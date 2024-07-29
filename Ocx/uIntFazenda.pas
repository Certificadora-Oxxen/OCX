// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Propriedade Rural,fazenda, etc - Definição das Classes.doc
// *  Código Classe      : 34
// *  Descrição Resumida : Cadastro de Fazenda
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    24/07/2002    Criação
// *   Arley    13/08/2002    Alteração nos atributos desta classe
// *   Arley    13/11/2002    Inclusão da propriedade IndSituacaoImagem
// *   Hitalo    19/11/2002    Adcionar metodo GerarRelatorio.
// *
// ****************************************************************************
unit uIntFazenda;

interface

type
  TIntFazenda = class
  private
    FCodPessoaProdutor: Integer;
    FCodFazenda: Integer;
    FSglFazenda: String;
    FNomFazenda: String;
    FCodEstado: Integer;
    FSglEstado: String;
    FNumPropriedadeRural: String;
    FTxtObservacao: String;
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: String;
    FNumImovelReceitaFederalPR: String;
    FNomMunicipioPR: String;
    FSglEstadoPR: String;
    FNomPaisPR: String;
    FIndSituacaoImagem: String;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FIndEfetivadoUmaVez: String;
    FCodLocalizacaoSisbov: Integer;
    FCodRegimePosseUso: Integer;
    FDesRegimePosseUso: String;
    FCodUlavPro: String;
    FCodUlavFaz: String;
    FQtdDistMunicipio: Integer;
    FCodIdPropriedadeSisbov: Integer;
    FDesAcessoFaz: String;

  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property SglFazenda: String read FSglFazenda write FSglFazenda;
    property NomFazenda: String read FNomFazenda write FNomFazenda;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: String read FSglEstado write FSglEstado;
    property NumPropriedadeRural: String read FNumPropriedadeRural write FNumPropriedadeRural;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: String read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederalPR: String read FNumImovelReceitaFederalPR write FNumImovelReceitaFederalPR;
    property NomMunicipioPR: String read FNomMunicipioPR write FNomMunicipioPR;
    property SglEstadoPR: String read FSglEstadoPR write FSglEstadoPR;
    property NomPaisPR: String read FNomPaisPR write FNomPaisPR;
    property IndSituacaoImagem: String read FIndSituacaoImagem write FIndSituacaoImagem;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property IndEfetivadoUmaVez: String read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodLocalizacaoSisbov: Integer read FCodLocalizacaoSisbov write FCodLocalizacaoSisbov;
    property CodRegimePosseUso: Integer read FCodRegimePosseUso write FCodRegimePosseUso;
    property DesRegimePosseUso: String read FDesRegimePosseUso write FDesRegimePosseUso;
    property CodUlavPro: String read FCodUlavPro write FCodUlavPro;
    property CodUlavFaz: String read FCodUlavFaz write FCodUlavFaz;
    property QtdDistMunicipio: Integer read FQtdDistMunicipio write FQtdDistMunicipio;
    property DesAcessoFaz: String read FDesAcessoFaz write FDesAcessoFaz;
    property CodIdPropriedadeSisbov: Integer read FCodIdPropriedadeSisbov write FCodIdPropriedadeSisbov;
  end;

implementation

end.
