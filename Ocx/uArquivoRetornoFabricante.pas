unit uArquivoRetornoFabricante;

interface

uses Classes, SysUtils, uConexao, uIntMensagens, uIntClassesBasicas,
  uFerramentas, XMLdom, ActiveX;

const
  cCodTipoOrigemArquivoUpload: Integer = 1;
  cCodTipoOrigemArquivoFTP: Integer = 2;
  cParCaminhoDiretorioUpload: Integer = 21;
  cParCaminhoDiretorioFtp: Integer = 72;
  cParCaminhoDiretorioErroFTP: Integer = 73;
  cParCaminhoDiretorioFabricante: Integer = 90;

type
  { Thread que processa o arquivo de importação dos fabricantes }
  TThreadProcessarArquivoFabricante = class (TThread)
  private
    function GetRetorno: Integer;
  protected
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FCodArquivoImportacao: Integer;
    FLinhaInicial: Integer;
    FTempoMaximo: Integer;
    FCodTarefa: Integer;

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

  { Classe básica para o processamento dos arquivos de improtação do fabricantes }
  TArquivoRetornoFabricante = class(TIntClasseBDBasica)
  protected
    FThread: TThreadProcessarArquivoFabricante;
    FQtdRegistrosProcessados,
    FQtdRegistrosErro,
    FQtdRegistrosTotal: Integer;

    function DescompactaArquivo(CodTipoOrigem: Integer;
      NomeArquivo, NomeArquivoAbsoluto: String): String;
    function GetNomeCompleto(CodTipoOrigem: Integer;
      NomeArquivo: String): String;
    function GetNomeArquivoDestino(CodArquivo: Integer; Extensao: String): String;
    function VerificaExistenciaArquivo(CodTipoOrigem: Integer; NomeArquivo: String): String;
    procedure InserirArquivo(CodArqImportFabricante: Integer; NomArqUpload,
      NomArqImportFabricante: String; CodTipoOrigemArqImport,
      QtdRegistrosTotal: Integer;  CodSituacaoArqImport,
      TxtMensagem: String);
    procedure PrepararProcessamento;
    procedure InserirOcorrencia(CodArqImportFabricante, CodTipoMensagem: Integer;
      TxtMensagem, TxtIdentificacao, TxtLegendaIdentificacao: String);
    procedure GravarOcorrencias(CodArqImportFabricante: Integer;
      TxtIdentificacao, TxtLegendaIdentificacao: String);
    function ProximoCodigoArqFabricante: Integer;
    procedure AtualizarRegistro;
    procedure IncrementaProgresso;
    procedure AtualizarStatusProcessamento(CodStatusTarefa: String = 'C';
      Mensagem: String = '');
  public
    function Processar: Integer; virtual; abstract;
    function Validar(CodTipoOrigem: Integer; NomeArquivo: String): Integer;
      virtual; abstract;
    class function GetInstancia(EThread: TThreadProcessarArquivoFabricante;
      Tipo: Integer): TArquivoRetornoFabricante;

    property Thread: TThreadProcessarArquivoFabricante read FThread write FThread;
  end;

  TArquivoRetornoFabricanteXML = class(TArquivoRetornoFabricante)
  end;

  TArquivoRetornoFabricanteTipo1 = class(TArquivoRetornoFabricanteXML)
  protected
    procedure ContarRegistros(No: IDOMNode; var QtdPedidos: Integer;
      var IndArquivoValido: Boolean; var MsgErro: String);
    function ProcessarRegistros(Node: IDOMNode; CodFabricante: Integer): Integer;
  public
    function Processar: Integer; override;
    function Validar(CodTipoOrigem: Integer; NomeArquivo: String): Integer; override;
  end;

implementation

uses uLibZipM, XMLDoc, SqlExpr, DB, uIntOrdensServico, ComObj,
  uIntOcorrenciasSistema, DateUtils;

{ TThreadProcessarArquivoFabricante }

{ Construtor da Thread.

Parametros:
  CodTarefa: Código da tarefa que deve ser processada.
  Conexao: Conexão com a base de dados.
  Mensagens: Objeto de log.
  CodArquivoImportacao: Código do arquivo a ser processado.

Retorno:
  ...}
constructor TThreadProcessarArquivoFabricante.CreateTarefa(
  CodTarefa: Integer; Conexao: TConexao; Mensagens: TIntMensagens;
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

{ Método que efetivamente processa o arquivo.

Parametros:
  ...

Retorno:
  ...}
procedure TThreadProcessarArquivoFabricante.Execute;
var
  Arquivo: TArquivoRetornoFabricante;
begin
  // O código está fixo como 1, mas deve ser alterado de acordo com a inclusão
  // de novos arquivos de fabricantes diferente
  Arquivo := TArquivoRetornoFabricante.GetInstancia(self, 1);
  try
    Arquivo.Inicializar(FConexao, FMensagens);
    ReturnValue := Arquivo.Processar;
  finally
    Arquivo.Free;
  end;
end;

function TThreadProcessarArquivoFabricante.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

{ TArquivoRetornoFabricante }

{ Atualiza a quantidade de registros processados e com erro do arquivo.

Exceptions:
  EHerdomException caso ocorra algum erro.}
procedure TArquivoRetornoFabricante.AtualizarRegistro;
const
  NomeMetodo: String = 'AtualizarRegistro';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_arq_import_fabricante');
        SQL.Add('   SET qtd_registros_errados = :qtd_registros_errados,');
        SQL.Add('       qtd_registros_processados = :qtd_registros_processados,');
        SQL.Add('       dta_processamento = getDate(),');
        SQL.Add('       cod_tarefa = :cod_tarefa');
        SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger := FThread.CodArquivoImportacao;
        ParamByName('qtd_registros_errados').AsInteger := FQtdRegistrosErro;
        ParamByName('qtd_registros_processados').AsInteger := FQtdRegistrosProcessados;
        ParamByName('cod_tarefa').AsInteger := FThread.CodTarefa;
        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1983, Self.ClassName, NomeMetodo, [E.Message],
        False);
    end;
  end;
end;

{ Atualiza o status da tarefa para executado ou pendente de acordo com os
  registros processados.

Parametros:
  CodStatusTarefa: Código da tarefa. Por padrão é o código da tarefa concluida
    com sucesso.

Exceptions:
  EHerdomException caso ocorra algum erro.}
procedure TArquivoRetornoFabricante.AtualizarStatusProcessamento(
  CodStatusTarefa: String = 'C'; Mensagem: String = '');
