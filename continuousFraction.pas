program SALAC_ukol_2;

uses
  Math;


function pi_retezoveZlomky(citatel, pricitam, max:real) : real;
begin
if max > 0 then
   begin
   pi_retezoveZlomky := pricitam + (citatel * citatel) / pi_retezoveZlomky(citatel + 2, 6, max - 1);
   end
else
   pi_retezoveZlomky := pricitam + (citatel * citatel);
end;


function pi_Ramanujan(nMax: integer) : real;
var
  s,c,j,j2: real;
  i,n: integer;
begin
  s := 0;
  for n := 0 to nMax do
    begin
      c := 1;
      for i := 1 to 4*n do
        c := c*i;
      j := 1;
      for i := 1 to n do
        j := j*i;
      j := sqr(sqr(j));
      j2 := power(396, 4.0*n);
      s := s + c/j*(1103+26390*n)/j2;
    end;
    pi_Ramanujan := 1/s * 9801/sqrt(8);

end;

function pi_Wolfram(pocetCyklu: integer) : real;
var
  pi, nasobek, suma: ValReal;
  k: Int64;
begin
  suma := 0;
  nasobek := (8/(1+sqrt(2)));
  for k:=0 to pocetCyklu do
  begin
    suma := suma + ((1/(8*k+1)) - 1/(8*k+7));
  end;
  pi := suma*nasobek;
  pi_Wolfram := pi;
end;

begin
  writeln('Autor:   David SALAC');
  writeln('');

  write('Dle meho prvniho vypoctu vyjde pi = ');
  write(pi_wolfram(10000000));
  writeln('');
  write('Dle Ramanujanova vypoctu vyjde pi = ');
  write(pi_Ramanujan(10));

  writeln('');
  write('Dle retezovych zlomku vyjde pi    = ');
  write(pi_retezoveZlomky(1,3,100000));

  writeln('');
  writeln('');
  writeln('Konec programu, stisknete enter!');
  readln;
end.

