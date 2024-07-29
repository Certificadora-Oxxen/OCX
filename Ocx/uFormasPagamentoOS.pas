// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 98
// *  Descrição Resumida : Pesquisa por todas as formas de pagamento de ordens de serviço
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit UFormasPagamentoOS;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntFormasPagamentoOS, uConexao,
  uIntMensagens;

type
  TFormasPagamentoOS = class(TASPMTSObject, IFormasPagamentoOS)
  private
    FIntFormasPagamentoOS: TIntFormasPagamentoOS;
    FInicializado: Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TFormasPagamentoOS.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TFormasPagamentoOS.BeforeDestruction;
begin
  If FIntFormasPagamentoOS <> nil Then Begin
    FIntFormasPagamentoOS.Free;
  End;
  inherited;
end;

function TFormasPagamentoOS.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntFormasPagamentoOS := TIntFormasPagamentoOS.Create;
  Result := FIntFormasPagamentoOS.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TFormasPagamentoOS.EOF: WordBool;
begin
   Result := FIntFormasPagamentoOS.EOF;
end;

function TFormasPagamentoOS.Pesquisar: Integer;
begin
   Result := FIntFormasPagamentoOS.Pesquisar;
end;

function TFormasPagamentoOS.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
   Result := FIntFormasPagamentoOS.ValorCampo(NomCampo);
end;

procedure TFormasPagamentoOS.FecharPesquisa;
begin
  FIntFormasPagamentoOS.FecharPesquisa;
end;

procedure TFormasPagamentoOS.IrAoProximo;
begin
 FIntFormasPagamentoOS.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFormasPagamentoOS, Class_FormasPagamentoOS,
    ciMultiInstance, tmApartment);
end.
