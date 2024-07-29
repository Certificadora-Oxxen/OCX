// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Vers�o             : 1
// *  Data               : 06/01/2003
// *  Documenta��o       : Atributo de animais
// *  C�digo Classe      :
// *  Descri��o Resumida : Cadastro de Tipos de agrupamentos de ra�as
// ************************************************************************
// *  �ltimas Altera��es
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
