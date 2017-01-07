(* WLA:                                    HDO, 2016-12-06
   ---
   Wish list analyzer for the Christkind.
==========================================================*)
PROGRAM WLA;

(*$IFDEF WINDOWS*)
  USES
    WinCrt;
(*$ENDIF*)

TYPE 
  wishPtr = ^wishersNode;
  wishersNode = RECORD
    next : wishPtr;
    name : STRING;  
  END; (* END RECORD *)

  amazonListPtr = ^listElement;
  listElement = RECORD
    prev : amazonListPtr;
    next : amazonListPtr;
    item : STRING;
    n : INTEGER;
    wishers : wishPtr;    
  END; (* END RECORD *)

  amazonList = RECORD
    first: amazonListPtr;
    last:  amazonListPtr;
  END; (* END RECORD *)

PROCEDURE InitAmazonList(VAR l : amazonList);
BEGIN
  l.first := NIL;
  l.last := NIL;
END;

FUNCTION newWishNode(name : STRING) : wishPtr;
VAR temp : wishPtr;
BEGIN
  New(temp);
  temp^.next := NIL;
  temp^.name := name;

  newWishNode := temp;
END;

PROCEDURE appendToWishList(VAR list : wishPtr; node : wishPtr);
VAR temp : wishPtr;
BEGIN
  IF (list <> NIL) THEN 
  BEGIN
    temp := list;
    WHILE (temp^.next <> NIL) DO
      temp := temp^.next;

    temp^.next := node;
  END
  ELSE
    list := node;
END;

FUNCTION newAmazonListNode(item, wisher : STRING) : amazonListPtr;
VAR temp : amazonListPtr;
BEGIN
  New(temp);
  temp^.prev := NIL;
  temp^.next := NIL;
  temp^.item := item;
  temp^.n := 1;
  temp^.wishers := newWishNode(wisher);

  newAmazonListNode := temp;
END;

(* Append to the amazon list *)
(* if there is no toy in the list a new element will be made *)
(* if a toy is already in the list, the name of the wisher will be added to the wisher list *)
PROCEDURE appendToAmazonList(VAR amazon_List : amazonList; toy, wisher : STRING);
VAR aListPtr, temp : amazonListPtr;
BEGIN
  aListPtr := amazon_List.first;

  IF amazon_List.first = NIL THEN
  BEGIN
    aListPtr := newAmazonListNode(toy, wisher);
    amazon_List.first := aListPtr;
    amazon_List.last := aListPtr;
  END
  ELSE
  BEGIN
    WHILE aListPtr^.next <> NIL DO
    BEGIN 
      IF aListPtr^.item = toy THEN break
      ELSE
        aListPtr := aListPtr^.next;
    END;

    IF aListPtr^.item = toy then
    BEGIN
      appendToWishList(aListPtr^.wishers,newWishNode(wisher));
      aListPtr^.n := aListPtr^.n + 1;
    END
    ELSE
    BEGIN
      aListPtr := newAmazonListNode(toy, wisher);
      aListPtr^.prev := amazon_List.last;
      amazon_List.last^.next := aListPtr;
      amazon_List.last := alistPtr;
    END;
  END;
END;

(*#######################*)
(*  Printing to Console  *)
(*#######################*)

PROCEDURE printWishers(wishers : wishPtr);
VAR temp : wishPtr;
BEGIN
  temp := wishers;

  WHILE temp <> NIL DO
  BEGIN
    Write(temp^.name, ' ');
    temp := temp^.next;
  END;
END;

PROCEDURE printAmazonList(list : amazonList);
VAR 
  temp : amazonListPtr;
  count : INTEGER;
BEGIN
  temp := list.first;
  count := 1;

  WHILE temp <> NIL DO
  BEGIN
    WriteLn(count, '. Item:');
    WriteLn('Name > ',temp^.item ,' | Count > ', temp^.n);
    WriteLn('Wishers: ');
    printWishers(temp^.wishers);
    WriteLn;
    WriteLn;
    count := count + 1;
    temp := temp^.next;
  END;
END;

VAR
  wishesFile: TEXT;
  line, wisher, toy: STRING;
  position : INTEGER;
  amazon_List : amazonList;

BEGIN (*WLA*)
  InitAmazonList(amazon_List);

  WriteLn(chr(205),chr(205),chr(185),' Amazon wish list for XMas ',chr(204),chr(205),chr(205));  
  WriteLn;
  
  (* Read every line from txt *)
  Assign(wishesFile, 'Wishes.txt');
  Reset(wishesFile);
  
  REPEAT
    ReadLn(wishesFile, line);
    position := pos(':',line);

    IF position <> 0 THEN
      wisher := Copy(line,1,position-1)
    ELSE
      appendToAmazonList(amazon_List,line,wisher);

    //WriteLn(wisher, ' ',position); 
  UNTIL Eof(wishesFile);
  Close(wishesFile);

  printAmazonList(amazon_List);

END. (*WLA*)