program soustavaDRovnic;

{$mode objfpc}{$H+}
const
  neq=4;        // pocet rovnic
type
  tY = array[1..neq] of real;   // typ pro vektor reseni
const // musime kostanty definovat na dvou mistech, abychom pouzivali jen drive definovane typy a konstanty
  xmin=0;       // dolni mez nezavisle promenne, cas t
  xmax=5;       // horni mez nezavisle promenne, cas t_max
  ymin: tY=(10,25,  5, 30); // pocatecni podminka (vyska z = 10 m, rychlost v_z = 20 m/s, vzdalenost x=5 m, rychlost v_x = 30 m/s)
  nstep=100;     // pocet kroku reseni
type
  tAx = array[0..nstep] of real; // pole hodnot x, ve kterych pocitame reseni
  tAY = array[0..nstep] of tY; // pole vektoru, budeme do nej ukladat reseni
  tFunct = function(x : real; Y : tY) : tY;

// prava strana rovnice - SIKMY vrh
function vrh(x : real; y : tY) : tY;
const
  g = 9.81; // gravitacni zrychleni
  K = 0.05;
  m = 1.0; // vse v jednotkach SI
var
  vy, vx, v : real;
begin
  vy := y[2];
  vx := y[4];
  v := sqrt( (vy*vy) + (vx*vx ));
  result[1] := vy;
  result[2] := -g - (K/m)*(v*v)*(vy/v); // odporova sila je umerna v^2
  result[3] := vx;
  result[4] := - (K/m)*(v*v)*(vx/v);
end;

// Eulerova metoda
procedure Euler(f : tFunct; const xmin, xmax : real;
                const ymin : tY;
                const nstep : integer;
                var x : tAx; var y : tAY);
var
  h : real;
  i, j : integer;
  FF: tY;
begin
  x[0] := xmin;
  y[0] := ymin;
  h := (xmax-xmin)/nstep;
  for i := 1 to nstep do begin
    x[i] := x[i-1] + h;
    FF := f(x[i-1],y[i-1]);  // vysledek dalsiho kroku
    for j := 1 to neq do // do pole vysledku postupne pricteme dalsi krok
      Y[i,j] := Y[i-1,j] + h*FF[j];
  end;
end;

// Runge-Kuttova metoda 4. radu
procedure RungeKutta(f : tFunct; const xmin, xmax : real;
                const ymin : tY;
                const nstep : integer;
                var x : tAx; var y : tAY);
var
  h : real; // velikost kroku
  k1,k2,k3,k4,YY : tY;
  i,j: integer;
begin
  x[0] := xmin;
  y[0] := ymin;
  h := (xmax-xmin)/nstep;
  for i := 0 to nstep-1 do begin
    k1 := f(x[i],y[i]);
    for j := 1 to neq do
      YY[j] := y[i][j] + h*k1[j]*0.5;
    k2 := f(x[i]+h*0.5, YY);
    for j := 1 to neq do
      YY[j] := y[i][j] + h*k2[j]*0.5;
    k3 := f(x[i]+h*0.5, YY);
    for j := 1 to neq do
      YY[j] := y[i][j] + h*k3[j];
    k4 := f(x[i]+h, YY);
    for j := 1 to neq do
      y[i+1][j] := y[i][j] + h * (k1[j] + 2*k2[j] + 2*k3[j] + k4[j])/6.;
  end;
end;


var
  t : tAx;
  y : tAY;
  i, j : integer;
  soubor : text;
begin
  Euler(@vrh, xmin, xmax, ymin, nstep, t, Y);
  assign(soubor, 'vrh-E.dat');
  rewrite(soubor);

  for i := 0 to nstep do begin
    //write(soubor, t[i]:8:4);
    write(soubor, ' ', Y[i,3]:10:5);
    write(soubor, ' ', Y[i,1]:10:5);
    writeln(soubor);
  end;
  close(soubor);

  RungeKutta(@vrh, xmin, xmax, ymin, nstep, t, Y);
  assign(soubor, 'vrh-RK.dat');
  rewrite(soubor);

  for i := 0 to nstep do begin
    write(soubor, ' ', Y[i,3]:10:5);
    write(soubor, ' ', Y[i,1]:10:5);
    writeln(soubor);
  end;
  close(soubor);
end.


