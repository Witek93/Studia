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


    procedure randomize (W : in ouadd at Wektor; Min, Max : Float) is
    G : Generator;
    begin
        reset(G);
        for I in W'Range loop
            W(I) := Random(G) * (Max - Min) + Min;
        end loop;
    end randomize;


    function sort (W : in Wektor) return Wektor is
        tmp : Float;
        R   : Wektor (W'Range);
    begin
        R := W;
        for I in R'Range loop
            for J in R'First..(R'Last - 1) loop
                if(R(J) > R(J+1)) then
                    tmp    := R(J);
                    R(J)   := R(J+1);
                    R(J+1) := tmp;
                end if;
            end loop;
        end loop;
        return R;
    end sort;

end vec;
