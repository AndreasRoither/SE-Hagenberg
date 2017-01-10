PROGRAM WLA;

USES
	WinCrt;


TYPE
   WishersNodePtr = ^Wishers;
   Wishers = RECORD
    next: WishersNodePtr;
    name: STRING;
   END; 
   WishersListPtr = WishersNodePtr;

   AmazonPtr = ^AmazonNode;
   AmazonNode= RECORD
    next: AmazonPtr;
    prev: AmazonPtr;
    item: STRING;
    n: INTEGER;
    wishers: WishersListPtr;
   END;
   
   doubleList = RECORD
   	first: AmazonPtr;
   	last: AmazonPtr;
   END;

  
PROCEDURE InitList(VAR l: doubleList);
BEGIN
  l.first := NIL;
  l.last := NIL;
END; 


FUNCTION NewWishNode (s: STRING): WishersNodePtr;
VAR
	node: WishersNodePtr;
	
BEGIN
	New(node);
		
		node^.name := s;
		node^.next := NIL;
		
  NewWishNode := node;
END;

PROCEDURE AppendItem (VAR list: WishersNodePtr; item: WishersNodePtr);
VAR
	itemlist : WishersNodePtr;
	
BEGIN
	IF list = NIL THEN
		list := item
	ELSE BEGIN
		list := itemlist;
	
		WHILE (itemlist^.next <> NIL) DO BEGIN
			itemlist := itemlist^.next;

			itemlist^.next := item;
		END;
	END;
END;

FUNCTION NewAmazonOrder (item, wisher: STRING): AmazonPtr;
VAR
	node: AmazonPtr;
BEGIN
	New(node);
	node^.prev := NIL;
	node^.next := NIL;
	node^.item := item;
	node^.n := 1;
	node^.wishers := NewWishNode(wisher);
	NewAmazonOrder := node;
END;


PROCEDURE AppendToAmazonOrderList (VAR orderlist: doubleList; item, wisher: STRING);
VAR
	firstPtr: AmazonPtr;
	
BEGIN

	firstPtr := orderlist.first;
	
	
	IF (orderlist.first =  NIL) THEN BEGIN
		firstPtr := NewAmazonOrder (item, wisher);
		orderlist.first := firstPtr;
		orderlist.last := firstPtr;
	END
		
	ELSE BEGIN
		
		WHILE (firstPtr^.next <> NIL) DO BEGIN
			IF (firstPtr^.item = item) THEN BEGIN
			AppendItem(firstPtr^.wishers, NewWishNode(wisher));
			firstPtr^.n := firstPtr^.n + 1;
			END
			ELSE BEGIN
				firstPtr := NewAmazonOrder(item, wisher);
				firstPtr^.prev := orderlist.last;
				orderlist.last^.next := firstPtr;
				orderlist.last := firstPtr;
			END;
		firstPtr := firstPtr^.next;
		END;
	END;
END;


PROCEDURE WriteWishersList (wishers: WishersNodePtr);
VAR
	x : WishersNodePtr;
BEGIN
	x := wishers;
	
	WHILE x <> NIL DO BEGIN
		WriteLn(x^.name);
		x := x^.next;
	END;
END;

PROCEDURE WriteOrderList(l: doubleList);
 VAR
  h : AmazonPtr;
  i : INTEGER;
 BEGIN
  h := l.first;
 	i := 1;
  
  WHILE h <> NIL DO BEGIN
  WriteLn(i, '.');
    WriteLn('Wish: ', h^.item,' ', 'quantity: ', h^.n);
    WriteLn('Wishers: ');
    WriteWishersList(h^.wishers);
   	i := i+1;
   	h := h^.next;  
  END;
END;
 
VAR
	wishesFile: TEXT;
	s, wisher: STRING;
	orderlist: doubleList;
	posi: INTEGER;

BEGIN 
	InitList(orderlist);
	WriteLn('XmasWishes: ');
	WriteLn();
	
	
	Assign(wishesFile, 'Wishes.txt');
  Reset(wishesFile);
 	InitList(orderlist);
 	
 REPEAT
  ReadLn(wishesFile, s);
  posi := POS(':', s);
  
  IF posi <> 0 THEN
  	wisher := Copy(s, 1, posi-1)
  
  ELSE
  	AppendToAmazonOrderlist(orderlist, s, wisher);
  
   
 UNTIL Eof(wishesFile);
 Close(wishesFile);
 
 	 WriteOrderList(orderlist);
END. 