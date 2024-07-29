// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Vers�o             : 1
// *  Data               : 03/08/2004
// *  Documenta��o       : Atributos de Ordem de Servi�o - Defini��o das Classes.doc
// *  C�digo Classe      : 98
// *  Descri��o Resumida : Pesquisa por todas as formas de pagamento de ordens de servi�o
// ************************************************************************
// *  �ltimas Altera��es :
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
