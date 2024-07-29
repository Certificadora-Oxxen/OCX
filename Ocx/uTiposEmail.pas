unit uTiposEmail;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uIntTiposEmail;

type
  TTiposEmail = class(TASPMTSObject, ITiposEmail)
  private
    FIntTiposEmail: TIntTiposEmail;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure FecharPesquisa; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntClassesBasicas;

function TTiposEmail.EOF: WordBool;
begin
  Result := FIntTiposEmail.EOF;
end;

function TTiposEmail.Pesquisar(): Integer;
begin
  Result := FIntTiposEmail.Pesquisar();
end;

function TTiposEmail.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposEmail.ValorCampo(NomCampo);
end;

procedure TTiposEmail.IrAoProximo;
begin
  FIntTiposEmail.IrAoProximo;
end;

procedure TTiposEmail.IrAoPrimeiro;
begin
  FIntTiposEmail.IrAoPrimeiro;
end;

procedure TTiposEmail.FecharPesquisa;
begin
  FIntTiposEmail.FecharPesquisa;
end;

procedure TTiposEmail.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposEmail.BeforeDestruction;
begin
  If FIntTiposEmail <> nil Then Begin
    FIntTiposEmail.Free;
  End;
  inherited;
end;

function TTiposEmail.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposEmail := TIntTiposEmail.Create;
  Result := FIntTiposEmail.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposEmail, Class_TiposEmail,
    ciMultiInstance, tmApartment);
end.
