unit uIntBoletosBancario;

interface

uses SysUtils, Classes,
     uIntClassesBasicas, uConexao, uIntBoletoBancario, uColecoes, uIntOrdensServico,
     uIntenderecos, uLibZipM, uFerramentas, uIntMensagens, uArquivo;

type

  TInfoBoleto = record
    NumParcelaCorrente:    Integer;
    ValorParcelaCorrente:  Currency;
    DtaVencimentoCorrente: TDateTime
  end;

  TDadosArquivo = record
    CodTipoArquivoRemessa: Integer;
    TxtPrefixoArquivo:     String;
    NomArquivoZIP:         String;
    NomArquivoRemessa:     String;
    Caminho:               String;
  end;

  TMudancaSituacao = record
    CodSituacaoOrigemBoleto:  Integer;
    CodSituacaoDestinoBoleto: Integer;
    IndAtualizaSituacao:      String;
    TxtMensagemLog:           String;
  end;

  TTipo = record
    CodTipoLinha: Integer;
    QtdLidas: Integer;
    QtdErradas: Integer;
    QtdProcessadas: Integer;
  end;

  { TProcessamento }
  TProcessamento = class(TIntClasseBDNavegacaoBasica)
  private
    FCodArquivoImportacao: Integer;
  public
    constructor Create; override;
    function IncLidas(CodTipoLinhaImportacao: Integer): Integer;
    function IncErradas(CodTipoLinhaImportacao: Integer): Integer;
    function IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;

    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
  end;

  { TArmazenamento }
  TArmazenamento = class(TIntClasseBDNavegacaoBasica)
  private
    FTipos: Array of TTipo;
    FCodArquivoImportacao: Integer;
    function GetQtdLinhasLidas(TipoLinhaImportacao: Integer): Integer;
  public
    constructor Create; override;
    procedure IncLidas(CodTipoLinhaImportacao: Integer);
    function Salvar: Integer;

    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
    property QtdLinhasLidas[TipoLinhaImportacao: Integer]: Integer read GetQtdLinhasLidas;
  end;

  { TThrProcessarArquivo }
  TThrProcessarArquivoBoleto = class(TThread)
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

  TIntBoletosBancario = Class(TIntClasseBDNavegacaoBasica)
    private
      FIntBoletoBancario: TIntBoletoBancario;
      FIntenderecos:      TIntenderecos;
      FThread: TThrProcessarArquivoBoleto;

      function ObterDadosCertificadora(var ENomCertificadora,
                                       ENumCNPJCertificadora: String;
                                       AOwner: TObject): Integer;

      function VerificaParametroMultiValorData(strOriginal: String; var strSaida: TStringList): Integer;

      function ProximoNumeroBoletoBancario(var EValProximoNumBoletoBancario: Integer): Integer;

      function ProximoNumeroArquivoRemessa(ECodIdentificacaoBancaria: Integer; var EValProximoArquivoRemessa: Integer): Integer;

      function ObterCodArquivoImportacao(var ECodArquivoImportacao: Integer): Integer;

      function BuscarTituloAceito(ECodIdentificacaoBancaria: Integer; var ECodTituloAceito: String): Integer;

      function BuscarCodigoPrioridadeSituacao(ECodSituacaoBoleto: Integer;
                                              var ECodPrioridadeSituacao: Integer): Integer;

      function InserirHistoricoMudancaSituacao(ECodBoleto, ENumParcela, ECodSituacaoBoleto: Integer;
                                               ETxtObservacao: String): Integer;

      function InserirArquivoRemessaBoleto(ECodArquivoRemessaBoleto,
                                           ECodTipoArquivoRemessaBoleto: Integer;
                                           ENomArquivo: String;
                                           EQtdBytesArquivo: Integer;
                                           EIndPossuiLogErro: String): Integer;

      function InserirErroRemessaBoleto(ECodArquivoRemessaBoleto: Integer;
                                        ETxtMensagemErro: String): Integer;

      function ValidaDadosRemessaBoleto(EQuery: THerdomQuery;
                                        var ETxtMensagens: TStringList): Integer;

      function VerificaMudancaSituacao(var EMudancaSituacao: TMudancaSituacao): Integer;

      function ProcessarArquivoRetornoInt(ECodArquivoImportacao: Integer): Integer;

      function InserirArquivoUpLoad(ECodArquivoImportacao: Integer; ENomArquivoImportacao,
                                    ENomArquivoUpload: String; ETxtDados: String;
                                    ESituacaoArqImport: Char): Integer;

      procedure LimparAtributos();

    public
      constructor Create; override;
      destructor Destroy; override;
      function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;

      function Inserir(ECodIdentificacaoBancaria, ECodOrdemServico,
                       ECodenderecoCobranca, EQtdParcelas: Integer;
                       var EValUnitarioVendedor, EValUnitarioTecnico,
                       EValUnitarioCertificadora, EValVistoria: Double;
                       EDtaVencimentoBoleto: String; ETxtMensagem3,
                       ETxtMensagem4: String;
                       ECodFormaPagamentoBoleto: Integer): Integer;

      function Alterar(CodBoleto, NumParcela, CodenderecoCobranca: Integer;
                       DtaVencimentoBoleto: TDateTime; TxtMensagem3,
                       TxtMensagem4: String): Integer;

      function MudarSituacao(CodBoleto, NumParcela, CodSituacaoDestino: Integer;
                             TxtObservacao: String): Integer;

      function Pesquisar(CodOrdemServico: Integer): Integer;

      function PesquisarRemessa(CodArquivoRemessa, CodTipoArquivoRemessa: Integer;
                                DtaCriacaoArquivoInicial, DtaCriacaoArquivoFinal: TDateTime;
                                IndPossuiLogErro: String): Integer;

      function PesquisarErroRemessa(ECodArquivoRemessa: Integer): Integer;

      function PesquisarTipoArquivoRemessa(): Integer;

      function PesquisarSituacaoBoleto(ECodSituacaoBoleto: Integer; EIndOrdenacao: String): Integer;

      function PesquisarImportacaoBoleto(ECodSituacaoArquivo, ENomArquivoUpLoad,
                                         ENomUsuario: String; EDtaImportacaoInicio,
                                         EDtaImportacaoFim, EDtaProcessamentoInicio,
                                         EDtaProcessamentoFim: TDateTime): Integer;

      function PesquisarHistoricoMudancaSituacao(ECodBoletoBancario,
                                                 ENumParcela: Integer): Integer;

      function PesquisarErrosImportacao(ECodArquivoImportacao: Integer): Integer;

      function Buscar(ECodBoletoBancario, ENumParcela: Integer): Integer;

      function BuscarArquivoImportacao(ECodArquivoImportacao: Integer): Integer;

      function DefinirenderecoCobrancaBoleto(ECodTipoendereco: Integer;
                                             ENomLogradouro,
                                             ENomBairro,
                                             ENumCEP: WideString;
                                             ECodDistrito,
                                             ECodMunicipio: Integer;
                                             ENomLocalidade: WideString;
                                             ECodEstado: Integer): Integer;

      function DefinirenderecoCobrancaOS(ECodOrdemServico: Integer): Integer;

      function ValidarCertificadora(ENumCNPJ: String; AOwner: TObject): Integer;

      function ArmazenarArquivoUpLoad(ENomArquivoUpload: String): Integer;

      function GerarArquivoRemessa(): Integer;

      function ProcessarArquivoRetorno(ECodArquivoImportacao: Integer): Integer;

      function GerarRelatorioFichaBoletos(ECodBoleto, ENumParcela,
                                          ECodTipoArquivo: Integer): String;

      function PesquisarFormaPagamentoBoleto(ECodFormaPagamentoBoleto: Integer): Integer;

      property IntBoletoBancario: TIntBoletoBancario read FIntBoletoBancario write FIntBoletoBancario;
      property Thread: TThrProcessarArquivoBoleto read FThread write FThread;
  end;

  procedure InterpretaLinhaArquivoRetorno(Owner: TArquivoPosicionalLeitura);

implementation

uses DB, SqlExpr, uIntendereco;

{ TIntBoletosBancario }

{* Função responsável por alterar um boleto bancário. A alteração somente poderá
   ser realizada caso a situação do boleto seja 1.

   @param CodBoleto Inteiro Código do boleto bancário a ser alterado.
   @param NumParcela Inteiro Número da parcela referente ao boleto informado no
                             parâmetro anterior (CodBoleto) que deverá ser
                             alterado.
   @param CodenderecoCobranca Inteiro endereco de cobrança
   @param DtaVencimentoBoleto Data de vencimento do boleto bancário
   @param TxtMensagem3 String Mensagem 1
   @param TxtMensagem4 String Mensagem 2

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return -188  Valor retornado quando o usuário logado no sistema não possuir
                 permissão de acesso para executar o método.
   @return -2126 Valor retornado quando o boleto informado no parãmetro CodBoleto
                 não for encontrado no banco de dados.
   @return -2135 Valor retornado quando a situação do boleto bancário informado
                 for uma situação diferente da situação "1".
   @return -2127 Valor retornado quando o endereço informado no parâmetro
                 CodenderecoCobranca, não for encontrado na base de dados.
   @return -2128 Valor retornado quando o tamanho do campo logradouro de cobrança,
                 for maior do que 40 caracteres.
   @return -2129 Valor retornado quando o tamanho do campo CEP de cobrança, for
                 maior do que 15 caracteres.
   @return -2122 Valor retornado quando a data de vencimento informada pelo
                 parâmetro, DtaVencimentoBoleto for menor do que a Data atual do
                 sistema.
   @return -2137 Valor retornado quando a data de uma parcela anterior a parcela
                 a ser alterada, for maior do que a data atual do sistema.
   @return -2138 Valor retornado quando a data de uma parcela posterior a parcela
                 a ser alterada, for menor do que a data atual do sistema.
   @return -2139 Valor retornado quando ocorrer alguma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.Alterar(CodBoleto, NumParcela, CodenderecoCobranca: Integer;
  DtaVencimentoBoleto: TDateTime; TxtMensagem3, TxtMensagem4: String): Integer;
const
  NomMetodo: String  = 'Alterar';
  CodMetodo: Integer = 622;
  CodSituacaoNaoEnviado: Integer = 1;
var
  Qry: THerdomQuery;
  CodOrdemServico: Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se o boleto bancário existe e se a situação do boleto é 1 para
      // que o mesmo possa sofrer alterações
      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_situacao_boleto, cod_ordem_servico from tab_boleto');
      Qry.SQL.Add(' where cod_boleto = :cod_boleto');
      Qry.SQL.Add('   and num_parcela = :num_parcela');      
      Qry.ParamByName('cod_boleto').AsInteger := CodBoleto;
      Qry.ParamByName('num_parcela').AsInteger := NumParcela;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2126, Self.ClassName, NomMetodo, []);
        Result := -2126;
        Exit;
      end;

      CodOrdemServico := Qry.FieldByName('cod_ordem_servico').AsInteger;

      if Qry.FieldByName('cod_situacao_boleto').AsInteger <> CodSituacaoNaoEnviado then
      begin
        Mensagens.Adicionar(2135, Self.ClassName, NomMetodo, []);
        Result := -2135;
        Exit;
      end;

      // Verifica se o endereço informado é válido.
      // Valida o tamanho dos campos logradouro e bairro
      if CodenderecoCobranca > 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select te.nom_logradouro, te.nom_bairro from tab_endereco te');
        Qry.SQL.Add(' where te.cod_endereco = :cod_endereco');
        Qry.ParamByName('cod_endereco').AsInteger := CodenderecoCobranca;
        Qry.Open;
        if Qry.IsEmpty then
        begin
          Mensagens.Adicionar(2127, Self.ClassName, NomMetodo, []);
          Result := -2127;
          Exit;
        end
        else
        begin
          if Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) > 40 then
          begin
            Mensagens.Adicionar(2128, Self.ClassName, NomMetodo, [Qry.FieldByName('nom_logradouro').AsString]);
            Result := -2128;
            Exit;
          end;
          if Length(Trim(Qry.FieldByName('nom_bairro').AsString)) > 15 then
          begin
            Mensagens.Adicionar(2129, Self.ClassName, NomMetodo, [Qry.FieldByName('nom_bairro').AsString]);
            Result := -2129;
            Exit;
          end;
        end;
      end;

      // Valida a data de Vencimento do boleto bancário
      if DtaVencimentoBoleto < Date then
      begin
        Mensagens.Adicionar(2122, Self.ClassName, NomMetodo, [DateToStr(DtaVencimentoBoleto)]);
        Result := -2122;
        Exit;
      end;

      Qry.SQL.Clear;
      Qry.SQL.Add('select num_parcela, dta_vencimento_boleto from tab_boleto');
      Qry.SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
      Qry.SQL.Add('   and cod_situacao_boleto <> 99');      
      Qry.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
      Qry.Open;
      while not Qry.Eof do
      begin
        if Qry.FieldByName('num_parcela').AsInteger < NumParcela then
        begin
          if Qry.FieldByName('dta_vencimento_boleto').AsDateTime >= DtaVencimentoBoleto then
          begin
            Mensagens.Adicionar(2137, Self.ClassName, NomMetodo, [IntToStr(NumParcela), DateToStr(DtaVencimentoBoleto)]);
            Result := -2137;
            Exit;
          end;
        end;
        if Qry.FieldByName('num_parcela').AsInteger > NumParcela then
        begin
          if Qry.FieldByName('dta_vencimento_boleto').AsDateTime <= DtaVencimentoBoleto then
          begin
            Mensagens.Adicionar(2138, Self.ClassName, NomMetodo, [IntToStr(NumParcela), DateToStr(DtaVencimentoBoleto)]);
            Result := -2138;
            Exit;
          end;
        end;
        Qry.Next;
      end;

      beginTran;
      Qry.SQL.Add(' update tab_boleto ' +
                  '    set dta_vencimento_boleto = :dta_vencimento_boleto ');

      if CodenderecoCobranca > 0 then
      begin
        Qry.SQL.Add('    , cod_endereco_cobranca = :cod_endereco_cobranca ');
      end;

      Qry.SQL.Add('      , dta_ultima_alteracao         = getdate() ' +
                  '      , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao ' +
                  '      , txt_mensagem_3               = :txt_mensagem_3 ' +
                  '      , txt_mensagem_4               = :txt_mensagem_4 ' +
                  '  where cod_boleto                   = :cod_boleto ' +
                  '    and num_parcela                  = :num_parcela ');

      Qry.ParamByName('dta_vencimento_boleto').AsDateTime := DtaVencimentoBoleto;
      if CodenderecoCobranca > 0 then
      begin
        Qry.ParamByName('cod_endereco_cobranca').AsInteger  := CodenderecoCobranca;
      end;
      Qry.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
      Qry.ParamByName('txt_mensagem_3').AsString                := TxtMensagem3;
      Qry.ParamByName('txt_mensagem_4').AsString                := TxtMensagem4;
      Qry.ParamByName('cod_boleto').AsInteger                   := CodBoleto;
      Qry.ParamByName('num_parcela').AsInteger                  := NumParcela;
      Qry.ExecSQL;
      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2139, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2139;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

{* Função responsável por gravar as informações do arquivo importado para o sistema
   além de realizar uma cópia do arquivo em questão, para o diretório importação.

   @Param ENomArquivoUload String Nome do arquivo que se encontra no diretório
                                  arq_upload, e que será interpretado pelo método.

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return 1267  Valor retornado caso já exista um arquivo importado para a base
                 de dados, com o mesmo nome (nome de upload).

   @return -188  Valor retornado quando o usuário logado no sistema não possuir
                 permissão de acesso para executar o método.
   @return -1122 Valor retornado quando o diretório de origem dos arquivos não
                 existir.
   @return -1123 Valor retornado quando o arquivo não existir no caminho
                 informado.
   @return -1223 Valor retornado caso o arquivo não pertença a certificadora.
   @return -1217 Valor retornado caso ocorra alguma falha na tentativa de criação
                 do diretório de destino, caso o mesmo não exista.
   @return -1218 Valor retornado caso ocorra alguma exceção durante a execução
                 do método.
   @return -1219 Valor retornado caso ocorra alguma falha ao inicializar a leitura
                 do arquivo a ser importado.
   @return -1360 Valor retornado quando ocorrer algum erro ao tentar abrir o
                 arquivo ZIP.
   @return -1361 Valor retornado quando ocorrer algum erro ao obter o número de
                 arquivos dentro do arquivo ZIP.
                 Valor retornado quando ocorrer algum erro ao tentar extrair o
                 arquivo de dentro do arquivo ZIP.
   @return -1362 Valor retornado quando o número de arquivos dentro do arquivo
                 ZIP for maior do que um.
}
function TIntBoletosBancario.ArmazenarArquivoUpLoad(ENomArquivoUpload: String): Integer;
const
  NomMetodo: String  = 'ArmazenarArquivoUpLoad';
  CodMetodo: Integer = 635;

  // Obtido no registro tipo 0
  ccNumCNPJCPFCertificadora: Integer = 6;

  // Obtido no registro tipo 3 segmento T
  ccIdentTituloEmpresa:      Integer = 11;

  // Obtido no registro tipo 3 segmento U
  ccCodMovimento:            Integer = 6;
  ccValPagoSacado:           Integer = 11;
  ccDtaEfetivacaoCredito:    Integer = 16;
