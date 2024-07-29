// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 08/11/2002
// *  Documentação       : Eventos de Movimentação - Definição das classes.doc
// *  Código Classe      : 71
// *  Descrição Resumida : Pesquisa de Tipos de Sub Eventos Sanitários
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    08/11/2002    Criação
// *
// ********************************************************************
unit uTiposSubEventoSanitario;

{$DEFINE MSSQL}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,uIntTiposSubEventoSanitario;

type
  TTiposSubEventoSanitario = class(TASPMTSObject, ITiposSubEventoSanitario)
  private
    FIntTiposSubEventoSanitario  : TIntTiposSubEventoSanitario;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposSubEventoSanitario.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposSubEventoSanitario.BeforeDestruction;
begin
  If FIntTiposSubEventoSanitario <> nil Then Begin
    FIntTiposSubEventoSanitario.Free;
  End;
  inherited;
end;

function TTiposSubEventoSanitario.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposSubEventoSanitario := TIntTiposSubEventoSanitario.Create;
  Result := FIntTiposSubEventoSanitario.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposSubEventoSanitario.EOF: WordBool;
begin
  result := FIntTiposSubEventoSanitario.EOF;
end;

function TTiposSubEventoSanitario.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntTiposSubEventoSanitario.Pesquisar(CodOrdenacao);
end;

function TTiposSubEventoSanitario.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  result := FIntTiposSubEventoSanitario.ValorCampo(NomColuna);
end;

procedure TTiposSubEventoSanitario.FecharPesquisa;
begin
  FIntTiposSubEventoSanitario.FecharPesquisa;
end;

procedure TTiposSubEventoSanitario.IrAoProximo;
begin
  FIntTiposSubEventoSanitario.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposSubEventoSanitario, Class_TiposSubEventoSanitario,
    ciMultiInstance, tmApartment);
end.
