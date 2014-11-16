-module(allInOne).
-compile(export_all).




rand() -> rand(100000).
rand(Length) -> rand({1, Length}, Length).
rand({Min, Max}, Length) -> [random:uniform(Max-Min) + Min || _ <- lists:seq(1,Length)].


printVec([])    -> io:format("~n");
printVec([H|T]) -> io:format("~p ", [H]),
                   printVec(T).





divide([Pivot|Rest]) -> divide(Pivot,Rest,[],[]).
divide(_,[], Smaller, Larger) -> {Smaller, Larger};
divide(Pivot, [H|T], Smaller, Larger) ->
if H =< Pivot -> divide(Pivot, T, [H|Smaller], Larger);
   H >  Pivot -> divide(Pivot, T, Smaller,     [H|Larger])
end.


sort([]) -> [];
sort([Pivot|Rest]) ->
    {Smaller, Larger} = divide([Pivot|Rest]),
    sort(Smaller) ++ [Pivot] ++ sort(Larger).





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





test(N) -> test(N, 500000).
test(N, _) when N < 0 -> {error, "Liczba testow nie moze byc ujemna!"};
test(N, VectorLength) -> test(N, VectorLength, 0, 0).
test(0, _, Trues, Falses) ->
    io:format("W ~p podejsciach sortowanie wspolbiezne bylo szybsze ~p razy.~n", [(Trues+Falses), Trues]),
    io:format("z kolei sortowanie na jednym procesie bylo szybsze   ~p razy.~n", [Falses]);
test(N, VectorLength, Trues, Falses) ->
    case compare(VectorLength) of
        true  -> test(N-1, VectorLength, Trues+1, Falses);
        false -> test(N-1, VectorLength, Trues,   Falses+1)
    end.


compare(VectorLength) ->
    Vec = vec:rand(VectorLength),
    {Micros, _} = timer:tc(fun qsort:sort/1, [Vec]),
    {Micros2, _} = timer:tc(fun spawner:spawnTwoProcesses/1, [Vec]),
    Micros > Micros2.


printComparison(VectorLength) ->
    Vec = vec:rand(VectorLength),
    {Micros, _} = timer:tc(fun qsort:sort/1, [Vec]),
    io:format("Czas sortowania na jednym procesie: ~p[ms]~n", [Micros/1000]),
    {Micros2, _} = timer:tc(fun spawner:spawnTwoProcesses/1, [Vec]),
    io:format("Czas sortowania wspolbieznego:      ~p[ms]~n", [Micros2/1000]).
