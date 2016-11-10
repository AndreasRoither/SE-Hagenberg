program balkendiagramm_redone;

(*Integer auf oder abrunden*)
function round(num: Integer) : Integer;
var temp, temp2 : Integer;
begin
  temp := abs(num);
  
  if num mod 10 >= 5 then temp2 := 1 else temp2 := 0;
  
  round := (temp div 10) + temp2;
end;

(*Zeile fuer einen Politiker mit String*)
function printGraph(a, b, pol_count : Integer) : String;
var i: Integer;
var s: String;
begin
  s := '';
  str(pol_count,s);
  s := Concat(s,':');

  for i := 1 to 10 - round(a) do s := Concat(s, ' ');
  for i := 1 to round(a) do s := Concat(s, 'X');
  
  s := Concat(s, '|');

  for i := 1 to round(b) do s := Concat(s, 'X');
  for i := round(b) to 10 do s := Concat(s, ' ');   

  (*Anfügen eines NewLine Characters an den String*)
  s := Concat(s, chr(10));
  
  printGraph := s;
end;

var anzahl, i, neg, pos : Integer;
var result : string;
begin
  result := '';
  anzahl := 0;
  
  WriteLn('-- Balkendiagramm Redone --');
  Write('Geben Sie die Anzahl der Politiker ein: ');
  Read(anzahl);
  
  if( anzahl >= 2 ) and (anzahl <= 40) then 
  begin
    (*Für beliebiege Anzahl Politiker wird eingelesen und die Werte, falls gültig,
    verarbeitet und in einem String gespeichert*)
    for i := 1 to anzahl do
    begin
      Write('Negativ und Positiv Zahlen fuer Politiker ',i,': ');
      ReadLn(neg, pos);
      if abs(neg) + pos <= 100 then 
        result := Concat(result, printGraph(abs(neg),pos,i))
      else WriteLn('Summer groesser 100 fuer Politiker ',i);
    end;
    WriteLn(result);
  end
  else 
    WriteLn('Keine gueltige Angabe');
end.  