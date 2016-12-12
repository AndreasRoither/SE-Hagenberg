(* BigInts:                                       F.Li, 1998-11-22
   -------                                         HDO, 2000-11-13
   Artihmetic for arbitrary size integers which are
   represented as singly-linked lists.
==================================================================*)

PROGRAM BigInts;

(*$IFDEF WINDOWS, for Borland Pascal only*)
  USES
    WinCrt,
    Math;
(*$ENDIF*)

(*$DEFINE SIGNED*)   (*when defined: first digit is sign +1 or -1*)

  CONST
    base = 1000;     (*base of number system used in all*)
                     (*  calculations, big digits: 0 .. base - 1*)

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      next: NodePtr;
      val: INTEGER;
    END; (*RECORD*)
    BigIntPtr = NodePtr;


  FUNCTION NewNode(val: INTEGER): NodePtr;
    VAR
      n: NodePtr;
  BEGIN
    New(n);
    (*IF n == NIL THEN ...*)
    n^.next := NIL;
    n^.val := val;
    NewNode := n;
  END; (*NewNode*)

  FUNCTION Zero: BigIntPtr;
  BEGIN
    Zero := NewNode(0);
  END; (*Zero*)

  PROCEDURE Append(VAR bi: BigIntPtr; val: INTEGER);
    VAR
      n, last: NodePtr;
  BEGIN
    n := NewNode(val);
    IF bi = NIL THEN
      bi := n
    ELSE BEGIN (*l <>NIL*)
      last := bi;
      WHILE last^.next <> NIL DO BEGIN
        last := last^.next;
      END; (*WHILE*)
      last^.next := n;
    END; (*ELSE*)
  END; (*Append*)

  PROCEDURE Prepend(VAR bi: BigIntPtr; val: INTEGER);
    VAR
      n: NodePtr;
  BEGIN
    n := NewNode(val);
    n^.next := bi;
    bi := n;
  END; (*Prepend*)

  FUNCTION Sign(bi: BigIntPtr): INTEGER;
  BEGIN
(*$IFDEF SIGNED*)
      (*assert: bi <> NIL*)
      Sign := bi^.val; (*results in +1 or -1*)
(*$ELSE*)
      WriteLn('Error in Sign: no sign node available');
      Halt;
(*$ENDIF*)
  END; (*Sign*)

  FUNCTION CopyOfBigInt(bi: BigIntPtr): BigIntPtr;
    VAR
      n: NodePtr;
      cBi: BigIntPtr; (*cBi = copy of BigIntPtr*)
  BEGIN
    cBi := NIL;
    n := bi;
    WHILE n <> NIL DO BEGIN
      Append(cBi, n^.val);
      n := n^.next;
    END; (*WHILE*)
    CopyOfBigInt := cBi;
  END; (*CopyOfBigInt*)

  PROCEDURE InvertBigInt(VAR bi: BigIntPtr);
    VAR
      iBi, next: NodePtr; (*iBi = inverted BigIntPtr*)
  BEGIN
    IF bi <> NIL THEN BEGIN
      iBi := bi;
      bi := bi^.next;
      iBi^.next := NIL;
      WHILE bi <> NIL DO BEGIN
        next := bi^.next;
        bi^.next := iBi;
        iBi := bi;
        bi := next;
      END; (*WHILE*)
      bi := iBi;
    END; (*IF*)
  END; (*InvertBigInt*)

  PROCEDURE DisposeBigInt(VAR bi: BigIntPtr);
    VAR
      next: NodePtr;
  BEGIN
    WHILE bi <> NIL DO BEGIN
      next := bi^.next;
      Dispose(bi);
      bi := next;
    END; (*WHILE*)
  END; (*DisposeBigInt*)


  (* ReadBigInt: reads BigIntPtr, version for base = 1000
     Input syntax: BigIntPtr = { digit }.
                   BigIntPtr = [+ | -] digit { digit }.
     The empty string is treated as zero, and as the whole
     input is read into one STRING, max. length is 255.
  -------------------------------------------------------*)
  PROCEDURE ReadBigInt(VAR bi: BigIntPtr);
    VAR
      s: STRING;           (*input string*)
      iBeg, iEnd: INTEGER; (*begin and end of proper input *)
      bigDig, decDig: INTEGER;
      nrOfBigDigits, lenOfFirst: INTEGER;
      sign, i, j: INTEGER;

    PROCEDURE WriteWarning(warnPos: INTEGER);
    BEGIN
      WriteLn('Warning in ReadBigInt: ',
              'character ', s[warnPos],
              ' in column ', warnPos, ' is treated as zero');
    END; (*WriteWarning*)

  BEGIN (*ReadBigInt*)
    IF base <> 1000 THEN BEGIN
      WriteLn('Error in ReadBigInt: ',
              'procedure currently works for base = 1000 only');
      Halt;
    END; (*IF*)
    ReadLn(s);
    iEnd := Length(s);
    IF iEnd = 0 THEN
      bi := Zero
    ELSE BEGIN

