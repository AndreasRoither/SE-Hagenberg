(* ADS Unit Test                           19.04.2017 *)
(* ----------                                         *)
(*                                                    *)
(* ================================================== *)

PROGRAM StackTADS;

  USES 
    StackADS;
    
  VAR 
    e: INTEGER;
    i: INTEGER;
    
BEGIN
  Init;
  
  FOR i := 1 to 10 DO BEGIN
    WriteLn('Push: ',i);
    Push(i);
  END;
  
  FOR i := 1 TO 10 DO BEGIN
    Pop(e);
    WriteLn('Pop: ',e);
  END;

END. (* StackTADS *)