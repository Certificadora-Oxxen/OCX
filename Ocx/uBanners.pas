unit uBanners;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uBanner,
  uIntBanners;

type
  TBanners = class(TASPMTSObject, IBanners)
  private
    FIntBanners : TIntBanners;
    FInicializado : Boolean;
    FBanner: TBanner;
  protected
    function Alterar(CodBanner: Integer; const URLDestino,
      TxtAlternativo: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodBanner: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodBanner: Integer): Integer; safecall;
    function Inserir(const NomArquivo: WideString; CodTipoBanner: Integer;
      const URLDestino, TXTAlternativo: WideString; CodTipoTarget,
      CodAnunciante: Integer): Integer; safecall;
    function Liberar(CodBanner, CodTipoTarget: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const NomArquivo: WideString; CodTipoBanner: Integer;
      IndPesquisarDesativados: WordBool; IndEscopoPesquisa,
      CodAnunciante: Integer): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    function Get_Inicializado: WordBool; safecall;
    function Get_Banner: IBanner; safecall;
    function ExisteNomeArquivo(const NomArquivo: WideString): Integer;
      safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TBanners.AfterConstruction;
begin
  inherited;
  FBanner := TBanner.Create;
  FBanner.ObjAddRef;
  FInicializado := False;
end;

procedure TBanners.BeforeDestruction;
begin
  If FIntBanners <> nil Then Begin
    FIntBanners.Free;
  End;
  If FBanner <> nil Then Begin
    FBanner.ObjRelease;
    FBanner := nil;
  End;
  inherited;
end;

function TBanners.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntBanners := TIntBanners.Create;
  Result := FIntBanners.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TBanners.Alterar(CodBanner: Integer; const URLDestino,
  TxtAlternativo: WideString): Integer;
begin
  Result := FIntBanners.Alterar(CodBanner, URLDestino, TxtAlternativo);
end;

function TBanners.BOF: WordBool;
begin
  Result := FIntBanners.BOF;
end;

function TBanners.Buscar(CodBanner: Integer): Integer;
begin
  Result := FIntBanners.Buscar(CodBanner);
end;

function TBanners.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntBanners.Deslocar(QtdRegistros);
end;

function TBanners.EOF: WordBool;
begin
  Result := FIntBanners.EOF;
end;

function TBanners.Excluir(CodBanner: Integer): Integer;
begin
  Result := FIntBanners.Excluir(CodBanner);
end;

function TBanners.Inserir(const NomArquivo: WideString;
  CodTipoBanner: Integer; const URLDestino, TXTAlternativo: WideString;
  CodTipoTarget, CodAnunciante: Integer): Integer;
begin
  Result := FIntBanners.Inserir(NomArquivo, CodTipoBanner, URLDestino, TxtAlternativo, CodTipoTarget, CodAnunciante);
end;

function TBanners.Liberar(CodBanner, CodTipoTarget: Integer): Integer;
begin
  Result := FIntBanners.Liberar(CodBanner, CodTipoTarget);
end;

function TBanners.NumeroRegistros: Integer;
begin
  Result := FIntBanners.NumeroRegistros;
end;

function TBanners.Pesquisar(const NomArquivo: WideString;
  CodTipoBanner: Integer; IndPesquisarDesativados: WordBool;
  IndEscopoPesquisa, CodAnunciante: Integer): Integer;
begin
  Result := FIntBanners.Pesquisar(NomArquivo, CodTipoBanner, IndPesquisarDesativados,
  IndEscopoPesquisa, CodAnunciante);
end;

procedure TBanners.FecharPesquisa;
begin
  FIntBanners.FecharPesquisa;
end;

procedure TBanners.IrAoAnterior;
begin
  FIntBanners.IrAoAnterior;
end;

procedure TBanners.IrAoPrimeiro;
begin
  FIntBanners.IrAoPrimeiro;
end;

procedure TBanners.IrAoProximo;
begin
  FIntBanners.IrAoProximo;
end;

procedure TBanners.IrAoUltimo;
begin
  FIntBanners.IrAoUltimo;
end;

procedure TBanners.Posicionar(NumRegistro: Integer);
begin
  FIntBanners.Posicionar(NumRegistro);
end;

function TBanners.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntBanners.ValorCampo(NomeColuna);
end;

function TBanners.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TBanners.Get_Banner: IBanner;
begin
  FBanner.Codigo           := FIntBanners.IntBanner.Codigo;
  FBanner.NomArquivo       := FIntBanners.IntBanner.NomArquivo;
  FBanner.CodTipoBanner    := FIntBanners.IntBanner.CodTipoBanner;
  FBanner.URLDestino       := FIntBanners.IntBanner.URLDestino;
  FBanner.TxTAlternativo   := FIntBanners.IntBanner.TxTAlternativo;
  FBanner.CodAnunciante    := FIntBanners.IntBanner.CodAnunciante;
  FBanner.CodTipoTarget    := FIntBanners.IntBanner.CodTipoTarget;
  FBanner.DesTipoBanner    := FIntBanners.IntBanner.DesTipoBanner;
  FBanner.NomAnunciante    := FIntBanners.IntBanner.NomAnunciante;
  FBanner.DesTipoTarget    := FIntBanners.IntBanner.DesTipoTarget;
  FBanner.DtaFimValidade   := FIntBanners.IntBanner.DtaFimValidade;
  FBanner.TxtComandoTarget := FIntBanners.IntBanner.TxtComandoTarget;
  Result := FBanner;
end;

function TBanners.ExisteNomeArquivo(const NomArquivo: WideString): Integer;
begin
  Result := FIntBanners.ExisteNomeArquivo(NomArquivo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBanners, Class_Banners,
    ciMultiInstance, tmApartment);
end.
