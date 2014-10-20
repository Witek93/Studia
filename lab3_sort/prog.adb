with Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random;
use  Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random;

procedure prog is

  --definicja typu wektorowego o dowolnym rozmiarze
  --dzięki <> możemy określić rozmiar typu na pozniejszym etapie
  type Wektor is array(Integer range <>) of Float;

  R  : constant Integer := 20;
  W1 : Wektor (1..R);

task type TSor is
  entry Start(W: Wektor);
  entry Koniec(W: out Wektor);
end TSor;

task body Tsor is
  WL: Wektor(1..Rozmiar);
begin
  accept Start(W: Wektor) do
  WL := W;
  end Start;

  Sortuj_BB(WL);

  accept Koniec(W: out Wektor) do
  W : WL;
  end Koniec;
end TSor;

type WTSor is access TSor;
WS1, WS2, WTSor;

  procedure losuj_wektor (W : in out Wektor) is
  Gen : Generator;
  begin
    reset(Gen);
    for E of W loop
      E := Random(Gen) * 10.0;
    end loop;
  end losuj_wektor;

  procedure put_wektor (W: in Wektor; Comment: String) is
  begin
    put_line(Comment);
    for E of W loop
      put(E,3,4,0);
    end loop;
    put_line("");
  end put_wektor;

  procedure sortuj_wektor (W: in out Wektor) is
    tmp : Float;
  begin
    for I in W'Range loop
      for J in W'First..(W'Last - 1) loop
        if(W(J) > W(J+1)) then
          tmp    := W(J);
          W(J)   := W(J+1);
          W(J+1) := tmp;
        end if;
        end loop;
      end loop;
  end sortuj_wektor;

begin
  losuj_wektor(W1);
  put_wektor(W1, "Przed sortowaniem:");
  sortuj_wektor(W1);
  put_wektor(W1, "Po sortowaniu:");
end prog;


-- W1 := (others => 5.0);
-- W1(2..4) := W1(5..7);
-- istnieja W1'Length, W1'Last, W1'First itp.
