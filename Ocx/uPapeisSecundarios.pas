// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 40
// *  Descrição Resumida : Cadastro de Papeis Secundarios.
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *
// ********************************************************************
unit uPapeisSecundarios;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntPapeisSecundarios;

type
  TPapeisSecundarios = class(TASPMTSObject, IPapeisSecundarios)
  private
    FIntPapeisSecundarios : TIntPapeisSecundarios;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPapeisSecundarios.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TPapeisSecundarios.BeforeDestruction;
begin
  If FIntPapeisSecundarios <> nil Then Begin
    FIntPapeisSecundarios.Free;
  End;
  inherited;
end;

function TPapeisSecundarios.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPapeisSecundarios := TIntPapeisSecundarios.Create;
  Result := FIntPapeisSecundarios.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPapeisSecundarios.EOF: WordBool;
begin
  result := FIntPapeisSecundarios.EOF;
end;

function TPapeisSecundarios.Pesquisar: Integer;
begin
  result := FIntPapeisSecundarios.Pesquisar;
end;

function TPapeisSecundarios.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntPapeisSecundarios.ValorCampo(NomCampo);
end;

procedure TPapeisSecundarios.FecharPesquisa;
begin
  FIntPapeisSecundarios.FecharPesquisa;
end;

procedure TPapeisSecundarios.IrAoProximo;
begin
  FIntPapeisSecundarios.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPapeisSecundarios, Class_PapeisSecundarios,
    ciMultiInstance, tmApartment);
end.
