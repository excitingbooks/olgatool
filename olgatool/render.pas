program OlgaRender;

uses
  Crt, Graph;

const
  MaxParams = 8;

var
  CurrentLine : String;
  CurrentParams : array[1..8] of String;
  c : Char;

const
  CurrentTextLine: Integer = 1;
procedure T(Message : String);
begin
  CurrentTextLine := CurrentTextLine + 1;
  OutTextXY(20, CurrentTextLine * 12, Message);
end;
  
function IntP(Pos : Integer) : Integer;
var
  RetVal, Code : Integer;
begin
  Val(CurrentParams[Pos], RetVal, Code);
  IntP := RetVal;
end;

function IntP_(Pos : Integer; _ : String) : Integer; begin IntP_ := IntP(Pos); end;

function WordP(Pos : Integer) : Word;
var
  RetVal, Code : Word;
begin
  Val(CurrentParams[Pos], RetVal, Code);
  WordP := RetVal;
end;

function BoolP(Pos : Integer) : Boolean;
var
  RetVal, Code : Word;
begin
  Val(CurrentParams[Pos], RetVal, Code);
  BoolP := RetVal = 1;
end;

{function ArrayOfIntP(Pos : Integer, Count : Integer) : Boolean;
var
  Param : String;
  CurrentChar : Char;
  Elements : array[1..127] of Integer;
  CurrentElement : String;
  InElement : Boolean;
begin
  Param := CurrentParams[Pos];
  CurrentElement := '';
  Count := 0;
  
  for i := 1 to Length(Param) do begin
    CurrentChar := S[i];

    case CurrentChar of
      '[', ' ', ']': ;
      '0'..'9', '-', '.': begin
        if not InElement then begin
          InElement := True;
          Count := Count + 1;
          Elements[Count] := '';
        end;
        Elements[Count] := Elements[Count] + CurrentChar;
      ',': InElement := False;
    end;
  end;
  
  ArrayOfIntP := Elements;
end;

function ArrayOfStringP(Pos : Integer, Count : Integer) : array[1..127] of String;
var
  Param : String;
  CurrentChar : Char;
  Elements : array[1..127] of String;
  InElement : Boolean;
begin
  Param := CurrentParams[Pos];
  Count := 0;
  
  for i := 1 to Length(Param) do begin
    CurrentChar := S[i];

    case CurrentChar of
      '[', ' ', ']': ;
      '0'..'9', '-', '.': begin
        if not InElement then begin
          InElement := True;
          Count := Count + 1;
          Elements[Count] := '';
        end;
        Elements[Count] := Elements[Count] + CurrentChar;
      ',': InElement := False;
    end;
  end;
  
  ArrayOfStringP := Elements;
end;}

procedure CmdArc;
var
  p1, p2, p3, p4, p5 : String;
  c : Char;
begin
  { Arc (X, Y: Integer; StAngle, ,EndAngle, Radius: Word); }
  Arc(IntP(1), IntP(2), WordP(3), WordP(4), WordP(5));
  { Str(IntP(1), p1);
  Str(IntP(2), p2);
  Str(IntP(3), p3);
  Str(IntP(4), p4);
  Str(IntP(5), p5);
  T('Completed>>>>Arc('+p1+','+p2+','+p3+','+p4+','+p5);
  c := ReadKey; }
end;

procedure CmdBar;
begin
  { Bar(Xl, Yl, X2, Y2: Integer) }
  Bar(IntP(1), IntP(2), IntP(3), IntP(4));
end;

procedure CmdBar3D;
begin
  { Bar3D(X1, Yl, X2, Y2: Integer; Depth: Word; Top: Boolean); }
  Bar3D(IntP(1), IntP(2), IntP(3), IntP(4), WordP(5), BoolP(6));
end;

procedure CmdCircle;
begin
  { procedure Bar(X1, Y1, X2, Y2: Integer) }
  Circle(IntP(1), IntP(2), WordP(3));
end;

procedure CmdEllipse;
var
  ShouldFill : Boolean;
begin
  ShouldFill := True;
  { FillEllipse(X, Y: Integer; XRadius, YRadius: Word);
  Ellipse(X, Y: Integer; StAngle, EndAngle: Word; YRadius, YRadius: Word); }
  
  if ShouldFill then
    FillEllipse(IntP(1), IntP(2), WordP(3), WordP(4))
  else Ellipse(IntP(1), IntP(2), WordP(5), WordP(6), WordP(3), WordP(4));
end;

procedure CmdLine;
begin
  Line(IntP(1), IntP(2), IntP(3), IntP(4));
end;

procedure CmdText;
var
  TextLine : String;
  
begin
  TextLine := CurrentParams[3];
  MoveTo(IntP(1), IntP(2));

  { TODO: for each line }
  OutText(TextLine);
end;

procedure CmdPolygon;
begin
  { DrawPoly (NumPoints: Word; var PolyPoints); }
end;

procedure CmdClear;
begin
  ClearDevice;
end;

procedure CmdSleep;
begin
  Delay(IntP(1));
end;

procedure CmdSetColor;
begin
  SetColor(IntP(1));
end;


procedure CmdBarChart;
var
  i, ValCount : Integer;
  Val, MaxVal : Integer;
  BorderWidth, BarInterval, BarHeight, ScaledHeight : Integer;
  TopVal : Integer;
