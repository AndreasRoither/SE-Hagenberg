PROGRAM temp;

USES tempUnit;

VAR lastTime : INTEGER;
VAR lastTemp : REAL;

FUNCTION isPlausible_Global(h, min : INTEGER; temp : REAL) : BOOLEAN;
VAR diff_time : INTEGER;
VAR diff_temp : REAL;
BEGIN
  diff_time := ((h * 60) + min) - lastTime;
  diff_temp := temp - lastTemp;
  (*Globale Variablen muessen vorher einmal gesetzt werden*)
  lastTime := (h * 60) + min;
  lastTemp := temp;
  
  isPlausible_Global := True;
  
  IF (temp <936.8) OR (temp > 1345.3) OR ((11.45 * diff_time) <= abs(diff_temp)) THEN
    isPlausible_Global := False;
    
END;

FUNCTION isPlausible_Var(h, min : INTEGER; temp : REAL; VAR v_lastTime : INTEGER; VAR v_lastTemp : REAL) : BOOLEAN;
VAR diff_time : INTEGER;
VAR diff_temp : REAL;
BEGIN
  diff_time := ((h * 60) + min) - v_lastTime;
  diff_temp := temp - v_lastTemp;

  v_lastTime := (h * 60) + min;
  v_lastTemp := temp;

  isPlausible_Var := True;

  IF (temp <936.8) OR (temp > 1345.3) OR ((11.45 * diff_time) <= abs(diff_temp)) THEN
    isPlausible_Var := False;
END;

VAR v_lastTime : INTEGER;
VAR v_lastTemp : REAL;
BEGIN
  lastTime := 0;
  lastTemp := 1000;
  
  v_lastTime := 0;
  v_lastTemp := 1000;
  
  WriteLn(chr(205),chr(205),chr(185),' Temp Plausible ',chr(204),chr(205),chr(205));
  
  (*Globale variablen Test*)
  WriteLn('Global');
  WriteLn('Temp: 1h  0min, Temp:  999, Plausible: ', isPlausible_Global(1,0,999));
  WriteLn('Temp: 1h 10min, Temp: 1000, Plausible: ', isPlausible_Global(1,10,1000));
  WriteLn('Temp: 1h 20min, Temp: 1300, Plausible: ', isPlausible_Global(1,20,1300));
  WriteLn('Temp: 2h  0min, Temp:  600, Plausible: ', isPlausible_Global(2,0,600));
  WriteLn();
  
  (*Lokal variablen Test*)
  WriteLn('Lokal');
  WriteLn('Temp: 1h  0min, Temp:  999, Plausible: ', isPlausible_Var(1,0,999,v_lastTime,v_lastTemp));
  WriteLn('Temp: 1h 10min, Temp: 1000, Plausible: ', isPlausible_Var(1,10,1000,v_lastTime,v_lastTemp));
  WriteLn('Temp: 1h 20min, Temp: 1300, Plausible: ', isPlausible_Var(1,20,1300,v_lastTime,v_lastTemp));
  WriteLn('Temp: 2h  0min, Temp:  600, Plausible: ', isPlausible_Var(2,0,600,v_lastTime,v_lastTemp));
  WriteLn();
  
  (*UNIT*)
  WriteLn('Unit');
  WriteLn('Temp: 1h  0min, Temp:  999, Plausible: ', isPlausible_Unit(1,0,999));
  WriteLn('Temp: 1h 10min, Temp: 1000, Plausible: ', isPlausible_Unit(1,10,1000));
  WriteLn('Temp: 1h 20min, Temp: 1300, Plausible: ', isPlausible_Unit(1,20,1300));
  WriteLn('Temp: 2h  0min, Temp:  600, Plausible: ', isPlausible_Unit(2,0,600));
  
END.