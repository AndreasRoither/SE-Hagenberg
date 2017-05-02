(* ExprEval    26.04.17 *)

PROGRAM ExprEval;
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
  PROCEDURE Expr(VAR e: INTEGER); FORWARD;
  PROCEDURE Term(VAR t: INTEGER); FORWARD;
  PROCEDURE Fact(VAR f: INTEGER); FORWARD;  

  PROCEDURE S;
  VAR
    e: INTEGER;
  BEGIN
    Expr(e); IF NOT success THEN EXIT;
    (* SEM *)
    WriteLn('result= ', e);
    (* ENDSEM *)
    IF sy <> eosSy THEN BEGIN success := FALSE; EXIT; END;
  END;

  PROCEDURE Expr(VAR e: INTEGER);
    VAR
      t1, t2: INTEGER;
  BEGIN
    Term(t1); IF NOT success THEN EXIT;
    (* SEM *)
    e := t1;
    (* ENDSEM *)
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN EXIT;
            (* SEM *)
            e := e + t2;
            (* ENDSEM *)
          END;
        minusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN EXIT;
            (* SEM *)
            e := e - t2;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Term(VAR t: INTEGER);
    VAR 
      f1: INTEGER;
  BEGIN
    Fact(t); IF NOT success THEN EXIT;
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN
            NewSy;
            Fact(f1); IF NOT success THEN EXIT;
            (* SEM *)
            t := t * f1;
            (* ENDSEM *)
          END;
        divSy: BEGIN
            NewSy;
            Fact(t); IF NOT success THEN EXIT;
            (* SEM *)
            t := t DIV f1;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Fact(VAR f: INTEGER);
  BEGIN
    CASE sy OF
      number: BEGIN
          (* SEM *)
          f := numberVal;
          (* ENDSEM *)
          NewSy;
        END;
      leftParSy: BEGIN
          NewSy;
          Expr(f); IF NOT success THEN EXIT;
          IF sy <> righParSy THEN BEGIN success:= FALSE; EXIT; END;
          NewSy;
        END;
      ELSE
        success := FALSE;
    END;
  END;

BEGIN
  line := '(1 + 2) * 3';
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