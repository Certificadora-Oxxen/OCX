unit uIntImportacoesSISBOV;

{$DEFINE MSSQL}

interface

uses Classes, DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas,
     uFerramentas, uArquivo, uIntImportacaoSISBOV, uConexao, uIntMensagens,
     uLibZipM, uIntCodigosSISBOV, uIntRelatorios;

type
  //Declaração dos tipos de dados utilizados!
  TTipo = record
    CodTipoLinha: Integer;
    QtdLidas: Integer;
    QtdErradas: Integer;
    QtdProcessadas: Integer;
  end;

  //Declaração das classes

  { TThrProcessarArquivoSISBOV }
  TThrProcessarArquivoSISBOV = class(TThread)
  private
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FCodArquivoImportacao: Integer;
    FLinhaInicial: Integer;
    FTempoMaximo: Integer;
    FCodTarefa: Integer;
    function GetRetorno: Integer;
  protected
    procedure Execute; override;
  public
    constructor CreateTarefa(CodTarefa: Integer; Conexao: TConexao;
      Mensagens: TIntMensagens; CodArquivoImportacao: Integer);
    property CodTarefa: Integer read FCodTarefa;
    property Retorno: Integer read GetRetorno;
    property Conexao: TConexao read FConexao;
    property Mensagens: TIntMensagens read FMensagens;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao;
    property LinhaInicial: Integer read FLinhaInicial;
    property TempoMaximo: Integer read FTempoMaximo;
  end;

  { TIntImportacoes }
  TIntImportacoesSISBOV = class(TIntClasseBDNavegacaoBasica)
  private
    FIntImportacaoSISBOV: TIntImportacaoSISBOV;
    FIntCodigosSISBOV:    TIntCodigosSisbov;
    FThread: TThrProcessarArquivoSISBOV;

    function ObterCodArquivoImportacao(var CodArquivoImportacao: Integer): Integer;
    function PesquisarRelatorioAutenticacao(NumCNPJCPFProdutor,
      NomPessoaProdutor, SglProdutor, NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer;
      NomPropriedadeRural: String; CodEstado: Integer; NomArqUpload: String;
      DtaImportacaoInicio, DtaImportacaoFim: TDateTime; CodPaisSISBOV,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV: Integer): Integer;
    procedure PrepararLinha(Relatorio: TRelatorioPadrao);
  public
    constructor Create; override;
    destructor Destroy; override;

    function ArmazenarArquivoUpLoad(NomArquivoUpload: String;
      TipoArquivoImportacao, CodOrigemArquivoUsuario: Integer): Integer;
    function Buscar(CodArquivoImportacao: Integer): Integer;
    function InserirArquivo(CodArquivoImportacao: Integer; NomArquivoImportacao,
      NomArquivoUpload: String; TipoArquivoImportacao: Integer;
      Txt_Dados: String; CodOrigem: Integer; SituacaoArqImport: Char): Integer;
    function Pesquisar(DtaImportacaoInicio, DtaImportacaoFim,
      DtaUltimoProcessamentoInicio, DtaUltimoProcessamentoFim: TDateTime;
      LoginUsuario, IndErrosNoProcessamento, IndArquivoProcessado: String;
      CodTipoArquivoImportacao, NumSolicitacao: Integer; NomeProdutor,
      CNPJ_CPF, NomePropriedade, NIRF: String; CodLocalizacaoSisbov: Integer): Integer;
    function Excluir(CodArquivoImportacao: Integer): Integer;
    function ProcessarInt(CodArquivoImportacao: Integer): Integer;
    function Processar(CodArquivoImportacao: Integer): Integer;
    function PesquisarOcorrencias(CodArquivoImportacao, CodTipoLinhaImportacao,
      CodTipoMensagem: Integer): Integer;
    function PesquisarTipo: Integer;
    procedure ObtemCodigoSISBOV(StrCodigo: String; var CodPaisSISBOV,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV,
      NumDVSisbov: Integer);
    procedure InsereAutenticacao(CodArqImportSISBOV, CodPaisSISBOV,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
      CodAnimalSISBOVFim, CodPessoaProdutor, CodPropriedadeRural: Integer);
    function GerarRelatorioAutenticacao(NumCNPJCPFProdutor, NomPessoaProdutor,
      SglProdutor, NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NomPropriedadeRural: String;
      CodEstado: Integer; NomArqUpload: String; DtaImportacaoInicio,
      DtaImportacaoFim: TDateTime; CodPaisSISBOV, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSISBOV, Tipo: Integer): String;

    property IntImportacao: TIntImportacaoSISBOV read FIntImportacaoSISBOV write FIntImportacaoSISBOV;
    property Thread: TThrProcessarArquivoSISBOV read FThread write FThread;
  end;

  { TArmazenamento }
  TArmazenamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipos: Array of TTipo;
    FCodPessoaProdutor: Integer;
    FCodArquivoImportacao: Integer;
    function GetQtdLinhasLidas(TipoLinhaImportacao: Integer): Integer;
  public
    constructor Create; override;
    procedure IncLidas(CodTipoLinhaImportacao: Integer);
    function Salvar: Integer;

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
    property QtdLinhasLidas[TipoLinhaImportacao: Integer]: Integer read GetQtdLinhasLidas;
  end;

  { TProcessamento }
  TProcessamento = class(TIntClasseBDNavegacaoBasica)
  private
    FCodPessoaProdutor: Integer;
    FCodArquivoImportacao: Integer;
  public
    constructor Create; override;
    function IncLidas(CodTipoLinhaImportacao: Integer): Integer;
    function IncErradas(CodTipoLinhaImportacao: Integer): Integer; overload;
    function IncErradas(CodTipoLinhaImportacao, Qtd: Integer): Integer; overload;
    function IncProcessadas(CodTipoLinhaImportacao: Integer): Integer; overload;
    function IncProcessadas(CodTipoLinhaImportacao, Qtd: Integer): Integer; overload;

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
  end;

  {  Funções Gerais às classes criadas!  }
  procedure InterpretaLinhaArquivoAutenticacao(Owner: TArquivoPosicionalLeitura);
  procedure InterpretaLinhaArquivoImpCodSISBOV(Owner: TArquivoPosicionalLeitura);
  function ValidarCertificadora(NumCNPJ: String; AOwner: TObject): Integer;
  function ValidarProdutor(Natureza, NumCNPJCPF: String; var CodPessoaProdutor: Integer; AOwner: TObject): Integer;
  function ValidarNirf(NumNIRF: String; CodLocalizacaoSisbov: Integer; AOwner: TObject): Integer;
  function ValidarCNPJCPFProdutor(numCNPJCPF: String; AOwner: TObject): Integer;
  function ValidarCodLocalizacao(numNIRF, numCNPJCPF: String; codLocalizacao: Integer; AOwner: TObject): Integer;
  function ValidaCNPJ(CNPJ: String): String;


implementation

uses ComServ, SqlExpr;

{ TIntImportacoes }

constructor TIntImportacoesSISBOV.Create;
begin
  inherited;
  FIntImportacaoSISBOV := TIntImportacaoSISBOV.Create;
end;

destructor TIntImportacoesSISBOV.Destroy;
begin
  FIntImportacaoSISBOV.Free;
  inherited;
end;

