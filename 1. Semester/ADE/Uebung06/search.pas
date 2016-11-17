(*$B+*)
PROGRAM search;
  FUNCTION IsElement(a: ARRAY OF INTEGER; x: INTEGER): BOOLEAN;
    VAR
      i: INTEGER;
    BEGIN
      i := 0;
      WHILE (i <= High(a)) AND (a[i] <> x) DO
      BEGIN
        i := i + 1;
      END;
      
      IsElement := (i <= High(a));
    END;
    
VAR arr: ARRAY [1 .. 5] OF INTEGER;
BEGIN
  arr[1] := 3;
  arr[2] := 4;
  arr[3] := 7;
  arr[4] := 1;
  arr[5] := 8;
  
  WriteLn(chr(205),chr(205),chr(185),' SearchOriginal ',chr(204),chr(205),chr(205));  
  WriteLn(IsElement(arr, 8));
  WriteLn(IsElement(arr, 10));
END.