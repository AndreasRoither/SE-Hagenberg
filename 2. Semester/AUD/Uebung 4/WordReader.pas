(* WordReader:                                     HDO, 03-02-27 *)
(* ----------                                                    *)
(* Reads a text file word (= seq. of characters) by word.        *)
(*===============================================================*)
UNIT WordReader;

INTERFACE

  CONST
    maxWordLen = 20;

  TYPE
    Conversion = (noConversion, toLower, toUpper);
    Word = STRING[maxWordLen]; (*to save memory, longer words are stripped*)

   PROCEDURE OpenFile(fileName: STRING; c: Conversion);
   PROCEDURE ReadWord(VAR w: Word); (*w = '' on end of file*)
   PROCEDURE CloseFile;

IMPLEMENTATION

  USES
    WinCrt;
    
  CONST
    characters = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
                  'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
    EF = CHR(0);        (*end of file character*)

  VAR
    txt: TEXT;          (*text file*)
    open: BOOLEAN;      (*file opened?*)
    line: STRING;       (*current line*)
    ch: CHAR;           (*current character*)
    cnr: INTEGER;       (*column number of current character*)
    conv: Conversion;   (*kind of conversion*)


  PROCEDURE ConvertToLower(VAR w: Word);
    VAR
      i: INTEGER;
  BEGIN
    FOR i := 1 TO Length(w) DO BEGIN
      CASE w[i] OF
        'A'..'Z': w[i] := CHR(ORD(w[i]) + 32) ;
        'Ä':      w[i] := 'ä';
        'Ö':      w[i] := 'ö';
        'Ü':      w[i] := 'ü';
      END; (*CASE*)
    END; (*FOR*)
  END; (*ConvertToLower*)

  PROCEDURE ConvertToUpper(VAR w: Word);
    VAR
      i: INTEGER;
  BEGIN
    FOR i := 1 TO Length(w) DO BEGIN
      CASE w[i] OF
        'a'..'z': w[i] := UpCase(w[i]);
        'ä':      w[i] := 'Ä';
        'ö':      w[i] := 'Ö';
        'ü':      w[i] := 'Ü';
      END; (*CASE*)
    END; (*FOR*)
  END; (*ConvertToUpper*)

  PROCEDURE NextChar;
  BEGIN
    IF cnr < Length(line) THEN BEGIN
        cnr := cnr + 1;
        ch := line[cnr]
      END (*THEN*)
    ELSE BEGIN
      IF NOT Eof(txt) THEN BEGIN
          ReadLn(txt, line);
          cnr := 0;
          ch := ' '; (*separate lines by ' '*)
        END (*THEN*)
      ELSE
        ch := EF;
    END; (*ELSE*)
  END; (*NextChar*)


  (* OpenFile: opens text file named fileName                    *)
  (*-------------------------------------------------------------*)
  PROCEDURE OpenFile(fileName: STRING; c: Conversion);
  BEGIN
    IF open THEN
      CloseFile;
    Assign(txt, fileName);
    (*$I-*)
    Reset(txt);
    (*$I+*)
    IF IOResult <> 0 THEN BEGIN
      WriteLn('ERROR in WordReader.OpenFile: file ', fileName, ' not found');
      HALT;
    END; (*IF*)
    open := TRUE;
    conv := c;
    line := '';
    cnr := 1; (*1 >= Length('') => force reading of first line*)
    NextChar;
  END; (*OpenFile*)


  (* NextWord: reads next word from file, returns '' on endfile  *)
  (*-------------------------------------------------------------*)
  PROCEDURE ReadWord(VAR w: Word);
    VAR
      i: INTEGER;
  BEGIN
    w := '';
    WHILE (ch <> EF) AND NOT (ch IN characters) DO BEGIN
      NextChar;
    END; (*WHILE*)
    IF ch = EF THEN 
      EXIT;
    i := 0;
    REPEAT
      IF i < maxWordLen THEN BEGIN
        i := i + 1;
        (*$R-*)
        w[i] := ch;
        (*$R+*)
      END; (*IF*)
      NextChar;
    UNTIL (ch = EF) OR NOT (ch IN characters);
    w[0] := Chr(i);
    CASE conv OF
      toUpper: ConvertToUpper(w);
      toLower: ConvertToLower(w);
    END; (*CASE*)
  END; (*ReadWord*)


  (* CloseFile: closes text file                                 *)
  (*-------------------------------------------------------------*)
  PROCEDURE CloseFile;
  BEGIN
    IF open THEN BEGIN
      Close(txt);
      open := FALSE;
    END; (*IF*)
  END; (*CloseFile*)


BEGIN (*WordReader*)
  open := FALSE;
END. (*WordReader*)