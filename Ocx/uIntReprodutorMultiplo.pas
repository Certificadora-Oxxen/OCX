// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 27/11/2002
// *  Documentação       : Animais - Definição das Classes
// *  Código Classe      : 73
// *  Descrição Resumida : Cadastro de Reprodutor Multiplo
// ********************************************************************
// *  Últimas Alterações
// *  Hitalo   27/11/2002  criacao
// *
// ********************************************************************
unit uIntReprodutorMultiplo;

interface
type
  TIntReprodutorMultiplo = class
  private
    FCodPessoaProdutor:Integer;
    FCodReprodutorMultiplo :Integer;
    FCodFazendaManejo : Integer;
    FSglFazendaManejo : String;
    FNomFazendaManejo : String;
    FCodReprodutorMultiploManejo : String;
    FCodEspecie : Integer;
    FSglEspecie : String;
    FDesEspecie : String;
    FTxtObservacao :  String;
    FIndAtivo : String;
    FDtaCadastramento : TDateTime;
  public
    property     CodPessoaProdutor              :Integer     read FCodPessoaProdutor               write FCodPessoaProdutor;
    property     CodReprodutorMultiplo          :Integer     read FCodReprodutorMultiplo           write FCodReprodutorMultiplo;
    property     CodFazendaManejo               :Integer     read FCodFazendaManejo                write FCodFazendaManejo;
    property     SglFazendaManejo               :String      read FSglFazendaManejo                write FSglFazendaManejo;
    property     NomFazendaManejo               :String      read FNomFazendaManejo                write FNomFazendaManejo;
    property     CodReprodutorMultiploManejo    :String      read FCodReprodutorMultiploManejo     write FCodReprodutorMultiploManejo;
    property     CodEspecie                     :Integer     read FCodEspecie                      write FCodEspecie;
    property     SglEspecie                     :String      read FSglEspecie                      write FSglEspecie;
    property     DesEspecie                     :String      read FDesEspecie                      write FDesEspecie;
    property     TxtObservacao                  :String      read FTxtObservacao                   write FTxtObservacao;    
    property     IndAtivo                       :String      read FIndAtivo                        write FIndAtivo;
    property     DtaCadastramento               :TDateTime   read FDtaCadastramento                write FDtaCadastramento;
  end;

implementation

end.
