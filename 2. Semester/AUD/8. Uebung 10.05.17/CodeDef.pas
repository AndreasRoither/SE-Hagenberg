(* CodeDef:                                         HDO, 2004-02-06
   -------
   Definition of the MiniPascal byte code.
===================================================================*)
UNIT CodeDef;

INTERFACE

  CONST
    maxCodeLen = 100;

  TYPE
    OpCode = (      (*operands:*)
      LoadConstOpc, (*num  = numerical literal*)
      LoadValOpc,   (*addr = address of variable for value to load*)
      LoadAddrOpc,  (*addr = address of variable*)
      StoreOpc,
      AddOpc,
      SubOpc,
      MulOpc,
      DivOpc,
      ReadOpc,      (*addr = address of variable to read*)
      WriteOpc,
      EndOpc);

    CodeArray = ARRAY [1 .. maxCodeLen] OF BYTE;


  PROCEDURE StoreCode(fileName: STRING; ca: CodeArray);
  PROCEDURE LoadCode(fileName: STRING; VAR ca: CodeArray; VAR ok: BOOLEAN);


IMPLEMENTATION


  PROCEDURE StoreCode(fileName: STRING; ca: CodeArray);
(*-----------------------------------------------------------------*)
    VAR
      f: FILE OF CodeArray;
  BEGIN
    Assign(f, fileName);
    ReWrite(f);
    Write(f, ca);
    Close(f);
  END; (*StoreCode*)


  PROCEDURE LoadCode(fileName: STRING; VAR ca: CodeArray; VAR ok: BOOLEAN);
(*-----------------------------------------------------------------*)
    VAR
      f: FILE OF CodeArray;
  BEGIN
    Assign(f, fileName);
    (*$I-*)
    Reset(f);
    (*$I+*)
    ok := IOResult = 0;
    IF NOT ok THEN
      Exit;
    Read(f, ca);
    Close(f);
  END; (*LoadCode*)


END. (*CodeDef*)