program LURozklad;

{$mode objfpc}{$H+}
{$m+}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp;


type TMatrix = class
  type
      EArray = Array of array of Extended;
  private
    n, m: integer;
    matrix: EArray;
  public
    constructor create(rowCount, columnCount: integer);
    constructor createIdentityMatrix(rowCount, columnCount: integer);
    constructor createRandomMatrix(rowCount, columnCount, randFrom, randTo: integer);
    function getRowCount(): integer;
    function getColumnCount(): integer;
    procedure printElements();
    function isSquare(): Boolean;
    procedure LUDecomposition(var L, U, P : TMatrix);
    function getElementByIndex(i, j: integer): Extended;
    procedure setElementByIndex(i, j: integer; val: Extended);
    function clone(): TMatrix;
    function multiplication(mul: TMatrix): TMatrix;
    function rowSwapByIndex(source, target: integer): TMatrix;
    procedure writeMatrixToMATLAB(varLabel: string);
    class function LUequationsSystem(L, U, P, vector: TMatrix) : TMatrix; static;

end;


constructor TMatrix.create(rowCount, columnCount: integer);
begin
   n := rowCount;
   m := columnCount;
   Setlength(matrix,rowCount,columnCount);
end;

constructor TMatrix.createIdentityMatrix(rowCount, columnCount: integer);
var
   nT, minNM: integer;
begin
   n := rowCount;
   m := columnCount;
   Setlength(matrix,rowCount,columnCount);
   if n > m then
      minNM := m
   else
      minNM := n;
   for nT := 0 to minNM - 1 do
   begin
     matrix[nT, nT] := 1;
   end;
end;


constructor TMatrix.createRandomMatrix(rowCount, columnCount, randFrom, randTo: integer);
var
  i, j: Integer;
begin
  n := rowCount;
  m := columnCount;
  Setlength(matrix,rowCount,columnCount);
  Randomize;
  for i:=0 to n-1 do
  begin
    for j:=0 to m-1 do
    begin
      matrix[i,j] := random(randTo)+randFrom;
    end;
  end;
end;

procedure TMatrix.printElements();
var
  nT, mT : integer;
begin
   for nT := 0 to n-1 do
   begin
     for mT := 0 to m-1 do
     begin
       write( matrix[nT,mT] );
     end;
     writeln();
   end;
end;


procedure TMatrix.writeMatrixToMATLAB(varLabel: string);
var
  i,j: integer;
begin
  write(varLabel);
  write('[');
  for i:= 0 to getRowCount()-1 do
  begin
    for j:=0 to getColumnCount()-1 do
    begin
      write(getElementByIndex(i, j), ' ');
    end;
    if i=getRowCount()-1 then Break;
    write(';');
  end;
  writeln(']');

end;

procedure TMatrix.setElementByIndex(i, j: integer; val: Extended);
begin

   if ((i < getRowCount()) and (j < getColumnCount())) then
   begin
      matrix[i,j] := val;
   end
   else
   begin
      writeln('Chyba v indexu!!!');
   end;
end;

function TMatrix.isSquare(): Boolean;
begin
   if m = n then
   begin
     isSquare := True;
   end

   else
   begin
     isSquare := False;
   end;
end;

function TMatrix.getElementByIndex(i, j: integer): Extended;
begin
   if ((i <= n) and (j <= m)) then
   begin
      getElementByIndex := matrix[i, j];
   end
   else
   begin
      getElementByIndex:=0.0;
      writeln('Chyba v indexu!!!');
   end;
end;

function TMatrix.getRowCount(): integer;
begin
   getRowCount:= n;
end;

function TMatrix.getColumnCount(): integer;
begin
   getColumnCount:= m;
end;


function TMatrix.clone(): TMatrix;
var
  tTMatrix: TMatrix;
  i, j: integer;
begin
   tTMatrix := TMatrix.create(n, m);

   for i:=0 to n-1 do
   begin
     for j:=0 to m-1 do
     begin
       tTMatrix.setElementByIndex(i, j, matrix[i,j]);
     end;
   end;


   clone := tTMatrix;
end;

function TMatrix.multiplication(mul: TMatrix): TMatrix;
var
  productMatrix: TMatrix;
  oldVal: Extended;
  i1,j1, k1 :integer;
