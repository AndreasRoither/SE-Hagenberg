program swap;

var a_i, b_i : Integer;
var a_r, b_r : Real;

(*procedure mit call by reference mit Integer als Datentyp*)
procedure swapInt(var i1, i2 : Integer);
var temp_i : Integer;
begin
  temp_i := i1;
  i1 := i2;
  i2 := temp_i;
end;

(*procedure mit call by reference mit Real als Datentyp*)
procedure swapReal(var r1, r2 : Real);
var temp_r : Real;
begin
  temp_r := r1;
  r1 := r2;
  r2 := temp_r;
end;
begin
  a_i := 1;
  b_i := 2;
  a_r := 1;
  b_r := 2;
  
  WriteLn('-- Vertauschungsprozedur --',#13#10,'Variable a_i (Integer): ',a_i,' Variable b_i (Integer): ',b_i); 
  swapint(a_i,b_i);
  WriteLn('Getauscht:',#13#10,'Variable a_i (Integer): ',a_i,' Variable b_i (Integer): ',b_i,#13#10); 
  
  (*:2:2 zur limitierung der angezeigten Stellen auf zwei vor und -nachkomma Stellen*)
  WriteLn('Variable a_r (Real): ',a_r:2:2,' Variable b_r (Real): ',b_r:2:2); 
  swapreal(a_r,b_r);
  WriteLn('Getauscht:',#13#10,'Variable a_r (Real): ',a_r:2:2,' Variable b_r (Real): ',b_r:2:2); 
end.