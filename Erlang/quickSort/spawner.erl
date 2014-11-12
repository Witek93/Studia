-module(spawner).
-export([sortingProcess/0, spawnTwoProcesses/1]).


spawnTwoProcesses(Vec) ->
    {Smaller, Larger} = qsort:divide(Vec),
    Process1 = spawn(spawner, sortingProcess, []),
    Process2 = spawn(spawner, sortingProcess, []),
    Process1 ! {self(), Smaller},
    Process2 ! {self(), Larger},
    psw(),
    psw().


sortingProcess() ->
    receive
        {From, L} ->
            From ! {sorted_properly, qsort:sort(L)}
    end.


psw() ->
    receive
        {sorted_properly, VecSorted} -> VecSorted
    end.
