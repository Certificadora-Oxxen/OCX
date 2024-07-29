unit uIntErroImportacao;

interface

uses Sysutils, Classes, uETabErro;

type
  TIntErroImportacao = class(TObject)
  private
    FCodErro: Integer;
    FArgs: array of String;
    function GetArgs(index: Integer): String;
    function GetCount: Integer;
  public
    function SetErro(CodErro: Integer): Integer; overload;
    function SetErro(CodErro: Integer; Args: array of string): Integer; overload;
    function SetErro(E: ETabErro): Integer; overload;
    property CodErro: Integer read FCodErro;
    property Args[index: Integer]: String read GetArgs;
    property Count: Integer read GetCount;
  end;

implementation

{ TIntErroImportacao }
function TIntErroImportacao.GetArgs(index: Integer): String;
begin
  If (index > High(FArgs)) or (index < Low(FArgs)) Then Begin
    Result := '?';
  End Else Begin
    Result := FArgs[index];
  End;
end;

function TIntErroImportacao.GetCount: Integer;
begin
  Result := Length(FArgs);
end;

function TIntErroImportacao.SetErro(CodErro: Integer): Integer;
begin
  FCodErro := CodErro;
  SetLength(FArgs, 0);
  Result := Trunc(Abs(CodErro) * -1);
end;

function TIntErroImportacao.SetErro(CodErro: Integer;
  Args: array of string): Integer;
var
  X : Integer;
begin
  FCodErro := CodErro;
  X := Length(Args);
  SetLength(FArgs, X);
  If X > 0 then Begin
    For X := 0 to High(Args) do Begin
      FArgs[X] := Args[X];
    End;
  End;
  Result := Trunc(Abs(CodErro) * -1);
end;

function TIntErroImportacao.SetErro(E: ETabErro): Integer;
var
  X : Integer;
begin
  FCodErro := E.CodErro;
  X := E.CountArgs;
  SetLength(FArgs, X);
  If X > 0 then Begin
    For X := 0 to E.CountArgs - 1 do Begin
      FArgs[X] := E.Args[X];
    End;
  End;
  Result := Trunc(Abs(CodErro) * -1);
end;

end.
