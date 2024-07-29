unit uRegimesPosseUso;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntRegimesPosseUso;

type
  TRegimesPosseUso = class(TASPMTSObject, IRegimesPosseUso)
  private
    FIntRegimesPosseUso: TIntRegimesPosseUso;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Pesquisar: Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TRegimesPosseUso.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TRegimesPosseUso.BeforeDestruction;
begin
  If FIntRegimesPosseUso <> nil Then Begin
    FIntRegimesPosseUso.Free;
  End;
  inherited;
end;

function TRegimesPosseUso.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRegimesPosseUso := TIntRegimesPosseUso.Create;
  Result := FIntRegimesPosseUso.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TRegimesPosseUso.EOF: WordBool;
begin
  Result := FIntRegimesPosseUso.EOF;
end;

function TRegimesPosseUso.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntRegimesPosseUso.ValorCampo(NomCampo);
end;

procedure TRegimesPosseUso.FecharPesquisa;
begin
  FIntRegimesPosseUso.FecharPesquisa;
end;

procedure TRegimesPosseUso.IrAoProximo;
begin
  FIntRegimesPosseUso.IrAoProximo;
end;

function TRegimesPosseUso.Pesquisar: Integer;
begin
  Result := FIntRegimesPosseUso.Pesquisar;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRegimesPosseUso, Class_RegimesPosseUso,
    ciMultiInstance, tmApartment);
end.
