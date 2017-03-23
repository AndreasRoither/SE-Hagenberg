(* Timer:                                       HDO, 2005-04-01
   -----
   Simple utility for run-time measurement.
===============================================================*)
UNIT Timer;

INTERFACE

  PROCEDURE StartTimer;
  PROCEDURE StopTimer;

  FUNCTION TimerIsRunning: BOOLEAN;

  FUNCTION Elapsed:      STRING;    (*same as ElapsedTime*)
  FUNCTION ElapsedTime:  STRING;    (*time format: mm:ss.th*)
  FUNCTION ElapsedSecs:  STRING;    (*secs format: sssss.th*)
  FUNCTION ElapsedTicks: LONGINT;   (*1 tick = 10 ms*)


IMPLEMENTATION

  USES
    {$IFDEF FPC}
      Dos;    (*for targets 'real mode' and 'protected mode'*)
    {$ELSE}
      {$IFDEF MSDOS}
        Dos;    (*for targets 'real mode' and 'protected mode'*)
      {$ENDIF}
      {$IFDEF WINDOWS}
        WinDos; (*for target 'windows'*)
      {$ENDIF}
    {$ENDIF}


  VAR
    running: BOOLEAN;
    startedAt, stoppedAt, ticksElapsed: LONGINT;


  PROCEDURE Assert(cond: BOOLEAN; msg: STRING);
  BEGIN
    IF NOT cond THEN BEGIN
      WriteLn('ERROR : ', msg);
      HALT;
    END; (*IF*)
  END; (*Assert*)

  PROCEDURE GetTicks(VAR ticks: LONGINT);
    VAR
      h, m, s, hs: WORD;
  BEGIN
    GetTime(h, m, s, hs);
    ticks := h     * 60 +  m;
    ticks := ticks * 60 +  s;
    ticks := ticks * 100 + hs;
  END; (*GetTicks*)

  FUNCTION DigitFor(n: INTEGER): CHAR;
  BEGIN
    Assert((n >= 0) AND (n <= 9), 'invalid digit value in DigitFor');
    DigitFor := CHR(ORD('0') + n);
  END; (*DigitFor*)


  (* StartTimer: start the timer
  -------------------------------------------------------------*)
  PROCEDURE StartTimer;
  BEGIN
    Assert(NOT running, 'StartTimer called while timer is running');
    GetTicks(startedAt);
    ticksElapsed := 0;
    running := TRUE;
  END; (*StartTimer*)


  (* StopTimer: stop the timer
  -------------------------------------------------------------*)
  PROCEDURE StopTimer;
  BEGIN
    Assert(running, 'StopTimer called when timer not running');
    GetTicks(stoppedAt);
    ticksElapsed := stoppedAt - startedAt;
    running := FALSE;
  END; (*StopTimer*)


  (* TimerIsrunning: is the timer running?
  -------------------------------------------------------------*)
  FUNCTION TimerIsRunning: BOOLEAN;
  BEGIN
    TimerIsRunning := running;
  END; (*TimerIsRunning*)


  (* Elapsed: same ElapsedTime
  -------------------------------------------------------------*)
  FUNCTION Elapsed: STRING;
  BEGIN
    Elapsed:= ElapsedTime;
  END; (*ElapsedTime*)


  (* ElapsedTime: return elapsed time in format "mm:ss.th"
  -------------------------------------------------------------*)
  FUNCTION ElapsedTime: STRING;
    VAR
      ticks: LONGINT;
      m, s, t, h: INTEGER;
      timeStr: STRING[8];
  BEGIN
    Assert(NOT running, 'ElapsedTime called while timer is running');
    ticks  := ticksElapsed;
    h      := ticks MOD 10;
    ticks  := ticks DIV 10;
    t      := ticks MOD 10;
    s      := ticks DIV 10;
    m      := s     DIV 60;
    s      := s     MOD 60;
              (*12345678*)
    timeStr := 'mm:ss.th';
    timeStr[1] := DigitFor(m DIV 10);
    timeStr[2] := DigitFor(m MOD 10);
    timeStr[4] := DigitFor(s DIV 10);
    timeStr[5] := DigitFor(s MOD 10);
    timeStr[7] := DigitFor(t);
    timeStr[8] := DigitFor(h);
    ElapsedTime := timeStr;
  END; (*ElapsedTime*)


  (* ElapsedSecs: return elapsed seconds in format "sssss.th"
  -------------------------------------------------------------*)
  FUNCTION ElapsedSecs: STRING;
    VAR
      ticks: REAL;
      secsStr: STRING[8];
  BEGIN
    Assert(NOT running, 'ElapsedSecs called while timer is running');
    ticks := elapsedTicks;
    Str((ticks / 100.0):8:2, secsStr);
    ElapsedSecs := secsStr;
  END; (*ElapsedSecs*)


  (* ElapsedTicks: return elapsed time in ticks
  -------------------------------------------------------------*)
  FUNCTION ElapsedTicks: LONGINT;
  BEGIN
    Assert(NOT running, 'ElapsedTicks called while timer is running');
    ElapsedTicks := ticksElapsed;
  END; (*ElapsedTicks*)


BEGIN (*Timer*)

  running :=FALSE;

END. (*Timer*)
