unit uConexao;

{$DEFINE MSSQL}

interface

uses
  SysUtils, DB, SqlExpr, classes, uColecoes, uIntProdutor, uIntFazendaTrabalho;

const
  MAX_FUNCOES = 1000;
  MAX_METODOS = 1000;

type
  {TConectar}
  TConectar = record
    Status  : Integer;
    Erros   : TErrosConexao;
  end;

  {TConexao}
  TConexao = class(TObject)
  private
    FSQLConnection: TSQLConnection;
    FAtiva: Boolean;
    FIgnorarNovasTransacoes: Boolean;
    FItensMenuDisponiveis: TItensMenuUsuario;
    FItensMenuPesquisa: TItensMenuUsuario;
    FProdutorTrabalho: TIntProdutor;
    FFazendaTrabalho: TIntFazendaTrabalho;
    FPonteiroPesquisa: Integer;
    FCodUsuario: Integer;
    FNomUsuario: String;
    FCodPessoa: Integer;
    FCodProdutor: Integer;
    FCodProdutorTrabalho: Integer;
    FExisteProdutorTrabalho: Boolean;
    FExisteFazendaTrabalho: Boolean;
    FQtdCaracteresManejoProdutor: Integer;
    FCodFazendaTrabalho: Integer;
    FCodPapelUsuario: Integer;
    FCaminhoArquivosCertificadora: String;
    FFuncoesDisponiveis: array[1..MAX_FUNCOES] of Boolean;
    FMetodosDisponiveis: array[1..MAX_METODOS] of Boolean;
    FServidor: String;
    FCodTipoAcesso : String;
    FBanco : String;
    FVQueryGovernorCostLimit: Integer;

    FDataUltimaVistoria : TDateTime;
    FStatusUltimavistoria : Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Conectar(ServerName, UserName, Password, Banco, Identificacao: String;
      LockTimeOut, QueryGovernorCostLimit: Integer) : TConectar;
    function SetFuncao(Index: Integer; Valor: Boolean) : Integer;
    function SetMetodo(Index: Integer; Valor: Boolean) : Integer;
    function GetFuncao(Index: Integer): Boolean;
    function GetMetodo(Index: Integer): Boolean;
    function PodeExecutarMetodo(CodMetodo: Integer): Boolean;

    function DefinirProdutorTrabalho(ECodPessoaProdutor: Integer;
                                     var ENomePessoaProdutor: String): Integer;

    function DefinirFazendaTrabalho(CodFazenda: Integer): Integer;
    function ValorParametro(CodParametro: Integer; EMensagens: TObject): String;
    function DtaSistema: TDateTime;
    function EmTransacao: Boolean;
    procedure LimpaProdutorTrabalho;
    procedure LimpaFazendaTrabalho;
    procedure LimpaFuncoes;
    procedure LimpaMetodos;
    procedure beginTran; overload;
    procedure Commit; overload;
    procedure Rollback; overload;
    procedure beginTran(NomTransacao: String); overload;
    procedure Commit(NomTransacao: String); overload;
    procedure Rollback(NomTransacao: String); overload;
    procedure SaveTran(NomTransacao: String);
    procedure RollTran(NomTransacao: String);

    property SQLConnection: TSQLConnection read FSQLConnection write FSQLConnection;
    property Ativa: Boolean read FAtiva write FAtiva;
    property IgnorarNovasTransacoes: Boolean read FIgnorarNovasTransacoes write FIgnorarNovasTransacoes;
    property ItensMenuDisponiveis: TItensMenuUsuario read FItensMenuDisponiveis write FItensMenuDisponiveis;
    property ItensMenuPesquisa: TItensMenuUsuario read FItensMenuPesquisa write FItensMenuPesquisa;
    property PonteiroPesquisa: Integer read FPonteiroPesquisa write FPonteiroPesquisa;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property NomUsuario: String read FNomUsuario write FNomUsuario;
    property CodPessoa: Integer read FCodPessoa write FCodPessoa;
    property CodProdutor: Integer read FCodProdutor write FCodProdutor;
    property CodProdutorTrabalho: Integer read FCodProdutorTrabalho write FCodProdutorTrabalho;
    property ProdutorTrabalho: TIntProdutor read FProdutorTrabalho write FProdutorTrabalho;
    property ExisteProdutorTrabalho: Boolean read FExisteProdutorTrabalho write FExisteProdutorTrabalho;
    property FazendaTrabalho: TIntFazendaTrabalho read FFazendaTrabalho write FFazendaTrabalho;
    property ExisteFazendaTrabalho: Boolean read FExisteFazendaTrabalho write FExisteFazendaTrabalho;
    property QtdCaracteresManejoProdutor: Integer read FQtdCaracteresManejoProdutor write FQtdCaracteresManejoProdutor;
    property CodFazendaTrabalho: Integer read FCodFazendaTrabalho write FCodFazendaTrabalho;
    property CodPapelUsuario: Integer read FCodPapelUsuario write FCodPapelUsuario;
    property Servidor: String read FServidor  write FServidor;
    property CodTipoAcesso: String read FCodTipoAcesso  write FCodTipoAcesso;
    property Banco: String read FBanco write FBanco;
    property CaminhoArquivosCertificadora: String read FCaminhoArquivosCertificadora write FCaminhoArquivosCertificadora;
    property VQueryGovernorCostLimit: Integer read FVQueryGovernorCostLimit write FVQueryGovernorCostLimit;
  end;

  {Funções genéricas}
  function EmTransacao(SQLConnection: TSQLConnection): Boolean;
  procedure beginTran(SQLConnection: TSQLConnection); overload;
  procedure beginTran(SQLConnection: TSQLConnection; NomTransacao: String); overload;
  procedure SaveTran(SQLConnection: TSQLConnection; NomTransacao: String);
  procedure Commit(SQLConnection: TSQLConnection); overload;
  procedure Commit(SQLConnection: TSQLConnection; NomTransacao: String); overload;
  procedure Rollback(SQLConnection: TSQLConnection); overload;
  procedure Rollback(SQLConnection: TSQLConnection; NomTransacao: String); overload;
  procedure RollTran(SQLConnection: TSQLConnection; NomTransacao: String);

