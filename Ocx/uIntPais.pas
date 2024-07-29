// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 05/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  Descri��o Resumida : Cadastro de Paises
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    05/08/2002    Cria��o
// *   Hitalo    09/08/2002    Adiciona metodo PaisCertificadora
// *
// *
// ********************************************************************
unit uIntPais;

interface

type
  TIntPais = class
  private
    FCodPais       : Integer;
    FNomPais       : String;
    FCodPaisSisBov : Integer;
  public
    property CodPais        : Integer read FCodPais       write FCodPais;
    property NomPais        : String  read FNomPais       write FNomPais;
    property CodPaisSisbov  : Integer read FCodPaisSisBov write FCodPaisSisBov ;
  end;
implementation

end.
