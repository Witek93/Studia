-module(tests).
-export([test/1, test/2, printComparison/1]).


test(N) -> test(N, 500000).
test(N, _) when N < 0 -> {error, "Liczba testow nie moze byc ujemna!"};
test(N, VectorLength)            -> test(N, VectorLength, 0, 0).
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
