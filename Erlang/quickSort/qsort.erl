-module(qsort).
-export([sort/1, divide/1]).


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
