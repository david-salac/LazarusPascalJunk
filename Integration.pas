program Integration;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, md5, math
  { you can add units after this };


//Definuji třídu 2D vektoru
type
  vector2D = class(TObject)
    private
      x, y : Extended;
    public
      constructor Create(sX, sY : Extended);
      function getX() : Extended;
      function getY() : Extended;
      class function getRandomVector(min, max : vector2D; randNumber : integer = 1) : vector2D; static;
end;

constructor vector2D.Create(sX, sY : Extended);
begin
  x := sX;
  y := sY;
end;

function vector2D.getX() : Extended;
begin
  getX := x;
end;
function vector2D.getY() : Extended;
begin
  getY := y;
end;

//Vrací náhodný vektor
class function vector2D.getRandomVector(min, max : vector2D; randNumber : integer = 1) : vector2D;
var
  randNumberHash1, randNumberHash2, decSpace : Int64;
begin
  randomize();

  decSpace := 10000;

  //Přičtění HASH hodnoty rapidně zlepší entropii náhodných čísel
  randNumberHash1 := abs(StrToInt64( '0x' + copy(MD5Print(MD5String(IntToStr(randNumber))), 1, 8) ));
  randNumberHash2 := abs(StrToInt64( '0x' + copy(MD5Print(MD5String(IntToStr(randNumber))), 8, 16) ));

  //getRandomVector := vector2D.Create( (random(100 * round(max.getX - min.getX) ) + 100 * min.getX) / 100, (random(100 * round(max.getY - min.getY) ) + 100 * min.getY) / 100 );
  getRandomVector := vector2D.Create( ( round(randNumberHash1 * random) mod (decSpace * round(max.getX - min.getX) ) + decSpace * min.getX) / decSpace, (  round(randNumberHash2  * random)   mod (decSpace * round(max.getY - min.getY) ) + decSpace * min.getY) / decSpace );
end;

type
  simple2dFunction = function (x: vector2D) : Extended;


//Počítá hodnotu primitivní funkce v bode x, Dmax a Dmin je definiční obor
function primitiveFunction(integrand : simple2dFunction; x, Dmin, Dmax: vector2D) : Extended;
var
  precision, i : Int64;
  f : Extended;
begin
  precision := 10000;
  f := 0;
  for i := 1 to precision do begin
    f:= f + integrand( vector2D.getRandomVector(Dmin, Dmax) );
  end;
  f := f / precision;
  primitiveFunction := x.getX * x.getY * f ;
end;

//Počítá chybu metody
function errorCount(integrand : simple2dFunction; x, Dmin, Dmax: vector2D) : Extended;
var
  precision, i : Int64;
  f, fn, tempFn : Extended;
begin
  precision := 10000;
  //<f>^2
  f := 0;
  for i := 1 to precision do begin
    f := f + integrand( vector2D.getRandomVector(Dmin, Dmax) );
  end;
  f := (f / precision)*(f / precision);

  //<f^2>
  fn := 0;
  for i := 1 to precision do begin
    tempFn := integrand( vector2D.getRandomVector(Dmin, Dmax) );
    fn := fn + tempFn * tempFn;
  end;
  fn := (fn / precision);

  errorCount := x.getX * x.getY * sqrt( (fn - f) / 2 ) ;
end;


function linearFunction(x : vector2D) : Extended;
begin
  linearFunction := 7*x.getX + 22 + 9 * x.getY ;
end;

type

  { Integral }

  Integral = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Integral }

procedure Integral.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }

  //Zkouška primitivní funkce pro náhodný bod
  write('Vysledek pro bod: [7, 6]: ');
  writeln(primitiveFunction(@linearFunction, vector2D.Create(7,6),vector2D.Create(6,5), vector2D.Create(8,7)));
  write('Chyba pro bod: [7, 6]: ');
  writeln(errorCount(@linearFunction, vector2D.Create(7,6),vector2D.Create(6,5), vector2D.Create(8,7)));


  readln();

  // stop program loop
  Terminate;
end;

constructor Integral.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Integral.Destroy;
begin
  inherited Destroy;
end;

procedure Integral.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;



var
  Application: Integral;
begin
  Application:=Integral.Create(nil);
  Application.Title:='Integral counting';
  Application.Run;
  Application.Free;
end.

