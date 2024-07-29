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

unit uIntTipoPropriedade;

interface
type
  TIntTipoPropriedade = class
private
  FCodTipoPropriedade:integer;
  FDesTipoPropriedade:string;
  FQtdDiasProxVistoria:integer;
protected
  function  Get_CodTipoPropriedade: Integer;
  procedure Set_CodTipoPropriedade(Value: Integer);

  function  Get_DesTipoPropriedade: string;
  procedure Set_DesTipoPropriedade(Value: string);

  function  Get_QtdDiasProxVistoria: Integer;
  procedure Set_QtdDiasProxVistoria(Value: Integer);
public
  property  CodTipoPropriedade        : Integer        Read Get_CodTipoPropriedade     write Set_CodTipoPropriedade;
  property  DesTipoPropriedade        : String         Read Get_DesTipoPropriedade     write Set_DesTipoPropriedade;
  property  QtdDiasProxVistoria       : Integer        Read Get_QtdDiasProxVistoria    write Set_QtdDiasProxVistoria;
end;
implementation
{ TIntTipoPropriedade }

function TIntTipoPropriedade.Get_CodTipoPropriedade: Integer;
begin
  result  :=  FCodTipoPropriedade;
end;

function TIntTipoPropriedade.Get_DesTipoPropriedade: string;
begin
  result  :=  FDesTipoPropriedade;
end;

function TIntTipoPropriedade.Get_QtdDiasProxVistoria: Integer;
begin
  result  :=  FQtdDiasProxVistoria;
end;

procedure TIntTipoPropriedade.Set_CodTipoPropriedade(Value: Integer);
begin
  FCodTipoPropriedade :=  Value;
end;

procedure TIntTipoPropriedade.Set_DesTipoPropriedade(Value: string);
begin
  FDesTipoPropriedade :=  Value;
end;

procedure TIntTipoPropriedade.Set_QtdDiasProxVistoria(Value: Integer);
begin
  FQtdDiasProxVistoria  :=  Value;
end;

end.
