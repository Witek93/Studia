with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Calendar;             use Ada.Calendar;
with Ada.Calendar.Formatting;  use Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones;  use Ada.Calendar.Time_Zones;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;


procedure Ada_log is
  Plik          : File_Type;
  Nazwa_Pliku   : String(1..100) := (others => ' ');
  Dlugosc_Pliku : Integer := 0;

  procedure Log (Msg : String) is
    Plik      : File_Type;
    Nazwa_Log : String           := "LOG.txt";
    DateStr   : Unbounded_String := To_Unbounded_String(Image(Clock, True));
  begin
    begin
      Open (Plik, Mode => Append_File, Name => Nazwa_Log);
      exception
        when Name_Error => Create (Plik, Mode => Out_File, Name => Nazwa_Log);
      end;
    Put_Line(Plik, (DateStr & " -> " & Msg));
    Close(Plik);
  end;


begin
Wczytaj_loop:
    loop
    Put_Line("Podaj nazwe pliku do otwarcia lub wcisnij <ENTER>, aby zakonczyc");
    Get_Line(Nazwa_Pliku, Dlugosc_Pliku);
      begin
        exit Wczytaj_loop when Nazwa_Pliku = "";
        Open(Plik, In_File,Nazwa_Pliku(1..Dlugosc_Pliku));
      exception
        when Name_Error =>
          Log("Bledna nazwa pliku <" & Nazwa_Pliku(1..Dlugosc_Pliku) & "> !");
      end;
    end loop Wczytaj_loop;


end Ada_log;
