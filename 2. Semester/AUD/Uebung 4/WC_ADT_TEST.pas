(* WC_ADT_TEST            23.04.2017 *)
(* Container for strings             *)
(* Hidden data test                  *)

PROGRAM WC_ADT_Test;

  USES WC_ADT;
  
  VAR f1: POINTER;
BEGIN
  InitTree(f1);
  
  (* test cases *)
  WriteLn('== WC_ADT_Test ==');
  WriteLn('Empty Test: ', IsEmpty(f1));
  WriteLn('Inserted Test');
  Insert(f1,'Test');
  
  WriteLn('Inserted Hallo');
  Insert(f1,'Hallo');

  WriteLn('Empty Test: ', IsEmpty(f1));
  WriteLn('Contains Test: ', Contains(f1,'Test'));
  WriteLn('Contains Hallo: ', Contains(f1,'Hallo'));
  
  WriteLn('Inserted Hallo');
  Insert(f1,'Hallo');
  Remove(f1,'Hallo');
  WriteLn('Contains Hallo: ', Contains(f1,'Hallo'));
  WriteLn('Duplicate texts are not saved.');

  DisposeTree(f1);
END.
