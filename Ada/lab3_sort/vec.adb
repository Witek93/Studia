with Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random;
use  Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random;

package body vec is

    procedure print (W: in Wektor; Comment: String) is
    begin
        put_line(Comment);
        for I in W'Range loop
            put(W(I),3,4,0);
        end loop;
        put_line("");
    end print;

    procedure randomize (W : in out Wektor; Min, Max : Float) is
    G : Generator;
    begin
        reset(G);
        for I in W'Range loop
            W(I) := Random(G) * (Max - Min) + Min;
        end loop;
    end randomize;

    procedure sort (W: in out Wektor) is
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
    end sort;

end vec;
