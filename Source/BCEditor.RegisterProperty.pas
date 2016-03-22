unit BCEditor.RegisterProperty;

interface

uses
  DesignIntf, DesignEditors, VCLEditors, StrEdit, Classes;

procedure Register;

implementation

uses
  Controls, BCEditor.Editor, BCEditor.MacroRecorder, SysUtils;

{ Register }

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(Char), nil, '', TCharProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), nil, '', TStringListProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut), TBCEditorMacroRecorder, '', TShortCutProperty);
end;

end.
