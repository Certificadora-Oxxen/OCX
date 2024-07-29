// ********************************************************************
// *  Projeto            : Boitata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 43
// *  Descrição Resumida : Cadastro de Tipos de Contato
// ************************************************************************
// *  Últimas Alterações
// *
// ************************************************************************

unit uTiposContato;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposContato;

type
  TTiposContato = class(TASPMTSObject, ITiposContato)
  private
    FIntTiposContato: TIntTiposContato;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposContato.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposContato.BeforeDestruction;
begin
  If FIntTiposContato <> nil Then Begin
    FIntTiposContato.Free;
  End;
  inherited;
end;

function TTiposContato.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposContato := TIntTiposContato.Create;
  Result := FIntTiposContato.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposContato.EOF: WordBool;
begin
  Result := FIntTiposContato.EOF;
end;

function TTiposContato.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  Result := FIntTiposContato.Pesquisar(CodOrdenacao);
end;

function TTiposContato.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposContato.ValorCampo(NomCampo);
end;

procedure TTiposContato.FecharPesquisa;
begin
  FIntTiposContato.FecharPesquisa;
end;

procedure TTiposContato.IrAoProximo;
begin
  FIntTiposContato.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposContato, Class_TiposContato,
    ciMultiInstance, tmApartment);
end.
