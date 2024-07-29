// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Perfil do Usuário
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
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

