PROGRAM HashTester;

  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt,
    WinGraph;
    
  CONST 
  	MAX_SIZE = 700;
  	EF = CHR(0);         (*end of file character*)
		maxWordLen = 30;     (*max. number of characters per word*)
		chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
             'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
  	
  TYPE
  	Node = ^NodeRec;
  	
  	NodeRec = RECORD
  		key : String;
  		next : Node;
  		END;
  		
    HashTable = ARRAY[0..MAX_SIZE - 1] OF Node;
    Word = STRING[maxWordLen];
    
  VAR
	    txt: TEXT;           (*text file*)
	    curLine: STRING;     (*current line from file txt*)
	    curCh: CHAR;         (*current character*)
	    curLineNr: INTEGER;  (*current line number*)
	    curColNr: INTEGER;   (*current column number*)
	    table: HashTable;
    
    
   FUNCTION LowerCase(ch: CHAR): STRING;
	  BEGIN
	    CASE ch OF
	      'A'..'Z': LowerCase := CHR(ORD(ch) + (ORD('a') - ORD('A')));
	      'Ä', 'ä': LowerCase := 'ae';
	      'Ö', 'ö': LowerCase := 'oe';
	      'Ü', 'ü': LowerCase := 'ue';
	      'ß':      LowerCase := 'ss';
	      ELSE (*all the others*)
	                LowerCase := ch;
	      END; (*CASE*)
	  END; (*LowerCase*)
	
	 PROCEDURE GetNextChar; (*updates curChar, ...*)
	  BEGIN
	    IF curColNr < Length(curLine) THEN BEGIN
	        curColNr := curColNr + 1;
	        curCh := curLine[curColNr]
	      END (*THEN*)
	    ELSE BEGIN (*curColNr >= Length(curLine)*)
	      IF NOT Eof(txt) THEN BEGIN
	          ReadLn(txt, curLine);
	          curLineNr:= curLineNr + 1;
	          curColNr := 0;
	          curCh := ' '; (*separate lines by ' '*)
	        END (*THEN*)
	      ELSE (*Eof(txt)*)
	        curCh := EF;
	    END; (*ELSE*)
	  END; (*GetNextChar*)
	
	PROCEDURE GetNextWord(VAR w: Word; VAR lnr: INTEGER);
	  BEGIN
	    WHILE (curCh <> EF) AND NOT (curCh IN chars) DO BEGIN
	      GetNextChar;
	    END; (*WHILE*)
	    lnr := curLineNr;
	    IF curCh <> EF THEN BEGIN
	        w := LowerCase(curCh);
	        GetNextChar;
	        WHILE (curCh <> EF) AND (curCh IN chars) DO BEGIN
	          w := Concat(w , LowerCase(curCh));
	          GetNextChar;
	        END; (*WHILE*)
	      END (*THEN*)
	    ELSE (*curCh = EF*)
	      w := '';
  	END; (*GetNextWord*)
  
  FUNCTION NewNode(key: String; next: Node): Node;
		VAR
			n: Node;
		BEGIN
			New(n);
			n^.key := key;
			n^.next := next;
			NewNode := n;
		END;
	
	PROCEDURE Init;
		VAR
			i : INTEGER;
		BEGIN
			FOR i := 0 TO MAX_SIZE - 1 DO BEGIN
				table[i] := NIL;
			END;
		END;
		
	(* good *)
	FUNCTION HashCode3(key: String): INTEGER;
		VAR
			hc: INTEGER;
			i: INTEGER;
		BEGIN
			hc := 0;
			FOR i := 1 TO Length(key) DO BEGIN
				hc := (621 * hc + Ord(key[i])) MOD MAX_SIZE;
			END;
			HashCode3 := hc;
		END;
		
	(* pretty good *)
	FUNCTION HashCode2(key: String): INTEGER;
		VAR
			hc: INT64;
			i: INTEGER;
		BEGIN
			hc := 0;
			FOR i := 1 TO Length(key) DO BEGIN
				hc := 3 * hc + Ord(key[i]); //31
			END;
			HashCode2 := Integer(hc MOD MAX_SIZE);
		END;
		
	(* very bad *)
	FUNCTION HashCode1(key: String): INTEGER;
		BEGIN
			HashCode1 := Ord(key[1]) * Ord(key[2]) MOD MAX_SIZE;
		END;
		
	PROCEDURE LookUp(key: String; mode: INTEGER);
		VAR
			h: INTEGER;
			n: Node;
			
		BEGIN
			IF mode = 1 THEN BEGIN
				h := HashCode1(key);
			END ELSE IF mode = 2 THEN BEGIN
				h := HashCode2(key);
			END ELSE IF mode = 3 THEN BEGIN
				h := HashCode3(key);
			END ELSE BEGIN
				WriteLn('Invalid hash function');
				Halt;
			END;
	    n := table[h];
	    
	    WHILE (n <> NIL) DO BEGIN
	    	IF n^.key = key THEN BEGIN
	    		Exit;
	    	END;
	    	n := n^.next;
	    END;
			n := NewNode(key, table[h]);
			table[h] := n;
		END;
		
	FUNCTION CountNodes(n : Node) : INTEGER;
		VAR
			count : INTEGER;
		BEGIN
			count := 0;
			WHILE n <> NIL DO BEGIN
				Inc(count);
				n := n^.next;
			END;
			CountNodes := count;
		END;
    
  PROCEDURE Draw(table : HashTable; dc : HDC; r : TRect);
    VAR i, j : INTEGER;
      stepX : REAL;
      w, h : INTEGER;
      maxVal, count : INTEGER;
      x, y : REAL;
      hFactor : REAL;
      
    BEGIN
      w := r.right - r.left;
      h := r.bottom - r.top;
      count := CountNodes(table[Low(table)]);
      maxVal := count;
      FOR i := Low(table) TO High(table) DO BEGIN
      	count := CountNodes(table[i]);
        IF maxVal < count THEN BEGIN
          maxVal := count;
        END;
      END;
      stepX := w / (High(table) - Low(table) + 1);
      hFactor := (h / stepX) / maxVal;
      x := r.left;
      count := 0;
      FOR i := Low(table) TO High(table) DO BEGIN
      	count := CountNodes(table[i]);
        y := r.bottom;
        FOR j := 1 TO Round(hFactor * count) DO BEGIN
          Ellipse(dc, Round(x), Round(y + stepX), Round(x + stepX), Round(y));
          y := y - stepX;
        END;
        x := x + stepX;
      END;
    END;


  PROCEDURE DrawHash(dc: HDC; wnd: HWnd; r: TRect);
    (*VAR i : INTEGER;
      w, h : INTEGER;
      x, y : INTEGER;*)
    BEGIN
      Draw(table, dc, r);
    END;

VAR
  txtName: STRING;
  w: Word;
  lnr, mode: INTEGER;
  n: LONGINT;

BEGIN
  
  IF ParamCount = 0 THEN BEGIN
	  WriteLn;
	  WriteLn;
	  Write('name of text file > ');
	  ReadLn(txtName);
	END ELSE BEGIN
	  txtName := ParamStr(1);
	  WriteLn(txtName);
	END;
	WriteLn;
	
	WriteLn('Choose the HashFunction: ');
	WriteLn('1 - Very bad');
	WriteLn('2 - pretty good');
	WriteLn('3 - Good');
	ReadLn(mode);
	
	Assign(txt, txtName);
	Reset(txt);
	curLine := '';
	curLineNr := 0;
	curColNr := 1;
	GetNextChar; 
	
	GetNextWord(w, lnr);
	n := 0;
	Init;
	WHILE Length(w) > 0 DO BEGIN
	  LookUp(w, mode);
	  n := n + 1;
	  GetNextWord(w, lnr);
	END;
	  
	redrawProc := DrawHash;
  WGMain;
	  
	WriteLn;
	WriteLn('number of words: ', n);
	  
	Close(txt);
END.
