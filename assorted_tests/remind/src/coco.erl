-module(coco).
-include("../include/msg.hrl").
-export([
    exchange/2,
    exchange/3,
    inform/2,
    inform/3,
    inform_all/2,
    inform_all/3
]).

exchange(Recipient, Msg, Args) ->
    exchange(Recipient, {Msg, Args}).

exchange(Recipient, Msg) ->
    Ref = make_ref(),
    Recipient ! #msg{sender=self(), reference=Ref, payload=Msg},
    receive_or_timeout(Ref, 5000).


inform(Recipient, Msg, Args) ->
    inform(Recipient, {Msg, Args}).

inform(Recipient, Msg) ->
    Recipient ! #msg{sender=self(), payload=Msg}.


inform_all(Recipients, Msg, Args) ->
    inform_all(Recipients, {Msg, Args}).


inform_all([R], Msg) -> 
    inform(R, Msg);

inform_all([R|Recipients], Msg) ->
    inform(R, Msg),
    inform_all(Recipients, Msg).


receive_or_timeout(Ref, Timeout) ->
    receive

        #msg{
            reference=Ref,
            payload=Response
        } -> Response

    after Timeout ->
        {error, timeout}
    end.
