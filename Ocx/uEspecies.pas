// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 47
// *  Descrição Resumida : Cadastro de Especies
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uEspecies;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntEspecies;

type
  TEspecies = class(TASPMTSObject, IEspecies)
  private
    FIntEspecies : TIntEspecies;
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

procedure TEspecies.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TEspecies.BeforeDestruction;
begin
  If FIntEspecies <> nil Then Begin
    FIntEspecies.Free;
  End;
  inherited;
end;

function TEspecies.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEspecies := TIntEspecies.Create;
  Result := FIntEspecies.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEspecies.EOF: WordBool;
begin
  result := FIntEspecies.EOF;
end;

function TEspecies.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  result := FIntEspecies.Pesquisar(CodOrdenacao);
end;

function TEspecies.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntEspecies.ValorCampo(NomCampo); 
end;

procedure TEspecies.FecharPesquisa;
begin
  FIntEspecies.FecharPesquisa;
end;

procedure TEspecies.IrAoProximo;
begin
  FIntEspecies.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEspecies, Class_Especies,
    ciMultiInstance, tmApartment);
end.
