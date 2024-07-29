// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Vers�o             : 1
// *  Data               : 03/08/2004
// *  Documenta��o       : Atributos de Ordem de Servi�o - Defini��o das Classes.doc
// *  C�digo Classe      : 101
// *  Descri��o Resumida : Pesquisa por todos os acess�rios de um determinado fabricante
// *                       de identificadores
// ************************************************************************
// *  �ltimas Altera��es :
// *
// ************************************************************************
unit uProdutosAcessorios;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntProdutosAcessorios;

type
  TProdutosAcessorios = class(TASPMTSObject, IProdutosAcessorios)
  private
    FIntProdutosAcessorios: TIntProdutosAcessorios;
    FInicializado: Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodFabricanteIdentificador: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
  end;

implementation

uses ComServ;

procedure TProdutosAcessorios.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TProdutosAcessorios.BeforeDestruction;
begin
  If FIntProdutosAcessorios <> nil Then Begin
    FIntProdutosAcessorios.Free;
  End;
  inherited;
end;

function TProdutosAcessorios.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntProdutosAcessorios := TIntProdutosAcessorios.Create;
  Result := FIntProdutosAcessorios.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TProdutosAcessorios.EOF: WordBool;
begin
  Result := FIntProdutosAcessorios.EOF;
end;

function TProdutosAcessorios.Pesquisar(
  CodFabricanteIdentificador: Integer): Integer;
begin
  Result := FIntProdutosAcessorios.Pesquisar(CodFabricanteIdentificador);
end;

function TProdutosAcessorios.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntProdutosAcessorios.ValorCampo(NomCampo);
end;

procedure TProdutosAcessorios.FecharPesquisa;
begin
  FIntProdutosAcessorios.FecharPesquisa;
end;

procedure TProdutosAcessorios.IrAoProximo;
begin
  FIntProdutosAcessorios.IrAoProximo;
end;

procedure TProdutosAcessorios.IrAoPrimeiro;
begin
  FIntProdutosAcessorios.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TProdutosAcessorios, Class_ProdutosAcessorios,
    ciMultiInstance, tmApartment);
end.
