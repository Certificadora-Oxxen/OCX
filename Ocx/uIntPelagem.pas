// *********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 29/07/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  C�digo Classe      : 26
// *  Descri��o Resumida : Cadastro de Pelagem
// *********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    29/07/2002    Cria��o
// *********************************************************************
unit uIntPelagem;

interface

type
  TIntpelagem = class
  private
    FCodPelagem     : Integer;
    FSglPelagem     : String;
    FDesPelagem     : String;
    FIndRestritoSistema: String;
  public
    property  CodPelagem        : Integer    Read FCodPelagem         write FCodPelagem;
    property  SglPelagem        : String     Read FSglPelagem         write FSglPelagem;
    property  DesPelagem        : String     Read FDesPelagem         write FDesPelagem;
    property  IndRestritoSistema: String     Read FIndRestritoSistema write FIndRestritoSistema;
  end;

implementation

end.
