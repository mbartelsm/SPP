-module(fold_test).
-export([
    anonymous_l/0,
    anonymous_r/0,
    callback_l/0,
    callback_r/0,
    double2/1,
    exported_callback_l/0,
    exported_callback_r/0
]).

% - - - - - - - - - - - - - - - - - - - -

anonymous_l() ->
    Res = lists:foldl(
        fun(Elem, Sum) -> Elem + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.

anonymous_r() ->
    Res = lists:foldr(
        fun(Elem, Sum) -> Elem + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.

% - - - - - - - - - - - - - - - - - - - -

double(X) -> 2 * X.

callback_l() -> 
    Res = lists:foldl(
        fun(Elem, Sum) -> double(Elem) + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.

callback_r() -> 
    Res = lists:foldr(
        fun(Elem, Sum) -> double(Elem) + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.

% - - - - - - - - - - - - - - - - - - - -

double2(X) -> 2 * X.

exported_callback_l() -> 
    Res = lists:foldl(
        fun(Elem, Sum) -> double2(Elem) + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.

exported_callback_r() -> 
    Res = lists:foldr(
        fun(Elem, Sum) -> double2(Elem) + Sum end,
        0,
        [1,2,3,4,5,6,7,8,9,10]
    ),
    Res.
