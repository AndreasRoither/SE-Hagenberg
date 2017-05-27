(* ========================================== *)
(* --           SOS UNIT 27.05.17          -- *)
(* ========================================== *)

UNIT SOSU;

  INTERFACE
    CONST
      MAX = 10;

    TYPE
      (* ========================================== *)
      (* --              SOS Class               -- *)
      (* ========================================== *)

      SOSPtr = ^SOS;
      SOS = OBJECT
        PRIVATE
          n: INTEGER;
          a: ARRAY[1..MAX] OF STRING;
        PUBLIC
          CONSTRUCTOR Init;
          DESTRUCTOR Done;                            VIRTUAL;

          FUNCTION Empty: BOOLEAN;                    VIRTUAL;
          FUNCTION Contains(val: STRING): BOOLEAN;    VIRTUAL;
          FUNCTION ContainsPos(val: STRING): INTEGER; VIRTUAL;
          FUNCTION Cardinality: INTEGER;              VIRTUAL;
          PROCEDURE Add(val: STRING);                 VIRTUAL;
          PROCEDURE Remove(val: STRING);              VIRTUAL;
          FUNCTION LookupPos(val: INTEGER): STRING;   VIRTUAL;
          PROCEDURE Print;                            VIRTUAL;

          (* set operations *)
          FUNCTION Union(b: SOSPtr): SOSPtr;          VIRTUAL;
          FUNCTION Intersection(b: SOSPtr): SOSPtr;   VIRTUAL;
          FUNCTION Difference(b: SOSPtr): SOSPtr;     VIRTUAL;
          FUNCTION Subset(b: SOSPtr): BOOLEAN;        VIRTUAL;
      END;

      (* ========================================== *)
      (* --             Sack Class               -- *)
      (* ========================================== *)

      SackPtr = ^Sack;
      Sack = OBJECT(SOS)
        PRIVATE
          counters: ARRAY[1..MAX] OF INTEGER;
        PUBLIC
          CONSTRUCTOR Init;
          DESTRUCTOR Done;

          FUNCTION Cardinality: INTEGER;
          PROCEDURE Add(val: STRING);
          PROCEDURE AddAmount(val: STRING; amount: INTEGER);
          PROCEDURE Remove(val: STRING);
          PROCEDURE LookupPos(val: INTEGER; VAR s: STRING; VAR amount: INTEGER);
          PROCEDURE Print;

          (* set operations *)
          FUNCTION Union(b: SackPtr): SackPtr;
          FUNCTION Difference(b: SackPtr): SackPtr;
          FUNCTION Intersection(b: SackPtr): SackPtr;
      END;

  IMPLEMENTATION

    (* ========================================== *)
    (* --       Implementation of SOS          -- *)
    (* ========================================== *)

    CONSTRUCTOR SOS.Init;
    BEGIN
      n := 0;
    END;

    DESTRUCTOR SOS.Done;
    BEGIN
      (* do nothing *)
    END;

    FUNCTION SOS.Empty: BOOLEAN;
    BEGIN
      Empty := n = 0;
    END;

    (* Returns TRUE if found*)
    FUNCTION SOS.Contains(val: STRING): BOOLEAN;
      VAR i: INTEGER;
    BEGIN
      Contains := FALSE;

      FOR i := 1 TO n DO BEGIN
        IF a[i] = val THEN BEGIN
          Contains := TRUE;
          break;
        END;
      END;
    END;

    (* returns pos of the found element *)
    FUNCTION SOS.ContainsPos(val: STRING): INTEGER;
      VAR i: INTEGER;
    BEGIN
      ContainsPos := 0;
      FOR i := 1 TO n DO BEGIN
        IF a[i] = val THEN BEGIN
          ContainsPos := i;
          break;
        END;
      END;
    END;

    FUNCTION SOS.Cardinality: INTEGER;
    BEGIN
      Cardinality := n;
    END;

    (* Adds to value to array, returns error msg if array is full *)
    PROCEDURE SOS.Add(val: STRING);
    BEGIN
      IF n < MAX THEN BEGIN
        n := n + 1;
        a[n] := val;
      END ELSE WriteLn('== ERROR ADD: Full! ==', #13#10);
    END;

    PROCEDURE SOS.Remove(val: STRING);
      VAR i,j: INTEGER;
    BEGIN
      IF NOT Empty THEN BEGIN
        FOR i := 0 TO n DO BEGIN
          IF a[i] = val THEN BEGIN
            FOR j := i TO n - 1 DO BEGIN
              a[j] := a[j + 1];
            END;
            n := n - 1;
            break;
          END;
        END;
      END ELSE WriteLn('Empty');
    END;

    (* Returns value from array at position * *)
    FUNCTION SOS.LookupPos(val: INTEGER): STRING;
    BEGIN
      LookupPos := '';
      IF NOT Empty THEN BEGIN
        IF (val <= n) AND (val >= 1) THEN LookupPos := a[val];
      END;
    END;

    (* Print all elements to the console *)
    PROCEDURE SOS.Print;
      VAR
        i: INTEGER;
    BEGIN
      FOR i := 1 TO n DO Write(a[i], ' ');
      WriteLn;
    END;

    (* Union of two sos objects
       Returns SOSPtr *)
    FUNCTION SOS.Union(b: SOSPtr): SOSPtr;
    VAR
      i: INTEGER;
      s: SOSPtr;
    BEGIN
      New(s,Init);
      IF (Cardinality + b^.Cardinality) <= MAX THEN BEGIN
        FOR i := 1 TO n DO BEGIN
          s^.Add(a[i]);
        END;
        FOR i := 1 TO b^.Cardinality DO BEGIN
          s^.Add(b^.LookupPos(i));
        END;
      END 
      ELSE BEGIN
        WriteLn('== Union Error ==');
        WriteLn(' Too big', #13#10' Cardinality m1: ', Cardinality, ' m2: '
          , b^.Cardinality, '- MAX size: ', MAX);
      END;
      Union := s;
    END;

    (* Intersection of two sos objects
       Returns SOSPtr *)
    FUNCTION SOS.Intersection(b: SOSPtr): SOSPtr;
      VAR
        i: INTEGER;
        s: SOSPtr;
    BEGIN
      New(s, Init);
      FOR i := 1 TO n DO BEGIN
        IF b^.Contains(a[i]) THEN s^.Add(a[i]);
      END;
      IF s^.Cardinality = 0 THEN BEGIN
        WriteLn('== Intersection ==');
        WriteLn(' Nothing in common');
      END;
      Intersection := s;
    END;

    (* Difference of two sos objects
       Returns SOSPtr *)
    FUNCTION SOS.Difference(b: SOSPtr): SOSPtr;
      VAR
        i: INTEGER;
        s: SOSPtr;
    BEGIN
      New(s, Init);
      FOR i := 1 TO n DO BEGIN
        IF NOT b^.Contains(a[i]) THEN s^.Add(a[i]);
      END;
      IF s^.Cardinality = 0 THEN BEGIN
        WriteLn('== Difference ==');
        WriteLn(' No difference');
      END;
      Difference := s;
    END;

    (* True if calling object is subset of b *)
    FUNCTION SOS.Subset(b: SOSPtr): BOOLEAN;
      VAR
        i: INTEGER;
    BEGIN
      Subset := TRUE;
      FOR i := 1 TO n DO BEGIN
        IF NOT b^.Contains(a[i]) THEN BEGIN
          Subset := FALSE;
          break;
        END;
      END;
    END;

    (* ========================================== *)
    (* --       Implementation of Sack         -- *)
    (* ========================================== *)

    CONSTRUCTOR Sack.Init;
    BEGIN
      INHERITED Init;
    END;

    DESTRUCTOR Sack.Done;
    BEGIN
      INHERITED Done;
    END;

    PROCEDURE Sack.Remove(val: STRING);
      VAR i,j: INTEGER;
    BEGIN
      i := ContainsPos(val);
      INHERITED Remove(val);
      IF i > 0 THEN BEGIN
        FOR j := i TO n - 1 DO BEGIN
          counters[j] := counters[j + 1];
        END;
      END;
    END;

    (* Adds to value to array, returns error msg if array is full *)
    PROCEDURE Sack.Add(val: STRING);
      VAR
        pos: INTEGER;
    BEGIN
      pos := ContainsPos(val);
      IF pos = 0 THEN BEGIN
        INHERITED Add(val);
        counters[n] := counters[n] + 1;
      END
      ELSE counters[pos] := counters[pos] + 1;
    END;

    (* Adds to value to array, returns error msg if array is full *)
    PROCEDURE Sack.AddAmount(val: STRING; amount: INTEGER);
      VAR
        pos: INTEGER;
    BEGIN
      pos := ContainsPos(val);
      IF pos = 0 THEN BEGIN
        INHERITED Add(val);
        counters[n] := counters[n] + amount;
      END
      ELSE counters[pos] := counters[pos] + amount;
    END;

    FUNCTION Sack.Cardinality: INTEGER;
      VAR
        i: INTEGER;
    BEGIN
      Cardinality := 0;
      FOR i := 1 TO n DO BEGIN
        Cardinality := Cardinality + counters[i];
      END;
    END;

    (* Returns value from array at position * *)
    PROCEDURE Sack.LookupPos(val: INTEGER; VAR s: STRING; VAR amount: 
      INTEGER);
    BEGIN
      IF NOT Empty THEN BEGIN
        IF (val <= n) AND (val >= 1) THEN BEGIN
          s := a[val];
          amount := counters[val];
        END;
      END;
    END;

    PROCEDURE Sack.Print;
      VAR
        i: INTEGER;
    BEGIN
      FOR i := 1 TO n DO Write(a[i], ' x', counters[i], ' ');
      WriteLn;
    END;

    (* Union of two sos objects
       Returns SackPtr *)
    FUNCTION Sack.Union(b: SackPtr): SackPtr;
    VAR
      i, amount: INTEGER;
      s: SackPtr;
      str: STRING;
    BEGIN
      New(s,Init);
      str := '';
      amount := 0;

      IF (Cardinality + b^.Cardinality) <= MAX THEN BEGIN
        FOR i := 1 TO n DO BEGIN
          s^.AddAmount(a[i], counters[i]);
        END;
        FOR i := 1 TO b^.Cardinality DO BEGIN
          b^.LookupPos(i, str, amount);
          s^.AddAmount(str, amount);
        END;
      END
      ELSE BEGIN
        WriteLn('== Union Error ==');
        WriteLn(' Too big', #13#10' Cardinality m1: ', Cardinality, ' m2: '
          , b^.Cardinality, '- MAX size: ', MAX);
      END;
      Union := s;
    END;

    (* Difference of two sos objects
       Returns SackPtr *)
    FUNCTION Sack.Difference(b: SackPtr):SackPtr;
      VAR
        i: INTEGER;
        s: SackPtr;
    BEGIN
      New(s, Init);
      FOR i := 1 TO n DO BEGIN
        IF NOT b^.Contains(a[i]) THEN s^.AddAmount(a[i], counters[i]);
      END;
      IF s^.Cardinality = 0 THEN BEGIN
        WriteLn('== Difference ==');
        WriteLn(' No difference');
      END;
      Difference := s;
    END;

    (* Intersection of two sos objects
       Returns SOSPtr *)
    FUNCTION Sack.Intersection(b: SackPtr): SackPtr;
      VAR
        i: INTEGER;
        s: SackPtr;
    BEGIN
      New(s, Init);
      FOR i := 1 TO n DO BEGIN
        IF b^.Contains(a[i]) THEN s^.Add(a[i]);
      END;
      IF s^.Cardinality = 0 THEN BEGIN
        WriteLn('== Intersection ==');
        WriteLn(' Nothing in common');
      END;
      Intersection := s;
    END;
END.