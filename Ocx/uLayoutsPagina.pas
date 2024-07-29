unit uLayoutsPagina;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,  uConexao, uIntMensagens,
  uIntLayoutsPagina;

type
  TLayoutsPagina = class(TASPMTSObject, ILayoutsPagina)
  private
    FIntLayoutsPagina : TIntLayoutsPagina;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodTipoPagina: Integer): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TLayoutsPagina.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TLayoutsPagina.BeforeDestruction;
begin
  If FIntLayoutsPagina <> nil Then Begin
    FIntLayoutsPagina.Free;
  End;
  inherited;
end;

function TLayoutsPagina.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntLayoutsPagina := TIntLayoutsPagina.Create;
  Result := FIntLayoutsPagina.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TLayoutsPagina.EOF: WordBool;
begin
  Result := FIntLayoutsPagina.EOF;
end;

function TLayoutsPagina.Pesquisar(CodTipoPagina: Integer): Integer;
begin
  Result := FIntLayoutsPagina.Pesquisar(CodTipoPagina);
end;

function TLayoutsPagina.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntLayoutsPagina.ValorCampo(NomeColuna);
end;

procedure TLayoutsPagina.FecharPesquisa;
begin
  FIntLayoutsPagina.FecharPesquisa;
end;

procedure TLayoutsPagina.IrAoProximo;
begin
  FIntLayoutsPagina.IrAoProximo;
end;

procedure TLayoutsPagina.IrAoPrimeiro;
begin
  FIntLayoutsPagina.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLayoutsPagina, Class_LayoutsPagina,
    ciMultiInstance, tmApartment);
end.