var
  Q: THerdomQuery;
  ArquivoUpload: TArquivoPosicionalLeitura;
  ArquivoImportacao: TArquivoPosicionalEscrita;
  Armazenamento: TArmazenamento;
  ArquivoZip: unzFile;
  sOrigem, sDestino, sAux, MsgErro,
  PrefixoNomeArquivo, sNomArquivoUploadOriginal: String;
  CodArquivoImportacao: Integer;
  SitArqImport: Char;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  // Armazena o nome original do arquivo de upload
  sNomArquivoUploadOriginal := ENomArquivoUpload;

  // Recupera pasta temporária de armazenamento
  sOrigem := ValorParametro(21);

  if (Length(sOrigem) = 0) or (sOrigem[Length(sOrigem)] <> '\') then
  begin
    sOrigem := sOrigem + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(sOrigem) then
  begin
    Mensagens.Adicionar(1122, Self.ClassName, NomMetodo, []);
    Result := -1122;
    Exit;
  end;

  // Consiste existência do arquivo informado
  if not FileExists(sOrigem + ENomArquivoUpload) then
  begin
    Mensagens.Adicionar(1123, Self.ClassName, NomMetodo, []);
    Result := -1123;
    Exit;
  end;

  // Verifica se o arquivo de upload está compactado
  if UpperCase(ExtractFileExt(ENomArquivoUpload)) = '.ZIP' then
  begin
    // Tentar abrir o arquivo ZIP
    Result := AbrirUnZip(sOrigem + ENomArquivoUpload, ArquivoZip);
    if Result < 0 then
    begin
      Mensagens.Adicionar(1360, Self.ClassName, NomMetodo, [ENomArquivoUpload]);
      DeleteFile(sOrigem + ENomArquivoUpload);
      Result := -1360;
      Exit;
    end;

    // Consiste o número de arquivo dentro do Arquivo ZIP
    Result := NumArquivosDoUnZip(ArquivoZip);
    if Result < 0 then
    begin
      Mensagens.Adicionar(1361, Self.ClassName, NomMetodo, [ENomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem + ENomArquivoUpload);
      Result := -1361;
      Exit;
    end
    else
    if Result > 1 then
    begin
      Mensagens.Adicionar(1362, Self.ClassName, NomMetodo, [ENomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem + ENomArquivoUpload);
      Result := -1362;
      Exit;
    end;

    // Obtem o nome do primeiro arquivo (teoricamente deve ser o último)
    sAux := NomeArquivoCorrenteDoUnzip(ArquivoZip);

    // Extrai o arquivo compactado
    Result := ExtrairArquivoDoUnZip(ArquivoZip, sAux, sOrigem);
    if Result <> 0 then
    begin
      Mensagens.Adicionar(1361, Self.ClassName, NomMetodo, [ENomArquivoUpload]);
      FecharUnZip(ArquivoZip);
      DeleteFile(sOrigem + ENomArquivoUpload);
      if (Result = -5) or (Result = -6) then
      begin
        DeleteFile(sOrigem+sAux);
      end;
      Result := -1361;
      Exit;
    end;

    // Fechar arquivo ZIP
    FecharUnZip(ArquivoZip);

    // Apaga arquivo compactado
    DeleteFile(sOrigem + ENomArquivoUpload);
    ENomArquivoUpload := ExtractFileName(sAux);
  end;

  // Define caminho e arquivo completo da origem
  sOrigem := sOrigem + ENomArquivoUpload;

  PrefixoNomeArquivo := 'RBO';

  sDestino := ValorParametro(38);
  if (Length(sDestino) = 0) or (sDestino[Length(sDestino)] <> '\') then
  begin
    sDestino := sDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then
  begin
    if not ForceDirectories(sDestino) then
    begin
      // Remove o arquivo temporário de imagem da pasta temporária
      DeleteFile(sOrigem);
      // Gera Mensagem erro informando o problema ao usuário
      Mensagens.Adicionar(1217, Self.ClassName, NomMetodo, []);
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
          ArquivoUpload.RotinaLeitura := InterpretaLinhaArquivoRetorno;

          Result := ArquivoUpload.Inicializar;
          if Result < 0 then
          begin
            // Trata possíveis erros durante a tentativa de abertura do arquivo
            if Result = EArquivoInexistente then
            begin
              Mensagens.Adicionar(1219, Self.ClassName, NomMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end
            else
            if Result = EInicializarLeitura then
            begin
              Mensagens.Adicionar(1219, Self.ClassName, NomMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1219;
            end
            else
            if Result < 0 then
            begin
              Mensagens.Adicionar(1220, Self.ClassName, NomMetodo, []);
              MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
              Result := -1220;
            end;
            // Caso o arquivo esteja inválido, um registro deve ser gerado na
            // base de dados informando o erro

            // Inicializa transação
            beginTran;
            // Armazena arquivo
            Result := InserirArquivoUpLoad(CodArquivoImportacao, sAux, ENomArquivoUpload, '', 'I');

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
          Result := ValidarCertificadora(ArquivoUpload.ValorColuna[ccNumCNPJCPFCertificadora], Self);
          if Result < 0 then
          begin
            Mensagens.Adicionar(1223, Self.ClassName, NomMetodo, []);
            MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
            Result := -1223;
            // Caso o arquivo esteja inválido, um registro deve ser gerado
            // na base de dados informando o erro
            beginTran;
            Result := InserirArquivoUpLoad(CodArquivoImportacao, sAux, ENomArquivoUpload, '', 'I');
            // Finaliza transação, garantindo atualizações realizadas
            if Result >= 0 then
            begin
              Commit;
            end;
            // Força um erro para que as devidas operações sejam realizadas
            Result := -1223;
            Exit;
          end;

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
              while (Result = 0) and not(ArquivoUpload.EOF) do
              begin
                Result := ArquivoUpload.ObterLinha; // Obtem linha do arquivo temporário
                if Result < 0 then
                begin
                  if Result = ETipoColunaDesconhecido then
                  begin
                    Result := -1234;
                  end
                  else if Result = ECampoNumericoInvalido then
                  begin
                    Result := -1235;
                  end
                  else if Result = EDelimitadorStringInvalido then
                  begin
                    Result := -1236;
                  end
                  else if Result = EDelimitadorOutroCampoInvalido then
                  begin
                    Result := -1237;
                  end
                  else if Result = EOutroCampoInvalido then
                  begin
                    Result := -1238;
                  end
                  else if Result = EDefinirTipoLinha then
                  begin
                    Result := -1239;
                  end
                  else if Result = EAdicionarColunaLeitura then
                  begin
                    Result := -1240;
                  end
                  else if Result = EFinalDeLinhaInesperado then
                  begin
                    Result := -1243;
                  end
                  else
                  begin
                    Result := -1232;
                  end;

                  Mensagens.Adicionar(-Result, Self.ClassName, NomMetodo, [IntToStr(ArquivoUpload.LinhasLidas)]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  // Caso o arquivo esteja inválido, um registro deve ser
                  // gerado na base de dados informando o erro}

                  //Inicializa transação}
                  beginTran;
                  // Armazena arquivo
                  Result := InserirArquivoUpLoad(CodArquivoImportacao, sAux, ENomArquivoUpload, '', 'I');
                  // Finaliza transação, garantindo atualizações realizadas
                  if Result >= 0 then
                    Commit;
                  // Força um erro para que as devidas operações sejam realizadas}
                  Result := -1;
                  Exit;
                end;

                // Escreve linha no arquivo definitivo
                Result := ArquivoImportacao.AdicionarLinhaTexto(ArquivoUpload.LinhaTexto);
                if Result < 0 then
                begin
                  Mensagens.Adicionar(1233, Self.ClassName, NomMetodo, [IntToStr(ArquivoUpload.LinhasLidas), sAux]);
                  MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;

                  // Caso o arquivo esteja inválido, um registro deve ser
                  // gerado na base de dados informando o erro

                  // Inicializa transação
                  beginTran;

                  // Armazena arquivo
                  Result := InserirArquivoUpLoad(CodArquivoImportacao, sAux, ENomArquivoUpload, '', 'I');
                  // Finaliza transação, garantindo atualizações realizadas
                  if Result >= 0 then
                    Commit;
                  // Força um erro para que as devidas operações sejam realizadas
                  Result := -1233;
                  Exit;
                end;
                Armazenamento.IncLidas(ArquivoUpload.TipoLinha);
              end;

              SitArqImport := 'N';
              beginTran;
              Result := InserirArquivoUpLoad(CodArquivoImportacao, sAux, ENomArquivoUpload, '', SitArqImport);
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
                Mensagens.Adicionar(1228, Self.ClassName, NomMetodo, []);
                MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
                Result := -1228;
              end;
              Commit;
            finally
              Armazenamento.Free;
            end;

            // Finaliza arquivo de UpLoad
            ArquivoUpload.Finalizar;

            // Verifica a existência de um arquivo de upload como o mesmo nome,
            // havendo gera uma mensagem}
            Q.Close;
            Q.SQL.Text :=
                         'select '+
                         '  count(1) as QtdArquivo '+
                         'from '+
                         '  tab_arq_import_boleto '+
                         'where '+
                         '  nom_arq_upload like :nom_arq_upload ';
            Q.ParamByName('nom_arq_upload').AsString := ENomArquivoUpload;
            Q.Open;

            if Q.FieldByName('QtdArquivo').AsInteger > 1 then
            begin
              Mensagens.Adicionar(1267, Self.ClassName, NomMetodo, []);
            end;
            Q.Close;

            // Identifica procedimento como bem sucedido, retornado o código do
            // arquivo inserido
            Result := CodArquivoImportacao;
          end;
        except
          on E: Exception do begin
            Rollback;
            Mensagens.Adicionar(1218, Self.ClassName, NomMetodo, [E.Message]);
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
            beginTran;
            Q.Close;
            Q.SQL.Text :=
              'update tab_arq_import_boleto '+
              'set '+
              '    cod_situacao_arq_import = :cod_situacao_arq_import '+
              '  , txt_mensagem = :txt_mensagem ' +
              'where '+
              '    cod_arq_import_boleto = :cod_arq_import_boleto ';
            Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
            Q.ParamByName('cod_arq_import_boleto').AsInteger := CodArquivoImportacao;
            Q.ParamByName('txt_mensagem').AsString := msgErro;
            Q.ExecSQL;
            {Finaliza transação, garantindo atualizações realizadas}
            Commit;
          except
             on E: Exception do
              begin
                 Rollback;
                 Mensagens.Adicionar(1218, Self.ClassName, NomMetodo, [E.Message]);
                 Result := -1218;
              end;
          end;

          if FileExists(sDestino) then
          begin
            {Tenta excluir o arquivo de importação gerado}
            if not DeleteFile(sDestino) then
            begin
              try
                beginTran;
                Q.Close;
                Q.SQL.Text :=
                             'update tab_arq_import_boleto '+
                             'set '+
                             '  cod_situacao_arq_import = :cod_situacao_arq_import '+
                             '  txt_mensagem = txt_mensagem + :txt_mensagem '+
                             'where '+
                             '  cod_arq_import_boleto = :cod_arq_import_boleto ';
                Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
                Q.ParamByName('cod_arq_import_boleto').AsInteger := CodArquivoImportacao;
                Q.ParamByName('txt_mensagem').AsString := msgErro;
                Q.ExecSQL;
                {Finaliza transação, garantindo atualizações realizadas}
                Commit;
              except
                on E: Exception do
                begin
                  Rollback;
                  Mensagens.Adicionar(1218, Self.ClassName, NomMetodo, [E.Message]);
                  Result := -1218;
                end;
              end;
            end;
          end;


          try
            if FileExists(sOrigem) then DeleteFile(sOrigem);
          except
            try
              beginTran;
              Q.Close;
              Q.SQL.Text :=
                'update tab_arq_import_sisbov '+
                'set '+
                '  cod_situacao_arq_import = :cod_situacao_arq_import, '+
                '  txt_mensagem = txt_mensagem + :txtMensagem '+
                'where '+
                '  cod_arq_import_boleto = :cod_arq_import_boleto ';
              Q.ParamByName('cod_situacao_arq_import').AsString := 'I';
              Q.ParamByName('cod_arq_import_boleto').AsInteger := CodArquivoImportacao;
              Q.ParamByName('txtMensagem').AsString := msgErro;
              Q.ExecSQL;
              //Finaliza transação, garantindo atualizações realizadas
              Commit;
            except
              on E: Exception do
              begin
                Rollback;
                Mensagens.Adicionar(1218, Self.ClassName, NomMetodo, [E.Message]);
                Result := -1218;
              end;
            end;
          end;
        end;
      end;
    finally
      {Tenta excluir o arquivo origem}
      if ((Result >= 0) and (not DeleteFile(sOrigem))) then begin
        try
          beginTran;
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
          Mensagens.Adicionar(1218, Self.ClassName, NomMetodo, [E.Message]);
          Result := -1218;
        end;
        end;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{* Função responsável por retornar os atributos do objeto. Os parâmetros de
   entrada são obrigatórios.

   @param ECodBoletoBancario Inteiro Parâmetro obrigatório, indicando qual boleto
                                     bancário, deverá ser buscado.
   @param ENumParcela Inteiro Parâmetro obrigatório, indicando qual parcela
                             deverá ser listada.

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2145 Retorno caso o parâmetro ECodBoletoBancario não seja informado
   @return -2184 Retorno caso o parâmetro ENumParcela não seja informado
   @return -2146 Retorno caso seja gerada alguma exceção durante a execução do
                 método.

}
function TIntBoletosBancario.Buscar(ECodBoletoBancario, ENumParcela: Integer): Integer;
const
  NomMetodo: String = 'Buscar';
  CodMetodo: Integer = 625;
var
  Qry: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if ECodBoletoBancario < 0 then
  begin
    Mensagens.Adicionar(2145, Self.ClassName, NomMetodo, []);
    Result := -2145;
    Exit;
  end;
  if ENumParcela < 0 then
  begin
    Mensagens.Adicionar(2184, Self.ClassName, NomMetodo, []);
    Result := -2184;
    Exit;
  end;


  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      LimparAtributos;
      Qry.SQL.Clear;
      Qry.SQL.Add(' select tb.cod_ordem_servico ' +
                  '      , tb.cod_boleto ' +
                  '      , tb.cod_identificacao_bancaria ' +
                  '      , tib.nom_banco ' +
                  '      , tib.nom_reduzido_banco ' +
                  '      , tsb.cod_situacao_boleto ' +
                  '      , tsb.sgl_situacao_boleto ' +
                  '      , tsb.des_situacao_boleto ' +
                  '      , tp.cod_pessoa ' +
                  '      , tp.nom_pessoa ' +
                  '      , tp.num_cnpj_cpf ' +
                  '      , case tp.cod_natureza_pessoa ' +
                  '          when ''F'' then convert(varchar(18), ' +
                  '            substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                  '            substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                  '            substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                  '            substring(tp.num_cnpj_cpf, 10, 2)) ' +
                  '          when ''J'' then convert(varchar(18), ' +
                  '            substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                  '            substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                  '            substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                  '            substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                  '            substring(tp.num_cnpj_cpf, 13, 2)) ' +
                  '        end as num_cnpj_cpf_formatado ' +
                  '      , tpr.nom_propriedade_rural ' +
                  '      , tpr.num_imovel_receita_federal ' +
                  '      , tb.dta_geracao_remessa ' +
                  '      , tb.cod_endereco_cobranca ' +
                  '      , tb.dta_vencimento_boleto ' +
                  '      , tb.num_parcela ' +
                  '      , tb.val_total_boleto ' +
                  '      , tos.qtd_animais ' +
                  '      , tos.val_unitario_vendedor ' +
                  '      , tos.val_unitario_tecnico ' +
                  '      , tos.val_unitario_certificadora ' +
                  '      , tos.val_vistoria ' +
                  '      , tos.val_total_os ' +
                  '      , tos.qtd_parcelas ' +
                  '      , tb.val_pago_boleto ' +
                  '      , tb.dta_credito_efetivado ' +
                  '      , tb.cod_usuario_ultima_alteracao ' +
                  '      , tua.nom_usuario as nom_usuario_ultima_alteracao ' +
                  '      , tb.cod_usuario_cancelamento ' +
                  '      , tuc.nom_usuario as nom_usuario_cancelamento ' +
                  '      , tb.dta_ultima_alteracao ' +
                  '      , tb.txt_mensagem_3 ' +
                  '      , tb.txt_mensagem_4 ' +
                  '      , te.cod_endereco ' +
                  '      , te.cod_tipo_endereco ' +
                  '      , (select sgl_tipo_endereco from tab_tipo_endereco where cod_tipo_endereco = te.cod_tipo_endereco) as sgl_tipo_endereco ' +
                  '      , (select des_tipo_endereco from tab_tipo_endereco where cod_tipo_endereco = te.cod_tipo_endereco) as des_tipo_endereco ' +
                  '      , te.nom_pessoa_contato ' +
                  '      , te.nom_logradouro ' +
                  '      , te.nom_bairro ' +
                  '      , te.num_cep ' +
                  '      , te.cod_distrito ' +
                  '      , (select nom_distrito from tab_distrito where cod_distrito = te.cod_distrito) nom_distrito ' +
                  '      , te.cod_municipio ' +
                  '      , (select nom_municipio from tab_municipio where cod_municipio = te.cod_municipio) nom_municipio ' +
                  '      , te.cod_estado ' +
                  '      , (select sgl_estado from tab_estado where cod_estado = te.cod_estado) sgl_estado ' +
                  '      , (select nom_estado from tab_estado where cod_estado = te.cod_estado) nom_estado ' +
                  '      , tfp.cod_forma_pagto_boleto ' +
                  '      , tfp.sgl_forma_pagto_boleto ' +
                  '      , tfp.des_forma_pagto_boleto ' +
                  '   from tab_boleto tb left join tab_usuario tuc on tb.cod_usuario_cancelamento = tuc.cod_usuario and tuc.dta_fim_validade is null ' +
                  '                      left join tab_usuario tua on tb.cod_usuario_ultima_alteracao = tua.cod_usuario and tua.dta_fim_validade is null ' +
                  '      , tab_identificacao_bancaria tib ' +
                  '      , tab_situacao_boleto tsb ' +
                  '      , tab_ordem_servico tos ' +
                  '      , tab_pessoa tp ' +
                  '      , tab_propriedade_rural tpr ' +
                  '      , tab_endereco te ' +
                  '      , tab_forma_pagto_boleto tfp ' +
                  '  where tb.cod_identificacao_bancaria = tib.cod_identificacao_bancaria ' +
                  '    and tb.cod_situacao_boleto        = tsb.cod_situacao_boleto ' +
                  '    and tb.cod_ordem_servico          = tos.cod_ordem_servico ' +
                  '    and tos.cod_pessoa_produtor       = tp.cod_pessoa ' +
                  '    and tos.cod_propriedade_rural     = tpr.cod_propriedade_rural ' +
                  '    and tfp.cod_forma_pagto_boleto    = tb.cod_forma_pagto_boleto ' +
                  '    and tb.cod_endereco_cobranca      = te.cod_endereco ' +
                  '    and tfp.dta_fim_validade is null ' +
                  '    and tib.dta_fim_validade is null ' +
                  '    and tp.dta_fim_validade is null ' +
                  '    and tpr.dta_fim_validade is null ' +
                  '    and tb.cod_boleto                 = :cod_boleto_bancario ' +
                  '    and tb.num_parcela                = :num_parcela ');

      Qry.ParamByName('cod_boleto_bancario').AsInteger := ECodBoletoBancario;
      Qry.ParamByName('num_parcela').AsInteger := ENumParcela;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2136, Self.ClassName, NomMetodo, []);
        Result := -2136;
        Exit;
      end;

      with Qry do
      begin
        FIntBoletoBancario.CodOrdemServico           := FieldByName('cod_ordem_servico').AsInteger;
        FIntBoletoBancario.CodBoletoBancario         := FieldByName('cod_boleto').AsInteger;
        FIntBoletoBancario.CodIdentificacaoBancaria  := FieldByName('cod_identificacao_bancaria').AsInteger;
        FIntBoletoBancario.NomBanco                  := FieldByName('nom_banco').AsString;
        FIntBoletoBancario.CodSituacaoBoleto         := FieldByName('cod_situacao_boleto').AsString;
        FIntBoletoBancario.SglSituacaoBoleto         := FieldByName('sgl_situacao_boleto').AsString;
        FIntBoletoBancario.DesSituacaoBoleto         := FieldByName('des_situacao_boleto').AsString;
        FIntBoletoBancario.NomPessoaProdutor         := FieldByName('nom_pessoa').AsString;
        FIntBoletoBancario.NumCNPJCPF                := FieldByName('num_cnpj_cpf').AsString;
        FIntBoletoBancario.NumCNPJCPFFormatado       := FieldByName('num_cnpj_cpf_formatado').AsString;
        FIntBoletoBancario.NomPropriedadeRural       := FieldByName('nom_propriedade_rural').AsString;
        FIntBoletoBancario.NumImovelReceitaFederal   := FieldByName('num_imovel_receita_federal').AsString;
        FIntBoletoBancario.DtaGeracaoRemessa         := FieldByName('dta_geracao_remessa').AsDateTime;
        FIntBoletoBancario.NomReduzidoBanco          := FieldByName('nom_reduzido_banco').AsString;

        //Classe endereço
        FIntBoletoBancario.enderecoCobranca.Codendereco      := FieldByName('cod_endereco').AsInteger;
        FIntBoletoBancario.enderecoCobranca.CodTipoendereco  := FieldByName('cod_tipo_endereco').AsInteger;
        FIntBoletoBancario.enderecoCobranca.SglTipoendereco  := FieldByName('sgl_tipo_endereco').AsString;
        FIntBoletoBancario.enderecoCobranca.DesTipoendereco  := FieldByName('des_tipo_endereco').AsString;
        FIntBoletoBancario.enderecoCobranca.NomPessoaContato := FieldByName('nom_pessoa_contato').AsString;
        FIntBoletoBancario.enderecoCobranca.NomLogradouro    := FieldByName('nom_logradouro').AsString;
        FIntBoletoBancario.enderecoCobranca.NomBairro        := FieldByName('nom_bairro').AsString;
        FIntBoletoBancario.enderecoCobranca.NumCEP           := FieldByName('num_cep').AsString;
        FIntBoletoBancario.enderecoCobranca.CodDistrito      := FieldByName('cod_distrito').AsInteger;
        FIntBoletoBancario.enderecoCobranca.NomDistrito      := FieldByName('nom_distrito').AsString;
        FIntBoletoBancario.enderecoCobranca.CodMunicipio     := FieldByName('cod_municipio').AsInteger;
        FIntBoletoBancario.enderecoCobranca.NomMunicipio     := FieldByName('nom_municipio').AsString;
        FIntBoletoBancario.enderecoCobranca.CodEstado        := FieldByName('cod_estado').AsInteger;
        FIntBoletoBancario.enderecoCobranca.NomEstado        := FieldByName('nom_estado').AsString;
        FIntBoletoBancario.enderecoCobranca.SglEstado        := FieldByName('sgl_estado').AsString;

        FIntBoletoBancario.DtaVencimentoBoleto       := FieldByName('dta_vencimento_boleto').AsDateTime;
        FIntBoletoBancario.NumParcela                := FieldByName('num_parcela').AsInteger;
        FIntBoletoBancario.ValTotalBoleto            := FieldByName('val_total_boleto').AsCurrency;
        FIntBoletoBancario.QtdAnimais                := FieldByName('qtd_animais').AsInteger;
        FIntBoletoBancario.ValUnitarioVendedor       := FieldByName('val_unitario_vendedor').AsCurrency;
        FIntBoletoBancario.ValUnitarioTecnico        := FieldByName('val_unitario_tecnico').AsCurrency;
        FIntBoletoBancario.ValUnitarioCertificadora  := FieldByName('val_unitario_certificadora').AsCurrency;
        FIntBoletoBancario.ValTotalOS                := FieldByName('val_total_os').AsCurrency;
        FIntBoletoBancario.ValVistoria               := FieldByName('val_vistoria').AsCurrency;
        FIntBoletoBancario.QtdParcelas               := FieldByName('qtd_parcelas').AsInteger;
        FIntBoletoBancario.ValPagoBoleto             := FieldByName('val_pago_boleto').AsCurrency;
        FIntBoletoBancario.DtaCreditoEfetivado       := FieldByName('dta_credito_efetivado').AsDateTime;
        FIntBoletoBancario.CodUsuarioUltimaAlteracao := FieldByName('cod_usuario_ultima_alteracao').AsInteger;
        FIntBoletoBancario.NomUsuarioUltimaAlteracao := FieldByName('nom_usuario_ultima_alteracao').AsString;
        FIntBoletoBancario.CodUsuarioCancelamento    := FieldByName('cod_usuario_cancelamento').AsInteger;
        FIntBoletoBancario.NomUsuarioCancelamento    := FieldByName('nom_usuario_cancelamento').AsString;
        FIntBoletoBancario.DtaUltimaAlteracao        := FieldByName('dta_ultima_alteracao').AsDateTime;
        FIntBoletoBancario.TxtMensagem3              := FieldByName('txt_mensagem_3').AsString;
        FIntBoletoBancario.TxtMensagem4              := FieldByName('txt_mensagem_4').AsString;

        FIntBoletoBancario.CodFormaPagamentoBoleto          := FieldByName('cod_forma_pagto_boleto').AsInteger;
        FIntBoletoBancario.SglFormaPagamentoBoleto          := FieldByName('sgl_forma_pagto_boleto').AsString;
        FIntBoletoBancario.DesFormaPagamentoBoleto          := FieldByName('des_forma_pagto_boleto').AsString;
      end;
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2146, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2146;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Função responsável por retornar os atributos referentes ao classe de boletos
   bancários, relacionados a importação do arquivo de retorno.

   @param ECodArquivoImportacao Inteiro Parmâmetro de entrada obrigatório. Quando
                                        informado, retornará os atributos da
                                        tab_arq_import_boleto.

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2173 Retorno caso o parâmetro ECodArquivoImportacao não seja informado.
   @return -2185 Retorno caso o arquivo informado no parâmetro não seja encontrado
                 na tab_arq_import_boleto. 
   @return -2174 Retorno caso seja gerada alguma exceção durante a execução do
                 método.

}
function TIntBoletosBancario.BuscarArquivoImportacao(ECodArquivoImportacao: Integer): Integer;
const
  NomMetodo: String  = 'BuscarArquivoImportacao';
  CodMetodo: Integer = 637;
var
  Qry: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if ECodArquivoImportacao < 0 then
  begin
    Mensagens.Adicionar(2173, Self.ClassName, NomMetodo, []);
    Result := -2173;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      LimparAtributos;    
      Qry.SQL.Clear;
      Qry.SQL.Add(' select taib.cod_arq_import_boleto ' +
                  '      , taib.nom_arq_upload ' +
                  '      , taib.nom_arq_import_boleto ' +
                  '      , taib.dta_importacao ' +
                  '      , taib.qtd_registros_total ' +
                  '      , taib.qtd_registros_errados ' +
                  '      , taib.qtd_registros_processados ' +
                  '      , taib.dta_processamento ' +
                  '      , taib.cod_usuario_upload ' +
                  '      , tu.nom_usuario as nom_usuario_upload ' +
                  '      , taib.cod_tarefa ' +
                  '      , taib.cod_tipo_arquivo_boleto ' +
                  '      , ttab.des_tipo_arquivo_boleto ' +
                  '      , taib.cod_situacao_arq_import ' +
                  '      , tsai.des_situacao_arq_import ' +
                  '      , taib.txt_mensagem ' +
                  '      , tst.des_situacao_tarefa ' +
                  '      , tt.dta_inicio_previsto ' +
                  '      , tt.dta_inicio_real ' +
                  '      , tt.dta_fim_real ' +
                  '      , tut.nom_usuario as nom_usuario_tarefa ' +
                  '   from tab_arq_import_boleto taib ' +
                  '          left join tab_tarefa tt on taib.cod_tarefa                  = tt.cod_tarefa ' +
		              '          left join tab_situacao_tarefa tst on tt.cod_situacao_tarefa = tst.cod_situacao_tarefa ' +
                  '          left join tab_usuario tut on tt.cod_usuario                 = tut.cod_usuario ' +
                  '      , tab_situacao_arq_import tsai ' +
                  '      , tab_usuario tu ' +
                  '      , tab_tipo_arquivo_boleto ttab ' +
                  '  where taib.cod_situacao_arq_import = tsai.cod_situacao_arq_import ' +
                  '    and taib.cod_usuario_upload      = tu.cod_usuario ' +
                  '    and taib.cod_tipo_arquivo_boleto = ttab.cod_tipo_arquivo_boleto ' +
                  '    and taib.cod_arq_import_boleto   = :cod_arq_import_boleto ');

      Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2185, Self.ClassName, NomMetodo, []);
        Result := -2185;
        Exit;
      end;

      with Qry do
      begin
        FIntBoletoBancario.CodArqImportBoleto      := FieldByName('cod_arq_import_boleto').AsInteger;
        FIntBoletoBancario.NomArqUpLoad            := FieldByName('nom_arq_upload').AsString;
        FIntBoletoBancario.NomArqImportBoleto      := FieldByName('nom_arq_import_boleto').AsString;
        FIntBoletoBancario.DtaImportacao           := FieldByName('dta_importacao').AsDateTime;
        FIntBoletoBancario.QtdRegistrosTotal       := FieldByName('qtd_registros_total').AsInteger;
        FIntBoletoBancario.QtdRegistrosErrados     := FieldByName('qtd_registros_errados').AsInteger;
        FIntBoletoBancario.QtdRegistrosProcessados := FieldByName('qtd_registros_processados').AsInteger;
        FIntBoletoBancario.DtaProcessamento        := FieldByName('dta_processamento').AsDateTime;
        FIntBoletoBancario.CodUsuarioUpLoad        := FieldByName('cod_usuario_upload').AsInteger;
        FIntBoletoBancario.NomUsuarioUpLoad        := FieldByName('nom_usuario_upload').AsString;
        FIntBoletoBancario.CodTarefa               := FieldByName('cod_tarefa').AsInteger;
        FIntBoletoBancario.CodTipoArquivoBoleto    := FieldByName('cod_tipo_arquivo_boleto').AsInteger;
        FIntBoletoBancario.DesTipoArquivoBoleto    := FieldByName('des_tipo_arquivo_boleto').AsString;
        FIntBoletoBancario.CodSituacaoBoleto       := FieldByName('cod_situacao_arq_import').AsString;
        FIntBoletoBancario.DesSituacaoBoleto       := FieldByName('des_situacao_arq_import').AsString;
        FIntBoletoBancario.TxtMensagem             := FieldByName('txt_mensagem').AsString;
        FIntBoletoBancario.CodSituacaoArqImport    := FieldByName('cod_situacao_arq_import').AsString;
        FIntBoletoBancario.DesSituacaoArqImport    := FieldByName('des_situacao_arq_import').AsString;

        FIntBoletoBancario.DesSituacaoTarefa             := FieldByName('des_situacao_tarefa').AsString;
        FIntBoletoBancario.DtaInicioPrevistoTarefa       := FieldByName('dta_inicio_previsto').AsDateTime;
        FIntBoletoBancario.DtaInicioRealTarefa           := FieldByName('dta_inicio_real').AsDateTime;
        FIntBoletoBancario.DtaFimRealTarefa              := FieldByName('dta_fim_real').AsDateTime;
        FIntBoletoBancario.NomUsuarioProcessamentoTarefa := FieldByName('nom_usuario_tarefa').AsString;
      end;
      
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2174, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2174;
        Exit;
      end;
    end
  finally
    Qry.Free;
  end;
end;


{* Função responsável por retornar a prioridade de uma situação do boleto bancário

    @param CodSituacaoBoleto Inteiro Situação do boleto bancário.
    @param CodPrioridadeSituacao Inteiro Parâmetro do tipo var, que irá receber
           o valor da prioridade da situação passada como parâmetro.

    @return 0     Retorno caso a função seja executada com sucesso.
    @return -2140 Retorno caso a situação informada como parâmetro não seja encontrada
                  na base de dados.
    @return -2141 Retorno caso ocorra alguma exceção durante a execução do método.
}
function TIntBoletosBancario.BuscarCodigoPrioridadeSituacao(ECodSituacaoBoleto: Integer;
                                                            var ECodPrioridadeSituacao: Integer): Integer;
const
  NomMetodo: String = 'BuscarCodigoPrioridadeSituacao';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_prioridade_situacao from tab_situacao_boleto');
      Qry.SQL.Add(' where cod_situacao_boleto = :cod_situacao_boleto');
      Qry.ParamByName('cod_situacao_boleto').AsInteger := ECodSituacaoBoleto;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2140, Self.ClassName, NomMetodo, []);
        Result := -2140;
        Exit
      end;
      ECodPrioridadeSituacao := Qry.FieldByName('cod_prioridade_situacao').AsInteger;
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2141, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2141;
        Exit
      end;
    end;
  finally
    Qry.Free;
  end;
end;

{* Função que retorna o valor do campo cod_titulo_aceito, atribuido para uma
   instituição bancária

   @param ECodIdentificacaoBancaria Inteiro Identifica a Instituição Bancária
   @param ECodTituloAceito String Campo do tipo var, que irá receber o valor do
          parâmetro cod_titulo_aceito que se encontra na tab_identificacao_bancária.

   @return 0     Retorno caso a função seja executada com sucesso
   @return -2124 Retorno caso não seja encontrada a instituição bancária passada
                 como parâmetro
   @return -2425 Retorono caso seja gerada alguma exceção durante a execução do
                 método
}
function TIntBoletosBancario.BuscarTituloAceito(ECodIdentificacaoBancaria: Integer;
                                                var ECodTituloAceito: String): Integer;
const
  NomMetodo: String = 'BuscarTituloAceito';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_titulo_aceito from tab_identificacao_bancaria');
      Qry.SQL.Add(' where cod_identificacao_bancaria = :cod_identificacao_bancaria');
      Qry.ParamByName('cod_identificacao_bancaria').AsInteger := ECodIdentificacaoBancaria;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2124, Self.ClassName, NomMetodo, []);
        Result := -2124;
        Exit;
      end
      else
      begin
        ECodTituloAceito := Qry.FieldByName('cod_titulo_aceito').AsString;
        Result := 0;
      end;
    Except
      on E:Exception do
      begin
        Mensagens.Adicionar(2125, Self.ClassName, NomMetodo, [e.message]);
        Result := -2125;
        Exit;
      end;
    end;
  Finally
    Qry.Free;
  end;
end;

constructor TIntBoletosBancario.Create;
begin
  inherited;
  FIntBoletoBancario := TIntBoletoBancario.Create;
  FIntBoletoBancario.enderecoCobranca := TIntendereco.Create;
  FIntenderecos      := TIntenderecos.Create;
end;


{* Função responsável por inserir um novo endereço, na tab_endereco, de acordo
   com as regras de negócio do módulo de boletos bancários.

   @param ECodTipoendereco Inteiro
   @param ENomLogradouro
   @param ENomBairro String
   @param ENumCEP String
   @param ECodDistrito Inteiro
   @param ECodMunicipio Inteiro
   @param ENomLocalidade String
   @param ECodEstado Inteiro

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
}
function TIntBoletosBancario.DefinirenderecoCobrancaBoleto(ECodTipoendereco: Integer;
                                                           ENomLogradouro,
                                                           ENomBairro,
                                                           ENumCEP: WideString;
                                                           ECodDistrito,
                                                           ECodMunicipio: Integer;
                                                           ENomLocalidade: WideString;
                                                           ECodEstado: Integer): Integer;
const
  CodMetodo: Integer = 629;
  NomMetodo: String = 'DefinirenderecoCobrancaBoleto';
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Result := FIntenderecos.Inserir(ECodTipoendereco, '', '', '', '',
                                  ENomLogradouro, ENomBairro, ENumCEP,
                                  ENomLocalidade, ECodDistrito,
                                  ECodMunicipio, ECodEstado);
  if Result < 0 then begin
    Exit;
  end;
end;


{* Função responsável por retornar o endereço de cobrança da Ordem de Serviço.

   @param ECodOrdemServico Inteiro Parâmetro obrigatório. Irá buscar na
                                   tab_ordem_servico, o atributo
                                   cod_endereco_cobranca_ident

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2156 Retorno caso a Ordem de serviço informada no parâmetro,
                 ECodOrdemServico, não seja encontrado.
   @return -2157 Retorno caso seja lançada alguma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.DefinirenderecoCobrancaOS(ECodOrdemServico: Integer): Integer;
const
  CodMetodo: Integer = 630;
  NomMetodo: String = 'DefinirenderecoCobrancaOS';
var
  Qry: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Qry.SQL.Clear;
      Qry.SQL.Add(' select cod_endereco_cobranca_ident ');
      Qry.SQL.Add('   from tab_ordem_servico ' );
      Qry.SQL.Add('  where cod_ordem_servico = :cod_ordem_servico ');
      Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2156, Self.ClassName, NomMetodo, []);
        Result := -2156;
        Exit;
      end;

      Result := Qry.FieldByName('cod_endereco_cobranca_ident').AsInteger;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2157, Self.ClassName, NomMetodo, [e.message]);
        Result := -2157;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

destructor TIntBoletosBancario.Destroy;
begin
  inherited;
  FIntBoletoBancario.Free;
  FIntenderecos.Free;
end;

{* Função responsável por realizar o processamento do arquivo de remessa de boletos
   bancários. A função gerará um arquivo para cada banco, salvando os mesmos no
   diretório <certificadora>\boletos.

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return -188  Valor retornado quando o usuário logado no sistema não possuir
                 permissão de acesso para executar o método.
   @return -2159 Valor retornado quando não for encontrado boletos bancários na
                 situação "2", "Pronto para envio".
   @return -2160 Valor retornado quando o tipo do arquivo não for encontrado,
                 tab_tipo_arquivo_boleto.
   @return -1088 Valor retornado quando não for encontrada a pessoa, referente a
                 Certificadora.
   @return -2161 Valor retornado quando o diretório de leitura do arquivo não
                 existir.
   @return -1140 Valor retornado quando ocorrer algum erro ao tentar escrever no
                 arquivo, dentro do arquivo ZIP.
   @return -2162 Valor retornado caso alguma exceção seja lançada durante a
                 execução do método.
}
function TIntBoletosBancario.GerarArquivoRemessa(): Integer;
const
  NomMetodo: String  = 'GerarArquivoRemessa';
  CodMetodo: Integer = 632;
  CodParametroCaminhoArqRemessa: Integer = 102;

  cCodigoProduto:    String = '0014';
  cCarteiraCobranca: String = '11';
  cVariacaoCarteira: String = '019';
