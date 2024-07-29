unit UintSoapSisbov;

{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE MSSQL}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, SysUtils, Classes, DB, Rio, uIntClassesBasicas,
  SOAPHTTPClient, uFerramentas, uConexao, uIntMensagens, XMLDOC, XMLIntf, uLibZipM, WsSISBOV1;

type
  TParametroMetodo = record
    Converter: Boolean;
    NomElementoPai: String;
    NomElementoFilho: String;
    IndTipoSimples: String;
    DesUriXmlnsPai: String;
    DesUriXmlnsFilho: String;
  end;

  THerdomHTTPRIO = class(THTTPRIO)
  protected
    procedure DoBeforeExecute(const MethodName: string; Request: TStream); override;
 end;

  TIntSoapSisbov = class(TIntClasseBDLeituraBasica)
//    HTTPRIO1: THerdomHTTPRIO;
    NodeD: array [0..64] of IXMLNode;
    NV: Integer;
    Metodo: String;
    Conexao: TConexao;
    DtaProc: TDateTime;
    NomArqXml: String;
    NomArqZip: String;
    FCodAnimalSisbov: String;
    FCpfCnpjPessoaOrigem: String;
    FCpfCnpjPessoaDestino: String;
    FCodPropriedadeRuralOrigem: Integer;
    FCodPropriedadeRuralDestino: Integer;
    FNroSolicitacaoSisbov: Integer;
    FNIdProdutorSISBOV:integer;
  private
    procedure LimpaAtributos;
    function IdToCodPropriedadeRural(IdPropriedade: Integer): Integer;
    function CpfCnpj(cpf, cnpj: String): String;
    procedure HTTPRIO1BeforeExecute(const MethodName: String;
        var SOAPRequest: WideString);
    procedure HTTPRIO1AfterExecute(const MethodName: String;
      SOAPResponse: TStream);
    function MetodoNecessitaConversao(NomeMetodo: String): Boolean;
    function ParametroNecessitaConversao(NomeMetodo, NomeParametro: String): TParametroMetodo;
    function ConverterMetodo(XMLOriginal: WideString): WideString;
    procedure ProcessarFilhos(NodePai: IXMLNode);
    procedure ProcessarFilhosConvertidos(NodePai: IXMLNode; Par: TParametroMetodo);
    procedure GravarInformacoes(GravarZip: Boolean; NomeArquivo: String; GravarLog: Boolean);
    procedure GravarArquivoZip(NomeArquivo: String);
    procedure GravarLogBanco;
    procedure AtribuirParametrosHTTPRIO(var H: THerdomHTTPRIO);
  public
    XD: IXMLDocument;
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;
    function Conectado(MsgRetorno: String): boolean;

    // Metodos WSDL
    function  recuperarTabela(const usuario: WideString; const senha: WideString; const idTabela: Int64): RetornoRecuperarTabela; stdcall;
    function  recuperarTabelaMunicipios(const usuario: WideString; const senha: WideString; const uf: WideString): RetornoRecuperarTabela; stdcall;
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
    function  incluirPropriedade(const usuario: WideString; const senha: WideString; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; const _nomePropriedade: WideString; const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString; const _grauLatitude: Integer;
                                 const _minutoLatitude: Integer; const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; const _segundoLongitude: Integer; const _area: Int64; const _logradouro: WideString; const _bairro: WideString;
                                 const _cep: WideString; const _codMunicipio: WideString; const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString; const _nrTelefoneContato: WideString;
                                 const _nrFaxContato: WideString): RetornoIncluirPropriedade; stdcall;
    function  alterarPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const _nirf: WideString; const _incra: WideString; const _tipoPropriedade: Int64; const _nomePropriedade: WideString; const _acessoFazenda: WideString; const _distanciaSedeMunicipio: Integer; const _orientacaoLatitude: WideString;
                                 const _grauLatitude: Integer; const _minutoLatitude: Integer; const _segundoLatitude: Integer; const _orientacaoLongitude: WideString; const _grauLongitude: Integer; const _minutoLongitude: Integer; const _segundoLongitude: Integer; const _area: Int64; const _logradouro: WideString;
                                 const _bairro: WideString; const _cep: WideString; const _codMunicipio: WideString; const _enderecoCorrespondenciaLogradouro: WideString; const _enderecoCorrespondenciaBairro: WideString; const _enderecoCorrespondenciaCep: WideString; const _enderecoCorrespondenciaCodMunicipio: WideString; const _telefoneResidencial: WideString; const _faxResidencial: WideString;
                                 const _nrTelefoneContato: WideString; const _nrFaxContato: WideString): RetornoAlterarPropriedade; stdcall;
    function  vincularProprietarioPropriedade(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64; const situacaoFundiaria: Int64): RetornoVincularProprietarioPropriedade; stdcall;
    function  desvincularPropriedadeProprietario(const usuario: WideString; const senha: WideString; const cpfProprietario: WideString; const cnpjProprietario: WideString; const idPropriedade: Int64): RetornoDesvincularProprietarioPropriedade; stdcall;
    function  vincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const IEProdutor: WideString; const ufIE: WideString; const tipoProdutor: Int64): RetornoVincularProdutorPropriedade; stdcall;
    function  desvincularProdutorPropriedade(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64): RetornoDesvincularProdutorPropriedade; stdcall;
    function  incluirVistoriaERAS(const usuario: WideString; const senha: WideString; const cpfSupervisor: WideString; const idPropriedade: Int64; const data: WideString): RetornoIncluirVistoriaERAS; stdcall;
    function  solicitarNumeracao(const usuario: WideString; const senha: WideString; const cnpjFabrica: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const qtdeSolicitada: Int64; const tipoIdentificacao: Int64): RetornoSolicitacaoNumeracao; stdcall;
    function  recuperarNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoRecuperarNumeracao; stdcall;

    function  solicitarNumeracaoReimpressao(const usuario: WideString; senha: WideString; cnpjFabrica, cpfProdutor, cnpjProdutor: WideString; const idPropriedade: Int64; const qtd: Integer; const numero: Array_Of_NumeroReimpressaoDTO): RetornoSolicitacaoNumeracaoReimpressao stdcall;
    function  consultarNumeracaoReimpressao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoConsultarNumeracaoReimpressao; stdcall;

    function  incluirAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedadeNascimento: Int64; const idPropriedadeLocalizacao: Int64; const idPropriedadeResponsavel: Int64; const numeroSisbov: WideString;
                            const codigoRaca: WideString; const tipoIdentificacao: Int64; const sexo: WideString; const cnpjProdutor: WideString; const cpfProdutor: WideString): RetornoIncluirAnimal; stdcall;
    function  alterarAnimal(const usuario: WideString; const senha: WideString; const dataIdentificacao: WideString; const dataNascimento: WideString; const numeroProvisorio: WideString; const numeroDefinitivo: WideString; const idPropriedadeNascimento: Int64; const numeroSisbov: WideString; const codigoRaca: WideString; const tipoIdentificacao: Int64;
                            const sexo: WideString): RetornoAlterarAnimal; stdcall;

    //druzo 27-05-2009 - Eventos de Suspenção de Propriedade
    function  suspenderPropriedade(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const idMotivo: Integer; const obs: WideString): RetornoWsSISBOV; stdcall;    
    function  consultarSuspensao(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoConsultarSuspensao; stdcall;
    //--------------------
    //druzo 16-06-2009 - Eventos de Vistoria
    function  iniciarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const cpfSupervisor: WideString): RetornoCheckListVistoria; stdcall;
    function  reagendarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataReagendamento: WideString; const cpfSupervisor: WideString; const justificativa: WideString): RetornoCheckListVistoria; stdcall;
    function  lancarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataVistoria: WideString; const cpfSupervisor: WideString; const resposta: CheckListItemRespostaDTO): RetornoWsSISBOV; stdcall;
    function  finalizarVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const cancelada: Boolean): RetornoWsSISBOV; stdcall;
    function  emitirParecerVistoriaRT(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString; const parecer: WideString; const cpfResponsavelTecnico: WideString): RetornoWsSISBOV; stdcall;
    //druzo 16-06-2009 - Eventos de Vistoria
    function  recuperarCheckListVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataAgendamento: WideString): RetornoCheckListVistoria; stdcall;
    //--------------------
    //druzo 07-07-2009
    function  informarPeriodoConfinamento(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const dataConfinamentoInicial: WideString; const dataConfinamentoFinal: WideString; const cancelada: Boolean): RetornoWsSISBOV; stdcall;
    //--------------------
    //druzo 28-07-2009
    function  solicitarAlteracaoPosse(const usuario: WideString; const senha: WideString; const idPropriedadeOrigem: WideString; const cpfProdutorOrigem: WideString; const cpfProdutorDestino: WideString; const motivoSolicitacao: Int64; const justificativa: WideString; const tipoEnvio: Int64; const qtdeAnimais: Int64; const numeracaoEnvio: widestring
                                      ): RetornoAlteracaoPosse; stdcall;
    //-------------------
    //druzo 06-04-2010
    function  informarAjusteRebanho(const usuario: WideString; const senha: WideString;
                                    const idPropriedade: Int64; const cpfProprietarioPropriedade: WideString;
                                    const cnpjProprietarioPropriedade: WideString): RetornoInformarAjusteRebanho; stdcall;

    function  alterarIE(const usuario: WideString; const senha: WideString; const cpf: WideString; const cnpj: WideString; const idPropriedade: Int64; const numeroIE: WideString): RetornoAlterarIE; stdcall;
    function  consultarDadosAnimal(const usuario: WideString; const senha: WideString; const numeroSisbov: WideString): RetornoConsultarDadosAnimal; stdcall;
    function  informarMorteAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const dataMorte: WideString; const codigoTipoMorte: Int64; const codigoCausaMorte: Int64): RetornoMorteAnimal; stdcall;
    function  informarDesligamentoAnimal(const usuario: WideString; const senha: WideString; const numeroSisbovAnimal: WideString; const tipoDesligamento: Int64): RetornoDesligamentoAnimal; stdcall;

    // Funcao movimentarAnimalParaFrigorifico
    // Alterada 11/01/2007(conforme documentacao SISBOV)
    // Permance ainda a chamada para a funcao anterior a esta data.
    //
    //function  movimentarAnimal(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString;
    //                           const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimal(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString;
                               const idPropriedadeOrigem: Int64; const idPropriedadeDestino: Int64; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const cpfProdutorDestino: WideString;
                               const cnpjProdutorDestino: WideString; const gtas: Array_Of_GtaDTO; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao;

    function  movimentarAnimalNaoErasPraEras(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const codigo: WideString; const nirf: WideString; const incra: WideString; const idPropriedadeDestino: Int64;
                                             const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString; const gtas: Array_Of_GtaDTO; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao; stdcall;
    function  migrarAnimalNaoInventariado(const usuario: WideString; const senha: WideString; const codigo: WideString; const nirf: WideString; const incra: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const idPropriedadeDestino: Int64; const cpfProdutorDestino: WideString; const cnpjProdutorDestino: WideString;
                                          const justificativa: Integer; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao; stdcall;

    // Funcao movimentarAnimalParaFrigorifico
    // Alterada 11/01/2007(conforme documentacao SISBOV)
    // Permance ainda a chamada para a funcao anterior a esta data.
    //
    //function  movimentarAnimalParaFrigorifico(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64; const cnpjFrigorifico: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString;
    //                                          const gtas: GtaDTO; const numerosSISBOV: WideString): RetornoInformarMovimentacao; stdcall;
    function  movimentarAnimalParaFrigorifico(const usuario: WideString; const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString; const dataChegada: WideString;
                                              const idPropriedadeOrigem: Int64; const cnpjFrigorifico: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const gtas: Array_Of_GtaDTO;
                                              const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao; stdcall;

    function  inventariarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const _numeroSolicitacao: Int64; const _cpfProdutor: WideString; const _cnpjProdutor: WideString; const _idPropriedadeDestino: Int64; const _tipoIdentificacao: Int64): RetornoInventarioSolicitacao; stdcall;
//    function  solicitarInventarioAnimais(const usuario: WideString; const senha: WideString; const idPropriedade: Int64; const quantidade: Integer; const numerosSisbov: ArrayOf_xsd_string): RetornoSolicitarInventarioAnimal; stdcall;
//    function  consultarInventarioAnimais(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoConsultarInventarioAnimal; stdcall;
//    function  incluirAnimalNaoInventariado(const usuario: WideString; const senha: WideString; const cpfProdutor: WideString; const cnpjProdutor: WideString; const idPropriedade: Int64; const numeroSisbov: WideString): RetornoIncluirAnimalNaoInventariado; stdcall;
    function  cancelarMovimentacao(const usuario: WideString; const senha: WideString; const idMovimentacao: Int64; const motivoCancelamento: WideString): RetornoCancelarMovimentacao; stdcall;
    function  excluirVistoria(const usuario: WideString; const senha: WideString; const idPropriedade: Int64): RetornoExcluirVistoria; stdcall;
    function  consultarAnimaisAbatidos(const usuario: WideString; const senha: WideString; const cnpjFrigorifico: WideString; const data: WideString): RetornoConsultarAnimaisAbatidos; stdcall;
    function  alterarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64; const tipoIdentificacao: Int64; const cnpjFabrica: WideString): RetornoAlterarSolicitacaoNumeracao; stdcall;

    // Funcao cancelarSolicitacaoNumeracao
    // Atualizada 16/09/2008 (conforme documentacao SISBOV)
    // Permance ainda a chamada para a funcao anterior a esta data.
    //
    function  cancelarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64; const numerosSisbov: ArrayOf_xsd_string; const idPropriedade: Int64; const cnpjProdutor: WideString; const cpfProdutor: WideString; const idMotivoCancelamento: Int64): RetornoCancelarSolicitacaoNumeracao; stdcall;
    //function  cancelarSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const idSolicitacao: Int64): RetornoCancelarSolicitacaoNumeracao; stdcall;

    function  informarNotaFiscal(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64; const nrSerie: WideString; const nrNota: WideString; const dtNota: WideString): RetornoAlterarSolicitacaoNumeracao; stdcall;
    function  cadastrarEmail(const usuario: WideString; const senha: WideString; const email: WideString): RetornoCadastrarEmail; stdcall;
    function  consultarEmail(const usuario: WideString; const senha: WideString): RetornoConsultarEmail; stdcall;
    function  consultaSolicitacaoNumeracao(const usuario: WideString; const senha: WideString; const numeroSolicitacao: Int64): RetornoConsultaSolicitacaoNumeracao; stdcall;

