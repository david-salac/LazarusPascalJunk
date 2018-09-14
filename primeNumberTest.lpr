program project1;



function powTo(zaklad, exponent: int64): int64;
var res, i:int64;
begin
  res := zaklad;
  for i := exponent downto 1 do
  begin
  res := res * zaklad;
  end;
  powTo := res;
end;

function modPow(zaklad, exponent, modulus: int64): int64;
var
  res, ex, zak: int64;
begin
  res := 1;
  ex := exponent;
  zak := zaklad;

  while ex  > 0 do
  begin

  if (ex mod 2) = 1 then
  begin
       res := (res * zak) mod modulus;
  end;

  zak := (zak * zak) mod modulus;
  ex:= ex div 2;
  end;
  modPow := res;
end;


var
  i, pocet: int64;
  prvocisla :Array[1..10] of int64;

begin

  i := 2;
  prvocisla[1] := 3;
  pocet := 1;

  while i < 50 do
  begin
     if modPow(3, powTo(2, i) - 2, powTo(2, i) - 1) = 1 then
     begin
          prvocisla[pocet+1] := powTo(2,i)-1;
          //writeln(powTo(2,i)-1);
          pocet := pocet + 1;
     end;
     i := i + 1;
  end;

  for i := 1 to pocet do
  begin
  writeln(prvocisla[i]);
  end;

  readln();

end.

