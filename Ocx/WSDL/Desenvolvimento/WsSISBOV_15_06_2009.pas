// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\Desenvolvimento\fontes\OCX HERDOM\WSDL\Desenvolvimento\WsSISBOV-15-06-2009.xml
// Encoding : UTF-8
// Version  : 1.0
// (15/06/2009 16:52:56 - 1.33.2.5)
// ************************************************************************ //

unit WsSISBOV_15_06_2009;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:long            - "http://www.w3.org/2001/XMLSchema"
  // !:int             - "http://www.w3.org/2001/XMLSchema"
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"
  // !:ObjetoPersistente - "http://model.sisbov.mapa.gov.br"

  TipoMorteCausa       = class;                 { "http://tipos.model.sisbov.mapa.gov.br" }
  NumeroSimplificado   = class;                 { "http://model.sisbov.mapa.gov.br" }
  NumeroReimpressaoDTO = class;                 { "http://model.sisbov.mapa.gov.br" }
  NumeroSimplificadoReimpressao = class;        { "http://model.sisbov.mapa.gov.br" }
  GtaDTO               = class;                 { "http://model.sisbov.mapa.gov.br" }
  CheckListItemDTO     = class;                 { "http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br" }
  CheckListItemRespostaDTO = class;             { "http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br" }
  Erro                 = class;                 { "http://model.sisbov.mapa.gov.br" }
  RetornoWsSISBOV      = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoRespostasCheckListVistoria = class;    { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoCheckListVistoria = class;             { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoFinalizarSolicNumAnimalImportado = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoCancelarSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarAnimaisAbatidos = class;      { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoExcluirVistoria = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoCancelarMovimentacao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoInventarioSolicitacao = class;         { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoInformarMovimentacao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoDesligamentoAnimal = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoMorteAnimal   = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarDadosAnimalImportado = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarMovimentacao = class;         { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarDadosAnimal = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarSenha  = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarEmail = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoCadastrarEmail = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoRecuperarSenha = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarIE     = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarAnimal = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirAnimal = class;                 { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarNumeracaoReimpressao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultaSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoRecuperarNumeracao = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoSolicitacaoNumeracaoReimpressao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoSolicitacaoNumeracao = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirVistoriaERAS = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoVincularProdutorPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoDesvincularProprietarioPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoDesvincularProdutorPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoVincularProprietarioPropriedade = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarPropriedade = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirPropriedade = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarPropriedade = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarSupervisor = class;             { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirSupervisor = class;             { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarProdutor = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirProdutor = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlterarProprietario = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoIncluirProprietario = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarVinculoMorteCausa = class;    { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  CheckListAgendamentoDTO = class;              { "http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br" }
  RetornoConsultarAgendamento = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoSuspenderPropriedade = class;          { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  Suspensao            = class;                 { "http://model.sisbov.mapa.gov.br" }
  RetornoConsultarSuspensao = class;            { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoAlteracaoPosse = class;                { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoConsultarProtocoloSolicitacaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RetornoInformarDistribuicaoNumeracao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  SolicitacaoDistribuicaoSimplificada = class;   { "http://model.sisbov.mapa.gov.br" }
  RetornoConsultarSolicitacaoDistribuicao = class;   { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  MovimentacaoAnimalDTO = class;                { "http://model.sisbov.mapa.gov.br" }
  MovimentacaoExternaDTO = class;               { "http://model.sisbov.mapa.gov.br" }
  RetornoMovimentacaoExterna = class;           { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }
  RegistroTabelaDominio = class;                { "http://model.sisbov.mapa.gov.br" }
  RetornoRecuperarTabela = class;               { "http://retorno.servicosWeb.sisbov.mapa.gov.br" }



  // ************************************************************************ //
  // Namespace : http://tipos.model.sisbov.mapa.gov.br
  // ************************************************************************ //
  TipoMorteCausa = class(TRemotable)
  private
    FdsCausaMorte: WideString;
    FdsTipoMorte: WideString;
    FidCausaMorte: Int64;
    FidTipoMorte: Int64;
    FidVinculo: Int64;
    FstatusCausaMorte: WideString;
    FstatusTipoMorte: WideString;
  published
    property dsCausaMorte: WideString read FdsCausaMorte write FdsCausaMorte;
    property dsTipoMorte: WideString read FdsTipoMorte write FdsTipoMorte;
    property idCausaMorte: Int64 read FidCausaMorte write FidCausaMorte;
    property idTipoMorte: Int64 read FidTipoMorte write FidTipoMorte;
    property idVinculo: Int64 read FidVinculo write FidVinculo;
    property statusCausaMorte: WideString read FstatusCausaMorte write FstatusCausaMorte;
    property statusTipoMorte: WideString read FstatusTipoMorte write FstatusTipoMorte;
  end;

  ArrayOf_tns4_TipoMorteCausa = array of TipoMorteCausa;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  NumeroSimplificado = class(TRemotable)
  private
    Fnumero: WideString;
    FstatusUtilizacao: WideString;
  published
    property numero: WideString read Fnumero write Fnumero;
    property statusUtilizacao: WideString read FstatusUtilizacao write FstatusUtilizacao;
  end;

  ArrayOf_tns2_NumeroSimplificado = array of NumeroSimplificado;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  NumeroReimpressaoDTO = class(TRemotable)
  private
    FnumeroSisbov: WideString;
    FtipoIdentificacao: Integer;
  published
    property numeroSisbov: WideString read FnumeroSisbov write FnumeroSisbov;
    property tipoIdentificacao: Integer read FtipoIdentificacao write FtipoIdentificacao;
  end;



  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  NumeroSimplificadoReimpressao = class(TRemotable)
  private
    Fdescricao: WideString;
    Fnumero: WideString;
    Fparecer: WideString;
  published
    property descricao: WideString read Fdescricao write Fdescricao;
    property numero: WideString read Fnumero write Fnumero;
    property parecer: WideString read Fparecer write Fparecer;
  end;

  ArrayOf_tns2_NumeroSimplificadoReimpressao = array of NumeroSimplificadoReimpressao;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  GtaDTO = class(TRemotable)
  private
    FnumeroGTA: WideString;
    FnumeroSerie: WideString;
    FqtdeAnimais: Int64;
    Fuf: WideString;
  published
    property numeroGTA: WideString read FnumeroGTA write FnumeroGTA;
    property numeroSerie: WideString read FnumeroSerie write FnumeroSerie;
    property qtdeAnimais: Int64 read FqtdeAnimais write FqtdeAnimais;
    property uf: WideString read Fuf write Fuf;
  end;

  ArrayOf_xsd_string = array of WideString;     { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br
  // ************************************************************************ //
  CheckListItemDTO = class(TRemotable)
  private
    Fdescricao: WideString;
    Fid: Int64;
    Ftipo: WideString;
  published
    property descricao: WideString read Fdescricao write Fdescricao;
    property id: Int64 read Fid write Fid;
    property tipo: WideString read Ftipo write Ftipo;
  end;

  ArrayOf_tns5_CheckListItemDTO = array of CheckListItemDTO;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br
  // ************************************************************************ //
  CheckListItemRespostaDTO = class(TRemotable)
  private
    Fconformidade: WideString;
    Fid: Int64;
    Fresposta: WideString;
  published
    property conformidade: WideString read Fconformidade write Fconformidade;
    property id: Int64 read Fid write Fid;
    property resposta: WideString read Fresposta write Fresposta;
  end;

  ArrayOf_tns5_CheckListItemRespostaDTO = array of CheckListItemRespostaDTO;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  Erro = class(TRemotable)
  private
    FcodigoErro: WideString;
    FmenssagemErro: WideString;
    FpilhaDeErro: WideString;
    FvalorInformado: ArrayOf_xsd_string;
  published
    property codigoErro: WideString read FcodigoErro write FcodigoErro;
    property menssagemErro: WideString read FmenssagemErro write FmenssagemErro;
    property pilhaDeErro: WideString read FpilhaDeErro write FpilhaDeErro;
    property valorInformado: ArrayOf_xsd_string read FvalorInformado write FvalorInformado;
  end;

  ArrayOf_tns2_Erro = array of Erro;            { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
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
    property ambiente: WideString read Fambiente write Fambiente;
    property erroBanco: WideString read FerroBanco write FerroBanco;
    property idTransacao: Int64 read FidTransacao write FidTransacao;
    property listaErros: ArrayOf_tns2_Erro read FlistaErros write FlistaErros;
    property status: Integer read Fstatus write Fstatus;
    property trace: WideString read Ftrace write Ftrace;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRespostasCheckListVistoria = class(RetornoWsSISBOV)
  private
    FidCheckListVistoria: Int64;
    Fitem: ArrayOf_tns5_CheckListItemRespostaDTO;
  public
    destructor Destroy; override;
  published
    property idCheckListVistoria: Int64 read FidCheckListVistoria write FidCheckListVistoria;
    property item: ArrayOf_tns5_CheckListItemRespostaDTO read Fitem write Fitem;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCheckListVistoria = class(RetornoWsSISBOV)
  private
    FidCheckListVistoria: Int64;
    Fitem: ArrayOf_tns5_CheckListItemDTO;
  public
    destructor Destroy; override;
  published
    property idCheckListVistoria: Int64 read FidCheckListVistoria write FidCheckListVistoria;
    property item: ArrayOf_tns5_CheckListItemDTO read Fitem write Fitem;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoFinalizarSolicNumAnimalImportado = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCancelarSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarAnimaisAbatidos = class(RetornoWsSISBOV)
  private
    Fanimais: ArrayOf_xsd_string;
  published
    property animais: ArrayOf_xsd_string read Fanimais write Fanimais;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoExcluirVistoria = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCancelarMovimentacao = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoInventarioSolicitacao = class(RetornoWsSISBOV)
  private
    FidSolicitacao: Int64;
  published
    property idSolicitacao: Int64 read FidSolicitacao write FidSolicitacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoInformarMovimentacao = class(RetornoWsSISBOV)
  private
    Fchave: Int64;
  published
    property chave: Int64 read Fchave write Fchave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesligamentoAnimal = class(RetornoWsSISBOV)
  private
    FidMorte: Int64;
  published
    property idMorte: Int64 read FidMorte write FidMorte;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoMorteAnimal = class(RetornoWsSISBOV)
  private
    FidMorte: Int64;
  published
    property idMorte: Int64 read FidMorte write FidMorte;
  end;



  // ************************************************************************ //
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
    property anoImportacao: WideString read FanoImportacao write FanoImportacao;
    property dataEntrada: WideString read FdataEntrada write FdataEntrada;
    property dataIdentificacao: WideString read FdataIdentificacao write FdataIdentificacao;
    property dataInclusao: WideString read FdataInclusao write FdataInclusao;
    property dataNascimento: WideString read FdataNascimento write FdataNascimento;
    property dataNascimentoEstimada: WideString read FdataNascimentoEstimada write FdataNascimentoEstimada;
    property dia: WideString read Fdia write Fdia;
    property nome: WideString read Fnome write Fnome;
    property numero: WideString read Fnumero write Fnumero;
    property numeroDefinitivo: WideString read FnumeroDefinitivo write FnumeroDefinitivo;
    property numeroProvisorio: WideString read FnumeroProvisorio write FnumeroProvisorio;
    property observacao: WideString read Fobservacao write Fobservacao;
    property pais: WideString read Fpais write Fpais;
    property raca: WideString read Fraca write Fraca;
    property registroAssociacao: WideString read FregistroAssociacao write FregistroAssociacao;
    property sexo: WideString read Fsexo write Fsexo;
    property tipoIdentificacao: WideString read FtipoIdentificacao write FtipoIdentificacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarMovimentacao = class(RetornoWsSISBOV)
  private
    FidMovimentacao: Int64;
    FnrAcionamentos: Int64;
    FnrInicialSisbov: WideString;
    FqtdeAnimaisMovimentado: Int64;
  published
    property idMovimentacao: Int64 read FidMovimentacao write FidMovimentacao;
    property nrAcionamentos: Int64 read FnrAcionamentos write FnrAcionamentos;
    property nrInicialSisbov: WideString read FnrInicialSisbov write FnrInicialSisbov;
    property qtdeAnimaisMovimentado: Int64 read FqtdeAnimaisMovimentado write FqtdeAnimaisMovimentado;
  end;



  // ************************************************************************ //
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
    property dataIdentificacao: WideString read FdataIdentificacao write FdataIdentificacao;
    property dataInclusao: WideString read FdataInclusao write FdataInclusao;
    property dataLiberacaoAbate: WideString read FdataLiberacaoAbate write FdataLiberacaoAbate;
    property dataNascimento: WideString read FdataNascimento write FdataNascimento;
    property dia: WideString read Fdia write Fdia;
    property numero: WideString read Fnumero write Fnumero;
    property numeroDefinitivo: WideString read FnumeroDefinitivo write FnumeroDefinitivo;
    property numeroProvisorio: WideString read FnumeroProvisorio write FnumeroProvisorio;
    property pais: WideString read Fpais write Fpais;
    property raca: WideString read Fraca write Fraca;
    property sexo: WideString read Fsexo write Fsexo;
    property tipoIdentificacao: WideString read FtipoIdentificacao write FtipoIdentificacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSenha = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarEmail = class(RetornoWsSISBOV)
  private
    Femail: WideString;
  published
    property email: WideString read Femail write Femail;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoCadastrarEmail = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarSenha = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarIE = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarAnimal = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirAnimal = class(RetornoWsSISBOV)
  private
    FdataLiberacaoAbate: WideString;
    Fdia: WideString;
  published
    property dataLiberacaoAbate: WideString read FdataLiberacaoAbate write FdataLiberacaoAbate;
    property dia: WideString read Fdia write Fdia;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarNumeracaoReimpressao = class(RetornoWsSISBOV)
  private
    Fnumeracoes: ArrayOf_tns2_NumeroSimplificadoReimpressao;
  public
    destructor Destroy; override;
  published
    property numeracoes: ArrayOf_tns2_NumeroSimplificadoReimpressao read Fnumeracoes write Fnumeracoes;
  end;



  // ************************************************************************ //
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
    property dataUltimaAlteracao: WideString read FdataUltimaAlteracao write FdataUltimaAlteracao;
    property nrSolicitacao: Int64 read FnrSolicitacao write FnrSolicitacao;
    property numeracao: ArrayOf_tns2_NumeroSimplificado read Fnumeracao write Fnumeracao;
    property observacao: WideString read Fobservacao write Fobservacao;
    property situacao: Int64 read Fsituacao write Fsituacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarNumeracao = class(RetornoWsSISBOV)
  private
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
  public
    destructor Destroy; override;
  published
    property numeracao: ArrayOf_tns2_NumeroSimplificado read Fnumeracao write Fnumeracao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoSolicitacaoNumeracaoReimpressao = class(RetornoWsSISBOV)
  private
    FnumeroSolicitacao: Int64;
  published
    property numeroSolicitacao: Int64 read FnumeroSolicitacao write FnumeroSolicitacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
    FnumeroSolicitacao: Int64;
  public
    destructor Destroy; override;
  published
    property numeracao: ArrayOf_tns2_NumeroSimplificado read Fnumeracao write Fnumeracao;
    property numeroSolicitacao: Int64 read FnumeroSolicitacao write FnumeroSolicitacao;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirVistoriaERAS = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoVincularProdutorPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesvincularProprietarioPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoDesvincularProdutorPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoVincularProprietarioPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarPropriedade = class(RetornoWsSISBOV)
  private
  published
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirPropriedade = class(RetornoWsSISBOV)
  private
    FidPropriedade: Int64;
  published
    property idPropriedade: Int64 read FidPropriedade write FidPropriedade;
  end;



  // ************************************************************************ //
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
    FrazaoSocial: WideString;
    FsegundoLatitude: WideString;
    FsegundoLongitude: WideString;
    FtelefoneResidencial: WideString;
    FtipoPropriedade: WideString;
  published
    property acessoFazenda: WideString read FacessoFazenda write FacessoFazenda;
    property area: WideString read Farea write Farea;
    property bairro: WideString read Fbairro write Fbairro;
    property cep: WideString read Fcep write Fcep;
    property codMunicipio: WideString read FcodMunicipio write FcodMunicipio;
    property distanciaSedeMunicipio: WideString read FdistanciaSedeMunicipio write FdistanciaSedeMunicipio;
    property enderecoCorrespondenciaBairro: WideString read FenderecoCorrespondenciaBairro write FenderecoCorrespondenciaBairro;
    property enderecoCorrespondenciaCep: WideString read FenderecoCorrespondenciaCep write FenderecoCorrespondenciaCep;
    property enderecoCorrespondenciaCodMunicipio: WideString read FenderecoCorrespondenciaCodMunicipio write FenderecoCorrespondenciaCodMunicipio;
    property enderecoCorrespondenciaLogradouro: WideString read FenderecoCorrespondenciaLogradouro write FenderecoCorrespondenciaLogradouro;
    property faxResidencial: WideString read FfaxResidencial write FfaxResidencial;
    property grauLatitude: WideString read FgrauLatitude write FgrauLatitude;
    property grauLongitude: WideString read FgrauLongitude write FgrauLongitude;
    property incra: WideString read Fincra write Fincra;
    property logradouro: WideString read Flogradouro write Flogradouro;
    property minutoLatitude: WideString read FminutoLatitude write FminutoLatitude;
    property minutoLongitude: WideString read FminutoLongitude write FminutoLongitude;
    property nirf: WideString read Fnirf write Fnirf;
    property nomePropriedade: WideString read FnomePropriedade write FnomePropriedade;
    property nrFaxContato: WideString read FnrFaxContato write FnrFaxContato;
    property nrTelefoneContato: WideString read FnrTelefoneContato write FnrTelefoneContato;
    property orientacaoLatitude: WideString read ForientacaoLatitude write ForientacaoLatitude;
    property orientacaoLongitude: WideString read ForientacaoLongitude write ForientacaoLongitude;
    property razaoSocial: WideString read FrazaoSocial write FrazaoSocial;
    property segundoLatitude: WideString read FsegundoLatitude write FsegundoLatitude;
    property segundoLongitude: WideString read FsegundoLongitude write FsegundoLongitude;
    property telefoneResidencial: WideString read FtelefoneResidencial write FtelefoneResidencial;
    property tipoPropriedade: WideString read FtipoPropriedade write FtipoPropriedade;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarSupervisor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirSupervisor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarProdutor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirProdutor = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlterarProprietario = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoIncluirProprietario = class(RetornoWsSISBOV)
  private
    Fchave: WideString;
    FtipoChave: WideString;
  published
    property chave: WideString read Fchave write Fchave;
    property tipoChave: WideString read FtipoChave write FtipoChave;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarVinculoMorteCausa = class(RetornoWsSISBOV)
  private
    Fvinculos: ArrayOf_tns4_TipoMorteCausa;
  public
    destructor Destroy; override;
  published
    property vinculos: ArrayOf_tns4_TipoMorteCausa read Fvinculos write Fvinculos;
  end;



  // ************************************************************************ //
  // Namespace : http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br
  // ************************************************************************ //
  CheckListAgendamentoDTO = class(TRemotable)
  private
    Fcancelada: Boolean;
    Fcpf: WideString;
    FdataAgendamento: WideString;
    FidPropriedade: Int64;
  published
    property cancelada: Boolean read Fcancelada write Fcancelada;
    property cpf: WideString read Fcpf write Fcpf;
    property dataAgendamento: WideString read FdataAgendamento write FdataAgendamento;
    property idPropriedade: Int64 read FidPropriedade write FidPropriedade;
  end;

  ArrayOf_tns5_CheckListAgendamentoDTO = array of CheckListAgendamentoDTO;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarAgendamento = class(RetornoWsSISBOV)
  private
    Fagendamento: ArrayOf_tns5_CheckListAgendamentoDTO;
  public
    destructor Destroy; override;
  published
    property agendamento: ArrayOf_tns5_CheckListAgendamentoDTO read Fagendamento write Fagendamento;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoSuspenderPropriedade = class(RetornoWsSISBOV)
  private
    FidSuspensao: Int64;
  published
    property idSuspensao: Int64 read FidSuspensao write FidSuspensao;
  end;



  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  Suspensao = class(TRemotable)
  private
    Fclassificacao: WideString;
    FdataSuspensao: WideString;
    FidSuspensao: WideString;
    Fmotivo: WideString;
  published
    property classificacao: WideString read Fclassificacao write Fclassificacao;
    property dataSuspensao: WideString read FdataSuspensao write FdataSuspensao;
    property idSuspensao: WideString read FidSuspensao write FidSuspensao;
    property motivo: WideString read Fmotivo write Fmotivo;
  end;

  ArrayOf_tns2_Suspensao = array of Suspensao;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarSuspensao = class(RetornoWsSISBOV)
  private
    Fclassificacao: WideString;
    FdataSuspensao: WideString;
    FlistaSuspensao: ArrayOf_tns2_Suspensao;
    Fmotivo: WideString;
  public
    destructor Destroy; override;
  published
    property classificacao: WideString read Fclassificacao write Fclassificacao;
    property dataSuspensao: WideString read FdataSuspensao write FdataSuspensao;
    property listaSuspensao: ArrayOf_tns2_Suspensao read FlistaSuspensao write FlistaSuspensao;
    property motivo: WideString read Fmotivo write Fmotivo;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoAlteracaoPosse = class(RetornoWsSISBOV)
  private
    FnrProtocolo: Int64;
  published
    property nrProtocolo: Int64 read FnrProtocolo write FnrProtocolo;
  end;

  ArrayOf_xsd_long = array of Int64;            { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarProtocoloSolicitacaoNumeracao = class(RetornoWsSISBOV)
  private
    FlistaProtocolos: ArrayOf_xsd_long;
  published
    property listaProtocolos: ArrayOf_xsd_long read FlistaProtocolos write FlistaProtocolos;
  end;



  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoInformarDistribuicaoNumeracao = class(RetornoWsSISBOV)
  private
    FnumeroSolicitacao: Int64;
  published
    property numeroSolicitacao: Int64 read FnumeroSolicitacao write FnumeroSolicitacao;
  end;



  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  SolicitacaoDistribuicaoSimplificada = class(TRemotable)
  private
    FUF: WideString;
    FcnpjProdutor: WideString;
    FcpfProdutor: WideString;
    FdataDistribuicao: WideString;
    Fnumeracao: ArrayOf_tns2_NumeroSimplificado;
    FnumeroSolicitacao: Int64;
    Fsituacao: WideString;
    FtipoEnvio: Integer;
  public
    destructor Destroy; override;
  published
    property UF: WideString read FUF write FUF;
    property cnpjProdutor: WideString read FcnpjProdutor write FcnpjProdutor;
    property cpfProdutor: WideString read FcpfProdutor write FcpfProdutor;
    property dataDistribuicao: WideString read FdataDistribuicao write FdataDistribuicao;
    property numeracao: ArrayOf_tns2_NumeroSimplificado read Fnumeracao write Fnumeracao;
    property numeroSolicitacao: Int64 read FnumeroSolicitacao write FnumeroSolicitacao;
    property situacao: WideString read Fsituacao write Fsituacao;
    property tipoEnvio: Integer read FtipoEnvio write FtipoEnvio;
  end;

  ArrayOf_tns2_SolicitacaoDistribuicaoSimplificada = array of SolicitacaoDistribuicaoSimplificada;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoConsultarSolicitacaoDistribuicao = class(RetornoWsSISBOV)
  private
    Fsolicitacao: ArrayOf_tns2_SolicitacaoDistribuicaoSimplificada;
  public
    destructor Destroy; override;
  published
    property solicitacao: ArrayOf_tns2_SolicitacaoDistribuicaoSimplificada read Fsolicitacao write Fsolicitacao;
  end;



  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  MovimentacaoAnimalDTO = class(TRemotable)
  private
    FcnpjCertificadoraOrigem: WideString;
    FdtChegada: WideString;
    FdtProcessamento: WideString;
    FnumeroSisbov: ArrayOf_xsd_string;
  published
    property cnpjCertificadoraOrigem: WideString read FcnpjCertificadoraOrigem write FcnpjCertificadoraOrigem;
    property dtChegada: WideString read FdtChegada write FdtChegada;
    property dtProcessamento: WideString read FdtProcessamento write FdtProcessamento;
    property numeroSisbov: ArrayOf_xsd_string read FnumeroSisbov write FnumeroSisbov;
  end;

  ArrayOf_tns2_MovimentacaoAnimalDTO = array of MovimentacaoAnimalDTO;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  MovimentacaoExternaDTO = class(TRemotable)
  private
    FcpfCnpjProdutor: WideString;
    FidPropriedade: Int64;
    Fmovimentacoes: ArrayOf_tns2_MovimentacaoAnimalDTO;
  public
    destructor Destroy; override;
  published
    property cpfCnpjProdutor: WideString read FcpfCnpjProdutor write FcpfCnpjProdutor;
    property idPropriedade: Int64 read FidPropriedade write FidPropriedade;
    property movimentacoes: ArrayOf_tns2_MovimentacaoAnimalDTO read Fmovimentacoes write Fmovimentacoes;
  end;

  ArrayOf_tns2_MovimentacaoExternaDTO = array of MovimentacaoExternaDTO;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoMovimentacaoExterna = class(RetornoWsSISBOV)
  private
    FmovimentacaoPropriedade: ArrayOf_tns2_MovimentacaoExternaDTO;
    FquantidadeAnimais: Integer;
  public
    destructor Destroy; override;
  published
    property movimentacaoPropriedade: ArrayOf_tns2_MovimentacaoExternaDTO read FmovimentacaoPropriedade write FmovimentacaoPropriedade;
    property quantidadeAnimais: Integer read FquantidadeAnimais write FquantidadeAnimais;
  end;



  // ************************************************************************ //
  // Namespace : http://model.sisbov.mapa.gov.br
  // ************************************************************************ //
  RegistroTabelaDominio = class(TRemotable)
  private
    Fcodigo: WideString;
    Fdescricao: WideString;
  published
    property codigo: WideString read Fcodigo write Fcodigo;
    property descricao: WideString read Fdescricao write Fdescricao;
  end;

  ArrayOf_tns2_RegistroTabelaDominio = array of RegistroTabelaDominio;   { "http://servicosWeb.sisbov.mapa.gov.br" }


  // ************************************************************************ //
  // Namespace : http://retorno.servicosWeb.sisbov.mapa.gov.br
  // ************************************************************************ //
  RetornoRecuperarTabela = class(RetornoWsSISBOV)
  private
    Fregistros: ArrayOf_tns2_RegistroTabelaDominio;
  public
    destructor Destroy; override;
  published
    property registros: ArrayOf_tns2_RegistroTabelaDominio read Fregistros write Fregistros;
  end;


  // ************************************************************************ //
  // Namespace : http://servicosWeb.sisbov.mapa.gov.br
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : WsSISBOVSoapBinding
  // service   : WsSISBOVService
  // port      : WsSISBOV
  // URL       : http://homolog.agricultura.gov.br/sisbov_ws_nova_hom/services/WsSISBOV
  // ************************************************************************ //
  WsSISBOV = interface(IInvokable)
  ['{F2538DF6-5D8C-6916-05AC-1035B5A39B2F}']
    function  recuperarTabela(const usuario: WideString; const senha: WideString; const idTabela: Int64): RetornoRecuperarTabela; stdcall;
    function  recuperarTabelaMunicipios(const usuario: WideString; const senha: WideString; const uf: WideString): RetornoRecuperarTabela; stdcall;
    function  recuperarVinculoMorteCausa(const usuario: WideString; const senha: WideString; const tipoMorte: WideString): RetornoConsultarVinculoMorteCausa; stdcall;
    function  incluirProprietario(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; 
                                  const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString): RetornoIncluirProprietario; stdcall;
    function  alterarProprietario(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; 
                                  const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString): RetornoAlterarProprietario; stdcall;
    function  incluirProdutor(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; 
                              const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoIncluirProdutor; stdcall;
    function  alterarProdutor(const usuario: WideString; const senha: WideString; const _razaoSocial: WideString; const _cnpj: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _sexo: WideString; const _logradouro: WideString; 
                              const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoAlterarProdutor; stdcall;
    function  incluirSupervisor(const usuario: WideString; const senha: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _rg: WideString; const _dataNascimento: WideString; const _dataExpedicao: WideString; const _OrgaoExpedidor: WideString; 
                                const _ufExpedidor: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString): RetornoIncluirSupervisor; stdcall;
    function  alterarSupervisor(const usuario: WideString; const senha: WideString; const _nome: WideString; const _telefone: WideString; const _email: WideString; const _cpf: WideString; const _rg: WideString; const _dataNascimento: WideString; const _dataExpedicao: WideString; const _OrgaoExpedidor: WideString; 
                                const _ufExpedidor: WideString; const _sexo: WideString; const _logradouro: WideString; const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString): RetornoAlterarSupervisor; stdcall;
    function  consultarPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoConsultarPropriedade; stdcall;
    function  incluirPropriedade(const usuario: WideString; const senha: WideString; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; const _nomePropriedade: WideString; const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString; const _grauLatitude: Integer; 
                                 const _minutoLatitude: Integer; const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; const _segundoLongitude: Integer; const _area: Int64; const _logradouro: WideString; const _bairro: WideString; 
                                 const _cep: WideString; const _codMunicipio: WideString; const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString; 
                                 const _nrFaxContato: WideString): RetornoIncluirPropriedade; stdcall;
    function  alterarPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; const _nomePropriedade: WideString; const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString; 
                                 const _grauLatitude: Integer; const _minutoLatitude: Integer; const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; const _segundoLongitude: Integer; const _area: Int64; const _logradouro: WideString; 
                                 const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString; const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; 
                                 const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoAlterarPropriedade; stdcall;
    function  vincularProprietarioPropriedade(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64; const situacaoFundiaria: Int64): RetornoVincularProprietarioPropriedade; stdcall;
    function  desvincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64): RetornoDesvincularProdutorPropriedade; stdcall;
    function  desvincularPropriedadeProprietario(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64): RetornoDesvincularProprietarioPropriedade; stdcall;
    function  vincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const IEProdutor: WideString; const ufIE: WideString; const tipoProdutor: Int64): RetornoVincularProdutorPropriedade; stdcall;
    function  incluirVistoriaERAS(const usuario: WideString; const senha: WideString; const cpfSupervisor: WideString; const idPropriedade: Int64; const data: WideString): RetornoIncluirVistoriaERAS; stdcall;
    function  solicitarNumeracao(const usuario: WideString; const senha: WideString; const cnpjFabrica: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const qtdeSolicitada: Int64; const tipoIdentificacao: Int64): RetornoSolicitacaoNumeracao; stdcall;
    function  solicitarNumeracaoReimpressao(const usuario: WideString; const senha: WideString; const cnpjFabrica: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const qtd: Integer; const numero: NumeroReimpressaoDTO): RetornoSolicitacaoNumeracaoReimpressao; stdcall;
    function  recuperarNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoRecuperarNumeracao; stdcall;
    function  consultaSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoConsultaSolicitacaoNumeracao; stdcall;
    function  consultarNumeracaoReimpressao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoConsultarNumeracaoReimpressao; stdcall;
    function  incluirAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedadeNascimento: Int64; const idPropriedadeLocalizacao: Int64; const idPropriedadeResponsavel: Int64; const numeroSisbov: WideString; 
                            const codigoRaca: WideString; const tipoIdentificacao: Int64; const sexo: WideString; const cnpjProdutor: WideString; const cpfProdutor: WideString): RetornoIncluirAnimal; stdcall;
    function  incluirAnimalImportado(const usuario: WideString; const senha: WideString; const codigoRaca: WideString; const nome: WideString; const codPais: WideString; const registroAssociacao: WideString; const numeroSisbov: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedade: Int64; 
                                     const cnpjProdutor: WideString; const cpfProdutor: WideString; const anoImportacao: Integer; const dataEntradaPais: WideString; const dataNascimento: WideString; const dataNascimentoEstimada: WideString; const sexo: WideString; const dataIdentificacao: WideString; const tipoIdentificacao: Integer; 
                                     const obs: WideString): RetornoIncluirAnimal; stdcall;
    function  alterarAnimalImportado(const usuario: WideString; const senha: WideString; const nome: WideString; const registroAssociacao: WideString; const numeroSisbov: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const sexo: WideString; const dataIdentificacao: WideString; const obs: WideString
                                     ): RetornoAlterarAnimal; stdcall;
    function  alterarAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedadeNascimento: Int64; const numeroSisbov: WideString; const codigoRaca: WideString; const tipoIdentificacao: Int64; 
                            const sexo: WideString): RetornoAlterarAnimal; stdcall;
    function  alterarIE(const usuario: WideString; const senha: WideString; const cpf: WideString; const cnpj: WideString; const idPropriedade: WideString; const numeroIE: WideString): RetornoAlterarIE; stdcall;
    function  recuperarSenha(const usuario: WideString; const email: WideString): RetornoRecuperarSenha; stdcall;
    function  cadastrarEmail(const usuario: WideString; const senha: WideString; const email: WideString): RetornoCadastrarEmail; stdcall;
    function  consultarEmail(const usuario: WideString; const senha: WideString): RetornoConsultarEmail; stdcall;
    function  alterarSenha(const usuario: WideString; const senha: WideString; const novaSenha: WideString): RetornoAlterarSenha; stdcall;
    function  consultarDadosAnimal(const usuario: WideString; const senha: WideString; const numeroSisbov: WideString): RetornoConsultarDadosAnimal; stdcall;
    function  consultarMovimentacao(const usuario: WideString; const senha: WideString; const gta: GtaDTO; const nrAcionamento: Int64): RetornoConsultarMovimentacao; stdcall;
    function  consultarDadosAnimalImportado(const usuario: WideString; const senha: WideString; const numeroSisbov: WideString): RetornoConsultarDadosAnimalImportado; stdcall;
    function  informarMorteAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const dataMorte: WideString; const codigoTipoMorte: Int64; const codigoCausaMorte: Int64): RetornoMorteAnimal; stdcall;
    function  informarDesligamentoAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const tipoDesligamento: Int64): RetornoDesligamentoAnimal; stdcall;
    function  movimentarAnimal(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const idPropriedadeDestino: Int64; 
                               const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalPropAglomeracao(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const idAglomeracaoDestino: Int64; 
                                              const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalAglomeracaoProp(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idAglomeracaoOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; 
                                              const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalAglomeracaoAglomeracao(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idAglomeracaoOrigem: Int64; const idAglomeracaoDestino: Int64; const gtas: GtaDTO; const numerosSISBOV: WideString
                                                     ): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalAglomeracaoAglomeracaoNovaProp(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idAglomeracaoOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; 
                                                             const idAglomeracaoDestino: Int64; const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalAglomeracaoNovaProp(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idAglomeracaoOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; 
                                                  const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalParaFrigorifico(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64; const cnpjFrigorifico: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; 
                                              const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  inventariarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const _numeroSolicitacao: Int64; const _cpfProdutor: WideString; const _cnpjProdutor: WideString; const _idPropriedadeDestino: Int64; const _tipoIdentificacao: Int64): RetornoInventarioSolicitacao; stdcall;
    function  cancelarMovimentacao(const usuario: WideString; const senha: WideString; const idMovimentacao: Int64; const motivoCancelamento: WideString): RetornoCancelarMovimentacao; stdcall;
    function  excluirVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoExcluirVistoria; stdcall;
    function  consultarAnimaisAbatidos(const usuario: WideString; const senha: WideString; const cnpjFrigorifico: WideString; const data: WideString): RetornoConsultarAnimaisAbatidos; stdcall;
    function  alterarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64; const tipoIdentificacao: Int64; const cnpjFabrica: WideString): RetornoAlterarSolicitacaoNumeracao; stdcall;
    function  cancelarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64; const numerosSisbov: WideString; const idPropriedade: Int64; const cnpjProdutor: WideString; const cpfProdutor: WideString; const idMotivoCancelamento: Int64): RetornoCancelarSolicitacaoNumeracao; stdcall;
    function  informarNotaFiscal(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const nrSerie: WideString; const nrNota: WideString; const dtNota: WideString): RetornoAlterarSolicitacaoNumeracao; stdcall;
    function  finalizarSolicNumAnimalImportado(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const cnpjFabrica: WideString; const nrSerie: WideString; const nrNota: WideString; const dtNota: WideString): RetornoFinalizarSolicNumAnimalImportado; stdcall;
    function  iniciarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const cpfSupervisor: WideString): RetornoCheckListVistoria; stdcall;
    function  reagendarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataReagendamento: WideString; const cpfSupervisor: WideString; const justificativa: WideString): RetornoCheckListVistoria; stdcall;
    function  consultarAgendamentoVistoria(const usuario: WideString; const senha: WideString; const dataInicial: WideString; const dataFinal: WideString; const idPropriedade: Int64; const cpfSupervisor: WideString; const uf: WideString; const municipio: WideString): RetornoConsultarAgendamento; stdcall;
    function  recuperarCheckListVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString): RetornoCheckListVistoria; stdcall;
    function  recuperarVistoriaLancada(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString): RetornoRespostasCheckListVistoria; stdcall;
    function  lancarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataVistoria: WideString; const cpfSupervisor: WideString; const resposta: CheckListItemRespostaDTO): RetornoWsSISBOV; stdcall;
    function  emitirParecerVistoriaRT(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const parecer: WideString; const cpfResponsavelTecnico: WideString): RetornoWsSISBOV; stdcall;
    function  finalizarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const cancelada: Boolean): RetornoWsSISBOV; stdcall;
    function  suspenderPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const idMotivo: Integer; const obs: WideString): RetornoSuspenderPropriedade; stdcall;
    function  solicitarCancelamentoSuspensao(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const justificativa: WideString; const idSuspensao: Int64): RetornoWsSISBOV; stdcall;
    function  consultarSuspensao(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoConsultarSuspensao; stdcall;
    function  solicitarAlteracaoPosse(const usuario: WideString; const senha: WideString; const idPropriedadeOrigem: WideString; const cpfProdutorOrigem: WideString; const cpfProdutorDestino: WideString; const motivoSolicitacao: Int64; const justificativa: WideString; const tipoEnvio: Int64; const qtdeAnimais: Int64; const numeracaoEnvio: WideString
                                      ): RetornoAlteracaoPosse; stdcall;
    function  consultarProtocoloSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataInicial: WideString; const dataFinal: WideString): RetornoConsultarProtocoloSolicitacaoNumeracao; stdcall;
    function  solicitarDistribuicaoNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const tipoEnvio: Integer; const idPropriedade: Int64; const cnpjProdutor: WideString; const cpfProdutor: WideString; const cnpjCertificadora: WideString; const numeroSisbov: WideString; const quantidade: Int64
                                             ): RetornoInformarDistribuicaoNumeracao; stdcall;
    function  consultarSolicitacaoDistribuicao(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const numeroSolicitacao: Int64; const cnpjProdutor: WideString; const dataInicial: WideString; const dataFinal: WideString): RetornoConsultarSolicitacaoDistribuicao; stdcall;
    function  consultarMovimentacaoExterna(const usuario: WideString; const senha: WideString; const idPropriedadeDestino: Int64; const cpfProdutorDestino: WideString; const dataInicial: WideString; const dataFinal: WideString): RetornoMovimentacaoExterna; stdcall;
    function  informarPeriodoConfinamento(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataConfinamentoInicial: WideString; const dataConfinamentoFinal: WideString; const cancelada: Boolean): RetornoWsSISBOV; stdcall;
  end;

function GetWsSISBOV(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): WsSISBOV;


implementation

function GetWsSISBOV(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): WsSISBOV;
const
  defWSDL = 'C:\Desenvolvimento\fontes\OCX HERDOM\WSDL\Desenvolvimento\WsSISBOV-15-06-2009.xml';
  defURL  = 'http://homolog.agricultura.gov.br/sisbov_ws_nova_hom/services/WsSISBOV';
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
    if Assigned(FlistaErros[I]) then
      FlistaErros[I].Free;
  SetLength(FlistaErros, 0);
  inherited Destroy;
end;

destructor RetornoRespostasCheckListVistoria.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fitem)-1 do
    if Assigned(Fitem[I]) then
      Fitem[I].Free;
  SetLength(Fitem, 0);
  inherited Destroy;
end;

destructor RetornoCheckListVistoria.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fitem)-1 do
    if Assigned(Fitem[I]) then
      Fitem[I].Free;
  SetLength(Fitem, 0);
  inherited Destroy;
end;

destructor RetornoConsultarNumeracaoReimpressao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracoes)-1 do
    if Assigned(Fnumeracoes[I]) then
      Fnumeracoes[I].Free;
  SetLength(Fnumeracoes, 0);
  inherited Destroy;
end;

destructor RetornoConsultaSolicitacaoNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    if Assigned(Fnumeracao[I]) then
      Fnumeracao[I].Free;
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoRecuperarNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    if Assigned(Fnumeracao[I]) then
      Fnumeracao[I].Free;
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoSolicitacaoNumeracao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    if Assigned(Fnumeracao[I]) then
      Fnumeracao[I].Free;
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoConsultarVinculoMorteCausa.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fvinculos)-1 do
    if Assigned(Fvinculos[I]) then
      Fvinculos[I].Free;
  SetLength(Fvinculos, 0);
  inherited Destroy;
end;

destructor RetornoConsultarAgendamento.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fagendamento)-1 do
    if Assigned(Fagendamento[I]) then
      Fagendamento[I].Free;
  SetLength(Fagendamento, 0);
  inherited Destroy;
end;

destructor RetornoConsultarSuspensao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FlistaSuspensao)-1 do
    if Assigned(FlistaSuspensao[I]) then
      FlistaSuspensao[I].Free;
  SetLength(FlistaSuspensao, 0);
  inherited Destroy;
end;

destructor SolicitacaoDistribuicaoSimplificada.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fnumeracao)-1 do
    if Assigned(Fnumeracao[I]) then
      Fnumeracao[I].Free;
  SetLength(Fnumeracao, 0);
  inherited Destroy;
end;

destructor RetornoConsultarSolicitacaoDistribuicao.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fsolicitacao)-1 do
    if Assigned(Fsolicitacao[I]) then
      Fsolicitacao[I].Free;
  SetLength(Fsolicitacao, 0);
  inherited Destroy;
