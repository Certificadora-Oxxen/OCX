unit XHerdom_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 22/07/2024 22:25:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: \\Herdom\d\Fontes\ActiveX\Ocx Importação xHerdom\XHerdom.tlb (1)
// LIBID: {96B07977-8E10-4B4A-8C22-E1CFC43527E6}
// LCID: 0
// Helpfile: 
// HelpString: XHerdom Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  XHerdomMajorVersion = 1;
  XHerdomMinorVersion = 0;

  LIBID_XHerdom: TGUID = '{96B07977-8E10-4B4A-8C22-E1CFC43527E6}';

  IID_IImportacaoExcel: TGUID = '{963695B0-7666-4677-9C17-25631AACD315}';
  CLASS_ImportacaoExcel: TGUID = '{88296D08-4C3C-4A79-A26B-0079CAC77899}';
  IID_IErroImportacao: TGUID = '{8206A82C-BF2E-403F-BBAC-5CE30611A055}';
  CLASS_ErroImportacao: TGUID = '{920B97A2-2516-4B23-8B2E-8C31403DDB3A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IImportacaoExcel = interface;
  IImportacaoExcelDisp = dispinterface;
  IErroImportacao = interface;
  IErroImportacaoDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImportacaoExcel = IImportacaoExcel;
  ErroImportacao = IErroImportacao;


