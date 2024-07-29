// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 46
// *  Descrição Resumida : Cadastro de Aptidoes
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uAptidoes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntAptidoes;

type
  TAptidoes = class(TASPMTSObject, IAptidoes)
  private
    FIntAptidoes : TIntAptidoes;
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

procedure TAptidoes.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TAptidoes.BeforeDestruction;
begin
  If FIntAptidoes <> nil Then Begin
    FIntAptidoes.Free;
  End;
  inherited;
end;

function TAptidoes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAptidoes := TIntAptidoes.Create;
  Result := FIntAptidoes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAptidoes.EOF: WordBool;
begin
  result  := FIntAptidoes.Eof;
end;

function TAptidoes.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  result  := FIntAptidoes.Pesquisar(CodOrdenacao);
end;

function TAptidoes.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result  := FIntAptidoes.ValorCampo(NomCampo);
end;

procedure TAptidoes.FecharPesquisa;
begin
  FIntAptidoes.FecharPesquisa;
end;

procedure TAptidoes.IrAoProximo;
begin
  FIntAptidoes.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAptidoes, Class_Aptidoes,
    ciMultiInstance, tmApartment);
end.
