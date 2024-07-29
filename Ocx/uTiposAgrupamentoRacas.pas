unit uTiposAgrupamentoRacas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, UIntTiposAgrupamentoRacas,
  uTipoAgrupamentoRacas, uConexao, uIntMensagens;

type
  TTiposAgrupamentoRacas = class(TASPMTSObject, ITiposAgrupamentoRacas)
  private
    FIntTiposAgrupamentoRacas : TIntTiposAgrupamentoRacas;
    FInicializado : Boolean;
    FTipoAgrupamentoRacas: TTipoAgrupamentoRacas;
  protected
    function Buscar(CodTipoAgrupamentoRacas: Integer): Integer; safecall;
    function Inserir(const SglTipoAgrupamentoRacas,
      DesTipoAgrupamentoRacas: WideString): Integer; safecall;
    function Alterar(CodTipoAgrupamentoRacas: Integer;
      const SglTipoAgrupamentoRacas,
      DesTipoAgrupamentoRacas: WideString): Integer; safecall;
    function Excluir(CodTipoAgrupamentoRacas: Integer): Integer; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function Get_TipoAgrupamentoRacas: ITipoAgrupamentoRacas; safecall;
    function BOF: WordBool; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    function EOF: WordBool; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposAgrupamentoRacas.AfterConstruction;
begin
  inherited;
  FTipoAgrupamentoRacas := TTipoAgrupamentoRacas.Create;
  FTipoAgrupamentoRacas.ObjAddRef;
  FInicializado := False;
end;

procedure TTiposAgrupamentoRacas.BeforeDestruction;
begin
  If FIntTiposAgrupamentoRacas <> nil Then Begin
    FIntTiposAgrupamentoRacas.Free;
  End;
  If FTipoAgrupamentoRacas <> nil Then Begin
    FTipoAgrupamentoRacas.ObjRelease;
    FTipoAgrupamentoRacas := nil;
  End;
  inherited;
end;

function TTiposAgrupamentoRacas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposAgrupamentoRacas := TIntTiposAgrupamentoRacas.Create;
  Result := FIntTiposAgrupamentoRacas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposAgrupamentoRacas.Buscar(
  CodTipoAgrupamentoRacas: Integer): Integer;
begin
  result := FIntTiposAgrupamentoRacas.Buscar(CodTipoAgrupamentoRacas);
end;

function TTiposAgrupamentoRacas.Inserir(const SglTipoAgrupamentoRacas,
  DesTipoAgrupamentoRacas: WideString): Integer;
begin
  result := FIntTiposAgrupamentoRacas.Inserir(SglTipoAgrupamentoRacas,
  DesTipoAgrupamentoRacas);
end;

function TTiposAgrupamentoRacas.Alterar(CodTipoAgrupamentoRacas: Integer;
  const SglTipoAgrupamentoRacas,
  DesTipoAgrupamentoRacas: WideString): Integer;
begin
  result := FIntTiposAgrupamentoRacas.Alterar(CodTipoAgrupamentoRacas,
  SglTipoAgrupamentoRacas, DesTipoAgrupamentoRacas);
end;

function TTiposAgrupamentoRacas.Excluir(
  CodTipoAgrupamentoRacas: Integer): Integer;
begin
  result := FIntTiposAgrupamentoRacas.Excluir(CodTipoAgrupamentoRacas);
end;

function TTiposAgrupamentoRacas.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntTiposAgrupamentoRacas.Pesquisar(CodOrdenacao);
end;

function TTiposAgrupamentoRacas.Get_TipoAgrupamentoRacas: ITipoAgrupamentoRacas;
begin
  FTipoAgrupamentoRacas.CodTipoAgrupamentoRacas   := FIntTiposAgrupamentoRacas.IntTipoAgrupamentoRacas.CodTipoAgrupamentoRacas;
  FTipoAgrupamentoRacas.SglTipoAgrupamentoRacas   := FIntTiposAgrupamentoRacas.IntTipoAgrupamentoRacas.SglTipoAgrupamentoRacas;
  FTipoAgrupamentoRacas.DesTipoAgrupamentoRacas   := FIntTiposAgrupamentoRacas.IntTipoAgrupamentoRacas.DesTipoAgrupamentoRacas;
  result := FTipoAgrupamentoRacas;
end;

function TTiposAgrupamentoRacas.BOF: WordBool;
begin
  result := FIntTiposAgrupamentoRacas.BOF;
end;

procedure TTiposAgrupamentoRacas.Deslocar(NumDeslocamento: Integer);
begin
  FIntTiposAgrupamentoRacas.Deslocar(NumDeslocamento);
end;

function TTiposAgrupamentoRacas.EOF: WordBool;
begin
  result := FIntTiposAgrupamentoRacas.EOF;
end;

procedure TTiposAgrupamentoRacas.FecharPesquisa;
begin
  FIntTiposAgrupamentoRacas.FecharPesquisa;
end;

procedure TTiposAgrupamentoRacas.IrAoAnterior;
begin
  FIntTiposAgrupamentoRacas.IrAoAnterior;
end;

procedure TTiposAgrupamentoRacas.IrAoPrimeiro;
begin
  FIntTiposAgrupamentoRacas.IrAoPrimeiro;
end;

procedure TTiposAgrupamentoRacas.IrAoProximo;
begin
  FIntTiposAgrupamentoRacas.IrAoProximo;
end;

procedure TTiposAgrupamentoRacas.IrAoUltimo;
begin
  FIntTiposAgrupamentoRacas.IrAoUltimo;
end;

function TTiposAgrupamentoRacas.NumeroRegistros: Integer;
begin
  result := FIntTiposAgrupamentoRacas.NumeroRegistros;
end;

procedure TTiposAgrupamentoRacas.Posicionar(NumPosicao: Integer);
begin
  FIntTiposAgrupamentoRacas.Posicionar(NumPosicao);
end;

function TTiposAgrupamentoRacas.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntTiposAgrupamentoRacas.ValorCampo(NomCampo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposAgrupamentoRacas, Class_TiposAgrupamentoRacas,
    ciMultiInstance, tmApartment);
end.
