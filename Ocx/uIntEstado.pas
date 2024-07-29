// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 05/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  Descri��o Resumida : Cadastro de Estado
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    05/08/2002    Cria��o
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
