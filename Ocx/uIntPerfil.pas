// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Vers�o  : 1
// *  Data : 16/07/2002
// *  Descri��o Resumida : Perfil do Usu�rio
// *
// ********************************************************************
// *  �ltimas Altera��es
// *  Analista      Data     Descri��o Altera��o
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *
// *
// *
// ********************************************************************

unit uIntPerfil;

interface

type
  TIntPerfil = class
  private
    FCodPerfil      : Integer;
    FNomPerfil      : String;
    FCodPapel       : Integer;
    FDesPapel       : String;
    FDesPerfil      : String;
    FDtaFimValidade : TDateTime;
  public
    property CodPerfil       : Integer    read FCodPerfil      write FCodPerfil;
    property NomPerfil       : String     read FNomPerfil      write FNomPerfil;
    property CodPapel        : Integer    read FCodPapel       write FCodPapel;
    property DesPapel        : String     read FDesPapel       write FDesPapel;
    property DesPerfil       : String     read FDesPerfil      write FDesPerfil;
    property DtaFimValidade : TDateTime  read FDtaFimValidade write FDtaFimValidade;
  end;

implementation

end.

