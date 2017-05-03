(* InfixToPrefix    26.04.17 *)

PROGRAM InfixToPrefix;
  CONST
    eosCh = Chr(0);

  TYPE
    SymbolCode = (noSy, (* error symbol *)
                  eosSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, righParSy,
                  number, variable);
  VAR
    line: STRING;

    ch: CHAR;
    cnr: INTEGER;
    sy: SymbolCode;
    numberVal, variableStr: STRING;
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
      (* for numbers *)
      '0'..'9': BEGIN
          sy := number;
          numberStr := '';

          WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
            numberStr := numberStr + ch;
            NewCh;
          END;
          numberVal := numberStr;
        END;

      (* for characters *)
      'A' .. 'Z', 'a'..'z': BEGIN
        sy := variable;
        variableStr := '';

        WHILE ((ch >= 'A') AND (ch < 'Z')) OR ((ch >= 'a') AND (ch < 'z'))
        DO BEGIN
          variableStr := variableStr + ch;
          NewCh;
        END;
      END;
    ELSE
      sy := noSy;
    END;
  END;

  (* ====== PARSER ====== *)
  PROCEDURE S; FORWARD;
  PROCEDURE Expr(VAR e: STRING); FORWARD;
  PROCEDURE Term(VAR t: STRING); FORWARD;
  PROCEDURE Fact(VAR f: STRING); FORWARD;

  PROCEDURE S;
  VAR
    e: STRING;
  BEGIN
    Expr(e); IF NOT success THEN EXIT;
    (* SEM *)
    WriteLn('result= ', e);
    (* ENDSEM *)
    IF sy <> eosSy THEN BEGIN success := FALSE; EXIT; END;
  END;

  PROCEDURE Expr(VAR e: STRING);
    VAR
      t1, t2: STRING;
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
            e := ' + ' + t1 + ' ' + t2;
            t1 := e;
            (* ENDSEM *)
          END;
        minusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN EXIT;
            (* SEM *)
            e := ' - ' + t1 + ' ' + t2;
            t1 := e;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Term(VAR t: STRING);
    VAR 
      f1, f2: STRING;
  BEGIN
    Fact(f1); IF NOT success THEN EXIT;
    (* SEM *)
    t := f1;
    (* ENDSEM *)
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN
            NewSy;
            Fact(f2); IF NOT success THEN EXIT;
            (* SEM *)
            t := ' * ' + f1 + ' ' + f2;
            f1 := t;
            (* ENDSEM *)
          END;
        divSy: BEGIN
            NewSy;
            Fact(f2); IF NOT success THEN EXIT;
            (* SEM *)
            t := ' / ' + f1 + ' ' + f2;
            f1 := t;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Fact(VAR f: STRING);
  BEGIN
    CASE sy OF
      number: BEGIN
          (* SEM *)
          f := numberVal;
          (* ENDSEM *)
          NewSy;
        END;
      variable: BEGIN
          f := variableStr;
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
(* ====== END PARSER ====== *)

  PROCEDURE SyntaxTest(str: STRING);
  BEGIN
    WriteLn('Infix: ', str);
    line := str;
    cnr := 0;
    NewCh;
    NewSy;
    success := TRUE;

    S;
    IF success THEN WriteLn('successful syntax analysis',#13#10) 
    ELSE WriteLn('Error in column: ', cnr,#13#10);
  END;

BEGIN
  (* Test cases *)
  SyntaxTest('(a + b) * c');
  SyntaxTest('1 + 2 + 3');
  SyntaxTest('(1 + 2) * a');
  SyntaxTest('(((a + b) * c)');
  SyntaxTest('a++3*4');
  SyntaxTest('1+2+3+4+5+6+7+8');

END.