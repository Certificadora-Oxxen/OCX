unit UTiposInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposInsumo,uTipoInsumo;

type
  TTiposInsumo = class(TASPMTSObject, ITiposInsumo)
  private
    FIntTiposInsumo : TIntTiposInsumo;
    FInicializado   : Boolean;
    FTipoInsumo     : TTipoInsumo;
  protected
    function Buscar(CodTipoInsumo: Integer): Integer; safecall;
    function Inserir(const SglTipoInsumo, DesTipoInsumo, IndSubTipoObrigatorio,
      IndAdmitePartidaLote: WideString; NumOrdem: Integer): Integer;
      safecall;
    function Alterar(CodTipoInsumo: Integer; const SglTipoInsumo,
      DesTipoInsumo: WideString; QtdIntervaloMinimoAplicacao,
      NumOrdem: Integer): Integer; safecall;
    function Excluir(CodTipoInsumo: Integer): Integer; safecall;
    function Pesquisar(CodSubEventoSanitario: Integer; const CodOrdenacao,
      IndSubEventoSanitario: WideString): Integer; safecall;
    function AdicionarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer; safecall;
    function RetirarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer; safecall;
    function PesquisarUnidadesMedida(CodTipoInsumo: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function Get_TipoInsumo: ITipoInsumo; safecall;
    function NumeroRegistros: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposInsumo.AfterConstruction;
begin
  inherited;
  FTipoInsumo := TTipoInsumo.Create;
  FTipoInsumo.ObjAddRef;
  FInicializado := False;
end;

procedure TTiposInsumo.BeforeDestruction;
begin
  If FIntTiposInsumo <> nil Then Begin
    FIntTiposInsumo.Free;
  End;
  If FTipoInsumo <> nil Then Begin
    FTipoInsumo.ObjRelease;
    FTipoInsumo := nil;
  End;
  inherited;
end;

function TTiposInsumo.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposInsumo := TIntTiposInsumo.Create;
  Result := FIntTiposInsumo.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposInsumo.Buscar(CodTipoInsumo: Integer): Integer;
begin
   result := FIntTiposInsumo.Buscar(CodTipoInsumo);
end;

function TTiposInsumo.Inserir(const SglTipoInsumo, DesTipoInsumo,
  IndSubTipoObrigatorio, IndAdmitePartidaLote: WideString;
  NumOrdem: Integer): Integer;
begin
   result := FIntTiposInsumo.Inserir(SglTipoInsumo, DesTipoInsumo,
             IndSubTipoObrigatorio, IndAdmitePartidaLote, NumOrdem);
end;

function TTiposInsumo.Alterar(CodTipoInsumo: Integer; const SglTipoInsumo,
  DesTipoInsumo: WideString; QtdIntervaloMinimoAplicacao,
  NumOrdem: Integer): Integer;
begin
   result := FIntTiposInsumo.Alterar(CodTipoInsumo,SglTipoInsumo,
             DesTipoInsumo,QtdIntervaloMinimoAplicacao, NumOrdem);
end;

function TTiposInsumo.Excluir(CodTipoInsumo: Integer): Integer;
begin
   result := FIntTiposInsumo.Excluir(CodTipoInsumo);
end;

function TTiposInsumo.Pesquisar(CodSubEventoSanitario: Integer;
  const CodOrdenacao, IndSubEventoSanitario: WideString): Integer;
begin
   result := FIntTiposInsumo.Pesquisar(CodSubEventoSanitario,CodOrdenacao,IndSubEventoSanitario);
end;

function TTiposInsumo.AdicionarUnidadeMedida(CodTipoInsumo,
  CodUnidadeMedida: Integer): Integer;
begin
   result := FIntTiposInsumo.AdicionarUnidadeMedida(CodTipoInsumo,
   CodUnidadeMedida);
end;

function TTiposInsumo.RetirarUnidadeMedida(CodTipoInsumo,
  CodUnidadeMedida: Integer): Integer;
begin
   result := FIntTiposInsumo.RetirarUnidadeMedida(CodTipoInsumo,
   CodUnidadeMedida);
end;

function TTiposInsumo.PesquisarUnidadesMedida(CodTipoInsumo: Integer;
  const CodOrdenacao: WideString): Integer;
begin
   result := FIntTiposInsumo.PesquisarUnidadesMedida(CodTipoInsumo,
   CodOrdenacao);
end;

function TTiposInsumo.EOF: WordBool;
begin
   result := FIntTiposInsumo.Eof;
end;

function TTiposInsumo.ValorCampo(const NomCampo: WideString): OleVariant;
begin
   result := FIntTiposInsumo.ValorCampo(NomCampo);
end;

procedure TTiposInsumo.FecharPesquisa;
begin
  FIntTiposInsumo.FecharPesquisa;
end;

procedure TTiposInsumo.IrAoPrimeiro;
begin
   FIntTiposInsumo.IrAoPrimeiro;
end;

procedure TTiposInsumo.IrAoProximo;
begin
   FIntTiposInsumo.IrAoProximo;
end;

function TTiposInsumo.Get_TipoInsumo: ITipoInsumo;
begin
  FTipoInsumo.CodTipoInsumo                     := FIntTiposInsumo.IntTipoInsumo.CodTipoInsumo;
  FTipoInsumo.SglTipoInsumo                     := FIntTiposInsumo.IntTipoInsumo.SglTipoInsumo;
  FTipoInsumo.DesTipoInsumo                     := FIntTiposInsumo.IntTipoInsumo.DesTipoInsumo;
  FTipoInsumo.IndSubTipoObrigatorio             := FIntTiposInsumo.IntTipoInsumo.IndSubTipoObrigatorio;
  FTipoInsumo.IndAdmitePartidaLote              := FIntTiposInsumo.IntTipoInsumo.IndAdmitePartidaLote;
  FTipoInsumo.IndRestritoSistema                := FIntTiposInsumo.IntTipoInsumo.IndRestritoSistema;
  FTipoInsumo.CodSubEventoSanitario             := FIntTiposInsumo.IntTipoInsumo.CodSubEventoSanitario;
  FTipoInsumo.SglSubEventoSanitario             := FIntTiposInsumo.IntTipoInsumo.SglSubEventoSanitario;
  FTipoInsumo.DesSubEventoSanitario             := FIntTiposInsumo.IntTipoInsumo.DesSubEventoSanitario;
  FTipoInsumo.QtdIntervaloMinimoAplicacao       := FIntTiposInsumo.IntTipoInsumo.QtdIntervaloMinimoAplicacao;
  FTipoInsumo.NumOrdem                          := FIntTiposInsumo.IntTipoInsumo.NumOrdem;
  result := FTipoInsumo;
end;

function TTiposInsumo.NumeroRegistros: Integer;
begin
  result := FIntTiposInsumo.NumeroRegistros;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposInsumo, Class_TiposInsumo,
    ciMultiInstance, tmApartment);
end.
