Program replaceWords;

    VAR
      line:STRING;
      linesRead, linesWritten:LONGINT;

VAR posFound:INTEGER;
  oldWord, newWord:STRING;

BEGIN
  linesRead:=0;
  linesWritten:=0;
  oldWord:='er';
  newWord:='sie';

      REPEAT
        ReadLn(input, line);
        linesRead:=linesRead+1;
        posFound:=Pos(oldWord,line);
        WHILE (posFound<>0) DO BEGIN
          Delete(line, posFound, Length(oldWord));
          Insert(newWord, line, posFound);
          posFound:=Pos(oldWord, line);
        END;
        WriteLn(output, line);
        linesWritten:=linesWritten+1;
      UNTIL Eof(input);

      WriteLn('lines read = ', linesRead, ' lines Written = ', linesWritten,'.');

END.