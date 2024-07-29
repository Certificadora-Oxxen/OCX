unit uImportacao;

interface

uses Sysutils, Dialogs, Forms, StdCtrls, ComCtrls,
     uETabErro, uArquivo, uIntErroImportacao, Variants,
     uFerramentas;

const
  tab_situacao_sisbov          =  1;
  tab_associacao_raca          =  2;
  tab_grau_sangue              =  3;
  tab_assoc_raca_grau_sangue   =  4;
  tab_tipo_identificador       =  5;
  tab_posicao_identificador    =  6;
  tab_tipo_lugar               =  7;
  tab_especie                  =  8;
  tab_aptidao                  =  9;
  tab_raca                     = 10;
  tab_raca_aptidao             = 11;
  tab_pelagem                  = 12;
  tab_tipo_origem              = 13;
  tab_regime_alimentar         = 14;
  tab_regime_alimentar_aptidao = 15;
  tab_categoria_animal         = 16;
  tab_categoria_animal_aptidao = 17;
  tab_tipo_evento              = 18;
  tab_tipo_morte               = 19;
  tab_causa_morte              = 20;
  tab_tipo_causa_morte         = 21;
  tab_grupo_identificador      = 22;
  tab_grupo_posicao_ident      = 23;
  tab_associacao_raca_raca     = 24;
  tab_atributo_alteracao       = 100;

type
  TPesquisa = (pNaoRealizada, pNormal, pRelacionamentos);
  TMetodoPesquisa = (mpNaoExecutado, mpPesquisar, mpPesquisarRelacionamentos);

  TCodManejo = record
    SglFazenda: String;
    CodManejo: String;
  end;

  TAnimal = record
    CodAnimalManejo: TCodManejo;
    CodAnimalCertificadora: String;
    CodAnimalSisbov: String;
  end;

  TTouroRM = record
    CodRMManejo: TCodManejo;
    CodAnimalManejo: TCodManejo;
  end;

  TEvento = record
    CodIdentificadorEvento: String;
    IndEventoPesagem: Boolean;
    IndEventoAvaliacao: Boolean;
    IndEventoDiagnosticoPrenhez: Boolean;
    IndEventoExameAndrologico: Boolean;
  end;

  TAnimalEvento = record
    CodIdentificadorEvento: String;
    CodAnimalManejo: TCodManejo;
  end;

  TComposicaoRacial = record
    CodAnimalManejo: TCodManejo;
    SglRaca: String;
  end;

  TInventarioAnimal = record
    SglFazenda: String;
    CodAnimalSisbov: String;
  end;

  {TIntImportacao}
  TImportacao = class(TObject)
  private
    // Tabelas de registro de informações gravadas
    FPar: array of array of array of variant;
    FRMs: array of TCodManejo;
    FAnimais: array of TAnimal;
    FTourosRM: array of TTouroRM;
    FEventos: array of TEvento;
    FAnimaisEvento: array of TAnimalEvento;
    FComposicoesRaciais: array of TComposicaoRacial;
    FInventariosAnimais: array of TInventarioAnimal;

    // Indexadores de tabelas
    FIndRMs: Integer;
    FIndAnimais: Integer;
    FIndTourosRM: Integer;
    FIndEventos: Integer;
    FIndAnimaisEvento: Integer;
    FIndComposicoesRaciais: Integer;
    FIndInventariosAnimais: Integer;

    // Pesquisa
    FTabelaCorrente: Integer;
    FIndiceCorrente: Integer;
    FTabPai: Integer;
    FTabFilho: Integer;
    FColPai: Integer;
    FColFilho: Integer;
    FCodPai: Variant;
    FCodFilho: Variant;
    FPosSglEntidade: Integer;
    FPosDesEntidade: Integer;
    FPosSglEntidadeRelacionada: Integer;
    FPosDesEntidadeRelacionada: Integer;
    FEOF: Boolean;
    FSglEntidade: String;
    FDesEntidade: String;
    FSglEntidadeRelacionada: String;
    FDesEntidadeRelacionada: String;
    FChaveRelacionamento: Variant;
    FUltimaPesquisa: TPesquisa;
    FMetodoPesquisa: TMetodoPesquisa;

    // Form Progresso
    FrmProgresso: TForm;
    LbInfo1: TLabel;
    LbInfo2: TLabel;
    Barra: TProgressBar;
    BtCancelar: TButton;
    FIndCancelar: Boolean;

    // Processamento
    FArquivoEscrita: TArquivoEscrita;
    FIntErroImportacao : TIntErroImportacao;
    FInicializado: Boolean;
    FIndParametrosCarregados: Integer;
    FDtaArquivoParametros: TDatetime;
    FNomCertificadora: String;
    FNumCNPJCertificadora: String;
    FIndGerarComentarios: Boolean;
    FUltimoTipoLinha: Integer;
    FNomArquivoEscrita: String;
    FUltimaFazenda: String;
    FUltimoAnimal: String;
    FSeqEvento: Integer;
    FUltimaData: TDatetime;
    FUltimaTipoMorte: String;
    FUltimaCausaMorte: String;
    FUltimaAptidao: String;
    FUltimoRegimeAD: String;
    FUltimoRegimeAO: String;
    FUltimaAptidaoL: String;
    FUltimaLocal: String;
    FUltimaRAM: String;
    FUltimaRAD: String;
    FUltimoLote: String;
    FUltimoCategD: String;
    FUltimoCategO: String;
    FUltimaDataCheg: TDatetime;
    FUltimaDataSaid: TDatetime;
    FUltimaAvaliacao: String;
    FUltimoEvento: Integer;
    FUltimoNirf: String;
    FUltimoCpfCnpj: String;
    FUltimoNumGTA: String;
    FUltimaDataGTA: TDatetime;
    FQtdCompRacial: Extended;
    //

    // Operações com tabelas de parâmetros
    function TabelaValida(Tabela: Integer): Boolean;
    function DesTabela(Tabela: Integer): String;
    function SglToVal(Tabela: Integer; Sgl: String; Col: Integer; RaiseErro: Boolean): Variant;
    function CodToVal(Tabela: Integer; Cod: Variant; Col: Integer; RaiseErro: Boolean): Variant;
    function SglToCod(Tabela: Integer; Sgl: String; RaiseErro: Boolean): Variant;
    function CodToDes(Tabela: Integer; Cod: Variant; RaiseErro: Boolean): String;
    function ExisteRelacionamento(TabelaRelacionamento, Tabela1, Tabela2: Integer;
      Sgl1, Sgl2: String; RaiseErro: Boolean): Boolean;

    // Operações de gerenciamento de pesquisas
    procedure InverterPaiFilho;
    function ObterRelacionamento: Integer;
    function LocalizarRelacionamento: Integer;

    // Operações com tabelas de registro de informações gravadas
    function RegistrarRM(SglFazendaManejo, CodRMManejo: String): Integer;
    function RegistrarAnimal(SglFazendaManejo, CodAnimalManejo, CodAnimalCertificadora,
      CodAnimalSisbov: String): Integer;

    function RegistrarAnimalNaoEspecificado(CodAnimalSisbov: String): Integer;

    function RegistrarTouroRM(SglFazendaManejo, CodRMManejo, SglFazendaAnimal,
      CodAnimalManejo: String): Integer;
    function RegistrarEvento(CodIdentificadorEvento: String; IndEventoPesagem,
      IndEventoDiagnosticoPrenhez, IndEventoExameAndrologico,
      IndEventoAvaliacao: Boolean): Integer;
    function RegistrarAnimalEvento(CodIdentificadorEvento, SglFazendaManejo,
      CodAnimalManejo: String): Integer;
    function RegistrarComposicaoRacial(SglFazendaManejo, CodAnimalManejo,
      SglRaca: String): Integer;
    function RegistrarInventarioAnimal(SglFazenda, CodAnimalSisbov: String): Integer;

    function ExisteRM(SglFazendaManejo, CodRMManejo: String): Boolean;
    function ExisteAnimal(SglFazendaManejo, CodAnimalManejo, CodAnimalCertificadora,
      CodAnimalSisbov: String): Integer;
    function ExisteAnimalNaoEspecificado(CodAnimalSisbov: String): Integer;

    function ExisteTouroRM(SglFazendaManejo, CodRMManejo, SglFazendaAnimal, CodAnimalManejo: String): Boolean;
    function ExisteEvento(CodIdentificadorEvento: String): Boolean;
    function EEventoEspecial(CodIdentificadorEvento: String): Integer;
    function ExisteAnimalEvento(CodIdentificadorEvento, SglFazendaManejo,
      CodAnimalManejo: String): Boolean;
    function ExisteComposicaoRacial(SglFazendaManejo, CodAnimalManejo,
      SglRaca: String): Boolean;
    function ExisteInventarioAnimal(SglFazenda, CodAnimalSisbov: String): Boolean;

    function VerificarSisbov(var CodAnimalSisbov: String): Integer;
    function VerificarCNPJCPF(NumCNPJCPF: String): Integer;
    procedure FrmProgressoClose(Sender: TObject; var Action: TCloseAction);
    procedure BtCancelarClick(Sender: TObject);

    property UltimaPesquisa: TPesquisa read FUltimaPesquisa write FUltimaPesquisa;
    property MetodoPesquisa: TMetodoPesquisa read FMetodoPesquisa write FMetodoPesquisa;
  protected
    procedure RaiseNaoInicializado(Metodo: String);
    function ehNumerico(valor: String): boolean;
    function ValidaNirfIncra(nirfIncra: String; IndObrigatorio: Boolean): Boolean;

  public
    constructor Create(IntErroImportacao: TIntErroImportacao); virtual;
    destructor Destroy; override;

    function CarregarParametros(NomArquivoParametros: String): Integer;
    function Inicializar(NomArquivoDados: String; IndLimparArquivo: Integer;
      CodNaturezaProdutor, NumCNPJCPFProdutor: String): Integer;
    function Finalizar(IndExcluirArquivo: Integer): Integer;

    function InserirReprodutorMultiplo(SglFazendaManejo, CodRMManejo,
      SglEspecie, TxtObservacao: String): Integer;

    function InserirAnimal(SglFazendaManejo, CodAnimalManejo,
      CodAnimalCertificadora, CodAnimalSisbov,
      SglSituacaoSisbov: String; DtaIdentificacaoSisbov: TDateTime;
      NumImovelIdentificacao, SglFazendaIdentificacao: String;
      DtaNascimento: TDateTime; NumImovelNascimento,
      SglFazendaNascimento: String; DtaCompra: TDateTime;
      NomAnimal, DesApelido, SglAssociacaoRaca, SglGrauSangue,
      NumRGD, NumTransponder, SglTipoIdentificador1,
      SglPosicaoIdentificador1, SglTipoIdentificador2,
      SglPosicaoIdentificador2, SglTipoIdentificador3,
      SglPosicaoIdentificador3, SglTipoIdentificador4,
      SglPosicaoIdentificador4, SglAptidao, SglRaca, SglPelagem, IndSexo,
      SglTipoOrigem, SglFazendaPai, CodManejoPai,
      SglFazendaMae, CodManejoMae, SglFazendaReceptor,
      CodManejoReceptor, IndAnimalCastrado, SglRegimeAlimentar,
      SglCategoriaAnimal, SglFazendaCorrente, SglLocalCorrente,
      SglLoteCorrente, TxtObservacao, NumGTA: String;
      DtaEmissaoGTA: TDateTime; NumnotaFiscal: Integer;
      NumCNPJCPFTecnico, IndEfetivar: String): Integer;

    function AlterarAnimal(SglFazendaManejo, CodAnimalManejo, NomColunaAlterar,
      ValColunaAlterar1: String; ValColunaAlterar2: Variant): Integer;

    function AdicionarTouroRM(SglFazendaManejo, CodRMManejo,
      SglFazendaAnimal, CodAnimalManejo: String): Integer;

    function InserirEventoMudRegimeAlimentar(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarOrigem,
      SglRegimeAlimentarDestino, CodFManejo, CodManejo: String): Integer;

    function InserirEventoDesmame(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, SglAptidao,
      SglRegimeAlimentarDestino, CodFManejo, CodManejo: String): Integer;

    function InserirEventoMudCategoria(CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; SglFazenda, TxtObservacao, SglAptidao, SglCategoriaOrigem,
      SglCategoriaDestino, CodFManejo, CodManejo: String): Integer;

    function InserirEventoSelecaoReproducao(CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo, CodManejo: String): Integer;

    function InserirEventoCastracao(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo,
      CodManejo: String): Integer;

    function InserirEventoMudancaLote(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; TxtObservacao, SglFazenda,
      SglLoteDestino, CodFManejo, CodManejo: String): Integer;

    function InserirEventoMudancaLocal(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; TxtObservacao, SglAptidao, SglFazenda,
      SglLocalDestino, SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado,
      CodFManejo, CodManejo: String): Integer;

    function InserirEventoTransferencia(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao, SglAptidao,
      SglTipoLugarOrigem, SglFazendaOrigem, NumImovelOrigem,
      NumCNPJCPFOrigem, SglTipoLugarDestino, SglFazendaDestino,
      SglLocalDestino, SglLoteDestino, NumImovelDestino, NumCNPJCPFDestino,
      SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado,
      NumGTA: String; DtaEmissaoGTA: TDateTime): Integer;

    function InserirEventoVendaCriador(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao,
      NumImovelReceitaFederal, NumCNPJCPFCriador, NumGTA: String;
      DtaEmissaoGTA: TDateTime; CodFManejo, CodManejo: String): Integer;

    function InserirEventoVendaFrigorifico(CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; SglFazenda, TxtObservacao, NumCNPJCPFFrigorifico, NumGTA: String;
      DtaEmissaoGTA: TDateTime; CodFManejo, CodManejo: String): Integer;

    function InserirEventoDesaparecimento(CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo, CodManejo: String): Integer;

    function InserirEventoMorte(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, SglTipoMorte,
      SglCausaMorte, CodFManejo, CodManejo: String): Integer;

    function InserirEventoPesagem(CodIdentificadorEvento: String;
      DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo,
      CodManejo: String; Peso: Double): Integer;

    function InserirEventoCoberturaRegimePasto(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao, SglFazenda,
      SglFazendaManejoAnimalRM,
      CodAnimalManejoAnimalRM: String): Integer; 

    function InserirEventoDiagnosticoPrenhez(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao,
      SglFazenda: String): Integer; 

    function InserirEventoEstacaoMonta(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao, SglFazenda, SglEstacaoMonta,
      DesEstacaoMonta: String): Integer; 

    function InserirEventoExameAndrologico(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao,
      SglFazenda: String): Integer;

    function AplicarEventoAnimal(CodIdentificadorEvento,
      SglFazendaManejo, CodAnimalManejo: String; QtdPesoAnimal: Double;
      IndVacaPrenha, IndTouroApto: String): Integer;

    function InserirEventoCoberturaInseminacaoArtificial(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao, SglFazenda: String;
      HraEvento: TDateTime; SglFazendaManejoTouro,
      CodAnimalManejoTouro, NumPartida, SglFazendaManejoFemea,
      CodAnimalManejoFemea: String; QtdDoses: Integer;
      NumCNPJCPFInseminador: String): Integer;

    function InserirEventoCoberturaMontaControlada(
      CodIdentificadorEvento: String; DtaInicio,
      DtaFim: TDateTime; TxtObservacao, SglFazenda,
      SglFazendaManejoTouro, CodAnimalManejoTouro, SglFazendaManejoFemea,
      CodAnimalManejoFemea: String): Integer;

    function Pesquisar(CodTabela: Integer): Integer;

    function PesquisarRelacionamentos(CodTabelaRelacionamentos,
      CodTabelaOrigem: Integer; SglEntidadeOrigem: String): Integer;

    function IrAoProximo: Integer;

    function EOF: Boolean;

    function DefinirComposicaoRacial(SglFazendaManejo, CodAnimalManejo,
      SglRaca: String; QtdComposicaoRacial: Extended): Integer;    function MostrarDialogAbrir(NomeArquivo, Caption: String): String;

    function MostrarDialogSalvar(NomeArquivo, Caption: String): String;

    function MostrarFormProgresso(Caption, TxtInfo1, TxtInfo2: String;
      IndBarraProgresso, ValMinBarraProgresso, ValMaxBarraProgresso: Integer): Integer;

    function AtualizarFormProgresso(IndTipoInfo: Integer; ValInfo: Variant): Integer;

    function InserirAnimalNaoEspecifico(ECodAnimalSISBOV, EIndSexo,
      ESglAptidao, ESglRaca: String;
      EDtaNascimento: TDateTime; ESglTipoIdentificador1,
      ESglPosicaoIdentificador1, ESglTipoIdentificador2,
      ESglPosicaoIdentificador2: String;
      EDtaIdentificacaoSISBOV: TDateTime; ESglFazendaIdentificacao,
      ENumCNPJCPFTecnico, EIndEfetivar: String): Integer;

    function InserirEventoAvaliacao(ECodIdentificadorEvento: String; EDtaInicio,
      EDtaFim: TDateTime; ECodTipoAvaliacao: String; ECodFazendaManejo,
      ECodAnimalManejo, ESglFazenda: String;
      ECodTipoCaracteristica: String; EValorAvaliacao: String;
      ETxtObservacao: String): Integer;

    function FecharFormProgresso: Integer;

    function InserirInventarioAnimal(SglFazenda, CodAnimalSisbov: String): Integer;

    property IntErroImportacao: TIntErroImportacao read FIntErroImportacao write FIntErroImportacao;
    property Inicializado: Boolean            read FInicializado;
    property IndParametrosCarregados: Integer read FIndParametrosCarregados;
    property DtaArquivoParametros: TDateTime  read FDtaArquivoParametros;
    property NomCertificadora: String         read FNomCertificadora;
    property NumCNPJCertificadora: String     read FNumCNPJCertificadora;
    property IndGerarComentarios: Boolean     read FIndGerarComentarios write FIndGerarComentarios;

    property SglEntidade: String              read FSglEntidade;
    property DesEntidade: String              read FDesEntidade;
    property SglEntidadeRelacionada: String   read FSglEntidadeRelacionada;
    property DesEntidadeRelacionada: String   read FDesEntidadeRelacionada;
  end;

implementation

{ TIntImportacao }
constructor TImportacao.Create(IntErroImportacao: TIntErroImportacao);
const
  Metodo: String = 'Create';
begin
  if IntErroImportacao <> nil then begin
    FIntErroImportacao := IntErroImportacao;
  end else begin
    FInicializado := False;
    Raise exception.Create('Parâmetro IntErroImportacao informado para criação da classe ' +
      Self.ClassName + ' é inválido (Classe: ' + Self.ClassName + ' Método: ' + Metodo + ')');
    Exit;
  end;

  // Inicializa indexadores de tabelas
  FIndRMs := 0;
  FIndAnimais := 0;
  FIndTourosRM := 0;
  FIndEventos := 0;
  FIndAnimaisEvento := 0;
  FIndComposicoesRaciais := 0;
  FIndInventariosAnimais := 0;

  // Objetos da form progresso
  FrmProgresso := nil;
  LbInfo1 := nil;
  LbInfo2 := nil;
  Barra := nil;
  BtCancelar := nil;
  FIndCancelar := False;

  FArquivoEscrita := TArquivoEscrita.Create;
  FUltimaPesquisa := pNaoRealizada;
  FMetodoPesquisa := mpNaoExecutado;
  FInicializado := False;
  FIndParametrosCarregados := 0;
  FDtaArquivoParametros := 0;
  FNomCertificadora := '';
  FNumCNPJCertificadora := '';
  FIndGerarComentarios := True;
  FUltimoTipoLinha := 0;
  FTabelaCorrente := 0;
  FIndiceCorrente := 0;
  FTabPai := -1;
  FTabFilho := -1;
  FColPai := -1;
  FColFilho := -1;
  FCodPai := Unassigned;
  FCodFilho := Unassigned;
  FPosSglEntidade := -1;
  FPosDesEntidade := -1;
  FPosSglEntidadeRelacionada := -1;
  FPosDesEntidadeRelacionada := -1;
  FChaveRelacionamento := Unassigned;
  FEOF := True;
end;

destructor TImportacao.Destroy;
begin
  Finalize(FPar);
  if FrmProgresso <> nil then begin
    // Os componentes da form são liberados por ela pois ela é Owner deles
    FrmProgresso.Free;
  end;
  FArquivoEscrita.Free;
  inherited;
end;

function TImportacao.TabelaValida(Tabela: Integer): Boolean;
begin
  Result := False;
  if (Tabela - 1 >= Low(FPar)) and (Tabela - 1 <= High(FPar)) then begin
    if Length(FPar[Tabela - 1]) > 0 then begin
      Result := True;
      Exit;
    end;
  end;
end;

function TImportacao.DesTabela(Tabela: Integer): String;
begin
  Result := 'Tabela ' + IntToStr(Tabela) + ' inválida';

  if TabelaValida(Tabela) then begin
    Case Tabela of
      tab_situacao_sisbov          : Result := 'Situação SISBOV';
      tab_associacao_raca          : Result := 'Associação de Raça';
      tab_grau_sangue              : Result := 'Grau de Sangue';
      tab_assoc_raca_grau_sangue   : Result := 'Relacionamento entre Associação de Raça e Grau de Sangue';
      tab_tipo_identificador       : Result := 'Tipo de Identificador';
      tab_posicao_identificador    : Result := 'Posição de Identificador';
      tab_tipo_lugar               : Result := 'Tipo de Lugar';
      tab_especie                  : Result := 'Espécie';
      tab_aptidao                  : Result := 'Aptidão';
      tab_raca                     : Result := 'Raça';
      tab_raca_aptidao             : Result := 'Relacionamento entre Raça e Aptidão';
      tab_pelagem                  : Result := 'Pelagem';
      tab_tipo_origem              : Result := 'Tipo de Origem';
      tab_regime_alimentar         : Result := 'Regime Alimentar';
      tab_regime_alimentar_aptidao : Result := 'Relacionamento entre Regime Alimentar e Aptidão';
      tab_categoria_animal         : Result := 'Categoria de Animal';
      tab_categoria_animal_aptidao : Result := 'Relacionamento entre Categoria de Animal e Aptidão';
      tab_tipo_evento              : Result := 'Tipo de Evento';
      tab_tipo_morte               : Result := 'Tipo de Morte';
      tab_causa_morte              : Result := 'Causa de Morte';
      tab_tipo_causa_morte         : Result := 'Tipo de Causa de Morte';
      tab_grupo_identificador      : Result := 'Grupo de identificadores';
      tab_grupo_posicao_ident      : Result := 'Relacionamento entre grupo e posição de identificador';
      tab_atributo_alteracao       : Result := 'Atributo para Alteração de Animal';
      tab_associacao_raca_raca     : Result := 'Relacionamento entre Associações de raça e Raças';
    end;
  end;
end;

function TImportacao.SglToVal(Tabela: Integer; Sgl: String; Col: Integer;
  RaiseErro: Boolean): Variant;
const
  Metodo: String = 'SglToVal';
var
  X, IndColSgl : Integer;
