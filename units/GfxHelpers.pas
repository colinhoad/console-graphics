unit GfxHelpers;

interface

uses SysUtils;

type ENonPositiveInt = Class(Exception);

type
  // record for X,Y co-ordinates
  TCartesian = record
    Px, Py: Integer;
  end;

  // record for initialising a TLine object
  TLineVals = record
    PStart, PEnd: TCartesian;
  end;

function MakeCartesian(X: Integer; Y: Integer): TCartesian;
function MakeTLineVals(StartXY: TCartesian; EndXY: TCartesian): TLineVals;

implementation

function MakeCartesian(X: Integer; Y: Integer): TCartesian;
var
  Cartesian: TCartesian;
begin
  if (X > 0) and (Y > 0) then
  begin
    Cartesian.Px := X;
    Cartesian.Py := Y;
  end
  else
  begin
    raise ENonPositiveInt.create('Both X and Y must be positive integers!');
  end;
  Result := Cartesian;
end;

function MakeTLineVals(StartXY: TCartesian; EndXY: TCartesian): TLineVals;
var
  LineVals: TLineVals;
begin
  LineVals.PStart := StartXY;
  LineVals.PEnd := EndXY;
  Result := LineVals;
end;

begin
end.