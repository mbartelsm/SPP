-module(event).
-include("../include/msg.hrl").
-export([start/2, start_link/2, cancel/1, init/1]).

-import(coco, [exchange/2, exchange/3, inform/2, inform/3]).


start(Name, Delay) ->
    spawn(?MODULE, init, [{self(), Name, Delay}]).


start_link(Name, Delay) ->
    spawn_link(?MODULE, init, [{self(), Name, Delay}]).


init({Server, Name, Timeout}) ->
    alert_loop({Server, Name, normalize(Timeout)}).


normalize(T) ->
    Limit = 49*24*60*60,
    [T rem Limit | lists:duplicate(T div Limit, Limit)].


alert_loop(_State = {Server, Name, [Timeout|Timeouts]}) ->
    receive

        %% Cancel
        #msg{
            sender=Server,
            reference=Ref,
            payload=cancel
        } -> Server ! #msg{
            sender=self(),
            reference=Ref,
            payload={ok, cancel}
        };

        %% Unexpected
        #msg{
            sender=Sender,
            reference=Ref,
            payload=Else
        } -> Sender ! #msg{
            sender=self(),
            reference=Ref,
            payload={unexpected_msg, Else}
        }

    after Timeout * 1000 ->
        if
            Timeouts =:= [] -> Server ! #msg{sender=self(),payload={alert, Name}};
            Timeouts =/= [] -> alert_loop({Server, Name, Timeouts})
        end
    end.


cancel(Event) ->
    Ref = monitor(process, Event),
    Event ! #msg{sender=self(), reference=Ref, payload=cancel},
    receive
        #msg{
            sender=Event,
            reference=Ref,
            payload=cancel
        } -> 
            demonitor(Ref, [flush]),
            cancelled;
        
        {'DOWN', Ref, process, Event, _Reason} -> cancelled
    after 5000 ->
        exit(Event, kill),
        demonitor(Ref, [flush])
    end.