(*$IFDEF SIGNED*)
      IF s[1] = '-' THEN BEGIN
        sign := -1;
        iBeg :=  2;
      END (*THEN*)
      ELSE IF s[1] = '+' THEN BEGIN
        sign := 1;
        iBeg := 2;
      END (*THEN*)
      ELSE BEGIN
(*$ENDIF*)
        sign := 1;
        iBeg := 1;
(*$IFDEF SIGNED*)
      END; (*ELSE*)
(*$ENDIF*)

      WHILE (iBeg <= iEnd) AND
            ((s[iBeg] < '1') OR (s[iBeg] > '9')) DO BEGIN
        IF (s[iBeg] <> '0') AND (s[iBeg] <> ' ') THEN
          WriteWarning(iBeg);
        iBeg := iBeg + 1;
      END; (*WHILE*)

      (*get value from s[iBeg .. iEnd]*)
      IF iBeg > iEnd THEN
        bi := Zero
      ELSE BEGIN
        bi := NIL;
        nrOfBigDigits := (iEnd - iBeg) DIV 3 + 1;
        lenOfFirst    := (iEnd - iBeg) MOD 3 + 1;
        FOR i := 1 TO nrOfBigDigits DO BEGIN
          bigDig := 0;
          FOR j := iBeg TO iBeg + lenOfFirst - 1 DO BEGIN
            IF (s[j] >= '0') AND (s[j] <= '9') THEN
              decDig := Ord(s[j]) - Ord('0')
            ELSE BEGIN
              WriteWarning(j);
              decDig := 0;
            END; (*ELSE*)
            bigDig := bigDig * 10 + decDig;
          END; (*FOR*)
          Prepend(bi, bigDig);
          iBeg := iBeg + lenOfFirst;
          lenOfFirst := 3;
        END; (*FOR*)
(*$IFDEF SIGNED*)
        Prepend(bi, sign);
(*$ENDIF*)
      END; (*IF*)
    END; (*ELSE*)
  END; (*ReadBigInt*)


  (* WriteBigInt: writes BigIntPtr, version for base = 1000
  -------------------------------------------------------*)
  PROCEDURE WriteBigInt(bi: BigIntPtr);
    VAR
      revBi: BigIntPtr;
      n: NodePtr;
  BEGIN
    IF base <> 1000 THEN BEGIN
      WriteLn('Error in WriteBigInt: ',
              'procedure currently works for base = 1000 only');
      Halt;
    END; (*IF*)
    IF bi = NIL THEN
      Write('0')
    ELSE BEGIN
(*$IFDEF SIGNED*)
        IF Sign(bi) = -1 THEN
          Write('-');
        revBi := CopyOfBigInt(bi^.next);
(*$ELSE*)
        revBi := CopyOfBigInt(bi);
(*$ENDIF*)
      InvertBigInt(revBi);
      n := revBi;
      Write(n^.val); (*first big digit printed without leading zeros*)
      n := n^.next;
      WHILE n <> NIL DO BEGIN
        IF n^.val >= 100 THEN
          Write(n^.val)
        ELSE IF n^.val >= 10 THEN
          Write('0', n^.val)
        ELSE (*n^.val < 10*)
          Write('00', n^.val);
        n := n^.next;
      END; (*WHILE*)
      DisposeBigInt(revBi); (*release the copy*)
    END; (*IF*)
  END; (*WriteBigInt*)

FUNCTION ANZ_Nodes(a : BigIntPtr): INTEGER;
VAR count : INTEGER;
BEGIN
  count := 1;
  
  WHILE a^.next <> NIL DO
  BEGIN
    a := a^.next;
    count := count + 1;
  END;
  
  ANZ_Nodes := count;
END;

FUNCTION HigherBigInt (a, b: BigIntPtr) : INTEGER;
VAR temp_a, temp_b : BigIntPtr;
BEGIN
  temp_a := CopyOfBigInt(a);
  temp_b := CopyOfBigInt(b);
  InvertBigInt(temp_a);
  InvertBigInt(temp_b);

  WHILE (temp_a^.val = temp_b^.val) AND (temp_a^.next <> NIL) AND (temp_b^.next <> NIL) DO
  BEGIN
    temp_a := temp_a^.next;
    temp_b := temp_b^.next;
  END;    

  IF (temp_a^.next = NIL) AND (temp_b^.next = NIL) THEN HigherBigInt := 0
  ELSE IF (temp_a^.next <> NIL) AND (temp_b^.next = NIL) THEN HigherBigInt := 1
  ELSE IF (temp_a^.next  = NIL) AND (temp_b^.next <> NIL) THEN HigherBigInt := 2
  ELSE IF temp_a^.val > temp_b^.val THEN HigherBigInt := 1 
  ELSE HigherBigInt := 2;
END;

FUNCTION Sum (a, b: BigIntPtr) : BigIntPtr;  (*compute sum = a + b*)
VAR result : BigIntPtr;
VAR sign_a, sign_b, overflow, temp, anz_a, anz_b, ishigher : Integer;

