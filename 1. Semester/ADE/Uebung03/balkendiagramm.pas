program balkendiagramm;
var a1,a2,b1,b2,c1,c2,d1,d2,e1,e2,f1,f2 : Integer;

(*Integer auf oder abrunden*)
function round(num: Integer) : Integer;
var temp, temp2 : Integer;
begin
  temp := abs(num);
  
  if num mod 10 >= 5 then temp2 := 1 else temp2 := 0;
  
  round := (temp div 10) + temp2;
end;

(*Zeile für einen Politiker*)
function printGraph(a, b : Integer) : String;
var i: Integer;

begin
  for i := 1 to 10 - round(a) do Write(' ');
  for i := 1 to round(a) do Write('X');
  
  Write(' | ');

  for i := 1 to round(b) do Write('X');
  for i := round(b) to 10 do Write(' ');   
end;

begin
  WriteLn('-- Balkendiagramm --');
  WriteLn('Geben Sie die Zahlen ein: ');
  Read(a1,a2,b1,b2,c1,c2,d1,d2,e1,e2,f1,f2);

  (*Ueberpruefung der Eingabe*)
  if (abs(a1)+a2 > 100) or (abs(b1)+b2 > 100) or (abs(c1)+c2 > 100) or (abs(d1)+d2 > 100) or (abs(e1)+e2 > 100) or (abs(f1)+f2 > 100) then
    WriteLn('Eingabe zweier Zahlen groeser als 100')
  else
  begin
    (*Ausgabe der Zeilen für jeden Politiker*)
    WriteLn('   negativ     positiv',#13#10,'-----------+-------------');
    WriteLn('1',printGraph(a1,a2));
    WriteLn('2',printGraph(b1,b2));
    WriteLn('3',printGraph(c1,c2));
    WriteLn('4',printGraph(d1,d2));
    WriteLn('5',printGraph(e1,e2));
    WriteLn('6',printGraph(f1,f2));
  end;
end.  