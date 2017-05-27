(* MP_Lex                                   03.05.17 *)
(* Lexikalischer Analysator (scanner) für mini pascal*)

UNIT MP_Lex;

  INTERFACE
    TYPE
      SymbolCode = (errorSy, (* error symbol *)
                    eofSy,
                    programSy, semicolonSy,
                    beginSy, endSy, periodSy,
                    varSy, colonSy, commaSy, integerSy,
                    readSy, writeSy, assignSy,
                    plusSy, minusSy, timesSy, divSy,
                    leftParSy, rightParSy,
                    identSy, numberSy);
    VAR
      sy: SymbolCode;
      numberVal, syLnr, syCnr : INTEGER;
      identStr : STRING;

    PROCEDURE InitScanner(srcName: STRING; VAR ok: BOOLEAN);

    PROCEDURE NewCh;
    PROCEDURE NewSy;

  IMPLEMENTATION
    CONST
      EF = Chr(0);

    VAR
      srcLine: STRING;
      ch: CHAR;
      chLnr, chCnr : INTEGER;
      srcFile: TEXT;

  PROCEDURE InitScanner(srcName: STRING; VAR ok: BOOLEAN);
  BEGIN
    Assign(srcFile, srcName);
    {$I-}
    Reset(srcFile);
    {$I+}
    ok := IOResult = 0;

    IF ok THEN BEGIN
      srcLine := '';
      chLnr := 0;
      chCnr := 1;
      NewCh;
      NewSy;
    END;
  END;

  PROCEDURE NewCh;
  BEGIN
    IF chCnr < Length(srcLine) THEN BEGIN
      chCnr := chCnr + 1;
      ch := srcLine[chCnr];
    END
    ELSE BEGIN (* new line *)
      IF NOT Eof(srcFile) THEN BEGIN
        ReadLn(srcFile, srcLine);
        Inc(chLnr);
        chCnr := 0;
        (* da leerzeichen überlesen werden wird in newsy gleich der 
           nächste char eingelesen *)
        ch := ' ';
      END
      ELSE BEGIN
        Close(srcFile);
        ch := EF;
      END;
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

    syLnr := chLnr;
    syCnr := chCnr;

    CASE ch OF
      EF: BEGIN
          sy := eofSy;
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
          sy := rightParSy;
          NewCh;
        END;
      ';': BEGIN
          sy := semicolonSy;
          NewCh;
        END;
      '.': BEGIN
          sy := periodSy;
          NewCh;
        END;
      ',': BEGIN
          sy := commaSy;
          NewCh;
        END;
      ':': BEGIN
          NewCh;
          IF ch <> '=' THEN BEGIN
            sy := colonSy;
          END
          ELSE BEGIN
            sy := assignSy;
            NewCh;
          END;
        END;
      'a' .. 'z', 'A' .. 'Z': BEGIN
          identStr := '';
          WHILE ch IN ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_'] DO BEGIN
            identStr := Concat(identStr, UpCase(ch));
            NewCh;
          END;

          IF identStr = 'PROGRAM' THEN 
            sy := programSy
          ELSE IF identStr = 'BEGIN'THEN
            sy := beginSy
          ELSE IF identStr = 'END' THEN
            sy := endSy
          ELSE IF identStr = 'VAR' THEN
            sy := varSy
          ELSE IF identStr = 'INTEGER' THEN
            sy := integerSy
          ELSE IF identStr = 'READ' THEN
            sy := readSy
          ELSE IF identStr = 'WRITE' THEN
            sy := writeSy
          ELSE
            sy := identSy;
        END;

      '0'..'9': BEGIN
          sy := numberSy;
          numberStr := '';

          WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
            numberStr := numberStr + ch;
            NewCh;
          END;
          Val(numberStr, numberVal, code);
        END;
    ELSE
      sy := errorSy;
    END;
  END;
END. (* MP_Lex *)