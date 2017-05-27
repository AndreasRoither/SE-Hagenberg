(* SymTab:                                          HDO, 2004-02-06
   ------
   Symbol table handling for the MiniPascal Interpreter and 
   the MiniPascal Compiler.
===================================================================*)
UNIT SymTab;


INTERFACE

  PROCEDURE InitSymbolTable;

  PROCEDURE DeclVar(id: STRING; VAR ok: BOOLEAN);
  FUNCTION IsDecl(id: STRING): BOOLEAN;

(*for the MiniPascal Interpreter only:*)

  PROCEDURE SetVal(id: STRING; val: INTEGER);
  PROCEDURE GetVal(id: STRING; VAR val: INTEGER);

(*for the MiniPascal Compiler only:*)

  FUNCTION AddrOf(id: STRING): INTEGER;


IMPLEMENTATION

  CONST
    max = 20;

  TYPE
    VarInfo = RECORD
      id:  STRING;    (*identifier*)
      val: INTEGER;   (*used in the interpreter only*)
      addr: INTEGER;  (*used in the compiler    only*)
    END; (*RECORD*)

  VAR
    st: ARRAY [1 .. max] OF VarInfo;
    n: INTEGER;


  FUNCTION Lookup (id: STRING): INTEGER;
    VAR
      i: INTEGER;
  BEGIN
    i := 1;
    WHILE (i <= n) AND (id <> st[i].id) DO BEGIN
      i := i + 1;
    END; (*WHILE*)
    IF i <= n THEN
      Lookup := i  (*id is at index i in st*)
    ELSE
      Lookup := 0; (*id not found*)
  END; (*Lookup*)
  
  
  PROCEDURE InitSymbolTable;
(*-----------------------------------------------------------------*)
  BEGIN
    n := 0;
  END; (*InitSymbolTable*)


  PROCEDURE DeclVar(id: STRING; VAR ok: BOOLEAN);
(*-----------------------------------------------------------------*)
  BEGIN
    ok := (Lookup(id) = 0) AND (n < max);
    IF ok THEN BEGIN
      n := n + 1;
      st[n].id := id;
      st[n].val := 0;
      st[n].addr := n - 1;
    END; (*if*)
  END; (*DeclVar*)

  FUNCTION IsDecl(id: STRING): BOOLEAN;
(*-----------------------------------------------------------------*)
  BEGIN
    IsDecl := (Lookup(id) > 0);
  END; (*IsDecl*)


(*for the MiniPascal Interpreter only:*)

  PROCEDURE SetVal(id: STRING; val: INTEGER);
(*-----------------------------------------------------------------*)
  BEGIN
    st[Lookup(id)].val := val;
  END; (*SetVal*)

  PROCEDURE GetVal(id: STRING; VAR val: INTEGER);
(*-----------------------------------------------------------------*)
  BEGIN
    val := st[Lookup(id)].val;
  END; (*SetVal*)


(*for the MiniPascal Compiler only:*)

  FUNCTION AddrOf(id: STRING): INTEGER;
(*-----------------------------------------------------------------*)
  BEGIN (*AdrOf*)
    AddrOf := st[Lookup(id)].addr;
  END; (*AddrOf*)


END. (*SymTab*)