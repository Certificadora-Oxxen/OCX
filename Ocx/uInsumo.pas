// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 16/09/2002
// *  Documentação       :
// *  Código Classe      :  63
// *  Descrição Resumida : Cadastro de Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    16/10/2002    Criação
// *
// ********************************************************************
unit uInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TInsumo = class(TASPMTSObject, IInsumo)
  Private
    FCodInsumo                   : Integer;
    FDesInsumo                   : WideString;
    FCodTipoInsumo               : Integer;
    FSglTipoInsumo               : WideString;
    FDesTipoInsumo               : WideString;
    FCodSubTipoInsumo            : Integer;
    FSglSubTipoInsumo            : WideString;
    FDesSubTipoInsumo            : WideString;
    FCodFabricanteInsumo         : Integer;
    FNomFabricanteInsumo         : WideString;
    FNomReduzidoFabricanteInsumo : WideString;
    FTxtObservacao               : WideString;
  protected
    function Get_CodFabricanteInsumo: Integer; safecall;
    function Get_CodInsumo: Integer; safecall;
    function Get_CodSubTipoInsumo: Integer; safecall;
    function Get_CodTipoInsumo: Integer; safecall;
    function Get_DesInsumo: WideString; safecall;
    function Get_DesSubTipoInsumo: WideString; safecall;
    function Get_DesTipoInsumo: WideString; safecall;
    function Get_NomFabricanteInsumo: WideString; safecall;
    function Get_NomReduzidoFabricanteInsumo: WideString; safecall;
    function Get_SglSubTipoInsumo: WideString; safecall;
    function Get_SglTipoInsumo: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_CodFabricanteInsumo(Value: Integer); safecall;
    procedure Set_CodInsumo(Value: Integer); safecall;
    procedure Set_CodSubTipoInsumo(Value: Integer); safecall;
    procedure Set_CodTipoInsumo(Value: Integer); safecall;
    procedure Set_DesInsumo(const Value: WideString); safecall;
    procedure Set_DesSubTipoInsumo(const Value: WideString); safecall;
    procedure Set_DesTipoInsumo(const Value: WideString); safecall;
    procedure Set_NomFabricanteInsumo(const Value: WideString); safecall;
    procedure Set_NomReduzidoFabricanteInsumo(const Value: WideString);
      safecall;
    procedure Set_SglSubTipoInsumo(const Value: WideString); safecall;
    procedure Set_SglTipoInsumo(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
  public
    property  CodInsumo                   : Integer      Read FCodInsumo  write FCodInsumo;
    property  DesInsumo                   : WideString   Read FDesInsumo  write FDesInsumo;
    property  CodTipoInsumo               : Integer      Read FCodTipoInsumo  write FCodTipoInsumo;
    property  SglTipoInsumo               : WideString   Read FSglTipoInsumo  write FSglTipoInsumo;
    property  DesTipoInsumo               : WideString   Read FDesTipoInsumo  write FDesTipoInsumo;
    property  CodSubTipoInsumo            : Integer      Read FCodSubTipoInsumo  write FCodSubTipoInsumo;
    property  SglSubTipoInsumo            : WideString   Read FSglSubTipoInsumo  write FSglSubTipoInsumo;
    property  DesSubTipoInsumo            : WideString   Read FDesSubTipoInsumo  write FDesSubTipoInsumo;
    property  CodFabricanteInsumo         : Integer      Read FCodFabricanteInsumo  write FCodFabricanteInsumo;
    property  NomFabricanteInsumo         : WideString   Read FNomFabricanteInsumo  write FNomFabricanteInsumo;
    property  NomReduzidoFabricanteInsumo : WideString   Read FNomReduzidoFabricanteInsumo  write FNomReduzidoFabricanteInsumo;
    property  TxtObservacao               : WideString   Read FTxtObservacao  write FTxtObservacao;
  end;
  
implementation

uses ComServ;

function TInsumo.Get_CodFabricanteInsumo: Integer;
begin
  result := FCodFabricanteInsumo;
end;

function TInsumo.Get_CodInsumo: Integer;
begin
  result := FCodInsumo;
end;

function TInsumo.Get_CodSubTipoInsumo: Integer;
begin
  result := FCodSubTipoInsumo;
end;

function TInsumo.Get_CodTipoInsumo: Integer;
begin
  result := FCodTipoInsumo;
end;

function TInsumo.Get_DesInsumo: WideString;
begin
  result := FDesInsumo;
end;

function TInsumo.Get_DesSubTipoInsumo: WideString;
begin
  result := FDesSubTipoInsumo;
end;

function TInsumo.Get_DesTipoInsumo: WideString;
begin
  result := FDesTipoInsumo;
end;

function TInsumo.Get_NomFabricanteInsumo: WideString;
begin
  result := FNomFabricanteInsumo;
end;

function TInsumo.Get_NomReduzidoFabricanteInsumo: WideString;
begin
  result := FNomReduzidoFabricanteInsumo;
end;

function TInsumo.Get_SglSubTipoInsumo: WideString;
begin
  result := FSglSubTipoInsumo;
end;

function TInsumo.Get_SglTipoInsumo: WideString;
begin
  result := FSglTipoInsumo;
end;

function TInsumo.Get_TxtObservacao: WideString;
begin
  result := FTxtObservacao;
end;

procedure TInsumo.Set_CodFabricanteInsumo(Value: Integer);
begin
  FCodFabricanteInsumo  := value;
end;

procedure TInsumo.Set_CodInsumo(Value: Integer);
begin
  FCodInsumo  := value;
end;

procedure TInsumo.Set_CodSubTipoInsumo(Value: Integer);
begin
  FCodSubTipoInsumo  := value;
end;

procedure TInsumo.Set_CodTipoInsumo(Value: Integer);
begin
  FCodTipoInsumo  := value;
end;

procedure TInsumo.Set_DesInsumo(const Value: WideString);
begin
  FDesInsumo  := value;
end;

procedure TInsumo.Set_DesSubTipoInsumo(const Value: WideString);
begin
  FDesSubTipoInsumo  := value;
end;

procedure TInsumo.Set_DesTipoInsumo(const Value: WideString);
begin
  FDesTipoInsumo  := value;
end;

procedure TInsumo.Set_NomFabricanteInsumo(const Value: WideString);
begin
  FNomFabricanteInsumo  := value;
end;

procedure TInsumo.Set_NomReduzidoFabricanteInsumo(const Value: WideString);
begin
  FNomReduzidoFabricanteInsumo  := value;
end;

procedure TInsumo.Set_SglSubTipoInsumo(const Value: WideString);
begin
  FSglSubTipoInsumo  := value;
end;

procedure TInsumo.Set_SglTipoInsumo(const Value: WideString);
begin
  FSglTipoInsumo  := value;
end;

procedure TInsumo.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao  := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TInsumo, Class_Insumo,
    ciMultiInstance, tmApartment);
end.
