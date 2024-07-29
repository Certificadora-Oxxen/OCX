unit uIntOrdensServico;

interface

{$DEFINE MSSQL}

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntOrdemServico, uferramentas, uIntOrdemServicoResumida, uIntEndereco,
     uIntEnderecos, uIntOcorrenciasSistema, DateUtils, uIntPropriedadesRurais,
     WsSISBOV1, InvokeRegistry, Rio, SOAPHTTPClient, XMLDoc, XMLIntf, SOAPHTTPTrans;

const
  // Quantidade máxima de animais que uma ordem de serviço pode ter.
  cLimiteQtdAnimais: Integer = 99999;
  cCodSituacaoOSPend: Integer = 3;
  cCodSituacaoOSEnv2: Integer = 6;
  cCodSituacaoOSProd: Integer = 8;
  cCodSituacaoOSIdent: Integer = 9;
  cCodSituacaoOSAut: Integer = 10;
  cCodSituacaoOSCert: Integer = 11;
  cCodSituacaoOSCancelada: Integer = 99;
  // Atributos da OS que devem ser utilizados de acordo com  a situação
  cNomeCamposSituacaoCodigoSisbov: array[1..11] of String = (
    'dta_insercao_registro', 'dta_utilizacao_codigo', 'dta_efetivacao_cadastro',
    'dta_autenticacao', 'dta_envio_certificado', '', '', '',
    'dta_recebimento_ficha', 'dta_aprovacao_ficha', 'dta_impressao_certificado');
  cParametroQtdDiasIntervaloPesquisa: Integer = 96;
  cParametroQtdOSPesquisa: Integer = 97;
  GERAR_NUMERACAO_AUTOMATICA_OS: Integer = 78;

type
  TIntOrdensServico = class(TIntClasseBDNavegacaoBasica)
  private
    FOrdemServico: TIntOrdemServico;
    FOrdemServicoResumida: TIntOrdemServicoResumida;
    FIntEnderecos: TIntEnderecos;

    FIndAcessoNumOrdemServico: String;
    FIndAcessoQtdAnimais: String;
    FIndAcessoPessoaTecnico: String;
    FIndAcessoPessoaVendedor: String;
    FIndAcessoFormaPagamentoOS: String;
    FIndAcessoIdentificacaoDupla: String;
    FIndAcessoFabricanteIdentificador: String;
    FIndAcessoFormaPagamentoIdent: String;
    FIndAcessoProdutoAcessorio1: String;
    FIndAcessoQtdProdutoAcessorio1: String;
    FIndAcessoProdutoAcessorio2: String;
    FIndAcessoQtdProdutoAcessorio2: String;
    FIndAcessoProdutoAcessorio3: String;
    FIndAcessoQtdProdutoAcessorio3: String;
    FIndAcessoEnviaPedidoIdentificador: String;
    FIndAcessoCodigoSISBOVInicio: String;
    FIndAcessoEnderecoEntregaCert: String;
    FIndAcessoEnderecoEntregaIdent: String;
    FIndAcessoEnderecoCobrancaIdent: String;
    FIndAcessoObservacaoPedido: String;
    FIndAcessoAnimaisRegistrados: String;

    function VerificaExistenciaOS(CodOrdemServico, TipoEndereco: Integer): Integer;
    function VerificaExistenciaEndereco(CodEndereco: Integer; TxtDesEndereco: String): Integer;
    function PreecheEstruturaOrdemServico(QueryLocal: THerdomQuery): Integer;
    class function ProximoNumeroOS(var ValProximoNumOS: Integer; Conexao: TConexao; Mensagens: TIntMensagens): Integer;
    function ValidaProdutoAcessorio(CodFabricanteIdentificador,
      CodProdutoAcessorio, QtdProdutoAcessorio,
      NumProdutoAcessorio: Integer): Integer;
    class function ValidaCamposAlterados(EConexao: TConexao; EMensagens: TIntMensagens;
      CodOrdemServico, QtdAnimais, CodPessoaTecnico, CodPessoaVendedor,
      CodFormaPagamentoOS, CodIdentificacaoDupla, CodFabricanteIdentificador,
      CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
      CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
      QtdProdutoAcessorio3, NumOrdemServico, CodSituacaoOS: Integer;
      IndEnviaPedidoIdent, TxtObservacaoPedido, IndAnimaisRegistrados: String;
      CodEnderecoEntregaCert, CodEnderecoEntregaIdent, CodEnderecoCobrancaIdent,
      CodAnimalSISBOVInicio: Integer; IndChamadaInterna,
      IndGerarMensagem: Boolean): Integer;
    class function AtributoValido(ValorAtual, ValorDestino: Integer; IndPodeAlterar,
      IndRequerido, IndMensagem: String; CodMensagemRequerido,
      CodMensagemAlterar, CodMensagemAviso: Integer): Integer; overload;
    class function AtributoValido(ValorAtual, ValorDestino, IndPodeAlterar,
      IndRequerido, IndMensagem: String; CodMensagemRequerido,
      CodMensagemAlterar, CodMensagemAviso: Integer): Integer; overload;
    class function ObtemValorSequencial(EConexao: TConexao; EMensagens: TIntMensagens;
      NomeCampo: String; var ValorCampo: Integer): Integer;
    class function ProximoCodigoOS(EConexao: TConexao; EMensagens: TIntMensagens;
      var ValProximoCodOS: Integer): Integer;
    class function AtualizaNumOrdemServico(EConexao: TConexao;
      EMensagens: TIntMensagens; NumOrdemServico: Integer): Integer;
    class function InsereHistoricoSituacao(EConexao: TConexao;
      EMensagens: TIntMensagens; CodOrdemServico, CodSituacaoOS: Integer;
      TxtObservacao: String): Integer;
    class function ObtemDadosUltimaOrdemServicoProdutor(EConexao: TConexao;
      EMensagens: TIntMensagens; CodPessoaProdutor,
      CodPropriedadeRural: Integer; IndEnviaPedidoIdent: String;
      var CodEnderecoEntregaCert, CodIdentificacaoDupla,
      CodFabricanteIdentificador, CodEnderecoEntregaIdent,
      CodEnderecoCobrancaIdent: Integer): Integer;
    class function VerificaPermissao(EConexao: TConexao;
      EMensagens: TIntMensagens; var PermiteAcesso: Boolean;
      CodPessoaProdutor: Integer; IndGerarMensagens: Boolean): Integer;
    class procedure ValidarIdentificacaoDupla(EConexao: TConexao;
      EMensagens: TIntMensagens; CodIdentificacaoDupla, CodPaisSISBOV,
        CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;

    function Buscar(CodOrdemServico: Integer): Integer;
    function BuscarResumido(CodOrdemServico: Integer): Integer;
    function OrdemServico: TIntOrdemServico;
    function OrdemServicoResumida: TIntOrdemServicoResumida;
    class function ObterProximoNumero(EConexao: TConexao; EMensagens: TIntMensagens): Integer;
    function PesquisarHistoricoSituacao(CodOrdemServico: Integer): Integer;
    function Alterar(CodOrdemServico,
                     NumOrdemServico,
                     QtdAnimais,
                     CodPessoaTecnico,
                     CodPessoaVendedor: Integer;
                     NumCNPJCPFVendedor: String;
                     CodFormaPagamentoOS,
                     CodIdentificacaoDupla,
                     CodFabricanteIdentificador,
                     CodFormaPagamentoIdent,
                     CodProdutoAcessorio1,
                     QtdProdutoAcessorio1,
                     CodProdutoAcessorio2,
                     QtdProdutoAcessorio2,
                     CodProdutoAcessorio3,
                     QtdProdutoAcessorio3: Integer;
                     TxtObservacaoPedido,
                     TxtObservacao,
                     IndAnimaisRegistrados: String): Integer;

    function Pesquisar(NumOrdemServico: Integer;
                       SglProdutor,
                       NomProdutor,
                       NumCNPJCPFProdutor,
                       NumImovelReceitaFederal: String;
                       CodLocalizacaoSisbov: Integer;
                       NomPropriedadeRural,
                       NumCNPJCPFTecnico,
                       NumCNPJCPFVendedor: String;
                       QtdAnimaisInicio,
                       QtdAnimaisFim,
                       NumSolicitacaoSISBOV: Integer;
                       IndApenasSemEnderecoEntregaCert: String;
                       CodIdentificacaoDupla,
                       CodFabricanteIdentificador: Integer;
                       IndEnviaPedidoIdentificador,
                       IndApenasSemEnderecoEntregaIdent,
                       IndApenasSemEnderecoCobrancaIdent: String;
                       NumPedidoFabricante,
                       NumRemessa: Integer;
                       DtaCadastramentoInicio,
                       DtaCadastramentoFim,
                       DtaMudancaSituacaoInicio,
                       DtaMudancaSituacaoFim: TDateTime;
                       CodSituacaoOS,
                       CodPaisSISBOV,
                       CodEstadoSISBOV,
                       CodMicroRegiaoSISBOV,
                       CodAnimalSISBOV,
                       CodSituacaoSISBOVSim,
                       CodSituacaoSISBOVNao: Integer;
                       DtaSituacaoSISBOVSimInicio,
                       DtaSituacaoSISBOVSimFim: TDateTime;
                       NumDiasBoletoAVencer,
                       NumDiasBoletoEmAtraso,
                       NumDiasBoletoPago,
                       CodSituacaoBoleto: Integer;
                       CodOrdenacao,
                       IndordenacaoCrescent: String): Integer;
                       
    function DefinirEnderecoEntregaCert2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer;
    function DefinirEnderecoEntregaIdent2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer;
    function DefinirEnderecoCobrancaIdent2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer;
    function DefinirEnderecoEntregaCert1(CodOrdemServico,
      CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
      NomLogradouro, NomBairro, NumCep: String; CodDistrito,
      CodMunicipio: Integer; NomLocalidade: String; CodEstado: Integer): Integer;
    function DefinirEnderecoEntregaIdent1(CodOrdemServico,
      CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
      NomLogradouro, NomBairro, NumCep: String; CodDistrito,
      CodMunicipio: Integer; NomLocalidade: String; CodEstado: Integer): Integer;
    function DefinirEnderecoCobrancaIdent1(CodOrdemServico,
      CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
      NomLogradouro, NomBairro, NumCep: String; CodDistrito,
      CodMunicipio: Integer; NomLocalidade: String; CodEstado: Integer): Integer;
    function BuscarAcessoAtributos(CodOrdemServico: Integer): Integer;

    class function Inserir(EConexao: TConexao;
                           EMensagens: TIntMensagens;
                           NumOrdemServico,
                           CodPessoaProdutor: Integer;
                           SglProdutor,
                           NumCNPJCPFProdutor: String;
                           CodPropriedadeRural: Integer;
                           NumImovelReceitaFederal: String;
                           CodLocalizacaoSisbov,
                           QtdAnimais: Integer;
                           IndEnviaPedidoIdent: String;
                           IndChamadaInterna: String = 'S'): Integer;

    class function MudarSituacaoInt(EConexao: TConexao; EMensagens: TIntMensagens;
      CodOrdemServico, CodSituacaoOS: Integer; TxtObservacao: String;
      IndGerarMensagens, IndChamadaInterna,
      IndValidaAcessoAtributo: Boolean): Integer;
    class function MudarSituacao(EConexao: TConexao; EMensagens: TIntMensagens;
      CodOrdemServico, CodSituacaoOS: Integer; TxtObservacao: String;
      IndGerarMensagens: String;
      IndChamadaInterna: String): Integer;
    class procedure MudarSituacaoParaIdent(EConexao: TConexao;
      EMensagens: TIntMensagens; CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov: Integer);
    class procedure MudarSituacaoParaAut(EConexao: TConexao;
      EMensagens: TIntMensagens; CodOrdemServico, CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim, QtdAnimaisAutenticados: Integer;
      DtaLiberacaoAbateInicial, DtaLiberacaoAbateFinal: TDateTime;
      IndDtaAbateEstimada: String);
    class procedure MudarSituacaoParaCert(EConexao: TConexao;
      EMensagens: TIntMensagens; CodOrdemServico, CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
      CodAnimalSISBOVFim, NumDVSISBOVFim, QtdAnimaisCertificados: Integer;
      DtaEnvioCert: TDateTime; NomServicoEnvio, NumConhecimento: String);
    class procedure MudarSituacaoParaProd(EConexao: TConexao;
      EMensagens: TIntMensagens; CodOrdemServico: Integer; TxtObservacao: String;
      DtaEnvio: TDateTime; NomServicoEnvio, NumConhecimento: String);
    class function AtualizarSolicitacaoSISBOV(
      CodPessoaProdutor, CodPropriedadeRural, QtdAnimais, NumSolicitacaoSISBOV,
      CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio: Integer;
      EConexao: TConexao; EMensagens: TIntMensagens): Integer;
    function PesquisarRelatorio(EQuery: THerdomQuery;
      NumOrdemServico: Integer; SglProdutor, NomProdutor,
      NumCNPJCPFProdutor, NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer;
      NomPropriedadeRural, NumCNPJCPFTecnico, NumCNPJCPFVendedor: String; QtdAnimaisInicio,
      QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
      IndApenasSemEnderecoEntregaCert: String; CodIdentificacaoDupla,
      CodFabricanteIdentificador: Integer; IndEnviaPedidoIdentificador,
      IndApenasSemEnderecoEntregaIdent,
      IndApenasSemEnderecoCobrancaIdent: String; NumPedidoFabricante,
      NumRemessa: Integer; DtaCadastramentoInicio,
      DtaCadastramentoFim, DtaMudancaSituacaoInicio,
      DtaMudancaSituacaoFim: TDateTime; CodSituacaoOS, CodPaisSISBOV,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV,
      CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
      DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
      NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
      CodSituacaoBoleto: Integer): Integer;
    function GerarRelatorio(NumOrdemServico: Integer; SglProdutor, NomProdutor,
      NumCNPJCPFProdutor, NumImovelReceitaFederal: String;
      CodLocalizacaoSisbov: Integer;  NomPropriedadeRural,
      NumCNPJCPFTecnico, NumCNPJCPFVendedor: String; QtdAnimaisInicio,
      QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
      IndApenasSemEnderecoEntregaCert: String; CodIdentificacaoDupla,
      CodFabricanteIdentificador: Integer; IndEnviaPedidoIdentificador,
      IndApenasSemEnderecoEntregaIdent,
      IndApenasSemEnderecoCobrancaIdent: String; NumPedidoFabricante,
      NumRemessa: Integer; DtaCadastramentoInicio,
      DtaCadastramentoFim, DtaMudancaSituacaoInicio,
      DtaMudancaSituacaoFim: TDateTime; CodSituacaoOS, CodPaisSISBOV,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV,
      CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
      DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
      NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
      CodSituacaoBoleto: Integer; CodOrdenacao,
      IndordenacaoCrescent: String; Tipo,  QtdQuebraRelatorio: Integer): String;

    function DefinirCodigoSISBOVInicio(CodOrdemServico, CodPaisSISBOVInicio,
      CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio, CodAnimalSISBOVInicio,
      NumDVSISBOVInicio: Integer): Integer;

    function LimparCodigoSISBOVInicio(CodOrdemServico: Integer): Integer;

    function MudarEnviarPedidoIdentificador(CodOrdemServico: Integer;
      IndEnviaPedidoIdent: String): Integer;

    function PesquisarSituacaoCodigoSisBov(CodOrdemServico: Integer;
      IndMostrarDataMudancaSituacao: String): Integer;

    function PesquisarDataLiberacaoAbate(CodOrdemServico: Integer): Integer;

    class procedure EnviarEMail(EConexao: TConexao; EMensagens: TIntMensagens;
      CodSituacaoOS, CodOrdemServico, QtdCertificadosEnviados,
      QtdAnimaisAutenticados: Integer; DtaLiberacaoAbateInicial,
      DtaLiberacaoAbateFinal: TDateTime; CodSISBOVInicioFormatado,
      CodSISBOVFimFormatado, TxtObservacaoSituacaoOS,
      IndDtaLiberacaoEstimada: String; DtaEnvioCert: TDateTime;
      NomServicoEnvioCert, NumConhecimentoCert: String);

    function GerarRelatorioFichaOrdemServico(CodOrdemServico,
      TipoDoArquivo: Integer): String;

    function PesquisarSituacoesFichas(CodOrdemServico,
      NumRemessaFicha: Integer): Integer;

    function AlterarEnvioIdentOS(ECodOrdemServico: Integer;
                                 EDtaEnvioIdentificadores: TDateTime;
                                 ENomServicoEnvio: String;
                                 ENroConhecimento: String): Integer;

    function IncluirSolicitacaoNumeracao(CodOrdemServico: Integer): Integer;
    function DefinirNumeroSolicitacao(CodOrdemServico, NumeroSolicitacao: Integer; DataSolicitacao: TDateTime): Integer;

    function IncluirSolicitacaoNumeracaoReimpressao(CodOrdemServico: Integer): Integer;
    function ConsultarNumeracaoReimpressao(CodOrdemServico: Integer): Integer;

    function TempConsultarNumeracaoReimpressao(const numeroSolicitacao: Int64): WideString;
    function TempSolicitarNumeracaoReimpressao(cnpjFabrica, cpfProdutor, cnpjProdutor: WideString;
      const idPropriedade: Int64; const qtd: Integer; const numero_sisbov, tipo_identificacao: WideString): Integer;
    function TempCancelarSolicitacaoNumeracao(NumeroSisbov: WideString;
      idPropriedade: Integer; cnpjProdutor, cpfProdutor: WideString; idMotivoCancelamento: Integer): Integer;

    function SolicitarNumeracaoReimpressao(CodFabricanteIdentificador: Integer;const CodManejo, TipoIdentificacao: WideString): Integer;
    
    property IndAcessoNumOrdemServico: String read FIndAcessoNumOrdemServico write FIndAcessoNumOrdemServico;
    property IndAcessoQtdAnimais: String read FIndAcessoQtdAnimais write FIndAcessoQtdAnimais;
    property IndAcessoPessoaTecnico: String read FIndAcessoPessoaTecnico write FIndAcessoPessoaTecnico;
    property IndAcessoPessoaVendedor: String read FIndAcessoPessoaVendedor write FIndAcessoPessoaVendedor;
    property IndAcessoFormaPagamentoOS: String read FIndAcessoFormaPagamentoOS write FIndAcessoFormaPagamentoOS;
    property IndAcessoIdentificacaoDupla: String read FIndAcessoIdentificacaoDupla write FIndAcessoIdentificacaoDupla;
    property IndAcessoFabricanteIdentificador: String read FIndAcessoFabricanteIdentificador write FIndAcessoFabricanteIdentificador;
    property IndAcessoFormaPagamentoIdent: String read FIndAcessoFormaPagamentoIdent write FIndAcessoFormaPagamentoIdent;
    property IndAcessoProdutoAcessorio1: String read FIndAcessoProdutoAcessorio1 write FIndAcessoProdutoAcessorio1;
    property IndAcessoQtdProdutoAcessorio1: String read FIndAcessoQtdProdutoAcessorio1 write FIndAcessoQtdProdutoAcessorio1;
    property IndAcessoProdutoAcessorio2: String read FIndAcessoProdutoAcessorio2 write FIndAcessoProdutoAcessorio2;
    property IndAcessoQtdProdutoAcessorio2: String read FIndAcessoQtdProdutoAcessorio2 write FIndAcessoQtdProdutoAcessorio2;
    property IndAcessoProdutoAcessorio3: String read FIndAcessoProdutoAcessorio3 write FIndAcessoProdutoAcessorio3;
    property IndAcessoQtdProdutoAcessorio3: String read FIndAcessoQtdProdutoAcessorio3 write FIndAcessoQtdProdutoAcessorio3;
    property IndAcessoEnviaPedidoIdentificador: String read FIndAcessoEnviaPedidoIdentificador write FIndAcessoEnviaPedidoIdentificador;
    property IndAcessoCodigoSISBOVInicio: String  read FIndAcessoCodigoSISBOVInicio write FIndAcessoCodigoSISBOVInicio;
    property IndAcessoEnderecoEntregaCert: String read FIndAcessoEnderecoEntregaCert write FIndAcessoEnderecoEntregaCert;
    property IndAcessoEnderecoEntregaIdent: String read FIndAcessoEnderecoEntregaIdent write FIndAcessoEnderecoEntregaIdent;
    property IndAcessoEnderecoCobrancaIdent: String read FIndAcessoEnderecoCobrancaIdent write FIndAcessoEnderecoCobrancaIdent;
    property IndAcessoObservacaoPedido: String read FIndAcessoObservacaoPedido write FIndAcessoObservacaoPedido;
    property IndAcessoAnimaisRegistrados: String read FIndAcessoAnimaisRegistrados write FIndAcessoAnimaisRegistrados;
  end;

implementation

uses SqlExpr, Classes, uIntEmailsEnvio, StrUtils, uIntCodigosSISBOV,
  uIntRelatorios, uIntSoapSisbov;

{ TIntOrdensServico }

function TIntOrdensServico.Alterar(CodOrdemServico, NumOrdemServico,
  QtdAnimais, CodPessoaTecnico, CodPessoaVendedor: Integer;
  NumCNPJCPFVendedor: String; CodFormaPagamentoOS, CodIdentificacaoDupla,
  CodFabricanteIdentificador, CodFormaPagamentoIdent, CodProdutoAcessorio1,
  QtdProdutoAcessorio1, CodProdutoAcessorio2, QtdProdutoAcessorio2,
  CodProdutoAcessorio3, QtdProdutoAcessorio3: Integer;
  TxtObservacaoPedido, TxtObservacao, IndAnimaisRegistrados: String): Integer;
const
  NomeMetodo = 'Alterar';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado,
  IndAtualizarUsuarioPedido: Boolean;
  NumOSAtual: Integer;
  CodPessoaProdutor: Integer;
  CodSituacaoOS: Integer;
  IndEnviaPedidoIdent: String;
  CodEnderecoEntregaCert,
  CodEnderecoEntregaIdent,
  CodEnderecoCobrancaIdent,
  CodRegistroLog,
  CodPaisSISBOVInicio,
  CodEstadoSISBOVInicio,
  CodMicroRegiaoSISBOVInicio,
  CodAnimalSISBOVInicio,
  CodIdentificacaoDuplaAnt,
  CodFabricanteIdentificadorAnt,
  CodModeloIdentificador1,
  CodModeloIdentificador2,
  QtdAnimaisAtual: Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(553) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Valida os CNPJ/CPF informados
  if not ValidaCnpjCpf(NumCNPJCPFVendedor, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFVendedor]);
    Result := -668;
    Exit;
  end;

  // Valida o código da ordem de serviço
  if CodOrdemServico < 0 then
  begin
    Mensagens.Adicionar(1804, Self.ClassName, NomeMetodo, []);
    Result := -1804;
    Exit;
  end;

  // Valida o número da ordem de serviço
  if NumOrdemServico < 0 then
  begin
    Mensagens.Adicionar(1805, Self.ClassName, NomeMetodo, []);
    Result := -1805;
    Exit;
  end;

  // A quantidade de animais da OS deve ser maior que 0 e menor
  // que o limite de animais
  if (QtdAnimais < 1) or (QtdAnimais > cLimiteQtdAnimais) then begin
    Mensagens.Adicionar(1773, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
    Result := -1773;
    Exit;
  end;

  // Sómente um dos parametros pode ser informando
  if (CodPessoaVendedor > -1) and (NumCNPJCPFVendedor <> '') then begin
    Mensagens.Adicionar(1806, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
    Result := -1806;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Caso o usuário logado seja um gestor, ao excluir o animal dever-se-á validar se o animal
      // pertence ao círculo de produtores relacionados a técnicos do gestor.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        QueryLocal.SQL.Clear;
        QueryLocal.SQL.Add(' select isnull(cod_pessoa_produtor, -1) as cod_pessoa_produtor from tab_ordem_servico ');
        QueryLocal.SQL.Add('  where cod_ordem_servico = :cod_ordem_servico');
        QueryLocal.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        QueryLocal.Open;
        CodPessoaProdutor := QueryLocal.FieldByName('cod_pessoa_produtor').AsInteger;

        QueryLocal.SQL.Clear;
        QueryLocal.SQL.Add(' select 1 ');
        QueryLocal.SQL.Add('   from tab_tecnico tt ');
        QueryLocal.SQL.Add('      , tab_tecnico_produtor ttp ');
        QueryLocal.SQL.Add('  where tt.cod_pessoa_tecnico   = ttp.cod_pessoa_tecnico ');
        if CodPessoaTecnico > 0 then
        begin
          QueryLocal.SQL.Add('    and tt.cod_pessoa_tecnico   = :cod_pessoa_tecnico ');
        end;
        QueryLocal.SQL.Add('    and tt.cod_pessoa_gestor    = :cod_pessoa_gestor ');
        QueryLocal.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        QueryLocal.SQL.Add('    and tt.dta_fim_validade     is null ');
        QueryLocal.SQL.Add('    and ttp.dta_fim_validade    is null ');
        QueryLocal.ParamByName('cod_pessoa_gestor').AsInteger   := Conexao.CodPessoa;
        QueryLocal.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        if CodPessoaTecnico > 0 then
        begin
          QueryLocal.ParamByName('cod_pessoa_tecnico').AsInteger  := CodPessoaTecnico;
        end;
        QueryLocal.Open;

        if QueryLocal.IsEmpty then
        begin
          Mensagens.Adicionar(2197, Self.ClassName, NomeMetodo, []);
          Result := -2197;
          Exit;
        end;
      end;

      // Se o CNPJ/CPF do vendedor foi informando busca do código
      if NumCNPJCPFVendedor <> '' then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select tp.cod_pessoa');
          SQL.Add('  from tab_pessoa tp,');
          SQL.Add('       tab_pessoa_papel tpp');
          SQL.Add(' where tp.cod_pessoa = tpp.cod_pessoa');
          SQL.Add('   and tpp.dta_fim_validade is null');
          SQL.Add('   and tp.dta_fim_validade is null');
          SQL.Add('   and tpp.cod_papel = 8');
          SQL.Add('   and tp.num_cnpj_cpf = :num_cnpj_cpf');
{$ENDIF}
          ParamByName('num_cnpj_cpf').AsString := NumCNPJCPFVendedor;
          Open;

          if isEmpty then
          begin
            Mensagens.Adicionar(1818, Self.ClassName, NomeMetodo, [NumCNPJCPFVendedor]);
            Result := -1818;
            Exit;
          end;

          CodPessoaVendedor := FieldByName('cod_pessoa').AsInteger;
        end;
      end;

      // Verifica se o vendedor é valido
      if CodPessoaVendedor > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select tp.cod_pessoa');
          SQL.Add('  from tab_pessoa tp,');
          SQL.Add('       tab_pessoa_papel tpp');
          SQL.Add(' where tp.cod_pessoa = tpp.cod_pessoa');
          SQL.Add('   and tpp.dta_fim_validade is null');
          SQL.Add('   and tp.dta_fim_validade is null');
          SQL.Add('   and tpp.cod_papel = 8');
          SQL.Add('   and tp.cod_pessoa = :cod_pessoa');
{$ENDIF}
          ParamByName('cod_pessoa').AsInteger := CodPessoaVendedor;
          Open;

          if isEmpty then
          begin
            Mensagens.Adicionar(1819, Self.ClassName, 'Buscar', [IntToStr(CodPessoaVendedor)]);
            Result := -1819;
            Exit;
          end;
        end;
      end;

      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       num_ordem_servico,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       cod_pessoa_produtor,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       isNull(cod_endereco_entrega_cert, -1) as cod_endereco_entrega_cert,');
        SQL.Add('       isNull(cod_endereco_entrega_ident, -1) as cod_endereco_entrega_ident,');
        SQL.Add('       isNull(cod_endereco_cobranca_ident, -1) as cod_endereco_cobranca_ident,');
        SQL.Add('       isNull(cod_pais_sisbov_inicio, -1) as cod_pais_sisbov_inicio,');
        SQL.Add('       isNull(cod_estado_sisbov_inicio, -1) as cod_estado_sisbov_inicio,');
        SQL.Add('       isNull(cod_micro_regiao_sisbov_inicio, -1) as cod_micro_regiao_sisbov_inicio,');
        SQL.Add('       isNull(cod_animal_sisbov_inicio, -1) as cod_animal_sisbov_inicio,');
        SQL.Add('       isNull(cod_fabricante_identificador, -1) as cod_fabricante_identificador,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla,');
        SQL.Add('       isNull(cod_forma_pagamento_ident, -1) as cod_forma_pagamento_ident,');
        SQL.Add('       isNull(cod_produto_acessorio_1, -1) as cod_produto_acessorio_1,');
        SQL.Add('       isNull(qtd_produto_acessorio_1, -1) as qtd_produto_acessorio_1,');
        SQL.Add('       isNull(cod_produto_acessorio_2, -1) as cod_produto_acessorio_2,');
        SQL.Add('       isNull(qtd_produto_acessorio_2, -1) as qtd_produto_acessorio_2,');
        SQL.Add('       isNull(cod_produto_acessorio_3, -1) as cod_produto_acessorio_3,');
        SQL.Add('       isNull(qtd_produto_acessorio_3, -1) as qtd_produto_acessorio_3,');
        SQL.Add('       isNull(cod_modelo_identificador_1, -1) as cod_modelo_identificador_1,');
        SQL.Add('       isNull(cod_modelo_identificador_2, -1) as cod_modelo_identificador_2,');
        SQL.Add('       qtd_animais,');
        SQL.Add('       cod_registro_log');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        if isEmpty then
        begin
          Mensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
          Result := -1744;
          Exit;
        end;

        NumOSAtual := FieldByName('num_ordem_servico').AsInteger;
        CodPessoaProdutor := FieldByName('cod_pessoa_produtor').AsInteger;
        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
        IndEnviaPedidoIdent := FieldByName('ind_envia_pedido_ident').AsString;
        CodEnderecoEntregaCert := FieldByName('cod_endereco_entrega_cert').AsInteger;
        CodEnderecoEntregaIdent := FieldByName('cod_endereco_entrega_ident').AsInteger;
        CodEnderecoCobrancaIdent := FieldByName('cod_endereco_cobranca_ident').AsInteger;
        CodRegistroLog := FieldByName('cod_registro_log').AsInteger;
        CodPaisSISBOVInicio := FieldByName('cod_pais_sisbov_inicio').AsInteger;
        CodEstadoSISBOVInicio := FieldByName('cod_estado_sisbov_inicio').AsInteger;
        CodMicroRegiaoSISBOVInicio := FieldByName('cod_micro_regiao_sisbov_inicio').AsInteger;
        CodAnimalSISBOVInicio := FieldByName('cod_animal_sisbov_inicio').AsInteger;
        CodIdentificacaoDuplaAnt := FieldByName('cod_identificacao_dupla').AsInteger;
        CodFabricanteIdentificadorAnt := FieldByName('cod_fabricante_identificador').AsInteger;
        CodModeloIdentificador1 := FieldByName('cod_modelo_identificador_1').AsInteger;
        CodModeloIdentificador2 := FieldByName('cod_modelo_identificador_2').AsInteger;
        QtdAnimaisAtual := FieldByName('qtd_animais').AsInteger;

        // Verifica se o usuário tem permissão de acesso.
        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          CodPessoaProdutor, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        // Verifica se algum dos dados do pedido esta sendo alterado
        IndAtualizarUsuarioPedido :=
          (CodFabricanteIdentificador <> FieldByName('cod_fabricante_identificador').AsInteger)
          or (CodFormaPagamentoIdent <> FieldByName('cod_forma_pagamento_ident').AsInteger)
          or (CodEnderecoEntregaIdent <> FieldByName('cod_endereco_entrega_ident').AsInteger)
          or (CodEnderecoCobrancaIdent <> FieldByName('cod_endereco_cobranca_ident').AsInteger)
          or (CodProdutoAcessorio1 <> FieldByName('cod_produto_acessorio_1').AsInteger)
          or (QtdProdutoAcessorio1 <> FieldByName('qtd_produto_acessorio_1').AsInteger)
          or (CodProdutoAcessorio2 <> FieldByName('cod_produto_acessorio_2').AsInteger)
          or (QtdProdutoAcessorio2 <> FieldByName('qtd_produto_acessorio_2').AsInteger)
          or (CodProdutoAcessorio3 <> FieldByName('cod_produto_acessorio_3').AsInteger)
          or (QtdProdutoAcessorio3 <> FieldByName('qtd_produto_acessorio_3').AsInteger);
      end;

      Result := ValidaCamposAlterados(Conexao, Mensagens, CodOrdemServico,
        QtdAnimais, CodPessoaTecnico, CodPessoaVendedor, CodFormaPagamentoOS,
        CodIdentificacaoDupla, CodFabricanteIdentificador,
        CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
        CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
        QtdProdutoAcessorio3, NumOrdemServico, CodSituacaoOS,
        IndEnviaPedidoIdent, TxtObservacaoPedido, IndAnimaisRegistrados, CodEnderecoEntregaCert,
        CodEnderecoEntregaIdent, CodEnderecoCobrancaIdent,
        CodAnimalSISBOVInicio, True, True);
      if Result < 0 then
      begin
        Exit;
      end;

      if NumOSAtual <> NumOrdemServico then
      begin
        // Verifica se já existe uma OS com este número na base de dados.
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select num_ordem_servico');
          SQL.Add('  from tab_ordem_servico');
          SQL.Add(' where num_ordem_servico = :num_ordem_servico');
          SQL.Add('   and cod_situacao_os <> :cod_situacao_os');
{$ENDIF}
          ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
          ParamByName('cod_situacao_os').AsInteger := cCodSituacaoOSCancelada;
          Open;

          if not IsEmpty then
          begin
            Mensagens.Adicionar(1764, Self.ClassName, NomeMetodo, []);
            Result := -1764;
            Exit;
          end;
        end;
      end;

      // Verifica se o técnico informado é valido
      if CodPessoaTecnico > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_pessoa_tecnico');
          SQL.Add('  from tab_tecnico_produtor');
          SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico');
          SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoaTecnico;
          ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1705, Self.ClassName, NomeMetodo, []);
            Result := -1705;
            Exit;
          end;
        end;
      end;

      // Verifica se a forma de pagamento informada é valida
      if CodFormaPagamentoOS > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_forma_pagamento_os');
          SQL.Add('  from tab_forma_pagamento_os');
          SQL.Add(' where cod_forma_pagamento_os = :cod_forma_pagamento_os');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_forma_pagamento_os').AsInteger := CodFormaPagamentoOS;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1807, Self.ClassName, NomeMetodo, []);
            Result := -1807;
            Exit;
          end;
        end;
      end;

      // Verifica se a identificação dupla informada é valida
      if (CodIdentificacaoDuplaAnt <> CodIdentificacaoDupla)
        and (CodIdentificacaoDupla > -1) then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_identificacao_dupla');
          SQL.Add('  from tab_identificacao_dupla');
          SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1808, Self.ClassName, NomeMetodo, []);
            Result := -1808;
            Exit;
          end;
        end;
      end;

      // Verifica se o fabricante de identificadores é valido
      if (CodFabricanteIdentificadorAnt <> CodFabricanteIdentificador)
        and (CodFabricanteIdentificador > -1) then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_fabricante_identificador');
          SQL.Add('  from tab_fabricante_identificador');
          SQL.Add(' where cod_fabricante_identificador = :cod_fabricante_identificador');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1809, Self.ClassName, NomeMetodo, []);
            Result := -1809;
            Exit;
          end;
        end;
      end;

      // Verifica se o fabricante possui um modelo para a identificacao dupla
      // informada e obtem os modelos da identificação dupla do fabricante
      if ((CodFabricanteIdentificador <> CodFabricanteIdentificadorAnt)
        or (CodIdentificacaoDupla <> CodIdentificacaoDuplaAnt))
        and (CodFabricanteIdentificador > -1) and (CodIdentificacaoDupla > -1) then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select IsNull(cod_modelo_identificador_1, -1) as cod_modelo_identificador_1,');
          SQL.Add('       IsNull(cod_modelo_identificador_2, -1) as cod_modelo_identificador_2');
          SQL.Add('  from tab_ident_dupla_modelo_ident');
          SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla');
          SQL.Add('   and cod_fabricante_identificador = :cod_fabricante_identificador');
{$ENDIF}
          ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
          ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1910, Self.ClassName, NomeMetodo, []);
            Result := -1910;
            Exit;
          end;

          CodModeloIdentificador1 := FieldByName('cod_modelo_identificador_1').AsInteger;
          CodModeloIdentificador2 := FieldByName('cod_modelo_identificador_2').AsInteger;
        end;
      end
      else
      if (CodFabricanteIdentificador < 0) or (CodIdentificacaoDupla < 0) then
      begin
        // se um dos dois atributos não estiver definido então limpa os
        // identificadores
        CodModeloIdentificador1 := -1;
        CodModeloIdentificador2 := -1;
      end;

      // Verifica se a forma de pagamento do sidentificadores é valida
      if CodFormaPagamentoIdent > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_forma_pagamento_ident');
          SQL.Add('  from tab_forma_pagamento_ident');
          SQL.Add(' where cod_forma_pagamento_ident = :cod_forma_pagamento_ident');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_forma_pagamento_ident').AsInteger := CodFormaPagamentoIdent;
          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1810, Self.ClassName, NomeMetodo, []);
            Result := -1810;
            Exit;
          end;
        end;
      end;

      // Valida o produto acessorio 1
      Result := ValidaProdutoAcessorio(CodFabricanteIdentificador,
        CodProdutoAcessorio1, QtdProdutoAcessorio1, 1);
      if Result < 0 then
      begin
        Exit;
      end;

      // Valida o produto acessorio 2
      Result := ValidaProdutoAcessorio(CodFabricanteIdentificador,
        CodProdutoAcessorio2, QtdProdutoAcessorio2, 2);
      if Result < 0 then
      begin
        Exit;
      end;

      // Valida o produto acessorio 3
      Result := ValidaProdutoAcessorio(CodFabricanteIdentificador,
        CodProdutoAcessorio3, QtdProdutoAcessorio3, 3);
      if Result < 0 then
      begin
        Exit;
      end;

      // Verifica se a quantidade de animais está sendo alterada depois da
      // definição do código SISBOV inicio.
      if (QtdAnimaisAtual <> QtdAnimais) and (CodAnimalSisbovInicio <> -1) then
      begin
        Mensagens.Adicionar(1949, Self.ClassName, NomeMetodo, []);
        Result := -1949;
        Exit;
      end;

      // Verifica se a identificação dupla é válida de acordo com os códigos
      // SISBOV associados á OS.
      try
        ValidarIdentificacaoDupla(Conexao, Mensagens, CodIdentificacaoDupla,
          CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
          CodAnimalSISBOVInicio);
      except
        on E: EHerdomException do
        begin
          E.gerarMensagem(Mensagens);
          Result := -E.CodigoErro;
          Exit;
        end;
      end;

      // Os produtos do pedido devem estar sempre em ordem, ou seja, o produto 2
      // só pode ser informado se o produtor 1 for informado.
      if (CodProdutoAcessorio1 < 0) and (QtdProdutoAcessorio1 < 0) then
      begin
        // se o produto 1 não foi informado mas o produtor 2 ou 3 foi informado
        // o produto informado passa a ser o produto 1.
        if (CodProdutoAcessorio2 > -1) and (QtdProdutoAcessorio2 > -1) then
        begin
          CodProdutoAcessorio1 := CodProdutoAcessorio2;
          QtdProdutoAcessorio1 := QtdProdutoAcessorio2;
          CodProdutoAcessorio2 := -1;
          QtdProdutoAcessorio2 := -1;
        end
        else
        if (CodProdutoAcessorio3 > -1) and (QtdProdutoAcessorio3 > -1) then
        begin
          CodProdutoAcessorio1 := CodProdutoAcessorio3;
          QtdProdutoAcessorio1 := QtdProdutoAcessorio3;
          CodProdutoAcessorio3 := -1;
          QtdProdutoAcessorio3 := -1;
        end;
      end;
      // se o produtor 3 foi informado mas o produto 2 não foi
      // então o produtor 2 passa a ser o produto 3.
      if (CodProdutoAcessorio2 < 0) and (QtdProdutoAcessorio2 < 0)
      and (CodProdutoAcessorio3 > -1) and (QtdProdutoAcessorio3 > -1) then
      begin
        CodProdutoAcessorio2 := CodProdutoAcessorio3;
        QtdProdutoAcessorio2 := QtdProdutoAcessorio3;
        CodProdutoAcessorio3 := -1;
        QtdProdutoAcessorio3 := -1;
      end;

      BeginTran;

      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_ordem_servico');
        SQL.Add('   set num_ordem_servico = :num_ordem_servico,');
        if IndAtualizarUsuarioPedido then
        begin
          SQL.Add('       cod_usuario_pedido = :cod_usuario_pedido,');
          SQL.Add('       dta_pedido = getDate(),');
        end;
        SQL.Add('       qtd_animais = :qtd_animais,');
        SQL.Add('       cod_pessoa_tecnico = :cod_pessoa_tecnico,');
        SQL.Add('       cod_pessoa_vendedor = :cod_pessoa_vendedor,');
        SQL.Add('       cod_forma_pagamento_os = :cod_forma_pagamento_os,');
        SQL.Add('       cod_identificacao_dupla = :cod_identificacao_dupla,');
        SQL.Add('       cod_fabricante_identificador = :cod_fabricante_identificador,');
        SQL.Add('       cod_forma_pagamento_ident = :cod_forma_pagamento_ident,');
        SQL.Add('       cod_modelo_identificador_1 = :cod_modelo_identificador_1,');
        SQL.Add('       cod_modelo_identificador_2 = :cod_modelo_identificador_2,');
        SQL.Add('       cod_produto_acessorio_1 = :cod_produto_acessorio_1,');
        SQL.Add('       qtd_produto_acessorio_1 = :qtd_produto_acessorio_1,');
        SQL.Add('       cod_produto_acessorio_2 = :cod_produto_acessorio_2,');
        SQL.Add('       qtd_produto_acessorio_2 = :qtd_produto_acessorio_2,');
        SQL.Add('       cod_produto_acessorio_3 = :cod_produto_acessorio_3,');
        SQL.Add('       qtd_produto_acessorio_3 = :qtd_produto_acessorio_3,');
        SQL.Add('       txt_observacao = :txt_observacao,');
        SQL.Add('       ind_envia_pedido_ident = :ind_envia_pedido_ident,');
        SQL.Add('       txt_observacao_pedido = :txt_observacao_pedido,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate(),');
        SQL.Add('       ind_animais_registrados = :ind_animais_registrados');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('qtd_animais').AsInteger := QtdAnimais;
        ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;
        if IndAtualizarUsuarioPedido then
        begin
          ParamByName('cod_usuario_pedido').AsInteger := Conexao.CodUsuario;
        end;

        AtribuiParametro(QueryLocal, CodPessoaTecnico, 'cod_pessoa_tecnico', -1);
        AtribuiParametro(QueryLocal, CodPessoaVendedor, 'cod_pessoa_vendedor', -1);
        AtribuiParametro(QueryLocal, CodFormaPagamentoOS, 'cod_forma_pagamento_os', -1);
        AtribuiParametro(QueryLocal, CodIdentificacaoDupla, 'cod_identificacao_dupla', -1);
        AtribuiParametro(QueryLocal, CodFabricanteIdentificador, 'cod_fabricante_identificador', -1);
        AtribuiParametro(QueryLocal, CodFormaPagamentoIdent, 'cod_forma_pagamento_ident', -1);
        AtribuiParametro(QueryLocal, CodModeloIdentificador1, 'cod_modelo_identificador_1', -1);
        AtribuiParametro(QueryLocal, CodModeloIdentificador2, 'cod_modelo_identificador_2', -1);
        AtribuiParametro(QueryLocal, CodProdutoAcessorio1, 'cod_produto_acessorio_1', -1);
        AtribuiParametro(QueryLocal, QtdProdutoAcessorio1, 'qtd_produto_acessorio_1', -1);
        AtribuiParametro(QueryLocal, CodProdutoAcessorio2, 'cod_produto_acessorio_2', -1);
        AtribuiParametro(QueryLocal, QtdProdutoAcessorio2, 'qtd_produto_acessorio_2', -1);
        AtribuiParametro(QueryLocal, CodProdutoAcessorio3, 'cod_produto_acessorio_3', -1);
        AtribuiParametro(QueryLocal, QtdProdutoAcessorio3, 'qtd_produto_acessorio_3', -1);
        AtribuiParametro(QueryLocal, TxtObservacao, 'txt_observacao', '');
        AtribuiParametro(QueryLocal, Conexao.CodUsuario, 'cod_usuario_ultima_alteracao', -1);
        AtribuiParametro(QueryLocal, TxtObservacaoPedido, 'txt_observacao_pedido', '');
        AtribuiParametro(QueryLocal, IndAnimaisRegistrados, 'ind_animais_registrados', '');

        ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
        //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, 552);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Atualiza o número da ordem de serviço na tabela de sequencial
      // se ele foi alterado.
      if NumOSAtual <> NumOrdemServico then
      begin
        Result := AtualizaNumOrdemServico(Conexao, Mensagens, NumOrdemServico);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      Rollback();
      Mensagens.Adicionar(1817, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1817;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.AtributoValido(ValorAtual,
  ValorDestino: Integer; IndPodeAlterar, IndRequerido, IndMensagem: String;
  CodMensagemRequerido, CodMensagemAlterar, CodMensagemAviso: Integer): Integer;
begin
  Result := 0;

  // Verifica se o valor pode ser alterado
  if UpperCase(IndPodeAlterar) = 'N' then
  begin
    if ValorAtual <> ValorDestino then
    begin
      Result := CodMensagemAlterar;
      Exit;
    end;
  end;

  // Verifica se o campo é obrigatório
  if UpperCase(IndRequerido) = 'S' then
  begin
    if ValorDestino = -1 then
    begin
      Result := CodMensagemRequerido;
      Exit;
    end;
  end;

  if UpperCase(IndMensagem) = 'S' then
  begin
    if ValorAtual <> ValorDestino then
    begin
      Result := CodMensagemAviso;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.AtributoValido(ValorAtual,
  ValorDestino, IndPodeAlterar, IndRequerido, IndMensagem: String;
  CodMensagemRequerido, CodMensagemAlterar, CodMensagemAviso: Integer): Integer;
begin
  Result := 0;

  // Verifica se o valor pode ser alterado
  if UpperCase(IndPodeAlterar) = 'N' then
  begin
    if ValorAtual <> ValorDestino then
    begin
      Result := CodMensagemAlterar;
      Exit;
    end;
  end;

  // Verifica se o campo é obrigatório
  if UpperCase(IndRequerido) = 'S' then
  begin
    if ValorDestino = '' then
    begin
      Result := CodMensagemRequerido;
      Exit;
    end;
  end;

  if UpperCase(IndMensagem) = 'S' then
  begin
    if ValorAtual <> ValorDestino then
    begin
      Result := CodMensagemAviso;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.AtualizaNumOrdemServico(EConexao: TConexao;
  EMensagens: TIntMensagens; NumOrdemServico: Integer): Integer;
const
  NomeMetodo = 'AtualizaNumOrdemServico';
var
  QueryLocal: THerdomQuery;
  ParObterCodigoAutomatico: String;
begin
  Result := 0;
  try
    // Busca o parametro
    ParObterCodigoAutomatico := EConexao.ValorParametro(78, EMensagens);

    // Verifica se a geração do código é automatica ou manual
    if UpperCase(ParObterCodigoAutomatico) = 'S' then
    begin
      QueryLocal := THerdomQuery.Create(EConexao, nil);
      try
        with QueryLocal do
        begin
          // Inicia uma transação separada para a obtenção do proximo código da OS
          EConexao.BeginTran('OBTER_PROXIMO_CODIGO_OS');
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select num_seq_ordem_servico from tab_seq_ordem_servico');
{$ENDIF}
          Open;

          // Se o número da OS na tabela de sequencial for menor que o código
          // informado finaliza a função
          if FieldByName('num_seq_ordem_servico').AsInteger >= NumOrdemServico then
          begin
            EConexao.Commit('OBTER_PROXIMO_CODIGO_OS');
            Exit;
          end;

          // Atualiza o número da OS
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('update tab_seq_ordem_servico ');
          SQL.Add('   set num_seq_ordem_servico = :num_seq_ordem_servico');
{$ENDIF}
          ParamByName('num_seq_ordem_servico').AsInteger := NumOrdemServico;

          // Atualiza o registro e verifica se a operação
          // foi realizada com sucesso
          if ExecSQL() = 0 then
          begin
            EConexao.Rollback('OBTER_PROXIMO_CODIGO_OS');
            EMensagens.Adicionar(1760, Self.ClassName, NomeMetodo, ['Erro inesperado.']);
            Result := -1760;
            Exit;
          end;
          EConexao.Commit('OBTER_PROXIMO_CODIGO_OS');
        end;
      finally
        QueryLocal.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback('OBTER_PROXIMO_CODIGO_OS');
      EMensagens.Adicionar(1760, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1760;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.Buscar(CodOrdemServico: Integer): Integer;
const
  NomeMetodo = 'Buscar';
var
  IndAcessoLiberado: Boolean;
  QueryLocal: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(551) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('exec spt_buscar_dados_os ' + IntToStr(CodOrdemServico));
{$ENDIF}
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('CodPessoaProdutor').AsInteger, False);
        if Result < 0 then
        begin
          Exit;
        end;
      end;

      If not IndAcessoLiberado Then Begin
        Mensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
        Result := -1744;
        Exit;
      End;

      Result := PreecheEstruturaOrdemServico(QueryLocal);
      if Result < 0 then
      begin
        Exit;
      end;

      Result := 0;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1761, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1761;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.BuscarResumido(
  CodOrdemServico: Integer): Integer;
const
  NomeMetodo = 'BuscarResumido';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(548) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  QueryLocal := THerdomQuery.Create(Conexao, nil);
  try
    try
      with QueryLocal do
      begin
        SQL.Clear;
  {$IFDEF MSSQL}
        SQL.Add('  SELECT tos.cod_ordem_servico,');
        SQL.Add('         tos.num_ordem_servico,');
        SQL.Add('         tos.cod_pessoa_produtor,');
        SQL.Add('         tpr.sgl_produtor,');
        SQL.Add('         tpp.nom_pessoa,');
        SQL.Add('         tpp.num_cnpj_cpf,');
        SQL.Add('         tos.cod_propriedade_rural,');
        SQL.Add('         tppr.nom_propriedade_rural,');
        SQL.Add('         tppr.num_imovel_receita_federal,');
        SQL.Add('         tos.qtd_animais,');
        SQL.Add('         tos.dta_envio,');
        SQL.Add('         tos.nom_servico_envio,');
        SQL.Add('         tos.num_conhecimento,');
        SQL.Add('         tos.cod_situacao_os,');
        SQL.Add('         tsos.sgl_situacao_os,');
        SQL.Add('         tsos.des_situacao_os,');
        SQL.Add('         tls.cod_localizacao_sisbov');
        SQL.Add('    FROM tab_ordem_servico            tos,'); // Ordem de Serviço
        SQL.Add('         tab_produtor                 tpr,'); // Produtor
        SQL.Add('         tab_pessoa                   tpp,'); // Dados pessoais do produtor
        SQL.Add('         tab_propriedade_rural        tppr,'); // Propriedade rural
        SQL.Add('         tab_situacao_os              tsos,'); // Situação atual da OS
        SQL.Add('         tab_localizacao_sisbov       tls'); // Código de exportação da fazenda (cod_localizacao_sisbov)
        SQL.Add('   WHERE tpr.cod_pessoa_produtor = tos.cod_pessoa_produtor');
        SQL.Add('     AND tpp.cod_pessoa = tos.cod_pessoa_produtor');
        SQL.Add('     AND tppr.cod_propriedade_rural = tos.cod_propriedade_rural');
        SQL.Add('     AND tpp.cod_pessoa = tls.cod_pessoa_produtor');
        SQL.Add('     AND tppr.cod_propriedade_rural = tls.cod_propriedade_rural');
        SQL.Add('     AND tsos.cod_situacao_os = tos.cod_situacao_os');
        SQL.Add('     AND tos.cod_ordem_servico = :cod_ordem_servico');
  {$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;
      end;

      if QueryLocal.IsEmpty then
      begin
        Mensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
        Result := -1744;
        Exit;
      end;

      Result := VerificaPermissao(Conexao, Mensagens,
        IndAcessoLiberado,
        QueryLocal.FieldByName('cod_pessoa_produtor').AsInteger, False);
      if Result < 0 then
      begin
        Exit;
      end;

      If not IndAcessoLiberado Then Begin
        Mensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
        Result := -1744;
        Exit;
      End;

      with QueryLocal do
      begin
        FOrdemServicoResumida.CodOrdemServico             := FieldByName('cod_ordem_servico').AsInteger;
        FOrdemServicoResumida.NumOrdemServico             := FieldByName('num_ordem_servico').AsInteger;
        FOrdemServicoResumida.CodPessoaProdutor           := FieldByName('cod_pessoa_produtor').AsInteger;
        FOrdemServicoResumida.NomProdutor                 := FieldByName('nom_pessoa').AsString;
        FOrdemServicoResumida.SglProdutor                 := FieldByName('sgl_produtor').AsString;
        FOrdemServicoResumida.NumCNPJCPFProdutorFormatado := FormataCnpjCpf(FieldByName('num_cnpj_cpf').AsString);
        FOrdemServicoResumida.CodPropriedadeRural         := FieldByName('cod_propriedade_rural').AsInteger;
        FOrdemServicoResumida.NomPropriedadeRural         := FieldByName('nom_propriedade_rural').AsString;
        FOrdemServicoResumida.NumImovelReceitaFederal     := FieldByName('num_imovel_receita_federal').AsString;
        FOrdemServicoResumida.QtdAnimais                  := FieldByName('qtd_animais').AsInteger;
        FOrdemServicoResumida.CodSituacaoOS               := FieldByName('cod_situacao_os').AsInteger;
        FOrdemServicoResumida.SglSituacaoOS               := FieldByName('sgl_situacao_os').AsString;
        FOrdemServicoResumida.DesSituacaoOS               := FieldByName('des_situacao_os').AsString;
        FOrdemServicoResumida.CodLocalizacaoSisbov        := FieldByName('cod_localizacao_sisbov').AsInteger;

        FOrdemServicoResumida.DtaEnvioPedido              := FieldByName('dta_envio').AsDateTime;
        FOrdemServicoResumida.NomServicoEnvio             := FieldByName('nom_servico_envio').AsString;
        FOrdemServicoResumida.NroConhecimento             := FieldByName('num_conhecimento').AsString;
      end;

      Result := 0;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1761, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1761;
      Exit;
    end;
  end;
end;

constructor TIntOrdensServico.Create;
begin
  inherited;
  FOrdemServico := TIntOrdemServico.Create;
  FIntEnderecos := TIntEnderecos.Create;
  FOrdemServico.EnderecoEntregaCert := TIntEndereco.Create;
  FOrdemServico.EnderecoEntregaIdent := TIntEndereco.Create;
  FOrdemServico.EnderecoCobrancaIdent := TIntEndereco.Create;
  FOrdemServicoResumida := TIntOrdemServicoResumida.Create;
end;

destructor TIntOrdensServico.Destroy;
begin
  FOrdemServico.EnderecoEntregaCert.Free;
  FOrdemServico.EnderecoEntregaIdent.Free;
  FOrdemServico.EnderecoCobrancaIdent.Free;
  FOrdemServico.Free;
  FOrdemServicoResumida.Free;
  FIntEnderecos.Free;
  inherited;
end;

function TIntOrdensServico.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
 Result := FIntEnderecos.Inicializar(ConexaoBD, Mensagens);
 if Result < 0 then
 begin
   Exit;
 end;

 Result := (inherited Inicializar(ConexaoBD, Mensagens));
end;

class function TIntOrdensServico.InsereHistoricoSituacao(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, CodSituacaoOS: Integer;
  TxtObservacao: String): Integer;
const
  NomeMetodo = 'InsereHistoricoSituacao';
var
  QueryLocal: THerdomQuery;
begin
  Result := 0;
  
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
        // Monta a query de inserção do registro
{$IFDEF MSSQL}
        SQL.Add('insert into tab_historico_situacao_os (');
        SQL.Add('  cod_ordem_servico,');
        SQL.Add('  cod_situacao_os,');
        SQL.Add('  dta_mudanca_situacao,');
        SQL.Add('  cod_usuario,');
        SQL.Add('  txt_observacao');
        SQL.Add(') values (');
        SQL.Add('  :cod_ordem_servico,');
        SQL.Add('  :cod_situacao_os,');
        SQL.Add('  getDate(),');
        SQL.Add('  :cod_usuario,');
        SQL.Add('  :txt_observacao');
        SQL.Add(')');
{$ENDIF}
        // Atualiza os aprametros
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('cod_usuario').AsInteger := EConexao.CodUsuario;
        // Verifica o valor do parametro TxtObservacao
        if TxtObservacao <> '' then
        begin // se for diferente de vazio passa o valor
          ParamByName('txt_observacao').AsString := TxtObservacao;
        end
        else
        begin // Se o campo for vazio insere nulo
          ParamByName('txt_observacao').DataType := ftString;
          ParamByName('txt_observacao').Clear;
          ParamByName('txt_observacao').Bound := True;
        end;

        ExecSQL;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EMensagens.Adicionar(1762, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1762;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.Inserir(EConexao: TConexao;
                                         EMensagens: TIntMensagens;
                                         NumOrdemServico,
                                         CodPessoaProdutor: Integer;
                                         SglProdutor,
                                         NumCNPJCPFProdutor: String;
                                         CodPropriedadeRural: Integer;
                                         NumImovelReceitaFederal: String;
                                         CodLocalizacaoSisbov,
                                         QtdAnimais: Integer;
                                         IndEnviaPedidoIdent: String;
                                         IndChamadaInterna: String = 'S'): Integer;
const
  NomeMetodo = 'Inserir';
var
  QueryLocal: THerdomQuery;
  Contador: Integer;
  CodOrdemServico: Integer;
  CodEnderecoEntregaCert: Integer;
  CodIdentificacaoDupla: Integer;
  CodFabricanteIdentificador: Integer;
  CodEnderecoEntregaIdent: Integer;
  CodEnderecoCobrancaIdent: Integer;
  CodRegistroLog: Integer;
  CodPessoaTecnico: Integer;
  IndAcessoLiberado: Boolean;
  CodModeloIdentificador1: Integer;
  CodModeloIdentificador2: Integer;
  IndAnimaisRegistrados: String;
begin
  // Verifica se usuário pode executar método
  if not EConexao.PodeExecutarMetodo(552) then
  begin
    EMensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      if EConexao.CodPapelUsuario = 9 then
      begin
        QueryLocal.SQL.Clear;
        QueryLocal.SQL.Add(' select 1 ');
        QueryLocal.SQL.Add('   from tab_tecnico tt ');
        QueryLocal.SQL.Add('      , tab_tecnico_produtor ttp ');
        QueryLocal.SQL.Add('  where tt.cod_pessoa_tecnico   = ttp.cod_pessoa_tecnico ');
        QueryLocal.SQL.Add('    and tt.cod_pessoa_gestor    = :cod_pessoa_gestor ');
        QueryLocal.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        QueryLocal.SQL.Add('    and tt.dta_fim_validade     is null ');
        QueryLocal.SQL.Add('    and ttp.dta_fim_validade    is null ');
        QueryLocal.ParamByName('cod_pessoa_gestor').AsInteger   := EConexao.CodPessoa;
        QueryLocal.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        QueryLocal.Open;

        if QueryLocal.IsEmpty then
        begin
          EMensagens.Adicionar(2197, Self.ClassName, NomeMetodo, []);
          Result := -2197;
          Exit;
        end;
      end;

      // Valida o numero da OS
      if IndChamadaInterna <> 'S' then
      begin
        if NumOrdemServico < 1 then
        begin
          EMensagens.Adicionar(1763, Self.ClassName, NomeMetodo, []);
          Result := -1763;
          Exit;
        end;
      end;

      // Verifica se já existe uma OS com este número na base de dados.
      if NumOrdemServico > 0 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select num_ordem_servico');
          SQL.Add('  from tab_ordem_servico');
          SQL.Add(' where num_ordem_servico = :num_ordem_servico');
          SQL.Add('   and cod_situacao_os <> :cod_situacao_os');
{$ENDIF}
          ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
          ParamByName('cod_situacao_os').AsInteger := cCodSituacaoOSCancelada;
          Open;

          if not IsEmpty then
          begin
            EMensagens.Adicionar(1764, Self.ClassName, NomeMetodo, []);
            Result := -1764;
            Exit;
          end;
        end;
      end;

      // Sómente um dos valores CodPessoaProdutor, SglProdutor
      // e NumCNPJCPFProdutor deve ser infrmando
      Contador := 0;
      if CodPessoaProdutor > -1 then
        Inc(Contador);
      if SglProdutor <> '' then
        Inc(Contador);
      if NumCNPJCPFProdutor <> '' then
        Inc(Contador);
      if Contador <> 1 then
      begin
        EMensagens.Adicionar(1765, Self.ClassName, NomeMetodo, []);
        Result := -1765;
        Exit;
      end;

      // Deve ser S ou N
      if (IndEnviaPedidoIdent <> 'S') and (IndEnviaPedidoIdent <> 'N') then
      begin
        EMensagens.Adicionar(1871, Self.ClassName, NomeMetodo, []);
        Result := -1871;
        Exit;
      end;

      // Se o parametro SglProdutor foi informado busca o código do produtor
      if SglProdutor <> '' then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select cod_pessoa_produtor');
          SQL.Add('  from tab_produtor');
          SQL.Add(' where sgl_produtor = :sgl_produtor');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('sgl_produtor').AsString := SglProdutor;
          Open;

          if IsEmpty then
          begin
            EMensagens.Adicionar(1768, Self.ClassName, NomeMetodo, [SglProdutor]);
            Result := -1768;
            Exit;
          end;

          CodPessoaProdutor := FieldByName('cod_pessoa_produtor').AsInteger;
        end;
      end;

      // Se o parametro NumCNPJCPFProdutor foi informado busca o código do produtor
      if NumCNPJCPFProdutor <> '' then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select tpr.cod_pessoa_produtor');
          SQL.Add('  from tab_produtor tpr,');
          SQL.Add('       tab_pessoa tp');
          SQL.Add(' where tp.cod_pessoa = tpr.cod_pessoa_produtor');
          SQL.Add('   and tp.num_cnpj_cpf = :num_cnpj_cpf');
          SQL.Add('   and tp.dta_fim_validade is null');
          SQL.Add('   and tpr.dta_fim_validade is null');
{$ENDIF}
          ParamByName('num_cnpj_cpf').AsString := NumCNPJCPFProdutor;
          Open;

          if IsEmpty then
          begin
            EMensagens.Adicionar(1769, Self.ClassName, NomeMetodo, [NumCNPJCPFProdutor]);
            Result := -1769;
            Exit;
          end;

          CodPessoaProdutor := FieldByName('cod_pessoa_produtor').AsInteger;
        end;
      end;

      // Sómente um dos valores CodPropriedadeRural ou
      // NumImovelReceitaFederal deve ser informando
      if (CodPropriedadeRural > -1) and (NumImovelReceitaFederal <> '') then
      begin
        EMensagens.Adicionar(1766, Self.ClassName, NomeMetodo, []);
        Result := -1766;
        Exit;
      end;

      CodPropriedadeRural := TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(EConexao, EMensagens, NumImovelReceitaFederal,
                                                                                      CodPropriedadeRural, CodLocalizacaoSisbov, CodPessoaProdutor,
                                                                                      True);
      if CodPropriedadeRural < 0 then
      begin
        Result := CodPropriedadeRural;
        Exit;
      end;

      // Verifica se o usuario tem acesso permissão para este produtor
      Result := VerificaPermissao(EConexao, EMensagens, IndAcessoLiberado,
        CodPessoaProdutor, True);
      if (Result < 0) or (not IndAcessoLiberado) then
      begin
        Exit;
      end;

      // A quantidade de animais da OS deve ser maior que 0 e menor
      // que o limite de animais
      if (QtdAnimais < 1) or (QtdAnimais > cLimiteQtdAnimais) then
      begin
        EMensagens.Adicionar(1773, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
        Result := -1773;
        Exit;
      end;

      // Obtem o sequencial da OS
      Result := ProximoCodigoOS(EConexao, EMensagens, CodOrdemServico);
      if Result < 0 then
      begin
        Exit;
      end;

      // Define o valor padrão dos modelos de identificador.
      CodModeloIdentificador1 := -1;
      CodModeloIdentificador2 := -1;

      // Obter o dado do ultimo endereço, fabricante e identificadores
      // informados para facilitar o cadastro
      Result := ObtemDadosUltimaOrdemServicoProdutor(EConexao, EMensagens,
        CodPessoaProdutor, CodPropriedadeRural, IndEnviaPedidoIdent,
        CodEnderecoEntregaCert, CodIdentificacaoDupla,
        CodFabricanteIdentificador, CodEnderecoEntregaIdent,
        CodEnderecoCobrancaIdent);
      if Result < 0 then
      begin
        Exit;
      end;

      CodPessoaTecnico := -1;
      // Se o usuário for um técnico, insere a OS com o atributo
      // cod_pessoa_tecnico igual ao do técnico
      if EConexao.CodPapelUsuario = 3 then
      begin
        CodPessoaTecnico := EConexao.CodPessoa;
      end;

      // Verifica se o fabricante é válido
      if CodFabricanteIdentificador > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select 1');
          SQL.Add('  from tab_fabricante_identificador');
          SQL.Add(' where cod_fabricante_identificador = :cod_fabricante_identificador');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          Open;

          // Se o fabricante não for mais válido então não grava o fabricante
          if IsEmpty then
          begin
            CodFabricanteIdentificador := -1;
          end;
        end;
      end;

      // Verifica se a identificação dupla é válida
      if CodIdentificacaoDupla > -1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select 1');
          SQL.Add('  from tab_identificacao_dupla');
          SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
          Open;

          // Se a identificação não for mais válida então grava NULL
          if IsEmpty then
          begin
            CodIdentificacaoDupla := -1;
          end;
        end;
      end;

      // Verifica se o fabricante possui um modelo para a identificacao dupla
      // informada
      if (CodFabricanteIdentificador > -1) and (CodIdentificacaoDupla > -1) then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select IsNull(cod_modelo_identificador_1, -1) as cod_modelo_identificador_1,');
          SQL.Add('       IsNull(cod_modelo_identificador_2, -1) as cod_modelo_identificador_2');
          SQL.Add('  from tab_ident_dupla_modelo_ident');
          SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla');
          SQL.Add('   and cod_fabricante_identificador = :cod_fabricante_identificador');
{$ENDIF}
          ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
          ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          Open;

          // Se o fabricante não possuir um modelo então não grava o fabricante
          if IsEmpty then
          begin
            CodFabricanteIdentificador := -1;
          end
          else
          begin
            CodModeloIdentificador1 := FieldByName('cod_modelo_identificador_1').AsInteger;
            CodModeloIdentificador2 := FieldByName('cod_modelo_identificador_2').AsInteger;
          end;
        end;
      end;

      // Pega próximo CodRegistroLog
      CodRegistroLog := TIntClasseBDNavegacaoBasica.ProximoCodRegistroLog(
        EConexao, EMensagens);
      if CodRegistroLog < 0 then
      begin
        Result := CodRegistroLog;
        Exit;
      end;

      EConexao.BeginTran;

      // Insere a ordem de serviço na base de dados
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('insert into tab_ordem_servico (');
        SQL.Add('  cod_ordem_servico,');
        SQL.Add('  num_ordem_servico,');
        SQL.Add('  cod_pessoa_produtor,');
        SQL.Add('  cod_propriedade_rural,');
        SQL.Add('  qtd_animais,');
        SQL.Add('  dta_cadastramento,');
        SQL.Add('  cod_usuario_cadastramento,');
        SQL.Add('  dta_ultima_alteracao,');
        SQL.Add('  cod_usuario_ultima_alteracao,');
        SQL.Add('  cod_situacao_os,');
        SQL.Add('  cod_endereco_entrega_cert,');
        SQL.Add('  cod_identificacao_dupla,');
        SQL.Add('  cod_fabricante_identificador,');
        SQL.Add('  cod_endereco_entrega_ident,');
        SQL.Add('  ind_envia_pedido_ident,');
        SQL.Add('  cod_endereco_cobranca_ident,');
        SQL.Add('  cod_registro_log,');
        SQL.Add('  cod_pessoa_tecnico,');
        SQL.Add('  cod_modelo_identificador_1,');
        SQL.Add('  cod_modelo_identificador_2,');
        SQL.Add('  ind_animais_registrados');
        SQL.Add(') values (');
        SQL.Add('  :cod_ordem_servico,');
        SQL.Add('  :num_ordem_servico,');
        SQL.Add('  :cod_pessoa_produtor,');
        SQL.Add('  :cod_propriedade_rural,');
        SQL.Add('  :qtd_animais,');
        SQL.Add('  getDate(),');
        SQL.Add('  :cod_usuario_cadastramento,');
        SQL.Add('  getDate(),');
        SQL.Add('  :cod_usuario_ultima_mudanca,');
        SQL.Add('  1,');
        SQL.Add('  :cod_endereco_entrega_cert,');
        SQL.Add('  :cod_identificacao_dupla,');
        SQL.Add('  :cod_fabricante_identificador,');
        SQL.Add('  :cod_endereco_entrega_ident,');
        SQL.Add('  :ind_envia_pedido_ident,');
        SQL.Add('  :cod_endereco_cobranca_ident,');
        SQL.Add('  :cod_registro_log,');
        SQL.Add('  :cod_pessoa_tecnico,');
        SQL.Add('  :cod_modelo_identificador_1,');
        SQL.Add('  :cod_modelo_identificador_2,');
        SQL.Add('  :ind_animais_registrados');
        SQL.Add(')');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        ParamByName('qtd_animais').AsInteger := QtdAnimais;
        ParamByName('cod_usuario_cadastramento').AsInteger := EConexao.CodUsuario;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;
        ParamByName('cod_usuario_ultima_mudanca').AsInteger := EConexao.CodUsuario;
        ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
        AtribuiParametro(QueryLocal, NumOrdemServico, 'num_ordem_servico', -1);
        AtribuiParametro(QueryLocal, CodEnderecoEntregaCert, 'cod_endereco_entrega_cert', -1);
        AtribuiParametro(QueryLocal, CodIdentificacaoDupla, 'cod_identificacao_dupla', -1);
        AtribuiParametro(QueryLocal, CodFabricanteIdentificador, 'cod_fabricante_identificador', -1);
        AtribuiParametro(QueryLocal, CodEnderecoEntregaIdent, 'cod_endereco_entrega_ident', -1);
        AtribuiParametro(QueryLocal, CodEnderecoCobrancaIdent, 'cod_endereco_cobranca_ident', -1);
        AtribuiParametro(QueryLocal, CodPessoaTecnico, 'cod_pessoa_tecnico', -1);
        AtribuiParametro(QueryLocal, CodModeloIdentificador1, 'cod_modelo_identificador_1', -1);
        AtribuiParametro(QueryLocal, CodModeloIdentificador2, 'cod_modelo_identificador_2', -1);
        If IndEnviaPedidoIdent = 'S' then
          IndAnimaisRegistrados := EConexao.ValorParametro(92, EMensagens)
        else
          IndAnimaisRegistrados := '';

        AtribuiParametro(QueryLocal, IndAnimaisRegistrados, 'ind_animais_registrados', '');

        // Insereo registro
        ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
        //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := TIntClasseBDNavegacaoBasica.GravarLogOperacao(EConexao,
          EMensagens, 'tab_ordem_servico', CodRegistroLog, 1, 552);
        if Result < 0 then begin
          EConexao.Rollback;
          Exit;
        end;

        Result := InsereHistoricoSituacao(EConexao, EMensagens, CodOrdemServico,
          1, '');
        if Result < 0 then
        begin
          EConexao.Rollback;
          Exit;
        end;

        if NumOrdemServico > 0 then
        begin
          Result := AtualizaNumOrdemServico(EConexao, EMensagens, NumOrdemServico);
          if Result < 0 then
          begin
            EConexao.Rollback;
            Exit;
          end;
        end;

        EConexao.Commit;
      end;
      Result := CodOrdemServico;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1774, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1774;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.ObtemDadosUltimaOrdemServicoProdutor(
  EConexao: TConexao; EMensagens: TIntMensagens; CodPessoaProdutor,
  CodPropriedadeRural: Integer; IndEnviaPedidoIdent: String;
  var CodEnderecoEntregaCert, CodIdentificacaoDupla, CodFabricanteIdentificador,
  CodEnderecoEntregaIdent, CodEnderecoCobrancaIdent: Integer): Integer;
const
  NomeMetodo = 'ObtemDadosUltimaOrdemServicoProdutor';
var
  QueryLocal: THerdomQuery;
begin
  Result := 0;
  CodEnderecoEntregaCert := -1;
  CodIdentificacaoDupla := -1;
  CodFabricanteIdentificador := -1;
  CodEnderecoEntregaIdent := -1;
  CodEnderecoCobrancaIdent := -1;

  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select top 1 num_ordem_servico,');
        SQL.Add('       isNull(cod_endereco_entrega_cert, -1) as cod_endereco_entrega_cert,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla,');
        SQL.Add('       isNull(cod_fabricante_identificador, -1) as cod_fabricante_identificador,');
        SQL.Add('       isNull(cod_endereco_entrega_ident, -1) as cod_endereco_entrega_ident,');
        SQL.Add('       isNull(cod_endereco_cobranca_ident, -1) as cod_endereco_cobranca_ident');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        SQL.Add('   and ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('order by dta_cadastramento desc');
{$ENDIF}
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;
        Open;

        if IsEmpty then
        begin
          Exit;
        end;

        CodEnderecoEntregaCert := FieldByName('cod_endereco_entrega_cert').AsInteger;
        CodIdentificacaoDupla := FieldByName('cod_identificacao_dupla').AsInteger;
        CodFabricanteIdentificador := FieldByName('cod_fabricante_identificador').AsInteger;
        CodEnderecoEntregaIdent := FieldByName('cod_endereco_entrega_ident').AsInteger;
        CodEnderecoCobrancaIdent := FieldByName('cod_endereco_cobranca_ident').AsInteger;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EMensagens.Adicionar(1774, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1774;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.ObtemValorSequencial(EConexao: TConexao;
  EMensagens: TIntMensagens; NomeCampo: String;
  var ValorCampo: Integer): Integer;
const
  NomeMetodo = 'ObtemValorSequencial';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        // Inicia uma transação separada para a obtenção do proximo código da OS
        EConexao.BeginTran('OBTER_PROXIMO_CODIGO_OS');

        // Atualiza os códigos
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_seq_ordem_servico ');
        SQL.Add('   set ' + NomeCampo + ' = ' + NomeCampo + ' + 1');
{$ENDIF}
        ExecSQL;

        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select ' + NomeCampo + ' from tab_seq_ordem_servico');
{$ENDIF}
        Open;

        If IsEmpty Then Begin
          EConexao.Rollback('OBTER_PROXIMO_CODIGO_OS');
          EMensagens.Adicionar(1775, Self.ClassName, NomeMetodo, ['Tabela vazia']);
          Result := -1775;
          Exit;
        End;

        ValorCampo := FieldByName(nomeCampo).AsInteger;
        Close;

        // Confirma Transação
        EConexao.Commit('OBTER_PROXIMO_CODIGO_OS');
        Result := 0;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback('OBTER_PROXIMO_CODIGO_OS');
      EMensagens.Adicionar(1775, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1775;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.ObterProximoNumero(EConexao: TConexao; EMensagens: TIntMensagens): Integer;
const
  NomeMetodo = 'ObterProximoCodigo';
var
  ParObterCodigoAutomatico: String;
  ValProximoNumOS: Integer;
begin
  // Verifica se usuário pode executar método
  if not EConexao.PodeExecutarMetodo(550) then
  begin
    EMensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    // Busca o parametro
    ParObterCodigoAutomatico := EConexao.ValorParametro(78, EMensagens);

    // Verifica se a geração do código é automatica ou manual
    if UpperCase(ParObterCodigoAutomatico) = 'S' then
    begin // Geração automática
      Result := ProximoNumeroOS(ValProximoNumOS, EConexao, EMensagens);
      if Result >= 0 then
        Result := ValProximoNumOS;
    end
    else
    begin // Geração Manual
      Result := 0;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1776, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1776;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.OrdemServico: TIntOrdemServico;
const
  NomeMetodo = 'OrdemServico';
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  Result := FOrdemServico;
end;

function TIntOrdensServico.OrdemServicoResumida: TIntOrdemServicoResumida;
begin
  Result := FOrdemServicoResumida;
end;

function TIntOrdensServico.Pesquisar(NumOrdemServico: Integer;
                                     SglProdutor,
                                     NomProdutor,
                                     NumCNPJCPFProdutor,
                                     NumImovelReceitaFederal: String;
                                     CodLocalizacaoSisbov: Integer;
                                     NomPropriedadeRural,
                                     NumCNPJCPFTecnico,
                                     NumCNPJCPFVendedor: String;
                                     QtdAnimaisInicio,
                                     QtdAnimaisFim,
                                     NumSolicitacaoSISBOV: Integer;
                                     IndApenasSemEnderecoEntregaCert: String;
                                     CodIdentificacaoDupla,
                                     CodFabricanteIdentificador: Integer;
                                     IndEnviaPedidoIdentificador,
                                     IndApenasSemEnderecoEntregaIdent,
                                     IndApenasSemEnderecoCobrancaIdent: String;
                                     NumPedidoFabricante,
                                     NumRemessa: Integer;
                                     DtaCadastramentoInicio,
                                     DtaCadastramentoFim,
                                     DtaMudancaSituacaoInicio,
                                     DtaMudancaSituacaoFim: TDateTime;
                                     CodSituacaoOS,
                                     CodPaisSISBOV,
                                     CodEstadoSISBOV,
                                     CodMicroRegiaoSISBOV,
                                     CodAnimalSISBOV,
                                     CodSituacaoSISBOVSim,
                                     CodSituacaoSISBOVNao: Integer;
                                     DtaSituacaoSISBOVSimInicio,
                                     DtaSituacaoSISBOVSimFim: TDateTime;
                                     NumDiasBoletoAVencer,
                                     NumDiasBoletoEmAtraso,
                                     NumDiasBoletoPago,
                                     CodSituacaoBoleto: Integer;
                                     CodOrdenacao,
                                     IndordenacaoCrescent: String): Integer;
const
  NomeMetodo = 'Pesquisar';
var
  Max, QtdDiasIntervalo: Integer;
  OrdenacaoCrescent: String;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(554) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Obtem parâmetro com o número máximo de OS para pesquisa
  Try
    Max := StrToInt(ValorParametro(cParametroQtdOSPesquisa));
    QtdDiasIntervalo := StrToInt(ValorParametro(cParametroQtdDiasIntervaloPesquisa));
  Except
    Result := -1;
    Exit;
  End;

  // Verifica se a data de inicio do cadastramento é menor que a data fim.
  if (DtaCadastramentoInicio <> 0) and (DtaCadastramentoFim <> 0)
    and (DtaCadastramentoInicio > DtaCadastramentoFim) then
  begin
    Mensagens.Adicionar(1953, Self.ClassName, NomeMetodo, []);
    Result := -1953;
    Exit;
  end;

  { Verifica se a o período de filtro de códigos SISBOV foi informado
    sem a situação }
  if (CodSituacaoSISBOVSim = -1) and ((DtaSituacaoSISBOVSimInicio <> 0) or
    (DtaSituacaoSISBOVSimFim <> 0)) then
  begin
    Mensagens.Adicionar(2064, Self.ClassName, NomeMetodo, [6]);
    Result := -2064;
    Exit;
  end;

  // Verifica se a situação dos códigos SISBOV foi informada sem o período
  if (CodSituacaoSISBOVSim > -1) and ((DtaSituacaoSISBOVSimInicio = 0) or
    (DtaSituacaoSISBOVSimFim = 0) or
    (DtaSituacaoSISBOVSimFim - DtaSituacaoSISBOVSimInicio > QtdDiasIntervalo)) then
  begin
    Mensagens.Adicionar(2063, Self.ClassName, NomeMetodo, [IntToStr(QtdDiasIntervalo)]);
    Result := -2063;
    Exit;
  end;

  if (DtaSituacaoSISBOVSimFim > 0) and (DtaSituacaoSISBOVSimInicio > 0) and
    (DtaSituacaoSISBOVSimInicio > DtaSituacaoSISBOVSimFim) then
  begin
    Mensagens.Adicionar(2109, Self.ClassName, NomeMetodo, []);
    Result := -2109;
    Exit;
  end;

  // Verifica se a situação não foi escolhida sem a situação sim
  if (CodSituacaoSISBOVSim = -1) and (CodSituacaoSISBOVNao > -1) then
  begin
    Mensagens.Adicionar(2065, Self.ClassName, NomeMetodo, []);
    Result := -2065;
    Exit;
  end;

  // Verifica se a situação não foi escolhida sem a situação sim
  if (CodSituacaoSISBOVSim = -1) and (CodSituacaoSISBOVNao > -1) then
  begin
    Mensagens.Adicionar(2065, Self.ClassName, NomeMetodo, []);
    Result := -2065;
    Exit;
  end;

  // Verifica se a data de inicio da mundança de situação é menor que a data fim.
  if (DtaMudancaSituacaoInicio <> 0) and (DtaMudancaSituacaoFim <> 0)
    and (DtaMudancaSituacaoInicio > DtaMudancaSituacaoFim) then
  begin
    Mensagens.Adicionar(1954, Self.ClassName, NomeMetodo, []);
    Result := -1954;
    Exit;
  end;

  // Se o código SISBOV foi informado verifica se ele foi informado corretamente
  if (CodPaisSISBOV > -1) or (CodEstadoSISBOV > -1)
    or (CodMicroRegiaoSISBOV > -1) or (CodAnimalSISBOV > -1) then
  begin
    // Verifica se todos os valores foram informados
    if (CodPaisSISBOV < 0) or (CodEstadoSISBOV < 0)
      or (CodMicroRegiaoSISBOV < -1) or (CodAnimalSISBOV < 0) then
    begin
      Mensagens.Adicionar(2066, Self.ClassName, NomeMetodo, []);
      Result := -2066;
      Exit;
    end;
  end;

  // Verifica se o parametro é S ou N
  IndApenasSemEnderecoEntregaCert := UpperCase(IndApenasSemEnderecoEntregaCert);
  if (IndApenasSemEnderecoEntregaCert <> 'S')
    and (IndApenasSemEnderecoEntregaCert <> 'N') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndApenasSemEnderecoEntregaCert']);
    Result := -1895;
    Exit;
  end;

  // Verifica se o parametro é S ou N
  IndEnviaPedidoIdentificador := UpperCase(IndEnviaPedidoIdentificador);
  if (IndEnviaPedidoIdentificador <> 'S')
    and (IndEnviaPedidoIdentificador <> 'N') and (IndEnviaPedidoIdentificador <> '') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndEnviaPedidoIdentificador']);
    Result := -1895;
    Exit;
  end;

  // Verifica se o parametro é S ou N
  IndApenasSemEnderecoEntregaIdent := UpperCase(IndApenasSemEnderecoEntregaIdent);
  if (IndApenasSemEnderecoEntregaIdent <> 'S')
    and (IndApenasSemEnderecoEntregaIdent <> 'N') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndEnviaPedidoIdentificador']);
    Result := -1895;
    Exit;
  end;

  // Verifica se o parametro é S ou N
  IndApenasSemEnderecoCobrancaIdent := UpperCase(IndApenasSemEnderecoCobrancaIdent);
  if (IndApenasSemEnderecoCobrancaIdent <> 'S')
    and (IndApenasSemEnderecoCobrancaIdent <> 'N')
    and (IndApenasSemEnderecoCobrancaIdent <> '') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndApenasSemEnderecoCobrancaIdent']);
    Result := -1895;
    Exit;
  end;

  // Verifica se o parametro é S ou N
  IndordenacaoCrescent := UpperCase(IndordenacaoCrescent);
  if (IndordenacaoCrescent <> 'S')
    and (IndordenacaoCrescent <> 'N') and (IndordenacaoCrescent <> '') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndordenacaoCrescent']);
    Result := -1895;
    Exit;
  end;

  // Valida os CNPJ/CPF informados
  if not ValidaCnpjCpf(NumCNPJCPFProdutor, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFProdutor]);
    Result := -668;
    Exit;
  end;
  if not ValidaCnpjCpf(NumCNPJCPFVendedor, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFVendedor]);
    Result := -668;
    Exit;
  end;
  if not ValidaCnpjCpf(NumCNPJCPFTecnico, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFTecnico]);
    Result := -668;
    Exit;
  end;

  // Valida o NIRF/INCRA
  if not ValidaNirfIncra(NumImovelReceitaFederal, False) then
  begin
    Mensagens.Adicionar(494, Self.ClassName, NomeMetodo, [NumImovelReceitaFederal]);
    Result := -494;
    Exit;
  end;

  // Verifica se o parametro de ordenação é valido
  if (CodOrdenacao = '') or
    not (ord(CodOrdenacao[1]) in [ord('O'), ord('P'), ord('R'), ord('C'), ord('M')]) then
  begin
    Mensagens.Adicionar(1821, Self.ClassName, NomeMetodo, [NumCNPJCPFTecnico]);
    Result := -1821;
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Clear;
{$IFDEF MSSQL}
      SQL.Add('SELECT DISTINCT top ' + IntToStr(Max) + ' tos.cod_ordem_servico as CodOrdemServico,');
      SQL.Add('       tos.num_ordem_servico as NumOrdemServico,');
      SQL.Add('       tpr.sgl_produtor as SglProdutor,');
      SQL.Add('       tpp.nom_pessoa as NomProdutor,');
      SQL.Add('       tpp.num_cnpj_cpf as NumCNPJCPFProdutor,');
      SQL.Add('       tppr.num_imovel_receita_federal as NumImovelReceitaFederal,');
      SQL.Add('       tppr.nom_propriedade_rural as NomPropriedadeRural,');
      SQL.Add('       tos.qtd_animais as QtdAnimais,');
      SQL.Add('       tfi.nom_reduzido_fabricante as NomReduzidoFabricante,');
      SQL.Add('       tos.dta_cadastramento as DtaCadastramento,');
      SQL.Add('       tos.dta_ultima_alteracao as DtaUltimaAlteracao,');
      SQL.Add('       tsos.sgl_situacao_os as SglSituacaoOS,');
      SQL.Add('       tsos.des_situacao_os as DesSituacaoOS,');
      SQL.Add('       tsos.cod_situacao_os as CodSituacaoOS,');
      SQL.Add('       tls.cod_localizacao_sisbov as CodLocalizacaoSisbov,');
      SQL.Add('       (select top 1 tb.cod_boleto from tab_boleto tb where tb.cod_ordem_servico = tos.cod_ordem_servico) as CodBoleto');
      SQL.Add('  FROM tab_ordem_servico tos -- Ordem de serviço');
      SQL.Add('         LEFT JOIN tab_fabricante_identificador tfi -- Dados do fabricante de identificadores');
      SQL.Add('           ON tos.cod_fabricante_identificador = tfi.cod_fabricante_identificador');
      SQL.Add('         LEFT JOIN tab_arquivo_remessa_pedido tarp -- Dados do arquivo de remessa do pedido');
      SQL.Add('           ON tos.cod_arquivo_remessa_pedido = tarp.cod_arquivo_remessa_pedido');
      SQL.Add('         LEFT JOIN tab_pessoa tpt -- Dados pessoais do tecnico');
      SQL.Add('           ON tos.cod_pessoa_tecnico = tpt.cod_pessoa');
      SQL.Add('         LEFT JOIN tab_pessoa tpv -- Dados pessoais do vendedor');
      SQL.Add('           ON tos.cod_pessoa_vendedor = tpv.cod_pessoa');
      SQL.Add('         LEFT JOIN tab_boleto tb -- Dados de boletos bancários');
      SQL.Add('           ON tb.cod_ordem_servico = tos.cod_ordem_servico, ');
      SQL.Add('       tab_situacao_os tsos, -- Dados da situação da OS');
      SQL.Add('       tab_propriedade_rural tppr, -- Dados da propriedade rural');
      SQL.Add('       tab_produtor tpr, -- Dados do produtor');
      SQL.Add('       tab_localizacao_sisbov tls,');
      // Se o usuário for um tecnico filtrar a OS
      if Conexao.CodPapelUsuario = 1 then
      begin
        SQL.Add('     tab_associacao_produtor tap, -- Produtores que o associação atende');
      end;
      SQL.Add('       tab_pessoa tpp -- Dados pessoais do produtor');
      SQL.Add(' WHERE tos.cod_pessoa_produtor = tpr.cod_pessoa_produtor');
      SQL.Add('   AND tos.cod_pessoa_produtor = tpp.cod_pessoa');
      SQL.Add('   AND tos.cod_propriedade_rural = tppr.cod_propriedade_rural');
      SQL.Add('   AND tos.cod_situacao_os = tsos.cod_situacao_os');
      SQL.Add('   AND tos.cod_pessoa_produtor = tls.cod_pessoa_produtor');
      SQL.Add('   AND tos.cod_propriedade_rural = tls.cod_propriedade_rural');
      // Se o usuário for uma associação de raça filtrar a OS
      if Conexao.CodPapelUsuario = 1 then
      begin
        SQL.Add('   AND tap.cod_pessoa_produtor = tos.cod_pessoa_produtor');
        SQL.Add('   AND tap.cod_pessoa_associacao = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um tecnico filtrar a OS
      else if Conexao.CodPapelUsuario = 3 then
      begin
        SQL.Add('   AND tos.cod_pessoa_tecnico = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um produtor filtrar a OS
      else if Conexao.CodPapelUsuario = 4 then
      begin
        SQL.Add('   AND tpr.cod_pessoa_produtor = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um gestor filtrar por OS relacionadas a técnicos do gestor
      else if Conexao.CodPapelUsuario = 9 then
      begin
        SQL.Add('   AND tos.cod_pessoa_tecnico in (select cod_pessoa_tecnico from tab_tecnico ');
        SQL.Add('                                    where cod_pessoa_gestor = ' + IntToStr(Conexao.CodPessoa) + ')');

      end;


{$ENDIF}

      if NumOrdemServico > -1 then
      begin
        SQL.Add('  AND tos.num_ordem_servico = :num_ordem_servico');
      end;
      if SglProdutor <> '' then
      begin
        SQL.Add('  AND tpr.sgl_produtor = :sgl_produtor');
      end;
      if NomProdutor <> '' then
      begin
        SQL.Add('  AND tpp.nom_pessoa like ''%' + NomProdutor + '%''');
      end;
      if NomPropriedadeRural <> '' then
      begin
        SQL.Add('  AND tppr.nom_propriedade_rural like ''%' + NomPropriedadeRural + '%''');
      end;
      if NumCNPJCPFProdutor <> '' then
      begin
        SQL.Add('  AND tpp.num_cnpj_cpf = :num_cnpj_cpf_produtor');
      end;
      if NumCNPJCPFTecnico <> '' then
      begin
        SQL.Add('  AND tpt.num_cnpj_cpf = :num_cnpj_cpf_tecnico');
      end;
      if NumCNPJCPFVendedor <> '' then
      begin
        SQL.Add('  AND tpv.num_cnpj_cpf = :num_cnpj_cpf_vendedor');
      end;
      if NumImovelReceitaFederal <> '' then
      begin
        SQL.Add('  AND tppr.num_imovel_receita_federal = :num_imovel_receita_federal');
      end;
      if CodLocalizacaoSisbov > 0 then
      begin
        SQL.Add('  AND tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
      end;
      if QtdAnimaisInicio > -1 then
      begin
        SQL.Add('  AND tos.qtd_animais >= :qtd_animais_inicio');
      end;
      if QtdAnimaisFim > -1 then
      begin
        SQL.Add('  AND tos.qtd_animais <= :qtd_animais_fim');
      end;
      if NumSolicitacaoSISBOV > -1 then
      begin
        SQL.Add('  AND tos.num_solicitacao_sisbov = :num_solicitacao_sisbov');
      end;
      if not (UpperCase(IndApenasSemEnderecoEntregaCert) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_entrega_cert is null');
      end;
      if not (UpperCase(IndApenasSemEnderecoEntregaIdent) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_entrega_ident is null');
      end;
      if not (UpperCase(IndApenasSemEnderecoCobrancaIdent) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_cobranca_ident is null');
      end;
      if CodIdentificacaoDupla > -1 then
      begin
        SQL.Add('  AND tos.cod_identificacao_dupla = :cod_identificacao_dupla');
      end;
      if CodFabricanteIdentificador > -1 then
      begin
        SQL.Add('  AND tos.cod_fabricante_identificador = :cod_fabricante_identificador');
      end;
      if NumPedidoFabricante > -1 then
      begin
        SQL.Add('  AND tos.num_pedido_fabricante = :num_pedido_fabricante');
      end;
      if NumRemessa > -1 then
      begin
        SQL.Add('  AND tarp.num_remessa_fabricante = :num_remessa_fabricante');
      end;
      if DtaCadastramentoInicio > 0 then
      begin
        SQL.Add('  AND tos.dta_cadastramento >= :dta_cadastramento_inicio');
      end;
      if DtaCadastramentoFim > 0 then
      begin
        SQL.Add('  AND tos.dta_cadastramento < :dta_cadastramento_fim');
      end;
      if DtaMudancaSituacaoInicio > 0 then
      begin
        SQL.Add('  AND tos.dta_ultima_alteracao >= :dta_ultima_mudanca_situacao_inicio');
      end;
      if DtaMudancaSituacaoFim > 0 then
      begin
        SQL.Add('  AND tos.dta_ultima_alteracao < :dta_ultima_mudanca_situacao_fim');
      end;
      if CodSituacaoOS > -1 then
      begin
        SQL.Add('  AND tos.cod_situacao_os = :cod_situacao_os');
      end;
      if IndEnviaPedidoIdentificador <> '' then
      begin
        SQL.Add('  AND tos.ind_envia_pedido_ident = :ind_envia_pedido_identificador');
      end;
      if CodPaisSISBOV > -1 then
      begin
        SQL.Add('  AND tos.cod_ordem_servico = (');
        SQL.Add('    SELECT cod_ordem_servico FROM tab_codigo_sisbov');
        SQL.Add('     WHERE cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('       AND cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('       AND cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('       AND cod_animal_sisbov = :cod_animal_sisbov)');
      end;
      if CodSituacaoSISBOVSim > -1 then
      begin
        SQL.Add('  AND tos.cod_ordem_servico in (SELECT cod_ordem_servico from tab_codigo_sisbov');
        SQL.Add('  WHERE ' + cNomeCamposSituacaoCodigoSisbov[CodSituacaoSISBOVSim]
          + ' BETWEEN :dta_situacao_sisbov_inicio AND :dta_situacao_sisbov_fim');
        if CodSituacaoSISBOVNao > -1 then
        begin
          SQL.Add('  AND ' + cNomeCamposSituacaoCodigoSisbov[CodSituacaoSISBOVNao]
            + ' IS NULL');
        end;
        SQL.Add(')');
      end;

      if NumDiasBoletoAVencer > 0 then
      begin
        SQL.Add('  AND tb.dta_vencimento_boleto >= getdate() and tb.dta_vencimento_boleto <= :dta_a_vencer');
      end;
      if NumDiasBoletoEmAtraso > 0 then
      begin
        SQL.Add('  AND tb.dta_vencimento_boleto >= :dta_em_atraso and tb.dta_vencimento_boleto <= getdate() ');
      end;
      if NumDiasBoletoPago > 0 then
      begin
        SQL.Add('  AND tb.dta_credito_efetivado >= :dta_pago and tb.dta_credito_efetivado <= getdate() ');
      end;
      if CodSituacaoBoleto > 0 then
      begin
        SQL.Add('  AND tb.cod_situacao_boleto = :cod_situacao_boleto ');
      end;

      // Define a ordenação
      if IndordenacaoCrescent = 'S' then
      begin
        OrdenacaoCrescent := 'asc';
      end
      else
      begin
        OrdenacaoCrescent := 'desc';
      end;
      case CodOrdenacao[1] of
        'O': SQL.Add('ORDER BY tos.num_ordem_servico ' + OrdenacaoCrescent);
        'P': SQL.Add('ORDER BY tpp.nom_pessoa ' + OrdenacaoCrescent);
        'R': SQL.Add('ORDER BY tppr.nom_propriedade_rural ' + OrdenacaoCrescent);
        'C': SQL.Add('ORDER BY tos.dta_cadastramento ' + OrdenacaoCrescent);
        'M': SQL.Add('ORDER BY tos.dta_ultima_alteracao ' + OrdenacaoCrescent);
      end;

      if NumOrdemServico > -1 then
      begin
        ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
      end;
      if SglProdutor <> '' then
      begin
        ParamByName('sgl_produtor').AsString := SglProdutor;
      end;
      if NumCNPJCPFProdutor <> '' then
      begin
        ParamByName('num_cnpj_cpf_produtor').AsString := NumCNPJCPFProdutor;
      end;
      if NumCNPJCPFTecnico <> '' then
      begin
        ParamByName('num_cnpj_cpf_tecnico').AsString := NumCNPJCPFTecnico;
      end;
      if NumCNPJCPFVendedor <> '' then
      begin
        ParamByName('num_cnpj_cpf_vendedor').AsString := NumCNPJCPFVendedor;
      end;
      if NumImovelReceitaFederal <> '' then
      begin
        ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
      end;
      if CodLocalizacaoSisbov > 0 then
      begin
        ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      end;
      if QtdAnimaisInicio > -1 then
      begin
        ParamByName('qtd_animais_inicio').AsInteger := QtdAnimaisInicio;
      end;
      if QtdAnimaisFim > -1 then
      begin
        ParamByName('qtd_animais_fim').AsInteger := QtdAnimaisFim;
      end;
      if NumSolicitacaoSISBOV > -1 then
      begin
        ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      end;
      if CodIdentificacaoDupla > -1 then
      begin
        ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
      end;
      if CodFabricanteIdentificador > -1 then
      begin
        ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
      end;
      if NumPedidoFabricante > -1 then
      begin
        ParamByName('num_pedido_fabricante').AsInteger := NumPedidoFabricante;
      end;
      if NumRemessa > -1 then
      begin
        ParamByName('num_remessa_fabricante').AsInteger := NumRemessa;
      end;
      if DtaCadastramentoInicio > 0 then
      begin
        ParamByName('dta_cadastramento_inicio').AsDateTime := DtaCadastramentoInicio;
      end;
      if DtaCadastramentoFim > 0 then
      begin
        ParamByName('dta_cadastramento_fim').AsDateTime := Trunc(DtaCadastramentoFim) + 1;
      end;
      if DtaMudancaSituacaoInicio > 0 then
      begin
        ParamByName('dta_ultima_mudanca_situacao_inicio').AsDateTime := DtaMudancaSituacaoInicio;
      end;
      if DtaMudancaSituacaoFim > 0 then
      begin
        ParamByName('dta_ultima_mudanca_situacao_fim').AsDateTime := Trunc(DtaMudancaSituacaoFim) + 1;
      end;
      if CodSituacaoOS > -1 then
      begin
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
      end;
      if IndEnviaPedidoIdentificador <> '' then
      begin
        ParamByName('ind_envia_pedido_identificador').AsString := IndEnviaPedidoIdentificador;
      end;
      if CodPaisSISBOV > -1 then
      begin
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
      end;
      if CodSituacaoSISBOVSim > -1 then
      begin
        ParamByName('dta_situacao_sisbov_inicio').AsDateTime := DateOf(DtaSituacaoSISBOVSimInicio);
        ParamByName('dta_situacao_sisbov_fim').AsDateTime := DateOf(DtaSituacaoSISBOVSimFim);
      end;

      if NumDiasBoletoAVencer > 0 then
      begin
        ParamByName('dta_a_vencer').AsDateTime := Now + NumDiasBoletoAVencer;
      end;
      if NumDiasBoletoEmAtraso > 0 then
      begin
        ParamByName('dta_em_atraso').AsDateTime := Now - NumDiasBoletoEmAtraso;
      end;
      if NumDiasBoletoPago > 0 then
      begin
        ParamByName('dta_pago').AsDateTime := Now - NumDiasBoletoPago;
      end;
      if CodSituacaoBoleto > 0 then
      begin
        ParamByName('cod_situacao_boleto').AsInteger := CodSituacaoBoleto;
      end;

      Open;
    end;

    If Query.RecordCount = Max Then Begin
      Mensagens.Adicionar(1820, Self.ClassName, NomeMetodo, [IntToStr(Max), IntToStr(Max)]);
      Result := 1820;
      Exit;
    End;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1777, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1777;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.PesquisarHistoricoSituacao(
  CodOrdemServico: Integer): Integer;
const
  NomeMetodo = 'PesquisarHistoricoSituacao';
var
  IndPermiteAcesso: Boolean;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(549) then
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
      SQL.Add('  SELECT cod_pessoa_produtor');
      SQL.Add('    FROM tab_ordem_servico');
      SQL.Add('   WHERE cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;
    end;

    if Query.isEmpty then
    begin
      Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
      Result := -1744;
      Exit;
    end;

    Result := VerificaPermissao(Conexao, Mensagens, IndPermiteAcesso,
      Query.FieldByName('cod_pessoa_produtor').AsInteger, False);
    if Result < 0 then
    begin
      Exit;
    end;

    if not IndPermiteAcesso then
    begin
      Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
      Result := -1744;
      Exit;
    end;

    with Query do
    begin
      SQL.Clear;
{$IFDEF MSSQL}
      SQL.Add('select thsos.cod_ordem_servico as CodOrdemServico,');
      SQL.Add('       thsos.cod_situacao_os as CodSituacaoOS,');
      SQL.Add('       tsos.sgl_situacao_os as SglSituacaoOS,');
      SQL.Add('       tsos.des_situacao_os as DesSituacaoOS,');
      SQL.Add('       thsos.dta_mudanca_situacao as DtaMudancaSituacao,');
      SQL.Add('       thsos.cod_usuario as CodUsuario,');
      SQL.Add('       tu.nom_usuario as NomUsuario,');
      SQL.Add('       thsos.txt_observacao as TxtObservacao');
      SQL.Add('  from tab_historico_situacao_os thsos');
      SQL.Add('         left join tab_usuario tu');
      SQL.Add('           on thsos.cod_usuario = tu.cod_usuario,');
      SQL.Add('       tab_situacao_os tsos');
      SQL.Add(' where thsos.cod_situacao_os = tsos.cod_situacao_os');
      SQL.Add('   and thsos.cod_ordem_servico = :cod_ordem_servico');
      SQL.Add('order by dta_mudanca_situacao desc');
{$ENDIF}
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;
    end;

    if Query.isEmpty then
    begin
      Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
      Result := -1744;
      Exit;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1777, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1777;
      Exit;
    end;
  end;
end;

{*
  Preenche a estrutura de dados FOrdemServico a partir de uma Query.

  @param QueryLocal Query onde a consulta foi realizada. Esta função não veifica se a query esta vazia, isto deve ser feito antes da chamada deste método.

  @return Retorna 0 se tudo ocorrer bem ou se algo der errado retorna o código do erro (menor que zero).
}
function TIntOrdensServico.PreecheEstruturaOrdemServico(
  QueryLocal: THerdomQuery): Integer;
const
  NomeMetodo = 'PreecheEstruturaOrdemServico';
begin
  try
    with QueryLocal do
    begin
      FOrdemServico.CodOrdemServico             := FieldByName('CodOrdemServico').AsInteger;
      FOrdemServico.NumOrdemServico             := FieldByName('NumOrdemServico').AsInteger;
      FOrdemServico.CodPessoaProdutor           := FieldByName('CodPessoaProdutor').AsInteger;
      FOrdemServico.SglProdutor                 := FieldByName('SglProdutor').AsString;
      FOrdemServico.NomProdutor                 := FieldByName('NomProdutor').AsString;
      FOrdemServico.NumCNPJCPFProdutor          := FieldByName('NumCNPJCPFProdutor').AsString;
      FOrdemServico.NumCNPJCPFProdutorFormatado := FormataCnpjCpf(FieldByName('NumCNPJCPFProdutor').AsString);
      FOrdemServico.CodPropriedadeRural         := FieldByName('CodPropriedadeRural').AsInteger;
      FOrdemServico.NomPropriedadeRural         := FieldByName('NomPropriedadeRural').AsString;
      FOrdemServico.NumImovelReceitaFederal     := FieldByName('NumImovelReceitaFederal').AsString;
      FOrdemServico.CodPessoaTecnico            := FieldByName('CodPessoaTecnico').AsInteger;
      FOrdemServico.NomTecnico                  := FieldByName('NomTecnico').AsString;
      FOrdemServico.NumCNPJCPFTecnico           := FieldByName('NumCNPJCPFTecnico').AsString;
      FOrdemServico.NumCNPJCPFTecnicoFormatado  := FormataCnpjCpf(FieldByName('NumCNPJCPFTecnico').AsString);
      FOrdemServico.CodPessoaVendedor           := FieldByName('CodPessoaVendedor').AsInteger;
      FOrdemServico.NomVendedor                 := FieldByName('NomVendedor').AsString;
      FOrdemServico.NumCNPJCPFVendedor          := FieldByName('NumCNPJCPFVendedor').AsString;
      FOrdemServico.NumCNPJCPFVendedorFormatado := FormataCnpjCpf(FieldByName('NumCNPJCPFVendedor').AsString);
      FOrdemServico.QtdAnimais                  := FieldByName('QtdAnimais').AsInteger;
      FOrdemServico.NumSolicitacaoSISBOV        := FieldByName('NumSolicitacaoSISBOV').AsInteger;
      FOrdemServico.CodPaisSISBOVInicial        := FieldByName('CodPaisSISBOVInicial').AsInteger;
      FOrdemServico.CodEstadoSISBOVInicial      := FieldByName('CodEstadoSISBOVInicial').AsInteger;
      FOrdemServico.CodMicroRegiaoSISBOVInicial := FieldByName('CodMicroRegiaoSISBOVInicial').AsInteger;
      FOrdemServico.CodAnimalSISBOVInicial      := FieldByName('CodAnimalSISBOVInicial').AsInteger;
      FOrdemServico.NumDVSISBOVInicial          := FieldByName('NumDVSISBOVInicial').AsInteger;
      FOrdemServico.CodFormaPagamentoOS         := FieldByName('CodFormaPagamentoOS').AsInteger;
      FOrdemServico.DesFormaPagamentoOS         := FieldByName('DesFormaPagamentoOS').AsString;

      FOrdemServico.EnderecoEntregaCert.CodEndereco      := FieldByName('CodEnderecoEntregaCert').AsInteger;
      FOrdemServico.EnderecoEntregaCert.CodTipoEndereco  := FieldByName('CodTipoEnderecoEC').AsInteger;
      FOrdemServico.EnderecoEntregaCert.SglTipoEndereco  := FieldByName('SglTipoEnderecoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.DesTipoEndereco  := FieldByName('DesTipoEnderecoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NomPessoaContato := FieldByName('NomPessoaContatoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NumTelefone      := FieldByName('NumTelefoneEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NumFax           := FieldByName('NumFaxEC').AsString;
      FOrdemServico.EnderecoEntregaCert.TxtEmail         := FieldByName('TxtEmailEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NomLogradouro    := FieldByName('NomLogradouroEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NomBairro        := FieldByName('NomBairroEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NumCEP           := FieldByName('NumCEPEC').AsString;
      FOrdemServico.EnderecoEntregaCert.CodDistrito      := FieldByName('CodDistritoEC').AsInteger;
      FOrdemServico.EnderecoEntregaCert.NomDistrito      := FieldByName('NomDistritoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.CodMunicipio     := FieldByName('CodMunicipioEC').AsInteger;
      FOrdemServico.EnderecoEntregaCert.NumMunicipioIBGE := FieldByName('NumMunicipioIBGEEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NomMunicipio     := FieldByName('NomMunicipioEC').AsString;
      FOrdemServico.EnderecoEntregaCert.CodEstado        := FieldByName('CodEstadoEC').AsInteger;
      FOrdemServico.EnderecoEntregaCert.SglEstado        := FieldByName('SglEstadoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.NomEstado        := FieldByName('NomEstadoEC').AsString;
      FOrdemServico.EnderecoEntregaCert.CodPais          := FieldByName('CodPaisEC').AsInteger;
      FOrdemServico.EnderecoEntregaCert.NomPais          := FieldByName('NomPaisEC').AsString;

      FOrdemServico.CodIdentificacaoDupla       := FieldByName('CodIdentificacaoDupla').AsInteger;
      FOrdemServico.SglIdentificacaoDupla       := FieldByName('SglIdentificacaoDupla').AsString;
      FOrdemServico.DesIdentificacaoDupla       := FieldByName('DesIdentificacaoDupla').AsString;
      FOrdemServico.CodFabricanteIdentificador  := FieldByName('CodFabricanteIdentificador').AsInteger;
      FOrdemServico.NomReduzidoFabricante       := FieldByName('NomReduzidoFabricante').AsString;
      FOrdemServico.CodformaPagamentoIdent      := FieldByName('CodformaPagamentoIdent').AsInteger;
      FOrdemServico.DesFormaPagamentoIdent      := FieldByName('DesFormaPagamentoIdent').AsString;

      FOrdemServico.EnderecoEntregaIdent.CodEndereco      := FieldByName('CodEnderecoEntregaIdent').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.CodTipoEndereco  := FieldByName('CodTipoEnderecoEI').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.SglTipoEndereco  := FieldByName('SglTipoEnderecoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.DesTipoEndereco  := FieldByName('DesTipoEnderecoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NomPessoaContato := FieldByName('NomPessoaContatoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NumTelefone      := FieldByName('NumTelefoneEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NumFax           := FieldByName('NumFaxEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.TxtEmail         := FieldByName('TxtEmailEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NomLogradouro    := FieldByName('NomLogradouroEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NomBairro        := FieldByName('NomBairroEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NumCEP           := FieldByName('NumCEPEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.CodDistrito      := FieldByName('CodDistritoEI').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.NomDistrito      := FieldByName('NomDistritoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.CodMunicipio     := FieldByName('CodMunicipioEI').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.NumMunicipioIBGE := FieldByName('NumMunicipioIBGEEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NomMunicipio     := FieldByName('NomMunicipioEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.CodEstado        := FieldByName('CodEstadoEI').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.SglEstado        := FieldByName('SglEstadoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.NomEstado        := FieldByName('NomEstadoEI').AsString;
      FOrdemServico.EnderecoEntregaIdent.CodPais          := FieldByName('CodPaisEI').AsInteger;
      FOrdemServico.EnderecoEntregaIdent.NomPais          := FieldByName('NomPaisEI').AsString;

      FOrdemServico.EnderecoCobrancaIdent.CodEndereco      := FieldByName('CodEnderecoCobrancaIdent').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.CodTipoEndereco  := FieldByName('CodTipoEnderecoCI').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.SglTipoEndereco  := FieldByName('SglTipoEnderecoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.DesTipoEndereco  := FieldByName('DesTipoEnderecoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NomPessoaContato := FieldByName('NomPessoaContatoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NumTelefone      := FieldByName('NumTelefoneCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NumFax           := FieldByName('NumFaxCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.TxtEmail         := FieldByName('TxtEmailCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NomLogradouro    := FieldByName('NomLogradouroCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NomBairro        := FieldByName('NomBairroCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NumCEP           := FieldByName('NumCEPCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.CodDistrito      := FieldByName('CodDistritoCI').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.NomDistrito      := FieldByName('NomDistritoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.CodMunicipio     := FieldByName('CodMunicipioCI').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.NumMunicipioIBGE := FieldByName('NumMunicipioIBGECI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NomMunicipio     := FieldByName('NomMunicipioCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.CodEstado        := FieldByName('CodEstadoCI').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.SglEstado        := FieldByName('SglEstadoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.NomEstado        := FieldByName('NomEstadoCI').AsString;
      FOrdemServico.EnderecoCobrancaIdent.CodPais          := FieldByName('CodPaisCI').AsInteger;
      FOrdemServico.EnderecoCobrancaIdent.NomPais          := FieldByName('NomPaisCI').AsString;

      FOrdemServico.CodModeloIdentificador1     := FieldByName('CodModeloIdentificador1').AsInteger;
      FOrdemServico.SglModeloIdentificador1     := FieldByName('SglModeloIdentificador1').AsString;
      FOrdemServico.DesModeloIdentificador1     := FieldByName('DesModeloIdentificador1').AsString;
      FOrdemServico.CodModeloIdentificador2     := FieldByName('CodModeloIdentificador2').AsInteger;
      FOrdemServico.SglModeloIdentificador2     := FieldByName('SglModeloIdentificador2').AsString;
      FOrdemServico.DesModeloIdentificador2     := FieldByName('DesModeloIdentificador2').AsString;
      FOrdemServico.CodProdutoAcessorio1        := FieldByName('CodProdutoAcessorio1').AsInteger;
      FOrdemServico.SglProdutoAcessorio1        := FieldByName('SglProdutoAcessorio1').AsString;
      FOrdemServico.DesProdutoAcessorio1        := FieldByName('DesProdutoAcessorio1').AsString;
      FOrdemServico.QtdProdutoAcessorio1        := FieldByName('QtdProdutoAcessorio1').AsInteger;
      FOrdemServico.CodProdutoAcessorio2        := FieldByName('CodProdutoAcessorio2').AsInteger;
      FOrdemServico.SglProdutoAcessorio2        := FieldByName('SglProdutoAcessorio2').AsString;
      FOrdemServico.DesProdutoAcessorio2        := FieldByName('DesProdutoAcessorio2').AsString;
      FOrdemServico.QtdProdutoAcessorio2        := FieldByName('QtdProdutoAcessorio2').AsInteger;
      FOrdemServico.CodProdutoAcessorio3        := FieldByName('CodProdutoAcessorio3').AsInteger;
      FOrdemServico.SglProdutoAcessorio3        := FieldByName('SglProdutoAcessorio3').AsString;
      FOrdemServico.DesProdutoAcessorio3        := FieldByName('DesProdutoAcessorio3').AsString;
      FOrdemServico.QtdProdutoAcessorio3        := FieldByName('QtdProdutoAcessorio3').AsInteger;
      FOrdemServico.NumPedidoFabricante         := FieldByName('NumPedidoFabricante').AsInteger;
      FOrdemServico.CodArquivoRemessaPedido     := FieldByName('CodArquivoRemessaPedido').AsInteger;
      FOrdemServico.NumRemessa                  := FieldByName('NumRemessa').AsInteger;
      FOrdemServico.DtaCadastramento            := FieldByName('DtaCadastramento').AsDateTime;
      FOrdemServico.CodUsuarioCadastramento     := FieldByName('CodUsuarioCadastramento').AsInteger;
      FOrdemServico.NomUsuarioCadastramento     := FieldByName('NomUsuarioCadastramento').AsString;
      FOrdemServico.DtaUltimaAlteracao          := FieldByName('DtaUltimaMudancaSituacao').AsDateTime;
      FOrdemServico.CodUsuarioUltimaAlteracao   := FieldByName('CodUsuarioUltimaMudanca').AsInteger;
      FOrdemServico.NomUsuarioUltimaAlteracao   := FieldByName('NomUsuarioUltimaMudanca').AsString;
      FOrdemServico.CodSituacaoOS               := FieldByName('CodSituacaoOS').AsInteger;
      FOrdemServico.SglSituacaoOS               := FieldByName('SglSituacaoOS').AsString;
      FOrdemServico.DesSituacaoOS               := FieldByName('DesSituacaoOS').AsString;
      FOrdemServico.TxtObservacao               := FieldByName('TxtObservacao').AsString;
      FOrdemServico.IndEnviaPedidoIdentificador := FieldByName('IndEnviaPedidoIdent').AsString;
      FOrdemServico.CodUsuarioPedido            := FieldByName('CodUsuarioPedido').AsInteger;
      FOrdemServico.NomUsuarioPedido            := FieldByName('NomUsuarioPedido').AsString;
      FOrdemServico.DtaPedido                   := FieldByName('DtaPedido').AsDateTime;
      FOrdemServico.TxtObservacaoPedido         := FieldByName('TxtObservacaoPedido').AsString;
      FOrdemServico.IndAnimaisRegistrados       := FieldByName('IndAnimaisRegistrados').AsString;
      FOrdemServico.DtaEnvio                    := FieldByName('DtaEnvio').AsDateTime;
      FOrdemServico.NomServicoEnvio             := FieldByName('NomServicoEnvio').AsString;
      FOrdemServico.NumConhecimento             := FieldByName('NumConhecimento').AsString;
      FOrdemServico.CodLocalizacaoSisbov        := FieldByName('CodLocalizacaoSisbov').AsInteger;
      FOrdemServico.CodBoleto                   := FieldByName('CodBoleto').AsInteger;
      FOrdemServico.IndTransmissaoSisbov        := FieldByName('IndTransmissaoSisbov').AsString;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1761, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1761;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.ProximoCodigoOS(
  EConexao: TConexao; EMensagens: TIntMensagens;
  var ValProximoCodOS: Integer): Integer;
begin
  Result := ObtemValorSequencial(EConexao, EMensagens,
    'cod_seq_ordem_servico', ValProximoCodOS);
end;

class function TIntOrdensServico.ProximoNumeroOS(
  var ValProximoNumOS: Integer; Conexao: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := ObtemValorSequencial(Conexao, Mensagens,
    'num_seq_ordem_servico', ValProximoNumOS);
end;

class function TIntOrdensServico.ValidaCamposAlterados(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, QtdAnimais, CodPessoaTecnico,
  CodPessoaVendedor, CodFormaPagamentoOS, CodIdentificacaoDupla,
  CodFabricanteIdentificador, CodFormaPagamentoIdent, CodProdutoAcessorio1,
  QtdProdutoAcessorio1, CodProdutoAcessorio2, QtdProdutoAcessorio2,
  CodProdutoAcessorio3, QtdProdutoAcessorio3, NumOrdemServico,
  CodSituacaoOS: Integer; IndEnviaPedidoIdent, TxtObservacaoPedido, IndAnimaisRegistrados: String;
  CodEnderecoEntregaCert, CodEnderecoEntregaIdent,
  CodEnderecoCobrancaIdent, CodAnimalSISBOVInicio: Integer;
  IndChamadaInterna, IndGerarMensagem: Boolean): Integer;
const
  NomeMetodo = 'ValidaCamposAlterados';
var
  QOSAtual: THerdomQuery;
  QAtribSituacao: THerdomQuery;
  NomeAtributo: String;
  CodMensagemErro: Integer;
  ValorAtual: Integer;
  ValorDestino: Integer;
  StrValorAtual: String;
  StrValorDestino: String;
  CodMensagemRequerido: Integer;
  CodMensagemAlterar: Integer;
  CodMensagemAviso: Integer;
  IndPodeAlterar: String;
  IndRequerido: String;
  IndMensagem: String;
  CamposMensagem: String;
  DesSituacaoOS: String;
begin
  Result := 0;

  try
    QOSAtual := THerdomQuery.Create(EConexao, nil);
    QAtribSituacao := THerdomQuery.Create(EConexao, nil);
    try
      // Busca os dados atuais da OS para comparar com os valores informados
      with QOSAtual do
      begin
        SQL.Clear;
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       isNull(num_ordem_servico, -1) as num_ordem_servico,');
        SQL.Add('       qtd_animais,');
        SQL.Add('       isNull(cod_pessoa_tecnico, -1) as cod_pessoa_tecnico,');
        SQL.Add('       isNull(cod_pessoa_vendedor, -1) as cod_pessoa_vendedor,');
        SQL.Add('       isNull(cod_forma_pagamento_os, -1) as cod_forma_pagamento_os,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla,');
        SQL.Add('       isNull(cod_fabricante_identificador, -1) as cod_fabricante_identificador,');
        SQL.Add('       isNull(cod_forma_pagamento_ident, -1) as cod_forma_pagamento_ident,');
        SQL.Add('       isNull(cod_produto_acessorio_1, -1) as cod_produto_acessorio_1,');
        SQL.Add('       isNull(qtd_produto_acessorio_1, -1) as qtd_produto_acessorio_1,');
        SQL.Add('       isNull(cod_produto_acessorio_2, -1) as cod_produto_acessorio_2,');
        SQL.Add('       isNull(qtd_produto_acessorio_2, -1) as qtd_produto_acessorio_2,');
        SQL.Add('       isNull(cod_produto_acessorio_3, -1) as cod_produto_acessorio_3,');
        SQL.Add('       isNull(qtd_produto_acessorio_3, -1) as qtd_produto_acessorio_3,');
        SQL.Add('       isNull(cod_endereco_entrega_cert, -1) as cod_endereco_entrega_cert,');
        SQL.Add('       isNull(cod_endereco_entrega_ident, -1) as cod_endereco_entrega_ident,');
        SQL.Add('       isNull(cod_endereco_cobranca_ident, -1) as cod_endereco_cobranca_ident,');
        SQL.Add('       isNull(cod_animal_sisbov_inicio, -1) as cod_animal_sisbov_inicio,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       txt_observacao_pedido,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       ind_animais_registrados');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        if isEmpty then
        begin
          EMensagens.Adicionar(1744, Self.ClassName, 'Buscar', []);
          Result := -1744;
          Exit;
        end;
      end;

      with QAtribSituacao do
      begin
        SQL.Clear;
        // Obtem os atributos e as respectivas restrições de acordo com a situação
        SQL.Add('select taos.nom_coluna_atributo,');
        SQL.Add('       taos.des_atributo_os,');
        SQL.Add('       tsaos.ind_pode_alterar,');
        SQL.Add('       tsaos.ind_mostra_mensagem,');
        SQL.Add('       tsaos.ind_requerido,');
        SQL.Add('       tsos.des_situacao_os');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_atributo_os taos,');
        SQL.Add('       tab_situacao_os tsos');
        SQL.Add(' where tsaos.cod_atributo_os = taos.cod_atributo_os');
        SQL.Add('   and tsaos.cod_situacao_os = tsos.cod_situacao_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsos.cod_situacao_os = :cod_situacao_os');

        ParamByName('cod_situacao_os').AsInteger :=
          CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString :=
          QOSAtual.FieldByName('ind_envia_pedido_ident').AsString;
        Open;

        CamposMensagem := '';

        // Valida os campos
        while not EOF do
        begin
          ValorAtual := -1;
          StrValorAtual := '';
          ValorDestino := 0;
          CodMensagemAviso := 1874;
          CodMensagemRequerido := 1872;
          CodMensagemAlterar := 1873;

          NomeAtributo := FieldByName('nom_coluna_atributo').AsString;
          IndPodeAlterar := FieldByName('ind_pode_alterar').AsString;
          IndRequerido := FieldByName('ind_requerido').AsString;
          IndMensagem := FieldByName('ind_mostra_mensagem').AsString;
          if QOSAtual.FieldByName(NomeAtributo).DataType = ftString then
          begin
            StrValorAtual := QOSAtual.FieldByName(NomeAtributo).AsString;
          end
          else
          begin
            ValorAtual := QOSAtual.FieldByName(NomeAtributo).AsInteger;
          end;

          if LowerCase(NomeAtributo) = 'qtd_animais' then
          begin
            ValorDestino := QtdAnimais;
          end
          else if LowerCase(NomeAtributo) = 'cod_pessoa_tecnico' then
          begin
            ValorDestino := CodPessoaTecnico;
          end
          else if LowerCase(NomeAtributo) = 'cod_pessoa_vendedor' then
          begin
            ValorDestino := CodPessoaVendedor;
          end
          else if LowerCase(NomeAtributo) = 'cod_forma_pagamento_os' then
          begin
            ValorDestino := CodFormaPagamentoOS;
          end
          else if LowerCase(NomeAtributo) = 'cod_identificacao_dupla' then
          begin
            ValorDestino := CodIdentificacaoDupla;
          end
          else if LowerCase(NomeAtributo) = 'cod_fabricante_identificador' then
          begin
            ValorDestino := CodFabricanteIdentificador;
          end
          else if LowerCase(NomeAtributo) = 'cod_forma_pagamento_ident' then
          begin
            ValorDestino := CodFormaPagamentoIdent;
          end
          else if (LowerCase(NomeAtributo) = 'cod_produto_acessorio_1') then
          begin
            ValorDestino := CodProdutoAcessorio1;
          end
          else if LowerCase(NomeAtributo) = 'qtd_produto_acessorio_1' then
          begin
            ValorDestino := QtdProdutoAcessorio1;
          end
          else if LowerCase(NomeAtributo) = 'cod_produto_acessorio_2' then
          begin
            ValorDestino := CodProdutoAcessorio2;
          end
          else if LowerCase(NomeAtributo) = 'qtd_produto_acessorio_2' then
          begin
            ValorDestino := QtdProdutoAcessorio2;
          end
          else if LowerCase(NomeAtributo) = 'cod_produto_acessorio_3' then
          begin
            ValorDestino := CodProdutoAcessorio3;
          end
          else if LowerCase(NomeAtributo) = 'qtd_produto_acessorio_3' then
          begin
            ValorDestino := QtdProdutoAcessorio3;
          end
          else if LowerCase(NomeAtributo) = 'num_ordem_servico' then
          begin
            ValorDestino := NumOrdemServico;
          end
          else if LowerCase(NomeAtributo) = 'ind_envia_pedido_ident' then
          begin
            StrValorDestino := IndEnviaPedidoIdent;
          end
          else if LowerCase(NomeAtributo) = 'cod_endereco_entrega_cert' then
          begin
            ValorDestino := CodEnderecoEntregaCert;
          end
          else if LowerCase(NomeAtributo) = 'cod_endereco_entrega_ident' then
          begin
            ValorDestino := CodEnderecoEntregaIdent;
          end
          else if LowerCase(NomeAtributo) = 'cod_animal_sisbov_inicio' then
          begin
            ValorDestino := CodAnimalSISBOVInicio;
          end
          else if LowerCase(NomeAtributo) = 'txt_observacao_pedido' then
          begin
            StrValorDestino := TxtObservacaoPedido;
          end
          else if LowerCase(NomeAtributo) = 'cod_endereco_cobranca_ident' then
          begin
            ValorDestino := CodEnderecoCobrancaIdent;
          end
          else if LowerCase(NomeAtributo) = 'ind_animais_registrados' then
          begin
            StrValorDestino := IndAnimaisRegistrados;
          end;
          
          // Verifica se o campo é valido
          if QOSAtual.FieldByName(NomeAtributo).DataType = ftString then
          begin
            CodMensagemErro := AtributoValido(StrValorAtual, StrValorDestino,
              IndPodeAlterar, IndRequerido, IndMensagem, CodMensagemRequerido,
              CodMensagemAlterar, CodMensagemAviso);
          end
          else
          begin
            CodMensagemErro := AtributoValido(ValorAtual, ValorDestino,
              IndPodeAlterar, IndRequerido, IndMensagem, CodMensagemRequerido,
              CodMensagemAlterar, CodMensagemAviso);
          end;

          // Se algum erro foi encontrado gera a mensagem
          if CodMensagemErro > 0 then
          begin
            DesSituacaoOS := FieldByName('des_situacao_os').AsString;
            if CodMensagemErro = CodMensagemAviso then
            begin
              if CamposMensagem = '' then
              begin
                CamposMensagem := FieldByName('des_atributo_os').AsString;
              end
              else
              begin
                CamposMensagem := CamposMensagem + ', ' + FieldByName('des_atributo_os').AsString;
              end;
            end
            else
            begin
              if IndGerarMensagem then
              begin
                EMensagens.Adicionar(CodMensagemErro, Self.ClassName,
                  NomeMetodo, [FieldByName('des_atributo_os').AsString]);
              end;
              Result := -CodMensagemErro;
              Exit;
            end;
          end;

          Next;
        end;

        // Caso exista algum aviso, inclui uma mensagem
        if IndGerarMensagem and (CamposMensagem <> '') then
        begin
          EMensagens.Adicionar(1874, Self.ClassName, NomeMetodo,
            [DesSituacaoOS, CamposMensagem]);
        end;
      end;
    finally
      QOSAtual.Free;
      QAtribSituacao.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1779, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1779;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.ValidaProdutoAcessorio(CodFabricanteIdentificador,
  CodProdutoAcessorio, QtdProdutoAcessorio, NumProdutoAcessorio: Integer): Integer;
const
  NomeMetodo = 'ValidaProdutoAcessorio';
var
  QueryLocal: THerdomQuery;
begin
  Result := 0;
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Se o produto foi informado verifica se é valido
      if CodProdutoAcessorio > 0 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
          SQL.Add('select cod_produto_acessorio');
          SQL.Add('  from tab_produto_acessorio');
          SQL.Add(' where cod_fabricante_identificador = :cod_fabricante_identificador');
          SQL.Add('   and cod_produto_acessorio = :cod_produto_acessorio');
          SQL.Add('   and dta_fim_validade is null');

          ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          ParamByName('cod_produto_acessorio').AsInteger := CodProdutoAcessorio;

          Open;

          if IsEmpty then
          begin
            Mensagens.Adicionar(1812, Self.ClassName, NomeMetodo, [IntToStr(NumProdutoAcessorio)]);
            Result := -1812;
            Exit;
          end;

          // A quantidade deve ser maior que 0
          if QtdProdutoAcessorio < 1 then
          begin
            Mensagens.Adicionar(1813, Self.ClassName, NomeMetodo, [IntToStr(NumProdutoAcessorio)]);
            Result := -1813;
            Exit;
          end;
        end;
      end
      else
      begin
        if QtdProdutoAcessorio > -1 then
        begin
          Mensagens.Adicionar(1813, Self.ClassName, NomeMetodo, [IntToStr(NumProdutoAcessorio)]);
          Result := -1813;
          Exit;
        end;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1811, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1811;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.VerificaPermissao(EConexao: TConexao;
  EMensagens: TIntMensagens; var PermiteAcesso: Boolean;
  CodPessoaProdutor: Integer; IndGerarMensagens: Boolean): Integer;
const
  NomeMetodo = 'VerificaPermissao';
var
  QueryLocal: THerdomQuery;
begin
  Result := 0;
  PermiteAcesso := False;
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Se o papel do usuário for de um técnico ...
      if EConexao.CodPapelUsuario = 3 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
          SQL.Add('select cod_pessoa_tecnico');
          SQL.Add('  from tab_tecnico_produtor');
          SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
          SQL.Add('   and cod_pessoa_tecnico = :cod_pessoa_tecnico');
          SQL.Add('   and dta_fim_validade is null');
          ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          ParamByName('cod_pessoa_tecnico').AsInteger := EConexao.CodPessoa;

          Open;
          if isEmpty then
          begin
            if IndGerarMensagens then
            begin
              EMensagens.Adicionar(1246, Self.ClassName, NomeMetodo, []);
              Result := -1246;
            end;
            Exit;
          end;
        end;
      end
      // Se o papel do usuário for de um produtor ...
      else if EConexao.CodPapelUsuario = 4 then
      begin
        if CodPessoaProdutor <> EConexao.CodPessoa then
        begin
          if IndGerarMensagens then
          begin
            EMensagens.Adicionar(1246, Self.ClassName, NomeMetodo, []);
            Result := -1246;
          end;
          Exit;
        end;
      end
      // Se o papel do usuário for de uma associação de raça ...
      else if EConexao.CodPapelUsuario = 1 then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
          SQL.Add('select cod_pessoa_associacao');
          SQL.Add('  from tab_associacao_produtor');
          SQL.Add(' where cod_pessoa_produtor =:cod_pessoa_produtor');
          SQL.Add('   and cod_pessoa_associacao = :cod_pessoa_associacao');
          ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          ParamByName('cod_pessoa_associacao').AsInteger := EConexao.CodPessoa;

          Open;
          if isEmpty then
          begin
            if IndGerarMensagens then
            begin
              EMensagens.Adicionar(1246, Self.ClassName, NomeMetodo, []);
              Result := -1246;
            end;
            Exit;
          end;
        end;
      end;

      PermiteAcesso := True;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1779, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1779;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.VerificaExistenciaOS(CodOrdemServico, TipoEndereco: Integer): Integer;
const
  NomeMetodo: String = 'VerificaExistenciaOS';
var
  Q: THerdomQuery;
  IndAcessoLiberado: Boolean;
  CodPessoaProdutor: Integer;
  PodeAlterar: String;
begin    
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      with Q do begin
      {$IFDEF MSSQL}
          SQL.Add(' select tsa.ind_pode_alterar as PodeAlterar, tos.cod_pessoa_produtor as CodPessoaProdutor ');
          SQL.Add(' from ');
          SQL.Add('   tab_ordem_servico tos, ');
          SQL.Add('   tab_situacao_atributo_os tsa, ');
          SQL.Add('   tab_atributo_os tao ');
          SQL.Add(' where ');
          SQL.Add('   tsa.cod_situacao_os = tos.cod_situacao_os ');
          SQL.Add('   and tos.cod_ordem_servico = :cod_ordem_servico ');
          SQL.Add('   and tsa.cod_atributo_os = tao.cod_atributo_os ');
          SQL.Add('   and tsa.cod_atributo_os = :cod_atributo_os ');
          SQL.Add('   and tos.ind_envia_pedido_ident = tsa.ind_envia_pedido_ident ');
      {$ENDIF}
          ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          ParamByName('cod_atributo_os').AsInteger := TipoEndereco;
          Open;
      end;

      If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1832, Self.ClassName, NomeMetodo, []);
          Result := -1832;
          Exit;
      end else begin
        CodPessoaProdutor := Q.fieldbyname('CodPessoaProdutor').AsInteger;
        PodeAlterar       := Q.fieldbyname('PodeAlterar').AsString;
        If PodeAlterar = 'N' then begin
           Mensagens.Adicionar(1844, Self.ClassName, NomeMetodo, []);
           Result := -1844;
           Exit;
        end;
        // Verifica se o usuário tem permissão de acesso.
        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          CodPessoaProdutor, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
           Result := -1;
        end else begin
           Result := 0;
        end;  
      end;
    Finally
     Q.Free;
    end;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1833, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1833;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.VerificaExistenciaEndereco(CodEndereco: Integer; TxtDesEndereco: String): Integer;
const
  NomeMetodo: String = 'VerificaExistenciaEndereco';
var
  Q: THerdomQuery;
begin

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      with Q do begin
  {$IFDEF MSSQL}
        SQL.Add('select 1 from tab_endereco');
        SQL.Add('where cod_endereco = :cod_endereco');
  {$ENDIF}
        ParamByName('cod_endereco').AsInteger := CodEndereco;
        Open;
      end;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1836, Self.ClassName, NomeMetodo, [TxtDesEndereco]);
        Result := -1836;
      end else begin
        Result := CodEndereco;
      end;
    Finally
     Q.Free;
    end;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1834, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1834;
      Exit;
    end;
  end;
end;


function TIntOrdensServico.DefinirEnderecoEntregaCert2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
var
  Q: THerdomQuery;
  CodEnderecoEntregaCert: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 555;
  NomMetodo: String = 'DefinirEnderecoEntregaCert2';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Q := THerdomQuery.Create(Conexao, nil);

    If (CodEndereco > 0) and (CodPessoa > 0) then begin
        Mensagens.Adicionar(1835, Self.ClassName, NomMetodo, []);
        Result := -1835;
        Exit;
    end;

    //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
    Result := VerificaExistenciaOS(CodOrdemServico, 15);
    if Result < 0 then Exit;

    If CodEndereco > 0 then begin
      CodEnderecoEntregaCert := VerificaExistenciaEndereco(CodEndereco, 'entrega de certificados');
      if CodEnderecoEntregaCert < 0 then begin
        Result := CodEnderecoEntregaCert;
        Exit;
      end;
    end else begin
      CodEnderecoEntregaCert := FIntEnderecos.Inserir(CodPessoa);
      if CodEnderecoEntregaCert < 0 then begin
        Result := CodEnderecoEntregaCert;
        Exit;
      end;
    end;

    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_entrega_cert = :cod_endereco_entrega_cert, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_entrega_cert').AsInteger := CodEnderecoEntregaCert;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;
    Commit;
    Result := CodEnderecoEntregaCert;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1838, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1838;
      Exit;
    End;
  End;
end;

//Adalberto
function TIntOrdensServico.DefinirEnderecoEntregaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
var
  Q: THerdomQuery;
  CodEnderecoEntregaIdent: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 556;
  NomMetodo: String = 'DefinirEnderecoEntregaIdent2';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Q := THerdomQuery.Create(Conexao, nil);

    If (CodEndereco > 0) and (CodPessoa > 0) then begin
        Mensagens.Adicionar(1835, Self.ClassName, NomMetodo, []);
        Result := -1835;
        Exit;
    end;

    //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
    Result := VerificaExistenciaOS(CodOrdemServico, 16);
    if Result < 0 then Exit;

    If CodEndereco > 0 then begin
      CodEnderecoEntregaIdent := VerificaExistenciaEndereco(CodEndereco, 'entrega de identificadores');
      if CodEnderecoEntregaIdent < 0 then begin
        Result := CodEnderecoEntregaIdent;
        Exit;
      end;
    end else begin
      CodEnderecoEntregaIdent := FIntEnderecos.Inserir(CodPessoa);
      if CodEnderecoEntregaIdent < 0 then begin
        Result := CodEnderecoEntregaIdent;
        Exit;
      end;
    end;

    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_entrega_ident = :cod_endereco_entrega_ident, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_entrega_ident').AsInteger := CodEnderecoEntregaIdent;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;

    Commit;
    Result := CodEnderecoEntregaIdent;     //retorno OK
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1839, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1839;
      Exit;
    End;
  End;
end;

function TIntOrdensServico.DefinirEnderecoCobrancaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
var
  Q: THerdomQuery;
  CodEnderecoCobrancaIdent: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 557;
  NomMetodo: String = 'DefinirEnderecoCobrancaIdent';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Q := THerdomQuery.Create(Conexao, nil);

    If (CodEndereco > 0) and (CodPessoa > 0) then begin
        Mensagens.Adicionar(1835, Self.ClassName, NomMetodo, []);
        Result := -1835;
        Exit;
    end;

    //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
    Result := VerificaExistenciaOS(CodOrdemServico, 17);
    if Result < 0 then Exit;
  
    If CodEndereco > 0 then begin
      CodEnderecoCobrancaIdent := VerificaExistenciaEndereco(CodEndereco, 'cobrança de identificadores');
      if CodEnderecoCobrancaIdent < 0 then begin
        Result := CodEnderecoCobrancaIdent;
        Exit;
      end;
    end else begin
      CodEnderecoCobrancaIdent := FIntEnderecos.Inserir(CodPessoa);
      if CodEnderecoCobrancaIdent < 0 then begin
        Result := CodEnderecoCobrancaIdent;
        Exit;
      end;
    end;

    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_cobranca_ident = :cod_endereco_cobranca_ident, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_cobranca_ident').AsInteger := CodEnderecoCobrancaIdent;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;
    Commit;
    Result := CodEnderecoCobrancaIdent; //retorno Ok
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1840, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1840;
      Exit;
    End;
  End;
end;

function TIntOrdensServico.DefinirEnderecoCobrancaIdent1(CodOrdemServico,
  CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep: String; CodDistrito, CodMunicipio: Integer;
  NomLocalidade: String; CodEstado: Integer): Integer;
var
  Q : THerdomQuery;
  CodNovoEndereco: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 558;
  NomMetodo: String = 'DefinirEnderecoCobrancaIdent';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
  Result := VerificaExistenciaOS(CodOrdemServico, 17);
  if Result < 0 then Exit;

  CodNovoEndereco := FIntEnderecos.Inserir(CodTipoEndereco, NomPessoaContato, NumTelefone, NumFax,
                                TxtEmail, NomLogradouro, NomBairro, NumCEP, NomLocalidade,
                                CodDistrito, CodMunicipio, CodEstado);
  If CodNovoEndereco < 0 then begin
    Result := CodNovoEndereco;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try

    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_cobranca_ident = :cod_endereco_cobranca_ident, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_cobranca_ident').AsInteger := CodNovoEndereco;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;
    Commit;
    Result := CodNovoEndereco;     //retorno OK
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1840, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1840;
      Exit;
    End;
  End;
end;

function TIntOrdensServico.DefinirEnderecoEntregaCert1(CodOrdemServico,
  CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep: String; CodDistrito, CodMunicipio: Integer;
  NomLocalidade: String; CodEstado: Integer): Integer;
var
  Q : THerdomQuery;
  CodNovoEndereco: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 559;
  NomMetodo: String = 'DefinirEnderecoEntregaCert';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
  Result := VerificaExistenciaOS(CodOrdemServico, 15);
  if Result < 0 then Exit;

  CodNovoEndereco := FIntEnderecos.Inserir(CodTipoEndereco, NomPessoaContato,
    NumTelefone, NumFax, TxtEmail, NomLogradouro, NomBairro, NumCEP,
    NomLocalidade, CodDistrito, CodMunicipio, CodEstado);
  If CodNovoEndereco < 0 then begin
    Result := CodNovoEndereco;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_entrega_cert = :cod_endereco_entrega_cert, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_entrega_cert').AsInteger := CodNovoEndereco;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;

    Commit;
    Result := CodNovoEndereco;     //retorno OK
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1838, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1838;
      Exit;
    End;
  End;
end;

function TIntOrdensServico.DefinirEnderecoEntregaIdent1(CodOrdemServico,
  CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep: String; CodDistrito, CodMunicipio: Integer;
  NomLocalidade: String; CodEstado: Integer): Integer;
var
  Q : THerdomQuery;
  CodNovoEndereco: Integer;
  CodRegistroLog: Integer;
const
  CodMetodo: Integer = 560;
  NomMetodo: String = 'DefinirEnderecoEntregaIdent';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //consiste se a Ordem de Serviço existe, através do CodOrdemServico do parametro
  Result := VerificaExistenciaOS(CodOrdemServico, 16);
  if Result < 0 then Exit;

  CodNovoEndereco := FIntEnderecos.Inserir(CodTipoEndereco, NomPessoaContato, NumTelefone, NumFax,
                                TxtEmail, NomLogradouro, NomBairro, NumCEP, NomLocalidade,
                                CodDistrito, CodMunicipio, CodEstado);
  If CodNovoEndereco < 0 then begin
    Result := CodNovoEndereco;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    // Abre transação
    BeginTran;
    With Q do begin
      // Obtem o código do registro de log da OS
      SQL.Add('select cod_registro_log');
      SQL.Add('  from tab_ordem_servico');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico');
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Open;

      CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

      // Atualiza o endereço da OS
      SQL.Clear;
      SQL.Add('update tab_ordem_servico set ');
      SQL.Add(' cod_endereco_entrega_ident = :cod_endereco_entrega_ident, ');
      SQL.Add(' dta_ultima_alteracao = (select getdate()), ');
      SQL.Add(' cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ');
      SQL.Add('where cod_ordem_servico = :cod_ordem_servico ');

      ParamByName('cod_endereco_entrega_ident').AsInteger := CodNovoEndereco;
      ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
    end;

    Commit;
    Result := CodNovoEndereco;     //retorno OK

  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1839, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1839;
      Exit;
    End;
  End;
end;


class function TIntOrdensServico.MudarSituacaoInt(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, CodSituacaoOS: Integer;
  TxtObservacao: String; IndGerarMensagens, IndChamadaInterna,
  IndValidaAcessoAtributo: Boolean): Integer;
  function _TrataMensagemErroCANC(RetornoSISBOV: RetornoWsSISBOV): String;
  var
    Retorno: String;
    I, J: Integer;
  begin
    Retorno := '';
    if not Assigned(RetornoSISBOV) then begin
      Result := 'Erro no tratamento de retorno SISBOV';
      Exit;
    end;
    // Verifica se o vetor de erros contem algum elemento
    if RetornoSISBOV.listaErros <> nil then
    begin
      // Percorre os elementos do vetor
      for I := 0 to Length(RetornoSISBOV.listaErros) - 1 do
      begin
        Retorno := Retorno + '("' + RetornoSISBOV.listaErros[I].menssagemErro + '"';
        // Verifica o vetor de erros do banco de dados do SISBOV
        if RetornoSISBOV.listaErros[I].valorInformado <> nil then
        begin
          // Percorre o vetor de erros do banco de dados do SISBOV
          for J := 0 to Length(RetornoSISBOV.listaErros[I].valorInformado) - 1 do
          begin
            Retorno := Retorno + ', "' + RetornoSISBOV.listaErros[I].valorInformado[J] + '"';
          end;
        end;
        Retorno := Retorno + ') ';
        if Length(Retorno) > 1700 then begin
          Break;
        end;
      end;
    end else begin
      Retorno := 'Mensagem de erro não retornada pelo SISBOV.';
    end;

    Result := Retorno;
  end;

const
  NomeMetodo = 'MudarSituacaoInt';
var
  QueryLocal: THerdomQuery;
  PermiteAcesso: Boolean;
  CodSituacaoOSAtual, QtdAnimais, CodPessoaTecnico, CodPessoaVendedor,
  CodFormaPagamentoOS, CodIdentificacaoDupla, CodFabricanteIdentificador,
  CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
  CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
  QtdProdutoAcessorio3, NumOrdemServico: Integer;
  IndEnviaPedidoIdent: String;
  CodPessoaProdutor,
  CodEnderecoEntregaCert,
  CodEnderecoEntregaIdent,
  CodEnderecoCobrancaIdent,
  CodRegistroLog,
  CodAnimalSISBOVInicio: Integer;
  TxtObservacaoPedido: String;
  IndAnimaisRegistrados: String;
  NumSolicitacaoSISBOV: Integer;

  RetornoCANC: RetornoCancelarSolicitacaoNumeracao;
  SoapSisbov: TIntSoapSisbov;
  Conectado: Boolean;
begin
  // Verifica se usuário pode executar método
  If Not EConexao.PodeExecutarMetodo(561) Then Begin
    EMensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  NumSolicitacaoSISBOV := 0;
  SoapSisbov := nil;

  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Verifica se a OS informada é valida e se o usuário tem acesso
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_pessoa_produtor,');
        SQL.Add('       isNull(num_ordem_servico, -1) as num_ordem_servico,');
        SQL.Add('       qtd_animais,');
        SQL.Add('       isNull(cod_pessoa_tecnico, -1) as cod_pessoa_tecnico,');
        SQL.Add('       isNull(cod_pessoa_vendedor, -1) as cod_pessoa_vendedor,');
        SQL.Add('       isNull(cod_forma_pagamento_os, -1) as cod_forma_pagamento_os,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla,');
        SQL.Add('       isNull(cod_fabricante_identificador, -1) as cod_fabricante_identificador,');
        SQL.Add('       isNull(cod_forma_pagamento_ident, -1) as cod_forma_pagamento_ident,');
        SQL.Add('       isNull(cod_produto_acessorio_1, -1) as cod_produto_acessorio_1,');
        SQL.Add('       isNull(qtd_produto_acessorio_1, -1) as qtd_produto_acessorio_1,');
        SQL.Add('       isNull(cod_produto_acessorio_2, -1) as cod_produto_acessorio_2,');
        SQL.Add('       isNull(qtd_produto_acessorio_2, -1) as qtd_produto_acessorio_2,');
        SQL.Add('       isNull(cod_produto_acessorio_3, -1) as cod_produto_acessorio_3,');
        SQL.Add('       isNull(qtd_produto_acessorio_3, -1) as qtd_produto_acessorio_3,');
        SQL.Add('       isNull(cod_endereco_entrega_cert, -1) as cod_endereco_entrega_cert,');
        SQL.Add('       isNull(cod_endereco_entrega_ident, -1) as cod_endereco_entrega_ident,');
        SQL.Add('       isNull(cod_endereco_cobranca_ident, -1) as cod_endereco_cobranca_ident,');
        SQL.Add('       isNull(cod_animal_sisbov_inicio, -1) as cod_animal_sisbov_inicio,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       txt_observacao_pedido,');
        SQL.Add('       cod_registro_log,');
        SQL.Add('       num_solicitacao_sisbov,');
        SQL.Add('       ind_animais_registrados');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        if IsEmpty then
        begin
          EMensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        end;

        CodSituacaoOSAtual         := FieldByName('cod_situacao_os').AsInteger;
        QtdAnimais                 := FieldByName('qtd_animais').AsInteger;
        CodPessoaTecnico           := FieldByName('cod_pessoa_tecnico').AsInteger;
        CodPessoaVendedor          := FieldByName('cod_pessoa_vendedor').AsInteger;
        CodFormaPagamentoOS        := FieldByName('cod_forma_pagamento_os').AsInteger;
        CodIdentificacaoDupla      := FieldByName('cod_identificacao_dupla').AsInteger;
        CodFabricanteIdentificador := FieldByName('cod_fabricante_identificador').AsInteger;
        CodFormaPagamentoIdent     := FieldByName('cod_forma_pagamento_ident').AsInteger;
        CodProdutoAcessorio1       := FieldByName('cod_produto_acessorio_1').AsInteger;
        QtdProdutoAcessorio1       := FieldByName('qtd_produto_acessorio_1').AsInteger;
        CodProdutoAcessorio2       := FieldByName('cod_produto_acessorio_2').AsInteger;
        QtdProdutoAcessorio2       := FieldByName('qtd_produto_acessorio_2').AsInteger;
        CodProdutoAcessorio3       := FieldByName('cod_produto_acessorio_3').AsInteger;
        QtdProdutoAcessorio3       := FieldByName('qtd_produto_acessorio_3').AsInteger;
        NumOrdemServico            := FieldByName('num_ordem_servico').AsInteger;
        IndEnviaPedidoIdent        := FieldByName('ind_envia_pedido_ident').AsString;
        CodEnderecoEntregaCert     := FieldByName('cod_endereco_entrega_cert').AsInteger;
        CodEnderecoEntregaIdent    := FieldByName('cod_endereco_entrega_ident').AsInteger;
        CodEnderecoCobrancaIdent   := FieldByName('cod_endereco_cobranca_ident').AsInteger;
        CodRegistroLog             := FieldByName('cod_registro_log').AsInteger;
        CodPessoaProdutor          := FieldByName('cod_pessoa_produtor').AsInteger;
        CodAnimalSISBOVInicio      := FieldByName('cod_animal_sisbov_inicio').AsInteger;
        TxtObservacaoPedido        := FieldByName('txt_observacao_pedido').AsString;
        IndAnimaisRegistrados      := FieldByName('ind_animais_registrados').AsString;
        NumSolicitacaoSISBOV       := FieldByName('num_solicitacao_sisbov').AsInteger;

        // Verifica se o usuário tem acesso
        Result := VerificaPermissao(EConexao, EMensagens, PermiteAcesso,
          CodPessoaProdutor, True);
        if Result < 0 then
        begin
          Exit;
        end;
      end;

      // Verifica se a situação destino é valida
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_situacao_os_destino');
        SQL.Add('  from tab_mudanca_situacao_os');
        SQL.Add(' where cod_situacao_os_origem = :cod_situacao_os_origem');
        SQL.Add('   and cod_situacao_os_destino = :cod_situacao_os_destino');
        SQL.Add('   and ind_envia_pedido_ident = :ind_envia_pedido_ident');
        if not IndChamadaInterna then
        begin
          SQL.Add('   and ind_restrito_sistema = ''N''');
        end;
{$ENDIF}
        ParamByName('cod_situacao_os_origem').AsInteger := CodSituacaoOSAtual;
        ParamByName('cod_situacao_os_destino').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;
        Open;

        if IsEmpty or (CodSituacaoOSAtual = CodSituacaoOS) then
        begin
          if IndGerarMensagens then
          begin
            EMensagens.Adicionar(1823, Self.ClassName, NomeMetodo, []);
          end;
          Result := -1823;
          Exit;
        end;
      end;

      // Verifica se a OS esta cancelada.
      if CodSituacaoOSAtual = cCodSituacaoOSCancelada then
      begin
        // Verifica se existe uma OS válida com o mesmo número
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select 1');
          SQL.Add('  from tab_ordem_servico');
          SQL.Add(' where num_ordem_servico = :num_ordem_servico');
          SQL.Add('   and cod_situacao_os <> :cod_situacao_os');
{$ENDIF}
          ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
          ParamByName('cod_situacao_os').AsInteger := cCodSituacaoOSCancelada;
          Open;

          if not IsEmpty then
          begin
            if IndGerarMensagens then
            begin
              EMensagens.Adicionar(1945, Self.ClassName, NomeMetodo, []);
            end;
            Result := -1945;
            Exit;
          end;
        end;
      end;

      // Caso a situação destino seja CANCELADA e exista um boleto bancário
      // associado a OS, a situação não deverá ser alterada.
      if CodSituacaoOS = cCodSituacaoOSCancelada then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
          {$IFDEF MSSQL}
          SQL.Add(' select 1 ');
          SQL.Add('   from tab_boleto ');
          SQL.Add('  where cod_ordem_servico = :cod_ordem_servico ');
          SQL.Add('    and cod_situacao_boleto <> 99 ');
          {$ENDIF}
          ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Open;
          if not IsEmpty then
          begin
            EMensagens.Adicionar(2211, Self.ClassName, NomeMetodo, [IntToStr(NumOrdemServico)]);
            Result := -2211;
            Exit;
          end;
        end;
      end;

      // Verifica se todos os campos obrigatórios foram preenchidos
      if IndValidaAcessoAtributo then
      begin
        Result := ValidaCamposAlterados(EConexao, EMensagens, CodOrdemServico,
          QtdAnimais, CodPessoaTecnico, CodPessoaVendedor, CodFormaPagamentoOS,
          CodIdentificacaoDupla, CodFabricanteIdentificador,
          CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
          CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
          QtdProdutoAcessorio3, NumOrdemServico, CodSituacaoOS,
          IndEnviaPedidoIdent, TxtObservacaoPedido, IndAnimaisRegistrados, CodEnderecoEntregaCert,
          CodEnderecoEntregaIdent, CodEnderecoCobrancaIdent,
          CodAnimalSISBOVInicio, True, IndGerarMensagens);
        if Result < 0 then
        begin
          Exit;
        end;
      end;

      EConexao.BeginTran;
      with QueryLocal do
      begin
        SQL.Clear;
        {$IFDEF MSSQL}
        SQL.Add('update tab_ordem_servico');
        SQL.Add('   set cod_situacao_os = :cod_situacao_os,');
        SQL.Add('       dta_ultima_alteracao = getDate(),');
        if (CodSituacaoOSAtual = cCodSituacaoOSEnv2)
          and (CodSituacaoOS = cCodSituacaoOSPend) then
        begin
          SQL.Add('       num_pedido_fabricante = NULL,');
          SQL.Add('       cod_arquivo_remessa_pedido = NULL,');
        end;
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
        {$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('cod_usuario').AsInteger := EConexao.CodUsuario;
        ExecSQL;
      end;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
      //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := TIntClasseBDNavegacaoBasica.GravarLogOperacao(EConexao,
        EMensagens, 'tab_ordem_servico', CodRegistroLog, 2, 552);
      if Result < 0 then begin
        EConexao.Rollback;
        Exit;
      end;

      Result := InsereHistoricoSituacao(EConexao, EMensagens, CodOrdemServico,
        CodSituacaoOS, TxtObservacao);
      if Result < 0 then
      begin
        EConexao.Rollback;
        Exit;
      end;

      // Verifica se a OS esta sendo cancelada.
      if CodSituacaoOS = cCodSituacaoOSCancelada then
      begin
        // Verifica se a OS gerou solicitacao de numeros e se algum foi utilizado
        if (NumSolicitacaoSISBOV > 0) then
        begin
          with QueryLocal do
          begin
            Close;
            SQL.Clear;
            {$IFDEF MSSQL}
            SQL.Add('SELECT COUNT(*) AS QtdeCodigosDISP FROM tab_codigo_sisbov');
            SQL.Add('WHERE cod_ordem_servico = :cod_ordem_servico');
            SQL.Add('AND cod_situacao_codigo_sisbov = :cod_situacao_codigo');
            {$ENDIF}
            ParamByName('cod_ordem_servico').AsInteger   := CodOrdemServico;
            ParamByName('cod_situacao_codigo').AsInteger := 1;
            Open;
            if (FieldByName('QtdeCodigosDisp').AsInteger <> QtdAnimais) then
            begin
              raise Exception.Create('Não é possível CANCELAR a Ordem de Serviço. A solicitação de código vinculada possue códigos SISBOV sendo utilizados.');
            end
            else
              begin
                // CANCELAMENTO DA SOLICITACAO DE NUMERACAO
                RetornoCANC := nil;
                SoapSisbov := TIntSoapSisbov.Create;
                try
                  SoapSisbov.Inicializar(EConexao, EMensagens);
                  Conectado := SoapSisbov.conectado('Cancelamento da Solicitação de Numeração');
                  if not Conectado then begin
                    EMensagens.Adicionar(2289, Self.ClassName, NomeMetodo, ['não foi possível cancelar a solicitação de numeração']);
                    Result := -2289;
                    Exit;
                  end;
                  try
                    RetornoCANC := nil;

                    // Funcao cancelarSolicitacaoNumeracao
                    // Atualizada 16/09/2008 (conforme documentacao SISBOV)
                    // Permance ainda a chamada para a funcao anterior a esta data.
                    //
                    //RetornoCANC := SoapSisbov.cancelarSolicitacaoNumeracao(
                    //                     Descriptografar( EConexao.ValorParametro(118, EMensagens))
                    //                   , Descriptografar( EConexao.ValorParametro(119, EMensagens))
                    //                   , NumSolicitacaoSISBOV);

                  except
                    on E: Exception do
                    begin
                      EMensagens.Adicionar(9999, Self.ClassName, NomeMetodo, ['Houve um problema ao tentar cancelar a Solicitação de Numeração da Ordem de Serviço.']);
                      Result := -9999;
                    end;
                  end;
                finally
                  SoapSisbov.Free;
                end;
                if RetornoCANC <> nil then
                begin
                  if RetornoCANC.Status = 0 then
                  begin
                    EMensagens.Adicionar(9999, Self.ClassName, NomeMetodo, ['Houve um problema ao tentar cancelar a Solicitação de Numeração da Ordem de Serviço. Mensagem Sisbov : ' + _TrataMensagemErroCANC(RetornoCANC)]);
                    Result := -9999;
                    Exit;
                  end;
                end
                else
                  begin
                    EMensagens.Adicionar(9999, Self.ClassName, NomeMetodo, ['Houve um problema ao tentar cancelar a Solicitação de Numeração da Ordem de Serviço. Erro no retorno do Sisbov ']);
                    Result := -9999;
                    Exit;
                  end;
              end;
            Close;
          end;
        end;
        // Limpa os códigos sisbov relacionados a ela.
        with QueryLocal do
        begin
          SQL.Clear;
          {$IFDEF MSSQL}
          SQL.Add('update tab_codigo_sisbov');
          SQL.Add('   set cod_ordem_servico = NULL');
          SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
          {$ENDIF}
          ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          ExecSQL;
        end;
      end;
      EConexao.Commit;
      Result := 0;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1774, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1774;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.MudarSituacao(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, CodSituacaoOS: Integer;
  TxtObservacao: String; IndGerarMensagens: String;
  IndChamadaInterna: String): Integer;
const
  NomeMetodo = 'MudarSituacao';
begin
  try
    EConexao.BeginTran;

    Result := MudarSituacaoInt(EConexao, EMensagens, CodOrdemServico,
      CodSituacaoOS, TxtObservacao, UpperCase(IndGerarMensagens) = 'S',
      UpperCase(IndChamadaInterna) = 'S', True);

    if Result < 0 then
    begin
      EConexao.Rollback;
      Exit;
    end;

    EnviarEMail(EConexao, EMensagens, CodSituacaoOS, CodOrdemServico, 0, 0, 0,
     0, '', '', TxtObservacao, '', 0, '', '');

    EConexao.Commit;
  except
    on E: EHerdomException do
    begin
      E.GerarMensagem(EMensagens);
      Result := -E.CodigoErro;
      Exit;
    end;
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1774, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1774;
      Exit;
    end;
  end;
end;

class function TIntOrdensServico.AtualizarSolicitacaoSISBOV(
  CodPessoaProdutor, CodPropriedadeRural, QtdAnimais, NumSolicitacaoSISBOV,
  CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
  CodAnimalSISBOVInicio, NumDVSISBOVInicio: Integer; EConexao: TConexao; EMensagens: TIntMensagens): Integer;
const
  NomeMetodo: String = 'AtualizarSolicitacaoSISBOV';
  CodMetodo: Integer = 569;
  CodAplicativo: Integer = 4;
var
  FIntOcorrenciasSistema: TIntOcorrenciasSistema;
  QueryLocal: THerdomQuery;
  CodOrdemServico, NumOrdemServico: Integer;
  AtualizarQtdAnimais: boolean;
  EnviaPedidoIdent, IndEnviaPedidoIdent: String;

  procedure AtualizarOS;
  begin
      //Atualiza os dados da ORDEM DE SERVICO
      QueryLocal.SQL.Clear;
      QueryLocal.SQL.Add('update tab_ordem_servico ');
      QueryLocal.SQL.Add(' set num_solicitacao_sisbov = :num_solicitacao_sisbov, ');
      If not AtualizarQtdAnimais then begin
        // A quantidade de animais da OS deve ser maior que 0 e menor
        // que o limite de animais
        if (QtdAnimais < 1) or (QtdAnimais > cLimiteQtdAnimais) then begin
           EMensagens.Adicionar(1773, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
           Result := -1773;
           Exit;
        end;
        QueryLocal.SQL.Add('     qtd_animais = :qtd_animais, ');
      end;
      QueryLocal.SQL.Add('     cod_pais_sisbov_inicio = :cod_pais_sisbov, ');
      QueryLocal.SQL.Add('     cod_estado_sisbov_inicio = :cod_estado_sisbov, ');
      QueryLocal.SQL.Add('     cod_micro_regiao_sisbov_inicio = :cod_micro_regiao_sisbov, ');
      QueryLocal.SQL.Add('     cod_animal_sisbov_inicio = :cod_animal_sisbov, ');
      QueryLocal.SQL.Add('     num_dv_sisbov_inicio = :num_dv_sisbov, ');
      QueryLocal.SQL.Add('     dta_ultima_alteracao = (select getdate()), ');
      QueryLocal.SQL.Add('     cod_usuario_ultima_alteracao = :cod_usuario ');
      QueryLocal.SQL.Add(' where cod_ordem_servico = :cod_ordem_servico ');

      QueryLocal.ParamByName('num_solicitacao_sisbov').AsInteger  := NumSolicitacaoSISBOV;
      If not AtualizarQtdAnimais then begin
        // A quantidade de animais da OS deve ser maior que 0 e menor
        // que o limite de animais
        if (QtdAnimais < 1) or (QtdAnimais > cLimiteQtdAnimais) then begin
           EMensagens.Adicionar(1773, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
           Result := -1773;
           Exit;
        end;
        QueryLocal.ParamByName('qtd_animais').AsInteger           := QtdAnimais;
      end;
      QueryLocal.ParamByName('cod_pais_sisbov').AsInteger         := CodPaisSISBOVInicio;
      QueryLocal.ParamByName('cod_estado_sisbov').AsInteger       := CodEstadoSISBOVInicio;
      QueryLocal.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOVInicio;
      QueryLocal.ParamByName('cod_animal_sisbov').AsInteger       := CodAnimalSISBOVInicio;
      QueryLocal.ParamByName('num_dv_sisbov').AsInteger           := NumDVSISBOVInicio;
      QueryLocal.ParamByName('cod_ordem_servico').AsInteger       := CodOrdemServico;
      QueryLocal.ParamByName('cod_usuario').AsInteger             := EConexao.CodUsuario;
      QueryLocal.ExecSQL;
  end;

begin
  AtualizarQtdAnimais := false;

  FIntOcorrenciasSistema := TIntOcorrenciasSistema.Create;
  FIntOcorrenciasSistema.Inicializar(EConexao, EMensagens);

  If (CodPessoaProdutor < 0) or
    (CodPropriedadeRural < 0) or
    (QtdAnimais < 0) or
    (NumSolicitacaoSISBOV < 0) or
    (CodPaisSISBOVInicio < 0) or
    (CodEstadoSISBOVInicio < 0) or
    (CodMicroRegiaoSISBOVInicio < -1) or
    (CodAnimalSISBOVInicio < 0) or
    (NumDVSISBOVInicio < 0) then
  begin
    EMensagens.Adicionar(1869, Self.ClassName, NomeMetodo, []);
    Result := -1869;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Add(' select ind_envia_pedido_ident, cod_ordem_servico, qtd_animais, num_ordem_servico ');
        SQL.Add(' from ');
        SQL.Add('   tab_ordem_servico ');
        SQL.Add(' where ');
        SQL.Add('   cod_pessoa_produtor = :cod_pessoa_produtor ');
        SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
        SQL.Add('   and cod_situacao_os <> 99 '); //COD PARA OS CANCELADA
        SQL.Add('   and cod_animal_sisbov_inicio is null ');
        SQL.Add(' order by dta_cadastramento desc ');

        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Open;
      end;

      if QueryLocal.IsEmpty then
      begin
        Result := TIntOrdensServico.ObterProximoNumero(EConexao, EMensagens);
        if Result > 0 then
        begin
          NumOrdemServico := Result;
        end
        else
        if Result = 0 then
        begin
          // Se a geração do número da OS não for automática insere NULL
          NumOrdemServico := -1;
        end
        else
        begin
          Exit;
        end;

        IndEnviaPedidoIdent := EConexao.ValorParametro(84, EMensagens);
        AtualizarQtdAnimais := true;

        CodOrdemServico := TIntOrdensServico.Inserir(EConexao, EMensagens,
          NumOrdemServico, CodPessoaProdutor, '', '', CodPropriedadeRural, '', -1,
          QtdAnimais, IndEnviaPedidoIdent);
        if CodOrdemServico < 0 then
        begin
          Result := CodOrdemServico;
          Exit;               
        end;

        AtualizarOS;

        Result := TIntOrdensServico.MudarSituacao(EConexao, EMensagens,
          CodOrdemServico, 3, '', 'S', 'S'); //situacao para "Com códigos SISBOV carregados"
        if Result < 0 then
        begin
          // Se a geração de número da OS não for automatica informa o usuário
          // que não é possível gerar a ordem de serviço automaticamente.
          if EConexao.ValorParametro(GERAR_NUMERACAO_AUTOMATICA_OS,
            EMensagens) = 'N' then
          begin
            EMensagens.Adicionar(2111, Self.ClassName, NomeMetodo, []);
          end;
          Exit;
        end;

        Result := FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
          'Não havia Ordem de Serviço para a solicitação de códigos SISBOV. Uma Ordem de Serviço foi gerada automaticamente.',
          IntToStr(NumOrdemServico), 'Número da Ordem de Serviço');
        if Result < 0 then
        begin
          Exit;
        end;
      end
      else
      begin
        NumOrdemServico := -1;
        while not QueryLocal.Eof do
        begin
          if (QtdAnimais = QueryLocal.FieldByName('qtd_animais').AsInteger) then
          begin
            AtualizarQtdAnimais := true;
            CodOrdemServico  := QueryLocal.FieldByName('cod_ordem_servico').AsInteger;
            EnviaPedidoIdent := QueryLocal.FieldByName('ind_envia_pedido_ident').AsString;
            NumOrdemServico  := QueryLocal.FieldByName('num_ordem_servico').AsInteger;
          end
          else
          if not AtualizarQtdAnimais then
          begin
            CodOrdemServico  := QueryLocal.FieldByName('cod_ordem_servico').AsInteger;
            EnviaPedidoIdent := QueryLocal.FieldByName('ind_envia_pedido_ident').AsString;
            NumOrdemServico  := QueryLocal.FieldByName('num_ordem_servico').AsInteger;
          end;
          QueryLocal.Next;
        end;

          // Foi retirado essa atualização porque o controle de solicitação de
          // códigos sisbov, passou a ser realizado pela ordem de servico.
//        AtualizarOS;

        if not AtualizarQtdAnimais then begin
          Result := TIntOrdensServico.MudarSituacao(EConexao, EMensagens, CodOrdemServico, 3, '', 'S', 'S'); //situacao para "Códigos carregados, dados pendentes"
          if Result < 0 then exit;
        end else begin
          if EnviaPedidoIdent = 'S' then
          begin
            Result := TIntOrdensServico.MudarSituacao(EConexao, EMensagens,
              CodOrdemServico, 5, '', 'S', 'S'); //situacao para "Pedido de brincos pronto para envio"
          end
          else
          begin
            Result := TIntOrdensServico.MudarSituacao(EConexao, EMensagens,
              CodOrdemServico, 4, '', 'S', ''); //situacao para "OK"
          end;
          if Result < 0 then
            Result := TIntOrdensServico.MudarSituacao(EConexao, EMensagens, CodOrdemServico, 3, '', 'S', 'S'); //situacao para "Códigos carregados, dados pendentes"
            if Result < 0 then exit;
        end;

        if not AtualizarQtdAnimais then
        begin
          Result := FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
            'Foi encontrada uma Ordem de Serviço com a quantidade de animais diferente da informada. A quantidade de animais foi corrigida.',
            IntToStr(NumOrdemServico), 'Número da Ordem de Serviço');
        end;
      end;

      Result := CodOrdemServico;

    finally
      QueryLocal.Free;
      FIntOcorrenciasSistema.Free;
    end;
  except
    on E: Exception do
    begin
      EMensagens.Adicionar(1867, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1867;
      Exit;
    end;
 end;
end;

function TIntOrdensServico.PesquisarRelatorio(EQuery: THerdomQuery;
  NumOrdemServico: Integer;
  SglProdutor, NomProdutor, NumCNPJCPFProdutor,
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer;
  NomPropriedadeRural, NumCNPJCPFTecnico, NumCNPJCPFVendedor: String;
  QtdAnimaisInicio, QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
  IndApenasSemEnderecoEntregaCert: String; CodIdentificacaoDupla,
  CodFabricanteIdentificador: Integer; IndEnviaPedidoIdentificador,
  IndApenasSemEnderecoEntregaIdent,
  IndApenasSemEnderecoCobrancaIdent: String; NumPedidoFabricante,
  NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
  DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
  CodSituacaoOS, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV, CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
  DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
  NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
  CodSituacaoBoleto: Integer): Integer;
const
  NomeMetodo: String = 'PesquisarRelatorio';
  CodRelatorio: Integer = 25;
var
  Max, QtdDiasIntervalo: Integer;
  IntRelatorios: TIntRelatorios;
  sOrderBy: String;
  IndFiltroCodigoSISBOVInformado: Boolean;
  bDuplicaOS: Boolean;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  // Obtem parâmetro com o número máximo de OS para pesquisa
  Try
    Max := StrToInt(ValorParametro(cParametroQtdOSPesquisa));
    QtdDiasIntervalo := StrToInt(ValorParametro(cParametroQtdDiasIntervaloPesquisa));
  Except
    Result := -1;
    Exit;
  End;

  // Valida os CNPJ/CPF informados
  if not ValidaCnpjCpf(NumCNPJCPFProdutor, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFProdutor]);
    Result := -668;
    Exit;
  end;
  if not ValidaCnpjCpf(NumCNPJCPFVendedor, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFVendedor]);
    Result := -668;
    Exit;
  end;
  if not ValidaCnpjCpf(NumCNPJCPFTecnico, True, False, 'N') then
  begin
    Mensagens.Adicionar(668, Self.ClassName, NomeMetodo, [NumCNPJCPFTecnico]);
    Result := -668;
    Exit;
  end;

  // Valida o NIRF/INCRA
  if not ValidaNirfIncra(NumImovelReceitaFederal, False) then
  begin
    Mensagens.Adicionar(494, Self.ClassName, NomeMetodo, [NumImovelReceitaFederal]);
    Result := -494;
    Exit;
  end;

  // Verifica se a data de inicio do cadastramento é menor que a data fim.
  if (DtaCadastramentoInicio <> 0) and (DtaCadastramentoFim <> 0)
    and (DtaCadastramentoInicio > DtaCadastramentoFim) then
  begin
    Mensagens.Adicionar(1953, Self.ClassName, NomeMetodo, []);
    Result := -1953;
    Exit;
  end;

  { Verifica se a o período de filtro de códigos SISBOV foi informado
    sem a situação }
  if (CodSituacaoSISBOVSim = -1) and ((DtaSituacaoSISBOVSimInicio <> 0) or
    (DtaSituacaoSISBOVSimFim <> 0)) then
  begin
    Mensagens.Adicionar(2064, Self.ClassName, NomeMetodo, [6]);
    Result := -2064;
    Exit;
  end;

  // Verifica se a situação dos códigos SISBOV foi informada sem o período
  if (CodSituacaoSISBOVSim > -1) and ((DtaSituacaoSISBOVSimInicio = 0) or
    (DtaSituacaoSISBOVSimFim = 0) or
    (DtaSituacaoSISBOVSimFim - DtaSituacaoSISBOVSimInicio > QtdDiasIntervalo)) then
  begin
    Mensagens.Adicionar(2063, Self.ClassName, NomeMetodo, [IntToStr(QtdDiasIntervalo)]);
    Result := -2063;
    Exit;
  end;

  // Verifica se a situação não foi escolhida sem a situação sim
  if (CodSituacaoSISBOVSim = -1) and (CodSituacaoSISBOVNao > -1) then
  begin
    Mensagens.Adicionar(2065, Self.ClassName, NomeMetodo, []);
    Result := -2065;
    Exit;
  end;

  IndFiltroCodigoSISBOVInformado := CodSituacaoSISBOVSim > -1;

  // Verifica os campos selecionados

  if not IndFiltroCodigoSISBOVInformado then
  begin
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
      IntRelatorios.IrAoPrimeiro;
      while not IntRelatorios.EOF do
      begin
        if (IntRelatorios.ValorCampo('CodCampo') >= 89)
          and (IntRelatorios.ValorCampo('CodCampo') <= 102)
          and (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S') then
        begin
          Mensagens.Adicionar(2067, Self.ClassName, NomeMetodo,
            [IntRelatorios.ValorCampo('TxtTitulo')]);
          Result := -2067;
          Exit;
        end;
        IntRelatorios.IrAoProximo;
      end;
      IntRelatorios.IrAoPrimeiro;
    Finally
      IntRelatorios.Free;
    end;
  end;

  try
    with EQuery do
    begin
      // Gera o Order by de acordo com os campos do relatório
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

        // Monta o order by
        sOrderBy := '';
        IntRelatorios.IrAoPrimeiro;
        bDuplicaOS := False;
        while not IntRelatorios.EOF do begin
          if (IntRelatorios.ValorCampo('NumParcelaBoleto') = 'S')        or
             (IntRelatorios.ValorCampo('NomBanco') = 'S')                or
             (IntRelatorios.ValorCampo('SglSituacaoBoleto') = 'S')       or
             (IntRelatorios.ValorCampo('DesSituacaoBoleto') = 'S')       or
             (IntRelatorios.ValorCampo('ValTotalBoleto') = 'S')          or
             (IntRelatorios.ValorCampo('NumRemessaBoleto') = 'S')        or
             (IntRelatorios.ValorCampo('DtaGeracaoRemessaBoleto') = 'S') or
             (IntRelatorios.ValorCampo('DtaVencimentoBoleto') = 'S')     or
             (IntRelatorios.ValorCampo('ValPagoBoleto') = 'S')           or
             (IntRelatorios.ValorCampo('DtaCreditoEfetivado') = 'S')     or
             (IntRelatorios.ValorCampo('DtaCadastramentoBoleto') = 'S') then
          begin
            bDuplicaOS := True;
          end;

          if IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S' then
          begin
            if sOrderBy = '' then
              sOrderBy := ' '
            else
              sOrderBy := sOrderBy + ', ';
            sOrderBy := sOrderBy + IntRelatorios.ValorCampo('NomField');
          end;
          IntRelatorios.IrAoProximo;
        end;
        IntRelatorios.IrAoPrimeiro;
      finally
        IntRelatorios.Free;
      end;

      SQL.Clear;
{$IFDEF MSSQL}
      if bDuplicaOS then
      begin
        SQL.Add('  SELECT top ' + IntToStr(Max) + ' tos.cod_ordem_servico AS CodOrdemServico,');
      end
      else
      begin
        SQL.Add('  SELECT DISTINCT top ' + IntToStr(Max) + ' tos.cod_ordem_servico AS CodOrdemServico,');
      end;
      SQL.Add('         tos.num_ordem_servico AS NumOrdemServico,');
      SQL.Add('         tos.cod_pessoa_produtor AS CodPessoaProdutor,');
      SQL.Add('         tpr.sgl_produtor AS SglProdutor,');
      SQL.Add('         tpp.nom_pessoa AS NomProdutor,');
      SQL.Add('         tpp.num_cnpj_cpf AS NumCNPJCPFProdutor,');
      SQL.Add('       case tpp.cod_natureza_pessoa ');
      SQL.Add('         when ''F'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 1, 3) + ''.'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 4, 3) + ''.'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 7, 3) + ''-'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 10, 2)) ');
      SQL.Add('         when ''J'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 1, 2) + ''.'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 3, 3) + ''.'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 6, 3) + ''/'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 9, 4) + ''-'' + ');
      SQL.Add('                             substring(tpp.num_cnpj_cpf, 13, 2)) ');
      SQL.Add('       end as NumCNPJCPFProdutorFormatado, ');
      SQL.Add('         tos.cod_propriedade_rural AS CodPropriedadeRural,');
      SQL.Add('         tppr.nom_propriedade_rural AS NomPropriedadeRural,');
      SQL.Add('         tppr.num_imovel_receita_federal AS NumImovelReceitaFederal,');
      SQL.Add('         tos.cod_pessoa_tecnico AS CodPessoaTecnico,');
      SQL.Add('         tpt.nom_pessoa AS NomTecnico,');
      SQL.Add('         tpt.num_cnpj_cpf AS NumCNPJCPFTecnico,');
      SQL.Add('       case tpt.cod_natureza_pessoa ');
      SQL.Add('         when ''F'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 1, 3) + ''.'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 4, 3) + ''.'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 7, 3) + ''-'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 10, 2)) ');
      SQL.Add('         when ''J'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 1, 2) + ''.'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 3, 3) + ''.'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 6, 3) + ''/'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 9, 4) + ''-'' + ');
      SQL.Add('                             substring(tpt.num_cnpj_cpf, 13, 2)) ');
      SQL.Add('       end as NumCNPJCPFTecnicoFormatado, ');
      SQL.Add('         tos.cod_pessoa_vendedor AS CodPessoaVendedor,');
      SQL.Add('         tpv.nom_pessoa AS NomVendedor,');
      SQL.Add('         tpv.num_cnpj_cpf AS NumCNPJCPFVendedor,');
      SQL.Add('       case tpv.cod_natureza_pessoa ');
      SQL.Add('         when ''F'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 1, 3) + ''.'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 4, 3) + ''.'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 7, 3) + ''-'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 10, 2)) ');
      SQL.Add('         when ''J'' then convert(varchar(18), ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 1, 2) + ''.'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 3, 3) + ''.'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 6, 3) + ''/'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 9, 4) + ''-'' + ');
      SQL.Add('                             substring(tpv.num_cnpj_cpf, 13, 2)) ');
      SQL.Add('       end as NumCNPJCPFVendedorFormatado, ');
      SQL.Add('         tos.qtd_animais AS QtdAnimais,');
      SQL.Add('         tos.num_solicitacao_sisbov AS NumSolicitacaoSISBOV,');
      SQL.Add('         tos.cod_pais_sisbov_inicio AS CodPaisSISBOVInicial,');
      SQL.Add('         tos.cod_estado_sisbov_inicio AS CodEstadoSISBOVInicial,');
      SQL.Add('         tos.cod_micro_regiao_sisbov_inicio AS CodMicroRegiaoSISBOVInicial,');
      SQL.Add('         tos.cod_animal_sisbov_inicio AS CodAnimalSISBOVInicial,');
      SQL.Add('         tos.num_dv_sisbov_inicio AS NumDVSISBOVInicial,');
      SQL.Add('         tos.cod_forma_pagamento_os AS CodFormaPagamentoOS,');
      SQL.Add('         tfpo.des_forma_pagamento_os AS DesFormaPagamentoOS,');
      SQL.Add('         tos.cod_endereco_entrega_cert AS CodEnderecoEntregaCert,');
      SQL.Add('         teec.cod_tipo_endereco AS CodTipoEnderecoEC,');
      SQL.Add('         tteec.sgl_tipo_endereco AS SglTipoEnderecoEC,');
      SQL.Add('         tteec.des_tipo_endereco AS DesTipoEnderecoEC,');
      SQL.Add('         teec.nom_pessoa_contato AS NomPessoaContatoEC,');
      SQL.Add('         teec.num_telefone AS NumTelefoneEC,');
      SQL.Add('         teec.num_fax AS NumFaxEC,');
      SQL.Add('         teec.txt_email AS TxtEmailEC,');
      SQL.Add('         teec.nom_logradouro AS NomLogradouroEC,');
      SQL.Add('         teec.nom_bairro AS NomBairroEC,');
      SQL.Add('         teec.num_cep AS NumCEPEC,');
      SQL.Add('         teec.cod_distrito AS CodDistritoEC,');
      SQL.Add('         tdec.nom_distrito AS NomDistritoEC,');
      SQL.Add('         teec.cod_municipio AS CodMunicipioEC,');
      SQL.Add('         tmec.num_municipio_ibge AS NumMunicipioIBGEEC,');
      SQL.Add('         tmec.nom_municipio AS NomMunicipioEC,');
      SQL.Add('         teec.cod_estado AS CodEstadoEC,');
      SQL.Add('         tedec.sgl_estado AS SglEstadoEC,');
      SQL.Add('         tedec.nom_estado AS NomEstadoEC,');
      SQL.Add('         teec.cod_pais AS CodPaisEC,');
      SQL.Add('         tpec.nom_pais AS NomPaisEC,');
      SQL.Add('         tos.cod_identificacao_dupla AS CodIdentificacaoDupla,');
      SQL.Add('         tid.sgl_identificacao_dupla AS SglIdentificacaoDupla,');
      SQL.Add('         tid.des_identificacao_dupla AS DesIdentificacaoDupla,');
      SQL.Add('         tos.cod_fabricante_identificador AS CodFabricanteIdentificador,');
      SQL.Add('         tfi.nom_reduzido_fabricante AS NomReduzidoFabricante,');
      SQL.Add('         tos.cod_forma_pagamento_ident AS CodFormaPagamentoIdent,');
      SQL.Add('         tfpi.des_forma_pagamento_ident AS DesFormaPagamentoIdent,');
      SQL.Add('         tos.cod_endereco_entrega_ident AS CodEnderecoCobrancaIdent,');
      SQL.Add('         teci.cod_tipo_endereco AS CodTipoEnderecoCI,');
      SQL.Add('         tteci.sgl_tipo_endereco AS SglTipoEnderecoCI,');
      SQL.Add('         tteci.des_tipo_endereco AS DesTipoEnderecoCI,');
      SQL.Add('         teci.nom_pessoa_contato AS NomPessoaContatoCI,');
      SQL.Add('         teci.num_telefone AS NumTelefoneCI,');
      SQL.Add('         teci.num_fax AS NumFaxCI,');
      SQL.Add('         teci.txt_email AS TxtEmailCI,');
      SQL.Add('         teci.nom_logradouro AS NomLogradouroCI,');
      SQL.Add('         teci.nom_bairro AS NomBairroCI,');
      SQL.Add('         teci.num_cep AS NumCEPCI,');
      SQL.Add('         teci.cod_distrito AS CodDistritoCI,');
      SQL.Add('         tdci.nom_distrito AS NomDistritoCI,');
      SQL.Add('         teci.cod_municipio AS CodMunicipioCI,');
      SQL.Add('         tmci.num_municipio_ibge AS NumMunicipioIBGECI,');
      SQL.Add('         tmci.nom_municipio AS NomMunicipioCI,');
      SQL.Add('         teci.cod_estado AS CodEstadoCI,');
      SQL.Add('         tedci.sgl_estado AS SglEstadoCI,');
      SQL.Add('         tedci.nom_estado AS NomEstadoCI,');
      SQL.Add('         teci.cod_pais AS CodPaisCI,');
      SQL.Add('         tpci.nom_pais AS NomPaisCI,');
      SQL.Add('         tos.cod_endereco_cobranca_ident AS CodEnderecoEntregaIdent,');
      SQL.Add('         teei.cod_tipo_endereco AS CodTipoEnderecoEI,');
      SQL.Add('         tteei.sgl_tipo_endereco AS SglTipoEnderecoEI,');
      SQL.Add('         tteei.des_tipo_endereco AS DesTipoEnderecoEI,');
      SQL.Add('         teei.nom_pessoa_contato AS NomPessoaContatoEI,');
      SQL.Add('         teei.num_telefone AS NumTelefoneEI,');
      SQL.Add('         teei.num_fax AS NumFaxEI,');
      SQL.Add('         teei.txt_email AS TxtEmailEI,');
      SQL.Add('         teei.nom_logradouro AS NomLogradouroEI,');
      SQL.Add('         teei.nom_bairro AS NomBairroEI,');
      SQL.Add('         teei.num_cep AS NumCEPEI,');
      SQL.Add('         teei.cod_distrito AS CodDistritoEI,');
      SQL.Add('         tdei.nom_distrito AS NomDistritoEI,');
      SQL.Add('         teei.cod_municipio AS CodMunicipioEI,');
      SQL.Add('         tmei.num_municipio_ibge AS NumMunicipioIBGEEI,');
      SQL.Add('         tmei.nom_municipio AS NomMunicipioEI,');
      SQL.Add('         teei.cod_estado AS CodEstadoEI,');
      SQL.Add('         tedei.sgl_estado AS SglEstadoEI,');
      SQL.Add('         tedei.nom_estado AS NomEstadoEI,');
      SQL.Add('         teei.cod_pais AS CodPaisEI,');
      SQL.Add('         tpei.nom_pais AS NomPaisEI,');
      SQL.Add('         tos.cod_modelo_identificador_1 AS CodModeloIdentificador1,');
      SQL.Add('         tmi1.sgl_modelo_identificador AS SglModeloIdentificador1,');
      SQL.Add('         tmi1.des_modelo_identificador AS DesModeloIdentificador1,');
      SQL.Add('         tos.cod_modelo_identificador_2 AS CodModeloIdentificador2,');
      SQL.Add('         tmi2.sgl_modelo_identificador AS SglModeloIdentificador2,');
      SQL.Add('         tmi2.Des_modelo_identificador AS DesModeloIdentificador2,');
      SQL.Add('         tos.cod_produto_acessorio_1 AS CodProdutoAcessorio1,');
      SQL.Add('         tpa1.sgl_produto_acessorio AS SglProdutoAcessorio1,');
      SQL.Add('         tpa1.des_produto_acessorio AS DesProdutoAcessorio1,');
      SQL.Add('         tos.qtd_produto_acessorio_1 AS QtdProdutoAcessorio1,');
      SQL.Add('         tos.cod_produto_acessorio_2 AS CodProdutoAcessorio2,');
      SQL.Add('         tpa2.sgl_produto_acessorio AS SglProdutoAcessorio2,');
      SQL.Add('         tpa2.des_produto_acessorio AS DesProdutoAcessorio2,');
      SQL.Add('         tos.qtd_produto_acessorio_2 AS QtdProdutoAcessorio2,');
      SQL.Add('         tos.cod_produto_acessorio_3 AS CodProdutoAcessorio3,');
      SQL.Add('         tpa3.sgl_produto_acessorio AS SglProdutoAcessorio3,');
      SQL.Add('         tpa3.des_produto_acessorio AS DesProdutoAcessorio3,');
      SQL.Add('         tos.qtd_produto_acessorio_3 AS QtdProdutoAcessorio3,');
      SQL.Add('         tos.num_pedido_fabricante AS NumPedidoFabricante,');
      SQL.Add('         tos.cod_arquivo_remessa_pedido AS CodArquivoRemessaPedido,');
      SQL.Add('         tarp.num_remessa_fabricante AS NumRemessa,');
      SQL.Add('         tarp.dta_criacao_arquivo as DtaGeracaoRemessaPedido,');
      SQL.Add('         tos.dta_cadastramento AS DtaCadastramento,');
      SQL.Add('         tos.cod_usuario_cadastramento AS CodUsuarioCadastramento,');
      SQL.Add('         tu.nom_USUARIO AS NomUsuarioCadastramento,');
      SQL.Add('         tos.dta_ultima_alteracao AS DtaUltimaMudancaSituacao,');
      SQL.Add('         tos.cod_usuario_ultima_alteracao AS CodusuarioUltimaMudanca,');
      SQL.Add('         tum.nom_usuario AS NomUsuarioUltimaMudanca,');
      SQL.Add('         tos.cod_situacao_os AS CodSituacaoOS,');
      SQL.Add('         tsos.sgl_situacao_os AS SglSituacaoOS,');
      SQL.Add('         tsos.des_situacao_os AS DesSituacaoOS,');
      SQL.Add('         tos.txt_observacao AS TxtObservacao,');
      SQL.Add('         tos.txt_observacao_pedido AS TxtObservacaoPedido,');
      if (CodPaisSISBOV > -1) or (CodSituacaoSISBOVSim > -1) then
      begin
        SQL.Add('       tcs.DtaUltimoRecebimentoFicha,');
        SQL.Add('       tcs.QtdCodigosRecebimentoFicha,');
        SQL.Add('       tcs.DtaUltimaAprovacaoFicha,');
        SQL.Add('       tcs.QtdCodigosAprovacaoFicha,');
        SQL.Add('       tcs.DtaUltimaUtilizacaoCodigo,');
        SQL.Add('       tcs.QtdCodigosUtilizacao,');
        SQL.Add('       tcs.DtaUltimaEfetivacaoCadastro,');
        SQL.Add('       tcs.QtdCodigosEfetivacaoCadastro,');
        SQL.Add('       tcs.DtaUltimaAutenticacao,');
        SQL.Add('       tcs.QtdCodigosAutenticacao,');
        SQL.Add('       tcs.DtaUltimaImpressaoCertificado,');
        SQL.Add('       tcs.QtdCodigosImpressaoCertificado,');
        SQL.Add('       tcs.DtaUltimoEnvioCertificado,');
        SQL.Add('       tcs.QtdCodigosEnvioCertificado,');
      end;
      SQL.Add('         tls.cod_localizacao_sisbov as CodLocalizacaoSisbov,');
      SQL.Add('         CASE IsNull(tos.ind_animais_registrados,'''')');
      SQL.Add('           WHEN ''''  THEN ''''');
      SQL.Add('           WHEN ''S'' THEN ''SIM'' ELSE ''NÃO''');
      SQL.Add('         end AS IndAnimaisRegistrados, ');
      SQL.Add('         tb.num_parcela as NumParcelaBoleto, ');
      SQL.Add('         tib.nom_banco as NomBanco, ');
      SQL.Add('         tsb.sgl_situacao_boleto as SglSituacaoBoleto, ');
      SQL.Add('         tsb.des_situacao_boleto as DesSituacaoBoleto, ');
      SQL.Add('         tb.val_total_boleto as ValTotalBoleto, ');
      SQL.Add('         tb.dta_geracao_remessa as DtaGeracaoRemessaBoleto, ');
      SQL.Add('         tb.dta_vencimento_boleto as DtaVencimentoBoleto, ');
      SQL.Add('         tb.val_pago_boleto as ValPagoBoleto, ');
      SQL.Add('         tb.dta_credito_efetivado as DtaCreditoEfetivado, ');
      SQL.Add('         tb.dta_cadastramento as DtaCadastramentoBoleto, ');
      SQL.Add('         tb.cod_arquivo_remessa_boleto as NumRemessaBoleto');
      SQL.Add('    FROM tab_ordem_servico tos ');
      SQL.Add('           left join tab_pessoa tpv ');
      SQL.Add('             on tpv.cod_pessoa = tos.cod_pessoa_vendedor ');
      SQL.Add('           left join tab_endereco                 teec ');
      SQL.Add('             on teec.cod_endereco = tos.cod_endereco_entrega_cert ');
      SQL.Add('           left join tab_tipo_endereco tteec ');
      SQL.Add('             on tteec.cod_tipo_endereco = teec.cod_tipo_endereco ');
      SQL.Add('           left join tab_distrito      tdec ');
      SQL.Add('             on tdec.cod_distrito = teec.cod_distrito ');
      SQL.Add('           left join tab_municipio     tmec ');
      SQL.Add('             on tmec.cod_municipio = teec.cod_municipio ');
      SQL.Add('           left join tab_estado        tedec ');
      SQL.Add('             on tedec.cod_estado = teec.cod_estado ');
      SQL.Add('           left join tab_pais          tpec');
      SQL.Add('             on tpec.cod_pais = teec.cod_pais');
      SQL.Add('           left join tab_identificacao_dupla      tid');
      SQL.Add('             on tid.cod_identificacao_dupla = tos.cod_identificacao_dupla');
      SQL.Add('           left join tab_fabricante_identificador tfi');
      SQL.Add('             on tfi.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('           left join tab_endereco                 teei');
      SQL.Add('             on teei.cod_endereco = tos.cod_endereco_entrega_ident');
      SQL.Add('           left join tab_tipo_endereco tteei');
      SQL.Add('             on tteei.cod_tipo_endereco = teei.cod_tipo_endereco');
      SQL.Add('           left join tab_distrito      tdei');
      SQL.Add('             on tdei.cod_distrito = teei.cod_distrito');
      SQL.Add('           left join tab_municipio     tmei');
      SQL.Add('             on tmei.cod_municipio = teei.cod_municipio');
      SQL.Add('           left join tab_estado        tedei');
      SQL.Add('             on tedei.cod_estado = teei.cod_estado');
      SQL.Add('           left join tab_pais          tpei');
      SQL.Add('             on tpei.cod_pais = teei.cod_pais');
      SQL.Add('           left join tab_endereco                 teci');
      SQL.Add('             on teci.cod_endereco = tos.cod_endereco_cobranca_ident');
      SQL.Add('           left join tab_tipo_endereco tteci');
      SQL.Add('             on tteci.cod_tipo_endereco = teci.cod_tipo_endereco');
      SQL.Add('           left join tab_distrito      tdci');
      SQL.Add('             on tdci.cod_distrito = teci.cod_distrito');
      SQL.Add('           left join tab_municipio     tmci');
      SQL.Add('             on tmci.cod_municipio = teci.cod_municipio');
      SQL.Add('           left join tab_estado        tedci');
      SQL.Add('             on tedci.cod_estado = teci.cod_estado');
      SQL.Add('           left join tab_pais          tpci');
      SQL.Add('             on tpci.cod_pais = teci.cod_pais');
      SQL.Add('           left join tab_forma_pagamento_ident    tfpi');
      SQL.Add('             on tfpi.cod_forma_pagamento_ident = tos.cod_forma_pagamento_ident');
      SQL.Add('                and tfpi.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('           left join tab_modelo_identificador     tmi1');
      SQL.Add('             on tmi1.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('                and tmi1.cod_modelo_identificador = tos.cod_modelo_identificador_1');
      SQL.Add('           left join tab_modelo_identificador     tmi2');
      SQL.Add('             on tmi2.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('                and tmi2.cod_modelo_identificador = tos.cod_modelo_identificador_2');
      SQL.Add('           left join tab_produto_acessorio        tpa1');
      SQL.Add('             on tpa1.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('                and tpa1.cod_produto_acessorio = tos.cod_produto_acessorio_1');
      SQL.Add('           left join tab_produto_acessorio        tpa2');
      SQL.Add('             on tpa2.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('                and tpa2.cod_produto_acessorio = tos.cod_produto_acessorio_2');
      SQL.Add('           left join tab_produto_acessorio        tpa3');
      SQL.Add('             on tpa3.cod_fabricante_identificador = tos.cod_fabricante_identificador');
      SQL.Add('                and tpa3.cod_produto_acessorio = tos.cod_produto_acessorio_3');
      SQL.Add('           left join tab_arquivo_remessa_pedido   tarp');
      SQL.Add('             on tarp.cod_arquivo_remessa_pedido = tos.cod_arquivo_remessa_pedido');
      SQL.Add('           left join tab_forma_pagamento_os       tfpo');
      SQL.Add('             on tfpo.cod_forma_pagamento_os = tos.cod_forma_pagamento_os');
      SQL.Add('           left join tab_pessoa                   tpt');
      SQL.Add('             on tpt.cod_pessoa = tos.cod_pessoa_tecnico');
      SQL.Add('           LEFT JOIN tab_boleto tb');
      SQL.Add('             ON tb.cod_ordem_servico = tos.cod_ordem_servico');
      SQL.Add('           LEFT JOIN tab_situacao_boleto tsb');
      SQL.Add('             ON tb.cod_situacao_boleto = tsb.cod_situacao_boleto');
      SQL.Add('           LEFT JOIN tab_identificacao_bancaria tib');
      SQL.Add('             ON tb.cod_identificacao_bancaria = tib.cod_identificacao_bancaria,');
      SQL.Add('         tab_produtor                 tpr,');
      SQL.Add('         tab_pessoa                   tpp,');
      SQL.Add('         tab_propriedade_rural        tppr,');
      SQL.Add('         tab_usuario                  tu,');
      SQL.Add('         tab_usuario                  tum,');
      SQL.Add('         tab_localizacao_sisbov       tls,');
      // Se o usuário for um tecnico filtrar a OS
      if Conexao.CodPapelUsuario = 1 then
      begin
        SQL.Add('       tab_associacao_produtor tap, -- Produtores que o associação atende');
      end;
      if (CodPaisSISBOV > -1) or (CodSituacaoSISBOVSim > -1) then
      begin
        SQL.Add('(select tcs1.cod_ordem_servico,');
        SQL.Add('        MAX(tcs1.dta_recebimento_ficha) AS DtaUltimoRecebimentoFicha,');
        SQL.Add('        COUNT(tcs1.dta_recebimento_ficha) AS QtdCodigosRecebimentoFicha,');
        SQL.Add('        MAX(tcs1.dta_aprovacao_ficha) AS DtaUltimaAprovacaoFicha,');
        SQL.Add('        COUNT(tcs1.dta_aprovacao_ficha) AS QtdCodigosAprovacaoFicha,');
        SQL.Add('        MAX(tcs1.dta_utilizacao_codigo) AS DtaUltimaUtilizacaoCodigo,');
        SQL.Add('        COUNT(tcs1.dta_utilizacao_codigo) AS QtdCodigosUtilizacao,');
        SQL.Add('        MAX(tcs1.dta_efetivacao_cadastro) AS DtaUltimaEfetivacaoCadastro,');
        SQL.Add('        COUNT(tcs1.dta_efetivacao_cadastro) AS QtdCodigosEfetivacaoCadastro,');
        SQL.Add('        MAX(tcs1.dta_autenticacao) AS DtaUltimaAutenticacao,');
        SQL.Add('        COUNT(tcs1.dta_autenticacao) AS QtdCodigosAutenticacao,');
        SQL.Add('        MAX(tcs1.dta_impressao_certificado) AS DtaUltimaImpressaoCertificado,');
        SQL.Add('        COUNT(tcs1.dta_impressao_certificado) AS QtdCodigosImpressaoCertificado,');
        SQL.Add('        MAX(tcs1.dta_envio_certificado) AS DtaUltimoEnvioCertificado,');
        SQL.Add('        COUNT(tcs1.dta_envio_certificado) AS QtdCodigosEnvioCertificado');
        SQL.Add('   from tab_codigo_sisbov tcs1');
        if CodSituacaoSISBOVSim > -1 then
        begin
          SQL.Add('  WHERE tcs1.' + cNomeCamposSituacaoCodigoSisbov[CodSituacaoSISBOVSim]
            + ' BETWEEN :dta_situacao_sisbov_inicio AND :dta_situacao_sisbov_fim');
          if CodSituacaoSISBOVNao > -1 then
          begin
            SQL.Add('  AND tcs1.' + cNomeCamposSituacaoCodigoSisbov[CodSituacaoSISBOVNao]
              + ' IS NULL');
          end;
        end;
        SQL.Add(' group by cod_ordem_servico) as tcs,');
      end;
      SQL.Add('         tab_situacao_os              tsos');
      SQL.Add('   WHERE tpr.cod_pessoa_produtor = tos.cod_pessoa_produtor');
      SQL.Add('     AND tpp.cod_pessoa = tos.cod_pessoa_produtor');
      SQL.Add('     AND tppr.cod_propriedade_rural = tos.cod_propriedade_rural');
      SQL.Add('     AND tpp.cod_pessoa = tls.cod_pessoa_produtor');
      SQL.Add('     AND tppr.cod_propriedade_rural = tls.cod_propriedade_rural');
      SQL.Add('     AND tu.cod_usuario = tos.cod_usuario_cadastramento');
      SQL.Add('     AND tum.cod_usuario = tos.cod_usuario_ultima_alteracao');
      SQL.Add('     AND tsos.cod_situacao_os = tos.cod_situacao_os');
      // Se o usuário for uma associação de raça filtrar a OS
      if Conexao.CodPapelUsuario = 1 then
      begin
        SQL.Add('   AND tap.cod_pessoa_produtor = tos.cod_pessoa_produtor');
        SQL.Add('   AND tap.cod_pessoa_associacao = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um tecnico filtrar a OS
      else if Conexao.CodPapelUsuario = 3 then
      begin
        SQL.Add('   AND tos.cod_pessoa_tecnico = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um produtor filtrar a OS
      else if Conexao.CodPapelUsuario = 4 then
      begin
        SQL.Add('   AND tpr.cod_pessoa_produtor = ' + IntToStr(Conexao.CodPessoa));
      end
      // Se o usuário for um gestor filtrar por OS relacionadas a técnicos do gestor
      else if Conexao.CodPapelUsuario = 9 then
      begin
        SQL.Add('   AND tos.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ');
        SQL.Add('                                    where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null ' +
                '                                      and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = ' + IntToStr(Conexao.CodPessoa)+ ')');
      end;
      
{$ENDIF}

      if NumOrdemServico > -1 then
      begin
        SQL.Add('  AND tos.num_ordem_servico = :num_ordem_servico');
      end;
      if SglProdutor <> '' then
      begin
        SQL.Add('  AND tpr.sgl_produtor = :sgl_produtor');
      end;
      if NomProdutor <> '' then
      begin
        SQL.Add('  AND tpp.nom_pessoa like ''%' + NomProdutor + '%''');
      end;
      if NomPropriedadeRural <> '' then
      begin
        SQL.Add('  AND tpr.nom_propriedade_rural like ''%' + NomPropriedadeRural + '%''');
      end;
      if NumCNPJCPFProdutor <> '' then
      begin
        SQL.Add('  AND tpp.num_cnpj_cpf = :num_cnpj_cpf_produtor');
      end;
      if NumCNPJCPFTecnico <> '' then
      begin
        SQL.Add('  AND tpt.num_cnpj_cpf = :num_cnpj_cpf_tecnico');
      end;
      if NumCNPJCPFVendedor <> '' then
      begin
        SQL.Add('  AND tpv.num_cnpj_cpf = :num_cnpj_cpf_vendedor');
      end;
      if NumImovelReceitaFederal <> '' then
      begin
        SQL.Add('  AND tppr.num_imovel_receita_federal = :num_imovel_receita_federal');
      end;
      if CodLocalizacaoSisbov > 0 then
      begin
        SQL.Add('  AND tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
      end;
      if QtdAnimaisInicio > -1 then
      begin
        SQL.Add('  AND tos.qtd_animais >= :qtd_animais_inicio');
      end;
      if QtdAnimaisFim > -1 then
      begin
        SQL.Add('  AND tos.qtd_animais <= :qtd_animais_fim');
      end;
      if NumSolicitacaoSISBOV > -1 then
      begin
        SQL.Add('  AND tos.num_solicitacao_sisbov = :num_solicitacao_sisbov');
      end;
      if not (UpperCase(IndApenasSemEnderecoEntregaCert) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_entrega_cert is null');
      end;
      if not (UpperCase(IndApenasSemEnderecoEntregaIdent) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_entrega_ident is null');
      end;
      if not (UpperCase(IndApenasSemEnderecoCobrancaIdent) <> 'S') then
      begin
        SQL.Add('  AND tos.cod_endereco_cobranca_ident is null');
      end;
      if CodIdentificacaoDupla > -1 then
      begin
        SQL.Add('  AND tos.cod_identificacao_dupla = :cod_identificacao_dupla');
      end;
      if CodFabricanteIdentificador > -1 then
      begin
        SQL.Add('  AND tos.cod_fabricante_identificador = :cod_fabricante_identificador');
      end;
      if NumPedidoFabricante > -1 then
      begin
        SQL.Add('  AND tos.num_pedido_fabricante = :num_pedido_fabricante');
      end;
      if NumRemessa > -1 then
      begin
        SQL.Add('  AND tarp.num_remessa_fabricante = :num_remessa_fabricante');
      end;
      if DtaCadastramentoInicio > 0 then
      begin
        SQL.Add('  AND tos.dta_cadastramento >= :dta_cadastramento_inicio');
      end;
      if DtaCadastramentoFim > 0 then
      begin
        SQL.Add('  AND tos.dta_cadastramento < :dta_cadastramento_fim');
      end;
      if DtaMudancaSituacaoInicio > 0 then
      begin
        SQL.Add('  AND tos.dta_ultima_alteracao >= :dta_ultima_mudanca_situacao_inicio');
      end;
      if DtaMudancaSituacaoFim > 0 then
      begin
        SQL.Add('  AND tos.dta_ultima_alteracao < :dta_ultima_mudanca_situacao_fim');
      end;
      if CodSituacaoOS > -1 then
      begin
        SQL.Add('  AND tos.cod_situacao_os = :cod_situacao_os');
      end;
      if IndEnviaPedidoIdentificador <> '' then
      begin
        SQL.Add('  AND tos.ind_envia_pedido_ident = :ind_envia_pedido_identificador');
      end;
      if (CodPaisSISBOV > -1) or (CodSituacaoSISBOVSim > -1) then
      begin
        SQL.Add('  AND tos.cod_ordem_servico = tcs.cod_ordem_servico');
      end;
      if CodPaisSISBOV > -1 then
      begin
        SQL.Add('  AND tcs.cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('  AND tcs.cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('  AND tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('  AND tcs.cod_animal_sisbov = :cod_animal_sisbov)');
      end;

      if NumDiasBoletoAVencer > 0 then
      begin
        SQL.Add('  AND tb.dta_vencimento_boleto >= getdate() and tb.dta_vencimento_boleto <= :dta_a_vencer');
      end;
      if NumDiasBoletoEmAtraso > 0 then
      begin
        SQL.Add('  AND tb.dta_vencimento_boleto >= :dta_em_atraso and tb.dta_vencimento_boleto <= getdate() ');
      end;
      if NumDiasBoletoPago > 0 then
      begin
        SQL.Add('  AND tb.dta_credito_efetivado >= :dta_pago and tb.dta_credito_efetivado <= getdate() ');
      end;
      if CodSituacaoBoleto > 0 then
      begin
        SQL.Add('  AND tb.cod_situacao_boleto = :cod_situacao_boleto ');
      end;
      SQL.Add('ORDER BY ' + sOrderBy);

      if NumOrdemServico > -1 then
      begin
        ParamByName('num_ordem_servico').AsInteger := NumOrdemServico;
      end;
      if SglProdutor <> '' then
      begin
        ParamByName('sgl_produtor').AsString := SglProdutor;
      end;
      if NumCNPJCPFProdutor <> '' then
      begin
        ParamByName('num_cnpj_cpf_produtor').AsString := NumCNPJCPFProdutor;
      end;
      if NumCNPJCPFTecnico <> '' then
      begin
        ParamByName('num_cnpj_cpf_tecnico').AsString := NumCNPJCPFTecnico;
      end;
      if NumCNPJCPFVendedor <> '' then
      begin
        ParamByName('num_cnpj_cpf_vendedor').AsString := NumCNPJCPFVendedor;
      end;
      if NumImovelReceitaFederal <> '' then
      begin
        ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
      end;
      if CodLocalizacaoSisbov > 0 then
      begin
        ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      end;
      if QtdAnimaisInicio > -1 then
      begin
        ParamByName('qtd_animais_inicio').AsInteger := QtdAnimaisInicio;
      end;
      if QtdAnimaisFim > -1 then
      begin
        ParamByName('qtd_animais_fim').AsInteger := QtdAnimaisFim;
      end;
      if NumSolicitacaoSISBOV > -1 then
      begin
        ParamByName('num_solicitacao_sisbov').AsInteger := NumSolicitacaoSISBOV;
      end;
      if CodIdentificacaoDupla > -1 then
      begin
        ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
      end;
      if CodFabricanteIdentificador > -1 then
      begin
        ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
      end;
      if NumPedidoFabricante > -1 then
      begin
        ParamByName('num_pedido_fabricante').AsInteger := NumPedidoFabricante;
      end;
      if NumRemessa > -1 then
      begin
        ParamByName('num_remessa_fabricante').AsInteger := NumRemessa;
      end;
      if DtaCadastramentoInicio > 0 then
      begin
        ParamByName('dta_cadastramento_inicio').AsDateTime := DtaCadastramentoInicio;
      end;
      if DtaCadastramentoFim > 0 then
      begin
        ParamByName('dta_cadastramento_fim').AsDateTime := DateOf(DtaCadastramentoFim) + 1;
      end;
      if DtaMudancaSituacaoInicio > 0 then
      begin
        ParamByName('dta_ultima_mudanca_situacao_inicio').AsDateTime := DtaMudancaSituacaoInicio;
      end;
      if DtaMudancaSituacaoFim > 0 then
      begin
        ParamByName('dta_ultima_mudanca_situacao_fim').AsDateTime := DateOf(DtaMudancaSituacaoFim) + 1;
      end;
      if CodSituacaoOS > -1 then
      begin
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
      end;
      if IndEnviaPedidoIdentificador <> '' then
      begin
        ParamByName('ind_envia_pedido_identificador').AsString := IndEnviaPedidoIdentificador;
      end;
      if CodPaisSISBOV > -1 then
      begin
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
      end;
      if CodSituacaoSISBOVSim > -1 then
      begin
        ParamByName('dta_situacao_sisbov_inicio').AsDateTime := DateOf(DtaSituacaoSISBOVSimInicio);
        ParamByName('dta_situacao_sisbov_fim').AsDateTime := DateOf(DtaSituacaoSISBOVSimFim);
      end;

      if NumDiasBoletoAVencer > 0 then
      begin
        ParamByName('dta_a_vencer').AsDateTime := Now + NumDiasBoletoAVencer;
      end;
      if NumDiasBoletoEmAtraso > 0 then
      begin
        ParamByName('dta_em_atraso').AsDateTime := Now - NumDiasBoletoEmAtraso;
      end;
      if NumDiasBoletoPago > 0 then
      begin
        ParamByName('dta_pago').AsDateTime := Now - NumDiasBoletoPago;
      end;
      if CodSituacaoBoleto > 0 then
      begin
        ParamByName('cod_situacao_boleto').AsInteger := CodSituacaoBoleto;
      end;

      Open;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1961, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1961;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.GerarRelatorio(NumOrdemServico: Integer;
  SglProdutor, NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal:String;
  CodLocalizacaoSisbov: Integer; NomPropriedadeRural, NumCNPJCPFTecnico,
  NumCNPJCPFVendedor: String; QtdAnimaisInicio, QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
  IndApenasSemEnderecoEntregaCert: String; CodIdentificacaoDupla,
  CodFabricanteIdentificador: Integer; IndEnviaPedidoIdentificador,
  IndApenasSemEnderecoEntregaIdent,
  IndApenasSemEnderecoCobrancaIdent: String; NumPedidoFabricante,
  NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
  DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
  CodSituacaoOS, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV, CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
  DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
  NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
  CodSituacaoBoleto: Integer; CodOrdenacao, IndordenacaoCrescent: String;
  Tipo, QtdQuebraRelatorio: Integer): String;
const
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 25;
var
  Rel: TRelatorioPadrao;
  Retorno,
  iAux,
  QtdRegistros,
  Max: Integer;
  sQuebra,
  sAux: String;
  bTituloQuebra,
  bAvancou: Boolean;
  vAux: Array [1..2] of Variant;
  QueryLocal: THerdomQuery;
begin
//  Result := '';
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(554) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := '';
    Exit;
  end;

  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  QueryLocal := THerdomQuery.Create(Conexao, nil);
  try
    Retorno := PesquisarRelatorio(QueryLocal, NumOrdemServico, SglProdutor,
      NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov,
      NomPropriedadeRural, NumCNPJCPFTecnico, NumCNPJCPFVendedor, QtdAnimaisInicio,
      QtdAnimaisFim, NumSolicitacaoSISBOV, IndApenasSemEnderecoEntregaCert,
      CodIdentificacaoDupla, CodFabricanteIdentificador,
      IndEnviaPedidoIdentificador, IndApenasSemEnderecoEntregaIdent,
      IndApenasSemEnderecoCobrancaIdent, NumPedidoFabricante, NumRemessa,
      DtaCadastramentoInicio, DtaCadastramentoFim, DtaMudancaSituacaoInicio,
      DtaMudancaSituacaoFim, CodSituacaoOS, CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOV, CodSituacaoSISBOVSim,
      CodSituacaoSISBOVNao, DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim,
      NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
      CodSituacaoBoleto);

    if Retorno < 0 then
    begin
      Exit;
    end;

    if QueryLocal.IsEmpty then
    begin
      Mensagens.Adicionar(1479, Self.ClassName, NomeMetodo, []);
      Exit;
    end;

    Rel.TipoDoArquvio := Tipo;
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then
    begin
      Exit;
    end;

    // Consiste se o número de quebras é válido
    if Rel.Campos.NumCampos < QtdQuebraRelatorio then begin
      Mensagens.Adicionar(1384, Self.ClassName, NomeMetodo, []);
      Exit;
    end;

    // Desabilita a apresentação dos campos selecionados para quebra
    Rel.Campos.IrAoPrimeiro;
    for iAux := 1 to QtdQuebraRelatorio do
    begin
      Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
      Rel.Campos.IrAoProximo;
    end;

    // Inicializa o procedimento de geração do arquivo de relatório
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then
    begin
      Exit;
    end;

    sQuebra := '';
    bTituloQuebra := False;
    QtdRegistros := 0;
    while not QueryLocal.EOF do
    begin
      Inc(QtdRegistros);
      bAvancou := False;
      // Atualiza o campo valor do atributo Campos do relatorio
      // c/ os dados da query
      Rel.Campos.CarregarValores(QueryLocal);
      Rel.Campos.SalvarValores;

      // Realiza tratamento de quebras somente para formato PDF
      if Tipo = ctaPDF then
      begin
        if Rel.LinhasRestantes <= 2 then
        begin
          {Verifica se o próximo registro existe, para que o último registro
          do relatório possa ser exibido na próxima folha, e assim o total não
          seja mostrado sozinho nesta folha}
          QueryLocal.Next;
          bAvancou := True;
          if QueryLocal.Eof then
          begin
            Rel.NovaPagina;
          end;
        end;
        if QtdQuebraRelatorio > 0 then
        begin
          // Percorre o(s) campo(s) informado(s) para quebra
          sAux := '';
          for iAux := 1 to QtdQuebraRelatorio do
          begin
            // Concatena o valor dos campos de quebra, montando o título
            vAux[iAux] := Rel.Campos.ValorCampoIdx[iAux-1];
            sAux := SE(sAux = '', sAux, sAux + ' / ') +
              TrataQuebra(Rel.Campos.TextoTituloIdx[iAux-1]) + ': ' +
              Rel.Campos.ValorCampoIdx[iAux-1];
          end;
          if (sAux <> sQuebra) then
          begin
            {Se ocorreu mudança na quebra atual ou é a primeira ('')
             Apresenta subtotal para quebra concluída, caso não seja a primeira}
            sQuebra := sAux;
            if Rel.LinhasRestantes <= 4 then
            begin
              {Verifica se a quebra possui somente um registro e se o espaço é su-
              ficiênte para a impressão de título, registro e subtotal, caso
              contrário quebra a página antes da impressão}
              if not bAvancou then
              begin
                QueryLocal.Next;
                bAvancou := True;
              end;
              if QueryLocal.Eof then
              begin
                Rel.NovaPagina;
              end
              else
              begin
                Rel.Campos.CarregarValores(QueryLocal);
                for iAux := 1 to QtdQuebraRelatorio do
                begin
                  if (rel.LinhasRestantes <= 2)
                    or (vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1]) then
                  begin
                    Rel.NovaPagina;
                    Break;
                  end;
                end;
                // Verifica se uma nova página foi gerada, caso não salta uma linha
                if Rel.LinhasRestantes < Rel.LinhasPorPagina then
                begin
                  Rel.NovaLinha;
                end;
              end;
            end
            else if Rel.LinhasRestantes < Rel.LinhasPorPagina then
            begin
              // Salta uma linha antes da quebra, caso não seja a primeira da pág.
              Rel.NovaLinha;
            end;
            // Imprime título da quebra
            Rel.FonteNegrito;
            Rel.ImprimirTexto(0, sQuebra);
            Rel.FonteNormal;
          end
          else if bTituloQuebra then
          begin
            // Repete o título da quebra no topo da nova pág. qdo ocorrer
            // quebra de pág.
            Rel.NovaPagina;
            Rel.FonteNegrito;
            Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
            Rel.FonteNormal;
          end;
        end;

        {Verifica se o registro a ser apresentado é o último da quebra, caso
        seja faz com que ele possa ser exibido na próxima folha, e assim o
        subtotal e/ou o total não sejam mostrados sozinhos nesta folha}
        if (Rel.LinhasRestantes <= 2) and (QtdQuebraRelatorio > 0) then
        begin
          if not bAvancou then
          begin
             QueryLocal.Next;
             bAvancou := True;
          end;
          if not QueryLocal.Eof then
          begin
            {Caso uma nova pág. seja necessária, apresenta o texto da
            quebra novamente no início da nova página concatenado com o
            texto "(continuação)"}
            Rel.Campos.CarregarValores(QueryLocal);
            for iAux := 1 to QtdQuebraRelatorio do
            begin
              if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then
              begin
                Rel.NovaPagina;
                Rel.FonteNegrito;
                Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                Rel.FonteNormal;
                Break;
              end;
            end;
          end;
        end;
      end;
      Rel.Campos.RecuperarValores;
      Rel.ImprimirColunas;
      bTituloQuebra := (Rel.LinhaCorrente = Rel.LinhasPorPagina);
      if not bAvancou then
      begin
        QueryLocal.Next;
      end;
    end;

    // Obtem parâmetro com o número máximo de OS para pesquisa
    Try
      Max := StrToInt(ValorParametro(cParametroQtdOSPesquisa));
    Except
      Result := '';
      Exit;
    End;

    If Max = QtdRegistros Then Begin
      Mensagens.Adicionar(1820, Self.ClassName, NomeMetodo, [IntToStr(Max), IntToStr(Max)]);
    End;

    Retorno := Rel.FinalizarRelatorio;
    if Retorno = 0 then
    begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
    QueryLocal.Free;
  end;
end;

function TIntOrdensServico.DefinirCodigoSISBOVInicio(CodOrdemServico,
  CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
  CodAnimalSISBOVInicio, NumDVSISBOVInicio: Integer): Integer;
const
  NomeMetodo: String = 'DefinirCodigoSISBOVInicio';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
  IndEnviaPedidoIdent,
  TxtMensagem: String;
  QtdAnimais,
  CodPessoaProdutor,
  CodPropriedadeRural,
  CodRegistroLog,
  CodSituacaoOS,
  CodPaisSISBOVAtual,
  CodIdentificacaoDupla: Integer;
  CodigosSISBOV: TIntCodigosSisbov;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(577) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Valida o CodPaisSISBOVInicio
  if CodPaisSISBOVInicio < 0 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['código SISBOV do país']);
    Result := -1875;
    Exit;
  end;

  // Valida o CodEstadoSISBOVInicio
  if CodEstadoSISBOVInicio < 0 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['código SISBOV do estado']);
    Result := -1875;
    Exit;
  end;

  // Valida o CodMicroRegiaoSISBOVInicio
  if CodMicroRegiaoSISBOVInicio < -1 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['código SISBOV da micro região']);
    Result := -1875;
    Exit;
  end;

  // Valida o CodAnimalSISBOVInicio
  if CodAnimalSISBOVInicio < 0 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['código SISBOV do animal']);
    Result := -1875;
    Exit;
  end;

  // Valida o CodAnimalSISBOVInicio
  if NumDVSISBOVInicio <> BuscarDVSisBov(CodPaisSISBOVInicio,
    CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio, CodAnimalSISBOVInicio ) then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['digito verificador do código SISBOV do animal']);
    Result := -1875;
    Exit;
  end;

  try
    CodigosSISBOV := TIntCodigosSisbov.Create;
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      Result := CodigosSISBOV.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;

      // Obtem os dados básicos da  OS e verifica se o usuário tem acesso à OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       cod_pessoa_produtor,');
        SQL.Add('       cod_propriedade_rural,');
        SQL.Add('       qtd_animais,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       cod_registro_log,');
        SQL.Add('       isNull(cod_pais_sisbov_inicio, -1) as cod_pais_sisbov_inicio,');
        SQL.Add('       num_dv_sisbov_inicio,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        QtdAnimais := FieldByName('qtd_animais').AsInteger;
        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
        IndEnviaPedidoIdent := FieldByName('ind_envia_pedido_ident').AsString;
        CodPessoaProdutor := FieldByName('cod_pessoa_produtor').AsInteger;
        CodPropriedadeRural := FieldByName('cod_propriedade_rural').AsInteger;
        CodRegistroLog := FieldByName('cod_registro_log').AsInteger;
        CodPaisSISBOVAtual := FieldByName('cod_pais_sisbov_inicio').AsInteger;
        CodIdentificacaoDupla := FieldByName('cod_identificacao_dupla').AsInteger;
      end;

      // Verifica se a OS pode ser alterada
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select tsaos.ind_pode_alterar,');
        SQL.Add('       tsos.des_situacao_os');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_situacao_os tsos');
        SQL.Add(' where tsaos.cod_situacao_os = tsos.cod_situacao_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsos.cod_situacao_os = :cod_situacao_os');
        SQL.Add('   and tsaos.cod_atributo_os = 19');
{$ENDIF}
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;

        Open;
        if FieldByName('ind_pode_alterar').AsString = 'N' then
        begin
          Mensagens.Adicionar(1873, Self.ClassName, NomeMetodo,
            ['Códigos SISBOV']);
          Result := -1873;
          Exit;
        end;
      end;

      // Verifica se algum dos códigos está sendo utilizado
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select count(cod_animal_sisbov) as QtdCodigos');
        SQL.Add('  from tab_codigo_sisbov');
        SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   and cod_animal_sisbov between :cod_animal_sisbov_inicio and :cod_animal_sisbov_fim');
        SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        SQL.Add('   and dta_utilizacao_codigo is NULL');
        SQL.Add('   and cod_ordem_servico is NULL');
        SQL.Add('   and cod_situacao_codigo_sisbov = 1'); // DISP
{$ENDIF}
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOVInicio;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOVInicio;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOVInicio;
        ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
        ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVInicio + QtdAnimais - 1;
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

        Open;

        if IsEmpty or (FieldByName('QtdCodigos').AsInteger <> QtdAnimais) then
        begin
          Mensagens.Adicionar(1876, Self.ClassName, NomeMetodo, []);
          Result := -1876;
          Exit;
        end;
      end;

      // Verifica se a identificação dupla é válida de acordo com os códigos
      // SISBOV associados á OS.
      try
        ValidarIdentificacaoDupla(Conexao, Mensagens, CodIdentificacaoDupla,
          CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
          CodAnimalSISBOVInicio);
      except
        on E: EHerdomException do
        begin
          E.gerarMensagem(Mensagens);
          Result := -E.CodigoErro;
          Exit;
        end;
      end;

      BeginTran;

      // Libera os códigos SISBOV
      if CodPaisSISBOVAtual > -1 then
      begin
        CodigosSISBOV.LimparOrdemServicoCodigos(CodOrdemServico);
      end;

      CodigosSISBOV.AlterarOrdemServico(CodPaisSISBOVInicio,
        CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
        CodAnimalSISBOVInicio, CodAnimalSISBOVInicio + QtdAnimais - 1,
        CodOrdemServico);

      // Atualiza os códigos SISBOV para utilizados
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_ordem_servico');
        SQL.Add('   set cod_pais_sisbov_inicio = :cod_pais_sisbov_inical,');
        SQL.Add('       cod_estado_sisbov_inicio = :cod_estado_sisbov_inicial,');
        SQL.Add('       cod_micro_regiao_sisbov_inicio = :cod_micro_regiao_sisbov_inicial,');
        SQL.Add('       cod_animal_sisbov_inicio = :cod_animal_sisbov_inicial,');
        SQL.Add('       num_dv_sisbov_inicio = :num_dv_sisbov_inicial,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate()');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_pais_sisbov_inical').AsInteger := CodPaisSISBOVInicio;
        ParamByName('cod_estado_sisbov_inicial').AsInteger := CodEstadoSISBOVInicio;
        ParamByName('cod_micro_regiao_sisbov_inicial').AsInteger := CodMicroRegiaoSISBOVInicio;
        ParamByName('cod_animal_sisbov_inicial').AsInteger := CodAnimalSISBOVInicio;
        ParamByName('num_dv_sisbov_inicial').AsInteger := NumDVSISBOVInicio;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
        //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 1, 577);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Trava a transação para que os método de mudança de situação não interrompa a transção
      Conexao.IgnorarNovasTransacoes := True;

      // Muda o status da OS
      if IndEnviaPedidoIdent = 'S' then
      begin
        // se a situação atual da OS for cadastrada ou "Códigos SISBOV Solicitados"
        if CodSituacaoOS in [1, 2] then
        begin
          // Se não deu certo tenta alterar a situação para 'PEND'
          Result := MudarSituacao(Conexao, Mensagens, CodOrdemServico, 3, '', 'S', 'S');
        end;
      end
      else
      begin
        // se a situação atual da OS for cadastrada ou "Códigos SISBOV Solicitados"
        if CodSituacaoOS in [1, 2] then
        begin
          // Tenta alterar a situação para 'OK'
          Result := MudarSituacao(Conexao, Mensagens, CodOrdemServico, 4, '', 'S', 'S');
        end;
      end;
      Conexao.IgnorarNovasTransacoes := False;

      if Result < 0 then
      begin
        TxtMensagem := Mensagens.Items[Mensagens.Count - 1].Texto;
        Mensagens.Clear;
        Mensagens.Adicionar(1887, Self.ClassName, NomeMetodo, [TxtMensagem]);
        Result := -1887;
        Rollback;
        Exit;
      end;

      Commit;
    finally
      QueryLocal.Free;
      CodigosSISBOV.Free;
    end;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1877, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1877;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.LimparCodigoSISBOVInicio(
  CodOrdemServico: Integer): Integer;
const
  NomeMetodo: String = 'LimparCodigoSISBOVInicio';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
  IndEnviaPedidoIdent: String;
  CodSituacaoOS: Integer;
  CodigosSISBOV: TIntCodigosSisbov;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(587) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    CodigosSISBOV := TIntCodigosSisbov.Create;
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      Result := CodigosSISBOV.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;

      // Obtem os dados básicos da  OS e verifica se o usuário tem acesso à OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       cod_pessoa_produtor,');
        SQL.Add('       cod_propriedade_rural,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       isNull(cod_pais_sisbov_inicio, -1) as cod_pais_sisbov_inicio,');
        SQL.Add('       cod_registro_log');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
        IndEnviaPedidoIdent := FieldByName('ind_envia_pedido_ident').AsString;

        // Verifica se a OS está associada a algum código
        if FieldByName('cod_pais_sisbov_inicio').AsInteger = -1 then
        begin
          // Se não estiver finaliza a função com sucesso.
          Result := 0;
          Exit;
        end;
      end;

      // Verifica se a OS pode ser alterada
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select tsaos.ind_pode_alterar,');
        SQL.Add('       tsos.des_situacao_os');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_situacao_os tsos');
        SQL.Add(' where tsaos.cod_situacao_os = tsos.cod_situacao_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsos.cod_situacao_os = :cod_situacao_os');
        SQL.Add('   and tsaos.cod_atributo_os = 19');
{$ENDIF}
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;

        Open;
        if FieldByName('ind_pode_alterar').AsString <> 'S' then
        begin
          Mensagens.Adicionar(1873, Self.ClassName, NomeMetodo,
            ['Códigos SISBOV']);
          Result := -1873;
          Exit;
        end;
      end;

      BeginTran;

      CodigosSISBOV.LimparOrdemServicoCodigos(CodOrdemServico);

      // Libera os códigos SISBOV
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_ordem_servico');
        SQL.Add('   set cod_pais_sisbov_inicio = NULL,');
        SQL.Add('       cod_estado_sisbov_inicio = NULL,');
        SQL.Add('       cod_micro_regiao_sisbov_inicio = NULL,');
        SQL.Add('       cod_animal_sisbov_inicio = NULL,');
        SQL.Add('       num_dv_sisbov_inicio = NULL,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate()');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        ExecSQL;

        Result := TIntOrdensServico.MudarSituacao(Conexao, Mensagens,
          CodOrdemServico, 1, '', 'N', 'S');
        if Result < 0 then
        begin
          exit;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
      CodigosSISBOV.Free;
    end;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1877, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1877;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.MudarEnviarPedidoIdentificador(
  CodOrdemServico: Integer; IndEnviaPedidoIdent: String): Integer;
const
  NomeMetodo: String = 'MudarEnviarPedidoIdentificador';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
  CodSituacaoOS: Integer;
  CodRegistroLog: Integer;
  IndEnviaPedidoIdentAtual: String;
  IndAnimaisRegistrados: String;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(578) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  IndEnviaPedidoIdent := UpperCase(IndEnviaPedidoIdent);
  if (IndEnviaPedidoIdent <> 'S')
    and (IndEnviaPedidoIdent <> 'N') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomeMetodo, ['IndEnviaPedidoIdent']);
    Result := -1895;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem os dados básicos da  OS e verifica se o usuário tem acesso à OS
      with QueryLocal do
      begin
        Close;
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       cod_pessoa_produtor,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       cod_registro_log');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        if IndEnviaPedidoIdent = FieldByName('ind_envia_pedido_ident').AsString then
        begin
          Mensagens.Adicionar(1878, Self.ClassName, NomeMetodo, []);
          Result := -1878;
          Exit;
        end;

        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
        CodRegistroLog := FieldByName('cod_registro_log').AsInteger;
        IndEnviaPedidoIdentAtual :=
          FieldByName('ind_envia_pedido_ident').AsString;
      end;

      // Verifica se a OS pode ser alterada
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select tsaos.ind_pode_alterar,');
        SQL.Add('       tsos.des_situacao_os');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_situacao_os tsos');
        SQL.Add(' where tsaos.cod_situacao_os = tsos.cod_situacao_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsos.cod_situacao_os = :cod_situacao_os');
        SQL.Add('   and tsaos.cod_atributo_os = 18');
{$ENDIF}
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdentAtual;

        Open;
        if FieldByName('ind_pode_alterar').AsString = 'N' then
        begin
          Mensagens.Adicionar(1885, Self.ClassName, NomeMetodo, []);
          Result := -1885;
          Exit;
        end;
      end;

      // Trava a transação para que os método de mudança de situação não interrompa a transção
      BeginTran;

      with QueryLocal do
      begin
        Close;
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_ordem_servico');
        SQL.Add('   set ind_envia_pedido_ident = :ind_envia_pedido_ident,');
        if IndEnviaPedidoIdent = 'N' then begin
          SQL.Add('       cod_fabricante_identificador = NULL,');
          SQL.Add('       cod_modelo_identificador_1 = NULL,');
          SQL.Add('       cod_modelo_identificador_2 = NULL,');
          SQL.Add('       cod_forma_pagamento_ident = NULL,');
          SQL.Add('       cod_endereco_entrega_ident = NULL,');
          SQL.Add('       cod_endereco_cobranca_ident = NULL,');
          SQL.Add('       cod_produto_acessorio_1 = NULL,');
          SQL.Add('       qtd_produto_acessorio_1 = NULL,');
          SQL.Add('       cod_produto_acessorio_2 = NULL,');
          SQL.Add('       qtd_produto_acessorio_2 = NULL,');
          SQL.Add('       cod_produto_acessorio_3 = NULL,');
          SQL.Add('       qtd_produto_acessorio_3 = NULL,');
        end;
        SQL.Add('       ind_animais_registrados = :ind_animais_registrados,');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao,');
        SQL.Add('       dta_ultima_alteracao = getDate()');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;

        If IndEnviaPedidoIdent = 'S' then
          IndAnimaisRegistrados := ValorParametro(92)
        else
          IndAnimaisRegistrados := '';

        AtribuiParametro(QueryLocal, IndAnimaisRegistrados, 'ind_animais_registrados', '');
        ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
        //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 1, 578);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      Conexao.IgnorarNovasTransacoes := True;

      // Se a situação for OK altera para PEND
      if CodSituacaoOS = 4 then
      begin
        Result := MudarSituacao(Conexao, Mensagens, CodOrdemServico, 3, '', 'N', 'S');
      end
      else // Se a situação for ENV1 altera para OK
      if CodSituacaoOS = 5 then
      begin
        Result := MudarSituacao(Conexao, Mensagens, CodOrdemServico, 4, '', 'N', 'S');
      end;

      Conexao.IgnorarNovasTransacoes := False;

      if Result < 0 then
      begin
        Mensagens.Adicionar(1887, Self.ClassName, NomeMetodo, []);
        Result := -1887;
        Rollback;
        Exit;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1886, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1886;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.PesquisarSituacaoCodigoSisBov(CodOrdemServico: Integer;
                                                         IndMostrarDataMudancaSituacao: String): Integer;
const
  NomMetodo: String = 'PesquisarSituacaoCodigoSisBov';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
begin
  IndMostrarDataMudancaSituacao := UpperCase(IndMostrarDataMudancaSituacao);
  if (IndMostrarDataMudancaSituacao <> 'S')
    and (IndMostrarDataMudancaSituacao <> 'N') then
  begin
    Mensagens.Adicionar(1895, Self.ClassName, NomMetodo, ['IndMostrarDataMudancaSituacao']);
    Result := -1895;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try

      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_pessoa_produtor');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;

        // Verifica se a OS existe
        Open;
        if isEmpty then
        begin
          Mensagens.Adicionar(1744, Self.ClassName, NomMetodo, []);
          Result := -1744;
          Exit;
        end;

        // Verifica se o usuário tem permissão de acesso à OS
        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or not IndAcessoLiberado then
        begin
          Exit;
        end;
      end;
    finally
      QueryLocal.Free;
    end;

    with Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select tscs.sgl_situacao_codigo_sisbov  as SglSituacaoSisBov,');
      SQL.Add('       tscs.des_situacao_codigo_sisbov  as DesSituacaoSisBov,');
      if UpperCase(IndMostrarDataMudancaSituacao) = 'S' then
      begin
        SQL.Add('       CAST(CONVERT(CHAR(10), tcs.dta_mudanca_situacao, 110) as datetime) as DtaMudancaSituacao,');
      end;
      SQL.Add('       tcs.cod_ordem_servico as CodOrdemServico,');
      SQL.Add('       tscs.num_ordem as NumOrdem,');
      SQL.Add('       Count(1) as QtdCodigoSisBov');
      SQL.Add('  from tab_codigo_sisbov          tcs,');
      SQL.Add('       tab_situacao_codigo_sisbov tscs');
      SQL.Add(' where tcs.cod_situacao_codigo_sisbov = tscs.cod_situacao_codigo_sisbov');
      SQL.Add('   and tcs.cod_ordem_servico = :cod_ordem_servico');
      SQL.Add('group by tscs.sgl_situacao_codigo_sisbov,');
      SQL.Add('         tscs.des_situacao_codigo_sisbov,');
      SQL.Add('         tcs.cod_ordem_servico,');
      if UpperCase(IndMostrarDataMudancaSituacao) = 'S' then
      begin
        SQL.Add('        CAST(CONVERT(CHAR(10), tcs.dta_mudanca_situacao, 110) as datetime),');
      end;
      SQL.Add('          tscs.num_ordem');
      SQL.Add('order by tscs.num_ordem asc');
      if UpperCase(IndMostrarDataMudancaSituacao) = 'S' then
      begin
        SQL.Add('    , CAST(CONVERT(CHAR(10), tcs.dta_mudanca_situacao, 110) as datetime) ');
      end;
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
    end;

    Query.Open;

    if Query.IsEmpty then
    begin
      Mensagens.Adicionar(1896, Self.ClassName, NomMetodo, [IntToStr(CodOrdemServico)]);
      Result := -1896;
      Exit;
    end;
  except
    on E:Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1880, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1880;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.PesquisarDataLiberacaoAbate(CodOrdemServico: Integer): Integer;
const
   NomMetodo: String = 'PesquisarDataLiberacaoAbate';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try

      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_pessoa_produtor');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;

        // Verifica se a OS existe
        Open;
        if isEmpty then
        begin
          Mensagens.Adicionar(1744, Self.ClassName, NomMetodo, []);
          Result := -1744;
          Exit;
        end;

        // Verifica se o usuário tem permissão de acesso à OS
        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or not IndAcessoLiberado then
        begin
          Exit;
        end;
      end;
    finally
      QueryLocal.Free;
    end;

    with Query do
    begin
      Close;
      SQL.Text := ' Select ' +
                  '      CAST(CONVERT(CHAR(10), tcs.dta_liberacao_abate, 110) as datetime) as DtaLiberacaoAbate ' +
                  '    , Count(1)                as QtdCodigosSisBov ' +
                  '    , tcs.cod_ordem_servico   as CodOrdemServico ' +
                  ' From ' +
                  '    tab_codigo_sisbov tcs ' +
                  ' Where ' +
                  '    tcs.cod_ordem_servico = :cod_ordem_servico ' +
                  ' Group By ' +
                  '    CAST(CONVERT(CHAR(10), tcs.dta_liberacao_abate, 110) as datetime), tcs.cod_ordem_servico ' +
                  ' Order By ' +
                  '    CAST(CONVERT(CHAR(10), tcs.dta_liberacao_abate, 110) as datetime) desc ';
      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
    end;

    Query.Open;

    if Query.IsEmpty then
    begin
      Mensagens.Adicionar(1896, Self.ClassName, NomMetodo, [IntToStr(CodOrdemServico)]);
      Result := -1896;
      Exit;
    end;
  except
    on E:Exception do
    begin
       Rollback;
       Mensagens.Adicionar(1881, Self.ClassName, NomMetodo, [E.Message]);
       Result := -1881;
       Exit;
    end;
  end;
end;

function TIntOrdensServico.GerarRelatorioFichaOrdemServico(CodOrdemServico, TipoDoArquivo: Integer): String;
const
   CodMetodo: Integer = 581;
   NomMetodo: String = 'GerarRelatorioFichaOrdemServico';
   CodRelatorio: Integer = 26;
   sQuebraLinha : String = #13#10;
var
  FichaOS: TRelatorioPadrao;
  sTxtSubTitulo,
  sQuebra,
  sFichaOS,
  Cabecalho,
  Cabecalho2,
  sNroInicial, sNroFinal: String;
  Retorno: Integer;
  LinhaEmNegrito: Integer;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
{  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  }
  Retorno := Buscar(CodOrdemServico);
  if Retorno < 0 then Exit;

  Retorno := PesquisarHistoricoSituacao(CodOrdemServico);
  if Query.IsEmpty then Exit;
  if Retorno < 0 then Exit;

  sTxtSubTitulo := 'Ordem de Serviço nº ' + IntToStr(FOrdemServico.NumOrdemServico);

  Try
     FichaOS := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
     FichaOS.TipoDoArquvio := TipoDoArquivo;

     FichaOS.TxtSubTitulo := sTxtSubTitulo;
     FichaOS.FormatarTxtDados := False;
     FichaOS.PrimeiraLinhaNegritoTxtDados := True;
     FichaOS.CodTamanhoFonteTxtDados := 2;
     FichaOS.TxtDados := sFichaOS;
     sQuebra := '';

     //Monta a CAPA da OS.
     FichaOS.CodOrientacao   := 1;
     FichaOS.CodTamanhoFonte := 2;
     FichaOS.QtdColunas      := 1;
     FichaOS.TxtTitulo       := 'Ficha da Ordem de Serviço';

     {Inicializa o procedimento de geração do arquivo de relatório}
     Retorno := FichaOS.InicializarRelatorio;
     if Retorno < 0 then Exit;

     FichaOS.InicializarQuadro('N');
     if Length(FOrdemServico.NumCNPJCPFProdutor) = 11 then begin
        SFichaOS := 'Produtor:       ' + PadR(Trim(FOrdemServico.SglProdutor) + ' - ' + RedimensionaString(FOrdemServico.NomProdutor, 40), ' ', 45);
        sFichaOS := sFichaOS + 'CPF:           ' + FOrdemServico.NumCNPJCPFProdutorFormatado;
     end else begin
        SFichaOS := 'Produtor:       ' + PadR(Trim(FOrdemServico.SglProdutor) + ' - ' + RedimensionaString(FOrdemServico.NomProdutor, 40), ' ', 45);
        sFichaOS := sFichaOS + 'CNPJ:          ' + FOrdemServico.NumCNPJCPFProdutorFormatado;
     end;

     FichaOS.FonteNegrito;
     FichaOS.ImprimirTexto(01, sFichaOS);


     sFichaOS := 'Prop. rural:    ' + PadR(FOrdemServico.NomPropriedadeRural, ' ', 45);
     if Length(Trim(FOrdemServico.NumImovelReceitaFederal)) = 8 then
       sFichaOS := sFichaOS + 'NIRF:          ' + FOrdemServico.NumImovelReceitaFederal
     else if Length(Trim(FOrdemServico.NumImovelReceitaFederal)) = 13 then
       sFichaOS := sFichaOS + 'INCRA:         ' + FOrdemServico.NumImovelReceitaFederal
     else
       sFichaOS := sFichaOS;
     FichaOS.ImprimirTexto(01, sFichaOS);
     FichaOS.FonteNormal;
     sFichaOS := 'Técnico:        ' + PadR(RedimensionaString(FOrdemServico.NomTecnico, 39), ' ', 45);
     if (Length(FOrdemServico.NumCNPJCPFTecnico) = 14) then
        sFichaOS := sFichaOS + 'CNPJ:          '     + FOrdemServico.NumCNPJCPFTecnicoFormatado
     else if (Length(FOrdemServico.NumCNPJCPFTecnico) = 11) then
        sFichaOS := sFichaOS + 'CPF:           '     + FOrdemServico.NumCNPJCPFTecnicoFormatado;
     FichaOS.ImprimirTexto(01, sFichaOS);
     sFichaOS := 'Vendedor:       ' + PadR(RedimensionaString(FOrdemServico.NomVendedor, 39), ' ', 45);
     if (Length(FOrdemServico.NumCNPJCPFVendedor) = 14) then
        sFichaOS := sFichaOS + 'CNPJ:          ' + FOrdemServico.NumCNPJCPFVendedorFormatado
     else if (Length(FOrdemServico.NumCNPJCPFVendedor) = 11) then
        sFichaOS := sFichaOS + 'CPF:           ' + FOrdemServico.NumCNPJCPFVendedorFormatado;
     FichaOS.ImprimirTexto(01, sFichaOS);

     FichaOS.NovaLinha;
     sFichaOS := 'Quant. animais: ' + IntToStr(FOrdemServico.QtdAnimais);
     If FOrdemServico.IndAnimaisRegistrados = 'S' then
       sFichaOS := sFichaOS + ' (registrados em associação de raça)';
     FichaOS.FonteNegrito;
     FichaOS.ImprimirTexto(01, sFichaOS);
     FichaOS.FonteNormal;
     if FOrdemServico.CodPaisSISBOVInicial > 0 then
     begin
       if (FOrdemServico.CodMicroRegiaoSISBOVInicial = -1) then
       begin
         sNroInicial := StrZero(FOrdemServico.CodPaisSISBOVInicial, 3) + ' ' +
                        StrZero(FOrdemServico.CodEstadoSISBOVInicial, 2) + ' ' +
                        StrZero(FOrdemServico.CodAnimalSISBOVInicial, 9) + ' ' +
                        StrZero(FOrdemServico.NumDVSISBOVInicial, 1);
         sNroFinal   := ' - ' + StrZero(FOrdemServico.CodAnimalSISBOVInicial + FOrdemServico.QtdAnimais - 1, 9) +
                        ' ' + IntToStr(BuscarDVSisBov(FOrdemServico.CodPaisSISBOVInicial, FOrdemServico.CodEstadoSISBOVInicial, FOrdemServico.CodMicroRegiaoSISBOVInicial, FOrdemServico.CodAnimalSISBOVInicial + FOrdemServico.QtdAnimais - 1));
       end
       else
         begin
           sNroInicial := StrZero(FOrdemServico.CodPaisSISBOVInicial, 3) + ' ' +
                          StrZero(FOrdemServico.CodEstadoSISBOVInicial, 2) + ' ' +
                          StrZero(FOrdemServico.CodMicroRegiaoSISBOVInicial, 2) + ' ' +
                          StrZero(FOrdemServico.CodAnimalSISBOVInicial, 7) + ' ' +
                          StrZero(FOrdemServico.NumDVSISBOVInicial, 1);
           sNroFinal   := ' - ' + StrZero(FOrdemServico.CodAnimalSISBOVInicial + FOrdemServico.QtdAnimais - 1, 7) +
                          ' ' + IntToStr(BuscarDVSisBov(FOrdemServico.CodPaisSISBOVInicial, FOrdemServico.CodEstadoSISBOVInicial, FOrdemServico.CodMicroRegiaoSISBOVInicial, FOrdemServico.CodAnimalSISBOVInicial + FOrdemServico.QtdAnimais - 1));
         end;
       sFichaOS := 'SISBOV : ' + PadR(sNroInicial + sNroFinal, ' ', 45);
     end
     else
       sFichaOS := 'SISBOV : ' + '';
     sFichaOS := PadR(sFichaOS, ' ', 61) + 'Pagamento:     ' + RedimensionaString(FOrdemServico.DesFormaPagamentoOS, 20);
     FichaOS.ImprimirTexto(01, sFichaOS);
     sFichaOS := 'Tipo ident.:    ' + Trim(FOrdemServico.SglIdentificacaoDupla) + ' - ' + FOrdemServico.DesIdentificacaoDupla;
     sFichaOS := PadR(sFichaOS, ' ', 61) + 'Solic. SISBOV: ' + IntToStr(FOrdemServico.NumSolicitacaoSISBOV);
     FichaOS.ImprimirTexto(01, sFichaOS);

     if Length(FOrdemServico.EnderecoEntregaCert.NomLogradouro) > 0 then begin
        FichaOS.NovaLinha;
        sFichaOS := 'Endereço de Entrega dos Certificados';
        FichaOS.FonteNegrito;
        FichaOS.ImprimirTexto(01, sFichaOS);
        FichaOS.FonteNormal;
        sFichaOS := 'Contato:        ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaCert.NomPessoaContato, 44), ' ', 45);
        sFichaOS := sFichaOS + 'Telefone:      ' + FOrdemServico.EnderecoEntregaCert.NumTelefone;
        FichaOS.ImprimirTexto(01, sFichaOS);
        sFichaOS := 'E-mail:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaCert.TxtEmail, 44), ' ', 45);
        sFichaOS := sFichaOS + 'FAX:           ' + FOrdemServico.EnderecoEntregaCert.NumFax;
        FichaOS.ImprimirTexto(01, sFichaOS);
        sFichaOS := 'Logradouro:     ' + RedimensionaString(FOrdemServico.EnderecoEntregaCert.NomLogradouro, 79);
        FichaOS.ImprimirTexto(01, sFichaOS);
        sFichaOS := 'Bairro:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaCert.NomBairro, 44), ' ', 45);
        sFichaOS := sFichaOS + 'CEP:           ' + FOrdemServico.EnderecoEntregaCert.NumCEP;
        FichaOS.ImprimirTexto(01, sFichaOS);
        sFichaOS := 'Município:      ' + FOrdemServico.EnderecoEntregaCert.NomMunicipio + ' - ' + FOrdemServico.EnderecoEntregaCert.SglEstado;
        FichaOS.ImprimirTexto(01, sFichaOS);
     end;

     FichaOS.FinalizarQuadro;
     if (UpperCase(FOrdemServico.IndEnviaPedidoIdentificador) = 'S') then begin
        FichaOS.NovaLinha;
        FichaOS.InicializarQuadro('S');
        sFichaOS := 'PEDIDO DE IDENTIFICADORES';
        FichaOS.FonteNegrito;
        FichaOS.ImprimirTexto(01, sFichaOS);
        FichaOS.FonteNormal;
        sFichaOS := 'Fabricante:     ' + PadR(RedimensionaString(FOrdemServico.NomReduzidoFabricante, 43), ' ', 45);
        sFichaOS := sFichaOS +   'Nº remessa:    ' + IntToStr(FOrdemServico.NumRemessa);
        FichaOS.ImprimirTexto(01, sFichaOS);
        sFichaOS := 'Nº pedido:      ' + PadR(IntToStr(FOrdemServico.NumPedidoFabricante), ' ', 45);
        sFichaOS :=   sFichaOS + 'Pagamento:     ' + RedimensionaString(FOrdemServico.DesFormaPagamentoIdent, 25);
        FichaOS.ImprimirTexto(01, sFichaOS);

        if FOrdemServico.CodProdutoAcessorio1 > 0 then begin
          sFichaOS := 'Prod acessório: ' + PadR(RedimensionaString(Trim(FOrdemServico.SglProdutoAcessorio1) + ' - ' + FOrdemServico.DesProdutoAcessorio1, 44), ' ', 45);
          sFichaOS := sFichaOS + 'Quant.:        ' + IntToStr(FOrdemServico.QtdProdutoAcessorio1);
          FichaOS.ImprimirTexto(01, sFichaOS);
        end;
        if FOrdemServico.CodProdutoAcessorio2 > 0 then begin
          sFichaOS := 'Prod acessório: ' + PadR(RedimensionaString(Trim(FOrdemServico.SglProdutoAcessorio2) + ' - ' + FOrdemServico.DesProdutoAcessorio2, 44), ' ', 45);
          sFichaOS := sFichaOS + 'Quant.:        ' + IntToStr(FOrdemServico.QtdProdutoAcessorio2);
          FichaOS.ImprimirTexto(01, sFichaOS);
        end;
        if FOrdemServico.CodProdutoAcessorio3 > 0 then begin
          sFichaOS := 'Prod Acessório: ' + PadR(RedimensionaString(Trim(FOrdemServico.SglProdutoAcessorio3) + ' - ' + FOrdemServico.DesProdutoAcessorio3, 44), ' ', 45);
          sFichaOS := sFichaOS + 'Quant.:        ' + IntToStr(FOrdemServico.QtdProdutoAcessorio3);
          FichaOS.ImprimirTexto(01, sFichaOS);
        end;

        if (Length(FOrdemServico.EnderecoEntregaIdent.NomLogradouro) > 0) then begin
           FichaOS.NovaLinha;
           sFichaOS := 'Endereço de Entrega dos Identificadores';
           FichaOS.FonteNegrito;
           FichaOS.ImprimirTexto(01, sFichaOS);
           FichaOS.FonteNormal;
           sFichaOS := 'Contato:        ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaIdent.NomPessoaContato, 44), ' ', 45);
           sFichaOS := sFichaOS + 'Telefone:      ' + RedimensionaString(FOrdemServico.EnderecoEntregaIdent.NumTelefone, 17);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'E-mail:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaIdent.TxtEmail, 44), ' ', 45);
           sFichaOS := sFichaOS + 'FAX:           ' + RedimensionaString(FOrdemServico.EnderecoEntregaIdent.NumFax, 17);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Logradouro:     ' + RedimensionaString(FOrdemServico.EnderecoEntregaIdent.NomLogradouro, 79);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Bairro:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoEntregaIdent.NomBairro, 44), ' ', 45);
           sFichaOS := sFichaOS + 'CEP:           ' + FOrdemServico.EnderecoEntregaIdent.NumCEP;
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Município:      ' + FOrdemServico.EnderecoEntregaIdent.NomMunicipio + ' - ' + FOrdemServico.EnderecoEntregaIdent.SglEstado;
           FichaOS.ImprimirTexto(01, sFichaOS);
        end;

        if (Length(FOrdemServico.EnderecoCobrancaIdent.NomLogradouro) > 0) then begin
           FichaOS.NovaLinha;
           sFichaOS := 'Endereço de Cobrança dos Identificadores';
           FichaOS.FonteNegrito;
           FichaOS.ImprimirTexto(01, sFichaOS);
           FichaOS.FonteNormal;
           sFichaOS := 'Contato:        ' + PadR(RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.NomPessoaContato, 44), ' ', 45);
           sFichaOS := sFichaOS + 'Telefone:      ' + RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.NumTelefone, 17);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'E-mail:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.TxtEmail, 44), ' ', 45);
           sFichaOS := sFichaOS + 'FAX:           ' + RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.NumFax, 17);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Logradouro:     ' + RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.NomLogradouro, 79);
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Bairro:         ' + PadR(RedimensionaString(FOrdemServico.EnderecoCobrancaIdent.NomBairro, 44), ' ', 45);
           sFichaOS := sFichaOS + 'CEP:           ' + FOrdemServico.EnderecoCobrancaIdent.NumCEP;
           FichaOS.ImprimirTexto(01, sFichaOS);
           sFichaOS := 'Município:      ' + FOrdemServico.EnderecoCobrancaIdent.NomMunicipio + ' - ' + FOrdemServico.EnderecoCobrancaIdent.SglEstado;
           FichaOS.ImprimirTexto(01, sFichaOS);
        end;
        FichaOS.FinalizarQuadro;
     end;

     FichaOS.NovaLinha;
     FichaOS.InicializarQuadro('S');
     sFichaOS := 'Cadastramento:  ' + PadR(FormatDateTime('dd/mm/yyyy', FOrdemServico.DtaCadastramento), ' ', 45);
     sFichaOS := sFichaOS + 'Usuário:       ' + FOrdemServico.NomUsuariocadastramento;
     FichaOS.ImprimirTexto(01, sFichaOS);
     sFichaOS := 'Últ. alteração: ' + PadR(FormatDateTime('dd/mm/yyyy', FOrdemServico.DtaUltimaAlteracao), ' ', 45);
     sFichaOS := sFichaOS + 'Usuário:       ' + FOrdemServico.NomUsuarioUltimaAlteracao;
     FichaOS.ImprimirTexto(01, sFichaOS);
     if (Length(FOrdemServico.TxtObservacao) > 0) then begin
        sFichaOS := 'Observação:     ' + RedimensionaString(FOrdemServico.TxtObservacao, 79);
        FichaOS.ImprimirTexto(01, sFichaOS);
     end;
     FichaOS.FinalizarQuadro;
     FichaOS.NovaLinha;
     FichaOS.FonteNormal;
     if Not Query.Eof then begin
        if FichaOS.LinhasRestantes <= 6 then FichaOS.NovaPagina;
        FichaOS.InicializarQuadro('S');
        Cabecalho := PadR('Situação', ' ', 48);
        Cabecalho := Cabecalho + PadR('Mudança', ' ', 13);
        Cabecalho := Cabecalho + PadR('Usuário', ' ', 13);
        FichaOS.ImprimirTexto(01, Cabecalho);
        Cabecalho2 := PadR('Ordem Serviço', ' ', 48);
        Cabecalho2 := Cabecalho2 + PadR('Situação', ' ', 15);
        FichaOS.ImprimirTexto(01, Cabecalho2);
        FichaOS.FinalizarQuadro;
     end;
     Query.First;
     LinhaEmNegrito := FichaOS.LinhaCorrente;
     while not Query.Eof do begin
        if LinhaEmNegrito = FichaOS.LinhaCorrente then FichaOS.FonteNegrito;
        FichaOS.ImprimirTexto(01,
                                  PadR(RedimensionaString(Query.FieldByName('SglSituacaoOS').AsString + ' - ' + Query.FieldByName('DesSituacaoOS').AsString, 46), ' ', 48) +
                                  PadR(FormatDateTime('dd/mm/yyyy', Query.FieldByName('DtaMudancaSituacao').AsDateTime), ' ', 13) +
                                  PadR(RedimensionaString(Query.FieldByName('NomUsuario').AsString, 14), ' ', 15)
                             );
        FichaOS.FonteNormal;
        Query.Next;

        if (FichaOS.LinhasRestantes <= 3) and (Not Query.Eof) then begin
           FichaOS.NovaPagina;
           FichaOS.InicializarQuadro('S');
           FichaOS.ImprimirTexto(01, Cabecalho);
           FichaOS.ImprimirTexto(01, Cabecalho2);
           FichaOS.FinalizarQuadro;
        end;
     end;

     FichaOS.NovaLinha;
     if FichaOS.LinhasRestantes <= 5 then
     begin
       FichaOS.NovaPagina;
     end;

     FichaOS.InicializarQuadro('S');
     FichaOS.FonteNegrito;
     FichaOS.ImprimirTexto(01, 'Dados de envio do pedido de identificadores');
     FichaOS.FonteNormal;

     if (FOrdemServico.CodSituacaoOS = 8) or (FOrdemServico.CodSituacaoOS = 9) or
        (FOrdemServico.CodSituacaoOS = 10) or (FOrdemServico.CodSituacaoOS = 11) then
     begin
       if (FOrdemServico.DtaEnvio > 0) then
       begin
         sFichaOS := 'Data de envio:          ' + DateToStr(FOrdemServico.DtaEnvio);
         FichaOS.ImprimirTexto(01, sFichaOS);
       end;
       if (Trim(FOrdemServico.NomServicoEnvio) <> '') then
       begin
         sFichaOS := 'Nome do serviço:        ' + FOrdemServico.NomServicoEnvio;
         FichaOS.ImprimirTexto(01, sFichaOS);
       end;
       if (Trim(FOrdemServico.NumConhecimento) <> '') then
       begin
         sFichaOS := 'Número de conhecimento: ' + FOrdemServico.NumConhecimento;
         FichaOS.ImprimirTexto(01, sFichaOS);
       end;

       if (FOrdemServico.DtaEnvio = 0) and (Trim(FOrdemServico.NomServicoEnvio) = '') and
          (Trim(FOrdemServico.NumConhecimento) = '') then
       begin
         sFichaOS := 'Os dados de envio do pedido de identificadores, ao produtor, não estão disponíveis.';
         FichaOS.ImprimirTexto(01, sFichaOS);
       end;
     end
     else
     begin
       sFichaOS := 'Os dados de envio do pedido de identificadores, ao produtor, não estão disponíveis, pois o';
       FichaOS.ImprimirTexto(01, sFichaOS);
       sFichaOS := 'pedido ainda não foi enviado ao produtor.';
       FichaOS.ImprimirTexto(01, sFichaOS);       
     end;

     FichaOS.FinalizarQuadro;

     Retorno := PesquisarSituacaoCodigoSisBov(CodOrdemServico, 'S');
//     if Query.IsEmpty then Exit;
     if (Retorno < 0) and (Retorno <> -1744) and (Retorno <> -1896)then Exit;
     if Not Query.Eof then begin
        FichaOS.NovaLinha;
        if FichaOS.LinhasRestantes <= 6 then FichaOS.NovaPagina;
        FichaOS.InicializarQuadro('S');
        Cabecalho := PadR('Situação dos', ' ', 48);
        Cabecalho := Cabecalho + PadR('Mudança', ' ', 13);
        Cabecalho := Cabecalho + 'Quant.';
        FichaOS.ImprimirTexto(01, Cabecalho);
        Cabecalho2 := PadR('Códigos SISBOV da OS', ' ', 48);
        Cabecalho2 := Cabecalho2 + PadR('Situação', ' ', 13);
        FichaOS.ImprimirTexto(01, Cabecalho2);
        FichaOS.FinalizarQuadro;
     end;
     Query.First;
     while not Query.Eof do begin
        FichaOS.ImprimirTexto(01,
                                  PadR(RedimensionaString(Query.FieldByName('SglSituacaoSisBov').AsString + ' - ' + Query.FieldByName('DesSituacaoSisBov').AsString, 46), ' ', 48) +
                                  PadR(FormatDateTime('dd/mm/yyyy', Query.FieldByName('DtaMudancaSituacao').AsDateTime), ' ', 13) +
                                  PadL(Query.FieldByName('QtdCodigoSisBov').AsString, ' ', 6)
                              );
        Query.Next;

        if (FichaOS.LinhasRestantes <= 3) and (Not Query.Eof) then begin
           FichaOS.NovaPagina;
           FichaOS.InicializarQuadro('S');
           FichaOS.ImprimirTexto(01, Cabecalho);
           FichaOS.ImprimirTexto(01, Cabecalho2);
           FichaOS.FinalizarQuadro;
        end;
     end;

     Retorno := PesquisarDataLiberacaoAbate(CodOrdemServico);
//     if Query.IsEmpty then Exit;
     if (Retorno < 0) and (Retorno <> -1744) and (Retorno <> -1896)then Exit;
     if Not Query.Eof then begin
        FichaOS.NovaLinha;
        FichaOS.NovaLinha;
        if FichaOS.LinhasRestantes <= 6 then FichaOS.NovaPagina;
        FichaOS.InicializarQuadro('S');
        Cabecalho := PadR('Liberação', ' ', 48);
        Cabecalho := Cabecalho + 'Quant.';
        FichaOS.ImprimirTexto(01, Cabecalho);
        Cabecalho2 := PadR('para Abate', ' ', 48);
        Cabecalho2 := Cabecalho2 + 'Animais';
        FichaOS.ImprimirTexto(01, Cabecalho2);
        FichaOS.FinalizarQuadro;
     end;
     Query.First;
     while not Query.Eof do begin
        if Length(Trim(Query.FieldByName('DtaLiberacaoAbate').AsString)) > 0 then
          FichaOS.ImprimirTexto(01,
                                    PadR(FormatDateTime('dd/mm/yyyy', Query.FieldByName('DtaLiberacaoAbate').AsDateTime), ' ', 48) +
                                    PadL(Query.FieldByName('QtdCodigosSisBov').AsString, ' ', 7)
                                )
        else
          FichaOS.ImprimirTexto(01,
                                    PadR('(Sem data prevista)', ' ', 48) +
                                    PadL(Query.FieldByName('QtdCodigosSisBov').AsString, ' ', 7)
                                );
        Query.Next;
        if (FichaOS.LinhasRestantes <= 3) and (Not Query.Eof) then begin
           FichaOS.NovaPagina;
           FichaOS.InicializarQuadro('S');
           FichaOS.ImprimirTexto(01, Cabecalho);
           FichaOS.ImprimirTexto(01, Cabecalho2);
           FichaOS.FinalizarQuadro;
        end;
     end;

     Retorno := FichaOS.FinalizarRelatorio;
     {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
     if Retorno = 0 then begin
       Mensagens.Clear; //Limpa o objeto mensagem uma vez que todo o processamento foi realizado com sucesso!
                        //Este procedimento foi adotado pois os metodos PesquisarDataLiberacaoAbate e PesquisarSituacaoCodigoSisBov
                        // retornam valores negativas quando o result set resultante é vazio! E mesmo assim o relatorio deve ser gerado!
       Result := FichaOS.NomeArquivo;
     end
     else
       Result := '';
  Finally

  End;
end;

function TIntOrdensServico.BuscarAcessoAtributos(CodOrdemServico: Integer): Integer;
const
  NomeMetodo: String = 'BuscarAcessoAtributos';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
  IndEnviaPedidoIdent: String;
  IndAcesso: String;
  NomeAtributo: String;
  CodSituacaoOS: Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(579) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem os dados básicos da  OS e verifica se o usuário tem acesso à OS
      with QueryLocal do
      begin
        Close;
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_pessoa_produtor,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       cod_situacao_os');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado,
          FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        IndEnviaPedidoIdent := FieldByName('ind_envia_pedido_ident').AsString;
        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
      end;

      with QueryLocal do
      begin
        SQL.Clear;
        // Obtem os atributos e as respectivas restrições de acordo com a situação
        SQL.Add('select taos.nom_coluna_atributo,');
        SQL.Add('       tsaos.ind_pode_alterar,');
        SQL.Add('       tsaos.ind_mostra_mensagem,');
        SQL.Add('       tsaos.ind_exibe_atributo,');
        SQL.Add('       tsaos.ind_requerido');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_atributo_os taos');
        SQL.Add(' where tsaos.cod_atributo_os = taos.cod_atributo_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsaos.cod_situacao_os = :cod_situacao_os');
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;
        Open;

        while not Eof do
        begin
          IndAcesso := FieldByName('ind_pode_alterar').AsString +
            FieldByName('ind_mostra_mensagem').AsString +
            FieldByName('ind_requerido').AsString +
            FieldByName('ind_exibe_atributo').AsString;
          NomeAtributo := LowerCase(FieldByName('nom_coluna_atributo').AsString);

          if NomeAtributo = 'qtd_animais' then
          begin
            IndAcessoQtdAnimais := IndAcesso;
          end
          else if NomeAtributo = 'cod_pessoa_tecnico' then
          begin
            IndAcessoPessoaTecnico := IndAcesso;
          end
          else if NomeAtributo = 'cod_pessoa_vendedor' then
          begin
            IndAcessoPessoaVendedor := IndAcesso;
          end
          else if NomeAtributo = 'cod_forma_pagamento_os' then
          begin
            IndAcessoFormaPagamentoOS := IndAcesso;
          end
          else if NomeAtributo = 'cod_identificacao_dupla' then
          begin
            IndAcessoIdentificacaoDupla := IndAcesso;
          end
          else if NomeAtributo = 'cod_fabricante_identificador' then
          begin
            IndAcessoFabricanteIdentificador := IndAcesso;
          end
          else if NomeAtributo = 'cod_forma_pagamento_ident' then
          begin
            IndAcessoFormaPagamentoIdent := IndAcesso;
          end
          else if (NomeAtributo = 'cod_produto_acessorio_1') then
          begin
            IndAcessoProdutoAcessorio1 := IndAcesso;
          end
          else if NomeAtributo = 'qtd_produto_acessorio_1' then
          begin
            IndAcessoQtdProdutoAcessorio1 := IndAcesso;
          end
          else if NomeAtributo = 'cod_produto_acessorio_2' then
          begin
            IndAcessoProdutoAcessorio2 := IndAcesso;
          end
          else if NomeAtributo = 'qtd_produto_acessorio_2' then
          begin
            IndAcessoQtdProdutoAcessorio2 := IndAcesso;
          end
          else if NomeAtributo = 'cod_produto_acessorio_3' then
          begin
            IndAcessoProdutoAcessorio3 := IndAcesso;
          end
          else if NomeAtributo = 'qtd_produto_acessorio_3' then
          begin
            IndAcessoQtdProdutoAcessorio3 := IndAcesso;
          end
          else if NomeAtributo = 'num_ordem_servico' then
          begin
            IndAcessoNumOrdemServico := IndAcesso;
          end
          else if NomeAtributo = 'ind_envia_pedido_ident' then
          begin
            IndAcessoEnviaPedidoIdentificador := IndAcesso;
          end
          else if NomeAtributo = 'cod_endereco_entrega_cert' then
          begin
            IndAcessoEnderecoEntregaCert := IndAcesso;
          end
          else if NomeAtributo = 'cod_endereco_entrega_ident' then
          begin
            IndAcessoEnderecoEntregaIdent := IndAcesso;
          end
          else if NomeAtributo = 'cod_endereco_cobranca_ident' then
          begin
            IndAcessoEnderecoCobrancaIdent := IndAcesso;
          end
          else if (NomeAtributo = 'cod_pais_sisbov_inicio')
            or (NomeAtributo = 'cod_estado_sisbov_inicio')
            or (NomeAtributo = 'cod_micro_regiao_sisbov_inicio')
            or (NomeAtributo = 'cod_animal_sisbov_inicio')
            or (NomeAtributo = 'num_dv_sisbov_inicio') then
          begin
            IndAcessoCodigoSISBOVInicio := IndAcesso;
          end
          else if NomeAtributo = 'txt_observacao_pedido' then
          begin
            IndAcessoObservacaoPedido := IndAcesso;
          end
          else if NomeAtributo = 'ind_animais_registrados' then
          begin
            IndAcessoAnimaisRegistrados := IndAcesso;
          end;

          Next;
        end;

      end;
    finally
      QueryLocal.Free;
    end;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1886, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1886;
      Exit;
    end;
  end;
end;

{ Envia um e-mail com os dados da OS.

Parametros;
  EConexao: TConexao;
  EMensagens: TIntMensagens;
  CodSituacaoOS,
  CodOrdemServico,
  QtdCertificadosEnviados,
  QtdAnimaisAutenticados: Integer;
  DtaLiberacaoAbateInicial,
  DtaLiberacaoAbateFinal: TDateTime;
  CodSISBOVInicioFormatado,
  CodSISBOVFimFormatado,
  TxtObservacaoSituacaoOS,
  IndDtaLiberacaoEstimada: String;
  DtaEnvioCert: TDateTime;
  NomServicoEnvioCert,
  NumConhecimentoCert: String

Retorno:
  Nenhum.}
class procedure TIntOrdensServico.EnviarEMail(EConexao: TConexao;
  EMensagens: TIntMensagens; CodSituacaoOS, CodOrdemServico,
  QtdCertificadosEnviados, QtdAnimaisAutenticados: Integer;
  DtaLiberacaoAbateInicial, DtaLiberacaoAbateFinal: TDateTime;
  CodSISBOVInicioFormatado, CodSISBOVFimFormatado,
  TxtObservacaoSituacaoOS, IndDtaLiberacaoEstimada: String;
  DtaEnvioCert: TDateTime; NomServicoEnvioCert, NumConhecimentoCert: String);
const
  NomeMetodo: String = 'EnviarEMail';
var
  QueryLocal: THerdomQuery;
  CodTipoDestTecnico,
  CodTipoDestProdutor,
  CodModeloEMail,
  CodPessoaProdutor,
  CodPessoaTecnico: Integer;
  TextoEMail,
  AssuntoEMail,
  EMailProdutor,
  EMailTecnico,
  TxtDtaLiberacaoEstimada: String;
  Email: TIntEmailsEnvio;
  CodEMail,
  CodTipoEmail,
  I: Integer;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select IsNull(cod_tipo_destinatario_produtor, -1) as cod_tipo_destinatario_produtor,');
        SQL.Add('       IsNull(cod_tipo_destinatario_tecnico, -1) as cod_tipo_destinatario_tecnico,');
        SQL.Add('       IsNull(cod_modelo_email, -1) as cod_modelo_email');
        SQL.Add('  from tab_situacao_os');
        SQL.Add(' where cod_situacao_os = :cod_situacao_os');
{$ENDIF}
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        Open;

        CodTipoDestTecnico :=
          FieldByName('cod_tipo_destinatario_tecnico').AsInteger;
        CodTipoDestProdutor :=
          FieldByName('cod_tipo_destinatario_produtor').AsInteger;
        CodModeloEMail := FieldByName('cod_modelo_email').AsInteger;
      end;

      // Verifica se o e-mail deve ser enviado.
      if CodModeloEMail = -1 then
      begin
        Exit;
      end;

      // Obtem o técnico e o produtor
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select IsNull(cod_pessoa_tecnico, -1) as cod_pessoa_tecnico,');
        SQL.Add('       cod_pessoa_produtor');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        CodPessoaProdutor :=
          FieldByName('cod_pessoa_produtor').AsInteger;
        CodPessoaTecnico :=
          FieldByName('cod_pessoa_tecnico').AsInteger;
      end;

      if (CodModeloEMail <> -1) then
      begin
        // Obtem o corpo do e-mail
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select txt_corpo_email');
          SQL.Add('  from tab_modelo_email');
          SQL.Add(' where cod_modelo_email = :cod_modelo_email');
{$ENDIF}
          ParamByName('cod_modelo_email').AsInteger := CodModeloEMail;
          Open;

          TextoEMail := FieldByName('txt_corpo_email').AsString;
        end;

        // Obtem titulo do e-mail
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select txt_assunto,');
          SQL.Add('       cod_tipo_email');
          SQL.Add('  from tab_modelo_email');
          SQL.Add(' where cod_modelo_email = :cod_modelo_email');
{$ENDIF}
          ParamByName('cod_modelo_email').AsInteger := CodModeloEMail;
          Open;

          AssuntoEMail := FieldByName('txt_assunto').AsString;
          CodTipoEmail := FieldByName('cod_tipo_email').AsInteger;
        end;

        // Obtem o e-mail do produtor e do tecnico
        EMailTecnico := '';
        EMailProdutor := '';
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select dbo.fnt_buscar_contato_principal(:cod_pessoa, ''E'')');
{$ENDIF}

          if CodTipoDestTecnico > -1 then
          begin
            Close;
            ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
            Open;

            if not IsEmpty then
            begin
              EMailProdutor := Fields[0].AsString;
            end;
          end;

          if CodTipoDestProdutor > -1 then
          begin
            Close;
            ParamByName('cod_pessoa').AsInteger := CodPessoaTecnico;
            Open;

            if not IsEmpty then
            begin
              EMailTecnico := Fields[0].AsString;
            end;
          end;
        end;

        // Obtem o nome da certificadora
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select tp.nom_pessoa as NomCertificadora,');
          SQL.Add('       tp.nom_reduzido_pessoa as NomReduzidoCertificadora');
          SQL.Add('  from tab_pessoa tp,');
          SQL.Add('       tab_parametro_sistema tps');
          SQL.Add(' where tp.cod_pessoa = CAST(tps.val_parametro_sistema AS int)');
          SQL.Add('   and tps.cod_parametro_sistema = 4');
{$ENDIF}
          Open;
          for I := 0 to Fields.Count - 1 do
          begin
            AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<' + Fields[I].FieldName + '>',
              Fields[I].AsString);
            TextoEMail := AnsiReplaceStr(TextoEMail, '<' + Fields[I].FieldName + '>',
              Fields[I].AsString);
          end;
        end;

        // Obtem o e-mail da certificadora
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select val_parametro_sistema as TxtEmailContatoCertificadora');
          SQL.Add('  from tab_parametro_sistema');
          SQL.Add(' where cod_parametro_sistema = 86');
{$ENDIF}
          Open;
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<' + Fields[0].FieldName + '>',
            Fields[0].AsString);
          TextoEMail := AnsiReplaceStr(TextoEMail, '<' + Fields[0].FieldName + '>',
            Fields[0].AsString);
        end;

        // Obtem o e-mail da certificadora
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select txt_observacao as TxtObservacaoSituacaoOS');
          SQL.Add('  from tab_historico_situacao_os');
          SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
          SQL.Add(' order by dta_mudanca_situacao desc');
{$ENDIF}
          ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Open;
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<' + Fields[0].FieldName + '>',
            Fields[0].AsString);
          TextoEMail := AnsiReplaceStr(TextoEMail, '<' + Fields[0].FieldName + '>',
            Fields[0].AsString);
        end;

        // Obtem os dados da OS
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('SELECT IsNull(tos.num_ordem_servico, -1) AS NumOrdemServico,');
          SQL.Add('       IsNull(tos.num_pedido_fabricante, -1) AS NumPedidoFabricante,');
          SQL.Add('       IsNull(tos.qtd_animais, -1) AS QtdAnimais,');
          SQL.Add('       case tos.ind_envia_pedido_ident');
          SQL.Add('         when ''S'' then ''SIM''');
          SQL.Add('         when ''N'' then ''NÃO''');
          SQL.Add('         end AS TxtEnviaPedidoIdentificador,');
          SQL.Add('       tid.des_identificacao_dupla AS DesIdentificacaoDupla,');
          SQL.Add('       tsos.des_situacao_os AS DesSituacaoOS,');
          SQL.Add('       tfi.nom_fabricante_identificador AS NomFabricanteIdentificador,');
          SQL.Add('       tfi.nom_reduzido_fabricante AS NomReduzidoFabricante,');
          SQL.Add('       tpp.nom_pessoa AS NomProdutor,');
          SQL.Add('       tpp.num_cnpj_cpf AS NumCNPJCPFProdutor,');
          SQL.Add('       tpr.nom_propriedade_rural AS NomPropriedadeRural,');
          SQL.Add('       tpr.num_imovel_receita_federal AS NumImovelReceitaFederal,');
          SQL.Add('       tpt.nom_pessoa AS NomTecnico,');
          SQL.Add('       tpt.num_cnpj_cpf AS NumCNPJCPFTecnico,');
          SQL.Add('       CONVERT(CHAR(10), tos.dta_envio, 103) + '' '' + CONVERT(CHAR(8), tos.dta_envio, 108) AS DtaEnvio,');
          SQL.Add('       tos.nom_servico_envio AS NomServicoEnvio,');
          SQL.Add('       tos.num_conhecimento AS NumConhecimento,');
          SQL.Add('       case tos.cod_animal_sisbov_inicio ');
          SQL.Add('         when null then '''' ');
          SQL.Add('         else right(''000'' + cast(tos.cod_pais_sisbov_inicio as varchar(3)),3) + '' '' + ');
          SQL.Add('              right(''00'' + cast(tos.cod_estado_sisbov_inicio as varchar(2)),2) + '' '' + ');
          SQL.Add('              case tos.cod_micro_regiao_sisbov_inicio when -1 then '''' ');
          SQL.Add('                else right(''00'' + cast(tos.cod_micro_regiao_sisbov_inicio as varchar(2)),2) end + '' '' + ');
          SQL.Add('              right(''000000000'' + cast(tos.cod_animal_sisbov_inicio as varchar(9)),9) + '' '' + ');
          SQL.Add('              right(''0'' + cast(tos.num_dv_sisbov_inicio as varchar(1)),1) end as CodSISBOVInicioFormatado ');
          SQL.Add('  FROM tab_ordem_servico tos');
          SQL.Add('         LEFT JOIN tab_identificacao_dupla tid -- Identificação dupla da OS');
          SQL.Add('           ON tos.cod_identificacao_dupla = tid.cod_identificacao_dupla');
          SQL.Add('         LEFT JOIN tab_fabricante_identificador tfi -- Fabricante de identificador da OS');
          SQL.Add('           ON tos.cod_fabricante_identificador = tfi.cod_fabricante_identificador');
          SQL.Add('         LEFT JOIN tab_pessoa tpt');
          SQL.Add('           ON tos.cod_pessoa_tecnico = tpt.cod_pessoa, -- Técnico da OS');
          SQL.Add('       tab_situacao_os tsos, -- Situação da OS');
          SQL.Add('       tab_pessoa tpp, -- pessoa do produtor');
          SQL.Add('       tab_propriedade_rural tpr');
          SQL.Add(' WHERE tsos.cod_situacao_os = tos.cod_situacao_os');
          SQL.Add('   AND tpp.cod_pessoa = tos.cod_pessoa_produtor');
          SQL.Add('   AND tpr.cod_propriedade_rural = tos.cod_propriedade_rural');
          SQL.Add('   AND tos.cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
          ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Open;

          for I := 0 to Fields.Count - 1 do
          begin
            if (Fields[I].FieldName = 'NumCNPJCPFTecnico')
              or (Fields[I].FieldName = 'NumCNPJCPFProdutor') then
            begin
              AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<' + Fields[I].FieldName +
                'Formatado>', FormataCnpjCpf(Fields[I].AsString));
              TextoEMail := AnsiReplaceStr(TextoEMail, '<' + Fields[I].FieldName +
                'Formatado>', FormataCnpjCpf(Fields[I].AsString));
            end
            else
            begin
              AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<' + Fields[I].FieldName + '>',
                Fields[I].AsString);
              TextoEMail := AnsiReplaceStr(TextoEMail, '<' + Fields[I].FieldName + '>',
                Fields[I].AsString);
            end;
          end;
        end;

        if CodSISBOVInicioFormatado <> '' then
        begin
          // CodSISBOVInicioFormatado
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<CodSISBOVInicioFormatado>',
            CodSISBOVInicioFormatado);
          TextoEMail := AnsiReplaceStr(TextoEMail, '<CodSISBOVInicioFormatado>',
            CodSISBOVInicioFormatado);
        end;

        if CodSISBOVFimFormatado = '' then
        begin
          if Length(Trim(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString)) = 18 then
          begin
            CodSISBOVFimFormatado := Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03) + ' ' +
                                     Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02) + ' ' +
                                     FormatFloat('000000000', (StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 08, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1))) + ' ' +
                                     IntToStr(BuscarDVSisBov(StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03)),
                                                             StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02)),
                                                             -1,
                                                             StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 08, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1)));
          end else begin
            if Length(Trim(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString)) = 21 then
            begin
              CodSISBOVFimFormatado := Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03) + ' ' +
                                       Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02) + ' ' +
                                       Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 08, 02) + ' ' +
                                       FormatFloat('000000000', (StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 09, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1))) + ' ' +
                                       IntToStr(BuscarDVSisBov(StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03)),
                                                               StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02)),
                                                               StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 08, 02)),
                                                               StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 11, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1)));
            end else begin
              if Length(Trim(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString)) = 19 then
              begin
                CodSISBOVFimFormatado := Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03) + ' ' +
                                       Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02) + ' ' +
                                       FormatFloat('000000000', (StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 09, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1))) + ' ' +
                                       IntToStr(BuscarDVSisBov(StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 01, 03)),
                                                               StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 05, 02)),
                                                               -1,
                                                               StrToInt(Copy(QueryLocal.FieldByName('CodSISBOVInicioFormatado').AsString, 09, 09)) + (QueryLocal.FieldByName('QtdAnimais').AsInteger-1)));
              end;
            end;
          end;
        end;

        // CodSISBOVFimFormatado
        AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<CodSISBOVFimFormatado>',
          CodSISBOVFimFormatado);
        TextoEMail := AnsiReplaceStr(TextoEMail, '<CodSISBOVFimFormatado>',
          CodSISBOVFimFormatado);

        // DtaLiberacaoAbate
        if (DtaLiberacaoAbateInicial <> 0) and (DtaLiberacaoAbateFinal <> 0) then
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<DtaLiberacaoAbate>',
            'entre ' + FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateInicial) +
            ' e ' + FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateFinal));
          TextoEMail := AnsiReplaceStr(TextoEMail, '<DtaLiberacaoAbate>',
            'entre ' + FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateInicial) +
            ' e ' + FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateFinal));
        end
        else
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<DtaLiberacaoAbate>', FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateInicial));
          TextoEMail := AnsiReplaceStr(TextoEMail, '<DtaLiberacaoAbate>', FormatDateTime('dd/mm/yyyy', DtaLiberacaoAbateInicial));
        end;

        // QtdAnimaisAutenticados
        AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<QtdAnimaisAutenticados>', IntToStr(QtdAnimaisAutenticados));
        TextoEMail := AnsiReplaceStr(TextoEMail, '<QtdAnimaisAutenticados>', IntToStr(QtdAnimaisAutenticados));

        // QtdCertificadosEnviados
        AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<QtdCertificadosEnviados>', IntToStr(QtdCertificadosEnviados));
        TextoEMail := AnsiReplaceStr(TextoEMail, '<QtdCertificadosEnviados>', IntToStr(QtdCertificadosEnviados));

        // TxtDtaLiberacaoEstimada
        if IndDtaLiberacaoEstimada = 'S' then
        begin
          TxtDtaLiberacaoEstimada := 'estimada';
        end
        else
        begin
          TxtDtaLiberacaoEstimada := 'confirmada';
        end;

        AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<TxtDtaLiberacaoEstimada>',
          TxtDtaLiberacaoEstimada);
        TextoEMail := AnsiReplaceStr(TextoEMail, '<TxtDtaLiberacaoEstimada>',
          TxtDtaLiberacaoEstimada);

        if Length(Trim(NomServicoEnvioCert)) > 0 then
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<NomServicoEnvioCert>', NomServicoEnvioCert);
          TextoEMail := AnsiReplaceStr(TextoEMail, '<NomServicoEnvioCert>', NomServicoEnvioCert);
        end
        else
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<NomServicoEnvioCert>', '(Não disponível)');
          TextoEMail := AnsiReplaceStr(TextoEMail, '<NomServicoEnvioCert>', '(Não disponível)');
        end;

        if Length(Trim(NumConhecimentoCert)) > 0 then
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<NumConhecimentoCert>', NumConhecimentoCert);
          TextoEMail := AnsiReplaceStr(TextoEMail, '<NumConhecimentoCert>', NumConhecimentoCert);
        end
        else
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<NumConhecimentoCert>', '(Não disponível)');
          TextoEMail := AnsiReplaceStr(TextoEMail, '<NumConhecimentoCert>', '(Não disponível)');
        end;

        if DtaEnvioCert > 0 then
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<DtaEnvioCertificado>', FormatDateTime('dd/mm/yyyy', DtaEnvioCert));
          TextoEMail := AnsiReplaceStr(TextoEMail, '<DtaEnvioCertificado>', FormatDateTime('dd/mm/yyyy', DtaEnvioCert));
        end
        else
        begin
          AssuntoEMail := AnsiReplaceStr(AssuntoEMail, '<DtaEnvioCertificado>', '(Não disponível)');
          TextoEMail := AnsiReplaceStr(TextoEMail, '<DtaEnvioCertificado>', '(Não disponível)');
        end;

        // Envia o e-mail
        Email := TIntEmailsEnvio.Create;
        try
          Email.Inicializar(EConexao, EMensagens);
          CodEMail := Email.Inserir(CodTipoEmail, AssuntoEMail, TextoEMail);
          if CodEMail < 0 then
          begin
            raise EHerdomException.Create(CodEMail, Self.ClassName, NomeMetodo, [], True);
          end;

          if EMailTecnico <> '' then
          begin
            Email.AdicionarDestinatario(CodEMail, EMailTecnico,
              CodTipoDestTecnico, CodPessoaTecnico);
          end;

          if EMailProdutor <> '' then
          begin
            Email.AdicionarDestinatario(CodEMail, EMailProdutor,
              CodTipoDestProdutor, CodPessoaProdutor);
          end;

          Email.AlterarSituacaoParaPendente(CodEMail, 'S');
        finally
          EMail.Free;
        end;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    raise;
  end;
end;

class procedure TIntOrdensServico.MudarSituacaoParaIdent(EConexao: TConexao;
  EMensagens: TIntMensagens; CodPaisSisbov, CodEstadoSisbov,
  CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov: Integer);
var
  QueryLocal: THerdomQuery;
  Retorno,
  CodSituacaoOS,
  CodOrdemServico: Integer;
  CodSisbovFormatado: String;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Obtem o dados da OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT tos.cod_ordem_servico,');
        SQL.Add('       tos.cod_situacao_os');
        SQL.Add('  FROM tab_ordem_servico tos,');
        SQL.Add('       tab_codigo_sisbov tcs');
        SQL.Add(' WHERE tcs.cod_ordem_servico = tos.cod_ordem_servico');
        SQL.Add('   AND tcs.cod_pais_sisbov = :cod_pais_sisbov');
        SQL.Add('   AND tcs.cod_estado_sisbov = :cod_estado_sisbov');
        SQL.Add('   AND tcs.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
        SQL.Add('   AND tcs.cod_animal_sisbov = :cod_animal_sisbov');
        SQL.Add('   AND tcs.num_dv_sisbov = :num_dv_sisbov');
        SQL.Add('   AND tos.cod_situacao_os <> :cod_situacao_os');
{$ENDIF}
        ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
        ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
        ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
        ParamByName('num_dv_sisbov').AsInteger := NumDVSisbov;
        ParamByName('cod_situacao_os').AsInteger := cCodSituacaoOSCancelada;
        Open;

        // Se este código SISBOV não estiver associado à nenhuma OS
        // finaliza a função
        if IsEmpty then
        begin
          Exit;
        end;

        CodOrdemServico := FieldByName('cod_ordem_servico').AsInteger;
        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
      end;

      if not(CodSituacaoOS in [cCodSituacaoOSIdent, cCodSituacaoOSAut, cCodSituacaoOSCert]) then
      begin
        Retorno := MudarSituacaoInt(EConexao, EMensagens, CodOrdemServico,
          cCodSituacaoOSIdent, 'Mudança automática do sistema', True, True,
          False);
        // 1823 é o código de erro quando a situação destino é inválida.
        if (Retorno < 0) and (Retorno <> -1823) then
        begin
          raise EHerdomException.Create(Retorno, '', '', [], true);
        end;
      end;

      CodSisbovFormatado := PadL(IntToStr(CodPaisSisbov), '0', 3) + ' ' +
        PadL(IntToStr(CodEstadoSisbov), '0', 2) + ' ';
      if CodMicroRegiaoSisbov > -1 then
      begin
        CodSisbovFormatado := PadL(IntToStr(CodMicroRegiaoSisbov), '0', 2) + ' ';
      end;
      CodSisbovFormatado := PadL(IntToStr(CodAnimalSisbov), '0', 9) + ' ' +
        IntToStr(NumDVSisbov);

      EnviarEMail(EConexao, EMensagens, cCodSituacaoOSIdent, CodOrdemServico,
        0, 0, 0, 0, CodSisbovFormatado, CodSisbovFormatado, '', '', 0, '', '');
    finally
      QueryLocal.Free;
    end;
  except
    raise;
  end;
end;

class procedure TIntOrdensServico.MudarSituacaoParaAut(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, CodPaisSisbov, CodEstadoSisbov,
  CodMicroRegiaoSisbov, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim, QtdAnimaisAutenticados: Integer;
  DtaLiberacaoAbateInicial, DtaLiberacaoAbateFinal: TDateTime;
  IndDtaAbateEstimada: String);
var
  QueryLocal: THerdomQuery;
  Retorno,
  CodSituacaoOS: Integer;
  CodSisbovInicioFormatado,
  CodSisbovFimFormatado: String;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Obtem o dados da OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT cod_situacao_os');
        SQL.Add('  FROM tab_ordem_servico');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        // Se este código SISBOV não estiver associado à nenhuma OS
        // finaliza a função
        if IsEmpty then
        begin
          Exit;
        end;

        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
      end;

      if not(CodSituacaoOS in [cCodSituacaoOSAut, cCodSituacaoOSCert]) then
      begin
        Retorno := MudarSituacaoInt(EConexao, EMensagens, CodOrdemServico,
          cCodSituacaoOSAut, 'Mudança automática do sistema', True, True,
          False);
        // 1823 é o código de erro quando a situação destino é inválida.
        if (Retorno < 0) and (Retorno <> -1823) then
        begin
          raise EHerdomException.Create(Retorno, '', '', [], true);
        end;
      end;

      // Formata o código SISBOV Inicial e Final
      CodSisbovInicioFormatado := PadR(IntToStr(CodPaisSisbov), '0', 3) + ' ' +
        PadL(IntToStr(CodEstadoSisbov), '0', 2) + ' ';
      if CodMicroRegiaoSisbov > -1 then
      begin
        CodSisbovInicioFormatado := CodSisbovInicioFormatado + ' ' + PadL(IntToStr(CodMicroRegiaoSisbov), '0', 2);
      end;
      CodSisbovFimFormatado := CodSisbovInicioFormatado;

      CodSisbovInicioFormatado := CodSisbovInicioFormatado + PadL(IntToStr(CodAnimalSISBOVInicio), '0', 9) + ' ' + IntToStr(NumDVSISBOVInicio);

      CodSisbovFimFormatado := CodSisbovFimFormatado + PadL(IntToStr(CodAnimalSISBOVFim), '0', 9) + ' ' + IntToStr(NumDVSISBOVFim);

      EnviarEMail(EConexao, EMensagens, cCodSituacaoOSAut, CodOrdemServico,
        0, QtdAnimaisAutenticados, DtaLiberacaoAbateInicial, DtaLiberacaoAbateFinal,
        CodSisbovInicioFormatado, CodSisbovFimFormatado, '',
        IndDtaAbateEstimada, 0, '', '');
    finally
      QueryLocal.Free;
    end;
  except
    raise;
  end;
end;

class procedure TIntOrdensServico.MudarSituacaoParaCert(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico, CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSISBOVInicio,
  NumDVSISBOVInicio, CodAnimalSISBOVFim, NumDVSISBOVFim,
  QtdAnimaisCertificados: Integer; DtaEnvioCert: TDateTime; NomServicoEnvio,
  NumConhecimento: String);
var
  QueryLocal: THerdomQuery;
  Retorno,
  CodSituacaoOS: Integer;
  CodSisbovInicioFormatado,
  CodSisbovFimFormatado: String;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Obtem o dados da OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT cod_situacao_os');
        SQL.Add('  FROM tab_ordem_servico');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        // Se este código SISBOV não estiver associado à nenhuma OS
        // finaliza a função
        if IsEmpty then
        begin
          Exit;
        end;

        CodSituacaoOS := FieldByName('cod_situacao_os').AsInteger;
      end;

      if CodSituacaoOS <> cCodSituacaoOSCert then
      begin
        Retorno := MudarSituacaoInt(EConexao, EMensagens, CodOrdemServico,
          cCodSituacaoOSCert, 'Mudança automática do sistema', True, True,
          False);
        // 1823 é o código de erro quando a situação destino é inválida.
        if (Retorno < 0) and (Retorno <> -1823) then
        begin
          raise EHerdomException.Create(Retorno, '', '', [], true);
        end;
      end;

      // Formata o código SISBOV Inicial e Final
      CodSisbovInicioFormatado := PadL(IntToStr(CodPaisSisbov), '0', 3) + ' ' +
        PadR(IntToStr(CodEstadoSisbov), '0', 2) + ' ';
      if CodMicroRegiaoSisbov > -1 then
      begin
        CodSisbovInicioFormatado := PadL(IntToStr(CodMicroRegiaoSisbov), '0', 2) + ' ';
      end;
      CodSisbovFimFormatado := CodSisbovInicioFormatado;

      CodSisbovInicioFormatado := PadL(IntToStr(CodAnimalSISBOVInicio), '0', 9) + ' ' +
        IntToStr(NumDVSISBOVInicio);

      CodSisbovFimFormatado := PadR(IntToStr(CodAnimalSISBOVInicio + QtdAnimaisCertificados), '0', 9) + ' ' +
        IntToStr(NumDVSISBOVInicio);


      EnviarEMail(EConexao, EMensagens, cCodSituacaoOSCert, CodOrdemServico,
        QtdAnimaisCertificados, 0, 0, 0, CodSisbovInicioFormatado,
        CodSisbovFimFormatado, '', '', DtaEnvioCert, NomServicoEnvio,
        NumConhecimento);
    finally
      QueryLocal.Free;
    end;
  except
    raise;
  end;
end;

{ Verifica se a identificação dupla escolhida para a OS está de acordo com o
  código SISBOV da OS.

Parametros:
  EConexao: Conexão com o banco de dados
  EMensagens: Gerenciador de mensagens
  CodIdentificacaoDupla: Código da identificação dupla da OS
  CodPaisSISBOV: Código SISBOV do país
  CodEstadoSISBOV: Código SISBOV do estado
  CodMicroRegiaoSISBOV: Código SISBOV da micro região
  CodAnimalSISBOV: Código SISBOV do animal

Retorno:
  Sem retorno.

Exceções:
  EHerdomException: Caso a identificação dupla não seja valida para os
                    códigos SISBOV informados.
  Exception: Caso ocorra algum erro geral ou com o banco de dados.}
class procedure TIntOrdensServico.ValidarIdentificacaoDupla(
  EConexao: TConexao; EMensagens: TIntMensagens; CodIdentificacaoDupla,
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV: Integer);
const
  NomeMetodo: String = 'ValidarIdentificacaoDupla';
var
  QueryLocal: THerdomQuery;
  DtaValidadeSolicitacao,
  DtaSolicitacaoCodigo: TDateTime;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      if (CodIdentificacaoDupla > -1) and (CodAnimalSISBOV > -1) then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select dta_validade_solicitacao');
          SQL.Add('  from tab_identificacao_dupla');
          SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla');
          SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          ParamByName('cod_identificacao_dupla').AsInteger := CodIdentificacaoDupla;
          Open;

          DtaValidadeSolicitacao := FieldByName('dta_validade_solicitacao').AsDateTime;
          if FieldByName('dta_validade_solicitacao').IsNull then
          begin
            Exit;
          end;
       end;

        with QueryLocal do
        begin
          SQL.Clear;
{$IFDEF MSSQL}
          SQL.Add('select dta_solicitacao_sisbov');
          SQL.Add('  from tab_codigo_sisbov');
          SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov');
          SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov');
          SQL.Add('   and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
          SQL.Add('   and cod_animal_sisbov = :cod_animal_sisbov');
{$ENDIF}
          ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
          ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
          ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
          ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
          Open;

          DtaSolicitacaoCodigo := FieldByName('dta_solicitacao_sisbov').AsDateTime;

          if (DtaSolicitacaoCodigo = 0)
            or (DtaSolicitacaoCodigo > DtaValidadeSolicitacao) then
          begin
            raise EHerdomException.Create(1950, Self.ClassName, NomeMetodo,
              [FormatDateTime('dd/mm/yyyy',  DtaValidadeSolicitacao)], false);
          end;
        end;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    // Lança a exeção para o método que originou a chamada
    raise;
  end;
end;

class procedure TIntOrdensServico.MudarSituacaoParaProd(EConexao: TConexao;
  EMensagens: TIntMensagens; CodOrdemServico: Integer; TxtObservacao: String;
  DtaEnvio: TDateTime; NomServicoEnvio, NumConhecimento: String);
const
  NomeMetodo: String = 'MudarSituacaoParaProd';
var
  Retorno: Integer;
  QueryLocal: THerdomQuery;
begin
  // Se o nome do serviço for maior que 30 caracteres então truncar a string
  if Length(NomServicoEnvio) > 30 then
  begin
    NomServicoEnvio := Copy(NomServicoEnvio, 1, 27) + '...';
  end;

  // Se o número conhecimento for maior que 30 caracteres então truncar a string
  if Length(NumConhecimento) > 30 then
  begin
    NumConhecimento := Copy(NumConhecimento, 1, 27) + '...';
  end;

  try
    // Inicia a transação
    EConexao.BeginTran;

    // Muda a situação da OS
    Retorno := MudarSituacaoInt(EConexao, EMensagens, CodOrdemServico,
      cCodSituacaoOSProd, TxtObservacao, True, True, False);
    if (Retorno < 0) then
    begin
      raise EHerdomException.Create(Retorno, '', '', [], true);
    end;

    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Atualiza os dados do envio dos identificadores ao fabricante
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_ordem_servico');
        SQL.Add('   SET dta_envio = :dta_envio,');
        SQL.Add('       nom_servico_envio = :nom_servico_envio,');
        SQL.Add('       num_conhecimento = :num_conhecimento');
        SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');

        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        ParamByName('dta_envio').AsDateTime := DtaEnvio;
        AtribuiParametro(QueryLocal, NomServicoEnvio, 'nom_servico_envio', '');
        AtribuiParametro(QueryLocal, NumConhecimento, 'num_conhecimento', '');

        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;

    // Finaliza a transação
    EConexao.Commit;
  except
    on E: EHerdomException do
    begin
      EConexao.Rollback;
      raise;
    end;
    on E: Exception do
    begin
      EConexao.Rollback;
      raise EHerdomException.Create(2000, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;

  // Envia o e-mail da musança de situação se for necessário
  EnviarEMail(EConexao, EMensagens, cCodSituacaoOSProd, CodOrdemServico,
    0, 0, 0, 0, '', '', '', '', 0, '', '');
end;

function TIntOrdensServico.PesquisarSituacoesFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
const
  NomeMetodo: String = 'PesquisarSituacoesFichas';
  CodMetodo: Integer = 613;
begin
  if not Inicializado then
  begin
    Result := -1;
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

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

    with Query do
    begin
      SQL.Clear;
{$IFDEF MSSQL}
      SQL.Add('SELECT cod_ordem_servico AS CodOrdemServico,');
      SQL.Add('       num_remessa_ficha AS NumRemessaFicha,');
      SQL.Add('       seq_faixa_remessa AS SeqFaixaRemessa,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE cod_pais_sisbov');
      SQL.Add('       END AS CodPaisSISBOV,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE cod_estado_sisbov');
      SQL.Add('       END AS CodEstadoSISBOV,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE cod_micro_regiao_sisbov');
      SQL.Add('       END AS CodMicroRegiaoSISBOV,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE MIN(cod_animal_sisbov)');
      SQL.Add('       END AS CodAnimalSISBOVInicio,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE dbo.fnt_calcula_num_dv_sisbov(cod_pais_sisbov, cod_estado_sisbov, cod_micro_regiao_sisbov, MIN(cod_animal_sisbov))');
      SQL.Add('       END AS NumDVSISBOVInicio,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE MAX(cod_animal_sisbov)');
      SQL.Add('       END AS CodAnimalSISBOVFim,');
      SQL.Add('       CASE IsNull(num_remessa_ficha, 0)');
      SQL.Add('         WHEN 0 THEN NULL');
      SQL.Add('         ELSE dbo.fnt_calcula_num_dv_sisbov(cod_pais_sisbov, cod_estado_sisbov, cod_micro_regiao_sisbov, MAX(cod_animal_sisbov))');
      SQL.Add('       END AS NumDVSISBOVFim,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_recebimento_ficha, 3)) AS DtaRecebimentoFicha,');
      SQL.Add('       SUM(case IsNull(dta_recebimento_ficha, 0) when 0 then 0 else 1 end) AS QtdCodigosRecebimentoFicha,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_aprovacao_ficha, 3)) AS DtaAprovacaoFicha,');
      SQL.Add('       SUM(case IsNull(dta_aprovacao_ficha, 0) when 0 then 0 else 1 end) AS QtdCodigosAprovacaoFicha,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_utilizacao_codigo, 3)) AS DtaUtilizacaoCodigo,');
      SQL.Add('       SUM(case IsNull(dta_utilizacao_codigo, 0) when 0 then 0 else 1 end) AS QtdCodigosUtilizacao,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_efetivacao_cadastro, 3)) AS DtaEfetivacaoCadastro,');
      SQL.Add('       SUM(case IsNull(dta_efetivacao_cadastro, 0) when 0 then 0 else 1 end) AS QtdCodigosEfetivacaoCadastro,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_autenticacao, 3)) AS DtaAutenticacao,');
      SQL.Add('       SUM(case IsNull(dta_autenticacao, 0) when 0 then 0 else 1 end) AS QtdCodigosAutenticacao,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_impressao_certificado, 3)) AS DtaImpressaoCertificado,');
      SQL.Add('       SUM(case IsNull(dta_impressao_certificado, 0) when 0 then 0 else 1 end) AS QtdCodigosImpressaoCertificado,');
      SQL.Add('       MAX(CONVERT(CHAR(8), dta_envio_certificado, 3)) AS DtaEnvioCertificado,');
      SQL.Add('       SUM(case IsNull(dta_envio_certificado, 0) when 0 then 0 else 1 end) AS QtdCodigosEnvioCertificado');
      SQL.Add('  FROM tab_codigo_sisbov');
      SQL.Add(' WHERE cod_ordem_servico = :cod_ordem_servico');
      if NumRemessaFicha > -1 then
      begin
        SQL.Add('  AND num_remessa_ficha = :num_remessa_ficha');
      end;
      SQL.Add('GROUP BY cod_ordem_servico,');
      SQL.Add('       num_remessa_ficha,');
      SQL.Add('       seq_faixa_remessa,');
      SQL.Add('       cod_pais_sisbov,');
      SQL.Add('       cod_estado_sisbov,');
      SQL.Add('       cod_micro_regiao_sisbov');
      SQL.Add('ORDER BY cod_ordem_servico,');
      SQL.Add('       num_remessa_ficha,');
      SQL.Add('       seq_faixa_remessa,');
      SQL.Add('       cod_pais_sisbov,');
      SQL.Add('       cod_estado_sisbov,');
      SQL.Add('       cod_micro_regiao_sisbov');
{$ENDIF}

      ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      if NumRemessaFicha > -1 then
      begin
        ParamByName('num_remessa_ficha').AsInteger := NumRemessaFicha;
      end;

      Open;

      if IsEmpty then
      begin
        Mensagens.Adicionar(2055, Self.ClassName, NomeMetodo, []);
        Result := -2055;
        Exit;
      end;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(2056, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2056;
    end;
  end;
end;

function TIntOrdensServico.AlterarEnvioIdentOS(ECodOrdemServico: Integer;
                                               EDtaEnvioIdentificadores: TDateTime;
                                               ENomServicoEnvio,
                                               ENroConhecimento: String): Integer;
const
  NomMetodo: String  = 'AlterarEnvioIdentOS';
  CodMetodo: Integer = 645;
var
  Qry: THerdomQuery;
  CodSituacaoOS: Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if EDtaEnvioIdentificadores = 0 then
  begin
    Mensagens.Adicionar(2201, Self.ClassName, NomMetodo, []);
    Result := -2201;
    Exit;
  end;

  if Length(Trim(ENomServicoEnvio)) = 0 then
  begin
    Mensagens.Adicionar(2202, Self.ClassName, NomMetodo, []);
    Result := -2202;
    Exit;
  end;

  if Length(Trim(ENroConhecimento)) = 0 then
  begin
    Mensagens.Adicionar(2203, Self.ClassName, NomMetodo, []);
    Result := -2203;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Qry.SQL.Clear;
      Qry.SQL.Add(' select cod_situacao_os, cod_ordem_servico ' +
                  '   from tab_ordem_servico ' +
                  '  where cod_ordem_servico = :cod_ordem_servico ');
      Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(1744, Self.ClassName, NomMetodo, []);
        Result := -1744;
        Exit;
      end;

      CodSituacaoOS := Qry.FieldByName('cod_situacao_os').AsInteger;

      Qry.SQL.Clear;
      Qry.SQL.Add(' select top 1 dta_mudanca_situacao ' +
                  '   from tab_historico_situacao_os ' +
                  '  where cod_ordem_servico = :cod_ordem_servico ' +
                  '    and cod_situacao_os > 5 ' +
                  '    and not cod_situacao_os in (14, 99) ');
      Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(1744, Self.ClassName, NomMetodo, []);
        Result := -1744;
        Exit;
      end;

      if Trunc(Qry.FieldByName('dta_mudanca_situacao').AsDateTime) > EDtaEnvioIdentificadores then
      begin
        Mensagens.Adicionar(2207, Self.ClassName, NomMetodo, []);
        Result := -2207;
        Exit;
      end;             

      if (CodSituacaoOS < 6) then
      begin
        Mensagens.Adicionar(2204, Self.ClassName, NomMetodo, []);
        Result := -2204;
        Exit;
      end;

      if (CodSituacaoOS = 99) then
      begin
        Mensagens.Adicionar(2205, Self.ClassName, NomMetodo, []);
        Result := -2205;
        Exit;
      end;

      BeginTran;

      Qry.SQL.Clear;
      Qry.SQL.Add(' update tab_ordem_servico ' +
                  '    set dta_envio = :dta_envio ' +
                  '      , nom_servico_envio = :nom_servico_envio ' +
                  '      , num_conhecimento  = :num_conhecimento ' +
                  '      , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
                  '      , dta_ultima_alteracao = getdate() ' +
                  '  where cod_ordem_servico = :cod_ordem_servico ');
      Qry.ParamByName('dta_envio').AsDateTime                   := EDtaEnvioIdentificadores;
      Qry.ParamByName('nom_servico_envio').AsString             := ENomServicoEnvio;
      Qry.ParamByName('num_conhecimento').AsString              := ENroConhecimento;
      Qry.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Qry.ParamByName('cod_ordem_servico').AsInteger            := ECodOrdemServico;
      Qry.ExecSQL;
      Commit;

      Result := 0;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2206, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2206;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TIntOrdensServico.IncluirSolicitacaoNumeracao(CodOrdemServico: Integer): Integer;
const
  NomMetodo: String  = 'IncluirSolicitacaoNumeracao';
  CodMetodo: Integer = 569;
var
  Q1, Qry: THerdomQuery;
  I: Integer;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoSolicitacaoNumeracao;
  RetornoRecuperacaoCodigo: RetornoRecuperarNumeracao;
  RetornoConsulta: RetornoConsultaSolicitacaoNumeracao;
  CodSisbovInicio, CodSisbovFim: widestring;
  DataSolicitacao: Tdatetime;
  NroSolicitacao, CodEstadoSisBov, CodAnimalInicio, CodDVInicio, CodAnimalFim, CodDVFim: Integer;
  FIntCodigosSisbov: TIntCodigosSisbov;
  ListaCodigo: TStringList;
  sMsgConsulta: String;
begin
  Result := -1;
  RetornoSisbov   := nil;
  RetornoRecuperacaoCodigo := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Q1  := THerdomQuery.Create(Conexao, nil);
  Qry := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  ListaCodigo := TStringList.Create;

  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.Conectado('Solicitação numeração');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, NomMetodo, ['não foi possível transmitir a solicitação de numeração']);
        Result := -2289;
        Exit;
      end;

      Q1.SQL.Clear;
      Q1.SQL.Add('select  tos.cod_situacao_os ' +
                 '      , tos.cod_ordem_servico ' +
                 '      , tos.cod_pessoa_produtor ' +
                 '      , case tp.cod_natureza_pessoa ' +
                 '              when ''F'' then tp.num_cnpj_cpf ' +
                 '              else ''''   ' +
                 '        end as num_cpf_produtor ' +
                 '      , case tp.cod_natureza_pessoa ' +
                 '              when ''J'' then tp.num_cnpj_cpf ' +
                 '              else ''''   ' +
                 '           end as num_cnpj_produtor ' +
                 '      , tfi.num_cnpj_fabricante ' +
                 '      , tos.cod_propriedade_rural ' +
                 '      , tpr.cod_id_propriedade_sisbov ' +
                 '      , 105 as cod_pais ' +
                 '      , tos.qtd_animais ' +
                 '      , tid.cod_identificacao_dupla_sisbov ' +
                 '      , tos.ind_transmissao_sisbov ' +
                 '      , tos.num_solicitacao_sisbov ' +
                 '      , tos.dta_solicitacao_sisbov ' +
                 'from tab_ordem_servico tos ' +
                 '   ,  tab_pessoa tp ' +
                 '   ,  tab_propriedade_rural tpr ' +
                 '   ,  tab_fabricante_identificador tfi ' +
                 '   ,  tab_identificacao_dupla tid ' +
                 'where cod_ordem_servico                 = :cod_ordem_servico ' +
                 '  and tos.cod_pessoa_produtor           = tp.cod_pessoa ' +
                 '  and tos.cod_propriedade_rural         = tpr.cod_propriedade_rural ' +
                 '  and tos.cod_fabricante_identificador *= tfi.cod_fabricante_identificador ' +
                 '  and tos.cod_identificacao_dupla      *= tid.cod_identificacao_dupla ');

      Q1.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q1.Open;

      if Q1.IsEmpty then
      begin
        Mensagens.Adicionar(1744, Self.ClassName, NomMetodo, []);
        Result := -1744;
        Exit;
      end;

      // Testa se a solicitação de códigos já foi enviada ao sisbov
//      if (Q1.FieldByName('ind_transmissao_sisbov').AsString = '') and (Q1.FieldByName('num_solicitacao_sisbov').AsString = '') then begin
      if (Q1.FieldByName('num_solicitacao_sisbov').AsString = '') then begin
        if (Q1.FieldByName('num_cnpj_fabricante').AsString = '') or
           (Q1.FieldByName('cod_identificacao_dupla_sisbov').AsString = '') or
           (Q1.FieldByName('qtd_animais').AsInteger = 0) then
        begin
          Mensagens.Adicionar(2287, Self.ClassName, NomMetodo, []);
          Result := -2287;
          Exit;
        end;

        if (Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger = 0) then
        begin
          Mensagens.Adicionar(2288, Self.ClassName, NomMetodo, []);
          Result := -2288;
          Exit;
        end;

        try
          RetornoSisbov := SoapSisbov.solicitarNumeracao(
                               Descriptografar(ValorParametro(118))
                             , Descriptografar(ValorParametro(119))
                             , Q1.FieldByName('num_cnpj_fabricante').AsString
                             , Q1.FieldByName('num_cpf_produtor').AsString
                             , Q1.FieldByName('num_cnpj_produtor').AsString
                             , Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger
                             , Q1.FieldByName('qtd_animais').AsInteger
                             , StrToInt(trim(Q1.FieldByName('cod_identificacao_dupla_sisbov').AsString)));
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(2290, Self.ClassName, NomMetodo, ['']);
            Result := -2290;
          end;
        end;

        If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then begin
//          If RetornoSisbov.Status = 0 then begin
            DataSolicitacao := Now;

            BeginTran;

            Qry.SQL.Clear;
{$IFDEF MSSQL}
            Qry.SQL.Add(' update tab_ordem_servico ' +
                        '    set ind_transmissao_sisbov         = ''S'' ' +
                        '      , cod_id_transacao_sisbov        = :cod_idtransacao ' +
                        '      , num_solicitacao_sisbov         = :num_solicitacao_sisbov ' +
                        '      , dta_solicitacao_sisbov         = :dta_solicitacao_sisbov ' +
                        '  where cod_ordem_servico      = :cod_ordem_servico ');
{$ENDIF}

            Qry.ParamByName('cod_ordem_servico').AsInteger         := CodOrdemServico;
            Qry.ParamByName('num_solicitacao_sisbov').AsInteger    := RetornoSisbov.numeroSolicitacao;
            Qry.ParamByName('dta_solicitacao_sisbov').AsDateTime   := DataSolicitacao;
            Qry.ParamByName('cod_idtransacao').AsInteger           := RetornoSisbov.idTransacao;
            Qry.ExecSQL;

            Commit;

//            Mensagens.Adicionar(2290, Self.ClassName, NomMetodo, ['Mensagem Sisbov : ' + TrataMensagemErroSISBOV(RetornoSisbov)]);
//            Result := -2290;
//            Exit;
//          end;
        end else begin
          Mensagens.Adicionar(2290, Self.ClassName, NomMetodo, [' Erro no retorno do Sisbov ']);
          Result := -2290;
          Exit;
        end;

        // situacao para "Códigos SISBOV já solicitados"
        Result := TIntOrdensServico.MudarSituacao(Conexao, Mensagens, CodOrdemServico, 2, '', 'S', 'S');
        if Result < 0 then
          Exit;

      end else begin
        RetornoConsulta := nil;
        try
          sMsgConsulta := '';
          RetornoConsulta := SoapSisbov.consultaSolicitacaoNumeracao( Descriptografar(ValorParametro(118)), Descriptografar(ValorParametro(119)), Q1.FieldByName('num_solicitacao_sisbov').AsInteger);
          if (RetornoConsulta <> nil) then
          begin                                                              // Aprovada, Finalizada
            if (RetornoConsulta.status <> 1) and (not RetornoConsulta.situacao in [3,7]) then
            begin
              sMsgConsulta := 'a solicitação já foi solicitada e retornou situação ';
              case RetornoConsulta.situacao of
                1: sMsgConsulta := sMsgConsulta + '"Não Enviada".';
                2: sMsgConsulta := sMsgConsulta + '"Enviada".';
                4: sMsgConsulta := sMsgConsulta + '"Não Aprovada".';
                5: sMsgConsulta := sMsgConsulta + '"Cancelada".';
                6: sMsgConsulta := sMsgConsulta + '"Aberta".';
              end;
              if (Trim(RetornoConsulta.observacao) <> '') then
                sMsgConsulta := sMsgConsulta + ' *** Observação: ' + RetornoConsulta.observacao;
            end
            else begin
                sMsgConsulta := 'a solicitação já foi solicitada porém ocorreu um ERRO ao consultar sua situação. ERRO: ' + RetornoConsulta.listaErros[0].codigoErro + ' - ' + RetornoConsulta.listaErros[0].menssagemErro;
                if (RetornoConsulta.erroBanco = '') then
                  sMsgConsulta := sMsgConsulta + ' ErroBanco: ' + RetornoConsulta.erroBanco;
            end;
          end
          else
            sMsgConsulta := 'a solicitação já foi solicitada porém ocorreu um ERRO desconhecido ao consultar sua situação.';
          if (sMsgConsulta <> '') then
            raise Exception.Create(sMsgConsulta);
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(2305, Self.ClassName, NomMetodo, [sMsgConsulta]);
            Result := -2305;
          end;
        end;

        try
          RetornoRecuperacaoCodigo := SoapSisbov.recuperarNumeracao( Descriptografar(ValorParametro(118)), Descriptografar(ValorParametro(119)), Q1.FieldByName('num_solicitacao_sisbov').AsInteger);
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(2305, Self.ClassName, NomMetodo, [IntToStr(Q1.FieldByName('num_solicitacao_sisbov').AsInteger)]);
            Result := -2305;
          end;
        end;

        If RetornoRecuperacaoCodigo <> nil then begin
          If RetornoRecuperacaoCodigo.Status = 0 then begin
            Mensagens.Adicionar(2305, Self.ClassName, NomMetodo, ['Mensagem Sisbov : ' + TrataMensagemErroSISBOV(RetornoRecuperacaoCodigo)]);
            Result := -2305;
            Exit;
          end else begin
            For I := 0 To length(RetornoRecuperacaoCodigo.numeracao) - 1 do begin
              ListaCodigo.Add(RetornoRecuperacaoCodigo.numeracao[I].numero);
            end;
            ListaCodigo.Sorted := True;

            CodSisbovInicio := ListaCodigo.Strings[0];
            CodSisbovFim    := ListaCodigo.Strings[ListaCodigo.Count -1];

            CodEstadoSisBov := StrToInt(copy(CodSisbovInicio,4,2));
            CodAnimalInicio := StrToInt(copy(CodSisbovInicio,6,9));
            CodDVInicio     := StrToInt(copy(CodSisbovInicio,15,1));
            CodAnimalFim    := StrToInt(copy(CodSisbovFim,6,9));
            CodDVFim        := StrToInt(copy(CodSisbovFim,15,1));
            NroSolicitacao  := Q1.FieldByName('num_solicitacao_sisbov').AsInteger;
            DataSolicitacao := Q1.FieldByName('dta_solicitacao_sisbov').AsDateTime;

            BeginTran;

            Qry.SQL.Clear;
{$IFDEF MSSQL}
            Qry.SQL.Add(' update tab_ordem_servico ' +
                        '    set ind_transmissao_sisbov         = ''S'' ' +
                        '      , cod_id_transacao_sisbov        = :cod_idtransacao ' +
                        '      , num_solicitacao_sisbov         = :num_solicitacao_sisbov ' +
                        '      , cod_pais_sisbov_inicio         = 105 ' +
                        '      , cod_estado_sisbov_inicio       = :cod_estado_sisbov_inicio ' +
                        '      , cod_micro_regiao_sisbov_inicio = -1 ' +
                        '      , cod_animal_sisbov_inicio       = :cod_animal_sisbov_inicio ' +
                        '      , num_dv_sisbov_inicio           = :num_dv_sisbov_inicio ' +
                        '      , dta_solicitacao_sisbov         = :dta_solicitacao_sisbov ' +
                        '  where cod_ordem_servico      = :cod_ordem_servico ');
{$ENDIF}

            Qry.ParamByName('cod_ordem_servico').AsInteger         := CodOrdemServico;
            Qry.ParamByName('num_solicitacao_sisbov').AsInteger    := NroSolicitacao;
            Qry.ParamByName('cod_estado_sisbov_inicio').AsInteger  := CodEstadoSisBov;
            Qry.ParamByName('cod_animal_sisbov_inicio').AsInteger  := CodAnimalInicio;
            Qry.ParamByName('num_dv_sisbov_inicio').AsInteger      := CodDVInicio;
            Qry.ParamByName('dta_solicitacao_sisbov').AsDateTime   := DataSolicitacao;
            Qry.ParamByName('cod_idtransacao').AsInteger           := RetornoRecuperacaoCodigo.idTransacao;
            Qry.ExecSQL;

            Commit;

            FIntCodigosSisbov := TIntCodigosSisbov.Create;
            Try
              FIntCodigosSisbov.Inicializar(Conexao, Mensagens);
              Result := FIntCodigosSisbov.Inserir(Q1.FieldByName('cod_pessoa_produtor').AsInteger
                                               , ''
                                               , ''
                                               , Q1.FieldByName('cod_propriedade_rural').AsInteger
                                               , ''
                                               , -1
                                               , NroSolicitacao
                                               , DataSolicitacao
                                               , Q1.FieldByName('cod_pais').AsInteger
                                               , CodEstadoSisBov
                                               , -1
                                               , CodAnimalInicio
                                               , CodDVInicio
                                               , CodAnimalFim
                                               , CodDVFim
                                               , CodOrdemServico);

               // situacao para "Códigos carregados, dados pendentes"
              Result := TIntOrdensServico.MudarSituacao(Conexao, Mensagens, CodOrdemServico, 3, '', 'S', 'S');
              if Result < 0 then
                Exit;
            Finally
              FIntCodigosSisbov.Free;
            end;

          end;
        end else begin
          Mensagens.Adicionar(2305, Self.ClassName, NomMetodo, ['Erro no retorno do SISBOV ']);
          Result := -2305;
          Exit;
        end;

      end;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2291, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2291;
        Exit;
      end;
    end;
  finally
    Q1.Free;
    Qry.Free;
    SoapSisbov.Free;
    ListaCodigo.Free;
  end;
end;

function TIntOrdensServico.DefinirNumeroSolicitacao(CodOrdemServico, NumeroSolicitacao: Integer; DataSolicitacao: TDateTime): Integer;
const
  NomeMetodo: String = 'DefinirNumeroSolicitacao';
var
  QueryLocal: THerdomQuery;
  IndAcessoLiberado: Boolean;
  IndEnviaPedidoIdent: String;
  CodRegistroLog,
  CodSituacaoOS: Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  // Neste teste, está sendo verificado a possibilidade do método de Definição do CodSISBOV Inicial pela similaridade de operação
  // TODO: Incluir o Metodo 'DefinirNumeroSolicitacao' na tab_metodo
  if not Conexao.PodeExecutarMetodo(577) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Valida o NumeroSolicitacao
  if NumeroSolicitacao < 0 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['número de Solicitação informado']);
    Result := -1875;
    Exit;
  end;
  // Valida o NumeroSolicitacao
  if DataSolicitacao = 0 then
  begin
    Mensagens.Adicionar(1875, Self.ClassName, NomeMetodo, ['valor informado para data da Solicitação']);
    Result := -1875;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem os dados básicos da  OS e verifica se o usuário tem acesso à OS
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select cod_ordem_servico,');
        SQL.Add('       cod_situacao_os,');
        SQL.Add('       cod_pessoa_produtor,');
        SQL.Add('       cod_propriedade_rural,');
        SQL.Add('       qtd_animais,');
        SQL.Add('       ind_envia_pedido_ident,');
        SQL.Add('       cod_registro_log,');
        SQL.Add('       isNull(cod_pais_sisbov_inicio, -1) as cod_pais_sisbov_inicio,');
        SQL.Add('       num_dv_sisbov_inicio,');
        SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla');
        SQL.Add('  from tab_ordem_servico');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
        Open;

        If IsEmpty Then Begin
          Mensagens.Adicionar(1744, Self.ClassName, NomeMetodo, []);
          Result := -1744;
          Exit;
        End;

        Result := VerificaPermissao(Conexao, Mensagens, IndAcessoLiberado, FieldByName('cod_pessoa_produtor').AsInteger, True);
        if (Result < 0) or (not IndAcessoLiberado) then
        begin
          Exit;
        end;

        CodSituacaoOS       := FieldByName('cod_situacao_os').AsInteger;
        IndEnviaPedidoIdent := FieldByName('ind_envia_pedido_ident').AsString;
        CodRegistroLog      := FieldByName('cod_registro_log').AsInteger;
      end;

      // Verifica se a OS pode ser alterada
      // Neste teste, está sendo verificado a possibilidade do Campo CodSISBOV Inicial pela similaridade de operação
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select tsaos.ind_pode_alterar,');
        SQL.Add('       tsos.des_situacao_os');
        SQL.Add('  from tab_situacao_atributo_os tsaos,');
        SQL.Add('       tab_situacao_os tsos');
        SQL.Add(' where tsaos.cod_situacao_os = tsos.cod_situacao_os');
        SQL.Add('   and tsaos.ind_envia_pedido_ident = :ind_envia_pedido_ident');
        SQL.Add('   and tsos.cod_situacao_os = :cod_situacao_os');
        SQL.Add('   and tsaos.cod_atributo_os = 19');
{$ENDIF}
        ParamByName('cod_situacao_os').AsInteger := CodSituacaoOS;
        ParamByName('ind_envia_pedido_ident').AsString := IndEnviaPedidoIdent;

        Open;
        if FieldByName('ind_pode_alterar').AsString = 'N' then
        begin
          Mensagens.Adicionar(1873, Self.ClassName, NomeMetodo, ['Número da Solicitação.']);
          Result := -1873;
          Exit;
        end;
      end;


      BeginTran;

      // Atualiza o Numero da Solicitacao
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add(' update tab_ordem_servico ');
        SQL.Add('   set num_solicitacao_sisbov = :num_solicitacao_sisbov, ');
        SQL.Add('       dta_solicitacao_sisbov = :dta_solicitacao_sisbov, ');
        SQL.Add('       cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao, ');
        SQL.Add('       dta_ultima_alteracao = getDate() ');
        SQL.Add(' where cod_ordem_servico = :cod_ordem_servico ');
{$ENDIF}
        ParamByName('cod_ordem_servico').AsInteger            := CodOrdemServico;
        ParamByName('num_solicitacao_sisbov').AsInteger       := NumeroSolicitacao;
        ParamByName('dta_solicitacao_sisbov').AsDateTime      := DataSolicitacao;
        ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;

        ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert,   2-Alteração Antes,      3-Alteração Após,
        //              4-Exclusão, 5-Finalização Validade, 6-Revalidação
        // TODO: Incluir o Metodo 'DefinirNumeroSolicitacao' na tab_metodo
//        Result := GravarLogOperacao('tab_ordem_servico', CodRegistroLog, 1, 577);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1877, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1877;
      Exit;
    end;
  end;
end;

function TIntOrdensServico.IncluirSolicitacaoNumeracaoReimpressao(CodOrdemServico: Integer): Integer;
const
  NomeMetodo: String  = 'solicitarNumeracaoReimpressao';
//  CodMetodo: Integer = 656;
var
  Q1, Q2, Q3: THerdomQueryNavegacao;
  Index: Integer;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoSolicitacaoNumeracaoReimpressao;
  RetornoConsulta: RetornoConsultarNumeracaoReimpressao;
  NroSolicitacao: Integer;
  Conectado: boolean;
  CodigosSisbov: Array_Of_NumeroReimpressaoDTO;
begin

  Result := -1;
  RetornoSisbov   := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

//  if not Conexao.PodeExecutarMetodo(CodMetodo) then
//  begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  end;

  Q1  := THerdomQueryNavegacao.Create(nil);
  Q1.SQLConnection := Conexao.SQLConnection;
  Q2 := THerdomQueryNavegacao.Create(nil);
  Q2.SQLConnection := Conexao.SQLConnection;
  SoapSisbov := TIntSoapSisbov.Create;

  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Solicitação numeração reimpressão');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, [' não foi possível transmitir a solicitação de numeração ']);
        Result := -2289;
        Exit;
      end;

      // Verifica se a solicitação de reimpressão ainda não foi enviada ao SISBOV
      if (true) then begin //(Q1.FieldByName('num_solicitacao_sisbov').AsString = '') then begin
        try
          RetornoSisbov := SoapSisbov.solicitarNumeracaoReimpressao(
                               Descriptografar(ValorParametro(118))
                             , Descriptografar(ValorParametro(119))
                             , Q1.FieldByName('num_cnpj_fabricante').AsString
                             , Q1.FieldByName('num_cpf_produtor').AsString
                             , Q1.FieldByName('num_cnpj_produtor').AsString
                             , Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger
                             , Q1.FieldByName('qtd_animais').AsInteger
                             , CodigosSisbov);
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['']);
            Result := -2290;
          end;
        end;

        If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then begin
          Result := RetornoSisbov.status;
          BeginTran;
          Q3 := THerdomQueryNavegacao.Create(nil);
          Q3.SQLConnection := Conexao.SQLConnection;
          Q3.SQL.Clear;
{$IFDEF MSSQL}
          Q3.SQL.Add(' update tab_ordem_servico ' +
                      '    set ind_transmissao_sisbov         = ''S'' ' +
                      '      , cod_id_transacao_sisbov        = :cod_idtransacao ' +
                      '      , num_solicitacao_sisbov         = :num_solicitacao_sisbov ' +
                      '      , dta_solicitacao_sisbov         = :dta_solicitacao_sisbov ' +
                      '  where cod_ordem_servico      = :cod_ordem_servico ');
{$ENDIF}

          Q3.ParamByName('cod_ordem_servico').AsInteger         := Q1.FieldByName('cod_ordem_servico').AsInteger;
          Q3.ParamByName('num_solicitacao_sisbov').AsInteger    := RetornoSisbov.numeroSolicitacao;
          Q3.ParamByName('dta_solicitacao_sisbov').AsDateTime   := Now;
          Q3.ParamByName('cod_idtransacao').AsInteger           := RetornoSisbov.idTransacao;
          Q3.ExecSQL;

          Commit;
          Exit;
        end else begin
          Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [RetornoSisbov.listaErros[0].menssagemErro]);
          Result := -2290;
          Exit;
        end;

      end else begin
        //Atualizar a situação dos registros.
        ConsultarNumeracaoReimpressao(CodOrdemServico);
      end;
    except
      on E:Exception do begin
        Rollback;
        Mensagens.Adicionar(2291, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2291;
        Exit;
      end;
    end;

  finally
    Q1.Free;
    Q2.Free;
    SoapSisbov.Free;
  end;
end;

function TIntOrdensServico.ConsultarNumeracaoReimpressao(
  CodOrdemServico: Integer): Integer;
const
  NomeMetodo: String  = 'consultarNumeracaoReimpressao';
var
  Index: Integer;
  Q1: THerdomQueryNavegacao;
  Q2: THerdomQueryNavegacao;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoConsultarNumeracaoReimpressao;
  NumeroSolicitacao: Integer;
  CodigoPais: Integer;
  CodigoEstado: Integer;
  CodigoSisbov: Integer;
  CodigoDVSisbov: Integer;
  CodigoSituacao: Integer;
  Conectado: Boolean;
begin
  Result := -1;
  RetornoSisbov   := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    try
      Q1 := THerdomQueryNavegacao.Create(nil);
      Q1.SQLConnection := Conexao.SQLConnection;
      Q1.SQL.Clear;
      Q1.SQL.Add(' select top 1 num_solicitacao_sisbov ' +
                 ' from tab_ordem_servico ' +
                 ' where cod_ordem_servico = :cod_ordem_servico ');
      Q1.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Q1.Open;
      NumeroSolicitacao := Q1.FieldByName('num_solicitacao_sisbov').AsInteger;
      Q1.Close;

      if NumeroSolicitacao < 1 then
      begin
        Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, [' solicitação não enviada ao sisbov ']);
        Result := -2410;
        Exit;
      end;

      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Consultar numeração de reimpressão');
      try
        RetornoSisbov := SoapSisbov.consultarNumeracaoReimpressao(
                             Descriptografar(ValorParametro(118))
                           , Descriptografar(ValorParametro(119))
                           , NumeroSolicitacao);
      except
        on E: Exception do begin
          Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, ['']);
          Result := -2410;
        end;
      end;

      If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then
      begin

        Q1.SQLConnection := Conexao.SQLConnection;
        Q1.SQL.Clear;
        Q1.SQL.Add(' select cod_situacao_codigo_sisbov ' +
                   ' from tab_situacao_codigo_sisbov ' +
                   ' where des_situacao_codigo_sisbov like :des_situacao_codigo_sisbov ');

        Q2 := THerdomQueryNavegacao.Create(nil);
        Q2.SQLConnection := Conexao.SQLConnection;
        Q2.SQL.Clear;
        Q2.SQL.Add(' update tab_codigo_sisbov ' +
                     '      set cod_situacao_codigo_sisbov = :cod_situacao_codigo_sisbov ' +
                     '        , dta_ultima_alteracao       = getdate() ' +
                     '  where cod_ordem_servico            = :cod_ordem_servico ' +
                     '    and cod_pais_sisbov              = :cod_pais_sisbov ' +
                     '    and cod_estado_sisbov            = :cod_estado_sisbov '+
                     '    and cod_animal_sisbov            = :cod_animal_sisbov '+
                     '    and num_dv_sisbov                = :num_dv_sisbov' );

        for Index := 0 to Length(RetornoSisbov.numeracoes) do
        begin
          Q2.ParamByName('des_situacao_codigo_sisbov').AsString := RetornoSisbov.numeracoes[Index].descricao;
          Q2.Open;
          CodigoSituacao := Q2.FieldByName('cod_situacao_codigo_sisbov').AsInteger;
          Q2.Close;

          if CodigoSituacao = 0 then
          begin
            Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, [' situação Sisbov não localizada ']);
            Result := -2410;
            Exit;
          end;
          CodigoPais := StrToInt(Copy(RetornoSisbov.numeracoes[Index].numero,   1, 3));
          codigoEstado := StrToInt(Copy(RetornoSisbov.numeracoes[Index].numero, 4, 2));
          CodigoSisbov := StrToInt(Copy(RetornoSisbov.numeracoes[Index].numero, 7, Length(RetornoSisbov.numeracoes[Index].numero) -1));
          CodigoDVSisbov := StrToInt(Copy(RetornoSisbov.numeracoes[Index].numero, Length(RetornoSisbov.numeracoes[Index].numero) -1, 1));

          Begintran;

          Q2.ParamByName('cod_situacao_codigo_sisbov').AsInteger := CodigoSituacao;
          Q2.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Q2.ParamByName('cod_pais_sisbov').AsInteger := CodigoPais;
          Q2.ParamByName('cod_estado_sisbov').AsInteger := codigoEstado;
          Q2.ParamByName('cod_animal_sisbov').AsInteger := CodigoSisbov;
          Q2.ParamByName('num_dv_sisbov').AsInteger := CodigoDVSisbov;
          Q2.ExecSQL;

          Commit;
        end;
      end else begin
        Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, [RetornoSisbov.listaErros[0].menssagemErro]);
        Result := -2410;
        Exit;
      end;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2410;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
  end;
end;

function TIntOrdensServico.TempConsultarNumeracaoReimpressao(
  const numeroSolicitacao: Int64): WideString;
const
  NomeMetodo: String  = 'IncluirSolicitarNumeracaoReimpressao';
var
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoConsultarNumeracaoReimpressao;
  Conectado: boolean;
  Index: Integer;
  Retorno: TStringList;
begin
  Retorno := TStringList.Create;
  RetornoSisbov := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  if not Conexao.PodeExecutarMetodo(569) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    //Result := -188;
    Exit;
  end;

  SoapSisbov := TIntSoapSisbov.Create;
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado := SoapSisbov.Conectado('Solicitação numeração reimpressão');

    if not Conectado then begin
      Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, ['não foi possível transmitir a solicitação de numeração']);
      //Result := -2289;
      Exit;
    end;

    RetornoSisbov := SoapSisbov.consultarNumeracaoReimpressao(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , NumeroSolicitacao);
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['']);
      //Result := -2290;
    end;
  end;

  for Index := 0 to High(RetornoSisbov.numeracoes) do
  begin
    Retorno.Values[RetornoSisbov.numeracoes[Index].numero] := RetornoSisbov.numeracoes[Index].descricao;
  end;
  Result := TrimRight(Retorno.Text);
end;

function TIntOrdensServico.TempSolicitarNumeracaoReimpressao(cnpjFabrica, cpfProdutor, cnpjProdutor: WideString;
  const idPropriedade: Int64; const qtd: Integer; const numero_sisbov, tipo_identificacao: WideString): Integer;
const
  NomeMetodo: String  = 'solicitarNumeracaoReimpressao';
var
  Index: Integer;
  XMLDoc: TXMLDocument;
  XMLDocRetorno: IXMLDocument;
  INodeEnvelope, INodeBody, INodeReimpressao, INodeUsuario, INodeSenha, INodeCnpjFabrica, INodeCpfProdutor, INodeCnpjProdutor,
    INodeIdPropriedade, INodeQtde, INodeNumeros, INodeNumeroSisbov, INodeTipoIdent: IXMLNode;
  INodeRetorno:IXMLNode;
  SoapSisbov: THttpReqResp;
  Conectado: boolean;
  NumerosSisbov: TStringList;
  IdentSisbov: TStringList;
  RetornoXMLSisbov: TStringStream;
  RetornoSisbov: RetornoSolicitacaoNumeracaoReimpressao;
  NomeArquivoENV: string;
  NomeArquivoRET: string;

  teste: string;
begin
  Result := -1;

  //
  // Criação do Arquivo XML
  //
  XMLDoc := TXMLDocument.Create(nil);
  //NomeArquivoENV := ValorParametro(16) + '\' + Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaSistema) + '_ENV_' + NomeMetodo + '.xml';
  //NomeArquivoRET := ValorParametro(16) + '\' + Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaSistema) + '_RET_' + NomeMetodo + '.xml';

  NomeArquivoENV  :=  ValorParametro(16)   + '\' +
                      FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
                      FormatDateTime('mm', Conexao.DtaSistema)   + '\' +
                      FormatDateTime('dd', Conexao.DtaSistema)   + '\' +
                      Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_ENV_' + NomeMetodo + '.xml';

  NomeArquivoRET  :=  ValorParametro(16)   + '\' +
                      FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
                      FormatDateTime('mm', Conexao.DtaSistema)   + '\' +
                      FormatDateTime('dd', Conexao.DtaSistema)   + '\' +
                      Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_RET_' + NomeMetodo + '.xml';
  try
      XMLDoc.Active := true;
      XMLDoc.Version :=  '1.0';

    INodeEnvelope := XMLDoc.AddChild('SOAP-ENV:Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
    INodeEnvelope.Attributes['xmlns:xsd'] := 'http://www.w3.org/2001/XMLSchema';
    INodeEnvelope.Attributes['xmlns:xsi'] := 'http://www.w3.org/2001/XMLSchema-instance';

    INodeBody := INodeEnvelope.AddChild('SOAP-ENV:Body');
    INodeReimpressao := INodeBody.AddChild('solicitarNumeracaoReimpressao', 'http://servicosWeb.sisbov.mapa.gov.br');
    INodeUsuario := INodeReimpressao.AddChild('usuario');
    INodeUsuario.Text := Descriptografar(ValorParametro(118));
    INodeSenha := INodeReimpressao.AddChild('senha');
    INodeSenha.Text := Descriptografar(ValorParametro(119));
    INodeCnpjFabrica := INodeReimpressao.AddChild('cnpjFabrica');
    INodeCnpjFabrica.Text := cnpjFabrica;
    INodeCpfProdutor := INodeReimpressao.AddChild('cpfProdutor');
    INodeCpfProdutor.Text := cpfProdutor;
    INodeCnpjProdutor := INodeReimpressao.AddChild('cnpjProdutor');
    INodeCnpjProdutor.Text := cnpjProdutor;
    INodeIdPropriedade := INodeReimpressao.AddChild('idPropriedade');
    INodeIdPropriedade.Text := IntToStr(idPropriedade);
    INodeQtde := INodeReimpressao.AddChild('qtd');
    INodeQtde.Text := IntToStr(qtd);

    NumerosSisbov := TStringList.Create;
    IdentSisbov := TStringList.Create;
    try
      NumerosSisbov.DelimitedText := numero_sisbov;
      IdentSisbov.DelimitedText := tipo_identificacao;
      for Index := 0 to NumerosSisbov.Count -1 do
      begin
        INodeNumeros := INodeReimpressao.AddChild('numero');
        INodeNumeroSisbov := INodeNumeros.AddChild('numeroSisbov', 'http://model.sisbov.mapa.gov.br');
        INodeNumeroSisbov.Text := NumerosSisbov[Index];
        INodeTipoIdent := INodeNumeros.AddChild('tipoIdentificacao');
        INodeTipoIdent.Text := IdentSisbov[Index];
      end;
    finally
      NumerosSisbov.Free;
      NumerosSisbov := Nil;
    end;

  except
    Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [' criação - Arquivo reimpressão ']);
    Result := -2278;
    Exit;
  end;

  SoapSisbov := THTTPReqResp.Create(nil);
  RetornoXMLSisbov := TStringStream.Create('');
  RetornoSisbov := RetornoSolicitacaoNumeracaoReimpressao.Create;

  try
    try
      SoapSisbov.URL := ValorParametro(117);
      SoapSisbov.Proxy := ValorParametro(120);
      SoapSisbov.UserName:= Descriptografar(ValorParametro(121));
      SoapSisbov.Password:= Descriptografar(ValorParametro(122));
      SoapSisbov.MaxSinglePostSize := $1000000;
      try
        XMLDoc.SaveToFile(NomeArquivoENV);
      except
        Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [NomeArquivoENV]);
        Result := -2290;
      end;

      SoapSisbov.Execute(XMLDoc.XML.Text, RetornoXMLSisbov);
    finally
      XMLDoc := Nil;

      XMLDocRetorno := LoadXMLData(RetornoXMLSisbov.DataString);
      try
        XMLDocRetorno.SaveToFile(NomeArquivoRET);
      except
        Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [NomeArquivoRET]);
        Result := -2290;
      end;

      INodeRetorno := XMLDocRetorno.DocumentElement.ChildNodes.First.ChildNodes.First.ChildNodes.First;
      RetornoSisbov.ambiente := INodeRetorno.ChildNodes['ambiente'].Text;
      RetornoSisbov.erroBanco := INodeRetorno.ChildNodes['erroBanco'].Text;
      RetornoSisbov.idTransacao := StrToInt64(INodeRetorno.ChildNodes['idTransacao'].Text);
      RetornoSisbov.numeroSolicitacao := StrToInt64(INodeRetorno.ChildNodes['numeroSolicitacao'].Text);
      RetornoSisbov.status := StrToInt(INodeRetorno.ChildNodes['status'].Text);
      RetornoSisbov.trace := INodeRetorno.ChildNodes['trace'].Text;

      XMLDocRetorno := Nil;
      Result := RetornoSisbov.numeroSolicitacao;
    end;
  except
    Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [SoapSisbov.URL]);
    Result := -2290;
  end;

  If (Result < 1) then begin
    Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['']);
    Result := -2290;
    Exit;
  end;

end;

function TIntOrdensServico.TempCancelarSolicitacaoNumeracao(
  NumeroSisbov: WideString; idPropriedade: Integer;
  cnpjProdutor, cpfProdutor: WideString; idMotivoCancelamento: Integer): Integer;
const
  NomeMetodo: String  = 'cancelarSolicitarNumeracaoReimpressao';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSisbov: RetornoCancelarSolicitacaoNumeracao;
  Index: Integer;
  Num_Sisbov: TStringList;
  CodigosSisbov: ArrayOf_xsd_string;
begin
  Result := -1;
  RetornoSisbov   := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  //if not Conexao.PodeExecutarMetodo(657) then
  //begin
  //  Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
  //  Result := -188;
  //  Exit;
  //end;

  SoapSisbov := TIntSoapSisbov.Create;
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado := SoapSisbov.Conectado('Solicitação numeração reimpressão');

    if not Conectado then begin
      Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, ['não foi possível transmitir a solicitação de numeração']);
      Result := -2289;
      Exit;
    end;

    Num_Sisbov := TStringList.Create;
    try
      Num_Sisbov.DelimitedText := NumeroSisbov;
      SetLength(CodigosSisbov, Num_Sisbov.Count);
      for Index := 0 to Num_Sisbov.Count -1 do begin
        CodigosSisbov[Index] := Num_Sisbov[Index];
      end;
    finally
      Num_Sisbov.Free;
      Num_Sisbov := Nil;
    end;
    RetornoSisbov := SoapSisbov.cancelarSolicitacaoNumeracao(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , 0
                       , CodigosSisbov
                       , idPropriedade
                       , cnpjProdutor
                       , cpfProdutor
                       , idMotivoCancelamento);

  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['cancelarSolicitacaoNumeracao']);
      Result := -2290;
    end;
  end;

  If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then begin
    Result := RetornoSisbov.status;
  end else begin
    Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [RetornoSisbov.listaErros[0].menssagemErro]);
    Result := -2290;
    Exit;
  end;
end;
//-------------------------------------------------------------------------------------------------------------
//Solicitar Reimpressão Druzo 26-07-2010
//-------------------------------------------------------------------------------------------------------------
function TIntOrdensServico.SolicitarNumeracaoReimpressao(CodFabricanteIdentificador: integer;
  const CodManejo, TipoIdentificacao: WideString): Integer;
const
  NomeMetodo: string = 'SolicitarNumeracaoReimpressao';
var
  Index: Integer;
  XMLDoc: TXMLDocument;
  XMLDocRetorno: IXMLDocument;
  INodeEnvelope, INodeBody, INodeReimpressao, INodeUsuario, INodeSenha, INodeCnpjFabrica, INodeCpfProdutor, INodeCnpjProdutor,
    INodeIdPropriedade, INodeQtde, INodeNumeros, INodeNumeroSisbov, INodeTipoIdent: IXMLNode;
  INodeRetorno: IXMLNode;
  SoapSisbov: THttpReqResp;
  Conectado: boolean;
  TiposIdentificacoes, NumerosSisbov: TStringList;
  //IdentSisbov: TStringList;
  RetornoXMLSisbov: TStringStream;
  RetornoSisbov: RetornoSolicitacaoNumeracaoReimpressao;
  NomeArquivoENV: string;
  teste: string;
  NomeArquivoRET: string;
  q, qi: THerdomQuery;
  CodIdPropriedadeSISBOV, CodPropriedadeRural: integer;
  CPF_CNPJ_PRODUTOR, CNPJFabrica, cpfProdutor, cnpjProdutor: string;
  CodSolicitacaoReimpressao: integer;
  Qtd: Integer;
  VTipoIdentificacao:string;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;
  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(297) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then
  begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;
  q := THerdomQuery.Create(conexao, nil);
  qi := THerdomQuery.Create(conexao, nil);

  try
    NumerosSisbov := TStringList.Create;
    TiposIdentificacoes := TStringList.Create;

    Assert(Assigned(NumerosSisbov));
    NumerosSisbov.Clear;
    NumerosSisbov.Delimiter := ',';
    NumerosSisbov.DelimitedText := CodManejo;

    Assert(Assigned(TiposIdentificacoes));
    TiposIdentificacoes.Clear;
    TiposIdentificacoes.Delimiter := ',';
    TiposIdentificacoes.DelimitedText := TipoIdentificacao;

    //NumerosSisbov        :=  SplitString(CodManejo,',');
    //TiposIdentificacoes  :=  SplitString(TipoIdentificacao,',');
    Qtd := NumerosSisbov.Count;

    if Qtd <= 0 then
    begin
      Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Não foi selecionado nenhum animal para reimpressão!']);
      Result := -CERRO_GERAL;
      exit;
    end;

    //Descobrindo o CNPJ do Fabricante------------------------------------------
    q.sql.text := 'SELECT A.NUM_CNPJ_FABRICANTE ' +
                  ' FROM TAB_FABRICANTE_IDENTIFICADOR A ' +
                  ' WHERE A.COD_FABRICANTE_IDENTIFICADOR = :COD_FABRICANTE_IDENTIFICADOR';

    q.ParamByName('COD_FABRICANTE_IDENTIFICADOR').AsInteger := CodFabricanteIdentificador;
    q.Open;

    if q.IsEmpty then
    begin
      Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Código de fabricante de identificador não encontrado']);
      Result := -CERRO_GERAL;
      exit;
    end;

    CNPJFabrica := q.fieldbyname('NUM_CNPJ_FABRICANTE').AsString;
    q.Close;
    //Fim Descobrindo o CNPJ do Fabricante--------------------------------------

    //Descobrindo dados da propriedade Rural------------------------------------
    q.sql.text := 'SELECT TPR.COD_ID_PROPRIEDADE_SISBOV, TP.NUM_CNPJ_CPF,TPR.COD_PROPRIEDADE_RURAL ' +
                  'FROM   TAB_FAZENDA TF, TAB_PROPRIEDADE_RURAL TPR, TAB_PESSOA TP ' +
                  'WHERE  TF.COD_PROPRIEDADE_RURAL = TPR.COD_PROPRIEDADE_RURAL ' +
                  'AND    TP.COD_PESSOA = TF.COD_PESSOA_PRODUTOR ' +
                  'AND    TF.COD_PESSOA_PRODUTOR = :COD_PESSOA_PRODUTOR ' +
                  'AND    TF.COD_FAZENDA = :COD_FAZENDA';

    q.ParamByName('COD_PESSOA_PRODUTOR').AsInteger := Conexao.CodProdutorTrabalho;
    q.ParamByName('COD_FAZENDA').AsInteger := conexao.CodFazendaTrabalho;
    q.Open;

    if q.IsEmpty then
    begin
      Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao resgatar dados da propriedade rural']);
      Result := -CERRO_GERAL;
      exit;
    end;
    CodIdPropriedadeSISBOV  := q.fieldbyname('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
    CPF_CNPJ_PRODUTOR       := q.fieldbyname('NUM_CNPJ_CPF').AsString;
    CodPropriedadeRural     := q.fieldbyname('COD_PROPRIEDADE_RURAL').AsInteger;

    cnpjProdutor  := '';
    cpfProdutor   := '';
    if length(CPF_CNPJ_PRODUTOR) > 11 then
      cnpjProdutor := CPF_CNPJ_PRODUTOR
    else
      cpfProdutor := CPF_CNPJ_PRODUTOR;

    q.Close;
    //Fim Descobrindo dados da propriedade Rural--------------------------------

    //Setando caminho para salvar os arquivos de requisição e resposta----------
    NomeArquivoENV := ValorParametro(16) + '\' +
      FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
      FormatDateTime('mm', Conexao.DtaSistema) + '\' +
      FormatDateTime('dd', Conexao.DtaSistema) + '\' +
      Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_ENV_' + NomeMetodo + '.xml';

    NomeArquivoRET := ValorParametro(16) + '\' +
      FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
      FormatDateTime('mm', Conexao.DtaSistema) + '\' +
      FormatDateTime('dd', Conexao.DtaSistema) + '\' +
      Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_RET_' + NomeMetodo + '.xml';
    //Fim Setando caminho para salvar os arquivos de requisição e resposta------

    //Montando o XML de envio---------------------------------------------------
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.Active := true;
      XMLDoc.Version := '1.0';

      INodeEnvelope := XMLDoc.AddChild('SOAP-ENV:Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
      INodeEnvelope.Attributes['xmlns:xsd'] := 'http://www.w3.org/2001/XMLSchema';
      INodeEnvelope.Attributes['xmlns:xsi'] := 'http://www.w3.org/2001/XMLSchema-instance';

      INodeBody := INodeEnvelope.AddChild('SOAP-ENV:Body');
      INodeReimpressao := INodeBody.AddChild('solicitarNumeracaoReimpressao', 'http://servicosWeb.sisbov.mapa.gov.br');
      INodeUsuario := INodeReimpressao.AddChild('usuario');
      INodeUsuario.Text := Descriptografar(ValorParametro(118));
      INodeSenha := INodeReimpressao.AddChild('senha');
      INodeSenha.Text := Descriptografar(ValorParametro(119));
      INodeCnpjFabrica := INodeReimpressao.AddChild('cnpjFabrica');
      INodeCnpjFabrica.Text := cnpjFabrica;
      INodeCpfProdutor := INodeReimpressao.AddChild('cpfProdutor');
      INodeCpfProdutor.Text := cpfProdutor;
      INodeCnpjProdutor := INodeReimpressao.AddChild('cnpjProdutor');
      INodeCnpjProdutor.Text := cnpjProdutor;
      INodeIdPropriedade := INodeReimpressao.AddChild('idPropriedade');
      INodeIdPropriedade.Text := IntToStr(CodIdPropriedadeSISBOV);
      INodeQtde := INodeReimpressao.AddChild('qtd');
      INodeQtde.Text := IntToStr(qtd);

      //Consulta que devolve o numero do SISBOV completo------------------------
      q.sql.text := 'SELECT   CAST (TA.COD_PAIS_SISBOV AS VARCHAR (3)) ' +
                    '       + RIGHT (''00'' + CAST (TA.COD_ESTADO_SISBOV AS VARCHAR (2)), 2) ' +
                    '       + CASE TA.COD_MICRO_REGIAO_SISBOV ' +
                    '            WHEN 0 ' +
                    '               THEN ''00'' ' +
                    '            WHEN -1 ' +
                    '               THEN '''' ' +
                    '            ELSE RIGHT (  ''00'' ' +
                    '                        + CONVERT (VARCHAR (2), TA.COD_MICRO_REGIAO_SISBOV), ' +
                    '                        2 ' +
                    '                       ) ' +
                    '         END ' +
                    '       + RIGHT (''000000000'' + CONVERT (VARCHAR (9), TA.COD_ANIMAL_SISBOV), 9) ' +
                    '       + CONVERT (VARCHAR (1), TA.NUM_DV_SISBOV) AS COD_ANIMAL_SISBOV ' +
                    'FROM   TAB_ANIMAL TA ' +
                    'WHERE  TA.COD_ANIMAL_MANEJO = :COD_ANIMAL_MANEJO ' +
                    'AND    TA.COD_PESSOA_PRODUTOR = :COD_PESSOA_PRODUTOR ' +
                    'AND    TA.DTA_FIM_VALIDADE IS NULL ';

      q.ParamByName('COD_PESSOA_PRODUTOR').AsInteger := Conexao.CodProdutorTrabalho;
      q.ParamByName('COD_ANIMAL_MANEJO').AsString := '-1';
      q.Open;
      qtd := 0;
      for Index := 0 to NumerosSisbov.Count - 1 do
      begin
        q.ParamByName('COD_ANIMAL_MANEJO').AsString := NumerosSisbov[Index];
        q.Refresh;
        if not q.IsEmpty then
        begin
          INodeNumeros := INodeReimpressao.AddChild('numero');
          INodeNumeroSisbov := INodeNumeros.AddChild('numeroSisbov', 'http://model.sisbov.mapa.gov.br');
          INodeNumeroSisbov.Text := q.fieldbyname('COD_ANIMAL_SISBOV').AsString;
          INodeTipoIdent := INodeNumeros.AddChild('tipoIdentificacao');
          if TiposIdentificacoes[Index] = '1' then
            //brinco
            INodeTipoIdent.Text := '10'
          else if TiposIdentificacoes[Index]='9' then
            //bottom
            INodeTipoIdent.Text := '11';
          qtd := qtd + 1;
        end;
      end;
      INodeQtde.Text := inttostr(qtd);
      q.Close;
    //Fim Montando o XML de envio-----------------------------------------------
      SoapSisbov := THTTPReqResp.Create(nil);
      RetornoXMLSisbov := TStringStream.Create('');
      RetornoSisbov := RetornoSolicitacaoNumeracaoReimpressao.Create;
      try
        try
          try

            SoapSisbov.URL := ValorParametro(117);
            SoapSisbov.Proxy := ValorParametro(120);
            SoapSisbov.UserName := Descriptografar(ValorParametro(121));
            SoapSisbov.Password := Descriptografar(ValorParametro(122));
            SoapSisbov.MaxSinglePostSize := $1000000;
            if not ForceDirectories(ExtractFileDir(NomeArquivoENV)) then
            begin
              Mensagens.Adicionar(1079, Self.ClassName, NomeMetodo, [ExtractFileDir(NomeArquivoENV)]);
              Exit;
            end;
            try
              XMLDoc.SaveToFile(NomeArquivoENV);
            except
              Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [NomeArquivoENV]);
              Result := -2290;
            end;
            SoapSisbov.Execute(XMLDoc.XML.Text, RetornoXMLSisbov);
          finally
            XMLDoc := nil;
          end;
          XMLDocRetorno := LoadXMLData(RetornoXMLSisbov.DataString);
          try
            XMLDocRetorno.SaveToFile(NomeArquivoRET);
          except
            Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [NomeArquivoRET]);
            Result := -2290;
          end;
          INodeRetorno := XMLDocRetorno.DocumentElement.ChildNodes.First.ChildNodes.First.ChildNodes.First;
          RetornoSisbov.ambiente := INodeRetorno.ChildNodes['ambiente'].Text;
          RetornoSisbov.erroBanco := INodeRetorno.ChildNodes['erroBanco'].Text;
          RetornoSisbov.idTransacao := StrToInt64(INodeRetorno.ChildNodes['idTransacao'].Text);
          RetornoSisbov.numeroSolicitacao := StrToInt64(INodeRetorno.ChildNodes['numeroSolicitacao'].Text);
          RetornoSisbov.status := StrToInt(INodeRetorno.ChildNodes['status'].Text);
          RetornoSisbov.trace := INodeRetorno.ChildNodes['trace'].Text;

          if RetornoSISBOV.status = 0 then
          begin
            Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao solicitar reimpressão de brincos no SISBOV']);
            Result := -CERRO_GERAL;
            exit;
          end;
          try
            //pegando o próximo código para a solicitacao de reimpressao
            q.sql.text := 'SELECT ISNULL(MAX(COD_SOLICITACAO_REIMPRESSAO),0)+1 as COD_SOLICITACAO_REIMPRESSAO ' +
                          'FROM TAB_SOLICITACAO_REIMPRESSAO';
            q.Open;
            CodSolicitacaoReimpressao := q.FieldByName('COD_SOLICITACAO_REIMPRESSAO').AsInteger;
            q.Close;
            //Montando Query para insersao de da solicitação
            qi.sql.text := 'INSERT INTO TAB_SOLICITACAO_REIMPRESSAO(COD_SOLICITACAO_REIMPRESSAO, ' +
                           ' COD_SOLICITACAO_SISBOV, COD_FABRICANTE_IDENTIFICADOR,' +
                           ' COD_PROPRIEDADE_RURAL) ' +
                           ' VALUES (:COD_SOLICITACAO_REIMPRESSAO, :COD_SOLICITACAO_SISBOV, ' +
                           '         :COD_FABRICANTE_IDENTIFICADOR,:COD_PROPRIEDADE_RURAL)';

            qi.ParamByName('COD_SOLICITACAO_REIMPRESSAO').AsInteger := CodSolicitacaoReimpressao;
            qi.ParamByName('COD_SOLICITACAO_SISBOV').AsInteger := RetornoSisbov.numeroSolicitacao;
            qi.ParamByName('COD_FABRICANTE_IDENTIFICADOR').AsInteger := CodFabricanteIdentificador;
            qi.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger := CodPropriedadeRural;

            Begintran;
            qi.ExecSQL();

            qi.sql.text := 'INSERT INTO TAB_ANIMAL_SOLICITACAO_REIMPRESSAO (COD_SOLICITACAO_REIMPRESSAO, ' +
              'COD_PESSOA_PRODUTOR, ' +
              'COD_ANIMAL, ' +
              'COD_TIPO_IDENTIFICADOR) ' +
              'VALUES(:COD_SOLICITACAO_REIMPRESSAO, ' +
              ':COD_PESSOA_PRODUTOR, ' +
              ':COD_ANIMAL, ' +
              ':COD_TIPO_IDENTIFICADOR) ';


            q.sql.text := 'SELECT   COD_ANIMAL ' +
              'FROM   TAB_ANIMAL TA ' +
              'WHERE  TA.COD_ANIMAL_MANEJO = :COD_ANIMAL_MANEJO ' +
              'AND    TA.COD_PESSOA_PRODUTOR = :COD_PESSOA_PRODUTOR ' +
              'AND    TA.DTA_FIM_VALIDADE IS NULL ';
            q.ParamByName('COD_PESSOA_PRODUTOR').AsInteger := Conexao.CodProdutorTrabalho;
            q.ParamByName('COD_ANIMAL_MANEJO').AsString := '-1';
            q.Open;

            qi.ParamByName('COD_SOLICITACAO_REIMPRESSAO').AsInteger := CodSolicitacaoReimpressao;
            qi.ParamByName('COD_PESSOA_PRODUTOR').AsInteger := Conexao.CodProdutorTrabalho;

            for Index := 0 to NumerosSisbov.Count - 1 do
            begin
              q.ParamByName('COD_ANIMAL_MANEJO').AsString := NumerosSisbov[Index];
              q.Refresh;
              if not q.IsEmpty then
              begin
                qi.ParamByName('COD_ANIMAL').AsInteger := q.fieldbyname('COD_ANIMAL').AsInteger;
                qi.ParamByName('COD_TIPO_IDENTIFICADOR').AsInteger := strtoint(TiposIdentificacoes[Index]);
                qi.ExecSQL();
              end;
            end;
            commit;
          except
            on e: exception do
            begin
              Rollback;
              Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao cadastrar solicitação de reimpressão - ' + e.Message]);
              Result := -CERRO_GERAL;
              exit;
            end;
          end;
          XMLDocRetorno := nil;
          Result := RetornoSisbov.numeroSolicitacao;
          Mensagens.Adicionar(10263,self.ClassName,NomeMetodo,[Result]);
        except
          Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [SoapSisbov.URL]);
          Result := -2290;
        end;
      finally
        RetornoSisbov.Free;
        RetornoXMLSisbov.Free;
        SoapSisbov.Free;
      end;
    finally
      XMLDoc  :=  nil;
    end;
  finally
    q.Free;
    qi.Free;
    NumerosSisbov.Free;
    TiposIdentificacoes.Free;
  end;
end;

end.

