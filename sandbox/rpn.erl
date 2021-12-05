-module(rpn).
-export([eval/1]).

eval(String) -> 
    [Res] = lists:foldl(fun rpn/2, [], string:tokens(String, " ")),
    Res.

rpn("+", [A,B|Acc]) when is_number(A) and is_number(B)  -> [B+A|Acc];
rpn("-", [A,B|Acc]) when is_number(A) and is_number(B)  -> [B-A|Acc];
rpn("*", [A,B|Acc]) when is_number(A) and is_number(B)  -> [B*A|Acc];
rpn("/", [A,B|Acc]) when is_number(A) and is_number(B)  -> [B/A|Acc];
rpn("^", [A,B|Acc]) when is_number(A) and is_number(B)  -> [math:pow(B,A)|Acc];
rpn("ln", [A|Acc]) when is_number(A)                    -> [math:log(A)|Acc];
rpn("log", [A|Acc]) when is_number(A)                   -> [math:log(A)|Acc];
rpn("lg", [A|Acc]) when is_number(A)                    -> [math:log10(A)|Acc];
rpn("log10", [A|Acc]) when is_number(A)                 -> [math:log10(A)|Acc];
rpn(N, Acc)                                             -> [read_num(N)|Acc].

read_num(N) ->
    try
        N = string:to_float(N)
    case string:to_float(N) of
        {error, no_float} -> list_to_integer(N);
        {F,_} -> {error, F}
    end.
