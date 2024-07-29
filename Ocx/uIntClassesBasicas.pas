unit uIntClassesBasicas;

{$DEFINE MSSQL}

interface

uses WinProcs, SysUtils, Classes, Graphics, DB, SqlExpr, Controls, FileCtrl,
     uConexao, uIntMensagens, uColecoes, uPrintPDF, Variants,
     Provider, DBClient, WsSISBOV1,StrUtils;

type
  TAlinhamento = (taEsquerda, taCentro, taDireita);

  {THerdomQuery}
  THerdomQuery = class(TSQLQuery)
  public
    constructor Create(Conexao: TConexao; AOwner: TComponent); reintroduce; overload;
  end;

  {THerdomQueryNavegacao}
  THerdomQueryNavegacao = class(THerdomQuery)
  private
    FDataSetProvider: TDataSetProvider;
    FClientDataSet: TClientDataSet;
    function GetClientDataSetRecordCount: Integer;
    function GetClientDataSetBof: Boolean;
    function GetClientDataSetEof: Boolean;
    function GetClientDataSetActive: Boolean;
    procedure SetClientDataSetActive(const Value: Boolean);
    procedure SetClientDataSetAfterClose(const Value: TDataSetNotifyEvent);
    procedure SetClientDataSetAfterOpen(const Value: TDataSetNotifyEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure First;
    procedure Next;
    procedure Prior;
    procedure Last;

    function IsEmpty: Boolean;
    function FieldByName(const FieldName: string): TField;
    function MoveBy(Distance: Integer): Integer;
    function Locate(const KeyFields: string; const KeyValues: Variant;
                    Options: TLocateOptions): Boolean; override;
    property ClientDataSet: TClientDataSet read FClientDataSet write FClientDataSet;
    property RecordCount: Integer read GetClientDataSetRecordCount;
    property Eof: Boolean read GetClientDataSetEof;
    property Bof: Boolean read GetClientDataSetBof;
    property Active: Boolean read GetClientDataSetActive write SetClientDataSetActive default False;
    property AfterOpen: TDataSetNotifyEvent write SetClientDataSetAfterOpen;
    property AfterClose: TDataSetNotifyEvent write SetClientDataSetAfterClose;
  end;

  {TIntClasseBDBasica}
  TIntClasseBDBasica = class(TObject)
  private
    FConexao : TConexao;
    FMensagens : TIntMensagens;
    FInicializado : Boolean;
  protected
    procedure RaiseNaoInicializado(Metodo: String);
  public
    constructor Create; virtual;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; overload; virtual;
    function EmTransacao: Boolean;
    procedure Begintran;
    procedure Commit;
    procedure Rollback;
    function ValorParametro(CodParametro: Integer) : String;
    function DtaSistema: TDateTime;
    function TrataString(var Str: String; Tam: Integer; NomParametro: String) : Integer;
    function VerificaString(Str, NomParametro: String): Integer;
    function VerificaParametroMultiValor(TxtParametro: String; var Parametros: TValoresParametro): Integer;
    function VerificaParametroMultiValorString(var TxtParametro: String;
      var Parametros: TValoresParametro): Integer;
    function TrataMensagemErroSISBOV(RetornoSISBOV: RetornoWsSISBOV): String;
    procedure AddSQL(EQuery: THerdomQuery; ESQL: String); overload;
    procedure AddSQL(EQuery: THerdomQuery; ESQL: String; ECondicao: Boolean); overload;

    property Conexao:      TConexao      read FConexao;
    property Inicializado: Boolean       read FInicializado;
    property Mensagens:    TIntMensagens read FMensagens;
  end;

  {TIntClasseBDLeituraBasica}
  TIntClasseBDLeituraBasica = class(TIntClasseBDBasica)
  private
    FQuery : THerdomQueryNavegacao;
    FPosicao : Integer;
    procedure AfterOpen(DataSet: TDataSet);
    procedure AfterClose(DataSet: TDataSet);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;

    function EOF: Boolean;
    procedure IrAoPrimeiro;
    procedure IrAoProximo;
    function ValorCampo(NomeColuna: String): Variant;
    procedure FecharPesquisa;

    property Query : THerdomQueryNavegacao read FQuery write FQuery;
  end;

  {TIntClasseBDNavegacaoBasica}
  TIntClasseBDNavegacaoBasica = class(TIntClasseBDBasica)
  private
    FQuery : THerdomQueryNavegacao;
    FPosicao : Integer;
    procedure AfterOpen(DataSet: TDataSet);
    procedure AfterClose(DataSet: TDataSet);

  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
      override;
    procedure BeginTran(NomTransacao: String); reintroduce; overload;
    procedure Commit(NomTransacao: String); reintroduce; overload;
    procedure Rollback(NomTransacao: String); reintroduce; overload;

    procedure AoRetornarDados;virtual;abstract;
    procedure AoFecharDataset;virtual;abstract;
    //druzo 30/07/2009
    function SplitString(Valor: String; caractere: char): TStringList;

    function BOF: Boolean;
    function EOF: Boolean;
    procedure IrAoPrimeiro;
    procedure IrAoProximo;
    procedure IrAoAnterior;
    procedure IrAoUltimo;
    procedure Posicionar(NumRegistro: Integer);
    function Deslocar(QtdRegistros: Integer): Integer;
    function NumeroRegistros: Integer;
    function ValorCampo(NomeColuna: String): Variant;
    procedure FecharPesquisa;
    function GravarLogOperacao(NomeTabela: String; CodRegistroLog,
      CodOperacao, CodMetodo: Integer) : Integer; overload;
    class function GravarLogOperacao(EConexao: TConexao;
      EMensagens: TIntMensagens; NomeTabela: String; CodRegistroLog, CodOperacao,
      CodMetodo: Integer): Integer; overload;
      
    function ProximoCodRegistroLog: Integer; overload;
    class function ProximoCodRegistroLog(EConexao: TConexao; EMensagens: TIntMensagens): Integer; overload;

    function CadastroEfetivado(NomeTabela, NomeColuna: String;
      CodPessoaProdutor, CodRegistro: Integer; PossuiFimValidade: Boolean): Integer;
    function ExportadoSisbov(NomeTabela, NomeColuna: String;
      CodPessoaProdutor, CodRegistro: Integer; PossuiFimValidade: Boolean): Integer;
(*
    A partir de 19/10/2004 o procedimento de atualização de grandezas será
    realizado a partir da execução de processo batch por intervalos configuráveis
    e não mais a partir da execução de cada operação como anteriormente.
    function AtualizaGrandeza(CodGrandezaResumo, CodPessoaProdutor,
      VlrGrandezaResumo: Integer): Integer;
*)
    function VerificarAgendamentoTarefa(CodTipoTarefa: Integer;
      Parametros: Array of Variant): Integer;
    function SolicitarAgendamentoTarefa(CodTipoTarefa: Integer;
      Parametros: Array of Variant; DtaInicioPrevisto: TDateTime): Integer;

    property Query : THerdomQueryNavegacao read FQuery write FQuery;
  end;
  {TCampo}
  TCampo = record
    TxtTitulo: String;
    NomField: String;
    DataType: TFieldType;
    QtdLargura: Integer;
    QtdTamanho: Integer;
    QtdDecimais: Integer;
    CodFormato: Integer;
    CodAlinhamento: Integer;
    Valor: Variant;
    ValorSalvo: Variant;
    ValorAnterior: Variant;
    OcultarValorRepetido: Boolean;
    Desabilitado: Boolean;
  end;

  {TCampos}
  TCampos = class
  private
    FTipo: Integer;
    FListaCampos: Array of TCampo;
    FPosicao: Integer;
    FSPosicao: Integer;
    FEOF: Boolean;
    FSEOF: Boolean;
    function GetEOF: Boolean;
    function GetNumCampos: Integer;
    function GetCampo: TCampo;
    procedure SalvarPosicao;
    procedure RecuperarPosicao;
    procedure SetValorCampo(NomField: String; const Value: Variant);
    function GetBOF: Boolean;
    function GetLarguraLinha: Integer;
    procedure SetTextoTitulo(NomField: String; const Value: String);
    function GetTextoTitulo(NomField: String): String;
    function GetValorCampo(NomField: String): Variant;
    function GetValorCampoIdx(Idx: Integer): Variant;
    procedure SetValorCampoIdx(Idx: Integer; const Value: Variant);
    function GetTextoTituloIdx(Idx: Integer): String;
    procedure SetTextTituloIdx(Idx: Integer; const Value: String);
  public
    constructor Create;
    procedure IrAoPrimeiro;
    procedure IrAoProximo;
    procedure LimparValores;
    procedure CarregarValores(SourceDataSet: THerdomQuery);
    procedure Adicionar(aTxtTitulo, aNomField: String; aQtdLargura, aQtdTamanho,
      aQtdDecimais, aCodFormato, aCodAlinhamento: Integer);
    procedure DesabilitarCampo(NomField: String);
    procedure OcultarValoresRepetidos(NomField: String);
    procedure MostrarValoresOcultos;
    procedure SalvarValores;
    procedure RecuperarValores;

    property Tipo: Integer read FTipo write FTipo;
    property LarguraLinha: Integer read GetLarguraLinha;
    property NumCampos: Integer read GetNumCampos;
    property BOF: Boolean read GetBOF;
    property EOF: Boolean read GetEOF;
    property Campo: TCampo read GetCampo;
    property ValorCampo[NomField: String]: Variant read GetValorCampo write SetValorCampo;
    property ValorCampoIdx[Idx: Integer]: Variant read GetValorCampoIdx write SetValorCampoIdx;
    property TextoTitulo[NomField: String]: String read GetTextoTitulo write SetTextoTitulo;
    property TextoTituloIdx[Idx: Integer]: String read GetTextoTituloIdx write SetTextTituloIdx;
  end;

  {TLocalizacaoSISBOV}
  TLocalizacaoSISBOV = class(TIntClasseBDBasica)
  public
    function RelacionaProdutorPropriedade(CodPessoaProdutor, CodPropriedade: Integer):Integer;
  end;

  {TRelatorioPadrao}
  TRelatorioPadrao = class(TPrintPDF)
  private
    { Private declarations }
    FArquivoCSV: TextFile;
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FInicializado: Boolean;
    FCampos: TCampos;

    FCodRelatorio: Integer;
    FCodOrientacao: Integer;
    FCodTamanhoFonte: Integer;
    FQtdColunas: Integer;
    FLarguraLinha: Integer;
    FMargem: Integer;
    FAuxiliarLinha: Integer;

    FTxtTitulo: String;
    FTxtSubTitulo: String;
    FTxtDados: String;
    FTxtCabecalho: String;
    FTxtCabecalhoX: Integer;

    FNomeArquivo: String;
    FTipoDoArquivo: Integer;
    FFormatarTxtDados: Boolean;
    FCodTamanhoFonteTxtDados: Integer;
    FPrimeiraLinhaNegritoTxtDados: Boolean;

    FLogoCertificadora: String;
    FNumBitmapCertificadora: Integer;
    FLogoTQI: String;
    FNumBitmapTQI: Integer;

    FAlturaCabecalho: Integer;
    FAlturaRodape: Integer;
    FLinhasPorPagina: Integer;
    FLinhaCorrente: Integer;
    FColunaAtual: Integer;
    FMargemEsquerda: Integer;
    FSFont: TPDFFont;

    FYQuadroInicial: Integer;
    FUsaCabecalhoColunas: Boolean;

    FCodTarefa: Integer;

    procedure Cabecalho; OverLoad;
    procedure Cabecalho(sSubTitulo: String); OverLoad;
    procedure CabecalhoColunas;
    procedure Rodape;

    function Colunas(ResultSet: THerdomQuery; TextoPrePos: String): Integer;
    function GetLinhasRestantes: Integer;
    function GetYDados: Integer;
    function BuscarSPID: Integer;
    function BuscarValorParametroSistema(Parametro: Integer;
                                         var Valor: String): Integer;
    function ConsistirLarguraLinha: Integer;

    procedure SetAlturaCabecalho(const Value: Integer);
    procedure SetAlturaRodape(const Value: Integer);
    procedure AtualizaLinhasPorPagina;

    property YDados: Integer read GetYDados;
    procedure SetTipoDoArquivo(const Value: Integer);
    function CarregarRelatorio: Integer; overload;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ConexaoBD: TConexao; Mensagens: TIntMensagens); reintroduce; overload;
    constructor Create(ConexaoBD: TConexao; Mensagens: TIntMensagens); reintroduce; overload;
    destructor Destroy; override;

    function CarregarRelatorio(CodRelatorio: Integer): Integer; overload;
    function ImprimirColunas: Integer;
    function ImprimirColunasResultSet(ResultSet: THerdomQuery): Integer;
    function ImprimirTexto(Posicao: Integer; Texto: String): Integer;
    function ImprimirTextoTotalizador(Texto: String): Integer;
    function BuscarNomeArquivo: Integer;
    function AlturaLinha(): Integer;
    procedure ImprimirTextoAposCabecalho(Posicao: Integer; Texto: String);
    procedure AjustarFonte(Name: TPDFFontName; Size: Integer);
    Procedure TextOut(X, Y: Integer; Text: String); override;
    procedure SalvarFonte;
    procedure RecuperarFonte;
    procedure FonteNegrito;
    procedure FonteNormal;

    function InicializarRelatorio: Integer; overload;
    function InicializarRelatorio(CodRelatorio: Integer): Integer; overload;
    function InicializarRelatorio(sSubTitulo: String; DataUltAlteracao: TDate;
                                  HoraUltAlteracao: TTime; NomUsuarioUltAlteracao: String): Integer; overload;
    function FinalizarRelatorio: Integer;
    procedure NovaLinha;
    procedure NovaPagina; OverLoad;
    procedure NovaPagina(sSubTitulo: String); OverLoad;

    function InicializarQuadro(IndImprimeLinhaHorizontalInicial: Char): Integer;
    function ImprimirLinhaQuadro(): Integer;
    function FinalizarQuadro(): Integer;
    function DividirQuadroAoMeio(): Integer;

    property CodTamanhoFonte: Integer read FCodTamanhoFonte write FCodTamanhoFonte;
    property CodOrientacao: Integer read FCodOrientacao write FCodOrientacao;

    property TxtDados: String read FTxtDados write FTxtDados;
    property TxtSubTitulo: String read FTxtSubTitulo write FTxtSubTitulo;
    property TxtTitulo: String read FTxtTitulo write FTxtTitulo;
    property FormatarTxtDados: Boolean read FFormatarTxtDados write FFormatarTxtDados;
    property CodTamanhoFonteTxtDados: Integer read FCodTamanhoFonteTxtDados write FCodTamanhoFonteTxtDados;
    property PrimeiraLinhaNegritoTxtDados: Boolean read FPrimeiraLinhaNegritoTxtDados write FPrimeiraLinhaNegritoTxtDados;

    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property TipoDoArquvio: Integer read FTipoDoArquivo write SetTipoDoArquivo;
    property LogoCertificadora: String read FLogoCertificadora write FLogoCertificadora;
    property LogoTQI: String read FLogoTQI write FLogoTQI;

    property AlturaCabecalho: Integer read FAlturaCabecalho write SetAlturaCabecalho;
    property AlturaRodape: Integer read FAlturaRodape write SetAlturaRodape;
    property LinhasPorPagina: Integer read FLinhasPorPagina write FLinhasPorPagina;
    property LinhasRestantes: Integer read GetLinhasRestantes;
    property QtdColunas: Integer read FQtdColunas write FQtdColunas;
    property Margem: Integer read FMargem;
    property LinhaCorrente: Integer read FLinhaCorrente;

    property Campos: TCampos read FCampos;
    property Conexao: TConexao read FConexao;
    property Mensagens: TIntMensagens read FMensagens;
    property CodTarefa: Integer read FCodTarefa write FCodTarefa;
    property UsaCabecalhoColunas: Boolean read FUsaCabecalhoColunas write FUsaCabecalhoColunas;
  end;

  { TRegistroLinha }
  TRegistroLinha = record
    Posicao: Integer;
    Tamanho: Integer;
  end;

  { TTipoLinhaArquivo }
  TTipoLinhaArquivo = record
    CodTipoLinha: Integer;
    Atributos: array of TRegistroLinha;
  end;

  { Classe básica para a leitura de arquivo SISBOV. }
  TIntArquivoSISBOV = class
  private
    FArquivo: TextFile;
    FTipos: Array of TTipoLinhaArquivo;
    FLinha: String;
    FIndiceTipoLinhaAtual: Integer;

    procedure ObtemIndiceTipoLinhaAtual;
  public
    constructor Create; Virtual;
    destructor Free; Virtual;

    procedure Abrir(NomeArquivo: String);
    procedure Fechar;
    procedure LerLinha;
    procedure AddTipoLinha(TipoLinha: TTipoLinhaArquivo);
    procedure LimparTiposLinhas;
    function  ValorAtributo(NumAtributo: Integer): String;
    function  Eof: Boolean;
    function  TipoLiha: Integer;

    property Linha: String read FLinha;
  end;

  function SE(Condicao: Boolean; Verdadeiro: Variant; Falso: Variant): Variant;
  function TrataAspas(Texto: String): String;
  function TrataParentesesPDF(Texto: String): String;
  function AlinharTexto(Texto, Caracter: String; Tamanho: Integer;
    Alinhamento: TAlinhamento): String;
  function TrataQuebra(Texto: String): String;
  function RemoveDelimitadores(Texto: String): String;
  procedure VarToParamStr(ValVariant: Variant; var Tipo, ValString: String);
  procedure ParamStrToVar(ValString: String; Tipo: String; var ValVariant: Variant);

const
  coRetrato: Integer = 1;
  coPaisagem: Integer = 2;
  ctaPDF: Integer = 1;
  ctaCSV: Integer = 2;
  ctfReduzido: Integer = 1;
  ctfNormal: Integer = 2;
  ctfExpandido: Integer = 3;
  ctFonte: Array [1..3] of Integer = (8, 10, 12);
  idExceedsTheConfiguredThreshold: Integer = -2;
  strExceedsTheConfiguredThreshold: String =
    'The query has been canceled because the estimated cost of this query';
  cLCIDdBrasil:integer = 1046;

