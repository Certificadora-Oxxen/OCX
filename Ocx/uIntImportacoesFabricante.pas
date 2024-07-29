unit uIntImportacoesFabricante;

interface

uses Classes, SysUtils, uConexao, uIntMensagens, uIntClassesBasicas,
  uFerramentas, XMLdom, uIntImportacaoFabricante, uArquivoRetornoFabricante;

type

  TIntImportacoesFabricante = class(TIntClasseBDNavegacaoBasica)
  protected
    FIntImportacaoFabricante: TIntImportacaoFabricante;
  public
    constructor Create; override;
    destructor Destroy; override;

    function ArmazenarArquivoUpload(CodTipoOrigemArqImport: Integer;
                                    NomArqUpload: String): Integer;

    function Buscar(CodArqImportFabricante: Integer): Integer;

    function Pesquisar(NomArqUpload: String;
                       DtaImportacaoInicio,
                       DtaImportacaoFim: TDateTime;
                       NomUsuarioUpload: String;
                       CodTipoOrigemArqImport: Integer;
                       CodSituacaoArqImport: String;
                       DtaProcessamentoInicio,
                       DtaProcessamentoFim: TDateTime;
                       NomUsuarioProc: String): Integer;

    function Excluir(CodArqImportFabricante: Integer): Integer;

    function PesquisarOcorrencias(CodArqImportFabricante,
                                  CodTipoMensagem: Integer): Integer;

    function ProcessarArquivo(CodArqImportFabricante: Integer): Integer;

    function Inicializar(EConexao: TConexao;
                         EMensagens: TIntMensagens;
                         EImportacaoFabricante: TIntImportacaoFabricante): Integer; overload;

    property IntImportacaoFabricante: TIntImportacaoFabricante read FIntImportacaoFabricante write FIntImportacaoFabricante;
  end;
  
implementation

uses uLibZipM, XMLDoc, SqlExpr, DB, uIntOrdensServico;


{ TIntImportacoesFabricante }

{ Valida a estrutura do arquivo e, caso a estretura do mesmo seja válida,
  move o arquivo para o diretório dos arquivos a serem processados, modificando
  seu nome para ser um nome único definido pelo sistema. Caso o arquivo seja
  inválido o arquivo é excluído.

Parametros:
  CodTipoOrigemArqImport: Parametro obrigatório que indica a origem do arquivo,
    FTP ou WEB.
  NomArqUpload: Obrigatório. Nome do arquivo sem a pasta a ser processado.

Retorno:
  O código do arquivo caso o arquivo seja válido.
  < 0 se ocorre algum erro.}
function TIntImportacoesFabricante.ArmazenarArquivoUpload(
  CodTipoOrigemArqImport: Integer; NomArqUpload: String): Integer;
const
  NomeMetodo: String = 'ArmazenarArquivoUpload';
var
  ArquivoFabricante: TArquivoRetornoFabricante;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  if not Conexao.PodeExecutarMetodo(596) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se o tipo do arquivo de origem é válido.
  if not (CodTipoOrigemArqImport in [1, 2]) then
  begin
    Mensagens.Adicionar(1986, Self.ClassName, NomeMetodo, []);
    Result := -1986;
    Exit;
  end;

  // Verifica se o nome do arquivo foi informado corretamente.
  if NomArqUpload = '' then
  begin
    Mensagens.Adicionar(1987, Self.ClassName, NomeMetodo, []);
    Result := -1987;
    Exit;
  end;

  { Inicialmente o tipo de arquivo é sempre 1 (Fockink), posteriormente
    com a inclusão de novos formatos a linha abaixo deve ser alterado
    para verificar o tipo de arquivo a ser validado. }
  ArquivoFabricante := TArquivoRetornoFabricante.GetInstancia(nil, 1);
  try
    ArquivoFabricante.Inicializar(Conexao, Mensagens);
    Result := ArquivoFabricante.Validar(CodTipoOrigemArqImport, NomArqUpload);
  finally
    ArquivoFabricante.Free;
  end;
end;

function TIntImportacoesFabricante.Buscar(
  CodArqImportFabricante: Integer): Integer;
const
  NomeMetodo: String = 'Buscar';
var
  QueryLocal: THerdomQuery;
