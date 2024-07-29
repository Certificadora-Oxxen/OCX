// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 100
// *  Descrição Resumida : Pesquisa por todas as identificações duplas exigidas pelo SISBOV
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIdentificacoesDuplas;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntIdentificacoesDuplas,
   uConexao, uIntMensagens;

type
  TIdentificacoesDuplas = class(TASPMTSObject, IIdentificacoesDuplas)
  private
    FIntIdentificacoesDuplas: TIntIdentificacoesDuplas;
    FInicializado : Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const IndEnviaPedidoIdent: WideString): Integer;
      safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TIdentificacoesDuplas.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TIdentificacoesDuplas.BeforeDestruction;
begin
  If FIntIdentificacoesDuplas <> nil Then Begin
    FIntIdentificacoesDuplas.Free;
  End;
  inherited;
end;

function TIdentificacoesDuplas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntIdentificacoesDuplas := TIntIdentificacoesDuplas.Create;
  Result := FIntIdentificacoesDuplas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TIdentificacoesDuplas.EOF: WordBool;
begin
  Result := FIntIdentificacoesDuplas.EOF;
end;

function TIdentificacoesDuplas.Pesquisar(
  const IndEnviaPedidoIdent: WideString): Integer;
begin
  Result := FIntIdentificacoesDuplas.Pesquisar(IndEnviaPedidoIdent);
end;

function TIdentificacoesDuplas.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntIdentificacoesDuplas.ValorCampo(NomCampo);
end;

procedure TIdentificacoesDuplas.FecharPesquisa;
begin
  FIntIdentificacoesDuplas.FecharPesquisa;
end;

procedure TIdentificacoesDuplas.IrAoProximo;
begin
  FIntIdentificacoesDuplas.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TIdentificacoesDuplas, Class_IdentificacoesDuplas,
    ciMultiInstance, tmApartment);
end.