// *********************************************************************//
// Interface: IImportacaoExcel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {963695B0-7666-4677-9C17-25631AACD315}
// *********************************************************************//
  IImportacaoExcel = interface(IDispatch)
    ['{963695B0-7666-4677-9C17-25631AACD315}']
    function Get_IndParametrosCarregados: Integer; safecall;
    function Get_DtaArquivoParametros: TDateTime; safecall;
    function Get_NomCertificadora: WideString; safecall;
    function Get_NumCNPJCertificadora: WideString; safecall;
    function CarregarParametros(const NomArquivoParametros: WideString): Integer; safecall;
    function Inicializar(const NomArquivoDados: WideString; IndLimparArquivo: Integer; 
                         const CodNaturezaProdutor: WideString; const NumCNPJCPFProdutor: WideString): Integer; safecall;
    function InserirReprodutorMultiplo(const SglFazendaManejo: WideString; 
                                       const CodRMManejo: WideString; const SglEspecie: WideString; 
                                       const TxtObservacao: WideString): Integer; safecall;
    function InserirAnimal(const SglFazendaManejo: WideString; const CodAnimalManejo: WideString; 
                           const CodAnimalCertificadora: WideString; 
                           const CodAnimalSisbov: WideString; const SglSituacaoSisbov: WideString; 
                           DtaIdentificacaoSisbov: TDateTime; 
                           const NumImovelIdentificacao: WideString; 
                           const SglFazendaIdentificacao: WideString; DtaNascimento: TDateTime; 
                           const NumImovelNascimento: WideString; 
                           const SglFazendaNascimento: WideString; DtaCompra: TDateTime; 
                           const NomAnimal: WideString; const DesApelido: WideString; 
                           const SglAssociacaoRaca: WideString; const SglGrauSangue: WideString; 
                           const NumRGD: WideString; const NumTransponder: WideString; 
                           const SglTipoIdentificador1: WideString; 
                           const SglPosicaoIdentificador1: WideString; 
                           const SglTipoIdentificador2: WideString; 
                           const SglPosicaoIdentificador2: WideString; 
                           const SglTipoIdentificador3: WideString; 
                           const SglPosicaoIdentificador3: WideString; 
                           const SglTipoIdentificador4: WideString; 
                           const SglPosicaoIdentificador4: WideString; 
                           const SglAptidao: WideString; const SglRaca: WideString; 
                           const SglPelagem: WideString; const IndSexo: WideString; 
                           const SglTipoOrigem: WideString; const SglFazendaPai: WideString; 
                           const CodManejoPai: WideString; const SglFazendaMae: WideString; 
                           const CodManejoMae: WideString; const SglFazendaReceptor: WideString; 
                           const CodManejoReceptor: WideString; 
                           const IndAnimalCastrado: WideString; 
                           const SglRegimeAlimentar: WideString; 
                           const SglCategoriaAnimal: WideString; 
                           const SglFazendaCorrente: WideString; 
                           const SglLocalCorrente: WideString; const SglLoteCorrente: WideString; 
                           const TxtObservacao: WideString; const NumGTA: WideString; 
                           DtaEmissaoGTA: TDateTime; NumNotaFiscal: Integer; 
                           const NumCNPJCPFTecnico: WideString; const IndReservado: WideString): Integer; safecall;
    function AlterarAnimal(const SglFazendaManejo: WideString; const CodAnimalManejo: WideString; 
                           const NomColunaAlterar: WideString; const ValColunaAlterar1: WideString; 
                           ValColunaAlterar2: OleVariant): Integer; safecall;
    function AdicionarTouroRM(const SglFazendaManejo: WideString; const CodRMManejo: WideString; 
                              const SglFazendaAnimal: WideString; const CodAnimalManejo: WideString): Integer; safecall;
    function InserirEventoMudRegimeAlimentar(const CodIdentificadorEvento: WideString; 
                                             DtaInicio: TDateTime; DtaFim: TDateTime; 
                                             const SglFazenda: WideString; 
                                             const TxtObservacao: WideString; 
                                             const SglAptidao: WideString; 
                                             const SglRegimeAlimentarOrigem: WideString; 
                                             const SglRegimeAlimentarDestino: WideString; 
                                             const CodFManejo: WideString; 
                                             const CodManejo: WideString): Integer; safecall;
    function InserirEventoDesmame(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                  DtaFim: TDateTime; const SglFazenda: WideString; 
                                  const TxtObservacao: WideString; const SglAptidao: WideString; 
                                  const SglRegimeAlimentarDestino: WideString; 
                                  const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoMudCategoria(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const SglFazenda: WideString; 
                                       const TxtObservacao: WideString; 
                                       const SglAptidao: WideString; 
                                       const SglCategoriaOrigem: WideString; 
                                       const SglCategoriaDestino: WideString; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoSelecaoReproducao(const CodIdentificadorEvento: WideString; 
                                            DtaInicio: TDateTime; DtaFim: TDateTime; 
                                            const SglFazenda: WideString; 
                                            const TxtObservacao: WideString; 
                                            const CodFManejo: WideString; 
                                            const CodManejo: WideString): Integer; safecall;
    function InserirEventoCastracao(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                    DtaFim: TDateTime; const SglFazenda: WideString; 
                                    const TxtObservacao: WideString; const CodFManejo: WideString; 
                                    const CodManejo: WideString): Integer; safecall;
    function InserirEventoTransferencia(const CodIdentificadorEvento: WideString; 
                                        DtaInicio: TDateTime; DtaFim: TDateTime; 
                                        const TxtObservacao: WideString; 
                                        const SglAptidao: WideString; 
                                        const SglTipoLugarOrigem: WideString; 
                                        const SglFazendaOrigem: WideString; 
                                        const NumImovelOrigem: WideString; 
                                        const NumCNPJCPFOrigem: WideString; 
                                        const SglTipoLugarDestino: WideString; 
                                        const SglFazendaDestino: WideString; 
                                        const SglLocalDestino: WideString; 
                                        const SglLoteDestino: WideString; 
                                        const NumImovelDestino: WideString; 
                                        const NumCNPJCPFDestino: WideString; 
                                        const SglRegimeAlimentarMamando: WideString; 
                                        const SglRegimeAlimentarDesmamado: WideString; 
                                        const NumGTA: WideString; DtaEmissaoGTA: TDateTime): Integer; safecall;
    function InserirEventoVendaCriador(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const SglFazenda: WideString; 
                                       const TxtObservacao: WideString; 
                                       const NumImovelReceitaFederal: WideString; 
                                       const NumCNPJCPFCriador: WideString; 
                                       const NumGTA: WideString; DtaEmissaoGTA: TDateTime; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoVendaFrigorifico(const CodIdentificadorEvento: WideString; 
                                           DtaInicio: TDateTime; DtaFim: TDateTime; 
                                           const SglFazenda: WideString; 
                                           const TxtObservacao: WideString; 
                                           const NumCNPJCPFFrigorifico: WideString; 
                                           const NumGTA: WideString; DtaEmissaoGTA: TDateTime; 
                                           const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoDesaparecimento(const CodIdentificadorEvento: WideString; 
                                          DtaInicio: TDateTime; DtaFim: TDateTime; 
                                          const SglFazenda: WideString; 
                                          const TxtObservacao: WideString; 
                                          const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoMorte(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                DtaFim: TDateTime; const SglFazenda: WideString; 
                                const TxtObservacao: WideString; const SglTipoMorte: WideString; 
                                const SglCausaMorte: WideString; const CodFManejo: WideString; 
                                const CodManejo: WideString): Integer; safecall;
    function InserirEventoPesagem(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                  DtaFim: TDateTime; const SglFazenda: WideString; 
                                  const TxtObservacao: WideString; const CodFManejo: WideString; 
                                  const CodManejo: WideString; Peso: Double): Integer; safecall;
    function AplicarEventoAnimal(const CodIdentificadorEvento: WideString; 
                                 const SglFazendaManejo: WideString; 
                                 const CodAnimalManejo: WideString; QtdPesoAnimal: Double; 
                                 const IndVacaPrenha: WideString; const IndTouroApto: WideString): Integer; safecall;
    function Get_ErroImportacao: IErroImportacao; safecall;
    function Finalizar(IndExcluirArquivo: Integer): Integer; safecall;
    function Get_IndGerarComentarios: Integer; safecall;
    procedure Set_IndGerarComentarios(Value: Integer); safecall;
    function InserirEventoMudancaLote(const CodIdentificadorEvento: WideString; 
                                      DtaInicio: TDateTime; DtaFim: TDateTime; 
                                      const TxtObservacao: WideString; 
                                      const SglFazenda: WideString; 
                                      const SglLoteDestino: WideString; 
                                      const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function InserirEventoMudancaLocal(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const TxtObservacao: WideString; 
                                       const SglAptidao: WideString; const SglFazenda: WideString; 
                                       const SglLocalDestino: WideString; 
                                       const SglRegimeAlimentarMamando: WideString; 
                                       const SglRegimeAlimentarDesmamado: WideString; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; safecall;
    function Pesquisar(CodTabela: Integer): Integer; safecall;
    function IrAoProximo: Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_SglEntidade: WideString; safecall;
    function Get_DesEntidade: WideString; safecall;
    function DefinirComposicaoRacial(const SglFazendaManejo: WideString; 
                                     const CodAnimalManejo: WideString; const SglRaca: WideString; 
                                     QtdComposicaoRacial: Double): Integer; safecall;
    function MostrarDialogAbrir(const NomeArquivo: WideString; const Caption: WideString): WideString; safecall;
    function MostrarDialogSalvar(const NomeArquivo: WideString; const Caption: WideString): WideString; safecall;
    function MostrarFormProgresso(const Caption: WideString; const TxtInfo1: WideString; 
                                  const TxtInfo2: WideString; IndBarraProgresso: Integer; 
                                  ValMinBarraProgresso: Integer; ValMaxBarraProgresso: Integer): Integer; safecall;
    function AtualizarFormProgresso(IndTipoInfo: Integer; ValInfo: OleVariant): Integer; safecall;
    function FecharFormProgresso: Integer; safecall;
    function Get_SglEntidadeRelacionada: WideString; safecall;
    function Get_DesEntidadeRelacionada: WideString; safecall;
    function PesquisaRelacionamentos(CodTabelaRelacionamentos: Integer; CodTabelaOrigem: Integer; 
                                     const SglEntidadeOrigem: WideString): Integer; safecall;
    function InserirEventoEstacaoMonta(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const TxtObservacao: WideString; 
                                       const SglFazenda: WideString; 
                                       const SglEstacaoMonta: WideString; 
                                       const DesEstacaoMonta: WideString): Integer; safecall;
    function InserirEventoCoberturaRegimePasto(const CodIdentificadorEvento: WideString; 
                                               DtaInicio: TDateTime; DtaFim: TDateTime; 
                                               const TxtObservacao: WideString; 
                                               const SglFazenda: WideString; 
                                               const SglFazendaManejoAnimalRM: WideString; 
                                               const CodAnimalManejoAnimalRM: WideString): Integer; safecall;
    function InserirEventoDiagnosticoPrenhez(const CodIdentificadorEvento: WideString; 
                                             DtaInicio: TDateTime; DtaFim: TDateTime; 
                                             const TxtObservacao: WideString; 
                                             const SglFazenda: WideString): Integer; safecall;
    function InserirEventoExameAndrologico(const CodIdentificadorEvento: WideString; 
                                           DtaInicio: TDateTime; DtaFim: TDateTime; 
                                           const TxtObservacao: WideString; 
                                           const SglFazenda: WideString): Integer; safecall;
    function InserirEventoCoberturaInseminacaoArtificial(const CodIdentificadorEvento: WideString; 
                                                         DtaInicio: TDateTime; DtaFim: TDateTime; 
                                                         const TxtObservacao: WideString; 
                                                         const SglFazenda: WideString; 
                                                         HraEvento: TDateTime; 
                                                         const SglFazendaManejoTouro: WideString; 
                                                         const CodAnimalManejoTouro: WideString; 
                                                         const NumPartida: WideString; 
                                                         const SglFazendaManejoFemea: WideString; 
                                                         const CodAnimalManejoFemea: WideString; 
                                                         QtdDoses: Integer; 
                                                         const NumCNPJCPFInseminador: WideString): Integer; safecall;
    function InserirEventoCoberturaMontaControlada(const CodIdentificadorEvento: WideString; 
                                                   DtaInicio: TDateTime; DtaFim: TDateTime; 
                                                   const TxtObservacao: WideString; 
                                                   const SglFazenda: WideString; 
                                                   const SglFazendaManejoTouro: WideString; 
                                                   const CodAnimalManejoTouro: WideString; 
                                                   const SglFazendaManejoFemea: WideString; 
                                                   const CodAnimalManejoFemea: WideString): Integer; safecall;
    function InserirAnimalNaoEspecificado(const CodAnimalSisbov: WideString; 
                                          const IndSexo: WideString; const SglAptidao: WideString; 
                                          const SglRaca: WideString; DtaNascimento: TDateTime; 
                                          const SglTipoIdentificador1: WideString; 
                                          const SglPosicaoIdentificador1: WideString; 
                                          const SglTipoIdentificador2: WideString; 
                                          const SglPosicaoIdentificador2: WideString; 
                                          DtaIdentificacaoSisbov: TDateTime; 
                                          const SglFazendaIdentificacao: WideString; 
                                          const NumCNPJCPFTecnico: WideString; 
                                          const IndEfetivar: WideString): Integer; safecall;
    function InserirEventoAvaliacao(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                    DtaFim: TDateTime; const CodTipoAvaliacao: WideString; 
                                    const CodFazendaManejo: WideString; 
                                    const CodAnimalManejo: WideString; 
                                    const SglFazenda: WideString; 
                                    const CodTipoCaracteristica: WideString; 
                                    const ValorAvaliacao: WideString; 
                                    const TxtObservacao: WideString): Integer; safecall;
    function InserirInventarioAnimal(const SglFazenda: WideString; const CodAnimalSisbov: WideString): Integer; safecall;
    property IndParametrosCarregados: Integer read Get_IndParametrosCarregados;
    property DtaArquivoParametros: TDateTime read Get_DtaArquivoParametros;
    property NomCertificadora: WideString read Get_NomCertificadora;
    property NumCNPJCertificadora: WideString read Get_NumCNPJCertificadora;
    property ErroImportacao: IErroImportacao read Get_ErroImportacao;
    property IndGerarComentarios: Integer read Get_IndGerarComentarios write Set_IndGerarComentarios;
    property SglEntidade: WideString read Get_SglEntidade;
    property DesEntidade: WideString read Get_DesEntidade;
    property SglEntidadeRelacionada: WideString read Get_SglEntidadeRelacionada;
    property DesEntidadeRelacionada: WideString read Get_DesEntidadeRelacionada;
  end;

// *********************************************************************//
// DispIntf:  IImportacaoExcelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {963695B0-7666-4677-9C17-25631AACD315}
// *********************************************************************//
  IImportacaoExcelDisp = dispinterface
    ['{963695B0-7666-4677-9C17-25631AACD315}']
    property IndParametrosCarregados: Integer readonly dispid 1;
    property DtaArquivoParametros: TDateTime readonly dispid 2;
    property NomCertificadora: WideString readonly dispid 3;
    property NumCNPJCertificadora: WideString readonly dispid 4;
    function CarregarParametros(const NomArquivoParametros: WideString): Integer; dispid 5;
    function Inicializar(const NomArquivoDados: WideString; IndLimparArquivo: Integer; 
                         const CodNaturezaProdutor: WideString; const NumCNPJCPFProdutor: WideString): Integer; dispid 6;
    function InserirReprodutorMultiplo(const SglFazendaManejo: WideString; 
                                       const CodRMManejo: WideString; const SglEspecie: WideString; 
                                       const TxtObservacao: WideString): Integer; dispid 7;
    function InserirAnimal(const SglFazendaManejo: WideString; const CodAnimalManejo: WideString; 
                           const CodAnimalCertificadora: WideString; 
                           const CodAnimalSisbov: WideString; const SglSituacaoSisbov: WideString; 
                           DtaIdentificacaoSisbov: TDateTime; 
                           const NumImovelIdentificacao: WideString; 
                           const SglFazendaIdentificacao: WideString; DtaNascimento: TDateTime; 
                           const NumImovelNascimento: WideString; 
                           const SglFazendaNascimento: WideString; DtaCompra: TDateTime; 
                           const NomAnimal: WideString; const DesApelido: WideString; 
                           const SglAssociacaoRaca: WideString; const SglGrauSangue: WideString; 
                           const NumRGD: WideString; const NumTransponder: WideString; 
                           const SglTipoIdentificador1: WideString; 
                           const SglPosicaoIdentificador1: WideString; 
                           const SglTipoIdentificador2: WideString; 
                           const SglPosicaoIdentificador2: WideString; 
                           const SglTipoIdentificador3: WideString; 
                           const SglPosicaoIdentificador3: WideString; 
                           const SglTipoIdentificador4: WideString; 
                           const SglPosicaoIdentificador4: WideString; 
                           const SglAptidao: WideString; const SglRaca: WideString; 
                           const SglPelagem: WideString; const IndSexo: WideString; 
                           const SglTipoOrigem: WideString; const SglFazendaPai: WideString; 
                           const CodManejoPai: WideString; const SglFazendaMae: WideString; 
                           const CodManejoMae: WideString; const SglFazendaReceptor: WideString; 
                           const CodManejoReceptor: WideString; 
                           const IndAnimalCastrado: WideString; 
                           const SglRegimeAlimentar: WideString; 
                           const SglCategoriaAnimal: WideString; 
                           const SglFazendaCorrente: WideString; 
                           const SglLocalCorrente: WideString; const SglLoteCorrente: WideString; 
                           const TxtObservacao: WideString; const NumGTA: WideString; 
                           DtaEmissaoGTA: TDateTime; NumNotaFiscal: Integer; 
                           const NumCNPJCPFTecnico: WideString; const IndReservado: WideString): Integer; dispid 8;
    function AlterarAnimal(const SglFazendaManejo: WideString; const CodAnimalManejo: WideString; 
                           const NomColunaAlterar: WideString; const ValColunaAlterar1: WideString; 
                           ValColunaAlterar2: OleVariant): Integer; dispid 9;
    function AdicionarTouroRM(const SglFazendaManejo: WideString; const CodRMManejo: WideString; 
                              const SglFazendaAnimal: WideString; const CodAnimalManejo: WideString): Integer; dispid 10;
    function InserirEventoMudRegimeAlimentar(const CodIdentificadorEvento: WideString; 
                                             DtaInicio: TDateTime; DtaFim: TDateTime; 
                                             const SglFazenda: WideString; 
                                             const TxtObservacao: WideString; 
                                             const SglAptidao: WideString; 
                                             const SglRegimeAlimentarOrigem: WideString; 
                                             const SglRegimeAlimentarDestino: WideString; 
                                             const CodFManejo: WideString; 
                                             const CodManejo: WideString): Integer; dispid 11;
    function InserirEventoDesmame(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                  DtaFim: TDateTime; const SglFazenda: WideString; 
                                  const TxtObservacao: WideString; const SglAptidao: WideString; 
                                  const SglRegimeAlimentarDestino: WideString; 
                                  const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 12;
    function InserirEventoMudCategoria(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const SglFazenda: WideString; 
                                       const TxtObservacao: WideString; 
                                       const SglAptidao: WideString; 
                                       const SglCategoriaOrigem: WideString; 
                                       const SglCategoriaDestino: WideString; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 13;
    function InserirEventoSelecaoReproducao(const CodIdentificadorEvento: WideString; 
                                            DtaInicio: TDateTime; DtaFim: TDateTime; 
                                            const SglFazenda: WideString; 
                                            const TxtObservacao: WideString; 
                                            const CodFManejo: WideString; 
                                            const CodManejo: WideString): Integer; dispid 14;
    function InserirEventoCastracao(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                    DtaFim: TDateTime; const SglFazenda: WideString; 
                                    const TxtObservacao: WideString; const CodFManejo: WideString; 
                                    const CodManejo: WideString): Integer; dispid 15;
    function InserirEventoTransferencia(const CodIdentificadorEvento: WideString; 
                                        DtaInicio: TDateTime; DtaFim: TDateTime; 
                                        const TxtObservacao: WideString; 
                                        const SglAptidao: WideString; 
                                        const SglTipoLugarOrigem: WideString; 
                                        const SglFazendaOrigem: WideString; 
                                        const NumImovelOrigem: WideString; 
                                        const NumCNPJCPFOrigem: WideString; 
                                        const SglTipoLugarDestino: WideString; 
                                        const SglFazendaDestino: WideString; 
                                        const SglLocalDestino: WideString; 
                                        const SglLoteDestino: WideString; 
                                        const NumImovelDestino: WideString; 
                                        const NumCNPJCPFDestino: WideString; 
                                        const SglRegimeAlimentarMamando: WideString; 
                                        const SglRegimeAlimentarDesmamado: WideString; 
                                        const NumGTA: WideString; DtaEmissaoGTA: TDateTime): Integer; dispid 16;
    function InserirEventoVendaCriador(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const SglFazenda: WideString; 
                                       const TxtObservacao: WideString; 
                                       const NumImovelReceitaFederal: WideString; 
                                       const NumCNPJCPFCriador: WideString; 
                                       const NumGTA: WideString; DtaEmissaoGTA: TDateTime; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 17;
    function InserirEventoVendaFrigorifico(const CodIdentificadorEvento: WideString; 
                                           DtaInicio: TDateTime; DtaFim: TDateTime; 
                                           const SglFazenda: WideString; 
                                           const TxtObservacao: WideString; 
                                           const NumCNPJCPFFrigorifico: WideString; 
                                           const NumGTA: WideString; DtaEmissaoGTA: TDateTime; 
                                           const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 18;
    function InserirEventoDesaparecimento(const CodIdentificadorEvento: WideString; 
                                          DtaInicio: TDateTime; DtaFim: TDateTime; 
                                          const SglFazenda: WideString; 
                                          const TxtObservacao: WideString; 
                                          const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 19;
    function InserirEventoMorte(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                DtaFim: TDateTime; const SglFazenda: WideString; 
                                const TxtObservacao: WideString; const SglTipoMorte: WideString; 
                                const SglCausaMorte: WideString; const CodFManejo: WideString; 
                                const CodManejo: WideString): Integer; dispid 20;
    function InserirEventoPesagem(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                  DtaFim: TDateTime; const SglFazenda: WideString; 
                                  const TxtObservacao: WideString; const CodFManejo: WideString; 
                                  const CodManejo: WideString; Peso: Double): Integer; dispid 21;
    function AplicarEventoAnimal(const CodIdentificadorEvento: WideString; 
                                 const SglFazendaManejo: WideString; 
                                 const CodAnimalManejo: WideString; QtdPesoAnimal: Double; 
                                 const IndVacaPrenha: WideString; const IndTouroApto: WideString): Integer; dispid 22;
    property ErroImportacao: IErroImportacao readonly dispid 23;
    function Finalizar(IndExcluirArquivo: Integer): Integer; dispid 24;
    property IndGerarComentarios: Integer dispid 25;
    function InserirEventoMudancaLote(const CodIdentificadorEvento: WideString; 
                                      DtaInicio: TDateTime; DtaFim: TDateTime; 
                                      const TxtObservacao: WideString; 
                                      const SglFazenda: WideString; 
                                      const SglLoteDestino: WideString; 
                                      const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 26;
    function InserirEventoMudancaLocal(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const TxtObservacao: WideString; 
                                       const SglAptidao: WideString; const SglFazenda: WideString; 
                                       const SglLocalDestino: WideString; 
                                       const SglRegimeAlimentarMamando: WideString; 
                                       const SglRegimeAlimentarDesmamado: WideString; 
                                       const CodFManejo: WideString; const CodManejo: WideString): Integer; dispid 27;
    function Pesquisar(CodTabela: Integer): Integer; dispid 28;
    function IrAoProximo: Integer; dispid 29;
    function EOF: WordBool; dispid 30;
    property SglEntidade: WideString readonly dispid 31;
    property DesEntidade: WideString readonly dispid 32;
    function DefinirComposicaoRacial(const SglFazendaManejo: WideString; 
                                     const CodAnimalManejo: WideString; const SglRaca: WideString; 
                                     QtdComposicaoRacial: Double): Integer; dispid 33;
    function MostrarDialogAbrir(const NomeArquivo: WideString; const Caption: WideString): WideString; dispid 34;
    function MostrarDialogSalvar(const NomeArquivo: WideString; const Caption: WideString): WideString; dispid 35;
    function MostrarFormProgresso(const Caption: WideString; const TxtInfo1: WideString; 
                                  const TxtInfo2: WideString; IndBarraProgresso: Integer; 
                                  ValMinBarraProgresso: Integer; ValMaxBarraProgresso: Integer): Integer; dispid 36;
    function AtualizarFormProgresso(IndTipoInfo: Integer; ValInfo: OleVariant): Integer; dispid 37;
    function FecharFormProgresso: Integer; dispid 38;
    property SglEntidadeRelacionada: WideString readonly dispid 39;
    property DesEntidadeRelacionada: WideString readonly dispid 40;
    function PesquisaRelacionamentos(CodTabelaRelacionamentos: Integer; CodTabelaOrigem: Integer; 
                                     const SglEntidadeOrigem: WideString): Integer; dispid 41;
    function InserirEventoEstacaoMonta(const CodIdentificadorEvento: WideString; 
                                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                                       const TxtObservacao: WideString; 
                                       const SglFazenda: WideString; 
                                       const SglEstacaoMonta: WideString; 
                                       const DesEstacaoMonta: WideString): Integer; dispid 42;
    function InserirEventoCoberturaRegimePasto(const CodIdentificadorEvento: WideString; 
                                               DtaInicio: TDateTime; DtaFim: TDateTime; 
                                               const TxtObservacao: WideString; 
                                               const SglFazenda: WideString; 
                                               const SglFazendaManejoAnimalRM: WideString; 
                                               const CodAnimalManejoAnimalRM: WideString): Integer; dispid 43;
    function InserirEventoDiagnosticoPrenhez(const CodIdentificadorEvento: WideString; 
                                             DtaInicio: TDateTime; DtaFim: TDateTime; 
                                             const TxtObservacao: WideString; 
                                             const SglFazenda: WideString): Integer; dispid 44;
    function InserirEventoExameAndrologico(const CodIdentificadorEvento: WideString; 
                                           DtaInicio: TDateTime; DtaFim: TDateTime; 
                                           const TxtObservacao: WideString; 
                                           const SglFazenda: WideString): Integer; dispid 45;
    function InserirEventoCoberturaInseminacaoArtificial(const CodIdentificadorEvento: WideString; 
                                                         DtaInicio: TDateTime; DtaFim: TDateTime; 
                                                         const TxtObservacao: WideString; 
                                                         const SglFazenda: WideString; 
                                                         HraEvento: TDateTime; 
                                                         const SglFazendaManejoTouro: WideString; 
                                                         const CodAnimalManejoTouro: WideString; 
                                                         const NumPartida: WideString; 
                                                         const SglFazendaManejoFemea: WideString; 
                                                         const CodAnimalManejoFemea: WideString; 
                                                         QtdDoses: Integer; 
                                                         const NumCNPJCPFInseminador: WideString): Integer; dispid 46;
    function InserirEventoCoberturaMontaControlada(const CodIdentificadorEvento: WideString; 
                                                   DtaInicio: TDateTime; DtaFim: TDateTime; 
                                                   const TxtObservacao: WideString; 
                                                   const SglFazenda: WideString; 
                                                   const SglFazendaManejoTouro: WideString; 
                                                   const CodAnimalManejoTouro: WideString; 
                                                   const SglFazendaManejoFemea: WideString; 
                                                   const CodAnimalManejoFemea: WideString): Integer; dispid 47;
    function InserirAnimalNaoEspecificado(const CodAnimalSisbov: WideString; 
                                          const IndSexo: WideString; const SglAptidao: WideString; 
                                          const SglRaca: WideString; DtaNascimento: TDateTime; 
                                          const SglTipoIdentificador1: WideString; 
                                          const SglPosicaoIdentificador1: WideString; 
                                          const SglTipoIdentificador2: WideString; 
                                          const SglPosicaoIdentificador2: WideString; 
                                          DtaIdentificacaoSisbov: TDateTime; 
                                          const SglFazendaIdentificacao: WideString; 
                                          const NumCNPJCPFTecnico: WideString; 
                                          const IndEfetivar: WideString): Integer; dispid 201;
    function InserirEventoAvaliacao(const CodIdentificadorEvento: WideString; DtaInicio: TDateTime; 
                                    DtaFim: TDateTime; const CodTipoAvaliacao: WideString; 
                                    const CodFazendaManejo: WideString; 
                                    const CodAnimalManejo: WideString; 
                                    const SglFazenda: WideString; 
                                    const CodTipoCaracteristica: WideString; 
                                    const ValorAvaliacao: WideString; 
                                    const TxtObservacao: WideString): Integer; dispid 202;
    function InserirInventarioAnimal(const SglFazenda: WideString; const CodAnimalSisbov: WideString): Integer; dispid 203;
  end;

// *********************************************************************//
// Interface: IErroImportacao
// Flags:     (6464) Dual OleAutomation Replaceable Dispatchable
// GUID:      {8206A82C-BF2E-403F-BBAC-5CE30611A055}
// *********************************************************************//
  IErroImportacao = interface(IDispatch)
    ['{8206A82C-BF2E-403F-BBAC-5CE30611A055}']
    function Get_CodErro: Integer; safecall;
    function Limpar: Integer; safecall;
    function ObterMensagem(CodErro: Integer): WideString; safecall;
    function ObterMensagemErro: WideString; safecall;
    property CodErro: Integer read Get_CodErro;
  end;

// *********************************************************************//
// DispIntf:  IErroImportacaoDisp
// Flags:     (6464) Dual OleAutomation Replaceable Dispatchable
// GUID:      {8206A82C-BF2E-403F-BBAC-5CE30611A055}
// *********************************************************************//
  IErroImportacaoDisp = dispinterface
    ['{8206A82C-BF2E-403F-BBAC-5CE30611A055}']
    property CodErro: Integer readonly dispid 1;
    function Limpar: Integer; dispid 2;
    function ObterMensagem(CodErro: Integer): WideString; dispid 3;
    function ObterMensagemErro: WideString; dispid 4;
  end;

// *********************************************************************//
// The Class CoImportacaoExcel provides a Create and CreateRemote method to          
// create instances of the default interface IImportacaoExcel exposed by              
// the CoClass ImportacaoExcel. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImportacaoExcel = class
    class function Create: IImportacaoExcel;
    class function CreateRemote(const MachineName: string): IImportacaoExcel;
  end;

// *********************************************************************//
// The Class CoErroImportacao provides a Create and CreateRemote method to          
// create instances of the default interface IErroImportacao exposed by              
// the CoClass ErroImportacao. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoErroImportacao = class
    class function Create: IErroImportacao;
    class function CreateRemote(const MachineName: string): IErroImportacao;
  end;

implementation

uses ComObj;

class function CoImportacaoExcel.Create: IImportacaoExcel;
begin
  Result := CreateComObject(CLASS_ImportacaoExcel) as IImportacaoExcel;
end;

class function CoImportacaoExcel.CreateRemote(const MachineName: string): IImportacaoExcel;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ImportacaoExcel) as IImportacaoExcel;
end;

class function CoErroImportacao.Create: IErroImportacao;
begin
  Result := CreateComObject(CLASS_ErroImportacao) as IErroImportacao;
end;

class function CoErroImportacao.CreateRemote(const MachineName: string): IErroImportacao;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ErroImportacao) as IErroImportacao;
end;

end.
