unit UCaracteristicasAvaliacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, UIntCaracteristicasAvaliacao,
  uCaracteristicaAvaliacao, uConexao, uIntMensagens;

type
  TCaracteristicasAvaliacao = class(TASPMTSObject, ICaracteristicasAvaliacao)
  private
    FIntCaracteristicasAvaliacao : TIntCaracteristicasAvaliacao;
    FInicializado : Boolean;
    FCaracteristicaAvaliacao: TCaracteristicaAvaliacao;
  protected
    function Buscar(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
      safecall;
    function Inserir(CodTipoAvaliacao: Integer; const SglCaracteristica,
      DesCaracteristica: WideString; CodUnidadeMedida: Integer;
      const IndSexo: WideString; ValLimiteMinimo,
      ValLimiteMaximo: Double): Integer; safecall;
    function Alterar(CodTipoAvaliacao, CodCaracteristica: Integer;
      const SglCaracteristica, DesCaracteristica: WideString;
      CodUnidadeMedida: Integer; const IndSexo: WideString;
      ValLimiteMinimo, ValLimiteMaximo: Double): Integer; safecall;
    function Excluir(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
      safecall;
    function Pesquisar(CodTipoAvaliacao: Integer; const DesCaracteristica,
      CodOrdenaca: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoProximo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    procedure FecharPesquisa; safecall;
    function PesquisarCaracteristica(CodTipoAvaliacao: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function Get_CaracteristicaAvaliacao: ICaracteristicaAvaliacao; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TCaracteristicasAvaliacao.AfterConstruction;
begin
  inherited;
  FCaracteristicaAvaliacao := TCaracteristicaAvaliacao.Create;
  FCaracteristicaAvaliacao.ObjAddRef;
  FInicializado := False;
end;

procedure TCaracteristicasAvaliacao.BeforeDestruction;
begin
  If FIntCaracteristicasAvaliacao <> nil Then Begin
    FIntCaracteristicasAvaliacao.Free;
  End;
  If FCaracteristicaAvaliacao <> nil Then Begin
    FCaracteristicaAvaliacao.ObjRelease;
    FCaracteristicaAvaliacao := nil;
  End;
  inherited;
end;

function TCaracteristicasAvaliacao.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntCaracteristicasAvaliacao := TIntCaracteristicasAvaliacao.Create;
  Result := FIntCaracteristicasAvaliacao.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TCaracteristicasAvaliacao.Buscar(CodTipoAvaliacao,
  CodCaracteristica: Integer): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.Buscar(CodTipoAvaliacao, CodCaracteristica);
end;

function TCaracteristicasAvaliacao.Inserir(CodTipoAvaliacao: Integer;
  const SglCaracteristica, DesCaracteristica: WideString;
  CodUnidadeMedida: Integer; const IndSexo: WideString; ValLimiteMinimo,
  ValLimiteMaximo: Double): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.Inserir(CodTipoAvaliacao, SglCaracteristica,
   DesCaracteristica, CodUnidadeMedida, IndSexo, ValLimiteMinimo, ValLimiteMaximo);
end;

function TCaracteristicasAvaliacao.Alterar(CodTipoAvaliacao,
  CodCaracteristica: Integer; const SglCaracteristica,
  DesCaracteristica: WideString; CodUnidadeMedida: Integer;
  const IndSexo: WideString; ValLimiteMinimo,
  ValLimiteMaximo: Double): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.Alterar(CodTipoAvaliacao, CodCaracteristica,
   SglCaracteristica, DesCaracteristica, CodUnidadeMedida, IndSexo, ValLimiteMinimo,
   ValLimiteMaximo);
end;

function TCaracteristicasAvaliacao.Excluir(CodTipoAvaliacao,
  CodCaracteristica: Integer): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.Excluir(CodTipoAvaliacao, CodCaracteristica);
end;

function TCaracteristicasAvaliacao.Pesquisar(CodTipoAvaliacao: Integer;
  const DesCaracteristica, CodOrdenaca: WideString): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.Pesquisar(CodTipoAvaliacao, DesCaracteristica,
   CodOrdenaca);
end;

function TCaracteristicasAvaliacao.BOF: WordBool;
begin
  Result := FIntCaracteristicasAvaliacao.BOF;
end;

function TCaracteristicasAvaliacao.EOF: WordBool;
begin
  Result := FIntCaracteristicasAvaliacao.EOF;
end;

function TCaracteristicasAvaliacao.NumeroRegistros: Integer;
begin
  Result := FIntCaracteristicasAvaliacao.NumeroRegistros;
end;

procedure TCaracteristicasAvaliacao.IrAoPrimeiro;
begin
  FIntCaracteristicasAvaliacao.IrAoPrimeiro;
end;

procedure TCaracteristicasAvaliacao.IrAoUltimo;
begin
  FIntCaracteristicasAvaliacao.IrAoUltimo;
end;

function TCaracteristicasAvaliacao.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntCaracteristicasAvaliacao.ValorCampo(NomCampo);
end;

procedure TCaracteristicasAvaliacao.Deslocar(NumDeslocamento: Integer);
begin
  FIntCaracteristicasAvaliacao.Deslocar(NumDeslocamento);
end;

procedure TCaracteristicasAvaliacao.IrAoAnterior;
begin
  FIntCaracteristicasAvaliacao.IrAoAnterior;
end;

procedure TCaracteristicasAvaliacao.IrAoProximo;
begin
  FIntCaracteristicasAvaliacao.IrAoProximo;
end;

procedure TCaracteristicasAvaliacao.Posicionar(NumPosicao: Integer);
begin
  FIntCaracteristicasAvaliacao.Posicionar(NumPosicao);
end;

procedure TCaracteristicasAvaliacao.FecharPesquisa;
begin
  FIntCaracteristicasAvaliacao.FecharPesquisa;
end;

function TCaracteristicasAvaliacao.PesquisarCaracteristica(
  CodTipoAvaliacao: Integer; const CodOrdenacao: WideString): Integer;
begin
  Result := FIntCaracteristicasAvaliacao.PesquisarCaracteristica(CodTipoAvaliacao, CodOrdenacao);
end;

function TCaracteristicasAvaliacao.Get_CaracteristicaAvaliacao: ICaracteristicaAvaliacao;
begin
  FCaracteristicaAvaliacao.CodCaracteristica  := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.CodCaracteristica;
  FCaracteristicaAvaliacao.CodTipoAvaliacao   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.CodTipoAvaliacao;
  FCaracteristicaAvaliacao.CodUnidadeMedida   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.CodUnidadeMedida;
  FCaracteristicaAvaliacao.DesTipoAvaliacao   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.DesTipoAvaliacao;
  FCaracteristicaAvaliacao.SglTipoAvaliacao   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.SglTipoAvaliacao;
  FCaracteristicaAvaliacao.SglUnidadeMedida   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.SglUnidadeMedida;
  FCaracteristicaAvaliacao.DesUnidadeMedida   := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.DesUnidadeMedida;
  FCaracteristicaAvaliacao.ValLimiteMaximo    := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.ValLimiteMaximo;
  FCaracteristicaAvaliacao.ValLimiteMinimo    := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.ValLimiteMinimo;
  FCaracteristicaAvaliacao.IndSexo            := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.IndSexo;
  FCaracteristicaAvaliacao.DesCaracteristica  := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.DesCaracteristica;
  FCaracteristicaAvaliacao.SglCaracteristica  := FIntCaracteristicasAvaliacao.IntCaracteristicaAvaliacao.SglCaracteristica;
  result := FCaracteristicaAvaliacao;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCaracteristicasAvaliacao, Class_CaracteristicasAvaliacao,
    ciMultiInstance, tmApartment);
end.
