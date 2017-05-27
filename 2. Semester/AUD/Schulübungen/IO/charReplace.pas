Program charReplace;

    VAR ch: CHAR;
      charsRead, charsWritten:LONGINT;

BEGIN
  charsRead :=0;
  charsWritten :=0;

      REPEAT
        (* input ist die mit Eingabelenkung eingegebene Datei *)
        Read(input, ch);
        charsRead:=charsRead+1;
        IF ch='Ä' THEN BEGIN
          Write(output, 'Ae');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='ä' THEN BEGIN
          Write(output, 'ae');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='Ö' THEN BEGIN
          Write(output, 'Oe');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='ö' THEN BEGIN
          Write(output, 'oe');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='Ü' THEN BEGIN
          Write(output, 'Ue');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='ü' THEN BEGIN
          Write(output, 'ue');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='ß' THEN BEGIN
          Write(output, 'ss');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='«' THEN BEGIN
           Write(output, '<<');
          charsWritten:=charsWritten+2;
        END
        ELSE IF ch='»' THEN BEGIN
           Write(output, '>>');
          charsWritten:=charsWritten+2;
        END
        ELSE BEGIN
          Write(output, ch);
          charsWritten:=charsWritten+1;
        END;
      UNTIL Eof(input);
    
       Writeln();
       WriteLn('chars read = ', charsRead, ' chars Written = ', charsWritten,'.');

END.