BEGIN

  IF a^.val = 0 THEN result := CopyOfBigInt(b);
  IF b^.val = 0 THEN result := CopyOfBigInt(a)
  ELSE
  BEGIN 
    result := NIL;
    overflow := 0;
    ishigher := 0;
    sign_a := Sign(a);
    sign_b := Sign(b);
    anz_a := ANZ_Nodes(a);
    anz_b := ANZ_Nodes(b);

    IF anz_a > anz_b THEN ishigher := 1
    ELSE IF anz_b > anz_a THEN ishigher := 2
    ELSE ishigher := HigherBigInt(a,b);   
    
    IF ((sign_a = 1) OR (sign_a = 0)) AND ((sign_b = 1) OR (sign_a = 0)) THEN Append(result,1)
    ELSE IF (sign_a = -1) AND (sign_b = -1) THEN Append(result,-1)
    ELSE IF (sign_a = -1) AND (sign_b = 1) THEN 
      IF ishigher = 1 THEN Append(result,-1) ELSE Append(result,1)
    ELSE
      IF ishigher = 1 THEN Append(result,1) ELSE Append(result,-1);

    IF (ishigher = 0) AND (sign_a <> sign_b) THEN
    BEGIN
      result^.val := 1;
      Append(result,0);
    END
    ELSE
    BEGIN
      REPEAT
        IF a^.next <> NIL THEN a := a^.next ELSE a^.val := 0;
        IF b^.next <> NIL THEN b := b^.next ELSE b^.val := 0;

        IF ((sign_a = 1) AND (sign_b = 1)) OR ((sign_a = -1) AND (sign_b = -1)) THEN 
        BEGIN
          temp := a^.val + b^.val + overflow;
          overflow := 0;
        END
        ELSE
        BEGIN
          IF ishigher = 1 THEN
          BEGIN
            IF a^.val >= b^.val THEN 
            BEGIN
              temp := a^.val - b^.val + overflow;
              overflow := 0;  
            END
            ELSE BEGIN
              temp := (1000 + a^.val) - b^.val + overflow;
              overflow := -1;
            END;
          END
          ELSE
          BEGIN
            IF b^.val >= a^.val THEN 
            BEGIN
              temp := b^.val - a^.val + overflow;
              overflow := 0;  
            END
            ELSE BEGIN
              temp := (1000 + b^.val) - a^.val + overflow;
              overflow := -1;
            END;
          END;
        END;  

        IF temp >= 1000 THEN
        BEGIN
          overflow := 1;
          temp := temp - 1000;
        END
        ELSE IF temp < 0 then
        BEGIN
          temp := 1000 + temp;
          overflow := - 1;
        END;

        IF (temp = 0) AND ((a^.next = NIL) AND (b^.next = NIL)) THEN ELSE Append(result,temp);

      UNTIL ((a^.val = 0) AND (b^.val = 0)) AND ((a^.next = NIL) AND (b^.next = NIL));
    END;
  END;
  
  Sum := result;
END;

FUNCTION Product (a, b: BigIntPtr) : BigIntPtr; (*compute product = a * b*)
var result : BigIntPtr;
VAR i, sum_a, sum_b, sum_ab : Int64;

BEGIN
  result := NIL;

  IF Sign(a) <> Sign(b) then
    Append(result, -1)
  ELSE
    Append(result, 1);
  
  sum_a := 0;
  sum_b := 0;
  i := 0;

  a := a^.next;
  b := b^.next;

  WHILE a <> NIL DO 
  BEGIN
    sum_a := sum_a + (a^.val * (base ** i));
    a := a^.next;
    i := i + 1;
  END;

  i := 0;

  WHILE b <> NIL DO 
  BEGIN 
    sum_b := sum_b + (b^.val * (base ** i));
    b := b^.next;
    i := i + 1;
  END;

  sum_ab := sum_a * sum_b;
  WriteLn(sum_ab);
  
  WHILE sum_ab <> 0 DO 
  BEGIN 
    Append(result, (sum_ab MOD base));
    WriteBigInt(result);
    sum_ab := sum_ab DIV base;
  END;

  Product := result;
    
END;

(*=== main program, for test purposes ===*)

  VAR
    bi : BigIntPtr;
    bi2: BigIntPtr;
    sumbi : BigIntPtr;
    probi : BigIntPtr;

BEGIN (*BigInts*)

  WriteLn(chr(205),chr(205),chr(185),' BigInt ',chr(204),chr(205),chr(205));  
  
  (*tests for ReadBigInt and WriteBigInt only*)
  Write('big int > ');
  ReadBigInt(bi);
  
  Write('big int > ');
  ReadBigInt(bi2);

  WriteLN;
  
  Write('Sum : ');
  sumbi := Sum(bi,bi2);
  WriteBigInt(sumbi);
  WriteLN;

  Write('Product : ');
  probi := Product(bi, bi2);
  WriteBigInt(probi);

END. (*BigInts*)

