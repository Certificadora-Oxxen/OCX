// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Antonio Druzo Rocha Neto
// *  Versão             : 1
// *  Data               : 13/02/2009
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de tipos de propriedade de animais
// ********************************************************************
// *
// ********************************************************************

unit uTipoPropriedade;

interface
uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTipoPropriedade = class(TASPMTSObject,ITipoPropriedade)
private
  FCodTipoPropriedade:integer;
  FDesTipoPropriedade:widestring;
  FQtdDiasProxVistoria:integer;
protected
  function  Get_CodTipoPropriedade: Integer; safecall;
  procedure Set_CodTipoPropriedade(Value: Integer); safecall;

  function  Get_DesTipoPropriedade: WideString; safecall;
  procedure Set_DesTipoPropriedade(Const Value: WideString); safecall;

  function  Get_QtdDiasProxVistoria: Integer; safecall;
  procedure Set_QtdDiasProxVistoria(Value: Integer); safecall;
public
  property  CodTipoPropriedade        : Integer        Read Get_CodTipoPropriedade     write Set_CodTipoPropriedade;
  property  DesTipoPropriedade        : WideString     Read Get_DesTipoPropriedade     write Set_DesTipoPropriedade;
  property  QtdDiasProxVistoria       : Integer        Read Get_QtdDiasProxVistoria    write Set_QtdDiasProxVistoria;
end;

implementation

uses ComServ;

function TTipoPropriedade.Get_CodTipoPropriedade: Integer;
begin
  result  :=  FCodTipoPropriedade;
end;

function TTipoPropriedade.Get_DesTipoPropriedade: WideString;
begin
  result  :=  FDesTipoPropriedade;
end;

function TTipoPropriedade.Get_QtdDiasProxVistoria: Integer;
begin
  result  :=  FQtdDiasProxVistoria;
end;

procedure TTipoPropriedade.Set_CodTipoPropriedade(Value: Integer);
begin
  FCodTipoPropriedade :=  Value;
end;

procedure TTipoPropriedade.Set_DesTipoPropriedade(const Value: widestring);
begin
  FDesTipoPropriedade :=  Value;
end;

procedure TTipoPropriedade.Set_QtdDiasProxVistoria(Value: Integer);
begin
  FQtdDiasProxVistoria  :=  Value;   
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoPropriedade, CLASS_TipoPropriedade,
    ciMultiInstance, tmApartment);

end.
