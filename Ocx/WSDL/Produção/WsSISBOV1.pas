// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : WsSISBOV.xml
//  >Import : WsSISBOV.xml:0
//  >Import : WsSISBOV.xml:1
//  >Import : WsSISBOV.xml:2
//  >Import : WsSISBOV.xml:3
// Encoding : UTF-8
// Version  : 1.0
// (16/5/2008 18:54:43 - - $Rev: 7300 $)
// ************************************************************************ //

unit WsSISBOV1;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:long            - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  NumeroSimplificado   = class;                 { "http://model.sisbov.mapa.gov.br"[GblCplx] }
  GtaDTO               = class;                 { "http://model.sisbov.mapa.gov.br"[GblCplx] }
  ObjetoPersistente    = class;                 { "http://persistence.serpro.gov.br"[GblCplx] }
  RegistroTabelaDominio = class;                { "http://model.sisbov.mapa.gov.br"[GblCplx] }
  RetornoWsSISBOV      = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoFinalizarSolicNumAnimalImportado = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoCancelarSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoExcluirVistoria = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoCancelarMovimentacao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoInventarioSolicitacao = class;         { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoInformarMovimentacao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoDesligamentoAnimal = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoMorteAnimal   = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarDadosAnimalImportado = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarMovimentacao = class;         { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarDadosAnimal = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarSenha  = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarEmail = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoCadastrarEmail = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoRecuperarSenha = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarIE     = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarAnimal = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirAnimal = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoRecuperarNumeracaoReimpressao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultaSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoRecuperarNumeracao = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoSolicitacaoNumeracaoReimpressao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoSolicitacaoNumeracao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirVistoriaERAS = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoVincularProdutorPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoDesvincularProprietarioPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoDesvincularProdutorPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoVincularProprietarioPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarPropriedade = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirPropriedade = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarPropriedade = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarSupervisor = class;             { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirSupervisor = class;             { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarProdutor = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirProdutor = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoAlterarProprietario = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoIncluirProprietario = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoRecuperarTabela = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  RetornoConsultarAnimaisAbatidos = class;      { "http://retorno.servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  Erro                 = class;                 { "http://model.sisbov.mapa.gov.br"[GblCplx] }
  item2                = class;                 { "http://servicosWeb.sisbov.mapa.gov.br"[Alias] }
  item3                = class;                 { "http://servicosWeb.sisbov.mapa.gov.br"[Alias] }
  item4                = class;                 { "http://servicosWeb.sisbov.mapa.gov.br"[Alias] }

  ArrayOf_tns2_Erro = array of item2;           { "http://servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  ArrayOf_tns2_RegistroTabelaDominio = array of item3;   { "http://servicosWeb.sisbov.mapa.gov.br"[GblCplx] }
  ArrayOf_tns2_NumeroSimplificado = array of item4;   { "http://servicosWeb.sisbov.mapa.gov.br"[GblCplx] }


  // ************************************************************************ //
  // XML       : NumeroSimplificado, global, <complexType>
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  NumeroSimplificado = class(TRemotable)
  private
    Fnumero: WideString;
    FstatusUtilizacao: WideString;
  published
    property numero:           WideString  Index (IS_NLBL) read Fnumero write Fnumero;
    property statusUtilizacao: WideString  Index (IS_NLBL) read FstatusUtilizacao write FstatusUtilizacao;
  end;



  // ************************************************************************ //
  // XML       : GtaDTO, global, <complexType>
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  GtaDTO = class(TRemotable)
  private
    FnumeroGTA: WideString;
    FnumeroSerie: WideString;
    FqtdeAnimais: Int64;
    Fuf: WideString;
  published
    property numeroGTA:   WideString  Index (IS_NLBL) read FnumeroGTA write FnumeroGTA;
    property numeroSerie: WideString  Index (IS_NLBL) read FnumeroSerie write FnumeroSerie;
    property qtdeAnimais: Int64       read FqtdeAnimais write FqtdeAnimais;
    property uf:          WideString  Index (IS_NLBL) read Fuf write Fuf;
  end;



  // ************************************************************************ //
  // XML       : ObjetoPersistente, global, <complexType>
  // Namespace : http://persistence.serpro.gov.br
  // ************************************************************************ //
  ObjetoPersistente = class(TRemotable)
  private
    Fid: Int64;
  published
    property id: Int64  Index (IS_NLBL) read Fid write Fid;
  end;



  // ************************************************************************ //
  // XML       : RegistroTabelaDominio, global, <complexType>
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  RegistroTabelaDominio = class(ObjetoPersistente)
  private
    Fcodigo: WideString;
    Fdescricao: WideString;
  published
    property codigo:    WideString  Index (IS_NLBL) read Fcodigo write Fcodigo;
    property descricao: WideString  Index (IS_NLBL) read Fdescricao write Fdescricao;
  end;



  // ************************************************************************ //
  // XML       : RetornoWsSISBOV, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoWsSISBOV = class(TRemotable)
  private
    Fambiente: WideString;
    FerroBanco: WideString;
    FidTransacao: Int64;
    FlistaErros: ArrayOf_tns2_Erro;
    Fstatus: Integer;
    Ftrace: WideString;
  public
    destructor Destroy; override;
  published
    property ambiente:    WideString         Index (IS_NLBL) read Fambiente write Fambiente;
    property erroBanco:   WideString         Index (IS_NLBL) read FerroBanco write FerroBanco;
    property idTransacao: Int64              read FidTransacao write FidTransacao;
    property listaErros:  ArrayOf_tns2_Erro  Index (IS_NLBL) read FlistaErros write FlistaErros;
    property status:      Integer            read Fstatus write Fstatus;
    property trace:       WideString         Index (IS_NLBL) read Ftrace write Ftrace;
  end;



  // ************************************************************************ //
  // XML       : RetornoFinalizarSolicNumAnimalImportado, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoFinalizarSolicNumAnimalImportado = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoCancelarSolicitacaoNumeracao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCancelarSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarSolicitacaoNumeracao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoExcluirVistoria, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoExcluirVistoria = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoCancelarMovimentacao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCancelarMovimentacao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoInventarioSolicitacao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoInventarioSolicitacao = class(RetornoWsSISBOV)
  private
    FidSolicitacao: Int64;
  published
    property idSolicitacao: Int64  read FidSolicitacao write FidSolicitacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoInformarMovimentacao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoInformarMovimentacao = class(RetornoWsSISBOV)
  private
    Fchave: Int64;
  published
    property chave: Int64  read Fchave write Fchave;
  end;



  // ************************************************************************ //
  // XML       : RetornoDesligamentoAnimal, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesligamentoAnimal = class(RetornoWsSISBOV)
  private
    FidMorte: Int64;
  published
    property idMorte: Int64  read FidMorte write FidMorte;
  end;



  // ************************************************************************ //
  // XML       : RetornoMorteAnimal, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoMorteAnimal = class(RetornoWsSISBOV)
  private
    FidMorte: Int64;
  published
    property idMorte: Int64  read FidMorte write FidMorte;
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultarDadosAnimalImportado, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarDadosAnimalImportado = class(RetornoWsSISBOV)
  private
    FanoImportacao: WideString;
    FdataEntrada: WideString;
    FdataIdentificacao: WideString;
    FdataInclusao: WideString;
    FdataNascimento: WideString;
    FdataNascimentoEstimada: WideString;
    Fdia: WideString;
    Fnome: WideString;
    Fnumero: WideString;
    FnumeroDefinitivo: WideString;
    FnumeroProvisorio: WideString;
    Fobservacao: WideString;
    Fpais: WideString;
    Fraca: WideString;
    FregistroAssociacao: WideString;
    Fsexo: WideString;
    FtipoIdentificacao: WideString;
  published
    property anoImportacao:          WideString  Index (IS_NLBL) read FanoImportacao write FanoImportacao;
    property dataEntrada:            WideString  Index (IS_NLBL) read FdataEntrada write FdataEntrada;
    property dataIdentificacao:      WideString  Index (IS_NLBL) read FdataIdentificacao write FdataIdentificacao;
    property dataInclusao:           WideString  Index (IS_NLBL) read FdataInclusao write FdataInclusao;
    property dataNascimento:         WideString  Index (IS_NLBL) read FdataNascimento write FdataNascimento;
    property dataNascimentoEstimada: WideString  Index (IS_NLBL) read FdataNascimentoEstimada write FdataNascimentoEstimada;
    property dia:                    WideString  Index (IS_NLBL) read Fdia write Fdia;
    property nome:                   WideString  Index (IS_NLBL) read Fnome write Fnome;
    property numero:                 WideString  Index (IS_NLBL) read Fnumero write Fnumero;
    property numeroDefinitivo:       WideString  Index (IS_NLBL) read FnumeroDefinitivo write FnumeroDefinitivo;
    property numeroProvisorio:       WideString  Index (IS_NLBL) read FnumeroProvisorio write FnumeroProvisorio;
    property observacao:             WideString  Index (IS_NLBL) read Fobservacao write Fobservacao;
    property pais:                   WideString  Index (IS_NLBL) read Fpais write Fpais;
    property raca:                   WideString  Index (IS_NLBL) read Fraca write Fraca;
    property registroAssociacao:     WideString  Index (IS_NLBL) read FregistroAssociacao write FregistroAssociacao;
    property sexo:                   WideString  Index (IS_NLBL) read Fsexo write Fsexo;
    property tipoIdentificacao:      WideString  Index (IS_NLBL) read FtipoIdentificacao write FtipoIdentificacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultarMovimentacao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarMovimentacao = class(RetornoWsSISBOV)
  private
    FidMovimentacao: Int64;
    FnrAcionamentos: Int64;
    FnrInicialSisbov: WideString;
    FqtdeAnimaisMovimentado: Int64;
  published
    property idMovimentacao:         Int64       read FidMovimentacao write FidMovimentacao;
    property nrAcionamentos:         Int64       read FnrAcionamentos write FnrAcionamentos;
    property nrInicialSisbov:        WideString  Index (IS_NLBL) read FnrInicialSisbov write FnrInicialSisbov;
    property qtdeAnimaisMovimentado: Int64       read FqtdeAnimaisMovimentado write FqtdeAnimaisMovimentado;
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultarDadosAnimal, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarDadosAnimal = class(RetornoWsSISBOV)
  private
    FdataIdentificacao: WideString;
    FdataInclusao: WideString;
    FdataLiberacaoAbate: WideString;
    FdataNascimento: WideString;
    Fdia: WideString;
    Fnumero: WideString;
    FnumeroDefinitivo: WideString;
    FnumeroProvisorio: WideString;
    Fpais: WideString;
    Fraca: WideString;
    Fsexo: WideString;
    FtipoIdentificacao: WideString;
  published
    property dataIdentificacao:  WideString  Index (IS_NLBL) read FdataIdentificacao write FdataIdentificacao;
    property dataInclusao:       WideString  Index (IS_NLBL) read FdataInclusao write FdataInclusao;
    property dataLiberacaoAbate: WideString  Index (IS_NLBL) read FdataLiberacaoAbate write FdataLiberacaoAbate;
    property dataNascimento:     WideString  Index (IS_NLBL) read FdataNascimento write FdataNascimento;
    property dia:                WideString  Index (IS_NLBL) read Fdia write Fdia;
    property numero:             WideString  Index (IS_NLBL) read Fnumero write Fnumero;
    property numeroDefinitivo:   WideString  Index (IS_NLBL) read FnumeroDefinitivo write FnumeroDefinitivo;
    property numeroProvisorio:   WideString  Index (IS_NLBL) read FnumeroProvisorio write FnumeroProvisorio;
    property pais:               WideString  Index (IS_NLBL) read Fpais write Fpais;
    property raca:               WideString  Index (IS_NLBL) read Fraca write Fraca;
    property sexo:               WideString  Index (IS_NLBL) read Fsexo write Fsexo;
    property tipoIdentificacao:  WideString  Index (IS_NLBL) read FtipoIdentificacao write FtipoIdentificacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarSenha, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSenha = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultarEmail, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarEmail = class(RetornoWsSISBOV)
  private
    Femail: WideString;
  published
    property email: WideString  Index (IS_NLBL) read Femail write Femail;
  end;



  // ************************************************************************ //
  // XML       : RetornoCadastrarEmail, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCadastrarEmail = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoRecuperarSenha, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarSenha = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarIE, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarIE = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarAnimal, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarAnimal = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirAnimal, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirAnimal = class(RetornoWsSISBOV)
  private
    FdataLiberacaoAbate: WideString;
    Fdia: WideString;
  published
    property dataLiberacaoAbate: WideString  Index (IS_NLBL) read FdataLiberacaoAbate write FdataLiberacaoAbate;
    property dia:                WideString  Index (IS_NLBL) read Fdia write Fdia;
  end;



  // ************************************************************************ //
  // XML       : RetornoRecuperarNumeracaoReimpressao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarNumeracaoReimpressao = class(RetornoWsSISBOV)
  private
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
  public
    destructor Destroy; override;
  published
    property numeracao: ArrayOf_tns2_NumeroSimplificado  Index (IS_NLBL) read Fnumeracao write Fnumeracao;
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultaSolicitacaoNumeracao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultaSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
    FdataUltimaAlteracao: WideString;
    FnrSolicitacao: Int64;
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
    Fobservacao: WideString;
    Fsituacao: Int64;
  public
    destructor Destroy; override;
  published
    property dataUltimaAlteracao: WideString                       Index (IS_NLBL) read FdataUltimaAlteracao write FdataUltimaAlteracao;
    property nrSolicitacao:       Int64                            Index (IS_NLBL) read FnrSolicitacao write FnrSolicitacao;
    property numeracao:           ArrayOf_tns2_NumeroSimplificado  Index (IS_NLBL) read Fnumeracao write Fnumeracao;
    property observacao:          WideString                       Index (IS_NLBL) read Fobservacao write Fobservacao;
    property situacao:            Int64                            Index (IS_NLBL) read Fsituacao write Fsituacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoRecuperarNumeracao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarNumeracao = class(RetornoWsSISBOV)
  private
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
  public
    destructor Destroy; override;
  published
    property numeracao: ArrayOf_tns2_NumeroSimplificado  Index (IS_NLBL) read Fnumeracao write Fnumeracao;
  end;



  // ************************************************************************ //
  // XML       : RetornoSolicitacaoNumeracaoReimpressao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoSolicitacaoNumeracaoReimpressao = class(RetornoWsSISBOV)
  private
    FnumeroSolicitacao: Int64;
  published
    property numeroSolicitacao: Int64  read FnumeroSolicitacao write FnumeroSolicitacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoSolicitacaoNumeracao, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
    FnumeroSolicitacao: Int64;
  public
    destructor Destroy; override;
  published
    property numeracao:         ArrayOf_tns2_NumeroSimplificado  Index (IS_NLBL) read Fnumeracao write Fnumeracao;
    property numeroSolicitacao: Int64                            read FnumeroSolicitacao write FnumeroSolicitacao;
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirVistoriaERAS, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirVistoriaERAS = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoVincularProdutorPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoVincularProdutorPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoDesvincularProprietarioPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesvincularProprietarioPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoDesvincularProdutorPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesvincularProdutorPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoVincularProprietarioPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoVincularProprietarioPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirPropriedade = class(RetornoWsSISBOV)
  private
    FidPropriedade: Int64;
  published
    property idPropriedade: Int64  read FidPropriedade write FidPropriedade;
  end;



  // ************************************************************************ //
  // XML       : RetornoConsultarPropriedade, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarPropriedade = class(RetornoWsSISBOV)
  private
    FacessoFazenda: WideString;
    Farea: WideString;
    Fbairro: WideString;
    Fcep: WideString;
    FcodMunicipio: WideString;
    FdistanciaSedeMunicipio: WideString;
    FenderecoCorrespondenciaBairro: WideString;
    FenderecoCorrespondenciaCep: WideString;
    FenderecoCorrespondenciaCodMunicipio: WideString;
    FenderecoCorrespondenciaLogradouro: WideString;
    FfaxResidencial: WideString;
    FgrauLatitude: WideString;
    FgrauLongitude: WideString;
    Fincra: WideString;
    Flogradouro: WideString;
    FminutoLatitude: WideString;
    FminutoLongitude: WideString;
    Fnirf: WideString;
    FnomePropriedade: WideString;
    FnrFaxContato: WideString;
    FnrTelefoneContato: WideString;
    ForientacaoLatitude: WideString;
    ForientacaoLongitude: WideString;
    FsegundoLatitude: WideString;
    FsegundoLongitude: WideString;
    FtelefoneResidencial: WideString;
    FtipoPropriedade: WideString;
  published
    property acessoFazenda:                       WideString  Index (IS_NLBL) read FacessoFazenda write FacessoFazenda;
    property area:                                WideString  Index (IS_NLBL) read Farea write Farea;
    property bairro:                              WideString  Index (IS_NLBL) read Fbairro write Fbairro;
    property cep:                                 WideString  Index (IS_NLBL) read Fcep write Fcep;
    property codMunicipio:                        WideString  Index (IS_NLBL) read FcodMunicipio write FcodMunicipio;
    property distanciaSedeMunicipio:              WideString  Index (IS_NLBL) read FdistanciaSedeMunicipio write FdistanciaSedeMunicipio;
    property enderecoCorrespondenciaBairro:       WideString  Index (IS_NLBL) read FenderecoCorrespondenciaBairro write FenderecoCorrespondenciaBairro;
    property enderecoCorrespondenciaCep:          WideString  Index (IS_NLBL) read FenderecoCorrespondenciaCep write FenderecoCorrespondenciaCep;
    property enderecoCorrespondenciaCodMunicipio: WideString  Index (IS_NLBL) read FenderecoCorrespondenciaCodMunicipio write FenderecoCorrespondenciaCodMunicipio;
    property enderecoCorrespondenciaLogradouro:   WideString  Index (IS_NLBL) read FenderecoCorrespondenciaLogradouro write FenderecoCorrespondenciaLogradouro;
    property faxResidencial:                      WideString  Index (IS_NLBL) read FfaxResidencial write FfaxResidencial;
    property grauLatitude:                        WideString  Index (IS_NLBL) read FgrauLatitude write FgrauLatitude;
    property grauLongitude:                       WideString  Index (IS_NLBL) read FgrauLongitude write FgrauLongitude;
    property incra:                               WideString  Index (IS_NLBL) read Fincra write Fincra;
    property logradouro:                          WideString  Index (IS_NLBL) read Flogradouro write Flogradouro;
    property minutoLatitude:                      WideString  Index (IS_NLBL) read FminutoLatitude write FminutoLatitude;
    property minutoLongitude:                     WideString  Index (IS_NLBL) read FminutoLongitude write FminutoLongitude;
    property nirf:                                WideString  Index (IS_NLBL) read Fnirf write Fnirf;
    property nomePropriedade:                     WideString  Index (IS_NLBL) read FnomePropriedade write FnomePropriedade;
    property nrFaxContato:                        WideString  Index (IS_NLBL) read FnrFaxContato write FnrFaxContato;
    property nrTelefoneContato:                   WideString  Index (IS_NLBL) read FnrTelefoneContato write FnrTelefoneContato;
    property orientacaoLatitude:                  WideString  Index (IS_NLBL) read ForientacaoLatitude write ForientacaoLatitude;
    property orientacaoLongitude:                 WideString  Index (IS_NLBL) read ForientacaoLongitude write ForientacaoLongitude;
    property segundoLatitude:                     WideString  Index (IS_NLBL) read FsegundoLatitude write FsegundoLatitude;
    property segundoLongitude:                    WideString  Index (IS_NLBL) read FsegundoLongitude write FsegundoLongitude;
    property telefoneResidencial:                 WideString  Index (IS_NLBL) read FtelefoneResidencial write FtelefoneResidencial;
    property tipoPropriedade:                     WideString  Index (IS_NLBL) read FtipoPropriedade write FtipoPropriedade;
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarSupervisor, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSupervisor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirSupervisor, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirSupervisor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarProdutor, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarProdutor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirProdutor, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirProdutor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoAlterarProprietario, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarProprietario = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoIncluirProprietario, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirProprietario = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave:     WideString  Index (IS_NLBL) read Fchave write Fchave;
    property tipoChave: WideString  Index (IS_NLBL) read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // XML       : RetornoRecuperarTabela, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarTabela = class(RetornoWsSISBOV)
  private
    Fregistros: ArrayOf_tns2_RegistroTabelaDominio;
  public
    destructor Destroy; override;
  published
    property registros: ArrayOf_tns2_RegistroTabelaDominio  Index (IS_NLBL) read Fregistros write Fregistros;
  end;

  item            =  type WideString;      { "http://servicosWeb.sisbov.mapa.gov.br"[Alias] }
  ArrayOf_xsd_string = array of item;           { "http://servicosWeb.sisbov.mapa.gov.br"[GblCplx] }


  // ************************************************************************ //
  // XML       : RetornoConsultarAnimaisAbatidos, global, <complexType>
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarAnimaisAbatidos = class(RetornoWsSISBOV)
  private
    Fanimais: ArrayOf_xsd_string;
  published
    property animais: ArrayOf_xsd_string  Index (IS_NLBL) read Fanimais write Fanimais;
  end;



  // ************************************************************************ //
  // XML       : Erro, global, <complexType>
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  Erro = class(TRemotable)
  private
    FcodigoErro: WideString;
    FmenssagemErro: WideString;
    FpilhaDeErro: WideString;
    FvalorInformado: ArrayOf_xsd_string;
  published
    property codigoErro:     WideString          Index (IS_NLBL) read FcodigoErro write FcodigoErro;
    property menssagemErro:  WideString          Index (IS_NLBL) read FmenssagemErro write FmenssagemErro;
    property pilhaDeErro:    WideString          Index (IS_NLBL) read FpilhaDeErro write FpilhaDeErro;
    property valorInformado: ArrayOf_xsd_string  Index (IS_NLBL) read FvalorInformado write FvalorInformado;
  end;



  // ************************************************************************ //
  // XML       : item, alias
  // Namespace : http://servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  item2 = class(Erro)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : item, alias
  // Namespace : http://servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  item3 = class(RegistroTabelaDominio)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : item, alias
  // Namespace : http://servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  item4 = class(NumeroSimplificado)
  private
  published
  end;

  Array_Of_string = array of WideString;        { "http://www.w3.org/2001/XMLSchema"[GblUbnd] }
  Array_Of_GtaDTO = array of GtaDTO;            { "http://model.sisbov.mapa.gov.br"[GblUbnd] }

  // ************************************************************************ //
  // Namespace : http://servicosWeb.sisbov.mapa.gov.br
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : WsSISBOVSoapBinding
  // service   : WsSISBOVService
  // port      : WsSISBOV
  // URL       : http://extranet.agricultura.gov.br/sisbov_ws_prd/services/WsSISBOV
  // ************************************************************************ //
  WsSISBOV = interface(IInvokable)
  ['{F2538DF6-5D8C-6916-05AC-1035B5A39B2F}']
    function  recuperarTabela(const usuario: WideString; const senha: WideString; const idTabela: Int64): RetornoRecuperarTabela; stdcall;
    function  recuperarTabelaMunicipios(const usuario: WideString; const senha: WideString; const uf: WideString): RetornoRecuperarTabela; stdcall;
    function  incluirProprietario(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; 
                                  const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; 
                                  const _cep: WideString; const _codMunicipio: WideString): RetornoIncluirProprietario; stdcall;
    function  alterarProprietario(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; 
                                  const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; 
                                  const _cep: WideString; const _codMunicipio: WideString): RetornoAlterarProprietario; stdcall;
    function  incluirProdutor(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; 
                              const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; 
                              const _cep: WideString; const _codMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; 
                              const _nrFaxContato: WideString): RetornoIncluirProdutor; stdcall;
    function  alterarProdutor(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; 
                              const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; 
                              const _cep: WideString; const _codMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; 
                              const _nrFaxContato: WideString): RetornoAlterarProdutor; stdcall;
    function  incluirSupervisor(const usuario: WideString; const senha: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; 
                                const _rg: WideString; const _dataNascimento: WideString; const _dataExpedicao: WideString; const _OrgaoExpedidor: WideString; const _ufExpedidor: WideString; 
                                const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString
                                ): RetornoIncluirSupervisor; stdcall;
    function  alterarSupervisor(const usuario: WideString; const senha: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; 
                                const _rg: WideString; const _dataNascimento: WideString; const _dataExpedicao: WideString; const _OrgaoExpedidor: WideString; const _ufExpedidor: WideString; 
                                const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString
                                ): RetornoAlterarSupervisor; stdcall;
    function  consultarPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoConsultarPropriedade; stdcall;
    function  incluirPropriedade(const usuario: WideString; const senha: WideString; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; const _nomePropriedade: WideString; 
                                 const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString; const _grauLatitude: Integer; const _minutoLatitude: Integer; 
                                 const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; const _segundoLongitude: Integer; 
                                 const _area: Int64; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString; 
                                 const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; const _telefoneResidencial: WideString; 
                                 const _faxResidencial: WideString; const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoIncluirPropriedade; stdcall;
    function  alterarPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; 
                                 const _nomePropriedade: WideString; const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString; const _grauLatitude: Integer; 
                                 const _minutoLatitude: Integer; const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; 
                                 const _segundoLongitude: Integer; const _area: Int64; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; 
                                 const _codMunicipio: WideString; const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; 
                                 const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoAlterarPropriedade; stdcall;
    function  vincularProprietarioPropriedade(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64; const situacaoFundiaria: Int64
                                              ): RetornoVincularProprietarioPropriedade; stdcall;
    function  desvincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64): RetornoDesvincularProdutorPropriedade; stdcall;
    function  desvincularPropriedadeProprietario(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64): RetornoDesvincularProprietarioPropriedade; stdcall;
    function  vincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const IEProdutor: WideString; 
                                          const ufIE: WideString; const tipoProdutor: Int64): RetornoVincularProdutorPropriedade; stdcall;
    function  incluirVistoriaERAS(const usuario: WideString; const senha: WideString; const cpfSupervisor: WideString; const idPropriedade: Int64; const data: WideString): RetornoIncluirVistoriaERAS; stdcall;
    function  solicitarNumeracao(const usuario: WideString; const senha: WideString; const cnpjFabrica: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; 
                                 const qtdeSolicitada: Int64; const tipoIdentificacao: Int64): RetornoSolicitacaoNumeracao; stdcall;
    function  solicitarNumeracaoReimpressao(const usuario: WideString; const senha: WideString; const cnpjFabrica: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; 
                                            const numeros: Array_Of_string; const tipoIdentificacao: Int64): RetornoSolicitacaoNumeracaoReimpressao; stdcall;
    function  recuperarNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoRecuperarNumeracao; stdcall;
    function  consultaSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoConsultaSolicitacaoNumeracao; stdcall;
    function  recuperarNumeracaoReimpressao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoRecuperarNumeracaoReimpressao; stdcall;
    function  incluirAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; 
                            const idPropriedadeNascimento: Int64; const idPropriedadeLocalizacao: Int64; const idPropriedadeResponsavel: Int64; const numeroSisbov: WideString; const codigoRaca: WideString; 
                            const tipoIdentificacao: Int64; const sexo: WideString; const cnpjProdutor: WideString; const cpfProdutor: WideString): RetornoIncluirAnimal; stdcall;
    function  incluirAnimalImportado(const usuario: WideString; const senha: WideString; const codigoRaca: WideString; const nome: WideString; const codPais: WideString; const registroAssociacao: WideString; 
                                     const numeroSisbov: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedade: Int64; const cnpjProdutor: WideString; 
                                     const cpfProdutor: WideString; const anoImportacao: Integer; const dataEntradaPais: WideString; const dataNascimento: WideString; const dataNascimentoEstimada: WideString; 
                                     const sexo: WideString; const dataIdentificacao: WideString; const tipoIdentificacao: Integer; const obs: WideString): RetornoIncluirAnimal; stdcall;
    function  alterarAnimalImportado(const usuario: WideString; const senha: WideString; const nome: WideString; const registroAssociacao: WideString; const numeroSisbov: WideString; const numeroProvisorio: WideString; 
                                     const numeroDefinitivo: WideString; const sexo: WideString; const dataIdentificacao: WideString; const obs: WideString): RetornoAlterarAnimal; stdcall;
    function  alterarAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; 
                            const idPropriedadeNascimento: Int64; const numeroSisbov: WideString; const codigoRaca: WideString; const tipoIdentificacao: Int64; const sexo: WideString
                            ): RetornoAlterarAnimal; stdcall;
    function  alterarIE(const usuario: WideString; const senha: WideString; const cpf: WideString; const cnpj: WideString; const idPropriedade: WideString; const numeroIE: WideString
                        ): RetornoAlterarIE; stdcall;
    function  recuperarSenha(const usuario: WideString; const email: WideString): RetornoRecuperarSenha; stdcall;
    function  cadastrarEmail(const usuario: WideString; const senha: WideString; const email: WideString): RetornoCadastrarEmail; stdcall;
    function  consultarEmail(const usuario: WideString; const senha: WideString): RetornoConsultarEmail; stdcall;
    function  alterarSenha(const usuario: WideString; const senha: WideString; const novaSenha: WideString): RetornoAlterarSenha; stdcall;
    function  consultarDadosAnimal(const usuario: WideString; const senha: WideString; const numeroSisbov: WideString): RetornoConsultarDadosAnimal; stdcall;
    function  consultarMovimentacao(const usuario: WideString; const senha: WideString; const gta: GtaDTO; const nrAcionamento: Int64): RetornoConsultarMovimentacao; stdcall;
    function  consultarDadosAnimalImportado(const usuario: WideString; const senha: WideString; const numeroSisbov: WideString): RetornoConsultarDadosAnimalImportado; stdcall;
    function  informarMorteAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const dataMorte: WideString; const codigoTipoMorte: Int64; const codigoCausaMorte: Int64
                                  ): RetornoMorteAnimal; stdcall;
    function  informarDesligamentoAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const tipoDesligamento: Int64): RetornoDesligamentoAnimal; stdcall;
    function  movimentarAnimal(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; 
                               const idPropriedadeOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const cpfProdutorDestino: WideString; 
                               const cnpjProdutorDestino: WideString; const gtas: Array_Of_GtaDTO; const numerosSISBOV: Array_Of_string): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalParaFrigorifico(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; 
                                              const idPropriedadeOrigem: Int64; const cnpjFrigorifico: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const gtas: Array_Of_GtaDTO; 
                                              const numerosSISBOV: Array_Of_string): RetornoInformarMovimentacao; stdcall;
    function  inventariarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const _numeroSolicitacao: Int64; const _cpfProdutor: WideString; const _cnpjProdutor: WideString; const _idPropriedadeDestino: Int64; 
                                              const _tipoIdentificacao: Int64): RetornoInventarioSolicitacao; stdcall;
    function  cancelarMovimentacao(const usuario: WideString; const senha: WideString; const idMovimentacao: Int64; const motivoCancelamento: WideString): RetornoCancelarMovimentacao; stdcall;
    function  excluirVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoExcluirVistoria; stdcall;
    function  consultarAnimaisAbatidos(const usuario: WideString; const senha: WideString; const cnpjFrigorifico: WideString; const data: WideString): RetornoConsultarAnimaisAbatidos; stdcall;
    function  alterarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64; const tipoIdentificacao: Int64; const cnpjFabrica: WideString): RetornoAlterarSolicitacaoNumeracao; stdcall;
    function  cancelarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64): RetornoCancelarSolicitacaoNumeracao; stdcall;
    function  informarNotaFiscal(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const nrSerie: WideString; const nrNota: WideString; const dtNota: WideString
                                 ): RetornoAlterarSolicitacaoNumeracao; stdcall;
    function  finalizarSolicNumAnimalImportado(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const cnpjFabrica: WideString; const nrSerie: WideString; const nrNota: WideString; 
                                               const dtNota: WideString): RetornoFinalizarSolicNumAnimalImportado; stdcall;
  end;