const
  NomeMetodo: String = 'AtualizarStatusProcessamento';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Atualiza a tarefa
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('update tab_tarefa');
        SQL.Add('   set cod_situacao_tarefa = :cod_situacao_tarefa,');
        SQL.Add('       dta_fim_real = getDate(),');
        SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro');
        SQL.Add(' where cod_tarefa = :cod_tarefa');

        ParamByName('cod_tarefa').AsInteger := FThread.CodTarefa;
        ParamByName('cod_situacao_tarefa').AsString := CodStatusTarefa;
        AtribuiParametro(QueryLocal, Copy(Mensagem, 1, 255), 'txt_mensagem_erro', '');
        ExecSQL();
      end;

      // Atualiza o arquivo
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('update tab_arq_import_fabricante');
        SQL.Add('   set cod_situacao_arq_import = :cod_situacao_arq_import,');
        SQL.Add('       txt_mensagem = :txt_mensagem');
        SQL.Add(' where cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger :=
          FThread.CodArquivoImportacao;
        AtribuiParametro(QueryLocal, Copy(Mensagem, 1, 255), 'txt_mensagem', '');
        if CodStatusTarefa = 'E' then
        begin
          ParamByName('cod_situacao_arq_import').AsString := 'P';
        end
        else
        begin
          ParamByName('cod_situacao_arq_import').AsString := 'C';
        end;
        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1979, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Descompacta o arquivo, exclui o arquivo compactado e retorna o nome do
  arquivo descompactado. Se o arquivo não estiver compactado retorna o mesmo
  nome.

Parametros:
  CodTipoOrigem: Tipo de orgiem do arquivo FTP ou Upload
  NomeArquivo: Nome do arquivo
  NomeArquivoAbsoluto: Nome do arquivo com a pasta

Retorno:
  Nome do arquivo descompactado.}
function TArquivoRetornoFabricante.DescompactaArquivo(
  CodTipoOrigem: Integer; NomeArquivo, NomeArquivoAbsoluto: String): String;
const
  NomeMetodo: String = 'DescompactaArquivo';
var
  ArquivoZip: unzFile;
  Retorno: Integer;
  NomeArquivoDescompactado: String;
begin
  // Verifica se o arquivo de upload está compactado
  if UpperCase(ExtractFileExt(NomeArquivoAbsoluto)) <> '.ZIP' then
  begin
    Result := NomeArquivoAbsoluto;
    Exit;
  end;

  // Tentar abrir o arquivo ZIP
  Retorno := AbrirUnZip(NomeArquivoAbsoluto, ArquivoZip);
  if Retorno < 0 then
  begin
    if not DeleteFile(NomeArquivoAbsoluto) then
    begin
      // Gera Mensagem erro informando o problema ao usuário
      raise EHerdomException.Create(2003, Self.ClassName, NomeMetodo,
        [ExtractFileName(NomeArquivoAbsoluto)], False);
    end;
    raise EHerdomException.Create(1360, Self.ClassName, NomeMetodo,
      [NomeArquivo], False);
  end;

  // Consiste o número de arquivo dentro do Arquivo ZIP
  Retorno := NumArquivosDoUnZip(ArquivoZip);
  if Retorno <= 0 then
  begin
    FecharUnZip(ArquivoZip);
    raise EHerdomException.Create(1361, Self.ClassName, NomeMetodo,
      [NomeArquivo], True);
  end
  else
  if Retorno > 1 then
  begin
    FecharUnZip(ArquivoZip);
    raise EHerdomException.Create(1362, Self.ClassName, NomeMetodo,
      [NomeArquivo], False);
  end;

  // Obtem o nome do primeiro arquivo (teoricamente deve ser o último)
  NomeArquivoDescompactado := NomeArquivoCorrenteDoUnzip(ArquivoZip);

  // Extrai o arquivo compactado
  Retorno := ExtrairArquivoDoUnZip(ArquivoZip, NomeArquivoDescompactado,
    ExtractFilePath(NomeArquivoAbsoluto));
  if Retorno <> 0 then
  begin
    FecharUnZip(ArquivoZip);
    if (Retorno = -5) or (Retorno = -6) then
    begin
      DeleteFile(NomeArquivoDescompactado);
    end;

    raise EHerdomException.Create(1361, Self.ClassName, NomeMetodo,
      [NomeArquivo], False);
  end;

  // Fechar arquivo ZIP
  FecharUnZip(ArquivoZip);

  // Apaga arquivo compactado
  if not DeleteFile(NomeArquivoAbsoluto) then
  begin
    // Gera Mensagem erro informando o problema ao usuário
    raise EHerdomException.Create(2003, Self.ClassName, NomeMetodo,
      [ExtractFileName(NomeArquivoAbsoluto)], False);
  end;

  // Retorna o nome do novo arquivo.
  Result := ExtractFilePath(NomeArquivoAbsoluto) + NomeArquivoDescompactado;
end;

{ Método que retorna uma instância da classe que processa o arquivo do tipo
  informado. Este método implementa o padrão Builder (GOF).

Parametros:
  Tipo: Tipo do arquivo a ser processado.

Retorno:
  Instância da classe que processa o tipo do arquivo informado.}
class function TArquivoRetornoFabricante.GetInstancia(
  EThread: TThreadProcessarArquivoFabricante;
  Tipo: Integer): TArquivoRetornoFabricante;
begin
  Result := nil;

  case Tipo of
    1: Result := TArquivoRetornoFabricanteTipo1.Create;
  end;
  
  Result.Thread := EThread;
end;

{ TArquivoRetornoFabricanteTipo1 }

{ Função recursiva que obtem a quantidade de registros a serem processados
  no arquivo XML.

  OBS: Não descobrir uma forma automática de fazer a validação do
  arquivo XML pelo DTD, assim a validação do arquivo está sendo feita
  manualmente durante a contagem dos registros.

Parametros:
  No: Nó do arquivo a ser analisado.
  QtdPedidos: Variavel de retorno com a quantidade de registros do arquivo.
  IndArquivoValido: Parametro de retorno. Indica se o arquivo é válido ou não.
    Se este atrivuto for False significa que o arquivo é inválido
  MsgErro: Parametro de retorno. Se o arquivo for inválido esta variavel
    vai conter uma mensagem descrevendo o erro encontrado.}
procedure TArquivoRetornoFabricanteTipo1.ContarRegistros(No: IDOMNode;
  var QtdPedidos: Integer; var IndArquivoValido: Boolean; var MsgErro: String);
var
  I: Integer;
  Node: IDOMNode;
