unit uIntTarefas;

{$DEFINE MSSQL}

interface

uses DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas, uFerramentas,
     uIntTarefa;

type
  TIntTarefas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntTarefa: TIntTarefa;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Buscar(CodTarefa: Integer): Integer;
    function Cancelar(CodTarefa: Integer): Integer;
    function Pesquisar(DtaAgendamentoInicio, DtaAgendamentoFim: TDateTime;
      QtdDiasConclusao: Integer; const CodSituacaoTarefa, NomUsuario,
      NomArqUpLoad: String; CodTipoOrigemArqImport: Integer): Integer;

    property IntTarefa: TIntTarefa read FIntTarefa write FIntTarefa;
  end;

implementation

{ TIntTarefas }

constructor TIntTarefas.Create;
begin
  inherited;
  FIntTarefa := TIntTarefa.Create;
end;

destructor TIntTarefas.Destroy;
begin
  FIntTarefa.Free;
  inherited;
end;

function TIntTarefas.Buscar(CodTarefa: Integer): Integer;
const
  Metodo: Integer = 409;
  NomeMetodo: String = 'Buscar';
var
  Q: THerdomQuery;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
{  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;  }

  try
    Q := THerdomQuery.Create(Conexao, nil);
    try
      with Q do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  tt.cod_tarefa as CodTarefa');
        SQL.Add('  , tt.cod_tipo_tarefa as CodTipoTarefa');
        SQL.Add('  , ttt.des_tipo_tarefa +');
{$IFDEF MSSQL}
        SQL.Add('    isnull('': ''+tt.txt_parametros, '''')');
{$ENDIF}
        SQL.Add('    as TipoTxtParametros');
        SQL.Add('  , tt.dta_agendamento as DtaAgendamento');
        SQL.Add('  , tt.dta_inicio_previsto as DtaInicioPrevisto');
        SQL.Add('  , tt.dta_inicio_real as DtaInicioReal');
        SQL.Add('  , tt.dta_fim_real as DtaFimReal');
        SQL.Add('  , tt.cod_situacao_tarefa as CodSituacaoTarefa');
        SQL.Add('  , tst.des_situacao_tarefa as DesSituacaoTarefa');
        SQL.Add('  , tt.qtd_progresso as QtdProgresso');
        SQL.Add('  , tt.txt_mensagem_erro as TxtMensagemErro');
        SQL.Add('  , tt.nom_arq_relatorio as NomArqRelatorio');
        SQL.Add('  , ttt.ind_permitir_cancelamento as IndPermiteCancelamento');
        SQL.Add('from');
        SQL.Add('  tab_tarefa tt');
        SQL.Add('  , tab_tipo_tarefa ttt');
        SQL.Add('  , tab_situacao_tarefa tst');
        SQL.Add('where');
        SQL.Add('  ttt.cod_tipo_tarefa = tt.cod_tipo_tarefa');
        SQL.Add('  and tst.cod_situacao_tarefa = tt.cod_situacao_tarefa');
        SQL.Add('  and tt.cod_tarefa = :cod_tarefa');
        AddSQL(Q, '  and tt.cod_usuario = :cod_usuario', Conexao.CodPapelUsuario <> 2);

        // Define os parametros
        ParamByName('cod_tarefa').AsInteger := CodTarefa;
        if (Conexao.CodPapelUsuario <> 2) then
        begin
          Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
        end;

        Open;

        // Consiste a existencia da tarefa informada
        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(1329, Self.ClassName, NomeMetodo, []);
          Result := -1329;
          Exit;
        end;

        // Popula a lista de propriedades para a tarefa informada
        FIntTarefa.CodSituacaoTarefa      := FieldByName('CodSituacaoTarefa').AsString;
        FIntTarefa.CodTarefa              := FieldByName('CodTarefa').AsInteger;
        FIntTarefa.CodTipoTarefa          := FieldByName('CodTipoTarefa').AsInteger;
        FIntTarefa.DesSituacaoTarefa      := FieldByName('DesSituacaoTarefa').AsString;
        FIntTarefa.DtaAgendamento         := FieldByName('DtaAgendamento').AsDateTime;
        FIntTarefa.DtaFimReal             := FieldByName('DtaFimReal').AsDateTime;
        FIntTarefa.DtaInicioPrevisto      := FieldByName('DtaInicioPrevisto').AsDateTime;
        FIntTarefa.DtaInicioReal          := FieldByName('DtaInicioReal').AsDateTime;
        FIntTarefa.IndPermiteCancelamento := FieldByName('IndPermiteCancelamento').AsString;
        FIntTarefa.QtdProgresso           := FieldByName('QtdProgresso').AsInteger;
        FIntTarefa.TxtMensagemErro        := FieldByName('TxtMensagemErro').AsString;
        FIntTarefa.NomArqRelatorio        := FieldByName('NomArqRelatorio').AsString;
        Close;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    finally
      Q.Free;
    end;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1327, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1327;
      Exit;
    end;
  end;
end;

function TIntTarefas.Cancelar(CodTarefa: Integer): Integer;
const
  Metodo: Integer = 410;
  NomeMetodo: String = 'Cancelar';
var
  Q: THerdomQuery;
  iAux: Integer;
  sAux: String;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
{  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;  }

  try
    Q := THerdomQuery.Create(Conexao, nil);
    try
      // Consiste se a tarefa informada é válida
      with Q do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('    cod_tipo_tarefa as CodTipoTarefa');
        SQL.Add('  , cod_situacao_tarefa as CodSituacaoTarefa');
        SQL.Add('from');
        SQL.Add('  tab_tarefa');
        SQL.Add('where');
        SQL.Add('  cod_tarefa = :cod_tarefa');
        AddSQL(Q, '  and cod_usuario = :cod_usuario', Conexao.CodPapelUsuario <> 2);

        ParamByName('cod_tarefa').AsInteger := CodTarefa;
        if (Conexao.CodPapelUsuario <> 2) then
        begin
          ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
        end;
        Open;

        if IsEmpty then
        begin
          Mensagens.Adicionar(1329, Self.ClassName, NomeMetodo, []);
          Result := -1329;
          Exit;
        end;
        
        if (FieldByName('CodSituacaoTarefa').AsString <> 'N')
          and (FieldByName('CodSituacaoTarefa').AsString <> 'A') then
        begin
          Mensagens.Adicionar(1334, Self.ClassName, NomeMetodo, []);
          Result := -1334;
          Exit;
        end;
        
        iAux := FieldByName('CodTipoTarefa').AsInteger;
        sAux := FieldByName('CodSituacaoTarefa').AsString;
      end;

      with Q do
      begin
        // Consiste se o tipo de tarefa, permite à tarefa ser cancelada
        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  ind_permitir_cancelamento as IndPermitirCancelamento');
        SQL.Add('  , des_tipo_tarefa as DesTipoTarefa');
        SQL.Add('from');
        SQL.Add('  tab_tipo_tarefa');
        SQL.Add('where');
        SQL.Add('  cod_tipo_tarefa = :cod_tipo_tarefa');
        ParamByName('cod_tipo_tarefa').AsInteger := iAux;
        Open;
        if FieldByName('IndPermitirCancelamento').AsString = 'N' then
        begin
          Mensagens.Adicionar(1330, Self.ClassName, NomeMetodo,
            [FieldByName('DesTipoTarefa').AsString]);
          Result := -1330;
          Exit;
        end;
      end;

      // Inicia transação
      BeginTran;

      with Q do
      begin
        Close;
        if sAux = 'A' then
        begin
          // Solicita cancelamento da tarefa
          SQL.Add('update tab_tarefa');
          SQL.Add('set');
          SQL.Add('  ind_cancelada = ''S''');
          SQL.Add('where');
          SQL.Add('  cod_tarefa = :cod_tarefa');
          ParamByName('cod_tarefa').AsInteger := CodTarefa;
          ExecSQL;
        end
        else
        begin
          // Realiza exclusão física da tarefa agendada informada
          SQL.Add('delete from tab_tarefa_parametro');
          SQL.Add('  where cod_tarefa = :cod_tarefa');
          ParamByName('cod_tarefa').AsInteger := CodTarefa;
          ExecSQL;

          SQL.Add('delete from tab_tarefa');
          SQL.Add('  where cod_tarefa = :cod_tarefa');
          ParamByName('cod_tarefa').AsInteger := CodTarefa;
          ExecSQL;
        end;
      end;

      // Encerra transação
      Commit;

      // Identifica procedimento como bem sucedido
      Result := 0;
    finally
      Q.Free;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1328, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1328;
      Exit;
    end;
  end;
