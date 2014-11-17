with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use  Ada.Text_IO;


procedure Cyclic_Buffer is

   type TBuf is array (Integer range <>) of Integer;
   Rozmiar : Integer := 10;

   subtype Wait is Integer range 0..10;

   package Draw is new Ada.Numerics.Discrete_Random(Wait);
   use Draw;
   G : Generator;

   protected Protected_Buffer is
      entry Wstaw(I : in Integer);
      entry Pobierz(I : out Integer);
   private
      B           : TBuf(1..Rozmiar);
      ElemCount   : Integer:=0;
      ElemWstaw   : Integer:=1;
      ElemPobierz : Integer:=1;
   end Protected_Buffer;

   task Producent;
   task Konsument;

   protected body Protected_Buffer is

      entry Wstaw(I : in Integer) when ElemCount < Rozmiar is
      begin
         B(ElemPobierz) := I;
         ElemPobierz    := ElemPobierz mod Rozmiar + 1;
         ElemCount      := ElemCount + 1;
       end Wstaw;

      entry Pobierz(I : out Integer) when ElemCount > 0 is
      begin
         I         := B(ElemWstaw);
         ElemWstaw := ElemWstaw mod Rozmiar + 1;
         ElemCount := ElemCount - 1;
       end Pobierz;

   end Protected_Buffer; --koniec: protected body Protected_Buffer



task body Konsument is
   Opoznienie_Konsumenta : Integer;
begin
   loop
      Reset(G);
      Opoznienie_Konsumenta := Integer(Random(G));
      delay Duration(0.3 * Float(Opoznienie_Konsumenta));
      Protected_Buffer.Pobierz(Opoznienie_Konsumenta);
      Put_Line("Konsument pobiera: " &Opoznienie_Konsumenta'Img);
      delay 0.15;
    end loop;
end Konsument;

task body Producent is
   Opoznienie_Producenta : Integer;
begin
   loop
      Reset(G);
      Opoznienie_Producenta := Integer(Random(G));
      delay Duration(Opoznienie_Producenta);
      Protected_Buffer.Wstaw(Opoznienie_Producenta);
      Put_Line("Producent tworzy:  " &Opoznienie_Producenta'Img);
      delay 0.15;
   end loop;
end Producent;

begin
   null;
end Cyclic_Buffer;
