// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 05/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Estado
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    05/08/2002    Criação
// *
// *
// ********************************************************************
unit uEstado;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TEstado = class(TASPMTSObject, IEstado)
  private
    FCodEstado       : Integer;
    FSglEstado       : WideString;
    FNomEstado       : WideString;
    FCodEstadoSisBov : Integer;
    FCodPais         : Integer;
    FNomPais         : WideString;
    FCodPaisSisBov   : Integer;
  protected
    function Get_CodEstado: Integer; safecall;
    function Get_CodEstadoSisBov: Integer; safecall;
    function Get_CodPais: Integer; safecall;
    function Get_CodPaisSisBov: Integer; safecall;
    function Get_NomEstado: WideString; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_SglEstado: WideString; safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_CodEstadoSisBov(Value: Integer); safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_CodPaisSisBov(Value: Integer); safecall;
    procedure Set_NomEstado(const Value: WideString); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
  public
    property CodEstado        : Integer     read FCodEstado        write FCodEstado;
    property NomEstado        : WideString  read FNomEstado        write FNomEstado;
    property SglEstado        : WideString  read FSglEstado        write FSglEstado;    
    property CodEstadoSisbov  : Integer     read FCodEstadoSisbov  write FCodEstadoSisbov ;

    property CodPais          : Integer     read FCodPais          write FCodPais;
    property NomPais          : WideString  read FNomPais          write FNomPais;
    property CodPaisSisbov    : Integer     read FCodPaisSisBov    write FCodPaisSisBov ;
  end;

implementation

uses ComServ;

function TEstado.Get_CodEstado: Integer;
begin
  result := FCodEstado;
end;

function TEstado.Get_CodEstadoSisBov: Integer;
begin
  result := FCodEstadoSisBov;
end;

function TEstado.Get_CodPais: Integer;
begin
  result := FCodPais;
end;

function TEstado.Get_CodPaisSisBov: Integer;
begin
  result := FCodPaisSisBov;
end;

function TEstado.Get_NomEstado: WideString;
begin
  result := FNomEstado;
end;

function TEstado.Get_NomPais: WideString;
begin
  result := FNomPais;
end;

function TEstado.Get_SglEstado: WideString;
begin
  result := FSglEstado;
end;

procedure TEstado.Set_CodEstado(Value: Integer);
begin
  FCodEstado := value;
end;

procedure TEstado.Set_CodEstadoSisBov(Value: Integer);
begin
  FCodEstadoSisBov := value;
end;

procedure TEstado.Set_CodPais(Value: Integer);
begin
  FCodPais := value;
end;

procedure TEstado.Set_CodPaisSisBov(Value: Integer);
begin
  FCodPaisSisBov := value;
end;

procedure TEstado.Set_NomEstado(const Value: WideString);
begin
  FNomEstado := value;
end;

procedure TEstado.Set_NomPais(const Value: WideString);
begin
  FNomPais := value;
end;

procedure TEstado.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEstado, Class_Estado,
    ciMultiInstance, tmApartment);
end.