implementation

uses uIntClassesBasicas, uIntMensagens;

{Funções genéricas}

function EmTransacao(SQLConnection: TSQLConnection): Boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select @@trancount as trancount');
{$ENDIF}
    Q.Open;
    if Q.FieldByName('trancount').AsInteger > 0 then begin
      Result := True;
    end;
  finally
    Q.Free;
  end;
end;

procedure beginTran(SQLConnection: TSQLConnection); overload;
var
  Q: TSQLQuery;
begin
// Comentada a pedido do Jerry
//  if EmTransacao then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('begin transaction BOITATA');
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure beginTran(SQLConnection: TSQLConnection; NomTransacao: String); overload;
var
  Q: TSQLQuery;
begin
//  if EmTransacao then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('begin transaction ' + NomTransacao);
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure SaveTran(SQLConnection: TSQLConnection; NomTransacao: String);
var
  Q: TSQLQuery;
begin
  if not uConexao.EmTransacao(SQLConnection) then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('save transaction ' + NomTransacao);
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure Commit(SQLConnection: TSQLConnection); overload;
var
  Q: TSQLQuery;
begin
  if not uConexao.EmTransacao(SQLConnection) then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('commit transaction BOITATA');
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure Commit(SQLConnection: TSQLConnection; NomTransacao: String); overload;
var
  Q: TSQLQuery;
begin
//  if not EmTransacao then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('commit transaction ' + NomTransacao);
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure Rollback(SQLConnection: TSQLConnection); overload;
var
  Q: TSQLQuery;
begin
  if not uConexao.EmTransacao(SQLConnection) then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('rollback transaction BOITATA');
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure Rollback(SQLConnection: TSQLConnection; NomTransacao: String); overload;
var
  Q: TSQLQuery;
begin
//  if not EmTransacao then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('rollback transaction ' + NomTransacao);
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure RollTran(SQLConnection: TSQLConnection; NomTransacao: String);
var
  Q: TSQLQuery;
begin
  if not uConexao.EmTransacao(SQLConnection) then Exit;

  Q := TSQLQuery.Create(nil);
  try
    Q.SQLConnection := SQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('rollback transaction ' + NomTransacao);
{$ENDIF}
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

{TConexao}

