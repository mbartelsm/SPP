# Testing cauder

| Test                  | Self          | Other         |
|---                    |---            |---            |
| Callback Fun          | Ok            | --            |
| Anonymous Fun         | Ok            | --            |
| Named Fun             | No load[^1]   | --            |
| Named Fun recursion   | No load[^1]   | --            |
| Fold                  | Not ok[^2]    | --            |
| Spawn                 | Ok            | --            |
| Link                  | Freeze[^3]    | --            |
| Monitor               | Freeze[^3]    | --            |
| spawn_link            | Crash[^4]     | --            |
| spawn_monitor         | Crash[^4]     | --            |
| Exit                  | Freeze[^3]    | Freeze[^3]    |
| Kill                  | Freeze[^3]    | Freeze[^3]    |
| Sleep                 | Ok            | Ok            |
| Message               | Ok            | Ok            |
| Receive               | Ok            | Ok            |
| Receive w/ timeout    | No load[^1]   | --            |


## Notes

[^1]: File is not loaded, no messages are shown by the UI. Error displayed by terminal is below.

[^2]: Produces erroneous output, crashes when inspecting value on Bindings panel. Details below

[^3]: Debugging UI becomes greyed out on exit call with status "Performing forward steps...". No error messages on terminal.

[^4]: Cauder crashes on process creation. If the debugger is not focused on the triggering process, it does not crash until that process is selected. Trapping exits does not change anything.


### Named Funs

```
[cauder_wx:659] Unhandled Info:
{dbg,
    {failure,load,function_clause,
        [{cauder_syntax,expr,
             [{named_fun,11,'Test',
                  [{clause,11,
                       [{var,11,'X'}],
                       [],
                       [{call,11,
                            {var,11,'Test'},
                            [{op,11,'-',{var,11,'X'},{integer,11,1}}]}]},
                   {clause,11,[{integer,11,0}],[],[{atom,11,ok}]}]}],
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_syntax.erl"},
              {line,234}]},
         {cauder_syntax,expr,1,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_syntax.erl"},
              {line,313}]},
         {cauder_syntax,exprs,1,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_syntax.erl"},
              {line,229}]},
         {cauder_syntax,clause,1,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_syntax.erl"},
              {line,46}]},
         {cauder_syntax,clauses,1,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_syntax.erl"},
              {line,34}]},
         {cauder_load,store_forms,3,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_load.erl"},
              {line,64}]},
         {cauder_load,store_module,1,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_load.erl"},
              {line,49}]},
         {timer,tc,3,[{file,"timer.erl"},{line,197}]}]}}
```

### Folds

Code:

```erlang
Res = lists:foldr(fun(Elem, Sum) -> Elem + Sum end, 0, [1,2,3])
```
Return value:

```
{[3,
        {[2,
          {[1, 0],
           {{fold_test, '-anonymous_l/0-fun-0-'},
            #{},
            [{clause,
              13,
              [{var, 13, 'Elem'}, {var, 13, 'Sum'}],
              [],
              [{op, 13, '+', [{var, 13, 'Elem'}, {var, 13, 'Sum'}]}]}]}}],
         {{fold_test, '-anonymous_l/0-fun-0-'},
          #{},
          [{clause,
            13,
            [{var, 13, 'Elem'}, {var, 13, 'Sum'}],
            [],
            [{op, 13, '+', [{var, 13, 'Elem'}, {var, 13, 'Sum'}]}]}]}}],
       {{fold_test, '-anonymous_l/0-fun-0-'},
        #{},
        [{clause,
          13,
          [{var, 13, 'Elem'}, {var, 13, 'Sum'}],
          [],
          [{op, 13, '+', [{var, 13, 'Elem'}, {var, 13, 'Sum'}]}]}]}}
```

Crash report:

