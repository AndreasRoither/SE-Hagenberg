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
