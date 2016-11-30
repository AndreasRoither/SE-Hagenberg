FUNCTION isPlausible(h, min : INTEGER; temp : REAL) : BOOLEAN;
  static lastTime : INTEGER = 0;
  static lastTemp : Real = 0;
  VAR diff_time : INTEGER;
  VAR diff_temp : REAL;
BEGIN

  diff_time := (h*60 +min) - lastTime;
  diff_temp := temp - lastTemp;
  
  IF(temp < 936,8) OR (temp > 1345,3) OR ((11,45 / 60) * diff_time > abs(diff_temp)) THEN 
    isPlausible := False;
  ELSE THEN
    isPlausible := True;
  lastTime := (h*60 + minute);
  lastTemp := temp;
END;
