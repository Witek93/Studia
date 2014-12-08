-- asearch_pak.adb
-- (C) JP

with Ada.Text_IO;
use  Ada.Text_IO;



package body ASearch_Pak is

protected Log_Monit is
 procedure Log(Msg: String);
 procedure Put_Res(Msg: String);
end Log_Monit;




protected body Log_Monit is


 procedure Log(Msg: String) is
 begin
   Put_Line(Msg);
 end Log;
 procedure Put_Res(Msg: String) is
 begin
   Put_Line(Msg);
 end Put_Res;
end Log_Monit;


procedure Log(Msg: String) is
 Is_Log : constant Boolean := True; -- True;
begin
  if Is_Log then Log_Monit.Log(Msg);
  end if;
end Log;


procedure Put_Res(Msg: String) is
 begin
  Log_Monit.Put_Res(Msg);
end Put_Res;


task body Main is
  End_Count: Integer := 0;
begin
  Log("--- Main start ok");
  loop
	select
	  accept  Found(Id: Integer; My_Elem: Character) do
	    Put_Res("@@@ Agent (" & Id'Img &") => [" & My_Elem & "]");
	  end  Found;
	or
	  accept Task_End(Id: Integer) do
		End_Count := End_Count + 1;
	  end Task_End;
	  exit when  End_Count = Num_Agents;
	or
	  accept Finish;
  	  exit;
    end select;
  end loop;
  Log("--- Main end ok");
exception
  when others => Log("*** Task Main dead!");
end Main;


task body Agent is

  My_Id : Integer := 0;
  My_Elem, Search_Elem: Character := ASCII.Nul;
  Sib_Agents : PAgents(1..NSib);

begin
  accept Start(Id: Integer; Elem: Character) do
    My_Id := Id;
    My_Elem := Elem;
  end Start;
  Log("--- Task "&My_Id'Img&" ready!");
  if NSib > 0 then
	accept Params(SAgents: PAgents) do
	  Sib_Agents := SAgents;
    end Params;
    Log("---Task " & My_Id'Img & " params ok!");
  else
    Log("---Task " & My_Id'Img & " zero params ok!");
  end if;
  loop
    select
	  accept Search(Elem: Character) do
	    Search_Elem := Elem;
      end Search;
    or
	  accept Finish;
	  exit;
	end select;
      for I in Sib_Agents'range loop
	    Sib_Agents(I).Search(Search_Elem);
      end loop;
	if My_Elem = Search_Elem then
	  Main.Found(My_Id, My_Elem); --OK
	end if;
  end loop;
    for I in Sib_Agents'range loop
      Sib_Agents(I).Finish;
    end loop;
  Main.Task_End(My_Id);
  Log("--- Task" & My_Id'Img & " end ok");
exception
  when others => Log("*** Task " & My_Id'Img & " dead!");
end Agent;



end ASearch_Pak;
