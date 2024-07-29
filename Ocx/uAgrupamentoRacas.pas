unit uAgrupamentoRacas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAgrupamentoRacas = class(TASPMTSObject, IAgrupamentoRacas)
  Private
    FCodAgrupamentoRacas            : Integer;
    FSglAgrupamentoRacas            : WideString;
    FDesAgrupamentoRacas            : WideString;
  protected
    function Get_CodAgrupamentoRacas: Integer; safecall;
    function Get_DesAgrupamentoRacas: WideString; safecall;
    function Get_SglAgrupamentoRacas: WideString; safecall;
    procedure Set_CodAgrupamentoRacas(Value: Integer); safecall;
    procedure Set_DesAgrupamentoRacas(const Value: WideString); safecall;
    procedure Set_SglAgrupamentoRacas(const Value: WideString); safecall;
  public
    property CodAgrupamentoRacas  : Integer     read FCodAgrupamentoRacas   write FCodAgrupamentoRacas;
    property SglAgrupamentoRacas  : WideString  read FSglAgrupamentoRacas   write FSglAgrupamentoRacas;
    property DesAgrupamentoRacas  : WideString  read FDesAgrupamentoRacas   write FDesAgrupamentoRacas;
  end;

implementation

uses ComServ;

function TAgrupamentoRacas.Get_CodAgrupamentoRacas: Integer;
begin
 result := FCodAgrupamentoRacas;
end;

function TAgrupamentoRacas.Get_DesAgrupamentoRacas: WideString;
begin
 result := FDesAgrupamentoRacas;
end;

function TAgrupamentoRacas.Get_SglAgrupamentoRacas: WideString;
begin
 result := FSglAgrupamentoRacas;
end;

procedure TAgrupamentoRacas.Set_CodAgrupamentoRacas(Value: Integer);
begin
  FCodAgrupamentoRacas := value;
end;

procedure TAgrupamentoRacas.Set_DesAgrupamentoRacas(
  const Value: WideString);
begin
  FDesAgrupamentoRacas := value;
end;

procedure TAgrupamentoRacas.Set_SglAgrupamentoRacas(
  const Value: WideString);
begin
  FSglAgrupamentoRacas := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAgrupamentoRacas, Class_AgrupamentoRacas,
    ciMultiInstance, tmApartment);
end.
