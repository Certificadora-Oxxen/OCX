unit uSituacoesEmail;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uIntSituacoesEmail;

type
  TSituacoesEmail = class(TASPMTSObject, ISituacoesEmail)
  private
    FIntSituacoesEmail: TIntSituacoesEmail;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;  
  end;

implementation

uses ComServ, uIntClassesBasicas;

function TSituacoesEmail.EOF: WordBool;
begin
  Result := FIntSituacoesEmail.EOF;
end;

function TSituacoesEmail.Pesquisar(): Integer;
begin
  Result := FIntSituacoesEmail.Pesquisar();
end;

function TSituacoesEmail.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntSituacoesEmail.ValorCampo(NomCampo)
end;

procedure TSituacoesEmail.FecharPesquisa;
begin
  FIntSituacoesEmail.FecharPesquisa;
end;

procedure TSituacoesEmail.IrAoProximo;
begin
  FIntSituacoesEmail.IrAoProximo;
end;

procedure TSituacoesEmail.IrAoPrimeiro;
begin
  FIntSituacoesEmail.IrAoPrimeiro;
end;

procedure TSituacoesEmail.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesEmail.BeforeDestruction;
begin
  If FIntSituacoesEmail <> nil Then Begin
    FIntSituacoesEmail.Free;
  End;
  inherited;             
end;

function TSituacoesEmail.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesEmail := TIntSituacoesEmail.Create;
  Result := FIntSituacoesEmail.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesEmail, Class_SituacoesEmail, ciMultiInstance, tmApartment);
end.
