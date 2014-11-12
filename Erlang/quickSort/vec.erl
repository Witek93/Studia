-module(vec).
-export([rand/2, rand/1, rand/0, print/1]).


rand() -> rand(100000).
rand(Length) -> rand({1, Length}, Length).
rand({Min, Max}, Length) -> [random:uniform(Max-Min) + Min || _ <- lists:seq(1,Length)].


print([])    -> io:format("~n");
print([H|T]) -> io:format("~p ", [H]),
                print(T).
