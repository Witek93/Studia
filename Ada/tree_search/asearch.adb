--
-- asearch.adb : Agent Search
-- (C) JP

with Ada.Text_IO;
use  Ada.Text_IO;
with ASearch_Pak;
use ASearch_Pak;

procedure ASearch is


Agents : PAgents(1..Num_Agents) := (1 => new Agent(3), 2|3|4 => new Agent(2) ,others => new Agent(0));

Node_Elems : array(Agents'range) of Character := ('A', 'B', 'C','D','E', 'B', 'F', 'G', 'H','C');


procedure Init_Tree is
begin
 for I in Agents'range loop
   Agents(I).Start(I, Node_Elems(I));
 end loop;
 Agents(4).Params( (Agents(9), Agents(10)) );
 Agents(3).Params( (Agents(7), Agents(8)) );
 Agents(2).Params( (Agents(5), Agents(6)) );
 Agents(1).Params( (Agents(2), Agents(3), Agents(4)) );
end Init_Tree;


procedure Search(Ch: Character) is
begin
  Agents(1).Search(Ch);
  Put_Res("### Searching >" & Ch & "<");
end Search;


procedure Finish_Tree is
begin
   Agents(1).Finish;
end Finish_Tree;

begin -- ASearch
  Init_Tree;

  Search('A');
  Search('P');
  Search('B');
  Search('C');
  Search('Y');

  Finish_Tree;
end ASearch;
