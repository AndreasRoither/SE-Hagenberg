(* MPC_SS                             10.05.17 *)
(* Syntax Analysator (scanner) für mini pascal*)

UNIT MPC_SS;
  INTERFACE
    
    VAR
      success: BOOLEAN;

    PROCEDURE S;

  IMPLEMENTATION
    USES
      MP_Lex, SymTab, CodeGen, CodeDef;

    FUNCTION SyIsNot(expectedSy: SymbolCode): BOOLEAN;
    BEGIN
      success := success AND (sy = expectedSy);
      SyIsNot := NOT success;
    END;

    PROCEDURE SemErr(msg: STRING);
    BEGIN
      WriteLn('*** semantic error *', msg, '* in line ', syLnr, ' at position ', syCnr);
      
      (*if you want to stop parsing after a semantic error occured 
      then add the following line:
      success := FALSE;
      *)
    END; (*SemErr*)

    PROCEDURE MP;       FORWARD;
    PROCEDURE VarDecal; FORWARD;
    PROCEDURE StatSeq;  FORWARD;
    PROCEDURE Stat;     FORWARD;
    PROCEDURE Expr;     FORWARD;
    PROCEDURE Term;     FORWARD;
    PROCEDURE Fact;     FORWARD;

    PROCEDURE S;
    BEGIN
      success := TRUE;
      MP; IF NOT success OR SyIsNot(eofSy) THEN
        WriteLn('Error in line ', syLnr, ' at position ', syCnr)
      ELSE
        WriteLn('Sucessfully parsed');
    END;

    PROCEDURE MP;
    BEGIN
      (* SEM *)
      InitSymbolTable;
      InitCodeGenerator;
      (* END SEM *)

      IF SyIsNot(programSy) THEN EXIT;
      NewSy;
      IF SyIsNot(identSy) THEN EXIT;
      NewSy;
      IF SyIsNot(semicolonSy) THEN EXIT;
      NewSy;
      IF sy = varSy THEN BEGIN
        VarDecal; IF NOT success THEN EXIT;
      END;
      IF SyIsNot(beginSy) THEN EXIT;
      NewSy;
      StatSeq; IF NOT success THEN EXIT;
      (* SEM *)
      Emit1(EndOpc);
      (* END SEM *)
      IF SyIsNot(endSy) THEN EXIT;
      NewSy;
      IF SyIsNot(periodSy) THEN EXIT;
      NewSy; (* to get eofSy *)
    END;

    PROCEDURE VarDecal;
      (*Local*)
      VAR
        ok: BOOLEAN;
      (* END LOCAL *)
    BEGIN
      IF SyIsNot(varSy) THEN EXIT;
      NewSy;
      IF SyIsNot(identSy) THEN EXIT;
      (* SEM *)
      DeclVar(identStr, ok);
      (* ENDSEM *)
      NewSy;
      WHILE sy = commaSy DO BEGIN
        NewSy;
        IF SyIsNot(identSy) THEN EXIT;
        (* SEM *) 
        DeclVar(identStr, ok); IF NOT ok THEN SemErr('multiple declaration');
        (* ENDSEM *)
        NewSy;
      END;
      IF SyIsNot(colonSy) THEN EXIT;
      NewSy;
      IF SyIsNot(integerSy) THEN EXIT;
      NewSy;
      IF SyIsNot(semicolonSy) THEN EXIT;
      NewSy;
    END;

    PROCEDURE StatSeq;
    BEGIN
      Stat; IF NOT success THEN EXIT;
      WHILE sy = semicolonSy DO BEGIN
        NewSy;
        Stat; IF NOT success THEN EXIT;
      END;
    END;

    PROCEDURE Stat;
      (* LOCAL *)
      VAR
        destId: STRING;
        addr, addr1, addr2 : INTEGER;
      (* END LOCAL *)
    BEGIN
      CASE sy OF
        identSy: BEGIN
            (* SEM *)
            destId := identStr;
            IF NOT IsDecl(destId) THEN 
              SemErr('var not declared')
            ELSE
              Emit2(LoadAddrOpc, AddrOf(destId));
            (* ENDSEM *)
            NewSy;
            IF SyIsNot(assignSy) THEN EXIT;
            NewSy;
            Expr; IF NOT success THEN EXIT;
            (* SEM *)
            IF IsDecl(destId) THEN Emit1(StoreOpc);
            (* ENDSEM *)
          END;
        readSy: BEGIN
            NewSy;
            IF SyIsNot(leftParSy) THEN EXIT;
            NewSy;
            (* SEM *)
            IF NOT IsDecl(identStr) THEN 
              SemErr('var not declared')
            ELSE
              Emit2(LoadAddrOpc, AddrOf(identStr));
            (* ENDSEM *)
            IF SyIsNot(identSy) THEN EXIT;
            NewSy;
            IF SyIsNot(rightParSy) THEN EXIT;
            NewSy;
          END;
        writeSy: BEGIN
            NewSy;
            IF SyIsNot(leftParSy) THEN EXIT;
            NewSy;
            Expr; IF NOT success THEN EXIT;
            (* SEM *)
            Emit1(WriteOpc);
            (* ENDSEM *)
            IF SyIsNot(rightParSy) THEN EXIT;
            NewSy;
          END;
        beginSy: BEGIN
          NewSy;
          StatSeq; IF NOT success THEN EXIT;
          IF SyIsNot(endSy) THEN EXIT;
          NewSy;
        END;
        ifSy: BEGIN
          NewSy;
          IF SyIsNot(identSy) THEN EXIT;
          IF NOT ISDecl(identStr) THEN SemErr('variable not declared');
          Emit2(LoadValOpc, AddrOf(identStr));
          Emit2(JmpZOpc, 0);
          addr := CurAddr - 2;
          NewSy;
          IF SyIsNot(thenSy) THEN EXIT;
          NewSy;
          Stat; IF NOT success THEN EXIT;
          IF sy = elseSy THEN BEGIN
            Emit2(JmpOpc, 0);
            FixUp(addr, CurAddr);
            addr := CurAddr - 2;
            NewSy;
            Stat; IF NOT success THEN EXIT;
            FixUp(addr, CurAddr);
          END;
        END;
        whileSy: BEGIN
          NewSy;
          IF SyIsNot(identSy) THEN EXIT;
          IF NOT IsDecl(identStr) THEN SemErr('variable not declared');
          addr1 := CurAddr;
          Emit2(LoadValOpc, AddrOf(identStr));
          Emit2(JmpZOpc, 0);
          addr2 := CurAddr - 2;
          NewSy;
          IF SyIsNot(doSy) THEN EXIT;
          NewSy;
          Stat; IF NOT success THEN EXIT;
          Emit2(JmpOpc, addr1);
          FixUp(addr2, CurAddr);
        END;
        ELSE
          (* no statement *)
      END;
    END;

    PROCEDURE Expr;
    BEGIN
      Term; IF NOT success THEN EXIT;
      WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
        CASE sy OF
          plusSy: BEGIN
              NewSy;
              Term; IF NOT success THEN EXIT;
              (* SEM *)
              Emit1(AddOpc);
              (* ENDSEM *)
            END;
          minusSy: BEGIN
              NewSy;
              Term; IF NOT success THEN EXIT;
              (* SEM *)
              Emit1(SubOpc);
              (* ENDSEM *)
            END;
        END;
      END;
    END;

    PROCEDURE Term;
    BEGIN
      Fact; IF NOT success THEN EXIT;
      WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
        CASE sy OF
          timesSy: BEGIN
              NewSy;
              Fact; IF NOT success THEN EXIT;
              (* SEM *)
              Emit1(MulOpc);
              (* ENDSEM *)
            END;
          divSy: BEGIN
              NewSy;
              Fact; IF NOT success THEN EXIT;
              (* SEM *)
              Emit1(DivOpc);
              (* ENDSEM *)
            END;
        END;
      END;
    END;

    PROCEDURE Fact;
    BEGIN
      CASE sy OF
        identSy: BEGIN
            (* SEM *)
            IF NOT IsDecl(identStr) THEN SemErr('var not decl.')
            ELSE
              Emit2(LoadValOpc, AddrOf(identStr));
            (* ENDSEM *)
            NewSy;
          END;
        numberSy: BEGIN
            (* SEM *)
            Emit2(LoadConstOpc, numberVal);
            (* ENDSEM *)
            NewSy;
          END;
        leftParSy: BEGIN
            NewSy;
            Expr; IF NOT success THEN EXIT;
            IF sy <> rightParSy THEN BEGIN success:= FALSE; EXIT; END;
            NewSy;
          END;
        ELSE
          success := FALSE;
      END;
    END;
END.