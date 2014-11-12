-module(qsort).
-export([sort/1, processSort/0, test/1, printComparison/0]).


test(N) when N < 0 -> {error};
test(N)            -> test(N, 0, 0).
test(0, Trues, Falses) -> io:format("Trues: ~p, falses: ~p~n", [Trues, Falses]);
test(N, Trues, Falses) ->
    case compare() of
        true  -> test(N-1, Trues+1, Falses);
        false -> test(N-1, Trues,   Falses+1)
    end.


compare() ->
    Vec = vec:rand({1,1000},200000),
    {Micros, _} = timer:tc(fun sort/1, [Vec]),
    {Micros2, _} = timer:tc(fun spawn2processes/1, [Vec]),
    Micros > Micros2.


printComparison() ->
    Vec = vec:rand({1,1000},200000),
    {Micros, _} = timer:tc(fun sort/1, [Vec]),
    io:format("Czas sortowania na jednym procesie: ~p[ms]~n", [Micros/1000]),
    {Micros2, _} = timer:tc(fun spawn2processes/1, [Vec]),
    io:format("Czas sortowania wspolbieznego:      ~p[ms]~n", [Micros2/1000]).


spawn2processes(Vec) ->
    {Smaller, Larger} = divide(Vec),
    Process1 = spawn(qsort, processSort, []),
    Process2 = spawn(qsort, processSort, []),
    Process1 ! {self(), Smaller},
    Process2 ! {self(), Larger},
    psw(),
    psw().



divide([Pivot|Rest]) -> divide(Pivot,Rest,[],[]).

divide(_,[], Smaller, Larger) -> {Smaller, Larger};
divide(Pivot, [H|T], Smaller, Larger) ->
if H =< Pivot -> divide(Pivot, T, [H|Smaller], Larger);
   H >  Pivot -> divide(Pivot, T, Smaller,     [H|Larger])
end.


sort([]) -> [];
sort([Pivot|Rest]) ->
    {Smaller, Larger} = divide(Pivot,Rest,[],[]),
    sort(Smaller) ++ [Pivot] ++ sort(Larger).


processSort() ->
    receive
        {From, L} ->
            From ! {sorted_properly, sort(L)}
    end.


psw()->
    receive
        {sorted_properly, VecSorted} -> VecSorted
    end.
