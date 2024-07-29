// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 05/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Paises
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    05/08/2002    Criação
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
