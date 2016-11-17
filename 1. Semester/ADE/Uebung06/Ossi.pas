PROGRAM Ossi;
  TYPE
    Person = (anton, berta, clemens, doris);
    Visitors = ARRAY[Person] OF BOOLEAN;
  
  VAR
    v: Visitors; (*v[p] = TRUE ? person p will attend Ossis party*)
    a, b, c, d: BOOLEAN;
  FUNCTION Valid(v: Visitors): BOOLEAN;
  BEGIN
    (*Alle negativ kriterien, bei denen Valid nicht stimmt*)
    IF NOT v[anton] AND NOT v[clemens] AND NOT v[doris] AND NOT v[doris] THEN exit(False);
    IF v[anton] AND v[doris] THEN exit(False);
    IF v[anton] AND v[clemens] AND v[berta] THEN exit(False);
    IF v[berta] AND NOT v[clemens] THEN exit(False);
    IF NOT v[anton] AND v[clemens] AND v[doris] THEN exit(False); 
    Valid := True;
  END;

BEGIN
  FOR a := FALSE TO TRUE DO BEGIN 
    v[anton] := a; 
    FOR b := FALSE TO TRUE DO BEGIN
      v[berta] := b;       
      FOR c := FALSE TO TRUE DO BEGIN 
        v[clemens] := c;         
        FOR d := FALSE TO TRUE DO BEGIN 
          v[doris] := d;           
          IF Valid(v) THEN BEGIN             
            WriteLn(chr(205),chr(205),chr(185),' Valid ',chr(204),chr(205),chr(205));  
            WriteLn('Anton:   ',v[anton]);
            WriteLn('Berta:   ',v[berta]);
            WriteLn('Clemens: ',v[clemens]);
            WriteLn('Doris:   ',v[doris],#13#10);
          END; (*IF*)
        END; (*FOR*)
      END; (*FOR*)
    END; (*FOR*)
  END; (*FOR*)
END. (*Ossi*) 
