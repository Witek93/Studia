with Ada.Float_Text_IO, Ada.Text_IO, Ada.Numerics.Float_Random;
use  Ada.Float_Text_IO, Ada.Text_IO, Ada.Numerics.Float_Random;


procedure bubbleSort is
	R: constant Integer := 40;
	type Wektor is array(integer range <>) of Float;
	Vector : Wektor(1 .. R) := (others=>0.0);

	task type TSort (R:Integer) is
		entry Start(W:Wektor);
		entry Koniec(W: out Wektor);
	end;

	type T_P is access TSort;
	type TSort_Array is array (Integer range <>) of T_P;

	task body TSort  is
		WL:Wektor(1..R):= (others=>0.0);--new TSor(rozmiar R)
		procedure Sortuj_wektor(W: in out Wektor) is
			k:Integer:=1;
			tmp:Float;
		begin
			while k>0 loop
				k:=0;
				for I in W'First..W'Last-1 loop
					if W(I)>W(I+1) then
					tmp:=W(I);
					W(I):=W(I+1);
					W(I+1):=tmp;
					k:=k+1;
					end if;
				end loop;
			end loop;
		end Sortuj_wektor;

	begin
		accept Start(W:Wektor)  do --miejsce zsynchronizowane
			WL:=W;
		end Start;
		Sortuj_wektor(Wl);
		accept Koniec(W: out Wektor) do
			W:=WL;
		end;
	end;


	procedure randomVec(W:in out Wektor) is
		Gen: Generator;
	begin
		Reset(Gen);

		for I in W'Range loop
			W(I) := Random(Gen) * 1000.0;
		end loop;

	end randomVec;


	procedure printVec(W: Wektor) is
	begin
		for I in W'Range loop
			Put(W(I),6,3,0);
		end loop;
	end printVec;

	procedure Zlacz_wektory (Vector:out Wektor; W2:in Wektor; W3:in Wektor) is
		i:Integer:=W2'First;
		j:Integer:=W3'First;
		k:Integer:=Vector'First;
		w2_p:Integer:=0;
		w3_p:Integer:=W3'First;
	begin
		for k in Vector'Range loop
			if i>W2'Last then
				Vector(k):=W3(j);
				j:=j+1;
			elsif j>W3'Last then
				Vector(k):=W2(i);
				i:=i+1;
			elsif W2(i)>W3(j) then
				Vector(k):=W3(j);
				j:=j+1;
			else
				Vector(k):=W2(i);
				i:=i+1;
			end if;
		end loop;
	end Zlacz_wektory;

	len:Integer;

begin

	randomVec(Vector);
	printVec(Vector);
if Vector'length>5 then len:=Vector'length/2; else len:=Vector'Length; end if;
	declare
		z_sort : TSort_Array (1 .. 2) ;--:= (others => new TSort (R => len));
		W2 : Wektor(1 .. len) := (others=>0.0);
		W3 : Wektor(1 .. Vector'Length-len) := (others=>0.0);
	begin
		z_sort(1):=new TSort(len);
		z_sort(2):=new TSort(Vector'Length-len);
		z_sort(1).Start(Vector(Vector'First..len));
		z_sort(2).Start(Vector(len+1..Vector'Last));
		z_sort(1).Koniec(W2);
		z_sort(2).Koniec(W3);

		new_line;
		new_line;
		Zlacz_wektory(Vector,W2,W3);
	end;
		printVec(Vector);
end bubbleSort;
