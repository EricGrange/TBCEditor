unit BCEditor.Editor.LeftMargin;

interface

uses
  Classes, Graphics, Controls,
  BCEditor.Editor.LeftMargin.Bookmarks, BCEditor.Editor.Bookmarks,
  BCEditor.Editor.LeftMargin.Border, BCEditor.Consts, BCEditor.Editor.LeftMargin.LineState,
  BCEditor.Editor.LeftMargin.LineNumbers, BCEditor.Editor.LeftMargin.Colors;

type
  TLeftMarginGetTextEvent = procedure(Sender: TObject; ALine: Integer; var AText: string) of object;
  TLeftMarginPaintEvent = procedure(Sender: TObject; ALine: Integer; X, Y: Integer) of object;
  TLeftMarginClickEvent = procedure(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Bookmark: TBCEditorBookmark) of object;

  TBCEditorLeftMargin = class(TPersistent)
  strict private
    FAutosize: Boolean;
    FBookMarks: TBCEditorLeftMarginBookMarks;
    FBorder: TBCEditorLeftMarginBorder;
    FColors: TBCEditorLeftMarginColors;
    FCursor: TCursor;
    FFont: TFont;
    FLineState: TBCEditorLeftMarginLineState;
    FLineNumbers: TBCEditorLeftMarginLineNumbers;
    FOnChange: TNotifyEvent;
    FVisible: Boolean;
    FWidth: Integer;
    procedure DoChange;
    procedure SetAutosize(const AValue: Boolean);
    procedure SetBookMarks(const AValue: TBCEditorLeftMarginBookMarks);
    procedure SetColors(const AValue: TBCEditorLeftMarginColors);
    procedure SetFont(AValue: TFont);
    procedure SetOnChange(AValue: TNotifyEvent);
    procedure SetVisible(const AValue: Boolean);
    procedure SetWidth(AValue: Integer);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function GetWidth: Integer;
    function FormatLineNumber(ALine: Integer): string;
    function RealLeftMarginWidth(ACharWidth: Integer): Integer;
    procedure Assign(ASource: TPersistent); override;
    procedure AutosizeDigitCount(ALinesCount: Integer);
  published
    property Autosize: Boolean read FAutosize write SetAutosize default True;
    property Bookmarks: TBCEditorLeftMarginBookMarks read FBookMarks write SetBookMarks;
    property Border: TBCEditorLeftMarginBorder read FBorder write FBorder;
    property Colors: TBCEditorLeftMarginColors read FColors write SetColors;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property Font: TFont read FFont write SetFont;
    property LineNumbers: TBCEditorLeftMarginLineNumbers read FLineNumbers write FLineNumbers;
    property LineState: TBCEditorLeftMarginLineState read FLineState write FLineState;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default 57;
  end;

implementation

uses
  SysUtils, Math, BCEditor.Types;

{ TBCEditorLeftMargin }

constructor TBCEditorLeftMargin.Create(AOwner: TComponent);
begin
  inherited Create;

  FAutosize := True;
  FColors := TBCEditorLeftMarginColors.Create;
  FCursor := crDefault;
  FBorder := TBCEditorLeftMarginBorder.Create;
  FFont := TFont.Create;
  FFont.Name := 'Courier New';
  FFont.Size := 8;
  FFont.Style := [];
  FFont.Color := clLeftMarginFontForeground;
  FWidth := 57;
  FVisible := True;

  FBookmarks := TBCEditorLeftMarginBookmarks.Create(AOwner);
  FLineState := TBCEditorLeftMarginLineState.Create;
  FLineNumbers := TBCEditorLeftMarginLineNumbers.Create;
end;

procedure TBCEditorLeftMargin.SetOnChange(AValue: TNotifyEvent);
begin
  FOnChange := AValue;

  FBookmarks.OnChange := AValue;
  FBorder.OnChange := AValue;
  FColors.OnChange := AValue;
  FFont.OnChange := AValue;
  FLineState.OnChange := AValue;
  FLineNumbers.OnChange := AValue;
end;

