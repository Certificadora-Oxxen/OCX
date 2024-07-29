unit UIntSituacoesCria;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntSituacoesCria }
  TIntSituacoesCria = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntSituacoesCria}

function TIntSituacoesCria.Pesquisar: Integer;
const
  CodMetodo: Integer = 467;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Text :=
      'select '+
      '  cod_situacao_cria as CodSituacaoCria '+
      '  , sgl_situacao_cria as SglSituacaoCria '+
      '  , des_situacao_cria as DesSituacaoCria '+
      'from '+
      '  tab_situacao_cria '+
      'where '+
      '  dta_fim_validade is null '+
      'order by '+
      '  cod_situacao_cria ';
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1542, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1542;
      Exit;
    End;
  End;
end;

end.
