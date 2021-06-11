unit Fairtris.Logic;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  Fairtris.Classes;


type
  TScene = specialize TCustomState<Integer>;


type
  TLogic = class(TObject)
  private
    FScene: TScene;
    FStopped: Boolean;
  private
    procedure HelpUnderstand();
    procedure HelpControl();
  private
    procedure PreparePlaySelection();
  private
    procedure PreparePauseSelection();
    procedure PreparePauseScene();
  private
    procedure PrepareTopOutSelection();
    procedure PrepareTopOutResult();
  private
    procedure PrepareOptionsSelection();
    procedure PrepareOptionsScene();
  private
    procedure PrepareKeyboardSelection();
    procedure PrepareKeyboardScanCodes();
  private
    procedure PrepareControllerSelection();
    procedure PrepareControllerScanCodes();
  private
    procedure PreparePlay();
    procedure PreparePause();
    procedure PrepareTopOut();
    procedure PreapreOptions();
    procedure PrepareKeyboard();
    procedure PrepareController();
    procedure PrepareQuit();
  private
    procedure UpdateLegalHang();
    procedure UpdateLegalScene();
  private
    procedure UpdateMenuSelection();
    procedure UpdateMenuScene();
  private
    procedure UpdatePlaySelection();
    procedure UpdatePlayRegion();
    procedure UpdatePlayRNG();
    procedure UpdatePlayLevel();
    procedure UpdatePlayScene();
  private
    procedure UpdateGameScene();
  private
    procedure UpdatePauseSelection();
    procedure UpdatePauseScene();
  private
    procedure UpdateTopOutSelection();
    procedure UpdateTopOutScene();
  private
    procedure UpdateOptionsSelection();
    procedure UpdateOptionsInput();
    procedure UpdateOptionsWindow();
    procedure UpdateOptionsTheme();
    procedure UpdateOptionsSounds();
    procedure UpdateOptionsScroll();
    procedure UpdateOptionsScene();
  private
    procedure UpdateKeyboardItemSelection();
    procedure UpdateKeyboardKeySelection();
    procedure UpdateKeyboardKeyScanCode();
    procedure UpdateKeyboardScene();
  private
    procedure UpdateControllerItemSelection();
    procedure UpdateControllerButtonSelection();
    procedure UpdateControllerButtonScanCode();
    procedure UpdateControllerScene();
  private
    procedure UpdateQuitHang();
    procedure UpdateQuitScene();
  private
    procedure UpdateCommon();
    procedure UpdateLegal();
    procedure UpdateMenu();
    procedure UpdatePlay();
    procedure UpdateGame();
    procedure UpdatePause();
    procedure UpdateTopOut();
    procedure UpdateOptions();
    procedure UpdateKeyboard();
    procedure UpdateController();
    procedure UpdateQuit();
  public
    constructor Create();
    destructor Destroy(); override;
  public
    procedure Update();
    procedure Reset();
    procedure Stop();
  public
    property Scene: TScene read FScene;
    property Stopped: Boolean read FStopped;
  end;


var
  Logic: TLogic;


implementation

uses
  Windows,
  Math,
  Forms,
  Fairtris.Clock,
  Fairtris.Buffers,
  Fairtris.Input,
  Fairtris.Memory,
  Fairtris.Placement,
  Fairtris.Renderers,
  Fairtris.Grounds,
  Fairtris.Sounds,
  Fairtris.Arrays,
  Fairtris.Constants;


constructor TLogic.Create();
begin
  FScene := TScene.Create({$IFDEF MODE_DEBUG} SCENE_MENU {$ELSE} SCENE_LEGAL {$ENDIF});
end;


destructor TLogic.Destroy();
begin
  FScene.Free();
  inherited Destroy();
end;


procedure TLogic.HelpUnderstand();
begin
  Sounds.PlaySound(SOUND_START, Memory.Play.Region);

  ShellExecute(0, 'open', 'https://github.com/furious-programming/fairtris', nil, nil, SW_SHOWNORMAL);
  Application.Minimize();
end;


procedure TLogic.HelpControl();
begin
  Input.Keyboard.Restore();
  Input.DeviceID := INPUT_KEYBOARD;

  Memory.Options.Input := INPUT_KEYBOARD;

  PrepareKeyboardScanCodes();
  Sounds.PlaySound(SOUND_TRANSITION, Memory.Play.Region);
