// modul s komplexni aritmetikou
// Numerical Recipes, kap. 5.4

unit complex;

// exportovana jmena
interface
type
  tComplex = array[1..2] of real;
function areal(c : tComplex) : real;
function imag(c : tComplex) : real;
function cmpx(re,im : real) : tComplex;
function cAdd(a,b : tComplex) : tComplex;
function cSub(a,b : tComplex) : tComplex;
function cMul(a,b : tComplex) : tComplex;
function cDiv(a,b : tComplex) : tComplex;
function cAbs(a : tComplex) : real;

// implementacni cast
implementation
type
  tComplexA = array[1..2] of real;       // komplexni typ jako pole
  tComplexR = record Re,Im : real end;   // komplexni typ jako zaznam (record)

// realna cast
function areal(c : tComplex) : real;
begin
  result:=c[1];
end;

// imaginarni cast
function imag(c : tComplex) : real;
begin
  result:=c[2];
end;

// vytvoreni komplexniho cisla (pole) ze dvou realnych
function cmpx(re,im : real) : tComplex;
begin
  result[1] := re;
  result[2] := im;
end;
// vytvoreni komplexniho cisla (zaznam) ze dvou realnych
function cmpxR(re,im : real) : tComplexR;
begin
  result.Re := re;
  result.Im := im;
end;

// komplexni scitani (varianta pole)
function cAdd(a,b : tComplex) : tComplex;
begin
  result[1] := a[1] + b[1];
  result[2] := a[2] + b[2];
end;
// komplexni scitani (varianta zaznam)
function cAddR(a,b : tComplexR) : tComplexR;
begin
  result.Re := a.Re + b.Re;
  result.Im := a.Im + b.Im;
end;

// komplexni odcitani (varianta pole)
function cSub(a,b : tComplex) : tComplex;
begin
  result[1] := a[1] - b[1];
  result[2] := a[2] - b[2];
end;

// komplexni nasobeni
// (a+ib)*(c+id)=ac-bd + i (ad+bc)
function cMul(a,b : tComplex) : tComplex;
begin
  result[1] := a[1]*b[1] - a[2]*b[2];
  result[2] := a[1]*b[2] + a[2]*b[1];
end;

// prevracena hodnota
// 1/(a1 + i.a2) = (a1 - i.a2) / (a1^2+a2^2)
function cInv(a : tComplex) : tComplex;
var
  jmenovatel : real;
begin
  jmenovatel:=sqr(a[1])+sqr(a[2]);
  result[1]:=a[1]/jmenovatel;
  result[2]:=-a[2]/jmenovatel;
end;

// komplexni deleni
function cDiv(a,b : tComplex) : tComplex;
begin
  result:=cMul(a,CInv(b));
end;

// absolutni hodnota komplexniho cisla (odolna proti preteceni)
function cAbs(a : tComplex) : real;
begin
  if abs(a[1]) > abs(a[2])
    then result := abs(a[1]) * sqrt(1+sqr(a[2]/a[1]))
  else if abs(a[1]) > 0
    then result := abs(a[2]) * sqrt(1+sqr(a[1]/a[2]))
  else result := 0;
end;

end.

