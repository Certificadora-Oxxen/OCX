unit uProgramas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uPrograma,
  uIntProgramas;

type
  TProgramas = class(TASPMTSObject, IProgramas)
  private
    FIntProgramas : TIntProgramas;
    FInicializado : Boolean;
    FPrograma: TPrograma;
  protected
    function Alterar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio, DtaInicioAnuncioNova, DtaFimAnuncioNova: TDateTime;
      CodBannerNovo: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio: TDateTime): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio: TDateTime): Integer; safecall;
    function Get_Inicializado: WordBool; safecall;
    function Get_Programa: IPrograma; safecall;
    function Inserir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio, DtaFimAnuncio: TDateTime;
      CodBanner: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodGrupoPaginas: Integer; DtaInicioAnuncio,
      DtaFimAnuncio: TDateTime; IndAnunciosInativos,
      IndOrdemCrescente: WordBool): Integer; safecall;
    function PesquisarUltimos(CodGrupoPaginas,
      QtdDiasRetroativos: Integer): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TProgramas.AfterConstruction;
begin
  inherited;
  FPrograma := TPrograma.Create;
  FPrograma.ObjAddRef;
  FInicializado := False;
end;

procedure TProgramas.BeforeDestruction;
begin
  If FIntProgramas <> nil Then Begin
    FIntProgramas.Free;
  End;
  If FPrograma <> nil Then Begin
    FPrograma.ObjRelease;
    FPrograma := nil;
  End;
  inherited;
end;

function TProgramas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntProgramas := TIntProgramas.Create;
  Result := FIntProgramas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TProgramas.Alterar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio, DtaInicioAnuncioNova, DtaFimAnuncioNova: TDateTime;
  CodBannerNovo: Integer): Integer;
begin
  Result := FIntProgramas.Alterar(CodGrupoPaginas, SeqPosicaoBanner,
    DtaInicioAnuncio, DtaInicioAnuncioNova, DtaFimAnuncioNova, CodBannerNovo);
end;

function TProgramas.BOF: WordBool;
begin
  Result := FIntProgramas.BOF;
end;

function TProgramas.Buscar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio: TDateTime): Integer;
begin
  Result := FIntProgramas.Buscar(CodGrupoPaginas, SeqPosicaoBanner, DtaInicioAnuncio);
end;

function TProgramas.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntProgramas.Deslocar(QtdRegistros);
end;

function TProgramas.EOF: WordBool;
begin
  Result := FIntProgramas.EOF;
end;

function TProgramas.Excluir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio: TDateTime): Integer;
begin
  Result := FIntProgramas.Excluir(CodGrupoPaginas, SeqPosicaoBanner, DtaInicioAnuncio);
end;

function TProgramas.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TProgramas.Get_Programa: IPrograma;
begin
  FPrograma.CodGrupoPaginas  := FIntProgramas.IntPrograma.CodGrupoPaginas;
  FPrograma.SeqPosicaoBanner := FIntProgramas.IntPrograma.SeqPosicaoBanner;
  FPrograma.DtaInicioAnuncio := FIntProgramas.IntPrograma.DtaInicioAnuncio;
  FPrograma.DtaFimAnuncio    := FIntProgramas.IntPrograma.DtaFimAnuncio;
  FPrograma.CodBanner        := FIntProgramas.IntPrograma.CodBanner;
  FPrograma.DesGrupoPaginas  := FIntProgramas.IntPrograma.DesGrupoPaginas;
  FPrograma.DesPosicaoBanner := FIntProgramas.IntPrograma.DesPosicaoBanner;
  FPrograma.NomArquivo       := FIntProgramas.IntPrograma.NomArquivo;
  Result := FPrograma;
end;

function TProgramas.Inserir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio, DtaFimAnuncio: TDateTime; CodBanner: Integer): Integer;
begin
  Result := FIntProgramas.Inserir(CodGrupoPaginas, SeqPosicaoBanner,
    DtaINicioAnuncio, DtaFimAnuncio, CodBanner);
end;

function TProgramas.NumeroRegistros: Integer;
begin
  Result := FIntProgramas.NumeroRegistros;
end;

function TProgramas.Pesquisar(CodGrupoPaginas: Integer; DtaInicioAnuncio,
  DtaFimAnuncio: TDateTime; IndAnunciosInativos,
  IndOrdemCrescente: WordBool): Integer;
begin
  Result := FIntProgramas.Pesquisar(CodGrupoPaginas, DtaInicioAnuncio, DtaFimAnuncio,
    IndAnunciosInativos, IndOrdemCrescente);
end;

function TProgramas.PesquisarUltimos(CodGrupoPaginas,
  QtdDiasRetroativos: Integer): Integer;
begin
  Result := FIntProgramas.PesquisarUltimos(CodGrupoPaginas, QtdDiasRetroativos);
end;

function TProgramas.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntProgramas.ValorCampo(NomeColuna);
end;

procedure TProgramas.FecharPesquisa;
begin
  FIntProgramas.FecharPesquisa;
end;

procedure TProgramas.IrAoAnterior;
begin
  FIntProgramas.IrAoAnterior;
end;

procedure TProgramas.IrAoPrimeiro;
begin
  FIntProgramas.IrAoPrimeiro;
end;

procedure TProgramas.IrAoProximo;
begin
  FIntProgramas.IrAoProximo;
end;

procedure TProgramas.IrAoUltimo;
begin
  FIntProgramas.IrAoUltimo;
end;

procedure TProgramas.Posicionar(NumRegistro: Integer);
begin
  FIntProgramas.Posicionar(NumRegistro);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TProgramas, Class_Programas,
    ciMultiInstance, tmApartment);
end.
