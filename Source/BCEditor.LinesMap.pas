unit BCEditor.LinesMap deprecated;

interface

uses
   Classes,
   BCEditor.Editor.Base, BCEditor.Editor.CodeFolding.Ranges;

type

   TBCEditorLinesMap = class
      private
         FLines : array of TStrings;
         FLineIndex : array of Integer;
         FCount : Integer;

      protected
         procedure Grow;
         procedure Add(lines : TStrings; index : Integer);

         function GetLine(index : Integer) : String;
         procedure SetLine(index : Integer; const aLine : String);

      public
         constructor Create(editor : TBCBaseEditor);

         property Lines[index : Integer] : String read GetLine write SetLine; default;
         property Count : Integer read FCount;
   end;

implementation

const
   cDefaultCapacity = 16;

// ------------------
// ------------------ TBCEditorLinesMap ------------------
// ------------------

// Create
//
constructor TBCEditorLinesMap.Create(editor : TBCBaseEditor);
var
   i, j : Integer;
   codeFoldingRange : TBCEditorCodeFoldingRange;
begin
   inherited Create;

   SetLength(FLines, cDefaultCapacity);
   SetLength(FLineIndex, cDefaultCapacity);

   j := 0;
   for i := 0 to editor.Lines.Count - 1 do begin
//      codeFoldingRange := nil;
      while j < editor.AllCodeFoldingRanges.AllCount do begin
         codeFoldingRange := editor.AllCodeFoldingRanges[j];
         if Assigned(codeFoldingRange) and not codeFoldingRange.Collapsed then begin
            Inc(j)
         end else begin
            Break;
         end;
      end;
//      if (j < editor.AllCodeFoldingRanges.AllCount) and Assigned(codeFoldingRange) and (codeFoldingRange.FromLine - 1 = i) then begin
//         for k := 0 to codeFoldingRange.CollapsedLines.Count - 1 do
//            Add(codeFoldingRange.CollapsedLines, k);
//         Inc(j);
//      end else begin
//         Add(editor.Lines, i)
//      end;
   end;
end;

// Grow
//
procedure TBCEditorLinesMap.Grow;
var
   n : Integer;
begin
   n := Length(FLines);
   Inc(n, n shr 1);  // + 50%
   SetLength(FLines, n);
   SetLength(FLineIndex, n);
end;

// Add
//
procedure TBCEditorLinesMap.Add(lines : TStrings; index : Integer);
begin
   if FCount = Length(FLines) then Grow;

   FLines[FCount] := lines;
   FLineIndex[FCount] := index;
   Inc(FCount);
end;

// GetLine
//
function TBCEditorLinesMap.GetLine(index : Integer) : String;
begin
   Result:=FLines[index][FLineIndex[index]];
end;

// SetLine
//
procedure TBCEditorLinesMap.SetLine(index : Integer; const aLine : String);
begin
   FLines[index][FLineIndex[index]]:=aLine;
end;

end.
