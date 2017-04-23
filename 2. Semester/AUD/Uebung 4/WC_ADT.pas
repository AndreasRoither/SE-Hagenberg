(* WC_ADT                 23.04.2017 *)
(* Container for strings             *)
(* Hidden data                       *)

UNIT WC_ADT;

INTERFACE 
  TYPE
    (* "hiding" of tree data *)
    TreePtr = POINTER;
    
  PROCEDURE InitTree(VAR Tree: TreePtr);
  FUNCTION IsEmpty(VAR Tree: TreePtr): BOOLEAN;
  FUNCTION Contains(VAR Tree: TreePtr; s: STRING): BOOLEAN;
  PROCEDURE Insert (VAR Tree: TreePtr; s : String);
  PROCEDURE Remove(VAR Tree: TreePtr; s: STRING);
  PROCEDURE DisposeTree(VAR Tree : TreePtr);

IMPLEMENTATION
  
  TYPE
    Node = ^NodeRec;
    NodeRec = RECORD
      data: STRING;
      left, right: Node;
    END;
  
  (* Init tree *)
  PROCEDURE InitTree(VAR Tree: TreePtr);
  BEGIN
    Node(Tree) := NIL;
  END;
  
  (* create a new node 
     returns: Node *)
  FUNCTION NewNode (data: STRING): Node;
	VAR
		n: Node;
  BEGIN
    New(n);
    n^.data := data;
    n^.left := NIL;
    n^.right := NIL;
    NewNode := n;
  END;
  
  (* Check if binsearchtree is empty *)
  FUNCTION IsEmpty(VAR Tree: TreePtr): BOOLEAN;
  BEGIN
    IsEmpty := Node(Tree) = NIL; 
  END;
  
  (* check if binsearchtree contains string
     recursive *)
  FUNCTION ContainsRec(VAR t: TreePtr; s: STRING): BOOLEAN;
  BEGIN
    IF t = NIL THEN BEGIN
      ContainsRec := FALSE;
    END
    ELSE IF Node(t)^.data = s THEN 
      ContainsRec := TRUE
    ELSE IF s < Node(t)^.data THEN BEGIN
      ContainsRec := ContainsRec(Node(t)^.left, s);
    END
    ELSE BEGIN
      ContainsRec := ContainsRec(Node(t)^.right, s);
    END;
  END;
  
  (* check if binsearchtree contains string 
     Uses a help function *)
  FUNCTION Contains(VAR Tree: TreePtr; s: STRING): BOOLEAN;
  BEGIN
    Contains := ContainsRec(Node(Tree), s);
  END;
 
 (* Insert in binsearchtree 
     recursive *)
  PROCEDURE InsertRec (VAR t: Node; n: Node);
  BEGIN
    IF t = NIL THEN BEGIN
      t := n;
    END
    ELSE BEGIN
    IF (n^.data = t^.data) THEN Exit
    ELSE IF n^.data < t^.data THEN
      InsertRec(t^.left, n)
    ELSE
      InsertRec(t^.right, n)
    END;    
  END;
  
  (* Insert a string in binsearchtree
     Uses a help function *)
  PROCEDURE Insert (VAR Tree: TreePtr; s : String);
  BEGIN
    InsertRec(Node(Tree), NewNode(s));
  END;
  
  (* Remove a string from binsearchtree *)
  PROCEDURE Remove(VAR Tree: TreePtr; s: STRING);
  VAR
    n, nPar: Node;
    st: Node; (*subtree*)
    succ, succPar: Node;
  BEGIN
    nPar := NIL;
    n := Node(Tree);
	WHILE (n <> NIL) AND (n^.data <> s) DO BEGIN
		nPar := n;
		IF s < n^.data THEN
			n := n^.left
		ELSE
			n := n^.right;
		END;
		IF n <> NIL THEN BEGIN (* no right subtree *)
			IF n^.right = NIL THEN BEGIN
				st := n^.left;
			END
			ELSE BEGIN
				IF n^.right^.left = NIL THEN BEGIN (* right subtree, but no left subtree *)
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
			(* insert the new sub-tree *)
			IF nPar = NIL THEN
				Node(Tree) := st
			ELSE IF n^.data < nPar^.data THEN
				nPar^.left := st
			ELSE
				nPar^.right := st;
			Dispose(n);
		END; (* n <> NIL *)
  END;
  
  (* Removes all the elements from the binary search tree *)
  (* rooted at Tree, leaving the tree empty. *)
  PROCEDURE DisposeTree(VAR Tree : TreePtr);
  BEGIN
    (* Base Case: If Tree is NIL, do nothing. *)
    IF Tree <> NIL THEN BEGIN

    (* Traverse the left subtree in postorder. *)
    DisposeTree (Node(Tree)^.Left);

    (* Traverse the right subtree in postorder. *)
    DisposeTree (Node(Tree)^.Right);

    (* Delete this leaf node from the tree. *)
    Dispose (Node(Tree));
    END
  END;
BEGIN
END.