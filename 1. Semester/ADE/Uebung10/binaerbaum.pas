PROGRAM binaerbaum;

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

PROCEDURE InsertNode( VAR t: tree; n: Node);
VAR
  subtree, parent: Node;
BEGIN
  IF t = NIL THEN BEGIN
    t := n;
  END
  ELSE BEGIN
    parent := NIL;
    subtree := t;
    WHILE subtree <> NIL DO BEGIN
      parent := subtree;
        IF n^.value < subtree^.value THEN BEGIN
          subtree := subtree^.left;
        END
        ELSE (*n^.value >= subtree^.value*)
          subtree := subtree^.right;
      END;
      IF n^.value < parent^.value THEN
        parent^.left := n
      ELSE
        parent^.right := n;
  END;
END;

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

PROCEDURE WriteTreeInOrder (t: Tree);
BEGIN
  IF t <> NIL THEN 
  BEGIN
    WriteTreeInOrder(t^.left);
    WriteLn(t^.value);
    WriteTreeInOrder(t^.right);
  END;
END;

PROCEDURE SaveTreeInOrder (t: Tree; VAR b_array : ARRAY OF Node);
BEGIN
  IF t <> NIL THEN 
  BEGIN
    SaveTreeInOrder(t^.left, b_array);
    AddToArray(b_array, t);
    SaveTreeInOrder(t^.right, b_array);
  END;
END;

PROCEDURE CountNodes (t: Tree; VAR count : INTEGER);
BEGIN
  IF t <> NIL THEN
  BEGIN
    CountNodes(t^.left, count);
    count := count + 1;
    CountNodes(t^.right, count);
  END;
END;

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

PROCEDURE PrintArray(b_array: ARRAY OF Node);
VAR count : INTEGER;
BEGIN
  FOR count := 0 TO High(b_array) DO
  BEGIN
    IF b_array[Count] = NIL THEN 
      Write('NIL ')
    ELSE
      Write(b_array[count]^.value, ' ');
  END;
  WriteLn;
END;

PROCEDURE Balance(VAR t: Tree);
VAR 
  c : INTEGER;
  b_array : ARRAY OF Node;
  
BEGIN
  IF t <> NIL THEN
  BEGIN
    c := 0;

    CountNodes(t,c);
    SetLength(b_array, c);
    InitArray(b_array);
    SaveTreeInOrder(t, b_array);
    PrintArray(b_array);
    
    WriteLn();
    
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
  c : INTEGER;
  
BEGIN

  WriteLn(chr(205),chr(205),chr(185),' Binary Tree ',chr(204),chr(205),chr(205)); 
  c := 0;
  
  InitTree(t);
  InsertNode(t,NewNode(14));
  InsertNode(t,NewNode(5));
  InsertNode(t,NewNode(20));
  InsertNode(t, NewNode(12));
  InsertNode(t, NewNode(11));
  InsertNode(t, NewNode(3));
  InsertNode(t, NewNode(25));

  WriteLn('-InOrder-');
  WriteTreeInOrder(t);
  WriteLn('Height= ', Height(t));
  
  WriteLn('-----------------------');
  CountNodes(t,c);
  WriteLn('Nodes: ', c);
  WriteLn('-----------------------');
  
  Balance(t);
  
  DisposeTree(t);
  WriteLn('-----------------------');
END.