program maxof2or3;

function Max2(i1, i2 : Integer) : Integer;
begin
  if i1 > i2 then Max2 := i1 else Max2 := i2
end;

function Max3a(i1, i2, i3 : Integer) : Integer;
var temp : Integer;
begin
  if i1 > i2 then temp := i1 else temp := i2;
  if temp > i3 then Max3a := temp else Max3a := i3;
end;

function Max3b(i1, i2, i3 : Integer) : Integer;
var temp : Integer;
begin
  temp := Max2(i1, i2);
  if temp > i3 then Max3b := temp else Max3b := i3;
end;

begin
  WriteLn('-- Maxof2or3 --');
  WriteLn('Max2(1,2)   : Maximum ist ', Max2(1,2));
  WriteLn('Max3a(3,2,1): Maximum ist ', Max3a(3,2,1));
  WriteLn('Max3b(1,2,3): Maximum ist ', Max3b(1,2,3));
end.  