constructor TConexao.Create;
begin
  inherited;

  FSQLConnection := TSQLConnection.Create(nil);

  FItensMenuDisponiveis := TItensMenuUsuario.Create(TItemMenuUsuario);
  FItensMenuPesquisa := TItensMenuUsuario.Create(TItemMenuUsuario);
  FProdutorTrabalho := TIntProdutor.Create;
  FFazendaTrabalho := TIntFazendaTrabalho.Create;
  FPonteiroPesquisa := 0;
  FCodUsuario := -1;
  FNomUsuario := '';
  FCodProdutor := -1;
  FCodProdutorTrabalho := -1;
  FExisteProdutorTrabalho := False;
  FExisteFazendaTrabalho := False;
  FCodPapelUsuario := -1;
  FQtdCaracteresManejoProdutor := 0;
  FCodTipoAcesso := '';
  FServidor := '';
  FCaminhoArquivosCertificadora := '';

  LimpaFuncoes;
  LimpaMetodos;

  FAtiva := False;
  FIgnorarNovasTransacoes := False;
end;

destructor TConexao.Destroy;
begin
  FItensMenuDisponiveis.Free;
  FItensMenuPesquisa.Free;
  FProdutorTrabalho.Free;
  FFazendaTrabalho.Free;
  FSQLConnection.Close;
  FSQLConnection.Free;
  inherited;
end;

function TConexao.Conectar(ServerName, UserName, Password, Banco, Identificacao: String; LockTimeOut, QueryGovernorCostLimit: Integer): TConectar;
var
  DbName : String;
  Q : THerdomQuery;
begin
  Result.Status := 0;
  Result.Erros := TErrosConexao.Create(TErroConexao);

  if FSQLConnection.Connected then begin
    FSQLConnection.Close;
  end;

  DbName := 'SQLConnection_' + FormatDateTime('yyyymmddhhnnsszzz', Now);
  FAtiva := False;

  FSQLConnection.DriverName := 'SQLServer';
  FSQLConnection.GetDriverFunc := 'getSQLDriverSQLServer';
  FSQLConnection.KeepConnection := True;
  FSQLConnection.LibraryName := 'dbexpsda.dll';
  FSQLConnection.LoginPrompt := False;
  FSQLConnection.Name := DbName;
  FSQLConnection.Params.Values['Hostname'] := ServerName;
  FSQLConnection.Params.Values['User_Name'] := UserName;
  FSQLConnection.Params.Values['password'] := Password;
  FSQLConnection.Params.Values['database'] := Banco;
  FSQLConnection.VendorLib := 'sqloledb.dll';
  try
    // Tenta conectar
    FSQLConnection.Open;

    Q := THerdomQuery.Create(self, nil);
    try
      try
        // Determina o tempo máximo por espera de recursos
        Q.SQL.Text := 'SET LOCK_TIMEOUT ' + IntToStr(LockTimeOut * 1000);
        Q.ExecSQL;

        if QueryGovernorCostLimit > 0 then begin
          // Determina o tempo máximo para execução de query´s
          Q.SQL.Text := 'SET QUERY_GOVERNOR_COST_LIMIT ' + IntToStr(QueryGovernorCostLimit);
          Q.ExecSQL;
          VQueryGovernorCostLimit := QueryGovernorCostLimit;
        end;

        FBanco := Banco;
        FServidor := ServerName;
      except
        On E: exception do begin
          Result.Status := -2;
          Result.Erros.Add(0, E.Message);
          Exit;
        end;
      end;
    finally
      Q.Free;
    end;
    // Conexão Ok
    FAtiva := True;
  except
    On E: exception do begin
      Result.Status := -1;
      Result.Erros.Add(0, E.Message);
      Exit;
    end;
  end;
end;

function TConexao.GetFuncao(Index: Integer): Boolean;
begin
  Result := False;
  if Index > High(FFuncoesDisponiveis) then Exit;
  Result := FFuncoesDisponiveis[Index];
end;

function TConexao.GetMetodo(Index: Integer): Boolean;
begin
  Result := False;
  if Index > High(FMetodosDisponiveis) then Exit;
  Result := FMetodosDisponiveis[Index];
end;

function TConexao.SetFuncao(Index: Integer; Valor: Boolean): Integer;
begin
  Result := -1;
  if Index > High(FFuncoesDisponiveis) then Exit;
  FFuncoesDisponiveis[Index] := Valor;
  Result := 0;
end;

function TConexao.SetMetodo(Index: Integer; Valor: Boolean): Integer;
begin
  Result := -1;
  if Index > High(FMetodosDisponiveis) then Exit;
  FMetodosDisponiveis[Index] := Valor;
  Result := 0;
