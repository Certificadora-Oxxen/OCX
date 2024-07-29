unit uTipoAvaliacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTipoAvaliacao = class(TASPMTSObject, ITipoAvaliacao)
  Private
    FCodTipoAvaliacao            : Integer;
    FSglTipoAvaliacao            : WideString;
    FDesTipoAvaliacao            : WideString;
  protected
    function Get_CodTipoAvaliacao: Integer; safecall;
    function Get_SglTipoAvaliacao: WideString; safecall;
    procedure Set_CodTipoAvaliacao(Value: Integer); safecall;
    procedure Set_SglTipoAvaliacao(const Value: WideString); safecall;
    function Get_DesTipoAvaliacao: WideString; safecall;
    procedure Set_DesTipoAvaliacao(const Value: WideString); safecall;
  public
    property CodTipoAvaliacao  : Integer     read FCodTipoAvaliacao   write FCodTipoAvaliacao;
    property SglTipoAvaliacao  : WideString  read FSglTipoAvaliacao   write FSglTipoAvaliacao;
    property DesTipoAvaliacao  : WideString  read FDesTipoAvaliacao   write FDesTipoAvaliacao;
  end;

implementation

uses ComServ;

function TTipoAvaliacao.Get_CodTipoAvaliacao: Integer;
begin
  Result := FCodTipoAvaliacao;
end;

function TTipoAvaliacao.Get_SglTipoAvaliacao: WideString;
begin
  Result := FSglTipoAvaliacao;
end;

procedure TTipoAvaliacao.Set_CodTipoAvaliacao(Value: Integer);
begin
  FCodTipoAvaliacao := Value;
end;

procedure TTipoAvaliacao.Set_SglTipoAvaliacao(const Value: WideString);
begin
  FSglTipoAvaliacao := Value;
end;

function TTipoAvaliacao.Get_DesTipoAvaliacao: WideString;
begin
  Result := FDesTipoAvaliacao;
end;

procedure TTipoAvaliacao.Set_DesTipoAvaliacao(const Value: WideString);
begin
  FDesTipoAvaliacao := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoAvaliacao, Class_TipoAvaliacao,
    ciMultiInstance, tmApartment);
end.
