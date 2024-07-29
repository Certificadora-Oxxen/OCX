unit uArquivoSisbov;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TArquivoSisbov = class(TASPMTSObject, IArquivoSisbov)
  private
    FCodArquivoSisbov: Integer;
    FNomArquivoSisbov: WideString;
    FDtaCriacaoArquivo: TDateTime;
    FQtdBytesArquivo: Integer;
    FCodTipoArquivoSisbov: Integer;
    FDesTipoArquivoSisbov: WideString;
    FCodUsuario: Integer;
    FNomUsuario: WideString;
    FIndPossuiLogErro: Integer;
    FDtaInsercaoSisbov: TDateTime;
  protected
    function Get_CodArquivoSisbov: Integer; safecall;
    procedure Set_CodArquivoSisbov(Value: Integer); safecall;
    function Get_NomArquivoSisbov: WideString; safecall;
    procedure Set_NomArquivoSisbov(const Value: WideString); safecall;
    function Get_DtaCriacaoArquivo: TDateTime; safecall;
    procedure Set_DtaCriacaoArquivo(Value: TDateTime); safecall;
    function Get_QtdBytesArquivo: Integer; safecall;
    procedure Set_QtdBytesArquivo(Value: Integer); safecall;
    function Get_CodTipoArquivoSisbov: Integer; safecall;
    procedure Set_CodTipoArquivoSisbov(Value: Integer); safecall;
    function Get_DesTipoArquivoSisbov: WideString; safecall;
    procedure Set_DesTipoArquivoSisbov(const Value: WideString); safecall;
    function Get_CodUsuario: Integer; safecall;
    procedure Set_CodUsuario(Value: Integer); safecall;
    function Get_NomUsuario: WideString; safecall;
    procedure Set_NomUsuario(const Value: WideString); safecall;
    function Get_IndPossuiLogErro: Integer; safecall;
    procedure Set_IndPossuiLogErro(Value: Integer); safecall;
    function Get_DtaInsercaoSisbov: TDateTime; safecall;
    procedure Set_DtaInsercaoSisbov(Value: TDateTime); safecall;
  public
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property NomArquivoSisbov: WideString read FNomArquivoSisbov write FNomArquivoSisbov;
    property DtaCriacaoArquivo: TDateTime read FDtaCriacaoArquivo write FDtaCriacaoArquivo;
    property QtdBytesArquivo: Integer read FQtdBytesArquivo write FQtdBytesArquivo;
    property CodTipoArquivoSisbov: Integer read FCodTipoArquivoSisbov write FCodTipoArquivoSisbov;
    property DesTipoArquivoSisbov: WideString read FDesTipoArquivoSisbov write FDesTipoArquivoSisbov;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property NomUsuario: WideString read FNomUsuario write FNomUsuario;
    property IndPossuiLogErro: Integer read FIndPossuiLogerro write FIndPossuiLogErro;
    property DtaInsercaoSisbov: TDateTime read FDtaInsercaoSisbov write FDtaInsercaoSisbov;
  end;

implementation

uses ComServ;

function TArquivoSisbov.Get_CodArquivoSisbov: Integer;
begin
  Result := FCodArquivoSisbov;
end;

procedure TArquivoSisbov.Set_CodArquivoSisbov(Value: Integer);
begin
  FCodArquivoSisbov := Value;
end;

function TArquivoSisbov.Get_NomArquivoSisbov: WideString;
begin
  Result := FNomArquivoSisbov;
end;

procedure TArquivoSisbov.Set_NomArquivoSisbov(const Value: WideString);
begin
  FNomArquivoSisbov := Value;
end;

function TArquivoSisbov.Get_DtaCriacaoArquivo: TDateTime;
begin
  Result := FDtaCriacaoArquivo;
end;

procedure TArquivoSisbov.Set_DtaCriacaoArquivo(Value: TDateTime);
begin
  FDtaCriacaoArquivo := Value;
end;

function TArquivoSisbov.Get_QtdBytesArquivo: Integer;
begin
  Result := FQtdBytesArquivo;
end;

procedure TArquivoSisbov.Set_QtdBytesArquivo(Value: Integer);
begin
  FQtdBytesArquivo := Value;
end;

function TArquivoSisbov.Get_CodTipoArquivoSisbov: Integer;
begin
  Result := FCodTipoArquivoSisbov;
end;

procedure TArquivoSisbov.Set_CodTipoArquivoSisbov(Value: Integer);
begin
  FCodTipoArquivoSisbov := Value;
end;

function TArquivoSisbov.Get_DesTipoArquivoSisbov: WideString;
begin
  Result := FDesTipoArquivoSisbov;
end;

procedure TArquivoSisbov.Set_DesTipoArquivoSisbov(const Value: WideString);
begin
  FDesTipoArquivoSisbov := Value;
end;

function TArquivoSisbov.Get_CodUsuario: Integer;
begin
  Result := FCodUsuario;
end;

procedure TArquivoSisbov.Set_CodUsuario(Value: Integer);
begin
  FCodUsuario := Value;
end;

function TArquivoSisbov.Get_NomUsuario: WideString;
begin
  Result := FNomUsuario;
end;

procedure TArquivoSisbov.Set_NomUsuario(const Value: WideString);
begin
  FNomUsuario := Value;
end;

function TArquivoSisbov.Get_IndPossuiLogErro: Integer;
begin
  Result := FIndPossuiLogErro;
end;

procedure TArquivoSisbov.Set_IndPossuiLogErro(Value: Integer);
begin
  FIndPossuiLogErro := Value;
end;

function TArquivoSisbov.Get_DtaInsercaoSisbov: TDateTime;
begin
  Result := FDtaInsercaoSisbov;
end;

procedure TArquivoSisbov.Set_DtaInsercaoSisbov(Value: TDateTime);
begin
  FDtaInsercaoSisbov := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivoSisbov, Class_ArquivoSisbov,
    ciMultiInstance, tmApartment);
end.