end;

procedure TConexao.LimpaFuncoes;
var
  X : Integer;
begin
  For X := 1 to MAX_FUNCOES do begin
    FFuncoesDisponiveis[X] := False;
  end;
end;

procedure TConexao.LimpaMetodos;
var
  X : Integer;
begin
  For X := 1 to MAX_METODOS do begin
    FMetodosDisponiveis[X] := False;
  end;
end;

procedure TConexao.LimpaProdutorTrabalho;
begin
  ProdutorTrabalho.CodProdutor         := 0;
  ProdutorTrabalho.NomProdutor         := '';
  ProdutorTrabalho.CodNatureza         := '';
  ProdutorTrabalho.NumCPFCNPJ          := '';
  ProdutorTrabalho.NumCPFCNPJFormatado := '';
  CodProdutorTrabalho                  := -1;
  FExisteProdutorTrabalho              := False;
end;

procedure TConexao.LimpaFazendaTrabalho;
begin
  FFazendaTrabalho.CodFazenda := 0;
  FFazendaTrabalho.SglFazenda := '';
  FFazendaTrabalho.NomFazenda := '';
  CodFazendaTrabalho          := -1;
  FExisteFazendaTrabalho      := False;
end;

function TConexao.PodeExecutarMetodo(CodMetodo: Integer): Boolean;
begin
//  if (UpperCase(FServidor) = 'HERDOM') then begin
    if (FCodUsuario = 1) then begin
      Result := True;
    end else begin
      Result := GetMetodo(CodMetodo);
    end;
//  end else begin
//    Result := True;
//  end;
end;

function TConexao.DefinirProdutorTrabalho(ECodPessoaProdutor: Integer;
                                          var ENomePessoaProdutor: String): Integer;
var
  Q : THerdomQuery;
