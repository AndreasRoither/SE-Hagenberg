(* TMPI_SS                              Dagmar Auer, 03.05.2017 
   ------                        
   Program for testing the MiniPascal Interpreter.
 ============================================================== *)
PROGRAM TMPI_SS;

  USES
    MP_Lex, MPI_SS;

  VAR
    ok: BOOLEAN;
  
BEGIN

  InitScanner('SVP.mp', ok);
  IF ok THEN
    S
  ELSE
    WriteLn('source code file not available');
      
END. (*TMPI_SS*)