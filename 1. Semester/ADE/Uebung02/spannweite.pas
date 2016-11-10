program spannweite;
var min, max, val, spanwidth : Integer;
begin
  Write('Spannweiten Berechnung', #13#10 ,'Zahl eingeben: ');
  Read(val);
  Write(#13);
  if val > 0 then
  begin
    min := val;
    max := val;
    repeat
      Write('Zahl eingeben: ');
      Read(val);
      Write(#13);
      if val > 0 then
        begin
          if val >= max then
            max := val
          else if val < min then
            min := val;
        end
    until val <= 0;

  if max = min then
    Write('Spannweite: 0', #13#10)
  else
  begin
    spanwidth := max -min;
    Write('Spannweite: ', spanwidth, #13#10);
  end
  end
  else
    Write('Spannweite: 0',#13#10);
end.