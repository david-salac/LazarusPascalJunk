program krivky;
{$APPTYPE CONSOLE}
{$mode objfpc}

uses
 Sysutils;

// Lissajousovy obrazce
// http://en.wikipedia.org/wiki/Lissajous_curve

// vystup programu doporucuji presmerovat do souboru prikazem:
// cviceni3c.exe > a.dat		(ve Windows)
// ./cviceni3c > a.dat		(Linux apod.)

const
  a = 8;
  b = 5;
  delta = 0;


var
  t, x, y, R1, r, p : real;
  File1: TextFile;

begin
  WriteLn('Zapisuji do soburu zdroj.dat!');

  {$I+}
  try

    AssignFile(File1, 'zdroj.dat');
    Rewrite(File1);

    R1 := 100;
    r := 2.0;
    p := 80;

    repeat
      x := (R1-r)*cos(t) + p*cos((R1-r)*t/r);
      y := (R1-r)*sin(t) - p*sin((R1-r)*t/r);
      Writeln(File1,  x, ' ', y);
      t := t + 0.001;
    until (a*t > 100*2*pi);

    CloseFile(File1);
  except
    on E: EInOutError do
    begin
     Writeln('Vyskytla se chyba pri zapisu do souboru: '+E.ClassName+'/'+E.Message);
    end;
  end;
  WriteLn('');
  WriteLn('Vystup muzete vykreslit pomoci prikazu gnuplotu:');
  WriteLn('set size square');
  WriteLn('unset key');
  WriteLn('plot ''zdroj.dat'' with lines ');

  WriteLn('');
  WriteLn('Konec programu, stisknete enter pro ukonceni.');
  Readln;


end.