var
  Qry, qAux: THerdomQuery;
  DadosArquivo: TDadosArquivo;
  Zip : ZipFile;
  NomPessoa,
  NumCNPJCertificadora,
  TxtPrefixoNomArquivo,
  CodBancoCompensacao,
  CodConvenioBanco,
  strLinha: String;
  CodArquivoRemessa,
  CodPessoa,
  NumSeqLote,
  QtdBytes,
  TamNumeroBanco,
  NumLinhasArquivo,
  i, CodIdentificacaoBancaria: Integer;
  Dia, Mes, Ano, Hora, Min, Seg, MSeg: Word;
  F : File of Byte;
  bUltimoArquivo: Boolean;
  TxtMensagensErro: TStringList;
  IndErroGeracaoRemessa: Char;

  ListaBoletosAtualizar: TStringList;

  function AbrirArquivos(): Integer;
  begin
    // Prepara o arquivo zip para receber o arquivo txt.
    if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'criação']);
      Result := -1140;
      Exit;
    end;
    // Prepara o arquivo txt dentro do arquivo ZIP
    if AbrirArquivoNoZip(Zip, ExtractFileName(DadosArquivo.NomArquivoRemessa)) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'criação']);
      Result := -1140;
      Exit;
    end;

    DecodeDate(DtaSistema, Ano, Mes, Dia);
    DecodeTime(DtaSistema, Hora, Min, Seg, MSeg);
    strLinha := '';
    NumLinhasArquivo := 0;

    // Header de arquivo - Registro 0
    strLinha := strLinha + PadL(Qry.FieldByName('cod_banco_compensacao').AsString, '0', 3); // Código do banco na compensação
    strLinha := strLinha + '0000'; // Lote de serviço
    strLinha := strLinha + '0'; // Registro header do arquivo
    strLinha := strLinha + PadR('', ' ', 9); // Uso exclusivo FEBRABAN
    strLinha := strLinha + '2'; // Tipo de inscrição da empresa (CNPJ)
    strLinha := strLinha + PadR(NumCNPJCertificadora, ' ', 14);
    strLinha := strLinha + PadR('', ' ', 20); // Código do convênio no banco (Em branco)
    strLinha := strLinha + PadL(Qry.FieldByName('cod_agencia_conta').AsString, '0', 5); // Agência mantenedora do banco
    strLinha := strLinha + PadL(Qry.FieldByName('cod_dv_agencia').AsString, '0', 1); // Digito verificador da agência mantenedora do banco
    strLinha := strLinha + PadL(Qry.FieldByName('cod_conta_corrente').AsString, '0', 12); // Número da Conta corrente

    if Length(Trim(Qry.FieldByName('cod_dv_conta_corrente').AsString)) = 1 then
    begin
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_corrente').AsString, ' ', 1); // Dígito verificador da conta corrente
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_agencia').AsString, ' ', 1); // Dígito verificador da agê
    end
    else
    begin
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_corrente').AsString, ' ', 2); // Dígito verificador da conta corrente
    end;

    strLinha := strLinha + PadR(RedimensionaString(NomPessoa, 30), ' ', 30); // Nome da empresa
    strLinha := strLinha + PadR(RedimensionaString(Qry.FieldByName('nom_banco').AsString, 30), ' ', 30); // Nome do Banco
    strLinha := strLinha + PadR('', ' ', 10); // Uso exclusivo FEBRABAN
    strLinha := strLinha + PadR('1', ' ', 1); // Código remessa (1) / retorno (2)
    strLinha := strLinha + PadL(IntToStr(Dia), '0', 2)
                         + PadL(IntToStr(Mes), '0', 2)
                         + PadL(IntToStr(Ano), '0', 4); // Data de geração do arquivo
    strLinha := strLinha + PadL(IntToStr(Hora), '0', 2)
                         + PadL(IntToStr(Min),  '0', 2)
                         + PadL(IntToStr(Seg),  '0', 2); // Hora de geração do arquivo
    strLinha := strLinha + '000000'; // Nùmero sequencial do arquivo
    strLinha := strLinha + '030'; // Número da versão do layout do arquivo
    strLinha := strLinha + '00000'; // Densidade de gravação do arquivo
    strLinha := strLinha + PadR('', ' ', 20); // Uso reservado do banco
    strLinha := strLinha + PadR('', ' ', 20); // Uso reservado da empresa

    strLinha := strLinha + PadR('', ' ', 11); // Uso exclusivo FEBRABAN
    strLinha := strLinha + PadR('', ' ', 3); // Identificacao cobrança s/ papel
    strLinha := strLinha + PadR('', ' ', 3); // Uso exclusivo das vans
    strLinha := strLinha + PadR('', ' ', 2); // Tipo de serviço
    strLinha := strLinha + PadR('', ' ', 10); // Código das ocorrências

    // Grava registro Tipo 0
    if GravarLinhaNoZip(Zip, strLinha) < 0 then
    begin
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
      Result := -1140;
      Exit;
    end;
    Inc(NumLinhasArquivo);

    Inc(NumSeqLote);
    strLinha := '';
    DecodeDate(DtaSistema, Ano, Mes, Dia);

    // Header de arquivo - Registro 1
    strLinha := strLinha + PadL(Qry.FieldByName('cod_banco_compensacao').AsString, '0', 3); // Código do banco na compensação
    strLinha := strLinha + '0001'; // Lote serviço
    strLinha := strLinha + '1'; // Registro header do lote
    strLinha := strLinha + 'R'; // Tipo de operação
    strLinha := strLinha + '01'; // Tipo de serviço
    strLinha := strLinha + '00'; // Forma de lançamento
    strLinha := strLinha + '020'; // Número da versão do layout do lote
    strLinha := strLinha + PadR('', ' ', 1); // Uso exclusivo FEBRABAN
    strLinha := strLinha + '2'; // Tipo de inscrição da empresa (CNPJ)
    strLinha := strLinha + PadL(NumCNPJCertificadora, '0', 15);
    // Código de convênio do banco -> composto por: 00 +
    //                                codigo convenio do banco +
    //                                0014 (código produto) +
    //                               (codigo carteira cobrancça) +
    //                               (código da variação da carteira)
    if Length(Trim(Qry.FieldByName('cod_convenio_banco').AsString)) = 18 then
    begin
      strLinha := strLinha + Trim(Qry.FieldByName('cod_convenio_banco').AsString)
                           + PadR('', ' ', 2); // Código do convênio no banco
    end
    else if Length(Trim(Qry.FieldByName('cod_convenio_banco').AsString)) = 20 then
    begin
      strLinha := strLinha + Trim(Qry.FieldByName('cod_convenio_banco').AsString);
    end
    else
    begin
      TxtMensagensErro.Add('O campo código de convênio está com formato inválido. O arquivo não será gerado.');
      Result := -1;
      Exit;
    end;

    strLinha := strLinha + PadL(Qry.FieldByName('cod_agencia_conta').AsString, '0', 5); // Agência mantenedora do banco
    strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_agencia').AsString, ' ', 1); // Digito verificador da agência mantenedora do banco
    strLinha := strLinha + PadL(Qry.FieldByName('cod_conta_corrente').AsString, '0', 12); // Número da Conta corrente

    if Length(Trim(Qry.FieldByName('cod_dv_conta_corrente').AsString)) = 1 then
    begin
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_corrente').AsString, ' ', 1); // Dígito verificador da conta corrente
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_agencia').AsString, ' ', 1); // Dígito verificador da agê
    end
    else
    begin
      strLinha := strLinha + PadR(Qry.FieldByName('cod_dv_conta_corrente').AsString, ' ', 2); // Dígito verificador da conta corrente
    end;

    strLinha := strLinha + PadR(RedimensionaString(NomPessoa, 30), ' ', 30); // Nome da empresa
    strLinha := strLinha + PadR(Qry.FieldByName('txt_mensagem_1').AsString, ' ', 40); // Mensagem 1 (Em branco)
    strLinha := strLinha + PadR(Qry.FieldByName('txt_mensagem_2').AsString, ' ', 40); // Mensagem 2 (Em branco)
    strLinha := strLinha + PadL(IntToStr(CodArquivoRemessa), '0', 8); // Número remessa / retorno
    strLinha := strLinha + PadL(IntToStr(Dia), '0', 2)
                         + PadL(IntToStr(Mes), '0', 2)
                         + PadL(IntToStr(Ano), '0', 4); // Data de gravação do arquivo
    strLinha := strLinha + PadR('', '0', 8); // Data do crédito
    strLinha := strLinha + PadR('', ' ', 33); // Uso exclusivo FEBRABAN

    // Grava registro Tipo 1
    if GravarLinhaNoZip(Zip, strLinha) < 0 then
    begin
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
      Result := -1140;
      Exit;
    end;
    Inc(NumLinhasArquivo);

    Result := 0;
  end;

  function FinalizarArquivos(): Integer;
  begin
    Inc(NumLinhasArquivo);
    // Trailer de lote do arquivo - registro Tipo 5
    strLinha := '';
    strLinha := strLinha + PadL(CodBancoCompensacao, '0', 3); // Código do banco na compensação
    strLinha := strLinha + '0001'; // Lote serviço
    strLinha := strLinha + '5'; // Registro trailer do lote
    strLinha := strLinha + PadR('', ' ', 9); // Uso exclusivo FEBRABAN
    strLinha := strLinha + PadL(IntToStr(NumLinhasArquivo - 1), '0', 6); // Quantidade de registros do arquivo
    strLinha := strLinha + PadL('', '0', 6); // Quantidade de títulos em cobrança
    strLinha := strLinha + PadL('', '0', 15); // Valor total dos títulos em carteira
    strLinha := strLinha + PadL('', '0', 6); // Quantidade de títulos em cobrança
    strLinha := strLinha + PadL('', '0', 15); // Valor total dos títulos em carteira
    strLinha := strLinha + PadL('', '0', 6); // Quantidade de títulos em cobrança
    strLinha := strLinha + PadL('', '0', 15); // Valor total dos títulos em carteira
    strLinha := strLinha + PadL('', '0', 6); // Quantidade de títulos em cobrança
    strLinha := strLinha + PadL('', '0', 15); // Valor total dos títulos em carteira
    strLinha := strLinha + PadL('', ' ', 8); // Número do aviso de lançamento
    strLinha := strLinha + PadL('', ' ', 125); // Uso exclusivo FEBRABAN

    // Grava registro Tipo 5
    if GravarLinhaNoZip(Zip, strLinha) < 0 then
    begin
      Rollback;
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
      Result := -1140;
      Exit;
    end;

    Inc(NumLinhasArquivo);
    // Trailer do arquivo - Registro 09
    strLinha := '';
    strLinha := strLinha + PadL(CodBancoCompensacao, '0', 3); // Código do banco na compensação
    strLinha := strLinha + '9999'; // Lote serviço
    strLinha := strLinha + '9'; // Registro trailer
    strLinha := strLinha + PadR('', ' ', 9); // Uso exclusivo FEBRABAN
    strLinha := strLinha + '000001'; // Quantidade de lotes do arquivo
    strLinha := strLinha + PadL(IntToStr(NumLinhasArquivo), '0', 6); // Quantidade de registros do arquivo
    strLinha := strLinha + PadL('', ' ', 6); // Quantidade de contas
    strLinha := strLinha + PadR('', ' ', 205); // Uso exclusivo FEBRABAN

    // Grava registro Tipo 9
    if GravarLinhaNoZip(Zip, strLinha) < 0 then
    begin
      Rollback;
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
      Result := -1140;
      Exit;
    end;

    if FecharArquivoNoZip(Zip) < 0 then
    begin
      Rollback;
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'fechamento']);
      Result := -1140;
      Exit;
    end;
    if FecharZip(Zip, nil) < 0 then
    begin
      Rollback;
      Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'conclusão']);
      Result := -1140;
      Exit;
    end;

    if FileExists(DadosArquivo.NomArquivoZIP) then begin
      AssignFile(F, DadosArquivo.NomArquivoZIP);
      Reset(F);
      try
        QtdBytes := FileSize(F);
      finally
        CloseFile(F);
      end;
    end else begin
      QtdBytes := 0;
    end;

    if (TxtMensagensErro <> nil) and (TxtMensagensErro.Count > 0) then
    begin
      IndErroGeracaoRemessa := 'S';
      QtdBytes := 0;

      if not DeleteFile(DadosArquivo.NomArquivoZIP) then
      begin
        Mensagens.Adicionar(2199, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZIP]);
        Result := -2199;
        Exit;
      end;
    end
    else
    begin
      IndErroGeracaoRemessa := 'N';
    end;

    Result := InserirArquivoRemessaBoleto(CodArquivoRemessa, 1, DadosArquivo.NomArquivoZIP, QtdBytes, IndErroGeracaoRemessa);
    if Result < 0 then
    begin
      Exit;
    end;

    // Caso exista alguma mensagem de erro, as mesmas deverão ser gravadas no banco
    if (TxtMensagensErro <> nil) and (TxtMensagensErro.Count > 0) then
    begin
      i := 0;
      while i < TxtMensagensErro.Count do
      begin
        Result := InserirErroRemessaBoleto(CodArquivoRemessa, TxtMensagensErro.Strings[i]);
        if Result < 0 then
        begin
          Exit;
        end;
        Inc(i);
      end;
    end;

    if Length(Trim(ListaBoletosAtualizar.DelimitedText)) > 0 then
    begin
      Begintran;
      // Atualiza remessa do boleto na tab_boleto
      qAux.SQL.Clear;
      qAux.SQL.Add(' update tab_boleto ' +
                   '    set cod_arquivo_remessa_boleto = :cod_arquivo_remessa_boleto ' +
                   '      , dta_geracao_remessa        = getdate() ' +
                   '  where cod_boleto in ( ' + ListaBoletosAtualizar.DelimitedText + ') ');
      qAux.ParamByName('cod_arquivo_remessa_boleto').AsInteger := CodArquivoRemessa;
      qAux.ExecSQL;
      Commit;
    end;

    Result := 0;
  end;

begin
  Result := 0;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  ListaBoletosAtualizar := TStringList.Create;
  ListaBoletosAtualizar.Sorted := True;

  TxtMensagensErro := TStringList.Create;
  Qry  := THerdomQuery.Create(Conexao, nil);
  qAux := THerdomQuery.Create(Conexao, nil);
  try
    try
      with Qry do
      begin
        SQL.Clear;
        SQL.Add(' select tb.cod_ordem_servico ' +
                '      , tb.cod_boleto ' +
                '      , tb.num_parcela ' +
                '      , tb.val_total_boleto ' +
                '      , tb.dta_vencimento_boleto ' +
                '      , tb.txt_mensagem_3 ' +
                '      , tb.txt_mensagem_4 ' +
                '      , tib.cod_identificacao_bancaria ' +
                '      , tib.nom_banco ' +
                '      , tib.nom_reduzido_banco ' +
                '      , tib.cod_banco_compensacao ' +
                '      , tib.cod_convenio_banco ' +
                '      , tib.cod_agencia_conta ' +
                '      , tib.cod_dv_agencia ' +
                '      , tib.cod_conta_corrente ' +
                '      , tib.cod_dv_conta_corrente ' +
                '      , tib.cod_dv_conta_agencia ' +
                '      , tib.cod_tipo_juros_mora ' +
                '      , tib.val_juros_mora_dia_taxa ' +
                '      , tib.cod_carteira_banco ' +
                '      , tib.cod_protesto_boleto ' +
                '      , tib.qtd_dia_protesto ' +
                '      , tib.cod_especie_titulo ' +
                '      , tib.cod_titulo_aceito ' +                
                '      , tib.txt_mensagem_1 ' +
                '      , tib.txt_mensagem_2 ' +
                '      , tib.ind_gera_nosso_numero ' +
                '      , tec.nom_logradouro ' +
                '      , tec.nom_bairro ' +
                '      , tec.num_cep ' +
                '      , tm.nom_municipio ' +
                '      , te.nom_estado ' +
                '      , te.sgl_estado ' +                
                '      , tp.nom_pessoa ' +
                '      , tp.cod_natureza_pessoa ' +
                '      , tp.num_cnpj_cpf ' +
                '   from tab_boleto tb ' +
                '      , tab_identificacao_bancaria tib ' +
                '      , tab_ordem_servico tos ' +
                '      , tab_pessoa tp' +
                '      , tab_endereco tec ' +
                '      , tab_municipio tm ' +
                '      , tab_estado te ' +
                '  where tb.cod_identificacao_bancaria = tib.cod_identificacao_bancaria ' +
                '    and tb.cod_ordem_servico          = tos.cod_ordem_servico ' +
                '    and tos.cod_pessoa_produtor       = tp.cod_pessoa ' +
                '    and tb.cod_endereco_cobranca      = tec.cod_endereco ' +
                '    and tec.cod_municipio             = tm.cod_municipio ' +
                '    and tec.cod_estado                = te.cod_estado ' +
                '    and tb.cod_situacao_boleto = 2 ' +
                '  order ' +
                '     by tb.cod_identificacao_bancaria, tb.cod_boleto, tb.num_parcela ');
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(2159, Self.ClassName, NomMetodo, []);
          Result := -2159;
          Exit;
        end;

        qAux.SQL.Clear;
        qAux.SQL.Add('select txt_prefixo_nome_arquivo from tab_tipo_arquivo_boleto');
        qAux.SQL.Add(' where cod_tipo_arquivo_boleto = 1');
        qAux.Open;
        if qAux.IsEmpty then
        begin
          Mensagens.Adicionar(2160, Self.ClassName, NomMetodo, []);
          Result := -2160;
          Exit;
        end;
        TxtPrefixoNomArquivo := Trim(qAux.FieldByName('txt_prefixo_nome_arquivo').AsString);

        CodPessoa := StrToInt(ValorParametro(4));
        qAux.SQL.Clear;
        qAux.SQL.Add('select nom_pessoa, num_cnpj_cpf ' +
                     '  from tab_pessoa ' +
                     ' where cod_pessoa = :cod_pessoa  ' +
                     '   and dta_fim_validade is null ');
        qAux.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        qAux.Open;
        if qAux.IsEmpty then begin
          Mensagens.Adicionar(1088, Self.ClassName, NomMetodo, []);
          Result := -1088;
          Exit;
        end;
        NomPessoa            := qAux.FieldByName('nom_pessoa').AsString;
        NumCNPJCertificadora := qAux.FieldByName('num_cnpj_cpf').AsString;

        CodIdentificacaoBancaria := FieldByName('cod_identificacao_bancaria').AsInteger;

        begintran;
        Result := ProximoNumeroArquivoRemessa(CodIdentificacaoBancaria, CodArquivoRemessa);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
        Commit;

        DadosArquivo.CodTipoArquivoRemessa := 1;
        DadosArquivo.TxtPrefixoArquivo     := TxtPrefixoNomArquivo;
        DadosArquivo.Caminho               := ValorParametro(CodParametroCaminhoArqRemessa);
        DadosArquivo.NomArquivoZIP         := DadosArquivo.Caminho + '\' + DadosArquivo.TxtPrefixoArquivo + '_' + FieldByName('nom_reduzido_banco').AsString + '_' + FormatFloat('0000000000', CodArquivoRemessa) + '.ZIP';
        DadosArquivo.NomArquivoRemessa     := DadosArquivo.Caminho + '\' + DadosArquivo.TxtPrefixoArquivo + '_' + FieldByName('nom_reduzido_banco').AsString + '_' + FormatFloat('0000000000', CodArquivoRemessa) + '.TXT';
        if not DirectoryExists(DadosArquivo.Caminho) then
        begin
          if not CreateDir(DadosArquivo.Caminho) then
          begin
            Mensagens.Adicionar(2161, Self.ClassName, NomMetodo, []);
            Result := -2161;
            Exit;
          end;
        end;

        Result := AbrirArquivos();
        if Result < 0 then
        begin
          FinalizarArquivos();
          Result := 0;
          Exit;
        end;

        // Geração do arquivo de remessa.
        NumSeqLote := 0;
        bUltimoArquivo := False;
        begintran;
        while not Qry.EOF do
        begin
          CodBancoCompensacao := FieldByName('cod_banco_compensacao').AsString;
          Result := ValidaDadosRemessaBoleto(Qry, TxtMensagensErro);
          if Result < 0 then
          begin
            Rollback;
            Exit;
          end;

          if (CodIdentificacaoBancaria = FieldByName('cod_identificacao_bancaria').AsInteger) then
          begin
            Inc(NumSeqLote);
            strLinha := '';
            DecodeDate(FieldByName('dta_vencimento_boleto').AsDateTime, Ano, Mes, Dia);

            // Header de arquivo - Registro 3 Segmento P
            strLinha := strLinha + PadL(FieldByName('cod_banco_compensacao').AsString, '0', 3); // Código do banco na compensação
            strLinha := strLinha + '0001'; // Lote serviço
            strLinha := strLinha + '3'; // Registro header do lote
            strLinha := strLinha + PadL(IntToStr(NumSeqLote), '0', 5); // Numero sequencial do registro no lote
            strLinha := strLinha + 'P'; // Tipo de operação
            strLinha := strLinha + PadR('', ' ', 1); // Uso exclusivo FEBRABAN
            strLinha := strLinha + '01'; // Código de movimento "01 - Entrada de títulos"
            strLinha := strLinha + PadL(FieldByName('cod_agencia_conta').AsString, '0', 5); // Agência mantenedora do banco
            strLinha := strLinha + PadR(FieldByName('cod_dv_agencia').AsString, ' ', 1); // Digito verificador da agência mantenedora do banco
            strLinha := strLinha + PadL(FieldByName('cod_conta_corrente').AsString, '0', 12); // Número da Conta corrente

            if Length(Trim(FieldByName('cod_dv_conta_corrente').AsString)) = 1 then
            begin
              strLinha := strLinha + PadR(FieldByName('cod_dv_conta_corrente').AsString, ' ', 1); // Dígito verificador da conta corrente
              strLinha := strLinha + PadR(FieldByName('cod_dv_conta_agencia').AsString, ' ', 1); // Dígito verificador da agê
            end
            else
            begin
              strLinha := strLinha + PadR(FieldByName('cod_dv_conta_corrente').AsString, ' ', 2); // Dígito verificador da conta corrente
            end;

            if (Copy(Qry.FieldByName('cod_convenio_banco').AsString, 14, 02) = '17') and (UpperCase(Qry.FieldByName('ind_gera_nosso_numero').AsString) = 'S') then
            begin
              CodConvenioBanco := RetiraZerosEsquerda(Copy(Qry.FieldByName('cod_convenio_banco').AsString, 01, 09));
              TamNumeroBanco   := 17 - Length(CodConvenioBanco);
              strLinha := strLinha + CodConvenioBanco + PadL((Qry.FieldByName('cod_boleto').AsString + Qry.FieldByName('num_parcela').AsString), '0', TamNumeroBanco) + '   '; // Identificação do título no banco
            end
            else
            begin
              strLinha := strLinha + PadR('', '0', 20); // Identificação do título no banco
            end;

            strLinha := strLinha + PadR(FieldByName('cod_carteira_banco').AsString, '0', 1); // Código da carteira
            strLinha := strLinha + '1'; // Forma de cadastramento do título no banco
            strLinha := strLinha + '1'; // Tipo de documento
            strLinha := strLinha + '1'; // Identificação da emissão do boleto
            strLinha := strLinha + '1'; // Identificação da distribuição
            strLinha := strLinha + PadR(FormatFloat('000000', FieldByName('cod_ordem_servico').AsInteger) + '.'
                                 + FormatFloat('000000', FieldByName('cod_boleto').AsInteger) + '.'
                                 + FormatFloat('0', FieldByName('num_parcela').AsInteger), ' ', 15); // Número do documento de cobrança
            strLinha := strLinha + PadL(IntToStr(Dia), '0', 2)
                                 + PadL(IntToStr(Mes), '0', 2)
                                 + PadL(IntToStr(Ano), '0', 4); // Data de vencimento do título
            strLinha := strLinha + PadL(FloatToStr(Trunc(FieldByName('val_total_boleto').AsCurrency * 100)), '0', 15); // Valor nominal do título
            strLinha := strLinha + '00000'; // Agencia encarregada da cobrança
            strLinha := strLinha + '0'; // Dígito Verifificador da agencia
            strLinha := strLinha + PadL(FieldByName('cod_especie_titulo').AsString, '0', 2); // Espécie do título
            strLinha := strLinha + FieldByName('cod_titulo_aceito').AsString; //Identificação de título aceito / não aceito

            DecodeDate(DtaSistema, Ano, Mes, Dia);

            strLinha := strLinha + PadL(IntToStr(Dia), '0', 2)
                                 + PadL(IntToStr(Mes), '0', 2)
                                 + PadL(IntToStr(Ano), '0', 4); // Data de emissão do título
            strLinha := strLinha + PadR(FieldByName('cod_tipo_juros_mora').AsString, '0', 1); // Código do juros de mora
            strLinha := strLinha + '00000000'; // Data do juros de mora
            strLinha := strLinha + PadL(FloatToStr(Trunc(FieldByName('val_juros_mora_dia_taxa').AsCurrency * 100)), '0', 15); // Juros de mora por dia / taxa
            strLinha := strLinha + '0'; // Código do desconto
            strLinha := strLinha + '00000000'; // Data do desconto
            strLinha := strLinha + PadR('', '0', 15); // Valor percentual a ser concedido
            strLinha := strLinha + PadR('', '0', 15); // Valor do IOF a ser recolhido
            strLinha := strLinha + PadR('', '0', 15); // Valor do abatimento
            strLinha := strLinha + PadR(FormatFloat('0000000000', FieldByName('cod_ordem_servico').AsInteger) + '.'
                                 + FormatFloat('0000000000', FieldByName('cod_boleto').AsInteger) + '.'
                                 + FormatFloat('0', FieldByName('num_parcela').AsInteger), ' ', 25); // Identificação do título na empresa
            strLinha := strLinha + PadR(FieldByName('cod_protesto_boleto').AsString, '0', 1); // Código para protesto
            strLinha := strLinha + PadL(FieldByName('qtd_dia_protesto').AsString, '0', 2);
            strLinha := strLinha + '2'; // Código para baixa devolução
            strLinha := strLinha + '000'; // Número de dias para baixa / devolução
            strLinha := strLinha + '09'; // Código da moeda
            strLinha := strLinha + '0000000000'; // Número do contrato da operação de credito
            strLinha := strLinha + PadR('', ' ', 1);

            // Grava registro Tipo 3 Segmento P
            if GravarLinhaNoZip(Zip, strLinha) < 0 then
            begin
              Rollback;
              Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
              Result := -1140;
              Exit;
            end;
            Inc(NumLinhasArquivo);

            strLinha := '';
            Inc(NumSeqLote);

            // Header de arquivo - Registro 3 Segmento Q
            strLinha := strLinha + PadL(FieldByName('cod_banco_compensacao').AsString, '0', 3); // Código do banco na compensação
            strLinha := strLinha + '0001'; // Lote serviço
            strLinha := strLinha + '3'; // Registro detalhe
            strLinha := strLinha + PadL(IntToStr(NumSeqLote), '0', 5); // Numero sequencial do registro no lote
            strLinha := strLinha + 'Q'; // Tipo de operação
            strLinha := strLinha + PadR('', ' ', 1); // Uso exclusivo da FEBRABAN
            strLinha := strLinha + '01'; // Código de movimento
            if UpperCase(FieldByName('cod_natureza_pessoa').AsString) = 'F' then
            begin
              strLinha := strLinha + '1'; // Tipo de inscrição
            end
            else if UpperCase(FieldByName('cod_natureza_pessoa').AsString) = 'F' then
            begin
              strLinha := strLinha + '2'; // Tipo de inscrição
            end
            else
            begin
              strLinha := strLinha + '0'; // Tipo de inscrição
            end;
            strLinha := strLinha + PadL(FieldByName('num_cnpj_cpf').AsString, '0', 15);
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('nom_pessoa').AsString, 40), ' ', 40);
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('nom_logradouro').AsString, 40), ' ', 40);
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('nom_bairro').AsString, 15), ' ', 15);
            strLinha := strLinha + Copy(FieldByName('num_cep').AsString, 01, 05);
            strLinha := strLinha + Copy(FieldByName('num_cep').AsString, 06, 03);
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('nom_municipio').AsString, 15), ' ', 15);
            strLinha := strLinha + PadR(FieldByName('sgl_estado').AsString, ' ', 2);
            strLinha := strLinha + PadR('', '0', 1); // tipo de inscrição
            strLinha := strLinha + PadR('', '0', 15); // numero de inscrição
            strLinha := strLinha + PadR('', ' ', 40); // Nome do sacador / avalista
            strLinha := strLinha + PadR('', '0', 3); // Cód. Banco Corresp. na compensação
            strLinha := strLinha + PadR('', '0', 20); // Nosso númerp no Banco Correspondente
            strLinha := strLinha + PadR('', ' ', 8); // Uso da FEBRABAN

            // Grava registro Tipo 3 Segmento Q
            if GravarLinhaNoZip(Zip, strLinha) < 0 then
            begin
              Rollback;
              Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
              Result := -1140;
              Exit;
            end;
            Inc(NumLinhasArquivo);

            strLinha := '';
            Inc(NumSeqLote);

            // Header de arquivo - Registro 3 Segmento R
            strLinha := strLinha + PadL(FieldByName('cod_banco_compensacao').AsString, '0', 3); // Código do banco na compensação
            strLinha := strLinha + '0001'; // Lote serviço
            strLinha := strLinha + '3'; // Registro detalhe
            strLinha := strLinha + PadL(IntToStr(NumSeqLote), '0', 5); // Numero sequencial do registro no lote
            strLinha := strLinha + 'R'; // Tipo de operação
            strLinha := strLinha + PadR('', ' ', 1); //Uso exclusivo da FEBRABAN
            strLinha := strLinha + '01'; // Código do movimento
            strLinha := strLinha + '1'; // Código do desconto 02
            strLinha := strLinha + PadR('', '0', 8); // Data do desconto 02
            strLinha := strLinha + PadR('', '0', 15); // Valor percentual a ser concedido 02
            strLinha := strLinha + '1'; // Código do desconto 03
            strLinha := strLinha + PadR('', '0', 8); // Data do desconto 03
            strLinha := strLinha + PadR('', '0', 15); // Valor percentual a ser concedido 03
            strLinha := strLinha + PadR('', '0', 1); // Código da multa
            strLinha := strLinha + PadR('', '0', 8); // Data da multa
            strLinha := strLinha + PadR('', '0', 15); // Valor percentual a ser aplicado
            strLinha := strLinha + PadR('', ' ', 10); // Informação do banco ao sacado
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('txt_mensagem_3').AsString , 40), ' ', 40);
            strLinha := strLinha + PadR(RedimensionaString(FieldByName('txt_mensagem_4').AsString , 40), ' ', 40);
            strLinha := strLinha + PadR('', '0', 3); // Cód do banco da conta do débito
            strLinha := strLinha + PadR('', '0', 4); // Código da agencia do debito

            strLinha := strLinha + PadR('', '0', 13); // Conta corrente / dv do debito
            strLinha := strLinha + PadR('', '0', 8); // Códigos de ocorrencia do sacado
            strLinha := strLinha + PadR('', ' ', 33); // Uso exclusivo FEBRABAN

            // Grava registro Tipo 3 Segmento R
            if GravarLinhaNoZip(Zip, strLinha) < 0 then
            begin
              Rollback;
              Mensagens.Adicionar(1140, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoZip, 'gravação']);
              Result := -1140;
              Exit;
            end;
            Inc(NumLinhasArquivo);

            Result := MudarSituacao(FieldByName('cod_boleto').AsInteger, FieldByName('num_parcela').AsInteger, 3, '');
            if Result < 0 then
            begin
              RollBack;
              Exit;
            end;

            ListaBoletosAtualizar.Add(FieldByName('cod_boleto').AsString);

            CodIdentificacaoBancaria := FieldByName('cod_identificacao_bancaria').AsInteger;
            Qry.Next;
            if Qry.Eof then
            begin
              bUltimoArquivo := True;
            end;
          end
          else
          begin
            Result := FinalizarArquivos();
            if Result < 0 then
            begin
              Exit;
            end;

            //Inicia a geração do arquivo do próximo banco
            Result := ProximoNumeroArquivoRemessa(CodIdentificacaoBancaria, CodArquivoRemessa);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end;

            CodIdentificacaoBancaria           := FieldByName('cod_identificacao_bancaria').AsInteger;
            DadosArquivo.NomArquivoZIP         := DadosArquivo.Caminho + '\' + DadosArquivo.TxtPrefixoArquivo + '_' + FieldByName('nom_reduzido_banco').AsString + '_' + FormatFloat('0000000000', CodArquivoRemessa) + '.ZIP';
            DadosArquivo.NomArquivoRemessa     := DadosArquivo.Caminho + '\' + DadosArquivo.TxtPrefixoArquivo + '_' + FieldByName('nom_reduzido_banco').AsString + '_' + FormatFloat('0000000000', CodArquivoRemessa) + '.TXT';

            NumLinhasArquivo  := 0;
            NumSeqLote        := 0;

            Result := AbrirArquivos();
            if Result < 0 then
            begin
              Exit;
            end;
          end;
        end;

        //Finaliza o último arquivo
        if bUltimoArquivo then begin
          Result := FinalizarArquivos();
          if Result < 0 then
          begin
            Exit;
          end;
        end;
      end;
      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2162, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2162;
        Exit;
      end;
    end;
  finally
    Qry.Free;
    qAux.Free;
    TxtMensagensErro.Free;
    ListaBoletosAtualizar.Free;
  end;
