unit uAgrupamentosRacas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, UIntAgrupamentosRacas,
  uAgrupamentoRacas, uConexao, uIntMensagens;

type
  TAgrupamentosRacas = class(TASPMTSObject, IAgrupamentosRacas)
  private
    FIntAgrupamentosRacas : TIntAgrupamentosRacas;
    FInicializado : Boolean;
    FAgrupamentoRacas: TAgrupamentoRacas;
  protected
    function Buscar(CodAgrupamentoRacas: Integer): Integer; safecall;
    function Inserir(CodTipoAgrupamentoRacas: Integer;
      const SglAgrupamentoRacas, DesAgrupamentoRacas: WideString): Integer;
      safecall;
    function Alterar(CodAgrupamentoRacas: Integer; const SglAgrupamentoRacas,
      DesAgrupamentoRacas: WideString): Integer; safecall;
    function Excluir(CodAgrupamentoRacas: Integer): Integer; safecall;
    function AdicionarRaca(CodAgrupamentoRacas, CodRaca: Integer;
      QtdFracaoRaca: Double): Integer; safecall;
    function RetirarRaca(CodAgrupamentoRaca, CodRaca: Integer): Integer;
      safecall;
    function PesquisarRacas(CodAgrupamentoRacas: Integer;
      const IndRacasNoAgrupamento, CodOrdenacao: WideString): Integer;
      safecall;
    function Pesquisar(CodTipoAgrupamento: Integer; const IndDetalharRacas,
      CodOrdenacao: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function Get_AgrupamentoRacas: IAgrupamentoRacas; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function ValorCampo(const ValorCampo: WideString): OleVariant; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TAgrupamentosRacas.AfterConstruction;
begin
  inherited;
  FAgrupamentoRacas := TAgrupamentoRacas.Create;
  FAgrupamentoRacas.ObjAddRef;
  FInicializado := False;
end;

procedure TAgrupamentosRacas.BeforeDestruction;
begin
  If FIntAgrupamentosRacas <> nil Then Begin
    FIntAgrupamentosRacas.Free;
  End;
  If FAgrupamentoRacas <> nil Then Begin
    FAgrupamentoRacas.ObjRelease;
    FAgrupamentoRacas := nil;
  End;
  inherited;
end;

function TAgrupamentosRacas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAgrupamentosRacas := TIntAgrupamentosRacas.Create;
  Result := FIntAgrupamentosRacas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAgrupamentosRacas.Buscar(CodAgrupamentoRacas: Integer): Integer;
begin
  result := FIntAgrupamentosRacas.Buscar(CodAgrupamentoRacas);
end;

function TAgrupamentosRacas.Inserir(CodTipoAgrupamentoRacas: Integer;
  const SglAgrupamentoRacas, DesAgrupamentoRacas: WideString): Integer;
begin
  result := FIntAgrupamentosRacas.Inserir(CodTipoAgrupamentoRacas,
  SglAgrupamentoRacas, DesAgrupamentoRacas);
end;

function TAgrupamentosRacas.Alterar(CodAgrupamentoRacas: Integer;
  const SglAgrupamentoRacas, DesAgrupamentoRacas: WideString): Integer;
begin
  result := FIntAgrupamentosRacas.Alterar(CodAgrupamentoRacas,
  SglAgrupamentoRacas, DesAgrupamentoRacas);
end;

function TAgrupamentosRacas.Excluir(CodAgrupamentoRacas: Integer): Integer;
begin
  result := FIntAgrupamentosRacas.Excluir(CodAgrupamentoRacas);
end;

function TAgrupamentosRacas.AdicionarRaca(CodAgrupamentoRacas,
  CodRaca: Integer; QtdFracaoRaca: Double): Integer;
begin
  result := FIntAgrupamentosRacas.AdicionarRaca(CodAgrupamentoRacas,
  CodRaca, QtdFracaoRaca);
end;

function TAgrupamentosRacas.RetirarRaca(CodAgrupamentoRaca,
  CodRaca: Integer): Integer;
begin
  result := FIntAgrupamentosRacas.RetirarRaca(CodAgrupamentoRaca,
  CodRaca);
end;

function TAgrupamentosRacas.PesquisarRacas(CodAgrupamentoRacas: Integer;
  const IndRacasNoAgrupamento, CodOrdenacao: WideString): Integer;
begin
  result := FIntAgrupamentosRacas.PesquisarRacas(CodAgrupamentoRacas,
  IndRacasNoAgrupamento, CodOrdenacao);
end;

function TAgrupamentosRacas.Pesquisar(CodTipoAgrupamento: Integer;
  const IndDetalharRacas, CodOrdenacao: WideString): Integer;
begin
  result := FIntAgrupamentosRacas.Pesquisar(CodTipoAgrupamento,
  IndDetalharRacas, CodOrdenacao);
end;

function TAgrupamentosRacas.BOF: WordBool;
begin
  result := FIntAgrupamentosRacas.BOF;
end;

function TAgrupamentosRacas.EOF: WordBool;
begin
  result := FIntAgrupamentosRacas.EOF;
end;

function TAgrupamentosRacas.Get_AgrupamentoRacas: IAgrupamentoRacas;
begin
  FAgrupamentoRacas.CodAgrupamentoRacas   := FIntAgrupamentosRacas.IntAgrupamentoRacas.CodAgrupamentoRacas;
  FAgrupamentoRacas.SglAgrupamentoRacas   := FIntAgrupamentosRacas.IntAgrupamentoRacas.SglAgrupamentoRacas;
  FAgrupamentoRacas.DesAgrupamentoRacas   := FIntAgrupamentosRacas.IntAgrupamentoRacas.DesAgrupamentoRacas;
  result := FAgrupamentoRacas;
end;

procedure TAgrupamentosRacas.Deslocar(NumDeslocamento: Integer);
begin
  FIntAgrupamentosRacas.Deslocar(NumDeslocamento);
end;

procedure TAgrupamentosRacas.FecharPesquisa;
begin
  FIntAgrupamentosRacas.FecharPesquisa;
end;

procedure TAgrupamentosRacas.IrAoAnterior;
begin
  FIntAgrupamentosRacas.IrAoAnterior;
end;

procedure TAgrupamentosRacas.IrAoPrimeiro;
begin
  FIntAgrupamentosRacas.IrAoPrimeiro;
end;

procedure TAgrupamentosRacas.IrAoProximo;
begin
  FIntAgrupamentosRacas.IrAoProximo;
end;

procedure TAgrupamentosRacas.IrAoUltimo;
begin
  FIntAgrupamentosRacas.IrAoUltimo;
end;

function TAgrupamentosRacas.NumeroRegistros: Integer;
begin
  result := FIntAgrupamentosRacas.NumeroRegistros;
end;

procedure TAgrupamentosRacas.Posicionar(NumPosicao: Integer);
begin
  FIntAgrupamentosRacas.Posicionar(NumPosicao);
end;

function TAgrupamentosRacas.ValorCampo(
  const ValorCampo: WideString): OleVariant;
begin
  result := FIntAgrupamentosRacas.ValorCampo(ValorCampo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAgrupamentosRacas, Class_AgrupamentosRacas,
    ciMultiInstance, tmApartment);
end.
