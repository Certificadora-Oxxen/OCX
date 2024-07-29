// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 29/07/2002
// *  Documenta��o       : Atributos de Animais.doc
// *  C�digo Classe      : 26
// *  Descri��o Resumida : Cadastro de Raca
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    29/07/2002    Cria��o
// *   H�talo    10/09/2002   Adiconar propriedade CodRacaSisBov.
// *   H�talo    19/09/2002   Adicionar as propriedades CodEspecie,DesEspecie,Sglespecie.
// *
// ********************************************************************
unit uIntRaca;

interface

type
  TIntRaca = class
  private
    FCodRaca        : Integer;
    FSglRaca        : String;
    FDesRaca        : String;
    FIndRacaPura    : String;
    FCodRacaSisBov  : String;
    FCodEspecie     : Integer;
    FSglEspecie     : String;
    FDesEspecie     : String;
    FIndDefaultProdutor : WideString;
    FQtdPesoPadraoNascimento : Double;
    FQtdMinDiasGestacao: Integer;
    FQtdMaxDiasGestacao: Integer;
    FCodRacaAbcz : String;
  public
    property  CodRaca        : Integer        Read FCodRaca        write FCodRaca;
    property  SglRaca        : String         Read FSglRaca        write FSglRaca;
    property  DesRaca        : String         Read FDesRaca        write FDesRaca;
    property  IndRacaPura    : String         Read FIndRacaPura    write FIndRacaPura;
    property  CodRacaSisBov  : String         Read FCodRacaSisBov  write FCodRacaSisBov;
    property  CodEspecie     : Integer        Read FCodEspecie     write FCodEspecie;
    property  SglEspecie     : String         Read FSglEspecie     write FSglEspecie;
    property  DesEspecie     : String         Read FDesEspecie     write FDesEspecie;
    property  IndDefaultProdutor : WideString     Read FIndDefaultProdutor     write FIndDefaultProdutor;
    property  QtdPesoPadraoNascimento  : Double   Read FQtdPesoPadraoNascimento  write FQtdPesoPadraoNascimento;
    property  QtdMinDiasGestacao       : Integer  Read FQtdMinDiasGestacao       write FQtdMinDiasGestacao;
    property  QtdMaxDiasGestacao       : Integer  Read FQtdMaxDiasGestacao       write FQtdMaxDiasGestacao;
    property  CodRacaAbcz              : String   read FCodRacaAbcz              write FCodRacaAbcz;
  end;

implementation

end.
