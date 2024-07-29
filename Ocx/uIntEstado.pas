// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 05/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Estado
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    05/08/2002    Criação
// *
// *
// ********************************************************************
unit uIntEstado;

interface

type
  TIntEstado = class
  private
    FCodEstado       : Integer;
    FSglEstado       : String;
    FNomEstado       : String;
    FCodEstadoSisBov : Integer;
    FCodPais         : Integer;
    FNomPais         : String;
    FCodPaisSisBov   : Integer;
  public
    property CodEstado        : Integer     read FCodEstado        write FCodEstado;
    property NomEstado        : String      read FNomEstado        write FNomEstado;
    property SglEstado        : String      read FSglEstado        write FSglEstado;
    property CodEstadoSisbov  : Integer     read FCodEstadoSisbov  write FCodEstadoSisbov ;

    property CodPais          : Integer     read FCodPais          write FCodPais;
    property NomPais          : String      read FNomPais          write FNomPais;
    property CodPaisSisbov    : Integer     read FCodPaisSisBov    write FCodPaisSisBov ;
  end;

implementation

end.
