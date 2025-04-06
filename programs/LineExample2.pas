program LineExample2;

uses
  SysUtils, Crt, Line, GfxHelpers, math;

const
  MaxScreenX = 238;    // screen size width
  MaxScreenY = 58;     // screen size height
  MaxTileArray = 36;   // width of wall tile
  MaxPlaneArray = 36;  // number of lines defining a plane
  InitialX = 101;      // top left corner of wall tile (X co-ordinate)
  InitialY = 22;       // top left corner of wall tile (Y co-ordinate)
  Length = 14;         // wall tile height
  Frames = 6;          // number of frames of animation
  PauseTime = 300;     // pause between each redraw

type
  TileArray = array[1..MaxTileArray] of TLine; // wall tile array
  TPlaneArray = array[1..MaxPlaneArray] of TLine; // for floor and ceiling lines

var
  I: Word; // array index for wall tile
  F: Word; // frame iterator
  CeilingLines: TPlaneArray;  {\    /}
  TileLines: TileArray;       { |||| }
  FloorLines: TPlaneArray;    {/    \}

  WallGlyph:    WideChar = #$258A;
  FloorGlyph:   WideChar = '.';
  CeilingGlyph: WideChar = '~';

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
      // draw floor and ceiling lines
      for I := 1 to MaxPlaneArray do
      begin
        if (I > (F*2)) and (I < (MaxPlaneArray - (F*2))) then
        begin
          // floor
          FloorLines[I].ModifyLine(
            MakeTLineVals(
              (I*7), MaxScreenY,
              (InitialX) + I, ((InitialY+2) + Length) - F)
          );
          // ceiling
          CeilingLines[I].ModifyLine(
            MakeTLineVals(
              (I*7), 1,
              (InitialX) + I, (InitialY-2) + F
            )
          );
        end;
      end;
      // now draw end of hallway tile
      for I := 1 to MaxTileArray do
      begin
        if (I > (F*2)) and (I < (MaxTileArray - (F*2))) then
        begin
          TileLines[I].ModifyLine(
            MakeTLineVals(
              InitialX + I, InitialY + F,
              InitialX + I, (InitialY + Length) - F
            )
          );
        end;
      end;

      Delay(PauseTime);

      // erase floor and ceiling
      for I := 1 to MaxPlaneArray do
      begin
        if (I > F) and (I < (MaxPlaneArray - F)) then
        begin
          FloorLines[I].EraseLine;
          CeilingLines[I].EraseLine;
        end;
      end;

      // erase tile
      for I := 1 to MaxTileArray do
      begin
        if (I > F) and (I < (MaxTileArray - F)) then
        begin
          TileLines[I].EraseLine;
        end;
      end;

  end;

  // movement towards loop
  for F := Frames downto 0 do
    begin
      // draw floor and ceiling lines
      for I := 1 to MaxPlaneArray do
      begin
        if (I > (F*2)) and (I < (MaxPlaneArray - (F*2))) then
        begin
          // floor
          FloorLines[I].ModifyLine(
            MakeTLineVals(
              (I*7), MaxScreenY,
              (InitialX) + I, ((InitialY+2) + Length) - F)
          );
          // ceiling
          CeilingLines[I].ModifyLine(
            MakeTLineVals(
              (I*7), 1,
              (InitialX) + I, (InitialY-2) + F
            )
          );
        end;
      end;
      // now draw end of hallway tile
      for I := 1 to MaxTileArray do
      begin
        if (I > (F*2)) and (I < (MaxTileArray - (F*2))) then
        begin
          TileLines[I].ModifyLine(
            MakeTLineVals(
              InitialX + I, InitialY + F,
              InitialX + I, (InitialY + Length) - F
            )
          );
        end;
      end;

      Delay(PauseTime);

      // erase floor and ceiling
      for I := 1 to MaxPlaneArray do
      begin
        if (I > F) and (I < (MaxPlaneArray - F)) then
        begin
          FloorLines[I].EraseLine;
          CeilingLines[I].EraseLine;
        end;
      end;

      // erase tile
      for I := 1 to MaxTileArray do
      begin
        if (I > F) and (I < (MaxTileArray - F)) then
        begin
          TileLines[I].EraseLine;
        end;
      end;

  end;

  until KeyPressed = true;

  except
    on E: ECartesianOutOfRange do
    begin
      Writeln('Program aborted!');
    end;
  end;

end.