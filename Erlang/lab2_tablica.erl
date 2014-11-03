-module(lab2_tablica).
-export([fp/0, fm/0]).


% komunikacja między procesami

% odbiera wiadomosci
fp() ->
  receive
    {From, agh} -> From ! {agh, ok}
  end.


% wysyla wiadomosci do konkretnego procesu
fm() ->
  MPid = spawn(lab2_tablica, fp, []),
  MPid ! {self(), agh}.
