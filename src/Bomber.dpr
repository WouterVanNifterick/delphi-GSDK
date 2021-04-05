program Bomber;

{$APPTYPE CONSOLE}

{$R *.res}
{$R+}

uses
  Windows,
  WvN.Console,
  WvN.game.Bomber,
  LogitechGSDK,
  Vcl.Graphics,
  System.Threading,
  System.SysUtils,
  System.UITypes;

procedure TryInit;
begin
  // Initialize the LED SDK
  if LogiLedInitWithName('SetTargetZone Sample Delphi') then
    Exit;

  WriteLn('LogiLedInit() failed.');
  Halt;
end;


procedure ShowOnConsole(buf:TGsdkBitmap);
var
  x_,y_:integer;
  c:string;
begin
    Console.Clear;
    for y_ := 0 to high(buf)-1 do
    begin
      for x_ := 1 to high(buf[y_]) do
      begin
        case buf[y_,x_] of
          TAlphaColors.Yellow  : c := 'Y';
          TAlphaColors.Cyan    : c := 'C';
          TAlphaColors.Magenta : c := 'M';
          TAlphaColors.White   : c := 'W';
          TAlphaColors.Blue    : c := 'B';
          TAlphaColors.Black   : c := 'Z';
          TAlphaColors.Red     : c := 'R';
          TAlphaColors.Green   : c := 'G';
          else                 c := 'z';
        end;
        WriteC(format('~%s ', [c]));
      end;
      WritelnC('~z ');
    end;
end;


procedure UpdateGame(g: TBomberGame; buffer:TGsdkBitmap);
var
  x, y: integer;

  procedure FlipBuffer;
  begin
    ShowOnConsole(buffer);
    LogiLedSetLightingFromBitmap(@buffer[0]);
  end;
begin
  if g.GameState = gsNone then
  begin
    Console.Clear;
    Console.GotoXY(0,0);
    WriteLnC('~z^WPress S to start');
    FlipBuffer;
    Exit;
  end;

  // draw score
  // Console.WriteLine(0,0,Format('Score:%d   HighScore:%d ',[g.Score,g.HighScore]);

  if g.GameState = gsGameOver then
  begin
    WriteLnC('~z^WGame Over.');
    Console.WriteLine(g.bomber.x.tostring);
    Console.WriteLine(g.bomber.y.tostring);
    Console.WriteLine(g.Buildings[trunc(g.Bomber.X)*g.cols].tostring);
    FlipBuffer;
    Exit;
  end;

  g.Tick;


  for x := 0 to g.cols - 1 do
  begin
    // draw sky
    for y := 0 to g.rows - g.Buildings[x]  do
      if(y>=0) and (y<g.Rows) then
      if(x>=0) and (x<g.cols) then
        buffer[y, x] := TAlphaColors.Blue;

    // draw building
    for y := g.rows - g.Buildings[x]+1 to g.rows-1 do
      buffer[y, x] := TAlphaColors.White;
  end;

  // draw helicopter
  buffer[trunc(g.Bomber.y * g.rows), trunc(g.Bomber.x * g.cols)] := TAlphaColors.Red;

  // draw bomb
  if g.BombCounter>=0 then
    if g.Bomb.Y < 1 then
      if g.Bomber.X < 1 then
      begin
        var y_ := trunc(1 + g.Bomb.y * g.rows);
        if y_ < LOGI_LED_BITMAP_HEIGHT then
          buffer[y_, trunc(g.Bomb.x * g.cols)] := TAlphaColors.Yellow;
      end;

  FlipBuffer;
end;

procedure Main;
var
  game: TBomberGame;
  t:ITask;
  buffer:TGsdkBitmap;
begin
  SetConsoleOutputCP(CP_OEMCP);
  Console.CursorVisible := False;
  Console.Clear;
  TryInit;

  buffer := default(TGsdkBitmap);
  game := TBomberGame.Create(LOGI_LED_BITMAP_WIDTH, LOGI_LED_BITMAP_HEIGHT, 30);

  t := TTask.Create(
    procedure
    var
      key:TConsoleKeyInfo;
    begin
      repeat
        key := Console.ReadKey(true);
        if TConsoleModifiers.Control in key.Modifiers then
          game.DropBomb(btRocket);
        case key.Key of
          TConsoleKey.Spacebar: game.DropBomb(btBomb);
          TConsoleKey.Q : game.GameState := gsNone;
          TConsoleKey.S : game.Start;
          TConsoleKey.X : Halt;
        end;
      until (game.GameState = gsGameOver);
    end
  );

  t.Start;

  game.Start;

  repeat
    UpdateGame(game, buffer);
    Sleep(5);
  until (game.GameState = gsGameOver);

  LogiLedShutdown;
  Halt;
end;

begin
  try
    Main;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

