// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 11/09/2002
// *  Documentação       :
// *  Código Classe      :  60
// *  Descrição Resumida : Cadastro de Fabricante Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/10/2002    Criação
// *
// ********************************************************************
unit uFabricanteInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TFabricanteInsumo = class(TASPMTSObject, IFabricanteInsumo)
  Private
    FCodFabricanteInsumo         : Integer;
    FNomFabricanteInsumo         : WideString;
    FNomReduzidoFabricanteInsumo : WideString;
    FNumRegistroFabricante       : Integer;    
  protected
    function Get_NomFabricanteInsumo: WideString; safecall;
    function Get_NomReduzidoFabricanteInsumo: WideString; safecall;
    procedure Set_NomFabricanteInsumo(const Value: WideString); safecall;
    procedure Set_NomReduzidoFabricanteInsumo(const Value: WideString);
      safecall;
    function Get_CodFabricanteInsumo: Integer; safecall;
    procedure Set_CodFabricanteInsumo(Value: Integer); safecall;
    function Get_NumRegistroFabricante: Integer; safecall;
    procedure Set_NumRegistroFabricante(Value: Integer); safecall;
  public
    property  CodFabricanteInsumo          : Integer      Read FCodFabricanteInsumo  write FCodFabricanteInsumo;
    property  NomFabricanteInsumo          : WideString   Read FNomFabricanteInsumo  write FNomFabricanteInsumo;
    property  NomReduzidoFabricanteInsumo  : WideString   Read FNomReduzidoFabricanteInsumo  write FNomReduzidoFabricanteInsumo;
    property  NumRegistroFabricante        : Integer      Read FNumRegistroFabricante  write FNumRegistroFabricante;

  end;

implementation

uses ComServ;

function TFabricanteInsumo.Get_NomFabricanteInsumo: WideString;
begin
  result := FNomFabricanteInsumo;
end;

function TFabricanteInsumo.Get_NomReduzidoFabricanteInsumo: WideString;
begin
  result := FNomReduzidoFabricanteInsumo;
end;

procedure TFabricanteInsumo.Set_NomFabricanteInsumo(
  const Value: WideString);
begin
  FNomFabricanteInsumo := value;
end;

procedure TFabricanteInsumo.Set_NomReduzidoFabricanteInsumo(
  const Value: WideString);
begin
  FNomReduzidoFabricanteInsumo := value; 
end;

function TFabricanteInsumo.Get_CodFabricanteInsumo: Integer;
begin
 result := FCodFabricanteInsumo;
end;

procedure TFabricanteInsumo.Set_CodFabricanteInsumo(Value: Integer);
begin
 FCodFabricanteInsumo := value;
end;

function TFabricanteInsumo.Get_NumRegistroFabricante: Integer;
begin
  result := FNumRegistroFabricante;
end;

procedure TFabricanteInsumo.Set_NumRegistroFabricante(Value: Integer);
begin
  FNumRegistroFabricante := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFabricanteInsumo, Class_FabricanteInsumo,
    ciMultiInstance, tmApartment);
end.
