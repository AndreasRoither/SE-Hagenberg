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

    ItemNodePrt = ^ItemNode;
    ItemNode = RECORD
      next : ItemNodePrt;
      item : STRING;
    END;
     

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

  VAR
    wishesFile: TEXT;
    s: STRING;
    wish_list : WishNodePtr;

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

END. (*WLA*)