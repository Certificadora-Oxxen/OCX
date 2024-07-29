// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 31
// *  Descrição Resumida : Cadastro de Tipos Fonte Agua
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    24/07/2002    Criação
// *
// ********************************************************************
unit uTiposFonteAgua;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposFonteAgua;

type
  TTiposFonteAgua = class(TASPMTSObject, ITiposFonteAgua)
  private
    FIntTiposFonteAgua : TIntTiposFonteAgua;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposFonteAgua.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposFonteAgua.BeforeDestruction;
begin
  If FIntTiposFonteAgua <> nil Then Begin
    FIntTiposFonteAgua.Free;
  End;
  inherited;
end;

function TTiposFonteAgua.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposFonteAgua := TIntTiposFonteAgua.Create;
  Result := FIntTiposFonteAgua.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposFonteAgua.EOF: WordBool;
begin
  result := FIntTiposFonteAgua.Eof;
end;

function TTiposFonteAgua.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntTiposFonteAgua.Pesquisar(CodOrdenacao);
end;

 procedure TTiposFonteAgua.FecharPesquisa;
begin
  FIntTiposFonteAgua.FecharPesquisa;
end;

procedure TTiposFonteAgua.IrAoProximo;
begin
  FIntTiposFonteAgua.IrAoProximo;
end;

function TTiposFonteAgua.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntTiposFonteAgua.ValorCampo(NomCampo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposFonteAgua, Class_TiposFonteAgua,
    ciMultiInstance, tmApartment);
end.
