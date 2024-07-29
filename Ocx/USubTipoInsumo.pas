// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       : 
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Tipo de Insumo - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit USubTipoInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TSubTipoInsumo = class(TASPMTSObject, ISubTipoInsumo)
  private
    FCodSubTipoInsumo:Integer;
    FSglSubTipoInsumo:WideString;
    FDesSubTipoInsumo:WideString;
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:WideString;
    FDesTipoInsumo:WideString;
    FQtdIntervaloMinimoAplicacao:Integer;
    FIndSexoAnimalAplicacao:WideString;
    FNumOrdem:Integer;
  protected
    function Get_CodSubTipoInsumo: Integer; safecall;
    function Get_DesSubTipoInsumo: WideString; safecall;
    function Get_SglSubTipoInsumo: WideString; safecall;
    procedure Set_CodSubTipoInsumo(Value: Integer); safecall;
    procedure Set_DesSubTipoInsumo(const Value: WideString); safecall;
    procedure Set_SglSubTipoInsumo(const Value: WideString); safecall;
    function Get_CodTipoInsumo: Integer; safecall;
    function Get_DesTipoInsumo: WideString; safecall;
    function Get_SglTipoInsumo: WideString; safecall;
    procedure Set_CodTipoInsumo(Value: Integer); safecall;
    procedure Set_DesTipoInsumo(const Value: WideString); safecall;
    procedure Set_SglTipoInsumo(const Value: WideString); safecall;
    function Get_QtdIntervaloMinimoAplicacao: Integer; safecall;
    procedure Set_QtdIntervaloMinimoAplicacao(Value: Integer); safecall;
    function Get_IndSexoAnimalAplicacao: WideString; safecall;
    function Get_NumOrdem: Integer; safecall;
    procedure Set_IndSexoAnimalAplicacao(const Value: WideString); safecall;
    procedure Set_NumOrdem(Value: Integer); safecall;
  public
    property CodSubTipoInsumo                   : Integer     read FCodSubTipoInsumo            write FCodSubTipoInsumo;
    property SglSubTipoInsumo                   : WideString  read FSglSubTipoInsumo            write FSglSubTipoInsumo;
    property DesSubTipoInsumo                   : WideString  read FDesSubTipoInsumo            write FDesSubTipoInsumo;
    property CodTipoInsumo                      : Integer     read FCodTipoInsumo               write FCodTipoInsumo;
    property SglTipoInsumo                      : WideString  read FSglTipoInsumo               write FSglTipoInsumo;
    property DesTipoInsumo                      : WideString  read FDesTipoInsumo               write FDesTipoInsumo;
    property QtdIntervaloMinimoAplicacao        : Integer     read FQtdIntervaloMinimoAplicacao write FQtdIntervaloMinimoAplicacao;
    property IndSexoAnimalAplicacao             : WideString  read FIndSexoAnimalAplicacao      write FIndSexoAnimalAplicacao;
    property NumOrdem                           : Integer     read FNumOrdem                    write FNumOrdem;
  end;

implementation

uses ComServ;

function TSubTipoInsumo.Get_CodSubTipoInsumo: Integer;
begin
  result := FCodSubTipoInsumo;
end;

function TSubTipoInsumo.Get_DesSubTipoInsumo: WideString;
begin
  result := FDesSubTipoInsumo;
end;

function TSubTipoInsumo.Get_SglSubTipoInsumo: WideString;
begin
  result := FSglSubTipoInsumo;
end;

procedure TSubTipoInsumo.Set_CodSubTipoInsumo(Value: Integer);
begin
  FCodSubTipoInsumo := Value;
end;

procedure TSubTipoInsumo.Set_DesSubTipoInsumo(const Value: WideString);
begin
  FDesSubTipoInsumo := Value;
end;

procedure TSubTipoInsumo.Set_SglSubTipoInsumo(const Value: WideString);
begin
  FSglSubTipoInsumo := Value;
end;

function TSubTipoInsumo.Get_CodTipoInsumo: Integer;
begin
  result := FCodTipoInsumo;
end;

function TSubTipoInsumo.Get_DesTipoInsumo: WideString;
begin
  result := FDesTipoInsumo;
end;

function TSubTipoInsumo.Get_SglTipoInsumo: WideString;
begin
  result := FSglTipoInsumo;
end;

procedure TSubTipoInsumo.Set_CodTipoInsumo(Value: Integer);
begin
  FCodTipoInsumo := Value;
end;

procedure TSubTipoInsumo.Set_DesTipoInsumo(const Value: WideString);
begin
  FDesTipoInsumo := Value;
end;

procedure TSubTipoInsumo.Set_SglTipoInsumo(const Value: WideString);
begin
  FSglTipoInsumo := Value;
end;

function TSubTipoInsumo.Get_QtdIntervaloMinimoAplicacao: Integer;
begin
  result := FQtdIntervaloMinimoAplicacao;
end;

procedure TSubTipoInsumo.Set_QtdIntervaloMinimoAplicacao(Value: Integer);
begin
  FQtdIntervaloMinimoAplicacao := Value;
end;

function TSubTipoInsumo.Get_IndSexoAnimalAplicacao: WideString;
begin
  result := FIndSexoAnimalAplicacao;
end;

function TSubTipoInsumo.Get_NumOrdem: Integer;
begin
  result := FNumOrdem;
end;

procedure TSubTipoInsumo.Set_IndSexoAnimalAplicacao(
  const Value: WideString);
begin
  FIndSexoAnimalAplicacao := Value;
end;

procedure TSubTipoInsumo.Set_NumOrdem(Value: Integer);
begin
  FNumOrdem := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSubTipoInsumo, Class_SubTipoInsumo,
    ciMultiInstance, tmApartment);
end.
