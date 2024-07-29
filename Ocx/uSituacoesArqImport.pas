unit uSituacoesArqImport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntSituacoesArqImport, uConexao, uIntMensagens;

type
  TSituacoesArqImport = class(TASPMTSObject, ISituacoesArqImport)
  private
    FIntSituacoesArqImport: TIntSituacoesArqImport;
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

uses ComServ, uIntClassesBasicas;

function TSituacoesArqImport.EOF: WordBool;
begin
  Result := FIntSituacoesArqImport.EOF(); 
end;

function TSituacoesArqImport.Pesquisar: Integer;
begin
  Result := FIntSituacoesArqImport.Pesquisar();
end;

function TSituacoesArqImport.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntSituacoesArqImport.ValorCampo(NomCampo);
end;

procedure TSituacoesArqImport.FecharPesquisa;
begin
  FIntSituacoesArqImport.FecharPesquisa;
end;

procedure TSituacoesArqImport.IrAoPrimeiro;
begin
  FIntSituacoesArqImport.IrAoPrimeiro;
end;

procedure TSituacoesArqImport.IrAoProximo;
begin
  FIntSituacoesArqImport.IrAoProximo;
end;

procedure TSituacoesArqImport.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesArqImport.BeforeDestruction;
begin
  inherited;
  If FIntSituacoesArqImport <> nil Then Begin
    FIntSituacoesArqImport.Free;
  End;
end;

function TSituacoesArqImport.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesArqImport := TIntSituacoesArqImport.Create;
  Result := FIntSituacoesArqImport.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesArqImport, Class_SituacoesArqImport,
    ciMultiInstance, tmApartment);
end.
