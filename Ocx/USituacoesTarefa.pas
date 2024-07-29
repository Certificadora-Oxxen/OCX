unit USituacoesTarefa;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntSituacoesTarefa;

type
  TSituacoesTarefa = class(TASPMTSObject, ISituacoesTarefa)
  private
    FIntSituacoesTarefa : TIntSituacoesTarefa;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TSituacoesTarefa.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesTarefa.BeforeDestruction;
begin
  If FIntSituacoesTarefa <> nil Then Begin
    FIntSituacoesTarefa.Free;
  End;
  inherited;
end;

function TSituacoesTarefa.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesTarefa := TIntSituacoesTarefa.Create;
  Result := FIntSituacoesTarefa.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSituacoesTarefa.EOF: WordBool;
begin
  Result := FIntSituacoesTarefa.EOF;
end;

function TSituacoesTarefa.Pesquisar: Integer;
begin
  Result := FIntSituacoesTarefa.Pesquisar;
end;

function TSituacoesTarefa.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntSituacoesTarefa.ValorCampo(NomeColuna);
end;

procedure TSituacoesTarefa.FecharPesquisa;
begin
  FIntSituacoesTarefa.FecharPesquisa;
end;

procedure TSituacoesTarefa.IrAoProximo;
begin
  FIntSituacoesTarefa.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesTarefa, Class_SituacoesTarefa,
    ciMultiInstance, tmApartment);
end.
