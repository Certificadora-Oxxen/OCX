// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       : 
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Tipo de Insumo - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit UTipoInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTipoInsumo = class(TASPMTSObject, ITipoInsumo)
  private
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:WideString;
    FDesTipoInsumo:WideString;
    FIndSubTipoObrigatorio:WideString;
    FIndAdmitePartidaLote:WideString;
    FIndRestritoSistema:WideString;
    FCodSubEventoSanitario:Integer;
    FSglSubEventoSanitario:WideString;
    FDesSubEventoSanitario:WideString;
    FQtdIntervaloMinimoAplicacao:Integer;
    FNumOrdem:Integer;
  protected
    function Get_CodTipoInsumo: Integer; safecall;
    procedure Set_CodTipoInsumo(Value: Integer); safecall;
    function Get_SglTipoInsumo: WideString; safecall;
    procedure Set_SglTipoInsumo(const Value: WideString); safecall;
    function Get_DesTipoInsumo: WideString; safecall;
    procedure Set_DesTipoInsumo(const Value: WideString); safecall;
    function Get_IndSubTipoObrigatorio: WideString; safecall;
    procedure Set_IndSubTipoObrigatorio(const Value: WideString); safecall;
    function Get_IndAdmitePartidaLote: WideString; safecall;
    procedure Set_IndAdmitePartidaLote(const Value: WideString); safecall;
    function Get_CodSubEventoSanitario: Integer; safecall;
    function Get_DesSubEventoSanitario: WideString; safecall;
    function Get_IndRestritoSistema: WideString; safecall;
    function Get_NumOrdem: Integer; safecall;
    function Get_QtdIntervaloMinimoAplicacao: Integer; safecall;
    function Get_SglSubEventoSanitario: WideString; safecall;
    procedure Set_CodSubEventoSanitario(Value: Integer); safecall;
    procedure Set_DesSubEventoSanitario(const Value: WideString); safecall;
    procedure Set_IndRestritoSistema(const Value: WideString); safecall;
    procedure Set_NumOrdem(Value: Integer); safecall;
    procedure Set_QtdIntervaloMinimoAplicacao(Value: Integer); safecall;
    procedure Set_SglSubEventoSanitario(const Value: WideString); safecall;
  public
    property CodTipoInsumo                      : Integer     read FCodTipoInsumo               write FCodTipoInsumo;
    property SglTipoInsumo                      : WideString  read FSglTipoInsumo               write FSglTipoInsumo;
    property DesTipoInsumo                      : WideString  read FDesTipoInsumo               write FDesTipoInsumo;
    property IndSubTipoObrigatorio              : WideString  read FIndSubTipoObrigatorio       write FIndSubTipoObrigatorio;
    property IndAdmitePartidaLote               : WideString  read FIndAdmitePartidaLote        write FIndAdmitePartidaLote;
    property IndRestritoSistema                 : WideString  read FIndRestritoSistema          write FIndRestritoSistema;
    property CodSubEventoSanitario              : Integer     read FCodSubEventoSanitario       write FCodSubEventoSanitario;
    property SglSubEventoSanitario              : WideString  read FSglSubEventoSanitario       write FSglSubEventoSanitario;
    property DesSubEventoSanitario              : WideString  read FDesSubEventoSanitario       write FDesSubEventoSanitario;
    property QtdIntervaloMinimoAplicacao        : Integer     read FQtdIntervaloMinimoAplicacao write FQtdIntervaloMinimoAplicacao;
    property NumOrdem                           : Integer     read FNumOrdem                    write FNumOrdem;
  end;

implementation

uses ComServ;

function TTipoInsumo.Get_CodTipoInsumo: Integer;
begin
  result := FCodTipoInsumo;
end;

procedure TTipoInsumo.Set_CodTipoInsumo(Value: Integer);
begin
  FCodTipoInsumo := Value;
end;

function TTipoInsumo.Get_SglTipoInsumo: WideString;
begin
  result := FSglTipoInsumo;
end;

procedure TTipoInsumo.Set_SglTipoInsumo(const Value: WideString);
begin
  FSglTipoInsumo := Value;
end;

function TTipoInsumo.Get_DesTipoInsumo: WideString;
begin
  result := FDesTipoInsumo;
end;

procedure TTipoInsumo.Set_DesTipoInsumo(const Value: WideString);
begin
  FDesTipoInsumo := Value;
end;

function TTipoInsumo.Get_IndSubTipoObrigatorio: WideString;
begin
  result := FIndSubTipoObrigatorio;
end;

procedure TTipoInsumo.Set_IndSubTipoObrigatorio(const Value: WideString);
begin
  FIndSubTipoObrigatorio := Value;
end;

function TTipoInsumo.Get_IndAdmitePartidaLote: WideString;
begin
  result := FIndAdmitePartidaLote;
end;

procedure TTipoInsumo.Set_IndAdmitePartidaLote(const Value: WideString);
begin
  FIndAdmitePartidaLote := Value;
end;

function TTipoInsumo.Get_CodSubEventoSanitario: Integer;
begin
  result := FCodSubEventoSanitario;
end;

function TTipoInsumo.Get_DesSubEventoSanitario: WideString;
begin
  result := FDesSubEventoSanitario;
end;

function TTipoInsumo.Get_IndRestritoSistema: WideString;
begin
  result := FIndRestritoSistema;
end;

function TTipoInsumo.Get_NumOrdem: Integer;
begin
  result := FNumOrdem;
end;

function TTipoInsumo.Get_QtdIntervaloMinimoAplicacao: Integer;
begin
  result := FQtdIntervaloMinimoAplicacao;
end;

function TTipoInsumo.Get_SglSubEventoSanitario: WideString;
begin
  result := FSglSubEventoSanitario;
end;

procedure TTipoInsumo.Set_CodSubEventoSanitario(Value: Integer);
begin
  FCodSubEventoSanitario := Value;
end;

procedure TTipoInsumo.Set_DesSubEventoSanitario(const Value: WideString);
begin
  FDesSubEventoSanitario := Value;
end;

procedure TTipoInsumo.Set_IndRestritoSistema(const Value: WideString);
begin
  FIndRestritoSistema := Value;
end;

procedure TTipoInsumo.Set_NumOrdem(Value: Integer);
begin
  FNumOrdem := Value;
end;

procedure TTipoInsumo.Set_QtdIntervaloMinimoAplicacao(Value: Integer);
begin
  FQtdIntervaloMinimoAplicacao := Value;
end;

procedure TTipoInsumo.Set_SglSubEventoSanitario(const Value: WideString);
begin
  FSglSubEventoSanitario := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoInsumo, Class_TipoInsumo,
    ciMultiInstance, tmApartment);
end.
