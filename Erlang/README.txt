Zadanie na 16.11~:

qsort (tak jak w Adzie) na zadaniach (spawn - funkcje fp/fm z lab2.erl)




scal(L1,L2) -> scal(L1, L2, []);
scal([H1|T1], [H2|T2], L) when H1 >  H2 -> scal([H1]++T1, T2, L++[H2]);
scal([H1|T1], [H2|T2], L) when H1 =< H2 -> scal(T1, [H2]++T2, L++[H1]);


dzielna(L) -> dzielna(L, [], [], true);
dzielna([H|T], L1, L2, true)  -> dzielna(T, [H]++L1, L2, false);
dzielna([H|T], L1, L2, false) -> dzielna(...);


psort() ->
receive
  {Od, L} ->
    Od ! {w, sortbb(L)},
    after 1000 -> timeout_ps
end.

sortw(L) ->
% spawn(NAZWA_PLIKU, nazwa_funkcji, poczatkowa_wartosc_L1lubL2) %
P1 = spawn(msort, psort, []),
P2 = spawn(msort, psort, []),
[L1, L2] = dzielna(L),
P1 !{self(), L1},
P2 !{self(), L2}.



L = [random:uniform(5000)+100 || _ <- lists:seq(1,2000)],
io:format("Liczba elementow = ~p ~n", [len(L)]),

TS1 = calendar:local_time(),
TS1f = calendar:time_to_seconds(TS1).
