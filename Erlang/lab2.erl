-module(lab2).
-export([bubble/1, randIntList/2, qsort/1]).


bubble([E1,E2]) ->
  case E1 > E2 of
    true -> [E1,E2];
    _    -> [E2,E1]
  end.



% Sortowanie 20 liczb z zakresu od 1 do 100:
% usage: lab2:qsort(lab2:randIntList({1,100}, 20)).
randIntList({Min, Max}, Count) ->
  case Min < Max of
    true -> randIntList@({Min, Max}, Count);
    _    -> {error, io:format("Min nie może być większy od Max!")} % do poprawy
  end.

randIntList@({Min, Max}, Count) -> [random:uniform(Max-Min) + Min || _ <- lists:seq(1,Count)].

qsort([]) -> [];
qsort([H|T]) ->
  {Smaller, Larger} = partition(H, T, [], []),
  qsort(Smaller) ++ [H] ++ qsort(Larger).


partition(_, [], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
  if H <  Pivot -> partition(Pivot, T, [H|Smaller], Larger);
     H >= Pivot -> partition(Pivot, T, Smaller, [H|Larger])
  end.
