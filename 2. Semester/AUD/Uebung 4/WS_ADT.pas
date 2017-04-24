(* WS_ADT                 23.04.2017 *)
(* Container for strings             *)
(* Hidden data                       *)

UNIT WS_ADT;

INTERFACE 
  TYPE
    (* "hiding" of tree data *)
    TreePtr = POINTER;
    
  PROCEDURE InitTree(VAR Tree: TreePtr);
  FUNCTION IsEmpty(VAR Tree: TreePtr): BOOLEAN;
  FUNCTION Contains(VAR Tree: TreePtr; s: STRING): BOOLEAN;
  PROCEDURE Insert (VAR Tree: TreePtr; s : String);
  PROCEDURE Remove(VAR Tree: TreePtr; s: STRING);
  
  FUNCTION Union (s1,s2 : TreePtr) : TreePtr;
  FUNCTION Intersection (s1,s2 : TreePtr) : TreePtr;
  FUNCTION Difference (s1,s2 : TreePtr) : TreePtr;
  FUNCTION Cardinality (s1: TreePtr) : INTEGER;
  
  PROCEDURE DisposeWS(VAR Tree: TreePtr);

IMPLEMENTATION
  
  TYPE
    WordSet = ^WordSetRec;
    WordSetRec = RECORD
      data: STRING;
      left, right: WordSet;
    END;
  
  (* Init tree *)
  PROCEDURE InitTree(VAR Tree: TreePtr);
  BEGIN
    WordSet(Tree) := NIL;
  END;
  
  (* create a new WordSet 
     returns: WordSet *)
  FUNCTION NewWordSet (data: STRING): WordSet;
	VAR
		n: WordSet;
  BEGIN
    New(n);
    n^.data := data;
    n^.left := NIL;
    n^.right := NIL;
    NewWordSet := n;
  END;
  
  (* Check if binsearchtree is empty *)
  FUNCTION IsEmpty(VAR Tree: TreePtr): BOOLEAN;
  BEGIN
    IsEmpty := WordSet(Tree) = NIL; 
  END;
  
  (* check if binsearchtree contains string
     TypeCast to WordSet for rec. function *)
  FUNCTION ContainsRec(VAR t: TreePtr; s: STRING): BOOLEAN;
  BEGIN
    IF t = NIL THEN BEGIN
      ContainsRec := FALSE;
    END
    ELSE IF WordSet(t)^.data = s THEN 
      ContainsRec := TRUE
    ELSE IF s < WordSet(t)^.data THEN BEGIN
      ContainsRec := ContainsRec(WordSet(t)^.left, s);
    END
    ELSE BEGIN
      ContainsRec := ContainsRec(WordSet(t)^.right, s);
    END;
  END;
  
  (* check if binsearchtree contains string 
     TypeCast to WordSet for rec. function *)
  FUNCTION Contains(VAR Tree: TreePtr; s: STRING): BOOLEAN;
  BEGIN
    Contains := ContainsRec(WordSet(Tree), s);
  END;
 
 (* Insert in binsearchtree 
     recursive *)
  PROCEDURE InsertRec (VAR t: WordSet; n: WordSet);
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
     TypeCast to WordSet for rec. function *)
  PROCEDURE Insert (VAR Tree: TreePtr; s : String);
  BEGIN
    InsertRec(WordSet(Tree), NewWordSet(s));
  END;
  
  (* Remove a string from binsearchtree *)
  PROCEDURE Remove(VAR Tree: TreePtr; s: STRING);
  VAR
    n, nPar: WordSet;
    st: WordSet; (*subtree*)
    succ, succPar: WordSet;
  BEGIN
    nPar := NIL;
    n := WordSet(Tree);
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
				WordSet(Tree) := st
			ELSE IF n^.data < nPar^.data THEN
				nPar^.left := st
			ELSE
				nPar^.right := st;
			Dispose(n);
		END; (* n <> NIL *)
  END;
  
  (* copy a set 
     returns: WordSet*)
  FUNCTION CopyWSet(ws : WordSet) : WordSet;
    VAR
      n : WordSet;
  BEGIN
    IF ws = NIL THEN CopyWSet := NIL
    ELSE BEGIN
      New(n);
      n^.data := ws^.data;
      n^.left := CopyWSet(ws^.left);
      n^.right := CopyWSet(ws^.right);
      CopyWSet := n;
    END;
  END;
  
  (* inserts s1 into s2 and returns it 
     recursive *)
  FUNCTION UnionRec (s1,s2 : WordSet) : WordSet;
  VAR
    result : WordSet;
  BEGIN
    result := s2;
    IF s1 <> NIL THEN BEGIN
      Insert(result, s1^.data);
      UnionRec(s1^.left, result);
      UnionRec(s1^.right, result);
    END;
    UnionRec := result;
   END;
 
  (* union, calls recursive function 
     TypeCast to WordSet for rec. function *)
  FUNCTION Union (s1,s2 : TreePtr) : TreePtr;
  BEGIN
    Union := WordSet(UnionRec(WordSet(s1),WordSet(s2)));
  END;
  
  (* removes Nodes that are not present in s2 
     recursive *)
  FUNCTION IntersectionRec (VAR s1,s2 : WordSet) : WordSet;
  BEGIN
    IF s1 <> NIL THEN BEGIN
      (* words that are NOT in both *)
      IF NOT Contains(s2 ,s1^.data) THEN BEGIN
        Remove(s1, s1^.data);
        s1 := IntersectionRec(s1,s2);
      END 
      ELSE BEGIN
        IntersectionRec(s1^.left, s2);
        IntersectionRec(s1^.right, s2);
      END;
    END;
    IntersectionRec := s1;
  END;
  
  (* intersection, calls recursive function 
     TypeCast to WordSet for rec. function *)
  FUNCTION Intersection (s1,s2 : TreePtr) : TreePtr;
  BEGIN
    Intersection := WordSet(IntersectionRec(WordSet(s1),WordSet(s2)));
  END;
  
  (* removes Nodes that are present in s2 
     recursive *)
  FUNCTION DifferenceRec (VAR s1,s2 : WordSet) : WordSet;
  BEGIN
    IF s1 <> NIL THEN BEGIN
      IF Contains(s2 ,s1^.data) THEN BEGIN
        Remove(s1, s1^.data);
        s1 := DifferenceRec(s1,s2);
      END 
      ELSE BEGIN
        DifferenceRec(s1^.left, s2);
        DifferenceRec(s1^.right, s2);
      END;
    END;
    DifferenceRec := s1;
  END;
  
  (* difference, calls recursive function 
     TypeCast to WordSet for rec. function *)
  FUNCTION Difference (s1,s2 : TreePtr) : TreePtr;
  BEGIN
    WordSet(Difference) := DifferenceRec(WordSet(s1),WordSet(s2));
  END;
 
  (* number of words in a WordSet 
     returns 0 if none are found  *)
  FUNCTION Cardinality (s1: TreePtr) : INTEGER;
  BEGIN
    (* 0 if nothing is found *)
    Cardinality := 0;
    IF s1 <> NIL THEN BEGIN
      Cardinality := 1;
      IF (WordSet(s1)^.left <> NIL) AND (WordSet(s1)^.right <> NIL) THEN BEGIN
        Cardinality := Cardinality(WordSet(s1)^.left) + Cardinality(WordSet(s1)^.right) + 1;
      END 
      ELSE
        IF WordSet(s1)^.left <> NIL THEN Cardinality := Cardinality(WordSet(s1)^.left) + 1
        ELSE IF WordSet(s1)^.right <> NIL THEN Cardinality := Cardinality(WordSet(s1)^.right) + 1;
    END;
  END;
  
  (* Removes all the elements from the binary search tree *)
  (* rooted at Tree, leaving the tree empty. *)
  PROCEDURE DisposeWS(VAR Tree : TreePtr);
  BEGIN
    (* Base Case: If Tree is NIL, do nothing. *)
    IF Tree <> NIL THEN BEGIN

    (* Traverse the left subtree in postorder. *)
    DisposeWS (WordSet(Tree)^.Left);

    (* Traverse the right subtree in postorder. *)
    DisposeWS (WordSet(Tree)^.Right);

    (* Delete this leaf node from the tree. *)
    Dispose (WordSet(Tree));
    END
  END;
BEGIN
END.