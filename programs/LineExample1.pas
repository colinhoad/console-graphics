program LineExample1;

uses
  SysUtils, Crt, Line, GfxHelpers;

const
  MaxScreenX = 238;   // screen size width
  MaxScreenY = 58;    // screen size height
  MaxLineArray = 32;  // width of wall tile
  InitialX = 100;     // top left corner of wall tile (X co-ordinate)
  InitialY = 24;      // top left corner of wall tile (Y co-ordinate)
  Length = 14;        // wall tile height
  Frames = 6;         // number of frames of animation
  PauseTime = 300;    // pause between each redraw

type
  LineArray = array[1..MaxLineArray] of TLine; // wall tile array

var
  I: Word; // array index for wall tile
  F: Word; // frame iterator
  MyLinePos: TLineVals;
  CeilingL, CeilingR: TLine;    {\    /}
  MyLines: LineArray;           { |||| }
  PathLineL, PathLineR: TLine;  {/    \}

  WallGlyph:  WideChar = #$258A;
  EraseGlyph: WideChar = ' ';
  PathGlyph:  WideChar = '.';
  CeilGlyph:  WideChar = '~';

function MakeStartEndXY(CStart: TCartesian; CEnd: TCartesian): TLineVals;
var
  LinePosition: TLineVals;
begin
  LinePosition.PStart := CStart;
  LinePosition.PEnd := CEnd;
  Result := LinePosition;
end;

