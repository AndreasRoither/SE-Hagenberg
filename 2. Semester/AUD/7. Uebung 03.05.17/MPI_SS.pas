(* MPI_SS                              Dagmar Auer, 03.05.2017 
   ------                                                      
   Syntaxanalysator (Parser) für MiniPascal entsprechend          
   folgender Grammatik                                        
   S  =      MP eof .
   MP =      "PROGRAM" ident ";"
             [VarDecl]
             "BEGIN"
               StatSeq
             "END" "." .
   VarDecl = "VAR" ident { "," ident }
             ":" "INTEGER" ";" .
   StatSeq = Stat { ";" Stat } .
   Stat =    [ ident ":=" Expr
             | "READ" "(" ident ")" 
             | "WRITE" "(" Expr ")"
             ] .
   Expr =    Term { ("+"|"-") Term} .
   Term =    Fact { ("*"|"/") Fact} .
   Fact =    ident | number | "(" Expr ")" .
   Semantische Aktionen für Interpreter siehe Foliensatz
   zur LVA.
   
   Syntax & Semantics --> SS
============================================================= *)
UNIT MPI_SS;

INTERFACE

  VAR
    success: BOOLEAN;

  PROCEDURE S;
  
IMPLEMENTATION

  USES
    MP_Lex, SymTab;


  FUNCTION SyIsNot(expectedSy: SymbolCode): BOOLEAN;
  BEGIN
    success := success AND (sy = expectedSy);
    SyIsNot := NOT success;
  END; (*SyIsNot*)
  
  PROCEDURE SemErr(msg: STRING);
  BEGIN
    WriteLn('*** semantic error *', msg, '* in line ', syLnr, ' at position ', syCnr);
    
    (*if you want to stop parsing after a semantic error occured 
    then add the following line:
    success := FALSE;
    *)
  END; (*SemErr*)
  
  PROCEDURE MP;                    FORWARD;
  PROCEDURE VarDecl;               FORWARD;
  PROCEDURE StatSeq;               FORWARD;
  PROCEDURE Stat;                  FORWARD;
  PROCEDURE Expr(VAR e: INTEGER);  FORWARD;
  PROCEDURE Term(VAR t: INTEGER);  FORWARD;
  PROCEDURE Fact(VAR f: INTEGER);  FORWARD;
  
  
  PROCEDURE S;
  BEGIN
    success := TRUE;
    MP; IF NOT success OR SyISNot(eofSy) THEN 
      WriteLn('*** syntax error in line ', syLnr, ' at position ', syCnr)
    ELSE
      WriteLn('Successfully interpreted!')
  END; (*S*)
  
  PROCEDURE MP;
  BEGIN
    (*SEM*)InitSymbolTable;(*ENDSEM*)
    IF SyIsNot(programSy) THEN Exit;
    NewSy;
    IF SyIsNot(identSy) THEN Exit;
    NewSy;
    IF SyIsNot(semicolonSy) THEN Exit;
    NewSy;
    IF sy = varSy THEN BEGIN
      VarDecl; IF NOT success THEN Exit;
    END;
    IF SyIsNot(beginSy) THEN Exit;
    NewSy;
    StatSeq; IF NOT success THEN Exit;
    IF SyIsNot(endSy) THEN Exit;
    NewSy;
    IF SyIsNot(periodSy) THEN Exit;
    NewSy;
  END; (*MP*)
  
  PROCEDURE VarDecl;
    VAR
      ok: BOOLEAN;
  BEGIN
    IF SyIsNot(varSy) THEN Exit;
    NewSy;
    IF SyIsNot(identSy) THEN Exit;
    (*SEM*)DeclVar(identStr, ok);(*ENDSEM*)
    NewSy;
    WHILE sy = commaSy DO BEGIN
      NewSy;
      IF SyIsNot(identSy) THEN Exit;
      (*SEM*)DeclVar(identStr, ok);
             IF NOT ok THEN
               SemErr('multiple declaration');
      (*ENDSEM*)      
      NewSy;
    END; (*WHILE*)
    IF SyIsNot(colonSy) THEN Exit;
    NewSy;
    IF SyIsNot(integerSy) THEN Exit;
    NewSy;
    IF SyIsNot(semicolonSy) THEN Exit;
    NewSy;
  END; (*VarDecl*)
  
  PROCEDURE StatSeq;
  BEGIN
    Stat; IF NOT success THEN Exit;
    WHILE sy = semicolonSy DO BEGIN
      NewSy;
      Stat; IF NOT success THEN Exit;
    END; (*WHILE*)
  END; (*StatSeq*)
  
  PROCEDURE Stat;
    (*LOCAL*)
    VAR
      destId: STRING;
      e: INTEGER;
    (*ENDLOCAL*)  
  BEGIN
    CASE sy OF
      identSy: BEGIN      
          (*SEM*)destId := identStr;
                 IF NOT IsDecl(destId) THEN 
                   SemErr('variable not declared');
          (*ENDSEM*)
          NewSy;
          IF SyIsNot(assignSy) THEN Exit;
          NewSy;
          Expr(e); 
          
          IF NOT success THEN Exit;  (*Expr -> attribute e*)
          (*SEM*)IF IsDecl(destId) THEN 
                   SetVal(destId, e);
          (*ENDSEM*)          
        END;
      readSy: BEGIN
          NewSy;
          IF SyIsNot(leftParSy) THEN Exit;
          NewSy;
          IF SyIsNot(identSy) THEN Exit;
          (*SEM*)IF NOT IsDecl(identStr) THEN 
                   SemErr('variable not declared')
                 ELSE BEGIN
                   Write('identStr', ' > ');
                   ReadLn(e); 
                   SetVal(identStr, e);
                 END;
          (*ENDSEM*)                    
          NewSy;
          IF SyIsNot(rightParSy) THEN Exit;
          NewSy;          
        END;
      writeSy: BEGIN
          NewSy;
          IF SyIsNot(leftParSy) THEN Exit;
          NewSy;
          Expr(e); ///IF NOT success THEN Exit; (*Expr -> attribute e*)
          (*SEM*)WriteLn(e);(*ENDSEM*)                              
          IF SyIsNot(rightParSy) THEN Exit;
          NewSy;          
        END;
      ELSE
        ;(* empty statement*)
    END; (*CASE*)
  END; (*Stat*)
  
  (*comment for students - as we did not finish the code in the course:
    the following procedures are "copies" from the previous course - ExprCalc.pas
    Only Fact needs to be extended with handling the identSy
    
    do not forget to add the parameters in the FORWARD declarations of the 
    following procedures.
    *)

  PROCEDURE Expr(VAR e: INTEGER);
    (*LOCAL*)
    VAR
      t1, t2: INTEGER;
    (*ENDLOCAL*)
  BEGIN
    Term(t1); IF NOT success THEN Exit;
    (*SEM*)e := t1;(*ENDSEM*)   
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN Exit;
            (*SEM*)e := e + t2;(*ENDSEM*)
          END;
        minusSy: BEGIN
            NewSy;
            Term(t2); IF NOT success THEN Exit;
            (*SEM*)e := e - t2;(*ENDSEM*)
          END;
      END; (*CASE*)
    END; (*WHILE*)
  END; (*Expr*)
  
  PROCEDURE Term(VAR t: INTEGER);
    (*LOCAL*)
    VAR
      f: INTEGER;
    (*ENDLOCAL*)
  BEGIN
    Fact(t); IF NOT success THEN Exit;
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN      
            NewSy;
            Fact(f); IF NOT success THEN Exit;
            (*SEM*)t := t * f;(*ENDSEM*)
          END;
        divSy: BEGIN
            NewSy;
            Fact(f); IF NOT success THEN Exit;
            (*SEM*)IF f = 0 THEN
                     SemErr('zero division')
                   ELSE
                     t := t DIV f;
            (*ENDSEM*)
          END;
      END;
    END; (*WHILE*)    
  END; (*Term*)
  
  PROCEDURE Fact(VAR f: INTEGER);
  BEGIN
    CASE sy OF
      identSy: BEGIN
          (*SEM*)IF NOT IsDecl(identStr) THEN
                   SemErr('variable not declared')
                 ELSE
                   GetVal(identStr, f);
          (*ENDSEM*)
          NewSy;
        END; 
      numberSy: BEGIN
          (*SEM*)f := numberVal;(*ENDSEM*)      
          NewSy;
        END;
      leftParSy: BEGIN
          NewSy;
          Expr(f); IF NOT success THEN Exit;
          IF sy <> rightParSy THEN BEGIN
            success := FALSE;
            Exit;
          END;
          NewSy;
        END;
      ELSE
        success := FALSE;
    END; (*CASE*)
  END; (*Fact*)

END. (*MPI_SS*)