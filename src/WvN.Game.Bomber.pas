unit WvN.Game.Bomber;

interface

uses System.Types;

type
  TBomberGame=class
    type
      TBombType=(btBomb,btRocket);
    var
      cols,Rows:integer;

      Buildings : array of Integer;

      Bomber : TPointF;
      Bomb : TPointF;
      BombType:TBombType;
      BombCounter:integer;

      Score,HighScore:Integer;

      Speed : Double;

      GameState : (gsNone,gsPlaying,gsGameOver);

    constructor Create(aCols,aRows,aSpeed:integer);
    procedure Start;
    procedure Init;
    procedure Tick;
    procedure GameOver;
    procedure DropBomb(t:TBombType);
  end;


implementation

constructor TBomberGame.Create(aCols,aRows,aSpeed:integer);
begin
  cols := aCols;
  Rows := aRows;
  Speed := aSpeed;
  Init;
  GameState := gsNone;
end;

procedure TBomberGame.Start;
begin
  Init;
  GameState := gsPlaying;
end;

procedure TBomberGame.DropBomb(t:TBombType);
begin
  // bomb active already?
  if BombCounter>=0 then
    Exit;

  BombType := t;
  Bomb.X := Bomber.X;
  Bomb.Y := Bomber.Y;
  BombCounter := 0;
end;

procedure TBomberGame.GameOver;
begin
  GameState := gsGameOver;
end;

procedure TBomberGame.Init;
var i:Integer;
begin
  SetLength(Buildings, Cols);

  for I := 0 to High(Buildings) do
    Buildings[I] := Random(rows - 1);

  Bomber.X := 0;
  Bomber.Y := 0;

  Bomb.X := -10;
  Bomb.Y := -10;

  BombCounter := -1
end;


procedure TBomberGame.Tick;
var BombStrength:integer;
begin
  // advance bomber
  Bomber.X := Bomber.X + 1/cols/Speed;
  if Bomber.X >= 1 then
  begin
    Bomber.X := 0;
    Bomber.Y := Bomber.Y + 1 / rows;
  end;

  Assert(Bomber.X<1);

  // advance bomb
  case BombType of
    btBomb:
      if Bomb.Y >= 0 then
      begin
        Bomb.Y := Bomb.Y + 3/Rows/Speed;
        if Bomb.Y > 1 then
        begin
          Bomb.Y := -10;
          BombCounter := -1;
        end;
      end;

    btRocket:
      // advance rocket
      if Bomb.X >= 0 then
      begin
        Bomb.X := Bomb.X + 2/Rows/Speed;
        if Bomb.X > 1 then
        begin
          Bomb.X := 0;
          Bomb.Y := Bomb.Y + 1 / rows;
        end;
      end;
  end;



  // check for collision of bomb
  if BombCounter>=0 then
    if Rows - Buildings[Trunc(Bomb.X * Cols)] <= (Bomb.Y * rows) then
    begin
      if Buildings[Trunc(Bomb.X * Cols)]>0 then
      begin
        case BombType of
          btBomb: BombStrength := 1;
          btRocket: BombStrength := 3;
        else
          BombStrength := 0;
        end;
        Dec(Buildings[Trunc(Bomb.X * Cols)],BombStrength);
        Inc(BombCounter,BombStrength);
        Inc(Score,BombStrength);
        if Score>HighScore then
          HighScore := Score;
      end;
      if (BombCounter > 5) or (BombType=btRocket) then
      begin
        Bomb.X := -10;
        Bomb.Y := -10;
        BombCounter := -1;
      end;
    end;

  // check for collision of bomber
  if Rows - Buildings[Trunc(Bomber.X * Cols)] < (Bomber.Y * Rows) then
  begin
    GameOver;
    Exit;
  end;


end;



end.
