unit uTipoAgrupamentoRacas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTipoAgrupamentoRacas = class(TASPMTSObject, ITipoAgrupamentoRacas)
  Private
    FCodTipoAgrupamentoRacas            : Integer;
    FSglTipoAgrupamentoRacas            : WideString;
    FDesTipoAgrupamentoRacas            : WideString;
  protected
    function Get_CodTipoAgrupamentoRacas: Integer; safecall;
    function Get_DesTipoAgrupamentoRacas: WideString; safecall;
    function Get_SglTipoAgrupamentoRacas: WideString; safecall;
    procedure Set_CodTipoAgrupamentoRacas(Value: Integer); safecall;
    procedure Set_DesTipoAgrupamentoRacas(const Value: WideString); safecall;
    procedure Set_SglTipoAgrupamentoRacas(const Value: WideString); safecall;
  public
    property CodTipoAgrupamentoRacas  : Integer     read FCodTipoAgrupamentoRacas   write FCodTipoAgrupamentoRacas;
    property SglTipoAgrupamentoRacas  : WideString  read FSglTipoAgrupamentoRacas   write FSglTipoAgrupamentoRacas;
    property DesTipoAgrupamentoRacas  : WideString  read FDesTipoAgrupamentoRacas   write FDesTipoAgrupamentoRacas;
  end;

implementation

uses ComServ;

function TTipoAgrupamentoRacas.Get_CodTipoAgrupamentoRacas: Integer;
begin
 result := FCodTipoAgrupamentoRacas;
end;

function TTipoAgrupamentoRacas.Get_DesTipoAgrupamentoRacas: WideString;
begin
 result := FDesTipoAgrupamentoRacas;
end;

function TTipoAgrupamentoRacas.Get_SglTipoAgrupamentoRacas: WideString;
begin
 result := FSglTipoAgrupamentoRacas;
end;

procedure TTipoAgrupamentoRacas.Set_CodTipoAgrupamentoRacas(
  Value: Integer);
begin
  FCodTipoAgrupamentoRacas := value;
end;

procedure TTipoAgrupamentoRacas.Set_DesTipoAgrupamentoRacas(
  const Value: WideString);
begin
  FDesTipoAgrupamentoRacas := value;
end;

procedure TTipoAgrupamentoRacas.Set_SglTipoAgrupamentoRacas(
  const Value: WideString);
begin
  FSglTipoAgrupamentoRacas := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoAgrupamentoRacas, Class_TipoAgrupamentoRacas,
    ciMultiInstance, tmApartment);
end.
