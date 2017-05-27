(* CodeDis:                                         HDO, 2004-02-06
   -------
   Byte code disassembler for the MiniPascal compiler.
===================================================================*)
UNIT CodeDis;

INTERFACE

  USES
    CodeDef;

  PROCEDURE DisassembleCode(ca: CodeArray);


IMPLEMENTATION

  VAR
    ca: CodeArray; (*array of opCodes and opderands*)
    pc: INTEGER;   (*program counter*)


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

  PROCEDURE Write1(opcStr:STRING; opc: OpCode);
  BEGIN
    Write('[', Ord(opc):2, '         ]  ');
    WriteLn(opcStr);
  END; (*Write1*)

  PROCEDURE Write2(opcStr:STRING; opc: OpCode; opd: INTEGER);
  BEGIN
    Write('[', Ord(opc):2, (opd DIV 256):4, (opd MOD 256):4, ' ]  ');
    WriteLn(opcStr, opd);
  END; (*Write2*)


  PROCEDURE DisassembleCode(ca: CodeArray);
(*-----------------------------------------------------------------*)
    VAR
      opc: OpCode;
      opd: INTEGER;
  BEGIN
    CodeDis.ca := ca;
    WriteLn('code disassembling started ...');
    pc := 1;
    REPEAT
      Write(pc:4, ':  ');
      FetchOpc(opc);
      CASE opc OF
      LoadConstOpc: BEGIN
          FetchOpd(opd);
          Write2('LoadConst', opc, opd);
        END;
      LoadValOpc: BEGIN
          FetchOpd(opd);
          Write2('LoadVal  ', opc, opd);
        END;
      LoadAddrOpc: BEGIN
          FetchOpd(opd);
          Write2('LoadAddr ', opc, opd);
        END;
      StoreOpc: BEGIN
          Write1('Store    ', opc);
        END;
      AddOpc: BEGIN
          Write1('Add      ', opc);
        END;
      SubOpc: BEGIN
          Write1('Sub      ', opc);
        END;
      MulOpc: BEGIN
          Write1('Mul      ', opc);
        END;
      DivOpc: BEGIN
          Write1('Div      ', opc);
        END;
      ReadOpc: BEGIN
          FetchOpd(opd);
          Write2('Read     ', opc, opd);
        END;
      WriteOpc: BEGIN
          Write1('Write    ', opc);
        END;
      EndOpc: BEGIN
          Write1('End      ', opc);
        END;
      ELSE
        WriteLn('*** Error: invalid operation code');
        HALT;
      END; (*CASE*)
    UNTIL opc = EndOpc;
    WriteLn('... code disassembling ended');
  END; (*DisassembleCode*)


END. (*CodeDis*)