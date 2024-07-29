unit uMotivosDescarte;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntMotivosDescarte;

type
  TMotivosDescarte = class(TASPMTSObject, IMotivosDescarte)
  private
    FIntMotivosDescarte: TIntMotivosDescarte;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TMotivosDescarte.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TMotivosDescarte.BeforeDestruction;
begin
  If FIntMotivosDescarte <> nil Then Begin
    FIntMotivosDescarte.Free;
  End;
  inherited;
end;

function TMotivosDescarte.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntMotivosDescarte := TIntMotivosDescarte.Create;
  Result := FIntMotivosDescarte.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TMotivosDescarte.EOF: WordBool;
begin
  Result := FIntMotivosDescarte.EOF;
end;

function TMotivosDescarte.Pesquisar: Integer;
begin
  Result := FIntMotivosDescarte.Pesquisar;
end;

function TMotivosDescarte.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  Result := FIntMotivosDescarte.ValorCampo(NomColuna);
end;

procedure TMotivosDescarte.FecharPesquisa;
begin
  FIntMotivosDescarte.FecharPesquisa;
end;

procedure TMotivosDescarte.IrAoProximo;
begin
  FIntMotivosDescarte.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMotivosDescarte, Class_MotivosDescarte,
    ciMultiInstance, tmApartment);
end.
