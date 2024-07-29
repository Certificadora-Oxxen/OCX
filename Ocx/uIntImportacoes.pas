// ****************************************************************************
// *  Projeto            : BoiTata
// *  Sistema            :
// *  Desenvolvedor      :
// *  Versão             : 1
// *  Data               :
// *  Documentação       :
// *  Código Classe      :
// *  Descrição Resumida :
// ****************************************************************************
// *  Últimas Alterações
// *   Fábio    13/04/2004    Alteração do procedimento "TThrProcessarArquivo.Execute"
// *                          para não executar o método "Terminate".
// *
// ****************************************************************************
unit uIntImportacoes;

{$DEFINE MSSQL}

interface

uses Classes, DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas, ActiveX,
     uFerramentas, uArquivo, uIntImportacao, uIntReprodutoresMultiplos,
     uIntAnimais, uIntEventos, uIntInventariosAnimais, uConexao, uIntMensagens, uLibZipM;

type

  TTipoArmazenamento = (taImportacao, taAutenticacao);

  TSQLTxt = record
    TipoLinha: Integer;
    Comentario: String;
    SQL: String;
  end;

  TDadosAnimalComErro = record
    DesApelido: String;
    CodFazendaManejo: Integer;
    SglFazendaManejo: String;
    CodAnimalManejo: String;
    CodAnimalCertificadora: String;
    CodSituacaoSisbov: String;
    CodPaisSisbov: Integer;
    CodEstadoSisbov: Integer;
    CodMicroRegiaoSisbov: Integer;
    CodAnimalSisbov: Integer;
    NumDVSisbov: Integer;
    CodRaca: Integer;
    IndSexo: String;
    CodTipoOrigem: Integer;
    CodCategoriaAnimal: Integer;
    CodLocalCorrente: Integer;
    CodLoteCorrente: Integer;
    CodTipoLugar: Integer;
  end;

  TDadosEventoComErro = record
    CodTipoEvento: Integer;
    DtaInicioEvento: TDateTime;
    DtaFimEvento: TDateTime;
    TxtObservacao: String;
    TxtDados: String;
  end;

  TErroAplicacaoEvento = record
    CodTipoMensagem: Integer;
    TxtMensagem: String;
    DtaAplicacaoEvento: TDateTime;
  end;

  TTipo = record
    CodTipoLinha: Integer;
    QtdLidas: Integer;
    QtdErradas: Integer;
    QtdProcessadas: Integer;
  end;

  { TEventoInserido }
  TEventosInseridos = class(TIntClasseBDNavegacaoBasica)
  private
    FCodPessoaProdutor: Integer;
    FCodArquivoImportacao: Integer;
  public
    constructor Create; override;
    function Adicionar(CodEvento: Integer; SeqEventoInterno: String): Integer;
    function BuscarCodigoEvento(SeqEventoInterno: String;
      var CodEvento: Integer; var DadosEventoComErro: TDadosEventoComErro): Integer;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
  end;

  { TProcessamento }
  TProcessamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipoArmazenamento: TTipoArmazenamento;
    FCodPessoaProdutor: Integer;
    FCodArquivoImportacao: Integer;
  public
    constructor Create; override;
    function IncLidas(CodTipoLinhaImportacao: Integer): Integer;
    function IncErradas(CodTipoLinhaImportacao: Integer): Integer;
    function IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
    property TipoArmazenamento: TTipoArmazenamento read FTipoArmazenamento write FTipoArmazenamento;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
  end;

  { TArmazenamento }
  TArmazenamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipoArmazenamento: TTipoArmazenamento;
    FTipos: Array of TTipo;
    FCodPessoaProdutor: Integer;
    FCodArquivoImportacao: Integer;
    function GetQtdLinhasLidas(TipoLinhaImportacao: Integer): Integer;
  public
    constructor Create; override;
    procedure IncLidas(CodTipoLinhaImportacao: Integer);
    function Salvar: Integer;
    property TipoArmazenamento: TTipoArmazenamento read FTipoArmazenamento write FTipoArmazenamento;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
    property QtdLinhasLidas[TipoLinhaImportacao: Integer]: Integer read GetQtdLinhasLidas;
  end;

  { TThrProcessarArquivo }
  TThrProcessarArquivo = class(TThread)
  private
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FCodArquivoImportacao: Integer;
    FLinhaInicial: Integer;
    FTempoMaximo: Integer;
    FCodTarefa: Integer;

    function ConsistirFazenda(SglFazenda: String;
      var CodFazenda: Integer): Integer; overload;

    function ConsistirFazenda(SglFazenda: String;
      var CodFazenda, CodPropriedadeRural: Integer): Integer; overload;

    function ConsistirRaca(CodRaca: Integer; var CodEspecie: Integer): Integer;

    function ConsistirLocal(CodFazenda: Integer; SglLocal: String;
      var CodLocal: Integer): Integer;

    function ConsistirLote(CodFazenda: Integer; SglLote: String;
      var CodLote: Integer): Integer;

    function ConsistirAnimal(SglFazendaManejo, CodAnimalManejo: String;
      var CodAnimal: Integer;
      var DadosAnimalComErro: TDadosAnimalComErro): Integer;

    function ConsistirRM(SglFazendaManejo, CodReprodutorMultiploManejo: String;
      var CodReprodutorMultiplo: Integer): Integer;

    function ConsistirAnimalouRM(SglFazendaManejo,
      CodAnimalManejo: String; var CodAnimal, CodReprodutorMultiplo: Integer;
      var DadosAnimalComErro: TDadosAnimalComErro): Integer;

    function ConsistirPessoaSecundaria(NumCNPJCPF: String;
      var CodPessoaSecundaria: Integer; CodPapelSecundario: Integer): Integer;

    function ConsistirEstacaoMonta(SglEstacaoMonta: String;
      var CodEventoEstacaoMonta: Integer): Integer;

    function ConsistirTipoAvaliacao(ESglTipoAvaliacao: String;
      var ECodTipoAvaliacao: Integer): Integer;

    function ConsistirTipoCaracteristica(ECodTipoAvaliacao: Integer;
                                         ESglTipoCaracteristica: String;
                                         var ECodTipoCaracteristica: Integer): Integer;

    procedure LimparDadosAnimalComErro(
      var DadosAnimalComErro: TDadosAnimalComErro);

    procedure LimparDadosEventoComErro(
      var DadosEventoComErro: TDadosEventoComErro);

    function GetRetorno: Integer;
  protected
    procedure Execute; override;
  public
    constructor CreateTarefa(CodTarefa: Integer; Conexao: TConexao;
      Mensagens: TIntMensagens; CodArquivoImportacao, LinhaInicial,
      TempoMaximo: Integer);
    property CodTarefa: Integer read FCodTarefa;
    property Retorno: Integer read GetRetorno;
    property Conexao: TConexao read FConexao;
    property Mensagens: TIntMensagens read FMensagens;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao;
    property LinhaInicial: Integer read FLinhaInicial;
    property TempoMaximo: Integer read FTempoMaximo;
  end;

  { TIntImportacoes }
  TIntImportacoes = class(TIntClasseBDNavegacaoBasica)
  private
    FIntImportacao : TIntImportacao;
    FProcesso: TThrProcessarArquivo;
    function ObterCodArquivoImportacao(var CodArquivoImportacao: Integer): Integer;
    function ObterCodArquivoAutenticacao(var CodArquivoImportacao: Integer): Integer;

    function InserirArquivoImportacao(CodPessoaProdutor,
     CodArquivoImportacao:Integer; NomArquivoImportacao, NomArquivoUpload,CodSituacaoArqImport,TxtMensagem:String;
       CodTipoOrigemArqImport: Integer): Integer;


    function InserirArquivoAutenticacao(CodArquivoImportacao: Integer;
      NomArquivoImportacao, NomArquivoUpload: String): Integer;
    function ValidarProdutorUsuario(CodPessoaProdutor: Integer): Integer;

    function AtualizarTarefa(ECodArquivoImportacao, ECodTarefa: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ArmazenarArquivoUpload(CodTipoOrigemArqImport: Integer; NomArquivoUpload: String): Integer;
    function ArmazenarArquivoAutenticacao(NomArquivoUpload: String): Integer;
    function Buscar(CodArquivoImportacao: Integer): Integer;
    function BuscarAutenticacao(CodArquivoImportacao: Integer): Integer;
    function GerarArquivoParametro: Integer;

    class function ValidarNIRFIdentificacao(EConexao: TConexao; EMensagem: TIntMensagens;
      ENumImovelReceitaFederal: String; ECodPropriedadeRural, ECodLocalizacaoSisbov,
      ECodPessoaProdutor: Integer; IndVerificaEfetivado: Boolean): Integer;

    class function ValidarNIRFNascimento(EConexao: TConexao; EMensagem: TIntMensagens;
      ENumImovelReceitaFederal: String; ECodPropriedadeRural, ECodLocalizacaoSisbov,
      ECodPessoaProdutor: Integer; IndVerificaEfetivado: Boolean): Integer;

    function Pesquisar(NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
    NomUsuarioUpload: String; CodTipoOrigemArqImport: Integer; CodSituacaoArqImport: String; DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim: TDateTime): Integer;

    function PesquisarAutenticacao(DtaImportacaoInicio, DtaImportacaoFim,
      DtaUltimoProcessamentoInicio, DtaUltimoProcessamentoFim: TDateTime;
      LoginUsuario, IndErrosNoProcessamento,
      IndArquivoProcessado: String): Integer;
    function Excluir(CodArquivoImportacao: Integer): Integer;
    function ExcluirAutenticacao(CodArquivoImportacao: Integer): Integer;
    function ProcessarArquivo(CodArquivoImportacao, LinhaInicial,
      TempoMaximo: Integer): Integer;
    function ProcessarAutenticacao(CodArquivoImportacao: Integer): Integer;
    function PesquisarOcorrenciasProcessamento(CodArquivoImportacao,
      CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer;
    function PesquisarOcorrenciasAutenticacao(CodArquivoImportacao,
      CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer;
    function PesquisarTipoArquivoImportacaoSisBov: Integer;
    property IntImportacao: TIntImportacao read FIntImportacao write FIntImportacao;
  end;

  { Funções genéricas às classes }
  function ObterDadosCertificadora(var NomCertificadora,
    NumCNPJCertificadora: String; AOwner: TObject): Integer;
  function ValidarCertificadora(NumCNPJ: String; AOwner: TObject): Integer;
  function ValidarProdutor(Natureza, NumCNPJCPF: String;
    var CodPessoaProdutor: Integer; AOwner: TObject): Integer;
  procedure InterpretaLinhaArquivoAutenticacao(
    Owner: TArquivoPosicionalLeitura);

const
  RetornoSucesso: Integer = 10000;

implementation

uses uIntPropriedadesRurais, StrUtils, SqlExpr;

{ Funções genéricas às classes }

function ObterDadosCertificadora(var NomCertificadora,
  NumCNPJCertificadora: String; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ObterDadosCertificadora';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoes) then begin
    Conexao := TIntImportacoes(AOwner).Conexao;
    Mensagens := TIntImportacoes(AOwner).Mensagens;
  end else if (AOwner is TThrProcessarArquivo) then begin
    Conexao := TThrProcessarArquivo(AOwner).Conexao;
    Mensagens := TThrProcessarArquivo(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'select '+
        '  tp.nom_pessoa as NomCertificadora '+
        '  , num_cnpj_cpf as NumCNPJCertificadora '+
        'from '+
        '  tab_pessoa tp '+
        '  , tab_parametro_sistema tps '+
        'where '+
{$IFDEF MSSQL}
        '  tp.cod_pessoa = CAST(tps.val_parametro_sistema AS int) '+
{$ENDIF}
        '  and tps.cod_parametro_sistema = 4 ';
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1210, AOwner.ClassName, NomeMetodo, []);
        Result := -1210;
        Exit;
      end;
      NomCertificadora := Q.FieldByName('NomCertificadora').AsString;
      NumCNPJCertificadora := Q.FieldByName('NumCNPJCertificadora').AsString;
      Q.Close;
      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1211, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1211;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function ValidarCertificadora(NumCNPJ: String; AOwner: TObject): Integer;
var
  NomCertificadora, NumCNPJCertificadora: String;
begin
  Result := ObterDadosCertificadora(NomCertificadora, NumCNPJCertificadora,
    AOwner);
  if Result < 0 then Exit;
  if NumCNPJ = NumCNPJCertificadora then begin
    Result := 1; {Certificadora identificada}
  end else begin
    Result := 0; {Certificadora não identificada}
  end;
end;

function ValidarProdutor(Natureza, NumCNPJCPF: String;
  var CodPessoaProdutor: Integer; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ValidarProdutor';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoes) then begin
    Conexao := TIntImportacoes(AOwner).Conexao;
    Mensagens := TIntImportacoes(AOwner).Mensagens;
  end else if (AOwner is TThrProcessarArquivo) then begin
    Conexao := TThrProcessarArquivo(AOwner).Conexao;
    Mensagens := TThrProcessarArquivo(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'select '+
        '  tpr.cod_pessoa_produtor as CodPessoaProdutor '+
        'from '+
        '  tab_pessoa tp '+
        '  , tab_pessoa_papel tpp '+
        '  , tab_produtor tpr '+
        'where '+
        '  tpr.dta_fim_validade is null '+
        '  and tpr.cod_pessoa_produtor = tp.cod_pessoa '+
        '  and tpp.dta_fim_validade is null '+
        '  and tpp.cod_papel = 4 '+
        '  and tpp.cod_pessoa = tp.cod_pessoa '+
        '  and tp.dta_fim_validade is null '+
        '  and tp.cod_natureza_pessoa = :cod_natureza_pessoa '+
        '  and tp.num_cnpj_cpf = :num_cnpj_cpf ';
      Q.ParamByName('cod_natureza_pessoa').AsString := Natureza;
      Q.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPF;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        CodPessoaProdutor := Q.FieldByName('CodPessoaProdutor').AsInteger;
        Result := 1;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1225, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1225;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{ TEventoInserido }

constructor TEventosInseridos.Create;
begin
  inherited;
  FCodPessoaProdutor := -1;
  FCodArquivoImportacao := -1;
end;

function TEventosInseridos.Adicionar(CodEvento: Integer;
  SeqEventoInterno: String): Integer;
const
  NomeMetodo: String = 'Adicionar';
begin
  if (FCodPessoaProdutor = -1) or (FCodArquivoImportacao = -1) then begin
    Raise Exception.Create('Produtor ou arquivo não definido(s)!');
  end;
  try
    // Consiste se o identificado é único entre os eventos já inserido para
    // o arquivo de importação
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  1 '+
      'from '+
      '  tab_evento_arquivo_importacao '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and seq_evento_arquivo = :seq_evento_arquivo ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('seq_evento_arquivo').AsString := SeqEventoInterno;
    Query.Open;
    if not Query.IsEmpty then begin
      Mensagens.Adicionar(1313, Self.ClassName, NomeMetodo, [SeqEventoInterno]);
      Result := -1313;
      Exit;
    end;

    // Insere o registro relacionando o identificador interno do evento no arquivo
    // com o evento real inserido no sistema
    Query.Close;
    Query.SQL.Text :=
      'insert into tab_evento_arquivo_importacao '+
      ' (cod_pessoa_produtor '+
      '  , cod_arquivo_importacao '+
      '  , seq_evento_arquivo '+
      '  , cod_evento) '+
      'values '+
      ' (:cod_pessoa_produtor '+
      '  , :cod_arquivo_importacao '+
      '  , :seq_evento_arquivo '+
      '  , :cod_evento ) ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('seq_evento_arquivo').AsString := SeqEventoInterno;
    Query.ParamByName('cod_evento').AsInteger := CodEvento;
    Query.ExecSQL;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Mensagens.Adicionar(1314, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1314;
      Exit;
    end;
  end;
end;

function TEventosInseridos.BuscarCodigoEvento(SeqEventoInterno: String;
  var CodEvento: Integer; var DadosEventoComErro: TDadosEventoComErro): Integer;
const
  NomeMetodo: String = 'BuscarCodEvento';
begin
  if (FCodPessoaProdutor = -1) or (FCodArquivoImportacao = -1) then begin
    Raise Exception.Create('Produtor ou arquivo não definido(s)!');
  end;
  try
    // Busca código do evento no sistema relacionado com o identificador informado
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  teai.cod_evento as CodEvento '+
      '  , te.cod_tipo_evento as CodTipoEvento '+
      '  , te.dta_inicio as DtaInicio '+
      '  , te.dta_fim as DtaFim '+
      '  , te.txt_observacao as TxtObservacao '+
      '  , te.txt_dados as TxtDados '+
      'from '+
      '  tab_evento_arquivo_importacao teai '+
      '  , tab_evento te '+
      'where '+
      '  te.cod_pessoa_produtor = teai.cod_pessoa_produtor '+
      '  and te.cod_evento = teai.cod_evento '+
      '  and teai.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and teai.cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and teai.seq_evento_arquivo = :seq_evento_arquivo ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('seq_evento_arquivo').AsString := SeqEventoInterno;
    Query.Open;
    if Query.IsEmpty then begin
      Mensagens.Adicionar(1315, Self.ClassName, NomeMetodo, [SeqEventoInterno]);
      Result := -1315;
      Exit;
    end;

    // Retorna o código interno do evento identificado
    CodEvento := Query.FieldByName('CodEvento').AsInteger;
    DadosEventoComErro.CodTipoEvento := Query.FieldByName('CodTipoEvento').AsInteger;
    DadosEventoComErro.DtaInicioEvento := Query.FieldByName('DtaInicio').AsDateTime;
    DadosEventoComErro.DtaFimEvento := Query.FieldByName('DtaFim').AsDateTime;
    DadosEventoComErro.TxtObservacao := Query.FieldByName('TxtObservacao').AsString;
    DadosEventoComErro.TxtDados := Query.FieldByName('TxtDados').AsString;
    Query.Close;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Mensagens.Adicionar(1316, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1316;
      Exit;
    end;
  end;
end;

{ TProcessamento }

constructor TProcessamento.Create;
begin
  inherited;
  FTipoArmazenamento := taImportacao;
end;

function TProcessamento.IncLidas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncLidas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  try
    // Verifica a existência do registro na base
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_total as QtdTotal '+
        'from '+
        '  tab_quantidade_tipo_linha '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_total as QtdTotal '+
        'from '+
        '  tab_quantidade_tipo_linha_aut '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdTotal').AsInteger;

    if Query.IsEmpty then begin
      // É a primeira linha deste tipo
      Query.Close;
      if FTipoArmazenamento = taImportacao then begin
        Query.SQL.Text :=
          'insert into tab_quantidade_tipo_linha '+
          ' (cod_pessoa_produtor, '+
          '  cod_arquivo_importacao, '+
          '  cod_tipo_linha_importacao, '+
          '  qtd_total, '+
          '  qtd_processadas) '+
          'values '+
          ' (:cod_pessoa_produtor, '+
          '  :cod_arquivo_importacao, '+
          '  :cod_tipo_linha_importacao, '+
          '  :qtd_total, '+
          '  0) ';
      end else if FTipoArmazenamento = taAutenticacao then begin
        Query.SQL.Text :=
          'insert into tab_quantidade_tipo_linha_aut '+
          ' (cod_arquivo_importacao, '+
          '  cod_tipo_linha_importacao, '+
          '  qtd_total, '+
          '  qtd_processadas) '+
          'values '+
          ' (:cod_arquivo_importacao, '+
          '  :cod_tipo_linha_importacao, '+
          '  :qtd_total, '+
          '  0) ';
      end;
    end else begin
      // Incrementa o totalizador atual
      Query.Close;
      if FTipoArmazenamento = taImportacao then begin
        Query.SQL.Text :=
          'update '+
          '  tab_quantidade_tipo_linha '+
          'set '+
          '  qtd_total = :qtd_total '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
          '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      end else if FTipoArmazenamento = taAutenticacao then begin
        Query.SQL.Text :=
          'update '+
          '  tab_quantidade_tipo_linha_aut '+
          'set '+
          '  qtd_total = :qtd_total '+
          'where '+
          '  cod_arquivo_importacao = :cod_arquivo_importacao '+
          '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      end;
    end;

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_total').AsInteger := iAux;
    if FTipoArmazenamento = taImportacao then begin
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1226, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1226;
      Exit;
    end;
  end;
end;

function TProcessamento.IncErradas(
  CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncErradas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  try
    // Verifica a existência do registro na base
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_erradas as QtdErradas '+
        'from '+
        '  tab_quantidade_tipo_linha '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_erradas as QtdErradas '+
        'from '+
        '  tab_quantidade_tipo_linha_aut '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdErradas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text :=
        'update '+
        '  tab_quantidade_tipo_linha '+
        'set '+
        '  qtd_erradas = :qtd_erradas '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text :=
        'update '+
        '  tab_quantidade_tipo_linha_aut '+
        'set '+
        '  qtd_erradas = :qtd_erradas '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end;

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_erradas').AsInteger := iAux;
    if FTipoArmazenamento = taImportacao then begin
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1346, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1346;
      Exit;
    end;
  end;
end;

function TProcessamento.IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncProcessadas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  try
    // Verifica a existência do registro na base
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_processadas as QtdProcessadas '+
        'from '+
        '  tab_quantidade_tipo_linha '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text :=
        'select '+
        '  qtd_processadas as QtdProcessadas '+
        'from '+
        '  tab_quantidade_tipo_linha_aut '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdProcessadas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text :=
        'update '+
        '  tab_quantidade_tipo_linha '+
        'set '+
        '  qtd_processadas = :qtd_processadas '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text :=
        'update '+
        '  tab_quantidade_tipo_linha_aut '+
        'set '+
        '  qtd_processadas = :qtd_processadas '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
    end;

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_processadas').AsInteger := iAux;
    if FTipoArmazenamento = taImportacao then begin
      Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
    end;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1227, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1227;
      Exit;
    end;
  end;
end;

{ TArmazenamento }

constructor TArmazenamento.Create;
begin
  inherited;
  FTipoArmazenamento := taImportacao;
end;

function TArmazenamento.GetQtdLinhasLidas(
  TipoLinhaImportacao: Integer): Integer;
var
  iAux: Integer;
  iFound: Integer;
begin
  iFound := -1;
  for iAux := 0 to Length(FTipos)-1 do begin
    if FTipos[iAux].CodTipoLinha = TipoLinhaImportacao then begin
      iFound := iAux;
      Break;
    end;
  end;
  if iFound = -1 then begin
    Result := 0;
  end else begin
    Result := FTipos[iFound].QtdLidas;
  end;
end;

procedure TArmazenamento.IncLidas(CodTipoLinhaImportacao: Integer);
var
  iAux: Integer;
  iFound: Integer;
begin
  iFound := -1;
  for iAux := 0 to Length(FTipos)-1 do begin
    if FTipos[iAux].CodTipoLinha = CodTipoLinhaImportacao then begin
      iFound := iAux;
      Break;
    end;
  end;
  if iFound = -1 then begin
    iFound := Length(FTipos);
    SetLength(FTipos, iFound+1);
    FTipos[iFound].CodTipoLinha := CodTipoLinhaImportacao;
    FTipos[iFound].QtdLidas := 1;
    FTipos[iFound].QtdErradas := 0;
    FTipos[iFound].QtdProcessadas := 0;
  end else begin
    Inc(FTipos[iFound].QtdLidas);
  end;
end;

function TArmazenamento.Salvar: Integer;
const
  NomeMetodo: String = 'Salvar';
  SelectImportacao: String =
    ' select 1 as cod_tipo_linha_importacao '+
    '  from tab_tipo_linha_importacao ' +
    '  Where cod_tipo_linha_importacao = :CodTipoLinhaImportacao ';
  InsertImportacao: String =
    'insert into tab_quantidade_tipo_linha '+
    ' (cod_pessoa_produtor, '+
    '  cod_arquivo_importacao, '+
    '  cod_tipo_linha_importacao, '+
    '  qtd_total, '+
    '  qtd_erradas, '+
    '  qtd_processadas) '+
    'values '+
    ' (:cod_pessoa_produtor, '+
    '  :cod_arquivo_importacao, '+
    '  :cod_tipo_linha_importacao, '+
    '  :qtd_total, '+
    '  :qtd_erradas, '+
    '  :qtd_processadas) ';
  InsertAutenticacao: String =
    'insert into tab_quantidade_tipo_linha_aut '+
    ' (cod_arquivo_importacao, '+
    '  cod_tipo_linha_importacao, '+
    '  qtd_total, '+
    '  qtd_erradas, '+
    '  qtd_processadas) '+
    'values '+
    ' (:cod_arquivo_importacao, '+
    '  :cod_tipo_linha_importacao, '+
    '  :qtd_total, '+
    '  :qtd_erradas, '+
    '  :qtd_processadas) ';
var
  iAux: Integer;
begin
  try
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text := SelectImportacao;
      // Valida os tipos de registros encontrados no arquivo antes de atualizar as quantidades.
      for iAux := 0 to Length(FTipos)-1 do begin
        Query.Close;
        Query.ParamByName('CodTipoLinhaImportacao').AsInteger := FTipos[iAux].CodTipoLinha;
        Query.Open;
        if Query.fieldByName('cod_tipo_linha_importacao').AsInteger <> 1 then
        begin
          Mensagens.Adicionar(1680, Self.ClassName, NomeMetodo, [FTipos[iAux].CodTipoLinha]);
          Result := -1680;
          Exit;
        end;
      end;
      Query.SQL.Text := InsertImportacao;
    end else if FTipoArmazenamento = taAutenticacao then begin
      Query.SQL.Text := InsertAutenticacao;
    end;

    for iAux := 0 to Length(FTipos)-1 do begin
      Query.ParamByName('qtd_total').AsInteger := FTipos[iAux].QtdLidas;
      Query.ParamByName('qtd_erradas').AsInteger := FTipos[iAux].QtdErradas;
      Query.ParamByName('qtd_processadas').AsInteger := FTipos[iAux].QtdProcessadas;
      if FTipoArmazenamento = taImportacao then begin
        Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
      end;
      Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArquivoImportacao;
      Query.ParamByName('cod_tipo_linha_importacao').AsInteger := FTipos[iAux].CodTipoLinha;
      Query.ExecSQL;
    end;
    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1322, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1322;
      Exit;
    end;
  end;
end;

{ TIntImportacoes }

constructor TIntImportacoes.Create;
begin
  inherited;
  FIntImportacao := TIntImportacao.Create;
end;

destructor TIntImportacoes.Destroy;
begin
  FIntImportacao.Free;
  inherited;
end;

function TIntImportacoes.ObterCodArquivoImportacao(
  var CodArquivoImportacao: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArquivoImportacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arquivo_importacao), 0) + 1 as CodSeqArquivoImportacao from tab_seq_arquivo_importacao ');
      {$ENDIF}
      Q.Open;

      CodArquivoImportacao := Q.FieldByName('CodSeqArquivoImportacao').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arquivo_importacao set cod_seq_arquivo_importacao = cod_seq_arquivo_importacao + 1');
      {$ENDIF}
      Q.ExecSQL;


      Q.Close;

      // Fecha a transação
      Commit;
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1229, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1229;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ObterCodArquivoAutenticacao(var CodArquivoImportacao: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArquivoAutenticacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
{$IFDEF MSSQL}
        '  isnull(max(cod_arquivo_importacao), 0)+1 as CodArquivoImportacao '+
{$ENDIF}
        'from '+
        '  tab_arquivo_autenticacao ';
      Q.Open;
      CodArquivoImportacao := Q.FieldByName('CodArquivoImportacao').AsInteger;
      Q.Close;
      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1229, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1229;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.InserirArquivoImportacao(CodPessoaProdutor,
     CodArquivoImportacao:Integer; NomArquivoImportacao, NomArquivoUpload,CodSituacaoArqImport,TxtMensagem:String;
       CodTipoOrigemArqImport: Integer): Integer;
const
  NomeMetodo: String = 'InserirArquivoImportacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'insert into tab_arquivo_importacao '+
        ' (cod_pessoa_produtor '+
        '  , cod_arquivo_importacao '+
        '  , nom_arquivo_importacao '+
        '  , nom_arquivo_upload '+
        '  , cod_usuario_upload '+
        '  , dta_importacao '+
        '  , qtd_vezes_processamento '+
        '  , dta_ultimo_processamento '+
        '  , cod_tipo_origem_arq_import '+
        '  , cod_situacao_arq_import '+
        '  , txt_mensagem ) '+
        'values '+
        ' (:cod_pessoa_produtor '+
        '  , :cod_arquivo_importacao '+
        '  , :nom_arquivo_importacao '+
        '  , :nom_arquivo_upload '+
        '  , :cod_usuario_upload '+
{$IFDEF MSSQL}
        '  , getdate() '+
{$ENDIF}
        '  , 0 '+
        '  , null ' +
        '  , :cod_tipo_origem_arq_import '+
        '  , :cod_situacao_arq_import '+
        '  , :txt_mensagem ) ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('nom_arquivo_importacao').AsString := NomArquivoImportacao;
      Q.ParamByName('nom_arquivo_upload').AsString := NomArquivoUpload;
      Q.ParamByName('cod_usuario_upload').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
      Q.ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
      Q.ParamByName('txt_mensagem').AsString := TxtMensagem;
      Q.ExecSQL;
      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1230, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1230;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.InserirArquivoAutenticacao(CodArquivoImportacao: Integer;
  NomArquivoImportacao, NomArquivoUpload: String): Integer;
const
  NomeMetodo: String = 'InserirArquivoAutenticacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'insert into tab_arquivo_autenticacao '+
        ' (cod_arquivo_importacao '+
        '  , nom_arquivo_upload '+
        '  , nom_arquivo_importacao '+
        '  , cod_usuario '+
        '  , dta_importacao '+
        '  , qtd_vezes_processamento '+
        '  , dta_ultimo_processamento) '+
        'values '+
        ' (:cod_arquivo_importacao '+
        '  , :nom_arquivo_upload '+
        '  , :nom_arquivo_importacao '+
        '  , :cod_usuario '+
{$IFDEF MSSQL}
        '  , getdate() '+
{$ENDIF}
        '  , 0 '+
        '  , null) ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('nom_arquivo_upload').AsString := NomArquivoUpload;
      Q.ParamByName('nom_arquivo_importacao').AsString := NomArquivoImportacao;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;
      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1230, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1230;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ValidarProdutorUsuario(
  CodPessoaProdutor: Integer): Integer;
const
  NomeMetodo: String = 'ValidarProdutorUsuario';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  1 '+
        'from '+
        '  tab_produtor tp ';
      if Conexao.CodPapelUsuario = 1 then begin // Associação
        Q.SQL.Text := Q.SQL.Text +
          '  , tab_associacao_produtor tap ';
      end else if Conexao.CodPapelUsuario = 3 then begin // Tecnico
        Q.SQL.Text := Q.SQL.Text +
          '  , tab_tecnico_produtor ttp ';
      end;
      Q.SQL.Text := Q.SQL.Text +
        'where '+
        '  tp.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and tp.dta_fim_validade is null ';
      if Conexao.CodPapelUsuario = 1 then begin // Associação
        Q.SQL.Text := Q.SQL.Text +
          '  and tap.cod_pessoa_produtor = tp.cod_pessoa_produtor '+
          '  and tap.cod_pessoa_associacao = :cod_pessoa_usuario ';
      end else if Conexao.CodPapelUsuario = 3 then begin // Tecnico
        Q.SQL.Text := Q.SQL.Text +
          '  and ttp.cod_pessoa_produtor = tp.cod_pessoa_produtor '+
          '  and ttp.cod_pessoa_tecnico = :cod_pessoa_usuario '+
          '  and ttp.dta_fim_validade is null ';
      end else if Conexao.CodPapelUsuario = 4 then begin // Produtor
        Q.SQL.Text := Q.SQL.Text +
          '  and tp.cod_pessoa_produtor = :cod_pessoa_usuario ';
      end;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      if Conexao.CodPapelUsuario in [1, 3, 4] then begin
        Q.ParamByName('cod_pessoa_usuario').AsInteger := Conexao.CodPessoa;
      end;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        Result := 1;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1245, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1245;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.GerarArquivoParametro: Integer;
const
  Metodo: Integer = 382;
  NomeMetodo: String = 'GerarArquivoParametro';
  cDados: Array [0..24] of TSQLTxt = (
    (TipoLinha: 1;
     Comentario: 'Situações SISBOV';
     SQL: 'select '+
          '  cod_situacao_sisbov '+
          '  , des_situacao_sisbov '+
          '  , txt_situacao_sisbov '+
          'from '+
          '  tab_situacao_sisbov '+
          'order by '+
          '  num_ordem '),

    (TipoLinha: 2;
     Comentario: 'Associações de Raça';
     SQL: 'select '+
          '  cod_associacao_raca '+
          '  , sgl_associacao_raca '+
          '  , nom_associacao_raca '+
          'from '+
          '  tab_associacao_raca '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  nom_associacao_raca '),

    (TipoLinha: 3;
     Comentario: 'Graus de sangues de Animais';
     SQL: 'select '+
          '  cod_grau_sangue '+
          '  , sgl_grau_sangue '+
          '  , des_grau_sangue '+
          'from '+
          '  tab_grau_sangue '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '   des_grau_sangue '),

    (TipoLinha: 4;
     Comentario: 'Relacionamento entre Graus de Sangue e Associações de Raça';
     SQL: 'select '+
          '  targs.cod_associacao_raca '+
          '  , targs.cod_grau_sangue '+
          'from '+
          '  tab_assoc_raca_grau_sangue targs '+
          '  , tab_associacao_raca tar '+
          '  , tab_grau_sangue tgs '+
          'where '+
          '  tar.cod_associacao_raca = targs.cod_associacao_raca '+
          '  and tgs.cod_grau_sangue = targs.cod_grau_sangue '+
          '  and tar.dta_fim_validade is null '+
          '  and tgs.dta_fim_validade is null '+
          'order by '+
          '   tar.nom_associacao_raca '+
          '   , tgs.des_grau_sangue '),

    (TipoLinha: 5;
     Comentario: 'Tipos de Identificadores';
     SQL: 'select '+
          '  cod_tipo_identificador '+
          '  , sgl_tipo_identificador '+
          '  , des_tipo_identificador '+
          '  , ind_transponder '+
          '  , ind_brinco '+
          '  , cod_grupo_identificador '+
          'from '+
          '  tab_tipo_identificador '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_tipo_identificador '),

    (TipoLinha: 6;
     Comentario: 'Posições de Identificadores';
     SQL: 'select '+
          '  cod_posicao_identificador '+
          '  , sgl_posicao_identificador '+
          '  , des_posicao_identificador '+
          'from '+
          '  tab_posicao_identificador '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_posicao_identificador '),

    (TipoLinha: 7;
     Comentario: 'Tipos de Lugares';
     SQL: 'select '+
          '  cod_tipo_lugar '+
          '  , sgl_tipo_lugar '+
          '  , des_tipo_lugar '+
          'from '+
          '  tab_tipo_lugar '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_tipo_lugar '),

    (TipoLinha: 8;
     Comentario: 'Espécies';
     SQL: 'select '+
          '  cod_especie '+
          '  , sgl_especie '+
          '  , des_especie '+
          '  , cod_especie_sisbov '+
          'from '+
          '  tab_especie '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_especie '),

    (TipoLinha: 9;
     Comentario: 'Aptidões';
     SQL: 'select '+
          '  cod_aptidao '+
          '  , sgl_aptidao '+
          '  , des_aptidao '+
          '  , cod_aptidao_sisbov '+
          'from '+
          '  tab_aptidao '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_aptidao '),

    (TipoLinha: 10;
     Comentario: 'Raças';
     SQL: 'select '+
          '  cod_raca '+
          '  , sgl_raca '+
          '  , des_raca '+
          '  , ind_raca_pura '+
          '  , cod_especie '+
          '  , ind_default_produtor '+
          '  , cod_raca_sisbov '+
          '  , qtd_peso_padrao_nascimento '+
          'from '+
          '  tab_raca '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_raca '),

    (TipoLinha: 11;
     Comentario: 'Relacionamento de Raças e Aptidões';
     SQL: 'select '+
          '  tra.cod_raca '+
          '  , tra.cod_aptidao '+
          'from '+
          '  tab_raca_aptidao tra '+
          '  , tab_raca tr '+
          '  , tab_aptidao ta '+
          'where '+
          '  tr.cod_raca = tra.cod_raca '+
          '  and ta.cod_aptidao = tra.cod_aptidao '+
          '  and tr.dta_fim_validade is null '+
          '  and ta.dta_fim_validade is null '+
          'order by '+
          '  tr.des_raca '+
          '  , ta.des_aptidao '),

    (TipoLinha: 12;
     Comentario: 'Pelagens';
     SQL: 'select '+
          '  cod_pelagem '+
          '  , sgl_pelagem '+
          '  , des_pelagem '+
          'from '+
          '  tab_pelagem '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_pelagem '),

    (TipoLinha: 13;
     Comentario: 'Tipos de origens';
     SQL: 'select '+
          '  cod_tipo_origem '+
          '  , sgl_tipo_origem '+
          '  , des_tipo_origem '+
          'from '+
          '  tab_tipo_origem '+
          'where dta_fim_validade is null '+
          '  and cod_tipo_origem <> 6 '+
          'order by '+
          '  des_tipo_origem '),

    (TipoLinha: 14;
     Comentario: 'Regimes Alimentares';
     SQL: 'select '+
          '  cod_regime_alimentar '+
          '  , sgl_regime_alimentar '+
          '  , des_regime_alimentar '+
          '  , ind_animal_mamando '+
          'from '+
          '  tab_regime_alimentar '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_regime_alimentar '),

    (TipoLinha: 15;
     Comentario: 'Relacionamento entre Regimes Alimentares e Aptidões';
     SQL: 'select '+
          '  traa.cod_regime_alimentar '+
          '  , traa.cod_aptidao '+
          'from '+
          '  tab_regime_alimentar_aptidao traa '+
          '  , tab_regime_alimentar tra '+
          '  , tab_aptidao ta '+
          'where '+
          '  tra.cod_regime_alimentar = traa.cod_regime_alimentar '+
          '  and ta.cod_aptidao = traa.cod_aptidao '+
          '  and tra.dta_fim_validade is null '+
          '  and ta.dta_fim_validade is null '+
          'order by '+
          '  tra.des_regime_alimentar '+
          '  , ta.des_aptidao '),

    (TipoLinha: 16;
     Comentario: 'Categorias de Animais';
     SQL: 'select '+
          '  cod_categoria_animal '+
          '  , sgl_categoria_animal '+
          '  , des_categoria_animal '+
          '  , ind_sexo '+
          '  , num_idade_minima '+
          '  , num_idade_maxima '+
          '  , ind_animal_ativo '+
          '  , ind_animal_castrado '+
          '  , ind_restrito_sistema '+
          'from '+
          '  tab_categoria_animal '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_categoria_animal '),

    (TipoLinha: 17;
     Comentario: 'Relacionamento entre Categorias de Animais e Aptidões';
     SQL: 'select '+
          '  tcaa.cod_categoria_animal '+
          '  , tcaa.cod_aptidao '+
          'from '+
          '  tab_categoria_animal_aptidao tcaa '+
          '  , tab_categoria_animal tca '+
          '  , tab_aptidao ta '+
          'where '+
          '  tca.cod_categoria_animal = tcaa.cod_categoria_animal '+
          '  and ta.cod_aptidao = tcaa.cod_aptidao '+
          '  and tca.dta_fim_validade is null '+
          '  and ta.dta_fim_validade is null '+
          'order by '+
          '  tca.des_categoria_animal '+
          '  , ta.des_aptidao '),

    (TipoLinha: 18;
     Comentario: 'Tipos de Eventos';
     SQL: 'select '+
          '  cod_tipo_evento '+
          '  , sgl_tipo_evento '+
          '  , des_tipo_evento '+
          '  , cod_grupo_evento '+
          '  , ind_evento_sisbov '+
          'from '+
          '  tab_tipo_evento '+
          'where '+
          '  dta_fim_validade is null '+
          '  and ind_restrito_sistema = ''N'' '+
          'order by '+
          '  num_ordem '),

    (TipoLinha: 19;
     Comentario: 'Tipos de Mortes';
     SQL: 'select '+
          '  cod_tipo_morte '+
          '  , sgl_tipo_morte '+
          '  , des_tipo_morte '+
          '  , cod_tipo_morte_sisbov '+
          'from '+
          '  tab_tipo_morte '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_tipo_morte '),

    (TipoLinha: 20;
     Comentario: 'Causas de Mortes';
     SQL: 'select '+
          '  cod_causa_morte '+
          '  , sgl_causa_morte '+
          '  , des_causa_morte '+
          'from '+
          '  tab_causa_morte '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_causa_morte '),

    (TipoLinha: 21;
     Comentario: 'Tipos de Causas de Mortes';
     SQL: 'select '+
          '  ttcm.cod_tipo_morte '+
          '  , ttcm.cod_causa_morte '+
          'from '+
          '  tab_tipo_causa_morte ttcm '+
          '  , tab_tipo_morte ttm '+
          '  , tab_causa_morte tcm '+
          'where '+
          '  tcm.cod_causa_morte = ttcm.cod_causa_morte '+
          '  and tcm.dta_fim_validade is null '+
          '  and ttm.cod_tipo_morte = ttcm.cod_tipo_morte '+
          '  and ttm.dta_fim_validade is null '+
          'order by '+
          '  ttm.des_tipo_morte '+
          '  , tcm.des_causa_morte '),

    (TipoLinha: 22;
     Comentario: 'Grupos de Identificadores';
     SQL: 'select '+
          '  cod_grupo_identificador '+
          '  , des_grupo_identificador '+
          'from '+
          '  tab_grupo_identificador '+
          'where '+
          '  dta_fim_validade is null '+
          'order by '+
          '  des_grupo_identificador '),

    (TipoLinha: 23;
     Comentario: 'Posição por Grupos de Identificadores';
     SQL: 'select '+
          '  tgpi.cod_posicao_identificador '+
          '  , tgpi.cod_grupo_identificador '+
          'from '+
          '  tab_grupo_posicao_ident tgpi '+
          '  , tab_posicao_identificador tpi '+
          '  , tab_grupo_identificador tgi '+
          'where '+
          '  tgi.cod_grupo_identificador = tgpi.cod_grupo_identificador '+
          '  and tgi.dta_fim_validade is null '+
          '  and tpi.cod_posicao_identificador = tgpi.cod_posicao_identificador '+
          '  and tpi.dta_fim_validade is null '+
          'order by '+
          '  tpi.des_posicao_identificador '+
          '  , tgi.des_grupo_identificador '),

    (TipoLinha: 24;
     Comentario: 'Relacionamento entre Raças e Associações de raça';
     SQL: 'select '+
          '  tarr.cod_associacao_raca '+
          '  , tarr.cod_raca '+
          'from '+
          '  tab_associacao_raca_raca tarr '+
          '  , tab_associacao_raca tar '+
          '  , tab_raca tr '+
          'where '+
          '  tar.cod_associacao_raca = tarr.cod_associacao_raca '+
          '  and tr.cod_raca = tarr.cod_raca '+
          '  and tar.dta_fim_validade is null '+
          '  and tr.dta_fim_validade is null '+
          'order by '+
          '  tar.nom_associacao_raca '+
          '  , tr.des_raca '),

    (TipoLinha: 100;
     Comentario: 'Atributos de animais disponíveis para alteração';
     SQL: 'select '+
          '  cod_atributo_alteracao '+
          '  , sgl_atributo_alteracao '+
          '  , nom_coluna_alteracao ' +
          '  , ind_tipo_dado ' +
          '  , txt_dado_vazio ' +
          'from '+
          '  tab_atributo_alteracao_animal '+
          { A condição descrita abaixo elimina da lista de atributos disponíveis
          para alteração o atributo cod_animal_certificadora, quando o mesmo é
          gerado automaticamente pelo sistema }
          'where '+
          '  not exists ( '+
          '    select 1 from tab_parametro_sistema '+
          '    where cod_parametro_sistema = 8 and val_parametro_sistema = ''S'') '+
          '  or cod_atributo_alteracao <> 3 ')
  );
var
  Q: THerdomQuery;
  iAux, jAux: Integer;
  Arquivo: TArquivoEscrita;
  NomCertificadora, NumCNPJCertificadora, sNomArquivo: String;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

{  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;  }

  Result :=  ObterDadosCertificadora(NomCertificadora, NumCNPJCertificadora, Self);
  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    Arquivo := TArquivoEscrita.Create;
    Arquivo.Compactar := False;
    try
      try

        sNomArquivo := Conexao.CaminhoArquivosCertificadora + Trim(ValorParametro(36));
        if (Length(sNomArquivo)=0) or (sNomArquivo[Length(sNomArquivo)]<>'\') then begin
          sNomArquivo := sNomArquivo + '\';
        end;
        if not DirectoryExists(sNomArquivo) then begin
          if not ForceDirectories(sNomArquivo) then begin
            Mensagens.Adicionar(1214, Self.ClassName, NomeMetodo, []);
            Result := -1214;
            Exit;
          end;
        end;
        sNomArquivo := sNomArquivo + Trim(ValorParametro(37));
        Arquivo.NomeArquivo := sNomArquivo;
        if Arquivo.Inicializar = 0 then begin
          Arquivo.AdicionarComentario('Header do arquivo');
          Arquivo.DefinirHeader(DtaSistema, NomCertificadora, NumCNPJCertificadora);
          Arquivo.AdicionarLinha; {Salta uma linha em branco}
          for iAux := 0 to Length(cDados)-1 do begin
            Arquivo.AdicionarComentario(cDados[iAux].Comentario);
            Arquivo.TipoLinha := cDados[iAux].TipoLinha;
            Q.Close;
            Q.SQL.Text := cDados[iAux].SQL;
            Q.Open;
            while not Q.EOF do begin
              for jAux := 0 to Q.Fields.Count-1 do begin
                if Q.Fields[jAux].DataType = ftString then begin
                  Arquivo.AdicionarColuna(Trim(Q.Fields[jAux].AsString));
                end else begin
                  Arquivo.AdicionarColuna(Q.Fields[jAux].Value);
                end;
              end;
              Q.Next;
              Arquivo.AdicionarLinha;
            end;
            Arquivo.AdicionarLinha; {Salta uma linha em branco}
          end;
          Arquivo.AdicionarComentario('Final do arquivo!');
          Arquivo.Finalizar;
          Result := 0;
        end else begin
          Mensagens.Adicionar(1212, Self.ClassName, NomeMetodo, []);
          Result := -1212;
        end;
      except
        on E: Exception do begin
          Rollback;
          Mensagens.Adicionar(1213, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -1213;
          Exit;
        end;
      end;
    finally
      Arquivo.Free;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ArmazenarArquivoUpload(CodTipoOrigemArqImport: Integer; NomArquivoUpload: String): Integer;
const
  Metodo: Integer = 383;
  NomeMetodo: String = 'ArmazenarArquivoUpload';
var
  Q: THerdomQuery;
  ArquivoUpload: TArquivoLeitura;
  ArquivoImportacao: TArquivoEscrita;
  Armazenamento: TArmazenamento;
  ArquivoZip: unzFile;
  sOrigem, sDestino, sRetornoErro, sAux, sNomArquivoUploadOriginal, MsgErro: String;
  iAux, CodPessoaProdutor, CodArquivoImportacao: Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Armazena o nome original do arquivo de upload
  sNomArquivoUploadOriginal := NomArquivoUpload;

  // Recupera pasta temporária de armazenamento
  if CodTipoOrigemArqImport = 1 then begin //Caminho para busca no diretorio de Upload
     sOrigem := ValorParametro(21);
    if (Length(sOrigem)=0) or (sOrigem[Length(sOrigem)]<>'\') then begin
        sOrigem := sOrigem + '\';
     end;
  end else if CodTipoOrigemArqImport = 2 then begin //Caminho para busca no diretorio de FTP
     sOrigem := ValorParametro(72);
     if (Length(sOrigem)=0) or (sOrigem[Length(sOrigem)]<>'\') then begin
        sOrigem := sOrigem + '\';
     end;
  end;

    // Consiste existência da pasta
  if not DirectoryExists(sOrigem) then begin
    Mensagens.Adicionar(1122, Self.ClassName, NomeMetodo, []);
    Result := -1122;
    Exit;
  end;

  // Consiste existência do arquivo informado
  if not FileExists(sOrigem + NomArquivoUpload) then begin
    Mensagens.Adicionar(1123, Self.ClassName, NomeMetodo, []);
    Result := -1123;
    Exit;
  end;

  if CodTipoOrigemArqImport = 2 then begin
    // Recupera a pasta adequada dos arquivos que se encontram com erro, caso a origem seja do FTP
    sRetornoErro := ValorParametro(73);
    if (Length(sRetornoErro)=0) or (sOrigem[Length(sRetornoErro)]<>'\') then begin
      sRetornoErro := sRetornoErro + '\';
    end;

    // Consiste existência da pasta, caso não exista tenta criá-la
    if not DirectoryExists(sRetornoErro) then begin
      if not ForceDirectories(sRetornoErro) then begin
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1217, Self.ClassName, NomeMetodo, []);
        Result := -1217;
        Exit;
      end;
    end;

    // Armazena o arquivo de upload via FTP na pasta de retorno
    // Ao final do processo, caso o mesmo tenha sido bem sucedido, esse arquivo será excluído
    Win32_CopiaArquivo(sOrigem + sNomArquivoUploadOriginal, sRetornoErro + sNomArquivoUploadOriginal);
  end;

  // Verifica se o arquivo de upload está compactado
  if UpperCase(ExtractFileExt(NomArquivoUpload)) = '.ZIP' then begin
    // Tentar abrir o arquivo ZIP
    Result := AbrirUnZip(sOrigem+NomArquivoUpload, ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1360, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1360;
      Exit;
    end;

    // Consiste o número de arquivo dentro do Arquivo ZIP
    Result := NumArquivosDoUnZip(ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1361;
      Exit;
    end else if Result > 1 then begin
      Mensagens.Adicionar(1362, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1362;
      Exit;
    end;

    // Obtem o nome do primeiro arquivo (teoricamente deve ser o último)
    sAux := NomeArquivoCorrenteDoUnzip(ArquivoZip);

    // Extrai o arquivo compactado
    Result := ExtrairArquivoDoUnZip(ArquivoZip, sAux, sOrigem);
    if Result <> 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      if (Result = -5) or (Result = -6) then begin
        DeleteFile(sOrigem+sAux);
      end;
      Result := -1361;
      Exit;
    end;

    // Fechar arquivo ZIP
    FecharUnZip(ArquivoZip);

    // Apaga arquivo compactado
    DeleteFile(sOrigem+NomArquivoUpload);
    NomArquivoUpload := ExtractFileName(sAux);
  end;

  // Define caminho e arquivo completo da origem
  sOrigem := sOrigem + NomArquivoUpload;

  // Recupera pasta adequada dos arquivos
  sDestino := ValorParametro(38);
  if (Length(sDestino)=0) or (sDestino[Length(sDestino)]<>'\') then begin
    sDestino := sDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then begin
    if not ForceDirectories(sDestino) then begin
      // Remove o arquivo temporário de imagem da pasta temporária
      DeleteFile(sOrigem);
      // Gera Mensagem erro informando o problema ao usuário
      Mensagens.Adicionar(1217, Self.ClassName, NomeMetodo, []);
      Result := -1217;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    ArquivoUpload := TArquivoLeitura.Create;
    try
      ArquivoImportacao := TArquivoEscrita.Create;
      try
        try

          {Habilita a sequencia  de leitura "linha-a-linha" (não saltando linhas
          em branco, comentários, nem mesmo o header (apenas obtem seus dados e
          retorna ao início do arquivo, aguardando uma nova instrução))}
          ArquivoUpload.LinhaaLinha := True;
          {Identifica arquivo de upload}
          ArquivoUpload.NomeArquivo := sOrigem;
          {Guarda resultado da tentativa de abertura do arquivo}
          Result := ArquivoUpload.Inicializar;
          {Trata possíveis erros durante a tentativa de abertura do arquivo}
          if Result = EArquivoInexistente then begin
            Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
            Result := -1219;
            Exit;
          end else if Result = EInicializarLeitura then begin
            Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
            Result := -1219;
            Exit;
          end else if Result < 0 then begin
            Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
            Result := -1220;
            Exit;
          end;
          {Verifica se os dados do arquivo pertencem a certificadora}
          Result := ValidarCertificadora(ArquivoUpload.NumCNPJCertificadora, Self);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
              Result := -1223;
            end;
            Exit;
          end;
          {Verifica se natureza do produtor foi informada e é válida}
          if (ArquivoUpload.NaturezaProdutor <> 'F') and (ArquivoUpload.NaturezaProdutor <> 'J') then begin
            Mensagens.Adicionar(1221, Self.ClassName, NomeMetodo, []);
            Result := -1221;
            Exit;
          end;
          {Verifica se NumCNPJCPF do produtor foi informado e é valido}
          iAux := Length(ArquivoUpload.NumCNPJCPFProdutor);
          if ArquivoUpload.NaturezaProdutor = 'F' then begin
            if iAux <> 11 then begin
              Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, ['CPF']);
              Result := -1222;
              Exit;
            end;
            sAux := Copy(ArquivoUpload.NumCNPJCPFProdutor, 1, 9);
          end else begin
            if iAux <> 14 then begin
              Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, ['CNPJ']);
              Result := -1222;
              Exit;
            end;
            sAux := Copy(ArquivoUpload.NumCNPJCPFProdutor, 1, 12);
          end;
          if not VerificarCnpjCpf(sAux, ArquivoUpload.NumCNPJCPFProdutor, 'N') then begin
            Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, []);
            Result := -1222;
            Exit;
          end;
          {Verifica se o produtor pertence ao universo de produtores da certificadora}
          Result := ValidarProdutor(ArquivoUpload.NaturezaProdutor,
            ArquivoUpload.NumCNPJCPFProdutor, CodPessoaProdutor, Self);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1224, Self.ClassName, NomeMetodo, []);
              Result := -1224;
            end;
            Exit;
          end;
          {Verifica se o usuário logado tem permissão para manipular os dados do produtor
          identificado}
          Result := ValidarProdutorUsuario(CodPessoaProdutor);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1246, Self.ClassName, NomeMetodo, []);
              Result := -1246;
            end;
            Exit;
          end;


          {Obtem código um código para o arquivo}
          Result := ObterCodArquivoImportacao(CodArquivoImportacao);
          if Result < 0 then begin
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result:= -1;
            Exit;
          end;
          

          {Caso o produtor rural ainda não tenha sido definido, defini o produtor identificado
          como o produtor de trabalho corrente}
          iAux := Conexao.CodProdutorTrabalho;
          if Conexao.CodProdutorTrabalho <> CodPessoaProdutor then begin
            Result := Conexao.DefinirProdutorTrabalho(CodPessoaProdutor, sAux);
            case Result of
              180: {Inexistência de dados do produtor}
                begin
                  Mensagens.Adicionar(180, Self.ClassName, NomeMetodo, [IntToStr(CodPessoaProdutor)]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                  {Inicializa transação}
                  BeginTran;
                  {Armazena arquivo}
                  Result := InserirArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao, sAux, NomArquivoUpload, 'N', ' ', CodTipoOrigemArqImport);

                  if Result >= 0 then Commit
                  else begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    RollBack;
                  end;
                  Commit;
                  Result := -180;
                  Exit;
                end;
              362: {Dados do produtor obtidos, porém o mesmo está bloqueado (acesso negado)}
                begin
                  Mensagens.Adicionar(362, Self.ClassName, NomeMetodo, [sAux]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                  {Inicializa transação}
                  BeginTran;
                  {Armazena arquivo}
                  Result := InserirArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao, sAux, NomArquivoUpload, 'N', ' ', CodTipoOrigemArqImport);
                  if Result >= 0 then Commit
                  else begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    RollBack;
                  end;
                  Commit;
                  Result := -362;
                  Exit;
                end;
              0: {Procedimento bem sucedido}
                if iAux = -1 then begin
                  Mensagens.Adicionar(1263, Self.ClassName, NomeMetodo, []);
                end else begin
                  Mensagens.Adicionar(1264, Self.ClassName, NomeMetodo, []);
                end;
            else
              Exit;
            end;
          end;
          {Abre transação para controle do processamento de leitura do arquivo temporário
          e as respectivas inserção realizadas na base}
          //BeginTran;

          //{Obtem código um código para o arquivo}
          //Result := ObterCodArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao);
          //if Result < 0 then Exit;

          {Identifica arquivo a ser salvo em disco na pasta correta}
          sAux := 'HRP'+ StrZero(CodArquivoImportacao, 7)+'.txt';
          sDestino := sDestino + sAux;
          {Inicia procedimento de armazenamento definitivo do arquivo}
          ArquivoImportacao.NomeArquivo := sDestino;
          if (ArquivoImportacao.Inicializar = 0) then begin
            Armazenamento := TArmazenamento.Create;
            try
              Result := Armazenamento.Inicializar(Conexao, Mensagens);
              if Result < 0 then Exit;
              Armazenamento.CodPessoaProdutor := CodPessoaProdutor;
              Armazenamento.CodArquivoImportacao := CodArquivoImportacao;
              ArquivoImportacao.TipoLinha := -1; // Desliga a identificação automática de linhas
              while (Result = 0) and not(ArquivoUpload.EOF) do begin
                Result := ArquivoUpload.ObterLinha; // Obtem linha do arquivo temporário
                if Result < 0 then begin
                  if Result = ETipoColunaDesconhecido then begin
                    Result := -1234;
                  end else if Result = ECampoNumericoInvalido then begin
                    Result := -1235;
                  end else if Result = EDelimitadorStringInvalido then begin
                    Result := -1236;
                  end else if Result = EDelimitadorOutroCampoInvalido then begin
                    Result := -1237;
                  end else if Result = EOutroCampoInvalido then begin
                    Result := -1238;
                  end else if Result = EDefinirTipoLinha then begin
                    Result := -1239;
                  end else if Result = EAdicionarColunaLeitura then begin
                    Result := -1240;
                  end else if Result = EFinalDeLinhaInesperado then begin
                    Result := -1243;
                  end else begin
                    Result := -1232;
                  end;
                  Mensagens.Adicionar(-Result, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas)]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  {Caso o arquivo esteja inválido, um registro deve ser gerado na base de dados informando o erro}
                  {Inicializa transação}
                  BeginTran;
                  {Armazena arquivo}
                  Result := InserirArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao, sAux, NomArquivoUpload, 'N', ' ', CodTipoOrigemArqImport);
                  if Result >= 0 then Commit
                  else begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    RollBack;
                  end;
                  {Força um erro para que as devidas operações sejam realizadas}
                  Result := -1;
                  Exit;
                end;
                Result := ArquivoImportacao.AdicionarLinhaTexto(ArquivoUpload.LinhaTexto); // Escreve linha no arquivo definitivo
                if Result < 0 then begin
                  Mensagens.Adicionar(1233, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  {Caso o arquivo esteja inválido, um registro deve ser gerado na base de dados informando o erro}
                  {Inicializa transação}
                  BeginTran;
                  {Armazena arquivo}
                  Result := InserirArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao, sAux, NomArquivoUpload, 'N', ' ', CodTipoOrigemArqImport);
                  if Result >= 0 then Commit
                  else begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    RollBack;
                  end;
                  Result := -1233;
                  Exit;
                end;
                if ArquivoUpload.TipoLinha > 0 then begin
                  Armazenamento.IncLidas(ArquivoUpload.TipoLinha);
                end;
              end;

              {Finaliza arquivo definitivo}
              ArquivoImportacao.Finalizar;

              {Inicializa transação}
              BeginTran;
              {Armazena arquivo}
              Result := InserirArquivoImportacao(CodPessoaProdutor, CodArquivoImportacao, sAux, NomArquivoUpload, 'N', ' ', CodTipoOrigemArqImport);
              Commit;
              if Result >= 0 then begin
                BeginTran;
                Result := Armazenamento.Salvar;
                if Result < 0 then begin
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                  Rollback;
                  Exit;
                end else Commit;
              end else begin
                Rollback; {Desfaz atualizações realizadas na base}
                Mensagens.Adicionar(1228, Self.ClassName, NomeMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1228;
              end;
            finally
              Armazenamento.Free;
            end;


            {Atualiza a quantidade real de linhas do arquivo}
            Q.Close;
            Q.SQL.Text :=
              'update tab_arquivo_importacao '+
              'set '+
              '  qtd_linhas = :num_linhas '+
              'where '+
              '  cod_pessoa_produtor = :cod_pessoa_produtor '+
              '  and cod_arquivo_importacao = :cod_arquivo_importacao ';
            Q.ParamByName('num_linhas').AsInteger := ArquivoUpload.LinhasLidas;
            Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
            Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
            Q.ExecSQL;

            {Finaliza arquivo upload}
            ArquivoUpload.Finalizar;

            {Verifica a existência de um arquivo de upload como o mesmo, havendo gera uma mensagem}
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  count(1) as QtdArquivo '+
              'from '+
              '  tab_arquivo_importacao '+
              'where '+
              '  nom_arquivo_upload like :nom_arquivo_upload ';
            Q.ParamByName('nom_arquivo_upload').AsString := NomArquivoUpload;
            Q.Open;
            if Q.FieldByName('QtdArquivo').AsInteger > 1 then begin
              Mensagens.Adicionar(1267, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            end;
            Q.Close;
            {Finaliza transação, garantindo atualizações realizadas}
            Commit;

            if CodTipoOrigemArqImport = 2 then begin
              // Remove arquivo da pasta de retorno via FTP, pois o procedimento
              // foi realizado com sucesso
              DeleteFile(sRetornoErro + sNomArquivoUploadOriginal);
            end;

            {Identifica procedimento como bem sucedido, retornado o código do arquivo inserido}
            Result := CodArquivoImportacao;
          end else begin
            Rollback; {Desfaz atualizações realizadas na base}
            Mensagens.Adicionar(1228, Self.ClassName, NomeMetodo, []);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1228;
            exit;
          end;
        except
          on E: Exception do begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1218;
            Exit;
          end;
        end;
      finally
        ArquivoImportacao.Free;
        ArquivoUpload.Free;
        {Remove arquivo de destino caso o procedimento tenha sido mal sucedido}
        {e atualiza a situação do arquivo}
        if (Result < 0) then
        begin
          try
            BeginTran;
            Q.Close;
            Q.SQL.Text :=
              'update tab_arquivo_importacao '+
              'set '+
              '  cod_situacao_arq_import = :codSituacaoArqImport, '+
              '  txt_mensagem = :txtMensagem '+
              'where '+
              '      cod_arquivo_importacao = :codArquivoImportacao ' +
              '  and cod_pessoa_produtor    = :cod_pessoa_produtor' ;
            Q.ParamByName('codSituacaoArqImport').AsString := 'I';
            Q.ParamByName('codArquivoImportacao').AsInteger := CodArquivoImportacao;
            Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
            Q.ParamByName('txtMensagem').AsString := MsgErro;
            Q.ExecSQL;
            {Finaliza transação, garantindo atualizações realizadas}
            Commit;
          except
          on E: Exception do begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1218;
          end;
          end;

          if FileExists(sDestino) then begin
            {Tenta excluir o arquivo de importação gerado}
            if not DeleteFile(sDestino) then begin
              try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arquivo_importacao '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '      cod_arquivo_importacao = :codArquivoImportacao ' +
                  '  and cod_pessoa_produtor    = :cod_pessoa_produtor' ;
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArquivoImportacao;
                Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;                
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir o arquivo de importação. ';
                Q.ExecSQL;
                {Finaliza transação, garantindo atualizações realizadas}
                Commit;
              except
              on E: Exception do begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              end;
              end;
            end;
          end;

          if (FileExists(sOrigem) and (CodTipoOrigemArqImport = 2)) then  begin // FTP
            try
//              Após a alteração realizada no início deste procedimento o arquivo
//              já se encontra na pasta de retorno e não é + necessária esta cópia
//              CopiaArquivo(sOrigem, sRetornoErro + NomArquivoUpload);
              if FileExists(sOrigem) then DeleteFile(sOrigem);
            except
              try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arquivo_importacao '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '      cod_arquivo_importacao = :codArquivoImportacao' +
                  '  and cod_pessoa_produtor    = :cod_pessoa_produtor' ;
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArquivoImportacao;
                Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;                
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir ou mover o arquivo de origem. ';
                Q.ExecSQL;
                //Finaliza transação, garantindo atualizações realizadas
                Commit;
              except
              on E: Exception do begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              end;
              end;
            end;
          end else begin // Upload
            try
              if FileExists(sOrigem) then DeleteFile(sOrigem);
            except
              try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arquivo_importacao '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '      cod_arquivo_importacao = :codArquivoImportacao ' +
                  '  and cod_pessoa_produtor    = :cod_pessoa_produtor' ;
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArquivoImportacao;
                Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;                
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir o arquivo de origem. ';
                Q.ExecSQL;
                //Finaliza transação, garantindo atualizações realizadas
                Commit;
              except
              on E: Exception do begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              end;
              end;
            end;
          end;
        end;
      end;
    finally
      {Tenta excluir o arquivo origem}
      if ((Result >= 0) and (FileExists(sOrigem)) and (not DeleteFile(sOrigem))) then begin
        try
          BeginTran;
          Q.Close;
          Q.SQL.Text :=
            'update tab_arquivo_importacao '+
            'set '+
            '  cod_situacao_arq_import =:codSituacaoArqImport, '+
            '  txt_mensagem = txt_mensagem + :txtMensagem '+
            'where '+
            '      cod_arquivo_importacao = :codArquivoImportacao ' +
            '  and cod_pessoa_produtor    = :cod_pessoa_produtor' ;

          Q.ParamByName('codSituacaoArqImport').AsString := 'I';
          Q.ParamByName('codArquivoImportacao').AsInteger := CodArquivoImportacao;
          Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
          Q.ParamByName('txtMensagem').AsString := 'Erro ao excluir o arquivo de origem. ';
          Q.ExecSQL;
          {Finaliza transação, garantindo atualizações realizadas}
          Commit;
        except
        on E: Exception do begin
          Rollback;
          Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -1218;
        end;
        end;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ArmazenarArquivoAutenticacao(
  NomArquivoUpload: String): Integer;
const
  Metodo: Integer = 486;
  NomeMetodo: String = 'ArmazenarArquivoAutenticacao';
  iCNPJ: Integer = 3;
  iTipo1: Integer = 1;
  iQtdTipo1: Integer = 2;
  iTipo2: Integer = 3;
  iQtdTipo2: Integer = 4;
var
  Q: THerdomQuery;
  ArquivoUpload: TArquivoPosicionalLeitura;
  ArquivoImportacao: TArquivoPosicionalEscrita;
  Armazenamento: TArmazenamento;
  ArquivoZip: unzFile;
  bConfirmacaoLeitura: Boolean;
  sOrigem, sDestino, sAux: String;
  CodArquivoImportacao: Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Recupera pasta temporária de armazenamento
  sOrigem := ValorParametro(21);
  if (Length(sOrigem)=0) or (sOrigem[Length(sOrigem)]<>'\') then begin
    sOrigem := sOrigem + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(sOrigem) then begin
    Mensagens.Adicionar(1122, Self.ClassName, NomeMetodo, []);
    Result := -1122;
    Exit;
  end;

  // Consiste existência do arquivo informado
  if not FileExists(sOrigem + NomArquivoUpload) then begin
    Mensagens.Adicionar(1123, Self.ClassName, NomeMetodo, []);
    Result := -1123;
    Exit;
  end;

  // Verifica se o arquivo de upload está compactado
  if UpperCase(ExtractFileExt(NomArquivoUpload)) = '.ZIP' then begin
    // Tentar abrir o arquivo ZIP
    Result := AbrirUnZip(sOrigem+NomArquivoUpload, ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1360, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1360;
      Exit;
    end;

    // Consiste o número de arquivo dentro do Arquivo ZIP
    Result := NumArquivosDoUnZip(ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1361;
      Exit;
    end else if Result > 1 then begin
      Mensagens.Adicionar(1362, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1362;
      Exit;
    end;

    // Obtem o nome do primeiro arquivo (teoricamente deve ser o último)
    sAux := NomeArquivoCorrenteDoUnzip(ArquivoZip);

    // Extrai o arquivo compactado
    Result := ExtrairArquivoDoUnZip(ArquivoZip, sAux, sOrigem);
    if Result <> 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArquivoUpload);
      if (Result = -5) or (Result = -6) then begin
        DeleteFile(sOrigem+sAux);
      end;
      Result := -1361;
      Exit;
    end;

    // Fechar arquivo ZIP
    FecharUnZip(ArquivoZip);

    // Apaga arquivo compactado
    DeleteFile(sOrigem+NomArquivoUpload);
    NomArquivoUpload := ExtractFileName(sAux);
  end;

  // Define caminho e arquivo completo da origem
  sOrigem := sOrigem + NomArquivoUpload;

  // Recupera pasta adequada dos arquivos
  sDestino := Conexao.CaminhoArquivosCertificadora + ValorParametro(64);
  if (Length(sDestino)=0) or (sDestino[Length(sDestino)]<>'\') then begin
    sDestino := sDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then begin
    if not ForceDirectories(sDestino) then begin
      // Remove o arquivo temporário de imagem da pasta temporária
      DeleteFile(sOrigem);
      // Gera Mensagem erro informando o problema ao usuário
      Mensagens.Adicionar(1217, Self.ClassName, NomeMetodo, []);
      Result := -1217;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    ArquivoUpload := TArquivoPosicionalLeitura.Create;
    try
      ArquivoImportacao := TArquivoPosicionalEscrita.Create;
      try
        try

          {Identifica arquivo de upload}
          ArquivoUpload.NomeArquivo := sOrigem;
          {Guarda resultado da tentativa de abertura do arquivo}
          ArquivoUpload.RotinaLeitura := InterpretaLinhaArquivoAutenticacao;
          Result := ArquivoUpload.Inicializar;
          {Trata possíveis erros durante a tentativa de abertura do arquivo}
          if Result = EArquivoInexistente then begin
            Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
            Result := -1219;
            Exit;
          end else if Result = EInicializarLeitura then begin
            Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
            Result := -1219;
            Exit;
          end else if Result < 0 then begin
            Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
            Result := -1220;
            Exit;
          end;
          {Obtem a primeira linha do arquivo (que identifica certificadora)}
          ArquivoUpload.ObterLinha;
          {Verifica se os dados do arquivo pertencem a certificadora}
          Result := ValidarCertificadora(ArquivoUpload.ValorColuna[iCNPJ], Self);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
              Result := -1223;
            end;
            Exit;
          end;
          {Recomeça leitura a partir do ínicio do arquivo}
          ArquivoUpload.ReInicializar;
          {Abre transação para controle do processamento de leitura do arquivo temporário
          e as respectivas inserção realizadas na base}
          BeginTran;

          {Obtem código um código para o arquivo}
          Result := ObterCodArquivoAutenticacao(CodArquivoImportacao);
          if Result < 0 then Exit;
          {Identifica arquivo a ser salvo em disco na pasta correta}
          sAux := StrZero(CodArquivoImportacao, 8)+'.txt';
          sDestino := sDestino + sAux;
          {Inicia procedimento de armazenamento definitivo do arquivo}
          ArquivoImportacao.NomeArquivo := sDestino;
          if (ArquivoImportacao.Inicializar = 0) then begin
            Result := InserirArquivoAutenticacao(CodArquivoImportacao, sAux, NomArquivoUpload);
            if Result = 0 then begin
              Armazenamento := TArmazenamento.Create;
              try
                Result := Armazenamento.Inicializar(Conexao, Mensagens);
                if Result < 0 then begin
                  Rollback;
                  Exit;
                end;
                Armazenamento.TipoArmazenamento := taAutenticacao;
                Armazenamento.CodArquivoImportacao := CodArquivoImportacao;
                ArquivoImportacao.TipoLinha := -1; // Desliga a identificação automática de linhas
                bConfirmacaoLeitura := False; // A última linha de confirmação do arquivo não foi encontrada ainda
                while (Result = 0) and not(ArquivoUpload.EOF) do begin
                  Result := ArquivoUpload.ObterLinha; // Obtem linha do arquivo temporário
                  if Result < 0 then begin
                    if Result = ETipoColunaDesconhecido then begin
                      Result := -1234;
                    end else if Result = ECampoNumericoInvalido then begin
                      Result := -1235;
                    end else if Result = EDelimitadorStringInvalido then begin
                      Result := -1236;
                    end else if Result = EDelimitadorOutroCampoInvalido then begin
                      Result := -1237;
                    end else if Result = EOutroCampoInvalido then begin
                      Result := -1238;
                    end else if Result = EDefinirTipoLinha then begin
                      Result := -1239;
                    end else if Result = EAdicionarColunaLeitura then begin
                      Result := -1240;
                    end else if Result = EFinalDeLinhaInesperado then begin
                      Result := -1243;
                    end else begin
                      Result := -1232;
                    end;
                    Mensagens.Adicionar(-Result, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas)]);
                    Rollback;
                    Exit;
                  end;
                  Result := ArquivoImportacao.AdicionarLinhaTexto(ArquivoUpload.LinhaTexto); // Escreve linha no arquivo definitivo
                  if Result < 0 then begin
                    Mensagens.Adicionar(1233, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                    Result := -1233;
                    Rollback;
                    Exit;
                  end;
                  // Verifica se a linha é uma linha de autenticação
                  case ArquivoUpload.TipoLinha of
                    1, 2:
                      Armazenamento.IncLidas(ArquivoUpload.TipoLinha);
                    9:
                      begin
                        // Define que a última linha do arquivo foi encontrada, mas a confirmação depende
                        // das informações nela contidas
                        bConfirmacaoLeitura :=
                          (StrToIntDef(ArquivoUpload.ValorColuna[iTipo1], 0) = 1)
                          and (StrToIntDef(ArquivoUpload.ValorColuna[iTipo2], 0) = 2)
                          and (StrToIntDef(ArquivoUpload.ValorColuna[iQtdTipo1], 0) = Armazenamento.QtdLinhasLidas[1])
                          and (StrToIntDef(ArquivoUpload.ValorColuna[iQtdTipo2], 0) = Armazenamento.QtdLinhasLidas[2]);
                      end;
                  end;
                end;
                if not bConfirmacaoLeitura then begin
                  Mensagens.Adicionar(1604, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
                  Result := -1604;
                  Rollback;
                  Exit;
                end;
                if Armazenamento.QtdLinhasLidas[2] = 0 then begin
                  Mensagens.Adicionar(1603, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
                  Result := -1603;
                  Rollback;
                  Exit;
                end;
                Result := Armazenamento.Salvar;
                if Result < 0 then begin
                  Rollback;
                  Exit;
                end;
              finally
                Armazenamento.Free;
              end;
              {Finaliza arquivo definitivo}
              ArquivoImportacao.Finalizar;

              {Atualiza a quantidade real de linhas do arquivo}
              Q.Close;
              Q.SQL.Text :=
                'update tab_arquivo_autenticacao '+
                'set '+
                '  num_linhas = :num_linhas '+
                'where '+
                '  cod_arquivo_importacao = :cod_arquivo_importacao ';
              Q.ParamByName('num_linhas').AsInteger := ArquivoUpload.LinhasLidas;
              Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
              Q.ExecSQL;

              {Verifica a existência de um arquivo de upload como o mesmo, havendo gera uma mensagem}
              Q.Close;
              Q.SQL.Text :=
                'select '+
                '  count(1) as QtdArquivo '+
                'from '+
                '  tab_arquivo_autenticacao '+
                'where '+
                '  nom_arquivo_upload like :nom_arquivo_upload ';
              Q.ParamByName('nom_arquivo_upload').AsString := NomArquivoUpload;
              Q.Open;
              if Q.FieldByName('QtdArquivo').AsInteger > 1 then begin
                Mensagens.Adicionar(1267, Self.ClassName, NomeMetodo, []);
              end;
              Q.Close;
              {Finaliza transação, garantindo atualizações realizadas}
              Commit;
              {Identifica procedimento como bem sucedido, retornado o código do arquivo inserido}
              Result := CodArquivoImportacao;
            end else begin
              Rollback; {Desfaz atualizações realizadas na base}
            end;
          end else begin
            Rollback; {Desfaz atualizações realizadas na base}
            Mensagens.Adicionar(1228, Self.ClassName, NomeMetodo, []);
            Result := -1228;
          end;
        except
          on E: Exception do begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
            Result := -1218;
            Exit;
          end;
        end;
      finally
        ArquivoImportacao.Free;
        {Remove arquivo de destino caso o procedimento tenha sido mal sucedido}
        if (Result < 0) and FileExists(sDestino) then begin
          DeleteFile(sDestino);
        end;
      end;
    finally
      ArquivoUpload.Free;
      {Remove arquivo temporário de upload}
      DeleteFile(sOrigem);
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.Pesquisar(NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
    NomUsuarioUpload: String; CodTipoOrigemArqImport: Integer; CodSituacaoArqImport: String; DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim: TDateTime): Integer;
const
  Metodo: Integer = 386;
  NomeMetodo: String = 'Pesquisar';
var
  CodUsuarioUpload: Integer;
begin
  Result := -1;
  CodUsuarioUpload := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  // Result:=Conexao.DefinirProdutorTrabalho(1177, sAux);
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  try

     //resultSet para codigos de usuario Upload
    if ((NomUsuarioUpload <> '') and (Conexao.CodPapelUsuario = 2)) then begin
            Query.Close;
            Query.SQL.Text := 'select cod_usuario from tab_usuario ' +
                      ' where nom_usuario like :nom_usuario ';
            Query.ParamByName('nom_usuario').AsString := #37 + NomUsuarioUpload + #37;
            Query.Open;
            CodUsuarioUpload := Query.fieldbyname('cod_usuario').AsInteger;
    end;

    if CodUsuarioUpload = -1 then begin
       CodUsuarioUpload := Conexao.CodUsuario;
    end;

    Query.Close;
    {Montando query de pesquisa de acordo com os críterios informados}
    Query.SQL.Text :=
      'select '+
      '     tai.cod_arquivo_importacao as CodArquivoImportacao '+
      '   , tai.nom_arquivo_upload as NomArquivoUpload ' +
      '   , tai.dta_importacao as DtaImportacao ' +

{      if ((NomUsuarioUpload <> '') and (Conexao.CodPapelUsuario <> 2)) then begin
      Query.SQL.Text := Query.SQL.Text +
      '    , (select nom_usuario from tab_usuario where cod_usuario = :cod_usuario_upload) as NomUsuarioUpload  ';
      end else begin
      Query.SQL.Text := Query.SQL.Text + }

      '    , (select nom_usuario from tab_usuario where cod_usuario = tai.cod_usuario_upload) as NomUsuarioUpload ' +
//      end;
//      Query.SQL.Text := Query.SQL.Text +

      '    , tor.sgl_tipo_origem_arq_import as SglTipoOrigemArqImport  '+
      '    , tai.cod_situacao_arq_import as SglSituacaoArqImport    ' +
      '    , tai.dta_ultimo_processamento as DtaUltimoProcessamento '+
      '    , qtd.qtd_erradas '+
      '    , qtd.qtd_total '+
      ' from '+
      '  tab_arquivo_importacao tai '+
      '  , tab_ocorrencia_processamento tp ' +
//     if Conexao.CodPapelUsuario <> 2 then begin
//      Query.SQL.Text := Query.SQL.Text +
      '  , tab_usuario tu ' +
//      end;
//      Query.SQL.Text := Query.SQL.Text +
      '  , tab_situacao_arq_import tsa '+
      '  , tab_tipo_origem_arq_import tor '+
      '  , tab_quantidade_tipo_linha qtd '+
      'where '+
{$IFDEF MSSQL}
      '  tp.cod_pessoa_produtor =* tai.cod_pessoa_produtor '+
      '  and tp.cod_arquivo_importacao =* tai.cod_arquivo_importacao '+
      '     and tsa.cod_situacao_arq_import =* tai.cod_situacao_arq_import '+
      '     and tor.cod_tipo_origem_arq_import =* tai.cod_tipo_origem_arq_import '+
      '     and qtd.cod_arquivo_importacao =* tai.cod_arquivo_importacao '+
      '     and qtd.cod_pessoa_produtor =* tai.cod_pessoa_produtor '+
{$ENDIF}
      '  and tai.cod_pessoa_produtor = :cod_pessoa_produtor ' +
      '  and tu.cod_usuario = tai.cod_usuario_upload ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;

    if Trim(NomArqUpload) <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
      '    and tai.nom_arquivo_upload like :nom_arq_upload ';
      Query.ParamByName('nom_arq_upload').AsString := #37 + NomArqUpload + #37;
    end;

    if (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tai.dta_importacao >= :dta_importacao_inicio ' +
        '  and tai.dta_importacao < :dta_importacao_fim ';
      Query.ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
      Query.ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim)+1;
    end;
    if (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tai.dta_ultimo_processamento >= :dta_ultimo_processamento_inicio '+
        '  and tai.dta_ultimo_processamento < :dta_ultimo_processamento_fim ';
      Query.ParamByName('dta_ultimo_processamento_inicio').AsDateTime := Trunc(DtaUltimoProcessamentoInicio);
      Query.ParamByName('dta_ultimo_processamento_fim').AsDateTime := Trunc(DtaUltimoProcessamentoFim)+1;
    end;

    if ((Conexao.CodPapelUsuario <> 2) or ((Trim(NomUsuarioUpload) <> ''))) then begin
       Query.SQL.Text := Query.SQL.Text +
       '    and tai.cod_usuario_upload = :cod_usuario_upload ';
       Query.ParamByName('cod_usuario_upload').AsInteger := CodUsuarioUpload;
    end;

    if CodTipoOrigemArqImport > 0 then begin
       Query.SQL.Text := Query.SQL.Text +
       '   and tai.cod_tipo_origem_arq_import = :cod_tipo_origem_arq_import ';
       Query.ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
    end;

    if Trim(CodSituacaoArqImport) <> '0' then begin
       Query.SQL.Text := Query.SQL.Text +
       '   and tai.cod_situacao_arq_import = :cod_situacao_arq_import ';
       Query.ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
    end;

    Query.SQL.Text := Query.SQL.Text +
      'group by '+
      '  tai.cod_arquivo_importacao '+
      '  , tai.nom_arquivo_importacao '+
      '  , tai.nom_arquivo_upload ';
      if Conexao.CodPapelUsuario <> 2 then begin
      Query.SQL.Text := Query.SQL.Text +
      '  , tu.nom_usuario ';
      end;
      Query.SQL.Text := Query.SQL.Text +
      '  , tai.cod_usuario_upload '+
      '  , tai.dta_importacao '+
      '  , tai.dta_ultimo_processamento '+
      '  , tp.cod_arquivo_importacao '+
      '  , tor.sgl_tipo_origem_arq_import '+
      '  , qtd.qtd_erradas '+
      '  , qtd.qtd_total '+
      '  , tai.cod_situacao_arq_import   ' +
      '  , tai.cod_pessoa_produtor ';

    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  tai.dta_importacao desc ';
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1231, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1231;
      Exit;
    end;
  end;
end;

function TIntImportacoes.Buscar(CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 387;
  NomeMetodo: String = 'Buscar';
var
  Query: THerdomQuery;
  Q: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
      Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
      Result := -188;
      Exit;
  end;
  

  // Verifica se produtor de trabalho foi definido
  //Conexao.DefinirProdutorTrabalho(1177, sAux); //definição temporaria para testes
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Query := THerdomQuery.Create(Conexao, nil);
  try
    try


      Q.Close;
      {Montando query de pesquisa de acordo com os críterios informados}
      Q.SQL.Text :=
        'select '+
        '  tai.cod_pessoa_produtor as CodPessoaProdutor '+
        '  , tpr.sgl_produtor as SglProdutor '+
        '  , tp.nom_pessoa as NomPessoaProdutor '+
{$IFDEF MSSQL}
        '  , case tp.cod_natureza_pessoa '+
        '    when ''F'' then convert(varchar(18), '+
        '      substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + '+
        '      substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + '+
        '      substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + '+
        '      substring(tp.num_cnpj_cpf, 10, 2)) '+
        '    when ''J'' then convert(varchar(18), '+
        '      substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + '+
        '      substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + '+
        '      substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + '+
        '      substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + '+
        '      substring(tp.num_cnpj_cpf, 13, 2)) '+
        '    end as NumCNPJCPFFormatadoProdutor '+
{$ENDIF}
        '  , tai.cod_arquivo_importacao as CodArquivoImportacao '+
        '  , tai.nom_arquivo_importacao as NomArquivoImportacao '+
        '  , tai.dta_importacao as DtaImportacao '+
        '  , tu.nom_usuario as LoginUsuarioUpload '+
        '  , tai.nom_arquivo_upload as NomArquivoUpload '+
        '  , tai.qtd_vezes_processamento as QtdVezesProcessamento '+
        '  , tai.dta_ultimo_processamento as DtaUltimoProcessamento '+
        '  , tai.qtd_linhas as NumLinhas '+
        '  , tai.cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
        '  , tai.cod_situacao_arq_import as CodSituacaoArqImport '+
        '  , tai.cod_usuario_upload as CodUsuarioUpload '+
        '  , tai.cod_ultima_tarefa as CodUltimaTarefa '+
        ' from '+
        '  tab_arquivo_importacao tai '+
        '  , tab_pessoa tp '+
        '  , tab_produtor tpr '+
        '  , tab_usuario tu '+
        'where '+
        '  tu.cod_usuario = tai.cod_usuario_upload '+
        '  and tp.cod_pessoa = tpr.cod_pessoa_produtor '+
        '  and tpr.cod_pessoa_produtor = tai.cod_pessoa_produtor '+
        '  and tai.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and tai.cod_arquivo_importacao = :cod_arquivo_importacao ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
        Q.Open;
        
      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;
      
      { Busca dados da sigla e descrição da origem do arquivo de importação, através do cod_tipo_origem_arq_import da consulta principal }
      Query.Close;
      Query.SQL.Text := 'select sgl_tipo_origem_arq_import, des_tipo_origem_arq_import from tab_tipo_origem_arq_import ' +
                ' where cod_tipo_origem_arq_import = :cod_tipo_origem ';
      Query.ParamByName('cod_tipo_origem').AsInteger := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      Query.Open;
      FIntImportacao.SglTipoOrigemArqImport := Query.FieldByName('sgl_tipo_origem_arq_import').AsString;
      FIntImportacao.DesTipoOrigemArqImport := Query.FieldByName('des_tipo_origem_arq_import').AsString;

      {Busca informação da descrição da situação do arquivo de importação, através do CodSituacaoArqImport da consulta principal }
      Query.Close;
      Query.SQL.Text := 'select des_situacao_arq_import from tab_situacao_arq_import ' +
                ' where cod_situacao_arq_import = :cod_situacao ';
      Query.ParamByName('cod_situacao').AsString := Q.FieldByName('CodSituacaoArqImport').AsString;
      Query.Open;
      FIntImportacao.DesSituacaoArqImport := Query.FieldByName('des_situacao_arq_import').AsString;

      // Obtem informações do registro
      FIntImportacao.CodPessoaProdutor := Q.FieldByName('CodPessoaProdutor').AsInteger;
      FIntImportacao.SglProdutor := Q.FieldByName('SglProdutor').AsString;
      FIntImportacao.NomPessoaProdutor := Q.FieldByName('NomPessoaProdutor').AsString;
      FIntImportacao.NumCNPJCPFFormatadoProdutor := Q.FieldByName('NumCNPJCPFFormatadoProdutor').AsString;
      FIntImportacao.CodArquivoImportacao := Q.FieldByName('CodArquivoImportacao').AsInteger;
      FIntImportacao.NomArquivoImportacao := Q.FieldByName('NomArquivoImportacao').AsString;
      FIntImportacao.NomUsuarioUpload := Q.FieldByName('LoginUsuarioUpload').AsString;
      FIntImportacao.NomArquivoUpload := Q.FieldByName('NomArquivoUpload').AsString;
      FIntImportacao.DtaImportacao := Q.FieldByName('DtaImportacao').AsDateTime;
      FIntImportacao.QtdVezesProcessamento := Q.FieldByName('QtdVezesProcessamento').AsInteger;
      FIntImportacao.DtaUltimoProcessamento := Q.FieldByName('DtaUltimoProcessamento').AsDateTime;
      FIntImportacao.QtdLinhas := Q.FieldByName('NumLinhas').AsInteger;
      FIntImportacao.CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      FIntImportacao.CodSituacaoArqImport := Q.FieldByName('CodSituacaoArqImport').AsString;
      FIntImportacao.CodUsuarioUpload := Q.FieldByName('CodUsuarioUpload').AsInteger;

      Query.Close;
      Query.SQL.Text := 'select '+
        '  ta.cod_situacao_tarefa as CodSituacaoUltimaTarefa ' +
        ' , ts.des_situacao_tarefa as DesSituacaoUltimaTarefa ' +
        ' , dta_inicio_previsto as DtaInicioPrevistoUltimaTarefa '+
        ' , dta_inicio_real as DtaInicioRealUltimaTarefa '+
        ' , dta_fim_real as DtaFimRealUltimaTarefa '+
        '    from '+
        '      tab_tarefa ta, tab_situacao_tarefa ts '+
        '    where cod_tarefa = :cod_ultima_tarefa '+
        '         and ta.cod_situacao_tarefa = ts.cod_situacao_tarefa ';
      Query.ParamByName('cod_ultima_tarefa').AsInteger := Q.FieldByName('CodUltimaTarefa').AsInteger;
      Query.Open;

      //obtem informações do registro de Tarefas
      FIntImportacao.CodUltimaTarefa := Q.FieldByName('CodUltimaTarefa').AsInteger;
      FIntImportacao.CodSituacaoUltimaTarefa := Query.FieldByName('CodSituacaoUltimaTarefa').AsString;
      FIntImportacao.DesSituacaoUltimaTarefa := Query.FieldByName('DesSituacaoUltimaTarefa').AsString;
      FIntImportacao.DtaInicioPrevistoUltimaTarefa := Query.FieldByName('DtaInicioPrevistoUltimaTarefa').AsDateTime;
      FIntImportacao.DtaInicioRealUltimaTarefa := Query.FieldByName('DtaInicioRealUltimaTarefa').AsDateTime;
      FIntImportacao.DtaFimRealUltimaTarefa := Query.FieldByName('DtaFimRealUltimaTarefa').AsDateTime;

      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_total as QtdTotal '+
        '  , qtd_processadas as QtdProcessadas '+
        '  , qtd_erradas as QtdErradas '+
        'from '+
        '  tab_quantidade_tipo_linha '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
        '  and cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      {Obtendo quantidade de linhas de RM´s a serem inseridos}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 1;
      Q.Open;
      FIntImportacao.QtdRMProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdRMTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdRMErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de animais a serem inseridos}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 2;
      Q.Open;
      FIntImportacao.QtdAnimaisInsercaoProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdAnimaisInsercaoTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdAnimaisInsercaoErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de animais a serem alterados}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 3;
      Q.Open;
      FIntImportacao.QtdAnimaisAlteracaoProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdAnimaisAlteracaoTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdAnimaisAlteracaoErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de animais a serem associados a RM´s}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 4;
      Q.Open;
      FIntImportacao.QtdTourosRMProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdTourosRMTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdTourosRMErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de eventos a serem inseridos}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 5;
      Q.Open;
      FIntImportacao.QtdEventosProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdEventosTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdEventosErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de animais a serem associados a eventos}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 6;
      Q.Open;
      FIntImportacao.QtdAnimaisEventosProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdAnimaisEventosTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdAnimaisEventosErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de composição racial de animais}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 7;
      Q.Open;
      FIntImportacao.QtdCRacialProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdCRacialTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdCRacialErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
      {Obtendo quantidade de linhas de inventários de animais a serem inseridos}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 9;
      Q.Open;
      FIntImportacao.QtdInventariosAnimaisProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacao.QtdInventariosAnimaisTotal := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacao.QtdInventariosAnimaisErro := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;

      if FIntImportacao.QtdVezesProcessamento > 0 then begin
        {Otendo quantidade de linhas com erro}
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasComErro '+
          'from '+
          '  tab_ocorrencia_processamento '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
          '  and cod_tipo_mensagem in (1, 3) ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := FIntImportacao.CodPessoaProdutor;
        Q.ParamByName('cod_arquivo_importacao').AsInteger := FIntImportacao.CodArquivoImportacao;
        Q.Open;
        FIntImportacao.QtdOcorrencias := Q.FieldByName('NumLinhasComErro').AsInteger;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1241, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1241;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.BuscarAutenticacao(
  CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 490;
  NomeMetodo: String = 'BuscarAutenticacao';
var
  Q: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try


      Q.Close;
      {Montando query de pesquisa de acordo com os críterios informados}
      Q.SQL.Text :=
        'select '+
        '  taa.cod_arquivo_importacao as CodArquivoImportacao '+
        '  , taa.nom_arquivo_importacao as NomArquivoImportacao '+
        '  , taa.dta_importacao as DtaImportacao '+
        '  , tu.nom_usuario as LoginUsuarioUpload '+
        '  , taa.nom_arquivo_upload as NomArquivoUpload '+
        '  , taa.qtd_vezes_processamento as QtdVezesProcessamento '+
        '  , taa.dta_ultimo_processamento as DtaUltimoProcessamento '+
        '  , taa.num_linhas as NumLinhas '+
        'from '+
        '  tab_arquivo_autenticacao taa '+
        '  , tab_usuario tu '+
        'where '+
        '  tu.cod_usuario = taa.cod_usuario '+
        '  and taa.cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;

      // Obtem informações do registro
      FIntImportacao.CodPessoaProdutor := 0;
      FIntImportacao.SglProdutor := '';
      FIntImportacao.NomPessoaProdutor := '';
      FIntImportacao.NumCNPJCPFFormatadoProdutor := '';
      FIntImportacao.CodArquivoImportacao := Q.FieldByName('CodArquivoImportacao').AsInteger;
      FIntImportacao.NomArquivoImportacao := Q.FieldByName('NomArquivoImportacao').AsString;
      FIntImportacao.NomUsuarioUpload := Q.FieldByName('LoginUsuarioUpload').AsString;
      FIntImportacao.NomArquivoUpload := Q.FieldByName('NomArquivoUpload').AsString;
      FIntImportacao.DtaImportacao := Q.FieldByName('DtaImportacao').AsDateTime;
      FIntImportacao.QtdVezesProcessamento := Q.FieldByName('QtdVezesProcessamento').AsInteger;
      FIntImportacao.DtaUltimoProcessamento := Q.FieldByName('DtaUltimoProcessamento').AsDateTime;
      FIntImportacao.QtdLinhas := Q.FieldByName('NumLinhas').AsInteger;
      FIntImportacao.QtdRMProcessados := 0;
      FIntImportacao.QtdRMTotal := 0;
      FIntImportacao.QtdRMErro := 0;
      FIntImportacao.QtdAnimaisInsercaoProcessados := 0;
      FIntImportacao.QtdAnimaisInsercaoTotal := 0;
      FIntImportacao.QtdAnimaisInsercaoErro := 0;
      FIntImportacao.QtdAnimaisAlteracaoProcessados := 0;
      FIntImportacao.QtdAnimaisAlteracaoTotal := 0;
      FIntImportacao.QtdAnimaisAlteracaoErro := 0;
      FIntImportacao.QtdTourosRMProcessados := 0;
      FIntImportacao.QtdTourosRMTotal := 0;
      FIntImportacao.QtdTourosRMErro := 0;
      FIntImportacao.QtdEventosProcessados := 0;
      FIntImportacao.QtdEventosTotal := 0;
      FIntImportacao.QtdEventosErro := 0;
      FIntImportacao.QtdAnimaisEventosProcessados := 0;
      FIntImportacao.QtdAnimaisEventosTotal := 0;
      FIntImportacao.QtdAnimaisEventosErro := 0;
      FIntImportacao.QtdCRacialProcessados := 0;
      FIntImportacao.QtdCRacialTotal := 0;
      FIntImportacao.QtdCRacialErro := 0;

      Q.Close;
      FIntImportacao.QtdOcorrencias := 0;
      if FIntImportacao.QtdVezesProcessamento > 0 then begin
        {Otendo quantidade de linhas com erro}
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasComErro '+
          'from '+
          '  tab_ocorrencia_autenticacao '+
          'where '+
          '  cod_arquivo_importacao = :cod_arquivo_importacao '+
          '  and cod_tipo_mensagem = 1 ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := FIntImportacao.CodArquivoImportacao;
        Q.Open;
        FIntImportacao.QtdOcorrencias := Q.FieldByName('NumLinhasComErro').AsInteger;
        {Otendo quantidade de linhas total do log}
        {Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasLog '+
          'from '+
          '  tab_ocorrencia_autenticacao '+
          'where '+
          '  cod_arquivo_importacao = :cod_arquivo_importacao ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := FIntImportacao.CodArquivoImportacao;
        Q.Open;
        FIntImportacao.NumLinhasLog := Q.FieldByName('NumLinhasLog').AsInteger;
        Q.Close;
        }
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1599, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1599;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.Excluir(CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 390;
  NomeMetodo: String = 'Excluir';
var
  Q: THerdomQuery;
  sArquivo: String;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
     Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
     Result := -188;
     Exit;
  end;


  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try


      // Recupera a pasta onde os arquivos são armazenados
      sArquivo := ValorParametro(38);
      if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
        sArquivo := sArquivo + '\';
      end;

      // Consiste existência do arquivo
      Q.SQL.Text :=
        'select nom_arquivo_importacao from tab_arquivo_importacao where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('nom_arquivo_importacao').AsString;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Text :=
        'delete from tab_ocorrencia_processamento where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_quantidade_tipo_linha where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '   cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_linha_arquivo_importacao where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '   cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_evento_arquivo_importacao where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_arquivo_importacao where '+
        ' cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '   cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Verifica existe do arquivo, e caso exista, o exclui
      DeleteFile(sArquivo);

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1244, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1244;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ExcluirAutenticacao(
  CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 491;
  NomeMetodo: String = 'ExcluirAutenticacao';
var
  Q: THerdomQuery;
  sArquivo: String;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try


      // Recupera a pasta onde os arquivos são armazenados
      sArquivo := Conexao.CaminhoArquivosCertificadora + ValorParametro(64);
      if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
        sArquivo := sArquivo + '\';
      end;

      // Consiste existência do registro
      Q.SQL.Text :=
        'select nom_arquivo_importacao from tab_arquivo_autenticacao '+
        'where cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('nom_arquivo_importacao').AsString;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Text :=
        'delete from tab_ocorrencia_autenticacao '+
        'where cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_quantidade_tipo_linha_aut '+
        'where cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_linha_arquivo_autenticacao '+
        'where cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_arquivo_autenticacao '+
        'where cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Verifica existe do arquivo, e caso exista, o exclui
      DeleteFile(sArquivo);

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1600, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1600;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.ProcessarArquivo(CodArquivoImportacao, LinhaInicial,
  TempoMaximo: Integer): Integer;
const
  Metodo: Integer = 384;
  NomeMetodo: String = 'ProcessarArquivo';
  CodTipoTarefa: Integer = 1;
var
  Q: THerdomQuery;
  sAux: String;
  tDtaInicioPrevisto, tHorarioAgNoturno: TDateTime;
  iNumLinhas, CodTipoOrigemArqImport, iNumLinhasMinimoAgImediato, iNumLinhasMinimoAgNoturno: Integer;
  isInventario: Boolean;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
     Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
     Result := -188;
     Exit;
  end;

  // Verifica se produtor de trabalho foi definido
//  Conexao.DefinirProdutorTrabalho(3, sAux); //definição "forçada" para testes
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Consiste existência do arquivo informado, obtendo a qtd de linhas do mesmo
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_linhas as NumLinhas '+
        ', cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
        ', cod_situacao_arq_import as CodSituacaoArqImport '+
        'from '+
        '  tab_arquivo_importacao tai '+
        'where '+
        '  tai.cod_pessoa_produtor = :cod_pessoa_produtor and '+
        '  tai.cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('NumLinhas').AsInteger = 0) or (Q.FieldByName('CodSituacaoArqImport').AsString = 'I') then begin
        Mensagens.Adicionar(1343, Self.ClassName, NomeMetodo, []);
        Result := -1343;
        Exit;
      end;
      iNumLinhas := Q.FieldByName('NumLinhas').AsInteger;
      CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      Q.Close;

      // Verifica se é um arquivo de inventário, se for possui linhas do tipo 9
      Q.SQL.Clear;
      Q.SQL.Add('select isnull(sum(qtd_total), 0) as qtd_inventario ');
      Q.SQL.Add('  from tab_quantidade_tipo_linha ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_arquivo_importacao = :cod_arquivo_importacao ');
      Q.SQL.Add('   and cod_tipo_linha_importacao = 9');  // inventário de animais

      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;

      if Q.IsEmpty or (Q.FieldByName('qtd_inventario').AsInteger = 0) then begin
        isInventario := false;
      end else begin
        isInventario := true;
      end;

      // Otendo parametros para identifícação do tipo do processamento
      iNumLinhasMinimoAgImediato := StrToIntDef(ValorParametro(41), 1000);
      iNumLinhasMinimoAgNoturno := StrToIntDef(ValorParametro(42), 5000);
      sAux := ValorParametro(43);
      tHorarioAgNoturno := EncodeTime(
        StrToIntDef(Copy(sAux, 1, 2), 22),
        StrToIntDef(Copy(sAux, 4, 2), 0),
        StrToIntDef(Copy(sAux, 7, 2), 0),
        0);
      tDtaInicioPrevisto := DtaSistema;

      if (CodTipoOrigemArqImport = 2) and (not isInventario) then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
        [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo]);
        if Result <= 0 then begin
          if Result = 0 then begin
            Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
            Result := -1344;
          end;
          Exit;
        end;

          if iNumLinhas >= iNumLinhasMinimoAgNoturno then begin
                // Realiza o agendamento da tarefa para horário noturno
                tDtaInicioPrevisto := Trunc(tDtaInicioPrevisto) + tHorarioAgNoturno;
          end;

        // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
        Result := SolicitarAgendamentoTarefa(CodTipoTarefa,
          [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          AtualizarTarefa(CodArquivoImportacao, Result);
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      // Identificando o tipo de processamento a ser realizado
      end else if (iNumLinhas >= iNumLinhasMinimoAgNoturno) and (not isInventario) then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
        [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo]);
        if Result <= 0 then begin
          if Result = 0 then begin
            Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
            Result := -1344;
          end;
          Exit;
        end;

        // Realiza o agendamento da tarefa para horário noturno
        tDtaInicioPrevisto := Trunc(tDtaInicioPrevisto) + tHorarioAgNoturno;
        Result := SolicitarAgendamentoTarefa(CodTipoTarefa,
          [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          AtualizarTarefa(CodArquivoImportacao, Result);
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      end else if (iNumLinhas >= iNumLinhasMinimoAgImediato) and (not isInventario) then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
          [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo]);
        if Result <= 0 then begin
          if Result = 0 then begin
            Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
            Result := -1344;
          end;
          Exit;
        end;

        // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
        Result := SolicitarAgendamentoTarefa(CodTipoTarefa,
          [Conexao.CodProdutorTrabalho, CodArquivoImportacao, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          AtualizarTarefa(CodArquivoImportacao, Result);
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      end else begin
        // Processando agora
        FProcesso := TThrProcessarArquivo.CreateTarefa(-1, Conexao, Mensagens,
          CodArquivoImportacao, LinhaInicial, TempoMaximo);
        try
          // Aguarda o fim do processamento
          FProcesso.WaitFor;

          // Obtem o resultado do processamento
          Result := FProcesso.ReturnValue;
        finally
          FProcesso.Free;
        end;
      end;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1284, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1284;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoes.PesquisarOcorrenciasProcessamento(
  CodArquivoImportacao, CodTipoLinhaImportacao,
  CodTipoMensagem: Integer): Integer;
const
  Metodo: Integer = 385;
  NomeMetodo: String = 'PesquisarOcorrenciasProcessamento';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;  

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  toc.cod_pessoa_produtor as CodPessoaProdutor '+
      '  , toc.num_linha as NumLinha '+
      '  , toc.txt_mensagem as TxtMensagem '+
      '  , toc.cod_reprodutor_multiplo_manejo as CodReprodutorMultiploManejo '+
      '  , te.sgl_especie as SglEspecie '+
      '  , toc.cod_evento as CodEvento '+
      '  , toc.cod_animal as CodAnimal '+
      '  , toc.dta_aplicacao_evento as DtaAplicacaoEvento '+
      '  , toc.des_apelido as DesApelido '+
      '  , toc.cod_fazenda_manejo as CodFazendaManejo '+
      '  , toc.sgl_fazenda_manejo as SglFazendaManejo '+
      '  , toc.cod_animal_manejo as CodAnimalManejo '+
      '  , toc.cod_animal_certificadora as CodAnimalCertificadora '+
      '  , toc.cod_situacao_sisbov as CodSituacaoSisbov '+
      '  , tss.des_situacao_sisbov as DesSituacaoSisbov '+
      '  , toc.cod_pais_sisbov as CodPaisSisbov '+
      '  , toc.cod_estado_sisbov as CodEstadoSisbov '+
      '  , toc.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov '+
      '  , toc.cod_animal_sisbov as CodAnimalSisbov '+
      '  , toc.num_dv_sisbov as NumDVSisbov '+
      '  , toc.cod_raca as CodRaca '+
      '  , tr.sgl_raca as SglRaca '+
      '  , toc.ind_sexo as IndSexo '+
      '  , toc.cod_tipo_origem as CodTipoOrigem '+
      '  , tto.sgl_tipo_origem as SglTipoOrigem '+
      '  , toc.cod_categoria_animal as CodCategoriaAnimal '+
      '  , tca.sgl_categoria_animal as SglCategoriaAnimal '+
      '  , toc.cod_local_corrente as CodLocalCorrente '+
      '  , tlc.sgl_local as SglLocalCorrente '+
      '  , toc.cod_lote_corrente as CodLoteCorrente '+
      '  , tlt.sgl_lote as SglLoteCorrente '+
      '  , toc.cod_tipo_lugar as CodTipoLugar '+
      '  , ttl.sgl_tipo_lugar as SglTipoLugar '+
      '  , toc.qtd_peso_animal as QtdPesoAnimal '+
      '  , toc.dta_inicio_evento as DtaInicioEvento '+
      '  , tte.des_tipo_evento as DesTipoEvento '+
      '  , toc.txt_dados as TxtDados '+
      '  , ttli.des_tipo_linha_importacao as DesTipoLinhaImportacao '+
      '  , dbo.fnt_idade_animal(toc.cod_animal, toc.cod_pessoa_produtor, getdate()) as IdadeAnimal ' +
      'from '+
      '  tab_ocorrencia_processamento toc '+
      '  , tab_especie te '+
      '  , tab_situacao_sisbov tss '+
      '  , tab_raca tr '+
      '  , tab_tipo_origem tto '+
      '  , tab_categoria_animal tca '+
      '  , tab_local tlc '+
      '  , tab_lote tlt '+
      '  , tab_tipo_evento tte '+
      '  , tab_tipo_lugar ttl '+
      '  , tab_tipo_linha_importacao ttli '+
      'where '+
{$IFDEF MSSQL}
      '  toc.cod_especie *= te.cod_especie '+
      '  and toc.cod_situacao_sisbov *= tss.cod_situacao_sisbov '+
      '  and toc.cod_raca *= tr.cod_raca '+
      '  and toc.cod_tipo_origem *= tto.cod_tipo_origem '+
      '  and toc.cod_categoria_animal *= tca.cod_categoria_animal '+
      '  and toc.cod_pessoa_produtor *= tlc.cod_pessoa_produtor '+
      '  and toc.cod_local_corrente *= tlc.cod_local '+
      '  and toc.cod_pessoa_produtor *= tlt.cod_pessoa_produtor '+
      '  and toc.cod_lote_corrente *= tlt.cod_lote '+
      '  and toc.cod_tipo_evento *= tte.cod_tipo_evento '+
      '  and toc.cod_tipo_lugar *= ttl.cod_tipo_lugar '+
      '  and toc.cod_tipo_linha_importacao *= ttli.cod_tipo_linha_importacao '+
{$ENDIF}
      '  and toc.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and toc.cod_arquivo_importacao = :cod_arquivo_importacao ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;

    if CodTipoLinhaImportacao <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    end;

    if CodTipoMensagem <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_mensagem = :cod_tipo_mensagem ';
      Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
    end;

    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  SglFazendaManejo '+
      '  , CodAnimalManejo ';
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1317, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1317;
      Exit;
    end;
  end;
end;

function TIntImportacoes.PesquisarAutenticacao(DtaImportacaoInicio,
  DtaImportacaoFim, DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime; LoginUsuario,
  IndErrosNoProcessamento, IndArquivoProcessado: String): Integer;
const
  Metodo: Integer = 489;
  NomeMetodo: String = 'PesquisarAutenticacao';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.Close;
    {Montando query de pesquisa de acordo com os críterios informados}
    Query.SQL.Text :=
      'select '+
      '  taa.cod_arquivo_importacao as CodArquivoImportacao '+
      '  , taa.nom_arquivo_importacao as NomArquivoImportacao '+
      '  , taa.nom_arquivo_upload as NomArquivoUpload '+
      '  , tu.nom_usuario as LoginUsuarioUpload '+
      '  , taa.dta_importacao as DtaImportacao '+
      '  , taa.dta_ultimo_processamento as DtaUltimoProcessamento '+
{$IFDEF MSSQL}
      '  , case when tp.cod_arquivo_importacao is null then '+
      '      0 '+
      '    else '+
      '      count(1) '+
      '    end as NumLinhasComErro '+
{$ENDIF}
      'from '+
      '  tab_arquivo_autenticacao taa '+
      '  , tab_ocorrencia_autenticacao tp '+
      '  , tab_usuario tu '+
      'where '+
{$IFDEF MSSQL}
      '  tp.cod_arquivo_importacao =* taa.cod_arquivo_importacao '+
{$ENDIF}
      '  and tu.cod_usuario = taa.cod_usuario ';
    if (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and taa.dta_importacao >= :dta_importacao_inicio ' +
        '  and taa.dta_importacao < :dta_importacao_fim ';
      Query.ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
      Query.ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim)+1;
    end;
    if (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and taa.dta_ultimo_processamento >= :dta_ultimo_processamento_inicio '+
        '  and taa.dta_ultimo_processamento < :dta_ultimo_processamento_fim ';
      Query.ParamByName('dta_ultimo_processamento_inicio').AsDateTime := Trunc(DtaUltimoProcessamentoInicio);
      Query.ParamByName('dta_ultimo_processamento_fim').AsDateTime := Trunc(DtaUltimoProcessamentoFim)+1;
    end;
    if LoginUsuario <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tu.nom_usuario like :nom_usuario ';
      Query.ParamByName('nom_usuario').AsString := LoginUsuario + #37;
    end;
    if (IndArquivoProcessado = 'S') or (IndErrosNoProcessamento = 'S')
      or (IndErrosNoProcessamento = 'N') then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and taa.qtd_vezes_processamento > 0 ';
    end else if IndArquivoProcessado = 'N' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and taa.qtd_vezes_processamento = 0 ';
    end;
    Query.SQL.Text := Query.SQL.Text +
      'group by '+
      '  taa.cod_arquivo_importacao '+
      '  , taa.nom_arquivo_importacao '+
      '  , taa.nom_arquivo_upload '+
      '  , tu.nom_usuario '+
      '  , taa.dta_importacao '+
      '  , taa.dta_ultimo_processamento '+
      '  , tp.cod_arquivo_importacao ';
    if IndErrosNoProcessamento = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        'having '+
        '  tp.cod_arquivo_importacao is not null ';
    end else if IndErrosNoProcessamento = 'N' then begin
      Query.SQL.Text := Query.SQL.Text +
        'having '+
        '  tp.cod_arquivo_importacao is null ';
    end;
    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  taa.dta_importacao desc ';
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1598, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1598;
      Exit;
    end;
  end;
end;

procedure InterpretaLinhaArquivoAutenticacao(Owner: TArquivoPosicionalLeitura);
type
  TCampo = record
    Posicao: Integer;
    Tamanho: Integer;
  end;
const
  // Linha tipo 0
  Linha0: Array [0..2] of TCampo = (
    (Posicao: 2; Tamanho: 6),
    (Posicao: 8; Tamanho: 8),
    (Posicao: 16; Tamanho: 14));

  // Linha tipo 1
  Linha1: Array [0..1] of TCampo = (
    (Posicao: 2; Tamanho: 20),
    (Posicao: 22; Tamanho: 50));

  // Linha tipo 2
  Linha2: Array [0..1] of TCampo = (
    (Posicao: 2; Tamanho: 14),
    (Posicao: 297; Tamanho: 32));
    
  // Linha tipo 9
  Linha9: Array [0..3] of TCampo = (
    (Posicao: 2; Tamanho: 1),
    (Posicao: 3; Tamanho: 6),
    (Posicao: 9; Tamanho: 1),
    (Posicao: 10; Tamanho: 6));

var
  sAux: String;

  procedure AdicionarCampos(Campos: Array of TCampo);
  var
    iAux: Integer;
  begin
    for iAux := Low(Campos) to High(Campos) do begin
      sAux := Copy(Owner.LinhaTexto, Campos[iAux].Posicao, Campos[iAux].Tamanho);
      Owner.AdicionarColuna(sAux);
    end;
  end;

begin
  // Limpa campos carregados anteriormente
  Owner.LimparColunas;

  // Verifica se existem dados para serem alterados
  if Trim(Owner.LinhaTexto) = '' then begin
    exit;
  end;

  // Identifica tipo da linha
  Owner.TipoLinha := StrToIntDef(Copy(Owner.LinhaTexto, 1, 1), 0);

  // Define colunas disponíveis
  case Owner.TipoLinha of
    0:
      AdicionarCampos(Linha0);
    1:
      AdicionarCampos(Linha1);
    2:
      AdicionarCampos(Linha2);
    9:
      AdicionarCampos(Linha9);
  end;
end;

function TIntImportacoes.PesquisarTipoArquivoImportacaoSisBov;
Const
  CodMetodo : Integer = 510;
  NomMetodo : String = 'PesquisarTipoArquivoImportacaoSisBov';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('Select ' +
                '     cod_tipo_arq_import_sisbov CodImportacao' +
                '   , sgl_tipo_arq_import_sisbov SglImportacao' +
                '   , des_tipo_arq_import_sisbov DesImportacao' +
                'from ' +
                '   tab_tipo_arq_import_sisbov ' +
                'Order by ' +
                '   des_tipo_arq_import_sisbov ');
  {$ENDIF}
  try
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1685, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1685;
      Exit;
    end;
  end;
end;

function TIntImportacoes.ProcessarAutenticacao(
  CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 487;
  NomeMetodo: String = 'ProcessarAutenticacao';

  // Atributos de Animais
  aaCodAnimalSisbov: Integer = 1;
  aaCodAutenticacaoSisbov: Integer = 2;
var
  Q: THerdomQuery;
  Processamento: TProcessamento;
  Arquivo: TArquivoPosicionalLeitura;
  iLinhasPercorridas: Integer;
  NomArquivoImportacao: String;
  DtaProcessamento: TDateTime;

  { Verifica se o registro informado é válido }
  function VerificarRegistro: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  nom_arquivo_importacao as NomArquivoImportacao '+
      'from '+
      '  tab_arquivo_autenticacao tai '+
      'where '+
      '  cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(1285, Self.ClassName, NomeMetodo, []);
      Result := -1285;
    end else begin
      NomArquivoImportacao := Q.FieldByName('NomArquivoImportacao').AsString;
      Result := 0;
    end;
    Q.Close;
  end;

  { Verifica se ainda existem linhas do arquivo a serem processadas }
  function VerificarStatus: Integer;
  var
    iiAux: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  count(1) as NumLinhas '+
      'from '+
      '  tab_linha_arquivo_autenticacao tlai '+
      'where '+
      '  tlai.cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.Open;
    iiAux := Q.FieldByName('NumLinhas').AsInteger;
    if iiAux = 0 then begin
      Result := 0;
    end else begin
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  sum(qtd_total) as NumLinhasAProcessar '+
        'from '+
        '  tab_quantidade_tipo_linha_aut tqtl '+
        'where '+
        '  cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;
      if iiAux < Q.FieldByName('NumLinhasAProcessar').AsInteger then begin
        Result := 0;
      end else begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasAProcessar '+
          'from '+
          '  tab_linha_arquivo_autenticacao tlai '+
          'where '+
          '  tlai.dta_processamento is null '+
          '  and tlai.cod_arquivo_importacao = :cod_arquivo_importacao '+
          'group by '+
          '  tlai.cod_arquivo_importacao ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
        Q.Open;
        if Q.FieldByName('NumLinhasAProcessar').AsInteger = 0 then begin
          Mensagens.Adicionar(1286, Self.ClassName, NomeMetodo, []);
          Result := -1286;
        end else begin
          Result := 0;
        end;
      end;
    end;
    Q.Close;
  end;

  { Verifica existência física do arquivo em disco }
  function VerificarArquivo: Integer;
  var
    sArquivo: String;
  begin
    // Obtem a pasta onde os arquivo estão armazenados
    sArquivo := Conexao.CaminhoArquivosCertificadora + Conexao.ValorParametro(64, Mensagens);
    if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
      sArquivo := sArquivo + '\';
    end;

    // Consiste existência da pasta
    if not DirectoryExists(sArquivo) then begin
      Mensagens.Adicionar(1596, Self.ClassName, NomeMetodo, []);
      Result := -1596;
      Exit;
    end;

    // Consiste existência do arquivo
    sArquivo := sArquivo + NomArquivoImportacao;
    if not FileExists(sArquivo) then begin
      Mensagens.Adicionar(1597, Self.ClassName, NomeMetodo, [NomArquivoImportacao]);
      Result := -1597;
      Exit;
    end;

    // Passo bem sucedido
    NomArquivoImportacao := sArquivo;
    Result := 0;
  end;

  { Incrementa o contador de vezes que o arquivo foi processado }
  procedure IncrementarQtdVezesProcessamento;
  begin
    // Incrementa o contador de vezes de processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_arquivo_autenticacao '+
      '   set qtd_vezes_processamento = qtd_vezes_processamento + 1 '+
      '     , dta_ultimo_processamento = :dta_ultimo_processamento '+
      ' where cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('dta_ultimo_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;

    // Zera o número de erros obtidos durante o último processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_quantidade_tipo_linha_aut '+
      'set '+
      '  qtd_erradas = 0 '+
      'where '+
      '  cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Limpa as ocorrências obtidas no último processamento }
  procedure LimparOcorrenciaProcessamento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'delete from tab_ocorrencia_autenticacao '+
      ' where cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Guarda ocorrências durante o processamento }
  function GravarOcorrenciaProcessamento: Integer;
  var
    iiAux, jjAux: Integer;
  begin
    if Mensagens.Count > 0 then begin
      Q.Close;

      // Script SQL de inseração de ocorrência durante o processamento
      Q.SQL.Text :=
        'insert into tab_ocorrencia_autenticacao '+
        ' (cod_arquivo_importacao '+
        '  , dta_processamento '+
        '  , cod_tipo_linha_importacao '+
        '  , cod_tipo_mensagem '+
        '  , txt_mensagem '+
        '  , num_linha '+
        '  , txt_observacao '+
        '  , cod_pais_sisbov '+
        '  , cod_estado_sisbov '+
        '  , cod_micro_regiao_sisbov '+
        '  , cod_animal_sisbov '+
        '  , num_dv_sisbov) '+
        'values '+
        ' (:cod_arquivo_importacao '+
        '  , :dta_processamento '+
        '  , :cod_tipo_linha_importacao '+
        '  , :cod_tipo_mensagem '+
        '  , :txt_mensagem '+
        '  , :num_linha '+
        '  , :txt_observacao '+
        '  , :cod_pais_sisbov '+
        '  , :cod_estado_sisbov '+
        '  , :cod_micro_regiao_sisbov '+
        '  , :cod_animal_sisbov '+
        '  , :num_dv_sisbov ) ';

      // Dados de identicação do arquivo e linha
      // Constantes a todos os tipos de ocorrências
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := Arquivo.TipoLinha;
      Q.ParamByName('num_linha').AsInteger := Arquivo.LinhasLidas;

      // Tipos dos dados de identificação da ocorrência
      // Variável de acordo com o tipo da linha
      Q.ParamByName('txt_mensagem').DataType := ftString;
      Q.ParamByName('txt_observacao').DataType := ftString;
      Q.ParamByName('cod_pais_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_estado_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_micro_regiao_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_animal_sisbov').DataType := ftInteger;
      Q.ParamByName('num_dv_sisbov').DataType := ftInteger;

      for iiAux := 0 to Mensagens.Count-1 do begin
        // Verifica se a ocorrência é um erro fatal
        if (Mensagens.Items[iiAux].Tipo = 2) and (Mensagens.Items[iiAux].Codigo <> 188) then begin
          Result := -1*Mensagens.Items[iiAux].Codigo;
          Conexao.Rollback;
          Exit;
        end;

        // Limpa os parâmetros de identificação da ocorrência
        for jjAux := 6 to Q.Params.Count-1 do begin
          Q.Params[jjAux].Clear;
        end;

        try
          // Identificando o tipo da linha onde o erro ocorreu
          case (Arquivo.TipoLinha) of
            2: {Autenticações}
              begin
                  AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), 105);
                  AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 1, 2), 0));
                  if Length(Arquivo.ValorColuna[aaCodAnimalSisbov]) = 14 then begin
                     if Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 3, 2) = '99' then begin
                        AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), 00);
                     end else begin
                        AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 3, 2), 0));
                     end;
                     AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 5, 9), 0));
                     AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 14, 1), 0));
                  end else if Length(Arquivo.ValorColuna[aaCodAnimalSisbov]) = 12 then begin
                     AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), -1);
                     AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 3, 9), 0));
                     AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 12, 1), 0));
                  end;
              end;
          end;
        except
          // Desconsidera o erro, caso algum tenha acontecido
        end;
        Q.ParamByName('cod_tipo_mensagem').AsInteger := Mensagens.Items[iiAux].Tipo;
        Q.ParamByName('txt_mensagem').AsString := Mensagens.Items[iiAux].Texto;
        Q.ExecSQL;
      end;

      // Limpa mensagens geradas durante a última linha de processamento
      Mensagens.Clear;
    end;
    Result := 0;
  end;

  { Cancela o processamento em andamento }
  procedure CancelarProcessamento;
  begin
    // Reabilita ao sistema o controle sobre transações
    Conexao.IgnorarNovasTransacoes := False;
    Conexao.Rollback;
    Arquivo.Finalizar;
  end;

  { Verifica se a linha informada ja foi processada }
  function ProcessarLinha(NumLinha: Integer): Integer;
  begin
    if (Arquivo.NumeroColunas = 0) then begin
      Result := 0;
      Exit;
    end else if Arquivo.TipoLinha in [0, 9] then begin
      Result := 0;
      Exit;
    end;
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  dta_processamento as DtaProcessamento '+
      'from '+
      '  tab_linha_arquivo_autenticacao '+
      'where '+
      '  cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.Open;
    if Q.IsEmpty then begin
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_linha_arquivo_autenticacao '+
        ' (cod_arquivo_importacao '+
        '  , num_linha '+
        '  , dta_processamento) '+
        'values '+
        ' (:cod_arquivo_importacao '+
        '  , :num_linha '+
        '  , null) ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('num_linha').AsInteger := NumLinha;
      Q.ExecSQL;
      Result := 1;
    end else begin
      if Q.FieldByName('DtaProcessamento').IsNull then begin
        Result := 1;
      end else begin
        Result := 0;
      end;
    end;
    Q.Close;
  end;

  { Marca a linha informada como já processada }
  procedure MarcarLinhaComoProcessada(NumLinha: Integer);
  begin
    Q.Close;
    Q.SQL.Text :=
      'update '+
      '  tab_linha_arquivo_autenticacao '+
      'set '+
      '  dta_processamento = :dta_processamento '+
      'where '+
      '  cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.ExecSQL;
  end;

  { Trata resultado da função de processamento }
  function TratarResultadoProcessamento(Resultado: Integer): Integer;
  begin
    if Mensagens.Count > 0 then begin
      Result := GravarOcorrenciaProcessamento;
      if Result < 0 then Exit;
    end;
    if Resultado < 0 then begin
      Result := Processamento.IncErradas(Arquivo.TipoLinha);
    end else begin
      MarcarLinhaComoProcessada(Arquivo.LinhasLidas);
      Result := Processamento.IncProcessadas(Arquivo.TipoLinha);
    end;
  end;

  { Processa arquivo recebido do SISBOV referente a autenticações de animais  }
  function ProcessarAnimais: Integer;
  var
    CodPessoaProdutor, CodAnimal, CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov: Integer;
  begin
    // Consiste inicialmente a quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 2 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Autenticação']);
      Result := -1294;
      Exit;
    end;

    // Recupera a composição individual do código SISBOV do animal
    CodPaisSisbov := 105;
    CodEstadoSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 1, 2), 0);
    CodMicroRegiaoSisbov := -1;
    CodAnimalSisbov := -1;
    NumDvSisbov := -1;
    if Length(Arquivo.ValorColuna[aaCodAnimalSisbov])=14 then begin
       CodMicroRegiaoSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 3, 2), 0);
       CodAnimalSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 5, 9), 0);
       NumDvSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 14, 1), 0);
    end else if Length(Arquivo.ValorColuna[aaCodAnimalSisbov])= 12 then begin
       CodMicroRegiaoSisbov := -1;
       CodAnimalSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 3, 9), 0);
       NumDvSisbov := StrToIntDef(Copy(Arquivo.ValorColuna[aaCodAnimalSisbov], 12, 1), 0);
    end;

    // Testa se a micro regiao é 00, se for muda para 99
