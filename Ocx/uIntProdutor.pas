// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Controle de acesso - definição das classes
// *  Código Classe      : 
// *  Descrição Resumida : Cadastro de Produtor
// *****************************************************************************
// *  Últimas Alterações
// *   Jerry    25/07/2002    Criação
// *   Hitalo   02/09/2002    Carrega/Adicionar SglProdutor,QtdCaracterCodManejo
// *
// *****************************************************************************
unit uIntProdutor;

interface

type
  TIntProdutor = class
  private
    FCodProdutor: Integer;
    FNomProdutor: String;
    FCodNatureza: String;
    FNumCPFCNPJ: String;
    FNumCPFCNPJFormatado: String;
    FSglProdutor  : String;
    FQtdCaracterCodManejo : Integer;
    FIndConsultaPublica  : String;
    FCodTipoAgrupamentoRacas  : Integer;
    FQtdDenominadorCompRacial  : Integer;
    FQtdDiasEntreCoberturas: Integer;
    FQtdDiasDescansoReprodutivo: Integer;
    FQtdDiasDiagnosticoGestacao: Integer;
    FCodAptidao: Integer;
    FCodSituacaoSisBov: String;
    FIndMostrarNome: String;
    FIndMostrarIdentificadores: String;
    FIndTransfereEmbrioes: String;
    FIndMostrarFiltroCompRacial: String;
    FIndEstacaoMonta: String;
    FIndTrabalhaAssociacaoRaca: String;
    FQtdIdadeMinimaDesmame: Integer;
    FQtdIdadeMaximaDesmame: Integer;
    FIndAplicarDesmameAutomatico: String;
  public
    property CodProdutor:                 Integer read FCodProdutor                 write FCodProdutor;
    property NomProdutor:                 String  read FNomProdutor                 write FNomProdutor;
    property CodNatureza:                 String  read FCodNatureza                 write FCodNatureza;
    property NumCPFCNPJ:                  String  read FNumCPFCNPJ                  write FNumCPFCNPJ;
    property NumCPFCNPJFormatado:         String  read FNumCPFCNPJFormatado         write FNumCPFCNPJFormatado;
    property SglProdutor:                 String  read FSglProdutor                 write FSglProdutor;
    property QtdCaracterCodManejo:        Integer read FQtdCaracterCodManejo        write FQtdCaracterCodManejo;
    property IndConsultaPublica:          String  read FIndConsultaPublica          write FIndConsultaPublica;
    property CodTipoAgrupamentoRacas:     Integer read FCodTipoAgrupamentoRacas     write FCodTipoAgrupamentoRacas;
    property QtdDenominadorCompRacial:    Integer read FQtdDenominadorCompRacial    write FQtdDenominadorCompRacial;
    property QtdDiasEntreCoberturas:      Integer read FQtdDiasEntreCoberturas      write FQtdDiasEntreCoberturas;
    property QtdDiasDescansoReprodutivo:  Integer read FQtdDiasDescansoReprodutivo  write FQtdDiasDescansoReprodutivo;
    property QtdDiasDiagnosticoGestacao:  Integer read FQtdDiasDiagnosticoGestacao  write FQtdDiasDiagnosticoGestacao;
    property CodAptidao:                  Integer read FCodAptidao                  write FCodAptidao;
    property CodSituacaoSisBov:           String  read FCodSituacaoSisBov           write FCodSituacaoSisBov;
    property IndMostrarNome:              String  read FIndMostrarNome              write FIndMostrarNome;
    property IndMostrarIdentificadores:   String  read FIndMostrarIdentificadores   write FIndMostrarIdentificadores;
    property IndTransfereEmbrioes:        String  read FIndTransfereEmbrioes        write FIndTransfereEmbrioes;
    property IndMostrarFiltroCompRacial:  String  read FIndMostrarFiltroCompRacial  write FIndMostrarFiltroCompRacial;
    property IndEstacaoMonta:             String  read FIndEstacaoMonta             write FIndEstacaoMonta;
    property IndTrabalhaAssociacaoRaca:   String  read FIndTrabalhaAssociacaoRaca   write FIndTrabalhaAssociacaoRaca;
    property QtdIdadeMinimaDesmame:       Integer read FQtdIdadeMinimaDesmame       write FQtdIdadeMinimaDesmame;
    property QtdIdadeMaximaDesmame:       Integer read FQtdIdadeMaximaDesmame       write FQtdIdadeMaximaDesmame;
    property IndAplicarDesmameAutomatico: String  read FIndAplicarDesmameAutomatico write FIndAplicarDesmameAutomatico;
  end;

implementation

end.