begin
  if (not Inicializado) or (FIntImportacaoFabricante = nil) then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  if not Conexao.PodeExecutarMetodo(597) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Add('SELECT taif.cod_arq_import_fabricante AS CodArqImportFabricante,');
        SQL.Add('       taif.nom_arq_upload AS NomArqUpload,');
        SQL.Add('       taif.nom_arq_import_fabricante AS NomArqImportFabricante,');
        SQL.Add('       taif.dta_importacao AS DtaImportacao,');
        SQL.Add('       taif.cod_fabricante_identificador AS CodFabricanteIdentificador,');
        SQL.Add('       tfi.nom_fabricante_identificador AS NomFabricanteIdentificador,');
        SQL.Add('       tfi.nom_reduzido_fabricante AS NomReduzidoFabricanteIdent,');
        SQL.Add('       taif.cod_tipo_arq_import_fabricante AS CodTipoArqImportFabricante,');
        SQL.Add('       ttaif.sgl_tipo_arq_import_fabricante AS SglTipoArqImportFabricante,');
        SQL.Add('       ttaif.des_tipo_arq_import_fabricante AS DesTipoArqImportFabricante,');
        SQL.Add('       taif.cod_usuario_upload AS CodUsuarioUpload,');
        SQL.Add('       tuup.nom_usuario AS NomUsuarioUpload,');
        SQL.Add('       taif.cod_tipo_origem_arq_import AS CodTipoOrigemArqImport,');
        SQL.Add('       ttoai.sgl_tipo_origem_arq_import AS SglTipoOrigemArqImport,');
        SQL.Add('       ttoai.des_tipo_origem_arq_import AS DesTipoOrigemArqImport,');
        SQL.Add('       taif.cod_situacao_arq_import AS CodSituacaoArqImport,');
        SQL.Add('       tsai.des_situacao_arq_import AS DesSituacaoArqImport,');
        SQL.Add('       taif.qtd_registros_total AS QtdRegistrosTotal,');
        SQL.Add('       taif.qtd_registros_errados AS QtdRegistrosErrados,');
        SQL.Add('       taif.qtd_registros_processados AS QtdRegistrosProcessados,');
        SQL.Add('       (select count(*) from tab_ocorrencia_import_fab a where a.cod_arq_import_fabricante = taif.cod_arq_import_fabricante) AS QtdOcorrencias,');
        SQL.Add('       taif.dta_processamento AS DtaProcessamento,');
        SQL.Add('       tt.cod_usuario AS CodUsuarioProc,');
        SQL.Add('       tut.nom_usuario AS NomUsuarioProc,');
        SQL.Add('       taif.cod_tarefa AS CodTarefa,');
        SQL.Add('       tt.cod_situacao_tarefa AS CodSituacaoTarefa,');
        SQL.Add('       tst.des_situacao_tarefa AS DesSituacaoTarefa,');
        SQL.Add('       tt.dta_inicio_previsto AS DtaInicioPrevistoTarefa,');
        SQL.Add('       tt.dta_inicio_real AS DtaInicioRealTarefa,');
        SQL.Add('       tt.dta_fim_real AS DtaFimRealTarefa,');
        SQL.Add('       taif.txt_mensagem AS TxtMensagem');
        SQL.Add('  FROM tab_arq_import_fabricante taif');
        SQL.Add('         LEFT JOIN tab_tarefa tt');
        SQL.Add('           ON tt.cod_tarefa = taif.cod_tarefa');
        SQL.Add('         LEFT JOIN tab_usuario tut');
        SQL.Add('           ON tt.cod_usuario = tut.cod_usuario');
        SQL.Add('         LEFT JOIN tab_situacao_tarefa tst');
        SQL.Add('           ON tst.cod_situacao_tarefa = tt.cod_situacao_tarefa,');
        SQL.Add('       tab_fabricante_identificador tfi,');
        SQL.Add('       tab_tipo_arq_import_fabricante ttaif,');
        SQL.Add('       tab_usuario tuup,');
        SQL.Add('       tab_tipo_origem_arq_import ttoai,');
        SQL.Add('       tab_situacao_arq_import tsai');
        SQL.Add(' WHERE taif.cod_fabricante_identificador = tfi.cod_fabricante_identificador');
        SQL.Add('   AND taif.cod_tipo_arq_import_fabricante = ttaif.cod_tipo_arq_import_fabricante');
        SQL.Add('   AND taif.cod_usuario_upload = tuup.cod_usuario');
        SQL.Add('   AND taif.cod_tipo_origem_arq_import = ttoai.cod_tipo_origem_arq_import');
        SQL.Add('   AND taif.cod_situacao_arq_import = tsai.cod_situacao_arq_import');
        SQL.Add('   AND taif.cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(1989, Self.ClassName, NomeMetodo,
            [IntToStr(CodArqImportFabricante)]);
          Result := -1989;
          Exit;
        end;

        // Obtem os valores
        FIntImportacaoFabricante.CodFabricanteIdentificador         := FieldByName('CodFabricanteIdentificador').AsInteger;
        FIntImportacaoFabricante.NomArqUpload                       := FieldByName('NomArqUpload').AsString;
        FIntImportacaoFabricante.NomArqImportFabricante             := FieldByName('NomArqImportFabricante').AsString;
        FIntImportacaoFabricante.DtaImportacao                      := FieldByName('DtaImportacao').AsDateTime;
        FIntImportacaoFabricante.CodFabricanteIdentificador         := FieldByName('CodFabricanteIdentificador').AsInteger;
        FIntImportacaoFabricante.NomFabricanteIdentificador         := FieldByName('NomFabricanteIdentificador').AsString;
        FIntImportacaoFabricante.NomReduzidoFabricanteIdentificador := FieldByName('NomReduzidoFabricanteIdent').AsString;
        FIntImportacaoFabricante.CodTipoArqImportFabricante         := FieldByName('CodTipoArqImportFabricante').AsInteger;
        FIntImportacaoFabricante.SglTipoArqImportFabricante         := FieldByName('SglTipoArqImportFabricante').AsString;
        FIntImportacaoFabricante.DesTipoArqImportFabricante         := FieldByName('DesTipoArqImportFabricante').AsString;
        FIntImportacaoFabricante.CodUsuarioUpload                   := FieldByName('CodUsuarioUpload').AsInteger;
        FIntImportacaoFabricante.NomUsuarioUpload                   := FieldByName('NomUsuarioUpload').AsString;
        FIntImportacaoFabricante.CodTipoOrigemArqImport             := FieldByName('CodTipoOrigemArqImport').AsInteger;
        FIntImportacaoFabricante.SglTipoOrigemArqImport             := FieldByName('SglTipoOrigemArqImport').AsString;
        FIntImportacaoFabricante.DesTipoOrigemArqImport             := FieldByName('DesTipoOrigemArqImport').AsString;
        FIntImportacaoFabricante.CodSituacaoArqImport               := FieldByName('CodSituacaoArqImport').AsString;
        FIntImportacaoFabricante.DesSituacaoArqImport               := FieldByName('DesSituacaoArqImport').AsString;
        FIntImportacaoFabricante.QtdRegistrosTotal                  := FieldByName('QtdRegistrosTotal').AsInteger;
        FIntImportacaoFabricante.QtdRegistrosErrados                := FieldByName('QtdRegistrosErrados').AsInteger;
        FIntImportacaoFabricante.QtdRegistrosProcessados            := FieldByName('QtdRegistrosProcessados').AsInteger;
        FIntImportacaoFabricante.QtdOcorrencias                     := FieldByName('QtdOcorrencias').AsInteger;
        FIntImportacaoFabricante.DtaProcessamento                   := FieldByName('DtaProcessamento').AsDateTime;
        FIntImportacaoFabricante.CodUsuarioProc                     := FieldByName('CodUsuarioProc').AsInteger;
        FIntImportacaoFabricante.NomUsuarioProc                     := FieldByName('NomUsuarioProc').AsString;
        FIntImportacaoFabricante.CodTarefa                          := FieldByName('CodTarefa').AsInteger;
        FIntImportacaoFabricante.CodSituacaoTarefa                  := FieldByName('CodSituacaoTarefa').AsString;
        FIntImportacaoFabricante.DesSituacaoTarefa                  := FieldByName('DesSituacaoTarefa').AsString;
        FIntImportacaoFabricante.DtaInicioPrevistoTarefa            := FieldByName('DtaInicioPrevistoTarefa').AsDateTime;
        FIntImportacaoFabricante.DtaInicioRealTarefa                := FieldByName('DtaInicioRealTarefa').AsDateTime;
        FIntImportacaoFabricante.DtaFimRealTarefa                   := FieldByName('DtaFimRealTarefa').AsDateTime;
        FIntImportacaoFabricante.TxtMensagem                        := FieldByName('TxtMensagem').AsString;
      end;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1988, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1988;
    end;
  end;
