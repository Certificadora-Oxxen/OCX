// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 21/08/2002
// *  Documenta��o       : Atributos de Animais - Especifica��o das Classe.doc// *  C�digo Classe      : 38
// *  Descri��o Resumida : Cadastro de Grau de Sangue
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    21/08/2002    Cria��o
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