//    property httpprio: THerdomHTTPRIO read HTTPRIO1;
    property CodAnimalSisbov: String read FCodAnimalSisbov write FCodAnimalSisbov;
    property CpfCnpjPessoaOrigem: String read FCpfCnpjPessoaOrigem write FCpfCnpjPessoaOrigem;
    property CpfCnpjPessoaDestino: String read FCpfCnpjPessoaDestino write FCpfCnpjPessoaDestino;
    property CodPropriedadeRuralOrigem: Integer read FCodPropriedadeRuralOrigem write FCodPropriedadeRuralOrigem;
    property CodPropriedadeRuralDestino: Integer read FCodPropriedadeRuralDestino write FCodPropriedadeRuralDestino;
    property NroSolicitacaoSisbov: Integer read FNroSolicitacaoSisbov write FNroSolicitacaoSisbov;
    Property IdProdutorSISBOV:integer read FNIdProdutorSISBOV write FNIdProdutorSISBOV;
  end;

implementation

uses ComServ ;

{ THerdomHTTPRIO }
procedure THerdomHTTPRIO.DoBeforeExecute(const MethodName: string;
  Request: TStream);
var
  StrStrm: TStringStream;
  ReqW: WideString;
begin
  {Este método foi re-escrito para que o evento OnBeforeExecute funcione corretamente.
   No Delphi 7, mesmo alterando-se o conteúdo do XML no OnBeforeExecute, este novo conteúdo
   não era utilizado pelo delphi após a execução do evento.
   Sendo assim, criamos uma classe THerdomHTTPRIO derivada da classe THTTPRIO, que por sua
   vez é derivada da classe TRIO onde está o método DoBeforeExecute (Source\Soap\Rio.pas),
   e sobreescrevemos o método para que utilize o conteúdo alterado no evento OnBeforeExecute.
   Em caso de mudança de versão do Delphi, verificar na Rio.pas se o código do método DoBeforeExecute
   não foi alterado, caso tenha sido, estas alterações devem ser refletidas no método re-escrito
   abaixo}
  if Assigned(OnBeforeExecute) then  // no método original era FOnBeforeExecute
  begin
    StrStrm := TStringStream.Create('');
    try
      StrStrm.CopyFrom(Request, 0);
      Request.Position := 0;
      ReqW := StrStrm.DataString;
      OnBeforeExecute(MethodName, ReqW); // no método original era FOnBeforeExecute

      // Trecho de código adicionado ao código original do método onde obtemos o conteúdo alterado
      // no evento OnBeforeExecute e "devolvemos" ao Delphi para que este novo conteúdo possa ser
      // utilizado
      StrStrm.Size := 0;
      StrStrm.WriteString(ReqW);
      Request.Size := Length(ReqW);
      Request.CopyFrom(StrStrm, 0);
      // Fim do trecho adicionado ao código original
    finally
      StrStrm.Free;
    end;
  end;
