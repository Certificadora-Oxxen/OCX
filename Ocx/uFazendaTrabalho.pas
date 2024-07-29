unit uFazendaTrabalho;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TFazendaTrabalho = class(TASPMTSObject, IFazendaTrabalho)
  private
    FCodFazenda : Integer;
    FSglFazenda : WideString;
    FNomFazenda : WideString;
    FDataUltimaVistoria : WideString;
    FStatusVistoria : WideString;
  protected
    function Get_CodFazenda: Integer; safecall;
    function Get_NomFazenda: WideString; safecall;
    function Get_SglFazenda: WideString; safecall;

    function Get_DataUltimaVistoria: WideString; safecall;
    function Get_StatusVistoria: WideString; safecall;

    procedure Set_CodFazenda(Value: Integer); safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;

    procedure Set_DataUltimaVistoria(const Value: WideString); safecall;
    procedure Set_StatusVistoria(const Value: WideString); safecall;
  public
    property CodFazenda: Integer            read FCodFazenda         write FCodFazenda;
    property SglFazenda: WideString         read FSglFazenda         write FSglFazenda;
    property NomFazenda: WideString         read FNomFazenda         write FNomFazenda;
    property DataUltimaVistoria: WideString read FDataUltimaVistoria write FDataUltimaVistoria;
    property StatusVistoria: WideString     read FStatusVistoria     write FStatusVistoria;
  end;

implementation

uses ComServ;

function TFazendaTrabalho.Get_CodFazenda: Integer;
begin
  Result := FCodFazenda;
end;

function TFazendaTrabalho.Get_DataUltimaVistoria: WideString;
begin
  Result := FDataUltimaVistoria;
end;

function TFazendaTrabalho.Get_NomFazenda: WideString;
begin
  Result := FNomFazenda;
end;

function TFazendaTrabalho.Get_SglFazenda: WideString;
begin
  Result := FSglFazenda;
end;

function TFazendaTrabalho.Get_StatusVistoria: WideString;
begin
  Result := FStatusVistoria;
end;

procedure TFazendaTrabalho.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := Value;
end;

procedure TFazendaTrabalho.Set_DataUltimaVistoria(const Value: WideString);
begin
  FDataUltimaVistoria := Value;
end;

procedure TFazendaTrabalho.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := Value;
end;

procedure TFazendaTrabalho.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := Value;
end;

procedure TFazendaTrabalho.Set_StatusVistoria(const Value: WideString);
begin
  FStatusVistoria := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFazendaTrabalho, Class_FazendaTrabalho,
    ciMultiInstance, tmApartment);
end.
