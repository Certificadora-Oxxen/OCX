unit uLargurasLinhaRelatorio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntLargurasLinhaRelatorio;

type
  TLargurasLinhaRelatorio = class(TASPMTSObject, ILargurasLinhaRelatorio)
  private
    FIntLargurasLinhaRelatorio: TIntLargurasLinhaRelatorio;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TLargurasLinhaRelatorio.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TLargurasLinhaRelatorio.BeforeDestruction;
begin
  If FIntLargurasLinhaRelatorio <> nil Then Begin
    FIntLargurasLinhaRelatorio.Free;
  End;
  inherited;
end;

function TLargurasLinhaRelatorio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntLargurasLinhaRelatorio := TIntLargurasLinhaRelatorio.Create;
  Result := FIntLargurasLinhaRelatorio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TLargurasLinhaRelatorio.EOF: WordBool;
begin
  Result := FIntLargurasLinhaRelatorio.EOF;
end;

function TLargurasLinhaRelatorio.Pesquisar: Integer;
begin
  Result := FIntLargurasLinhaRelatorio.Pesquisar;
end;

function TLargurasLinhaRelatorio.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntLargurasLinhaRelatorio.ValorCampo(NomCampo);
end;

procedure TLargurasLinhaRelatorio.FecharPesquisa;
begin
  FIntLargurasLinhaRelatorio.FecharPesquisa;
end;

procedure TLargurasLinhaRelatorio.IrAoProximo;
begin
  FIntLargurasLinhaRelatorio.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLargurasLinhaRelatorio, Class_LargurasLinhaRelatorio,
    ciMultiInstance, tmApartment);
end.
