program LineExample3;

uses
  SysUtils, Crt, Line, GfxHelpers, math;

const
  MaxScreenX = 238;    // screen size width
  MaxScreenY = 58;     // screen size height
  MaxTileArray = 34;   // width of wall tile
  MaxPlaneArray = 34;  // number of lines defining a plane
  InitialX = 200;        // top left corner of wall tile (X co-ordinate)
  InitialY = 22;       // top left corner of wall tile (Y co-ordinate)
  Length = 15;         // wall tile height
  Frames = 5;          // number of frames of animation
  PauseTime = 100;     // pause between each redraw

type
  TTileArray = array[1..MaxTileArray] of TLine; // wall tile array
  TPlaneArray = array[1..MaxPlaneArray] of TLine; // for floor and ceiling lines

var
  I: Word; // array index for wall tile
  F: Word; // frame iterator
  CeilingLines: TPlaneArray;  {\    /}
  TileLines: TTileArray;      { |||| }
  FloorLines: TPlaneArray;    {/    \}

  WallGlyph:    WideChar = #$258A;
  FloorGlyph:   WideChar = '-';
  CeilingGlyph: WideChar = '-';

procedure DrawPlanes(FloorArray, CeilingArray: TPlaneArray; MaxArray, Frame, ScreenWidth, InitX, InitY, TileHeight: Integer);
{
draws the floor and ceiling lines
}
var
  I: Integer;
  M: Integer;
begin
  M := ScreenWidth div MaxArray;
  for I := 1 to MaxArray do
  begin
    // floor
    FloorArray[I].ModifyLine(
      MakeTLineVals(
        (I*M), MaxScreenY,
        (InitialX) + I, ((InitY + TileHeight)+2) - F)
    );
    // ceiling
    CeilingArray[I].ModifyLine(
      MakeTLineVals(
        (I*M), 1,
        (InitialX) + I, ((InitY) - 2) + F )
    );
  end;
end;

procedure DrawTile(TileArray: TTileArray; MaxArray, Frame: Integer);
var
  I: Integer;
begin
  // draw tile
  for I := 1 to MaxTileArray do
  begin
    if (I > (Frame*2)) and (I < (MaxTileArray - (Frame*2))) then
    begin
      TileLines[I].ModifyLine(
        MakeTLineVals(
          InitialX + I, InitialY + Frame,
          InitialX + I, (InitialY + Length) - Frame
        )
      );
    end;
  end;
end;

begin

  // clear screen
  ClrScr;
  cursoroff; // only works on Microsoft Windows

  // initialise wall tile array of TLine objects
  for  I := 1 to MaxTileArray do
    TileLines[I] := TLine.Create(WallGlyph);

  // initialise floor and ceiling line objects
  for I := 1 to MaxPlaneArray do
    begin
      CeilingLines[I] := TLine.Create(CeilingGlyph);
      FloorLines[I] := TLine.Create(FloorGlyph);
    end;

  try
  // start animation loop
  repeat
    // movement away
    for F := 0 to Frames do
    begin
      ClrScr;
      // draw floor and ceiling lines
      DrawPlanes(FloorLines, CeilingLines, MaxPlaneArray, F, MaxScreenX, InitialX, InitialY, Length);
      // now draw end of hallway tile
      DrawTile(TileLines, MaxTileArray, F);
      // wait
      Delay(PauseTime);
    end;

    // movement towards loop
    for F := Frames downto 0 do
    begin
      ClrScr;
      // draw floor and ceiling lines
      DrawPlanes(FloorLines, CeilingLines, MaxPlaneArray, F, MaxScreenX, InitialX, InitialY, Length);
      // now draw end of hallway tile
      DrawTile(TileLines, MaxTileArray, F);
      // wait
      Delay(PauseTime);
    end;

  until KeyPressed = true;

  except
    on E: ECartesianOutOfRange do
    begin
      Writeln('Program aborted!');
    end;
  end;

end.