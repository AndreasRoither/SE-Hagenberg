(* IndexGen:                                     HDO, 2002-02-28 *)
(* --------                                                      *)
(* Generation of a sorted index of all words in a text file.     *)
(* Command line:                                                 *)
(*    IndexGen [ textFileName ]                                  *)
(*===============================================================*)
PROGRAM IndexGen;

	USES
	WinCrt, Timer;

	CONST
	EF = CHR(0);         (*end of file character*)
	maxWordLen = 30;     (*max. number of characters per word*)
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
			 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
	size = 30000;

	TYPE
	Word = STRING[maxWordLen];
	
	doubleListPtr = ^listElement;
	listElement = record
	  val : Integer;
	  Prev : doubleListPtr;
	  Next : doubleListPtr;
	end; (*Record*)
 
	dList = ^List;
	List = RECORD
		first: doubleListPtr;
		last:  doubleListPtr;
	END; (*Record*)

	NodePtr = ^Node;
		Node = RECORD
		key: STRING;
		data : dList;
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
		wordArray : ARRAY of STRING;
		wordCount : Integer;

	(* New has table node *) 
	function NewHashNode(key: String; next: NodePtr; data : dList) : NodePtr;
	var
		n: NodePtr;
	begin
		New(n);
		n^.key := key;
		n^.next := next;
		n^.data := data;
		NewHashNode := n;
	end; (*NewNode*)

	(* New double linked list node *)
	function NewDLListNode(val : Integer) : doubleListPtr;
	var temp : doubleListPtr;
	begin
		New(temp);
		temp^.val := val;
		temp^.prev := Nil;
		temp^.next := Nil;
		NewDLListNode := temp;
	end;

	(* init double linked list*)
	procedure InitDLList(var l : dList);
	begin
		l^.first := Nil;
		l^.last := Nil;
	end;
	
	(* append to double linked list *)
	procedure AppendDlList(var l : dList; val : Integer);
	var n : doubleListPtr;
	begin
		
		if (l^.first = Nil) then
		begin
			n := NewDLListNode(val);
			l^.first := n;
			l^.last := n;
		end
		else
		begin
			if l^.last^.val <> val then begin
				n := NewDLListNode(val);
				n^.prev := l^.last;
				l^.last^.next := n;
				l^.last := n;
			end;
		end; 
	end;

	(* returns the hashcode of a key *)
	function HashCode4(key: String): Integer;
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

		HashCode4 := Abs(hc) MOD size;
	end; (*HashCode4*)

	(* Lookup combines search and prepend *)
	function Lookup(key: String; val : Integer) : NodePtr;
	  var
		i: Integer;
		n: NodePtr;  
		l: dList;
	begin
		i := HashCode4(key);
		//WriteLn('Hashwert= ', i);
		n := ht[i];

		while (n <> Nil) do begin
		if (n^.key = key) THEN BEGIN
			AppendDlList(n^.data, val);
			exit;
		end;
		n := n^.next;
		end;

		if n = nil then begin
		New(l);
		InitDLList(l);
		AppendDlList(l, val);

		n := NewHashNode(key, ht[i], l);
		ht[i] := n;

		if wordCount >= High(wordArray) then
			SetLength(wordArray, (wordCount + 500));

		wordArray[wordcount] := key;
		wordCount := wordCount + 1;
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

	procedure WriteLineNumbers(d : dList);
	var 
	n : doubleListPtr;
	begin
		if d^.first <> NIL then begin
			n := d^.first;
			WHILE (n <> NIL) DO BEGIN
				Write(n^.val, ' ');
				n := n^.next;
			END;
		end;
	end;

	procedure WriteHashTable;
	var 
	h : Integer;
	n : NodePtr;
	d : dList;
	begin
	  for h:= 0 to size-1 do begin
		if ht[h] <> nil then begin 
		  Write(h, ': ');
		  n := ht[h];

		  while n <> nil do begin
			Write(n^.key, ' ');
			WriteLineNumbers(n^.data);
			
			n := n^.next;
		  end; (* while *)
		  WriteLn;
		end; (* if *)
	  end; (* for *)
	end; (* WriteHashTable *)

	PROCEDURE Swap(VAR a, b : String);
	VAR
		temp : String;
	BEGIN
		temp := b;
		b := a;
		a := temp;
	END;

	FUNCTION LT(a, b : String) : BOOLEAN;
	BEGIN
		LT := a < b;
	END;
  
	(* quicksort rec for string arrays *)
	PROCEDURE QuickSort(VAR arr : ARRAY OF String; n : INTEGER);
	PROCEDURE QuickSortRec(VAR arr : ARRAY OF String; l, u : INTEGER);
	VAR
	  p : String;
	  i, j : INTEGER;
	BEGIN
	  IF l < u THEN BEGIN
		(* at least 2 elements *)
		p := arr[l + (u - l) DIV 2]; (* use first element as pivot *)
		i := l;
		j := u;
		REPEAT
		  WHILE LT(arr[i], p) DO Inc(i);
		  WHILE LT(p, arr[j]) DO Dec(j);
		  
		  IF i <= j THEN BEGIN
			IF i <> j THEN BEGIN
			  Swap(arr[i], arr[j]);
			END;
			Inc(i);
			Dec(j);
		  END;
		UNTIL i > j;
		IF j > l THEN QuickSortRec(arr, l, j);
		IF i < u THEN QuickSortRec(arr, i, u);
	  END;
	END;

	BEGIN
		QuickSortRec(arr, Low(arr), n);
	END;

	procedure PrintStringArray();
	var 
		i : Integer;
		n : NodePtr;
	begin
		
		for i := 0 to wordCount do begin
			WriteLn;
			Write(wordArray[i], ': ',#9);
			n := ht[HashCode4(wordArray[i])];
			
			while (n <> NIL) AND (n^.key <> wordArray[i]) do begin
				n := n^.next;
			end;		
			
			if n <> nil then
				WriteLineNumbers(n^.data);
		end;
	end;
	
	procedure Init();
	var i : Integer;
	begin
		SetLength(wordArray,1000);

		for i := 0 to size-1 do begin
			ht[i] := NIL;
		end;
	end;
	
	VAR
		txtName: STRING;
		w: Word;        (*current word*)
		lnr: INTEGER;   (*line number of current word*)
		n: LONGINT;     (*number of words*)

BEGIN (*IndexGen*)
	Init;
	Write('IndexGen: index generation for text file ');

	IF ParamCount = 0 THEN BEGIN
		WriteLn;
		WriteLn;
		Write('name of text file > ');
		ReadLn(txtName);
	END (*THEN*)
	ELSE BEGIN
		txtName := ParamStr(1);
		WriteLn(txtName);
	END; (*ELSE*)
	WriteLn;

	(*--- read text from text file ---*)
	Assign(txt, txtName);
	Reset(txt);
	curLine := '';
	curLineNr := 0;
	curColNr := 1; (*curColNr > Length(curLine) forces reading of first line*)
	GetNextChar;   (*curCh now holds first character*)
	n := 0;
	wordCount := 0;
	
	StartTimer;
	GetNextWord(w, lnr);
	WHILE Length(w) > 0 DO BEGIN
		//WriteLn(w, ' ', lnr);
		Lookup(w,lnr);
		n := n + 1;
		GetNextWord(w, lnr);
	END; (*WHILE*)
	QuickSort(wordArray, wordCount);
	PrintStringArray();
	StopTimer;	

	WriteLn;
	WriteLn('number of words: ', n, ' ', wordCount);
	WriteLn('elapsed time:    ', ElapsedTime);
	Close(txt);

	ReadLn;

END. (*IndexGen*)