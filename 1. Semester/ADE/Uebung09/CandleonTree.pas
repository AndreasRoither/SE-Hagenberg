PROGRAM CandleonTree;
USES Math;

(* recursive *)
FUNCTION Candles(h: INTEGER) : INTEGER;
BEGIN
  IF h = 1 THEN Candles := 1 Else Candles := 3**(h-1) + Candles(h-1);
End;

(* iterative *)
FUNCTION Candles_Iterative(h : INTEGER) : INTEGER;
VAR candles : INTEGER;
BEGIN
  candles := 0;
  
  WHILE h > 1 DO
  BEGIN
    h := h - 1;
    candles := candles + 3**(h);
  END;

  Candles_Iterative := candles + 1;

END;

VAR result, result_it : INTEGER;
BEGIN
  WriteLn(chr(205),chr(205),chr(185),' Candles on XMas Tree ',chr(204),chr(205),chr(205));   

  result := Candles(1);
  result_it := Candles_Iterative(1);
  WriteLn('Candles with height 1: ',result, ' Iterative: ', result_it);
  
  result := Candles(2);
  result_it := Candles_Iterative(2);
  WriteLn('Candles with height 2: ',result, ' Iterative: ', result_it);
  
  result := Candles(3);
  result_it := Candles_Iterative(3);
  WriteLn('Candles with height 3: ',result, ' Iterative: ', result_it);
  
  result := Candles(4);
  result_it := Candles_Iterative(4);
  WriteLn('Candles with height 4: ',result, ' Iterative: ', result_it);
  
  result := Candles(5);
  result_it := Candles_Iterative(5);
  WriteLn('Candles with height 5: ',result, ' Iterative: ', result_it);

  result := Candles(6);
  result_it := Candles_Iterative(6);
  WriteLn('Candles with height 6: ',result, ' Iterative: ', result_it);
END.