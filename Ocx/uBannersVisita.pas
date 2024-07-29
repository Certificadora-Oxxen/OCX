unit uBannersVisita;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntBannersVisita;

type
  TBannersVisita = class(TASPMTSObject, IBannersVisita)
  private
    FIntBannersVisita : TIntBannersVisita;
    FInicializado : Boolean;
  protected
    function Get_Inicializado: WordBool; safecall;
    function IncrementarCliques(CodPagina, CodBanner: Integer): Integer;
      safecall;
    function Localizar(SeqPosicaoBanner: Integer): Integer; safecall;
    function Pesquisar(CodPagina: Integer;
      IncrementarImpressao: WordBool): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function QtdBannersPagina(CodPagina: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;                        
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TBannersVisita.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TBannersVisita.BeforeDestruction;
begin
  If FIntBannersVisita <> nil Then Begin
    FIntBannersVisita.Free;
  End;
  inherited;
end;

function TBannersVisita.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntBannersVisita := TIntBannersVisita.Create;
  Result := FIntBannersVisita.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TBannersVisita.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TBannersVisita.IncrementarCliques(CodPagina,
  CodBanner: Integer): Integer;
begin
  Result := FIntBannersVisita.IncrementarCliques(CodPagina, CodBanner);
end;

function TBannersVisita.Localizar(SeqPosicaoBanner: Integer): Integer;
begin
  Result := FIntBannersVisita.Localizar(SeqPosicaoBanner);
end;

function TBannersVisita.Pesquisar(CodPagina: Integer;
  IncrementarImpressao: WordBool): Integer;
begin
  Result := FIntBannersVisita.Pesquisar(CodPagina, IncrementarImpressao);
end;

function TBannersVisita.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntBannersVisita.ValorCampo(NomeColuna);
end;

procedure TBannersVisita.FecharPesquisa;
begin
  FIntBannersVisita.FecharPesquisa;
end;

function TBannersVisita.QtdBannersPagina(CodPagina: Integer): Integer;
begin
  Result := FIntBannersVisita.QtdBannersPagina(CodPagina);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBannersVisita, Class_BannersVisita,
    ciMultiInstance, tmApartment);
end.