end;

constructor TIntImportacoesFabricante.Create;
begin
  inherited;
  FIntImportacaoFabricante := TIntImportacaoFabricante.Create;
end;

destructor TIntImportacoesFabricante.Destroy;
begin
  inherited;
  FIntImportacaoFabricante.Free;
end;

function TIntImportacoesFabricante.Excluir(
  CodArqImportFabricante: Integer): Integer;
const
  NomeMetodo: String = 'Excluir';
var
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  if not Conexao.PodeExecutarMetodo(599) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Inicia a transação
      BeginTran;

      with QueryLocal do
      begin
        SQL.Add('DELETE FROM tab_ocorrencia_import_fab');
        SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;

        ExecSQL;
      end;

      with QueryLocal do
      begin
        SQL.Add('DELETE FROM tab_arq_import_fabricante');
        SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;

        if ExecSQL <> 1 then
        begin
          Rollback;
          Mensagens.Adicionar(1989, Self.ClassName, NomeMetodo,
            [IntToStr(CodArqImportFabricante)]);
          Result := -1989;
          Exit;
        end;
      end;

      Commit;
    finally
      QueryLocal.Free;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1991, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1991;
    end;
  end;
end;

function TIntImportacoesFabricante.Inicializar(EConexao: TConexao;
  EMensagens: TIntMensagens;
  EImportacaoFabricante: TIntImportacaoFabricante): Integer;
