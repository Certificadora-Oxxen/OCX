// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Regime Alimentar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    23/07/2002    Criação
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *
// *
// ********************************************************************
unit uRegimesAlimentares;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntRegimesAlimentares;

type
  TRegimesAlimentares = class(TASPMTSObject, IRegimesAlimentares)
  private
    FIntRegimesAlimentares : TIntRegimesAlimentares;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodAptidao: Integer; const IndAnimalMamando,
      IndIncluirNaoDefinido, CodOrdenacao: WideString): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    function PesquisarRelacionamento: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TRegimesAlimentares.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TRegimesAlimentares.BeforeDestruction;
begin
  If FIntRegimesAlimentares <> nil Then Begin
    FIntRegimesAlimentares.Free;
  End;
  inherited;
end;

function TRegimesAlimentares.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRegimesAlimentares := TIntRegimesAlimentares.Create;
  Result := FIntRegimesAlimentares.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TRegimesAlimentares.EOF: WordBool;
begin
  result := FIntRegimesAlimentares.EOF;
end;

function TRegimesAlimentares.Pesquisar(CodAptidao: Integer;
  const IndAnimalMamando, IndIncluirNaoDefinido,
  CodOrdenacao: WideString): Integer;
begin
  Result := FIntRegimesAlimentares.Pesquisar(CodAptidao,IndAnimalMamando,
    IndIncluirNaoDefinido, CodOrdenacao);
end;

procedure TRegimesAlimentares.FecharPesquisa;
begin
  FIntRegimesAlimentares.FecharPesquisa;
end;

procedure TRegimesAlimentares.IrAoProximo;
begin
  FIntRegimesAlimentares.IrAoProximo;
end;

function TRegimesAlimentares.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result :=  FIntRegimesAlimentares.ValorCampo(NomCampo);
end;

function TRegimesAlimentares.PesquisarRelacionamento: Integer;
begin
  result := FIntRegimesAlimentares.PesquisarRelacionamento;
end;

procedure TRegimesAlimentares.IrAoPrimeiro;
begin
  FIntRegimesAlimentares.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRegimesAlimentares, Class_RegimesAlimentares,
    ciMultiInstance, tmApartment);
end.