end;

{ TIntSoapSisbov }

constructor TIntSoapSisbov.Create;
begin
  inherited;
//  HTTPRIO1 := THerdomHTTPRIO.Create(nil);
end;

destructor TIntSoapSisbov.Destroy;
begin
//  if Assigned(HTTPRIO1) then begin
//    HTTPRIO1.Free;
//  end;
  inherited;
end;

function TIntSoapSisbov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
  If Result <> 0 Then Begin
    Exit;
  End;

  Conexao := ConexaoBD;
//  HTTPRIO1.URL := ValorParametro(117);
//  HTTPRIO1.HTTPWebNode.Proxy:= ValorParametro(120);
//  HTTPRIO1.HTTPWebNode.UserName:= Descriptografar(ValorParametro(121));
//  HTTPRIO1.HTTPWebNode.Password:= Descriptografar(ValorParametro(122));
//  HTTPRIO1.OnBeforeExecute := HTTPRIO1BeforeExecute;
//  HTTPRIO1.OnAfterExecute := HTTPRIO1AfterExecute;

  Result := 0;
end;

procedure TIntSoapSisbov.LimpaAtributos;
begin
  FCodAnimalSisbov := '';
  FCpfCnpjPessoaOrigem  := '';
  FCpfCnpjPessoaDestino  := '';
  FCodPropriedadeRuralOrigem := -1;
  FCodPropriedadeRuralDestino := -1;
  FNroSolicitacaoSisbov := -1;
  FNIdProdutorSISBOV  :=  -1;
end;

function TIntSoapSisbov.IdToCodPropriedadeRural(
  IdPropriedade: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_propriedade_rural ');
      Q.SQL.Add('  from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_id_propriedade_sisbov = :cod_id_propriedade_sisbov ');
{$ENDIF}
      Q.ParamByName('cod_id_propriedade_sisbov').AsInteger := IdPropriedade;
      Q.Open;
      if not Q.IsEmpty then begin
        Result := Q.fieldByName('cod_propriedade_rural').AsInteger;
      end;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(2362, Self.ClassName, 'IdToCodPropriedadeRural', [E.Message]);
        raise;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSoapSisbov.CpfCnpj(cpf, cnpj: String): String;
begin
  if cpf <> '' then begin
    result := cpf;
  end else begin
    result := cnpj;
  end;
end;

function TIntSoapSisbov.Conectado(MsgRetorno: String): boolean;
var
  retorno: RetornoRecuperarTabela;
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  // Pela razão do Sisbov estar com muitos erros na conexão do método abaixo,
  // foi acrescentado o teste abaixo desabilitando a chamada do método passando
  // o parametro 123 com o valor 1000
  if StrToInt(ValorParametro(123)) = 1000 then begin
    Result := True;
    exit
  end;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Conectado');
    Result := false;
    Exit;
  End;

  try
    try
      retorno:= ObjSoap.recuperarTabela(Descriptografar(ValorParametro(118)),
                                      Descriptografar(ValorParametro(119)),
                                      StrToInt(ValorParametro(123)));
    except
      On e:Exception do Begin
        Mensagens.Adicionar(2366, Self.ClassName, 'ConectarWebServiceExceptChamMetodo', [e.Message, MsgRetorno]);
        Result  := false;
        exit;
      end;
    end;

    if retorno <> nil then begin
      if (retorno.status = 1) or (retorno.listaErros[0].codigoErro = '0.000') then begin
        Result := true;
      end else begin
        Mensagens.Adicionar(2366, Self.ClassName, 'ConectarWebService', [retorno.listaErros[0].menssagemErro, MsgRetorno]);
        Result  := false;
      end;
    end else begin
      Result := true;
    end;
  except
    On e:Exception do Begin
      Mensagens.Adicionar(2335, Self.ClassName, 'ConectarWebServiceExceptHTTP', [e.Message, MsgRetorno]);
      result := false;
    end;
  end;
end;

procedure TIntSoapSisbov.HTTPRIO1BeforeExecute(const MethodName: String;
  var SOAPRequest: WideString);
var
  M : TMemoryStream;
  S : TStringStream;
  NomArqEnv: String;
begin
  Metodo := MethodName;
  if Uppercase(MethodName) <> 'RECUPERARTABELA' then begin
    // Obtém data do Sistema
    DtaProc := Conexao.DtaSistema;
    // Memory Stream para gravar o arquivo
    M := TMemoryStream.Create;
    Try
      // String Stream para obter o string do XML e enviá-lo ao Memory Stream de gravação do arquivo
      S := TStringStream.Create('');
      Try
        // Verifica se o método precisará ter parâmetros array convertidos devido ao problema do Delphi
        // com parâmetros array no WSDL (maxOccurs="unbounded")
        if MetodoNecessitaConversao(MethodName) then begin
          Metodo := MethodName;
          SOAPRequest := ConverterMetodo(SOAPRequest);
        end;

        // Salva arquivo com o XML gerado
        S.Size := 0;
        S.WriteString(SOAPRequest);
        M.Clear;
        M.LoadFromStream(S);
        NomArqEnv := ValorParametro(16)   + '\' +
          FormatDateTime('yyyy', DtaProc) + '\' +
          FormatDateTime('mm', DtaProc)   + '\' +
          FormatDateTime('dd', DtaProc)   + '\' +
          Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaProc) + '_ENV_' + MethodName + '.xml';
        NomArqZip := ValorParametro(16)   + '\' +
          FormatDateTime('yyyy', DtaProc) + '\' +
          FormatDateTime('mm', DtaProc)   + '\' +
          FormatDateTime('dd', DtaProc)   + '\' +
          Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaProc) + '_' + MethodName + '.zip';

        if not ForceDirectories(ExtractFileDir(NomArqEnv)) then
        begin
          Mensagens.Adicionar(1079, Self.ClassName, Metodo, [ExtractFileDir(NomArqEnv)]);
          Exit;
        end;

        M.SaveToFile(NomArqEnv);

        NomArqXML := NomArqEnv;
        
        // Grava arquivo ZIP e gera LOG no banco
        GravarInformacoes(false, NomArqEnv, true);
      Finally
        S.Free;
      End;
    Finally
      M.Free;
    End;
  end;
end;

procedure TIntSoapSisbov.HTTPRIO1AfterExecute(const MethodName: String;
  SOAPResponse: TStream);
var
  M : TMemoryStream;
  NomArqRet: String;
begin
  Metodo := MethodName;
  if Uppercase(MethodName) <> 'RECUPERARTABELA' then begin
    M := TMemoryStream.Create;
    Try
      M.LoadFromStream(SOAPResponse);
      NomArqRet := ValorParametro(16)   + '\' +
        FormatDateTime('yyyy', DtaProc) + '\' +
        FormatDateTime('mm', DtaProc)   + '\' +
        FormatDateTime('dd', DtaProc)   + '\' +
        Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaProc) + '_RET_' + MethodName + '.xml';

      if not ForceDirectories(ExtractFileDir(NomArqRet)) then
        begin
          Mensagens.Adicionar(1079, Self.ClassName, Metodo, [ExtractFileDir(NomArqRet)]);
          Exit;
        end;

      M.SaveToFile(NomArqRet);

      // Grava informações
      GravarInformacoes(false, NomArqRet, false);
    Finally
      M.Free;
    end;
  end;
end;

function TIntSoapSisbov.MetodoNecessitaConversao(NomeMetodo: String): Boolean;
var
  Q : THerdomQuery;
begin
  Result := false;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_metodo_soap_conversao ');
      Q.SQL.Add(' where nom_metodo_soap = :nom_metodo_soap ');
{$ENDIF}
      Q.ParamByName('nom_metodo_soap').AsString := NomeMetodo;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Result := true;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2363, Self.ClassName, 'MetodoNecessitaConversao', [E.Message]);
        raise;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSoapSisbov.ParametroNecessitaConversao(
  NomeMetodo, NomeParametro: String): TParametroMetodo;
var
  Q : THerdomQuery;
