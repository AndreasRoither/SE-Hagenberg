
PROGRAM WG_Hash;

  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt, WinGraph;
	
	CONST
	EF = CHR(0);         (*end of file character*)
	maxWordLen = 30;     (*max. number of characters per word*)
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
			 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
	size = 421;

	TYPE
	Word = STRING[maxWordLen];

	NodePtr = ^Node;
	Node = RECORD
		key: STRING;
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
		option : Integer;
	
	function NewHashNode(key: String; next: NodePtr) : NodePtr;
	var
		n: NodePtr;
	begin
		New(n);
		n^.key := key;
		n^.next := next;
		NewHashNode := n;
	end; (*NewNode*)

	(* returns the hashcode of a key *)
	function HashCode1(key: String): Integer;
	begin
	  HashCode1 := Ord(key[1]) MOD size;
	end; (*HashCode1*)

	(* compiler hashcode.. *)
	function HashCode2(key: String): Integer;
	begin
	  if Length(key) = 1 then
		HashCode2 := (Ord(key[1]) * 7 + 1) * 17 MOD size
	  else
		HashCode2 := (Ord(key[1]) * 7 + Ord(key[2]) + Length(key)) * 17 MOD size
	end; (*HashCode2)

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
	procedure Lookup(key: String);
	  var
		i: Integer;
		n: NodePtr;  
	begin
		IF option = 1 THEN i := HashCode1(key)
		ELSE IF option = 2 THEN i := HashCode2(key)
		ELSE IF option = 3 THEN i := HashCode3(key)
		ELSE BEGIN
			WriteLn('Invalid option');
			Halt;
		END;
		n := ht[i];
		
		while (n <> Nil) do begin
			if (n^.key = key) THEN BEGIN
				exit;
			end;
			n := n^.next;
		end;

		n := NewHashNode(key, ht[i]);
		ht[i] := n;
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
	
	(* Counts nodes *)
	FUNCTION CountNodes(n : ListPtr) : INTEGER;
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

	(* Draw function with eclipse *)
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
      count := 1;
      maxVal := count;
	  
      FOR i := Low(table) TO High(table) DO BEGIN
      	count := CountNodes(table[i]);
        IF maxVal < count THEN BEGIN
          maxVal := count;
        END;
      END;
      IF maxVal = 0 THEN BEGIN
      	maxVal := 1;
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
	
	(* Function to call the actual drawing function *)
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
	
BEGIN 
	option := 1;
	n := 0;
	Init();
	
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
	WriteLn('1. func (bad)');
	WriteLn('2. func (better)');
	WriteLn('3. func (best)');
	Write('> ');
	ReadLn(option);

	Assign(txt, txtName);
	Reset(txt);
	curLine := '';
	curLineNr := 0;
	curColNr := 1;
	GetNextChar; 

	GetNextWord(w, lnr);
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