function GetWsSISBOV(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): WsSISBOV;


implementation
  uses SysUtils;

function GetWsSISBOV(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): WsSISBOV;
const
  defWSDL = 'WsSISBOV.xml';
  defURL  = 'https://extranet.agricultura.gov.br/sisbov_ws_prd/services/WsSISBOV';
  defSvc  = 'WsSISBOVService';
  defPrt  = 'WsSISBOV';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as WsSISBOV);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor RetornoWsSISBOV.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FlistaErros)-1 do
    FreeAndNil(FlistaErros[I]);
  SetLength(FlistaErros, 0);
  inherited Destroy;
end;

destructor RetornoRecuperarNumeracaoReimpressao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    FreeAndNil(Fnumeracao[I]);
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoConsultaSolicitacaoNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    FreeAndNil(Fnumeracao[I]);
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoRecuperarNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    FreeAndNil(Fnumeracao[I]);
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoSolicitacaoNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    FreeAndNil(Fnumeracao[I]);
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoRecuperarTabela.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fregistros)-1 do
    FreeAndNil(Fregistros[I]);
  SetLength(Fregistros, 0);
  inherited Destroy;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(WsSISBOV), 'http://servicosWeb.sisbov.mapa.gov.br', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(WsSISBOV), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(WsSISBOV), ioDocument);
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_Erro), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_Erro');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_RegistroTabelaDominio), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_RegistroTabelaDominio');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_NumeroSimplificado), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_NumeroSimplificado');
  RemClassRegistry.RegisterXSClass(NumeroSimplificado, 'http://model.sisbov.mapa.gov.br', 'NumeroSimplificado');
  RemClassRegistry.RegisterXSClass(GtaDTO, 'http://model.sisbov.mapa.gov.br', 'GtaDTO');
  RemClassRegistry.RegisterXSClass(ObjetoPersistente, 'http://persistence.serpro.gov.br', 'ObjetoPersistente');
  RemClassRegistry.RegisterXSClass(RegistroTabelaDominio, 'http://model.sisbov.mapa.gov.br', 'RegistroTabelaDominio');
  RemClassRegistry.RegisterXSClass(RetornoWsSISBOV, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoWsSISBOV');
  RemClassRegistry.RegisterXSClass(RetornoFinalizarSolicNumAnimalImportado, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoFinalizarSolicNumAnimalImportado');
  RemClassRegistry.RegisterXSClass(RetornoCancelarSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoCancelarSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoAlterarSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoExcluirVistoria, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoExcluirVistoria');
  RemClassRegistry.RegisterXSClass(RetornoCancelarMovimentacao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoCancelarMovimentacao');
  RemClassRegistry.RegisterXSClass(RetornoInventarioSolicitacao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoInventarioSolicitacao');
  RemClassRegistry.RegisterXSClass(RetornoInformarMovimentacao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoInformarMovimentacao');
  RemClassRegistry.RegisterXSClass(RetornoDesligamentoAnimal, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoDesligamentoAnimal');
  RemClassRegistry.RegisterXSClass(RetornoMorteAnimal, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoMorteAnimal');
  RemClassRegistry.RegisterXSClass(RetornoConsultarDadosAnimalImportado, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarDadosAnimalImportado');
  RemClassRegistry.RegisterXSClass(RetornoConsultarMovimentacao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarMovimentacao');
  RemClassRegistry.RegisterXSClass(RetornoConsultarDadosAnimal, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarDadosAnimal');
  RemClassRegistry.RegisterXSClass(RetornoAlterarSenha, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarSenha');
  RemClassRegistry.RegisterXSClass(RetornoConsultarEmail, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarEmail');
  RemClassRegistry.RegisterXSClass(RetornoCadastrarEmail, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoCadastrarEmail');
  RemClassRegistry.RegisterXSClass(RetornoRecuperarSenha, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRecuperarSenha');
  RemClassRegistry.RegisterXSClass(RetornoAlterarIE, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarIE');
  RemClassRegistry.RegisterXSClass(RetornoAlterarAnimal, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarAnimal');
  RemClassRegistry.RegisterXSClass(RetornoIncluirAnimal, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirAnimal');
  RemClassRegistry.RegisterXSClass(RetornoRecuperarNumeracaoReimpressao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRecuperarNumeracaoReimpressao');
  RemClassRegistry.RegisterXSClass(RetornoConsultaSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultaSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoRecuperarNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRecuperarNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoSolicitacaoNumeracaoReimpressao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoSolicitacaoNumeracaoReimpressao');
  RemClassRegistry.RegisterXSClass(RetornoSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoIncluirVistoriaERAS, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirVistoriaERAS');
  RemClassRegistry.RegisterXSClass(RetornoVincularProdutorPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoVincularProdutorPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoDesvincularProprietarioPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoDesvincularProprietarioPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoDesvincularProdutorPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoDesvincularProdutorPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoVincularProprietarioPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoVincularProprietarioPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoAlterarPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoIncluirPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoConsultarPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarPropriedade');
  RemClassRegistry.RegisterXSClass(RetornoAlterarSupervisor, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarSupervisor');
  RemClassRegistry.RegisterXSClass(RetornoIncluirSupervisor, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirSupervisor');
  RemClassRegistry.RegisterXSClass(RetornoAlterarProdutor, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarProdutor');
  RemClassRegistry.RegisterXSClass(RetornoIncluirProdutor, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirProdutor');
  RemClassRegistry.RegisterXSClass(RetornoAlterarProprietario, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarProprietario');
  RemClassRegistry.RegisterXSClass(RetornoIncluirProprietario, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoIncluirProprietario');
  RemClassRegistry.RegisterXSClass(RetornoRecuperarTabela, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRecuperarTabela');
  RemClassRegistry.RegisterXSInfo(TypeInfo(item), 'http://servicosWeb.sisbov.mapa.gov.br', 'item');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_xsd_string), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_xsd_string');
  RemClassRegistry.RegisterXSClass(RetornoConsultarAnimaisAbatidos, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarAnimaisAbatidos');
  RemClassRegistry.RegisterXSClass(Erro, 'http://model.sisbov.mapa.gov.br', 'Erro');
  RemClassRegistry.RegisterXSClass(item2, 'http://servicosWeb.sisbov.mapa.gov.br', 'item2', 'item');
  RemClassRegistry.RegisterXSClass(item3, 'http://servicosWeb.sisbov.mapa.gov.br', 'item3', 'item');
  RemClassRegistry.RegisterXSClass(item4, 'http://servicosWeb.sisbov.mapa.gov.br', 'item4', 'item');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_string), 'http://www.w3.org/2001/XMLSchema', 'Array_Of_string');
  RemClassRegistry.RegisterSerializeOptions(TypeInfo(Array_Of_string), [xoInlineArrays]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_GtaDTO), 'http://model.sisbov.mapa.gov.br', 'Array_Of_GtaDTO');
  RemClassRegistry.RegisterSerializeOptions(TypeInfo(Array_Of_GtaDTO), [xoInlineArrays]);

end.