//    if CodMicroRegiaoSisbov = 0 then begin
//      CodMicroRegiaoSisbov := 99;
//    end;

    // Identifica o animal pelo código SISBOV retornado
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  cod_pessoa_produtor '+
      '  , cod_animal '+
      '  , cod_autenticacao_sisbov '+
      'from '+
      '  tab_animal ta '+
      '  , tab_categoria_animal tca '+
      'where '+
      '  ta.cod_pais_sisbov = :cod_pais_sisbov '+
      '  and ta.cod_estado_sisbov = :cod_estado_sisbov '+
      '  and ta.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov '+
      '  and ta.cod_animal_sisbov = :cod_animal_sisbov '+
      '  and ta.num_dv_sisbov = :num_dv_sisbov '+
      '  and ta.dta_fim_validade is null '+
      '  and ta.num_dv_sisbov = :num_dv_sisbov '+
      // As autenticações, deverão ser atualizadas para o animal, mesmo que
      // o mesmo esteja desativado.
      //      '  and ta.dta_desativacao is null '+
      //      '  and tca.ind_animal_ativo = ''S'' ';
      //      '  and tca.cod_categoria_animal = ta.cod_categoria_animal '+
      '  and ta.dta_fim_validade is null ';
    Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
    Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
    Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
    Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
    Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(1593, Self.ClassName, NomeMetodo, [Arquivo.ValorColuna[aaCodAnimalSisbov]]);
      Result := -1593;
      Exit;
    end else if Q.FieldByName('cod_autenticacao_sisbov').AsString <> '' then begin
      Mensagens.Adicionar(1594, Self.ClassName, NomeMetodo, [Arquivo.ValorColuna[aaCodAnimalSisbov],
        Q.FieldByName('cod_autenticacao_sisbov').AsString, Arquivo.ValorColuna[aaCodAutenticacaoSisbov]]);
    end;
    CodPessoaProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;
    CodAnimal := Q.FieldByName('cod_animal').AsInteger;

    // Atualiza autenticação SISBOV para o animal identificado
    Q.Close;
    Q.SQL.Text :=
      'update '+
      '  tab_animal '+
      'set '+
      '  cod_autenticacao_sisbov = :cod_autenticacao_sisbov '+
      '  , cod_arq_import_sisbov = :cod_arq_import_sisbov '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_animal = :cod_animal ';
    Q.ParamByName('cod_autenticacao_sisbov').AsString := Arquivo.ValorColuna[aaCodAutenticacaoSisbov];
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
    Q.ParamByName('cod_animal').AsInteger := CodAnimal;
    Q.ExecSQL;

    // Identifica procedimento como bem sucedido
    Result := 0;
  end;

begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    try
      // Inicializa referências para objetos utilizados como nulas
      Q := nil;
      Arquivo := nil;
      Processamento := nil;

      // Instancia classes a serem utilizadas, atribuindo os objetos gerados à
      // suas respectivas referências
      Q := THerdomQuery.Create(Conexao, nil);
      Arquivo := TArquivoPosicionalLeitura.Create;
      Processamento := TProcessamento.Create;

      // Define rotina que interpreta cada linha do arquivo
      Arquivo.RotinaLeitura := InterpretaLinhaArquivoAutenticacao;

      // Consiste registro na base do arquivo informado para o produtor corrente
      Result := VerificarRegistro;
      if Result < 0 then exit;

      // Verifica se o arquivo ainda está disponível para processamento
      Result := VerificarStatus;
      if Result < 0 then exit;

      // Verifica se o arquivo existe fisicamente em disco
      Result := VerificarArquivo;
      if Result < 0 then exit;

      // Obtem a data corrente do sistema (data + hora de processamento)
      DtaProcessamento := Conexao.DtaSistema;

      {Identifica arquivo de upload}
      Arquivo.NomeArquivo := NomArquivoImportacao;

      {Guarda resultado da tentativa de abertura do arquivo}
      Result := Arquivo.Inicializar;

      {Trata possíveis erros durante a tentativa de abertura do arquivo}
      if Result = EArquivoInexistente then begin
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        Result := -1219;
        Exit;
      end else if Result = EInicializarLeitura then begin
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        Result := -1219;
        Exit;
      end else if Result < 0 then begin
        Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
        Result := -1220;
        Exit;
      end;

      // Limpa lista de mensagens geradas pelo sistema
      Mensagens.Clear;

      // Classe que auxilia na totalização de valores do processamento
      Result := Processamento.Inicializar(Conexao, Mensagens);
      if Result < 0 then begin
        CancelarProcessamento;
        Exit;
      end;
      Processamento.TipoArmazenamento := taAutenticacao;
      Processamento.CodArquivoImportacao := CodArquivoImportacao;

      // Abre transação
      Conexao.BeginTran;

      // Incrementa o contador de vezes que o arquivo foi processado
      IncrementarQtdVezesProcessamento;

      // Limpa as ocorrências obtidas no último processamento
      LimparOcorrenciaProcessamento;

      // Confirma transação
      Conexao.Commit;

      // Percorre o arquivo processando somente as linha ainda não processadas
      while (Result >= 0) and (Arquivo.EOF = False) do begin
        Result := Arquivo.ObterLinha; // Obtem linha do arquivo de importação
        if Result < 0 then begin
          Result := -1232;
          Mensagens.Adicionar(-Result, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);
          try
            Conexao.Begintran;
            Result := GravarOcorrenciaProcessamento;
            Conexao.Commit;
          except
            Conexao.Rollback;
          end;
          if Result < 0 then begin
            CancelarProcessamento;
            Exit;
          end else begin
            Continue;
          end;
        end;

        // Verifica se a linha atual deve ser processada
        Result := ProcessarLinha(Arquivo.LinhasLidas);
        if Result < 0 then begin
          CancelarProcessamento;
          Exit;
        end;

        if Result = 1 then begin
          // A linha atual deve ser processada!
          // Abre transação
          Conexao.BeginTran;

          // Identifica o tipo da linha e realiza o processamento adequado
          case (Arquivo.TipoLinha) of
            1: {Informação sobre técnico responsável pela certificadora. O sistema já o conhece}
              Result := 0;
            2: {Autenticações}
              Result := ProcessarAnimais;
          else
            Mensagens.Adicionar(1290, Self.ClassName, NomeMetodo, []);
            Result := -1290;
          end;

          // Verifica se existe uma transação aberto
          if not Conexao.EmTransacao then begin
            Conexao.BeginTran;
          end;

          // Identifica e guarda erro ocorrido
          Result := TratarResultadoProcessamento(Result);

          // Verifica se um erro fatal foi identificado
          if Result < 0 then begin
            CancelarProcessamento;
            Exit;
          end;

          // Cofirma transação
          Conexao.Commit;
        end;
      end;

      // Identifica a quantidade real de linhas percorridas durante a execução do método
      iLinhasPercorridas := Arquivo.LinhasLidas;

      // Finaliza arquivo lido
      Arquivo.Finalizar;

      // Retorna status "ok" do método
      Result := iLinhasPercorridas;
    finally
      if Assigned(Processamento) then Processamento.Free;
      if Assigned(Arquivo) then Arquivo.Free;
      if Assigned(Q) then Q.Free;
    end;
  except
    on E: Exception do begin
      // Reabilita ao sistema o controle sobre transações
      Conexao.IgnorarNovasTransacoes := False;
      Conexao.Rollback;  // desfaz transação se houver uma ativa
      Mensagens.Adicionar(1592, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1592;
      Exit;
    end;
  end;
end;

function TIntImportacoes.PesquisarOcorrenciasAutenticacao(
  CodArquivoImportacao, CodTipoLinhaImportacao,
  CodTipoMensagem: Integer): Integer;
const
  Metodo: Integer = 488;
  NomeMetodo: String = 'PesquisarOcorrenciasAutenticacao';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  toa.dta_processamento as DtaProcessamento '+
      '  , toa.cod_tipo_linha_importacao as CodTipoLinhaImportacao '+
      '  , toa.num_linha as NumLinha '+
      '  , toa.cod_tipo_mensagem as CodTipoMensagem '+
      '  , toa.txt_mensagem as TxtMensagem '+
      '  , toa.cod_pais_sisbov as CodPaisSisbov '+
      '  , toa.cod_estado_sisbov as CodEstadoSisbov '+
      '  , toa.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov '+
      '  , toa.cod_estado_sisbov as CodEstadoSisbov '+
      '  , toa.cod_animal_sisbov as CodAnimalSisbov '+
{$IFDEF MSSQL}
      '  , right(''00'' + cast(toa.cod_estado_sisbov as varchar(2)),2) + '' '' + ' +
      '    case toa.cod_micro_regiao_sisbov when 0 then ' +
      '      ''00 '' + ' +
      '      right(''000000000'' + cast(toa.cod_animal_sisbov as varchar(9)),9) + '' '' + ' +
      '      right(''0'' + cast(toa.num_dv_sisbov as varchar(1)),1) ' +
      '    when -1 then ' +
      '      right(''000000000'' + cast(toa.cod_animal_sisbov as varchar(9)),9) + '' '' + ' +
      '      right(''0'' + cast(toa.num_dv_sisbov as varchar(1)),1) ' +
      '    else ' +
      '      right(''00'' + cast(toa.cod_micro_regiao_sisbov as varchar(2)),2) + '' '' + ' +
      '      right(''000000000'' + cast(toa.cod_animal_sisbov as varchar(9)),9) + '' '' + ' +
      '      right(''0'' + cast(toa.num_dv_sisbov as varchar(1)),1) ' +
      '    end as CodAnimalSisbovFormatado '+
{$ENDIF}
      '  , toa.num_dv_sisbov as NumDvSisbov '+
      '  , toa.txt_observacao as TxtObservacao '+
      'from '+
      '  tab_ocorrencia_autenticacao toa '+
      'where '+
      '  toa.cod_arquivo_importacao = :cod_arquivo_importacao ';
    Query.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;

    if CodTipoLinhaImportacao <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toa.cod_tipo_linha_importacao = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    end;

    if CodTipoMensagem <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toa.cod_tipo_mensagem = :cod_tipo_mensagem ';
      Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
    end;

    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  CodPaisSisbov '+
      '  , CodEstadoSisbov '+
      '  , CodMicroRegiaoSisbov '+
      '  , CodAnimalSisbov ';
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1595, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1595;
      Exit;
    end;
  end;
end;

class function TIntImportacoes.ValidarNIRFIdentificacao(EConexao: TConexao; EMensagem: TIntMensagens;
  ENumImovelReceitaFederal: String; ECodPropriedadeRural, ECodLocalizacaoSisbov,
  ECodPessoaProdutor: Integer; IndVerificaEfetivado: Boolean): Integer;
const
  NomMetodo: String = 'ValidarNIRFIdentificacao';
var
  Qry: THerdomQuery;
  CodPropriedadeRural: Integer;
begin
  if ECodPessoaProdutor <= 0 then
  begin
    EMensagem.Adicionar(2103, Self.ClassName, NomMetodo, []);
    Result := -2103;
    Exit;
  end;

  if (ECodPropriedadeRural > 0) and (ENumImovelReceitaFederal <> '') then
  begin
    EMensagem.Adicionar(-2104, Self.ClassName, NomMetodo, []);
    Result := -2104;
    Exit;
  end;

  try
    Qry := THerdomQuery.Create(EConexao, nil);
    try
      { Caso o NIRF/INCRA seja informado verifica a existência de uma propriedade.
        Caso seja encontrado mais de 1 registro ou nenhum registro para a consulta retornar erro informando-o
        Caso contrário, retornar o cod_propriedade_rural }
      if (Length(Trim(ENumImovelReceitaFederal)) > 0) and (ECodLocalizacaoSisbov > 0) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select tpr.cod_propriedade_rural from tab_propriedade_rural tpr, tab_localizacao_sisbov tls');
        Qry.SQL.Add(' where tpr.cod_propriedade_rural = tls.cod_propriedade_rural ');
        Qry.SQL.Add('   and tpr.num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
        Qry.SQL.Add('   and tpr.dta_fim_validade is null');        
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada nenhuma propriedade rural com o NIRF/INCRA de identificação: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal +
                              SE(ECodLocalizacaoSisbov > 0, ' - código exportação: ' + IntToStr(ECodLocalizacaoSisbov), '')]);
          Result := -2094;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('cod_propriedade_rural').AsInteger;
      end
      else
      if Length(Trim(ENumImovelReceitaFederal)) > 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select num_imovel_receita_federal, count(cod_propriedade_rural) as QtdPropriedade, max(cod_propriedade_rural) as CodPropriedadeRural from tab_propriedade_rural');
        Qry.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and dta_fim_validade is null');
        Qry.SQL.Add('group by num_imovel_receita_federal');
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.Open;

        if Qry.FieldByName('QtdPropriedade').AsInteger = 0 then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada nenhuma propriedade rural com o NIRF/INCRA de identificação: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal +
                              SE(ECodLocalizacaoSisbov > 0, ' - código exportação: ' + IntToStr(ECodLocalizacaoSisbov), '')]);
          Result := -2094;
          Exit;
        end;

        if Qry.FieldByName('QtdPropriedade').AsInteger > 1 then
        begin
          EMensagem.Adicionar('Na inserção do animal, foram encontradas 2 (duas) ou mais propriedades rurais com o NIRF/INCRA de identificação: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal]);
          Result := -2095;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('CodPropriedadeRural').AsInteger;
      end
      else if ECodPropriedadeRural > 0 then
      begin
        CodPropriedadeRural := ECodPropriedadeRural;
      end
      else
      begin
        EMensagem.Adicionar('A propriedade rural não foi informada.', 1, Self.ClassName, NomMetodo, []);
        Result := -2096;
        Exit;
      end;
      { Caso o CodLocalizacaoSisbov tenha sido informado, consistir o par, produtor/propriedade
        verficando-os com o respectivo codigo de localizacao }
      if (ECodLocalizacaoSisbov > 0) or (IndVerificaEfetivado) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select cod_localizacao_sisbov');
        Qry.SQL.Add('  from tab_localizacao_sisbov');
        Qry.SQL.Add(' where (1 = 1)');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.SQL.Add('   and cod_localizacao_sisbov = :cod_localizacao_sisbov');
        end;
        Qry.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        end;
        Qry.ParamByName('cod_pessoa_produtor').AsInteger :=   ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, o código de exportação informado não corresponde a propriedade informada, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, []);
          Result := -2097;
          Exit;
        end;
      end
      else
      begin
        { Caso o CodLocalizacaoSisbov não seja informado, ou esteja pesquisando por uma propriedade não exportada
          é necessário verificar se existe uma fazenda associada a propriedade e ao produtor informado }
        Qry.SQL.Clear;  
        Qry.SQL.Add('select cod_fazenda from tab_fazenda');
        Qry.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        Qry.SQL.Add('   and dta_fim_validade is null');        
        Qry.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada uma fazenda cadastrada para o produtor, para a propriedade rural informada, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, []);
          Result := -2098;
          Exit;
        end;
      end;

      Result := CodPropriedadeRural;
    finally
      qry.Free;
    end;
  except
    on E:Exception do
    begin
      EMensagem.Adicionar(2099, Self.ClassName, NomMetodo, [e.message]);
      Result := -2099;
      Exit;
    end;
  end;
