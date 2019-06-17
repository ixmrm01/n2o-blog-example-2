-include_lib("kvs/include/kvs.hrl").

-record(feed, {?CONTAINER}).

% -record(post, {id, title, text, author}).
% -record(post, {?CONTAINER, title, text, author}).
-record(post, {?ITERATOR(feed), title, text, author}).

% -record(postcomment, {?ITERATOR(post), text, author}).
-record(postcomment, {?ITERATOR(feed), text, author}).
