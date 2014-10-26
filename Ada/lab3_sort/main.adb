with Vec;

procedure main is
    N : Integer := 20;
    V : Vec.Wektor(1..N);

begin
    Vec.randomize(V, 10.0, 15.0);
    Vec.print(V, "Początkowy: ");

    Vec.sort(V);
    Vec.print(V, "Po sortowaniu: ");
end main;
