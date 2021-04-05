unit LogitechGSDK;

{
  Delphi GSDK

  Include this unit in your project to control your Logitech devices.
  It uses the G SDK (see https://www.logitechg.com/en-us/innovation/developer-lab.html)

  - LogitechLedEnginesWrapper.dll needs to be distributed along with your application.
  - Initialize with LogiLedInitWithName.
  - Call LogiLedShutdown upon closing.

  https://github.com/WouterVanNifterick/delphi-GSDK

  Wouter van Nifterick, 2021
}


interface

uses
  System.UITypes,
  System.Types,
  System.SysUtils;

const LogitechDll = 'LogitechLedEnginesWrapper.dll';

type
  TKeyName = (
    ESC = $01,
    F1  = $3b,
    F2  = $3c,
    F3  = $3d,
    F4  = $3e,
    F5  = $3f,
    F6  = $40,
    F7  = $41,
    F8  = $42,
    F9  = $43,
    F10 = $44,
    F11 = $57,
    F12 = $58,

    PRINT_SCREEN = $137,
    SCROLL_LOCK  = $46,
    PAUSE_BREAK  = $145,


    TILDE        = $29,
    ONE          = $02,
    TWO          = $03,
    THREE        = $04,
    FOUR         = $05,
    FIVE         = $06,
    SIX          = $07,
    SEVEN        = $08,
    EIGHT        = $09,
    NINE         = $0a,
    ZERO         = $0b,
    MINUS        = $0c,
    &EQUALS      = $0d,
    BACKSPACE    = $0e,

    INSERT       = $152,
    HOME         = $147,
    PAGE_UP      = $149,

    NUM_LOCK     = $45,
    NUM_SLASH    = $135,
    NUM_ASTERISK = $37,
    NUM_MINUS    = $4a,

    TAB = $0f,
    Q   = $10,
    W   = $11,
    E   = $12,
    R   = $13,
    T   = $14,
    Y   = $15,
    U   = $16,
    I   = $17,
    O   = $18,
    P   = $19,
    OPEN_BRACKET  = $1a,
    CLOSE_BRACKET = $1b,
    BACKSLASH     = $2b,

    KEYBOARD_DELETE = $153,
    &END            = $14f,
    PAGE_DOWN       = $151,

    NUM_SEVEN = $47,
    NUM_EIGHT = $48,
    NUM_NINE  = $49,
    NUM_PLUS  = $4e,

    CAPS_LOCK = $3a,
    A = $1e,
    S = $1f,
    D = $20,
    F = $21,
    G = $22,
    H = $23,
    J = $24,
    K = $25,
    L = $26,
    SEMICOLON  = $27,
    APOSTROPHE = $28,
    ENTER      = $1c,

    NUM_FOUR = $4b,
    NUM_FIVE = $4c,
    NUM_SIX  = $4d,

    LEFT_SHIFT = $2a,
    Z = $2c,
    X = $2d,
    C = $2e,
    V = $2f,
    B = $30,
    N = $31,
    M = $32,
    COMMA         = $33,
    PERIOD        = $34,
    FORWARD_SLASH = $35,
    RIGHT_SHIFT   = $36,

    ARROW_UP  = $148,

    NUM_ONE   = $4f,
    NUM_TWO   = $50,
    NUM_THREE = $51,
    NUM_ENTER = $11c,

    LEFT_CONTROL       = $1d,
    LEFT_WINDOWS       = $15b,
    LEFT_ALT           = $38,
    SPACE              = $39,
    RIGHT_ALT          = $138,
    RIGHT_WINDOWS      = $15c,
    APPLICATION_SELECT = $15d,
    RIGHT_CONTROL      = $11d,
    ARROW_LEFT         = $14b,
    ARROW_DOWN         = $150,
    ARROW_RIGHT        = $14d,
    NUM_ZERO           = $52,
    NUM_PERIOD         = $53,

    G_1 = $fff1,
    G_2 = $fff2,
    G_3 = $fff3,
    G_4 = $fff4,
    G_5 = $fff5,
    G_6 = $fff6,
    G_7 = $fff7,
    G_8 = $fff8,
    G_9 = $fff9,

    G_LOGO  = $ffff1,
    G_BADGE = $ffff2
  );

  DeviceType = (
    Keyboard = $0,
    Mouse    = $3,
    Mousemat = $4,
    Headset  = $8,
    Speaker  = $e
  );

  const
    LOGI_DEVICETYPE_MONOCHROME_ORD = 0;
    LOGI_DEVICETYPE_RGB_ORD        = 1;
    LOGI_DEVICETYPE_PERKEY_RGB_ORD = 2;

    LOGI_DEVICETYPE_MONOCHROME     = 1 shl LOGI_DEVICETYPE_MONOCHROME_ORD;
    LOGI_DEVICETYPE_RGB            = 1 shl LOGI_DEVICETYPE_RGB_ORD;
    LOGI_DEVICETYPE_PERKEY_RGB     = 1 shl LOGI_DEVICETYPE_PERKEY_RGB_ORD;
    LOGI_DEVICETYPE_ALL            = LOGI_DEVICETYPE_MONOCHROME or LOGI_DEVICETYPE_RGB or LOGI_DEVICETYPE_PERKEY_RGB;

    LOGI_LED_BITMAP_WIDTH          = 21;
    LOGI_LED_BITMAP_HEIGHT         = 6;
    LOGI_LED_BITMAP_BYTES_PER_KEY  = 4;

    LOGI_LED_BITMAP_SIZE           = LOGI_LED_BITMAP_WIDTH * LOGI_LED_BITMAP_HEIGHT * LOGI_LED_BITMAP_BYTES_PER_KEY;
    LOGI_LED_DURATION_INFINITE     = 0;

  type
    TGsdkBitmap = packed array[0..pred(LOGI_LED_BITMAP_HEIGHT),0..pred(LOGI_LED_BITMAP_WIDTH)] of TAlphaColor;
    PGsdkBitmap = ^TGsdkBitmap;

  function LogiLedInit: Boolean; cdecl; external LogitechDll;
  function LogiLedInitWithName(name: string): Boolean; cdecl; external LogitechDll;
  function LogiLedGetConfigOptionNumber(configPath: PWideChar; var defaultNumber: Double): Boolean; cdecl; external LogitechDll;
  function LogiLedGetConfigOptionBool(configPath: PWideChar; var defaultValue: Boolean): Boolean; cdecl; external LogitechDll;
  function LogiLedGetConfigOptionColor(configPath: PWideChar; var defaultRed: Integer; var defaultGreen: Integer; var defaultBlue: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedGetConfigOptionRect(configPath: PWideChar; var defaultX, defaultY, defaultWidth, defaultHeight: Integer): Boolean; cdecl; external LogitechDll; overload;
  function LogiLedGetConfigOptionKeyInput(configPath: PWideChar; buffer: PWideChar; bufsize: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedGetConfigOptionString(configPath: PWideChar; defaultValue:PWideChar; var bufferSize:Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSetTargetDevice(targetDevice: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedGetSdkVersion(var majorNum: Integer; var minorNum: Integer; var buildNum: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSaveCurrentLighting: Boolean; cdecl; external LogitechDll;
  function LogiLedSetLighting(redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll;overload;
  function LogiLedRestoreLighting: Boolean; cdecl; external LogitechDll;
  function LogiLedFlashLighting(redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer; milliSecondsDuration: Integer; milliSecondsInterval: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedPulseLighting(redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer; milliSecondsDuration: Integer; milliSecondsInterval: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedStopEffects: Boolean; cdecl; external LogitechDll;
  function LogiLedExcludeKeysFromBitmap(keyList: array of TKeyName; listCount: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSetLightingFromBitmap(bitmap: PByte): Boolean; cdecl; external LogitechDll; overload;
  function LogiLedSetLightingForKeyWithScanCode(keyCode: Integer; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSetLightingForKeyWithHidCode(keyCode: Integer; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSetLightingForKeyWithQuartzCode(keyCode: Integer; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedSetLightingForKeyWithKeyName(keyCode: TKeyName; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll; overload;
  function LogiLedSaveLightingForKey(keyName: TKeyName): Boolean; cdecl; external LogitechDll;
  function LogiLedRestoreLightingForKey(keyName: TKeyName): Boolean; cdecl; external LogitechDll;
  function LogiLedFlashSingleKey(keyName: TKeyName; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer; msDuration: Integer; msInterval: Integer): Boolean; cdecl; external LogitechDll;
  function LogiLedPulseSingleKey(keyName: TKeyName; startRedPercentage: Integer; startGreenPercentage: Integer; startBluePercentage: Integer; finishRedPercentage: Integer; finishGreenPercentage: Integer; finishBluePercentage: Integer; msDuration: Integer; isInfinite: Boolean): Boolean; cdecl; external LogitechDll; overload;
  function LogiLedStopEffectsOnKey(keyName: TKeyName): Boolean; cdecl; external LogitechDll;
  function LogiLedSetLightingForTargetZone(DeviceType: DeviceType; zone: Integer; redPercentage: Integer; greenPercentage: Integer; bluePercentage: Integer): Boolean; cdecl; external LogitechDll; overload;
  procedure LogiLedShutdown; cdecl; external LogitechDll;

  // some convenience alternatives, so that you can pass TColor instead of R,G,B percentages.
  function LogiLedSetLighting(color:TColor): Boolean; overload;
  function LogiLedSetLightingForKeyWithKeyName(keyCode: TKeyName; color: TColor): Boolean; overload;
  function LogiLedSetLightingForTargetZone(DeviceType: DeviceType; zone: Integer; color: TColor): Boolean; overload;
  function LogiLedPulseSingleKey(keyName: TKeyName; startColor: TColor; finishColor: TColor; msDuration: Integer; isInfinite: Boolean): Boolean; overload;
  function LogiLedGetConfigOptionRect(configPath: string; var rect: TRect): Boolean; overload;


implementation

function ToPerc(aValue:Byte):Byte; inline;
begin
  Result := Round(100 * aValue / 256)
end;

function LogiLedSetLighting(color:TColor): Boolean; overload;
var c: TColorRec absolute color;
begin
  Result := LogiLedSetLighting(ToPerc(c.R), ToPerc(c.G), ToPerc(c.B))
end;


function LogiLedSetLightingForKeyWithKeyName(keyCode: TKeyName; color:TColor ): Boolean; overload;
var c: TColorRec absolute color;
begin
  Result :=
    LogiLedSetLightingForKeyWithKeyName(
      keyCode,
      ToPerc(c.R), ToPerc(c.G), ToPerc(c.B)
    )
end;


function LogiLedSetLightingForTargetZone(deviceType: DeviceType; zone: Integer; color:TColor): Boolean; overload;
var c: TColorRec absolute color;
begin
  Result := LogiLedSetLightingForTargetZone(
      DeviceType,
      zone,
      ToPerc(c.R), ToPerc(c.G), ToPerc(c.B)
    )
end;


function LogiLedPulseSingleKey(keyName: TKeyName; startColor:TColor; finishColor:TColor; msDuration: Integer; isInfinite: Boolean): Boolean; overload;
var
  c1: TColorRec absolute startColor;
  c2: TColorRec absolute finishColor;
begin
  Result := LogiLedPulseSingleKey(
      keyName,
      ToPerc(c1.R), ToPerc(c1.G), ToPerc(c1.B),
      ToPerc(c2.R), ToPerc(c2.G), ToPerc(c2.B),
      msDuration,
      isInfinite
    )
end;


function LogiLedGetConfigOptionRect(configPath: string; var rect: TRect): Boolean; overload;
var x,y,w,h:Integer;
begin
  Result := LogiLedGetConfigOptionRect(PChar(configPath),x,y,w,h);
  rect.Left := x;
  rect.Top := y;
  rect.Width := w;
  rect.Height := h;
end;


end.
