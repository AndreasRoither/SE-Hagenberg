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
PROCEDURE appendToWishList(VAR list : WishNodePtr; node : WishNodePtr);
VAR wishList : WishNodePtr;
BEGIN
  IF list = NIL THEN list := node 
  ELSE 
  BEGIN
    wishList := list;
    
    WHILE (wishList^.next <> NIL) DO
      wishList := wishList^.next;
      
    wishList^.next := node; 
  END;
END;

(*#########*)
(*  ORDER  *)
(*#########*)

(* New Order Node*)
FUNCTION newOrderNode(item : STRING; anz : INTEGER): OrderNodePtr;
VAR node : OrderNodePtr;
BEGIN
  New(node);
  node^.item := item;
  node^.n := anz;
  node^.next := NIL;
  NewOrderNode := node;
END;

(* Append to an Order List *)
PROCEDURE appendToOrder(VAR list : OrderNodePtr; node : OrderNodePtr);
VAR orderList : OrderNodePtr;
BEGIN
  IF list = NIL THEN list := node 
  ELSE 
  BEGIN
    orderList := list;
    
    WHILE (orderList^.next <> NIL) DO
      orderList := orderList^.next;
      
    orderList^.next := node; 
  END;
END;

(* Increase the number of items per order *)
PROCEDURE increaseOrder(VAR list : OrderNodePtr; s_item : STRING);
VAR temp_orderlist : OrderNodePtr;
BEGIN
  IF list = NIL THEN appendToOrder(list, newOrderNode(s_item, 1)) 
  ELSE 
  BEGIN

    temp_orderlist := list;
    WHILE(temp_orderlist <> NIL) DO
    BEGIN
    
      IF(temp_orderlist^.item = s_item) THEN 
      BEGIN
        temp_orderlist^.n := temp_orderlist^.n + 1;
        exit;
      END;
      
      temp_orderlist := temp_orderlist^.next;
    END;
    
    appendToOrder(list, newOrderNode(s_item, 1));
  END;
END;

(* Generate Order List from Wish List*)
FUNCTION orderListOf(wishlist : WishNodePtr): OrderNodePtr;
VAR result : OrderNodePtr;
BEGIN
  result := NIL;
  WHILE wishlist <> NIL DO 
  BEGIN
      increaseOrder(result, wishlist^.item);
      wishlist := wishlist^.next;
  END;
  orderListOf := result;
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
  newItemNode := node;
END;

(* Append To Item List *)
PROCEDURE appendItem(VAR list : ItemNodePrt; element : ItemNodePrt);
VAR tmp : ItemNodePrt;
BEGIN
  IF list = NIL THEN list := element 
  ELSE 
  BEGIN
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
  IF list = NIL THEN list := element ELSE 
  BEGIN
    tmp := list;
    
    WHILE (tmp^.next <> NIL) DO
      tmp := tmp^.next;
      
    tmp^.next := element; 
  END;
END;

(* Append Item to Kids Item List *)
PROCEDURE appendItemKid(VAR list : DelivNodePtr; name, item : STRING);
VAR tmp : DelivNodePtr;
BEGIN
  IF list = NIL THEN list := NewDelivNode(name, item) 
  ELSE 
  BEGIN
  
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
FUNCTION DeliveryListOf(wishlist : WishNodePtr): DelivNodePtr;
VAR result : DelivNodePtr;
BEGIN
  result := NIL;
  WHILE wishlist <> NIL DO BEGIN
      AppendItemKid(result, wishlist^.name, wishlist^.item);
      wishlist := wishlist^.next;
  END;
  DeliveryListOf := result;
END;

(*#######################*)
(*  Printing to Console  *)
(*#######################*)

(* Write Wish List to Console *)
PROCEDURE writeWishList(wishList : WishNodePtr);
BEGIN
    WriteLn(chr(205),chr(205),' Wish list ',chr(205),chr(205));  
        
    WHILE wishList <> NIL DO 
    BEGIN
      Writeln(wishList^.name, ' : ' , wishList^.item);
      wishList := wishList^.next;
    END;

    WriteLn(chr(205),chr(205),' End Wish list ',chr(205),chr(205));    
END;

(* Write OrderList to Console *)
PROCEDURE writeOrderList(list : OrderNodePtr);
BEGIN
    WriteLn(chr(205),chr(205),' Order list ',chr(205),chr(205));  
        
    WHILE list <> NIL DO 
    BEGIN
      Writeln(list^.item, ' : ' , list^.n);
      list := list^.next;
    END;
      
    WriteLn(chr(205),chr(205),' End Order list ',chr(205),chr(205));  
END;

(* Write Delivery List *)
PROCEDURE writeDelivList(list : DelivListPtr);
VAR citem: ItemNodePrt;
BEGIN
  WriteLn(chr(205),chr(205),' Delv list ',chr(205),chr(205));
        
    WHILE list <> NIL DO BEGIN
      Write(list^.name, ' : ');
      citem := list^.items;
      
      WHILE citem <> NIL DO BEGIN
        write(citem^.item, ' ');
        citem := citem^.next;
      END;
      writeln();
      list := list^.next;
    END;
      
    WriteLn(chr(205),chr(205),' End Delv list ',chr(205),chr(205)); 
END;

  VAR
    wishesFile: TEXT;
    s: STRING;
    wish_list : WishNodePtr;
    order_list : OrderNodePtr;
    delv_list : DelivNodePtr;

BEGIN (*WLA*)

  WriteLn(chr(205),chr(205),chr(185),' Lists for Xmas ',chr(204),chr(205),chr(205));  
  WriteLn;
  
  (* Read everyline from txt, appendtowishlist and close file *)
  Assign(wishesFile, 'Wishes.txt');
  Reset(wishesFile);
  
  REPEAT
    ReadLn(wishesFile, s);
    appendToWishList(wish_list,newWishNode(s));    
  UNTIL Eof(wishesFile);
  Close(wishesFile);

  (* Write wishlist to console *)
  writeWishList(wish_list);
  WriteLn;

  (* Generating & Writing OrderList to Console *)
  order_list := orderListOf(wish_list);
  writeOrderList(order_list);
  WriteLn;
 
  (* Generating & Writing DeliveryList to Console *)
  delv_list := DeliveryListOf(wish_list);
  writeDelivList(delv_list);

END. (*WLA*)