// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 102
// *  Descrição Resumida : Pesquisa por todas situacoes de Ordem de Serviço
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uSituacoesOS;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntSituacoesOS;

type
  TSituacoesOS = class(TASPMTSObject, ISituacoesOS)
  private
    FIntSituacoesOS: TIntSituacoesOS;
    FInicializado: Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodSituacaoOSOrigem: Integer;
      const IndEnviaPedidoIdent: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TSituacoesOS.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesOS.BeforeDestruction;
begin
  If FIntSituacoesOS <> nil Then Begin
    FIntSituacoesOS.Free;
  End;
  inherited;
end;

function TSituacoesOS.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesOS := TIntSituacoesOS.Create;
  Result := FIntSituacoesOS.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSituacoesOS.EOF: WordBool;
begin
  Result := FIntSituacoesOS.EOF;
end;

function TSituacoesOS.Pesquisar(CodSituacaoOSOrigem: Integer;
  const IndEnviaPedidoIdent: WideString): Integer;
begin
  Result := FIntSituacoesOS.Pesquisar(CodSituacaoOSOrigem, IndEnviaPedidoIdent);
end;

function TSituacoesOS.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntSituacoesOS.ValorCampo(NomCampo);
end;

procedure TSituacoesOS.FecharPesquisa;
begin
  FIntSituacoesOS.FecharPesquisa;
end;

procedure TSituacoesOS.IrAoProximo;
begin
  FIntSituacoesOS.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesOS, Class_SituacoesOS,
    ciMultiInstance, tmApartment);
end.
