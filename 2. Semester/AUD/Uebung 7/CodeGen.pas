(* CodeGen:                                         HDO, 2004-02-06
   -------
   Byte code generator for the MiniPascal compiler.
===================================================================*)
UNIT CodeGen;

(*$I Chooser.inc*)

INTERFACE

  USES
    CodeDef;

  PROCEDURE InitCodeGenerator;

  PROCEDURE Emit1(opc: OpCode);
  PROCEDURE Emit2(opc: OpCode; opd: INTEGER);

(*$IFDEF Midi*)
  FUNCTION  CurAddr: INTEGER;
  PROCEDURE FixUp(addr: INTEGER; opd: INTEGER);
(*$ENDIF*)

  PROCEDURE GetCode(VAR ca: CodeArray);


IMPLEMENTATION

  VAR
    ca: CodeArray; (*array of opCodes and opderands*)
    n: INTEGER;    (*index of next free byte in c*)


  PROCEDURE InitCodeGenerator;
(*-----------------------------------------------------------------*)
    VAR
      i: INTEGER;
  BEGIN
    n := 1;
    FOR i := 1 TO maxCodeLen DO BEGIN
      ca[i] := 0;
    END; (*FOR*)
  END; (*InitCodeGenerator*)


  PROCEDURE EmitByte(b: BYTE);
  BEGIN
    IF n = maxCodeLen THEN BEGIN
      WriteLn('*** Error: overflow in code array');
      HALT;
    END; (*IF*)
    ca[n] := b;
    n := n + 1;
  END; (*EmitByte*)

  PROCEDURE EmitWord(w: INTEGER);
  BEGIN
    EmitByte(w DIV 256);
    EmitByte(w MOD 256);
  END; (*EmitWord*)


  PROCEDURE Emit1(opc: OpCode);
(*-----------------------------------------------------------------*)
  BEGIN
    EmitByte(Ord(opc));
  END; (*Emit1*)

  PROCEDURE Emit2(opc: OpCode; opd: INTEGER);
(*-----------------------------------------------------------------*)
  BEGIN
    EmitByte(Ord(opc));
    EmitWord(opd);
  END; (*Emit1*)


(*$IFDEF Midi*)
  FUNCTION CurADdr: INTEGER;
(*-----------------------------------------------------------------*)
  BEGIN
    CurAddr := n;
  END; (*CurAddr*)

  PROCEDURE FixUp(addr: INTEGER; opd: INTEGER);
(*-----------------------------------------------------------------*)
  BEGIN
    ca[addr    ] := opd DIV 256;
    ca[addr + 1] := opd MOD 256;
  END; (*FixUp*)
(*$ENDIF*)


  PROCEDURE GetCode(VAR ca: CodeArray);
(*-----------------------------------------------------------------*)
  BEGIN
    ca := CodeGen.ca;
  END; (*GetCode*)


END. (*CodeGen*)