begin
  Result := null;

  // Verifica validade da tabela
  if not TabelaValida(Tabela) then begin
    Raise ETabErro.CreateErro(Tabela, 19, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Verifica se coluna é válida
  if ((Col - 1) < Low(FPar[Tabela - 1][Low(FPar[Tabela - 1])])) or ((Col - 1) > High(FPar[Tabela - 1][Low(FPar[Tabela - 1])])) then begin
    Raise ETabErro.CreateErro(Tabela, 24, [IntToStr(Col), Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  Sgl := Trim(Sgl);

  // Configura coluna de sigla
  Case Tabela of
    tab_associacao_raca,
    tab_grau_sangue,
    tab_tipo_identificador,
    tab_posicao_identificador,
    tab_tipo_lugar,
    tab_especie,
    tab_aptidao,
    tab_raca,
    tab_pelagem,
    tab_tipo_origem,
    tab_regime_alimentar,
    tab_categoria_animal,
    tab_tipo_evento,
    tab_tipo_morte,
    tab_causa_morte:
      begin
        IndColSgl := 2;
      end;

    tab_situacao_sisbov,
    tab_grupo_identificador:
      begin
        IndColSgl := 1;
      end;

    tab_atributo_alteracao:
      begin
        IndColSgl := 2;
      end;
  else
    Raise ETabErro.CreateErro(Tabela, 22, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Procura informação na tabela
  For X := Low(FPar[Tabela - 1]) to High(FPar[Tabela - 1]) do begin
    if Uppercase(FPar[Tabela - 1][X][IndColSgl - 1]) = Uppercase(Sgl) then begin
      Result := FPar[Tabela - 1][X][Col - 1];
      Exit;
    end;
  end;

  if RaiseErro then begin
    Raise ETabErro.CreateErro(Tabela, 21, [DesTabela(Tabela), Sgl]);
    Exit;
  end;
end;

function TImportacao.CodToVal(Tabela: Integer; Cod: Variant; Col: Integer;
  RaiseErro: Boolean): Variant;
const
  Metodo: String = 'CodToVal';
var
  X, IndColCod : Integer;
begin
  Result := '';

  // Verifica validade da tabela
  if not TabelaValida(Tabela) then begin
    Raise ETabErro.CreateErro(Tabela, 19, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Verifica se coluna é válida
  if ((Col - 1) < Low(FPar[Tabela - 1][Low(FPar[Tabela - 1])])) or ((Col - 1) > High(FPar[Tabela - 1][Low(FPar[Tabela - 1])])) then begin
    Raise ETabErro.CreateErro(Tabela, 24, [IntToStr(Col), Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Configura coluna de código
  IndColCod := 1;

  // Procura informação na tabela
  For X := Low(FPar[Tabela - 1]) to High(FPar[Tabela - 1]) do begin
    if FPar[Tabela - 1][X][IndColCod - 1] = Cod then begin
      Result := FPar[Tabela - 1][X][Col - 1];
      Exit;
    end;
  end;
  if RaiseErro then begin
    Raise ETabErro.CreateErro(Tabela, 21, [DesTabela(Tabela), IntToStr(Cod)]);
    Exit;
  end;
end;

function TImportacao.SglToCod(Tabela: Integer; Sgl: String; RaiseErro: Boolean): Variant;
const
  Metodo: String = 'SglToCod';
var
  X, IndColCod, IndColSgl : Integer;
begin
  Result := null;

  // Verifica validade da tabela
  if not TabelaValida(Tabela) then begin
    Raise ETabErro.CreateErro(Tabela, 19, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  Sgl := Trim(Sgl);

  // Configura colunas de código e sigla
  Case Tabela of
    tab_situacao_sisbov,
    tab_grupo_identificador:
      begin
        IndColCod := 1;
        IndColSgl := 1;
        Result := '';
      end;

    tab_associacao_raca,
    tab_grau_sangue,
    tab_tipo_identificador,
    tab_posicao_identificador,
    tab_tipo_lugar,
    tab_especie,
    tab_aptidao,
    tab_raca,
    tab_pelagem,
    tab_tipo_origem,
    tab_regime_alimentar,
    tab_categoria_animal,
    tab_tipo_evento,
    tab_tipo_morte,
    tab_causa_morte:
      begin
        IndColCod := 1;
        IndColSgl := 2;
        Result := -1;
      end;

    tab_atributo_alteracao:
      begin
        IndColCod := 1;
        IndColSgl := 2;
        Result := -1;
      end;
  else
    Raise ETabErro.CreateErro(Tabela, 22, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  if Trim(Sgl) = '' then begin
    Exit;
  end;

  // Procura informação na tabela
  For X := Low(FPar[Tabela - 1]) to High(FPar[Tabela - 1]) do begin
    if Uppercase(FPar[Tabela - 1][X][IndColSgl - 1]) = Uppercase(Sgl) then begin
      Result := FPar[Tabela - 1][X][IndColCod - 1];
      Exit;
    end;
  end;

  if RaiseErro then begin
    Raise ETabErro.CreateErro(Tabela, 21, [DesTabela(Tabela), Sgl]);
    Exit;
  end;
end;

function TImportacao.CodToDes(Tabela: Integer; Cod: Variant; RaiseErro: Boolean): String;
const
  Metodo: String = 'CodToDes';
var
  X, IndColCod, IndColDes : Integer;
begin
  Result := '';

  // Verifica validade da tabela
  if not TabelaValida(Tabela) then begin
    Raise ETabErro.CreateErro(Tabela, 19, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Configura colunas de código e descrição
  Case Tabela of
    tab_situacao_sisbov,
    tab_associacao_raca,
    tab_grau_sangue,
    tab_tipo_identificador,
    tab_posicao_identificador,
    tab_tipo_lugar,
    tab_especie,
    tab_aptidao,
    tab_raca,
    tab_pelagem,
    tab_tipo_origem,
    tab_regime_alimentar,
    tab_categoria_animal,
    tab_tipo_evento,
    tab_tipo_morte,
    tab_causa_morte:
      begin
        IndColCod := 1;
        IndColDes := 3;
      end;

    tab_grupo_identificador:
      begin
        IndColCod := 1;
        IndColDes := 2;
      end;

    tab_atributo_alteracao:
      begin
        IndColCod := 1;
        IndColDes := 2;
      end;
  else
    Raise ETabErro.CreateErro(Tabela, 20, [Metodo, DesTabela(Tabela)]);
    Exit;
  end;

  // Procura informação na tabela
  For X := Low(FPar[Tabela - 1]) to High(FPar[Tabela - 1]) do begin
    if FPar[Tabela - 1][X][IndColCod - 1] = Cod then begin
      Result := FPar[Tabela - 1][X][IndColDes - 1];
      Exit;
    end;
  end;
  if RaiseErro then begin
    Raise ETabErro.CreateErro(Tabela, 21, [DesTabela(Tabela), IntToStr(Cod)]);
    Exit;
  end;
end;

function TImportacao.ExisteRelacionamento(TabelaRelacionamento, Tabela1,
  Tabela2: Integer; Sgl1, Sgl2: String; RaiseErro: Boolean): Boolean;
const
  Metodo: String = 'ExisteRelacionamento';
var
  X: Integer;
  Cod1, Cod2: Variant;
begin
  Result := False;

  // Verifica validade das tabelas
  if not TabelaValida(TabelaRelacionamento) then begin
    Raise ETabErro.CreateErro(TabelaRelacionamento, 19, [Metodo, DesTabela(TabelaRelacionamento)]);
    Exit;
  end;
  if not TabelaValida(Tabela1) then begin
    Raise ETabErro.CreateErro(Tabela1, 19, [Metodo, DesTabela(Tabela1)]);
    Exit;
  end;
  if not TabelaValida(Tabela2) then begin
    Raise ETabErro.CreateErro(Tabela2, 19, [Metodo, DesTabela(Tabela2)]);
    Exit;
  end;

  Cod1 := SglToCod(Tabela1, Sgl1, True);
  Cod2 := SglToCod(Tabela2, Sgl2, True);

  // Procura informação na tabela
  For X := Low(FPar[TabelaRelacionamento - 1]) to High(FPar[TabelaRelacionamento - 1]) do begin
    if (FPar[TabelaRelacionamento - 1][X][0] = Cod1) and (FPar[TabelaRelacionamento - 1][X][1] = Cod2) then begin
      Result := True;
      Exit;
    end;
  end;
  if RaiseErro then begin
    Raise ETabErro.CreateErro(TabelaRelacionamento, 32, [DesTabela(Tabela1), CodToDes(Tabela1, Cod1, True), DesTabela(Tabela2), CodToDes(Tabela2, Cod2, True)]);
    Exit;
  end;
end;

procedure TImportacao.InverterPaiFilho;
var
  iTabPai, iColPai, iPosSglEntidade, iPosDesEntidade: Integer;
begin
  iTabPai := FTabPai;
  iColPai := FColPai;
  iPosSglEntidade := FPosSglEntidade;
  iPosDesEntidade := FPosDesEntidade;
  FTabPai := FTabFilho;
  FColPai := FColFilho;
  FPosSglEntidade := FPosSglEntidadeRelacionada;
  FPosDesEntidade := FPosDesEntidadeRelacionada;
  FTabFilho := iTabPai;
  FColFilho := iColPai;
  FPosSglEntidadeRelacionada := iPosSglEntidade;
  FPosDesEntidadeRelacionada := iPosDesEntidade;
end;

function TImportacao.ObterRelacionamento: Integer;
const
  Metodo: String = 'ObterRelacionamento';
var
  Cod: Variant;
begin
  try
    Cod := FPar[FTabelaCorrente - 1][FIndiceCorrente][FColPai - 1];
    if (VarType(Cod) <> VarType(FCodPai)) or (Cod <> FCodPai) then begin
      FCodPai := Cod;
      if FPosSglEntidade > 0 then begin
        FSglEntidade := CodToVal(FTabPai, Cod, FPosSglEntidade, True);
      end else begin
        FSglEntidade := '';
      end;
      if FPosDesEntidade > 0 then begin
        FDesEntidade := CodToVal(FTabPai, Cod, FPosDesEntidade, True);
      end else begin
        FDesEntidade := '';
      end;
    end;
    Cod := FPar[FTabelaCorrente - 1][FIndiceCorrente][FColFilho - 1];
    if (VarType(Cod) <> VarType(FCodFilho)) or (Cod <> FCodFilho) then begin
      FCodFilho := Cod;
      if FPosSglEntidadeRelacionada > 0 then begin
        FSglEntidadeRelacionada := CodToVal(FTabFilho, Cod, FPosSglEntidadeRelacionada, True);
      end else begin
        FSglEntidadeRelacionada := '';
      end;
      if FPosDesEntidadeRelacionada > 0 then begin
        FDesEntidadeRelacionada := CodToVal(FTabFilho, Cod, FPosDesEntidadeRelacionada, True);
      end else begin
        FDesEntidadeRelacionada := '';
      end;
    end;
    Result := 0;
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      Result := FIntErroImportacao.SetErro(140, [E.Message]);
      Exit;
    end;
  end;
end;

function TImportacao.Pesquisar(CodTabela: Integer): Integer;
const
  Metodo: String = 'Pesquisar';
begin
  Result := 0;

  if FIndParametrosCarregados = 0 then begin
    Result := FIntErroImportacao.SetErro(15);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';
  FUltimoAnimal  := '';

  MetodoPesquisa := mpPesquisar;
  FSglEntidade := '';
  FDesEntidade := '';
  FSglEntidadeRelacionada := '';
  FDesEntidadeRelacionada := '';
  if not TabelaValida(CodTabela) then begin
    FTabelaCorrente := 0;
    Result := FIntErroImportacao.SetErro(19, [Metodo, IntToStr(CodTabela)]);
    Exit;
  end;

  // Iniciliza identificadores para pesquisa
  FTabPai := -1;
  FTabFilho := -1;
  FColPai := -1;
  FColFilho := -1;
  FCodPai := Unassigned;
  FCodFilho := Unassigned;
  FPosSglEntidade := -1;
  FPosDesEntidade := -1;
  FPosSglEntidadeRelacionada := -1;
  FPosDesEntidadeRelacionada := -1;
  FChaveRelacionamento := Unassigned;

  // Configura colunas de Sigla e descrição
  Case CodTabela of
    tab_situacao_sisbov:
      begin
        UltimaPesquisa := pNormal;
        FPosSglEntidade := 1;
        FPosDesEntidade := 3;
      end;

    tab_assoc_raca_grau_sangue:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_associacao_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_grau_sangue;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
      end;

    tab_raca_aptidao:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
      end;

    tab_regime_alimentar_aptidao:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_regime_alimentar;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
      end;

    tab_categoria_animal_aptidao:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_categoria_animal;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
      end;

    tab_tipo_causa_morte:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_tipo_morte;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_causa_morte;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
      end;

    tab_grupo_posicao_ident:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_posicao_identificador;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_grupo_identificador;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := -1;
        FPosDesEntidadeRelacionada := 2;
      end;

    tab_associacao_raca_raca:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_associacao_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_raca;
        FColFilho := 2;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
      end;

    tab_associacao_raca,
    tab_grau_sangue,
    tab_tipo_identificador,
    tab_posicao_identificador,
    tab_tipo_lugar,
    tab_especie,
    tab_aptidao,
    tab_raca,
    tab_pelagem,
    tab_tipo_origem,
    tab_regime_alimentar,
    tab_categoria_animal,
    tab_tipo_evento,
    tab_tipo_morte,
    tab_causa_morte,
    tab_atributo_alteracao:
      begin
        UltimaPesquisa := pNormal;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
      end;
  else
    FTabelaCorrente := 0;
    Result := FIntErroImportacao.SetErro(116, [Metodo, IntToStr(CodTabela)]);
    Exit;
  end;

  if Length(FPar[CodTabela - 1]) = 0 then begin
    FTabelaCorrente := 0;
    FEOF := True;
    Result := FIntErroImportacao.SetErro(117, [DesTabela(CodTabela)]);
    Exit;
  end;

  FTabelaCorrente := CodTabela;
  FIndiceCorrente := Low(FPar[FTabelaCorrente - 1]);
  case UltimaPesquisa of
    pNormal:
      begin
        FSglEntidade := FPar[FTabelaCorrente - 1][FIndiceCorrente][FPosSglEntidade - 1];
        FDesEntidade := FPar[FTabelaCorrente - 1][FIndiceCorrente][FPosDesEntidade - 1];
        FSglEntidadeRelacionada := '';
        FDesEntidadeRelacionada := '';
      end;
    pRelacionamentos:
      begin
        ObterRelacionamento;
      end;
  end;
  FEOF := False;
end;

function TImportacao.LocalizarRelacionamento: Integer;
const
  Metodo: String = 'LocalizarRelacionamento';
var
  Cod: Variant;
begin
  Result := 0;
  if FEOF then Exit;
  try
    while (True) do begin
      if FIndiceCorrente > High(FPar[FTabelaCorrente - 1]) then begin
        Dec(FIndiceCorrente);
        FEOF := True;
        Exit;
      end;
      Cod := FPar[FTabelaCorrente - 1][FIndiceCorrente][FColPai - 1];
      if VarType(Cod) = VarType(FChaveRelacionamento) then begin
        if Cod = FChaveRelacionamento then begin
          Break;
        end;
      end;
      Inc(FIndiceCorrente);
    end;
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      Result := FIntErroImportacao.SetErro(140, [E.Message]);
      Exit;
    end;
  end;
end;

function TImportacao.PesquisarRelacionamentos(CodTabelaRelacionamentos,
  CodTabelaOrigem: Integer; SglEntidadeOrigem: String): Integer;
const
  Metodo: String = 'PesquisarRelacionamentos';
begin
  if FIndParametrosCarregados = 0 then begin
    Result := FIntErroImportacao.SetErro(15);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';  
  FUltimoAnimal  := '';

  MetodoPesquisa := mpPesquisarRelacionamentos;
  FSglEntidade := '';
  FDesEntidade := '';
  FSglEntidadeRelacionada := '';
  FDesEntidadeRelacionada := '';
  if not TabelaValida(CodTabelaRelacionamentos) then begin
    FTabelaCorrente := 0;
    Result := FIntErroImportacao.SetErro(19, [Metodo, IntToStr(CodTabelaRelacionamentos)]);
    Exit;
  end;

  // Iniciliza identificadores para pesquisa
  FTabPai := -1;
  FTabFilho := -1;
  FColPai := -1;
  FColFilho := -1;
  FCodPai := Unassigned;
  FCodFilho := Unassigned;
  FPosSglEntidade := -1;
  FPosDesEntidade := -1;
  FPosSglEntidadeRelacionada := -1;
  FPosDesEntidadeRelacionada := -1;
  FChaveRelacionamento := Unassigned;

  // Configura colunas de Sigla e descrição
  Case CodTabelaRelacionamentos of
    tab_assoc_raca_grau_sangue:
      begin
        FTabPai := tab_associacao_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_grau_sangue;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
        if CodTabelaOrigem = tab_grau_sangue then begin
          InverterPaiFilho;
        end;
      end;

    tab_raca_aptidao:
      begin
        FTabPai := tab_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
        if CodTabelaOrigem = tab_aptidao then begin
          InverterPaiFilho;
        end;
      end;

    tab_regime_alimentar_aptidao:
      begin
        FTabPai := tab_regime_alimentar;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
        if CodTabelaOrigem = tab_aptidao then begin
          InverterPaiFilho;
        end;
      end;

    tab_categoria_animal_aptidao:
      begin
        UltimaPesquisa := pRelacionamentos;
        FTabPai := tab_categoria_animal;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_aptidao;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
        if CodTabelaOrigem = tab_aptidao then begin
          InverterPaiFilho;
        end;
      end;

    tab_tipo_causa_morte:
      begin
        FTabPai := tab_tipo_morte;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_causa_morte;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := 2;
        FPosDesEntidadeRelacionada := 3;
        if CodTabelaOrigem = tab_causa_morte then begin
          InverterPaiFilho;
        end;
      end;

    tab_grupo_posicao_ident:
      begin
        FTabPai := tab_posicao_identificador;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_grupo_identificador;
        FColFilho := 2;
        FPosSglEntidadeRelacionada := -1;
        FPosDesEntidadeRelacionada := 2;
        if CodTabelaOrigem = tab_grupo_identificador then begin
          InverterPaiFilho;
        end;
      end;

    tab_associacao_raca_raca:
      begin
        FTabPai := tab_associacao_raca;
        FColPai := 1;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
        FTabFilho := tab_raca;
        FColFilho := 2;
        FPosSglEntidade := 2;
        FPosDesEntidade := 3;
      end;
  else
    FTabelaCorrente := 0;
    Result := FIntErroImportacao.SetErro(116, [Metodo, IntToStr(CodTabelaRelacionamentos)]);
    Exit;
  end;

  if Length(FPar[CodTabelaRelacionamentos - 1]) = 0 then begin
    FTabelaCorrente := 0;
    FEOF := True;
    Result := FIntErroImportacao.SetErro(117, [DesTabela(CodTabelaRelacionamentos)]);
    Exit;
  end;

  try
    FChaveRelacionamento := SglToCod(CodTabelaOrigem, SglEntidadeOrigem, True);
  except
    on E: ETabErro Do begin
      Result := FIntErroImportacao.SetErro(E);
      FTabelaCorrente := 0;
      FEOF := True;
      Exit;
    end;
    on E: exception Do begin
      Result := FIntErroImportacao.SetErro(140, [E.Message]);
      FTabelaCorrente := 0;
      FEOF := True;
      Exit;
    end;
  end;

  UltimaPesquisa := pRelacionamentos;
  FTabelaCorrente := CodTabelaRelacionamentos;
  FIndiceCorrente := Low(FPar[FTabelaCorrente - 1]);
  FEOF := False;

  Result := LocalizarRelacionamento;
  if Result < 0 then Exit;

  if FEOF then begin
    FTabelaCorrente := 0;
    FEOF := True;
    Result := FIntErroImportacao.SetErro(117, [DesTabela(CodTabelaRelacionamentos)]);
    Exit;
  end;

  ObterRelacionamento;
end;

function TImportacao.IrAoProximo: Integer;
const
  Metodo: String = 'IrAoProximo';
begin
  Result := 0;

  if FIndParametrosCarregados = 0 then begin
    Result := FIntErroImportacao.SetErro(15);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';  
  FUltimoAnimal  := '';

  if FTabelaCorrente = 0 then begin
    FEOF := True;
    Result := FIntErroImportacao.SetErro(115);
    Exit;
  end;

  if FEOF then begin
    Exit;
  end;

  Inc(FIndiceCorrente);
  Case MetodoPesquisa of
    mpPesquisar:
      begin
        if FIndiceCorrente > High(FPar[FTabelaCorrente - 1]) then begin
          Dec(FIndiceCorrente);
          FEOF := True;
          Exit;
        end;
      end;
    mpPesquisarRelacionamentos:
      begin
        LocalizarRelacionamento;
      end;
  end;

  Case UltimaPesquisa of
    pNormal:
      begin
        FSglEntidade := FPar[FTabelaCorrente - 1][FIndiceCorrente][FPosSglEntidade - 1];
        FDesEntidade := FPar[FTabelaCorrente - 1][FIndiceCorrente][FPosDesEntidade - 1];
        FSglEntidadeRelacionada := '';
        FDesEntidadeRelacionada := '';
      end;
    pRelacionamentos:
      begin
        ObterRelacionamento;
      end;
  end;
end;

function TImportacao.EOF: Boolean;
begin
  Result := FEOF;
end;

function TImportacao.ExisteRM(SglFazendaManejo,
  CodRMManejo: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FRMs) > 0 then begin
    For X := Low(FRMs) to FIndRMs - 1 do begin
      if (FRMs[X].SglFazenda = Uppercase(SglFazendaManejo)) and
         (FRMs[X].CodManejo  = Uppercase(CodRMManejo)) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TImportacao.ExisteAnimal(SglFazendaManejo, CodAnimalManejo,
  CodAnimalCertificadora, CodAnimalSisbov: String): Integer;
var
  X : Integer;
begin
  Result := 0;
  if Length(FAnimais) > 0 then begin
    For X := Low(FAnimais) to FIndAnimais - 1 do begin
      if (FAnimais[X].CodAnimalManejo.SglFazenda = Uppercase(SglFazendaManejo)) and
         (FAnimais[X].CodAnimalManejo.CodManejo  = Uppercase(CodAnimalManejo)) then begin
        Result := 1; // Existe animal com este código de manejo
        Exit;
      end;
      if Trim(CodAnimalCertificadora) <> '' then begin
        if FAnimais[X].CodAnimalCertificadora = Uppercase(Trim(CodAnimalCertificadora)) then begin
          Result := 2; // Existe animal com este código de certificadora
          Exit;
        end;
      end;
      if Trim(CodAnimalSisbov) <> '' then begin
        if FAnimais[X].CodAnimalSisbov = Uppercase(Trim(CodAnimalSisbov)) then begin
          Result := 3; // Existe animal com este código Sisbov
          Exit;
        end;
      end;
    end;
  end;
end;

function TImportacao.ExisteTouroRM(SglFazendaManejo, CodRMManejo,
  SglFazendaAnimal, CodAnimalManejo: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FTourosRM) > 0 then begin
    For X := Low(FTourosRM) to FIndTourosRM - 1 do begin
      if (FTourosRM[X].CodRMManejo.SglFazenda = Uppercase(SglFazendaManejo)) and
         (FTourosRM[X].CodRMManejo.CodManejo  = Uppercase(CodRMManejo)) and
         (FTourosRM[X].CodAnimalManejo.SglFazenda = Uppercase(SglFazendaAnimal)) and
         (FTourosRM[X].CodAnimalManejo.CodManejo  = Uppercase(CodAnimalManejo)) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TImportacao.ExisteEvento(CodIdentificadorEvento: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FEventos) > 0 then begin
    For X := Low(FEventos) to FIndEventos - 1 do begin
      if FEventos[X].CodIdentificadorEvento = Uppercase(CodIdentificadorEvento) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TImportacao.EEventoEspecial(CodIdentificadorEvento: String): Integer;
var
  X : Integer;
begin
  if Length(FEventos) > 0 then begin
    For X := Low(FEventos) to FIndEventos - 1 do begin
      if FEventos[X].CodIdentificadorEvento = Uppercase(CodIdentificadorEvento) then begin
        if FEventos[X].IndEventoExameAndrologico then begin
          Result := 3;
        end else if FEventos[X].IndEventoDiagnosticoPrenhez then begin
          Result := 2;
        end else if FEventos[X].IndEventoPesagem then begin
          Result := 1
        end else begin
          Result := 0;
        end;
        Exit;
      end;
    end;
  end;
  Result := FIntErroImportacao.SetErro(39, [CodIdentificadorEvento, FNomArquivoEscrita]);
  Exit;
end;

function TImportacao.ExisteAnimalEvento(CodIdentificadorEvento,
  SglFazendaManejo, CodAnimalManejo: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FAnimaisEvento) > 0 then begin
    For X := Low(FAnimaisEvento) to FIndAnimaisEvento - 1 do begin
      if (FAnimaisEvento[X].CodIdentificadorEvento = Uppercase(CodIdentificadorEvento)) and
         (FAnimaisEvento[X].CodAnimalManejo.SglFazenda = Uppercase(SglFazendaManejo)) and
         (FAnimaisEvento[X].CodAnimalManejo.CodManejo  = Uppercase(CodAnimalManejo)) then begin
        Result := True;
        Exit;
      end;
    end;
  end;  
end;

function TImportacao.ExisteComposicaoRacial(SglFazendaManejo,
  CodAnimalManejo, SglRaca: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FComposicoesRaciais) > 0 then begin
    For X := Low(FComposicoesRaciais) to FIndComposicoesRaciais - 1 do begin
      if (FComposicoesRaciais[X].CodAnimalManejo.SglFazenda = Uppercase(SglFazendaManejo)) and
         (FComposicoesRaciais[X].CodAnimalManejo.CodManejo  = Uppercase(CodAnimalManejo)) and
         (FComposicoesRaciais[X].SglRaca = Uppercase(SglRaca)) then begin
        Result := True;
        Exit;
      end;
    end;
  end;  
end;

function TImportacao.RegistrarRM(SglFazendaManejo,
  CodRMManejo: String): Integer;
begin
  Result := 0;
  if ExisteRM(SglFazendaManejo, CodRMManejo) then begin
    Result := FIntErroImportacao.SetErro(33, [SglFazendaManejo, CodRMManejo, FNomArquivoEscrita]);
    Exit;
  end;
  if Length(FRMs) <= FIndRms then begin
    SetLength(FRMs, Length(FRMs) + 100);
  end;
  FRMs[FIndRMs].SglFazenda := UpperCase(SglFazendaManejo);
  FRMs[FIndRMs].CodManejo  := UpperCase(CodRMManejo);
  Inc(FIndRMs);
end;

function TImportacao.RegistrarAnimal(SglFazendaManejo, CodAnimalManejo,
  CodAnimalCertificadora, CodAnimalSisbov: String): Integer;
begin
  Result := ExisteAnimal(SglFazendaManejo, CodAnimalManejo, CodAnimalCertificadora, CodAnimalSisbov);
  Case Result of
    // Animal ainda não registrado na tabela
    0 : begin
          if Length(FAnimais) <= FIndAnimais then begin
            SetLength(FAnimais, Length(FAnimais) + 10000);
          end;
          FAnimais[FIndAnimais].CodAnimalManejo.SglFazenda := Uppercase(SglFazendaManejo);
          FAnimais[FIndAnimais].CodAnimalManejo.CodManejo  := Uppercase(CodAnimalManejo);
          FAnimais[FIndAnimais].CodAnimalCertificadora     := Uppercase(CodAnimalCertificadora);
          FAnimais[FIndAnimais].CodAnimalSisbov            := Uppercase(CodAnimalSisbov);
          Inc(FIndAnimais);
        end;
    // Animal já existente com o mesmo código de manejo
    1 : begin
          Result := FIntErroImportacao.SetErro(34, [SglFazendaManejo, CodAnimalManejo, FNomArquivoEscrita]);
        end;
    // Animal já existente com o mesmo código de certificadora
    2 : begin
          Result := FIntErroImportacao.SetErro(35, [CodAnimalCertificadora, FNomArquivoEscrita]);
        end;
    // Animal já existente com o mesmo código SISBOV
    3 : begin
          Result := FIntErroImportacao.SetErro(36, [CodAnimalSisbov, FNomArquivoEscrita]);
        end;
  end;
end;

function TImportacao.RegistrarTouroRM(SglFazendaManejo, CodRMManejo,
  SglFazendaAnimal, CodAnimalManejo: String): Integer;
begin
  Result := 0;
  if ExisteTouroRM(SglFazendaManejo, CodRMManejo, SglFazendaAnimal, CodAnimalManejo) then begin
    Result := FIntErroImportacao.SetErro(37, [SglFazendaAnimal, CodAnimalManejo, SglFazendaManejo, CodRMManejo, FNomArquivoEscrita]);
    Exit;
  end;
  if Length(FTourosRM) <= FIndTourosRM then begin
    SetLength(FTourosRM, Length(FTourosRM) + 2000);
  end;
  FTourosRM[FIndTourosRM].CodRMManejo.SglFazenda     := UpperCase(SglFazendaManejo);
  FTourosRM[FIndTourosRM].CodRMManejo.CodManejo      := UpperCase(CodRMManejo);
  FTourosRM[FIndTourosRM].CodAnimalManejo.SglFazenda := UpperCase(SglFazendaAnimal);
  FTourosRM[FIndTourosRM].CodAnimalManejo.CodManejo  := UpperCase(CodAnimalManejo);
  Inc(FIndTourosRM);
end;

function TImportacao.RegistrarEvento(CodIdentificadorEvento: String;
  IndEventoPesagem, IndEventoDiagnosticoPrenhez, IndEventoExameAndrologico,
  IndEventoAvaliacao: Boolean): Integer;
begin
  Result := 0;
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;
  if Length(FEventos) <= FIndEventos then begin
    SetLength(FEventos, Length(FEventos) + 100);
  end;
  FEventos[FIndEventos].CodIdentificadorEvento := UpperCase(CodIdentificadorEvento);
  FEventos[FIndEventos].IndEventoPesagem := IndEventoPesagem;
  FEventos[FIndEventos].IndEventoAvaliacao := IndEventoAvaliacao;
  FEventos[FIndEventos].IndEventoDiagnosticoPrenhez := IndEventoDiagnosticoPrenhez;
  FEventos[FIndEventos].IndEventoExameAndrologico := IndEventoExameAndrologico;
  Inc(FIndEventos);
end;

function TImportacao.RegistrarAnimalEvento(CodIdentificadorEvento,
  SglFazendaManejo, CodAnimalManejo: String): Integer;
begin
  Result := 0;
  if not ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(39, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;
  if ExisteAnimalEvento(CodIdentificadorEvento, SglFazendaManejo, CodAnimalManejo) then begin
    Result := FIntErroImportacao.SetErro(40, [SglFazendaManejo, CodAnimalManejo, CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;
  if Length(FAnimaisEvento) <= FIndAnimaisEvento then begin
    SetLength(FAnimaisEvento, Length(FAnimaisEvento) + 2000);
  end;
  FAnimaisEvento[FIndAnimaisEvento].CodIdentificadorEvento     := UpperCase(CodIdentificadorEvento);
  FAnimaisEvento[FIndAnimaisEvento].CodAnimalManejo.SglFazenda := UpperCase(SglFazendaManejo);
  FAnimaisEvento[FIndAnimaisEvento].CodAnimalManejo.CodManejo  := UpperCase(CodAnimalManejo);
  Inc(FIndAnimaisEvento);
end;

function TImportacao.RegistrarComposicaoRacial(SglFazendaManejo,
  CodAnimalManejo, SglRaca: String): Integer;
begin
  Result := 0;
  if ExisteComposicaoRacial(SglFazendaManejo, CodAnimalManejo, SglRaca) then begin
    Result := FIntErroImportacao.SetErro(128, [SglFazendaManejo, CodAnimalManejo, SglRaca, FNomArquivoEscrita]);
    Exit;
  end;
  if Length(FComposicoesRaciais) <= FIndComposicoesRaciais then begin
    SetLength(FComposicoesRaciais, Length(FComposicoesRaciais) + 500);
  end;
  FComposicoesRaciais[FIndComposicoesRaciais].CodAnimalManejo.SglFazenda := UpperCase(SglFazendaManejo);
  FComposicoesRaciais[FIndComposicoesRaciais].CodAnimalManejo.CodManejo  := UpperCase(CodAnimalManejo);
  FComposicoesRaciais[FIndComposicoesRaciais].SglRaca                    := UpperCase(SglRaca);
  Inc(FIndComposicoesRaciais);
end;

function TImportacao.VerificarSisbov(var CodAnimalSisbov: String): Integer;
var
  Soma, Mult, Modulo, X, DV1, DV2, TamCod : Integer;
begin
  Result := 0;

  if Ord(CodAnimalSisbov[1]) = 39 then begin
    CodAnimalSisbov := Copy(CodAnimalSisbov,2,17);
  end;

  if (Length(CodAnimalSisbov) <> 17) and (Length(CodAnimalSisbov) <> 14) and (Length(CodAnimalSisbov) <> 15) then begin
    Result := FIntErroImportacao.SetErro(47);
    Exit;
  end;
  if (CodAnimalSisbov = '00000000000000') or (CodAnimalSisbov = '00000000000000000') then begin
    Result := FIntErroImportacao.SetErro(143);
    Exit;
  end;
  if ( (Length(CodAnimalSisbov) = 14) or (Length(CodAnimalSisbov) = 12) ) then begin
    CodAnimalSisbov := '105' + CodAnimalSisbov;
  end;

//*****
//Se o código sisbov tiver com a micro região 99, muda para 00
//e calcula o digito verificador. Esta mudanca foi realizada de
//acordo com a mudanca do sisbov.
  if Copy(CodAnimalSisbov, 6, 2) = '99' then begin
    CodAnimalSisbov := Copy(CodAnimalSisbov, 1, 5) + '00' + Copy(CodAnimalSisbov, 8, 10);
  end;
//*****
//Se o código sisbov tiver com a micro região 88, remove o campo
//e calcula o digito verificador. Esta mudanca foi realizada de
//acordo com a mudanca do sisbov.
  if ( (Copy(CodAnimalSisbov, 6, 2) = '88') or (Copy(CodAnimalSisbov, 6, 2) = '-1') ) then begin
    CodAnimalSisbov := Copy(CodAnimalSisbov, 1, 5) + Copy(CodAnimalSisbov, 8, 10);
  end;
//*****

  TamCod := Length(CodAnimalSisbov);
  DV1 := StrToInt(Copy(CodAnimalSisbov, TamCod, 1));
  Soma := 0;
  Mult := 2;
  For X := TamCod - 1 downto 1 do begin
    Soma := Soma + (Mult * StrToInt(Copy(CodAnimalSisbov, X, 1)));
    Inc(Mult);
    if Mult > 9 then begin
      Mult := 2;
    end;
  end;

{
//*****
//Se o código sisbov tiver com a micro região 00, muda para 99
//para gravar corretamente o código a ser importado para o
//sistema.
  if (17 = TamCod) and (Copy(CodAnimalSisbov, 6, 2) = '00') then begin
    CodAnimalSisbov := Copy(CodAnimalSisbov, 1, 5) + '99' + Copy(CodAnimalSisbov, 8, 10);
  end;
//*****
//Se o código sisbov tiver se a micro região, muda para 88
//para gravar corretamente o código a ser importado para o
//sistema.
  if 15 = TamCod then begin
    CodAnimalSisbov := Copy(CodAnimalSisbov, 1, 5) + '88' + Copy(CodAnimalSisbov, 6, 10);
  end;
//*****
}
  Modulo := Soma mod 11;
  if (Modulo = 0) or (Modulo = 1) then begin
    DV2 := 0;
  end else begin
    DV2 := 11 - Modulo;
  end;
  if DV1 <> DV2 then begin
    Result := FIntErroImportacao.SetErro(48);
    Exit;
  end;
end;

function TImportacao.VerificarCNPJCPF(NumCNPJCPF: String): Integer;
var
  I, J, K, Soma, Digito: Integer;
  NumeroAux: String;
  CNPJ : Boolean;
begin
  Result := 0;

  Case Length(NumCNPJCPF) Of
    11: CNPJ := False;
    14: CNPJ := True;
  else
    Result := FIntErroImportacao.SetErro(65, [NumCNPJCPF]);
    Exit;
  end;

  if CNPJ and ((NumCNPJCPF = '11111111111111') or
               (NumCNPJCPF = '22222222222222') or
               (NumCNPJCPF = '33333333333333') or
               (NumCNPJCPF = '44444444444444') or
               (NumCNPJCPF = '55555555555555') or
               (NumCNPJCPF = '66666666666666') or
               (NumCNPJCPF = '77777777777777') or
               (NumCNPJCPF = '88888888888888') or
               (NumCNPJCPF = '99999999999999')) then begin
    Result := FIntErroImportacao.SetErro(67, [NumCNPJCPF]);
    Exit;
  end else if ((NumCNPJCPF = '11111111111') or
               (NumCNPJCPF = '22222222222') or
               (NumCNPJCPF = '33333333333') or
               (NumCNPJCPF = '44444444444') or
               (NumCNPJCPF = '55555555555') or
               (NumCNPJCPF = '66666666666') or
               (NumCNPJCPF = '77777777777') or
               (NumCNPJCPF = '88888888888') or
               (NumCNPJCPF = '99999999999')) then begin
    Result := FIntErroImportacao.SetErro(67, [NumCNPJCPF]);
    Exit;
  end;

  // Calcula o número com o dígito
  NumeroAux := Copy(NumCNPJCPF, 1, Length(NumCNPJCPF) - 2);
  For J := 1 to 2 do begin
    K := 2;
    Soma := 0;
    For I := Length(NumeroAux) Downto 1 do begin
      Soma := Soma + (Ord(NumeroAux[I]) - Ord('0')) * K;
      Inc(K);
      if (K > 9) and CNPJ then K := 2;
    end;
    Digito := 11 - Soma mod 11;
    if Digito >= 10 then Digito := 0;
    NumeroAux := NumeroAux + Chr(Digito + Ord('0'));
  end;

  if NumeroAux <> NumCNPJCPF then begin
    if CNPJ then begin
      Result := FIntErroImportacao.SetErro(66, ['CNPJ', NumCNPJCPF]);
    end else begin
      Result := FIntErroImportacao.SetErro(66, ['CPF', NumCNPJCPF]);
    end;
    Exit;
  end;
end;

function TImportacao.CarregarParametros(
  NomArquivoParametros: String): Integer;
var
  Arquivo: TArquivoLeitura;
  MaiorTipo, TIPO, LINHA, COLUNA, X: Integer;
begin
  if Trim(NomArquivoParametros) = '' then begin
    Result := FIntErroImportacao.SetErro(2);
    Exit;
  end;
  if not FileExists(NomArquivoParametros) then begin
    Result := FIntErroImportacao.SetErro(3, [NomArquivoParametros]);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';
  FUltimoAnimal  := '';

   // Abre o arquivo de parãmetros
  Arquivo := TArquivoLeitura.Create;
  try
    Arquivo.NomeArquivo := NomArquivoParametros;
    Result := Arquivo.Inicializar;
    if Result = EArquivoInexistente then begin
      Result := FIntErroImportacao.SetErro(3, [NomArquivoParametros]);
      Exit;
    end else if Result = EInicializarLeitura then begin
      Result := FIntErroImportacao.SetErro(4, [NomArquivoParametros]);
      Exit;
    end else if Result = EJaInicializado then begin
      Result := FIntErroImportacao.SetErro(12, [NomArquivoParametros]);
      Exit;
    end else if Result < 0 then begin
      Result := FIntErroImportacao.SetErro(5, [NomArquivoParametros]);
      Exit;
    end;
    try
      // Ler restante do arquivo (header já foi lido na inicialização) para montar tabela
      // A tabela de parâmetros é montada em um array dinâmico e multidimensional sendo que
      // a primeira dimensão (TIPO) representa o tipo de parâmetro, a segunda dimensão (LINHA)
      // representa as linhas contidas em cada tipo de parâmetro e a terceira dimensão (COLUNA)
      // representa as colunas de cada linha.
      // Sendo o array dinâmico, o código abaixo contempla o redimensionamento de cada dimensão
      // do array conforme o tipo de linha encontrado.
      Finalize(FPar);
      MaiorTipo := 0;
      While not Arquivo.EOF do begin
        Result := Arquivo.ObterLinha;
        if Result < 0 then begin
          Result := FIntErroImportacao.SetErro(6, [NomArquivoParametros, IntToStr(Result)]);
          Break;
        end else begin
          // Se tipo de linha for inválido, pula para próxima linha
          if Arquivo.TipoLinha < 1 then begin
            Continue;
          end;
          // Se tipo de linha for maior que o maior tipo já lido, ajusta dimensão TIPO
          // para armazenar o novo tipo de linha encontrado
          if Arquivo.TipoLinha > MaiorTipo then begin
            MaiorTipo := Arquivo.TipoLinha;
            SetLength(FPar, MaiorTipo);
          end;
          TIPO := Arquivo.TipoLinha;
          LINHA := Length(FPar[TIPO - 1]) + 1;

          // Ajusta dimensão LINHA da posicão TipoLinha da dimensão TIPO para armazenar a nova linha
          SetLength(FPar[TIPO - 1], LINHA);

          // Ajusta a dimensão COLUNA da última posição da dimensão LINHA para armazenar a quantidade
          // correta de colunas de acordo com TipoLinha
          COLUNA := Arquivo.NumeroColunas;
          SetLength(FPar[TIPO - 1][LINHA - 1], COLUNA);

          // Coloca valores lidos do arquivo no array preparado previamente
          For X := 0 to COLUNA - 1 do begin
            FPar[TIPO - 1][LINHA - 1][X] := Arquivo.ValorColuna[X + 1];
          end;
        end;
      end;

      if Result = 0 then begin
        FIndParametrosCarregados := 1;
        FDtaArquivoParametros    := Arquivo.DtaGeracao;
        FNomCertificadora        := Arquivo.NomCertificadora;
        FNumCNPJCertificadora    := Arquivo.NumCNPJCertificadora;
      end;
    finally
      Arquivo.Finalizar;
    end;
  finally
    Arquivo.Free;
  end;
end;

function TImportacao.Inicializar(NomArquivoDados: String;
  IndLimparArquivo: Integer; CodNaturezaProdutor,
  NumCNPJCPFProdutor: String): Integer;
var
  ArqLeitura : TArquivoLeitura;
begin
  if FInicializado then begin
    Result := FIntErroImportacao.SetErro(12, [NomArquivoDados]);
    Exit;
  end;

  if FIndParametrosCarregados = 0 then begin
    Result := FIntErroImportacao.SetErro(15);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';
  FUltimoAnimal  := '';

  // Consiste parâmetros
  if Trim(NomArquivoDados) = '' then begin
    Result := FIntErroImportacao.SetErro(7);
    Exit;
  end;
  if Trim(CodNaturezaProdutor) = '' then begin
    Result := FIntErroImportacao.SetErro(10);
    Exit;
  end;
  if Trim(NumCNPJCPFProdutor) = '' then begin
    Result := FIntErroImportacao.SetErro(11);
    Exit;
  end;
  Result := VerificarCNPJCPF(NumCNPJCPFProdutor);
  if Result < 0 then begin
    Exit;
  end;
  FNomArquivoEscrita := NomArquivoDados;

  // Limpa dados existentes nas tabelas internas
  Finalize(FRMs);
  Finalize(FAnimais);
  Finalize(FTourosRM);
  Finalize(FEventos);
  Finalize(FAnimaisEvento);
  Finalize(FComposicoesRaciais);
  Finalize(FInventariosAnimais);

  FIndRMs                := 0;
  FIndAnimais            := 0;
  FIndTourosRM           := 0;
  FIndEventos            := 0;
  FIndAnimaisEvento      := 0;
  FIndComposicoesRaciais := 0;
  FIndInventariosAnimais := 0;

  // Se não for pra limpara o arquivo, consiste se o mesmo existe e se os dados
  // já gravados nele correspondem aos parâmetros informados
  if IndLimparArquivo = 0 then begin
    if not FileExists(NomArquivoDados) then begin
      Result := FIntErroImportacao.SetErro(8, [NomArquivoDados]);
      Exit;
    end;

    ArqLeitura := TArquivoLeitura.Create;
    try
      ArqLeitura.NomeArquivo := NomArquivoDados;
      // Tenta inicializar arquivo para leitura
      Result := ArqLeitura.Inicializar;
      if Result = EArquivoInexistente then begin
        Result := FIntErroImportacao.SetErro(8, [NomArquivoDados]);
        Exit;
      end else if Result = EInicializarLeitura then begin
        Result := FIntErroImportacao.SetErro(4, [NomArquivoDados]);
        Exit;
      end else if Result = EJaInicializado then begin
        Result := FIntErroImportacao.SetErro(12, [NomArquivoDados]);
        Exit;
      end else if Result < 0 then begin
        Result := FIntErroImportacao.SetErro(5, [NomArquivoDados]);
        Exit;
      end;
      // Arquivo inicializado com sucesso
      try
        if (ArqLeitura.NaturezaProdutor <> CodNaturezaProdutor) or
           (ArqLeitura.NumCNPJCPFProdutor <> NumCNPJCPFProdutor) then begin
          Result := FIntErroImportacao.SetErro(9, [NomArquivoDados]);
          Exit;
        end;

        While not ArqLeitura.EOF do begin
          Result := ArqLeitura.ObterLinha;
          if Result < 0 then begin
            Result := FIntErroImportacao.SetErro(6, [NomArquivoDados, IntToStr(Result)]);
            Break;
          end else begin
            // Adiciona informações encontradas nas tabelas internas correspondentes
            Case ArqLeitura.TipoLinha of
              // RM´s
              1 : begin
                    Result := RegistrarRM(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Animais (inserção)
              2 : begin
                    Result := RegistrarAnimal(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2],
                                             ArqLeitura.ValorColuna[3], ArqLeitura.ValorColuna[4]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Touros de RM
              4 : begin
                    Result := RegistrarTouroRM(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2], ArqLeitura.ValorColuna[3], ArqLeitura.ValorColuna[4]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Eventos
              5 : begin
                    Result := EEventoEspecial(ArqLeitura.ValorColuna[1]);
                    if Result < 0 then begin
                      Exit;
                    end;
                    Case Result Of
                      1: // Pesagem
                        Result := RegistrarEvento(ArqLeitura.ValorColuna[1], True, False, False, False);
                      2: // Diagnóstico de prenhez
                        Result := RegistrarEvento(ArqLeitura.ValorColuna[1], False, True, False, False);
                      3: // Exame andrológico
                        Result := RegistrarEvento(ArqLeitura.ValorColuna[1], False, False, True, False);
                      4: // Avaliação
                        Result := RegistrarEvento(ArqLeitura.ValorColuna[1], False, False, False, True);
                      else
                        Result := RegistrarEvento(ArqLeitura.ValorColuna[1], False, False, False, False);
                    end;
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Animais relacionados a evento
              6 : begin
                    Result := RegistrarAnimalEvento(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2], ArqLeitura.ValorColuna[3]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Definições de composição racial
              7 : begin
                    Result := RegistrarComposicaoRacial(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2], ArqLeitura.ValorColuna[3]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
              // Inventários de animais
              9 : begin
                    Result := RegistrarInventarioAnimal(ArqLeitura.ValorColuna[1], ArqLeitura.ValorColuna[2]);
                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
            else
              Continue;
            end;
          end;
        end;
      finally
        ArqLeitura.Finalizar;
      end;
    finally
      ArqLeitura.Free;
    end;
  end;

  FArquivoEscrita.NomeArquivo := NomArquivoDados;
  FArquivoEscrita.LimparAoAbrir := (IndLimparArquivo <> 0);
  if FArquivoEscrita.Inicializar <> 0 then begin
    Result := FIntErroImportacao.SetErro(13, [NomArquivoDados]);
    Exit;
  end;

  // Define o Header se arquivo foi limpo na inicialização
  if IndLimparArquivo <> 0 then begin
    FArquivoEscrita.AdicionarComentario('*----------------------------------------------------* #');
    FArquivoEscrita.AdicionarComentario('* ARQUIVO DE DADOS PARA INTERFACE COM SISTEMA HERDOM * #');
    FArquivoEscrita.AdicionarComentario('* DATA DA GERAÇÃO: ' + FormatDateTime('dd/mm/yyyy hh:mm', Now) + '    (XHERDOM.OCX) * #');
    FArquivoEscrita.AdicionarComentario('*----------------------------------------------------* #');
    FArquivoEscrita.AdicionarComentario('');
    FArquivoEscrita.DefinirHeader(Now, FNomCertificadora, FNumCNPJCertificadora, CodNaturezaProdutor, NumCNPJCPFProdutor);
    FArquivoEscrita.AdicionarLinha;
  end;

  FInicializado := True;
end;

function TImportacao.Finalizar(IndExcluirArquivo: Integer): Integer;
begin
  Result := 0;
  if not FInicializado then Exit;
  if FArquivoEscrita.Finalizar <> 0 then begin
    Result := FIntErroImportacao.SetErro(14);
    Exit;
  end;

  if IndExcluirArquivo <> 0 then begin
     if FNomArquivoEscrita <> '' then begin
       try
         DeleteFile(FNomArquivoEscrita);
       except
         on E: exception do begin
           Result := FIntErroImportacao.SetErro(105, [E.Message]);
           Exit;
         end;
       end;
     end;
  end;

  // Limpa dados existentes nas tabelas internas
  Finalize(FRMs);
  Finalize(FAnimais);
  Finalize(FTourosRM);
  Finalize(FEventos);
  Finalize(FAnimaisEvento);
  Finalize(FComposicoesRaciais);
  Finalize(FInventariosAnimais);

  FInicializado := False;
end;

procedure TImportacao.RaiseNaoInicializado(Metodo: String);
begin
  Raise exception.Create('Erro. Objeto não inicializado. (Classe: ' + Self.ClassName + ' Método: ' + Metodo + ')');
end;

function TImportacao.InserirReprodutorMultiplo(SglFazendaManejo, CodRMManejo,
  SglEspecie, TxtObservacao: String): Integer;
const
  TIPO_LINHA: Integer = 1;
  DES_TIPO: String    = 'REPRODUTORES MÚLTIPLOS';
begin
  Result := 0;
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';  
  FUltimoAnimal  := '';

  // Consistências
  if Trim(SglFazendaManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(41);
    Exit;
  end;
  if Length(SglFazendaManejo) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodRMManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(42);
    Exit;
  end;
  if Length(CodRMManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(86);
    Exit;
  end;
  if Trim(SglEspecie) = '' then begin
    Result := FIntErroImportacao.SetErro(43);
    Exit;
  end;
  if ExisteRM(SglFazendaManejo, CodRMManejo) then begin
    Result := FIntErroImportacao.SetErro(33, [SglFazendaManejo, CodRMManejo, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodRMManejo);
    FArquivoEscrita.AdicionarColuna(Integer(SglToCod(tab_especie, SglEspecie, True)));
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarRM(SglFazendaManejo, CodRMManejo);
end;

function TImportacao.InserirAnimal(SglFazendaManejo, CodAnimalManejo,
  CodAnimalCertificadora, CodAnimalSisbov, SglSituacaoSisbov: String;
  DtaIdentificacaoSisbov: TDateTime; NumImovelIdentificacao,
  SglFazendaIdentificacao: String; DtaNascimento: TDateTime;
  NumImovelNascimento, SglFazendaNascimento: String; DtaCompra: TDateTime;
  NomAnimal, DesApelido, SglAssociacaoRaca, SglGrauSangue, NumRGD,
  NumTransponder, SglTipoIdentificador1, SglPosicaoIdentificador1,
  SglTipoIdentificador2, SglPosicaoIdentificador2, SglTipoIdentificador3,
  SglPosicaoIdentificador3, SglTipoIdentificador4,
  SglPosicaoIdentificador4, SglAptidao, SglRaca, SglPelagem, IndSexo,
  SglTipoOrigem, SglFazendaPai, CodManejoPai,
  SglFazendaMae, CodManejoMae, SglFazendaReceptor, CodManejoReceptor,
  IndAnimalCastrado, SglRegimeAlimentar, SglCategoriaAnimal,
  SglFazendaCorrente, SglLocalCorrente, SglLoteCorrente, TxtObservacao,
  NumGTA: String; DtaEmissaoGTA: TDateTime;
  NumnotaFiscal: Integer; NumCNPJCPFTecnico, IndEfetivar: String): Integer;
const
  TIPO_LINHA: Integer = 2;
  DES_TIPO: String    = 'ANIMAIS (INSERÇÃO)';
var
  CodTipoOrigem, CodIdent, QtdTransponder, QtdBrinco: Integer;
  CodSituacaoSisbov: String;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

{
  SglFazendaCorrente,
  SglLocalCorrente,
  SglLoteCorrente,
}
  // Trata os parametros da função
  SglFazendaManejo := Trim(SglFazendaManejo);
  CodAnimalManejo := Trim(CodAnimalManejo);
  CodAnimalCertificadora := Trim(CodAnimalCertificadora);
  CodAnimalSisbov := Trim(CodAnimalSisbov);
  SglSituacaoSisbov := Trim(SglSituacaoSisbov);
  NumImovelIdentificacao := Trim(NumImovelIdentificacao);
  SglFazendaIdentificacao := Trim(SglFazendaIdentificacao);
  NumImovelNascimento := Trim(NumImovelNascimento);
  SglFazendaNascimento := Trim(SglFazendaNascimento);
  NomAnimal := Trim(NomAnimal);
  DesApelido := Trim(DesApelido);
  SglAssociacaoRaca := Trim(SglAssociacaoRaca);
  SglGrauSangue := Trim(SglGrauSangue);
  NumRGD := Trim(NumRGD);
  NumTransponder := Trim(NumTransponder);
  SglTipoIdentificador1 := Trim(SglTipoIdentificador1);
  SglPosicaoIdentificador1 := Trim(SglPosicaoIdentificador1);
  SglTipoIdentificador2 := Trim(SglTipoIdentificador2);
  SglPosicaoIdentificador2 := Trim(SglPosicaoIdentificador2);
  SglTipoIdentificador3 := Trim(SglTipoIdentificador3);
  SglPosicaoIdentificador3 := Trim(SglPosicaoIdentificador3);
  SglTipoIdentificador4 := Trim(SglTipoIdentificador4);
  SglPosicaoIdentificador4 := Trim(SglPosicaoIdentificador4);
  SglAptidao := Trim(SglAptidao);
  SglRaca := Trim(SglRaca);
  SglPelagem := Trim(SglPelagem);
  IndSexo := Trim(IndSexo);
  SglTipoOrigem := Trim(SglTipoOrigem);
  SglFazendaPai := Trim(SglFazendaPai);
  CodManejoPai := Trim(CodManejoPai);
  SglFazendaMae := Trim(SglFazendaMae);
  CodManejoMae := Trim(CodManejoMae);
  SglFazendaReceptor := Trim(SglFazendaReceptor);
  CodManejoReceptor := Trim(CodManejoReceptor);
  IndAnimalCastrado := Trim(IndAnimalCastrado);
  SglRegimeAlimentar := Trim(SglRegimeAlimentar);
  SglCategoriaAnimal := Trim(SglCategoriaAnimal);
  SglFazendaCorrente := Trim(SglFazendaCorrente);
  SglLocalCorrente := Trim(SglLocalCorrente);
  SglLoteCorrente := Trim(SglLoteCorrente);
  TxtObservacao := Trim(TxtObservacao);
  NumGTA := Trim(NumGTA);
  NumCNPJCPFTecnico := Trim(NumCNPJCPFTecnico);
  IndEfetivar := Trim(IndEfetivar);

  // Fim do tratamento dos parametros

  // Consistências
  QtdTransponder := 0;
  QtdBrinco := 0;

  try
    // Tipo de Origem
    if Trim(SglTipoOrigem) = '' then begin
      Result := FIntErroImportacao.SetErro(81);
      Exit;
    end;
    CodTipoOrigem := SglToCod(tab_tipo_origem, SglTipoOrigem, True);

    // Situacao SISBOV
    if Trim(SglSituacaoSisbov) = '' then begin
      Result := FIntErroImportacao.SetErro(23);
      Exit;
    end;
    CodSituacaoSisbov := SglToCod(tab_situacao_sisbov, SglSituacaoSisbov, True);

    // Trata situação SISBOV necessária para animais externos
    if (CodTipoOrigem = 4) and (CodSituacaoSisbov <> 'N') then begin
      Result := FIntErroImportacao.SetErro(182);
      Exit;
    end;

    //consiste data de identificacao animal caso seja informada
    if (DtaIdentificacaoSisbov > 0) and (DtaIdentificacaoSisbov > Date) then begin
      Result := FIntErroImportacao.SetErro(206, [datetimetostr(DtaIdentificacaoSisbov)]);
      Exit;
    end;

    //consiste data de nascimento do animal caso seja informada
    if (DtaNascimento > 0) and (DtaNascimento > Date) then begin
      Result := FIntErroImportacao.SetErro(207, [datetimetostr(DtaNascimento)]);
      Exit;
    end;

    //consiste se a data de identificacao e menor que a data de nascimento. Se for, ERRO.
    if (DtaNascimento > 0) and (DtaIdentificacaoSisbov > 0) and (DtaIdentificacaoSisbov < DtaNascimento) then begin
      Result := FIntErroImportacao.SetErro(27, []);
      Exit;
    end;

    //consiste data EmissaoGTA é menor que a data de nascimento. Se for, ERRO.
    if (DtaNascimento > 0) and (DtaEmissaoGTA > 0) and (DtaEmissaoGTA < DtaNascimento) then begin
      Result := FIntErroImportacao.SetErro(210, [datetimetostr(DtaEmissaoGTA), datetimetostr(DtaNascimento)]);
      Exit;
    end;    

    //consiste data de compra do animal caso seja informada
    if (DtaCompra > 0) and (DtaCompra > Date) then begin
      Result := FIntErroImportacao.SetErro(208, [datetimetostr(DtaCompra)]);
      Exit;
    end;

    //consiste data EmissaoGTA do animal caso seja informada
    if (DtaEmissaoGTA > 0) and (DtaEmissaoGTA > Date) then begin
      Result := FIntErroImportacao.SetErro(209, [datetimetostr(DtaEmissaoGTA)]);
      Exit;
    end;

    // Fazenda Manejo
    if Trim(SglFazendaManejo) = '' then begin
      if CodTipoOrigem <> 4 then begin
        Result := FIntErroImportacao.SetErro(44);
        Exit;
      end;
    end;
    if (CodTipoOrigem = 4) and (Trim(SglFazendaManejo) <> '') then begin
      Result := FIntErroImportacao.SetErro(183);
      Exit;
    end else if Length(SglFazendaManejo) > 2 then begin
      Result := FIntErroImportacao.SetErro(85);
      Exit;
    end;

    // Código de Manejo
    if Trim(CodAnimalManejo) = '' then begin
      Result := FIntErroImportacao.SetErro(45);
      Exit;
    end;
    if Length(CodAnimalManejo) > 8 then begin
      Result := FIntErroImportacao.SetErro(84);
      Exit;
    end;

    if (CodTipoOrigem = 1) and (NumImovelIdentificacao <> '') then
    begin
      Result := FIntErroImportacao.SetErro(212);
      Exit;
    end;

    if (NumImovelIdentificacao <> '') and (SglFazendaIdentificacao <> '') then
    begin
      Result := FIntErroImportacao.SetErro(211);
      Exit;
    end;

    // Codigo SISBOV
    if CodSituacaoSisbov = 'I' then begin
      if CodAnimalSisbov = '' then begin
        Result := FIntErroImportacao.SetErro(26);
        Exit;
      end;
    end;
    if CodSituacaoSisbov = 'P' then begin
      if (NumImovelIdentificacao = '') and (SglFazendaIdentificacao = '') then begin
        Result := FIntErroImportacao.SetErro(196);
        Exit;
      end;
      if Length(SglFazendaIdentificacao) > 2 then begin
        Result := FIntErroImportacao.SetErro(89);
        Exit;
      end;
    end;
    if CodSituacaoSisbov = 'N' then begin
      // Animais externos possuem situação sisbov "N" e podem ter o código SISBOV informado
      if (CodTipoOrigem <> 4) and (CodAnimalSisbov <> '') then begin
        Result := FIntErroImportacao.SetErro(29);
        Exit;
      end;
      if (CodTipoOrigem <> 4) and (DtaIdentificacaoSisbov > 0) then begin
        Result := FIntErroImportacao.SetErro(30);
        Exit;
      end;
      if (CodTipoOrigem <> 4) and ((NumImovelIdentificacao <> '') or (SglFazendaIdentificacao <> '')) then begin
        Result := FIntErroImportacao.SetErro(31);
        Exit;
      end;
    end;
    if CodAnimalSisbov <> '' then begin
      if CodTipoOrigem = 3 then begin
        Result := FIntErroImportacao.SetErro(88);
        Exit;
      end;
      Result := VerificarSisbov(CodAnimalSisbov);
      if Result < 0 then begin
        Exit;
      end;
    end;

    // Data de Nascimento
    if (DtaNascimento <= 0) And (CodSituacaoSisbov <> 'I') then begin
      Result := FIntErroImportacao.SetErro(25);
      Exit;
    end;

    // Código da certificadora
    if (CodTipoOrigem = 4) then begin // Animais externos
      if CodAnimalCertificadora <> '' then begin
        Result := FIntErroImportacao.SetErro(184);
        Exit;
      end;
    end else begin
      if (Length(CodAnimalCertificadora) > 20) then begin
        Result := FIntErroImportacao.SetErro(142);
        Exit;
      end;
    end;

    // Fazenda / Propriedade de nascimento
    if (CodTipoOrigem = 4) then begin // Animais externos
      if (NumImovelNascimento <> '') then begin
        Result := FIntErroImportacao.SetErro(185);
        Exit;
      end else if (SglFazendaNascimento <> '') then begin
        Result := FIntErroImportacao.SetErro(186);
        Exit;
      end;
    end else begin
      if (CodSituacaoSisbov <> 'I') then begin
        if ((NumImovelNascimento <> '') or (SglFazendaNascimento <> '')) then begin
          if (NumImovelNascimento <> '') and (SglFazendaNascimento <> '') then begin
            Result := FIntErroImportacao.SetErro(106);
            Exit;
          end;
          if NumImovelNascimento <> '' then begin
            if CodTipoOrigem <> 2 then begin
              Result := FIntErroImportacao.SetErro(90);
              Exit;
            end;
            if not ValidaNirfIncra(NumImovelNascimento, true) then begin
              Result := FIntErroImportacao.SetErro(107);
              Exit;
            end;
          end else begin
            if Length(SglFazendaNascimento) > 2 then begin
              Result := FIntErroImportacao.SetErro(91);
              Exit;
            end;
            if CodTipoOrigem <> 1 then begin
              Result := FIntErroImportacao.SetErro(108);
              Exit;
            end;
          end;
        (*end else begin
          if CodTipoOrigem = 1 then begin
            Result := FIntErroImportacao.SetErro(109);
            Exit;
          end; *)
        end;
      end;
    end;

    // Data de Compra
    if DtaCompra > 0 then begin
      if CodTipoOrigem = 4 then begin // Animais externos
        Result := FIntErroImportacao.SetErro(187);
        Exit;
      end;
      if (CodTipoOrigem <> 2) and (CodTipoOrigem <> 3) then begin
        Result := FIntErroImportacao.SetErro(82);
        Exit;
      end;
      if DtaCompra < DtaNascimento then begin
        Result := FIntErroImportacao.SetErro(83);
        Exit;
      end;
    end;

    // Nome do animal
    if (Length(NomAnimal) > 60) then begin
      Result := FIntErroImportacao.SetErro(92);
      Exit;
    end;

    // Apelido do animal
    if (Length(DesApelido) > 20) then begin
      Result := FIntErroImportacao.SetErro(93);
      Exit;
    end;

    // Relacionamento Grau Sangue x Associação Raça
    if (SglAssociacaoRaca <> '') and (SglGrauSangue <> '') And (CodSituacaoSisbov <> 'I') then begin
      ExisteRelacionamento(tab_assoc_raca_grau_sangue,
                           tab_associacao_raca,
                           tab_grau_sangue,
                           SglAssociacaoRaca,
                           SglGrauSangue,
                           True);
    end;

    // RGD
    if Length(NumRGD) > 20 then begin
      Result := FIntErroImportacao.SetErro(94);
      Exit;
    end;

    // Consistindo identificadores
    if CodTipoOrigem = 4 then begin // Animais externos
      // Verifica se algum tipo de identificador foi informado
      if (SglTipoIdentificador1 <> '') or (SglTipoIdentificador2 <> '')
        or (SglTipoIdentificador2 <> '') or (SglTipoIdentificador4 <> '') then begin
        Result := FIntErroImportacao.SetErro(188);
        Exit;
      end;

      // Verifica se alguma posição de identificador foi informada
      if (SglPosicaoIdentificador1 <> '') or (SglPosicaoIdentificador2 <> '')
        or (SglPosicaoIdentificador3 <> '') or (SglPosicaoIdentificador4 <> '') then begin
        Result := FIntErroImportacao.SetErro(189);
        Exit;
      end;

      // Verifica se o número transponder para o animal foi informado
      if (NumTransponder <> '') then begin
        Result := FIntErroImportacao.SetErro(200);
        Exit;
      end;
    end else begin
      if (CodSituacaoSisbov <> 'I') then begin
        // Consiste identificador 1
        if Trim(SglTipoIdentificador1) <> '' then begin
          CodIdent := SglToCod(tab_tipo_identificador, SglTipoIdentificador1, True);
          if CodToVal(tab_tipo_identificador, CodIdent, 4, True) = 'S' then begin
            Inc(QtdTransponder);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 5, True) = 'S' then begin
            Inc(QtdBrinco);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 6, True) <> 'O' then begin
            Result := FIntErroImportacao.SetErro(144, ['1', 'de orelha (brinco ou tatuagem)']);
            Exit;
          end;

          if Trim(SglPosicaoIdentificador1) <> '' then begin
            if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                        tab_posicao_identificador,
                                        tab_grupo_identificador,
                                        SglPosicaoIdentificador1,
                                        SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                        True) then begin
              Result := FIntErroImportacao.SetErro(76, ['1']);
              Exit;
            end;
//          end else begin
//            Result := FIntErroImportacao.SetErro(75, ['1']);
//            Exit;
          end;
        end else begin
          if Trim(SglPosicaoIdentificador1) <> '' then begin
            Result := FIntErroImportacao.SetErro(74, ['1']);
            Exit;
          end;
        end;

        // Consiste identificador 2
        if Trim(SglTipoIdentificador2) <> '' then begin
          CodIdent := SglToCod(tab_tipo_identificador, SglTipoIdentificador2, True);
          if CodToVal(tab_tipo_identificador, CodIdent, 4, True) = 'S' then begin
            Inc(QtdTransponder);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 5, True) = 'S' then begin
            Inc(QtdBrinco);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 6, True) <> 'O' then begin
            Result := FIntErroImportacao.SetErro(144, ['2', 'de orelha (brinco ou tatuagem)']);
            Exit;
          end;

          if Trim(SglPosicaoIdentificador2) <> '' then begin
            if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                        tab_posicao_identificador,
                                        tab_grupo_identificador,
                                        SglPosicaoIdentificador2,
                                        SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                        True) then begin
              Result := FIntErroImportacao.SetErro(76, ['2']);
              Exit;
            end;
//          end else begin
//          Result := FIntErroImportacao.SetErro(75, ['2']);
//          Exit;
          end;
        end else begin
          if Trim(SglPosicaoIdentificador2) <> '' then begin
            Result := FIntErroImportacao.SetErro(74, ['2']);
            Exit;
          end;
        end;

        // Consiste identificador 3
        if Trim(SglTipoIdentificador3) <> '' then begin
          CodIdent := SglToCod(tab_tipo_identificador, SglTipoIdentificador3, True);
          if CodToVal(tab_tipo_identificador, CodIdent, 4, True) = 'S' then begin
            Inc(QtdTransponder);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 5, True) = 'S' then begin
            Inc(QtdBrinco);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 6, True) <> 'C' then begin
            Result := FIntErroImportacao.SetErro(144, ['3', 'de corpo (marca fogo/frio)']);
            Exit;
          end;

          if Trim(SglPosicaoIdentificador3) <> '' then begin
            if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                        tab_posicao_identificador,
                                        tab_grupo_identificador,
                                        SglPosicaoIdentificador3,
                                        SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                        True) then begin
              Result := FIntErroImportacao.SetErro(76, ['3']);
              Exit;
            end;
//          end else begin
//          Result := FIntErroImportacao.SetErro(75, ['3']);
//          Exit;
          end;
        end else begin
          if Trim(SglPosicaoIdentificador3) <> '' then begin
            Result := FIntErroImportacao.SetErro(74, ['3']);
            Exit;
          end;
        end;

        // Consiste identificador 4
        if Trim(SglTipoIdentificador4) <> '' then begin
          CodIdent := SglToCod(tab_tipo_identificador, SglTipoIdentificador4, True);
          if CodToVal(tab_tipo_identificador, CodIdent, 4, True) = 'S' then begin
            Inc(QtdTransponder);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 5, True) = 'S' then begin
            Inc(QtdBrinco);
          end;
          if CodToVal(tab_tipo_identificador, CodIdent, 6, True) <> 'I' then begin
            Result := FIntErroImportacao.SetErro(144, ['4', 'interno (transponder umbilical, bolus ruminal)']);
            Exit;
          end;

          if Trim(SglPosicaoIdentificador4) <> '' then begin
            if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                        tab_posicao_identificador,
                                        tab_grupo_identificador,
                                        SglPosicaoIdentificador4,
                                        SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                        True) then begin
              Result := FIntErroImportacao.SetErro(76, ['4']);
              Exit;
            end;
//        end else begin
//          Result := FIntErroImportacao.SetErro(75, ['4']);
//          Exit;
          end;
        end else begin
          if Trim(SglPosicaoIdentificador4) <> '' then begin
            Result := FIntErroImportacao.SetErro(74, ['4']);
            Exit;
          end;
        end;

        if QtdTransponder = 0 then begin
          if Trim(NumTransponder) <> '' then begin
            Result := FIntErroImportacao.SetErro(78);
            Exit;
          end;
        end else begin
          if QtdTransponder <> 1 then begin
            Result := FIntErroImportacao.SetErro(79);
            Exit;
          end;
        end;

        if QtdBrinco > 2 then begin
          Result := FIntErroImportacao.SetErro(80);
          Exit;
        end;
      end;
    end;

    // Raça e Aptidão
    if (SglRaca <> '') and (SglAptidao <> '') And (CodSituacaoSisbov <> 'I') then begin
      ExisteRelacionamento(tab_raca_aptidao,
                           tab_raca,
                           tab_aptidao,
                           SglRaca,
                           SglAptidao,
                           True);
    end else begin
      if  (CodSituacaoSisbov <> 'I') then begin
        Result := FIntErroImportacao.SetErro(95);
        Exit;
      end;
    end;

    // Pelagem
    if (SglPelagem = '') And (CodSituacaoSisbov <> 'I') then begin
      Result := FIntErroImportacao.SetErro(96);
      Exit;
    end;

    // Sexo
    if (Uppercase(IndSexo) <> 'M') and (Uppercase(IndSexo) <> 'F') And (CodSituacaoSisbov <> 'I') then begin
      Result := FIntErroImportacao.SetErro(97);
      Exit;
    end;

    // Pai
    if (CodTipoOrigem <> 4) and (SglFazendaPai <> '') And (CodSituacaoSisbov <> 'I') then begin
      if CodManejoPai = '' then begin
        Result := FIntErroImportacao.SetErro(98);
        Exit;
      end;
      if Length(SglFazendaPai) > 2 then begin
        Result := FIntErroImportacao.SetErro(99);
        Exit;
      end;
    end;

    // Mãe
    if (CodTipoOrigem <> 4) and (SglFazendaMae <> '') And (CodSituacaoSisbov <> 'I') then begin
      if CodManejoMae = '' then begin
        Result := FIntErroImportacao.SetErro(100);
        Exit;
      end;
      if Length(SglFazendaMae) > 2 then begin
        Result := FIntErroImportacao.SetErro(101);
        Exit;
      end;
    end;

    // Receptor
    if (CodTipoOrigem <> 4) and (SglFazendaReceptor <> '') And (CodSituacaoSisbov <> 'I') then begin
      if CodManejoReceptor = '' then begin
        Result := FIntErroImportacao.SetErro(102);
        Exit;
      end;
      if Length(SglFazendaReceptor) > 2 then begin
        Result := FIntErroImportacao.SetErro(103);
        Exit;
      end;
    end;

    // Castrado
    if CodTipoOrigem = 4 then begin // Animais externos
      if IndAnimalCastrado <> '' then begin
        Result := FIntErroImportacao.SetErro(190);
        Exit;
      end;
    end else begin
      if (Uppercase(IndAnimalCastrado) <> 'S') and (Uppercase(IndAnimalCastrado) <> 'N') And (CodSituacaoSisbov <> 'I') then begin
        Result := FIntErroImportacao.SetErro(104);
        Exit;
      end;
    end;

    // Regime Alimentar
    if CodTipoOrigem = 4 then begin // Animais externos
      if SglRegimeAlimentar <> '' then begin
        Result := FIntErroImportacao.SetErro(191);
        Exit;
      end;
    end else begin
      if (SglRegimeAlimentar = '') And (CodSituacaoSisbov <> 'I') then begin
        Result := FIntErroImportacao.SetErro(111);
        Exit;
      end;
        if (CodSituacaoSisbov <> 'I') then begin
          ExisteRelacionamento(tab_regime_alimentar_aptidao,
                               tab_regime_alimentar,
                               tab_aptidao,
                               SglRegimeAlimentar,
                               SglAptidao,
                               True);
        end;
    end;

    // Categoria
    if (CodTipoOrigem <> 4) then begin // Animais externos

//      Foi retirado o teste abaixo, pois, para animal externo
//      não tem categoria.
//    if CodTipoOrigem = 4 then begin // Animais externos
//      if SglCategoriaAnimal <> '' then begin
//        Result := FIntErroImportacao.SetErro(192);
//        Exit;
//      end;
//    end else begin

      if SglCategoriaAnimal = '' then begin
        Result := FIntErroImportacao.SetErro(110);
        Exit;
      end;

      if SglToval(tab_categoria_animal, SglCategoriaAnimal, 7, True) = 'N' then begin
        Result := FIntErroImportacao.SetErro(145);
        Exit;
      end;

      if (CodSituacaoSisbov <> 'I') then begin
        ExisteRelacionamento(tab_categoria_animal_aptidao,
                             tab_categoria_animal,
                             tab_aptidao,
                             SglCategoriaAnimal,
                             SglAptidao,
                             True);
      end;

      // Verifica se é regime alimentar é compatível com a categoria
      if SglToVal(tab_regime_alimentar, SglRegimeAlimentar, 4, True) = 'N' then begin
        if SglToVal(tab_categoria_animal, SglCategoriaAnimal, 1, True) = 1 then begin
          Result := FIntErroImportacao.SetErro(63, [CodToDes(tab_regime_alimentar,
                                                             SglToCod(tab_regime_alimentar,
                                                                      SglRegimeAlimentar,
                                                                      True),
                                                             True)]);
          Exit;
        end;
      end else begin
        if SglToVal(tab_regime_alimentar, SglRegimeAlimentar, 4, True) = 'S' then begin
          if SglToVal(tab_categoria_animal, SglCategoriaAnimal, 1, True) <> 1 then begin
            Result := FIntErroImportacao.SetErro(64, [CodToDes(tab_regime_alimentar,
                                                               SglToCod(tab_regime_alimentar,
                                                                        SglRegimeAlimentar,
                                                                        True),
                                                               True)]);
            Exit;
          end;
        end;
      end;

      if (CodSituacaoSisbov <> 'I') then begin
        // Consiste idade x categoria
        if (Trunc(Date - DtaNascimento) < Integer(SglToVal(tab_categoria_animal, SglCategoriaAnimal, 5, True))) or
           (Trunc(Date - DtaNascimento) > Integer(SglToVal(tab_categoria_animal, SglCategoriaAnimal, 6, True))) then begin
          Result := FIntErroImportacao.SetErro(112, [CodToDes(tab_categoria_animal,
                                                             SglToCod(tab_categoria_animal,
                                                                      SglCategoriaAnimal,
                                                                      True),
                                                             True)]);
          Exit;
        end;

        // Consiste sexo x categoria
        if SglToVal(tab_categoria_animal, SglCategoriaAnimal, 4, True) <> 'A' then begin
          if IndSexo <> SglToVal(tab_categoria_animal, SglCategoriaAnimal, 4, True) then begin
            Result := FIntErroImportacao.SetErro(113, [CodToDes(tab_categoria_animal,
                                                                SglToCod(tab_categoria_animal,
                                                                         SglCategoriaAnimal,
                                                                         True),
                                                                True)]);
            Exit;
          end;
        end;

        // Consiste IndCastrado x categoria
        if SglToVal(tab_categoria_animal, SglCategoriaAnimal, 8, True) <> 'A' then begin
          if IndAnimalCastrado <> SglToVal(tab_categoria_animal, SglCategoriaAnimal, 8, True) then begin
            Result := FIntErroImportacao.SetErro(114, [CodToDes(tab_categoria_animal,
                                                                SglToCod(tab_categoria_animal,
                                                                         SglCategoriaAnimal,
                                                                         True),
                                                                True)]);
            Exit;
          end;
        end;
      end;
    end;

    // TxtObservacao
    if Length(TxtObservacao) > 255 then begin
      Result := FIntErroImportacao.SetErro(122);
      Exit;
    end;

    //CNPJ CPF do Técnico
    if (NumCNPJCPFTecnico <> '') and ((Length(NumCNPJCPFTecnico) <> 11) and (Length(NumCNPJCPFTecnico) <> 14)) then begin
      Result := FIntErroImportacao.SetErro(205, [NumCNPJCPFTecnico]);
      Exit;
    end else begin
      if not ValidaCnpjCpf(NumCNPJCPFTecnico, True, False) then begin
        Result := FIntErroImportacao.SetErro(205, [NumCNPJCPFTecnico]);
        Exit;
      end;
    end;

    // IndEfetivar
    if (IndEfetivar <> 'S') and (IndEfetivar <> 'N') then begin
      Result := FIntErroImportacao.setErro(201);
      Exit;
    end;
    if (IndEfetivar = 'S') and (CodSituacaoSisbov <> 'P') then begin
      Result := FIntErroImportacao.setErro(202);
      Exit;
    end;

    if CodTipoOrigem = 4 then begin // Animais externos
      if NumGTA <> '' then begin
        Result := FIntErroImportacao.SetErro(193);
        Exit;
      end;
      if DtaEmissaoGTA <> 0 then begin
        Result := FIntErroImportacao.SetErro(194);
        Exit;
      end;
      if NumnotaFiscal <> 0 then begin
        Result := FIntErroImportacao.SetErro(195);
        Exit;
      end;
      if SglFazendaCorrente <> '' then begin
        Result := FIntErroImportacao.SetErro(197);
        Exit;
      end;
      if SglLocalCorrente <> '' then begin
        Result := FIntErroImportacao.SetErro(198);
        Exit;
      end;
      if SglLoteCorrente <> '' then begin
        Result := FIntErroImportacao.SetErro(199);
        Exit;
      end;
    end else begin
      // NumGTA / DtaEmissaoGTA
      if Trim(NumGTA) <> '' then begin
        if (CodTipoOrigem <> 2) and (CodTipoOrigem <> 3) then begin
          Result := FIntErroImportacao.SetErro(120);
          Exit;
        end;
        if Length(NumGTA) > 10 then begin
          Result := FIntErroImportacao.SetErro(123);
          Exit;
        end;
      end;

      if DtaEmissaoGTA <> 0 then begin
        if (CodTipoOrigem <> 2) and (CodTipoOrigem <> 3) then begin
          Result := FIntErroImportacao.SetErro(120);
          Exit;
        end;
      end;

      // NumnotaFiscal
      if NumnotaFiscal <> 0 then begin
        if (CodTipoOrigem <> 2) and (CodTipoOrigem <> 3) then begin
          Result := FIntErroImportacao.SetErro(121);
          Exit;
        end;
        if Length(IntToStr(NumnotaFiscal)) > 9 then begin
          Result := FIntErroImportacao.SetErro(124);
          Exit;
        end;
      end;
    end;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Verifica se registro já não foi gravado no arquivo
  Result := ExisteAnimal(SglFazendaManejo, CodAnimalManejo, CodAnimalCertificadora, CodAnimalSisbov);
  Case Result of
    // Animal já existente com o mesmo código de manejo
    1 : begin
          Result := FIntErroImportacao.SetErro(34, [SglFazendaManejo, CodAnimalManejo, FNomArquivoEscrita]);
          Exit;
        end;
    // Animal já existente com o mesmo código de certificadora
    2 : begin
          Result := FIntErroImportacao.SetErro(35, [CodAnimalCertificadora, FNomArquivoEscrita]);
          Exit;
        end;
    // Animal já existente com o mesmo código SISBOV
    3 : begin
          Result := FIntErroImportacao.SetErro(36, [CodAnimalSisbov, FNomArquivoEscrita]);
          Exit;
        end;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejo);
    FArquivoEscrita.AdicionarColuna(CodAnimalCertificadora);
    FArquivoEscrita.AdicionarColuna(CodAnimalSisbov);
    FArquivoEscrita.AdicionarColuna(CodSituacaoSisbov);
    FArquivoEscrita.AdicionarColuna(DtaIdentificacaoSisbov);
    FArquivoEscrita.AdicionarColuna(NumImovelIdentificacao);
    FArquivoEscrita.AdicionarColuna(SglFazendaIdentificacao);
    FArquivoEscrita.AdicionarColuna(DtaNascimento);
    FArquivoEscrita.AdicionarColuna(NumImovelNascimento);
    FArquivoEscrita.AdicionarColuna(SglFazendaNascimento);
    FArquivoEscrita.AdicionarColuna(DtaCompra);
    FArquivoEscrita.AdicionarColuna(NomAnimal);
    FArquivoEscrita.AdicionarColuna(DesApelido);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_associacao_raca, SglAssociacaoRaca, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_grau_sangue, SglGrauSangue, True));
    FArquivoEscrita.AdicionarColuna(NumRGD);
    FArquivoEscrita.AdicionarColuna(NumTransponder);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, SglTipoIdentificador1, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, SglPosicaoIdentificador1, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, SglTipoIdentificador2, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, SglPosicaoIdentificador2, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, SglTipoIdentificador3, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, SglPosicaoIdentificador3, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, SglTipoIdentificador4, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, SglPosicaoIdentificador4, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_raca, SglRaca, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_pelagem, SglPelagem, True));
    FArquivoEscrita.AdicionarColuna(IndSexo);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_origem, SglTipoOrigem, True));
    FArquivoEscrita.AdicionarColuna(SglFazendaPai);
    FArquivoEscrita.AdicionarColuna(CodManejoPai);
    FArquivoEscrita.AdicionarColuna(SglFazendaMae);
    FArquivoEscrita.AdicionarColuna(CodManejoMae);
    FArquivoEscrita.AdicionarColuna(SglFazendaReceptor);
    FArquivoEscrita.AdicionarColuna(CodManejoReceptor);
    FArquivoEscrita.AdicionarColuna(IndAnimalCastrado);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentar, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_categoria_animal, SglCategoriaAnimal, True));
    FArquivoEscrita.AdicionarColuna(1);  // Tipo lugar
    FArquivoEscrita.AdicionarColuna(SglFazendaCorrente);
    FArquivoEscrita.AdicionarColuna(SglLocalCorrente);
    FArquivoEscrita.AdicionarColuna(SglLoteCorrente);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.AdicionarColuna(NumGTA);
    FArquivoEscrita.AdicionarColuna(DtaEmissaoGTA);
    FArquivoEscrita.AdicionarColuna(NumnotaFiscal);
    FArquivoEscrita.AdicionarColuna(NumCNPJCPFTecnico);
    FArquivoEscrita.AdicionarColuna(IndEfetivar);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarAnimal(SglFazendaManejo, CodAnimalManejo, CodAnimalCertificadora, CodAnimalSisbov);
