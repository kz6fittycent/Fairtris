unit Fairtris.BestScores;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  FGL,
  IniFiles;


type
  TCustomScore = class(TObject)
  private
    FLinesCleared: Integer;
    FLevelBegin: Integer;
    FLevelEnd: Integer;
    FTetrisRate: Integer;
    FTotalScore: Integer;
  protected
    FValid: Boolean;
  protected
    procedure Validate(); virtual;
  public
    procedure Load(AFile: TIniFile; const ASection: String);
    procedure Save(AFile: TIniFile; const ASection: String);
  end;


type
  TBestScores = class(TObject)
  public
    procedure Load();
    procedure Save();
  end;


var
  BestScores: TBestScores;


implementation

uses
  Math,
  Fairtris.Constants;


procedure TScoreEntry.Validate();
begin
  FValid := InRange(FLinesCleared, 0, 999);

  FValid := FValid and InRange(FLevelBegin, LEVEL_FIRST, LEVEL_LAST);
  FValid := FValid and InRange(FLevelEnd,   LEVEL_FIRST, 99);

  FValid := FValid and (FLevelBegin <= FLevelEnd);

  FValid := FValid and InRange(FTetrisRate, 0, 100);
  FValid := FValid and InRange(FTotalScore, 0, 9999999);
end;


procedure TScoreEntry.Load(AFile: TIniFile; const ASection: String);
begin
  FLinesCleared := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, -1);

  FLevelBegin := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, -1);
  FLevelEnd   := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   -1);

  FTetrisRate := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, -1);
  FTotalScore := AFile.ReadInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, -1);

  Validate();
end;


procedure TScoreEntry.Save(AFile: TIniFile; const ASection: String);
begin
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LINES_CLEARED, FLinesCleared);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_BEGIN, FLevelBegin);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_LEVEL_END,   FLevelEnd);

  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TETRIS_RATE, FTetrisRate);
  AFile.WriteInteger(ASection, BEST_SCORES_KEY_SCORE_TOTAL_SCORE, FTotalScore);
end;


procedure TBestScores.Load();
begin

end;


procedure TBestScores.Save();
begin

end;


end.

