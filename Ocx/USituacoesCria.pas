unit USituacoesCria;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntSituacoesCria;

type
  TSituacoesCria = class(TASPMTSObject, ISituacoesCria)
  private
    FIntSituacoesCria: TIntSituacoesCria;
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

procedure TSituacoesCria.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesCria.BeforeDestruction;
begin
  If FIntSituacoesCria <> nil Then Begin
    FIntSituacoesCria.Free;
  End;
  inherited;
end;

function TSituacoesCria.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesCria := TIntSituacoesCria.Create;
  Result := FIntSituacoesCria.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSituacoesCria.EOF: WordBool;
begin
  Result := FIntSituacoesCria.EOF;
end;

function TSituacoesCria.Pesquisar: Integer;
begin
  Result := FIntSituacoesCria.Pesquisar;
end;

function TSituacoesCria.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  Result := FIntSituacoesCria.ValorCampo(NomColuna);
end;

procedure TSituacoesCria.FecharPesquisa;
begin
  FIntSituacoesCria.FecharPesquisa;
end;

procedure TSituacoesCria.IrAoProximo;
begin
  FIntSituacoesCria.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesCria, Class_SituacoesCria,
    ciMultiInstance, tmApartment);
end.
