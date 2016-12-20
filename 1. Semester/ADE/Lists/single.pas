program single;

TYPE
    nodePtr = ^listElement;
    listElement = RECORD
      next: nodePtr;
      val: Integer;
    END;

procedure printList(list : nodePtr);
BEGIN
  write('list: ');
  while(list <> nil) do begin
    write(list^.val);
    list := list^.next;
  end;
  WriteLn;
END;

function NewNode(val : Integer): nodePtr;
var node : nodePtr;
begin
  New(node);
  node^.next := nil;
  node^.val := val;
  NewNode := node;
end;

procedure Append(var list : nodePtr; element : nodePtr);
var tmp : nodePtr;
BEGIN
  if list = nil then list := element else begin
    tmp := list;
    while tmp^.next <> nil do
      tmp := tmp^.next;
    tmp^.next := element;    
  end;
END;

procedure Prepend(var list : nodePtr; element : nodePtr);
BEGIN
  if list = nil then list := element else begin
    element^.next := list;
    list := element;
  END;
END;

function getNode(list: nodePtr; val : Integer) : nodePtr;
begin
  getNode := nil;
  while(list <> nil) do begin
    if list^.val = val then exit(list);
    list := list^.next;
  end;    
end;

procedure insertAfter(var list : nodePtr; val : Integer; node : nodePtr);
var found,tmp : nodePtr;
begin
  found := getNode(list, val);
  if found <> nil then begin
    tmp := found^.next;
    found^.next := node;
    node^.next := tmp;
  end;
end;

procedure changeValue(list : nodePtr; oldVal, newVal : Integer);
begin
  if getNode(list, oldVal) <> nil then begin
    getNode(list,oldVal)^.val := newVal;
  end;
end;

procedure deleteNode(var list :nodePtr; val :Integer);
begin
  if list = nil then exit else begin
    if list^.val = val then list := list^.next else begin
      while(list^.next <> nil) do begin
        if list^.next^.val = val then begin
          list := list^.next^.next;
          exit;
        end;
        list := list^.next;
      end;   
    end;
  end;
end;

procedure disposeList(var list : nodePtr);
begin
  if list^.next = nil then dispose(list) else disposeList(list^.next);
end;

procedure reverseList(var list : nodePtr);
var result : nodePtr;
begin
    result := nil;
    while(list <> nil) do begin
      Prepend(result, NewNode(list^.val));
      list := list^.next;
    end;
    list := result;
end;

procedure insertBefore(var list :nodePtr; val :Integer; node : nodePtr);
var tmp : nodePtr;
var temp2 : nodePtr;
begin
  temp2 :=  list;
  if list = nil then exit else begin
    if list^.val = val then Prepend(list,node) else begin
      while(list^.next <> nil) do 
      begin
        if list^.next^.val = val then 
        begin
          tmp := list^.next;
          list^.next := node;
          node^.next := tmp;
          list := temp2;
          exit;
        end;
        list := list^.next;
      end;   
    end;
  end;
end;

procedure insertAft(var list :nodePtr; val :Integer; node : nodePtr);
var tmp, tmp2 : nodePtr;
begin
  tmp := list;
  if list = nil then exit else begin
    if list^.val = val then Prepend(list,node) 
    else begin
      while(tmp <> nil) do 
      begin
        if tmp^.val = val then 
        begin
          tmp2 := tmp^.next;
          tmp^.next := node;
          node^.next := tmp2;
          exit;
        end;
        tmp := tmp^.next;
      end;   
    end;
  end;
end;

function hasDoubles(list : nodePtr; val : Integer) : Boolean;
var temp : nodePtr;
var temp2 : nodePtr;
begin

  if (list <> Nil) and (list^.next <> Nil) then 
  begin
    temp := list;
    hasDoubles := False;
    while (temp <> Nil) and (hasDoubles = False) do begin
      temp2 := temp^.next;
      while temp2 <> Nil do begin
        if temp2^.val = val then
        begin
          hasDoubles := True;
          break;
        end;
        temp2 := temp2^.next;
      end;
      temp := temp^.next;      
    end;
  end;
end;

procedure deleteDoubles(var list : nodePtr);
var temp : nodePtr;
var temp2 : nodePtr;
var temp3 : nodePtr;
begin

  if (list <> Nil) and (list^.next <> Nil) then 
  begin
    temp := list;

    while (temp <> Nil) do begin
      temp2 := temp^.next;
      temp3 := temp;
      while temp2 <> Nil do begin
        if temp^.val = temp2^.val then
        begin
          temp3^.next := temp2^.next;
          Dispose(temp2);
          temp2 := temp3;
        end;
        temp3 := temp2; 
        temp2 := temp2^.next;     
      end;
      temp := temp^.next;      
    end;
  end;
end;

procedure deleteSpecificDouble(var list : nodePtr; val : Integer);
var temp : nodePtr;
var temp2 : nodePtr;
var temp3 : nodePtr;
begin

  if (list <> Nil) and (list^.next <> Nil) then 
  begin
    temp := list;

    while (temp <> Nil) do begin
      temp2 := temp^.next;
      temp3 := temp;
      while temp2 <> Nil do begin
        if temp2^.val = val then
        begin
          temp3^.next := temp2^.next;
          Dispose(temp2);
          temp2 := temp3;
        end;
        temp3 := temp2; 
        temp2 := temp2^.next;     
      end;
      temp := temp^.next;      
    end;
  end;
end;

procedure bringToFront(var list : nodePtr; val : Integer);
var temp : nodePtr;
var temp2 : nodePtr;
begin
  temp := list;
  
  if temp^.next <> Nil then
  begin
    while (temp <> Nil) do
    begin
      temp2 := temp;
      temp := temp^.next;

      if(temp^.val = val) then
      begin
        temp2^.next := temp^.next;
        temp^.next := list;
        list := temp;
        break;
      end;
    end;
  end;
end;

procedure bringToBack(var list : nodePtr; val : Integer);
var temp, temp2, temp3 : nodePtr;
begin
  temp := list;
  temp3 := Nil;

  if temp^.val = val then
  begin
    list := temp^.next;
    temp2 := list;

    while temp2^.next <> Nil do
      temp2 := temp2^.next;

    printList(temp);
    temp2^.next := temp;
    temp^.next := Nil;
  end 
  else 
  begin
    while temp^.next <> Nil do
    begin
      temp2 := temp;
      temp := temp^.next;

      if(temp^.val = val) then
      begin
        temp2^.next := temp^.next;
        temp3 := temp;
        break;
      end;
    end;
    
    while temp^.next <> Nil do
    begin
        temp := temp^.next;
    end;

    if (temp3 <> Nil) then
    begin
      temp3^.next := Nil;
      temp^.next := temp3;
    end;
  end;
    
end;


var list : nodePtr;
begin
Append(list, NewNode(1));
Append(list, NewNode(1));
Append(list, NewNode(2));
Append(list, NewNode(4));
Append(list, NewNode(5));
Append(list, NewNode(5));
Append(list, NewNode(6));
Prepend(list, NewNode(3));
insertBefore(list, 6, NewNode(8));
insertAft(list,6,NewNode(7));
insertAfter(list, 1, NewNode(9));

if hasDoubles(list,1) then WriteLn('List has doubles') else WriteLn('List has no doubles');

printList(list);
bringToFront(list,4);
printList(list);
bringToBack(list, 4);
printList(list);
deleteSpecificDouble(list, 1);
printList(list);
deleteDoubles(list);
printList(list);
reverseList(list);
printList(list);

disposeList(list);
end.