var
  AjustesdeFormato:TFormatSettings;
  //Constantes de Erros Comuns
  EFaltaAcesso    : integer = 188;
implementation


uses uIntRelatorios, uFerramentas;

{Funções genéricas}

{* Se o parametro Condicao for True então retorna o valor do parmetro
  Verdadeiro senão retornar o valor do parametro Falso.

  @param Condicao Indicador de qual valor deve ser retornado
  @param Verdadeiro Valor a ser retornado se Condiscao for True
  @param Falso Valor a ser retornado se Condicao for False

  @return Se Condicao for True retorna Verdadeiro senão retorna Falso}
function SE(Condicao: Boolean; Verdadeiro: Variant; Falso: Variant): Variant;
begin
  if Condicao then
  begin
    Result := Verdadeiro
  end
  else
  begin
    Result := Falso;
  end;
end;

{* Converte uma aspa simples em duas aspas simples. Se a string "Teste '123"
  for passada como argumento a função retorna "Teste ''123".

  @param Texto Texto onde as aspas devem ser tratadas

  @return Parametro Texto com as aspas simples convertidas em duas aspas simples}
function TrataAspas(Texto: String): String;
var
  iAux: Integer;
begin
  if Pos(#34, Texto) > 0 then
  begin
    Result := '';
    for iAux := 1 to Length(Texto) do
    begin
      if Texto[iAux] = #34 then
      begin
        Result := Result + #34;
      end;
      Result := Result + Texto[iAux];
    end;
  end
  else
  begin
    Result := Texto;
  end;
end;

{* Percorre a string em busca de parenteses ajustando-os de acordo com o
  formato PDF.

  @param Texto String a ser percorrida

  @return Texto no formado PDF}
function TrataParentesesPDF(Texto: String): String;
var
  iAux: Integer;
  sAux: String;
begin
  sAux := '';
  {Percorre a string em busca de parenteses ajustando-os de acordo com o
   formato PDF}
  for iAux := 1 to Length(Texto) do begin
    if (Texto[iAux] = #40) or (Texto[iAux] = #41) then begin
      sAux := sAux + #92;
    end;
    sAux := sAux + Texto[iAux];
  end;
  Result := sAux;
end;

{* Alinha o texto de acordo com os parametros.

  @param Texto Texto a ser alinhado
  @param Caracter Caracter de preenchimento do campo
  @param Tamanho Tamanho do campo que o texto deve ser alinhado
  @param Alinhamento Indica se o texto deve ser alinha á esquerda,
         direita ou no centro

  @return Texto alinhado}
function AlinharTexto(Texto, Caracter: String; Tamanho: Integer;
  Alinhamento: TAlinhamento): String;
var
  i: Integer;
begin
  Result := Trim(Texto);
  if (Alinhamento = taEsquerda) and (Length(Caracter)>0) then
  begin
    for i := 1 to Tamanho-Length(Result) do
    begin
      Result := Result + Caracter[1];
    end;
  end
  else
  if (Alinhamento = taCentro) and (Length(Caracter)>0) then
  begin
    for i := 1 to ((Tamanho-Length(Result)) div 2) do
    begin
      Result := Caracter[1] + Result;
    end;
    for i := 1 to Tamanho - Length(Result) do
    begin
      Result := Result + Caracter[1];
    end;
  end
  else
  if (Alinhamento = taDireita) and (Length(Caracter)>0) then
  begin
    for i := 1 to Tamanho-Length(Result) do
    begin
      Result := Caracter[1] + Result;
    end;
  end;
end;

{* Trata a quebra de linha.

  @param Texto Texto a ser tratado

  @return Texto com a quebra de linha tratada}
function TrataQuebra(Texto: String): String;
var
  iAux: Integer;
  sAux: String;
begin
  if Pos(#13, Texto) > 0 then
  begin
    iAux := 1;
    sAux := '';
    while iAux <= Length(Texto) do
    begin
      if not(Texto[iAux] in [#13, #10]) then
      begin
        if not((Texto[iAux] = '-') and (iAux < Length(Texto))
          and (Texto[iAux+1] = #13)) then
        begin
          sAux := sAux + Texto[iAux];
        end;
      end
      else
      if (iAux > 2) and (Texto[iAux] = #10) and (Texto[iAux-1] = #13)
        and (Texto[iAux-2] <> #45) then
      begin
        sAux := sAux + #32;
      end;
      Inc(iAux);
    end;
    Result := sAux;
  end
  else
  begin
    Result := Texto;
  end;
end;

{* Conta a quantidade de quebras de linha do texto.

  @param Texto Texto a ser verificado

  @return Quantidade de quebras de linha do texto}
function ContarQuebras(Texto: String): Integer;
var
  iAux: Integer;
begin
  Result := 1;
  iAux := Pos(#13#10, Texto);
  while iAux <> 0 do
  begin
    Texto := Copy(Texto, iAux+2, Length(Texto)-(iAux+2));
    iAux := Pos(#13#10, Texto);
    Inc(Result);
  end;
end;

{* Obtem uma determinada linha do texto. A quantidade de linhas do texto
  é determinada pela quantidade de quebras de linha.

  @param Texto Texto que a linha deve ser extraida
  @param Linha Número da linha a ser extraída

  @return Linha do texto solicitada. Se a linha não exisitir retorna vazio.}
function ObterLinhaTexto(Texto: String; Linha: Integer): String;
var
  iAux, iLinha: Integer;
  sAux: String;
begin
  Result := '';
  iAux := Pos(#13#10, Texto);
  if (iAux = 0) and (Linha = 1) then
  begin
    Result := Texto;
  end
  else
  begin
    if Linha = 1 then
    begin
      Result := Copy(Texto, 1, iAux-1);
    end
    else
    if iAux <> 0 then
    begin
      iLinha := 1;
      sAux := Texto;
      while (iLinha < Linha) and (iAux <> 0) do
      begin
        sAux := Copy(sAux, iAux+2, Length(sAux)-(iAux+1));
        iAux := Pos(#13#10, sAux);
        Inc(iLinha);
      end;
      if (iLinha = Linha) then
      begin
        if (iAux <> 0) then
        begin
          Result := Copy(sAux, 1, iAux-1);
        end
        else
        begin
          Result := sAux;
        end;
      end
      else
      begin
        Result := '';
      end;
    end;
  end;
end;

{* Remove os delimitadores do texto. Texto sem o primeiro e os último caracter.

  @param Texto Texto onde os delimitadores devem ser removidos.

  @return Texto com os relimitadores removidos.}
function RemoveDelimitadores(Texto: String): String;
begin
  if Texto <> '' then
  begin
    Result := Copy(Texto, 2, Length(Texto)-2);
  end
  else
  begin
    Result := Texto;
  end;
end;

{ Retorna o tipo e o valor string do parametro ValVariant.

  @param ValVariant Valor a ser avaliado
  @param Tipo Tipo do parametro informado
  @param ValString Valor convertido em string do parametor ValVariant}
procedure VarToParamStr(ValVariant: Variant; var Tipo, ValString: String);
var
  fAux: Extended;
  sDecimalSeparator: Char;
  sThousandSeparator: Char;
  function TrataString(Texto: String): String;
  var
    iAux: Integer;
  begin
    Result := '';
    for iAux := 1 to Length(Texto) do
    begin
      if Texto[iAux] = #34 then
      begin
        Result := Result + #34;
      end;
      Result := Result + Texto[iAux];
    end;
  end;
begin
  sDecimalSeparator := DecimalSeparator;
  sThousandSeparator := ThousandSeparator;
  DecimalSeparator := #46;
  ThousandSeparator := #0;
  try
    case (VarType(ValVariant)) of
      varBoolean:
        begin
          Tipo := 'B'; // Booleano
          if ValVariant then begin
            ValString := '#TRUE#';
          end else begin
            ValString := '#FALSE#';
          end;
        end;
      varDate:
        begin
          Tipo := 'D'; // Data / Hora
          if ValVariant = 0 then begin
            ValString := '0';
          end else begin
            fAux := ValVariant;
            fAux := Trunc(fAux);
            if ValVariant = fAux  then begin
              ValString := #35+FormatDateTime('yyyy-mm-dd', ValVariant)+#35;
            end else begin
              ValString := #35+FormatDateTime('yyyy-mm-dd hh:nn:ss', ValVariant)+#35;
            end;
          end;
        end;
      varByte:
        begin
          Tipo := 'G'; // Gráfico (Binário)
        end;
      varShortInt:
        begin
          Tipo := 'I'; // Numérico Inteiro
          ValString := IntToStr(ValVariant);
        end;
      varSmallint, varInteger:
        begin
          Tipo := 'I'; // Numérico Inteiro
          ValString := IntToStr(ValVariant);
        end;
      varSingle, varDouble:
        begin
          Tipo := 'N'; // Númerico Decimal
          ValString := FloatToStr(ValVariant);
        end;
      varCurrency:
        begin
          Tipo := 'N'; // Númerico Decimal
          ValString := CurrToStr(ValVariant)
        end;
      varOleStr, varStrArg, varString:
        begin
          Tipo := 'S'; // String
          ValString := #34+TrataString(ValVariant)+#34;
        end;
    else
      ValString := '';
    end;
  finally
    DecimalSeparator := sDecimalSeparator;
    ThousandSeparator := sThousandSeparator;
  end;
end;

procedure ParamStrToVar(ValString: String; Tipo: String; var ValVariant: Variant);
begin

end;

{TLocalizacaoSISBOV}


function TLocalizacaoSISBOV.RelacionaProdutorPropriedade(CodPessoaProdutor, CodPropriedade: Integer):Integer;
const
  NomMetodo = 'RelacionaProdutorPropriedade';
var
  Q : THerdomQuery;
  CodLocalizacaoSisbov:Integer;
begin
  Result := 0;
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
     // Verifica se o produtor é válido
     Q.Close;
     Q.SQL.Text :=
       'select '+
       '  1 '+
       'from '+
       '  tab_produtor '+
       'where '+
       '  cod_pessoa_produtor = :cod_pessoa_produtor ';
     Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
     Q.Open;
     if Q.IsEmpty then begin
        Mensagens.Adicionar(170, Self.ClassName, NomMetodo, []);
        Result := -170;
        Exit;
     end;
     // Verifica se a propriedade é válida
     Q.Close;
     Q.SQL.Text :=
       'select '+
       '  1 '+
       'from '+
       '  tab_propriedade_rural '+
       'where '+
       '  cod_propriedade_rural = :cod_propriedade_rural ' +
       '  and dta_fim_validade is null ';
     Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;
     Q.Open;
     if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, NomMetodo, []);
        Result := -327;
        Exit;
     end;
     // Verifica a existência do relacionamento entre o produtor da fazenda e a propriedade associada
     Q.Close;
     Q.SQL.Text :=
       'select '+
       '  cod_localizacao_sisbov '+
       'from '+
       '  tab_localizacao_sisbov '+
       'where '+
       '  cod_pessoa_produtor = :cod_pessoa_produtor '+
       '  and cod_propriedade_rural = :cod_propriedade_rural ';
     Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
     Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;
     Q.Open;
     if Q.IsEmpty then begin
     // Obtem um novo código de localização sisbov
        Q.Close;
        Q.SQL.Text :=
          'update tab_sequencia_codigo '+
          'set '+
          '  cod_localizacao_sisbov = cod_localizacao_sisbov + 1 ';
        Q.ExecSQL;
        // Recupera o código de localização sisbov obtido
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  cod_localizacao_sisbov '+
          ' from '+
          '  tab_sequencia_codigo ';
        Q.Open;
        CodLocalizacaoSisbov := Q.FieldByName('cod_localizacao_sisbov').AsInteger;
        // Estabelece um novo relacionamento entre o produtor da fazenda e propriedade associada
        Q.Close;
        Q.SQL.Text :=
          'insert into tab_localizacao_sisbov '+
          ' (cod_propriedade_rural '+
          '  , cod_pessoa_produtor '+
          '  , cod_localizacao_sisbov '+
          '  , cod_arquivo_sisbov) '+
          'values '+
          ' (:cod_propriedade_rural '+
          '  , :cod_pessoa_produtor '+
          '  , :cod_localizacao_sisbov '+
          '  , null) ';
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
        Q.ExecSQL;
        result := CodLocalizacaoSisbov;
    end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1385, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1385;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


{THerdomQuery}
constructor THerdomQuery.Create(Conexao: TConexao; AOwner: TComponent);
begin
  Create(AOwner);
  If Conexao = nil Then Begin
    Raise Exception.CreateResFmt(3, [Self.ClassName + '.Create']);
    Exit;
  End;
  Self.SQLConnection := Conexao.SQLConnection;
end;

{ THerdomQueryNavegacao }

procedure THerdomQueryNavegacao.Close;
begin
  if FClientDataSet.Active then begin
    FClientDataSet.Close;
  end;
  if TSQLQuery(Self).Active then begin
    TSQLQuery(Self).Close;
  end;
end;

constructor THerdomQueryNavegacao.Create(AOwner: TComponent);
var
  R: Integer;
  N: String;
begin
  inherited Create(AOwner);
  FDataSetProvider := TDataSetProvider.Create(Self);
  FClientDataSet := TClientDataSet.Create(Self);
  FDataSetProvider.DataSet := Self;
  R := Random(9);
  N := 'DSP_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '_' + IntToStr(R);
  FDataSetProvider.Name := N;
  FClientDataSet.ProviderName := N;
end;

destructor THerdomQueryNavegacao.Destroy;
begin
  FClientDataSet.Free;
  FDataSetProvider.Free;
  inherited Destroy;
end;

function THerdomQueryNavegacao.FieldByName(
  const FieldName: string): TField;
begin
  Result := FClientDataSet.FieldByName(FieldName);
end;

procedure THerdomQueryNavegacao.First;
begin
  FClientDataSet.First;
end;

function THerdomQueryNavegacao.GetClientDataSetActive: Boolean;
begin
  Result := FClientDataSet.Active;
end;

function THerdomQueryNavegacao.GetClientDataSetBof: Boolean;
begin
  Result := FClientDataSet.Bof;
end;

function THerdomQueryNavegacao.GetClientDataSetEof: Boolean;
begin
  Result := FClientDataSet.Eof;
end;

function THerdomQueryNavegacao.GetClientDataSetRecordCount: Integer;
begin
  Result := FClientDataSet.RecordCount;
end;

function THerdomQueryNavegacao.IsEmpty: Boolean;
begin
  Result := FClientDataSet.IsEmpty;
end;

procedure THerdomQueryNavegacao.Last;
begin
  FClientDataSet.Last;
end;

function THerdomQueryNavegacao.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  Result := FClientDataSet.Locate(KeyFields, KeyValues, Options);
end;

function THerdomQueryNavegacao.MoveBy(Distance: Integer): Integer;
begin
  Result := FClientDataSet.MoveBy(Distance);
end;

procedure THerdomQueryNavegacao.Next;
begin
  FClientDataSet.Next;
end;

procedure THerdomQueryNavegacao.Open;
begin
  if FClientDataSet.Active then begin
    FClientDataSet.Close;
  end;
  FClientDataSet.Open;
end;

procedure THerdomQueryNavegacao.Prior;
begin
  FClientDataSet.Prior;
end;

procedure THerdomQueryNavegacao.SetClientDataSetActive(const Value: Boolean);
begin
  FClientDataSet.Active := Value;
end;

procedure THerdomQueryNavegacao.SetClientDataSetAfterClose(
  const Value: TDataSetNotifyEvent);
begin
  FClientDataSet.AfterClose := Value;
end;

procedure THerdomQueryNavegacao.SetClientDataSetAfterOpen(
  const Value: TDataSetNotifyEvent);
begin
  FClientDataSet.AfterOpen := Value;
end;

{TIntClasseBDBasica}
constructor TIntClasseBDBasica.Create;
begin
  FInicializado := False;
end;

function TIntClasseBDBasica.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  // Consiste parâmetros do método inicializar
  If Mensagens = nil Then Begin
    Raise Exception.CreateResFmt(15, [Self.ClassName + '.Inicializar']);
    Result := -1;
    Exit;
  end;

  If ConexaoBD = nil Then Begin
    Mensagens.Adicionar(2, Self.ClassName, 'Inicializar', [Self.ClassName + '.Inicializar']);
    Result := -1;
    Exit;
  End;

  If Not ConexaoBD.Ativa Then Begin
    Mensagens.Adicionar(3, Self.ClassName, 'Inicializar', [Self.ClassName + '.Inicializar']);
    Result := -1;
    Exit;
  End;

  FConexao      := ConexaoBD;
  FMensagens    := Mensagens;
  FInicializado := True;

  Result := 0;
end;

function TIntClasseBDBasica.EmTransacao: Boolean;
begin
  Result := False;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EmTransacao');
    Exit;
  End;
  Result := Conexao.EmTransacao;
end;

procedure TIntClasseBDBasica.Begintran;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BeginTran');
    Exit;
  End;
  Conexao.BeginTran;
end;

procedure TIntClasseBDBasica.Commit;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Commit');
    Exit;
  End;
  Conexao.Commit;
end;

procedure TIntClasseBDBasica.Rollback;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Rollback');
    Exit;
  End;
  Conexao.Rollback;
end;

function TIntClasseBDBasica.ValorParametro(CodParametro: Integer) : String;
begin
  Result := '';
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ValorParametro');
    Exit;
  End;
  Result := Conexao.ValorParametro(CodParametro, Mensagens);
end;

procedure TIntClasseBDBasica.RaiseNaoInicializado(Metodo: String);
begin
  Raise Exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + Metodo]);
end;

function TIntClasseBDBasica.TrataString(var Str: String; Tam: Integer;
  NomParametro: String): Integer;
var
  WStr, Ult : String;
  X : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('TrataString');
    Exit;
  End;

  Str := Trim(Str);
  WStr := '';
  Ult := '';
  For X := 1 to Length(Str) do Begin
    If Str[X] = ' ' Then Begin
      If Ult <> ' ' Then Begin
        WStr := WStr + Str[X];
      End;
    End Else Begin
      WStr := WStr + Str[X];
    End;
    Ult := Str[X];
  End;

  Str := WStr;

  If Length(Str) > Tam Then Begin
    Mensagens.Adicionar(291, Self.ClassName, 'TrataString', [NomParametro, IntToStr(Tam)]);
    Result := -291;
    Exit;
  End;
  Result := 0;
end;

function TIntClasseBDBasica.VerificaString(Str, NomParametro: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('VerificaString');
    Exit;
  End;

  Str := Trim(Str);
  If Str = '' Then Begin
    Mensagens.Adicionar(309, Self.ClassName, 'VerificaString', [NomParametro]);
    Result := -309;
    Exit;
  End;
  Result := 0;
end;

function TIntClasseBDBasica.VerificaParametroMultiValor(TxtParametro: String;
  var Parametros: TValoresParametro): Integer;
var
  X, Qtd : Integer;
  Num : String;

  function AdicionaNumero(Valor: String): Integer;
  var
    Par : Integer;
  begin
    Result := 0;
    Try
      Par := StrToInt(Valor);
      Parametros.Add(Par);
      Inc(Qtd);
      Num := '';
    Except
      On E: EConvertError Do Begin
        Mensagens.Adicionar(429, Self.ClassName, 'VerificaParametroMultiValor', [Num]);
        Result := -429;
        Exit;
      End;
      On E: Exception Do Begin
        Mensagens.Adicionar(438, Self.ClassName, 'VerificaParametroMultiValor', [E.Message]);
        Result := -438;
        Exit;
      End;
    End;
  end;

begin
  Parametros.Clear;
  Num := '';
  Qtd := 0;
  TxtParametro := Trim(TxtParametro);
  For X := 1 to Length(TxtParametro) do Begin
    If Pos(Copy(TxtParametro, X, 1), '-0123456789') > 0 Then Begin
      Num := Num + Copy(TxtParametro, X, 1);
      If X = Length(TxtParametro) Then Begin
        Result := AdicionaNumero(Num);
        If Result = 0 Then Result := Qtd;
        Exit;
      End;
    End Else Begin
      If Copy(TxtParametro, X, 1) = ' ' Then Begin
        Continue;
      End;
      If Copy(TxtParametro, X, 1) <> ',' Then Begin
        Mensagens.Adicionar(428, Self.ClassName, 'VerificaParametroMultiValor', [TxtParametro]);
        Result := -428;
        Exit;
      End;
      Result := AdicionaNumero(Num);
      If Result < 0 Then Begin
        Exit;
      End;
    End;
  End;
  If Qtd < 1 Then Begin
    Mensagens.Adicionar(437, Self.ClassName, 'VerificaParametroMultiValor', [TxtParametro]);
    Result := -437;
    Exit;
  End;
  Result := Qtd;
end;

function TIntClasseBDBasica.VerificaParametroMultiValorString(
  var TxtParametro: String; var Parametros: TValoresParametro): Integer;
var
  X, Qtd : Integer;
  Num : String;

  function AdicionaNumero(Valor: String): Integer;
  begin
    Result := 0;
    Try
      Parametros.Add(Valor);
      Inc(Qtd);
      Num := '';
    Except
      On E: EConvertError Do Begin
        Mensagens.Adicionar(429, Self.ClassName, 'VerificaParametroMultiValorString', [Num]);
        Result := -429;
        Exit;
      End;
      On E: Exception Do Begin
        Mensagens.Adicionar(438, Self.ClassName, 'VerificaParametroMultiValorString', [E.Message]);
        Result := -438;
        Exit;
      End;
    End;
  end;

begin
  Parametros.Clear;
  Num := '';
  Qtd := 0;
  TxtParametro := Trim(TxtParametro);
  For X := 1 to Length(TxtParametro) do Begin
    If Pos(UpperCase(Copy(TxtParametro, X, 1)), '0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ') > 0 Then Begin
      Num := Num + Copy(TxtParametro, X, 1);
      If X = Length(TxtParametro) Then Begin
        AdicionaNumero(Num);
      End;
    End Else Begin
      If Copy(TxtParametro, X, 1) = ' ' Then Begin
        Continue;
      End;
      If Copy(TxtParametro, X, 1) <> ',' Then Begin
        Mensagens.Adicionar(428, Self.ClassName, 'VerificaParametroMultiValorString', [TxtParametro]);
        Result := -428;
        Exit;
      End;
      Result := AdicionaNumero(Num);
      If Result < 0 Then Begin
        Exit;
      End;
    End;
  End;
  If Qtd < 1 Then Begin
    Mensagens.Adicionar(437, Self.ClassName, 'VerificaParametroMultiValorString', [TxtParametro]);
    Result := -437;
    Exit;
  End;
  TxtParametro := '';
  For X := 0 to Parametros.Count - 1 do Begin
    If TxtParametro <> '' Then TxtParametro := TxtParametro + ', ';
    TxtParametro := TxtParametro + '''' + Parametros.Items[X].Valor + '''';
  End;
  Result := Qtd;
end;

function TIntClasseBDBasica.DtaSistema: TDateTime;
begin
  Result := 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('DtaSistema');
    Exit;
  End;
  Result := Conexao.DtaSistema;
end;

{ Verifica se o retorno SISBOV tem mensagens de erros.
  Se tiver concatena e retorna estas mensagens, caso contrário
  retorna um texto vazio. }
function TIntClasseBDBasica.TrataMensagemErroSISBOV(
  RetornoSISBOV: RetornoWsSISBOV): String;
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

{* Inclui no SQL da query a linha informada de acondo com a condição.

  @param EQuery Query que a linha deve ser incluida
  @param ESQL linha a ser incluida na query
  @param ECondicao Se for True o sql é incluido na query, se for Talse nada é feito}
procedure TIntClasseBDBasica.AddSQL(EQuery: THerdomQuery; ESQL: String;
  ECondicao: Boolean);
begin
  if ECondicao then
  begin
    EQuery.SQL.Add(ESQL);
  end;
end;

{* Inclui no SQL da query a linha informada.

  @param EQuery Query que a linha deve ser incluida
  @param ESQL linha a ser incluida na query}
procedure TIntClasseBDBasica.AddSQL(EQuery: THerdomQuery; ESQL: String);
begin
  AddSQL(EQuery, ESQL, True);
end;

{TIntClasseBDLeituraBasica}
constructor TIntClasseBDLeituraBasica.Create;
begin
  inherited;
  FQuery := THerdomQueryNavegacao.Create(nil);
  FQuery.AfterOpen := AfterOpen;
  FQuery.AfterClose := AfterClose;
  FPosicao := -1;
end;

destructor TIntClasseBDLeituraBasica.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TIntClasseBDLeituraBasica.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
  If Result <> 0 Then Begin
    Exit;
  End;
  FQuery.SQLConnection := ConexaoBD.SQLConnection;
  Result := 0;
end;

function TIntClasseBDLeituraBasica.EOF: Boolean;
begin
  Result := True;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EOF');
    Exit;
  End;
  If FQuery.Active Then Begin
    Result := FQuery.Eof;
  End;
end;

procedure TIntClasseBDLeituraBasica.IrAoPrimeiro;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoPrimeiro');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.First;
    FPosicao := 1;
  End;
end;

procedure TIntClasseBDLeituraBasica.IrAoProximo;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoProximo');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Next;
    If Not FQuery.EOF Then Begin
      Inc(FPosicao);
    End;
  End;
end;

function TIntClasseBDLeituraBasica.ValorCampo(NomeColuna: String): Variant;
begin
  Result := null;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ValorCampo');
    Exit;
  End;
  If FQuery.Active Then Begin
    Try
      If FQuery.FieldByName(NomeColuna).IsNull Then Begin
        Case FQuery.FieldByName(NomeColuna).DataType of
          ftString, ftFixedChar, ftWideString, ftMemo, ftFmtMemo,
          ftBytes, ftVarBytes, ftBlob, ftGraphic:
            Begin
              Result := '';
            End;
          ftSmallInt, ftInteger, ftWord, ftLargeInt,
          ftFloat, ftCurrency, ftBCD,
          ftDate, ftTime, ftDateTime :
            Begin
              Result := 0;
            End;
          ftBoolean :
            Begin
              Result := False;
            End;
        Else
          Result := '';
        End;
      End Else Begin
        Result := FQuery.FieldByName(NomeColuna).Value;
      End;
    Except
      Result := '#CAMPO_INEXISTENTE#';
    End;
  End;
end;

procedure TIntClasseBDLeituraBasica.FecharPesquisa;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('FecharPesquisa');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Close;
  End;
end;

procedure TIntClasseBDLeituraBasica.AfterClose(DataSet: TDataSet);
begin
  FPosicao := -1;
end;

procedure TIntClasseBDLeituraBasica.AfterOpen(DataSet: TDataSet);
begin
  FPosicao := 1;
end;

{TIntClasseBDNavegacaoBasica}
constructor TIntClasseBDNavegacaoBasica.Create;
begin
  inherited;
  FQuery := THerdomQueryNavegacao.Create(nil);
  FQuery.AfterOpen := AfterOpen;
  FQuery.AfterClose := AfterClose;
  FPosicao := -1;
end;

destructor TIntClasseBDNavegacaoBasica.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TIntClasseBDNavegacaoBasica.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
  If Result <> 0 Then Begin
    Exit;
  End;
  FQuery.SQLConnection := ConexaoBD.SQLConnection;
  Result := 0;
end;

function TIntClasseBDNavegacaoBasica.BOF: Boolean;
begin
  Result := True;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BOF');
    Exit;
  End;

  If FQuery.Active Then Begin
    Result := FQuery.Bof;
  End;
end;

function TIntClasseBDNavegacaoBasica.EOF: Boolean;
begin
  Result := True;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EOF');
    Exit;
  End;
  If FQuery.Active Then Begin
    Result := FQuery.Eof;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.IrAoPrimeiro;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoPrimeiro');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.First;
    FPosicao := 1;
    try
      AoRetornarDados;
    except
    end;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.IrAoProximo;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoProximo');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Next;
    try
      AoRetornarDados;
    except
    end;
    If Not FQuery.EOF Then Begin
      Inc(FPosicao);
    End;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.IrAoAnterior;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoAnterior');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Prior;
    try
      AoRetornarDados;
    except
    end;
    If Not FQuery.BOF Then Begin
      Dec(FPosicao);
    End;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.IrAoUltimo;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IrAoUltimo');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Last;
    FPosicao := FQuery.RecordCount;
    try
      AoRetornarDados;
    except
    end;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.Posicionar(NumRegistro: Integer);
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Posicionar');
    Exit;
  End;
  If FQuery.Active Then Begin
//    FQuery.First;
//    FQuery.MoveBy(NumRegistro - 1);
    FQuery.MoveBy(NumRegistro - FPosicao);
    FPosicao := NumRegistro;
    If FQuery.EOF Then Begin
      FPosicao := FQuery.RecordCount;
    End;
    If FQuery.BOF Then Begin
     FPosicao := 1;
    End;
    try
      AoRetornarDados;
    except
    end;
  End;
end;

function TIntClasseBDNavegacaoBasica.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Deslocar');
    Exit;
  End;
  If FQuery.Active Then Begin
    Result := FQuery.MoveBy(QtdRegistros);
    FPosicao := FPosicao + QtdRegistros;
    If FQuery.EOF Then Begin
      FPosicao := FQuery.RecordCount;
    End;
    If FQuery.BOF Then Begin
     FPosicao := 1;
    End;
    try
      AoRetornarDados;
    except
    end;
  End;
end;

function TIntClasseBDNavegacaoBasica.NumeroRegistros: Integer;
var
  Q: THerdomQuery;
  sAux: String;
  iAux: Integer;
begin
  Result := 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('NumeroRegistros');
    Exit;
  End;
  If FQuery.Active Then Begin
    Result := FQuery.RecordCount;
    If Result < 0 Then Begin
      Q := THerdomQuery.Create(Conexao, nil);
      Try
        Try
          Q.Close;
          Q.SQL.Text := '';
          sAux := LowerCase(FQuery.SQL.Text);
          iAux := Pos('select', sAux);
          while iAux > 0 do begin
            Q.SQL.Text := Q.SQL.Text + Copy(sAux, 1, iAux+5);
            sAux := Copy(sAux, iAux+6, Length(sAux)-iAux);
            Q.SQL.Text := Q.SQL.Text + ' count(1) as NumRegistros ';
            iAux := Pos('from', sAux);
            sAux := Copy(sAux, iAux, Length(sAux)-iAux+1);
            iAux := Pos('select', sAux);
          end;
          iAux := Pos('order by', sAux);
          if iAux > 0 then begin
            sAux := Copy(sAux, 1, iAux-1);
          end;
          Q.SQL.Text := Q.SQL.Text + sAux;
          Q.PrepareStatement;
          for iAux := 0 to Q.ParamCount-1 do begin
            Q.Params[iAux].Value := FQuery.ParamByName(Q.Params[iAux].Name).Value;
          end;
          Q.Open;
          Result := 0;
          while not Q.EOF do begin
            Result := Result + Q.FieldByName('NumRegistros').AsInteger;
            Q.Next;
          end;
          Q.Close;
        Except
          Result := -1;
        End;
      Finally
        Q.Free;
      End;
    End;
  End;
end;
{
============================================================================================
Data de Criacao:      03/12/2007      Data de Atualizacao:
Criado por:           Antônio Druzo  Atualizado por:
procedimento SplitString: Esse procedimento é responsavel por quebar uma string em uma string
                          List de acordo com o com o caractere especificado
parametros:  Valor       - A string q sera quebrada
             Caractere   - O carcatere que sera usado como referencia para quebrar a string
Retorno:     Uma String List :TStringList
obs:
============================================================================================
}
function TIntClasseBDNavegacaoBasica.SplitString(Valor:String;caractere:char)  :TStringList;
var PosicaoAtual,PosicaoAnterior:Integer;
begin
  Result  :=  TStringList.Create;
  PosicaoAtual    :=  1;
  PosicaoAtual    :=  PosEx(caractere,Valor,PosicaoAtual);
  if Copy(Valor,1,PosicaoAtual) <>'' then
    begin
      Result.add(Copy(Valor,1,PosicaoAtual-1));
      PosicaoAnterior :=  PosicaoAtual;
      PosicaoAtual    :=  PosEx(caractere,Valor,PosicaoAtual+1);
    end
  else
    begin
      PosicaoAnterior :=  1;
      PosicaoAtual    :=  0;
    end;

  while PosicaoAtual  > 0 do
    begin
      Result.add(Copy(Valor,PosicaoAnterior+1,PosicaoAtual-PosicaoAnterior-1));
      PosicaoAnterior :=  PosicaoAtual;
      PosicaoAtual    :=  PosEx(caractere,Valor,PosicaoAtual+1);
    end;
  if trim(Copy(Valor,PosicaoAnterior,Length(Valor))) <> ''  then
    Result.add(Copy(Valor,PosicaoAnterior,Length(Valor)));
  for PosicaoAtual := 0  to Result.Count -1 do
    Result.Strings[PosicaoAtual]  :=  Trim(Result.Strings[PosicaoAtual]);
end;


function TIntClasseBDNavegacaoBasica.ValorCampo(NomeColuna: String): Variant;
begin
  Result := null;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ValorCampo');
    Exit;
  End;
  If FQuery.Active Then Begin
    Try
      If FQuery.FieldByName(NomeColuna).IsNull Then Begin
        Case FQuery.FieldByName(NomeColuna).DataType of
          ftString, ftFixedChar, ftWideString, ftMemo, ftFmtMemo,
          ftBytes, ftVarBytes, ftBlob, ftGraphic:
            Begin
              Result := '';
            End;
          ftSmallInt, ftInteger, ftWord, ftLargeInt,
          ftFloat, ftCurrency, ftBCD,
          ftDate, ftTime, ftDateTime :
            Begin
              Result := 0;
            End;
          ftBoolean :
            Begin
              Result := False;
            End;
        Else
          Result := '';
        End;
      End Else Begin
        if (FQuery.FieldByName(NomeColuna).DataType = ftFloat) or
           (FQuery.FieldByName(NomeColuna).DataType = ftCurrency) then
        begin
          Result := FormatFloat('#0.00', FQuery.FieldByName(NomeColuna).Value);
        end
        else
        begin
          Result := FQuery.FieldByName(NomeColuna).Value;
        end;
      End;
    Except
      Result := '#CAMPO_INEXISTENTE#';
    End;
  End;
end;

procedure TIntClasseBDNavegacaoBasica.FecharPesquisa;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('FecharPesquisa');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Close;
  End;
end;

function TIntClasseBDNavegacaoBasica.GravarLogOperacao(NomeTabela: String;
  CodRegistroLog, CodOperacao, CodMetodo: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('GravaLogOperacao');
    Exit;
  End;

  Result := TIntClasseBDNavegacaoBasica.GravarLogOperacao(FConexao,
    FMensagens, NomeTabela, CodRegistroLog, CodOperacao, CodMetodo);
end;

class function TIntClasseBDNavegacaoBasica.GravarLogOperacao(EConexao: TConexao;
  EMensagens: TIntMensagens; NomeTabela: String; CodRegistroLog, CodOperacao,
  CodMetodo: Integer): Integer;
var
  Q : THerdomQuery;
  CodTabela, CodLogOperacao, X, Y : Integer;
  TxtDados, S : String;
begin
  If (CodOperacao < 1) or (CodOperacao > 6) Then Begin
    EMensagens.Adicionar(183, Self.ClassName, 'GravaLogOperacao', [IntToStr(CodOperacao)]);
    Result := -183;
    Exit;
  End;

  Q := THerdomQuery.Create(EConexao, nil);
  Try
    Try

      // Obtem Código da Tabela
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tabela');
      Q.SQL.Add('  from tab_tabela_log');
      Q.SQL.Add(' where nom_tabela = :nom_tabela');
{$ENDIF}
      Q.ParamByName('nom_tabela').AsString := NomeTabela;
      Q.Open;
      If Q.IsEmpty Then Begin
        EMensagens.Adicionar(184, Self.ClassName, 'GravarLogOperacao', [NomeTabela]);
        Result := -184;
        Exit;
      End;
      CodTabela := Q.FieldByName('cod_tabela').AsInteger;
      Q.Close;

      // Abre transação interna
      EConexao.BeginTran('GRAVAR_LOG_OPERACAO');

      // Obtem sequencia de log de operação
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_sequencia_codigo');
      Q.SQL.Add('   set cod_log_operacao = cod_log_operacao + 1');
{$ENDIF}
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_log_operacao from tab_sequencia_codigo');
{$ENDIF}
      Q.Open;

      If Q.IsEmpty Then Begin
        EMensagens.Adicionar(206, Self.ClassName, 'GravaLogOperacao', []);
        Result := -206;
        EConexao.Rollback;
//        Rollback('GRAVAR_LOG_OPERACAO');
        Exit;
      End;

      CodLogOperacao := Q.FieldByName('cod_log_operacao').AsInteger;
      Q.Close;

      // Obtem registro para geração dos dados de log
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select *');
      Q.SQL.Add('  from ' + NomeTabela);
      Q.SQL.Add(' where cod_registro_log = :cod_registro_log');
{$ENDIF}
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.Open;
      If Q.IsEmpty Then Begin
        EMensagens.Adicionar(186, Self.ClassName, 'GravarLogOperacao', [IntToStr(CodRegistroLog), NomeTabela]);
        Result := -186;
//        Rollback('GRAVAR_LOG_OPERACAO');
        EConexao.Rollback;
        Exit;
      End;

      // Monta TxtDados
      TxtDados := '';
      For X := 0 to Q.FieldCount - 1 do Begin
        Case Q.Fields[X].DataType of
          ftString, ftFixedChar, ftWideString :
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                S := Q.Fields[X].Text;
                For Y := 1 to Length(S)  do Begin
                  If S[Y] = '"' Then S[Y] := '´';
                End;
                TxtDados := TxtDados + '"' + S + '",';
              End;
            End;
          ftSmallInt, ftInteger, ftWord, ftLargeInt :
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                TxtDados := TxtDados + Q.Fields[X].Text + ',';
              End;
            End;
          ftFloat, ftCurrency, ftBCD :
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                S := Q.Fields[X].Text;
                For Y := 1 to Length(S)  do Begin
                  If S[Y] = ',' Then S[Y] := '.';
                End;
                TxtDados := TxtDados + S + ',';
              End;
            End;
          ftDate, ftTime, ftDateTime, ftTimeStamp :
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                S := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzzz', Q.Fields[X].AsDateTime);
                TxtDados := TxtDados + S + ',';
              End;
            End;
          ftBoolean :
            Begin
              If Q.Fields[X].AsBoolean Then S := 'TRUE' Else S := 'FALSE';
              TxtDados := TxtDados + S + ',';
            End;
          ftMemo, ftFmtMemo:
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                S := Q.Fields[X].Text;
                For Y := 1 to Length(S)  do Begin
                  If S[Y] = '"' Then S[Y] := '´';
                End;
                TxtDados := TxtDados + '"' + S + '",';
              End;
            End;
          ftBytes, ftVarBytes, ftBlob, ftGraphic:
            Begin
              If Q.Fields[X].IsNull Then Begin
                TxtDados := TxtDados + '<NULL>,';
              End Else Begin
                TxtDados := TxtDados + '<BLOB>,';
              End;
            End;
        Else
          TxtDados := TxtDados + '<?>,';
        End;
      End;
      TxtDados     := Copy(TxtDados, 1, Length(TxtDados) - 1);

      // Insere registro na tabela tab_log_operacao
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_log_operacao ');
      Q.SQL.Add(' (cod_log_operacao, ');
      Q.SQL.Add('  dta_operacao, ');
      Q.SQL.Add('  cod_operacao, ');
      Q.SQL.Add('  cod_tabela, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  cod_usuario, ');
      Q.SQL.Add('  txt_dados, ');
      Q.SQL.Add('  cod_metodo, ');
      Q.SQL.Add('  cod_produtor) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_log_operacao, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_operacao, ');
      Q.SQL.Add('  :cod_tabela, ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  :cod_usuario, ');
      Q.SQL.Add('  :txt_dados, ');
      Q.SQL.Add('  :cod_metodo, ');
      Q.SQL.Add('  :cod_produtor) ');
{$ENDIF}
      Q.ParamByName('cod_log_operacao').AsInteger := CodLogOperacao;
      Q.ParamByName('cod_operacao').AsInteger := CodOperacao;
      Q.ParamByName('cod_tabela').AsInteger := CodTabela;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ParamByName('cod_usuario').AsInteger := EConexao.CodUsuario;
      Q.ParamByName('txt_dados').AsMemo := TxtDados;
      Q.ParamByName('cod_metodo').AsInteger := CodMetodo;

      If EConexao.CodProdutor > 0 Then Begin
        Q.ParamByName('cod_produtor').AsInteger := EConexao.CodProdutor;
      End Else Begin
        Q.ParamByName('cod_produtor').Datatype := ftInteger;
        Q.ParamByName('cod_produtor').Clear;
      End;
      Q.ExecSQL;

      // Confirma Transação
      EConexao.Commit('GRAVAR_LOG_OPERACAO');
      Result := 0;
    Except
      On E: Exception do Begin
        EConexao.Rollback;  // desfaz transação se houver uma ativa
//        Rollback('GRAVAR_LOG_OPERACAO');
        EMensagens.Adicionar(185, Self.ClassName, 'GravarLogOperacao', [E.Message]);
        Result := -185;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntClasseBDNavegacaoBasica.ProximoCodRegistroLog: Integer;
begin
  Result := -1;
  
  if not Inicializado then
  begin
    RaiseNaoInicializado('ProximoCodRegistroLog');
    Exit;
  end;

  Result := TIntClasseBDNavegacaoBasica.ProximoCodRegistroLog(FConexao, FMensagens);
end;
(* Este método foi transformando em um método estático
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ProximoCodRegistroLog');
    Exit;
  End;

  Q := THerdomQuery.Create(FConexao, nil);
  Try

    // Obtem sequencia de CodRegistroLog
    BeginTran('OBTER_PROXIMO_CODIGO');
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_sequencia_codigo');
      Q.SQL.Add('   set cod_registro_log = cod_registro_log + 1');
{$ENDIF}
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_sequencia_codigo');
{$ENDIF}
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(206, Self.ClassName, 'ProximoCodRegistroLog', []);
        Result := -206;
        Rollback;
        Exit;
      End;

      Result := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Confirma Transação
      Commit('OBTER_PROXIMO_CODIGO');
    Except
      On E: Exception do Begin
//        Rollback('OBTER_PROXIMO_CODIGO');
        Rollback;
        Mensagens.Adicionar(207, Self.ClassName, 'ProximoCodRegistroLog', [E.Message]);
        Result := -207;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
*)

class function TIntClasseBDNavegacaoBasica.ProximoCodRegistroLog(EConexao: TConexao; EMensagens: TIntMensagens): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(EConexao, nil);
  Try

    // Obtem sequencia de CodRegistroLog
    EConexao.BeginTran('OBTER_PROXIMO_CODIGO');
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_sequencia_codigo');
      Q.SQL.Add('   set cod_registro_log = cod_registro_log + 1');
{$ENDIF}
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_sequencia_codigo');
{$ENDIF}
      Q.Open;

      If Q.IsEmpty Then Begin
        EMensagens.Adicionar(206, Self.ClassName, 'ProximoCodRegistroLog', []);
        Result := -206;
        EConexao.Rollback;
        Exit;
      End;

      Result := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Confirma Transação
      EConexao.Commit('OBTER_PROXIMO_CODIGO');
    Except
      On E: Exception do Begin
//        Rollback('OBTER_PROXIMO_CODIGO');
        EConexao.Rollback;
        EMensagens.Adicionar(207, Self.ClassName, 'ProximoCodRegistroLog', [E.Message]);
        Result := -207;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


procedure TIntClasseBDNavegacaoBasica.BeginTran(NomTransacao: String);
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BeginTran');
    Exit;
  End;
  Conexao.BeginTran(NomTransacao);
end;

procedure TIntClasseBDNavegacaoBasica.Commit(NomTransacao: String);
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Commit');
    Exit;
  End;
  Conexao.Commit(NomTransacao);
end;

procedure TIntClasseBDNavegacaoBasica.Rollback(NomTransacao: String);
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Rollback');
    Exit;
  End;
  Conexao.Rollback(NomTransacao);
end;

function TIntClasseBDNavegacaoBasica.CadastroEfetivado(NomeTabela, NomeColuna: String;
  CodPessoaProdutor, CodRegistro: Integer; PossuiFimValidade: Boolean): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('CadastroEfetivado');
    Exit;
  End;

  Q := THerdomQuery.Create(FConexao, nil);
  Try

    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_efetivacao_cadastro ');
      Q.SQL.Add('  from ' + NomeTabela );
      Q.SQL.Add(' where ' + NomeColuna + ' = :cod_registro');
      If CodPessoaProdutor > 0 Then Begin
        Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor' );
      End;
      If PossuiFimValidade Then Begin
        Q.SQL.Add('   and dta_fim_validade is null' );
      End;
{$ENDIF}
      If CodPessoaProdutor > 0 Then Begin
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      End;
      Q.ParamByName('cod_registro').AsInteger := CodRegistro;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(503, Self.ClassName, 'CadastroEfetivado', [NomeTabela, IntToStr(CodRegistro)]);
        Result := -503;
        Rollback;
        Exit;
      End;

      If Q.FieldByName('dta_efetivacao_cadastro').IsNull Then Begin
        Result := 0;
      End Else Begin
        Result := 1;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(504, Self.ClassName, 'CadastroEfetivado', [E.Message]);
        Result := -504;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntClasseBDNavegacaoBasica.ExportadoSisbov(NomeTabela,
  NomeColuna: String; CodPessoaProdutor, CodRegistro: Integer;
  PossuiFimValidade: Boolean): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ExportadoSisbov');
    Exit;
  End;

  Q := THerdomQuery.Create(FConexao, nil);
  Try

    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_arquivo_sisbov ');
      Q.SQL.Add('  from ' + NomeTabela );
      Q.SQL.Add(' where ' + NomeColuna + ' = :cod_registro');
      If CodPessoaProdutor > 0 Then Begin
        Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor' );
      End;
      If PossuiFimValidade Then Begin
        Q.SQL.Add('   and dta_fim_validade is null' );
      End;
{$ENDIF}
      If CodPessoaProdutor > 0 Then Begin
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      End;
      Q.ParamByName('cod_registro').AsInteger := CodRegistro;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(505, Self.ClassName, 'ExportadoSisbov', [NomeTabela, IntToStr(CodRegistro)]);
        Result := -505;
        Rollback;
        Exit;
      End;

      If Q.FieldByName('cod_arquivo_sisbov').IsNull Then Begin
        Result := 0;
      End Else Begin
        Result := 1;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(506, Self.ClassName, 'ExportadoSisbov', [E.Message]);
        Result := -506;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

(*
A partir de 19/10/2004 o procedimento de atualização de grandezas será
realizado a partir da execução de processo batch por intervalos configuráveis
e não mais a partir da execução de cada operação como anteriormente.
function TIntClasseBDNavegacaoBasica.AtualizaGrandeza(CodGrandezaResumo,
  CodPessoaProdutor, VlrGrandezaResumo: Integer): Integer;
const
  NomeMetodo : String = 'AtualizaGrandeza';
var
  Q : THerdomQuery;
  Valor : Integer;
  NovoRegistro : Boolean;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(FConexao, nil);
  Try

    Try
      BeginTran;

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select vlr_grandeza_resumo ' +
                '  from tab_valor_grandeza_resumo ' +
                ' where cod_grandeza_resumo = :cod_grandeza_resumo ' +
                '   and cod_pessoa_produtor = :cod_pessoa_produtor ' );
{$ENDIF}
      Q.ParamByName('cod_grandeza_resumo').AsInteger := CodGrandezaResumo;
      If CodPessoaProdutor > 0 Then Begin
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      End Else Begin
        Q.ParamByName('cod_pessoa_produtor').DataType := ftInteger;
        Q.ParamByName('cod_pessoa_produtor').Clear;
      End;
      Q.Open;

      If Q.IsEmpty Then Begin
        NovoRegistro := True;
        Valor := VlrGrandezaResumo;
      End Else Begin
        NovoRegistro := False;
        Valor := Q.FieldByName('vlr_grandeza_resumo').AsInteger + VlrGrandezaResumo;
      End;

      // Consiste novo valor para o registro
      If Valor < 0 Then Begin
        Valor := 0;
      End;

      // Atualiza tabela
      Q.Close;
      Q.SQL.Clear;

      If NovoRegistro Then Begin
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_valor_grandeza_resumo ' +
                  '      (cod_grandeza_resumo, ' +
                  '       cod_pessoa_produtor, ' +
                  '       vlr_grandeza_resumo) ' +
                  ' values ' +
                  '      (:cod_grandeza_resumo, ' +
                  '       :cod_pessoa_produtor, ' +
                  '       :vlr_grandeza_resumo) ');
  {$ENDIF}
      End Else Begin
        If Valor > 0 Then Begin
          Q.SQL.Add('update tab_valor_grandeza_resumo ' +
                    '   set vlr_grandeza_resumo = :vlr_grandeza_resumo ' +
                    ' where cod_grandeza_resumo = :cod_grandeza_resumo ' +
                    '   and cod_pessoa_produtor = :cod_pessoa_produtor ' );
        End Else Begin
          Q.SQL.Add('delete from tab_valor_grandeza_resumo ' +
                    ' where cod_grandeza_resumo = :cod_grandeza_resumo ' +
                    '   and cod_pessoa_produtor = :cod_pessoa_produtor ' );
        End;
      End;

      Q.ParamByName('cod_grandeza_resumo').AsInteger := CodGrandezaResumo;
      If CodPessoaProdutor > 0 Then Begin
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      End Else Begin
        Q.ParamByName('cod_pessoa_produtor').DataType := ftInteger;
        Q.ParamByName('cod_pessoa_produtor').Clear;
      End;
      If NovoRegistro or (Valor > 0) Then Begin
        Q.ParamByName('vlr_grandeza_resumo').AsInteger := Valor;
      End;
      Q.ExecSQL;
      Commit;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(770, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -770;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
*)

procedure TIntClasseBDNavegacaoBasica.AfterClose(DataSet: TDataSet);
begin
  FPosicao := -1;
  try
    AoFecharDataset;
  except
  end;
end;

procedure TIntClasseBDNavegacaoBasica.AfterOpen(DataSet: TDataSet);
begin
  FPosicao := 1;
    try
      AoRetornarDados;
    except
    end;
end;

function TIntClasseBDNavegacaoBasica.VerificarAgendamentoTarefa(
  CodTipoTarefa: Integer; Parametros: array of Variant): Integer;
const
  NomeMetodo: String = 'VerificarAgendamentoTarefa';
var
  Q: THerdomQuery;
  iAux: Integer;
  sCodTipoDado, sValParametro: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  top 1 1 '+
        'from '+
        '  tab_tarefa tt ';
      for iAux := 1 to Length(Parametros) do begin
        Q.SQL.Text := Q.SQL.Text +
          '  , tab_tarefa_parametro ttp'+IntToStr(iAux)+' ';
      end;
      Q.SQL.Text := Q.SQL.Text +
        'where '+
        '  tt.cod_tipo_tarefa = :cod_tipo_tarefa '+
        '  and tt.cod_situacao_tarefa in (''N'', ''A'') ';
      Q.ParamByName('cod_tipo_tarefa').AsInteger := CodTipoTarefa;
      for iAux := 1 to Length(Parametros) do begin
        Q.SQL.Text := Q.SQL.Text +
          '  and ttp'+IntToStr(iAux)+'.cod_tarefa = tt.cod_tarefa '+
          '  and ttp'+IntToStr(iAux)+'.cod_parametro = '+IntToStr(iAux)+' '+
          '  and ttp'+IntToStr(iAux)+'.val_parametro = :param'+IntToStr(iAux)+' ';
        VarToParamStr(Parametros[iAux-1], sCodTipoDado, sValParametro);
        Q.ParamByName('param'+IntToStr(iAux)).AsString := sValParametro;
      end;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 1;
      end else begin
        Result := 0;
      end;
      Q.Close;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(1336, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1336;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntClasseBDNavegacaoBasica.SolicitarAgendamentoTarefa(
  CodTipoTarefa: Integer; Parametros: array of Variant;
  DtaInicioPrevisto: TDateTime): Integer;
const
  NomeMetodo: String = 'SolicitarAgendamentoTarefa';
var
  Q: THerdomQuery;
  iAux, iCodTarefa, CodTipoOrigemArqImport: Integer;
  NomArqUpload, txt_parametro, sCodTipoDado, sValParametro: String;
  OldThousandSeparator, OldDecimalSeparator: Char;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  OldDecimalSeparator  := DecimalSeparator;
  OldThousandSeparator := ThousandSeparator;
  DecimalSeparator  := ',';
  ThousandSeparator := '.';

  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  cod_tipo_tarefa as CodTipoTarefa '+
        'from '+
        '  tab_tipo_tarefa ttt '+
        'where '+
        '  ttt.cod_tipo_tarefa = :cod_tipo_tarefa ';
      Q.ParamByName('cod_tipo_tarefa').AsInteger := CodTipoTarefa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1339, Self.ClassName, NomeMetodo, []);
        Result := -1339;
        Exit;
      end;

      if DtaInicioPrevisto < Trunc(Now) then begin
        Mensagens.Adicionar(1340, Self.ClassName, NomeMetodo, []);
        Result := -1340;
        Exit;
      end;

      // Monta texto de parametros quer será apresentado ao usuário
      case (CodTipoTarefa) of
        1:
          begin
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  nom_arquivo_upload as NomArquivoUpload '+
              ', nom_arquivo_importacao as NomArquivoImportacao '+
              ', cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
              'from '+
              '  tab_arquivo_importacao tai '+
              'where '+
              '  tai.cod_pessoa_produtor = :cod_pessoa_produtor '+
              '  and tai.cod_arquivo_importacao = :cod_arquivo_importacao ';
            Q.ParamByName('cod_pessoa_produtor').Value := Parametros[0];
            Q.ParamByName('cod_arquivo_importacao').Value := Parametros[1];
            Q.Open;
            NomArqUpload := Q.FieldByName('NomArquivoUpload').AsString;
            txt_parametro := Q.FieldByName('NomArquivoImportacao').AsString;
            CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
          end;
        2:
          begin
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  nom_arq_upload as NomArquivoUpload '+
              ', nom_arq_import_dado_geral as NomArquivoImportacao '+
              ', cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
              'from '+
              '  tab_arq_import_dado_geral tai '+
              'where '+
              '  tai.cod_arq_import_dado_geral = :cod_arquivo_importacao ';
            Q.ParamByName('cod_arquivo_importacao').Value := Parametros[0];
            Q.Open;
            NomArqUpload := Q.FieldByName('NomArquivoUpload').AsString;
            txt_parametro := Q.FieldByName('NomArquivoImportacao').AsString;
            CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
          end;
        3:
          begin
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  nom_arq_upload as NomArquivoUpload '+
              '  , nom_arq_import_sisbov as NomArquivoImportacao '+
              '  , cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
              'from '+
              '  tab_arq_import_sisbov tais '+
              'where '+
              '  tais.cod_arq_import_sisbov = :cod_arq_import_sisbov ';
            Q.ParamByName('cod_arq_import_sisbov').Value := Parametros[0];
            Q.Open;
            NomArqUpload := Q.FieldByName('NomArquivoUpload').AsString;
            txt_parametro := Q.FieldByName('NomArquivoImportacao').AsString;
            CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
          end;
        4:
          begin
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  nom_arq_upload as NomArquivoUpload '+
              '  , nom_arq_import_fabricante as NomArquivoImportacao '+
              '  , cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
              'from '+
              '  tab_arq_import_fabricante '+
              'where '+
              '  cod_arq_import_fabricante = :cod_arq_import_fabricante ';
            Q.ParamByName('cod_arq_import_fabricante').Value := Parametros[0];
            Q.Open;
            NomArqUpload := Q.FieldByName('NomArquivoUpload').AsString;
            txt_parametro := Q.FieldByName('NomArquivoImportacao').AsString;
            CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
          end;
        5:
          begin
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  txt_titulo '+
              'from '+
              '  tab_relatorio '+
              'where '+
              '  cod_relatorio = :cod_relatorio ';
            Q.ParamByName('cod_relatorio').Value := Parametros[0];
            Q.Open;

            NomArqUpload := Q.FieldByName('txt_titulo').AsString;
            txt_parametro := Q.FieldByName('txt_titulo').AsString;
            CodTipoOrigemArqImport := -1;
          end;
        6:
        begin
            Q.Close;
            Q.SQL.Text :=
              ' select '+
              '        nom_arq_upload as NomArquivoUpload '+
              '      , nom_arq_import_boleto as NomArquivoImportacao '+
              '   from '+
              '        tab_arq_import_boleto taib '+
              '  where '+
              '        taib.cod_arq_import_boleto = :cod_arq_import_boleto ';
            Q.ParamByName('cod_arq_import_boleto').Value := Parametros[0];
            Q.Open;
            NomArqUpload  := Q.FieldByName('NomArquivoUpload').AsString;
            txt_parametro := Q.FieldByName('NomArquivoImportacao').AsString;
            CodTipoOrigemArqImport := -1;
        end;
        7:
        begin
          NomArqUpload := 'Aplicação de evento automático';
          txt_parametro := 'Aplicação de evento automático';
          CodTipoOrigemArqImport := -1;
        end;
        8:
        begin
          NomArqUpload  := 'Animais_ABCZ_' + VarToStr(Parametros[High(Parametros)]) ;
          txt_parametro := 'Exportação de Dados - ABCZ';
          CodTipoOrigemArqImport := -1;
        end;
      else
        NomArqUpload := '';
        txt_parametro := '';
        CodTipoOrigemArqImport := -1;
      end;

      // Inicia transação
      BeginTran;

      // Obtendo código para a tarefa
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  isnull(max(cod_tarefa), 0)+1 as CodTarefa '+
        'from '+
        '  tab_tarefa ';
      Q.Open;
      iCodTarefa := Q.FieldByName('CodTarefa').AsInteger;

      // Inserindo tarefa
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_tarefa '+
        ' (cod_tarefa '+
        '  , cod_tipo_tarefa '+
        '  , cod_situacao_tarefa '+
        '  , cod_usuario '+
        '  , txt_parametros '+
        '  , dta_agendamento '+
        '  , dta_inicio_previsto '+
        '  , dta_inicio_real '+
        '  , dta_fim_real '+
        '  , qtd_progresso '+
        '  , txt_mensagem_erro '+
        '  , ind_cancelada '+
        '  , nom_arq_upload '+
        '  , cod_tipo_origem_arq_import) '+
        'values '+
        ' (:cod_tarefa '+
        '  , :cod_tipo_tarefa '+
        '  , ''N'' '+
        '  , :cod_usuario '+
        '  , :txt_parametros '+
        '  , getdate() '+
        '  , :dta_inicio_previsto '+
        '  , null '+
        '  , null '+
        '  , 0 '+
        '  , null '+
        '  , ''N'' '+
        '  , :nome_arq_upload '+
        '  , :cod_tipo_origem_arq_import )';
      Q.ParamByName('cod_tarefa').AsInteger := iCodTarefa;
      Q.ParamByName('cod_tipo_tarefa').AsInteger := CodTipoTarefa;
      Q.ParamByName('cod_usuario').AsInteger := FConexao.CodUsuario;
      Q.ParamByName('txt_parametros').AsString := txt_parametro;
      if NomArqUpload <> '' then begin
        Q.ParamByName('nome_arq_upload').AsString := NomArqUpload;
      end else begin
        Q.ParamByName('nome_arq_upload').DataType := ftString;
        Q.ParamByName('nome_arq_upload').Clear;
      end;
      Q.ParamByName('dta_inicio_previsto').AsDateTime := DtaInicioPrevisto;
      if CodTipoOrigemArqImport > 0 then begin
        Q.ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
      end else begin
        Q.ParamByName('cod_tipo_origem_arq_import').DataType := ftInteger;
        Q.ParamByName('cod_tipo_origem_arq_import').Clear;
      end;
      Q.ExecSQL;

      // Inserindo parametros referentes a tarefa
      Q.SQL.Text :=
        'insert into tab_tarefa_parametro '+
        ' (cod_tarefa '+
        '  , cod_parametro '+
        '  , cod_tipo_dado '+
        '  , val_parametro) '+
        'values '+
        ' (:cod_tarefa '+
        '  , :cod_parametro '+
        '  , :cod_tipo_dado '+
        '  , :val_parametro) ';
      Q.ParamByName('cod_tarefa').AsInteger := iCodTarefa;
      for iAux := 1 to Length(Parametros) do begin
        VarToParamStr(Parametros[iAux-1], sCodTipoDado, sValParametro);
        Q.ParamByName('cod_parametro').AsInteger := iAux;
        Q.ParamByName('cod_tipo_dado').AsString := sCodTipoDado;
        Q.ParamByName('val_parametro').AsString := sValParametro;
        Q.ExecSQL;
      end;

      // Encerra transação
      Commit;

      // Identifica procedimento como bem sucedido e retorno o Código da tarefa
      // que foi agendanda!
      Result := iCodTarefa;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1337, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1337;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    DecimalSeparator  := OldDecimalSeparator;
    ThousandSeparator := OldThousandSeparator;
  End;
end;

{ TRelatorioPadrao }

function TRelatorioPadrao.BuscarValorParametroSistema(Parametro: Integer;
  var Valor: String): Integer;
const
  NomeMetodo: String = 'BuscarValorParametroSistema';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select val_parametro_sistema');
      Q.SQL.Add('  from tab_parametro_sistema');
      Q.SQL.Add(' where cod_parametro_sistema = :cod_parametro_sistema');
{$ENDIF}
      Q.ParamByName('cod_parametro_sistema').AsInteger := Parametro;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(193, Self.ClassName, NomeMetodo, [IntToStr(Parametro)]);
        Result := -193;
        Exit;
      End;
      Valor := Conexao.CaminhoArquivosCertificadora + Q.FieldByName('val_parametro_sistema').AsString;
      Result := 0;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(966, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -966;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

constructor TRelatorioPadrao.Create(AOwner: TComponent; ConexaoBD: TConexao;
  Mensagens: TIntMensagens);
begin
  Create(AOwner);
  FAuxiliarLinha := 0;
  FInicializado := False;
  FCampos := TCampos.Create;
  FConexao := ConexaoBD;
  FMensagens := Mensagens;
  FMargem := 5;
  FAlturaCabecalho := 0;
  FAlturaRodape := 0;
  FLinhasPorPagina := 0;
  FCodOrientacao := coPaisagem;
  if BuscarValorParametroSistema(12, FLogoTQI) < 0 then Abort;
  if BuscarValorParametroSistema(13, FLogoCertificadora) < 0 then Abort;
  FFormatarTxtDados := True;
  FPrimeiraLinhaNegritoTxtDados := False;
  FCodTamanhoFonteTxtDados := 2;
  FNomeArquivo := '';
  FTxtCabecalho := '';
  FTxtCabecalhoX := 0;
  FCodTarefa := -1;
  FUsaCabecalhoColunas := True;
end;

destructor TRelatorioPadrao.Destroy;
begin
  FCampos.Free;
end;

function TRelatorioPadrao.ConsistirLarguraLinha: Integer;
const
  NomeMetodo: String = 'ConsistirLarguraLinha';
var
  Q: THerdomQuery;
  Largura: Integer;
begin

  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_largura from tab_largura_linha_relatorio ' +
                ' where cod_orientacao = :cod_orientacao ' +
                '   and cod_tamanho_fonte = :cod_tamanho_fonte ');
{$ENDIF}
      Q.ParamByName('cod_orientacao').AsInteger := FCodOrientacao;
      Q.ParamByName('cod_tamanho_fonte').AsInteger := FCodTamanhoFonte;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(967, Self.ClassName, NomeMetodo, []);
        Result := -967;
        Exit;
      End;
      Largura := Q.FieldByName('qtd_largura').AsInteger div FQtdColunas;
      If FCampos.LarguraLinha > Largura then begin
        Mensagens.Adicionar(969, Self.ClassName, NomeMetodo, []);
        Result := -969;
        Exit;
      end;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(968, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -968;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TRelatorioPadrao.BuscarSPID: Integer;
const
  NomeMetodo: String = 'BuscarSPID';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select @@spid as SPID ');
{$ENDIF}
      Q.Open;
      Result := Q.FieldByName('SPID').AsInteger;
      Q.Close;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(971, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -971;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TRelatorioPadrao.CarregarRelatorio: Integer;
const
  NomeMetodo: String = 'CarregarRelatorio';
var
  Q: THerdomQuery;
  R: TIntRelatorios;
  RPersonalizado: Boolean;
begin
  Q := THerdomQuery.Create(FConexao, nil);
  R := TIntRelatorios.Create;
  Try
    Try
      Result := R.Inicializar(FConexao, FMensagens);
      if Result < 0 then Exit;
      Result := R.Buscar(FCodRelatorio);
      if Result < 0 then Exit;
      {Otendo largura da linha}
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select '+
                '  qtd_largura '+
                'from '+
                '  tab_largura_linha_relatorio '+
                'where '+
                '  cod_orientacao = :cod_orientacao '+
                '  and cod_tamanho_fonte = :cod_tamanho_fonte ');
      Q.ParamByName('cod_orientacao').AsInteger := R.IntRelatorio.CodOrientacao;
      Q.ParamByName('cod_tamanho_fonte').AsInteger := R.IntRelatorio.CodTamanhoFonte;
      Q.Open;
      FLarguraLinha := Q.FieldByName('qtd_largura').AsInteger div R.IntRelatorio.QtdColunas;
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select ' +
                '  txt_titulo ' +
                '  , nom_field ' +
                '  , qtd_largura ' +
                '  , qtd_tamanho ' +
                '  , qtd_decimais ' +
                '  , cod_formato ' +
                '  , cod_alinhamento ' +
                'from ' +
                '  tab_campo_relatorio ' +
                'where ' +
                '  cod_relatorio = :cod_relatorio ' +
                '  and cod_campo = :cod_campo ');
      {Dados principais do relatório}
      FTxtTitulo := R.IntRelatorio.TxtTitulo;
      FQtdColunas := R.IntRelatorio.QtdColunas;
      FCodOrientacao := R.IntRelatorio.CodOrientacao;
      FCodTamanhoFonte := R.IntRelatorio.CodTamanhoFonte;
      FTxtSubTitulo := R.IntRelatorio.TxtSubTitulo;
      RPersonalizado := (R.IntRelatorio.IndPersonalizavel = 'S');
      Result := R.Pesquisar(FCodRelatorio);
      if Result < 0 then Exit;
      {Campos do relatório}
      R.IrAoPrimeiro;
      while not R.EOF do begin
        if not RPersonalizado or (R.ValorCampo('IndSelecaoUsuario') = 'S') then begin
          Q.ParamByName('cod_relatorio').AsInteger := FCodRelatorio;
          Q.ParamByName('cod_campo').AsInteger := R.ValorCampo('CodCampo');
          Q.Open;
          if not Q.IsEmpty then begin
            FCampos.Adicionar(Q.FieldByName('txt_titulo').AsString,
              Q.FieldByName('nom_field').AsString,
              Q.FieldByName('qtd_largura').AsInteger,
              Q.FieldByName('qtd_tamanho').AsInteger,
              Q.FieldByName('qtd_decimais').AsInteger,
              Q.FieldByName('cod_formato').AsInteger,
              Q.FieldByName('cod_alinhamento').AsInteger);
          end;
          Q.Close;
        end;
        R.IrAoProximo;
      end;
      FCampos.IrAoPrimeiro;
      if FCampos.EOF then begin
        Mensagens.Adicionar(962, Self.ClassName, NomeMetodo, []);
        Result := -962;
        Exit;
      end;
      {Dados recuperados com sucesso}
      Result := 0;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(957, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -957;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    R.Free;
  End;
end;

function TRelatorioPadrao.CarregarRelatorio(CodRelatorio: Integer): Integer;
begin
  FCodRelatorio := CodRelatorio;
  Result := CarregarRelatorio;
end;

function TRelatorioPadrao.BuscarNomeArquivo: Integer;
const
  NomeMetodo: String = 'BuscarNomeArquivo';
var
  SR: TSearchRec;
  sAux, NomePadrao: String;
  iAux, iMaior: Integer;
begin
  NomePadrao := Conexao.NomUsuario;
  Result := BuscarValorParametroSistema(14, FNomeArquivo);
  if Result < 0 then Exit;
  if (Length(FNomeArquivo)=0) or (FNomeArquivo[Length(FNomeArquivo)]<>'\') then begin
    FNomeArquivo := FNomeArquivo + '\';
  end;
  if not DirectoryExists(FNomeArquivo) then begin
    if not ForceDirectories(FNomeArquivo) then begin
      Mensagens.Adicionar(1012, Self.ClassName, NomeMetodo, []);
      Result := -1012;
      Exit;
    end;
  end;
  if CodTarefa > 0 then begin
    FNomeArquivo := FNomeArquivo + NomePadrao + '_' + IntToStr(CodTarefa);
  end else begin
    FNomeArquivo := FNomeArquivo + UpperCase(Conexao.NomUsuario);
    Result := BuscarSPID;
    if Result < 0 then Exit;
    FNomeArquivo := FNomeArquivo + '_' + IntToStr(Result) + '_';
    iMaior := 0;
    if FindFirst(FNomeArquivo+#42, faArchive, SR) = 0 then begin
      try
        iAux := Pos('.PDF', UpperCase(SR.Name));
        if iAux = 0 then begin
          iAux := Pos('.CSV', UpperCase(SR.Name));
        end;
        sAux := Copy(UpperCase(SR.Name), iAux-3, 3);
        iAux := StrToIntDef(sAux, 0);
        if iAux > iMaior then begin
          iMaior := iAux;
        end;
        while FindNext(SR) = 0 do begin
          iAux := Pos('.PDF', UpperCase(SR.Name));
          if iAux = 0 then begin
            iAux := Pos('.CSV', UpperCase(SR.Name));
          end;
          sAux := Copy(UpperCase(SR.Name), iAux-3, 3);
          iAux := StrToIntDef(sAux, 0);
          if iAux > iMaior then begin
            iMaior := iAux;
          end;
        end;
      finally
        FindClose(SR);
      end;
    end;
    FNomeArquivo := FNomeArquivo + StrZero(iMaior+1, 3);
  end;
end;

function TRelatorioPadrao.InicializarRelatorio: Integer;
const
  NomeMetodo: String = 'InicializarRelatorio';
  Largura: Integer = 595; {21,00 cm - largura A4}
  Altura: Integer = 842; {29,70 cm - largura A4}
var
  BmpCertificadora, BmpTQI: TBitmap;
begin
  Result := -1;

  {Identificando arquivo caso ainda não tenha sido informado}
  if FNomeArquivo = '' then begin
    Result := BuscarNomeArquivo;
    if Result < 0 then Exit;
  end;

  {Definindo arquivo}
  FileName := FNomeArquivo;

  if FTipoDoArquivo = ctaPDF then begin
    FileName := FileName + '.PDF';

    {Verifica existencia dos arquivos de imagem}
    if not FileExists(FLogoCertificadora) then begin
      Mensagens.Adicionar(941, Self.ClassName, NomeMetodo, [Self.ClassName + '.' + NomeMetodo]);
      Result := -941;
      Exit;
    end;
    if not FileExists(FLogoTQI) then begin
      Mensagens.Adicionar(942, Self.ClassName, NomeMetodo, [Self.ClassName + '.' + NomeMetodo]);
      Result := -942;
      Exit;
    end;
    Compress := True;

    {Verifica se a lagura é permitida para o relatório}
    Result := ConsistirLarguraLinha;
    if Result < 0 then Exit;

    {Definindo tamanho da página e orientação do relatório}
    if FCodOrientacao = coRetrato then begin
      Orientation := poPortrait;
      PageWidth := Largura;
      PageHeight := Altura;
    end else if FCodOrientacao = coPaisagem then begin
      Orientation := poLandscape;
      PageWidth := Altura;
      PageHeight := Largura;
    end;

    {Carregando as logomarcas}
    BmpCertificadora := TBitmap.Create;
    BmpTQI := TBitmap.Create;
    try
      try
        BeginDoc;
        if FCodRelatorio <> 32 then begin
          BmpCertificadora.LoadFromFile(LogoCertificadora);
          FNumBitmapCertificadora := EscreverBitmap(BmpCertificadora);
          BmpTQI.LoadFromFile(LogoTQI);
          FNumBitmapTQI := EscreverBitmap(BmpTQI);
          Cabecalho;
          Rodape;
        end;

        FColunaAtual := 1;
        FMargemEsquerda := FMargem + FMargem;
        Result := 0;
      except
        On E: Exception do Begin
          Mensagens.Adicionar(938, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -938;
          Exit;
        End;
      end;
    finally
      BmpCertificadora.Free;
      BmpTQI.Free;
    end;

    FInicializado := True;

  end else if FTipoDoArquivo = ctaCSV then begin
    FileName := FileName + '.CSV';
    AssignFile(FArquivoCSV, FileName);
    Rewrite(FArquivoCSV);
    FInicializado := True;
    CabecalhoColunas;
    Result := 0;
  end;
  // Atualiza o nome do arquivo, guardando apenas o nome + a extensão (sem path)
  FNomeArquivo := ExtractFileName(FileName);
end;

function TRelatorioPadrao.InicializarRelatorio(CodRelatorio: Integer): Integer;
begin
  {Definição do relatório corrente}
  FCodRelatorio := CodRelatorio;

  {Definindo atributos do relatório}
  Result := CarregarRelatorio;
  if Result < 0 then Exit;

  {Procedimento geral de inicialização do relatório}
  Result := InicializarRelatorio;
end;

function TRelatorioPadrao.FinalizarRelatorio: Integer;
const
  NomeMetodo: String = 'FinalizarRelatorio';
begin
  Result := 0;
  if FInicializado then begin
    try
      if FTipoDoArquivo = ctaPDF then begin
        EndDoc;
      end else begin
        CloseFile(FArquivoCSV);
      end;
    except
      on E: Exception do begin
        Mensagens.Adicionar(970, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -970;
        Exit;
      end;
    end;
  end;
end;

procedure TRelatorioPadrao.AjustarFonte(Name: TPDFFontName; Size: Integer);
begin
  Font.Name := Name;
  Font.Size := Size;
end;

procedure TRelatorioPadrao.Cabecalho;
const
  XQuadroEsq: Integer = 115;
  XQuadroDir: Integer = 115;
  LarguraCaracterPadrao: Integer = 6;
var
  X, Y, T, Aux: Integer;
  S, sUsuario: String;
  bAux: Boolean;

  function LarguraTexto(Texto: String): Integer;
  begin
    Result := Length(Texto) * LarguraCaracterPadrao;
  end;

  function AlturaCaracterPadrao: Integer;
  begin
    Result := ctFonte[FCodTamanhoFonteTxtDados];
  end;

begin

  if FTipoDoArquivo = ctaPDF then begin
    // Garantindo que q pelo - a 1ª letra do nome do usuário será maiúscula
    sUsuario := UpperCase(Copy(Conexao.NomUsuario, 1, 1)) +
      Copy(Conexao.NomUsuario, 2, Length(Conexao.NomUsuario)-1);

    // Molduras inicias
    DrawRectangle(FMargem, FMargem, PageWidth-FMargem, FMargem+45);
    X := XQuadroEsq+FMargem;
    DrawLine(X, FMargem, X, FMargem+45);
    X := PageWidth-FMargem-FMargem-XQuadroDir-FMargem;
    DrawLine(X, FMargem, X, FMargem+45);

    // Logo Certificadora
    ReferenciarBitmap(FMargem+FMargem, FMargem+FMargem,
      FNumBitmapCertificadora, 50);

    // Informações do relatório
    X := FMargem + XQuadroEsq + FMargem;
    AjustarFonte(poCourierBold, 12);
    TextOut(X, FMargem+18, AlinharTexto(
      RedimensionaString(FTxtTitulo, SE(FCodOrientacao = coRetrato, 47, 81)),
      #32, SE(FCodOrientacao = coRetrato, 48, 81), taCentro));
    AjustarFonte(poCourier, 10);
    TextOut(X, FMargem+35, AlinharTexto(
      RedimensionaString(FTxtSubTitulo, SE(FCodOrientacao = coRetrato, 56, 97)),
      #32, SE(FCodOrientacao = coRetrato, 56, 97), taCentro));
    AjustarFonte(poCourier, 8);
    X := PageWidth-FMargem-FMargem-XQuadroDir;
    TextOut(X, FMargem+10, 'DATA:    ' + AlinharTexto(FormatDateTime('dd/mm/yyyy', Now), #32, 15, taDireita));
    TextOut(X, FMargem+20, 'HORA:    ' + AlinharTexto(FormatDateTime('hh:nn', Now), #32, 15, taDireita));
    TextOut(X, FMargem+30, 'PÁGINA:  ' + AlinharTexto(IntToStr(PageNumber), #32, 15, taDireita));
    TextOut(X, FMargem+40, 'USUÁRIO: ' + AlinharTexto(sUsuario, #32, 15, taDireita));
    Y := FMargem+50;

    // Txtdados
    if Length(FTxtDados) > 0 then begin
      Y := Y+AlturaCaracterPadrao;
      Dec(Y, AlturaCaracterPadrao div 2);
      X := FMargem+FMargem;
      if FFormatarTxtDados then begin
        T := 0;
        S := FTxtDados;
        // Obtendo maior descrição
        while S <> '' do begin
          Aux := LarguraTexto(Copy(S, 1, Pos(':', S)));
          if Aux > T then begin
            T := Aux;
          end;
          Aux := Pos(#13#10, S);
          if Aux > 0 then begin
            S := Copy(S, Aux+1, Length(S)-Aux);
          end else begin
            S := '';
          end;
        end;
        Inc(T, 5);
        if T < (FMargem+XQuadroEsq+FMargem)-X then begin
          T := (FMargem+XQuadroEsq+FMargem)-X;
        end;
        // Imprimindo dados
        S := FTxtDados;
        while S <> '' do begin
          Aux := Pos(':', S);
          AjustarFonte(poCourier, AlturaCaracterPadrao);
          TextOut(X, Y, Trim(Copy(S, 1, Aux)));
          AjustarFonte(poCourierBold, AlturaCaracterPadrao);
          S := Trim(Copy(S, Aux+1, Length(S) - (Aux)));
          Aux := Pos(#13#10, S);
          if Aux = 0 then begin
            TextOut(X+T, Y, S);
            S := '';
          end else begin
            TextOut(X+T, Y, Copy(S, 1, Aux-1));
            S := Copy(S, Aux+1, Length(S)-Aux);
          end;
          Inc(Y, AlturaCaracterPadrao);
        end;
      end else begin
        // Imprimindo dados
        bAux := False;
        S := FTxtDados;
        while S <> '' do begin
          if not(bAux) and FPrimeiraLinhaNegritoTxtDados then begin
            AjustarFonte(poCourierBold, AlturaCaracterPadrao);
            bAux := True;
          end else if (Font.Name <> poCourier) or (Font.Size <> AlturaCaracterPadrao) then begin
            AjustarFonte(poCourier, AlturaCaracterPadrao);
          end;
          Aux := Pos(#13#10, S);
          if Aux = 0 then begin
            TextOut(X, Y, S);
            S := '';
          end else begin
            TextOut(X, Y, Copy(S, 1, Aux-1));
            S := Copy(S, Aux+2, Length(S)-Aux);
          end;
          Inc(Y, AlturaCaracterPadrao);
        end;
      end;
      Dec(Y, AlturaCaracterPadrao div 2);
      DrawRectangle(FMargem, FMargem+45, PageWidth-FMargem, Y);
    end;
    AlturaCabecalho := Y;
  end else begin
    AlturaCabecalho := 0;
  end;
  FLinhaCorrente := 0;
end;

procedure TRelatorioPadrao.Rodape;
var
  FontName: TPDFFontName;
  FontSize: Integer;
  X, Y: Integer;
begin
  if FTipoDoArquivo = ctaPDF then begin
    // Salva Fonte
    FontName := Font.Name;
    FontSize := Font.Size;
    AjustarFonte(poTimesRoman, 9);
    (* Powered by HERDDOM
    Y := PageHeight - (FMargem + 15);
    AlturaRodape := PageHeight-Y;
    DrawLine(FMargem, Y, PageWidth - FMargem, Y);
    X := PageWidth - (FMargem + 102);
    Y := PageHeight - (FMargem + 12);
    TextOut(X, Y+6, 'Powered by');
    X := PageWidth-(FMargem+56);
    // Logo Herdom
    ReferenciarBitmap(X, Y, FNumBitmapTQI, 40);
    // Reconfigura fonte original
    AjustarFonte(FontName, FontSize);
    *)
    Y := PageHeight - (FMargem + 15);
    AlturaRodape := PageHeight-Y;
    DrawLine(FMargem, Y, PageWidth - FMargem, Y);
    Y := PageHeight - (FMargem + 12);
    X := PageWidth-(FMargem+107);
    // Logo Herdom
    ReferenciarBitmap(X, Y, FNumBitmapTQI, 40);
    // Reconfigura fonte original
    AjustarFonte(FontName, FontSize);
  end else begin
    AlturaRodape := 0;
  end;
end;

procedure TRelatorioPadrao.NovaLinha;
begin
  Inc(FLinhaCorrente);
  if (FLinhaCorrente = FLinhasPorPagina) and (FCodRelatorio <> 32) then begin
    NovaPagina;
  end;
end;

procedure TRelatorioPadrao.NovaPagina;
begin
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if (FColunaAtual = FQtdColunas) or (FTxtCabecalho <> '') then begin
        NewPage;
        Cabecalho;
        Rodape;
        FColunaAtual := 1;
        FLinhaCorrente := 0;
        FMargemEsquerda := FMargem + FMargem;
      end else begin
        Inc(FColunaAtual);
        FLinhaCorrente := 0;
        FMargemEsquerda := FMargem + (((PageWidth - FMargem - FMargem) div
          FQtdColunas) * (FColunaAtual-1)) + FMargem;
      end;
    end else begin
      FLinhaCorrente := 0;
    end;
  end;
end;

procedure TRelatorioPadrao.CabecalhoColunas;
var
  Y, X: Integer;
  sLinha, sSeparador: String;
  sLinhas: Array of String;
  iLinhas, iAux: Integer;
  bDesabilitado, bExisteCabecalho: Boolean;
begin
  if (FtipoDoArquivo = ctaPDF) and not(FUsaCabecalhoColunas) then Exit;
  iLinhas := 1;
  bExisteCabecalho := False;
  sSeparador := SE(FTipoDoArquivo = ctaPDF, #32, #59);
  with FCampos do begin
    if FTipoDoArquivo = ctaPDF then begin
      // Obtem a quantidade de linhas do cabeçalho de colunas
      IrAoPrimeiro;
      while not EOF do begin
        if not Campo.Desabilitado then begin
          if not bExisteCabecalho then bExisteCabecalho := True;
          iAux := ContarQuebras(FCampos.Campo.TxtTitulo);
          if iAux > iLinhas then begin
            iLinhas := iAux;
          end;
        end;
        IrAoProximo;
      end;
      if bExisteCabecalho then begin
        // Configura a quantidade identificada de linhas para o cabeçalho
        SetLength(sLinhas, iLinhas);
        // Obtem o conteúdo específico de cada linha do cabeçalho
        for iAux := 0 to iLinhas-1 do begin
          IrAoPrimeiro;
          sLinha := '';
          while not EOF do begin
            bDesabilitado := Campo.Desabilitado;
            if not bDesabilitado then begin
              sLinha := sLinha +
                AlinharTexto(ObterLinhaTexto(FCampos.Campo.TxtTitulo, iAux+1),
                #32, FCampos.Campo.QtdLargura, TAlinhamento(
                FCampos.Campo.CodAlinhamento - 1));
            end;
            IrAoProximo;
            if not EOF and not bDesabilitado then begin
              sLinha := sLinha + sSeparador;
            end;
          end;
          sLinhas[iAux] := sLinha;
        end;
      end;
    end else if FTipoDoArquivo = ctaCSV then begin
      IrAoPrimeiro;
      sLinha := '';
      while not EOF do begin
        sLinha := sLinha + #34 +
          Trim(TrataAspas(TrataQuebra(FCampos.Campo.TxtTitulo))) + #34;
        IrAoProximo;
        if not EOF then begin
          sLinha := sLinha + sSeparador;
        end;
      end;
    end;
  end;
  X := 0; Y := 0;
  if FInicializado then begin
    if (FTipoDoArquivo = ctaPDF) and bExisteCabecalho then begin
      Y := AlturaCabecalho;
      if FColunaAtual = 1 then begin
        if FTxtCabecalho = '' then begin
          DrawRectangle(FMargem, Y, PageWidth-FMargem,
            Y+(iLinhas*ctFonte[FCodTamanhoFonte]+(2 * FMargem div 3)));
          Y := Y+(iLinhas*ctFonte[FCodTamanhoFonte]);
        end else begin
          DrawRectangle(FMargem, Y, PageWidth-FMargem,
            Y+((2+iLinhas)*ctFonte[FCodTamanhoFonte])+(2 * FMargem div 3));
          Y := Y+((2+iLinhas)*ctFonte[FCodTamanhoFonte]);
        end;
        AlturaCabecalho := Y;
      end;
      if FTxtCabecalho <> '' then begin
        Y := Y-((1+iLinhas)*ctFonte[FCodTamanhoFonte]);
        X := FMargemEsquerda + FTxtCabecalhoX;
        TextOut(X, Y, FTxtCabecalho);
        FTxtCabecalho := '';
        FTxtCabecalhoX := 0;
        Y := Y+(2*ctFonte[FCodTamanhoFonte]);
      end else begin
        Y := Y-((iLinhas-1)*ctFonte[FCodTamanhoFonte]);
      end;
      if (Font.Name <> poCourier) or (Font.Size <> ctFonte[FCodTamanhoFonte]) then begin
        AjustarFonte(poCourier, ctFonte[FCodTamanhoFonte]);
      end;
      X := FMargemEsquerda;
    end;
    if (FTipoDoArquivo = ctaPDF) and bExisteCabecalho then begin
      for iAux := 0 to iLinhas - 1 do begin
        sLinha := sLinhas[iAux];
        TextOut(X, Y, sLinha);
        if iAux + 1 < iLinhas then begin
          Inc(Y, ctFonte[FCodTamanhoFonte]);
        end;
      end;
    end else if FTipoDoArquivo = ctaCSV then begin
      Writeln(FArquivoCSV, sLinha);
    end;
  end;
end;

function TRelatorioPadrao.GetLinhasRestantes: Integer;
begin
  if FLinhasPorPagina = 0 then begin
    Result := 0;
  end else begin
    Result := FLinhasPorPagina - FLinhaCorrente;
  end;
end;

function TRelatorioPadrao.Colunas(ResultSet: THerdomQuery; TextoPrePos: String): Integer;
var
  X, Y: Integer;
  sLinha, sSeparador: String;
  sLinhas: Array of String;
  iLinhas, iAux: Integer;
  bDesabilitado: Boolean;
begin
  Result := 0;
  iLinhas := 1;
  sSeparador := SE(FTipoDoArquivo = ctaPDF, #32, #59);
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      // Se for início da página imprime o cabeçalho de colunas antes dos dados
      if FLinhaCorrente = 0 then begin
        CabecalhoColunas;
      end;
    end;
    with FCampos do begin
      if ResultSet <> nil then begin
        // Obtem os dados do result set informado
        CarregarValores(ResultSet);
      end;
      if FTipoDoArquivo = ctaPDF then begin
        // Obtem a quantidade de linhas a serem utilizadas pelo registro
        IrAoPrimeiro;
        while not EOF do begin
          if not Campo.Desabilitado then begin
            iAux := ContarQuebras(FCampos.Campo.Valor);
            if iAux > iLinhas then begin
              iLinhas := iAux;
            end;
          end;
          IrAoProximo;
        end;
        // Configura a quantidade identificada de linhas para o registro
        SetLength(sLinhas, iLinhas);
        // Obtem o conteúdo específico de cada linha do registro
        for iAux := 0 to iLinhas-1 do begin
          IrAoPrimeiro;
          sLinha := '';
          while not EOF do begin
            bDesabilitado := Campo.Desabilitado;
            if not bDesabilitado then begin
              sLinha := sLinha +
                AlinharTexto(ObterLinhaTexto(FCampos.Campo.Valor, iAux+1),
                #32, FCampos.Campo.QtdLargura, TAlinhamento(
                FCampos.Campo.CodAlinhamento - 1));
            end;
            IrAoProximo;
            if not EOF and not bDesabilitado then begin
              sLinha := sLinha + sSeparador;
            end;
          end;
          sLinhas[iAux] := sLinha;
        end;
      end else if FTipoDoArquivo = ctaCSV then begin
        // Monta linha de registro contendo dados no formato CSV
        IrAoPrimeiro;
        sLinha := '';
        while not EOF do begin
          sLinha := sLinha + #34 +
            Trim(TrataAspas(TrataQuebra(FCampos.Campo.Valor))) + #34;
          IrAoProximo;
          if not EOF then begin
            sLinha := sLinha + sSeparador;
          end;
        end;
      end;
    end;
    if FTipoDoArquivo = ctaPDF then begin
      {Verifica espaço disponível para impressão e quebra página se necessário}
      if FLinhasPorPagina - FLinhaCorrente < iLinhas then begin
        NovaPagina;
        CabecalhoColunas;
      end;
      X := FMargemEsquerda;
      {Verifica se algum texto pré ou pós a impressão das colunas com valor
      deve ser apresentado também}
      TextoPrePos := Trim(TextoPrePos);
      if (iLinhas = 1) and (TextoPrePos <> '') then begin
        if TextoPrePos[Length(TextoPrePos)] = #58 then begin
          TextoPrePos := Copy(TextoPrePos, 1, Length(TextoPrePos)-1);
        end;
        sLinha := sLinhas[0];
        iAux := 0;
        while iAux < Length(sLinha) do begin
          if sLinha[iAux+1] = #32 then begin
            Inc(iAux);
          end else begin
            Break;
          end;
        end;
        if iAux < Length(TextoPrePos)+2 then begin
          sLinha := sLinha + #32#40 + TextoPrePos + #41;
          if Length(sLinha) > FLarguraLinha then begin
            sLinha := Copy(sLinha, 1, FLarguraLinha-3) + '...';
          end;
        end else begin
          iAux := Length(TextoPrePos)+1;
          sLinha := TextoPrePos + #58 + Copy(sLinha, iAux+1,
            Length(sLinha)-iAux);
        end;
        sLinhas[0] := sLinha;
      end;
      {Imprime linha(s) correpondente(s)}
      for iAux := 0 to iLinhas-1 do begin
        Y := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente+1);
        sLinha := sLinhas[iAux];
        TextOut(X, Y, sLinha);
        if iAux < iLinhas-1 then Inc(FLinhaCorrente);
      end;
    end else begin
      {Redireciona linha a ser impressa para arquivo formato CSV}
      Writeln(FArquivoCSV, sLinha);
    end;
    Inc(FLinhaCorrente);
    if (FLinhaCorrente = FLinhasPorPagina) and Assigned(ResultSet) then begin
      // Verifica se existe o próximo registro antes de quebrar página
      if ResultSet.FindNext then begin
        // Retorna para o registro impresso
        if not ResultSet.Eof then begin
          ResultSet.Prior;
        end;
        // Quebra página
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

function TRelatorioPadrao.ImprimirColunas: Integer;
begin
  Result := 0;
  if FInicializado then begin
    Result := Colunas(nil, '');
  end;
end;

function TRelatorioPadrao.ImprimirColunasResultSet(ResultSet: THerdomQuery): Integer;
begin
  Result := 0;
  if FInicializado then begin
    Result := Colunas(ResultSet, '');
  end;
end;

function TRelatorioPadrao.ImprimirTexto(Posicao: Integer;
  Texto: String): Integer;
var
  Y, I: Integer;
  sLinha: String;
  NomeFonteAtual: TPDFFontName;
begin
  Result := 0;
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if FLinhaCorrente = 0 then begin
        NomeFonteAtual := Font.Name;
        CabecalhoColunas;
        AjustarFonte(NomeFonteAtual, ctFonte[FCodTamanhoFonte])
      end else if FLinhasPorPagina - FLinhaCorrente <= 0 then begin
        if FCodRelatorio <> 32 then begin
          NovaPagina;
          CabecalhoColunas;
        end;
      end;

      Y := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente+1);
      if Texto <> '' then begin
        sLinha := '';
        for I := 1 to Posicao do begin
          sLinha := sLinha + #32;
        end;
        sLinha := sLinha + Texto;
        TextOut(FMargemEsquerda, Y, sLinha);
      end;
      Inc(FLinhaCorrente);
      if FLinhaCorrente = FLinhasPorPagina then begin
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

function TRelatorioPadrao.ImprimirTextoTotalizador(Texto: String): Integer;
begin
  Result := 0;
  if FInicializado then begin
    Result := Colunas(nil, Texto);
  end;
end;

procedure TRelatorioPadrao.ImprimirTextoAposCabecalho(Posicao: Integer;
  Texto: String);
begin
  if FInicializado and (FTipoDoArquivo = ctaPDF) then begin
    FTxtCabecalho := Texto;
    FTxtCabecalhoX := Posicao;
    if FLinhaCorrente > 0 then begin
      NovaPagina;
    end;
  end;
end;

function TRelatorioPadrao.GetYDados: Integer;
begin
  Result := AlturaCabecalho+ctFonte[FCodTamanhoFonte]+FMargem + (2 * FAuxiliarLinha);
end;

procedure TRelatorioPadrao.AtualizaLinhasPorPagina;
var
  I: Integer;
begin
  FLinhasPorPagina := 0;
  I := PageHeight;
  I := I - AlturaCabecalho - AlturaRodape - FMargem - FMargem;
  FLinhasPorPagina := Trunc(I / ctFonte[FCodTamanhoFonte]);
end;

procedure TRelatorioPadrao.SetAlturaCabecalho(const Value: Integer);
begin
  FAlturaCabecalho := Value;
  AtualizaLinhasPorPagina;
end;

procedure TRelatorioPadrao.SetAlturaRodape(const Value: Integer);
begin
  FAlturaRodape := Value;
  AtualizaLinhasPorPagina;
end;

procedure TRelatorioPadrao.SetTipoDoArquivo(const Value: Integer);
begin
  FTipoDoArquivo := Value;
  FCampos.Tipo := Value;
end;

procedure TRelatorioPadrao.RecuperarFonte;
begin
  FSFont := Font;
end;

procedure TRelatorioPadrao.SalvarFonte;
begin
  Font := FSFont;
end;

procedure TRelatorioPadrao.FonteNegrito;
begin
  case Font.Name of
    poHelvetica:
      Font.Name := poHelveticaBold;
    poHelveticaOblique:
      Font.Name := poHelveticaBoldOblique;
    poCourier:
      Font.Name := poCourierBold;
    poCourierOblique:
      Font.Name := poCourierBoldOblique;
    poTimesRoman:
      Font.Name := poTimesBold;
    poTimesItalic:
      Font.Name := poTimesBoldItalic;
  end;
  Font.Size := ctFonte[FCodTamanhoFonte];
end;

procedure TRelatorioPadrao.FonteNormal;
begin
  case Font.Name of
    poHelveticaBold:
      Font.Name := poHelvetica;
    poHelveticaBoldOblique:
      Font.Name := poHelveticaOblique;
    poCourierBold:
      Font.Name := poCourier;
    poCourierBoldOblique:
      Font.Name := poCourierOblique;
    poTimesBold:
      Font.Name := poTimesRoman;
    poTimesBoldItalic:
      Font.Name := poTimesItalic;
  end;
  Font.Size := ctFonte[FCodTamanhoFonte];
end;

procedure TRelatorioPadrao.TextOut(X, Y: Integer; Text: String);
begin
  Text := TrataParentesesPDF(Text);
  inherited;
end;

function TRelatorioPadrao.AlturaLinha: Integer;
begin
   Result := ctFonte[FCodTamanhoFonteTxtDados];
end;

function TRelatorioPadrao.InicializarRelatorio(sSubTitulo: String; DataUltAlteracao: TDate;
                                               HoraUltAlteracao: TTime; NomUsuarioUltAlteracao: String): Integer;
const
  NomeMetodo: String = 'InicializarRelatorio';
  Largura: Integer = 595; {21,00 cm - largura A4}
  Altura: Integer = 842; {29,70 cm - largura A4}
var
  BmpCertificadora, BmpTQI: TBitmap;
begin
  {Retorna erro caso nome do arquivo ainda não tenha sido informado}
  if (Trim(FNomeArquivo) = '') then begin
     Result := -1;
     Exit;
  end;

  {Definindo arquivo}
  FileName := FNomeArquivo;

  if FTipoDoArquivo = ctaPDF then begin
    FileName := FileName + '.PDF';

    {Verifica existencia dos arquivos de imagem}
    if not FileExists(FLogoCertificadora) then begin
      Mensagens.Adicionar(941, Self.ClassName, NomeMetodo, [Self.ClassName + '.' + NomeMetodo]);
      Result := -941;
      Exit;
    end;
    if not FileExists(FLogoTQI) then begin
      Mensagens.Adicionar(942, Self.ClassName, NomeMetodo, [Self.ClassName + '.' + NomeMetodo]);
      Result := -942;
      Exit;
    end;
    Compress := True;

    {Definindo tamanho da página e orientação do relatório}
    if FCodOrientacao = coRetrato then begin
      Orientation := poPortrait;
      PageWidth := Largura;
      PageHeight := Altura;
    end else if FCodOrientacao = coPaisagem then begin
      Orientation := poLandscape;
      PageWidth := Altura;
      PageHeight := Largura;
    end;

    {Carregando as logomarcas}
    BmpCertificadora := TBitmap.Create;
    BmpTQI := TBitmap.Create;
    try
      try
        BeginDoc;
        BmpCertificadora.LoadFromFile(LogoCertificadora);
        FNumBitmapCertificadora := EscreverBitmap(BmpCertificadora);
        BmpTQI.LoadFromFile(LogoTQI);
        FNumBitmapTQI := EscreverBitmap(BmpTQI);
        Cabecalho(sSubTitulo);
        Rodape;
        FColunaAtual := 1;
        FMargemEsquerda := FMargem + FMargem;
      except
        On E: Exception do Begin
          Mensagens.Adicionar(938, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -938;
          Exit;
        End;
      end;
    finally
      BmpCertificadora.Free;
      BmpTQI.Free;
    end;
    FInicializado := True;

  end else if FTipoDoArquivo = ctaCSV then begin
    FileName := FileName + '.CSV';
    AssignFile(FArquivoCSV, FileName);
    Rewrite(FArquivoCSV);
    FInicializado := True;
    CabecalhoColunas;
  end;
  // Atualiza o nome do arquivo, guardando apenas o nome + a extensão (sem path)
  FNomeArquivo := ExtractFileName(FileName);
  Result := 0;
end;

procedure TRelatorioPadrao.Cabecalho(sSubTitulo: String);
const
  XQuadroEsq: Integer = 115;
  XQuadroDir: Integer = 115;
  LarguraCaracterPadrao: Integer = 6;
var
  X, Y, T, Aux: Integer;
  S: String;
  bAux: Boolean;

  function LarguraTexto(Texto: String): Integer;
  begin
    Result := Length(Texto) * LarguraCaracterPadrao;
  end;

  function AlturaCaracterPadrao: Integer;
  begin
    Result := ctFonte[FCodTamanhoFonteTxtDados];
  end;

begin
  if FTipoDoArquivo = ctaPDF then begin
    // Molduras inicias
    DrawRectangle(FMargem, FMargem, PageWidth-FMargem, FMargem+45);
    X := XQuadroEsq+FMargem;
    DrawLine(X, FMargem, X, FMargem+45);
    X := PageWidth-FMargem-FMargem-XQuadroDir-FMargem;
    DrawLine(X, FMargem, X, FMargem+45);

    // Logo Certificadora
    ReferenciarBitmap(FMargem+FMargem, FMargem+FMargem,
      FNumBitmapCertificadora, 50);

    // Informações do relatório
    X := FMargem + XQuadroEsq + FMargem;
    AjustarFonte(poCourierBold, 12);
    TextOut(X, FMargem+18, AlinharTexto(
      RedimensionaString(FTxtTitulo, SE(FCodOrientacao = coRetrato, 47, 81)),
      #32, SE(FCodOrientacao = coRetrato, 48, 81), taCentro));
    AjustarFonte(poCourier, 12);
    TextOut(X, FMargem+35, AlinharTexto(
      RedimensionaString(sSubTitulo, SE(FCodOrientacao = coRetrato, 47, 81)),
      #32, SE(FCodOrientacao = coRetrato, 47, 81), taCentro));
    AjustarFonte(poCourier, 8);
    X := PageWidth-FMargem-FMargem-XQuadroDir;
    TextOut(X, FMargem+10, 'DATA:    ' + AlinharTexto(FormatDateTime('dd/mm/yyyy', Now), #32, 15, taDireita));
    TextOut(X, FMargem+20, 'HORA:    ' + AlinharTexto(FormatDateTime('hh:nn', Now), #32, 15, taDireita));
    TextOut(X, FMargem+30, 'PÁGINA:  ' + AlinharTexto(IntToStr(PageNumber), #32, 15, taDireita));
    Y := FMargem+50;

    // Txtdados
    if Length(FTxtDados) > 0 then begin
      Y := Y+AlturaCaracterPadrao;
      Dec(Y, AlturaCaracterPadrao div 2);
      X := FMargem+FMargem;
      if FFormatarTxtDados then begin
        T := 0;
        S := FTxtDados;
        // Obtendo maior descrição
        while S <> '' do begin
          Aux := LarguraTexto(Copy(S, 1, Pos(':', S)));
          if Aux > T then begin
            T := Aux;
          end;
          Aux := Pos(#13#10, S);
          if Aux > 0 then begin
            S := Copy(S, Aux+1, Length(S)-Aux);
          end else begin
            S := '';
          end;
        end;
        Inc(T, 5);
        if T < (FMargem+XQuadroEsq+FMargem)-X then begin
          T := (FMargem+XQuadroEsq+FMargem)-X;
        end;
        // Imprimindo dados
        S := FTxtDados;
        while S <> '' do begin
          Aux := Pos(':', S);
          AjustarFonte(poCourier, AlturaCaracterPadrao);
          TextOut(X, Y, Trim(Copy(S, 1, Aux)));
          AjustarFonte(poCourierBold, AlturaCaracterPadrao);
          S := Trim(Copy(S, Aux+1, Length(S) - (Aux)));
          Aux := Pos(#13#10, S);
          if Aux = 0 then begin
            TextOut(X+T, Y, S);
            S := '';
          end else begin
            TextOut(X+T, Y, Copy(S, 1, Aux-1));
            S := Copy(S, Aux+1, Length(S)-Aux);
          end;
          Inc(Y, AlturaCaracterPadrao);
        end;
      end else begin
        // Imprimindo dados
        bAux := False;
        S := FTxtDados;
        while S <> '' do begin
          if not(bAux) and FPrimeiraLinhaNegritoTxtDados then begin
            AjustarFonte(poCourierBold, AlturaCaracterPadrao);
            bAux := True;
          end else if (Font.Name <> poCourier) or (Font.Size <> AlturaCaracterPadrao) then begin
            AjustarFonte(poCourier, AlturaCaracterPadrao);
          end;
          Aux := Pos(#13#10, S);
          if Aux = 0 then begin
            TextOut(X, Y, S);
            S := '';
          end else begin
            TextOut(X, Y, Copy(S, 1, Aux-1));
            S := Copy(S, Aux+2, Length(S)-Aux);
          end;
          Inc(Y, AlturaCaracterPadrao);
        end;
      end;
      Dec(Y, AlturaCaracterPadrao div 2);
      DrawRectangle(FMargem, FMargem+45, PageWidth-FMargem, Y);
    end;
    AlturaCabecalho := Y;
  end else begin
    AlturaCabecalho := 0;
  end;
  FLinhaCorrente := 0;
end;

constructor TRelatorioPadrao.Create(ConexaoBD: TConexao; Mensagens: TIntMensagens);
begin
  Create(Nil);
  FAuxiliarLinha := 0;
  FCampos := TCampos.Create;
  FConexao := ConexaoBD;
  FMensagens := Mensagens;
  FInicializado := False;
  FMargem := 5;
  FAlturaCabecalho := 0;
  FAlturaRodape := 0;
  FLinhasPorPagina := 0;
  FCodOrientacao := coPaisagem;
  if BuscarValorParametroSistema(12, FLogoTQI) < 0 then Abort;
  if BuscarValorParametroSistema(13, FLogoCertificadora) < 0 then Abort;
  FFormatarTxtDados := True;
  FPrimeiraLinhaNegritoTxtDados := False;
  FCodTamanhoFonteTxtDados := 2;
  FNomeArquivo := '';
  FTxtCabecalho := '';
  FTxtCabecalhoX := 0;
  FCodTarefa := -1;
  FUsaCabecalhoColunas := True;
end;

procedure TRelatorioPadrao.NovaPagina(sSubTitulo: String);
begin
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if (FColunaAtual = FQtdColunas) or (FTxtCabecalho <> '') then begin
        NewPage;
        Cabecalho(sSubTitulo);
        Rodape;
        FColunaAtual := 1;
        FMargemEsquerda := FMargem + FMargem;
      end else begin
        Inc(FColunaAtual);
        FLinhaCorrente := 0;
        FMargemEsquerda := FMargem + (((PageWidth - FMargem - FMargem) div
          FQtdColunas) * (FColunaAtual-1)) + FMargem;
      end;
    end else begin
      FLinhaCorrente := 0;
    end;
  end;
end;

function TRelatorioPadrao.FinalizarQuadro: Integer;
var
  Y: Integer;
  NomeFonteAtual: TPDFFontName;
begin
  Result := 0;
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if FLinhaCorrente = 0 then begin
        NomeFonteAtual := Font.Name;
        CabecalhoColunas;
        AjustarFonte(NomeFonteAtual, ctFonte[FCodTamanhoFonte])
      end;
      Y := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente) - (ctFonte[FCodTamanhoFonte] div 2);
      FAuxiliarLinha  := -(ctFonte[FCodTamanhoFonte] div 4);      
      DrawRectangle(FMargem, FYQuadroInicial, PageWidth-FMargem, Y);
      if FLinhaCorrente = FLinhasPorPagina then begin
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

function TRelatorioPadrao.ImprimirLinhaQuadro: Integer;
var
  Y: Integer;
  NomeFonteAtual: TPDFFontName;
begin
  Result := 0;
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if FLinhaCorrente = 0 then begin
        NomeFonteAtual := Font.Name;
        CabecalhoColunas;
        AjustarFonte(NomeFonteAtual, ctFonte[FCodTamanhoFonte])
      end;
      Y := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente+1) + (ctFonte[FCodTamanhoFonte] div 2);
      DrawLine(FMargem, Y, PageWidth-FMargem, Y);
      Inc(FLinhaCorrente);      
      if FLinhaCorrente = FLinhasPorPagina then begin
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

function TRelatorioPadrao.InicializarQuadro(IndImprimeLinhaHorizontalInicial: Char): Integer;
var
  NomeFonteAtual: TPDFFontName;
begin
  Result := 0;
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if FLinhaCorrente = 0 then begin
        NomeFonteAtual := Font.Name;
        CabecalhoColunas;
        AjustarFonte(NomeFonteAtual, ctFonte[FCodTamanhoFonte])
      end;
      FAuxiliarLinha  := -(ctFonte[FCodTamanhoFonte] div 2);

      if UpperCase(IndImprimeLinhaHorizontalInicial) = 'S' then
        FYQuadroInicial := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente - 3) - (ctFonte[FCodTamanhoFonte] div 2)
      else
        FYQuadroInicial := FMargem + 45;

//      Inc(FLinhaCorrente);
      if FLinhaCorrente = FLinhasPorPagina then begin
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

function TRelatorioPadrao.DividirQuadroAoMeio(): Integer;
var
  Y: Integer;
  NomeFonteAtual: TPDFFontName;
begin
  Result := 0;
  if FInicializado then begin
    if FTipoDoArquivo = ctaPDF then begin
      if FLinhaCorrente = 0 then begin
        NomeFonteAtual := Font.Name;
        CabecalhoColunas;
        AjustarFonte(NomeFonteAtual, ctFonte[FCodTamanhoFonte])
      end;
      Y := YDados + (ctFonte[FCodTamanhoFonte] * FLinhaCorrente + 1) - (ctFonte[FCodTamanhoFonte] div 2);
      DrawLine((PageWidth div 2), FYQuadroInicial, (PageWidth div 2), Y);
//      Inc(FLinhaCorrente);
      if FLinhaCorrente = FLinhasPorPagina then begin
        Result := 1;
        NovaPagina;
      end;
    end;
  end;
end;

{ TCampos }

constructor TCampos.Create;
begin
  IrAoPrimeiro;
end;

procedure TCampos.Adicionar(aTxtTitulo, aNomField: String; aQtdLargura,
  aQtdTamanho, aQtdDecimais, aCodFormato, aCodAlinhamento: Integer);
begin
  SetLength(FListaCampos, Length(FListaCampos)+1);
  with FListaCampos[Length(FListaCampos)-1] do begin
    TxtTitulo := aTxtTitulo;
    NomField := aNomField;
    QtdLargura := aQtdLargura;
    QtdTamanho := aQtdTamanho;
    QtdDecimais := aQtdDecimais;
    CodFormato := aCodFormato;
    CodAlinhamento := aCodAlinhamento;
    Desabilitado := False;
    Valor := '';
  end;
end;

procedure TCampos.LimparValores;
begin
  if (Length(FListaCampos) > 0) then begin
    IrAoPrimeiro;
    while not EOF do begin
      FListaCampos[FPosicao].Valor := '';
      IrAoProximo;
    end;
  end;
end;

procedure TCampos.CarregarValores(SourceDataSet: THerdomQuery);
var
  ValorFormatado, sAux: String;
  iAux, iLinhas: Integer;
  ResultSet: TDataSet;
begin
  if SourceDataSet is THerdomQueryNavegacao then begin
    ResultSet := TDataSet(THerdomQueryNavegacao(SourceDataSet).ClientDataSet);
  end else begin
    ResultSet := TDataSet(SourceDataSet);
  end;

  if (Length(FListaCampos) > 0) and (ResultSet <> nil) then begin
    LimparValores;
    IrAoPrimeiro;
    while not EOF do begin
      try
        if ResultSet.FieldByName(FListaCampos[FPosicao].NomField).IsNull then begin
          ValorFormatado := '';
        end else case (FListaCampos[FPosicao].CodFormato) of
          1: {Texto}
            ValorFormatado :=
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsString;
          2: {Decimal}
            ValorFormatado := FloatToStrF(
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsFloat,
              ffNumber, FListaCampos[FPosicao].QtdTamanho,
              FListaCampos[FPosicao].QtdDecimais);
          3: {Inteiro}
            ValorFormatado :=
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsString;
          4: {Inteiro c/ 0 a esq.}
            ValorFormatado := StrZero(
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsInteger,
              FListaCampos[FPosicao].QtdTamanho);
          5: {Data (dd/mm)}
            ValorFormatado := FormatDateTime('dd/mm',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          6: {Data (mm/yy)}
            ValorFormatado := FormatDateTime('mm/yy',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          7: {Data (mm/yyyy)}
            ValorFormatado := FormatDateTime('mm/yyyy',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          8: {Data (dd/mm/yy)}
            ValorFormatado := FormatDateTime('dd/mm/yy',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          9: {Data (dd/mm/yyyy)}
            ValorFormatado := FormatDateTime('dd/mm/yyyy',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          10: {Hora (mm:ss)}
            ValorFormatado := FormatDateTime('nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          11: {Hora (hh:mm)}
            ValorFormatado := FormatDateTime('hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          12: {Hora (hh:mm:ss)}
            ValorFormatado := FormatDateTime('hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          13: {Data + Hora (dd/mm mm:ss)}
            ValorFormatado := FormatDateTime('dd/mm nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          14: {Data + Hora (dd/mm hh:mm)}
            ValorFormatado := FormatDateTime('dd/mm hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          15: {Data + Hora (dd/mm hh:mm:ss)}
            ValorFormatado := FormatDateTime('dd/mm hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          16: {Data + Hora (mm/yy mm:ss)}
            ValorFormatado := FormatDateTime('mm/yy nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          17: {Data + Hora (mm/yy hh:mm)}
            ValorFormatado := FormatDateTime('mm/yy hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          18: {Data + Hora (mm/yy hh:mm:ss)}
            ValorFormatado := FormatDateTime('mm/yy hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          19: {Data + Hora (mm/yyyy mm:ss}
            ValorFormatado := FormatDateTime('mm/yyyy nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          20: {Data + Hora (mm/yyyy hh:mm)}
            ValorFormatado := FormatDateTime('mm/yyyy hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          21: {Data + Hora (mm/yyyy hh:mm:ss)}
            ValorFormatado := FormatDateTime('mm/yyyy hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          22: {Data + Hora (dd/mm/yy mm:ss}
            ValorFormatado := FormatDateTime('dd/mm/yy nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          23: {Data + Hora (dd/mm/yy hh:mm)}
            ValorFormatado := FormatDateTime('dd/mm/yy hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          24: {Data + Hora (dd/mm/yy hh:mm:ss)}
            ValorFormatado := FormatDateTime('dd/mm/yy hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          25: {Data + Hora (dd/mm/yyyy mm:ss}
            ValorFormatado := FormatDateTime('dd/mm/yyyy nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          26: {Data + Hora (dd/mm/yyyy hh:mm)}
            ValorFormatado := FormatDateTime('dd/mm/yyyy hh:nn',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          27: {Data + Hora (dd/mm/yyyy hh:mm:ss)}
            ValorFormatado := FormatDateTime('dd/mm/yyyy hh:nn:ss',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          28: {Data (yyyy)}
            ValorFormatado := FormatDateTime('yyyy',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          29: {Data (dd)}
            ValorFormatado := FormatDateTime('dd',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);
          30: {Data (mm)}
            ValorFormatado := FormatDateTime('mm',
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsDateTime);

          else
            ValorFormatado :=
              ResultSet.FieldByName(FListaCampos[FPosicao].NomField).AsString;
        end;
        FListaCampos[FPosicao].DataType :=
          ResultSet.FieldByName(FListaCampos[FPosicao].NomField).DataType;
      except
        ValorFormatado := '#CAMPO_INEXISTENTE#';
      end;
      {Distribui um texto de dados em linhas e colunas corretamente, qdo necessário}
      iLinhas := ContarQuebras(ValorFormatado);
      if iLinhas > 1 then begin
        sAux := '';
        for iAux := 0 to iLinhas-1 do begin
          if sAux = '' then begin
            sAux := RedimensionaString(
              ObterLinhaTexto(ValorFormatado, iAux+1),
              FListaCampos[FPosicao].QtdLargura);
          end else begin
            sAux := sAux + #13#10 + RedimensionaString(
              ObterLinhaTexto(ValorFormatado, iAux+1),
              FListaCampos[FPosicao].QtdLargura);
          end;
        end;
      end else begin
        sAux := RedimensionaString(ValorFormatado,
          FListaCampos[FPosicao].QtdLargura);
      end;
      ValorFormatado := sAux;
      {Quando se é definida uma quebra a função oculta a coluna sel. p/ quebra}
      if (FTipo = 1) and FListaCampos[FPosicao].OcultarValorRepetido then begin
        if VarIsEmpty(FListaCampos[FPosicao].ValorAnterior)
          or (FListaCampos[FPosicao].ValorAnterior <> ValorFormatado) then begin
          FListaCampos[FPosicao].ValorAnterior := ValorFormatado;
          FListaCampos[FPosicao].Valor := ValorFormatado;
        end else begin
          FListaCampos[FPosicao].Valor := '';
        end;
      end else begin
        FListaCampos[FPosicao].Valor := ValorFormatado;
      end;
      IrAoProximo;
    end;
  end;
end;

function TCampos.GetBOF: Boolean;
begin
  Result := (FPosicao = 0);
end;

function TCampos.GetEOF: Boolean;
begin
  Result := ((NumCampos = 0) OR FEOF);
end;

function TCampos.GetNumCampos: Integer;
begin
  Result := Length(FListaCampos);
end;

procedure TCampos.IrAoPrimeiro;
begin
  FPosicao := 0;
  FEOF := False;
end;

procedure TCampos.IrAoProximo;
begin
  if not EOF and (Length(FListaCampos)>0) then begin
    if FPosicao + 1 = NumCampos then begin
      FEOF := True;
    end else begin
      Inc(FPosicao);
    end;
  end;
end;

function TCampos.GetCampo: TCampo;
begin
  if (Length(FListaCampos)>0) then begin
    Result := FListaCampos[FPosicao];
  end else begin
    Abort;
  end;
end;

procedure TCampos.SalvarPosicao;
begin
  FSPosicao := FPosicao;
  FSEOF := FEOF;
end;

procedure TCampos.RecuperarPosicao;
begin
  FPosicao := FSPosicao;
  FEOF := FSEOF;
end;

function TCampos.GetValorCampo(NomField: String): Variant;
begin
  Result := '#CAMPO_INEXISTENTE#';
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      Result := FListaCampos[FPosicao].Valor;
      Break;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

procedure TCampos.SetValorCampo(NomField: String; const Value: Variant);
begin
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      FListaCampos[FPosicao].Valor := Value;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

function TCampos.GetValorCampoIdx(Idx: Integer): Variant;
begin
  try
    Result := FListaCampos[Idx].Valor;
  except
    Result := '#INDÍCE_INEXISTENTE#';
  end;
end;

procedure TCampos.SetValorCampoIdx(Idx: Integer; const Value: Variant);
begin
  try
    FListaCampos[Idx].Valor := Value;
  except
    FListaCampos[Idx].Valor := '#ERRO#';
  end;
end;

procedure TCampos.OcultarValoresRepetidos(NomField: String);
begin
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      FListaCampos[FPosicao].OcultarValorRepetido := True;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

procedure TCampos.MostrarValoresOcultos;
begin
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if FListaCampos[FPosicao].OcultarValorRepetido then begin
      FListaCampos[FPosicao].ValorAnterior := Unassigned;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

procedure TCampos.DesabilitarCampo(NomField: String);
begin
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      FListaCampos[FPosicao].Desabilitado := True;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

function TCampos.GetLarguraLinha: Integer;
var
  iAux: Integer;
begin
  Result := 0;
  for iAux := 0 to NumCampos-1 do begin
    if not FListaCampos[iAux].Desabilitado then begin
      if Result = 0 then begin
        Result := FListaCampos[iAux].QtdLargura;
      end else begin
        Result := Result + 1 + FListaCampos[iAux].QtdLargura;
      end;
    end;
  end;
end;

function TCampos.GetTextoTitulo(NomField: String): String;
begin
  Result := '#CAMPO_INEXISTENTE#';
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      Result := FListaCampos[FPosicao].TxtTitulo;
      Break;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

procedure TCampos.SetTextoTitulo(NomField: String; const Value: String);
begin
  SalvarPosicao;
  IrAoPrimeiro;
  while not EOF do begin
    if UpperCase(FListaCampos[FPosicao].NomField) = UpperCase(NomField) then begin
      FListaCampos[FPosicao].TxtTitulo := Value;
      Break;
    end;
    IrAoProximo;
  end;
  RecuperarPosicao;
end;

function TCampos.GetTextoTituloIdx(Idx: Integer): String;
begin
  try
    Result := FListaCampos[Idx].TxtTitulo;
  except
    Result := '#INDÍCE_INEXISTENTE#';
  end;
end;

procedure TCampos.SetTextTituloIdx(Idx: Integer; const Value: String);
begin
  try
    FListaCampos[Idx].TxtTitulo := Value;
  except
    FListaCampos[Idx].TxtTitulo := '#ERRO#';
  end;
end;

procedure TCampos.RecuperarValores;
begin
  if (Length(FListaCampos) > 0) then begin
    IrAoPrimeiro;
    while not EOF do begin
      FListaCampos[FPosicao].Valor := FListaCampos[FPosicao].ValorSalvo;
      IrAoProximo;
    end;
  end;
end;

procedure TCampos.SalvarValores;
begin
  if (Length(FListaCampos) > 0) then begin
    IrAoPrimeiro;
    while not EOF do begin
      FListaCampos[FPosicao].ValorSalvo := FListaCampos[FPosicao].Valor;
      IrAoProximo;
    end;
  end;
end;

{ TIntArquivoSISBOV }

{ Verifica se o arquivo existe e abre o arquivo.

Parametros:
  NomeArquivo: Nome absoluto do arquivo a ser aberto.}
procedure TIntArquivoSISBOV.Abrir(NomeArquivo: String);
const
  NomeMetodo: String = 'Abrir';
begin
  if not FileExists(NomeArquivo) then
  begin
    raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
      ['O arquivo ' + NomeArquivo + ' não existe.'], False);
  end;

  try
    AssignFile(FArquivo, NomeArquivo);
    Reset(FArquivo);
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Adiciona um novo tipo de linha ao leitor de arquivos.

Parametros:
  TipoLinha: Tipo de linha.}
procedure TIntArquivoSISBOV.AddTipoLinha(TipoLinha: TTipoLinhaArquivo);
const
  NomeMetodo: String = 'AddTipoLinha';
var
  I, Posicao: Integer;
begin
  // Obtem a posição do novo registro
  Posicao := Length(FTipos);

  // Verifica se ja não existe um registro com esse tipo de linha
  for I := 0 to Posicao - 1 do
  begin
    if TipoLinha.CodTipoLinha = FTipos[I].CodTipoLinha then
    begin
      raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
        ['Já existe uma linha do tipo ' + IntToStr(TipoLinha.CodTipoLinha)
        + '.'], False);
    end;
  end;

  // Redimenciona o vetor
  SetLength(FTipos, Posicao + 1);

  // Atribui os valores
  FTipos[Posicao].CodTipoLinha := TipoLinha.CodTipoLinha;
  SetLength(FTipos[Posicao].Atributos, Length(TipoLinha.Atributos));
  for I := 0 to Length(TipoLinha.Atributos) - 1 do
  begin
    FTipos[Posicao].Atributos[I].Posicao := TipoLinha.Atributos[I].Posicao;
    FTipos[Posicao].Atributos[I].Tamanho := TipoLinha.Atributos[I].Tamanho;
  end;
end;

{ Construtor da classe. Inicializa as variaveis. }
constructor TIntArquivoSISBOV.Create;
begin
  FLinha := '';
  FIndiceTipoLinhaAtual := -1;
  LimparTiposLinhas;
end;

{ Verifica se é o fim do arquivo.

Retorno:
  True se for o fim do arquivo.
  False se não for.}
function TIntArquivoSISBOV.Eof: Boolean;
begin
  Result := System.Eof(FArquivo);
end;

{ Fecha o arquivo aberto. }
procedure TIntArquivoSISBOV.Fechar;
begin
  CloseFile(FArquivo);
end;

{ Destrutor da classe. Fecha o arquivo e libera a memória armazenada. }
destructor TIntArquivoSISBOV.Free;
begin
  Fechar;
  LimparTiposLinhas;
end;

{ Le a proxima linha do arquivo. }
procedure TIntArquivoSISBOV.LerLinha;
const
  NomeMetodo: String = 'LerLinha';
begin
  // Se estiver no fim do arquivo da uma mensagem de erro.
  if Self.Eof then
  begin
    raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
      ['Fim do arquivo.'], False);
  end;

  // le a linha
  Readln(FArquivo, FLinha);

  // Obtem o tipo de linha do registro
  ObtemIndiceTipoLinhaAtual;
end;

{ Limpa os tipos de linhas definidos. }
procedure TIntArquivoSISBOV.LimparTiposLinhas;
begin
  FIndiceTipoLinhaAtual := -1;
  SetLength(FTipos, 0);
end;

{ Método privado. Obtem o indice no vetor FTipos do tipo da linha a atual.
  Se não existir o tipo de linha na estrutura atribui -1 à variavel interna
  FIndiceTipoLinhaAtual; }
procedure TIntArquivoSISBOV.ObtemIndiceTipoLinhaAtual;
var
  nTipoLinha, Contador: Integer;
begin
  // Inicializa as variaveis
  FIndiceTipoLinhaAtual := -1;
  Contador := 0;

  // Obtem o tipo da linha
  nTipoLinha := TipoLiha;

  // Busca o indice se o tipo de linha existir
  while (FIndiceTipoLinhaAtual = -1) and (Contador < Length(FTipos)) do
  begin
    if FTipos[Contador].CodTipoLinha = nTipoLinha then
    begin
      FIndiceTipoLinhaAtual := Contador;
    end;
    Inc(Contador);
  end;
end;

{ Obtem o tipo da linha atual. }
function TIntArquivoSISBOV.TipoLiha: Integer;
begin
  Result := -1;

  // Verifica se a linha não está vazia
  if FLinha <> '' then
  begin
    Result := StrToInt(Copy(FLinha, 1, 1));
  end;
end;

{ Obtem o valor de um atributo da linha.

Parametros:
  NumAtributo: Número do atributo do tipo de linha atual a ser lido.

Retorno:
  Uma string com o atributo lido.}
function TIntArquivoSISBOV.ValorAtributo(NumAtributo: Integer): String;
const
  NomeMetodo: String = 'ValorAtributo';
begin
  // Verifica se o tipo de linha é válido.
  if FIndiceTipoLinhaAtual = -1 then
  begin
    raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
      ['Tipo de linha desconhecido.'], False);
  end;

  // Verifica se o numero do atributo é válido
  if NumAtributo >= Length(FTipos[FIndiceTipoLinhaAtual].Atributos) then
  begin
    raise EHerdomException.Create(2080, Self.ClassName, NomeMetodo,
      ['Posição do atributo inválida.'], False);
  end;

  // Obtem o valor do atributo
  Result := Copy(FLinha,
    FTipos[FIndiceTipoLinhaAtual].Atributos[NumAtributo].Posicao,
    FTipos[FIndiceTipoLinhaAtual].Atributos[NumAtributo].Tamanho);
end;

initialization
  GetLocaleFormatSettings(cLCIDdBrasil,AjustesdeFormato);
end.
