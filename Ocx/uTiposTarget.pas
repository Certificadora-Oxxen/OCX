unit uTiposTarget;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposTarget;

type
  TTiposTarget = class(TASPMTSObject, ITiposTarget)
  private
    FIntTiposTarget : TIntTiposTarget;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposTarget.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposTarget.BeforeDestruction;
begin
  If FIntTiposTarget <> nil Then Begin
    FIntTiposTarget.Free;
  End;
  inherited;
end;

function TTiposTarget.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposTarget := TIntTiposTarget.Create;
  Result := FIntTiposTarget.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposTarget.EOF: WordBool;
begin
  Result := FIntTiposTarget.EOF;
end;

function TTiposTarget.Pesquisar: Integer;
begin
  Result := FIntTiposTarget.Pesquisar;
end;

function TTiposTarget.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntTiposTarget.ValorCampo(NomeColuna);
end;

procedure TTiposTarget.FecharPesquisa;
begin
  FIntTiposTarget.FecharPesquisa;
end;

procedure TTiposTarget.IrAoProximo;
begin
  FIntTiposTarget.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposTarget, Class_TiposTarget,
    ciMultiInstance, tmApartment);
end.
