-- asearch_pak.ads
-- (C) JP

package ASearch_Pak is
	
Num_Agents : constant := 10; 		

procedure Log(Msg: String);
procedure Put_Res(Msg: String);	
	
task Main is
 entry Found(Id: Integer; My_Elem: Character);
 entry Task_End(Id: Integer);
 entry Finish;
end Main;

type Id_Nodes is array(Integer range <>) of Integer;	
type  Node(NS: Integer) is
record
  Id   : Integer := 0;
  Elem : Character;
  NSib : Id_Nodes(1..NS);
end record;
 
type Agent;
type PAgent is access Agent;  
type PAgents is array(Integer range <>) of PAgent;  	
	
task type Agent (NSib: Integer := 0) is
  entry Start(Id: Integer; Elem: Character);
  entry Params(SAgents: PAgents);
  entry Search(Elem: Character);
  entry Finish;
end Agent;		

end ASearch_Pak;	