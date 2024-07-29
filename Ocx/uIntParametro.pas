// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 25/07/2002
// *  Documenta��o       : Controle de acesso - defini��o das classes
// *  C�digo Classe      :
// *  Descri��o Resumida : Cadastro de Parametros
// ************************************************************************
// *  �ltimas Altera��es
// *   H�talo    02/09/2002    Cria��o
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
