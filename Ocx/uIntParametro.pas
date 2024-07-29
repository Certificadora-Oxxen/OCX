// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Controle de acesso - definição das classes
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Parametros
// ************************************************************************
// *  Últimas Alterações
// *   Hítalo    02/09/2002    Criação
// *
// ********************************************************************
unit uIntParametro;

interface
  type
    TIntParametro = class
  private
    FCodPaisCertificadora          : Integer;
    FNomPaisCertificadora          : WideString;
    FCodPaisSisBovCertificadora    : Integer;
    FIndCodCertificadoraAutomatico : WideString;
  public
    property CodPaisCertificadora          : Integer    read FCodPaisCertificadora          write FCodPaisCertificadora;
    property NomPaisCertificadora          : WideString read FNomPaisCertificadora          write FNomPaisCertificadora;
    property CodPaisSisBovCertificadora    : Integer    read FCodPaisSisBovCertificadora    write FCodPaisSisBovCertificadora;
    property IndCodCertificadoraAutomatico : WideString read FIndCodCertificadoraAutomatico write FIndCodCertificadoraAutomatico;
  end;
implementation

end.
