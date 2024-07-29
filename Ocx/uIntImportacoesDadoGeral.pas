// ****************************************************************************
// *  Projeto            : BoiTata
// *  Sistema            :
// *  Desenvolvedor      :
// *  Versão             : 1
// *  Data               :
// *  Documentação       :
// *  Código Classe      :  90
// *  Descrição Resumida :
// ****************************************************************************
// ****************************************************************************
unit uIntImportacoesDadoGeral;

{$DEFINE MSSQL}

interface

uses Classes, DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas,
     uFerramentas, uArquivo, uIntReprodutoresMultiplos,
     uIntImportacaoDadoGeral, uIntAnimais, uIntEventos, uConexao, uIntMensagens,
     uLibZipM, uIntPessoas ,uIntPropriedadesRurais, uIntFazendas, uIntLocais,
     uIntPessoasContatos;

type

//  TTipoArmazenamento = (taImportacao, taAutenticacao);
  TTipoArmazenamento = (taImportacao);

  TSQLTxt = record
    TipoLinha: Integer;
    Comentario: String;
    SQL: String;
  end;

  { tipo 8 }
  TDadosLocaisComErro = record
     NumCnpjCpf: Integer;
     SglFazenda: String;
     SglLocal: String;
     DesLocal: String;
  end;

  { tipo 9 }
  TDadosFazendasComErro = record
     NumCnpjCpf: Integer;
     SglFazenda: String;
     NomFazenda: String;
  end;

  { tipo 10 }
  TDadosProdutoresComErro = record
     NumCnpjCpf: Integer;
     SglProdutor: String;
     NomProdutor: String;
  end;

  { tipo 11 }
  TDadosPropriedadesComErro = record
     NumImovelReceitaFederal: Integer;
     NomPropriedadeRural: String;
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
 { TEventosInseridos = class(TIntClasseBDNavegacaoBasica)
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
  }

  { TProcessamento }
 TProcessamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipoArmazenamento: TTipoArmazenamento;
    FCodPessoa: Integer;
    FCodArqImportDadoGeral: Integer;
  public
    constructor Create; override;
    function IncLidas(CodTipoLinhaImportacao: Integer): Integer;
    function IncErradas(CodTipoLinhaImportacao: Integer): Integer;
    function IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
    property TipoArmazenamento: TTipoArmazenamento read FTipoArmazenamento write FTipoArmazenamento;
    property CodPessoa: Integer read FCodPessoa write FCodPessoa;
    property CodArqImportDadoGeral: Integer read FCodArqImportDadoGeral write FCodArqImportDadoGeral;
  end;


  { TArmazenamento }
  TArmazenamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipoArmazenamento: TTipoArmazenamento;
    FTipos: Array of TTipo;
    FCodPessoa: Integer;
    FCodArqImportDadoGeral: Integer;
    function GetQtdLinhasLidas(TipoLinhaImportacao: Integer): Integer;
  public
    constructor Create; override;
    procedure IncLidas(CodTipoLinhaImportacao: Integer);
    function Salvar: Integer;
    property TipoArmazenamento: TTipoArmazenamento read FTipoArmazenamento write FTipoArmazenamento;
    property CodArqImportDadoGeral: Integer read FCodArqImportDadoGeral write FCodArqImportDadoGeral;
    property QtdLinhasLidas[TipoLinhaImportacao: Integer]: Integer read GetQtdLinhasLidas;
    property CodPessoa: integer read FCodPessoa write FCodPessoa;
  end;

  { TThrProcessarArquivo }
 TThrProcessarArquivo = class(TThread)
  private
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FCodArqImportDadoGeral: Integer;
    FLinhaInicial: Integer;
    FTempoMaximo: Integer;
    FCodTarefa: Integer;

    function ConsistirFazenda(SglFazenda, NumCnpjCpfProdutor: String;
      var CodFazenda: Integer): Integer;
    function GetRetorno: Integer;
  protected
    procedure Execute; override;
  public
    constructor CreateTarefa(CodTarefa: Integer; Conexao: TConexao;
      Mensagens: TIntMensagens; CodArqImportDadoGeral, LinhaInicial,
      TempoMaximo: Integer);
    property CodTarefa: Integer read FCodTarefa;
    property Retorno: Integer read GetRetorno;
    property Conexao: TConexao read FConexao;
    property Mensagens: TIntMensagens read FMensagens;
    property CodArqImportDadoGeral: Integer read FCodArqImportDadoGeral;
    property LinhaInicial: Integer read FLinhaInicial;
    property TempoMaximo: Integer read FTempoMaximo;
  end;

  { TIntImportacoes }
  TIntImportacoesDadoGeral = class(TIntClasseBDNavegacaoBasica)
  private
    FIntImportacaoDadoGeral : TIntImportacaoDadoGeral;
    FProcesso: TThrProcessarArquivo;
    function ObterCodArqImportDado(var CodArqImportDadoGeral: Integer): Integer;
    function InserirArqImportDado( CodArqImportDadoGeral: Integer; NomArqImportDadoGeral,
  NomArqUpload, CodSituacaoArqImport, TxtMensagem: String; CodTipoOrigemArqImport: Integer ): Integer;
{  function ValidarProdutorUsuario(CodPessoaProdutor: Integer): Integer; }
  public
    constructor Create; override;
    destructor Destroy; override;
    //funções que estão descritas na documentação
    function ArmazenarArqUpload(CodTipoOrigemArqImport: Integer; NomArqUpload: String): Integer;
    function Buscar(CodArqImportDadoGeral: Integer): Integer;
    function Pesquisar(NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
    NomUsuarioUpload: String; CodTipoOrigemArqImport: Integer; CodSituacaoArqImport: String; DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim: TDateTime; NomUsuarioUltimoProc: String): Integer;
    function Excluir(CodArqImportDadoGeral: Integer): Integer;
    function ProcessarArquivo(CodArqImportDadoGeral, LinhaInicial,
      TempoMaximo: Integer): Integer;
    function PesquisarOcorrencias(CodArqImportDadoGeral,
      CodTipoRegImportacao, CodTipoMensagem: Integer): Integer;
    property IntImportacaoDadoGeral: TIntImportacaoDadoGeral read FIntImportacaoDadoGeral write FIntImportacaoDadoGeral;
  end;

  { Funções genéricas às classes }
  function ObterDadosCertificadora(var NomCertificadora,
    NumCNPJCertificadora: String; AOwner: TObject): Integer;
  function ValidarCertificadora(NumCNPJ: String; AOwner: TObject): Integer;
  function ValidarProdutor(Natureza, NumCNPJCPF: String;
    var CodPessoaProdutor: Integer; AOwner: TObject): Integer;

const
  RetornoSucesso: Integer = 10000;