end;


function TIntBoletosBancario.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
 Result := FIntenderecos.Inicializar(ConexaoBD, Mensagens);
 if Result < 0 then
 begin
   Exit;
 end;
 Result := (inherited Inicializar(ConexaoBD, Mensagens));
end;

{* Insere um Boleto Bancário para uma Ordem de Serviço

   @param CodIdentificacaoBancaria Inteiro identifica o Banco o qual o boleto bancário será gerado
   @param CodOrdemServico Inteiro identifica a Ordem de Serviço a que se refere o boleto bancário a ser gerado
   @param CodenderecoCobranca Inteito identifica o endereço de cobrança referente ao boleto bancário (Classe endereco)
   @param QtdParcelas Inteiro identifica o total de parcelas que irá compor o pagamento da Ordem de Serviço
   @param ValUnitarioVendedor Currency Identifica o valor unitário que o vendedor receberá por animal da OS.
   @param ValUnitarioTecnico Currency  Identifica o valor unitário que o técnico receberá por animal da OS.
   @param ValUnitarioCertificadora Currency Identifica o valor unitário que o técnico receberá por animal da OS.
   @param DtaVencimentoBoleto String Identifica a data de vencimento do boleto bancário. Este campo será um valor multi-valorado,
                                     sendo que estas serão determinadas de acordo com o número de parcelas informadadas no
                                     parâmetro QtdParcelas.
   @param TxtMensagem3 String
   @param TxtMensagem4 String

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return -188 O método será abortado quando o usuário não tiver permissão para execução do método.
}
function TIntBoletosBancario.Inserir(ECodIdentificacaoBancaria, ECodOrdemServico,
                                     ECodenderecoCobranca, EQtdParcelas: Integer;
                                     var EValUnitarioVendedor, EValUnitarioTecnico,
                                     EValUnitarioCertificadora, EValVistoria: Double;
                                     EDtaVencimentoBoleto: String;
                                     ETxtMensagem3, ETxtMensagem4: String;
                                     ECodFormaPagamentoBoleto: Integer): Integer;
const
  CodMetodo:         Integer = 621;
  NomMetodo:         String  = 'Inserir';
  CodSituacaoBoletoNaoEnviado: Integer = 1;   // Situação "não-enviado"
  CodSituacaoBoletoCancelado:  Integer = 99;   // Situação "cancelado"
  //SQL inserção do boleto bancário
  sqlInserirBoleto: String =  ' insert into tab_boleto ' +
                              '             ( cod_boleto ' +
                              '             , cod_identificacao_bancaria ' +
                              '             , cod_ordem_servico ' +
                              '             , cod_situacao_boleto ' +
                              '             , val_total_boleto ' +
                              '             , num_parcela ' +
                              '             , dta_geracao_remessa ' +
                              '             , cod_endereco_cobranca ' +
                              '             , cod_arquivo_remessa_boleto ' +
                              '             , cod_forma_pagto_boleto ' +
                              '             , dta_vencimento_boleto ' +
                              '             , val_pago_boleto ' +
                              '             , dta_credito_efetivado ' +
                              '             , txt_mensagem_3 ' +
                              '             , txt_mensagem_4 ' +
                              '             , cod_usuario_ultima_alteracao ' +
                              '             , cod_usuario_cancelamento ' +
                              '             , dta_ultima_alteracao ' +
                              '             , dta_cadastramento ' +
                              '             ) ' +
                              '      values ( :cod_boleto ' +
                              '             , :cod_identificacao_bancaria ' +
                              '             , :cod_ordem_servico ' +
                              '             , :cod_situacao_boleto ' +
                              '             , :val_total_boleto ' +
                              '             , :num_parcela ' +
                              '             , null ' +
                              '             , :cod_endereco_cobranca ' +
                              '             , null ' +
                              '             , :cod_forma_pagto_boleto ' +
                              '             , :dta_vencimento_boleto ' +
                              '             , null ' +
                              '             , null ' +
                              '             , :txt_mensagem_3 ' +
                              '             , :txt_mensagem_4 ' +
                              '             , :cod_usuario_ultima_alteracao ' +
                              '             , null ' +
                              '             , getdate() ' +
                              '             , getdate() ' +
                              '             ) ';
var
  DtaVencimentoParcela: TStringList;
  DataVenc: TDateTime;
  CodBoleto,
  nParcela,
  NumOrdemServico,
  QtdAnimais, i, j: Integer;
  CodTituloAceito: String;
  Q, Qry: THerdomQuery;
  ValParcela, ValTotalOS: Currency;
  InfoBoleto: array of TInfoBoleto;

  function CalculaValorTotalOS(ValVendedor, ValTecnico, ValCertificadora, ValVistoria: Currency;
                               QtdAnimaisOS: Integer): Currency;
  begin
    Result := ((ValVendedor + ValTecnico + ValCertificadora) * QtdAnimaisOS) + ValVistoria;
  end;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if ECodIdentificacaoBancaria <= 0 then
  begin
    Mensagens.Adicionar(2114, Self.ClassName, NomMetodo, []);
    Result := -2114;
    Exit;
  end;

  if ECodOrdemServico <= 0 then
  begin
    Mensagens.Adicionar(2115, Self.ClassName, NomMetodo, []);
    Result := -2115;
    Exit;
  end;

  if ECodenderecoCobranca <= 0 then
  begin
    Mensagens.Adicionar(2116, Self.ClassName, NomMetodo, []);
    Result := -2116;
    Exit;
  end;

  if EQtdParcelas <= 0 then
  begin
    Mensagens.Adicionar(2117, Self.ClassName, NomMetodo, []);
    Result := -2117;
    Exit;
  end;

  if Length(Trim(EDtaVencimentoBoleto)) = 0 then
  begin
    Mensagens.Adicionar(2118, Self.ClassName, NomMetodo, []);
    Result := -2118;
    Exit;
  end;

  if (EValUnitarioVendedor <= 0) and
     (EValUnitarioTecnico <= 0)  and
     (EValUnitarioCertificadora <= 0) and
     (EValVistoria <= 0)then
  begin
    Mensagens.Adicionar(2119, Self.ClassName, NomMetodo, []);
    Result := -2119;
    Exit;
  end;

  if EValUnitarioVendedor < 0 then
  begin
    EValUnitarioVendedor := 0;
  end;

  if EValUnitarioTecnico < 0 then
  begin
    EValUnitarioTecnico := 0;
  end;

  if EValUnitarioCertificadora < 0 then
  begin
    EValUnitarioCertificadora := 0;
  end;

  if EValVistoria < 0 then
  begin
    EValVistoria := 0;
  end;

  if ECodFormaPagamentoBoleto < 0 then
  begin
    Mensagens.Adicionar(2210, Self.ClassName, NomMetodo, []);
    Result := -2210;
    Exit;
  end;


  // Validar relação parcelas e data de vencimento do boleto
  DtaVencimentoParcela := TStringList.Create;
  if (EQtdParcelas > 0) and (Length(Trim(EDtaVencimentoBoleto)) > 0) then
  begin
    Result := VerificaParametroMultiValorData(Trim(EDtaVencimentoBoleto), DtaVencimentoParcela);
    if Result < 0 then
    begin
      Exit;
    end;

    if EQtdParcelas <> DtaVencimentoParcela.Count then
    begin
      Mensagens.Adicionar(2120, Self.ClassName, NomMetodo, []);
      Result := -2120;
      Exit;
    end;

    nParcela := 0;
    DataVenc := 0;
    for i := 0 to DtaVencimentoParcela.Count - 1 do
    begin
      Inc(nParcela);
      Try
        DataVenc := StrToDate(DtaVencimentoParcela.Strings[i]);
      Except
        Mensagens.Adicionar(2121, Self.ClassName, NomMetodo, [DtaVencimentoParcela.Strings[i]]);
        Result := -2121;
        Exit;
      end;

      if DataVenc < Date then
      begin
        Mensagens.Adicionar(2122, Self.ClassName, NomMetodo, [DtaVencimentoParcela.Strings[i]]);
        Result := -2122;
        Exit;
      end;

      // Irá verificar se a data de vencimento da parcela atual é menor do que a data de vencimento de
      // alguma parcela anterior. Caso seja, a operação será abortada.
      for j := 0 to nParcela - 1 do
      begin
        if StrToDate(DtaVencimentoParcela.Strings[j]) > DataVenc then
        begin
          Mensagens.Adicionar(2123, Self.ClassName, NomMetodo, [IntToStr(nParcela), DtaVencimentoParcela.Strings[j], IntToStr(j + 1)]);
          Result := -2123;
          Exit;
        end;
      end;
    end;
  end;

  beginTran;
  Result := ProximoNumeroBoletoBancario(CodBoleto);
  if Result < 0 then
  begin
    RollBack;
    Exit;
  end;

  Result := BuscarTituloAceito(ECodIdentificacaoBancaria, CodTituloAceito);
  if Result < 0 then
  begin
    RollBack;
    Exit;
  end;

  Q   := THerdomQuery.Create(Conexao, nil);
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se existe uma OS, caso exista retorna a quantidade de animais da mesma.
      // caso não uma mensagem de alerta é retornada e o processamento parado!
      Qry.SQL.Clear;
      Qry.SQL.Add('select num_ordem_servico, qtd_animais from tab_ordem_servico');
      Qry.SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
      Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Rollback;
        Mensagens.Adicionar(2130, Self.ClassName, NomMetodo, []);
        Result := -2130;
        Exit;
      end;
      NumOrdemServico := Qry.FieldByName('num_ordem_servico').AsInteger;      
      QtdAnimais      := Qry.FieldByName('qtd_animais').AsInteger;

      Qry.SQL.Clear;
      Qry.SQL.Add('select 1 from tab_boleto');
      Qry.SQL.Add(' where cod_ordem_servico = :cod_ordem_servico');
      Qry.SQL.Add('   and cod_situacao_boleto <> :cod_situacao_boleto');
      Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
      Qry.ParamByName('cod_situacao_boleto').AsInteger := CodSituacaoBoletoCancelado;
      Qry.Open;
      if not Qry.IsEmpty then
      begin
        Rollback;
        Mensagens.Adicionar(2133, Self.ClassName, NomMetodo, [IntToStr(NumOrdemServico)]);
        Result := -2133;
        Exit;
      end;

      // Verifica se a identificação bancária informada é válida
      Qry.SQL.Clear;
      Qry.SQL.Add('select 1 from tab_identificacao_bancaria');
      Qry.SQL.Add(' where cod_identificacao_bancaria = :cod_identificacao_bancaria');
      Qry.ParamByName('cod_identificacao_bancaria').AsInteger := ECodIdentificacaoBancaria;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Rollback;
        Mensagens.Adicionar(2126, Self.ClassName, NomMetodo, []);
        Result := -2126;
        Exit;
      end;

      // Verifica se o endereço informado é válido.
      // Valida o tamanho dos campos logradouro e bairro
      Qry.SQL.Clear;
      Qry.SQL.Add('select te.nom_logradouro, te.nom_bairro, te.num_cep from tab_endereco te');
      Qry.SQL.Add(' where te.cod_endereco = :cod_endereco');
      Qry.ParamByName('cod_endereco').AsInteger := ECodenderecoCobranca;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Rollback;
        Mensagens.Adicionar(2127, Self.ClassName, NomMetodo, []);
        Result := -2127;
        Exit;
      end
      else
      begin
        if (Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) > 40) or
           (Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) = 0)  then
        begin
          Rollback;
          Mensagens.Adicionar(2128, Self.ClassName, NomMetodo, [SE(Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) > 0, Qry.FieldByName('nom_logradouro').AsString, '"logradouro não informado"')]);
          Result := -2128;
          Exit;
        end;
        if (Length(Trim(Qry.FieldByName('nom_bairro').AsString)) > 15) or
           (Length(Trim(Qry.FieldByName('nom_bairro').AsString)) = 0) then
        begin
          Rollback;
          Mensagens.Adicionar(2129, Self.ClassName, NomMetodo, [SE(Length(Trim(Qry.FieldByName('nom_bairro').AsString)) > 0, Qry.FieldByName('nom_bairro').AsString, '"bairro não informado"')]);
          Result := -2129;
          Exit;
        end;
        if Length(Trim(Qry.FieldByName('num_cep').AsString)) = 0 then
        begin
          Rollback;
          Mensagens.Adicionar(2178, Self.ClassName, NomMetodo, []);
          Result := -2178;
          Exit;
        end;
      end;

      // Verifica se a forma de pagamento é uma forma de pagamento válida.
      Qry.SQL.Clear;
      Qry.SQL.Add(' select 1 ' +
                  '   from tab_forma_pagto_boleto ' +
                  '  where cod_forma_pagto_boleto = :cod_forma_pagto_boleto ');
      Qry.ParamByName('cod_forma_pagto_boleto').AsInteger := ECodFormaPagamentoBoleto;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Rollback;
        Mensagens.Adicionar(2209, Self.ClassName, NomMetodo, []);
        Result := -2209;
        Exit;
      end;

      ValTotalOS := CalculaValorTotalOS(EValUnitarioVendedor, EValUnitarioTecnico,
                                        EValUnitarioCertificadora, EValVistoria, QtdAnimais);
      ValParcela := (Trunc((ValTotalOS / EQtdParcelas) * 100) / 100);
      // Criando uma estrutura para armazendar parcela, valor e vencimento,
      // apenas para facilitar a manipulação das
      // informações no momento em que o(s) boleto(s) for(em) inserido(s)
      SetLength(InfoBoleto, DtaVencimentoParcela.Count);
      for i := 0 to DtaVencimentoParcela.Count - 1 do
      begin
        InfoBoleto[i].NumParcelaCorrente := i + 1;
        // Caso seja a primeira parcela, e a somatória dos valores das parcelas
        // não dê o valor exato, a primeira
        // parcela será arredondada, de forma que a somatória se apresente correta.
        if (EQtdParcelas > 1) and (i = 0) then
        begin
          InfoBoleto[i].ValorParcelaCorrente  := (ValTotalOS - (ValParcela * EQtdParcelas)) + ValParcela;
        end
        else
        begin
          InfoBoleto[i].ValorParcelaCorrente  := ValParcela;
        end;
        InfoBoleto[i].DtaVencimentoCorrente := StrToDate(DtaVencimentoParcela.Strings[i]);
      end;

      Qry.SQL.Clear;
      Qry.SQL.Add(' update tab_ordem_servico ' +
                  '    set qtd_parcelas               = :qtd_parcelas ' +
                  '      , val_unitario_vendedor      = :val_unitario_vendedor ' +
                  '      , val_unitario_tecnico       = :val_unitario_tecnico ' +
                  '      , val_vistoria               = :val_vistoria ' +
                  '      , val_unitario_certificadora = :val_unitario_certificadora ' +
                  '      , val_total_os               = :val_total_os ' +
                  '  where cod_ordem_servico          = :cod_ordem_servico ');
      Qry.ParamByName('qtd_parcelas').AsInteger                := EQtdParcelas;
      Qry.ParamByName('val_unitario_vendedor').AsCurrency      := EValUnitarioVendedor;
      Qry.ParamByName('val_unitario_tecnico').AsCurrency       := EValUnitarioTecnico;
      Qry.ParamByName('val_vistoria').AsCurrency               := EValVistoria;
      Qry.ParamByName('val_unitario_certificadora').AsCurrency := EValUnitarioCertificadora;
      Qry.ParamByName('val_total_os').AsFloat                  := ValTotalOS;
      Qry.ParamByName('cod_ordem_servico').AsInteger           := ECodOrdemServico;
      Qry.ExecSQL;

      for i := 0 to DtaVencimentoParcela.Count - 1 do
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add(sqlInserirBoleto);
        Qry.ParamByName('cod_boleto').AsInteger                   := CodBoleto;
        Qry.ParamByName('cod_identificacao_bancaria').AsInteger   := ECodIdentificacaoBancaria;
        Qry.ParamByName('cod_ordem_servico').AsInteger            := ECodOrdemServico;
        Qry.ParamByName('cod_situacao_boleto').AsInteger          := CodSituacaoBoletoNaoEnviado;
        Qry.ParamByName('val_total_boleto').AsCurrency            := InfoBoleto[i].ValorParcelaCorrente;
        Qry.ParamByName('num_parcela').AsInteger                  := InfoBoleto[i].NumParcelaCorrente;
        Qry.ParamByName('cod_endereco_cobranca').AsInteger        := ECodenderecoCobranca;
        Qry.ParamByName('cod_forma_pagto_boleto').AsInteger       := ECodFormaPagamentoBoleto;
        Qry.ParamByName('dta_vencimento_boleto').AsDateTime       := InfoBoleto[i].DtaVencimentoCorrente;
        Qry.ParamByName('txt_mensagem_3').AsString                := ETxtMensagem3;
        Qry.ParamByName('txt_mensagem_4').AsString                := ETxtMensagem4;
        Qry.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        Qry.ExecSQL;

        Result := InserirHistoricoMudancaSituacao(CodBoleto, InfoBoleto[i].NumParcelaCorrente, CodSituacaoBoletoNaoEnviado,
                                                  'Inserção do boleto bancário para OS: ' + IntToStr(NumOrdemServico) +
                                                  ', parcela: ' + IntToStr(InfoBoleto[i].NumParcelaCorrente) + '.');
        if Result < 0 then
        begin
          Exit;
        end;
      end;

      Commit;
      Result := CodBoleto;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2131, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2131;
        Exit;
      end;
    end;
  finally
    Qry.Free;
    Q.Free;
    SetLength(InfoBoleto, 0);
    if Assigned(DtaVencimentoParcela) then
    begin
      DtaVencimentoParcela.Free;
      DtaVencimentoParcela := nil;
    end;
  end;
end;


{* Função interna.
   Função respónsável por gerar o registro referente ao arquivo de remessa de
   boletos bancários. Insere na tab_arquivo_remessa_boleto, os dados referentes ao
   arquivo gerado pelo método GerarRemessa

   @param ECodArquivoRemessaBoleto Inteiro
   @param ECodTipoArquivoRemessaBoleto Inteiro
   @param ENomArquivo String
   @param EQtdBytesArquivo Inteiro
   @param EIndPossuiLogErro String

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -2153 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.InserirArquivoRemessaBoleto(ECodArquivoRemessaBoleto,
                                                         ECodTipoArquivoRemessaBoleto: Integer;
                                                         ENomArquivo: String;
                                                         EQtdBytesArquivo: Integer;
                                                         EIndPossuiLogErro: String): Integer;
const
  NomMetodo: String = 'InserirArquivoRemessaBoleto';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      beginTran;

      Qry.SQL.Clear;
      Qry.SQL.Add(' insert into tab_arquivo_remessa_boleto ' +
                  '             ( cod_arquivo_remessa_boleto ' +
                  '             , cod_tipo_arquivo_boleto ' +
                  '             , nom_arquivo_remessa_boleto ' +
                  '             , dta_criacao_arquivo ' +
                  '             , qtd_bytes_arquivo ' +
                  '             , ind_possui_log_erro ' +
                  '             , cod_usuario ) ' +
                  '      values ( :cod_arquivo_remessa_boleto ' +
                  '             , :cod_tipo_arquivo_boleto ' +
                  '             , :nom_arquivo_remessa_boleto ' +
                  '             , getdate() ' +
                  '             , :qtd_bytes_arquivo ' +
                  '             , :ind_possui_log_erro ' +
                  '             , :cod_usuario ) ');
      Qry.ParamByName('cod_arquivo_remessa_boleto').AsInteger := ECodArquivoRemessaBoleto;
      Qry.ParamByName('cod_tipo_arquivo_boleto').AsInteger := ECodTipoArquivoRemessaBoleto;
      Qry.ParamByName('nom_arquivo_remessa_boleto').AsString := ExtractFileName(ENomArquivo);
      Qry.ParamByName('qtd_bytes_arquivo').AsInteger := EQtdBytesArquivo;
      Qry.ParamByName('ind_possui_log_erro').AsString := EIndPossuiLogErro;
      Qry.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Qry.ExecSQL;

      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        RollBack;
        Mensagens.Adicionar(2153, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2153;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Função responsável por inserir um registro referente ao upload do arquivo,
   realizado pela aplicação WEB, na tabela tab_arq_import_boleto.

   @param ECodArquivoImportacao Inteiro Parâmetro obrigatório. Código do arquivo
                                        de importação que deverá ser inserido na
                                        base de dados.
   @param ENomArquivoImportacao String Parâmetro obrigatório. Nome do arquivo de
                                       importação que deverá ser inserido na base
                                       de dados. Nome interno do sistema.
   @param ENomArquivoUpload String Parâmetro obrigatório. Nome do arquivo de
                                       importação que deverá ser inserido na base
                                       de dados. Nome de upload do arquivo.
   @param ETxtDados String Parâmetro opcional. 
   @param ESituacaoArqImport Char Parâmetro obrigatório. Situação que do arquivo.
                                  Arquivo não processado, ou arquivo inválido.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -2164 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.

}
function TIntBoletosBancario.InserirArquivoUpLoad(ECodArquivoImportacao: Integer;
                                                  ENomArquivoImportacao,
                                                  ENomArquivoUpload: String;
                                                  ETxtDados: String;
                                                  ESituacaoArqImport: Char): Integer;
const
  NomeMetodo: String = 'InserirArquivoUpLoad';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Text :=
        'insert into tab_arq_import_boleto ' +
        ' (  cod_arq_import_boleto ' +
        '  , nom_arq_upload ' +
        '  , nom_arq_import_boleto ' +
        '  , dta_importacao ' +
        '  , cod_situacao_arq_import ' +
        '  , qtd_registros_total ' +
        '  , qtd_registros_errados ' +
        '  , qtd_registros_processados ' +
        '  , cod_usuario_upload ' +
        '  , cod_tarefa ' +
        '  , cod_tipo_arquivo_boleto ' +
        '  , txt_mensagem ) '+
        'values '+
        ' (  :cod_arq_import_boleto ' +
        '  , :nom_arq_upload ' +
        '  , :nom_arq_import_boleto ' +
        '  , getdate() ' +
        '  , :cod_situacao_arq_import ' +
        '  , null ' +
        '  , null ' +
        '  , null ' +
        '  , :cod_usuario_upload ' +
        '  , null ' +
        '  , 2 ' +
        '  , :txt_mensagem ) ';
      Q.ParamByName('cod_arq_import_boleto').AsInteger      := ECodArquivoImportacao;
      Q.ParamByName('nom_arq_upload').AsString              := ENomArquivoUpload;
      Q.ParamByName('nom_arq_import_boleto').AsString       := ENomArquivoImportacao;
      Q.ParamByName('cod_situacao_arq_import').AsString     := ESituacaoArqImport;
      Q.ParamByName('cod_usuario_upload').AsInteger         := Conexao.CodUsuario;
      Q.ParamByName('txt_mensagem').AsString                := ETxtDados;
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


{* Função responsável por inserir no banco de dados, tabela tab_erro_remessa_boleto,
   os erros ocorridos durante a geração do arquivo de remessa.

   @param ECodArquivoRemessaBoleto Inteiro Parâmetro obrigatório. Indica o arquivo
                                   de remessa que ocasionou o erro.
   @param ETxtMensagemErro String Parâmetro obrigatório. Indida a mensagem de erro,
                                  gerada durante a geração do arquivo de remessa.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -2152 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.

}
function TIntBoletosBancario.InserirErroRemessaBoleto(ECodArquivoRemessaBoleto: Integer;
                                                      ETxtMensagemErro: String): Integer;
const
  NomMetodo: String = 'InserirErroRemessaBoleto';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      beginTran;

      Qry.SQL.Clear;
      Qry.SQL.Add(' insert into tab_erro_remessa_boleto ' +
                  '             ( cod_arquivo_remessa_boleto ' +
                  '             , txt_mensagem_erro ) ' +
                  '      values ( :cod_arquivo_remessa_boleto ' +
                  '             , :txt_mensagem_erro ) ');
      Qry.ParamByName('cod_arquivo_remessa_boleto').AsInteger := ECodArquivoRemessaBoleto;
      Qry.ParamByName('txt_mensagem_erro').AsString := ETxtMensagemErro;
      Qry.ExecSQL;

      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2152, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2152;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Função responsável por inserir um histórico para o boleto bancário gerado

   @param ECodBoleto Inteiro Parâmetro obrigatório. Indica o boleto bancário que
                             o histórico será gerado.  
   @param ENumParcela Inteiro Parãmetro obrigatório. Indica a parcela do boleto
                              bancário, que o histórico será gerado.
   @param ECodSituacaoBoleto Inteiro Parâmetro obrigátório. Indica a nova situação
                                     que o boleto/parcela irá assumir. 
   @param ETxtObservacao String Parâmetro opcional. Informação complementar a ser
                                inserida durante a mudança de situação.

   @return 0     Valor retornado caso seja executado com sucesso.
   @return -2132 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.InserirHistoricoMudancaSituacao(ECodBoleto,
                                                             ENumParcela,
                                                             ECodSituacaoBoleto: Integer;
                                                             ETxtObservacao: String): Integer;
const
  NomMetodo: String = 'InserirHistoricoMudancaSituacao';
  CodSituacaoProntoEnvio: Integer = 2;
  CodSituacaoCancelado:   Integer = 99;
var
  Q, Qry: THerdomQuery;
begin
  Q   := THerdomQuery.Create(Conexao, nil);
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Clear;
      Q.SQL.Add(' select num_parcela ' +
                  '   from tab_boleto ' +
                  '  where cod_boleto = :cod_boleto ');
      if not ((ECodSituacaoBoleto = CodSituacaoProntoEnvio) or
         (ECodSituacaoBoleto = CodSituacaoCancelado)) then
      begin
        Q.SQL.Add('    and num_parcela = :num_parcela ');
        Q.ParamByName('num_parcela').AsInteger := ENumParcela;
      end;
      Q.SQL.Add('      and cod_situacao_boleto = :cod_situacao_boleto ');
      Q.SQL.Add('order by cod_boleto, num_parcela');
      Q.ParamByName('cod_boleto').AsInteger := ECodBoleto;
      Q.ParamByName('cod_situacao_boleto').AsInteger := ECodSituacaoBoleto;
      Q.Open;

      begintran;
      while not Q.eof do
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add(' insert into tab_historico_situacao_boleto ' +
                    '             ( cod_boleto ' +
                    '             , num_parcela ' +
                    '             , cod_situacao_boleto ' +
                    '             , cod_usuario_alteracao ' +
                    '             , dta_mudanca_situacao ' +
                    '             , txt_observacao ' +
                    '             ) ' +
                    '      values ( :cod_boleto ' +
                    '             , :num_parcela ' +
                    '             , :cod_situacao_boleto ' +
                    '             , :cod_usuario_alteracao ' +
                    '             , getdate() ' +
                    '             , :txt_observacao ' +
                    '             ) ');
        Qry.ParamByName('cod_boleto').AsInteger            := ECodBoleto;
        Qry.ParamByName('num_parcela').AsInteger           := Q.FieldByName('num_parcela').AsInteger;
        Qry.ParamByName('cod_situacao_boleto').AsInteger   := ECodSituacaoBoleto;
        Qry.ParamByName('cod_usuario_alteracao').AsInteger := Conexao.CodUsuario;
        Qry.ParamByName('txt_observacao').AsString         := ETxtObservacao;
        Qry.ExecSQL;
        Q.Next;
      end;
      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2132, Self.ClassName, NomMetodo, [e.message]);
        Result := -2132;
        Exit;
      end;
    end;
  finally
    Q.Free;
    Qry.Free;
  end;
