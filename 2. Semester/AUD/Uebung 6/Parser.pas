(* Parser                             03.05.17 *)
(* Syntax Analysator (scanner) UE6             *)

UNIT Parser;
  INTERFACE
    
    VAR
      success: BOOLEAN;

    PROCEDURE S;
    PROCEDURE InitParser(outputFileName: STRING; ok: BOOLEAN);

  IMPLEMENTATION
    USES
      Lex;

    VAR
      outputFile : TEXT;
      tab : STRING;
    
    TYPE
      Mode = (printTitle, printHead, printEnd,
              printCurlyBegin, printCurlyEnd,
              printCompBegin, printOpt, printCompEnd,
              printIsNotSy, printNonTerminal, printTerminal);

    (* Init parser with the file to write to*)
    PROCEDURE InitParser(outputFileName: STRING; ok: BOOLEAN);
    BEGIN
      Assign(outputFile, outputFileName);
      {$I-}
      Rewrite(outputFile);
      {$I+}
      ok := IOResult = 0;
    END;

    (* tab control *)
    PROCEDURE IncTab;
    BEGIN
      tab := tab + '  ';
    END;

    PROCEDURE DecTab;
    BEGIN
      Delete(tab, Length(tab)-1, 2);
    END;


    (* Check sy;
       returns false if sy is not expected sy *)
    FUNCTION SyIsNot(expectedSy: SymbolCode): BOOLEAN;
    BEGIN
      success := success AND (sy = expectedSy);
      SyIsNot := NOT success;
    END;

    (* write pascal syntax to outputfile *)
    PROCEDURE WritePas(m: Mode; msg: STRING);
    BEGIN
      CASE m OF
        printTitle: BEGIN
            WriteLn(outputFile, '(* PARSER Generated *)');
          END;
        printHead: BEGIN
            tab := '  ';
            WriteLn(outputFile, 'PROCEDURE ', msg, ';');
            WriteLn(outputFile, 'BEGIN');
          END;
        printEnd: BEGIN
            DecTab;
            WriteLn(outputFile, 'END;');
          END;
        printCurlyBegin: BEGIN
            WriteLn(outputFile, tab, 'WHILE sy = .... DO BEGIN');
            IncTab;
          END;
        printCurlyEnd: BEGIN
            DecTab;
            WriteLn(outputFile, tab, 'END;');
          END;
        printCompBegin: BEGIN
            WriteLn(outputFile, tab, 'IF sy = .... THEN BEGIN');
            IncTab;
          END;
        printOpt: BEGIN
            DecTab;
            WriteLn(outputFile, tab, 'END ELSE');
          END;
        printCompEnd: BEGIN
            IncTab;
            WriteLn(outputFile, tab, 'success := FALSE');
          END;
        printIsNotSy: BEGIN
            WriteLn(outputFile,'FUNCTION SyIsNot(expectedSy: Symbol):',
              'BOOLEAN;');
            WriteLn(outputFile,'BEGIN');
            WriteLn(outputFile,' success:= success AND (sy = expectedSy);');
            WriteLn(outputFile,' SyIsNot := NOT success;');
            WriteLn(outputFile,'END;');
            WriteLn(outputFile);
          END;
        printNonTerminal: BEGIN
            WriteLn(outputFile, tab, msg, '; IF NOT success THEN EXIT;');
          END;
        printTerminal: BEGIN
            WriteLn(outputFile, tab, 'IF SyIsNot(', msg, 'Sy) THEN EXIT;');
            WriteLn(outputFile, tab, 'NewSy;');
          END;
      END;
    END;

    (*======== PARSER ========*)
    PROCEDURE Seq;    FORWARD;
    PROCEDURE Stat;   FORWARD;
    PROCEDURE Fact;   FORWARD;

    PROCEDURE S;
    BEGIN
      success := TRUE;
      Seq; IF NOT success OR SyIsNot(eofSy) THEN BEGIN
        WriteLn('----- Error ------');

        WriteLn('Error in line ', syLnr, ' at position ', syCnr)
      END
      ELSE
        WriteLn('Finished writing to output file');
        WriteLn('Sucessfully parsed');
      Close(outputFile);
    END;

    PROCEDURE Seq;
    BEGIN
      WriteLn('Creating output..');
      WritePas(printTitle, '');
      WritePas(printIsNotSy, '');

      WHILE sy <> eofSy DO BEGIN
        IF SyIsNot(identSy) THEN EXIT;
        WritePas(printHead, identStr);
        NewSy;
        IF SyIsNot(equalsSy) THEN EXIT; 
        NewSy;

        Stat; IF NOT success THEN EXIT;
        IF SyIsNot(periodSy) THEN EXIT;
        NewSy;
        WritePas(printEnd, '');
        WriteLn(outputFile);
      END;
    END;

    PROCEDURE Stat;
    BEGIN
      Fact; IF NOT success THEN EXIT;
      WHILE (sy = identSy) OR (sy = optSy) OR (sy = leftCompSy) OR 
        (sy = leftCurlySy) OR (sy = leftParSy) DO BEGIN
        Fact; IF NOT success THEN EXIT;
      END;
    END;

    PROCEDURE Fact;
    BEGIN
      CASE sy OF
        identSy: BEGIN
            (* term or non-term symbol check *)
            IF identStr[1] IN ['A'..'Z'] THEN
              WritePas(printNonTerminal, identStr)
            ELSE
              WritePas(printTerminal, identStr);
            NewSy;
          END;
        optSy: BEGIN
            WritePas(printOpt, '');
            WritePas(printCompBegin, '');
            NewSy;
          END;
        leftCompSy: BEGIN
            NewSy;
            WritePas(printCompBegin, '');
            Stat; IF NOT success THEN EXIT;
            IF sy <> rightCompSy THEN BEGIN success := FALSE; EXIT; END;
            WritePas(printOpt, '');
            WritePas(printCompEnd, '');
            NewSy;
          END;
        leftCurlySy: BEGIN
            NewSy;
            WritePas(printCurlyBegin, '');
            Stat; IF NOT success THEN EXIT;
            IF sy <> rightCurlySy THEN BEGIN success := FALSE; EXIT; END;
            WritePas(printCurlyEnd, '');
            NewSy;
          END;
        leftParSy: BEGIN
            NewSy;
            Stat; IF NOT success THEN EXIT;
            IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
            NewSy;
          END;
      END;
    END;
BEGIN
  tab := '';
END.
