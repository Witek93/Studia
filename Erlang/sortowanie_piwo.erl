scal(L1,L2) -> scal(L1, L2, []);
scal([H1|T1], [H2|T2], L) when H1 >  H2 -> scal([H1]++T1, T2, L++[H2]);
scal([H1|T1], [H2|T2], L) when H1 =< H2 -> scal(T1, [H2]++T2, L++[H1]);
scal([],L2,L)-> L++L2;
scal(L1,[],L)-> L++L1;
scal([],[],L)->L.

dzielna2(L) -> dzielna2(L, [], [], true);
dzielna2([H|T], L1, L2, true)  -> dzielna2(T, [H]++L1, L2, false);
dzielna2([H|T], L1, L2, false) -> dzielna2(...); % prawdopodobnie ... = (T, L1, [H]++L2, false) %


psort() ->
receive
  {Od, L} ->
    Od ! {w, sortbb(L)},
    after 1000 -> timeout_ps
end.


psw()-> receive
  {w,L0}->L0
  after 50000 ->timeout_psw
  end.


sortw(L) ->
% spawn(NAZWA_PLIKU, nazwa_funkcji, poczatkowa_wartosc_L1lubL2) %
P1 = spawn(sortowanie_piwo, psort, []),
P2 = spawn(sortowanie_piwo, psort, []),
[L1, L2] = dzielna2(L),
P1 !{self(), L1},
P2 !{self(), L2}.