end;


procedure TLogic.PreparePlaySelection();
begin
  Memory.Play.ItemIndex := ITEM_PLAY_FIRST;
end;


procedure TLogic.PreparePauseSelection();
begin
  Memory.Pause.ItemIndex := IfThen(Input.Device.Connected, ITEM_PAUSE_FIRST, ITEM_PAUSE_OPTIONS);
end;


procedure TLogic.PreparePauseScene();
begin
  if FScene.Previous in [SCENE_GAME_NORMAL, SCENE_GAME_FLASH] then
    Memory.Pause.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareTopOutSelection();
begin
  Memory.TopOut.ItemIndex := ITEM_TOP_OUT_FIRST;
end;


procedure TLogic.PrepareTopOutResult();
begin
  // tu ustawić dane dotyczące gry i wpisać je do pól "Memory.TopOut"
end;


procedure TLogic.PrepareOptionsSelection();
begin
  Memory.Options.ItemIndex := ITEM_OPTIONS_FIRST;
end;


procedure TLogic.PrepareOptionsScene();
begin
  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
    Memory.Options.FromScene := FScene.Previous;
end;


procedure TLogic.PrepareKeyboardSelection();
begin
  Memory.Keyboard.ItemIndex := ITEM_KEYBOARD_FIRST;
  Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
end;


procedure TLogic.PrepareKeyboardScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Keyboard.ScanCodes) to High(Memory.Keyboard.ScanCodes) do
    Memory.Keyboard.ScanCodes[Index] := Input.Keyboard.ScanCode[Index];
end;


procedure TLogic.PrepareControllerSelection();
begin
  Memory.Controller.ItemIndex := ITEM_CONTROLLER_FIRST;
  Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
end;


procedure TLogic.PrepareControllerScanCodes();
var
  Index: Integer;
begin
  for Index := Low(Memory.Controller.ScanCodes) to High(Memory.Controller.ScanCodes) do
    Memory.Controller.ScanCodes[Index] := Input.Controller.ScanCode[Index];
end;


procedure TLogic.PreparePlay();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_MENU then
    PreparePlaySelection();
end;


procedure TLogic.PreparePause();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous <> SCENE_OPTIONS then
  begin
    PreparePauseSelection();
    PreparePauseScene();
  end;
end;


procedure TLogic.PrepareTopOut();
begin
  if FScene.Changed then
  begin
    PrepareTopOutSelection();
    PrepareTopOutResult();
  end;
end;


procedure TLogic.PreapreOptions();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous in [SCENE_MENU, SCENE_PAUSE] then
  begin
    PrepareOptionsSelection();
    PrepareOptionsScene();
  end;
end;


procedure TLogic.PrepareKeyboard();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareKeyboardSelection();
    PrepareKeyboardScanCodes();
  end;
end;


procedure TLogic.PrepareController();
begin
  if not FScene.Changed then Exit;

  if FScene.Previous = SCENE_OPTIONS then
  begin
    PrepareControllerSelection();
    PrepareControllerScanCodes();
  end;
end;


procedure TLogic.PrepareQuit();
begin
  if not FScene.Changed then Exit;

  Memory.Quit.Buffer.Canvas.Draw(0, 0, Buffers.Native);
  Memory.Quit.Buffer.Canvas.Draw(0, 0, Grounds[Memory.Options.Theme][SCENE_QUIT]);
end;


procedure TLogic.UpdateLegalHang();
begin
  Memory.Legal.FrameIndex := Memory.Legal.FrameIndex + 1;
end;


procedure TLogic.UpdateLegalScene();
begin
  FScene.Validate();

  if Memory.Legal.FrameIndex = DURATION_HANG_LEGAL * Clock.FrameRateLimit then
    FScene.Current := SCENE_MENU;
end;


procedure TLogic.UpdateMenuSelection();
begin
  if Memory.Menu.ItemIndex > ITEM_MENU_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Menu.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Menu.ItemIndex < ITEM_MENU_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Menu.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateMenuScene();
