program LineExample1;

uses
  SysUtils, Crt, Line, GfxHelpers;

const
  MaxScreenX = 238;    // screen size width
  MaxScreenY = 58;     // screen size height
  MaxTileArray = 32;   // width of wall tile
  MaxPlaneArray = 2;   // number of lines defining a plane
  InitialX = 100;      // top left corner of wall tile (X co-ordinate)
  InitialY = 24;       // top left corner of wall tile (Y co-ordinate)
  Length = 14;         // wall tile height
  Frames = 6;          // number of frames of animation
  PauseTime = 100;     // pause between each redraw

type
  TileArray = array[1..MaxTileArray] of TLine; // wall tile array
  TPlaneArray = array[1..MaxPlaneArray] of TLine; // for floor and ceiling lines

var
  I: Word; // array index for wall tile
  F: Word; // frame iterator
  LineVals: TLineVals; // used for passing co-ordinate arguments into TLine constructors
  CeilingLines: TPlaneArray;  {\    /}
  TileLines: TileArray;       { |||| }
  FloorLines: TPlaneArray;    {/    \}

  EraseGlyph:   WideChar = ' ';
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
      for I := 1 to MaxTileArray do
      begin
        // draw floor and ceiling lines
        if I = (1 + (F*2)) then
        begin
          // floor (left)
          FloorLines[1].ModifyLine(
            MakeTLineVals(
              1, MaxScreenY,
              (InitialX-1) + I, ((InitialY+2) + Length) - F)
          );
          // ceiling (left)
          CeilingLines[1].ModifyLine(
            MakeTLineVals(
              1, 1,
              (InitialX-1) + I, (InitialY-2) + F
            )
          );
        end
        else if I = (MaxTileArray - (F*2)) then
        begin
          // floor (right)
          FloorLines[MaxPlaneArray].ModifyLine(
            MakeTLineVals(
              MaxScreenX, MaxScreenY,
              (InitialX+1) + I, ((InitialY+2) + Length) - F
            )
          );
          // ceiling (right)
          CeilingLines[MaxPlaneArray].ModifyLine(
            MakeTLineVals(
              MaxScreenX, 1,
              (InitialX+1) + I, (InitialY-2) + F
            )
          );
        end;

        // now draw end of hallway tile
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
        FloorLines[I].EraseLine;
        CeilingLines[I].EraseLine;
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
      for I := 1 to MaxTileArray do
      begin
        // draw floor and ceiling lines
        if I = (1 + (F*2)) then
        begin
          // floor (left)
          FloorLines[1].ModifyLine(
            MakeTLineVals(
              1, MaxScreenY,
              (InitialX-1) + I, ((InitialY+2) + Length) - F)
          );
          // ceiling (left)
          CeilingLines[1].ModifyLine(
            MakeTLineVals(
              1, 1,
              (InitialX-1) + I, (InitialY-2) + F
            )
          );
        end
        else if I = (MaxTileArray - (F*2)) then
        begin
          // floor (right)
          FloorLines[MaxPlaneArray].ModifyLine(
            MakeTLineVals(
              MaxScreenX, MaxScreenY,
              (InitialX+1) + I, ((InitialY+2) + Length) - F
            )
          );
          // ceiling (right)
          CeilingLines[MaxPlaneArray].ModifyLine(
            MakeTLineVals(
              MaxScreenX, 1,
              (InitialX+1) + I, (InitialY-2) + F
            )
          );
        end;

        // now draw end of hallway tile
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
        FloorLines[I].EraseLine;
        CeilingLines[I].EraseLine;
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