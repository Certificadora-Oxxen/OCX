// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Controle de acesso - definição das classes
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Parametros
// ************************************************************************
// *  Últimas Alterações
// *   Hítalo    02/09/2002    Criação
// *
// ********************************************************************
unit uParametro;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TParametro = class(TASPMTSObject, IParametro)
  private
    FCodPaisCertificadora          : Integer;
    FNomPaisCertificadora          : WideString;
    FCodPaisSisBovCertificadora    : Integer;
    FIndCodCertificadoraAutomatico : WideString;
  protected
    function Get_CodPaisCertificadora: Integer; safecall;
    function Get_CodPaisSisBovCertificadora: Integer; safecall;
    function Get_IndCodCertificadoraAutomatico: WideString; safecall;
    function Get_NomPaisCertificadora: WideString; safecall;
    procedure Set_CodPaisCertificadora(Value: Integer); safecall;
    procedure Set_CodPaisSisBovCertificadora(Value: Integer); safecall;
    procedure Set_IndCodCertificadoraAutomatico(const Value: WideString);
      safecall;
    procedure Set_NomPaisCertificadora(const Value: WideString); safecall;
  public
    property CodPaisCertificadora          : Integer    read FCodPaisCertificadora          write FCodPaisCertificadora;
    property NomPaisCertificadora          : WideString read FNomPaisCertificadora          write FNomPaisCertificadora;
    property CodPaisSisBovCertificadora    : Integer    read FCodPaisSisBovCertificadora    write FCodPaisSisBovCertificadora;
    property IndCodCertificadoraAutomatico : WideString read FIndCodCertificadoraAutomatico write FIndCodCertificadoraAutomatico;
  end;
  
implementation

uses ComServ;

function TParametro.Get_CodPaisCertificadora: Integer;
begin
  result := FCodPaisCertificadora;
end;

function TParametro.Get_CodPaisSisBovCertificadora: Integer;
begin
  result := FCodPaisSisBovCertificadora;
end;

function TParametro.Get_IndCodCertificadoraAutomatico: WideString;
begin
  result := FIndCodCertificadoraAutomatico;
end;

function TParametro.Get_NomPaisCertificadora: WideString;
begin
  result := FNomPaisCertificadora;
end;

procedure TParametro.Set_CodPaisCertificadora(Value: Integer);
begin
  FCodPaisCertificadora := value;
end;

procedure TParametro.Set_CodPaisSisBovCertificadora(Value: Integer);
begin
  FCodPaisSisBovCertificadora := value;
end;

procedure TParametro.Set_IndCodCertificadoraAutomatico(
  const Value: WideString);
begin

end;

procedure TParametro.Set_NomPaisCertificadora(const Value: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TParametro, Class_Parametro,
    ciMultiInstance, tmApartment);
end.
