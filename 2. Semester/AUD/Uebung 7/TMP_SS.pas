(* TMP_SS                              Dagmar Auer, 03.05.2017 
   ------                        
   Program for testing the MiniPascal Interpreter.
 ============================================================== *)
PROGRAM TMP_SS;

  USES
    MP_Lex, MPc_SS;

  VAR
    ok: BOOLEAN;
  
BEGIN
  InitScanner('test.txt', ok);
  IF ok THEN S;
END. (*TMPI_SS*)