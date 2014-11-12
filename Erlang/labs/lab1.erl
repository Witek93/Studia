-module(lab1).
-export([area/1, len/1, list_max/1, list_min/1, min_max/1, min_max2/1, areas/1, desc_list/1, temperatura/2]).


area({rect,X,Y})      -> X*Y;
area({cir,X})         -> 3.14*X*X;

% zadanie 1
area({triangle,A,H})  -> 1/2 * A * H;
area({trapeze,A,B,H}) -> (A+B)/2 * H;

area({cube,A})        -> A*A*A;
area({cone,R,H})      -> 1/3 * 3.14 * R * R * H;
area({sphere,R})      -> 4/3 * 3.14 * R * R * R.


% zadanie 2
len([]) -> 0;
len([_|T]) -> 1 + len(T).


% zadanie 3
list_min([]) -> empty;
list_min([H|T]) -> list_min(H, T).

list_min(Min, [])                 -> Min;
list_min(Min, [H|T]) when Min > H -> list_min(H, T);
list_min(Min, [_|T])              -> list_min(Min, T).


% zadanie 4
list_max([]) -> empty;
list_max([H|T]) -> list_max(H, T).

list_max(X, [])               -> X;
list_max(X, [H|T]) when X < H -> list_max(H, T);
list_max(X, [_|T])            -> list_max(X, T).


% zadanie 5
min_max([]) -> empty;
min_max(List) -> {list_min(List), list_max(List)}.


% zadanie 6
min_max2([]) -> empty;
min_max2(List) -> [list_min(List)|[list_max(List)]].


% zadanie 7
areas([]) -> empty;
areas(List) -> areas(List, []).

areas([], Result) -> Result;
areas([H|T], Result) -> areas(T, [area(H)|Result]).


% zadanie 8
desc_list(N) when N < 1 -> empty;
desc_list(N)            -> desc_list(N, []).

desc_list(N, List) when N < 1 -> List;
desc_list(N, List) -> [N | desc_list(N-1, List)].


% zadanie 9
temperatura({c, T}, f) -> {f, T * 1.8 + 32};
temperatura({c, T}, k) -> {k, T + 273};

temperatura({f, T}, c) -> {c, 5 * (T - 32) / 9};
temperatura({f, T}, k) -> {k, (T + 459) * 5/9};

temperatura({k, T}, c) -> {c, T - 273};
temperatura({k, T}, f) -> {f, T * 1.8 - 459};

temperatura({X, _}, Y) -> {cannot, convert, X, to, Y}.