end;


{* Função responsável por limpar todos os atributos (valores padrões) da classe.
}
procedure TIntBoletosBancario.LimparAtributos;
begin
  FIntBoletoBancario.CodOrdemServico           := -1;
  FIntBoletoBancario.CodBoletoBancario         := -1;
  FIntBoletoBancario.CodIdentificacaoBancaria  := -1;
  FIntBoletoBancario.NomBanco                  := '';
  FIntBoletoBancario.NomReduzidoBanco          := '';
  FIntBoletoBancario.CodSituacaoBoleto         := '';
  FIntBoletoBancario.SglSituacaoBoleto         := '';
  FIntBoletoBancario.DesSituacaoBoleto         := '';
  FIntBoletoBancario.NomPessoaProdutor         := '';
  FIntBoletoBancario.NumCNPJCPF                := '';
  FIntBoletoBancario.NumCNPJCPFFormatado       := '';
  FIntBoletoBancario.NomPropriedadeRural       := '';
  FIntBoletoBancario.NumImovelReceitaFederal   := '';
  FIntBoletoBancario.DtaGeracaoRemessa         := 0;
  FIntBoletoBancario.DtaVencimentoBoleto       := 0;
  FIntBoletoBancario.NumParcela                := -1;
  FIntBoletoBancario.ValTotalBoleto            := 0;
  FIntBoletoBancario.QtdAnimais                := -1;
  FIntBoletoBancario.ValUnitarioVendedor       := 0;
  FIntBoletoBancario.ValUnitarioTecnico        := 0;
  FIntBoletoBancario.ValUnitarioCertificadora  := 0;
  FIntBoletoBancario.ValTotalOS                := 0;
  FIntBoletoBancario.QtdParcelas               := -1;
  FIntBoletoBancario.ValPagoBoleto             := 0;
  FIntBoletoBancario.DtaCreditoEfetivado       := 0;
  FIntBoletoBancario.CodUsuarioUltimaAlteracao := -1;
  FIntBoletoBancario.NomUsuarioUltimaAlteracao := '';
  FIntBoletoBancario.CodUsuarioCancelamento    := -1;
  FIntBoletoBancario.NomUsuarioCancelamento    := '';
  FIntBoletoBancario.DtaUltimaAlteracao        := 0;
  FIntBoletoBancario.TxtMensagem3              := '';
  FIntBoletoBancario.TxtMensagem4              := '';
  FIntBoletoBancario.NomReduzidoBanco          := '';
  // Informações do endereço de cobrança!
  FIntBoletoBancario.enderecoCobranca.Codendereco      := -1;
  FIntBoletoBancario.enderecoCobranca.CodTipoendereco  := -1;
  FIntBoletoBancario.enderecoCobranca.SglTipoendereco  := '';
  FIntBoletoBancario.enderecoCobranca.DesTipoendereco  := '';
  FIntBoletoBancario.enderecoCobranca.NomPessoaContato := '';
  FIntBoletoBancario.enderecoCobranca.NumTelefone      := '';
  FIntBoletoBancario.enderecoCobranca.NumFax           := '';
  FIntBoletoBancario.enderecoCobranca.TxtEMail         := '';
  FIntBoletoBancario.enderecoCobranca.NomLogradouro    := '';
  FIntBoletoBancario.enderecoCobranca.NumCEP           := '';
  FIntBoletoBancario.enderecoCobranca.NomBairro        := '';
  FIntBoletoBancario.enderecoCobranca.CodDistrito      := -1;
  FIntBoletoBancario.enderecoCobranca.NomDistrito      := '';
  FIntBoletoBancario.enderecoCobranca.CodMunicipio     := -1;
  FIntBoletoBancario.enderecoCobranca.NumMunicipioIBGE := '';
  FIntBoletoBancario.enderecoCobranca.NomMunicipio     := '';
  FIntBoletoBancario.enderecoCobranca.CodEstado        := -1;
  FIntBoletoBancario.enderecoCobranca.SglEstado        := '';
  FIntBoletoBancario.enderecoCobranca.NomEstado        := '';
  FIntBoletoBancario.enderecoCobranca.CodPais          := -1;

  // Informações da importação do arquivo de retorno
  FIntBoletoBancario.CodArqImportBoleto      := -1;
  FIntBoletoBancario.NomArqUpLoad            := '';
  FIntBoletoBancario.NomArqImportBoleto      := '';
  FIntBoletoBancario.DtaImportacao           := 0;
  FIntBoletoBancario.QtdRegistrosTotal       := -1;
  FIntBoletoBancario.QtdRegistrosErrados     := -1;
  FIntBoletoBancario.QtdRegistrosProcessados := -1;
  FIntBoletoBancario.DtaProcessamento        := 0;
  FIntBoletoBancario.CodUsuarioUpLoad        := -1;
  FIntBoletoBancario.NomUsuarioUpLoad        := '';
  FIntBoletoBancario.CodTarefa               := -1;
  FIntBoletoBancario.CodTipoArquivoBoleto    := -1;
  FIntBoletoBancario.DesTipoArquivoBoleto    := '';
  FIntBoletoBancario.DesTipoArquivoBoleto    := '';
  FIntBoletoBancario.TxtMensagem             := '';
end;


{* Função responsável por Mudar a situação de um boleto bancário

   @param CodBoleto Inteiro Parâmetro com o código do boleto bancário que será
          terá sua situação alterada.
   @param CodSituacaoDestino Parâmetro com o código da situação para que o boleto
          deverá ser alterada.

   @return -188  Valor retornado caso o usuário logado no sistema não tenha
                 permissão para executar o método.
   @return -2136 Valor retornado caso o boleto informado no parâmetro CodBoleto
                 não seja encontrado na base de dados.
   @return -2142 Valor retornado caso a situação atual do boleto informado seja
                 cancelado (99), neste caso, o boleto não poderá ter sua situação
                 alterada.
   @return -2143 Valor retornado caso a prioridade de destino da situação do boleto
                 seja menor do que a prioridade atual da situação que o boleto se
                 encontra.
   @return -2144 Valor retornado caso ocorra alguma exceção durante a execução do
                 método.
}
function TIntBoletosBancario.MudarSituacao(CodBoleto, NumParcela,
                                           CodSituacaoDestino: Integer;
                                           TxtObservacao: String): Integer;
const
  NomMetodo: String = 'MudarSituacao';
  CodMetodo: Integer = 623;
  CodSituacaoBoletoCancelado: Integer = 99;
  CodSituacaoProntoEnvio: Integer = 2;
var
  Qry: THerdomQuery;
  CodOrdemServico,
  CodenderecoCobranca,
  CodSituacaoOrigem,
  CodPrioridadeOrigem,
  CodPrioridadeDestino: Integer;
  MudancaSituacao: TMudancaSituacao;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if (not (CodSituacaoDestino in [2, 99])) and (NumParcela <= 0) then
  begin
    Mensagens.Adicionar(2151, Self.ClassName, NomMetodo, []);
    Result := -2151;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se o boleto bancário é um boleto bancário válido.
      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_situacao_boleto ' +
                  '     , cod_ordem_servico ' +
                  '     , cod_endereco_cobranca ' +
                  '  from tab_boleto');
      Qry.SQL.Add(' where cod_boleto = :cod_boleto');
      if NumParcela > 0 then
      begin
        Qry.SQL.Add(' and num_parcela = :num_parcela');
      end;
      Qry.ParamByName('cod_boleto').AsInteger  := CodBoleto;
      if NumParcela > 0 then
      begin
        Qry.ParamByName('num_parcela').AsInteger := NumParcela;
      end;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2136, Self.ClassName, NomMetodo, []);
        Result := -2136;
        Exit;
      end;
      CodOrdemServico := Qry.FieldByName('cod_ordem_servico').AsInteger;
      CodenderecoCobranca := Qry.FieldByName('cod_endereco_cobranca').AsInteger;

      // Busca prioridade da situacao de origem, e valida se é uma situacao válida!
      CodSituacaoOrigem := Qry.FieldByName('cod_situacao_boleto').AsInteger;
      Result := BuscarCodigoPrioridadeSituacao(CodSituacaoOrigem, CodPrioridadeOrigem);
      if Result < 0 then
      begin
        Exit;
      end;

      Qry.SQL.Clear;
      Qry.SQL.Add(' select nom_logradouro ' +
                  '      , nom_bairro ' +
                  '      , num_cep ' +
                  '   from tab_endereco ' +
                  '  where cod_endereco = :cod_endereco ');
      Qry.ParamByName('cod_endereco').AsInteger := CodenderecoCobranca;
      Qry.Open;
      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2127, Self.ClassName, NomMetodo, []);
        Result := -2127;
        Exit;
      end;

      if (Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) = 0)  or
         (Length(Trim(Qry.FieldByName('nom_logradouro').AsString)) > 40) then
      begin
        Mensagens.Adicionar(2128, Self.ClassName, NomMetodo, []);
        Result := -2128;
        Exit;
      end;
      if (Length(Trim(Qry.FieldByName('nom_bairro').AsString)) = 0)  or
         (Length(Trim(Qry.FieldByName('nom_bairro').AsString)) > 15) then
      begin
        Mensagens.Adicionar(2129, Self.ClassName, NomMetodo, [Qry.FieldByName('nom_bairro').AsString]);
        Result := -2129;
        Exit;
      end;
      if Length(Trim(Qry.FieldByName('num_cep').AsString)) = 0 then
      begin
        Mensagens.Adicionar(2178, Self.ClassName, NomMetodo, []);
        Result := -2178;
        Exit;
      end;      

      // Se a situação atual do boleto for cancelado
      if CodSituacaoOrigem = CodSituacaoBoletoCancelado then
      begin
        Mensagens.Adicionar(2142, Self.ClassName, NomMetodo, []);
        Result := -2142;
        Exit;
      end;

      // Busca prioridade da situacao de destino, e valida se é uma situacao válida!
      Result := BuscarCodigoPrioridadeSituacao(CodSituacaoDestino, CodPrioridadeDestino);
      if Result < 0 then
      begin
        Exit;
      end;      

      // Verifica se a mudança de situação é permitida pelo sistema 
      MudancaSituacao.CodSituacaoOrigemBoleto  := CodSituacaoOrigem;
      MudancaSituacao.CodSituacaoDestinoBoleto := CodSituacaoDestino;      
      Result := VerificaMudancaSituacao(MudancaSituacao);
      if Result < 0 then
      begin
        Exit;
      end;

      // Caso a prioridade de origem seja maior que a prioridade de destino lançar uma mensagem
      // informando que a prioridade de destino deve ser maior que a de origem!
      if CodPrioridadeOrigem >= CodPrioridadeDestino then
      begin
        Mensagens.Adicionar(2143, Self.ClassName, NomMetodo, []);
        Result := -2143;
        Exit;
      end;

      begintran;
      if (UpperCase(MudancaSituacao.IndAtualizaSituacao) = 'S') then
      begin
        // Atualiza situação do boleto
        Qry.SQL.Clear;
        Qry.SQL.Add('update tab_boleto');
        Qry.SQL.Add('   set cod_situacao_boleto          = :cod_situacao_boleto');

        if CodSituacaoDestino = CodSituacaoBoletoCancelado then
        begin
          Qry.SQL.Add('   , cod_usuario_cancelamento     = :cod_usuario_cancelamento');
        end;

        Qry.SQL.Add('     , dta_ultima_alteracao         = getdate()');
        Qry.SQL.Add('     , cod_usuario_ultima_alteracao = :cod_usuario_ultima_alteracao');
        Qry.SQL.Add(' where cod_boleto                   = :cod_boleto');

        if (NumParcela > 0) and (CodSituacaoDestino <> CodSituacaoBoletoCancelado) and
           (CodSituacaoDestino <> CodSituacaoProntoEnvio) then
        begin
          Qry.SQL.Add(' and num_parcela = :num_parcela');
        end;
        if CodSituacaoDestino = CodSituacaoProntoEnvio then
        begin
          Qry.SQL.Add(' and cod_situacao_boleto = 1');
        end;

        Qry.SQL.Add('   and cod_ordem_servico = :cod_ordem_servico');

        Qry.ParamByName('cod_ordem_servico').AsInteger      := CodOrdemServico;
        Qry.ParamByName('cod_boleto').AsInteger             := CodBoleto;

        if (NumParcela > 0) and (CodSituacaoDestino <> CodSituacaoBoletoCancelado) and
           (CodSituacaoDestino <> CodSituacaoProntoEnvio) then
        begin
          Qry.ParamByName('num_parcela').AsInteger          := NumParcela;
        end;

        Qry.ParamByName('cod_usuario_ultima_alteracao').AsInteger := Conexao.CodUsuario;
        Qry.ParamByName('cod_situacao_boleto').AsInteger    := CodSituacaoDestino;

        if CodSituacaoDestino = CodSituacaoBoletoCancelado then
        begin
          Qry.ParamByName('cod_usuario_cancelamento').AsInteger := Conexao.CodUsuario;
        end;
        Qry.ExecSQL;

        if CodSituacaoDestino = CodSituacaoBoletoCancelado then
        begin
          Qry.SQL.Clear;
          Qry.SQL.Add('update tab_ordem_servico');
          Qry.SQL.Add('   set qtd_parcelas                = null');
          Qry.SQL.Add('     , val_unitario_vendedor       = null');
          Qry.SQL.Add('     , val_unitario_tecnico        = null');
          Qry.SQL.Add('     , val_unitario_certificadora  = null');
          Qry.SQL.Add('     , val_total_os                = null');
          Qry.SQL.Add(' where cod_ordem_servico           = :cod_ordem_servico');
          Qry.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
          Qry.ExecSQL;
        end;
      end;

      Result := InserirHistoricoMudancaSituacao(CodBoleto, NumParcela,
                                                CodSituacaoDestino,
                                                SE(Length(Trim(TxtObservacao)) > 0, TxtObservacao, MudancaSituacao.TxtMensagemLog));
      if Result < 0 then
      begin
        Exit;
      end;

      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2144, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2144;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Busca o próximo código sequencial para compor a chave primária da tab_seq_arq_import_boleto

   @param ECodArquivoImportacao Inteiro, que irá receber o valor do código
          sequencial obtido da tab_seq_arq_import_boleto, através da leitura do
          campo cod_seq_arq_import_boleto da respectiva tabela incrementado de
          uma unidade

   @return 0 caso o método seja executado com sucesso
   @return -1 caso ocorra alguma falha durante a execução do método
}
function TIntBoletosBancario.ObterCodArquivoImportacao(var ECodArquivoImportacao: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArquivoImportacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre transação
      beginTran('PEGA_SEQ_CODIGO');

      // Pega próximo código
      Q.SQL.Clear;
      Q.SQL.Add('select isnull(max(cod_seq_arq_import_boleto), 0) + 1 as CodArqImportacao from tab_seq_arq_import_boleto');
      Q.Open;

      ECodArquivoImportacao := Q.FieldByName('CodArqImportacao').AsInteger;
      Q.SQL.Clear;
      Q.SQL.Add('update tab_seq_arq_import_boleto set cod_seq_arq_import_boleto  = cod_seq_arq_import_boleto + 1');
      Q.ExecSQL;
      // Fecha a transação
      Commit('PEGA_SEQ_CODIGO');
      // Identifica procedimento como bem sucedido
      Result := ECodArquivoImportacao;
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


{* Função responsável por validar os dados da certificadora.

   @param ENomCertificadora String 
   @ENumCNPJCertificadora String

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return -1210 Valor retornado caso não seja encontrado os dados referentes a
                 Certificadora.
   @return -1211 Valor retornado caso ocorra alguma exceção durante a execução do
                 método.
}
function TIntBoletosBancario.ObterDadosCertificadora(var ENomCertificadora,
                                                     ENumCNPJCertificadora: String;
                                                     AOwner: TObject): Integer;
const
  NomMetodo: String = 'ObterDadosCertificadora';
var
  Conexao: TConexao;
  Mensagens: TIntMensagens;
  Q: THerdomQuery;
begin
  if (AOwner is TIntBoletosBancario) then begin
    Conexao := TIntBoletosBancario(AOwner).Conexao;
    Mensagens := TIntBoletosBancario(AOwner).Mensagens;
  end else if (AOwner is TThrProcessarArquivoBoleto) then begin
    Conexao := TThrProcessarArquivoBoleto(AOwner).Conexao;
    Mensagens := TThrProcessarArquivoBoleto(AOwner).Mensagens;
  end else begin
    Raise Exception.CreateResFmt(8, [AOwner.ClassName, AOwner.ClassName + NomMetodo]);
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Text := ' select ' +
                    '        tp.nom_pessoa as NomCertificadora ' +
                    '      , num_cnpj_cpf as NumCNPJCertificadora ' +
                    ' from ' +
                    '      tab_pessoa tp ' +
                    '    , tab_parametro_sistema tps ' +
                    ' where '+
                    '       tp.cod_pessoa = CAST(tps.val_parametro_sistema AS int) ' +
                    '   and tps.cod_parametro_sistema = 4 ';
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1210, AOwner.ClassName, NomMetodo, []);
        Result := -1210;
        Exit;
      end;
      ENomCertificadora := Q.FieldByName('NomCertificadora').AsString;
      ENumCNPJCertificadora := Q.FieldByName('NumCNPJCertificadora').AsString;
      Q.Close;
      // Identifica procedimento como bem sucedido
      Result := 0;
    Except
      On E: Exception do begin
        Mensagens.Adicionar(1211, AOwner.ClassName, NomMetodo, [E.Message]);
        Result := -1211;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;


{* Função responsável por pesquisar os boletos bancários cadastrados no sistema.
   Caso o parmâmetro CodOrdemServico, seja informado, a consulta realizada na
   tab_boleto, deverá ser filtrada pela OS, caso contrário, todos os boletos
   deverá ser mostrados

   @param ECodOrdemServico Inteiro Parâmetro opcional, que irá indicar a relação
                                   dos boletos bancários e a ordem de serviço.

   @return 0     Valor retornado quando o método for executado com sucesso. 
   @return -188  Valor retornado caso o usuário logado no sistema não tenha
                 permissão para executar o método.
   @return -2144 Valor retornado caso ocorra alguma exceção durante a execução
                 do método.

}
function TIntBoletosBancario.Pesquisar(CodOrdemServico: Integer): Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 626 ;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;
  
  try
    Query.SQL.Clear;
    Query.SQL.Add(' select tb.cod_ordem_servico          as CodOrdemServico ');
    Query.SQL.Add('      , tb.cod_boleto                 as CodBoleto ');
    Query.SQL.Add('      , tb.num_parcela                as NumParcela ');
    Query.SQL.Add('      , tb.cod_identificacao_bancaria as CodIdentificacaoBancaria ');
    Query.SQL.Add('      , tib.nom_banco                 as NomBanco ');
    Query.SQL.Add('      , tib.nom_reduzido_banco        as NomReduzidoBanco ');    
    Query.SQL.Add('      , tb.cod_situacao_boleto        as CodSituacaoBoleto ');
    Query.SQL.Add('      , tsb.sgl_situacao_boleto       as SglSituacaoBoleto ');
    Query.SQL.Add('      , tsb.des_situacao_boleto       as DesSituacaoBoleto ');
    Query.SQL.Add('      , tb.dta_vencimento_boleto      as DtaVencimentoBoleto ');
    Query.SQL.Add('      , tb.val_total_boleto           as ValTotalBoleto ');    
    Query.SQL.Add('   from tab_boleto tb');
    Query.SQL.Add('      , tab_situacao_boleto tsb');
    Query.SQL.Add('      , tab_identificacao_bancaria tib');        
    Query.SQL.Add('  where tb.cod_identificacao_bancaria = tib.cod_identificacao_bancaria ');
    Query.SQL.Add('    and tb.cod_situacao_boleto        = tsb.cod_situacao_boleto ');
    if CodOrdemServico > 0 then
    begin
      Query.SQL.Add('  and tb.cod_ordem_servico          = :cod_ordem_servico ');
      Query.ParamByName('cod_ordem_servico').AsInteger := CodOrdemServico;
    end;
    Query.SQL.Add('order by tb.cod_boleto desc, tb.num_parcela asc');

    Query.Open;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2144, Self.ClassName, NomMetodo, [e.Message]);
      Result := -2144;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar os erros ocorridos durante a importação de um
   arquivo remessa de boletos bancários.

   @param ECodArquivoImportacao Inteiro

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2173 Retorno caso o parâmetro ECodArquivoImportacao não seja informado
   @return -2175 Retorno caso seja gerada alguma exceção durante a execução do
                 método.
}
function TIntBoletosBancario.PesquisarErrosImportacao(ECodArquivoImportacao: Integer): Integer;
const
  NomMetodo: String = 'PesquisarErroImportacao';
  CodMetodo: Integer = 638;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if ECodArquivoImportacao <= 0 then
  begin
    Mensagens.Adicionar(2173, Self.ClassName, NomMetodo, []);
    Result := -2173;
    Exit;
  end;
  
  try
    with Query do
    begin
      SQL.Clear;
      SQL.Add(' select cod_arq_import_boleto as CodArqImportBoleto ' +
              '      , txt_mensagem_erro     as TxtMensagemErro ' +
              '   from tab_erro_import_boleto ' +
              '  where cod_arq_import_boleto = :cod_arq_import_boleto ');
      ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
      Open;
    end;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2175, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2175;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar os erros que ocorreram na geração do arquivo
   de remessa.

   @param ECodArquivoRemessa Inteiro Parâmetro obrigatório, código do arquivo
                                     de remessa gerado.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -188  Valor retornado caso o usuário logado no sistema não possua
                 permissão para executar o método.
   @return -2148 Valor retornado caso o parâmetro ECodArquivoRemessa não tenha
                 sido informado.
   @return -2149 Valor retornado caso ocorra alguma exceção durante a execução.
}
function TIntBoletosBancario.PesquisarErroRemessa(ECodArquivoRemessa: Integer): Integer;
const
  NomMetodo: String = 'PesquisarErroRemessa';
  CodMetodo: Integer = 628;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if ECodArquivoRemessa <= 0 then
  begin
    Mensagens.Adicionar(2148, Self.ClassName, NomMetodo, []);
    Result := -2148;
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add('select cod_arquivo_remessa_boleto as CodArquivoRemessaBoleto');
    Query.SQL.Add('     , txt_mensagem_erro  as TxtMensagemErro');
    Query.SQL.Add('  from tab_erro_remessa_boleto');
    Query.SQL.Add(' where cod_arquivo_remessa_boleto = :cod_arquivo_remessa_boleto');
    Query.ParamByName('cod_arquivo_remessa_boleto').AsInteger := ECodArquivoRemessa;
    Query.Open;

    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2149, Self.ClassName, NomMetodo, [e.Message]);
      Result := -2149;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar os dados de importação dos arquivos de
   retorno, processados pelos bancos.

   @param ECodSituacaoArquivo String
   @param ENomArquivoUpLoad String
   @param ENomUsuario String
   @param EDtaImportacaoInicio Date
   @param EDtaImportacaoFim Date
   @param EDtaProcessamentoInicio Date
   @param EDtaProcessamentoFim Date

   @return -0    Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2182 Retorno caso a data de importação inicial seja maior do que a
                 data final.
   @return -2183 Retorno caso a data de processamento inicial seja maior do que
                 a data final.
   @return -2177 Retorno caso ocorra alguma exceção na execução do método.
}
function TIntBoletosBancario.PesquisarImportacaoBoleto(ECodSituacaoArquivo,
                                                       ENomArquivoUpLoad,
                                                       ENomUsuario: String;
                                                       EDtaImportacaoInicio,
                                                       EDtaImportacaoFim,
                                                       EDtaProcessamentoInicio,
                                                       EDtaProcessamentoFim: TDateTime): Integer;