begin
  if No = nil then
  begin
    Exit;
  end;

  for I := 0 to No.childNodes.length - 1 do
  begin
    ContarRegistros(No.childNodes.item[I], QtdPedidos, IndArquivoValido, MsgErro);
  end;

  if UpperCase(no.nodeName) = 'PEDIDO' then
  begin
    Inc(QtdPedidos);

    // Verifica se os campos obrigatórios estão preenchidos
    if No.attributes.getNamedItem('id_pedido') = nil then
    begin
      IndArquivoValido := False;
      MsgErro := 'Erro. O atributo IND_PEDIDO da tag PEDIDO é obrigatório.';
    end;
    if No.attributes.getNamedItem('data_hora_status') = nil then
    begin
      IndArquivoValido := False;
      MsgErro := 'Erro pedido ' + No.attributes.getNamedItem('id_pedido').nodeValue
        + '.O atributo DATA_HORA_STATUS da tag PEDIDO é obrigatório.';
    end;
    if No.attributes.getNamedItem('status') = nil then
    begin
      IndArquivoValido := False;
      MsgErro := 'Erro pedido ' + No.attributes.getNamedItem('id_pedido').nodeValue
        + '.O atributo STATUS da tag PEDIDO é obrigatório.';
    end;

    // Verifica se o arquivo é valido.
    Node := no.parentNode;
    if (Node = nil) or (UpperCase(Node.nodeName) <> 'PEDIDOS') then
    begin
      IndArquivoValido := False;
      MsgErro := 'Estrutura do arquivo inválida.';
    end
    else
    begin
      Node := Node.parentNode;
      if (Node = nil) or (UpperCase(Node.nodeName) <> 'EDI') then
      begin
        IndArquivoValido := False;
        MsgErro := 'Estrutura do arquivo inválida.';
      end;
    end;

    // Verifica se a tag ENVIO é válida
    for I := 0 to No.childNodes.length - 1 do
    begin
      if (UpperCase(No.ChildNodes.Item[I].NodeName) = 'ENVIO') then
      begin
        if No.ChildNodes.Item[I].attributes.getNamedItem('nome_servico') = nil then
        begin
          IndArquivoValido := False;
          MsgErro := 'Erro pedido ' + No.attributes.getNamedItem('id_pedido').nodeValue
            + '.O atributo NOME_SERVICO da tag ENVIO é obrigatório.';
        end;
      end;
    end;
  end;
end;

{ Processa um arquivo de retorno dos fabricantes de identificadores.

Parametros:
  ...

Retorno:
  >= 0 se tudo ocorreu bem
  <  0 se ocorreu algum erro}
function TArquivoRetornoFabricanteTipo1.Processar: Integer;
const
  NomeMetodo: String = 'Processar';
var
  QueryLocal: THerdomQuery;
  NomeArquivoCompleto: String;
  Retorno,
  CodFabricante: Integer;
  XmlDocument: TXMLDocument;
  No: IDOMNode;
