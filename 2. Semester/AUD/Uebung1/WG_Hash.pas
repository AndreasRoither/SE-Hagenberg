
PROGRAM WG_Hash;

  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt;
	
	CONST
	EF = CHR(0);         (*end of file character*)
	maxWordLen = 30;     (*max. number of characters per word*)
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
			 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
	size = 30000;

	TYPE
	Word = STRING[maxWordLen];

	NodePtr = ^Node;
	  Node = RECORD
		key: STRING;
		data : Integer;
		collision: Integer;
		next: NodePtr;
	  END; (*Record*)
	ListPtr = NodePtr;
	HashTable = ARRAY[0..size-1] OF ListPtr;
	
	VAR
		txt: TEXT;           (*text file*)
		curLine: STRING;     (*current line from file txt*)
		curCh: CHAR;         (*current character*)
		curLineNr: INTEGER;  (*current line number*)
		curColNr: INTEGER;   (*current column number*)
		ht : HashTable;
	
	function NewHashNode(key: String; next: NodePtr; data : Integer) : NodePtr;
	var
		n: NodePtr;
	begin
		New(n);
		n^.key := key;
		n^.next := next;
		n^.data := data;
		n^.collision := 0;
		NewHashNode := n;
	end; (*NewNode*)

	(* returns the hashcode of a key *)
	function HashCode(key: String): Integer;
	begin
	  HashCode := Ord(key[1]) MOD size;
	end; (*HashCode*)

	(* returns the hashcode of a key *)
	function HashCode2(key: String): Integer;
	begin
	  HashCode2 := (Ord(key[1]) + Length(key)) MOD size;
	end; (*HashCode2*)
	
	(* returns the hashcode of a key *)
	function HashCode3(key: String): Integer;
	  var
		hc, i : Integer;
	begin
		hc := 0;

		for i := 1 to Length(key) do begin
		{Q-}
		{R-}
		hc := 31 * hc + Ord(key[i]);
		{R+}
		{Q+}
		end; (* for *)

		HashCode3 := Abs(hc) MOD size;
	end; (*HashCode3*)

	(* Lookup combines search and prepend *)
	function Lookup(key: String) : NodePtr;
	  var
		i: Integer;
		n: NodePtr;  
	begin
		IF hash = 1 THEN BEGIN
			i := HashCode1(key);
		END ELSE IF mode = 2 THEN BEGIN
			i := HashCode2(key);
		END ELSE IF mode = 3 THEN BEGIN
			i := HashCode3(key);
		END ELSE BEGIN
			WriteLn('Invalid hash function');
			Halt;
		END;
		n := ht[i];
		
		while (n <> Nil) do begin
		if (n^.key = key) THEN BEGIN
			n^.data = n^.data + 1;
			exit;
		end;
		n := n^.next;
		end;

		if n = nil then begin
			n := NewHashNode(key, ht[i], 1);
			ht[i] := n;
			ht[i]^.collision := ht[i]^.collision + 1;
		end; (*if*)

		Lookup := n;

	end; (* Lookup *)

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

	PROCEDURE Draw(ht : HashTable; dc : HDC; r : TRect);
    VAR i, j : INTEGER;
      stepX : REAL;
      w, h : INTEGER;
      maxVal, count : INTEGER;
      x, y : REAL;
      hFactor : REAL;
      
    BEGIN
      w := r.right - r.left;
      h := r.bottom - r.top;
      count := ht[0]^.collision;
      maxVal := count;
	  
      FOR i := Low(ht) TO High(ht) DO BEGIN
      	count := ht[i]^.collision;
        IF maxVal < count THEN BEGIN
          maxVal := count;
        END;
      END;
	  
      stepX := w / (High(ht) - Low(ht) + 1);
      hFactor := (h / stepX) / maxVal;
      x := r.left;
      count := 0;
	  
      FOR i := Low(ht) TO High(ht) DO BEGIN
      	count := ht[i]^.collision;
        y := r.bottom;
        FOR j := 1 TO Round(hFactor * count) DO BEGIN
          Ellipse(dc, Round(x), Round(y + stepX), Round(x + stepX), Round(y));
          y := y - stepX;
        END;
        x := x + stepX;
      END;
    END;
	
	PROCEDURE DrawHash(dc: HDC; wnd: HWnd; r: TRect);
    BEGIN
      Draw(ht, dc, r);
    END;
	
	PROCEDURE Init;
	VAR
		i : INTEGER;
	BEGIN
		FOR i := 0 TO size - 1 DO BEGIN
			ht[i] := NIL;
		END;
	END;
VAR
	txtName: STRING;
	w: Word;        (*current word*)
	lnr: INTEGER;   (*line number of current word*)
	n: LONGINT;     (*number of words*)
	hash : Integer;
	
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
	
	WriteLn('Choose HashFunction: ');
	WriteLn('1.');
	WriteLn('2.');
	WriteLn('3.');
	ReadLn(hash);
	
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
	  LookUp(w);
	  n := n + 1;
	  GetNextWord(w, lnr);
	END;
	  
	redrawProc := DrawHash;
	WGMain;
	  
	WriteLn;
	WriteLn('number of words: ', n);
	  
	Close(txt);
END. 
