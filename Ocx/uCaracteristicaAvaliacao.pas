unit uCaracteristicaAvaliacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TCaracteristicaAvaliacao = class(TASPMTSObject, ICaracteristicaAvaliacao)
  Private
    FCodCaracteristica           : Integer;
    FCodTipoAvaliacao            : Integer;
    FCodUnidadeMedida            : Integer;
    FDesTipoAvaliacao            : WideString;
    FSglTipoAvaliacao            : WideString;
    FSglUnidadeMedida            : WideString;
    FDesUnidadeMedida            : WideString;
    FValLimiteMaximo             : Double;
    FValLimiteMinimo             : Double;
    FDesCaracteristica           : WideString;
    FSglCaracteristica           : WideString;
    FIndSexo                     : WideString;
  protected
    function Get_CodCaracteristica: Integer; safecall;
    function Get_CodTipoAvaliacao: Integer; safecall;
    function Get_CodUnidadeMedida: Integer; safecall;
    function Get_DesTipoAvaliacao: WideString; safecall;
    function Get_SglTipoAvaliacao: WideString; safecall;
    function Get_SglUnidadeMedida: WideString; safecall;
    function Get_ValLimiteMinimo: Double; safecall;
    procedure Set_CodCaracteristica(Value: Integer); safecall;
    procedure Set_CodTipoAvaliacao(Value: Integer); safecall;
    procedure Set_CodUnidadeMedida(Value: Integer); safecall;
    procedure Set_DesTipoAvaliacao(const Value: WideString); safecall;
    procedure Set_SglTipoAvaliacao(const Value: WideString); safecall;
    procedure Set_SglUnidadeMedida(const Value: WideString); safecall;
    procedure Set_ValLimiteMinimo(Value: Double); safecall;
    function Get_ValLimiteMaximo: Double; safecall;
    procedure Set_ValLimiteMaximo(Value: Double); safecall;
    function Get_DesCaracteristica: WideString; safecall;
    function Get_SglCaracteristica: WideString; safecall;
    procedure Set_DesCaracteristica(const Value: WideString); safecall;
    procedure Set_SglCaracteristica(const Value: WideString); safecall;
    function Get_DesUnidadeMedida: WideString; safecall;
    procedure Set_DesUnidadeMedida(const Value: WideString); safecall;
    function Get_IndSexo: WideString; safecall;
    procedure Set_IndSexo(const Value: WideString); safecall;
  public
    property CodCaracteristica  : Integer    read FCodCaracteristica  write FCodCaracteristica;
    property CodTipoAvaliacao   : Integer    read FCodTipoAvaliacao   write FCodTipoAvaliacao;
    property CodUnidadeMedida   : Integer    read FCodUnidadeMedida   write FCodUnidadeMedida;
    property DesTipoAvaliacao   : WideString read FDesTipoAvaliacao   write FDesTipoAvaliacao;
    property SglTipoAvaliacao   : WideString read FSglTipoAvaliacao   write FSglTipoAvaliacao;
    property SglUnidadeMedida   : WideString read FSglUnidadeMedida   write FSglUnidadeMedida;
    property DesUnidadeMedida   : WideString read FDesUnidadeMedida   write FDesUnidadeMedida;
    property ValLimiteMaximo    : Double     read FValLimiteMaximo    write FValLimiteMaximo;
    property ValLimiteMinimo    : Double     read FValLimiteMinimo    write FValLimiteMinimo;
    property DesCaracteristica  : WideString  read FDesCaracteristica write FDesCaracteristica;
    property SglCaracteristica  : WideString  read FSglCaracteristica write FSglCaracteristica;
    property IndSexo            : WideString  read FIndSexo           write FIndSexo;
  end;

implementation

uses ComServ;

function TCaracteristicaAvaliacao.Get_CodCaracteristica: Integer;
begin
  Result := FCodCaracteristica;
end;

function TCaracteristicaAvaliacao.Get_CodTipoAvaliacao: Integer;
begin
  Result := FCodTipoAvaliacao;
end;

function TCaracteristicaAvaliacao.Get_CodUnidadeMedida: Integer;
begin
  Result := FCodUnidadeMedida;
end;

function TCaracteristicaAvaliacao.Get_DesTipoAvaliacao: WideString;
begin
  Result := FDesTipoAvaliacao;
end;

function TCaracteristicaAvaliacao.Get_SglTipoAvaliacao: WideString;
begin
  Result := FSglTipoAvaliacao;
end;

function TCaracteristicaAvaliacao.Get_SglUnidadeMedida: WideString;
begin
  Result := FSglUnidadeMedida;
end;

function TCaracteristicaAvaliacao.Get_ValLimiteMinimo: Double;
begin
  Result := FValLimiteMinimo;
end;

procedure TCaracteristicaAvaliacao.Set_CodCaracteristica(Value: Integer);
begin
  FCodCaracteristica := Value;
end;

procedure TCaracteristicaAvaliacao.Set_CodTipoAvaliacao(Value: Integer);
begin
  FCodTipoAvaliacao := Value;
end;

procedure TCaracteristicaAvaliacao.Set_CodUnidadeMedida(Value: Integer);
begin
  FCodUnidadeMedida := Value;
end;

procedure TCaracteristicaAvaliacao.Set_DesTipoAvaliacao(
  const Value: WideString);
begin
  FDesTipoAvaliacao := Value;
end;

procedure TCaracteristicaAvaliacao.Set_SglTipoAvaliacao(
  const Value: WideString);
begin
  FSglTipoAvaliacao := Value;
end;

procedure TCaracteristicaAvaliacao.Set_SglUnidadeMedida(
  const Value: WideString);
begin
  FSglUnidadeMedida := Value;
end;

procedure TCaracteristicaAvaliacao.Set_ValLimiteMinimo(Value: Double);
begin
  FValLimiteMinimo := Value;
end;

function TCaracteristicaAvaliacao.Get_ValLimiteMaximo: Double;
begin
  Result := FValLimiteMaximo;
end;

procedure TCaracteristicaAvaliacao.Set_ValLimiteMaximo(Value: Double);
begin
  FValLimiteMaximo := Value;
end;

function TCaracteristicaAvaliacao.Get_DesCaracteristica: WideString;
begin
  Result := FDesCaracteristica;
end;

function TCaracteristicaAvaliacao.Get_SglCaracteristica: WideString;
begin
  Result := FSglCaracteristica;
end;

procedure TCaracteristicaAvaliacao.Set_DesCaracteristica(
  const Value: WideString);
begin
  FDesCaracteristica := Value;
end;

procedure TCaracteristicaAvaliacao.Set_SglCaracteristica(
  const Value: WideString);
begin
  FSglCaracteristica := Value;
end;

function TCaracteristicaAvaliacao.Get_DesUnidadeMedida: WideString;
begin
  Result := FDesUnidadeMedida;
end;

procedure TCaracteristicaAvaliacao.Set_DesUnidadeMedida(
  const Value: WideString);
begin
  FDesUnidadeMedida := Value;
end;

function TCaracteristicaAvaliacao.Get_IndSexo: WideString;
begin
  Result := FIndSexo;
end;

procedure TCaracteristicaAvaliacao.Set_IndSexo(const Value: WideString);
begin
  FIndSexo := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCaracteristicaAvaliacao, Class_CaracteristicaAvaliacao,
    ciMultiInstance, tmApartment);
end.
