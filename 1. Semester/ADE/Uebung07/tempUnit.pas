UNIT tempUnit;

INTERFACE
  FUNCTION isPlausible_Unit(h, min : INTEGER; temp : REAL) : BOOLEAN;
 
IMPLEMENTATION
(*Globale Vraiblen in der UNIT*)
VAR lastTime : INTEGER;
VAR lastTemp : REAL;

FUNCTION isPlausible_Unit(h, min : INTEGER; temp : REAL) : BOOLEAN;
VAR diff_time : INTEGER;
VAR diff_temp : REAL;
BEGIN
  diff_time := ((h * 60) + min) - lastTime;
  diff_temp := temp - lastTemp;

  lastTime := (h * 60) + min;
  lastTemp := temp;

  isPlausible_Unit := True;

  IF (temp <936.8) OR (temp > 1345.3) OR ((11.45 * diff_time) <= abs(diff_temp)) THEN
  isPlausible_Unit := False;
END;
BEGIN
lastTime := 0;
lastTemp := 1000;
END.