destructor TBCEditorLeftMargin.Destroy;
begin
  FBookmarks.Free;
  FBorder.Free;
  FColors.Free;
  FFont.Free;
  FLineState.Free;
  FLineNumbers.Free;
  inherited Destroy;
end;

procedure TBCEditorLeftMargin.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TBCEditorLeftMargin.RealLeftMarginWidth(ACharWidth: Integer): Integer;
var
  PanelWidth: Integer;
begin
  PanelWidth := FBookmarks.Panel.Width;
  if not FBookmarks.Panel.Visible and not FBookmarks.Visible then
    PanelWidth := 0;

  if not FVisible then
    Result := 0
  else
  if FLineNumbers.Visible then
    Result := PanelWidth + FLineState.Width + FLineNumbers.AutosizeDigitCount * ACharWidth + 5
  else
    Result := FWidth;
end;

procedure TBCEditorLeftMargin.Assign(ASource: TPersistent);
begin
  if ASource is TBCEditorLeftMargin then
  with ASource as TBCEditorLeftMargin do
  begin
    Self.FAutosize := FAutosize;
    Self.FBookmarks.Assign(FBookmarks);
    Self.FColors.Assign(FColors);
    Self.FBorder := FBorder;
    Self.FCursor := FCursor;
    Self.FFont.Assign(FFont);
    Self.FLineNumbers.Assign(FLineNumbers);
    Self.FWidth := FWidth;
    Self.FVisible := FVisible;
    Self.DoChange;
  end
  else
    inherited Assign(ASource);
end;

function TBCEditorLeftMargin.GetWidth: Integer;
begin
  if FVisible then
    Result := FWidth
  else
    Result := 0;
end;

procedure TBCEditorLeftMargin.SetAutosize(const AValue: Boolean);
begin
  if FAutosize <> AValue then
  begin
    FAutosize := AValue;
    DoChange
  end;
end;

procedure TBCEditorLeftMargin.SetColors(const AValue: TBCEditorLeftMarginColors);
begin
  FColors.Assign(AValue);
end;

procedure TBCEditorLeftMargin.SetFont(AValue: TFont);
begin
  FFont.Assign(AValue);
end;

procedure TBCEditorLeftMargin.SetWidth(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if FWidth <> AValue then
  begin
    FWidth := AValue;
    DoChange
  end;
end;

procedure TBCEditorLeftMargin.SetVisible(const AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    DoChange
  end;
end;

procedure TBCEditorLeftMargin.SetBookMarks(const AValue: TBCEditorLeftMarginBookmarks);
begin
  FBookmarks.Assign(AValue);
end;

procedure TBCEditorLeftMargin.AutosizeDigitCount(ALinesCount: Integer);
var
  NumberOfDigits: Integer;
begin
  if FLineNumbers.Visible and FAutosize then
  begin
    if FLineNumbers.StartFrom = 0 then
      Dec(ALinesCount)
    else
      if FLineNumbers.StartFrom > 1 then
        Inc(ALinesCount, FLineNumbers.StartFrom - 1);

    NumberOfDigits := Max(Length(IntToStr(ALinesCount)), FLineNumbers.DigitCount);
    if FLineNumbers.AutosizeDigitCount <> NumberOfDigits then
    begin
      FLineNumbers.AutosizeDigitCount := NumberOfDigits;
      if Assigned(FOnChange) then
        FOnChange(Self);
    end;
  end
  else
    FLineNumbers.AutosizeDigitCount := FLineNumbers.DigitCount;
end;

function TBCEditorLeftMargin.FormatLineNumber(ALine: Integer): string;
var
  i: Integer;
begin
  if FLineNumbers.StartFrom = 0 then
    Dec(ALine)
  else
  if FLineNumbers.StartFrom > 1 then
    Inc(ALine, FLineNumbers.StartFrom - 1);
  Result := Format('%*d', [FLineNumbers.AutosizeDigitCount, ALine]);
  if lnoLeadingZeros in FLineNumbers.Options then
    for i := 1 to FLineNumbers.AutosizeDigitCount - 1 do
    begin
      if Result[i] <> ' ' then
        Break;
      Result[i] := '0';
    end;
end;

end.
