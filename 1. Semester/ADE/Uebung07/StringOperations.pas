PROGRAM StringOperations;

(*Zeichen von einem String werden in einen anderen String kopiert
  Dabei wird von der groessten Stelle runtergezaehlt und das jeweilige
  Zeichen kopiert*)
FUNCTION Reversed(s : String): String;
VAR rev: STRING;
VAR i : INTEGER;
BEGIN
  rev := '';
  FOR i := Length(s) DOWNTO 1 DO
  BEGIN
   rev := Concat(rev, s[i]);
  END;
  Reversed := rev;
END;

(*StripBlanks kopiert nur ein Zeichen in einen anderen String wenn
  dieses Zeichen kein Leerzeichen ist*)
PROCEDURE StripBlanks(VAR s : STRING);
VAR i : INTEGER;
VAR s_new : STRING;
BEGIN
  s_new := '';
  FOR i := 1 TO Length(s) DO
  BEGIN
    IF s[i] <> ' ' THEN 
    BEGIN
      s_new := Concat(s_new, s[i]);
    END;
  END;
  s := s_new;
END;

(*ReplaceAll ersetzt alle vorkommende Strings
  dabei wird immer ein neuer subString erstellt dieser wird 
  wieder überprueft ob old darin vorkommt.*)
PROCEDURE ReplaceAll(old, _new : STRING; VAR s : STRING);
VAR Position, count : INTEGER;
VAR result, subString : STRING;
BEGIN
  Position := Pos(old,s);
  IF Position <> 0 THEN
  BEGIN
    result := '';
    count := 0;
    result := Concat(result,Copy(s,1,Position-1));
    
    WHILE Position <> 0 DO
    BEGIN
    
      result := concat(result,_new);
      subString := Copy(s,(count + Position + length(old)), Length(s));
      count := count + Position + length(old)-1;
      Position := Pos(old, subString);
      result := Concat(result,Copy(subString,1,Position-1));
      
    END;
    s := result + subString;
  END;
END;

VAR s, old, _new : STRING;
BEGIN

  WriteLn(chr(205),chr(205),chr(185),' StringOperations ',chr(204),chr(205),chr(205));  
  WriteLn('Reverse:');
  s := 'Hal lo';
  WriteLn('Hal lo: ',Reversed(s),#13#10);
  
  WriteLn('StripBlanks:');
  StripBlanks(s);
  WriteLn('Hal lo: ', s,#13#10);
  
  WriteLn('ReplaceAll:');
  s := 'Test Hallo das das hierdasenthalten';
  WriteLn(s);
  ReplaceAll('das','der',s);
  WriteLn(s);
  ReplaceAll('der','der das',s);
  WriteLn(s);
END.