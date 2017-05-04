(* parsing functions generated from file 'EBNF.syn' *)

  FUNCTION SyIsNot(expectedSy: Symbol): BOOLEAN;
  BEGIN
    success:= success AND (sy = expectedSy);
    SyIsNot := NOT success;
  END; (*SyIsNot*)

  PROCEDURE Grammar;
  BEGIN
    Rule; IF NOT success THEN Exit;
    WHILE sy = ... DO BEGIN
      Rule; IF NOT success THEN Exit;
    END; (*WHILE*)
  END; (*Grammar*)

  PROCEDURE Rule;
  BEGIN
    IF SyIsNot(identSy) THEN Exit;
    NewSy;
    IF SyIsNot(equalSy) THEN Exit;
    NewSy;
    Expr; IF NOT success THEN Exit;
  END; (*Rule*)

  PROCEDURE Expr;
  BEGIN
    IF sy = ... THEN BEGIN
      Term; IF NOT success THEN Exit;
    END (*IF*)
    ELSE IF sy = ... THEN BEGIN
      IF SyIsNot(ltSy) THEN Exit;
      NewSy;
      Term; IF NOT success THEN Exit;
      WHILE sy = ... DO BEGIN
        IF SyIsNot(barSy) THEN Exit;
        NewSy;
        Term; IF NOT success THEN Exit;
      END; (*WHILE*)
      IF SyIsNot(gtSy) THEN Exit;
      NewSy;
    END (*IF*)
    ELSE
      success := FALSE;
  END; (*Expr*)

  PROCEDURE Term;
  BEGIN
    Fact; IF NOT success THEN Exit;
    WHILE sy = ... DO BEGIN
      Fact; IF NOT success THEN Exit;
    END; (*WHILE*)
  END; (*Term*)

  PROCEDURE Fact;
  BEGIN
    IF sy = ... THEN BEGIN
      IF SyIsNot(identSy) THEN Exit;
      NewSy;
    END (*IF*)
    ELSE IF sy = ... THEN BEGIN
      IF SyIsNot(leftParSy) THEN Exit;
      NewSy;
      Expr; IF NOT success THEN Exit;
      IF SyIsNot(rightParSy) THEN Exit;
      NewSy;
    END (*IF*)
    ELSE IF sy = ... THEN BEGIN
      IF SyIsNot(leftOptSy) THEN Exit;
      NewSy;
      Expr; IF NOT success THEN Exit;
      IF SyIsNot(rightOptSy) THEN Exit;
      NewSy;
    END (*IF*)
    ELSE IF sy = ... THEN BEGIN
      IF SyIsNot(leftIterSy) THEN Exit;
      NewSy;
      Expr; IF NOT success THEN Exit;
      IF SyIsNot(rightIterSy) THEN Exit;
      NewSy;
    END (*IF*)
    ELSE
      success := FALSE;
  END; (*Fact*)

(* generation ended succesfully *)
