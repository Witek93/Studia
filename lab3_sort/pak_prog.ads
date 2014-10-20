package pak_prog is

type Wektor is array (Integer range <>) of Float;

procedure put_wektor    (W: Wektor; Kom: String);
procedure losuj_wektor  (W: Wektor);
procedure sortuj_wektor (W: Wektor);

end pak_prog;
