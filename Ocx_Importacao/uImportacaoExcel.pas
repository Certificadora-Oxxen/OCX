unit uImportacaoExcel;

interface
                                    
uses
  ComObj, ActiveX, AspTlb, XHerdom_TLB, StdVcl, SysUtils, uErroImportacao, uIntErroImportacao,
  uIntImportacaoExcel;

type
  TImportacaoExcel = class(TASPMTSObject, IImportacaoExcel)
  private
    FIntImportacaoExcel: TIntImportacaoExcel;
    FInicializado: Boolean;
    FIntErroImportacao: TIntErroImportacao;
    FErroImportacao: TErroImportacao;
  protected
    function Get_DtaArquivoParametros: TDateTime; safecall;
    function Get_IndParametrosCarregados: Integer; safecall;
    function Get_NomCertificadora: WideString; safecall;
    function Get_NumCNPJCertificadora: WideString; safecall;
    function CarregarParametros(
      const NomArquivoParametros: WideString): Integer; safecall;
    function Inicializar(const NomArquivoDados: WideString;
      IndLimparArquivo: Integer; const CodNaturezaProdutor,
      NumCNPJCPFProdutor: WideString): Integer; safecall;
    function InserirReprodutorMultiplo(const SglFazendaManejo, CodRMManejo,
      SglEspecie, TxtObservacao: WideString): Integer; safecall;
    function InserirAnimal(const SglFazendaManejo, CodAnimalManejo,
      CodAnimalCertificadora, CodAnimalSisbov,
      SglSituacaoSisbov: WideString; DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao, SglFazendaIdentificacao: WideString;
      DtaNascimento: TDateTime; const NumImovelNascimento,
      SglFazendaNascimento: WideString; DtaCompra: TDateTime;
      const NomAnimal, DesApelido, SglAssociacaoRaca, SglGrauSangue,
      NumRGD, NumTransponder, SglTipoIdentificador1,
      SglPosicaoIdentificador1, SglTipoIdentificador2,
      SglPosicaoIdentificador2, SglTipoIdentificador3,
      SglPosicaoIdentificador3, SglTipoIdentificador4,
      SglPosicaoIdentificador4, SglAptidao, SglRaca, SglPelagem, IndSexo,
      SglTipoOrigem, SglFazendaPai, CodManejoPai, SglFazendaMae,
      CodManejoMae, SglFazendaReceptor, CodManejoReceptor,
      IndAnimalCastrado, SglRegimeAlimentar, SglCategoriaAnimal,
      SglFazendaCorrente, SglLocalCorrente, SglLoteCorrente, TxtObservacao,
      NumGTA: WideString; DtaEmissaoGTA: TDateTime; NumNotaFiscal: Integer;
      const NumCNPJCPFTecnico, IndReservado: WideString): Integer;
      safecall;
    function AlterarAnimal(const SglFazendaManejo, CodAnimalManejo,
      NomColunaAlterar, ValColunaAlterar1: WideString;
      ValColunaAlterar2: OleVariant): Integer; safecall;
    function AdicionarTouroRM(const SglFazendaManejo, CodRMManejo,
      SglFazendaAnimal, CodAnimalManejo: WideString): Integer; safecall;
    function InserirEventoMudRegimeAlimentar(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao, SglAptidao,
      SglRegimeAlimentarOrigem, SglRegimeAlimentarDestino, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoDesmame(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      SglAptidao, SglRegimeAlimentarDestino, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoMudCategoria(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao, SglAptidao,
      SglCategoriaOrigem, SglCategoriaDestino, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoSelecaoReproducao(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoCastracao(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      CodFManejo, CodManejo: WideString): Integer; safecall;
    function InserirEventoMudancaLote(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const TxtObservacao, SglFazenda,
      SglLoteDestino, CodFManejo, CodManejo: WideString): Integer;
      safecall;
    function InserirEventoMudancaLocal(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglAptidao, SglFazenda,
      SglLocalDestino, SglRegimeAlimentarMamando,
      SglRegimeAlimentarDesmamado, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoTransferencia(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglAptidao,
      SglTipoLugarOrigem, SglFazendaOrigem, NumImovelOrigem,
      NumCNPJCPFOrigem, SglTipoLugarDestino, SglFazendaDestino,
      SglLocalDestino, SglLoteDestino, NumImovelDestino, NumCNPJCPFDestino,
      SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado,
      NumGTA: WideString; DtaEmissaoGTA: TDateTime): Integer; safecall;
    function InserirEventoVendaCriador(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      NumImovelReceitaFederal, NumCNPJCPFCriador, NumGTA: WideString;
      DtaEmissaoGTA: TDateTime; const CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoVendaFrigorifico(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      NumCNPJCPFFrigorifico, NumGTA: WideString; DtaEmissaoGTA: TDateTime;
      const CodFManejo, CodManejo: WideString): Integer; safecall;
    function InserirEventoDesaparecimento(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const SglFazenda, TxtObservacao, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoMorte(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      SglTipoMorte, SglCausaMorte, CodFManejo,
      CodManejo: WideString): Integer; safecall;
    function InserirEventoPesagem(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const SglFazenda, TxtObservacao,
      CodFManejo, CodManejo: WideString; Peso: Double): Integer; safecall;
    function AplicarEventoAnimal(const CodIdentificadorEvento,
      SglFazendaManejo, CodAnimalManejo: WideString; QtdPesoAnimal: Double;
      const IndVacaPrenha, IndTouroApto: WideString): Integer; safecall;
    function Get_ErroImportacao: IErroImportacao; safecall;
    function Finalizar(IndExcluirArquivo: Integer): Integer; safecall;
    function Get_IndGerarComentarios: Integer; safecall;
    procedure Set_IndGerarComentarios(Value: Integer); safecall;
    function Pesquisar(CodTabela: Integer): Integer; safecall;
    function IrAoProximo: Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_SglEntidade: WideString; safecall;
    function Get_DesEntidade: WideString; safecall;
    function DefinirComposicaoRacial(const SglFazendaManejo, CodAnimalManejo,
      SglRaca: WideString; QtdComposicaoRacial: Double): Integer; safecall;
    function MostrarDialogAbrir(const NomeArquivo,
      Caption: WideString): WideString; safecall;
    function MostrarDialogSalvar(const NomeArquivo,
      Caption: WideString): WideString; safecall;
    function MostrarFormProgresso(const Caption, TxtInfo1,
      TxtInfo2: WideString; IndBarraProgresso, ValMinBarraProgresso,
      ValMaxBarraProgresso: Integer): Integer; safecall;
    function AtualizarFormProgresso(IndTipoInfo: Integer;
      ValInfo: OleVariant): Integer; safecall;
    function FecharFormProgresso: Integer; safecall;
    function Get_DesEntidadeRelacionada: WideString; safecall;
    function Get_SglEntidadeRelacionada: WideString; safecall;
    function PesquisaRelacionamentos(CodTabelaRelacionamentos,
      CodTabelaOrigem: Integer;
      const SglEntidadeOrigem: WideString): Integer; safecall;
    function InserirEventoCoberturaRegimePasto(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglFazenda,
      SglFazendaManejoAnimalRM,
      CodAnimalManejoAnimalRM: WideString): Integer; safecall;
    function InserirEventoDiagnosticoPrenhez(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao,
      SglFazenda: WideString): Integer; safecall;
    function InserirEventoEstacaoMonta(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglFazenda, SglEstacaoMonta,
      DesEstacaoMonta: WideString): Integer; safecall;
    function InserirEventoExameAndrologico(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao,
      SglFazenda: WideString): Integer; safecall;
    function InserirEventoCoberturaInseminacaoArtificial(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglFazenda: WideString;
      HraEvento: TDateTime; const SglFazendaManejoTouro,
      CodAnimalManejoTouro, NumPartida, SglFazendaManejoFemea,
      CodAnimalManejoFemea: WideString; QtdDoses: Integer;
      const NumCNPJCPFInseminador: WideString): Integer; safecall;
    function InserirEventoCoberturaMontaControlada(
      const CodIdentificadorEvento: WideString; DtaInicio,
      DtaFim: TDateTime; const TxtObservacao, SglFazenda,
      SglFazendaManejoTouro, CodAnimalManejoTouro, SglFazendaManejoFemea,
      CodAnimalManejoFemea: WideString): Integer; safecall;
    function InserirAnimalNaoEspecificado(const CodAnimalSisBov, IndSexo,
      SglAptidao, SglRaca: WideString; DtaNascimento: TDateTime;
      const SglTipoIdentificador1, SglPosicaoIdentificador1,
      SglTipoIdentificador2, SglPosicaoIdentificador2: WideString;
      DtaIdentificacaoSISBOV: TDateTime; const SglFazendaIdentificacao,
      NumCNPJCPFTecnico, IndEfetivar: WideString): Integer; safecall;
    function InserirEventoAvaliacao(const CodIdentificadorEvento: WideString;
      DtaInicio, DtaFim: TDateTime; const CodTipoAvaliacao,
      CodFazendaManejo, CodAnimalManejo, SglFazenda, CodTipoCaracteristica,
      ValorAvaliacao, TxtObservacao: WideString): Integer; safecall;
    function InserirInventarioAnimal(const SglFazenda,
      CodAnimalSisbov: WideString): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
//    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TImportacaoExcel.AfterConstruction;
const
  Metodo: String = 'AfterConstruction';
begin
  inherited;
  FInicializado := False;

  // Instancia e inicializa classe ErroImportacao (interna e publicada)
  Try
    FIntErroImportacao := TIntErroImportacao.Create;

    If FIntErroImportacao <> nil Then Begin
      FErroImportacao := TErroImportacao.Create;
      FErroImportacao.ObjAddRef;
      FErroImportacao.Inicializar(FIntErroImportacao);
      If Not FErroImportacao.Inicializada Then Begin
        Raise Exception.Create('Erro ao inicializar classe ErroImportacao (Classe: ' + Self.ClassName + ' Método: ' + Metodo + ')')
      End;
    End Else Begin
      Raise Exception.Create('Erro ao inicializar classe IntErroImportacao (Classe: ' + Self.ClassName + ' Método: ' + Metodo + ')')
    End;
  Except
    On E: Exception do Begin
      Raise Exception.Create('Erro ao inicializar classes de manipulação de erro (Classe: ' + Self.ClassName + ' Método: ' + Metodo + ')')
    End;
  End;

  // Instancia classe interna correspondente
  FIntImportacaoExcel := TIntImportacaoExcel.Create(FIntErroImportacao);
end;

procedure TImportacaoExcel.BeforeDestruction;
begin
  // Libera recursos das classes IntErroImportacao e ErroImportacao
  If FIntErroImportacao <> nil Then Begin
    FIntErroImportacao.Free;
    FIntErroImportacao := nil;
  End;
  If FErroImportacao <> nil Then Begin
    FErroImportacao.ObjRelease;
    FErroImportacao := nil;
  End;

  // Libera recursos da classe interna correspondente
  If FIntImportacaoExcel <> nil Then Begin
    FIntImportacaoExcel.Free;
    FIntImportacaoExcel := nil;
  End;
  inherited;
end;

function TImportacaoExcel.Get_DtaArquivoParametros: TDateTime;
begin
  Result := FIntImportacaoExcel.DtaArquivoParametros;
end;

function TImportacaoExcel.Get_IndParametrosCarregados: Integer;
begin
  Result := FIntImportacaoExcel.IndParametrosCarregados;
end;

function TImportacaoExcel.Get_NomCertificadora: WideString;
begin
  Result := FIntImportacaoExcel.NomCertificadora;
end;

function TImportacaoExcel.Get_NumCNPJCertificadora: WideString;
begin
  Result := FIntImportacaoExcel.NumCNPJCertificadora;
end;

function TImportacaoExcel.CarregarParametros(
  const NomArquivoParametros: WideString): Integer;
begin
  Result := FIntImportacaoExcel.CarregarParametros(NomArquivoParametros);
end;

function TImportacaoExcel.Inicializar(const NomArquivoDados: WideString;
  IndLimparArquivo: Integer; const CodNaturezaProdutor,
  NumCNPJCPFProdutor: WideString): Integer;
begin
  Result := FIntImportacaoExcel.Inicializar(NomArquivoDados, IndLimparArquivo,
    CodNaturezaProdutor, NumCNPJCPFProdutor);
end;

function TImportacaoExcel.InserirReprodutorMultiplo(const SglFazendaManejo,
  CodRMManejo, SglEspecie, TxtObservacao: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirReprodutorMultiplo(SglFazendaManejo,
  CodRmManejo, SglEspecie, TxtObservacao);
end;

function TImportacaoExcel.InserirAnimal(const SglFazendaManejo,
  CodAnimalManejo, CodAnimalCertificadora, CodAnimalSisbov,
  SglSituacaoSisbov: WideString; DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao, SglFazendaIdentificacao: WideString;
  DtaNascimento: TDateTime; const NumImovelNascimento,
  SglFazendaNascimento: WideString; DtaCompra: TDateTime; const NomAnimal,
  DesApelido, SglAssociacaoRaca, SglGrauSangue, NumRGD, NumTransponder,
  SglTipoIdentificador1, SglPosicaoIdentificador1, SglTipoIdentificador2,
  SglPosicaoIdentificador2, SglTipoIdentificador3,
  SglPosicaoIdentificador3, SglTipoIdentificador4,
  SglPosicaoIdentificador4, SglAptidao, SglRaca, SglPelagem, IndSexo,
  SglTipoOrigem, SglFazendaPai, CodManejoPai, SglFazendaMae, CodManejoMae,
  SglFazendaReceptor, CodManejoReceptor, IndAnimalCastrado,
  SglRegimeAlimentar, SglCategoriaAnimal, SglFazendaCorrente,
  SglLocalCorrente, SglLoteCorrente, TxtObservacao, NumGTA: WideString;
  DtaEmissaoGTA: TDateTime; NumNotaFiscal: Integer;
  const NumCNPJCPFTecnico, IndReservado: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirAnimal(SglFazendaManejo, CodAnimalManejo,
    CodAnimalCertificadora, CodAnimalSisbov, SglSituacaoSisbov,
    DtaIdentificacaoSisbov, NumImovelIdentificacao, SglFazendaIdentificacao,
    DtaNascimento, NumImovelNascimento, SglFazendaNascimento, DtaCompra,
    NomAnimal, DesApelido, SglAssociacaoRaca, SglGrauSangue, NumRGD,
    NumTransponder, SglTipoIdentificador1, SglPosicaoIdentificador1,
    SglTipoIdentificador2, SglPosicaoIdentificador2, SglTipoIdentificador3,
    SglPosicaoIdentificador3, SglTipoIdentificador4,
    SglPosicaoIdentificador4, SglAptidao, SglRaca, SglPelagem, IndSexo,
    SglTipoOrigem, SglFazendaPai, CodManejoPai,
    SglFazendaMae, CodManejoMae, SglFazendaReceptor, CodManejoReceptor,
    IndAnimalCastrado, SglRegimeAlimentar, SglCategoriaAnimal,
    SglFazendaCorrente, SglLocalCorrente, SglLoteCorrente, TxtObservacao,
    NumGTA, DtaEmissaoGTA, NumNotaFiscal, NumCNPJCPFTecnico, IndReservado);
end;

function TImportacaoExcel.AlterarAnimal(const SglFazendaManejo,
  CodAnimalManejo, NomColunaAlterar, ValColunaAlterar1: WideString;
  ValColunaAlterar2: OleVariant): Integer;
begin
  Result := FIntImportacaoExcel.AlterarAnimal(SglFazendaManejo,
                                              CodAnimalManejo,
                                              NomColunaAlterar,
                                              ValColunaAlterar1,
                                              ValColunaAlterar2);
end;

function TImportacaoExcel.AdicionarTouroRM(const SglFazendaManejo,
  CodRMManejo, SglFazendaAnimal, CodAnimalManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.AdicionarTouroRM(SglFazendaManejo, CodRMManejo,
  SglFazendaAnimal, CodAnimalManejo);
end;

function TImportacaoExcel.InserirEventoMudRegimeAlimentar(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarOrigem,
  SglRegimeAlimentarDestino, CodFManejo, CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoMudRegimeAlimentar(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarOrigem,
    SglRegimeAlimentarDestino, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoDesmame(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarDestino,
  CodFManejo, CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoDesmame(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarDestino,
    CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoMudCategoria(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, SglAptidao, SglCategoriaOrigem,
  SglCategoriaDestino, CodFManejo, CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoMudCategoria(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, SglAptidao, SglCategoriaOrigem,
    SglCategoriaDestino, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoSelecaoReproducao(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoSelecaoReproducao(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoCastracao(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoCastracao(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoMudancaLote(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda, SglLoteDestino, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoMudancaLote(CodIdentificadorEvento,
    DtaInicio, DtaFim, TxtObservacao, SglFazenda, SglLoteDestino, CodFManejo,
    CodManejo);
end;

function TImportacaoExcel.InserirEventoMudancaLocal(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglAptidao, SglFazenda, SglLocalDestino,
  SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoMudancaLocal(CodIdentificadorEvento,
    DtaInicio, DtaFim, TxtObservacao, SglAptidao, SglFazenda, SglLocalDestino,
    SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoTransferencia(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglAptidao, SglTipoLugarOrigem, SglFazendaOrigem,
  NumImovelOrigem, NumCNPJCPFOrigem, SglTipoLugarDestino,
  SglFazendaDestino, SglLocalDestino, SglLoteDestino, NumImovelDestino,
  NumCNPJCPFDestino, SglRegimeAlimentarMamando,
  SglRegimeAlimentarDesmamado, NumGTA: WideString;
  DtaEmissaoGTA: TDateTime): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoTransferencia(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglAptidao,
    SglTipoLugarOrigem, SglFazendaOrigem, NumImovelOrigem, NumCNPJCPFOrigem,
    SglTipoLugarDestino, SglFazendaDestino, SglLocalDestino, SglLoteDestino,
    NumImovelDestino, NumCNPJCPFDestino, SglRegimeAlimentarMamando,
    SglRegimeAlimentarDesmamado, NumGTA, DtaEmissaoGTA);
end;

function TImportacaoExcel.InserirEventoVendaCriador(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, NumImovelReceitaFederal,
  NumCNPJCPFCriador, NumGTA: WideString; DtaEmissaoGTA: TDateTime;
  const CodFManejo, CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoVendaCriador(
    CodIdentificadorEvento, DtaInicio, DtaFim, SglFazenda, TxtObservacao,
    NumImovelReceitaFederal, NumCNPJCPFCriador, NumGTA, DtaEmissaoGTA, CodFManejo,
    CodManejo);
end;

function TImportacaoExcel.InserirEventoVendaFrigorifico(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, NumCNPJCPFFrigorifico,
  NumGTA: WideString; DtaEmissaoGTA: TDateTime; const CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoVendaFrigorifico(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, NumCNPJCPFFrigorifico,
    NumGTA, DtaEmissaoGTA, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoDesaparecimento(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoDesaparecimento(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, CodFManejo, CodManejo);
end;

function TImportacaoExcel.InserirEventoMorte(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, SglTipoMorte, SglCausaMorte, CodFManejo,
  CodManejo: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoMorte(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, SglTipoMorte, SglCausaMorte, CodFManejo,
    CodManejo);
end;

function TImportacaoExcel.InserirEventoPesagem(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const SglFazenda, TxtObservacao, CodFManejo, CodManejo: WideString;
  Peso: Double): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoPesagem(CodIdentificadorEvento,
    DtaInicio, DtaFim, SglFazenda, TxtObservacao, CodFManejo, CodManejo, Peso);
end;

function TImportacaoExcel.AplicarEventoAnimal(const CodIdentificadorEvento,
  SglFazendaManejo, CodAnimalManejo: WideString; QtdPesoAnimal: Double;
  const IndVacaPrenha, IndTouroApto: WideString): Integer;
begin
  Result := FIntImportacaoExcel.AplicarEventoAnimal(CodIdentificadorEvento,
    SglFazendaManejo, CodAnimalManejo, QtdPesoAnimal, IndVacaPrenha,
    IndTouroApto);
end;

function TImportacaoExcel.Get_ErroImportacao: IErroImportacao;
begin
  Result := FErroImportacao;
end;

function TImportacaoExcel.Finalizar(IndExcluirArquivo: Integer): Integer;
begin
  Result := FIntImportacaoExcel.Finalizar(IndExcluirArquivo);
end;

function TImportacaoExcel.Get_IndGerarComentarios: Integer;
begin
  If FIntImportacaoExcel.IndGerarComentarios Then Begin
    Result := 1;
  End Else Begin
    Result := 0;
  end;
end;

procedure TImportacaoExcel.Set_IndGerarComentarios(Value: Integer);
begin
  If Value = 0 Then Begin
    FIntImportacaoExcel.IndGerarComentarios := False;
  End Else Begin
    FIntImportacaoExcel.IndGerarComentarios := True;
  end;
end;

function TImportacaoExcel.Pesquisar(CodTabela: Integer): Integer;
begin
  Result := FIntImportacaoExcel.Pesquisar(CodTabela);
end;

function TImportacaoExcel.IrAoProximo: Integer;
begin
  Result := FIntImportacaoExcel.IrAoProximo;
end;

function TImportacaoExcel.EOF: WordBool;
begin
  Result := FIntImportacaoExcel.EOF;
end;

function TImportacaoExcel.Get_SglEntidade: WideString;
begin
  Result := FIntImportacaoExcel.SglEntidade;
end;

function TImportacaoExcel.Get_DesEntidade: WideString;
begin
  Result := FIntImportacaoExcel.DesEntidade;
end;

function TImportacaoExcel.DefinirComposicaoRacial(const SglFazendaManejo,
  CodAnimalManejo, SglRaca: WideString;
  QtdComposicaoRacial: Double): Integer;
begin
  Result := FIntImportacaoExcel.DefinirComposicaoRacial(SglFazendaManejo,
    CodAnimalManejo, SglRaca, QtdComposicaoRacial);
end;

function TImportacaoExcel.MostrarDialogAbrir(const NomeArquivo,
  Caption: WideString): WideString;
begin
  Result := FIntImportacaoExcel.MostrarDialogAbrir(NomeArquivo, Caption);
end;

function TImportacaoExcel.MostrarDialogSalvar(const NomeArquivo,
  Caption: WideString): WideString;
begin
  Result := FIntImportacaoExcel.MostrarDialogSalvar(NomeArquivo, Caption);
end;

function TImportacaoExcel.MostrarFormProgresso(const Caption, TxtInfo1,
  TxtInfo2: WideString; IndBarraProgresso, ValMinBarraProgresso,
  ValMaxBarraProgresso: Integer): Integer;
begin
  Result := FIntImportacaoExcel.MostrarFormProgresso(Caption, TxtInfo1,
    TxtInfo2, IndBarraProgresso, ValMinBarraProgresso, ValMaxBarraProgresso);
end;

function TImportacaoExcel.AtualizarFormProgresso(IndTipoInfo: Integer;
  ValInfo: OleVariant): Integer;
begin
  Result := FIntImportacaoExcel.AtualizarFormProgresso(IndTipoInfo, ValInfo);
end;

function TImportacaoExcel.FecharFormProgresso: Integer;
begin
  Result := FIntImportacaoExcel.FecharFormProgresso;
end;

function TImportacaoExcel.Get_DesEntidadeRelacionada: WideString;
begin
  Result := FIntImportacaoExcel.DesEntidadeRelacionada;
end;

function TImportacaoExcel.Get_SglEntidadeRelacionada: WideString;
begin
  Result := FIntImportacaoExcel.SglEntidadeRelacionada;
end;

function TImportacaoExcel.PesquisaRelacionamentos(CodTabelaRelacionamentos,
  CodTabelaOrigem: Integer; const SglEntidadeOrigem: WideString): Integer;
begin
  Result := FIntImportacaoExcel.PesquisarRelacionamentos(
    CodTabelaRelacionamentos, CodTabelaOrigem, SglEntidadeOrigem);
end;

function TImportacaoExcel.InserirEventoCoberturaRegimePasto(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda, SglFazendaManejoAnimalRM,
  CodAnimalManejoAnimalRM: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoCoberturaRegimePasto(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda,
    SglFazendaManejoAnimalRM, CodAnimalManejoAnimalRM);
end;

function TImportacaoExcel.InserirEventoDiagnosticoPrenhez(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoDiagnosticoPrenhez(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda);
end;

function TImportacaoExcel.InserirEventoEstacaoMonta(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda, SglEstacaoMonta,
  DesEstacaoMonta: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoEstacaoMonta(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda,
    SglEstacaoMonta, DesEstacaoMonta);
end;

function TImportacaoExcel.InserirEventoExameAndrologico(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoExameAndrologico(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda);
end;

function TImportacaoExcel.InserirEventoCoberturaInseminacaoArtificial(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda: WideString; HraEvento: TDateTime;
  const SglFazendaManejoTouro, CodAnimalManejoTouro, NumPartida,
  SglFazendaManejoFemea, CodAnimalManejoFemea: WideString;
  QtdDoses: Integer; const NumCNPJCPFInseminador: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoCoberturaInseminacaoArtificial(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda,
    HraEvento, SglFazendaManejoTouro, CodAnimalManejoTouro, NumPartida,
    SglFazendaManejoFemea, CodAnimalManejoFemea, QtdDoses,
    NumCNPJCPFInseminador);
end;

function TImportacaoExcel.InserirEventoCoberturaMontaControlada(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const TxtObservacao, SglFazenda, SglFazendaManejoTouro,
  CodAnimalManejoTouro, SglFazendaManejoFemea,
  CodAnimalManejoFemea: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoCoberturaMontaControlada(
    CodIdentificadorEvento, DtaInicio, DtaFim, TxtObservacao, SglFazenda,
    SglFazendaManejoTouro, CodAnimalManejoTouro, SglFazendaManejoFemea,
    CodAnimalManejoFemea);
end;

function TImportacaoExcel.InserirAnimalNaoEspecificado(
  const CodAnimalSisBov, IndSexo, SglAptidao, SglRaca: WideString;
  DtaNascimento: TDateTime; const SglTipoIdentificador1,
  SglPosicaoIdentificador1, SglTipoIdentificador2,
  SglPosicaoIdentificador2: WideString; DtaIdentificacaoSISBOV: TDateTime;
  const SglFazendaIdentificacao, NumCNPJCPFTecnico,
  IndEfetivar: WideString): Integer;
begin
 Result := FIntImportacaoExcel.InserirAnimalNaoEspecifico(CodAnimalSisBov,
                                                          IndSexo,
                                                          SglAptidao,
                                                          SglRaca,
                                                          DtaNascimento,
                                                          SglTipoIdentificador1,
                                                          SglPosicaoIdentificador1,
                                                          SglTipoIdentificador2,
                                                          SglPosicaoIdentificador2,
                                                          DtaIdentificacaoSISBOV,
                                                          SglFazendaIdentificacao,
                                                          NumCNPJCPFTecnico,
                                                          IndEfetivar);
end;

function TImportacaoExcel.InserirEventoAvaliacao(
  const CodIdentificadorEvento: WideString; DtaInicio, DtaFim: TDateTime;
  const CodTipoAvaliacao, CodFazendaManejo, CodAnimalManejo, SglFazenda,
  CodTipoCaracteristica, ValorAvaliacao,
  TxtObservacao: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirEventoAvaliacao(CodIdentificadorEvento,
                                                       DtaInicio,
                                                       DtaFim,
                                                       CodTipoAvaliacao,
                                                       CodFazendaManejo,
                                                       CodAnimalManejo,
                                                       SglFazenda,
                                                       CodTipoCaracteristica,
                                                       ValorAvaliacao,
                                                       TxtObservacao)
end;

function TImportacaoExcel.InserirInventarioAnimal(const SglFazenda,
  CodAnimalSisbov: WideString): Integer;
begin
  Result := FIntImportacaoExcel.InserirInventarioAnimal(SglFazenda, CodAnimalSisbov);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacaoExcel, Class_ImportacaoExcel,
    ciMultiInstance, tmApartment);
end.
