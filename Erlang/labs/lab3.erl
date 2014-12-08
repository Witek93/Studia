-module(lab3).
-export([test/0, initAgents/1, agent/0, search/1, waitForIt/0, initTree/0]).
-record(agents, {key, value, left = nil, center = nil, right = nil}).



initAgents([]) -> ok;
initAgents([H|T]) ->
  % init agent as a process
  Process = spawn(lab3, agent, []),
  Process ! {self(), [H]},
  % call initAgents recursively
  initAgents(T),
  % wait for end of agent processes
  waitForIt().



agent() ->
  receive
    {From, Value} ->
      From ! {good, search(Value)}
  end.


search(Value) ->
  %TODO szukanie
  Value.


waitForIt() ->
  receive
    {good, Value} -> io:format('Magic! ~p~n', [Value])
  end.


initTree() ->
  initAgents(['A', 'B', 'C', 'D', 'E', 'B', 'F', 'G', 'H', 'C']).
