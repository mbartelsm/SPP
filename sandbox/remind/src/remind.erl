-module(remind).
-export(['^'/2]).

%% server ! {client, Ref, {subscribe, Who}}
%% client ! {server, Ref, ok}

%% server ! {client, Ref, {add, Name, Description, Timeout}}
%% client ! {server, Ref, ok} | {server, {error, Reason}}

%% server ! {client, Ref, {cancel, Name}}
%% client ! {server, Ref, ok} | {server, {error, Reason}}

%% client ! {server, Ref, {notify, Name, Description}}

%% server ! {client, Ref, shutdown}
%% client ! {server, Ref, {'DOWN', Ref, Process, Pid, shutown}}

%% server ! {Event,  Ref, {done, Id}}

%% Event  ! {server, Ref, cancel}
%% server ! {Event,  Ref, ok}
