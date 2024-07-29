// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Luiz Humberto Canival
// *  Versão             : 1
// *  Data               : 28/05/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Caracteristicas de tipos de avaliação.
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit uIntCaracteristicaAvaliacao;

interface

type
  TIntCaracteristicaAvaliacao = class
  private
    FCodTipoAvaliacao           : Integer;
    FCodCaracteristica          : Integer;
    FSglTipoAvaliacao           : String;
    FDesTipoAvaliacao           : String;
    FSglCaracteristica          : String;
    FDesCaracteristica          : String;
    FCodUnidadeMedida           : Integer;
    FSglUnidadeMedida           : String;
    FDesUnidadeMedida           : String;
    FValLimiteMinimo            : Double;
    FValLimiteMaximo            : Double;
    FIndSexo                    : String;

  public
    property CodTipoAvaliacao   : Integer     read FCodTipoAvaliacao    write FCodTipoAvaliacao;
    property CodCaracteristica  : Integer     read FCodCaracteristica   write FCodCaracteristica;
    property SglTipoAvaliacao   : String      read FSglTipoAvaliacao    write FSglTipoAvaliacao;
    property DesTipoAvaliacao   : String      read FDesTipoAvaliacao    write FDesTipoAvaliacao;
    property SglCaracteristica  : String      read FSglCaracteristica   write FSglCaracteristica;
    property DesCaracteristica  : String      read FDesCaracteristica   write FDesCaracteristica;
    property CodUnidadeMedida   : Integer     read FCodUnidadeMedida    write FCodUnidadeMedida;
    property SglUnidadeMedida   : String      read FSglUnidadeMedida    write FSglUnidadeMedida;
    property DesUnidadeMedida   : String      read FDesUnidadeMedida    write FDesUnidadeMedida;
    property ValLimiteMinimo    : Double      read FValLimiteMinimo     write FValLimiteMinimo;
    property ValLimiteMaximo    : Double      read FValLimiteMaximo     write FValLimiteMaximo;
    property IndSexo            : String      read FIndSexo             write FIndSexo;
  end;

implementation

end.
