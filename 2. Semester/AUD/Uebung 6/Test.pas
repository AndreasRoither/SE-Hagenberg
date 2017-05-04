(* Test    03.05.17 *)
(* Parser + Lexi.   *)

PROGRAM Test;
  USES
    Lex, Parser;

  VAR
    ok : BOOLEAN;
    inFileName, outFileName: STRING;

BEGIN
  (* Param check *)
  IF (ParamCount < 2) THEN 
  BEGIN
    WriteLn('Wrong input, try again: ');
    
    Write('syn File name > ');
    ReadLn(inFileName);
    
    Write('out File name > ');
    ReadLn(outFileName);
  END
  ELSE BEGIN
    inFileName := ParamStr(1);
    outFileName := ParamStr(2);
  END;

  InitScanner(inFileName, ok);
  InitParser(outFileName, ok);

  IF ok THEN S
  ELSE
    WriteLn('File error')
END.
