PROGRAM quadratwurzel_new;

PROCEDURE Naeherung(VAR y0,y1, r_digit : REAL);
BEGIN
  y0 := y1;
  y1 := (y0 + (r_digit / y0))/2;
END;

VAR r_digit, approx_error, y0, y1: REAL;
VAR count: INTEGER;
BEGIN
  WriteLn(chr(205),chr(205),chr(185),' Quadratwurzel_new ',chr(204),chr(205),chr(205));  
  WriteLn('Reelle Zahl eingeben: ');
  Read(r_digit);
  Write(#13);
  Write('Fehlerschranke eingeben: ');
  Read(approx_error);
  Write('-------------------', #13#10); 
  
  IF r_digit <= 0 THEN
    Write('Fehler: erste Eingabe kleiner als 0', #13#10);
  IF approx_error = 0 THEN
    Write('Fehler: Fehlerschranke ist 0', #13#10)
  ELSE BEGIN
    y1 := 1;
    y0 := 1;
    count := 0;
    WHILE (count < 50) AND (abs(y1 - y0) >= approx_error) DO 
    BEGIN
      Naeherung(y0,y1,r_digit);
      count := count + 1;
    END; 
  END;

  IF count = 50 THEN
    Write('Fehler: Nach 50 Iterationen keine Konvergenz gefunden')
  ELSE
    Write('Naeherung: ', y1, ' nach ', count, ' Iterationen');

  Write(#13#10);
END.