program convert;

var b7,b6,b5,b4,b3,b2,b1,b0: Boolean;
var d : integer;

(*procedure mit call by reference*)
procedure Convert2Binary(d : Integer; var b7,b6,b5,b4,b3,b2,b1,b0: Boolean );
var count : Integer;
var result : Boolean;

begin
  count := 0;
   
  while d > 0 do 
  begin
    
    if d mod 2 > 0 then
      result := True
    else
      result := False;

    (*b7 bis b1 auf True oder False setzen*)
    case count of
      0: b0 := result;
      1: b1 := result;
      2: b2 := result;
      3: b3 := result;
      4: b4 := result;
      5: b5 := result;
      6: b6 := result;
      7: b7 := result;
    end;
    
    (*Zahl verkleinern für die nächste Iteration*)
    d := d DIV 2;
    count := count +1;
  end;
end;
begin
  WriteLn('-- Convert2Binary --');
  Write('Zahl: ');
  Read(d);
  if(d <= 255) and (d >= 0) then begin
    Convert2Binary(d,b7,b6,b5,b4,b3,b2,b1,b0);  
    WriteLn('Dezimal: ',d,' Binaer: ',b7,' ',b6,' ',b5,' ',b4,' ',b3,' ',b2,' ',b1,' ',b0,' ');
  end
  else
    WriteLn('Falsche Eingabe');
end.  