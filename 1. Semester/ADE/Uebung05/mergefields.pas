program mergefields;

(*gibt ein array auf der konsole aus*)
procedure printArray(a : ARRAY OF INTEGER);
var i : INTEGER;
begin
  for i := 0 to length(a)-1 do
    Write(a[i], ' ');
  WriteLn();
end;

(*setzt alle elemente in einem array auf 0*)
procedure clearArray(var a : ARRAY OF INTEGER);
var i : INTEGER;
begin
  for i := 0 to length(a)-1 do
    a[i] := 0;
end;

PROCEDURE Merge(a1, a2: ARRAY OF INTEGER; VAR a3: ARRAY OF INTEGER; VAR n3: INTEGER); 
var i,i2,i3,i4,count : INTEGER;
var found : Boolean;
BEGIN
  count := 0;
  found := False;
  n3 := 0;

  (*schreibt alle unterschiedlichen elemente von a1 und a2 aus a1 in a3*)
  FOR i := 0 TO length(a1)-1 DO BEGIN
    FOR i2 := 0 TO length(a2)-1 DO BEGIN
      IF a2[i2] = a1[i] THEN 
        found := True;
    END;
    IF found = False then
    BEGIN
      a3[count] := a1[i];
      count := count + 1;
      n3 := n3 + 1;
    END;
    found := False;
  END;

  (*schreibt alle unterschiedlichen elemente aus a1 und a2 aus a2 geordnet in a3*)
  FOR i := 0 TO length(a2)-1 DO BEGIN
    FOR i2 := 0 TO length(a1)-1 DO BEGIN
      IF a1[i2] = a2[i] THEN
        found := True;
    END;

    IF found = False THEN
      FOR i3 := 0 TO length(a3)-1 DO
        IF (a2[i] <= a3[i3]) OR ((a2[i] >= a3[i3]) AND (a3[i3] = 0))THEN 
        BEGIN
          FOR i4 := length(a3)-1 DOWNTO i3+1 DO
            a3[i4] := a3[i4-1];

          a3[i3] := a2[i];  
          n3 := n3 + 1;
          break;        
        END;
    found := false;
  END; 
END;

var a1 : ARRAY [1 .. 6] OF INTEGER;
var a2 : ARRAY [1 .. 4] OF INTEGER;
var a3 : ARRAY [1 .. (length(a1) + length(a2))] OF INTEGER;
var n3 : INTEGER;

BEGIN
a1[1] := 1;
a1[2] := 2;
a1[3] := 3;
a1[4] := 4;
a1[5] := 5;
a1[6] := 6;

a2[1] := 7;
a2[2] := 8;
a2[3] := 9;
a2[4] := 10;

Merge(a1,a2,a3,n3);

printArray(a1);
printArray(a2);
printArray(a3);
WriteLn('n3: ',n3,#13#10);

clearArray(a3);

a1[1] := 2;
a1[2] := 4;
a1[3] := 4;
a1[4] := 10;
a1[5] := 15;
a1[6] := 15;

a2[1] := 2;
a2[2] := 4;
a2[3] := 5;
a2[4] := 10;

Merge(a1,a2,a3,n3);

printArray(a1);
printArray(a2);
printArray(a3);
WriteLn('n3: ',n3,#13#10);
END.