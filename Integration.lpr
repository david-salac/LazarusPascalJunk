program Integration;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, md5
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
begin
  randomize();
  getRandomVector := vector2D.Create( (random(100 * round(max.getX - min.getX) ) + 100 * min.getX) / 100, (random(100 * round(max.getY - min.getY) ) + 100 * min.getY) / 100 );
end;

type
  simple2dFunction = function (x: vector2D) : Extended;


//Počítá hodnotu primitivní funkce v bode x
function primitiveFunction(integrand : simple2dFunction; x, Dmin, Dmax: vector2D) : Extended;
var
  precision, i : integer;
  f : Extended;
begin
  precision := 1000000;
  f := 0;
  for i := 1 to precision do begin
    f:= f + integrand( vector2D.getRandomVector(Dmin, Dmax) );
  end;
  f := f / precision;
  primitiveFunction := x.getX * x.getY * f ;
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



  writeln(StrToInt64( '0x' + copy(MD5Print(MD5String(IntToStr(9))), 0, 16) ));
  while true do begin
  write(vector2D.getRandomVector( vector2D.Create(1,1), vector2D.Create(3,5) ).getX);
  write(vector2D.getRandomVector( vector2D.Create(1,1), vector2D.Create(3,5) ).getY);
  readln();

  end;

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