implementation

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
  if (AOwner is TIntImportacoesDadoGeral) then begin
    Conexao := TIntImportacoesDadoGeral(AOwner).Conexao;
    Mensagens := TIntImportacoesDadoGeral(AOwner).Mensagens;
  end else if (AOwner is TThrProcessarArquivo) then begin
    Conexao := TThrProcessarArquivo(AOwner).Conexao;
    Mensagens := TThrProcessarArquivo(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
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
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(1211, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1211;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
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
  if (AOwner is TIntImportacoesDadoGeral) then begin
    Conexao := TIntImportacoesDadoGeral(AOwner).Conexao;
    Mensagens := TIntImportacoesDadoGeral(AOwner).Mensagens;
  end else if (AOwner is TThrProcessarArquivo) then begin
    Conexao := TThrProcessarArquivo(AOwner).Conexao;
    Mensagens := TThrProcessarArquivo(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Text :=
        'select '+
        '  tp.cod_pessoa as CodPessoaProdutor '+
        'from '+
        '  tab_pessoa tp '+
        '  , tab_pessoa_papel tpp '+
        '  , tab_produtor tpr '+
        'where '+
        '  tp.dta_fim_validade is null '+
       // '  and tpr.cod_pessoa_produtor = tp.cod_pessoa '+
        '  and tpp.dta_fim_validade is null '+
        '  and tpp.cod_papel = 4 '+
        '  and tpp.cod_pessoa = tp.cod_pessoa '+
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
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(1225, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1225;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


{ TIntImportacoesDadoGeral }
function TIntImportacoesDadoGeral.ArmazenarArqUpload(
  CodTipoOrigemArqImport: Integer; NomArqUpload: String): Integer;
const
  Metodo: Integer = 511;
  NomeMetodo: String = 'ArmazenarArqUpload';
var
  Q: THerdomQuery;
  ArquivoUpload: TArquivoLeitura;
  ArquivoImportacao: TArquivoEscrita;
  Armazenamento: TArmazenamento;
  ArquivoZip: unzFile;
  sOrigem, sDestino, sRetornoErro, sAux, sNomArqUploadOriginal, MsgErro: String;
  iAux, CodArqImportDadoGeral: Integer;
//  CodPessoaProdutor: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Armazena o nome original do arquivo de upload
  sNomArqUploadOriginal := NomArqUpload;

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
  if not FileExists(sOrigem + NomArqUpload) then begin
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
          // Remove o arquivo temporário de imagem da pasta temporária
          //if CodTipoOrigemArqImport = 1 then
            //DeleteFile(sOrigem);
          // Gera Mensagem erro informando o problema ao usuário
          Mensagens.Adicionar(1217, Self.ClassName, NomeMetodo, []);
          Result := -1217;
          Exit;
        end;
      end;

    // Armazena o arquivo de upload via FTP na pasta de retorno
    // Ao final do processo, caso o mesmo tenha sido bem sucedido, esse arquivo será excluído
    Win32_CopiaArquivo(sOrigem + sNomArqUploadOriginal, sRetornoErro + sNomArqUploadOriginal);
  end;

  // Verifica se o arquivo de upload está compactado
  if UpperCase(ExtractFileExt(NomArqUpload)) = '.ZIP' then begin
    // Tentar abrir o arquivo ZIP
    Result := AbrirUnZip(sOrigem+NomArqUpload, ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1360, Self.ClassName, NomeMetodo, [NomArqUpload]);
      DeleteFile(sOrigem+NomArqUpload);
      Result := -1360;
      Exit;
    end;

    // Consiste o número de arquivo dentro do Arquivo ZIP
    Result := NumArquivosDoUnZip(ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArqUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArqUpload);
      Result := -1361;
      Exit;
    end else if Result > 1 then begin
      Mensagens.Adicionar(1362, Self.ClassName, NomeMetodo, [NomArqUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArqUpload);
      Result := -1362;
      Exit;
    end;

    // Obtem o nome do primeiro arquivo (teoricamente deve ser o último)
    sAux := NomeArquivoCorrenteDoUnzip(ArquivoZip);

    // Extrai o arquivo compactado
    Result := ExtrairArquivoDoUnZip(ArquivoZip, sAux, sOrigem);
    if Result <> 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArqUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem+NomArqUpload);
      if (Result = -5) or (Result = -6) then begin
        DeleteFile(sOrigem+sAux);
      end;
      Result := -1361;
      Exit;
    end;

    // Fechar arquivo ZIP
    FecharUnZip(ArquivoZip);

    // Apaga arquivo compactado
    DeleteFile(sOrigem+NomArqUpload);
    NomArqUpload := ExtractFileName(sAux);
  end;

  // Define caminho e arquivo completo da origem
  sOrigem := sOrigem + NomArqUpload;

  // Recupera pasta adequada dos arquivos
  sDestino := ValorParametro(38);
  if (Length(sDestino)=0) or (sDestino[Length(sDestino)]<>'\') then begin
    sDestino := sDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then begin
    if not ForceDirectories(sDestino) then begin
      // Remove o arquivo temporário de imagem da pasta temporária
      //if CodTipoOrigemArqImport = 1 then begin
        DeleteFile(sOrigem);
      //end;
      // Gera Mensagem erro informando o problema ao usuário
      Mensagens.Adicionar(1217, Self.ClassName, NomeMetodo, []);
      Result := -1217;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    ArquivoUpload := TArquivoLeitura.Create;
    Try
      ArquivoImportacao := TArquivoEscrita.Create;
      Try
        {Obtem um código para o arquivo}
        {Este procedimento possui uma transação a parte para obtenção do código }
        Result := ObterCodArqImportDado(CodArqImportDadoGeral);
        If Result < 0 then Begin
          MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
          Result:= -1;
          Exit;
        end;

        Try
          {Habilita a sequencia  de leitura "linha-a-linha" (não saltando linhas
          em branco, comentários, nem mesmo o header (apenas obtem seus dados e
          retorna ao início do arquivo, aguardando uma nova instrução))}
          ArquivoUpload.LinhaaLinha := True;
          {Identifica arquivo de upload}
          ArquivoUpload.NomeArquivo := sOrigem;
          {Guarda resultado da tentativa de abertura do arquivo}

          Result := ArquivoUpload.Inicializar;
          If Result < 0 then Begin
            {Trata possíveis erros durante a tentativa de abertura do arquivo}
            if Result = EArquivoInexistente then begin
              Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end else if Result = EInicializarLeitura then begin
              Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end else if Result < 0 then begin
              Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1220;
            end;
            {Caso o arquivo esteja inválido, um registro deve ser gerado na base de dados informando o erro}
            {Inicializa transação}
            BeginTran;
            {Armazena arquivo}
            Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
            If Result >= 0 then Commit
            else begin
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              RollBack;
            end;

            {Força um erro para que as devidas operações sejam realizadas}
            Result := -1;
            Exit;
          end;

          {Verifica se os dados do arquivo pertencem a certificadora}
          Result := ValidarCertificadora(ArquivoUpload.NumCNPJCertificadora, Self);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1223;
            end;
            {Caso o arquivo esteja inválido, um registro deve ser gerado na base de dados informando o erro}
            {Inicializa transação}
            BeginTran;
            {Armazena arquivo}
            Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
            If Result >= 0 then Commit
            else begin
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              RollBack;
            end;
            {Força um erro para que as devidas operações sejam realizadas}
            Result := -1;
            Exit;
          end;

{VERIFICAR ESTE
          Result := ValidarProdutorUsuario(Conexao.CodUsuario);
          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1246, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1246;
            end;
            //Caso o arquivo esteja inválido, um registro deve ser gerado na base de dados informando o erro
            //Inicializa transação
            BeginTran;
            //Armazena arquivo
            Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
            If Result >= 0 then Commit
            else begin
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              RollBack;
            end;
            //Força um erro para que as devidas operações sejam realizadas
            Result := -1;
            Exit;
          end;
}

          {Identifica arquivo a ser salvo em disco na pasta correta}
          sAux := 'HRG'+ StrZero(CodArqImportDadoGeral, 7)+'.txt';
          sDestino := sDestino + sAux;
          {Inicia procedimento de armazenamento definitivo do arquivo}
          ArquivoImportacao.NomeArquivo := sDestino;
          if (ArquivoImportacao.Inicializar = 0) then begin
            Armazenamento := TArmazenamento.Create;
            try
              Result := Armazenamento.Inicializar(Conexao, Mensagens);
              if Result < 0 then Exit;
              Armazenamento.CodPessoa := Conexao.CodUsuario;
              Armazenamento.CodArqImportDadoGeral := CodArqImportDadoGeral;
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
                  Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
                  If Result >= 0 then Commit
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
                  Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
                  If Result >= 0 then Commit
                  else begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    RollBack;
                  end;
                  {Força um erro para que as devidas operações sejam realizadas}
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
              Result := InserirArqImportDado(CodArqImportDadoGeral, sAux, NomArqUpload, 'N', ' ', CodTipoOrigemArqImport);
              Commit;
              If Result >= 0 then begin
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

            BeginTran;
            {Atualiza a quantidade real de linhas do arquivo}
            Q.Close;
            Q.SQL.Text :=
              'update tab_arq_import_dado_geral '+
              'set '+
              '  qtd_linhas = :qtd_linhas '+
              'where '+
              '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
            Q.ParamByName('qtd_linhas').AsInteger := ArquivoUpload.LinhasLidas;
            Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
            Q.ExecSQL;

            {Finaliza arquivo upload}
            ArquivoUpload.Finalizar;

            {Verifica a existência de um arquivo de upload como o mesmo, havendo gera uma mensagem}
            Q.Close;
            Q.SQL.Text :=
              'select '+
              '  count(1) as QtdArquivo '+
              'from '+
              '  tab_arq_import_dado_geral '+
              'where '+
              '  nom_arq_upload like :nom_arquivo_upload ';
            Q.ParamByName('nom_arquivo_upload').AsString := NomArqUpload;
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
              DeleteFile(sRetornoErro + sNomArqUploadOriginal);
            end;

            {Identifica procedimento como bem sucedido, retornado o código do arquivo inserido}
            Result := CodArqImportDadoGeral;
          end else begin
            Rollback; {Desfaz atualizações realizadas na base}
            Mensagens.Adicionar(1228, Self.ClassName, NomeMetodo, []);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1228;
            exit;
          end;
        Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1218;
            Exit;
          End;
        End;
      Finally
        ArquivoImportacao.Free;
        ArquivoUpload.Free;
        {Remove arquivo de destino caso o procedimento tenha sido mal sucedido}
        {e atualiza a situação do arquivo}
        if (Result < 0) then
        Begin
          Try
            BeginTran;
            Q.Close;
            Q.SQL.Text :=
              'update tab_arq_import_dado_geral '+
              'set '+
              '  cod_situacao_arq_import = :codSituacaoArqImport, '+
              '  txt_mensagem = :txtMensagem '+
              'where '+
              '      cod_arq_import_dado_geral = :codArquivoImportacao ';
            Q.ParamByName('codSituacaoArqImport').AsString := 'I';
            Q.ParamByName('codArquivoImportacao').AsInteger := CodArqImportDadoGeral;
            Q.ParamByName('txtMensagem').AsString := MsgErro;
            Q.ExecSQL;
            {Finaliza transação, garantindo atualizações realizadas}
            Commit;
          Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1218;
          End;
          End;

          If FileExists(sDestino) then begin
            {Tenta excluir o arquivo de importação gerado}
            If not DeleteFile(sDestino) then begin
              Try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arq_import_dado_geral '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '  cod_arq_import_dado_geral = :codArquivoImportacao ';
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArqImportDadoGeral;
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir o arquivo de importação. ';
                Q.ExecSQL;
                {Finaliza transação, garantindo atualizações realizadas}
                Commit;
              Except
              On E: Exception do Begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              End;
              End;
            End;
          End;

          If (FileExists(sOrigem) and (CodTipoOrigemArqImport = 2)) then  begin // FTP
            Try
//              Após a alteração realizada no início deste procedimento o arquivo
//              já se encontra na pasta de retorno e não é + necessária esta cópia
//              CopiaArquivo(sOrigem, sRetornoErro + NomArqUpload);
              If FileExists(sOrigem) then DeleteFile(sOrigem);
            Except
              Try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arq_import_dado_geral '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '  cod_arq_import_dado_geral = :codArquivoImportacao ';
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArqImportDadoGeral;
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir ou mover o arquivo de origem. ';
                Q.ExecSQL;
                //Finaliza transação, garantindo atualizações realizadas
                Commit;
              Except
              On E: Exception do Begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              End;
              End;
            End;
          End Else Begin // Upload
            Try
              If FileExists(sOrigem) then DeleteFile(sOrigem);
            Except
              Try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arq_import_dado_geral '+
                  'set '+
                  '  cod_situacao_arq_import = :codSituacaoArqImport, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '  cod_arq_import_dado_geral = :codArquivoImportacao ';
                Q.ParamByName('codSituacaoArqImport').AsString := 'I';
                Q.ParamByName('codArquivoImportacao').AsInteger := CodArqImportDadoGeral;
                Q.ParamByName('txtMensagem').AsString := ' Erro ao excluir o arquivo de origem. ';
                Q.ExecSQL;
                //Finaliza transação, garantindo atualizações realizadas
                Commit;
              Except
              On E: Exception do Begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                Result := -1218;
              End;
              End;
            End;
          End;
        End;
      End;
    Finally
      {Tenta excluir o arquivo origem}
      If ((Result >= 0) and (FileExists(sOrigem)) and (not DeleteFile(sOrigem))) then begin
        Try
          BeginTran;
          Q.Close;
          Q.SQL.Text :=
            'update tab_arq_import_dado_geral '+
            'set '+
            '  cod_situacao_arq_import = :codSituacaoArqImport, '+
            '  txt_mensagem = txt_mensagem + :txtMensagem '+
            'where '+
            '  cod_arq_import_dado_geral = :codArquivoImportacao ';
          Q.ParamByName('codSituacaoArqImport').AsString := 'I';
          Q.ParamByName('codArquivoImportacao').AsInteger := CodArqImportDadoGeral;
          Q.ParamByName('txtMensagem').AsString := 'Erro ao excluir o arquivo de origem. ';
          Q.ExecSQL;
          {Finaliza transação, garantindo atualizações realizadas}
          Commit;
        Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -1218;
        End;
        End;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntImportacoesDadoGeral.Buscar(
  CodArqImportDadoGeral: Integer): Integer;
const
  Metodo: Integer = 515;
  NomeMetodo: String = 'Buscar';
var
  Q: THerdomQuery;
  Query: THerdomQuery;
  CodUsuarioUltimoProc, CodUsuarioUpload: Integer;
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

 // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Query := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.Close;
      {Montando query de pesquisa de acordo com os críterios informados}
      Q.SQL.Text :=
        'select '+
        '    tai.cod_arq_import_dado_geral as CodArquivoImportacaoDadoGeral '+
        '  , tai.nom_arq_upload as NomArqUpload '+
        '  , tai.nom_arq_import_dado_geral as NomArquivoImportacaoDadoGeral '+
        '  , tai.dta_importacao as DtaImportacao '+
        '  , tai.cod_usuario_upload as CodUsuarioUpload ' +
        '  , tai.cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
        '  , tai.cod_situacao_arq_import as CodSituacaoArqImport '+
        '  , tai.qtd_vezes_processamento as QtdVezesProcessamento '+
        '  , tai.qtd_linhas as NumLinhas '+
        '  , tai.dta_ultimo_processamento as DtaUltimoProcessamento '+
        '  , tai.cod_usuario_ultimo_proc as CodUsuarioUltimoProc ' +
        '  , tai.txt_mensagem as TxtMensagem '+
        '  , tai.cod_ultima_tarefa as CodUltimaTarefa '+
        'from '+
        '    tab_arq_import_dado_geral tai '+
        '  , tab_usuario tu '+
        '  , tab_usuario tuu '+
        'where '+
        '     tu.cod_usuario = tai.cod_usuario_upload '+
        {$IFDEF MSSQL}
        'and  tuu.cod_usuario =* tai.cod_usuario_ultimo_proc '+
        {$ENDIF}
        'and  tai.cod_arq_import_dado_geral = :cod_arq_import_dado_geral ';

      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      End;

      CodUsuarioUpload := Q.FieldByName('CodUsuarioUpload').AsInteger;
      CodUsuarioUltimoProc := Q.FieldByName('CodUsuarioUltimoProc').AsInteger;

      {Buscando nome de usuario upload}
      Query.Close;
      Query.SQL.Text := 'select nom_usuario from tab_usuario '+
              ' where cod_usuario = :cod_usuario_upload ';
      Query.ParamByName('cod_usuario_upload').AsInteger := CodUsuarioUpload;
      Query.Open;
      FIntImportacaoDadoGeral.NomUsuarioUpload       :=Query.FieldByName('nom_usuario').AsString;

      {Buscando nome de usuario ultimo processamento}
      Query.Close;
      Query.SQL.Text := 'select nom_usuario from tab_usuario '+
              ' where cod_usuario = :cod_usuario_ultimo_proc ';
      Query.ParamByName('cod_usuario_ultimo_proc').AsInteger := CodUsuarioUltimoProc;
      Query.Open;
      FIntImportacaoDadoGeral.CodUsuarioUltimoProc   :=Q.FieldByName('CodUsuarioUltimoProc').AsInteger;
      FIntImportacaoDadoGeral.NomUsuarioUltimoProc   :=Query.FieldByName('nom_usuario').AsString;

      { Busca dados da sigla e descrição da origem do arquivo de importação, através do cod_tipo_origem_arq_import da consulta principal }
      Query.Close;
      Query.SQL.Text := 'select sgl_tipo_origem_arq_import, des_tipo_origem_arq_import from tab_tipo_origem_arq_import ' +
                ' where cod_tipo_origem_arq_import = :cod_tipo_origem ';
      Query.ParamByName('cod_tipo_origem').AsInteger := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      Query.Open;
      FIntImportacaoDadoGeral.SglTipoOrigemArqImport := Query.FieldByName('sgl_tipo_origem_arq_import').AsString;
      FIntImportacaoDadoGeral.DesTipoOrigemArqImport := Query.FieldByName('des_tipo_origem_arq_import').AsString;

      {Busca informação da descrição da situação do arquivo de importação, através do CodSituacaoArqImport da consulta principal }
      Query.Close;
      Query.SQL.Text := 'select des_situacao_arq_import from tab_situacao_arq_import ' +
                ' where cod_situacao_arq_import = :cod_situacao ';
      Query.ParamByName('cod_situacao').AsString := Q.FieldByName('CodSituacaoArqImport').AsString;
      Query.Open;
      FIntImportacaoDadoGeral.DesSituacaoArqImport := Query.FieldByName('des_situacao_arq_import').AsString;

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
      FIntImportacaoDadoGeral.CodUltimaTarefa := Q.FieldByName('CodUltimaTarefa').AsInteger;
      FIntImportacaoDadoGeral.CodSituacaoUltimaTarefa := Query.FieldByName('CodSituacaoUltimaTarefa').AsString;
      FIntImportacaoDadoGeral.DesSituacaoUltimaTarefa := Query.FieldByName('DesSituacaoUltimaTarefa').AsString;
      FIntImportacaoDadoGeral.DtaInicioPrevistoUltimaTarefa := Query.FieldByName('DtaInicioPrevistoUltimaTarefa').AsDateTime;
      FIntImportacaoDadoGeral.DtaInicioRealUltimaTarefa := Query.FieldByName('DtaInicioRealUltimaTarefa').AsDateTime;
      FIntImportacaoDadoGeral.DtaFimRealUltimaTarefa := Query.FieldByName('DtaFimRealUltimaTarefa').AsDateTime;

      // Obtem informações do registro
      FIntImportacaoDadoGeral.CodArqImportDadoGeral  :=Q.FieldByName('CodArquivoImportacaoDadoGeral').AsInteger;
      FIntImportacaoDadoGeral.NomArqUpLoad           :=Q.FieldByName('NomArqUpload').AsString;
      FIntImportacaoDadoGeral.NomArqImportDadoGeral  :=Q.FieldByName('NomArquivoImportacaoDadoGeral').AsString;
      FIntImportacaoDadoGeral.DtaImportacao          :=Q.FieldByName('DtaImportacao').AsDateTime;
      FIntImportacaoDadoGeral.CodUsuarioUpload       :=Q.FieldByName('CodUsuarioUpload').AsInteger;
      FIntImportacaoDadoGeral.CodTipoOrigemArqImport :=Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      FIntImportacaoDadoGeral.CodSituacaoArqImport   :=Q.FieldByName('CodSituacaoArqImport').AsString;
      FIntImportacaoDadoGeral.QtdVezesProcessamento  :=Q.FieldByName('QtdVezesProcessamento').AsInteger;
      FIntImportacaoDadoGeral.QtdLinhas              :=Q.FieldByName('NumLinhas').asInteger;
      FIntImportacaoDadoGeral.DtaUltimoProcessamento :=Q.FieldByName('DtaUltimoProcessamento').AsDateTime;
      FIntImportacaoDadoGeral.TxtMensagem            :=Q.FieldByName('TxtMensagem').AsString;

      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_total as QtdTotal '+
        '  , qtd_processadas as QtdProcessadas '+
        '  , qtd_erradas as QtdErradas '+
        'from '+
        '  tab_qtd_tipo_reg_import_geral '+
        'where '+
        '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;

      {Obtendo quantidade de linhas de Locais}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 8;
      Q.Open;

      FIntImportacaoDadoGeral.QtdLocaisProcessados := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacaoDadoGeral.QtdLocaisTotal       := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacaoDadoGeral.QtdLocaisErrados     := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;
 
      {Obtendo quantidade de linhas de Fazendas}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 9;
      Q.Open;

      FIntImportacaoDadoGeral.QtdFazendasProcessadas := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacaoDadoGeral.QtdFazendasTotal       := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacaoDadoGeral.QtdFazendasErradas     := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;

      {Obtendo quantidade de linhas de Produtores}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 10;
      Q.Open;

      FIntImportacaoDadoGeral.QtdProdutoresProcessados  := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacaoDadoGeral.QtdProdutoresTotal        := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacaoDadoGeral.QtdProdutoresErrados      := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;

      {Obtendo quantidade de linhas de Propriedades}
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := 11;
      Q.Open;

      FIntImportacaoDadoGeral.QtdPropriedadesProcessadas := Q.FieldByName('QtdProcessadas').AsInteger;
      FIntImportacaoDadoGeral.QtdPropriedadesTotal       := Q.FieldByName('QtdTotal').AsInteger;
      FIntImportacaoDadoGeral.QtdPropriedadesErradas     := Q.FieldByName('QtdErradas').AsInteger;
      Q.Close;

      FIntImportacaoDadoGeral.QtdOcorrencias := 0;

      if FIntImportacaoDadoGeral.QtdVezesProcessamento > 0 then begin
        {Otendo quantidade de linhas com erro}
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasComErro '+
          'from '+
          '  tab_ocorrencia_import_geral '+
          'where '+
          '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
          '  and cod_tipo_mensagem in (1,2) ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := FIntImportacaoDadoGeral.CodArqImportDadoGeral;
        Q.Open;
        FIntImportacaoDadoGeral.QtdOcorrencias := Q.FieldByName('NumLinhasComErro').AsInteger;

        {Otendo quantidade de linhas total do log
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasLog '+
          'from '+
          '  tab_ocorrencia_import_geral '+
          'where '+
          '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := FIntImportacaoDadoGeral.CodArqImportDadoGeral;
        Q.Open;
        FIntImportacaoDadoGeral.QtdLinhasLogUltimoProc := Q.FieldByName('NumLinhasLog').AsInteger;
        }

        Q.Close;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1241, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1241;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


constructor TIntImportacoesDadoGeral.Create;
begin
  inherited;
   FIntImportacaoDadoGeral := TIntImportacaoDadoGeral.Create;
end;

destructor TIntImportacoesDadoGeral.Destroy;
begin
  FIntImportacaoDadoGeral.Free;
  inherited;
end;

function TIntImportacoesDadoGeral.Excluir(
  CodArqImportDadoGeral: Integer): Integer;
const
  Metodo: Integer = 516;
  NomeMetodo: String = 'Excluir';
var
  Q: THerdomQuery;
  sArquivo: String;
begin
  Result := -1;
 
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;


  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Recupera a pasta onde os arquivos são armazenados
      sArquivo := ValorParametro(38);
      if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
        sArquivo := sArquivo + '\';
      end;
 
      // Consiste existência do arquivo
      Q.SQL.Text :=
        'select nom_arq_import_dado_geral from tab_arq_import_dado_geral '+
        ' where cod_arq_import_dado_geral = :cod_arq_import_dado_geral   ';
      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('nom_arq_import_dado_geral').AsString;
      Q.Close;
 
      // Abre transação
      BeginTran;
 
      Q.SQL.Text :=
        'delete from tab_ocorrencia_import_geral '+
        'where cod_arq_import_dado_geral = :cod_arq_import_dado_geral ';
      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.ExecSQL;
 
      Q.SQL.Text :=
        'delete from tab_qtd_tipo_reg_import_geral '+
        'where cod_arq_import_dado_geral = :cod_arq_import_dado_geral ';
      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.ExecSQL;
 
      Q.SQL.Text :=
        'delete from tab_linha_arq_import_geral '+
        'where cod_arq_import_dado_geral = :cod_arq_import_dado_geral ';
      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_arq_import_dado_geral '+
        'where cod_arq_import_dado_geral = :cod_arq_import_dado_geral ';
      Q.ParamByName('cod_arq_import_dado_geral').AsInteger := CodArqImportDadoGeral;
      Q.ExecSQL;
 
      // Cofirma transação
      Commit;
 
      // Verifica existe do arquivo, e caso exista, o exclui
      DeleteFile(sArquivo);
 
      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1244, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1244;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntImportacoesDadoGeral.InserirArqImportDado(
  CodArqImportDadoGeral: Integer; NomArqImportDadoGeral,
  NomArqUpload, CodSituacaoArqImport, TxtMensagem: String; CodTipoOrigemArqImport: Integer ): Integer;
const
  NomeMetodo: String = 'InserirArqImportDado';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.SQL.Text :=
        'insert into tab_arq_import_dado_geral '+
        ' (cod_arq_import_dado_geral '+
        '  , nom_arq_upload '+
        '  , nom_arq_import_dado_geral '+
        '  , dta_importacao '+
        '  , cod_usuario_upload '+
        '  , qtd_vezes_processamento '+
        '  , qtd_linhas '+
        '  , dta_ultimo_processamento '+
        '  , cod_usuario_ultimo_proc  '+
        '  , cod_situacao_arq_import  '+
        '  , cod_tipo_origem_arq_import '+
        '  , txt_mensagem) ' +
        'values '+
        ' (:cod_arq_import '+
        '  , :nom_arq_upload '+
        '  , :nom_arq_import '+
{$IFDEF MSSQL}
        '  , getdate() '+
{$ENDIF}
        '  , :cod_usuario '+
        '  , 0 '+  //qtd_vezes_processamento
        '  , 0 '+  //qtd_linhas
        '  , null '+ //dta_ultimo_processamento
        '  , null '+ //cod_usuario_ultimo_proc
        '  , :cod_situacao_arq_import '+
        '  , :cod_tipo_origem_arq_mport '+
        '  , :txt_mensagem )';
      Q.ParamByName('cod_arq_import').AsInteger := CodArqImportDadoGeral;
      Q.ParamByName('nom_arq_import').AsString := NomArqImportDadoGeral;
      Q.ParamByName('nom_arq_upload').AsString := NomArqUpload;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
      Q.ParamByName('cod_tipo_origem_arq_mport').AsInteger := CodTipoOrigemArqImport;
      Q.ParamByName('txt_mensagem').AsString := TxtMensagem;
      Q.ExecSQL;
      // Identifica procedimento como bem sucedido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1230, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1230;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntImportacoesDadoGeral.ObterCodArqImportDado(
  var CodArqImportDadoGeral: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArqImportDado';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Abre transação
      BeginTran;

      // Executa um update que não afeta nenhuma linha para travar tabela
      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arq_import_geral set cod_seq_arq_import_geral = cod_seq_arq_import_geral where cod_seq_arq_import_geral is null');
      {$ENDIF}
      Q.ExecSQL;

      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arq_import_geral), 0) + 1 as CodSeqArqImportGeral from tab_seq_arq_import_geral ');
      {$ENDIF}
      Q.Open;

      CodArqImportDadoGeral := Q.FieldByName('CodSeqArqImportGeral').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arq_import_geral set cod_seq_arq_import_geral = cod_seq_arq_import_geral + 1');
      {$ENDIF}
      Q.ExecSQL;


      Q.Close;

      // Fecha a transação
      Commit;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1229, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1229;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntImportacoesDadoGeral.Pesquisar(NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
    NomUsuarioUpload: String; CodTipoOrigemArqImport: Integer; CodSituacaoArqImport: String; DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim: TDateTime; NomUsuarioUltimoProc: String): Integer;
const
  Metodo: Integer = 514;
  NomeMetodo: String = 'Pesquisar';
var
  CodUsuarioUpload, CodUsuarioUltimoProc: Integer;
begin
  Result := -1;
  CodUsuarioUpload := -1;
  CodUsuarioUltimoProc := -1;


  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
{  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  } 

  Try

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

    //resultSet para codigos de usuario Upload
    if NomUsuarioUltimoProc <> '' then begin
            Query.Close;
            Query.SQL.Text := 'select cod_usuario from tab_usuario ' +
                      ' where nom_usuario like :nom_usuario ';
            Query.ParamByName('nom_usuario').AsString := #37 + NomUsuarioUltimoProc + #37;
            Query.Open;
            CodUsuarioUltimoProc := Query.fieldbyname('cod_usuario').AsInteger;
    end;


    Query.Close;

    //usado apenas para setar cod_usuario_upload para uma variavel da Query e ser usado
    //no sub-select da query principal.
    if NomUsuarioUpload <> '' then begin
       Query.SQL.Text := Query.SQL.Text +
       '    and tu.cod_usuario = :cod_usuario_upload ';
       Query.ParamByName('cod_usuario_upload').AsInteger := CodUsuarioUpload;
    end;

    //usado apenas para setar cod_usuario_ultimo_proc para uma variavel da Query e ser usado
    //no sub-select da query principal.
    if NomUsuarioUltimoProc <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
      '    and tu2.cod_usuario = :cod_usuario_ultimo_proc ';
      Query.ParamByName('cod_usuario_ultimo_proc').AsInteger := CodUsuarioUltimoProc;
    end;

    {Montando query de pesquisa de acordo com os críterios informados}
    Query.SQL.Text :=

    ' select '+
    '      tai.cod_arq_import_dado_geral as CodArqImportDadoGeral '+
    '    , tai.nom_arq_upload as NomArqUpload                     '+
    '    , tai.dta_importacao as DtaImportacao                    ' +
    '    , (select nom_usuario from tab_usuario where cod_usuario = tai.cod_usuario_upload) as NomUsuarioUpload ' +
    '    , tor.sgl_tipo_origem_arq_import as SglTipoOrigemArqImport  '+
    '    , tai.cod_situacao_arq_import as SglSituacaoArqImport    '+
    '    , tai.dta_ultimo_processamento as DtaUltimoProcessamento ' +
//    if NomUsuarioUltimoProc <> '' then begin
//    Query.SQL.Text := Query.SQL.Text +
    '    , (select nom_usuario from tab_usuario where cod_usuario = tai.cod_usuario_ultimo_proc) as NomUsuarioUltimoProc ' +
//    '    , (select nom_usuario from tab_usuario where cod_usuario = :cod_usuario_ultimo_proc) as NomUsuarioUltimoProc ';
//    end else begin
//    Query.SQL.Text := Query.SQL.Text +
//    ' , null as NomUsuarioUltimoProc ';
//    end;
{$IFDEF MSSQL}
//    Query.SQL.Text := Query.SQL.Text +
    '         , (select sum(qtd_total) from tab_qtd_tipo_reg_import_geral '+
    '           where cod_arq_import_dado_geral = tai.cod_arq_import_dado_geral)'+
    '          as QtdRegistrosTotal '+

    '         , (select sum(qtd_erradas) from tab_qtd_tipo_reg_import_geral '+
    '            where cod_arq_import_dado_geral = tai.cod_arq_import_dado_geral) '+
    '           as QtdRegistrosErrados '+
{$ENDIF}
    '  from                                                    '+
    '      tab_arq_import_dado_geral tai                       '+
    '    , tab_ocorrencia_import_geral toc                     '+
    '    , tab_usuario tu                                      '+
    '    , tab_usuario tu2                                     '+
    '    , tab_qtd_tipo_reg_import_geral tqt                   '+
    '    , tab_situacao_arq_import tsa                         '+
    '    , tab_tipo_origem_arq_import tor                      '+
    '  where                                                   '+
{$IFDEF MSSQL}
   '    toc.cod_arq_import_dado_geral =* tai.cod_arq_import_dado_geral '+
   '   	and tqt.cod_arq_import_dado_geral =* tai.cod_arq_import_dado_geral '+
   '     and tsa.cod_situacao_arq_import =* tai.cod_situacao_arq_import '+
   '     and tor.cod_tipo_origem_arq_import =* tai.cod_tipo_origem_arq_import '+
   '     and tu.cod_usuario =* tai.cod_usuario_upload ' +
   '     and tu2.cod_usuario =* tai.cod_usuario_ultimo_proc ';
{$ENDIF}
    if NomArqUpload <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
      '    and tai.nom_arq_upload like :nom_arq_upload ';
      Query.ParamByName('nom_arq_upload').AsString := #37 + NomArqUpload + #37;
    end;

    if (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0) then begin
        Query.SQL.Text := Query.SQL.Text +
   '          and tai.dta_importacao >= :dta_importacao_inicio ' +
   '          and tai.dta_importacao < :dta_importacao_fim ';
        Query.ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
        Query.ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim)+1;
    end;

    if ((Conexao.CodPapelUsuario <> 2) or ((NomUsuarioUpload <> ''))) then begin
       if (NomUsuarioUpload <> '') then begin
         Query.SQL.Text := Query.SQL.Text +
         ' and tai.cod_usuario_upload in (select cod_usuario from tab_usuario where nom_usuario like :nom_usuario) ';
         Query.ParamByName('nom_usuario').AsString := #37 + NomUsuarioUpload + #37;
       end else begin
         Query.SQL.Text := Query.SQL.Text +
         ' and tai.cod_usuario_upload = :cod_usuario_upload ';
         Query.ParamByName('cod_usuario_upload').AsInteger := CodUsuarioUpload;
       end;
    end;

    if CodTipoOrigemArqImport > 0 then begin
       Query.SQL.Text := Query.SQL.Text +
       '   and tai.cod_tipo_origem_arq_import = :cod_tipo_origem_arq_import ';
       Query.ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
    end;

    if CodSituacaoArqImport <> '' then begin
       Query.SQL.Text := Query.SQL.Text +
       '   and tai.cod_situacao_arq_import = :cod_situacao_arq_import ';
       Query.ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
    end;

    if (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
   '      and tai.dta_ultimo_processamento >= :dta_ultimo_processamento_inicio '+
   '      and tai.dta_ultimo_processamento < :dta_ultimo_processamento_fim ';
      Query.ParamByName('dta_ultimo_processamento_inicio').AsDateTime := Trunc(DtaUltimoProcessamentoInicio);
      Query.ParamByName('dta_ultimo_processamento_fim').AsDateTime := Trunc(DtaUltimoProcessamentoFim) + 1;
    end;

    if NomUsuarioUltimoProc <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
      '    and tu2.cod_usuario = :cod_usuario_ultimo_proc ';
      Query.ParamByName('cod_usuario_ultimo_proc').AsInteger := CodUsuarioUltimoProc;
    end;


    {if (IndArqProcessado = 'S') and ((IndErrosNoProcessamento = 'S') or (IndErrosNoProcessamento = 'N')) then begin
    Query.SQL.Text := Query.SQL.Text +
       '   and tai.qtd_vezes_processamento > 0 ';
    end else if IndArqProcessado = 'N' then begin
      Query.SQL.Text := Query.SQL.Text +
       '   and tai.qtd_vezes_processamento = 0 ';
    end;
    }
    Query.SQL.Text := Query.SQL.Text +
      'group by                          '+
      '   tor.sgl_tipo_origem_arq_import '+
      '  , tai.cod_situacao_arq_import   '+
      '  , tai.cod_arq_import_dado_geral '+
      '  , tai.nom_arq_import_dado_geral '+
      '  , tai.nom_arq_upload            '+
      '  , tu.nom_usuario                '+
      '  , tai.dta_importacao            '+
      '  , tai.dta_ultimo_processamento  '+
      '  , toc.cod_arq_import_dado_geral '+
      '  , tai.cod_usuario_upload        '+
      '  , tai.cod_usuario_ultimo_proc   '+
      '  , tqt.cod_arq_import_dado_geral ';
      
    {if IndErrosNoProcessamento = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
      '  having                           '+
      '    toc.cod_arq_import_dado_geral  is not null ';

    end else if IndErrosNoProcessamento = 'N' then begin
      Query.SQL.Text := Query.SQL.Text +
      '  having                            '+
      '    toc.cod_arq_import_dado_geral is null ';
    end;
    }

    
    Query.SQL.Text := Query.SQL.Text +
      'order by                           '+
      '  tai.dta_importacao desc          ';
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1231, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1231;
      Exit;
    End;
  End;
end;

function TIntImportacoesDadoGeral.PesquisarOcorrencias(
  CodArqImportDadoGeral, CodTipoRegImportacao,
  CodTipoMensagem: Integer): Integer;
const
  Metodo: Integer = 513;
  NomeMetodo: String = 'PesquisarOcorrencias';
begin
  Result := -1;
 
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
 
  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  
  Try
    Query.Close;
    Query.SQL.Text :=
      'SELECT '+
      '      toc.cod_arq_import_dado_geral, '+
      '      toc.cod_tipo_reg_import_geral, '+
      '      toc.cod_tipo_mensagem, '+
      '      toc.txt_mensagem, '+
      '      toc.num_linha, '+
      '      toc.txt_identificacao, '+
      '      toc.txt_legenda_identificacao '+
      '  FROM tab_ocorrencia_import_geral toc, '+
      '       tab_arq_import_dado_geral tqi, '+
      '       tab_tipo_reg_import_geral ttl '+
{$IFDEF MSSQL}
      '  where '+
      '       toc.cod_arq_import_dado_geral = tqi.cod_arq_import_dado_geral '+
      '   and toc.cod_tipo_reg_import_geral = ttl.cod_tipo_reg_import_geral '+
{$ENDIF}
      '  and toc.cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Query.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
 
    if CodTipoRegImportacao <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';
      Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoRegImportacao;
    end Else Begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_reg_import_geral in ( 8,9,10,11 ) ';
    end;
 
    if CodTipoMensagem <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_mensagem = :cod_tipo_mensagem ';
      Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
    end else begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toc.cod_tipo_mensagem in (1,2) ';
    end;
 
    Query.SQL.Text := Query.SQL.Text +
      ' order by '+
      '  toc.cod_arq_import_dado_geral,  '+
      '  toc.cod_tipo_reg_import_geral ';
 
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1317, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1317;
      Exit;
    End;
  End;
end;


function TIntImportacoesDadoGeral.ProcessarArquivo(CodArqImportDadoGeral,
  LinhaInicial, TempoMaximo: Integer): Integer;
const
  Metodo: Integer = 512;
  NomeMetodo: String = 'ProcessarArquivo';
  CodTipoTarefa: Integer = 2;
var
  Q: THerdomQuery;
  sAux: String;
  tDtaInicioPrevisto, tHorarioAgNoturno: TDateTime;
  CodTipoOrigemArqImport,iNumLinhas, iNumLinhasMinimoAgImediato, iNumLinhasMinimoAgNoturno: Integer;
  NomArqImportDado: String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste existência do arquivo informado, obtendo a qtd de linhas do mesmo
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_linhas as NumLinhas '+
        '  , nom_arq_import_dado_geral as NomArqImportDado '+
        '  , cod_tipo_origem_arq_import as CodTipoOrigemArqImport '+
        '  , cod_situacao_arq_import as CodSituacaoArqImport ' +
        'from '+
        '  tab_arq_import_dado_geral tai '+
        'where '+
        '  tai.cod_arq_import_dado_geral = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('NumLinhas').AsInteger = 0) or (Q.FieldByName('CodSituacaoArqImport').AsString = 'I') then begin
        Mensagens.Adicionar(1343, Self.ClassName, NomeMetodo, []);
        Result := -1343;
        Exit;
      end;
      NomArqImportDado := Q.FieldByName('NomArqImportDado').AsString;
      CodTipoOrigemArqImport := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      iNumLinhas := Q.FieldByName('NumLinhas').AsInteger;
      Q.Close;

      // Otendo parametros para identifícação do tipo do processamento
      iNumLinhasMinimoAgImediato := StrToIntDef(ValorParametro(70), 1000);
      iNumLinhasMinimoAgNoturno := StrToIntDef(ValorParametro(71), 5000);
      sAux := ValorParametro(43);
      tHorarioAgNoturno := EncodeTime(
        StrToIntDef(Copy(sAux, 1, 2), 22),
        StrToIntDef(Copy(sAux, 4, 2), 0),
        StrToIntDef(Copy(sAux, 7, 2), 0),
        0);
      tDtaInicioPrevisto := DtaSistema;

      if CodTipoOrigemArqImport = 2 then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo]);
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
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      end else if iNumLinhas >= iNumLinhasMinimoAgNoturno then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo]);

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
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      end else if iNumLinhas >= iNumLinhasMinimoAgImediato then begin
        // Verifica se a tarefa já foi agendada
        Result := VerificarAgendamentoTarefa(CodTipoTarefa,
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo]);
        if Result <= 0 then begin
          if Result = 0 then begin
            Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
            Result := -1344;
          end;
          Exit;
        end;

        // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
        Result := SolicitarAgendamentoTarefa(CodTipoTarefa,
          [CodArqImportDadoGeral, LinhaInicial, -1, TempoMaximo],
          tDtaInicioPrevisto);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Result >= 0 then begin
          Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
          Result := -1345;
        end;
      end else begin
        // Processando agora
        FProcesso := TThrProcessarArquivo.CreateTarefa(-1, Conexao, Mensagens,
          CodArqImportDadoGeral, LinhaInicial, TempoMaximo);
        try
          // Aguarda o fim do processamento
          FProcesso.WaitFor;

          // Obtem o resultado do processamento
          Result := FProcesso.ReturnValue;
        finally
          FProcesso.Free;
        end;
      end;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(1284, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1284;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

(* Comentado em 08/10/2004 por não estar sendo mais usado

function TIntImportacoesDadoGeral.ValidarProdutorUsuario(
  CodPessoaProdutor: Integer): Integer;
const
  NomeMetodo: String = 'ValidarProdutorUsuario';
var
  Q: THerdomQuery;         
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

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
//        Q.ParamByName('cod_pessoa_usuario').AsInteger := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa_usuario').AsInteger := Conexao.CodUsuario;
      end;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        Result := 1;
      end;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1245, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1245;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end; *)

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

//executada pela ArmazenarArqUpload
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

//executado pela ArmazenarArqUpload
function TArmazenamento.Salvar: Integer;
const
  NomeMetodo: String = 'Salvar';

  SelectImportacao: String =
    ' select 1 as cod_tipo_reg_import_geral '+
    '  from tab_tipo_reg_import_geral ' +
    '  Where cod_tipo_reg_import_geral = :CodTipoRegImportGeral ';

  InsertImportacao: String =
    'insert into tab_qtd_tipo_reg_import_geral '+
    ' (cod_arq_import_dado_geral, '+
    '  cod_tipo_reg_import_geral, '+
    '  qtd_total, '+
    '  qtd_erradas, '+
    '  qtd_processadas) '+
    'values '+
    ' (:cod_arquivo_importacaoDadoGeral, '+
    '  :cod_tipo_reg_importacaoDadoGeral, '+
    '  :qtd_total, '+
    '  :qtd_erradas, '+
    '  :qtd_processadas) ';

var
  iAux: Integer;
begin
  Try
    Query.Close;
    if FTipoArmazenamento = taImportacao then begin
      Query.SQL.Text := SelectImportacao;
    end;

     // Valida os tipos de registros encontrados no arquivo antes de atualizar as quantidades.
    for iAux := 0 to Length(FTipos)-1 do begin
      Query.Close;
      Query.ParamByName('CodTipoRegImportGeral').AsInteger := FTipos[iAux].CodTipoLinha;
      Query.Open;
      If Query.fieldByName('cod_tipo_reg_import_geral').AsInteger <> 1 then
      begin
        Mensagens.Adicionar(1680, Self.ClassName, NomeMetodo, [inttostr(FTipos[iAux].CodTipoLinha)]);
        Result := -1680;
        Exit;
      end;
    end;

    Query.SQL.Text := InsertImportacao;

    for iAux := 0 to Length(FTipos)-1 do begin
      Query.ParamByName('qtd_total').AsInteger := FTipos[iAux].QtdLidas;
      Query.ParamByName('qtd_erradas').AsInteger := FTipos[iAux].QtdErradas;
      Query.ParamByName('qtd_processadas').AsInteger := FTipos[iAux].QtdProcessadas;
      {if FTipoArmazenamento = taImportacao then begin
        Query.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoaProdutor;
      end;}
      Query.ParamByName('cod_arquivo_importacaoDadoGeral').AsInteger := FCodArqImportDadoGeral;
      Query.ParamByName('cod_tipo_reg_importacaoDadoGeral').AsInteger := FTipos[iAux].CodTipoLinha;
      Query.ExecSQL;
    end;
    // Identifica procedimento como bem sucedido
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1322, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1322;
      Exit;
    End;
  End;
end;

{ TThrProcessarArquivo }


constructor TThrProcessarArquivo.CreateTarefa(CodTarefa: Integer;
  Conexao: TConexao; Mensagens: TIntMensagens; CodArqImportDadoGeral,
  LinhaInicial, TempoMaximo: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FCodTarefa := CodTarefa;
  FConexao := Conexao;
  FMensagens := Mensagens;
  FCodArqImportDadoGeral := CodArqImportDadoGeral;
  FLinhaInicial := LinhaInicial;
  FTempoMaximo := TempoMaximo;
  Priority := tpLowest;
  Suspended := False;
end;

function TThrProcessarArquivo.ConsistirFazenda(SglFazenda, NumCNPJCpfProdutor: String;
  var CodFazenda: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirFazenda';
var
  Q: THerdomQuery;
  CodPessoaProdutor: Integer;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

 
      Q.SQL.Text := 'select cod_pessoa from tab_pessoa '+
                    ' where num_cnpj_cpf = :num_cnpj_cpf_produtor ';
      Q.ParamByName('num_cnpj_cpf_produtor').AsString := NumCNPJCpfProdutor;
      Q.Open;
      
      CodPessoaProdutor := Q.FieldByName('cod_pessoa').AsInteger;
 
      Q.SQL.Clear;
      Q.SQL.Text :=
        'select '+
        '  tf.cod_fazenda as CodFazenda '+
        'from '+
        '  tab_fazenda tf '+
        'where '+
        '  tf.sgl_fazenda = :sgl_fazenda '+
        '  and cod_pessoa_produtor = :cod_pessoa '+
        '  and tf.dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
      Q.ParamByName('sgl_fazenda').AsString := UpperCase(SglFazenda);
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1291, Self.ClassName, NomeMetodo, [SglFazenda]);
        Result := -1291;
      end else begin
        CodFazenda := Q.FieldByName('CodFazenda').AsInteger;
        Result := 0;
      end;
      Q.Close;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(1293, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1293;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

procedure TThrProcessarArquivo.Execute;
const
  NomeMetodo: String = 'Execute';

  //Locais
//  loTipoRegistro: Integer = 1;
  loCodNaturezaProdutor: Integer = 1;
  loNumCNPJCpfProdutor: Integer = 2;
  loSglFazenda: Integer = 3;
  loSglLocal: Integer = 4;
  loDesLocal: Integer = 5;
  loCodTipoFonteAgua: Integer = 6;
  loCodTipoRegimeAlimentar: Integer = 7;

  //Fazendas
//  faTipoRegistro: Integer = 1;
  faCodNaturezaProdutor: Integer = 1;
  faNumCNPJCpfProdutor: Integer = 2;
  faSglFazenda: Integer = 3;
  faNomFazenda: Integer = 4;
  faCodEstado: Integer = 5;
  faNumPropriedadeRural: Integer = 6;
  faNumImovelReceitaFederal: Integer = 7;
  faCodRegimePosseUso: Integer = 8;
  faTxtObservacao: Integer = 9;
  faEfetivacaoCadastro: Integer = 10;

  //Produtores
//  proTipoRegistro: Integer = 1;
  proSglProdutor: Integer = 1;
  proNomProdutor: Integer = 2;
  proNomReduzidoProdutor: Integer = 3;
  proCodNaturezaProdutor: Integer = 4;
  proNumCNPJCpfProdutor: Integer = 5;
  proDtaNascimento: Integer = 6;
  proCodTipoEndereco: Integer = 7;
  proNomLogradouro: Integer = 8;
  proNomBairro: Integer = 9;
  proNumCep: Integer = 10;
  proCodPais: Integer = 11;
  proCodEstado: Integer = 12;
  proCodMunicipio: Integer = 13;
  proCodDistrito: Integer = 14;
  proCodTipoContato1: Integer = 15;
  proTxtContato1: Integer = 16;
  proCodTipoContato2: Integer = 17;
  proTxtContato2: Integer = 18;
  proCodTipoContato3: Integer = 19;
  proTxtContato3: Integer = 20;
  proCodTipoContato4: Integer = 21;
  proTxtContato4: Integer = 22;
  proCodTipoContato5: Integer = 23;
  proTxtContato5: Integer = 24;
  proTxtObservacao: Integer = 25;
  proEfetivacaoCadastro: Integer = 26;

  //PropriedadesRurais
//  priTipoRegistro: Integer = 1;
  priNomPropriedadeRural: Integer = 1;
  priNumImovelReceitaFederal: Integer = 2;
  priTipoInscricao: Integer = 3;
  priNumLatitude: Integer = 4;
  priNumLongitude: Integer = 5;
  priQtdArea: Integer = 6;
//  priCodNaturezaProprietario: Integer = 7;
//  priNroCNPJCpfProprietario: Integer = 8;
  priNomLogradouro: Integer = 7;
  priNomBairro: Integer = 8;
  priNumCep: Integer = 9;
  priCodPais: Integer = 10;
  priCodEstado: Integer = 11;
  priCodMunicipio: Integer = 12;
  priCodDistrito: Integer = 13;
  priNomPessoaContato: Integer = 14;
  priNumTelefone: Integer = 15;
  priNumFax: Integer = 16;
  priNumLogradouroCorrespondencia: Integer = 17;
  priNomBairroCorrespondencia: Integer = 18;
  priNumCepCorrespondencia: Integer = 19;
  priCodPaisCorrespondencia: Integer = 20;
  priCodEstadoCorrespondencia: Integer = 21;
  priCodMunicipioCorrespondencia: Integer = 22;
  priCodDistritoCorrespondencia: Integer = 23;
  priDtaInicioCertificacao: Integer = 24;
  priTxtObservacao: Integer = 25;
  priEfetivacaoCadastro: Integer = 26;

var
  Q: THerdomQuery;
  Arquivo: TArquivoLeitura;

  //INSERIR PRODUTOR, PROPRIEDADE, FAZENDA E LOCAL
  IntProdutores: TIntPessoas;
  IntPessoasContatos: TIntPessoasContatos;
  IntPropriedades: TIntPropriedadesRurais;
  IntFazendas: TIntFazendas;
  IntLocais: TIntLocais;
  Processamento: TProcessamento;

//  IntAnimais: TIntAnimais;
//  DadosAnimalComErro: TDadosAnimalComErro;
//  DadosEventoComErro: TDadosEventoComErro;

//  ErrosAplicacaoEvento: Array of TErroAplicacaoEvento;
  NomArqImportDadoGeral: String;
  bTimeOut: Boolean;
  tTimeOut, DtaProcessamento: TDateTime;
    iLinhasPercorridas, CodFazenda,
    iProgresso, iProgressoAux, iProgressoIncremento,
    iQtdVezesProcessamento: Integer;

  { Verifica se o registro informado é válido }
  function VerificarRegistro: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  nom_arq_import_dado_geral as NomArquivoImportacao '+
      'from '+
      '  tab_arq_import_dado_geral tai '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(1285, Self.ClassName, NomeMetodo, []);
      Result := -1285;
    end else begin
      NomArqImportDadoGeral := Q.FieldByName('NomArquivoImportacao').AsString;
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
      '  tab_linha_arq_import_geral tlai '+
      'where '+
      '  tlai.cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.Open;
    iiAux := Q.FieldByName('NumLinhas').AsInteger;
    if iiAux = 0 then begin
      Result := 0;
    end else begin
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  isnull(sum(qtd_total), 0) as NumLinhasAProcessar '+
        'from '+
        '  tab_qtd_tipo_reg_import_geral tqtl '+
        'where '+
        ' cod_arq_import_dado_geral = :cod_arquivo_importacao ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
      Q.Open;
      if iiAux < Q.FieldByName('NumLinhasAProcessar').AsInteger then begin
        Result := 0;
      end else begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasAProcessar '+
          'from '+
          '  tab_linha_arq_import_geral tlai '+
          'where '+
          '  tlai.dta_processamento is null '+
          '  and tlai.cod_arq_import_dado_geral = :cod_arquivo_importacao '+
          'group by '+
          '  tlai.cod_arq_import_dado_geral ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
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
    sArquivo := sArquivo + NomArqImportDadoGeral;
    if not FileExists(sArquivo) then begin
      Mensagens.Adicionar(1288, Self.ClassName, NomeMetodo, [NomArqImportDadoGeral]);
      Result := -1288;
      Exit;
    end;

    // Passo bem sucedido
    NomArqImportDadoGeral := sArquivo;
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

  function AtualizaSituacaoArqImport(CodSituacao: String): Integer;
  var QtdTotal, QtdProcessadas: Integer;
  begin
     if (CodSituacao = 'C') then begin
        Q.Close;
        Q.SQL.Clear;
        Q.SQL.Text :=
         'select sum(qtd_total) as qtd_total, sum(qtd_processadas) as qtd_processadas '+
         ' from tab_qtd_tipo_reg_import_geral where cod_arq_import_dado_geral = :cod_arquivo_importacao ';
        Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
        Q.Open;
          QtdTotal := Q.FieldByName('qtd_total').AsInteger;
          QtdProcessadas := Q.FieldByName('qtd_processadas').AsInteger;

        if (QtdTotal = QtdProcessadas) then begin
         Q.Close;
         Q.SQL.Clear;
         Q.SQL.Text :=
          'update tab_arq_import_dado_geral set cod_situacao_arq_import = ''C'' '+
           ' where cod_arq_import_dado_geral = :cod_arquivo_importacao '; //cod obtido no if acima
         Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
         Q.ExecSQL;
        end;
     end else begin
         Q.Close;
         Q.SQL.Clear;
         Q.SQL.Text :=
           'update tab_arq_import_dado_geral set cod_situacao_arq_import = :cod_situacao_arq_import ' +
                ' where cod_arq_import_dado_geral = :cod_arquivo_importacao ';
         Q.ParamByName('cod_situacao_arq_import').AsString := CodSituacao;
         Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
         Q.ExecSQL;
     end;
     Q.Close;
     Result := 0;
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
      '  tab_linha_arq_import_geral '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.Open;
    if Q.IsEmpty then begin
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_linha_arq_import_geral '+
        ' (cod_arq_import_dado_geral '+
        '  , num_linha '+
        '  , dta_processamento) '+
        'values '+
        ' (:cod_arquivo_importacao '+
        '  , :num_linha '+
        '  , null) ';
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
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
      '  tab_linha_arq_import_geral '+
      'set '+
      '  dta_processamento = :dta_processamento '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.ExecSQL;
  end;

  { Limpa as ocorrências obtidas no último processamento }
  procedure LimparOcorrenciaProcessamento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'delete from tab_ocorrencia_import_geral '+
      '  where cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.ExecSQL;
  end;

  { Incrementa o contador de vezes que o arquivo foi processado }
  procedure IncrementarQtdVezesProcessamento;
  begin
    // Incrementa o contador de vezes de processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_arq_import_dado_geral '+
      '   set qtd_vezes_processamento = qtd_vezes_processamento + 1 '+
      '     , dta_ultimo_processamento = :dta_ultimo_processamento '+
      '     , cod_usuario_ultimo_proc = :cod_usuario '+
      ' where cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('dta_ultimo_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
    Q.ExecSQL;

    // Obtem o valor do contador de vezes de processamento
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  qtd_vezes_processamento as QtdVezesProcessamento '+
      'from '+
      '  tab_arq_import_dado_geral '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.Open;
    iQtdVezesProcessamento := Q.FieldByName('QtdVezesProcessamento').AsInteger;

    // Zera o número de erros obtidos durante o último processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_qtd_tipo_reg_import_geral '+
      'set '+
      '  qtd_erradas = 0 '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
    Q.ExecSQL;
  end;

  { Guarda ocorrências durante o processamento }
  function GravarOcorrenciaProcessamento: Integer;
  var
    iiAux, jjAux: Integer;
  begin
    Result := 0;
    if (Mensagens.Count > 0) then begin
      Q.Close;

      // Script SQL de inseração de ocorrência durante o processamento
      Q.SQL.Text :=
        'insert into tab_ocorrencia_import_geral '+
        ' (cod_arq_import_dado_geral '+
        '  , dta_processamento '+
        '  , cod_tipo_reg_import_geral '+
        '  , cod_tipo_mensagem '+
        '  , txt_mensagem '+
        '  , num_linha '+
        '  , num_cnpj_cpf '+
        '  , sgl_produtor '+
        '  , nom_produtor '+
        '  , num_imovel_receita_federal '+
        '  , nom_propriedade_rural '+
        '  , sgl_fazenda'+
        '  , nom_fazenda'+
        '  , sgl_local'+
        '  , des_local'+
        '  , txt_identificacao'+
        '  , txt_legenda_identificacao)'+
        'values '+
        ' (:cod_arquivo_importacao '+
        '  , :dta_processamento '+
        '  , :cod_tipo_linha_importacao '+
        '  , :cod_tipo_mensagem '+
        '  , :txt_mensagem '+
        '  , :num_linha '+
        '  , :num_cnpj_cpf '+
        '  , :sgl_produtor '+
        '  , :nom_produtor '+
        '  , :num_imovel_receita_federal '+
        '  , :nom_propriedade_rural '+
        '  , :sgl_fazenda '+
        '  , :nom_fazenda '+
        '  , :sgl_local '+
        '  , :des_local '+
        '  , :txt_identificacao '+
        '  , :txt_legenda_identificacao) ';

      // Dados de identicação do arquivo e linha
      // Constantes a todos os tipos de ocorrências
      Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
      Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
      Q.ParamByName('cod_tipo_linha_importacao').AsInteger := Arquivo.TipoLinha;
      Q.ParamByName('num_linha').AsInteger := Arquivo.LinhasLidas;

      // Tipos dos dados de identificação da ocorrência
      // Variável de acordo com o tipo da linha
      Q.ParamByName('num_cnpj_cpf').DataType := ftString;
      Q.ParamByName('sgl_produtor').DataType := ftString;
      Q.ParamByName('nom_produtor').DataType := ftString;
      Q.ParamByName('num_imovel_receita_federal').DataType := ftString;
      Q.ParamByName('nom_propriedade_rural').DataType := ftString;
      Q.ParamByName('sgl_fazenda').DataType := ftString;
      Q.ParamByName('nom_fazenda').DataType := ftString;
      Q.ParamByName('sgl_local').DataType := ftString;
      Q.ParamByName('des_local').DataType := ftString;
      Q.ParamByName('txt_identificacao').DataType := ftString;
      Q.ParamByName('txt_legenda_identificacao').DataType := ftString;

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

        Try
          // Identificando o tipo da linha onde o erro ocorreu
          case (Arquivo.TipoLinha) of
            8: { Local }
              begin
                AtribuiValorParametro(Q.ParamByName('num_cnpj_cpf'), Arquivo.ValorColuna[loNumCNPJCpfProdutor]);
                AtribuiValorParametro(Q.ParamByName('sgl_fazenda'), Arquivo.ValorColuna[loSglFazenda]);
                AtribuiValorParametro(Q.ParamByName('sgl_local'), Arquivo.ValorColuna[loSglLocal]);
                AtribuiValorParametro(Q.ParamByName('des_local'), Arquivo.ValorColuna[loDesLocal]);
                if Arquivo.ValorColuna[loNumCNPJCpfProdutor] <> '' then begin
                    if Arquivo.ValorColuna[loSglLocal] <> '' then begin
                       AtribuiValorParametro(Q.ParamByName('txt_identificacao'), (Arquivo.ValorColuna[loNumCNPJCpfProdutor]+' - '+Arquivo.ValorColuna[loSglLocal]));
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'CNPJ/CPF Produtor - Código Local';
                    end else if Arquivo.ValorColuna[loDesLocal] <> '' then begin
                       AtribuiValorParametro(Q.ParamByName('txt_identificacao'), (Arquivo.ValorColuna[loNumCNPJCpfProdutor]+' - '+Arquivo.ValorColuna[loDesLocal]));
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'CNPJ/CPF Produtor - Descrição Local';
                    end else begin
                       Q.ParamByName('txt_identificacao').AsString := ' ';
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'Local não identificado';
                    end;
                end else begin
                       Q.ParamByName('txt_identificacao').AsString := ' ';
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'Local não identificado';
                end;
              end;
            9: { Fazenda }
              begin
                AtribuiValorParametro(Q.ParamByName('num_cnpj_cpf'), Arquivo.ValorColuna[faNumCNPJCpfProdutor]);
                AtribuiValorParametro(Q.ParamByName('sgl_fazenda'), Arquivo.ValorColuna[faSglFazenda]);
                AtribuiValorParametro(Q.ParamByName('nom_fazenda'), Arquivo.ValorColuna[faNomFazenda]);
                if Arquivo.ValorColuna[faNumCNPJCpfProdutor] <> '' then begin
                    if Arquivo.ValorColuna[faSglFazenda] <> '' then begin
                       AtribuiValorParametro(Q.ParamByName('txt_identificacao'), (Arquivo.ValorColuna[faNumCNPJCpfProdutor]+' - '+Arquivo.ValorColuna[faSglFazenda]));
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'CNPJ/CPF Produtor - Código Fazenda';
                    end else if Arquivo.ValorColuna[faNomFazenda] <> '' then begin
                       AtribuiValorParametro(Q.ParamByName('txt_identificacao'), (Arquivo.ValorColuna[faNumCNPJCpfProdutor]+' - '+Arquivo.ValorColuna[faNomFazenda]));
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'CNPJ/CPF Produtor - Nome Fazenda';
                    end else begin
                       Q.ParamByName('txt_identificacao').AsString := ' ';
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'Fazenda não identificada';
                    end;
                end else begin
                       Q.ParamByName('txt_identificacao').AsString := ' ';
                       Q.ParamByName('txt_legenda_identificacao').AsString := 'Fazenda não identificada';
                end;
              end;
            10: { Produtores }
              begin
                AtribuiValorParametro(Q.ParamByName('num_cnpj_cpf'), Arquivo.ValorColuna[proNumCNPJCpfProdutor]);
                AtribuiValorParametro(Q.ParamByName('sgl_produtor'), Arquivo.ValorColuna[proSglProdutor]);
                AtribuiValorParametro(Q.ParamByName('nom_produtor'), Arquivo.ValorColuna[proNomProdutor]);
                if Arquivo.ValorColuna[proNumCNPJCpfProdutor] <> '' then begin
                   AtribuiValorParametro(Q.ParamByName('txt_identificacao'), Arquivo.ValorColuna[proNumCNPJCpfProdutor]);
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'CNPJ/CPF Produtor';
                end else if Arquivo.ValorColuna[proNomProdutor] <> '' then begin
                   AtribuiValorParametro(Q.ParamByName('txt_identificacao'), Arquivo.ValorColuna[proNomProdutor]);
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'Nome do Produtor';
                end else if Arquivo.ValorColuna[proSglProdutor] <> '' then begin
                   AtribuiValorParametro(Q.ParamByName('txt_identificacao'), Arquivo.ValorColuna[proSglProdutor]);
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'Sigla do Produtor';
                end else begin
                   Q.ParamByName('txt_identificacao').AsString := ' ';
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'Produtor não identificado';
                end;
              end;
            11: { PropriedadesRurais }
              begin
                AtribuiValorParametro(Q.ParamByName('nom_propriedade_rural'), Arquivo.ValorColuna[priNomPropriedadeRural]);
                AtribuiValorParametro(Q.ParamByName('num_imovel_receita_federal'), Arquivo.ValorColuna[priNumImovelReceitaFederal]);
                if Arquivo.ValorColuna[priNumImovelReceitaFederal] <> '' then begin
                   AtribuiValorParametro(Q.ParamByName('txt_identificacao'), Arquivo.ValorColuna[priNumImovelReceitaFederal]);
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'NIRF';
                end else if Arquivo.ValorColuna[priNomPropriedadeRural] <> ''  then begin
                   AtribuiValorParametro(Q.ParamByName('txt_identificacao'), Arquivo.ValorColuna[priNomPropriedadeRural]);
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'Nome Propriedade Rural';
                end else begin
                   Q.ParamByName('txt_identificacao').AsString := ' ';
                   Q.ParamByName('txt_legenda_identificacao').AsString := 'Propriedade Rural não identificada';
                end;
              end;
          end;
          Q.ParamByName('cod_tipo_mensagem').AsInteger := Mensagens.Items[iiAux].Tipo;
          Q.ParamByName('txt_mensagem').AsString := Mensagens.Items[iiAux].Texto;
          Q.ExecSQL;
        except
          on E:Exception do
          begin
            Mensagens.Adicionar(1284, Self.ClassName, NomeMetodo, [E.Message]);
            ReturnValue := -1284;
            Exit;
          end;
        end;
      end;
      // Limpa mensagens geradas durante a última linha de processamento
      Mensagens.Clear;
    end;
  end;

  { Trata resultado da função de processamento }
  function TratarResultadoProcessamento(Resultado: Integer): Integer;
  begin
    if Resultado < 0 then begin
      Result := GravarOcorrenciaProcessamento;
      AtualizaSituacaoArqImport('P');
      if Result < 0 then Exit;
      Result := Processamento.IncErradas(Arquivo.TipoLinha);
    end else begin
      MarcarLinhaComoProcessada(Arquivo.LinhasLidas);
      Result := Processamento.IncProcessadas(Arquivo.TipoLinha);
      AtualizaSituacaoArqImport('C');      
    end;
  end;

  { Trata solicitação de alteração em atributo não disponível }
  function TratarAlteracaoAtributoNaoImplementada(DesAtributo: String): Integer;
  begin
    Mensagens.Adicionar(1304, Self.ClassName, NomeMetodo, [DesAtributo]);
    Result := -1304;
  end;

  //Chama Cadastro de LOCAIS
  function ProcessarLocais: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 7 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Locais']);
      Result := -1294;
      Exit;
    end;

    // Inicializando variáveis como não informadas
    CodFazenda := -1;

    // Consiste Fazenda de para locais
    Result := ConsistirFazenda(Arquivo.ValorColuna[loSglFazenda],Arquivo.ValorColuna[loNumCNPJCpfProdutor],
      CodFazenda);
    if Result < 0 then Exit;

    Result := IntLocais.InserirDadoGeral(Arquivo.ValorColuna[loNumCNPJCpfProdutor],
    Arquivo.ValorColuna[loCodNaturezaProdutor], CodFazenda, Arquivo.ValorColuna[loSglLocal],
    Arquivo.ValorColuna[loDesLocal], Arquivo.ValorColuna[loCodTipoFonteAgua],
    Arquivo.ValorColuna[loCodTipoRegimeAlimentar]);

  end;

  //Chama Cadastro de FAZENDAS
  function ProcessarFazendas: Integer;
  var CodFazendaCadastrada: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 10 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Fazendas']);
      Result := -1294;
      Exit;
    end;

   CodFazendaCadastrada := intFazendas.InserirDadoGeral(Arquivo.ValorColuna[faNumCNPJCpfProdutor],
   Arquivo.ValorColuna[faCodNaturezaProdutor],  Arquivo.ValorColuna[faSglFazenda],
   Arquivo.ValorColuna[faNomFazenda], Arquivo.ValorColuna[faCodEstado],  Arquivo.ValorColuna[faNumPropriedadeRural],
   Arquivo.ValorColuna[faNumImovelReceitaFederal], Arquivo.ValorColuna[faCodRegimePosseUso], Arquivo.ValorColuna[faTxtObservacao]);

   if CodFazendaCadastrada < 0 then begin
       Result := CodFazendaCadastrada;
       Exit;
    end;

   if UPPERCASE(Arquivo.ValorColuna[faEfetivacaoCadastro]) = 'S' then begin
      Result := IntFazendas.EfetivarCadastro(CodFazendaCadastrada,0,Arquivo.ValorColuna[faNumCNPJCpfProdutor]);
      If Result < 0 Then Begin
         Exit;
      End;
   end;

   //retorna o codigo da Fazenda Inserida
   Result := CodFazendaCadastrada;

  end;

  //Chama cadastro de PRODUTORES
  function ProcessarProdutores: Integer;
  var CodPessoaCadastrada: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 26 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Produtores']);
      Result := -1294;
      Exit;
    end;

    CodPessoaCadastrada := IntProdutores.Inserir(Arquivo.ValorColuna[proNomProdutor], Arquivo.ValorColuna[proNomReduzidoProdutor],
    Arquivo.ValorColuna[proCodNaturezaProdutor], Arquivo.ValorColuna[proNumCNPJCpfProdutor],
    Arquivo.ValorColuna[proDtaNascimento], Arquivo.ValorColuna[proTxtObservacao],
    4, Arquivo.ValorColuna[proSglProdutor], -1, '', '', '', -1, '', '', '', '', 0);

    if CodPessoaCadastrada < 0 then begin
       Result := CodPessoaCadastrada;
       Exit;
    end;

    Result := IntProdutores.DefinirEndereco(CodPessoaCadastrada, Arquivo.ValorColuna[proCodTipoEndereco],
        Arquivo.ValorColuna[proNomLogradouro], Arquivo.ValorColuna[proNomBairro],
        Arquivo.ValorColuna[proNumCep], Arquivo.ValorColuna[proCodPais],
        Arquivo.ValorColuna[proCodEstado], Arquivo.ValorColuna[proCodMunicipio],
        Arquivo.ValorColuna[proCodDistrito]);
    If Result < 0 Then Begin
      Exit;
    End;

    if ((Arquivo.ValorColuna[proCodTipoContato1] <> -1) and (Arquivo.ValorColuna[proTxtContato1] <> '')) then begin
    Result := IntPessoasContatos.Inserir(CodPessoaCadastrada,
     Arquivo.ValorColuna[proCodTipoContato1], Arquivo.ValorColuna[proTxtContato1]);
     if Result < 0 then Exit;
    end;

    if ((Arquivo.ValorColuna[proCodTipoContato2] <> -1) and (Arquivo.ValorColuna[proTxtContato2] <> '')) then begin
    Result := IntPessoasContatos.Inserir(CodPessoaCadastrada,
     Arquivo.ValorColuna[proCodTipoContato2], Arquivo.ValorColuna[proTxtContato2]);
     if Result < 0 then Exit;
    end;


    if ((Arquivo.ValorColuna[proCodTipoContato3] <> -1) and (Arquivo.ValorColuna[proTxtContato3] <> '')) then begin
    Result := IntPessoasContatos.Inserir(CodPessoaCadastrada,
     Arquivo.ValorColuna[proCodTipoContato3], Arquivo.ValorColuna[proTxtContato3]);
     if Result < 0 then Exit;
    end;


    if ((Arquivo.ValorColuna[proCodTipoContato4] <> -1) and (Arquivo.ValorColuna[proTxtContato4] <> '')) then begin
    Result := IntPessoasContatos.Inserir(CodPessoaCadastrada,
     Arquivo.ValorColuna[proCodTipoContato4], Arquivo.ValorColuna[proTxtContato4]);
     if Result < 0 then Exit;
    end;

    if ((Arquivo.ValorColuna[proCodTipoContato5] <> -1) and (Arquivo.ValorColuna[proTxtContato5] <> '')) then begin
    Result := IntPessoasContatos.Inserir(CodPessoaCadastrada,
     Arquivo.ValorColuna[proCodTipoContato5], Arquivo.ValorColuna[proTxtContato5]);
     if Result < 0 then Exit;
    end;

    if UPPERCASE(Arquivo.ValorColuna[proEfetivacaoCadastro]) = 'S' then begin
       Result := IntProdutores.EfetivarCadastro(CodPessoaCadastrada);
       If Result < 0 Then Begin
        Exit;
       End;
    end;

    //retorna o codigo da pessoa produtor cadastrada
    Result := CodPessoaCadastrada;

  end;

  function ProcessarPropriedades: Integer;
  var CodPropriedadeRuralCadastrada: Integer;
  begin
    // Consiste Quantidade de colunas da linha
    if Arquivo.NumeroColunas <> 26 then begin
      Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['Propriedades']);
      Result := -1294;
      Exit;
    end;

    CodPropriedadeRuralCadastrada := IntPropriedades.Inserir(Arquivo.ValorColuna[priNomPropriedadeRural], Arquivo.ValorColuna[priNumImovelReceitaFederal],
    Arquivo.ValorColuna[priTipoInscricao], Arquivo.ValorColuna[priNumLatitude], Arquivo.ValorColuna[priNumLongitude],
    Arquivo.ValorColuna[priQtdArea], Arquivo.ValorColuna[priNomPessoaContato], Arquivo.ValorColuna[priNumTelefone],
    Arquivo.ValorColuna[priNumFax], Arquivo.ValorColuna[priDtaInicioCertificacao], Arquivo.ValorColuna[priTxtObservacao], '', '', 3);

    if CodPropriedadeRuralCadastrada < 0 then begin
       Result := CodPropriedadeRuralCadastrada;
       Exit;
    end;
    
    Result := IntPropriedades.DefinirEndereco(CodPropriedadeRuralCadastrada, Arquivo.ValorColuna[priNomLogradouro],
       Arquivo.ValorColuna[priNomBairro], Arquivo.ValorColuna[priNumCep], Arquivo.ValorColuna[priCodPais],
       Arquivo.ValorColuna[priCodEstado], Arquivo.ValorColuna[priCodMunicipio], Arquivo.ValorColuna[priCodDistrito]);
    If Result < 0 Then Begin
      Exit;
    End;

    Result := IntPropriedades.DefinirEnderecoCorrespondencia(CodPropriedadeRuralCadastrada,
    Arquivo.ValorColuna[priNumLogradouroCorrespondencia], Arquivo.ValorColuna[priNomBairroCorrespondencia],
    Arquivo.ValorColuna[priNumCepCorrespondencia], Arquivo.ValorColuna[priCodPaisCorrespondencia],
    Arquivo.ValorColuna[priCodEstadoCorrespondencia], Arquivo.ValorColuna[priCodMunicipioCorrespondencia],
        Arquivo.ValorColuna[priCodDistritoCorrespondencia]);
    If Result < 0 Then Begin
      Exit;
    End;

    if UPPERCASE(Arquivo.ValorColuna[priEfetivacaoCadastro]) = 'S' then begin
        Result := IntPropriedades.EfetivarCadastro(CodPropriedadeRuralCadastrada);
        If Result < 0 Then Begin
           Exit;
        End;
    end;

    //Retorna o codigo da propriedade rural cadastrada
    Result := CodPropriedadeRuralCadastrada;
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
      '  tab_qtd_tipo_reg_import_geral '+
      'where '+
      '  cod_arq_import_dado_geral = :cod_arquivo_importacao ';
    Q.ParamByName('cod_arquivo_importacao').AsInteger := CodArqImportDadoGeral;
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

{ Processamento principal
  Realiza chamada para processamentos secundários }
begin
  // Identifica o instante de inicio do processamento
  tTimeOut := Now;

  // Identifica o tempo máximo para processamento do método
  IdentificaTimeOut;

  // Define objetos a serem utilizados como não instanciados
  Q := nil;
  IntLocais := nil;
  IntFazendas := nil;
  IntProdutores := nil;
  IntPropriedades := nil;
  IntPessoasContatos := nil;
  IntProdutores := nil;
  Processamento := nil;
  Arquivo := nil;

  Try
    // Instancia objetos a serem utilizados
    Q := THerdomQuery.Create(Conexao, nil);
    IntLocais := TIntLocais.Create;
    IntFazendas := TIntFazendas.Create;
    IntPropriedades := TIntPropriedadesRurais.Create;
    IntProdutores := TIntPessoas.Create;
    IntPessoasContatos := TIntPessoasContatos.Create;
    Processamento := TProcessamento.Create;


//    IntAnimais := TIntAnimais.Create;

    Arquivo := TArquivoLeitura.Create;
    Try

      // Inicializa classe responsável por Locais
      ReturnValue := IntLocais.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        Exit;
      end;

      // Inicializa classe responsável por Fazendas
      ReturnValue := IntFazendas.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        Exit;
      end;

      // Inicializa classe responsável por Produtores
      ReturnValue := IntProdutores.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        Exit;
      end;

      // Inicializa classe responsável por Propriedades Rurais
      ReturnValue := IntPropriedades.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        Exit;
      end;

       // Inicializa classe responsável por Propriedades Rurais
      ReturnValue := IntPessoasContatos.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        Exit;
      end;


      // Consiste registro na base do arquivo informado
      ReturnValue := VerificarRegistro;
      if ReturnValue < 0 then begin
        // Terminate; 13/04/2004
        Exit;
      end;

      // Verifica se o arquivo ainda está disponível para processamento
      ReturnValue := VerificarStatus;
      if ReturnValue < 0 then
      begin
        // Terminate; 13/04/2004
        Exit;
      end;

      // Verifica se o arquivo existe fisicamente em disco
      ReturnValue := VerificarArquivo;
      if ReturnValue < 0 then
      begin
        // Terminate; 13/04/2004
        Exit;
      end;

      // Obtem a data corrente do sistema (data + hora de processamento)
      DtaProcessamento := Conexao.DtaSistema;

      {Identifica arquivo de importacao}
      Arquivo.NomeArquivo := NomArqImportDadoGeral;

      {Guarda resultado da tentativa de abertura do arquivo}
      ReturnValue := Arquivo.Inicializar;

      {Trata possíveis erros durante a tentativa de abertura do arquivo}
      if ReturnValue = EArquivoInexistente then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1219;
        // Terminate; 13/04/2004
        Exit;
      end else if ReturnValue = EInicializarLeitura then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1219;
        // Terminate; 13/04/2004
        Exit;
      end else if ReturnValue < 0 then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
        ReturnValue := -1220;
        // Terminate; 13/04/2004
        Exit;
      end;

      {Verifica se os dados do arquivo pertencem a certificadora}
      ReturnValue := ValidarCertificadora(Arquivo.NumCNPJCertificadora, Self);
      if ReturnValue <= 0 then
      begin
        if ReturnValue = 0 then
        begin
          Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
          ReturnValue := -1223;
        end;
        // Terminate; 13/04/2004
        Exit;
      end;

      // Limpa lista de mensagens geradas pelo sistema
      Mensagens.Clear;

      // Classe que auxilia na totalização de valores do processamento
      ReturnValue := Processamento.Inicializar(Conexao, Mensagens);
      if ReturnValue < 0 then
      begin
        CancelarProcessamento;
        // Terminate; 13/04/2004
        Exit;
      end;

      Processamento.CodPessoa := Conexao.CodUsuario;
      Processamento.CodArqImportDadoGeral := CodArqImportDadoGeral;


      // Abre transação
      Conexao.BeginTran;

      // Incrementa o contador de vezes que o arquivo foi processado
      IncrementarQtdVezesProcessamento;
      AtualizaSituacaoArqImport('P');

      if LinhaInicial = 0 then
      begin
        // Limpa as ocorrências obtidas no último processamento
        LimparOcorrenciaProcessamento;
      end
      else
      begin
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
      //bIniciouComposicaoRacial := False;

      // Percorre o arquivo processando somente as linha ainda não processadas
      while (ReturnValue >= 0) and (Arquivo.EOF = False) and (bTimeOut = False) and not(Terminated) do
      begin
        // Incrementa indicador de progresso e registra se necessário
        Inc(iProgressoAux);
        if (iProgressoAux >= iProgressoIncremento) then
        begin
          IncrementarProgresso;
          iProgressoAux := 0;
        end;

        ReturnValue := Arquivo.ObterLinha; // Obtem linha do arquivo de importação
        if ReturnValue < 0 then begin
          if ReturnValue = ETipoColunaDesconhecido then
          begin
            ReturnValue := -1234;
          end
          else
          if ReturnValue = ECampoNumericoInvalido then
          begin
            ReturnValue := -1235;
          end
          else
          if ReturnValue = EDelimitadorStringInvalido then
          begin
            ReturnValue := -1236;
          end
          else
          if ReturnValue = EDelimitadorOutroCampoInvalido then
          begin
            ReturnValue := -1237;
          end
          else
          if ReturnValue = EOutroCampoInvalido then
          begin
            ReturnValue := -1238;
          end
          else
          if ReturnValue = EDefinirTipoLinha then
          begin
            ReturnValue := -1239;
          end
          else
          if ReturnValue = EAdicionarColunaLeitura then
          begin
            ReturnValue := -1240;
          end
          else
          if ReturnValue = EFinalDeLinhaInesperado then
          begin
            ReturnValue := -1243;
          end
          else
          begin
            ReturnValue := -1232;
          end;
          AtualizaSituacaoArqImport('P');
          Mensagens.Adicionar(-ReturnValue, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);

          try
            Conexao.Begintran;
            ReturnValue := GravarOcorrenciaProcessamento;
            Conexao.Commit;
          except
            Conexao.Rollback;
          end;

          if ReturnValue < 0 then
          begin
            CancelarProcessamento;
            Exit;
          end
          else
          begin
            Continue;
          end;
        end;

        // Verifica se a linha atual deve ser processada
        ReturnValue := ProcessarLinha(Arquivo.LinhasLidas);
        if ReturnValue < 0 then
        begin
          CancelarProcessamento;
          Exit;
        end;

        if ReturnValue = 1 then
        begin
        
          // A linha atual deve ser processada!
          // Abre transação
          Conexao.BeginTran;

          // Solicita ao sistema que nenhuma transação, a partir deste momento,
          // seja iniciada (begin tran), confirmada (commit) ou desfeita (rollback),
          // desabilitando o controle sobre transações
          Conexao.IgnorarNovasTransacoes := True;
          Try
            // Identifica o tipo da linha e realiza o processamento adequado
            case (Arquivo.TipoLinha) of
              8: { Locais }
                ReturnValue := ProcessarLocais;
              9: { Fazendas }
                ReturnValue := ProcessarFazendas;
              10: { Produtores }
                ReturnValue := ProcessarProdutores;
              11: { PropriedadesRurais }
                ReturnValue := ProcessarPropriedades;
            else
              Mensagens.Adicionar(1290, Self.ClassName, NomeMetodo, []);
              ReturnValue := -1290;
            end;
          Finally
            Conexao.IgnorarNovasTransacoes := False;
          end;

          if ReturnValue < 0 then
          begin
            Conexao.Rollback;
            Conexao.BeginTran;
            ReturnValue := GravarOcorrenciaProcessamento;
            Conexao.Commit;
            Continue;
          end;

          // Identifica e guarda erro ocorrido
          ReturnValue := TratarResultadoProcessamento(ReturnValue);

          // Verifica se um erro fatal foi identificado
          if ReturnValue < 0 then
          begin
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
      if Arquivo.EOF and (iProgresso <> 100) then
      begin
        iProgresso := 99;
        IncrementarProgresso;
        AtualizaSituacaoArqImport('C');
      end;

      // Identifica a quantidade real de linhas percorridas durante a execução do método
      iLinhasPercorridas := Arquivo.LinhasLidas;

      // Finaliza arquivo lido
      Arquivo.Finalizar;

      // Retorna status "ok" do método
      ReturnValue := iLinhasPercorridas;
    Except
      On E: Exception do
      Begin
        // Reabilita ao sistema o controle sobre transações
        Conexao.IgnorarNovasTransacoes := False;
        Conexao.Rollback;
        Mensagens.Adicionar(1284, Self.ClassName, NomeMetodo, [E.Message]);
        ReturnValue := -1284;
        // Terminate; 13/04/2004
        Exit;
      End;
    End;
  Finally
    Conexao.IgnorarNovasTransacoes := False;

    if Assigned(Processamento) then Processamento.Free;
    if Assigned(IntProdutores) then IntProdutores.Free;
    if Assigned(IntPessoasContatos) then IntPessoasContatos.Free;
    if Assigned(IntPropriedades) then IntPropriedades.Free;
    if Assigned(IntFazendas) then IntFazendas.Free;
    if Assigned(IntLocais) then IntLocais.Free;
    if Assigned(Arquivo) then Arquivo.Free;
    if Assigned(Q) then Q.Free;
  End;
end;

function TThrProcessarArquivo.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

{ TProcessamento }

constructor TProcessamento.Create;
begin
  inherited;
  FTipoArmazenamento := taImportacao;
end;

function TProcessamento.IncErradas(
  CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncErradas';
var
  iAux: Integer;
begin
  if FCodArqImportDadoGeral = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  Try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text :=
        'select '+
        '  qtd_erradas as QtdErradas '+
        'from '+
        '  tab_qtd_tipo_reg_import_geral '+
        'where '+
        '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';

    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdErradas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text :=
        'update '+
        '  tab_qtd_tipo_reg_import_geral '+
        'set '+
        '  qtd_erradas = :qtd_erradas '+
        'where '+
        '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_erradas').AsInteger := iAux;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1346, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1346;
      Exit;
    End;
  End;
end;


function TProcessamento.IncLidas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncLidas';
var
  iAux: Integer;
begin
  if FCodArqImportDadoGeral = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  Try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text :=
        'select '+
        '  qtd_total as QtdTotal '+
        'from '+
        '  tab_qtd_tipo_reg_import_geral '+
        'where '+
        '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';

    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdTotal').AsInteger;

    if Query.IsEmpty then begin
      // É a primeira linha deste tipo
      Query.Close;
      Query.SQL.Text :=
          'insert into tab_qtd_tipo_reg_import_geral '+
          ' (cod_arq_import_dado_geral, '+
          '  cod_tipo_reg_import_geral, '+
          '  qtd_total, '+
          '  qtd_processadas) '+
          'values '+
          ' (:cod_arquivo_importacao, '+
          '  :cod_tipo_linha_importacao, '+
          '  :qtd_total, '+
          '  0) ';
    end else begin
      // Incrementa o totalizador atual
      Query.Close;
      Query.SQL.Text :=
          'update '+
          '  tab_qtd_tipo_reg_import_geral '+
          'set '+
          '  qtd_total = :qtd_total '+
          'where '+
          '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
          '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';
    end;

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_total').AsInteger := iAux;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1226, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1226;
      Exit;
    End;
  End;
end;


function TProcessamento.IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomeMetodo: String = 'IncProcessadas';
var
  iAux: Integer;
begin
  if FCodArqImportDadoGeral = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  Try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text :=
        'select '+
        '  qtd_processadas as QtdProcessadas '+
        'from '+
        '  tab_qtd_tipo_reg_import_geral '+
        'where '+
        '  cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';

    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdProcessadas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text :=
        'update '+
        '  tab_qtd_tipo_reg_import_geral '+
        'set '+
        '  qtd_processadas = :qtd_processadas '+
        'where '+
        ' cod_arq_import_dado_geral = :cod_arquivo_importacao '+
        '  and cod_tipo_reg_import_geral = :cod_tipo_linha_importacao ';

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_processadas').AsInteger := iAux;
    Query.ParamByName('cod_arquivo_importacao').AsInteger := FCodArqImportDadoGeral;
    Query.ParamByName('cod_tipo_linha_importacao').AsInteger := CodTipoLinhaImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1227, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1227;
      Exit;
    End;
  End;
end;


end.




















