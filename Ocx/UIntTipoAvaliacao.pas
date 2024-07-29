// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Luiz Humberto Canival
// *  Vers�o             : 1
// *  Data               : 27/05/2003
// *  Documenta��o       : Atributo de animais
// *  C�digo Classe      :
// *  Descri��o Resumida : Cadastro de Tipos de avalia��o.
// ************************************************************************
// *  �ltimas Altera��es
// *
// ********************************************************************
unit UIntTipoAvaliacao;

interface

type
  TIntTipoAvaliacao = class
  private
    FCodTipoAvaliacao    : Integer;
    FSglTipoAvaliacao    : String;
    FDesTipoAvaliacao    : String;
  public
    property CodTipoAvaliacao   : Integer     read FCodTipoAvaliacao   write FCodTipoAvaliacao;
    property SglTipoAvaliacao   : String      read FSglTipoAvaliacao   write FSglTipoAvaliacao;
    property DesTipoAvaliacao   : String      read FDesTipoAvaliacao   write FDesTipoAvaliacao;
  end;

implementation

end.
