(* PARSER Generated *)
FUNCTION SyIsNot(expectedSy: Symbol):BOOLEAN;
BEGIN
 success:= success AND (sy = expectedSy);
 SyIsNot := NOT success;
END;

PROCEDURE Expr;
BEGIN
  Term; IF NOT success THEN EXIT;
  WHILE sy = .... DO BEGIN
    IF SyIsNot(plusSy) THEN EXIT;
    NewSy;
    Term; IF NOT success THEN EXIT;
  END;
END;

PROCEDURE Term;
BEGIN
  Fact; IF NOT success THEN EXIT;
  WHILE sy = .... DO BEGIN
    IF SyIsNot(timesSy) THEN EXIT;
    NewSy;
    Fact; IF NOT success THEN EXIT;
  END;
END;

PROCEDURE Fact;
BEGIN
  IF sy = .... THEN BEGIN
    IF SyIsNot(numberSy) THEN EXIT;
    NewSy;
  END ELSE
  IF sy = .... THEN BEGIN
    IF SyIsNot(leftParSy) THEN EXIT;
    NewSy;
    Expr; IF NOT success THEN EXIT;
    IF SyIsNot(rightParSy) THEN EXIT;
    NewSy;
  END ELSE
    success := FALSE
END;

