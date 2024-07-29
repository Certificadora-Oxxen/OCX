unit uTipoOrigemArqImport;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTipoOrigemArqImport = class(TASPMTSObject, ITipoOrigemArqImport)
  private
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: WideString;
    FDesTipoOrigemArqImport: WideString;
  protected
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    function Get_SglCodTipoOrigemArqImport: WideString; safecall;
    procedure Set_CodTipoOrigemArqImport(Value: Integer); safecall;
    procedure Set_DesTipoOrigemArqImport(const Value: WideString); safecall;
    procedure Set_SglCodTipoOrigemArqImport(const Value: WideString); safecall;
  public
    property CodTipoOrigemArqImport: Integer  read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: WideString  read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: WideString  read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;

  end;

implementation

uses ComServ;

function TTipoOrigemArqImport.Get_CodTipoOrigemArqImport: Integer;
begin
   Result := FCodTipoOrigemArqImport;
end;

function TTipoOrigemArqImport.Get_DesTipoOrigemArqImport: WideString;
begin
   Result := FSglTipoOrigemArqImport;
end;

function TTipoOrigemArqImport.Get_SglCodTipoOrigemArqImport: WideString;
begin
   Result := FDesTipoOrigemArqImport;
end;

procedure TTipoOrigemArqImport.Set_CodTipoOrigemArqImport(Value: Integer);
begin
   FCodTipoOrigemArqImport := Value;
end;

procedure TTipoOrigemArqImport.Set_DesTipoOrigemArqImport(
  const Value: WideString);
begin
   FSglTipoOrigemArqImport := Value;
end;

procedure TTipoOrigemArqImport.Set_SglCodTipoOrigemArqImport(
  const Value: WideString);
begin
   FDesTipoOrigemArqImport := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoOrigemArqImport, Class_TipoOrigemArqImport,
    ciMultiInstance, tmApartment);
end.