end;

function TImportacao.AlterarAnimal(SglFazendaManejo, CodAnimalManejo,
  NomColunaAlterar, ValColunaAlterar1: String; ValColunaAlterar2: Variant): Integer;
const
  TIPO_LINHA: Integer = 3;
  DES_TIPO: String    = 'ANIMAIS (ALTERAÇÃO)';
var
  TipoPar, IntAux, CodCol: Integer;
  DtaAux : TDateTime;
  ValPar: Variant;
  IndAtributoManejo: Boolean;
  IndTabela: Integer;
  CodigoSisbov : string;
begin
  Result := 0;
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;
  
  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(ValColunaAlterar2) = '' then begin
    ValColunaAlterar2 := ''; 
  end;

//****
// Testa se a coluna a ser alterada tem o caracter de
// aspa simples, se tiver é retirado do campo. Este
// procedimento é aplicado para evitar erros de altera
// ção nos códigos sisbov copiados da planilha de relatório
// do sistema.
  if (Trim(NomColunaAlterar) = 'COD_SISBOV') And (Length(Trim(ValColunaAlterar2)) > 0) then begin
    CodigoSisbov := ValColunaAlterar2;
    if Ord(CodigoSisbov[1]) = 39 then begin
      ValColunaAlterar2 := Copy(CodigoSisbov,2,17);
    end;
  end;