begin
  if not FAtiva then
  begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'DefinirProdutorTrabalho']);
    Exit;
  end;

  Q := THerdomQuery.Create(nil);
  try
    Q.SQLConnection := FSQLConnection;
    //------------------------
    // Obtem dados do produtor
    //------------------------
    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('select tp.cod_pessoa, ' +
              '       tp.nom_pessoa, ' +
              '       tp.cod_natureza_pessoa, ' +
              '       tp.num_cnpj_cpf, ' +
              '       case tp.cod_natureza_pessoa ' +
              '         when ''F'' then convert(varchar(18), ' +
              '                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
              '                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
              '                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
              '                             substring(tp.num_cnpj_cpf, 10, 2)) ' +
              '         when ''J'' then convert(varchar(18), ' +
              '                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
              '                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
              '                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
              '                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
              '                             substring(tp.num_cnpj_cpf, 13, 2)) ' +
              '       end as num_cnpj_cpf_formatado, ' +
              '       tpr.ind_produtor_bloqueado, ' +
              '       tpr.sgl_produtor, ' +
              '       tpr.qtd_caracteres_cod_manejo, ' +
              '       tpr.ind_consulta_publica, ' +
              '       tpr.cod_tipo_agrup_racas, ' +
              '       tpr.qtd_denominador_comp_racial, ' +
              '       tpr.qtd_dias_entre_coberturas, ' +
              '       tpr.qtd_dias_descanso_reprodutivo, ' +
              '       tpr.qtd_dias_diagnostico_gestacao, ' +
              '       tpr.cod_aptidao, ' +
              '       tpr.cod_situacao_sisbov, ' +
              '       tpr.ind_mostrar_nome, ' +
              '       tpr.ind_mostrar_identificadores, ' +
              '       tpr.ind_transfere_embrioes, ' +
              '       tpr.ind_mostrar_filtro_comp_racial, ' +
              '       tpr.ind_estacao_monta, ' +
              '       tpr.ind_trabalha_assoc_raca, ' +
              '       tpr.qtd_idade_minima_desmame, ' +
              '       tpr.qtd_idade_maxima_desmame, ' +
              '       tpr.ind_aplicar_desmame_automatico '+
              '  from tab_pessoa tp, ' +
              '       tab_produtor tpr, ');

    if FCodPapelUsuario = 1 then // Associação
    begin
      Q.SQL.Add('     tab_associacao_produtor tap, ');
    end
    else if FCodPapelUsuario = 3 then // Tecnico
    begin
      Q.SQL.Add('     tab_tecnico_produtor ttp, ');
    end;

    Q.SQL.Add('       tab_pessoa_papel tpp ' +
              ' where tpp.cod_pessoa = tp.cod_pessoa ' +
              '   and tpr.cod_pessoa_produtor = tp.cod_pessoa ' +
              '   and tpp.dta_fim_validade is null ');

    if FCodPapelUsuario = 1 then // Associação
    begin
      Q.SQL.Add('  and tap.cod_pessoa_produtor = tp.cod_pessoa ' +
                '  and tap.cod_pessoa_associacao = :cod_pessoa_associacao ');
    end
    else if FCodPapelUsuario = 3 then // Tecnico
    begin
      Q.SQL.Add('  and ttp.cod_pessoa_produtor = tp.cod_pessoa ');
      Q.SQL.Add('  and ttp.cod_pessoa_tecnico = :cod_pessoa_tecnico ');
      Q.SQL.Add('  and ttp.dta_fim_validade is null ');
    end
    else if FCodPapelUsuario = 4 then // Produtor
    begin
      Q.SQL.Add('  and tp.cod_pessoa = :cod_pessoa_produtor ');
    end
    else if FCodPapelUsuario = 9 then // Gestor
    begin
      Q.SQL.Add('  and tp.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa ' +
                '                           from tab_tecnico_produtor ttp ' +
                '                              , tab_tecnico tt ' +
                '                          where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                '                             and ttp.dta_fim_validade is null ' +
                '                             and tt.dta_fim_validade is null ' +
                '                             and tt.cod_pessoa_gestor = :cod_pessoa_gestor ' +
                '                       ) ');
    end;

    Q.SQL.Add('    and tpp.cod_papel = 4 ' +
              '    and tp.dta_fim_validade is null ' +
              '    and tp.cod_pessoa = :cod_produtor ');
    {$ENDIF}

    if FCodPapelUsuario = 1 then // Associação
    begin
      Q.ParamByName('cod_pessoa_associacao').AsInteger := FCodPessoa;
    end
    else if FCodPapelUsuario = 3 then // Tecnico
    begin
      Q.ParamByName('cod_pessoa_tecnico').AsInteger := FCodPessoa;
    end
    else if FCodPapelUsuario = 4 then // Produtor
    begin
      Q.ParamByName('cod_pessoa_produtor').AsInteger := FCodPessoa;
    end
    else if FCodPapelUsuario = 9 then
    begin  // Gestor
      Q.ParamByName('cod_pessoa_gestor').AsInteger := FCodPessoa;
    end;

    Q.ParamByName('cod_produtor').AsInteger := ECodPessoaProdutor;
    Q.Open;

    // Verifica existência de dados da pessoa (produtor)
    if Q.IsEmpty then begin
      Result := 180;
      Exit;
    end;

    // Verifica se produtor está bloqueado
    if Q.FieldByName('ind_produtor_bloqueado').AsString = 'S' then
    begin
      if FCodPapelUsuario <> 2 then
      begin
        ENomePessoaProdutor := Q.FieldByName('nom_pessoa').AsString;
        Result := 362;
        Exit;
      end;
    end;

    LimpaProdutorTrabalho;

    // Atribui dados do produtor ao objeto Produtor
    ProdutorTrabalho.CodProdutor                 := Q.FieldByName('cod_pessoa').AsInteger;
    ProdutorTrabalho.NomProdutor                 := Q.FieldByName('nom_pessoa').AsString;
    ProdutorTrabalho.CodNatureza                 := Q.FieldByName('cod_natureza_pessoa').AsString;
    ProdutorTrabalho.NumCPFCNPJ                  := Q.FieldByName('num_cnpj_cpf').AsString;
    ProdutorTrabalho.NumCPFCNPJFormatado         := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
    ProdutorTrabalho.SglProdutor                 := Q.FieldByName('sgl_produtor').AsString;
    ProdutorTrabalho.QtdCaracterCodManejo        := Q.FieldByName('qtd_caracteres_cod_manejo').AsInteger;
    ProdutorTrabalho.IndConsultaPublica          := Q.FieldByName('ind_consulta_publica').AsString;
    ProdutorTrabalho.CodTipoAgrupamentoRacas     := Q.FieldByName('cod_tipo_agrup_racas').AsInteger;
    ProdutorTrabalho.QtdDenominadorCompRacial    := Q.FieldByName('qtd_denominador_comp_racial').AsInteger;
    ProdutorTrabalho.QtdDiasEntreCoberturas      := Q.FieldByName('qtd_dias_entre_coberturas').AsInteger;
    ProdutorTrabalho.QtdDiasDescansoReprodutivo  := Q.FieldByName('qtd_dias_descanso_reprodutivo').AsInteger;
    ProdutorTrabalho.QtdDiasDiagnosticoGestacao  := Q.FieldByName('qtd_dias_diagnostico_gestacao').AsInteger;
    ProdutorTrabalho.CodAptidao                  := Q.FieldByName('cod_aptidao').AsInteger;
    ProdutorTrabalho.CodSituacaoSisBov           := Q.FieldByName('cod_situacao_sisbov').AsString;
    ProdutorTrabalho.IndMostrarNome              := Q.FieldByName('ind_mostrar_nome').AsString;
    ProdutorTrabalho.IndMostrarIdentificadores   := Q.FieldByName('ind_mostrar_identificadores').AsString;
    ProdutorTrabalho.IndTransfereEmbrioes        := Q.FieldByName('ind_transfere_embrioes').AsString;
    ProdutorTrabalho.IndMostrarFiltroCompRacial  := Q.FieldByName('ind_mostrar_filtro_comp_racial').AsString;
    ProdutorTrabalho.IndEstacaoMonta             := Q.FieldByName('ind_estacao_monta').AsString;
    ProdutorTrabalho.IndTrabalhaAssociacaoRaca   := Q.FieldByName('ind_trabalha_assoc_raca').AsString;
    ProdutorTrabalho.QtdIdadeMinimaDesmame       := Q.FieldByName('qtd_idade_minima_desmame').AsInteger;
    ProdutorTrabalho.QtdIdadeMaximaDesmame       := Q.FieldByName('qtd_idade_maxima_desmame').AsInteger;
    ProdutorTrabalho.IndAplicarDesmameAutomatico := Q.FieldByName('ind_aplicar_desmame_automatico').AsString;
    CodProdutorTrabalho                          := ProdutorTrabalho.CodProdutor;
    QtdCaracteresManejoProdutor                  := ProdutorTrabalho.QtdCaracterCodManejo;

    // Identifica procedimento de definição como bem sucedido
    FExisteProdutorTrabalho := True;
    Q.Close;

    Result := DefinirFazendaTrabalho(-1);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := 0;
  finally
    Q.Free;
  end;
