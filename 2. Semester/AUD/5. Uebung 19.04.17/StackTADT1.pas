(* ADS Unit Test 1                         19.04.2017 *)
(* ----------                                         *)
(*                                                    *)
(* ================================================== *)

PROGRAM StackTADS1;

  USES 
    StackADT1;
    
  VAR 
    s1, s2: Stack;
    e: INTEGER;
    i: INTEGER;
    
BEGIN
  Init(s1);
  Init(s2);
  
  FOR i := 1 TO 10 DO BEGIN
    WriteLn('Push: ',i);
    Push(s1, i);
  END;
  
  FOR i := 1 TO 10 DO BEGIN
    WriteLn('Push2: ',i*i);
    Push(s2, i*i);
  END;
  
  FOR i := 1 TO 10 DO BEGIN
    Pop(s2, e);
    WriteLn('Pop2: ',e);
  END;
  
  FOR i := 1 TO 10 DO BEGIN
    Pop(s1, e);
    WriteLn('Pop: ',e);
  END;

END. (* StackTADS1 *)