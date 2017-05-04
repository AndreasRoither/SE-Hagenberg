(* Lex                                   03.05.17 *)
(* Lexikalischer Analysator (scanner)UE6          *)

UNIT Lex;
  INTERFACE
    TYPE
      SymbolCode = (errorSy, (* error symbol *)
                    leftParSy, rightParSy,
                    eofSy, periodSy, equalsSy,
                    leftCompSy, rightCompSy, optSy,
                    leftCurlySy, rightCurlySy, identSy);
    VAR
      sy: SymbolCode;
      syLnr, syCnr : INTEGER;
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
      '(': BEGIN
          sy := leftParSy;
          NewCh;
        END;
      ')': BEGIN
          sy := rightParSy;
          NewCh;
        END;
      '.': BEGIN
          sy := periodSy;
          NewCh;
        END;
      '<': BEGIN
          sy := leftCompSy;
          NewCh;
        END;
      '>': BEGIN
          sy := rightCompSy;
          NewCh;
        END;
      '|': BEGIN
          sy := optSy;
          NewCh;
        END;
      '{': BEGIN
          sy := leftCurlySy;
          NewCh;
        END;
      '}': BEGIN
          sy := rightCurlySy;
          NewCh;
        END;
      '=': BEGIN
          sy := equalsSy;
          NewCh;
        END;
      'a' .. 'z', 'A' .. 'Z': BEGIN
          identStr := '';
          WHILE ch IN ['a' .. 'z', 'A' .. 'Z', '_'] DO BEGIN
            identStr := Concat(identStr, ch);
            NewCh;
          END;
          sy := identSy;
        END;
    ELSE 
      sy := errorSy;
    END;
  END;
END. (* Lex *)