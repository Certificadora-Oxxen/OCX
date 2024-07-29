unit uBoletosBancario;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,
  uBoletoBancario, uIntBoletosBancario, uConexao, uIntMensagens, uEndereco,
  uIntEndereco;

type
  TBoletosBancario = class(TASPMTSObject, IBoletosBancario)
  private
    FInicializado: Boolean;

    FBoletoBancario:     TBoletoBancario;
    FIntBoletosBancario: TIntBoletosBancario;

    FConexao:   TConexao;
    FMensagens: TIntMensagens;
  protected
    function Alterar(CodBoletoBancario, NumParcela,
      CodEnderecoCobranca: Integer; DtaVencimentoBoleto: TDateTime;
      const TxtMensagem3, TxtMensagem4: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodBoletoBancario, NumParcela: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Inserir(CodIdentificacaoBancaria, CodOrdemServico,
      CodEnderecoCobranca, QtdParcelas: Integer; ValUnitarioVendedor,
      ValUnitarioTecnico, ValVistoria, ValUnitarioCertificadora: Double;
      const DtaVencimentoBoleto, TxtMensagem3, TxtMensagem4: WideString;
      CodFormaPagamentoBoleto: Integer): Integer; safecall;
    function MudarSituacao(CodBoletoBancario, NumParcela,
      CodSituacaoBoleto: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function Pesquisar(CodOrdemServico: Integer): Integer; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_BoletoBancario: IBoletoBancario; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    function PesquisarErroRemessa(CodArquivoRemessa: Integer): Integer;
      safecall;
    function PesquisarRemessa(CodArquivoRemessa,
      CodTipoArquivoRemessa: Integer; DtaCriacaoArquivoInicial,
      DtaCriacaoArquivoFinal: TDateTime;
      const IndPossuiLogErro: WideString): Integer; safecall;
    function PesquisarTipoArquivoRemessa: Integer; safecall;
    function GerarRemessa: Integer; safecall;
    function DefinirEnderecoCobrancaBoleto(CodTipoEndereco: Integer;
      const NomLogradouro, NomBairro, NumCEP: WideString; CodDistrito,
      CodMunicipio: Integer; const NomLocalidade: WideString;
      CodEstado: Integer): Integer; safecall;
    function DefinirEnderecoCobrancaOS(CodOrdemServico: Integer): Integer;
      safecall;
    function PesquisarSituacaoBoleto(CodSituacaoBoleto: Integer;
      const IndOrdenacao: WideString): Integer; safecall;
    function ArmazenarArquivoUpLoad(
      const NomArquivoUpLoad: WideString): Integer; safecall;
    function PesquisarImportacaoBoleto(const CodSituacaoArquivo,
      NomArquivoUpLoad, NomUsuario: WideString; DtaImportacaoInicio,
      DtaImportacaoFim, DtaProcessamentoInicio,
      DtaProcessamentoFim: TDateTime): Integer; safecall;
    function ProcessarArquivoRetorno(CodArquivoImportacao: Integer): Integer;
      safecall;
    function BuscarArquivoImportacao(CodArquivoImportacao: Integer): Integer;
      safecall;
    function PesquisarErrosImportacao(CodArquivoImportacao: Integer): Integer;
      safecall;
    function GerarRelatorioFichaBoletos(CodBoleto, NumParcela,
      CodTipoArquivo: Integer): WideString; safecall;
    function PesquisarHistoricoMudancaSituacao(CodBoleto,
      NumParcela: Integer): Integer; safecall;
    function PesquisarFormaPagamentoBoleto(
      CodFormaPagamentoBoleto: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
end;

implementation

uses ComServ, uIntBoletoBancario;

function TBoletosBancario.Alterar(CodBoletoBancario, NumParcela,
  CodEnderecoCobranca: Integer; DtaVencimentoBoleto: TDateTime;
  const TxtMensagem3, TxtMensagem4: WideString): Integer;
begin
  Result := FIntBoletosBancario.Alterar(CodBoletoBancario, NumParcela, CodEnderecoCobranca,
    DtaVencimentoBoleto, TxtMensagem3, TxtMensagem4);
end;

function TBoletosBancario.BOF: WordBool;
begin
  Result := FIntBoletosBancario.BOF();
end;

function TBoletosBancario.Buscar(CodBoletoBancario,
  NumParcela: Integer): Integer;
begin
  Result := FIntBoletosBancario.Buscar(CodBoletoBancario, NumParcela);
end;

function TBoletosBancario.EOF(): WordBool;
begin
  Result := FIntBoletosBancario.EOF();
end;

function TBoletosBancario.Inserir(CodIdentificacaoBancaria,
  CodOrdemServico, CodEnderecoCobranca, QtdParcelas: Integer;
  ValUnitarioVendedor, ValUnitarioTecnico, ValVistoria,
  ValUnitarioCertificadora: Double; const DtaVencimentoBoleto,
  TxtMensagem3, TxtMensagem4: WideString;
  CodFormaPagamentoBoleto: Integer): Integer;
begin
  Result := FIntBoletosBancario.Inserir(CodIdentificacaoBancaria, CodOrdemServico, CodEnderecoCobranca,
                                        QtdParcelas, ValUnitarioVendedor, ValUnitarioTecnico,
                                        ValUnitarioCertificadora, ValVistoria, DtaVencimentoBoleto, TxtMensagem3,
                                        TxtMensagem4, CodFormaPagamentoBoleto);
end;

function TBoletosBancario.MudarSituacao(CodBoletoBancario, NumParcela,
  CodSituacaoBoleto: Integer; const TxtObservacao: WideString): Integer;
begin
  Result := FIntBoletosBancario.MudarSituacao(CodBoletoBancario,
                                              NumParcela,
                                              CodSituacaoBoleto,
                                              TxtObservacao);
end;

function TBoletosBancario.Pesquisar(CodOrdemServico: Integer): Integer;
begin
  Result := FIntBoletosBancario.Pesquisar(CodOrdemServico);
end;

procedure TBoletosBancario.Deslocar(NumDeslocamento: Integer);
begin
  FIntBoletosBancario.Deslocar(NumDeslocamento);
end;

procedure TBoletosBancario.IrAoPrimeiro;
begin
  FIntBoletosBancario.IrAoPrimeiro();
end;

procedure TBoletosBancario.IrAoProximo;
begin
  FIntBoletosBancario.IrAoProximo();
end;

procedure TBoletosBancario.Posicionar(NumPosicao: Integer);
begin
  FIntBoletosBancario.Posicionar(NumPosicao);
end;

function TBoletosBancario.Get_BoletoBancario: IBoletoBancario;
begin
  FBoletoBancario.CodOrdemServico           := FIntBoletosBancario.IntBoletoBancario.CodOrdemServico;
  FBoletoBancario.CodBoletoBancario         := FIntBoletosBancario.IntBoletoBancario.CodBoletoBancario;
  FBoletoBancario.CodIdentificacaoBancaria  := FIntBoletosBancario.IntBoletoBancario.CodIdentificacaoBancaria;
  FBoletoBancario.NomBanco                  := FIntBoletosBancario.IntBoletoBancario.NomBanco;
  FBoletoBancario.NomReduzidoBanco          := FIntBoletosBancario.IntBoletoBancario.NomReduzidoBanco;
  FBoletoBancario.CodSituacaoBoleto         := FIntBoletosBancario.IntBoletoBancario.CodSituacaoBoleto;
  FBoletoBancario.SglSituacaoBoleto         := FIntBoletosBancario.IntBoletoBancario.SglSituacaoBoleto;
  FBoletoBancario.DesSituacaoBoleto         := FIntBoletosBancario.IntBoletoBancario.DesSituacaoBoleto;
  FBoletoBancario.NomPessoaProdutor         := FIntBoletosBancario.IntBoletoBancario.NomPessoaProdutor;
  FBoletoBancario.NumCNPJCPF                := FIntBoletosBancario.IntBoletoBancario.NumCNPJCPF;
  FBoletoBancario.NumCNPJCPFFormatado       := FIntBoletosBancario.IntBoletoBancario.NumCNPJCPFFormatado;
  FBoletoBancario.NomPropriedadeRural       := FIntBoletosBancario.IntBoletoBancario.NomPropriedadeRural;
  FBoletoBancario.NumImovelReceitaFederal   := FIntBoletosBancario.IntBoletoBancario.NumImovelReceitaFederal;
  FBoletoBancario.DtaGeracaoRemessa         := FIntBoletosBancario.IntBoletoBancario.DtaGeracaoRemessa;
  FBoletoBancario.DtaVencimentoBoleto       := FIntBoletosBancario.IntBoletoBancario.DtaVencimentoBoleto;
  FBoletoBancario.NumParcela                := FIntBoletosBancario.IntBoletoBancario.NumParcela;
  FBoletoBancario.ValTotalBoleto            := FIntBoletosBancario.IntBoletoBancario.ValTotalBoleto;
  FBoletoBancario.QtdAnimais                := FIntBoletosBancario.IntBoletoBancario.QtdAnimais;
  FBoletoBancario.ValUnitarioVendedor       := FIntBoletosBancario.IntBoletoBancario.ValUnitarioVendedor;
  FBoletoBancario.ValUnitarioTecnico        := FIntBoletosBancario.IntBoletoBancario.ValUnitarioTecnico;
  FBoletoBancario.ValUnitarioCertificadora  := FIntBoletosBancario.IntBoletoBancario.ValUnitarioCertificadora;
  FBoletoBancario.ValVistoria               := FIntBoletosBancario.IntBoletoBancario.ValVistoria; 
  FBoletoBancario.ValTotalOS                := FIntBoletosBancario.IntBoletoBancario.ValTotalOS;
  FBoletoBancario.QtdParcelas               := FIntBoletosBancario.IntBoletoBancario.QtdParcelas;
  FBoletoBancario.ValPagoBoleto             := FIntBoletosBancario.IntBoletoBancario.ValPagoBoleto;
  FBoletoBancario.DtaCreditoEfetivado       := FIntBoletosBancario.IntBoletoBancario.DtaCreditoEfetivado;
  FBoletoBancario.CodUsuarioUltimaAlteracao := FIntBoletosBancario.IntBoletoBancario.CodUsuarioUltimaAlteracao;
  FBoletoBancario.NomUsuarioUltimaAlteracao := FIntBoletosBancario.IntBoletoBancario.NomUsuarioUltimaAlteracao;
  FBoletoBancario.CodUsuarioCancelamento    := FIntBoletosBancario.IntBoletoBancario.CodUsuarioCancelamento;
  FBoletoBancario.NomUsuarioCancelamento    := FIntBoletosBancario.IntBoletoBancario.NomUsuarioCancelamento;
  FBoletoBancario.DtaUltimaAlteracao        := FIntBoletosBancario.IntBoletoBancario.DtaUltimaAlteracao;
  FBoletoBancario.TxtMensagem3              := FIntBoletosBancario.IntBoletoBancario.TxtMensagem3;
  FBoletoBancario.TxtMensagem4              := FIntBoletosBancario.IntBoletoBancario.TxtMensagem4;
  FBoletoBancario.NomReduzidoBanco          := FIntBoletosBancario.IntBoletoBancario.NomReduzidoBanco;
  // Informações do endereço de cobrança!
  FBoletoBancario.EnderecoCobranca.CodEndereco      := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodEndereco;
  FBoletoBancario.EnderecoCobranca.CodTipoEndereco  := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodTipoEndereco;
  FBoletoBancario.EnderecoCobranca.SglTipoEndereco  := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.SglTipoEndereco;
  FBoletoBancario.EnderecoCobranca.DesTipoEndereco  := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.DesTipoEndereco;
  FBoletoBancario.EnderecoCobranca.NomPessoaContato := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomPessoaContato;
  FBoletoBancario.EnderecoCobranca.NumTelefone      := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NumTelefone;
  FBoletoBancario.EnderecoCobranca.NumFax           := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NumFax;
  FBoletoBancario.EnderecoCobranca.TxtEMail         := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.TxtEMail;
  FBoletoBancario.EnderecoCobranca.NomLogradouro    := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomLogradouro;
  FBoletoBancario.EnderecoCobranca.NumCEP           := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NumCEP;
  FBoletoBancario.EnderecoCobranca.NomBairro        := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomBairro;
  FBoletoBancario.EnderecoCobranca.CodDistrito      := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodDistrito;
  FBoletoBancario.EnderecoCobranca.NomDistrito      := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomDistrito;
  FBoletoBancario.EnderecoCobranca.CodMunicipio     := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodMunicipio;
  FBoletoBancario.EnderecoCobranca.NumMunicipioIBGE := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NumMunicipioIBGE;
  FBoletoBancario.EnderecoCobranca.NomMunicipio     := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomMunicipio;
  FBoletoBancario.EnderecoCobranca.CodEstado        := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodEstado;
  FBoletoBancario.EnderecoCobranca.SglEstado        := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.SglEstado;
  FBoletoBancario.EnderecoCobranca.NomEstado        := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.NomEstado;
  FBoletoBancario.EnderecoCobranca.CodPais          := FIntBoletosBancario.IntBoletoBancario.EnderecoCobranca.CodPais;

  // Informações da importação do arquivo de retorno
  FBoletoBancario.CodArqImportBoleto      := FIntBoletosBancario.IntBoletoBancario.CodArqImportBoleto;
  FBoletoBancario.NomArqUpLoad            := FIntBoletosBancario.IntBoletoBancario.NomArqUpLoad;
  FBoletoBancario.NomArqImportBoleto      := FIntBoletosBancario.IntBoletoBancario.NomArqImportBoleto;
  FBoletoBancario.DtaImportacao           := FIntBoletosBancario.IntBoletoBancario.DtaImportacao;
  FBoletoBancario.QtdRegistrosTotal       := FIntBoletosBancario.IntBoletoBancario.QtdRegistrosTotal;
  FBoletoBancario.QtdRegistrosErrados     := FIntBoletosBancario.IntBoletoBancario.QtdRegistrosErrados;
  FBoletoBancario.QtdRegistrosProcessados := FIntBoletosBancario.IntBoletoBancario.QtdRegistrosProcessados;
  FBoletoBancario.DtaProcessamento        := FIntBoletosBancario.IntBoletoBancario.DtaProcessamento;
  FBoletoBancario.CodUsuarioUpLoad        := FIntBoletosBancario.IntBoletoBancario.CodUsuarioUpLoad;
  FBoletoBancario.NomUsuarioUpLoad        := FIntBoletosBancario.IntBoletoBancario.NomUsuarioUpLoad;
  FBoletoBancario.CodTarefa               := FIntBoletosBancario.IntBoletoBancario.CodTarefa;
  FBoletoBancario.CodTipoArquivoBoleto    := FIntBoletosBancario.IntBoletoBancario.CodTipoArquivoBoleto;
  FBoletoBancario.DesTipoArquivoBoleto    := FIntBoletosBancario.IntBoletoBancario.DesTipoArquivoBoleto;
  FBoletoBancario.CodSituacaoBoleto       := FIntBoletosBancario.IntBoletoBancario.CodSituacaoBoleto;
  FBoletoBancario.DesTipoArquivoBoleto    := FIntBoletosBancario.IntBoletoBancario.DesTipoArquivoBoleto;
  FBoletoBancario.TxtMensagem             := FIntBoletosBancario.IntBoletoBancario.TxtMensagem;
  FBoletoBancario.CodSituacaoArqImport    := FIntBoletosBancario.IntBoletoBancario.CodSituacaoArqImport;
  FBoletoBancario.DesSituacaoArqImport    := FIntBoletosBancario.IntBoletoBancario.DesSituacaoArqImport;  

  FBoletoBancario.DesSituacaoTarefa             := FIntBoletosBancario.IntBoletoBancario.DesSituacaoTarefa;
  FBoletoBancario.DtaInicioPrevistoTarefa       := FIntBoletosBancario.IntBoletoBancario.DtaInicioPrevistoTarefa;
  FBoletoBancario.DtaInicioRealTarefa           := FIntBoletosBancario.IntBoletoBancario.DtaInicioRealTarefa;
  FBoletoBancario.DtaFimRealTarefa              := FIntBoletosBancario.IntBoletoBancario.DtaFimRealTarefa;
  FBoletoBancario.NomUsuarioProcessamentoTarefa := FIntBoletosBancario.IntBoletoBancario.NomUsuarioProcessamentoTarefa;

  FBoletoBancario.CodFormaPagamentoBoleto := FIntBoletosBancario.IntBoletoBancario.CodFormaPagamentoBoleto;
  FBoletoBancario.SglFormaPagamentoBoleto := FIntBoletosBancario.IntBoletoBancario.SglFormaPagamentoBoleto;
  FBoletoBancario.DesFormaPagamentoBoleto := FIntBoletosBancario.IntBoletoBancario.DesFormaPagamentoBoleto;

  Result := FBoletoBancario;
end;

function TBoletosBancario.NumeroRegistros: Integer;
begin
  Result := FIntBoletosBancario.NumeroRegistros();
end;

function TBoletosBancario.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntBoletosBancario.ValorCampo(NomCampo);
end;

procedure TBoletosBancario.AfterConstruction;
begin
  inherited;
  FIntBoletosBancario              := TIntBoletosBancario.Create;
  FBoletoBancario                  := TBoletoBancario.Create;
  FBoletoBancario.EnderecoCobranca := TEndereco.Create;
  FBoletoBancario.ObjAddRef;
end;

procedure TBoletosBancario.BeforeDestruction;
begin
  inherited;
  if FBoletoBancario <> nil then
  begin
    FBoletoBancario.ObjRelease;
    FBoletoBancario := nil;
  end;

  if FIntBoletosBancario <> nil then
  begin
    FIntBoletosBancario.Free;
  end;
end;

function TBoletosBancario.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FConexao   := ConexaoBD;
  FMensagens := Mensagens;

  FIntBoletosBancario := TIntBoletosBancario.Create;
  Result := FIntBoletosBancario.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TBoletosBancario.PesquisarErroRemessa(
  CodArquivoRemessa: Integer): Integer;
begin
  Result := FIntBoletosBancario.PesquisarErroRemessa(CodArquivoRemessa);
end;

function TBoletosBancario.PesquisarRemessa(CodArquivoRemessa,
  CodTipoArquivoRemessa: Integer; DtaCriacaoArquivoInicial,
  DtaCriacaoArquivoFinal: TDateTime;
  const IndPossuiLogErro: WideString): Integer;
begin
  Result := FIntBoletosBancario.PesquisarRemessa(CodArquivoRemessa,
      CodTipoArquivoRemessa, DtaCriacaoArquivoInicial, DtaCriacaoArquivoFinal,
      IndPossuiLogErro);
end;

function TBoletosBancario.PesquisarTipoArquivoRemessa(): Integer;
begin
  Result := FIntBoletosBancario.PesquisarTipoArquivoRemessa();
end;

function TBoletosBancario.GerarRemessa: Integer;
begin
  Result := FIntBoletosBancario.GerarArquivoRemessa();
end;

function TBoletosBancario.DefinirEnderecoCobrancaBoleto(
  CodTipoEndereco: Integer; const NomLogradouro, NomBairro,
  NumCEP: WideString; CodDistrito, CodMunicipio: Integer;
  const NomLocalidade: WideString; CodEstado: Integer): Integer;
begin
  Result := FIntBoletosBancario.DefinirEnderecoCobrancaBoleto(CodTipoEndereco,
    NomLogradouro, NomBairro, NumCEP, CodDistrito, CodMunicipio,
    NomLocalidade, CodEstado);
end;

function TBoletosBancario.DefinirEnderecoCobrancaOS(
  CodOrdemServico: Integer): Integer;
begin
  Result := FIntBoletosBancario.DefinirEnderecoCobrancaOS(CodOrdemServico);
end;

function TBoletosBancario.PesquisarSituacaoBoleto(
  CodSituacaoBoleto: Integer; const IndOrdenacao: WideString): Integer;
begin
  Result := FIntBoletosBancario.PesquisarSituacaoBoleto(CodSituacaoBoleto, IndOrdenacao);
end;

function TBoletosBancario.ArmazenarArquivoUpLoad(
  const NomArquivoUpLoad: WideString): Integer;
begin
  Result := FIntBoletosBancario.ArmazenarArquivoUpLoad(NomArquivoUpLoad);
end;

function TBoletosBancario.PesquisarImportacaoBoleto(
  const CodSituacaoArquivo, NomArquivoUpLoad, NomUsuario: WideString;
  DtaImportacaoInicio, DtaImportacaoFim, DtaProcessamentoInicio,
  DtaProcessamentoFim: TDateTime): Integer;
begin
  Result := FIntBoletosBancario.PesquisarImportacaoBoleto(CodSituacaoArquivo,
    NomArquivoUpLoad, NomUsuario, DtaImportacaoInicio, DtaImportacaoFim,
    DtaProcessamentoInicio, DtaProcessamentoFim);
end;

function TBoletosBancario.ProcessarArquivoRetorno(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntBoletosBancario.ProcessarArquivoRetorno(CodArquivoImportacao);
end;

function TBoletosBancario.BuscarArquivoImportacao(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntBoletosBancario.BuscarArquivoImportacao(CodArquivoImportacao); 
end;

function TBoletosBancario.PesquisarErrosImportacao(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntBoletosBancario.PesquisarErrosImportacao(CodArquivoImportacao);
end;

function TBoletosBancario.GerarRelatorioFichaBoletos(CodBoleto, NumParcela,
  CodTipoArquivo: Integer): WideString;
begin
  Result := FIntBoletosBancario.GerarRelatorioFichaBoletos(CodBoleto, NumParcela, CodTipoArquivo);
end;

function TBoletosBancario.PesquisarHistoricoMudancaSituacao(CodBoleto,
  NumParcela: Integer): Integer;
begin
  Result := FIntBoletosBancario.PesquisarHistoricoMudancaSituacao(CodBoleto, NumParcela);
end;

function TBoletosBancario.PesquisarFormaPagamentoBoleto(
  CodFormaPagamentoBoleto: Integer): Integer;
begin
  Result := FIntBoletosBancario.PesquisarFormaPagamentoBoleto(CodFormaPagamentoBoleto);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBoletosBancario, Class_BoletosBancario,
    ciMultiInstance, tmApartment);
end.
