unit USubTiposInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMensagens,uConexao,
  uIntSubTiposInsumo,uSubTipoInsumo;

type
  TSubTiposInsumo = class(TASPMTSObject, ISubTiposInsumo)
  private
    FIntSubTiposInsumo : TIntSubTiposInsumo;
    FInicializado      : Boolean;
    FSubTipoInsumo    : TSubTipoInsumo;
  protected
    function Buscar(CodSubTipoInsumo: Integer): Integer; safecall;
    function Pesquisar(CodTipoInsumo: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function Inserir(CodTipoInsumo: Integer; const SglSubTipoInsumo,
      DesSubTipoInsumo: WideString; QtdeIntervaloMinimoAplicacao: Integer;
      const IndSexoAnimalAplicacao: WideString;
      NumOrdem: Integer): Integer; safecall;
    function Excluir(CodSubTipoInsumo: Integer): Integer; safecall;
    function Alterar(CodSubTipoInsumo: Integer; const SglSubTipoInsumo,
      DesSubTipoString: WideString; QtdIntervaloMinimoAplicacao: Integer;
      const IndSexoAnimalAplicacao: WideString;
      NumOrdem: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function Get_SubTipoInsumo: ISubTipoInsumo; safecall;
    function NumeroRegistros: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TSubTiposInsumo.AfterConstruction;
begin
  inherited;
  FSubTipoInsumo := TSubTipoInsumo.Create;
  FSubTipoInsumo.ObjAddRef;
  FInicializado := False;
end;

procedure TSubTiposInsumo.BeforeDestruction;
begin
  If FIntSubTiposInsumo <> nil Then Begin
    FIntSubTiposInsumo.Free;
  End;
  If FSubTipoInsumo <> nil Then Begin
    FSubTipoInsumo.ObjRelease;
    FSubTipoInsumo := nil;
  End;
  inherited;
end;

function TSubTiposInsumo.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntSubTiposInsumo := TIntSubTiposInsumo.Create;
  Result := FIntSubTiposInsumo.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TSubTiposInsumo.Buscar(CodSubTipoInsumo: Integer): Integer;
begin
  result := FIntSubTiposInsumo.Buscar(CodSubTipoInsumo);
end;

function TSubTiposInsumo.Pesquisar(CodTipoInsumo: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntSubTiposInsumo.Pesquisar(CodTipoInsumo,CodOrdenacao);
end;

function TSubTiposInsumo.Inserir(CodTipoInsumo: Integer;
  const SglSubTipoInsumo, DesSubTipoInsumo: WideString;
  QtdeIntervaloMinimoAplicacao: Integer;
  const IndSexoAnimalAplicacao: WideString; NumOrdem: Integer): Integer;
begin
  result := FIntSubTiposInsumo.Inserir(CodTipoInsumo, SglSubTipoInsumo,
            DesSubTipoInsumo, QtdeIntervaloMinimoAplicacao,
            IndSexoAnimalAplicacao, NumOrdem);
end;

function TSubTiposInsumo.Excluir(CodSubTipoInsumo: Integer): Integer;
begin
  result := FIntSubTiposInsumo.Excluir(CodSubTipoInsumo);
end;

function TSubTiposInsumo.Alterar(CodSubTipoInsumo: Integer;
  const SglSubTipoInsumo, DesSubTipoString: WideString;
  QtdIntervaloMinimoAplicacao: Integer;
  const IndSexoAnimalAplicacao: WideString; NumOrdem: Integer): Integer;
begin
  result := FIntSubTiposInsumo.Alterar(CodSubTipoInsumo, SglSubTipoInsumo,
            DesSubTipoString, QtdIntervaloMinimoAplicacao,
            IndSexoAnimalAplicacao, NumOrdem);
end;

function TSubTiposInsumo.EOF: WordBool;
begin
   result := FIntSubTiposInsumo.Eof;
end;

procedure TSubTiposInsumo.IrAoPrimeiro;
begin
   FIntSubTiposInsumo.IrAoPrimeiro;
end;

procedure TSubTiposInsumo.IrAoProximo;
begin
   FIntSubTiposInsumo.IrAoProximo;
end;

function TSubTiposInsumo.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
   result := FIntSubTiposInsumo.ValorCampo(NomCampo);
end;

procedure TSubTiposInsumo.FecharPesquisa;
begin
  FIntSubTiposInsumo.FecharPesquisa;
end;

function TSubTiposInsumo.Get_SubTipoInsumo: ISubTipoInsumo;
begin
  FSubTipoInsumo.CodTipoInsumo                     := FIntSubTiposInsumo.IntSubTipoInsumo.CodTipoInsumo;
  FSubTipoInsumo.SglTipoInsumo                     := FIntSubTiposInsumo.IntSubTipoInsumo.SglTipoInsumo;
  FSubTipoInsumo.DesTipoInsumo                     := FIntSubTiposInsumo.IntSubTipoInsumo.DesTipoInsumo;
  FSubTipoInsumo.CodSubTipoInsumo                  := FIntSubTiposInsumo.IntSubTipoInsumo.CodSubTipoInsumo;
  FSubTipoInsumo.SglSubTipoInsumo                  := FIntSubTiposInsumo.IntSubTipoInsumo.SglSubTipoInsumo;
  FSubTipoInsumo.DesSubTipoInsumo                  := FIntSubTiposInsumo.IntSubTipoInsumo.DesSubTipoInsumo;
  FSubTipoInsumo.QtdIntervaloMinimoAplicacao       := FIntSubTiposInsumo.IntSubTipoInsumo.QtdIntervaloMinimoAplicacao;
  FSubTipoInsumo.IndSexoAnimalAplicacao            := FIntSubTiposInsumo.IntSubTipoInsumo.IndSexoAnimalAplicacao;
  FSubTipoInsumo.NumOrdem                          := FIntSubTiposInsumo.IntSubTipoInsumo.NumOrdem;
  result := FSubTipoInsumo;
end;

function TSubTiposInsumo.NumeroRegistros: Integer;
begin
   result := FIntSubTiposInsumo.NumeroRegistros;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSubTiposInsumo, Class_SubTiposInsumo,
    ciMultiInstance, tmApartment);
end.
