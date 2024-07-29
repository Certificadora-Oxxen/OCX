unit uRotinasFTPRetorno;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntRotinasFTPRetorno;

type
  TRotinasFTPRetorno = class(TASPMTSObject, IRotinasFTPRetorno)
  private
    FIntRotinasFTPRetorno: TIntRotinasFTPRetorno;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TRotinasFTPRetorno.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TRotinasFTPRetorno.BeforeDestruction;
begin
  If FIntRotinasFTPRetorno <> nil Then Begin
    FIntRotinasFTPRetorno.Free;
  End;
  inherited;
end;

function TRotinasFTPRetorno.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRotinasFTPRetorno := TIntRotinasFTPRetorno.Create;
  Result := FIntRotinasFTPRetorno.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TRotinasFTPRetorno.EOF: WordBool;
begin
  Result := FIntRotinasFTPRetorno.EOF;
end;

function TRotinasFTPRetorno.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntRotinasFTPRetorno.ValorCampo(NomCampo);
end;

procedure TRotinasFTPRetorno.FecharPesquisa;
begin
  FIntRotinasFTPRetorno.FecharPesquisa;
end;

procedure TRotinasFTPRetorno.IrAoProximo;
begin
  FIntRotinasFTPRetorno.IrAoProximo;
end;

function TRotinasFTPRetorno.Pesquisar: Integer;
begin
  Result := FIntRotinasFTPRetorno.Pesquisar;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRotinasFTPRetorno, Class_RotinasFTPRetorno,
    ciMultiInstance, tmApartment);
end.
