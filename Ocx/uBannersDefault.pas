unit uBannersDefault;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntBannersDefault;

type
  TBannersDefault = class(TASPMTSObject, IBannersDefault)
  private
    FIntBannersDefault : TIntBannersDefault;
    FInicializado : Boolean;
  protected
    function Definir(CodGrupoPaginas, SeqPosicaoBanner,
      CodBannerDefault: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Pesquisar(CodGrupoPaginas: Integer): Integer; safecall;
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

procedure TBannersDefault.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TBannersDefault.BeforeDestruction;
begin
  If FIntBannersDefault <> nil Then Begin
    FIntBannersDefault.Free;
  End;
  inherited;
end;

function TBannersDefault.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntBannersDefault := TIntBannersDefault.Create;
  Result := FIntBannersDefault.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TBannersDefault.Definir(CodGrupoPaginas: Integer; SeqPosicaoBanner: Integer;
  CodBannerDefault: Integer): Integer;
begin
  Result := FIntBannersDefault.Definir(CodGrupoPaginas, SeqPosicaoBanner, CodBannerDefault);
end;

function TBannersDefault.EOF: WordBool;
begin
  Result := FIntBannersDefault.EOF;
end;

function TBannersDefault.Pesquisar(CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntBannersDefault.Pesquisar(CodGrupoPaginas);
end;

function TBannersDefault.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntBannersDefault.ValorCampo(NomeColuna);
end;

procedure TBannersDefault.FecharPesquisa;
begin
  FIntBannersDefault.FecharPesquisa;
end;

procedure TBannersDefault.IrAoProximo;
begin
  FIntBannersDefault.IrAoProximo
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBannersDefault, Class_BannersDefault,
    ciMultiInstance, tmApartment);
end.
