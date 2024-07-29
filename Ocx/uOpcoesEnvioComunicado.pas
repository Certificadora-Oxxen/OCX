unit uOpcoesEnvioComunicado;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntOpcoesEnvioComunicado;

type
  TOpcoesEnvioComunicado = class(TASPMTSObject, IOpcoesEnvioComunicado)
  private
    FIntOpcoesEnvioComunicado : TIntOpcoesEnvioComunicado;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Pesquisar(CodPapel: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TOpcoesEnvioComunicado.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TOpcoesEnvioComunicado.BeforeDestruction;
begin
  If FIntOpcoesEnvioComunicado <> nil Then Begin
    FIntOpcoesEnvioComunicado.Free;
  End;
  inherited;
end;

function TOpcoesEnvioComunicado.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntOpcoesEnvioComunicado := TIntOpcoesEnvioComunicado.Create;
  Result := FIntOpcoesEnvioComunicado.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TOpcoesEnvioComunicado.EOF: WordBool;
begin
  Result := FIntOpcoesEnvioComunicado.EOF;
end;

function TOpcoesEnvioComunicado.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntOpcoesEnvioComunicado.ValorCampo(NomCampo);
end;

procedure TOpcoesEnvioComunicado.FecharPesquisa;
begin
  FIntOpcoesEnvioComunicado.FecharPesquisa;
end;

procedure TOpcoesEnvioComunicado.IrAoProximo;
begin
  FIntOpcoesEnvioComunicado.IrAoProximo;
end;

function TOpcoesEnvioComunicado.Pesquisar(CodPapel: Integer): Integer;
begin
  Result := FIntOpcoesEnvioComunicado.Pesquisar(CodPapel);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOpcoesEnvioComunicado, Class_OpcoesEnvioComunicado,
    ciMultiInstance, tmApartment);
end.
