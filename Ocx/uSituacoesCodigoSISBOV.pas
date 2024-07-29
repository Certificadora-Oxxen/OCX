unit uSituacoesCodigoSISBOV;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntSituacoesCodigoSISBOV;

type
  TSituacoesCodigoSISBOV = class(TASPMTSObject, ISituacoesCodigoSISBOV)
  private
    FIntSituacoesCodigoSISBOV: TIntSituacoesCodigoSISBOV;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const IndSituacaoAplicavel,
      IndFiltroPesquisaOS: WideString): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
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

procedure TSituacoesCodigoSISBOV.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSituacoesCodigoSISBOV.BeforeDestruction;
begin
  if FIntSituacoesCodigoSISBOV <> nil then begin
    FIntSituacoesCodigoSISBOV.Free;
  end;
  inherited;
end;

function TSituacoesCodigoSISBOV.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntSituacoesCodigoSISBOV := TIntSituacoesCodigoSISBOV.Create;
  Result := FIntSituacoesCodigoSISBOV.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSituacoesCodigoSISBOV.EOF: WordBool;
begin
  Result := FIntSituacoesCodigoSISBOV.EOF;
end;

function TSituacoesCodigoSISBOV.Pesquisar(const IndSituacaoAplicavel,
  IndFiltroPesquisaOS: WideString): Integer;
begin
  Result := FIntSituacoesCodigoSISBOV.Pesquisar(IndSituacaoAplicavel,
    IndFiltroPesquisaOS);
end;

function TSituacoesCodigoSISBOV.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntSituacoesCodigoSISBOV.ValorCampo(NomeColuna);
end;

procedure TSituacoesCodigoSISBOV.FecharPesquisa;
begin
  FIntSituacoesCodigoSISBOV.FecharPesquisa;
end;

procedure TSituacoesCodigoSISBOV.IrAoPrimeiro;
begin
  FIntSituacoesCodigoSISBOV.IrAoPrimeiro;
end;

procedure TSituacoesCodigoSISBOV.IrAoProximo;
begin
  FIntSituacoesCodigoSISBOV.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSituacoesCodigoSISBOV, Class_SituacoesCodigoSISBOV,
    ciMultiInstance, tmApartment);
end.
