unit Line;

interface

uses GfxHelpers;

type
  TLine = class
  {
  class for creating simple line objects defined by a starting and
  ending (X,Y) Cartesian co-ordinate and a glyph with which to draw 
  the line
  }
    private
      StartXY: TCartesian;
      EndXY: TCartesian;
      Glyph: WideChar;
    public
      constructor Create; overload;
      constructor Create(CustomGlyph: WideChar); overload;
      constructor Create(Args: TLineVals); overload;
      constructor Create(Args: TLineVals; CustomGlyph: WideChar); overload;
      procedure ModifyLine(Args: TLineVals);
      procedure SetStartXY(PStart: TCartesian);
      procedure SetEndXY(PEnd: TCartesian);
      procedure SetGlyph(CustomGlyph: WideChar);
      procedure DrawLine;
  end;

implementation

uses
  SysUtils, Crt, CwString, math;

const
  GridX = 120;
  GridY = 40;
  LinePause = 0;
  GlyphPause = 0;

constructor TLine.Create;
{
constructor to create a new TLine object with default 
values supplied for StartXY, EndXY and Glyph attributes
}
begin
  StartXY.Px := 1;
  StartXY.Py := 1;
  EndXY.Px := 1;
  EndXY.Py := 1;
  Glyph := WideChar(#$258A);
end;

constructor TLine.Create(CustomGlyph: WideChar);
{
constructor to create a new TLine object with a specified
value for the Glyph attribute only
}
begin
  Glyph := CustomGlyph;
end;

constructor TLine.Create(Args: TLineVals);
{
overloaded constructor with specified values for only the
StartXY and EndXY attributes
}
begin
  StartXY := Args.PStart;
  EndXY := Args.PEnd;
  Glyph := WideChar(#$258A);
end;

// 
constructor TLine.Create(Args: TLineVals; CustomGlyph: WideChar);
{
overloaded constructor with specified values for the StartXY,
EndXY and Glyph attributes
}
begin
  StartXY := Args.PStart;
  EndXY := Args.PEnd;
  Glyph := CustomGlyph;
end;

procedure TLine.SetStartXY(PStart: TCartesian);
{
sets the StartXY attribute to a new value
}
begin
  StartXY := PStart;
end;

procedure TLine.SetEndXY(PEnd: TCartesian);
{
sets the EndXY attribute to a new value
}
begin
  EndXY := PEnd;
end;

procedure TLine.SetGlyph(CustomGlyph: WideChar);
{
sets the Glyph attribute to a new value
}
begin
  Glyph := CustomGlyph;
end;

procedure TLine.DrawLine;
{
draws the line based on its current StartXY 
and EndXY Cartesian co-ordinate attributes
}
var
  LengthX: Integer;
  LengthY: Integer;
  D: Integer;
  x: Integer;
  y: Integer;
  IterFrom: Integer;
  IterTo: Integer;

begin

  // calculate lengths moved along X and Y axes
  LengthX := abs(StartXY.Px - EndXY.Px);
  LengthY := abs(StartXY.Py - EndXY.Py);

  // logic for when line is vertical
  if StartXY.Px = EndXY.Px then
  begin
    // establish the iteration from and to values based on whether line is moving 
    // towards or away from its starting co-ordinate
    IterFrom := min(StartXY.Py, EndXY.Py);
    IterTo := max(StartXY.Py, EndXY.Py);
    for y := IterFrom to IterTo do
    begin
      GoToXY(StartXY.Px, y);
      Write(Glyph);
      GoToXY(1,1);
      Delay(GlyphPause);
    end;
  end
  // logic for when line is horizontal
  else if StartXY.Py = EndXY.Py then
  begin
    // establish the iteration from and to values based on whether line is moving 
    // towards or away from its starting co-ordinate
    IterFrom := min(StartXY.Px, EndXY.Px);
    IterTo := max(StartXY.Px, EndXY.Px);
    for x := IterFrom to IterTo do
    begin
      GoToXY(x, StartXY.Py);
      Write(Glyph);
      GoToXY(1,1);
      Delay(GlyphPause);
    end;
  end
  // for diagonals, use Bresenham algorithm
  else if LengthX >= LengthY then
  begin
    // Calculate D based on the longer of the two lengths
    D := abs((2*LengthY) - LengthX);
    // establish the iteration from and to values based on whether line is moving 
    // towards or away from its starting co-ordinate
    IterFrom := StartXY.Px;
    IterTo := EndXY.Px;
    y := StartXY.Py;
    if IterFrom < IterTo then
    begin
      // carry out the algorithm
      for x := IterFrom to IterTo do
      begin
        GoToXY(x, y);
        Write(Glyph);
        Delay(GlyphPause);
        if D > 0 then
        begin
          if StartXY.Py < EndXY.Py then
          begin
            y := y + 1;
          end
          else
          begin
            y := y - 1;
          end;
          D := D - (2*LengthX);
        end;
        D := D + (2*LengthY);
      end;
    end
    else if IterFrom > IterTo then
    begin
      // carry out the algorithm in reverse
      for x := IterFrom downto IterTo do
      begin
        GoToXY(x, y);
        Write(Glyph);
        Delay(GlyphPause);
        if D > 0 then
        begin
          if StartXY.Py < EndXY.Py then
          begin
            y := y + 1;
          end
          else
          begin
            y := y - 1;
          end;
          D := D - (2*LengthX);
        end;
        D := D + (2*LengthY);
      end;
    end;
  end
  else if LengthY > LengthX then
  begin
    // Calculate D based on the longer of the two lengths
    D := abs((2*LengthX) - LengthY);
    // establish the iteration from and to values based on whether line is moving 
    // towards or away from its starting co-ordinate
    IterFrom := StartXY.Py;
    IterTo := EndXY.Py;
    x := StartXY.Px;
    if IterFrom < IterTo then
    begin
      // carry out the algorithm
      for y := IterFrom to IterTo do
      begin
        GoToXY(x, y);
        Write(Glyph);
        Delay(GlyphPause);
        if D > 0 then
        begin
          if StartXY.Px < EndXY.Px then
          begin
            x := x + 1;
          end
          else
          begin
            x := x - 1;
          end;
          D := D - (2*LengthY);
        end;
        D := D + (2*LengthX);
      end;
    end
    else if IterFrom > IterTo then
    begin
      // carry out the algorithm in reverse
      for y := IterFrom downto IterTo do
      begin
        GoToXY(x, y);
        Write(Glyph);
        Delay(GlyphPause);
        if D > 0 then
        begin
          if StartXY.Px < EndXY.Px then
          begin
            x := x + 1;
          end
          else
          begin
            x := x - 1;
          end;
          D := D - (2*LengthY);
        end;
        D := D + (2*LengthX);
      end;
    end;
  end;

  // reset cursor
  GoToXY(1,1);

end;

procedure TLine.ModifyLine(Args: TLineVals);
{
modifies the starting and ending co-ordinates for an
existing  line and redraws it
}
begin
  // set new position
  StartXY := Args.PStart;
  EndXY := Args.PEnd;
  // draw new position
  DrawLine;
end;

end.