PROGRAM XmasFire;

(* Check if the number is uneven*)
FUNCTION CheckForOdd(i : INTEGER) : BOOLEAN;
BEGIN
  IF (i MOD 2 <> 0) AND ( i <> 0) THEN CheckForOdd := True ELSE CheckForOdd := False;
    
END;

(* Recursive *)
FUNCTION XFire(len : Integer) : INTEGER;
VAR count : INTEGER;
BEGIN
  count := 0;
  
  IF CheckForOdd(len) THEN 
  BEGIN

    IF len < 3 THEN
      count := count + 3  
    ELSE 
    BEGIN 
        count := count + (len - 3) * 2 ;
        count :=  count + XFire(len-2);
    END;

    XFire := count;
  END
  ELSE
  BEGIN
    Write('Wrong Input!');
    XFire := 0;
  END;
END;

(* Iterative *)
FUNCTION XFire_iterative(len : INTEGER) : INTEGER;
VAR count, temp: INTEGER;
BEGIN

  IF CheckForOdd(len) THEN
  BEGIN
    count := 0;
    temp := len;

    WHILE temp > 1 DO
    BEGIN
      count := count + 1;
      temp := temp - 2;
    END;

    XFire_iterative := 3 + ((len-3) * count);
  END
  ELSE
  BEGIN
    Write('Wrong Input!');
    XFire_iterative := 0;
  END;
END;

VAR word : String;
BEGIN
  WriteLn(chr(205),chr(205),chr(185),' Fire on XMas Tree ',chr(204),chr(205),chr(205)); 
  
  word := '1234';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '123';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '12345';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '1234567';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '123456789';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '12345678901';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
  word := '1234567890123';
  WriteLn('Ways for ',word,': ',XFire(length(word)));
  WriteLn('Ways for ',word,' Iterative: ',XFire_iterative(length(word)));
  
END.