//****

  // Consistências
//  if Trim(SglFazendaManejo) = '' then begin
//    Result := FIntErroImportacao.SetErro(44);
//    Exit;
//  end;
  if Length(SglFazendaManejo) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodAnimalManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(45);
    Exit;
  end;
  if Length(CodAnimalManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(84);
    Exit;
  end;
  if Trim(NomColunaAlterar) = '' then begin
    Result := FIntErroImportacao.SetErro(46);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  CodCol := SglToCod(tab_atributo_alteracao, NomColunaAlterar, True);
  if (CodCol = 2) or (CodCol = 35) or (CodCol = 36) or (CodCol = 37) then begin
    IndAtributoManejo := True;
    // Se está alterando código de manejo do animal então exige a fazenda caso
    // a mesma tenha sido informada na "chave" pois pressupõe-se que trata-se
    // de um animal não externo
    if CodCol = 2 then begin
      if Trim(SglFazendaManejo) <> '' then begin
        if Trim(ValColunaAlterar1) = '' then begin
          Result := FIntErroImportacao.SetErro(146);
          Exit;
        end;
      end else begin
        if Trim(ValColunaAlterar1) <> '' then begin
          Result := FIntErroImportacao.SetErro(147);
          Exit;
        end;
      end;
    end;
  end else begin
    IndAtributoManejo := False;
  end;

  // Verifica colunas que precisam ser convertidas de sigla p/ código
  Case CodCol of
    15, 17, 19, 21 : IndTabela := tab_tipo_identificador;
    16, 18, 20     : IndTabela := tab_posicao_identificador;
    23             : IndTabela := tab_raca;
    24             : IndTabela := tab_pelagem;
  else
    IndTabela := 0;
  end;

  if not IndAtributoManejo then begin
    if ValColunaAlterar1 <> '' then begin
      Result := FIntErroImportacao.SetErro(139);
      Exit;
    end;
  end else begin
    if Length(Trim(ValColunaAlterar1)) > 2 then begin
      Result := FIntErroImportacao.SetErro(85);
      Exit;
    end;
    if Length(Trim(String(ValColunaAlterar2))) > 8 then begin
      Result := FIntErroImportacao.SetErro(84);
      Exit;
    end;
  end;

  // NIRF Nascimento
  if CodCol = 9 then begin
    if not ValidaNirfIncra(Trim(String(ValColunaAlterar2)), true) then begin
      Result := FIntErroImportacao.SetErro(107);
      Exit;
    end;
  end;
  // GTA
  if CodCol = 32 then begin
    if Length(Trim(String(ValColunaAlterar2))) > 10 then begin
      Result := FIntErroImportacao.SetErro(123);
      Exit;
    end;
  end;
  //Tecnico 
  if CodCol = 38 then begin
    if (ValColunaAlterar2 = '') or ((Length(ValColunaAlterar2) <> 11) and (Length(ValColunaAlterar2) <> 14))
        or (not ValidaCnpjCpf(ValColunaAlterar2, True, False)) then begin
      Result := FIntErroImportacao.SetErro(205, [ValColunaAlterar2]);
      Exit;
    end;   
  end;

  //consiste data de identificacao animal caso seja informada
  if (CodCol = 5) and (StrtoDate(ValColunaAlterar2) > Date) then begin
     Result := FIntErroImportacao.SetErro(206, [ValColunaAlterar2]);
     Exit;
  end;

  //consiste data de nascimento do animal caso seja informada
  if (CodCol = 8) and (StrtoDate(ValColunaAlterar2) > Date) then begin
    Result := FIntErroImportacao.SetErro(207, [ValColunaAlterar2]);
    Exit;
  end;

  //consiste data da emissão GTA do animal caso seja informada
  if (CodCol = 33) and (StrtoDate(ValColunaAlterar2) > Date) then begin
    Result := FIntErroImportacao.SetErro(209, [ValColunaAlterar2]);
    Exit;
  end;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejo);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_atributo_alteracao, NomColunaAlterar, True));
    TipoPar := SglToVal(tab_atributo_alteracao, NomColunaAlterar, 4, True);
    Case TipoPar of
       3: begin  // Integer
            if Trim(String(ValColunaAlterar2)) = '' then begin
              ValColunaAlterar2 := SglToVal(tab_atributo_alteracao, NomColunaAlterar, 5, True);
            end;
            try
              IntAux := Integer(ValColunaAlterar2);
            except
              try
                IntAux := StrToInt(String(ValColunaAlterar2));
              except
                Result := FIntErroImportacao.SetErro(119, [NomColunaAlterar]);
                Exit;
              end;
            end;
            if IntAux = 0 then begin
               IntAux := StrToInt(SglToVal(tab_atributo_alteracao, NomColunaAlterar, 5, True));
            end;
            ValPar := IntAux;
          end;
       7: begin  // DateTime
            try
              DtaAux := TDateTime(ValColunaAlterar2);
            except
              try
                DtaAux := StrToDate(String(ValColunaAlterar2));
              except
                Result := FIntErroImportacao.SetErro(118, [NomColunaAlterar]);
                Exit;
              end;
            end;
            if DtaAux = 0 then begin
               DtaAux := StrToFloat(SglToVal(tab_atributo_alteracao, NomColunaAlterar, 5, True));
            end;
            ValPar := DtaAux;
          end;
     256: begin  // String
            if (VarIsEmpty(ValColunaAlterar2)) or
               (String(ValColunaAlterar2) = '') then begin
               ValPar := SglToVal(tab_atributo_alteracao, NomColunaAlterar, 5, True);
            end else begin
              ValPar := String(ValColunaAlterar2);
            end;
          end;
    else
      ValPar := '';
    end;
    if IndAtributoManejo then begin
      FArquivoEscrita.AdicionarColuna(ValColunaAlterar1);
    end else begin
      FArquivoEscrita.AdicionarColuna('');
    end;

    if IndTabela > 0 then begin
      FArquivoEscrita.AdicionarColuna(SglToCod(IndTabela, ValPar, True));
    end else begin
      FArquivoEscrita.AdicionarColuna(ValPar);
    end;

  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;