begin
  {Values := ArrayOfIntP(1, ValCount);
  TopVal := 0;
  
  BorderWidth := GetMaxX / 50;
  BarInterval := (GetMaxX - (BorderWidth * 2)) / ValCount;
  BarHeight := (GetMaxY - (BorderWidth * 4)) / ValCount;
  
  for i := 1 to ValCount do begin
    Val := Values[i];
    if Val > TopVal then TopVal := Val;
  end;
  
  for i := 1 to ValCount do begin
    Val := Values[i];
    ScaledHeight := Val / TopVal * BarHeight;
    Bar3D(
      BorderWidth + i * BarInterval, GetMaxY - BorderWidth, 
      BorderWidth + i * BarInterval + (BarInterval / 2), GetMaxY - BorderWidth - ScaledHeight,
      BarInterval / 2, 1);
  end;}
end;

procedure RenderCommand(_Command : String);
var
  i : Integer;
  Command : String;
begin
  Command := '';
  
  for i := 1 to length(_Command) do
    Command := Command + UpCase(_Command[i]);

  if Command = 'CLEAR' then CmdClear
  
  else if Command = 'ARC' then CmdArc
  else if Command = 'BAR' then CmdBar
  else if Command = 'BAR3D' then CmdBar3D
  else if Command = 'CIRCLE' then CmdCircle
  else if Command = 'ELLIPSE' then CmdEllipse
  else if Command = 'LINE' then CmdLine
  else if Command = 'POLYGON' then CmdPolygon
  else if Command = 'TEXT' then CmdText
    
  else if Command = 'BARCHART' then CmdBarChart
  
  
  else if Command = 'SLEEP' then CmdSleep
  else if Command = 'SETCOLOR' then CmdSetColor
    
  else T('Couldn''t find command: ' + Command);
end;

procedure Render(S : String);
const
  CR = #10;
  LF = #13;

  ParamIdx: Integer = 1;
  InArgs: Boolean = False;
  InString: Boolean = False;
  InArray: Boolean = False;
  Command: String = '';
var
  CurrentChar, c : Char;
  i, j : Integer;
begin
  for i := 1 to Length(S) do begin
    CurrentChar := S[i];
    {T('CHAR#'+_+': '+CurrentChar);
    c := ReadKey;}

    if InString and (CurrentChar <> '"') then
      CurrentParams[ParamIdx] := CurrentParams[ParamIdx] + CurrentChar
    else
      begin
        case UpCase(CurrentChar) of
          ';', CR, LF:
            if Command <> '' then
              begin
                RenderCommand(Command);
                for j := 1 to ParamIdx do
                  CurrentParams[j] := '';
                ParamIdx := 1;
                Command := '';
              end;
          '(': InArgs := True;
          ')': InArgs := False;
          ',': ParamIdx := ParamIdx + 1;
          '"': InString := not InString;
          ' ': ;
          'A'..'Z', '0'..'9', '.', '-':
            begin
              if InArgs then
                CurrentParams[ParamIdx] := CurrentParams[ParamIdx] + CurrentChar
              else
                Command := Command + CurrentChar;
            end;
        else
          T('Error at >' + CurrentChar + '< Command ' + Command);
        end;
      end;
  end;
end;

procedure InitGraphics;
var
  ErrorCode, grDriver, grMode : Integer;
  Command : String;

begin
  grDriver := Detect;
  InitGraph(grDriver, grMode, 'EGAVGA.BGI');
  ErrorCode := GraphResult;
  if ErrorCode <> grOK then
    begin
      WriteLn('GraphResult ErrorCode ', ErrorCode);
      Halt(1);
    end;

  ClearDevice;
end;

procedure LoopOnInbox;
var
  Inbox, Outbox: Text;
  Command: String;
  ch, ch2: Char;
  Done: Boolean;
begin
  Done := False;
  repeat
    Assign(Inbox, 'Inbox');
    Reset(Inbox);
    Assign(Outbox, 'Outbox');
    Rewrite(Outbox);

    if not Eof(Inbox) then
    begin
      Readln(Inbox, Command);
      {T('Inbox cmd: ' + Command);}
      Render(Command);
      Rewrite(Inbox);
    end;
    ch := ReadKey;
    if KeyPressed then
      ch2 := ReadKey;
    {Writeln('> ', ch, ' ord ', Ord(ch), ' ch2 ', ch2, ' ord ', Ord(ch2));
    Writeln(Outbox, ch);
    Flush(Outbox);}
    T('<' + ch);
    case ch of
      Chr(27): Done := True;
    end;
  
    Close(Inbox);
    Close(Outbox);
  until Done;
end;

var
  Command : String;

begin
  Command :=
    'arc(200,200,290,340,100);' +
    'arc(200,200,110,160,100);' +
    'line(0,0,400,400);' +
    'Sleep(1000);' +
    'Clear;' +
    'Bar3D(50,200,90,100,15,1);' +
    'Bar3D(100,200,140,120,15,1);' +
    'BarChart([10, 13, 20, 29, 50]);' +
    'Text(100, 20, "hamb/ORGR");' +
    '';

  InitGraphics;
  SetFillStyle(CloseDotFill, 9);
  SetColor(15);
  SetTextStyle(10, HorizDir, 1);
  SetTextJustify(CenterText, TopText);;

  LoopOnInbox;

  { Render(Command); }
  c := ReadKey;
  CloseGraph;
end.
