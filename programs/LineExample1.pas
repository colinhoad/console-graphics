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
  PauseTime = 300;     // pause between each redraw

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
  cursoroff; // only works on Windows

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
    for F := 0 to Frames do
    begin
      // movement away
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

        // Now draw end of hallway tile
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
        FloorLines[I].SetGlyph(EraseGlyph);
        FloorLines[I].DrawLine;
        FloorLines[I].SetGlyph(FloorGlyph);
        CeilingLines[I].SetGlyph(EraseGlyph);
        CeilingLines[I].DrawLine;
        CeilingLines[I].SetGlyph(CeilingGlyph);
      end;
      // erase tile
      for I := 1 to MaxTileArray do
      begin
        TileLines[I].SetGlyph(EraseGlyph);
        if (I > F) and (I < (MaxTileArray - F)) then
        begin
          TileLines[I].DrawLine;
        end;
        TileLines[I].SetGlyph(WallGlyph);
      end;

  end;
{
  // Movement towards loop
  for F := Frames downto 0 do
  begin
      // Draw initial position of TLines
      for I := 1 to MaxTileArray do
      begin
        // Draw floor and ceiling lines
        if I = (1 + (F*2)) then
        begin
          // floor (Left)
          LineVals.PStart.Px := 1;
          LineVals.PStart.Py := MaxScreenY;
          LineVals.PEnd.Px := (InitialX-1) + I;
          LineVals.PEnd.Py := ((InitialY+2) + Length) - F;
          floorLineL.ModifyLine(LineVals);
          // Ceiling (Left)
          LineVals.PStart.Px := 1;
          LineVals.PStart.Py := 1;
          LineVals.PEnd.Px := (InitialX-1) + I;
          LineVals.PEnd.Py := (InitialY-2) + F;
          CeilingL.ModifyLine(LineVals);
        end
        else if I = (MaxTileArray - (F*2)) then
        begin
          // floor (Right)
          LineVals.PStart.Px := MaxScreenX;
          LineVals.PStart.Py := MaxScreenY;
          LineVals.PEnd.Px := (InitialX+1) + I;
          LineVals.PEnd.Py := ((InitialY+2) + Length) - F;
          floorLineR.ModifyLine(LineVals);
          // Ceiling (Right)
          LineVals.PStart.Px := MaxScreenX;
          LineVals.PStart.Py := 1;
          LineVals.PEnd.Px := (InitialX+1) + I;
          LineVals.PEnd.Py := (InitialY-2) + F;
          CeilingR.ModifyLine(LineVals);
        end;
        // Now draw end of hallway tile
        if (I > (F*2)) and (I < (MaxTileArray - (F*2))) then
        begin
          TileLines[I].SetGlyph(WallGlyph);
          LineVals.PStart.Px := InitialX + I;
          LineVals.PStart.Py := InitialY + F;
          LineVals.PEnd.Px := InitialX + I;
          LineVals.PEnd.Py := (InitialY + Length) - F;
          TileLines[I].ModifyLine(LineVals);
        end;

      end;

      Delay(PauseTime);
    
      // Erase initial position of TLines
      floorLineL.SetGlyph(EraseGlyph);
      floorLineR.SetGlyph(EraseGlyph);
      CeilingL.SetGlyph(EraseGlyph);
      CeilingR.SetGlyph(EraseGlyph);
      floorLineL.DrawLine;
      floorLineR.DrawLine;
      CeilingL.DrawLine;
      CeilingR.DrawLine;
      floorLineL.SetGlyph(FloorGlyph);
      floorLineR.SetGlyph(FloorGlyph);
      CeilingL.SetGlyph(CeilingGlyph);
      CeilingR.SetGlyph(CeilingGlyph);
      for I := 1 to MaxTileArray do
      begin
        TileLines[I].SetGlyph(EraseGlyph);
        if (I > F) and (I < (MaxTileArray - F)) then
        begin
          TileLines[I].DrawLine;
        end;
        TileLines[I].SetGlyph(WallGlyph);
      end;


  end;
}
  until KeyPressed = true;
  except
    on E: ECartesianOutOfRange do
    begin
      Writeln('Program aborted!');
    end;
  end;

end.