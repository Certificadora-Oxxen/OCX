// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 06/01/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Agrupamentos de raças
// ************************************************************************
// *  Últimas Alterações
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
