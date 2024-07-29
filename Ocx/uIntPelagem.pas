// *********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 29/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 26
// *  Descrição Resumida : Cadastro de Pelagem
// *********************************************************************
// *  Últimas Alterações
// *   Hitalo    29/07/2002    Criação
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
