unit uVisita;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, Sysutils, uConexao, uFerramentas, IniFiles,
  uIntMensagens, uMensagens, uMensagem, uBannersVisita,uAnimaisVisita;

const
  ARQUIVO_INI = 'herdom.ini';

type
  TVisita = class(TASPMTSObject, IVisita)
  private
    FConexao : TConexao;
    FMensagens : TIntMensagens;
    FAtiva : Boolean;
    FBannersVisita : TBannersVisita;
    FAnimaisVisita : TAnimaisVisita;
  protected
    function Inicializar(const IdCertificadora: WideString): Integer; safecall;
    function Mensagens: IDispatch; safecall;
    function Get_Ativa: WordBool; safecall;
    procedure FinalizarTudo; safecall;
    function InicializarBannersVisita: Integer; safecall;
    procedure FinalizarBannersVisita; safecall;
    function Get_BannersVisita: IBannersVisita; safecall;
    procedure Finalizar; safecall;
    function Get_AnimaisVisita: IAnimaisVisita; safecall;
    function InicializarAnimaisVisita: Integer; safecall;
    procedure FinalizarAnimaisVisita; safecall;
  public
    procedure AfterConstruction; override;  // declarada nesta unit
    procedure BeforeDestruction; override;  // declarada nesta unit
  end;

implementation

uses ComServ;

{TVisita}
procedure TVisita.AfterConstruction;
begin
  inherited;
  FAtiva := False;
end;

procedure TVisita.BeforeDestruction;
begin
  inherited;
End;

function TVisita.Inicializar(const IdCertificadora: WideString): Integer;
var
  FIni : TIniFile;
  Ret : TConectar;
  GerarLog: Boolean;
  X, NivelLog, LockTimeOut, QueryGovernorCostLimit : Integer;
  ServerName, Banco, UserName, Password: String;
begin
  If FAtiva Then Begin
    Result := 0;
    Exit;
  End;

  Result := -1;

  // Cria objetos de conexão e mensagens se ainda não foram criados
  If FConexao = nil Then Begin
    FConexao := TConexao.Create;
  End;
  If FMensagens = nil Then Begin
    FMensagens := TIntMensagens.Create(TIntMensagem);
  End;

  // Limpa coleção de mensagens
  FMensagens.Clear;

  // Abre arquivo ini
  FIni := TIniFile.Create(ARQUIVO_INI);
  Try
    Try
      // Verifica Sessão e Valores para a Certificadora
      If (Not FIni.SectionExists(IdCertificadora)) or
         (Not FIni.ValueExists(IdCertificadora, 'SERVIDOR')) or
         (Not FIni.ValueExists(IdCertificadora, 'BANCO')) or
         (Not FIni.ValueExists(IdCertificadora, 'USUARIO_V')) or
         (Not FIni.ValueExists(IdCertificadora, 'SENHA_V')) or
         (Not FIni.ValueExists(IdCertificadora, 'GERAR_LOG')) or
         (Not FIni.ValueExists(IdCertificadora, 'ARQUIVO_LOG')) or
         (Not FIni.ValueExists(IdCertificadora, 'NIVEL_LOG')) Then Begin
        FMensagens.Adicionar(1, Self.ClassName, 'Inicializar', [IdCertificadora]);
        Exit;
      End;

      // Obtem informações para log do arquivo .ini
      GerarLog := FIni.ReadBool(IdCertificadora, 'GERAR_LOG', True);
      NivelLog := FIni.ReadInteger(IdCertificadora, 'NIVEL_LOG', 3);

      // Obtem dados para conexão do arquivo .ini
      ServerName := Descriptografar(FIni.ReadString(IdCertificadora, 'SERVIDOR', ''));
      Banco      := Descriptografar(FIni.ReadString(IdCertificadora, 'BANCO', ''));
      UserName   := Descriptografar(FIni.ReadString(IdCertificadora, 'USUARIO_V', ''));
      Password   := Descriptografar(FIni.ReadString(IdCertificadora, 'SENHA_V', ''));
      LockTimeOut := FIni.ReadInteger(IdCertificadora, 'LOCK_TIMEOUT', -1);
      If LockTimeOut = -1 Then Begin
        LockTimeOut := 15;
        FIni.WriteInteger(IdCertificadora, 'LOCK_TIMEOUT', LockTimeOut);
      End;
      QueryGovernorCostLimit := FIni.ReadInteger(IdCertificadora, 'QUERY_GOVERNOR_COST_LIMIT', -1);
      If QueryGovernorCostLimit = -1 Then Begin
        QueryGovernorCostLimit := 90;
        FIni.WriteInteger(IdCertificadora, 'QUERY_GOVERNOR_COST_LIMIT', QueryGovernorCostLimit);
      End;

      // Tenta conexão com o banco
      Ret := FConexao.Conectar(ServerName, UserName, Password, Banco, 'V_'+Trim(UpperCase(IdCertificadora)), LockTimeOut, QueryGovernorCostLimit);

      If Ret.Status <> 0 Then Begin
        Case Ret.Status of
          // Erro de conexão
          -1 : Begin
