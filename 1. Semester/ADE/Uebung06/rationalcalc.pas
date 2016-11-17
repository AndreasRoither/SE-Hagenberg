PROGRAM rationalcalc;

  TYPE
    Rational = RECORD
      num, denom: INTEGER;
    END;
    
  (* Function to get the greatest common dvisor *)
FUNCTION ggT (a,b : INTEGER) : INTEGER;
VAR remainder: INTEGER;
BEGIN
  WHILE NOT (b=0) DO
  BEGIN
    remainder := a MOD b;
    a := b;
    b := remainder;
  END;
  ggT :=a;
END;

(* Proc to simplify given Rational *)
PROCEDURE simplify(Var a : Rational);
var divisor : Integer;
begin
  divisor := ggT(a.num, a.denom);
  a.num := a.num div divisor;
  a.denom := a.denom div divisor;
end;
  
  PROCEDURE rationalAdd(a, b: Rational; VAR c: Rational);
  BEGIN
    IF NOT (a.denom = b.denom) THEN 
    BEGIN
      c.num := a.num * b.denom + b.num * a.denom;
      c.denom := a.denom * b.denom ;
    END
    ELSE
    BEGIN
      c.num := a.num + b.num;
      c.denom := a.denom;
    END;
    simplify(c);
  END;
  
  PROCEDURE rationalSub(a, b: Rational; VAR c: Rational);
  BEGIN
    IF NOT (a.denom = b.denom) THEN 
    BEGIN
      c.num := a.num * b.denom - b.num * a.denom;
      c.denom := a.denom * b.denom ;
    END
    ELSE BEGIN
      c.num := a.num - b.num;
      c.denom := a.denom;
    END;
    simplify(c);
  END;
  
  PROCEDURE rationalMult(a, b: Rational; VAR c: Rational);
  BEGIN   
    c.num := a.num * b.num;
    c.denom := a.denom * b.denom;

    simplify(c);
  END;
  
  PROCEDURE rationalDiv(a, b: Rational; VAR c: Rational);
  BEGIN
    c.num := a.num * b.denom;
    c.denom := a.denom * b.num;
    simplify(c);
  END;
  
  (*Liest a und b ein*)
  PROCEDURE input(VAR a, b: Rational);
  BEGIN
  REPEAT
    Write('a num: ');
    ReadLn(a.num);
    Write('a denom: ');
    ReadLn(a.denom);
    
    Write('b num: ');
    ReadLn(b.num);
    Write('b denom: ');
    ReadLn(b.denom);

    IF (a.denom = 0) OR (b.denom = 0) THEN
      WriteLn('a denom und b denom muessen groeser 0 sein')
  UNTIL (a.denom > 0) AND (b.denom > 0)
  END;
  
  (*Gibt eine Rationale Zahl aus*)
  PROCEDURE output(a: Rational);
  BEGIN
    WriteLn(a.num,'/',a.denom);
  END;
  
VAR a, b, c: Rational;
BEGIN
  WriteLn(chr(205),chr(205),chr(185),' RationalCalc ',chr(204),chr(205),chr(205));  
  input(a,b);

  WriteLn('Add:');
  rationalAdd(a,b,c);
  output(c);
  WriteLn('Sub:');
  rationalSub(a,b,c);
  output(c);
  WriteLn('Mult:');
  rationalMult(a,b,c);
  output(c);
  WriteLn('Div:');
  rationalDiv(a,b,c);
  output(c);
END.