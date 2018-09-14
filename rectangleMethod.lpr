program project1;
{$mode objfpc}{$H+}

const
  sirka : integer = 1960;
  vyska : integer = 1080;
  maximumIteraci : integer = 400;
var
  cRe, cIm, newRe, newIm, oldRe, oldIm, zoom, moveX, moveY : real;
  x, y, i :integer;
  f : text;              // typ textovy soubor
begin
  assign(f, 'a.dat');    // prirazeni jmena souboru promenne 'f'
  rewrite(f);            // vytvoreni souboru a otevreni pro zapis

  zoom := 1;
  moveX := 0;
  moveY := 0;

  cRe := -0.7;
  cIm := 0.27015;

  for x:=0 to sirka - 1 do begin
  for y:=0 to vyska-1 do begin
     newRe := 1.5 * (x - sirka / 2) / (0.5 * zoom * sirka) + moveX;
     newIm := (y - vyska / 2) / (0.5 * zoom * vyska) + moveY;

     for i:=0 to maximumIteraci - 1 do begin
            oldRe := newRe;
            oldIm := newIm;

            newRe := oldRe * oldRe - oldIm * oldIm + cRe;
            newIm := 2 * oldRe * oldIm + cIm;

            if ((newRe * newRe + newIm * newIm) > 4) then break;
     end;
     writeln(f, x, ' ', y,' ', i mod 256);  // zapis do souboru (prvni parametr)
  end;
  end;
  close(f);  // zavreni soboru (zde zbytecne)
end.

//Zdroj: algoritmus vypujcen z: http://lodev.org