begin
   if mul.getRowCount() = getColumnCount() then
   begin
     productMatrix := TMatrix.create(getRowCount(), mul.getColumnCount() );
     for i1:= 0 to getRowCount() - 1 do
     begin
       for j1:=0 to mul.getColumnCount()-1 do
       begin
         oldVal := productMatrix.getElementByIndex(i1,j1);
         for k1:=0 to mul.getRowCount()-1 do
         begin
           productMatrix.setElementByIndex(i1, j1, oldVal + (getElementByIndex(i1, k1)*mul.getElementByIndex(k1, j1)) );
           oldVal := productMatrix.getElementByIndex(i1,j1);
         end;
           {writeln(i1);
           writeln(j1);
           writeln(mul.getColumnCount(), mul.getRowCount());
           writeln();}
       end;
     end;
     multiplication := productMatrix;
   end
   else
   begin
     write('Chyba v dimenzi');
     multiplication := TMatrix.create(1,1);
   end;
end;

function TMatrix.rowSwapByIndex(source, target: integer): TMatrix;
var
  newMatrix: TMatrix;
  colIndex:integer;
  tempVal:Extended;
begin
   if ((source < getRowCount()) and (target < getRowCount())) then
   begin

   newMatrix := clone();
   for colIndex:=0 to getColumnCount() -1 do
   begin
     tempVal := getElementByIndex(target, colIndex);
     newMatrix.setElementByIndex(target, colIndex, getElementByIndex(source, colIndex) );
     newMatrix.setElementByIndex(source, colIndex, tempVal);
   end;
   rowSwapByIndex := newMatrix;
   end
   else
   begin
     write('Chyba v dimenzi');
     newMatrix := TMatrix.create(1,1);
     rowSwapByIndex := newMatrix;
   end;
end;

procedure TMatrix.LUDecomposition(var L, U, P : TMatrix);
var
  diagonal, row, col, sign : integer;
  oldElement, oldLElement, pivotElement, subPivotColElement, subPivotColLElement, pivotColElement, pivotElementInverse:Extended;
begin
   L:= TMatrix.createIdentityMatrix(n, n);
   P:= TMatrix.createIdentityMatrix(n, n);
   U:= clone();


   for diagonal := 0 to getColumnCount()-1 do
   begin

     pivotElement := U.getElementByIndex(diagonal, diagonal);


     pivotElementInverse := abs(1/pivotElement);

     for row := diagonal + 1 to getRowCount()-1 do
     begin
       pivotColElement := U.getElementByIndex(row, diagonal);

       //Dopocita znamenka
         sign := 1;
         if (( pivotColElement*pivotElement < 0 ) and (pivotColElement < 0) ) then
         begin
          sign := -1;
         end
         else if (( pivotColElement*pivotElement > 0 ) and (pivotColElement > 0) ) then
         begin
          sign := -1;
         end;

       for col := diagonal  to getColumnCount() - 1 do
       begin
         oldElement:=U.getElementByIndex(row,col);

         oldLElement := L.getElementByIndex(row,col);

         subPivotColElement := U.getElementByIndex(diagonal, col);
         subPivotColLElement := L.getElementByIndex(diagonal, col);

         U.setElementByIndex(row, col, oldElement + sign* pivotColElement* (pivotElementInverse*subPivotColElement));
         L.setElementByIndex(row, col, oldLElement + sign* (-1)* pivotColElement* (pivotElementInverse*subPivotColLElement));

         {writeln('Akce---');
         writeln('sign: ', sign);
         writeln('oldElement:          ', oldElement);
         writeln('pivotColElement:     ', pivotColElement);    //Skripe to tu!
         writeln('pivotElement:        ', pivotElement);
         writeln('subPivotColElement:  ', subPivotColElement);
         writeln('pivotElementInverse: ', pivotElementInverse);
         writeln('row:                 ', row);
         writeln('col:                 ', col);
         writeln('diagonal:            ', diagonal);
         U.printElements();
         writeln('---');
         }
       end;
     end;
   end;

   {//L.printElements();
   writeln('------U:----');
   U.printElements();
   {writeln('------U: matlab----');
   U.writeMatrixToMATLAB();}

   writeln('------L:----');
   L.printElements();}

end;


class function TMatrix.LUequationsSystem(L, U, P, vector: TMatrix) : TMatrix; static;
var
  yVal, retVal, b: TMatrix;
  i, j, invI, invJ:Integer;
  val, divVal : Extended;
begin

  b := P.multiplication(vector);

  yVal := TMatrix.create(L.getRowCount(),1);

  val := 0;

  for i := 0 to L.getRowCount()-1 do
  begin
    val := b.getElementByIndex(i,0) ;
    for j:=0 to i-1 do
    begin
      val := val - L.getElementByIndex(i, j)*yVal.getElementByIndex(j,0);
    end;
    yVal.setElementByIndex(i, 0, val);

  end;

  {yVal.writeMatrixToMATLAB('LxB = ');}

  retVal := TMatrix.create(U.getRowCount(),1);

  val := 0;

  invI := U.getRowCount() - 1;
  invJ := U.getColumnCount()-1;
  for i := 0 to U.getRowCount()-1 do
  begin
    divVal := U.getElementByIndex(invI - i, invI - i);

