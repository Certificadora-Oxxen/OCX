// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Edivaldo Portela
// *  Versão             : 1.0
// *  Data               : 12/11/2008
// *  Documentação       :
// *  Código Classe      :
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntTmpAplicaEvento;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntTmpAplicaEvento }
  TIntTmpAplicaEvento = class(TIntClasseBDNavegacaoBasica)
  public
    function Pesquisar(CodPessoaProdutor, CodAnimal, CodEvento,
      CodSessao: Integer): Integer;
  end;


implementation

{ TIntTmpAplicaEvento }

function TIntTmpAplicaEvento.Pesquisar(CodPessoaProdutor, CodAnimal, CodEvento,
      CodSessao: Integer): Integer;
const
  NomMetodo: String = 'PesquisarTmpAplicaEvento';
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT a.*,');
    Query.SQL.Add('       b.cod_animal_manejo AS cod_animal_manejo_herdom,');
    Query.SQL.Add('       b.ind_sexo,');
    Query.SQL.Add('       b.cod_situacao_sisbov,');
    Query.SQL.Add('       b.des_apelido,');
    Query.SQL.Add('       CASE b.cod_pais_sisbov  when null then null  else right(''000'' + cast(b.cod_pais_sisbov as varchar(3)),3) end + ' +
                  '       CASE b.cod_animal_sisbov  when null then ''''  else right(''00'' + cast(b.cod_estado_sisbov as varchar(2)),2) + ' +
                  '       CASE b.cod_micro_regiao_sisbov when -1 then '''' else right(''00'' + cast(b.cod_micro_regiao_sisbov as varchar(2)),2) end + ' +
                  '       RIGHT(''000000000'' + cast(b.cod_animal_sisbov as varchar(9)),9) + right(''0'' + cast(b.num_dv_sisbov as varchar(1)),1) end as num_sisbov,');
//    Query.SQL.Add('       dbo.fnt_idade(b.dta_nascimento, getdate()) as idade,');
    Query.SQL.Add('       dbo.fnt_idade(b.dta_nascimento, isnull(b.dta_desativacao, getdate())) as idade,');
    Query.SQL.Add('       c.sgl_categoria_animal,');
    Query.SQL.Add('       d.sgl_raca,');
    Query.SQL.Add('       e.sgl_fazenda,');
    Query.SQL.Add('       f.sgl_local,');
    Query.SQL.Add('       g.sgl_lote');
    Query.SQL.Add('FROM tmp_aplica_evento a');
    Query.SQL.Add('INNER JOIN tab_animal b ON (b.cod_pessoa_produtor = a.cod_pessoa_produtor AND b.cod_animal = a.cod_animal)');
    Query.SQL.Add('LEFT JOIN tab_categoria_animal c ON (c.cod_categoria_animal = b.cod_categoria_animal)');
    Query.SQL.Add('LEFT JOIN tab_raca d ON (d.cod_raca = b.cod_raca)');
    Query.SQL.Add('LEFT JOIN tab_fazenda e ON (e.cod_pessoa_produtor = b.cod_pessoa_produtor AND e.cod_fazenda = b.cod_fazenda_corrente)');
    Query.SQL.Add('LEFT JOIN tab_local f ON (f.cod_pessoa_produtor = b.cod_pessoa_produtor AND f.cod_fazenda = b.cod_fazenda_corrente AND f.cod_local = b.cod_local_corrente)');
    Query.SQL.Add('LEFT JOIN tab_lote g ON (g.cod_pessoa_produtor = b.cod_pessoa_produtor AND g.cod_fazenda = b.cod_fazenda_corrente AND g.cod_lote = b.cod_lote_corrente)');
    Query.SQL.Add('WHERE 1=1');
    if CodEvento > 0 then
      Query.SQL.Add('AND a.cod_evento = ' + IntToStr(CodEvento));
    if CodPessoaProdutor > 0 then
      Query.SQL.Add('AND a.cod_pessoa_produtor = ' + IntToStr(CodPessoaProdutor));
    if CodAnimal > 0 then
      Query.SQL.Add('AND a.cod_animal = ' + IntToStr(CodAnimal));
    if CodSessao > 0 then
      Query.SQL.Add('AND a.cod_sessao = ' + IntToStr(CodSessao));
//    Query.SQL.Add('ORDER BY a.num_ordem, a.ind_ultimo ');

    Query.Open;

    Result := 1;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(9999, Self.ClassName, NomMetodo, ['Erro ao tentar recuperar registros temporários da Aplicação de Eventos. Detalhe: ' + E.Message]);
      Result := -9999;
      Exit;
    end;
  end;
end;

end.

