// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 20/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 53
// *  Descrição Resumida : Cadastro de Tipos Lugar
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************

unit UtiposLugar;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposLugar;

type
  TTiposLugar = class(TASPMTSObject, ITiposLugar)
  private
    FIntTiposLugar : TIntTiposLugar;
    FInicializado : Boolean;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TTiposLugar.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposLugar.BeforeDestruction;
begin
  If FIntTiposLugar <> nil Then Begin
    FIntTiposLugar.Free;
  End;
  inherited;
end;

function TTiposLugar.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposLugar := TIntTiposLugar.Create;
  Result := FIntTiposLugar.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposLugar.EOF: WordBool;
begin
  result := FIntTiposLugar.EOF;
end;

function TTiposLugar.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
   result := FIntTiposLugar.Pesquisar(CodOrdenacao);
end;

function TTiposLugar.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntTiposLugar.ValorCampo(NomCampo);
end;

procedure TTiposLugar.FecharPesquisa;
begin
  FIntTiposLugar.FecharPesquisa;
end;

procedure TTiposLugar.IrAoProximo;
begin
  FIntTiposLugar.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposLugar, Class_TiposLugar,
    ciMultiInstance, tmApartment);
end.
