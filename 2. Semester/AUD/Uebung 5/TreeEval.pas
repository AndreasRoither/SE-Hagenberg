(* TreeEval    26.04.17 *)

PROGRAM TreeEval;
  CONST
    eosCh = Chr(0);

  TYPE
    SymbolCode = (noSy, (* error symbol *)
                  eosSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, righParSy,
                  number, variable);

    NodePtr = ^Node;
    Node = RECORD
      txt: STRING;
      left, right: NodePtr;
    END;
    TreePtr = NodePtr;

  VAR
    sy: SymbolCode;
    ch: CHAR;
    cnr: INTEGER;
    numberVal, variableStr, line: STRING;
    success: BOOLEAN;
    tr : TreePtr;

  (* ====== Scanner ====== *)
  PROCEDURE NewCh;
  BEGIN
    IF cnr < Length(line) THEN BEGIN
      cnr := cnr + 1;
      ch := line[cnr];
    END
    ELSE BEGIN
      ch := eosCh;
    END;
  END;

  PROCEDURE NewSy;
    VAR
    numberStr: STRING; 
    code: INTEGER;
  BEGIN
    WHILE ch = ' ' DO BEGIN
      NewCh;
    END;

    CASE ch OF
      eosCh: BEGIN
          sy := eosSy;
        END;
      '+': BEGIN
          sy := plusSy;
          NewCh;
        END;
      '-': BEGIN
          sy := minusSy;
          NewCh;
        END;
      '*': BEGIN
          sy := timesSy;
          NewCh;
        END;
      '/': BEGIN
          sy := divSy;
          NewCh;
        END;
      '(': BEGIN
          sy := leftParSy;
          NewCh;
        END;
      ')': BEGIN
          sy := righParSy;
          NewCh;
        END;
      (* for numbers *)
      '0'..'9': BEGIN
          sy := number;
          numberStr := '';

          WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
            numberStr := numberStr + ch;
            NewCh;
          END;
          numberVal := numberStr;
        END;

      (* for characters *)
      'A' .. 'Z', 'a'..'z': BEGIN
        sy := variable;
        variableStr := '';

        WHILE ((ch >= 'A') AND (ch < 'Z')) OR ((ch >= 'a') AND (ch < 'z')) DO
        BEGIN
          variableStr := variableStr + ch;
          NewCh;
        END;
      END;
    ELSE
      sy := noSy;
    END;
  END;

  (* ====== PARSER ====== *)
  PROCEDURE S; FORWARD;
  PROCEDURE Expr(VAR e: NodePtr); FORWARD;
  PROCEDURE Term(VAR t: NodePtr); FORWARD;
  PROCEDURE Fact(VAR f: NodePtr); FORWARD;
  FUNCTION NewNode (value: STRING): NodePtr; FORWARD;
  FUNCTION NewNode2 (leftSubTree, rightSubTree: NodePtr; value: STRING): NodePtr; FORWARD;

  PROCEDURE S;
  VAR
    e: NodePtr;
  BEGIN
    Expr(e); IF NOT success THEN EXIT;
    tr := e;
    IF sy <> eosSy THEN BEGIN success := FALSE; EXIT; END;
  END;

  PROCEDURE Expr(VAR e: NodePtr);
    VAR
      t1, t2: NodePtr;
  BEGIN
    Term(t1); IF NOT success THEN EXIT;
    (* SEM *)
    e := t1;
    (* ENDSEM *)
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN EXIT;
            (* SEM *)
            e := NewNode2(t1, t2, '+');
            t1 := e;
            (* ENDSEM *)
          END;
        minusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN EXIT;
            (* SEM *)
            e := NewNode2(t1, t2, '-');
            t1 := e;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Term(VAR t: NodePtr);
    VAR 
      f1, f2: NodePtr;
  BEGIN
    Fact(f1); IF NOT success THEN EXIT;
    (* SEM *)
    t := f1;
    (* ENDSEM *)
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN
            NewSy;
            Fact(f2); IF NOT success THEN EXIT;
            (* SEM *)
            t := NewNode2(f1, f2, '*');
            f1 := t;
            (* ENDSEM *)
          END;
        divSy: BEGIN
            NewSy;
            Fact(f2); IF NOT success THEN EXIT;
            (* SEM *)
            t := NewNode2(f1, f2, '/');
            f1 := t;
            (* ENDSEM *)
          END;
      END;
    END;
  END;

  PROCEDURE Fact(VAR f: NodePtr);
  BEGIN
    CASE sy OF
      number: BEGIN
          (* SEM *)
          f := NewNode(numberVal);
          (* ENDSEM *)
          NewSy;
        END;
      variable: BEGIN
          f := NewNode(variableStr);
          NewSy;
        END;
      leftParSy: BEGIN
          NewSy;
          Expr(f); IF NOT success THEN EXIT;
          IF sy <> righParSy THEN BEGIN success:= FALSE; EXIT; END;
          NewSy;
        END;
      ELSE
        success := FALSE;
    END;
  END;
  (* ====== END PARSER ====== *)

  (* ========= TREE ========= *)

  PROCEDURE InitTree (VAR t: TreePtr);
  BEGIN
    t:= NIL;
  END;

  (* NewNode with string *)
  FUNCTION NewNode (value: STRING): NodePtr;
    VAR
      n: NodePtr;
  BEGIN
    New(n);
    n^.txt := value;
    n^.left := NIL;
    n^.right := NIL;
    NewNode := n;
  END;

  (* NewNode2 with value as root and the two other Nodes as left and right subtree *)
  FUNCTION NewNode2 (leftSubTree, rightSubTree: NodePtr; value: STRING): NodePtr;
    VAR
      n: NodePtr;
  BEGIN
    New(n);
    n^.txt := value;
    n^.left := leftSubTree;
    n^.right := rightSubTree;
    NewNode2 := n;
  END;

  PROCEDURE WriteTreeInOrder (t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      WriteTreeInOrder(t^.left);
      Write(t^.txt);
      WriteTreeInOrder(t^.right);
    END;
  END;

  PROCEDURE WriteTreePreOrder (t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      Write(t^.txt);
      WriteTreePreOrder(t^.left);
      WriteTreePreOrder(t^.right);
    END;
  END;

  PROCEDURE WriteTreePostOrder (t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      WriteTreePostOrder(t^.left);
      WriteTreePostOrder(t^.right);
      Write(t^.txt);
    END;
  END;

  (* calculate value of the tree *)
  FUNCTION ValueOf(t: TreePtr): INTEGER;
  BEGIN
    IF t <> NIL THEN BEGIN
      CASE t^.txt OF
        '+': BEGIN
            ValueOf := ValueOf(t^.left) + ValueOf(t^.right);
          END;
        '-': BEGIN
            ValueOf := ValueOf(t^.left) - ValueOf(t^.right);
          END;
        '*': BEGIN
            ValueOf := ValueOf(t^.left) * ValueOf(t^.right);
          END;
        '/': BEGIN
            ValueOf := ValueOf(t^.left) DIV ValueOf(t^.right);
          END;
        ELSE BEGIN
            Val(t^.txt,ValueOf);
          END;
      END;
    END;
  END;

  PROCEDURE DisposeTree(VAR t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      DisposeTree(t^.left);
      DisposeTree(t^.right);
      Dispose(t);
      t := NIL;
    END;
  END;

  (* ======= END TREE ======== *)

  PROCEDURE SyntaxTest(str: STRING);
  BEGIN
    WriteLn('Infix: ', str);
    line := str;
    cnr := 0;
    NewCh;
    NewSy;
    success := TRUE;

    S;
    IF success THEN WriteLn('successful syntax analysis',#13#10) ELSE WriteLn('Error in column: ', cnr,#13#10);

    WriteLn('-InOrder-');
    WriteTreeInOrder(tr);
    WriteLn(#13#10, '-PreOrder-');
    WriteTreePreOrder(tr);
    WriteLn(#13#10, '-PostOrder-');
    WriteTreePostOrder(tr);
    WriteLn(#13#10, 'ValueOf: ', ValueOf(tr), #13#10);
  END;

BEGIN
  InitTree(tr);
  SyntaxTest('(1 + 2) * 3');
  DisposeTree(tr);

  InitTree(tr);
  SyntaxTest('(1 + 2) * 3 + 2');
  DisposeTree(tr);

  InitTree(tr);
  SyntaxTest('(2 - 1) * 3 + 2');
  DisposeTree(tr);

  InitTree(tr);
  SyntaxTest('(1 + (2*4)) * 2');
  DisposeTree(tr);
END.