unit uOrdensServico;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl, uOrdemServico, uIntOrdensServico,
  WsSISBOV1, uConexao, uIntMensagens, uOrdemServicoResumida, uEndereco, uIntEnderecos;

type
  TOrdensServico = class(TAutoObject, IOrdensServico)
    FInicializado: Boolean;
    FOrdemServico: TOrdemServico;
    FIntOrdensServico: TIntOrdensServico;
    FIntEnderecos: TIntEnderecos;
    FOrdemServicoResumida: TOrdemServicoResumida;
    FConexaoBD: TConexao;
    FMensagens: TIntMensagens;
  protected
    function Buscar(CodOrdemServico: Integer): Integer; safecall;
    function OrdemServico: IOrdemServico; safecall;
    function BuscarResumido(CodOrdemServico: Integer): Integer; safecall;
    function OrdemServicoResumida: IOrdemServicoResumida; safecall;
    function PesquisarHistoricoSituacao(CodOrdemServico: Integer): Integer;
      safecall;
    function ObterProximoNumero: Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure Posicionar(NumDeslocamento: Integer); safecall;
    function ValorCampo(const NomCampo: WideString): WideString; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Alterar(CodOrdemServico, NumOrdemServico, QtdAnimais,
      CodPessoaTecnico, CodPessoaVendedor: Integer;
      const NumCNPJCPFVendedor: WideString; CodFormaPagamentoOS,
      CodIdentificacaoDupla, CodFabricanteIdentificador,
      CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
      CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
      QtdProdutoAcessorio3: Integer; const TxtObservacaoPedido,
      TxtObservacao, IndAnimaisRegistrados: WideString): Integer; safecall;
    function Inserir(NumOrdemServico, CodPessoaProdutor: Integer;
      const SglProdutor, NumCNPJCPFProdutor: WideString;
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      QtdAnimais: Integer;
      const IndEnviaPedidoIdentificador: WideString): Integer; safecall;
    function Pesquisar(NumOrdemServico: Integer; const SglProdutor,
      NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal: WideString;
      CodLocalizacaoSisbov: Integer; const NomPropriedadeRural,
      NumCPNJCPFTecnico, NumCNPJCPFVendedor: WideString; QtdAnimaisInicio,
      QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
      const IndApenasSemEnderecoEntregaCert: WideString;
      CodIdentificacaoDupla, CodFabricanteIdentificador: Integer;
      const IndEnviaPedidoIdentificador, IndApenasSemEnderecoEntregaIdent,
      IndapenasSemEnderecoCobrancaIdent: WideString; NumPedidoFabricante,
      NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
      DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
      CodSituacaoOS, CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, CodSituacaoSISBOVSimInicio,
      CodSituacaoSISBOVNao: Integer; DtaSituacaoSISBOVSimInicio,
      DtaSituacaoSISBOVSimFim: TDateTime; NumDiasBoletoAVencer,
      NumDiasBoletoEmAtraso, NumDiasBoletoPago, CodSituacaoBoleto: Integer;
      const CodOrdenacao, IndOrdenacaoCrescente: WideString): Integer;
      safecall;
    function DefinirEnderecoEntregaCert2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer; safecall;
    function DefinirEnderecoEntregaCert1(CodOrdemServico,
      CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone,
      NumFax, TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString;
      CodDistrito, CodMunicipio: Integer; const NomLocalidade: WideString;
      CodEstado: Integer): Integer; safecall;
    function DefinirEnderecoCobrancaIdent2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer; safecall;
    function DefinirEnderecoCobrancaIdent1(CodOrdemServico,
      CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone,
      NumFax, TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString;
      CodDistrito, CodMunicipio: Integer; const NomLocalidade: WideString;
      CodEstado: Integer): Integer; safecall;
    function DefinirEnderecoEntregaIdent2(CodOrdemServico, CodEndereco,
      CodPessoa: Integer): Integer; safecall;
    function DefinirEnderecoEntregaIdent1(CodOrdemServico,
      CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone,
      NumFax, TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString;
      CodDistrito, CodMunicipio: Integer; const NomLocalidade: WideString;
      CodEstado: Integer): Integer; safecall;
    function MudarSituacao(CodOrdemServico, CodSituacaoOS: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function DefinirCodigoSISBOVInicio(CodOrdemServico, CodPaisSISBOVInicio,
      CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio: Integer): Integer;
      safecall;
    function MudarEnviaPedidoIdentificador(CodOrdemServico: Integer;
      const IndEnviaPedidoIdentificador: WideString): Integer; safecall;
    function PesquisarSituacaoCodigosSISBOV(CodOrdemServico: Integer;
      const IndMostrarDataMudancaSituacao: WideString): Integer; safecall;
    function PesquisarDataLiberacaoAbate(CodOrdemServico: Integer): Integer;
      safecall;
    function GerarRelatorioFichaOS(CodOrdemServico,
      TipoArquivo: Integer): WideString; safecall;
    function Get_IndAcessoCodigoSISBOVInicio: WideString; safecall;
    function Get_IndAcessoEnderecoCobrancaIdent: WideString; safecall;
    function Get_IndAcessoEnderecoEntregaCert: WideString; safecall;
    function Get_IndAcessoEnderecoEntregaIdent: WideString; safecall;
    function Get_IndAcessoIndEnviaPedidoIdent: WideString; safecall;
    function Get_IndAcessoFabricanteIdentificador: WideString; safecall;
    function Get_IndAcessoFormaPagamentoIdent: WideString; safecall;
    function Get_IndAcessoFormaPagamentoOS: WideString; safecall;
    function Get_IndAcessoIdentificacaoDupla: WideString; safecall;
    function Get_IndAcessoNumOrdemServico: WideString; safecall;
    function Get_IndAcessoPessoaTecnico: WideString; safecall;
    function Get_IndAcessoPessoaVendedor: WideString; safecall;
    function Get_IndAcessoCodProdutoAcessorio1: WideString; safecall;
    function Get_IndAcessoCodProdutoAcessorio2: WideString; safecall;
    function Get_IndAcessoCodProdutoAcessorio3: WideString; safecall;
    function Get_IndAcessoQtdAnimais: WideString; safecall;
    function Get_IndAcessoQtdProdutoAcessorio1: WideString; safecall;
    function Get_IndAcessoQtdProdutoAcessorio2: WideString; safecall;
    function Get_IndAcessoQtdProdutoAcessorio3: WideString; safecall;
    function BuscarAcessoAtributos(CodOrdemServico: Integer): Integer;
      safecall;
    function GerarRelatorio(NumOrdemServico: Integer; const SglProdutor,
      NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal: WideString;
      CodLocalizacaoSisbov: Integer; const NomPropriedadeRural,
      numCNPJCPFTecnico, NumCNPJCPFVendedor: WideString; QtdAnimaisInicio,
      QtdAnimaisFim, NumSolicitacaoSISBOV: Integer;
      const IndApenasSemEnderecoEntregaCert: WideString;
      CodIdentificacaoDupla, CodFabricanteIdentificador: Integer;
      const IndEnviaPedidoIdent, IndApenasSemEnderecoEntregaIdent,
      IndapenasSemEnderecoCobrancaIdent: WideString; NumPedidoFabricante,
      NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
      DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
      CodSituacaoOS, CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
      DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
      NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
      CodSituacaoBoleto: Integer; const CodOrdenacao,
      IndOrdenacaoCrescente: WideString; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function LimparCodigoSISBOVInicio(CodOrdemServico: Integer): Integer;
      safecall;
    function Get_IndAcessoObservacaoPedido: WideString; safecall;
    function Get_IndAcessoAnimaisRegistrados: WideString; safecall;
    function PesquisarSituacoesFichas(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function AlterarEnvioIdentOS(CodOrdemServico: Integer;
      DtaEnvioIdent: TDateTime; const NomServicoEnvio,
      NroConhecimento: WideString): Integer; safecall;
    function IncluirSolicitacaoNumeracao(CodOrdemServico: Integer): Integer; safecall;
    function IncluirSolicitacaoNumeracaoReimpressao(CodOrdemServico: Integer): Integer; safecall;
    function DefinirNumeroSolicitacao(CodOrdemServico,
      NumeroSolicitacao: Integer; DataSolicitacao: TDateTime): Integer;
      safecall;
    function TempCancelarSolicitacaoNumeracao(const NumeroSisbov: WideString;
      IdPropriedade: Integer; const CnpjProdutor, CpfProdutor: WideString; IdMotivoCancelamento: Integer): Integer; safecall;
    function TempSolicitarNumeracaoReimpressao(const cnpjFabrica, cpfProdutor,
      cnpjProdutor: WideString; idPropriedade, qtd: Integer;
      const numero_sisbov, tipo_identificacao: WideString): Integer;
      safecall;
    function TempConsultarNumeracaoReimpressao(
      NumeroSolicitacao: Integer): WideString; safecall;
    function SolicitarNumeracaoReimpressao(CodFabricanteIdentificador: Integer;
      const CodManejo, TipoIdentificacao: WideString): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntOrdemServico, uIntClassesBasicas,
  uIntOrdemServicoResumida, MaskUtils;

procedure TOrdensServico.AfterConstruction;
begin
  inherited;

  FOrdemServico := TOrdemServico.Create;
  FOrdemServico.EnderecoEntregaCert := TEndereco.Create;
  FOrdemServico.EnderecoEntregaIdent := TEndereco.Create;
  FOrdemServico.EnderecoCobrancaIdent := TEndereco.Create;
  FOrdemServico.ObjAddRef;
  FOrdemServicoResumida := TOrdemServicoResumida.Create;
  FOrdemServicoResumida.ObjAddRef;
  FInicializado := False;
end;

procedure TOrdensServico.BeforeDestruction;
begin
  If FIntOrdensServico <> nil Then Begin
    FIntOrdensServico.Free;
  End;
  If FOrdemServico <> nil Then Begin
    FOrdemServico.ObjRelease;
    FOrdemServico := nil;
    FOrdemServicoResumida.ObjRelease;
    FOrdemServicoResumida := nil;
  End;
  inherited;
end;

function TOrdensServico.Buscar(CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.Buscar(CodOrdemServico);

  FOrdemServico.CodOrdemServico             := FIntOrdensServico.OrdemServico.CodOrdemServico;
  FOrdemServico.NumOrdemServico             := FIntOrdensServico.OrdemServico.NumOrdemServico;
  FOrdemServico.CodPessoaProdutor           := FIntOrdensServico.OrdemServico.CodPessoaProdutor;
  FOrdemServico.SglProdutor                 := FIntOrdensServico.OrdemServico.SglProdutor;
  FOrdemServico.NomProdutor                 := FIntOrdensServico.OrdemServico.NomProdutor;
  FOrdemServico.NumCNPJCPFProdutor          := FIntOrdensServico.OrdemServico.NumCNPJCPFProdutor;
  FOrdemServico.NumCNPJCPFProdutorFormatado := FIntOrdensServico.OrdemServico.NumCNPJCPFProdutorFormatado;
  FOrdemServico.CodPropriedadeRural         := FIntOrdensServico.OrdemServico.CodPropriedadeRural;
  FOrdemServico.NomPropriedadeRural         := FIntOrdensServico.OrdemServico.NomPropriedadeRural;
  FOrdemServico.NumImovelReceitaFederal     := FIntOrdensServico.OrdemServico.NumImovelReceitaFederal;
  FOrdemServico.CodPessoaTecnico            := FIntOrdensServico.OrdemServico.CodPessoaTecnico;
  FOrdemServico.NomTecnico                  := FIntOrdensServico.OrdemServico.NomTecnico;
  FOrdemServico.NumCNPJCPFTecnico           := FIntOrdensServico.OrdemServico.NumCNPJCPFTecnico;
  FOrdemServico.NumCNPJCPFTecnicoFormatado  := FIntOrdensServico.OrdemServico.NumCNPJCPFTecnicoFormatado;
  FOrdemServico.CodPessoaVendedor           := FIntOrdensServico.OrdemServico.CodPessoaVendedor;
  FOrdemServico.NomVendedor                 := FIntOrdensServico.OrdemServico.NomVendedor;
  FOrdemServico.NumCNPJCPFVendedor          := FIntOrdensServico.OrdemServico.NumCNPJCPFVendedor;
  FOrdemServico.NumCNPJCPFVendedorFormatado := FIntOrdensServico.OrdemServico.NumCNPJCPFVendedorFormatado;
  FOrdemServico.QtdAnimais                  := FIntOrdensServico.OrdemServico.QtdAnimais;
  FOrdemServico.NumSolicitacaoSISBOV        := FIntOrdensServico.OrdemServico.NumSolicitacaoSISBOV;
  FOrdemServico.CodPaisSISBOVInicial        := FIntOrdensServico.OrdemServico.CodPaisSISBOVInicial;
  FOrdemServico.CodEstadoSISBOVInicial      := FIntOrdensServico.OrdemServico.CodEstadoSISBOVInicial;
  FOrdemServico.CodMicroRegiaoSISBOVInicial := FIntOrdensServico.OrdemServico.CodMicroRegiaoSISBOVInicial;
  FOrdemServico.CodAnimalSISBOVInicial      := FIntOrdensServico.OrdemServico.CodAnimalSISBOVInicial;
  FOrdemServico.NumDVSISBOVInicial          := FIntOrdensServico.OrdemServico.NumDVSISBOVInicial;
  FOrdemServico.CodFormaPagamentoOS         := FIntOrdensServico.OrdemServico.CodFormaPagamentoOS;
  FOrdemServico.DesFormaPagamentoOS         := FIntOrdensServico.OrdemServico.DesFormaPagamentoOS;

  FOrdemServico.EnderecoEntregaCert.CodEndereco      := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodEndereco;
  FOrdemServico.EnderecoEntregaCert.CodTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodTipoEndereco;
  FOrdemServico.EnderecoEntregaCert.SglTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.SglTipoEndereco;
  FOrdemServico.EnderecoEntregaCert.DesTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.DesTipoEndereco;
  FOrdemServico.EnderecoEntregaCert.NomPessoaContato := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomPessoaContato;
  FOrdemServico.EnderecoEntregaCert.NumTelefone      := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NumTelefone;
  FOrdemServico.EnderecoEntregaCert.NumFax           := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NumFax;
  FOrdemServico.EnderecoEntregaCert.TxtEmail         := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.TxtEmail;
  FOrdemServico.EnderecoEntregaCert.NomLogradouro    := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomLogradouro;
  FOrdemServico.EnderecoEntregaCert.NomBairro        := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomBairro;
  FOrdemServico.EnderecoEntregaCert.NumCEP           := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NumCEP;
  FOrdemServico.EnderecoEntregaCert.CodDistrito      := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodDistrito;
  FOrdemServico.EnderecoEntregaCert.NomDistrito      := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomDistrito;
  FOrdemServico.EnderecoEntregaCert.CodMunicipio     := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodMunicipio;
  FOrdemServico.EnderecoEntregaCert.NumMunicipioIBGE := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NumMunicipioIBGE;
  FOrdemServico.EnderecoEntregaCert.NomMunicipio     := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomMunicipio;
  FOrdemServico.EnderecoEntregaCert.CodEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodEstado;
  FOrdemServico.EnderecoEntregaCert.SglEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.SglEstado;
  FOrdemServico.EnderecoEntregaCert.NomEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomEstado;
  FOrdemServico.EnderecoEntregaCert.CodPais          := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.CodPais;
  FOrdemServico.EnderecoEntregaCert.NomPais          := FIntOrdensServico.OrdemServico.EnderecoEntregaCert.NomPais;

  FOrdemServico.CodIdentificacaoDupla       := FIntOrdensServico.OrdemServico.CodIdentificacaoDupla;
  FOrdemServico.SglIdentificacaoDupla       := FIntOrdensServico.OrdemServico.SglIdentificacaoDupla;
  FOrdemServico.DesIdentificacaoDupla       := FIntOrdensServico.OrdemServico.DesIdentificacaoDupla;
  FOrdemServico.CodFabricanteIdentificador  := FIntOrdensServico.OrdemServico.CodFabricanteIdentificador;
  FOrdemServico.NomReduzidoFabricante       := FIntOrdensServico.OrdemServico.NomReduzidoFabricante;
  FOrdemServico.CodformaPagamentoIdent      := FIntOrdensServico.OrdemServico.CodformaPagamentoIdent;
  FOrdemServico.DesFormaPagamentoIdent      := FIntOrdensServico.OrdemServico.DesFormaPagamentoIdent;

  FOrdemServico.EnderecoEntregaIdent.CodEndereco      := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodEndereco;
  FOrdemServico.EnderecoEntregaIdent.CodTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodTipoEndereco;
  FOrdemServico.EnderecoEntregaIdent.SglTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.SglTipoEndereco;
  FOrdemServico.EnderecoEntregaIdent.DesTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.DesTipoEndereco;
  FOrdemServico.EnderecoEntregaIdent.NomPessoaContato := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomPessoaContato;
  FOrdemServico.EnderecoEntregaIdent.NumTelefone      := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NumTelefone;
  FOrdemServico.EnderecoEntregaIdent.NumFax           := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NumFax;
  FOrdemServico.EnderecoEntregaIdent.TxtEmail         := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.TxtEmail;
  FOrdemServico.EnderecoEntregaIdent.NomLogradouro    := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomLogradouro;
  FOrdemServico.EnderecoEntregaIdent.NomBairro        := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomBairro;
  FOrdemServico.EnderecoEntregaIdent.NumCEP           := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NumCEP;
  FOrdemServico.EnderecoEntregaIdent.CodDistrito      := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodDistrito;
  FOrdemServico.EnderecoEntregaIdent.NomDistrito      := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomDistrito;
  FOrdemServico.EnderecoEntregaIdent.CodMunicipio     := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodMunicipio;
  FOrdemServico.EnderecoEntregaIdent.NumMunicipioIBGE := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NumMunicipioIBGE;
  FOrdemServico.EnderecoEntregaIdent.NomMunicipio     := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomMunicipio;
  FOrdemServico.EnderecoEntregaIdent.CodEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodEstado;
  FOrdemServico.EnderecoEntregaIdent.SglEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.SglEstado;
  FOrdemServico.EnderecoEntregaIdent.NomEstado        := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomEstado;
  FOrdemServico.EnderecoEntregaIdent.CodPais          := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.CodPais;
  FOrdemServico.EnderecoEntregaIdent.NomPais          := FIntOrdensServico.OrdemServico.EnderecoEntregaIdent.NomPais;

  FOrdemServico.EnderecoCobrancaIdent.CodEndereco      := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodEndereco;
  FOrdemServico.EnderecoCobrancaIdent.CodTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodTipoEndereco;
  FOrdemServico.EnderecoCobrancaIdent.SglTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.SglTipoEndereco;
  FOrdemServico.EnderecoCobrancaIdent.DesTipoEndereco  := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.DesTipoEndereco;
  FOrdemServico.EnderecoCobrancaIdent.NomPessoaContato := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomPessoaContato;
  FOrdemServico.EnderecoCobrancaIdent.NumTelefone      := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NumTelefone;
  FOrdemServico.EnderecoCobrancaIdent.NumFax           := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NumFax;
  FOrdemServico.EnderecoCobrancaIdent.TxtEmail         := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.TxtEmail;
  FOrdemServico.EnderecoCobrancaIdent.NomLogradouro    := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomLogradouro;
  FOrdemServico.EnderecoCobrancaIdent.NomBairro        := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomBairro;
  FOrdemServico.EnderecoCobrancaIdent.NumCEP           := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NumCEP;
  FOrdemServico.EnderecoCobrancaIdent.CodDistrito      := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodDistrito;
  FOrdemServico.EnderecoCobrancaIdent.NomDistrito      := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomDistrito;
  FOrdemServico.EnderecoCobrancaIdent.CodMunicipio     := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodMunicipio;
  FOrdemServico.EnderecoCobrancaIdent.NumMunicipioIBGE := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NumMunicipioIBGE;
  FOrdemServico.EnderecoCobrancaIdent.NomMunicipio     := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomMunicipio;
  FOrdemServico.EnderecoCobrancaIdent.CodEstado        := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodEstado;
  FOrdemServico.EnderecoCobrancaIdent.SglEstado        := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.SglEstado;
  FOrdemServico.EnderecoCobrancaIdent.NomEstado        := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomEstado;
  FOrdemServico.EnderecoCobrancaIdent.CodPais          := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.CodPais;
  FOrdemServico.EnderecoCobrancaIdent.NomPais          := FIntOrdensServico.OrdemServico.EnderecoCobrancaIdent.NomPais;

  FOrdemServico.CodModeloIdentificador1     := FIntOrdensServico.OrdemServico.CodModeloIdentificador1;
  FOrdemServico.SglModeloIdentificador1     := FIntOrdensServico.OrdemServico.SglModeloIdentificador1;
  FOrdemServico.DesModeloIdentificador1     := FIntOrdensServico.OrdemServico.DesModeloIdentificador1;
  FOrdemServico.CodModeloIdentificador2     := FIntOrdensServico.OrdemServico.CodModeloIdentificador2;
  FOrdemServico.SglModeloIdentificador2     := FIntOrdensServico.OrdemServico.SglModeloIdentificador2;
  FOrdemServico.DesModeloIdentificador2     := FIntOrdensServico.OrdemServico.DesModeloIdentificador2;
  FOrdemServico.CodProdutoAcessorio1        := FIntOrdensServico.OrdemServico.CodProdutoAcessorio1;
  FOrdemServico.SglProdutoAcessorio1        := FIntOrdensServico.OrdemServico.SglProdutoAcessorio1;
  FOrdemServico.DesProdutoAcessorio1        := FIntOrdensServico.OrdemServico.DesProdutoAcessorio1;
  FOrdemServico.QtdProdutoAcessorio1        := FIntOrdensServico.OrdemServico.QtdProdutoAcessorio1;
  FOrdemServico.CodProdutoAcessorio2        := FIntOrdensServico.OrdemServico.CodProdutoAcessorio2;
  FOrdemServico.SglProdutoAcessorio2        := FIntOrdensServico.OrdemServico.SglProdutoAcessorio2;
  FOrdemServico.DesProdutoAcessorio2        := FIntOrdensServico.OrdemServico.DesProdutoAcessorio2;
  FOrdemServico.QtdProdutoAcessorio2        := FIntOrdensServico.OrdemServico.QtdProdutoAcessorio2;
  FOrdemServico.CodProdutoAcessorio3        := FIntOrdensServico.OrdemServico.CodProdutoAcessorio3;
  FOrdemServico.SglProdutoAcessorio3        := FIntOrdensServico.OrdemServico.SglProdutoAcessorio3;
  FOrdemServico.DesProdutoAcessorio3        := FIntOrdensServico.OrdemServico.DesProdutoAcessorio3;
  FOrdemServico.QtdProdutoAcessorio3        := FIntOrdensServico.OrdemServico.QtdProdutoAcessorio3;
  FOrdemServico.NumPedidoFabricante         := FIntOrdensServico.OrdemServico.NumPedidoFabricante;
  FOrdemServico.CodArquivoRemessaPedido     := FIntOrdensServico.OrdemServico.CodArquivoRemessaPedido;
  FOrdemServico.NumRemessa                  := FIntOrdensServico.OrdemServico.NumRemessa;
  FOrdemServico.DtaCadastramento            := FIntOrdensServico.OrdemServico.DtaCadastramento;
  FOrdemServico.CodUsuarioCadastramento     := FIntOrdensServico.OrdemServico.CodUsuarioCadastramento;
  FOrdemServico.NomUsuarioCadastramento     := FIntOrdensServico.OrdemServico.NomUsuarioCadastramento;
  FOrdemServico.DtaUltimaAlteracao          := FIntOrdensServico.OrdemServico.DtaUltimaAlteracao;
  FOrdemServico.CodUsuarioUltimaAlteracao   := FIntOrdensServico.OrdemServico.CodUsuarioUltimaAlteracao;
  FOrdemServico.NomUsuarioUltimaAlteracao   := FIntOrdensServico.OrdemServico.NomUsuarioUltimaAlteracao;
  FOrdemServico.CodSituacaoOS               := FIntOrdensServico.OrdemServico.CodSituacaoOS;
  FOrdemServico.SglSituacaoOS               := FIntOrdensServico.OrdemServico.SglSituacaoOS;
  FOrdemServico.DesSituacaoOS               := FIntOrdensServico.OrdemServico.DesSituacaoOS;
  FOrdemServico.TxtObservacao               := FIntOrdensServico.OrdemServico.TxtObservacao;
  FOrdemServico.IndEnviaPedidoIdentificador := FIntOrdensServico.OrdemServico.IndEnviaPedidoIdentificador;
  FOrdemServico.CodUsuarioPedido            := FIntOrdensServico.OrdemServico.CodUsuarioPedido;
  FOrdemServico.NomUsuarioPedido            := FIntOrdensServico.OrdemServico.NomUsuarioPedido;
  FOrdemServico.DtaPedido                   := FIntOrdensServico.OrdemServico.DtaPedido;
  FOrdemServico.TxtObservacaoPedido         := FIntOrdensServico.OrdemServico.TxtObservacaoPedido;
  FOrdemServico.IndAnimaisRegistrados       := FIntOrdensServico.OrdemServico.IndAnimaisRegistrados;
  FOrdemServico.DtaEnvio                    := FIntOrdensServico.OrdemServico.DtaEnvio;
  FOrdemServico.NomServicoEnvio             := FIntOrdensServico.OrdemServico.NomServicoEnvio;
  FOrdemServico.NumConhecimento             := FIntOrdensServico.OrdemServico.NumConhecimento;
  FOrdemServico.CodLocalizacaoSisbov        := FIntOrdensServico.OrdemServico.CodLocalizacaoSisbov;
  FOrdemServico.CodBoleto                   := FIntOrdensServico.OrdemServico.CodBoleto;
end;

function TOrdensServico.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FConexaoBD := ConexaoBD;
  FMensagens := Mensagens;
  FIntOrdensServico := TIntOrdensServico.Create;
  Result := FIntOrdensServico.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TOrdensServico.OrdemServico: IOrdemServico;
begin
  Result := FOrdemServico;
end;

function TOrdensServico.BuscarResumido(CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.BuscarResumido(CodOrdemServico);
end;

function TOrdensServico.OrdemServicoResumida: IOrdemServicoResumida;
begin
  FOrdemServicoResumida.CodOrdemServico         := FIntOrdensServico.OrdemServicoResumida.CodOrdemServico;
  FOrdemServicoResumida.NumOrdemServico         := FIntOrdensServico.OrdemServicoResumida.NumOrdemServico;
  FOrdemServicoResumida.CodPessoaProdutor       := FIntOrdensServico.OrdemServicoResumida.CodPessoaProdutor;
  FOrdemServicoResumida.NomProdutor             := FIntOrdensServico.OrdemServicoResumida.NomProdutor;
  FOrdemServicoResumida.SglProdutor             := FIntOrdensServico.OrdemServicoResumida.SglProdutor;
  FOrdemServicoResumida.NumCNPJCPFProdutorFormatado     := FIntOrdensServico.OrdemServicoResumida.NumCNPJCPFProdutorFormatado;
  FOrdemServicoResumida.CodPropriedadeRural     := FIntOrdensServico.OrdemServicoResumida.CodPropriedadeRural;
  FOrdemServicoResumida.NomPropriedadeRural     := FIntOrdensServico.OrdemServicoResumida.NomPropriedadeRural;
  FOrdemServicoResumida.NumImovelReceitaFederal := FIntOrdensServico.OrdemServicoResumida.NumImovelReceitaFederal;
  FOrdemServicoResumida.QtdAnimais              := FIntOrdensServico.OrdemServicoResumida.QtdAnimais;
  FOrdemServicoResumida.CodSituacaoOS           := FIntOrdensServico.OrdemServicoResumida.CodSituacaoOS;
  FOrdemServicoResumida.SglSituacaoOS           := FIntOrdensServico.OrdemServicoResumida.SglSituacaoOS;
  FOrdemServicoResumida.DesSituacaoOS           := FIntOrdensServico.OrdemServicoResumida.DesSituacaoOS;
  FOrdemServicoResumida.CodLocalizacaoSisbov    := FIntOrdensServico.OrdemServicoResumida.CodLocalizacaoSisbov;

  FOrdemServicoResumida.DtaEnvioPedido          := FIntOrdensServico.OrdemServicoResumida.DtaEnvioPedido;
  FOrdemServicoResumida.NomServicoEnvio         := FIntOrdensServico.OrdemServicoResumida.NomServicoEnvio;
  FOrdemServicoResumida.NroConhecimento         := FIntOrdensServico.OrdemServicoResumida.NroConhecimento; 

  Result := FOrdemServicoResumida;
end;

function TOrdensServico.PesquisarHistoricoSituacao(
  CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.PesquisarHistoricoSituacao(CodOrdemServico);
end;

function TOrdensServico.ObterProximoNumero: Integer;
begin
  Result := FIntOrdensServico.ObterProximoNumero(FConexaoBD, FMensagens);
end;

function TOrdensServico.BOF: WordBool;
begin
  Result := FIntOrdensServico.BOF;
end;

function TOrdensServico.EOF: WordBool;
begin
  Result := FIntOrdensServico.EOF;
end;

function TOrdensServico.NumeroRegistros: Integer;
begin
  Result := FIntOrdensServico.NumeroRegistros;
end;

procedure TOrdensServico.Posicionar(NumDeslocamento: Integer);
begin
  FIntOrdensServico.Posicionar(NumDeslocamento);
end;

function TOrdensServico.ValorCampo(const NomCampo: WideString): WideString;
begin
  Result := FIntOrdensServico.ValorCampo(NomCampo);
end;

procedure TOrdensServico.IrAoAnterior;
begin
  FIntOrdensServico.IrAoAnterior;
end;

procedure TOrdensServico.IrAoPrimeiro;
begin
  FIntOrdensServico.IrAoPrimeiro;
end;

procedure TOrdensServico.IrAoProximo;
begin
  FIntOrdensServico.IrAoProximo;
end;

procedure TOrdensServico.IrAoUltimo;
begin
  FIntOrdensServico.IrAoUltimo;
end;

function TOrdensServico.Alterar(CodOrdemServico, NumOrdemServico,
  QtdAnimais, CodPessoaTecnico, CodPessoaVendedor: Integer;
  const NumCNPJCPFVendedor: WideString; CodFormaPagamentoOS,
  CodIdentificacaoDupla, CodFabricanteIdentificador,
  CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
  CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
  QtdProdutoAcessorio3: Integer; const TxtObservacaoPedido, TxtObservacao,
  IndAnimaisRegistrados: WideString): Integer;
begin
  Result := FIntOrdensServico.Alterar(CodOrdemServico, NumOrdemServico,
    QtdAnimais, CodPessoaTecnico, CodPessoaVendedor, NumCNPJCPFVendedor,
    CodFormaPagamentoOS, CodIdentificacaoDupla, CodFabricanteIdentificador,
    CodFormaPagamentoIdent, CodProdutoAcessorio1, QtdProdutoAcessorio1,
    CodProdutoAcessorio2, QtdProdutoAcessorio2, CodProdutoAcessorio3,
    QtdProdutoAcessorio3, TxtObservacaoPedido, TxtObservacao, IndAnimaisRegistrados);
end;

function TOrdensServico.Inserir(NumOrdemServico,
  CodPessoaProdutor: Integer; const SglProdutor,
  NumCNPJCPFProdutor: WideString; CodPropriedadeRural: Integer;
  const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
  QtdAnimais: Integer;
  const IndEnviaPedidoIdentificador: WideString): Integer;
begin
  Result := TIntOrdensServico.Inserir(FConexaoBD, FMensagens, NumOrdemServico,
    CodPessoaProdutor, SglProdutor, NumCNPJCPFProdutor, CodPropriedadeRural,
    NumImovelReceitaFederal, CodLocalizacaoSisbov, QtdAnimais, IndEnviaPedidoIdentificador, 'N');
end;

function TOrdensServico.Pesquisar(NumOrdemServico: Integer;
  const SglProdutor, NomProdutor, NumCNPJCPFProdutor,
  NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
  const NomPropriedadeRural, NumCPNJCPFTecnico,
  NumCNPJCPFVendedor: WideString; QtdAnimaisInicio, QtdAnimaisFim,
  NumSolicitacaoSISBOV: Integer;
  const IndApenasSemEnderecoEntregaCert: WideString; CodIdentificacaoDupla,
  CodFabricanteIdentificador: Integer; const IndEnviaPedidoIdentificador,
  IndApenasSemEnderecoEntregaIdent,
  IndapenasSemEnderecoCobrancaIdent: WideString; NumPedidoFabricante,
  NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
  DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
  CodSituacaoOS, CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSisbov, CodSituacaoSISBOVSimInicio,
  CodSituacaoSISBOVNao: Integer; DtaSituacaoSISBOVSimInicio,
  DtaSituacaoSISBOVSimFim: TDateTime; NumDiasBoletoAVencer,
  NumDiasBoletoEmAtraso, NumDiasBoletoPago, CodSituacaoBoleto: Integer;
  const CodOrdenacao, IndOrdenacaoCrescente: WideString): Integer;
begin
  Result := FIntOrdensServico.Pesquisar(NumOrdemServico, SglProdutor,
    NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    NomPropriedadeRural, NumCPNJCPFTecnico, NumCNPJCPFVendedor,
    QtdAnimaisInicio, QtdAnimaisFim, NumSolicitacaoSISBOV,
    IndApenasSemEnderecoEntregaCert, CodIdentificacaoDupla,
    CodFabricanteIdentificador, IndEnviaPedidoIdentificador,
     IndApenasSemEnderecoEntregaIdent, IndapenasSemEnderecoCobrancaIdent,
     NumPedidoFabricante, NumRemessa, DtaCadastramentoInicio,
     DtaCadastramentoFim, DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim,
     CodSituacaoOS, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
     CodAnimalSISBOV, CodSituacaoSISBOVSimInicio, CodSituacaoSISBOVNao,
     DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim,
     NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago, CodSituacaoBoleto, 
     CodOrdenacao, IndOrdenacaoCrescente);
end;

function TOrdensServico.DefinirEnderecoEntregaCert2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
begin
    Result := FIntOrdensServico.DefinirEnderecoEntregaCert2(CodOrdemServico,
  CodEndereco, CodPessoa);
end;

function TOrdensServico.DefinirEnderecoEntregaCert1(CodOrdemServico,
  CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone, NumFax,
  TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString; CodDistrito,
  CodMunicipio: Integer; const NomLocalidade: WideString;
  CodEstado: Integer): Integer;
begin
  Result := FIntOrdensServico.DefinirEnderecoEntregaCert1(CodOrdemServico,
  CodTipoEndereco, NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep, CodDistrito, CodMunicipio,
  NomLocalidade, CodEstado);
end;

function TOrdensServico.DefinirEnderecoCobrancaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
begin
  Result := FIntOrdensServico.DefinirEnderecoCobrancaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa);
end;

function TOrdensServico.DefinirEnderecoCobrancaIdent1(CodOrdemServico,
  CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone, NumFax,
  TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString; CodDistrito,
  CodMunicipio: Integer; const NomLocalidade: WideString;
  CodEstado: Integer): Integer;
begin
  Result := FIntOrdensServico.DefinirEnderecoCobrancaIdent1(CodOrdemServico,
  CodTipoEndereco, NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep, CodDistrito, CodMunicipio,
  NomLocalidade, CodEstado);
end;

function TOrdensServico.DefinirEnderecoEntregaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa: Integer): Integer;
begin
  Result := FIntOrdensServico.DefinirEnderecoEntregaIdent2(CodOrdemServico,
  CodEndereco, CodPessoa);
end;

function TOrdensServico.DefinirEnderecoEntregaIdent1(CodOrdemServico,
  CodTipoEndereco: Integer; const NomPessoaContato, NumTelefone, NumFax,
  TxtEMail, NomLogradouro, NomBairro, NumCEP: WideString; CodDistrito,
  CodMunicipio: Integer; const NomLocalidade: WideString;
  CodEstado: Integer): Integer;
begin
  Result := FIntOrdensServico.DefinirEnderecoEntregaIdent1(CodOrdemServico,
  CodTipoEndereco, NomPessoaContato, NumTelefone, NumFax, TxtEmail,
  NomLogradouro, NomBairro, NumCep, CodDistrito, CodMunicipio,
  NomLocalidade, CodEstado);
end;

function TOrdensServico.MudarSituacao(CodOrdemServico,
  CodSituacaoOS: Integer; const TxtObservacao: WideString): Integer;
begin
  Result := FIntOrdensServico.MudarSituacao(FConexaoBD, FMensagens,
    CodOrdemServico, CodSituacaoOS, TxtObservacao, 'S', 'N');
end;

function TOrdensServico.DefinirCodigoSISBOVInicio(CodOrdemServico,
  CodPaisSISBOVInicio, CodEstadoSISBOVInicio, CodMicroRegiaoSISBOVInicio,
  CodAnimalSISBOVInicio, NumDVSISBOVInicio: Integer): Integer;
begin
  result := FIntOrdensServico.DefinirCodigoSISBOVInicio(
    CodOrdemServico, CodPaisSISBOVInicio, CodEstadoSISBOVInicio,
    CodMicroRegiaoSISBOVInicio, CodAnimalSISBOVInicio, NumDVSISBOVInicio);
end;

function TOrdensServico.MudarEnviaPedidoIdentificador(
  CodOrdemServico: Integer;
  const IndEnviaPedidoIdentificador: WideString): Integer;
begin
  Result := FIntOrdensServico.MudarEnviarPedidoIdentificador(
    CodOrdemServico, IndEnviaPedidoIdentificador);
end;

function TOrdensServico.PesquisarSituacaoCodigosSISBOV(
  CodOrdemServico: Integer;
  const IndMostrarDataMudancaSituacao: WideString): Integer;
begin
  Result := FIntOrdensServico.PesquisarSituacaoCodigoSisBov(CodOrdemServico,
    IndMostrarDataMudancaSituacao);
end;

function TOrdensServico.PesquisarDataLiberacaoAbate(
  CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.PesquisarDataLiberacaoAbate(CodOrdemServico);
end;

function TOrdensServico.GerarRelatorioFichaOS(CodOrdemServico,
  TipoArquivo: Integer): WideString;
begin
   Result := FIntOrdensServico.GerarRelatorioFichaOrdemServico(CodOrdemServico, TipoArquivo);
end;

function TOrdensServico.Get_IndAcessoCodigoSISBOVInicio: WideString;
begin
  Result := FIntOrdensServico.IndAcessoCodigoSISBOVInicio;
end;

function TOrdensServico.Get_IndAcessoEnderecoCobrancaIdent: WideString;
begin
  Result := FIntOrdensServico.IndAcessoEnderecoCobrancaIdent;
end;

function TOrdensServico.Get_IndAcessoEnderecoEntregaCert: WideString;
begin
  Result := FIntOrdensServico.IndAcessoEnderecoEntregaCert;
end;

function TOrdensServico.Get_IndAcessoEnderecoEntregaIdent: WideString;
begin
  Result := FIntOrdensServico.IndAcessoEnderecoEntregaIdent;
end;

function TOrdensServico.Get_IndAcessoIndEnviaPedidoIdent: WideString;
begin
  Result := FIntOrdensServico.IndAcessoEnviaPedidoIdentificador;
end;

function TOrdensServico.Get_IndAcessoFabricanteIdentificador: WideString;
begin
  Result := FIntOrdensServico.IndAcessoFabricanteIdentificador;
end;

function TOrdensServico.Get_IndAcessoFormaPagamentoIdent: WideString;
begin
  Result := FIntOrdensServico.IndAcessoFormaPagamentoIdent;
end;

function TOrdensServico.Get_IndAcessoFormaPagamentoOS: WideString;
begin
  Result := FIntOrdensServico.IndAcessoFormaPagamentoOS;
end;

function TOrdensServico.Get_IndAcessoIdentificacaoDupla: WideString;
begin
  Result := FIntOrdensServico.IndAcessoIdentificacaoDupla;
end;

function TOrdensServico.Get_IndAcessoNumOrdemServico: WideString;
begin
  Result := FIntOrdensServico.IndAcessoNumOrdemServico;
end;

function TOrdensServico.Get_IndAcessoPessoaTecnico: WideString;
begin
  Result := FIntOrdensServico.IndAcessoPessoaTecnico;
end;

function TOrdensServico.Get_IndAcessoPessoaVendedor: WideString;
begin
  Result := FIntOrdensServico.IndAcessoPessoaVendedor;
end;

function TOrdensServico.Get_IndAcessoCodProdutoAcessorio1: WideString;
begin
  Result := FIntOrdensServico.IndAcessoProdutoAcessorio1;
end;

function TOrdensServico.Get_IndAcessoCodProdutoAcessorio2: WideString;
begin
  Result := FIntOrdensServico.IndAcessoProdutoAcessorio2;
end;

function TOrdensServico.Get_IndAcessoCodProdutoAcessorio3: WideString;
begin
  Result := FIntOrdensServico.IndAcessoProdutoAcessorio3;
end;

function TOrdensServico.Get_IndAcessoQtdAnimais: WideString;
begin
  Result := FIntOrdensServico.IndAcessoQtdAnimais;
end;

function TOrdensServico.Get_IndAcessoQtdProdutoAcessorio1: WideString;
begin
  Result := FIntOrdensServico.IndAcessoQtdProdutoAcessorio1;
end;

function TOrdensServico.Get_IndAcessoQtdProdutoAcessorio2: WideString;
begin
  Result := FIntOrdensServico.IndAcessoQtdProdutoAcessorio2;
end;

function TOrdensServico.Get_IndAcessoQtdProdutoAcessorio3: WideString;
begin
  Result := FIntOrdensServico.IndAcessoQtdProdutoAcessorio3;
end;

function TOrdensServico.BuscarAcessoAtributos(
  CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.BuscarAcessoAtributos(CodOrdemServico);
end;

function TOrdensServico.GerarRelatorio(NumOrdemServico: Integer;
  const SglProdutor, NomProdutor, NumCNPJCPFProdutor,
  NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
  const NomPropriedadeRural, numCNPJCPFTecnico,
  NumCNPJCPFVendedor: WideString; QtdAnimaisInicio, QtdAnimaisFim,
  NumSolicitacaoSISBOV: Integer;
  const IndApenasSemEnderecoEntregaCert: WideString; CodIdentificacaoDupla,
  CodFabricanteIdentificador: Integer; const IndEnviaPedidoIdent,
  IndApenasSemEnderecoEntregaIdent,
  IndapenasSemEnderecoCobrancaIdent: WideString; NumPedidoFabricante,
  NumRemessa: Integer; DtaCadastramentoInicio, DtaCadastramentoFim,
  DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim: TDateTime;
  CodSituacaoOS, CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSisbov, CodSituacaoSISBOVSim, CodSituacaoSISBOVNao: Integer;
  DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim: TDateTime;
  NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
  CodSituacaoBoleto: Integer; const CodOrdenacao,
  IndOrdenacaoCrescente: WideString; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntOrdensServico.GerarRelatorio(NumOrdemServico, SglProdutor,
    NomProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    NomPropriedadeRural, NumCNPJCPFTecnico, NumCNPJCPFVendedor, QtdAnimaisInicio,
    QtdAnimaisFim, NumSolicitacaoSISBOV, IndApenasSemEnderecoEntregaCert,
    CodIdentificacaoDupla, CodFabricanteIdentificador, IndEnviaPedidoIdent,
    IndApenasSemEnderecoEntregaIdent, IndApenasSemEnderecoCobrancaIdent,
    NumPedidoFabricante, NumRemessa, DtaCadastramentoInicio,
    DtaCadastramentoFim, DtaMudancaSituacaoInicio, DtaMudancaSituacaoFim,
    CodSituacaoOS, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOV, CodSituacaoSISBOVSim, CodSituacaoSISBOVNao,
    DtaSituacaoSISBOVSimInicio, DtaSituacaoSISBOVSimFim,
    NumDiasBoletoAVencer, NumDiasBoletoEmAtraso, NumDiasBoletoPago,
    CodSituacaoBoleto, CodOrdenacao, IndOrdenacaoCrescente,
    Tipo, QtdQuebraRelatorio);
end;

function TOrdensServico.LimparCodigoSISBOVInicio(
  CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.LimparCodigoSISBOVInicio(CodOrdemServico);
end;

function TOrdensServico.Get_IndAcessoObservacaoPedido: WideString;
begin
  Result := FIntOrdensServico.IndAcessoObservacaoPedido;
end;

function TOrdensServico.Get_IndAcessoAnimaisRegistrados: WideString;
begin
  Result := FIntOrdensServico.IndAcessoAnimaisRegistrados;
end;

function TOrdensServico.PesquisarSituacoesFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntOrdensServico.PesquisarSituacoesFichas(CodOrdemServico,
    NumRemessaFicha);
end;

function TOrdensServico.AlterarEnvioIdentOS(CodOrdemServico: Integer;
  DtaEnvioIdent: TDateTime; const NomServicoEnvio,
  NroConhecimento: WideString): Integer;
begin
  Result := FIntOrdensServico.AlterarEnvioIdentOS(CodOrdemServico, DtaEnvioIdent,
                                                  NomServicoEnvio, NroConhecimento)
end;

function TOrdensServico.IncluirSolicitacaoNumeracao(CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.IncluirSolicitacaoNumeracao(CodOrdemServico)
end;

function TOrdensServico.DefinirNumeroSolicitacao(CodOrdemServico,
  NumeroSolicitacao: Integer; DataSolicitacao: TDateTime): Integer;
begin
  Result := FIntOrdensServico.DefinirNumeroSolicitacao(CodOrdemServico, NumeroSolicitacao, DataSolicitacao);
end;

function TOrdensServico.IncluirSolicitacaoNumeracaoReimpressao(CodOrdemServico: Integer): Integer;
begin
  Result := FIntOrdensServico.IncluirSolicitacaoNumeracaoReimpressao(CodOrdemServico);
end;

function TOrdensServico.TempCancelarSolicitacaoNumeracao(const NumeroSisbov: WideString;
  IdPropriedade: Integer; const CnpjProdutor, CpfProdutor: WideString;
  IdMotivoCancelamento: Integer): Integer;
begin
  Result := FIntOrdensServico.TempCancelarSolicitacaoNumeracao(
    NumeroSisbov, IdPropriedade, CnpjProdutor, CpfProdutor, IdMotivoCancelamento);
end;

function TOrdensServico.TempSolicitarNumeracaoReimpressao(
  const cnpjFabrica, cpfProdutor, cnpjProdutor: WideString; idPropriedade,
  qtd: Integer; const numero_sisbov,
  tipo_identificacao: WideString): Integer;
begin
  Result := FIntOrdensServico.TempSolicitarNumeracaoReimpressao(cnpjFabrica,
    cpfProdutor, cnpjProdutor, idPropriedade, qtd, numero_sisbov, tipo_identificacao);
end;

function TOrdensServico.TempConsultarNumeracaoReimpressao(
  NumeroSolicitacao: Integer): WideString;
begin
  Result := FIntOrdensServico.TempConsultarNumeracaoReimpressao(NumeroSolicitacao);
end;

function TOrdensServico.SolicitarNumeracaoReimpressao(
  CodFabricanteIdentificador: Integer; const CodManejo,
  TipoIdentificacao: WideString): Integer;
begin
  result  :=  FIntOrdensServico.SolicitarNumeracaoReimpressao(CodFabricanteIdentificador,CodManejo,TipoIdentificacao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOrdensServico, Class_OrdensServico,
    ciMultiInstance, tmApartment);
end.
