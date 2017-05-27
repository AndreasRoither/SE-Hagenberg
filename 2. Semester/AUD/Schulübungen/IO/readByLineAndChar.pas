Program readByLineAndChar;

    VAR ch: CHAR;
      line:STRING;
      charsRead, charsWritten:LONGINT;
      linesRead, linesWritten:LONGINT;
      mode:(byChars, byLines);

BEGIN
  mode:=byChars;
  charsRead :=0;
  charsWritten :=0;
  linesRead:=0;
  linesWritten:=0;

  CASE mode OF

    byChars: BEGIN
      REPEAT
        Read(input, ch);
        charsRead:=charsRead+1;
        Write(output, ch);
        charsWritten:=charsWritten+1;
      UNTIL Eof(input);
    END;
    byLines: BEGIN
      REPEAT
        ReadLn(input, line);
        linesRead:=linesRead+1;
        (*Filter remove Empty*)
        IF Length(line) <> 0 THEN BEGIN
          WriteLn(output, line);
          linesWritten:=linesWritten+1;
        END;
      UNTIL Eof(input);
    END;

  END;

  CASE mode OF
    byChars:BEGIN
      WriteLn('chars read = ', charsRead, ' chars Written = ', charsWritten,'.');
    END;
    byLines:BEGIN
      WriteLn('lines read = ', linesRead, ' lines Written = ', linesWritten,'.');
    END;
  END;
END.