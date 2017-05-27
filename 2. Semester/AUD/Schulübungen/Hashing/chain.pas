(* Hashing-Tabelle mit Chaining *)

PROGRAM chain;

  CONST
    size = 10;

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      key: STRING;
      (* DATA *)
      next : NodePtr;
    END;
    ListPtr = NodePtr;
    HashTable = ARRAY[0..size-1] OF ListPtr;
  
  VAR (* Globale Variable *)
    table : HashTable;
    
  (* Init Hash Table *)
  PROCEDURE InitHashTable;
    var i: INTEGER;
  BEGIN
    FOR i:=0 to size-1 do begin
      table[i] := nil;
    end;
  END;
  
  (* Generiert NewNode *)
  function NewNode(key : STRING; next: NodePtr): NodePtr;
    VAR n : NodePtr;
  BEGIN
    New(n);
    n^.key := key;
    n^.next := next;
    (* n^.data := data; *)
    NewNode := n;
  END;
  
  (* Generiert den HashCode *)
  FUNCTION HashCode(key : STRING) : INTEGER;
  BEGIN
    HashCode := Ord(key[1]) MOD size;
  END;
  
  (* Generiert den HashCode *)
  FUNCTION HashCode2(key : STRING) : INTEGER;
  BEGIN
    HashCode2 := (Ord(key[1])+ Length(key)) MOD size;
  END;
  
  (* Generiert den HashCode (KOMPILER) *)
  FUNCTION HashCode3(key : STRING) : INTEGER;
  BEGIN
    IF Length(key) = 1 then
      HashCode3 := (Ord(key[1])*7+ 1)*17 MOD size
    ELSE
      HashCode3 := (Ord(key[1])*7+ Ord(key[2]) + Length(key))*17 MOD size;
      
  END;
  
  (* Generiert den HashCode (JAVA) *)
  FUNCTION HashCode4(key : STRING) : INTEGER;
    VAR hc, i : INTEGER;
  BEGIN
    hc := 0;
    FOR i:=1 to Length(key) do begin
    {Q-}
    {R-}
      hc := 31* hc + Ord(key[i]);
    {R+}
    {Q+}
    end;
    HashCode4 := Abs(hc) Mod Size;
  END;
  
  (* Sucht und fügt ein und gibt den eingefügten Ptr zurück *)
  FUNCTION Lookup(key : STRING): NodePtr;
    Var
      h: INTEGER;
      n : NodePtr;
  BEGIN
    h := HashCode4(key);
    //writeln('Hash of ', key , ' is ', h );
    n := table[h];
    
    while (n <> nil) AND (n^.key <> key) do
      n := n^.next;
      
    If n = nil then begin
      n := NewNode(key, table[h]);
      table[h] := n;
    end;
    
    Lookup := n;
    
  END;
  
  (* Prints the HAshTable *)
  PROCEDURE PrintTable;
    VAR
      h : INTEGER;
      n : NodePtr;
  BEGIN
    FOR h := 0 to size -1 do begin
      if table[h] <> nil then begin
        write(h, ' : ');
        n := table[h];
        while n <> nil do begin
          write(n^.key, ', ');
          n := n^.next;
        end;
        writeln;
      end;
    end;
  END;
  
  VAR
    n : NodePtr;
    
BEGIN
    InitHashTable;
    n := Lookup('Auer');
    n := Lookup('Daniel');
    n := Lookup('Andi');
    PrintTable;
    
END.