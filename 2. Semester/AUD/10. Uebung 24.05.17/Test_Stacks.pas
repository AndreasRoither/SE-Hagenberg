PROGRAM Test_Stacks;

  USES Stacks;

  VAR
    s: StackPtr;
    arraySt: ArrayStackPtr;
    safearraySt: SafeArrayStackPtr;

  PROCEDURE WriteStack(s: StackPtr);
  BEGIN
    WHILE NOT s^.Empty DO BEGIN
      Write(s^.Pop, ' ');
    END;
  END;

BEGIN
  New(safearraySt, Init);
  safearraySt^.Push(2);
  safearraySt^.Push(3);

  WriteStack(safearraySt);

  Dispose(safearraySt, Done);
END.