end;

function TConexao.DefinirFazendaTrabalho(CodFazenda: Integer): Integer;
var
  Q  : THerdomQuery;
  Q1 : THerdomQuery;
  Salva : TStringList;
begin
  Salva := TStringList.Create;
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'DefinirFazendaTrabalho']);
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if FCodProdutorTrabalho = -1 then begin
    Result := 307;
    Exit;
  end;




  Q  := THerdomQuery.Create(nil);
  Q1 := THerdomQuery.Create(nil);
  try
    Q.SQLConnection := FSQLConnection;

    // Obtem dados da fazenda
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select cod_fazenda, ');
    Q.SQL.Add('       sgl_fazenda, ');
    Q.SQL.Add('       nom_fazenda ');
    Q.SQL.Add('  from tab_fazenda  ');
    Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
    Q.SQL.Add('   and ((cod_fazenda = :cod_fazenda) or (:cod_fazenda < 0)) ');
    Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
    Q.ParamByName('cod_pessoa_produtor').AsInteger := FCodProdutorTrabalho;
    Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;

    Q.Open;

    // Verifica existência da fazenda
    if Q.IsEmpty then begin
      if CodFazenda > 0 then begin
        Result := 310;
        Exit;
      end else begin
        LimpaFazendaTrabalho;
      end;
    end else begin
      LimpaFazendaTrabalho;
      FFazendaTrabalho.CodFazenda         := Q.FieldByName('cod_fazenda').AsInteger;
      FFazendaTrabalho.SglFazenda         := Q.FieldByName('sgl_fazenda').AsString;
      FFazendaTrabalho.NomFazenda         := Q.FieldByName('nom_fazenda').AsString;


      try
        Q1 := THerdomQuery.Create(nil);
        Q1.SQLConnection := FSQLConnection;
        Q1.SQL.Clear;
        Q1.SQL.Add('select top 1 tv.data_vistoria as data_vistoria, tvs.descricao as nome_status');
        Q1.SQL.Add('from tab_vistoria tv join tab_vistoria_status tvs on tv.cod_status_vistoria = tvs.cod_status_vistoria');
        //Q1.SQL.Add('where tv.cod_status_vistoria = 2');
        Q1.SQL.Add('where   tv.cod_propriedade_rural = (select cod_propriedade_rural from tab_fazenda where cod_fazenda = ' + IntToStr(FFazendaTrabalho.CodFazenda) + ' and cod_pessoa_produtor = ' + IntToStr(FCodProdutorTrabalho) + ')');
        Q1.SQL.Add('order by tv.data_vistoria desc');
        Q1.Open;

        Salva.Text := Q1.SQL.Text;
        Salva.SaveToFile('C:\Herdom\sql.txt');

      finally
          FFazendaTrabalho.DataUltimaVistoria := Q1.Fields[0].AsString;
          FFazendaTrabalho.StatusVistoria     := Q1.Fields[1].AsString;
      end;




      FCodFazendaTrabalho                 := FFazendaTrabalho.CodFazenda;
      FExisteFazendaTrabalho              := True;
    end;
    Q.Close;
    Q1.Close;

    Result := 0;
  finally
    Q.Free;
    Q1.Free;
  end;
