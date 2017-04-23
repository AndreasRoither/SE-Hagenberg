(* WS_ADT_TEST            23.04.2017 *)
(* Container for strings             *)
(* Hidden data test                  *)

PROGRAM WS_ADT_TEST;

  USES WS_ADT, WordReader;
  
  (* Load words from files 
     uses WordReader unit *)
  PROCEDURE LoadFromFile(source: STRING; VAR ws: POINTER);
  VAR word: STRING;
  BEGIN
    InitTree(ws);
    word := '';
    
    OpenFile(source, noConversion);
    ReadWord(word);
    
    (* ReadWord returns '' if EOF *)
    WHILE(word <> '') DO BEGIN
      Insert(ws,word);
      ReadWord(word);
    END;
    CloseFile;
  END;

  (* since WordSet is hidden, POINTER is used
     WS_ADT interprets it internally as WordSet *)
   VAR f1, f2 ,f3, f4 : POINTER;
BEGIN
  
  (* Load files *)
  LoadFromFile('gruene.txt', f1);
  LoadFromFile('oevp.txt', f2);
  LoadFromFile('fpoe.txt', f3);
  LoadFromFile('spoe.txt', f4);
  
  (* file input cardinality *)
  WriteLn('== WS_ADT_Test ==');
  WriteLn('- Input cardinality -');
  WriteLn(#9,'gruene: ', #9, Cardinality(f1));
  WriteLn(#9,'oevp: ', #9#9, Cardinality(f2));
  WriteLn(#9,'fpoe: ', #9#9, Cardinality(f3));
  WriteLn(#9,'spoe: ', #9#9, Cardinality(f4));
  
  (* file input cardinality with union *)
  WriteLn(#13#10,'- Input Union cardinality -');
  WriteLn(#9,'spoe + oevp: ', #9, Cardinality(Union(f4,f2)));
  WriteLn(#9,'gruene + oevp: ', #9, Cardinality(Union(f1,f2)));
  WriteLn(#9,'oevp + fpoe: ', #9, Cardinality(Union(f2,f3)));
  WriteLn(#9,'fpoe + spoe: ', #9, Cardinality(Union(f3,f4)));
  WriteLn(#9,'spoe + gruene: ', #9, Cardinality(Union(f4,f1)));
  
  (* file input cardinality with intersection *)
  WriteLn(#13#10,'- Input Intersection cardinality -');
  WriteLn(#9,'spoe + oevp: ', #9, Cardinality(Intersection(f4,f2)));
  WriteLn(#9,'gruene + oevp: ', #9, Cardinality(Intersection(f1,f2)));
  WriteLn(#9,'oevp + fpoe: ', #9, Cardinality(Intersection(f2,f3)));
  WriteLn(#9,'fpoe + spoe: ', #9, Cardinality(Intersection(f3,f4)));
  WriteLn(#9,'spoe + gruene: ', #9, Cardinality(Intersection(f4,f1)));
  
  (* file input cardinality with difference *)
  WriteLn(#13#10,'- Input Difference cardinality -');
  WriteLn(#9,'spoe + oevp: ', #9, Cardinality(Difference(f4,f2)));
  WriteLn(#9,'gruene + oevp: ', #9, Cardinality(Difference(f1,f2)));
  WriteLn(#9,'oevp + fpoe: ', #9, Cardinality(Difference(f2,f3)));
  WriteLn(#9,'fpoe + spoe: ', #9, Cardinality(Difference(f3,f4)));
  WriteLn(#9,'spoe + gruene: ', #9, Cardinality(Difference(f4,f1)));
  
  DisposeWs(f1);
  DisposeWs(f2);
  DisposeWs(f3);
  DisposeWs(f4);
  
END.