begin
  Result.Converter := false;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select nom_elemento_pai, nom_elemento_filho, ind_tipo_simples, des_uri_xmlns_pai, des_uri_xmlns_filho ');
      Q.SQL.Add('  from tab_metodo_soap_conversao ');
      Q.SQL.Add(' where nom_metodo_soap = :nom_metodo_soap ');
      Q.SQL.Add('   and nom_elemento_pai = :nom_elemento_pai ');
{$ENDIF}
      Q.ParamByName('nom_metodo_soap').AsString := NomeMetodo;
      Q.ParamByName('nom_elemento_pai').AsString := NomeParametro;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Result.Converter := true;
        Result.NomElementoPai := Q.FieldByName('nom_elemento_pai').AsString;
        Result.NomElementoFilho := Q.FieldByName('nom_elemento_filho').AsString;
        Result.IndTipoSimples := Q.FieldByName('ind_tipo_simples').AsString;
        Result.DesUriXmlnsPai := Q.FieldByName('des_uri_xmlns_pai').AsString;
        Result.DesUriXmlnsFilho := Q.FieldByName('des_uri_xmlns_filho').AsString;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2363, Self.ClassName, 'ParametroNecessitaConversao', [E.Message]);
        raise;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSoapSisbov.ConverterMetodo(XMLOriginal: WideString): WideString;
var
  S : TStringStream;
  XO: IXMLDocument;
begin
  Result := XMLOriginal;
  // Cria StringStream para armazenar o string do XML Original
  S := TStringStream.Create(XMLOriginal);
  Try
    // Cria objeto para manipular XML Original
    XO := XMLDoc.NewXMLDocument;
    Try
      // Cria objeto para manipular XML Destino (novo XML a ser gerado)
       XD := XMLDoc.NewXMLDocument;
      Try
        XO.Active := True;
        XD.Active := True;

        // Armazena no objeto XO o conteúdo do StringStream que é o XML Original
        XO.LoadFromStream(S);

        // Varre nodes do XML origem
        NV := 0;
        ProcessarFilhos(XO.Node);
        Result := XD.XML.Text;
      Finally
        XD := nil;
      End;
    Finally
      XO := nil;
    End;
  Finally
    S.Free;
  End;
end;

procedure TIntSoapSisbov.ProcessarFilhos(NodePai: IXMLNode);
var
  I : Integer;
  Node: IXMLNode;
  Par: TParametroMetodo;
begin
  if NV > Length(NodeD) - 1 then begin
    raise Exception.Create('Número de níveis de elementos do XML excedeu o máximo definido (' + IntToStr(Length(NodeD)) + ')');
  end;

  For I := 0 to NodePai.ChildNodes.Count - 1 do begin
    Node := NodePai.ChildNodes.Get(I);

    Par := ParametroNecessitaConversao(Metodo, Node.NodeName);

    case Node.NodeType of
      ntAttribute:
      begin
      end;

      ntElement:
      begin
        If NodePai.ParentNode = nil then begin
          NodeD[NV] := XD.AddChild(Node.NodeName, Node.NamespaceURI);
        End else begin
          NodeD[NV] := NodeD[NV-1].AddChild(Node.NodeName, Node.NamespaceURI);
        End;
        if Node.HasChildNodes then begin
          Inc(NV);
          if Par.Converter then begin
            ProcessarFilhosConvertidos(Node, Par);
          end else begin
            ProcessarFilhos(Node);
          end;
          Dec(NV);
        end;
      end;

      ntText:
      begin
        NodeD[NV-1].Text := Node.Text;
      end;

      ntCData:
      begin
      end;

      ntEntityRef:
      begin
      end;

      ntEntity:
      begin
      end;

      ntProcessingInstr:
      begin
        XD.CreateNode(Node.NodeName, Node.NodeType, Node.NodeValue);
      end;

      ntComment:
      begin
      end;

      ntDocument:
      begin
      end;

      ntDocType:
      begin
      end;

      ntDocFragment:
      begin
      end;

      ntNotation:
      begin
      end;
    end;
  End;
end;


procedure TIntSoapSisbov.ProcessarFilhosConvertidos(NodePai: IXMLNode;
  Par: TParametroMetodo);
var
  I : Integer;
  Node : IXMLNode;
begin
  For I := 0 to NodePai.ChildNodes.Count - 1 do begin
    Node := NodePai.ChildNodes.Get(I);

    case Node.NodeType of
      ntElement:
      begin
        If Node.NodeName <> Par.NomElementoFilho then begin
          NodeD[NV] := NodeD[NV-1].AddChild(Node.NodeName, Node.NamespaceURI);
        End;
        if Node.HasChildNodes then begin
          // Após a primeira iteração do loop, deve-se criar "artificialmente" um novo Node
          // com o nome do parâmetro para criar um filho com o valor abaixo dele
          if I > 0 then begin
            if Node.ParentNode.NodeName <> Par.NomElementoFilho then begin
              if Par.DesUriXmlnsPai <> '' then begin
                NodeD[NV] := NodeD[NV-2].AddChild(Par.NomElementoPai, Par.DesUriXmlnsPai);
              end else begin
                NodeD[NV] := NodeD[NV-2].AddChild(Par.NomElementoPai);
              end;
              Inc(NV)
            end;
          end;
          ProcessarFilhosConvertidos(Node, Par);
          if I > 0 then begin
            if Node.ParentNode.NodeName <> Par.NomElementoFilho then begin
              Dec(NV)
            end;  
          end;
        end;
      end;

      ntText:
      begin
        if Par.IndTipoSimples = 'S' then begin
          NodeD[NV-1].Text := Node.Text;
        end else begin
          NodeD[NV].Text := Node.Text;
        end;
      end;
    end;
  End;
end;

procedure TIntSoapSisbov.GravarInformacoes(GravarZip: Boolean; NomeArquivo: String; GravarLog: Boolean);
const
  NomeMetodo : String = 'GravarInformacoes';
begin
  if GravarZip then begin
    GravarArquivoZip(NomeArquivo);
  end;

  if GravarLog then begin
    GravarLogBanco;
  end;
end;

procedure TIntSoapSisbov.GravarArquivoZip(NomeArquivo: String);
const
  NomeMetodo : String = 'GravarArquivoZip';
var
  Zip: ZipFile;
  ZipAberto: Boolean;
begin
  // Cria e/ou abre o arquivo ZIP
  if AbrirZip(NomArqZip, Zip, FileExists(NomArqZip)) < 0 then begin
    Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArqZip, 'criação']);
    raise Exception.Create(NomeMetodo);
  end;
  ZipAberto := True;

  // Se abriu o arquivo ZIP deve-se garantir que o mesmo será fechado haja sucesso ou não
  // nas operações subsequentes, por isso o try/finally
  Try
    // Adiciona XML no arquivo ZIP
    if AdicionarArquivoNoZipSemHierarquiaPastas(Zip, NomeArquivo) < 0 then begin
      Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [NomeArquivo, NomArqZip]);
      raise Exception.Create(NomeMetodo);
    end;

    // Fecha Arquivo Zip
    if FecharZip(Zip, nil) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArqZip, 'conclusão']);
      raise Exception.Create(NomeMetodo);
    end else begin
      ZipAberto := False;
    end;

    // Exclui o arquivo XML original após geração do zip
    DeleteFile(NomeArquivo);
  Finally
    if ZipAberto then begin
      if (FecharZip(Zip, nil) < 0) then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomArqZip, 'conclusão']);
        raise Exception.Create(NomeMetodo);
      end;
    end;
  End;

end;