end;

function TImportacao.AdicionarTouroRM(SglFazendaManejo, CodRMManejo,
  SglFazendaAnimal, CodAnimalManejo: String): Integer;
const
  TIPO_LINHA: Integer = 4;
  DES_TIPO: String    = 'TOUROS DE R.M.';
begin
  Result := 0;
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  // Consistências
  if Trim(SglFazendaManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(41);
    Exit;
  end;
  if Length(SglFazendaManejo) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodRMManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(42);
    Exit;
  end;
  if Length(CodRMManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(86);
    Exit;
  end;
  if Trim(SglFazendaAnimal) = '' then begin
    Result := FIntErroImportacao.SetErro(44);
    Exit;
  end;
  if Length(SglFazendaAnimal) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodAnimalManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(45);
    Exit;
  end;
  if Length(CodAnimalManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(84);
    Exit;
  end;
  if ExisteTouroRM(SglFazendaManejo, CodRMManejo, SglFazendaAnimal, CodAnimalManejo) then begin
    Result := FIntErroImportacao.SetErro(37, [SglFazendaAnimal, CodAnimalManejo, SglFazendaManejo, CodRMManejo, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodRMManejo);
    FArquivoEscrita.AdicionarColuna(SglFazendaAnimal);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejo);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarTouroRM(SglFazendaManejo, CodRMManejo, SglFazendaAnimal, CodAnimalManejo);
end;

function TImportacao.InserirEventoMudRegimeAlimentar(
  CodIdentificadorEvento: String; DtaInicio,
  DtaFim: TDateTime; SglFazenda, TxtObservacao, SglAptidao, SglRegimeAlimentarOrigem,
  SglRegimeAlimentarDestino, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'RA';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia da numeração do evento.
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoRegimeAD <> SglRegimeAlimentarDestino) or
       (FUltimoRegimeAO <> SglRegimeAlimentarOrigem) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglAptidao) = '' then begin
    Result := FIntErroImportacao.SetErro(53);
    Exit;
  end;
  if Trim(SglRegimeAlimentarOrigem) = '' then begin
    Result := FIntErroImportacao.SetErro(54);
    Exit;
  end;
  if Trim(SglRegimeAlimentarDestino) = '' then begin
    Result := FIntErroImportacao.SetErro(55);
    Exit;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Relacionamento Regime Alimentar Origem x Aptidão
  try
    ExisteRelacionamento(tab_regime_alimentar_aptidao,
                         tab_regime_alimentar,
                         tab_aptidao,
                         SglRegimeAlimentarOrigem,
                         SglAptidao,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Relacionamento Regime Alimentar Destino x Aptidão
  try
    ExisteRelacionamento(tab_regime_alimentar_aptidao,
                         tab_regime_alimentar,
                         tab_aptidao,
                         SglRegimeAlimentarDestino,
                         SglAptidao,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

{****
  Consistência retirada, pois, o procedimento de gravação
  do evento foi alterado, passando a ser gravado por colunas.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    // Se mudar a data de início, fazenda, tipo de morte ou a causa de morte,
    // insere um novo evento
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoRegimeAD <> SglRegimeAlimentarDestino) or
       (FUltimoRegimeAO <> SglRegimeAlimentarOrigem) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarOrigem, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarDestino, True));

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
      FUltimaAptidao  := SglAptidao;
      FUltimoRegimeAD := SglRegimeAlimentarDestino;
      FUltimoRegimeAO := SglRegimeAlimentarOrigem;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoDesmame(CodIdentificadorEvento: String;
  DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, SglAptidao,
  SglRegimeAlimentarDestino, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'DS';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia da numeração do evento.
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoRegimeAD <> SglRegimeAlimentarDestino) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglAptidao) = '' then begin
    Result := FIntErroImportacao.SetErro(53);
    Exit;
  end;
  if Trim(SglRegimeAlimentarDestino) = '' then begin
    Result := FIntErroImportacao.SetErro(55);
    Exit;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Relacionamento Regime Alimentar Destino x Aptidão
  try
    ExisteRelacionamento(tab_regime_alimentar_aptidao,
                         tab_regime_alimentar,
                         tab_aptidao,
                         SglRegimeAlimentarDestino,
                         SglAptidao,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

{****
  Consistência retirada, pois, o procedimento de gravação
  do evento foi alterado, passando a ser gravado por colunas.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    // Se mudar a data de início, fazenda, tipo de morte ou a causa de morte,
    // insere um novo evento
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoRegimeAD <> SglRegimeAlimentarDestino) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarDestino, True));
      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
      FUltimaAptidao  := SglAptidao;
      FUltimoRegimeAD := SglRegimeAlimentarDestino;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoMudCategoria(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  SglFazenda, TxtObservacao, SglAptidao, SglCategoriaOrigem,
  SglCategoriaDestino, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'CT';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia da numeração do evento.
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoCategD <> SglCategoriaDestino) or
       (FUltimoCategO <> SglCategoriaOrigem) then begin
         FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglAptidao) = '' then begin
    Result := FIntErroImportacao.SetErro(53);
    Exit;
  end;
  if Trim(SglCategoriaOrigem) = '' then begin
    Result := FIntErroImportacao.SetErro(56);
    Exit;
  end;
  if Trim(SglCategoriaDestino) = '' then begin
    Result := FIntErroImportacao.SetErro(57);
    Exit;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Relacionamento Categoria Origem x Aptidão
  try
    ExisteRelacionamento(tab_categoria_animal_aptidao,
                         tab_categoria_animal,
                         tab_aptidao,
                         SglCategoriaOrigem,
                         SglAptidao,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Relacionamento Categoria Destino x Aptidão
  try
    ExisteRelacionamento(tab_categoria_animal_aptidao,
                         tab_categoria_animal,
                         tab_aptidao,
                         SglCategoriaDestino,
                         SglAptidao,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

{****
  Consistência retirada, pois, o procedimento de gravação
  do evento foi alterado, passando a ser gravado por colunas.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    // Se mudar a data de início, fazenda, tipo de morte ou a causa de morte,
    // insere um novo evento
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidao <> SglAptidao) or (FUltimoCategD <> SglCategoriaDestino) or
       (FUltimoCategO <> SglCategoriaOrigem) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_categoria_animal, SglCategoriaOrigem, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_categoria_animal, SglCategoriaDestino, True));

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
      FUltimaAptidao  := SglAptidao;
      FUltimoCategD   := SglCategoriaDestino;
      FUltimoCategO   := SglCategoriaOrigem;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoSelecaoReproducao(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  SglFazenda, TxtObservacao, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'SE';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia da numeração do evento.
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
         FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;
{****
  Consistência retirada, pois, o procedimento de gravação
  do evento foi alterado, passando a ser gravado por colunas.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    // Se mudar a data de início, fazenda, tipo de morte ou a causa de morte,
    // insere um novo evento
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoCastracao(CodIdentificadorEvento: String;
  DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo,
  CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'CS';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;
{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.
  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;
****}

  // Verifica se é necessário gerar comentário
//  if FIndGerarComentarios then begin
//    if FUltimoTipoLinha <> TIPO_LINHA then begin
//      FArquivoEscrita.AdicionarLinha;
//      FArquivoEscrita.AdicionarComentario(DES_TIPO);
//      FUltimoTipoLinha := TIPO_LINHA;
//    end;
//  end;

  // Adiciona colunas
  try
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData    := DtaInicio;
      FUltimaFazenda := SglFazenda;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoMudancaLote(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda, SglLoteDestino, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'LT';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimoLote <> SglLoteDestino) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(58);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;
  if Trim(SglLoteDestino) = '' then begin
    Result := FIntErroImportacao.SetErro(59);
    Exit;
  end;

{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.
  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;
****}

  // Verifica se é necessário gerar comentário
//  if FIndGerarComentarios then begin
//    if FUltimoTipoLinha <> TIPO_LINHA then begin
//      FArquivoEscrita.AdicionarLinha;
//      FArquivoEscrita.AdicionarComentario(DES_TIPO);
//      FUltimoTipoLinha := TIPO_LINHA;
//    end;
//  end;


  // Adiciona colunas
  try
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimoLote <> SglLoteDestino) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.AdicionarColuna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(SglLoteDestino);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData    := DtaInicio;
      FUltimaFazenda := SglFazenda;
      FUltimoLote    := SglLoteDestino;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoMudancaLocal(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglAptidao, SglFazenda, SglLocalDestino,
  SglRegimeAlimentarMamando, SglRegimeAlimentarDesmamado,
  CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'LC';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidaoL <> SglAptidao) or (FUltimaLocal  <> SglLocalDestino) or
       (FUltimaRAM <> SglRegimeAlimentarMamando) or (FUltimaRAD <> SglRegimeAlimentarDesmamado) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(58);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;
  if Trim(SglLocalDestino) = '' then begin
    Result := FIntErroImportacao.SetErro(60);
    Exit;
  end;
  if Trim(SglAptidao) = '' then begin
    Result := FIntErroImportacao.SetErro(53);
    Exit;
  end;
  // Consiste Regime Alimentar Mamando
  if Trim(SglRegimeAlimentarMamando) <> '' then begin
    try
      // Verifica se é regime alimentar para animal mamando
      if SglToVal(tab_regime_alimentar, SglRegimeAlimentarMamando, 4, True) = 'N' then begin
        Result := FIntErroImportacao.SetErro(63, [CodToDes(tab_regime_alimentar,
                                                           SglToCod(tab_regime_alimentar,
                                                                    SglRegimeAlimentarMamando,
                                                                    True),
                                                           True)]);
        Exit;
      end;

      // Verifica relacionamento com aptidão
      ExisteRelacionamento(tab_regime_alimentar_aptidao,
                           tab_regime_alimentar,
                           tab_aptidao,
                           SglRegimeAlimentarMamando,
                           SglAptidao,
                           True);
    except
      on E: ETabErro do begin
        Result := FIntErroImportacao.SetErro(E);
        Exit;
      end;
    end;
//  end else begin
//    Result := FIntErroImportacao.SetErro(61);
//    Exit;
  end;

  // Consiste Regime Alimentar Desmamado
  if Trim(SglRegimeAlimentarDesmamado) <> '' then begin
    try
      // Verifica se é regime alimentar para animal Desmamado
      if SglToVal(tab_regime_alimentar, SglRegimeAlimentarDesmamado, 4, True) = 'S' then begin
        Result := FIntErroImportacao.SetErro(64, [CodToDes(tab_regime_alimentar,
                                                           SglToCod(tab_regime_alimentar,
                                                                    SglRegimeAlimentarDesmamado,
                                                                    True),
                                                           True)]);
        Exit;
      end;

      // Verifica relacionamento com aptidão
      ExisteRelacionamento(tab_regime_alimentar_aptidao,
                           tab_regime_alimentar,
                           tab_aptidao,
                           SglRegimeAlimentarDesmamado,
                           SglAptidao,
                           True);
    except
      on E: ETabErro do begin
        Result := FIntErroImportacao.SetErro(E);
        Exit;
      end;
    end;
  end else begin
    Result := FIntErroImportacao.SetErro(62);
    Exit;
  end;

{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.
  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaAptidaoL <> SglAptidao) or (FUltimaLocal  <> SglLocalDestino) or
       (FUltimaRAM <> SglRegimeAlimentarMamando) or (FUltimaRAD <> SglRegimeAlimentarDesmamado) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
      FArquivoEscrita.AdicionarColuna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(SglLocalDestino);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarMamando, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarDesmamado, True));

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
      FUltimaAptidaoL := SglAptidao;
      FUltimaLocal    := SglLocalDestino;
      FUltimaRAM      := SglRegimeAlimentarMamando;
      FUltimaRAD      := SglRegimeAlimentarDesmamado;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoTransferencia(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglAptidao, SglTipoLugarOrigem, SglFazendaOrigem,
  NumImovelOrigem, NumCNPJCPFOrigem, SglTipoLugarDestino,
  SglFazendaDestino, SglLocalDestino, SglLoteDestino, NumImovelDestino,
  NumCNPJCPFDestino, SglRegimeAlimentarMamando,
  SglRegimeAlimentarDesmamado, NumGTA: String;
  DtaEmissaoGTA: TDateTime): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'TR';
