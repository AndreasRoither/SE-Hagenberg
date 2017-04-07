(* WinGraph:                    HDO 1995-2004, JH 2003, GHO 2010, HDO 2011
   --------
   Simple module for generating Windows graphics using Borland Pascal
   or FreePascal (in Turbo Pascal mode: -Mtp).
==========================================================================*)
UNIT WinGraph;


INTERFACE

  USES
  {$IFDEF FPC}
    Windows;
  {$ELSE}
    WinTypes;
  {$ENDIF}

  TYPE
    RedrawProcType =       PROCEDURE (dc: HDC; wnd: HWnd; r: TRect);
    MousePressedProcType = PROCEDURE (dc: HDC; wnd: HWnd; x, y: INTEGER);

  VAR
    redrawProc:       RedrawProcType;        (*SHOULD be set in main program*)
    mousePressedProc: MousePressedProcType;  (*MAY    be set in main program*)

{$IFDEF FPC}
  PROCEDURE MoveTo(dc: HDC; x, y: INTEGER); (*calls MoveToEx for Win32 API*)
{$ENDIF}

  PROCEDURE WGMain; (*HAS TO be called in main program to start message loop*)


IMPLEMENTATION

  USES
  {$IFNDEF FPC}
    WinProcs,
  {$ENDIF}
    Strings;

  CONST
    applName = 'WinGraph: Windows Graphics';

{$IFDEF FPC}
  PROCEDURE MoveTo(dc: HDC; x, y: INTEGER);
  BEGIN
    MoveToEx(dc, x, y, NIL);
  END; (*MoveTo*)
{$ENDIF}

  (* FrameWindowProc: callback function,
     called whenever an event for the frame window occurs *)
  FUNCTION FrameWindowProc
  {$IFDEF FPC}
    (wnd: HWnd; msg: UINT; wParam: WPARAM; lParam: LPARAM):  LRESULT; StdCall; EXPORT;
  {$ELSE}
    (wnd: HWnd; msg: WORD; wParam: WORD;   lParam: LONGINT): LONGINT; EXPORT;
  {$ENDIF}
    VAR
      ps: TPaintStruct;
      r:  TRect;
      dc: HDC;
  BEGIN
    FrameWindowProc := 0;
    CASE msg OF
      wm_destroy:
          PostQuitMessage(0);
      wm_paint:
          IF @redrawProc <> NIL THEN BEGIN
            dc := BeginPaint(wnd, ps);
            GetClientRect(wnd, r);
            redrawProc(dc, wnd, r);
            EndPaint(wnd, ps);
          END; (*IF*)
      wm_lButtonDown: BEGIN
         IF @mousePressedProc <> NIL THEN
           mousePressedProc(GetDC(wnd), wnd, LoWord(lParam), HiWord(lParam));
         END
      ELSE BEGIN
        FrameWindowProc := DefWindowProc(wnd, msg, wParam, lParam);
      END;
    END; (*CASE*)
  END;(*FrameWindowProc*)

  PROCEDURE WGMain;
    VAR
      wndClass: TWndClass;
      wnd:      HWnd;
      msg:      TMsg;
  BEGIN
    IF hPrevInst = 0 THEN BEGIN (*first call*)
      wndClass.style         := cs_hRedraw OR cs_vRedraw;
  {$IFDEF FPC}
      wndClass.lpfnWndProc   := WndProc(@FrameWindowProc);
  {$ELSE}
      wndClass.lpfnWndProc   := @FrameWindowProc;
  {$ENDIF}
      wndClass.cbClsExtra    := 0;
      wndClass.cbWndExtra    := 0;
      wndClass.hInstance     := 0;
      wndClass.hIcon         := 0;
      wndClass.hCursor       := 0;
      wndClass.hbrBackground := 0;
      wndClass.lpszMenuName  := applName; (*BPC: ext. syntax compiler option*)
      wndClass.lpszClassName := applName; (*BPC: ext. syntax compiler option*)
      wndClass.hInstance     := hInstance;
      wndClass.hIcon         := LoadIcon(0, idi_application);
      wndClass.hCursor       := LoadCursor(0, idc_arrow);
      wndClass.hbrBackground := GetStockObject(white_brush);
      IF Ord(RegisterClass(wndClass)) = 0 THEN BEGIN
        MessageBox(0, 'RegisterClass for window failed', NIL, mb_Ok);
        Halt;
      END; (*IF*)
    END; (*IF*)
    wnd := CreateWindow(applName, applName, ws_overlappedWindow,
                        40, 40, 800, 600, 0, 0, hInstance, NIL);
    ShowWindow(wnd, cmdShow);
    UpdateWindow(wnd);       (*update client area by sending wm_paint*)
    WHILE GetMessage(msg, 0, 0, 0) DO BEGIN
      TranslateMessage(msg); (*translate key messages*)
      DispatchMessage(msg);  (*dispatch  to windows callback function*)
    END; (*WHILE*)
  END; (*WGMain*)

  PROCEDURE Redraw_Default(dc: HDC; wnd: HWnd; r: TRect); FAR;
    VAR
      txt: ARRAY [0..255] OF CHAR;
  BEGIN
    StrCopy(txt, 'Redraw_Default: no other Redraw prodecure installed');
    TextOut(dc, 10, 10, txt, StrLen(txt));
  END; (*MousePressed_Default*)

  PROCEDURE MousePressed_Default(dc: HDC; wnd: HWnd; x, y: INTEGER); FAR;
  BEGIN
    WriteLn('MousePressed_Default: no other MousePressed procedure installed');
  END; (*MousePressed_Default*)

BEGIN (*WinGraph*)
  redrawProc := Redraw_Default;
  mousePressedProc := MousePressed_Default;
END. (*WinGraph*)