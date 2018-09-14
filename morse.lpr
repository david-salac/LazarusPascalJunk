program morse;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };


function dekodovaniMorzeovyAbecedy(kod:string) : string;
var
  vystup : string;
begin
  { --- ZAPISI SI MORZEOVU ABECEDU JAKO (BEZ)PREFIXOVY KOD --- }

  vystup := StringReplace(kod, '--..--', ',', [rfReplaceAll] ); //S dovolenim ostatni symboly vynecham a to vcetne cislovek


  vystup := StringReplace(vystup, '-...', 'b' , [rfReplaceAll] );
  vystup := StringReplace(vystup, '-.-.', 'c' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '..-.', 'f' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '....', 'h' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '----', 'ch', [rfReplaceAll]);
  vystup := StringReplace(vystup, '.---', 'j' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '.-..', 'l' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '.--.', 'p' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '--.-', 'q' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '...-', 'v' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '-..-', 'x' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '-.--', 'y' , [rfReplaceAll]);
  vystup := StringReplace(vystup, '--..', 'z' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '-..', 'd' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '--.', 'g' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '-.-', 'k' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '---', 'o' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '.-.', 'r' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '...', 's' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '..-', 'u' , [rfReplaceAll]);
  vystup := StringReplace(vystup,  '.--', 'w' , [rfReplaceAll]);
  vystup := StringReplace(vystup,   '.-', 'a' , [rfReplaceAll]);
  vystup := StringReplace(vystup,   '..', 'i' , [rfReplaceAll]);
  vystup := StringReplace(vystup,   '--', 'm' , [rfReplaceAll]);
  vystup := StringReplace(vystup,   '-.', 'n' , [rfReplaceAll]);
  vystup := StringReplace(vystup,    '.', 'e' , [rfReplaceAll]);
  vystup := StringReplace(vystup,    '-', 't' , [rfReplaceAll]);


  { --- VYRESIM PROBLEMY S MEZERAMI --- }
  vystup := StringReplace(vystup, '  ', '*', [rfReplaceAll] );
  vystup := StringReplace(vystup, ' ' , '', [rfReplaceAll] );
  vystup := StringReplace(vystup, '*' , ' ', [rfReplaceAll] );

  dekodovaniMorzeovyAbecedy := vystup;
end;

var
  kod: string;
  soubor: text;
begin
assign(soubor, 'morse.txt');
reset(soubor);
while not eof(soubor) do begin
 read(soubor,kod);

end;
 writeln(dekodovaniMorzeovyAbecedy(kod));


//writeln(dekodovaniMorzeovyAbecedy(kod));

readln();
end.