begin
  FIntImportacaoFabricante := EImportacaoFabricante;
  Result := Inicializar(EConexao, EMensagens);
end;

function TIntImportacoesFabricante.Pesquisar(NomArqUpload: String;
  DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  NomUsuarioUpload: String; CodTipoOrigemArqImport: Integer;
  CodSituacaoArqImport: String; DtaProcessamentoInicio,
  DtaProcessamentoFim: TDateTime; NomUsuarioProc: String): Integer;
const
  NomeMetodo: String = 'Pesquisar';
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  if not Conexao.PodeExecutarMetodo(598) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    with Query do
    begin
     SQL.Add('SELECT taif.cod_arq_import_fabricante AS CodArqImportFabricante,');
     SQL.Add('       taif.nom_arq_upload AS NomArqUpload,');
     SQL.Add('       taif.dta_importacao AS DtaImportacao,');
     SQL.Add('       tuu.nom_usuario AS NomUsuarioUpload,');
     SQL.Add('       ttoai.sgl_tipo_origem_arq_import AS SglTipoOrigemArqImport,');
     SQL.Add('       taif.cod_situacao_arq_import AS CodSituacaoArqImport,');
     SQL.Add('       taif.dta_processamento AS DtaProcessamento,');
     SQL.Add('       tut.nom_usuario AS NomUsuarioProc,');
     SQL.Add('       taif.qtd_registros_total AS QtdRegistrosTotal,');
     SQL.Add('       taif.qtd_registros_errados AS QtdRegistrosErrados');
     SQL.Add('  FROM tab_arq_import_fabricante taif');
     SQL.Add('         LEFT JOIN tab_tarefa tt');
     SQL.Add('           ON taif.cod_tarefa = tt.cod_tarefa');
     SQL.Add('         LEFT JOIN tab_usuario tut');
     SQL.Add('           ON tt.cod_usuario = tut.cod_usuario');
     if NomUsuarioProc <> '' then
     begin
       SQL.Add('         AND tut.nom_usuario LIKE ''%' + NomUsuarioProc + '%''');
     end;
     SQL.Add('       , tab_usuario tuu,');
     SQL.Add('       tab_tipo_origem_arq_import ttoai');
     SQL.Add(' WHERE taif.cod_usuario_upload = tuu.cod_usuario');
     SQL.Add('   AND taif.cod_tipo_origem_arq_import = ttoai.cod_tipo_origem_arq_import');
     if NomArqUpload <> '' then
     begin
       SQL.Add(' AND taif.nom_arq_upload LIKE ''%' + NomArqUpload + '%''');
     end;
     if DtaImportacaoInicio > 0 then
     begin
       SQL.Add(' AND taif.dta_importacao >= :dta_importacao_inicio');
     end;
     if DtaImportacaoFim > 0 then
     begin
       SQL.Add(' AND taif.dta_importacao < :dta_importacao_fim + 1');
     end;
     if NomUsuarioUpload <> '' then
     begin
       SQL.Add(' AND tuu.nom_usuario LIKE ''%' + NomUsuarioUpload + '%''');
     end;
     if CodTipoOrigemArqImport > -1 then
     begin
       SQL.Add(' AND taif.cod_tipo_origem_arq_import = :cod_tipo_origem_arq_import');
     end;
     if CodSituacaoArqImport <> '' then
     begin
       SQL.Add(' AND taif.cod_situacao_arq_import = :cod_situacao_arq_import');
     end;
     if DtaProcessamentoInicio > 0 then
     begin
       SQL.Add(' AND taif.dta_processamento >= :dta_processamento_inicio');
     end;
     if DtaProcessamentoFim > 0 then
     begin
       SQL.Add(' AND taif.dta_processamento < :dta_processamento_fim + 1');
     end;

     // Ordenação
     SQL.Add('ORDER BY taif.dta_importacao desc');

     // Define os parametros da pesquisa
     if DtaImportacaoInicio > 0 then
     begin
       ParamByName('dta_importacao_inicio').AsDateTime := Trunc(DtaImportacaoInicio);
     end;
     if DtaImportacaoFim > 0 then
     begin
       ParamByName('dta_importacao_fim').AsDateTime := Trunc(DtaImportacaoFim);
     end;
     if CodTipoOrigemArqImport > -1 then
     begin
       ParamByName('cod_tipo_origem_arq_import').AsInteger := CodTipoOrigemArqImport;
     end;
     if CodSituacaoArqImport <> '' then
     begin
       ParamByName('cod_situacao_arq_import').AsString := CodSituacaoArqImport;
     end;
     if DtaProcessamentoInicio > 0 then
     begin
       ParamByName('dta_processamento_inicio').AsDateTime := Trunc(DtaProcessamentoInicio);
     end;
     if DtaProcessamentoFim > 0 then
     begin
       ParamByName('dta_processamento_fim').AsDateTime := Trunc(DtaProcessamentoFim);
     end;

     Open;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1990, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1990;
    end;
  end;
