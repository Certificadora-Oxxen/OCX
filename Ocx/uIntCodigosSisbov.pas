// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 14/08/2002
// *  Documentação       : Atributo de Animais - Especificação das
// *                       classes.doc
// *  Código Classe      : 23
// *  Descrição Resumida : Cadastro de Codigo SisBov.
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    14/08/2002    Criação
// *   Carlos    04/09/2002    Inserção do método Excluir
// *   Carlos    23/01/2003    Inserção do método GerarRelatorioConsolidadoSisBov
// *   Canival   23/01/2003    Inserção do método GerarRelatorioCodigoSisBov
// *   Fábio     03/02/2004    Tratamento das micro regiões de codigo 88
// *   Daniel    05/07/2004    Tratamento das micro regiões de codigo -1
// ********************************************************************
unit uIntCodigosSisbov;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db,uFerramentas, uIntRelatorios,
     uLibZipM, uIntOrdensServico, uIntMensagens, uColecoes, DBClient,
     uPrintPDF, uIntPropriedadesRurais;

type

  TTotalizadores = record
    Campo: String;
    SubTotal: Integer;
    Total: Integer;
  end;

  TFaixaCodigos = record
    CodAnimalSISBOVInicio: Integer;
    CodAnimalSISBOVFim: Integer;
  end;

  TTotalizadoresArray = Array of TTotalizadores;

  TIntCodigosSisbov = class(TIntClasseBDNavegacaoBasica)
  private
    FCodPaisSisbov : Integer;
    FCodEstadoSisbov : Integer;
    FCodMicroRegiaoSisbov : Integer;
    FIndCodigoUtilizado: String;
    FIntOrdensServico: TIntOrdensServico;
    FQueryInsertHistorico: THerdomQuery;
    FCodOrdemServico: Integer;
    FNumRemessaFicha: Integer;

    /////////////////////////////
    // Atributos da carga inicial
    FCodLocalizacaoSISBOVCI,
    FCodPessoaProdutorCI,
    FCodPropriedadeRuralCI: Integer;
    FNIRFINCRAPropriedadeCI,
    FCNPJCPFProdutorCI: String;
    /////////////////////////////

    procedure PrepararLinha(Relatorio: TRelatorioPadrao; Query: THerdomQuery;
      var Observacao: Boolean);
    function PesquisarRelatorioConsolidado(Query: THerdomQuery;
      CodEstado, SglProdutor, NomPessoaProdutor, NumCNPJCPFProdutor,
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NomPropriedadeRural,
      NomMunicipioPropriedadeRural: String; DtaSolicitacaoSISBOVInicio,
      DtaSolicitacaoSISBOVFim, DtaInsercaoInicio, DtaInsercaoFim,
      DtaUtilizacaoInicio, DtaUtilizacaoFim, DtaLiberacaoAbateInicio,
      DtaLiberacaoAbateFim, DtaExpiracaoInicio, DtaExpiracaoFim: TDateTime;
      CodSituacoesCodigoSISBOV: String; var Totalizadores: TTotalizadoresArray; CodTarefa: Integer): Integer;
    function BuscarProdutor(SglProdutor, NumCNPJCPFProdutor: String): Integer;
