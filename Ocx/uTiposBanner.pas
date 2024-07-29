unit uTiposBanner;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposBanner;

type
  TTiposBanner = class(TASPMTSObject, ITiposBanner)
  private
    FIntTiposBanner : TIntTiposBanner;
    FInicializado : Boolean;
  protected
    function Pesquisar: Integer; safecall;
    function EOF: WordBool; safecall;
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

procedure TTiposBanner.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposBanner.BeforeDestruction;
begin
  If FIntTiposBanner <> nil Then Begin
    FIntTiposBanner.Free;
  End;
  inherited;
end;

function TTiposBanner.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposBanner := TIntTiposBanner.Create;
  Result := FIntTiposBanner.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposBanner.Pesquisar: Integer;
begin
  Result := FIntTiposBanner.Pesquisar;
end;

function TTiposBanner.EOF: WordBool;
begin
  Result := FIntTiposBanner.EOF;
end;

function TTiposBanner.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FInttiposBanner.ValorCampo(NomeColuna);
end;

procedure TTiposBanner.FecharPesquisa;
begin
  FIntTiposBanner.FecharPesquisa;
end;

procedure TTiposBanner.IrAoProximo;
begin
  FIntTiposBanner.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposBanner, Class_TiposBanner,
    ciMultiInstance, tmApartment);
end.
