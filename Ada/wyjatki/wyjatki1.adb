with Ada.Text_IO;
use  Ada.Text_IO;

procedure Wyjatki1 is
  Pl      : File_Type;
  Nazwa   : String(1..100) := (others => ' ');
  Pusty   : String(1..100) := (others => ' ');
  Dlugosc : Integer := 0;

begin
Exit_loop:
  loop
  Put_Line("Podaj nazwe pliku do otwarcia.");
  Put_Line("Aby zakonczyc wcisnij ESC");
  Get_Line(Nazwa, Dlugosc);
    begin
      exit Exit_loop when Nazwa = Pusty;
      Open(Pl, In_File,Nazwa(1..Dlugosc));
    exception
      when Name_Error => Put_Line("Bledna nazwa pliku <" & Nazwa(1..Dlugosc) & "> !");
    end;
    Nazwa := (others => ' ');
  end loop Exit_loop;


  Put_Line("Otwieram plik: " & Nazwa(1..Dlugosc));

  while not (End_Of_File(Pl)) loop
    Put_Line(Get_Line(Pl));
  end loop;

  Put_Line("Zamykam plik");
  Close(Pl);
end Wyjatki1;
