// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 97
// *  Descrição Resumida : Pesquisa por todas as formas de pagamento de identifcadores de
// *                       um determinado fabricante
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uFormasPagamentoIdentificador;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntFormasPagamentoIdentificador,
  uConexao, uIntMensagens;

type
  TFormasPagamentoIdentificador = class(TASPMTSObject, IFormasPagamentoIdentificador)
  private
    FIntFormasPagamentoIdentificador : TIntFormasPagamentoIdentificador;
    FInicializado: Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function Pesquisar(CodFabricanteIdentificador: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
  end;

implementation

uses ComServ;

procedure TFormasPagamentoIdentificador.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TFormasPagamentoIdentificador.BeforeDestruction;
begin
  If FIntFormasPagamentoIdentificador <> nil Then Begin
    FIntFormasPagamentoIdentificador.Free;
  End;
  inherited;
end;

function TFormasPagamentoIdentificador.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntFormasPagamentoIdentificador := TIntFormasPagamentoIdentificador.Create;
  Result := FIntFormasPagamentoIdentificador.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;


function TFormasPagamentoIdentificador.Pesquisar(
  CodFabricanteIdentificador: Integer): Integer;
begin
  Result := FIntFormasPagamentoIdentificador.Pesquisar(CodFabricanteIdentificador);
end;

function TFormasPagamentoIdentificador.EOF: WordBool;
begin
  Result := FIntFormasPagamentoIdentificador.EOF;
end;

procedure TFormasPagamentoIdentificador.FecharPesquisa;
begin
 FIntFormasPagamentoIdentificador.FecharPesquisa;
end;

procedure TFormasPagamentoIdentificador.IrAoProximo;
begin
  FIntFormasPagamentoIdentificador.IrAoProximo;
end;

function TFormasPagamentoIdentificador.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntFormasPagamentoIdentificador.ValorCampo(NomCampo);
end;

procedure TFormasPagamentoIdentificador.IrAoPrimeiro;
begin
  FIntFormasPagamentoIdentificador.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFormasPagamentoIdentificador, Class_FormasPagamentoIdentificador,
    ciMultiInstance, tmApartment);
end.
