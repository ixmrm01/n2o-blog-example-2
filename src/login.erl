-module(login).
-compile(export_all).
-include_lib("kvs/include/feed.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").

event(init) ->
  nitro:update(loginButton,
    #button{id=loginButton,body="Login",postback=login,source=[user,pass]});

event(login) ->
  User = nitro:to_list(nitro:q(user)),
  n2o:user(User),
  nitro:redirect("/app/index.htm"),
  ok;

event(_) ->
  [].