begin
  FScene.Validate();

  if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
  begin
    case Memory.Menu.ItemIndex of
      ITEM_MENU_PLAY:    FScene.Current := SCENE_PLAY;
      ITEM_MENU_OPTIONS: FScene.Current := SCENE_OPTIONS;
      ITEM_MENU_QUIT:    FScene.Current := SCENE_QUIT;
    end;

    if Memory.Menu.ItemIndex <> ITEM_MENU_QUIT then
      Sounds.PlaySound(SOUND_START, Memory.Play.Region)
    else
      Sounds.PlaySound(SOUND_GLASS, Memory.Play.Region);

    if Memory.Menu.ItemIndex = ITEM_MENU_HELP then
      HelpUnderstand();
  end;
end;


procedure TLogic.UpdatePlaySelection();
begin
  if Memory.Play.ItemIndex > ITEM_PLAY_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Play.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Play.ItemIndex < ITEM_PLAY_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Play.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdatePlayRegion();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_REGION then Exit;

  if Memory.Play.Region > REGION_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Play.Region -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Play.Region < REGION_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Play.Region += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  Clock.FrameRateLimit := CLOCK_FRAMERATE_LIMIT[Memory.Play.Region];

  if Memory.Play.Region in [REGION_PAL .. REGION_LAST] then
    Memory.Play.Level := Min(Memory.Play.Level, LEVEL_LAST_PAL);
end;


procedure TLogic.UpdatePlayRNG();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_RNG then Exit;

  if Memory.Play.RNG > RNG_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Play.RNG -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Play.RNG < RNG_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Play.RNG += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdatePlayLevel();
begin
  if Memory.Play.ItemIndex <> ITEM_PLAY_LEVEL then Exit;

  if Memory.Play.Level > LEVEL_FIRST[Memory.Play.Region] then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Play.Level -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Play.Level < LEVEL_LAST[Memory.Play.Region] then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Play.Level += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdatePlayScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.Play.ItemIndex = ITEM_PLAY_START then
    begin
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

      Exit;
    end;

  if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
  begin
    FScene.Current := SCENE_MENU;
    Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
  end;

  if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
  case Memory.Play.ItemIndex of
    ITEM_PLAY_START:
    begin
      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
    ITEM_PLAY_BACK:
    begin
      FScene.Current := SCENE_MENU;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateGameScene();
begin
  FScene.Validate();

  // tylko do testu sceny SCENE_GAME_FLASH:
  //
  {} if Input.Device.Up.JustPressed  then FScene.Current := SCENE_GAME_FLASH;
  {} if Input.Device.Up.JustReleased then FScene.Current := SCENE_GAME_NORMAL;
  //
  // później wywalić.

  // tylko do testu scen SCENE_PAUSE i SCENE_TOP_OUT:
  //
  {} if Input.Device.Start.JustPressed then
  {} begin
  {}   FScene.Current := SCENE_PAUSE;
  {}   Sounds.PlaySound(SOUND_PAUSE, Memory.Play.Region);
  {} end;
  {}
  {} if Input.Device.Select.JustPressed then
  {} begin
  {}   FScene.Current := SCENE_TOP_OUT;
  {}   Sounds.PlaySound(SOUND_TOP_OUT, Memory.Play.Region);
  {} end;
  //
  // później wywalić.

  if not Input.Device.Connected then
  begin
    FScene.Current := SCENE_PAUSE;
    Sounds.PlaySound(SOUND_PAUSE, Memory.Play.Region);
  end;
end;


procedure TLogic.UpdatePauseSelection();
begin
  if Memory.Pause.ItemIndex > ITEM_PAUSE_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Pause.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Pause.ItemIndex < ITEM_PAUSE_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Pause.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdatePauseScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.Pause.ItemIndex in [ITEM_PAUSE_RESUME, ITEM_PAUSE_RESTART] then
    begin
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

      if Input.Device.Start.JustPressed or Input.Keyboard.Start.JustPressed then
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

      Exit;
    end;

  if Memory.Pause.ItemIndex = ITEM_PAUSE_RESUME then
    if Input.Device.Start.JustPressed or Input.Keyboard.Start.JustPressed then
      FScene.Current := Memory.Pause.FromScene;

  if Input.Device.Start.JustPressed or Input.Device.A.JustPressed or Input.Keyboard.Start.JustPressed or Input.Keyboard.A.JustPressed then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_RESUME:
      FScene.Current := Memory.Pause.FromScene;
    ITEM_PAUSE_RESTART:
    begin
      // tu zresetować dane gry, aby zaczynano od początku

      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
  end;

  if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
  case Memory.Pause.ItemIndex of
    ITEM_PAUSE_OPTIONS:
    begin
      FScene.Current := SCENE_OPTIONS;
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
    ITEM_PAUSE_BACK:
    begin
      FScene.Current := SCENE_PLAY;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateTopOutSelection();
