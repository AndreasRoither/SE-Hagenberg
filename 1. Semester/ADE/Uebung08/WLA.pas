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


(*#########*)
(*  Wishes *)
(*#########*)

(* New WishNode Function *)
FUNCTION newWishNode(line : STRING): WishListPtr;
VAR node : WishNodePtr;
BEGIN
  New(node);
  node^.name := Copy(line,1,pos(':',line)-1);
  node^.item := Copy(line,pos(' ',line)+1,length(line));
  node^.next := NIL;
  newWishNode := node;
END;

(* Append to a Wish List*)
PROCEDURE appendToWishList(VAR list : WishNodePtr; element : WishNodePtr);
VAR wishList : WishNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE 
  BEGIN
    wishList := list;
    
    WHILE (wishList^.next <> NIL) DO
      wishList := wishList^.next;
      
    wishList^.next := element; 
  END;
END;

(* Write Wish List to Console *)
PROCEDURE writeWishList(wishList : WishNodePtr);
BEGIN
    WriteLn(chr(205),chr(205),chr(185),' Wish list: ',chr(204),chr(205),chr(205));  
        
    WHILE wishList <> NIL DO BEGIN
      Writeln(wishList^.name, ': ' , wishList^.item);
      wishList := wishList^.next;
    END;

    WriteLn(chr(205),chr(205),chr(188),' End Wish list: ',chr(200),chr(205),chr(205));  
    
END;

(*#########*)
(*  ORDER  *)
(*#########*)

(* New Order Node*)
FUNCTION newOrderNode(item : STRING; n : INTEGER): OrderNodePtr;
VAR node : OrderNodePtr;
BEGIN
  New(node);
  node^.item := item;
  node^.n := n;
  node^.next := NIL;
  NewOrderNode := node;
END;

(* Append to an Order List *)
PROCEDURE appendToOrder(VAR list : OrderNodePtr; element : OrderNodePtr);
VAR orderList : OrderNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE 
  BEGIN
    orderList := list;
    
    WHILE (orderList^.next <> NIL) DO
      orderList := orderList^.next;
      
    orderList^.next := element; 
  END;
END;

(* Increase the number of items per order *)
PROCEDURE increaseOrder(VAR list : OrderNodePtr; item : STRING);
VAR temp_orderlist : OrderNodePtr;
BEGIN
  IF list = NIL THEN appendToOrder(list, newOrderNode(item, 1)) ELSE 
  BEGIN

    temp_orderlist := list;
    WHILE(temp_orderlist <> NIL) DO
    BEGIN
    
      IF(temp_orderlist^.item = item) THEN 
      BEGIN
        temp_orderlist^.n := temp_orderlist^.n + 1;
        exit;
      END;
      
      temp_orderlist := temp_orderlist^.next;
    END;
    
    appendToOrder(list, newOrderNode(item, 1));
  END;
END;


(* Generate Order List from Wish List*)
FUNCTION orderListOf(wishlist : WishNodePtr): OrderNodePtr;
VAR result : OrderNodePtr;
BEGIN
  result := NIL;
  WHILE wishlist <> NIL DO BEGIN
      increaseOrder(result, wishlist^.item);
      wishlist := wishlist^.next;
  END;
  OrderListOf := result;
END;

(* Write OrderList to Console *)
PROCEDURE writeOrderList(list : OrderNodePtr);
BEGIN
    WriteLn(chr(205),chr(205),chr(185),' Order list: ',chr(204),chr(205),chr(205));  
        
    WHILE list <> NIL DO BEGIN
      Writeln(list^.item, ': ' , list^.n);
      list := list^.next;
    END;
      
    WriteLn(chr(205),chr(205),chr(188),' End Order list: ',chr(200),chr(205),chr(205));  
END;


(*#########*)
(*  Items  *)
(*#########*)

(* New Item Node *)
FUNCTION newItemNode(item : STRING): ItemNodePrt;
VAR node : ItemNodePrt;
BEGIN
  New(node);
  node^.item := item;
  node^.next := NIL;
  NewItemNode := node;
END;

(* Append To Item List *)
PROCEDURE appendItem(VAR list : ItemNodePrt; element : ItemNodePrt);
VAR tmp : ItemNodePrt;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(*############*)
(*  Delivery  *)
(*############*)

(* Get New DeliveryList *)
FUNCTION newDelivNode(name,item : STRING): DelivNodePtr;
VAR node : DelivNodePtr;
BEGIN
  New(node);
  node^.name := name;
  node^.items := NewItemNode(item);
  node^.next := NIL;
  NewDelivNode := node;
END;

(* Append to a Deliverylist *)
PROCEDURE appendToDelivery(VAR list : DelivNodePtr; element : DelivNodePtr);
VAR tmp : DelivNodePtr;
BEGIN
  IF list = NIL THEN list := element ELSE BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Append Item to Kids Item List *)
PROCEDURE appendItemForKid(VAR list : DelivNodePtr; name, item : STRING);
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
    
    appendToDelivery(list, NewDelivNode(name, item));
  END;
END;

(* Genereate Delivery based on wish list *)
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

(* Write Delivery List *)
PROCEDURE writeDelivList(list : DelivListPtr);
VAR citem: ItemNodePrt;
BEGIN
  WriteLn(chr(205),chr(205),chr(185),' Delv list: ',chr(204),chr(205),chr(205));
        
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
      
    WriteLn(chr(205),chr(205),chr(188),' End Delv list: ',chr(200),chr(205),chr(205)); 
END;

  VAR
    wishesFile: TEXT;
    s: STRING;
    wish_list : WishNodePtr;
    order_list : OrderNodePtr;
    delv_list : DelivNodePtr;

BEGIN (*WLA*)

  Assign(wishesFile, 'Wishes.txt');
  Reset(wishesFile);
  REPEAT
    ReadLn(wishesFile, s);
    appendToWishList(wish_list,newWishNode(s));
    
  UNTIL Eof(wishesFile);
  Close(wishesFile);

  writeWishList(wish_list);
  WriteLn;

  (* Generating an printing OrderList *)
  order_list := OrderListOf(wish_list);
  writeOrderList(order_list);
  WriteLn;
 
  (* Generating an printing DeliveryList *)
  delv_list := DeliveryListOf(wish_list);
  writeDelivList(delv_list);

END. (*WLA*)