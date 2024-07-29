// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 41
// *  Descrição Resumida : Cadastro de Pessoa Secundária - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *   Arley     06/08/2002    Adição no cadastro de alguns atributos
// *   Arley     06/09/2002    Adição das propriedades tipos de contato
// *   
// ********************************************************************
unit uIntPessoaSecundaria;

interface

type
  TIntPessoaSecundaria = class
  private
    FCodPessoaProdutor           : Integer;
    FCodPessoaSecundaria         : Integer;
    FNomPessoaSecundaria         : String;
    FNomReduzidoPessoaSecundaria : String;
    FCodNaturezaPessoa           : String;
    FDtaCadastramento            : TDateTime;
    FNumCNPJCPF                  : String;
    FNumCNPJCPFFormatado         : String;
    FCodTipoContato1             : Integer;
    FDesTipoContato1             : String;
    FTxtContato1                 : String;
    FCodTipoContato2             : Integer;
    FDesTipoContato2             : String;
    FTxtContato2                 : String;
    FCodTipoContato3             : Integer;
    FDesTipoContato3             : String;
    FTxtContato3                 : String;
    FCodTipoEndereco             : Integer;
    FNomLogradouro               : String;
    FNomBairro                   : String;
    FNumCep                      : String;
    FNomPais                     : String;
    FSglEstado                   : String;
    FNomMunicipio                : String;
    FNumMunicipioIBGE            : String;
    FNomDistrito                 : String;
    FTxtObservacao               : String;
  public
    property CodPessoaProdutor           : Integer     read FCodPessoaProdutor           write FCodPessoaProdutor;
    property CodPessoaSecundaria         : Integer     read FCodPessoaSecundaria         write FCodPessoaSecundaria;
    property NomPessoaSecundaria         : String      read FNomPessoaSecundaria         write FNomPessoaSecundaria;
    property NomReduzidoPessoaSecundaria : String      read FNomReduzidoPessoaSecundaria write FNomReduzidoPessoaSecundaria;
    property CodNaturezaPessoa           : String      read FCodNaturezaPessoa           write FCodNaturezaPessoa;
    property DtaCadastramento            : TDateTime   read FDtaCadastramento            write FDtaCadastramento;
    property NumCNPJCPF                  : String      read FNumCNPJCPF                  write FNumCNPJCPF;
    property NumCNPJCPFFormatado         : String      read FNumCNPJCPFFormatado         write FNumCNPJCPFFormatado;
    property CodTipoContato1             : Integer     read FCodTipoContato1             write FCodTipoContato1;
    property DesTipoContato1             : String      read FDesTipoContato1             write FDesTipoContato1;
    property TxtContato1                 : String      read FTxtContato1                 write FTxtContato1;
    property CodTipoContato2             : Integer     read FCodTipoContato2             write FCodTipoContato2;
    property DesTipoContato2             : String      read FDesTipoContato2             write FDesTipoContato2;
    property TxtContato2                 : String      read FTxtContato2                 write FTxtContato2;
    property CodTipoContato3             : Integer     read FCodTipoContato3             write FCodTipoContato3;
    property DesTipoContato3             : String      read FDesTipoContato3             write FDesTipoContato3;
    property TxtContato3                 : String      read FTxtContato3                 write FTxtContato3;
    property CodTipoEndereco             : Integer     read FCodTipoEndereco             write FCodTipoEndereco;
    property NomLogradouro               : String      read FNomLogradouro               write FNomLogradouro;
    property NomBairro                   : String      read FNomBairro                   write FNomBairro;
    property NumCep                      : String      read FNumCep                      write FNumCep;
    property NomPais                     : String      read FNomPais                     write FNomPais;
    property SglEstado                   : String      read FSglEstado                   write FSglEstado;
    property NomMunicipio                : String      read FNomMunicipio                write FNomMunicipio;
    property NumMunicipioIBGE            : String      read FNumMunicipioIBGE            write FNumMunicipioIBGE;
    property NomDistrito                 : String      read FNomDistrito                 write FNomDistrito;
    property txtObservacao               : String      read FtxtObservacao               write FtxtObservacao;
  end;

implementation

end.
