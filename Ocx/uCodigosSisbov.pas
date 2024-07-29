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
// *
// ********************************************************************
unit uCodigosSisbov;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uIntCodigosSisbov;

type
  TCodigosSisbov = class(TASPMTSObject, ICodigosSisbov)
  private
    FIntCodigosSisbov : TIntCodigosSisbov;
    FInicializado : Boolean;
  protected
    function Inserir(CodPessoaProdutor: Integer; const SglProdutor,
      NumCNPJCPFProdutor: WideString; CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      NumSolicitacaoSISBOV: Integer; DtaSolicitacaoSISBOV: TDateTime;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
      NumDVSISBOVFim, CodigoOS: Integer): Integer; safecall;
    function Pesquisar(CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      SeqInicial, SeqFinal: Integer; const IndCodigoUtilizado, NomPessoa,
      NomPropriedade, SglProdutor: WideString;
      DtaInicioCadastramentoCodigos, DtaFimCadastramentoCodigos,
      DtaInicioUtilizacaoCodigos, DtaFimUtilizacaoCodigos: TDateTime;
      NumSolicitacaoSISBOV: Integer): Integer; safecall;
    procedure FecharPesquisa; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoProximo; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Excluir(CodPessoaProdutor: Integer; const SglProdutor,
      NumCNPJCPFProdutor: WideString; CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
      NumDVSISBOVFim: Integer): Integer; safecall;
    function GerarRelatorioConsolidado(const CodEstado, SglProdutor,
      NomPessoaProdutor, NumCNPJCPFProdutor,
      NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
      const NomPropriedadeRural, NomMunicipioPropriedadeRural: WideString;
      DtaSolicitacaoSISBOVInicio, DtaSolicitacaoSISBOVFim,
      DtaInsercaoInicio, DtaInsercaoFim, DtaUtilizacaoInicio,
      DtaUtilizacaoFim, DtaLiberacaoAbateInicio, DtaLiberacaoAbateFim,
      DtaExpiracaoInicio, DtaExpiracaoFim: TDateTime;
      const CodSituacoesCodigoSISBOV: WideString; QtdQuebraRelatorio,
      Tipo: Integer): WideString; safecall;
    function ReservarCodigosProdutor(CodPessoaProdutor, CodEstadoSisBov,
      CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
      CodPropriedadeRural: Integer): Integer; safecall;
    function CancelarReservaProdutor(CodPessoaProdutor, CodEstadoSisBov,
      CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
      CodPropriedadeRural: Integer): Integer; safecall;
    function PesquisarReservaProdutor(const NomProdutor: WideString;
      CodEstadoSISBOV, CodMicroRegiaoSISBOV: Integer;
      const IndCodigoUtilizado, NomPropriedade: WideString; CodInicial,
      CodFinal: Integer): Integer; safecall;
    function GerarRelatorioCodigosSisbov(CodEstado, CodMicroRegiao: Integer;
      const CodOrdenacao: WideString; SeqInicial, SeqFinal, Tipo: Integer;
      const SglProdutor, NomProdutor, NomPropriedade: WideString;
      DtaInicioCadastramentoCodigos, DtaFimCadastramentoCodigos,
      DtaInicioUtilizacaoCodigos, DtaFimUtilizacaoCodigos: TDateTime;
      CodPais, QtdQuebraRelatorio,
      NumSolicitacaoSISBOV: Integer): WideString; safecall;
    function GeraArquivoCodigoExportacao: Integer; safecall;
    function InserirApenasUmCodigo(CodPaisSisBov, CodEstadoSisBov, CodMR,
      CodProdutor, CodPropriedadeRural, CodAnimal: Integer): Integer;
      safecall;
    function AlterarSolicitacao(CodPessoaProdutor: Integer; const SglProdutor,
      NumCNPJCPFProdutor: WideString; CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      NumSolicitacaoSISBOV: Integer; DtaSolicitacaoSISBOV: TDateTime;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
      NumDVSISBOVFim: Integer): Integer; safecall;
    function ProcessarAutenticacao(CodPessoaProdutor: Integer;
      const SglProdutor, NumCNPJCPFProdutor: WideString;
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
      NumDVSISBOVFim: Integer; DtaLiberacaoAbate: TDateTime): Integer;
      safecall;
    function CancelarAutenticacao(CodPessoaProdutor: Integer;
      const SglProdutor, NumCNPJCPFProdutor: WideString;
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
      NumDVSISBOVFim: Integer): Integer; safecall;
    function CancelarEnvioCertificado(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function ProcessarEnvioCertificado(CodOrdemServico,
      NumRemessaFicha: Integer; DtaEnvio: TDateTime; const NomServicoEnvio,
      NumConhecimento: WideString): Integer; safecall;
    function ProcessarRecebimentoFichas(DtaRecebimentoFicha: TDateTime;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV: Integer;
      const CodAnimaisSISBOVInicio,
      CodAnimaisSISBOVFim: WideString): Integer; safecall;
    function AdicionarFaixaRecebimento(CodOrdemServico, NumRemessaFicha,
      CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSISBOVInicio, CodAnimalSISBOVFim: Integer): Integer;
      safecall;
    function PesquisarFaixaRecebimento(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function RetirarFaixaRecebimento(CodOrdemServico, NumRemessaFaixa,
      SeqFaixaRemessa: Integer): Integer; safecall;
    function Get_CodOrdemServico: Integer; safecall;
    function Get_NumRemessaFicha: Integer; safecall;
    function CancelarAprovacaoFichas(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function CancelarImpressaoCertificado(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function ProcessarAprovacaoFichas(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function ProcessarImpressaoCertificado(CodOrdemServico,
      NumRemessaFicha: Integer): Integer; safecall;
    function InserirEnvioCertificado(CodPessoaProdutor: Integer;
      const SglProdutor, NumCNPJCPF: WideString;
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString;
      CodLocalizacaoSisbov: Integer; DtaEnvio: TDateTime;
      const NomServicoEnvio, NumConhecimento: WideString; CodPaisSisBov,
      CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalSisBovInicio,
      CodAnimalSisBovFim, NumDVSisBovInicio,
      NumDVSisBovFim: Integer): Integer; safecall;
    function ExcluirEnvioCertificado(CodPessoaProdutor: Integer;
      const SglProdutor, NumCNPJCPFProdutor: WideString;
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisBov,
      CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
      CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio,
      NumDBSisBovFim: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TCodigosSisbov.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TCodigosSisbov.BeforeDestruction;
begin
  If FIntCodigosSisbov <> nil Then Begin
    FIntCodigosSisbov.Free;
  End;
  inherited;
end;

function TCodigosSisbov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntCodigosSisbov := TIntCodigosSisbov.Create;
  Result := FIntCodigosSisbov.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TCodigosSisbov.Inserir(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisbov, NumSolicitacaoSISBOV: Integer;
  DtaSolicitacaoSISBOV: TDateTime; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim, CodigoOS: Integer): Integer;
begin
  Result := FIntCodigosSisbov.Inserir(CodPessoaProdutor, SglProdutor,
    NumCNPJCPFProdutor, CodPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    NumSolicitacaoSISBOV, DtaSolicitacaoSISBOV, CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
    CodAnimalSISBOVFim, NumDVSISBOVFim, CodigoOS);
end;

function TCodigosSisbov.Pesquisar(CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, SeqInicial, SeqFinal: Integer;
  const IndCodigoUtilizado, NomPessoa, NomPropriedade,
  SglProdutor: WideString; DtaInicioCadastramentoCodigos,
  DtaFimCadastramentoCodigos, DtaInicioUtilizacaoCodigos,
  DtaFimUtilizacaoCodigos: TDateTime;
  NumSolicitacaoSISBOV: Integer): Integer;
begin
  Result := FIntCodigosSisbov.Pesquisar(CodPaisSisBov, CodEstadoSisBov,
                                        CodMicroRegiaoSisBov, SeqInicial, SeqFinal, IndCodigoUtilizado, NomPessoa,
                                        NomPropriedade, SglProdutor,
                                        DtaInicioCadastramentoCodigos, DtaFimCadastramentoCodigos,
                                        DtaInicioUtilizacaoCodigos, DtaFimUtilizacaoCodigos, NumSolicitacaoSISBOV);
end;

procedure TCodigosSisbov.FecharPesquisa;
begin
  FIntCodigosSisbov.FecharPesquisa;
end;

function TCodigosSisbov.EOF: WordBool;
begin
  result := FIntCodigosSisbov.EOF;
end;

function TCodigosSisbov.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntCodigosSisbov.ValorCampo(NomCampo); 
end;

procedure TCodigosSisbov.IrAoProximo;
begin
  FIntCodigosSisbov.IrAoProximo;
end;

function TCodigosSisbov.BOF: WordBool;
begin
  result := FIntCodigosSisbov.BOF;
end;

function TCodigosSisbov.NumeroRegistros: Integer;
begin
  result := FIntCodigosSisbov.NumeroRegistros;
end;

procedure TCodigosSisbov.IrAoPrimeiro;
begin
  FIntCodigosSisbov.IrAoPrimeiro;
end;

procedure TCodigosSisbov.IrAoUltimo;
begin
  FIntCodigosSisbov.IrAoUltimo;
end;

procedure TCodigosSisbov.Deslocar(NumDeslocamento: Integer);
begin
  FIntCodigosSisbov.Deslocar(NumDeslocamento);
end;

procedure TCodigosSisbov.Posicionar(NumPosicao: Integer);
begin
  FIntCodigosSisbov.Posicionar(NumPosicao);
end;

function TCodigosSisbov.Excluir(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisbov, CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.Excluir(CodPessoaProdutor, SglProdutor,
    NumCNPJCPFProdutor, CodPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
    NumDVSISBOVInicio, CodAnimalSISBOVFim, NumDVSISBOVFim);
end;

function TCodigosSisbov.GerarRelatorioConsolidado(const CodEstado,
  SglProdutor, NomPessoaProdutor, NumCNPJCPFProdutor,
  NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
  const NomPropriedadeRural, NomMunicipioPropriedadeRural: WideString;
  DtaSolicitacaoSISBOVInicio, DtaSolicitacaoSISBOVFim, DtaInsercaoInicio,
  DtaInsercaoFim, DtaUtilizacaoInicio, DtaUtilizacaoFim,
  DtaLiberacaoAbateInicio, DtaLiberacaoAbateFim, DtaExpiracaoInicio,
  DtaExpiracaoFim: TDateTime; const CodSituacoesCodigoSISBOV: WideString;
  QtdQuebraRelatorio, Tipo: Integer): WideString;
begin
  Result := FIntCodigosSisbov.GerarRelatorioConsolidado(CodEstado, SglProdutor,
    NomPessoaProdutor, NumCNPJCPFProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    NomPropriedadeRural, NomMunicipioPropriedadeRural,
    DtaSolicitacaoSISBOVInicio, DtaSolicitacaoSISBOVFim, DtaInsercaoInicio,
    DtaInsercaoFim, DtaUtilizacaoInicio, DtaUtilizacaoFim,
    DtaLiberacaoAbateInicio, DtaLiberacaoAbateFim, DtaExpiracaoInicio, DtaExpiracaoFim,
    CodSituacoesCodigoSISBOV, QtdQuebraRelatorio, Tipo, -1);
end;

function TCodigosSisbov.ReservarCodigosProdutor(CodPessoaProdutor,
  CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntCodigosSisbov.ReservarCodigosProdutor(CodPessoaProdutor,
  CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
  CodPropriedadeRural);
end;

function TCodigosSisbov.CancelarReservaProdutor(CodPessoaProdutor,
  CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntCodigosSisbov.CancelarReservaProdutor(CodPessoaProdutor,
        CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalInicio, CodAnimalFim,
          CodPropriedadeRural);
end;

function TCodigosSisbov.PesquisarReservaProdutor(
  const NomProdutor: WideString; CodEstadoSISBOV,
  CodMicroRegiaoSISBOV: Integer; const IndCodigoUtilizado,
  NomPropriedade: WideString; CodInicial, CodFinal: Integer): Integer;
begin
  Result := FIntCodigosSisbov.PesquisarReservaProdutor(NomProdutor,
  CodEstadoSisBov, CodMicroRegiaoSisBov, IndCodigoUtilizado, NomPropriedade, CodInicial, CodFinal);
end;

function TCodigosSisbov.GerarRelatorioCodigosSisbov(CodEstado,
  CodMicroRegiao: Integer; const CodOrdenacao: WideString; SeqInicial,
  SeqFinal, Tipo: Integer; const SglProdutor, NomProdutor,
  NomPropriedade: WideString; DtaInicioCadastramentoCodigos,
  DtaFimCadastramentoCodigos, DtaInicioUtilizacaoCodigos,
  DtaFimUtilizacaoCodigos: TDateTime; CodPais, QtdQuebraRelatorio,
  NumSolicitacaoSISBOV: Integer): WideString;
begin
  Result := FIntCodigosSisbov.GerarRelatorioCodigosSisbov(CodEstado,
  CodMicroRegiao, CodOrdenacao, SeqInicial, SeqFinal, Tipo,
  SglProdutor, NomProdutor, NomPropriedade, DtaInicioCadastramentoCodigos, DtaFimCadastramentoCodigos,
  DtaInicioUtilizacaoCodigos, DtaFimUtilizacaoCodigos, CodPais, QtdQuebraRelatorio, NumSolicitacaoSISBOV);
end;

function TCodigosSisbov.GeraArquivoCodigoExportacao: Integer;
begin
  Result := FIntCodigosSisbov.GeraArquivoCodigoExportacao();
end;

function TCodigosSisbov.InserirApenasUmCodigo(CodPaisSisBov,
  CodEstadoSisBov, CodMR, CodProdutor, CodPropriedadeRural,
  CodAnimal: Integer): Integer;
begin
end;

function TCodigosSisbov.AlterarSolicitacao(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisbov, NumSolicitacaoSISBOV: Integer;
  DtaSolicitacaoSISBOV: TDateTime; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.AlterarSolicitacao(CodPessoaProdutor,
    SglProdutor, NumCNPJCPFProdutor, CodPropriedadeRural,
    NumImovelReceitaFederal, CodLocalizacaoSisbov, NumSolicitacaoSISBOV, DtaSolicitacaoSISBOV,
    CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
    NumDVSISBOVInicio, CodAnimalSISBOVFim, NumDVSISBOVFim);
end;

function TCodigosSisbov.ProcessarAutenticacao(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisbov, CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer;
  DtaLiberacaoAbate: TDateTime): Integer;
begin
  Result := FIntCodigosSisbov.ProcessarAutenticacao(CodPessoaProdutor,
    SglProdutor, NumCNPJCPFProdutor, CodPropriedadeRural,
    NumImovelReceitaFederal, CodLocalizacaoSisbov, CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
    CodAnimalSISBOVFim, NumDVSISBOVFim, DtaLiberacaoAbate);
end;

function TCodigosSisbov.CancelarAutenticacao(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisbov, CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
  CodAnimalSISBOVFim, NumDVSISBOVFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.CancelarAutenticacao(CodPessoaProdutor,
    SglProdutor, NumCNPJCPFProdutor, CodPropriedadeRural,
    NumImovelReceitaFederal, CodLocalizacaoSisbov, CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio, NumDVSISBOVInicio,
    CodAnimalSISBOVFim, NumDVSISBOVFim);
end;

function TCodigosSisbov.CancelarEnvioCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.CancelarEnvioCertificado(CodOrdemServico,
    NumRemessaFicha);
end;

function TCodigosSisbov.ProcessarEnvioCertificado(CodOrdemServico,
  NumRemessaFicha: Integer; DtaEnvio: TDateTime; const NomServicoEnvio,
  NumConhecimento: WideString): Integer;
begin
  Result := FIntCodigosSisbov.ProcessarEnvioCertificado(CodOrdemServico,
    NumRemessaFicha, DtaEnvio, NomServicoEnvio, NumConhecimento);
end;

function TCodigosSisbov.ProcessarRecebimentoFichas(
  DtaRecebimentoFicha: TDateTime; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV: Integer; const CodAnimaisSISBOVInicio,
  CodAnimaisSISBOVFim: WideString): Integer;
begin
  Result := FIntCodigosSisbov.ProcessarRecebimentoFichas(DtaRecebimentoFicha,
    CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimaisSISBOVInicio, CodAnimaisSISBOVFim);
end;

function TCodigosSisbov.AdicionarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOVInicio, CodAnimalSISBOVFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.AdicionarFaixaRecebimento(CodOrdemServico,
    NumRemessaFicha, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOVInicio, CodAnimalSISBOVFim);
end;

function TCodigosSisbov.PesquisarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.PesquisarFaixaRecebimento(CodOrdemServico,
  NumRemessaFicha);
end;

function TCodigosSisbov.RetirarFaixaRecebimento(CodOrdemServico,
  NumRemessaFaixa, SeqFaixaRemessa: Integer): Integer;
begin
  Result := FIntCodigosSisbov.RetirarFaixaRecebimento(CodOrdemServico,
  NumRemessaFaixa, SeqFaixaRemessa);
end;

function TCodigosSisbov.Get_CodOrdemServico: Integer;
begin
  Result := FIntCodigosSisbov.PCodOrdemServico;
end;

function TCodigosSisbov.Get_NumRemessaFicha: Integer;
begin
  Result := FIntCodigosSisbov.PNumRemessaFicha;
end;

function TCodigosSisbov.CancelarAprovacaoFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.CancelarAprovacaoFichas(CodOrdemServico,
    NumRemessaFicha);
end;

function TCodigosSisbov.CancelarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.CancelarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha);
end;

function TCodigosSisbov.ProcessarAprovacaoFichas(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.ProcessarAprovacaoFichas(CodOrdemServico,
    NumRemessaFicha);
end;

function TCodigosSisbov.ProcessarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha: Integer): Integer;
begin
  Result := FIntCodigosSisbov.ProcessarImpressaoCertificado(CodOrdemServico,
  NumRemessaFicha);
end;

function TCodigosSisbov.InserirEnvioCertificado(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPF: WideString; CodPropriedadeRural: Integer;
  const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
  DtaEnvio: TDateTime; const NomServicoEnvio, NumConhecimento: WideString;
  CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
  CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio,
  NumDVSisBovFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.InserirEnvioCertificado(CodPessoaProdutor, SglProdutor, NumCNPJCPF,
    CodPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov, DtaEnvio, NomServicoEnvio, NumConhecimento,
    CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalSisBovInicio, CodAnimalSisBovFim,
    NumDVSisBovInicio, NumDVSisBovFim);
end;

function TCodigosSisbov.ExcluirEnvioCertificado(CodPessoaProdutor: Integer;
  const SglProdutor, NumCNPJCPFProdutor: WideString;
  CodPropriedadeRural: Integer; const NumImovelReceitaFederal: WideString;
  CodLocalizacaoSisBov, CodPaisSisBov, CodEstadoSisBov,
  CodMicroRegiaoSisBov, CodAnimalSisBovInicio, CodAnimalSisBovFim,
  NumDVSisBovInicio, NumDBSisBovFim: Integer): Integer;
begin
  Result := FIntCodigosSisbov.ExcluirEnvioCertificado(CodPessoaProdutor, SglProdutor, NumCNPJCPFProdutor,
    CodPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisBov, CodPaisSisBov, CodEstadoSisBov,
    CodMicroRegiaoSisBov, CodAnimalSisBovInicio, CodAnimalSisBovFim, NumDVSisBovInicio, NumDBSisBovFim);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCodigosSisbov, Class_CodigosSisbov,
    ciMultiInstance, tmApartment);
end.

