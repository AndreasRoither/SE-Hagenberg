(* ========================================== *)
(* --          SOS TEST 27.05.17           -- *)
(* ========================================== *)

PROGRAM SOSTest;
  USES SOSU;

  VAR
    s, s1, s2, s3: SOSPtr;
BEGIN
  WriteLn('=== SOSTest ===');

  New(s, Init);
  New(s1, Init);
  New(s2, Init);

  s^.Add('Hallo');
  s^.Add('ich');

  s1^.Add('Hallo');
  s1^.Add('ich');
  s1^.Add('bin');
  s1^.Add('eine');
  s1^.Add('Unit');

  s2^.Add('Hallo');
  s2^.Add('its');
  s2^.Add('me');
  s2^.Add('bin');
  s2^.Add('Unit');

  (* Cardinality Test *)
  WriteLn;
  WriteLn('Cardinality s1: ', s1^.Cardinality);
  WriteLn('Cardinality s2: ', s2^.Cardinality);
  WriteLn;

  (* Successful union *)
  WriteLn('-- Union --');
  s3 := s1^.Union(s2);
  s3^.Print();
  s3^.Remove('Hallo');
  WriteLn('-- Removed Hallo --');
  s3^.Print();

  (* unsuccessful union *)
  WriteLn;
  s2^.Add('T');
  s2^.Add('T2');
  s2^.Add('T3');
  s2^.Add('T4');
  s2^.Add('T5');
  s2^.Add('T6');
  s3 := s1^.Union(s2);
  s3^.Print();

  (* Difference Test *)
  WriteLn('-- Difference --');
  s3 := s1^.Difference(s2);
  s3^.Print();
  WriteLn;

  (* Intersection Test *)
  WriteLn('-- Intersection --');
  s3 := s1^.Intersection(s2);
  s3^.Print();
  WriteLn;

  (* Subset Test, first true, second false *)
  WriteLn('-- Subset --');
  IF s^.Subset(s1) THEN WriteLn('s is a subset from s1')
  ELSE WriteLn('s is not a subset from s1');
  s^.Add('TTTTTT');
  WriteLn('Added Element TTTTTT to s (Not in s1)');
  IF s^.Subset(s1) THEN WriteLn('s is a subset from s1')
  ELSE WriteLn('s is not a subset from s1');
  WriteLn;

  Dispose(s, Done);
  Dispose(s1, Done);
  Dispose(s2, Done);
  Dispose(s3, Done);
END.