end;

function TIntTarefas.Pesquisar(DtaAgendamentoInicio,
  DtaAgendamentoFim: TDateTime; QtdDiasConclusao: Integer;
  const CodSituacaoTarefa, NomUsuario, NomArqUpLoad: String;
  CodTipoOrigemArqImport: Integer): Integer;
const
  Metodo: Integer = 408;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Clear;
{$IFDEF MSSQL}
      AddSQL(Query, 'select');
      AddSQL(Query, '    tt.cod_tarefa as CodTarefa');
      AddSQL(Query, '  , tt.cod_tipo_tarefa as CodTipoTarefa');
      AddSQL(Query, '  , tt.nom_arq_relatorio as NomArqRelatorio');
      AddSQL(Query, '  , tt.dta_agendamento as DtaAgendamento');
      AddSQL(Query, '  , tt.cod_situacao_tarefa as CodSituacaoTarefa');
      AddSQL(Query, '  , tt.qtd_progresso as QtdProgresso');
      AddSQL(Query, '  , ttt.des_tipo_tarefa +');
      AddSQL(Query, '    isnull('': ''+tt.txt_parametros, '''')');
      AddSQL(Query, '    as TipoTxtParametros');
      AddSQL(Query, '  , case when tt.cod_tipo_tarefa = 1 then');
      AddSQL(Query, '      cast(ttp_cpp.val_parametro as integer)');
      AddSQL(Query, '    else');
      AddSQL(Query, '      null');
      AddSQL(Query, '    end as CodPessoaProdutor');
      AddSQL(Query, '  , case tt.cod_tipo_tarefa');
      AddSQL(Query, '    when 1 then');
      AddSQL(Query, '      cast(ttp_cai.val_parametro as integer)');
      AddSQL(Query, '    when 2 then');
      AddSQL(Query, '      cast(ttp_cpp.val_parametro as integer)');
      AddSQL(Query, '    else');
      AddSQL(Query, '      null');
      AddSQL(Query, '    end as CodArquivoImportacao');
      AddSQL(Query, '  , tu.nom_usuario as NomUsuarioUpLoad', Conexao.CodPapelUsuario = 2);
      AddSQL(Query, '  , tt.cod_tipo_origem_arq_import as CodTipoOrigemArqImport', CodTipoOrigemArqImport > 0);
      AddSQL(Query, '  , ttt.des_tipo_tarefa +');
      AddSQL(Query, '    isnull('': ''+tt.nom_arq_upload, '''')');
      AddSQL(Query, '    as NomArqUpLoad');
      AddSQL(Query, 'from');
      AddSQL(Query, '    tab_tarefa tt with (nolock)');
      AddSQL(Query, '  , tab_tipo_tarefa ttt with (nolock)');
      AddSQL(Query, '  , tab_tarefa_parametro ttp_cpp with (nolock)');
      AddSQL(Query, '  , tab_tarefa_parametro ttp_cai with (nolock)');
      AddSQL(Query, '  , tab_usuario tu with (nolock)', Conexao.CodPapelUsuario = 2);
      AddSQL(Query, 'where');
      AddSQL(Query, '  ttt.cod_tipo_tarefa = tt.cod_tipo_tarefa');
      AddSQL(Query, '  and ttp_cpp.cod_tarefa =* tt.cod_tarefa');
      AddSQL(Query, '  and ttp_cpp.cod_parametro =* (select cod_parametro from tab_tarefa_parametro');
      AddSQL(Query, '                                where cod_tarefa = tt.cod_tarefa and cod_parametro = 1)');
      AddSQL(Query, '  and ttp_cai.cod_tarefa =* tt.cod_tarefa');
      AddSQL(Query, '  and ttp_cai.cod_parametro =* (select cod_parametro from tab_tarefa_parametro');
      AddSQL(Query, '                                where cod_tarefa = tt.cod_tarefa and cod_parametro = 2)');
      AddSQL(Query, '  and tu.cod_usuario = tt.cod_usuario', Conexao.CodPapelUsuario = 2);
      AddSQL(Query, '  and tt.cod_usuario = :cod_usuario', Conexao.CodPapelUsuario <> 2);
      AddSQL(Query, '  and tt.dta_agendamento > :dta_agendamento_inicio', DtaAgendamentoInicio > 0);
      AddSQL(Query, '  and tt.dta_agendamento < :dta_agendamento_fim', DtaAgendamentoFim > 0);
      AddSQL(Query, '  and getdate() - tt.dta_fim_real <= :qtd_dias_conclusao', QtdDiasConclusao > 0);
      AddSQL(Query, '  and tt.cod_situacao_tarefa = :cod_situacao_tarefa', Length(Trim(CodSituacaoTarefa)) > 0);
      AddSQL(Query, '  and tu.nom_usuario like :nom_usuario', Length(Trim(NomUsuario)) > 0);
      AddSQL(Query, '  and tt.cod_tipo_origem_arq_import = :cod_tipo_origem_arq_import', CodTipoOrigemArqImport > 0);
      AddSQL(Query, '  and tt.nom_arq_upload = :nom_arq_upload', Length(Trim(NomArqUpLoad)) > 0);
      AddSQL(Query, 'order by');
      AddSQL(Query, '  DtaAgendamento desc');
{$ENDIF}

      if (Conexao.CodPapelUsuario <> 2) then
      begin
        ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      end;
      if (DtaAgendamentoInicio > 0) then
      begin
        ParamByName('dta_agendamento_inicio').AsDateTime := Trunc(DtaAgendamentoInicio);
      end;
      if (DtaAgendamentoFim > 0) then
      begin
        ParamByName('dta_agendamento_fim').AsDateTime := Trunc(DtaAgendamentoFim)+1;
      end;
      if (QtdDiasConclusao > 0) then
      begin
        ParamByName('qtd_dias_conclusao').AsInteger := QtdDiasConclusao;
      end;
      if (Length(Trim(CodSituacaoTarefa)) > 0) then
      begin
        ParamByName('cod_situacao_tarefa').AsString := CodSituacaoTarefa;
      end;
      if (Length(Trim(NomUsuario)) > 0) then
      begin
        ParamByName('nom_usuario').AsString := '%' + NomUsuario + '%';
      end;
      if (CodTipoOrigemArqImport > 0) then
      begin
        ParamByName('cod_tipo_origem_arq_import').asInteger := CodTipoOrigemArqImport;
      end;
      if (Length(Trim(NomArqUpLoad)) > 0) then
      begin
        ParamByName('nom_arq_upload').AsString := '%' + NomArqUpLoad + '%';
      end;

      Open;
    end;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(1326, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1326;
      Exit;
    end;
  end;
end;

end.
