// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 05/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  Descri��o Resumida : Cadastro de Paises
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    05/08/2002    Cria��o
// *
// *
// ********************************************************************
unit uPais;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPais = class(TASPMTSObject, IPais)
  private
    FCodPais       : Integer;
    FNomPais       : WideString;
    FCodPaisSisBov : Integer;
  protected
    function Get_CodPais: Integer; safecall;
    function Get_CodPaisSisBov: Integer; safecall;
    function Get_NomPais: WideString; safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_CodPaisSisBov(Value: Integer); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
  public
    property CodPais        : Integer     read FCodPais       write FCodPais;
    property NomPais        : WideString  read FNomPais       write FNomPais;
    property CodPaisSisbov  : Integer     read FCodPaisSisBov write FCodPaisSisBov ;
  end;

implementation

uses ComServ;

function TPais.Get_CodPais: Integer;
begin
  result := FCodPais;
end;

function TPais.Get_CodPaisSisBov: Integer;
begin
  result := FCodPaisSisBov;
end;

function TPais.Get_NomPais: WideString;
begin
  result := FNomPais;
end;

procedure TPais.Set_CodPais(Value: Integer);
begin
  FCodPais := value;
end;

procedure TPais.Set_CodPaisSisBov(Value: Integer);
begin
  FCodPaisSisBov := value;
end;

procedure TPais.Set_NomPais(const Value: WideString);
begin
  FNomPais := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPais, Class_Pais,
    ciMultiInstance, tmApartment);
end.
