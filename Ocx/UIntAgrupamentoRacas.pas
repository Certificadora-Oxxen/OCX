// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Vers�o             : 1
// *  Data               : 06/01/2003
// *  Documenta��o       : Atributo de animais
// *  C�digo Classe      :
// *  Descri��o Resumida : Cadastro de Agrupamentos de ra�as
// ************************************************************************
// *  �ltimas Altera��es
// *
// ********************************************************************
unit UIntAgrupamentoRacas;

interface

type
  TIntAgrupamentoRacas = class
  private
    FCodAgrupamentoRacas    : Integer;
    FSglAgrupamentoRacas    : String;
    FDesAgrupamentoRacas    : String;
  public
    property CodAgrupamentoRacas   : Integer     read FCodAgrupamentoRacas   write FCodAgrupamentoRacas;
    property SglAgrupamentoRacas   : String      read FSglAgrupamentoRacas   write FSglAgrupamentoRacas;
    property DesAgrupamentoRacas   : String      read FDesAgrupamentoRacas   write FDesAgrupamentoRacas;
  end;

implementation

end.
