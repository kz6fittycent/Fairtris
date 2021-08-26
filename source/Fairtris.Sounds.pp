unit Fairtris.Sounds;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2_Mixer,
  Fairtris.Constants;


type
  TRegionSounds = class(TObject)
  private type
    TSounds = array [SOUND_FIRST .. SOUND_LAST] of PMix_Chunk;
  private
    FSounds: TSounds;
    FSoundsPath: String;
  private
    function GetSound(ASoundID: Integer): PMix_Chunk;
  public
    constructor Create(const APath: String);
    destructor Destroy(); override;
  public
    procedure Load();
  public
    property Sound[ASoundID: Integer]: PMix_Chunk read GetSound; default;
  end;


type
  TSounds = class(TObject)
  private
    FEnabled: Integer;
  public
    procedure Initilize();
  public
    procedure PlaySound(ASound: Integer);
  public
    property Enabled: Integer read FEnabled write FEnabled;
  end;


var
  Sounds: TSounds;


implementation

uses
  Fairtris.Settings,
  Fairtris.Arrays;


constructor TRegionSounds.Create(const APath: String);
begin
  FSoundsPath := APath;
end;


destructor TRegionSounds.Destroy();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
    Mix_FreeChunk(FSounds[Index]);

  inherited Destroy();
end;


function TRegionSounds.GetSound(ASoundID: Integer): PMix_Chunk;
begin
  Result := FSounds[ASoundID];
end;


procedure TRegionSounds.Load();
var
  Index: Integer;
begin
  for Index := Low(FSounds) to High(FSounds) do
  begin
    FSounds[Index] := Mix_LoadWAV(PChar(FSoundsPath + SOUND_FILENAME[Index]));

    if FSounds[Index] = nil then Halt();
  end;
end;


procedure TSounds.Initilize();
begin
  FEnabled := Settings.General.Sounds;
end;


procedure TSounds.PlaySound(ASound: Integer);
begin
  if ASound = SOUND_UNKNOWN then Exit;
  if FEnabled = SOUNDS_DISABLED then Exit;

  // play sound here
end;


end.

