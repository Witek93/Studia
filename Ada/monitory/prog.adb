with Ada.Text_IO, Ada.Float_Text_IO;
use  Ada.Text_IO, Ada.Float_Text_IO;


task Buf is
  entry Wstaw  (Ch : in  Character);
  entry Pobierz(Ch : out Character);
end Buf;

task body Buf is
  B     : Character;
  Pusty : Boolean := True;

begin
  loop select
    when Pusty => accept Wstaw  (Ch : in  Character) do
  begin
    B := Ch;
    Pusty := False;
  or when not Pusty => accept Pobierz(Ch : out Character) do
  begin
    Ch := B;
    Pusty := True;
  end;

end Buf;
