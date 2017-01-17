PROGRAM bintree;

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

PROCEDURE WriteTreeInOrder (t: Tree);
BEGIN
	IF t <> NIL THEN BEGIN
		WriteTreeInOrder(t^.left);
		WriteLn(t^.value);
		WriteTreeInOrder(t^.right);
	END;
END;

PROCEDURE WriteTreePreOrder (t: Tree);
BEGIN
	IF t <> NIL THEN BEGIN
		WriteLn(t^.value);
		WriteTreePreOrder(t^.left);
		WriteTreePreOrder(t^.right);
	END;
END;

PROCEDURE WriteTreePostOrder (t: Tree);
BEGIN
	IF t <> NIL THEN BEGIN
		WriteTreePostOrder(t^.left);
		WriteTreePostOrder(t^.right);
		WriteLn(t^.value);
		
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

PROCEDURE Remove (VAR t: Tree; value: INTEGER);
VAR
	n, nPar: Node;
	st: Node; (*subtree*)
	succ, succPar: Node;
BEGIN
	nPar := NIL;
	n := t;
	WHILE (n <> NIL) AND (n^.value <> value) DO BEGIN
		nPar := n;
		IF value < n^.value THEN
			n := n^.left
		ELSE
			n := n^.right;
		END;
		IF n <> NIL THEN BEGIN (*kein Rechter Teilbaum*)
			IF n^.right = NIL THEN BEGIN
				st := n^.left;
			END
			ELSE BEGIN
				IF n^.right^.left = NIL THEN BEGIN (*rechter Teilbaum, aber kein linker Nachfolger davon*)
					st := n^.right;
					st^.left := n^.left;
				END
				ELSE BEGIN
					(*common case*)
					succPar := NIL;
					succ := n^.right;
					WHILE succ^.left <> NIL DO BEGIN
						succPar := succ;
						succ := succ^.left;
					END;
						succPar^.left := succ^.right;
						st := succ;
						st^.left := n^.left;
						st^.right := n^.right;
				END;
			END;
			(*insert the new sub-tree*)
			IF nPar = NIL THEN
				t := st
			ELSE IF n^.value < nPar^.value THEN
				nPar^.left := st
			ELSE
				nPar^.right := st;
			Dispose(n);
		END; (*n<> NIL*)
END;

PROCEDURE FindValuePreOrder (t: Tree; val : INTEGER);
BEGIN
	IF t <> NIL THEN BEGIN
		IF val = t^.value THEN
			WriteLn('Found');
		FindValuePreOrder(t^.left, val);
		FindValuePreOrder(t^.right, val);
	END;
END;

PROCEDURE RemoveValuePreOrder (t,t_temp: Tree; val : INTEGER);
BEGIN
	IF t <> NIL THEN BEGIN

		IF (t^.value = val) THEN
		BEGIN
			WriteLn('t: ',t^.value);
			WriteLn('ttemp: ',t_temp^.value, ' ', t_temp^.left^.value, ' ',t_temp^.right^.value);
			IF val >= t_temp^.value THEN
			BEGIN
				IF t^.right <> NIL THEN
					t_temp^.right := t^.right
				ELSE IF t^.left <> NIL THEN
					t_temp^.right := t^.left
				ELSE
					t_temp^.right := NIL;
			END
			ELSE
			BEGIN
				IF t^.right <> NIL THEN
					t_temp^.left := t^.right
				ELSE IF t^.left <> NIL THEN
					t_temp^.left := t^.left
				ELSE
					t_temp^.right := NIL;
			END;
			t^.left := NIL;
			t^.right := NIL;
			Dispose(t);
		END;

		t_temp := t;
		
		IF val < t^.value THEN
			RemoveValuePreOrder(t^.left, t_temp, val)
		ELSE
			RemoveValuePreOrder(t^.right, t_temp, val);
	END;
END;

(* amount of value in tree *)
FUNCTION AmountOf(t : Tree; val : INTEGER) : INTEGER;
VAR
	amount : INTEGER;
BEGIN
	amount := 0;
	IF t = NIL THEN BEGIN
		AmountOf := amount;
	END
	ELSE IF t^.value = val THEN BEGIN
		amount := AmountOf(t^.right, val) + 1;
	END
	ELSE IF t^.value > val THEN BEGIN
		amount := AmountOf(t^.left, val);
	END
	ELSE IF t^.value < val THEN BEGIN
		amount := AmountOf(t^.right, val);
	END;
	AmountOf := amount;
END;


FUNCTION ContainsVal(t : Tree; val : INTEGER) : BOOLEAN;
BEGIN
	IF t = NIL THEN BEGIN
		ContainsVal := false;
	END
	ELSE IF t^.value = val THEN BEGIN
		ContainsVal := true;
	END
	ELSE IF val < t^.value THEN BEGIN
		ContainsVal := ContainsVal(t^.left, val);
	END
	ELSE BEGIN
		ContainsVal := ContainsVal(t^.right, val);
	END;
END;

FUNCTION IsSorted(t : Tree) : BOOLEAN;
VAR b : BOOLEAN;
BEGIN
	b := true;
	IF t <> NIL THEN BEGIN
		b := IsSorted(t^.left) AND IsSorted(t^.right);
		IF t^.left <> NIL THEN BEGIN
			b := b AND (t^.left^.value < t^.value);
		END;
		IF t^.right <> NIL THEN BEGIN
			b := b AND (t^.right^.value >= t^.value);
		END;
	END;
	ISSorted := b;
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
	t,t_temp: Tree;
	
BEGIN
	InitTree(t);
	InitTree(t_temp);
	InsertNode(t,NewNode(14));
	InsertNode(t,NewNode(5));
	InsertNode(t,NewNode(5));
	InsertNode(t,NewNode(20));
	InsertRec(t, NewNode(12));
	InsertRec(t, NewNode(11));
	InsertRec(t, NewNode(3));
	InsertRec(t, NewNode(25));
	InsertNode(t,NewNode(5));


	// WriteLn('-InOrder-');
	// WriteTreeInOrder(t);
	// Remove(t, 11);
	// WriteLn('Removed 11 ---------');
	// WriteLn('-PreOrder-');
	// WriteTreePreOrder(t);
	// WriteLn('-PostOrder-');
	// WriteTreePostOrder(t);
	// WriteLn('-----------------------');
	// WriteLn('Height= ', Height(t));
	// DisposeTree(t);
	// WriteLn('-----------------------');
	// WriteTreePostOrder(t);

	//Wurzelknoten removen geht nicht
	//RemoveValuePreOrder(t,t_temp,5);

	WriteLn('Found: ', AmountOf(t, 5));
	//WriteTreeInOrder(t);



    DisposeTree(t);
END.