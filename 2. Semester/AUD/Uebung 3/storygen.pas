PROGRAM storygen;
  USES
    Crt, sysutils; (* sysutils for filesexits *)

  CONST
    EF = CHR(0);         (*END of file character*)
    maxWordLen = 30;     (*max. number of characters per word*)
    chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
         'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
    size = 100;
    
  TYPE
    Word = STRING[maxWordLen];

    NodePtr = ^Node;
      Node = RECORD
        key: STRING;
        replacement : STRING;
        next: NodePtr;
      END; (*Record*)
      
    ListPtr = NodePtr;
    HashTable = ARRAY[0..size-1] OF ListPtr;
    
	VAR
		curLine : STRING;     (*current line from file txt*)
		curCh: CHAR;          (*current character*)
		curLineNr: INTEGER;   (*current line number*)
		curColNr: INTEGER;    (*current column number*)
    mode : (fillHashTableMode, replaceMode);
    replTXTFile, inTXTFile, outTXTFile : TEXT;   (* text files *)
    newLine : BOOLEAN;

  (* Sets everything in the ht to NIL *)
  PROCEDURE InitHashTable(VAR ht: HashTable);
  VAR
    h: Integer;
  BEGIN
    FOR h := 0 TO size - 1 DO BEGIN
      ht[h] := NIL;
    END;
  END;

  (* Create a new Node *)
  FUNCTION NewNode(w, wr : Word; next: NodePtr) : NodePtr;
  VAR
    n: NodePtr;
  BEGIN
    New(n);
    n^.key := w;
    n^.replacement := wr;
    n^.next := next;

    NewNode := n;
  END; 
  
  (* compiler hashcode 
     returns hashcode of string *)
  FUNCTION HashCode(key: String): Integer;
  BEGIN
    IF Length(key) = 1 THEN
      HashCode := (Ord(key[1]) * 7 + 1) * 17 MOD size
    ELSE
      HashCode := (Ord(key[1]) * 7 + Ord(key[2]) + Length(key)) * 17 MOD size
  END;
  
  (* Lookup combines search and prepend  *)
  FUNCTION Lookup(w, wr : Word; VAR ht: HashTable) : NodePtr;
    VAR
      i: Integer;
      n: NodePtr;  
  BEGIN
    i := HashCode(w);
    n := ht[i];

    WHILE (n <> NIL) AND (n^.key <> w) DO BEGIN
      n := n^.next;
    END;

    IF n = NIL THEN BEGIN
      n := NewNode(w, wr, ht[i]);
      ht[i] := n;
    END;
    Lookup := n;
  END;
  
  (* Searches for a string in the hashtable
     returns NIL if not found *)
  FUNCTION Search(key: String; ht: HashTable) : NodePtr;
    VAR
      i: Integer;
      n: NodePtr;  
  BEGIN
    i := HashCode(key);
    n := ht[i];
    
    WHILE (n <> NIL) AND (n^.key <> key) DO BEGIN
      n := n^.next;
    END;
    Search := n;
  END;

  (* updates curChar *)
	PROCEDURE GetNextChar(VAR txt: TEXT);
	BEGIN
		IF curColNr < Length(curLine) THEN BEGIN
			curColNr := curColNr + 1;
			curCh := curLine[curColNr];
		END
    ELSE IF (curColNr = 0) AND (curColNr >= Length(curLine)) THEN BEGIN
    
      CASE mode OF
          replaceMode: BEGIN
            WriteLn(outTXTFile);
            ReadLn(txt, curLine);
            curLineNr:= curLineNr + 1;
            curColNr := 0;
            curCh := ' '; (* separate lines by ' ' *)  
          END;
        END;     
    END
		ELSE BEGIN (* curColNr >= Length(curLine) *)
		  IF NOT Eof(txt) THEN BEGIN
        
        CASE mode OF
          replaceMode: BEGIN
            newLine := TRUE;
          END;
        END; 
        
			  ReadLn(txt, curLine);
			  curLineNr:= curLineNr + 1;
			  curColNr := 0;
			  curCh := ' '; (* separate lines by ' ' *)       
			END
		  ELSE 
			curCh := EF;
		END;
	END; (* GetNextChar *)

  (* Creates word from char
      - mode decides if between reading or writing
     returns the next word in a string *)
	PROCEDURE GetNextWord(VAR w: Word; VAR lnr: INTEGER; VAR txt: TEXT);
	BEGIN
    WHILE (curCh <> EF) AND NOT (curCh IN chars) DO BEGIN
      CASE mode OF
        replaceMode: BEGIN
          IF NOT (curCh IN chars) THEN Write(outTXTFile, curCh); 
        END;
      END;   
      GetNextChar(txt);
    END;
    
    lnr := curLineNr;
    IF curCh <> EF THEN BEGIN
      w := curCh;
      GetNextChar(txt);

      WHILE (curCh <> EF) AND (curCh IN chars) DO BEGIN
        w := Concat(w, curCh);
        GetNextChar(txt);
      END; 
    END 
    ELSE 
      w := '';   
	END; (* GetNextWord *)

  (* Fills the HashTable with the replacements *)
  PROCEDURE FillHashTable(VAR ht: HashTable; VAR txt: TEXT);
  VAR
		w, wr: Word;    (*current word*)
		lnr: INTEGER;   (*line number of current word*)
		n: LONGINT;     (*number of words*)
    
  BEGIN
    curLine := '';
    curLineNr := 0;
    curColNr := 1;      (*curColNr > Length(curLine) FORces reading of first line*)
    GetNextChar(txt);   (*curCh now holds first character*)
    n := 0;
    mode := fillHashTableMode;
    w := '';
    
    GetNextWord(w, lnr, txt);
    GetNextWord(wr, lnr, txt);
    WHILE Length(w) > 0 DO BEGIN
      IF (w <> '') AND (wr <> '') THEN Lookup(w, wr, ht); 
      n := n + 1;
      GetNextWord(w, lnr, txt);
      GetNextWord(wr, lnr, txt);
    END;
    WriteLn('Found ',n ,' replacements');
  END;
  
  (* Replaces a word if there is a replacement *)
  PROCEDURE Replace(ht: HashTable);
  VAR
		w : Word;       (*current word*)
		lnr: INTEGER;   (*line number of current word*)
		n: LONGINT;     (*number of words*)
    temp : NodePtr;
    
  BEGIN
    curLine := '';
    curLineNr := 0;
    curColNr := 1;            (*curColNr > Length(curLine) forces reading of first line*)
    GetNextChar(inTXTFile);   (*curCh now holds first character*)
    n := 0;
    mode := replaceMode;
    w := ' ';

    WriteLn('Replacing... ');
    
    GetNextWord(w, lnr, inTXTFile);
    WHILE Length(w) > 0 DO BEGIN
      (* Check if word is the word from the ht, and not just a word 
         with the same hashcode *)
      temp := Search(w, ht);
      
      IF newLine THEN BEGIN
        WriteLn(outTXTFile);
        newLine := FALSE;
      END;
      
      IF temp <> NIL THEN BEGIN
        //WriteLn('w: ', w, ' temp: ', temp^.key, ' temp repl.: ', temp^.replacement, ' ');
        IF (temp^.key = w) THEN Write(outTXTFile, temp^.replacement)
        ELSE Write(outTXTFile, w);
      END
      ELSE
        Write(outTXTFile, w);
      
      n := n + 1;
      GetNextWord(w, lnr, inTXTFile);
    END;
    WriteLn('Finished!');
  END;

  (* check for command line args 
     calls Decompress or Compress *)
  PROCEDURE ParamCheck();
  VAR
    replaceFileName, inFileName, outFileName : STRING;
    ht : HashTable;
    
  BEGIN
    IF (ParamCount < 3) OR (NOT FileExists(ParamStr(2))) OR 
        (NOT FileExists(ParamStr(3))) THEN 
    BEGIN
      WriteLn('Wrong input, try again: ');
      Write('replaceFile > ');
      ReadLn(replaceFileName);
      
      Write('inFile > ');
      ReadLn(inFileName);
      
      Write('outFile > ');
      ReadLn(outFileName);
    END
    ELSE BEGIN
      replaceFileName := ParamStr(1);
      inFileName := ParamStr(2);
      outFileName := ParamStr(3);
    END;
    
    InitHashTable(ht);
    
    (*$I-*)
    (* File initialization *)
    Assign(replTXTFile, replaceFileName);
    Reset(replTXTFile);    (* read file *) 
    Assign(inTXTFile, inFileName);
    Reset(inTXTFile);      (* read file *)
    Assign(outTXTFile, outFileName);
    Rewrite(outTXTFile);   (* Rewrite new file or write*)
    
    (* Check IOResult for opening errors *)
    IF IOResult <> 0 THEN
    BEGIN
      WriteLn('Error opening file!');
      Exit;
    END;
    
    (* closing repl. cause we dont need it anymore *)
    FillHashTable(ht, replTXTFile);
    Close(replTXTFile);
    
    Replace(ht);
    
    (* close files *)
    Close(inTXTFile);
    Close(outTXTFile);

  END;
  
BEGIN

  ParamCheck();
  
END.