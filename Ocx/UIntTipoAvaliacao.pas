// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Luiz Humberto Canival
// *  Versão             : 1
// *  Data               : 27/05/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Tipos de avaliação.
// ************************************************************************
// *  Últimas Alterações
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
