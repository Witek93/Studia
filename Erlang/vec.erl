-module(vec).
-export([rand/2, print/1]).

rand({Min, Max}, Length) -> [random:uniform(Max-Min) + Min || _ <- lists:seq(1,Length)].

print([])    -> io:format("~n");
print([H|T]) -> io:format("~p ", [H]),
                print(T).
