// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 22/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 54
// *  Descrição Resumida : Cadastro de Situacoes SisBov
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************

unit USituacoesSisBov;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntSituacoesSisBov;

type
  TSituacoesSisBov = class(TASPMTSObject, ISituacoesSisBov)
  private
    FIntSituacoesSisBov : TIntSituacoesSisBov;
    FInicializado : Boolean;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
  end;

implementation

uses ComServ;

procedure TSituacoesSisBov.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesSisBov.BeforeDestruction;
begin
  If FIntSituacoesSisBov <> nil Then Begin
    FIntSituacoesSisBov.Free;
  End;
  inherited;
end;

function TSituacoesSisBov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesSisBov := TIntSituacoesSisBov.Create;
  Result := FIntSituacoesSisBov.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSituacoesSisBov.EOF: WordBool;
begin
  result := FIntSituacoesSisBov.EOF;
end;

function TSituacoesSisBov.Pesquisar: Integer;
begin
   result := FIntSituacoesSisBov.Pesquisar;
end;

function TSituacoesSisBov.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntSituacoesSisBov.ValorCampo(NomCampo);
end;

procedure TSituacoesSisBov.FecharPesquisa;
begin
  FIntSituacoesSisBov.FecharPesquisa;
end;

procedure TSituacoesSisBov.IrAoProximo;
begin
  FIntSituacoesSisBov.IrAoProximo;
end;

procedure TSituacoesSisBov.IrAoPrimeiro;
begin
  FIntSituacoesSisBov.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesSisBov, Class_SituacoesSisBov,
    ciMultiInstance, tmApartment);
end.
