PROGRAM patternMatching;

  VAR
    comps : LONGINT;

  FUNCTION EQ(c1,c2 : CHAR) : BOOLEAN;
  BEGIN
    comps := comps + 1;
    EQ := c1 = c2;
  END;

  (* BruteForce Left To Right Two Loops *)
  Procedure BruteForceLR2L(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    pos := 0;
    
    i := 1;
    WHILE (pos = 0) AND (i + pLen - 1 <= sLen) DO BEGIN
      j := 1;
       WHILE (j <= pLen) AND EQ(p[j] , s[i + j - 1]) DO BEGIN
        j := j+1;
       END;
       IF j > pLen THEN
        pos := i;
       i := i+1;
    END;
  END;
  
  (* BruteForce Left To Right One Loops *)
  Procedure BruteForceLR1L(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    
    i := 1;
    j := 1;
    REPEAT
      IF EQ(s[i], p[j]) THEN BEGIN
        i := i+1;
        j := j+1;
      END
      ELSE BEGIN
        i := i -j +1+1;
        j := 1;
      END;
       
    UNTIl (i > sLen) OR (j > pLen);

    IF j > pLen THEN
      pos := i - pLen
    ELSE
      pos := 0;
    
  END;
  
  (* KnuthMorrisPratt1 *)
  Procedure KnuthMorrisPratt1(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
      next : ARRAY[1..255] OF INTEGER;
      
      PROCEDURE InitNext;
        VAR
          i,j :INTEGER;
      BEGIN
        i := 1;
        j := 0;
        next[i] := 0;
        
        WHILE i < pLen DO BEGIN
          IF (j = 0) OR (EQ(p[i],p[j])) THEN BEGIN
            i := i+1;
            j := j+1;
            next[i] := j;
          END
          ELSE BEGIN
            j := next[j];
          END;
        END;
      END;
      
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    InitNext;
    i := 1;
    j := 1;
    REPEAT
      IF (j = 0) OR (EQ(s[i], p[j])) THEN BEGIN
        i := i+1;
        j := j+1;
        
      END
      ELSE BEGIN
        j := next[j];
      END;
       
    UNTIl (i > sLen) OR (j > pLen);

    IF j > pLen THEN
      pos := i - pLen
    ELSE
      pos := 0;
    
  END;
  
   (* KnuthMorrisPratt2 *)
  Procedure KnuthMorrisPratt2(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
      next : ARRAY[1..255] OF INTEGER;
      
      PROCEDURE InitNextImproved;
        VAR
          i,j :INTEGER;
      BEGIN
        i := 1;
        j := 0;
        next[i] := 0;
        
        WHILE i < pLen DO BEGIN
          IF (j = 0) OR (EQ(p[i],p[j])) THEN BEGIN
            i := i+1;
            j := j+1;
            IF NOT EQ(p[i],p[j]) THEN
              next[i] := j
            ELSE
              next[i] := next[j];
          END
          ELSE BEGIN
            j := next[j];
          END;
        END;
      END;
      
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    InitNextImproved;
    i := 1;
    j := 1;
    REPEAT
      IF (j = 0) OR (EQ(s[i], p[j])) THEN BEGIN
        i := i+1;
        j := j+1;
      END
      ELSE BEGIN
         j := next[j];
      END;
       
    UNTIl (i > sLen) OR (j > pLen);

    IF j > pLen THEN
      pos := i - pLen
    ELSE
      pos := 0;
    
  END;
	
	
	(* BruteForce Right To Left One Loops *)
  Procedure BruteForceRL1L(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    
    i := pLen;
    j := pLen;
    REPEAT
      IF EQ(s[i], p[j]) THEN BEGIN
        i := i-1;
        j := j-1;
      END
      ELSE BEGIN
        i := i + pLen - j + 1;
        j := pLen;
      END;
       
    UNTIl (i > sLen) OR (j < 1);

    IF j < 1 THEN
      pos := i + 1
    ELSE
      pos := 0;
    
  END;
  
	(* BoyerMoore *)
  Procedure BoyerMoore(s,p : STRING; Var pos : INTEGER);
    VAR
      sLen, pLen, i, j : INTEGER;
			skip : ARRAY[CHAR] OF INTEGER;
			
			PROCEDURE InitSkip;
			Var
				ch : CHAR;
				j : INTEGER;
		BEGIN
			for ch := Chr(0) to Chr(255) DO BEGIN
				skip[ch] := pLen;
			END;
			
			FOR j := 1 TO pLen DO BEGIN
				skip[p[j]] := pLen - j;
			END;
		END;
			
  BEGIN
    sLen := Length(s);
    pLen := Length(p);
    
    i := pLen;
    j := pLen;
		InitSkip;
		
    REPEAT
      IF EQ(s[i], p[j]) THEN BEGIN
        i := i-1;
        j := j-1;
      END
      ELSE BEGIN
				IF pLen - j + 1 > skip[s[i]] THEN
					i := i + pLen - j + 1
				ELSE
					i := i + skip[s[i]];
				j := pLen;
      END;
       
    UNTIl (i > sLen) OR (j < 1);

    IF j < 1 THEN
      pos := i + 1
    ELSE
      pos := 0;
    
  END;

	PROCEDURE RabinKarp(s,p: STRING; VAR pos : INTEGER);
		CONST
			d = 256; (* Number of char in charset *)
			q = 8355967; (* Prime, size of virtual hash table *)
		VAR
			hp: LONGINT; (* hash value of pattern *)
			hs : LONGINT; (* hash value of pLen substring of s *)
			dp: LONGINT; (* d power, needed for hash function *)
			
			sLen, pLen : INTEGER;
			j,i,k : INTEGER;
			iMax : Integer;
	BEGIN
		sLen := Length(s);
		pLen := Length(p);
		(* Calculate initial hash values *)
		hp := 0; hs := 0;
		
		FOR j := 1 TO pLen DO BEGIN
			hp := (hp * d + Ord(p[j])) MOD q;
			hs := (hs * d + Ord(s[j])) MOD q;
		END;
		
		(* calculatr Power *)
		dp := 1;
		FOR i := 1 TO pLen -1 DO BEGIN
			dp := (dp * d) MOD q;
		END;
		
		j := 1; i := 1;
		iMax := sLen - pLen +1;
		WHILE (i <= iMax)  AND (j <= pLen) DO BEGIN
		
			IF (hs = hp) THEN BEGIN
				(* check char by char *)
				j := 1;
				k := i;
				WHILE (j <= pLen) AND EQ(p[j],s[k]) DO BEGIN
					j := j + 1;
					k := k + 1;
				END;
			END;
			(* calculate new hash value *)
			hs := (hs + d * q - Ord(s[i]) * dp) MOD q; (* remove value for first char *)
			hs := (hs * d + Ord(s[i+pLen])) MOD q; (* add value for new character on the right *)
			i :=  i + 1;
		END;
		
		IF (i > iMax) AND (j <= pLen) THEN
			pos := 0
		ELSE
			pos := i-1;
	END;
	
  VAR
    s,p : String;
    pos : INTEGER;
    
BEGIN
  s := 'aadfacdafkjlccdcdxaabcdcd';
  p := 'aabcdcd';
  
  comps := 0;
  BruteForceLR2L(s,p,pos);
  writeln('BruteForceLR2L pos: ',pos , ' comps: ', comps);
  
  comps := 0;
  BruteForceLR1L(s,p,pos);
  writeln('BruteForceLR1L pos: ',pos , ' comps: ', comps);
  
  
  comps := 0;
  KnuthMorrisPratt1(s,p,pos);
  writeln('KnuthMorrisPratt1 pos: ',pos , ' comps: ', comps);
	
  comps := 0;
  KnuthMorrisPratt2(s,p,pos);
  writeln('KnuthMorrisPratt2 pos: ',pos , ' comps: ', comps);
	
	comps := 0;
  BruteForceRL1L(s,p,pos);
  writeln('BruteForceRL1L pos: ',pos , ' comps: ', comps);
	
	comps := 0;
  BoyerMoore(s,p,pos);
  writeln('BoyerMoore pos: ',pos , ' comps: ', comps);
	
	comps := 0;
  RabinKarp(s,p,pos);
  writeln('RabinKarp pos: ',pos , ' comps: ', comps);

END.