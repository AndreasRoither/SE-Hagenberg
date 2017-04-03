PROGRAM wildcard;
uses Crt, Timer;

  VAR
    comps : LONGINT;

  (* Compares two char
	 Returns true if chars equal *)
  FUNCTION EQ(c1,c2 : CHAR) : BOOLEAN;
  BEGIN
    comps := comps + 1;
	IF c1 = '?' THEN EQ := TRUE
	ELSE EQ := c1 = c2;
  END;
  
  (* Check for a char in a string
     recursive 
	 Returns true if char is in the string *)
  FUNCTION Matching(p : CHAR; s : STRING; VAR i : INTEGER) : Boolean;
  BEGIN
	IF s <> '' THEN
	BEGIN
		i := i + 1;
		IF EQ(p, s[1]) THEN Matching := TRUE
		ELSE Matching := Matching(p, Copy(s,2,Length(s)), i);
	END
	ELSE
		Matching := FALSE; 
  END;
  
  (* BruteForce Left To Right One Loop
     with recursive matching *)
  Procedure BruteForceLR1L(s,p : STRING; Var pos1, pos2 : INTEGER);
    VAR
      sLen, pLen, i, j, iterations, qcount : INTEGER;
	  found : Boolean;
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    
	iterations := 0;
	qcount := 0;
    i := 1;
    j := 1;
    REPEAT
	  IF p[j] = '?' THEN BEGIN
		i := i + 1;
		j := j + 1;
		qcount := qcount + 1;
	  END
	  ELSE IF p[j] = '*' THEN BEGIN
		WHILE (j < pLen) AND ((p[j] = '*') OR (p[j] = '?')) DO 
		BEGIN
			IF p[j] = '*' THEN j := j + 1
			ELSE IF p[j] = '?' THEN BEGIN
				i := i + 1;
				j := j + 1;
				qcount := qcount + 1;
			END;
		END;
		
		IF p[j] = '*' THEN 
		BEGIN
			iterations := sLen - i;
			i := sLen + 1;
			j := pLen + 1;
		END
		ELSE BEGIN
			IF NOT Matching(p[j], Copy(s,i,sLen), iterations) THEN 
			BEGIN
				i := sLen + 1;
				break;
			END
			ELSE
			BEGIN
				i := i + iterations;
				j := j + 1;
			END;
		END;
	  END
      ELSE IF EQ(s[i], p[j]) THEN BEGIN
        i := i + 1;
        j := j + 1;
		qcount := qcount + 1;
      END
      ELSE BEGIN
        i := i -j + 1 + 1;
        j := 1;
      END;
       
    UNTIl (i > sLen) OR (j > pLen);
	
	IF (iterations <> 0) AND (j > pLen) THEN BEGIN
		pos1 := i - iterations - qcount;
		pos2 := i - 1;
	END
    ELSE IF j > pLen THEN
	BEGIN
      pos1 := i - pLen;
	  pos2 := i - 1;
	END
    ELSE
	BEGIN
      pos1 := 0;
	  pos2 := 0;
	END;
  END;
  
    (* BruteForce Left To Right One Loop
	   iterative matching*)
  Procedure BruteForceLR1LIt(s,p : STRING; Var pos1, pos2 : INTEGER);
    VAR
      sLen, pLen, i, j, iterations, qcount : INTEGER;
	  found : Boolean;
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    
	iterations := 0;
	qcount := 0;
    i := 1;
    j := 1;
    REPEAT
	  IF p[j] = '?' THEN BEGIN
		i := i + 1;
		j := j + 1;
		qcount := qcount + 1;
	  END
	  ELSE IF p[j] = '*' THEN BEGIN
		WHILE (j < pLen) AND ((p[j] = '*') OR (p[j] = '?')) DO 
		BEGIN
			IF p[j] = '*' THEN j := j + 1
			ELSE IF p[j] = '?' THEN BEGIN
				i := i + 1;
				j := j + 1;
				qcount := qcount + 1;
			END;
		END;
		
		IF p[j] = '*' THEN 
		BEGIN
			iterations := sLen - i;
			i := sLen + 1;
			j := pLen + 1;
		END
		ELSE BEGIN
			
			WHILE (NOT EQ(s[i], p[j])) AND (i < sLen) DO BEGIN
				i := i + 1;
				iterations := iterations + 1;
			END;
			
			IF i = sLen THEN i := sLen + 1;
		END;
	  END
      ELSE IF EQ(s[i], p[j]) THEN BEGIN
        i := i + 1;
        j := j + 1;
		qcount := qcount + 1;
      END
      ELSE BEGIN
        i := i -j + 1 + 1;
        j := 1;
      END;
       
    UNTIl (i > sLen) OR (j > pLen);
	
	IF (iterations <> 0) AND (j > pLen) THEN BEGIN
		pos1 := i - iterations - qcount;
		pos2 := i - 1;
	END
    ELSE IF j > pLen THEN
	BEGIN
      pos1 := i - pLen;
	  pos2 := i - 1;
	END
    ELSE
	BEGIN
      pos1 := 0;
	  pos2 := 0;
	END;
  END;
  
  (*Highlighting Text with green*
    Prints out normal if conditions not met *)
  PROCEDURE HighlightPart(s: STRING; fromPos, toPos: Integer);
  VAR
	i : Integer;
  BEGIN
	IF (fromPos <> 0) AND (toPos >= fromPos)  THEN BEGIN
		Write('  ');
		FOR i := 1 TO Length(s) DO BEGIN
			IF (i >= fromPos) AND (i <= toPos) THEN BEGIN
				TextColor(Green);
				Write(s[i]);
			END
			ELSE BEGIN
				TextColor(LightGray);
				Write(s[i]);
			END;
			
		END;
		TextBackground(Black);
		TextColor(LightGray);
	END ELSE
		Write('  ', s);
		
	WriteLn;
  END;
  
  VAR
    s,p : String;
    pos1, pos2 : INTEGER;
  
BEGIN
  s := 'aabbccddeeffgaaaeghhaXeasdflkasdfl';
  p := 'a*e';
  pos1 := 0;
  pos2 := 0;
  
  (* recursive *)
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  
  p := 'b**e';
  
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  
  p := 'X**z';
  
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  
  p := 'b*?e';
  
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  
  p := '??e';
  
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  WriteLn('elapsed time:    ', ElapsedTime, #13#10);
  
  p := '?*?a';
  
  comps := 0;
  BruteForceLR1L(s,p,pos1,pos2);
  writeln('BruteForceLR1L:', #13#10, '  pos: from ', pos1, ' - ', pos2, #13#10, '  comps: ', comps);
  WriteLn('  ', p);
  HighlightPart(s,pos1,pos2);
  WriteLn('elapsed time:    ', ElapsedTime, #13#10);
  
  
END.