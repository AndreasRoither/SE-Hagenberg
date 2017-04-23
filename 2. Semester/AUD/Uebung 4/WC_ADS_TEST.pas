(* WC_ADT_TEST            23.04.2017 *)
(* Container for strings             *)

PROGRAM WC_ADS_Test;

  USES WC_ADS;
  
BEGIN
  (* test cases *)
  WriteLn('== WC_ADS_Test ==');
  WriteLn('Empty Test: ', IsEmpty());
  WriteLn('Inserted Test');
  Insert('Test');
  
  WriteLn('Inserted Hallo');
  Insert('Hallo');

  WriteLn('Empty Test: ', IsEmpty());
  WriteLn('Contains Test: ', Contains('Test'));
  WriteLn('Contains Hallo: ', Contains('Hallo'));
  
  WriteLn('Inserted Hallo');
  Insert('Hallo');
  Remove('Hallo');
  WriteLn('Contains Hallo: ', Contains('Hallo'));
  WriteLn('Duplicate texts are not saved.');

  DisposeTree;
END.
