unit uIntTiposMovimentoEstoqueSemen;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposMovimentoEstoqueSemen }
  TIntTiposMovimentoEstoqueSemen = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(IndRestritoSistema: String): Integer;
  end;

implementation

{ TIntTiposMovimentoEstoqueSemen}

function TIntTiposMovimentoEstoqueSemen.Pesquisar(
  IndRestritoSistema: String): Integer;
const
  Metodo: Integer = 433;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  cod_tipo_mov_estoque_semen as CodTipoMovEstoque '+
      '  , sgl_tipo_mov_estoque_semen as SglTipoMovEstoqueSemen '+
      '  , des_tipo_mov_estoque_semen as DesTipoMovEstoqueSemen '+
      '  , cod_operacao_mov_estoque as CodOperacaoMovEstoque '+
      '  , ind_restrito_sistema as IndRestritoSistema '+
      'from '+
      '  tab_tipo_mov_estoque_semen ';
    if (IndRestritoSistema = 'S') or (IndRestritoSistema = 'N') then begin
      Query.SQL.Text := Query.SQL.Text +
        'where '+
        '  ind_restrito_sistema = :ind_restrito_sistema ';
      Query.ParamByName('ind_restrito_sistema').AsString := IndRestritoSistema;
    end;
    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  num_ordem ';
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1442, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1442;
      Exit;
    End;
  End;
end;

end.
