program spannweite;
var a, b ,c , lowest, mid, highest: Integer;
begin
  Write('-- Zahlen Sortierung --', #13#10 ,'Zahl eingeben: ');
  Read(a);
  Write(#13);
  lowest := a;
  mid := 0;
  highest := 0;
  Write('Zahl eingeben: ');
  Read(b);
  Write(#13);
  Write('Zahl eingeben: ');
  Read(c);
  
  if b < lowest then
  begin
    mid := lowest;
    lowest := b;
  end
  else
    mid := b;
  
  if c >= mid then
    highest := c
  else if (c < mid) And (c >= lowest) then
  begin
    highest := mid;
    mid := c;
  end
  else if c < lowest then
  begin
    highest := mid;
    mid := lowest;
    lowest := c;
  end;
  
  Write('Zahlen aufsteigend sortiert: ' , lowest, ' ' , mid, ' ', highest);
  Write(#13#10);
end.