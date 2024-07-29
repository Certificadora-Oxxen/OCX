// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 19/08/2002
// *  Documenta��o       : Atributos de animais - defini��o das classes.doc
// *  C�digo Classe      : 37
// *  Descri��o Resumida : Cadastro de Associa��o Ra�a
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    23/07/2002    Cria��o
// *   Hitalo    19/08/2002  Adicionar m�todos Inserir, Excluir, Buscar ,Alterar,
// *                         AdicionarGrauSangue,RetirrarGrauSangue,PesquisarRelacionamentos
// *
// ********************************************************************
unit uIntAssociacaoRaca;

interface

type
  TIntAssociacaoRaca = class
  private
    FCodAssociacaoRaca       : Integer;
    FSglAssociacaoRaca       : String;
    FNomAssociacaoRaca       : String;
  public
    property CodAssociacaoRaca   : Integer     read FCodAssociacaoRaca   write FCodAssociacaoRaca;
    property SglAssociacaoRaca   : String      read FSglAssociacaoRaca   write FSglAssociacaoRaca;
    property NomAssociacaoRaca   : String      read FNomAssociacaoRaca   write FNomAssociacaoRaca;
  end;
      
implementation

end.
