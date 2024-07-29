unit uETabErro;

interface

uses Sysutils;

type
  ETabErro = class(Exception)
  private
    FTabela: Integer;
    FCodErro: Integer;
    FArgs: Array of String;
    function GetArgs(index: Integer): String;
  public
    constructor CreateErro(Tabela, CodErro: Integer); overload;
    constructor CreateErro(Tabela, CodErro: Integer; Args: array of String); overload;
    function CountArgs: Integer;
    property Tabela: Integer read FTabela write FTabela;
    property CodErro: Integer read FCodErro write FCodErro;
    property Args[index: Integer]: String read GetArgs;
  end;

implementation

{ ETabErro }

constructor ETabErro.CreateErro(Tabela, CodErro: Integer);
begin
  FTabela  := Tabela;
  FCodErro := CodErro;
  Finalize(FArgs);
end;

constructor ETabErro.CreateErro(Tabela, CodErro: Integer;
  Args: array of String);
var
  X : Integer;
begin
  Finalize(FArgs);
  FTabela  := Tabela;
  FCodErro := CodErro;
  X := Length(Args);
  SetLength(FArgs, X);
  If X > 0 then Begin
    For X := 0 to High(Args) do Begin
      FArgs[X] := Args[X];
    End;
  End;
end;

function ETabErro.CountArgs: Integer;
begin
  Result := Length(FArgs);
end;

function ETabErro.GetArgs(index: Integer): String;
begin
  If (index > High(FArgs)) or (index < Low(FArgs)) Then Begin
    Result := '?';
  End Else Begin
    Result := FArgs[index];
  End;
end;

end.
 