//  Removida por nao mais ser utilizada! foi substituida pela VerificaLocalizacaoSISBOVPropriedade da uIntPropriedadesRurais
//  function BuscarPropriedadeRural(NumImovelReceitaFederal: String): Integer;
    procedure ZerarValoresUltimaPesquisa;
    procedure InserirHistorico(CodPais, CodEstado, CodMicroRegiao,
      CodAnimalSisbovInicial, CodAnimalSisbovFinal: Integer;
      IndExclusao: String);
    function ValidaFaixaRemessa(CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, CodAnimalSISBOVFim: Integer;
      var CodOrdemServico: Integer): Integer;
    function ObtemProximoValor(var Valor: String): String; 
    function SeparaFaixasCodigos(CodAnimaisSISBOVInicio,
      CodAnimaisSISBOVFim: String; var FaixasCodigos: array of TFaixaCodigos;
      var QtdFaixas: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inserir(CodPessoaProdutor: Integer; SglProdutor,
      NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NumSolicitacaoSISBOV: Integer;
      DtaSolicitacaoSISBOV: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim, CodigoOS: Integer): Integer;

    function Pesquisar(CodPaisSisBov,
                       CodEstadoSisBov,
                       CodMicroRegiaoSisBov,
                       SeqInicial,
                       SeqFinal: Integer;
                       IndCodigoUtilizado,
                       NomPessoa,
                       NomPropriedade,
                       SiglaProdutor: String;
                       DtaInicioCadastramentoCodigos,
                       DtaFimCadastramentoCodigos,
                       DtaInicioUtilizacaoCodigos,
                       DtaFimUtilizacaoCodigos: TDateTime;
                       NumSolicitacaoSISBOV: Integer): Integer;

    function Excluir(CodPessoaProdutor: Integer; SglProdutor,
      NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;

    function GerarRelatorioConsolidado(CodEstado,
                                       SglProdutor,
                                       NomPessoaProdutor,
                                       NumCNPJCPFProdutor,
                                       NumImovelReceitaFederal: String;
                                       CodLocalizacaoSisbov: Integer;
                                       NomPropriedadeRural,
                                       NomMunicipioPropriedadeRural: String;
                                       DtaSolicitacaoSISBOVInicio,
                                       DtaSolicitacaoSISBOVFim,
                                       DtaInsercaoInicio,
                                       DtaInsercaoFim,
                                       DtaUtilizacaoInicio,
                                       DtaUtilizacaoFim,
                                       DtaLiberacaoAbateInicio,
                                       DtaLiberacaoAbateFim,
                                       DtaExpiracaoInicio,
                                       DtaExpiracaoFim: TDateTime;
                                       CodSituacoesCodigoSISBOV: String;
                                       QtdQuebraRelatorio,
                                       Tipo,
                                       CodTarefa: Integer): String;

    function GerarRelatorioCodigosSisBov(CodEstado,
                                         CodMicroRegiao: Integer;
                                         CodOrdenacao: String;
                                         SeqInicial,
                                         SeqFinal: Integer;
                                         Tipo: Integer;
                                         SiglaProdutor,
                                         NomProdutor,
                                         NomPropriedade: String;
                                         DtaInicioCadastramentoCodigos,
                                         DtaFimCadastramentoCodigos,
                                         DtaInicioUtilizacaoCodigos,
                                         DtaFimUtilizacaoCodigos: TDateTime;
                                         CodPais,
                                         QtdQuebraRelatorio,
                                         NumSolicitacaoSISBOV: Integer): String;

    function ReservarCodigosProdutor(CodPessoaProdutor, CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalInicio,CodAnimalFim,CodPropriedadeRural : Integer): Integer;
    function CancelarReservaProdutor(CodPessoaProdutor, CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalInicio,CodAnimalFim,CodPropriedadeRural : Integer): Integer;
    function PesquisarReservaProdutor(NomProdutor: String;CodEstadoSisBov,CodMicroRegiaoSisBov : Integer;IndCodigoUtilizado: String; NomPropriedade: WideString; CodInicial,
      CodFinal: Integer): Integer;
    function GeraArquivoCodigoExportacao(): Integer;
    function AlterarSituacaoSisbov(CodPais, CodEstado, CodMicroRegiao,
      CodAnimalSisbov, CodSituacaoSisbovDestino: Integer): Integer;
    function RestaurarSituacaoSisbov(CodPais, CodEstado, CodMicroRegiao,
      CodAnimalSisbov: Integer): Integer;
    function ReservaCodigos(CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSisbovInicio, QtdAnimais: Integer): Integer;
    procedure RemoverAnimalEvento(CodAnimal, CodPessoaProdutor,
      CodEvento: Integer; IndEventoEnvioCertificado: Boolean);
    function AlterarSolicitacao(CodPessoaProdutor: Integer; SglProdutor,
      NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov, NumSolicitacaoSISBOV: Integer;
      DtaSolicitacaoSISBOV: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
    function ProcessarAutenticacao(CodPessoaProdutor: Integer;
      SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim: Integer;
       DtaLiberacaoAbate: TDateTime): Integer;
    function CancelarAutenticacao(CodPessoaProdutor: Integer;
      SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
    function CancelarEnvioCertificado(CodOrdemServico,
      NumRemessaFicha: Integer): Integer;
    function ProcessarEnvioCertificado(CodOrdemServico,
      NumRemessaFicha: Integer; DtaEnvio: TDateTime; NomServicoEnvio,
      NumConhecimento: String): Integer;
    procedure AlterarOrdemServico(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
      CodAnimalSisbovInicial, CodAnimalSisbovFinal, CodOrdemServico: Integer);
    procedure LimparOrdemServicoCodigos(CodOrdemServico: Integer);

    function ProcessarRecebimentoFichas(DtaRecebimentoFicha: TDateTime;
      CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV: Integer;
      CodAnimaisSISBOVInicio, CodAnimaisSISBOVFim: String): Integer;
    function AdicionarFaixaRecebimento(CodOrdemServico, NumRemessaFicha,
      CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, CodAnimalSISBOVFim: Integer): Integer;
    function PesquisarFaixaRecebimento(CodOrdemServico, NumRemessaFicha: Integer): Integer;
    function RetirarFaixaRecebimento(CodOrdemServico, NumRemessaFicha, SeqFaixaRemessa: Integer): Integer;
    function ProcessarAprovacaoFichas(CodOrdemServico, NumRemessaFicha: Integer): Integer;
    function CancelarAprovacaoFichas(CodOrdemServico, NumRemessaFicha: Integer): Integer;
    function ProcessarImpressaoCertificado(CodOrdemServico, NumRemessaFicha: Integer): Integer;
    function CancelarImpressaoCertificado(CodOrdemServico, NumRemessaFicha: Integer): Integer;

    function InserirEnvioCertificado(CodPessoaProdutor: Integer;
      SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
      NumImovelReceitaFederal: String; CodLocalizacaoSiSbov: Integer; DtaEnvio: TDateTime;
      NomServicoEnvio, NumConhecimento: String; CodPaisSisBov,
      CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalSisBovInicio,
      CodAnimalSisBovFim, NumDVSisBovInicio, NumDVSisBovFim: Integer): Integer;

    function ExcluirEnvioCertificado(CodPessoaProdutor: Integer;
      SglProdutor, NumCNPJCPFProdutor: String;
      CodPropriedadeRural: Integer; NumImovelReceitaFederal: String;
      CodLocalizacaoSiSbov, CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
      CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio,
      NumDVSisBovFim: Integer): Integer;

    /////////////////////////////
    // Métodos da carga inicial
    procedure InserirCodigoSISBOVCargaInicial(NumSISBOV, NirfIncraReserva,
      CodLocalizacaoSISBOVReserva, CNPJCPFReserva, NirfIncraSolicitacao,
      CodLocalizacaoSISBOVSolicitacao, CNPJCPFSolicitacao, NumeroDaSolicitacao,
      DtaSolicitacao: String);
    /////////////////////////////

    property PCodOrdemServico: Integer read FCodOrdemServico;
    property PNumRemessaficha: Integer read FNumRemessaFicha;
  end;

const
  {Situações de códigos sisbov}
  DISP  = 1;
  CAD   = 2;
  EFET  = 3;
  AUT   = 4;
  CERT  = 5;
  TRANS = 6;
  INAT  = 7;
  EXCL  = 8;
  REC   = 9;
  APROV = 10;
  IMPR  = 11;


  {Referência para parâmetros globais do sistema}
  NUM_DIAS_EMISSAO_CERTIFICADO = 66;
  GERAR_ATUALIZAR_ORDENS_SERVICO = 88;
  PRAZO_DIAS_UNICIDADE_SOLICITACAO = 89;

  {Tipos de eventos relacionados}
  EVENTO_AUTENTICACAO_SISBOV = 34;
  EVENTO_ENVIO_CERTIFICADO = 35;


implementation

uses SqlExpr, uConexao, uIntEventos, DateUtils;

{ TIntCodigosSisbov }
constructor TIntCodigosSisbov.Create;
begin
  inherited;
  ZerarValoresUltimaPesquisa;
  FIntOrdensServico := TIntOrdensServico.Create;

  FQueryInsertHistorico := THerdomQuery.Create(nil);
  with FQueryInsertHistorico do
  begin
    SQL.Add('insert into tab_historico_codigo_sisbov(');
    SQL.Add('  cod_pais_sisbov,');
    SQL.Add('  cod_estado_sisbov,');
    SQL.Add('  cod_micro_regiao_sisbov,');
    SQL.Add('  cod_animal_sisbov,');
    SQL.Add('  num_dv_sisbov,');
    SQL.Add('  cod_pessoa_produtor,');
    SQL.Add('  cod_propriedade_rural,');
    SQL.Add('  dta_insercao_registro,');
    SQL.Add('  dta_recebimento_ficha,');
    SQL.Add('  dta_aprovacao_ficha,');
    SQL.Add('  dta_utilizacao_codigo,');
    SQL.Add('  dta_efetivacao_cadastro,');
    SQL.Add('  dta_autenticacao,');
    SQL.Add('  cod_evento_autenticacao,');
    SQL.Add('  qtd_vezes_autenticacao,');
    SQL.Add('  dta_impressao_certificado,');
    SQL.Add('  dta_envio_certificado,');
    SQL.Add('  cod_evento_envio_certificado,');
    SQL.Add('  qtd_vezes_envio_certificado,');
    SQL.Add('  dta_liberacao_abate,');
    SQL.Add('  ind_data_liberacao_estimada,');
    SQL.Add('  num_solicitacao_sisbov,');
    SQL.Add('  dta_solicitacao_sisbov,');
    SQL.Add('  cod_animal_cancelado,');
    SQL.Add('  cod_ordem_servico,');
    SQL.Add('  num_remessa_ficha,');
    SQL.Add('  seq_faixa_remessa,');
    SQL.Add('  cod_situacao_codigo_sisbov,');
    SQL.Add('  dta_mudanca_situacao,');
    SQL.Add('  cod_usuario_mudanca,');
    SQL.Add('  cod_usuario_ultima_alteracao,');
    SQL.Add('  dta_ultima_alteracao');
    SQL.Add(')');
    SQL.Add('select cod_pais_sisbov,');
    SQL.Add('       cod_estado_sisbov,');
    SQL.Add('       cod_micro_regiao_sisbov,');
    SQL.Add('       cod_animal_sisbov,');
    SQL.Add('       num_dv_sisbov,');
    SQL.Add('       cod_pessoa_produtor,');
    SQL.Add('       cod_propriedade_rural,');
    SQL.Add('       dta_insercao_registro,');
    SQL.Add('       dta_recebimento_ficha,');
    SQL.Add('       dta_aprovacao_ficha,');
    SQL.Add('       dta_utilizacao_codigo,');
    SQL.Add('       dta_efetivacao_cadastro,');
    SQL.Add('       dta_autenticacao,');
    SQL.Add('       cod_evento_autenticacao,');
    SQL.Add('       qtd_vezes_autenticacao,');
    SQL.Add('       dta_impressao_certificado,');
    SQL.Add('       dta_envio_certificado,');
    SQL.Add('       cod_evento_envio_certificado,');
    SQL.Add('       qtd_vezes_envio_certificado,');
    SQL.Add('       dta_liberacao_abate,');
    SQL.Add('       ind_data_liberacao_estimada,');
    SQL.Add('       num_solicitacao_sisbov,');
    SQL.Add('       dta_solicitacao_sisbov,');
    SQL.Add('       cod_animal_cancelado,');
    SQL.Add('       cod_ordem_servico,');
    SQL.Add('       num_remessa_ficha,');
    SQL.Add('       seq_faixa_remessa,');
    SQL.Add('       case :cod_situacao_codigo_sisbov when -1 then cod_situacao_codigo_sisbov else :cod_situacao_codigo_sisbov end as cod_situacao_codigo_sisbov,');
    SQL.Add('       dta_mudanca_situacao,');
    SQL.Add('       cod_usuario_mudanca,');
    SQL.Add('       case :cod_situacao_codigo_sisbov when -1 then cod_usuario_ultima_alteracao else :cod_usuario_ultima_alteracao end as cod_usuario_ultima_alteracao,');
    SQL.Add('       case :cod_situacao_codigo_sisbov when -1 then dta_ultima_alteracao else getdate() end as dta_ultima_alteracao');
    SQL.Add('  from tab_codigo_sisbov');
    SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
    SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
    SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
    SQL.Add('   and cod_animal_sisbov between :cod_animal_sisbov_inicio');
    SQL.Add('                             and :cod_animal_sisbov_fim');
  end;

  FCodLocalizacaoSISBOVCI := -1;
  FCodPessoaProdutorCI := -1;
  FCodPropriedadeRuralCI := -1;
  FNIRFINCRAPropriedadeCI := '';
  FCNPJCPFProdutorCI := '';
end;

destructor TIntCodigosSisbov.Destroy;
begin
  FIntOrdensServico.Free;
  FQueryInsertHistorico.Free;

  inherited;
end;

function TIntCodigosSisbov.BuscarProdutor(SglProdutor,
  NumCNPJCPFProdutor: String): Integer;
const
  SQL_SGL: String =
    {$IFDEF MSSQL}
    'select ' +
    '  cod_pessoa_produtor ' +
    'from ' +
    '  tab_produtor ' +
    'where ' +
    '  sgl_produtor = :sgl_produtor ' +
    '  and dta_fim_validade is null ';
    {$ENDIF}
  SQL_NUM_CNPJ_CPF: String =
    {$IFDEF MSSQL}
    'select ' +
    '  tpr.cod_pessoa_produtor ' +
    'from ' +
    '  tab_produtor tpr, ' +
    '  tab_pessoa tp ' +
    'where ' +
    '  tp.cod_pessoa = tpr.cod_pessoa_produtor ' +
    '  and tp.num_cnpj_cpf = :num_cnpj_cpf ' +
    '  and tp.dta_fim_validade is null ' +
    '  and tpr.dta_fim_validade is null ';
    {$ENDIF}
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if SglProdutor <> '' then begin
      Q.SQL.Text := SQL_SGL;
      Q.ParamByName('sgl_produtor').AsString := SglProdutor;
    end else begin
      Q.SQL.Text := SQL_NUM_CNPJ_CPF;
      Q.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPFProdutor;
    end;
    Q.Open;
    if Q.IsEmpty then begin
      if SglProdutor <> '' then begin
        Mensagens.Adicionar(1768, Self.ClassName, 'BuscarProdutor', [SglProdutor]);
        Result := -1768;
      end else begin
        Mensagens.Adicionar(1769, Self.ClassName, 'BuscarProdutor', [NumCNPJCPFProdutor]);
        Result := -1769;
      end;
    end else begin
      Result := Q.Fields[0].AsInteger;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

// Removida por nao mais ser utilizada! foi substituida pela VerificaLocalizacaoSISBOVPropriedade da uIntPropriedadesRurais
{
function TIntCodigosSisbov.BuscarPropriedadeRural(
  NumImovelReceitaFederal: String): Integer;
const
  SQL: String =

    'select cod_propriedade_rural ' +
    '  from tab_propriedade_rural ' +
    ' where num_imovel_receita_federal = :num_imovel_receita_federal ' +
    '   and dta_fim_validade is null ';

var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    Q.SQL.Text := SQL;
    Q.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(1767, Self.ClassName, 'BuscarPropriedadeRural', [NumImovelReceitaFederal]);
      Result := -1767;
    end else begin
      Result := Q.Fields[0].AsInteger;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;
}

function TIntCodigosSisbov.Pesquisar(CodPaisSisBov,
                                     CodEstadoSisBov,
                                     CodMicroRegiaoSisBov,
                                     SeqInicial,
                                     SeqFinal: Integer;
                                     IndCodigoUtilizado,
                                     NomPessoa,
                                     NomPropriedade,
                                     SiglaProdutor: String;
                                     DtaInicioCadastramentoCodigos,
                                     DtaFimCadastramentoCodigos,
                                     DtaInicioUtilizacaoCodigos,
                                     DtaFimUtilizacaoCodigos: TDateTime;
                                     NumSolicitacaoSISBOV: Integer): Integer;
var
  Max : Integer;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(193) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  end;

  // Guarda valores da última pesquisa
  if (CodPaisSisbov <> FCodPaisSisbov) or
     (CodEstadoSisbov <> FCodEstadoSisbov) or
     (CodMicroRegiaoSisbov <> FCodMicroRegiaoSisbov) or
     (IndCodigoUtilizado <> FIndCodigoUtilizado) then begin
    FCodPaisSisbov := CodPaisSisbov;
    FCodEstadoSisbov := CodEstadoSisbov;
    FCodMicroRegiaoSisbov := CodMicroRegiaoSisbov;
    FIndCodigoUtilizado := IndCodigoUtilizado;
  end Else begin
    if Query.Active then begin
      Result := 0;
      Exit;
    end;
  end;

  if CodMicroRegiaoSisbov < - 1 then begin
    if CodEstadoSisbov = -1 then begin
      Mensagens.Adicionar(387, Self.ClassName, 'Pesquisar', []);
      Result := -387;
      Exit;
    end
    else if CodPaisSisbov = - 1 then begin
      Mensagens.Adicionar(402, Self.ClassName, 'Pesquisar', []);
      Result := -402;
      Exit;
    end;
  end;

  if CodEstadoSisbov <> - 1 then begin
    if CodPaisSisbov = - 1 then begin
      Mensagens.Adicionar(402, Self.ClassName, 'Pesquisar', []);
      Result := -402;
      Exit;
    end;
  end;

  // Obtem parâmetro com o máximo número de códigos sisbov para pesquisa
  Try
    Max := StrToInt(ValorParametro(25));
  except
    Result := -1;
    Exit;
  end;

  // select
  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select top ' + IntToStr(Max) + ' tcs.cod_pais_sisbov as CodPaisSisbov ');
  Query.SQL.Add('     , tcs.cod_estado_sisbov as CodEstadoSisbov ');
  Query.SQL.Add('     , tcs.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov');
  Query.SQL.Add('     , tcs.cod_animal_sisbov as CodAnimalSisBov ');
  Query.SQL.Add('     , tcs.num_dv_sisbov  as NumDvSisbov');
  Query.SQL.Add('     , case isnull(tcs.dta_utilizacao_codigo,0)   ');
  Query.SQL.Add('       when 0 then ''N'' else ''S'' ');
  Query.SQL.Add('       end as IndCodigoUtilizado ');
  if Trim(SiglaProdutor) = '' then
    Query.SQL.Add('     , case isnull(tcs.cod_pessoa_produtor,0) when 0 then '''' else tt.sgl_produtor end as SglProdutor ')
  else Query.SQL.Add(', tt.sgl_produtor as SglProdutor');
  Query.SQL.Add('     , tp.nom_pessoa ');
  Query.SQL.Add('     , tpr.nom_propriedade_rural ');
  Query.SQL.Add('     , tcs.dta_insercao_registro ');
  Query.SQL.Add('     , tcs.dta_utilizacao_codigo ');
  Query.SQL.Add('  from tab_codigo_sisbov tcs ');
  Query.SQL.Add('     , tab_pessoa tp ');
  Query.SQL.Add('     , tab_propriedade_rural tpr ');
  Query.SQL.Add('     , tab_produtor tt ');

  Query.SQL.Add(' where ((tcs.cod_pais_sisbov = :cod_pais_sisbov) or (:cod_pais_sisbov = -1)) ');
  Query.SQL.Add('   and ((tcs.cod_estado_sisbov = :cod_estado_sisbov) or (:cod_estado_sisbov = -1)) ');
  if CodMicroRegiaoSisBov <> -1 then begin
      Query.SQL.Add('   and ((tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov) or (:cod_micro_regiao_sisbov = -2)) ');
  end;

  if Trim(SiglaProdutor) <> '' then begin
    Query.SQL.Add('   and tt.sgl_produtor = :Sgl_Produtor ');
    Query.SQL.Add('   and tt.cod_pessoa_produtor = tp.cod_pessoa ');
  end;

  if Trim(NomPessoa) <> '' then begin
    Query.SQL.Add('   and tp.nom_pessoa like :Nom_Pessoa ');
    Query.SQL.Add('   and tp.cod_pessoa = tcs.cod_pessoa_produtor ');
  end;

  if Trim(NomPropriedade) <> '' then begin
    Query.SQL.Add('   and tpr.nom_propriedade_rural like :Nom_Propriedade ');
    if not ((DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0)) then begin
      Query.SQL.Add('   and tt.cod_pessoa_produtor = tp.cod_pessoa ');
    end;
    Query.SQL.Add('   and tcs.cod_propriedade_rural = tpr.cod_propriedade_rural ');
  end
  else begin
    Query.SQL.Add('   and tcs.cod_propriedade_rural *= tpr.cod_propriedade_rural ');
  end;

  if (((DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0)) or ((DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0))) then begin
    if (DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0) then begin
      Query.SQL.Add('   and tcs.dta_insercao_registro between :dta_inicio_cadastramento and :dta_fim_cadastramento ');
    end;
    if (DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0) then begin
      Query.SQL.Add('   and tcs.dta_utilizacao_codigo between :dta_inicio_utilizacao and :dta_fim_utilizacao ');
    end;
    if (Trim(NomPessoa) = '') and (Trim(SiglaProdutor) = '') then begin
      Query.SQL.Add('   and tcs.cod_pessoa_produtor *= tp.cod_pessoa ');
    end;
    if Trim(SiglaProdutor) <> '' then begin
      Query.SQL.Add('   and tcs.cod_pessoa_produtor = tt.cod_pessoa_produtor ');
    end
    else begin
      Query.SQL.Add('   and tcs.cod_pessoa_produtor *= tt.cod_pessoa_produtor ');
    end;
  end
  else begin
    Query.SQL.Add('   and tcs.cod_pessoa_produtor = tt.cod_pessoa_produtor ');
  end;

  if (SeqInicial > 0) and (SeqFinal > 0) then begin
    Query.SQL.Add('   and tcs.cod_animal_sisbov  between :SeqInicial and :SeqFinal ');
  end;

  if (Conexao.CodPapelUsuario = 3) then // Caso o usuário logado seja um técnico, filtrar por produtores relacionados a ele.
  begin
    Query.SQL.Add('   and tcs.cod_pessoa_produtor in (select cod_pessoa_produtor from tab_tecnico_produtor where cod_pessoa_tecnico = :cod_pessoa and dta_fim_validade is null) ');
  end
  else if (Conexao.CodPapelUsuario = 9) then // Caso o usuário logado seja um gestor, filtrar por produtores relacionados a ele.
  begin
    Query.SQL.Add('   and tcs.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ');
    Query.SQL.Add('                                   where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ');
  end;

  {Se o usuario entrar somente com a sequencia de codigos sisbov ou não entrar com
     nenhuma informação, eh preciso fazer o join com a tabela pessoa para o resultado
     nao repetir o codigo para cada pessoa}
  if (SiglaProdutor = '') and (NomPessoa = '') and (NomPropriedade = '') and (DtaInicioCadastramentoCodigos <= 0) and (DtaFimCadastramentoCodigos <= 0) and (DtaInicioUtilizacaoCodigos <= 0) and (DtaFimUtilizacaoCodigos <= 0) then begin
    Query.SQL.Add('   and tp.cod_pessoa = tt.cod_pessoa_produtor ');
  end;

  if UpperCase(IndCodigoUtilizado) = 'S' then begin
    Query.SQL.Add('   and tcs.dta_utilizacao_codigo is not null');
  end
  else if UpperCase(IndCodigoUtilizado) = 'N' then begin
    Query.SQL.Add('   and tcs.dta_utilizacao_codigo is null');
  end
  else if UpperCase(IndCodigoUtilizado) = 'R' then begin
    Query.SQL.Add('   and tcs.cod_pessoa_produtor is not null');
    Query.SQL.Add('   and tcs.dta_utilizacao_codigo is null');
  end;

  if NumSolicitacaoSISBOV > 0 then begin
    Query.SQL.Add('   and tcs.num_solicitacao_sisbov = :num_solicitacao_sisbov');
  end;

  {Ordenando os códigos sisbov em ordem crescente...}
  Query.SQL.Add(' order by CodPaisSisbov,        ');
  Query.SQL.Add('          CodEstadoSisbov,      ');
  Query.SQL.Add('          CodMicroRegiaoSisbov, ');
  Query.SQL.Add('          CodAnimalSisBov       ');

{$ENDIF}
  if Trim(NomPessoa) <> '' then begin
    Query.ParamByName('Nom_Pessoa').AsString := '%'+NomPessoa+'%';
  end;
  if Trim(NomPropriedade) <> '' then begin
   Query.ParamByName('Nom_Propriedade').AsString := '%'+NomPropriedade+'%';
  end;
  if Trim(SiglaProdutor) <> '' then begin
   Query.ParamByName('Sgl_Produtor').AsString := SiglaProdutor;
  end;
  if (DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0) then begin
    Query.ParamByName('dta_inicio_cadastramento').AsDateTime := DtaInicioCadastramentoCodigos;
    Query.ParamByName('dta_fim_cadastramento').AsDateTime := DtaFimCadastramentoCodigos + 1;
  end;
  if (DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0) then begin
    Query.ParamByName('dta_inicio_utilizacao').AsDateTime := DtaInicioUtilizacaoCodigos;
    Query.ParamByName('dta_fim_utilizacao').AsDateTime := DtaFimUtilizacaoCodigos + 1;
  end;

  Query.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
  Query.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;

  if CodMicroRegiaoSisBov <> -1 then begin
      if CodMicroRegiaoSisBov = 88 then //Parametro passado pela pagina ASP. -1 no ASP é padrão para parametro não informado!
         Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := -1
      else
         Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisBov;
  end;

  if (SeqInicial > 0) and (SeqFinal > 0) then begin
    Query.ParamByName('SeqInicial').AsInteger := SeqInicial;
    Query.ParamByName('SeqFinal').AsInteger := SeqFinal;
  end;

  if NumSolicitacaoSISBOV > 0 then begin
    Query.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
  end;

  if (Conexao.CodPapelUsuario = 3) or // Técnico
     (Conexao.CodPapelUsuario = 9) then // Gestor
  begin
    Query.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
  end;

  Try
    Query.Open;

    if Query.RecordCount = Max then begin
      Mensagens.Adicionar(1151, Self.ClassName, 'Pesquisar', [IntToStr(Max), IntToStr(Max)]);
      Result := 1151;
      Exit;
    end;

    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(524, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -524;
      Exit;
    end;
  end;
end;

function TIntCodigosSisbov.Inserir(CodPessoaProdutor: Integer;
  SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NumSolicitacaoSISBOV: Integer;
  DtaSolicitacaoSISBOV: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim, CodigoOS: Integer): Integer;
const
  CodMetodo : Integer = 82;
  NomMetodo : String = 'Inserir';
var
  Q : THerdomQuery;
  GerarAtualizarOrdemServico: Boolean;
  Contador, CodAnimalSISBOV, NumDVSISBOV, NumDiasUnicidadeSolicitacao,
  CodPais, CodEstado, CodOrdemServico : Integer;
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  if NumSolicitacaoSISBOV <> 999999999 then begin
    // Verifica se o número da solicitação foi informado corretamente
    if NumSolicitacaoSISBOV <= 0 then begin
      Mensagens.Adicionar(1911, Self.ClassName, NomMetodo, []);
      Result := -1911;
      Exit;
    end;

    // Verifica se a data da solicitação foi informada corretamente
    if (DtaSolicitacaoSISBOV = 0) or (DtaSolicitacaoSISBOV < EncodeDate(2004, 01, 01)) then begin
      Mensagens.Adicionar(1912, Self.ClassName, NomMetodo, []);
      Result := -1912;
      Exit;
    end;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  // Busca parâmetro que indica o número de dias para verificação da
  // unicidade de número da solicitação SISBOV
  NumDiasUnicidadeSolicitacao := StrToInt(ValorParametro(PRAZO_DIAS_UNICIDADE_SOLICITACAO));
  if (DtaSolicitacaoSISBOV < (Date - NumDiasUnicidadeSolicitacao)) then begin
    Mensagens.Adicionar(2029, Self.ClassName, NomMetodo, []);
    Result := -2029;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens, NumImovelReceitaFederal, CodPropriedadeRural,
                                                                                        CodLocalizacaoSisbov, CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      // Busca parâmetro que indica se o sistema deve ou não gerar/atualizar
      // ordens de serviço referentes a novos códigos SISBOV inseridos
      GerarAtualizarOrdemServico :=
        (ValorParametro(GERAR_ATUALIZAR_ORDENS_SERVICO) = 'S');

      //--------------
      // Consiste país
      //--------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      //-----------------
      // Consiste estado
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      //-----------------------
      // Consiste micro-região
      //-----------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
        Result := -299;
        Exit;
      end;

      // Verifica se o estado da propriedade corresponde ao estado do código SISBOV
      Q.Close;
      Q.SQL.Text :=
        'select ' +
        '  cod_estado ' +
        'from ' +
        '  tab_propriedade_rural ' +
        'where ' +
        '  cod_propriedade_rural = :cod_propriedade_rural ' +
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      if Q.FieldByName('cod_estado').AsInteger <> CodEstado then begin
        Mensagens.Adicionar(1944, Self.ClassName, NomMetodo, []);
        Result := -1944;
        Exit;
      end;

      //------------------------------------------------------------------------
      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      //------------------------------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      //---------------
      // Abre transação
      //---------------
      beginTran;

      //--------------------------------------
      // Verifica existência do código sisbov
      //--------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(300, Self.ClassName, NomMetodo, []);
        Result := -300;
        Rollback;
        Exit;
      end;

      // Testa numero da solicitação para códigos associados a animais diferentes
      // de animais de origem compra.
      if NumSolicitacaoSISBOV <> 999999999 then begin
        //----------------------------------------------------------------------------
        // Verifica existência do número de solicitação dentro do período identificado
        //----------------------------------------------------------------------------
        Q.Close;
  {$IFDEF MSSQL}
        Q.SQL.Text :=
          'select top 1 dta_solicitacao_sisbov ' +
          'from tab_codigo_sisbov ' +
          'where num_solicitacao_sisbov = :num_solicitacao_sisbov ' +
          'and dta_solicitacao_sisbov <> :dta_solicitacao_sisbov ';
  {$ENDIF}
        Q.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
        Q.ParamByName('dta_solicitacao_sisbov').AsDateTime := DtaSolicitacaoSISBOV;
        Q.Open;

        if not Q.IsEmpty then begin
          Mensagens.Adicionar(1923, Self.ClassName, NomMetodo, [intToStr(NumSolicitacaoSISBOV)]);
          Result := -1923;
          Rollback;
          Exit;
        end;
      end;

      //------------------------
      // Tenta Inserir Registros
      //------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_codigo_sisbov ' +
                  ' (cod_pais_sisbov, ' +
                  '  cod_estado_sisbov, ' +
                  '  cod_micro_regiao_sisbov, ' +
                  '  cod_animal_sisbov, ' +
                  '  num_dv_sisbov, ' +
                  '  dta_insercao_registro, ' +
                  '  dta_utilizacao_codigo, '+
                  '  cod_pessoa_produtor, ' +
                  '  cod_propriedade_rural,' +
                  '  ind_data_liberacao_estimada,' +
                  '  num_solicitacao_sisbov, ' +
                  '  dta_solicitacao_sisbov, ' +
                  '  cod_ordem_servico, ' +
                  '  cod_situacao_codigo_sisbov,'+
                  '  dta_mudanca_situacao,' +
                  '  cod_usuario_mudanca, ' +
                  '  cod_usuario_ultima_alteracao, ' +
                  '  dta_ultima_alteracao ) ' +
                  'values  ' +
                  ' (:cod_pais_sisbov, ' +
                  '  :cod_estado_sisbov, ' +
                  '  :cod_micro_regiao_sisBov, ' +
                  '  :cod_animal_sisbov, ' +
                  '  :num_dv_sisbov, ' +
                  '  getdate(), ' +
                  '  null, ' +
                  '  :cod_pessoa_produtor, ' +
                  '  :cod_propriedade_rural,' +
                  '  null,' +
                  '  :num_solicitacao_sisbov, ' +
                  '  :dta_solicitacao_sisbov, ' +
                  '  :cod_ordem_servico, ' +
                  '  1,' +
                  '  getDate(),' +
                  '  :cod_usuario_mudanca, ' +
                  '  :cod_usuario_ultima_alteracao, ' +
                  '  getDate() ) ');
  {$ENDIF}


      Q.Close;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      Q.ParamByName('dta_solicitacao_sisbov').AsDateTime := DtaSolicitacaoSISBOV;
      if CodigoOS > 0 then begin
        Q.ParamByName('cod_ordem_servico').AsInteger := CodigoOS;
      end else begin
        Q.ParamByName('cod_ordem_servico').DataType := ftInteger;
        Q.ParamByName('cod_ordem_servico').Clear;
      end;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      for CodAnimalSISBOV := CodAnimalSISBOVInicio to CodAnimalSISBOVFim do
      begin
        //--------------------------
        //Busca o Digito Verificador
        //--------------------------

        NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV);

        if NumDVSISBOV = -1 then begin
          Mensagens.Adicionar(526, Self.ClassName, NomMetodo, []);
          Result := -526;
          Rollback;  // desfaz transação se houver uma ativa
          Exit;
        end;

        Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
        Q.ParamByName('num_dv_sisbov').AsInteger := NumDVSISBOV;
        Q.ExecSQL;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      if NumSolicitacaoSISBOV <> 999999999 then begin
        // Gera ordem de serviço correspondente
        if GerarAtualizarOrdemServico then begin
          CodOrdemServico := FIntOrdensServico.AtualizarSolicitacaoSISBOV(CodPessoaProdutor,
            CodPropriedadeRural, (CodAnimalSISBOVFim - CodAnimalSISBOVInicio + 1),
            NumSolicitacaoSISBOV, CodPaisSISBOV, CodEstadoSISBOV,
            CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
            Conexao, Mensagens);
          if CodOrdemServico < 0 then begin
            Result := CodOrdemServico;
            Rollback;
            Exit;
          end;
        end else begin
          CodOrdemServico := -1;
        end;

        if CodOrdemServico > 0 then begin
          Q.Close;
          Q.SQL.Text :=
            'update ' +
            '  tab_codigo_sisbov ' +
            'set ' +
            '  cod_ordem_servico = :cod_ordem_servico ' +
            'where ' +
            '  cod_pais_sisbov = :cod_pais_sisbov ' +
            '  and cod_estado_sisbov = :cod_estado_sisbov ' +
            '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
            '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
            '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
            '  and cod_propriedade_rural = :cod_propriedade_rural ';
          Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
          Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
          Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
          Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
          Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
          Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          Q.ExecSQL;
        end;
      end;
      Commit;

      ZerarValoresUltimaPesquisa;

      Mensagens.Adicionar(767, Self.ClassName, NomMetodo,
        [IntToStr(CodAnimalSISBOVFim - CodAnimalSISBOVInicio + 1)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(301, Self.ClassName, NomMetodo, [E.Message]);
        Result := -301;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.Excluir(CodPessoaProdutor: Integer;
  SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
var
  Q : THerdomQuery;
  quant_utilizado, quant_nao_utilizado: Integer;
  Contador, CodPais, CodEstado, NumDVSISBOV : Integer;
const
  CodMetodo : Integer = 249;
  NomMetodo : String = 'Excluir';
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens, NumImovelReceitaFederal, CodPropriedadeRural,
                                                                                        CodLocalizacaoSisbov, CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      //--------------
      // Consiste país
      //--------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;
      //-----------------
      // Consiste estado
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      //-----------------------
      // Consiste micro-região
      //-----------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
        Result := -299;
        Exit;
      end;

      //------------------------------------------------------------------------
      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      //------------------------------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      //-----------------------------------------------
      // Verifica existência do código sisbov utilizado
      //-----------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(1) as QtdUtilizado ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_utilizacao_codigo is not null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      quant_utilizado := Q.FieldByName('QtdUtilizado').AsInteger;

      //---------------------------------------------------
      // Verifica existência do código sisbov não utilizado
      //---------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(1) as QtdNaoUtilizado ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_utilizacao_codigo is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      quant_nao_utilizado := Q.FieldByName('QtdNaoUtilizado').AsInteger;

      if quant_nao_utilizado + quant_utilizado = 0 then begin
         Mensagens.Adicionar(753, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
         Result := -753;
         Exit;
       end;

      //---------------------------------------------------------------------------------
      // Verifica existência de alguma ordem de serviço associada a um dos códigos SISBOV
      //---------------------------------------------------------------------------------
      Q.Close;
      Q.SQL.Text :=
        'select ' +
        '  1 ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
        '  and cod_ordem_servico is not null  ';
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(1962, Self.ClassName, NomMetodo, []);
        Result := -1962;
        Exit;
      end;

      //---------------
      // Abre transação
      //---------------
      beginTran;

      InserirHistorico(CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'S');

      //------------------------
      // Tenta Excluir Registros
      //------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_codigo_sisbov ' +
                ' where ' +
                '  cod_pais_sisbov =:cod_pais_sisbov ' +
                '  and cod_estado_sisbov =:cod_estado_sisbov ' +
                '  and cod_micro_regiao_sisbov =:cod_micro_regiao_sisBov ' +
                '  and cod_animal_sisbov between :cod_animal_sisbov_i and :cod_animal_sisbov_f ' +
                '  and dta_utilizacao_codigo is null '+
                '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '  and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisBov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisBov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisBov;
      Q.ParamByName('cod_animal_sisbov_i').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_f').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ExecSQL;

      Commit;

      ZerarValoresUltimaPesquisa;

      Mensagens.Adicionar(749, Self.ClassName, NomMetodo, [inttostr(Q.RowsAffected),inttostr(quant_nao_utilizado+quant_utilizado),inttostr(quant_utilizado)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(748, Self.ClassName, NomMetodo, [E.Message]);
        Result := -748;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TIntCodigosSisbov.PrepararLinha(Relatorio: TRelatorioPadrao;
  Query: THerdomQuery; var Observacao: Boolean);
const
  CodSISBOVFormatadoMinimo: String = 'CodSISBOVFormatadoMinimo';
  CodSISBOVFormatadoMaximo: String = 'CodSISBOVFormatadoMaximo';
var
  Complemento: String;
  AtualizaMinimo, AtualizaMaximo: Boolean;
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV: Integer;

  function CodSISBOVFormatado(CodAnimalSISBOV: Integer): String;
  var
    NumDvSISBOV: Integer;
  begin
    NumDVSISBOV := BuscarDVSisBov(CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSISBOV);
    if NumDvSISBOV <> -1 then begin
      if CodMicroRegiaoSISBOV = -1 then begin
        Result :=
          StrZero(CodPaisSISBOV, 3) +
          StrZero(CodEstadoSISBOV, 2) +
          StrZero(CodAnimalSISBOV, 9) +
          StrZero(NumDvSISBOV, 1) +
          Complemento;
      end else begin
        Result :=
          StrZero(CodPaisSISBOV, 3) +
          StrZero(CodEstadoSISBOV, 2) +
          StrZero(CodMicroRegiaoSISBOV, 2) +
          StrZero(CodAnimalSISBOV, 9) +
          StrZero(NumDvSISBOV, 1) +
          Complemento;
      end;
    end;
  end;

begin
  AtualizaMinimo := Assigned(Query.Fields.FindField(CodSISBOVFormatadoMinimo));
  AtualizaMaximo := Assigned(Query.Fields.FindField(CodSISBOVFormatadoMaximo));
  Relatorio.Campos.CarregarValores(Query);
  if AtualizaMinimo or AtualizaMaximo then begin
    CodPaisSisbov := Query.FieldByName('cod_pais_sisbov').AsInteger;
    CodEstadoSisbov := Query.FieldByName('cod_estado_sisbov').AsInteger;
    CodMicroRegiaoSisbov := Query.FieldByName('cod_micro_regiao_sisbov').AsInteger;
    if Query.FieldByName('QtdTotal').AsInteger <>
      Query.FieldByName('cod_animal_sisbov_maximo').AsInteger -
      Query.FieldByName('cod_animal_sisbov_minimo').AsInteger + 1 then begin
      Complemento := ' *';
      Observacao := True;
    end else begin
      Complemento := '';
    end;
    if AtualizaMinimo then begin
      Relatorio.Campos.ValorCampo[CodSISBOVFormatadoMinimo] :=
        CodSISBOVFormatado(Query.FieldByName('cod_animal_sisbov_minimo').AsInteger);
    end;
    if AtualizaMaximo then begin
      Relatorio.Campos.ValorCampo[CodSISBOVFormatadoMaximo] :=
          CodSISBOVFormatado(Query.FieldByName('cod_animal_sisbov_maximo').AsInteger);
    end;
  end;
end;

procedure TIntCodigosSisbov.ZerarValoresUltimaPesquisa;
begin
  FCodPaisSisbov := 0;
  FCodEstadoSisbov := 0;
  FCodMicroRegiaoSisbov := 0;
  FIndCodigoUtilizado := '';
end;

function TIntCodigosSisbov.PesquisarRelatorioConsolidado(Query: THerdomQuery;
                                                         CodEstado,
                                                         SglProdutor,
                                                         NomPessoaProdutor,
                                                         NumCNPJCPFProdutor,
                                                         NumImovelReceitaFederal: String;
                                                         CodLocalizacaoSisbov: Integer;
                                                         NomPropriedadeRural,
                                                         NomMunicipioPropriedadeRural: String;
                                                         DtaSolicitacaoSISBOVInicio,
                                                         DtaSolicitacaoSISBOVFim,
                                                         DtaInsercaoInicio,
                                                         DtaInsercaoFim,
                                                         DtaUtilizacaoInicio,
                                                         DtaUtilizacaoFim,
                                                         DtaLiberacaoAbateInicio,
                                                         DtaLiberacaoAbateFim,
                                                         DtaExpiracaoInicio,
                                                         DtaExpiracaoFim: TDateTime;
                                                         CodSituacoesCodigoSISBOV: String;
                                                         var Totalizadores: TTotalizadoresArray;
                                                         CodTarefa: Integer): Integer;
const
  NomMetodo: String = 'PesquisarRelatorioConsolidado';
  CodRelatorio: Integer = 12;

  // Indicadores utilizados como campos que determinam a inclusão ou
  // exclusão de alguma string SQL
  ccDesprezar = -1;
  ccAdicionar = 0;

  // Campos que compõe o relatório
  ccSglEstado: Integer = 1;
  ccNomEstado: Integer = 2;
  ccQtdDisponiveis: Integer = 3;
  ccQtdUtilizados: Integer = 4;
  ccQtdTotal: Integer = 5;
  ccCodSISBOVFormatadoMinimo: Integer = 6;
  ccCodSISBOVFormatadoMaximo: Integer = 7;
  ccSglProdutor: Integer = 8;
  ccNomReduzidoPessoaProdutor: Integer = 9;
  ccNumCNPJCPFFormatadoProdutor: Integer = 10;
  ccNumImovelReceitaFederal: Integer = 11;
  ccNomPropriedadeRural: Integer = 12;
  ccNomMunicipioPropriedadeRural: Integer = 13;
  ccNumSolicitacaoSISBOV: Integer = 14;
  ccDtaSolicitacaoSISBOV: Integer = 15;
  ccDtaInsercao: Integer = 16;
  ccDtaUtilizacao: Integer = 17;
  ccDtaLiberacaoAbate: Integer = 18;
  ccIndDataLiberacaoEstimada: Integer = 19;
  ccNumOrdemServico: Integer = 20;
  ccSglSituacaoCodigoSISBOV: Integer = 21;
  ccDesSituacaoCodigoSISBOV: Integer = 22;
  ccDtaExpiracaoCodigo: Integer = 23;
  ccNomPessoaProdutor: Integer = 24;
  ccNomFazenda: Integer = 25;
  ccDtaEnvioCertificado: Integer = 26;
  ccNomServicoEnvio: Integer = 27;
  ccNumConhecimento: Integer = 28;
  ccCodLocalizacaoSisbov: Integer = 29;
var
  sAux, PeriodoExpiracao: String;
  iAux: Integer;
  CodCampo: Integer;
  IntRelatorios: TIntRelatorios;
  bPersonalizavel, bGroupBy, bGroupByFirst, bOrderByFirst: Boolean;
  Param: TValoresParametro;

  function SQL(Linha: String; VerificaCampo: Integer): Boolean; overload;
  begin
    Result := False;
    if (VerificaCampo <> -1) then
    begin
      Result := (VerificaCampo = 0) or not(bPersonalizavel)
        or (IntRelatorios.CampoAssociado(VerificaCampo) = 1);
      if Result then
      begin
        Query.SQL.Text := Query.SQL.Text + Linha;
      end;
    end;
  end;

  function SQL(Linha: String; VerificaCampos: Array Of Integer): Boolean; overload;
  var
    iAuxPesquisa: Integer;
  begin
    iAuxPesquisa := 0;
    Result := not(bPersonalizavel);
    while (iAuxPesquisa < Length(VerificaCampos)) and (not Result) do
    begin
      Result := (IntRelatorios.CampoAssociado(VerificaCampos[iAuxPesquisa]) = 1);
      Inc(iAuxPesquisa);
    end;
    if Result then
    begin
      SQL(Linha, ccAdicionar);
    end;
  end;

  function SQLgb(Linha: String; VerificaCampos: Array Of Integer): Boolean;
  var
    iAuxPesquisa: Integer;
  begin
    iAuxPesquisa := 0;
    Result := not(bPersonalizavel);
    while (iAuxPesquisa < Length(VerificaCampos)) and (not Result) do
    begin
      Result :=
        (IntRelatorios.CampoAssociado(VerificaCampos[iAuxPesquisa]) = 1);
      Inc(iAuxPesquisa);
    end;
    if Result then
    begin
      if bGroupByFirst then
      begin
        bGroupByFirst := False;
        Linha := '  ' + Linha;
      end
      else
      begin
        Linha := '  , ' + Linha;
      end;
      SQL(Linha, ccAdicionar);
    end;
  end;

  function CamposAssociados(VerificaCampos: Array Of Integer): Boolean;
  var
    iAuxPesquisa: Integer;
  begin
    iAuxPesquisa := 0;
    Result := not(bPersonalizavel);
    while (iAuxPesquisa < Length(VerificaCampos)) and (not Result) do
    begin
      Result := (IntRelatorios.CampoAssociado(VerificaCampos[iAuxPesquisa]) = 1);
      Inc(iAuxPesquisa);
    end;
  end;

begin
  {----------------------------------------------------------------------------
  * notas sobre esta função

    Esta função contrói uma query de acordo com  os  campos  selecionados  pelo
  usuário o relatório, levando em conta também os critérios por  ele  informado
  para a seleção dos animais do relatório.
    Para isto algumas procedures internas foram  criadas  visando  facilitar  o
  procedimento principal. As function´s criadas são:

  SQL('<linha a ser inserida no SQL da query>', <número do campo do relatório>)
  - Esta função condiciona a inclusão da <linha a ser inserida no SQL da query>
  somente se o <número do campo do relatório> for 0 (zero) ou o  usuário  tiver
  selecionado esse campo para ser apresentado no relatório, quando o valor "-1"
  é a linha é descosiderada imediantamente, não sendo incluída.

  SQL('<linha a ser inserida no SQL da query>', <lista de campos do relatório>)
  - Esta função condiciona a inclusão da <linha a ser inserida no SQL da query>
  somente se pelo menos um dos campo da <lista de campos do relatório> tiver
  sido selecionada pelo usuário para ser apresentado no relatório.

  SQL('<campo a ser inserido no segmento de group by do SQL da query>', <núme-
  ro do campo do relatório >)
  - Esta função condiciona a inclusão do <campo a ser inserido no segmento de
  group by do SQL da query> somente se o <número do campo do relatório> for
  selecionado para ser apresentado no relatório.

  Ambas as funções retornam verdadeiro (TRUE) quando uma  linha  é  inserida  e
  falso (FALSE) quando não.
  ----------------------------------------------------------------------------}
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  Param := TValoresParametro.Create(TValorParametro);
  try
    Param.Clear;
    if CodSituacoesCodigoSISBOV <> '' then
    begin
      Result := VerificaParametroMultiValor(CodSituacoesCodigoSISBOV, Param);
      if Result < 0 then
      begin
        Exit;
      end;
      Param.Clear;
    end;
  finally
    Param.Free;
  end;

  Param := TValoresParametro.Create(TValorParametro);
  Try
    Param.Clear;
    if CodEstado <> '' then
    begin
      Result := VerificaParametroMultiValor(CodEstado, Param);
      if Result < 0 then
      begin
        Exit;
      end;
      Param.Clear;
    end;
  finally
    Param.Free;
  end;
  

  IntRelatorios := TIntRelatorios.Create;
  try
    Result := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := IntRelatorios.Buscar(CodRelatorio);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := IntRelatorios.Pesquisar(CodRelatorio);
    if Result < 0 then
    begin
      Exit;
    end;

    try
      bPersonalizavel := (IntRelatorios.IntRelatorio.IndPersonalizavel = 'S');
      bGroupBy := False;
      bGroupByFirst := True;
      bOrderByFirst := True;
      IntRelatorios.IrAoPrimeiro;
      while not(IntRelatorios.EOF) and not(bGroupBy) do
      begin
        CodCampo := IntRelatorios.ValorCampo('CodCampo');
        if not (CodCampo in [ccQtdDisponiveis, ccQtdUtilizados, ccQtdTotal]) then
        begin
          if not bPersonalizavel or
            (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S') or
            (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S') and not(bGroupBy) then
          begin
            bGroupBy := True;
          end;
        end;
        IntRelatorios.IrAoProximo;
      end;

      if (DtaExpiracaoInicio > 0) and (DtaExpiracaoFim > 0) then
        PeriodoExpiracao := ValorParametro(91);

      Query.Close;
      Query.SQL.Clear;
      {$IFDEF MSSQL}
      SQL('select ', ccAdicionar);
      SQL('  null as TxtAjuste ', ccAdicionar);
      SQL('  , te.sgl_estado as SglEstado ', ccSglEstado);
      SQL('  , te.nom_estado as NomEstado ', ccNomEstado);
      SQL('  , tcs.cod_pais_sisbov as cod_pais_sisbov ', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , tcs.cod_estado_sisbov as cod_estado_sisbov ', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , tcs.cod_micro_regiao_sisbov as cod_micro_regiao_sisbov ', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , min(tcs.cod_animal_sisbov) as cod_animal_sisbov_minimo ', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , max(tcs.cod_animal_sisbov) as cod_animal_sisbov_maximo ', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , replicate(''?'', 19) as CodSISBOVFormatadoMinimo ', ccCodSISBOVFormatadoMinimo);
      SQL('  , replicate(''?'', 19) as CodSISBOVFormatadoMaximo ', ccCodSISBOVFormatadoMaximo);
      SQL('  , tr.sgl_produtor as SglProdutor ', ccSglProdutor);
      SQL('  , tp.nom_reduzido_pessoa as NomReduzidoPessoaProdutor ', ccNomReduzidoPessoaProdutor);
      SQL('  , tp.nom_pessoa as NomPessoaProdutor ', ccNomPessoaProdutor);
      SQL('  , case tp.cod_natureza_pessoa ', ccNumCNPJCPFFormatadoProdutor);
      SQL('      when ''F'' then convert(varchar(18), ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 10, 2)) ', ccNumCNPJCPFFormatadoProdutor);
      SQL('      when ''J'' then convert(varchar(18), ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ', ccNumCNPJCPFFormatadoProdutor);
      SQL('                          substring(tp.num_cnpj_cpf, 13, 2)) ', ccNumCNPJCPFFormatadoProdutor);
      SQL('    end as NumCNPJCPFFormatadoProdutor ', ccNumCNPJCPFFormatadoProdutor);
      SQL('  , tpr.num_imovel_receita_federal as NumImovelReceitaFederal ', ccNumImovelReceitaFederal);
      SQL('  , tls.cod_localizacao_sisbov as CodLocalizacaoSisbov ', ccCodLocalizacaoSisbov);      
      SQL('  , tpr.nom_propriedade_rural as NomPropriedadeRural ', ccNomPropriedadeRural);
      SQL('  , tm.nom_municipio as NomMunicipioPropriedadeRural ', ccNomMunicipioPropriedadeRural);
      SQL('  , tcs.num_solicitacao_sisbov as NumSolicitacaoSISBOV ', ccNumSolicitacaoSISBOV);
      SQL('  , cast(round(cast(tcs.dta_solicitacao_sisbov as float), 0, 1) as smalldatetime) as DtaSolicitacaoSISBOV ', ccDtaSolicitacaoSISBOV);
      SQL('  , cast(round(cast(tcs.dta_insercao_registro as float), 0, 1) as smalldatetime) as DtaInsercao ', ccDtaInsercao);
      SQL('  , cast(round(cast(tcs.dta_utilizacao_codigo as float), 0, 1) as smalldatetime) as DtaUtilizacao ', ccDtaUtilizacao);
      SQL('  , cast(round(cast(tcs.dta_liberacao_abate as float), 0, 1) as smalldatetime) as DtaLiberacaoAbate ', ccDtaLiberacaoAbate);
      SQL('  , case when tcs.cod_situacao_codigo_sisbov in (1, 2) then tcs.dta_solicitacao_sisbov + ' + ValorParametro(91), ccDtaExpiracaoCodigo);
      SQL('                                                       else null end as DtaExpiracao', ccDtaExpiracaoCodigo);
      SQL('  , tcs.ind_data_liberacao_estimada as IndDataLiberacaoEstimada ', ccIndDataLiberacaoEstimada);
      SQL('  , tos.num_ordem_servico as NumOrdemServico ', ccNumOrdemServico);
      SQL('  , tscs.sgl_situacao_codigo_sisbov as SglSituacaoCodigoSisbov ', ccSglSituacaoCodigoSISBOV);
      SQL('  , tscs.des_situacao_codigo_sisbov as DesSituacaoCodigoSisbov ', ccDesSituacaoCodigoSISBOV);
      SQL('  , sum(case isnull(tcs.dta_utilizacao_codigo, 0) when 0 then 1 else 0 end) as QtdDisponiveis ', ccQtdDisponiveis);
      SQL('  , sum(case isnull(tcs.dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) as QtdUtilizados ', ccQtdUtilizados);
      SQL('  , count(tcs.cod_animal_sisbov) as QtdTotal ', [ccQtdTotal, ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQL('  , tf.nom_fazenda as NomFazenda ', ccNomFazenda);
      SQL('  , tcs.dta_envio_certificado as DtaEnvioCertificado ', ccDtaEnvioCertificado);
      SQL('  , teec.nom_servico_envio as NomServicoEnvio ', ccNomServicoEnvio);
      SQL('  , teec.num_conhecimento as NumConhecimento ', ccNumConhecimento);
      SQL('from ', ccAdicionar);
      SQL('  tab_codigo_sisbov tcs ', ccAdicionar);
      SQL('  inner join tab_estado te on tcs.cod_estado_sisbov = te.cod_estado_sisbov ', SE(CamposAssociados([ccSglEstado, ccNomEstado]) or (CodEstado <> ''), ccAdicionar, ccDesprezar));
      SQL('  inner join tab_situacao_codigo_sisbov tscs on tcs.cod_situacao_codigo_sisbov = tscs.cod_situacao_codigo_sisbov ', [ccSglSituacaoCodigoSISBOV, ccDesSituacaoCodigoSISBOV]);
      SQL('  left outer join tab_produtor tr on tcs.cod_pessoa_produtor = tr.cod_pessoa_produtor ', SE(CamposAssociados([ccSglProdutor]) or (SglProdutor <> ''), ccAdicionar, ccDesprezar));
      SQL('  left outer join tab_pessoa tp on tcs.cod_pessoa_produtor = tp.cod_pessoa ', SE(CamposAssociados([ccNomReduzidoPessoaProdutor, ccNumCNPJCPFFormatadoProdutor, ccNomPessoaProdutor]) or (NomPessoaProdutor <> '') or (NumCNPJCPFProdutor <> ''), ccAdicionar, ccDesprezar));
      SQL('  left outer join tab_propriedade_rural tpr on tcs.cod_propriedade_rural = tpr.cod_propriedade_rural ', SE(CamposAssociados([ccNumImovelReceitaFederal, ccNomPropriedadeRural, ccNomMunicipioPropriedadeRural]) or (NumImovelReceitaFederal <> '') or (NomPropriedadeRural <> '') or (NomMunicipioPropriedadeRural <> ''), ccAdicionar, ccDesprezar));
      SQL('  left outer join tab_municipio tm on tpr.cod_municipio = tm.cod_municipio ', SE(CamposAssociados([ccNomMunicipioPropriedadeRural]) or (NomMunicipioPropriedadeRural <> ''), ccAdicionar, ccDesprezar));
      SQL('  left outer join tab_ordem_servico tos on tcs.cod_ordem_servico = tos.cod_ordem_servico ', ccNumOrdemServico);
      SQL('  left outer join tab_fazenda tf on tcs.cod_propriedade_rural = tf.cod_propriedade_rural and tcs.cod_pessoa_produtor = tf.cod_pessoa_produtor and tf.dta_fim_validade is null', ccNomFazenda);
      SQL('  left outer join tab_evento_envio_certificado teec on tcs.cod_pessoa_produtor = teec.cod_pessoa_produtor and tcs.cod_evento_envio_certificado = teec.cod_evento ', [ccNomServicoEnvio, ccNumConhecimento]);
      SQL('  left outer join tab_localizacao_sisbov tls on tcs.cod_pessoa_produtor = tls.cod_pessoa_produtor and tcs.cod_propriedade_rural = tls.cod_propriedade_rural',SE(CamposAssociados([ccCodLocalizacaoSisbov]) or (CodLocalizacaoSisbov > 0), ccAdicionar, ccDesprezar));
      SQL('where ', ccAdicionar);
      SQL('  1 = 1 ', ccAdicionar);
      SQL('  and te.cod_estado in ( ' + CodEstado + ' ) ', SE(CodEstado <> '', ccAdicionar, ccDesprezar));
      SQL('  and tr.sgl_produtor = :sgl_produtor ', SE(SglProdutor <> '', ccAdicionar, ccDesprezar));
      SQL('  and tp.nom_pessoa like :nom_pessoa ', SE(NomPessoaProdutor <> '', ccAdicionar, ccDesprezar));
      SQL('  and tp.num_cnpj_cpf = :num_cnpj_cpf ', SE(NumCNPJCPFProdutor <> '', ccAdicionar, ccDesprezar));
      SQL('  and tpr.num_imovel_receita_federal = :num_imovel_receita_federal ', SE(NumImovelReceitaFederal <> '', ccAdicionar, ccDesprezar));
      SQL('  and tpr.nom_propriedade_rural like :nom_propriedade_rural ', SE(NomPropriedadeRural <> '', ccAdicionar, ccDesprezar));
      SQL('  and tm.nom_municipio like :nom_municipio ', SE(NomMunicipioPropriedadeRural <> '', ccAdicionar, ccDesprezar));
      SQL('  and (tcs.dta_solicitacao_sisbov >= :dta_solicitacao_sisbov_inicio and tcs.dta_solicitacao_sisbov < :dta_solicitacao_sisbov_fim ) ', SE((DtaSolicitacaoSISBOVInicio> 0) and (DtaSolicitacaoSISBOVFim > 0), ccAdicionar, ccDesprezar));
      SQL('  and (tcs.dta_insercao_registro >= :dta_insercao_registro_inicio and tcs.dta_insercao_registro < :dta_insercao_registro_fim ) ', SE((DtaInsercaoInicio > 0) and (DtaInsercaoFim > 0), ccAdicionar, ccDesprezar));
      SQL('  and (tcs.dta_utilizacao_codigo >= :dta_utilizacao_codigo_inicio and tcs.dta_utilizacao_codigo < :dta_utilizacao_codigo_fim ) ', SE((DtaUtilizacaoInicio > 0) and (DtaUtilizacaoFim > 0), ccAdicionar, ccDesprezar));
      SQL('  and (tcs.dta_liberacao_abate >= :dta_liberacao_abate_inicio and tcs.dta_liberacao_abate < :dta_liberacao_abate_fim ) ', SE((DtaLiberacaoAbateInicio > 0) and (DtaLiberacaoAbateFim > 0), ccAdicionar, ccDesprezar));
      SQL('  and (( (tcs.dta_solicitacao_sisbov + ' + PeriodoExpiracao + ' ) >= :dta_expiracao_inicio and (tcs.dta_solicitacao_sisbov + ' + PeriodoExpiracao + ') < :dta_expiracao_fim) and tcs.cod_situacao_codigo_sisbov in (1,2))', SE((DtaExpiracaoInicio > 0) and (DtaExpiracaoFim > 0), ccAdicionar, ccDesprezar));
      SQL('  and tcs.cod_situacao_codigo_sisbov in ( ' + CodSituacoesCodigoSISBOV + ' ) ', SE(CodSituacoesCodigoSISBOV <> '', ccAdicionar, ccDesprezar));
      SQL('  and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov', SE(CodLocalizacaoSisbov > 0, ccAdicionar, ccDesprezar));      

      { Aplica restrições quanto ao tipo de acesso do usuário }
      if (Conexao.CodPapelUsuario = 1) and (Conexao.CodTipoAcesso = 'C') then // Associacao
      begin
        SQL('   and tcs.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_associacao_produtor where cod_pessoa_associacao = :cod_pessoa ) ', ccAdicionar);
      end
      else if (Conexao.CodPapelUsuario = 3) and (Conexao.CodTipoAcesso = 'C') then // Tecnico
      begin
        SQL('   and tcs.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_tecnico_produtor where cod_pessoa_tecnico = :cod_pessoa and dta_fim_validade is null) ', ccAdicionar);
      end
      else if (Conexao.CodPapelUsuario = 4) and (Conexao.CodTipoAcesso ='P') then // Produtor
      begin
        SQL('   and tcs.cod_pessoa_produtor = :cod_pessoa ', ccAdicionar);
      end
      else if (Conexao.CodPapelUsuario = 9) and (Conexao.CodTipoAcesso = 'C') then // Gestor
      begin
        SQL('   and tcs.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ', 0);
        SQL('                                   where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ', 0);
      end
      else if Conexao.CodTipoAcesso = 'N' then // Não tem acesso
      begin
        SQL('   and tcs.cod_pessoa_produtor = :cod_pessoa ', ccAdicionar);
      end;

      SQL('group by ', SE(bGroupBy, ccAdicionar, ccDesprezar));
      SQLgb('te.sgl_estado', [ccSglEstado]);
      SQLgb('te.nom_estado', [ccNomEstado]);
      SQLgb('tcs.cod_pais_sisbov', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQLgb('tcs.cod_estado_sisbov', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQLgb('tcs.cod_micro_regiao_sisbov', [ccCodSISBOVFormatadoMinimo, ccCodSISBOVFormatadoMaximo]);
      SQLgb('tr.sgl_produtor', [ccSglProdutor]);
      SQLgb('tp.nom_pessoa', [ccNomPessoaProdutor]);
      SQLgb('tp.nom_reduzido_pessoa', [ccNomReduzidoPessoaProdutor]);
      SQLgb('tp.cod_natureza_pessoa', [ccNumCNPJCPFFormatadoProdutor]);
      SQLgb('tp.num_cnpj_cpf', [ccNumCNPJCPFFormatadoProdutor]);
      SQLgb('tpr.num_imovel_receita_federal', [ccNumImovelReceitaFederal]);
      SQLgb('tpr.nom_propriedade_rural', [ccNomPropriedadeRural]);
      SQLgb('tm.nom_municipio', [ccNomMunicipioPropriedadeRural]);
      SQLgb('tcs.num_solicitacao_sisbov', [ccNumSolicitacaoSISBOV]);
      SQLgb('cast(round(cast(tcs.dta_solicitacao_sisbov as float), 0, 1) as smalldatetime)', [ccDtaSolicitacaoSISBOV]);
      SQLgb('cast(round(cast(tcs.dta_insercao_registro as float), 0, 1) as smalldatetime)', [ccDtaInsercao]);
      SQLgb('cast(round(cast(tcs.dta_utilizacao_codigo as float), 0, 1) as smalldatetime)', [ccDtaUtilizacao]);
      SQLgb('cast(round(cast(tcs.dta_liberacao_abate as float), 0, 1) as smalldatetime)', [ccDtaLiberacaoAbate]);
      SQLgb('case when tcs.cod_situacao_codigo_sisbov in (1, 2) then tcs.dta_solicitacao_sisbov + ' + ValorParametro(91) + ' else null end', [ccDtaExpiracaoCodigo]);
      SQLgb('tcs.ind_data_liberacao_estimada', [ccIndDataLiberacaoEstimada]);
      SQLgb('tos.num_ordem_servico', [ccNumOrdemServico]);
      SQLgb('tscs.sgl_situacao_codigo_sisbov', [ccSglSituacaoCodigoSISBOV]);
      SQLgb('tscs.des_situacao_codigo_sisbov', [ccDesSituacaoCodigoSISBOV]);
      SQLgb('tf.nom_fazenda', [ccNomFazenda]);
      SQLgb('tcs.dta_envio_certificado ', ccDtaEnvioCertificado);
      SQLgb('teec.nom_servico_envio ', ccNomServicoEnvio);
      SQLgb('teec.num_conhecimento ', ccNumConhecimento);
      SQLgb('tls.cod_localizacao_sisbov ', ccCodLocalizacaoSisbov);      
      if bGroupBy then
      begin
        SQL('order by ', ccAdicionar);
        IntRelatorios.IrAoPrimeiro;
        while not IntRelatorios.EOF do
        begin
          CodCampo := IntRelatorios.ValorCampo('CodCampo');
          if not (CodCampo in [ccQtdDisponiveis, ccQtdUtilizados, ccQtdTotal]) then
          begin
            sAux := SE(bOrderByFirst, '  ', '  , ')+IntRelatorios.ValorCampo('NomField');
            if SQL(sAux, SE(not bPersonalizavel
              or (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S')
              or (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S'),
              ccAdicionar, ccDesprezar)) and bOrderByFirst then
            begin
              bOrderByFirst := False;
            end;
          end;
          IntRelatorios.IrAoProximo;
        end;
      end;
      {$ENDIF}
      if SglProdutor <> '' then
      begin
        Query.ParamByName('sgl_produtor').AsString := SglProdutor;
      end;
      if NomPessoaProdutor <> '' then
      begin
        Query.ParamByName('nom_pessoa').AsString := '%' + NomPessoaProdutor + '%';
      end;
      if NumCNPJCPFProdutor <> '' then
      begin
        Query.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPFProdutor;
      end;
      if NumImovelReceitaFederal <> '' then
      begin
        Query.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
      end;
      if NomPropriedadeRural <> '' then
      begin
        Query.ParamByName('nom_propriedade_rural').AsString := '%' + NomPropriedadeRural + '%';
      end;
      if NomMunicipioPropriedadeRural <> '' then
      begin
        Query.ParamByName('nom_municipio').AsString := '%' + NomMunicipioPropriedadeRural + '%';
      end;
      if (DtaSolicitacaoSISBOVInicio> 0) and (DtaSolicitacaoSISBOVFim > 0) then
      begin
        Query.ParamByName('dta_solicitacao_sisbov_inicio').AsDateTime := Trunc(DtaSolicitacaoSISBOVInicio);
        Query.ParamByName('dta_solicitacao_sisbov_fim').AsDateTime := Trunc(DtaSolicitacaoSISBOVFim)+1;
      end;
      if (DtaInsercaoInicio > 0) and (DtaInsercaoFim > 0) then
      begin
        Query.ParamByName('dta_insercao_registro_inicio').AsDateTime := Trunc(DtaInsercaoInicio);
        Query.ParamByName('dta_insercao_registro_fim').AsDateTime := Trunc(DtaInsercaoFim)+1;
      end;
      if (DtaUtilizacaoInicio > 0) and (DtaUtilizacaoFim > 0) then
      begin
        Query.ParamByName('dta_utilizacao_codigo_inicio').AsDateTime := Trunc(DtaUtilizacaoInicio);
        Query.ParamByName('dta_utilizacao_codigo_fim').AsDateTime := Trunc(DtaUtilizacaoFim)+1;
      end;
      if (DtaLiberacaoAbateInicio > 0) and (DtaLiberacaoAbateFim > 0) then
      begin
        Query.ParamByName('dta_liberacao_abate_inicio').AsDateTime := Trunc(DtaLiberacaoAbateInicio);
        Query.ParamByName('dta_liberacao_abate_fim').AsDateTime := Trunc(DtaLiberacaoAbateFim)+1;
      end;
      if (DtaExpiracaoInicio > 0) and (DtaExpiracaoFim > 0) then
      begin
        Query.ParamByName('dta_expiracao_inicio').AsDateTime := Trunc(DtaExpiracaoInicio);
        Query.ParamByName('dta_expiracao_fim').AsDateTime    := Trunc(DtaExpiracaoFim) + 1;
      end;

      if ((Conexao.CodPapelUsuario = 1) and (Conexao.CodTipoAcesso = 'C')) // Associacao
      or ((Conexao.CodPapelUsuario = 3) and (Conexao.CodTipoAcesso = 'C')) // Tecnico
      or ((Conexao.CodPapelUsuario = 4) and (Conexao.CodTipoAcesso = 'P')) //Produtor
      or ((Conexao.CodPapelUsuario = 9) and (Conexao.CodTipoAcesso = 'C')) //Produtor
      then begin
        Query.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
      end
      else if (Conexao.CodTipoAcesso = 'N') then
      begin
        Query.ParamByName('cod_pessoa').AsInteger := -1;
      end;

      if CodLocalizacaoSisbov > 0 then
      begin
        Query.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      end;


      IntRelatorios.IrAoPrimeiro;
      while not IntRelatorios.EOF do
      begin
        CodCampo := IntRelatorios.ValorCampo('CodCampo');
        if CodCampo in [ccQtdDisponiveis, ccQtdUtilizados, ccQtdTotal] then
        begin
          if not bPersonalizavel or
            (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S') or
            (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S') then
          begin
              iAux := Length(Totalizadores);
              SetLength(Totalizadores, iAux + 1);
              Totalizadores[iAux].Campo := IntRelatorios.ValorCampo('NomField');
              Totalizadores[iAux].SubTotal := 0;
              Totalizadores[iAux].Total := 0;
          end;
        end;
        IntRelatorios.IrAoProximo;
      end;

      Query.Open;
      Result := 0;
    except
      on E: exception do
      begin
        Rollback;
        iAux := Length(strExceedsTheConfiguredThreshold);
        if (CodTarefa = -1) and (Copy(E.Message, 1, iAux) = strExceedsTheConfiguredThreshold) then
        begin
          Result := idExceedsTheConfiguredThreshold;
        end
        else
        begin
          Mensagens.Adicionar(1308, Self.ClassName, NomMetodo, [E.Message]);
          Result := -1308;
        end;
        Exit;
      end;
    end;
  finally
    IntRelatorios.Free;
  end;
end;

function TIntCodigosSisbov.GerarRelatorioConsolidado(CodEstado,
                                                     SglProdutor,
                                                     NomPessoaProdutor,
                                                     NumCNPJCPFProdutor,
                                                     NumImovelReceitaFederal: String;
                                                     CodLocalizacaoSisbov: Integer;
                                                     NomPropriedadeRural,
                                                     NomMunicipioPropriedadeRural: String;
                                                     DtaSolicitacaoSISBOVInicio,
                                                     DtaSolicitacaoSISBOVFim,
                                                     DtaInsercaoInicio,
                                                     DtaInsercaoFim,
                                                     DtaUtilizacaoInicio,
                                                     DtaUtilizacaoFim,
                                                     DtaLiberacaoAbateInicio,
                                                     DtaLiberacaoAbateFim,
                                                     DtaExpiracaoInicio,
                                                     DtaExpiracaoFim: TDateTime;
                                                     CodSituacoesCodigoSISBOV: String;
                                                     QtdQuebraRelatorio,
                                                     Tipo,
                                                     CodTarefa: Integer): String;
const
  Metodo: Integer = 407;
  NomeMetodo: String = 'GerarRelatorioConsolidadoSisBov';
  CodRelatorio: Integer = 12;
  CodTipoTarefa: Integer = 5;
var
  Query: THerdomQuery;
  Rel: TRelatorioPadrao;
  Retorno, iAux, iRecordCount: Integer;
  bIncluirObservacao, bAvancou, bTituloQuebra: Boolean;
  aTotalizadores, aValorCorrente: TTotalizadoresArray;
  vAux: Array [1..2] of Variant;
  sAux, sQuebra: String;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  Query := THerdomQuery.Create(Conexao, nil);
  try
    {Realiza pesquisa de animais de acordo com os critérios informados}
    Retorno := PesquisarRelatorioConsolidado(Query,
                                             CodEstado,
                                             SglProdutor,
                                             NomPessoaProdutor,
                                             NumCNPJCPFProdutor,
                                             NumImovelReceitaFederal,
                                             CodLocalizacaoSisbov,
                                             NomPropriedadeRural,
                                             NomMunicipioPropriedadeRural,
                                             DtaSolicitacaoSISBOVInicio,
                                             DtaSolicitacaoSISBOVFim,
                                             DtaInsercaoInicio,
                                             DtaInsercaoFim,
                                             DtaUtilizacaoInicio,
                                             DtaUtilizacaoFim,
                                             DtaLiberacaoAbateInicio,
                                             DtaLiberacaoAbateFim,
                                             DtaExpiracaoInicio,
                                             DtaExpiracaoFim,
                                             CodSituacoesCodigoSISBOV,
                                             aTotalizadores,
                                             CodTarefa);
    if Retorno < 0 then begin
      if Retorno = idExceedsTheConfiguredThreshold then begin
        // Verifica se o arquivo se se encontra na lista de tarefas para processamento
        Retorno := VerificarAgendamentoTarefa(CodTipoTarefa, [CodRelatorio,
                                              CodEstado, SglProdutor, NomPessoaProdutor,
                                              NumCNPJCPFProdutor, NumImovelReceitaFederal,
                                              CodLocalizacaoSisbov, NomPropriedadeRural,
                                              NomMunicipioPropriedadeRural,
                                              DtaSolicitacaoSISBOVInicio,
                                              DtaSolicitacaoSISBOVFim, DtaInsercaoInicio,
                                              DtaInsercaoFim, DtaUtilizacaoInicio,
                                              DtaUtilizacaoFim, DtaLiberacaoAbateInicio,
                                              DtaLiberacaoAbateFim, DtaExpiracaoInicio,
                                              DtaExpiracaoFim, CodSituacoesCodigoSISBOV,
                                              QtdQuebraRelatorio, Tipo]);
        if Retorno <= 0 then begin
          if Retorno = 0 then begin
            Mensagens.Adicionar(1994, Self.ClassName, NomeMetodo, []);
          end;
          Exit;
        end;

        // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
        Retorno := SolicitarAgendamentoTarefa(CodTipoTarefa, [CodRelatorio,
          CodEstado, SglProdutor, NomPessoaProdutor, NumCNPJCPFProdutor,
          NumImovelReceitaFederal, CodLocalizacaoSisbov, NomPropriedadeRural,
          NomMunicipioPropriedadeRural, DtaSolicitacaoSISBOVInicio,
          DtaSolicitacaoSISBOVFim, DtaInsercaoInicio, DtaInsercaoFim,
          DtaUtilizacaoInicio, DtaUtilizacaoFim, DtaLiberacaoAbateInicio,
          DtaLiberacaoAbateFim, DtaExpiracaoInicio, DtaExpiracaoFim,
          CodSituacoesCodigoSISBOV, QtdQuebraRelatorio, Tipo], DtaSistema);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Retorno >= 0 then begin
          Mensagens.Adicionar(1995, Self.Classname, NomeMetodo, []);
        end;
      end;
      Exit;
    end;

    {Verifica se a pesquisa é válida (se existe algum registro)}
    if Query.IsEmpty then begin
      Mensagens.Adicionar(1103, Self.ClassName, NomeMetodo, []);
      Exit;
    end;

    Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
    try
      try
        Rel.TipoDoArquvio := Tipo;

        {Verifica se execução do procedimento está ocorrendo sobre uma tarefa}
        if CodTarefa > 0 then begin
          Rel.CodTarefa := CodTarefa;
        end;

        {Define o relatório em questão e carrega os seus dados específicos}
        Retorno := Rel.CarregarRelatorio(CodRelatorio);
        if Retorno < 0 then Exit;

        {Consiste se o número de quebras é válido}
        if Rel.Campos.NumCampos < QtdQuebraRelatorio then begin
          Mensagens.Adicionar(1384, Self.ClassName, NomeMetodo, []);
          Exit;
        end;

        {Desabilita a apresentação dos campos selecionados para quebra}
        Rel.Campos.IrAoPrimeiro;
        for iAux := 1 to QtdQuebraRelatorio do begin
          Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
          Rel.Campos.IrAoProximo;
        end;

        {Inicializa o procedimento de geração do arquivo de relatório}
        Retorno := Rel.InicializarRelatorio;
        if Retorno < 0 then Exit;

        sQuebra := '';
        iRecordCount := 0;
        bTituloQuebra := False;
        SetLength(aValorCorrente, Length(aTotalizadores));
        for iAux := 0 to Length(aValorCorrente)-1 do begin
          aValorCorrente[iAux].Campo := aTotalizadores[iAux].Campo;
          aValorCorrente[iAux].SubTotal := 0;
          aValorCorrente[iAux].Total := 0;
        end;
        while not Query.Eof do begin
          bAvancou := False;
          PrepararLinha(Rel, Query, bIncluirObservacao);
          Rel.Campos.SalvarValores;
          {Realiza tratamento de quebras somente para formato PDF}
          if Tipo = ctaPDF then begin
            for iAux := 0 to Length(aValorCorrente)-1 do begin
              aValorCorrente[iAux].SubTotal := Query.FieldByName(aValorCorrente[iAux].Campo).AsInteger;
              aValorCorrente[iAux].Total := Query.FieldByName(aValorCorrente[iAux].Campo).AsInteger
            end;
            if Rel.LinhasRestantes <= 2 then begin
              {Verifica se o próximo registro existe, para que o último registro
              do relatório possa ser exibido na próxima folha, e assim o total não
              seja mostrado sozinho nesta folha}
              Query.Next;
              bAvancou := True;
              if Query.Eof then begin
                Rel.NovaPagina;
              end;
            end;
            if QtdQuebraRelatorio > 0 then begin
              {Percorre o(s) campo(s) informado(s) para quebra}
              sAux := '';
              for iAux := 1 to QtdQuebraRelatorio do begin
                {Concatena o valor dos campos de quebra, montando o título}
                vAux[iAux] := Rel.Campos.ValorCampoIdx[iAux-1];
                sAux := SE(sAux = '', sAux, sAux + ' / ') +
                  TrataQuebra(Rel.Campos.TextoTituloIdx[iAux-1]) + ': ' +
                  Rel.Campos.ValorCampoIdx[iAux-1];
              end;
              if (sAux <> sQuebra) then begin
                {Se ocorreu mudança na quebra atual ou é a primeira ('')}
                {Apresenta subtotal para quebra concluída, caso não seja a primeira}
                if (sQuebra <> '') and (Length(aTotalizadores) > 0) then begin
                  {Confirma se o subtotal deve ser apresentado}
                  if Rel.Campos.NumCampos > (QtdQuebraRelatorio+1) then begin
                    Rel.NovaLinha;
                    Rel.Campos.LimparValores;
                    for iAux := 0 to Length(aTotalizadores)-1 do begin
                      {Identifica valor a ser apresentado}
                      Rel.Campos.ValorCampo[aTotalizadores[iAux].Campo] :=
                        aTotalizadores[iAux].SubTotal;
                      {Zera acumulador da quebra}
                      aTotalizadores[iAux].SubTotal := 0;
                    end;
                    Rel.ImprimirTextoTotalizador('Sub-total');
                  end;
                end;
                sQuebra := sAux;
                if Rel.LinhasRestantes <= 4 then begin
                  {Verifica se a quebra possui somente um registro e se o espaço é su-
                  ficiênte para a impressão de título, registro e subtotal, caso
                  contrário quebra a página antes da impressão}
                  if not bAvancou then begin
                    Query.Next;
                    bAvancou := True;
                  end;
                  if Query.Eof then begin
                    Rel.NovaPagina;
                  end else begin
                    Rel.Campos.CarregarValores(Query);
                    for iAux := 1 to QtdQuebraRelatorio do begin
                      if (rel.LinhasRestantes <= 2) or (vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1]) then begin
                        Rel.NovaPagina;
                        Break;
                      end;
                    end;
                  end;
                  {Verifica se uma nova página foi gerada, caso não salta uma linha}
                  if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
                    Rel.NovaLinha;
                  end;
                end else if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
                  {Salta uma linha antes da quebra, caso não seja a primeira da pág.}
                  Rel.NovaLinha;
                end;
                {Imprime título da quebra}
                Rel.FonteNegrito;
                Rel.ImprimirTexto(0, sQuebra);
                Rel.FonteNormal;
              end else if bTituloQuebra then begin
                {Repete o título da quebra no topo da nova pág. qdo ocorrer quebra de pág.}
                Rel.NovaPagina;
                Rel.FonteNegrito;
                Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                Rel.FonteNormal;
              end;
            end;
            {Verifica se o registro a ser apresentado é o último da quebra, caso
            seja faz com que ele possa ser exibido na próxima folha, e assim o
            subtotal e/ou o total não sejam mostrados sozinhos nesta folha}
            if (Rel.LinhasRestantes <= 2) and (QtdQuebraRelatorio > 0) then begin
              if not bAvancou then begin
                Query.Next;
                bAvancou := True;
              end;
              if not Query.Eof then begin
                {Caso uma nova pág. seja necessária, apresenta o texto da
                quebra novamente no início da nova página concatenado com o
                texto "(continuação)"}
                Rel.Campos.CarregarValores(Query);
                for iAux := 1 to QtdQuebraRelatorio do begin
                  if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then begin
                    Rel.NovaPagina;
                    Rel.FonteNegrito;
                    Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                    Rel.FonteNormal;
                    Break;
                  end;
                end;
              end;
            end;
            for iAux := 0 to Length(aTotalizadores)-1 do begin
              aTotalizadores[iAux].SubTotal := aTotalizadores[iAux].SubTotal + aValorCorrente[iAux].SubTotal;
              aTotalizadores[iAux].Total := aTotalizadores[iAux].Total + aValorCorrente[iAux].Total;
            end;
          end;
          inc(iRecordCount);
          Rel.Campos.RecuperarValores;
          Rel.ImprimirColunas;
          bTituloQuebra := (Rel.LinhaCorrente = Rel.LinhasPorPagina);
          if not bAvancou then begin
            Query.Next;
          end;
        end;
        {Realiza tratamento de quebras somente para formato PDF}
        if Tipo = ctaPDF then begin
          if Length(aTotalizadores) > 0 then begin
            {Monta Linhas totalizadoras, caso necessário}
            if iRecordCount > 1 then begin
              {Confirma se o subtotal deve ser apresentado}
              if Rel.Campos.NumCampos > (QtdQuebraRelatorio+1) then begin
                Rel.NovaLinha;
                Rel.Campos.LimparValores;
                for iAux := 0 to Length(aTotalizadores)-1 do begin
                  {Identifica valor a ser apresentado}
                  Rel.Campos.ValorCampo[aTotalizadores[iAux].Campo] :=
                    aTotalizadores[iAux].SubTotal;
                end;
                Rel.ImprimirTextoTotalizador('Sub-total');
              end;
              Rel.NovaLinha;
              Rel.Campos.LimparValores;
              for iAux := 0 to Length(aTotalizadores)-1 do begin
                {Identifica valor a ser apresentado}
                Rel.Campos.ValorCampo[aTotalizadores[iAux].Campo] :=
                  aTotalizadores[iAux].Total;
              end;
              Rel.ImprimirTextoTotalizador('Total');
            end;
          end;
          if bIncluirObservacao then begin
            if Rel.LinhasRestantes < 3 then begin
              Rel.NovaPagina;
            end else begin
              Rel.NovaLinha;
            end;
            Rel.AjustarFonte(poCourierBold, 10);
            Rel.ImprimirTexto(0, 'OBSERVAÇÃO');
            Rel.AjustarFonte(poCourier, 8);
            Rel.ImprimirTexto(0, 'Os códigos SISBOV marcados com o caracter "*" ' +
              'identificam que algum código correspondente a faixa não está ' +
              'presente.');
          end;
        end;
        Retorno := Rel.FinalizarRelatorio;
        {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
        if Retorno = 0 then begin
          Result := Rel.NomeArquivo;
        end;
      except
        on E: exception do begin
          Rollback;
          Mensagens.Adicionar(1308, Self.ClassName, NomeMetodo, [E.Message]);
          Result := '';
          Exit;
        end;
      end;
    finally
      Rel.Free;
    end;
  finally
    Query.Free;
  end;
end;

//****
// Novo metodo para geração do relatório com a relação de códigos sisbov
// gerados pela consulta de códigos.
function TIntCodigosSisbov.GerarRelatorioCodigosSisBov(CodEstado,
                                                       CodMicroRegiao: Integer;
                                                       CodOrdenacao: String;
                                                       SeqInicial,
                                                       SeqFinal: Integer;
                                                       Tipo: Integer;
                                                       SiglaProdutor,
                                                       NomProdutor,
                                                       NomPropriedade: String;
                                                       DtaInicioCadastramentoCodigos,
                                                       DtaFimCadastramentoCodigos,
                                                       DtaInicioUtilizacaoCodigos,
                                                       DtaFimUtilizacaoCodigos: TDateTime;
                                                       CodPais,
                                                       QtdQuebraRelatorio,
                                                       NumSolicitacaoSISBOV: Integer): String;
const
  Metodo: Integer = 485;
  NomeMetodo: String = 'GerarRelatorioCodigosSisBov';
  CodRelatorio: Integer = 23;
var
  Rel: TRelatorioPadrao;
  Retorno, Max: Integer;
  Cod1, Cod2, Cod3, Cod4, Cod5: string;
  InsereReg: Boolean;
  Q : THerdomQueryNavegacao;
  IntRelatorios: TIntRelatorios;
  NumCampos, iAux: Integer;
  sAux, sQuebra: String;
  vAux: Array [1..2] of Variant;
begin
  Result := '';

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  // Obtem parâmetro com o máximo número de códigos sisbov para pesquisa
  Try
    Max := StrToInt(ValorParametro(25));
  except
    Exit;
  end;

  IntRelatorios := TIntRelatorios.Create;

  try
    Retorno := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Retorno < 0 then Exit;
    Retorno := IntRelatorios.Buscar(CodRelatorio);
    if Retorno < 0 then Exit;
    Retorno := IntRelatorios.Pesquisar(CodRelatorio);
    if Retorno < 0 then Exit;

    try
      Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
      // Define o relatório em questão e carrega os seus dados específicos
      Retorno := Rel.CarregarRelatorio(CodRelatorio);
      if Retorno < 0 then Exit;

      NumCampos := 1;

      // Setando a quantidade de campos selecionados pelo usuario para a montagem do relatorio
      if (IntRelatorios.CampoAssociado(6) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(7) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(8) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(9) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(10) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(11) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(12) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(13) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(14) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(15) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(16) = 1) then Inc(NumCampos);
      if (IntRelatorios.CampoAssociado(17) = 1) then Inc(NumCampos);

      Query.SQL.Clear;
{$IFDEF MSSQL}
      Query.SQL.Add('select top ' + IntToStr(Max));
      if Tipo = 2 then begin
        Query.SQL.Add('   char(39) + ');
      end;
      Query.SQL.Add('   convert(char(3), tcs.cod_pais_sisbov) + ');
      Query.SQL.Add('   right(''00'' + convert(varchar(2), tcs.cod_estado_sisbov), 2) + ');
      Query.SQL.Add('   CASE tcs.cod_micro_regiao_sisbov WHEN 0 THEN  ');
      Query.SQL.Add('   ''00''  ');
      Query.SQL.Add('   WHEN -1 THEN  ');
      Query.SQL.Add('   ''''  ');
      Query.SQL.Add('   ELSE  ');
      Query.SQL.Add('   right(''00'' + convert(varchar(2), tcs.cod_micro_regiao_sisbov), 2) ');
      Query.SQL.Add('   END + ');
      Query.SQL.Add('   right(''000000000'' + convert(varchar(9), tcs.cod_animal_sisbov), 9) + ');
      Query.SQL.Add('   convert(varchar(1), tcs.num_dv_sisbov) as CodAnimalSisbov ');

      if Trim(SiglaProdutor) = '' then
        Query.SQL.Add('   , case isnull(tcs.cod_pessoa_produtor,0)   when 0 then '''' else tt.sgl_produtor  end as SglProdutor ')
      else Query.SQL.Add(', tt.sgl_produtor as SglProdutor');
      Query.SQL.Add('     , tp.nom_pessoa as NomeProdutor');
      Query.SQL.Add('     , tpr.nom_propriedade_rural as NomePropriedade');
      Query.SQL.Add('     , tcs.dta_insercao_registro as DtaCadastramentoCodigo');
      Query.SQL.Add('     , tcs.dta_utilizacao_codigo as DtaUtilizacaoCodigo');

      Query.SQL.Add('     , tcs.num_solicitacao_sisbov as NumSolicitacaoSISBOV');
      Query.SQL.Add('     , tcs.dta_liberacao_abate as DtaLiberacaoAbate');
      Query.SQL.Add('     , tcs.dta_solicitacao_sisbov as DtaSolicitacaoSISBOV');
      Query.SQL.Add('     , tcs.dta_envio_certificado as DtaEnvioCertificado');
      Query.SQL.Add('     , tcs.dta_autenticacao as DtaAutenticacao');
      Query.SQL.Add('     , tscs.sgl_situacao_codigo_sisbov as SglSituacaoCodigoSISBOV');
      Query.SQL.Add('     , tscs.des_situacao_codigo_sisbov as DesSituacaoCodigoSISBOV');

      Query.SQL.Add('  from tab_codigo_sisbov tcs ');
      Query.SQL.Add('     , tab_pessoa tp ');
      Query.SQL.Add('     , tab_propriedade_rural tpr ');
      Query.SQL.Add('     , tab_produtor tt ');
      Query.SQL.Add('     , tab_situacao_codigo_sisbov tscs');

      Query.SQL.Add(' where ((tcs.cod_pais_sisbov = :cod_pais_sisbov) or (:cod_pais_sisbov = -1)) ');
      Query.SQL.Add('   and ((tcs.cod_estado_sisbov = :cod_estado_sisbov) or (:cod_estado_sisbov = -1)) ');
      Query.SQL.Add('   and tcs.cod_situacao_codigo_sisbov = tscs.cod_situacao_codigo_sisbov');      
      if CodMicroRegiao <> -1 then
         Query.SQL.Add('   and ((tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov) or (:cod_micro_regiao_sisbov = -2)) ');

      if Trim(SiglaProdutor) <> '' then begin
        Query.SQL.Add(' and tt.sgl_produtor = :Sgl_Produtor ');
        Query.SQL.Add(' and tt.cod_pessoa_produtor = tp.cod_pessoa ');
      end;

      if Trim(NomProdutor) <> '' then begin
        Query.SQL.Add(' and tp.nom_pessoa like :Nom_Pessoa ');
        Query.SQL.Add(' and tp.cod_pessoa = tcs.cod_pessoa_produtor ');
      end;

      if Trim(NomPropriedade) <> '' then begin
        Query.SQL.Add('  and tpr.nom_propriedade_rural like :Nom_Propriedade ');
        if not ((DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0)) then begin
          Query.SQL.Add('  and tt.cod_pessoa_produtor = tp.cod_pessoa ');
        end;
        Query.SQL.Add('  and tcs.cod_propriedade_rural = tpr.cod_propriedade_rural ');
      end
      else begin
        Query.SQL.Add(' and tcs.cod_propriedade_rural *= tpr.cod_propriedade_rural ');
      end;

      if (((DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0)) or ((DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0))) then begin
        if (DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0) then begin
          Query.SQL.Add(' and tcs.dta_insercao_registro between :dta_inicio_cadastramento and :dta_fim_cadastramento ');
        end;
        if (DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0) then begin
          Query.SQL.Add(' and tcs.dta_utilizacao_codigo between :dta_inicio_utilizacao and :dta_fim_utilizacao ');
        end;
        if (Trim(NomProdutor) = '') and (Trim(SiglaProdutor) = '') then begin
          Query.SQL.Add(' and tcs.cod_pessoa_produtor *= tp.cod_pessoa ');
        end;
        if Trim(SiglaProdutor) <> '' then begin
          Query.SQL.Add(' and tcs.cod_pessoa_produtor = tt.cod_pessoa_produtor ');
        end
        else begin
          Query.SQL.Add(' and tcs.cod_pessoa_produtor *= tt.cod_pessoa_produtor ');
        end;
      end
      else begin
        Query.SQL.Add(' and tcs.cod_pessoa_produtor = tt.cod_pessoa_produtor ');
      end;

      if (SeqInicial > 0) and (SeqFinal > 0) then begin
        Query.SQL.Add(' and tcs.cod_animal_sisbov  between :SeqInicial and :SeqFinal ');
      end;

      {Se o usuario entrar somente com a sequencia de codigos sisbov ou não entrar com
         nenhuma informação, eh preciso fazer o join com a tabela pessoa para o resultado
         nao repetir o codigo para cada pessoa}
      if ((Trim(SiglaProdutor) = '') and (Trim(NomProdutor) = '') and (Trim(NomPropriedade) = '') and (DtaInicioCadastramentoCodigos <= 0) and (DtaFimCadastramentoCodigos <= 0) and (DtaInicioUtilizacaoCodigos <= 0) and (DtaFimUtilizacaoCodigos <= 0)) then begin
        Query.SQL.Add(' and tp.cod_pessoa = tt.cod_pessoa_produtor ');
      end;

      if UpperCase(CodOrdenacao) = 'S' then begin
        Query.SQL.Add(' and tcs.dta_utilizacao_codigo is not null');
      end
      else if UpperCase(CodOrdenacao) = 'N' then begin
        Query.SQL.Add(' and tcs.dta_utilizacao_codigo is null');
      end
      else if UpperCase(CodOrdenacao) = 'R' then begin
        Query.SQL.Add(' and tcs.cod_pessoa_produtor is not null');
        Query.SQL.Add(' and tcs.dta_utilizacao_codigo is null');
      end;

      if NumSolicitacaoSISBOV > 0 then begin
        Query.SQL.Add(' and tcs.num_solicitacao_sisbov = :num_solicitacao_sisbov');
      end;

      if (Conexao.CodPapelUsuario = 3) then // Caso o usuário logado seja um técnico, filtrar por produtores relacionados a ele.
      begin
        Query.SQL.Add('   and tcs.cod_pessoa_produtor in (select cod_pessoa_produtor from tab_tecnico_produtor where cod_pessoa_tecnico = :cod_pessoa and dta_fim_validade is null) ');
      end
      else if (Conexao.CodPapelUsuario = 9) then // Caso o usuário logado seja um gestor, filtrar por produtores relacionados a ele.
      begin
        Query.SQL.Add('   and tcs.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ');
        Query.SQL.Add('                                   where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ');
      end;

      {Ordenando o resultado apresentado no relatório}
      if (QtdQuebraRelatorio = 0) then begin
         Query.SQL.Add(' order by CodAnimalSisbov ');
      end
      else begin
         if (NumCampos <> 1) then begin
            Rel.Campos.IrAoPrimeiro;
            if (QtdQuebraRelatorio >= 1) then begin
               Query.SQL.Add(' order by ' + Rel.Campos.Campo.NomField + ', ');
               Rel.Campos.IrAoProximo;
            end;
            if (QtdQuebraRelatorio = 2) then
               Query.SQL.Add('          ' + Rel.Campos.Campo.NomField + ', ');
            Query.SQL.Add('          CodAnimalSisbov ');
         end;
      end;

{$ENDIF}
      if Trim(NomProdutor) <> '' then begin
        Query.ParamByName('Nom_Pessoa').AsString := '%'+NomProdutor+'%';
      end;
      if Trim(NomPropriedade) <> '' then begin
       Query.ParamByName('Nom_Propriedade').AsString := '%'+NomPropriedade+'%';
      end;
      if Trim(SiglaProdutor) <> '' then begin
       Query.ParamByName('Sgl_Produtor').AsString := SiglaProdutor;
      end;
      if (DtaInicioCadastramentoCodigos > 0) and (DtaFimCadastramentoCodigos > 0) then begin
        Query.ParamByName('dta_inicio_cadastramento').AsDateTime := DtaInicioCadastramentoCodigos;
        Query.ParamByName('dta_fim_cadastramento').AsDateTime := DtaFimCadastramentoCodigos + 1;
      end;
      if (DtaInicioUtilizacaoCodigos > 0) and (DtaFimUtilizacaoCodigos > 0) then begin
        Query.ParamByName('dta_inicio_utilizacao').AsDateTime := DtaInicioUtilizacaoCodigos;
        Query.ParamByName('dta_fim_utilizacao').AsDateTime := DtaFimUtilizacaoCodigos + 1;
      end;

      Query.ParamByName('cod_pais_sisbov').AsInteger := CodPais;
      Query.ParamByName('cod_estado_sisbov').AsInteger := CodEstado;

      if CodMicroRegiao <> -1 then begin
          if CodMicroRegiao <> 88 then
             Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao
          else
             Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := -1;
      end;

      if (SeqInicial > 0) and (SeqFinal > 0) then begin
        Query.ParamByName('SeqInicial').AsInteger := SeqInicial;
        Query.ParamByName('SeqFinal').AsInteger := SeqFinal;
      end;

      if (NumSolicitacaoSISBOV > 0) then begin
        Query.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      end;

      if (Conexao.CodPapelUsuario = 3) or // Técnico
         (Conexao.CodPapelUsuario = 9) then // Gestor
      begin
        Query.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
      end;      

      Query.Open;

      // Se o usuario optou pela impressao pdf (tipo=1) somente do código do sisbov,
      //   eles serao apresentados em 5 colunas no relatorio.
      Q := THerdomQueryNavegacao.Create(nil);
      if ((Tipo = 1) and (NumCampos = 1)) then begin
        Q.SQLConnection := Conexao.SQLConnection;
{$IFDEF MSSQL}
        Q.SQL.Add('if object_id(''tempdb..#tmp_relatorio_codigo_sisbov'') is null '+
        #13#10'  create table #tmp_relatorio_codigo_sisbov '+
        #13#10'  ( '+
        #13#10'      CodAnimalSisbov  varchar(17) '+
        #13#10'    , CodAnimalSisbov1 varchar(17) '+
        #13#10'    , CodAnimalSisbov2 varchar(17) '+
        #13#10'    , CodAnimalSisbov3 varchar(17) '+
        #13#10'    , CodAnimalSisbov4 varchar(17) '+
        #13#10'  ) ');
{$ENDIF}
        Q.ExecSQL;

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('truncate table #tmp_relatorio_codigo_sisbov');
{$ENDIF}
        Q.ExecSQL;

        Q.SQL.Clear;
        Q.SQL.Add('insert into #tmp_relatorio_codigo_sisbov ');
        Q.SQL.Add('   values ( :Cod1 ');
        Q.SQL.Add('          , :Cod2 ');
        Q.SQL.Add('          , :Cod3 ');
        Q.SQL.Add('          , :Cod4 ');
        Q.SQL.Add('          , :Cod5 ');
        Q.SQL.Add('   ) ');

        Query.First;
        while (not Query.EOF) do begin
          InsereReg := true;

          Cod1 := Query.FieldByName('CodAnimalSisbov').AsString;
          Query.Next;

          if (not Query.EOF) then begin
           Cod2 := Query.FieldByName('CodAnimalSisbov').AsString;
           Query.Next;

           if (not Query.EOF) then begin
             Cod3 := Query.FieldByName('CodAnimalSisbov').AsString;
             Query.Next;

             if (not Query.EOF) then begin
               Cod4 := Query.FieldByName('CodAnimalSisbov').AsString;
               Query.Next;

               if (not Query.EOF) then begin
                 Cod5 := Query.FieldByName('CodAnimalSisbov').AsString;
               end;
             end;
           end;
          end;

          if InsereReg then begin
            Q.ParamByName('Cod1').AsString := Cod1;
            Q.ParamByName('Cod2').AsString := Cod2;
            Q.ParamByName('Cod3').AsString := Cod3;
            Q.ParamByName('Cod4').AsString := Cod4;
            Q.ParamByName('Cod5').AsString := Cod5;

            Q.ExecSQL;
            Cod1 := ''; Cod2 := ''; Cod3 := ''; Cod4 := ''; Cod5 := '';
          end;

          Query.Next;
        end;

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select * ');
        Q.SQL.Add(' from #tmp_relatorio_codigo_sisbov ');
{$ENDIF}
        Q.Open;

      end; // if ((Tipo = 1) and (NumCampos = 1))

      try
        Rel.TipoDoArquvio := Tipo;

        {Consiste se o número de quebras é válido}
        if NumCampos < QtdQuebraRelatorio then begin
          Mensagens.Adicionar(1384, Self.ClassName, NomeMetodo, []);
          Exit;
        end;

        {Desabilita a apresentação dos campos selecionados para quebra}
        Rel.Campos.IrAoPrimeiro;

        if (NumCampos = 1) then begin
          // Imprimindo relatorio pdf, somente de codigos sisbov...
          if (Tipo = 1) then begin
            if Q.IsEmpty then begin
              Mensagens.Adicionar(1307, Self.ClassName, NomeMetodo, []);
              Exit;
            end;

            Retorno := Rel.InicializarRelatorio;
            if Retorno < 0 then Exit;

            Q.First;
            while (not Q.EOF) do begin
              Rel.ImprimirColunasResultSet(Q);
              Q.Next;
            end;
            Q.SQL.Clear;
{$IFDEF MSSQL}
            Q.SQL.Add('Drop table #tmp_relatorio_codigo_sisbov');
{$ENDIF}
            Q.ExecSQL;
          end // if (Tipo = 1)
          // Imprimindo relatorio excel, somente de codigos sisbov...
          else begin
            if Query.IsEmpty then begin
              Mensagens.Adicionar(1307, Self.ClassName, NomeMetodo, []);
              Exit;
            end;

            Retorno := Rel.InicializarRelatorio;
            if Retorno < 0 then Exit;

            Query.First;
            while not Query.EOF do begin
              Rel.ImprimirColunasResultSet(Query);
              Query.Next;
            end;
          end; // if (Tipo = 2)
        end; // if (NumCampos = 1)

        if (NumCampos <> 1) then begin
          Rel.Campos.IrAoPrimeiro;
          for iAux := 1 to QtdQuebraRelatorio do begin
            Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
            Rel.Campos.IrAoProximo;
          end;

          {Inicializa o procedimento de geração do arquivo de relatório}
          Retorno := Rel.InicializarRelatorio;
          if Retorno < 0 then Exit;

          sQuebra := '';
          Q := Query;
          Q.First;

          while not Q.EOF do begin
            {Realiza tratamento de quebras somente para formato PDF}
            if Tipo = 1 then begin
              if Rel.LinhasRestantes <= 2 then begin
                {Verifica se o próximo registro existe, para que o último registro
                do relatório possa ser exibido na próxima folha, e assim o total não
                seja mostrado sozinho nesta folha}
                if Q.FindNext then begin
                  Q.Prior;
                end else begin
                  Rel.NovaPagina;
                end;
              end;
              if QtdQuebraRelatorio > 0 then begin
                {Atualiza o campo valor do atributo Campos do relatorio c/ os dados da query}
                Rel.Campos.CarregarValores(Q);
                {Percorre o(s) campo(s) informado(s) para quebra}
                sAux := '';
                for iAux := 1 to QtdQuebraRelatorio do begin
                  {Concatena o valor dos campos de quebra, montando o título}
                  vAux[iAux] := Rel.Campos.ValorCampoIdx[iAux-1];
                  sAux := SE(sAux = '', sAux, sAux + ' / ') +
                    TrataQuebra(Rel.Campos.TextoTituloIdx[iAux-1]) + ': ' +
                    Rel.Campos.ValorCampoIdx[iAux-1];
                end;
                if (sAux <> sQuebra) then begin
                  {Se ocorreu mudança na quebra atual ou é a primeira ('')}
                  {Apresenta subtotal para quebra concluída, caso não seja a primeira}
                  if sQuebra <> '' then begin
                    {Confirma se o subtotal deve ser apresentado}
                    if NumCampos > (QtdQuebraRelatorio+1) then begin
                      Rel.NovaLinha;
                      Rel.Campos.LimparValores;
                    end;
                  end;
                  sQuebra := sAux;
                  if Rel.LinhasRestantes <= 4 then begin
                    {Verifica se a quebra possui somente um registro e se o espaço é su-
                    ficiênte para a impressão de título, registro e subtotal, caso
                    contrário quebra a página antes da impressão}
                    if not Q.FindNext then begin
                      Rel.NovaPagina;
                    end else begin
                      Rel.Campos.CarregarValores(Q);
                      for iAux := 1 to QtdQuebraRelatorio do begin
                        if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then begin
                          Rel.NovaPagina;
                          Break;
                        end;
                      end;
                    end;
                    Q.Prior;
                  end else if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
                    {Salta uma linha antes da quebra, caso não seja a primeira da pág.}
                    Rel.NovaLinha;
                  end;
                  {Imprime título da quebra}
                  Rel.FonteNegrito;
                  Rel.ImprimirTexto(0, sQuebra);
                  Rel.FonteNormal;
                end else if (Rel.LinhasRestantes = Rel.LinhasPorPagina) then begin
                  {Repete o título da quebra no topo da nova pág. qdo ocorrer quebra de pág.}
                  Rel.FonteNegrito;
                  Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                  Rel.FonteNormal;
                end;
              end;
              {Verifica se o registro a ser apresentado é o último da quebra, caso
              seja faz com que ele possa ser exibido na próxima folha, e assim o
              subtotal e/ou o total não sejam mostrados sozinhos nesta folha}
              if (Rel.LinhasRestantes <= 2) and (QtdQuebraRelatorio > 0) then begin
                if Q.FindNext then begin
                  Rel.Campos.CarregarValores(Q);
                  for iAux := 1 to QtdQuebraRelatorio do begin
                    if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then begin
                      Rel.NovaPagina;
                      Break;
                    end;
                  end;
                  Q.Prior;
                  {Caso uma nova pág. tenha sido criada, força o reinício do procedi-
                  mento para que o nome do produtor possa ser impresso no início da nova
                  página concatenado com o texto "(continuação)"}
                  if Rel.LinhasRestantes = Rel.LinhasPorPagina then begin
                    Continue;
                  end;
                end;
              end;
            end;
            Rel.ImprimirColunasResultSet(Q);
            Q.Next;
          end;
          {Realiza tratamento de quebras somente para formato PDF}
          if Tipo = 1 then begin
            {Monta Linhas totalizadoras, caso necessário}
            if not Q.IsEmpty then begin
              {Confirma se o subtotal deve ser apresentado}
              if NumCampos > (QtdQuebraRelatorio+1) then begin
                Rel.NovaLinha;
                Rel.Campos.LimparValores;
              end;
              Rel.NovaLinha;
              Rel.Campos.LimparValores;
            end;
          end;

          Q.SQL.Clear;
        end; // if (NumCampos <> 1)

        Retorno := Rel.FinalizarRelatorio;
        {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
        if Retorno = 0 then begin
          Result := Rel.NomeArquivo;
        end;

      finally
        Rel.Free;
      end;

    except // try da Query
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1591, Self.ClassName, NomeMetodo, [E.Message]);
        Result := '';
        Exit;
      end;
    end;
    finally
       IntRelatorios.Free;
    end;
end;

//****

function TIntCodigosSisbov.ReservarCodigosProdutor(CodPessoaProdutor, CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalInicio,CodAnimalFim, CodPropriedadeRural : Integer): Integer;
var
  Q : THerdomQueryNavegacao;
  CodPaisSisBov, CodPais, CodEstado : Integer;
const
  CodMetodo : Integer = 477;
  NomMetodo : String = 'ReservarCodigosProdutor';
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

  if CodAnimalInicio > CodAnimalFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQueryNavegacao.Create(nil);
  Try
    Try
      Q.SQLConnection := Conexao.SQLConnection;
      CodPais := 1;
      CodPaisSisBov := 105;

      //------------------
      // Consiste produtor
      //------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(170, Self.ClassName, NomMetodo, []);
        Result := -170;
        Exit;
      end;

      //-----------------
      // Consiste estado
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      //-----------------------
      // Consiste micro-região
      //-----------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
        Result := -299;
        Exit;
      end;


      //-----------------------
      // Verifica se a propriedade pertence ao produtor
      //-----------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select fz.cod_propriedade_rural');
      Q.SQL.Add('  from tab_propriedade_rural pr, tab_fazenda  fz');
      Q.SQL.Add(' where fz.dta_fim_validade         is null');
      Q.SQL.Add('   and fz.cod_pessoa_produtor       = :cod_pessoa_produtor');
      Q.SQL.Add('   and pr.dta_fim_validade         is null');
      Q.SQL.Add('   and pr.cod_propriedade_rural     = :cod_propriedade_rural');
      Q.SQL.Add('   and (   fz.cod_propriedade_rural = pr.cod_propriedade_rural');
      Q.SQL.Add('        or fz.num_propriedade_rural = pr.num_imovel_receita_federal)');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1646, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
        Result := -1646;
        Exit;
      end;

      //------------------------------------------------------------------------
      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      //------------------------------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;


      if (CodMicroRegiaoSisBov <> 0) and (CodMicroRegiaoSisBov <> -1) then
      begin
        //-----------------------
        // Verifica se a micro-região selecionada é a mesma da propriedade
        //-----------------------
        Q.close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select cod_micro_regiao_sisbov');
        Q.SQL.Add('  from tab_propriedade_rural pr, tab_municipio mn, tab_micro_regiao mr');
        Q.SQL.Add(' where pr.cod_propriedade_rural = :cod_propriedade_rural');
        Q.SQL.Add('   and mn.cod_micro_regiao      = mr.cod_micro_regiao');
        Q.SQL.Add('   and pr.cod_municipio         = mn.cod_municipio');
{$ENDIF}
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;

        if Q.IsEmpty then begin
          Mensagens.Adicionar(1647, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
          Result := -1647;
          Exit;
        end;
      end;

      //--------------------------------------
      // Verifica existência do código sisbov
      //--------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
//      Q.SQL.Add('   and cod_pessoa_produtor is null ');
      Q.SQL.Add('   and cod_propriedade_rural is null ');
      Q.SQL.Add('   and dta_utilizacao_codigo is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalFim;
      Q.Open;
      if Q.RecordCount < ((CodAnimalFim - CodAnimalInicio)+1) then begin
        Mensagens.Adicionar(1577, Self.ClassName, NomMetodo, []);
        Result := -1577;
        Exit;
      end;
      //---------------
      // Abre transação
      //---------------
      beginTran;
      //---------------------------
      // Tenta Alterar os registros
      //---------------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
      Q.SQL.Add('update tab_codigo_sisbov ' +
                ' set ' +
                '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
                ', cod_propriedade_rural = :cod_propriedade_rural ' +
                ' where cod_pais_sisbov = :cod_pais_sisbov '+
                '   and cod_estado_sisbov = :cod_estado_sisbov '+
                '   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov '+
                '   and cod_animal_sisbov >= :cod_animal_inicio '+
                '   and cod_animal_sisbov <= :cod_animal_fim ');
  {$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalFim;

      Q.ExecSQL;

      InserirHistorico(CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
        CodAnimalInicio, CodAnimalFim, 'N');

      commit;

      ZerarValoresUltimaPesquisa;

      Mensagens.Adicionar(10206, Self.ClassName, NomMetodo, [Inttostr(CodAnimalFim - CodAnimalInicio + 1)]);

      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1578, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1578;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.CancelarReservaProdutor(CodPessoaProdutor, CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalInicio,CodAnimalFim,CodPropriedadeRural : Integer): Integer;
var
  Q : THerdomQueryNavegacao;
  CodPaisSisBov, CodPais, CodEstado : Integer;
  quant_utilizado, quant_reservado: Integer;
const
  CodMetodo : Integer = 478;
  NomMetodo : String = 'CancelarReservaProdutor';
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

  if CodAnimalInicio > CodAnimalFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQueryNavegacao.Create(nil);
  Try
    Try
      Q.SQLConnection := Conexao.SQLConnection;

      CodPais := 1;
      CodPaisSisBov := 105;

      //------------------
      // Consiste produtor
      //------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(170, Self.ClassName, NomMetodo, []);
        Result := -170;
        Exit;
      end;

      //------------------------------
      // Consiste propriedade rural
      //------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural   = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, NomMetodo, []);
        Result := -327;
        Exit;
      end;

      //-----------------
      // Consiste estado
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      //-----------------------
      // Consiste micro-região
      //-----------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
        Result := -299;
        Exit;
      end;

      //-----------------------------------------------------------------------------------
      // Verifica existência do código sisbov reservados para esse produtor e não utlizados
      //-----------------------------------------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
      Q.SQL.Add('   and cod_pessoa_produtor =:cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_utilizacao_codigo is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      quant_reservado := Q.RecordCount;

      //-------------------------------------------------------------------------------
      // Verifica existência do código sisbov reservados para esse produtor e utlizados
      //-------------------------------------------------------------------------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_animal_sisbov >= :cod_animal_inicio ');
      Q.SQL.Add('   and cod_animal_sisbov <= :cod_animal_fim ');
      Q.SQL.Add('   and cod_pessoa_produtor =:cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_utilizacao_codigo is not null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      quant_utilizado := Q.RecordCount;

      if quant_reservado + quant_utilizado = 0 then begin
        Mensagens.Adicionar(1579, Self.ClassName, NomMetodo, []);
        Result := -1579;
        Exit;
      end;
      //---------------
      // Abre transação
      //---------------
      beginTran;
      //---------------------------
      // Tenta Alterar os registros
      //---------------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
      Q.SQL.Add('update tab_codigo_sisbov ' +
                ' set ' +
                '  cod_pessoa_produtor = null ' +
                ', cod_propriedade_rural = null ' +
                ' where cod_pais_sisbov = :cod_pais_sisbov '+
                '   and cod_estado_sisbov = :cod_estado_sisbov '+
                '   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov '+
                '   and cod_animal_sisbov >= :cod_animal_inicio '+
                '   and cod_animal_sisbov <= :cod_animal_fim '+
                '   and cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and cod_propriedade_rural = :cod_propriedade_rural '+
                '   and dta_utilizacao_codigo is null ');
  {$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_inicio').AsInteger := CodAnimalInicio;
      Q.ParamByName('cod_animal_fim').AsInteger := CodAnimalFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

      Q.ExecSQL;

      // Grava o histórico dos registros
      InserirHistorico(CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
        CodAnimalInicio, CodAnimalFim, 'N');

      commit;

      ZerarValoresUltimaPesquisa;

      Mensagens.Adicionar(1580, Self.ClassName, NomMetodo, [inttostr(quant_reservado),inttostr(quant_reservado+quant_utilizado),inttostr(quant_utilizado)]);
      Result := -1580;

    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1581, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1581;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.PesquisarReservaProdutor(NomProdutor: String;CodEstadoSisBov,CodMicroRegiaoSisBov : Integer;IndCodigoUtilizado: String; NomPropriedade: WideString; CodInicial,
      CodFinal: Integer): Integer;
var
  CodPaisSisBov : Integer;
  CodEstado, CodMicroRegiao, CodAnimal :Integer;
  NomPessoa, NomPropriedadeRural: String;
  Q: THerdomQuery;
  Q1: THerdomQuery;
begin
  Result := -1;
  CodPaisSisBov := 105;

  if not Inicializado then begin
    RaiseNaoInicializado('PesquisarReservaProdutor');
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(479) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarReservaProdutor', []);
    Result := -188;
    Exit;
  end;

  if CodMicroRegiaoSisbov <> -2 then begin //caso em que não foi definido valor para CodMicroRegiao
    if CodEstadoSisbov = -1 then begin
      Mensagens.Adicionar(387, Self.ClassName, 'PesquisarReservaProdutor', []);
      Result := -387;
      Exit;
    end
    else if CodPaisSisbov = -1 then begin
      Mensagens.Adicionar(402, Self.ClassName, 'PesquisarReservaProdutor', []);
      Result := -402;
      Exit;
    end;
  end;

  if CodEstadoSisbov <> - 1 then begin
    if CodPaisSisbov = - 1 then begin
      Mensagens.Adicionar(402, Self.ClassName, 'Pesquisar', []);
      Result := -402;
      Exit;
    end;
  end;

  if (CodInicial > CodFinal) then begin
    Mensagens.Adicionar(1650, Self.ClassName, 'Pesquisar', []);
    Result := -1650;
    Exit;
  end;                     

  // select
  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tpp.sgl_produtor as SglProdutor '+
                '     , tp.nom_pessoa as NomProdutor '+
                '     , tpr.nom_propriedade_rural as NomPropriedadeRural '+
                '     , te.sgl_estado as SglEstado '+
                '     , tcs.cod_estado_sisbov as CodEstadoSisBov '+
                '     , tmr.nom_micro_regiao as NomMicroRegiao '+
                '     , tcs.cod_micro_regiao_sisbov as CodMicroRegiaoSisBov '+
                '     , tcs.cod_animal_sisbov as CodAnimalSisBov '+
                '     , case isnull(tcs.dta_utilizacao_codigo,0) '+
                '       when 0 then ''N'' else ''S'' '+
                '       end as IndCodigoUtilizado '+
                '  from tab_codigo_sisbov tcs, '+
                '       tab_produtor tpp, '+
                '       tab_pessoa tp, '+
                '       tab_estado te, '+
                '       tab_micro_regiao tmr, '+
                '       tab_propriedade_rural tpr '+
                ' where ((tcs.cod_pais_sisbov = :cod_pais_sisbov) or (:cod_pais_sisbov = -1)) '+
                '   and ((tcs.cod_estado_sisbov = :cod_estado_sisbov) or (:cod_estado_sisbov = -1)) '+
                '   and ((tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov) or (:cod_micro_regiao_sisbov = -2)) ');
  if (Trim(NomPropriedade) <> '') then begin
    Query.SQL.Add('   and tpr.nom_propriedade_rural like :Nom_Propriedade  ');
  end;
  Query.SQL.Add('   and tp.nom_pessoa like :nom_pessoa '+
                '   and tp.cod_pessoa = tpp.cod_pessoa_produtor '+
                '   and tp.cod_pessoa = tcs.cod_pessoa_produtor '+
                '   and te.cod_estado_sisbov = tcs.cod_estado_sisbov '+
                '   and tmr.cod_micro_regiao_sisbov = tcs.cod_micro_regiao_sisbov ');
  if (CodInicial > 0) and (CodFinal > 0) then begin
    Query.SQL.Add('   and tcs.cod_animal_sisbov between :Cod_Inicial and :Cod_Final ');
  end;
  Query.SQL.Add('   and tmr.cod_estado = te.cod_estado ');
  Query.SQL.Add('   and tcs.cod_propriedade_rural = tpr.cod_propriedade_rural ');


  if UpperCase(IndCodigoUtilizado) = 'S' then begin
    Query.SQL.Add('   and tcs.dta_utilizacao_codigo is not null');
  end
  else if UpperCase(IndCodigoUtilizado) = 'N' then begin
    Query.SQL.Add('   and tcs.dta_utilizacao_codigo is null');
  end;
  Query.SQL.Add(' order by NomProdutor, CodEstadoSisBov, NomMicroRegiao, IndCodigoUtilizado, CodAnimalSisBov ');
{$ENDIF}
  Query.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
  Query.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;

  if CodMicroRegiaoSisbov = 88 then
     Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := -1
  else
     Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;


  Query.ParamByName('nom_pessoa').AsString := '%' + Trim(NomProdutor) + '%';


  if NomPropriedade <> '' then begin
    Query.ParamByName('Nom_Propriedade').AsString := '%' + Trim(NomPropriedade) + '%';
  end;
  if (CodInicial > 0) and (CodFinal > 0) then begin
    Query.ParamByName('Cod_Inicial').AsInteger := CodInicial;
    Query.ParamByName('Cod_Final').AsInteger := CodFinal;
  end;


  Q := THerdomQuery.Create(Conexao, nil);
  Q1 := THerdomQuery.Create(Conexao, nil);
  Try
   Try
    Query.Open;

    Q.Close;
    Q.SQL.Add('if object_id(''tempdb..#tmp_pesquisa_sisbov'') is null '+
              '  create table #tmp_pesquisa_sisbov '+
              '  ( '+
              '    SglProdutor varchar(10) null, '+
              '    NomProdutor varchar(100) null, '+
              '    NomPropriedadeRural varchar(50) null, '+
              '    SglEstado varchar(2) null, '+
              '    CodEstadoSisBov int null, '+
              '    NomMicroRegiao varchar(40) null, '+
              '    CodMicroRegiaoSisBov int null, '+
              '    CodAnimalInicio int null, '+
              '    CodAnimalFim int null, '+
              '    IndCodigoUtilizado varchar(1) null )');
    Q.ExecSQL;

    Q.Close;
    Q.SQL.Clear;
    Q.SQL.Add(' truncate table #tmp_pesquisa_sisbov ');
    Q.ExecSQL;

    Q.Close;
    Q.SQL.Clear;
    Q.SQL.Add(' insert into #tmp_pesquisa_sisbov  '+
              '    (SglProdutor, '+
              '    NomProdutor, '+
              '    NomPropriedadeRural, '+
              '    SglEstado, '+
              '    CodEstadoSisBov, '+
              '    NomMicroRegiao, '+
              '    CodMicroRegiaoSisBov, '+
              '    CodAnimalInicio, '+
              '    CodAnimalFim, '+
              '    IndCodigoUtilizado)'+
              '    values '+
              '    (:SglProdutor, '+
              '    :NomProdutor, '+
              '    :NomPropriedadeRural, '+
              '    :SglEstado, '+
              '    :CodEstadoSisBov, '+
              '    :NomMicroRegiao, '+
              '    :CodMicroRegiaoSisBov, '+
              '    :CodAnimalInicio, '+
              '    :CodAnimalFim, '+
              '    :IndCodigoUtilizado) ');

    Q1.Close;
    Q1.SQL.Clear;
    Q1.SQL.Add(' update #tmp_pesquisa_sisbov '+
               ' set CodAnimalFim = :CodAnimalFim '+
               ' where CodAnimalFim = 0 ');

    Query.First;
    NomPessoa := '';
    NomPropriedadeRural := '';
    CodEstado := 0;
    CodMicroRegiao := 0;
    CodAnimal := -1;
    while not Query.Eof do begin
          if (NomPessoa <> Query.FieldByName('NomProdutor').asstring) or
             (NomPropriedadeRural <> Query.FieldByName('NomPropriedadeRural').asstring) or
             (CodEstado <> Query.FieldByName('CodEstadoSisBov').asinteger) or
             (CodMicroRegiao <> Query.FieldByName('CodMicroRegiaoSisBov').asinteger) or
             ((CodAnimal + 1) <> Query.FieldByName('CodAnimalSisBov').asinteger) then begin

             Q1.ParamByName('CodAnimalFim').asinteger := CodAnimal;
             Q1.ExecSQL;

             Q.ParamByName('NomProdutor').asstring := Query.FieldByName('NomProdutor').asstring;
             Q.ParamByName('NomPropriedadeRural').asstring := Query.FieldByName('NomPropriedadeRural').asstring;
             Q.ParamByName('SglProdutor').asstring := Query.FieldByName('SglProdutor').asstring;
             Q.ParamByName('SglEstado').asstring := Query.FieldByName('SglEstado').asstring;
             Q.ParamByName('CodEstadoSisBov').asinteger := Query.FieldByName('CodEstadoSisBov').asinteger;
             Q.ParamByName('NomMicroRegiao').asstring := Query.FieldByName('NomMicroRegiao').asstring;
             Q.ParamByName('CodMicroRegiaoSisBov').asinteger := Query.FieldByName('CodMicroRegiaoSisBov').asinteger;
             Q.ParamByName('CodAnimalInicio').asinteger := Query.FieldByName('CodAnimalSisBov').asinteger;
             Q.ParamByName('CodAnimalFim').asinteger := 0;
             Q.ParamByName('IndCodigoUtilizado').asstring := Query.FieldByName('IndCodigoUtilizado').asstring;
             Q.ExecSQL;

             NomPessoa := Query.FieldbyName('NomProdutor').asstring;
             NomPropriedadeRural := Query.FieldbyName('NomPropriedadeRural').asstring;
             CodEstado := Query.FieldbyName('CodEstadoSisBov').asinteger;
             CodMicroRegiao := Query.FieldbyName('CodMicroRegiaoSisBov').asinteger;
             CodAnimal := Query.FieldbyName('CodAnimalSisBov').asinteger;
          end else begin
             inc(CodAnimal);
          end;
          Query.Next;
    end;

    if Query.RecordCount > 0 then begin
      Q1.ParamByName('CodAnimalFim').asinteger := CodAnimal;
      Q1.ExecSQL;
    end;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add(' select SglProdutor, '+
                  '    NomProdutor, '+
                  '    NomPropriedadeRural, '+
                  '    SglEstado, '+
                  '    CodEstadoSisBov, '+
                  '    NomMicroRegiao, '+
                  '    CodMicroRegiaoSisBov, '+
                  '    CodAnimalInicio, '+
                  '    CodAnimalFim, '+
                  '    IndCodigoUtilizado'+
                  '    from #tmp_pesquisa_sisbov ');
    Query.Open;

    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(1582, Self.ClassName, 'PesquisarReservaProdutor', [E.Message]);
      Result := -1582;
      Exit;
    end;
  end;
 finally
   Q.Free;
   Q1.Free;
 end;
end;


function TIntCodigosSisbov.GeraArquivoCodigoExportacao(): Integer;
const
  NomeMetodo: String = 'GeraArquivoCodigoExportacao';
  TipoArquivo: Integer = 4;
var
  Q : THerdomQuery;
  X : Integer;
  //DesTipo, Prefixo: String;
  Zip : ZipFile;
  Qtd1, Qtd2 : Integer;
  CPF_CNPJ_Produtor_Rural, Cod_Sisbov, Linha,
  NomArquivoSisbov, NomArquivoZip, Pessoa,
  CNPJCodTipoArquivoSisbov,vProdutorRuralAtual,TxtPrefixoNomeArquivo, vNirf : String;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Pessoa := ValorParametro(4);
    vNirf := '';
    Try
      // Monta CPF/CNPJ
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select num_cnpj_cpf ' +
                '  from tab_pessoa ' +
                ' where cod_pessoa = :cod_pessoa  ' +
                '   and dta_fim_validade is null ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := StrToInt(Pessoa);
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1088, Self.ClassName, NomeMetodo, []);
        Result := -1088;
        Exit;
      end;

      CNPJCodTipoArquivoSisbov := '';
      X := 14 - Length(Q.FieldByName('num_cnpj_cpf').AsString);
      While X > 0 Do begin
        CNPJCodTipoArquivoSisbov := '0' + CNPJCodTipoArquivoSisbov;
        Dec(X);
      end;
      CNPJCodTipoArquivoSisbov := CNPJCodTipoArquivoSisbov + Q.FieldByName('num_cnpj_cpf').AsString;


      // Faz busca da decrição que irá compor o nome do arquivo de acordo com a operadora
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select des_tipo_arquivo_sisbov, ' +
                '       txt_prefixo_nome_arquivo ' +
                '  from tab_tipo_arquivo_sisbov ' +
                ' where cod_tipo_arquivo_sisbov = :cod_tipo_arquivo_sisbov  ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_arquivo_sisbov').AsInteger := 6;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1084, Self.ClassName, NomeMetodo, []);
        Result := -1084;
        Exit;
      end;

      TxtPrefixoNomeArquivo := Q.FieldByName('txt_prefixo_nome_arquivo').AsString;


      // Obtem as informações para geração do arquivo
      Q.Close;
      Q.SQL.Clear;
      // Transferências
      Q.SQL.Add(' select tcs.cod_pessoa_produtor,' +
                '   tpr.num_imovel_receita_federal, '+
                '   tcs.cod_estado_sisbov,  '+
                '   tcs.cod_micro_regiao_sisbov, '+
                '   tcs.cod_animal_sisbov,       '+
                '   tcs.num_dv_sisbov,           '+
                '   tp.num_cnpj_cpf,             '+
                '   case tp.cod_natureza_pessoa  '+
                '     when ''F'' then ''PF''     '+
                '     when ''J'' then ''PJ''     '+
                '   end  as tipo_proprietario,   '+
                '   tls.cod_localizacao_sisbov   '+
                ' from tab_codigo_sisbov tcs,    '+
                '      tab_pessoa tp,            '+
                '      tab_localizacao_sisbov tls,  '+
                '      tab_propriedade_rural tpr    '+
                ' where (tcs.dta_utilizacao_codigo is null  or tcs.dta_utilizacao_codigo > ''2004-04-14 23:59:00'') '+
//                '   and tcs.cod_micro_regiao_sisbov <> -1  '+
                '   and tcs.cod_pessoa_produtor   = tp.cod_pessoa     '+
                '   and tcs.cod_pessoa_produtor   = tls.cod_pessoa_produtor '+
                '   and tcs.cod_propriedade_rural = tls.cod_propriedade_rural ' +
                '   and tcs.cod_propriedade_rural = tpr.cod_propriedade_rural ' +
                '   and tcs.cod_estado_sisbov is not null ' +
                ' order by 1, 2 ');

      Q.Open;

      // Monta Nome do arquivo e o caminho que o mesmo será gravado
      NomArquivoSisbov := ValorParametro(16) + '\' +
          FormatDateTime('yyyy', Now) + '\' +
          FormatDateTime('mm', Now)   + '\' +
          FormatDateTime('dd', Now)   + '\' + TxtPrefixoNomeArquivo + '_' + formatdatetime('ddmmyyyy',now) + '.TXT';
      NomArquivoZip    := ValorParametro(16) + '\' +
          FormatDateTime('yyyy', Now) + '\' +
          FormatDateTime('mm', Now)   + '\' +
          FormatDateTime('dd', Now)   + '\' + TxtPrefixoNomeArquivo + '_' + formatdatetime('ddmmyyyy',now) + '.ZIP';

      // Cria arquivo Zip
      if AbrirZip(NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'criação']);
        Result := -1140;
        Exit;
      end;
      Try
        if AbrirArquivoNoZip(Zip, ExtractFileName(NomArquivoSisbov)) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'criação']);
          Result := -1140;
          Exit;
        end;

        // Grava registro Tipo 0
        if GravarLinhaNoZip(Zip, '0' +  CNPJCodTipoArquivoSisbov) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'gravação']);
          Result := -1140;
          Exit;
        end;

        Qtd1 := 0;
        Qtd2 := 0;

        vProdutorRuralAtual:='';
        While not Q.Eof do begin
          // Dispara impressão de registro tipo 1
          if (0 <> Q.FieldByName('cod_pessoa_produtor').AsInteger)then
          begin
            Linha := '1';
            X := 14 - Length(Q.FieldByName('num_cnpj_cpf').AsString);
            While X > 0 Do begin
              CPF_CNPJ_Produtor_Rural := '0' + CPF_CNPJ_Produtor_Rural;
              Dec(X);
            end;
            CPF_CNPJ_Produtor_Rural := CPF_CNPJ_Produtor_Rural + Q.FieldByName('num_cnpj_cpf').AsString;

            if (vProdutorRuralAtual <> CPF_CNPJ_Produtor_Rural) or (vNirf <> Q.FieldByName('num_imovel_receita_federal').AsString) then
            begin
              vProdutorRuralAtual:=CPF_CNPJ_Produtor_Rural;
              vNirf := Q.FieldByName('num_imovel_receita_federal').AsString;

              Linha := Linha + PadR(Q.FieldByName('num_imovel_receita_federal').AsString, ' ',13);
              Linha := Linha + PadR(Q.FieldByName('cod_localizacao_sisbov').AsString, ' ', 10);
              Linha := Linha + PadR(Q.FieldByName('tipo_proprietario').AsString,' ',2);
              Linha := Linha + PadR(CPF_CNPJ_Produtor_Rural, ' ', 14);
              if GravarLinhaNoZip(Zip, Linha) < 0 then begin
                Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'gravação']);
                Result := -1140;
                Exit;
              end;
              Inc(Qtd1);
            end;
            CPF_CNPJ_Produtor_Rural :='';

            // Dispara impressão de registro tipo 2
            Cod_Sisbov:= '';
            // Monta Código Sisbov
            if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '00' then begin
              Cod_Sisbov := Cod_Sisbov +
                              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                              '00' +
                              PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                              PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end Else if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '-1' then begin
              //Não possui Micro-Região!
              Cod_Sisbov := Cod_Sisbov +
                                PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end
            end Else begin
              Cod_Sisbov := Cod_Sisbov +
                                PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                                PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end;
            Linha := '2';
            Linha := Linha + Cod_Sisbov;
            if GravarLinhaNoZip(Zip, Linha) < 0 then begin
              Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'gravação']);
              Result := -1140;
              Exit;
            end;
            Inc(Qtd2);
  //        end;
          Q.Next;
        end;

        // Grava registro Tipo 9
        if GravarLinhaNoZip(Zip, '91' + StrZero(Qtd1, 6) + '2' + StrZero(Qtd2, 6)) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'gravação']);
          Result := -1140;
          Exit;
        end;

        if FecharArquivoNoZip(Zip) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'fechamento']);
          Result := -1140;
          Exit;
        end;
      Finally
        if FecharZip(Zip, nil) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArquivoZip, 'conclusão']);
          Result := -1140;
        end;
      end;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{ Altera a situação de um código SISBOV.
  O controle de transação desta operação deve ser gerenciado pelo método que
  realizou a chamada deste método.

 Parametros:
   CodPais: Código SISBOV do pais, geralmente 105 (Brasil)
   CodEstado: Código SISBOV do estado
   CodMicroRegiao: Código SISBOV da micro região
   CodAnimalSisbov: Código SISBOV do animal
   CodSituacaoSisbovDestino: Situação de destino da baixa de códigos informada

 Retorno:
   >= 0 se deu tudo certo.
   < 0 se ocorrer algum erro.}
function TIntCodigosSisbov.AlterarSituacaoSisbov(CodPais, CodEstado,
  CodMicroRegiao, CodAnimalSisbov, CodSituacaoSisbovDestino: Integer): Integer;
const
  NomeMetodo: String = 'AlterarSituacaoSisbov';
var
  QueryLocal: THerdomQuery;
  sCodigoSisbov: String;
  AtualizarDataUtilizacao, AtualizarDataEfetivacao: Boolean;
  CodEventoAutenticacao, CodEventoEnvioCertificado,
  CodAnimal: Integer;
begin
  Result := 0;
  CodEventoAutenticacao := 0;
  CodEventoEnvioCertificado := 0;
  AtualizarDataUtilizacao := False;
  AtualizarDataEfetivacao := False;
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        // Verifica para qual situação o código SISBOV deve realmente ir
        if CodSituacaoSisbovDestino = DISP then
        begin
          // Obtem o código dos eventos de autenticacao e envio de certificado
          SQL.Clear;
          SQL.Add('select cod_evento_envio_certificado,');
          SQL.Add('       cod_evento_autenticacao');
          SQL.Add('  from tab_codigo_sisbov');
          SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
          SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
          SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
          SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');

          ParamByName('cod_pais_sisbov').AsInteger := CodPais;
          ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
          ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
          ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
          Open;
          if IsEmpty then begin
            sCodigoSisbov := IntToStr(CodPais) + ' ' + IntToStr(CodEstado) +
              ' ' + IntToStr(CodMicroRegiao) + ' ' + IntToStr(CodAnimalSisbov);
            Mensagens.Adicionar(296, Self.ClassName, NomeMetodo, [sCodigoSisbov]);
            Result := -296;
            Exit;
          end;

          CodEventoAutenticacao :=
            FieldByName('cod_evento_autenticacao').AsInteger;
          CodEventoEnvioCertificado :=
            FieldByName('cod_evento_envio_certificado').AsInteger;

          Close;
        end;

        // Se o código estiver sendo atualizado para 'CAD' a data de utilizacao
        // do codigo SISBOV deve ser atualizada
        if CodSituacaoSisbovDestino = CAD then
        begin
          AtualizarDataUtilizacao := True;
        end;

        // Verifica para qual situação o código SISBOV deve realmente ir
        if CodSituacaoSisbovDestino in [EFET, AUT, CERT] then
        begin
          // Obtem as datas do código SISBOV
          SQL.Clear;
          SQL.Add('select dta_efetivacao_cadastro,');
          SQL.Add('       dta_autenticacao,');
          SQL.Add('       dta_utilizacao_codigo,');
          SQL.Add('       dta_envio_certificado');
          SQL.Add('  from tab_codigo_sisbov');
          SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
          SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
          SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
          SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');

          ParamByName('cod_pais_sisbov').AsInteger := CodPais;
          ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
          ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
          ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
          Open;
          if IsEmpty then begin
            sCodigoSisbov := IntToStr(CodPais) + ' ' + IntToStr(CodEstado) +
              ' ' + IntToStr(CodMicroRegiao) + ' ' + IntToStr(CodAnimalSisbov);
            Mensagens.Adicionar(296, Self.ClassName, NomeMetodo, [sCodigoSisbov]);
            Result := -296;
            Exit;
          end;

          // Verifica a situação correta do código SISBOV
          if not FieldByName('dta_envio_certificado').IsNull then
          begin
            CodSituacaoSisbovDestino := CERT; // CERT
          end
          else
          if not FieldByName('dta_autenticacao').IsNull then
          begin
            CodSituacaoSisbovDestino := AUT; // AUT
          end
          else
          begin
            CodSituacaoSisbovDestino := EFET; // EFET
          end;

          // Se o código não possuir uma data de efetivação então a data
          // do codigo SISBOV deve ser atualizada
          if FieldByName('dta_efetivacao_cadastro').IsNull then
          begin
            AtualizarDataEfetivacao := True;
          end;

          // Se o código não possuir uma data de utilização então a data
          // do codigo SISBOV deve ser atualizada
          if FieldByName('dta_utilizacao_codigo').IsNull then
          begin
            AtualizarDataUtilizacao := True;
          end;

          Close;
        end;

        // Atualiza o STATUS do código SISBOV
        SQL.Clear;
        SQL.Add('update tab_codigo_sisbov');
        SQL.Add('   set cod_situacao_codigo_sisbov = :cod_situacao_codigo_sisbov,');
        if CodSituacaoSisbovDestino = DISP then // Se a situação for 'DISP'
        begin
          // Limpa as datas
          SQL.Add('dta_utilizacao_codigo = NULL,');
          SQL.Add('dta_efetivacao_cadastro = NULL,');
          SQL.Add('dta_autenticacao = NULL,');
          SQL.Add('dta_envio_certificado = NULL,');
          SQL.Add('cod_evento_envio_certificado = NULL,');
          SQL.Add('cod_evento_autenticacao = NULL,');
        end
        else
        if CodSituacaoSisbovDestino = CAD then
        begin
          SQL.Add('dta_efetivacao_cadastro = NULL,');
        end;

        if AtualizarDataUtilizacao then
        begin
          // Atualiza a data de utilização do código SISBOV
          SQL.Add('dta_utilizacao_codigo = getDate(),');
        end;
        if AtualizarDataEfetivacao then
        begin
          // Atualiza a data de utilização do código SISBOV
          SQL.Add('dta_efetivacao_cadastro = getDate(),');
        end;
        SQL.Add('       dta_mudanca_situacao = getDate(),');
        SQL.Add('       cod_usuario_mudanca = :cod_usuario_mudanca,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate()');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');

        ParamByName('cod_situacao_codigo_sisbov').AsInteger := CodSituacaoSisbovDestino;
        ParamByName('cod_pais_sisbov').AsInteger := CodPais;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
        ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        ExecSQL;

        // Se o código SISBOV estiver sendo desassociado de um animal
        // verifica se o animal está em um evento de envio de certificado
        // ou autenticação. Se estiver exclui o animal do evento.
        if (CodSituacaoSisbovDestino = DISP)
          and ((CodEventoAutenticacao <> 0)
           or (CodEventoEnvioCertificado <> 0)) then
        begin
          // Verifica se produtor de trabalho foi definido
          if Conexao.CodProdutorTrabalho = -1 then
          begin
            Mensagens.Adicionar(307, Self.ClassName, 'AlterarSituacaoSisbov', []);
            Result := -307;
            Exit;
          end;

          SQL.Clear;
          SQL.Add('select cod_animal');
          SQL.Add('  from tab_animal');
          SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
          SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
          SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
          SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');
          SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
          SQL.Add('   and dta_fim_validade is null');

          ParamByName('cod_pais_sisbov').AsInteger := CodPais;
          ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
          ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
          ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
          ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;

          Open;
          if IsEmpty then
          begin
            sCodigoSisbov := IntToStr(CodPais) + ' ' + IntToStr(CodEstado) +
              ' ' + IntToStr(CodMicroRegiao) + ' ' + IntToStr(CodAnimalSisbov);

            Mensagens.Adicionar(1917, Self.ClassName, NomeMetodo, [sCodigoSisbov]);
            Result := -1917;
            Exit;
          end;

          CodAnimal := FieldByName('cod_animal').AsInteger;

          if CodEventoAutenticacao <> 0 then
          begin
            RemoverAnimalEvento(CodAnimal, Conexao.CodProdutorTrabalho,
              CodEventoAutenticacao, false);
          end;

          if CodEventoEnvioCertificado <> 0 then
          begin
            RemoverAnimalEvento(CodAnimal, Conexao.CodProdutorTrabalho,
              CodEventoEnvioCertificado, true);
          end;
        end;

        InserirHistorico(CodPais, CodEstado, CodMicroRegiao, CodAnimalSisbov,
          CodAnimalSisbov, 'N');
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(1900, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1900;
      Exit;
    end;
  end;
end;

{ Grava na tabela tab_historico_codigo_sisbov a situação atual do regsitro.
  O controle de transação desta operação deve ser gerenciado pelo método que
  realizou a chamada deste método.

 Parametros:
   CodPais: Código SISBOV do pais, geralmente 105 (Brasil)
   CodEstado: Código SISBOV do estado
   CodMicroRegiao: Código SISBOV da micro região
   CodAnimalSisbovIncial: Código SISBOV inicial
   CodAnimalSisbovFinal: Código SISBOV final
   IndExclusao: Indica se o registro exta sendo excluido. Deve ser 'S'
      se o registro estiver sendo excluido e 'N' caso contrário. Se este
      parametro for 'S' o valor do campo cod_situacao_codigo_sisbov será
      o código da situação 'EXCLUIDO'.

 Retorno:
   Sem Retorno.

 exception:
   Caso ocorra algum erro uma excessão será lançada.}
procedure TIntCodigosSisbov.InserirHistorico(CodPais, CodEstado,
  CodMicroRegiao, CodAnimalSisbovInicial, CodAnimalSisbovFinal: Integer;
  IndExclusao: String);
begin
  try
    // Prepara a query de insert
    FQueryInsertHistorico.SQLConnection := Conexao.SQLConnection;

    // Obtem os dados do código SISBOV informado
    with FQueryInsertHistorico do
    begin
      ParamByName('cod_pais_sisbov').AsInteger := CodPais;
      ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
      ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
      ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSisbovInicial;
      ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSisbovFinal;
      ParamByName('cod_situacao_codigo_sisbov').AsInteger := -1;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      // Se os códigos estiverem sendo excluidos atualiza a situação dos códigos
      // para 'EXCLUIDO'
      if IndExclusao = 'S' then
      begin
        ParamByName('cod_situacao_codigo_sisbov').AsInteger := EXCL;
      end;

      ExecSQL;
    end;
  except
    // Repassa a excessão caso ocorra algum erro
    raise;
  end;
end;

{ Restaura a ultima situação de um código SISBOV.
  O controle de transação desta operação deve ser gerenciado pelo método que
  realizou a chamada deste método.

 Parametros:
   CodPais: Código SISBOV do pais, geralmente 105 (Brasil)
   CodEstado: Código SISBOV do estado
   CodMicroRegiao: Código SISBOV da micro região
   CodAnimalSisbov: Código SISBOV do animal

 Retorno:
   >= 0 se deu tudo certo.
   < 0 se ocorrer algum erro.}
function TIntCodigosSisbov.RestaurarSituacaoSisbov(CodPais, CodEstado,
  CodMicroRegiao, CodAnimalSisbov: Integer): Integer;
const
  NomeMetodo: String = 'RestaurarSituacaoSisbov';
var
  QueryLocal: THerdomQuery;
  CodSituacaoSisbovDestino: Integer;
  sCodigoSisbov: String;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem a ultima situação do animal
      with QueryLocal do
      begin
        SQL.Add('select dta_utilizacao_codigo,');
        SQL.Add('       dta_efetivacao_cadastro');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');

        ParamByName('cod_pais_sisbov').AsInteger := CodPais;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;

        Open;
        if IsEmpty then
        begin
          sCodigoSisbov := IntToStr(CodPais) + ' ' + IntToStr(CodEstado) +
            ' ' + IntToStr(CodMicroRegiao) + ' ' + IntToStr(CodAnimalSisbov);
          Mensagens.Adicionar(296, Self.ClassName, NomeMetodo, [sCodigoSisbov]);
          Result := -296;
          Exit;
        end;

        // Verifica qual era a situação anterior do código SISBOV
        if FieldByName('dta_utilizacao_codigo').IsNull then
        begin
          CodSituacaoSisbovDestino := 1; // Cadastrado
        end
        else
        if not FieldByName('dta_efetivacao_cadastro').IsNull then
        begin
          CodSituacaoSisbovDestino := 3; // Animal Efetivado 'IDENT'
        end
        else
        begin
          CodSituacaoSisbovDestino := 2; // cadastrado
        end;
      end;

      // Altera a situação do animal 
      Result := AlterarSituacaoSisbov(CodPais, CodEstado, CodMicroRegiao,
        CodAnimalSisbov, CodSituacaoSisbovDestino);
      if Result < 0 then
      begin
        Exit;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(1902, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1902;
      Exit;
    end;
  end;
end;

{ Verifica se uma faixa de códigos SISBOV está disponivel. Se estiver marca os
  códigos como utilizados.
  A transão deve ser controla pelo método que originou a chamada deste método.

Parametros:
  CodPaisSISBOV: Código SISBOV do país
  CodEstadoSISBOV: Código SISBOV do estado
  CodMicroRegiaoSISBOV: Código SISBOV da micro região
  CodAInicialAnimalSisbov: Código SISBOV inicial do animal
  QtdAnimais: Quantidade de códigos SISBOV que devem ser verificados.

Retorno:
  > 0 se der tudo certo.
  < 0 se ocorrer algum erro}
function TIntCodigosSisbov.ReservaCodigos(CodPaisSisbov, CodEstadoSisbov,
  CodMicroRegiaoSisbov, CodAnimalSisbovInicio, QtdAnimais: Integer): Integer;
const
  NomeMetodo : String = 'ReservaCodigos';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(conexao, nil);
  Try
    Try

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(*) as qtd_disponivel');
      Q.SQL.Add('  from tab_codigo_sisbov');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
      Q.SQL.Add('   and cod_animal_sisbov between :cod_inicial_animal_sisbov and :cod_final_animal_sisbov');
      Q.SQL.Add('   and dta_utilizacao_codigo is null');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_inicial_animal_sisbov').AsInteger := CodAnimalSisbovInicio;
      Q.ParamByName('cod_final_animal_sisbov').AsInteger := CodAnimalSisbovInicio + QtdAnimais - 1;

      Q.Open;
      if (Q.FieldByName('qtd_disponivel').AsInteger < QtdAnimais) or
         (Q.IsEmpty) then begin
        Mensagens.Adicionar(747, Self.ClassName, NomeMetodo, [IntToStr(QtdAnimais)]);
        Result := -747;
        Exit;
      end;
      Q.Close;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_codigo_sisbov');
      Q.SQL.Add('   set dta_utilizacao_codigo = getdate()');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
      Q.SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
      Q.SQL.Add('   and cod_animal_sisbov between :cod_inicial_animal_sisbov and :cod_final_animal_sisbov');
      Q.SQL.Add('   and dta_utilizacao_codigo is null');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_inicial_animal_sisbov').AsInteger := CodAnimalSisbovInicio;
      Q.ParamByName('cod_final_animal_sisbov').AsInteger := CodAnimalSisbovInicio + QtdAnimais - 1;

      Q.ExecSQL;

      InserirHistorico(CodEstadoSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
        CodAnimalSisbovInicio, CodAnimalSisbovInicio + QtdAnimais - 1, 'N');

      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, NomeMetodo, [E.Message, 'utilização de códigos sisbov por intervalo']);
        Result := -496;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{ Exclui o animal do evento.
  Se o animal excluido for o ultimo do evento, apaga o evento.

 Parametros:
   CodAnimal: Código do animal a ser excluido
   CodPessoaProdutor: Código do produtor ao qual o animal pertence
   CodEvento: Código do Evento que o animal deve ser excluido 

 Retorno:
   Sem retorno !!!

 Excessões:
   Retorna uma excessão caso ocorra algum erro.
}
procedure TIntCodigosSisbov.RemoverAnimalEvento(CodAnimal, CodPessoaProdutor,
  CodEvento: Integer; IndEventoEnvioCertificado: Boolean);
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Remove o animal do evento
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('delete from tab_animal_evento');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   and cod_animal = :cod_animal');
        SQL.Add('   and cod_evento = :cod_evento');

        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_animal').AsInteger := CodAnimal;
        ParamByName('cod_evento').AsInteger := CodEvento;

        ExecSQL;
      end;

      // Exclui o evento se estiver vazio
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select 1 from tab_animal_evento');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
//        SQL.Add('   and cod_animal = :cod_animal');
        SQL.Add('   and cod_evento = :cod_evento');

        ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
//        ParamByName('cod_animal').AsInteger := CodAnimal;
        ParamByName('cod_evento').AsInteger := CodEvento;

        Open;
        // Verifica se o evento esta vazio
        if not IsEmpty then
        begin
          Exit;
        end;

        if IndEventoEnvioCertificado then
        begin
          // Exclui o evento
          SQL.Clear;
          SQL.Add('delete from tab_evento_envio_certificado');
          SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
          SQL.Add('   and cod_evento = :cod_evento');

          ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          ParamByName('cod_evento').AsInteger := CodEvento;

          ExecSQL;
        end;

        // Exclui o evento
        SQL.Clear;
        SQL.Add('delete from tab_evento');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   and cod_evento = :cod_evento');

        ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        ParamByName('cod_evento').AsInteger := CodEvento;

        ExecSQL;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    // Repassa a excessão
    raise;
  end;
end;

function TIntCodigosSisbov.AlterarSolicitacao(CodPessoaProdutor: Integer;
  SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov, NumSolicitacaoSISBOV: Integer;
  DtaSolicitacaoSISBOV: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
const
  CodMetodo: Integer = 582;
  NomMetodo: String = 'AlterarSolicitacao';
var
  Q: THerdomQuery;
  Contador, NumDiasUnicidadeSolicitacao, CodPais, CodEstado,
    NumDvSISBOV: Integer;
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o número da solicitação foi informado corretamente
  if NumSolicitacaoSISBOV <= 0 then begin
    Mensagens.Adicionar(1911, Self.ClassName, NomMetodo, []);
    Result := -1911;
    Exit;
  end;

  // Verifica se a data da solicitação foi informada corretamente
  if (DtaSolicitacaoSISBOV = 0) or (DtaSolicitacaoSISBOV < EncodeDate(2004, 01, 01)) then begin
    Mensagens.Adicionar(1912, Self.ClassName, NomMetodo, []);
    Result := -1912;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens,
                                                                                        NumImovelReceitaFederal, CodPropriedadeRural, CodLocalizacaoSisbov,
                                                                                        CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      // Busca parâmetro que indica o número de dias para verificação da
      // unicidade de número da solicitação SISBOV
      NumDiasUnicidadeSolicitacao :=
        StrToInt(ValorParametro(PRAZO_DIAS_UNICIDADE_SOLICITACAO));

      // Consiste se o país sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
        Result := -299;
        Exit;
      end;

      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      // Abre transação
      beginTran;

      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select count(1) as qtd_codigos ' +
        '  from tab_codigo_sisbov ' +
        ' where cod_pais_sisbov = :cod_pais_sisbov' +
        '   and cod_estado_sisbov = :cod_estado_sisbov' +
        '   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov' +
        '   and cod_animal_sisbov between :cod_animal_sisbov_inicio' +
        '                             and :cod_animal_sisbov_fim ' +
        '   and cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '   and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigos').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Rollback;
        Exit;
      end;

      // Verifica existência do número de solicitação dentro do período identificado
      // para outros códigos que não correspondam a faixa informada
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Text :=
          'select ' +
          '  1 ' +
          'from ' +
          '  tab_codigo_sisbov ' +
          'where ' +
          '  num_solicitacao_sisbov = :num_solicitacao_sisbov ' +
          '  and dta_solicitacao_sisbov between :dta_solicitacao_sisbov_inicio and :dta_solicitacao_sisbov_fim ' +
          '  and not ( ' +
          '    cod_pais_sisbov = :cod_pais_sisbov ' +
          '    and cod_estado_sisbov = :cod_estado_sisbov ' +
          '    and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '    and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  ) ';
{$ENDIF}
      Q.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      Q.ParamByName('dta_solicitacao_sisbov_inicio').AsDateTime := DtaSolicitacaoSISBOV - NumDiasUnicidadeSolicitacao;
      Q.ParamByName('dta_solicitacao_sisbov_fim').AsDateTime := DtaSolicitacaoSISBOV;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(1923, Self.ClassName, NomMetodo, [intToStr(NumSolicitacaoSISBOV)]);
        Result := -1923;
        Exit;
      end;

      // Tenta alterar os registros localizados
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'update ' +
        '  tab_codigo_sisbov ' +
        'set ' +
        '  num_solicitacao_sisbov = :num_solicitacao_sisbov ' +
        '  , dta_solicitacao_sisbov = :dta_solicitacao_sisbov ' +
        '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
        '  , dta_ultima_alteracao = getdate() ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
        '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      Q.ParamByName('dta_solicitacao_sisbov').AsDateTime := DtaSolicitacaoSISBOV;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.CancelarAutenticacao(CodPessoaProdutor: Integer;
  SglProdutor, NumCNPJCPFProdutor: String; CodPropriedadeRural: Integer;
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
const
  CodMetodo: Integer = 584;
  NomMetodo: String = 'CancelarAutenticacao';
var
  Q: THerdomQuery;
  bRestaurarAutenticacao: Boolean;
  Contador, CodPais, CodEstado, NumDvSISBOV, QtdCodigo,
    CodEventoAutenticacao: Integer;
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens,
                                                                                        NumImovelReceitaFederal, CodPropriedadeRural, CodLocalizacaoSisbov,
                                                                                        CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      // Consiste se o país sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
        Result := -299;
        Exit;
      end;

      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(cod_pessoa_produtor, 0)) as qtd_produtor ' +
        '  , count(distinct isnull(cod_propriedade_rural, 0)) as qtd_propriedade_rural ' +
        '  , count(distinct isnull(cod_evento_autenticacao, 0)) as qtd_evento_autenticacao ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , sum(case isnull(dta_autenticacao, 0) when 0 then 0 else 1 end) as qtd_codigo_autenticado ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_evento_autenticacao, 0)) as cod_evento_autenticacao ' +
        '  , max(isnull(qtd_vezes_autenticacao, 0)) as qtd_vezes_autenticacao ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodEventoAutenticacao := Q.FieldByName('cod_evento_autenticacao').AsInteger;
      bRestaurarAutenticacao := (Q.FieldByName('qtd_vezes_autenticacao').AsInteger <> 1);
      if (Q.FieldByName('qtd_produtor').AsInteger <> 1) or (Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor) then begin
        Mensagens.Adicionar(1925, Self.ClassName, NomMetodo, []);
        Result := -1925;
        Exit;
      end;
      if (Q.FieldByName('qtd_propriedade_rural').AsInteger <> 1) or (Q.FieldByName('cod_propriedade_rural').AsInteger <> CodPropriedadeRural) then begin
        Mensagens.Adicionar(1926, Self.ClassName, NomMetodo, []);
        Result := -1926;
        Exit;
      end;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1927, Self.ClassName, NomMetodo, []);
        Result := -1927;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_autenticado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1933, Self.ClassName, NomMetodo, []);
        Result := -1933;
        Exit;
      end;
      if (Q.FieldByName('qtd_evento_autenticacao').AsInteger <> 1) then begin
        Mensagens.Adicionar(1934, Self.ClassName, NomMetodo, []);
        Result := -1934;
        Exit;
      end;

(*
      Alteração permitindo que apenas uma faixa parcial de códigos tenha o
      processamento cancelado.
      // Verifica se todos os códigos referentes ao evento de autenticacao
      // correspondente são contemplados pela faixa informada
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo_evento ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_propriedade_rural = :cod_propriedade_rural ' +
        '  and cod_evento_autenticacao = :cod_evento_autenticacao ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_evento_autenticacao').AsInteger := CodEventoAutenticacao;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo_evento').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1935, Self.ClassName, NomMetodo, []);
        Result := -1935;
        Exit;
      end;
      Q.Close;
*)

      // Abre transação
      beginTran;

      // Remove animais associados ao evento de autenticação correspondente
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'delete from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ' +
        '  and cod_animal in ( ' +
        '    select ' +
        '      cod_animal ' +
        '    from ' +
        '      tab_animal ' +
        '    where ' +
        '      cod_pais_sisbov = :cod_pais_sisbov ' +
        '      and cod_estado_sisbov = :cod_estado_sisbov ' +
        '      and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '      and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
        '      and cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '      and dta_fim_validade is null ' +
        '  ) ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoAutenticacao;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1998, Self.ClassName, NomMetodo, []);
        Result := -1998;
        Rollback;
        Exit;
      end;

      // Verifica se todos os animais associados ao evento foram removido
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  top 1 1 ' +
        'from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoAutenticacao;
      Q.Open;
      if Q.IsEmpty then begin
        // Remove evento de correspondente, pois nenhum animal está associado
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete from ' +
          '  tab_evento ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoAutenticacao;
        Q.ExecSQL;
      end else begin
        // Atualiza a quantidade de animais associada ao evento
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_evento ' +
          'set ' +
          '  qtd_animais = ( ' +
          '    select ' +
          '      count(cod_animal) ' +
          '    from ' +
          '      tab_animal_evento ' +
          '    where ' +
          '      cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '      and cod_evento = :cod_evento ' +
          '  ) ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoAutenticacao;
        Q.ExecSQL;
      end;

      // Verifica se é necessária a restauração de algum valor
      if bRestaurarAutenticacao then begin
        // Restaura última autenticação sofrida pela faixa de códigos SISBOV
        // autenticada correspondente
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_autenticacao = tha.dta_autenticacao ' +
          '  , cod_evento_autenticacao = tha.cod_evento_autenticacao ' +
          '  , qtd_vezes_autenticacao = tha.qtd_vezes_autenticacao ' +
          '  , dta_liberacao_abate = tha.dta_liberacao_abate ' +
          '  , ind_data_liberacao_estimada = tha.ind_data_liberacao_estimada ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'from ' +
          '  tab_codigo_sisbov tcs ' +
          '  inner join tab_historico_autenticacao tha on ' +
          '    tcs.cod_pais_sisbov = tha.cod_pais_sisbov ' +
          '    and tcs.cod_estado_sisbov = tha.cod_estado_sisbov ' +
          '    and tcs.cod_micro_regiao_sisbov = tha.cod_micro_regiao_sisbov ' +
          '    and tcs.cod_animal_sisbov = tha.cod_animal_sisbov ' +
          '    and tcs.num_dv_sisbov = tha.num_dv_sisbov ' +
          '    and tcs.qtd_vezes_autenticacao-1 = tha.qtd_vezes_autenticacao ' +
          'where ' +
          '  tcs.cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and tcs.cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and tcs.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and tcs.cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and tcs.cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      end else begin
        // Limpa autenticação da faixa de códigos SISBOV autenticada
        // correspondente
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_autenticacao = null ' +
          '  , cod_evento_autenticacao = null ' +
          '  , qtd_vezes_autenticacao = null ' +
          '  , dta_liberacao_abate = null ' +
          '  , ind_data_liberacao_estimada = null ' +
          '  , cod_situacao_codigo_sisbov = case cod_situacao_codigo_sisbov when :cod_situacao_aut then :cod_situacao_ident else cod_situacao_codigo_sisbov end ' +
          '  , cod_usuario_mudanca = case cod_situacao_codigo_sisbov when :cod_situacao_aut then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
          '  , dta_mudanca_situacao = case cod_situacao_codigo_sisbov when :cod_situacao_aut then getdate() else dta_mudanca_situacao end ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
        Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
      end;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1932, Self.ClassName, NomMetodo, []);
        Result := -1932;
        Rollback;
        Exit;
      end;

      // Remove do histórico de autenticações a faixa de autenticação restaurada
      if bRestaurarAutenticacao then begin
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete tab_historico_autenticacao ' +
          'from ' +
          '  tab_historico_autenticacao tha ' +
          '  inner join tab_codigo_sisbov tcs on ' +
          '    tha.cod_pais_sisbov = tcs.cod_pais_sisbov ' +
          '    and tha.cod_estado_sisbov = tcs.cod_estado_sisbov ' +
          '    and tha.cod_micro_regiao_sisbov = tcs.cod_micro_regiao_sisbov ' +
          '    and tha.cod_animal_sisbov = tcs.cod_animal_sisbov ' +
          '    and tha.num_dv_sisbov = tcs.num_dv_sisbov ' +
          '    and tha.qtd_vezes_autenticacao = tcs.qtd_vezes_autenticacao ' +
          'where ' +
          '  tcs.cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and tcs.cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and tcs.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and tcs.cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and tcs.cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ExecSQL;
        if Q.RowsAffected <> QtdCodigo then begin
          Mensagens.Adicionar(1997, Self.ClassName, NomMetodo, []);
          Result := -1997;
          Rollback;
          Exit;
        end;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.CancelarEnvioCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  CodMetodo: Integer = 586;
  NomMetodo: String = 'CancelarEnvioCertificado';
var
  Q: THerdomQuery;
  bRestaurarEnvioCertificado: Boolean;
  QtdCodigo,
  CodEventoEnvioCertificado,
  CodPessoaProdutor: Integer;
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

  if CodOrdemServico = -1 then
  begin
    Mensagens.Adicionar(2049, Self.ClassName, NomMetodo, []);
    Result := -2049;
    Exit;
  end;

  if NumRemessaFicha = -1 then
  begin
    Mensagens.Adicionar(2050, Self.ClassName, NomMetodo, []);
    Result := -2050;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(cod_pessoa_produtor, 0)) as qtd_produtor ' +
        '  , count(distinct isnull(cod_propriedade_rural, 0)) as qtd_propriedade_rural ' +
        '  , count(distinct isnull(cod_evento_envio_certificado, 0)) as qtd_evento_envio_certificado ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , sum(case isnull(dta_envio_certificado, 0) when 0 then 0 else 1 end) as qtd_codigo_certificado ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_evento_envio_certificado, 0)) as cod_evento_envio_certificado ' +
        '  , max(isnull(qtd_vezes_envio_certificado, 0)) as qtd_vezes_envio_certificado ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        ' cod_ordem_servico = :cod_ordem_servico ' +
        ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}
      Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      Q.Open;

      CodPessoaProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;

      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodEventoEnvioCertificado := Q.FieldByName('cod_evento_envio_certificado').AsInteger;
      bRestaurarEnvioCertificado := (Q.FieldByName('qtd_vezes_envio_certificado').AsInteger <> 1);
      if (Q.FieldByName('qtd_produtor').AsInteger <> 1) or (Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor) then begin
        Mensagens.Adicionar(1925, Self.ClassName, NomMetodo, []);
        Result := -1925;
        Exit;
      end;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1927, Self.ClassName, NomMetodo, []);
        Result := -1927;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_certificado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1939, Self.ClassName, NomMetodo, []);
        Result := -1939;
        Exit;
      end;
      if (Q.FieldByName('qtd_evento_envio_certificado').AsInteger <> 1) then begin
        Mensagens.Adicionar(1940, Self.ClassName, NomMetodo, []);
        Result := -1940;
        Exit;
      end;


      // Abre transação
      beginTran;

      // Remove animais associados ao evento de autenticação correspondente
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'delete from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ' +
        '  and cod_animal in ( ' +
        '    select ' +
        '      cod_animal ' +
        '    from ' +
        '      tab_animal ta,' +
        '      tab_codigo_sisbov tcs ' +
        '    where ' +
        '      tcs.cod_pais_sisbov = ta.cod_pais_sisbov ' +
        '      and tcs.cod_estado_sisbov = ta.cod_estado_sisbov ' +
        '      and tcs.cod_micro_regiao_sisbov = ta.cod_micro_regiao_sisbov ' +
        '      and tcs.cod_animal_sisbov = ta.cod_animal_sisbov' +
        '      and dta_fim_validade is null ' +
        '      and cod_ordem_servico = :cod_ordem_servico ' +
        '      and num_remessa_ficha = :num_remessa_ficha ' +
        '  ) ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
      Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1998, Self.ClassName, NomMetodo, []);
        Result := -1998;
        Rollback;
        Exit;
      end;


      // Verifica se todos os animais associados ao evento foram removido
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  top 1 1 ' +
        'from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
      Q.Open;
      if Q.IsEmpty then begin
        // Remove evento de correspondente, pois nenhum animal está associado
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete from ' +
          '  tab_evento_envio_certificado ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;

        // Remove evento de correspondente, pois nenhum animal está associado
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete from ' +
          '  tab_evento ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;
      end else begin
        // Atualiza a quantidade de animais associada ao evento
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_evento ' +
          'set ' +
          '  qtd_animais = ( ' +
          '    select ' +
          '      count(cod_animal) ' +
          '    from ' +
          '      tab_animal_evento ' +
          '    where ' +
          '      cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '      and cod_evento = :cod_evento ' +
          '  ) ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;
      end;

      // Verifica se é necessária a restauração de algum valor
      if bRestaurarEnvioCertificado then begin
        // Restaura último envio de certificado sofrido pela faixa de códigos
        // SISBOV autenticada correspondente
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_envio_certificado = thec.dta_envio_certificado ' +
          '  , cod_evento_envio_certificado = thec.cod_evento_envio_certificado ' +
          '  , qtd_vezes_envio_certificado = thec.qtd_vezes_envio_certificado ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'from ' +
          '  tab_codigo_sisbov tcs ' +
          '  inner join tab_historico_env_certificado thec on ' +
          '    tcs.cod_pais_sisbov = thec.cod_pais_sisbov ' +
          '    and tcs.cod_estado_sisbov = thec.cod_estado_sisbov ' +
          '    and tcs.cod_micro_regiao_sisbov = thec.cod_micro_regiao_sisbov ' +
          '    and tcs.cod_animal_sisbov = thec.cod_animal_sisbov ' +
          '    and tcs.num_dv_sisbov = thec.num_dv_sisbov ' +
          '    and tcs.qtd_vezes_envio_certificado-1 = thec.qtd_vezes_envio_certificado ' +
          'where ' +
          ' cod_ordem_servico = :cod_ordem_servico ' +
          ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}
      end else begin
        // Altera faixa de códigos SISBOV correspondentes ao envio de certificado
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_envio_certificado = null ' +
          '  , cod_evento_envio_certificado = null ' +
          '  , qtd_vezes_envio_certificado = null ' +
          '  , cod_situacao_codigo_sisbov = ' +
          '    case cod_situacao_codigo_sisbov ' +
          '      when :cod_situacao_cert then ' +
          '        case ' +
          '          when dta_autenticacao is null then ' +
          '            :cod_situacao_ident ' +
          '          else ' +
          '            :cod_situacao_aut ' +
          '        end ' +
          '      else ' +
          '        cod_situacao_codigo_sisbov ' +
          '    end ' +
          '  , cod_usuario_mudanca = case cod_situacao_codigo_sisbov when :cod_situacao_cert then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
          '  , dta_mudanca_situacao = case cod_situacao_codigo_sisbov when :cod_situacao_cert then getdate() else dta_mudanca_situacao end ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'where ' +
          ' cod_ordem_servico = :cod_ordem_servico ' +
          ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}
        Q.ParamByName('cod_situacao_cert').AsInteger := CERT;
        Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
        Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
      end;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1932, Self.ClassName, NomMetodo, []);
        Result := -1932;
        Rollback;
        Exit;
      end;

      // Remove do histórico de envio de certificados correspondente a faixa de
      // envio de certificados restaurada
      if bRestaurarEnvioCertificado then begin
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete tab_historico_env_certificado ' +
          'from ' +
          '  tab_historico_env_certificado thec ' +
          '  inner join tab_codigo_sisbov tcs on ' +
          '    thec.cod_pais_sisbov = tcs.cod_pais_sisbov ' +
          '    and thec.cod_estado_sisbov = tcs.cod_estado_sisbov ' +
          '    and thec.cod_micro_regiao_sisbov = tcs.cod_micro_regiao_sisbov ' +
          '    and thec.cod_animal_sisbov = tcs.cod_animal_sisbov ' +
          '    and thec.num_dv_sisbov = tcs.num_dv_sisbov ' +
          '    and thec.qtd_vezes_envio_certificado = tcs.qtd_vezes_envio_certificado ' +
          'where ' +
          ' cod_ordem_servico = :cod_ordem_servico ' +
          ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}
        Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Q.ExecSQL;
        if Q.RowsAffected <> QtdCodigo then begin
          Mensagens.Adicionar(1997, Self.ClassName, NomMetodo, []);
          Result := -1997;
          Rollback;
          Exit;
        end;
      end;

      // Gera o histórico das faixas atualizadas.
      with Q do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');
          Next;
        end;
      end;

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.ProcessarAutenticacao(
  CodPessoaProdutor: Integer; SglProdutor, NumCNPJCPFProdutor: String;
  CodPropriedadeRural: Integer; NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer;
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
  NumDVSISBOVFim: Integer; DtaLiberacaoAbate: TDateTime): Integer;
const
  CodMetodo: Integer = 583;
  NomMetodo: String = 'ProcessarAutenticacao';
var
  Q: THerdomQuery;
  IntEventos: TIntEventos;
  bGerarHistoricoAutenticacao: Boolean;
  DtaHoraCorrente, DtaLiberacaoAbateInicio, DtaLiberacaoAbateFim: TDateTime;
  IndDtaAbateEstimada, sCodSISBOVInicio, sCodSISBOVFim, sNumCNPJCPF,
    sNIRFIncra: String;
  Contador, NumDiasEspera, CodPais, CodEstado, NumDvSISBOV, QtdCodigo,
    CodEventoAutenticacao, CodOrdemServico: Integer;

  function BuscaCNPJCPF: String;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select ' +
      '  case tp.cod_natureza_pessoa ' +
      '    when ''F'' then convert(varchar(18), ' +
      '      substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '      substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '    when ''J'' then convert(varchar(18), ' +
      '      substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '      substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '      substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '  end as NumCNPJCPFFormatado ' +
      'from ' +
      '  tab_pessoa tp ' +
      'where ' +
      '  tp.dta_fim_validade is null ' +
      '  and tp.cod_pessoa = :cod_pessoa ';
    Q.ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
    Q.Open;
    Result := Q.FieldByName('NumCNPJCPFFormatado').AsString;
    Q.Close;
  end;

  function BuscaNIRFIncra(): String;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select ' +
      '  tpr.num_imovel_receita_federal as NIRFIncra ' +
      'from ' +
      '  tab_propriedade_rural tpr ' +
      'where ' +
      '  tpr.dta_fim_validade is null ' +
      '  and tpr.cod_propriedade_rural = :cod_propriedade_rural ';
    Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
    Q.Open;
    Result := Q.FieldByName('NIRFIncra').AsString;
    Q.Close;
  end;

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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  // Formata código SISBOV para apresentação ao usuário em caso de advertência
  sCodSISBOVInicio := FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio);
  sCodSISBOVFim := FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim, NumDVSISBOVFim);
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;
      // Formata CNPJ/CPF para apresentação ao usuário em caso de advertência
      sNumCNPJCPF := BuscaCNPJCPF;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens, NumImovelReceitaFederal,
                                                                                        CodPropriedadeRural, CodLocalizacaoSisbov,
                                                                                        CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;
      // Formata NIRF/Incra para apresentação ao usuário em caso de advertência
      sNIRFIncra := BuscaNIRFIncra();

      // Busca parâmetro que indica o número de dias para verificação da
      // unicidade de número da solicitação SISBOV
      NumDiasEspera :=
        StrToIntDef(ValorParametro(NUM_DIAS_EMISSAO_CERTIFICADO), 40);

      // Consiste se o país sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
        Result := -299;
        Exit;
      end;

      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1967, Self.ClassName, NomMetodo, [sNIRFIncra, sNumCNPJCPF, sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1967;
        Exit;
      end;

      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(cod_pessoa_produtor, 0)) as qtd_produtor ' +
        '  , count(distinct isnull(cod_propriedade_rural, 0)) as qtd_propriedade_rural ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , count(distinct isnull(cod_ordem_servico, 0)) as qtd_ordem_servico ' +
        '  , sum(case isnull(dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) as qtd_codigo_utilizado ' +
        '  , sum(case isnull(dta_autenticacao, 0) when 0 then 0 else 1 end) as qtd_codigo_autenticado ' +
        '  , sum(case when cod_situacao_codigo_sisbov in (2, 3, 4, 5, 6, 7) then 1 else 0 end) as qtd_situacao_codigo ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_ordem_servico, 0)) as cod_ordem_servico ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1968, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1968;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodOrdemServico := Q.FieldByName('cod_ordem_servico').AsInteger;
      if (Q.FieldByName('qtd_produtor').AsInteger <> 1) or (Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor) then begin
        Mensagens.Adicionar(1969, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim, sNumCNPJCPF]);
        Result := -1969;
        Exit;
      end;
      if (Q.FieldByName('qtd_propriedade_rural').AsInteger <> 1) or (Q.FieldByName('cod_propriedade_rural').AsInteger <> CodPropriedadeRural) then begin
        Mensagens.Adicionar(1970, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim, sNIRFIncra]);
        Result := -1970;
        Exit;
      end;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1971, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1971;
        Exit;
      end;
      if (Q.FieldByName('qtd_ordem_servico').AsInteger <> 1) then begin
        Mensagens.Adicionar(1972, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1972;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_utilizado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1973, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1973;
        Exit;
      end;
{
      Essa alteração permite que códigos já autenticados possam sofrer nova
      autenticação. Os códigos que já foram autenticados terão seus atributos
      de situação armazenados em tabela de histórico para possibilitar posterior
      cancelamento, caso necessário.
      if (Q.FieldByName('qtd_codigo_autenticado').AsInteger <> 0) then begin
        Mensagens.Adicionar(1929, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1929;
        Exit;
      end;
}
      bGerarHistoricoAutenticacao := (Q.FieldByName('qtd_codigo_autenticado').AsInteger <> 0);
      if (Q.FieldByName('qtd_situacao_codigo').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1930, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1930;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Insere evento de autenticação
      IntEventos := TIntEventos.Create;
      try
        if IntEventos.Inicializar(Conexao, Mensagens) < 0 then begin
          Rollback;
          Exit;
        end;

        DtaHoraCorrente := DtaSistema;
        CodEventoAutenticacao := IntEventos.InserirEvento(
          CodPessoaProdutor, EVENTO_AUTENTICACAO_SISBOV, DtaHoraCorrente,
          DtaHoraCorrente, '', '', -1);

        if CodEventoAutenticacao < 0 then begin
          Result := CodEventoAutenticacao;
          Rollback;
          Exit;
        end;
      finally
        IntEventos.Free;
      end;

      // Associa animais que utilizam os códigos SISBOV da faixa ao evento
      // de Autenticação SISBOV gerado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_animal_evento ( ' +
          '  cod_pessoa_produtor ' +
          '  , cod_evento ' +
          '  , cod_animal ' +
          '  , ind_animal_castrado ' +
          '  , cod_regime_alimentar ' +
          '  , cod_categoria_animal ' +
          '  , cod_tipo_lugar ' +
          '  , cod_lote_corrente ' +
          '  , cod_local_corrente ' +
          '  , cod_fazenda_corrente ' +
          '  , num_imovel_corrente ' +
          '  , cod_localizacao_corrente ' +
          '  , cod_propriedade_corrente ' +
          '  , num_cnpj_cpf_corrente ' +
          '  , cod_pessoa_corrente ' +
          '  , cod_pessoa_secundaria_corrente ' +
          '  , qtd_peso_animal ' +
          '  , ind_apto_cobertura ' +
          '  , ind_touro_apto ' +
          '  , ind_vaca_prenha ' +
          '  , dta_desativacao ' +
          '  , dta_ultimo_evento ' +
          '  , dta_aplicacao_ultimo_evento ' +
          '  , cod_animal_associado ' +
          '  , dta_aplicacao_evento ' +
          '  , txt_dados ' +
          '  , cod_arquivo_sisbov ' +
          '  , cod_arquivo_sisbov_log ' +
          ') ' +
          'select ' +
          '  cod_pessoa_produtor ' +
          '  , :cod_evento_autenticacao as cod_evento ' +
          '  , cod_animal ' +
          '  , ind_animal_castrado ' +
          '  , cod_regime_alimentar ' +
          '  , cod_categoria_animal ' +
          '  , cod_tipo_lugar ' +
          '  , cod_lote_corrente ' +
          '  , cod_local_corrente ' +
          '  , cod_fazenda_corrente ' +
          '  , num_imovel_corrente ' +
          '  , cod_localizacao_corrente ' +
          '  , cod_propriedade_corrente ' +
          '  , num_cnpj_cpf_corrente ' +
          '  , cod_pessoa_corrente ' +
          '  , cod_pessoa_secundaria_corrente ' +
          '  , null as qtd_peso_animal ' +
          '  , ind_apto_cobertura ' +
          '  , null as ind_touro_apto ' +
          '  , null as ind_vaca_prenha ' +
          '  , dta_desativacao ' +
          '  , dta_ultimo_evento ' +
          '  , dta_aplicacao_ultimo_evento ' +
          '  , null as cod_animal_associado ' +
          '  , getdate() as dta_aplicacao_evento ' +
          '  , null as txt_dados ' +
          '  , null as cod_arquivo_sisbov ' +
          '  , null as cod_arquivo_sisbov_log ' +
          'from ' +
          '  tab_animal ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_arquivo_sisbov is not null ' +
          '  and dta_fim_validade is null ';
{$ENDIF}
      Q.ParamByName('cod_evento_autenticacao').AsInteger := CodEventoAutenticacao;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1931, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1931;
        Rollback;
        Exit;
      end;

      // Atualiza a quantidade de animais do evento
      Q.Close;
      Q.SQL.Text:=
{$IFDEF MSSQL}
        'update ' +
        '  tab_evento ' +
        'set ' +
        '  qtd_animais = :qtd_animais ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento_autenticacao ';
{$ENDIF}
      Q.ParamByName('qtd_animais').AsInteger := QtdCodigo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento_autenticacao').AsInteger := CodEventoAutenticacao;
      Q.ExecSQL;

      // Armazena situação atual dos códigos que estão sendo autenticados
      // novamente
      if bGerarHistoricoAutenticacao then begin
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_historico_autenticacao ( ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_autenticacao ' +
          '  , dta_autenticacao ' +
          '  , cod_evento_autenticacao ' +
          '  , dta_liberacao_abate ' +
          '  , ind_data_liberacao_estimada ' +
          ') ' +
          'select ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_autenticacao ' +
          '  , dta_autenticacao ' +
          '  , cod_evento_autenticacao ' +
          '  , dta_liberacao_abate ' +
          '  , ind_data_liberacao_estimada ' +
          'from ' +
          '  tab_codigo_sisbov ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_propriedade_rural = :cod_propriedade_rural ' +
          '  and qtd_vezes_autenticacao is not null ';
{$ENDIF}
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.ExecSQL;
      end;

      // Altera os códigos SISBOV correspondentes a operação
      Q.Close;
      if DtaLiberacaoAbate > 0 then begin
        // Quando a data de liberação para abate foi informada
        IndDtaAbateEstimada := 'N';
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_autenticacao = getdate() ' +
          '  , cod_evento_autenticacao = :cod_evento_autenticacao ' +
          '  , qtd_vezes_autenticacao = ISNULL(qtd_vezes_autenticacao, 0) + 1 ' +
          '  , dta_liberacao_abate = :dta_liberacao_abate ' +
          '  , ind_data_liberacao_estimada = ''N'' ' +
          '  , cod_situacao_codigo_sisbov = case cod_situacao_codigo_sisbov when :cod_situacao_ident then :cod_situacao_aut else cod_situacao_codigo_sisbov end ' +
          '  , cod_usuario_mudanca = case cod_situacao_codigo_sisbov when :cod_situacao_ident then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
          '  , dta_mudanca_situacao = case cod_situacao_codigo_sisbov when :cod_situacao_ident then getdate() else dta_mudanca_situacao end ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ParamByName('dta_liberacao_abate').AsDateTime := DtaLiberacaoAbate;
      end else begin
        // Quando a data de liberação para abate deve ser estimada, realiza
        // o cálculo a partir da data de exportação do animal para o SISBOV
        // acrescida da quantidade de dias determinada para emissão de
        // certificado (quarentena)
        IndDtaAbateEstimada := 'S';
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_autenticacao = getdate() ' +
          '  , cod_evento_autenticacao = :cod_evento_autenticacao ' +
          '  , qtd_vezes_autenticacao = ISNULL(qtd_vezes_autenticacao, 0) + 1 ' +
          '  , dta_liberacao_abate = isnull(tas.dta_insercao_sisbov, tas.dta_criacao_arquivo) + :num_dias_espera ' +
          '  , ind_data_liberacao_estimada = ''S'' ' +
          '  , cod_situacao_codigo_sisbov = case cod_situacao_codigo_sisbov when :cod_situacao_ident then :cod_situacao_aut else cod_situacao_codigo_sisbov end ' +
          '  , cod_usuario_mudanca = case cod_situacao_codigo_sisbov when :cod_situacao_ident then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
          '  , dta_mudanca_situacao = case cod_situacao_codigo_sisbov when :cod_situacao_ident then getdate() else dta_mudanca_situacao end ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'from ' +
          '  tab_arquivo_sisbov tas ' +
          '  , tab_animal ta ' +
          'where ' +
          '  tas.cod_arquivo_sisbov = ta.cod_arquivo_sisbov ' +
          '  and ta.cod_pais_sisbov = tab_codigo_sisbov.cod_pais_sisbov ' +
          '  and ta.cod_estado_sisbov = tab_codigo_sisbov.cod_estado_sisbov ' +
          '  and ta.cod_micro_regiao_sisbov = tab_codigo_sisbov.cod_micro_regiao_sisbov ' +
          '  and ta.cod_animal_sisbov = tab_codigo_sisbov.cod_animal_sisbov ' +
          '  and ta.cod_pessoa_produtor = tab_codigo_sisbov.cod_pessoa_produtor ' +
          '  and tab_codigo_sisbov.cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and tab_codigo_sisbov.cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and tab_codigo_sisbov.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and tab_codigo_sisbov.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and tab_codigo_sisbov.cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and tab_codigo_sisbov.cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ParamByName('num_dias_espera').AsInteger := NumDiasEspera;
      end;
      Q.ParamByName('cod_evento_autenticacao').AsInteger := CodEventoAutenticacao;
      Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
      Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1974, Self.ClassName, NomMetodo, [sCodSISBOVInicio, sCodSISBOVFim]);
        Result := -1974;
        Rollback;
        Exit;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      if CodOrdemServico > 0 then begin
        if IndDtaAbateEstimada = 'S' then begin
          Q.Close;
          Q.SQL.Text :=
            'select ' +
            '  min(dta_liberacao_abate) as dta_liberacao_abate_inicio ' +
            '  , max(dta_liberacao_abate) as dta_liberacao_abate_fim ' +
            'from ' +
            '  tab_codigo_sisbov tcs ' +
            'where ' +
            '  tcs.cod_pais_sisbov = :cod_pais_sisbov ' +
            '  and tcs.cod_estado_sisbov = :cod_estado_sisbov ' +
            '  and tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
            '  and tcs.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
            '  and tcs.cod_pessoa_produtor = :cod_pessoa_produtor ' +
            '  and tcs.cod_propriedade_rural = :cod_propriedade_rural ';
          Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
          Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
          Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
          Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
          Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
          Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          Q.Open;
          DtaLiberacaoAbateInicio := Q.FieldByName('dta_liberacao_abate_inicio').AsDateTime;
          DtaLiberacaoAbateFim := Q.FieldByName('dta_liberacao_abate_fim').AsDateTime;
          Q.Close;
        end else begin
          DtaLiberacaoAbateInicio := DtaLiberacaoAbate;
          DtaLiberacaoAbateFim := 0;
        end;

        try
          FIntOrdensServico.MudarSituacaoParaAut(Conexao, Mensagens,
            CodOrdemServico, CodPaisSISBOV, CodEstadoSISBOV,
            CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
            CodAnimalSISBOVFim, NumDVSISBOVFim, QtdCodigo,
            DtaLiberacaoAbateInicio, DtaLiberacaoAbateFim, IndDtaAbateEstimada);
        except
          on E: EHerdomexception do begin
            Rollback;
            E.GerarMensagem(Mensagens);
            Result := -E.CodigoErro;
            Exit;
          end;
        end;
      end;

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(QtdCodigo)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.ProcessarEnvioCertificado(CodOrdemServico,
      NumRemessaFicha: Integer; DtaEnvio: TDateTime; NomServicoEnvio,
      NumConhecimento: String): Integer;
const
  CodMetodo: Integer = 584;
  NomMetodo: String = 'ProcessarEnvioCertificado';
var
  Q: THerdomQuery;
  IntEventos: TIntEventos;
  bGerarHistoricoEnvioCertificado: Boolean;
  QtdCodigo,
  CodEventoEnvioCertificado,
  CodPessoaProdutor: Integer;
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

  if CodOrdemServico = -1 then
  begin
    Mensagens.Adicionar(2049, Self.ClassName, NomMetodo, []);
    Result := -2049;
    Exit;
  end;

  if NumRemessaFicha = -1 then
  begin
    Mensagens.Adicionar(2050, Self.ClassName, NomMetodo, []);
    Result := -2050;
    Exit;
  end;

  // Verifica se a data de envio do certificado é válida.
  if DtaEnvio = 0 then
  begin
    DtaEnvio := DateOf(now);
  end;
  if DateOf(DtaEnvio) > DateOf(Now) then
  begin
    Mensagens.Adicionar(2001, Self.ClassName, NomMetodo, []);
    Result := -2001;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , count(distinct isnull(cod_ordem_servico, 0)) as qtd_ordem_servico ' +
        '  , sum(case isnull(dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) as qtd_codigo_utilizado ' +
        '  , sum(case isnull(dta_envio_certificado, 0) when 0 then 0 else 1 end) as qtd_codigo_certificado ' +
        '  , sum(case when cod_situacao_codigo_sisbov in (2, 3, 4, 5, 6, 7, 9, 10, 11) then 1 else 0 end) as qtd_situacao_codigo ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_ordem_servico, 0)) as cod_ordem_servico ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        ' cod_ordem_servico = :cod_ordem_servico ' +
        ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}

      Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      Q.Open;

      CodPessoaProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;

      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodOrdemServico := Q.FieldByName('cod_ordem_servico').AsInteger;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1927, Self.ClassName, NomMetodo, []);
        Result := -1927;
        Exit;
      end;
      if (Q.FieldByName('qtd_ordem_servico').AsInteger <> 1) then begin
        Mensagens.Adicionar(1943, Self.ClassName, NomMetodo, []);
        Result := -1943;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_utilizado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1928, Self.ClassName, NomMetodo, []);
        Result := -1928;
        Exit;
      end;

      bGerarHistoricoEnvioCertificado := (Q.FieldByName('qtd_codigo_certificado').AsInteger <> 0);
      if (Q.FieldByName('qtd_situacao_codigo').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1937, Self.ClassName, NomMetodo, []);
        Result := -1937;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Insere evento de autenticação
      IntEventos := TIntEventos.Create;
      try
        if IntEventos.Inicializar(Conexao, Mensagens) < 0 then begin
          Rollback;
          Exit;
        end;

        CodEventoEnvioCertificado := IntEventos.InserirEnvioCertificado(
           CodPessoaProdutor, NomServicoEnvio, NumConhecimento);

        if CodEventoEnvioCertificado < 0 then begin
          Result := CodEventoEnvioCertificado;
          Rollback;
          Exit;
        end;
      finally
        IntEventos.Free;
      end;

      // Associa animais que utilizam os códigos SISBOV da faixa ao evento
      // de Autenticação SISBOV gerado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_animal_evento ( ' +
          '  cod_pessoa_produtor ' +
          '  , cod_evento ' +
          '  , cod_animal ' +
          '  , ind_animal_castrado ' +
          '  , cod_regime_alimentar ' +
          '  , cod_categoria_animal ' +
          '  , cod_tipo_lugar ' +
          '  , cod_lote_corrente ' +
          '  , cod_local_corrente ' +
          '  , cod_fazenda_corrente ' +
          '  , num_imovel_corrente ' +
          '  , cod_localizacao_corrente ' +
          '  , cod_propriedade_corrente ' +
          '  , num_cnpj_cpf_corrente ' +
          '  , cod_pessoa_corrente ' +
          '  , cod_pessoa_secundaria_corrente ' +
          '  , qtd_peso_animal ' +
          '  , ind_apto_cobertura ' +
          '  , ind_touro_apto ' +
          '  , ind_vaca_prenha ' +
          '  , dta_desativacao ' +
          '  , dta_ultimo_evento ' +
          '  , dta_aplicacao_ultimo_evento ' +
          '  , cod_animal_associado ' +
          '  , dta_aplicacao_evento ' +
          '  , txt_dados ' +
          '  , cod_arquivo_sisbov ' +
          '  , cod_arquivo_sisbov_log ' +
          ') ' +
          'select ' +
          '  ta.cod_pessoa_produtor ' +
          '  , :cod_evento_envio_certificado as cod_evento ' +
          '  , ta.cod_animal ' +
          '  , ta.ind_animal_castrado ' +
          '  , ta.cod_regime_alimentar ' +
          '  , ta.cod_categoria_animal ' +
          '  , ta.cod_tipo_lugar ' +
          '  , ta.cod_lote_corrente ' +
          '  , ta.cod_local_corrente ' +
          '  , ta.cod_fazenda_corrente ' +
          '  , ta.num_imovel_corrente ' +
          '  , ta.cod_localizacao_corrente ' +
          '  , ta.cod_propriedade_corrente ' +
          '  , ta.num_cnpj_cpf_corrente ' +
          '  , ta.cod_pessoa_corrente ' +
          '  , ta.cod_pessoa_secundaria_corrente ' +
          '  , null as qtd_peso_animal ' +
          '  , ta.ind_apto_cobertura ' +
          '  , null as ind_touro_apto ' +
          '  , null as ind_vaca_prenha ' +
          '  , ta.dta_desativacao ' +
          '  , ta.dta_ultimo_evento ' +
          '  , ta.dta_aplicacao_ultimo_evento ' +
          '  , null as cod_animal_associado ' +
          '  , getdate() as dta_aplicacao_evento ' +
          '  , null as txt_dados ' +
          '  , null as cod_arquivo_sisbov ' +
          '  , null as cod_arquivo_sisbov_log ' +
          'from ' +
          '  tab_animal ta, ' +
          '  tab_codigo_sisbov tcs ' +
          'where ' +
        ' tcs.cod_pais_sisbov = ta.cod_pais_sisbov ' +
        ' and tcs.cod_estado_sisbov = ta.cod_estado_sisbov ' +
        ' and tcs.cod_micro_regiao_sisbov = ta.cod_micro_regiao_sisbov ' +
        ' and tcs.cod_animal_sisbov = ta.cod_animal_sisbov ' +
        ' and tcs.cod_ordem_servico = :cod_ordem_servico ' +
        ' and tcs.num_remessa_ficha = :num_remessa_ficha ' +
        ' and ta.cod_pessoa_produtor = :cod_pessoa_produtor ' +
        ' and ta.cod_arquivo_sisbov is not null ' +
        ' and ta.dta_fim_validade is null ';
{$ENDIF}
      Q.ParamByName('cod_ordem_servico').AsInteger            := CodOrdemServico;
      Q.ParamByName('cod_pessoa_produtor').AsInteger          := CodPessoaProdutor;
      Q.ParamByName('num_remessa_ficha').AsInteger            := NumRemessaFicha;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1938, Self.ClassName, NomMetodo, []);
        Result := -1938;
        Rollback;
        Exit;
      end;

      // Atualiza a quantidade de animais do evento
      Q.Close;
      Q.SQL.Text:=
{$IFDEF MSSQL}
        'update ' +
        '  tab_evento ' +
        'set ' +
        '  qtd_animais = :qtd_animais ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento_envio_certificado ';
{$ENDIF}
      Q.ParamByName('qtd_animais').AsInteger := QtdCodigo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ExecSQL;

      // Armazena situação atual dos códigos que estão sendo enviados novamente
      if bGerarHistoricoEnvioCertificado then begin
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_historico_env_certificado ( ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_envio_certificado ' +
          '  , dta_envio_certificado ' +
          '  , cod_evento_envio_certificado ' +
          ') ' +
          'select ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_envio_certificado ' +
          '  , dta_envio_certificado ' +
          '  , cod_evento_envio_certificado ' +
          'from ' +
          '  tab_codigo_sisbov ' +
          'where ' +
          '  cod_ordem_servico = :cod_ordem_servico ' +
          '  and num_remessa_ficha = :num_remessa_ficha ' +
          '  and qtd_vezes_envio_certificado is not null ';
{$ENDIF}
        Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Q.ExecSQL;
      end;

      // Altera os códigos SISBOV correspondentes a operação
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'update ' +
        '  tab_codigo_sisbov ' +
        'set ' +
        '  dta_envio_certificado = :dta_envio_certificado ' +
        '  , cod_evento_envio_certificado = :cod_evento_envio_certificado ' +
        '  , qtd_vezes_envio_certificado = ISNULL(qtd_vezes_envio_certificado, 0) + 1 ' +
        '  , cod_situacao_codigo_sisbov = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut ) then :cod_situacao_cert else cod_situacao_codigo_sisbov end ' +
        '  , cod_usuario_mudanca = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut ) then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
        '  , dta_mudanca_situacao = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut ) then getdate() else dta_mudanca_situacao end ' +
        '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
        '  , dta_ultima_alteracao = getdate() ' +
        'where ' +
        ' cod_ordem_servico = :cod_ordem_servico ' +
        ' and num_remessa_ficha = :num_remessa_ficha ';
{$ENDIF}
      Q.ParamByName('dta_envio_certificado').AsDateTime := DtaEnvio;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
      Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
      Q.ParamByName('cod_situacao_cert').AsInteger := CERT;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q.ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1932, Self.ClassName, NomMetodo, []);
        Result := -1932;
        Rollback;
        Exit;
      end;

      // Gera o histórico das faixas atualizadas.
      with Q do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');

            if CodOrdemServico > 0 then begin
              try
                FIntOrdensServico.MudarSituacaoParaCert(Conexao, Mensagens,
                  CodOrdemServico, FieldByName('cod_pais_sisbov').AsInteger,
                  FieldByName('cod_micro_regiao_sisbov').AsInteger,
                  FieldByName('cod_micro_regiao_sisbov').AsInteger,
                  FieldByName('CodAnimalSISBOVInicio').AsInteger,
                  0, FieldByName('CodAnimalSISBOVFim').AsInteger,
                  0, QtdCodigo, 0, '', '');
              except
                on E: EHerdomexception do begin
                  Rollback;
                  E.GerarMensagem(Mensagens);
                  Result := -E.CodigoErro;
                  Exit;
                end;
              end;
            end;
          Next;
        end;
      end;

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{ Altera o código da Ordem de Serviço de uma faixa de códigos SISBOV.

Parametros:
  CodPaisSisbov: Código SISBOV do pais
  CodEstadoSisbov: Código SISBOV do estado
  CodMicroRegiaoSisbov: Código SISBOV da micro região
  CodAnimalSisbovInicial: Código SISBOV inicial do animal
  CodAnimalSisbovFinal: Código SISBOV final do animal
  CodOrdemServico: Código da Ordem de Serviço

Retorno:
  Sem retorno.

Excessões:
  Retorna uma EHerdomexception ou uma exception em caso de erro.}
procedure TIntCodigosSisbov.AlterarOrdemServico(CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbovInicial,
  CodAnimalSisbovFinal, CodOrdemServico: Integer);
const
  NomeMetodo: String = 'AlterarOrdemServico';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        // Atualiza o STATUS do código SISBOV
        SQL.Clear;
        SQL.Add('update tab_codigo_sisbov');
        SQL.Add('   set cod_ordem_servico = :cod_ordem_servico,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate()');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   and cod_animal_sisbov between :cod_animal_sisbov_inicial');
        SQL.Add('                             and :cod_animal_sisbov_final');

        AtribuiParametro(QueryLocal, CodOrdemServico, 'cod_ordem_servico', -1);
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
        ParamByName('cod_animal_sisbov_inicial').AsInteger := CodAnimalSisbovInicial;
        ParamByName('cod_animal_sisbov_final').AsInteger := CodAnimalSisbovFinal;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        ExecSQL;
      end;

      InserirHistorico(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
        CodAnimalSisbovInicial, CodAnimalSisbovFinal, 'N');
    finally
      QueryLocal.Free;
    end;
  except
    // Lança a excessão para que o proximo método trate o erro.
    raise;
  end;
end;

{ Limpa o código da Ordem de Serviço de uma faixa de códigos SISBOV.

Parametros:
  CodOrdemServico: Código da Ordem de Serviço dos códigos que devem ser limpados.

Retorno:
  Sem retorno.

Excessões:
  Retorna uma EHerdomexception ou uma exception em caso de erro.}
procedure TIntCodigosSisbov.LimparOrdemServicoCodigos(
  CodOrdemServico: Integer);
var
  CodPaisSisbov,
  CodEstadoSisbov,
  CodMicroRegiaoSisbov,
  CodAnimalSisbovInicial,
  CodAnimalSisbovFinal: Integer;
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem os códigos SISBOV para gravar o histórico
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select max(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       max(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       max(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       min(cod_animal_sisbov) as cod_animal_sisbov_inicial,');
        SQL.Add('       max(cod_animal_sisbov) as cod_animal_sisbov_final');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        CodPaisSisbov := FieldByName('cod_pais_sisbov').AsInteger;
        CodEstadoSisbov := FieldByName('cod_estado_sisbov').AsInteger;
        CodMicroRegiaoSisbov := FieldByName('cod_micro_regiao_sisbov').AsInteger;
        CodAnimalSisbovInicial := FieldByName('cod_animal_sisbov_inicial').AsInteger;
        CodAnimalSisbovFinal := FieldByName('cod_animal_sisbov_final').AsInteger;
      end;

      // Limpa o código SISBOV dos códigos SISBOV
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('update tab_codigo_sisbov');
        SQL.Add('   set cod_ordem_servico = NULL');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;

        ExecSQL;
      end;

      InserirHistorico(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
        CodAnimalSisbovInicial, CodAnimalSisbovFinal, 'N');
    finally
      QueryLocal.Free;
    end;
  except
    // Lança a excessão para que o proximo método trate o erro.
    raise;
  end;
end;

{ Valida se a faixa de códigos SISBOV informada é válida. Ou seja, verifica se
  os códigos da faixa pertencem à mesma OS, se os códigos ainda não foram
  recebidos (dta_recebimento_ficha <> NULL) e se a quantidade de códigos
  na base corresponde à quantidade da faixa.

Parâmetros:
  CodPaisSISBOV: Códigos SISBOV do pais
  CodEstadoSISBOV: Código SISBOV do estado
  CodMicroRegiaoSISBOV: Código SISBOV da Micro Região
  CodAnimalSISBOVInicio: Código SISBOV do animal inicial da faixa
  CodAnimalSISBOVFim: Código SISBOV do animal final da faixa
  CodOrdemServico: Parâmetro de retorno. Código da Ordem de serviço dos
    códigos SISBOV.

Retorno:
  = 0 se estiver tudo OK.
  < 0 se ocorrer algum erro ou se a faixa de códigos for inválida.}
function TIntCodigosSisbov.ValidaFaixaRemessa(CodPaisSISBOV,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
  CodAnimalSISBOVFim: Integer; var CodOrdemServico: Integer): Integer;
const
  NomeMetodo: String = 'ValidaFaixaRemessa';
var
  QtdCodigos: Integer;
  StrCodigoI, StrCodigoF: String;
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT count(cod_animal_sisbov) AS QtdCodigos');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   AND cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   AND cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   AND cod_animal_sisbov BETWEEN :cod_animal_sisbov_inicio');
        SQL.Add('                             AND :cod_animal_sisbov_fim');

        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
        Open;

        // Verifica se algum dos códigos está sendo utilizado
        if FieldByName('QtdCodigos').AsInteger <> CodAnimalSISBOVFim
          - CodAnimalSISBOVInicio + 1 then
        begin
          StrCodigoI := StrZero(CodPaisSISBOV, 3) + ' ' + StrZero(CodEstadoSISBOV, 2);
          if CodMicroRegiaoSISBOV > -1 then
          begin
            StrCodigoI := StrCodigoI + ' ' + StrZero(CodMicroRegiaoSISBOV, 2);
          end;
          StrCodigoF := StrCodigoI;

          StrCodigoI := StrCodigoI + ' ' + StrZero(CodAnimalSISBOVInicio, 9);
          StrCodigoF := StrCodigoF + ' ' + StrZero(CodAnimalSISBOVFim, 9);

          Mensagens.Adicionar(2069, Self.ClassName, NomeMetodo,
            [StrCodigoI, StrCodigoF]);
          Result := -2069;
          Exit;
        end;
      end;

      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       count(cod_animal_sisbov) AS QtdCodigos');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   AND cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   AND cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   AND cod_animal_sisbov BETWEEN :cod_animal_sisbov_inicio');
        SQL.Add('                             AND :cod_animal_sisbov_fim');
        SQL.Add('   AND dta_recebimento_ficha is NULL');
        SQL.Add('GROUP BY cod_ordem_servico');

        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
        Open;

        QtdCodigos := FieldByName('QtdCodigos').AsInteger;
        // Obtem o código da OS para retornar
        CodOrdemServico := FieldByName('cod_ordem_servico').AsInteger;

        Next;
        { Se a query não estiver no fim do ResultSet significa que os códigos
          estão associados a mais de uma OS }
        if not Eof then
        begin
          StrCodigoI := StrZero(CodPaisSISBOV, 3) + ' ' + StrZero(CodEstadoSISBOV, 2);
          if CodMicroRegiaoSISBOV > -1 then
          begin
            StrCodigoI := StrCodigoI + ' ' + StrZero(CodMicroRegiaoSISBOV, 2);
          end;
          StrCodigoF := StrCodigoI;

          StrCodigoI := StrCodigoI + ' ' + StrZero(CodAnimalSISBOVInicio, 9);
          StrCodigoF := StrCodigoF + ' ' + StrZero(CodAnimalSISBOVFim, 9);

          Mensagens.Adicionar(2032, Self.ClassName, NomeMetodo,
            [StrCodigoI, StrCodigoF]);
          Result := -2032;
          Exit;
        end;

        // Verifica se algum dos códigos está sendo utilizado
        if QtdCodigos <> CodAnimalSISBOVFim
          - CodAnimalSISBOVInicio + 1 then
        begin
          StrCodigoI := StrZero(CodPaisSISBOV, 3) + ' ' + StrZero(CodEstadoSISBOV, 2);
          if CodMicroRegiaoSISBOV > -1 then
          begin
            StrCodigoI := StrCodigoI + ' ' + StrZero(CodMicroRegiaoSISBOV, 2);
          end;
          StrCodigoF := StrCodigoI;

          StrCodigoI := StrCodigoI + ' ' + StrZero(CodAnimalSISBOVInicio, 9);
          StrCodigoF := StrCodigoF + ' ' + StrZero(CodAnimalSISBOVFim, 9);

          Mensagens.Adicionar(2033, Self.ClassName, NomeMetodo,
            [StrCodigoI, StrCodigoF]);
          Result := -2033;
          Exit;
        end;

        { Se o código da ordem de serviço for null (0) significa que os códigos
          não estão associados a nenhuma OS}
        if CodOrdemServico = 0 then
        begin
          StrCodigoI := StrZero(CodPaisSISBOV, 3) + ' ' + StrZero(CodEstadoSISBOV, 2);
          if CodMicroRegiaoSISBOV > -1 then
          begin
            StrCodigoI := StrCodigoI + ' ' + StrZero(CodMicroRegiaoSISBOV, 2);
          end;
          StrCodigoF := StrCodigoI;

          StrCodigoI := StrCodigoI + ' ' + StrZero(CodAnimalSISBOVInicio, 9);
          StrCodigoF := StrCodigoF + ' ' + StrZero(CodAnimalSISBOVFim, 9);

          Mensagens.Adicionar(2031, Self.ClassName, NomeMetodo,
            [StrCodigoI, StrCodigoF]);
          Result := -2031;
          Exit;
        end;
      end;
    finally
      QueryLocal.Free;
    end;
    Result := 0;
  except
    on E: exception do
    begin
      Mensagens.Adicionar(2053, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2053;
    end;
  end;
end;

function TIntCodigosSisbov.SeparaFaixasCodigos(CodAnimaisSISBOVInicio,
  CodAnimaisSISBOVFim: String; var FaixasCodigos: array of TFaixaCodigos;
  var QtdFaixas: Integer): Integer;
const
  NomeMetodo: String = 'SeparaFaixasCodigos';
var
  StrCodigo: String;
  CountInicio, CountFim, I: Integer;
begin
  try
    // Conta a quantidade de registros nas strings
    CountInicio := 0;
    CountFim    := 0;
    for I := 1 to Length(CodAnimaisSISBOVInicio) do
    begin
      if CodAnimaisSISBOVInicio[I] = ',' then
      begin
        Inc(CountInicio);
      end;
    end;
    for I := 1 to Length(CodAnimaisSISBOVFim) do
    begin
      if CodAnimaisSISBOVFim[I] = ',' then
      begin
        Inc(CountFim);
      end;
    end;

    // a quantidade de registros devem ser iguais
    if CountInicio <> CountFim then
    begin
      Mensagens.Adicionar(2039, Self.ClassName, NomeMetodo, []);
      Result := -2039;
      Exit;
    end;

    while Trim(CodAnimaisSISBOVInicio) <> '' do
    begin
      StrCodigo := ObtemProximoValor(CodAnimaisSISBOVInicio);
      FaixasCodigos[QtdFaixas].CodAnimalSISBOVInicio := StrToInt(Trim(StrCodigo));
      StrCodigo := ObtemProximoValor(CodAnimaisSISBOVFim);
      FaixasCodigos[QtdFaixas].CodAnimalSISBOVFim := StrToInt(Trim(StrCodigo));

      // Verifica se o código SISBOV final é maior que o final
      if FaixasCodigos[QtdFaixas].CodAnimalSISBOVInicio >
        FaixasCodigos[QtdFaixas].CodAnimalSISBOVFim then
      begin
        Mensagens.Adicionar(2035, Self.ClassName, NomeMetodo, []);
        Result := -2035;
        Exit;
      end;

      Inc(QtdFaixas);
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Mensagens.Adicionar(2034, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2034;
    end;
  end;
end;

{ Recebe uma string com valores separados por virgula (,) e retorna o primeiro
  valor. O valor retornado é removido da string passada como argumento.

Parametros:
  Valor: String multivalorada. 

Retorno:
  String contendo o primeiro valor da string.}
function TIntCodigosSisbov.ObtemProximoValor(var Valor: String): String;
var
  Posicao: Integer;
begin
  Result := '';

  // Procura pelo delimitador
  Posicao := Pos(',', Valor);

  // Se o encontrar então obtem o valor e o remove da string
  if Posicao > 0 then
  begin
    Result := Trim(Copy(Valor, 1, Posicao - 1));
    Valor := Copy(Valor, Posicao + 1, Length(Valor));
  end
  else if Valor <> '' then // Se não encontrar obtem a string inteira
  begin
    Result := Trim(Valor);
    Valor := '';
  end;
end;

{ Valida as faixas de códigos SISBOV informadas e atualiza os registros se
  todas as faixas forem válidas.

Parametros:
  DtaRecebimentoFicha: Data em que as fichas foram recebidas
  CodPaisSISBOV: Códigos SISBOV do pais
  CodEstadoSISBOV: Código SISBOV do estado
  CodMicroRegiaoSISBOV: Código SISBOV da Micro Região
  CodAnimaisSISBOVInicio: Códigos SISBOV do animal iniciais das faixas
    separados por virgula (,)
  CodAnimaisSISBOVFim: Códigos SISBOV do animal finais das faixas
    separados por virgula (,)
  CodOrdemServico: Parâmetro de retorno. Se o processamento for executado com
    sucesso esta parâmetro irá conter o código da ordem de serviços dos códigos.
  NumRemessaFicha: Parâmetro de retorno. Se o processamento for executado com
    sucesso esta parâmetro irá conter o número da remessa gerada.

Retorno:
  = 0 se o processamento for concluido com sucesso
  < 0 se ocorrer algum erro ou alguma das faixas for inválida}
function TIntCodigosSisbov.ProcessarRecebimentoFichas(
  DtaRecebimentoFicha: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV: Integer; CodAnimaisSISBOVInicio,
  CodAnimaisSISBOVFim: String): Integer;
const
  NomeMetodo: String = 'ProcessarRecebimentoFichas';
  CodMetodo: Integer = 605;
var
  FaixasCodigos: array [0..50] of TFaixaCodigos;
  QtdFaixas,
  CodPais,
  CodEstado,
  I,
  J,
  NumDvInicioI,
  NumDvFimI,
  NumDvInicioJ,
  NumDvFimJ,
  CodOrdemServicoTmp: Integer;
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Valida os parametros multivalor
  CodAnimaisSISBOVInicio := Trim(CodAnimaisSISBOVInicio);
  if CodAnimaisSISBOVInicio = '' then
  begin
    Mensagens.Adicionar(437, Self.ClassName, NomeMetodo, ['CodAnimaisSISBOVInicio']);
    Result := -437;
    Exit;
  end;
  CodAnimaisSISBOVFim := Trim(CodAnimaisSISBOVFim);
  if CodAnimaisSISBOVFim = '' then
  begin
    Mensagens.Adicionar(437, Self.ClassName, NomeMetodo, ['CodAnimaisSISBOVFim']);
    Result := -437;
    Exit;
  end;

  // Valida e obtem as faixas de códigos SISBOV
  QtdFaixas := 0;
  Result := SeparaFaixasCodigos(CodAnimaisSISBOVInicio, CodAnimaisSISBOVFim,
    FaixasCodigos, QtdFaixas);
  if Result < 0 then
  begin
    Exit;
  end;

  // Verifica se a data de recebimento é válida
  if DateOf(DtaRecebimentoFicha) = 0 then
  begin
    Mensagens.Adicionar(2068, Self.ClassName, NomeMetodo, []);
    Result := -2068;
    Exit;
  end;
  if DateOf(DtaRecebimentoFicha) > DateOf(Now) then
  begin
    Mensagens.Adicionar(2036, Self.ClassName, NomeMetodo, []);
    Result := -2036;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Consiste se o país sisbov informado corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_pais ');
        SQL.Add('  from tab_pais ');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
        SQL.Add('   and dta_fim_validade is null ');
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(297, Self.ClassName, NomeMetodo, [IntToStr(CodPaisSisbov)]);
          Result := -297;
          Exit;
        end;

        CodPais := FieldByName('cod_pais').AsInteger;
      end;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_estado ');
        SQL.Add('  from tab_estado ');
        SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
        SQL.Add('   and cod_pais = :cod_pais ');
        SQL.Add('   and dta_fim_validade is null ');
        ParamByName('cod_pais').AsInteger := CodPais;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(298, Self.ClassName, NomeMetodo, [IntToStr(CodEstadoSisbov)]);
          Result := -298;
          Exit;
        end;

        CodEstado := FieldByName('cod_estado').AsInteger;
      end;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_micro_regiao ');
        SQL.Add('  from tab_micro_regiao ');
        SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
        SQL.Add('   and dta_fim_validade is null ');
        SQL.Add('   and cod_estado = :cod_estado ');
        ParamByName('cod_estado').AsInteger := CodEstado;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(299, Self.ClassName, NomeMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
          Result := -299;
          Exit;
        end;
      end;

      // Valida as faixas e obtem a OS dos códigos SISBOV
      FCodOrdemServico := 0;
      for I := 0 to QtdFaixas - 1 do
      begin
        if FaixasCodigos[I].CodAnimalSISBOVInicio > 0 then
        begin
          Result := ValidaFaixaRemessa(CodPaisSISBOV, CodEstadoSISBOV,
            CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVInicio,
            FaixasCodigos[I].CodAnimalSISBOVFim, CodOrdemServicoTmp);
          if Result < 0 then
          begin
            Exit;
          end;

          // Se for a primeira execução então obtem o códigos da OS
          if FCodOrdemServico = 0 then
          begin
            FCodOrdemServico := CodOrdemServicoTmp;
          end
          else if FCodOrdemServico <> CodOrdemServicoTmp then
          begin // Se o código da OS for diferente do código da OS do restante
            // então exibe uma mensaem de erro
            Mensagens.Adicionar(2038, Self.ClassName, NomeMetodo, []);
            Result := -2038;
            Exit;
          end;

          // Verifica se existe uma intersecção entre as faixas
          for J := I + 1 to QtdFaixas - 1 do
          begin
            if FaixasCodigos[J].CodAnimalSISBOVInicio > 0 then
            begin
              { A primeira validação verifiva se o ponto inicial do J
                esta dentro da faixa I. A segunda validação verifica se o ponto
                final do J esta dentro da faixa I e a terceira validação verifica
                se a faixa I esta dentro da faixa J.}
              if ((FaixasCodigos[I].CodAnimalSISBOVInicio <= FaixasCodigos[J].CodAnimalSISBOVInicio)
                  and (FaixasCodigos[I].CodAnimalSISBOVFim >= FaixasCodigos[J].CodAnimalSISBOVInicio))
                or ((FaixasCodigos[I].CodAnimalSISBOVInicio <= FaixasCodigos[J].CodAnimalSISBOVFim)
                  and (FaixasCodigos[I].CodAnimalSISBOVFim >= FaixasCodigos[J].CodAnimalSISBOVFim))
                or ((FaixasCodigos[I].CodAnimalSISBOVInicio >= FaixasCodigos[J].CodAnimalSISBOVInicio)
                  and (FaixasCodigos[I].CodAnimalSISBOVFim <= FaixasCodigos[J].CodAnimalSISBOVFim)) then
              begin
                NumDvInicioI := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVInicio);
                NumDvFimI := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVFim);
                NumDvInicioJ := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[J].CodAnimalSISBOVInicio);
                NumDvFimJ := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[J].CodAnimalSISBOVFim);

                Mensagens.Adicionar(2040, Self.ClassName, NomeMetodo, [
                  FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVInicio, NumDvInicioI),
                  FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVFim, NumDvFimI),
                  FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[J].CodAnimalSISBOVInicio, NumDvInicioJ),
                  FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
                  CodMicroRegiaoSISBOV, FaixasCodigos[J].CodAnimalSISBOVFim, NumDvFimJ)]);
                Result := -2040;
                Exit;
              end;
            end;
          end;
        end;
      end;

      // Obtem o número da remessa
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select max(IsNull(num_remessa_ficha, 0)) + 1 as NumRemessaFicha');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        ParamByName('cod_ordem_servico').AsInteger := FCodOrdemServico;
        Open;

        FNumRemessaFicha := FieldByName('NumRemessaFicha').AsInteger;
      end;

      beginTran;

      // Insere as faixas
      for I := 0 to QtdFaixas - 1 do
      begin
        if FaixasCodigos[I].CodAnimalSISBOVInicio > 0 then
        begin
          { Atualiza o número da remessa, a sequencia da faixa, a data de
            recebimento da remessa e se a situação do código for DISP então
            atualiza a situação para REC}
          with QueryLocal do
          begin
            SQL.Clear;
            SQL.Add('UPDATE tab_codigo_sisbov');
            SQL.Add('   SET num_remessa_ficha = :num_remessa_ficha,');
            SQL.Add('       seq_faixa_remessa = :seq_faixa_remessa,');
            SQL.Add('       dta_recebimento_ficha = :dta_recebimento_ficha,');
            SQL.Add('       cod_situacao_codigo_sisbov = ');
            SQL.Add('         CASE cod_situacao_codigo_sisbov');
            SQL.Add('           WHEN :cod_situacao_disp then :cod_situacao_codigo_sisbov');
            SQL.Add('           ELSE cod_situacao_codigo_sisbov END,');
            SQL.Add('       dta_mudanca_situacao =');
            SQL.Add('         CASE cod_situacao_codigo_sisbov ');
            SQL.Add('           WHEN :cod_situacao_disp THEN getDate()');
            SQL.Add('           ELSE dta_mudanca_situacao END,');
            SQL.Add('       cod_usuario_mudanca =');
            SQL.Add('         CASE cod_situacao_codigo_sisbov ');
            SQL.Add('           WHEN :cod_situacao_disp THEN :cod_usuario_mudanca');
            SQL.Add('           ELSE cod_usuario_mudanca END,');
            SQL.Add('       dta_ultima_alteracao = getdate(),');
            SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
            SQL.Add(' WHERE cod_pais_sisbov = :cod_pais_sisbov');
            SQL.Add('   AND cod_estado_sisbov = :cod_estado_sisbov');
            SQL.Add('   AND cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
            SQL.Add('   AND cod_animal_sisbov BETWEEN :cod_animal_sisbov_inicio');
            SQL.Add('                             AND :cod_animal_sisbov_fim');

            ParamByName('num_remessa_ficha').AsInteger := FNumRemessaFicha;
            ParamByName('seq_faixa_remessa').AsInteger := I + 1;
            ParamByName('dta_recebimento_ficha').AsDateTime := DateOf(DtaRecebimentoFicha);
            ParamByName('cod_situacao_disp').AsInteger := DISP;
            ParamByName('cod_situacao_codigo_sisbov').AsInteger := REC;
            ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
            ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
            ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
            ParamByName('cod_animal_sisbov_inicio').AsInteger := FaixasCodigos[I].CodAnimalSISBOVInicio;
            ParamByName('cod_animal_sisbov_fim').AsInteger := FaixasCodigos[I].CodAnimalSISBOVFim;
            ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
            ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;

            // Verifica se a quantidade de registro atualizados está correta
            if ExecSQL <> FaixasCodigos[I].CodAnimalSISBOVFim
              - FaixasCodigos[I].CodAnimalSISBOVInicio + 1 then
            begin
              raise exception.Create('A quantidade de registros atualizada é'
                + ' diferente do total da faixa de códigos SISBOV.');
            end;

            InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV,
              CodMicroRegiaoSISBOV, FaixasCodigos[I].CodAnimalSISBOVInicio,
              FaixasCodigos[I].CodAnimalSISBOVFim, 'N');
          end;
        end;
      end;
      
      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Conexao.Rollback;
      Mensagens.Adicionar(2053, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2053;
    end;
  end;
end;

{ Valida s faixa de código SISBOV informada e atualiza os registros da faixa.

Parametros:
  CodOrdemServico: Código da ordem de serviços dos códigos.
  NumRemessaFicha: Número da remessa que a faixa deve ser inserida.
  CodPaisSISBOV: Códigos SISBOV do pais
  CodEstadoSISBOV: Código SISBOV do estado
  CodMicroRegiaoSISBOV: Código SISBOV da Micro Região
  CodAnimalSISBOVInicio: Códigos SISBOV do animal iniciaal
  CodAnimalSISBOVFim: Códigos SISBOV do animal final

Retorno:
  = 0 se o processamento for concluido com sucesso
  < 0 se ocorrer algum erro ou se a faixa for inválida}
function TIntCodigosSisbov.AdicionarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOVInicio, CodAnimalSISBOVFim: Integer): Integer;
const
  NomeMetodo: String = 'AdicionarFaixaRecebimento';
  CodMetodo: Integer = 606;
var
  CodPais,
  CodEstado,
  CodOrdemServicoTmp,
  SeqFaixaRemessa: Integer;
  DtaRecebimentoFicha: TDateTime;
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se o código SISBOV final é maior que o final
  if CodAnimalSISBOVInicio >
    CodAnimalSISBOVFim then
  begin
    Mensagens.Adicionar(2035, Self.ClassName, NomeMetodo, []);
    Result := -2035;
    Exit;
  end;

  if CodOrdemServico = -1 then
  begin
    Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
    Result := -2049;
    Exit;
  end;

  if NumRemessaFicha = -1 then
  begin
    Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
    Result := -2050;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Consiste se o país sisbov informado corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_pais ');
        SQL.Add('  from tab_pais ');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
        SQL.Add('   and dta_fim_validade is null ');
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(297, Self.ClassName, NomeMetodo, [IntToStr(CodPaisSisbov)]);
          Result := -297;
          Exit;
        end;

        CodPais := FieldByName('cod_pais').AsInteger;
      end;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_estado ');
        SQL.Add('  from tab_estado ');
        SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
        SQL.Add('   and cod_pais = :cod_pais ');
        SQL.Add('   and dta_fim_validade is null ');
        ParamByName('cod_pais').AsInteger := CodPais;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(298, Self.ClassName, NomeMetodo, [IntToStr(CodEstadoSisbov)]);
          Result := -298;
          Exit;
        end;

        CodEstado := FieldByName('cod_estado').AsInteger;
      end;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_micro_regiao ');
        SQL.Add('  from tab_micro_regiao ');
        SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
        SQL.Add('   and dta_fim_validade is null ');
        SQL.Add('   and cod_estado = :cod_estado ');
        ParamByName('cod_estado').AsInteger := CodEstado;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(299, Self.ClassName, NomeMetodo, [IntToStr(CodMicroRegiaoSISBOV)]);
          Result := -299;
          Exit;
        end;
      end;

      // Valida as faixas e obtem a OS dos códigos SISBOV
      Result := ValidaFaixaRemessa(CodPaisSISBOV, CodEstadoSISBOV,
        CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
        CodAnimalSISBOVFim, CodOrdemServicoTmp);
      if Result < 0 then
      begin
        Exit;
      end;

      if CodOrdemServico <> CodOrdemServicoTmp then
      begin // Se o código da OS for diferente do código da OS do restante
        // então exibe uma mensaem de erro
        Mensagens.Adicionar(2038, Self.ClassName, NomeMetodo, []);
        Result := -2038;
        Exit;
      end;

      // Obtem a data de recebimento da remessa
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select max(dta_recebimento_ficha) as dta_recebimento_ficha,');
        SQL.Add('       max(dta_aprovacao_ficha) as dta_aprovacao_ficha,');
        SQL.Add('       max(dta_impressao_certificado) as dta_impressao_certificado,');
        SQL.Add('       max(seq_faixa_remessa) + 1 as SeqFaixaRemessa');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   and num_remessa_ficha = :num_remessa_ficha');
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a ficha já foi aprovada
        if FieldByName('dta_aprovacao_ficha').AsDateTime <> 0 then
        begin
          Mensagens.Adicionar(2042, Self.ClassName, NomeMetodo, []);
          Result := -2042;
          Exit;
        end;

        // Verifica se o certificado já foi impresso
        if FieldByName('dta_impressao_certificado').AsDateTime <> 0 then
        begin
          Mensagens.Adicionar(2043, Self.ClassName, NomeMetodo, []);
          Result := -2043;
          Exit;
        end;

        DtaRecebimentoFicha := FieldByName('dta_recebimento_ficha').AsDateTime;
        SeqFaixaRemessa := FieldByName('SeqFaixaRemessa').AsInteger;

        // Verifica se a remessa existe
        if SeqFaixaRemessa = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;
      end;

      beginTran;

      { Insere s faixa.
        Atualiza o número da remessa, a sequencia da faixa, a data de
        recebimento da remessa e se a situação do código for DISP então
        atualiza a situação para REC}
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET num_remessa_ficha = :num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa = :seq_faixa_remessa,');
        SQL.Add('       dta_recebimento_ficha = :dta_recebimento_ficha,');
        SQL.Add('       cod_situacao_codigo_sisbov = ');
        SQL.Add('         CASE cod_situacao_codigo_sisbov');
        SQL.Add('           WHEN :cod_situacao_disp then :cod_situacao_codigo_sisbov');
        SQL.Add('           ELSE cod_situacao_codigo_sisbov END,');
        SQL.Add('       dta_mudanca_situacao =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_disp THEN getDate()');
        SQL.Add('           ELSE dta_mudanca_situacao END,');
        SQL.Add('       cod_usuario_mudanca =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_disp THEN :cod_usuario_mudanca');
        SQL.Add('           ELSE cod_usuario_mudanca END,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   AND cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   AND cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   AND cod_animal_sisbov BETWEEN :cod_animal_sisbov_inicio');
        SQL.Add('                             AND :cod_animal_sisbov_fim');

        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('seq_faixa_remessa').AsInteger := SeqFaixaRemessa;
        ParamByName('dta_recebimento_ficha').AsDateTime := DateOf(DtaRecebimentoFicha);
        ParamByName('cod_situacao_disp').AsInteger := DISP;
        ParamByName('cod_situacao_codigo_sisbov').AsInteger := REC;
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;

        // Verifica se a quantidade de registro atualizados está correta
        if ExecSQL <> CodAnimalSISBOVFim
          - CodAnimalSISBOVInicio + 1 then
        begin
          raise exception.Create('A quantidade de registros atualizada é'
            + ' diferente do total da faixa de códigos SISBOV.');
        end;

        InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV,
          CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
          CodAnimalSISBOVFim, 'N');
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Conexao.Rollback;
      Mensagens.Adicionar(2053, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2053;
    end;
  end;
end;

function TIntCodigosSisbov.PesquisarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'PesquisarFaixaRecebimento';
  CodMetodo: Integer = 607;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Clear;
{$IFDEF MSSQL}
      SQL.Add('select tcs.cod_ordem_servico as CodOrdemServico,');
      SQL.Add('       tos.num_ordem_servico as NumOrdemServico,');
      SQL.Add('       tpp.sgl_produtor as SglProdutor,');
      SQL.Add('       tp.nom_pessoa as NomPessoa,');
      SQL.Add('       case tp.cod_natureza_pessoa');
      SQL.Add('         when ''F'' then convert(varchar(18),');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2))');
      SQL.Add('         when ''J'' then convert(varchar(18),');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2))');
      SQL.Add('       end as NumCNPJCPFFormatado,');
      SQL.Add('       tpr.nom_propriedade_rural as NomPropriedadeRural,');
      SQL.Add('       tpr.num_imovel_receita_federal as NumImovelReceitaFederal,');
      SQL.Add('       tcs.num_remessa_ficha as NumRemessaFicha,');
      SQL.Add('       tcs.seq_faixa_remessa as SeqFaixaRemessa,');
      SQL.Add('       max(tcs.dta_recebimento_ficha) AS DtaRecebimentoFicha,');
      SQL.Add('       tls.cod_localizacao_sisbov as CodLocalizacaoSisbov,');      
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE tcs.cod_pais_sisbov');
      SQL.Add('       END AS CodPaisSISBOV,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE tcs.cod_estado_sisbov');
      SQL.Add('       END AS CodEstadoSISBOV,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE tcs.cod_micro_regiao_sisbov');
      SQL.Add('       END AS CodMicroRegiaoSISBOV,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE MIN(tcs.cod_animal_sisbov)');
      SQL.Add('       END AS CodAnimalSISBOVInicio,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE dbo.fnt_calcula_num_dv_sisbov(tcs.cod_pais_sisbov, tcs.cod_estado_sisbov, tcs.cod_micro_regiao_sisbov, MIN(tcs.cod_animal_sisbov))');
      SQL.Add('       END AS NumDVSISBOVInicio,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE MAX(tcs.cod_animal_sisbov)');
      SQL.Add('       END AS CodAnimalSISBOVFim,');
      SQL.Add('       CASE IsNull(tcs.num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE dbo.fnt_calcula_num_dv_sisbov(tcs.cod_pais_sisbov, tcs.cod_estado_sisbov, tcs.cod_micro_regiao_sisbov, MAX(tcs.cod_animal_sisbov))');
      SQL.Add('       END AS NumDVSISBOVFim');
      SQL.Add('  from tab_codigo_sisbov tcs,');
      SQL.Add('       tab_ordem_servico tos,');
      SQL.Add('       tab_produtor tpp,');
      SQL.Add('       tab_pessoa tp,');
      SQL.Add('       tab_propriedade_rural tpr,');
      SQL.Add('       tab_localizacao_sisbov tls');
      SQL.Add(' where tcs.cod_ordem_servico = tos.cod_ordem_servico');
      SQL.Add('   and tcs.cod_pessoa_produtor = tpp.cod_pessoa_produtor');
      SQL.Add('   and tcs.cod_pessoa_produtor = tp.cod_pessoa');
      SQL.Add('   and tcs.cod_propriedade_rural = tpr.cod_propriedade_rural');
      SQL.Add('   and tls.cod_propriedade_rural = tpr.cod_propriedade_rural');
      SQL.Add('   and tls.cod_pessoa_produtor = tp.cod_pessoa');      
      if CodOrdemServico > -1 then
      begin
        SQL.Add('   and tcs.cod_ordem_servico = :cod_ordem_servico');
      end;
      if NumRemessaFicha > -1 then
      begin
        SQL.Add('   and tcs.num_remessa_ficha = :num_remessa_ficha');
      end
      else
      begin
        SQL.Add('   and tcs.num_remessa_ficha is not null');
      end;
      SQL.Add('group by tcs.cod_ordem_servico,');
      SQL.Add('       tos.num_ordem_servico,');
      SQL.Add('       tcs.num_remessa_ficha,');
      SQL.Add('       tcs.seq_faixa_remessa,');
      SQL.Add('       tpp.sgl_produtor,');
      SQL.Add('       tp.nom_pessoa,');
      SQL.Add('       tp.cod_natureza_pessoa,');
      SQL.Add('       tp.num_cnpj_cpf,');
      SQL.Add('       tpr.nom_propriedade_rural,');
      SQL.Add('       tpr.num_imovel_receita_federal,');
      SQL.Add('       tls.cod_localizacao_sisbov,');
      SQL.Add('       tcs.cod_pais_sisbov,');
      SQL.Add('       tcs.cod_estado_sisbov,');
      SQL.Add('       tcs.cod_micro_regiao_sisbov');
{$ENDIF}

      if CodOrdemServico > -1 then
      begin
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      end;
      if NumRemessaFicha > -1 then
      begin
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      end;

      Open;

      if IsEmpty then
      begin
        Mensagens.Adicionar(2054, Self.ClassName, NomeMetodo, []);
        Result := -2054;
        Exit;
      end;

    end;

    Result := 0;
  except
    on E: exception do
    begin
      Conexao.Rollback;
      Mensagens.Adicionar(2044, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2044;
    end;
  end;
end;

{ Exclui uma faixa de códigos SISBOV da remessa. Para remover a faixa a remessa
  não podeter estar aprovada ou com os certificados impressos.

Parâmetros:
  CodOrdemServico: Código da ordem de serviço da remessa.
  NumRemessaFicha: Número da remessa da ficha.
  SeqFaixaRemessa: Sequencial da faixa a ser removida. Este parametro é opcional,
    se não for informado toda a remssa será excluída.

Retorno:
  = 0 se ocorrer algum erro
  < 0 se algo der errado}
function TIntCodigosSisbov.RetirarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha, SeqFaixaRemessa: Integer): Integer;
const
  NomeMetodo: String = 'RetirarFaixaRecebimento';
  CodMetodo: Integer = 608;
var
  FaixasCodigos: array [0..50] of TFaixaCodigos;
  QtdFaixas,
  CodPaisSISBOV,
  CodEstadoSISBOV,
  CodMicroRegiaoSISBOV,
  I,
  NumOrdemServico: Integer;
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  if CodOrdemServico = -1 then
  begin
    Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
    Result := -2049;
    Exit;
  end;

  if NumRemessaFicha = -1 then
  begin
    Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
    Result := -2050;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem a data de recebimento da remessa
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select max(dta_recebimento_ficha) as dta_recebimento_ficha,');
        SQL.Add('       max(dta_aprovacao_ficha) as dta_aprovacao_ficha,');
        SQL.Add('       max(dta_impressao_certificado) as dta_impressao_certificado,');
        SQL.Add('       max(seq_faixa_remessa) + 1 as SeqFaixaRemessa');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   and num_remessa_ficha = :num_remessa_ficha');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a remessa existe para a OS
        if FieldByName('dta_recebimento_ficha').AsDateTime = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;

        // Verifica se a ficha já foi aprovada
        if FieldByName('dta_aprovacao_ficha').AsDateTime <> 0 then
        begin
          Mensagens.Adicionar(2045, Self.ClassName, NomeMetodo, []);
          Result := -2045;
          Exit;
        end;

        // Verifica se o certificado já foi impresso
        if FieldByName('dta_impressao_certificado').AsDateTime <> 0 then
        begin
          Mensagens.Adicionar(2046, Self.ClassName, NomeMetodo, []);
          Result := -2046;
          Exit;
        end;
      end;

      // Obtem as faicas de códigos a serem atualizadas para gerar o histórico
      QtdFaixas := 0;
      CodPaisSISBOV := 0;
      CodEstadoSISBOV := 0;
      CodMicroRegiaoSISBOV := 0;
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        if SeqFaixaRemessa > -1 then
        begin
          SQL.Add('   AND seq_faixa_remessa = :seq_faixa_remessa');
        end;
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        if SeqFaixaRemessa > -1 then
        begin
          ParamByName('seq_faixa_remessa').AsInteger := SeqFaixaRemessa;
        end;
        Open;

        while not EOF do
        begin
          CodPaisSISBOV := FieldByName('cod_pais_sisbov').AsInteger;
          CodEstadoSISBOV := FieldByName('cod_estado_sisbov').AsInteger;
          CodMicroRegiaoSISBOV := FieldByName('cod_micro_regiao_sisbov').AsInteger;
          FaixasCodigos[QtdFaixas].CodAnimalSISBOVInicio := FieldByName('CodAnimalSISBOVInicio').AsInteger;
          FaixasCodigos[QtdFaixas].CodAnimalSISBOVFim := FieldByName('CodAnimalSISBOVFim').AsInteger;
          Inc(QtdFaixas);
          Next;
        end;
      end;

      // Busca o número da OS para ser utlizado caso a remessa seja excluída
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT num_ordem_servico');
        SQL.Add('  FROM tab_ordem_servico');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        NumOrdemServico := FieldByName('num_ordem_servico').AsInteger;
      end;

      beginTran;

      { Remove a faixa.
        Atualiza o número da remessa, a sequencia da faixa, a data de
        recebimento da remessa e se a situação do código for REC então
        atualiza a situação para DISP}
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET num_remessa_ficha = NULL,');
        SQL.Add('       seq_faixa_remessa = NULL,');
        SQL.Add('       dta_recebimento_ficha = NULL,');
        SQL.Add('       cod_situacao_codigo_sisbov = ');
        SQL.Add('         CASE cod_situacao_codigo_sisbov');
        SQL.Add('           WHEN :cod_situacao_rec then :cod_situacao_codigo_sisbov');
        SQL.Add('           ELSE cod_situacao_codigo_sisbov END,');
        SQL.Add('       dta_mudanca_situacao =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_rec THEN getDate()');
        SQL.Add('           ELSE dta_mudanca_situacao END,');
        SQL.Add('       cod_usuario_mudanca =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_rec THEN :cod_usuario_mudanca');
        SQL.Add('           ELSE cod_usuario_mudanca END,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   and num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}
        if SeqFaixaRemessa > -1 then
        begin
          SQL.Add('   and seq_faixa_remessa = :seq_faixa_remessa');
        end;

        ParamByName('cod_situacao_rec').AsInteger := REC;
        ParamByName('cod_situacao_codigo_sisbov').AsInteger := DISP;
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;

        if SeqFaixaRemessa > -1 then
        begin
          ParamByName('seq_faixa_remessa').AsInteger := SeqFaixaRemessa;
        end;

        if ExecSQL = 0 then
        begin
          Rollback;
          Mensagens.Adicionar(2052, Self.ClassName, NomeMetodo, []);
          Result := -2052;
          Exit;
        end;
      end;

      for I := 0 to QtdFaixas - 1 do
      begin
        InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
          FaixasCodigos[I].CodAnimalSISBOVInicio,
          FaixasCodigos[I].CodAnimalSISBOVFim, 'N');
      end;

      Commit;
      Result := 0;

      // Verifica se a remessa foi excluída
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select 1');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   and num_remessa_ficha = :num_remessa_ficha');
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        // Se a remessa foi excluida então exibe uma mensagem para avisar
        // o usuário
        if isEmpty then
        begin
          Mensagens.Adicionar(2048, Self.ClassName, NomeMetodo,
            [IntToStr(NumRemessaFicha), IntToStr(NumOrdemServico)]);
          Result := 1;
        end;
      end;

    finally
      QueryLocal.Free;
    end;
  except
    on E: exception do
    begin
      Conexao.Rollback;
      Mensagens.Adicionar(2047, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2047;
    end;
  end;
end;

function TIntCodigosSisbov.ProcessarAprovacaoFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'ProcessarAprovacaoFichas';
  CodMetodo: Integer = 609;
var
  QueryLocal: THerdomQuery;
  QtdCodigos: Integer;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    if CodOrdemServico = -1 then
    begin
      Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
      Result := -2049;
      Exit;
    end;

    if NumRemessaFicha = -1 then
    begin
      Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
      Result := -2050;
      Exit;
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica se a remessa de fichasé válida
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT SUM(CASE IsNull(dta_aprovacao_ficha, 0) WHEN 0 THEN 0 ELSE 1 END) AS QtdFicasAprovadas,');
        SQL.Add('       COUNT(cod_animal_sisbov) AS QtdCodigosRemessa');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a remessa existe
        QtdCodigos := FieldByName('QtdCodigosRemessa').AsInteger;
        if QtdCodigos = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;

        // Verifica se nenhum códigos está aprovado
        if FieldByName('QtdFicasAprovadas').AsInteger <> 0 then
        begin
          Mensagens.Adicionar(2057, Self.ClassName, NomeMetodo, []);
          Result := -2057;
          Exit;
        end;
      end;

      beginTran;

      // Atualiza os registros
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET dta_aprovacao_ficha = :dta_aprovacao_ficha,');
        SQL.Add('       cod_situacao_codigo_sisbov =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_rec THEN :cod_situacao_aprov');
        SQL.Add('           ELSE cod_situacao_codigo_sisbov END,');
        SQL.Add('       dta_mudanca_situacao =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_rec THEN getDate()');
        SQL.Add('           ELSE dta_mudanca_situacao END,');
        SQL.Add('       cod_usuario_mudanca =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_rec THEN :cod_usuario_mudanca');
        SQL.Add('           ELSE cod_usuario_mudanca END,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('cod_situacao_rec').AsInteger := REC;
        ParamByName('cod_situacao_aprov').AsInteger := APROV;
        ParamByName('dta_aprovacao_ficha').AsDateTime := DateOf(Now);
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;

        if ExecSQL <> QtdCodigos then
        begin
          raise exception.Create('A quantidade de registros atualizada é'
            + ' diferente do total da faixa de códigos SISBOV.');
        end;
      end;

      // Gera o histórico das faixas atualizadas.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');
          Next;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(2058, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2058;
    end;
  end;
end;

function TIntCodigosSisbov.CancelarAprovacaoFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'CancelarAprovacaoFichas';
  CodMetodo: Integer = 610;
var
  QueryLocal: THerdomQuery;
  QtdCodigos: Integer;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    if CodOrdemServico = -1 then
    begin
      Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
      Result := -2049;
      Exit;
    end;

    if NumRemessaFicha = -1 then
    begin
      Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
      Result := -2050;
      Exit;
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica se a remessa de fichasé válida
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT SUM(CASE IsNull(dta_aprovacao_ficha, 0) WHEN 0 THEN 1 ELSE 0 END) AS QtdFicasAprovadas,');
        SQL.Add('       COUNT(cod_animal_sisbov) AS QtdCodigosRemessa');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a remessa existe
        QtdCodigos := FieldByName('QtdCodigosRemessa').AsInteger;
        if QtdCodigos = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;

        // Verifica se nenhum códigos está aprovado
        if FieldByName('QtdFicasAprovadas').AsInteger <> 0 then
        begin
          Mensagens.Adicionar(2059, Self.ClassName, NomeMetodo, []);
          Result := -2059;
          Exit;
        end;
      end;

      beginTran;

      // Atualiza os registros
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET dta_aprovacao_ficha = NULL,');
        SQL.Add('       cod_situacao_codigo_sisbov =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_aprov THEN :cod_situacao_rec');
        SQL.Add('           ELSE cod_situacao_codigo_sisbov END,');
        SQL.Add('       dta_mudanca_situacao =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_aprov THEN getDate()');
        SQL.Add('           ELSE dta_mudanca_situacao END,');
        SQL.Add('       cod_usuario_mudanca =');
        SQL.Add('         CASE cod_situacao_codigo_sisbov ');
        SQL.Add('           WHEN :cod_situacao_aprov THEN :cod_usuario_mudanca');
        SQL.Add('           ELSE cod_usuario_mudanca END,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('cod_situacao_rec').AsInteger := REC;
        ParamByName('cod_situacao_aprov').AsInteger := APROV;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_usuario_mudanca').AsInteger := Conexao.CodUsuario;


        if ExecSQL <> QtdCodigos then
        begin
          raise exception.Create('A quantidade de registros atualizada é'
            + ' diferente do total da faixa de códigos SISBOV.');
        end;
      end;

      // Gera o histórico das faixas atualizadas.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');
          Next;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(2060, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2060;
    end;
  end;
end;

function TIntCodigosSisbov.ProcessarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'ProcessarImpressaoCertificado';
  CodMetodo: Integer = 611;
var
  QueryLocal: THerdomQuery;
  QtdCodigos: Integer;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    if CodOrdemServico = -1 then
    begin
      Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
      Result := -2049;
      Exit;
    end;

    if NumRemessaFicha = -1 then
    begin
      Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
      Result := -2050;
      Exit;
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select count(1) as qtd_codigo,');
        SQL.Add('       count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov,');
        SQL.Add('       count(distinct isnull(cod_ordem_servico, 0)) as qtd_ordem_servico,');
        SQL.Add('       sum(case isnull(dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) as qtd_codigo_utilizado,');
        SQL.Add('       sum(case when cod_situacao_codigo_sisbov in (2, 3, 4, 5, 6, 7, 9, 10, 11) then 1 else 0 end) as qtd_situacao_codigo,');
        SQL.Add('       max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor,');
        SQL.Add('       max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural,');
        SQL.Add('       max(isnull(cod_ordem_servico, 0)) as cod_ordem_servico');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   and num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        if IsEmpty or (FieldByName('qtd_codigo').AsInteger = 0) then begin
          Mensagens.Adicionar(1913, Self.ClassName, NomeMetodo, []);
          Result := -1913;
          Exit;
        end;
        QtdCodigos := FieldByName('qtd_codigo').AsInteger;
        CodOrdemServico := FieldByName('cod_ordem_servico').AsInteger;
        if (FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
          Mensagens.Adicionar(1927, Self.ClassName, NomeMetodo, []);
          Result := -1927;
          Exit;
        end;
        if (FieldByName('qtd_ordem_servico').AsInteger <> 1) then begin
          Mensagens.Adicionar(1943, Self.ClassName, NomeMetodo, []);
          Result := -1943;
          Exit;
        end;
        if (FieldByName('qtd_codigo_utilizado').AsInteger <> QtdCodigos) then begin
          Mensagens.Adicionar(1928, Self.ClassName, NomeMetodo, []);
          Result := -1928;
          Exit;
        end;
        if (FieldByName('qtd_situacao_codigo').AsInteger <> QtdCodigos) then begin
          Mensagens.Adicionar(1937, Self.ClassName, NomeMetodo, []);
          Result := -1937;
          Exit;
        end;
      end;

      // Verifica se a remessa de fichas é válida
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT COUNT(cod_animal_sisbov) AS QtdCodigosRemessa');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a remessa existe
        QtdCodigos := FieldByName('QtdCodigosRemessa').AsInteger;
        if QtdCodigos = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;
      end;

      beginTran;

      // Atualiza os registros
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET dta_impressao_certificado = :dta_impressao_certificado,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('dta_impressao_certificado').AsDateTime := DateOf(Now);
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        if ExecSQL <> QtdCodigos then
        begin
          raise exception.Create('A quantidade de registros atualizada é'
            + ' diferente do total da faixa de códigos SISBOV.');
        end;
      end;

      // Gera o histórico das faixas atualizadas.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');
          Next;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(2058, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2058;
    end;
  end;
end;

function TIntCodigosSisbov.CancelarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'CancelarImpressaoCertificado';
  CodMetodo: Integer = 612;
var
  QueryLocal: THerdomQuery;
  QtdCodigos: Integer;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    if CodOrdemServico = -1 then
    begin
      Mensagens.Adicionar(2049, Self.ClassName, NomeMetodo, []);
      Result := -2049;
      Exit;
    end;

    if NumRemessaFicha = -1 then
    begin
      Mensagens.Adicionar(2050, Self.ClassName, NomeMetodo, []);
      Result := -2050;
      Exit;
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica se a remessa de fichas é válida
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT SUM(CASE IsNull(dta_impressao_certificado, 0) WHEN 0 THEN 1 ELSE 0 END) AS QtdImpressaoCertificado,');
        SQL.Add('       COUNT(cod_animal_sisbov) AS QtdCodigosRemessa');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
{$ENDIF}

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        // Verifica se a remessa existe
        QtdCodigos := FieldByName('QtdCodigosRemessa').AsInteger;
        if QtdCodigos = 0 then
        begin
          Mensagens.Adicionar(2051, Self.ClassName, NomeMetodo, []);
          Result := -2051;
          Exit;
        end;

        // Verifica se o certificado de nenhum códigos está impresso
        if FieldByName('QtdImpressaoCertificado').AsInteger <> 0 then
        begin
          Mensagens.Adicionar(2061, Self.ClassName, NomeMetodo, []);
          Result := -2061;
          Exit;
        end;
      end;

      beginTran;

      // Atualiza os registros
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_codigo_sisbov');
        SQL.Add('   SET dta_impressao_certificado = NULL,');
        SQL.Add('       dta_ultima_alteracao = getdate(),');
        SQl.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        if ExecSQL <> QtdCodigos then
        begin
          raise exception.Create('A quantidade de registros atualizada é'
            + ' diferente do total da faixa de códigos SISBOV.');
        end;
      end;

      // Gera o histórico das faixas atualizadas.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_ordem_servico,');
        SQL.Add('       num_remessa_ficha,');
        SQL.Add('       seq_faixa_remessa,');
        SQL.Add('       MAX(cod_pais_sisbov) as cod_pais_sisbov,');
        SQL.Add('       MAX(cod_estado_sisbov) as cod_estado_sisbov,');
        SQL.Add('       MAX(cod_micro_regiao_sisbov) as cod_micro_regiao_sisbov,');
        SQL.Add('       MIN(cod_animal_sisbov) as CodAnimalSISBOVInicio,');
        SQL.Add('       MAX(cod_animal_sisbov) as CodAnimalSISBOVFim');
        SQL.Add('  FROM tab_codigo_sisbov');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
        SQL.Add('   AND num_remessa_ficha = :num_remessa_ficha');
        SQL.Add('GROUP BY cod_ordem_servico,');
        SQL.Add('         num_remessa_ficha,');
        SQL.Add('         seq_faixa_remessa');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
        Open;

        while not EOF do
        begin
          InserirHistorico(FieldByName('cod_pais_sisbov').AsInteger,
            FieldByName('cod_estado_sisbov').AsInteger,
            FieldByName('cod_micro_regiao_sisbov').AsInteger,
            FieldByName('CodAnimalSISBOVInicio').AsInteger,
            FieldByName('CodAnimalSISBOVFim').AsInteger, 'N');
          Next;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(2062, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2062;
    end;
  end;
end;

{ Método que faz a carga inicial dos códigos SISBOV. O código SISBOV pode ser
  reservado ou solicitado. Se o código estiver reservado estes dados serão
  utilizados, mesmo tendo os dados da solicitacao. Isto porque alguns códigos
  foram solicitados para uma determinada propriedade e posteriormente
  reservados para um produtor e propriedade.

  Se não houver nem reserva e nem solicitação (caso dos códigos antigos) os
  atributos cod_pessoa_produtor e cod_propriedade_rural devem ser NULL.

  Os dados do produtor e da propriedade são guardados e na proxima execução
  do método, se os dados forem iguais a validação do produtor/propriedade
  não é feita.

Parametros:
  NumSISBOV: Número sisbov no formato: XX = estado, WW = Micro Região (MR)
                                       YYYYYYYYY = Código, Z = Digito Verificador
    Sem MR - 105XXYYYYYYYYYZ
    Com MR - 0XXWWYYYYYYYYYZ
  TipoInscricaoReserva: Indica se o campo TipoInscricaoReserva é NIRF ou INCRA
  NirfIncraReserva: NIRF ou INCRA da fazenda
  CodLocalizacaoSISBOVReserva: Código da tabela tab_localizacao_sisbov
  NaturezaProprietarioReserva: Indica se o produtor é pessoa Física ou Jurídica
  CNPJCPFReserva: CNPJ ou CPF do produtor
  TipoInscricaoSolicitacao: Indica se o campo TipoInscricaoSolicitacao é NIRF ou INCRA
  NirfIncraSolicitacao: NIRF ou INCRA da fazenda
  CodLocalizacaoSISBOVSolicitacao: Código da tabela tab_localizacao_sisbov
  NaturezaProprietarioSolicitacao: Indica se o produtor é pessoa Física ou Jurídica
  CNPJCPFSolicitacao: CNPJ ou CPF do produtor
  NumeroDaSolicitacao: Número da solicitação dos códigos junto ao MAPA
  DtaSolicitacao: Data da solicitação dos códigos junto ao MAPA

exceptins:
  EHerdomexception: caso ocorra algum erro.}
procedure TIntCodigosSisbov.InserirCodigoSISBOVCargaInicial(NumSISBOV,
  NirfIncraReserva, CodLocalizacaoSISBOVReserva, CNPJCPFReserva,
  NirfIncraSolicitacao, CodLocalizacaoSISBOVSolicitacao, CNPJCPFSolicitacao,
  NumeroDaSolicitacao, DtaSolicitacao: String);
const
  NomeMetodo: String = 'InserirCodigoSISBOVCargaInicial';
var
  QueryLocal: THerdomQuery;
  CodProdutor,
  CodPropriedade,
  CodPaisSISBOV,
  CodEstadoSISBOV,
  CodMicroRegiaoSISBOV,
  CodAnimalSISBOV,
  NumDVSISBOV,
  NumSolicitacao,
  CodLocalizacaoSISBOV: Integer;
  NIRFINCRA,
  CNPJCPFProdutor: String;
  DataSolicitacao: TDateTime;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    if Length(Trim(NumSISBOV)) <> 15 then
    begin
      raise exception.Create('O atributo NumSISBOV é inválido.');
    end;
    if not ehNumerico(Trim(NumSISBOV)) then
    begin
      raise exception.Create('O atributo NumSISBOV deve ser numérico.');
    end;
    if Trim(NumSISBOV) = '' then
    begin
      raise exception.Create('O atributo NumSISBOV é obrigatório.');
    end;
    if Length(NirfIncraReserva) > 13 then
    begin
      raise exception.Create('O atributo NirfIncraReserva é inválido.');
    end;
    if Length(CodLocalizacaoSISBOVReserva) > 10 then
    begin
      raise exception.Create('O atributo CodLocalizacaoSISBOVReserva é inválido.');
    end;
    if Length(CNPJCPFReserva) > 14 then
    begin
      raise exception.Create('O atributo CNPJCPFReserva é inválido.');
    end;
    if Length(NirfIncraSolicitacao) > 13 then
    begin
      raise exception.Create('O atributo NirfIncraSolicitacao é inválido.');
    end;
    if Length(CodLocalizacaoSISBOVSolicitacao) > 10 then
    begin
      raise exception.Create('O atributo CodLocalizacaoSISBOVSolicitacao é inválido.');
    end;
    if Length(CNPJCPFSolicitacao) > 14 then
    begin
      raise exception.Create('O atributo CNPJCPFSolicitacao é inválido.');
    end;
    if Length(NumeroDaSolicitacao) > 6 then
    begin
      raise exception.Create('O atributo NumeroDaSolicitacao é inválido.');
    end;
    if Length(DtaSolicitacao) > 8 then
    begin
      raise exception.Create('O atributo DtaSolicitacao é inválido.');
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      CodProdutor := -1;
      CodPropriedade := -1;

      // Obtem o código SISBOV
      try
        CodPaisSISBOV := 105;
        if Copy(NumSISBOV, 1, 1) = '0' then // Com MR
        begin
          CodEstadoSISBOV := StrToInt(Copy(NumSISBOV, 2, 2));
          CodMicroRegiaoSISBOV := StrToInt(Copy(NumSISBOV, 4, 2));
        end
        else
        begin // Sem MR
          CodEstadoSISBOV := StrToInt(Copy(NumSISBOV, 4, 2));
          CodMicroRegiaoSISBOV := -1;
        end;
        CodAnimalSISBOV := StrToInt(Copy(NumSISBOV, 6, 9));
        NumDVSISBOV := StrToInt(Copy(NumSISBOV, 15, 1));
      except
        on E: exception do
        begin
          raise exception.Create('Parametro NumSISBOV("' +
            NumSISBOV + '" inválido: [' + E.Message + ']');
        end;
      end;

      // Prepara a data
      try
        DataSolicitacao := 0;
        if Trim(DtaSolicitacao) <> '' then
        begin
          DataSolicitacao := EncodeDate(
            StrToInt(Copy(DtaSolicitacao, 5, 4)),  // Ano
            StrToInt(Copy(DtaSolicitacao, 3, 2)),  // Mes
            StrToInt(Copy(DtaSolicitacao, 1, 2))); // Dia
        end;
      except
        on E: exception do
        begin
          raise exception.Create('Parametro DtaSolicitacao("' +
            DtaSolicitacao + '" inválido: [' + E.Message + ']');
        end;
      end;

      // Obtem o número da solicitação
      try
        NumSolicitacao := -1;
        if Trim(NumeroDaSolicitacao) <> '' then
        begin
          NumSolicitacao := StrToInt(Trim(NumeroDaSolicitacao));
        end;
      except
        on E: exception do
        begin
          raise exception.Create('Parametro NumeroDaSolicitacao("' +
            NumeroDaSolicitacao + '" inválido: [' + E.Message + ']');
        end;
      end;

      // Obtem o CodLocalizacaoSISBOV. Da preferência para a reserva
      CodLocalizacaoSISBOV := -1;
      if Trim(CodLocalizacaoSISBOVReserva) <> '' then
      begin
        CodLocalizacaoSISBOV := StrToInt(Trim(CodLocalizacaoSISBOVReserva));
        NIRFINCRA := Trim(NirfIncraReserva);
        CNPJCPFProdutor := Trim(CNPJCPFReserva);
      end
      else if Trim(CodLocalizacaoSISBOVSolicitacao) <> '' then
      begin
        CodLocalizacaoSISBOV := StrToInt(Trim(CodLocalizacaoSISBOVSolicitacao));
        NIRFINCRA := Trim(NirfIncraSolicitacao);
        CNPJCPFProdutor := Trim(CNPJCPFSolicitacao);
      end;

      // Obtem o código do produtor e da propriedade
      if CodLocalizacaoSISBOV > 0 then
      begin
        // Se o código da localização SISBOV, o produtor e a propriedade forem os
        // mesmos da ultima execução não realiza as validações
        if (CodLocalizacaoSISBOV <> FCodLocalizacaoSISBOVCI)
          or (FNIRFINCRAPropriedadeCI <> NIRFINCRA)
          or (FCNPJCPFProdutorCI <> CNPJCPFProdutor) then
        begin
          with QueryLocal do
          begin
            SQL.Clear;
            SQL.Add('SELECT tls.cod_pessoa_produtor,');
            SQL.Add('       tls.cod_propriedade_rural');
            SQL.Add('  FROM tab_localizacao_sisbov tls,');
            SQL.Add('       tab_propriedade_rural tpr,');
            SQL.Add('       tab_pessoa tp');
            SQL.Add(' WHERE tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
            SQL.Add('   AND tls.cod_propriedade_rural = tpr.cod_propriedade_rural');
            SQL.Add('   AND tpr.num_imovel_receita_federal = :num_imovel_receita_federal');
            SQL.Add('   AND tp.cod_pessoa = tls.cod_pessoa_produtor');
            SQL.Add('   AND tp.num_cnpj_cpf = :num_cnpj_cpf');
            ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSISBOV;
            ParamByName('num_imovel_receita_federal').AsString := NIRFINCRA;
            ParamByName('num_cnpj_cpf').AsString := CNPJCPFProdutor;

            Open;
            if IsEmpty then
            begin
              raise EHerdomexception.Create(2079, Self.ClassName, NomeMetodo,
                ['Código de localização inexistente na tab_localizacao_sisbov: '
                 + '"' + IntToStr(CodLocalizacaoSISBOV) + '" NIRF: "'
                 + NIRFINCRA + '" CNPJ: "' + CNPJCPFProdutor + '"'], False);
            end;

            CodProdutor := FieldByName('cod_pessoa_produtor').AsInteger;
            CodPropriedade := FieldByName('cod_propriedade_rural').AsInteger;
          end;

          // Verifica se o CNPJ/CPF do produtor esta correto
          with QueryLocal do
          begin
            SQL.Clear;
            SQL.Add('select num_cnpj_cpf');
            SQL.Add('  from tab_pessoa');
            SQL.Add(' where cod_pessoa = :cod_pessoa');
            ParamByName('cod_pessoa').AsInteger := CodProdutor;

            Open;
            if  IsEmpty
              or (FieldByName('num_cnpj_cpf').AsString <> CNPJCPFProdutor) then
            begin
              raise EHerdomexception.Create(2079, Self.ClassName, NomeMetodo,
                ['CNPJ do produtor diferente do produtor da tab_localizacao_sisbov'], False);
            end;
          end;

          // Verifica se o CNPJ/CPF do produtor esta correto
          with QueryLocal do
          begin
            SQL.Clear;
            SQL.Add('select num_imovel_receita_federal');
            SQL.Add('  from tab_propriedade_rural');
            SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural');
            ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;

            Open;
            if IsEmpty
              or (Trim(FieldByName('num_imovel_receita_federal').AsString) <> Trim(NIRFINCRA)) then
            begin
              raise EHerdomexception.Create(2079, Self.ClassName, NomeMetodo,
                ['NIRF/INCRA da propriedade diferente da propriedade da tab_localizacao_sisbov'], False);
            end;
          end;

          // Guarda os valores para comparar na proxima execução
          FCodLocalizacaoSISBOVCI := CodLocalizacaoSISBOV;
          FCodPessoaProdutorCI := CodProdutor;
          FCodPropriedadeRuralCI := CodPropriedade;
          FNIRFINCRAPropriedadeCI := NIRFINCRA;
          FCNPJCPFProdutorCI := CNPJCPFProdutor;
        end
        else
        begin
          CodProdutor := FCodPessoaProdutorCI;
          CodPropriedade := FCodPropriedadeRuralCI;
        end;
      end;

      // Insere o código SISBOV
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('insert into tab_codigo_sisbov (');
        SQL.Add('  cod_pais_sisbov,');
        SQL.Add('  cod_estado_sisbov,');
        SQL.Add('  cod_micro_regiao_sisbov,');
        SQL.Add('  cod_animal_sisbov,');
        SQL.Add('  num_dv_sisbov,');
        SQL.Add('  dta_insercao_registro, ');
        SQL.Add('  cod_pessoa_produtor, ');
        SQL.Add('  cod_propriedade_rural,');
        SQL.Add('  num_solicitacao_sisbov, ');
        SQL.Add('  dta_solicitacao_sisbov, ');
        SQL.Add('  cod_situacao_codigo_sisbov,');
        SQL.Add('  dta_mudanca_situacao,');
        SQL.Add('  cod_usuario_mudanca, ');
        SQL.Add('  cod_usuario_ultima_alteracao, ');
        SQL.Add('  dta_ultima_alteracao');
        SQL.Add(') values ( ');
        SQL.Add('  :cod_pais_sisbov,');
        SQL.Add('  :cod_estado_sisbov,');
        SQL.Add('  :cod_micro_regiao_sisbov,');
        SQL.Add('  :cod_animal_sisbov,');
        SQL.Add('  :num_dv_sisbov,');
        SQL.Add('  :dta_insercao_registro,');
        SQL.Add('  :cod_pessoa_produtor,');
        SQL.Add('  :cod_propriedade_rural,');
        SQL.Add('  :num_solicitacao_sisbov,');
        SQL.Add('  :dta_solicitacao_sisbov,');
        SQL.Add('  1,');
        SQL.Add('  getDate(),');
        SQL.Add('  1,');
        SQL.Add('  1,');
        SQL.Add('  getDate() )');

        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
        ParamByName('num_dv_sisbov').AsInteger := NumDVSISBOV;
        AtribuiParametro(QueryLocal, CodProdutor, 'cod_pessoa_produtor', -1);
        AtribuiParametro(QueryLocal, CodPropriedade, 'cod_propriedade_rural', -1);
        AtribuiParametro(QueryLocal, NumSolicitacao, 'num_solicitacao_sisbov', -1);
        AtribuiParametro(QueryLocal, DataSolicitacao, 'dta_solicitacao_sisbov', 0);
        if DataSolicitacao > 0 then
        begin
          ParamByName('dta_insercao_registro').AsDateTime := DataSolicitacao;
        end
        else
        begin
          ParamByName('dta_insercao_registro').AsDateTime := Now;
        end;

        ExecSQL;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOV, CodAnimalSISBOV, 'N');
    finally
      QueryLocal.Free;
    end;
  except
    on E: EHerdomexception do
    begin
      raise; // Lança a excessão para o método que realizou a chamada
    end;
    on E: exception do
    begin
      raise EHerdomexception.Create(2079, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

function TIntCodigosSisbov.ExcluirEnvioCertificado(
  CodPessoaProdutor: Integer; SglProdutor, NumCNPJCPFProdutor: String;
  CodPropriedadeRural: Integer; NumImovelReceitaFederal: String; CodLocalizacaoSiSbov,
  CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
  CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio,
  NumDVSisBovFim: Integer): Integer;
const
  CodMetodo: Integer = 620;
  NomMetodo: String = 'ExcluirEnvioCertificado';
var
  Q: THerdomQuery;
  bRestaurarEnvioCertificado: Boolean;
  Contador, CodPais, CodEstado, NumDvSISBOV, QtdCodigo,
    CodEventoEnvioCertificado: Integer;
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens, NumImovelReceitaFederal, CodPropriedadeRural,
                                                                                           CodLocalizacaoSiSbov, CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      // Consiste se o país sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, []);
        Result := -299;
        Exit;
      end;

      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(cod_pessoa_produtor, 0)) as qtd_produtor ' +
        '  , count(distinct isnull(cod_propriedade_rural, 0)) as qtd_propriedade_rural ' +
        '  , count(distinct isnull(cod_evento_envio_certificado, 0)) as qtd_evento_envio_certificado ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , sum(case isnull(dta_envio_certificado, 0) when 0 then 0 else 1 end) as qtd_codigo_certificado ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_evento_envio_certificado, 0)) as cod_evento_envio_certificado ' +
        '  , max(isnull(qtd_vezes_envio_certificado, 0)) as qtd_vezes_envio_certificado ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodEventoEnvioCertificado := Q.FieldByName('cod_evento_envio_certificado').AsInteger;
      bRestaurarEnvioCertificado := (Q.FieldByName('qtd_vezes_envio_certificado').AsInteger <> 1);
      if (Q.FieldByName('qtd_produtor').AsInteger <> 1) or (Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor) then begin
        Mensagens.Adicionar(1925, Self.ClassName, NomMetodo, []);
        Result := -1925;
        Exit;
      end;
      if (Q.FieldByName('qtd_propriedade_rural').AsInteger <> 1) or (Q.FieldByName('cod_propriedade_rural').AsInteger <> CodPropriedadeRural) then begin
        Mensagens.Adicionar(1926, Self.ClassName, NomMetodo, []);
        Result := -1926;
        Exit;
      end;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1927, Self.ClassName, NomMetodo, []);
        Result := -1927;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_certificado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1939, Self.ClassName, NomMetodo, []);
        Result := -1939;
        Exit;
      end;
      if (Q.FieldByName('qtd_evento_envio_certificado').AsInteger <> 1) then begin
        Mensagens.Adicionar(1940, Self.ClassName, NomMetodo, []);
        Result := -1940;
        Exit;
      end;

(*
      Alteração permitindo que apenas uma faixa parcial de códigos tenha o
      processamento cancelado.
      // Verifica se todos os códigos referentes ao evento de envio de
      // certificado correspondente são contemplados pela faixa informada
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo_evento ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_propriedade_rural = :cod_propriedade_rural ' +
        '  and cod_evento_envio_certificado = :cod_evento_envio_certificado ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo_evento').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1941, Self.ClassName, NomMetodo, []);
        Result := -1941;
        Exit;
      end;
      Q.Close;
*)

      // Abre transação
      beginTran;

      // Remove animais associados ao evento de autenticação correspondente
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'delete from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ' +
        '  and cod_animal in ( ' +
        '    select ' +
        '      cod_animal ' +
        '    from ' +
        '      tab_animal ' +
        '    where ' +
        '      cod_pais_sisbov = :cod_pais_sisbov ' +
        '      and cod_estado_sisbov = :cod_estado_sisbov ' +
        '      and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '      and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
        '      and cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '      and cod_arquivo_sisbov is not null ' +
        '      and dta_fim_validade is null ' +
        '  ) ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1998, Self.ClassName, NomMetodo, []);
        Result := -1998;
        Rollback;
        Exit;
      end;


      // Verifica se todos os animais associados ao evento foram removido
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  top 1 1 ' +
        'from ' +
        '  tab_animal_evento ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
      Q.Open;
      if Q.IsEmpty then begin
        // Remove evento de correspondente, pois nenhum animal está associado
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete from ' +
          '  tab_evento_envio_certificado ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;

        // Remove evento de correspondente, pois nenhum animal está associado
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete from ' +
          '  tab_evento ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;
      end else begin
        // Atualiza a quantidade de animais associada ao evento
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_evento ' +
          'set ' +
          '  qtd_animais = ( ' +
          '    select ' +
          '      count(cod_animal) ' +
          '    from ' +
          '      tab_animal_evento ' +
          '    where ' +
          '      cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '      and cod_evento = :cod_evento ' +
          '  ) ' +
          'where ' +
          '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_evento = :cod_evento ';
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_evento').AsInteger := CodEventoEnvioCertificado;
        Q.ExecSQL;
      end;

      // Verifica se é necessária a restauração de algum valor
      if bRestaurarEnvioCertificado then begin
        // Restaura último envio de certificado sofrido pela faixa de códigos
        // SISBOV autenticada correspondente
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_envio_certificado = thec.dta_envio_certificado ' +
          '  , cod_evento_envio_certificado = thec.cod_evento_envio_certificado ' +
          '  , qtd_vezes_envio_certificado = thec.qtd_vezes_envio_certificado ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'from ' +
          '  tab_codigo_sisbov tcs ' +
          '  inner join tab_historico_env_certificado thec on ' +
          '    tcs.cod_pais_sisbov = thec.cod_pais_sisbov ' +
          '    and tcs.cod_estado_sisbov = thec.cod_estado_sisbov ' +
          '    and tcs.cod_micro_regiao_sisbov = thec.cod_micro_regiao_sisbov ' +
          '    and tcs.cod_animal_sisbov = thec.cod_animal_sisbov ' +
          '    and tcs.num_dv_sisbov = thec.num_dv_sisbov ' +
          '    and tcs.qtd_vezes_envio_certificado-1 = thec.qtd_vezes_envio_certificado ' +
          'where ' +
          '  tcs.cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and tcs.cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and tcs.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and tcs.cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and tcs.cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      end else begin
        // Altera faixa de códigos SISBOV correspondentes ao envio de certificado
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'update ' +
          '  tab_codigo_sisbov ' +
          'set ' +
          '  dta_envio_certificado = null ' +
          '  , cod_evento_envio_certificado = null ' +
          '  , qtd_vezes_envio_certificado = null ' +
          '  , cod_situacao_codigo_sisbov = ' +
          '    case cod_situacao_codigo_sisbov ' +
          '      when :cod_situacao_cert then ' +
          '        case ' +
          '          when dta_impressao_certificado is not null then ' +
          '            :cod_situacao_impr ' +
          '          when dta_autenticacao is null then ' +
          '            :cod_situacao_ident ' +
          '          else ' +
          '            :cod_situacao_aut ' +
          '        end ' +
          '      else ' +
          '        cod_situacao_codigo_sisbov ' +
          '    end ' +
          '  , cod_usuario_mudanca = case cod_situacao_codigo_sisbov when :cod_situacao_cert then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
          '  , dta_mudanca_situacao = case cod_situacao_codigo_sisbov when :cod_situacao_cert then getdate() else dta_mudanca_situacao end ' +
          '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
          '  , dta_ultima_alteracao = getdate() ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ParamByName('cod_situacao_cert').AsInteger := CERT;
        Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
        Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
        Q.ParamByName('cod_situacao_impr').AsInteger := IMPR;
      end;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1932, Self.ClassName, NomMetodo, []);
        Result := -1932;
        Rollback;
        Exit;
      end;

      // Remove do histórico de envio de certificados correspondente a faixa de
      // envio de certificados restaurada
      if bRestaurarEnvioCertificado then begin
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'delete tab_historico_env_certificado ' +
          'from ' +
          '  tab_historico_env_certificado thec ' +
          '  inner join tab_codigo_sisbov tcs on ' +
          '    thec.cod_pais_sisbov = tcs.cod_pais_sisbov ' +
          '    and thec.cod_estado_sisbov = tcs.cod_estado_sisbov ' +
          '    and thec.cod_micro_regiao_sisbov = tcs.cod_micro_regiao_sisbov ' +
          '    and thec.cod_animal_sisbov = tcs.cod_animal_sisbov ' +
          '    and thec.num_dv_sisbov = tcs.num_dv_sisbov ' +
          '    and thec.qtd_vezes_envio_certificado = tcs.qtd_vezes_envio_certificado ' +
          'where ' +
          '  tcs.cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and tcs.cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and tcs.cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and tcs.cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and tcs.cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
        Q.ExecSQL;
        if Q.RowsAffected <> QtdCodigo then begin
          Mensagens.Adicionar(1997, Self.ClassName, NomMetodo, []);
          Result := -1997;
          Rollback;
          Exit;
        end;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntCodigosSisbov.InserirEnvioCertificado(
  CodPessoaProdutor: Integer; SglProdutor, NumCNPJCPFProdutor: String;
  CodPropriedadeRural: Integer; NumImovelReceitaFederal: String;
  CodLocalizacaoSiSbov: Integer; DtaEnvio: TDateTime; NomServicoEnvio,
  NumConhecimento: String; CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
  CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio,
  NumDVSisBovFim: Integer): Integer;
const
  CodMetodo: Integer = 619;
  NomMetodo: String = 'InserirEnvioCertificado';
var
  Q: THerdomQuery;
  IntEventos: TIntEventos;
  bGerarHistoricoEnvioCertificado: Boolean;
  Contador, CodPais, CodEstado, NumDvSISBOV, QtdCodigo,
  CodEventoEnvioCertificado, CodOrdemServico: Integer;
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

  // Sómente um dos valores CodPessoaProdutor, SglProdutor
  // e NumCNPJCPFProdutor deve ser informando
  Contador := 0;
  if CodPessoaProdutor > -1 then begin
    Inc(Contador);
  end;
  if SglProdutor <> '' then begin
    Inc(Contador);
  end;
  if NumCNPJCPFProdutor <> '' then begin
    Inc(Contador);
  end;
  if Contador <> 1 then begin
    Mensagens.Adicionar(1765, Self.ClassName, NomMetodo, []);
    Result := -1765;
    Exit;
  end;

  // Verifica se a data de envio do certificado é válida.
  if DateOf(DtaEnvio) > DateOf(Now) then
  begin
    Mensagens.Adicionar(2001, Self.ClassName, NomMetodo, []);
    Result := -2001;
    Exit;
  end;

  // Sómente um dos valores CodPropriedadeRural ou
  // NumImovelReceitaFederal deve ser informando
  if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
  begin
    Mensagens.Adicionar(1766, Self.ClassName, NomMetodo, []);
    Result := -1766;
    Exit;
  end;

  // Verifica se o código SISBOV inicial é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  if NumDVSISBOV <> NumDVSISBOVInicio then begin
    Mensagens.Adicionar(1920, Self.ClassName, NomMetodo, []);
    Result := -1920;
    Exit;
  end;

  // Verifica se o código SISBOV final é válido
  NumDVSISBOV := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);
  if NumDVSISBOV <> NumDVSISBOVFim then begin
    Mensagens.Adicionar(1921, Self.ClassName, NomMetodo, []);
    Result := -1921;
    Exit;
  end;

  // Verifica se a faixa informada é válida
  if CodAnimalSISBOVInicio > CodAnimalSISBOVFim then begin
    Mensagens.Adicionar(525, Self.ClassName, NomMetodo, []);
    Result := -525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se o produtor não foi identificado
      if (CodPessoaProdutor < 0) then begin
        CodPessoaProdutor := BuscarProdutor(SglProdutor, NumCNPJCPFProdutor);
        if CodPessoaProdutor < 0 then begin
          Result := CodPessoaProdutor;
          Exit;
        end;
      end;

      // Verifica se a propriedade rural não foi identificada
      if (CodPropriedadeRural < 0) then begin
        CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(Conexao, Mensagens, NumImovelReceitaFederal, CodPropriedadeRural,
                                                                                           CodLocalizacaoSiSbov, CodPessoaProdutor, True);
        if CodPropriedadeRural < 0 then begin
          Result := CodPropriedadeRural;
          Exit;
        end;
      end;

      // Consiste se o país sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(297, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
        Result := -297;
        Exit;
      end;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Consiste se o estado sisbov informado corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_estado ');
      Q.SQL.Add('  from tab_estado ');
      Q.SQL.Add(' where cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(298, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisbov)]);
        Result := -298;
        Exit;
      end;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Consiste se a micro região sisbov informada corresponde a um valor válido
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao ');
      Q.SQL.Add('  from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(299, Self.ClassName, NomMetodo, []);
        Result := -299;
        Exit;
      end;

      // Verifica se a propriedade e produtor já foram exportados para o Sisbov
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1658, Self.ClassName, NomMetodo, []);
        Result := -1658;
        Exit;
      end;

      // Verifica se existem códigos para serem atualizados que correspondam ao
      // intervalo informado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'select ' +
        '  count(1) as qtd_codigo ' +
        '  , count(distinct isnull(cod_pessoa_produtor, 0)) as qtd_produtor ' +
        '  , count(distinct isnull(cod_propriedade_rural, 0)) as qtd_propriedade_rural ' +
        '  , count(distinct isnull(num_solicitacao_sisbov, 0)) as qtd_solicitacao_sisbov ' +
        '  , count(distinct isnull(cod_ordem_servico, 0)) as qtd_ordem_servico ' +
        '  , sum(case isnull(dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) as qtd_codigo_utilizado ' +
        '  , sum(case isnull(dta_envio_certificado, 0) when 0 then 0 else 1 end) as qtd_codigo_certificado ' +
        '  , sum(case when cod_situacao_codigo_sisbov in (2, 3, 4, 5, 6, 7) then 1 else 0 end) as qtd_situacao_codigo ' +
        '  , max(isnull(cod_pessoa_produtor, 0)) as cod_pessoa_produtor ' +
        '  , max(isnull(cod_propriedade_rural, 0)) as cod_propriedade_rural ' +
        '  , max(isnull(cod_ordem_servico, 0)) as cod_ordem_servico ' +
        'from ' +
        '  tab_codigo_sisbov ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ';
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('qtd_codigo').AsInteger = 0) then begin
        Mensagens.Adicionar(1913, Self.ClassName, NomMetodo, []);
        Result := -1913;
        Exit;
      end;
      QtdCodigo := Q.FieldByName('qtd_codigo').AsInteger;
      CodOrdemServico := Q.FieldByName('cod_ordem_servico').AsInteger;
      if (Q.FieldByName('qtd_produtor').AsInteger <> 1) or (Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor) then begin
        Mensagens.Adicionar(1925, Self.ClassName, NomMetodo, []);
        Result := -1925;
        Exit;
      end;
      if (Q.FieldByName('qtd_propriedade_rural').AsInteger <> 1) or (Q.FieldByName('cod_propriedade_rural').AsInteger <> CodPropriedadeRural) then begin
        Mensagens.Adicionar(1926, Self.ClassName, NomMetodo, []);
        Result := -1926;
        Exit;
      end;
      if (Q.FieldByName('qtd_solicitacao_sisbov').AsInteger <> 1) then begin
        Mensagens.Adicionar(1927, Self.ClassName, NomMetodo, []);
        Result := -1927;
        Exit;
      end;
      if (Q.FieldByName('qtd_ordem_servico').AsInteger <> 1) then begin
        Mensagens.Adicionar(1943, Self.ClassName, NomMetodo, []);
        Result := -1943;
        Exit;
      end;
      if (Q.FieldByName('qtd_codigo_utilizado').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1928, Self.ClassName, NomMetodo, []);
        Result := -1928;
        Exit;
      end;
{
      Essa alteração permite que códigos já enviados possam sofrer novo
      envio. Os códigos que já foram enviados terão seus atributos de situação
      armazenados em tabela de histórico para possibilitar posterior
      cancelamento, caso necessário.
      if (Q.FieldByName('qtd_codigo_certificado').AsInteger <> 0) then begin
        Mensagens.Adicionar(1936, Self.ClassName, NomMetodo, []);
        Result := -1936;
        Exit;
      end;
}
      bGerarHistoricoEnvioCertificado := (Q.FieldByName('qtd_codigo_certificado').AsInteger <> 0);
      if (Q.FieldByName('qtd_situacao_codigo').AsInteger <> QtdCodigo) then begin
        Mensagens.Adicionar(1937, Self.ClassName, NomMetodo, []);
        Result := -1937;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Insere evento de autenticação
      IntEventos := TIntEventos.Create;
      try
        if IntEventos.Inicializar(Conexao, Mensagens) < 0 then begin
          Rollback;
          Exit;
        end;

        CodEventoEnvioCertificado := IntEventos.InserirEnvioCertificado(
           CodPessoaProdutor, NomServicoEnvio, NumConhecimento);

        if CodEventoEnvioCertificado < 0 then begin
          Result := CodEventoEnvioCertificado;
          Rollback;
          Exit;
        end;
      finally
        IntEventos.Free;
      end;

      // Associa animais que utilizam os códigos SISBOV da faixa ao evento
      // de Autenticação SISBOV gerado
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_animal_evento ( ' +
          '  cod_pessoa_produtor ' +
          '  , cod_evento ' +
          '  , cod_animal ' +
          '  , ind_animal_castrado ' +
          '  , cod_regime_alimentar ' +
          '  , cod_categoria_animal ' +
          '  , cod_tipo_lugar ' +
          '  , cod_lote_corrente ' +
          '  , cod_local_corrente ' +
          '  , cod_fazenda_corrente ' +
          '  , num_imovel_corrente ' +
          '  , cod_propriedade_corrente ' +
          '  , num_cnpj_cpf_corrente ' +
          '  , cod_pessoa_corrente ' +
          '  , cod_pessoa_secundaria_corrente ' +
          '  , qtd_peso_animal ' +
          '  , ind_apto_cobertura ' +
          '  , ind_touro_apto ' +
          '  , ind_vaca_prenha ' +
          '  , dta_desativacao ' +
          '  , dta_ultimo_evento ' +
          '  , dta_aplicacao_ultimo_evento ' +
          '  , cod_animal_associado ' +
          '  , dta_aplicacao_evento ' +
          '  , txt_dados ' +
          '  , cod_arquivo_sisbov ' +
          '  , cod_arquivo_sisbov_log ' +
          ') ' +
          'select ' +
          '  cod_pessoa_produtor ' +
          '  , :cod_evento_envio_certificado as cod_evento ' +
          '  , cod_animal ' +
          '  , ind_animal_castrado ' +
          '  , cod_regime_alimentar ' +
          '  , cod_categoria_animal ' +
          '  , cod_tipo_lugar ' +
          '  , cod_lote_corrente ' +
          '  , cod_local_corrente ' +
          '  , cod_fazenda_corrente ' +
          '  , num_imovel_corrente ' +
          '  , cod_propriedade_corrente ' +
          '  , num_cnpj_cpf_corrente ' +
          '  , cod_pessoa_corrente ' +
          '  , cod_pessoa_secundaria_corrente ' +
          '  , null as qtd_peso_animal ' +
          '  , ind_apto_cobertura ' +
          '  , null as ind_touro_apto ' +
          '  , null as ind_vaca_prenha ' +
          '  , dta_desativacao ' +
          '  , dta_ultimo_evento ' +
          '  , dta_aplicacao_ultimo_evento ' +
          '  , null as cod_animal_associado ' +
          '  , getdate() as dta_aplicacao_evento ' +
          '  , null as txt_dados ' +
          '  , null as cod_arquivo_sisbov ' +
          '  , null as cod_arquivo_sisbov_log ' +
          'from ' +
          '  tab_animal ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_arquivo_sisbov is not null ' +
          '  and dta_fim_validade is null ';
{$ENDIF}
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1938, Self.ClassName, NomMetodo, []);
        Result := -1938;
        Rollback;
        Exit;
      end;

      // Atualiza a quantidade de animais do evento
      Q.Close;
      Q.SQL.Text:=
{$IFDEF MSSQL}
        'update ' +
        '  tab_evento ' +
        'set ' +
        '  qtd_animais = :qtd_animais ' +
        'where ' +
        '  cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_evento = :cod_evento_envio_certificado ';
{$ENDIF}
      Q.ParamByName('qtd_animais').AsInteger := QtdCodigo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ExecSQL;

      // Armazena situação atual dos códigos que estão sendo enviados novamente
      if bGerarHistoricoEnvioCertificado then begin
        Q.Close;
        Q.SQL.Text :=
{$IFDEF MSSQL}
          'insert into tab_historico_env_certificado ( ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_envio_certificado ' +
          '  , dta_envio_certificado ' +
          '  , cod_evento_envio_certificado ' +
          ') ' +
          'select ' +
          '  cod_pais_sisbov ' +
          '  , cod_estado_sisbov ' +
          '  , cod_micro_regiao_sisbov ' +
          '  , cod_animal_sisbov ' +
          '  , num_dv_sisbov ' +
          '  , qtd_vezes_envio_certificado ' +
          '  , dta_envio_certificado ' +
          '  , cod_evento_envio_certificado ' +
          'from ' +
          '  tab_codigo_sisbov ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
          '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
          '  and cod_propriedade_rural = :cod_propriedade_rural ' +
          '  and qtd_vezes_envio_certificado is not null ';
{$ENDIF}
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.ExecSQL;
      end;

      // Altera os códigos SISBOV correspondentes a operação
      Q.Close;
      Q.SQL.Text :=
{$IFDEF MSSQL}
        'update ' +
        '  tab_codigo_sisbov ' +
        'set ' +
        '  dta_envio_certificado = :dta_envio_certificado ' +
        '  , cod_evento_envio_certificado = :cod_evento_envio_certificado ' +
        '  , qtd_vezes_envio_certificado = ISNULL(qtd_vezes_envio_certificado, 0) + 1 ' +
        '  , cod_situacao_codigo_sisbov = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut ) then :cod_situacao_cert else cod_situacao_codigo_sisbov end ' +
        '  , cod_usuario_mudanca = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut, :cod_situacao_impr ) then :cod_usuario_ultima_alteracao else cod_usuario_mudanca end ' +
        '  , dta_mudanca_situacao = case when cod_situacao_codigo_sisbov in ( :cod_situacao_ident , :cod_situacao_aut, :cod_situacao_impr ) then getdate() else dta_mudanca_situacao end ' +
        '  , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
        '  , dta_ultima_alteracao = getdate() ' +
        'where ' +
        '  cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim ' +
        '  and cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      Q.ParamByName('dta_envio_certificado').AsDateTime := DtaEnvio;
      Q.ParamByName('cod_evento_envio_certificado').AsInteger := CodEventoEnvioCertificado;
      Q.ParamByName('cod_situacao_ident').AsInteger := EFET;
      Q.ParamByName('cod_situacao_aut').AsInteger := AUT;
      Q.ParamByName('cod_situacao_cert').AsInteger := CERT;
      Q.ParamByName('cod_situacao_impr').AsInteger := IMPR;
      Q.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
      Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
      if Q.RowsAffected <> QtdCodigo then begin
        Mensagens.Adicionar(1932, Self.ClassName, NomMetodo, []);
        Result := -1932;
        Rollback;
        Exit;
      end;

      InserirHistorico(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
        CodAnimalSISBOVInicio, CodAnimalSISBOVFim, 'N');

      if CodOrdemServico > 0 then begin
        try
          FIntOrdensServico.MudarSituacaoParaCert(Conexao, Mensagens,
            CodOrdemServico, CodPaisSISBOV, CodEstadoSISBOV,
            CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
            CodAnimalSISBOVFim, NumDVSISBOVFim, QtdCodigo, 0, '', '');
        except
          on E: EHerdomexception do begin
            Rollback;
            E.GerarMensagem(Mensagens);
            Result := -E.CodigoErro;
            Exit;
          end;
        end;
      end;

      Commit;

      Mensagens.Adicionar(1914, Self.ClassName, NomMetodo, [IntToStr(Q.RowsAffected)]);
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(1915, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1915;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

end.
