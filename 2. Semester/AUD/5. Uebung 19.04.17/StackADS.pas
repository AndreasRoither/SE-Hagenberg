(* Stack ADS                               19.04.2017 *)
(* ----------                                         *)
(* implementing the stack as abstract data structure  *)
(* ================================================== *)

UNIT StackADS;

INTERFACE 

  PROCEDURE Init;
  
  PROCEDURE Push(e: INTEGER);
  PROCEDURE Pop(VAR e: INTEGER);
  
  FUNCTION Empty: BOOLEAN;

IMPLEMENTATION
  
  CONST
    max = 100;
    
  VAR 
    data: Array[1..max] OF INTEGER;
    top: INTEGER;
    
  PROCEDURE Init;
  BEGIN
    top := 0;
  END;
  
  PROCEDURE Push(e: INTEGER);
  BEGIN
    IF top = max THEN BEGIN
      WriteLn('Stack overflow');
    END
    ELSE BEGIN
      top := top + 1;
      data[top] := e;
    END;
  END;
  
  PROCEDURE Pop(VAR e: INTEGER);
  BEGIN
    IF top = 0 THEN BEGIN
      WriteLn('Stack underflow');
    END
    ELSE BEGIN
      e := data[top];
      top := top - 1;
    END;
  END;
  
  FUNCTION Empty: BOOLEAN;
  BEGIN
    Empty := top = 0;
  END;
  
BEGIN
  Init;
END. (* StackADS *)





