unit uIntMotivosBloqueio;

{$DEFINE MSSQL}

interface

uses dbtables, sysutils, db, uIntClassesBasicas, uIntMotivoBloqueio;

type
  { TIntMotivosBloqueio }
  TIntMotivosBloqueio = class(TIntClasseBDLeituraBasica)
  private
    FIntMotivoBloqueio : TIntMotivoBloqueio;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodAplicacaoBloqueio,
      IndRestritoSistema: String): Integer;
    function Buscar(CodMotivoBloqueio: Integer): Integer;
    function Alterar(CodMotivoBloqueio: Integer; TxtMotivoUsuario,
      TxtObservacao, TxtProcedimentoUsuario: String): Integer;

    property IntMotivoBloqueio : TIntMotivoBloqueio read FIntMotivoBloqueio write FIntMotivoBloqueio;
  end;

implementation

{ TIntMotivosBloqueio }
function TIntMotivosBloqueio.Alterar(CodMotivoBloqueio: Integer;
  TxtMotivoUsuario, TxtObservacao,
  TxtProcedimentoUsuario: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(80) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se pelo menos um parâmetro foi informado
  If (TxtMotivoUsuario = '') and
     (TxtObservacao = '') and
     (TxtProcedimentoUsuario = '') Then Begin
    Mensagens.Adicionar(215, Self.ClassName, 'Alterar', []);
    Result := -215;
    Exit;
  End;

  If TxtMotivoUsuario <> '' Then Begin
    Result := TrataString(TxtMotivoUsuario, 255, 'Motivo do usuário');
    If Result < 0 then Exit;
  End;

  If TxtObservacao <> '' Then Begin
    Result := TrataString(TxtObservacao, 255, 'Observação do usuário');
    If Result < 0 then Exit;
  End;

  If TxtProcedimentoUsuario <> '' Then Begin
    Result := TrataString(TxtProcedimentoUsuario, 255, 'Procedimento do usuário');
    If Result < 0 then Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro e pega cod_registro_log do mesmo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_motivo_bloqueio ');
      Q.SQL.Add(' where cod_motivo_bloqueio = :cod_motivo_bloqueio ');
{$ENDIF}
      Q.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(280, Self.ClassName, 'Alterar', [IntToStr(CodMotivoBloqueio)]);
        Result := -280;
        Exit;
      End;
      Q.Close;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_motivo_bloqueio ');
      Q.SQL.Add('   set ');
      If TxtMotivoUsuario <> '' Then Begin
        Q.SQL.Add('   txt_motivo_usuario = :txt_motivo_usuario,');
      End;
      If TxtObservacao <> '' Then Begin
        Q.SQL.Add('   txt_observacao_usuario = :txt_observacao_usuario,');
      End;
      If TxtProcedimentoUsuario <> '' Then Begin
        Q.SQL.Add('   txt_procedimento_usuario = :txt_procedimento_usuario,');
      End;

      // Pra tirar a merda de vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_motivo_bloqueio = :cod_motivo_bloqueio ');
{$ENDIF}
      If TxtMotivoUsuario <> '' Then Begin
        Q.ParamByName('txt_motivo_usuario').AsString       := TxtMotivoUsuario;
      End;
      If TxtObservacao <> '' Then Begin
        Q.ParamByName('txt_observacao_usuario').AsString   := TxtObservacao;
      End;
      If TxtProcedimentoUsuario <> '' Then Begin
        Q.ParamByName('txt_procedimento_usuario').AsString := TxtProcedimentoUsuario;
      End;
      Q.ParamByName('cod_motivo_bloqueio').AsInteger       := CodMotivoBloqueio;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(281, Self.ClassName, 'Alterar', [E.Message]);
        Result := -281;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntMotivosBloqueio.Buscar(CodMotivoBloqueio: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(79) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tmb.cod_motivo_bloqueio, ');
      Q.SQL.Add('       tmb.des_motivo_bloqueio, ');
      Q.SQL.Add('       tmb.txt_motivo_usuario, ');
      Q.SQL.Add('       tmb.txt_observacao_usuario, ');
      Q.SQL.Add('       tmb.txt_procedimento_usuario, ');
      Q.SQL.Add('       tmb.cod_aplicacao_bloqueio, ');
      Q.SQL.Add('       tab.des_aplicacao_bloqueio, ');
      Q.SQL.Add('       tmb.ind_restrito_sistema ');
      Q.SQL.Add('  from tab_motivo_bloqueio tmb, ');
      Q.SQL.Add('       tab_aplicacao_bloqueio tab ');
      Q.SQL.Add(' where tab.cod_aplicacao_bloqueio = tmb.cod_aplicacao_bloqueio ');
      Q.SQL.Add('   and tmb.cod_motivo_bloqueio = :cod_motivo_bloqueio ');
{$ENDIF}
      Q.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(280, Self.ClassName, 'Buscar', []);
        Result := -280;
        Exit;
      End;

      // Obtem informações do registro
      FIntMotivoBloqueio.CodMotivoBloqueio      := Q.FieldByName('cod_motivo_bloqueio').AsInteger;
      FIntMotivoBloqueio.DesMotivoBloqueio      := Q.FieldByName('des_motivo_bloqueio').AsString;
      FIntMotivoBloqueio.TxtMotivoUsuario       := Q.FieldByName('txt_motivo_usuario').AsString;
      FIntMotivoBloqueio.TxtObservacaoUsuario   := Q.FieldByName('txt_observacao_usuario').AsString;
      FIntMotivoBloqueio.TxtProcedimentoUsuario := Q.FieldByName('txt_procedimento_usuario').AsString;
      FIntMotivoBloqueio.CodAplicacaoBloqueio   := Q.FieldByName('cod_aplicacao_bloqueio').AsString;
      FIntMotivoBloqueio.DesAplicacaoBloqueio   := Q.FieldByName('des_aplicacao_bloqueio').AsString;
      FIntMotivoBloqueio.IndRestritoSistema     := Q.FieldByName('ind_restrito_sistema').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(282, Self.ClassName, 'Buscar', [E.Message]);
        Result := -282;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

constructor TIntMotivosBloqueio.Create;
begin
  inherited;
  FIntMotivoBloqueio := TIntMotivoBloqueio.Create;
end;

destructor TIntMotivosBloqueio.Destroy;
begin
  FIntMotivoBloqueio.Free;
  inherited;
end;

function TIntMotivosBloqueio.Pesquisar(CodAplicacaoBloqueio,
  IndRestritoSistema: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(78) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tmb.cod_motivo_bloqueio as CodMotivoBloqueio, ');
  Query.SQL.Add('       tmb.des_motivo_bloqueio as DesMotivoBloqueio, ');
  Query.SQL.Add('       tmb.cod_aplicacao_bloqueio as CodAplicacaoBloqueio, ');
  Query.SQL.Add('       tab.des_aplicacao_bloqueio as DesAplicacaoBloqueio, ');
  Query.SQL.Add('       tmb.ind_restrito_sistema as IndRestritoSistema ');
  Query.SQL.Add('  from tab_motivo_bloqueio tmb, ');
  Query.SQL.Add('       tab_aplicacao_bloqueio tab ');
  Query.SQL.Add(' where tab.cod_aplicacao_bloqueio = tmb.cod_aplicacao_bloqueio ');
  Query.SQL.Add('   and tmb.cod_aplicacao_bloqueio = :cod_aplicacao_bloqueio ');
  If (UpperCase(IndRestritoSistema) = 'S') or (UpperCase(IndRestritoSistema) = 'N') Then Begin
    Query.SQL.Add('   and tmb.ind_restrito_sistema = :ind_restrito_sistema ');
  End;  
  Query.SQL.Add(' order by tmb.des_motivo_bloqueio ');
{$ENDIF}
  Query.ParamByName('cod_aplicacao_bloqueio').AsString := CodAplicacaoBloqueio;
  If (UpperCase(IndRestritoSistema) = 'S') or (UpperCase(IndRestritoSistema) = 'N') Then Begin
    Query.ParamByName('ind_restrito_sistema').AsString := IndRestritoSistema;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(279, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -279;
      Exit;
    End;
  End;
end;

end.

