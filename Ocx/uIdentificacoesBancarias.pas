unit uIdentificacoesBancarias;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntIdentificacoesBancarias,
  uConexao, uIntMensagens;

type
  TIdentificacoesBancarias = class(TASPMTSObject, IIdentificacoesBancarias)
  private
    FInicializado: Boolean;

    FIntIdentificacoesBancarias: TIntIdentificacoesBancarias;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodIdentificacaoBancaria: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;  
  end;

implementation

uses ComServ;

function TIdentificacoesBancarias.EOF: WordBool;
begin
  Result := FIntIdentificacoesBancarias.EOF();
end;

function TIdentificacoesBancarias.Pesquisar(
  CodIdentificacaoBancaria: Integer): Integer;
begin
  Result := FIntIdentificacoesBancarias.Pesquisar(CodIdentificacaoBancaria);
end;

function TIdentificacoesBancarias.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntIdentificacoesBancarias.ValorCampo(NomCampo);
end;

procedure TIdentificacoesBancarias.IrAoPrimeiro;
begin
  FIntIdentificacoesBancarias.IrAoPrimeiro;
end;

procedure TIdentificacoesBancarias.IrAoProximo;
begin
  FIntIdentificacoesBancarias.IrAoProximo;
end;

procedure TIdentificacoesBancarias.AfterConstruction;
begin
  inherited;
end;

procedure TIdentificacoesBancarias.BeforeDestruction;
begin
  inherited;
  if FIntIdentificacoesBancarias <> nil then
  begin
    FIntIdentificacoesBancarias.Free;
  end;
end;

function TIdentificacoesBancarias.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntIdentificacoesBancarias := TIntIdentificacoesBancarias.Create;
  Result := FIntIdentificacoesBancarias.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TIdentificacoesBancarias, Class_IdentificacoesBancarias,
    ciMultiInstance, tmApartment);
end.
