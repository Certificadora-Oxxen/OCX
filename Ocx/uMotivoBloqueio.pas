unit uMotivoBloqueio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TMotivoBloqueio = class(TASPMTSObject, IMotivoBloqueio)
  private
    FCodMotivoBloqueio: Integer;
    FDesMotivoBloqueio: WideString;
    FTxtMotivoUsuario: WideString;
    FTxtObservacaoUsuario: WideString;
    FTxtProcedimentoUsuario: WideString;
    FCodAplicacaoBloqueio: WideString;
    FDesAplicacaoBloqueio: WideString;
    FIndRestritoSistema: WideString;
  protected
    function Get_CodAplicacaoBloqueio: WideString; safecall;
    function Get_CodMotivoBloqueio: Integer; safecall;
    function Get_DesAplicacaoBloqueio: WideString; safecall;
    function Get_DesMotivoBloqueio: WideString; safecall;
    function Get_IndRestritoSistema: WideString; safecall;
    function Get_TxtMotivoUsuario: WideString; safecall;
    function Get_TxtObservacaoUsuario: WideString; safecall;
    function Get_TxtProcedimentoUsuario: WideString; safecall;
    procedure Set_CodAplicacaoBloqueio(const Value: WideString); safecall;
    procedure Set_CodMotivoBloqueio(Value: Integer); safecall;
    procedure Set_DesAplicacaoBloqueio(const Value: WideString); safecall;
    procedure Set_DesMotivoBloqueio(const Value: WideString); safecall;
    procedure Set_IndRestritoSistema(const Value: WideString); safecall;
    procedure Set_TxtMotivoUsuario(const Value: WideString); safecall;
    procedure Set_TxtObservacaoUsuario(const Value: WideString); safecall;
    procedure Set_TxtProcedimentoUsuario(const Value: WideString); safecall;
  public
    property CodMotivoBloqueio: Integer read FCodMotivoBloqueio write FCodMotivoBloqueio;
    property DesMotivoBloqueio: WideString read FDesMotivoBloqueio write FDesMotivoBloqueio;
    property TxtMotivoUsuario: WideString read FTxtMotivoUsuario write FTxtMotivoUsuario;
    property TxtObservacaoUsuario: WideString read FTxtObservacaoUsuario write FTxtObservacaoUsuario;
    property TxtProcedimentoUsuario: WideString read FTxtProcedimentoUsuario write FTxtProcedimentoUsuario;
    property CodAplicacaoBloqueio: WideString read FCodAplicacaoBloqueio write FCodAplicacaoBloqueio;
    property DesAplicacaoBloqueio: WideString read FDesAplicacaoBloqueio write FDesAplicacaoBloqueio;
    property IndRestritoSistema: WideString read FIndRestritoSistema write FIndRestritoSistema;
  end;

implementation

uses ComServ;

function TMotivoBloqueio.Get_CodAplicacaoBloqueio: WideString;
begin
  Result := FCodAplicacaoBloqueio;
end;

function TMotivoBloqueio.Get_CodMotivoBloqueio: Integer;
begin
  Result := FCodMotivoBloqueio;
end;

function TMotivoBloqueio.Get_DesAplicacaoBloqueio: WideString;
begin
  Result := FDesAplicacaoBloqueio;
end;

function TMotivoBloqueio.Get_DesMotivoBloqueio: WideString;
begin
  Result := FDesMotivoBloqueio;
end;

function TMotivoBloqueio.Get_IndRestritoSistema: WideString;
begin
  Result := FIndRestritoSistema;
end;

function TMotivoBloqueio.Get_TxtMotivoUsuario: WideString;
begin
  Result := FTxtMotivoUsuario;
end;

function TMotivoBloqueio.Get_TxtObservacaoUsuario: WideString;
begin
  Result := FTxtObservacaoUsuario;
end;

function TMotivoBloqueio.Get_TxtProcedimentoUsuario: WideString;
begin
  Result := FTxtProcedimentoUsuario;
end;

procedure TMotivoBloqueio.Set_CodAplicacaoBloqueio(
  const Value: WideString);
begin
  FCodAplicacaoBloqueio := Value;
end;

procedure TMotivoBloqueio.Set_CodMotivoBloqueio(Value: Integer);
begin
  FCodMotivoBloqueio := Value;
end;

procedure TMotivoBloqueio.Set_DesAplicacaoBloqueio(
  const Value: WideString);
begin
  FDesAplicacaoBloqueio := Value;
end;

procedure TMotivoBloqueio.Set_DesMotivoBloqueio(const Value: WideString);
begin
 FDesMotivoBloqueio := Value;
end;

procedure TMotivoBloqueio.Set_IndRestritoSistema(const Value: WideString);
begin
  FIndRestritoSistema := Value;
end;

procedure TMotivoBloqueio.Set_TxtMotivoUsuario(const Value: WideString);
begin
  FTxtMotivoUsuario := Value;
end;

procedure TMotivoBloqueio.Set_TxtObservacaoUsuario(
  const Value: WideString);
begin
  FTxtObservacaoUsuario := Value;
end;

procedure TMotivoBloqueio.Set_TxtProcedimentoUsuario(
  const Value: WideString);
begin
 FTxtProcedimentoUsuario := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMotivoBloqueio, Class_MotivoBloqueio,
    ciMultiInstance, tmApartment);
end.