procedure TIntSoapSisbov.GravarLogBanco;
const
  NomeMetodo : String = 'GravarLogBanco';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_log_transacao_sisbov ');
      Q.SQL.Add('  (dta_transacao_arquivo, ');
      Q.SQL.Add('   cod_usuario_transacao, ');
      Q.SQL.Add('   nom_metodo_transacao, ');
      Q.SQL.Add('   nom_arquivo_transacao, ');
      Q.SQL.Add('   cod_animal_sisbov, ');
      Q.SQL.Add('   cpf_cnpj_pessoa_origem, ');
      Q.SQL.Add('   cpf_cnpj_pessoa_destino, ');
      Q.SQL.Add('   cod_propriedade_origem, ');
      Q.SQL.Add('   cod_propriedade_destino, ');
      Q.SQL.Add('   nro_solicitacao_sisbov) ');
      Q.SQL.Add('values ');
      Q.SQL.Add('  (:dta_transacao_arquivo, ');
      Q.SQL.Add('   :cod_usuario_transacao, ');
      Q.SQL.Add('   :nom_metodo_transacao,  ');
      Q.SQL.Add('   :nom_arquivo_transacao, ');
      Q.SQL.Add('   :cod_animal_sisbov, ');
      Q.SQL.Add('   :cpf_cnpj_pessoa_origem, ');
      Q.SQL.Add('   :cpf_cnpj_pessoa_destino, ');
      Q.SQL.Add('   :cod_propriedade_origem, ');
      Q.SQL.Add('   :cod_propriedade_destino, ');
      Q.SQL.Add('   :nro_solicitacao_sisbov) ');
{$ENDIF}
      Q.ParamByName('dta_transacao_arquivo').AsDateTime := DtaProc;
      Q.ParamByName('cod_usuario_transacao').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('nom_metodo_transacao').AsString := Metodo;
      Q.ParamByName('nom_arquivo_transacao').AsString := NomArqXML;
      if FCodAnimalSisbov <> '' then begin
        Q.ParamByName('cod_animal_sisbov').AsString := FCodAnimalSisbov;
      end else begin
        Q.ParamByName('cod_animal_sisbov').DataType := ftString;
        Q.ParamByName('cod_animal_sisbov').Clear;
      end;
      if FCpfCnpjPessoaOrigem <> '' then begin
        Q.ParamByName('cpf_cnpj_pessoa_origem').AsString := FCpfCnpjPessoaOrigem;
      end else begin
        Q.ParamByName('cpf_cnpj_pessoa_origem').DataType := ftString;
        Q.ParamByName('cpf_cnpj_pessoa_origem').Clear;
      end;
      if FCpfCnpjPessoaDestino <> '' then begin
        Q.ParamByName('cpf_cnpj_pessoa_destino').AsString := FCpfCnpjPessoaDestino;
      end else begin
        Q.ParamByName('cpf_cnpj_pessoa_destino').DataType := ftString;
        Q.ParamByName('cpf_cnpj_pessoa_destino').Clear;
      end;
      if FCodPropriedadeRuralOrigem > 0 then begin
        Q.ParamByName('cod_propriedade_origem').AsInteger := FCodPropriedadeRuralOrigem;
      end else begin
        Q.ParamByName('cod_propriedade_origem').DataType := ftInteger;
        Q.ParamByName('cod_propriedade_origem').Clear;
      end;
      if FCodPropriedadeRuralDestino > 0 then begin
        Q.ParamByName('cod_propriedade_destino').AsInteger := FCodPropriedadeRuralDestino;
      end else begin
        Q.ParamByName('cod_propriedade_destino').DataType := ftInteger;
        Q.ParamByName('cod_propriedade_destino').Clear;
      end;
      if FNroSolicitacaoSisbov > 0 then begin
        Q.ParamByName('nro_solicitacao_sisbov').AsInteger := FNroSolicitacaoSisbov;
      end else begin
        Q.ParamByName('nro_solicitacao_sisbov').DataType := ftInteger;
        Q.ParamByName('nro_solicitacao_sisbov').Clear;
      end;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2362, Self.ClassName, NomeMetodo, [E.Message]);
        raise;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSoapSisbov.alterarAnimal(const usuario, senha,
  dataIdentificacao, dataNascimento, numeroProvisorio,
  numeroDefinitivo: WideString; const idPropriedadeNascimento: Int64;
  const numeroSisbov, codigoRaca: WideString;
  const tipoIdentificacao: Int64;
  const sexo: WideString): RetornoAlterarAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodAnimalSisbov := numeroSisbov;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedadeNascimento);
  Result := Objsoap.alterarAnimal(usuario, senha, dataIdentificacao, dataNascimento, numeroProvisorio,
    numeroDefinitivo, idPropriedadeNascimento, numeroSisbov, codigoRaca, tipoIdentificacao, sexo);
end;

function TIntSoapSisbov.alterarProdutor(const usuario, senha, _razaoSocial,
  _cnpj, _nome, _telefone, _email, _cpf, _sexo, _logradouro, _bairro, _cep,
  _codMunicipio, _telefoneResidencial, _faxResidencial, _nrTelefoneContato,
  _nrFaxContato: WideString): RetornoAlterarProdutor;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(_cpf, _cnpj);
  Result := Objsoap.alterarProdutor(usuario, senha, _razaoSocial, _cnpj, _nome, _telefone, _email,
    _cpf, _sexo, _logradouro, _bairro, _cep, _codMunicipio, _telefoneResidencial, _faxResidencial, _nrTelefoneContato,
    _nrFaxContato);
end;

function TIntSoapSisbov.alterarPropriedade(const usuario,
  senha: WideString; const idPropriedade: Int64; const _nirf,
  _incra: WideString; const _tipoPropriedade: Int64;
  const _nomePropriedade, _acessoFazenda: WideString;
  const _distanciaSedeMunicipio: Integer;
  const _orientacaoLatitude: WideString; const _grauLatitude,
  _minutoLatitude, _segundoLatitude: Integer;
  const _orientacaoLongitude: WideString; const _grauLongitude,
  _minutoLongitude, _segundoLongitude: Integer; const _area: Int64;
  const _logradouro, _bairro, _cep, _codMunicipio,
  _enderecoCorrespondenciaLogradouro, _enderecoCorrespondenciaBairro,
  _enderecoCorrespondenciaCep, _enderecoCorrespondenciaCodMunicipio,
  _telefoneResidencial, _faxResidencial, _nrTelefoneContato,
  _nrFaxContato: WideString): RetornoAlterarPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);

  Result := ObjSoap.alterarPropriedade(usuario, senha, idPropriedade, _nirf, _incra, _tipoPropriedade,
    _nomePropriedade, _acessoFazenda, _distanciaSedeMunicipio, _orientacaoLatitude, _grauLatitude, _minutoLatitude,
    _segundoLatitude, _orientacaoLongitude, _grauLongitude, _minutoLongitude, _segundoLongitude, _area, _logradouro,
    _bairro, _cep, _codMunicipio, _enderecoCorrespondenciaLogradouro, _enderecoCorrespondenciaBairro,
    _enderecoCorrespondenciaCep, _enderecoCorrespondenciaCodMunicipio, _telefoneResidencial, _faxResidencial,
    _nrTelefoneContato, _nrFaxContato);

end;

function TIntSoapSisbov.alterarProprietario(const usuario, senha,
  _razaoSocial, _cnpj, _nome, _telefone, _email, _cpf, _sexo, _logradouro,
  _bairro, _cep, _codMunicipio: WideString): RetornoAlterarProprietario;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(_cpf, _cnpj);
  Result := Objsoap.alterarProprietario(usuario, senha, _razaoSocial, _cnpj, _nome, _telefone, _email,
    _cpf, _sexo, _logradouro, _bairro, _cep, _codMunicipio);
end;

function TIntSoapSisbov.alterarSolicitacaoNumeracao(const usuario,
  senha: WideString; const idSolicitacao, tipoIdentificacao: Int64;
  const cnpjFabrica: WideString): RetornoAlterarSolicitacaoNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := idSolicitacao;
  Result := Objsoap.alterarSolicitacaoNumeracao(usuario, senha, idSolicitacao, tipoIdentificacao,
    cnpjFabrica);
end;

function TIntSoapSisbov.alterarSupervisor(const usuario, senha, _nome,
  _telefone, _email, _cpf, _rg, _dataNascimento, _dataExpedicao,
  _OrgaoExpedidor, _ufExpedidor, _sexo, _logradouro, _bairro, _cep,
  _codMunicipio: WideString): RetornoAlterarSupervisor;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := _cpf;
  Result := Objsoap.alterarSupervisor(usuario, senha, _nome, _telefone, _email, _cpf, _rg, _dataNascimento,
    _dataExpedicao, _OrgaoExpedidor, _ufExpedidor, _sexo, _logradouro, _bairro, _cep, _codMunicipio);
end;

function TIntSoapSisbov.cancelarMovimentacao(const usuario,
  senha: WideString; const idMovimentacao: Int64;
  const motivoCancelamento: WideString): RetornoCancelarMovimentacao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.cancelarMovimentacao(usuario, senha, idMovimentacao, motivoCancelamento);
end;

