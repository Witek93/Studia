with Ada.Text_IO;
use Ada.Text_IO;

procedure prog2 is

  task type zad2 is
    entry w1 (i : Integer);
    entry w2 (i : Integer);
  end zad2;

  task body zad2 is
    id : Integer := 0;
  begin
    loop
      select
        accept w1() do
          put("Wejscie pierwsze");
        end w1;
      or
        accept w2() do
          put("Wejscie drugie");
        end w2;
      or
        delay 1.0;
        exit;
      end select;
    end loop;
  end zad2;



subtype zad is Integer range 1..10;
  z1 : array (1 .. 10) of zad2;

begin
  for k in zad loop
    z1(k).w1(k);
  end loop;
end prog2;
