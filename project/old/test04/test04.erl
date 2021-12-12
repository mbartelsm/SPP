-module(test04).
-export([init/1]).

%% Start with a list of processes and a number

init(Setup) ->
    io:fwrite("~w is starting~n", [self()]),
    process_flag(trap_exit, true),
    init_all(Setup, []).


init_all([], Pids) ->
    loop(Pids);


init_all([{Name, Count}|Procs], Pids) ->
    Self = self(),
    Pid = spawn_link(fun() -> countdown(Name, Count, Self) end),
    init_all(Procs, [Pid|Pids]).


loop([]) -> done;

loop(Children) -> 
    receive
        {'EXIT', Pid, {negative_count, Name}} ->
            Self = self(),
            NewPid = spawn_link(fun() -> countdown(Name, 0, Self) end),
            loop([NewPid|lists:delete(Pid, Children)]);

        {Child, _Name, done} ->
            loop(lists:delete(Child, Children));

        {Child, Name, 0} ->
            io:fwrite("~w is done~n", [Name]),
            Child ! {self(), die},
            loop(Children);

        {_Child, Name, Count} when is_number(Count) ->
            io:fwrite("~w@~w~n", [Name, Count]),
            loop(Children)

    after 5000 -> timeout
    end.


countdown(Name, 0, Parent) ->
    Parent ! {self(), Name, 0},
    await_death(Name, Parent);

countdown(Name, Count, _Parent) when Count < 0 ->
    exit({negative_count, Name});

countdown(Name, Count, Parent) -> 
    Parent ! {self(), Name, Count},
    countdown(Name, Count - 1, Parent).


await_death(Name, Parent) ->
    receive
        {Parent, die} -> Parent ! {self(), Name, done}
    end.
