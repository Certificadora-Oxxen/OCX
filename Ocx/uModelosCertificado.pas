
unit uModelosCertificado;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntModelosCertificado;

type
  TModelosCertificado = class(TASPMTSObject, IModelosCertificado)
  private
    FIntModelosCertificado: TIntModelosCertificado;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TModelosCertificado.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TModelosCertificado.BeforeDestruction;
begin
  If FIntModelosCertificado <> nil Then Begin
    FIntModelosCertificado.Free;
  End;
  inherited;
end;

function TModelosCertificado.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntModelosCertificado := TIntModelosCertificado.Create;
  Result := FIntModelosCertificado.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TModelosCertificado.EOF: WordBool;
begin
  Result := FIntModelosCertificado.EOF;
end;

function TModelosCertificado.Pesquisar: Integer;
begin
  Result := FIntModelosCertificado.Pesquisar;
end;

function TModelosCertificado.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  Result := FIntModelosCertificado.ValorCampo(NomColuna);
end;

procedure TModelosCertificado.FecharPesquisa;
begin
  FIntModelosCertificado.FecharPesquisa;
end;

procedure TModelosCertificado.IrAoProximo;
begin
  FIntModelosCertificado.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TModelosCertificado, Class_ModelosCertificado,
    ciMultiInstance, tmApartment);
end.
