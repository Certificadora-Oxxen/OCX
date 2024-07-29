unit uEventos;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntEventos, uIntMensagens,
  uConexao, uEvento;

type

  { TEventos }
  TEventos = class(TASPMTSObject, IEventos)
  private
    FIntEventos   : TIntEventos;
    FInicializado : Boolean;
    FEvento       : TEvento;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_Evento: IEvento; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Buscar(CodEvento: Integer;
      const IndRetornaDetalhe: WideString): Integer; safecall;
    function InserirCastracao(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function InserirDesmame(DtaEvento: TDateTime; CodAptidao,
      CodRegimeAlimentarDestino: Integer; const TxtObservacao: WideString;
      CodFazenda: Integer): Integer; safecall;
    function InserirMudCategoria(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodAptidao, CodCategoriaOrigem,
      CodCategoriaDestino, CodFazenda: Integer): Integer; safecall;
    function InserirMudRegAlimentar(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodAptidao,
      CodRegimeAlimentarOrigem, CodRegimeAlimentarDestino,
      CodFazenda: Integer): Integer; safecall;
    function InserirSelecaoReproducao(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function AlterarObservacao(CodEvento: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function InserirMudancaLote(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda,
      CodLoteDestino: Integer): Integer; safecall;
    function InserirDesaparecimento(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function InserirMorte(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodTipoMorte, CodCausaMorte,
      CodFazenda: Integer): Integer; safecall;
    function InserirMudancaLocal(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodAptidao, CodFazenda,
      CodLocalDestino, CodRegAlimentarMamando,
      CodRegAlimentarDesmamado: Integer): Integer; safecall;
    function Pesquisar(CodEvento, CodTipoEvento: Integer; DtaInicio,
      DtaFim: TDateTime; const TxtDados, CodSituacaoSisBov: WideString;
      CodFazenda: Integer; const IndAplicadoAnimais, CodOrdenacao,
      IndOrdenacaoCrescente: WideString; CodGrupoEvento: Integer): Integer;
      safecall;
    function InserirVendaCriador(DtaSaidaOrigem, DtaChegadaDestino: TDateTime;
      const TxtObservacao, NumImovelReceitaFederal,
      CodLocalizacaoSisbov: WideString; CodPropriedadeRural, CodPessoa,
      CodPessoaSecundaria: Integer; const NumCNPJCPFCriador: WideString;
      DtaEmissaoGta: TDateTime; const NumGta: WideString;
      CodFazenda: Integer; const IndEventoCertTerceira,
      CodSerieGTA: WideString; CodEstadoGTA: Integer;
      const IndMovNErasEras: WideString;
      DtaValidadeGTA: TDateTime): Integer; safecall;
    function InserirVendaFrigorifico(DtaSaidaOrigem,
      DtaChegadaDestino: TDateTime; const TxtObservacao,
      NumCNPJCPFPessoa: WideString; CodPessoa: Integer;
      DtaEmissaoGta: TDateTime; const NumGta: WideString;
      CodFazenda: Integer; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime): Integer; safecall;
    function InserirTransferencia(DtaSaidaOrigem, DtaChegadaDestino: TDateTime;
      const TxtObservacao: WideString; CodAptidao, CodTipoLugarOrigem,
      CodFazendaOrigem: Integer; const NumImovelOrigem: WideString;
      CodLocalizacaoSISBOVOrigem, CodPropriedadeOrigem: Integer;
      const NumCNPJCPFOrigem: WideString; CodPessoaOrigem,
      CodPessoaSecundariaOrigem, CodTipoLugarDestino, CodFazendaDestino,
      CodLocalDestino, CodLoteDestino: Integer;
      const NumImovelDestino: WideString; CodLocalizacaoSISBOVDestino,
      CodPropriedadeDestino: Integer; const NumCNPJCPFDestino: WideString;
      CodPessoaDestino, CodPessoaSecundariaDestino, CodRegAlimentarMamando,
      CodRegAlimentarDesmamado: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime;
      const IndMovNErasEras, IndMigrarAnimal: WideString): Integer;
      safecall;
    function EfetivarCadastro(CodEvento: Integer): Integer; safecall;
    function CancelarEfetivacao(CodEvento: Integer): Integer; safecall;
    function Excluir(CodEvento: Integer): Integer; safecall;
    function MarcarNaoGravadoSisbov(CodEvento: Integer): Integer; safecall;
    function AlterarGTA(CodEvento: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime): Integer; safecall;
    function InserirAbateAnimalVendido(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function InserirSanitario(DtaInicio, DtaFim: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function AdicionarSubEventoSanitario(CodEvento,
      CodEntradaInsumo: Integer): Integer; safecall;
    function RemoverSubEventoSanitario(CodEvento,
      CodEntradaInsumo: Integer): Integer; safecall;
    function PesquisarSubEventosSanitarios(CodEvento: Integer): Integer;
      safecall;
    function InserirEmissaoCertificado(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function PossuiMensagemOcorrenciaAplicacao(CodEvento: Integer): Integer;
      safecall;
    function Get_UltimoArquivoGerado: WideString; safecall;
    function GerarRelatorioConsolidado(const SglProdutor, NomPessoaProdutor,
      CodSituacaoSisBov: WideString; CodGrupoEvento: Integer;
      const CodTipoEvento: WideString; CodTipoSubEventoSanitario: Integer;
      DtaInicio, DtaFim: TDateTime; const TxtDados: WideString; Tipo,
      QtdQuebraRelatorio: Integer; DtaInicioCadastro, DtaFimCadastro,
      DtaInicioEfetivacao, DtaFimEfetivacao: TDateTime): WideString;
      safecall;
    function GerarRelatorioAnimaisAplicados(
      const CodSituacaoSisbovEvento: WideString; CodGrupoEvento,
      CodTipoEvento, CodTipoSubEventoSanitario, CodEvento: Integer;
      DtaInicioEvento, DtaFimEvento: TDateTime; CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
      CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
      CodAnimalSisbovInicio, CodAnimalSisbovFim: Integer;
      DtaNascimentoInicio, DtaNascimentoFim, DtaIdentificacaoInicio,
      DtaIdentificacaoFim: TDateTime; const CodRaca, CodCategoria,
      IndSexo: WideString; CodTipoLugar: Integer; const CodLocal, CodLote,
      IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
      QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
      CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo: Integer;
      const IndMostrarCriteriosPesquisa, IndAnimaisNaoAssociados,
      SemTecnico: WideString; CodPessoaTecnico: Integer): WideString;
      safecall;
    function InserirPesagem(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer): Integer;
      safecall;
    function EmitirCertificado(CodEvento,
      CodModeloCertificado: Integer): Integer; safecall;
    function InserirEstacaoMonta(DtaInicio, DtaFim: TDateTime;
      const TxtObservacao: WideString; CodFazenda: Integer;
      const SglEstacaoMonta, DesEstacaoMonta: WideString): Integer;
      safecall;
    function AlterarVendaCriador(CodEvento: Integer;
      const NumImovelReceitaFederal, CodLocalizacaoSisbov: WideString;
      CodPropriedadeRural: Integer;
      const NumCNPJCPFPessoaSecundaria: WideString; CodPessoa,
      CodPessoaSecundaria: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const IndVendaCertifTerceira,
      CodSerieGTA: WideString; CodEstadoGTA: Integer;
      const IndMovNErasEras: WideString; DtaValidadeGTA, DtaSaidaOrigem,
      DtaChegadaDestino: TDateTime): Integer; safecall;
    function AlterarVendaFrigorifico(CodEvento: Integer;
      const NumCNPJCPFFrigorifico: WideString;
      CodPessoaFrigorifico: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA, DtaSaidaOrigem,
      DtaChegadaDestino: TDateTime): Integer; safecall;
    function InserirCoberturaRegimePasto(DtaInicio, DtaFim: TDateTime;
      CodFazenda: Integer; const TxtObservacao: WideString;
      CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
      CodAnimalTouro, CodReprodutorMultiplo,
      CodEventoEstacaoMonta: Integer): Integer; safecall;
    function AlterarCoberturaRegimePasto(CodEvento: Integer; DtaFim: TDateTime;
      CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
      CodAnimalTouro, CodReprodutorMultiplo: Integer): Integer; safecall;
    function InserirDiagnosticoPrenhez(DtaEvento: TDateTime;
      CodFazenda: Integer; const TxtObservacao: WideString;
      CodEventoEstacaoMonta: Integer): Integer; safecall;
    function InserirExameAndrologico(DtaEvento: TDateTime; CodFazenda: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function InserirCoberturaMontaControlada(DtaEvento: TDateTime;
      CodFazenda: Integer; const TxtObservacao: WideString; CodAnimalTouro,
      CodFazendaManejoTouro: Integer;
      const CodAnimalManejoTouro: WideString; CodAnimalFemea,
      CodFazendaManejoFemea: Integer;
      const CodAnimalManejoFemea: WideString;
      CodEventoEstacaoMonta: Integer): Integer; safecall;
    function InserirCoberturaInseminacaoArtificial(DtaEvento,
      HraEvento: TDateTime; CodFazenda: Integer;
      const TxtObservacao: WideString; CodAnimalTouro: Integer;
      const NumPartida: WideString; CodAnimalFemea,
      CodFazendaManejoFemea: Integer;
      const CodAnimalManejoFemea: WideString; QtdDoses,
      CodPessoaSecundariaInseminador,
      CodEventoEstacaoMonta: Integer): Integer; safecall;
    function InserirAvaliacao(DtaEvento: TDateTime; CodFazenda: Integer;
      const TxtObservacao: WideString; CodTipoAvaliacao,
      CodPessoaSecAvaliador: Integer): Integer; safecall;
    function AlterarAvaliacao(CodEvento: Integer; DtaEvento: TDateTime;
      CodPessoaSecAvaliador: Integer): Integer; safecall;
    function GerarRelatorioAvaliacao(CodEvento: Integer; DtaInicioEvento,
      DtaFimEvento: TDateTime; CodTipoAvaliacao: Integer;
      const CodCaracteristicas: WideString; CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalManejoPai, NomAnimalPai,
      DesApelidoPai: WideString; CodFazendaManejoMae: Integer;
      const CodAnimalManejoMae: WideString; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; const IndSexo, CodRacas, CodCategorias,
      CodLocais, CodLotes, IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function InserirParto(DtaEvento: TDateTime; CodFazenda: Integer;
      const TxtObservacao: WideString; CodGrauDificuldade, CodSituacaoCria,
      CodEstacaoMonta: Integer; const CodAnimalManejoCria,
      IndSexoCria: WideString; CodPelagemCria: Integer;
      QtdPesagemCria: Double; const CodAnimalManejoGemeo,
      IndSexoGemeo: WideString; CodPelagemGemeo: Integer;
      QtdPesagemGemeo: Double; CodAnimalFemea,
      CodFazendaManejoFemea: Integer; const CodAnimalManejoFemea,
      IndCodSisBovReservado: WideString): WideString; safecall;
    function AlterarParto(CodEvento: Integer; DtaEvento: TDateTime;
      CodGrauDificuldade, CodCobertura: Integer): Integer; safecall;
    function PesquisarEstacoesMonta(NumMaxEventos,
      CodFazenda: Integer): Integer; safecall;
    function GerarRelatorioPrevisaoParto(CodEventoEstacaoMonta: Integer;
      const CodTipoEventosCobertura: WideString; DtaPrevistaPartoInicio,
      DtaPrevistaPartoFim: TDateTime; const CodRacas, CodCategorias,
      IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
      QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
      CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; NumOrdemInicio,
      NumOrdemFim: Integer; const CodLotes, CodLocais: WideString;
      CodFazendaManejo: Integer; const CodAnimalManejoInicio,
      CodAnimalManejoFim: WideString; CodFazendaManejoPai: Integer;
      const CodAnimalManejoPai, IndDiagnosticoPrenhez: WideString;
      Tipo: Integer): WideString; safecall;
    function PesquisarMontasParto(CodEventoParto: Integer): Integer; safecall;
    function GerarRelatorioFemeasADiagnosticar(CodEventoEstacaoMonta: Integer;
      const CodTipoEventosCobertura: WideString;
      DtaDiagnosticoPrevisto: TDateTime; const CodRacas,
      IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
      QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
      CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; NumOrdemInicio,
      NumOrdemFim: Integer; const CodLotes, CodLocais,
      CodCategorias: WideString; CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalManejoPai: WideString;
      Tipo: Integer): WideString; safecall;
    function GerarRelatorioDesempenhoVacas(CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalManejoPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalManejoMae, CodRacas,
      CodCategorias, CodLocais, CodLotes, IndAgrupRaca1: WideString;
      CodRaca1: Integer; QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; NumPartoInicio,
      NumPartoFim, NumDiasIntervaloInicio, NumDiasIntervalorFim,
      QtdPesoDesmameInicio, QtdPesoDesmameFim, Tipo: Integer): WideString;
      safecall;
    function GerarRelatorioResumoEstacaoMonta(
      CodEventoEstacaoMonta: Integer): WideString; safecall;
    function GerarRelatorioAvaliacaoInseminacao(CodEventoEstacaoMonta,
      CodFazendaManejoTouro: Integer; const CodAnimalManejoTouroInicio,
      CodAnimalManejoTouroFim, NomAnimalTouro, DesApelidoTouro, NumPartida,
      CodRacas, CodCategorias, IndAgrupRaca1: WideString;
      CodRaca1: Integer; QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; NumOrdemPartoInicio,
      NumOrdemPartoFim: Integer; const CodInseminadores: WideString; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function GerarRelatorioConsultaReprodutiva(CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
      CodFazenda: Integer; const CodEstacoes, CodRacas, CodCategorias,
      CodLocais, CodLotes, IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; NumPartosInicio,
      NumPartosFim: Integer; const CodTipoCoberturas: WideString;
      NumCoberturasInicio, NumCoberturasFim: Integer; DtaCoberturaInicio,
      DtaCoberturaFim, DtaDiagnosticoInicio, DtaDiagnosticoFim: TDateTime;
      const IndVacaPrenha, CodInseminadores: WideString;
      CodFazendaManejoTouro: Integer;
      const CodAnimalManejoTouro: WideString; DtaUltimoPartoInicio,
      DtaUltimoPartoFim: TDateTime; Tipo: Integer): WideString; safecall;
    function InserirDescarte(DtaEvento: TDateTime;
      const TxtObservacao: WideString; CodFazenda,
      CodMotivoDescarte: Integer): Integer; safecall;
    function InserirAnimaisVendidos(CodEvento: Integer): Integer; safecall;
    function AlterarRetornoFrigorifico(CodEvento: Integer;
      const NumCNPJCPFFrigorifico: WideString;
      CodPessoaFrigorifico: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime): Integer; safecall;
    function InserirRetornoFrigorifico(DtaSaidaOrigem,
      DtaChegadaDestino: TDateTime; const TxtObservacao,
      NumCNPJCPFPessoa: WideString; CodPessoa: Integer;
      DtaEmissaoGta: TDateTime; const NumGta: WideString;
      CodFazenda: Integer; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime): Integer; safecall;
    function AlterarTransferencia(CodEvento: Integer; const NumGta: WideString;
      DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
      CodEstadoGTA: Integer; const IndMovNErasEras: WideString;
      DtaValidadeGTA, DtaSaidaOrigem, DtaChegadaDestino: TDateTime;
      const IndMigrarAnimal: WideString): Integer; safecall;
    function RelatorioFormularioSaidaAnimal(CodEvento: Integer): WideString;
      safecall;
    function RelatorioFormularioAnexoXI(CodFazenda, CodEvento: Integer;
      const CodAnimais: WideString; VerificaSISBOV: Integer): WideString;
      safecall;
    function ExportarAnimaisAbcz(const CodAnimais: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
      CodSisBovFim: Integer; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; const CodRaca, CodCategoria: WideString;
      CodTipoLugar: Integer; const CodLocal, CodLote, CodManejoInicio,
      CodManejoFim, IndSexo: WideString; CodProdutor,
      CodTarefa: Integer): WideString; safecall;
    function RelatorioFormularioAnexoVI(CodProdutor,
      CodPropriedade: Integer): WideString; safecall;
    function PossuiCodigosSemelhantes(CodEvento: Integer): Integer; safecall;
    procedure InsereMorteAnimal(CodTipoMorte, CodCausaMorte: Integer;
      const CodAnimalManejo, DataMorteAnimal: WideString); safecall;
    procedure LimpaListaMorteAnimais; safecall;
    function EfetivarEventosMorte: Integer; safecall;
    procedure teste; safecall;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntEvento;

{ TEventos }

procedure TEventos.AfterConstruction;
begin
  inherited;
  FEvento := TEvento.Create;
  FEvento.ObjAddRef;
  FInicializado := False;
end;

procedure TEventos.BeforeDestruction;
begin
  If FIntEventos <> nil Then Begin
    FIntEventos.Free;
  End;
  If FEvento <> nil Then Begin
    FEvento.ObjRelease;
    FEvento := nil;
  End;
  inherited;
end;

function TEventos.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEventos := TIntEventos.Create;
  Result := FIntEventos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEventos.BOF: WordBool;
begin
  Result := FIntEventos.BOF;
end;

function TEventos.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntEventos.Deslocar(QtdRegistros);
end;

function TEventos.EOF: WordBool;
begin
  Result := FIntEventos.EOF;
end;

function TEventos.Get_Evento: IEvento;
begin
  FEvento.CodEvento := FIntEventos.IntEvento.CodEvento;
  FEvento.CodArquivoSisbov := FIntEventos.IntEvento.CodArquivoSisbov;
  FEvento.CodEvento := FIntEventos.IntEvento.CodEvento;
  FEvento.CodGrupoEvento := FIntEventos.IntEvento.CodGrupoEvento;
  FEvento.CodPessoaProdutor := FIntEventos.IntEvento.CodPessoaProdutor;
  FEvento.CodTipoEvento := FIntEventos.IntEvento.CodTipoEvento;
  FEvento.DesGrupoEvento := FIntEventos.IntEvento.DesGrupoEvento;
  FEvento.DesTipoEvento := FIntEventos.IntEvento.DesTipoEvento;
  FEvento.DtaCadastramento := FIntEventos.IntEvento.DtaCadastramento;
  FEvento.DtaEfetivacaoCadastro := FIntEventos.IntEvento.DtaEfetivacaoCadastro;
  FEvento.DtaFim := FIntEventos.IntEvento.DtaFim;
  FEvento.CodFazenda := FIntEventos.IntEvento.CodFazenda;
  FEvento.DtaGravacaoSisbov := FIntEventos.IntEvento.DtaGravacaoSisbov;
  FEvento.DtaInicio := FIntEventos.IntEvento.DtaInicio;
  FEvento.NomArquivoSisbov := FIntEventos.IntEvento.NomArquivoSisbov;
  FEvento.QtdAnimais := FIntEventos.IntEvento.QtdAnimais;
  FEvento.SglGrupoEvento := FIntEventos.IntEvento.SglGrupoEvento;
  FEvento.SglTipoEvento := FIntEventos.IntEvento.SglTipoEvento;
  FEvento.TxtDados := FIntEventos.IntEvento.TxtDados;
  FEvento.TxtObservacao := FIntEventos.IntEvento.TxtObservacao;
  FEvento.CodSituacaoSisbov := FIntEventos.IntEvento.CodSituacaoSisbov;
  FEvento.CodAptidao := FIntEventos.IntEvento.CodAptidao;
  FEvento.CodCategoria := FIntEventos.IntEvento.CodCategoria;
  FEvento.NIRF := FIntEventos.IntEvento.NIRF;
  FEvento.CodLocalizacaoSISBOV := FIntEventos.IntEvento.CodLocalizacaoSISBOV;
  FEvento.CNPJAglomeracao := FIntEventos.IntEvento.CNPJAglomeracao;
  FEvento.NomArquivoCertificado := FIntEventos.IntEvento.NomArquivoCertificado;
  FEvento.CodPropriedadeRural := FIntEventos.IntEvento.CodPropriedadeRural;
  FEvento.NomPropriedadeRural := FIntEventos.IntEvento.NomPropriedadeRural;
  FEvento.NumCNPJCPFPessoa := FIntEventos.IntEvento.NumCNPJCPFPessoa;
  FEvento.CodPessoa := FIntEventos.IntEvento.CodPessoa;
  FEvento.NomPessoa := FIntEventos.IntEvento.NomPessoa;
  FEvento.NumCNPJCPFPessoaSecundaria := FIntEventos.IntEvento.NumCNPJCPFPessoaSecundaria;
  FEvento.CodPessoaSecundaria := FIntEventos.IntEvento.CodPessoaSecundaria;
  FEvento.NomPessoaSecundaria := FIntEventos.IntEvento.NomPessoaSecundaria;
  FEvento.NumGTA := FIntEventos.IntEvento.NumGTA;
  FEvento.CodSerieGTA := FIntEventos.IntEvento.CodSerieGTA;
  FEvento.CodEstadoGTA := FIntEventos.IntEvento.CodEstadoGTA;
  FEvento.DtaEmissaoGTA := FIntEventos.IntEvento.DtaEmissaoGTA;
  FEvento.DtaValidadeGTA := FIntEventos.IntEvento.DtaValidadeGTA;
  FEvento.CodFazendaManejo := FIntEventos.IntEvento.CodFazendaManejo;
  FEvento.CodAnimalRMManejo := FIntEventos.IntEvento.CodAnimalRMManejo;
  FEvento.CodPessoaSecAvaliador := FIntEventos.IntEvento.CodPessoaSecAvaliador;
  FEvento.CodTipoAvaliacao := FIntEventos.IntEvento.CodTipoAvaliacao;
  FEvento.CodGrauDificuldade := FIntEventos.IntEvento.CodGrauDificuldade;
  FEvento.DesSituacaoCria := FIntEventos.IntEvento.DesSituacaoCria;
  FEvento.DtaEventoCobertura := FIntEventos.IntEvento.DtaEventoCobertura;
  FEvento.CodEventoCobertura := FIntEventos.IntEvento.CodEventoCobertura;
  FEvento.QtdDiasGestacao := FIntEventos.IntEvento.QtdDiasGestacao;
  FEvento.NumOrdemParto := FIntEventos.IntEvento.NumOrdemParto;
  FEvento.CodAnimalManejoCria := FIntEventos.IntEvento.CodAnimalManejoCria;
  FEvento.CodAnimalManejoGemeo := FIntEventos.IntEvento.CodAnimalManejoGemeo;
  FEvento.CodAnimalManejoTouro := FIntEventos.IntEvento.CodAnimalManejoTouro;
  FEvento.CodAnimalManejoFemea := FIntEventos.IntEvento.CodAnimalManejoFemea;
  FEvento.CodEstacaoMonta := FIntEventos.IntEvento.CodEstacaoMonta;
  FEvento.CodAnimalTouro := FIntEventos.IntEvento.CodAnimalTouro;
  FEvento.CodAnimalFemea := FIntEventos.IntEvento.CodAnimalFemea;
  FEvento.CodEventoAssociado := FIntEventos.IntEvento.CodEventoAssociado;
  FEvento.IndVendaCertifTerceira := FIntEventos.IntEvento.IndVendaCertifTerceira;
  FEvento.CodExportacaoPropriedade := FIntEventos.IntEvento.CodExportacaoPropriedade;
  FEvento.IndMovNErasEras := FIntEventos.IntEvento.IndMovNErasEras;
  FEvento.IndMigrarAnimal := FIntEventos.IntEvento.IndMigrarAnimal;
  Result := FEvento;
end;

function TEventos.NumeroRegistros: Integer;
begin
  Result := FIntEventos.NumeroRegistros;
end;

function TEventos.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntEventos.ValorCampo(NomeColuna);
end;

procedure TEventos.FecharPesquisa;
begin
  FIntEventos.FecharPesquisa;
end;

procedure TEventos.IrAoAnterior;
begin
  FIntEventos.IrAoAnterior;
end;

procedure TEventos.IrAoPrimeiro;
begin
  FIntEventos.IrAoPrimeiro;
end;

procedure TEventos.IrAoProximo;
begin
  FIntEventos.IrAoProximo;
end;

procedure TEventos.IrAoUltimo;
begin
  FIntEventos.IrAoUltimo;
end;

procedure TEventos.Posicionar(NumRegistro: Integer);
begin
  FIntEventos.Posicionar(NumRegistro);
end;

function TEventos.Buscar(CodEvento: Integer;
  const IndRetornaDetalhe: WideString): Integer;
begin
  Result := FIntEventos.Buscar(CodEvento,IndRetornaDetalhe);
end;

function TEventos.InserirCastracao(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirCastracao(DtaEvento, TxtObservacao, CodFazenda);
end;

function TEventos.InserirDesmame(DtaEvento: TDateTime; CodAptidao,
  CodRegimeAlimentarDestino: Integer; const TxtObservacao: WideString;
  CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirDesmame(DtaEvento, CodAptidao,
    CodRegimeAlimentarDestino, TxtObservacao, CodFazenda);
end;

function TEventos.InserirMudCategoria(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodAptidao, CodCategoriaOrigem,
  CodCategoriaDestino, CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirMudCategoria(DtaEvento, TxtObservacao,
    CodAptidao, CodCategoriaOrigem, CodCategoriaDestino, CodFazenda);
end;

function TEventos.InserirMudRegAlimentar(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodAptidao, CodRegimeAlimentarOrigem,
  CodRegimeAlimentarDestino, CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirMudRegAlimentar(DtaEvento, TxtObservacao,
    CodAptidao, CodRegimeAlimentarOrigem, CodRegimeAlimentarDestino,
    CodFazenda);
end;

function TEventos.InserirSelecaoReproducao(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirSelecaoReproducao(DtaEvento, TxtObservacao,
  CodFazenda);
end;

function TEventos.AlterarObservacao(CodEvento: Integer;
  const TxtObservacao: WideString): Integer;
begin
  Result := FIntEventos.AlterarObservacao(CodEvento, TxtObservacao);
end;

function TEventos.InserirMudancaLote(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda,
  CodLoteDestino: Integer): Integer;
begin
  Result := FIntEventos.InserirMudancaLote(DtaEvento, TxtObservacao,
  CodFazenda, CodLoteDestino);
end;

function TEventos.InserirDesaparecimento(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirDesaparecimento(DtaEvento, TxtObservacao,
  CodFazenda);
end;

function TEventos.InserirMorte(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodTipoMorte, CodCausaMorte,
  CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirMorte(DtaEvento, TxtObservacao,
  CodTipoMorte, CodCausaMorte, CodFazenda);
end;

function TEventos.InserirMudancaLocal(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodAptidao, CodFazenda, CodLocalDestino,
  CodRegAlimentarMamando, CodRegAlimentarDesmamado: Integer): Integer;
begin
  Result := FIntEventos.InserirMudancaLocal(DtaEvento, TxtObservacao, CodAptidao,
  CodFazenda, CodLocalDestino, CodRegAlimentarMamando, CodRegAlimentarDesmamado);
end;

function TEventos.Pesquisar(CodEvento, CodTipoEvento: Integer; DtaInicio,
  DtaFim: TDateTime; const TxtDados, CodSituacaoSisBov: WideString;
  CodFazenda: Integer; const IndAplicadoAnimais, CodOrdenacao,
  IndOrdenacaoCrescente: WideString; CodGrupoEvento: Integer): Integer;
begin
  Result := FIntEventos.Pesquisar(CodEvento, CodTipoEvento, DtaInicio,
  DtaFim, TxtDados, CodSituacaoSisBov, CodFazenda, IndAplicadoAnimais,
  CodOrdenacao, IndOrdenacaoCrescente, CodGrupoEvento);
end;

function TEventos.InserirVendaCriador(DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime; const TxtObservacao,
  NumImovelReceitaFederal, CodLocalizacaoSisbov: WideString;
  CodPropriedadeRural, CodPessoa, CodPessoaSecundaria: Integer;
  const NumCNPJCPFCriador: WideString; DtaEmissaoGta: TDateTime;
  const NumGta: WideString; CodFazenda: Integer;
  const IndEventoCertTerceira, CodSerieGTA: WideString;
  CodEstadoGTA: Integer; const IndMovNErasEras: WideString;
  DtaValidadeGTA: TDateTime): Integer;
begin
  Result := FIntEventos.InserirVendaCriador(DtaSaidaOrigem, DtaChegadaDestino,
    TxtObservacao, NumImovelReceitaFederal, CodLocalizacaoSISBOV,
    CodPropriedadeRural, CodPessoa, CodPessoaSecundaria, NumCNPJCPFCriador,
    DtaEmissaoGTA, NumGTA, CodFazenda, IndEventoCertTerceira, CodSerieGta, CodEstadoGta, IndMovNErasEras,
    DtaValidadeGTA);
end;

function TEventos.InserirVendaFrigorifico(DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime; const TxtObservacao,
  NumCNPJCPFPessoa: WideString; CodPessoa: Integer;
  DtaEmissaoGta: TDateTime; const NumGta: WideString; CodFazenda: Integer;
  const CodSerieGTA: WideString; CodEstadoGTA: Integer;
  DtaValidadeGTA: TDateTime): Integer;
begin
  Result := FIntEventos.InserirVendaFrigorifico(DtaSaidaOrigem, DtaChegadaDestino,
    TxtObservacao, NumCNPJCPFPessoa, CodPessoa, DtaEmissaoGTA, NumGTA, CodFazenda, CodSerieGta, CodEstadoGta,
    DtaValidadeGTA);
end;

function TEventos.InserirTransferencia(DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime; const TxtObservacao: WideString;
  CodAptidao, CodTipoLugarOrigem, CodFazendaOrigem: Integer;
  const NumImovelOrigem: WideString; CodLocalizacaoSISBOVOrigem,
  CodPropriedadeOrigem: Integer; const NumCNPJCPFOrigem: WideString;
  CodPessoaOrigem, CodPessoaSecundariaOrigem, CodTipoLugarDestino,
  CodFazendaDestino, CodLocalDestino, CodLoteDestino: Integer;
  const NumImovelDestino: WideString; CodLocalizacaoSISBOVDestino,
  CodPropriedadeDestino: Integer; const NumCNPJCPFDestino: WideString;
  CodPessoaDestino, CodPessoaSecundariaDestino, CodRegAlimentarMamando,
  CodRegAlimentarDesmamado: Integer; const NumGta: WideString;
  DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
  CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime; const IndMovNErasEras,
  IndMigrarAnimal: WideString): Integer;
begin
  Result := FIntEventos.InserirTransferencia(DtaSaidaOrigem, DtaChegadaDestino,
    TxtObservacao, CodAptidao, CodTipoLugarOrigem, CodFazendaOrigem,
    NumImovelOrigem, CodLocalizacaoSISBOVOrigem, CodPropriedadeOrigem,
    NumCNPJCPFOrigem, CodPessoaOrigem, CodPessoaSecundariaOrigem,
    CodTipoLugarDestino, CodFazendaDestino, CodLocalDestino, CodLoteDestino,
    NumImovelDestino, CodLocalizacaoSISBOVDestino, CodPropriedadeDestino,
    NumCNPJCPFDestino, CodPessoaDestino, CodPessoaSecundariaDestino,
    CodRegAlimentarMamando, CodRegAlimentarDesmamado, NumGTA, DtaEmissaoGTA, CodSerieGta,
    CodEstadoGta, DtaValidadeGTA, IndMovNErasEras, IndMigrarAnimal);
end;

function TEventos.EfetivarCadastro(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.EfetivarCadastro(CodEvento);
end;

function TEventos.CancelarEfetivacao(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.CancelarEfetivacao(CodEvento);
end;

function TEventos.Excluir(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.Excluir(CodEvento);
end;

function TEventos.MarcarNaoGravadoSisbov(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.MarcarNaoGravadoSisbov(CodEvento);
end;

function TEventos.AlterarGTA(CodEvento: Integer; const NumGta: WideString;
  DtaEmissaoGta: TDateTime; const CodSerieGTA: WideString;
  CodEstadoGTA: Integer; DtaValidadeGTA: TDateTime): Integer;
begin
  Result := FIntEventos.AlterarGTA(CodEvento, NumGTA, DtaEmissaoGTA, CodSerieGta, CodEstadoGta,
  DtaValidadeGTA);
end;

function TEventos.InserirAbateAnimalVendido(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirAbateAnimalVendido(DtaEvento, TxtObservacao, CodFazenda);
end;

function TEventos.InserirSanitario(DtaInicio, DtaFim: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirSanitario(DtaInicio, DtaFim, TxtObservacao, CodFazenda);
end;

function TEventos.AdicionarSubEventoSanitario(CodEvento,
  CodEntradaInsumo: Integer): Integer;
begin
  Result := FIntEventos.AdicionarSubEventoSanitario(CodEvento, CodEntradaInsumo);
end;

function TEventos.RemoverSubEventoSanitario(CodEvento,
  CodEntradaInsumo: Integer): Integer;
begin
  Result := FIntEventos.RemoverSubEventoSanitario(CodEvento, CodEntradaInsumo);
end;

function TEventos.PesquisarSubEventosSanitarios(
  CodEvento: Integer): Integer;
begin
  Result := FIntEventos.PesquisarSubEventosSanitarios(CodEvento);
end;

function TEventos.InserirEmissaoCertificado(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirEmissaoCertificado(DtaEvento, TxtObservacao, CodFazenda);
end;

function TEventos.PossuiMensagemOcorrenciaAplicacao(
  CodEvento: Integer): Integer;
begin
  Result := FIntEventos.PossuiMensagemOcorrenciaAplicacao(CodEvento);
end;

function TEventos.Get_UltimoArquivoGerado: WideString;
begin
  Result := FIntEventos.UltimoArquivoGerado;
end;

function TEventos.GerarRelatorioConsolidado(const SglProdutor,
  NomPessoaProdutor, CodSituacaoSisBov: WideString;
  CodGrupoEvento: Integer; const CodTipoEvento: WideString;
  CodTipoSubEventoSanitario: Integer; DtaInicio, DtaFim: TDateTime;
  const TxtDados: WideString; Tipo, QtdQuebraRelatorio: Integer;
  DtaInicioCadastro, DtaFimCadastro, DtaInicioEfetivacao,
  DtaFimEfetivacao: TDateTime): WideString;
begin
  Result := FIntEventos.GerarRelatorioConsolidado(SglProdutor,
    NomPessoaProdutor, CodSituacaoSisbov, CodGrupoEvento, CodTipoEvento,
    CodTipoSubEventoSanitario, DtaInicio, DtaFim, TxtDados, Tipo,
    QtdQuebraRelatorio, -1,
    DtaInicioCadastro, DtaFimCadastro,
    DtaInicioEfetivacao, DtaFimEfetivacao);
end;

function TEventos.GerarRelatorioAnimaisAplicados(
  const CodSituacaoSisbovEvento: WideString; CodGrupoEvento, CodTipoEvento,
  CodTipoSubEventoSanitario, CodEvento: Integer; DtaInicioEvento,
  DtaFimEvento: TDateTime; CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
  CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
  CodAnimalSisbovInicio, CodAnimalSisbovFim: Integer; DtaNascimentoInicio,
  DtaNascimentoFim, DtaIdentificacaoInicio, DtaIdentificacaoFim: TDateTime;
  const CodRaca, CodCategoria, IndSexo: WideString; CodTipoLugar: Integer;
  const CodLocal, CodLote, IndAgrupRaca1: WideString; CodRaca1: Integer;
  QtdCompRacialInicio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; Tipo: Integer;
  const IndMostrarCriteriosPesquisa, IndAnimaisNaoAssociados,
  SemTecnico: WideString; CodPessoaTecnico: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioAnimaisAplicados(CodSituacaoSisbovEvento,
    CodGrupoEvento, CodTipoEvento, CodTipoSubEventoSanitario, CodEvento,
    DtaInicioEvento, DtaFimEvento, CodFazendaManejo, CodAnimalManejoInicio,
    CodAnimalManejoFim, CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov,
    CodAnimalSisbovInicio, CodAnimalSisbovFim, DtaNascimentoInicio,
    DtaNascimentoFim, DtaIdentificacaoInicio, DtaIdentificacaoFim, CodRaca,
    CodCategoria, IndSexo, CodTipoLugar, CodLocal, CodLote, IndAgrupRaca1,
    CodRaca1, QtdCompRacialInicio1, QtdCompRacialFim1, IndAgrupRaca2,
    CodRaca2, QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3,
    CodRaca3, QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4,
    CodRaca4, QtdCompRacialInicio4, QtdCompRacialFim4, Tipo,
    IndMostrarCriteriosPesquisa, IndAnimaisNaoAssociados, SemTecnico, CodPessoaTecnico);
end;

function TEventos.InserirPesagem(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.InserirPesagem(DtaEvento, TxtObservacao, CodFazenda);
end;

function TEventos.EmitirCertificado(CodEvento,
  CodModeloCertificado: Integer): Integer;
begin
  Result := FIntEventos.EmitirCertificado(CodEvento, CodModeloCertificado);
end;

function TEventos.InserirEstacaoMonta(DtaInicio, DtaFim: TDateTime;
  const TxtObservacao: WideString; CodFazenda: Integer;
  const SglEstacaoMonta, DesEstacaoMonta: WideString): Integer;
begin
  Result := FIntEventos.InserirEstacaoMonta(DtaInicio, DtaFim, TxtObservacao,
    CodFazenda, SglEstacaoMonta, DesEstacaoMonta);
end;

function TEventos.AlterarVendaCriador(CodEvento: Integer;
  const NumImovelReceitaFederal, CodLocalizacaoSisbov: WideString;
  CodPropriedadeRural: Integer;
  const NumCNPJCPFPessoaSecundaria: WideString; CodPessoa,
  CodPessoaSecundaria: Integer; const NumGta: WideString;
  DtaEmissaoGta: TDateTime; const IndVendaCertifTerceira,
  CodSerieGTA: WideString; CodEstadoGTA: Integer;
  const IndMovNErasEras: WideString; DtaValidadeGTA, DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime): Integer;
begin
  Result := FIntEventos.AlterarVendaCriador(CodEvento, NumImovelReceitaFederal,
  CodLocalizacaoSISBOV, CodPropriedadeRural, NumCNPJCPFPessoaSecundaria,
  CodPessoa, CodPessoaSecundaria, NumGTA, DtaEmissaoGTA, IndVendaCertifTerceira,
  CodSerieGta, CodEstadoGta, IndMovNErasEras, DtaValidadeGTA, DtaSaidaOrigem,
  DtaChegadaDestino);
end;

function TEventos.AlterarVendaFrigorifico(CodEvento: Integer;
  const NumCNPJCPFFrigorifico: WideString; CodPessoaFrigorifico: Integer;
  const NumGta: WideString; DtaEmissaoGta: TDateTime;
  const CodSerieGTA: WideString; CodEstadoGTA: Integer; DtaValidadeGTA,
  DtaSaidaOrigem, DtaChegadaDestino: TDateTime): Integer;
begin
  Result := FIntEventos.AlterarVendaFrigorifico(CodEvento,
  NumCNPJCPFFrigorifico, CodPessoaFrigorifico, NumGTA, DtaEmissaoGTA, CodSerieGta,
  CodEstadoGta, DtaValidadeGTA, DtaSaidaOrigem, DtaChegadaDestino);
end;

function TEventos.InserirCoberturaRegimePasto(DtaInicio, DtaFim: TDateTime;
  CodFazenda: Integer; const TxtObservacao: WideString;
  CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
  CodAnimalTouro, CodReprodutorMultiplo,
  CodEventoEstacaoMonta: Integer): Integer;
begin
  Result := FIntEventos.InserirCoberturaRegimePasto(DtaInicio, DtaFim,
  CodFazenda, TxtObservacao, CodFazendaManejo, CodAnimalManejo,
  CodAnimalTouro, CodReprodutorMultiplo, CodEventoEstacaoMonta);
end;

function TEventos.AlterarCoberturaRegimePasto(CodEvento: Integer;
  DtaFim: TDateTime; CodFazendaManejo: Integer;
  const CodAnimalManejo: WideString; CodAnimalTouro,
  CodReprodutorMultiplo: Integer): Integer;
begin
  Result := FIntEventos.AlterarCoberturaRegimePasto(CodEvento, DtaFim,
  CodFazendaManejo, CodAnimalManejo, CodAnimalTouro,
  CodReprodutorMultiplo);
end;

function TEventos.InserirDiagnosticoPrenhez(DtaEvento: TDateTime;
  CodFazenda: Integer; const TxtObservacao: WideString;
  CodEventoEstacaoMonta: Integer): Integer;
begin
  Result := FIntEventos.InserirDiagnosticoPrenhez(DtaEvento,
  CodFazenda, TxtObservacao, CodEventoEstacaoMonta);
end;

function TEventos.InserirExameAndrologico(DtaEvento: TDateTime;
  CodFazenda: Integer; const TxtObservacao: WideString): Integer;
begin
  Result := FIntEventos.InserirExameAndrologico(DtaEvento,
  CodFazenda, TxtObservacao);
end;

function TEventos.InserirCoberturaMontaControlada(DtaEvento: TDateTime;
  CodFazenda: Integer; const TxtObservacao: WideString; CodAnimalTouro,
  CodFazendaManejoTouro: Integer; const CodAnimalManejoTouro: WideString;
  CodAnimalFemea, CodFazendaManejoFemea: Integer;
  const CodAnimalManejoFemea: WideString;
  CodEventoEstacaoMonta: Integer): Integer;
begin
  Result := FIntEventos.InserirCoberturaMontaControlada(DtaEvento,
  CodFazenda, TxtObservacao, CodAnimalTouro, CodFazendaManejoTouro,
  CodAnimalManejoTouro, CodAnimalFemea, CodFazendaManejoFemea,
  CodAnimalManejoFemea, CodEventoEstacaoMonta);
end;

function TEventos.InserirCoberturaInseminacaoArtificial(DtaEvento,
  HraEvento: TDateTime; CodFazenda: Integer;
  const TxtObservacao: WideString; CodAnimalTouro: Integer;
  const NumPartida: WideString; CodAnimalFemea,
  CodFazendaManejoFemea: Integer; const CodAnimalManejoFemea: WideString;
  QtdDoses, CodPessoaSecundariaInseminador,
  CodEventoEstacaoMonta: Integer): Integer;
begin
  Result := FIntEventos.InserirCoberturaInseminacaoArtificial(DtaEvento,
  HraEvento, CodFazenda, TxtObservacao, CodAnimalTouro, NumPartida,
  CodAnimalFemea, CodFazendaManejoFemea, CodAnimalManejoFemea,
  QtdDoses, CodPessoaSecundariaInseminador, CodEventoEstacaoMonta);
end;

function TEventos.InserirAvaliacao(DtaEvento: TDateTime;
  CodFazenda: Integer; const TxtObservacao: WideString; CodTipoAvaliacao,
  CodPessoaSecAvaliador: Integer): Integer;
begin
  Result := FIntEventos.InserirAvaliacao(DtaEvento, CodFazenda,
  TxtObservacao, CodTipoAvaliacao, CodPessoaSecAvaliador);
end;

function TEventos.AlterarAvaliacao(CodEvento: Integer;
  DtaEvento: TDateTime; CodPessoaSecAvaliador: Integer): Integer;
begin
  Result := FIntEventos.AlterarAvaliacao(CodEvento, DtaEvento,
  CodPessoaSecAvaliador);
end;

function TEventos.GerarRelatorioAvaliacao(CodEvento: Integer;
  DtaInicioEvento, DtaFimEvento: TDateTime; CodTipoAvaliacao: Integer;
  const CodCaracteristicas: WideString; CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalManejoPai, NomAnimalPai,
  DesApelidoPai: WideString; CodFazendaManejoMae: Integer;
  const CodAnimalManejoMae: WideString; DtaNascimentoInicio,
  DtaNascimentoFim: TDateTime; const IndSexo, CodRacas, CodCategorias,
  CodLocais, CodLotes, IndAgrupRaca1: WideString; CodRaca1: Integer;
  QtdCompRacialInicio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioAvaliacao(CodEvento, DtaInicioEvento,
    DtaFimEvento, CodTipoAvaliacao, CodCaracteristicas, CodFazendaManejo,
    CodAnimalManejoInicio, CodAnimalManejoFim, CodFazendaManejoPai,
    CodAnimalManejoPai, NomAnimalPai, DesApelidoPai, CodFazendaManejoMae,
    CodAnimalManejoMae, DtaNascimentoInicio, DtaNascimentoFim, IndSexo,
    CodRacas, CodCategorias, CodLocais, CodLotes, IndAgrupRaca1, CodRaca1,
    QtdCompRacialInicio1, QtdCompRacialFim1, IndAgrupRaca2, CodRaca2,
    QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3, CodRaca3,
    QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4, CodRaca4,
    QtdCompRacialInicio4, QtdCompRacialFim4, Tipo, QtdQuebraRelatorio, -1, -1);
end;

function TEventos.InserirParto(DtaEvento: TDateTime; CodFazenda: Integer;
  const TxtObservacao: WideString; CodGrauDificuldade, CodSituacaoCria,
  CodEstacaoMonta: Integer; const CodAnimalManejoCria,
  IndSexoCria: WideString; CodPelagemCria: Integer; QtdPesagemCria: Double;
  const CodAnimalManejoGemeo, IndSexoGemeo: WideString;
  CodPelagemGemeo: Integer; QtdPesagemGemeo: Double; CodAnimalFemea,
  CodFazendaManejoFemea: Integer; const CodAnimalManejoFemea,
  IndCodSisBovReservado: WideString): WideString;
begin
  Result := FIntEventos.InserirParto(DtaEvento, CodFazenda, TxtObservacao,
  CodGrauDificuldade, CodSituacaoCria, CodEstacaoMonta, CodAnimalManejoCria,
  IndSexoCria, CodPelagemCria, QtdPesagemCria, CodAnimalManejoGemeo, IndSexoGemeo,
  CodPelagemGemeo, QtdPesagemGemeo, CodAnimalFemea, CodFazendaManejoFemea,
  CodAnimalManejoFemea, IndCodSisBovReservado);
end;

function TEventos.AlterarParto(CodEvento: Integer; DtaEvento: TDateTime;
  CodGrauDificuldade, CodCobertura: Integer): Integer;
begin
  Result := FIntEventos.AlterarParto(CodEvento, DtaEvento,
  CodGrauDificuldade, CodCobertura);
end;

function TEventos.PesquisarEstacoesMonta(NumMaxEventos,
  CodFazenda: Integer): Integer;
begin
  Result := FIntEventos.PesquisarEstacoesMonta(NumMaxEventos, CodFazenda);
end;

function TEventos.GerarRelatorioPrevisaoParto(
  CodEventoEstacaoMonta: Integer;
  const CodTipoEventosCobertura: WideString; DtaPrevistaPartoInicio,
  DtaPrevistaPartoFim: TDateTime; const CodRacas, CodCategorias,
  IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double;
  NumOrdemInicio, NumOrdemFim: Integer; const CodLotes,
  CodLocais: WideString; CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalManejoPai,
  IndDiagnosticoPrenhez: WideString; Tipo: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioPrevisaoParto(CodEventoEstacaoMonta,
    CodTipoEventosCobertura, DtaPrevistaPartoInicio, DtaPrevistaPartoFim,
    CodRacas, CodCategorias, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
    QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
    QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
    QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
    QtdCompRacialFim4, NumOrdemInicio, NumOrdemFim, CodLotes, CodLocais,
    CodFazendaManejo, CodAnimalManejoInicio, CodAnimalManejoFim,
    CodFazendaManejoPai, CodAnimalManejoPai, Tipo, -1, -1, IndDiagnosticoPrenhez);
end;

function TEventos.PesquisarMontasParto(CodEventoParto: Integer): Integer;
begin
  Result := FIntEventos.PesquisarMontasParto(CodEventoParto);
end;

function TEventos.GerarRelatorioFemeasADiagnosticar(
  CodEventoEstacaoMonta: Integer;
  const CodTipoEventosCobertura: WideString;
  DtaDiagnosticoPrevisto: TDateTime; const CodRacas,
  IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double;
  NumOrdemInicio, NumOrdemFim: Integer; const CodLotes, CodLocais,
  CodCategorias: WideString; CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalManejoPai: WideString;
  Tipo: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioFemeasADiagnosticar(
    CodEventoEstacaoMonta, CodTipoEventosCobertura, DtaDiagnosticoPrevisto,
    CodRacas, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
    QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
    QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
    QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
    QtdCompRacialFim4, NumOrdemInicio, NumOrdemFim, CodLotes, CodLocais,
    CodCategorias, CodFazendaManejo, CodAnimalManejoInicio, CodAnimalManejoFim,
    CodFazendaManejoPai, CodAnimalManejoPai, Tipo, -1, -1);
end;

function TEventos.GerarRelatorioDesempenhoVacas(CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalManejoPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalManejoMae, CodRacas,
  CodCategorias, CodLocais, CodLotes, IndAgrupRaca1: WideString;
  CodRaca1: Integer; QtdCompRacialInicio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; NumPartoInicio, NumPartoFim,
  NumDiasIntervaloInicio, NumDiasIntervalorFim, QtdPesoDesmameInicio,
  QtdPesoDesmameFim, Tipo: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioDesempenhoVacas(CodFazendaManejo,
    CodAnimalManejoInicio, CodAnimalManejoFim, CodFazendaManejoPai,
    CodAnimalManejoPai, CodFazendaManejoMae, CodAnimalManejoMae, CodRacas,
    CodCategorias, CodLocais, CodLotes, IndAgrupRaca1, CodRaca1,
    QtdCompRacialInicio1, QtdCompRacialFim1, IndAgrupRaca2, CodRaca2,
    QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3, CodRaca3,
    QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4, CodRaca4,
    QtdCompRacialInicio4, QtdCompRacialFim4, NumPartoInicio, NumPartoFim,
    NumDiasIntervaloInicio, NumDiasIntervalorFim, QtdPesoDesmameInicio,
    QtdPesoDesmameFim, Tipo, -1, -1);
end;

function TEventos.GerarRelatorioResumoEstacaoMonta(
  CodEventoEstacaoMonta: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioResumoEstacaoMonta(CodEventoEstacaoMonta, -1, -1);
end;

function TEventos.GerarRelatorioAvaliacaoInseminacao(CodEventoEstacaoMonta,
  CodFazendaManejoTouro: Integer; const CodAnimalManejoTouroInicio,
  CodAnimalManejoTouroFim, NomAnimalTouro, DesApelidoTouro, NumPartida,
  CodRacas, CodCategorias, IndAgrupRaca1: WideString; CodRaca1: Integer;
  QtdCompRacialInicio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; NumOrdemPartoInicio,
  NumOrdemPartoFim: Integer; const CodInseminadores: WideString; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioAvaliacaoInseminacao(
    CodEventoEstacaoMonta, CodFazendaManejoTouro, CodAnimalManejoTouroInicio,
    CodAnimalManejoTouroFim, NomAnimalTouro, DesApelidoTouro, NumPartida,
    CodRacas, CodCategorias, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
    QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
    QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
    QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
    QtdCompRacialFim4, NumOrdemPartoInicio, NumOrdemPartoFim, CodInseminadores,
    Tipo, QtdQuebraRelatorio);
end;

function TEventos.GerarRelatorioConsultaReprodutiva(
  CodFazendaManejo: Integer; const CodAnimalManejoInicio,
  CodAnimalManejoFim: WideString; CodFazenda: Integer; const CodEstacoes,
  CodRacas, CodCategorias, CodLocais, CodLotes, IndAgrupRaca1: WideString;
  CodRaca1: Integer; QtdCompRacialInicio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; NumPartosInicio, NumPartosFim: Integer;
  const CodTipoCoberturas: WideString; NumCoberturasInicio,
  NumCoberturasFim: Integer; DtaCoberturaInicio, DtaCoberturaFim,
  DtaDiagnosticoInicio, DtaDiagnosticoFim: TDateTime; const IndVacaPrenha,
  CodInseminadores: WideString; CodFazendaManejoTouro: Integer;
  const CodAnimalManejoTouro: WideString; DtaUltimoPartoInicio,
  DtaUltimoPartoFim: TDateTime; Tipo: Integer): WideString;
begin
  Result := FIntEventos.GerarRelatorioConsultaReprodutiva(CodFazendaManejo,
    CodAnimalManejoInicio, CodAnimalManejoFim, CodFazenda, CodEstacoes,
    CodRacas, CodCategorias, CodLocais, CodLotes, IndAgrupRaca1, CodRaca1,
    QtdCompRacialInicio1, QtdCompRacialFim1, IndAgrupRaca2, CodRaca2,
    QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3, CodRaca3,
    QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4, CodRaca4,
    QtdCompRacialInicio4, QtdCompRacialFim4, NumPartosInicio, NumPartosFim,
    CodTipoCoberturas, NumCoberturasInicio, NumCoberturasFim,
    DtaCoberturaInicio, DtaCoberturaFim, DtaDiagnosticoInicio,
    DtaDiagnosticoFim, IndVacaPrenha, CodInseminadores, CodFazendaManejoTouro,
    CodAnimalManejoTouro, DtaUltimoPartoInicio, DtaUltimoPartoFim, Tipo);
end;

function TEventos.InserirDescarte(DtaEvento: TDateTime;
  const TxtObservacao: WideString; CodFazenda,
  CodMotivoDescarte: Integer): Integer;
begin
  Result := FIntEventos.InserirDescarte(DtaEvento, TxtObservacao,
    CodFazenda, CodMotivoDescarte);
end;

function TEventos.InserirAnimaisVendidos(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.InserirAnimaisVendidos(CodEvento);
end;

function TEventos.AlterarRetornoFrigorifico(CodEvento: Integer;
  const NumCNPJCPFFrigorifico: WideString; CodPessoaFrigorifico: Integer;
  const NumGta: WideString; DtaEmissaoGta: TDateTime;
  const CodSerieGTA: WideString; CodEstadoGTA: Integer;
  DtaValidadeGTA: TDateTime): Integer;
begin
  Result := FIntEventos.AlterarRetornoFrigorifico(CodEvento,
  NumCNPJCPFFrigorifico, CodPessoaFrigorifico, NumGTA, DtaEmissaoGTA, CodSerieGta,
  CodEstadoGta, DtaValidadeGTA);
end;

function TEventos.InserirRetornoFrigorifico(DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime; const TxtObservacao,
  NumCNPJCPFPessoa: WideString; CodPessoa: Integer;
  DtaEmissaoGta: TDateTime; const NumGta: WideString; CodFazenda: Integer;
  const CodSerieGTA: WideString; CodEstadoGTA: Integer;
  DtaValidadeGTA: TDateTime): Integer;
begin
  Result := FIntEventos.InserirRetornoFrigorifico(DtaSaidaOrigem, DtaChegadaDestino,
    TxtObservacao, NumCNPJCPFPessoa, CodPessoa, DtaEmissaoGTA, NumGTA, CodFazenda,
    CodSerieGta, CodEstadoGta, DtaValidadeGTA);
end;

function TEventos.AlterarTransferencia(CodEvento: Integer;
  const NumGta: WideString; DtaEmissaoGta: TDateTime;
  const CodSerieGTA: WideString; CodEstadoGTA: Integer;
  const IndMovNErasEras: WideString; DtaValidadeGTA, DtaSaidaOrigem,
  DtaChegadaDestino: TDateTime;
  const IndMigrarAnimal: WideString): Integer;
begin
  Result := FIntEventos.AlterarTransferencia(CodEvento, NumGta, DtaEmissaoGta,
  CodSerieGta, CodEstadoGta, IndMovNErasEras, DtaValidadeGta, DtaSaidaOrigem,
  DtaChegadaDestino, IndMigrarAnimal);
end;

function TEventos.RelatorioFormularioSaidaAnimal(
  CodEvento: Integer): WideString;
begin
  Result := FIntEventos.RelatorioFormularioSaidaAnimal(CodEvento);
end;

function TEventos.RelatorioFormularioAnexoXI(CodFazenda,
  CodEvento: Integer; const CodAnimais: WideString;
  VerificaSISBOV: Integer): WideString;
begin
  Result := FIntEventos.RelatorioFormularioAnexoXI(CodFazenda, CodEvento, CodAnimais, VerificaSISBOV);
end;

function TEventos.ExportarAnimaisAbcz(const CodAnimais: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
  CodSisBovFim: Integer; DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
  const CodRaca, CodCategoria: WideString; CodTipoLugar: Integer;
  const CodLocal, CodLote, CodManejoInicio, CodManejoFim,
  IndSexo: WideString; CodProdutor, CodTarefa: Integer): WideString;
begin
  Result := FIntEventos.ExportarAnimaisAbcz(CodAnimais, CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodSisbovInicio,
                                            CodSisbovFim, DtaNascimentoInicio, DtaNascimentoFim,
                                            CodRaca, CodCategoria, CodTipoLugar, CodLocal, CodLote, CodManejoInicio, CodManejoFim,
                                            IndSexo, CodProdutor, CodTarefa);
end;

function TEventos.RelatorioFormularioAnexoVI(CodProdutor,
  CodPropriedade: Integer): WideString;
begin
  Result := FIntEventos.RelatorioFormularioAnexoVI(CodProdutor, CodPropriedade);
end;

function TEventos.PossuiCodigosSemelhantes(CodEvento: Integer): Integer;
begin
  Result := FIntEventos.PossuiCodigosSemelhantes(CodEvento);
end;

procedure TEventos.InsereMorteAnimal(CodTipoMorte, CodCausaMorte: Integer;
  const CodAnimalManejo, DataMorteAnimal: WideString);
begin
  FIntEventos.InsereMorteAnimal(CodTipoMorte,CodCausaMorte,CodAnimalManejo,DataMorteAnimal);
end;

procedure TEventos.LimpaListaMorteAnimais;
begin
  FIntEventos.LimpaListaMorteAnimais;
end;

function TEventos.EfetivarEventosMorte: Integer;
begin
  result  :=  FIntEventos.EfetivaEventosMorte;
end;

procedure TEventos.teste;
var tmp:TInfoEvento;
begin
  FIntEventos.GeraCertificados(tmp,1);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEventos, Class_Eventos,
    ciMultiInstance, tmApartment);
end.
