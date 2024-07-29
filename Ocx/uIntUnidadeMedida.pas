// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 10/09/2002
// *  Documenta��o       :
// *  Descri��o Resumida : Cadastro de Unidade Medida
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    10/09/2002    Cria��o
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
