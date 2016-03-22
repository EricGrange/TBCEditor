{$IF CompilerVersion < 23}
type
  TEncodingHelper = class helper for SysUtils.TEncoding
  private
    class function GetANSI: SysUtils.TEncoding; static;
  public
    class property ANSI: SysUtils.TEncoding read GetANSI;
  end;

class function TEncodingHelper.GetANSI: SysUtils.TEncoding;
begin
  Result := SysUtils.TEncoding.Default;
end;
{$IFEND}
