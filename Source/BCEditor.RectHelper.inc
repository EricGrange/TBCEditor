{$IF CompilerVersion < 25}
type
  TRectHelper = record helper for TRect
  private
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  public
    function Contains(const Pt: TPoint): Boolean;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
  end;

function TRectHelper.Contains(const Pt: TPoint): Boolean;
begin
  Result := PtInRect(Self, PT);
end;

function TRectHelper.GetHeight: Integer;
begin
  Result := Self.Bottom - Self.Top;
end;

function TRectHelper.GetWidth: Integer;
begin
  Result := Self.Right - Self.Left;
end;

procedure TRectHelper.SetHeight(const Value: Integer);
begin
  Bottom := Top + Value;
end;

procedure TRectHelper.SetWidth(const Value: Integer);
begin
  Right := Left + Value;
end;
{$IFEND}
