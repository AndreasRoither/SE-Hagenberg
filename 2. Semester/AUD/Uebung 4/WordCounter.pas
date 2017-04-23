(* WordCounter:                                  HDO, 2003-02-28 *)
(* -----------                                                   *)
(* Template for programs that count words in text files.         *)
(*===============================================================*)
PROGRAM WordCounter;

  USES
    WinCrt, Timer, WordReader;

  VAR
    w: Word;
    n: LONGINT;

BEGIN (*WordCounter*)
  WriteLn('WordCounter:');
  OpenFile('Kafka.txt', toLower);
  StartTimer;
  n := 0;
  ReadWord(w);
  WHILE w <> '' DO BEGIN
    n := n + 1;
    (*insert word in data structure and count its occurence*)
    ReadWord(w);
  END; (*WHILE*)
  StopTimer;
  CloseFile;
  WriteLn('number of words: ', n);
  WriteLn('elapsed time:    ', ElapsedTime);
  (*search in data structure for word with max. occurrence*)

END. (*WordCounter*)