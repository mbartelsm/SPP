-module(exit_proc).
-export([
    start/0
]).

start() ->
    exit_proc_self(),
    exit_proc_other(),
    exit_proc_monitor(),
    exit_proc_link(),
    ok.

exit_proc_self() ->
    exit(reason),
    ok.

exit_proc_other() ->
    spawn(fun() -> exit(reason), ok end),
    ok.

exit_proc_link() ->
    spawn_link(fun() -> exit(reason), ok end),
    ok.

exit_proc_monitor() ->
    spawn_monitor(fun() -> exit(reason), ok end),
    ok.
