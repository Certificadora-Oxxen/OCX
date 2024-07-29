unit uIntSituacoesCodigoSISBOV;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntSituacoesCodigoSISBOV }
  TIntSituacoesCodigoSISBOV = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(IndSituacaoAplicavel,
      IndFiltroPesquisaOS: String): Integer;
  end;

implementation

{ TIntSituacoesCodigoSISBOV }

function TIntSituacoesCodigoSISBOV.Pesquisar(IndSituacaoAplicavel,
  IndFiltroPesquisaOS: String): Integer;
const
  CodMetodo: Integer = 588;
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  Query.SQL.Text :=
{$IFDEF MSSQL}
    'select ' +
    '  cod_situacao_codigo_sisbov as CodSituacaoCodigoSisbov ' +
    '  , sgl_situacao_codigo_sisbov as SglSituacaoCodigoSisbov ' +
    '  , des_situacao_codigo_sisbov as DesSituacaoCodigoSisbov ' +
    '  , txt_filtro_pesquisa_os as TxtFiltroPesquisaOS ' +
    'from ' +
    '  tab_situacao_codigo_sisbov ' +
    'where 1 = 1 ';

  if IndSituacaoAplicavel <> '' then
    Query.SQL.Text := Query.SQL.Text +
      'and ind_situacao_aplicavel = :ind_situacao_aplicavel ';

  if IndFiltroPesquisaOS <> '' then
    Query.SQL.Text := Query.SQL.Text +
      'and ind_filtro_pesquisa_os = :ind_filtro_pesquisa_os ';

  Query.SQL.Text := Query.SQL.Text +
    'order by ' +
    '  num_ordem ';
{$ENDIF}
  try
    if IndSituacaoAplicavel <> '' then
    begin
      Query.ParamByName('ind_situacao_aplicavel').AsString := IndSituacaoAplicavel;
    end;

    if IndFiltroPesquisaOS <> '' then
    begin
      Query.ParamByName('ind_filtro_pesquisa_os').AsString := IndFiltroPesquisaOS;
    end;

    Query.Open;
    Result := 0;
  except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1946, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -1946;
      Exit;
    end;
  end;
end;

end.

