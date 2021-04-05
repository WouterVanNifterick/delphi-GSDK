program Logi_SetTargetZone_Sample_Delphi;
{$APPTYPE CONSOLE}

uses
  VCL.Graphics,
  LogitechGSDK in 'LogitechGSDK.pas';

begin
// Initialize the LED SDK
  if not LogiLedInitWithName('SetTargetZone Sample Delphi') then
  begin
    WriteLn('LogiLedInit() failed.');
    Halt;
  end;

  WriteLn('LED SDK Initialized');
  LogiLedSetTargetDevice(LOGI_DEVICETYPE_ALL);

  // Set all devices to Black
  LogiLedSetLighting(clBlack);

  // Set some keys on keyboard
  LogiLedSetLightingForKeyWithKeyName(TKeyName.L, clWebCyan);
  LogiLedSetLightingForKeyWithKeyName(TKeyName.O, clWebCyan);
  LogiLedSetLightingForKeyWithKeyName(TKeyName.G, clWebCyan);
  LogiLedSetLightingForKeyWithKeyName(TKeyName.I, clWebCyan);

  // Set RGB mouse logo to Red
  LogiLedSetLightingForTargetZone(DeviceType.Mouse, 1, clRed);

  // Set G213 keyboard zones to Red, Yellow, Green, Cyan, Blue
  LogiLedSetLightingForTargetZone(DeviceType.Keyboard, 1, clRed);
  LogiLedSetLightingForTargetZone(DeviceType.Keyboard, 2, clYellow);
  LogiLedSetLightingForTargetZone(DeviceType.Keyboard, 3, clGreen);
  LogiLedSetLightingForTargetZone(DeviceType.Keyboard, 4, clWebCyan);
  LogiLedSetLightingForTargetZone(DeviceType.Keyboard, 5, clBlue);

  // Set G633/G933 headset logos to White, backsides to Purple
  LogiLedSetLightingForTargetZone(DeviceType.Headset, 0, clWhite);
  LogiLedSetLightingForTargetZone(DeviceType.Headset, 1, clPurple);

  WriteLn('Press "ENTER" to continue...');
  Readln;

  WriteLn('LED SDK Shutting down');
  LogiLedShutdown();

end.
