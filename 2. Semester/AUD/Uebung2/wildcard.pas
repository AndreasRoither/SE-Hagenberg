PROGRAM wildcard;

(* Matching Going from the left to right 
   recursive *)
  FUNCTION Matching(p, s : STRING):Boolean;
	VAR 
		i,j:Integer;
  BEGIN
	i := 1;
	j := 1;
  
  (* *)
    WHILE (p[j] <> '*') AND (j <= length(p)) AND ((s[i] = p[j]) OR 
			(p[j] = '?')) DO BEGIN
		i := i + 1;
		j := j + 1;
    END;

    IF (p[j] <> '*') AND (i <= length(s)) THEN BEGIN
		Matching := Matching(p,Copy(s,2,length(s)))
    END
    ELSE IF (j <= length(p)) AND (i <= length(s)) THEN BEGIN
		Matching := Matching(Copy(p, j + 1, Length(p)),Copy(s, 2, length(s)));
    END 
    ELSE IF ((j >= length(p)) AND (i >= length(s))) OR 
			((j = length(p)) AND (p[j] = '*')) THEN BEGIN
		Matching := True;
    END
    ELSE Begin
		Matching := False;
    END;
  END;
  VAR
	s,p : STRING;
BEGIN
	s := '?c?$';
	p := 'aca$';
	
	IF Matching(s, p) THEN WriteLn(s, ' and ', p, #9#9, ' True')
	ELSE WriteLn(s, ' and ', p, #9, ' False');

	s := '?c?$';
	p := 'acasdfa$';
	IF Matching(s, p) THEN WriteLn(s, ' and ', p, #9, ' True')
	ELSE WriteLn(s, ' and ', p, #9, ' False');
	
	s := '*c?$';
	p := 'asssssca$';
	IF Matching(s, p) THEN WriteLn(s, ' and ', p, #9, ' True')
	ELSE WriteLn(s, ' and ', p, #9, ' False');
	
	s := '?c*$';
	p := 'acaaaaaaaaaa$';
	IF Matching(s, p) THEN WriteLn(s, ' and ', p, #9, ' True')
	ELSE WriteLn(s, ' and ', p, #9,' False');
	
	s := '?*c*?$';
	p := 'aabbacaba$';
	IF Matching(s, p) THEN WriteLn(s, ' and ', p, #9, ' True')
	ELSE WriteLn(s, ' and ', p, #9,' False');
END.