unit uTiposPagina;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposPagina;

type
  TTiposPagina = class(TASPMTSObject, ITiposPagina)
  private
    FIntTiposPagina : TIntTiposPagina;
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

procedure TTiposPagina.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposPagina.BeforeDestruction;
begin
  If FIntTiposPagina <> nil Then Begin
    FIntTiposPagina.Free;
  End;
  inherited;
end;

function TTiposPagina.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposPagina := TIntTiposPagina.Create;
  Result := FIntTiposPagina.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposPagina.EOF: WordBool;
begin
  Result := FIntTiposPagina.EOF;
end;

function TTiposPagina.Pesquisar: Integer;
begin
  Result := FIntTiposPagina.Pesquisar;
end;

function TTiposPagina.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntTiposPagina.ValorCampo(NomeColuna);
end;

procedure TTiposPagina.FecharPesquisa;
begin
  FIntTiposPagina.FecharPesquisa;
end;

procedure TTiposPagina.IrAoProximo;
begin
  FIntTiposPagina.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposPagina, Class_TiposPagina,
    ciMultiInstance, tmApartment);
end.
