
UNIT Stacks;

  INTERFACE
    CONST
      MAX = 10;
    TYPE

      (* abstract class stack *)
      StackPtr = ^Stack;
      Stack = OBJECT
        (*data components*)
        CONSTRUCTOR Init;
        DESTRUCTOR Done;              VIRTUAL;
        
        PROCEDURE Push(val: INTEGER); VIRTUAL; ABSTRACT;
        FUNCTION Pop: INTEGER;        VIRTUAL; ABSTRACT;
        FUNCTION Empty: BOOLEAN;      VIRTUAL; ABSTRACT;
        PROCEDURE WriteAll;           VIRTUAL; ABSTRACT;
      END;

      (* stack implementations - concrete classes *)

      ArrayStackPtr = ^ArrayStack;
      ArrayStack = OBJECT(Stack)
        PRIVATE
          top: INTEGER;
          a: ARRAY[1..MAX] OF INTEGER;
        PUBLIC
          CONSTRUCTOR Init;
          DESTRUCTOR Done;              VIRTUAL;

          PROCEDURE Push(val: INTEGER); VIRTUAL;
          FUNCTION Pop: INTEGER;        VIRTUAL;
          FUNCTION Empty: BOOLEAN;      VIRTUAL;
          PROCEDURE WriteAll;           VIRTUAL;
      END;

      SafeArrayStackPtr = ^SafeArrayStack;
      SafeArrayStack = OBJECT(ArrayStack)
        PUBLIC
          CONSTRUCTOR Init;
          DESTRUCTOR Done;              VIRTUAL;

          PROCEDURE Push(val: INTEGER); VIRTUAL;
          FUNCTION Pop: INTEGER;        VIRTUAL;
      END;

      NodePtr = ^Node;
      Node = RECORD
        value: INTEGER;
        next: NodePtr;
      END;
      ListPtr = NodePtr;

      ListStackPtr = ^ListStack;
      ListStack = OBJECT(Stack)
        PRIVATE
          l: ListPtr;

        PUBLIC
          CONSTRUCTOR Init;             VIRTUAL;
          DESTRUCTOR Done;              VIRTUAL;

          PROCEDURE Push(val: INTEGER); VIRTUAL;
          FUNCTION Pop: INTEGER;        VIRTUAL;
          FUNCTION Empty: BOOLEAN;      VIRTUAL;
          PROCEDURE WriteAll;           VIRTUAL;
      END;

  IMPLEMENTATION

    (* ========================================== *)
    (* --       Implementation of Stack        -- *)
    (* ========================================== *)

    CONSTRUCTOR Stack.Init;
    BEGIN
      (* do nothing *)
    END;

    DESTRUCTOR Stack.Done;
    BEGIN
      (* do nothing *)
    END;

    (* ========================================== *)
    (* --     Implementation of ArrayStack     -- *)
    (* ========================================== *)

    CONSTRUCTOR ArrayStack.Init;
    BEGIN
      (* always call base class constructor first *)
      INHERITED Init;
      top := 0;
    END;

    DESTRUCTOR ArrayStack.Done;
    BEGIN
      (* always call base class deconstructor first *)
      INHERITED Done;
    END;

    PROCEDURE ArrayStack.Push(val: INTEGER);
    BEGIN
      top := top + 1;
      a[top] := val;
    END;

    FUNCTION ArrayStack.Pop: INTEGER;
    BEGIN
      Pop := a[top];
      top := top - 1;
    END;

    FUNCTION ArrayStack.Empty: BOOLEAN;
    BEGIN
      Empty := top = 0;
    END;

    PROCEDURE ArrayStack.WriteAll;
      VAR
        i: INTEGER;
    BEGIN
      FOR i := 1 TO top DO BEGIN
        Write(a[i], ' ');
      END;
      WriteLn();
    END;

    (* ========================================== *)
    (* --   Implementation of SafeArrayStack   -- *)
    (* ========================================== *)

    CONSTRUCTOR SafeArrayStack.Init;
    BEGIN
      (* always call base class constructor first *)
      INHERITED Init;
    END;

    DESTRUCTOR SafeArrayStack.Done;
    BEGIN
      (* always call base class deconstructor first *)
      INHERITED Done;
    END;

    PROCEDURE SafeArrayStack.Push(val: INTEGER);
    BEGIN
      IF top < MAX THEN BEGIN
        INHERITED Push(val);
      END ELSE WriteLn('Damn its full!');
    END;

    FUNCTION SafeArrayStack.Pop: INTEGER;
    BEGIN
      IF top <> 0 THEN BEGIN
        Pop := INHERITED Pop(val);
      END ELSE WriteLn('Damn its empty!');
    END;

    (* ========================================== *)
    (* --     Implementation of ListStack      -- *)
    (* ========================================== *)

    CONSTRUCTOR ListStack.Init;
    BEGIN
      (* always call base class constructor first *)
      INHERITED Init;
      top := 0;
    END;

    DESTRUCTOR ListStack.Done;
    VAR
      n: NodePtr;
    BEGIN

      WHILE l <> NIL DO BEGIN
        n := l;
        l := l^.next;
        Dispose(n);
      END;

      (* dont call base deconstrucotor first since nodes have to be deleted *)
      INHERITED Done;
    END;

    PROCEDURE ListStack.Push(val: INTEGER);
    VAR
      n: NodePtr
    BEGIN
      New(n);
      n^.value := value;
      n^.next := l;
      l := n;
    END;

    FUNCTION ListStack.Pop: INTEGER;
    VAR
      n: NodePtr;
    BEGIN
      IF NOT Empty THEN BEGIN
        Pop := l^.value;
        n := l;
        l := l^.next;
        Dispose(n);
      END ELSE WriteLn('Damn its empty!');
    END;

    FUNCTION ListStack.Empty: BOOLEAN;
    BEGIN
      Empty := l = NIL;
    END;

    PROCEDURE ListStack.WriteAll;
      VAR
        n: NodePtr;
    BEGIN
      n := l;
      WHILE n <> NIL DO BEGIN
        Write(n^.value, ' ');
        n := n^.next;
      END;
      WriteLn();
    END;

END.