{    writeln('divVal: ', divVal);}

    val := yVal.getElementByIndex(invI - i,0)/divVal ;



    for j:=0 to i-1 do
    begin
      val := val - U.getElementByIndex(invI - i, invJ - j)*retVal.getElementByIndex(invJ - j,0)/divVal;
    end;
    retVal.setElementByIndex(invI -i, 0, val);

  end;

  LUequationsSystem:=retVal;
end;


type

  { TLURozklad }

  TLURozklad = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TLURozklad }

procedure TLURozklad.DoRun;
var
  ErrorMsg: String;
  myMatrix, newMatrix, userMatrix, userVector, L, U, P, x: Tmatrix;
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


  userMatrix := TMatrix.create(5,5);
  //Navstupuji konkretni matici:
  userMatrix.setElementByIndex(0,0, 4);  userMatrix.setElementByIndex(0,1, 8);  userMatrix.setElementByIndex(0,2, 8);  userMatrix.setElementByIndex(0,3, 3);  userMatrix.setElementByIndex(0,4, 1);
  userMatrix.setElementByIndex(1,0, 8);  userMatrix.setElementByIndex(1,1, 2);  userMatrix.setElementByIndex(1,2, 6);  userMatrix.setElementByIndex(1,3, 7);  userMatrix.setElementByIndex(1,4, 1);
  userMatrix.setElementByIndex(2,0, 2);  userMatrix.setElementByIndex(2,1, 4);  userMatrix.setElementByIndex(2,2, 7);  userMatrix.setElementByIndex(2,3, 4);  userMatrix.setElementByIndex(2,4, 2);
  userMatrix.setElementByIndex(3,0, 3);  userMatrix.setElementByIndex(3,1, 8);  userMatrix.setElementByIndex(3,2, 6);  userMatrix.setElementByIndex(3,3, 2);  userMatrix.setElementByIndex(3,4, 7);
  userMatrix.setElementByIndex(4,0, 5);  userMatrix.setElementByIndex(4,1, 2);  userMatrix.setElementByIndex(4,2, 5);  userMatrix.setElementByIndex(4,3, 7);  userMatrix.setElementByIndex(4,4, 4);
  userMatrix.LUDecomposition(L, U, P);

  //Navstupuji konkretni vektor:
  userVector:=TMatrix.create(5,1);

  userVector.setElementByIndex(0,0, 9);  userVector.setElementByIndex(1,0, 1);  userVector.setElementByIndex(2,0, 3);  userVector.setElementByIndex(3,0, 5);  userVector.setElementByIndex(4,0, 7);
  userMatrix.LUDecomposition(L, U, P);
  x := TMatrix.LUequationsSystem(L, U, P, userVector);

  writeln('Vitejte v programku na LU rozklad!!!');
  writeln('Matice A (zadana v kodu): ');
  userMatrix.printElements();
  writeln('');
  writeln('Matice po rozkladu:');
  writeln('Matice U (horni trojuhelnikova): ');
  U.printElements();
  writeln('Matice L (dolni trojuhelnikova): ');
  L.printElements();
  writeln('Matice P (Permutacni matice): ');
  P.printElements();

  writeln();
  writeln('Pro snadnou kontrolu MATLABem:');
  userMatrix.writeMatrixToMATLAB('A = ');
  writeln();
  L.writeMatrixToMATLAB('L = ');
  writeln();
  U.writeMatrixToMATLAB('U = ');
  writeln();
  P.writeMatrixToMATLAB('P = ');
  writeln();
  userVector.writeMatrixToMATLAB('b = ');
  writeln();
  x.writeMatrixToMATLAB('x = ');


  {myMatrix := TMatrix.createRandomMatrix(5,5, 1, 8);
  //myMatrix.setElementByIndex(4,4,8);
  myMatrix.printElements();
  writeln();
  myMatrix.writeMatrixToMATLAB();
  writeln();
  myMatrix.LUDecomposition(L,U,P);
  //myMatrix.LUDecomposition(L, U, P);
  U.printElements();
  writeln('--------');
  L.printElements();
  writeln();
  }
  writeln();
  write('Hotovo!');
  readln;

  // stop program loop
  Terminate;
end;

constructor TLURozklad.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLURozklad.Destroy;
begin
  inherited Destroy;
end;

procedure TLURozklad.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TLURozklad;
begin
  Application:=TLURozklad.Create(nil);
  Application.Title:='LU Rozklad';
  Application.Run;
  Application.Free;
end.