begin
  if Memory.TopOut.ItemIndex > ITEM_TOP_OUT_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.TopOut.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.TopOut.ItemIndex < ITEM_TOP_OUT_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.TopOut.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateTopOutScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
    if Memory.TopOut.ItemIndex = ITEM_TOP_OUT_PLAY then
    begin
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

      Exit;
    end;

  if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
  case Memory.TopOut.ItemIndex of
    ITEM_TOP_OUT_PLAY:
    begin
      // tu zresetować dane gry, tak aby zacząć od początku

      FScene.Current := SCENE_GAME_NORMAL;
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
    ITEM_TOP_OUT_BACK:
    begin
      FScene.Current := SCENE_PLAY;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateOptionsSelection();
begin
  if Memory.Options.ItemIndex > ITEM_OPTIONS_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Options.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Options.ItemIndex < ITEM_OPTIONS_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Options.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateOptionsInput();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_INPUT then Exit;

  if Memory.Options.Input > INPUT_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Options.Input -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Options.Input < INPUT_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Options.Input += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  Input.DeviceID := Memory.Options.Input;
end;


procedure TLogic.UpdateOptionsWindow();
begin
  Memory.Options.Window := Placement.WindowSize;

  if Memory.Options.ItemIndex <> ITEM_OPTIONS_WINDOW then Exit;

  if Memory.Options.Window > WINDOW_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Options.Window -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Options.Window < WINDOW_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Options.Window += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  Placement.WindowSize := Memory.Options.Window;
end;


procedure TLogic.UpdateOptionsTheme();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_THEME then Exit;

  if Memory.Options.Theme > THEME_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Options.Theme -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Options.Theme < THEME_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Options.Theme += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  Renderers.ThemeID := Memory.Options.Theme;
end;


procedure TLogic.UpdateOptionsSounds();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SOUNDS then Exit;

  if Memory.Options.Sounds > SOUNDS_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Options.Sounds -= 1;

      Sounds.Enabled := Memory.Options.Sounds;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Options.Sounds < SOUNDS_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Options.Sounds += 1;

      Sounds.Enabled := Memory.Options.Sounds;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateOptionsScroll();
begin
  if Memory.Options.ItemIndex <> ITEM_OPTIONS_SCROLL then Exit;

  if Memory.Options.Scroll > SCROLL_FIRST then
    if Input.Device.Left.JustPressed or Input.Keyboard.Left.JustPressed then
    begin
      Memory.Options.Scroll -= 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  if Memory.Options.Scroll < SCROLL_LAST then
    if Input.Device.Right.JustPressed or Input.Keyboard.Right.JustPressed then
    begin
      Memory.Options.Scroll += 1;
      Sounds.PlaySound(SOUND_SHIFT, Memory.Play.Region);
    end;

  Placement.Scroll := Memory.Options.Scroll;
end;


procedure TLogic.UpdateOptionsScene();
begin
  FScene.Validate();

  if not Input.Device.Connected then
  begin
    if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

    if Memory.Options.ItemIndex in [ITEM_OPTIONS_SET_UP, ITEM_OPTIONS_BACK] then
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

    Exit;
  end;

  if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
  begin
    FScene.Current := Memory.Options.FromScene;
    Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
  end;

  if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
  case Memory.Options.ItemIndex of
    ITEM_OPTIONS_SET_UP:
    case Memory.Options.Input of
      INPUT_KEYBOARD:
        if Input.Keyboard.Device.Connected then
        begin
          FScene.Current := SCENE_KEYBOARD;
          Sounds.PlaySound(SOUND_START, Memory.Play.Region);
        end;
      INPUT_CONTROLLER:
        if Input.Controller.Device.Connected then
        begin
          FScene.Current := SCENE_CONTROLLER;
          Sounds.PlaySound(SOUND_START, Memory.Play.Region);
        end;
      end;
    ITEM_OPTIONS_BACK:
    begin
      FScene.Current := Memory.Options.FromScene;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateKeyboardItemSelection();
