-module(func_test).
-export([
      anonymous_0/0
    , anonymous_1/0
%   , anonymous_rec/0
%   , named_0/0
%   , named_1/0
]).

anonymous_0() ->
    Func = fun() -> test end,
    Func().

anonymous_1() ->
    Func = fun(X) -> X end,
    Func(test).

% anonymous_rec() ->
%     Func = fun Rec(X) -> Rec(X - 1); Rec(0) -> test end,
%     Func(3).
% 
% test_0() -> test.
% 
% test_1(X) -> X.
% 
% run_0(Func) -> Func().
% 
% run_1(Func, Arg) -> Func(Arg).
% 
% named_0() -> run_0(fun test_0/0).
% 
% named_1() -> run_1(fun test_1/1, test).