//function TIntSoapSisbov.cancelarSolicitacaoNumeracao(const usuario,
//  senha: WideString;
//  const idSolicitacao: Int64): RetornoCancelarSolicitacaoNumeracao;
//var
//  Objsoap : WSSISBOV;
//  H : THerdomHTTPRIO;
//begin
//  H := THerdomHTTPRIO.Create(nil);
//  AtribuirParametrosHTTPRIO(H);
//  ObjSoap := H as WSSISBOV;
//
//  LimpaAtributos;
//  FNroSolicitacaoSisbov := idSolicitacao;
//  Result := Objsoap.cancelarSolicitacaoNumeracao(usuario, senha, idSolicitacao);
//end;

function TIntSoapSisbov.cancelarSolicitacaoNumeracao(const usuario,
  senha: WideString; const idSolicitacao: Int64;
  const numerosSisbov: ArrayOf_xsd_string; const idPropriedade: Int64;
  const cnpjProdutor, cpfProdutor: WideString;
  const idMotivoCancelamento: Int64): RetornoCancelarSolicitacaoNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := idSolicitacao;
  Result := Objsoap.cancelarSolicitacaoNumeracao(usuario, senha, idSolicitacao, numerosSisbov, idPropriedade, cnpjProdutor, cpfProdutor, idMotivoCancelamento);
end;

function TIntSoapSisbov.consultarAnimaisAbatidos(const usuario, senha,
  cnpjFrigorifico, data: WideString): RetornoConsultarAnimaisAbatidos;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := cnpjFrigorifico;
  Result := Objsoap.consultarAnimaisAbatidos(usuario, senha, cnpjFrigorifico, data);
end;

function TIntSoapSisbov.consultarDadosAnimal(const usuario, senha,
  numeroSisbov: WideString): RetornoConsultarDadosAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodAnimalSisbov := numeroSisbov;
  Result := Objsoap.consultarDadosAnimal(usuario, senha, numeroSisbov);
end;

function TIntSoapSisbov.desvincularProdutorPropriedade(const usuario,
  senha, cpfProdutor, cnpjProdutor: WideString;
  const idPropriedade: Int64): RetornoDesvincularProdutorPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.desvincularProdutorPropriedade(usuario, senha, cpfProdutor,
    cnpjProdutor, idPropriedade);
end;

function TIntSoapSisbov.desvincularPropriedadeProprietario(const usuario,
  senha, cpfProprietario, cnpjProprietario: WideString;
  const idPropriedade: Int64): RetornoDesvincularProprietarioPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProprietario, cnpjProprietario);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.desvincularPropriedadeProprietario(usuario, senha, cpfProprietario,
    cnpjProprietario, idPropriedade);
end;

function TIntSoapSisbov.incluirAnimal(const usuario, senha,
  dataIdentificacao, dataNascimento, numeroProvisorio,
  numeroDefinitivo: WideString; const idPropriedadeNascimento,
  idPropriedadeLocalizacao, idPropriedadeResponsavel: Int64;
  const numeroSisbov, codigoRaca: WideString;
  const tipoIdentificacao: Int64; const sexo, cnpjProdutor,
  cpfProdutor: WideString): RetornoIncluirAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedadeNascimento);
  FCodAnimalSisbov := numeroSisbov;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  Result := Objsoap.incluirAnimal(usuario, senha, dataIdentificacao, dataNascimento,
    numeroProvisorio, numeroDefinitivo, idPropriedadeNascimento, idPropriedadeLocalizacao,
    idPropriedadeResponsavel, numeroSisbov, codigoRaca, tipoIdentificacao, sexo, cnpjProdutor, cpfProdutor);
end;

{function TIntSoapSisbov.incluirAnimalNaoInventariado(const usuario, senha,
  cpfProdutor, cnpjProdutor: WideString; const idPropriedade: Int64;
  const numeroSisbov: WideString): RetornoIncluirAnimalNaoInventariado;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  FCodAnimalSisbov := numeroSisbov;
  Result := Objsoap.incluirAnimalNaoInventariado(usuario, senha, cpfProdutor, cnpjProdutor,
    idPropriedade, numeroSisbov);
end;
}

function TIntSoapSisbov.incluirProdutor(const usuario, senha, _razaoSocial,
  _cnpj, _nome, _telefone, _email, _cpf, _sexo, _logradouro, _bairro, _cep,
  _codMunicipio, _telefoneResidencial, _faxResidencial, _nrTelefoneContato,
  _nrFaxContato: WideString): RetornoIncluirProdutor;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(_cpf, _cnpj);
  Result := Objsoap.incluirProdutor(usuario, senha, _razaoSocial, _cnpj, _nome, _telefone,
    _email, _cpf, _sexo, _logradouro, _bairro, _cep, _codMunicipio, _telefoneResidencial, _faxResidencial,
    _nrTelefoneContato, _nrFaxContato);
end;

function TIntSoapSisbov.incluirPropriedade(const usuario, senha, _nirf,
  _incra: WideString; const _tipoPropriedade: Int64;
  const _nomePropriedade, _acessoFazenda: WideString;
  const _distanciaSedeMunicipio: Integer;
  const _orientacaoLatitude: WideString; const _grauLatitude,
  _minutoLatitude, _segundoLatitude: Integer;
  const _orientacaoLongitude: WideString; const _grauLongitude,
  _minutoLongitude, _segundoLongitude: Integer; const _area: Int64;
  const _logradouro, _bairro, _cep, _codMunicipio,
  _enderecoCorrespondenciaLogradouro, _enderecoCorrespondenciaBairro,
  _enderecoCorrespondenciaCep, _enderecoCorrespondenciaCodMunicipio,
  _telefoneResidencial, _faxResidencial, _nrTelefoneContato,
  _nrFaxContato: WideString): RetornoIncluirPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.incluirPropriedade(usuario, senha, _nirf, _incra, _tipoPropriedade,
    _nomePropriedade, _acessoFazenda, _distanciaSedeMunicipio, _orientacaoLatitude, _grauLatitude,
    _minutoLatitude, _segundoLatitude, _orientacaoLongitude, _grauLongitude, _minutoLongitude,
    _segundoLongitude, _area, _logradouro, _bairro, _cep, _codMunicipio, _enderecoCorrespondenciaLogradouro,
    _enderecoCorrespondenciaBairro, _enderecoCorrespondenciaCep, _enderecoCorrespondenciaCodMunicipio,
    _telefoneResidencial, _faxResidencial, _nrTelefoneContato, _nrFaxContato);
end;

function TIntSoapSisbov.incluirProprietario(const usuario, senha,
  _razaoSocial, _cnpj, _nome, _telefone, _email, _cpf, _sexo, _logradouro,
  _bairro, _cep, _codMunicipio: WideString): RetornoIncluirProprietario;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(_cpf, _cnpj);
  Result := Objsoap.incluirProprietario(usuario, senha, _razaoSocial, _cnpj, _nome,
    _telefone, _email, _cpf, _sexo, _logradouro, _bairro, _cep, _codMunicipio);
end;

function TIntSoapSisbov.incluirSupervisor(const usuario, senha, _nome,
  _telefone, _email, _cpf, _rg, _dataNascimento, _dataExpedicao,
  _OrgaoExpedidor, _ufExpedidor, _sexo, _logradouro, _bairro, _cep,
  _codMunicipio: WideString): RetornoIncluirSupervisor;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := _cpf;
  Result := Objsoap.incluirSupervisor(usuario, senha, _nome, _telefone, _email, _cpf, _rg,
    _dataNascimento, _dataExpedicao, _OrgaoExpedidor, _ufExpedidor, _sexo, _logradouro, _bairro, _cep,
    _codMunicipio);
end;

function TIntSoapSisbov.incluirVistoriaERAS(const usuario, senha,
  cpfSupervisor: WideString; const idPropriedade: Int64;
  const data: WideString): RetornoIncluirVistoriaERAS;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := cpfSupervisor;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.incluirVistoriaERAS(usuario, senha, cpfSupervisor, idPropriedade, data);
end;

function TIntSoapSisbov.informarDesligamentoAnimal(const usuario, senha,
  numeroSisbovAnimal: WideString;
  const tipoDesligamento: Int64): RetornoDesligamentoAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodAnimalSisbov := numeroSisbovAnimal;
  Result := Objsoap.informarDesligamentoAnimal(usuario, senha, numeroSisbovAnimal, tipoDesligamento);
end;

function TIntSoapSisbov.informarMorteAnimal(const usuario, senha,
  numeroSisbovAnimal, dataMorte: WideString; const codigoTipoMorte,
  codigoCausaMorte: Int64): RetornoMorteAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodAnimalSisbov := numeroSisbovAnimal;
  Result := Objsoap.informarMorteAnimal(usuario, senha, numeroSisbovAnimal, dataMorte,
    codigoTipoMorte, codigoCausaMorte);
