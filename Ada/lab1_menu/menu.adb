-- include external file
with Ada.Text_IO;

-- qualify the namespace
use Ada.Text_IO;

procedure menu is
  znak : Character := '0';
  procedure print_menu is begin
    put_line("[1]   Opcja 1");
    put_line("[2]   Opcja 2");
    put_line("[3]   Opcja 3");
    put_line("[ESC] Wyjdź");
  end print_menu;

  procedure opcja1 is begin put_line("Wybrano opcję pierwszą"); end opcja1;
  procedure opcja2 is begin put_line("Wybrano opcję drugą"); end opcja2;
  procedure opcja3 is begin put_line("Wybrano opcję trzecią"); end opcja3;
  procedure wyjscie is begin put_line ("Wcisnieto ESC"); end wyjscie;
  procedure inny is begin put_line("Wcisnieto inny klawisz"); end inny;


begin
  loop
    print_menu;
    get_immediate(znak);
    case znak is
      when '1' => opcja1;
      when '2' => opcja2;
      when '3' => opcja3;
      when ASCII.ESC => wyjscie; exit;
      when others => inny;
    end case;
  end loop;
end menu;
