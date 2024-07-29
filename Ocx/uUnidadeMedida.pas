// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Unidade Medida
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    10/09/2002    Criação
// *
// ********************************************************************
unit uUnidadeMedida;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TUnidadeMedida = class(TASPMTSObject, IUnidadeMedida)
  private
    FCodUnidadeMedida : Integer;
    FSglUnidadeMedida : wideString;
    FDesUnidadeMedida : wideString;
  protected
    function Get_CodUnidadeMedida: Integer; safecall;
    function Get_DesUnidadeMedida: WideString; safecall;
    function Get_SglUnidadeMedida: WideString; safecall;
    procedure Set_CodUnidadeMedida(Value: Integer); safecall;
    procedure Set_DesUnidadeMedida(const Value: WideString); safecall;
    procedure Set_SglUnidadeMedida(const Value: WideString); safecall;
  public
    property CodUnidadeMedida        : Integer     read FCodUnidadeMedida       write FCodUnidadeMedida;
    property SglUnidadeMedida        : WideString  read FSglUnidadeMedida       write FSglUnidadeMedida;
    property DesUnidadeMedida        : WideString  read FDesUnidadeMedida       write FDesUnidadeMedida;
  end;

implementation

uses ComServ;

function TUnidadeMedida.Get_CodUnidadeMedida: Integer;
begin
  result := FCodUnidadeMedida;
end;

function TUnidadeMedida.Get_DesUnidadeMedida: WideString;
begin
  result := FDesUnidadeMedida;
end;

function TUnidadeMedida.Get_SglUnidadeMedida: WideString;
begin
  result := FSglUnidadeMedida;
end;

procedure TUnidadeMedida.Set_CodUnidadeMedida(Value: Integer);
begin
  FCodUnidadeMedida := value;
end;

procedure TUnidadeMedida.Set_DesUnidadeMedida(const Value: WideString);
begin
  FDesUnidadeMedida := value;
end;

procedure TUnidadeMedida.Set_SglUnidadeMedida(const Value: WideString);
begin
  FSglUnidadeMedida := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TUnidadeMedida, Class_UnidadeMedida,
    ciMultiInstance, tmApartment);
end.
