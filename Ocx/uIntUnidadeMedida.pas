// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Unidade Medida
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    10/09/2002    Criação
// *
// ********************************************************************
unit uIntUnidadeMedida;

interface

type
  TIntUnidadeMedida = class
  private
    FCodUnidadeMedida : Integer;
    FSglUnidadeMedida : wideString;
    FDesUnidadeMedida : wideString;
  public
    property CodUnidadeMedida        : Integer     read FCodUnidadeMedida       write FCodUnidadeMedida;
    property SglUnidadeMedida        : WideString  read FSglUnidadeMedida       write FSglUnidadeMedida;
    property DesUnidadeMedida        : WideString  read FDesUnidadeMedida       write FDesUnidadeMedida;
  end;
implementation

end.
