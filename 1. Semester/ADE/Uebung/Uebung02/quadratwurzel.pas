program quadratwurzel;
var r_digit, approx_error, y0, y1: Real;
var count: Integer;
begin
  Write('-- Quadratwurzel --', #13#10 ,'Reelle Zahl eingeben: ');
  Read(r_digit);
  Write(#13);
  Write('Fehlerschranke eingeben: ');
  Read(approx_error);
  Write('-------------------', #13#10); 
  
  if r_digit <= 0 then
    Write('Fehler: erste Eingabe kleiner als 0', #13#10); (*#10#13 sind Steuerbefehle für die Konsole*)
    
  if approx_error = 0 then
    Write('Fehler: Fehlerschranke ist 0', #13#10)
    
  else
    begin
      y1 := 1; (*Startwert*)
      count := 0;
      repeat 
        y0 := y1;
        y1 := (y0 + (r_digit / y0))/2;
        count := count + 1;
        (*Abbruch der Schleife nach 50 Iterationen*)
      until (abs(y1 - y0) <= approx_error) or (count = 50);
      
      if count = 50 then
        Write('Fehler: Nach 50 Iterationen keine Konvergenz gefunden')
      else begin
        Write('Naeherung: ', y1, ' nach ', count, ' Iterationen');
      end;
    end;
    Write(#13#10);
end.