var
  CodTipoLugarOrigem, CodTipoLugarDestino: Integer;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end else if DtaFim = 0 then begin
    Result := FIntErroImportacao.SetErro(51);
    Exit;
  end else if DtaFim < DtaInicio then begin
    Result := FIntErroImportacao.SetErro(52);
    Exit;
  end;

  // Consistindo Aptidão
  if Trim(SglAptidao) = '' then begin
    Result := FIntErroImportacao.SetErro(53);
    Exit;
  end;

  // Consistindo tipo de lugar origem
  try
    CodTipoLugarOrigem := SglToCod(tab_tipo_lugar, SglTipoLugarOrigem, True);
    CodTipoLugarDestino := SglToCod(tab_tipo_lugar, SglTipoLugarDestino, True);
    Result := 0;
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Consistindo dados referentes a origem
  Case CodTipoLugarOrigem of
    1: begin // Fazenda
         if (NumImovelOrigem <> '') or (NumCNPJCPFOrigem <> '') then begin
           Result := FIntErroImportacao.SetErro(179);
           Exit;
         end else if (SglFazendaOrigem = '') then begin
           Result := FIntErroImportacao.SetErro(180, ['origem']);
           Exit;
         end else if Length(SglFazendaOrigem) > 2 then begin
           Result := FIntErroImportacao.SetErro(87);
           Exit;
         end;
       end;
    2: begin // Propriedade Rural
         if (SglFazendaOrigem <> '') or (NumCNPJCPFOrigem <> '') then begin
           Result := FIntErroImportacao.SetErro(175);
           Exit;
         end else if (NumImovelOrigem = '')  then begin
           Result := FIntErroImportacao.SetErro(176, ['origem']);
           Exit;
         end else if not ValidaNirfIncra(NumImovelOrigem, true) then begin
           Result := FIntErroImportacao.SetErro(172);
           Exit;
         end else if StrToIntDef(NumImovelOrigem, -1) = -1 then begin
           Result := FIntErroImportacao.SetErro(173);
           Exit;
         end;
       end;
    3: begin // Aglomeração
         if (SglFazendaOrigem <> '') or (NumImovelOrigem <> '') then begin
           Result := FIntErroImportacao.SetErro(177);
           Exit;
         end else if NumCNPJCPFOrigem = '' then begin
           Result := FIntErroImportacao.SetErro(178, ['origem']);
           Exit;
         end else begin
           Result := VerificarCNPJCPF(NumCNPJCPFOrigem);
           if Result < 0 then begin
             Exit;
           end;
         end;
       end;
    else begin
      Result := FIntErroImportacao.SetErro(181, ['origem']);
      Exit;
    end;
  end;

  // Consistindo dados referentes ao destino
  Case CodTipoLugarDestino of
    1: begin // Fazenda
         if (NumImovelDestino <> '') or (NumCNPJCPFDestino <> '') then begin
           Result := FIntErroImportacao.SetErro(179);
           Exit;
         end else if (SglFazendaDestino = '') then begin
           Result := FIntErroImportacao.SetErro(180, ['destino']);
           Exit;
         end else if Length(SglFazendaDestino) > 2 then begin
           Result := FIntErroImportacao.SetErro(87);
           Exit;
         end;
       end;
    2: begin // Propriedade Rural
         if (SglFazendaDestino <> '') or (NumCNPJCPFDestino <> '') then begin
           Result := FIntErroImportacao.SetErro(175);
           Exit;
         end else if (NumImovelDestino = '')  then begin
           Result := FIntErroImportacao.SetErro(176, ['destino']);
           Exit;
         end else if not ValidaNirfIncra(NumImovelDestino, true) then begin
           Result := FIntErroImportacao.SetErro(172);
           Exit;
         end else if StrToIntDef(NumImovelDestino, -1) = -1 then begin
           Result := FIntErroImportacao.SetErro(173);
           Exit;
         end;
       end;
    3: begin // Aglomeração
         if (SglFazendaDestino <> '') or (NumImovelDestino <> '') then begin
           Result := FIntErroImportacao.SetErro(177);
           Exit;
         end else if NumCNPJCPFDestino = '' then begin
           Result := FIntErroImportacao.SetErro(178, ['destino']);
           Exit;
         end else begin
           Result := VerificarCNPJCPF(NumCNPJCPFDestino);
           if Result < 0 then begin
             Exit;
           end;
         end;
       end;
    else begin
      Result := FIntErroImportacao.SetErro(181, ['destino']);
      Exit;
    end;
  end;

  // Consiste Regime Alimentar para animais desmamados
  if SglRegimeAlimentarDesmamado = '' then begin
    Result := FIntErroImportacao.SetErro(62);
    Exit;
  end else begin
    // Relacionamento Regime Alimentar Desmamado Destino x Aptidão
    try
      ExisteRelacionamento(tab_regime_alimentar_aptidao,
                           tab_regime_alimentar,
                           tab_aptidao,
                           SglRegimeAlimentarDesmamado,
                           SglAptidao,
                           True);
    except
      on E: ETabErro do begin
        Result := FIntErroImportacao.SetErro(E);
        Exit;
      end;
    end;
  end;

  // Consiste regime alimentar para animais mamando, caso informado
  if SglRegimeAlimentarMamando <> '' then begin
    // Relacionamento Regime Alimentar Mamando Destino x Aptidão
    try
      ExisteRelacionamento(tab_regime_alimentar_aptidao,
                           tab_regime_alimentar,
                           tab_aptidao,
                           SglRegimeAlimentarMamando,
                           SglAptidao,
                           True);
    except
      on E: ETabErro do begin
        Result := FIntErroImportacao.SetErro(E);
        Exit;
      end;
    end;
  end;

  // Consistindo data informada de emissão do GTA
  if Trim(NumGTA) <> '' then begin
    if DtaEmissaoGTA = 0 then begin
      Result := FIntErroImportacao.SetErro(69);
      Exit;
    end else if DtaEmissaoGTA > DtaInicio then begin
      Result := FIntErroImportacao.SetErro(174);
      Exit;
    end;
  end;

  if Trim(NumGTA) = '' then begin
    if DtaEmissaoGTA <> 0 then begin
      Result := FIntErroImportacao.SetErro(70);
      Exit;
    end;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, SglAptidao, True));
    FArquivoEscrita.AdicionarColuna(CodTipoLugarOrigem);
    FArquivoEscrita.AdicionarColuna(SglFazendaOrigem);
    FArquivoEscrita.AdicionarColuna(NumImovelOrigem);
    FArquivoEscrita.AdicionarColuna(NumCNPJCPFOrigem);
    FArquivoEscrita.AdicionarColuna(CodTipoLugarDestino);
    FArquivoEscrita.AdicionarColuna(SglFazendaDestino);
    FArquivoEscrita.AdicionarColuna(SglLocalDestino);
    FArquivoEscrita.AdicionarColuna(SglLoteDestino);
    FArquivoEscrita.AdicionarColuna(NumImovelDestino);
    FArquivoEscrita.AdicionarColuna(NumCNPJCPFDestino);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarMamando, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_regime_alimentar, SglRegimeAlimentarDesmamado, True));
    FArquivoEscrita.AdicionarColuna(NumGTA);
    FArquivoEscrita.AdicionarColuna(DtaEmissaoGTA);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoVendaCriador(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime; SglFazenda,
  TxtObservacao, NumImovelReceitaFederal, NumCNPJCPFCriador,
  NumGTA: String; DtaEmissaoGTA: TDateTime; CodFManejo,
  CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'VC';
var
  TIPO_LINHA: Integer;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaDataCheg <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaDataSaid <> DtaFim) or (FUltimoCpfCnpj <> NumCNPJCPFCriador) or
       (FUltimoNirf <> NumImovelReceitaFederal) or (FUltimoNumGTA <> NumGTA) or
       (FUltimaDataGTA <> DtaEmissaoGTA) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end else if DtaFim = 0 then begin
    Result := FIntErroImportacao.SetErro(51);
    Exit;
  end else if DtaFim < DtaInicio then begin
    Result := FIntErroImportacao.SetErro(52);
    Exit;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consistindo NIRF
  if Trim(NumImovelReceitaFederal) <> '' then begin
    if not ValidaNirfIncra(NumImovelReceitaFederal, true) then begin
      Result := FIntErroImportacao.SetErro(172);
      Exit;
    end else if StrToIntDef(NumImovelReceitaFederal, -1) = -1 then begin
      Result := FIntErroImportacao.SetErro(173);
      Exit;
    end;
  end;

  // Consistindo CNPJ/CPF do criador
  if Trim(NumCNPJCPFCriador) = '' then begin
    Result := FIntErroImportacao.SetErro(171);
    Exit;
  end;

  Result := VerificarCNPJCPF(NumCNPJCPFCriador);
  if Result < 0 then begin
    Exit;
  end;

  // Consistindo data informada de emissão do GTA
  if Trim(NumGTA) <> '' then begin
    if DtaEmissaoGTA = 0 then begin
      Result := FIntErroImportacao.SetErro(69);
      Exit;
    end;
  end;

  if Trim(NumGTA) = '' then begin
    if DtaEmissaoGTA <> 0 then begin
      Result := FIntErroImportacao.SetErro(70);
      Exit;
    end;
  end;