//                 FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', ['-1']);
                 For X := 0 to Ret.Erros.Count - 1 do Begin
                   FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', [Ret.Erros[X].Texto]);
                 End;
               End;

          // Erro de acesso ao database padrão
          -2 : Begin
//                 FMensagens.Adicionar(12, Self.ClassName, 'Inicializar', ['-2']);
                 For X := 0 to Ret.Erros.Count - 1 do Begin
                   FMensagens.Adicionar(12, Self.ClassName, 'Inicializar', [Ret.Erros[X].Texto]);
                 End;
               End;
        End;
        Exit;
      End;

      // Inicializa Objeto Mensagens
      If FMensagens.Inicializar(FConexao,
                                GerarLog,
                                FIni.ReadString(IdCertificadora, 'ARQUIVO_LOG', ''),
                                NivelLog) < 0 Then Begin
        FMensagens.Adicionar(8, Self.ClassName, 'Inicializar', ['FMensagens']);
        Result := -1;
        Exit;
      End;

      FAtiva := True;
      Result := 0;
    Except
      On E: Exception do Begin
        FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', [E.Message]);
      End;
    End;
  Finally
    FIni.Free;
  End;
end;

function TVisita.Mensagens: IDispatch;
var
  Items: TMensagens;
  X : Integer;
begin
  Items := TMensagens.Create;
  For X := 0 to FMensagens.Count - 1 do Begin
    Items.Adicionar(FMensagens[X].Codigo,
                    FMensagens[X].Texto,
                    FMensagens[X].Classe,
                    FMensagens[X].Metodo,
                    FMensagens[X].Tipo);
  End;
  Result := Items as IDispatch;
end;

function TVisita.Get_Ativa: WordBool;
begin
  Result := FAtiva;
end;

procedure TVisita.FinalizarTudo;
begin
  // Finaliza qualquer objeto que tenha sido inicializado
  FinalizarBannersVisita;
  FinalizarAnimaisVisita;
end;

function TVisita.InicializarBannersVisita: Integer;
begin
  // Limpa mensagens
  FMensagens.Clear;

  // Verifica se Visita está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarBannersVisita', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza BannersVisita (só finaliza se já houver sido inicializado)
  FinalizarBannersVisita;
  FBannersVisita := TBannersVisita.Create;
  FBannersVisita.ObjAddRef;
  Result := FBannersVisita.Inicializar(FConexao, FMensagens);
end;

procedure TVisita.FinalizarBannersVisita;
begin
  If FBannersVisita <> nil Then Begin
    FBannersVisita.ObjRelease;
    FBannersVisita := nil;
  End;
end;

function TVisita.Get_BannersVisita: IBannersVisita;
begin
  Result := FBannersVisita;
end;

procedure TVisita.Finalizar;
begin
  If FMensagens <> nil Then Begin
    FMensagens.Free;
    FMensagens := nil;
  End;
  If FConexao <> nil Then Begin
    FConexao.Free;
    FConexao := nil;
  End;
  FAtiva := False;
end;

function TVisita.Get_AnimaisVisita: IAnimaisVisita;
begin
  Result := FAnimaisVisita;
end;

function TVisita.InicializarAnimaisVisita: Integer;
begin
  // Limpa mensagens
  FMensagens.Clear;

  // Verifica se Visita está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAnimaisVisita', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza AnimaisVisita (só finaliza se já houver sido inicializado)
  FinalizarAnimaisVisita;
  FAnimaisVisita := TAnimaisVisita.Create;
  FAnimaisVisita.ObjAddRef;
  Result := FAnimaisVisita.Inicializar(FConexao, FMensagens);
end;

procedure TVisita.FinalizarAnimaisVisita;
begin
  If FAnimaisVisita <> nil Then Begin
    FAnimaisVisita.ObjRelease;
    FAnimaisVisita := nil;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TVisita, Class_Visita,
    ciMultiInstance, tmApartment);
end.
