(* CodeInt:                                         HDO, 2004-02-06
   -------
   Interpreter for MiniPascal byte code.
===================================================================*)
UNIT CodeInt;

INTERFACE

  USES
    CodeDef;

  PROCEDURE InterpretCode(ca: CodeArray);


IMPLEMENTATION

  CONST
    maxStackSize = 10;
    maxStorageSize = 20;

  VAR
    ca: CodeArray; (*array of opCodes and operands*)
    pc: INTEGER;   (*program counter*)
    stack: ARRAY [1 .. maxStackSize] OF INTEGER;
    sp: INTEGER;   (*stack pointer = top of stack*)
    storage: ARRAY [0 .. maxStorageSize] OF INTEGER;


  PROCEDURE ExecError(msg: STRING);
  BEGIN
    WriteLn('*** Execution error: ', msg);
    HALT;
  END; (*ExecError*)


  PROCEDURE InitStack;
  BEGIN
    sp := 0;
  END; (*InitStack*)

  PROCEDURE Push(v: INTEGER);
  BEGIN
    IF sp = maxStackSize THEN
      ExecError('stack overflow');
    sp := sp + 1;
    stack[sp] := v;
  END; (*Push*)

  PROCEDURE Pop(VAR v: INTEGER);
  BEGIN
    IF sp = 0 THEN
      ExecError('stack underflow');
    v := stack[sp];
    sp := sp - 1;
  END; (*Pop*)

  PROCEDURE InitStorage;
    VAR
      i: INTEGER;
  BEGIN
    FOR i := 1 TO maxStorageSize DO BEGIN
      storage[i] := 0;
    END; (*FOR*)
  END; (*InitStorage*)

  PROCEDURE CheckAdr(adr: INTEGER);
  BEGIN
    IF (adr < 0) OR (adr > maxStorageSize) THEN
      ExecError('address out of storage range');
  END; (*CheckAdr*)

  PROCEDURE FetchOpc(VAR opc: OpCode);
  BEGIN
    opc := OpCode(ca[pc]);
    pc := pc + 1;
  END; (*FetchOpc*)

  PROCEDURE FetchOpd(VAR opd: INTEGER);
  BEGIN
    opd := Ord(ca[pc])*256 + Ord(ca[pc + 1]);
    pc := pc + 2;
  END; (*FetchOpc*)


  PROCEDURE InterpretCode(ca: CodeArray);
(*-----------------------------------------------------------------*)
    VAR
      opc: OpCode;
      opd: INTEGER;
      val, val1, val2: INTEGER;
  BEGIN
    CodeInt.ca := ca;
    WriteLn('code interpretation started ...');
    InitStack;
    InitStorage;
    pc := 1;
    FetchOpc(opc);
    WHILE (opc <> EndOpc) DO BEGIN
      CASE opc OF
      LoadConstOpc: BEGIN
          FetchOpd(opd);
          Push(opd);
        END;
      LoadValOpc: BEGIN
          FetchOpd(opd);
          CheckAdr(opd);
          Push(storage[opd]);
        END;
      LoadAddrOpc: BEGIN
          FetchOpd(opd);
          Push(opd);
        END;
      StoreOpc: BEGIN
          Pop(val);
          Pop(opd);
          CheckAdr(opd);
          storage[opd] := val;
        END;
      AddOpc: BEGIN
          Pop(val2);
          Pop(val1);
          Push(val1 + val2);
        END;
      SubOpc: BEGIN
          Pop(val2);
          Pop(val1);
          Push(val1 - val2);
        END;
      MulOpc: BEGIN
          Pop(val2);
          Pop(val1);
          Push(val1 * val2);
        END;
      DivOpc: BEGIN
          Pop(val2);
          Pop(val1);
          IF val2 = 0 THEN
            ExecError('zero division');
          Push(val1 DIV val2);
        END;
      ReadOpc: BEGIN
          FetchOpd(opd);
          CheckAdr(opd);
          Write('var@', opd:0, ' > '); ReadLn(val);
          storage[opd] := val;
        END;
      WriteOpc: BEGIN
          Pop(val);
          WriteLn(val);
        END;
      ELSE
        ExecError('invalid operation code');
      END; (*CASE*)
      FetchOpc(opc);
    END; (*WHILE*)
    WriteLn('... code interpretation ended');
  END; (*InterpretCode*)


END. (*CodeInt*)