// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 06/01/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Tipos de agrupamentos de raças
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit UIntTipoAgrupamentoRacas;

interface

type
  TIntTipoAgrupamentoRacas = class
  private
    FCodTipoAgrupamentoRacas    : Integer;
    FSglTipoAgrupamentoRacas    : String;
    FDesTipoAgrupamentoRacas    : String;
  public
    property CodTipoAgrupamentoRacas   : Integer     read FCodTipoAgrupamentoRacas   write FCodTipoAgrupamentoRacas;
    property SglTipoAgrupamentoRacas   : String      read FSglTipoAgrupamentoRacas   write FSglTipoAgrupamentoRacas;
    property DesTipoAgrupamentoRacas   : String      read FDesTipoAgrupamentoRacas   write FDesTipoAgrupamentoRacas;
  end;

implementation

end.