end;

destructor MovimentacaoExternaDTO.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fmovimentacoes)-1 do
    if Assigned(Fmovimentacoes[I]) then
      Fmovimentacoes[I].Free;
  SetLength(Fmovimentacoes, 0);
  inherited Destroy;
end;

destructor RetornoMovimentacaoExterna.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FmovimentacaoPropriedade)-1 do
    if Assigned(FmovimentacaoPropriedade[I]) then
      FmovimentacaoPropriedade[I].Free;
  SetLength(FmovimentacaoPropriedade, 0);
  inherited Destroy;
end;

destructor RetornoRecuperarTabela.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fregistros)-1 do
    if Assigned(Fregistros[I]) then
      Fregistros[I].Free;
  SetLength(Fregistros, 0);
  inherited Destroy;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(WsSISBOV), 'http://servicosWeb.sisbov.mapa.gov.br', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(WsSISBOV), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(WsSISBOV), ioDocument);
  RemClassRegistry.RegisterXSClass(TipoMorteCausa, 'http://tipos.model.sisbov.mapa.gov.br', 'TipoMorteCausa');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns4_TipoMorteCausa), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns4_TipoMorteCausa');
  RemClassRegistry.RegisterXSClass(NumeroSimplificado, 'http://model.sisbov.mapa.gov.br', 'NumeroSimplificado');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_NumeroSimplificado), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_NumeroSimplificado');
  RemClassRegistry.RegisterXSClass(NumeroReimpressaoDTO, 'http://model.sisbov.mapa.gov.br', 'NumeroReimpressaoDTO');
  RemClassRegistry.RegisterXSClass(NumeroSimplificadoReimpressao, 'http://model.sisbov.mapa.gov.br', 'NumeroSimplificadoReimpressao');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_NumeroSimplificadoReimpressao), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_NumeroSimplificadoReimpressao');
  RemClassRegistry.RegisterXSClass(GtaDTO, 'http://model.sisbov.mapa.gov.br', 'GtaDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_xsd_string), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_xsd_string');
  RemClassRegistry.RegisterXSClass(CheckListItemDTO, 'http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br', 'CheckListItemDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns5_CheckListItemDTO), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns5_CheckListItemDTO');
  RemClassRegistry.RegisterXSClass(CheckListItemRespostaDTO, 'http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br', 'CheckListItemRespostaDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns5_CheckListItemRespostaDTO), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns5_CheckListItemRespostaDTO');
  RemClassRegistry.RegisterXSClass(Erro, 'http://model.sisbov.mapa.gov.br', 'Erro');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_Erro), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_Erro');
  RemClassRegistry.RegisterXSClass(RetornoWsSISBOV, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoWsSISBOV');
  RemClassRegistry.RegisterXSClass(RetornoRespostasCheckListVistoria, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRespostasCheckListVistoria');
  RemClassRegistry.RegisterXSClass(RetornoCheckListVistoria, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoCheckListVistoria');
  RemClassRegistry.RegisterXSClass(RetornoFinalizarSolicNumAnimalImportado, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoFinalizarSolicNumAnimalImportado');
  RemClassRegistry.RegisterXSClass(RetornoCancelarSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoCancelarSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoAlterarSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlterarSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoConsultarAnimaisAbatidos, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarAnimaisAbatidos');
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
  RemClassRegistry.RegisterXSClass(RetornoConsultarNumeracaoReimpressao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarNumeracaoReimpressao');
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
  RemClassRegistry.RegisterXSClass(RetornoConsultarVinculoMorteCausa, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarVinculoMorteCausa');
  RemClassRegistry.RegisterXSClass(CheckListAgendamentoDTO, 'http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br', 'CheckListAgendamentoDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns5_CheckListAgendamentoDTO), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns5_CheckListAgendamentoDTO');
  RemClassRegistry.RegisterXSClass(RetornoConsultarAgendamento, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarAgendamento');
  RemClassRegistry.RegisterXSClass(RetornoSuspenderPropriedade, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoSuspenderPropriedade');
  RemClassRegistry.RegisterXSClass(Suspensao, 'http://model.sisbov.mapa.gov.br', 'Suspensao');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_Suspensao), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_Suspensao');
  RemClassRegistry.RegisterXSClass(RetornoConsultarSuspensao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarSuspensao');
  RemClassRegistry.RegisterXSClass(RetornoAlteracaoPosse, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoAlteracaoPosse');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_xsd_long), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_xsd_long');
  RemClassRegistry.RegisterXSClass(RetornoConsultarProtocoloSolicitacaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarProtocoloSolicitacaoNumeracao');
  RemClassRegistry.RegisterXSClass(RetornoInformarDistribuicaoNumeracao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoInformarDistribuicaoNumeracao');
  RemClassRegistry.RegisterXSClass(SolicitacaoDistribuicaoSimplificada, 'http://model.sisbov.mapa.gov.br', 'SolicitacaoDistribuicaoSimplificada');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_SolicitacaoDistribuicaoSimplificada), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_SolicitacaoDistribuicaoSimplificada');
  RemClassRegistry.RegisterXSClass(RetornoConsultarSolicitacaoDistribuicao, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoConsultarSolicitacaoDistribuicao');
  RemClassRegistry.RegisterXSClass(MovimentacaoAnimalDTO, 'http://model.sisbov.mapa.gov.br', 'MovimentacaoAnimalDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_MovimentacaoAnimalDTO), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_MovimentacaoAnimalDTO');
  RemClassRegistry.RegisterXSClass(MovimentacaoExternaDTO, 'http://model.sisbov.mapa.gov.br', 'MovimentacaoExternaDTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_MovimentacaoExternaDTO), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_MovimentacaoExternaDTO');
  RemClassRegistry.RegisterXSClass(RetornoMovimentacaoExterna, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoMovimentacaoExterna');
  RemClassRegistry.RegisterXSClass(RegistroTabelaDominio, 'http://model.sisbov.mapa.gov.br', 'RegistroTabelaDominio');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOf_tns2_RegistroTabelaDominio), 'http://servicosWeb.sisbov.mapa.gov.br', 'ArrayOf_tns2_RegistroTabelaDominio');
  RemClassRegistry.RegisterXSClass(RetornoRecuperarTabela, 'http://retorno.servicosWeb.sisbov.mapa.gov.br', 'RetornoRecuperarTabela');

end. 