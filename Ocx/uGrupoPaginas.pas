unit uGrupoPaginas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TGrupoPaginas = class(TASPMTSObject, IGrupoPaginas)
  private
    FCodigo : Integer;
    FCodTipoPagina: Integer;
    FDesGrupoPaginas: WideString;
    FDtaFimValidade : TDateTime;
  protected
    function Get_Codigo: Integer; safecall;
    function Get_CodTipoPagina: Integer; safecall;
    function Get_DesGrupoPaginas: WideString; safecall;
    procedure Set_Codigo(Value: Integer); safecall;
    procedure Set_CodTipoPagina(Value: Integer); safecall;
    procedure Set_DesGrupoPaginas(const Value: WideString); safecall;
    function Get_DtaFimValidade: TDateTime; safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;
  public
    property Codigo          : Integer    read FCodigo           write FCodigo         ;
    property CodTipoPagina   : Integer    read FCodTipoPagina    write FCodTipoPagina  ;
    property DesGrupoPaginas : WideString read FDesGrupoPaginas  write FDesGrupoPaginas;
    property DtaFimValidade  : TDateTime  read FDtaFimValidade   write FDtaFimValidade ;
  end;

implementation

uses ComServ;

function TGrupoPaginas.Get_Codigo: Integer;
begin
  Result := FCodigo;
end;

function TGrupoPaginas.Get_CodTipoPagina: Integer;
begin
  Result := FCodTipoPagina;
end;

function TGrupoPaginas.Get_DesGrupoPaginas: WideString;
begin
  Result := FDesGrupoPaginas;
end;

procedure TGrupoPaginas.Set_Codigo(Value: Integer);
begin
  FCodigo := Value;
end;

procedure TGrupoPaginas.Set_CodTipoPagina(Value: Integer);
begin
  FCodTipoPagina := Value;
end;

procedure TGrupoPaginas.Set_DesGrupoPaginas(const Value: WideString);
begin
  FDesGrupoPaginas := Value;
end;

function TGrupoPaginas.Get_DtaFimValidade: TDateTime;
begin
  Result := FDtaFimValidade;
end;

procedure TGrupoPaginas.Set_DtaFimValidade(Value: TDateTime);
begin
  FDtaFimValidade := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrupoPaginas, Class_GrupoPaginas,
    ciMultiInstance, tmApartment);
end.
