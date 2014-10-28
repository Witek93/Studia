with Vec;

procedure main is
    N    : Integer := 20;
    V, V2 : Vec.Wektor(1..N);

begin
    Vec.randomize(V, 10.0, 15.0);
    V2 := Vec.sort(V);
    
    Vec.print(V, "Początkowy: ");
    Vec.print(V2, "Po sortowaniu: ");
end main;
