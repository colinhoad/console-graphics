unit GfxHelpers;

interface

uses
  SysUtils;

const
  sLineBreak = {$IFDEF LINUX} AnsiChar(#10) {$ENDIF} 
               {$IFDEF MSWINDOWS} AnsiString(#13#10) {$ENDIF};

type ECartesianOutOfRange = Class(Exception);

type Coordinate = 1..1280;

type
  TCartesian = record
  {
  record representing a Cartesian co-ordinate of two integers
  }
    Px, Py: Coordinate;
  end;

  TLineVals = record
  {
  record representing a pair of Cartesian co-ordinates
  }
    PStart, PEnd: TCartesian;
  end;

function MakeCartesian(X: Integer; Y: Integer): TCartesian;
function MakeTLineVals(StartX, StartY, EndX, EndY: Integer): TLineVals;

implementation


function MakeCartesian(X: Integer; Y: Integer): TCartesian;
{
creates a valid TCartesian record based on a pair of integers 
representing an X,Y co-ordinate
}
begin
  try
    Result.Px := X;
    Result.Py := Y;
  except
    on E: ERangeError do
    begin
      raise ECartesianOutOfRange.create('ERROR: Attempted to create invalid co-ordinate (' + 
      X.ToString + ',' + Y.ToString + 
      ') during call to function GfxHelpers.MakeCartesian' + sLineBreak +
      'HINT: Co-ordinate (X,Y) integers can only range from 1 to 1280');
    end;
  end;
end;

function MakeTLineVals(StartX, StartY, EndX, EndY: Integer): TLineVals;
{
creates a TLineVals record based on a pair of valid Cartesian co-ordinates
}
begin
  try
    Result.PStart := MakeCartesian(StartX, StartY);
    Result.PEnd := MakeCartesian(EndX, EndY);
  except
    on E: ECartesianOutOfRange do
    begin
      Writeln('Exception occurred in GfxHelpers.MakeTLineVals while calling GfxHelpers.MakeCartesian');
      Writeln(E.Message);
      Result.PStart := MakeCartesian(1,1); // prevent range errors
      Result.PEnd := MakeCartesian(1,1); // prevent range errors
      raise;
    end;
  end;
end;

begin
end.