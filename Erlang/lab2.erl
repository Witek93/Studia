-module(lab2).
-export([bubble/1, fp/0, fm/0]).


bubble([E1,E2]) ->
  case E1 > E2 of
    true -> [E1,E2];
    _    -> [E2,E1]
  end.



% komunikacja między procesami
fp() ->
  receive
    {From, agh} -> From ! {agh, ok}
  end.

fm() ->
  MPid = spawn(lab2, fp, []),
  MPid ! {self(), agh}.


getRandomIntegerLost({Min, Max}, )