begin
  if Memory.Keyboard.Changing or Memory.Keyboard.SettingUp then Exit;

  if Memory.Keyboard.ItemIndex > ITEM_KEYBOARD_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Keyboard.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Keyboard.ItemIndex < ITEM_KEYBOARD_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Keyboard.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  case Memory.Keyboard.ItemIndex of
    ITEM_KEYBOARD_CHANGE:
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Input.Device.A.Validate();
      Input.Keyboard.A.Validate();

      Memory.Keyboard.KeyIndex := ITEM_KEYBOARD_KEY_FIRST;
      Memory.Keyboard.Changing := True;

      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
    ITEM_KEYBOARD_RESTORE:
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Input.Keyboard.Restore();
      PrepareKeyboardScanCodes();

      Sounds.PlaySound(SOUND_TOP_OUT, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateKeyboardKeySelection();
begin
  if not Memory.Keyboard.Changing or Memory.Keyboard.SettingUp then Exit;

  if Memory.Keyboard.KeyIndex > ITEM_KEYBOARD_KEY_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Keyboard.KeyIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Keyboard.KeyIndex < ITEM_KEYBOARD_KEY_LAST then
  begin
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Keyboard.KeyIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

    if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_CLEAR_MAPPING].JustPressed then
    begin
      Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
      Sounds.PlaySound(SOUND_BURN, Memory.Play.Region);
    end;
  end;

  if Memory.Keyboard.KeyIndex in [ITEM_KEYBOARD_SCANCODE_FIRST .. ITEM_KEYBOARD_SCANCODE_LAST] then
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Memory.Keyboard.SettingUp := True;

      Input.Keyboard.Validate();
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;

  if Memory.Keyboard.KeyIndex = ITEM_KEYBOARD_KEY_BACK then
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;

  if not Memory.Keyboard.SettingUp then
    if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
    begin
      Input.Device.B.Validate();
      Input.Keyboard.B.Validate();

      Memory.Keyboard.Changing := False;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateKeyboardKeyScanCode();
var
  ScanCode: UInt8 = KEYBOARD_SCANCODE_KEY_NOT_MAPPED;
begin
  if not Memory.Keyboard.SettingUp then Exit;

  if Input.Keyboard.CatchedOneKey(ScanCode) then
  begin
    Memory.Keyboard.ScanCodes[Memory.Keyboard.KeyIndex] := ScanCode;
    Memory.Keyboard.SettingUp := False;
    Memory.Keyboard.RemoveDuplicates(ScanCode, Memory.Keyboard.KeyIndex);

    Sounds.PlaySound(SOUND_START, Memory.Play.Region);
  end;
end;


procedure TLogic.UpdateKeyboardScene();
begin
  FScene.Validate();

  if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
  begin
    Memory.Keyboard.Changing := False;
    Memory.Keyboard.SettingUp := False;

    FScene.Current := SCENE_OPTIONS;
    Exit;
  end;

  if not Memory.Keyboard.Changing then
  begin
    if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
    begin
      if Memory.Keyboard.MappedCorrectly() then
        FScene.Current := SCENE_OPTIONS;

      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;

    if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_SAVE then
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        if Memory.Keyboard.MappedCorrectly() then
        begin
          Input.Keyboard.Introduce();

          FScene.Current := SCENE_OPTIONS;
          Sounds.PlaySound(SOUND_TETRIS, Memory.Play.Region);
        end
        else
          Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

    if Memory.Keyboard.ItemIndex = ITEM_KEYBOARD_CANCEL then
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
      begin
        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
      end;
  end;
end;