{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    if (FUltimaDataCheg <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaDataSaid <> DtaFim) or (FUltimoCpfCnpj <> NumCNPJCPFCriador) or
       (FUltimoNirf <> NumImovelReceitaFederal) or (FUltimoNumGTA <> NumGTA) or
       (FUltimaDataGTA <> DtaEmissaoGTA) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(NumImovelReceitaFederal);
      FArquivoEscrita.AdicionarColuna(NumCNPJCPFCriador);
      FArquivoEscrita.AdicionarColuna(NumGTA);
      FArquivoEscrita.AdicionarColuna(DtaEmissaoGTA);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaDataCheg := DtaInicio;
      FUltimaDataSaid := DtaFim;
      FUltimaFazenda  := SglFazenda;
      FUltimoNirf     := NumImovelReceitaFederal;
      FUltimoCpfCnpj  := NumCNPJCPFCriador;
      FUltimoNumGTA   := NumGTA;
      FUltimaDataGTA  := DtaEmissaoGTA;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoVendaFrigorifico(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  SglFazenda, TxtObservacao, NumCNPJCPFFrigorifico, NumGTA: String;
  DtaEmissaoGTA: TDateTime; CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'VF';
var
  TIPO_LINHA: Integer;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaDataCheg <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaDataSaid <> DtaFim) or (FUltimoCpfCnpj <> NumCNPJCPFFrigorifico) or
       (FUltimoNumGTA <> NumGTA) or (FUltimaDataGTA <> DtaEmissaoGTA) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  if Trim(NumCNPJCPFFrigorifico) = '' then begin
    Result := FIntErroImportacao.SetErro(68);
    Exit;
  end;

  Result := VerificarCNPJCPF(NumCNPJCPFFrigorifico);
  if Result < 0 then begin
    Exit;
  end;

  if Trim(NumGTA) <> '' then begin
    if DtaEmissaoGTA = 0 then begin
      Result := FIntErroImportacao.SetErro(69);
      Exit;
    end;
  end;

  if Trim(NumGTA) = '' then begin
    if DtaEmissaoGTA <> 0 then begin
      Result := FIntErroImportacao.SetErro(70);
      Exit;
    end;
  end;

  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    if (FUltimaDataCheg <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaDataSaid <> DtaFim) or (FUltimoCpfCnpj <> NumCNPJCPFFrigorifico) or
       (FUltimoNumGTA <> NumGTA) or (FUltimaDataGTA <> DtaEmissaoGTA) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(NumCNPJCPFFrigorifico);
      FArquivoEscrita.AdicionarColuna(NumGTA);
      FArquivoEscrita.AdicionarColuna(DtaEmissaoGTA);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaDataCheg := DtaInicio;
      FUltimaDataSaid := DtaFim;
      FUltimaFazenda  := SglFazenda;
      FUltimoCpfCnpj  := NumCNPJCPFFrigorifico;
      FUltimoNumGTA   := NumGTA;
      FUltimaDataGTA  := DtaEmissaoGTA;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoDesaparecimento(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  SglFazenda, TxtObservacao, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'DP';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

{****
  Foi retirado essa consistência, pois, o evento passou
  a ser digitado por coluna.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData     := DtaInicio;
      FUltimaFazenda  := SglFazenda;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoMorte(CodIdentificadorEvento: String;
  DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, SglTipoMorte,
  SglCausaMorte, CodFManejo, CodManejo: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'MT';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Implemta a sequencia de eventos para a planilha cadastrada 
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaTipoMorte <> SglTipoMorte) or (FUltimaCausaMorte <> SglCausaMorte) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  if Trim(SglTipoMorte) = '' then begin
    Result := FIntErroImportacao.SetErro(71);
    Exit;
  end;
  if Trim(SglCausaMorte) = '' then begin
    Result := FIntErroImportacao.SetErro(72);
    Exit;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consiste se tipo e causa da morte são compatíveis
  try
    ExisteRelacionamento(tab_tipo_causa_morte,
                         tab_tipo_morte,
                         tab_causa_morte,
                         SglTipoMorte,
                         SglCausaMorte,
                         True);
  except
    on E: ETabErro do begin
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

{****
   O evento mudou para colunas por isso esta consistência
   foi retirada.
  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    // Se mudar a data de início, fazenda, tipo de morte ou a causa de morte,
    // insere um novo evento
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimaTipoMorte <> SglTipoMorte) or (FUltimaCausaMorte <> SglCausaMorte) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_morte, SglTipoMorte, True));
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_causa_morte, SglCausaMorte, True));
      FArquivoEscrita.Adicionarcoluna(SglFazenda);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);

      FUltimaData       := DtaInicio;
      FUltimaFazenda    := SglFazenda;
      FUltimaTipoMorte  := SglTipoMorte;
      FUltimaCausaMorte := SglCausaMorte;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoPesagem(CodIdentificadorEvento: String;
  DtaInicio, DtaFim: TDateTime; SglFazenda, TxtObservacao, CodFManejo,
  CodManejo: String; Peso: Double): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'PE';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia do evento a ser importado
  if FSeqEvento = 0 then begin
    FSeqEvento := 1;
  end else begin
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimoEvento <> FSeqEvento) then begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

{****
  Consistência retirada, pois, o evento agora passou a
  ser inserido como coluna.

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;
****}

  // Adiciona colunas
  try
    if (FUltimaData <> DtaInicio) or (FUltimaFazenda <> SglFazenda) or
       (FUltimoEvento <> FSeqEvento) then begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(DtaInicio);
      FArquivoEscrita.AdicionarColuna(DtaFim);
      FArquivoEscrita.AdicionarColuna(TxtObservacao);
      FArquivoEscrita.Adicionarcoluna(SglFazenda);

      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
      FArquivoEscrita.Adicionarcoluna(Peso);

      FUltimaData    := DtaInicio;
      FUltimaFazenda := SglFazenda;
      FUltimoEvento  := FSeqEvento;
    end else begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(CodFManejo);
      FArquivoEscrita.Adicionarcoluna(CodManejo);
      FArquivoEscrita.Adicionarcoluna(Peso);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, True, False, False, False);
end;

function TImportacao.AplicarEventoAnimal(CodIdentificadorEvento,
  SglFazendaManejo, CodAnimalManejo: String; QtdPesoAnimal: Double;
  IndVacaPrenha, IndTouroApto: String): Integer;
const
  TIPO_LINHA: Integer = 6;
  DES_TIPO: String    = 'ANIMAIS ASSOCIADOS A EVENTOS';
