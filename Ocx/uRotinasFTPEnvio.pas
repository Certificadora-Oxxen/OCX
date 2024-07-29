unit uRotinasFTPEnvio;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntRotinasFTPEnvio, uConexao, uIntMensagens;

type
  TRotinasFTPEnvio = class(TASPMTSObject, IRotinasFTPEnvio)
  private
    FIntRotinasFTPEnvio: TIntRotinasFTPEnvio;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;    
  end;

implementation

uses ComServ;

function TRotinasFTPEnvio.EOF: WordBool;
begin
  Result := FIntRotinasFTPEnvio.EOF;
end;

function TRotinasFTPEnvio.Pesquisar: Integer;
begin
  Result := FIntRotinasFTPEnvio.Pesquisar;
end;

function TRotinasFTPEnvio.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntRotinasFTPEnvio.ValorCampo(NomCampo);
end;

procedure TRotinasFTPEnvio.FecharPesquisa;
begin
  FIntRotinasFTPEnvio.FecharPesquisa;
end;

procedure TRotinasFTPEnvio.IrAoPrimeiro;
begin
  FIntRotinasFTPEnvio.IrAoPrimeiro;
end;

procedure TRotinasFTPEnvio.IrAoProximo;
begin
  FIntRotinasFTPEnvio.IrAoProximo;
end;

procedure TRotinasFTPEnvio.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TRotinasFTPEnvio.BeforeDestruction;
begin
  If FIntRotinasFTPEnvio <> nil Then Begin
    FIntRotinasFTPEnvio.Free;
  End;
  inherited;
end;

function TRotinasFTPEnvio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRotinasFTPEnvio := TIntRotinasFTPEnvio.Create;
  Result := FIntRotinasFTPEnvio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRotinasFTPEnvio, Class_RotinasFTPEnvio,
    ciMultiInstance, tmApartment);
end.
