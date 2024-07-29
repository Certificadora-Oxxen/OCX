unit uSituacoesFTP;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntSituacoesFTP, uConexao, uIntMensagens;

type
  TSituacoesFTP = class(TASPMTSObject, ISituacoesFTP)
  private
    FIntSituacoesFTP: TIntSituacoesFTP;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

function TSituacoesFTP.EOF: WordBool;
begin
  Result := FIntSituacoesFTP.EOF;
end;

function TSituacoesFTP.Pesquisar: Integer;
begin
  Result := FIntSituacoesFTP.Pesquisar();
end;

function TSituacoesFTP.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntSituacoesFTP.ValorCampo(NomCampo);
end;

procedure TSituacoesFTP.FecharPesquisa;
begin
  FIntSituacoesFTP.FecharPesquisa;
end;

procedure TSituacoesFTP.IrAoPrimeiro;
begin
  FIntSituacoesFTP.IrAoPrimeiro;
end;

procedure TSituacoesFTP.IrAoProximo;
begin
  FIntSituacoesFTP.IrAoProximo;
end;

procedure TSituacoesFTP.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesFTP.BeforeDestruction;
begin
  inherited;
  If FIntSituacoesFTP <> nil Then Begin
    FIntSituacoesFTP.Free;
  End;
end;

function TSituacoesFTP.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesFTP := TIntSituacoesFTP.Create;
  Result := FIntSituacoesFTP.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesFTP, Class_SituacoesFTP,
    ciMultiInstance, tmApartment);
end.
