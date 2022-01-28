-module(server).
-include("../include/msg.hrl").
-compile(export_all).

server_loop(State = { Events, Clients }) ->
    receive
        %% Alert
        #msg{
            sender=Event,
            reference=_Ref,
            payload={ alert, Name }
        } -> 
        coco:inform_all(Clients, alert, Name),
        server_loop({
            filter(
                fun
                    ({_, Event}) -> true;
                    (_) -> false
                end,
                Events
            ),
            Clients 
        });

        %% Subscribe
        #msg{
            sender=Client,
            reference=Ref,
            payload={ subscribe, subscriber }
        } -> 
        Client ! #msg{
            sender=self(),
            reference=Ref,
            payload=subscribed
        },
        coco:inform(Client, subscribed),
        server_loop({ Events, [Client|Clients] });
        
        %% Schedule
        #msg{
            sender=Client,
            reference=Ref,
            payload={ schedule, {Name, Timeout} }
        } -> 
            Event = event:start(Name, Timeout),
            server_loop({ [Event|Events], Clients });

        %% Cancel
        #msg{
            sender=Client,
            reference=Ref,
            payload={ cancel, Name }
        } ->
            case lists:keyfind(Name, 1) of
                {Name, Event} -> coco:exchange(Event, cancel)
                false -> 
                    Client ! #msg{
                        sender=self(),
                        reference=Ref,
                        payload={ not_found, Name }
                    }
            end
            server_loop(State);

        %% Shutdown
        #msg{
            sender=Client,
            reference=Ref,
            payload=shutdown
        } -> [];

        %% Unexpected
        #msg{
            sender=Sender,
            reference=Ref,
            payload=Else
        } -> server_loop(State)
    end.