end;

function TIntSoapSisbov.informarNotaFiscal(const usuario,
  senha: WideString; const numeroSolicitacao: Int64; const nrSerie, nrNota,
  dtNota: WideString): RetornoAlterarSolicitacaoNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := numeroSolicitacao;
  Result := Objsoap.informarNotaFiscal(usuario, senha, numeroSolicitacao, nrSerie,
    nrNota, dtNota);
end;

function TIntSoapSisbov.inventariarSolicitacaoNumeracao(const usuario,
  senha: WideString; const _numeroSolicitacao: Int64; const _cpfProdutor,
  _cnpjProdutor: WideString; const _idPropriedadeDestino,
  _tipoIdentificacao: Int64): RetornoInventarioSolicitacao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := _numeroSolicitacao;
  FCpfCnpjPessoaOrigem := CpfCnpj(_cpfProdutor, _cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(_idPropriedadeDestino);
  Result := Objsoap.inventariarSolicitacaoNumeracao(usuario, senha, _numeroSolicitacao, _cpfProdutor,
    _cnpjProdutor, _idPropriedadeDestino, _tipoIdentificacao);
end;


//function TIntSoapSisbov.inventariarAnimais(const usuario,
//  senha: WideString; const idPropriedade: Int64;
//  const numerosSisbov: ArrayOf_xsd_string): RetornoInventarioAnimal;
//var
//  Objsoap : WSSISBOV;
//  H : THerdomHTTPRIO;
//begin
//  H := THerdomHTTPRIO.Create(nil);
//  AtribuirParametrosHTTPRIO(H);
//  ObjSoap := H as WSSISBOV;

//  LimpaAtributos;
//  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(IdPropriedade);
//  Result := Objsoap.inventariarAnimais(usuario, senha, idPropriedade, numerosSisbov);
//end;

{function TIntSoapSisbov.solicitarInventarioAnimais(const usuario,
  senha: WideString; const idPropriedade: Int64;
  const quantidade: Integer; const numerosSisbov: ArrayOf_xsd_string): RetornoSolicitarInventarioAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(IdPropriedade);
  Result := Objsoap.solicitarInventarioAnimais(usuario, senha, idPropriedade, quantidade, numerosSisbov);
end;
}

{function TIntSoapSisbov.consultarInventarioAnimais(const usuario,
  senha: WideString; const idPropriedade: Int64): RetornoConsultarInventarioAnimal;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(IdPropriedade);
  Result := Objsoap.consultarInventarioAnimais(usuario, senha, idPropriedade);
end;
}

function TIntSoapSisbov.movimentarAnimal(const usuario: WideString; const senha: WideString;
  const dataValidade: WideString; const dataEmissao: WideString; const dataSaida: WideString;
  const dataChegada: WideString; const idPropriedadeOrigem: Int64; const idPropriedadeDestino: Int64;
  const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString; const cpfProdutorDestino: WideString;
  const cnpjProdutorDestino: WideString; const gtas: Array_Of_GtaDTO; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedadeOrigem);
  FCodPropriedadeRuralDestino := IdToCodPropriedadeRural(idPropriedadeDestino);
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutorOrigem, cnpjProdutorOrigem);
  FCpfCnpjPessoaDestino := CpfCnpj(cpfProdutorDestino, cnpjProdutorDestino);
  Result := Objsoap.movimentarAnimal(usuario, senha, dataValidade, dataEmissao, dataSaida,
    dataChegada, idPropriedadeOrigem, cpfProdutorOrigem, cnpjProdutorOrigem, idPropriedadeDestino,
    cpfProdutorDestino, cnpjProdutorDestino, gtas, numerosSISBOV);
end;

function  TIntSoapSisbov.movimentarAnimalNaoErasPraEras(const usuario, senha,
  dataValidade, dataEmissao, dataSaida, dataChegada, codigo, nirf, incra: WideString;
  const idPropriedadeDestino: Int64; const cpfProdutorOrigem, cnpjProdutorOrigem,
  cpfProdutorDestino, cnpjProdutorDestino: WideString; const gtas: Array_Of_GtaDTO;
  const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao;
//var
//  Objsoap : WSSISBOV;
//  H : THerdomHTTPRIO;
begin
  raise Exception.Create('De acordo com a documentação e atualização da WebService de 04/04/2008, o método "movimentarAnimalNaoErasPraEras" não está mais disponível.');
{  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutorOrigem, cnpjProdutorOrigem);
  FCpfCnpjPessoaDestino := CpfCnpj(cpfProdutorDestino, cnpjProdutorDestino);
  Result := Objsoap.movimentarAnimalNaoErasPraEras(usuario, senha,
    dataValidade, dataEmissao, dataSaida, dataChegada, codigo, nirf, incra,
    idPropriedadeDestino, cpfProdutorOrigem, cnpjProdutorOrigem,
    cpfProdutorDestino, cnpjProdutorDestino, gtas, numerosSISBOV);
  }
end;

function  TIntSoapSisbov.migrarAnimalNaoInventariado(const usuario, senha, codigo, nirf, incra, cpfProdutorOrigem,
  cnpjProdutorOrigem: WideString; const idPropriedadeDestino: Int64; const cpfProdutorDestino, cnpjProdutorDestino: WideString;
  const justificativa: Integer; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao;
//var
//  Objsoap : WSSISBOV;
//  H : THerdomHTTPRIO;
begin
  raise Exception.Create('De acordo com a documentação e atualização da WebService de 04/04/2008, o método "migrarAnimalNaoInventariado" não está mais disponível.');
{  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutorOrigem, cnpjProdutorOrigem);
  FCpfCnpjPessoaDestino := CpfCnpj(cpfProdutorDestino, cnpjProdutorDestino);
  Result := Objsoap.migrarAnimalNaoInventariado(usuario, senha, codigo, nirf, incra,
    cpfProdutorOrigem, cnpjProdutorOrigem, idPropriedadeDestino, cpfProdutorDestino,
    cnpjProdutorDestino, justificativa, numerosSISBOV);
  }
end;

function TIntSoapSisbov.movimentarAnimalParaFrigorifico(const usuario: WideString;
  const senha: WideString; const dataValidade: WideString; const dataEmissao: WideString;
  const dataSaida: WideString; const dataChegada: WideString; const idPropriedadeOrigem: Int64;
  const cnpjFrigorifico: WideString; const cpfProdutorOrigem: WideString; const cnpjProdutorOrigem: WideString;
  const gtas: Array_Of_GtaDTO; const numerosSISBOV: ArrayOf_xsd_string): RetornoInformarMovimentacao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedadeOrigem);
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutorOrigem, cnpjProdutorOrigem);
  FCpfCnpjPessoaDestino := cnpjFrigorifico;
  Result := Objsoap.movimentarAnimalParaFrigorifico(usuario, senha, dataValidade, dataEmissao,
    dataSaida, dataChegada, idPropriedadeOrigem, cnpjFrigorifico, cpfProdutorOrigem, cnpjProdutorOrigem,
    gtas, numerosSISBOV);
end;

function TIntSoapSisbov.recuperarNumeracao(const usuario,
  senha: WideString;
  const numeroSolicitacao: Int64): RetornoRecuperarNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := numeroSolicitacao;
  Result := Objsoap.recuperarNumeracao(usuario, senha, numeroSolicitacao);
end;

function TIntSoapSisbov.recuperarTabela(const usuario, senha: WideString;
  const idTabela: Int64): RetornoRecuperarTabela;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.recuperarTabela(usuario, senha, idTabela);
end;

function TIntSoapSisbov.recuperarTabelaMunicipios(const usuario, senha,
  uf: WideString): RetornoRecuperarTabela;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.recuperarTabelaMunicipios(usuario, senha, uf);
end;

function TIntSoapSisbov.solicitarNumeracao(const usuario, senha,
  cnpjFabrica, cpfProdutor, cnpjProdutor: WideString; const idPropriedade,
  qtdeSolicitada, tipoIdentificacao: Int64): RetornoSolicitacaoNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.solicitarNumeracao(usuario, senha, cnpjFabrica, cpfProdutor,
    cnpjProdutor, idPropriedade, qtdeSolicitada, tipoIdentificacao);
end;

function TIntSoapSisbov.vincularProdutorPropriedade(const usuario, senha,
  cpfProdutor, cnpjProdutor: WideString; const idPropriedade: Int64;
  const IEProdutor, ufIE: WideString;
  const tipoProdutor: Int64): RetornoVincularProdutorPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.vincularProdutorPropriedade(usuario, senha, cpfProdutor, cnpjProdutor,
    idPropriedade, IEProdutor, ufIE, tipoProdutor);
