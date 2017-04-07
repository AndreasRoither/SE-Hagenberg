PROGRAM SimpleFilter1;
  VAR 
    mode : (byChars, byLines);
    ch : CHAR;
    line, oldWord, newWord : STRING;
    charsRead, charsWritten, linesRead, linesWritten : LONGINT;
    posFound : INTEGER;
    
  PROCEDURE 
BEGIN
  charsRead := 0;
  charsWritten := 0;
  linesRead := 0;
  linesWritten := 0;
  mode := byChars;
  oldWord := 'test';
  newWord := 'test2';
  
  CASE mode OF
    byChars: BEGIN
      REPEAT
        Read(input, ch);
        charsRead := charsRead + 1;
        
        IF ch = 'ö' THEN Write(output, 'oe')
        Write(output, ch);
        charsWritten := charsWritten + 1;
      UNTIL Eof(input);
    END; (* byChars *)
    
    byLines: BEGIN
      REPEAT
        Readln(input, line);
        linesRead := linesRead + 1;
        
        
        (* Filter: replace old wrd with new one *)
        WHILE (posFound <> 0) DO BEGIN  
          posFound := Pos(oldWord, line);
          Delete(line, posFound, Length(oldWord));
          Insert(newWord, line, posFound);
        END; (* WHILE *)
        
        IF Length(line) <> 0 THEN BEGIN
          Write(output, line);
          linesWritten := linesWritten + 1;
        END;
      UNTIL Eof(input);
    END; (* byChars *)
  END; (* case *)
 
  CASE mode OF 
    byChars: BEGIN
      WriteLn('chars read = ', charsRead, ' , chars written = ', charsWritten);
    END;
    
    byLines: BEGIN
      WriteLn('chars read = ', charsRead, ' , chars written = ', charsWritten);
    END;
  END;      
  
 
END. (* SimpleFilter1 *)