const
  NomMetodo: String = 'PesquisarImportacaoBoleto';
  CodMetodo: Integer = 634;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if EDtaImportacaoInicio > EDtaImportacaoFim then
  begin
    Mensagens.Adicionar(2182, Self.ClassName, NomMetodo, []);
    Result := -2182;
    Exit;
  end;

  if EDtaProcessamentoInicio > EDtaProcessamentoFim then
  begin
    Mensagens.Adicionar(2183, Self.ClassName, NomMetodo, []);
    Result := -2183;
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add(' select tib.cod_arq_import_boleto as CodArqImportBoleto ' +
                  '      , tib.nom_arq_upload as NomArqUpLoad ' +
                  '      , tib.dta_importacao as DtaImportacao ' +
                  '      , tsa.cod_situacao_arq_import as CodSituacaoArqImport ' +
                  '      , tsa.des_situacao_arq_import as DesSituacaoArqImport ' +
                  '      , tib.cod_usuario_upload as CodUsuarioUpLoad ' +
                  '      , tu.nom_usuario as NomUsuarioUpLoad ' +
                  '      , tib.dta_processamento as DtaProcessamento ' +                  
                  '      , case when tib.qtd_registros_errados > 0 then ''S'' ' +
                  '        else ''N'' end as IndPossuiLogErro ' +
                  '   from tab_arq_import_boleto tib ' +
                  '      , tab_situacao_arq_import tsa ' +
                  '      , tab_usuario tu ' +
                  '  where tib.cod_situacao_arq_import = tsa.cod_situacao_arq_import ' +
                  '    and tib.cod_usuario_upload  = tu.cod_usuario ');

    if Length(Trim(ECodSituacaoArquivo)) > 0 then
    begin
      Query.SQL.Add('  and tib.cod_situacao_arq_import = :cod_situacao_arq_import' );
      Query.ParamByName('cod_situacao_arq_import').AsString := ECodSituacaoArquivo;
    end;

    if Length(Trim(ENomArquivoUpLoad)) > 0 then
    begin
      Query.SQL.Add('  and tib.nom_arq_upload like :nom_arq_upload' );
      Query.ParamByName('nom_arq_upload').AsString := '%' + ENomArquivoUpLoad + '%';
    end;

    if Length(Trim(ENomUsuario)) > 0 then
    begin
      Query.SQL.Add('  and tu.nom_usuario like :nom_usuario' );
      Query.ParamByName('nom_usuario').AsString := '%' + ENomUsuario + '%' ;
    end;

    if EDtaImportacaoInicio > 0 then
    begin
      Query.SQL.Add('  and tib.dta_importacao >= :dta_importacao_inicio' );
      Query.ParamByName('dta_importacao_inicio').AsDateTime := EDtaImportacaoInicio;
    end;

    if EDtaImportacaoFim > 0 then
    begin
      Query.SQL.Add('  and tib.dta_importacao < :dta_importacao_fim' );
      Query.ParamByName('dta_importacao_fim').AsDateTime := EDtaImportacaoFim + 1;
    end;

    if EDtaProcessamentoInicio > 0 then
    begin
      Query.SQL.Add('  and tib.dta_processamento >= :dta_processamento_inicio' );
      Query.ParamByName('dta_processamento_inicio').AsDateTime := EDtaProcessamentoInicio;
    end;

    if EDtaProcessamentoFim > 0 then
    begin
      Query.SQL.Add('  and tib.dta_processamento < :dta_processamento_fim' );
      Query.ParamByName('dta_processamento_fim').AsDateTime := EDtaProcessamentoFim + 1;
    end;      


    Query.Open;
    Result := 0; 
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2177, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2177;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar num resul set (pesquisar) todos os arquivos
   remessa gerados no sistema.

   @param CodArquivoRemessa Inteiro Código do arquivo de remessa a ser gerado
                            Parãmatro opcional (-1)
   @param CodTipoArquivoRemessa Inteiro Tipo do arquivo de remessa
                                        Parãmatro opcional (-1)
   @param DtaCriacaoArquivoInicial Date Período inicial a filtrar pela data de
                                        geração do arquivo de remessa
   @param DtaCriacaoArquivoFinal Date Período final a filtrar pela data de
                                      geração do arquivo de remessa
   @param IndPossuiLogEr String Indica se a pesquisa deve filtrar por arquivos
                                que contiveram erros durante a geração do arquivo
                                ou não.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -188  Valor retornado caso o usuário logado no sistema não possua
                 permissão para executar o método.
   @return -2147 Valor retornar caso seja gerada uma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.PesquisarRemessa(CodArquivoRemessa,
  CodTipoArquivoRemessa: Integer; DtaCriacaoArquivoInicial,
  DtaCriacaoArquivoFinal: TDateTime; IndPossuiLogErro: String): Integer;
const
  NomMetodo: String = 'PesquisarRemessa';
  CodMetodo: Integer = 627;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if DtaCriacaoArquivoInicial > DtaCriacaoArquivoFinal then
  begin
    Mensagens.Adicionar(2181, Self.ClassName, NomMetodo, []);
    Result := -2181;
    Exit;
  end;
  
  try
    Query.SQL.Clear;
    Query.SQL.Add(' select tar.cod_arquivo_remessa_boleto as CodArquivoRemessaBoleto ' +
                  '      , tar.nom_arquivo_remessa_boleto as NomArquivoRemessaBoleto ' +
                  '      , tar.cod_tipo_arquivo_boleto as CodTipoArquivoBoleto ' +
                  '      , tta.des_tipo_arquivo_boleto as DesTipoArquivoBoleto ' +
                  '      , tar.dta_criacao_arquivo as DtaCriacaoArquivo ' +
                  '      , tar.qtd_bytes_arquivo as QtdBytesArquivo ' +
                  '      , tar.cod_usuario as CodUsuario ' +
                  '      , tu.nom_usuario as NomUsuario ' +
                  '      , tar.ind_possui_log_erro as IndPossuiLogErro ' +
                  '   from tab_arquivo_remessa_boleto tar ' +
                  '      , tab_tipo_arquivo_boleto tta ' +
                  '      , tab_usuario tu ' +                  
                  '  where tar.cod_tipo_arquivo_boleto = tta.cod_tipo_arquivo_boleto ' +
                  '    and tar.cod_usuario = tu.cod_usuario');
    if CodArquivoRemessa > 0 then
    begin
      Query.SQL.Add('  and tar.cod_arquivo_boleto = :cod_arquivo_boleto');
      Query.ParamByName('cod_arquivo_boleto').AsInteger := CodArquivoRemessa;
    end;
    if CodTipoArquivoRemessa > 0 then
    begin
      Query.SQL.Add('  and tar.cod_tipo_arquivo_boleto = :cod_tipo_arquivo_boleto');
      Query.ParamByName('cod_tipo_arquivo_boleto').AsInteger := CodTipoArquivoRemessa;
    end;
    if DtaCriacaoArquivoInicial > 0 then
    begin
      Query.SQL.Add('  and tar.dta_criacao_arquivo >= :dta_inicial_criacao_arquivo');
      Query.ParamByName('dta_inicial_criacao_arquivo').AsDateTime := DtaCriacaoArquivoInicial;
    end;
    if DtaCriacaoArquivoFinal > 0 then
    begin
      Query.SQL.Add('  and tar.dta_criacao_arquivo < :dta_final_criacao_arquivo');
      Query.ParamByName('dta_final_criacao_arquivo').AsDateTime := DtaCriacaoArquivoFinal + 1;
    end;
    if UpperCase(IndPossuiLogErro) = 'S' then
    begin
      Query.SQL.Add('  and tar.ind_possui_log_erro = :ind_possui_log_erro');
      Query.ParamByName('ind_possui_log_erro').AsString := IndPossuiLogErro;
    end;
    Query.SQL.Add('order by tar.dta_criacao_arquivo desc');

    Query.Open;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2147, Self.ClassName, NomMetodo, [e.message]);
      Result := -2147;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar as situações (tab_situação_boleto) que um
   boleto bancário poderá assumir.

   @param ECodSituacaoBoleto Inteiro Parâmetro opcional, que caso informado, irá
                                     filtrar pela situação informada.
   @param EIndOrdenacao String Parâmetro opcional. Caso seja passado "P", o result
                               set será ordenado pelo campo cod_prioridade_situacao.
                               Qualquer outro valor resultará na ordenação pelo
                               campo num_ordem.

   @return -0    Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2158 Retorno caso ocorra alguma exceção na execução do método.
}
function TIntBoletosBancario.PesquisarSituacaoBoleto(ECodSituacaoBoleto: Integer;
                                                     EIndOrdenacao: String): Integer;
const
  NomMetodo: String = 'PesquisarSituacaoBoleto';
  CodMetodo: Integer = 631;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add('select cod_situacao_boleto as CodSituacaoBoleto');
    Query.SQL.Add('     , sgl_situacao_boleto as SglSituacaoBoleto');
    Query.SQL.Add('     , des_situacao_boleto as DesSituacaoBoleto');
    Query.SQL.Add('     , ind_restrito_banco  as IndRestritoBanco');
    Query.SQL.Add('     , cod_movimentacao_retorno_banco as CodMovimentacaoBanco');
    Query.SQL.Add('     , num_ordem as NumOrdem');
    Query.SQL.Add('     , cod_prioridade_situacao as CodPrioridadeSituacao');    
    Query.SQL.Add('  from tab_situacao_boleto');
    Query.SQL.Add(' where (1 = 1)');
    if ECodSituacaoBoleto > 0 then
    begin
      Query.SQL.Add(' and cod_situacao_boleto = :cod_situacao_boleto');
      Query.ParamByName('cod_situacao_boleto').AsInteger := ECodSituacaoBoleto;
    end;
    if EIndOrdenacao <> 'P' then
    begin
      Query.SQL.Add('order by num_ordem');
    end
    else
    begin
      Query.SQL.Add('order by cod_prioridade_situacao');
    end;

    Query.Open;
    Result := 0;    
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2158, Self.ClassName, NomMetodo, [e.Message]);
      Result := -2158;
      Exit;
    end;
  end;
end;


{* Função responsável por pesquisar os tipos de arquivo remessa que serão gerados
   pelo sistema

   @return -0    Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2150 Retorno caso ocorra alguma exceção na execução do método.
}
function TIntBoletosBancario.PesquisarTipoArquivoRemessa(): Integer;
const
  NomMetodo: String = 'PesquisarTiposArquivoRemessa';
  CodMetodo: Integer = 636;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add('select cod_tipo_arquivo_boleto as CodTipoArquivoBoleto');
    Query.SQL.Add('     , des_tipo_arquivo_boleto as DesTipoArquivoBoleto');
    Query.SQL.Add('     , num_ordem as NumOrdem');
    Query.SQL.Add('  from tab_tipo_arquivo_boleto');
    Query.SQL.Add(' where dta_fim_validade is null');    
    Query.SQL.Add('order by num_ordem');
    Query.Open;
    Result := 0;    
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2150, Self.ClassName, NomMetodo, [e.Message]);
      Result := -2150;
      Exit;
    end;
  end;
end;


{* Função responsável pelo processamento do arquivo de retorno de boletos bancários.
   Além de realizar a leitura do arquivo, de acordo com as informações lidas, o
   boleto bancário terá sua situação alterada, ou apenas um histórico será gerado.

   @param ECodArquivoImportacao Inteiro Parâmetro obrigatório. Indica o código
                                        do arquivo, na tab_arq_import_boleto, que
                                        será processado.

   @return 0     Valor retornado quando o método for executado com sucesso.
   @return -188  Valor retornado quando o usuário logado no sistema não possuir
                 permissão de acesso para executar o método.
   @return -2165 Valor retornado caso o arquivo informado no parâmetro
                 ECodArquivoImportacao, não seja encontrado na base de dados.
   @return -1344 Valor retornado caso ocorra alguma erro ao pesquisar o agendamento
                 da tarefa de processamento do arquivo.
   @return 1345  Valor retornado caso o agendamento da tarefa tenha ocorrido com
                 sucesso.
   @return -2166 Valor retornado caso seja lançada alguma exceção durante a
                 execução do método.
}
function TIntBoletosBancario.ProcessarArquivoRetorno(ECodArquivoImportacao: Integer): Integer;
const
  NomMetodo: String = 'ProcessarArquivoRetorno';
  CodMetodo: Integer = 633;
  CodTipoTarefa: Integer = 6;
var
  Qry: THerdomQuery;
begin
  Result := -1;
 
  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Qry.SQL.Clear;
      Qry.SQL.Add(' select 1 ' +
                  '   from tab_arq_import_boleto ' +
                  '  where cod_arq_import_boleto = :cod_arq_import_boleto ');
      Qry.ParamByName('cod_arq_import_boleto').AsInteger :=  ECodArquivoImportacao;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        Mensagens.Adicionar(2165, Self.ClassName, NomMetodo, []);
        Result := -2165;
        Exit;
      end;

      // Verifica se o arquivo se se encontra na lista de tarefas para processamento
      Result := VerificarAgendamentoTarefa(CodTipoTarefa, [ECodArquivoImportacao]);
      if Result <= 0 then begin
        if Result = 0 then begin
          Mensagens.Adicionar(1344, Self.ClassName, NomMetodo, []);
          Result := -1344;
        end;
        Exit;
      end;

      // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
      Result := SolicitarAgendamentoTarefa(CodTipoTarefa,
                                           [ECodArquivoImportacao],
                                           DtaSistema);

      // Trata o resultado da solicitação, gerando mensagem se bem sucedido
      if Result >= 0 then
      begin
        Mensagens.Adicionar(1345, Self.Classname, NomMetodo, []);
      end;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2166, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2166;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Função responsável por realizar o processamento do arquivo de retorno
  (enviado à certificadora pelo banco). Neste arquivo será tratado o "andamento"
  do arquivo durante sua vida no banco.

  @param ECodArquivoImportacao Inteiro Código do arquivo que será processado.

  @return 0 Valor retornado caso o método seja executado com sucesso.
  @return -2165 Valor retornado caso o arquivo informado no parâmetro de entrada
                ECodArquivoImportacao não seja encontrado.
  @return -1219 Valor retornado caso ocorra algum problema na inicialização da
                leitura do arquivo.
  @return -1220 Valor retornado caso ocorra algum problema na inicialização da
                leitura do arquivo.
  @return -1232 Valor  retronado caso ocorra algum problema ao ler uma linha do
                arquivo.
  @return -2166 Valor retornado caso ocorra alguma exceção durante a execução do
                método.

}
function TIntBoletosBancario.ProcessarArquivoRetornoInt(ECodArquivoImportacao: Integer): Integer;
const
  NomMetodo: String = 'ProcessarArquivoRetornoInt';

  // Obtido no registro tipo 0
  ccNumCNPJCPFCertificadora: Integer = 6;

  // Obtido no registro tipo 3 segmento T
  ccIdentTituloEmpresa:      Integer = 21;

  // Obtido no registro tipo 3 segmento U
  ccCodMovimento:            Integer = 7;
  ccValPagoSacado:           Integer = 12;
  ccDtaEfetivacaoCredito:    Integer = 16;
var
  Qry: THerdomQuery;
  Arquivo: TArquivoPosicionalLeitura;
  i, iLinhasTotal: Integer;
  DtaProcessamento: TDateTime;
  NomArquivoImportacao: String;
  Processamento: TProcessamento;

  ValPagoSacado: Real;
  DtaEfetivacaoCredito: TDateTime;
  CodMovimento: Integer;
  IdentTituloEmpresa,
  DesMovimentoRetornoBanco,
  sOrigem, 
  TipoSegmentoRegistro: String;

  NumRegistrosProcessados,
  NumRegistrosErrados,
  CodOrdemServico,
  CodBoletoBancario,
  NumParcela: Integer;

  function AtualizaSituacaoArqImport(ECodSituacao: String): Integer;
  begin
    Qry.SQL.Clear;
    Qry.SQL.Add(' update tab_arq_import_boleto ' +
                '    set cod_situacao_arq_import = :cod_situacao_arq_import ' +
                '  where cod_arq_import_boleto = :cod_arq_import_boleto ');
    Qry.ParamByName('cod_situacao_arq_import').AsString := ECodSituacao;
    Qry.ParamByName('cod_arq_import_boleto').AsInteger  := ECodArquivoImportacao;
    Qry.ExecSQL;
    Result := 0;
  end;

  { Verifica se ainda existem linhas do arquivo a serem processadas }
  function VerificarStatus: Integer;
  var
    iiAux: Integer;
  begin
    Qry.Close;
    Qry.SQL.Text :=
      'select '+
      '  qtd_registros_total '+
      'from '+
      '  tab_arq_import_boleto '+
      'where '+
      '  cod_arq_import_boleto = :cod_arq_import_boleto ';
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.Open;

    iLinhasTotal := Qry.FieldByName('qtd_registros_total').AsInteger;

    Qry.Close;
    Qry.SQL.Text :=
      'select '+
      '  count(1) as NumLinhas '+
      'from '+
      '  tab_linha_arq_import_boleto '+
      'where '+
      '  cod_arq_import_boleto = :cod_arq_import_boleto ';
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.Open;

    iiAux := Qry.FieldByName('NumLinhas').AsInteger;

    if iiAux = 0 then
    begin
      Result := 0;
    end
    else
    begin
      Qry.Close;
      Qry.SQL.Text :=
        'select '+
        '  qtd_registros_total as NumLinhasAProcessar '+
        'from '+
        '  tab_arq_import_boleto '+
        'where '+
        '  cod_arq_import_boleto = :cod_arq_import_boleto ';
      Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
      Qry.Open;
      if iiAux < Qry.FieldByName('NumLinhasAProcessar').AsInteger then
      begin
        Result := 0;
      end
      else
      begin
        Qry.Close;
        Qry.SQL.Text :=
          'select '+
          '  count(1) as NumLinhasAProcessar '+
          'from '+
          '  tab_linha_arq_import_boleto '+
          'where '+
          '      dta_processamento is null '+
          '  and cod_arq_import_boleto = :cod_arq_import_boleto '+
          'group by '+
          '      cod_arq_import_boleto ';
        Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
        Qry.Open;
        if Qry.FieldByName('NumLinhasAProcessar').AsInteger = 0 then begin
          Mensagens.Adicionar(1286, Self.ClassName, NomMetodo, []);
          Result := -1286;
        end else begin
          Result := 0;
        end;
      end;
    end;
    Qry.Close;
  end;

  { Verifica existência física do arquivo em disco }
  function VerificarArquivo(): Integer;
  var
    sArquivo: String;
  begin
    Qry.SQL.Clear;
    Qry.SQL.Add('select nom_arq_import_boleto from tab_arq_import_boleto');
    Qry.SQL.Add(' where cod_arq_import_boleto = :cod_arq_import_boleto');
    Qry.Open;
    NomArquivoImportacao := Qry.FieldByName('cod_arq_import_boleto').AsString;

    // Obtem a pasta onde os arquivo estão armazenados
    sArquivo := Conexao.ValorParametro(102, Mensagens);
    if (Length(sArquivo) = 0) or (sArquivo[Length(sArquivo)] <> '\') then begin
      sArquivo := sArquivo + '\';
    end;
    // Consiste existência da pasta
    if not DirectoryExists(sArquivo) then begin
      Mensagens.Adicionar(1596, Self.ClassName, NomMetodo, []);
      Result := -1596;
      Exit;
    end;
    // Consiste existência do arquivo
    sArquivo := sArquivo + NomArquivoImportacao;
    if not FileExists(sArquivo) then begin
      Mensagens.Adicionar(1597, Self.ClassName, NomMetodo, [NomArquivoImportacao]);
      Result := -1597;
      Exit;
    end;

    // Passo bem sucedido
    NomArquivoImportacao := sArquivo;
    Result := 0;
  end;

  { Limpa as ocorrências obtidas no último processamento }
  procedure LimparOcorrenciaProcessamento;
  begin
    Qry.SQL.Clear;
    Qry.SQL.Add(' delete from tab_erro_import_boleto ' +
                ' where cod_arq_import_boleto = :cod_arq_import_boleto ');
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.ExecSQL;
  end;

  { Guarda ocorrências durante o processamento }
  function GravarOcorrenciaProcessamento: Integer;
  var
    iiAux: Integer;
  begin
    Qry.SQL.Clear;

    // Script SQL de inserção de ocorrência durante o processamento
    Qry.SQL.Add(' insert into tab_erro_import_boleto '+
                '  ( cod_arq_import_boleto '+
                '  , txt_mensagem_erro ) ' +
                ' values '+
                '  ( :cod_arq_import_boleto '+
                '  , :txt_mensagem_erro ) ');

    // Dados de identicação do arquivo e linha
    // Constantes a todos os tipos de ocorrências
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    // Tipos dos dados de identificação da ocorrência
    // Variável de acordo com o tipo da linha
    Qry.ParamByName('txt_mensagem_erro').DataType := ftString;
    for iiAux := 0 to Mensagens.Count-1 do
    begin
      Qry.ParamByName('txt_mensagem_erro').AsString := Mensagens.Items[iiAux].Texto;
      Qry.ExecSQL;
    end;
    Mensagens.Clear;
    Result := 0;
  end;

  { Marca a linha informada como já processada }
  procedure MarcarLinhaComoProcessada(NumLinha: Integer);
  begin
    Qry.Close;
    Qry.SQL.Text :=
      'update '+
      '  tab_linha_arq_import_boleto '+
      'set '+
      '  dta_processamento = :dta_processamento '+
      'where '+
      '  cod_arq_import_boleto = :cod_arq_import_boleto '+
      '  and num_linha = :num_linha ';
    Qry.ParamByName('dta_processamento').AsDateTime := DtaProcessamento;
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.ParamByName('num_linha').AsInteger := NumLinha;
    Qry.ExecSQL;
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
    end else if Arquivo.TipoLinha in [0, 1, 9] then begin
      Result := 0;
      Exit;
    end;

    Qry.Close;
    Qry.SQL.Text :=
      'select '+
      '  dta_processamento as DtaProcessamento '+
      'from '+
      '  tab_linha_arq_import_boleto '+
      'where '+
      '  cod_arq_import_boleto = :cod_arq_import_boleto '+
      '  and num_linha = :num_linha ';
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.ParamByName('num_linha').AsInteger := NumLinha;
    Qry.Open;
    if Qry.IsEmpty then begin
      Qry.Close;
      Qry.SQL.Text :=
        'insert into tab_linha_arq_import_boleto '+
        ' (cod_arq_import_boleto '+
        '  , num_linha '+
        '  , dta_processamento) '+
        'values '+
        ' (  :cod_arq_import_boleto '+
        '  , :num_linha '+
        '  , getdate()) ';
      Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
      Qry.ParamByName('num_linha').AsInteger := NumLinha;
      Qry.ExecSQL;
      Result := 1;
    end else begin
      if Qry.FieldByName('DtaProcessamento').IsNull then begin
        Result := 1;
      end else begin
        Result := 0;
      end;
    end;
    Qry.Close;
  end;

  function AtualizaStatusArquivo(): Integer;
  begin
    Qry.SQL.Clear;
    Qry.SQL.Add(' select qtd_registros_total ');
    Qry.SQL.Add('   from tab_arq_import_boleto ');
    Qry.SQL.Add('  where cod_arq_import_boleto = :cod_arq_import_boleto');
    Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
    Qry.Open;

    if Qry.FieldByName('qtd_registros_total').AsInteger = NumRegistrosProcessados then
    begin
      Result := AtualizaSituacaoArqImport('C');
      if Result < 0 then
      begin
        Exit;
      end;
    end;

    if NumRegistrosErrados > 0 then
    begin
      Result := AtualizaSituacaoArqImport('P');
      if Result < 0 then
      begin
        Exit;
      end;
    end;

    Qry.SQL.Clear;
    Qry.SQL.Add(' update tab_arq_import_boleto ');
    Qry.SQL.Add('    set qtd_registros_processados = :qtd_registros_processados ');
    Qry.SQL.Add('      , qtd_registros_errados = :qtd_registros_errados ');
    Qry.SQL.Add('      , dta_processamento = getdate() ');
    Qry.SQL.Add('      , cod_tarefa        = :cod_tarefa ');
    Qry.SQL.Add('  where cod_arq_import_boleto = :cod_arq_import_boleto ');
    Qry.ParamByName('cod_arq_import_boleto').AsInteger     := ECodArquivoImportacao;
    Qry.ParamByName('qtd_registros_processados').AsInteger := NumRegistrosProcessados;
    Qry.ParamByName('cod_tarefa').AsInteger                := Thread.CodTarefa;
    Qry.ParamByName('qtd_registros_errados').AsInteger     := NumRegistrosErrados;
    Qry.ExecSQL;
    Result := 0;
  end;

  { ************************************************************************** }
  {         Processamento dos boletos bancários retornados no arquivo          }


  function ProcessarBoletoBancario(ECodOrdemServico, ECodBoletoBancario,
                                   ENumParcela, ECodMovimento: Integer;
                                   EValPagoSacado: Real;
                                   EDtaEfetivacaoCredito: TDateTime): Integer;
  var
    CodSituacaoOrigem,
    CodSituacaoDestino: Integer;
    MudSituacao: TMudancaSituacao;
  begin
    // Verifica a existência do boleto bancário
    Qry.SQL.Clear;
    Qry.SQL.Add(' select cod_situacao_boleto ' +
                '   from tab_boleto ' +
                '  where cod_boleto        = :cod_boleto ' +
                '    and cod_ordem_servico = :cod_ordem_servico ' +
                '    and num_parcela       = :num_parcela ');
    Qry.ParamByName('cod_ordem_servico').AsInteger := ECodOrdemServico;
    Qry.ParamByName('cod_boleto').AsInteger        := ECodBoletoBancario;
    Qry.ParamByName('num_parcela').AsInteger       := ENumParcela;
    Qry.Open;
    if Qry.IsEmpty then
    begin
      Mensagens.Adicionar(2167, Self.ClassName, NomMetodo, [IntToStr(ECodBoletoBancario), IntToStr(ENumParcela)]);
      Result := -2167;
      Exit;
    end;
    CodSituacaoOrigem := Qry.FieldByName('cod_situacao_boleto').AsInteger;

    if (EValPagoSacado <= 0) and ((CodSituacaoOrigem = 2) or (CodSituacaoOrigem = 7)) then
    begin
      Mensagens.Adicionar(2168, Self.ClassName, NomMetodo, [IntToStr(ECodBoletoBancario), IntToStr(ENumParcela)]);
      Result := -2168;
      Exit;
    end;

    if (EDtaEfetivacaoCredito <= 0) and ((CodSituacaoOrigem = 2) or (CodSituacaoOrigem = 7)) then
    begin
      Mensagens.Adicionar(2169, Self.ClassName, NomMetodo, [IntToStr(ECodBoletoBancario), IntToStr(ENumParcela)]);
      Result := -2169;
      Exit;
    end;    

    // Verifica se o movimento retornado pelo banco é um movimento válido
    Qry.SQL.Clear;
    Qry.SQL.Add(' select des_movimentacao_retorno_banco ' +
                '   from tab_movimentacao_retorno_banco ' +
                '  where cod_movimentacao_retorno_banco = :cod_movimentacao_retorno_banco ');
    Qry.ParamByName('cod_movimentacao_retorno_banco').AsInteger := ECodMovimento;
    Qry.Open;
    if Qry.IsEmpty then
    begin
      Mensagens.Adicionar(2170, Self.ClassName, NomMetodo, [IntToStr(ECodBoletoBancario),
                                                            IntToStr(ENumParcela),
                                                            IntToStr(ECodMovimento)]);
      Result := -2170;
      Exit;
    end;
    DesMovimentoRetornoBanco := Qry.FieldByName('des_movimentacao_retorno_banco').AsString;

    // Verifica se o movimento retornado pelo banco é um movimento relacionado
    // com as situações do boleto bancário.
    Qry.SQL.Clear;
    Qry.SQL.Add(' select cod_situacao_boleto ' +
                '   from tab_situacao_boleto tsb ' +
                '      , tab_movimentacao_retorno_banco tmr ' +
                '  where tsb.cod_movimentacao_retorno_banco = tmr.cod_movimentacao_retorno_banco ' +
                '    and tsb.cod_movimentacao_retorno_banco = :cod_movimentacao_retorno_banco ');
    Qry.ParamByName('cod_movimentacao_retorno_banco').AsInteger := ECodMovimento;
    Qry.Open;
    if Qry.IsEmpty then
    begin
      Mensagens.Adicionar(2171, Self.ClassName, NomMetodo, [IntToStr(ECodBoletoBancario),
                                                            IntToStr(ENumParcela),
                                                            DesMovimentoRetornoBanco]);
      Result := -2171;
      Exit;
    end;

    // Valida a situação de origem x destino
    // Consiste se deverá ocorrer mudança da situação
    CodSituacaoDestino := Qry.FieldByName('cod_situacao_boleto').AsInteger;
    MudSituacao.CodSituacaoOrigemBoleto  := CodSituacaoOrigem;
    MudSituacao.CodSituacaoDestinoBoleto := CodSituacaoDestino;
    Result := VerificaMudancaSituacao(MudSituacao);
    if Result < 0 then
    begin
      Exit;
    end;

    // Atualiza os dados na tab_boleto e realiza a mudanca de situacao caso
    // necessario
    try
      beginTran;
      if CodSituacaoDestino in [3, 7]then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add(' update tab_boleto ' +
                    '    set val_pago_boleto        = :val_pago_boleto ' +
                    '      , dta_efetivacao_credito = :dta_credito_efetivado ' +
                    '  where cod_boleto  = :cod_boleto ' +
                    '    and num_parcela = :num_parcela ');
        Qry.ParamByName('val_pago_boleto').AsFloat          := EValPagoSacado;
        Qry.ParamByName('dta_credito_efetivado').AsDateTime := EDtaEfetivacaoCredito;
        Qry.ParamByName('cod_boleto').AsInteger             := ECodBoletoBancario;
        Qry.ParamByName('num_parcela').AsInteger            := ENumParcela;
        Qry.ExecSQL;
      end;

      if UpperCase(MudSituacao.IndAtualizaSituacao) = 'S' then
      begin
        Result := MudarSituacao(ECodBoletoBancario, ENumParcela,
                                CodSituacaoDestino, MudSituacao.TxtMensagemLog);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
      end
      else
      begin
        Result := InserirHistoricoMudancaSituacao(ECodBoletoBancario, ENumParcela,
                                                  CodSituacaoOrigem, MudSituacao.TxtMensagemLog);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
      end;
      Commit;
      Result := 0;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2166, Self.ClassName, NomMetodo, [e.Message]);
        Result := -2166;
        Exit;
      end;
    end;
  end;

