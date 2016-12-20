program test;

type 
 nodePtr = ^listElement;
 listElement = record
 val : Integer;
 Prev : nodePtr;
 Next : nodePtr;
 end;

List = RECORD
    first: nodePtr;
    last:  nodePtr;
  END;


function NewNode(val : Integer) : nodePtr;
var temp : nodePtr;
begin
  New(temp);
  temp^.val := val;
  temp^.prev := Nil;
  temp^.next := Nil;
  NewNode := temp;
end;

procedure initList(var l : List);
begin
  l.first := Nil;
  l.last := Nil;
end;

procedure Prepend(var l : List; val : Integer);
var n : nodePtr;
begin
  n := NewNode(val);

  if (l.first = Nil) then
  begin
    l.first := n;
    l.last := n;    
  end
  else
  begin
    n^.next := l.first;
    l.first^.prev := n;
    l.first := n;
  end;
end;

procedure Prepend2(var l : List; node : nodePtr);
begin
  if(l.first = Nil) then
  begin
    l.first := node;
    l.last := node;    
  end
  else
  begin
    node^.prev := Nil;
    node^.next := l.first;
    l.first^.prev := node;
    l.first := node;
  end;
end;

procedure Append(var l : List; val : Integer);
var n : nodePtr;
begin
  n := NewNode(val);
  
  if (l.first = Nil) then
  begin
    l.first := n;
    l.last := n;
  end
  else
  begin
    n^.prev := l.last;
    l.last^.next := n;
    l.last := n;
  end; 
end;

procedure Reverse(var l : List);
var n : nodePtr;
var temp : List;
begin
   initList(temp);
   n := l.last;

   while n <> Nil do
     begin
       Append(temp,n^.val);
       n := n^.prev;
     end;
    l := temp;
end;

procedure PrintList(l : List);
var n : nodePtr;
begin
  n := l.first;
  write('List: ');
  
  while n <> Nil do
  begin
    Write(n^.val);
    n := n^.next;
  end;
  WriteLn;
end;

var l : List;
begin
  initList(l);
  Append(l,1);
  Append(l,2);
  Append(l,3);
  Append(l,4);
  Append(l,5);
  Prepend(l,1);
  Prepend(l,7);

  PrintList(l);
  Reverse(l);

  PrintList(l);
end.