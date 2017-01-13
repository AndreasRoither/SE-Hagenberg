PROGRAM balancedtree;

TYPE
  Node = ^NodeRec;
  NodeRec = RECORD
    value: INTEGER;
    left, right: Node;
  END;
  Tree = Node;

PROCEDURE InitTree (VAR t: Tree);
BEGIN
  t:= NIL;
END;

PROCEDURE InitArray (VAR arr: ARRAY OF Node);
VAR count : INTEGER;
BEGIN
  FOR count := 1 TO High(arr) DO
    arr[count] := NIL;
END;

FUNCTION NewNode (value: INTEGER): Node;
  VAR
    n: Node;
BEGIN
  New(n);
  n^.value := value;
  n^.left := NIL;
  n^.right := NIL;
  NewNode := n;
END;

(* Insert nodes recursive *)
PROCEDURE InsertRec (VAR t: Tree; n: Node);
BEGIN
	IF t= NIL THEN BEGIN
		t := n;
	END
	ELSE BEGIN
	IF n^.value < t^.value THEN
		InsertRec(t^.left, n)
	ELSE
		InsertRec(t^.right, n)
	END;	
END;

(* Adds a node to the Array *)
PROCEDURE AddToArray(VAR arr : ARRAY OF Node; n : Node);
VAR count : INTEGER;
BEGIN
  count := 0;
  WHILE (arr[count] <> NIL) AND (count <= High(arr)) DO
    count := count + 1;
  
  IF count <= High(arr) THEN 
    arr[count] := n
  ELSE
    WriteLn('Array already full!');
END;

(* Adds Nodes to the Array, sorted *)
PROCEDURE SaveTreeInOrder (t: Tree; VAR b_array : ARRAY OF Node);
BEGIN
  IF t <> NIL THEN 
  BEGIN
    SaveTreeInOrder(t^.left, b_array);
    AddToArray(b_array, t);
    SaveTreeInOrder(t^.right, b_array);
  END;
END;

(* Sets the left & right pointer of all Elements in the array to NIL *)
PROCEDURE CleanArray(VAR b_array : ARRAY OF Node);
VAR count : INTEGER;
BEGIN
  FOR count := 0 TO High(b_array) DO
  BEGIN
    IF b_array[Count] <> NIL THEN 
    BEGIN
      b_array[count]^.left := NIL;
      b_array[count]^.right := NIL;
    END;
  END;
END;

(* Count the nodes in a tree *)
PROCEDURE CountNodes (t: Tree; VAR count : INTEGER);
BEGIN
  IF t <> NIL THEN
  BEGIN
    CountNodes(t^.left, count);
    count := count + 1;
    CountNodes(t^.right, count);
  END;
END;

(* Returns the height of the tree *)
FUNCTION Height(t: Tree) : INTEGER;
VAR
  hl, hr: INTEGER;
BEGIN
  IF t = NIL THEN
    Height := 0
  ELSE BEGIN

  hl := Height (t^.left);
  hr := Height (t^.right);

  IF hl > hr THEN
    Height := 1 + hl
  ELSE
    Height := 1 + hr;
  END;
END;

FUNCTION CalculateHalf(i : LONGINT): INTEGER;
BEGIN
  
  IF i/2 = i DIV 2 THEN
    CalculateHalf := Round(i / 2 )
  ELSE
    CalculateHalf := (i DIV 2) + 1;
END;

(* write values of the array to the console *)
PROCEDURE PrintArray(b_array: ARRAY OF Node);
VAR count : INTEGER;
BEGIN
  WriteLn('Array:');
  FOR count := 0 TO High(b_array) DO
  BEGIN
    IF b_array[count] = NIL THEN 
      Write('NIL ')
    ELSE
      Write(b_array[count]^.value, ' ');
  END;
  WriteLn;
END;

(* Balance the tree so the height of the tree will be reduced*)
PROCEDURE Balance(VAR t: Tree);
VAR 
  c, length : INTEGER;
  pos : LONGINT;
  b_array : ARRAY OF Node;
  t_temp : Tree;
  
BEGIN
  IF t <> NIL THEN
  BEGIN
    WriteLn('Balancing....');

    c := 0;
    CountNodes(t,c);
    SetLength(b_array, c);
    InitArray(b_array);
    InitTree(t_temp);
    SaveTreeInOrder(t, b_array);
    PrintArray(b_array);

    WriteLn('Old height: ', Height(t));

    (* Has to be done after height function because the pointer left & right are  
       set to NIL in cleanarray (the height after that will be 1) *)
    CleanArray(b_array);

    length := High(b_array)+1;
    pos := length;

    WHILE pos > 2 DO 
    BEGIN
      pos := CalculateHalf(pos);
      InsertRec(t_temp, b_array[pos-1]);
      b_array[pos-1] := NIL;
    END;

    pos := CalculateHalf(length);

    WHILE pos < length-1 DO 
    BEGIN 
      pos := pos + CalculateHalf(length - pos);
      InsertRec(t_temp, b_array[pos-1]);
      b_array[pos-1] := NIL;
    END;

    FOR pos := 0 TO High(b_array) DO
    BEGIN
      IF b_array[pos] <> NIL THEN 
      BEGIN
        InsertRec(t_temp, b_array[pos]);
        b_array[pos] := NIL;
      END;
    END;
    t := t_temp;
    b_array := NIL;
    t_temp := NIL;

    WriteLn('New height: ', Height(t));
  END;
END;

PROCEDURE DisposeTree(VAR t: Tree);
BEGIN
  IF t <> NIL THEN BEGIN
    DisposeTree(t^.left);
    DisposeTree(t^.right);
    Dispose(t);
    t := NIL;
  END;
END;

VAR
  t : Tree;
  
BEGIN

  WriteLn(chr(205),chr(205),chr(185),' Binary Tree ',chr(204),chr(205),chr(205)); 
  
  InitTree(t);
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(2));
  InsertRec(t,NewNode(3));
  InsertRec(t,NewNode(4));
  InsertRec(t,NewNode(5));
  InsertRec(t,NewNode(6));
  InsertRec(t,NewNode(7));
  InsertRec(t,NewNode(8));
  InsertRec(t,NewNode(9));
  Balance(t);
  
  DisposeTree(t);

  WriteLn(#13#10, '---- new tree ----', #13#10);

  InitTree(t);
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(2));
  InsertRec(t,NewNode(3));
  InsertRec(t,NewNode(4));
  InsertRec(t,NewNode(5));
  InsertRec(t,NewNode(6));
  InsertRec(t,NewNode(7));
  InsertRec(t,NewNode(8));
  InsertRec(t,NewNode(9));
  InsertRec(t,NewNode(10));
  InsertRec(t,NewNode(11));
  InsertRec(t,NewNode(12));
  InsertRec(t,NewNode(13));
  InsertRec(t,NewNode(14));
  InsertRec(t,NewNode(15));
  InsertRec(t,NewNode(16));
  InsertRec(t,NewNode(17));
  InsertRec(t,NewNode(18));
  InsertRec(t,NewNode(19));
  Balance(t);

  DisposeTree(t);

  WriteLn(#13#10, '---- new tree ----', #13#10);
  
  InitTree(t);
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  InsertRec(t,NewNode(1));
  Balance(t);
END.