unit uIntResultadosAnuncio;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db;

type
  TIntResultadosAnuncio = class(TIntClasseBDNavegacaoBasica)
  public
    function Pesquisar(CodAnunciante, CodPagina: Integer; DtaInicio, DtaFim: TDateTime;
      IndDetalheData, IndDetalhePagina, IndDetalheBanner: Boolean): Integer;
    function GerarRelatorio(CodAnunciante, CodPagina: Integer; DtaInicio, DtaFim: TDateTime;
      IndDetalheData, IndDetalhePagina, IndDetalheBanner: Boolean; Tipo: Integer): String;
  end;

implementation

function TIntResultadosAnuncio.Pesquisar(CodAnunciante, CodPagina: Integer; DtaInicio,
  DtaFim: TDateTime; IndDetalheData, IndDetalhePagina, IndDetalheBanner: Boolean): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(34) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;

  Query.SQL.Add('select ta.cod_anunciante as CodAnunciante, ');
  If IndDetalheData Then Begin
    Query.SQL.Add('       tra.dta_anuncio    as DtaAnuncio, ');
  End;
  If IndDetalhePagina Then Begin
   Query.SQL.Add('       tp.des_pagina      as DesPagina, ');
  End;
  If IndDetalheBanner Then Begin
    Query.SQL.Add('       tb.nom_arquivo     as NomArquivo, ');
  End;
  Query.SQL.Add('       sum(tra.qtd_impressoes) as QtdImpressoes, ');
  Query.SQL.Add('       sum(tra.qtd_cliques)    as QtdCliques, ');
  Query.SQL.Add('       ta.nom_anunciante  as NomAnunciante ');
  Query.SQL.Add('  from tab_resultado_anuncio tra, ');
  Query.SQL.Add('       tab_anunciante ta, ');
  Query.SQL.Add('       tab_banner tb, ');
  Query.SQL.Add('       tab_pagina tp ');
  Query.SQL.Add(' where tb.cod_banner = tra.cod_banner ');
  Query.SQL.Add('   and ta.cod_anunciante = tb.cod_anunciante ');
  Query.SQL.Add('   and tp.cod_pagina = tra.cod_pagina ');
  Query.SQL.Add('   and ((ta.cod_anunciante = :cod_anunciante) or (:cod_anunciante = -1)) ');
  Query.SQL.Add('   and ((tra.cod_pagina = :cod_pagina) or (:cod_pagina = -1)) ');
  Query.SQL.Add('   and ((tra.dta_anuncio between :dta_inicio and :dta_fim) or (:dta_inicio is null)) ');
  Query.SQL.Add(' group by ta.nom_anunciante, ');
  If IndDetalheData Then Begin
    Query.SQL.Add('          tra.dta_anuncio, ');
  End;
  If IndDetalhePagina Then Begin
    Query.SQL.Add('          tp.des_pagina, ');
  End;
  If IndDetalheBanner Then Begin
    Query.SQL.Add('          tb.nom_arquivo, ');
  End;
  Query.SQL.Add('          ta.cod_anunciante ');
  Query.SQL.Add(' order by ta.nom_anunciante, ');
  If IndDetalheData Then Begin
    Query.SQL.Add('          tra.dta_anuncio, ');
  End;
  If IndDetalhePagina Then Begin
    Query.SQL.Add('          tp.des_pagina, ');
  End;
  If IndDetalheBanner Then Begin
    Query.SQL.Add('          tb.nom_arquivo, ');
  End;
  Query.SQL.Add('          ta.cod_anunciante ');
{$ENDIF}

  Query.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
  Query.ParamByName('cod_pagina').AsInteger := CodPagina;
  If DtaInicio = 0 Then Begin
    Query.ParamByName('dta_inicio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio').Clear;
  End Else Begin
    Query.ParamByName('dta_inicio').AsDateTime := DtaInicio;
  End;
  If DtaFim = 0 Then Begin
    Query.ParamByName('dta_fim').DataType := ftDateTime;
    Query.ParamByName('dta_fim').Clear;
  End Else Begin
    Query.ParamByName('dta_fim').AsDateTime := DtaFim;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(156, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -156;
      Exit;
    End;
  End;
end;

function TIntResultadosAnuncio.GerarRelatorio(CodAnunciante,
  CodPagina: Integer; DtaInicio, DtaFim: TDateTime; IndDetalheData,
  IndDetalhePagina, IndDetalheBanner: Boolean; Tipo: Integer): String;
const
  Metodo: Integer = 370;
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 9;
var
  Rel: TRelatorioPadrao;
  Retorno: Integer;
  sAux: String;
begin
  Result := '';

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  End;

  {Pesquisa pelos dados a serem apresentados no relatório}
  Retorno := Pesquisar(CodAnunciante, CodPagina, DtaInicio,
    DtaFim, IndDetalheData, IndDetalhePagina, IndDetalheBanner);
  if Retorno < 0 then Exit;

  {Consiste se existem dados para serem apresentados}
  if Query.IsEmpty then begin
    Mensagens.Adicionar(1162, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  {Procedimento de geração do relatório}
  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  try
    Rel.TipoDoArquvio := Tipo;

    {Define o relatório em questão e carrega os seus dados específicos}
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then Exit;

    {Desabilita campos conforme a não seleção mesmos pelo usuário}
    If not IndDetalheData Then Begin
      Rel.Campos.DesabilitarCampo('DtaAnuncio');
    End;
    If not IndDetalhePagina Then Begin
      Rel.Campos.DesabilitarCampo('DesPagina');
    End;
    If not IndDetalheBanner Then Begin
      Rel.Campos.DesabilitarCampo('NomArquivo');
    End;

    {Desabilita a apresentação do campo NomAnunciante como coluna}
    Rel.Campos.DesabilitarCampo('NomAnunciante');

    {Inicializa o procedimento de geração do arquivo de relatório}
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then Exit;

    sAux := '';
    Query.First;
    while not Query.EOF do begin
      {Atualiza o campo valor do atributo Campos do relatorio c/ os dados da query}
      Rel.Campos.CarregarValores(Query);
      if (sAux <> Query.FieldByName('NomAnunciante').AsString) then begin
        {Se ocorreu mudança na quebra atual ou é a primeira ('')}
        sAux := Query.FieldByName('NomAnunciante').AsString;
        if Rel.LinhasRestantes <= 2 then begin
          {Se ñ couber uma linha de registro na pag. atual, quebra página}
          Rel.NovaPagina;
        end else if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
          {Salta uma linha antes da quebra}
          Rel.NovaLinha;
        end;
        {Imprime título da quebra}
        Rel.ImprimirTexto(0, 'Anunciante: '+sAux);
      end else if (Rel.LinhasRestantes = Rel.LinhasPorPagina) then begin
        // Repete o título da quebra no topo da nova pág. qdo ocorrer quebra de pág.
        Rel.ImprimirTexto(0, 'Anunciante: '+sAux+' (continuação)');
      end;
      Rel.ImprimirColunasResultSet(Query);
      Query.Next;
    end;
    Retorno := Rel.FinalizarRelatorio;
    if Retorno = 0 then begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
  end;
end;

end.
