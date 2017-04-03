PROGRAM wildcard;

(* Going from the right to left *)
FUNCTION Matching(p, s : STRING):Boolean;
  VAR 
	i,j:Integer;
BEGIN
  i:=length(s);
  j:=length(p);
  
  (* *)
  WHILE (p[j] <> '*') AND (j >= 1) AND ((s[i] = p[j]) OR (p[j] = '?')) DO BEGIN
    i := i - 1;
    j := j - 1;
  END;

  IF (p[j] <> '*') AND (i >= 1) THEN BEGIN
    Matching:=Matching(p,Copy(s,1,length(s)-1))
  END
  ELSE IF (j >= 1) AND (i >= 1) THEN BEGIN
    Matching:=Matching(Copy(p, 1, j - 1),Copy(s, 1, i));
  END 
  ELSE IF ((j < 1) AND (i < 1)) OR ((j = 1) AND (p[j] = '*')) THEN BEGIN
    Matching:=True;
  END
  ELSE Begin
    Matching:=False;
  END;
END;

(* Going from the left to right *)
FUNCTION Matching2(p, s : STRING):Boolean;
  VAR 
	i,j:Integer;
BEGIN
  i := 1;
  j := 1;
  
  (* *)
  WHILE (p[j] <> '*') AND (j <= length(p)) AND ((s[i] = p[j]) OR (p[j] = '?')) DO BEGIN
    i := i + 1;
    j := j + 1;
  END;

  IF (p[j] <> '*') AND (i <= length(s)) THEN BEGIN
    Matching2 := Matching2(p,Copy(s,2,length(s)))
  END
  ELSE IF (j <= length(p)) AND (i <= length(s)) THEN BEGIN
    Matching2 := Matching2(Copy(p, j + 1, Length(p)),Copy(s, 2, length(s)));
  END 
  ELSE IF ((j >= length(p)) AND (i >= length(s))) OR ((j = length(p)) AND (p[j] = '*')) THEN BEGIN
    Matching2 := True;
  END
  ELSE Begin
    Matching2 := False;
  END;
END;

BEGIN
	IF Matching('?c?$', 'aca$') THEN WriteLn('True')
	ELSE WriteLn('False');
	IF Matching2('?c?$', 'aca$') THEN WriteLn('True')
	ELSE WriteLn('False');

	IF Matching('?c?$', 'acasdfa$') THEN WriteLn('True')
	ELSE WriteLn('False');
	IF Matching2('?c?$', 'acasdfa$') THEN WriteLn('True')
	ELSE WriteLn('False');
	
	IF Matching('*c?$', 'asssssca$') THEN WriteLn('True')
	ELSE WriteLn('False');
	IF Matching2('*c?$', 'asssssca$') THEN WriteLn('True')
	ELSE WriteLn('False');
	
	IF Matching('?c*$', 'acaaaaaaaaaa$') THEN WriteLn('True')
	ELSE WriteLn('False');
	IF Matching2('?c*$', 'acaaaaaaaaaa$') THEN WriteLn('True')
	ELSE WriteLn('False');
	
	IF Matching('?*c*?$', 'aabbacaba$') THEN WriteLn('True')
	ELSE WriteLn('False');
	IF Matching2('?*c*?$', 'aabbacaba$') THEN WriteLn('True')
	ELSE WriteLn('False');
END.