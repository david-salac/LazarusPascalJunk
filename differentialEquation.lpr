program diferencialniRovnice;

{$mode objfpc}{$H+}
uses
  math;

const
  xmin=0.01;       // dolni mez nezavisle promenne
  xmax=0.7;       // horni mez nezavisle promenne
  ymin=3;       // pocatecni podminka
  nstep=100;     // pocet kroku
type
  tFunct = function(x, y : real) : real; // definujeme funkcionalni typ, abychom mohli nazev funkce predavat jako parametr procedure Euler
  tArr = array[0..nstep] of real;

// prava strana rovnice
// d y(x) / dx = y(x)
// reseni y(x) = const * exp(x)
function f(x, y : real) : real;
begin
  f := y;
end;

//Moje rovnice:
//d y(x) / dx = arcsin(x)+7*ln(x)
function moje(x, y:real) : real;
begin
  moje := arcsin(x) + 7*ln(x);
end;

// d y(x) / dx = sin(x)
// reseni ma byt y(x) = -cos(x) + const
function sinus(x, y : real) : real;
begin
  result := sin(x);
end;

// Eulerova metoda
procedure Euler(f : tFunct; const xmin, xmax, ymin : real;
                const nstep : integer;
                var x,y : tArr); // 'const' oznacuje vstupni promenne (nemuzeme menit); 'var' promenne, ktere zmenime a zustanou zmenene v hlavnim programu
var
  h : real;
  i : integer;
begin
  x[0] := xmin;
  y[0] := ymin;
  h := (xmax-xmin)/nstep; // velikost kroku
  for i := 1 to nstep do begin
    x[i] := x[i-1] + h;
    y[i] := y[i-1] + h*f(x[i-1],y[i-1]); // 'f' oznacuje funkci, jejiz nazev dostala procedura Euler jako prvni parametr
  end;
end;

var
  x, y : tArr;
  i : integer;
  soubor : text;
begin
  Euler(@moje, xmin, xmax, ymin, nstep, x, y); // '@' uvozuje funkcionalni typ
//   Euler(@sinus, 0, 40, 1, 50, x, y);
  assign(soubor, 'a.dat'); // priradime promenne 'soubor' jmeno souboru
  rewrite(soubor); // vytvorime novy soubor a otevreme pro zapis (pokud soubor existuje, je smazan a znovu vytvoren)
  for i := 0 to nstep do
    writeln(soubor, x[i], y[i]);
  close(soubor); // zavreme soubor, jinak se nemusi zapsat do konce
end.

