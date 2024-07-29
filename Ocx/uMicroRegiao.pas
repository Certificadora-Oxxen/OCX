// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Micro Região
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    06/08/2002    Criação
// *
// *
// ********************************************************************
unit uMicroRegiao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TMicroRegiao = class(TASPMTSObject, IMicroRegiao)
  private
    FCodPais                : Integer;
    FNomPais                : String;
    FCodPaisSisBov          : Integer;
    FCodEstado              : Integer;
    FSglEstado              : String;
    FCodEstadoSisBov        : Integer;
    FCodMicroRegiao         : Integer;
    FNomMicroRegiao         : String;
    FCodMicroRegiaoSisBov   : Integer;
  protected
    function Get_CodPais: Integer; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_CodPaisSisBov: Integer; safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_CodEstadoSisBov: Integer; safecall;
    function Get_CodMicroRegiao: Integer; safecall;
    function Get_NomMIcroRegiao: WideString; safecall;
    function Get_CodMicroRegiaoSisBov: Integer; safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_CodPaisSisBov(Value: Integer); safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_CodEstadoSisBov(Value: Integer); safecall;
    procedure Set_CodMicroRegiao(Value: Integer); safecall;
    procedure Set_NomMIcroRegiao(const Value: WideString); safecall;
    procedure Set_CodMicroRegiaoSisBov(Value: Integer); safecall;
  public
    property CodPais          : Integer     read FCodPais          write FCodPais;
    property NomPais          : String      read FNomPais          write FNomPais;
    property CodPaisSisbov    : Integer     read FCodPaisSisBov    write FCodPaisSisBov ;

    property CodEstado        : Integer     read FCodEstado        write FCodEstado;
    property SglEstado        : String      read FSglEstado        write FSglEstado;
    property CodEstadoSisbov  : Integer     read FCodEstadoSisbov  write FCodEstadoSisbov ;

    property CodMicroRegiao          : Integer     read FCodMicroRegiao          write FCodMicroRegiao;
    property NomMicroRegiao          : String      read FNomMicroRegiao          write FNomMicroRegiao;
    property CodMicroRegiaoSisbov    : Integer     read FCodMicroRegiaoSisBov    write FCodMicroRegiaoSisBov ;
  end;

implementation

uses ComServ;

function TMicroRegiao.Get_CodPais: Integer;
begin
  result := FCodPais;
end;

function TMicroRegiao.Get_NomPais: WideString;
begin
  result := FNomPais;
end;

function TMicroRegiao.Get_CodPaisSisBov: Integer;
begin
  result := FCodPaisSisBov;
end;

function TMicroRegiao.Get_CodEstado: Integer;
begin
  result := FCodestado;
end;

function TMicroRegiao.Get_SglEstado: WideString;
begin
  result := FSglEstado;
end;

function TMicroRegiao.Get_CodEstadoSisBov: Integer;
begin
  result := FCodEstadoSisBov;
end;

function TMicroRegiao.Get_CodMicroRegiao: Integer;
begin
  result := FCodMicroRegiao;
end;

function TMicroRegiao.Get_NomMIcroRegiao: WideString;
begin
  result := FNomMIcroRegiao;
end;

function TMicroRegiao.Get_CodMicroRegiaoSisBov: Integer;
begin
  result := FCodMicroRegiaoSisBov;
end;

procedure TMicroRegiao.Set_CodPais(Value: Integer);
begin
  FCodPais   := value;
end;

procedure TMicroRegiao.Set_NomPais(const Value: WideString);
begin
  FNomPais   := value;
end;

procedure TMicroRegiao.Set_CodPaisSisBov(Value: Integer);
begin
  FCodPaisSisBov   := value;
end;

procedure TMicroRegiao.Set_CodEstado(Value: Integer);
begin
  FCodEstado   := value;
end;

procedure TMicroRegiao.Set_SglEstado(const Value: WideString);
begin
  FSglEstado   := value;
end;

procedure TMicroRegiao.Set_CodEstadoSisBov(Value: Integer);
begin
  FCodEstadoSisBov   := value;
end;

procedure TMicroRegiao.Set_CodMicroRegiao(Value: Integer);
begin
  FCodMicroRegiao   := value;
end;

procedure TMicroRegiao.Set_NomMIcroRegiao(const Value: WideString);
begin
  FNomMIcroRegiao   := value;
end;

procedure TMicroRegiao.Set_CodMicroRegiaoSisBov(Value: Integer);
begin
  FCodMicroRegiaoSisBov   := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMicroRegiao, Class_MicroRegiao,
    ciMultiInstance, tmApartment);
end.