```
=ERROR REPORT==== 12-Dec-2021::18:52:54.115276 ===
** wx object server {local,cauder_wx} terminating 
** Last message in was {wx,2611,
                           {wx_ref,316,wxListCtrl,[]},
                           [],
                           {wxList,command_list_item_activated,-1,-1,0,-1,
                                   {0,0}}}
** When Server state == {wx_state,
                         {wx_ref,35,wxFrame,[]},
                         {wx_ref,36,wxMenuBar,[]},
                         {wx_ref,75,wxPanel,[]},
                         {wx_ref,385,wxStatusBar,[]},
                         {config,true,true,true,true,true,true,relevant,
                          concurrent,process,true},
                         fold_test,122,undefined,
                         {sys,
                          {mailbox,#{},#{}},
                          #{0 =>
                             {proc,nonode@nohost,0,
                              [{tau,#{},
                                [{match,12,
                                  {var,12,'Res'},
                                  {value,12,
                                   {[3,
                                     {[2,
                                       {[1,0],
                                        {{fold_test,'-anonymous_l/0-fun-0-'},
                                         #{},
                                         [{clause,13,
                                           [{var,13,'Elem'},{var,13,'Sum'}],
                                           [],
                                           [{op,13,'+',
                                             [{var,13,'Elem'},
                                              {var,13,'Sum'}]}]}]}}],
                                      {{fold_test,'-anonymous_l/0-fun-0-'},
                                       #{},
                                       [{clause,13,
                                         [{var,13,'Elem'},{var,13,'Sum'}],
                                         [],
                                         [{op,13,'+',
                                           [{var,13,'Elem'},
                                            {var,13,'Sum'}]}]}]}}],
                                    {{fold_test,'-anonymous_l/0-fun-0-'},
                                     #{},
                                     [{clause,13,
                                       [{var,13,'Elem'},{var,13,'Sum'}],
                                       [],
                                       [{op,13,'+',
                                         [{var,13,'Elem'},
                                          {var,13,'Sum'}]}]}]}}}},
                                 {var,17,'Res'}],
                                [{{fold_test,anonymous_l,0},
                                  #{},
                                  [{var,7,k_1},
                                   {local_call,8,anonymous_r,[]},
                                   {value,9,ok}],
                                  {var,7,k_1}},
                                 {{fold_test,start,0},
                                  #{},
                                  [{var,6,k_0}],
                                  {var,6,k_0}}]},
                               {tau,#{},
                                [{match,12,
                                  {var,12,'Res'},
                                  {remote_call,12,lists,foldl,
                                   [{value,13,#Fun<cauder_eval.4.91499260>},
                                    {value,14,0},
                                    {value,15,[1,2,3]}]}},
                                 {var,17,'Res'}],
                                [{{fold_test,anonymous_l,0},
                                  #{},
                                  [{var,7,k_1},
                                   {local_call,8,anonymous_r,[]},
                                   {value,9,ok}],
                                  {var,7,k_1}},
                                 {{fold_test,start,0},
                                  #{},
                                  [{var,6,k_0}],
                                  {var,6,k_0}}]},
                               {tau,#{},
                                [{match,12,
                                  {var,12,'Res'},
                                  {remote_call,12,lists,foldl,
                                   [{make_fun,13,'-anonymous_l/0-fun-0-',
                                     [{clause,13,
                                       [{var,13,'Elem'},{var,13,'Sum'}],
                                       [],
                                       [{op,13,'+',
                                         [{var,13,'Elem'},{var,13,'Sum'}]}]}]},
                                    {value,14,0},
                                    {value,15,[1,2,3]}]}},
                                 {var,17,'Res'}],
                                [{{fold_test,anonymous_l,0},
                                  #{},
                                  [{var,7,k_1},
                                   {local_call,8,anonymous_r,[]},
                                   {value,9,ok}],
                                  {var,7,k_1}},
                                 {{fold_test,start,0},
                                  #{},
                                  [{var,6,k_0}],
                                  {var,6,k_0}}]},
                               {tau,#{},
                                [{local_call,7,anonymous_l,[]},
                                 {local_call,8,anonymous_r,[]},
                                 {value,9,ok}],
                                [{{fold_test,start,0},
                                  #{},
                                  [{var,6,k_0}],
                                  {var,6,k_0}}]},
                               {tau,#{},
                                [{remote_call,6,fold_test,start,[]}],
                                []}],
                              [{{fold_test,anonymous_l,0},
                                #{},
                                [{var,7,k_1},
                                 {local_call,8,anonymous_r,[]},
                                 {value,9,ok}],
                                {var,7,k_1}},
                               {{fold_test,start,0},
                                #{},
                                [{var,6,k_0}],
                                {var,6,k_0}}],
                              #{'Res' =>
                                 {[3,
                                   {[2,
                                     {[1,0],
                                      {{fold_test,'-anonymous_l/0-fun-0-'},
                                       #{},
                                       [{clause,13,
                                         [{var,13,'Elem'},{var,13,'Sum'}],
                                         [],
                                         [{op,13,'+',
                                           [{var,13,'Elem'},
                                            {var,13,'Sum'}]}]}]}}],
                                    {{fold_test,'-anonymous_l/0-fun-0-'},
                                     #{},
                                     [{clause,13,
                                       [{var,13,'Elem'},{var,13,'Sum'}],
                                       [],
                                       [{op,13,'+',
                                         [{var,13,'Elem'},
                                          {var,13,'Sum'}]}]}]}}],
                                  {{fold_test,'-anonymous_l/0-fun-0-'},
                                   #{},
                                   [{clause,13,
                                     [{var,13,'Elem'},{var,13,'Sum'}],
                                     [],
                                     [{op,13,'+',
                                       [{var,13,'Elem'},{var,13,'Sum'}]}]}]}}},
                              [{value,12,
                                {[3,
                                  {[2,
                                    {[1,0],
                                     {{fold_test,'-anonymous_l/0-fun-0-'},
                                      #{},
                                      [{clause,13,
                                        [{var,13,'Elem'},{var,13,'Sum'}],
                                        [],
                                        [{op,13,'+',
                                          [{var,13,'Elem'},
                                           {var,13,'Sum'}]}]}]}}],
                                   {{fold_test,'-anonymous_l/0-fun-0-'},
                                    #{},
                                    [{clause,13,
                                      [{var,13,'Elem'},{var,13,'Sum'}],
                                      [],
                                      [{op,13,'+',
                                        [{var,13,'Elem'},
                                         {var,13,'Sum'}]}]}]}}],
                                 {{fold_test,'-anonymous_l/0-fun-0-'},
                                  #{},
                                  [{clause,13,
                                    [{var,13,'Elem'},{var,13,'Sum'}],
                                    [],
                                    [{op,13,'+',
                                      [{var,13,'Elem'},{var,13,'Sum'}]}]}]}}},
                               {var,17,'Res'}],
                              {fold_test,start,0}}},
                          #{},
                          [nonode@nohost],
                          [],[]},
                         0}
** Reason for termination == 
** {{badmap,{1,#{0 => 'Res'}}},
    [{erlang,map_get,[0,{1,#{0 => 'Res'}}],[]},
     {cauder_wx,handle_event,2,
                [{file,"/home/corso/RUG/SPP/cauder/src/cauder_wx.erl"},
                 {line,463}]},
     {wx_object,handle_msg,5,[{file,"wx_object.erl"},{line,500}]},
     {proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,226}]}]}

{"init terminating in do_boot",{{badmap,{1,#{0=>'Res'}}},[{erlang,map_get,[0,{1,#{0=>'Res'}}],[]},{cauder_wx,handle_event,2,[{file,"/home/corso/RUG/SPP/cauder/src/cauder_wx.erl"},{line,463}]},{wx_object,handle_msg,5,[{file,"wx_object.erl"},{line,500}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,226}]}]}}
init terminating in do_boot ({{badmap,{1,}},[{erlang,map_get,[0,{_}],[]},{cauder_wx,handle_event,2,[{_},{_}]},{wx_object,handle_msg,5,[{_},{_}]},{proc_lib,init_p_do_apply,3,[{_},{_}]}]})
```

### Link / Monitor

```
[cauder_wx:659] Unhandled Info:
{dbg,
    {failure,step_multiple,badarg,
        [{erlang,monitor,[process,1],[]},
         {cauder_eval,expr,3,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_eval.erl"},
              {line,184}]},
         {cauder_eval,seq,3,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder_eval.erl"},
              {line,78}]},
         {cauder_semantics_forwards,step,4,
             [{file,
                  "/home/corso/RUG/SPP/cauder/src/cauder_semantics_forwards.erl"},
              {line,39}]},
         {cauder,'-step_multiple/4-fun-1-',4,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder.erl"},{line,1139}]},
         {lists,foldl,3,[{file,"lists.erl"},{line,1267}]},
         {cauder,step_multiple,4,
             [{file,"/home/corso/RUG/SPP/cauder/src/cauder.erl"},{line,1145}]},
         {timer,tc,1,[{file,"timer.erl"},{line,166}]}]}}
```