end;

function TConexao.ValorParametro(CodParametro: Integer; EMensagens: TObject): String;
var
  Q: THerdomQuery;
  Mensagens: TIntMensagens;
begin
  Result := '';
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'ValorParametro']);
    Exit;
  end;

  Mensagens := TIntMensagens(EMensagens);
  Q := THerdomQuery.Create(nil);
  try
    Q.SQLConnection := FSQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select val_parametro_sistema');
    Q.SQL.Add('  from tab_parametro_sistema');
    Q.SQL.Add(' where cod_parametro_sistema = :cod_parametro_sistema');
{$ENDIF}
    Q.ParamByName('cod_parametro_sistema').AsInteger := CodParametro;
    Q.Open;
    if Q.IsEmpty then begin
      Mensagens.Adicionar(193, Self.ClassName, 'ValorParametro', [IntToStr(CodParametro)]);
      Raise exception.CreateFmt('Parametro inexistente (%s)', [IntToStr(CodParametro)]);
    end;
    Result := Q.FieldByName('val_parametro_sistema').AsString;
  finally
    Q.Free;
  end;
end;

function TConexao.DtaSistema: TDateTime;
var
  Q : THerdomQuery;
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'DtaSistema']);
    Exit;
  end;

  Q := THerdomQuery.Create(nil);
  try
    Q.SQLConnection := FSQLConnection;
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select getdate() as dta_sistema');
{$ENDIF}
    Q.Open;
    Result := Q.FieldByName('dta_sistema').AsDateTime;
  finally
    Q.Free;
  end;
end;

function TConexao.EmTransacao: Boolean;
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'EmTransacao']);
    Exit;
  end;
  Result := uConexao.EmTransacao(FSQLConnection);
end;

procedure TConexao.beginTran;
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'beginTran']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.beginTran(FSQLConnection);
end;

procedure TConexao.begintran(NomTransacao: String);
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'beginTran']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.beginTran(FSQLConnection, NomTransacao);
end;

procedure TConexao.Commit;
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'Commit']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.Commit(FSQLConnection);
end;

procedure TConexao.Commit(NomTransacao: String);
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'Commit']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.Commit(FSQLConnection, NomTransacao);
end;

procedure TConexao.Rollback;
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'Rollback']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.Rollback(FSQLConnection);
end;

procedure TConexao.Rollback(NomTransacao: String);
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'Rollback']);
    Exit;
  end;
  if FIgnorarNovasTransacoes then Exit;
  uConexao.Rollback(FSQLConnection, NomTransacao);
end;

procedure TConexao.SaveTran(NomTransacao: String);
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'SaveTran']);
    Exit;
  end;
  uConexao.SaveTran(FSQLConnection, NomTransacao);
end;

procedure TConexao.RollTran(NomTransacao: String);
begin
  if not FAtiva then begin
    Raise exception.CreateResFmt(8, [Self.ClassName, Self.ClassName + 'RollTran']);
    Exit;
  end;
  uConexao.RollTran(FSQLConnection, NomTransacao);
end;

end.

