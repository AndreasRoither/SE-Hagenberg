(* Hashing - openadressing   15.03.2017*)
PROGRAM hashopen;

uses
  Crt;

CONST
  size = 31;

TYPE
  NodePtr = ^Node;
  Node = RECORD
    key: STRING;
     (* data: AnyType*)
  END; (*Record*)
  
  HashTable = ARRAY[0..size-1] OF NodePtr;

VAR
  ht : HashTable;

procedure InitHashTable;
var
  h: Integer;
begin
  for h := 0 to size-1 do begin
    ht[h] := Nil;
  end;
end; (*InitHashTable*)

function NewNode(key: String) : NodePtr;
var
  n: NodePtr;
begin
  New(n);
  n^.key := key;
  (* n^.data := data; *)

  NewNode := n;
end; (*NewNode*)

(* returns the hashcode of a key *)
function HashCode(key: String): Integer;
begin
  HashCode := Ord(key[1]) MOD size;
end; (*HashCode*)

(* returns the hashcode of a key *)
function HashCode2(key: String): Integer;
begin
  HashCode2 := (Ord(key[1]) + Length(key)) MOD size;
end; (*HashCode2*)

(* compiler hashcode.. *)
function HashCode3(key: String): Integer;
begin
  if Length(key) = 1 then
    HashCode3 := (Ord(key[1]) * 7 + 1) * 17 MOD size
  else
    HashCode3 := (Ord(key[1]) * 7 + Ord(key[2]) + Length(key)) * 17 MOD size
end; (*HashCode3*)

(* returns the hashcode of a key *)
function HashCode4(key: String): Integer;
  var
    hc, i : Integer;
begin
  hc := 0;

  for i := 1 to Length(key) do begin
  {Q-}
  {R-}
    hc := 31 * hc + Ord(key[i]);
  {R+}
  {Q+}
  end; (* for *)

  HashCode4 := Abs(hc) MOD size;
end; (*HashCode4*)

(* Lookup combines search and prepend *)
function Lookup(key: String) : NodePtr;
  var
    h,i, noOfColl: Integer;
    n: NodePtr;  
begin
  i := HashCode3(key);
  WriteLn('Hashwert= ', i);
  noOfColl := 0;

  while (noOfColl <= size) do begin
    n := ht[i];

    if n = nil then begin
        n := NewNode(key);
        ht[i] := n;
        Lookup := n;
        Exit;
    end
    else if n^.key = key then begin
        Lookup := n;
        Exit;
    end; (*key already exists*)
    noOfColl := noOfColl + 1;

    (* linear collision strategy *) 
    h := (h + 1) MOD size;
  end; (* while *)
end; (* Lookup *)

procedure WriteHashTable;
  var 
    h : Integer;
begin
  for h:= 0 to size-1 do begin
    if ht[h] <> nil then begin 
      WriteLn(h, ': ', ht[h]^.key);
    end; (* if *)
  end; (* for *)
end; (* WriteHashTable *)

var
  n: NodePtr;
BEGIN
  Write('Auer '); n := Lookup('Auer');
  Write('Bach '); n := Lookup('Bach');
  Write('Bieger '); n := Lookup('Bieger');
  Write('Rieger '); n := Lookup('Rieger');
  Write('Brunmueller '); n := Lookup('Brunmueller');
  Write('Eieger '); n := Lookup('Eieger');
  Write('Sauer '); n := Lookup('Sauer');

  WriteLn;
  WriteHashTable;

END. (* Hashopen *)
