// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 48
// *  Descrição Resumida : Cadastro de Tipos Morte
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uTiposMorte;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposMorte;

type
  TTiposMorte = class(TASPMTSObject, ITiposMorte)
  private
    FIntTiposMorte : TIntTiposMorte;
    FInicializado : Boolean;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function Pesquisar(const CorOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function PesquisarRelacionamento: Integer; safecall;
  end;

implementation

uses ComServ;

procedure TTiposMorte.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposMorte.BeforeDestruction;
begin
  If FIntTiposMorte <> nil Then Begin
    FIntTiposMorte.Free;
  End;
  inherited;
end;

function TTiposMorte.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposMorte := TIntTiposMorte.Create;
  Result := FIntTiposMorte.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposMorte.Pesquisar(const CorOrdenacao: WideString): Integer;
begin
  result := FIntTiposMorte.Pesquisar(CorOrdenacao);
end;

function TTiposMorte.EOF: WordBool;
begin
  result := FIntTiposMorte.EOF;
end;

procedure TTiposMorte.IrAoProximo;
begin
  FIntTiposMorte.IrAoProximo;
end;

function TTiposMorte.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntTiposMorte.ValorCampo(NomCampo);
end;

procedure TTiposMorte.FecharPesquisa;
begin
  FIntTiposMorte.FecharPesquisa;
end;

function TTiposMorte.PesquisarRelacionamento: Integer;
begin
  result := FIntTiposMorte.PesquisarRelacionamento;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposMorte, Class_TiposMorte,
    ciMultiInstance, tmApartment);
end.
