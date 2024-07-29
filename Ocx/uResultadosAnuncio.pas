unit uResultadosAnuncio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntResultadosAnuncio;

type
  TResultadosAnuncio = class(TASPMTSObject, IResultadosAnuncio)
  private
    FIntResultadosAnuncio : TIntResultadosAnuncio;
    FInicializado : Boolean;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodAnunciante, CodPagina: Integer; DtaInicio,
      DtaFim: TDateTime; IndDetalheData, IndDetalhePagina,
      IndDetalheBanner: WordBool): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function GerarRelatorio(CodAnunciante, CodPagina: Integer; DtaInicio,
      DtaFim: TDateTime; IndDetalheData, IndDetalhePagina,
      IndDetalheBanner: WordBool; Tipo: Integer): WideString; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TResultadosAnuncio.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TResultadosAnuncio.BeforeDestruction;
begin
  If FIntResultadosAnuncio <> nil Then Begin
    FIntResultadosAnuncio.Free;
  End;
  inherited;
end;

function TResultadosAnuncio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntResultadosAnuncio := TIntResultadosAnuncio.Create;
  Result := FIntResultadosAnuncio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TResultadosAnuncio.BOF: WordBool;
begin
  Result := FIntResultadosAnuncio.BOF;
end;

function TResultadosAnuncio.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntResultadosAnuncio.Deslocar(QtdRegistros);
end;

function TResultadosAnuncio.EOF: WordBool;
begin
  Result := FIntResultadosAnuncio.EOF;
end;

function TResultadosAnuncio.NumeroRegistros: Integer;
begin
  Result := FIntResultadosAnuncio.NumeroRegistros;
end;

function TResultadosAnuncio.Pesquisar(CodAnunciante, CodPagina: Integer;
  DtaInicio, DtaFim: TDateTime; IndDetalheData, IndDetalhePagina,
  IndDetalheBanner: WordBool): Integer;
begin
  Result := FIntResultadosAnuncio.Pesquisar(CodAnunciante, CodPagina, DtaInicio,
    DtaFim, IndDetalheData, IndDetalhePagina, IndDetalheBanner);
end;

function TResultadosAnuncio.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntResultadosAnuncio.ValorCampo(NomeColuna);
end;

procedure TResultadosAnuncio.FecharPesquisa;
begin
  FIntResultadosAnuncio.FecharPesquisa;
end;

procedure TResultadosAnuncio.IrAoAnterior;
begin
  FIntResultadosAnuncio.IrAoAnterior;
end;

procedure TResultadosAnuncio.IrAoPrimeiro;
begin
  FIntResultadosAnuncio.IrAoPrimeiro;
end;

procedure TResultadosAnuncio.IrAoProximo;
begin
  FIntResultadosAnuncio.IrAoProximo;
end;

procedure TResultadosAnuncio.IrAoUltimo;
begin
  FIntResultadosAnuncio.IrAoUltimo;
end;

procedure TResultadosAnuncio.Posicionar(NumRegistro: Integer);
begin
  FIntResultadosAnuncio.Posicionar(NumRegistro);
end;

function TResultadosAnuncio.GerarRelatorio(CodAnunciante,
  CodPagina: Integer; DtaInicio, DtaFim: TDateTime; IndDetalheData,
  IndDetalhePagina, IndDetalheBanner: WordBool; Tipo: Integer): WideString;
begin
  Result := FIntResultadosAnuncio.GerarRelatorio(CodAnunciante, CodPagina,
    DtaInicio, DtaFim, IndDetalheData, IndDetalhePagina, IndDetalheBanner, Tipo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TResultadosAnuncio, Class_ResultadosAnuncio,
    ciMultiInstance, tmApartment);
end.
