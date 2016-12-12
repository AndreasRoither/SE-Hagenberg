PROGRAM WLA;

(*$IFDEF WINDOWS*)
  USES
    WinCrt;
(*$ENDIF*)

  TYPE

    WishNodePtr = ^WishNode;
    WishNode = RECORD
      next: WishNodePtr;
      name: STRING;
      item: STRING;
    END; (*RECORD*)
    WishListPtr = WishNodePtr;

    OrderNodePtr = ^OrderNode;
    OrderNode= RECORD
      next: OrderNodePtr;
      item: STRING;
      n: INTEGER;
    END; (*RECORD*)
    OrderList = OrderNode;

    ItemNodePrt = ^ItemNode;
    ItemNode = RECORD
      next : ItemNodePrt;
      item : STRING;
    END;

    DelivNodePtr = ^DelivNode;
    DelivNode = RECORD
      next: DelivNodePtr;
      name: STRING;
      items: ItemNodePrt;
    END; (*RECORD*)
    DelivListPtr = DelivNodePtr;

(* Function to get a new WishNode *)
FUNCTION NewWishNode(line : STRING): WishListPtr;
VAR n : WishNodePtr;
BEGIN
  New(n);
  n^.next := NIL;
  n^.name := Copy(line,1,pos(':',line)-1);
  n^.item := Copy(line,pos(' ',line)+1,length(line));
  NewWishNode := n;
END;

(* Proc to append a WishNode *)
PROCEDURE AppendWish(VAR list : WishNodePtr; element : WishNodePtr);
VAR tmp : WishNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Proc to print wish lists *)
PROCEDURE PrintWishList(list : WishNodePtr);
BEGIN
    Writeln('##### Wish list: #####');
        
    WHILE list <> NIL DO BEGIN
      Writeln(list^.name, ': ' , list^.item);
      list := list^.next;
    END;
      
    Writeln('##### End of Wish list: #####');
END;

(* Function to get a new order node *)
FUNCTION NewOrderNode(item : STRING; n : INTEGER): OrderNodePtr;
VAR node : OrderNodePtr;
BEGIN
  New(node);
  node^.item := item;
  node^.n := n;
  node^.next := NIL;
  NewOrderNode := node;
END;

(* Proc to append an order node *)
PROCEDURE AppendOrder(VAR list : OrderNodePtr; element : OrderNodePtr);
VAR tmp : OrderNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Proc to increment the number of items per order *)
PROCEDURE IncrementOrder(VAR list : OrderNodePtr; item : STRING);
VAR tmp : OrderNodePtr;
BEGIN
  IF list = NIL THEN AppendOrder(list, NewOrderNode(item, 1)) ELSE BEGIN
  
    tmp := list;
    WHILE(tmp <> NIL) DO BEGIN
      
      IF(tmp^.item = item) THEN BEGIN
        tmp^.n := tmp^.n + 1;
        exit;
      END;
      
      tmp := tmp^.next;
    END;
    
    AppendOrder(list, NewOrderNode(item, 1));
  END;
END;

(* Function to generate an order list from a wish list *)
FUNCTION OrderListOf(wlist : WishNodePtr): OrderNodePtr;
VAR result : OrderNodePtr;
BEGIN
  result := NIL;
  WHILE wlist <> NIL DO BEGIN
      IncrementOrder(result, wlist^.item);
      wlist := wlist^.next;
  END;
  OrderListOf := result;
END;

(* Proc to print order lists *)
PROCEDURE PrintOrderList(list : OrderNodePtr);
BEGIN
    Writeln('##### Order list: #####');
        
    WHILE list <> NIL DO BEGIN
      Writeln(list^.item, ': ' , list^.n);
      list := list^.next;
    END;
      
    Writeln('##### End of Order list: #####');
END;

(* Function to get a new item node *)
FUNCTION NewItemNode(item : STRING): ItemNodePrt;
VAR node : ItemNodePrt;
BEGIN
  New(node);
  node^.item := item;
  node^.next := NIL;
  NewItemNode := node;
END;

(* Proc to append an item node *)
PROCEDURE AppendItem(VAR list : ItemNodePrt; element : ItemNodePrt);
VAR tmp : ItemNodePrt;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Function to get a new delivery node *)
FUNCTION NewDelivNode(name,item : STRING): DelivNodePtr;
VAR node : DelivNodePtr;
BEGIN
  New(node);
  node^.name := name;
  node^.items := NewItemNode(item);
  node^.next := NIL;
  NewDelivNode := node;
END;

(* Proc to append a delivery node *)
PROCEDURE AppendDelivery(VAR list : DelivNodePtr; element : DelivNodePtr);
VAR tmp : DelivNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Proc to append an item to the kids item list *)
PROCEDURE AppendItemForKid(VAR list : DelivNodePtr; name, item : STRING);
VAR tmp : DelivNodePtr;
BEGIN
  IF list = NIL THEN BEGIN list := NewDelivNode(name, item);  END ELSE BEGIN
  
    tmp := list;
    WHILE tmp <> NIL DO BEGIN
      IF tmp^.name = name THEN BEGIN
        AppendItem(tmp^.items, NewItemNode(item));
        exit;
      END;
      tmp := tmp^.next;
    END;
    
    AppendDelivery(list, NewDelivNode(name, item));
  END;
END;

(* Function to generate the delivery list based on the wish list *)
FUNCTION DeliveryListOf(wlist : WishNodePtr): DelivNodePtr;
VAR result : DelivNodePtr;
BEGIN
  result := NIL;
  WHILE wlist <> NIL DO BEGIN
      AppendItemForKid(result, wlist^.name, wlist^.item);
      wlist := wlist^.next;
  END;
  DeliveryListOf := result;
END;

(* Proc to print delivery lists *)
PROCEDURE PrintDelivList(list : DelivListPtr);
VAR citem: ItemNodePrt;
BEGIN
  Writeln('##### Delivery list: #####');
        
    WHILE list <> NIL DO BEGIN
      Write(list^.name, ': ');
      citem := list^.items;
      
      WHILE citem <> NIL DO BEGIN
        write(citem^.item, ' ');
        citem := citem^.next;
      END;
      writeln();
      list := list^.next;
    END;
      
    Writeln('##### End of Delivery list: #####');
    
END;

  VAR
    wishesFile: TEXT;
    s: STRING;
    wishlist : WishNodePtr;
    olist : OrderNodePtr;
    dlist : DelivNodePtr;

BEGIN (*WLA*)

  Assign(wishesFile, 'Wishes.txt');
  Reset(wishesFile);
  REPEAT
    ReadLn(wishesFile, s);
    
   (* Generating WishList *)
   AppendWish(wishlist,NewWishNode(s));
    
  UNTIL Eof(wishesFile);
  Close(wishesFile);
  
    (* Printing WishList *)

  PrintWishList(wishlist);

  (* Generating an printing OrderList *)
  olist := OrderListOf(wishlist);
  PrintOrderList(olist);
 
  (* Generating an printing DeliveryList *)
  dlist := DeliveryListOf(wishlist);
  PrintDelivList(dlist);

END.
