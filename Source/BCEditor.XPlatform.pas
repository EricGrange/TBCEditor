unit BCEditor.XPlatform;

interface

uses Windows, Graphics;

function XPatBlt(dc : HDC; const rect : TRect; Rop: DWORD): BOOL;

implementation

function XPatBlt(dc : HDC; const rect : TRect; rop: DWORD): BOOL;
begin
   Result := PatBlt(dc, rect.Left, rect.Top, rect.Right-rect.Left, rect.Bottom-rect.Top, rop);
end;

end.