procedure TLogic.UpdateControllerItemSelection();
begin
  if Memory.Controller.Changing or Memory.Controller.SettingUp then Exit;

  if Memory.Controller.ItemIndex > ITEM_CONTROLLER_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Controller.ItemIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Controller.ItemIndex < ITEM_CONTROLLER_LAST then
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Controller.ItemIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  case Memory.Controller.ItemIndex of
    ITEM_CONTROLLER_CHANGE:
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Input.Device.A.Validate();
      Input.Keyboard.A.Validate();

      Memory.Controller.ButtonIndex := ITEM_CONTROLLER_BUTTON_FIRST;
      Memory.Controller.Changing := True;

      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;
    ITEM_CONTROLLER_RESTORE:
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Input.Controller.Restore();
      PrepareControllerScanCodes();

      Sounds.PlaySound(SOUND_TOP_OUT, Memory.Play.Region);
    end;
  end;
end;


procedure TLogic.UpdateControllerButtonSelection();
begin
  if not Memory.Controller.Changing or Memory.Controller.SettingUp then Exit;

  if Memory.Controller.ButtonIndex > ITEM_CONTROLLER_BUTTON_FIRST then
    if Input.Device.Up.JustPressed or Input.Keyboard.Up.JustPressed then
    begin
      Memory.Controller.ButtonIndex -= 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

  if Memory.Controller.ButtonIndex < ITEM_CONTROLLER_BUTTON_LAST then
  begin
    if Input.Device.Down.JustPressed or Input.Keyboard.Down.JustPressed then
    begin
      Memory.Controller.ButtonIndex += 1;
      Sounds.PlaySound(SOUND_BLIP, Memory.Play.Region);
    end;

    if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_CLEAR_MAPPING].JustPressed then
    begin
      Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
      Sounds.PlaySound(SOUND_BURN, Memory.Play.Region);
    end;
  end;

  if Memory.Controller.ButtonIndex in [ITEM_CONTROLLER_SCANCODE_FIRST .. ITEM_CONTROLLER_SCANCODE_LAST] then
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Memory.Controller.SettingUp := True;

      Input.Controller.Validate();
      Sounds.PlaySound(SOUND_START, Memory.Play.Region);
    end;

  if Memory.Controller.ButtonIndex = ITEM_CONTROLLER_BUTTON_BACK then
    if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
    begin
      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;

  if not Memory.Controller.SettingUp then
    if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
    begin
      Input.Device.B.Validate();
      Input.Keyboard.B.Validate();

      Memory.Controller.Changing := False;
      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;
end;


procedure TLogic.UpdateControllerButtonScanCode();
var
  ScanCode: UInt8 = CONTROLLER_SCANCODE_BUTTON_NOT_MAPPED;
begin
  if not Memory.Controller.SettingUp then Exit;

  if Input.Controller.CatchedOneButton(ScanCode) then
  begin
    Memory.Controller.ScanCodes[Memory.Controller.ButtonIndex] := ScanCode;
    Memory.Controller.SettingUp := False;
    Memory.Controller.RemoveDuplicates(ScanCode, Memory.Controller.ButtonIndex);

    Sounds.PlaySound(SOUND_START, Memory.Play.Region);
  end;
end;


procedure TLogic.UpdateControllerScene();
begin
  FScene.Validate();

  if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
  begin
    Memory.Keyboard.Changing := False;
    Memory.Keyboard.SettingUp := False;

    FScene.Current := SCENE_OPTIONS;
    Exit;
  end;

  if not Input.Controller.Connected then
  begin
    FScene.Current := SCENE_OPTIONS;

    Memory.Controller.Changing := False;
    Memory.Controller.SettingUp := False;

    Sounds.PlaySound(SOUND_TOP_OUT, Memory.Play.Region);
    Exit;
  end;

  if not Memory.Controller.Changing then
  begin
    if Input.Device.B.JustPressed or Input.Keyboard.B.JustPressed then
    begin
      if Memory.Controller.MappedCorrectly() then
        FScene.Current := SCENE_OPTIONS;

      Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
    end;

    if Memory.Controller.ItemIndex = ITEM_CONTROLLER_SAVE then
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
        if Memory.Controller.MappedCorrectly() then
        begin
          Input.Controller.Introduce();

          FScene.Current := SCENE_OPTIONS;
          Sounds.PlaySound(SOUND_TETRIS, Memory.Play.Region);
        end
        else
          Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);

    if Memory.Controller.ItemIndex = ITEM_CONTROLLER_CANCEL then
      if Input.Device.A.JustPressed or Input.Keyboard.A.JustPressed then
      begin
        FScene.Current := SCENE_OPTIONS;
        Sounds.PlaySound(SOUND_DROP, Memory.Play.Region);
      end;
  end;
