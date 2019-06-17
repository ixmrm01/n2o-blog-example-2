-module(new).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("records.hrl").

event(init) ->
  case n2o:user() of
    [] ->
      % nitro:header(<<"Location">>, nitro:to_binary("/app/login.htm")),
      nitro:state(status,302),
      [];
    _ ->
      nitro:update(button, #button{id=send, class=["btn", "btn-primary"], body="Add post",postback=post,source=[title,text]})
  end;

event(post) ->
  Id = kvs:next_id("post",1),

  % Post = #post{id=Id,author=n2o:user(),title=nitro:q(title),text=nitro:q(text)},
  Post = #post{id=Id,author=n2o:user(),feed_id=main, title=nitro:q(title),text=nitro:q(text)},

  %kvs:put(Post),
  kvs:add(Post),

  nitro:redirect("/app/post.htm?id=" ++ nitro:to_list(Id)).
