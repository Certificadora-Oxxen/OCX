unit uIntComunicados;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntComunicado, dbtables, sysutils, db, uFerramentas;

type
  { TIntComunicados }
  TIntComunicados = class(TIntClasseBDNavegacaoBasica)
  private
    FIntComunicado : TIntComunicado;
    function ConsisteDadosComunicado(CodUsuario: Integer;TxtAssunto,
      TxtComunicado: String; DtaInicioValidade,
      DtaFimValidade: TDateTime; NomeMetodo: String;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function PesquisarEnviados(CodUsuarioEnvio: Integer; DtaInicio,
      DtaFim: TDateTime): Integer;
    function PesquisarDestinatarios(CodComunicado: Integer;
      IndComunicadoLido: WideString): Integer;
    function PesquisarNaoLidos(CodUsuario: Integer): Integer;
    function PesquisarHistorico(CodUsuario: Integer; DtaInicio,
      DtaFim: TDateTime): Integer;
    function EnviarParaUsuario(CodUsuario: Integer; TxtAssunto,
      TxtComunicado: String; DtaInicioValidade,
      DtaFimValidade: TDateTime; IndComunicadoImportante: String;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
    function EnviarParaTodos(TxtAssunto, TxtComunicado: String;
      DtaInicioValidade, DtaFimValidade: TDateTime;
      IndComunicadoImportante: String; CodPapel,
      CodOpcaoEnvioComunicado: Integer): Integer;
    function EnviarParaProdutores(CodTecnico, CodAssociacao: Integer;
      TxtAssunto, TxtComunicado: String; DtaInicioValidade,
      DtaFimValidade: TDateTime; IndComunicadoImportante: String;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
    function EnviarParaTecnicos(CodProdutor: Integer; TxtAssunto,
      TxtComunicado: String; DtaInicioValidade,
      DtaFimValidade: TDateTime; IndComunicadoImportante: String;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
    function EnviarParaAssociacao(CodProdutor: Integer; TxtAssunto,
      TxtComunicado: String; DtaInicioValidade,
      DtaFimValidade: TDateTime; IndComunicadoImportante: String;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
    function BuscarEnviado(CodComunicado: Integer): Integer;
    function BuscarRecebido(CodComunicado, CodUsuarioDestinatario: Integer): Integer;
    function MarcarComoLido(CodComunicado: Integer): Integer;
    function FinalizarComunicado(CodComunicado: Integer): Integer; 

    property IntComunicado : TIntComunicado read FIntComunicado write FIntComunicado;
  end;

implementation

{ TIntComunicados }
constructor TIntComunicados.Create;
begin
  inherited;
  FIntComunicado := TIntComunicado.Create;
end;

destructor TIntComunicados.Destroy;
begin
  FIntComunicado.Free;
  inherited;
end;

function TIntComunicados.BuscarEnviado(CodComunicado: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BuscarEnviado');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(58) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'BuscarEnviado', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tc.cod_comunicado, ');
      Q.SQL.Add('       tc.txt_assunto, ');
      Q.SQL.Add('       tc.txt_comunicado, ');
      Q.SQL.Add('       tc.dta_inicio_validade, ');
      Q.SQL.Add('       tc.dta_fim_validade, ');
      Q.SQL.Add('       tc.dta_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_envio, ');
      Q.SQL.Add('       tu.nom_usuario, ');
      Q.SQL.Add('       tp.cod_pessoa, ');
      Q.SQL.Add('       tu.cod_papel, ');
      Q.SQL.Add('       tpap.des_papel, ');
      Q.SQL.Add('       tc.cod_opcao_envio_comunicado, ');
      Q.SQL.Add('       toec.des_opcao_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_opcao_envio, ');
      Q.SQL.Add('       tuoe.nom_usuario as nom_usuario_opcao_envio, ');
      Q.SQL.Add('       tc.cod_pessoa_opcao_envio, ');
      Q.SQL.Add('       tc.cod_papel_opcao_envio, ');
      Q.SQL.Add('       tpoe.des_papel as des_papel_opcao_envio');
      Q.SQL.Add('  from tab_comunicado tc, ');
      Q.SQL.Add('       tab_usuario tu, ');
      Q.SQL.Add('       tab_pessoa tp, ');
      Q.SQL.Add('       tab_papel tpap, ');
      Q.SQL.Add('       tab_opcao_envio_comunicado toec, ');
      Q.SQL.Add('       tab_usuario tuoe, ');
      Q.SQL.Add('       tab_papel tpoe ');
      Q.SQL.Add(' where tu.cod_usuario = tc.cod_usuario_envio ');
      Q.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
      Q.SQL.Add('   and tpap.cod_papel = tu.cod_papel ');
      Q.SQL.Add('   and toec.cod_papel = tc.cod_papel ');
      Q.SQL.Add('   and toec.cod_opcao_envio_comunicado = tc.cod_opcao_envio_comunicado ');
      Q.SQL.Add('   and tuoe.cod_usuario =* tc.cod_usuario_opcao_envio ');
      Q.SQL.Add('   and tpoe.cod_papel =* tc.cod_papel_opcao_envio ');
      Q.SQL.Add('   and tc.cod_comunicado = :cod_comunicado ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(239, Self.ClassName, 'BuscarEnviado', [IntToStr(CodComunicado)]);
        Result := -239;
        Exit;
      End;

      // Obtem informações do registro
      FIntComunicado.CodComunicado       := Q.FieldbyName('cod_comunicado').AsInteger;
      FIntComunicado.TxtAssunto          := Q.FieldbyName('txt_assunto').AsString;
      FIntComunicado.TxtComunicado       := Q.FieldbyName('txt_comunicado').AsString;
      FIntComunicado.DtaInicioValidade   := Q.FieldbyName('dta_inicio_validade').AsDateTime;
      FIntComunicado.DtaFimValidade      := Q.FieldbyName('dta_fim_validade').AsDateTime;
      FIntComunicado.DtaEnvioComunicado  := Q.FieldbyName('dta_envio_comunicado').AsDateTime;
      FIntComunicado.CodUsuarioEnvio     := Q.FieldbyName('cod_usuario_envio').AsInteger;
      FIntComunicado.NomUsuarioEnvio     := Q.FieldbyName('nom_usuario').AsString;
      FIntComunicado.PessoaEnvio.CarregaPropriedades(Q.FieldbyName('cod_pessoa').AsInteger, Conexao, Mensagens);
      FIntComunicado.CodPapelEnvio       := Q.FieldbyName('cod_papel').AsInteger;
      FIntComunicado.DesPapelEnvio       := Q.FieldbyName('des_papel').AsString;
      FIntComunicado.CodOpcaoEnvio       := Q.FieldbyName('cod_opcao_envio_comunicado').AsInteger;
      FIntComunicado.DesOpcaoEnvio       := Q.FieldbyName('des_opcao_envio_comunicado').AsString;
      FIntComunicado.CodUsuarioOpcaoEnvio     := Q.FieldbyName('cod_usuario_opcao_envio').AsInteger;
      FIntComunicado.NomUsuarioOpcaoEnvio     := Q.FieldbyName('nom_usuario_opcao_envio').AsString;
      If Not Q.FieldbyName('cod_pessoa_opcao_envio').IsNull Then Begin
        FIntComunicado.PessoaOpcaoEnvio.CarregaPropriedades(Q.FieldbyName('cod_pessoa_opcao_envio').AsInteger, Conexao, Mensagens);
      End;  
      FIntComunicado.CodPapelOpcaoEnvio       := Q.FieldbyName('cod_papel_opcao_envio').AsInteger;
      FIntComunicado.DesPapelOpcaoEnvio       := Q.FieldbyName('des_papel_opcao_envio').AsString;
      FIntComunicado.DesSituacao         := '';
      FIntComunicado.DtaLeitura          := 0;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(240, Self.ClassName, 'BuscarEnviado', [E.Message]);
        Result := -240;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.EnviarParaAssociacao(CodProdutor: Integer;
  TxtAssunto, TxtComunicado: String; DtaInicioValidade,
  DtaFimValidade: TDateTime; IndComunicadoImportante: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  CodComunicado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EnviarParaAssociacao');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(57) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EnviarParaAssociacao', []);
    Result := -188;
    Exit;
  End;

  Result := ConsisteDadosComunicado(-1, TxtAssunto, TxtComunicado, DtaInicioValidade,
                                    DtaFimValidade, 'EnviarParaAssociacao',
                                    CodPapel, CodOpcaoEnvioComunicado);
  If Result < 0 Then exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se produtor existe
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_produtor tp');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_produtor').AsInteger := CodProdutor;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, 'EnviarParaAssociacao', [IntToStr(CodProdutor)]);
        Result := -170;
        Exit;
      End;

      // Abre Transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_comunicado), 0) + 1 as cod_comunicado from tab_comunicado');
{$ENDIF}
      Q.Open;
      CodComunicado := Q.FieldByName('cod_comunicado').AsInteger;

      // Insere Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  txt_assunto, ');
      Q.SQL.Add('  txt_comunicado, ');
      Q.SQL.Add('  ind_comunicado_importante, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade, ');
      Q.SQL.Add('  dta_envio_comunicado, ');
      Q.SQL.Add('  cod_usuario_envio, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  cod_papel_opcao_envio, ');
      Q.SQL.Add('  cod_usuario_opcao_envio) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :txt_assunto, ');
      Q.SQL.Add('  :txt_comunicado, ');
      Q.SQL.Add('  :ind_comunicado_importante, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_usuario_envio, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  :cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  :cod_papel_opcao_envio, ');
      Q.SQL.Add('  :cod_usuario_opcao_envio) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('txt_assunto').AsString := TxtAssunto;
      Q.ParamByName('txt_comunicado').AsString := TxtComunicado;
      Q.ParamByName('ind_comunicado_importante').AsString := IndComunicadoImportante;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario_envio').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      Q.ParamByName('cod_pessoa_opcao_envio').AsInteger := CodProdutor;
      Q.ParamByName('cod_papel_opcao_envio').AsInteger := 4;
      Q.ParamByName('cod_usuario_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_usuario_opcao_envio').Clear;
      Q.ExecSQL;

      // "Envia" Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado_usuario ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  cod_usuario_destinatario, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('  select :cod_comunicado, ');
      Q.SQL.Add('         tud.cod_usuario, ');
      Q.SQL.Add('         :dta_inicio_validade, ');
      Q.SQL.Add('         :dta_fim_validade ');
      Q.SQL.Add('    from tab_usuario tud, ');
      Q.SQL.Add('         tab_associacao_produtor tap ');
      Q.SQL.Add('   where tap.cod_pessoa_produtor = :cod_produtor ');
      Q.SQL.Add('     and tud.cod_pessoa = tap.cod_pessoa_associacao ');
      Q.SQL.Add('     and tud.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_produtor').AsInteger := CodProdutor;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ExecSQL;

      // Confirma Transação
      Commit;

      // Retorna status "ok" do método
      Result := CodComunicado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(283, Self.ClassName, 'EnviarParaAssociacao', [E.Message]);
        Result := -283;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.EnviarParaProdutores(CodTecnico,
  CodAssociacao: Integer; TxtAssunto, TxtComunicado: String;
  DtaInicioValidade, DtaFimValidade: TDateTime; IndComunicadoImportante: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  CodComunicado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EnviarParaProdutores');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(55) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EnviarParaProdutores', []);
    Result := -188;
    Exit;
  End;

  If (CodTecnico > 0) And (CodAssociacao > 0) Then Begin
    Mensagens.Adicionar(469, Self.ClassName, 'EnviarParaProdutores', []);
    Result := -469;
    Exit;
  End;

  If (CodTecnico <= 0) And (CodAssociacao <= 0) Then Begin
    Mensagens.Adicionar(470, Self.ClassName, 'EnviarParaProdutores', []);
    Result := -470;
    Exit;
  End;

  Result := ConsisteDadosComunicado(-1, TxtAssunto, TxtComunicado, DtaInicioValidade,
                                    DtaFimValidade, 'EnviarParaProdutores',
                                    CodPapel, CodOpcaoEnvioComunicado);
  If Result < 0 Then exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      If CodTecnico > 0 Then Begin
        // Verifica se tecnico existe
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_tecnico');
        Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodTecnico;
        Q.Open;

        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(468, Self.ClassName, 'EnviarParaProdutores', [IntToStr(CodTecnico)]);
          Result := -468;
          Exit;
        End;
      End Else Begin
        // Verifica se associacao existe
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_associacao');
        Q.SQL.Add(' where cod_pessoa_associacao = :cod_pessoa_associacao ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_associacao').AsInteger := CodAssociacao;
        Q.Open;

        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(471, Self.ClassName, 'EnviarParaProdutores', [IntToStr(CodAssociacao)]);
          Result := -471;
          Exit;
        End;
      End;

      // Abre Transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_comunicado), 0) + 1 as cod_comunicado from tab_comunicado');
{$ENDIF}
      Q.Open;
      CodComunicado := Q.FieldByName('cod_comunicado').AsInteger;

      // Insere Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  txt_assunto, ');
      Q.SQL.Add('  txt_comunicado, ');
      Q.SQL.Add('  ind_comunicado_importante, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade, ');
      Q.SQL.Add('  dta_envio_comunicado, ');
      Q.SQL.Add('  cod_usuario_envio, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  cod_papel_opcao_envio, ');
      Q.SQL.Add('  cod_usuario_opcao_envio) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :txt_assunto, ');
      Q.SQL.Add('  :txt_comunicado, ');
      Q.SQL.Add('  :ind_comunicado_importante, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_usuario_envio, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  :cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  :cod_papel_opcao_envio, ');
      Q.SQL.Add('  :cod_usuario_opcao_envio) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('txt_assunto').AsString := TxtAssunto;
      Q.ParamByName('txt_comunicado').AsString := TxtComunicado;
      Q.ParamByName('ind_comunicado_importante').AsString := IndComunicadoImportante;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario_envio').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      If CodTecnico > 0 Then Begin
        Q.ParamByName('cod_pessoa_opcao_envio').AsInteger := CodTecnico;
        Q.ParamByName('cod_papel_opcao_envio').AsInteger := 3;
      End Else Begin
        Q.ParamByName('cod_pessoa_opcao_envio').AsInteger := CodAssociacao;
        Q.ParamByName('cod_papel_opcao_envio').AsInteger := 1;
      End;
      Q.ParamByName('cod_usuario_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_usuario_opcao_envio').Clear;
      Q.ExecSQL;

      // "Envia" Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado_usuario ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  cod_usuario_destinatario, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade) ');
      If CodTecnico > 0 Then Begin
        Q.SQL.Add('  select :cod_comunicado, ');
        Q.SQL.Add('         tud.cod_usuario, ');
        Q.SQL.Add('         :dta_inicio_validade, ');
        Q.SQL.Add('         :dta_fim_validade ');
        Q.SQL.Add('    from tab_usuario tud, ');
        Q.SQL.Add('         tab_tecnico_produtor ttp, ');
        Q.SQL.Add('         tab_produtor tp ');
        Q.SQL.Add('   where ttp.cod_pessoa_tecnico = :cod_pessoa_tecnico ');
        Q.SQL.Add('     and tud.cod_pessoa = ttp.cod_pessoa_produtor ');
        Q.SQL.Add('     and tp.cod_pessoa_produtor = ttp.cod_pessoa_produtor ');
        Q.SQL.Add('     and tp.dta_fim_validade is null ');
        Q.SQL.Add('     and tud.dta_fim_validade is null ');
        Q.SQL.Add('     and ttp.dta_fim_validade is null ');
      End Else Begin
        Q.SQL.Add('  select :cod_comunicado, ');
        Q.SQL.Add('         tud.cod_usuario, ');
        Q.SQL.Add('         :dta_inicio_validade, ');
        Q.SQL.Add('         :dta_fim_validade ');
        Q.SQL.Add('    from tab_usuario tud, ');
        Q.SQL.Add('         tab_associacao_produtor tap, ');
        Q.SQL.Add('         tab_produtor tp ');
        Q.SQL.Add('   where tap.cod_pessoa_associacao = :cod_pessoa_associacao ');
        Q.SQL.Add('     and tud.cod_pessoa = tap.cod_pessoa_produtor ');
        Q.SQL.Add('     and tp.cod_pessoa_produtor = tap.cod_pessoa_produtor ');
        Q.SQL.Add('     and tp.dta_fim_validade is null ');
        Q.SQL.Add('     and tud.dta_fim_validade is null ');
      End;
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      If CodTecnico > 0 Then Begin
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodTecnico;
      End Else Begin
        Q.ParamByName('cod_pessoa_associacao').AsInteger := CodAssociacao;
      End;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ExecSQL;

      // Confirma Transação
      Commit;

      // Retorna status "ok" do método
      Result := CodComunicado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(283, Self.ClassName, 'EnviarParaProdutores', [E.Message]);
        Result := -283;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.EnviarParaTecnicos(CodProdutor: Integer;
  TxtAssunto, TxtComunicado: String; DtaInicioValidade,
  DtaFimValidade: TDateTime; IndComunicadoImportante: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  CodComunicado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EnviarParaTecnicos');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(56) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EnviarParaTecnicos', []);
    Result := -188;
    Exit;
  End;

  Result := ConsisteDadosComunicado(-1, TxtAssunto, TxtComunicado, DtaInicioValidade,
                                    DtaFimValidade, 'EnviarParaTecnicos',
                                    CodPapel, CodOpcaoEnvioComunicado);
  If Result < 0 Then exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se produtor existe
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_produtor tp');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_produtor').AsInteger := CodProdutor;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, 'EnviarParaTecnicos', [IntToStr(CodProdutor)]);
        Result := -170;
        Exit;
      End;

      // Abre Transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_comunicado), 0) + 1 as cod_comunicado from tab_comunicado');
{$ENDIF}
      Q.Open;
      CodComunicado := Q.FieldByName('cod_comunicado').AsInteger;

      // Insere Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  txt_assunto, ');
      Q.SQL.Add('  txt_comunicado, ');
      Q.SQL.Add('  ind_comunicado_importante, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade, ');
      Q.SQL.Add('  dta_envio_comunicado, ');
      Q.SQL.Add('  cod_usuario_envio, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  cod_papel_opcao_envio, ');
      Q.SQL.Add('  cod_usuario_opcao_envio) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :txt_assunto, ');
      Q.SQL.Add('  :txt_comunicado, ');
      Q.SQL.Add('  :ind_comunicado_importante, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_usuario_envio, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  :cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  :cod_papel_opcao_envio, ');
      Q.SQL.Add('  :cod_usuario_opcao_envio) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('txt_assunto').AsString := TxtAssunto;
      Q.ParamByName('txt_comunicado').AsString := TxtComunicado;
      Q.ParamByName('ind_comunicado_importante').AsString := IndComunicadoImportante;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario_envio').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      Q.ParamByName('cod_pessoa_opcao_envio').AsInteger := CodProdutor;
      Q.ParamByName('cod_papel_opcao_envio').AsInteger := 4;
      Q.ParamByName('cod_usuario_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_usuario_opcao_envio').Clear;
      Q.ExecSQL;

      // "Envia" Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado_usuario ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  cod_usuario_destinatario, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('  select :cod_comunicado, ');
      Q.SQL.Add('         tud.cod_usuario, ');
      Q.SQL.Add('         :dta_inicio_validade, ');
      Q.SQL.Add('         :dta_fim_validade ');
      Q.SQL.Add('    from tab_usuario tud, ');
      Q.SQL.Add('         tab_tecnico_produtor ttp, ');
      Q.SQL.Add('         tab_tecnico tt ');
      Q.SQL.Add('   where ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('     and tud.cod_pessoa = ttp.cod_pessoa_tecnico ');
      Q.SQL.Add('     and tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
      Q.SQL.Add('     and tt.dta_fim_validade is null ');
      Q.SQL.Add('     and tud.dta_fim_validade is null ');
      Q.SQL.Add('     and ttp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ExecSQL;

      // Confirma Transação
      Commit;

      // Retorna status "ok" do método
      Result := CodComunicado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(283, Self.ClassName, 'EnviarParaTecnicos', [E.Message]);
        Result := -283;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.EnviarParaTodos(TxtAssunto, TxtComunicado: String;
  DtaInicioValidade, DtaFimValidade: TDateTime; IndComunicadoImportante: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  CodComunicado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EnviarParaTodos');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(54) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EnviarParaTodos', []);
    Result := -188;
    Exit;
  End;

  Result := ConsisteDadosComunicado(-1, TxtAssunto, TxtComunicado, DtaInicioValidade,
                                    DtaFimValidade, 'EnviarParaTodos',
                                    CodPapel, CodOpcaoEnvioComunicado);
  If Result < 0 Then exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Abre Transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_comunicado), 0) + 1 as cod_comunicado from tab_comunicado');
{$ENDIF}
      Q.Open;
      CodComunicado := Q.FieldByName('cod_comunicado').AsInteger;

      // Insere Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  txt_assunto, ');
      Q.SQL.Add('  txt_comunicado, ');
      Q.SQL.Add('  ind_comunicado_importante, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade, ');
      Q.SQL.Add('  dta_envio_comunicado, ');
      Q.SQL.Add('  cod_usuario_envio, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  cod_papel_opcao_envio, ');
      Q.SQL.Add('  cod_usuario_opcao_envio) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :txt_assunto, ');
      Q.SQL.Add('  :txt_comunicado, ');
      Q.SQL.Add('  :ind_comunicado_importante, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_usuario_envio, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  :cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  :cod_papel_opcao_envio, ');
      Q.SQL.Add('  :cod_usuario_opcao_envio) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('txt_assunto').AsString := TxtAssunto;
      Q.ParamByName('txt_comunicado').AsString := TxtComunicado;
      Q.ParamByName('ind_comunicado_importante').AsString := IndComunicadoImportante;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario_envio').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      Q.ParamByName('cod_pessoa_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_pessoa_opcao_envio').Clear;
      Q.ParamByName('cod_papel_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_papel_opcao_envio').Clear;
      Q.ParamByName('cod_usuario_opcao_envio').DataType := ftInteger;
      Q.ParamByName('cod_usuario_opcao_envio').Clear;
      Q.ExecSQL;

      // "Envia" Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado_usuario ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  cod_usuario_destinatario, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('select :cod_comunicado, ');
      Q.SQL.Add('       tu.cod_usuario, ');
      Q.SQL.Add('       :dta_inicio_validade, ');
      Q.SQL.Add('       :dta_fim_validade ');
      Q.SQL.Add('  from tab_usuario tu ');
      Q.SQL.Add(' where tu.dta_fim_validade is null ');
      Q.SQL.Add('   and tu.cod_usuario != :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      // Confirma Transação
      Commit;

      // Retorna status "ok" do método
      Result := CodComunicado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(283, Self.ClassName, 'EnviarParaTodos', [E.Message]);
        Result := -283;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.EnviarParaUsuario(CodUsuario: Integer; TxtAssunto,
  TxtComunicado: String; DtaInicioValidade,
  DtaFimValidade: TDateTime; IndComunicadoImportante: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  CodPessoaOpcaoEnvio, CodPapelOpcaoEnvio, CodComunicado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EnviarParaUsuario');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(53) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EnviarParaUsuario', []);
    Result := -188;
    Exit;
  End;

  Result := ConsisteDadosComunicado(CodUsuario, TxtAssunto, TxtComunicado, DtaInicioValidade,
                                    DtaFimValidade, 'EnviarParaUsuario',
                                    CodPapel, CodOpcaoEnvioComunicado);
  If Result < 0 Then exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Obtem pessoa e papel do usuário
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pessoa, cod_papel ');
      Q.SQL.Add('  from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(209, Self.ClassName, 'EnviarParaUsuario', [IntToStr(CodUsuario)]);
        Result := -209;
        Exit;
      End;
      CodPessoaOpcaoEnvio := Q.FieldByName('cod_pessoa').AsInteger;
      CodPapelOpcaoEnvio := Q.FieldByName('cod_papel').AsInteger;

      // Abre Transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_comunicado), 0) + 1 as cod_comunicado from tab_comunicado');
{$ENDIF}
      Q.Open;
      CodComunicado := Q.FieldByName('cod_comunicado').AsInteger;

      // Insere Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  txt_assunto, ');
      Q.SQL.Add('  txt_comunicado, ');
      Q.SQL.Add('  ind_comunicado_importante, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade, ');
      Q.SQL.Add('  dta_envio_comunicado, ');
      Q.SQL.Add('  cod_usuario_envio, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  cod_papel_opcao_envio, ');
      Q.SQL.Add('  cod_usuario_opcao_envio) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :txt_assunto, ');
      Q.SQL.Add('  :txt_comunicado, ');
      Q.SQL.Add('  :ind_comunicado_importante, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_usuario_envio, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_opcao_envio_comunicado, ');
      Q.SQL.Add('  :cod_pessoa_opcao_envio, ');
      Q.SQL.Add('  :cod_papel_opcao_envio, ');
      Q.SQL.Add('  :cod_usuario_opcao_envio) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('txt_assunto').AsString := TxtAssunto;
      Q.ParamByName('txt_comunicado').AsString := TxtComunicado;
      Q.ParamByName('ind_comunicado_importante').AsString := IndComunicadoImportante;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ParamByName('cod_usuario_envio').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      Q.ParamByName('cod_pessoa_opcao_envio').AsInteger := CodPessoaOpcaoEnvio;
      Q.ParamByName('cod_papel_opcao_envio').AsInteger := CodPapelOpcaoEnvio;
      Q.ParamByName('cod_usuario_opcao_envio').AsInteger := CodUsuario;
      Q.ExecSQL;

      // "Envia" Comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_comunicado_usuario ');
      Q.SQL.Add(' (cod_comunicado,  ');
      Q.SQL.Add('  cod_usuario_destinatario, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_comunicado,  ');
      Q.SQL.Add('  :cod_usuario_destinatario, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :dta_fim_validade) ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_usuario_destinatario').AsInteger := Codusuario;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime := DtaFimValidade;
      Q.ExecSQL;

      // Confirma Transação
      Commit;

      // Retorna status "ok" do método
      Result := CodComunicado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(283, Self.ClassName, 'EnviarParaUsuario', [E.Message]);
        Result := -283;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.MarcarComoLido(CodComunicado: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('MarcarComoLido');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(59) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'MarcarComoLido', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_comunicado tc,  ');
      Q.SQL.Add('       tab_comunicado_usuario tcu  ');
      Q.SQL.Add(' where tcu.cod_comunicado = tc.cod_comunicado ');
      Q.SQL.Add('   and tc.cod_comunicado = :cod_comunicado ');
      Q.SQL.Add('   and tcu.cod_usuario_destinatario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(473, Self.ClassName, 'MarcarComoLido', [IntToStr(CodComunicado)]);
        Result := -473;
        Exit;
      End;

      // Abre Transação
      BeginTran;

      // Marca comunicado como lido armazenando-o no histórico e excluíndo-o da
      // tabela de comunicados não lidos (tab_comunicado_usuario)
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_historico_comunicado ');
      Q.SQL.Add('select cod_comunicado, ');
      Q.SQL.Add('       cod_usuario_destinatario, ');
      Q.SQL.Add('       getdate(), ');
      Q.SQL.Add('       ''S'' ');
      Q.SQL.Add('  from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_comunicado = :cod_comunicado ');
      Q.SQL.Add('   and cod_usuario_destinatario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_comunicado = :cod_comunicado ');
      Q.SQL.Add('   and cod_usuario_destinatario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      // Encerra transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(474, Self.ClassName, 'MarcarComoLido', [E.Message]);
        Result := -474;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.PesquisarNaoLidos(CodUsuario: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarNaoLidos');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(51) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarNaoLidos', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tc.cod_comunicado as CodComunicado, ');
  Query.SQL.Add('       tc.txt_assunto as TxtAssunto, ');
  Query.SQL.Add('       tc.dta_envio_comunicado as DtaEnvioComunicado, ');
  Query.SQL.Add('       tu.nom_usuario as NomUsuarioEnvio, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoaEnvio, ');
  Query.SQL.Add('       tc.ind_comunicado_importante as IndComunicadoImportante ');
  Query.SQL.Add('  from tab_comunicado tc, ');
  Query.SQL.Add('       tab_usuario tu, ');
  Query.SQL.Add('       tab_pessoa tp, ');
  Query.SQL.Add('       tab_comunicado_usuario tcu ');
  Query.SQL.Add(' where tu.cod_usuario = tc.cod_usuario_envio ');
  Query.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
  Query.SQL.Add('   and tcu.cod_comunicado = tc.cod_comunicado ');
  Query.SQL.Add('   and getdate() between tcu.dta_inicio_validade and tcu.dta_fim_validade ');
  Query.SQL.Add('   and tcu.cod_usuario_destinatario = :cod_usuario ');
  Query.SQL.Add(' order by tc.ind_comunicado_importante desc, tc.dta_envio_comunicado ');
{$ENDIF}
  Query.ParamByName('cod_usuario').AsInteger := CodUsuario;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(241, Self.ClassName, 'PesquisarNaoLidos', [E.Message]);
      Result := -241;
      Exit;
    End;
  End;
end;

function TIntComunicados.PesquisarHistorico(CodUsuario: Integer; DtaInicio,
  DtaFim: TDateTime): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarHistorico');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(52) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarHistorico', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tc.cod_comunicado as CodComunicado, ');
  Query.SQL.Add('       tc.txt_assunto as TxtAssunto, ');
  Query.SQL.Add('       tc.dta_envio_comunicado as DtaEnvioComunicado, ');
  Query.SQL.Add('       tu.nom_usuario as NomUsuarioEnvio, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoaEnvio, ');
  Query.SQL.Add('       tc.ind_comunicado_importante as IndComunicadoImportante, ');
  Query.SQL.Add('       thc.dta_arquivamento_comunicado as DtaArquivamentoComunicado, ');
  Query.SQL.Add('       case thc.ind_comunicado_lido ');
  Query.SQL.Add('         when ''S'' then convert(varchar(8), ''Lido'') ');
  Query.SQL.Add('         when ''N'' then convert(varchar(8), ''Expirado'') ');
  Query.SQL.Add('       end as DesSituacao, ');
  Query.SQL.Add('       thc.dta_arquivamento_comunicado as DtaLeitura ');
  Query.SQL.Add('  from tab_comunicado tc, ');
  Query.SQL.Add('       tab_usuario tu, ');
  Query.SQL.Add('       tab_pessoa tp, ');
  Query.SQL.Add('       tab_historico_comunicado thc ');
  Query.SQL.Add(' where tu.cod_usuario = tc.cod_usuario_envio ');
  Query.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
  Query.SQL.Add('   and thc.cod_comunicado = tc.cod_comunicado ');
  Query.SQL.Add('   and thc.cod_usuario_destinatario = :cod_usuario ');
  Query.SQL.Add('   and ((tc.dta_envio_comunicado between :dta_inicio and :dta_fim) or (:dta_inicio is null)) ');
  Query.SQL.Add(' order by tc.dta_envio_comunicado ');
{$ENDIF}
  Query.ParamByName('cod_usuario').AsInteger := CodUsuario;
  If DtaInicio = 0 Then Begin
    Query.ParamByName('dta_inicio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio').Clear;
    Query.ParamByName('dta_fim').DataType := ftDateTime;
    Query.ParamByName('dta_fim').Clear;
  End Else Begin
    Query.ParamByName('dta_inicio').AsDateTime := DtaInicio;
  End;
  If DtaFim = 0 Then Begin
    Query.ParamByName('dta_inicio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio').Clear;
    Query.ParamByName('dta_fim').DataType := ftDateTime;
    Query.ParamByName('dta_fim').Clear;
  End Else Begin
    Query.ParamByName('dta_fim').AsDateTime := DtaFim + EncodeTime(23, 59, 59, 0);
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(241, Self.ClassName, 'PesquisarHistorico', [E.Message]);
      Result := -241;
      Exit;
    End;
  End;
end;

function TIntComunicados.PesquisarDestinatarios(CodComunicado: Integer;
  IndComunicadoLido: WideString): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarDestinatarios');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(60) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarDestinatarios', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  If UpperCase(IndComunicadoLido) <> 'S' Then Begin
    Query.SQL.Add('select tcu.cod_usuario_destinatario as CodUsuarioDestinatario, ');
    Query.SQL.Add('       tu.nom_usuario as NomUsuarioDestinatario, ');
    Query.SQL.Add('       tu.cod_pessoa as CodPessoaDestinatario, ');
    Query.SQL.Add('       tp.nom_pessoa as NomPessoaDestinatario, ');
    Query.SQL.Add('       tu.cod_papel as CodPapelDestinatario, ');
    Query.SQL.Add('       tpap.des_papel as DesPapelDestinatario, ');
    Query.SQL.Add('       convert(varchar(8), ''Não Lido'') as DesSituacao, ');
    Query.SQL.Add('       convert(smalldatetime, null) as DtaLeitura ');
    Query.SQL.Add('  from tab_comunicado_usuario tcu, ');
    Query.SQL.Add('       tab_usuario tu, ');
    Query.SQL.Add('       tab_pessoa tp, ');
    Query.SQL.Add('       tab_papel tpap ');
    Query.SQL.Add(' where tu.cod_usuario = tcu.cod_usuario_destinatario ');
    Query.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
    Query.SQL.Add('   and tpap.cod_papel = tu.cod_papel ');
    Query.SQL.Add('   and tcu.cod_comunicado = :cod_comunicado ');
  End;
  If (UpperCase(IndComunicadoLido) <> 'S') And
     (UpperCase(IndComunicadoLido) <> 'N') Then Begin
    Query.SQL.Add('union ');
  End;
  Query.SQL.Add('select thc.cod_usuario_destinatario as CodUsuarioDestinatario, ');
  Query.SQL.Add('       tu.nom_usuario as NomUsuarioDestinatario, ');
  Query.SQL.Add('       tu.cod_pessoa as CodPessoaDestinatario, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoaDestinatario, ');
  Query.SQL.Add('       tu.cod_papel as CodPapelDestinatario, ');
  Query.SQL.Add('       tpap.des_papel as DesPapelDestinatario, ');
  Query.SQL.Add('       case thc.ind_comunicado_lido ');
  Query.SQL.Add('         when ''S'' then convert(varchar(8), ''Lido'') ');
  Query.SQL.Add('         when ''N'' then convert(varchar(8), ''Expirado'') ');
  Query.SQL.Add('       end as DesSituacao, ');
  Query.SQL.Add('       case thc.ind_comunicado_lido ');
  Query.SQL.Add('         when ''S'' then thc.dta_arquivamento_comunicado ');
  Query.SQL.Add('         when ''N'' then convert(smalldatetime, null) ');
  Query.SQL.Add('       end as DtaLeitura ');
  Query.SQL.Add('  from tab_historico_comunicado thc, ');
  Query.SQL.Add('       tab_usuario tu, ');
  Query.SQL.Add('       tab_pessoa tp, ');
  Query.SQL.Add('       tab_papel tpap ');
  Query.SQL.Add(' where tu.cod_usuario = thc.cod_usuario_destinatario ');
  Query.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
  Query.SQL.Add('   and tpap.cod_papel = tu.cod_papel ');
  If UpperCase(IndComunicadoLido) = 'S' Then Begin
    Query.SQL.Add('and thc.ind_comunicado_lido = ''S'' ');
  End;
  If UpperCase(IndComunicadoLido) = 'N' Then Begin
    Query.SQL.Add('and thc.ind_comunicado_lido = ''N'' ');
  End;
  Query.SQL.Add('   and thc.cod_comunicado = :cod_comunicado ');
  Query.SQL.Add(' order by 2 ');
{$ENDIF}
  Query.ParamByName('cod_comunicado').AsInteger := CodComunicado;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(241, Self.ClassName, 'PesquisarDestinatarios', [E.Message]);
      Result := -241;
      Exit;
    End;
  End;
end;

function TIntComunicados.PesquisarEnviados(CodUsuarioEnvio: Integer;
  DtaInicio, DtaFim: TDateTime): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarEnviados');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(60) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarEnviados', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_comunicado as CodComunicado, ');
  Query.SQL.Add('       txt_assunto as TxtAssunto, ');
  Query.SQL.Add('       dta_envio_comunicado as DtaEnvioComunicado, ');
  Query.SQL.Add('       ind_comunicado_importante as IndComunicadoImportante ');
  Query.SQL.Add('  from tab_comunicado ');
  Query.SQL.Add(' where cod_usuario_envio = :cod_usuario ');
  Query.SQL.Add('   and ((dta_envio_comunicado between :dta_inicio and :dta_fim) or (:dta_inicio is null)) ');
  Query.SQL.Add(' order by dta_envio_comunicado ');
{$ENDIF}
  Query.ParamByName('cod_usuario').AsInteger := CodUsuarioEnvio;
  If DtaInicio = 0 Then Begin
    Query.ParamByName('dta_inicio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio').Clear;
    Query.ParamByName('dta_fim').DataType := ftDateTime;
    Query.ParamByName('dta_fim').Clear;
  End Else Begin
    Query.ParamByName('dta_inicio').AsDateTime := DtaInicio;
  End;
  If DtaFim = 0 Then Begin
    Query.ParamByName('dta_inicio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio').Clear;
    Query.ParamByName('dta_fim').DataType := ftDateTime;
    Query.ParamByName('dta_fim').Clear;
  End Else Begin
    Query.ParamByName('dta_fim').AsDateTime := DtaFim + EncodeTime(23, 59, 59, 0);
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(241, Self.ClassName, 'PesquisarEnviados', [E.Message]);
      Result := -241;
      Exit;
    End;
  End;
end;

function TIntComunicados.BuscarRecebido(CodComunicado,
  CodUsuarioDestinatario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BuscarRecebido');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(63) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'BuscarRecebido', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tc.cod_comunicado, ');
      Q.SQL.Add('       tc.txt_assunto, ');
      Q.SQL.Add('       tc.txt_comunicado, ');
      Q.SQL.Add('       tc.dta_inicio_validade, ');
      Q.SQL.Add('       tc.dta_fim_validade, ');
      Q.SQL.Add('       tc.dta_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_envio, ');
      Q.SQL.Add('       tu.nom_usuario, ');
      Q.SQL.Add('       tp.cod_pessoa, ');
      Q.SQL.Add('       tu.cod_papel, ');
      Q.SQL.Add('       tpap.des_papel, ');
      Q.SQL.Add('       tc.cod_opcao_envio_comunicado, ');
      Q.SQL.Add('       toec.des_opcao_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_opcao_envio, ');
      Q.SQL.Add('       tuoe.nom_usuario as nom_usuario_opcao_envio, ');
      Q.SQL.Add('       tc.cod_pessoa_opcao_envio, ');
      Q.SQL.Add('       tc.cod_papel_opcao_envio, ');
      Q.SQL.Add('       tpoe.des_papel as des_papel_opcao_envio, ');
      Q.SQL.Add('       convert(varchar(8), ''Não Lido'') as DesSituacao, ');
      Q.SQL.Add('       convert(smalldatetime, null) as DtaLeitura ');
      Q.SQL.Add('  from tab_comunicado tc, ');
      Q.SQL.Add('       tab_comunicado_usuario tcu, ');
      Q.SQL.Add('       tab_usuario tu, ');
      Q.SQL.Add('       tab_pessoa tp, ');
      Q.SQL.Add('       tab_opcao_envio_comunicado toec, ');
      Q.SQL.Add('       tab_papel tpap, ');
      Q.SQL.Add('       tab_usuario tuoe, ');
      Q.SQL.Add('       tab_papel tpoe ');
      Q.SQL.Add(' where tcu.cod_comunicado = tc.cod_comunicado ');
      Q.SQL.Add('   and tu.cod_usuario = tc.cod_usuario_envio ');
      Q.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
      Q.SQL.Add('   and toec.cod_papel = tc.cod_papel ');
      Q.SQL.Add('   and toec.cod_opcao_envio_comunicado = tc.cod_opcao_envio_comunicado ');
      Q.SQL.Add('   and tpap.cod_papel = tu.cod_papel ');
      Q.SQL.Add('   and tuoe.cod_usuario =* tc.cod_usuario_opcao_envio ');
      Q.SQL.Add('   and tpoe.cod_papel =* tc.cod_papel_opcao_envio ');
      Q.SQL.Add('   and tcu.cod_comunicado = :cod_comunicado ');
      Q.SQL.Add('   and tcu.cod_usuario_destinatario = :cod_usuario_destinatario ');
      Q.SQL.Add('union ');
      Q.SQL.Add('select tc.cod_comunicado, ');
      Q.SQL.Add('       tc.txt_assunto, ');
      Q.SQL.Add('       tc.txt_comunicado, ');
      Q.SQL.Add('       tc.dta_inicio_validade, ');
      Q.SQL.Add('       tc.dta_fim_validade, ');
      Q.SQL.Add('       tc.dta_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_envio, ');
      Q.SQL.Add('       tu.nom_usuario, ');
      Q.SQL.Add('       tp.cod_pessoa, ');
      Q.SQL.Add('       tu.cod_papel, ');
      Q.SQL.Add('       tpap.des_papel, ');
      Q.SQL.Add('       tc.cod_opcao_envio_comunicado, ');
      Q.SQL.Add('       toec.des_opcao_envio_comunicado, ');
      Q.SQL.Add('       tc.cod_usuario_opcao_envio, ');
      Q.SQL.Add('       tuoe.nom_usuario as nom_usuario_opcao_envio, ');
      Q.SQL.Add('       tc.cod_pessoa_opcao_envio, ');
      Q.SQL.Add('       tc.cod_papel_opcao_envio, ');
      Q.SQL.Add('       tpoe.des_papel as des_papel_opcao_envio, ');
      Q.SQL.Add('       case thc.ind_comunicado_lido ');
      Q.SQL.Add('         when ''S'' then convert(varchar(8), ''Lido'') ');
      Q.SQL.Add('         when ''N'' then convert(varchar(8), ''Expirado'') ');
      Q.SQL.Add('       end as DesSituacao, ');
      Q.SQL.Add('       case thc.ind_comunicado_lido ');
      Q.SQL.Add('         when ''S'' then thc.dta_arquivamento_comunicado ');
      Q.SQL.Add('         when ''N'' then convert(smalldatetime, null) ');
      Q.SQL.Add('       end as DtaLeitura ');
      Q.SQL.Add('  from tab_comunicado tc, ');
      Q.SQL.Add('       tab_historico_comunicado thc, ');
      Q.SQL.Add('       tab_usuario tu, ');
      Q.SQL.Add('       tab_pessoa tp, ');
      Q.SQL.Add('       tab_opcao_envio_comunicado toec, ');
      Q.SQL.Add('       tab_papel tpap, ');
      Q.SQL.Add('       tab_usuario tuoe, ');
      Q.SQL.Add('       tab_papel tpoe ');
      Q.SQL.Add(' where thc.cod_comunicado = tc.cod_comunicado ');
      Q.SQL.Add('   and tu.cod_usuario = tc.cod_usuario_envio ');
      Q.SQL.Add('   and tp.cod_pessoa = tu.cod_pessoa ');
      Q.SQL.Add('   and tpap.cod_papel = tu.cod_papel ');
      Q.SQL.Add('   and toec.cod_papel = tc.cod_papel ');
      Q.SQL.Add('   and toec.cod_opcao_envio_comunicado = tc.cod_opcao_envio_comunicado ');
      Q.SQL.Add('   and tuoe.cod_usuario =* tc.cod_usuario_opcao_envio ');
      Q.SQL.Add('   and tpoe.cod_papel =* tc.cod_papel_opcao_envio ');
      Q.SQL.Add('   and thc.cod_comunicado = :cod_comunicado ');
      Q.SQL.Add('   and thc.cod_usuario_destinatario = :cod_usuario_destinatario ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ParamByName('cod_usuario_destinatario').AsInteger := CodUsuarioDestinatario;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(239, Self.ClassName, 'BuscarRecebido', [IntToStr(CodComunicado)]);
        Result := -239;
        Exit;
      End;

      // Obtem informações do registro
      FIntComunicado.CodComunicado       := Q.FieldbyName('cod_comunicado').AsInteger;
      FIntComunicado.TxtAssunto          := Q.FieldbyName('txt_assunto').AsString;
      FIntComunicado.TxtComunicado       := Q.FieldbyName('txt_comunicado').AsString;
      FIntComunicado.DtaInicioValidade   := Q.FieldbyName('dta_inicio_validade').AsDateTime;
      FIntComunicado.DtaFimValidade      := Q.FieldbyName('dta_fim_validade').AsDateTime;
      FIntComunicado.DtaEnvioComunicado  := Q.FieldbyName('dta_envio_comunicado').AsDateTime;
      FIntComunicado.CodUsuarioEnvio     := Q.FieldbyName('cod_usuario_envio').AsInteger;
      FIntComunicado.NomUsuarioEnvio     := Q.FieldbyName('nom_usuario').AsString;
      FIntComunicado.PessoaEnvio.CarregaPropriedades(Q.FieldbyName('cod_pessoa').AsInteger, Conexao, Mensagens);
      FIntComunicado.CodPapelEnvio       := Q.FieldbyName('cod_papel').AsInteger;
      FIntComunicado.DesPapelEnvio       := Q.FieldbyName('des_papel').AsString;
      FIntComunicado.CodOpcaoEnvio       := Q.FieldbyName('cod_opcao_envio_comunicado').AsInteger;
      FIntComunicado.DesOpcaoEnvio       := Q.FieldbyName('des_opcao_envio_comunicado').AsString;
      FIntComunicado.CodUsuarioOpcaoEnvio     := Q.FieldbyName('cod_usuario_opcao_envio').AsInteger;
      FIntComunicado.NomUsuarioOpcaoEnvio     := Q.FieldbyName('nom_usuario_opcao_envio').AsString;
      If Not Q.FieldbyName('cod_pessoa_opcao_envio').IsNull Then Begin
        FIntComunicado.PessoaOpcaoEnvio.CarregaPropriedades(Q.FieldbyName('cod_pessoa_opcao_envio').AsInteger, Conexao, Mensagens);
      End;
      FIntComunicado.CodPapelOpcaoEnvio       := Q.FieldbyName('cod_papel_opcao_envio').AsInteger;
      FIntComunicado.DesPapelOpcaoEnvio       := Q.FieldbyName('des_papel_opcao_envio').AsString;
      FIntComunicado.DesSituacao         := Q.FieldbyName('DesSituacao').AsString;
      FIntComunicado.DtaLeitura          := Q.FieldbyName('DtaLeitura').AsDatetime;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(240, Self.ClassName, 'BuscarRecebido', [E.Message]);
        Result := -240;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.ConsisteDadosComunicado(CodUsuario: Integer;TxtAssunto,
  TxtComunicado: String; DtaInicioValidade,
  DtaFimValidade: TDateTime; NomeMetodo: String;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  DtaSistema : TDateTime;
begin
  // Consiste Texto do assunto
  If TxtAssunto = '' Then Begin
    Mensagens.Adicionar(284, Self.ClassName, NomeMetodo, []);
    Result := -284;
    Exit;
  End;

  Result := TrataString(TxtAssunto, 255, 'Assunto do comunicado');
  If Result < 0 Then Exit;

  // Consiste Texto do comunicado
  If TxtComunicado = '' Then Begin
    Mensagens.Adicionar(285, Self.ClassName, NomeMetodo, []);
    Result := -285;
    Exit;
  End;

  Result := TrataString(TxtComunicado, 255, 'Texto do comunicado');
  If Result < 0 Then Exit;

  // Consiste data início de validade
  If DtaInicioValidade = 0 Then Begin
    Mensagens.Adicionar(286, Self.ClassName, NomeMetodo, []);
    Result := -286;
    Exit;
  End;

  // Consiste data fim de validade
  If DtaFimValidade = 0 Then Begin
    Mensagens.Adicionar(287, Self.ClassName, NomeMetodo, []);
    Result := -287;
    Exit;
  End;

  // Consiste data fim de validade
  If DtaFimValidade < DtaInicioValidade Then Begin
    Mensagens.Adicionar(288, Self.ClassName, NomeMetodo, []);
    Result := -288;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Obtem data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;

      DtaSistema := Trunc(Q.FieldByName('dta_sistema').AsDateTime);

      // Verifica se data de validade é válida
      If DtaFimValidade < DtaSistema Then Begin
        Mensagens.Adicionar(289, Self.ClassName, NomeMetodo, []);
        Result := -289;
        Exit;
      End;

      // Verifica se opção envio existe
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_opcao_envio_comunicado ');
      Q.SQL.Add(' where cod_papel = :cod_papel ');
      Q.SQL.Add('   and cod_opcao_envio_comunicado = :cod_opcao_envio_comunicado ');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_opcao_envio_comunicado').AsInteger := CodOpcaoEnvioComunicado;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(460, Self.ClassName, NomeMetodo, [IntToStr(CodOpcaoEnvioComunicado)]);
        Result := -460;
        Exit;
      End;

      // Verifica se usuário existe
      If CodUsuario > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select cod_usuario ');
        Q.SQL.Add('  from tab_usuario ');
        Q.SQL.Add(' where cod_usuario = :cod_usuario ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
        Q.Open;

        // Verifica existência do registro
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(209, Self.ClassName, NomeMetodo, [IntToStr(CodUsuario)]);
          Result := -209;
          Exit;
        End;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(290, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -290;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntComunicados.FinalizarComunicado(
  CodComunicado: Integer): Integer;
var
  Q : THerdomQuery;
  DtaFimValidade, DtaSistema : TDateTime;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('FinalizarComunicado');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(62) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'FinalizarComunicado', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Verifica existência do comunicado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tc.dta_fim_validade, getdate() as dta_sistema ');
      Q.SQL.Add('  from tab_comunicado tc  ');
      Q.SQL.Add(' where tc.cod_comunicado = :cod_comunicado ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(239, Self.ClassName, 'FinalizarComunicado', [IntToStr(CodComunicado)]);
        Result := -239;
        Exit;
      End;
      DtaFimValidade := Q.FieldByName('dta_fim_validade').AsDateTime;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;

      If DtaFimValidade < DtaSistema Then Begin
        Mensagens.Adicionar(475, Self.ClassName, 'FinalizarComunicado', [IntToStr(CodComunicado)]);
        Result := -475;
        Exit;
      End;

      // Abre Transação
      BeginTran;

      // Finaliza Comunicado
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_comunicado  ');
      Q.SQL.Add('   set dta_fim_validade = :dta_fim_validade ');
      Q.SQL.Add(' where cod_comunicado = :cod_comunicado ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ExecSQL;

      // Finaliza Comunicados enviados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_comunicado_usuario  ');
      Q.SQL.Add('   set dta_fim_validade = :dta_fim_validade ');
      Q.SQL.Add(' where cod_comunicado = :cod_comunicado ');
{$ENDIF}
      Q.ParamByName('cod_comunicado').AsInteger := CodComunicado;
      Q.ExecSQL;

      // Encerra transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(476, Self.ClassName, 'FinalizarComunicado', [E.Message]);
        Result := -476;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