function TIntImportacoesSISBOV.ObterCodArquivoImportacao(var CodArquivoImportacao: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArquivoImportacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Abre transação
      BeginTran('PEGA_SEQ_CODIGO');

      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arq_import_sisbov), 0) + 1 as CodArqImportacao from tab_seq_arq_import_sisbov');
      {$ENDIF}
      Q.Open;

      CodArquivoImportacao := Q.FieldByName('CodArqImportacao').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arq_import_sisbov set cod_seq_arq_import_sisbov  = cod_seq_arq_import_sisbov + 1');
      {$ENDIF}
      Q.ExecSQL;

      Q.Close;

      // Fecha a transação
      Commit('PEGA_SEQ_CODIGO');

      // Identifica procedimento como bem sucedido
      Result := CodArquivoImportacao;
    except
      on E: Exception do begin
        Rollback('PEGA_SEQ_CODIGO');
        Mensagens.Adicionar(1229, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1229;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntImportacoesSISBOV.ArmazenarArquivoUpLoad(NomArquivoUpload: String; TipoArquivoImportacao, CodOrigemArquivoUsuario: Integer): Integer;
const
  Metodo: Integer = 486;
  NomeMetodo: String = 'ArmazenarArquivoUpLoad';
  iCNPJ: Integer = 3;
  iCNPJCertificadora: Integer = 2;
  iaCNPJCertificadora: Integer = 4;
  iTipo1: Integer = 1;
  iQtdTipo1: Integer = 2;
  iTipo2: Integer = 3;
  iQtdTipo2: Integer = 4;
  iNIRF: Integer = 7;
  iCNPJCPFProdutor: Integer = 12;
  iCODLocalizacao: Integer = 8;
  iNumCodigos: Integer = 9;
  iNumSolicitacao: Integer = 2;
  aaCodSisbov: Integer = 2;
  iTipoLinha: Integer = 1;
  iaTipoLinha: Integer = 1;
var
  Q: THerdomQuery;
  ArquivoUpload: TArquivoPosicionalLeitura;
  ArquivoImportacao: TArquivoPosicionalEscrita;
  Armazenamento: TArmazenamento;
  ArquivoZip: unzFile;
  bConfirmacaoLeitura: Boolean;
  sOrigem, sDestino, sAux, Txt_Dados, MsgErro, sRetornoErro,
  PrefixoNomeArquivo, sNomArquivoUploadOriginal: String;
  NumSolicitacao, iAux, CodArquivoImportacao, NCodigos, CodPessoa, CodPropriedade: Integer;
  CodAnimal, CodAnimalAnterior: Integer;
  SitArqImport: Char;
  TiposLinhasValidas: array of String;

  function ObterDadosTxtDados(Nirf, CNPJ_CPF: String; CodLocalizacaoSisbov:Integer; AOwner: TObject): String;
   begin
       Q.Close;
       Q.SQL.Text := ' Select ' +
                   '    cod_pessoa as CodPessoa ' +
                   '  , nom_pessoa as NomeProdutor ' +
                   '  , num_cnpj_cpf as CNPJ_CPF ' +
                   ' from ' +
                   '   tab_pessoa tp '  +
                   ' , tab_produtor tpr ' +
                   ' where ' +
                   '     tp.cod_pessoa = tpr.cod_pessoa_produtor ' +
                   ' and tp.num_cnpj_cpf = :num_cnpj_cpf ' +
                   ' and tp.dta_fim_validade is null ' +
                   ' and tpr.dta_fim_validade is null ';
       Q.ParamByName('num_cnpj_cpf').AsString := CNPJ_CPF;
       Q.Open;

       CodPessoa := Q.fieldbyName('CodPessoa').AsInteger;
       Result := 'Nome Produtor:  ' + Q.fieldbyName('NomeProdutor').AsString + '   ' +
                 'CNPJ/CPF:  '    + Q.fieldbyName('CNPJ_CPF').AsString     + '#';

       Q.Close;
       Q.SQL.Text := ' Select ' +
                   '    tpr.cod_propriedade_rural as CodPropriedade ' +
                   '  , tpr.nom_propriedade_rural as NomePropriedade ' +
                   '  , tpr.num_imovel_receita_federal as NIRF ' +
                   ' from tab_propriedade_rural tpr,' +
                   '      tab_localizacao_sisbov tls' +
                   ' where tpr.num_imovel_receita_federal = :num_imovel_receita_federal ' +
                   '   and tpr.cod_propriedade_rural = tls.cod_propriedade_rural ' +
                   '   and tls.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                   '   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov ';
       Q.ParamByName('num_imovel_receita_federal').AsString := NIRF;
       Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
       Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoa;
       Q.Open;

       CodPropriedade := Q.fieldbyName('CodPropriedade').AsInteger;
       Result := Result +
                'Nome Propriedade:  ' + Q.fieldbyName('NomePropriedade').AsString + '   ' +
                'NIRF:  '    + Q.fieldbyName('NIRF').AsString;
  end;

  function InsereSolicitacao(CodArqImportSisBov, CodPessoa, CodPropriedade, NumSolicitacao: Integer): Integer;
   begin
      try
         Q.Close;
         Q.SQL.Text := 'Insert into tab_arq_import_solicitacao ' +
                   ' ( cod_arq_import_sisbov ' +
                   ' , cod_pessoa_produtor ' +
                   ' , cod_propriedade_rural ' +
                   ' , num_solicitacao ) ' +
                   ' values ' +
                   ' ( :cod_arq_import_sisbov ' +
                   ' , :cod_pessoa_produtor ' +
                   ' , :cod_propriedade_rural ' +
                   ' , :num_solicitacao ) ';
         Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArqImportSisBov;
         Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoa;
         Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;
         Q.ParamByName('num_solicitacao').AsInteger := NumSolicitacao;
         Q.ExecSQL;
         Result := 0;
      except
         Result := -1;
      end;
   end;

   function VerificaDigitoVerificador(NumDvSisBov, CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov: Integer): Integer;
   begin
      if NumDvSisbov <> BuscarDVSisBov(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov) then
       begin
          Mensagens.Adicionar(526, Self.ClassName, NomeMetodo, []);
          Result := -526;
          Exit;
       end;
      Result := 1;
   end;

   function VerificaSequencia(CodAnimal: Integer): Integer;
   begin
      if (CodAnimal <> (CodAnimalAnterior + 1)) and (CodAnimalAnterior <> 0)then
      begin
        Result := -1;
      end
      else
        Result := 1;
   end;

  function  VerificaTipoLinha(TipoLinha: String): Integer;
  var
    Cont: Integer;
  begin
    // Se a variavel que contem os tipos de linha válidos para o arquivo
    // não foi inicializada então a inicializa
    if Length(TiposLinhasValidas) = 0 then
    begin
      with Q do
      begin
        Close;
        SQL.Clear;

        SQL.Add('select cod_tipo_reg_import_sisbov');
        SQL.Add('  from tab_tipo_arq_reg_import_sisbov');
        SQL.Add(' where cod_tipo_arq_import_sisbov = :cod_tipo_arq_import_sisbov');
        ParamByName('cod_tipo_arq_import_sisbov').AsInteger := TipoArquivoImportacao;
        Open;

        Cont := 0;
        // Define os tipos de linha válidos no vetor
        while not Eof do
        begin
          SetLength(TiposLinhasValidas, Cont + 1);
          TiposLinhasValidas[Cont] := FieldByName('cod_tipo_reg_import_sisbov').AsString;
          Inc(Cont);
          Next;
        end;
      end;
    end;

    // Busca pelo tipo de linha informado
    Result := -1;
    Cont := 0;
    while (Cont < Length(TiposLinhasValidas)) and (Result = -1) do
    begin
      if TiposLinhasValidas[Cont] = TipoLinha then
        Result := 0;
      Inc(Cont);
    end;
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

  // Limpa a variavel com os tipos de linhas válidos do arquivo
  SetLength(TiposLinhasValidas, 0);

  // Armazena o nome original do arquivo de upload
  sNomArquivoUploadOriginal := NomArquivoUpload;

  // Recupera pasta temporária de armazenamento
  if CodOrigemArquivoUsuario = 2 then begin
    sOrigem := ValorParametro(72);
  end else begin
    sOrigem := ValorParametro(21);
  end;

  if (Length(sOrigem) = 0) or (sOrigem[Length(sOrigem)] <> '\') then begin
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

  if CodOrigemArquivoUsuario = 2 then begin
    // Recupera a pasta adequada dos arquivos que se encontram com erro, caso a origem seja do FTP
    sRetornoErro := ValorParametro(73);
    if (Length(sRetornoErro)=0) or (sRetornoErro[Length(sRetornoErro)]<>'\') then begin
      sRetornoErro := sRetornoErro + '\';
    end;

    // Consiste existência da pasta, caso não exista tenta criá-la
    if not DirectoryExists(sRetornoErro) then begin
      if not ForceDirectories(sRetornoErro) then begin
        // Remove o arquivo temporário de imagem da pasta temporária
        //if CodOrigemArquivoUsuario = 1 then
          //DeleteFile(sOrigem);
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
      //if CodOrigemArquivoUsuario <> 2 then
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1360;
      Exit;
    end;

    // Consiste o número de arquivo dentro do Arquivo ZIP
    Result := NumArquivosDoUnZip(ArquivoZip);
    if Result < 0 then begin
      Mensagens.Adicionar(1361, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      //if CodOrigemArquivoUsuario <> 2 then
      DeleteFile(sOrigem+NomArquivoUpload);
      Result := -1361;
      Exit;
    end else if Result > 1 then begin
      Mensagens.Adicionar(1362, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      //if CodOrigemArquivoUsuario <> 2 then
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
      //if CodOrigemArquivoUsuario <> 2 then
      DeleteFile(sOrigem + NomArquivoUpload);
      if (Result = -5) or (Result = -6) then begin
        //if CodOrigemArquivoUsuario <> 2 then
        DeleteFile(sOrigem+sAux);
      end;
      Result := -1361;
      Exit;
    end;

    // Fechar arquivo ZIP
    FecharUnZip(ArquivoZip);

    // Apaga arquivo compactado
    //if CodOrigemArquivoUsuario <> 2 then
    DeleteFile(sOrigem+NomArquivoUpload);
    NomArquivoUpload := ExtractFileName(sAux);
  end;

  // Define caminho e arquivo completo da origem
  sOrigem := sOrigem + NomArquivoUpload;

  sDestino := ValorParametro(38);
  if (Length(sDestino)=0) or (sDestino[Length(sDestino)]<>'\') then begin
    sDestino := sDestino + '\';
  end;
  // Recupera pasta adequada dos arquivos
  if TipoArquivoImportacao = 1 then
  begin
    PrefixoNomeArquivo := 'DIA';
  end;

  if TipoArquivoImportacao = 2 then
  begin
    PrefixoNomeArquivo := 'SOL';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then begin
    if not ForceDirectories(sDestino) then begin
      // Remove o arquivo temporário de imagem da pasta temporária
      //if CodOrigemArquivoUsuario <> 2 then
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
        {Obtem código um código para o arquivo}
        Result := ObterCodArquivoImportacao(CodArquivoImportacao);
        if Result < 0 then Exit;
        try
          {Identifica arquivo de upload}
          ArquivoUpload.NomeArquivo := sOrigem;

          {Guarda resultado da tentativa de abertura do arquivo}
          if TipoArquivoImportacao = 1 then
            ArquivoUpload.RotinaLeitura := InterpretaLinhaArquivoAutenticacao;
          if TipoArquivoImportacao = 2 then
            ArquivoUpload.RotinaLeitura := InterpretaLinhaArquivoImpCodSISBOV;

          Result := ArquivoUpload.Inicializar;
          if Result < 0 then
          begin
            // Trata possíveis erros durante a tentativa de abertura do arquivo
            if Result = EArquivoInexistente then
            begin
              Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end
            else
            if Result = EInicializarLeitura then
            begin
              Mensagens.Adicionar(1219, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end
            else
            if Result < 0 then
            begin
              Mensagens.Adicionar(1220, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1220;
            end;
            // Caso o arquivo esteja inválido, um registro deve ser gerado na
            // base de dados informando o erro

            // Inicializa transação
            BeginTran;
            // Armazena arquivo
            Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');

            // Finaliza transação, garantindo atualizações realizadas
            if Result >= 0 then
              Commit;

            // Força um erro para que as devidas operações sejam realizadas
            Result := -1;
            Exit;
          end;

          // Validando o header do arquivo!
          // Obtem a primeira linha do arquivo (que identifica certificadora)

          // Registro Tipo 0;
          ArquivoUpload.ObterLinha;
          // Verifica se os dados do arquivo pertencem a certificadora
          if TipoArquivoImportacao = 2 then
          begin
            Result := ValidarCertificadora(
              ArquivoUpload.ValorColuna[iCNPJCertificadora], Self)
          end
          else
          begin
            Result := ValidarCertificadora(
              ArquivoUpload.ValorColuna[iaCNPJCertificadora], Self);
          end;

          if Result <= 0 then begin
            if Result = 0 then begin
              Mensagens.Adicionar(1223, Self.ClassName, NomeMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1223;
            end;

            // Caso o arquivo esteja inválido, um registro deve ser gerado
            // na base de dados informando o erro

            // Inicializa transação
            BeginTran;
            {Armazena arquivo}
            Result := InserirArquivo(CodArquivoImportacao, sAux,
              NomArquivoUpload, TipoArquivoImportacao, ' ',
              CodOrigemArquivoUsuario, 'I');
            // Finaliza transação, garantindo atualizações realizadas
            if Result >= 0 then
              Commit;
            // Força um erro para que as devidas operações sejam realizadas
            Result := -1223;
            Exit;
          end;

          NCodigos := 0;
          NumSolicitacao := 0;

          if TipoArquivoImportacao = 2 then
          begin
            ArquivoUpload.ObterLinha;

            NCodigos := ArquivoUpload.ValorColuna[iNumCodigos];
            NumSolicitacao := ArquivoUpload.ValorColuna[iNumSolicitacao];

            { Validar CNPJ/CPF do Produtor }
            Result := ValidarCNPJCPFProdutor(ArquivoUpload.ValorColuna[iCNPJCPFProdutor], Self);
            if Result <= 0 then
            begin
              if Result = -1656 then begin
                Mensagens.Adicionar(1656, Self.ClassName, NomeMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1656;
              end;
              if Result = -1655 then begin
                Mensagens.Adicionar(1655, Self.ClassName, NomeMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1655;
              end;
              if Result = 0 then begin
                Mensagens.Adicionar(1670, Self.ClassName, NomeMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1670;
              end;
              // Caso o arquivo esteja inválido, um registro deve ser gerado
              // na base de dados informando o erro}

              // Inicializa transação
              BeginTran;

              // Armazena arquivo
              Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
              // Finaliza transação, garantindo atualizações realizadas
              if Result >= 0 then
                Commit;
              // Força um erro para que as devidas operações sejam realizadas
              Result := -1;
              Exit;
            end;

            // Validar NIRF
            Result := ValidarNIRF(ArquivoUpload.ValorColuna[iNIRF], ArquivoUpload.ValorColuna[iCODLocalizacao], Self);
            if Result <= 0 then
            begin
              if Result = 0 then
              begin
                Mensagens.Adicionar(1654, Self.ClassName, NomeMetodo, []);
                Result := -1654;
              end;

              // Caso o arquivo esteja inválido, um registro deve ser gerado
              // na base de dados informando o erro

              // Inicializa transação
              BeginTran;

              // Armazena arquivo
              Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
              // Finaliza transação, garantindo atualizações realizadas
              if Result >= 0 then
                Commit;

              // Força um erro para que as devidas operações sejam realizadas
              Result := -1;
              Exit;
            end;

            // Validar Codigo da Propriedade
            Result := ValidarCodLocalizacao(ArquivoUpload.ValorColuna[iNIRF], ArquivoUpload.ValorColuna[iCNPJCPFProdutor], ArquivoUpload.ValorColuna[iCODLocalizacao], Self);
            if Result <= 0 then begin
              if Result = -1657 then begin
                Mensagens.Adicionar(1657, Self.ClassName, NomeMetodo, []);
                Result := -1657;
              end;
              if Result = 0 then begin
                Mensagens.Adicionar(1673, Self.ClassName, NomeMetodo, []);
                Result := -1673;
              end;

              // Caso o arquivo esteja inválido, um registro deve ser gerado
              // na base de dados informando o erro
              // Inicializa transação
              BeginTran;

              // Armazena arquivo
              Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
              // Finaliza transação, garantindo atualizações realizadas
              if Result >= 0 then
                Commit;

              // Força um erro para que as devidas operações sejam realizadas
              Result := -1;
              Exit;
            end;

            Txt_Dados := ObterDadosTxtDados(ArquivoUpload.ValorColuna[iNIRF], ArquivoUpload.ValorColuna[iCNPJCPFProdutor], ArquivoUpload.ValorColuna[iCODLocalizacao], Self);
          end;

          if Result < 0  then
            Exit;

          // Recomeça leitura a partir do ínicio do arquivo
          ArquivoUpload.ReInicializar;

          // Identifica arquivo a ser salvo em disco na pasta correta
          sAux := PrefixoNomeArquivo + StrZero(CodArquivoImportacao, 7) + '.txt';
          sDestino := sDestino + sAux;
          ArquivoImportacao.NomeArquivo := sDestino;
          if (ArquivoImportacao.Inicializar = 0) then
          begin
            // Inicia a verificação do arquivo e cria o arquivo a ser armazenado!
            Armazenamento := TArmazenamento.Create;
            try
              Result := Armazenamento.Inicializar(Conexao, Mensagens);
              if Result < 0 then
                Exit;
              ArquivoImportacao.NomeArquivo := sDestino;
              Armazenamento.CodArquivoImportacao := CodArquivoImportacao;
              ArquivoImportacao.TipoLinha := -1; // Desliga a identificação automática de linhas
              bConfirmacaoLeitura := False; // A última linha de confirmação do arquivo não foi encontrada ainda
              CodAnimalAnterior := 0;
              while (Result = 0) and not(ArquivoUpload.EOF) do
              begin
                Result := ArquivoUpload.ObterLinha; // Obtem linha do arquivo temporário
                if Result < 0 then
                begin
                  if Result = ETipoColunaDesconhecido then
                  begin

                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1234;
                  end
                  else if Result = ECampoNumericoInvalido then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1235;
                  end
                  else if Result = EDelimitadorStringInvalido then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1236;
                  end
                  else if Result = EDelimitadorOutroCampoInvalido then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1237;
                  end
                  else if Result = EOutroCampoInvalido then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1238;
                  end
                  else if Result = EDefinirTipoLinha then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1239;
                  end
                  else if Result = EAdicionarColunaLeitura then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1240;
                  end
                  else if Result = EFinalDeLinhaInesperado then
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1243;
                  end
                  else
                  begin
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                    Result := -1232;
                  end;

                  Mensagens.Adicionar(-Result, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas)]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  // Caso o arquivo esteja inválido, um registro deve ser
                  // gerado na base de dados informando o erro}

                  //Inicializa transação}
                  BeginTran;
                  // Armazena arquivo
                  Result := InserirArquivo(CodArquivoImportacao, sAux,
                    NomArquivoUpload, TipoArquivoImportacao, ' ',
                    CodOrigemArquivoUsuario, 'I');
                  // Finaliza transação, garantindo atualizações realizadas
                  if Result >= 0 then
                    Commit;
                  // Força um erro para que as devidas operações sejam realizadas}
                  Result := -1;
                  Exit;
                end;

                if TipoArquivoImportacao = 2 then
                  Result := VerificaTipoLinha(ArquivoUpload.ValorColuna[iTipoLinha])
                else
                  Result := VerificaTipoLinha(ArquivoUpload.ValorColuna[iaTipoLinha]);

                if Result < 0 then
                begin
                  Mensagens.Adicionar(1681, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                  Result := -1681;
                  Exit;
                end;

                if (ArquivoUpload.TipoLinha = 2) and (TipoArquivoImportacao = 2) then
                begin                
                  CodAnimal := StrToInt(Copy(ArquivoUpload.ValorColuna[aaCodSisBov], 06, 09));
                  if Length(ArquivoUpload.ValorColuna[aaCodSisBov]) <> 15 then
                  begin
                    Mensagens.Adicionar(1678, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                    // Caso o arquivo esteja inválido, um registro deve ser
                    // gerado na base de dados informando o erro

                    // Inicializa transação
                    BeginTran;

                    // Armazena arquivo
                    Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
                    // Finaliza transação, garantindo atualizações realizadas
                    if Result >= 0 then
                      Commit;
                    // Força um erro para que as devidas operações sejam realizadas}
                    Result := -1678;
                    Exit;
                  end;

                  Result := VerificaSequencia(CodAnimal);
                  CodAnimalAnterior := CodAnimal;
                  if Result < 0 then
                  begin
                    Mensagens.Adicionar(1676, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                    // Caso o arquivo esteja inválido, um registro deve ser
                    // gerado na base de dados informando o erro}

                    // Inicializa transação}
                    BeginTran;

                    // Armazena arquivo}
                    Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
                    // Finaliza transação, garantindo atualizações realizadas
                    if Result >= 0 then
                      Commit;

                    // Força um erro para que as devidas operações sejam realizadas}
                    Result := -1676;
                    Exit;
                  end;
                end;

                // Escreve linha no arquivo definitivo
                Result := ArquivoImportacao.AdicionarLinhaTexto(ArquivoUpload.LinhaTexto);
                if Result < 0 then
                begin
                  Mensagens.Adicionar(1233, Self.ClassName, NomeMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  // Caso o arquivo esteja inválido, um registro deve ser
                  // gerado na base de dados informando o erro

                  // Inicializa transação
                  BeginTran;

                  // Armazena arquivo
                  Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, ' ', CodOrigemArquivoUsuario, 'I');
                  // Finaliza transação, garantindo atualizações realizadas
                  if Result >= 0 then
                    Commit;
                  // Força um erro para que as devidas operações sejam realizadas
                  Result := -1233;
                  Exit;
                end;

                // Verifica se a linha é uma linha de importação
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

              if (not bConfirmacaoLeitura) and (TipoArquivoImportacao = 1) then
              begin
                Mensagens.Adicionar(1604, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1604;
                Exit;
              end;

              if (TipoArquivoImportacao = 2) and (Armazenamento.QtdLinhasLidas[2] <> NCodigos) then
              begin
                Mensagens.Adicionar(1604, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1604;
                Exit;
              end;

              if Armazenamento.QtdLinhasLidas[2] = 0 then
              begin
                Mensagens.Adicionar(1603, Self.ClassName, NomeMetodo, [NomArquivoUpload]);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1603;
                Exit;
              end;

              SitArqImport := 'N';
              BeginTran;
              Result := InserirArquivo(CodArquivoImportacao, sAux, NomArquivoUpload, TipoArquivoImportacao, Txt_Dados, CodOrigemArquivoUsuario, SitArqImport);
              if Result >= 0 then
              begin
                Result := Armazenamento.Salvar;
                if Result < 0 then
                begin
                  RollBack;
                  Exit;
                end;
              end
              else
              begin
                Rollback; {Desfaz atualizações realizadas na base}
                Mensagens.Adicionar(1228, Self.ClassName, NomeMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1228;
              end;
              Commit;
            finally
              Armazenamento.Free;
            end;

            BeginTran;
            // Atualiza a quantidade real de linhas do arquivo
            Q.Close;
            Q.SQL.Text :=
                       'update tab_arq_import_sisbov '+
                       'set '+
                       '  qtd_linhas = :qtd_linhas '+
                       'where '+
                       '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
            Q.ParamByName('qtd_linhas').AsInteger := ArquivoUpload.LinhasLidas;
            Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
            Q.ExecSQL;

            // Insere na tab_arq_import_solicitacao
            if TipoArquivoImportacao = 2 then
            begin
              Result := InsereSolicitacao(CodArquivoImportacao, CodPessoa, CodPropriedade, NumSolicitacao);
              if Result = -1 then
              begin
                Mensagens.Adicionar(1659, Self.ClassName, NomeMetodo, []);
                Result := -1659;
                Rollback;
                Exit;
              end
            end;

            // Finaliza arquivo de UpLoad
            ArquivoUpload.Finalizar;
            Commit;

            // Verifica a existência de um arquivo de upload como o mesmo nome,
            // havendo gera uma mensagem}
            Q.Close;
            Q.SQL.Text :=
                         'select '+
                         '  count(1) as QtdArquivo '+
                         'from '+
                         '  tab_arq_import_sisbov '+
                         'where '+
                         '  nom_arq_upload like :nom_arq_upload ';
            Q.ParamByName('nom_arq_upload').AsString := NomArquivoUpload;
            Q.Open;

            if Q.FieldByName('QtdArquivo').AsInteger > 1 then
            begin
              Mensagens.Adicionar(1267, Self.ClassName, NomeMetodo, []);
            end;
            Q.Close;

            if CodOrigemArquivoUsuario = 2 then begin
              // Remove arquivo da pasta de retorno via FTP, pois o procedimento
              // foi realizado com sucesso
              DeleteFile(sRetornoErro + sNomArquivoUploadOriginal);
            end;

            // Identifica procedimento como bem sucedido, retornado o código do
            // arquivo inserido
            Result := CodArquivoImportacao;
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
              'update tab_arq_import_sisbov '+
              'set '+
              '    cod_situacao_arq_import = :cod_situacao_arq_import '+
              '  , txt_mensagem = :txtMensagem ' +
              'where '+
              '    cod_arq_import_sisbov = :cod_arq_import_sisbov ';
            Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
            Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
            Q.ParamByName('txtMensagem').AsString := msgErro;
            Q.ExecSQL;
            {Finaliza transação, garantindo atualizações realizadas}
            Commit;
          except
             on E: Exception do
              begin
                 Rollback;
                 Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                 Result := -1218;
              end;
          end;

          if FileExists(sDestino) then
          begin
            {Tenta excluir o arquivo de importação gerado}
            if not DeleteFile(sDestino) then
            begin
              try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                             'update tab_arq_import_sisbov '+
                             'set '+
                             '  cod_situacao_arq_import = :cod_situacao_arq_import '+
                             '  txt_mensagem = txt_mensagem + :txtMensagem '+
                             'where '+
                             '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
                Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
                Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
                Q.ParamByName('txtMensagem').AsString := msgErro;
                Q.ExecSQL;
                {Finaliza transação, garantindo atualizações realizadas}
                Commit;
              except
                 on E: Exception do
                  begin
                     Rollback;
                     Mensagens.Adicionar(1218, Self.ClassName, NomeMetodo, [E.Message]);
                     Result := -1218;
                  end;
              end;
            end;
          end;

          if (FileExists(sOrigem) and (CodOrigemArquivoUsuario = 2)) then  begin // FTP
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
                  'update tab_arq_import_sisbov '+
                  'set '+
                  '  cod_situacao_arq_import = :cod_situacao_arq_import, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
                Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
                Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
                Q.ParamByName('txtMensagem').AsString := msgErro;
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
          end Else begin // Upload
            try
              if FileExists(sOrigem) then DeleteFile(sOrigem);
            except
              try
                BeginTran;
                Q.Close;
                Q.SQL.Text :=
                  'update tab_arq_import_sisbov '+
                  'set '+
                  '  cod_situacao_arq_import = :cod_situacao_arq_import, '+
                  '  txt_mensagem = txt_mensagem + :txtMensagem '+
                  'where '+
                  '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
                Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
                Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
                Q.ParamByName('txtMensagem').AsString := msgErro;
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
      // Limpa a variavel com os tipos de linhas válidos do arquivo
      SetLength(TiposLinhasValidas, 0);

      {Tenta excluir o arquivo origem}
      if ((Result >= 0) and (not DeleteFile(sOrigem))) then begin
        try
          BeginTran;
          Q.Close;
          Q.SQL.Text :=
            'update tab_arq_import_sisbov '+
            'set '+
            '  cod_situacao_arq_import = :cod_situacao_arq_import, '+
            '  txt_mensagem = txt_mensagem + :txtMensagem '+
            'where '+
            '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
          Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
          Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
          Q.ParamByName('txtMensagem').AsString := msgErro;
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


function TIntImportacoesSISBOV.Buscar(CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 490;
  NomeMetodo: String = 'Buscar';
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
        ' select '+
        '    taa.cod_arq_import_sisbov      as CodArquivoImportacao ' +
        '  , taa.nom_arq_upload             as NomArquivoUpload ' +
        '  , taa.nom_arq_import_sisbov      as NomArquivoImportacao ' +
        '  , taa.dta_importacao             as DtaImportacao ' +
        '  , tu.nom_usuario                 as LoginUsuarioUpload ' +
        '  , taa.qtd_vezes_processamento    as QtdVezesProcessamento ' +
        '  , taa.dta_ultimo_processamento   as DtaUltimoProcessamento ' +
        '  , taa.qtd_linhas                 as QtdLinhas ' +
        '  , taa.txt_dados                  as TxtDados ' +
        '  , taa.cod_tipo_origem_arq_import as CodTipoOrigemArqImport ' +
        '  , taa.cod_situacao_arq_import    as CodSituacaoArqImport ' +
        '  , taa.txt_mensagem               as TxtMensagem ' +
        '  , tto.des_tipo_origem_arq_import as DesTipoOrigemArqImport ' +
        '  , ts.des_situacao_arq_import     as DesSituacaoArqImport ' +
        ' from ' +
        '    tab_arq_import_sisbov taa ' +
        '  , tab_usuario tu ' +
        '  , tab_situacao_arq_import ts ' +
        '  , tab_tipo_origem_arq_import tto ' +
        ' where ' +
        '      tu.cod_usuario = taa.cod_usuario_upload ' +
        '  and taa.cod_arq_import_sisbov = :cod_arq_import_sisbov ' +
        '  and tto.cod_tipo_origem_arq_import = taa.cod_tipo_origem_arq_import ' +
        '  and ts.cod_situacao_arq_import = taa.cod_situacao_arq_import ';

      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;

      // Obtem informações do registro
      FIntImportacaoSISBOV.CodProdutor              := 0;
      FIntImportacaoSISBOV.CodPropriedade           := 0;
      FIntImportacaoSISBOV.CodArqImportSisBov       := Q.FieldByName('CodArquivoImportacao').AsInteger;
      FIntImportacaoSISBOV.NomArqImportSisBov       := Q.FieldByName('NomArquivoImportacao').AsString;
      FIntImportacaoSISBOV.NomUsuarioUpLoad         := Q.FieldByName('LoginUsuarioUpload').AsString;
      FIntImportacaoSISBOV.NomArqUpload             := Q.FieldByName('NomArquivoUpload').AsString;
      FIntImportacaoSISBOV.DtaArqImportSisBov       := Q.FieldByName('DtaImportacao').AsDateTime;
      FIntImportacaoSISBOV.QtdVezesProcessamento    := Q.FieldByName('QtdVezesProcessamento').AsInteger;
      FIntImportacaoSISBOV.DtaUltimoProcessamento   := Q.FieldByName('DtaUltimoProcessamento').AsDateTime;
      FIntImportacaoSISBOV.TxtDados                 := Q.FieldByName('TxtDados').AsString;
      FIntImportacaoSISBOV.QtdLinhas                := Q.FieldByName('QtdLinhas').AsInteger;
      FIntImportacaoSISBOV.CodTipoOrigemArqImport   := Q.FieldByName('CodTipoOrigemArqImport').AsInteger;
      FIntImportacaoSISBOV.CodSituacaoArqImport     := Q.FieldByName('CodSituacaoArqImport').AsString;
      FIntImportacaoSISBOV.TxtMensagem              := Q.FieldByName('TxtMensagem').AsString;
      FIntImportacaoSISBOV.DesTipoOrigemArqImport   := Q.FieldByName('DesTipoOrigemArqImport').AsString;
      FIntImportacaoSISBOV.DesSituacaoArqImport     := Q.FieldByName('DesSituacaoArqImport').AsString;

      FIntImportacaoSISBOV.QtdLinhasProcessadas     := 0;
      FIntImportacaoSISBOV.QtdLinhasErroUltimoProc  := 0;
      FIntImportacaoSISBOV.QtdLinhasLogUltimoProc   := 0;

      Q.Close;
      if FIntImportacaoSISBOV.QtdVezesProcessamento > 0 then begin
        {Otendo quantidade de linhas com erro}
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasComErro '+
          'from '+
          '  tab_ocorrencia_import_sisbov '+
          'where '+
          '  cod_arq_import_sisbov = :cod_arq_impor_sisbov '+
          '  and cod_tipo_mensagem = 2 ';
        Q.ParamByName('cod_arq_impor_sisbov').AsInteger := FIntImportacaoSISBOV.CodArqImportSisBov;
        Q.Open;
        FIntImportacaoSISBOV.QtdLinhasErroUltimoProc := Q.FieldByName('NumLinhasComErro').AsInteger;
        {Otendo quantidade de linhas total do log}
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasLog '+
          'from '+
          '  tab_ocorrencia_import_sisbov '+
          'where '+
          '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
        Q.ParamByName('cod_arq_import_sisbov').AsInteger := FIntImportacaoSISBOV.CodArqImportSisBov;
        Q.Open;
        FIntImportacaoSISBOV.QtdLinhasLogUltimoProc := Q.FieldByName('NumLinhasLog').AsInteger;
        Q.Close;
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

function TIntImportacoesSISBOV.Excluir(CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 491;
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

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try


     // Recupera a pasta onde os arquivos são armazenados

{     if TipoArquivoImportacao = 1 then
      begin}
     sArquivo := {Conexao.CaminhoArquivosCertificadora + } ValorParametro(38);
     if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
        sArquivo := sArquivo + '\';
     end;

{     if TipoArquivoImportacao = 2 then
      begin
         sArquivo := Conexao.CaminhoArquivosCertificadora + ValorParametro(68);
         if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
            sArquivo := sArquivo + '\';
         end;
      end;}

      // Consiste existência do registro
      Q.SQL.Text :=
        'select nom_arq_import_sisbov from tab_arq_import_sisbov '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1242, Self.ClassName, NomeMetodo, []);
        Result := -1242;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('nom_arq_import_sisbov').AsString;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Text :=
        'delete from tab_arq_import_autenticacao '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_ocorrencia_import_sisbov '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_qtd_reg_import_sisbov '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_linha_arq_import_sisbov '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_arq_import_solicitacao '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ExecSQL;

      Q.SQL.Text :=
        'delete from tab_arq_import_sisbov '+
        'where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
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

function TIntImportacoesSISBOV.Pesquisar(DtaImportacaoInicio,
  DtaImportacaoFim, DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime; LoginUsuario,
  IndErrosNoProcessamento, IndArquivoProcessado: String;
  CodTipoArquivoImportacao, NumSolicitacao: Integer;
  NomeProdutor, CNPJ_CPF, NomePropriedade, NIRF: String; CodLocalizacaoSisbov: Integer): Integer;
const
  Metodo: Integer = 489;
  NomeMetodo: String = 'Pesquisar';
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
    Query.SQL.Clear;
{$IFDEF MSSQL}
    // Montando query de pesquisa de acordo com os críterios informados
    AddSQL(Query, ' select');
    AddSQL(Query, '    taa.cod_arq_import_sisbov as CodArquivoImportacao');
    AddSQL(Query, '  , taa.nom_arq_import_sisbov as NomArquivoImportacao');
    AddSQL(Query, '  , taa.nom_arq_upload as NomArquivoUpload');
    AddSQL(Query, '  , tu.nom_usuario as LoginUsuarioUpload');
    AddSQL(Query, '  , taa.dta_importacao as DtaImportacao');
    AddSQL(Query, '  , taa.dta_ultimo_processamento as DtaUltimoProcessamento');
    AddSQL(Query, '  , taa.cod_tipo_arq_import_sisbov as TipoArquivo');
    AddSQL(Query, '  , taa.cod_situacao_arq_import as CodSituacaoArqImport');
    AddSQL(Query, '  , tto.sgl_tipo_origem_arq_import as SglTipoOrigemArqImport');
    AddSQL(Query, '  , case when tp.cod_arq_import_sisbov is null then');
    AddSQL(Query, '      0');
    AddSQL(Query, '    else');
    AddSQL(Query, '      count(1)');
    AddSQL(Query, '    end as NumLinhasComErro');
    AddSQL(Query, ' , tai.num_solicitacao as NumSolicitacao', (NumSolicitacao > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' , tpe.nom_pessoa as NomeProdutor', (Length(Trim(NomeProdutor)) > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' , tpe.num_cnpj_cpf as CNPJ_CPF', (Length(Trim(CNPJ_CPF)) > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' , tpp.nom_propriedade_rural as NomePropriedade', (Length(Trim(NomePropriedade)) > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' , tpp.num_imovel_receita_federal as NIRF', (Length(Trim(NIRF)) > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' , tls.cod_localizacao_sisbov as CodLocalizacaoSisbov ', (CodLocalizacaoSisbov > 0) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' from');
    AddSQL(Query, '    tab_arq_import_sisbov taa with (nolock)');
    AddSQL(Query, '  , tab_ocorrencia_import_sisbov tp with (nolock)');
    AddSQL(Query, '  , tab_usuario tu with (nolock)');
    AddSQL(Query, '  , tab_tipo_origem_arq_import tto with (nolock)');
    AddSQL(Query, '  , tab_arq_import_solicitacao tai with (nolock)');
    AddSQL(Query, '  , tab_pessoa tpe with (nolock)', ((Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0)) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, '  , tab_propriedade_rural tpp with (nolock)', ((Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, '  , tab_localizacao_sisbov tls with (nolock)', ((Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0) or (Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0) or (CodLocalizacaoSisbov > 0)) and (CodTipoArquivoImportacao = 2));
    AddSQL(Query, ' where');
    AddSQL(Query, '     tp.cod_tipo_mensagem <> 3');
    AddSQL(Query, ' and taa.cod_arq_import_sisbov *= tp.cod_arq_import_sisbov');
    AddSQL(Query, ' and taa.cod_arq_import_sisbov = tai.cod_arq_import_sisbov', (NumSolicitacao > 0) or (Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0) or (Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0));
    AddSQL(Query, ' and taa.cod_arq_import_sisbov *= tai.cod_arq_import_sisbov ', not ((NumSolicitacao > 0) or (Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0) or (Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)));
    AddSQL(Query, ' and tu.cod_usuario = taa.cod_usuario_upload');
    AddSQL(Query, ' and tto.cod_tipo_origem_arq_import = taa.cod_tipo_origem_arq_import');
    AddSQL(Query, ' and taa.cod_tipo_arq_import_sisbov = :cod_tipo_arq_import_sisbov', CodTipoArquivoImportacao > 0);
    AddSQL(Query, ' and taa.dta_importacao >= :dta_importacao_inicio', (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0));
    AddSQL(Query, ' and taa.dta_importacao < :dta_importacao_fim', (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0));
    AddSQL(Query, ' and taa.dta_ultimo_processamento >= :dta_ultimo_processamento_inicio', (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0));
    AddSQL(Query, ' and taa.dta_ultimo_processamento < :dta_ultimo_processamento_fim', (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0));
    AddSQL(Query, ' and tu.nom_usuario like :nom_usuario', LoginUsuario <> '');
    AddSQL(Query, ' and taa.qtd_vezes_processamento > 0', (IndArquivoProcessado = 'S') or (IndErrosNoProcessamento = 'S') or (IndErrosNoProcessamento = 'N'));
    AddSQL(Query, ' and taa.qtd_vezes_processamento = 0', (IndArquivoProcessado = 'N') and not ((IndErrosNoProcessamento = 'S') or (IndErrosNoProcessamento = 'N')));
    AddSQL(Query, ' and tpp.cod_propriedade_rural = tai.cod_propriedade_rural', (Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0));
    AddSQL(Query, ' and tai.num_solicitacao = :num_solicitacao ', (CodTipoArquivoImportacao = 2) and (NumSolicitacao > 0));
    AddSQL(Query, ' and tai.cod_pessoa_produtor = tpe.cod_pessoa', (CodTipoArquivoImportacao = 2) and ((Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0)));
    AddSQL(Query, ' and tpe.num_cnpj_cpf = :num_cnpj_cpf', (CodTipoArquivoImportacao = 2) and (Length(Trim(CNPJ_CPF)) > 0));
    AddSQL(Query, ' and tpe.cod_pessoa = tls.cod_pessoa_produtor', (CodTipoArquivoImportacao = 2) and (Length(Trim(CNPJ_CPF)) > 0));
    AddSQL(Query, ' and tpe.nom_pessoa like :nom_pessoa', (CodTipoArquivoImportacao = 2) and (Length(Trim(NomeProdutor)) > 0));
    AddSQL(Query, ' and tpe.cod_pessoa = tls.cod_pessoa_produtor', (CodTipoArquivoImportacao = 2) and (Length(Trim(NomeProdutor)) > 0));
    AddSQL(Query, ' and tpp.num_imovel_receita_federal = :num_imovel_receita_federal', (CodTipoArquivoImportacao = 2) and (((Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)) and (Length(Trim(NIRF)) > 0)));
    AddSQL(Query, ' and tls.cod_propriedade_rural = tpp.cod_propriedade_rural', (CodTipoArquivoImportacao = 2) and (((Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)) and (Length(Trim(NIRF)) > 0)));
    AddSQL(Query, ' and tpp.nom_propriedade_rural like :nom_propriedade_rural', (CodTipoArquivoImportacao = 2) and (((Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)) and (Length(Trim(NomePropriedade)) > 0)));
    AddSQL(Query, ' and tls.cod_propriedade_rural = tpp.cod_propriedade_rural', (CodTipoArquivoImportacao = 2) and (((Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0)) and (Length(Trim(NomePropriedade)) > 0)));
    AddSQL(Query, ' and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov', (CodTipoArquivoImportacao = 2) and (CodLocalizacaoSisbov > 0));
    AddSQL(Query, ' group by');
    AddSQL(Query, '     taa.cod_arq_import_sisbov');
    AddSQL(Query, '   , taa.nom_arq_import_sisbov');
    AddSQL(Query, '   , taa.nom_arq_upload');
    AddSQL(Query, '   , tu.nom_usuario');
    AddSQL(Query, '   , taa.dta_importacao');
    AddSQL(Query, '   , taa.dta_ultimo_processamento');
    AddSQL(Query, '   , tp.cod_arq_import_sisbov');
    AddSQL(Query, '   , taa.cod_tipo_arq_import_sisbov');
    AddSQL(Query, '   , taa.cod_situacao_arq_import');
    AddSQL(Query, '   , tto.sgl_tipo_origem_arq_import');
    AddSQL(Query, '   , tai.num_solicitacao', (CodTipoArquivoImportacao = 2) and (NumSolicitacao > 0));
    AddSQL(Query, '   , tpe.nom_pessoa', (CodTipoArquivoImportacao = 2) and (Length(Trim(NomeProdutor)) > 0));
    AddSQL(Query, '   , tpe.num_cnpj_cpf', (CodTipoArquivoImportacao = 2) and (Length(Trim(CNPJ_CPF)) > 0));
    AddSQL(Query, '   , tpp.nom_propriedade_rural', (CodTipoArquivoImportacao = 2) and (Length(Trim(NomePropriedade)) > 0));
    AddSQL(Query, '   , tpp.num_imovel_receita_federal', (CodTipoArquivoImportacao = 2) and (Length(Trim(NIRF)) > 0));
    AddSQL(Query, '   , tls.cod_localizacao_sisbov', (CodTipoArquivoImportacao = 2) and (CodLocalizacaoSisbov > 0));
    AddSQL(Query, 'having', IndErrosNoProcessamento = 'S');
    AddSQL(Query, '  tp.cod_arq_import_sisbov is not null', IndErrosNoProcessamento = 'S');
    AddSQL(Query, 'having', IndErrosNoProcessamento = 'N');
    AddSQL(Query, '  tp.cod_arq_import_sisbov is null', IndErrosNoProcessamento = 'N');
    AddSQL(Query, 'order by');
    AddSQL(Query, '  taa.dta_importacao desc');
{$ENDIF}

    if CodTipoArquivoImportacao > 0 then
    begin
      Query.ParamByName('cod_tipo_arq_import_sisbov').AsInteger := CodTipoArquivoImportacao;
    end;
    if (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0) then
    begin
      Query.ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
      Query.ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim) + 1;
    end;
    if (DtaUltimoProcessamentoInicio > 0) and (DtaUltimoProcessamentoFim > 0) then
    begin
      Query.ParamByName('dta_ultimo_processamento_inicio').AsDateTime := Trunc(DtaUltimoProcessamentoInicio);
      Query.ParamByName('dta_ultimo_processamento_fim').AsDateTime := Trunc(DtaUltimoProcessamentoFim)+1;
    end;
    if LoginUsuario <> '' then
    begin
      Query.ParamByName('nom_usuario').AsString := LoginUsuario + #37;
    end;

    if CodTipoArquivoImportacao = 2 then
    begin
      if NumSolicitacao > 0 then
      begin
        Query.ParamByName('num_solicitacao').AsInteger := NumSolicitacao;
      end;
      if (Length(Trim(NomeProdutor)) > 0) or (Length(Trim(CNPJ_CPF)) > 0) then
      begin
        if (Length(Trim(CNPJ_CPF)) > 0) then
        begin
          Query.ParamByName('num_cnpj_cpf').AsString := Trim(CNPJ_CPF);
        end;
        if (Length(Trim(NomeProdutor)) > 0) then
        begin
          Query.ParamByName('nom_pessoa').AsString := '%' + Trim(NomeProdutor) + '%';
        end;
      end;
      if (Length(Trim(NomePropriedade)) > 0) or (Length(Trim(NIRF)) > 0) then
      begin
        if (Length(Trim(NIRF)) > 0) then
        begin
          Query.ParamByName('num_imovel_receita_federal').AsString := Trim(NIRF);
        end;
        if (Length(Trim(NomePropriedade)) > 0) then
        begin
          Query.ParamByName('nom_propriedade_rural').AsString := '%' + Trim(NomePropriedade) + '%';
        end;
      end;

      if CodLocalizacaoSisbov > 0 then
      begin
        Query.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      end;
    end;

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
  Linha0: Array [0..3] of TCampo = (
    (Posicao: 1; Tamanho: 1),
    (Posicao: 2; Tamanho: 4),
    (Posicao: 6; Tamanho: 8),
    (Posicao: 14; Tamanho: 14));

  // Linha tipo 1
  Linha1: Array [0..1] of TCampo = (
    (Posicao: 1; Tamanho: 1),
    (Posicao: 2; Tamanho: 255));

  // Linha tipo 2
  Linha2: Array [0..1] of TCampo = (
    (Posicao: 1; Tamanho: 1),
    (Posicao: 2; Tamanho: 15));

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
    else
      AdicionarCampos(Linha2);
  end;
end;

procedure InterpretaLinhaArquivoImpCodSISBOV(Owner: TArquivoPosicionalLeitura);
type
  TCampo = record
    Posicao: Integer;
    Tamanho: Integer;
  end;
const
  // Linha tipo 0
  Linha0: Array [0..1] of TCampo = (
    (Posicao: 2; Tamanho: 1),
    (Posicao: 3; Tamanho: 14));

  // Linha tipo 1
  Linha1: Array [0..12] of TCampo = (
    (Posicao: 1; Tamanho: 1),   // Tipo Registro
    (Posicao: 2; Tamanho: 6),   // NR_Solicitacao
    (Posicao: 8; Tamanho: 6),   // Pais
    (Posicao: 14; Tamanho: 20), // Nome UF
    (Posicao: 34; Tamanho: 2),  // Sigla UF
    (Posicao: 36; Tamanho: 5),  // Tipo Inscrição Nirf ou Incra
    (Posicao: 41; Tamanho: 13),  // Nr. Incra ou NIRF
    (Posicao: 54; Tamanho: 10), // Cod Propriedade
    (Posicao: 64; Tamanho: 5),  // Qtd autorizada
    (Posicao: 69; Tamanho: 8),  // Dta solicitação
    (Posicao: 77; Tamanho: 2),  // Tipo Proprietario PF ou PJ
    (Posicao: 79; Tamanho: 14), // CPF NCPJ
    (Posicao: 93; Tamanho: 100)); // Nome do produtor

  // Linha tipo 2
  Linha2: Array [0..1] of TCampo = (
    (Posicao: 1; Tamanho: 1),
    (Posicao: 2; Tamanho: 17));
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
  else
      AdicionarCampos(Linha2);
  end;
end;

function TIntImportacoesSISBOV.PesquisarTipo;
Const
  CodMetodo : Integer = 510;
  NomMetodo : String = 'PesquisarTipoArquivoImportacao';
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
  Query.SQL.Clear;
  Query.SQL.Add(' Select ' +
                '     cod_tipo_arq_import_sisbov as CodImportacao ' +
                '   , sgl_tipo_arq_import_sisbov as SglImportacao ' +
                '   , des_tipo_arq_import_sisbov as DesImportacao ' +
                ' from ' +
                '   tab_tipo_arq_import_sisbov ' +
                ' Order by ' +
                '   des_tipo_arq_import_sisbov ');

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

function TIntImportacoesSISBOV.ProcessarInt(CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 487;
  NomeMetodo: String = 'Processar';
  aaCodSisbov: Integer = 2;
  aaCodAutenticacao: Integer = 3;
  iNumSolicitacaoSISBOV: Integer = 2;
  iNirf: Integer = 7;
  iCODLocalizacao: Integer = 8;
  iDtaSolicitacaoSISBOV: Integer = 10;
  iCPFCNPJ: Integer = 12;

  iCNPJ: Integer = 3;
  iCNPJCertificadora: Integer = 2;
  iTipo1: Integer = 1;
  iQtdTipo1: Integer = 2;
  iTipo2: Integer = 3;
  iQtdTipo2: Integer = 4;
var
  Q: THerdomQuery;
  Processamento: TProcessamento;
  Arquivo: TArquivoPosicionalLeitura;
  iLinhasTotal, iLinhasPercorridas: Integer;
  NomArquivoImportacao, numCodSisBov, sAux: String;
  DtaProcessamento, DtaSolicitacaoSISBOV: TDateTime;
  TipoArqProcessamento,
  codProdutor,
  codPropriedade,
  NumSolicitacaoSISBOV,
  CodLocalizacaoSisbov,
  CodAnimalSisBov,
  CodAnimalSISBOVInicio,
  CodAnimalSISBOVFim,
  NumDvSisbov,
  NumDVSISBOVInicio,
  NumDVSISBOVFim,
  CodPaisSisbov,
  CodEstadoSisbov,
  CodMicroRegiaoSisbov,
  Retorno: Integer;

  {
  *****************************************************************************
                         Funções internas ao método
  *****************************************************************************
  }
  { Verifica se o registro informado é válido }
  function VerificarRegistro: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '    nom_arq_import_sisbov as NomArquivoImportacao ' +
      '  , cod_tipo_arq_import_sisbov as TipoArquivo ' +
      'from '+
      '  tab_arq_import_sisbov  '+
      'where '+
      '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(1285, Self.ClassName, NomeMetodo, []);
      Result := -1285;
    end else begin
      NomArquivoImportacao := Q.FieldByName('NomArquivoImportacao').AsString;
      TipoArqProcessamento := Q.FieldByName('TipoArquivo').AsInteger;
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
      '  sum(qtd_total) as qtd_total '+
      'from '+
      '  tab_qtd_reg_import_sisbov '+
      'where '+
      '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.Open;
    iLinhasTotal := Q.FieldByName('qtd_total').AsInteger;
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  count(1) as NumLinhas '+
      'from '+
      '  tab_linha_arq_import_sisbov tlai '+
      'where '+
      '  tlai.cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
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
        '  tab_qtd_reg_import_sisbov tqtl '+
        'where '+
        '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.Open;
      if iiAux < Q.FieldByName('NumLinhasAProcessar').AsInteger then begin
        Result := 0;
      end else begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasAProcessar '+
          'from '+
          '  tab_linha_arq_import_sisbov tlai '+
          'where '+
          '  tlai.dta_processamento is null '+
          '  and tlai.cod_arq_import_sisbov = :cod_arq_import_sisbov '+
          'group by '+
          '  tlai.cod_arq_import_sisbov ';
        Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
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
  function VerificarArquivo(TipoArquivo: Integer): Integer;
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
      'update tab_arq_import_sisbov '+
      '   set qtd_vezes_processamento = qtd_vezes_processamento + 1 '+
      '     , cod_situacao_arq_import = ''P'' '+
      '     , dta_ultimo_processamento = :dta_ultimo_processamento '+
      ' where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('dta_ultimo_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;

    // Zera o número de erros obtidos durante o último processamento
    Q.Close;
    Q.SQL.Text :=
      'update tab_qtd_reg_import_sisbov '+
      'set '+
      '  qtd_erradas = 0 '+
      'where '+
      '  cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Incrementa indicador de progresso }
  procedure IncrementarProgresso;
  var
    iDesconto, iProgresso: Integer;
  begin
    if Thread.CodTarefa > 0 then begin
      // Número de linhas não salvas que teoricamente compõe o arquivo
      if TipoArqProcessamento = 1 then begin
        iDesconto := 2;
      end else if TipoArqProcessamento = 2 then begin
        iDesconto := 1;
      end else begin
        iDesconto := 0;
      end;

      // Obtem progresso atual da execução
      if iLinhasTotal > 0 then begin
        iProgresso := Integer(Trunc((Arquivo.LinhasLidas - iDesconto) /
          iLinhasTotal * 100));
      end else begin
        iProgresso := 0;
      end;

      // Atualiza o indicador de progresso
      Q.Close;
      Q.SQL.Text :=
        'update tab_tarefa '+
        'set '+
        '  qtd_progresso = :qtd_progresso '+
        'where '+
        '  cod_tarefa = :cod_tarefa ';
      Q.ParamByName('qtd_progresso').AsInteger := iProgresso;
      Q.ParamByName('cod_tarefa').AsInteger := Thread.CodTarefa;
      Q.ExecSQL;
    end;
  end;

  { Limpa as ocorrências obtidas no último processamento }
  procedure LimparOcorrenciaProcessamento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'delete from tab_ocorrencia_import_sisbov '+
      ' where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ExecSQL;
  end;

  { Guarda ocorrências durante o processamento }
  function GravarOcorrenciaProcessamento: Integer;
  var
    iiAux: Integer;
  begin
      Q.Close;

      // Script SQL de inserção de ocorrência durante o processamento
      Q.SQL.Text :=
                'insert into tab_ocorrencia_import_sisbov '+
                ' (cod_arq_import_sisbov '+
                '  , dta_processamento '+
                '  , cod_tipo_reg_import_sisbov '+
                '  , cod_tipo_mensagem '+
                '  , txt_mensagem '+
                '  , num_linha ' +
                '  , txt_identificacao ' +
                '  , txt_legenda_identificacao ) ' +
                'values '+
                ' (:cod_arq_import_sisbov '+
                '  , :dta_processamento '+
                '  , :cod_tipo_reg_import_sisbov '+
                '  , :cod_tipo_mensagem '+
                '  , :txt_mensagem '+
                '  , :num_linha  ' +
                '  , :txt_identificacao ' +
                '  , :txt_legenda_identificacao ) ';

         // Dados de identicação do arquivo e linha
         // Constantes a todos os tipos de ocorrências
      if TipoArqProcessamento = 2 then //Solicitacao
        begin
             Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
             Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
             Q.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := Arquivo.TipoLinha;
             Q.ParamByName('num_linha').AsInteger := Arquivo.LinhasLidas;
             Q.ParamByName('txt_identificacao').AsString := numCodSisBov;
             Q.ParamByName('txt_legenda_identificacao').AsString := 'Cód. SISBOV';

             // Tipos dos dados de identificação da ocorrência
             // Variável de acordo com o tipo da linha
             Q.ParamByName('txt_mensagem').DataType := ftString;


             for iiAux := 0 to Mensagens.Count-1 do begin
              // Verifica se a ocorrência é um erro fatal
                 Q.ParamByName('cod_tipo_mensagem').AsInteger := Mensagens.Items[iiAux].Tipo;
                 if CodMicroRegiaoSisbov <> -1 then
                  begin
                     Q.ParamByName('txt_mensagem').AsString := 'Código SISBOV: ' + StrZero(CodPaisSisbov, 3)
                                                                      + StrZero(CodEstadoSisbov, 2)
                                                                      + StrZero(CodMicroRegiaoSisbov, 3)
                                                                      + StrZero(CodAnimalSisbov, 9)
                                                                      + '.  Dígito Verif: ' + StrZero(NumDvSisbov, 1)
                                                                      + '.  Mensagem: ' + Mensagens.Items[iiAux].Texto;
                  end
                 else
                  begin
                     Q.ParamByName('txt_mensagem').AsString := 'Código SISBOV: ' + StrZero(CodPaisSisbov, 3)
                                                                      + StrZero(CodEstadoSisbov, 2)
                                                                      + StrZero(CodAnimalSisbov, 9)
                                                                      + '.  Dígito Verif: ' + StrZero(NumDvSisbov, 1)
                                                                      + '.  Mensagem: ' + Mensagens.Items[iiAux].Texto;
                  end;
              Q.ExecSQL;
          end;
       end
      else //Autenticação
       begin
             Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
             Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
             Q.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := Arquivo.TipoLinha;
             Q.ParamByName('num_linha').AsInteger := Arquivo.LinhasLidas;
             Q.ParamByName('txt_identificacao').AsString := numCodSisBov;
             Q.ParamByName('txt_legenda_identificacao').AsString := 'Autenticação';

             // Tipos dos dados de identificação da ocorrência
             // Variável de acordo com o tipo da linha
             Q.ParamByName('txt_mensagem').DataType := ftString;


             for iiAux := 0 to Mensagens.Count-1 do begin
              // Verifica se a ocorrência é um erro fatal
                 Q.ParamByName('cod_tipo_mensagem').AsInteger := Mensagens.Items[iiAux].Tipo;
                 Q.ParamByName('txt_mensagem').AsString := 'Mensagem: ' + Mensagens.Items[iiAux].Texto;
              Q.ExecSQL;
             end;
       end;

      // Limpa mensagens geradas durante a última linha de processamento
      Mensagens.Clear;
      Result := 0;
  end;

  { Cancela o processamento em andamento }
  procedure CancelarProcessamento;
  begin
    // Reabilita ao sistema o controle sobre transações
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
      '  tab_linha_arq_import_sisbov '+
      'where '+
      '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.Open;
    if Q.IsEmpty then begin
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_linha_arq_import_sisbov '+
        ' (cod_arq_import_sisbov '+
        '  , num_linha '+
        '  , dta_processamento) '+
        'values '+
        ' (  :cod_arq_import_sisbov '+
        '  , :num_linha '+
        '  , null) ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
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
      '  tab_linha_arq_import_sisbov '+
      'set '+
      '  dta_processamento = :dta_processamento '+
      'where '+
      '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
      '  and num_linha = :num_linha ';
    Q.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    Q.ParamByName('num_linha').AsInteger := NumLinha;
    Q.ExecSQL;
  end;

  { Trata resultado da função de processamento }
  function TratarResultadoProcessamento(Resultado: Integer): Integer;
  begin
    if Resultado < 0 then begin
      Result := Processamento.IncErradas(Arquivo.TipoLinha);
      if Result < 0 then Exit;
      Result := GravarOcorrenciaProcessamento;
    end
   else
    begin
      MarcarLinhaComoProcessada(Arquivo.LinhasLidas);
      Result := Processamento.IncProcessadas(Arquivo.TipoLinha);
    end;
  end;

  { Processa arquivo recebido do SISBOV referente a solicitação de códigos SISBOV }
  function InserirCodigosSisbov(codProdutor, codPropriedade: Integer): Integer;
   begin
      try
         FIntCodigosSISBOV := TIntCodigosSISBOV.Create;
         FIntCodigosSISBOV.Inicializar(Conexao, Mensagens);

         Result := FIntCodigosSISBOV.Inserir(CodProdutor, '', '',
          CodPropriedade, '', -1, NumSolicitacaoSISBOV, DtaSolicitacaoSISBOV,
          CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
          CodAnimalSISBOVInicio, NumDVSISBOVInicio, CodAnimalSISBOVFim,
          NumDVSISBOVFim, 0);
      finally
        FIntCodigosSISBOV.Free;
      end;

   end;

  function LerProdutorPropriedade(CPF_CNPJ, NIRF: String; CodLocalizacaoSisbov: Integer): Integer;
   var
      Q: THerdomQuery;
   begin
      Q := THerdomQuery.Create(Conexao, nil);
      Q.Close;
      Q.SQL.Text := ' Select ' +
                    '    cod_pessoa CodPessoa' +
                    ' from ' +
                    '    tab_pessoa ' +
                    ' where ' +
                    '    num_cnpj_cpf = :cnpj_cpf ' +
                    '    and dta_fim_validade is null ';
      Q.ParamByName('cnpj_cpf').AsString := CPF_CNPJ;
      Q.Open;
      codProdutor := Q.FieldbyName('CodPessoa').AsInteger;
      Q.Close;
      Q.SQL.Text := ' Select tpr.cod_propriedade_rural as CodPropriedadeRural' +
                    '   from tab_propriedade_rural tpr,' +
                    '        tab_localizacao_sisbov tls' +
                    '  where tpr.num_imovel_receita_federal = :nirf ' +
                    '    and tpr.dta_fim_validade is null ' +
                    '    and tpr.cod_propriedade_rural = tls.cod_propriedade_rural ' +
                    '    and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov';
      Q.ParamByName('nirf').AsString := Trim(NIRF);
      Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2094, Self.ClassName, 'LerProdutorPropriedade',
          [NIRF + ' - código exportação: '
          + IntToStr(CodLocalizacaoSisbov)]);
        Result := -2094;
        Exit;
      end;
      codPropriedade := Q.FieldByName('CodPropriedadeRural').AsInteger;
      Result := 1;
   end;

  procedure AtualizaSituacaoArqImport;
  var QtdTotal, QtdProcessadas, QtdErradas: Integer;
  begin
    Q.Close;
    Q.SQL.Text :=
     'select sum(qtd_total) as qtd_total, sum(qtd_processadas) as qtd_processadas, sum(qtd_erradas) as qtd_erradas'+
     ' from tab_qtd_reg_import_sisbov where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;                
    Q.Open;
      QtdTotal := Q.FieldByName('qtd_total').AsInteger;
      QtdProcessadas := Q.FieldByName('qtd_processadas').AsInteger;
      QtdErradas := Q.FieldByName('qtd_erradas').AsInteger;
    Q.Close;
    Q.SQL.Text :=
     'update tab_arq_import_sisbov set cod_situacao_arq_import = :cod_situacao_arq_import '+
     ' where cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
    if (QtdTotal = QtdProcessadas) and (QtdErradas = 0) then begin
      Q.ParamByName('cod_situacao_arq_import').AsString := 'C';
    end else begin
      Q.ParamByName('cod_situacao_arq_import').AsString := 'P';
    end;
    Q.ExecSQL;
  end;
  {
  ******************************************************************************
                       Processamento dos Arquivos de Importação
  ******************************************************************************
  }
  function ProcessarArquivoAutenticacao: Integer;
  var
    QueryLocal: THerdomQueryNavegacao;
    IntCodigosSISBOV: TIntCodigosSISBOV;
    CodPaisSISBOVAtual, CodEstadoSISBOVAtual, CodMicroRegiaoSISBOVAtual,
      CodAnimalSISBOVAtual, NumDVSISBOVAtual: Integer;
    CodPaisSISBOVInicial, CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial,
      CodAnimalSISBOVInicial, NumDVSISBOVInicial: Integer;
    CodPaisSISBOVFinal, CodEstadoSISBOVFinal, CodMicroRegiaoSISBOVFinal,
      CodAnimalSISBOVFinal, NumDVSISBOVFinal: Integer;
    QtdCodigos, NumLinhaInicio, iAux: Integer;
    StrCodigoInicial, StrCodigoFinal: String;
    DtaLiberacaoAbate: TDateTime;
    IndProcessarLinha: Boolean;
  begin
    CodPaisSISBOVInicial := -1;
    CodEstadoSISBOVInicial := -1;
    CodMicroRegiaoSISBOVInicial := -1;
    CodAnimalSISBOVInicial := -1;
    NumDVSISBOVInicial := -1;
    CodPaisSISBOVFinal := -1;
    CodEstadoSISBOVFinal := -1;
    CodMicroRegiaoSISBOVFinal := -1;
    CodAnimalSISBOVFinal := -1;
    NumDVSISBOVFinal := -1;
    CodPaisSISBOVAtual := -1;
    CodEstadoSISBOVAtual := -1;
    CodMicroRegiaoSISBOVAtual := -1;
    CodAnimalSISBOVAtual := -1;
    NumDVSISBOVAtual := -1;
    DtaLiberacaoAbate := 0;
    NumLinhaInicio := 0;
    Arquivo.RotinaLeitura := InterpretaLinhaArquivoAutenticacao;
    QueryLocal := THerdomQueryNavegacao.Create(nil);
    try
      IntCodigosSISBOV := TIntCodigosSisbov.Create;
      try
        QueryLocal.SQLConnection := Conexao.SQLConnection;
        Result := IntCodigosSISBOV.Inicializar(Conexao, Mensagens);
        if Result < 0 then begin
          Exit;
        end;

        QueryLocal.SQL.Text :=
          'select ' +
          '  cod_pessoa_produtor ' +
          '  , cod_propriedade_rural ' +
          '  , num_solicitacao_sisbov ' +
          '  , min(cod_animal_sisbov) as cod_animal_sisbov_min ' +
          '  , max(cod_animal_sisbov) as cod_animal_sisbov_max ' +
          '  , count(cod_animal_sisbov) as qtd_animal_sisbov ' +
          'from ' +
          '  tab_codigo_sisbov ' +
          'where ' +
          '  cod_pais_sisbov = :cod_pais_sisbov ' +
          '  and cod_estado_sisbov = :cod_estado_sisbov ' +
          '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
          '  and cod_animal_sisbov between :cod_animal_sisbov_inicial and :cod_animal_sisbov_final ' +
          'group by ' +
          '  cod_pessoa_produtor ' +
          '  , cod_propriedade_rural ' +
          '  , num_solicitacao_sisbov ' +
          'order by ' +
          '  cod_animal_sisbov_min ';

        Arquivo.ReInicializar;
        while (Arquivo.EOF = False) and (Thread.Suspended = False) do begin
          Result := Arquivo.ObterLinha;
          if Result < 0 then begin
            Result := -1232;
            Mensagens.Adicionar(1232, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);
            BeginTran;
            GravarOcorrenciaProcessamento;
            Commit;
            Exit;
          end;
          case (Arquivo.TipoLinha) of
            0: // Informações da certificadora
            begin
              // Obtem a data de efetivação dos animais
              DtaLiberacaoAbate := EncodeDate(
                StrToInt(Copy(Arquivo.ValorColuna[3], 5, 4)),
                StrToInt(Copy(Arquivo.ValorColuna[3], 3, 2)),
                StrToInt(Copy(Arquivo.ValorColuna[3], 1, 2)));
              // Incrementa a data de efetivação dos animais com a quantidade
              // de dias da quarentena
              DtaLiberacaoAbate := DtaLiberacaoAbate +
                StrToIntDef(ValorParametro(66), 40);
            end;
            1: // Nome do arquivo
            begin
              if ProcessarLinha(Arquivo.LinhasLidas) = 1 then begin
                MarcarLinhaComoProcessada(Arquivo.LinhasLidas);
                Processamento.IncProcessadas(1);
              end;
            end;
            2, 9: // Autenticações
            begin
              if (Arquivo.TipoLinha = 2) then begin
              ObtemCodigoSISBOV(Arquivo.ValorColuna[2], CodPaisSISBOVAtual,
                CodEstadoSISBOVAtual, CodMicroRegiaoSISBOVAtual,
                CodAnimalSISBOVAtual, NumDVSISBOVAtual);
              end;

              IndProcessarLinha := (ProcessarLinha(Arquivo.LinhasLidas) = 1);

              if (Arquivo.TipoLinha = 2) and (IndProcessarLinha) then begin
                if (CodAnimalSISBOVInicial = -1) then begin
                  CodPaisSISBOVInicial := CodPaisSISBOVAtual;
                  CodEstadoSISBOVInicial := CodEstadoSISBOVAtual;
                  CodMicroRegiaoSISBOVInicial := CodMicroRegiaoSISBOVAtual;
                  CodAnimalSISBOVInicial := CodAnimalSISBOVAtual;
                  NumDVSISBOVInicial := NumDVSISBOVAtual;

                  CodPaisSISBOVFinal := CodPaisSISBOVAtual;
                  CodEstadoSISBOVFinal := CodEstadoSISBOVAtual;
                  CodMicroRegiaoSISBOVFinal := CodMicroRegiaoSISBOVAtual;
                  CodAnimalSISBOVFinal := CodAnimalSISBOVAtual;
                  NumDVSISBOVFinal := NumDVSISBOVAtual;
                  NumLinhaInicio := Arquivo.LinhasLidas;
                end;
              end;

              if (CodAnimalSISBOVInicial <> -1) and ((Arquivo.TipoLinha = 9) or (CodAnimalSISBOVInicial <> CodAnimalSISBOVAtual)) then begin
                if (Arquivo.TipoLinha = 9) or not(IndProcessarLinha) or (
                  (CodPaisSISBOVFinal <> CodPaisSISBOVAtual) or
                  (CodEstadoSISBOVFinal <> CodEstadoSISBOVAtual) or
                  (CodMicroRegiaoSISBOVFinal <> CodMicroRegiaoSISBOVAtual) or
                  (CodAnimalSISBOVFinal <> CodAnimalSISBOVAtual - 1)) then begin

                  BeginTran;
                  try
                    QueryLocal.Close;
                    QueryLocal.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOVInicial;
                    QueryLocal.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOVInicial;
                    QueryLocal.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOVInicial;
                    QueryLocal.ParamByName('cod_animal_sisbov_inicial').AsInteger := CodAnimalSISBOVInicial;
                    QueryLocal.ParamByName('cod_animal_sisbov_final').AsInteger := CodAnimalSISBOVFinal;
                    QueryLocal.Open;
                    if QueryLocal.IsEmpty then begin
                      Mensagens.Adicionar(1956, Self.ClassName, NomeMetodo, [IntToStr(CodAnimalSISBOVInicial), IntToStr(CodAnimalSISBOVFinal)]);
                      Result := Processamento.IncErradas(2, CodAnimalSISBOVFinal - CodAnimalSISBOVInicial + 1);
                      if Result < 0 then begin
                        Rollback;
                        Exit;
                      end;
                    end else begin
                      QtdCodigos := 0;
                      while not QueryLocal.Eof do begin
                        Inc(QtdCodigos, QueryLocal.FieldByName('qtd_animal_sisbov').AsInteger);
                        QueryLocal.Next;
                      end;
                      if QtdCodigos <> CodAnimalSISBOVFinal - CodAnimalSISBOVInicial + 1 then begin
                        StrCodigoInicial := FormataCodigoSISBOV(CodPaisSISBOVInicial, CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial, CodAnimalSISBOVInicial, NumDVSISBOVInicial);
                        StrCodigoFinal := FormataCodigoSISBOV(CodPaisSISBOVFinal, CodEstadoSISBOVFinal, CodMicroRegiaoSISBOVFinal, CodAnimalSISBOVFinal, NumDVSISBOVFinal);
                        Mensagens.Adicionar(1958, Self.ClassName, NomeMetodo, [StrCodigoInicial, StrCodigoFinal]);
                        Result := Processamento.IncErradas(2, CodAnimalSISBOVFinal - CodAnimalSISBOVInicial + 1);
                        if Result < 0 then begin
                          Rollback;
                          Exit;
                        end;
                      end else begin
                        QueryLocal.First;
                        while not QueryLocal.Eof do begin
                          // Identifica quantidade de códigos
                          QtdCodigos := QueryLocal.FieldByName('qtd_animal_sisbov').AsInteger;

                          // Identifica codigo SISBOV inicial
                          CodAnimalSISBOVInicial :=
                            QueryLocal.FieldByName('cod_animal_sisbov_min').AsInteger;
                          NumDvSISBOVInicial := BuscarDVSisBov(CodPaisSISBOVInicial,
                            CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial,
                            CodAnimalSISBOVInicial);

                          // Identifica código SISBOV final
                          CodAnimalSISBOVFinal :=
                            QueryLocal.FieldByName('cod_animal_sisbov_max').AsInteger;
                          NumDvSISBOVFinal := BuscarDVSisBov(CodPaisSISBOVFinal,
                            CodEstadoSISBOVFinal, CodMicroRegiaoSISBOVFinal,
                            CodAnimalSISBOVFinal);

                          // Salva o ponto de retorno caso as operações a seguir falhem
                          Conexao.SaveTran('ProcessaAutenticacao');

                          // Ignora o controle transacional para as operações a seguir
                          Conexao.IgnorarNovasTransacoes := True;

                          try
                            // Atualiza a autenticação dos códigos SISBOV
                            Result := IntCodigosSISBOV.ProcessarAutenticacao(
                              QueryLocal.FieldByName('cod_pessoa_produtor').AsInteger, '', '',
                              QueryLocal.FieldByName('cod_propriedade_rural').AsInteger, '', CodLocalizacaoSisbov,
                              CodPaisSISBOVInicial, CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial,
                              CodAnimalSISBOVInicial, NumDvSISBOVInicial, CodAnimalSISBOVFinal,
                              NumDVSISBOVFinal, DtaLiberacaoAbate);
                          finally
                            // Reabilita o controle transacional para as operações a seguir
                            Conexao.IgnorarNovasTransacoes := False;
                          end;

                          // Se a função foi executada com sucesso então
                          // Insere o registro com a faixa de códigos sisbov processada
                          if Result >= 0 then begin
                            try
                              InsereAutenticacao(CodArquivoImportacao, CodPaisSISBOVInicial,
                                CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial,
                                CodAnimalSISBOVInicial, CodAnimalSISBOVFinal,
                                QueryLocal.FieldByName('cod_pessoa_produtor').AsInteger,
                                QueryLocal.FieldByName('cod_propriedade_rural').AsInteger);
                            except
                              on E: Exception do begin
                                StrCodigoInicial := FormataCodigoSISBOV(CodPaisSISBOVInicial, CodEstadoSISBOVInicial, CodMicroRegiaoSISBOVInicial, CodAnimalSISBOVInicial, NumDVSISBOVInicial);
                                StrCodigoFinal := FormataCodigoSISBOV(CodPaisSISBOVFinal, CodEstadoSISBOVFinal, CodMicroRegiaoSISBOVFinal, CodAnimalSISBOVFinal, NumDVSISBOVFinal);
                                Mensagens.Adicionar(1957, Self.ClassName, NomeMetodo, [StrCodigoInicial, StrCodigoFinal]);
                                Result := -1957;
                              end;
                            end;
                          end;

                          // Se a faixa de códigos foi processada corretamente marca
                          // as linhas como processadas, caso contrário a quantidade
                          // de erros é incrementada
                          if Result < 0 then begin
                            Conexao.RollTran('ProcessaAutenticacao');
                            Result := Processamento.IncErradas(2, QtdCodigos);
                            if Result < 0 then begin
                              Rollback;
                              Exit;
                            end;
                          end else begin
                            Result := Processamento.IncProcessadas(2, QtdCodigos);
                            if Result < 0 then begin
                              Rollback;
                              Exit;
                            end;
                            for iAux := 1 to QtdCodigos do begin
                              MarcarLinhaComoProcessada(NumLinhaInicio);
                              Inc(NumLinhaInicio);
                            end;
                          end;
                          QueryLocal.Next;
                        end;
                      end;
                    end;
                    GravarOcorrenciaProcessamento;
                    IncrementarProgresso;
                    Commit;
                  except
                    on E: Exception do begin
                      Rollback;
                      raise E;
                    end;
                  end;

                  if IndProcessarLinha then begin
                    CodPaisSISBOVInicial := CodPaisSISBOVAtual;
                    CodEstadoSISBOVInicial := CodEstadoSISBOVAtual;
                    CodMicroRegiaoSISBOVInicial := CodMicroRegiaoSISBOVAtual;
                    CodAnimalSISBOVInicial := CodAnimalSISBOVAtual;
                    NumDVSISBOVInicial := NumDVSISBOVAtual;

                    CodPaisSISBOVFinal := CodPaisSISBOVAtual;
                    CodEstadoSISBOVFinal := CodEstadoSISBOVAtual;
                    CodMicroRegiaoSISBOVFinal := CodMicroRegiaoSISBOVAtual;
                    CodAnimalSISBOVFinal := CodAnimalSISBOVAtual;
                    NumDVSISBOVFinal := NumDVSISBOVAtual;
                    NumLinhaInicio := Arquivo.LinhasLidas;
                  end else begin
                    CodAnimalSISBOVInicial := -1;
                  end;
                end else begin
                  CodPaisSISBOVFinal := CodPaisSISBOVAtual;
                  CodEstadoSISBOVFinal := CodEstadoSISBOVAtual;
                  CodMicroRegiaoSISBOVFinal := CodMicroRegiaoSISBOVAtual;
                  CodAnimalSISBOVFinal := CodAnimalSISBOVAtual;
                  NumDVSISBOVFinal := NumDVSISBOVAtual;
                end;
              end;
            end;
          end;
        end;
        // Atualiza indicador de progresso da tarefa para 100%
        iLinhasTotal := Arquivo.LinhasLidas - 2;
        IncrementarProgresso;

        // Identifica procedimento como bem sucedido
        Result := 0;
      finally
        IntCodigosSISBOV.Free;
      end;
    finally
      QueryLocal.Free;
    end;
  end;

  function ProcessarArquivoSolicitacaoCodigoSisBov(): Integer;
  var
    iAux, NumLinhaInicio: Integer;
  begin
    Arquivo.RotinaLeitura := InterpretaLinhaArquivoImpCodSISBOV;
    CodAnimalSISBOVInicio := -1;
    NumDVSISBOVInicio := -1;
    NumLinhaInicio := -1;
    while (Arquivo.EOF = False) and (Thread.Suspended = False) do
    begin
      Result := Arquivo.ObterLinha; // Obtem linha do arquivo de importação
      if Result < 0 then
      begin
        Mensagens.Adicionar(1232, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);
        Result := GravarOcorrenciaProcessamento;
        if Result < 0 then
        begin
          Exit;
        end;

        Result := -1232;
        CancelarProcessamento;
        Exit;
      end;

      Result := ProcessarLinha(Arquivo.LinhasLidas); // Verifica se a linha atual deve ser processada

      // Caso o arquivo já tenha sido processado, não entra no
      // if Result = 1 then! -> Portanto não processando o produtor e a propriedade
      if (Result = 0) and (TipoArqProcessamento = 2) and (Arquivo.TipoLinha = 1) then
      begin
        NumSolicitacaoSISBOV := Arquivo.ValorColuna[iNumSolicitacaoSISBOV];
        sAux := Arquivo.ValorColuna[iDtaSolicitacaoSISBOV];
        DtaSolicitacaoSISBOV := EncodeDate(
          StrToInt(Copy(sAux, 5, 4)),
          StrToInt(Copy(sAux, 3, 2)),
          StrToInt(Copy(sAux, 1, 2)));
        Result := LerProdutorPropriedade(Arquivo.ValorColuna[iCPFCNPJ],
          Arquivo.ValorColuna[iNirf], Arquivo.ValorColuna[iCODLocalizacao]);
      end;

      if Result < 0 then
      begin
        CancelarProcessamento;
        Exit;
      end;

      if (Result = 1) or (Arquivo.TipoLinha = 1) then
      begin
        case (Arquivo.TipoLinha) of
          1:
          begin
            // iAux := Result;
            NumSolicitacaoSISBOV := Arquivo.ValorColuna[iNumSolicitacaoSISBOV];
            sAux := Arquivo.ValorColuna[iDtaSolicitacaoSISBOV];
            DtaSolicitacaoSISBOV := EncodeDate(
              StrToInt(Copy(sAux, 5, 4)),
              StrToInt(Copy(sAux, 3, 2)),
              StrToInt(Copy(sAux, 1, 2)));
            Result := LerProdutorPropriedade(Arquivo.ValorColuna[iCPFCNPJ],
              Arquivo.ValorColuna[iNirf], Arquivo.ValorColuna[iCODLocalizacao]);
            if Result < 0 then
            begin
              Exit;
            end;
          end;
          2: {Solicitação de códigos SISBOV}
          begin
            // Consiste inicialmente a quantidade de colunas da linha
            if Arquivo.NumeroColunas <> 2 then
            begin
              Mensagens.Adicionar(1294, Self.ClassName, NomeMetodo, ['SolicitacaoCodigosSISBOV']);
              Result := -1294;
              Exit;
            end;
            if Length(Arquivo.ValorColuna[aaCodSisbov]) <> 15 then
            begin
              Mensagens.Adicionar(1678, Self.ClassName, NomeMetodo, [IntToStr(Arquivo.LinhasLidas)]);
              Result := -1678;
              Exit;
            end;

            CodPaisSisbov := StrToIntDef(Copy(
              Arquivo.ValorColuna[aaCodSisbov], 1, 3), 0);
            CodEstadoSisbov := StrToIntDef(Copy(
              Arquivo.ValorColuna[aaCodSisbov], 4, 2), 0);
            CodMicroRegiaoSisbov := -1;
            CodAnimalSisbov := StrToIntDef(
              Copy(Arquivo.ValorColuna[aaCodSisbov], 6, 9), 0);
            NumDvSisbov := StrToIntDef(
              Copy(Arquivo.ValorColuna[aaCodSisbov], 15, 1), 0);
            if NumDvSisbov <> BuscarDVSisBov(CodPaisSisbov, CodEstadoSisbov,
              CodMicroRegiaoSisbov, CodAnimalSisbov) then
            begin
              Mensagens.Adicionar(526, Self.ClassName, NomeMetodo, []);
              Result := -526;
              Exit;
            end;
            if CodAnimalSISBOVInicio = -1 then
            begin
              CodAnimalSISBOVInicio := CodAnimalSisbov;
              NumDVSISBOVInicio := NumDvSisbov;
            end;
            CodAnimalSISBOVFim := CodAnimalSisbov;
            NumDVSISBOVFim := NumDvSisbov;
            if NumLinhaInicio = -1 then
            begin
              NumLinhaInicio := Arquivo.LinhasLidas;
            end;

            Conexao.BeginTran;
            IncrementarProgresso;
            Conexao.Commit;
          end;
        end;
      end;
    end;

    Conexao.BeginTran;
    Result := InserirCodigosSisbov(codProdutor, codPropriedade);
    if (Result < 0) then
    begin
      // Desfaz alterações realizadas pelo procedimento, caso ele tenha
      // feito alguma
      Rollback;

      // Reabre transação para armazenamento das mensagens de erro geradas
      // durante o processamento
      Conexao.BeginTran;
      Processamento.IncErradas(2, CodAnimalSISBOVFim - CodAnimalSISBOVInicio + 1);
      GravarOcorrenciaProcessamento;
      Conexao.Commit;
      Retorno := Result;
      Exit;
    end
    else
    begin
      Processamento.IncProcessadas(1);

      Processamento.IncProcessadas(2, CodAnimalSISBOVFim - CodAnimalSISBOVInicio + 1);
      for iAux := 1 to CodAnimalSISBOVFim - CodAnimalSISBOVInicio + 1 do
      begin
        MarcarLinhaComoProcessada(NumLinhaInicio);
        Inc(NumLinhaInicio);
      end;
    end;

    // Atualiza indicador de progresso da tarefa para 100%
    iLinhasTotal := Arquivo.LinhasLidas - 1;
    IncrementarProgresso;

    Conexao.Commit;
    Retorno := 0;
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

      Result := VerificarRegistro; // Verifica se o registro informado é válido
      if Result < 0 then Exit;
      Result := VerificarStatus; // Verifica se o arquivo ainda está disponível para processamento
      if Result < 0 then Exit;
      Result := VerificarArquivo(TipoArqProcessamento); // Verifica se o arquivo existe fisicamente em disco
      if Result < 0 then Exit;

      DtaProcessamento := Conexao.DtaSistema; // Obtem a data corrente do sistema (data + hora de processamento)
      Arquivo.NomeArquivo := NomArquivoImportacao; // Identifica arquivo de upload

      {Guarda resultado da tentativa de abertura do arquivo}
      Result := Arquivo.Inicializar;
      if Result = EArquivoInexistente then begin {Trata possíveis erros durante a tentativa de abertura do arquivo}
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

      Mensagens.Clear; // Limpa lista de mensagens geradas pelo sistema

      // Classe que auxilia na totalização de valores do processamento
      Result := Processamento.Inicializar(Conexao, Mensagens);
      if Result < 0 then begin
        CancelarProcessamento;
        Exit;
      end;
      Processamento.CodArquivoImportacao := CodArquivoImportacao;

      // Abre transação
      Conexao.BeginTran;
      // Incrementa o contador de vezes que o arquivo foi processado
      IncrementarQtdVezesProcessamento;
      // Limpa as ocorrências obtidas no último processamento
      LimparOcorrenciaProcessamento;
      // Confirma transação
      Conexao.Commit;

      case TipoArqProcessamento of //Chamada para método responsável por processar o arquivo!
        1: Result := ProcessarArquivoAutenticacao;
        2: Result := ProcessarArquivoSolicitacaoCodigoSisBov();
      else
        Mensagens.Adicionar(1084, Self.ClassName, NomeMetodo, []);
        Result := -1084;
        Exit;
      end;
      BeginTran;
      AtualizaSituacaoArqImport;
      Result := GravarOcorrenciaProcessamento;
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      Commit;

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
      Conexao.Rollback;  // desfaz transação se houver uma ativa
      if TipoArqProcessamento = 1 then begin
        Mensagens.Adicionar(1592, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1592;
      end else begin
        Mensagens.Adicionar(2007, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2007;
      end;
      Exit;
    end;
  end;
end;

function TIntImportacoesSISBOV.PesquisarOcorrencias(
  CodArquivoImportacao, CodTipoLinhaImportacao,
  CodTipoMensagem: Integer): Integer;
const
  Metodo: Integer = 488;
  NomeMetodo: String = 'PesquisarOcorrencias';
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
      '    toa.dta_processamento as DtaProcessamento '+
      '  , toa.cod_tipo_reg_import_sisbov as CodTipoLinhaImportacao '+
      '  , toa.num_linha as NumLinha '+
      '  , toa.cod_tipo_mensagem as CodTipoMensagem '+
      '  , toa.txt_mensagem as TxtMensagem '+
      'from '+
      '  tab_ocorrencia_import_sisbov toa '+
      'where '+
      '  toa.cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;

    if CodTipoLinhaImportacao <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toa.cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';
      Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
    end;

    if CodTipoMensagem <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and toa.cod_tipo_mensagem = :cod_tipo_mensagem ';
      Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
    end;

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

{ TArmazenamento }

constructor TArmazenamento.Create;
begin
  inherited;
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
  InsertImportacaoSisBov: String =
    'insert into tab_qtd_reg_import_sisbov '+
    ' (cod_arq_import_sisbov, '+
    '  cod_tipo_reg_import_sisbov, '+
    '  qtd_total, '+
    '  qtd_erradas, '+
    '  qtd_processadas) '+
    'values '+
    ' (:cod_arq_import_sisbov, '+
    '  :cod_tipo_reg_import_sisbov, '+
    '  :qtd_total, '+
    '  :qtd_erradas, '+
    '  :qtd_processadas) ';
var
  iAux: Integer;
begin
  try
    Query.Close;
    Query.SQL.Text := InsertImportacaoSisBov;

    for iAux := 0 to Length(FTipos)-1 do begin
      Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
      Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := FTipos[iAux].CodTipoLinha;
      Query.ParamByName('qtd_total').AsInteger := FTipos[iAux].QtdLidas;
      Query.ParamByName('qtd_erradas').AsInteger := FTipos[iAux].QtdErradas;
      Query.ParamByName('qtd_processadas').AsInteger := FTipos[iAux].QtdProcessadas;
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

{ TProcessamento }

constructor TProcessamento.Create;
begin
  inherited;
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
    Query.SQL.Text :=
         'select '+
         '  qtd_total as QtdTotal '+
         'from '+
         '  tab_qtd_reg_import_sisbov '+
         'where '+
         '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
         '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdTotal').AsInteger;

    if Query.IsEmpty then begin
      // É a primeira linha deste tipo
      Query.Close;
        Query.SQL.Text :=
          'insert into tab_qtd_reg_import_sisbov '+
          ' (cod_arq_import_sisbov, '+
          '  cod_tipo_reg_import_sisbov, '+
          '  qtd_total, '+
          '  qtd_processadas) '+
          'values '+
          ' (:cod_arq_import_sisbov, '+
          '  :cod_tipo_reg_import_sisbov, '+
          '  :qtd_total, '+
          '  0) ';
    end else begin
      // Incrementa o totalizador atual
      Query.Close;
      Query.SQL.Text :=
          'update '+
          '  tab_qtd_reg_import_sisbov '+
          'set '+
          '  qtd_total = :qtd_total '+
          'where '+
          '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
          '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';
    end;

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_total').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
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

function TProcessamento.IncErradas(CodTipoLinhaImportacao: Integer): Integer;
begin
  Result := IncErradas(CodTipoLinhaImportacao, 1);
end;

function TProcessamento.IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
begin
  Result := IncProcessadas(CodTipoLinhaImportacao, 1);
end;

function TProcessamento.IncErradas(
  CodTipoLinhaImportacao, Qtd: Integer): Integer;
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
    Query.SQL.Text :=
        'select '+
        '  qtd_erradas as QtdErradas '+
        'from '+
        '  tab_qtd_reg_import_sisbov '+
        'where '+
        '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
        '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdErradas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
     Query.SQL.Text :=
        'update '+
        '  tab_qtd_reg_import_sisbov '+
        'set '+
        '  qtd_erradas = :qtd_erradas '+
        'where '+
        '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
        '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';

    // Atualiza grandeza
    Inc(iAux, Qtd);
    Query.ParamByName('qtd_erradas').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
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

function TProcessamento.IncProcessadas(CodTipoLinhaImportacao, Qtd: Integer): Integer;
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
    Query.SQL.Text :=
        'select '+
        '  qtd_processadas as QtdProcessadas '+
        'from '+
        '  tab_qtd_reg_import_sisbov '+
        'where '+
        '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
        '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdProcessadas').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text :=
        'update '+
        '  tab_qtd_reg_import_sisbov '+
        'set '+
        '  qtd_processadas = :qtd_processadas '+
        'where '+
        '  cod_arq_import_sisbov = :cod_arq_import_sisbov '+
        '  and cod_tipo_reg_import_sisbov = :cod_tipo_reg_import_sisbov ';

    // Atualiza grandeza
    Inc(iAux, Qtd);
    Query.ParamByName('qtd_processadas').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ParamByName('cod_tipo_reg_import_sisbov').AsInteger := CodTipoLinhaImportacao;
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

{  Funções comuns às classes!  }
function ValidarCertificadora(NumCNPJ: String; AOwner: TObject): Integer;
const
   NomeMetodo = 'ValidarCertificadora';
var
  NumCNPJCertificadora: String;
  Conexao: TConexao;
  Q: THerdomQuery;
  Mensagens: TIntMensagens;
begin
  if (AOwner is TIntImportacoesSISBOV) then begin
    Conexao := TIntImportacoesSISBOV(AOwner).Conexao;
    Mensagens := TIntImportacoesSISBOV(AOwner).Mensagens;
  end else begin              
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
   try
     try
       Q.Close;
       Q.SQL.Text := 'select '+
        '    tp.nom_pessoa as NomCertificadora '+
        '  , num_cnpj_cpf as NumCNPJCertificadora '+
        'from '+
        '  tab_pessoa tp '+
        '  , tab_parametro_sistema tps '+
        'where '+
        {$IFDEF MSSQL}
        '  tp.cod_pessoa = CAST(tps.val_parametro_sistema AS int) '+                   
        {$ENDIF}
        '  and tps.cod_parametro_sistema = 4' ;
       Q.Open;
       if Q.IsEmpty then begin
        Mensagens.Adicionar(1210, AOwner.ClassName, NomeMetodo, []);
        Result := -1210;                                                             
        Exit;
       end;
       NumCNPJCertificadora := Q.FieldByName('NumCNPJCertificadora').AsString;
       if (ValidaCNPJ(NumCNPJCertificadora) = validaCNPJ(NumCNPJ)) then
          Result := 1
       else
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

function ValidarProdutor(Natureza, NumCNPJCPF: String;
  var CodPessoaProdutor: Integer; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ValidarProdutor';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoesSISBOV) then begin
    Conexao := TIntImportacoesSISBOV(AOwner).Conexao;
    Mensagens := TIntImportacoesSISBOV(AOwner).Mensagens;
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
        Mensagens.Adicionar(1671, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1671;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function ValidarNirf(NumNIRF: String; CodLocalizacaoSisbov: Integer; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ValidarNirf';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoesSISBOV) then begin
    Conexao := TIntImportacoesSISBOV(AOwner).Conexao;
    Mensagens := TIntImportacoesSISBOV(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'select tp.num_imovel_receita_federal as NIRF ' +
        '     , tp.ind_efetivado_uma_vez as Efetivado ' +
        'from tab_propriedade_rural tp, ' +
        '     tab_localizacao_sisbov tls ' +
        'where tp.num_imovel_receita_federal = :num_imovel_receita_federal ' +
        '  and tp.cod_propriedade_rural = tls.cod_propriedade_rural ' +
        '  and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov ' +
        '  and tp.dta_fim_validade is null ';
      Q.ParamByName('num_imovel_receita_federal').AsString := NumNIRF;
      Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        if Q.FieldByName('Efetivado').AsString <> 'S' then
           Result := -1654
        else
           Result := 1;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1675, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1675;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function ValidarCNPJCPFProdutor(numCNPJCPF: String; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ValidarCNPJCPFProdutor';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoesSISBOV) then begin
    Conexao := TIntImportacoesSISBOV(AOwner).Conexao;
    Mensagens := TIntImportacoesSISBOV(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'select ' +
        '  tp.num_cnpj_cpf as CNPJCPF ' +
        ', tpr.ind_efetivado_uma_vez as Efetivado ' +
        'from ' +
        '  tab_pessoa tp ' +
        ', tab_produtor tpr ' +
        'where ' +
        '      tp.cod_pessoa = tpr.cod_pessoa_produtor ' +
        '  and tp.num_cnpj_cpf = :num_cnpj_cpf ' +
        '  and tp.dta_fim_validade is null ' +
        '  and tpr.dta_fim_validade is null ';
      Q.ParamByName('num_cnpj_cpf').AsString := numCNPJCPF;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        if Q.FieldByName('Efetivado').AsString <> 'S' then
           Result := -1656
        else
           Result := 1;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1671, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1671;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function ValidarCodLocalizacao(numNIRF, numCNPJCPF: String; codLocalizacao: Integer; AOwner: TObject): Integer;
const
  NomeMetodo: String = 'ValidarCodLocalizacao';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntImportacoesSISBOV) then begin
    Conexao := TIntImportacoesSISBOV(AOwner).Conexao;
    Mensagens := TIntImportacoesSISBOV(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomeMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text := ' select ' +
        '  tls.cod_localizacao_sisbov as CodLocalSISBOV ' +
        'from ' +
        '   tab_propriedade_rural tpr ' +
        ',  tab_localizacao_sisbov tls ' +
        ',  tab_pessoa tp ' +
        'where ' +
        '      tpr.cod_propriedade_rural = tls.cod_propriedade_rural ' +
        '  and tp.cod_pessoa             = tls.cod_pessoa_produtor   ' +
        '  and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov ' +
        '  and tpr.num_imovel_receita_federal = :num_imovel_receita_federal ' +
        '  and tp.num_cnpj_cpf           = :num_cnpj_cpf' +
        '  and tp.dta_fim_validade is null ';
      Q.ParamByName('num_imovel_receita_federal').AsString := Trim(numNIRF);
      Q.ParamByName('num_cnpj_cpf').AsString := Trim(numCNPJCPF);
      Q.ParamByName('cod_localizacao_sisbov').AsInteger := codLocalizacao;
      Q.Open;
      if Q.IsEmpty then
      begin
        Result := 0;
      end
      else
      begin
        Result := 1;
      end;
      Q.Close;
    except
      on E: Exception do begin
        Mensagens.Adicionar(1672, AOwner.ClassName, NomeMetodo, [E.Message]);
        Result := -1672;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function ValidaCNPJ(CNPJ: String): String;
begin
   while Length(CNPJ) < 14 do
    begin
       CNPJ := '0' + CNPJ;
    end;
   Result := CNPJ;
end;

function TIntImportacoesSISBOV.InserirArquivo( CodArquivoImportacao: Integer;
                                               NomArquivoImportacao,
                                               NomArquivoUpload: String;
                                               TipoArquivoImportacao:
                                               Integer; Txt_Dados: String;
                                               CodOrigem: Integer;
                                               SituacaoArqImport: Char ): Integer;
const
  NomeMetodo: String = 'InserirArquivoImportacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      Q.SQL.Text :=
        'insert into tab_arq_import_sisbov '+
        ' (  cod_arq_import_sisbov '+
        '  , nom_arq_upload '+
        '  , nom_arq_import_sisbov '+
        '  , dta_importacao '+
        '  , cod_usuario_upload '+
        '  , cod_tipo_origem_arq_import '+
        '  , cod_tipo_arq_import_sisbov '+
        '  , cod_situacao_arq_import '+
        '  , qtd_vezes_processamento '+
        '  , dta_ultimo_processamento ' +
        '  , txt_dados ' +
        '  , txt_mensagem ) '+

        'values '+

        ' (  :cod_arq_import_sisbov '+
        '  , :nom_arq_upload '+
        '  , :nom_arq_import_sisbov '+
{$IFDEF MSSQL}
        '  , getdate() '+
{$ENDIF}
        '  , :cod_usuario '+
        '  , :cod_tipo_origem_arq_import '+
        '  , :cod_tipo_arq_import_sisbov '+
        '  , :cod_situacao_arq_import '+
        '  , 0 '+
        '  , null '+        
        '  , :txt_dados ' +
        '  , null ) ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.ParamByName('nom_arq_upload').AsString := NomArquivoUpload;
      Q.ParamByName('nom_arq_import_sisbov').AsString := NomArquivoImportacao;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_tipo_origem_arq_import').AsInteger := CodOrigem;
      Q.ParamByName('cod_tipo_arq_import_sisbov').AsInteger := TipoArquivoImportacao;
      Q.ParamByName('cod_situacao_arq_import').AsString := SituacaoArqImport;
      Q.ParamByName('txt_dados').DataType := ftMemo;
      AtribuiValorParametro(Q.ParamByName('txt_dados'), Txt_Dados);
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

{ TThrProcessarArquivoSISBOV }

constructor TThrProcessarArquivoSISBOV.CreateTarefa(CodTarefa: Integer;
  Conexao: TConexao; Mensagens: TIntMensagens; CodArquivoImportacao: Integer);
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

procedure TThrProcessarArquivoSISBOV.Execute;
var
  ImportacoesSISBOV :TIntImportacoesSISBOV;
begin
  ImportacoesSISBOV := TIntImportacoesSISBOV.Create;
  try
    ImportacoesSISBOV.Inicializar(Conexao, Mensagens);
    ImportacoesSISBOV.Thread := Self;
    ReturnValue := ImportacoesSISBOV.ProcessarInt(FCodArquivoImportacao);
  finally
    ImportacoesSISBOV.Free;
  end;
end;

function TThrProcessarArquivoSISBOV.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

{Obtem a partir de uma String o código SISBOV.

Parametros:
  StrCodigo: String, com o código SISBOV
  CodPaisSISBOV: Integer, Pais SISBOV obtido da String
  CodEstadoSISBOV: Integer, Estado SISBOV obtido da String
  CodMicroRegiaoSISBOV: Integer, Micro Região SISBOV obtido da String
  CodAnimalSISBOV: Integer, Código SISBOV obtido da String
  NumDVSisbov: Integer, Digito Verificador do código SISBOV obtido da String

Retorno:
  Nenhum.

Exception:
  Exception caso ocorra algum erro.}
procedure TIntImportacoesSISBOV.ObtemCodigoSISBOV(StrCodigo: String;
  var CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV, NumDVSisbov: Integer);
begin
  CodPaisSISBOV := -1;
  CodEstadoSISBOV := -1;
  CodMicroRegiaoSISBOV := -1;
  CodAnimalSISBOV := -1;
  NumDVSisbov := -1;

  CodPaisSISBOV := 105;

  if StrCodigo[1] = ' ' then
  begin
    CodEstadoSISBOV := StrToInt(Copy(StrCodigo, 2, 2));
    CodMicroRegiaoSISBOV := StrToInt(Copy(StrCodigo, 4, 2));
  end
  else
  begin
    CodEstadoSISBOV := StrToInt(Copy(StrCodigo, 4, 2));
  end;

  CodAnimalSISBOV := StrToInt(Copy(StrCodigo, 6, 9));
  NumDVSisbov := StrToInt(Copy(StrCodigo, 15, 1));
end;

procedure TIntImportacoesSISBOV.InsereAutenticacao(CodArqImportSISBOV,
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
  CodAnimalSISBOVFim, CodPessoaProdutor, CodPropriedadeRural: Integer);
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    Q.SQL.Text :=
      'insert into tab_arq_import_autenticacao ( ' +
      '  cod_arq_import_sisbov ' +
      '  , cod_pessoa_produtor ' +
      '  , cod_propriedade_rural ' +
      '  , cod_pais_sisbov ' +
      '  , cod_estado_sisbov ' +
      '  , cod_micro_regiao_sisbov ' +
      '  , cod_animal_sisbov_inicio ' +
      '  , cod_animal_sisbov_fim ' +
      ') values ( ' +
      '  :cod_arq_import_sisbov ' +
      '  , :cod_pessoa_produtor ' +
      '  , :cod_propriedade_rural ' +
      '  , :cod_pais_sisbov ' +
      '  , :cod_estado_sisbov ' +
      '  , :cod_micro_regiao_sisbov ' +
      '  , :cod_animal_sisbov_inicio ' +
      '  , :cod_animal_sisbov_fim ' +
      ') ';
    Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArqImportSISBOV;
    Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
    Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
    Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
    Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
    Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
    Q.ParamByName('cod_animal_sisbov_inicio').AsInteger := CodAnimalSISBOVInicio;
    Q.ParamByName('cod_animal_sisbov_fim').AsInteger := CodAnimalSISBOVFim;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TIntImportacoesSISBOV.Processar(
  CodArquivoImportacao: Integer): Integer;
const
  Metodo: Integer = 487;
  NomeMetodo: String = 'Processar';
  CodTipoTarefa: Integer = 3;
var
  Q: THerdomQuery;
  CodTipoArqImportSisbov: Integer;
begin
  Result := -1;
  CodTipoArqImportSisbov:=1;
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
      // Consiste existência do arquivo informado, obtendo a qtd de linhas do mesmo
      Q.Close;
      Q.SQL.Text :=
        'select ' +
        '  tais.qtd_linhas as NumLinhas ' +
        '  , tais.cod_tipo_origem_arq_import as CodTipoOrigemArqImport ' +
        '  , tais.cod_situacao_arq_import as CodSituacaoArqImport ' +
        '  , tais.cod_tipo_arq_import_sisbov as CodTipoArqImportSISBOV '+
        'from ' +
        '  tab_arq_import_sisbov tais ' +
        'where ' +
        '  tais.cod_arq_import_sisbov = :cod_arq_import_sisbov ';
      Q.ParamByName('cod_arq_import_sisbov').AsInteger := CodArquivoImportacao;
      Q.Open;
      if Q.IsEmpty or (Q.FieldByName('NumLinhas').AsInteger = 0) or (Q.FieldByName('CodSituacaoArqImport').AsString = 'I') then begin
        Mensagens.Adicionar(1343, Self.ClassName, NomeMetodo, []);
        Result := -1343;
        Exit;
      end;

      //Obtem o tipo do arquivo de importação SISBOV (se é autenticação ou solicitaçã)..
      CodTipoArqImportSisbov := Q.FieldByName('CodTipoArqImportSISBOV').AsInteger;

      // Verifica se o arquivo se se encontra na lista de tarefas para processamento
      Result := VerificarAgendamentoTarefa(CodTipoTarefa, [CodArquivoImportacao]);
      if Result <= 0 then begin
        if Result = 0 then begin
          Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
          Result := -1344;
        end;
        Exit;
      end;

      // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
      Result := SolicitarAgendamentoTarefa(
        CodTipoTarefa, [CodArquivoImportacao], DtaSistema);

      // Trata o resultado da solicitação, gerando mensagem se bem sucedido
      if Result >= 0 then begin
        Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
      end;
    except
      on E: Exception do begin
        Conexao.Rollback;  // desfaz transação se houver uma ativa
        if CodTipoArqImportSisbov = 1 then begin
          Mensagens.Adicionar(1592, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -1592;
        end else begin
          Mensagens.Adicionar(2007, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -2007;
        end;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TIntImportacoesSISBOV.PrepararLinha(Relatorio: TRelatorioPadrao);
const
  CodSISBOVInicioFormatado: String = 'CodSISBOVInicioFormatado';
  CodSISBOVFimFormatado: String = 'CodSISBOVFimFormatado';
var
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio,
    CodAnimalSISBOVFim, NumDvSISBOVInicio, NumDvSISBOVFim: Integer;
begin
  CodPaisSISBOV := Query.FieldByName('cod_pais_sisbov').AsInteger;
  CodEstadoSISBOV := Query.FieldByName('cod_estado_sisbov').AsInteger;
  CodMicroRegiaoSISBOV := Query.FieldByName('cod_micro_regiao_sisbov').AsInteger;
  CodAnimalSISBOVInicio := Query.FieldByName('cod_animal_sisbov_inicio').AsInteger;
  CodAnimalSISBOVFim := Query.FieldByName('cod_animal_sisbov_fim').AsInteger;

  NumDvSISBOVInicio := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVInicio);
  NumDvSISBOVFim := BuscarDVSisBov(CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOVFim);

  Relatorio.Campos.CarregarValores(Query);
  Relatorio.Campos.ValorCampo[CodSISBOVInicioFormatado] :=
    FormataCodigoSISBOV( CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOVInicio, NumDvSISBOVInicio);
  Relatorio.Campos.ValorCampo[CodSISBOVFimFormatado] :=
    FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOVFim, NumDvSISBOVFim);
end;

function TIntImportacoesSISBOV.PesquisarRelatorioAutenticacao(
  NumCNPJCPFProdutor, NomPessoaProdutor, SglProdutor,
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NomPropriedadeRural: String;
  CodEstado: Integer; NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV: Integer): Integer;
const
  NomeMetodo: String = 'PesquisarRelatorioAutenticacao';
  CodRelatorio: Integer = 27;
var
  bCodigoSISBOV: Boolean;
  sOrderBy, sNomCampo: String;
  IntRelatorios: TIntRelatorios;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Text :=
      'select ' +
{$IFDEF MSSQL}
      '  case tp.cod_natureza_pessoa ' +
      '    when ''F'' then convert(varchar(18), ' +
      '      substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '      substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '    when ''J'' then convert(varchar(18), ' +
      '      substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '      substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '      substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '      substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '  end as NumCNPJCPFFormatadoProdutor ' +
{$ENDIF}
      '  , tp.nom_pessoa as NomPessoaProdutor ' +
      '  , tp.nom_reduzido_pessoa as NomReduzidoPessoaProdutor ' +
      '  , tr.sgl_produtor as SglProdutor ' +
      '  , tpr.num_imovel_receita_federal as NumImovelReceitaFederal ' +
      '  , tpr.nom_propriedade_rural as NomPropriedadeRural ' +
      '  , tm.nom_municipio as NomMunicipioPropriedadeRural ' +
      '  , te.nom_estado as NomEstadoPropriedadeRural ' +
      '  , te.sgl_estado as SglEstadoPropriedadeRural ' +
      '  , tais.nom_arq_upload as NomArqUpload ' +
      '  , tais.dta_importacao as DtaImportacao ' +
      '  , tais.cod_situacao_arq_import as CodSituacaoArqImport ' +
      '  , tsai.des_situacao_arq_import as DesSituacaoArqImport ' +
      '  , taia.cod_animal_sisbov_fim - taia.cod_animal_sisbov_inicio + 1 as QtdCodigos ' +
      '  , taia.cod_pais_sisbov ' +
      '  , taia.cod_estado_sisbov ' +
      '  , taia.cod_micro_regiao_sisbov ' +
      '  , taia.cod_animal_sisbov_inicio ' +
      '  , taia.cod_animal_sisbov_fim ' +
      '  , tls.cod_localizacao_sisbov ' +      
{$IFDEF MSSQL}
      '  , cast(null as varchar(18)) as CodSISBOVInicioFormatado ' +
      '  , cast(null as varchar(18)) as CodSISBOVFimFormatado ' +
      '  , tls.cod_localizacao_sisbov as CodLocalizacaoSisbov ' +
{$ENDIF}
      'from ' +
      '  tab_arq_import_autenticacao taia ' +
{$IFDEF MSSQL}
      '  inner join tab_produtor tr on tr.cod_pessoa_produtor = taia.cod_pessoa_produtor ' +
      '  inner join tab_pessoa tp on tp.cod_pessoa = taia.cod_pessoa_produtor ' +
      '  inner join tab_propriedade_rural tpr on tpr.cod_propriedade_rural = taia.cod_propriedade_rural ' +
      '  inner join tab_arq_import_sisbov tais on tais.cod_arq_import_sisbov = taia.cod_arq_import_sisbov ' +
      '  inner join tab_situacao_arq_import tsai on tsai.cod_situacao_arq_import = tais.cod_situacao_arq_import ' +
      '  inner join tab_localizacao_sisbov tls on tpr.cod_propriedade_rural = tls.cod_propriedade_rural and tp.cod_pessoa = tls.cod_pessoa_produtor ' + 
      '  left outer join tab_municipio tm on tm.cod_municipio = tpr.cod_municipio ' +
      '  left outer join tab_estado te on te.cod_estado = tpr.cod_estado ' +
{$ENDIF}
      'where ' +
      '  1 = 1 ';

    if NumCNPJCPFProdutor <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tp.num_cnpj_cpf = :num_cnpj_cpf ';
      Query.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPFProdutor;
    end;
    if NomPessoaProdutor <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tp.nom_pessoa like :nom_pessoa ';
      Query.ParamByName('nom_pessoa').AsString := '%' + NomPessoaProdutor + '%';
    end;
    if SglProdutor <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tr.sgl_produtor = :sgl_produtor ';
      Query.ParamByName('sgl_produtor').AsString := SglProdutor;
    end;
    if NumImovelReceitaFederal <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tpr.num_imovel_receita_federal = :num_imovel_receita_federal ';
      Query.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
    end;
    if CodLocalizacaoSisbov > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov ';
      Query.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
    end;
    if NomPropriedadeRural <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tpr.nom_propriedade_rural like :nom_propriedade_rural ';
      Query.ParamByName('nom_propriedade_rural').AsString := '%' + NomPropriedadeRural + '%';
    end;
    if CodEstado <> -1 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tpr.cod_estado = :cod_estado ';
      Query.ParamByName('cod_estado').AsInteger := CodEstado;
    end;
    if NomArqUpload <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tais.nom_arq_upload like :nom_arq_upload ';
      Query.ParamByName('nom_arq_upload').AsString := '%' + NomArqUpload + '%';
    end;
    if (DtaImportacaoInicio > 0) and (DtaImportacaoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tais.dta_importacao >= :dta_importacao_inicio ' +
        '  and tais.dta_importacao < :dta_importacao_fim' ;
      Query.ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
      Query.ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim) + 1;
    end;
    if (CodAnimalSISBOV <> -1) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and taia.cod_pais_sisbov = :cod_pais_sisbov ' +
        '  and taia.cod_estado_sisbov = :cod_estado_sisbov ' +
        '  and taia.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '  and :cod_animal_sisbov between taia.cod_animal_sisbov_inicio and taia.cod_animal_sisbov_fim ';
      Query.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSISBOV;
      Query.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSISBOV;
      Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSISBOV;
      Query.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSISBOV;
    end;

    sOrderBy := '';
    IntRelatorios := TIntRelatorios.Create;
    try
      Result := IntRelatorios.Inicializar(Conexao, Mensagens);
      if Result < 0 then Exit;
      Result := IntRelatorios.Buscar(CodRelatorio);
      if Result < 0 then Exit;
      Result := IntRelatorios.Pesquisar(CodRelatorio);
      if Result < 0 then Exit;
      bCodigoSISBOV := False;
      IntRelatorios.IrAoPrimeiro;
      while not IntRelatorios.EOF do begin
        sNomCampo := IntRelatorios.ValorCampo('NomField');
        if sNomCampo = 'CodSISBOVInicioFormatado' then begin
          if bCodigoSISBOV then begin
            sNomCampo := 'taia.cod_animal_sisbov_inicio';
          end else begin
            sNomCampo := 'taia.cod_pais_sisbov, taia.cod_estado_sisbov, taia.cod_micro_regiao_sisbov, taia.cod_animal_sisbov_inicio';
            bCodigoSISBOV := True;
          end;
        end else if sNomCampo = 'CodSISBOVFimFormatado' then begin
          if bCodigoSISBOV then begin
            sNomCampo := 'taia.cod_animal_sisbov_fim';
          end else begin
            sNomCampo := 'taia.cod_pais_sisbov, taia.cod_estado_sisbov, taia.cod_micro_regiao_sisbov, taia.cod_animal_sisbov_fim';
            bCodigoSISBOV := True;
          end;
        end;
        if (IntRelatorios.IntRelatorio.IndPersonalizavel <> 'S')
          or (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S')
          or (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S') then begin
          if sOrderBy = '' then begin
            sOrderBy := sNomCampo;
          end else begin
            sOrderBy := sOrderBy + ', ' + sNomCampo;
          end;
        end;
        IntRelatorios.IrAoProximo;
      end;
      if sOrderBy <> '' then begin
        sOrderBy := 'order by ' + sOrderBy
      end;
    finally
      IntRelatorios.Free;
    end;
    Query.SQL.Text := Query.SQL.Text + sOrderBy;
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Mensagens.Adicionar(1959, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1959;
      Exit;
    end;
  end;
end;

function TIntImportacoesSISBOV.GerarRelatorioAutenticacao(
  NumCNPJCPFProdutor, NomPessoaProdutor, SglProdutor,
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; NomPropriedadeRural: String; CodEstado: Integer;
  NomArqUpload: String; DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodAnimalSISBOV, Tipo: Integer): String;
const
  Metodo: Integer = 591;
  NomeMetodo: String = 'GerarRelatorioAutenticacao';
  CodRelatorio: Integer = 27;
var
  Relatorio: TRelatorioPadrao;
  Retorno: Integer;
begin
  Result := '';
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  Retorno := PesquisarRelatorioAutenticacao(NumCNPJCPFProdutor,
    NomPessoaProdutor, SglProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov,
    NomPropriedadeRural, CodEstado, NomArqUpload, DtaImportacaoInicio,
    DtaImportacaoFim, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOV);
  if Retorno < 0 then Exit;

  if Query.IsEmpty then begin
    Mensagens.Adicionar(1162, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  try
    Relatorio := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
    try
      Relatorio.TipoDoArquvio := Tipo;
      Retorno := Relatorio.InicializarRelatorio(CodRelatorio);
      if Retorno < 0 then Exit;
      Query.First;
      while not EOF do begin
        PrepararLinha(Relatorio);
        Relatorio.ImprimirColunas;
        Query.Next;
      end;
      if Relatorio.LinhasRestantes < 2 then begin
        Relatorio.NovaPagina;
      end else begin
        Relatorio.NovaLinha;
      end;
      Retorno := Relatorio.FinalizarRelatorio;
      if Retorno = 0 then begin
        Result := Relatorio.NomeArquivo;
      end;
    finally
      Relatorio.Free;
    end;
  except
    on E: Exception do begin
      Mensagens.Adicionar(1960, Self.ClassName, NomeMetodo, [E.Message]);
      Exit;
    end;
  end;
end;

end.


