program polynomy;
{$APPTYPE CONSOLE}
uses complex;

const
  Rmin : real = -2; Rmax : real = 1;  // meze testovaneho obdelnika
  Imin : real = -1; Imax : real = 1;
  presnost : integer = 10000000;

type
  tProc = procedure (z : tComplex; var f,df : tComplex);

// funkce z^3-1
procedure evalZ31(z : tComplex; var f,df : tComplex);
begin
  f:=cSub(cMul(Cmul(z,z),z),cmpx(1,0));
  df:=CMul(Cmul(z,z),cmpx(3,0));
end;

// funkce z^4-16
procedure evalZ416(z : tComplex; var f,df : tComplex);
begin
  f:=cSub(cMul(cMul(Cmul(z,z),z),z),cmpx(16,0));
  df:=CMul(cMul(Cmul(z,z),z),cmpx(4,0));
end;

// funkce 243*z^5-7776
procedure evalZ2437776(z : tComplex; var f,df : tComplex);
begin
  f:=cSub(cMul(cMul(cMul(cMul(cMul(z,z),z),z),z),cmpx(243,0)),cmpx(7776,0));
  df:=CMul(cMul(cMul(cMul(z,z),z),z),cmpx(1215,0));
end;

// funkce 3*z^4+4*z^3+2*z^2+7*z-1084
procedure eval3Z44z32z27z1084(z : tComplex; var f,df : tComplex);
begin

  {cAdd(cAdd(cAdd(
  cMul(cMul(cMul(cMul(z,z),z),z),cmpx(3,0)),
  cMul(cMul(cMul(z,z),z),cmpx(4,0))),
  cMul(cMul(z,z),cmpx(2,0)))
  cMul(z,cmpx(7,0)))}

  {
  cAdd(cAdd(cAdd(
  cMul(cMul(cMul(z,z),z),cmpx(12,0)),
  cMul(cMul(z,z),cmpx(12,0))),
  cMul(z,cmpx(4,0))),cmpx(7,0) )
  }

  f:=cSub(cAdd(cAdd(cAdd(
  cMul(cMul(cMul(cMul(z,z),z),z),cmpx(3,0)),
  cMul(cMul(cMul(z,z),z),cmpx(4,0))),
  cMul(cMul(z,z),cmpx(2,0))),
  cMul(z,cmpx(7,0))), cmpx(1084,0));

  df:=cAdd(cAdd(cAdd(
  cMul(cMul(cMul(z,z),z),cmpx(12,0)),
  cMul(cMul(z,z),cmpx(12,0))),
  cMul(z,cmpx(4,0))),cmpx(7,0));
end;



// Newtonova metoda
function Newton(evalF : tProc ; const z0 : tComplex; const eps : real) : tComplex;
const
  nmax=50;
var
  n : integer;
  z,dz,f,df : tComplex;
begin
  z:=z0;
  for n:=1 to nmax do begin
    evalF(z,f,df);
    dz:=cDiv(f,df);
    z:=cSub(z,dz);
    // writeln(n,areal(z),imag(z));
    if cAbs(dz)<eps then break;
  end;
  result:=z;
end;

var
  re,im : real;
  c,z0,z,zroot : tComplex;
  eps : real;
  f : text;
  ic: integer;
begin

  //-------------------------
  writeln('Pracuji na polynomu z^4-16:');
  assign(f, 'z_4_-_16.dat');    // prirazeni jmena souboru promenne 'f'
  rewrite(f);            // vytvoreni souboru a otevreni pro zapis
  zroot:=cmpx(2,0);
  eps:=1e-10;
  for ic:=0 to presnost do begin    // nekonecny cyklus, ukoncit ctrl-c
    re := Rmin + (Rmax-Rmin)*random;
    im := Imin + (Imax-Imin)*random;
    c := cmpx(re, im);   // testovane c
    z0 := c;             // pocatecni hodnota
    z:=Newton(@evalZ416,z0,eps); // Newtonova metoda z bodu z0
    if cAbs(cSub(z,zroot))<eps then writeln(f,re,' ',im); // vypis z0 pri konvergenci k zroot
  end;
  close(f);  // zavreni soboru (zde zbytecne)



  //-------------------------
  writeln('Pracuji na polynomu 243z^4-7776:');
  assign(f, '243z_5_-_7776.dat');    // prirazeni jmena souboru promenne 'f'
  rewrite(f);            // vytvoreni souboru a otevreni pro zapis
  zroot:=cmpx(2,0);
  eps:=1e-10;
  for ic:=0 to presnost do begin    // nekonecny cyklus, ukoncit ctrl-c
    re := Rmin + (Rmax-Rmin)*random;
    im := Imin + (Imax-Imin)*random;
    c := cmpx(re, im);   // testovane c
    z0 := c;             // pocatecni hodnota
    z:=Newton(@evalZ2437776,z0,eps); // Newtonova metoda z bodu z0
    if cAbs(cSub(z,zroot))<eps then writeln(f,re,' ',im); // vypis z0 pri konvergenci k zroot
  end;
  close(f);  // zavreni soboru (zde zbytecne)



  //-------------------------
  writeln('Pracuji na polynomu 3*z^4+4*z^3+2*z^2+7*z-1084:');
  assign(f, '3z4_4z3_2z2_7z_1084.dat');    // prirazeni jmena souboru promenne 'f'
  rewrite(f);            // vytvoreni souboru a otevreni pro zapis
  zroot:=cmpx(4,0);
  eps:=1e-10;
  for ic:=0 to presnost do begin    // nekonecny cyklus, ukoncit ctrl-c
    re := Rmin + (Rmax-Rmin)*random;
    im := Imin + (Imax-Imin)*random;
    c := cmpx(re, im);   // testovane c
    z0 := c;             // pocatecni hodnota
    z:=Newton(@eval3Z44z32z27z1084,z0,eps); // Newtonova metoda z bodu z0
    if cAbs(cSub(z,zroot))<eps then writeln(f,re,' ',im); // vypis z0 pri konvergenci k zroot
  end;
  close(f);  // zavreni soboru (zde zbytecne)

  writeln(' ');
  writeln('Soubory jsou pripravene k vykresleni!');
  writeln('K vykresleni (na obrazovku) lze vyuzit prikazu:');
  writeln('p ''z_4_-_16.dat'' u 1:2 w d');
  writeln('p ''243z_5_-_7776.dat'' u 1:2 w d');
  writeln('p ''3z4_4z3_2z2_7z_1084.dat'' u 1:2 w d');
  readln();
end.

