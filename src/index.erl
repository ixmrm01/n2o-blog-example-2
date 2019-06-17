-module(index).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("records.hrl").

posts() ->
  [
    #panel{body=[
      #h2{body = #link{body = P#post.title, url = "/app/post.htm?id=" ++ nitro:to_list(P#post.id)}},
      #p{body = P#post.text}

    % ]} || P <- posts:get()
    ]} || P <- kvs:all(post)

  ].

buttons() ->
  case n2o:user() of
    [] ->
      #li{body=#link{body = "Login", url="/app/login.htm"}};
    _ ->
      [
        #p{class=["navbar-text"], body="Hello, " ++ n2o:user()},
        #li{body=#link{body = "New post", url="/app/new.htm"}},
        #li{body=#link{body = "Logout", postback=logout}}
      ]
  end.

header() ->
  #ul{id=header, class=["nav", "navbar-nav", "navbar-right"], body = buttons()}.

event(init) ->
  nitro:update(header, header()),
  nitro:update(posts, posts());

event(logout) ->
  n2o:user([]),
  nitro:update(header, header()).
