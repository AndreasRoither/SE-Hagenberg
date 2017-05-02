(* ExprIn2P    26.04.17 *)

PROGRAM ExprIn2P;
  CONST
    eosCh = Chr(0);

  TYPE
    SymbolCode = (noSy, (* error symbol *)
                  eosSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, righParSy,
                  number);
  VAR
    line: STRING;

    ch: CHAR;
    cnr: INTEGER;
    sy: SymbolCode;
    numberVal: INTEGER;
    success: BOOLEAN;

  (* ====== Scanner ====== *)
  PROCEDURE NewCh;
  BEGIN
    IF cnr < Length(line) THEN BEGIN
      cnr := cnr + 1;
      ch := line[cnr];
    END
    ELSE BEGIN
      ch := eosCh;
    END;
  END;

  PROCEDURE NewSy;
    VAR
    numberStr: STRING; 
    code: INTEGER;
  BEGIN
    WHILE ch = ' ' DO BEGIN
      NewCh;
    END;

    CASE ch OF
      eosCh: BEGIN
          sy := eosSy;
        END;
      '+': BEGIN
          sy := plusSy;
          NewCh;
        END;
      '-': BEGIN
          sy := minusSy;
          NewCh;
        END;
      '*': BEGIN
          sy := timesSy;
          NewCh;
        END;
      '/': BEGIN
          sy := divSy;
          NewCh;
        END;
      '(': BEGIN
          sy := leftParSy;
          NewCh;
        END;
      ')': BEGIN
          sy := righParSy;
          NewCh;
        END;
      '0'..'9': BEGIN
          sy := number;
          numberStr := '';

          WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
            numberStr := numberStr + ch;
            NewCh;
          END;
          Val(numberStr, numberVal, code);
        END;
    ELSE
      sy := noSy;
    END;
  END;

  (* ====== PARSER ====== *)
  PROCEDURE S; FORWARD;
  PROCEDURE Expr; FORWARD;
  PROCEDURE Term; FORWARD;
  PROCEDURE Fact; FORWARD;  

  PROCEDURE S;
  BEGIN
    Expr; IF NOT success THEN EXIT;
    IF sy <> eosSy THEN BEGIN success := FALSE; EXIT; END;
  END;

  PROCEDURE Expr;
  BEGIN
    Term; IF NOT success THEN EXIT;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
            NewSy;
            Term; IF NOT success THEN EXIT;
            (* SEM *)
            Write('+');
            (* END SEM *)
          END;
        minusSy: BEGIN
            NewSy;
            Term; IF NOT success THEN EXIT;
            (* SEM *)
            Write('-');
            (* END SEM *)
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
            (* SEM *)
            Write('*');
            (* END SEM *)
          END;
        divSy: BEGIN
            NewSy;
            Fact; IF NOT success THEN EXIT;
            (* SEM *)
            Write('/');
            (* END SEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Fact;
  BEGIN
    CASE sy OF
      number: BEGIN
          (* SEM *)
          Write(numberVal, ' ');
          (* ENDSEM *)
          NewSy;
        END;
      leftParSy: BEGIN
          NewSy;
          Expr; IF NOT success THEN EXIT;
          IF sy <> righParSy THEN BEGIN success:= FALSE; EXIT; END;
          NewSy;
        END;
      ELSE
        success := FALSE;
    END;
  END;

BEGIN
  line := '1 + 2 * 3';
  cnr := 0;

  NewCh;
  NewSy;
  success := TRUE;
  
  S;
  
  IF success THEN WriteLn(#13#10, 'successful syntax analysis') ELSE WriteLn(#13#10, 'Error in column: ', cnr);
  
  (*
  REPEAT
    NewSy;
    Write(sy, ' ');
  UNTIL (sy = noSy) OR (sy = eosSy);
  *)

END.