end;

function TIntImportacoesFabricante.PesquisarOcorrencias(
  CodArqImportFabricante, CodTipoMensagem: Integer): Integer;
const
  NomeMetodo: String = 'PesquisarOcorrencias';
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
  end;

  if not Conexao.PodeExecutarMetodo(600) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Add('SELECT cod_tipo_mensagem AS CodTipoMensagem,');
      SQL.Add('       txt_mensagem AS TxtMensagem,');
      SQL.Add('       txt_identificacao AS TxtIdentificacao,');
      SQL.Add('       txt_legenda_identificacao AS TxtLegendaIdentificacao');
      SQL.Add('  FROM tab_ocorrencia_import_fab');
      SQL.Add(' WHERE cod_arq_import_fabricante = :cod_arq_import_fabricante');
      if CodTipoMensagem > -1 then
      begin
        SQL.Add(' AND cod_tipo_mensagem = :cod_tipo_mensagem');
      end;

      ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;
      if CodTipoMensagem > -1 then
      begin
        ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
      end;

      Open;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1992, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1992;
    end;
  end;
end;

function TIntImportacoesFabricante.ProcessarArquivo(
  CodArqImportFabricante: Integer): Integer;
const
  Metodo: Integer = 601;
  NomeMetodo: String = 'ProcessarArquivo';
  CodTipoTarefa: Integer = 4;
var
  QueryLocal: THerdomQuery;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  QueryLocal := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Consiste existência do arquivo informado, obtendo a qtd de linhas do mesmo
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT tais.qtd_registros_total AS NumLinhas,');
        SQL.Add('       tais.cod_tipo_origem_arq_import AS CodTipoOrigemArqImport,');
        SQL.Add('       tais.cod_situacao_arq_import AS CodSituacaoArqImport');
        SQL.Add('  FROM tab_arq_import_fabricante tais');
        SQL.Add(' WHERE tais.cod_arq_import_fabricante = :cod_arq_import_fabricante');
        ParamByName('cod_arq_import_fabricante').AsInteger := CodArqImportFabricante;
        Open;
        if IsEmpty or (FieldByName('NumLinhas').AsInteger = 0)
          or (FieldByName('CodSituacaoArqImport').AsString = 'I') then
        begin
          Mensagens.Adicionar(1343, Self.ClassName, NomeMetodo, []);
          Result := -1343;
          Exit;
        end;
      end;

      // Verifica se o arquivo se se encontra na lista de tarefas para processamento
      Result := VerificarAgendamentoTarefa(CodTipoTarefa, [CodArqImportFabricante]);
      if Result <= 0 then
      begin
        if Result = 0 then
        begin
          Mensagens.Adicionar(1344, Self.ClassName, NomeMetodo, []);
          Result := -1344;
        end;
        
        Exit;
      end;

      // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
      Result := SolicitarAgendamentoTarefa(
        CodTipoTarefa, [CodArqImportFabricante], DtaSistema);

      // Trata o resultado da solicitação, gerando mensagem se bem sucedido
      if Result >= 0 then
      begin
        Mensagens.Adicionar(1345, Self.Classname, NomeMetodo, []);
      end;
    except
      on E: Exception do
      begin
        Conexao.Rollback;  // desfaz transação se houver uma ativa
        Mensagens.Adicionar(1592, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1592;
        Exit;
      end;
    end;
  finally
    QueryLocal.Free;
  end;
end;

end.
