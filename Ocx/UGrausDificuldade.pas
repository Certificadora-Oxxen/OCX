unit UGrausDificuldade;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntGrausDificuldade;

type
  TGrausDificuldade = class(TASPMTSObject, IGrausDificuldade)
  private
    FIntGrausDificuldade: TIntGrausDificuldade;
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

procedure TGrausDificuldade.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TGrausDificuldade.BeforeDestruction;
begin
  If FIntGrausDificuldade <> nil Then Begin
    FIntGrausDificuldade.Free;
  End;
  inherited;
end;

function TGrausDificuldade.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGrausDificuldade := TIntGrausDificuldade.Create;
  Result := FIntGrausDificuldade.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGrausDificuldade.EOF: WordBool;
begin
  Result := FIntGrausDificuldade.EOF;
end;

function TGrausDificuldade.Pesquisar: Integer;
begin
  Result := FIntGrausDificuldade.Pesquisar;
end;

function TGrausDificuldade.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  Result := FIntGrausDificuldade.ValorCampo(NomColuna);
end;

procedure TGrausDificuldade.FecharPesquisa;
begin
  FIntGrausDificuldade.FecharPesquisa;
end;

procedure TGrausDificuldade.IrAoProximo;
begin
  FIntGrausDificuldade.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrausDificuldade, Class_GrausDificuldade,
    ciMultiInstance, tmApartment);
end.
