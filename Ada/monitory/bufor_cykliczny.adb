with Ada.Text_IO;
use  Ada.Text_IO;

procedure bufor_cykliczny is

  type TBuf is array(Integer range <>) of Character;
  BuforSize    : Integer := 5;
  Pobrany_znak : Character;

  protected Bufor is


    entry Wstaw  (Ch : in Character);
    entry Pobierz(Ch : out Character);

    private
      Buffer        : TBuf(1..BuforSize);
      ElementsCount : Integer := 0;
      GetPos        : Integer := 1;
      PutPos        : Integer := 1;

  end Bufor;


  protected body Bufor is
    entry Wstaw(Ch : in Character) when BuforSize < ElementsCount is
    begin
      Buffer(PutPos) := Ch;
      PutPos         := PutPos mod BuforSize + 1;
      ElementsCount  := ElementsCount + 1;
      put("Wstawiono " &Ch);
    end Wstaw;

    entry Pobierz(Ch : out Character) when ElementsCount > 0 is
    begin
      Ch            := Buffer(GetPos);
      GetPos        := GetPos mod BuforSize + 1;
      ElementsCount := ElementsCount - 1;
      put("Pobrano " &Ch);
    end Pobierz;

  end Bufor;


begin
  Bufor.Pobierz(Pobrany_znak);
  put("Pobrany znak: " &Pobrany_znak);
end bufor_cykliczny;
