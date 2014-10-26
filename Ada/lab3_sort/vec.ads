package vec is

    type Wektor is array (Integer range <>) of Float;

    procedure print(W : Wektor; Comment : String);
    procedure randomize(W : in out Wektor; Min, Max : Float);
    procedure sort(W : in out Wektor);

end vec;
