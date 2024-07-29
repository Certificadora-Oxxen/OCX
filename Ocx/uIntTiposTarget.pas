unit uIntTiposTarget;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposTarget }
  TIntTiposTarget = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntTiposTarget }

function TIntTiposTarget.Pesquisar: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(22) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select cod_tipo_target as CodTipoTarget, ');
  Query.SQL.Add('       des_tipo_target as DesTipoTarget, ');
  Query.SQL.Add('       txt_comando_target as TxtComandoTarget ');
  Query.SQL.Add('  from tab_tipo_target ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(135, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -135;
      Exit;
    End;
  End;
end;

end.

