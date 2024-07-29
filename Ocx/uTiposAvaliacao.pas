unit uTiposAvaliacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, UIntTiposAvaliacao,
  uTipoAvaliacao, uConexao, uIntMensagens;

type
  TTiposAvaliacao = class(TASPMTSObject, ITiposAvaliacao)
  private
    FIntTiposAvaliacao : TIntTiposAvaliacao;
    FInicializado : Boolean;
    FTipoAvaliacao: TTipoAvaliacao;
  protected
    function Buscar(CodTipoAvaliacao: Integer): Integer; safecall;
    function Alterar(CodTipoAvaliacao: Integer; const SglTipoAvaliacao,
      DesTipoAvaliacao: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodTipoAvaliacao: Integer): Integer; safecall;
    function Inserir(const SglTipoAvaliacao,
      DesTipoAvaliacao: WideString): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_TipoAvaliacao: ITipoAvaliacao; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposAvaliacao.AfterConstruction;
begin
  inherited;
  FTipoAvaliacao := TTipoAvaliacao.Create;
  FTipoAvaliacao.ObjAddRef;
  FInicializado := False;
end;

procedure TTiposAvaliacao.BeforeDestruction;
begin
  If FIntTiposAvaliacao <> nil Then Begin
    FIntTiposAvaliacao.Free;
  End;
  If FTipoAvaliacao <> nil Then Begin
    FTipoAvaliacao.ObjRelease;
    FTipoAvaliacao := nil;
  End;
  inherited;
end;

function TTiposAvaliacao.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposAvaliacao := TIntTiposAvaliacao.Create;
  Result := FIntTiposAvaliacao.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposAvaliacao.Buscar(CodTipoAvaliacao: Integer): Integer;
begin
  Result := FIntTiposAvaliacao.Buscar(CodTipoAvaliacao);
end;

function TTiposAvaliacao.Alterar(CodTipoAvaliacao: Integer;
  const SglTipoAvaliacao, DesTipoAvaliacao: WideString): Integer;
begin
  Result := FIntTiposAvaliacao.Alterar(CodTipoAvaliacao, SglTipoAvaliacao,
    DesTipoAvaliacao);
end;

function TTiposAvaliacao.BOF: WordBool;
begin
  Result := FIntTiposAvaliacao.BOF;
end;

function TTiposAvaliacao.EOF: WordBool;
begin
  Result := FIntTiposAvaliacao.EOF;
end;

function TTiposAvaliacao.Excluir(CodTipoAvaliacao: Integer): Integer;
begin
  Result := FIntTiposAvaliacao.Excluir(CodTipoAvaliacao);
end;

function TTiposAvaliacao.Inserir(const SglTipoAvaliacao,
  DesTipoAvaliacao: WideString): Integer;
begin
  Result := FIntTiposAvaliacao.Inserir(SglTipoAvaliacao, DesTipoAvaliacao);
end;

function TTiposAvaliacao.NumeroRegistros: Integer;
begin
  Result := FIntTiposAvaliacao.NumeroRegistros;
end;

function TTiposAvaliacao.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  Result := FIntTiposAvaliacao.Pesquisar(CodOrdenacao);
end;

function TTiposAvaliacao.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposAvaliacao.ValorCampo(NomCampo);
end;

procedure TTiposAvaliacao.IrAoPrimeiro;
begin
  FIntTiposAvaliacao.IrAoPrimeiro;
end;

procedure TTiposAvaliacao.IrAoProximo;
begin
  FIntTiposAvaliacao.IrAoProximo;
end;

procedure TTiposAvaliacao.IrAoUltimo;
begin
  FIntTiposAvaliacao.IrAoUltimo;
end;

procedure TTiposAvaliacao.Deslocar(NumDeslocamento: Integer);
begin
  FIntTiposAvaliacao.Deslocar(NumDeslocamento);
end;

procedure TTiposAvaliacao.FecharPesquisa;
begin
  FIntTiposAvaliacao.FecharPesquisa;
end;

procedure TTiposAvaliacao.IrAoAnterior;
begin
  FIntTiposAvaliacao.IrAoAnterior;
end;

procedure TTiposAvaliacao.Posicionar(NumPosicao: Integer);
begin
  FIntTiposAvaliacao.Posicionar(NumPosicao);
end;

function TTiposAvaliacao.Get_TipoAvaliacao: ITipoAvaliacao;
begin
  FTipoAvaliacao.CodTipoAvaliacao   := FIntTiposAvaliacao.IntTipoAvaliacao.CodTipoAvaliacao;
  FTipoAvaliacao.SglTipoAvaliacao   := FIntTiposAvaliacao.IntTipoAvaliacao.SglTipoAvaliacao;
  FTipoAvaliacao.DesTipoAvaliacao   := FIntTiposAvaliacao.IntTipoAvaliacao.DesTipoAvaliacao;
  result := FTipoAvaliacao;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposAvaliacao, Class_TiposAvaliacao,
    ciMultiInstance, tmApartment);
end.
