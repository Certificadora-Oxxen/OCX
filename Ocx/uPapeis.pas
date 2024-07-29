unit uPapeis;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntPapeis;

type
  TPapeis = class(TASPMTSObject, IPapeis)
  private
    FIntPapeis : TIntPapeis;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodTipoAcessoNaoDesejado: WideString): Integer;
      safecall;
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

procedure TPapeis.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TPapeis.BeforeDestruction;
begin
  If FIntPapeis <> nil Then Begin
    FIntPapeis.Free;
  End;
  inherited;
end;

function TPapeis.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPapeis := TIntPapeis.Create;
  Result := FIntPapeis.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPapeis.EOF: WordBool;
begin
  Result := FIntPapeis.EOF;
end;

function TPapeis.Pesquisar(
  const CodTipoAcessoNaoDesejado: WideString): Integer;
begin
  Result := FIntPapeis.Pesquisar(CodTipoAcessoNaoDesejado);
end;

function TPapeis.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPapeis.ValorCampo(NomeColuna);
end;

procedure TPapeis.FecharPesquisa;
begin
  FIntPapeis.FecharPesquisa;
end;

procedure TPapeis.IrAoProximo;
begin
  FIntPapeis.IrAoProximo;
end;

             
initialization
  TAutoObjectFactory.Create(ComServer, TPapeis, Class_Papeis,
    ciMultiInstance, tmApartment);
end.
