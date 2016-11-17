(*$B+*)
PROGRAM search;
  (*1 und -1 Stellen den Wahrheitswert dar*)
  FUNCTION IsElement(a: ARRAY OF INTEGER; x: INTEGER): Integer;
    VAR
      i: INTEGER;
    BEGIN
      FOR i := 0 to High(a) DO
        IF a[i] = x THEN Exit(1);

      IsElement := -1;
    END;
    
VAR arr: ARRAY [1 .. 5] OF INTEGER;
BEGIN
  arr[1] := 3;
  arr[2] := 4;
  arr[3] := 7;
  arr[4] := 1;
  arr[5] := 8;
  
  WriteLn(chr(205),chr(205),chr(185),' SearchAltered ',chr(204),chr(205),chr(205));  
  WriteLn(IsElement(arr, 8));
  WriteLn(IsElement(arr, 10));
END.