// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/08/2002
// *  Documentação       : Atributos de animais - definição das classes.doc
// *  Código Classe      : 37
// *  Descrição Resumida : Cadastro de Associação Raça
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    23/07/2002    Criação
// *   Hitalo    19/08/2002  Adicionar métodos Inserir, Excluir, Buscar ,Alterar,
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
