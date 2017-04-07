PROGRAM RLE;
  USES
    (* sysutils for StrToInt, IntToStr and FileExists *)
    Crt, sysutils;

  (* Check if char is Alphabet Char 
     Returns true if char *)
  FUNCTION IsChar(c: CHAR): BOOLEAN;
  BEGIN
    IF ((Ord(c) >= 65) AND (Ord(c) <= 90)) OR
       ((Ord(c) >= 97) AND (Ord(c) <= 122)) THEN
       IsChar := TRUE
    ELSE
      IsChar := FALSE;
  END;
  
  (* Check if char is Alphabet Char 
     Returns true if char *)
  FUNCTION IsCharWithSpecial(c: CHAR): BOOLEAN;
  BEGIN
    IF ((Ord(c) >= 65) AND (Ord(c) <= 90)) OR
       ((Ord(c) >= 97) AND (Ord(c) <= 122)) OR
       ((Ord(c) >= 33) AND (Ord(c) <= 47)) OR
       ((Ord(c) >= 58) AND (Ord(c) <= 64)) OR
       ((ord(c) >= 123) AND (Ord(c) <= 254)) THEN
       IsCharWithSpecial := TRUE
    ELSE
      IsCharWithSpecial := FALSE;
  END;
  
  (* check if char is a number 
     returns true if number *)
  FUNCTION IsNumber(c: CHAR): BOOLEAN;
  BEGIN
    IF ((Ord(c) >= 48) AND (Ord(c) <= 57)) THEN 
      IsNumber := TRUE
    ELSE
      IsNumber := FALSE;
  END;
  
  (* Get line of TEXT file  
     returns false if EOF, true if not *)
  FUNCTION GetLine(VAR txt: TEXT; VAR curLine: STRING): BOOLEAN;
  BEGIN
    IF NOT Eof(txt) THEN BEGIN
      ReadLn(txt, curLine);
      GetLine := TRUE;
    END
    ELSE
      GetLine := FALSE; (* EOF of txt *)
  END;
  
  (* compresses a string *)
  PROCEDURE CompressString(VAR curLine: STRING);
  VAR
    s        : STRING;
    curChar  : CHAR;
    count, i, i2 : INTEGER;
  BEGIN
    curChar := curLine[1];
    curLine := curLine + ' ';
    s := '';
    count := 0;
    
    FOR i := 1 TO Length(curLine) DO BEGIN
    
      IF curLine[i] = curChar THEN count := count + 1
      ELSE 
        IF count < 3 THEN BEGIN
          FOR i2 := 1 TO count DO s := s + curChar;
          count := 1;
          curChar := curLine[i];  
        END
        ELSE BEGIN
          s := s + curChar + IntToStr(count) ;
          count := 1;
          curChar := curLine[i];
        END;
    END;
    
    IF Length(curLine) > 1 THEN curLine := s;
  END;
  
  (* decompress a string *)
  PROCEDURE DecompressString(VAR curLine: STRING);
  VAR 
    s, temp : STRING;
    i, i2, count : INTEGER;
    curChar : CHAR;
  BEGIN
    s := '';
    temp := '';
    curChar := curLine[1];
    i := 1;
    
    WHILE i <= Length(curLine) DO BEGIN

      IF IsCharWithSpecial(curLine[i]) THEN BEGIN
        s := s + curLine[i];
        curChar := curLine[i];
      END
      ELSE BEGIN
        i2 := i;
        WHILE IsNumber(curLine[i]) AND (i2 <= Length(curLine)) DO BEGIN
          temp := temp + curLine[i];
          i := i + 1;
        END;
        i:= i - 1;
        
        IF temp <> '' THEN count := StrToInt(temp);
        temp := '';

        FOR i2 := 1 TO count - 1 DO s := s + curChar;  
      END;
      i := i + 1;
      WriteLn(s);
    END;
    
    IF Length(curLine) > 1 THEN curLine := s;
  END;
  
  (* compress txt file *)
  PROCEDURE Compress(VAR txt1, txt2 : TEXT);
  VAR
    curLine: STRING;
  BEGIN
    WHILE GetLine(txt1, curLine) DO BEGIN
      CompressString(curline);
      WriteLn(txt2, curLine);
    END;
    WriteLn('Compressed');
  END;
  
  (* decompress txt file *)
  PROCEDURE Decompress(VAR txt1, txt2 : TEXT);
  VAR
    curLine: STRING;
  BEGIN
    WHILE GetLine(txt1, curLine) DO BEGIN
      DecompressString(curline);
      WriteLn(txt2, curLine);
    END;
    WriteLn('Decompressed!');
  END;
  
  (* check for command line args 
     calls Decompress or Compress *)
  PROCEDURE ParamCheck();
  VAR
    option, inFileName, outFileName : STRING;
    txt1, txt2 : TEXT;   (* text files *)
    
  BEGIN
    IF (ParamCount < 3) OR ((ParamStr(1) <> '-c') AND (ParamStr(1) <> '-d')) OR
       (NOT FileExists(ParamStr(2))) OR (NOT FileExists(ParamStr(3))) THEN 
    BEGIN
      WriteLn('Wrong input, try again: ');
      Write('-c | -d > ');
      ReadLn(option);
      
      Write('inFile > ');
      ReadLn(inFileName);
      
      Write('outFile > ');
      ReadLn(outFileName);
    END
    ELSE BEGIN
      option := ParamStr(1);
      inFileName := ParamStr(2);
      outFileName := ParamStr(3);
    END;
    
    (*$I-*)
    
    (* File initialization *)
    Assign(txt1, inFileName);
    Reset(txt1);    (* read file *)
    Assign(txt2, outFileName);
    Rewrite(txt2);  (* Rewrite new file or write*)
    
    IF IOResult <> 0 THEN
    BEGIN
      WriteLn('Error opening file!');
      Exit;
    END;
    
    IF option = '-c' THEN Compress(txt1, txt2) ELSE IF option = '-d' THEN Decompress(txt1, txt2);
    
    (* Close Files *)
    Close(txt1);
    Close(txt2);

  END;
  
BEGIN

  ParamCheck();

END.