end;

class function TIntImportacoes.ValidarNIRFNascimento(EConexao: TConexao; EMensagem: TIntMensagens;
  ENumImovelReceitaFederal: String; ECodPropriedadeRural, ECodLocalizacaoSisbov,
  ECodPessoaProdutor: Integer; IndVerificaEfetivado: Boolean): Integer;
const
  NomMetodo: String = 'ValidarNIRFNascimento';
var
  Qry: THerdomQuery;
  CodPropriedadeRural: Integer;
begin
  if ECodPessoaProdutor <= 0 then
  begin
    EMensagem.Adicionar(2103, Self.ClassName, NomMetodo, []);
    Result := -2103;
    Exit;
  end;

  if (ECodPropriedadeRural > 0) and (ENumImovelReceitaFederal <> '') then
  begin
    EMensagem.Adicionar(-2104, Self.ClassName, NomMetodo, []);
    Result := -2104;
    Exit;
  end;

  try
    Qry := THerdomQuery.Create(EConexao, nil);
    try
      { Caso o NIRF/INCRA seja informado verifica a existência de uma propriedade.
        Caso seja encontrado mais de 1 registro ou nenhum registro para a consulta retornar erro informando-o
        Caso contrário, retornar o cod_propriedade_rural }
      if (Length(Trim(ENumImovelReceitaFederal)) > 0) and (ECodLocalizacaoSisbov > 0) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select tpr.cod_propriedade_rural from tab_propriedade_rural tpr, tab_localizacao_sisbov tls');
        Qry.SQL.Add(' where tpr.cod_propriedade_rural = tls.cod_propriedade_rural ');
        Qry.SQL.Add('   and tpr.num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
        Qry.SQL.Add('   and tpr.dta_fim_validade is null');        
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada nenhuma propriedade rural com o NIRF/INCRA de nascimento: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal +
                              SE(ECodLocalizacaoSisbov > 0, ' - código exportação: ' + IntToStr(ECodLocalizacaoSisbov), '')]);
          Result := -2094;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('cod_propriedade_rural').AsInteger;
      end
      else
      if Length(Trim(ENumImovelReceitaFederal)) > 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select num_imovel_receita_federal, count(cod_propriedade_rural) as QtdPropriedade, max(cod_propriedade_rural) as CodPropriedadeRural from tab_propriedade_rural');
        Qry.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and dta_fim_validade is null');
        Qry.SQL.Add('group by num_imovel_receita_federal');
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.Open;

        if Qry.FieldByName('QtdPropriedade').AsInteger = 0 then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada nenhuma propriedade rural com o NIRF/INCRA de nascimento: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal +
                              SE(ECodLocalizacaoSisbov > 0, ' - código exportação: ' + IntToStr(ECodLocalizacaoSisbov), '')]);
          Result := -2094;
          Exit;
        end;

        if Qry.FieldByName('QtdPropriedade').AsInteger > 1 then
        begin
          EMensagem.Adicionar('Na inserção do animal, foram encontradas 2 (duas) ou mais propriedades rurais com o NIRF/INCRA de nascimento: %s, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, [ENumImovelReceitaFederal]);
          Result := -2095;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('CodPropriedadeRural').AsInteger;
      end
      else if ECodPropriedadeRural > 0 then
      begin
        CodPropriedadeRural := ECodPropriedadeRural;
      end
      else
      begin
        EMensagem.Adicionar('Na inserção do animal, a propriedade rural não foi informada, entretanto o animal foi inserido com sucesso.', 1, Self.ClassName, NomMetodo, []);
        Result := -2096;
        Exit;
      end;
      { Caso o CodLocalizacaoSisbov tenha sido informado, consistir o par, produtor/propriedade
        verficando-os com o respectivo codigo de localizacao }
      if (ECodLocalizacaoSisbov > 0) or (IndVerificaEfetivado) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select cod_localizacao_sisbov');
        Qry.SQL.Add('  from tab_localizacao_sisbov');
        Qry.SQL.Add(' where (1 = 1)');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.SQL.Add('   and cod_localizacao_sisbov = :cod_localizacao_sisbov');
        end;
        Qry.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        end;
        Qry.ParamByName('cod_pessoa_produtor').AsInteger :=   ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, o código de exportação informado não corresponde a propriedade de nascimento informada, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, []);
          Result := -2097;
          Exit;
        end;
      end
      else
      begin
        { Caso o CodLocalizacaoSisbov não seja informado, ou esteja pesquisando por uma propriedade não exportada
          é necessário verificar se existe uma fazenda associada a propriedade e ao produtor informado }
        Qry.SQL.Clear;  
        Qry.SQL.Add('select cod_fazenda from tab_fazenda');
        Qry.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        Qry.SQL.Add('   and dta_fim_validade is null');        
        Qry.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar('Na inserção do animal, não foi encontrada uma fazenda de nascimento cadastrada para o produtor, para a propriedade rural de nascimentoinformada, entretanto o animal foi inserido com sucesso.', 1,
                              Self.ClassName, NomMetodo, []);
          Result := -2098;
          Exit;
        end;
      end;

      Result := CodPropriedadeRural;
    finally
      qry.Free;
    end;
  except
    on E:Exception do
    begin
      EMensagem.Adicionar(2099, Self.ClassName, NomMetodo, [e.message]);
      Result := -2099;
      Exit;
    end;
  end;
