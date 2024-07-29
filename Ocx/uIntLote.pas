// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 33
// *  Descrição Resumida : Cadastro de Lote
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    25/07/2002    Criação
// *
// ********************************************************************
unit uIntLote;

interface

type
  TIntLote = class
  private
    FCodPessoaProdutor       : Integer;
    FCodFazenda              : Integer;
    FCodLote                 : Integer;
    FSglLote                 : String;
    FDesLote                 : String;
    FSglFazenda              : String;
    FNomFazenda              : String;
    FDtaCadastramento        : TDateTime;
  public
    property CodPessoaProdutor   : Integer     read FCodPessoaProdutor   write FCodPessoaProdutor;
    property CodFazenda          : Integer     read FCodFazenda          write FCodFazenda;
    property CodLote             : Integer     read FCodLote             write FCodLote;
    property SglLote             : String      read FSglLote             write FSglLote;
    property DesLote             : String      read FDesLote             write FDesLote;
    property SglFazenda          : String      read FSglFazenda          write FSglFazenda;
    property NomFazenda          : String      read FNomFazenda          write FNomFazenda;
    property DtaCadastramento    : TDateTime   read FDtaCadastramento    write FDtaCadastramento;
  end;

implementation

end.
