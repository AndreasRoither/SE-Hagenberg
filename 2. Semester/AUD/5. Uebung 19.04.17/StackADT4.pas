(* Stack ADT 4                                    19.04.2017 *)
(* ----------                                                *)
(* implementing the stack as abstract data type - version 4  *)
(* ========================================================= *)

UNIT StackADT4;

INTERFACE 

  TYPE
    (* "verstecken" von stack daten *)
    Stack = POINTER;
    
  PROCEDURE NewStack(VAR s: Stack; max: INTEGER);
  PROCEDURE DisposeStack(VAR s: Stack);
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  
  FUNCTION Empty(s: Stack): BOOLEAN;

IMPLEMENTATION

  TYPE
    StackPtr = ^StackRec;
    StackRec = RECORD
      max : INTEGER;
      data: ARRAY[1..1] OF INTEGER;
      top: INTEGER;
    END;
    
  PROCEDURE NewStack(VAR s: Stack; max: INTEGER);
    VAR
      intSize: INTEGER;
      mem: INTEGER;
  BEGIN
    intSize := SizeOf(INTEGER);
    mem := intSize + intSize * max + intSize;
    GetMem(s, mem);
    
    (* typecast *)
    StackPtr(s)^.top := 0;
    StackPtr(s)^.max := max;
  END;
  
  PROCEDURE DisposeStack(VAR s: Stack);
    VAR
      intSize: INTEGER;
      mem: INTEGER;
  BEGIN
    intSize := SizeOf(INTEGER);
    mem := intSize + intSize * StackPtr(s)^.max + intSize;
    
    (* Alternative:
        2 Byte for max + 2 Byte for each integer in data (size max) + 2 Byte for top *)
    (* FreeMem(s, 2 + max*2 + 2) *)
    FreeMem(s, mem);
    s := NIL;
  END;
  
  PROCEDURE Push(VAR s: Stack; e: INTEGER);
  BEGIN
    IF StackPtr(s)^.top = StackPtr(s)^.max THEN BEGIN
      WriteLn('Stack overflow');
    END
    ELSE BEGIN
      StackPtr(s)^.top := StackPtr(s)^.top + 1;
      {$R-}
      StackPtr(s)^.data[StackPtr(s)^.top] := e;
      {$R+}
    END;
  END;
  
  PROCEDURE Pop(VAR s: Stack; VAR e: INTEGER);
  BEGIN
    IF StackPtr(s)^.top = 0 THEN BEGIN
      WriteLn('Stack underflow');
    END
    ELSE BEGIN
      {$R-}
      e := StackPtr(s)^.data[StackPtr(s)^.top];
      {$R+}
      StackPtr(s)^.top := StackPtr(s)^.top - 1;
    END;
  END;
  
  FUNCTION Empty(s: Stack): BOOLEAN;
  BEGIN
    Empty := StackPtr(s)^.top = 0;
  END;
  
BEGIN
END. (* StackADT4 *)





