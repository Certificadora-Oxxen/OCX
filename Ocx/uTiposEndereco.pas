// ********************************************************************
// *  Projeto            : Boitata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 44
// *  Descrição Resumida : Cadastro de Tipos de Endereço
// ************************************************************************
// *  Últimas Alterações
// *
// ************************************************************************

unit uTiposEndereco;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposEndereco;

type
  TTiposEndereco = class(TASPMTSObject, ITiposEndereco)
  private
    FIntTiposEndereco: TIntTiposEndereco;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposEndereco.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposEndereco.BeforeDestruction;
begin
  If FIntTiposEndereco <> nil Then Begin
    FIntTiposEndereco.Free;
  End;
  inherited;
end;

function TTiposEndereco.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposEndereco := TIntTiposEndereco.Create;
  Result := FIntTiposEndereco.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposEndereco.EOF: WordBool;
begin
  Result := FIntTiposEndereco.EOF;
end;

function TTiposEndereco.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposEndereco.ValorCampo(NomCampo);
end;

procedure TTiposEndereco.FecharPesquisa;
begin
  FIntTiposEndereco.FecharPesquisa;
end;

procedure TTiposEndereco.IrAoProximo;
begin
  FIntTiposEndereco.IrAoProximo;
end;

function TTiposEndereco.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  Result := FIntTiposEndereco.Pesquisar(CodOrdenacao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposEndereco, Class_TiposEndereco,
    ciMultiInstance, tmApartment);
end.