end;

function TIntSoapSisbov.vincularProprietarioPropriedade(const usuario,
  senha, cpfProprietario, cnpjProprietario: WideString;
  const idPropriedade,
  situacaoFundiaria: Int64): RetornoVincularProprietarioPropriedade;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProprietario, cnpjProprietario);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.vincularProprietarioPropriedade(usuario, senha, cpfProprietario,
    cnpjProprietario, idPropriedade, situacaoFundiaria);
end;

function  TIntSoapSisbov.excluirVistoria(const usuario: WideString; const
                                  senha: WideString;
                                  const idPropriedade: Int64): RetornoExcluirVistoria;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.excluirVistoria(usuario, senha, idPropriedade);
end;

function  TIntSoapSisbov.alterarIE(const usuario: WideString; const senha: WideString;
                                   const cpf: WideString; const cnpj: WideString;
                                   const idPropriedade: Int64;
                                   const numeroIE: WideString): RetornoAlterarIE;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  Result := Objsoap.alterarIE(usuario, senha, cpf, cnpj, IntToStr(idPropriedade), numeroIE);
end;

procedure TIntSoapSisbov.AtribuirParametrosHTTPRIO(var H: THerdomHTTPRIO);
begin

  H.URL := ValorParametro(117);
  H.HTTPWebNode.Proxy:= ValorParametro(120);
  H.HTTPWebNode.UserName:= Descriptografar(ValorParametro(121));
  H.HTTPWebNode.Password:= Descriptografar(ValorParametro(122));
  H.HTTPWebNode.MaxSinglePostSize := $1000000;
//  H.HTTPWebNode.ConnectTimeout := 1000000000;
//  H.HTTPWebNode.SendTimeout    := 1000000000;
//  H.HTTPWebNode.ReceiveTimeout := 1000000000;
  H.OnBeforeExecute := HTTPRIO1BeforeExecute;
  H.OnAfterExecute := HTTPRIO1AfterExecute;
end;

function TIntSoapSisbov.cadastrarEmail(const usuario, senha,
  email: WideString): RetornoCadastrarEmail;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.cadastrarEmail(usuario, senha, email);
end;

function TIntSoapSisbov.consultarEmail(const usuario,
  senha: WideString): RetornoConsultarEmail;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.consultarEmail(usuario, senha);
end;

function TIntSoapSisbov.consultaSolicitacaoNumeracao(const usuario,
  senha: WideString;
  const numeroSolicitacao: Int64): RetornoConsultaSolicitacaoNumeracao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  Result := Objsoap.consultaSolicitacaoNumeracao(usuario, senha, numeroSolicitacao);
end;

function TIntSoapSisbov.solicitarNumeracaoReimpressao(const usuario: WideString; senha: WideString;
  cnpjFabrica, cpfProdutor, cnpjProdutor: WideString;
  const idPropriedade: Int64; const qtd: Integer;
  const numero: Array_Of_NumeroReimpressaoDTO): RetornoSolicitacaoNumeracaoReimpressao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FCpfCnpjPessoaOrigem := CpfCnpj(cpfProdutor, cnpjProdutor);
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);

  Result := Objsoap.solicitarNumeracaoReimpressao(usuario, senha, cnpjFabrica, cpfProdutor,
    cnpjProdutor, idPropriedade, qtd, numero);
end;

function TIntSoapSisbov.consultarNumeracaoReimpressao(const usuario,
  senha: WideString;
  const numeroSolicitacao: Int64): RetornoConsultarNumeracaoReimpressao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;

  LimpaAtributos;
  FNroSolicitacaoSisbov := numeroSolicitacao;
  Result := Objsoap.consultarNumeracaoReimpressao(usuario, senha, numeroSolicitacao);
end;

function TIntSoapSisbov.consultarSuspensao(const usuario,
  senha: WideString;
  const idPropriedade: Int64): RetornoConsultarSuspensao;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.consultarSuspensao(usuario,senha,idPropriedade);
end;

function TIntSoapSisbov.suspenderPropriedade(const usuario,
  senha: WideString; const idPropriedade: Int64; const idMotivo: Integer;
  const obs: WideString): RetornoWsSISBOV;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.suspenderPropriedade(usuario,senha,idPropriedade,idMotivo,obs);
end;

function TIntSoapSisbov.iniciarVistoria(const usuario, senha: WideString;
  const idPropriedade: Int64; const dataAgendamento,
  cpfSupervisor: WideString): RetornoCheckListVistoria;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.iniciarVistoria(usuario,senha, idPropriedade, dataAgendamento,cpfSupervisor);
end;

function TIntSoapSisbov.reagendarVistoria(const usuario, senha: WideString;
  const idPropriedade: Int64; const dataReagendamento, cpfSupervisor,
  justificativa: WideString): RetornoCheckListVistoria;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.reagendarVistoria(usuario,senha, idPropriedade, dataReagendamento,cpfSupervisor,justificativa);
end;

function TIntSoapSisbov.lancarVistoria(const usuario, senha: WideString;
  const idPropriedade: Int64; const dataVistoria,
  cpfSupervisor: WideString;
  const resposta: CheckListItemRespostaDTO): RetornoWsSISBOV;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.lancarVistoria(usuario,senha, idPropriedade, dataVistoria,cpfSupervisor,resposta);
end;

function TIntSoapSisbov.finalizarVistoria(const usuario, senha: WideString;
  const idPropriedade: Int64; const dataAgendamento: WideString;
  const cancelada: Boolean): RetornoWsSISBOV;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.finalizarVistoria(usuario, senha ,idPropriedade,dataAgendamento,cancelada);
end;

function TIntSoapSisbov.emitirParecerVistoriaRT(const usuario,
  senha: WideString; const idPropriedade: Int64; const dataAgendamento,
  parecer, cpfResponsavelTecnico: WideString): RetornoWsSISBOV;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.emitirParecerVistoriaRT(usuario, senha ,idPropriedade,dataAgendamento,parecer,cpfResponsavelTecnico);
end;

function TIntSoapSisbov.informarPeriodoConfinamento(const usuario,
  senha: WideString; const idPropriedade: Int64;
  const dataConfinamentoInicial, dataConfinamentoFinal: WideString;
  const cancelada: Boolean): RetornoWsSISBOV;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.informarPeriodoConfinamento(usuario,senha,idPropriedade,dataConfinamentoInicial,dataConfinamentoFinal,cancelada);
end;

function TIntSoapSisbov.solicitarAlteracaoPosse(const usuario, senha,
  idPropriedadeOrigem, cpfProdutorOrigem, cpfProdutorDestino: WideString;
  const motivoSolicitacao: Int64; const justificativa: WideString;
  const tipoEnvio, qtdeAnimais: Int64;
  const numeracaoEnvio: widestring): RetornoAlteracaoPosse;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(strtoint(idPropriedadeOrigem));
  result  :=  Objsoap.solicitarAlteracaoPosse(usuario, senha,idPropriedadeOrigem, cpfProdutorOrigem, cpfProdutorDestino,
                                              motivoSolicitacao,justificativa,tipoEnvio, qtdeAnimais,numeracaoEnvio);

end;

function TIntSoapSisbov.recuperarCheckListVistoria(const usuario,
  senha: WideString; const idPropriedade: Int64;
  const dataAgendamento: WideString): RetornoCheckListVistoria;
var
  Objsoap : WSSISBOV;
  H       : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.recuperarCheckListVistoria(usuario, senha ,idPropriedade,dataAgendamento);
end;

function TIntSoapSisbov.informarAjusteRebanho(const usuario,
  senha: WideString; const idPropriedade: Int64;
  const cpfProprietarioPropriedade,
  cnpjProprietarioPropriedade: WideString): RetornoInformarAjusteRebanho;
var
  Objsoap : WSSISBOV;
  H : THerdomHTTPRIO;
begin
  H := THerdomHTTPRIO.Create(nil);
  AtribuirParametrosHTTPRIO(H);
  ObjSoap := H as WSSISBOV;
  LimpaAtributos;
  FCodPropriedadeRuralOrigem := IdToCodPropriedadeRural(idPropriedade);
  result  :=  Objsoap.informarAjusteRebanho(usuario, senha,idPropriedade, cpfProprietarioPropriedade,
                                            cnpjProprietarioPropriedade);
end;

end.
