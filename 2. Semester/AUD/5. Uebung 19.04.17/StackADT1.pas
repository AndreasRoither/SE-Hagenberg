(* Stack ADT 1                                    19.04.2017 *)
(* ----------                                                *)
(* implementing the stack as abstract data type - version 1  *)
(* ========================================================= *)

UNIT StackADT1;

INTERFACE 

  CONST
    max = 100;
    
  TYPE
    Stack = Record
      data: Array[1..max] OF INTEGER;
      top: INTEGER;
    END;
    
  PROCEDURE Init(VAR s: Stack);
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  
  (* Copying of an adress is faster than copying the actual stack 
     Although not nice implementation, its faster with big structures *)
  FUNCTION Empty(VAR s: Stack): BOOLEAN;

IMPLEMENTATION

  PROCEDURE Init(VAR s: Stack);
  BEGIN
    s.top := 0;
  END;
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  BEGIN
    IF s.top = max THEN BEGIN
      WriteLn('Stack overflow');
    END
    ELSE BEGIN
      s.top := s.top + 1;
      s.data[s.top] := e;
    END;
  END;
  
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  BEGIN
    IF s.top = 0 THEN BEGIN
      WriteLn('Stack underflow');
    END
    ELSE BEGIN
      e := s.data[s.top];
      s.top := s.top - 1;
    END;
  END;
  
  FUNCTION Empty(VAR s: Stack): BOOLEAN;
  BEGIN
    Empty := s.top = 0;
  END;
  
BEGIN
END. (* StackADT1 *)





