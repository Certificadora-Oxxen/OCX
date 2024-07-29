unit uTiposMovimentoEstoqueSemen;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposMovimentoEstoqueSemen;

type
  TTiposMovimentoEstoqueSemen = class(TASPMTSObject, ITiposMovimentoEstoqueSemen)
  private
    FIntTiposMovimentoEstoqueSemen : TIntTiposMovimentoEstoqueSemen;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const IndRestritoSistema: WideString): Integer;
      safecall;
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

procedure TTiposMovimentoEstoqueSemen.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposMovimentoEstoqueSemen.BeforeDestruction;
begin
  If FIntTiposMovimentoEstoqueSemen <> nil Then Begin
    FIntTiposMovimentoEstoqueSemen.Free;
  End;
  inherited;
end;

function TTiposMovimentoEstoqueSemen.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposMovimentoEstoqueSemen := TIntTiposMovimentoEstoqueSemen.Create;
  Result := FIntTiposMovimentoEstoqueSemen.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposMovimentoEstoqueSemen.EOF: WordBool;
begin
  Result := FIntTiposMovimentoEstoqueSemen.EOF;
end;

function TTiposMovimentoEstoqueSemen.Pesquisar(
  const IndRestritoSistema: WideString): Integer;
begin
  Result := FIntTiposMovimentoEstoqueSemen.Pesquisar(IndRestritoSistema);
end;

function TTiposMovimentoEstoqueSemen.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposMovimentoEstoqueSemen.ValorCampo(NomCampo);
end;

procedure TTiposMovimentoEstoqueSemen.FecharPesquisa;
begin
  FIntTiposMovimentoEstoqueSemen.FecharPesquisa;
end;

procedure TTiposMovimentoEstoqueSemen.IrAoPrimeiro;
begin
  FIntTiposMovimentoEstoqueSemen.IrAoPrimeiro;
end;

procedure TTiposMovimentoEstoqueSemen.IrAoProximo;
begin
  FIntTiposMovimentoEstoqueSemen.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposMovimentoEstoqueSemen, Class_TiposMovimentoEstoqueSemen,
    ciMultiInstance, tmApartment);
end.