end;

function TIntImportacoes.AtualizarTarefa(ECodArquivoImportacao, ECodTarefa: Integer): Integer;
const
  NomMetodo: String = 'AtualizarTarefa';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      BeginTran;
      with Qry do
      begin
        SQL.Add(' update tab_arquivo_importacao ');
        SQL.Add('    set cod_ultima_tarefa = :cod_tarefa ');
        SQL.Add('  where cod_arquivo_importacao = :cod_arquivo_importacao ');
        ParamByName('cod_tarefa').AsInteger := ECodTarefa;
        ParamByName('cod_arquivo_importacao').AsInteger := ECodArquivoImportacao;
        ExecSQL;

        Commit;

        Result := 0;
      end;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2247, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2247;
        Rollback;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

{ TThrProcessarArquivo }

constructor TThrProcessarArquivo.CreateTarefa(CodTarefa: Integer;
  Conexao: TConexao; Mensagens: TIntMensagens; CodArquivoImportacao,
  LinhaInicial, TempoMaximo: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FCodTarefa := CodTarefa;
  FConexao := Conexao;
  FMensagens := Mensagens;
  FCodArquivoImportacao := CodArquivoImportacao;
  FLinhaInicial := LinhaInicial;
  FTempoMaximo := TempoMaximo;
  Priority := tpLowest;
  Suspended := False;
end;

function TThrProcessarArquivo.ConsistirFazenda(SglFazenda: String;
  var CodFazenda: Integer): Integer;
var
  CodPropriedadeRural: Integer;
begin
  Result := ConsistirFazenda(SglFazenda, CodFazenda, CodPropriedadeRural);
end;

function TThrProcessarArquivo.ConsistirFazenda(SglFazenda: String;
  var CodFazenda, CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirFazenda';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  tf.cod_fazenda as CodFazenda, '+
        '  tf.cod_propriedade_rural CodPropriedadeRural '+
        'from '+
        '  tab_fazenda tf '+
        'where '+
        '  tf.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and tf.sgl_fazenda = :sgl_fazenda '+
        '  and tf.dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('sgl_fazenda').AsString := UpperCase(SglFazenda);
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1291, Self.ClassName, NomeMetodo, [SglFazenda]);
        Result := -1291;
      end else begin
        CodFazenda := Q.FieldByName('CodFazenda').AsInteger;
        CodPropriedadeRural := Q.FieldByName('CodPropriedadeRural').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1293, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1293;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirRaca(CodRaca: Integer;
  var CodEspecie: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirRaca';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  cod_especie as CodEspecie '+
        'from '+
        '  tab_raca tr '+
        'where '+
        '  tr.cod_raca = :cod_raca '+
        '  and tr.dta_fim_validade is null ';
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1296, Self.ClassName, NomeMetodo, []);
        Result := -1296;
      end else begin
        CodEspecie := Q.FieldByName('CodEspecie').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1297, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1297;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirLocal(CodFazenda: Integer; SglLocal: String;
  var CodLocal: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirLocal';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  cod_local as CodLocal '+
        'from '+
        '  tab_local '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and sgl_local = :sgl_local '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_local').AsString := UpperCase(SglLocal);
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1298, Self.ClassName, NomeMetodo, [SglLocal]);
        Result := -1298;
      end else begin
        CodLocal := Q.FieldByName('CodLocal').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1299, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1299;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirLote(CodFazenda: Integer; SglLote: String;
  var CodLote: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirLote';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  cod_lote as CodLote '+
        'from '+
        '  tab_lote '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and sgl_lote = :sgl_lote '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_lote').AsString := UpperCase(SglLote);
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1300, Self.ClassName, NomeMetodo, [SglLote]);
        Result := -1300;
      end else begin
        CodLote := Q.FieldByName('CodLote').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1301, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1301;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirAnimal(SglFazendaManejo,
  CodAnimalManejo: String; var CodAnimal: Integer;
  var DadosAnimalComErro: TDadosAnimalComErro): Integer;
const
  NomeMetodo: String = 'ConsistirAnimal';
var
  Q: THerdomQuery;
  CodFazenda: Integer;
  sAux: String;
begin
  Result := -1;
  if SglFazendaManejo <> '' then begin
    Result := ConsistirFazenda(SglFazendaManejo, CodFazenda);
    if Result < 0 then Exit;
  end else begin
    CodFazenda := -1;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  ta.cod_pessoa_produtor as CodPessoaProdutor '+
        '  , cod_animal as CodAnimal '+
        '  , ta.des_apelido as DesApelido '+
        '  , ta.cod_fazenda_manejo as CodFazendaManejo '+
        '  , tf.sgl_fazenda as SglFazendaManejo '+
        '  , ta.cod_animal_manejo as CodAnimalManejo '+
        '  , ta.cod_animal_certificadora as CodAnimalCertificadora '+
        '  , ta.cod_situacao_sisbov as CodSituacaoSisbov '+
        '  , ta.cod_pais_sisbov as CodPaisSisbov '+
        '  , ta.cod_estado_sisbov as CodEstadoSisbov '+
        '  , ta.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov '+
        '  , ta.cod_animal_sisbov as CodAnimalSisbov '+
        '  , ta.num_dv_sisbov as NumDVSisbov '+
        '  , ta.cod_raca as CodRaca '+
        '  , ta.ind_sexo as IndSexo '+
        '  , ta.cod_tipo_origem as CodTipoOrigem '+
        '  , ta.cod_categoria_animal as CodCategoriaAnimal '+
        '  , ta.cod_local_corrente as CodLocalCorrente '+
        '  , ta.cod_lote_corrente as CodLoteCorrente '+
        '  , ta.cod_tipo_lugar as CodTipoLugar '+
        'from '+
        '  tab_animal ta '+
        '  , tab_fazenda tf '+
        'where '+
        '  ta.cod_fazenda_manejo = :cod_fazenda_manejo '+
        '  and ta.cod_animal_manejo = :cod_animal_manejo '+
        '  and ta.cod_pessoa_produtor = :cod_pessoa_produtor '+
{$IFDEF MSSQL}
        '  and ta.cod_pessoa_produtor *= tf.cod_pessoa_produtor '+
        '  and ta.cod_fazenda_manejo *= tf.cod_fazenda '+
{$ENDIF}
        '  and ta.dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
      if CodFazenda > 0 then begin
        Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazenda;
      end else begin
        Q.ParamByName('cod_fazenda_manejo').DataType := ftInteger;
        Q.ParamByName('cod_fazenda_manejo').Clear;
      end;
      Q.Open;
      if Q.IsEmpty then begin
        sAux := Trim(SglFazendaManejo);
        if sAux = '' then begin
          sAux := CodAnimalManejo;
        end else begin
          sAux := sAux + ' - '+ CodAnimalManejo;
        end;
        Mensagens.Adicionar(1302, Self.ClassName, NomeMetodo, [sAux]);
        Result := -1302;
      end else begin
        CodAnimal := Q.FieldByName('CodAnimal').AsInteger;
        DadosAnimalComErro.DesApelido := Q.FieldByName('DesApelido').AsString;
        DadosAnimalComErro.CodFazendaManejo := Q.FieldByName('CodFazendaManejo').AsInteger;
        DadosAnimalComErro.SglFazendaManejo := Q.FieldByName('SglFazendaManejo').AsString;
        DadosAnimalComErro.CodAnimalManejo := Q.FieldByName('CodAnimalManejo').AsString;
        DadosAnimalComErro.CodAnimalCertificadora := Q.FieldByName('CodAnimalCertificadora').AsString;
        DadosAnimalComErro.CodSituacaoSisbov := Q.FieldByName('CodSituacaoSisbov').AsString;
        DadosAnimalComErro.CodPaisSisbov := Q.FieldByName('CodPaisSisbov').AsInteger;
        DadosAnimalComErro.CodEstadoSisbov := Q.FieldByName('CodEstadoSisbov').AsInteger;
        DadosAnimalComErro.CodMicroRegiaoSisbov := Q.FieldByName('CodMicroRegiaoSisbov').AsInteger;
        DadosAnimalComErro.CodAnimalSisbov := Q.FieldByName('CodAnimalSisbov').AsInteger;
        DadosAnimalComErro.NumDVSisbov := Q.FieldByName('NumDVSisbov').AsInteger;
        DadosAnimalComErro.CodRaca := Q.FieldByName('CodRaca').AsInteger;
        DadosAnimalComErro.IndSexo := Q.FieldByName('IndSexo').AsString;
        DadosAnimalComErro.CodTipoOrigem := Q.FieldByName('CodTipoOrigem').AsInteger;
        DadosAnimalComErro.CodCategoriaAnimal := Q.FieldByName('CodCategoriaAnimal').AsInteger;
        DadosAnimalComErro.CodLocalCorrente := Q.FieldByName('CodLocalCorrente').AsInteger;
        DadosAnimalComErro.CodLoteCorrente := Q.FieldByName('CodLoteCorrente').AsInteger;
        DadosAnimalComErro.CodTipoLugar := Q.FieldByName('CodTipoLugar').AsInteger;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1303, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1303;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirRM(SglFazendaManejo,
  CodReprodutorMultiploManejo: String; var CodReprodutorMultiplo: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirRM';
var
  Q: THerdomQuery;
  CodFazenda: Integer;
  sAux: String;
begin
  Result := ConsistirFazenda(SglFazendaManejo, CodFazenda);
  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  cod_reprodutor_multiplo as CodReprodutorMultiplo '+
        'from '+
        '  tab_reprodutor_multiplo trm '+
        'where '+
        '  trm.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and trm.cod_fazenda_manejo = :cod_fazenda_manejo '+
        '  and trm.cod_reprodutor_multiplo_manejo = :cod_reprodutor_multiplo_manejo ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazenda;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').AsString := CodReprodutorMultiploManejo;
      Q.Open;
      if Q.IsEmpty then begin
        sAux := Trim(SglFazendaManejo) + ' - '+ CodReprodutorMultiploManejo;
        Mensagens.Adicionar(1305, Self.ClassName, NomeMetodo, [sAux]);
        Result := -1305;
      end else begin
        CodReprodutorMultiplo := Q.FieldByName('CodReprodutorMultiplo').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1306, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1306;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirAnimalouRM(SglFazendaManejo,
  CodAnimalManejo: String; var CodAnimal, CodReprodutorMultiplo: Integer;
  var DadosAnimalComErro: TDadosAnimalComErro): Integer;
const
  NomeMetodo: String = 'ConsistirAnimalouRM';
var
  Q: THerdomQuery;
  CodFazenda: Integer;
  sAux: String;
