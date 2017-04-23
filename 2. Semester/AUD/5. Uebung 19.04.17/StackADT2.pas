(* Stack ADT 2                                    19.04.2017 *)
(* ----------                                                *)
(* implementing the stack as abstract data type - version 2  *)
(* ========================================================= *)

UNIT StackADT2;

INTERFACE 

  CONST
    max = 100;
    
  TYPE
    Stack = ^StackRec;
    StackRec = Record
      data: Array[1..max] OF INTEGER;
      top: INTEGER;
    END;
    
  PROCEDURE NewStack(VAR s: Stack);
  PROCEDURE DisposeStack(VAR s: Stack);
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  
  (* VAR not nice, but consistent with prev version 
  FUNCTION Empty(VAR s: Stack): BOOLEAN; *)
  
  FUNCTION Empty(s: Stack): BOOLEAN;

IMPLEMENTATION

  PROCEDURE NewStack(VAR s: Stack);
  BEGIN
    New(s);
    s^.top := 0;
  END;
  
  PROCEDURE DisposeStack(VAR s: Stack);
  BEGIN
    Dispose(s);
    s := NIL;
  END;
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  BEGIN
    IF s^.top = max THEN BEGIN
      WriteLn('Stack overflow');
    END
    ELSE BEGIN
      s^.top := s^.top + 1;
      s^.data[s^.top] := e;
    END;
  END;
  
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  BEGIN
    IF s^.top = 0 THEN BEGIN
      WriteLn('Stack underflow');
    END
    ELSE BEGIN
      e := s^.data[s^.top];
      s^.top := s^.top - 1;
    END;
  END;
  
  FUNCTION Empty(s: Stack): BOOLEAN;
  BEGIN
    Empty := s^.top = 0;
  END;
  
BEGIN
END. (* StackADT2 *)





