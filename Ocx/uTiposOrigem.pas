unit uTiposOrigem;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao,uIntMensagens,
  uIntTiposOrigem;

type
  TTiposOrigem = class(TASPMTSObject, ITiposOrigem)
  private
    FIntTiposOrigem : TIntTiposOrigem;
    FInicializado : Boolean;
  protected
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure IrAoProximo; safecall;
    procedure FecharPesquisa; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposOrigem.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposOrigem.BeforeDestruction;
begin
  If FIntTiposOrigem <> nil Then Begin
    FIntTiposOrigem.Free;
  End;
  inherited;
end;

function TTiposOrigem.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposOrigem := TIntTiposOrigem.Create;
  Result := FIntTiposOrigem.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposOrigem.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  result := FIntTiposOrigem.Pesquisar(CodOrdenacao);
end;

function TTiposOrigem.EOF: WordBool;
begin
  result := FIntTiposOrigem.EOF;
end;

function TTiposOrigem.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  result := FIntTiposOrigem.ValorCampo (NomeColuna);
end;

procedure TTiposOrigem.IrAoProximo;
begin
  FIntTiposOrigem.IrAoProximo;
end;

procedure TTiposOrigem.FecharPesquisa;
begin
  FIntTiposOrigem.FecharPesquisa;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposOrigem, Class_TiposOrigem,
    ciMultiInstance, tmApartment);
end.
