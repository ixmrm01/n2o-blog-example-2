-module(post).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("records.hrl").

post_id() ->
  try binary_to_integer(nitro:qc(id)) catch _:_ -> 0 end.

comments() ->
  case n2o:user() of
    [] ->
      #link{body = "Login to add comment", url="/app/login.htm"};
    _ ->
      [
        #textarea{id=comment, class=["form-control"], rows=3},
        #button{id=send, class=["btn", "btn-default"], body="Post comment",postback=comment,source=[comment]}
      ]
  end.

event(init) ->
  % Id = try binary_to_integer(nitro:qc(id)) catch _:_ -> 0 end,
  Id = post_id(),

  n2o:reg({post, Id}),

  % [event({client,Comment}) || Comment <- kvs:entries(kvs:get(post, Id),postcomment,undefined) ],
  [event({client,Comment}) || Comment <- kvs:entries(kvs:get(feed, {post, Id}),postcomment,undefined) ],

  %Post = posts:get(Id),
  case kvs:get(post, Id) of
    {ok, Post} ->
      nitro:update(header, Post#post.title),
      nitro:update(author, Post#post.author),
      nitro:update(text, #p{id=text, body=nitro:js_escape(Post#post.text)}),
      nitro:update(comment, comments());
    _ ->
      nitro:state(status,404),
      "Post not found"
  end;

event(comment) ->
  % nitro:insert_bottom(comments, #blockquote{body = #p{body = nitro:q(comment)}}).

  Id = post_id(),

  % Comment = #postcomment{id=kvs:next_id("postcomment",1),author=n2o:user(),feed_id=Id,text=nitro:q(comment)},
  Comment = #postcomment{id=kvs:next_id("postcomment",1),author=n2o:user(),feed_id={post, Id},text=nitro:q(comment)},

  kvs:add(Comment),

  % n2o:send({post, Id}, {client, nitro:q(comment)});
  n2o:send({post, Id}, {client, Comment});

% event({client, Text}) ->
event({client, Comment}) ->
  nitro:insert_bottom(comments,
    #blockquote{body = [

      % #p{body = Text}
      #p{body = Comment#postcomment.text},

      #footer{body = Comment#postcomment.author}
    ]}
  ).
