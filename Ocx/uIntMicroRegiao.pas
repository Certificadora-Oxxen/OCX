// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 06/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  Descri��o Resumida : Cadastro de Micro Regi�o
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    06/08/2002    Cria��o
// *
// *
// ********************************************************************
unit uIntMicroRegiao;

interface

type
  TIntMicroRegiao = class
  private
    FCodPais                : Integer;
    FNomPais                : String;
    FCodPaisSisBov          : Integer;
    FCodEstado              : Integer;
    FSglEstado              : String;
    FCodEstadoSisBov        : Integer;
    FCodMicroRegiao         : Integer;
    FNomMicroRegiao         : String;
    FCodMicroRegiaoSisBov   : Integer;
  public
    property CodPais          : Integer     read FCodPais          write FCodPais;
    property NomPais          : String      read FNomPais          write FNomPais;
    property CodPaisSisbov    : Integer     read FCodPaisSisBov    write FCodPaisSisBov ;

    property CodEstado        : Integer     read FCodEstado        write FCodEstado;
    property SglEstado        : String      read FSglEstado        write FSglEstado;
    property CodEstadoSisbov  : Integer     read FCodEstadoSisbov  write FCodEstadoSisbov ;

    property CodMicroRegiao          : Integer     read FCodMicroRegiao          write FCodMicroRegiao;
    property NomMicroRegiao          : String      read FNomMicroRegiao          write FNomMicroRegiao;
    property CodMicroRegiaoSisbov    : Integer     read FCodMicroRegiaoSisBov    write FCodMicroRegiaoSisBov ;
  end;

implementation

end.



