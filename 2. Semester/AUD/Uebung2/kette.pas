PROGRAM kette;

  TYPE
    nodePtr = ^listElement;
    listElement = RECORD
      next: nodePtr;
      c: Char;
    END; (* RECORD *)

  (* Creates a new node*)
  FUNCTION NewNode(c : Char): nodePtr;
  VAR node : nodePtr;
  BEGIN
	New(node);
	node^.next := NIL;
	node^.c := c;
	NewNode := node;
  END;

  (* Appends a Node to a List *)
  PROCEDURE Append(var list : nodePtr; element : nodePtr);
  VAR tmp : nodePtr;
  BEGIN
	if list = NIL THEN list := element ELSE 
	BEGIN
		tmp := list;
		WHILE tmp^.next <> NIL DO tmp := tmp^.next;
		
		tmp^.next := element;   	 
	END;
  END;
  
  (* recursive; disposes every node in a list *)
  PROCEDURE ClearList(var list : nodePtr);
  BEGIN
	IF list <> NIL THEN
	BEGIN
		IF list^.next = NIL THEN dispose(list) ELSE ClearList(list^.next);
	END;
  END;
  
  (* Counts nodes in a list *)
  FUNCTION CountNodes(n : nodePtr) : INTEGER;
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
  
  PROCEDURE RemoveFirst(var list : nodePtr);
  VAR
	temp : nodePtr;
  BEGIN
	IF list <> NIL THEN BEGIN
		temp := list;
		list := list^.next;
		Dispose(temp);
	END;
  END;
  
  (* Check if char exists in the list; 
     Returns TRUE OR FALSE *)
  FUNCTION CharExists(list : nodePtr; c : Char): Boolean;
  VAR 
	n : nodePtr;
  BEGIN
	n := list;

	WHILE n <> NIL DO BEGIN
		IF n^.c = c THEN BEGIN
			CharExists := TRUE;
			break;
		END;
		n := n^.next;
	END;
	
	IF n = NIL THEN CharExists := FALSE;
  END;
  
  (* Counts different chars in a list; 
     RETURNS 0 if empty*)
  FUNCTION CountDistinct(list: nodePtr): Integer;
  VAR
	temp, temp2 : nodePtr;
  BEGIN
	IF list <> NIL THEN 
	BEGIN
		temp := list;
		temp2 := NIL;
		
		WHILE temp <> NIL DO BEGIN
			IF NOT CharExists(temp2,temp^.c) THEN Append(temp2, NewNode(temp^.c));
			temp := temp^.next;
		END;
		
		CountDistinct := CountNodes(temp2);
		ClearList(temp2);
	END 
	ELSE
		CountDistinct := 0;
  END;
  
  (* Prints out list *)
  PROCEDURE PrintList(list : nodePtr);
  VAR
	n : nodePtr;
  BEGIN
	n := list;
	
	WHILE n <> NIL DO BEGIN
		Write(n^.c);
		n := n^.next;
	END;
	WriteLn;
  END;
  
  (* Insert to string from a list RETURNS STRING*)
  FUNCTION InsertinString(list : nodePtr): STRING;
  VAR
	n : nodePtr;
	s : STRING;
  BEGIN
	n := list;
	s := '';
	
	WHILE n <> NIL DO BEGIN
		s := Concat(s,n^.c);
		n := n^.next;
	END;
	InsertinString := s;
  END;
  
  (* Implementation with Single Linked List *)
  FUNCTION MinM(s: STRING) : Integer;
  VAR
	i : Integer;
	list : nodePtr;
  BEGIN
	list := NIL;
	
	FOR i := 1 TO Length(s) DO BEGIN
		IF NOT CharExists(list,s[i]) THEN Append(list, NewNode(s[i]));
	END;
	
	MinM := CountNodes(list);
  END;
  
  (* Implementation with Single Linked List *)
  FUNCTION MaxMStringLen(var longestS: STRING; s: STRING; m: Integer): Integer;
  VAR
	i, count, tempCount, maxLength : Integer;
	list : nodePtr;
  BEGIN
	list := NIL;
	count := 0;
	maxLength := 0;
	
	FOR i := 1 TO Length(s) DO BEGIN
		
		Append(list, NewNode(s[i]));
		tempCount := CountDistinct(list);
		//Write(tempCount, ' ', count, ' ');
		//PrintList(list);
		
		IF tempCount > m THEN 
		BEGIN
			RemoveFirst(list);
		END
		ELSE
			count := count + 1;
		
		IF count > maxLength THEN BEGIN
			maxLength := count;
			longestS := InsertinString(list);
			
		END;
	END;
	MaxMStringLen := maxLength;
  END;
  
  VAR 
	s1, s2, s3, longest : String;
BEGIN
  s1 := 'abcbaac';
  s2 := 'abcd';
  s3 := 'abcdefgggggggggggggggggraabbcdertzuiogaaaaaaaaaaaaaaaaaaaaa';
  s3 := 'abcdefgggggggggggggggggraabbcdertzuiogaaaaaaaaaaaaaaaaaaaaa';
  longest := '';
  
  WriteLn('String 1: ', s1, #13#10#9, 'Min m: ', MinM(s1));
  WriteLn('String 2: ', s2, #13#10#9, 'Min m: ', MinM(s2));
  WriteLn('String 3: ', s3, #13#10#9, 'Min m: ', MinM(s3));
  WriteLn('---------------------------------------------');
  WriteLn('String 1 mit m 2: ', s1, #13#10#9,'MaxM: ', MaxMStringLen(longest,s1,2), 
	#13#10#9, 'Longest substring: ', longest, #13#10);
  WriteLn('String 2 mit m 4: ', s2, #13#10#9,'MaxM: ', MaxMStringLen(longest,s2,4), 
	#13#10#9, 'Longest substring: ', longest, #13#10);
  WriteLn('String 3 mit m 5: ', s3, #13#10#9,'MaxM: ', MaxMStringLen(longest,s3,5), 
	#13#10#9, 'Longest substring: ', longest, #13#10);
	WriteLn('String 3 mit m 7: ', s3, #13#10#9,'MaxM: ', MaxMStringLen(longest,s3,7), 
	#13#10#9, 'Longest substring: ', longest, #13#10);

END.