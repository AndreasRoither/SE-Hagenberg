(* MP_SS                             03.05.17 *)
(* Syntax Analysator (scanner) für mini pascal*)

UNIT MP_SS;
  INTERFACE
    
    VAR
      success: BOOLEAN;

    PROCEDURE S;

  IMPLEMENTATION
    USES
      MP_Lex;

    FUNCTION SyIsNot(expectedSy: SymbolCode): BOOLEAN;
    BEGIN
      success := success AND (sy = expectedSy);
      SyIsNot := NOT success;
    END;

    PROCEDURE MP;       FORWARD;
    PROCEDURE VarDecal; FORWARD;
    PROCEDURE StatSeq;  FORWARD;
    PROCEDURE Stat;     FORWARD;
    PROCEDURE Expr;     FORWARD;
    PROCEDURE Term;     FORWARD;
    PROCEDURE Fact;     FORWARD;

    PROCEDURE S;
    BEGIN
      success := TRUE;
      MP; IF NOT success OR SyIsNot(eofSy) THEN
        WriteLn('Error in line ', syLnr, ' at position ', syCnr)
      ELSE
        WriteLn('Sucessfully parsed');
    END;

    PROCEDURE MP;
    BEGIN
      IF SyIsNot(programSy) THEN EXIT;
      NewSy;
      IF SyIsNot(identSy) THEN EXIT;
      NewSy;
      IF SyIsNot(semicolonSy) THEN EXIT;
      NewSy;
      IF sy = varSy THEN BEGIN
        VarDecal; IF NOT success THEN EXIT;
      END;
      IF SyIsNot(beginSy) THEN EXIT;
      NewSy;
      StatSeq; IF NOT success THEN EXIT;
      IF SyIsNot(endSy) THEN EXIT;
      NewSy;
      IF SyIsNot(periodSy) THEN EXIT;
      NewSy; (* to get eofSy *)
    END;

    PROCEDURE VarDecal;
    BEGIN
      IF SyIsNot(varSy) THEN EXIT;
      NewSy;
      IF SyIsNot(identSy) THEN EXIT;
      NewSy;
      WHILE sy = commaSy DO BEGIN
        NewSy;
        IF SyIsNot(identSy) THEN EXIT;
        NewSy;
      END;
      IF SyIsNot(colonSy) THEN EXIT;
      NewSy;
      IF SyIsNot(integerSy) THEN EXIT;
      NewSy;
      IF SyIsNot(semicolonSy) THEN EXIT;
      NewSy;
    END;

    PROCEDURE StatSeq;
    BEGIN
      Stat; IF NOT success THEN EXIT;
      WHILE sy = semicolonSy DO BEGIN
        NewSy;
        Stat; IF NOT success THEN EXIT;
      END;
    END;

    PROCEDURE Stat;
    BEGIN
      CASE sy OF
        identSy: BEGIN
            NewSy;
            IF SyIsNot(assignSy) THEN EXIT;
            NewSy;
            Expr; IF NOT success THEN EXIT;
          END;
        readSy: BEGIN
            NewSy;
            IF SyIsNot(leftParSy) THEN EXIT;
            NewSy;
            IF SyIsNot(identSy) THEN EXIT;
            NewSy;
            IF SyIsNot(rightParSy) THEN EXIT;
            NewSy;
          END;
        writeSy: BEGIN
            NewSy;
            IF SyIsNot(leftParSy) THEN EXIT;
            NewSy;
            Expr; IF NOT success THEN EXIT;
            IF SyIsNot(rightParSy) THEN EXIT;
            NewSy;
          END;
        ELSE
          (* no statement *)
      END;
    END;

    PROCEDURE Expr;
    BEGIN
      Term; IF NOT success THEN EXIT;
      WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
        CASE sy OF
          plusSy: BEGIN
              NewSy;
              Term; IF NOT success THEN EXIT;
            END;
          minusSy: BEGIN
              NewSy;
              Term; IF NOT success THEN EXIT;
            END;
        END;
      END;
    END;

    PROCEDURE Term;
    BEGIN
      Fact; IF NOT success THEN EXIT;
      WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
        CASE sy OF
          timesSy: BEGIN
              NewSy;
              Fact; IF NOT success THEN EXIT;
            END;
          divSy: BEGIN
              NewSy;
              Fact; IF NOT success THEN EXIT;
            END;
        END;
      END;
    END;

    PROCEDURE Fact;
    BEGIN
      CASE sy OF
        identSy: BEGIN
            NewSy;
          END;
        numberSy: BEGIN
            NewSy;
          END;
        leftParSy: BEGIN
            NewSy;
            Expr; IF NOT success THEN EXIT;
            IF sy <> rightParSy THEN BEGIN success:= FALSE; EXIT; END;
            NewSy;
          END;
        ELSE
          success := FALSE;
      END;
    END;
END.