var
  EventoPesagem, EventoDiagnosticoPrenhez, EventoExameAndrologico: Boolean;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimaAvaliacao := '';  
  FUltimoAnimal  := '';

  // Consistências
  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  if not ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(39, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  Result := EEventoEspecial(CodIdentificadorEvento);
  if Result < 0 then begin
    Exit;
  end;
  EventoPesagem := (Result = 1);
  EventoDiagnosticoPrenhez := (Result = 2);
  EventoExameAndrologico := (Result = 3);

  if Trim(SglFazendaManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(44);
    Exit;
  end;
  if Length(SglFazendaManejo) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodAnimalManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(45);
    Exit;
  end;
  if Length(CodAnimalManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(84);
    Exit;
  end;
  if EventoPesagem then begin
    if QtdPesoAnimal <= 0 then begin
      Result := FIntErroImportacao.SetErro(73);
      Exit;
    end;
  end else if EventoDiagnosticoPrenhez then begin
    if (IndVacaPrenha <> 'S') and (IndVacaPrenha <> 'N') then begin
      Result := FIntErroImportacao.SetErro(157);
      Exit;
    end;
  end else if EventoExameAndrologico then begin
    if (IndTouroApto <> 'S') and (IndTouroApto <> 'N') then begin
      Result := FIntErroImportacao.SetErro(158);
      Exit;
    end;
  end;
  if ExisteAnimalEvento(CodIdentificadorEvento, SglFazendaManejo, CodAnimalManejo) then begin
    Result := FIntErroImportacao.SetErro(40, [SglFazendaManejo, CodAnimalManejo, CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejo);
    if EventoPesagem then begin
      FArquivoEscrita.AdicionarColuna(QtdPesoAnimal);
    end else if EventoDiagnosticoPrenhez then begin
      FArquivoEscrita.AdicionarColuna(IndVacaPrenha);
    end else if EventoExameAndrologico then begin
      FArquivoEscrita.AdicionarColuna(IndTouroApto);
    end;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarAnimalEvento(CodIdentificadorEvento, SglFazendaManejo, CodAnimalManejo);
end;

function TImportacao.DefinirComposicaoRacial(SglFazendaManejo,
  CodAnimalManejo, SglRaca: String;
  QtdComposicaoRacial: Extended): Integer;
const
  TIPO_LINHA: Integer = 7;
  DES_TIPO: String    = 'DEFINIÇÃO DE COMPOSIÇÃO RACIAL';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

// Foi retirado a consistência da fazenda manejo,
// porque estava consistindo também para animal
// externo. Com isso a consistencia será feita
// apenas na inserção da composição no Herdom. 
//  if Trim(SglFazendaManejo) = '' then begin
//    Result := FIntErroImportacao.SetErro(44);
//    Exit;
//  end;

  if Length(SglFazendaManejo) > 2 then begin
    Result := FIntErroImportacao.SetErro(85);
    Exit;
  end;
  if Trim(CodAnimalManejo) = '' then begin
    Result := FIntErroImportacao.SetErro(45);
    Exit;
  end;
  if Length(CodAnimalManejo) > 8 then begin
    Result := FIntErroImportacao.SetErro(84);
    Exit;
  end;
  if Trim(SglRaca) = '' then begin
    Result := FIntErroImportacao.SetErro(126);
    Exit;
  end;
  if (QtdComposicaoRacial <= 0) or (QtdComposicaoRacial > 1) then begin
    Result := FIntErroImportacao.SetErro(127);
    Exit;
  end;

  if ExisteComposicaoRacial(SglFazendaManejo, CodAnimalManejo, SglRaca) then begin
    Result := FIntErroImportacao.SetErro(128, [SglFazendaManejo, CodAnimalManejo, SglRaca, FNomArquivoEscrita]);
    Exit;
  end;

  if (FUltimaFazenda = '') and (FUltimoAnimal = '') then begin
    FUltimaFazenda := SglFazendaManejo;
    FUltimoAnimal  := CodAnimalManejo;
    FQtdCompRacial := 0;
  end;

  // Verifica se o animal atual é diferente do último, significando que houve quebra
  if (FUltimaFazenda <> SglFazendaManejo) or (FUltimoAnimal <> CodAnimalManejo) then begin
    FQtdCompRacial := QtdComposicaoRacial;
  end else begin
    FQtdCompRacial := FQtdCompRacial + QtdComposicaoRacial;
  end;

  try
    // Consiste se raça é pura
    if SglToVal(tab_raca, SglRaca, 4, True) <> 'S' then begin
      Result := FIntErroImportacao.SetErro(148, [SglRaca]);
      Exit;
    end;

    // Consiste se composição racial para o mesmo animal não passou de 1
    if FQtdCompRacial > 1 then begin
      Result := FIntErroImportacao.SetErro(141, [SglFazendaManejo, CodAnimalManejo]);
      Exit;
    end;

    // Verifica se é necessário gerar comentário
    if FIndGerarComentarios then begin
      if FUltimoTipoLinha <> TIPO_LINHA then begin
        FArquivoEscrita.AdicionarLinha;
        FArquivoEscrita.AdicionarComentario(DES_TIPO);
        FUltimoTipoLinha := TIPO_LINHA;
      end;
    end;
    FArquivoEscrita.TipoLinha := TIPO_LINHA;

    // Adiciona colunas
    FArquivoEscrita.AdicionarColuna(SglFazendaManejo);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejo);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_raca, SglRaca, True));
    FArquivoEscrita.AdicionarColuna(QtdComposicaoRacial);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarComposicaoRacial(SglFazendaManejo, CodAnimalManejo, SglRaca);
end;

function TImportacao.MostrarDialogAbrir(NomeArquivo,
  Caption: String): String;
var
  Od: TOpenDialog;
begin
  Result := '';
  Od := TOpenDialog.Create(nil);
  try
    try
      Od.DefaultExt := 'xhp';
      Od.Filter := 'Parâmetros de certificadora (*.xhp)|*.xhp|Todos os arquivos (*.*)|*.*';
      if NomeArquivo <> '' then begin
        Od.FileName := ExtractFileName(NomeArquivo);
        Od.InitialDir := ExtractFilePath(NomeArquivo);
      end;
      if Caption <> '' then begin
        Od.Title := Caption;
      end;
      Od.Options := [ofHideReadonly, ofFileMustExist, ofEnableSizing];
      if Od.Execute then begin
        Result := Od.FileName;
      end;
    except
      on E:exception do begin
        FIntErroImportacao.SetErro(129, [E.Message]);
        Result := '#ERRO#';
        Exit;
      end;
    end;
  finally
    Od.Free;
  end;
end;

function TImportacao.MostrarDialogSalvar(NomeArquivo,
  Caption: String): String;
var
  Sd: TSaveDialog;
begin
  Result := '';
  Sd := TSaveDialog.Create(nil);
  try
    try
      Sd.DefaultExt := 'zip';
      Sd.Filter := 'Arquivos de dados xHerdom compactados (*.zip)|*.zip|Arquivos de dados xHerdom (*.xhu)|*.xhu|Todos os arquivos (*.*)|*.*';
//      Sd.DefaultExt := 'xhu';
//      Sd.Filter := 'Arquivos de dados xHerdom (*.xhu)|*.xhu|Todos os arquivos (*.*)|*.*';
      if NomeArquivo <> '' then begin
        Sd.FileName := ExtractFileName(NomeArquivo);
        Sd.InitialDir := ExtractFilePath(NomeArquivo);
      end;
      if Caption <> '' then begin
        Sd.Title := Caption;
      end;
      Sd.Options := [ofOverwritePrompt, ofHideReadonly, ofEnableSizing];
      if Sd.Execute then begin
        Result := Sd.FileName;
      end;
    except
      on E:exception do begin
        FIntErroImportacao.SetErro(130, [E.Message]);
        Result := '#ERRO#';
        Exit;
      end;
    end;
  finally
    Sd.Free;
  end;
end;

function TImportacao.MostrarFormProgresso(Caption, TxtInfo1,
  TxtInfo2: String; IndBarraProgresso, ValMinBarraProgresso,
  ValMaxBarraProgresso: Integer): Integer;
begin
  Result := 0;
  if FrmProgresso <> nil then begin
    Result := FIntErroImportacao.SetErro(131);
    Exit;
  end;
  if IndBarraProgresso <> 0 then begin
    if ValMinBarraProgresso > ValMaxBarraProgresso then begin
      Result := FIntErroImportacao.SetErro(132);
      Exit;
    end;
  end;
  try
    // Form
    FrmProgresso := TForm.Create(nil);
    if Caption <> '' then begin
      FrmProgresso.Caption := Caption;
    end else begin
      FrmProgresso.Caption := 'Processamento ' + FNomArquivoEscrita;
    end;
    FrmProgresso.BorderIcons  := [];
    FrmProgresso.BorderStyle  := bsDialog;
    if IndBarraProgresso <> 0 then begin
      FrmProgresso.ClientHeight := 123;
    end else begin
      FrmProgresso.ClientHeight := 93;
    end;
    FrmProgresso.ClientWidth  := 390;
    FrmProgresso.FormStyle    := fsStayonTop;
    FrmProgresso.Position     := poScreenCenter;
    FrmProgresso.onClose      := FrmProgressoClose;
    // Label Info1
    LbInfo1 := TLabel.Create(FrmProgresso);
    LbInfo1.Parent := FrmProgresso;
    LbInfo1.Left     := 8;
    LbInfo1.Top      := 8;
    LbInfo1.Width    := 373;
    LbInfo1.Height   := 13;
    LbInfo1.AutoSize := False;
    LbInfo1.Caption  := TxtInfo1;
    // Label Info2
    LbInfo2 := TLabel.Create(FrmProgresso);
    LbInfo2.Parent := FrmProgresso;
    LbInfo2.Left     := 8;
    LbInfo2.Top      := 36;
    LbInfo2.Width    := 373;
    LbInfo2.Height   := 13;
    LbInfo2.AutoSize := False;
    LbInfo2.Caption  := TxtInfo2;
    // Progress Bar
    if IndBarraProgresso <> 0 then begin
      Barra := TProgressBar.Create(FrmProgresso);
      Barra.Parent   := FrmProgresso;
      Barra.Left     := 8;
      Barra.Top      := 64;
      Barra.Width    := 373;
      Barra.Height   := 13;
      Barra.TabStop  := False;
      Barra.Min      := ValMinBarraProgresso;
      Barra.Max      := ValMaxBarraProgresso;
    end;
    // Botão
    BtCancelar := TButton.Create(FrmProgresso);
    BtCancelar.Parent   := FrmProgresso;
    BtCancelar.Left     := 140;
    if IndBarraProgresso <> 0 then begin
      BtCancelar.Top    := 92;
    end else begin
      BtCancelar.Top    := 64;
    end;
    BtCancelar.Width    := 109;
    BtCancelar.Height   := 25;
    BtCancelar.Caption  := 'Cancelar';
    BtCancelar.TabOrder := 0;
    BtCancelar.Cursor   := 0;
    BtCancelar.onClick  := BtCancelarClick;
    FIndCancelar := False;

    FrmProgresso.Show;
    Application.ProcessMessages;
  except
    on E:exception do begin
      Result := FIntErroImportacao.SetErro(133, [E.Message]);
      Exit;
    end;
  end;
end;

procedure TImportacao.FrmProgressoClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caNone;
end;

procedure TImportacao.BtCancelarClick(Sender: TObject);
begin
  Screen.Cursor := -19;  // crAppStart
  FIndCancelar := True;
end;

function TImportacao.AtualizarFormProgresso(IndTipoInfo: Integer;
  ValInfo: Variant): Integer;
begin
  Application.ProcessMessages;
  if FIndCancelar then begin
    Result := -1;
    Exit;
  end else begin
    Result := 0;
  end;
  if FrmProgresso = nil then begin
    Result := FIntErroImportacao.SetErro(134);
    Exit;
  end;
  try
    Case IndTipoInfo of
      1: begin
           LbInfo1.Caption := String(ValInfo);
         end;
      2: begin
           LbInfo2.Caption := String(ValInfo);
         end;
      3: begin
           if Barra = nil then begin
             Result := FIntErroImportacao.SetErro(138);
             Exit;
           end;
           if (StrToInt(String(ValInfo)) < Barra.Min) or
              (StrToInt(String(ValInfo)) > Barra.Max) then begin
             Result := FIntErroImportacao.SetErro(136, [IntToStr(Barra.Min), IntToStr(Barra.Max)]);
             Exit;
           end else begin
             Barra.Position := StrToInt(ValInfo);
           end;
         end;
    else
      Result := FIntErroImportacao.SetErro(135);
      Exit;
    end;
  except
    on E:exception do begin
      Result := FIntErroImportacao.SetErro(137, [IntToStr(IndTipoInfo), E.Message]);
      Exit;
    end;
  end;
end;

function TImportacao.FecharFormProgresso: Integer;
begin
  Result := 0;
  if FrmProgresso <> nil then begin
    FrmProgresso.Free;
  end;
  FrmProgresso := nil;
  LbInfo1 := nil;
  LbInfo2 := nil;
  Barra := nil;
  BtCancelar := nil;
end;

function TImportacao.InserirEventoCoberturaRegimePasto(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda, SglFazendaManejoAnimalRM,
  CodAnimalManejoAnimalRM: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'RP';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end else if DtaFim = 0 then begin
    Result := FIntErroImportacao.SetErro(51);
    Exit;
  end else if DtaFim < DtaInicio then begin
    Result := FIntErroImportacao.SetErro(52);
    Exit;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consistindo fazenda de manejo do animal ou rm
  if Trim(SglFazendaManejoAnimalRM) = '' then begin
    Result := FIntErroImportacao.SetErro(153);
    Exit;
  end;
  if Length(SglFazendaManejoAnimalRM) > 2 then begin
    Result := FIntErroImportacao.SetErro(154);
    Exit;
  end;

  // Consistindo código de manejo do animal ou rm
  if Trim(CodAnimalManejoAnimalRM) = '' then begin
    Result := FIntErroImportacao.SetErro(155);
    Exit;
  end;
  if Length(CodAnimalManejoAnimalRM) > 8 then begin
    Result := FIntErroImportacao.SetErro(156);
    Exit;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.AdicionarColuna(SglFazenda);
    FArquivoEscrita.AdicionarColuna(SglFazendaManejoAnimalRM);
    FArquivoEscrita.AdicionarColuna(CodAnimalManejoAnimalRM);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoDiagnosticoPrenhez(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'DP';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.Adicionarcoluna(SglFazenda);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, True, False, False);
end;

function TImportacao.InserirEventoEstacaoMonta(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda, SglEstacaoMonta,
  DesEstacaoMonta: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'RM';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end else if DtaFim = 0 then begin
    Result := FIntErroImportacao.SetErro(51);
    Exit;
  end else if DtaFim < DtaInicio then begin
    Result := FIntErroImportacao.SetErro(52);
    Exit;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consistindo SglEstacaoMonta
  if Trim(SglEstacaoMonta) = '' then begin
    Result := FIntErroImportacao.SetErro(149);
    Exit;
  end;
  if Length(SglEstacaoMonta) > 4 then begin
    Result := FIntErroImportacao.SetErro(150);
    Exit;
  end;

  // Consistindo DesEstacaoMonta
  if Trim(DesEstacaoMonta) = '' then begin
    Result := FIntErroImportacao.SetErro(151);
    Exit;
  end;
  if Length(DesEstacaoMonta) > 20 then begin
    Result := FIntErroImportacao.SetErro(152);
    Exit;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.AdicionarColuna(SglFazenda);
    FArquivoEscrita.AdicionarColuna(SglEstacaoMonta);
    FArquivoEscrita.AdicionarColuna(DesEstacaoMonta);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoExameAndrologico(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'AN';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.Adicionarcoluna(SglFazenda);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, True, False)
  ;
end;

function TImportacao.InserirEventoCoberturaInseminacaoArtificial(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda: String; HraEvento: TDateTime;
  SglFazendaManejoTouro, CodAnimalManejoTouro, NumPartida,
  SglFazendaManejoFemea, CodAnimalManejoFemea: String; QtdDoses: Integer;
  NumCNPJCPFInseminador: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'IA';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consistindo hora
  if HraEvento = 0 then begin
    Result := FIntErroImportacao.SetErro(168);
    Exit;
  end;

  // Consistindo fazenda de manejo do touro
  // O sêmen pode ser proveniente de um animal externo do produtor, neste caso
  // específico a sigla da fazenda de manejo do mesmo poder vazia, caracterís-
  // tica individual de animais externos
  if Length(SglFazendaManejoTouro) > 2 then begin
    Result := FIntErroImportacao.SetErro(160);
    Exit;
  end;

  // Consistindo código de manejo do touro
  if Trim(CodAnimalManejoTouro) = '' then begin
    Result := FIntErroImportacao.SetErro(161);
    Exit;
  end;
  if Length(CodAnimalManejoTouro) > 8 then begin
    Result := FIntErroImportacao.SetErro(162);
    Exit;
  end;

  // Consistindo número da partida
  if Length(NumPartida) > 8 then begin
    Result := FIntErroImportacao.SetErro(163);
    Exit;
  end;

  // Consistindo fazenda de manejo da fêmea
  if Trim(SglFazendaManejoFemea) = '' then begin
    Result := FIntErroImportacao.SetErro(164);
    Exit;
  end;
  if Length(SglFazendaManejoFemea) > 2 then begin
    Result := FIntErroImportacao.SetErro(165);
    Exit;
  end;

  // Consistindo código de manejo da fêmea
  if Trim(CodAnimalManejoFemea) = '' then begin
    Result := FIntErroImportacao.SetErro(166);
    Exit;
  end;
  if Length(CodAnimalManejoFemea) > 8 then begin
    Result := FIntErroImportacao.SetErro(167);
    Exit;
  end;

  // Consistindo o número de doses
  if QtdDoses = 0 then begin
    Result := FIntErroImportacao.SetErro(169);
    Exit;
  end else if (QtdDoses < 0) or (QtdDoses > 9) then begin
    Result := FIntErroImportacao.SetErro(170);
    Exit;
  end;

  // Consistindo CNPJCPF do inseminador
  if NumCNPJCPFInseminador <> '' then begin
    Result := VerificarCNPJCPF(NumCNPJCPFInseminador);
    if Result < 0 then begin
      Exit;
    end;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.Adicionarcoluna(SglFazenda);
    FArquivoEscrita.Adicionarcoluna(HraEvento);
    FArquivoEscrita.Adicionarcoluna(SglFazendaManejoTouro);
    FArquivoEscrita.Adicionarcoluna(CodAnimalManejoTouro);
    FArquivoEscrita.Adicionarcoluna(NumPartida);
    FArquivoEscrita.Adicionarcoluna(SglFazendaManejoFemea);
    FArquivoEscrita.Adicionarcoluna(CodAnimalManejoFemea);
    FArquivoEscrita.Adicionarcoluna(QtdDoses);
    FArquivoEscrita.Adicionarcoluna(NumCNPJCPFInseminador);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

function TImportacao.InserirEventoCoberturaMontaControlada(
  CodIdentificadorEvento: String; DtaInicio, DtaFim: TDateTime;
  TxtObservacao, SglFazenda, SglFazendaManejoTouro, CodAnimalManejoTouro,
  SglFazendaManejoFemea, CodAnimalManejoFemea: String): Integer;
const
  TIPO_LINHA: Integer = 5;
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'MC';
begin
  Result := 0;

  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  if Trim(CodIdentificadorEvento) = '' then begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  // Consistindo datas
  if DtaInicio = 0 then begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;
  if DtaFim > 0 then begin
    if DtaFim < DtaInicio then begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  // Consistindo fazenda
  if Trim(SglFazenda) = '' then begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;
  if Length(SglFazenda) > 2 then begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  // Consistindo fazenda de manejo do touro
  if Trim(SglFazendaManejoTouro) = '' then begin
    Result := FIntErroImportacao.SetErro(159);
    Exit;
  end;
  if Length(SglFazendaManejoTouro) > 2 then begin
    Result := FIntErroImportacao.SetErro(160);
    Exit;
  end;

  // Consistindo código de manejo do touro
  if Trim(CodAnimalManejoTouro) = '' then begin
    Result := FIntErroImportacao.SetErro(161);
    Exit;
  end;
  if Length(CodAnimalManejoTouro) > 8 then begin
    Result := FIntErroImportacao.SetErro(162);
    Exit;
  end;

  // Consistindo fazenda de manejo da fêmea
  if Trim(SglFazendaManejoFemea) = '' then begin
    Result := FIntErroImportacao.SetErro(164);
    Exit;
  end;
  if Length(SglFazendaManejoFemea) > 2 then begin
    Result := FIntErroImportacao.SetErro(165);
    Exit;
  end;

  // Consistindo código de manejo da fêmea
  if Trim(CodAnimalManejoFemea) = '' then begin
    Result := FIntErroImportacao.SetErro(166);
    Exit;
  end;
  if Length(CodAnimalManejoFemea) > 8 then begin
    Result := FIntErroImportacao.SetErro(167);
    Exit;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteEvento(CodIdentificadorEvento) then begin
    Result := FIntErroImportacao.SetErro(38, [CodIdentificadorEvento, FNomArquivoEscrita]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(CodIdentificadorEvento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
    FArquivoEscrita.AdicionarColuna(DtaInicio);
    FArquivoEscrita.AdicionarColuna(DtaFim);
    FArquivoEscrita.AdicionarColuna(TxtObservacao);
    FArquivoEscrita.Adicionarcoluna(SglFazenda);
    FArquivoEscrita.Adicionarcoluna(SglFazendaManejoTouro);
    FArquivoEscrita.Adicionarcoluna(CodAnimalManejoTouro);
    FArquivoEscrita.Adicionarcoluna(SglFazendaManejoFemea);
    FArquivoEscrita.Adicionarcoluna(CodAnimalManejoFemea);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(CodIdentificadorEvento, False, False, False, False);
end;

{*******************************************************************************
* Função responsavel para validar se o valor é um numero do incra ou um
* nirf válido
*
* Parametros de Entrada:
*      nirfIncra - String com o valor do nirf ou incra.
*      IndObrigatorio - Variavel booleana que indica que o valor deve ser obrigatorio.
*                       se o valor desta variavel for false e a variavel nirfIncra
*                       for vazia o retorno da função sera falso.
*
* Retorno:
*    Retoroa true se o nirfInca for um numero nirf ou incra valido.
*******************************************************************************}
function TImportacao.ValidaNirfIncra(nirfIncra: String; IndObrigatorio: Boolean): Boolean;
var
  valor: String;
begin
  Result := False;
  valor := Trim(nirfIncra);

  { Se a string for vazia e o valor for obrigatorio retorna false, }
  { caso contrario retorna true                                    }
  if (valor = '') then
  begin
    if not IndObrigatorio then
      Result := True;

    Exit;
  end;

  { Verfica se o valor é um Nirf, se for retorna true }
  if Length(valor) = 8 then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;

  { Se o valor é um numero INCRA valida o Digito verificador }
  if Length(valor) = 13 then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;
end;

{*******************************************************************************
* Valida se a string possui somente caracteres numericos
*
* Parametros de Entrada:
*      nirfIncra - String a ser validada
*
* Retorno:
*    Retoroa true se a string possuir somente caracteres numericos
*    e false caso contrario
*******************************************************************************}
function TImportacao.ehNumerico(valor: String): boolean;
var
  I: Integer;
begin
  Result := True;

  I := 1;
  while Result and (I <= Length(valor)) do
  begin
    if not (valor[I] in ['1', '2', '3', '4', '5' ,'6', '7','8', '9', '0']) then
      Result := False;
    Inc(I);
  end;
end;

function TImportacao.InserirAnimalNaoEspecifico(ECodAnimalSISBOV, EIndSexo,
  ESglAptidao, ESglRaca: String;
  EDtaNascimento: TDateTime; ESglTipoIdentificador1,
  ESglPosicaoIdentificador1, ESglTipoIdentificador2,
  ESglPosicaoIdentificador2: String; EDtaIdentificacaoSISBOV: TDateTime;
  ESglFazendaIdentificacao, ENumCNPJCPFTecnico,
  EIndEfetivar: String): Integer;
const
  TIPO_LINHA: Integer = 1;
  DES_TIPO: String    = 'ANIMAIS (INSERÇÃO - Específico rastreabilidade)';
var
  CodIdent: Integer;
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';
  FUltimoAnimal  := '';

  // Trata os parametros da função
  ECodAnimalSISBOV := Trim(ECodAnimalSISBOV);
  EIndSexo := Trim(EIndSexo);
  ESglAptidao := Trim(ESglAptidao);
  ESglRaca := Trim(ESglRaca);
  ESglTipoIdentificador1 := Trim(ESglTipoIdentificador1);
  ESglPosicaoIdentificador1 := Trim(ESglPosicaoIdentificador1);
  ESglTipoIdentificador2 := Trim(ESglTipoIdentificador2);
  ESglPosicaoIdentificador2 := Trim(ESglPosicaoIdentificador2);
  ESglFazendaIdentificacao := Trim(ESglFazendaIdentificacao);
  EIndEfetivar := Trim(EIndEfetivar);
  // Fim do tratamento dos parametros

  // Consistências
  try
    if ECodAnimalSISBOV = '' then
    begin
      Result := FIntErroImportacao.SetErro(214);
      Exit;
    end
    else
    begin
      Result := VerificarSisbov(ECodAnimalSISBOV);
      if Result < 0 then
      begin
        Exit;
      end; 

      if Length(ECodAnimalSISBOV) = 12 then
      begin
        ECodAnimalSISBOV := '105' + ECodAnimalSISBOV;
      end;


      Result := VerificarSisbov(ECodAnimalSisbov);
      if Result < 0 then begin
        Exit;
      end;
    end;

    if (ESglFazendaIdentificacao = '') then
    begin
      Result := FIntErroImportacao.SetErro(216);
      Exit;
    end;

    // Sexo
    if (Uppercase(EIndSexo) <> 'M') and (Uppercase(EIndSexo) <> 'F') then
    begin
      Result := FIntErroImportacao.SetErro(97);
      Exit;
    end;

    if ESglAptidao = '' then
    begin
      Result := FIntErroImportacao.SetErro(53);
      Exit;
    end;

    if ESglRaca = '' then
    begin
      Result := FIntErroImportacao.SetErro(126);
      Exit;
    end;

    // Raça e Aptidão
    if (ESglRaca <> '') and (ESglAptidao <> '') then begin
      ExisteRelacionamento(tab_raca_aptidao,
                           tab_raca,
                           tab_aptidao,
                           ESglRaca,
                           ESglAptidao,
                           True);
    end;

    // Data de Nascimento
    if (EDtaNascimento <= 0) then begin
      Result := FIntErroImportacao.SetErro(25);
      Exit;
    end;

    // Consiste data de nascimento do animal caso seja informada
    if (EDtaNascimento > 0) and (EDtaNascimento > Date) then begin
      Result := FIntErroImportacao.SetErro(207, [DateTimeToStr(EDtaNascimento)]);
      Exit;
    end;

    if (ESglTipoIdentificador1 = '') then
    begin
      Result := FIntErroImportacao.SetErro(215, ['1']);
      Exit;
    end;

{   De acordo com a liberação do Sisbov que passou a aceitar apenas um identificador,
    foi retirado essa consistência.
    if (ESglTipoIdentificador2 = '') then
    begin
      Result := FIntErroImportacao.SetErro(215, ['2']);
      Exit;
    end;
}
    // Consiste se a data de identificacao e menor que a data de nascimento. Se for, ERRO.
    if (EDtaNascimento > 0) and (EDtaIdentificacaoSisbov > 0) and (EDtaIdentificacaoSisbov < EDtaNascimento) then begin
      Result := FIntErroImportacao.SetErro(27, []);
      Exit;
    end;

    // Consiste data de identificacao animal caso seja informada
    if (EDtaIdentificacaoSisbov > 0) and (EDtaIdentificacaoSisbov > Date) then
    begin
      Result := FIntErroImportacao.SetErro(206, [DateTimeToStr(EDtaIdentificacaoSisbov)]);
      Exit;
    end;

    if (Trim(ESglTipoIdentificador1) <> '') and (Trim(ESglTipoIdentificador2) <> '') then
    begin
      if Trim(ESglTipoIdentificador1) = Trim(ESglTipoIdentificador2) then
      begin
        Result := FIntErroImportacao.SetErro(219, [DateTimeToStr(EDtaIdentificacaoSisbov)]);
        Exit;
      end;
    end;

    // Consiste identificador 1
    if Trim(ESglTipoIdentificador1) <> '' then begin
      CodIdent := SglToCod(tab_tipo_identificador, ESglTipoIdentificador1, True);
      if Trim(ESglPosicaoIdentificador1) <> '' then begin
        if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                    tab_posicao_identificador,
                                    tab_grupo_identificador,
                                    ESglPosicaoIdentificador1,
                                    SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                    True) then begin
          Result := FIntErroImportacao.SetErro(76, ['1']);
          Exit;
        end;
      end;
    end else begin
      if Trim(ESglPosicaoIdentificador1) <> '' then begin
        Result := FIntErroImportacao.SetErro(74, ['1']);
        Exit;
      end;
    end;

    // Consiste identificador 2
    if Trim(ESglTipoIdentificador2) <> '' then begin
      CodIdent := SglToCod(tab_tipo_identificador, ESglTipoIdentificador2, True);
      if Trim(ESglPosicaoIdentificador2) <> '' then begin
        if not ExisteRelacionamento(tab_grupo_posicao_ident,
                                    tab_posicao_identificador,
                                    tab_grupo_identificador,
                                    ESglPosicaoIdentificador2,
                                    SglToCod(tab_grupo_identificador, CodToVal(tab_tipo_identificador, CodIdent, 6, True), True),
                                    True) then begin
          Result := FIntErroImportacao.SetErro(76, ['2']);
          Exit;
        end;
      end;
    end else begin
      if Trim(ESglPosicaoIdentificador2) <> '' then begin
        Result := FIntErroImportacao.SetErro(74, ['2']);
        Exit;
      end;
    end;

    if Length(ESglFazendaIdentificacao) > 2 then
    begin
      Result := FIntErroImportacao.SetErro(89);
      Exit;
    end;

    //CNPJ CPF do Técnico
    if (ENumCNPJCPFTecnico <> '') and ((Length(ENumCNPJCPFTecnico) <> 11) and (Length(ENumCNPJCPFTecnico) <> 14)) then
    begin
      Result := FIntErroImportacao.SetErro(205, [ENumCNPJCPFTecnico]);
      Exit;
    end
    else
    begin
      if not ValidaCnpjCpf(ENumCNPJCPFTecnico, True, False) then
      begin
        Result := FIntErroImportacao.SetErro(205, [ENumCNPJCPFTecnico]);
        Exit;
      end;
    end;

    // IndEfetivar
    if (EIndEfetivar <> 'S') and (EIndEfetivar <> 'N') then begin
      Result := FIntErroImportacao.setErro(201);
      Exit;
    end;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Verifica se registro já não foi gravado no arquivo
  Result := ExisteAnimalNaoEspecificado(ECodAnimalSisbov);
  case Result of
    3: // Animal já existente com o mesmo código SISBOV
    begin
      Result := FIntErroImportacao.SetErro(36, [ECodAnimalSisbov, FNomArquivoEscrita]);
      Exit;
    end;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(ECodAnimalSISBOV);
    FArquivoEscrita.AdicionarColuna(EIndSexo);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_aptidao, ESglAptidao, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_raca, ESglRaca, True));
    FArquivoEscrita.AdicionarColuna(EDtaNascimento);
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, ESglTipoIdentificador1, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, ESglPosicaoIdentificador1, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_identificador, ESglTipoIdentificador2, True));
    FArquivoEscrita.AdicionarColuna(SglToCod(tab_posicao_identificador, ESglPosicaoIdentificador2, True));
    FArquivoEscrita.AdicionarColuna(EDtaIdentificacaoSisbov);
    FArquivoEscrita.AdicionarColuna(ESglFazendaIdentificacao);
    FArquivoEscrita.AdicionarColuna(ENumCNPJCPFTecnico);
    FArquivoEscrita.AdicionarColuna(EIndEfetivar);
  except
    on E:ETabErro do
    begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E:Exception do
    begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then
  begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarAnimalNaoEspecificado(ECodAnimalSisbov);
end;

function TImportacao.InserirEventoAvaliacao(
  ECodIdentificadorEvento: String; EDtaInicio, EDtaFim: TDateTime;
  ECodTipoAvaliacao: String; ECodFazendaManejo, ECodAnimalManejo,
  ESglFazenda: String; ECodTipoCaracteristica: String;
  EValorAvaliacao: String; ETxtObservacao: String): Integer;
const
  DES_TIPO: String    = 'EVENTOS';
  SGL_EVENTO: String  = 'AC';
var
  TIPO_LINHA: Integer;
begin
  Result := 0;

  if not FInicializado then
  begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if FIndInventariosAnimais > 0 then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimoAnimal  := '';
  // Consiste a sequencia do evento a ser importado
  if FSeqEvento = 0 then
  begin
    FSeqEvento := 1;
  end
  else
  begin
    if (FUltimaData <> EDtaInicio) or (FUltimaAvaliacao <> ECodTipoAvaliacao) or
       (FUltimoEvento <> FSeqEvento) then
    begin
      FSeqEvento := FSeqEvento + 1;
    end;
  end;

  // Consistências
  if Trim(ECodIdentificadorEvento) = '' then
  begin
    Result := FIntErroImportacao.SetErro(49);
    Exit;
  end;

  if Trim(ESglFazenda) = '' then
  begin
    Result := FIntErroImportacao.SetErro(125);
    Exit;
  end;

  if Length(ESglFazenda) > 2 then
  begin
    Result := FIntErroImportacao.SetErro(87);
    Exit;
  end;

  if (ECodTipoAvaliacao = '') then
  begin
    Result := FIntErroImportacao.SetErro(217);
    Exit;
  end;

  if EDtaInicio = 0 then
  begin
    Result := FIntErroImportacao.SetErro(50);
    Exit;
  end;

  if EDtaFim > 0 then
  begin
    if EDtaFim < EDtaInicio then
    begin
      Result := FIntErroImportacao.SetErro(52);
      Exit;
    end;
  end;

  if (ECodTipoCaracteristica = '') then
  begin
    Result := FIntErroImportacao.SetErro(213);
    Exit;
  end;

  if (EValorAvaliacao = '') then
  begin
    Result := FIntErroImportacao.SetErro(218, [ECodTipoCaracteristica, ECodTipoAvaliacao]);
    Exit;
  end;

  // Adiciona colunas
  try
    if (FUltimaData <> EDtaInicio) or (FUltimaAvaliacao <> ECodTipoAvaliacao) or
       (FUltimoEvento <> FSeqEvento) then
    begin
      TIPO_LINHA := 5;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(SglToCod(tab_tipo_evento, SGL_EVENTO, True));
      FArquivoEscrita.AdicionarColuna(EDtaInicio);
      FArquivoEscrita.AdicionarColuna(EDtaFim);
      FArquivoEscrita.AdicionarColuna(ETxtObservacao);
      FArquivoEscrita.Adicionarcoluna(ESglFazenda);
      FArquivoEscrita.AdicionarColuna(ECodTipoAvaliacao);      
      // Grava Linha
      if FArquivoEscrita.AdicionarLinha < 0 then
      begin
        Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
        Exit;
      end;

      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario('ANIMAIS ASSOCIADOS A EVENTOS');
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(ECodFazendaManejo);
      FArquivoEscrita.Adicionarcoluna(ECodAnimalManejo);
      FArquivoEscrita.Adicionarcoluna(ECodTipoCaracteristica);
      FArquivoEscrita.Adicionarcoluna(EValorAvaliacao);

      FUltimaData      := EDtaInicio;
      FUltimaAvaliacao := ECodTipoAvaliacao;
      FUltimoEvento    := FSeqEvento;      
    end
    else
    begin
      TIPO_LINHA := 6;
      FArquivoEscrita.TipoLinha := TIPO_LINHA;
      FArquivoEscrita.AdicionarColuna(FSeqEvento);
      FArquivoEscrita.AdicionarColuna(ECodFazendaManejo);
      FArquivoEscrita.Adicionarcoluna(ECodAnimalManejo);
      FArquivoEscrita.Adicionarcoluna(ECodTipoCaracteristica);
      FArquivoEscrita.Adicionarcoluna(EValorAvaliacao);
    end;

    FArquivoEscrita.TipoLinha := TIPO_LINHA;
  except
    on E:ETabErro do
    begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E:Exception do
    begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then
  begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarEvento(ECodIdentificadorEvento, False, False, False, True);
end;

function TImportacao.RegistrarAnimalNaoEspecificado(CodAnimalSisbov: String): Integer;
begin
  Result := ExisteAnimalNaoEspecificado(CodAnimalSisbov);
  Case Result of
    // Animal ainda não registrado na tabela
    0 : begin
          if Length(FAnimais) <= FIndAnimais then begin
            SetLength(FAnimais, Length(FAnimais) + 10000);
          end;
          FAnimais[FIndAnimais].CodAnimalSisbov := Uppercase(CodAnimalSisbov);
          Inc(FIndAnimais);
        end;
    // Animal já existente com o mesmo código SISBOV
    3 : begin
          Result := FIntErroImportacao.SetErro(36, [CodAnimalSisbov, FNomArquivoEscrita]);
        end;
  end;

end;

function TImportacao.ExisteAnimalNaoEspecificado(CodAnimalSisbov: String): Integer;
var
  X : Integer;
begin
  Result := 0;
  if Length(FAnimais) > 0 then
  begin
    For X := Low(FAnimais) to FIndAnimais - 1 do
    begin
      if Trim(CodAnimalSisbov) <> '' then
      begin
        if FAnimais[X].CodAnimalSisbov = Uppercase(Trim(CodAnimalSisbov)) then
        begin
          Result := 3; // Existe animal com este código Sisbov
          Exit;
        end;
      end;
    end;
  end;
end;

function TImportacao.InserirInventarioAnimal(SglFazenda,
  CodAnimalSisbov: String): Integer;
const
  TIPO_LINHA: Integer = 9;
  DES_TIPO: String    = 'INVENTARIO DE ANIMAIS (INSERÇÃO)';
begin
  if not FInicializado then begin
    Result := FIntErroImportacao.SetErro(16);
    Exit;
  end;

  // Inventário de animais deve ser exclusivo no arquivo
  if ((FIndRMs > 0) or
      (FIndAnimais > 0) or
      (FIndTourosRM > 0) or
      (FIndEventos > 0) or
      (FIndAnimaisEvento > 0) or
      (FIndComposicoesRaciais > 0)) then begin
    Result := FIntErroImportacao.SetErro(221);
    Exit;
  end;

  FUltimaFazenda := '';

  // Trata os parametros da função
  SglFazenda := Trim(SglFazenda);
  CodAnimalSisbov := Trim(CodAnimalSisbov);

  // Consistências
  try
    // Fazenda
    if SglFazenda = '' then begin
      Result := FIntErroImportacao.SetErro(125);
      Exit;
    end;
    if Length(SglFazenda) > 2 then begin
      Result := FIntErroImportacao.SetErro(87);
      Exit;
    end;

    // Codigo SISBOV
    if CodAnimalSisbov = '' then begin
      Result := FIntErroImportacao.SetErro(114);
      Exit;
    end;
    Result := VerificarSisbov(CodAnimalSisbov);
    if Result < 0 then begin
      Exit;
    end;
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
  end;

  // Verifica se registro já não foi gravado no arquivo
  if ExisteInventarioAnimal(SglFazenda, CodAnimalSisbov) then begin
    Result := FIntErroImportacao.SetErro(220, [CodAnimalSisbov, SglFazenda]);
    Exit;
  end;

  // Verifica se é necessário gerar comentário
  if FIndGerarComentarios then begin
    if FUltimoTipoLinha <> TIPO_LINHA then begin
      FArquivoEscrita.AdicionarLinha;
      FArquivoEscrita.AdicionarComentario(DES_TIPO);
      FUltimoTipoLinha := TIPO_LINHA;
    end;
  end;
  FArquivoEscrita.TipoLinha := TIPO_LINHA;

  // Adiciona colunas
  try
    FArquivoEscrita.AdicionarColuna(SglFazenda);
    FArquivoEscrita.AdicionarColuna(CodAnimalSisbov);
  except
    on E: ETabErro do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(E);
      Exit;
    end;
    on E: exception do begin
      FArquivoEscrita.CancelarLinha;
      Result := FIntErroImportacao.SetErro(17, [DES_TIPO]);
      Exit;
    end;
  end;

  // Grava Linha
  if FArquivoEscrita.AdicionarLinha < 0 then begin
    Result := FIntErroImportacao.SetErro(18, [DES_TIPO]);
    Exit;
  end;

  RegistrarInventarioAnimal(SglFazenda, CodAnimalSisbov);
  FUltimaFazenda  := SglFazenda;
end;

function TImportacao.ExisteInventarioAnimal(SglFazenda,
  CodAnimalSisbov: String): Boolean;
var
  X : Integer;
begin
  Result := False;
  if Length(FInventariosAnimais) > 0 then begin
    For X := Low(FInventariosAnimais) to FIndInventariosAnimais - 1 do begin
      if (FInventariosAnimais[X].SglFazenda = Uppercase(SglFazenda)) and
         (FInventariosAnimais[X].CodAnimalSisbov = Uppercase(CodAnimalSisbov)) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TImportacao.RegistrarInventarioAnimal(SglFazenda,
  CodAnimalSisbov: String): Integer;
begin
  Result := 0;
  if ExisteInventarioAnimal(SglFazenda, CodAnimalSisbov) then begin
    Result := FIntErroImportacao.SetErro(220, [CodAnimalSisbov, SglFazenda]);
    Exit;
  end;
  if Length(FInventariosAnimais) <= FIndInventariosAnimais then begin
    SetLength(FInventariosAnimais, Length(FInventariosAnimais) + 100);
  end;
  FInventariosAnimais[FIndInventariosAnimais].SglFazenda := UpperCase(SglFazenda);
  FInventariosAnimais[FIndInventariosAnimais].CodAnimalSisbov  := UpperCase(CodAnimalSisbov);
  Inc(FIndInventariosAnimais);
end;

end.