begin
  Qry := nil;
  Qry := THerdomQuery.Create(Conexao, nil);
  Arquivo := TArquivoPosicionalLeitura.Create;
  Processamento := TProcessamento.Create;
  
  try
    try
      // Verifica se o arquivo ainda está disponível para processamento
      Result := VerificarStatus;
      if Result < 0 then
      begin
        GravarOcorrenciaProcessamento;
        Exit;
      end;

      Qry.SQL.Clear;
      Qry.SQL.Add(' select nom_arq_import_boleto ' +
                  '   from tab_arq_import_boleto ' +
                  '  where cod_arq_import_boleto = :cod_arq_import_boleto ');
      Qry.ParamByName('cod_arq_import_boleto').AsInteger := ECodArquivoImportacao;
      Qry.Open;

      if Qry.IsEmpty then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(2165, Self.ClassName, NomMetodo, []);
        Result := -2165;
        Exit;
      end;
      NomArquivoImportacao := Qry.FieldByName('nom_arq_import_boleto').AsString;

      sOrigem := ValorParametro(38);
      if (Length(sOrigem) = 0) or (sOrigem[Length(sOrigem)] <> '\') then
      begin
        sOrigem := sOrigem + '\';
      end;

      { Identifica arquivo de upload }
      Arquivo.NomeArquivo := sOrigem + NomArquivoImportacao;

      { Trata possíveis erros durante a tentativa de abertura do arquivo }
      Result := Arquivo.Inicializar;
      if Result = EArquivoInexistente then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1219, Self.ClassName, NomMetodo, []);
        Result := -1219;
        Exit;
      end
      else if Result = EInicializarLeitura then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1219, Self.ClassName, NomMetodo, []);
        Result := -1219;
        Exit;
      end
      else if Result < 0 then
      begin
        AtualizaSituacaoArqImport('I');
        Mensagens.Adicionar(1220, Self.ClassName, NomMetodo, []);
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
      Processamento.CodArquivoImportacao := ECodArquivoImportacao;

      // Abre transação
      Conexao.beginTran;

      LimparOcorrenciaProcessamento;
      // Confirma transação
      Conexao.Commit;

      Arquivo.RotinaLeitura := InterpretaLinhaArquivoRetorno;
      Arquivo.ReInicializar;
      begintran;
      i := 0;

      NumRegistrosProcessados := 0;
      NumRegistrosErrados     := 0;

      while (Arquivo.EOF = False) and (Thread.Suspended = False) do
      begin
        Inc(i);

        // Obtém linha do arquivo de importação
        Result := Arquivo.ObterLinha;
        if Result < 0 then
        begin
          Rollback;
          Mensagens.Adicionar(1232, Self.ClassName, NomMetodo, [IntToStr(Arquivo.LinhasLidas)]);
          Result := GravarOcorrenciaProcessamento;
          if Result < 0 then
          begin
            Exit;
          end;
          Result := -1232;
          CancelarProcessamento;
          Exit;
        end;

        // Verifica se a linha atual deve ser processada
        Result := ProcessarLinha(Arquivo.LinhasLidas);
        if Result < 0 then
        begin
          Rollback;
          CancelarProcessamento;
          Exit;
        end;

        // Realiza o processamento do arquivo de acordo com o tipo de cada linha
        // do arquivo de retorno. Atentar para o fato que a linha tipo 3, é
        // diferenciada nos registros na posição 14, onde se encontra a especificação
        // do segmento a que o tipo do registro se refere.
        case Arquivo.TipoLinha of
          0:
          begin
            Result := ValidarCertificadora(Arquivo.ValorColuna[ccNumCNPJCPFCertificadora], Self);
            if Result < 0 then
            begin
              Rollback;
              AtualizaSituacaoArqImport('I');
              CancelarProcessamento;
              GravarOcorrenciaProcessamento;
              Exit;
            end;
          end;

          3:
          begin
            TipoSegmentoRegistro := Copy(Arquivo.LinhaTexto, 14, 1);
            if UpperCase(TipoSegmentoRegistro) = 'T' then
            begin
              IdentTituloEmpresa := Trim(Arquivo.ValorColuna[ccIdentTituloEmpresa]);
            end
            else
            if UpperCase(TipoSegmentoRegistro) = 'U' then
            begin
              CodOrdemServico    := StrToIntDef(Copy(IdentTituloEmpresa, 01, 10), 0);
              CodBoletoBancario  := StrToIntDef(Copy(IdentTituloEmpresa, 12, 10), 0);
              NumParcela         := StrToIntDef(Copy(IdentTituloEmpresa, 23, 1), 0);
              if (CodOrdemServico   <= 0) or
                 (CodBoletoBancario <= 0) or
                 (NumParcela        <= 0) then
              begin
                Inc(NumRegistrosErrados);
                Mensagens.Adicionar(2172, Self.ClassName, NomMetodo, [IntToStr(i)]);
                Result := -2172;
                if GravarOcorrenciaProcessamento < 0 then
                begin
                  Exit;
                end;
                Continue;
              end;

              CodMovimento         := StrToIntDef(Arquivo.ValorColuna[ccCodMovimento], 0);
              ValPagoSacado        := (StrToFloatDef(Arquivo.ValorColuna[ccValPagoSacado], 0) / 100);
              DtaEfetivacaoCredito := EncodeDate(StrToIntDef(Copy(Arquivo.ValorColuna[ccDtaEfetivacaoCredito], 05, 04), 0),
                                                 StrToIntDef(Copy(Arquivo.ValorColuna[ccDtaEfetivacaoCredito], 03, 02), 0),
                                                 StrToIntDef(Copy(Arquivo.ValorColuna[ccDtaEfetivacaoCredito], 01, 02), 0)
                                                 );
              Result := ProcessarBoletoBancario(CodOrdemServico, CodBoletoBancario,
                                                NumParcela, CodMovimento,
                                                ValPagoSacado, DtaEfetivacaoCredito);
              if Result < 0 then
              begin
                Inc(NumRegistrosErrados);
                if GravarOcorrenciaProcessamento < 0 then
                begin
                  Exit;
                end;
                Continue;
              end;
            end
            else
            begin
              Rollback;
              Inc(NumRegistrosErrados);              
              Mensagens.Adicionar(2176, Self.ClassName, NomMetodo, ['Tipo de segmento desconhecido na linha: ' + IntToStr(Arquivo.LinhasLidas)]);
              CancelarProcessamento;
              GravarOcorrenciaProcessamento;
              Result := AtualizaSituacaoArqImport('I');
              if Result < 0 then Exit;
              Result := AtualizaStatusArquivo;
              if Result < 0 then Exit;
              Result := -2176;
              Exit;
            end;
          end;
        end;
        Inc(NumRegistrosProcessados);
      end;
      Result := AtualizaStatusArquivo();
      if Result < 0 then
      begin
        Exit;
      end;

      Commit;
      Result := ECodArquivoImportacao;
    except
      on E:Exception do
      begin
        RollBack;
        Mensagens.Adicionar(2166, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2166;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;


{* Busca o próximo código sequencial para compor a chave primária da tab_arquivo_remessa_boleto

   @param ValProximoNumBoletoBancario Inteiro, que irá receber o valor do código
          sequencial obtido da tab_seq_remessa_boleto, através da leitura do
          campo cod_seq_remessa_boleto da respectiva tabela incrementado de uma unidade

   @return 0 caso o método seja executado com sucesso
   @return -1 caso ocorra alguma falha durante a execução do método
}
function TIntBoletosBancario.ProximoNumeroArquivoRemessa(ECodIdentificacaoBancaria: Integer;
                                                         var EValProximoArquivoRemessa: Integer): Integer;
const
  NomMetodo: String = 'ProximoNumeroArquivoRemessa';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      beginTran;

      Qry.SQL.Clear;
      Qry.SQL.Add('update tab_seq_remessa_boleto');
      Qry.SQL.Add('   set cod_seq_remessa_boleto = cod_seq_remessa_boleto + 1');
      if Qry.ExecSQL = 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('insert into tab_seq_remessa_boleto');
        Qry.SQL.Add('            (cod_seq_remessa_boleto)');
        Qry.SQL.Add('     values (1)');
        Qry.ExecSQL;
      end;
      Commit;

      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_seq_remessa_boleto from tab_seq_remessa_boleto');
      Qry.Open;
      EValProximoArquivoRemessa := Qry.FieldByName('cod_seq_remessa_boleto').AsInteger;

      Result := 0;
    Except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2154, Self.ClassName, NomMetodo, [e.message]);
        Result := -2154;
        Exit;
      end;
    end;
  Finally
    Qry.Free;
  end;
end;


{* Busca o próximo código sequencial para compor a chave primária da tab_boleto

   @param ValProximoNumBoletoBancario Inteiro, irá receber o valor do código sequencial obtido da tab_seq_boleto,
          através da leitura do campo cod_seq_boleto da respectiva tabela incrementado de uma unidade

   @return 0 caso o método seja executado com sucesso
   @return -2113 caso ocorra alguma falha durante a execução do método
}
function TIntBoletosBancario.ProximoNumeroBoletoBancario(var EValProximoNumBoletoBancario: Integer): Integer;
const
  NomMetodo: String = 'ProximoNumeroBoletoBancario';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      beginTran;

      Qry.SQL.Clear;
      Qry.SQL.Add('update tab_seq_boleto');
      Qry.SQL.Add('   set cod_seq_boleto = cod_seq_boleto + 1');
      if Qry.ExecSQL = 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('insert into tab_seq_boleto');
        Qry.SQL.Add('            (cod_seq_boleto)');
        Qry.SQL.Add('     values (1)');
        Qry.ExecSQL;
      end;
      Commit;

      Qry.SQL.Clear;
      Qry.SQL.Add('select cod_seq_boleto from tab_seq_boleto');
      Qry.Open;
      EValProximoNumBoletoBancario := Qry.FieldByName('cod_seq_boleto').AsInteger;

      Result := 0;
    Except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2113, Self.ClassName, NomMetodo, [e.message]);
        Result := -2113;
        Exit;
      end;
    end;
  Finally
    Qry.Free;
  end;
end;


