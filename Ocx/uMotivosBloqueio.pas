unit uMotivosBloqueio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uMotivoBloqueio,
  uIntMotivosBloqueio;

type
  TMotivosBloqueio = class(TASPMTSObject, IMotivosBloqueio)
  private
    FIntMotivosBloqueio : TIntMotivosBloqueio;
    FInicializado : Boolean;
    FMotivoBloqueio: TMotivoBloqueio;
  protected
    function EOF: WordBool; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    function Pesquisar(const CodAplicacaoBloqueio,
      IndRestritoSistema: WideString): Integer; safecall;
    procedure FecharPesquisa; safecall;
    function Buscar(CodMotivoBloqueio: Integer): Integer; safecall;
    function Alterar(CodMotivoBloqueio: Integer; const TxtMotivoUsuario,
      TxtObservacao, TxtProcedimentoUsuario: WideString): Integer;
      safecall;
    function Get_MotivoBloqueio: IMotivoBloqueio; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TMotivosBloqueio.AfterConstruction;
begin
  inherited;
  FMotivoBloqueio := TMotivoBloqueio.Create;
  FMotivoBloqueio.ObjAddRef;
  FInicializado := False;
end;

procedure TMotivosBloqueio.BeforeDestruction;
begin
  If FIntMotivosBloqueio <> nil Then Begin
    FIntMotivosBloqueio.Free;
  End;
  If FMotivoBloqueio <> nil Then Begin
    FMotivoBloqueio.ObjRelease;
    FMotivoBloqueio := nil;
  End;
  inherited;
end;

function TMotivosBloqueio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntMotivosBloqueio := TIntMotivosBloqueio.Create;
  Result := FIntMotivosBloqueio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TMotivosBloqueio.EOF: WordBool;
begin
  Result := FIntMotivosBloqueio.EOF;
end;

procedure TMotivosBloqueio.IrAoProximo;
begin
  FIntMotivosBloqueio.IrAoProximo;
end;

function TMotivosBloqueio.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntMotivosBloqueio.ValorCampo(NomeColuna);
end;

function TMotivosBloqueio.Pesquisar(const CodAplicacaoBloqueio,
  IndRestritoSistema: WideString): Integer;
begin
  Result := FIntMotivosBloqueio.Pesquisar(CodAplicacaoBloqueio, IndRestritoSistema);
end;

procedure TMotivosBloqueio.FecharPesquisa;
begin
  FIntMotivosBloqueio.FecharPesquisa;
end;

function TMotivosBloqueio.Buscar(CodMotivoBloqueio: Integer): Integer;
begin
  Result := FIntMotivosBloqueio.Buscar(CodMotivoBloqueio);
end;

function TMotivosBloqueio.Alterar(CodMotivoBloqueio: Integer;
  const TxtMotivoUsuario, TxtObservacao,
  TxtProcedimentoUsuario: WideString): Integer;
begin
  Result := FIntMotivosBloqueio.Alterar(CodMotivoBloqueio, TxtMotivoUsuario,
    TxtObservacao, TxtProcedimentoUsuario);
end;

function TMotivosBloqueio.Get_MotivoBloqueio: IMotivoBloqueio;
begin
  FMotivoBloqueio.CodMotivoBloqueio      := FIntMotivosBloqueio.IntMotivoBloqueio.CodMotivoBloqueio;
  FMotivoBloqueio.DesMotivoBloqueio      := FIntMotivosBloqueio.IntMotivoBloqueio.DesMotivoBloqueio;
  FMotivoBloqueio.TxtMotivoUsuario       := FIntMotivosBloqueio.IntMotivoBloqueio.TxtMotivoUsuario;
  FMotivoBloqueio.TxtObservacaoUsuario   := FIntMotivosBloqueio.IntMotivoBloqueio.TxtObservacaoUsuario;
  FMotivoBloqueio.TxtProcedimentoUsuario := FIntMotivosBloqueio.IntMotivoBloqueio.TxtProcedimentoUsuario;
  FMotivoBloqueio.CodAplicacaoBloqueio   := FIntMotivosBloqueio.IntMotivoBloqueio.CodAplicacaoBloqueio;
  FMotivoBloqueio.DesAplicacaoBloqueio   := FIntMotivosBloqueio.IntMotivoBloqueio.DesAplicacaoBloqueio;
  FMotivoBloqueio.IndRestritoSistema     := FIntMotivosBloqueio.IntMotivoBloqueio.IndRestritoSistema;
  Result := FMotivoBloqueio;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMotivosBloqueio, Class_MotivosBloqueio,
    ciMultiInstance, tmApartment);
end.
