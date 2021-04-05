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

procedure Init;
begin
  // Initialize the LED SDK
  if LogiLedInitWithName('SetTargetZone Sample Delphi') then
    Exit;

  WriteLn('LogiLedInit() failed.');
  Halt;
end;

procedure Clear;
begin
  LogiLedSetTargetDevice(LOGI_DEVICETYPE_ALL);
  LogiLedSetLighting(clBlack);
end;

function Triangle(x, w:integer):integer;
begin
  Result := abs((x mod w) - w div 2);
end;

var
  t0:TDateTime;
  t:integer;
  key:integer;
  highlightPos:integer;
  distToHighlight:integer;
  c : Integer;
begin
  Init;
  Clear;

  t0 := now;
  t := 0;

  while now - t0 < oneSecond * 5 do
  begin
    inc(t);
    highlightPos := Triangle(t, KEYS * 2);
    Write('[',highlightPos,'] ');
    for key := 0 to KEYS-1 do
    begin
      distToHighlight := Abs(key - highlightPos);
      c := 100 - Trunc(200 * distToHighlight / KEYS);
      if c < 50 then
        c := 0;
      Write(Format('%.03d ',[ c ]));
    LogiLedSetLightingForKeyWithKeyName(TKeyName(2 + key), c, 0, c div 16);
    end;
    Writeln;
    Sleep(25);
  end;

  WriteLn('Press "ENTER" to continue...');
  Readln;
  LogiLedShutdown;
end.
