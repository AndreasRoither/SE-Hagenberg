(* TMP_SS    03.05.17 *)

PROGRAM TMP_SS;
  USES
    MP_Lex, MP_SS;

  VAR
    ok : BOOLEAN;


BEGIN
  InitScanner('SVP.mp', ok);
  IF ok THEN S
  ELSE
    WriteLn('Source code file not available')

END.