{* Função responsável por realizar o tratamento dos atributos do arquivo de remessa.
   Caso algum atributo esteja fora do padrão, uma mensagem deverá ser lançada no
   objeto TStringList, para que seja tratada no método GerarRemessa.

   @param EQuery THerdomQuery Parâmetro Obrigatório. Indica a Query contendo o
                              result set referente a geração da remessa.
   @param ETxtMEnsagens TStringList Parâmetro do tipo var, que irá receber as
                                    mensagens de erro geradas durante a geração
                                    da remessa.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -2155 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.ValidaDadosRemessaBoleto(EQuery: THerdomQuery;
                                                      var ETxtMensagens: TStringList): Integer;
const
  NomMetodo: String = 'ValidaDadosRemessaBoleto';
begin
  if ETxtMensagens = nil then
  begin
    ETxtMensagens := TStringList.Create;
  end;
  
  try
    if not EQuery.Eof then
    begin
      with EQuery do
      begin
        if FieldByName('cod_ordem_servico').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('Não existe uma ordem de serviço associada ao boleto bancário.');
        end;
        if FieldByName('cod_boleto').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('Não foi encontrado o código do boleto para gerar a remessa.');
        end;
        if FieldByName('num_parcela').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('Não foi encontrada a parcela para geração da remessa.');
        end;
        if FieldByName('val_total_boleto').AsFloat <= 0 then
        begin
          ETxtMensagens.Add('O valor a ser pago do boleto bancário é inválido.');
        end;
        if FieldByName('dta_vencimento_boleto').AsDateTime <= 0 then
        begin
          ETxtMensagens.Add('A data de vencimento do boleto bancário é inválida.');
        end;
        if FieldByName('cod_identificacao_bancaria').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('Não existe um banco associado ao boleto bancário para gerar a remessa.');
        end;
        if FieldByName('cod_banco_compensacao').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('O código do banco de compensação não foi encontrado.');
        end;
        if FieldByName('cod_convenio_banco').AsString = '' then
        begin
          ETxtMensagens.Add('Não foi encontrado o código do banco de convênio com o boleto bancário.');
        end;
        if FieldByName('cod_agencia_conta').AsString = '' then
        begin
          ETxtMensagens.Add('Não foi encontrada a agência bancária para geração da remessa.');
        end;
        if FieldByName('cod_dv_agencia').AsString = '' then
        begin
          ETxtMensagens.Add('Não foi encontrado o dígito verificador da agência bancária para a geração da remessa.');
        end;
        if FieldByName('cod_conta_corrente').AsString = '' then
        begin
          ETxtMensagens.Add('Não foi encontrada a conta corrente para geração da remessa.');
        end;
        if FieldByName('cod_dv_conta_corrente').AsString = '' then
        begin
          ETxtMensagens.Add('Não foi encontrado o dígito verificador da conta corrente para a geração da remessa.');
        end;
        if FieldByName('cod_tipo_juros_mora').AsInteger < 0 then
        begin
          ETxtMensagens.Add('O tipo de juros não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('val_juros_mora_dia_taxa').AsInteger < 0 then
        begin
          ETxtMensagens.Add('A taxa de juros não foi encontrada. A remessa não será gerada.');
        end;
        if FieldByName('cod_protesto_boleto').AsInteger < 0 then
        begin
          ETxtMensagens.Add('O códido do protesto não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('qtd_dia_protesto').AsInteger < 0 then
        begin
          ETxtMensagens.Add('A quantidade de dias para protesto não foi encontrada. A remessa não será gerada.');
        end;
        if FieldByName('cod_especie_titulo').AsInteger <= 0 then
        begin
          ETxtMensagens.Add('O tipo da espécie dos títulos a serem gerados não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('nom_pessoa').AsString = '' then
        begin
          ETxtMensagens.Add('O nome do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('nom_logradouro').AsString = '' then
        begin
          ETxtMensagens.Add('O endereço do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if Length(Trim(FieldByName('nom_logradouro').AsString)) > 40 then
        begin
          ETxtMensagens.Add('O endereço do SACADO possui mais de 40 caracteres. A remessa não será gerada.');
        end;
        if FieldByName('nom_bairro').AsString = '' then
        begin
          ETxtMensagens.Add('O bairro do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if Length(Trim(FieldByName('nom_bairro').AsString)) > 15 then
        begin
          ETxtMensagens.Add('O bairro do SACADO possui mais de 15 caracteres. A remessa não será gerada.');
        end;
        if FieldByName('num_cep').AsString = '' then
        begin
          ETxtMensagens.Add('O cep do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('nom_municipio').AsString = '' then
        begin
          ETxtMensagens.Add('O município do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('nom_estado').AsString = '' then
        begin
          ETxtMensagens.Add('O estado do SACADO não foi encontrado. A remessa não será gerada.');
        end;
        if FieldByName('cod_natureza_pessoa').AsString = '' then
        begin
          ETxtMensagens.Add('A natureza da pessoa não foi encontrada. A remessa não será gerada.');
        end;
        if FieldByName('num_cnpj_cpf').AsString = '' then
        begin
          ETxtMensagens.Add('O CPF/CNPJ da pessoa não foi encontrado. A remessa não será gerada.');
        end;
      end;
    end;
    if ETxtMensagens.Count = 0 then
    begin
      ETxtMensagens.Free;
      ETxtMensagens := nil;
    end;                 
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2155, Self.ClassName, NomMetodo, [e.Message]);
      Result := -2155;
      Exit;
    end;
  end;
end;

function TIntBoletosBancario.ValidarCertificadora(ENumCNPJ: String;
  AOwner: TObject): Integer;
var
  NomCertificadora, NumCNPJCertificadora: String;
begin
  Result := ObterDadosCertificadora(NomCertificadora, NumCNPJCertificadora,
    AOwner);
  if Result < 0 then
  begin
    Exit;
  end;

  if ENumCNPJ = NumCNPJCertificadora then
  begin
    Result := 0; {Certificadora identificada}
  end
  else
  begin
    Result := -1; {Certificadora não identificada}
  end;
end;


{* Função responsável por preencher os atributos do parâmetro EMudancaSituacao,
   para que sejam feitas validações sobre estes atributos.

   @param EMudancaSituacao TMudancaSituacao Parâmetro do tipo var, que irá receber
                                            valores referentes a mudança de situação.
                                            Sobre estes parâmetros serão realizadas
                                            validaçõs do mesmo.

   @return 0     Valor retornado caso o método seja executado com sucesso.
   @return -2164 Valor retornado caso seja gerada uma exceção durante a execução
                 do método.
}
function TIntBoletosBancario.VerificaMudancaSituacao(var EMudancaSituacao: TMudancaSituacao): Integer;
const
  NomMetodo: String = 'VerficaMudancaSituacao';
var
  Q,
  Qry: THerdomQuery;
  DesSituacaoOrigemBoleto,
  DesSituacaoDestinoBoleto: String;

begin
  Q   := THerdomQuery.Create(Conexao, nil);
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      Qry.SQL.Clear;
      Qry.SQL.Add(' select tms.cod_situacao_boleto as CodSituacaoOrigemBoleto ' +
                  '      , tsbo.des_situacao_boleto as DesSituacaoOrigemBoleto ' +
                  '      , tms.cod_mudanca_situacao_boleto as CodSituacaoDestinoBoleto ' +
                  '      , tsbd.des_situacao_boleto as DesSituacaoDestinoBoleto ' +                  
                  '      , tms.ind_atualiza_situacao_boleto as IndAtualizaSituacaoBoleto ' +
                  '      , tms.txt_mensagem_log as TxtMensagemLog ' +
                  '   from tab_mudanca_situacao_boleto tms ' +
                  '      , tab_situacao_boleto tsbo ' +
                  '      , tab_situacao_boleto tsbd ' +
                  '  where tms.cod_situacao_boleto = :cod_situacao_boleto ' +
                  '    and tms.cod_situacao_boleto = tsbo.cod_situacao_boleto ' +
                  '    and tms.cod_mudanca_situacao_boleto = tsbd.cod_situacao_boleto ' +
                  '    and tms.cod_mudanca_situacao_boleto = :cod_mudanca_situacao_boleto ');
      Qry.ParamByName('cod_situacao_boleto').AsInteger         := EMudancaSituacao.CodSituacaoOrigemBoleto;
      Qry.ParamByName('cod_mudanca_situacao_boleto').AsInteger := EMudancaSituacao.CodSituacaoDestinoBoleto;
      Qry.Open;

      // A mudança de situação não é permitida.
      if Qry.IsEmpty then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select des_situacao_boleto  ');
        Q.SQL.Add('   from tab_situacao_boleto  ');
        Q.SQL.Add('  where cod_situacao_boleto = :cod_situacao_boleto ');
        Q.ParamByName('cod_situacao_boleto').AsInteger := EMudancaSituacao.CodSituacaoOrigemBoleto;
        Q.Open;
        if Q.IsEmpty then
        begin
          DesSituacaoOrigemBoleto := IntToStr(EMudancaSituacao.CodSituacaoOrigemBoleto) +
                                     '(Código não encontrado na base de dados)';
        end
        else
        begin
          DesSituacaoOrigemBoleto := Q.FieldByName('des_situacao_boleto').AsString;
        end;

        Q.SQL.Clear;
        Q.SQL.Add(' select des_situacao_boleto  ');
        Q.SQL.Add('   from tab_situacao_boleto  ');
        Q.SQL.Add('  where cod_situacao_boleto = :cod_situacao_boleto ');
        Q.ParamByName('cod_situacao_boleto').AsInteger := EMudancaSituacao.CodSituacaoDestinoBoleto;
        Q.Open;
        if Q.IsEmpty then
        begin
          DesSituacaoDestinoBoleto := IntToStr(EMudancaSituacao.CodSituacaoDestinoBoleto) +
                                      '(Código não encontrado na base de dados)';
        end
        else
        begin
          DesSituacaoDestinoBoleto := Q.FieldByName('des_situacao_boleto').AsString;
        end;


        Mensagens.Adicionar(2163, Self.ClassName, NomMetodo,
                            [DesSituacaoOrigemBoleto,
                             DesSituacaoDestinoBoleto]);
        Result := -2163;
        Exit;
      end;

      EMudancaSituacao.IndAtualizaSituacao := Qry.FieldByName('IndAtualizaSituacaoBoleto').AsString;
      EMudancaSituacao.TxtMensagemLog      := Qry.FieldByName('TxtMensagemLog').AsString;

      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2164, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2164;
        Exit;
      end;
    end;
  finally
    Qry.Free;
    Q.Free;
  end;
end;


{* Função responsável por atribuir os valores de um parâmetro multi-valorado a um
   string list.

   @param strOriginal Parâmetro contendo o valor multi-valorado que será tratado
          durante a execução do método.
   @param strSaida    Parâmetro do tipo var, que receberá o stringlist de saída.

   @return 0  Valor retorno caso o método seja executado com sucesso.
   @return -1 Valor retornado quando o parâmetro strOriginal for vazio.
}

function TIntBoletosBancario.VerificaParametroMultiValorData(strOriginal: String; var strSaida: TStringList): Integer;
var
  i: Integer;
  strAuxiliar: String;
begin
  if Length(Trim(strOriginal)) = 0 then
  begin
    Result := -1;
    Exit;
  end;

  strAuxiliar := '';
  for i := 0 to Length(strOriginal) + 1 do
  begin
    if (strOriginal[i] <> ',') and (i <= Length(strOriginal)) then
    begin
      strAuxiliar := strAuxiliar + strOriginal[i];
    end
    else
    begin
      if Length(Trim(strAuxiliar)) > 0 then
      begin
        strSaida.Add(Trim(strAuxiliar));
      end;
      strAuxiliar := '';
    end;
  end;
  Result := 0;
end;

procedure InterpretaLinhaArquivoRetorno(Owner: TArquivoPosicionalLeitura);
type
  TCampo = record
    Posicao: Integer;
    Tamanho: Integer;
  end;
const
  // Linha tipo 0
  Linha0: Array [0..27] of TCampo = (
    (Posicao: 1; Tamanho: 3),
    (Posicao: 4; Tamanho: 4),
    (Posicao: 8; Tamanho: 1),
    (Posicao: 9; Tamanho: 9),
    (Posicao: 18; Tamanho: 1),
    (Posicao: 19; Tamanho: 14),
    (Posicao: 33; Tamanho: 20),
    (Posicao: 53; Tamanho: 5),
    (Posicao: 58; Tamanho: 1),
    (Posicao: 59; Tamanho: 12),
    (Posicao: 71; Tamanho: 1),
    (Posicao: 72; Tamanho: 1),
    (Posicao: 73; Tamanho: 30),
    (Posicao: 103; Tamanho: 30),
    (Posicao: 133; Tamanho: 10),
    (Posicao: 143; Tamanho: 1),
    (Posicao: 144; Tamanho: 8),
    (Posicao: 152; Tamanho: 6),
    (Posicao: 158; Tamanho: 6),
    (Posicao: 164; Tamanho: 3),
    (Posicao: 167; Tamanho: 5),
    (Posicao: 172; Tamanho: 20),
    (Posicao: 192; Tamanho: 20),
    (Posicao: 212; Tamanho: 11),
    (Posicao: 223; Tamanho: 3),
    (Posicao: 226; Tamanho: 3),
    (Posicao: 229; Tamanho: 2),
    (Posicao: 231; Tamanho: 10));

  // Linha tipo 3 SegmentoT
  Linha3SegmentoT: Array [0..28] of TCampo = (
    (Posicao: 1;   Tamanho: 3),
    (Posicao: 4;   Tamanho: 4),
    (Posicao: 8;   Tamanho: 1),
    (Posicao: 9;   Tamanho: 5),
    (Posicao: 14;  Tamanho: 1),
    (Posicao: 15;  Tamanho: 1),
    (Posicao: 16;  Tamanho: 2),
    (Posicao: 18;  Tamanho: 5),
    (Posicao: 23;  Tamanho: 1),
    (Posicao: 24;  Tamanho: 12),
    (Posicao: 36;  Tamanho: 1),
    (Posicao: 37;  Tamanho: 1),
    (Posicao: 38;  Tamanho: 20),
    (Posicao: 58;  Tamanho: 1),
    (Posicao: 59;  Tamanho: 15), // Número do documento de cobrança
    (Posicao: 74;  Tamanho: 8),
    (Posicao: 82;  Tamanho: 15),
    (Posicao: 97;  Tamanho: 3),
    (Posicao: 100; Tamanho: 5),
    (Posicao: 105; Tamanho: 1),
    (Posicao: 106; Tamanho: 25), // Identificação do título na empresa
    (Posicao: 131; Tamanho: 2),
    (Posicao: 133; Tamanho: 1),
    (Posicao: 134; Tamanho: 15),
    (Posicao: 149; Tamanho: 40),
    (Posicao: 189; Tamanho: 10),
    (Posicao: 199; Tamanho: 15),
    (Posicao: 214; Tamanho: 10),
    (Posicao: 224; Tamanho: 17));

  // Linha tipo 3 Segmento U
  Linha3SegmentoU: Array [0..23] of TCampo = (
    (Posicao: 1;   Tamanho: 3),
    (Posicao: 4;   Tamanho: 4),
    (Posicao: 8;   Tamanho: 1),
    (Posicao: 9;   Tamanho: 5),
    (Posicao: 14;  Tamanho: 1),
    (Posicao: 15;  Tamanho: 1),
    (Posicao: 16;  Tamanho: 2),
    (Posicao: 18;  Tamanho: 15),
    (Posicao: 33;  Tamanho: 15),
    (Posicao: 48;  Tamanho: 15),
    (Posicao: 63;  Tamanho: 15),
    (Posicao: 78;  Tamanho: 15), // Valor pago pelo sacado
    (Posicao: 93;  Tamanho: 15),
    (Posicao: 108; Tamanho: 15),
    (Posicao: 123; Tamanho: 15),
    (Posicao: 138; Tamanho: 8),
    (Posicao: 146; Tamanho: 8), // Data da efetivação do crédito
    (Posicao: 154; Tamanho: 4),
    (Posicao: 158; Tamanho: 8),
    (Posicao: 166; Tamanho: 15),
    (Posicao: 181; Tamanho: 30),
    (Posicao: 211; Tamanho: 3),
    (Posicao: 214; Tamanho: 20),
    (Posicao: 234; Tamanho: 7));

  // Linha tipo 9 (Trailer de arquivo)
  Linha9: Array [0..7] of TCampo = (
    (Posicao: 1;  Tamanho: 3),
    (Posicao: 4;  Tamanho: 4),
    (Posicao: 8;  Tamanho: 1),
    (Posicao: 9;  Tamanho: 9),
    (Posicao: 18; Tamanho: 6),
    (Posicao: 24; Tamanho: 6),
    (Posicao: 30; Tamanho: 6),
    (Posicao: 36; Tamanho: 205));
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
  if Trim(Owner.LinhaTexto) = '' then
  begin
    Exit;
  end;

  // Identifica tipo da linha
  Owner.TipoLinha := StrToIntDef(Copy(Owner.LinhaTexto, 8, 1), 0);
  // Define colunas disponíveis
  case Owner.TipoLinha of
    0:
    begin
      AdicionarCampos(Linha0);
    end;
    1:
    begin
    end;
    3:
    begin
      if UpperCase(Copy(Owner.LinhaTexto, 14, 1)) = 'T' then
      begin
        // Linha 3 Segmento T
        AdicionarCampos(Linha3SegmentoT);
      end
      else if UpperCase(Copy(Owner.LinhaTexto, 14, 1)) = 'U' then
      begin
        // Linha 3 Segmento U
        AdicionarCampos(Linha3SegmentoU);
      end
      else
      begin
        Abort;
      end;
    end;
    9:
    begin
      AdicionarCampos(Linha9);
    end;
    else
    begin
      AdicionarCampos(Linha3SegmentoU);
    end;
  end;
end;

{ TThrProcessarArquivo }

constructor TThrProcessarArquivoBoleto.CreateTarefa(CodTarefa: Integer;
  Conexao: TConexao; Mensagens: TIntMensagens;
  CodArquivoImportacao: Integer);
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

procedure TThrProcessarArquivoBoleto.Execute;
const
  NomMetodo: String = 'Execute';
var
  IntBoletosBancario: TIntBoletosBancario;
begin
  IntBoletosBancario := TIntBoletosBancario.Create;
  try
    IntBoletosBancario.Inicializar(Conexao, Mensagens);
    IntBoletosBancario.Thread := Self;
    ReturnValue := IntBoletosBancario.ProcessarArquivoRetornoInt(CodArquivoImportacao);
  finally
    IntBoletosBancario.Free;
  end;
end;

function TThrProcessarArquivoBoleto.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

{ TProcessamento }

constructor TProcessamento.Create;
begin
  inherited;
end;

function TProcessamento.IncErradas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomMetodo: String = 'IncErradas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;

  try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text := ' select '+
                      '       qtd_registros_errados as QtdRegistrosErrados '+
                      ' from '+
                      '       tab_arq_import_boleto '+
                      ' where '+
                      '       cod_arq_import_boleto = :cod_arq_import_boleto ';
    Query.ParamByName('cod_arq_import_boleto').AsInteger := FCodArquivoImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdRegistrosErrados').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text := ' update '+
                      '        tab_arq_import_boleto '+
                      '    set '+
                      '        qtd_registros_errados = :qtd_registros_errados '+
                      '  where '+
                      '        cod_arq_import_boleto = :cod_arq_import_boleto ';
    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_registros_errados').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_boleto').AsInteger := FCodArquivoImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1346, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1346;
      Exit;
    end;
  end;
end;

function TProcessamento.IncLidas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomMetodo: String = 'IncLidas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;

  try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text := ' select ' +
                      '        qtd_registros_total as QtdTotal ' +
                      '   from ' +
                      '        tab_arq_import_boleto ' +
                      '  where ' +
                      '        cod_arq_import_sisbov = :cod_arq_import_sisbov ';
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdTotal').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text := ' update '+
                      '        tab_arq_import_boleto '+
                      '    set '+
                      '        qtd_registros_total = :qtd_registros_total '+
                      '  where '+
                      '        cod_arq_import_boleto = :cod_arq_import_boleto ';
    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_registros_total').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_boleto').AsInteger := FCodArquivoImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1226, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1226;
      Exit;
    end;
  end;
end;

function TProcessamento.IncProcessadas(CodTipoLinhaImportacao: Integer): Integer;
const
  NomMetodo: String = 'IncProcessadas';
var
  iAux: Integer;
begin
  if FCodArquivoImportacao = -1 then begin
    Raise Exception.Create('Arquivo não definido!');
  end;
  try
    // Verifica a existência do registro na base
    Query.Close;
    Query.SQL.Text := ' select '+
                      '        qtd_registros_processados as QtdRegistrosProcessados '+
                      '   from '+
                      '        tab_arq_import_boleto '+
                      '  where '+
                      '        cod_arq_import_boleto = :cod_arq_import_boleto ';
    Query.ParamByName('cod_arq_import_boleto').AsInteger := FCodArquivoImportacao;
    Query.Open;

    // Obtem a quantidade total de linha lidas deste tipo até o momento
    iAux := Query.FieldByName('QtdRegistrosProcessados').AsInteger;

    // Incrementa o totalizador atual
    Query.Close;
    Query.SQL.Text := ' update '+
                      '        tab_arq_import_sisbov '+
                      '    set '+
                      '        qtd_registros_processados = :qtd_registros_processados '+
                      '  where '+
                      '        cod_arq_import_sisbov = :cod_arq_import_sisbov ';

    // Atualiza grandeza
    Inc(iAux);
    Query.ParamByName('qtd_registros_processados').AsInteger := iAux;
    Query.ParamByName('cod_arq_import_sisbov').AsInteger := FCodArquivoImportacao;
    Query.ExecSQL;

    // Identifica processamento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1227, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1227;
      Exit;
    end;
  end;
end;

{ TArmazenamento }

constructor TArmazenamento.Create;
begin
  inherited;
end;

function TArmazenamento.GetQtdLinhasLidas(TipoLinhaImportacao: Integer): Integer;
var
  iAux: Integer;
  iFound: Integer;
begin
  iFound := -1;
  for iAux := 0 to Length(FTipos) - 1 do
  begin
    if FTipos[iAux].CodTipoLinha = TipoLinhaImportacao then
    begin
      iFound := iAux;
      Break;
    end;
  end;
  if iFound = -1 then
  begin
    Result := 0;
  end
  else
  begin
    Result := FTipos[iFound].QtdLidas;
  end;
end;

procedure TArmazenamento.IncLidas(CodTipoLinhaImportacao: Integer);
var
  iAux: Integer;
  iFound: Integer;
begin
  iFound := -1;
  for iAux := 0 to Length(FTipos)-1 do
  begin
    if FTipos[iAux].CodTipoLinha = CodTipoLinhaImportacao then
    begin
      iFound := iAux;
      Break;
    end;
  end;
  if iFound = -1 then
  begin
    iFound := Length(FTipos);
    SetLength(FTipos, iFound+1);
    FTipos[iFound].CodTipoLinha := CodTipoLinhaImportacao;
    FTipos[iFound].QtdLidas := 1;
    FTipos[iFound].QtdErradas := 0;
    FTipos[iFound].QtdProcessadas := 0;
  end
  else
  begin
    Inc(FTipos[iFound].QtdLidas);
  end;
end;

function TArmazenamento.Salvar: Integer;
const
  NomeMetodo: String = 'Salvar';
  AtualizaImportacaoBoleto: String = ' update tab_arq_import_boleto ' +
                                     '    set qtd_registros_total       = :qtd_registros_total ' +
                                     '      , qtd_registros_errados     = :qtd_registros_errados ' +
                                     '      , qtd_registros_processados = :qtd_registros_processados ' +
                                     '  where cod_arq_import_boleto     = :cod_arq_import_boleto ';
var
  iAux: Integer;
  QtdTotal,
  QtdErrados,
  QtdProcessados: Integer;
begin
  try
    Query.Close;
    Query.SQL.Text := AtualizaImportacaoBoleto;

    QtdTotal       := 0;
    QtdErrados     := 0;
    QtdProcessados := 0;
    for iAux := 0 to Length(FTipos)-1 do begin
      QtdTotal := QtdTotal + FTipos[iAux].QtdLidas;
      QtdErrados := QtdErrados + FTipos[iAux].QtdErradas;
      QtdProcessados := QtdProcessados + FTipos[iAux].QtdProcessadas;
    end;
    Query.ParamByName('cod_arq_import_boleto').AsInteger     := FCodArquivoImportacao;
    Query.ParamByName('qtd_registros_total').AsInteger       := QtdTotal;
    Query.ParamByName('qtd_registros_errados').AsInteger     := QtdErrados;
    Query.ParamByName('qtd_registros_processados').AsInteger := QtdProcessados;
    Query.ExecSQL;
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


{* Função responsável por gerar a ficha de boletos bancários.

   @param ECodBoleto Inteiro Parâmetro obrigatório. Indica sobre qual boleto o
                             relatório será gerado.
   @param ENumParcela Inteiro Parâmetro obrigatório. Indica sobre qual parcela o
                              relatório deverá ser gerado.            
   @ECodTipoArquivo Inteiro Parâmetro obrigatório. Indica que tipo de relatório
                            será gerado, CSV, ou PDF.

   @return '' Valor retornado quando ocorrer algum problema durante a execução
              do método. Deverá ser lançadas mensagens no objeto Mensagem.
   @return <NomeDoArquivo> Valor retornado quando o método for executado com sucesso.

}
function TIntBoletosBancario.GerarRelatorioFichaBoletos(ECodBoleto, ENumParcela,
                                                        ECodTipoArquivo: Integer): String;
const
  NomMetodo: String = 'GerarRelatorioFichaBoletos';
  CodMetodo: Integer = 640;
var
  FichaBoletos: TRelatorioPadrao;
  FIntOrdemServico: TIntOrdensServico;

  sQuebra,
  sTxtSubTitulo,
  Cabecalho,
  Cabecalho2,
  SFichaBoletos: String;

  Retorno: Integer;
begin
  Result := '';
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Exit;
  end;


  FichaBoletos  := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  FIntOrdemServico := TIntOrdensServico.Create;
  Retorno := FIntOrdemServico.Inicializar(Conexao, Mensagens);
  if Retorno < 0 then
  begin
    Exit;
  end;

  try
    try
      Retorno := Buscar(ECodBoleto, ENumParcela);
      if Retorno < 0 then
      begin
        Exit;
      end;

      Retorno := FIntOrdemServico.Buscar(FIntBoletoBancario.CodOrdemServico);
      if Retorno < 0 then
      begin
        Exit;
      end;

      sTxtSubTitulo := 'Ordem de Serviço nº ' + IntToStr(FIntOrdemServico.OrdemServico.NumOrdemServico);

      FichaBoletos.TipoDoArquvio                := ECodTipoArquivo;
      FichaBoletos.TxtSubTitulo                 := sTxtSubTitulo;
      FichaBoletos.FormatarTxtDados             := False;
      FichaBoletos.PrimeiraLinhaNegritoTxtDados := True;
      FichaBoletos.CodTamanhoFonteTxtDados      := 2;
      FichaBoletos.TxtDados                     := SFichaBoletos;
      sQuebra := '';

      //Monta a CAPA da Ficha de boletos
      FichaBoletos.CodOrientacao   := 1;
      FichaBoletos.CodTamanhoFonte := 2;
      FichaBoletos.QtdColunas      := 1;
      FichaBoletos.TxtTitulo       := 'Ficha de boleto bancário';

      {Inicializa o procedimento de geração do arquivo de relatório}
      Retorno := FichaBoletos.InicializarRelatorio;
      if Retorno < 0 then Exit;

      FichaBoletos.InicializarQuadro('N');
      if Length(FIntOrdemServico.OrdemServico.NumCNPJCPFProdutor) = 11 then
      begin
        SFichaBoletos := 'Produtor:       ' + PadR(Trim(FIntOrdemServico.OrdemServico.SglProdutor) + ' - ' + RedimensionaString(FIntOrdemServico.OrdemServico.NomProdutor, 40), ' ', 45);
        SFichaBoletos := SFichaBoletos + 'CPF:           ' + FIntOrdemServico.OrdemServico.NumCNPJCPFProdutorFormatado;
      end
      else
      begin
        SFichaBoletos := 'Produtor:       ' + PadR(Trim(FIntOrdemServico.OrdemServico.SglProdutor) + ' - ' + RedimensionaString(FIntOrdemServico.OrdemServico.NomProdutor, 40), ' ', 45);
        SFichaBoletos := SFichaBoletos + 'CNPJ:          ' + FIntOrdemServico.OrdemServico.NumCNPJCPFProdutorFormatado;
      end;

      FichaBoletos.FonteNegrito;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);

      SFichaBoletos := 'Prop. rural:    ' + PadR(FIntOrdemServico.OrdemServico.NomPropriedadeRural, ' ', 45);
      if Length(Trim(FIntOrdemServico.OrdemServico.NumImovelReceitaFederal)) = 8 then
      begin
        SFichaBoletos := SFichaBoletos + 'NIRF:          ' + FIntOrdemServico.OrdemServico.NumImovelReceitaFederal
      end
      else if Length(Trim(FIntOrdemServico.OrdemServico.NumImovelReceitaFederal)) = 13 then
      begin
        SFichaBoletos := SFichaBoletos + 'INCRA:         ' + FIntOrdemServico.OrdemServico.NumImovelReceitaFederal
      end
      else
      begin
        SFichaBoletos := SFichaBoletos;
      end;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      SFichaBoletos := 'Técnico:        ' + PadR(RedimensionaString(FIntOrdemServico.OrdemServico.NomTecnico, 39), ' ', 45);
      if (Length(FIntOrdemServico.OrdemServico.NumCNPJCPFTecnico) = 14) then
      begin
        SFichaBoletos := SFichaBoletos + 'CNPJ:          '     + FIntOrdemServico.OrdemServico.NumCNPJCPFTecnicoFormatado
      end
      else if (Length(FIntOrdemServico.OrdemServico.NumCNPJCPFTecnico) = 11) then
      begin
        SFichaBoletos := SFichaBoletos + 'CPF:           '     + FIntOrdemServico.OrdemServico.NumCNPJCPFTecnicoFormatado;
      end;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Vendedor:       ' + PadR(RedimensionaString(FIntOrdemServico.OrdemServico.NomVendedor, 39), ' ', 45);
      if (Length(FIntOrdemServico.OrdemServico.NumCNPJCPFVendedor) = 14) then
      begin
        SFichaBoletos := SFichaBoletos + 'CNPJ:          ' + FIntOrdemServico.OrdemServico.NumCNPJCPFVendedorFormatado
      end
      else if (Length(FIntOrdemServico.OrdemServico.NumCNPJCPFVendedor) = 11) then
      begin
        SFichaBoletos := SFichaBoletos + 'CPF:           ' + FIntOrdemServico.OrdemServico.NumCNPJCPFVendedorFormatado;
      end;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);

      FichaBoletos.NovaLinha;
      SFichaBoletos := 'Quant. animais: ' + IntToStr(FIntOrdemServico.OrdemServico.QtdAnimais);
      if FIntOrdemServico.OrdemServico.IndAnimaisRegistrados = 'S' then
      begin
        SFichaBoletos := SFichaBoletos + ' (registrados em associação de raça)';
      end;
      FichaBoletos.FonteNegrito;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      FichaBoletos.FinalizarQuadro;

      FichaBoletos.NovaLinha;         

      FichaBoletos.InicializarQuadro('S');
      SFichaBoletos := 'Valor Unitário';
      FichaBoletos.FonteNegrito;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      if UpperCase(ValorParametro(110)) = 'S' then
      begin
        SFichaBoletos := 'Vendedor:     R$ ' + PadR(FormatFloat('0.00', FIntBoletoBancario.ValUnitarioVendedor), ' ', 32);
      end
      else
      begin
        SFichaBoletos := 'Certificação: R$ ' + PadR(FormatFloat('0.00', FIntBoletoBancario.ValUnitarioCertificadora), ' ', 32);
      end;
      SFichaBoletos := SFichaBoletos + 'Situação boleto: ' + FIntBoletoBancario.SglSituacaoBoleto + ' - ' + FIntBoletoBancario.DesSituacaoBoleto;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);

      if UpperCase(ValorParametro(110)) = 'S' then
      begin
        SFichaBoletos := 'Técnico:      R$ ' + PadR(FormatFloat('0.00', FIntBoletoBancario.ValUnitarioTecnico), ' ', 32);
      end
      else
      begin
        SFichaBoletos := PadR('', ' ', 49);
      end;
      SFichaBoletos := SFichaBoletos + 'Banco:           ' + FIntBoletoBancario.NomBanco;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);

      if UpperCase(ValorParametro(110)) = 'S' then
      begin
        SFichaBoletos := 'Certificação: R$ ' + PadR(FormatFloat('0.00', FIntBoletoBancario.ValUnitarioCertificadora), ' ', 32);
      end
      else
      begin
        SFichaBoletos := PadR('', ' ', 49);
      end;
      SFichaBoletos := SFichaBoletos + 'Valor adesão/vistoria: R$ ' + FormatFloat('0.00', FIntBoletoBancario.ValVistoria);
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Total:        R$ ' + PadR(FormatFloat('0.00', FIntBoletoBancario.ValUnitarioVendedor + FIntBoletoBancario.ValUnitarioTecnico + FIntBoletoBancario.ValUnitarioCertificadora), ' ', 32);
      SFichaBoletos := SFichaBoletos + 'Valor total:           R$ ' + FormatFloat('0.00', FIntBoletoBancario.ValTotalOS);
      FichaBoletos.FonteNegrito;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      FichaBoletos.DividirQuadroAoMeio();
      FichaBoletos.FinalizarQuadro;

      FichaBoletos.NovaLinha;      

      // Informações do endereço de cobrança do boleto bancário
      FichaBoletos.InicializarQuadro('S');
      FichaBoletos.FonteNegrito;
      SFichaBoletos := 'Endereço de cobrança';
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      SFichaBoletos := 'Contato:        ' + PadR(RedimensionaString(FIntBoletoBancario.enderecoCobranca.NomPessoaContato, 43), ' ', 45);
      SFichaBoletos := SFichaBoletos + 'Telefone:      ' + FIntBoletoBancario.enderecoCobranca.NumTelefone;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Logradouro:     ' + RedimensionaString(FIntBoletoBancario.enderecoCobranca.NomLogradouro, 79);
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Bairro:         ' + PadR(RedimensionaString(FIntBoletoBancario.enderecoCobranca.NomBairro, 43), ' ', 45);
      SFichaBoletos := SFichaBoletos + 'CEP:           ' + FIntBoletoBancario.enderecoCobranca.NumCEP;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Município:      ' + Trim(FIntBoletoBancario.enderecoCobranca.NomMunicipio) + ' - ' + FIntBoletoBancario.enderecoCobranca.SglEstado;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FinalizarQuadro;

      FichaBoletos.NovaLinha;      

      // Informações das parcelas do boleto bancário      
      FichaBoletos.InicializarQuadro('S');
      FichaBoletos.FonteNegrito;
      SFichaBoletos := 'Parcelas';
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      FichaBoletos.FonteNormal;
      SFichaBoletos := 'Pagamento:      ' + FIntBoletoBancario.DesFormaPagamentoBoleto;
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);

      Retorno := Pesquisar(FIntBoletoBancario.CodOrdemServico);
      if Retorno < 0 then
      begin
        Exit;
      end;

      while not Query.Eof do
      begin
        if Query.FieldByName('CodSituacaoBoleto').AsInteger = 99 then
        begin
          Query.Next;
          Continue;
        end;

        if ENumParcela = Query.FieldByName('NumParcela').AsInteger then
        begin
          FichaBoletos.FonteNegrito;
        end
        else
        begin
          FichaBoletos.FonteNormal;
        end;
        SFichaBoletos := Query.FieldByName('NumParcela').AsString + ' - Vencimento: ' + PadR(Query.FieldByName('DtaVencimentoBoleto').AsString, ' ', 45);
        SFichaBoletos := SFichaBoletos + 'Valor:      R$ ' + FormatFloat('0.00', Query.FieldByName('ValTotalBoleto').AsCurrency);
        FichaBoletos.ImprimirTexto(01, SFichaBoletos);
        Query.Next;
      end;

      FichaBoletos.FinalizarQuadro;
      FichaBoletos.FonteNormal;
      FichaBoletos.NovaLinha;

      FichaBoletos.InicializarQuadro('S');
      SFichaBoletos := 'Mensagem 1:     ' + RedimensionaString(FIntBoletoBancario.TxtMensagem3, 79);
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Mensagem 2:     ' + RedimensionaString(FIntBoletoBancario.TxtMensagem4, 79);
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);
      SFichaBoletos := 'Usuário última alteração: ' + PadR(FIntBoletoBancario.NomUsuarioUltimaAlteracao, ' ', 35);
      SFichaBoletos := SFichaBoletos + 'Data última alteração: ' + DateToStr(FIntBoletoBancario.DtaUltimaAlteracao);
      FichaBoletos.ImprimirTexto(01, SFichaBoletos);      
      FichaBoletos.FinalizarQuadro;      

      // Informações sobre o histórico de mudança de situação dos boletos bancários
      Retorno := PesquisarHistoricoMudancaSituacao(ECodBoleto, ENumParcela);
      if Retorno < 0 then
      begin
        Exit;
      end;
      if not Query.Eof then
      begin
        FichaBoletos.NovaLinha;
        if FichaBoletos.LinhasRestantes <= 8 then
        begin
          FichaBoletos.NovaPagina;
        end;
        FichaBoletos.InicializarQuadro('S');
        Cabecalho := PadR('Situação', ' ', 25);
        Cabecalho := Cabecalho + PadR('Mudança', ' ', 11);
        Cabecalho := Cabecalho + PadR('Usuário', ' ', 16);
        Cabecalho := Cabecalho + 'Observação';
        FichaBoletos.ImprimirTexto(01, Cabecalho);
        Cabecalho2 := PadR('Parcela ' + IntToStr(FIntBoletoBancario.NumParcela), ' ', 25);
        Cabecalho2 := Cabecalho2 + PadR('Situação', ' ', 11);
        FichaBoletos.ImprimirTexto(01, Cabecalho2);
        FichaBoletos.FinalizarQuadro;
      end;

      // Imprime as informações de cada parcela.
      Query.First;
      while not Query.Eof do
      begin
        FichaBoletos.ImprimirTexto(01,
                                   PadR(RedimensionaString(Query.FieldByName('SglSituacaoBoleto').AsString + ' - ' + Query.FieldByName('DesSituacaoBoleto').AsString, 25), ' ', 25) +
                                   PadR(FormatDateTime('dd/mm/yyyy', Query.FieldByName('DtaMudancaSituacao').AsDateTime), ' ', 11) +
                                   PadR(Query.FieldByName('NomUsuarioUltimaAlteracao').AsString, ' ', 16) +
                                   RedimensionaString(Query.FieldByName('TxtObservacao').AsString, 41)
                                   );
        Query.Next
      end;

      Retorno := FichaBoletos.FinalizarRelatorio;

      if Retorno = 0 then
      begin
        Mensagens.Clear;
        Result := FichaBoletos.NomeArquivo;
      end
      else
      begin
        Result := '';
      end;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2180, Self.ClassName, NomMetodo, [E.Message]);
        Result := '';
        Exit;
      end;
    end;
  finally
    FIntOrdemServico.Free;
    FichaBoletos.Free;
  end;
end;


{* Função responsável por retornar o histórico das mudanças de situação ocorridas
   durante a vida de um boleto bancário.

   @param ECodBoletoBancario Inteiro
   @param ENumParcela Inteiro

   @return 0     Retorno caso o método seja executado com sucesso.
   @return -188  Retorno caso o usuário logado no sistema não tenha permissão para
                 executar o método.
   @return -2179 Retorno caso seja gerada alguma exceção durante a execução do
                 método.
}
function TIntBoletosBancario.PesquisarHistoricoMudancaSituacao(ECodBoletoBancario,
                                                               ENumParcela: Integer): Integer;
const
  NomMetodo: String = 'PesquisarHistoricoMudancaSituacao';
  CodMetodo: Integer = 639;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add(' select thsb.cod_boleto as CodBoleto ' +
                  '      , thsb.num_parcela as CodParcela ' +
                  '      , thsb.cod_situacao_boleto as CodSituacaoBoleto' +
                  '      , tsb.sgl_situacao_boleto as SglSituacaoBoleto ' +
                  '      , tsb.des_situacao_boleto as DesSituacaoBoleto ' +
                  '      , thsb.cod_usuario_alteracao as CodUsuarioAlteracao ' +
                  '      , tu.nom_usuario as NomUsuarioUltimaAlteracao ' +
                  '      , thsb.dta_mudanca_situacao as DtaMudancaSituacao ' +
                  '      , thsb.txt_observacao as TxtObservacao ' +
                  '   from tab_historico_situacao_boleto thsb ' +
                  '      , tab_situacao_boleto tsb ' +
                  '      , tab_usuario tu ' +                  
                  '  where thsb.cod_situacao_boleto = tsb.cod_situacao_boleto ' +
                  '    and thsb.cod_usuario_alteracao = tu.cod_usuario ' +
                  '    and thsb.cod_boleto = :cod_boleto ');
    Query.ParamByName('cod_boleto').AsInteger := ECodBoletoBancario;
    if ENumParcela > 0 then
    begin
      Query.SQL.Add('  and thsb.num_parcela = :num_parcela ' );
      Query.ParamByName('num_parcela').AsInteger := ENumParcela;
    end;
    Query.SQL.Add('order by thsb.cod_boleto, thsb.num_parcela, thsb.dta_mudanca_situacao');
    Query.Open;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2179, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2179;
      Exit;
    end;
  end;
end;

function TIntBoletosBancario.PesquisarFormaPagamentoBoleto(ECodFormaPagamentoBoleto: Integer): Integer;
const
  NomMetodo: String = 'PesquisarFormaPagamentoBoleto';
  CodMetodo: Integer = 642;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.SQL.Add(' select cod_forma_pagto_boleto as CodFormaPagamentoBoleto ' +
                  '      , sgl_forma_pagto_boleto as SglFormaPagamentoBoleto ' +
                  '      , des_forma_pagto_boleto as DesFormaPagamentoBoleto ' +
                  '      , qtd_parcela_boleto as QtdParcelaBoleto ' +
                  '      , qtd_dias_parcela_1 as QtdDiasParcela1 ' +
                  '      , qtd_dias_parcela_2 as QtdDiasParcela2 ' +
                  '      , qtd_dias_parcela_3 as QtdDiasParcela3 ' +
                  '      , qtd_dias_parcela_4 as QtdDiasParcela4 ' +
                  '      , qtd_dias_parcela_5 as QtdDiasParcela5 ' +
                  '   from tab_forma_pagto_boleto ' +
                  '  where dta_fim_validade is null ');
    if ECodFormaPagamentoBoleto > 0 then
    begin
      Query.SQL.Add('  and cod_forma_pagto_boleto = :cod_forma_pagto_boleto ');
      Query.ParamByName('cod_forma_pagto_boleto').AsInteger := ECodFormaPagamentoBoleto;
    end;

    Query.Open;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2208, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2208;
      Exit;
    end;
  end;
end;

end.
