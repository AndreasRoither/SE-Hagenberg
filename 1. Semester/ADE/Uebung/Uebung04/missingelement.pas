program missingelement;

const
 max = 6;

type
 IntArray = array [1 .. max] OF integer;

function  MissingElement(a: IntArray; n: integer): integer;
var i, array_sum, check_sum : integer;
begin
    check_sum := 0;
    array_sum := 0;

    (*Summe aus array bilden mit einer check summe*)
    for i := 1 to Length(a) do
    begin
      check_sum := check_sum + i;
      array_sum := array_sum + a[i];
    end;
    
    (*check_sum - array_sum ergibt das fehlende Element*)
    check_sum := check_sum + i+1;
    MissingElement := (check_sum - array_sum);
end;

var test_array : IntArray = (5,4,2,1,3,6);
var test_array2: IntArray = (1,3,5,4,6,7);
var i : Integer;
begin
    WriteLn('-- MissingElement --');
    Write('Array: ');
    for i := 1 to Length(test_array) do
      Write(test_array[i],' ');

    WriteLn(#13#10,'MissingElement: ',MissingElement(test_array, max));

    Write('Array: ');
    for i := 1 to Length(test_array2) do
      Write(test_array2[i],' ');
    WriteLn(#13#10,'MissingElement: ',MissingElement(test_array2, max));
end.  