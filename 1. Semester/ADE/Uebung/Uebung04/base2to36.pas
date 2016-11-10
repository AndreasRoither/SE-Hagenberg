program base2to36;

(*String mit Characters die verwendet werden dürfen*)
const possibleCharacters : String = '0123456789ABCDEFGHIJKLMNOPRRSTUVWXYZ';

(*Funktion für x^y*)
function powerFn (number, expo: Real): Real; 
begin 
powerFn := Exp(Expo*Ln(Number)); 
end; 

(*Liefert Position des gesuchten Elementes in einem String zurück*)
function getPosofElement (e : char; s : string): Integer;
var i, count : Integer;
begin 
  count := 0;
  
  for i := 1 to Length(s) do
    if e = s[i] then exit(count)
    else count := count +1;
    
  getPosofElement := count;
end; 

(*Ueberprueft ob ein Zeichen in einem String vorhanden ist*)
function stringContains(digits : string; c2 : char): Boolean;
var i : Integer;
begin
  for i := 1 to Length(digits) do begin
    if digits[i] = c2 then exit(True);
  end;
  stringContains := False;
end;

(*Gueltigkeitsueberpruefung ob für die jeweilige Basis die erlaubten Zeichen im String enthalten sind*)
function checkIfValid(digits: String; base: Integer; var count: Integer): Boolean;
var i : Integer;
begin
  count := 0;
  if (base >= 2) and (base <= 36) then 
  begin
    for i := 1 + base to 36 do
    begin
      if stringContains(digits, possibleCharacters[i]) then exit(False);
    end;
    checkIfValid := True;
  end
  else
  checkIfValid := False; 
end;

(*Liefert den Wert des String Inhaltes von beliebieger Basis in Basis 10 zurück*)
function ValueOf(digits: String; base: Integer): Integer;
var count, i, expo : Integer;
var value : Real;
begin
  if checkIfValid(digits, base, count) then begin
    value := 0;
    expo := 0;

    for i:= Length(digits) downto 1 do begin
      value := value + getPosofElement(digits[i],possibleCharacters) * powerFn(base,expo);
      expo := expo + 1;
    end
  end
  else
    exit(-1);

  ValueOf := Trunc(value);
end;

(*Liefert String mit Ziffernfolge für beliebige Basis*)
function DigitsOf(value: Integer; base: Integer): string;
var result : string;
begin
  result := '';
  if value < 0 then DigitsOf := 'ERROR'
  else
  begin
    while value > 0 do 
    begin
      (*an den String wird ein Zeichen mit einer bestimmten Wertigekeit in der Basis 10 angehängt*)
      if value mod base > 0 then result := Concat(possibleCharacters[(value mod base)+1], result);

      value := value DIV base;
    end;
  end;
  DigitsOf := result;
end;

function sum(d1: STRING; b1: INTEGER; d2: STRING; b2: INTEGER): INTEGER; 
begin
  sum := ValueOf(d1,b1) + ValueOf(d2,b2);
end;

function diff(d1: STRING; b1: INTEGER; d2: STRING; b2: INTEGER): INTEGER; 
begin
  diff := ValueOf(d1,b1) - ValueOf(d2,b2);
end;

function prod(d1: STRING; b1: INTEGER; d2: STRING; b2: INTEGER): INTEGER; 
begin
  prod := ValueOf(d1,b1) * ValueOf(d2,b2);
end;
function quot(d1: STRING; b1: INTEGER; d2: STRING; b2: INTEGER): INTEGER; 
begin
  quot := ValueOf(d1,b1) div ValueOf(d2,b2);
end;

begin
  WriteLn('-- base2to36 --');
  WriteLn('ValueOf');
  WriteLn('23672 Basis 10');
  WriteLn(ValueOf('23672',10));
  WriteLn('4DF8 Basis 17');
  WriteLn(ValueOf('4DF8',17));
  WriteLn('1LH5 Basis 23');
  WriteLn(ValueOf('1LH5',23));
  
  WriteLn('DigitsOf');
  WriteLn('23672 Basis 28');
  WriteLn(DigitsOf(23672,28));
  
  WriteLn('diff of 1234 in Basis 12');
  WriteLn(diff('1234',12,'1234',12));

  WriteLn('prod of 1234 in Basis 12');
  WriteLn(prod('1234',12,'1234',12));

  WriteLn('Sum of 1234 in Basis 12');
  WriteLn(sum('1234',12,'1234',12));

  WriteLn('quot of 1234 in Basis 12');
  WriteLn(quot('1234',12,'1234',12));
end.