end;


procedure TLogic.UpdateQuitHang();
begin
  Memory.Quit.FrameIndex := Memory.Quit.FrameIndex + 1;
end;


procedure TLogic.UpdateQuitScene();
begin
  FScene.Validate();

  if Memory.Quit.FrameIndex = Round(DURATION_HANG_QUIT * Clock.FrameRateLimit) then
    FStopped := True;
end;


procedure TLogic.UpdateCommon();
begin
  Sounds.Smart := FScene.Current in [SCENE_GAME_NORMAL, SCENE_GAME_FLASH];

  if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_HELP_UNDERSTAND].JustPressed then
    HelpUnderstand();

  if Input.Keyboard.Device.Key[KEYBOARD_SCANCODE_KEY_HELP_CONTROL].JustPressed then
    HelpControl();

  if Input.Keyboard.Device.Key[VK_F10].JustPressed then
    Renderers.ClipFrame := not Renderers.ClipFrame;
end;


procedure TLogic.UpdateLegal();
begin
  UpdateLegalHang();
  UpdateLegalScene();
end;


procedure TLogic.UpdateMenu();
begin
  UpdateMenuSelection();
  UpdateMenuScene();
end;


procedure TLogic.UpdatePlay();
begin
  PreparePlay();

  UpdatePlaySelection();
  UpdatePlayRegion();
  UpdatePlayRNG();
  UpdatePlayLevel();
  UpdatePlayScene();
end;


procedure TLogic.UpdateGame();
begin
  UpdateGameScene();
end;


procedure TLogic.UpdatePause();
begin
  PreparePause();

  UpdatePauseSelection();
  UpdatePauseScene();
end;


procedure TLogic.UpdateTopOut();
begin
  PrepareTopOut();

  UpdateTopOutSelection();
  UpdateTopOutScene();
end;


procedure TLogic.UpdateOptions();
begin
  PreapreOptions();

  UpdateOptionsSelection();
  UpdateOptionsInput();
  UpdateOptionsWindow();
  UpdateOptionsTheme();
  UpdateOptionsSounds();
  UpdateOptionsScroll();
  UpdateOptionsScene();
end;


procedure TLogic.UpdateKeyboard();
begin
  PrepareKeyboard();

  UpdateKeyboardItemSelection();
  UpdateKeyboardKeySelection();
  UpdateKeyboardKeyScanCode();
  UpdateKeyboardScene();
end;


procedure TLogic.UpdateController();
begin
  PrepareController();

  UpdateControllerItemSelection();
  UpdateControllerButtonSelection();
  UpdateControllerButtonScanCode();
  UpdateControllerScene();
end;


procedure TLogic.UpdateQuit();
begin
  PrepareQuit();

  UpdateQuitHang();
  UpdateQuitScene();
end;


procedure TLogic.Update();
begin
  UpdateCommon();

  case FScene.Current of
    SCENE_LEGAL:       UpdateLegal();
    SCENE_MENU:        UpdateMenu();
    SCENE_PLAY:        UpdatePlay();
    SCENE_GAME_NORMAL: UpdateGame();
    SCENE_GAME_FLASH:  UpdateGame();
    SCENE_PAUSE:       UpdatePause();
    SCENE_TOP_OUT:     UpdateTopOut();
    SCENE_OPTIONS:     UpdateOptions();
    SCENE_KEYBOARD:    UpdateKeyboard();
    SCENE_CONTROLLER:  UpdateController();
    SCENE_QUIT:        UpdateQuit();
  end;
end;


procedure TLogic.Reset();
begin
  FScene.Reset();
end;


procedure TLogic.Stop();
begin
  if FScene.Current <> SCENE_QUIT then
  begin
    FScene.Current := SCENE_QUIT;
    Sounds.PlaySound(SOUND_GLASS, Memory.Play.Region);
  end;
end;


end.