begin
  Result := -1;
  if SglFazendaManejo <> '' then begin
    Result := ConsistirFazenda(SglFazendaManejo, CodFazenda);
    if Result < 0 then Exit;
  end else begin
    CodFazenda := -1;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  ta.cod_pessoa_produtor as CodPessoaProdutor '+
        '  , ta.cod_animal as CodAnimal '+
        '  , null as CodReprodutorMultiplo '+
        '  , ta.des_apelido as DesApelido '+
        '  , ta.cod_fazenda_manejo as CodFazendaManejo '+
        '  , tf.sgl_fazenda as SglFazendaManejo '+
        '  , ta.cod_animal_manejo as CodAnimalManejo '+
        '  , ta.cod_animal_certificadora as CodAnimalCertificadora '+
        '  , ta.cod_situacao_sisbov as CodSituacaoSisbov '+
        '  , ta.cod_pais_sisbov as CodPaisSisbov '+
        '  , ta.cod_estado_sisbov as CodEstadoSisbov '+
        '  , ta.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov '+
        '  , ta.cod_animal_sisbov as CodAnimalSisbov '+
        '  , ta.num_dv_sisbov as NumDVSisbov '+
        '  , ta.cod_raca as CodRaca '+
        '  , ta.ind_sexo as IndSexo '+
        '  , ta.cod_tipo_origem as CodTipoOrigem '+
        '  , ta.cod_categoria_animal as CodCategoriaAnimal '+
        '  , ta.cod_local_corrente as CodLocalCorrente '+
        '  , ta.cod_lote_corrente as CodLoteCorrente '+
        '  , ta.cod_tipo_lugar as CodTipoLugar '+
        'from '+
        '  tab_animal ta '+
        '  , tab_fazenda tf '+
        'where '+
        '  ta.cod_fazenda_manejo = :cod_fazenda_manejo '+
        '  and ta.cod_animal_manejo = :cod_animal_manejo '+
        '  and ta.cod_pessoa_produtor = :cod_pessoa_produtor '+
{$IFDEF MSSQL}
        '  and ta.cod_pessoa_produtor *= tf.cod_pessoa_produtor '+
        '  and ta.cod_fazenda_manejo *= tf.cod_fazenda '+
{$ENDIF}
        '  and ta.dta_fim_validade is null '+
        'union '+
        'select '+
        '  trm.cod_pessoa_produtor as CodPessoaProdutor '+
        '  , null as CodAnimal '+
        '  , trm.cod_reprodutor_multiplo as CodReprodutorMultiplo '+
        '  , null as DesApelido '+
        '  , trm.cod_fazenda_manejo as CodFazendaManejo '+
        '  , tf.sgl_fazenda as SglFazendaManejo '+
        '  , trm.cod_reprodutor_multiplo_manejo as CodAnimalManejo '+
        '  , null as CodAnimalCertificadora '+
        '  , null as CodSituacaoSisbov '+
        '  , null as CodPaisSisbov '+
        '  , null as CodEstadoSisbov '+
        '  , null as CodMicroRegiaoSisbov '+
        '  , null as CodAnimalSisbov '+
        '  , null as NumDVSisbov '+
        '  , null as CodRaca '+
        '  , null as IndSexo '+
        '  , null as CodTipoOrigem '+
        '  , null as CodCategoriaAnimal '+
        '  , null as CodLocalCorrente '+
        '  , null as CodLoteCorrente '+
        '  , null as CodTipoLugar '+
        'from '+
        '  tab_reprodutor_multiplo trm '+
        '  , tab_fazenda tf '+
        'where '+
        '  trm.cod_fazenda_manejo = :cod_fazenda_manejo '+
        '  and trm.cod_reprodutor_multiplo_manejo = :cod_animal_manejo '+
        '  and trm.cod_pessoa_produtor = :cod_pessoa_produtor '+
{$IFDEF MSSQL}
        '  and trm.cod_pessoa_produtor *= tf.cod_pessoa_produtor '+
        '  and trm.cod_fazenda_manejo *= tf.cod_fazenda '+
{$ENDIF}
        '';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
      if CodFazenda > 0 then begin
        Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazenda;
      end else begin
        Q.ParamByName('cod_fazenda_manejo').DataType := ftInteger;
        Q.ParamByName('cod_fazenda_manejo').Clear;
      end;
      Q.Open;
      if Q.IsEmpty then begin
        sAux := Trim(SglFazendaManejo);
        if sAux = '' then begin
          sAux := CodAnimalManejo;
        end else begin
          sAux := sAux + ' - '+ CodAnimalManejo;
        end;
        Mensagens.Adicionar(1463, Self.ClassName, NomeMetodo, [sAux]);
        Result := -1463;
      end else begin
        if Q.FieldByName('CodAnimal').IsNull then begin
          CodAnimal := -1;
          CodReprodutorMultiplo := Q.FieldByName('CodReprodutorMultiplo').AsInteger;
        end else begin
          CodAnimal := Q.FieldByName('CodAnimal').AsInteger;
          CodReprodutorMultiplo := -1;
        end;
        DadosAnimalComErro.DesApelido := Q.FieldByName('DesApelido').AsString;
        DadosAnimalComErro.CodFazendaManejo := Q.FieldByName('CodFazendaManejo').AsInteger;
        DadosAnimalComErro.SglFazendaManejo := Q.FieldByName('SglFazendaManejo').AsString;
        DadosAnimalComErro.CodAnimalManejo := Q.FieldByName('CodAnimalManejo').AsString;
        DadosAnimalComErro.CodAnimalCertificadora := Q.FieldByName('CodAnimalCertificadora').AsString;
        DadosAnimalComErro.CodSituacaoSisbov := Q.FieldByName('CodSituacaoSisbov').AsString;
        DadosAnimalComErro.CodPaisSisbov := Q.FieldByName('CodPaisSisbov').AsInteger;
        DadosAnimalComErro.CodEstadoSisbov := Q.FieldByName('CodEstadoSisbov').AsInteger;
        DadosAnimalComErro.CodMicroRegiaoSisbov := Q.FieldByName('CodMicroRegiaoSisbov').AsInteger;
        DadosAnimalComErro.CodAnimalSisbov := Q.FieldByName('CodAnimalSisbov').AsInteger;
        DadosAnimalComErro.NumDVSisbov := Q.FieldByName('NumDVSisbov').AsInteger;
        DadosAnimalComErro.CodRaca := Q.FieldByName('CodRaca').AsInteger;
        DadosAnimalComErro.IndSexo := Q.FieldByName('IndSexo').AsString;
        DadosAnimalComErro.CodTipoOrigem := Q.FieldByName('CodTipoOrigem').AsInteger;
        DadosAnimalComErro.CodCategoriaAnimal := Q.FieldByName('CodCategoriaAnimal').AsInteger;
        DadosAnimalComErro.CodLocalCorrente := Q.FieldByName('CodLocalCorrente').AsInteger;
        DadosAnimalComErro.CodLoteCorrente := Q.FieldByName('CodLoteCorrente').AsInteger;
        DadosAnimalComErro.CodTipoLugar := Q.FieldByName('CodTipoLugar').AsInteger;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1464, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1464;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirPessoaSecundaria(NumCNPJCPF: String;
  var CodPessoaSecundaria: Integer; CodPapelSecundario: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirPessoaSecundaria';
var
  Q: THerdomQuery;
  sAux: String;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se a pessoa existe
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  cod_pessoa_secundaria, '+
        '  , nom_pessoa_secundaria  '+
        'from '+
        '  tab_pessoa_secundaria '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and num_cnpj_cpf = :num_cnpj_cpf '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPF;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1402, Self.ClassName, NomeMetodo, []);
        Result := -1402;
        Exit;
      end;
      CodPessoaSecundaria := Q.FieldByName('cod_pessoa_secundaria').AsInteger;
      sAux := Q.FieldByName('nom_pessoa_secundaria').AsString;

      // Verifica se pessoa informada possui papel, caso informado
      if CodPapelSecundario > 0 then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  tpps.cod_pessoa_secundaria '+
          '  , tps.des_papel_secundario '+
          'from '+
          '  tab_papel_secundario tps '+
          '  , tab_pessoa_papel_secundario tpps '+
          'where '+
{IFDEF MSSQL}
          '  tps.cod_papel_secundario *= tpps.cod_papel_secundario '+
{ENDIF}
          '  and tpps.cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and tpps.cod_pessoa_secundaria = :cod_pessoa_secundaria '+
          '  and tps.cod_papel_secundario = :cod_papel_secundario ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
        Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(422, Self.ClassName, NomeMetodo, []);
          Result := -422;
          Exit;
        end else if Q.FieldByName('cod_pessoa_secundaria').IsNull then begin
          Mensagens.Adicionar(1403, Self.ClassName, NomeMetodo, [sAux, Q.FieldByName('des_papel_secundario').AsString]);
          Result := -1403;
          Exit;
        end;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1310, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1310;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirEstacaoMonta(SglEstacaoMonta: String;
  var CodEventoEstacaoMonta: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirEstacaoMonta';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'select '+
        '  teem.cod_evento as CodEventoEstacaoMonta'+
        'from '+
        '  tab_evento_estacao_monta teem '+
        'where '+
        '  teem.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and teem.sgl_estacao_monta = :sgl_estacao_monta ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('sgl_estacao_monta').AsString := UpperCase(SglEstacaoMonta);
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1538, Self.ClassName, NomeMetodo, [SglEstacaoMonta]);
        Result := -1538;
      end else begin
        CodEventoEstacaoMonta := Q.FieldByName('CodEventoEstacaoMonta').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1539, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1539;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TThrProcessarArquivo.LimparDadosEventoComErro(
  var DadosEventoComErro: TDadosEventoComErro);
begin
    DadosEventoComErro.CodTipoEvento := -1;
    DadosEventoComErro.DtaInicioEvento := 0;
    DadosEventoComErro.DtaFimEvento := 0;
    DadosEventoComErro.TxtObservacao := '';
    DadosEventoComErro.TxtDados := '';
end;

procedure TThrProcessarArquivo.LimparDadosAnimalComErro(
  var DadosAnimalComErro: TDadosAnimalComErro);
begin
  DadosAnimalComErro.DesApelido := '';
  DadosAnimalComErro.CodFazendaManejo := -1;
  DadosAnimalComErro.SglFazendaManejo := '';
  DadosAnimalComErro.CodAnimalManejo := '';
  DadosAnimalComErro.CodAnimalCertificadora := '';
  DadosAnimalComErro.CodSituacaoSisbov := '';
  DadosAnimalComErro.CodPaisSisbov := -1;
  DadosAnimalComErro.CodEstadoSisbov := -1;
  DadosAnimalComErro.CodMicroRegiaoSisbov := -1;
  DadosAnimalComErro.CodAnimalSisbov := -1;
  DadosAnimalComErro.NumDVSisbov := -1;
  DadosAnimalComErro.CodRaca := -1;
  DadosAnimalComErro.IndSexo := '';
  DadosAnimalComErro.CodTipoOrigem := -1;
  DadosAnimalComErro.CodCategoriaAnimal := -1;
  DadosAnimalComErro.CodLocalCorrente := -1;
  DadosAnimalComErro.CodLoteCorrente := -1;
  DadosAnimalComErro.CodTipoLugar := -1;
end;

procedure TThrProcessarArquivo.Execute;
const
  NomeMetodo: String = 'Execute';

  // Reprodutores múltiplos
  rmSglFazendaManejo: Integer = 1;
  rmCodReprodutorMultiploManejo: Integer = 2;
  rmCodEspecie: Integer = 3;
  rmTxtObservacao: Integer = 4;

  // Animais - Inserção
  aiSglFazendaManejo: Integer = 1;
  aiCodAnimalManejo: Integer = 2;
  aiCodAnimalCertificadora: Integer = 3;
  aiCodAnimalSisbov: Integer = 4;
  aiCodSituacaoSisbov: Integer = 5;
  aiDtaIdentificacaoSisbov: Integer = 6;
  aiNumImovelIdentificacao: Integer = 7;
  aiSglFazendaIdentificacao: Integer = 8;
  aiDtaNascimento: Integer = 9;
  aiNumImovelNascimento: Integer = 10;
  aiSglFazendaNascimento: Integer = 11;
  aiDtaCompra: Integer = 12;
  aiNomAnimal: Integer = 13;
  aiDesApelido: Integer = 14;
  aiCodAssociacaoRaca: Integer = 15;
  aiCodGrauSangue: Integer = 16;
  aiNumRgd: Integer = 17;
  aiNumTransponder: Integer = 18;
  aiCodTipoIdentificador1: Integer = 19;
  aiCodPosicaoIdentificador1: Integer = 20;
  aiCodTipoIdentificador2: Integer = 21;
  aiCodPosicaoIdentificador2: Integer = 22;
  aiCodTipoIdentificador3: Integer = 23;
  aiCodPosicaoIdentificador3: Integer = 24;
  aiCodTipoIdentificador4: Integer = 25;
  aiCodPosicaoIdentificador4: Integer = 26;
  aiCodAptidao: Integer = 27;
  aiCodRaca: Integer = 28;
  aiCodPelagem: Integer = 29;
  aiIndSexo: Integer = 30;
  aiCodTipoOrigem: Integer = 31;
  aiSglFazendaManejoPai: Integer = 32;
  aiCodManejoPai: Integer = 33;
  aiSglFazendaManejoMae: Integer = 34;
  aiCodManejoMae: Integer = 35;
  aiSglFazendaManejoReceptor: Integer = 36;
  aiCodManejoReceptor: Integer = 37;
  aiIndAnimalCastrado: Integer = 38;
  aiCodRegimeAlimentar: Integer = 39;
  aiCodCategoriaAnimal: Integer = 40;
  aiCodTipoLugar: Integer = 41;
  aiSglFazendaCorrente: Integer = 42;
  aiSglLocalCorrente: Integer = 43;
  aiSglLoteCorrente: Integer = 44;
  aiTxtObservacao: Integer = 45;
  aiNumGta: Integer = 46;
  aiDtaEmissaoGta: Integer = 47;
  aiNumNotaFiscal: Integer = 48;
  aiNumCNPJCPFTecnico: Integer = 49;
  aiIndEfetivar: Integer = 50;

  //Animais - Inserção Não especificado
  ainCodAnimalSISBOV:          Integer = 1;
  ainIndSexo:                  Integer = 2;
  ainSglAptidao:               Integer = 3;
  ainSglRaca:                  Integer = 4;
  ainDtaNascimento:            Integer = 5;
  ainSglTipoIdentificador1:    Integer = 6;
  ainSglPosicaoIdentificador1: Integer = 7;
  ainSglTipoIdentificador2:    Integer = 8;
  ainSglPosicaoIdentificador2: Integer = 9;
  ainDtaIdentificacaoSISBOV:   Integer = 10;
  ainSglFazendaIdentificacao:  Integer = 11;
  ainNumCNPJCPFTecnico:        Integer = 12;
  ainIndEfetivar:              Integer = 13;

  // Animais - Alteração
  aaSglFazendaManejoId: Integer = 1;
  aaCodAnimalManejoId: Integer = 2;
  aaCodAtributoAAlterar: Integer = 3;
  aaNovoValorAtributo1: Integer = 4;
  aaNovoValorAtributo2: Integer = 5;

  // Reprodutores Múltiplos - Touros
  rmtSglFazendaManejoReprodutor: Integer = 1;
  rmtCodReprodutorMultiploManejo: Integer = 2;
  rmtSglFazendaManejoAnimal: Integer = 3;
  rmtCodAnimalManejo: Integer = 4;

  // Eventos
  eSeqEvento: Integer = 1;
  eCodTipoEvento: Integer = 2;
  eDtaInicio: Integer = 3;
  eDtaFim: Integer = 4;
  eTxtObservacao: Integer = 5;
  eaCodTipoAvaliacao: Integer = 7;
  // MUDANÇA DE REGIME ALIMENTAR
  e1SglFazenda: Integer = 6;
  e1CodAptidao: Integer = 7;
  e1CodRegimeAlimentarOrigem: Integer = 8;
  e1CodRegimeAlimentarDestino: Integer = 9;
  // DESMAME
  e2SglFazenda: Integer = 6;
  e2CodAptidao: Integer = 7;
  e2CodRegimeAlimentarDestino: Integer = 8;
  // MUDANÇA DE CATEGORIA
  e3SglFazenda: Integer = 6;
  e3CodAptidao: Integer = 7;
  e3CodCategoriaOrigem: Integer = 8;
  e3CodCategoriaDestino: Integer = 9;
  // SELEÇÃO PARA REPRODUÇÃO
  e4SglFazenda: Integer = 6;
  // CASTRAÇÃO
  e5SglFazenda: Integer = 6;
  // MUDANÇA DE LOTE
  e6SglFazenda: Integer = 6;
  e6SglLoteDestino: Integer = 7;
  // MUDANÇA DE LOCAL
  e7CodAptidao: Integer = 6;
  e7SglFazenda: Integer = 7;
  e7SglLocalDestino: Integer = 8;
  e7CodRegAlimentarMamando: Integer = 9;
  e7CodRegAlimentarDesmamado: Integer = 10;
  // TRANSFERÊNCIA
  e8CodAptidao: Integer = 6;
  e8CodTipoLugarOrigem: Integer = 7;
  e8SglFazendaOrigem: Integer = 8;
  e8NumImovelOrigem: Integer = 9;
  e8NumCnpjCpfOrigem: Integer = 10;
  e8CodTipoLugarDestino: Integer = 11;
  e8SglFazendaDestino: Integer = 12;
  e8SglLocalDestino: Integer = 13;
  e8SglLoteDestino: Integer = 14;
  e8NumImovelDestino: Integer = 15;
  e8NumCnpjCpfDestino: Integer = 16;
  e8CodRegAlimentarMamando: Integer = 17;
  e8CodRegAlimentarDesmamado: Integer = 18;
  e8NumGta: Integer = 19;
  e8DtaEmissaoGta: Integer = 20;
  // VENDA PARA CRIADOR
  e9NumImovelReceitaFederal: Integer = 6;
  e9CnpjCpfCriador: Integer = 7;
  e9NumGta: Integer = 8;
  e9DtaEmissaoGta: Integer = 9;
  e9IndEventoCertTerceira: Integer = 10;
  // VENDA PARA FRIGORÍFICO
  e10SglFazenda: Integer = 6;
  e10NumCnpjCpfFrigorifico: Integer = 7;
  e10NumGta: Integer = 8;
  e10DtaEmissaoGta: Integer = 9;
  // DESAPARECIMENTO
  e11SglFazenda: Integer = 6;
  // MORTE
  e12SglFazenda: Integer = 6;
  e12CodTipoMorte: Integer = 7;
  e12CodCausaMorte: Integer = 8;
  // PARTO
  // ABORTO
  // MANEJO SANITÁRIO
  // EMISSÃO DE CERTIFICADO
  // DESMAME DO BEZERRO
  // DESAPARECIMENTO DO BEZERRO
  // MORTE DO BEZERRO
  // VENDA DO BEZERRO
  // ABATE DE ANIMAL VENDIDO
  // PESAGEM
  e22SglFazenda: Integer = 6;
  // COBERTURA EM REGIME DE PASTO
  e23SglFazenda: Integer = 6;
  e23SglFazendaManejoAnimalRM: Integer = 7;
  e23CodAnimalManejoAnimalRM: Integer = 8;
  e23SglEstacaoMonta: Integer = 9;
  // ESTAÇÃO DE MONTA
  e24SglFazenda: Integer = 6;
  e24SglEstacaoMonta: Integer = 7;
  e24DesEstacaoMonta: Integer = 8;
  // EXAME ANDROLÓGICO
  e25SglFazenda: Integer = 6;
  // INSEMINAÇÃO ARTIFICIAL
  e26SglFazenda: Integer = 6;
  e26HraEvento: Integer = 7;
  e26SglFazendaManejoTouro: Integer = 8;
  e26CodAnimalManejoTouro: Integer = 9;
  e26HumPartida: Integer = 10;
  e26SglFazendaManejoFemea: Integer = 11;
  e26CodAnimalManejoFemea: Integer = 12;
  e26QtdDoses: Integer = 13;
  e26CnpjCpfInseminador: Integer = 14;
  e26SglEstacaoMonta: Integer = 15;
  // COBERTURA POR MONTA CONTROLADA
  e27SglFazenda: Integer = 6;
  e27SglFazendaManejoTouro: Integer = 7;
  e27CodAnimalManejoTouro: Integer = 8;
  e27SglFazendaManejoFemea: Integer = 9;
  e27CodAnimalManejoFemea: Integer = 10;
  e27SglEstacaoMonta: Integer = 11;
  // DIAGNÓSTICO DE PRENHEZ
  e28SglFazenda: Integer = 6;
  e28SglEstacaoMonta: Integer = 7;

  // Eventos - Animais associados:
  eaSeqEvento: Integer = 1;
  eaSglFazendaManejo: Integer = 2;
  eaCodAnimalManejo: Integer = 3;
  eaQtdPesoAnimal: Integer = 4; // Somente para evento de pesagem
  eaIndVacaPrenha: Integer = 4; // Somente para evento de diagnóstico de prenhez
  eaIndTouroApto: Integer = 4; // Somente para evento de exame andrológico

  // Importação de Composição racial:
  crSglFazendaManejo: Integer = 1;
  crCodAnimalManejo: Integer = 2;
  crCodRaca: Integer = 3;
  crQtdComposicaoRacial: Integer = 4;

  // Avaliação
  avaSglFazendaManejo:       Integer = 2;
  avaCodAnimalManejo:        Integer = 3;
  avaSglTipoCaracateristica: Integer = 4;
  avaValCaracteristica:      Integer = 5;

  // Inventario de Animais
  iaSglFazenda: Integer = 1;
  iaCodAnimalSisbov: Integer = 2;

var
  Q, qAux: THerdomQuery;
  Arquivo: TArquivoLeitura;
  IntReprodutoresMultiplos: TIntReprodutoresMultiplos;
  IntAnimais: TIntAnimais;
  IntEventos: TIntEventos;
  IntInventariosAnimais: TIntInventariosAnimais;
  Processamento: TProcessamento;
  EventosInseridos: TEventosInseridos;
  DadosAnimalComErro: TDadosAnimalComErro;
  DadosEventoComErro: TDadosEventoComErro;
  ErrosAplicacaoEvento: Array of TErroAplicacaoEvento;
  sAux, NomArquivoUpLoad, NomArquivoImportacao: String;
  bTimeOut, bIniciouComposicaoRacial: Boolean;
  tTimeOut, DtaProcessamento, DtaAplicacaoEvento: TDateTime;
  iAux, iLinhasPercorridas, CodPessoaProdutor, CodAnimal,
    CodReprodutorMultiplo, CodFazendaManejoRM, CodFazendaManejo,
    CodFazendaIdentificacao, CodFazendaNascimento, CodEspecie,
    CodFazendaManejoPai, CodFazendaManejoMae, CodFazendaManejoReceptor,
    CodFazendaCorrente, CodLoteCorrente, CodLocalCorrente, CodEvento,
    iProgresso, iProgressoAux, iProgressoIncremento,
    iQtdVezesProcessamento, CodPessoaTecnico,
    CodPropriedadeRural: Integer;

  CodTipoAvaliacao: Integer;

  NumImovelIdentificacao: String;


  { Verifica se o registro informado é válido }
  function VerificarRegistro(Qry: THerdomQuery): Integer;
  begin
    Qry.SQL.Text :=
      ' select nom_arquivo_importacao as NomArquivoImportacao ' +
      '      , nom_arquivo_upload as NomArquivoUpLoad ' +
      '   from tab_arquivo_importacao tai '+
      '  where cod_pessoa_produtor = :cod_pessoa_produtor '+
      '    and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Qry.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Qry.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Qry.Open;
    if Qry.IsEmpty then begin
      Mensagens.Adicionar(1285, Self.ClassName, NomeMetodo, []);
      Result := -1285;
    end else begin
      NomArquivoImportacao := Qry.FieldByName('NomArquivoImportacao').AsString;
      NomArquivoUpLoad := Qry.FieldByName('NomArquivoUpLoad').AsString;
      Result := 0;
    end;
  end;

  { Verifica se ainda existem linhas do arquivo a serem processadas }
  function VerificarStatus: Integer;
  var
    iiAux: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  count(1) as NumLinhas '+
      'from '+
      '  tab_linha_arquivo_importacao tlai '+
      'where '+
      '  tlai.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and tlai.cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.Open;
    iiAux := Q.FieldByName('NumLinhas').AsInteger;
    if iiAux = 0 then begin
      Result := 0;
    end else begin
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  sum(qtd_total) as NumLinhasAProcessar '+
        'from '+
        '  tab_quantidade_tipo_linha tqtl '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_arquivo_importacao = :cod_arquivo_importacao ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.Open;
      if iiAux < Q.FieldByName('NumLinhasAProcessar').AsInteger then begin
        Result := 0;
      end else begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasAProcessar '+
          'from '+
          '  tab_linha_arquivo_importacao tlai '+
          'where '+
          '  tlai.dta_processamento is null '+
          '  and tlai.cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and tlai.cod_arquivo_importacao = :cod_arquivo_importacao '+
          'group by '+
          '  tlai.cod_arquivo_importacao ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
        Q.Open;
        if Q.FieldByName('NumLinhasAProcessar').AsInteger = 0 then begin
          Mensagens.Adicionar(1286, Self.ClassName, NomeMetodo, []);
          Result := -1286;
        end else begin
          Result := 0;
        end;
      end;
    end;
    Q.Close;
  end;

  { Verifica existência física do arquivo em disco }
  function VerificarArquivo: Integer;
  var
    sArquivo: String;
  begin
    // Obtem a pasta onde os arquivo estão armazenados
    sArquivo := Conexao.ValorParametro(38, Mensagens);
    if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
      sArquivo := sArquivo + '\';
    end;

    // Consiste existência da pasta
    if not DirectoryExists(sArquivo) then begin
      Mensagens.Adicionar(1287, Self.ClassName, NomeMetodo, []);
      Result := -1287;
      Exit;
    end;

    // Consiste existência do arquivo
    sArquivo := sArquivo + NomArquivoImportacao;
    if not FileExists(sArquivo) then begin
      Mensagens.Adicionar(1288, Self.ClassName, NomeMetodo, [NomArquivoImportacao]);
      Result := -1288;
      Exit;
    end;

    // Passo bem sucedido
    NomArquivoImportacao := sArquivo;
    Result := 0;
  end;

  { Atualizar a situacao do arquivo }
  function AtualizaSituacaoArqImport(qryAux: THerdomQuery; CodSituacao: String): Integer;
  var QtdTotal, QtdProcessadas: Integer;
  begin
     if (CodSituacao = 'C') then begin
        qryAux.SQL.Clear;
        qryAux.SQL.Text :=
         'select sum(qtd_total) as qtd_total, sum(qtd_processadas) as qtd_processadas '+
         ' from tab_quantidade_tipo_linha  '+
         ' where cod_arquivo_importacao = :cod_arquivo_importacao ' +
         ' and cod_pessoa_produtor = :cod_pessoa_produtor ';
        qryAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        qryAux.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
        qryAux.Open;
        QtdTotal := Q.FieldByName('qtd_total').AsInteger;
        QtdProcessadas := Q.FieldByName('qtd_processadas').AsInteger;

        if (QtdTotal = QtdProcessadas) then begin
          qryAux.SQL.Clear;
          qryAux.SQL.Text :=
           'update tab_arquivo_importacao set cod_situacao_arq_import = ''C'' ' +
           ' where cod_arquivo_importacao = :cod_arquivo_importacao ' + //cod obtido no if acima
           ' and cod_pessoa_produtor = :cod_pessoa_produtor ';
          qryAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          qryAux.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
          qryAux.ExecSQL;
        end;
     end else begin
        qryAux.SQL.Clear;
        qryAux.SQL.Text :=
           'update tab_arquivo_importacao set cod_situacao_arq_import = :cod_situacao_arq_import ' +
                ' where cod_arquivo_importacao = :cod_arquivo_importacao ' +
                ' and cod_pessoa_produtor = :cod_pessoa_produtor ';
        qryAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        qryAux.ParamByName('cod_situacao_arq_import').AsString := CodSituacao;
        qryAux.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
        qryAux.ExecSQL;
     end;
     Result := 0;
  end;

  { Cancela o processamento em andamento }
  procedure CancelarProcessamento;
  begin
    // Reabilita ao sistema o controle sobre transações
    Conexao.IgnorarNovasTransacoes := False;
    Conexao.Rollback;
    AtualizaSituacaoArqImport(Q, 'P');
    Arquivo.Finalizar;
  end;

  { Verifica se a linha informada ja foi processada }
  function ProcessarLinha(NumLinha: Integer): Integer;
  begin
    if (Arquivo.NumeroColunas = 0) or (Arquivo.TipoLinha <= 0) then begin
      Result := 0;
      Exit;
    end;
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  dta_processamento as DtaProcessamento '+
      'from '+
      '  tab_linha_arquivo_importacao '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.Open;
    if Q.IsEmpty then begin
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_linha_arquivo_importacao '+
        ' (cod_pessoa_produtor '+
        '  , cod_arquivo_importacao '+
        '  , num_linha '+
        '  , dta_processamento) '+
        'values '+
        ' (:cod_pessoa_produtor '+
        '  , :cod_arquivo_importacao '+
        '  , :num_linha '+
        '  , null) ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('num_linha').AsInteger := NumLinha;
      Q.ExecSQL;
      Result := 1;
    end else begin
      if Q.FieldByName('DtaProcessamento').IsNull then begin
        Result := 1;
      end else begin
        Result := 0;
      end;
    end;
    Q.Close;
  end;

  { Marca a linha informada como já processada }
  procedure MarcarLinhaComoProcessada(NumLinha: Integer);
  begin
    Q.Close;
    Q.SQL.Text :=
      'update '+
      '  tab_linha_arquivo_importacao '+
      'set '+
      '  dta_processamento = :dta_processamento '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.ExecSQL;
  end;

  { Limpa as ocorrências obtidas no último processamento }
  procedure LimparOcorrenciaProcessamento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'delete from tab_ocorrencia_processamento '+
      ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
      '   and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Incrementa o contador de vezes que o arquivo foi processado }
  procedure IncrementarQtdVezesProcessamento;
  begin
    // Incrementa o contador de vezes de processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_arquivo_importacao '+
      '   set qtd_vezes_processamento = qtd_vezes_processamento + 1 '+
      '     , dta_ultimo_processamento = :dta_ultimo_processamento '+
      ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
      '   and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('dta_ultimo_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;

    // Obtem o valor do contador de vezes de processamento
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  qtd_vezes_processamento as QtdVezesProcessamento '+
      'from '+
      '  tab_arquivo_importacao '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.Open;
    iQtdVezesProcessamento := Q.FieldByName('QtdVezesProcessamento').AsInteger;

    // Zera o número de erros obtidos durante o último processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_quantidade_tipo_linha '+
      'set '+
      '  qtd_erradas = 0 '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Guarda ocorrências durante o processamento }
  function GravarOcorrenciaProcessamento: Integer;
  var
    iiAux, jjAux: Integer;
  begin
    if (Mensagens.Count > 0) or (Length(ErrosAplicacaoEvento) > 0) then begin
      Q.Close;

      // Script SQL de inseração de ocorrência durante o processamento
      Q.SQL.Text :=
        'insert into tab_ocorrencia_processamento '+
        ' (cod_pessoa_produtor '+
        '  , cod_arquivo_importacao '+
        '  , dta_processamento '+
        '  , cod_tipo_linha_importacao '+
        '  , cod_tipo_mensagem '+
        '  , txt_mensagem '+
        '  , num_linha '+
        '  , cod_evento '+
        '  , cod_tipo_evento '+
        '  , dta_inicio_evento '+
        '  , dta_fim_evento '+
        '  , txt_observacao '+
        '  , txt_dados '+
        '  , cod_animal '+
        '  , cod_reprodutor_multiplo '+
        '  , cod_fazenda_manejo '+
        '  , sgl_fazenda_manejo '+
        '  , cod_animal_manejo '+
        '  , cod_reprodutor_multiplo_manejo '+
        '  , cod_animal_certificadora '+
        '  , cod_situacao_sisbov '+
        '  , cod_pais_sisbov '+
        '  , cod_estado_sisbov '+
        '  , cod_micro_regiao_sisbov '+
        '  , cod_animal_sisbov '+
        '  , num_dv_sisbov '+
        '  , cod_raca '+
        '  , cod_especie '+
        '  , ind_sexo '+
        '  , cod_tipo_origem '+
        '  , cod_categoria_animal '+
        '  , cod_local_corrente '+
        '  , sgl_local_corrente '+
        '  , cod_lote_corrente '+
        '  , sgl_lote_corrente '+
        '  , dta_aplicacao_evento '+
        '  , des_apelido '+
        '  , cod_tipo_lugar '+
        '  , qtd_peso_animal) '+
        'values '+
        ' (:cod_pessoa_produtor '+
        '  , :cod_arquivo_importacao '+
        '  , :dta_processamento '+
        '  , :cod_tipo_linha_importacao '+
        '  , :cod_tipo_mensagem '+
        '  , :txt_mensagem '+
        '  , :num_linha '+
        '  , :cod_evento '+
        '  , :cod_tipo_evento '+
        '  , :dta_inicio_evento '+
        '  , :dta_fim_evento '+
        '  , :txt_observacao '+
        '  , :txt_dados '+
        '  , :cod_animal '+
        '  , :cod_reprodutor_multiplo '+
        '  , :cod_fazenda_manejo '+
        '  , :sgl_fazenda_manejo '+
        '  , :cod_animal_manejo '+
        '  , :cod_reprodutor_multiplo_manejo '+
        '  , :cod_animal_certificadora '+
        '  , :cod_situacao_sisbov '+
        '  , :cod_pais_sisbov '+
        '  , :cod_estado_sisbov '+
        '  , :cod_micro_regiao_sisbov '+
        '  , :cod_animal_sisbov '+
        '  , :num_dv_sisbov '+
        '  , :cod_raca '+
        '  , :cod_especie '+
        '  , :ind_sexo '+
        '  , :cod_tipo_origem '+
        '  , :cod_categoria_animal '+
        '  , :cod_local_corrente '+
        '  , :sgl_local_corrente '+
        '  , :cod_lote_corrente '+
        '  , :sgl_lote_corrente '+
        '  , :dta_aplicacao_evento '+
        '  , :des_apelido '+
        '  , :cod_tipo_lugar '+
        '  , :qtd_peso_animal ) ';

      // Dados de identicação do arquivo e linha
      // Constantes a todos os tipos de ocorrências
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
      Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := Arquivo.TipoLinha;
      Q.ParamByName('num_linha').AsInteger := Arquivo.LinhasLidas;

      // Tipos dos dados de identificação da ocorrência
      // Variável de acordo com o tipo da linha
      Q.ParamByName('cod_evento').DataType := ftInteger;
      Q.ParamByName('cod_tipo_evento').DataType := ftInteger;
      Q.ParamByName('dta_inicio_evento').DataType := ftDateTime;
      Q.ParamByName('dta_fim_evento').DataType := ftDateTime;
      Q.ParamByName('txt_observacao').DataType := ftString;
      Q.ParamByName('txt_dados').DataType := ftString;
      Q.ParamByName('cod_animal').DataType := ftInteger;
      Q.ParamByName('cod_reprodutor_multiplo').DataType := ftInteger;
      Q.ParamByName('cod_fazenda_manejo').DataType := ftInteger;
      Q.ParamByName('sgl_fazenda_manejo').DataType := ftString;
      Q.ParamByName('cod_animal_manejo').DataType := ftString;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').DataType := ftString;
      Q.ParamByName('cod_animal_certificadora').DataType := ftString;
      Q.ParamByName('cod_situacao_sisbov').DataType := ftString;
      Q.ParamByName('cod_pais_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_estado_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_micro_regiao_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_animal_sisbov').DataType := ftInteger;
      Q.ParamByName('num_dv_sisbov').DataType := ftInteger;
      Q.ParamByName('cod_raca').DataType := ftInteger;
      Q.ParamByName('cod_especie').DataType := ftInteger;
      Q.ParamByName('ind_sexo').DataType := ftString;
      Q.ParamByName('cod_tipo_origem').DataType := ftInteger;
      Q.ParamByName('cod_categoria_animal').DataType := ftInteger;
      Q.ParamByName('cod_local_corrente').DataType := ftInteger;
      Q.ParamByName('sgl_local_corrente').DataType := ftString;
      Q.ParamByName('cod_lote_corrente').DataType := ftInteger;
      Q.ParamByName('sgl_lote_corrente').DataType := ftString;
      Q.ParamByName('dta_aplicacao_evento').DataType := ftDateTime;
      Q.ParamByName('des_apelido').DataType := ftString;
      Q.ParamByName('cod_tipo_lugar').DataType := ftInteger;
      Q.ParamByName('qtd_peso_animal').DataType := ftFloat;

      for iiAux := 0 to Mensagens.Count-1 do begin
        // Verifica se a ocorrência é um erro fatal
        if (Mensagens.Items[iiAux].Tipo = 2) and (Mensagens.Items[iiAux].Codigo <> 188) then begin
          Result := -1*Mensagens.Items[iiAux].Codigo;
          Conexao.Rollback;
          Exit;
        end;

        // Limpa os parâmetros de identificação da ocorrência
        for jjAux := 7 to Q.Params.Count-1 do begin
          Q.Params[jjAux].Clear;
        end;

        try
          // Identificando o tipo da linha onde o erro ocorreu
          case (Arquivo.TipoLinha) of
            1: { Animais - (Inserção - Não especificado) }
              begin
                AtribuiValorParametro(Q.ParamByName('sgl_fazenda_manejo'), Arquivo.ValorColuna[ainSglFazendaIdentificacao]);
                if Length(Arquivo.ValorColuna[ainCodAnimalSISBOV]) = 15 then
                begin
                  AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), RightStr(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 06, 09), 6));
                end
                else
                begin
                  AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), RightStr(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 08, 09), 6));
                end;

                AtribuiValorParametro(Q.ParamByName('cod_tipo_origem'), 5);
                AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 1, 3), 0));
                AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 4, 2), 0));
                if Length(Arquivo.ValorColuna[ainCodAnimalSisbov]) = 17 then begin
                   if Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 6, 2) = '99' then begin //consiste se no arquivo de importacao ainda existe codigo 99
                      AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), 00);
                   end else begin
                      AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 6, 2), 0));
                   end;
                   AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 8, 9), 0));
                   AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 17, 1), 0));
                end else if Length(Arquivo.ValorColuna[ainCodAnimalSisbov]) = 15 then begin
                   AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), 00);
                   AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 6, 9), 0));
                   AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSisbov], 15, 1), 0));
                end;
                AtribuiValorParametro(Q.ParamByName('ind_sexo'), Arquivo.ValorColuna[ainIndSexo]);
                                
              end;
            2: {Animais (Inserção)}
              begin
                AtribuiValorParametro(Q.ParamByName('cod_fazenda_manejo'), CodFazendaManejo);
                AtribuiValorParametro(Q.ParamByName('sgl_fazenda_manejo'), Arquivo.ValorColuna[aiSglFazendaManejo]);
                AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), Arquivo.ValorColuna[aiCodAnimalManejo]);
                AtribuiValorParametro(Q.ParamByName('cod_animal_certificadora'), Arquivo.ValorColuna[aiCodAnimalCertificadora]);
                AtribuiValorParametro(Q.ParamByName('cod_situacao_sisbov'), Arquivo.ValorColuna[aiCodSituacaoSisbov]);

                AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0));
                AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0));
                if Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 17 then begin
                   if Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2) = '99' then begin //consiste se no arquivo de importacao ainda existe codigo 99
                      AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), 00);
                   end else begin
                      AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2), 0));
                   end;
                   AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 8, 9), 0));
                   AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 17, 1), 0));
                end else if Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 15 then begin
                   AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), 00);
                   AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 9), 0));
                   AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 15, 1), 0));
                end;

                AtribuiValorParametro(Q.ParamByName('cod_raca'), Arquivo.ValorColuna[aiCodRaca]);
                AtribuiValorParametro(Q.ParamByName('ind_sexo'), Arquivo.ValorColuna[aiIndSexo]);
                AtribuiValorParametro(Q.ParamByName('cod_tipo_origem'), Arquivo.ValorColuna[aiCodTipoOrigem]);
                AtribuiValorParametro(Q.ParamByName('cod_categoria_animal'), Arquivo.ValorColuna[aiCodCategoriaAnimal]);
                AtribuiValorParametro(Q.ParamByName('cod_local_corrente'), CodLocalCorrente);
                AtribuiValorParametro(Q.ParamByName('sgl_local_corrente'), Arquivo.ValorColuna[aiSglLocalCorrente]);
                AtribuiValorParametro(Q.ParamByName('cod_lote_corrente'), CodLoteCorrente);
                AtribuiValorParametro(Q.ParamByName('sgl_lote_corrente'), Arquivo.ValorColuna[aiSglLoteCorrente]);
                AtribuiValorParametro(Q.ParamByName('des_apelido'), Arquivo.ValorColuna[aiDesApelido]);
                AtribuiValorParametro(Q.ParamByName('cod_tipo_lugar'), Arquivo.ValorColuna[aiCodTipoLugar]);
              end;
            3: {Animais (Alteração)}
              begin;
                AtribuiValorParametro(Q.ParamByName('cod_animal'), CodAnimal);
                if CodAnimal > 0 then begin
                  // Atribui valor atual do animal que está sendo alterado caso o mesmo tenha sido identificado
                  AtribuiValorParametro(Q.ParamByName('des_apelido'), DadosAnimalComErro.DesApelido);
                  AtribuiValorParametro(Q.ParamByName('cod_fazenda_manejo'), DadosAnimalComErro.CodFazendaManejo);
                  AtribuiValorParametro(Q.ParamByName('sgl_fazenda_manejo'), DadosAnimalComErro.SglFazendaManejo);
                  AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), DadosAnimalComErro.CodAnimalManejo);
                  AtribuiValorParametro(Q.ParamByName('cod_animal_certificadora'), DadosAnimalComErro.CodAnimalCertificadora);
                  AtribuiValorParametro(Q.ParamByName('cod_situacao_sisbov'), DadosAnimalComErro.CodSituacaoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), DadosAnimalComErro.CodPaisSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), DadosAnimalComErro.CodEstadoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), DadosAnimalComErro.CodMicroRegiaoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), DadosAnimalComErro.CodAnimalSisbov);
                  AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), DadosAnimalComErro.NumDVSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_raca'), DadosAnimalComErro.CodRaca);
                  AtribuiValorParametro(Q.ParamByName('ind_sexo'), DadosAnimalComErro.IndSexo);
                  AtribuiValorParametro(Q.ParamByName('cod_tipo_origem'), DadosAnimalComErro.CodTipoOrigem);
                  AtribuiValorParametro(Q.ParamByName('cod_categoria_animal'), DadosAnimalComErro.CodCategoriaAnimal);
                  AtribuiValorParametro(Q.ParamByName('cod_local_corrente'), DadosAnimalComErro.CodLocalCorrente);
                  AtribuiValorParametro(Q.ParamByName('cod_lote_corrente'), DadosAnimalComErro.CodLoteCorrente);
                  AtribuiValorParametro(Q.ParamByName('cod_tipo_lugar'), DadosAnimalComErro.CodTipoLugar);
                end;
              end;
            5: {Eventos}
              begin
                AtribuiValorParametro(Q.ParamByName('cod_tipo_evento'), Arquivo.ValorColuna[eCodTipoEvento]);
                AtribuiValorParametro(Q.ParamByName('dta_inicio_evento'), Arquivo.ValorColuna[eDtaInicio]);
                AtribuiValorParametro(Q.ParamByName('dta_fim_evento'), Arquivo.ValorColuna[eDtaFim]);
                AtribuiValorParametro(Q.ParamByName('txt_observacao'), Arquivo.ValorColuna[eTxtObservacao]);
              end;
            6: {Animais Associados a Eventos}
              begin
                jjAux := Mensagens.Items[iiAux].Codigo;
                if  (jjAux = 870) or (jjAux = 871) or (jjAux = 1120) or (jjAux = 1121) then Continue;
                AtribuiValorParametro(Q.ParamByName('cod_evento'), CodEvento);
                if CodEvento > 0 then begin
                  AtribuiValorParametro(Q.ParamByName('cod_tipo_evento'), DadosEventoComErro.CodTipoEvento);
                  AtribuiValorParametro(Q.ParamByName('dta_inicio_evento'), DadosEventoComErro.DtaInicioEvento);
                  AtribuiValorParametro(Q.ParamByName('dta_fim_evento'), DadosEventoComErro.DtaFimEvento);
                  AtribuiValorParametro(Q.ParamByName('txt_observacao'), DadosEventoComErro.TxtObservacao);
                  AtribuiValorParametro(Q.ParamByName('txt_dados'), DadosEventoComErro.TxtDados);
                end;
                AtribuiValorParametro(Q.ParamByName('cod_fazenda_manejo'), CodFazendaManejo);
                AtribuiValorParametro(Q.ParamByName('sgl_fazenda_manejo'), Arquivo.ValorColuna[eaSglFazendaManejo]);
                AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), Arquivo.ValorColuna[eaCodAnimalManejo]);
                AtribuiValorParametro(Q.ParamByName('dta_aplicacao_evento'), DtaAplicacaoEvento);
                if CodAnimal > 0 then begin
                  AtribuiValorParametro(Q.ParamByName('des_apelido'), DadosAnimalComErro.DesApelido);
                  AtribuiValorParametro(Q.ParamByName('cod_animal_certificadora'), DadosAnimalComErro.CodAnimalCertificadora);
                  AtribuiValorParametro(Q.ParamByName('cod_situacao_sisbov'), DadosAnimalComErro.CodSituacaoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), DadosAnimalComErro.CodPaisSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), DadosAnimalComErro.CodEstadoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), DadosAnimalComErro.CodMicroRegiaoSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), DadosAnimalComErro.CodAnimalSisbov);
                  AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), DadosAnimalComErro.NumDVSisbov);
                  AtribuiValorParametro(Q.ParamByName('cod_raca'), DadosAnimalComErro.CodRaca);
                  AtribuiValorParametro(Q.ParamByName('ind_sexo'), DadosAnimalComErro.IndSexo);
                  AtribuiValorParametro(Q.ParamByName('cod_tipo_origem'), DadosAnimalComErro.CodTipoOrigem);
                  AtribuiValorParametro(Q.ParamByName('cod_categoria_animal'), DadosAnimalComErro.CodCategoriaAnimal);
                  AtribuiValorParametro(Q.ParamByName('cod_local_corrente'), DadosAnimalComErro.CodLocalCorrente);
                  AtribuiValorParametro(Q.ParamByName('cod_lote_corrente'), DadosAnimalComErro.CodLoteCorrente);
                  AtribuiValorParametro(Q.ParamByName('cod_tipo_lugar'), DadosAnimalComErro.CodTipoLugar);
                end;
              end;
          end;
        except
          // Desconsidera o erro, caso algum tenha acontecido
        end;
        Q.ParamByName('cod_tipo_mensagem').AsInteger := Mensagens.Items[iiAux].Tipo;
        Q.ParamByName('txt_mensagem').AsString := Mensagens.Items[iiAux].Texto;
        Q.ExecSQL;
      end;

      // Limpa mensagens geradas durante a última linha de processamento
      Mensagens.Clear;

      for iiAux := 0 to Length(ErrosAplicacaoEvento)-1 do begin
        // Limpa os parâmetros de identificação da ocorrência
        for jjAux := 7 to Q.Params.Count-1 do begin
          Q.Params[jjAux].Clear;
        end;

        if Arquivo.TipoLinha = 6 then begin {Animais Associados a Eventos}
          AtribuiValorParametro(Q.ParamByName('cod_evento'), CodEvento);
          if CodEvento > 0 then begin
            AtribuiValorParametro(Q.ParamByName('cod_tipo_evento'), DadosEventoComErro.CodTipoEvento);
            AtribuiValorParametro(Q.ParamByName('dta_inicio_evento'), DadosEventoComErro.DtaInicioEvento);
            AtribuiValorParametro(Q.ParamByName('dta_fim_evento'), DadosEventoComErro.DtaFimEvento);
            AtribuiValorParametro(Q.ParamByName('txt_observacao'), DadosEventoComErro.TxtObservacao);
            AtribuiValorParametro(Q.ParamByName('txt_dados'), DadosEventoComErro.TxtDados);
          end;
          AtribuiValorParametro(Q.ParamByName('cod_fazenda_manejo'), CodFazendaManejo);
          AtribuiValorParametro(Q.ParamByName('sgl_fazenda_manejo'), Arquivo.ValorColuna[eaSglFazendaManejo]);
          AtribuiValorParametro(Q.ParamByName('cod_animal_manejo'), Arquivo.ValorColuna[eaCodAnimalManejo]);
          if CodAnimal > 0 then begin
            AtribuiValorParametro(Q.ParamByName('des_apelido'), DadosAnimalComErro.DesApelido);
            AtribuiValorParametro(Q.ParamByName('cod_animal_certificadora'), DadosAnimalComErro.CodAnimalCertificadora);
            AtribuiValorParametro(Q.ParamByName('cod_situacao_sisbov'), DadosAnimalComErro.CodSituacaoSisbov);
            AtribuiValorParametro(Q.ParamByName('cod_pais_sisbov'), DadosAnimalComErro.CodPaisSisbov);
            AtribuiValorParametro(Q.ParamByName('cod_estado_sisbov'), DadosAnimalComErro.CodEstadoSisbov);
            AtribuiValorParametro(Q.ParamByName('cod_micro_regiao_sisbov'), DadosAnimalComErro.CodMicroRegiaoSisbov);
            AtribuiValorParametro(Q.ParamByName('cod_animal_sisbov'), DadosAnimalComErro.CodAnimalSisbov);
            AtribuiValorParametro(Q.ParamByName('num_dv_sisbov'), DadosAnimalComErro.NumDVSisbov);
            AtribuiValorParametro(Q.ParamByName('cod_raca'), DadosAnimalComErro.CodRaca);
            AtribuiValorParametro(Q.ParamByName('ind_sexo'), DadosAnimalComErro.IndSexo);
            AtribuiValorParametro(Q.ParamByName('cod_tipo_origem'), DadosAnimalComErro.CodTipoOrigem);
            AtribuiValorParametro(Q.ParamByName('cod_categoria_animal'), DadosAnimalComErro.CodCategoriaAnimal);
            AtribuiValorParametro(Q.ParamByName('cod_local_corrente'), DadosAnimalComErro.CodLocalCorrente);
            AtribuiValorParametro(Q.ParamByName('cod_lote_corrente'), DadosAnimalComErro.CodLoteCorrente);
            AtribuiValorParametro(Q.ParamByName('cod_tipo_lugar'), DadosAnimalComErro.CodTipoLugar);
          end;
          Q.ParamByName('dta_aplicacao_evento').AsDateTime := ErrosAplicacaoEvento[iiAux].DtaAplicacaoEvento;
          Q.ParamByName('cod_tipo_mensagem').AsInteger := ErrosAplicacaoEvento[iiAux].CodTipoMensagem;
          Q.ParamByName('txt_mensagem').AsString := ErrosAplicacaoEvento[iiAux].TxtMensagem;
          Q.ExecSQL;
        end;
      end;

      // Limpa mensagens geradas durante a última linha de processamento
      SetLength(ErrosAplicacaoEvento, 0);
    end;
    Result := 0;
  end;

  { Trata resultado da função de processamento }
  function TratarResultadoProcessamento(Resultado: Integer): Integer;
  begin
    Result := GravarOcorrenciaProcessamento;
    if Result < 0 then
    begin
      Exit;
    end;

    if Resultado < 0 then
    begin
      Result := Processamento.IncErradas(Arquivo.TipoLinha);
      AtualizaSituacaoArqImport(Q, 'P');
    end
    else
    begin
      MarcarLinhaComoProcessada(Arquivo.LinhasLidas);
      Result := Processamento.IncProcessadas(Arquivo.TipoLinha);
      AtualizaSituacaoArqImport(Q, 'C');
    end;
  end;

  { Obtem execeções geradas durante a aplicação de um evento a um animal }
  procedure ObtemErrosAplicacaoEvento;
  var
    iiAux: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  cod_tipo_mensagem as CodTipoMensagem '+
      '  , dta_aplicacao_evento as DtaAplicacaoEvento '+
      '  , txt_mensagem as TxtMensagem '+
      'from '+
      '  tab_erro_aplicacao_evento '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_evento = :cod_evento '+
      '  and cod_animal = :cod_animal ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_evento').AsInteger := CodEvento;
    Q.ParamByName('cod_animal').AsInteger := CodAnimal;
    Q.Open;
    while not Q.EOF do begin
      iiAux := Length(ErrosAplicacaoEvento);
      SetLength(ErrosAplicacaoEvento, iiAux+1);
      ErrosAplicacaoEvento[iiAux].CodTipoMensagem := Q.FieldByName('CodTipoMensagem').AsInteger;
      ErrosAplicacaoEvento[iiAux].TxtMensagem := Q.FieldByName('TxtMensagem').AsString;
      ErrosAplicacaoEvento[iiAux].DtaAplicacaoEvento := Q.FieldByName('DtaAplicacaoEvento').AsDateTime;
      Q.Next;
    end;
    Q.Close;
  end;

  { Trata solicitação de alteração em atributo não disponível }
  function TratarAlteracaoAtributoNaoImplementada(DesAtributo: String): Integer;
  begin
    Mensagens.Adicionar(1304, Self.ClassName, NomeMetodo, [DesAtributo]);
    Result := -1304;
  end;

  { Processando RM´s }
  function ProcessarRM: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 4 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Reprodutores Múltiplos']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodFazendaManejoRM := -1;

    // Consiste Fazenda de manejo do RM
    Result := ConsistirFazenda(Arquivo.ValorColuna[rmSglFazendaManejo],
      CodFazendaManejoRM);
    if Result < 0 then Exit;

    // Insere RM através de rotina específica do sistema
    Result := IntReprodutoresMultiplos.Inserir(CodFazendaManejoRM,
      Arquivo.ValorColuna[rmCodReprodutorMultiploManejo],
      Arquivo.ValorColuna[rmCodEspecie], Arquivo.ValorColuna[rmTxtObservacao]);
  end;

  { Processando Animais - Inserção }
  function ProcessarAnimaisInsercao: Integer;
  var
    iiAux: Integer;
    iRetAux: Integer;
    sDtaIdentificacaoSisbov,
    sDtaNascimento,
    sDtaCompra,
    sDtaEmissaoGta: String;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 50 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Animais - Inserção']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodFazendaManejo := -1;
    CodLocalCorrente := -1;
    CodLoteCorrente := -1;

    // Consiste origem do animal
    iiAux := Arquivo.ValorColuna[aiCodTipoOrigem];
    if not iiAux in [1, 2, 3, 4] then begin
      Mensagens.Adicionar(1295, Self.ClassName, NomeMetodo, []);
      Result := -1295;
      Exit;
    end;

    // Consiste fazenda de manejo, quando informada
    if Arquivo.ValorColuna[aiSglFazendaManejo] <> '' then begin
      Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaManejo],
        CodFazendaManejo);
      if Result < 0 then Exit;
    end else begin
      CodFazendaManejo := -1;
    end;

