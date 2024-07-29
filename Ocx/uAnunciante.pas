unit uAnunciante;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAnunciante = class(TASPMTSObject, IAnunciante)
  private
    FCodigo             : Integer;
    FNomAnunciante      : WideString;
    FTxtEmailAnunciante : WideString;
    FDtaFimValidade     : TDateTime;
  protected
    function  Get_Codigo: Integer; safecall;
    function  Get_NomAnunciante: WideString; safecall;
    function  Get_TxtEmailAnunciante: WideString; safecall;
    procedure Set_Codigo(Value: Integer); safecall;
    procedure Set_NomAnunciante(const Value: WideString); safecall;
    procedure Set_TxtEmailAnunciante(const Value: WideString); safecall;
    function  Get_DtaFimValidade: TDateTime; safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;
  public
    property Codigo             : Integer     read FCodigo              write FCodigo;
    property NomAnunciante      : WideString  read FNomAnunciante       write FNomAnunciante;
    property TxtEmailAnunciante : WideString  read FTxtEmailAnunciante  write FTxtEmailAnunciante;
    property DtaFimValidade     : TDateTime   read FDtaFimValidade      write FDtaFimValidade;
  end;

implementation

uses ComServ;

function TAnunciante.Get_Codigo: Integer;
begin
  Result := FCodigo;
end;

function TAnunciante.Get_NomAnunciante: WideString;
begin
  Result := FNomAnunciante;
end;

function TAnunciante.Get_TxtEmailAnunciante: WideString;
begin
  Result := FTxtEmailAnunciante;
end;

procedure TAnunciante.Set_Codigo(Value: Integer);
begin
  FCodigo := Value;
end;

procedure TAnunciante.Set_NomAnunciante(const Value: WideString);
begin
  FNomAnunciante := Value;
end;

procedure TAnunciante.Set_TxtEmailAnunciante(const Value: WideString);
begin
  FTxtEmailAnunciante := Value;
end;

function TAnunciante.Get_DtaFimValidade: TDateTime;
begin
  Result := FDtaFimValidade;
end;

procedure TAnunciante.Set_DtaFimValidade(Value: TDateTime);
begin
  FDtaFimValidade := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnunciante, Class_Anunciante,
    ciMultiInstance, tmApartment);
end.
