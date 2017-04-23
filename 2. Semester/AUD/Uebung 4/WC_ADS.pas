(* WC_ADS                 23.04.2017 *)
(* Container for strings             *)

UNIT WC_ADS;

INTERFACE 

  FUNCTION IsEmpty: BOOLEAN;
  FUNCTION Contains(s: STRING): BOOLEAN;
  PROCEDURE Insert(s: STRING);
  PROCEDURE Remove(s: STRING);
  PROCEDURE DisposeTree();

IMPLEMENTATION
  
  TYPE
    Node = ^NodeRec;
    NodeRec = RECORD
      data: STRING;
      left, right: Node;
    END;
  
  VAR 
    Tree : Node;
  
  PROCEDURE InitTree;
  BEGIN
    Tree := NIL;
  END;

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
  FUNCTION IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := Tree = NIL; 
  END;
  
  (* check if binsearchtree contains string
     recursive *)
  FUNCTION ContainsRec(VAR t: Node; s: STRING): BOOLEAN;
  BEGIN
    IF t = NIL THEN BEGIN
      ContainsRec := FALSE;
    END
    ELSE IF t^.data = s THEN 
      ContainsRec := TRUE
    ELSE IF s < t^.data THEN BEGIN
      ContainsRec := ContainsRec(t^.left, s);
    END
    ELSE BEGIN
      ContainsRec := ContainsRec(t^.right, s);
    END;
  END;
  
  (* check if binsearchtree contains string 
     Uses a help function *)
  FUNCTION Contains(s: STRING): BOOLEAN;
  BEGIN
    Contains := ContainsRec(Tree, s);
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
  PROCEDURE Insert (s : String);
  BEGIN
    InsertRec(Tree, NewNode(s));
  END;
  
  (* Remove a string from binsearchtree *)
  PROCEDURE Remove(s: STRING);
  VAR
    n, nPar: Node;
    st: Node; (*subtree*)
    succ, succPar: Node;
  BEGIN
    nPar := NIL;
    n := Tree;
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
				Tree := st
			ELSE IF n^.data < nPar^.data THEN
				nPar^.left := st
			ELSE
				nPar^.right := st;
			Dispose(n);
		END; (* n <> NIL *)
  END;
  
  (* Removes all the elements from the binary search tree 
     recursive *)
  PROCEDURE DisposeTree_rec(VAR Tree : Node);
  BEGIN
    IF Tree <> NIL THEN BEGIN

    (* Traverse the left subtree in postorder. *)
    DisposeTree_rec (Tree^.Left);

    (* Traverse the right subtree in postorder. *)
    DisposeTree_rec (Tree^.Right);

    (* Delete this leaf node from the tree. *)
    Dispose (Tree);
    END
  END;
  
  (* Removes all the elements from the binary search tree 
     calls rec. function *)
  PROCEDURE DisposeTree();
  BEGIN
    DisposeTree_rec(Tree);
  END;
  
BEGIN
  InitTree;
END.