// Consistência desnecessária
//    if Arquivo.ValorColuna[aiCodSituacaoSisbov] <> 'I' then begin
      // Consiste Raça, obtendo a espécie correspondente
      Result := ConsistirRaca(Arquivo.ValorColuna[aiCodRaca], CodEspecie);
      if Result < 0 then Exit;
//    end;

    // Consiste fazenda de manejo do pai, quando informada
    if Arquivo.ValorColuna[aiSglFazendaManejoPai] <> '' then begin
      Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaManejoPai],
        CodFazendaManejoPai);
      if Result < 0 then Exit;
    end else begin
      CodFazendaManejoPai := -1;
    end;

    // Consiste fazenda de manejo da mãe, quando informada
    if Arquivo.ValorColuna[aiSglFazendaManejoMae] <> '' then begin
      Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaManejoMae],
        CodFazendaManejoMae);
      if Result < 0 then Exit;
    end else begin
      CodFazendaManejoMae := -1;
    end;

    // Consiste fazenda de manejo do receptor, quando informada
    if Arquivo.ValorColuna[aiSglFazendaManejoReceptor] <> '' then begin
      Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaManejoReceptor],
        CodFazendaManejoReceptor);
      if Result < 0 then Exit;
    end else begin
      CodFazendaManejoReceptor := -1;
    end;

    // Consiste/obtem dados complementares de acordo com a origem
    iiAux := Arquivo.ValorColuna[aiCodTipoOrigem];
    if iiAux in [1, 2, 3, 5] then begin {Nascimento, Compra, Importação}

      if iiAux in [1, 2, 5] then begin {Nascimento, Compra}
        // Consiste fazenda de identificação, caso seja informada
        if Arquivo.ValorColuna[aiSglFazendaIdentificacao] <> '' then begin
          Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaIdentificacao],
            CodFazendaIdentificacao);
          if Result < 0 then Exit;
        end else begin
          CodFazendaIdentificacao := -1;
        end;
      end;

      // Consiste fazenda corrente informada para o animal
      // Como o tipo de lugar corrente será sempre 1 (um) para arquivos de
      // importação, faz se obrigatório a informação da fazenda corrente e
      // também que a mesma seja sempre válida.
      Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaCorrente],
        CodFazendaCorrente);
      if Result < 0 then Exit;

      // Consiste local corrente informado para o animal
      // Como o tipo de lugar corrente será sempre 1 (um) para arquivos de
      // importação, faz se obrigatório a informação do local corrente e
      // também que a mesmo seja sempre válido.
      Result := ConsistirLocal(CodFazendaCorrente,
        Arquivo.ValorColuna[aiSglLocalCorrente], CodLocalCorrente);
      if Result < 0 then Exit;

      // Consiste o lote corrente caso o mesmo seja informado
      if Arquivo.ValorColuna[aiSglLoteCorrente] <> '' then begin
        Result := ConsistirLote(CodFazendaCorrente,
          Arquivo.ValorColuna[aiSglLoteCorrente], CodLoteCorrente);
        if Result < 0 then Exit;
      end else begin
        CodLoteCorrente := -1;
      end;
    end;

    if (Arquivo.ValorColuna[aiCodTipoOrigem] = 2) and (Arquivo.ValorColuna[aiNumImovelIdentificacao] = '') then begin
      Mensagens.Adicionar(2384, Self.ClassName, NomeMetodo, []);
      exit;
    end else begin
      NumImovelIdentificacao := Arquivo.ValorColuna[aiNumImovelIdentificacao];
    end;

    if (Arquivo.ValorColuna[aiCodTipoOrigem] = 1) or (Arquivo.ValorColuna[aiCodTipoOrigem] = 5) then
    begin
      if (Arquivo.ValorColuna[aiSglFazendaIdentificacao] = '') then begin
        if (Trim(Arquivo.ValorColuna[aiNumImovelIdentificacao]) <> '') then
        begin
          CodPropriedadeRural := -1;
          Result := TIntImportacoes.ValidarNIRFIdentificacao(Conexao, Mensagens, Arquivo.ValorColuna[aiNumImovelIdentificacao],
                                                             CodPropriedadeRural, -1, Conexao.CodProdutorTrabalho, False);
          if Result < 0 then
          begin
            // Identifica e guarda erro ocorrido
            GravarOcorrenciaProcessamento;
            CodFazendaIdentificacao := -1;
          end
          else
          begin
            CodPropriedadeRural := Result;
            QAux.SQL.Clear;
            QAux.SQL.Add('select cod_fazenda as CodFazendaIdentificacao from tab_fazenda');
            QAux.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
            QAux.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
            QAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
            QAux.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
            QAux.Open;

            if QAux.IsEmpty then
            begin
              Mensagens.Adicionar('Não foi encontrada uma fazenda de identificação para o produtor com o NIRF/INCRA: ' + Arquivo.ValorColuna[aiNumImovelNascimento] +
                                  '. Informe o código de exportação na planilha de inserção ou altere os dados no cadastro do animal.', 1, Self.ClassName, NomeMetodo, []);
              // Identifica e guarda erro ocorrido
              GravarOcorrenciaProcessamento;
              CodFazendaIdentificacao := -1;
            end
            else
            begin
              NumImovelIdentificacao  := '';
              CodFazendaIdentificacao := QAux.FieldByName('CodFazendaIdentificacao').AsInteger;
            end;
          end;
        end;
      end;

      if (Arquivo.ValorColuna[aiSglFazendaNascimento] = '') then begin
        if (Trim(Arquivo.ValorColuna[aiNumImovelNascimento]) <> '') then
        begin
          CodPropriedadeRural := -1;
          Result := TIntImportacoes.ValidarNIRFNascimento(Conexao, Mensagens, Arquivo.ValorColuna[aiNumImovelNascimento],
                                                          CodPropriedadeRural, -1, Conexao.CodProdutorTrabalho, False);
          if Result < 0 then
          begin
            // Identifica e guarda erro ocorrido
            GravarOcorrenciaProcessamento;
            CodFazendaNascimento := -1;
          end
          else
          begin
            CodPropriedadeRural := Result;
            QAux.SQL.Clear;
            QAux.SQL.Add('select cod_fazenda as CodFazendaNascimento from tab_fazenda');
            QAux.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
            QAux.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
            QAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
            QAux.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
            QAux.Open;

            if QAux.IsEmpty then
            begin
              Mensagens.Adicionar('Não foi encontrada uma fazenda de nascimento para o produtor com o NIRF/INCRA: ' + Arquivo.ValorColuna[aiNumImovelNascimento]+
                                  '. Informe o código de exportação na planilha de inserção ou altere os dados no cadastro do animal.', 1, Self.ClassName, NomeMetodo, []);
              // Identifica e guarda erro ocorrido
              GravarOcorrenciaProcessamento;
              CodFazendaNascimento := -1;
            end
            else
            begin
              CodFazendaNascimento := QAux.FieldByName('CodFazendaNascimento').AsInteger;
            end;
          end;
        end;
      end;
    end;

    // Tratando Origem: Nascimento
    if Arquivo.ValorColuna[aiCodTipoOrigem] = 1 then begin
      // Consiste fazenda de nascimento, caso seja informada
      if Arquivo.ValorColuna[aiSglFazendaNascimento] <> '' then begin
        Result := ConsistirFazenda(Arquivo.ValorColuna[aiSglFazendaNascimento], CodFazendaNascimento);
        if Result < 0 then Exit;
      end;
      // Insere registro de animal
      if Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 15 then
      begin
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirNascido(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              -1, //Código SISBOV sem micro região!
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 15, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              NumImovelIdentificacao,
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              CodFazendaNascimento,
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              Arquivo.ValorColuna[aiNumTransponder],
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiIndAnimalCastrado],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],       // TO DO
              'S', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico]);
      end
      else
      begin
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirNascido(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 8, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 17, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              NumImovelIdentificacao,
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              CodFazendaNascimento,
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              Arquivo.ValorColuna[aiNumTransponder],
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiIndAnimalCastrado],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],       // TO DO
              'S', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico]);
      end;
    end else if Arquivo.ValorColuna[aiCodTipoOrigem] = 2 then begin
    // Tratando Origem: Compra
      if (Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 15) then
      begin // Insere registro de animal
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        sDtaCompra              := Arquivo.ValorColuna[aiDtaCompra];
        sDtaEmissaoGTA          := Arquivo.ValorColuna[aiDtaEmissaoGta];
        Result := IntAnimais.InserirComprado(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              -1, //Código SISBOV sem micro região!
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 15, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              Arquivo.ValorColuna[aiNumImovelIdentificacao],
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiNumImovelNascimento],
              -1, // CodPropriedadeNascimento (não é informado no arquivo)
              StrToDate(sDtaCompra),
              -1, // CodPessoaSecundariaCriador (não é informado no arquivo)
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              Arquivo.ValorColuna[aiNumTransponder],
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiIndAnimalCastrado],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],
              Arquivo.ValorColuna[aiNumGta],
              StrToDate(sDtaEmissaoGta),
              Arquivo.ValorColuna[aiNumNotaFiscal], //TO DO
              'S', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico], -1);
      end
      else
      begin
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        sDtaCompra              := Arquivo.ValorColuna[aiDtaCompra];
        sDtaEmissaoGTA          := Arquivo.ValorColuna[aiDtaEmissaoGta];
        Result := IntAnimais.InserirComprado(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 8, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 17, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              Arquivo.ValorColuna[aiNumImovelIdentificacao],
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiNumImovelNascimento],
              -1, // CodPropriedadeNascimento (não é informado no arquivo)
              StrToDate(sDtaCompra),
              -1, // CodPessoaSecundariaCriador (não é informado no arquivo)
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              Arquivo.ValorColuna[aiNumTransponder],
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiIndAnimalCastrado],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],
              Arquivo.ValorColuna[aiNumGta],
              StrToDate(sDtaEmissaoGta),
              Arquivo.ValorColuna[aiNumNotaFiscal], //TO DO
              'S', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico], -1);
      end;
    end else if Arquivo.ValorColuna[aiCodTipoOrigem] = 3 then begin
    // Tratando Origem: Importação
      // Insere registro de animal
      sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
      sDtaCompra              := Arquivo.ValorColuna[aiDtaCompra];
      Result := IntAnimais.InserirImportado(CodFazendaManejo,
        Arquivo.ValorColuna[aiCodAnimalManejo],
        Arquivo.ValorColuna[aiCodAnimalCertificadora],
        Arquivo.ValorColuna[aiCodSituacaoSisbov],
        StrToDate(sDtaNascimento),
        StrToDate(sDtaCompra),
        -1, // CodPessoaSecundariaCriador (não é informado no arquivo)
        Arquivo.ValorColuna[aiNomAnimal],
        Arquivo.ValorColuna[aiDesApelido],
        Arquivo.ValorColuna[aiCodAssociacaoRaca],
        Arquivo.ValorColuna[aiCodGrauSangue],
        Arquivo.ValorColuna[aiNumRGD],
        Arquivo.ValorColuna[aiNumTransponder],
        Arquivo.ValorColuna[aiCodTipoIdentificador1],
        Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
        Arquivo.ValorColuna[aiCodTipoIdentificador2],
        Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
        Arquivo.ValorColuna[aiCodTipoIdentificador3],
        Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
        Arquivo.ValorColuna[aiCodTipoIdentificador4],
        Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
        CodEspecie,
        Arquivo.ValorColuna[aiCodAptidao],
        Arquivo.ValorColuna[aiCodRaca],
        Arquivo.ValorColuna[aiCodPelagem],
        Arquivo.ValorColuna[aiIndSexo],
        CodFazendaManejoPai,
        Arquivo.ValorColuna[aiCodManejoPai],
        CodFazendaManejoMae,
        Arquivo.ValorColuna[aiCodManejoMae],
        CodFazendaManejoReceptor,
        Arquivo.ValorColuna[aiCodManejoReceptor],
        Arquivo.ValorColuna[aiIndAnimalCastrado],
        Arquivo.ValorColuna[aiCodRegimeAlimentar],
        Arquivo.ValorColuna[aiCodCategoriaAnimal],
        Arquivo.ValorColuna[aiCodTipoLugar],
        CodLoteCorrente,
        CodLocalCorrente,
        CodFazendaCorrente,
        -1, // CodPropriedadeCorrente (não é informado no arquivo)
        '', // NumCNPJCPFCorrente (não é informado no arquivo)
        -1, // CodPessoaCorrente (não é informado no arquivo)
        -1, // CodPaisOrigem (não é informado no arquivo)
        '', // DesPropriedadeOrigem (não é informado no arquivo)
        0, // DtaAutorizacaoImportacao (não é informado no arquivo)
        0, // DtaEntradaPais (não é informado no arquivo)
        '', // NumGuiaImportacao (não é informado no arquivo)
        '', // NumLicencaImportacao (não é informado no arquivo)
        Arquivo.ValorColuna[aiTxtObservacao], // TO DO
        'S', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico]);
    end else if Arquivo.ValorColuna[aiCodTipoOrigem] = 4 then begin
    // Tratando Origem: Externo
      // Insere registro de animal
      if Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 15 then
      begin
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirExterno(
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              -1, //Código SISBOV sem micro região!
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 15, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiTxtObservacao],'N', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico]); // TO DO
      end
      else
      begin
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirExterno(
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 8, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 17, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiNomAnimal],
              Arquivo.ValorColuna[aiDesApelido],
              Arquivo.ValorColuna[aiCodAssociacaoRaca],
              Arquivo.ValorColuna[aiCodGrauSangue],
              Arquivo.ValorColuna[aiNumRGD],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              CodFazendaManejoReceptor,
              Arquivo.ValorColuna[aiCodManejoReceptor],
              Arquivo.ValorColuna[aiTxtObservacao],'N', -1, Arquivo.ValorColuna[aiNumCNPJCPFTecnico]); // TO DO
      end;
    end else if Arquivo.ValorColuna[aiCodTipoOrigem] = 5 then begin
    // Tratando Origem: Não especificado
      // Insere registro de animal
      if Length(Arquivo.ValorColuna[aiCodAnimalSisbov]) = 15 then
      begin
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirNaoEspecificado(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              -1, //Código SISBOV sem micro região!
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 15, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              NumImovelIdentificacao,
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],
              -1,
              Arquivo.ValorColuna[aiNumCNPJCPFTecnico]);
      end
      else
      begin
        sDtaIdentificacaoSisbov := Arquivo.ValorColuna[aiDtaIdentificacaoSisbov];
        sDtaNascimento          := Arquivo.ValorColuna[aiDtaNascimento];
        Result := IntAnimais.InserirNaoEspecificado(CodFazendaManejo,
              Arquivo.ValorColuna[aiCodAnimalManejo],
              Arquivo.ValorColuna[aiCodAnimalCertificadora],
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 1, 3), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 4, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 6, 2), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 8, 9), 0),
              StrToIntDef(Copy(Arquivo.ValorColuna[aiCodAnimalSisbov], 17, 1), 0),
              Arquivo.ValorColuna[aiCodSituacaoSisbov],
              StrToDate(sDtaIdentificacaoSisbov),
              NumImovelIdentificacao,
              -1, // CodPropriedadeIdentificacao (não é informado no arquivo)
              CodFazendaIdentificacao,
              StrToDate(sDtaNascimento),
              Arquivo.ValorColuna[aiCodTipoIdentificador1],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador1],
              Arquivo.ValorColuna[aiCodTipoIdentificador2],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador2],
              Arquivo.ValorColuna[aiCodTipoIdentificador3],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador3],
              Arquivo.ValorColuna[aiCodTipoIdentificador4],
              Arquivo.ValorColuna[aiCodPosicaoIdentificador4],
              CodEspecie,
              Arquivo.ValorColuna[aiCodAptidao],
              Arquivo.ValorColuna[aiCodRaca],
              Arquivo.ValorColuna[aiCodPelagem],
              Arquivo.ValorColuna[aiIndSexo],
              CodFazendaManejoPai,
              Arquivo.ValorColuna[aiCodManejoPai],
              CodFazendaManejoMae,
              Arquivo.ValorColuna[aiCodManejoMae],
              Arquivo.ValorColuna[aiCodRegimeAlimentar],
              Arquivo.ValorColuna[aiCodCategoriaAnimal],
              Arquivo.ValorColuna[aiCodTipoLugar],
              CodLoteCorrente,
              CodLocalCorrente,
              CodFazendaCorrente,
              -1, // CodPropriedadeCorrente (não é informado no arquivo)
              '', // NumCNPJCPFCorrente (não é informado no arquivo)
              -1, // CodPessoaCorrente (não é informado no arquivo)
              Arquivo.ValorColuna[aiTxtObservacao],
              -1,
              Arquivo.ValorColuna[aiNumCNPJCPFTecnico]);
      end;
    end;

    // ==============
    // Fábio
    //
    // Efetiva o animal no SISBOV se for necessário e
    // se não houve nenhum erro no processamento.
    if Result > 0 then
    begin
      // Finaliza a operação anterior e inicia uma nova tarnsação para a efetivação do animal
      if Arquivo.ValorColuna[aiIndEfetivar] = 'S' then
      begin
        if Arquivo.ValorColuna[aiCodSituacaoSisbov] = 'P' then
        begin
          iRetAux := IntAnimais.EfetivarCadastro(Result, True)
        end
        else
        begin
          Mensagens.Adicionar(1649, Self.ClassName, 'ProcessarAnimaisInsercao', []);
          iRetAux := -1649;
        end;

        if iRetAux <> 0 then
        begin
          Mensagens.Adicionar(1964, Self.ClassName, NomeMetodo, []);
        end;
      end;
    end;
  end;

  { Processando Inventário de Animais }
  function ProcessarInventarioAnimais: Integer;
  var
    CodFazenda, CodPropriedadeRural: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 2 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Inventário de Animais']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodFazenda := -1;
    CodPropriedadeRural := -1;

    // Consiste fazenda de manejo, quando informada
    if Arquivo.ValorColuna[iaSglFazenda] <> '' then begin
      Result := ConsistirFazenda(Arquivo.ValorColuna[iaSglFazenda], CodFazenda, CodPropriedadeRural);
      if Result < 0 then Exit;
    end;

    Result := IntInventariosAnimais.Inserir(Conexao.CodProdutorTrabalho, CodPropriedadeRural, Arquivo.ValorColuna[iaCodAnimalSisbov], -1);
  end;

  function ProcessarAnimalNaoEspecificado(): Integer;
  var
    iRetAux: Integer;
    CodFazenda: Integer;
    sDtaIdentificacaoSISBOV,
    sDtaNascimento: String;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 13 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Animais - Inserção']);
      Result := -1294;
      Exit;
    end;

    Result := ConsistirFazenda(Arquivo.ValorColuna[ainSglFazendaIdentificacao], CodFazenda);
    if Result < 0 then
    begin
      Exit;
    end;
    sDtaIdentificacaoSISBOV := Arquivo.ValorColuna[ainDtaIdentificacaoSISBOV];
    sDtaNascimento          := Arquivo.ValorColuna[ainDtaNascimento];
    if Length(Trim(Arquivo.ValorColuna[ainCodAnimalSISBOV])) = 15 then
    begin
      Result := IntAnimais.InserirNaoEspecificado(CodFazenda,
                                                  '',
                                                  '',
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 01, 03), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 04, 02), 0),
                                                  -1,
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 06, 09), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 15, 01), 0),
                                                  'P',
                                                  StrToDate(sDtaIdentificacaoSISBOV),
                                                  '',
                                                  -1,
                                                  CodFazenda,
                                                  StrToDate(sDtaNascimento),
                                                  Arquivo.ValorColuna[ainSglTipoIdentificador1],
                                                  Arquivo.ValorColuna[ainSglPosicaoIdentificador1],
                                                  Arquivo.ValorColuna[ainSglTipoIdentificador2],
                                                  Arquivo.ValorColuna[ainSglPosicaoIdentificador2],
                                                  -1,
                                                  -1,
                                                  -1,
                                                  -1
                                                  -1,
                                                  1,
                                                  Arquivo.ValorColuna[ainSglAptidao],
                                                  Arquivo.ValorColuna[ainSglRaca],
                                                  14,
                                                  Arquivo.ValorColuna[ainIndSexo],
                                                  -1,
                                                  '',
                                                  -1,
                                                  '',
                                                  99,
                                                  99,
                                                  1,
                                                  -1,
                                                  -1,
                                                  CodFazenda,
                                                  -1,
                                                  '',
                                                  -1,
                                                  '',
                                                  -1,
                                                  Arquivo.ValorColuna[ainNumCNPJCPFTecnico]);
    end
    else
    begin
      Result := IntAnimais.InserirNaoEspecificado(CodFazenda,
                                                  '',
                                                  '',
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 01, 03), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 04, 02), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 06, 02), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 08, 09), 0),
                                                  StrToIntDef(Copy(Arquivo.ValorColuna[ainCodAnimalSISBOV], 17, 01), 0),
                                                  'P',
                                                  StrToDate(sDtaIdentificacaoSISBOV),
                                                  '',
                                                  -1,
                                                  CodFazenda,
                                                  StrToDate(sDtaNascimento),
                                                  Arquivo.ValorColuna[ainSglTipoIdentificador1],
                                                  Arquivo.ValorColuna[ainSglPosicaoIdentificador1],
                                                  Arquivo.ValorColuna[ainSglTipoIdentificador2],
                                                  Arquivo.ValorColuna[ainSglPosicaoIdentificador2],
                                                  -1,
                                                  -1,
                                                  -1,
                                                  -1
                                                  -1,
                                                  1,
                                                  Arquivo.ValorColuna[ainSglAptidao],
                                                  Arquivo.ValorColuna[ainSglRaca],
                                                  14,
                                                  Arquivo.ValorColuna[ainIndSexo],
                                                  -1,
                                                  '',
                                                  -1,
                                                  '',
                                                  99,
                                                  99,
                                                  1,
                                                  -1,
                                                  -1,
                                                  CodFazenda,
                                                  -1,
                                                  '',
                                                  -1,
                                                  '',
                                                  -1,
                                                  Arquivo.ValorColuna[ainNumCNPJCPFTecnico]);
    end;

    if Result > 0 then
    begin
      // Finaliza a operação anterior e inicia uma nova tarnsação para a efetivação do animal
      if Arquivo.ValorColuna[ainIndEfetivar] = 'S' then
      begin
        iRetAux := IntAnimais.EfetivarCadastro(Result, True);
        if iRetAux <> 0 then
        begin
          Mensagens.Adicionar(1964, Self.ClassName, NomeMetodo, []);
        end;
      end;
    end;
  end;

  { Processando Animais - Alteração }
  function ProcessarAnimaisAlteracao: Integer;
  const
    // Atributos de animais, disponíveis para alteração
    atrCodAnimalManejo:          Integer = 2;
    atrCodAnimalCertificadora:   Integer = 3;
    atrCodAnimalSisbov:          Integer = 4;
    atrDtaIdentificacaoSisbov:   Integer = 5;
    atrIndSexo:                  Integer = 6;
    atrCodFazendaIdentificacao:  Integer = 7;
    atrDtaNascimento:            Integer = 8;
    atrNumImovelNascimento:      Integer = 9;
    atrCodFazendaNascimento:     Integer = 10;
    atrDtaCompra:                Integer = 11;
    atrNomAnimal:                Integer = 12;
    atrDesApelido:               Integer = 13;
    atrNumTransponder:           Integer = 14;
    atrCodTipoIdentificador1:    Integer = 15;
    atrCodPosicaoIdentificador1: Integer = 16;
    atrCodTipoIdentificador2:    Integer = 17;
    atrCodPosicaoIdentificador2: Integer = 18;
    atrCodTipoIdentificador3:    Integer = 19;
    atrCodPosicaoIdentificador3: Integer = 20;
    atrCodTipoIdentificador4:    Integer = 21;
    atrCodPosicaoIdentificador4: Integer = 22;
    atrCodRaca:                  Integer = 23;
    atrCodPelagem:               Integer = 24;
    atrIndAnimalCastrado:        Integer = 25;
    atrCodRegimeAlimentar:       Integer = 26;
    atrCodCategoriaAnimal:       Integer = 27;
    atrCodFazendaCorrente:       Integer = 28;
    atrCodLocalCorrente:         Integer = 29;
    atrCodLoteCorrente:          Integer = 30;
    atrTxtObservacao:            Integer = 31;
    atrNumGta:                   Integer = 32;
    atrDtaEmissaoGta:            Integer = 33;
    atrNumNotaFiscal:            Integer = 34;
    atrCodManejoPai:             Integer = 35;
    atrCodManejoMae:             Integer = 36;
    atrCodManejoReceptor:        Integer = 37;
    atrNumCNPJCPFTecnico:        Integer = 38;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 5 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Animais - Alteração']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodAnimal := -1;
    CodFazendaIdentificacao := -1;
    CodFazendaManejo := -1;
    CodLocalCorrente := -1;
    CodLoteCorrente := -1;
    LimparDadosAnimalComErro(DadosAnimalComErro);

    // Consistindo animal
    Result := ConsistirAnimal(Arquivo.ValorColuna[aaSglFazendaManejoId],
      Arquivo.ValorColuna[aaCodAnimalManejoId], CodAnimal, DadosAnimalComErro);
    if Result < 0 then
    begin
      Exit;
    end;

    if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrIndAnimalCastrado then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Status de Castrado');
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodRegimeAlimentar then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Regime Alimentar');
      Exit;
    end else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodCategoriaAnimal then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Categoria');
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodFazendaCorrente then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Fazenda Corrente');
      Exit;      
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodLocalCorrente then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Local Corrente');
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodLoteCorrente then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Lote Corrente');
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrTxtObservacao then { Não Implementado }
    begin
      Result := TratarAlteracaoAtributoNaoImplementada('Observação');
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodFazendaIdentificacao then
    begin
      // Altera atributo fazenda de identificacao do animal
      Result := ConsistirFazenda(Arquivo.ValorColuna[aaNovoValorAtributo2],
        CodFazendaIdentificacao);
      if Result < 0 then Exit;
      Result := IntAnimais.AlterarAtributo(CodAnimal, atrCodFazendaIdentificacao,
        Arquivo.ValorColuna[aaNovoValorAtributo1],
        CodFazendaIdentificacao);
      Exit;
    end
    else if Arquivo.ValorColuna[aaCodAtributoAAlterar] = atrCodFazendaNascimento then
    begin
      // Altera atributo fazenda de nascimento do animal
      Result := ConsistirFazenda(Arquivo.ValorColuna[aaNovoValorAtributo2],
        CodFazendaNascimento);
      if Result < 0 then Exit;
      Result := IntAnimais.AlterarAtributo(CodAnimal, atrCodFazendaNascimento,
        Arquivo.ValorColuna[aaNovoValorAtributo1],
        CodFazendaNascimento);
      Exit;
    end;

    // Altera demais atributos do animal
    Result := IntAnimais.AlterarAtributo(CodAnimal,
      Arquivo.ValorColuna[aaCodAtributoAAlterar],
      Arquivo.ValorColuna[aaNovoValorAtributo1],
      Arquivo.ValorColuna[aaNovoValorAtributo2]);
  end;

  { Processando Touros de RM´s }
  function ProcessarTourosRM: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 4 then
    begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Touros de RM´s']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodAnimal := -1;
    CodReprodutorMultiplo := -1;
    LimparDadosAnimalComErro(DadosAnimalComErro);

    // Consistindo RM informado
    Result := ConsistirRM(Arquivo.ValorColuna[rmtSglFazendaManejoReprodutor],
      Arquivo.ValorColuna[rmtCodReprodutorMultiploManejo], CodReprodutorMultiplo);
    if Result < 0 then Exit;

    // Consistindo touro informado
    Result := ConsistirAnimal(Arquivo.ValorColuna[rmtSglFazendaManejoAnimal],
      Arquivo.ValorColuna[rmtCodAnimalManejo], CodAnimal, DadosAnimalComErro);
    if Result < 0 then Exit;

// --> foi retirado devido a inclusao dos campos DtaInicioUso e DtaFimUso
    // Relaciona touro com RM correspondente
//    Result := IntReprodutoresMultiplos.AdicionarTouro(CodReprodutorMultiplo,
//      CodAnimal, -1, '');
    if Result < 0 then Exit;

    // Identifica processamento como bem sucedido
    Result := 0;
  end;

  { Processando Eventos }
  function ProcessarEventos: Integer;
  var
    DadosAnimalFemeaComErro: TDadosAnimalComErro;
    CodTipoEvento, CodFazenda, CodLoteDestino, CodLocalDestino,
      CodFazendaOrigem, CodFazendaDestino, CodAnimalFemea,
      CodPessoaSecundaria, CodEventoEstacaoMonta: Integer;
  begin
    // Consiste inicialmente a Quantidade de colunas da linha
    if Arquivo.NumeroColunas < 2 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Eventos']);
      Result := -1294;
      Exit;
    end;

    // Obtendo o tipo do evento que está sendo inserido
    CodTipoEvento := Arquivo.ValorColuna[eCodTipoEvento];

    // Consiste se quantidade de colunas é válida ao tipo de evento identificado
    if (CodTipoEvento = 1) and (Arquivo.NumeroColunas <> 9)
    or (CodTipoEvento = 2) and (Arquivo.NumeroColunas <> 8)
    or (CodTipoEvento = 3) and (Arquivo.NumeroColunas <> 9)
    or (CodTipoEvento = 4) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 5) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 6) and (Arquivo.NumeroColunas <> 7)
    or (CodTipoEvento = 7) and (Arquivo.NumeroColunas <> 10)
    or (CodTipoEvento = 8) and (Arquivo.NumeroColunas <> 20)
    or (CodTipoEvento = 9) and (Arquivo.NumeroColunas <> 9)
    or (CodTipoEvento = 10) and (Arquivo.NumeroColunas <> 9)
    or (CodTipoEvento = 11) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 12) and (Arquivo.NumeroColunas <> 8)
//    or (CodTipoEvento = 13) and (Arquivo.NumeroColunas <> ) { Não implementado }
//    or (CodTipoEvento = 14) and (Arquivo.NumeroColunas <> ) { Não implementado }
//    or (CodTipoEvento = 15) and (Arquivo.NumeroColunas <> ) { Não definido }
//    or (CodTipoEvento = 16) and (Arquivo.NumeroColunas <> ) { Restrito ao sistema }
//    or (CodTipoEvento = 17) and (Arquivo.NumeroColunas <> ) { Restrito ao sistema }
//    or (CodTipoEvento = 18) and (Arquivo.NumeroColunas <> ) { Restrito ao sistema }
//    or (CodTipoEvento = 19) and (Arquivo.NumeroColunas <> ) { Restrito ao sistema }
//    or (CodTipoEvento = 20) and (Arquivo.NumeroColunas <> ) { Restrito ao sistema }
//    or (CodTipoEvento = 21) and (Arquivo.NumeroColunas <> ) { Não contemplado }
    or (CodTipoEvento = 22) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 23) and (Arquivo.NumeroColunas <> 8)
    or (CodTipoEvento = 24) and (Arquivo.NumeroColunas <> 8)
    or (CodTipoEvento = 25) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 26) and (Arquivo.NumeroColunas <> 14)
    or (CodTipoEvento = 27) and (Arquivo.NumeroColunas <> 10)
    or (CodTipoEvento = 28) and (Arquivo.NumeroColunas <> 6)
    or (CodTipoEvento = 31) and (Arquivo.NumeroColunas <> 7)  then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Eventos']);
      Result := -1294;
      Exit;
    end;

    // Realiza chamada de método específico para o tipo de evento
    case (CodTipoEvento) of
      1: { Mudança de regime alimentar }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e1SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e1SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirMudRegAlimentar(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e1CodAptidao],
            Arquivo.ValorColuna[e1CodRegimeAlimentarOrigem],
            Arquivo.ValorColuna[e1CodRegimeAlimentarDestino],
            CodFazenda);
        end;
      2: { Desmame }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e2SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e2SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirDesmame(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[e2CodAptidao],
            Arquivo.ValorColuna[e2CodRegimeAlimentarDestino],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda);
        end;
      3: { Mudança de categoria }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e3SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e3SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirMudCategoria(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e3CodAptidao],
            Arquivo.ValorColuna[e3CodCategoriaOrigem],
            Arquivo.ValorColuna[e3CodCategoriaDestino],
            CodFazenda);
        end;
      4: { Seleção para reprodução }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e4SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e4SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirSelecaoReproducao(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda);
        end;
      5: { Castração }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e5SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e5SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirCastracao(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda);
        end;
      6: { Mudança de lote }
        begin
          // Consistindo fazenda
          Result := ConsistirFazenda(
            Arquivo.ValorColuna[e6SglFazenda], CodFazenda);
          if Result < 0 then Exit;

          // Consistindo lote
          Result := ConsistirLote(CodFazenda,
            Arquivo.ValorColuna[e6SglLoteDestino], CodLoteDestino);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirMudancaLote(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda,
            CodLoteDestino);
        end;
      7: { Mudança de local }
        begin
          // Consistindo fazenda
          Result := ConsistirFazenda(
            Arquivo.ValorColuna[e7SglFazenda], CodFazenda);
          if Result < 0 then Exit;

          // Consistindo local
          Result := ConsistirLocal(CodFazenda,
            Arquivo.ValorColuna[e7SglLocalDestino], CodLocalDestino);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirMudancaLocal(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e7CodAptidao],
            CodFazenda,
            CodLocalDestino,
            Arquivo.ValorColuna[e7CodRegAlimentarMamando],
            Arquivo.ValorColuna[e7CodRegAlimentarDesmamado]);
        end;
      8: { Transferência }
        begin
          // Consistindo Fazenda origem, se informada
          if Arquivo.ValorColuna[e8SglFazendaOrigem] <> '' then begin
            Result := ConsistirFazenda(Arquivo.ValorColuna[e8SglFazendaOrigem],
              CodFazendaOrigem);
            if Result < 0 then Exit;
          end else begin
            CodFazendaOrigem := -1;
          end;

          // Consistindo Fazenda destino, se informada
          if Arquivo.ValorColuna[e8SglFazendaDestino] <> '' then begin
            Result := ConsistirFazenda(Arquivo.ValorColuna[e8SglFazendaDestino],
              CodFazendaDestino);
            if Result < 0 then Exit;
          end else begin
            CodFazendaDestino := -1;
          end;

          // Consistindo Local destino, se informada
          if Arquivo.ValorColuna[e8SglLocalDestino] <> '' then begin
            Result := ConsistirLocal(CodFazendaDestino,
              Arquivo.ValorColuna[e8SglLocalDestino], CodLocalDestino);
            if Result < 0 then Exit;
          end else begin
            CodLocalDestino := -1;
          end;

          // Consistindo Lote destino, se informada
          if Arquivo.ValorColuna[e8SglLoteDestino] <> '' then begin
            Result := ConsistirLote(CodFazendaDestino,
              Arquivo.ValorColuna[e8SglLoteDestino], CodLoteDestino);
            if Result < 0 then Exit;
          end else begin
            CodLoteDestino := -1;
          end;

          // Insere evento
          Result := IntEventos.InserirTransferencia(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eDtaFim],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e8CodAptidao],
            Arquivo.ValorColuna[e8CodTipoLugarOrigem],
            CodFazendaOrigem,
            Arquivo.ValorColuna[e8NumImovelOrigem],
            -1,
            -1, // Não informado no arquivo
            Arquivo.ValorColuna[e8NumCnpjCpfOrigem],
            -1, // Não informado no arquivo
            -1, // Não informado no arquivo
            Arquivo.ValorColuna[e8CodTipoLugarDestino],
            CodFazendaDestino,
            CodLocalDestino,
            CodLoteDestino,
            Arquivo.ValorColuna[e8NumImovelDestino],
            -1,
            -1, // Não informado no arquivo
            Arquivo.ValorColuna[e8NumCnpjCpfDestino],
            -1, // Não informado no arquivo
            -1, // Não informado no arquivo
            Arquivo.ValorColuna[e8CodRegAlimentarMamando],
            Arquivo.ValorColuna[e8CodRegAlimentarDesmamado],
            Arquivo.ValorColuna[e8NumGta],
            Arquivo.ValorColuna[e8DtaEmissaoGta], '', 0, 0, 'N', 'N');
        end;
      9: { Venda para criador }
        begin
          // Insere evento
          Result := IntEventos.InserirVendaCriador(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eDtaFim],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e9NumImovelReceitaFederal],
            '',
            -1, // Não informado no arquivo
            -1, // Não informado no arquivo
            -1,
            Arquivo.ValorColuna[e9CnpjCpfCriador],
            Arquivo.ValorColuna[e9DtaEmissaoGta],
            Arquivo.ValorColuna[e9NumGta],
            -1,
            Arquivo.ValorColuna[e9IndEventoCertTerceira],
            '',
            0,
            '',
            0); // Não identifica fazenda onde o evento foi ocorrido
        end;
      10: { Venda para frigorífico }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e10SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e10SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirVendaFrigorifico(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eDtaFim],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e10NumCnpjCpfFrigorifico],
            -1, // Não informado no arquivo
            Arquivo.ValorColuna[e10DtaEmissaoGta],
            Arquivo.ValorColuna[e10NumGta],
            CodFazenda, '', 0, 0);
        end;
      11: { Desaparecimento }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e11SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e11SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirDesaparecimento(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda);
        end;
      12: { Morte }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e12SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e12SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirMorte(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            Arquivo.ValorColuna[e12CodTipoMorte],
            Arquivo.ValorColuna[e12CodCausaMorte],
            CodFazenda);
        end;
