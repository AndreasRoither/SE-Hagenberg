Program readFileByLineAndChar;

  VAR ch: CHAR;
    line:STRING;
    charsRead, charsWritten:LONGINT;
    linesRead, linesWritten:LONGINT;
    mode:(byChars, byLines, byBlocks);
    inName, outName:STRING;
    inFile,outFile: FILE;
    blocksRead, blocksWritten:LONGINT;
    bytesINBlockRead,bytesINBlockWritten:INTEGER;

BEGIN
  mode:=byLines;

  (*if byBlocks ParamCount must be 2*)
  
  IF ParamCount > 0 THEN BEGIN
    inName:=ParamStr(1);
    (*imagine more code*)
    (*$I-*)
    IF (mode=byChars) OR (mode=byLines) THEN BEGIN
      Assign(input, inName);
      Reset(input);
    END
    ELSE BEGIN (*byBlocks*)
      Assign(inFile, inName);
      Reset(inFile, 1);
    END;
    IF IOResult <>0 THEN BEGIN
      WriteLn('ERROR in Reset input', inName);
      Halt;
    END;
    (*§I+*)
    IF ParamCount > 1 THEN BEGIN
      outName:=ParamStr(2);
        (*$I-*)
        IF (mode=byChars) OR (mode=byLines) THEN BEGIN
          Assign(output, outName);
          Rewrite(output);
        END 
        ELSE BEGIN
          Assign(outFile, outName);
          Rewrite(outFile, 1);
        END;
        IF IOResult <>0 THEN BEGIN
          WriteLn('ERROR in Rewrite output', outName);
          Halt;
        END;
        (*§I+*)
    END;
  END;

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
        WriteLn(output, line);
        linesWritten:=linesWritten+1;
      UNTIL Eof(input);
    END;
  END;

  IF ParamCount > 0 THEN BEGIN
    IF (mode=byChars) OR (mode=byLines) THEN BEGIN
      Close(input);
      Assign(input,'');(*reassign standard input*)
      Reset(input);
    END;
    IF ParamCount > 1 THEN BEGIN
      IF (mode=byChars) OR (mode=byLines) THEN BEGIN
        Close(output);
        Assign(output, ''); (*reasign output to standard*)
        Rewrite(output);
      END;
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