begin
  CoInitialize(nil);
  try
    Result := 0;
    try
      // Verifica se a classe foi inicializada corretamente
      if (FThread = nil) then
      begin
        raise Exception.Create('Inicialize o objeto corretamente.');
      end;

      NomeArquivoCompleto := Conexao.ValorParametro(cParCaminhoDiretorioFabricante,
        Mensagens);
      if (Length(NomeArquivoCompleto) = 0)
        or (NomeArquivoCompleto[Length(NomeArquivoCompleto)] <> '\') then
      begin
        NomeArquivoCompleto := NomeArquivoCompleto + '\';
      end;

      QueryLocal := THerdomQuery.Create(Conexao, nil);
      try
        // Obtem a quantidade de registros e o nome do arquvo.
        with QueryLocal do
        begin
          SQL.Clear;
          SQL.Add('SELECT qtd_registros_total,');
          SQL.Add('       cod_fabricante_identificador,');
          SQL.Add('       nom_arq_import_fabricante');
          SQL.Add('  FROM tab_arq_import_fabricante');
          SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');
          ParamByName('cod_arq_import_fabricante').AsInteger :=
            FThread.CodArquivoImportacao;
          Open;

          NomeArquivoCompleto := NomeArquivoCompleto +
            FieldByName('nom_arq_import_fabricante').AsString;
          CodFabricante :=
            FieldByName('cod_fabricante_identificador').AsInteger;
          FQtdRegistrosTotal := FieldByName('qtd_registros_total').AsInteger;
          FQtdRegistrosErro := 0;
          FQtdRegistrosProcessados := 0;
          Close;
        end;
      finally
        QueryLocal.Free;
      end;

      Begintran;
      PrepararProcessamento;
      Commit;

      // Processa registros
      XmlDocument := TXMLDocument.Create(nil);
      try
        XmlDocument.LoadFromFile(NomeArquivoCompleto);

        No := XmlDocument.DOMDocument.firstChild;
        while (no <> nil) and not FThread.Suspended do
        begin
          Retorno := ProcessarRegistros(no, CodFabricante);
          if Retorno < 0 then
          begin
            Result := Retorno;
          end;
          no := no.nextSibling;
        end;
      finally
        XmlDocument.Free;
      end;

      // Atualiza o status da tarefa.
      Begintran;
      AtualizarStatusProcessamento;
      Commit;
    except
      on E: EHerdomException do
      begin
        E.gerarMensagem(Mensagens);
        Result := -E.CodigoErro;

        // Atualiza o status da tarefa.
        if EmTransacao then
          Rollback;
        try
          Begintran;
          AtualizarStatusProcessamento('E',
            Mensagens.Items[Mensagens.Count - 1].Texto);
          Commit;
        except
          on E: EHerdomException do
          begin
            Rollback;
            E.gerarMensagem(Mensagens);
            Result := -E.CodigoErro;
          end;
        end;
      end;
      on E: Exception do
      begin
        Mensagens.Adicionar(1979, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1979;

        // Atualiza o status da tarefa.
        if EmTransacao then
          Rollback;
        try
          Begintran;
          AtualizarStatusProcessamento('E',
            Mensagens.Items[Mensagens.Count - 1].Texto);
          Commit;
        except
          on E: EHerdomException do
          begin
            Rollback;
            E.gerarMensagem(Mensagens);
            Result := -E.CodigoErro;
          end;
        end;
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

{ Função recursiva que tenta mudar a situação dos pedidos enviados pelo fabricante.
  Caso ocorra algum erro a linha com erro é ignorada e o processamento continua.

Parametros:
  Node: nó do arquivo XML a ser analizado.
  CodFabricante: Código do fabricante de identificadores ao qual o arquivo se refere.
  QtdPedidos: Quantidade de pedidos do arquivo. Usada para atualizar a porcentagem
    de andamento no processamento do arquivo.

Retorno:
  >= 0 se todo o processamento foi concluido com sucesso.
  < 0 se ocorre algum erro.}
function TArquivoRetornoFabricanteTipo1.ProcessarRegistros(
  Node: IDOMNode; CodFabricante: Integer): Integer;
const
  NomeMetodo: String = 'ProcessarRegistros';
var
  Retorno,
  NroPedido,
  CodOrdemServico,
  CodSituacaoOSDestino,
  I: Integer;
  DtaEnvio: TDateTime;
  IndErroOperacao: Boolean;
  QueryLocal: THerdomQuery;
  NomeServico,
  NroConhecimento,
  StrData,
  TxtObservacao: String;
begin
  Result := 0;
  CodSituacaoOSDestino := 0;
  CodOrdemServico := 0;
  IndErroOperacao := True;

  if Node = nil then
  begin
    Exit;
  end;

  // Processa os nós filhos
  for I := 0 to Node.childNodes.length - 1 do
  begin
    Retorno := ProcessarRegistros(Node.childNodes.item[I], CodFabricante);

    if Retorno < 0 then
    begin
      Result := Retorno;
    end;
  end;

  // Se o tipo do nó for um PEDIDO então processa.
  if UpperCase(Node.nodeName) = 'PEDIDO' then
  begin
    // Inicia a transação do registro.
    Begintran;
    try
      NroPedido := StrToInt(Node.attributes.getNamedItem('id_pedido').nodeValue);
      // dd/mm/yyyy hh:mm:ss
      StrData := Node.attributes.getNamedItem('data_hora_status').nodeValue;
      DtaEnvio := EncodeDateTime(
        StrToInt(Copy(StrData, 12, 4)), // ano
        StrToInt(Copy(StrData, 10, 2)), // mes
        StrToInt(Copy(StrData,  8, 2)), // dia
        StrToInt(Copy(StrData,  1, 2)), // hora
        StrToInt(Copy(StrData,  3, 2)), // minuto
        StrToInt(Copy(StrData,  5, 2)), // segundo
        0);

      // Obtem o código da situação da OS de acorod com o status do pedido.
      if RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S') = 'INICIAL' then
      begin
        CodSituacaoOSDestino := 7; // Pedido de brincos redebido pelo fabricante
      end
      else
      if RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S') = 'ENVIADO' then
      begin
        CodSituacaoOSDestino := 8; // Enviado para o produtor
      end
      else
      if RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S') = 'APROVADO' then
      begin
        CodSituacaoOSDestino := 12; // Aprovado pelo fabricante
      end
      else
      if RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S') = 'EM PRODUCAO' then
      begin
        CodSituacaoOSDestino := 13; // Pedido de identificadores em fabricação
      end
      else
      if RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S') = 'NAO APROVADO' then
      begin
        CodSituacaoOSDestino := 14; // Pedido de identificadores reprovado
      end
      else
      begin
        // Status inválido.
        Mensagens.Adicionar(1982, Self.ClassName, NomeMetodo,
          [RemoveAcentoString(Node.attributes.getNamedItem('status').nodeValue, 'S')]);
        Result := -1982;
        IndErroOperacao := False;
      end;

      if IndErroOperacao then
      begin
        QueryLocal := THerdomQuery.Create(Conexao, nil);
        try
          // Obtem a ordem de serviço referente ao pedido.
          with QueryLocal do
          begin
            SQL.Clear;
            SQL.Add('select cod_ordem_servico,');
            SQL.Add('       isNull(num_ordem_servico, -1) as num_ordem_servico,');
            SQL.Add('       qtd_animais,');
            SQL.Add('       isNull(cod_pessoa_tecnico, -1) as cod_pessoa_tecnico,');
            SQL.Add('       isNull(cod_pessoa_vendedor, -1) as cod_pessoa_vendedor,');
            SQL.Add('       isNull(cod_forma_pagamento_os, -1) as cod_forma_pagamento_os,');
            SQL.Add('       isNull(cod_identificacao_dupla, -1) as cod_identificacao_dupla,');
            SQL.Add('       isNull(cod_fabricante_identificador, -1) as cod_fabricante_identificador,');
            SQL.Add('       isNull(cod_forma_pagamento_ident, -1) as cod_forma_pagamento_ident,');
            SQL.Add('       isNull(cod_produto_acessorio_1, -1) as cod_produto_acessorio_1,');
            SQL.Add('       isNull(qtd_produto_acessorio_1, -1) as qtd_produto_acessorio_1,');
            SQL.Add('       isNull(cod_produto_acessorio_2, -1) as cod_produto_acessorio_2,');
            SQL.Add('       isNull(qtd_produto_acessorio_2, -1) as qtd_produto_acessorio_2,');
            SQL.Add('       isNull(cod_produto_acessorio_3, -1) as cod_produto_acessorio_3,');
            SQL.Add('       isNull(qtd_produto_acessorio_3, -1) as qtd_produto_acessorio_3,');
            SQL.Add('       ind_envia_pedido_ident,');
            SQL.Add('       txt_observacao,');
            SQL.Add('       txt_observacao_pedido,');
            SQL.Add('       cod_situacao_os,');
            SQL.Add('       ind_animais_registrados');
            SQL.Add('  FROM tab_ordem_servico');
            SQL.Add(' WHERE num_pedido_fabricante = :num_pedido_fabricante');
            SQL.Add('   AND cod_fabricante_identificador = :cod_fabricante_identificador');
            ParamByName('num_pedido_fabricante').AsInteger := NroPedido;
            ParamByName('cod_fabricante_identificador').AsInteger := CodFabricante;
            Open;

            if IsEmpty then
            begin
              Mensagens.Adicionar(1981, Self.ClassName, NomeMetodo,
                [IntToStr(NroPedido)]);
              Result := -1981;
              IndErroOperacao := False;
            end
            else
            begin
              CodOrdemServico := FieldByName('cod_ordem_servico').AsInteger;
              Close;
            end;
          end;
        finally
          QueryLocal.Free;
        end;

        if IndErroOperacao then
        begin
          NomeServico := '';
          NroConhecimento := '';
          TxtObservacao := '';

          // Se o pedido possuir os dados do envio ou observação então obtem os dados
          for I := 0 to Node.childNodes.length - 1 do
          begin
            if (UpperCase(Node.ChildNodes.Item[I].NodeName) = 'ENVIO') then
            begin
              if Node.ChildNodes.Item[I].attributes.getNamedItem('nome_servico') <> nil then
              begin
                NomeServico :=
                  Node.ChildNodes.Item[I].attributes.getNamedItem('nome_servico').nodeValue;
              end;
              if Node.ChildNodes.Item[I].attributes.getNamedItem('nro_conhecimento') <> nil then
              begin
                NroConhecimento :=
                  Node.ChildNodes.Item[I].attributes.getNamedItem('nro_conhecimento').nodeValue;
              end;
            end
            else
            if (UpperCase(Node.ChildNodes.Item[I].NodeName) = 'OBSERVACAO') then
            begin
              if Node.ChildNodes.Item[I].attributes.getNamedItem('obs') <> nil then
              begin
                TxtObservacao :=
                  Node.ChildNodes.Item[I].attributes.getNamedItem('obs').nodeValue;
              end;
            end;
          end;

          // Quando a situação for PROD muda pelo método MudarSituacaoParaProd
          // Caso contrário muda pelo método MudarSituacao
          if CodSituacaoOSDestino = 8 then
          begin
            try
              TIntOrdensServico.MudarSituacaoParaProd(Conexao, Mensagens,
                CodOrdemServico, TxtObservacao, DtaEnvio, NomeServico,
                NroConhecimento);
            except
              on E: EHerdomException do
              begin
                E.gerarMensagem(Mensagens);
                Retorno := -E.CodigoErro;
                Result := Retorno;
                IndErroOperacao := False;
              end;
            end;
          end
          else
          begin
            // Muda a situação da OS de acordo com o enviado pelo fabricante.
            Retorno := TIntOrdensServico.MudarSituacao(Conexao, Mensagens,
              CodOrdemServico, CodSituacaoOSDestino,
              TxtObservacao, 'S', 'S');
            if Retorno < 0 then
            begin
              Result := Retorno;
              IndErroOperacao := False;
            end;
          end;
        end;
      end;

      if IndErroOperacao then
      begin
        Inc(FQtdRegistrosProcessados);
      end
      else
      begin
        Inc(FQtdRegistrosErro);
      end;

      AtualizarRegistro;

      // Grava os erros ocorridos durante o processamento, se houver.
      GravarOcorrencias(FThread.CodArquivoImportacao, IntToStr(NroPedido),
        'Número do pedido');

      IncrementaProgresso;

      // Finaliza a transação.
      Commit;
    except
      // Cancela a opração.
      Rollback;
      raise;
    end;
  end;
end;

{ Valida o arquivo para verificar se este é valido e pode ser processado.

Parametros:
  CodTipoOrigem: código da origem do arquivo WEB ou FTP
  NomeArquivo: Nome do arquivo a ser validado.

Retorno:
  >  0, Código do arquivo se tudo ocorreu bem
  <  0 se ocorreu algum erro}
function TArquivoRetornoFabricanteTipo1.Validar(CodTipoOrigem: Integer;
  NomeArquivo: String): Integer;
const
  NomeMetodo: String = 'Validar';
var
  NomeCompleto,
  NomeDestino,
  StrErro: String;
  XmlDocument: TXMLDocument;
  No: IDOMNode;
  QtdNodes,
  CodArquivo: Integer;
  IndArquivoValido: Boolean;
begin
  QtdNodes := 0;
  IndArquivoValido := True;
  StrErro := '';
  try
    // Faz as validações básicas do arquivo.
    NomeCompleto := VerificaExistenciaArquivo(CodTipoOrigem, NomeArquivo);

    // Descompacta o arquivo se ele estiver compactado.
    NomeCompleto := DescompactaArquivo(CodTipoOrigem, NomeArquivo,
      NomeCompleto);

    // Bloco de controle da validação do arquivo.
    try
      // Obtem o código do arquivo
      CodArquivo := ProximoCodigoArqFabricante;
      if CodArquivo < 0 then
      begin
        Result := CodArquivo;
        Exit;
      end;

      // Obetem o nome do arquivo de destino.
      NomeDestino := GetNomeArquivoDestino(CodArquivo, '.XML');

      // Cria o documento XML
      // Neste bloco se ocorrer algum erro durante a validação do arquivo
      // um registro deve ser inserido na base de dados para informar o erro
      // caso contrário o registro é inserido para ser processado posteriormente
      try
        XmlDocument := TXMLDocument.Create(nil);
        try
          // Valida o documento
          XmlDocument.LoadFromFile(NomeCompleto);

          No := XmlDocument.DOMDocument.firstChild;
          while no <> nil do
          begin
            ContarRegistros(no, QtdNodes, IndArquivoValido, StrErro);
            no := no.nextSibling;
          end;

          // Se o arquivo não possuir nenhum pedido, ou o arquivo for inválido.
          if (QtdNodes = 0) or (IndArquivoValido = False) then
          begin
            if StrErro <> '' then
            begin
              raise Exception.Create(StrErro);
            end
            else
            begin
              raise Exception.Create('Estrutura do arquivo inconsistente.');
            end;
          end;

          // Inicia a transação
          Begintran;

          // Insere o arquivo na base de dados.
          InserirArquivo(CodArquivo, NomeArquivo, NomeDestino, CodTipoOrigem,
            QtdNodes, 'N', '');

          // Finaliza a transação.
          Commit;

          // Copia para o novo diretório
          XmlDocument.SaveToFile(NomeDestino);

          // Exclui o documento original
          if not DeleteFile(NomeCompleto) then
          begin
            // Gera Mensagem erro informando o problema ao usuário
            raise EHerdomException.Create(2003, Self.ClassName, NomeMetodo,
              [ExtractFileName(NomeCompleto)], False);
          end;
        finally
          XmlDocument.Free;
        end;
      except
        on E: EHerdomException do
        begin
          raise;
        end;
        on E: Exception do
        begin
          // Insere o arquivo na base de dados com a mensagem de erro.
          InserirArquivo(CodArquivo, NomeArquivo, NomeDestino, CodTipoOrigem,
            QtdNodes, 'I', E.Message);
          raise;
        end;
      end;
    except
      on E: EHerdomException do
      begin
        raise;
      end;
      on E: Exception do
      begin
        raise EHerdomException.Create(1999, Self.ClassName, NomeMetodo, [E.Message],
          False);
      end;
    end;

    Result := CodArquivo;
  except
    on E: EHerdomException do
    begin
      E.gerarMensagem(Mensagens);
      Result := -E.CodigoErro;

      // Exclui o arquivo se ele existir
      if FileExists(NomeCompleto)
        and (CodTipoOrigem <> cCodTipoOrigemArquivoFTP) then
      begin
        DeleteFile(NomeCompleto);
      end;
    end;
    on E: Exception do
    begin
      // Exclui o arquivo se ele existir
      if FileExists(NomeCompleto) 
        and (CodTipoOrigem <> cCodTipoOrigemArquivoFTP) then
      begin
        DeleteFile(NomeCompleto);
      end;

      Mensagens.Adicionar(1976, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1976;
    end;
  end;
end;

{ Obtem o nome completo do arquivo destino. O nome do arquivo de destino é
  composto a partir do código do arquivo para evitar que exista mais de um
  arquivo com o mesmo nome.

Parametros:
  CodArquivo: Código do arquivo.
  Extensao: Estenão do arquivo.

Retorno:
  Nome absoluto do arquivo com a extensão informada.

Exceptions:
  EHerdomException caso ocorra algum erro.}
function TArquivoRetornoFabricante.GetNomeArquivoDestino(
  CodArquivo: Integer; Extensao: String): String;
const
  NomeMetodo: String = 'GetNomeArquivoDestino';
var
  DiretoDestino: String;
begin
  // Recupera pasta adequada dos arquivos
  DiretoDestino := ValorParametro(cParCaminhoDiretorioFabricante);
  if (Length(DiretoDestino) = 0)
    or (DiretoDestino[Length(DiretoDestino)] <> '\') then
  begin
    DiretoDestino := DiretoDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(DiretoDestino) then
  begin
    if not ForceDirectories(DiretoDestino) then
    begin
      // Gera Mensagem erro informando o problema ao usuário
      raise EHerdomException.Create(1217, Self.ClassName, NomeMetodo, [],
        False);
    end;
  end;

  // Monta o nome do arquivo
  Result := DiretoDestino + PadL(IntToStr(CodArquivo), '0', 8) + Extensao;
end;

{ Obtem o nome completo do arquivo de acordo com sua origem.

Parametros:
  CodTipoOrigem: Tipo da orgem do arquivo WEB ou FTP
  NomeArquivo: Nome do arquivo.

Retorno:
  Nome absoluto do arquivo.

Exceptions:
  EHerdomException caso ocorra algum erro.}
function TArquivoRetornoFabricante.GetNomeCompleto(CodTipoOrigem: Integer;
  NomeArquivo: String): String;
const
  NomeMetodo: String = 'GetNomeCompleto';
var
  DiretorioOrigem: String;
begin
  // Recupera pasta temporária de armazenamento
  if CodTipoOrigem = cCodTipoOrigemArquivoUpload then // Caminho para busca no diretorio de Upload
  begin
    DiretorioOrigem := ValorParametro(cParCaminhoDiretorioUpload);
  end else if CodTipoOrigem = cCodTipoOrigemArquivoFTP then // Caminho para busca no diretorio de FTP
  begin
    DiretorioOrigem := ValorParametro(cParCaminhoDiretorioFtp);
  end;

  // Verifica se o nome do arquivo termina com uma contra barra "\" se não
  // terminar inclui a contra barra no final.
  if (Length(DiretorioOrigem) = 0)
    or (DiretorioOrigem[Length(DiretorioOrigem)] <> '\') then
  begin
    DiretorioOrigem := DiretorioOrigem + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(DiretorioOrigem) then begin
    raise EHerdomException.Create(1122, Self.ClassName, NomeMetodo, [], False);
  end;

  // Consiste existência do arquivo informado
  if not FileExists(DiretorioOrigem + NomeArquivo) then begin
    raise EHerdomException.Create(1123, Self.ClassName, NomeMetodo, [], False);
  end;

  Result := DiretorioOrigem + NomeArquivo;
end;

{ Grava todas as ocorrencias da classe de mensagens no banco de dados.

Parametros:
  CodArqImportFabricante: Código do arquivo que esta sendo processado
  TxtIdentificacao: Texto que identifica o registro (código, linha ...)
  TxtLegendaIdentificacao: Texto que descreve a identificação usada.

Exceptions:
  EHerdomException: Quando ocorre algum erro durante a inserção dos registros
    na base de dados.}
procedure TArquivoRetornoFabricante.GravarOcorrencias(
  CodArqImportFabricante: Integer; TxtIdentificacao,
  TxtLegendaIdentificacao: String);
const
  NomeMetodo: String = 'GravarOcorrencias';
var
  I: Integer;
begin
  try
    for I := 0 to Mensagens.Count - 1 do
    begin
      InserirOcorrencia(CodArqImportFabricante, Mensagens.Items[I].Tipo,
        Mensagens.Items[I].Texto, TxtIdentificacao, TxtLegendaIdentificacao);
    end;

    Mensagens.Clear;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1977, Self.ClassName, NomeMetodo, [E.Message],
        False);
    end;
  end;
end;

{ Incrementa o progresso da execução da tarefa.

Exceptions:
  EHerdomException caso ocorra algum erro.}
procedure TArquivoRetornoFabricante.IncrementaProgresso;
const
  NomeMetodo: String = 'IncrementaProgresso';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Add('update tab_tarefa');
        SQL.Add('   set qtd_progresso = :qtd_progresso');
        SQL.Add(' where cod_tarefa = :cod_tarefa');
        ParamByName('cod_tarefa').AsInteger := FThread.CodTarefa;
        ParamByName('qtd_progresso').AsInteger := Trunc(100 *
          (FQtdRegistrosProcessados + FQtdRegistrosErro) / FQtdRegistrosTotal);
        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1979, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Insere um registro na base de dados referente ao arquivo validado.

Parametros:
  CodArqImportFabricante: Código do arquivo.
  NomArqUpload: Nome original do arquivo.
  NomArqImportFabricante: Nome do arquivo no servidor
  CodTipoOrigemArqImport: Tipo de origem do arquivo FTP ou WEB
  QtdRegistrosTotal: Quantidade de registros no arquivo
  CodSituacaoArqImport: Situação do arquivo
  TxtMensagem: Mensagem de erro caso algum tenha ocorrido

Exception:
  EHerdomException: Caso algum erro ocorra.}
procedure TArquivoRetornoFabricante.InserirArquivo(
  CodArqImportFabricante: Integer; NomArqUpload, NomArqImportFabricante: String;
  CodTipoOrigemArqImport, QtdRegistrosTotal: Integer;  CodSituacaoArqImport,
  TxtMensagem: String);
const
  NomeMetodo: String = 'InserirArquivo';
var
  Retorno: Integer;
  QueryLocal: THerdomQuery;
  CodTipoArqImportFabricante,
  CodFabricante: Integer;
  OcorrenciasSistema: TIntOcorrenciasSistema;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem o tipo de arquivo.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_tipo_arq_import_fabricante');
        SQL.Add('  FROM tab_tipo_arq_import_fabricante');
        SQL.Add(' WHERE sgl_tipo_arq_import_fabricante = :sgl_tipo_arq_import_fabricante');

        ParamByName('sgl_tipo_arq_import_fabricante').AsString := UpperCase(
          Copy(NomArqUpload, 1, 3));
        Open;

        if IsEmpty then
        begin
          // Se a origem do arquivo for FTP envia uma ocorrência para informar
          // o usuário que o arquivo é inválido.
          if CodTipoOrigemArqImport = cCodTipoOrigemArquivoFTP then
          begin
            OcorrenciasSistema := TIntOcorrenciasSistema.Create;
            try
              OcorrenciasSistema.Inicializar(Conexao, Mensagens);
              Retorno := OcorrenciasSistema.Inserir(6, 596, 2,
                'Nome do arquivo inválido [' + ExtractFileName(NomArqUpload) +
                ']. O nome deve ser: ' +
                '<tipo-arq>_<nom-fabricante>_<nom-arquivo>.<extensão>.',
                ExtractFileName(NomArqUpload), 'Nome do arquivo');
              if Retorno < 0 then
              begin
                raise EHerdomException.Create(Retorno, Self.ClassName,
                  NomeMetodo, [], true);
              end;
            finally
              OcorrenciasSistema.Free;
            end;
          end;

          raise EHerdomException.Create(1978, Self.ClassName, NomeMetodo,
            [ExtractFileName(NomArqUpload)], False);
        end;

        CodTipoArqImportFabricante :=
          FieldByName('cod_tipo_arq_import_fabricante').AsInteger;

        Close;
      end;

      // Obtem o fabricante do arquivo
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_fabricante_identificador,');
        SQL.Add('       nom_reduzido_fabricante');
        SQL.Add('  FROM tab_fabricante_identificador');
        Open;

        CodFabricante := 0;
        while not Eof do
        begin
          if Pos(UpperCase(FieldByName('nom_reduzido_fabricante').AsString),
            UpperCase(NomArqUpload)) > 0 then
          begin
            CodFabricante :=
              FieldByName('cod_fabricante_identificador').AsInteger;
          end;
          Next;
        end;

        // Verifica se o arquivo pertente a algum fabricante válido
        if CodFabricante = 0 then
        begin
          // Se a origem do arquivo for FTP envia uma ocorrência para informar
          // o usuário que o arquivo é inválido.
          if CodTipoOrigemArqImport = cCodTipoOrigemArquivoFTP then
          begin
            OcorrenciasSistema := TIntOcorrenciasSistema.Create;
            try
              OcorrenciasSistema.Inicializar(Conexao, Mensagens);
              Retorno := OcorrenciasSistema.Inserir(6, 596, 2,
                'O fabricante do arquivo é inválido [' + ExtractFileName(NomArqUpload) +
                ']. O nome deve ser: ' +
                '<tipo-arq>_<nom-fabricante>_<nom-arquivo>.<extensão>.',
                ExtractFileName(NomArqUpload), 'Nome do arquivo');
              if Retorno < 0 then
              begin
                raise EHerdomException.Create(Retorno, Self.ClassName,
                  NomeMetodo, [], true);
              end;
            finally
              OcorrenciasSistema.Free;
            end;
          end;

          raise EHerdomException.Create(1985, Self.ClassName, NomeMetodo,
            [ExtractFileName(NomArqUpload)], False);
        end;

        Close;
      end;

      // Obtem o tipo de arquivo.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('INSERT INTO tab_arq_import_fabricante (');
        SQL.Add('  cod_arq_import_fabricante,');
        SQL.Add('  nom_arq_upload,');
        SQL.Add('  nom_arq_import_fabricante,');
        SQL.Add('  dta_importacao,');
        SQL.Add('  cod_fabricante_identificador,');
        SQL.Add('  cod_tipo_arq_import_fabricante,');
        SQL.Add('  cod_usuario_upload,');
        SQL.Add('  cod_tipo_origem_arq_import,');
        SQL.Add('  cod_situacao_arq_import,');
        SQL.Add('  qtd_registros_total,');
        SQL.Add('  txt_mensagem');
        SQL.Add(') VALUES (');
        SQL.Add('  :cod_arq_import_fabricante,');
        SQL.Add('  :nom_arq_upload,');
        SQL.Add('  :nom_arq_import_fabricante,');
        SQL.Add('  getDate(),');
        SQL.Add('  :cod_fabricante_identificador,');
        SQL.Add('  :cod_tipo_arq_import_fabricante,');
        SQL.Add('  :cod_usuario_upload,');
        SQL.Add('  :cod_tipo_origem_arq_import,');
        SQL.Add('  :cod_situacao_arq_import,');
        SQL.Add('  :qtd_registros_total,');
        SQL.Add('  :txt_mensagem');
        SQL.Add(')');

        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;
        ParamByName('nom_arq_upload').AsString := ExtractFileName(NomArqUpload);
        ParamByName('nom_arq_import_fabricante').AsString := ExtractFileName(NomArqImportFabricante);
        ParamByName('cod_fabricante_identificador').AsInteger := CodFabricante;
        ParamByName('cod_tipo_arq_import_fabricante').AsInteger := CodTipoArqImportFabricante;
        ParamByName('cod_usuario_upload').AsInteger := Conexao.CodUsuario;
        ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
        ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
        ParamByName('qtd_registros_total').AsInteger := QtdRegistrosTotal;
        AtribuiParametro(QueryLocal, TxtMensagem, 'txt_mensagem', '');

        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: EHerdomException do
    begin
      raise;
    end;
    on E: Exception do
    begin
      raise EHerdomException.Create(1977, Self.ClassName, NomeMetodo, [E.Message],
        False);
    end;
  end;
end;

{ Insere uma ocorrencia na base de dados.

Parametros:
  CodArqImportFabricante: Código do arquivo ondo o erro ocorreu
  TxtMensagem: Mensagem de erro
  TxtIdentificacao: Identificador do registro
  TxtLegendaIdentificacao: Descrição do identificador do arquivo

Exceptions:
  EHerdomException: Caso ocorra algum erro.
}
procedure TArquivoRetornoFabricante.InserirOcorrencia(
  CodArqImportFabricante, CodTipoMensagem: Integer; TxtMensagem,
  TxtIdentificacao, TxtLegendaIdentificacao: String);
const
  NomeMetodo: String = 'InserirOcorrencia';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Add('INSERT INTO tab_ocorrencia_import_fab (');
        SQL.Add('  cod_arq_import_fabricante,');
        SQL.Add('  cod_tipo_mensagem,');
        SQL.Add('  txt_mensagem,');
        SQL.Add('  txt_identificacao,');
        SQL.Add('  txt_legenda_identificacao');
        SQL.Add(') VALUES (');
        SQL.Add('  :cod_arq_import_fabricante,');
        SQL.Add('  :cod_tipo_mensagem,');
        SQL.Add('  :txt_mensagem,');
        SQL.Add('  :txt_identificacao,');
        SQL.Add('  :txt_legenda_identificacao');
        SQL.Add(')');

        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;
        ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
        ParamByName('txt_mensagem').AsString := TxtMensagem;
        ParamByName('txt_identificacao').AsString := TxtIdentificacao;
        ParamByName('txt_legenda_identificacao').AsString := TxtLegendaIdentificacao;

        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1980, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Prepara a tarefa para ser executada. Limpa as ocorrências do processamento
  anterior. Atualiza a tabela tab_arq_import_fabricante com o código da tarefa.

Exceptions:
  EHerdomException caso ocorra algum erro.}
procedure TArquivoRetornoFabricante.PrepararProcessamento;
const
  NomeMetodo: String = 'PrepararProcessamento';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Limpa as ocorrências do processamento anterior.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('DELETE FROM tab_ocorrencia_import_fab');
        SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');

        ParamByName('cod_arq_import_fabricante').AsInteger :=
          FThread.CodArquivoImportacao;

        ExecSQL();
      end;

      // Atauliza a tarefa do arquivo.
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_arq_import_fabricante');
        SQL.Add('   SET cod_tarefa = :cod_tarefa');
        SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');

        ParamByName('cod_arq_import_fabricante').AsInteger :=
          FThread.CodArquivoImportacao;
        ParamByName('cod_tarefa').AsInteger := FThread.CodTarefa;

        ExecSQL();
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(1980, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Obtem o próximo código da tabela tab_arq_import_fabricante.

Parametros:
  ...

Retorno:
  Código do arquivo.

Exceptions:
  Nenhuma.}
function TArquivoRetornoFabricante.ProximoCodigoArqFabricante: Integer;
const
  NomeMetodo: String = 'ProximoCodigoArqFabricante';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        Conexao.BeginTran('CODIGO_ARQ_TRANSF');
        SQL.Clear;
        SQL.Add('update tab_seq_arq_import_fabricante');
        SQL.Add('   set cod_seq_arq_import_fabricante = cod_seq_arq_import_fabricante + 1');
        ExecSQL();

        SQL.Clear;
        SQL.Add('select cod_seq_arq_import_fabricante');
        SQL.Add('  from tab_seq_arq_import_fabricante');
        Open;

        if IsEmpty then
        begin
          Conexao.Rollback('CODIGO_ARQ_TRANSF');
          Mensagens.Adicionar(1975, Self.ClassName, NomeMetodo,
            ['tabela (tab_seq_arq_import_fabricante) vazia']);
          Result := -1975;
        end;

        Result := QueryLocal.FieldByName('cod_seq_arq_import_fabricante').AsInteger;
        Conexao.Commit('CODIGO_ARQ_TRANSF');
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      Conexao.Rollback('CODIGO_ARQ_TRANSF');
      Mensagens.Adicionar(1975, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1975;
    end;
  end;
end;

{ Verifica se o arquivo existe. E retorna o nome absoluto do
  arquivo (incluido a pasta). Se a origem do arquivo for FTP faz uma cópia
  para o diretório de erro de processamento. 

Parametros:
  CodTipoOrigem: Tipo da origem do arquivo FTP ou WEB
  NomeArquivo: Nome do arquivo a ser validado.

Retorno:
  Nome do arquivo completo.

Exceptions:
  EHerdomException: Caso ocorra algum erro.}
function TArquivoRetornoFabricante.VerificaExistenciaArquivo(CodTipoOrigem: Integer;
  NomeArquivo: String): String;
const
  NomeMetodo: String = 'ValidaArquivo';
var
  NomeArquivoAbsoluto,
  NomeDiretorioErroFtp: String;
begin
  // Obtem o nome absoluto do arquivo. (com a pasta)
  NomeArquivoAbsoluto := GetNomeCompleto(CodTipoOrigem, NomeArquivo);

  // Se a orgem do arquivo for FTP então o arquivo deve ser copiado para o
  // diretório de erro. Caso o processamento do arquivo ocorra com sucesso
  // o arquivo será excluido deste diretório.
  if CodTipoOrigem = cCodTipoOrigemArquivoFTP then begin
    // Recupera a pasta adequada dos arquivos que se encontram com erro,
    // caso a origem seja do FTP
    NomeDiretorioErroFtp := ValorParametro(cParCaminhoDiretorioErroFTP);
    if (Length(NomeDiretorioErroFtp) = 0)
      or (NomeDiretorioErroFtp[Length(NomeDiretorioErroFtp)] <> '\') then
    begin
      NomeDiretorioErroFtp := NomeDiretorioErroFtp + '\';
    end;

    // Consiste existência da pasta, caso não exista tenta criá-la
    if not DirectoryExists(NomeDiretorioErroFtp) then begin
      if not ForceDirectories(NomeDiretorioErroFtp) then begin
        // Gera Mensagem erro informando o problema ao usuário
        raise EHerdomException.Create(1217, Self.ClassName, NomeMetodo, [],
          False);
      end;
    end;

    // Armazena o arquivo de upload via FTP na pasta de retorno
    // Ao final do processo, caso o mesmo tenha sido bem sucedido,
    // esse arquivo será excluído
    Win32_CopiaArquivo(NomeArquivoAbsoluto, NomeDiretorioErroFtp + NomeArquivo);
    if not DeleteFile(NomeArquivoAbsoluto) then
    begin
      // Gera Mensagem erro informando o problema ao usuário
      raise EHerdomException.Create(2003, Self.ClassName, NomeMetodo,
        [ExtractFileName(NomeArquivoAbsoluto)], False);
    end;

    Result := NomeDiretorioErroFtp + NomeArquivo; // Daniel 08.08.2005
  end
  else
  begin
    Result := NomeArquivoAbsoluto; // Daniel 08.08.2005
  end;
end;

end.
 