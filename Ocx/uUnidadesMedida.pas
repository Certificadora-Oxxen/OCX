// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Unidade Medida
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    10/09/2002    Criação
// *
// ********************************************************************
unit uUnidadesMedida;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntUnidadesMedida,uUnidadeMedida;

type
  TUnidadesMedida = class(TASPMTSObject, IUnidadesMedida)
  private
    FIntUnidadesMedida    : TIntUnidadesMedida;
    FInicializado : Boolean;
    FUnidadeMedida      : TUnidadeMedida;
  protected
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function NumeroRegistros: Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function Get_UnidadeMedida: UnidadeMedida; safecall;
    function Alterar(CodUnidadeMedida: Integer; const SglUnidadeMedida,
      DesUnidadeMedida: WideString): Integer; safecall;
    function Buscar(CodUnidadeMedida: Integer): Integer; safecall;
    function Excluir(CodUnidadeMedida: Integer): Integer; safecall;
    function Inserir(const SglUnidadeMedida,
      DesUnidadeMedida: WideString): Integer; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TUnidadesMedida.AfterConstruction;
begin
  inherited;
  FUnidadeMedida := TUnidadeMedida.Create;
  FUnidadeMedida.ObjAddRef;
  FInicializado := False;
end;

procedure TUnidadesMedida.BeforeDestruction;
begin
  If FIntUnidadesMedida <> nil Then Begin
    FIntUnidadesMedida.Free;
  End;
  If FUnidadeMedida <> nil Then Begin
    FUnidadeMedida.ObjRelease;
    FUnidadeMedida := nil;
  End;
  inherited;
end;

function TUnidadesMedida.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntUnidadesMedida := TIntUnidadesMedida.Create;
  Result := FIntUnidadesMedida.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TUnidadesMedida.BOF: WordBool;
begin
  result := FIntUnidadesMedida.BOF;
end;

function TUnidadesMedida.EOF: WordBool;
begin
  result := FIntUnidadesMedida.EOF;
end;

function TUnidadesMedida.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  result := FIntUnidadesMedida.ValorCampo(NomColuna);
end;

procedure TUnidadesMedida.FecharPesquisa;
begin
  FIntUnidadesMedida.FecharPesquisa;
end;

procedure TUnidadesMedida.IrAoAnterior;
begin
  FIntUnidadesMedida.IrAoAnterior;
end;

procedure TUnidadesMedida.IrAoPrimeiro;
begin
  FIntUnidadesMedida.IrAoPrimeiro;
end;

procedure TUnidadesMedida.IrAoProximo;
begin
  FIntUnidadesMedida.IrAoProximo;
end;

procedure TUnidadesMedida.IrAoUltimo;
begin
  FIntUnidadesMedida.IrAoUltimo;
end;

procedure TUnidadesMedida.Posicionar(NumPosicao: Integer);
begin
  FIntUnidadesMedida.Posicionar(NumPosicao);
end;

function TUnidadesMedida.NumeroRegistros: Integer;
begin
  result := FIntUnidadesMedida.NumeroRegistros;
end;

function TUnidadesMedida.Deslocar(NumDeslocamento: Integer): Integer;
begin
  result := FIntUnidadesMedida.Deslocar(NumDeslocamento);
end;

function TUnidadesMedida.Get_UnidadeMedida: UnidadeMedida;
begin
    FUnidadeMedida.CodUnidadeMedida := FIntUnidadesMedida.IntUnidadeMedida.CodUnidadeMedida;
    FUnidadeMedida.SglUnidadeMedida := FIntUnidadesMedida.IntUnidadeMedida.SglUnidadeMedida;
    FUnidadeMedida.DesUnidadeMedida := FIntUnidadesMedida.IntUnidadeMedida.DesUnidadeMedida;
    result := FUnidadeMedida;
end;

function TUnidadesMedida.Alterar(CodUnidadeMedida: Integer;
  const SglUnidadeMedida, DesUnidadeMedida: WideString): Integer;
begin
  result := FIntUnidadesMedida.Alterar(CodUnidadeMedida,SglUnidadeMedida, DesUnidadeMedida);
end;

function TUnidadesMedida.Buscar(CodUnidadeMedida: Integer): Integer;
begin
  result := FIntUnidadesMedida.Buscar(CodUnidadeMedida);
end;

function TUnidadesMedida.Excluir(CodUnidadeMedida: Integer): Integer;
begin
  result := FIntUnidadesMedida.Excluir(CodUnidadeMedida);
end;

function TUnidadesMedida.Inserir(const SglUnidadeMedida,
  DesUnidadeMedida: WideString): Integer;
begin
  result := FIntUnidadesMedida.Inserir(SglUnidadeMedida, DesUnidadeMedida);
end;

function TUnidadesMedida.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntUnidadesMedida.Pesquisar(CodOrdenacao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TUnidadesMedida, Class_UnidadesMedida,
    ciMultiInstance, tmApartment);
end.
