program SALAC_ukol_1;

var
  pi, nasobek, suma: ValReal;
  k: Int64;
begin
  writeln('Vitejte v mem programku na vypocet cisla pi!');
  writeln('Pouziji vzorec dostupny na: http://functions.wolfram.com/Constants/Pi/06/01/01/');
  writeln('a to na 11. radku');

  writeln('');
  writeln('VAROVANI!!! NA MEM NOTEBOOKU VYPOCET TRVAL CCA 20 SEKUND');
  writeln('');

  suma := 0;
  nasobek := (8/(1+sqrt(2)));


  for k:=0 to 1000000000 do
  begin
    suma := suma + ((1/(8*k+1)) - 1/(8*k+7));
  end;

  pi := suma*nasobek;

  write('Dle naseho vypoctu vyjde pi = ');
  write(pi);

  writeln('');
  writeln('');
  writeln('Konec programu, stisknete enter!');
  readln;
end.

