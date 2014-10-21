with Ada.Text_IO;
use  Ada.Text_IO;

procedure prog is

  --specyfikacja zadania
  task T_T1;

  --ciało zadania
  task body T_T1 is
  begin
    for i in 'A' .. 'Z' loop
      put(i'Img);
    end loop;
  end T_T1;

begin
  return;
end prog;