//      13: { Parto } { Não implementado }
//      14: { Aborto } { Não implementado }
//      15: { Manejo sanitário } { Não definido }
//      16: { Emissão de certificado } { Restrito ao sistema }
//      17: { Desmame do bezerro } { Restrito ao sistema }
//      18: { Desaparecimento do bezerro } { Restrito ao sistema }
//      19: { Morte do bezerro } { Restrito ao sistema }
//      20: { Venda do bezerro } { Restrito ao sistema }
//      21: { Abate de animal vendido } { Não contemplado }
      22: { Pesagem }
        begin
          // Consistindo fazenda
          Result := ConsistirFazenda(
            Arquivo.ValorColuna[e22SglFazenda], CodFazenda);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirPesagem(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda);
        end;
      23: { Cobertura em regime de pasto }
        begin
          // Consistindo fazenda
          Result := ConsistirFazenda(
            Arquivo.ValorColuna[e23SglFazenda], CodFazenda);
          if Result < 0 then Exit;

          // Consistindo estação de monta
          Result := ConsistirEstacaoMonta(
            Arquivo.ValorColuna[e23SglEstacaoMonta], CodEventoEstacaoMonta);
          if Result < 0 then Exit;

          // Inicializando variáveis como não informadas
          LimparDadosAnimalComErro(DadosAnimalComErro);

          // Consistindo Animal ou RM
          Result := ConsistirAnimalouRM(
            Arquivo.ValorColuna[e23SglFazendaManejoAnimalRM],
            Arquivo.ValorColuna[e23CodAnimalManejoAnimalRM],
            CodAnimal, CodReprodutorMultiplo, DadosAnimalComErro);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirCoberturaRegimePasto(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eDtaFim], CodFazenda,
            Arquivo.ValorColuna[eTxtObservacao], -1, '',
            CodAnimal,
            CodReprodutorMultiplo,
            CodEventoEstacaoMonta);
        end;
      24: { Estação de monta }
        begin
          // Consistindo fazenda
          Result := ConsistirFazenda(
            Arquivo.ValorColuna[e24SglFazenda], CodFazenda);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirEstacaoMonta(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[eDtaFim],
            Arquivo.ValorColuna[eTxtObservacao],
            CodFazenda,
            Arquivo.ValorColuna[e24SglEstacaoMonta],
            Arquivo.ValorColuna[e24DesEstacaoMonta]);
        end;
      25: { Exame andrológico }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e25SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e25SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Insere Evento
          Result := IntEventos.InserirExameAndrologico(
            Arquivo.ValorColuna[eDtaInicio],
            CodFazenda,
            Arquivo.ValorColuna[eTxtObservacao]);
        end;
      26: { Inseminação artificial }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e26SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e26SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Consistindo animal touro
          Result := ConsistirAnimal(Arquivo.ValorColuna[e26SglFazendaManejoTouro],
            Arquivo.ValorColuna[e26CodAnimalManejoTouro], CodAnimal, DadosAnimalComErro);
          if Result < 0 then Exit;

          // Consistindo animal fêmea
          Result := ConsistirAnimal(Arquivo.ValorColuna[e26SglFazendaManejoFemea],
            Arquivo.ValorColuna[e26CodAnimalManejoFemea], CodAnimalFemea, DadosAnimalFemeaComErro);
          if Result < 0 then Exit;

          // Consistindo inserminador, caso informado
          if Arquivo.ValorColuna[e26CnpjCpfInseminador] <> '' then begin
            Result := ConsistirPessoaSecundaria(
              Arquivo.ValorColuna[e26CnpjCpfInseminador], CodPessoaSecundaria, 6);
            if Result < 0 then Exit;
          end else begin
            CodPessoaSecundaria := -1;
          end;

          // Consistindo estação de monta
          Result := ConsistirEstacaoMonta(
            Arquivo.ValorColuna[e26SglEstacaoMonta], CodEventoEstacaoMonta);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirCoberturaInseminacaoArtificial(
            Arquivo.ValorColuna[eDtaInicio],
            Arquivo.ValorColuna[e26HraEvento],
            CodFazenda,
            Arquivo.ValorColuna[eTxtObservacao],
            CodAnimal,
            Arquivo.ValorColuna[e26HumPartida],
            CodAnimalFemea,
            -1,
            '',
            Arquivo.ValorColuna[e26QtdDoses],
            CodPessoaSecundaria,
            CodEventoEstacaoMonta);
        end;
      27: { Cobertura por monta controlada }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e27SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e27SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Consistindo animal touro
          Result := ConsistirAnimal(Arquivo.ValorColuna[e27SglFazendaManejoTouro],
            Arquivo.ValorColuna[e27CodAnimalManejoTouro], CodAnimal, DadosAnimalComErro);
          if Result < 0 then Exit;

          // Consistindo animal fêmea
          Result := ConsistirAnimal(Arquivo.ValorColuna[e27SglFazendaManejoFemea],
            Arquivo.ValorColuna[e27CodAnimalManejoFemea], CodAnimalFemea, DadosAnimalFemeaComErro);
          if Result < 0 then Exit;

          // Consistindo estação de monta
          Result := ConsistirEstacaoMonta(
            Arquivo.ValorColuna[e27SglEstacaoMonta], CodEventoEstacaoMonta);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirCoberturaMontaControlada(
            Arquivo.ValorColuna[eDtaInicio],
            CodFazenda,
            Arquivo.ValorColuna[eTxtObservacao],
            CodAnimal,
            -1,
            '',
            CodAnimalFemea,
            -1,
            '',
            CodEventoEstacaoMonta);
        end;
      28: { Diagnóstico de prenhez }
        begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e28SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e28SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          // Consistindo estação de monta
          Result := ConsistirEstacaoMonta(
            Arquivo.ValorColuna[e28SglEstacaoMonta], CodEventoEstacaoMonta);
          if Result < 0 then Exit;

          // Insere Evento
          Result := IntEventos.InserirDiagnosticoPrenhez(
            Arquivo.ValorColuna[eDtaInicio],
            CodFazenda,
            Arquivo.ValorColuna[eTxtObservacao],
            CodEventoEstacaoMonta);
        end;

      31: { Avaliação de características }
      begin
          // Consistindo fazenda
          if Arquivo.ValorColuna[e28SglFazenda] <> '' then begin
            Result := ConsistirFazenda(
              Arquivo.ValorColuna[e28SglFazenda], CodFazenda);
            if Result < 0 then Exit;
          end else begin
            CodFazenda := -1;
          end;

          if Arquivo.ValorColuna[eaCodTipoAvaliacao] <> '' then
          begin
            Result := ConsistirTipoAvaliacao(Arquivo.ValorColuna[eaCodTipoAvaliacao], CodTipoAvaliacao);
            if Result < 0 then
            begin
              Exit;
            end;
          end
          else
          begin
            CodTipoAvaliacao := -1;
          end;

         Result := IntEventos.InserirAvaliacao(Arquivo.ValorColuna[eDtaInicio],
                                               CodFazenda,
                                               Arquivo.ValorColuna[eTxtObservacao],
                                               CodTipoAvaliacao,
                                               -1);
      end;  
    else
      Mensagens.Adicionar(1312, Self.ClassName, NomeMetodo, [IntToStr(CodTipoEvento)]);
      Result := -1312;
    end;
  end;

  { Processando Animais associados a Eventos }
  function ProcessarEventosAnimais: Integer;
  var
    sQtdPeso: String;
    CodTipoEvento: Integer;
    cThousandSeparator: Char;
    cDecimalSeparator: Char;
    CodCaracteristicaAvaliacao: Integer;
  begin
    // Consiste inicialmente a quantidade de colunas da linha
    if not Arquivo.NumeroColunas in [3, 4, 5] then begin // 4 - eventos especiais: pesagem, diagnóstico de prenhez, exame andrológico
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Eventos - Animais']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodEvento := -1;
    CodAnimal := -1;
    CodFazendaManejo := -1;
    DtaAplicacaoEvento := Conexao.DtaSistema;
    LimparDadosEventoComErro(DadosEventoComErro);
    LimparDadosAnimalComErro(DadosAnimalComErro);

    // Consiste evento
    Result := EventosInseridos.BuscarCodigoEvento(
      Arquivo.ValorColuna[eaSeqEvento], CodEvento, DadosEventoComErro);
    if Result < 0 then Exit;

    // Identificando o tipo do evento
    CodTipoEvento := DadosEventoComErro.CodTipoEvento;

    // Eventos especiais de pesagem, exame andrológico e diagnóstico de prenhez
    // devem possuir a coluna 4 de informações adicionais
    if (CodTipoEvento in [22, 25, 28]) and (Arquivo.NumeroColunas <> 4) then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Eventos - Animais']);
      Result := -1294;
      Exit;
    end;

    // Verifica animal existente
    Result := ConsistirAnimal(Arquivo.ValorColuna[eaSglFazendaManejo],
      Arquivo.ValorColuna[eaCodAnimalManejo], CodAnimal, DadosAnimalComErro);
    if Result < 0 then Exit;

    // Associa o animal ao evento informado
    case CodTipoEvento of
      22: { Pesagem }
        begin
          cThousandSeparator := ThousandSeparator;
          cDecimalSeparator := DecimalSeparator;
          try
            ThousandSeparator := #0;
            DecimalSeparator := ',';
            sQtdPeso := FloatToStr(Arquivo.ValorColuna[eaQtdPesoAnimal]);
          finally
            ThousandSeparator := cThousandSeparator;
            DecimalSeparator := cDecimalSeparator;
          end;
          Result := IntAnimais.DefinirPesoAnimal(CodEvento, -1, IntToStr(CodAnimal),
            '', sQtdPeso, 'S');
        end;
      25: { Exame andrológico }
        begin
          Result := IntAnimais.DefinirExameAndrologico(CodEvento, IntToStr(CodAnimal),
            -1, '', Arquivo.ValorColuna[eaIndTouroApto]);
        end;
      28: { Diagnóstico de prenhez }
        begin
          Result := IntAnimais.DefinirDiagnosticoPrenhez(CodEvento, IntToStr(CodAnimal),
            -1, '', Arquivo.ValorColuna[eaIndVacaPrenha]);
        end;
      31: { Avaliação de características }
      begin
        if CodTipoAvaliacao <= 0 then
        begin
          qAux.SQL.Clear;
          qAux.SQL.Add(' select cod_tipo_avaliacao from tab_evento_avaliacao ');
          qAux.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa_produtor ');
          qAux.SQL.Add('    and cod_evento = :cod_evento ');
          qAux.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          qAux.ParamByName('cod_evento').AsInteger := CodEvento;
          qAux.Open;

          if qAux.IsEmpty then
          begin
            CodTipoAvaliacao := 0;
          end
          else
          begin
            CodTipoAvaliacao := qAux.FieldByName('cod_tipo_avaliacao').AsInteger;
          end;
        end;

        Result := ConsistirTipoCaracteristica(CodTipoAvaliacao,
                                              Arquivo.ValorColuna[avaSglTipoCaracateristica],
                                              CodCaracteristicaAvaliacao);
        if Result < 0 then
        begin
          Exit
        end;

        Result := IntAnimais.DefinirAvaliacao(CodEvento,
                                              CodAnimal,
                                              -1,
                                              '',
                                              CodCaracteristicaAvaliacao,
                                              StrToFloatDef(Arquivo.ValorColuna[avaValCaracteristica], 0));
      end;
    else
      Result := IntAnimais.AplicarEvento(IntToStr(CodAnimal), -1, '', -1, -1,
        CodEvento, 'S');
    end;
    ObtemErrosAplicacaoEvento;
  end;

  { Processando composição racial }
  function ProcessarComposicaoRacial: Integer;
  var
    iAuxCodAnimal: Integer;
  begin
    // Consiste inicialmente a quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 4 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Composição racial']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    if not bIniciouComposicaoRacial then begin
      bIniciouComposicaoRacial := True;
      CodAnimal := -1;
    end;
    CodFazendaManejo := -1;
    LimparDadosAnimalComErro(DadosAnimalComErro);
    iAuxCodAnimal := CodAnimal;

    // Verifica animal existente
    Result := ConsistirAnimal(Arquivo.ValorColuna[crSglFazendaManejo],
      Arquivo.ValorColuna[crCodAnimalManejo], CodAnimal, DadosAnimalComErro);
    if Result < 0 then Exit;

    // Verifica se é necessário limpar a composição racial do animal em questão
    if (iAuxCodAnimal <> CodAnimal) and (iQtdVezesProcessamento = 1) then begin
      Result := IntAnimais.LimparComposicaoRacial(CodAnimal);
      if Result < 0 then Exit;
    end;

    // Define composição racial para a raça e animal informado
    Result := IntAnimais.DefinirComposicaoRacial(CodAnimal,
      Arquivo.ValorColuna[crCodRaca], Arquivo.ValorColuna[crQtdComposicaoRacial]);
  end;

  { Consiste o tempo de execução método }
  procedure IdentificaTimeOut;
  var
    hh, nn, ss, iAux: Integer;
  begin
    if TempoMaximo < 0 then Exit;
    if TempoMaximo > 59 then begin
      iAux := TempoMaximo;
      ss := iAux mod 60;
      nn := Trunc(iAux / 60);
      if nn > 59 then begin
        iAux := nn;
        hh := Trunc(iAux / 60);
        nn := iAux mod 60;
      end else begin
        hh := 0;
      end;
    end else begin
      hh := 0;
      nn := 0;
      ss := TempoMaximo;
    end;
    tTimeOut := tTimeOut + EncodeTime(hh, nn, ss, 0);
  end;

  { Obtem valor de incremento do indicador de progresso }
  procedure ObterValorIncremento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  sum(qtd_total) as NumLinhas '+
      'from '+
      '  tab_quantidade_tipo_linha '+
      'where '+
      '  cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and cod_arquivo_importacao = :cod_arquivo_importacao ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArquivoImportacao;
    Q.Open;
    iProgressoIncremento := Q.FieldByName('NumLinhas').AsInteger div 100;
    iProgresso := 0;
  end;

  { Incrementa indicador de progresso }
  procedure IncrementarProgresso;
  begin
    Inc(iProgresso);
    if FCodTarefa > 0 then begin
      // Obtem a posição atual registrada do indicador de progresso
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_progresso as QtdProgresso '+
        'from '+
        '  tab_tarefa tt '+
        'where '+
        '  tt.cod_tarefa = :cod_tarefa ';
      Q.ParamByName('cod_tarefa').AsInteger := FCodTarefa;
      Q.Open;

      if (iProgresso <= 100) and (Q.FieldByName('QtdProgresso').AsInteger < iProgresso) then begin
        // Abre transação
        Conexao.Begintran;

        // Atualiza o indicador de progresso
        Q.Close;
        Q.SQL.Text :=
          'update tab_tarefa '+
          'set '+
          '  qtd_progresso = :qtd_progresso '+
          'where '+
          '  cod_tarefa = :cod_tarefa ';
        Q.ParamByName('qtd_progresso').AsInteger := iProgresso;
        Q.ParamByName('cod_tarefa').AsInteger := FCodTarefa;
        Q.ExecSQL;

        // Confirma transação
        Conexao.Commit;
      end;
    end;
  end;

  function VerificaProcessoSemelhanteAndamento(): Integer;
  var
    qAux: THerdomQuery;
    EncontrouThread: Boolean;
  begin
    qAux := THerdomQuery.Create(Conexao, nil);
    try
      try
        // Consiste registro na base do arquivo informado para o produtor corrente
        Result := VerificarRegistro(qAux);
        if Result < 0 then begin
          AtualizaSituacaoArqImport(qAux, 'I');
          Exit;
        end;

        EncontrouThread := True;
        while EncontrouThread do
        begin
          with qAux do
          begin
            SQL.Clear;
            SQL.Add(' select cod_tarefa ');
            SQL.Add('   from tab_tarefa tt ');
            SQL.Add('      , tab_arquivo_importacao tai ');
            SQL.Add('  where tt.cod_tarefa = tai.cod_ultima_tarefa ');
            SQL.Add('    and tt.cod_situacao_tarefa = :cod_situacao_tarefa ');
            SQL.Add('    and tai.nom_arquivo_upload = :nom_arquivo_upload ');
            SQL.Add('    and tt.cod_tarefa <> :cod_tarefa ');
            ParamByName('cod_situacao_tarefa').AsString := 'A';
            ParamByName('nom_arquivo_upload').AsString  := NomArquivoUpLoad;
            ParamByName('cod_tarefa').AsInteger         := FCodTarefa;
            Open;

            if IsEmpty then
            begin
              EncontrouThread := False;
              AtualizaSituacaoArqImport(qAux, 'P');
            end
            else
            begin
              EncontrouThread := True;
              Sleep(5000);
            end;
          end;
        end;
        Result := 0;        
      except
        on E:Exception do
        begin
          Mensagens.Adicionar(2248, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -2248;
          Exit;
        end;
      end;
    finally
      qAux.Free;
    end;
  end;

{ Processamento principal
  Realiza chamada para processamentos secundários }
begin
  CoInitialize(nil);
  // Identifica o instante de inicio do processamento
  tTimeOut := Now;
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['Inicio']);

  // Identifica o tempo máximo para processamento do método
  IdentificaTimeOut;

  // Define objetos a serem utilizados como não instanciados
  Q := nil;
  IntReprodutoresMultiplos := nil;
  IntAnimais := nil;
  IntEventos := nil;
  IntInventariosAnimais := nil;
  Processamento := nil;
  EventosInseridos := nil;
  Arquivo := nil;
  qAux := nil;

  try
    // Instancia objetos a serem utilizados
    Q := THerdomQuery.Create(Conexao, nil);

    // Verfica as tarefas, caso exista alguma tarefa com o mesmo nome de
    // arquivo de upload em andamento a tarefa deverá aguardar a conclusão do
    // processamento para que seja processada.
    ReturnValue := VerificaProcessoSemelhanteAndamento();
    if ReturnValue < 0 then
    begin
      AtualizaSituacaoArqImport(Q, 'I');
      Exit;
    end;

    // Verifica se produtor de trabalho foi definido
    if Conexao.CodProdutorTrabalho = -1 then
    begin
      Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
      AtualizaSituacaoArqImport(Q, 'I');
      ReturnValue := -307;
      // Terminate; 13/04/2004
      Exit;
    end;

    qAux := THerdomQuery.Create(Conexao, nil);
    IntReprodutoresMultiplos := TIntReprodutoresMultiplos.Create;
    IntAnimais := TIntAnimais.Create;
    IntEventos := TIntEventos.Create;
    IntInventariosAnimais := TIntInventariosAnimais.Create;
    Processamento := TProcessamento.Create;
    EventosInseridos := TEventosInseridos.Create;
    Arquivo := TArquivoLeitura.Create;
    try
      // Inicializa classe responsável por Reprodutores múltiplos
      ReturnValue := IntReprodutoresMultiplos.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        AtualizaSituacaoArqImport(Q, 'I');
        Exit;
      end;

      // Inicializa classe responsável por Animais
      ReturnValue := IntAnimais.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        Exit;
      end;

      // Inicializa classe responsável por Inventarios de Animais
      ReturnValue := IntInventariosAnimais.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        AtualizaSituacaoArqImport(Q, 'I');
        Exit;
      end;

      // Inicializa classe responsável por Eventos
      ReturnValue := IntEventos.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        AtualizaSituacaoArqImport(Q, 'I');
        Exit;
      end;

      // Verifica se o arquivo ainda está disponível para processamento
      ReturnValue := VerificarStatus;
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        AtualizaSituacaoArqImport(Q, 'I');
        Exit;
      end;

      // Verifica se o arquivo existe fisicamente em disco
      ReturnValue := VerificarArquivo;
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004  Q,
        AtualizaSituacaoArqImport(Q, 'I');
        Exit;
      end;

      // Obtem a data corrente do sistema (data + hora de processamento)
      DtaProcessamento := Conexao.DtaSistema;

      {Identifica arquivo de upload}
      Arquivo.NomeArquivo := NomArquivoImportacao;

      {Guarda resultado da tentativa de abertura do arquivo}
      ReturnValue := Arquivo.Inicializar;

      {Trata possíveis erros durante a tentativa de abertura do arquivo}
      if ReturnValue = EArquivoInexistente then begin
        AtualizaSituacaoArqImport(Q, 'I');
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1219;
        // Terminate; 13/04/2004
        Exit;
      end else if ReturnValue = EInicializarLeitura then begin
        AtualizaSituacaoArqImport(Q, 'I');
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1219;
        // Terminate; 13/04/2004
        Exit;
      end else if ReturnValue < 0 then begin
        AtualizaSituacaoArqImport(Q, 'I');
        Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1220;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se os dados do arquivo pertencem a certificadora}
      ReturnValue := ValidarCertificadora(Arquivo.NumCNPJCertificadora, Self);
      if ReturnValue <= 0 then begin
        if ReturnValue = 0 then begin
          Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
          ReturnValue := -1223;
        end;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se natureza do produtor foi informada e é válida}
      if (Arquivo.NaturezaProdutor <> 'F') and (Arquivo.NaturezaProdutor <> 'J') then begin
        Mensagens.Adicionar(1221, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1221;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se NumCNPJCPF do produtor foi informado e é valido}
      iAux := Length(Arquivo.NumCNPJCPFProdutor);
      if Arquivo.NaturezaProdutor = 'F' then begin
        if iAux <> 11 then begin
          Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, ['CPF']);
          ReturnValue := -1222;
          // Terminate; 13/04/2004
          Exit;
        end;
        sAux := Copy(Arquivo.NumCNPJCPFProdutor, 1, 9);
      end else begin
        if iAux <> 14 then begin
          Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, ['CNPJ']);
          ReturnValue := -1222;
          // Terminate; 13/04/2004
          Exit;
        end;
        sAux := Copy(Arquivo.NumCNPJCPFProdutor, 1, 12);
      end;
      if not VerificarCnpjCpf(sAux, Arquivo.NumCNPJCPFProdutor, 'N') then begin
        Mensagens.Adicionar(1222, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1222;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se o produtor pertence ao universo de produtores da certificadora}
      ReturnValue := ValidarProdutor(Arquivo.NaturezaProdutor,
        Arquivo.NumCNPJCPFProdutor, CodPessoaProdutor, Self);
      if ReturnValue <= 0 then begin
        if ReturnValue = 0 then begin
          Mensagens.Adicionar(1224, Self.ClassName, NomeMetodo, []);
          ReturnValue := -1224;
        end;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se o produtor do arquivo é o produtor corrente definido}
      if Conexao.CodProdutorTrabalho <> CodPessoaProdutor then begin
        Mensagens.Adicionar(1289, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1289;
        // Terminate; 13/04/2004
        Exit;
      end;

      { Caso o usuário logado seja um gestor, verifica se o produtor corrente,
        está relacionado a sua pessoa.
      }
      if Conexao.CodPapelUsuario = 9 then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select 1 ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico   = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor    = :cod_pessoa_gestor ');
        Q.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('    and tt.dta_fim_validade     is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade    is null ');
        Q.ParamByName('cod_pessoa_gestor').AsInteger   := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.Open;
        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2191, Self.ClassName, NomeMetodo, []);
          ReturnValue := -2191;
          Exit;
        end;
      end;

      // Limpa lista de mensagens geradas pelo sistema
      Mensagens.Clear;

      // Classe que auxilia na totalização de valores do processamento
      ReturnValue := Processamento.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        CancelarProcessamento;
        // Terminate; 13/04/2004
        Exit;
      end;
      Processamento.CodPessoaProdutor := Conexao.CodProdutorTrabalho;
      Processamento.CodArquivoImportacao := CodArquivoImportacao;

      // Classe que auxilia na identificação dos eventos inseridos
      ReturnValue := EventosInseridos.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then begin
        CancelarProcessamento;
        // Terminate; 13/04/2004
        Exit;
      end;
      EventosInseridos.CodPessoaProdutor := Conexao.CodProdutorTrabalho;
      EventosInseridos.CodArquivoImportacao := CodArquivoImportacao;

      // Abre transação
      Conexao.BeginTran;

      // Incrementa o contador de vezes que o arquivo foi processado
      IncrementarQtdVezesProcessamento;
      AtualizaSituacaoArqImport(Q, 'P');

      if LinhaInicial = 0 then begin
        // Limpa as ocorrências obtidas no último processamento
        LimparOcorrenciaProcessamento;
      end else begin
        // Posiciona o cursor de leitura do arquivo na linha imediatamente
        // anterior a linha a ser processada
        Arquivo.Posicionar(LinhaInicial-1);
      end;

      // Confirma transação
      Conexao.Commit;

      // Obtem valor de incremento do indicador de progresso
      ObterValorIncremento;
      iProgressoAux := 0;

      // Identifica status de timeout
      bTimeOut := (Now > tTimeOut) and (TempoMaximo <> -1);

      // Identifica processamento de composições raciais como não iniciado
      bIniciouComposicaoRacial := False;

      // Percorre o arquivo processando somente as linha ainda não processadas
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['Vai processar']);
      while (ReturnValue >= 0) and (Arquivo.EOF = False) and (bTimeOut = False) and not(Terminated) do begin
        // Incrementa indicador de progresso e registra se necessário
        Inc(iProgressoAux);
        if (iProgressoAux >= iProgressoIncremento) then begin
          IncrementarProgresso;
          iProgressoAux := 0;
        end;

        ReturnValue := Arquivo.ObterLinha; // Obtem linha do arquivo de importação
        if ReturnValue < 0 then begin
          if ReturnValue = ETipoColunaDesconhecido then begin
            ReturnValue := -1234;
          end else if ReturnValue = ECampoNumericoInvalido then begin
            ReturnValue := -1235;
          end else if ReturnValue = EDelimitadorStringInvalido then begin
            ReturnValue := -1236;
          end else if ReturnValue = EDelimitadorOutroCampoInvalido then begin
            ReturnValue := -1237;
          end else if ReturnValue = EOutroCampoInvalido then begin
            ReturnValue := -1238;
          end else if ReturnValue = EDefinirTipoLinha then begin
            ReturnValue := -1239;
          end else if ReturnValue = EAdicionarColunaLeitura then begin
            ReturnValue := -1240;
          end else if ReturnValue = EFinalDeLinhaInesperado then begin
            ReturnValue := -1243;
          end else begin
            ReturnValue := -1232;
          end;
          AtualizaSituacaoArqImport(Q, 'P');
          Mensagens.Adicionar(-ReturnValue, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);
          try
            Conexao.Begintran;
            ReturnValue := GravarOcorrenciaProcessamento;
            Conexao.Commit;
          except
            Conexao.Rollback;
          end;
          if ReturnValue < 0 then begin
            CancelarProcessamento;
            // Terminate; 13/04/2004
            Exit;
          end else begin
            Continue;
          end;
        end;

        // Verifica se a linha atual deve ser processada
        ReturnValue := ProcessarLinha(Arquivo.LinhasLidas);
        if ReturnValue < 0 then begin
          CancelarProcessamento;
          // Terminate; 13/04/2004
          Exit;
        end;

        if ReturnValue = 1 then begin
          // A linha atual deve ser processada!
          // Abre transação
          Conexao.BeginTran;

          // Salva situação atual
          Conexao.SaveTran('sp_tarefa');

          // Solicita ao sistema que nenhuma transação, a partir deste momento,
          // seja iniciada (begin tran), confirmada (commit) ou desfeita (rollback),
          // desabilitando o controle sobre transações
          Conexao.IgnorarNovasTransacoes := True;
          try
            // Identifica o tipo da linha e realiza o processamento adequado
            case (Arquivo.TipoLinha) of
              1: { Animais Não Especificado }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarAnimalNaoEspecificado']);
                ReturnValue := ProcessarAnimalNaoEspecificado();
              end;

              2: { Animais (Inserção) }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarAnimaisInsercao']);
                ReturnValue := ProcessarAnimaisInsercao();
              end;

              3: { Animais (Alteração) }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarAnimaisAlteracao']);
                ReturnValue := ProcessarAnimaisAlteracao();
              end;

              5: { Eventos }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarEventos']);
                ReturnValue := ProcessarEventos;
                if ReturnValue > 0 then
                begin
                  // Relaciona evento inserido no sistema com identificador de evento do arquivo
                  ReturnValue := EventosInseridos.Adicionar(ReturnValue,
                    Arquivo.ValorColuna[eSeqEvento]);
                end;
              end;

              6: { Animais Associados a Eventos }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarEventosAnimais']);
                ReturnValue := ProcessarEventosAnimais;
              end;

              9: { Inventário de Animais }
              begin
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['ProcessarInventarioAnimais']);
                ReturnValue := ProcessarInventarioAnimais();
              end;
            else
              Mensagens.Adicionar(1290, Self.ClassName, NomeMetodo, []);
              ReturnValue := -1290;
            end;
          finally
            // Reabilita ao sistema o controle sobre transações
            Conexao.IgnorarNovasTransacoes := False;
          end;
  //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['xxxxxxxxxxxxxxxxxxxxxxxx']);

          // Verifica se existe uma transação aberto
          if not Conexao.EmTransacao then begin
            Conexao.BeginTran;
          end else if ReturnValue < 0 then begin
            // Recupera situação anterior em caso de erro
            Conexao.RollTran('sp_tarefa');
          end;

          ReturnValue := TratarResultadoProcessamento(ReturnValue);
          // Verifica se um erro fatal foi identificado
          if ReturnValue < 0 then begin
            CancelarProcessamento;
            // Terminate; 13/04/2004
            Exit;
          end;

          // Cofirma transação
          Conexao.Commit;
        end;

        // Identifica status de timeout
        bTimeOut := (Now > tTimeOut) and (TempoMaximo <> -1);
      end;

      // Atualiza indicador de progresso se o procedimento foi concluído
      if Arquivo.EOF and (iProgresso <> 100) then begin
        iProgresso := 99;
        IncrementarProgresso;
        AtualizaSituacaoArqImport(Q, 'C');
      end;
      //Mensagens.Adicionar(99999, Self.ClassName, NomeMetodo, ['Processou']);

      // Identifica a quantidade real de linhas percorridas durante a execução do método
      iLinhasPercorridas := Arquivo.LinhasLidas;

      // Finaliza arquivo lido
      Arquivo.Finalizar;

      // Retorna status "ok" do método
      ReturnValue := iLinhasPercorridas;
    except
      on E: Exception do begin
        // Reabilita ao sistema o controle sobre transações
        Conexao.IgnorarNovasTransacoes := False;
        Conexao.Rollback;
        Mensagens.Adicionar(1284, Self.ClassName, NomeMetodo, [E.Message]);
        ReturnValue := -1284;
        // Terminate; 13/04/2004
        Exit;
      end;
    end;
  finally
    Conexao.IgnorarNovasTransacoes := False;
    if Assigned(IntReprodutoresMultiplos) then IntReprodutoresMultiplos.Free;
    if Assigned(IntAnimais) then IntAnimais.Free;
    if Assigned(IntEventos) then IntEventos.Free;
    if Assigned(IntInventariosAnimais) then IntInventariosAnimais.Free;
    if Assigned(Processamento) then Processamento.Free;
    if Assigned(EventosInseridos) then EventosInseridos.Free;
    if Assigned(Arquivo) then Arquivo.Free;
    if Assigned(Q) then Q.Free;
    if Assigned(qAux) then qAux.Free;
    CoUninitialize;
  end;
end;

function TThrProcessarArquivo.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

function TThrProcessarArquivo.ConsistirTipoAvaliacao(
  ESglTipoAvaliacao: String; var ECodTipoAvaliacao: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirTipoAvaliacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'select '+
        '  cod_tipo_avaliacao as CodTipoAvaliacao ' +
        'from '+
        '  tab_tipo_avaliacao ' +
        'where ' +
        '  sgl_tipo_avaliacao = :sgl_tipo_avaliacao ';
      Q.ParamByName('sgl_tipo_avaliacao').AsString := ESglTipoAvaliacao;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2217, Self.ClassName, NomeMetodo, [ESglTipoAvaliacao]);
        Result := -2217;
      end
      else
      begin
        ECodTipoAvaliacao := Q.FieldByName('CodTipoAvaliacao').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do
      begin
        Mensagens.Adicionar(2218, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2218;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TThrProcessarArquivo.ConsistirTipoCaracteristica(ECodTipoAvaliacao: Integer;
                                                          ESglTipoCaracteristica: String;
                                                          var ECodTipoCaracteristica: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirTipoCaracteristica';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        ' select '+
        '        cod_caracteristica as CodCaracteristica ' +
        '   from '+
        '        tab_caracteristica_avaliacao ' +
        '  where ' +
        '        cod_tipo_avaliacao = :cod_tipo_avaliacao ' +
        '    and sgl_caracteristica = :sgl_caracteristica ';
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := ECodTipoAvaliacao;
      Q.ParamByName('sgl_caracteristica').AsString  := ESglTipoCaracteristica;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2219, Self.ClassName, NomeMetodo, [ESglTipoCaracteristica]);
        Result := -2219;
      end
      else
      begin
        ECodTipoCaracteristica := Q.FieldByName('CodCaracteristica').AsInteger;
        Result := 0;
      end;
      Q.Close;
    except
      on E: Exception do
      begin
        Mensagens.Adicionar(2220, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2220;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;

end;

end.

