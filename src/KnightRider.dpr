program KnightRider;
{$APPTYPE CONSOLE}

uses
  System.UITypes,
  VCL.Graphics,
  System.DateUtils,
  System.SysUtils,
  LogitechGSDK in 'LogitechGSDK.pas';

const
  KEYS = 12;

procedure TryInit;
begin
  // Initialize the LED SDK
  if LogiLedInitWithName('SetTargetZone Sample Delphi') then
    Exit;

  WriteLn('LogiLedInit() failed.');
  Halt;
end;

procedure ClearAll;
begin
  LogiLedSetTargetDevice(LOGI_DEVICETYPE_ALL);
  LogiLedSetLighting(clBlack);
end;

function Triangle(x, w: integer): integer;
begin
  Result := abs((x mod w) - w div 2);
end;


procedure Animate(aSeconds:integer);
var
  t0             : TDateTime;
  t              : integer;
  key            : integer;
  highlightPos   : integer;
  distToHighlight: integer;
  color          : integer;
begin
  ClearAll;
  t0 := now;
  t  := 0;
  while now - t0 < oneSecond * aSeconds do
  begin
    inc(t);
    highlightPos := Triangle(t, KEYS * 2);
    for key := 0 to KEYS - 1 do
    begin
      distToHighlight := abs(key - highlightPos);
      color := 100 - Trunc(200 * distToHighlight / KEYS);
      LogiLedSetLightingForKeyWithKeyName(TKeyName(2 + key), color, 0, color div 16);
    end;
    Sleep(25);
  end;
end;

begin
  TryInit;

  Animate(5);

  LogiLedShutdown;

end.