begin

  ClrScr;
  cursoroff;

  // initialise wall tile array of TLine objects
  for  I := 1 to MaxLineArray do
    MyLines[I] := TLine.Create;  

  // initialise path and ceiling line objects
  PathLineL := TLine.Create(PathGlyph);
  PathLineR := TLine.Create(PathGlyph);
  CeilingL := TLine.Create(CeilGlyph);
  CeilingR := TLine.Create(CeilGlyph);

  // start animation loop
  repeat
    for F := 0 to Frames do
    begin
        // movement away
        for I := 1 to MaxLineArray do
        begin
          // draw path and ceiling lines
          if I = (1 + (F*2)) then
          begin
            // floor (left)
            PathLineL.ModifyLine(
              MakeTLineVals(
                MakeCartesian(1, MaxScreenY)
                ,MakeCartesian((InitialX-1) + I, ((InitialY+2) + Length) - F)
              )
            );
            // ceiling (left)
            try
            CeilingL.ModifyLine(
              MakeTLineVals(
                MakeCartesian(1, 1)
                ,MakeCartesian((InitialX-1) + I, (InitialY-2) + F)
              )
            )
            except
              on E : ENonPositiveInt do 
              begin
                Writeln(E.Message);
                exit;
              end;
            end;
          end
          else if I = (MaxLineArray - (F*2)) then
          begin
            // floor (right)
            MyLinePos.PStart.Px := MaxScreenX;
            MyLinePos.PStart.Py := MaxScreenY;
            MyLinePos.PEnd.Px := (InitialX+1) + I;
            MyLinePos.PEnd.Py := ((InitialY+2) + Length) - F;
            PathLineR.ModifyLine(MyLinePos);
            // ceiling (right)
            MyLinePos.PStart.Px := MaxScreenX;
            MyLinePos.PStart.Py := 1;
            MyLinePos.PEnd.Px := (InitialX+1) + I;
            MyLinePos.PEnd.Py := (InitialY-2) + F;
            CeilingR.ModifyLine(MyLinePos);
          end;
          // Now draw end of hallway tile
          if (I > (F*2)) and (I < (MaxLineArray - (F*2))) then
          begin
            MyLines[I].SetGlyph(WallGlyph);
            MyLinePos.PStart.Px := InitialX + I;
            MyLinePos.PStart.Py := InitialY + F;
            MyLinePos.PEnd.Px := InitialX + I;
            MyLinePos.PEnd.Py := (InitialY + Length) - F;
            MyLines[I].ModifyLine(MyLinePos);
          end;

        end;

        Delay(PauseTime);
      
        // Erase initial position of TLines
        PathLineL.SetGlyph(EraseGlyph);
        PathLineR.SetGlyph(EraseGlyph);
        CeilingL.SetGlyph(EraseGlyph);
        CeilingR.SetGlyph(EraseGlyph);
        PathLineL.DrawLine;
        PathLineR.DrawLine;
        CeilingL.DrawLine;
        CeilingR.DrawLine;
        PathLineL.SetGlyph(PathGlyph);
        PathLineR.SetGlyph(PathGlyph);
        CeilingL.SetGlyph(CeilGlyph);
        CeilingR.SetGlyph(CeilGlyph);
        for I := 1 to MaxLineArray do
        begin
          MyLines[I].SetGlyph(EraseGlyph);
          if (I > F) and (I < (MaxLineArray - F)) then
          begin
            MyLines[I].DrawLine;
          end;
          MyLines[I].SetGlyph(WallGlyph);
        end;
    end;

    // Movement towards loop
    for F := Frames downto 0 do
    begin
        // Draw initial position of TLines
        for I := 1 to MaxLineArray do
        begin
          // Draw path and ceiling lines
          if I = (1 + (F*2)) then
          begin
            // Path (Left)
            MyLinePos.PStart.Px := 1;
            MyLinePos.PStart.Py := MaxScreenY;
            MyLinePos.PEnd.Px := (InitialX-1) + I;
            MyLinePos.PEnd.Py := ((InitialY+2) + Length) - F;
            PathLineL.ModifyLine(MyLinePos);
            // Ceiling (Left)
            MyLinePos.PStart.Px := 1;
            MyLinePos.PStart.Py := 1;
            MyLinePos.PEnd.Px := (InitialX-1) + I;
            MyLinePos.PEnd.Py := (InitialY-2) + F;
            CeilingL.ModifyLine(MyLinePos);
          end
          else if I = (MaxLineArray - (F*2)) then
          begin
            // Path (Right)
            MyLinePos.PStart.Px := MaxScreenX;
            MyLinePos.PStart.Py := MaxScreenY;
            MyLinePos.PEnd.Px := (InitialX+1) + I;
            MyLinePos.PEnd.Py := ((InitialY+2) + Length) - F;
            PathLineR.ModifyLine(MyLinePos);
            // Ceiling (Right)
            MyLinePos.PStart.Px := MaxScreenX;
            MyLinePos.PStart.Py := 1;
            MyLinePos.PEnd.Px := (InitialX+1) + I;
            MyLinePos.PEnd.Py := (InitialY-2) + F;
            CeilingR.ModifyLine(MyLinePos);
          end;
          // Now draw end of hallway tile
          if (I > (F*2)) and (I < (MaxLineArray - (F*2))) then
          begin
            MyLines[I].SetGlyph(WallGlyph);
            MyLinePos.PStart.Px := InitialX + I;
            MyLinePos.PStart.Py := InitialY + F;
            MyLinePos.PEnd.Px := InitialX + I;
            MyLinePos.PEnd.Py := (InitialY + Length) - F;
            MyLines[I].ModifyLine(MyLinePos);
          end;

        end;

        Delay(PauseTime);
      
        // Erase initial position of TLines
        PathLineL.SetGlyph(EraseGlyph);
        PathLineR.SetGlyph(EraseGlyph);
        CeilingL.SetGlyph(EraseGlyph);
        CeilingR.SetGlyph(EraseGlyph);
        PathLineL.DrawLine;
        PathLineR.DrawLine;
        CeilingL.DrawLine;
        CeilingR.DrawLine;
        PathLineL.SetGlyph(PathGlyph);
        PathLineR.SetGlyph(PathGlyph);
        CeilingL.SetGlyph(CeilGlyph);
        CeilingR.SetGlyph(CeilGlyph);
        for I := 1 to MaxLineArray do
        begin
          MyLines[I].SetGlyph(EraseGlyph);
          if (I > F) and (I < (MaxLineArray - F)) then
          begin
            MyLines[I].DrawLine;
          end;
          MyLines[I].SetGlyph(WallGlyph);
        end;
    end;

  until KeyPressed = true;

end.