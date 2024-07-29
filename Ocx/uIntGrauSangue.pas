// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 21/08/2002
// *  Documentação       : Atributos de Animais - Especificação das Classe.doc// *  Código Classe      : 38
// *  Descrição Resumida : Cadastro de Grau de Sangue
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    21/08/2002    Criação
// *
// *
// ********************************************************************
unit uIntGrauSangue;

interface
type
  TIntGrauSangue = class
 private
    FCodGrauSangue : Integer;
    FSglGrauSangue : WideString;
    FDesGrauSangue : WideString;
  Public
    property CodGrauSangue   : Integer     read FCodGrauSangue   write FCodGrauSangue;
    property SglGrauSangue   : WideString  read FSglGrauSangue   write FSglGrauSangue;
    property DesGrauSangue   : WideString  read FDesGrauSangue   write FDesGrauSangue;
  end;
implementation

end.
