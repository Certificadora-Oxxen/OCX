// ****************************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/08/2002
// *  Documentação       : Animais - Definição das Classes.doc
// *  Código Classe      : 45
// *  Descrição Resumida : Cadastro de Animais
// ****************************************************************************
// *  Últimas Alterações
// *   Jerry    23/08/2002    Criação
// *   Hitalo   23/08/2002    Implementar o metodo Buscar
// *   Carlos   06/09/2002    Implementar o metodo PesquisarConsolidado
// *   Arley    04/11/2002    Inclusão do metodo GerarRelatorioConsolidado
// *   Arley    08/01/2003    Inclusão do método AlterarAtributoAnimal
// *   Jerry    21/02/2007    Inclusão dos métodos InventariarAnimaisPesquisados e
// *                          ExcluirInventarioAnimaisPesquisados
// *
// ****************************************************************************
unit uAnimais;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntAnimais, uAnimal, uConexao, uIntMensagens,
  uAnimalResumido, uFiliacao, uRegistro,uFerramentas;

type
  TAnimais = class(TASPMTSObject, IAnimais)
  private
    FIntAnimais : TIntAnimais;
    FInicializado : Boolean;
    FAnimal: TAnimal;
    FAnimalResumido : TAnimalResumido;
    FFiliacao : TFiliacao;
    FRegistro : TRegistro;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_Animal: IAnimal; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function InserirNascido(CodFazendaManejo: Integer; const CodAnimalManejo,
      CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSisbov, NumDVSisbov: Integer;
      const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodFazendaNascimento: Integer;
      const NomAnimal, DesApelido: WideString; CodAssociacaoRaca,
      CodGrauSangue: Integer; const NumRGD, NumTransponder: WideString;
      CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4, CodEspecie,
      CodAptidao, CodRaca, CodPelagem: Integer; const IndSexo: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
      CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
      IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function Get_AnimalResumido: IAnimalResumido; safecall;
    function Get_Filiacao: IFiliacao; safecall;
    function Get_Registro: IRegistro; safecall;
    function Buscar(CodAnimal: Integer; const CodAnimalSisbov,
      IndAnimalDoProprioProdutor, IndAnimalVendido: WideString): Integer;
      safecall;
    function InserirComprado(CodFazendaManejo: Integer; const CodAnimalManejo,
      CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSisbov, NumDVSisbov: Integer;
      const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; const NumImovelNascimento: WideString;
      CodPropriedadeNascimento: Integer; DtaCompra: TDateTime;
      CodPessoaSecundariaCriador: Integer; const NomAnimal,
      DesApelido: WideString; CodAssociacaoRaca, CodGrauSangue: Integer;
      const NumRGD, NumTransponder: WideString; CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
      CodPelagem: Integer; const IndSexo: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
      CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
      IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, NumGta: WideString; DtaEmissaoGta: TDateTime;
      NumNotaFiscal: Integer; const IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function InserirImportado(CodFazendaManejo: Integer; const CodAnimalManejo,
      CodAnimalCertificadora, CodSituacaoSisBov: WideString; DtaNascimento,
      DtaCompra: TDateTime; CodPessoaSecundariaCriador: Integer;
      const NomAnimal, DesApelido: WideString; CodAssociacaoRaca,
      CodGrauSangue: Integer; const NumRGD, NumTransponder: WideString;
      CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4, CodEspecie,
      CodAptidao, CodRaca, CodPelagem: Integer; const IndSexo: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
      CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
      IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente,
      CodPaisOrigem: Integer; const DesPropriedadeOrigem: WideString;
      DtaAutorizacaoImportacao, DtaEntradaPais: TDateTime;
      const NumGuiaImportacao, NumLicencaImportacao, TxtObservacao,
      IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function InserirExterno(const CodAnimalManejo,
      CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSisBov,
      CodMicroRegiaoSisBov, CodAnimalSisbov, NumDVSisbov: Integer;
      const CodSituacaoSisBov: WideString; DtaNascimento: TDateTime;
      const NomAnimal, DesApelido: WideString; CodAssociacaoRaca,
      CodGrauSangue: Integer; const NumRGD: WideString; CodEspecie,
      CodAptidao, CodRaca, CodPelagem: Integer; const IndSexo: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
      CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
      TxtObservacao, IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function Pesquisar(CodFazendaManejo: Integer; const CodManejoInicio,
      CodManejoFim, CodAnimalCertificadora: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
      CodSisBovFim: Integer; const CodSituacaoSisBov: WideString;
      DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
      CodFazendaNascimento: Integer; DtaCompraInicio,
      DtaCompraFim: TDateTime; CodPessoaSecundariaCriador: Integer;
      const NomAnimal, DesApelido: WideString; CodAptidao: Integer;
      const CodRaca, IndSexo, CodOrigem, SglFazendaPai, CodAnimalPai,
      DesApelidoPai, SglFazendaMae, CodAnimalMae,
      IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
      const CodCategoria, IndConsiderarExterno: WideString; CodAssociacao,
      CodGrauSangue: Integer; const NumRGD: WideString;
      CodTipoLugar: Integer; const CodLocal, CodLote: WideString;
      CodFazendaCorrente: Integer; const NumImovelCorrente: WideString;
      CodLocalizacaoCorrente: Integer; const NumCPFCNPJCorrente,
      IndCadastroEfetivado, CodOrdenacao: WideString; CodEvento: Integer;
      const IndEventoAplicado, IndAnimaisEvento: WideString;
      CodReprodutorMultiplo: Integer; const IndTrazerComposicaoRacial,
      IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialIncio1,
      QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
      CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double;
      const IndAptoCobertura, IndAutenticacao: WideString;
      CodEstacaoMonta: Integer; const IndAnimalSemTecnico: WideString;
      CodPessoaTecnico: Integer): Integer; safecall;
    function BuscarResumido(CodAnimal: Integer;
      const CodAnimalSisBov: WideString): Integer; safecall;
    function AlterarNascido(CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo, CodAnimalCertificadora: WideString;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, NumDVSisbov: Integer;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodFazendaNascimento: Integer;
      const NomAnimal, DesApelido, NumTransponder: WideString;
      CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4, CodRaca,
      CodPelagem: Integer; const IndAnimalCastrado: WideString;
      CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
      CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
      CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer; const IndSexo: WideString): Integer;
      safecall;
    function AlterarComprado(CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo, CodAnimalCertificadora: WideString;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, NumDVSisbov: Integer;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; const NumImovelNascimento: WideString;
      CodPropriedadeNascimento: Integer; DtaCompra: TDateTime;
      CodPessoaSecundariaCriador: Integer; const NomAnimal, DesApelido,
      NumTransponder: WideString; CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodRaca, CodPelagem: Integer;
      const IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, NumGta: WideString; DtaEmissaoGta: TDateTime;
      NumNotaFiscal: Integer; const IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer; const IndSexo: WideString): Integer;
      safecall;
    function AlterarImportado(CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo, CodAnimalCertificadora: WideString;
      DtaNascimento, DtaCompra: TDateTime;
      CodPessoaSecundariaCriador: Integer; const NomAnimal, DesApelido,
      NumTransponder: WideString; CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodRaca, CodPelagem: Integer;
      const IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente,
      CodPaisOrigem: Integer; const DesPropriedadeOrigem: WideString;
      DtaAutorizacaoImportacao, DtaEntradaPais: TDateTime;
      const NumGuiaImportacao, NumLicencaImportacao, TxtObservacao,
      IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
      const IndSexo: WideString): Integer; safecall;
    function AlterarExterno(CodAnimal: Integer; const CodAnimalManejo,
      CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodAnimalSisbov, NumDVSisbov: Integer;
      DtaNascimento: TDateTime; const NomAnimal, DesApelido: WideString;
      CodRaca, CodPelagem: Integer; const TxtObservacao,
      IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
      const IndSexo: WideString): Integer; safecall;
    function BuscarFiliacao(CodAnimal: Integer): Integer; safecall;
    function BuscarRegistro(CodAnimal: Integer): Integer; safecall;
    function AlterarFiliacao(CodAnimalFilho, CodAnimal,
      CodFazendaManejo: Integer; const CodAnimalManejo,
      CodAnimalCertificadora, CodTipoFiliacao: WideString): Integer;
      safecall;
    function AlterarRegistro(CodAnimal, CodAssociacaoRaca,
      CodGrauSangue: Integer; const NumRGD: WideString): Integer; safecall;
    function EfetivarCadastro(CodAnimal: Integer): Integer; safecall;
    function CancelarEfetivacao(CodAnimal: Integer): Integer; safecall;
    function InserirNascidos(QtdAnimais, CodFazendaManejo: Integer;
      const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
      TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
      CodInicialAnimalCertificadora,
      TxtSufixoAnimalCertificadora: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodInicialAnimalSisbov: Integer; const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodFazendaNascimento,
      CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4, CodEspecie,
      CodAptidao, CodRaca, CodPelagem: Integer; const IndSexo,
      IndAnimalCastrado: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function InserirComprados(QtdAnimais, CodFazendaManejo: Integer;
      const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
      TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
      CodInicialAnimalCertificadora,
      TxtSufixoAnimalCertificadora: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodInicialAnimalSisbov: Integer; const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; const NumImovelNascimento: WideString;
      CodPropriedadeNascimento: Integer; DtaCompra: TDateTime;
      CodPessoaSecundariaCriador, CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
      CodPelagem: Integer; const IndSexo, IndAnimalCastrado: WideString;
      CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
      CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
      CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao, NumGta: WideString; DtaEmissaoGta: TDateTime;
      NumNotaFiscal: Integer; const IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function InserirImportados(QtdAnimais, CodFazendaManejo: Integer;
      const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
      TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
      CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora,
      CodSituacaoSisBov: WideString; DtaNascimento, DtaCompra: TDateTime;
      CodPessoaSecundariaCriador, CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
      CodPelagem: Integer; const IndSexo, IndAnimalCastrado: WideString;
      CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
      CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
      CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente,
      CodPaisOrigem: Integer; const DesPropriedadeOrigem: WideString;
      DtaAutorizacaoImportacao, DtaEntradaPais: TDateTime;
      const NumGuiaImportacao, NumLicencaImportacao, TxtObservacao,
      IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function PesquisarConsolidado(CodFazenda,
      CodAgrupamento: Integer): Integer; safecall;
    function AlterarSisbovParaN(CodAnimal: Integer): Integer; safecall;
    function AlterarSisbovParaP(CodAnimal, CodPaisSisBov, CodEstadoSisBov,
      CodMicroRegiaoSisBov, CodAnimalSisbov, NumDVSisbov: Integer;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      const NumImovelNascimento: WideString;
      CodPropriedadeNascimento: Integer): Integer; safecall;
    function EfetivarCadastros(CodFazendaManejo: Integer;
      const CodInicialAnimalManejo, CodFinalAnimalManejo,
      CodAnimais: WideString): Integer; safecall;
    function CancelarEfetivacoes(CodFazendaManejo: Integer;
      const CodInicialAnimalManejo, CodFinalAnimalManejo,
      CodAnimais: WideString): Integer; safecall;
    function Excluir(CodFazendaManejo: Integer; const CodInicialAnimalManejo,
      CodFinalAnimalManejo, CodAnimais: WideString): Integer; safecall;
    function AlterarSisbov(CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo: WideString; CodPaisSisbov, CodEstadoSisbov,
      CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov: Integer;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao,
      CodFazendaIdentificacao: Integer): Integer; safecall;
    function AplicarEvento(const CodAnimais: WideString; CodFazenda: Integer;
      const CodAnimaisManejo: WideString; CodLote, CodLocal,
      CodEvento: Integer; const IndLimparMensagens: WideString): Integer;
      safecall;
    function AplicarEventoAnimaisPesquisados(CodEvento: Integer;
      const IndLimparMensagens: WideString): Integer; safecall;
    function PesquisarMensagensAplicacaoEvento(CodEvento: Integer;
      const IndOperacaoRemocao: WideString): Integer; safecall;
    function RemoverEvento(const CodAnimais: WideString; CodFazenda: Integer;
      const CodAnimaisManejo: WideString; CodLote, CodLocal,
      CodEvento: Integer; const IndLimparMensagens: WideString): Integer;
      safecall;
    function RemoverEventoAnimaisPesquisados(CodEvento: Integer;
      const IndLimparMensagens: WideString): Integer; safecall;
    function PesquisarMensagensOperacaoCadastro(CodOperacao: Integer): Integer;
      safecall;
    function LimparErrosOperacao(CodAnimal,
      CodOperacaoCadastro: Integer): Integer; safecall;
    function GerarRelatorio(CodFazendaManejo: Integer; const CodManejoInicio,
      CodManejoFim, CodAnimalCertificadora: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
      CodSisBovFim: Integer; const CodSituacaoSisBov: WideString;
      DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
      CodFazendaNascimento: Integer; DtaCompraInicio,
      DtaCompraFim: TDateTime; CodPessoaSecundariaCriador: Integer;
      const NomAnimal, DesApelido: WideString; CodAptidao: Integer;
      const CodRaca, IndSexo, CodOrigem, SglFazendaPai, CodAnimalPai,
      DesApelidoPai, SglFazendaMae, CodAnimalMae,
      IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
      const CodCategoria, IndConsiderarExterno: WideString; CodAssociacao,
      CodGrauSangue: Integer; const NumRGD: WideString;
      CodTipoLugar: Integer; const CodLocal, CodLote: WideString;
      CodFazendaCorrente: Integer; const NumImovelCorrente: WideString;
      CodLocalizacaoCorrente: Integer; const NumCPFCNPJCorrente,
      IndCadastroEfetivado, CodOrdenacao: WideString; CodEvento: Integer;
      const IndEventoAplicado, IndAnimaisEvento, IndAgrupRaca1: WideString;
      CodRaca1: Integer; QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double;
      const IndAptoCobertura, IndAutenticacao: WideString; Tipo,
      QtdQuebraRelatorio: Integer; const IndAnimalSemTecnico: WideString;
      CodPessoaTecnico: Integer): WideString; safecall;
    function PesquisarEventos(CodAnimal, CodGrupoEvento: Integer): Integer;
      safecall;
    function GerarRelatorioConsolidado(const SglProdutor, NomPessoaProdutor,
      CodSituacaoSisBov: WideString; DtaNascimentoInicio, DtaNascimentoFim,
      DtaIdentificacaoInicio, DtaIdentifcacaoFim: TDateTime;
      CodMicroRegiaoSisbovNascimento: Integer;
      const NomMicroRegiaoNascimento: WideString;
      CodEstadoNascimento: Integer; const NumImovelNascimento: WideString;
      CodLocalizacaoNascimento, CodMicroRegiaoSisbovIdentificacao: Integer;
      const NomMicroRegiaoIdentificacao: WideString;
      CodEstadoIdentificacao: Integer;
      const NumImovelIdentificacao: WideString;
      CodLocalizacaoIdentificacao: Integer; DtaCompraInicio,
      DtaCompraFim: TDateTime; const CodRaca, IndSexo, CodOrigem,
      IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
      const CodCategoria: WideString; CodAssociacaoRaca, CodGrauSangue,
      CodTipoLugar: Integer; const NumImovelCorrente: WideString;
      CodLocalizacaoCorrente: Integer; const NumCNPJCPFCorrente,
      NomPaisOrigem, IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double;
      const IndAptoCobertura: WideString; DtaInicioCertificado,
      DtaFimCertificado, DtaInicioCadastramento,
      DtaFimCadastramento: TDateTime; Tipo, QtdQuebraRelatorio: Integer;
      const numCNPJCPFTecnico, IndAnimalSemTecnico,
      IndAnimalCompradoComEvento: WideString; DtaInicioCadastramentoHerdom,
      DtaFimCadastramentoHerdom: TDateTime): WideString; safecall;
    function GerarRelatorioEventos(CodAnimal, CodGrupoEvento, Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function DefinirPesoAnimal(CodEvento, CodFazendaManejo: Integer;
      const CodAnimais, CodAnimaisManejo, QtdPesosAnimais,
      IndLimparMensagens: WideString): Integer; safecall;
    function AlterarPesoAnimal(CodEvento: Integer; const CodAnimais,
      QtdPesosAnimais: WideString): Integer; safecall;
    function GerarRelatorioPesoAjustado(Origem: Integer;
      const Sexo: WideString; Aptidao, CodFazendaManejo: Integer;
      const CodManejoInicial, CodManejoFinal, Raca, SglFazendaPai,
      CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae: WideString;
      DtaNascimentoInicio, DtaNascimentoFim, DtaCompraInicio,
      DtaCompraFim: TDateTime; CodPessoaSecundaria: Integer;
      const CodCategoria, IndAnimalCastrado: WideString;
      CodRegimeAlimentar: Integer; const CodLocal, CodLote: WideString;
      CodTipoLugar, NumIdadePadrao: Integer; QtdPesoMinimo, QtdPesoMaximo,
      QtdGPDMinimo, QtdGPDMaximo, QtdGPMMinimo, QtdGPMMaximo: Double;
      const IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function GerarRelatorioPesagem(CodOrigem: Integer;
      const IndSexoAnimal: WideString; CodAptidao,
      CodFazendaManejo: Integer; const CodAnimalManejoInicio,
      CodAnimalManejoFim, CodRaca, SglFazendaPai, CodAnimalManejoPai,
      DesApelidoPai, SglFazendaMae, CodAnimalManejoMae: WideString;
      DtaNascimentoInicio, DtaNascimentoFim, DtaCompraInicio,
      DtaCompraFim: TDateTime; CodPessoaSecundaria: Integer;
      const CodCategoria, IndAnimalCastrado: WideString;
      CodRegimeAlimentar: Integer; const CodLote, CodLocal: WideString;
      CodTipoLugar: Integer; DtaPesagemInicio, DtaPesagemFim: TDateTime;
      QtdPesoMinimo, QtdPesoMaximo, QtdGPDMinimo, QtdGPDMaximo,
      QtdGPMMinimo, QtdGPMMaximo: Double; QtdUltimasPesagens: Integer;
      const IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdCompRacialInicio1, QtdCompRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function DefinirComposicaoRacial(CodAnimal, CodRaca: Integer;
      QtdComposicaoRacial: Double): Integer; safecall;
    function PesquisarComposicaoRacial(CodAnimal: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function AlterarAtributo(CodAnimal, CodAtributo: Integer; Valor1,
      Valor2: OleVariant): Integer; safecall;
    function CalcularCompRacial(CodAnimal: Integer): Integer; safecall;
    function CalcularCompRacialDescendentes(CodAnimal,
      CodAnimalRM: Integer): Integer; safecall;
    function RecalcularTodasCompRacial: Integer; safecall;
    function LimparComposicaoRacial(CodAnimal: Integer): Integer; safecall;
    function PesquisarGenealogia(const CodAnimais: WideString;
      CodFazendaManejo: Integer;
      const CodAnimaisManejo: WideString): Integer; safecall;
    function DefinirDiagnosticoPrenhez(CodEvento: Integer;
      const CodAnimais: WideString; CodFazendaManejo: Integer;
      const CodAnimaisManejo, IndVacasPrenhas: WideString): Integer;
      safecall;
    function DefinirExameAndrologico(CodEvento: Integer;
      const CodAnimais: WideString; CodFazendaManejo: Integer;
      const CodAnimaisManejo, IndTourosAptos: WideString): Integer;
      safecall;
    function GerarRelatorioGenealogia(const CodAnimais: WideString;
      CodFazendaManejo: Integer;
      const CodAnimaisManejo: WideString): WideString; safecall;
    function GerarRelatorioAscendentes(const CodAnimais: WideString;
      CodFazendaManejo: Integer;
      const CodAnimaisManejo: WideString): WideString; safecall;
    function GerarRelAscendentesPesquisados: WideString; safecall;
    function DefinirAvaliacao(CodEvento, CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo: WideString;
      CodCaracteristicaAvaliacao: Integer; QtdAvalicao: Double): Integer;
      safecall;
    function RemoverAvaliacao(CodEvento, CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo: WideString): Integer; safecall;
    function PesquisarAvaliacao(CodEvento: Integer): Integer; safecall;
    function InserirNascidoParto(CodAnimalMae, CodAnimalPai,
      CodReprodutorMultiplo, CodFazendaManejo: Integer;
      const CodAnimalManejoCria, IndSexo: WideString; CodPelagem: Integer;
      DtaNascimento: TDateTime; const CodSituacaoSisBov: WideString;
      CodEspecie, CodAptidao, CodRaca, CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente: Integer; const IndCodSisBovReservado: WideString;
      CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function PesquisarPossivelPai(CodEstacaoMonta, CodAnimalFemea,
      CodFazendaManejoFemea: Integer;
      const CodAnimalManejoFemea: WideString;
      DtaEventoParto: TDateTime): Integer; safecall;
    function CancelarEfetivacaoAnimaisPesquisados: Integer; safecall;
    function EfetivarCadastroAnimaisPesquisados: Integer; safecall;
    function GerarRelatorioAutenticacao(const SglProdutor, NomPessoaProdutor,
      CodOrigens, IndSexo: WideString; CodAptidao, CodPaisSisBov,
      CodEstadoSisBov, CodMicroRegiaoSisBov, CodSisBovInicio,
      CodSisBovFim: Integer; const CodRacas, CodCategorias: WideString;
      DtaInicioNascimento, DtaFimNascimento: TDateTime; CodRegimeAlimentar,
      CodTipoLugar: Integer; DtaInicioAutenticacao, DtaFimAutenticacao,
      DtaInicioAutenticacaoPrevista, DtaFimAutenticacaoPrevista: TDateTime;
      const IndCertificadoEmitido: WideString; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function MarcarAnimaisComoExportadosPesquisados: Integer; safecall;
    function DesmCancAnimaisComoExportadosPesquisados(
      CodProcessamento: Integer): Integer; safecall;
    function DesmarcarExportados(CodFazendaManejo: Integer;
      const CodInicialAnimalManejo, CodFinalAnimalManejo,
      CodAnimais: WideString; CodProcessamento: Integer): Integer;
      safecall;
    function MarcarExportados(CodFazendaManejo: Integer;
      const CodInicialAnimalManejo, CodFinalAnimalManejo,
      CodAnimais: WideString): Integer; safecall;
    function PesquisarAnimalPai(CodFazendaManejo: Integer;
      const CodManejoInicio, CodManejoFim,
      CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
      CodMicroRegiaoSISBOV, CodSisBovInicio, CodSisBovFim: Integer;
      const CodSituacaoSisBov: WideString; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; CodFazendaNascimento: Integer;
      DtaCompraInicio, DtaCompraFim: TDateTime;
      CodPessoaSecundariaCriador: Integer; const NomAnimal,
      DesApelido: WideString; CodAptidao: Integer; const CodRaca, IndSexo,
      CodOrigem, SglFazendaPai, CodAnimalPai, DesApelidoPai, SglFazendaMae,
      CodAnimalMae, IndAnimalCastrado: WideString;
      CodRegimeAlimentar: Integer; const CodCategoria,
      IndConsiderarExterno: WideString; CodAssociacao,
      CodGrauSangue: Integer; const NumRGD: WideString;
      CodTipoLugar: Integer; const CodLocal, CodLote: WideString;
      CodFazendaCorrente: Integer; const NumImovelCorrente: WideString;
      CodLocalizacaoCorrente: Integer; const NumCPFCNPJCorrente,
      IndCadastroEfetivado, CodOrdenacao: WideString; CodEvento: Integer;
      const IndEventoAplicado, IndAnimaisEvento: WideString;
      CodReprodutorMultiplo: Integer; const IndTrazerComposicaoRacial,
      IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialIncio1,
      QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
      CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdCompRacialInicio3, QtdCompRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdCompRacialInicio4, QtdCompRacialFim4: Double;
      const IndAptoCobertura, IndAutenticacao: WideString;
      CodEstacaoMonta: Integer; const IndAnimalSemTecnico: WideString;
      CodPessoaTecnico: Integer): Integer; safecall;
    function AlterarTecnico(CodTecnico: Integer;
      const CodAnimais: WideString): Integer; safecall;
    function AlterarTecnicoAnimaisPesquisados(CodTecnico: Integer): Integer; safecall;
    function InserirNaoEspecificado(CodFazendaManejo: Integer;
      const CodAnimalManejo, CodAnimalCertificadora: WideString;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, NumDVSisbov: Integer;
      const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
      CodPelagem: Integer; const IndSexo: WideString;
      CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
      CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
      CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
      CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
      CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao: WideString; CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function AlterarNaoEspecificado(CodAnimal, CodFazendaManejo: Integer;
      const CodAnimalManejo, CodAnimalCertificadora: WideString;
      CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodAnimalSisbov, NumDVSisbov: Integer;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodFazendaNascimento,
      CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4, CodRaca, CodPelagem,
      CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
      CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
      CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao: WideString; CodPessoaTecnico: Integer;
      const IndSexo: WideString): Integer; safecall;
    function InserirNaoEspecificados(QtdAnimais, CodFazendaManejo: Integer;
      const CodInicialAnimalManejo,
      CodInicialAnimalCertificadora: WideString; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV,
      CodInicialAnimalSisbov: Integer; const CodSituacaoSisBov: WideString;
      DtaIdentificacaoSisbov: TDateTime;
      const NumImovelIdentificacao: WideString;
      CodPropriedadeIdentificacao, CodFazendaIdentificacao: Integer;
      DtaNascimento: TDateTime; CodTipoIdentificador1,
      CodPosicaoIdentificador1, CodTipoIdentificador2,
      CodPosicaoIdentificador2, CodTipoIdentificador3,
      CodPosicaoIdentificador3, CodTipoIdentificador4,
      CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
      CodPelagem: Integer; const IndSexo: WideString; CodRegimeAlimentar,
      CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
      CodFazendaCorrente, CodPropriedadeCorrente: Integer;
      const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
      const TxtObservacao: WideString; CodPessoaTecnico: Integer;
      const numCNPJCPFTecnico: WideString): Integer; safecall;
    function BuscarCaracteristicaAvaliacao(const CodAnimalManejo,
      SglCaracteristicaAvaliacao: WideString): Double; safecall;
    function BuscarPosicaoAnimalAvaliacaoCaracteristica(
      NumTela: Integer): Integer; safecall;
    function GerarRelatorioConsolidacaoCodigosSISBOV(const CodProdutor,
      NumCNPJCPFProdutor, NomProdutor, NumImovelReceitaFederal: WideString;
      CodExportacao: Integer; const NomPropriedadeRural,
      NomMunicipioPropriedade: WideString; SglEstadoPropriedade: Integer;
      DtaInicioIdentificacaoAnimal, DtaFimIdentificacaoAnimal: TDateTime;
      const NomPessoaTecnico, numCNPJCPFTecnico: WideString;
      TipoRelatorio: Integer): WideString; safecall;
    function InventariarAnimaisPesquisados(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer; safecall;
    function ExcluirInventarioAnimaisPesquisados(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer; safecall;
    function AlterarAnimalTmp(const PdataIdentificacaoSisbov, PdataNascimento,
      PNumRgd, PCodIdPropriedadeSISBOV, PCodRacaSisbov,
      PCodIdentificadorSisbov, PSexo,PCodSISBOV: WideString): Integer; safecall;
    function AtualizarDataAbate(CodPessoaProdutor,CodFazenda:integer):integer;safecall;
    function SolicitarAlteracaoPosse(CodPropriedadeRural, CodProdutorOrigem,
      CodProdutorDestino, CodMotivoSolicitacao: Integer;
      const Justificativa, NumeracaoEnvio: WideString): Integer; safecall;
    //druzo 10/08/2009
    function ConsultarAnimaisAbatidos(CodFrigorifico: Integer;
      const Data: WideString): Integer; safecall;
    function BuscaNumDvSISBOV(CodPaisSisbov, CodEstadoSisBov,
      CodMicroRegiaoSisBov, CodAnimalSisbov: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntAnimal, uIntAnimalResumido;

procedure TAnimais.AfterConstruction;
begin
  inherited;
  FAnimal := TAnimal.Create;
  FAnimal.ObjAddRef;
  FAnimalResumido := TAnimalResumido.Create;
  FAnimalResumido.ObjAddRef;
  FFiliacao := TFiliacao.Create;
  FFiliacao.ObjAddRef;
  FRegistro := TRegistro.Create;
  FRegistro.ObjAddRef;
  FInicializado := False;
end;

procedure TAnimais.BeforeDestruction;
begin
  If FIntAnimais <> nil Then Begin
    FIntAnimais.Free;
  End;
  If FAnimal <> nil Then Begin
    FAnimal.ObjRelease;
    FAnimal := nil;
  End;
  If FAnimalResumido <> nil Then Begin
    FAnimalResumido.ObjRelease;
    FAnimalResumido := nil;
  End;
  If FFiliacao <> nil Then Begin
    FFiliacao.ObjRelease;
    FFiliacao := nil;
  End;
  If FRegistro <> nil Then Begin
    FRegistro.ObjRelease;
    FRegistro := nil;
  End;
  inherited;
end;

function TAnimais.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAnimais := TIntAnimais.Create;
  Result := FIntAnimais.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAnimais.BOF: WordBool;
begin
  Result := FIntAnimais.BOF;
end;

function TAnimais.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntAnimais.Deslocar(QtdRegistros);
end;

function TAnimais.EOF: WordBool;
begin
  Result := FIntAnimais.EOF;
end;

function TAnimais.Get_Animal: IAnimal;
begin
  FAnimal.CodPessoaProdutor  := FIntAnimais.IntAnimal.CodPessoaProdutor;
  FAnimal.NomPessoaProdutor  := FIntAnimais.IntAnimal.NomPessoaProdutor;
  FAnimal.CodAnimal := FIntAnimais.IntAnimal.CodAnimal;
  FAnimal.CodFazendaManejo := FIntAnimais.IntAnimal.CodFazendaManejo;
  FAnimal.SglFazendaManejo := FIntAnimais.IntAnimal.SglFazendaManejo;
  FAnimal.CodAnimalManejo := FIntAnimais.IntAnimal.CodAnimalManejo;
  FAnimal.CodPaisSisbov := FIntAnimais.IntAnimal.CodPaisSisbov;
  FAnimal.CodEstadoSisbov := FIntAnimais.IntAnimal.CodEstadoSisbov;
  FAnimal.CodMicroRegiaoSisbov := FIntAnimais.IntAnimal.CodMicroRegiaoSisbov;
  FAnimal.CodAnimalSisbov := FIntAnimais.IntAnimal.CodAnimalSisbov;
  FAnimal.NumDVSisbov := FIntAnimais.IntAnimal.NumDVSisbov;
  FAnimal.NomAnimal := FIntAnimais.IntAnimal.NomAnimal;
  FAnimal.DesApelido := FIntAnimais.IntAnimal.DesApelido;
  FAnimal.CodRaca := FIntAnimais.IntAnimal.CodRaca;
  FAnimal.SglRaca := FIntAnimais.IntAnimal.SglRaca;
  FAnimal.DesRaca := FIntAnimais.IntAnimal.DesRaca;
  FAnimal.CodPelagem := FIntAnimais.IntAnimal.CodPelagem;
  FAnimal.SglPelagem := FIntAnimais.IntAnimal.SglPelagem;
  FAnimal.DesPelagem := FIntAnimais.IntAnimal.DesPelagem;
  FAnimal.IndSexo := FIntAnimais.IntAnimal.IndSexo;
  FAnimal.CodTipoOrigem := FIntAnimais.IntAnimal.CodTipoOrigem;
  FAnimal.SglTipoOrigem := FIntAnimais.IntAnimal.SglTipoOrigem;
  FAnimal.DesTipoOrigem := FIntAnimais.IntAnimal.DesTipoOrigem;
  FAnimal.DtaNascimento := FIntAnimais.IntAnimal.DtaNascimento;
  FAnimal.DtaCompra := FIntAnimais.IntAnimal.DtaCompra;
  FAnimal.CodAnimalPai := FIntAnimais.IntAnimal.CodAnimalPai;
  FAnimal.SglFazendaAnimalPai := FIntAnimais.IntAnimal.SglFazendaAnimalPai;
  FAnimal.CodManejoAnimalPai := FIntAnimais.IntAnimal.CodManejoAnimalPai;
  FAnimal.CodAnimalMae := FIntAnimais.IntAnimal.CodAnimalMae;
  FAnimal.SglFazendaAnimalMae := FIntAnimais.IntAnimal.SglFazendaAnimalMae;
  FAnimal.CodManejoAnimalMae := FIntAnimais.IntAnimal.CodManejoAnimalMae;
  FAnimal.CodAnimalReceptor := FIntAnimais.IntAnimal.CodAnimalReceptor;
  FAnimal.SglFazendaAnimalReceptor := FIntAnimais.IntAnimal.SglFazendaAnimalReceptor;
  FAnimal.CodManejoAnimalReceptor := FIntAnimais.IntAnimal.CodManejoAnimalReceptor;
  FAnimal.IndAnimalCastrado := FIntAnimais.IntAnimal.IndAnimalCastrado;
  FAnimal.CodRegimeAlimentar := FIntAnimais.IntAnimal.CodRegimeAlimentar;
  FAnimal.SglRegimeAlimentar := FIntAnimais.IntAnimal.SglRegimeAlimentar;
  FAnimal.DesRegimeAlimentar := FIntAnimais.IntAnimal.DesRegimeAlimentar;
  FAnimal.CodCategoriaAnimal := FIntAnimais.IntAnimal.CodCategoriaAnimal;
  FAnimal.SglCategoriaAnimal := FIntAnimais.IntAnimal.SglCategoriaAnimal;
  FAnimal.DesCategoriaAnimal := FIntAnimais.IntAnimal.DesCategoriaAnimal;
  FAnimal.CodFazendaCorrente := FIntAnimais.IntAnimal.CodFazendaCorrente;
  FAnimal.SglFazendaCorrente := FIntAnimais.IntAnimal.SglFazendaCorrente;
  FAnimal.NomFazendaCorrente := FIntAnimais.IntAnimal.NomFazendaCorrente;
  FAnimal.CodLocalCorrente := FIntAnimais.IntAnimal.CodLocalCorrente;
  FAnimal.SglLocalCorrente := FIntAnimais.IntAnimal.SglLocalCorrente;
  FAnimal.DesLocalCorrente  := FIntAnimais.IntAnimal.DesLocalCorrente;
  FAnimal.CodLoteCorrente := FIntAnimais.IntAnimal.CodLoteCorrente;
  FAnimal.SglLoteCorrente := FIntAnimais.IntAnimal.SglLoteCorrente;
  FAnimal.DesLoteCorrente := FIntAnimais.IntAnimal.DesLoteCorrente;
  FAnimal.TxtObservacao := FIntAnimais.IntAnimal.TxtObservacao;
  FAnimal.DtaCadastramento := FIntAnimais.IntAnimal.DtaCadastramento;
  FAnimal.DtaEfetivacaoCadastro := FIntAnimais.IntAnimal.DtaEfetivacaoCadastro;
  FAnimal.DtaUltimoEvento := FIntAnimais.IntAnimal.DtaUltimoEvento;
  FAnimal.CodAssociacaoRaca := FIntAnimais.IntAnimal.CodAssociacaoRaca;
  FAnimal.SglAssociacaoRaca := FIntAnimais.IntAnimal.SglAssociacaoRaca;
  FAnimal.NomAssociacaoRaca := FIntAnimais.IntAnimal.NomAssociacaoRaca;
  FAnimal.CodGrauSangue := FIntAnimais.IntAnimal.CodGrauSangue;
  FAnimal.SglGrauSangue := FIntAnimais.IntAnimal.SglGrauSangue;
  FAnimal.DesGrauSangue := FIntAnimais.IntAnimal.DesGrauSangue;
  FAnimal.NumRGD := FIntAnimais.IntAnimal.NumRGD;
  FAnimal.CodAnimalCertificadora := FIntAnimais.IntAnimal.CodAnimalCertificadora;
  FAnimal.CodSituacaoSisbov := FIntAnimais.IntAnimal.CodSituacaoSisbov;
  FAnimal.DesSituacaoSisbov := FIntAnimais.IntAnimal.DesSituacaoSisbov;
  FAnimal.TxtSituacaoSisbov  := FIntAnimais.IntAnimal.TxtSituacaoSisbov;
  FAnimal.DtaIdentificacaoSisbov := FIntAnimais.IntAnimal.DtaIdentificacaoSisbov;
  FAnimal.NumImovelIdentificacao := FIntAnimais.IntAnimal.NumImovelIdentificacao;
  FAnimal.CodLocalizacaoIdentificacao := FIntAnimais.IntAnimal.CodLocalizacaoIdentificacao;
  FAnimal.CodPropriedadeIdentificacao := FIntAnimais.IntAnimal.CodPropriedadeIdentificacao;
  FAnimal.NomPropriedadeIdentificacao := FIntAnimais.IntAnimal.NomPropriedadeIdentificacao;
  FAnimal.CodFazendaIdentificacao := FIntAnimais.IntAnimal.CodFazendaIdentificacao;
  FAnimal.SglFazendaIdentificacao := FIntAnimais.IntAnimal.SglFazendaIdentificacao;
  FAnimal.NomFazendaIdentificacao := FIntAnimais.IntAnimal.NomFazendaIdentificacao;
  FAnimal.NumImovelNascimento := FIntAnimais.IntAnimal.NumImovelNascimento;
  FAnimal.CodLocalizacaoNascimento := FIntAnimais.IntAnimal.CodLocalizacaoNascimento;
  FAnimal.CodPropriedadeNascimento := FIntAnimais.IntAnimal.CodPropriedadeNascimento;
  FAnimal.NomPropriedadeNascimento := FIntAnimais.IntAnimal.NomPropriedadeNascimento;
  FAnimal.CodFazendaNascimento := FIntAnimais.IntAnimal.CodFazendaNascimento;
  FAnimal.SglFazendaNascimento := FIntAnimais.IntAnimal.SglFazendaNascimento;
  FAnimal.NomFazendaNascimento := FIntAnimais.IntAnimal.NomFazendaNascimento;
  FAnimal.CodPessoaSecundariaCriador := FIntAnimais.IntAnimal.CodPessoaSecundariaCriador;
  FAnimal.NomPessoaSecundariaCriador := FIntAnimais.IntAnimal.NomPessoaSecundariaCriador;
  FAnimal.CodEspecie := FIntAnimais.IntAnimal.CodEspecie;
  FAnimal.SglEspecie := FIntAnimais.IntAnimal.SglEspecie;
  FAnimal.DesEspecie := FIntAnimais.IntAnimal.DesEspecie;
  FAnimal.CodAptidao := FIntAnimais.IntAnimal.CodAptidao;
  FAnimal.SglAptidao := FIntAnimais.IntAnimal.SglAptidao;
  FAnimal.DesAptidao := FIntAnimais.IntAnimal.DesAptidao;
  FAnimal.NumImovelCorrente := FIntAnimais.IntAnimal.NumImovelCorrente;
  FAnimal.CodLocalizacaoCorrente := FIntAnimais.IntAnimal.CodLocalizacaoCorrente;
  FAnimal.CodPropriedadeCorrente := FIntAnimais.IntAnimal.CodPropriedadeCorrente;
  FAnimal.NomPropriedadeCorrente := FIntAnimais.IntAnimal.NomPropriedadeCorrente;
  FAnimal.CodPessoCorrente := FIntAnimais.IntAnimal.CodPessoaCorrente;
  FAnimal.NomPessoaCorrente := FIntAnimais.IntAnimal.NomPessoaCorrente;
  FAnimal.NumCNPJCPFCorrente := FIntAnimais.IntAnimal.NumCNPJCPFCorrente;
  FAnimal.NumCNPJCPFCorrenteFormatado := FIntAnimais.IntAnimal.NumCNPJCPFCorrenteFormatado;
  FAnimal.CodPaisOrigem := FIntAnimais.IntAnimal.CodPaisOrigem;
  FAnimal.NomPaisOrigem := FIntAnimais.IntAnimal.NomPaisOrigem;
  FAnimal.DesPropriedadeOrigem := FIntAnimais.IntAnimal.DesPropriedadeOrigem;
  FAnimal.DtaAutorizacaoImportacao := FIntAnimais.IntAnimal.DtaAutorizacaoImportacao;
  FAnimal.DtaEntradaPais := FIntAnimais.IntAnimal.DtaEntradaPais;
  FAnimal.NumGuiaImportacao := FIntAnimais.IntAnimal.NumGuiaImportacao;
  FAnimal.NumLicencaImportacao := FIntAnimais.IntAnimal.NumLicencaImportacao;
  FAnimal.CodArquivoSisbov := FIntAnimais.IntAnimal.CodArquivoSisbov;
  FAnimal.DtaGravacaoSisbov := FIntAnimais.IntAnimal.DtaGravacaoSisbov;
  FAnimal.NomArquivoSisbov := FIntAnimais.IntAnimal.NomArquivoSisbov;
  FAnimal.CodTipoLugar := FIntAnimais.IntAnimal.CodTipoLugar;
  FAnimal.SglTipoLugar := FIntAnimais.IntAnimal.SglTipoLugar;
  FAnimal.DesTipoLugar := FIntAnimais.IntAnimal.DesTipoLugar;

  FAnimal.NumTransponder           := FIntAnimais.IntAnimal.NumTransponder;

  FAnimal.CodTipoIdentificador1    := FIntAnimais.IntAnimal.CodTipoIdentificador1;
  FAnimal.SglTipoIdentificador1    := FIntAnimais.IntAnimal.SglTipoIdentificador1;
  FAnimal.DesTipoIdentificador1    := FIntAnimais.IntAnimal.DesTipoIdentificador1;
  FAnimal.CodPosicaoIdentificador1 := FIntAnimais.IntAnimal.CodPosicaoIdentificador1;
  FAnimal.SglPosicaoIdentificador1 := FIntAnimais.IntAnimal.SglPosicaoIdentificador1;
  FAnimal.DesPosicaoIdentificador1 := FIntAnimais.IntAnimal.DesPosicaoIdentificador1;

  FAnimal.CodTipoIdentificador2    := FIntAnimais.IntAnimal.CodTipoIdentificador2;
  FAnimal.SglTipoIdentificador2    := FIntAnimais.IntAnimal.SglTipoIdentificador2;
  FAnimal.DesTipoIdentificador2    := FIntAnimais.IntAnimal.DesTipoIdentificador2;
  FAnimal.CodPosicaoIdentificador2 := FIntAnimais.IntAnimal.CodPosicaoIdentificador2;
  FAnimal.SglPosicaoIdentificador2 := FIntAnimais.IntAnimal.SglPosicaoIdentificador2;
  FAnimal.DesPosicaoIdentificador2 := FIntAnimais.IntAnimal.DesPosicaoIdentificador2;

  FAnimal.CodTipoIdentificador3    := FIntAnimais.IntAnimal.CodTipoIdentificador3;
  FAnimal.SglTipoIdentificador3    := FIntAnimais.IntAnimal.SglTipoIdentificador3;
  FAnimal.DesTipoIdentificador3    := FIntAnimais.IntAnimal.DesTipoIdentificador3;
  FAnimal.CodPosicaoIdentificador3 := FIntAnimais.IntAnimal.CodPosicaoIdentificador3;
  FAnimal.SglPosicaoIdentificador3 := FIntAnimais.IntAnimal.SglPosicaoIdentificador3;
  FAnimal.DesPosicaoIdentificador3 := FIntAnimais.IntAnimal.DesPosicaoIdentificador3;

  FAnimal.CodTipoIdentificador4    := FIntAnimais.IntAnimal.CodTipoIdentificador4;
  FAnimal.SglTipoIdentificador4    := FIntAnimais.IntAnimal.SglTipoIdentificador4;
  FAnimal.DesTipoIdentificador4    := FIntAnimais.IntAnimal.DesTipoIdentificador4;
  FAnimal.CodPosicaoIdentificador4 := FIntAnimais.IntAnimal.CodPosicaoIdentificador4;
  FAnimal.SglPosicaoIdentificador4 := FIntAnimais.IntAnimal.SglPosicaoIdentificador4;
  FAnimal.DesPosicaoIdentificador4 := FIntAnimais.IntAnimal.DesPosicaoIdentificador4;

  FAnimal.NumGta                   := FIntAnimais.IntAnimal.NumGta;
  FAnimal.DtaEmissaoGta            := FIntAnimais.IntAnimal.DtaEmissaoGta;
  FAnimal.NumNotaFiscal            := FIntAnimais.IntAnimal.NumNotaFiscal;

  FAnimal.NomMunicipioIdentificacao := FIntAnimais.IntAnimal.NomMunicipioIdentificacao;
  FAnimal.SglEstadoIdentificacao    := FIntAnimais.IntAnimal.SglEstadoIdentificacao;
  FAnimal.NomMunicipioNascimento    := FIntAnimais.IntAnimal.NomMunicipioNascimento;
  FAnimal.SglEstadoNascimento       := FIntAnimais.IntAnimal.SglEstadoNascimento;

  FAnimal.DesComposicaoRacial       := FIntAnimais.IntAnimal.DesComposicaoRacial;

  FAnimal.IndAptoCobertura          := FIntAnimais.IntAnimal.IndAptoCobertura;
  FAnimal.IndCadastroParto          := FIntAnimais.IntAnimal.IndCadastroParto;
  FAnimal.IndCodSisBovReservado     := FIntAnimais.IntAnimal.IndCodSisBovReservado;

  FAnimal.CodPessoaTecnico          := FIntAnimais.IntAnimal.CodPessoaTecnico;
  FAnimal.NomPessoaTecnico          := FIntAnimais.IntAnimal.NomPessoaTecnico;

  FAnimal.NomPessoaVendedor         := FIntAnimais.IntAnimal.NomPessoaVendedor;

  Result := FAnimal;
end;

function TAnimais.NumeroRegistros: Integer;
begin
  Result := FIntAnimais.NumeroRegistros;
end;

function TAnimais.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntAnimais.ValorCampo(NomeColuna);
end;

procedure TAnimais.FecharPesquisa;
begin
  FIntAnimais.FecharPesquisa;
end;

procedure TAnimais.IrAoAnterior;
begin
  FIntAnimais.IrAoAnterior;
end;

procedure TAnimais.IrAoPrimeiro;
begin
  FIntAnimais.IrAoPrimeiro;
end;

procedure TAnimais.IrAoProximo;
begin
  FIntAnimais.IrAoProximo;
end;

procedure TAnimais.IrAoUltimo;
begin
  FIntAnimais.IrAoUltimo;
end;

procedure TAnimais.Posicionar(NumRegistro: Integer);
begin
  FIntAnimais.Posicionar(NumRegistro);
end;

function TAnimais.InserirNascido(CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
  NumDVSisbov: Integer; const CodSituacaoSisBov: WideString;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodFazendaNascimento: Integer; const NomAnimal, DesApelido: WideString;
  CodAssociacaoRaca, CodGrauSangue: Integer; const NumRGD,
  NumTransponder: WideString; CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
  CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
  IndAnimalCastrado: WideString; CodRegimeAlimentar, CodCategoriaAnimal,
  CodTipoLugar, CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
  CodPropriedadeCorrente: Integer; const NumCNPJCPFCorrente: WideString;
  CodPessoaCorrente: Integer; const TxtObservacao,
  IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
  const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirNascido(CodFazendaManejo, CodAnimalManejo, CodAnimalCertificadora,
    CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov,
    CodSituacaoSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento,
    CodFazendaNascimento, NomAnimal, DesApelido, CodAssociacaoRaca, CodGrauSangue, NumRGD,
    NumTransponder, CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
    CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
    CodPelagem, IndSexo, CodFazendaManejoPai, CodAnimalPai, CodFazendaManejoMae, CodAnimalMae,
    CodFazendaManejoReceptor, CodAnimalReceptor, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, TxtObservacao, IndCodSisBovReservado, CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.Get_AnimalResumido: IAnimalResumido;
begin
  FAnimalResumido.CodPessoaProdutor  := FIntAnimais.IntAnimalResumido.CodPessoaProdutor;
  FAnimalResumido.NomPessoaProdutor  := FIntAnimais.IntAnimalResumido.NomPessoaProdutor;
  FAnimalResumido.CodAnimal := FIntAnimais.IntAnimalResumido.CodAnimal;
  FAnimalResumido.CodFazendaManejo := FIntAnimais.IntAnimalResumido.CodFazendaManejo;
  FAnimalResumido.SglFazendaManejo := FIntAnimais.IntAnimalResumido.SglFazendaManejo;
  FAnimalResumido.CodAnimalManejo := FIntAnimais.IntAnimalResumido.CodAnimalManejo;
  FAnimalResumido.CodAnimalCertificadora := FIntAnimais.IntAnimalResumido.CodAnimalCertificadora;
  FAnimalResumido.CodPaisSisbov := FIntAnimais.IntAnimalResumido.CodPaisSisbov;
  FAnimalResumido.CodEstadoSisbov := FIntAnimais.IntAnimalResumido.CodEstadoSisbov;
  FAnimalResumido.CodMicroRegiaoSisbov := FIntAnimais.IntAnimalResumido.CodMicroRegiaoSisbov;
  FAnimalResumido.CodAnimalSisbov := FIntAnimais.IntAnimalResumido.CodAnimalSisbov;
  FAnimalResumido.NumDVSisbov := FIntAnimais.IntAnimalResumido.NumDVSisbov;
  FAnimalResumido.NomAnimal := FIntAnimais.IntAnimalResumido.NomAnimal;
  FAnimalResumido.CodEspecie := FIntAnimais.IntAnimalResumido.CodEspecie;
  FAnimalResumido.SglEspecie := FIntAnimais.IntAnimalResumido.SglEspecie;
  FAnimalResumido.DesEspecie := FIntAnimais.IntAnimalResumido.DesEspecie;
  FAnimalResumido.CodAptidao := FIntAnimais.IntAnimalResumido.CodAptidao;
  FAnimalResumido.SglAptidao := FIntAnimais.IntAnimalResumido.SglAptidao;
  FAnimalResumido.DesAptidao := FIntAnimais.IntAnimalResumido.DesAptidao;
  FAnimalResumido.IndSexo := FIntAnimais.IntAnimalResumido.IndSexo;
  FAnimalResumido.CodTipoOrigem := FIntAnimais.IntAnimalResumido.CodTipoOrigem;
  FAnimalResumido.SglTipoOrigem := FIntAnimais.IntAnimalResumido.SglTipoOrigem;
  FAnimalResumido.DesTipoOrigem := FIntAnimais.IntAnimalResumido.DesTipoOrigem;
  FAnimalResumido.NomPessoaVendedor := FIntAnimais.IntAnimalResumido.NomPessoaVendedor;

  Result := FAnimalResumido;
end;

function TAnimais.Get_Filiacao: IFiliacao;
begin
  FFiliacao.CodPessoaProdutor := FIntAnimais.IntFiliacao.CodPessoaProdutor;
  FFiliacao.CodAnimal := FIntAnimais.IntFiliacao.CodAnimal;

  FFiliacao.AnimalPai.CodPessoaProdutor  := FIntAnimais.IntFiliacao.AnimalPai.CodPessoaProdutor;
  FFiliacao.AnimalPai.CodAnimal := FIntAnimais.IntFiliacao.AnimalPai.CodAnimal;
  FFiliacao.AnimalPai.CodPessoaProdutor  := FIntAnimais.IntFiliacao.AnimalPai.CodPessoaProdutor;
  FFiliacao.AnimalPai.CodAnimal := FIntAnimais.IntFiliacao.AnimalPai.CodAnimal;
  FFiliacao.AnimalPai.CodFazendaManejo := FIntAnimais.IntFiliacao.AnimalPai.CodFazendaManejo;
  FFiliacao.AnimalPai.SglFazendaManejo := FIntAnimais.IntFiliacao.AnimalPai.SglFazendaManejo;
  FFiliacao.AnimalPai.CodAnimalManejo := FIntAnimais.IntFiliacao.AnimalPai.CodAnimalManejo;
  FFiliacao.AnimalPai.CodAnimalCertificadora := FIntAnimais.IntFiliacao.AnimalPai.CodAnimalCertificadora;
  FFiliacao.AnimalPai.CodPaisSisbov := FIntAnimais.IntFiliacao.AnimalPai.CodPaisSisbov;
  FFiliacao.AnimalPai.CodEstadoSisbov := FIntAnimais.IntFiliacao.AnimalPai.CodEstadoSisbov;
  FFiliacao.AnimalPai.CodMicroRegiaoSisbov := FIntAnimais.IntFiliacao.AnimalPai.CodMicroRegiaoSisbov;
  FFiliacao.AnimalPai.CodAnimalSisbov := FIntAnimais.IntFiliacao.AnimalPai.CodAnimalSisbov;
  FFiliacao.AnimalPai.NumDVSisbov := FIntAnimais.IntFiliacao.AnimalPai.NumDVSisbov;
  FFiliacao.AnimalPai.NomAnimal := FIntAnimais.IntFiliacao.AnimalPai.NomAnimal;
  FFiliacao.AnimalPai.CodEspecie := FIntAnimais.IntFiliacao.AnimalPai.CodEspecie;
  FFiliacao.AnimalPai.SglEspecie := FIntAnimais.IntFiliacao.AnimalPai.SglEspecie;
  FFiliacao.AnimalPai.DesEspecie := FIntAnimais.IntFiliacao.AnimalPai.DesEspecie;
  FFiliacao.AnimalPai.CodAptidao := FIntAnimais.IntFiliacao.AnimalPai.CodAptidao;
  FFiliacao.AnimalPai.SglAptidao := FIntAnimais.IntFiliacao.AnimalPai.SglAptidao;
  FFiliacao.AnimalPai.DesAptidao := FIntAnimais.IntFiliacao.AnimalPai.DesAptidao;
  FFiliacao.AnimalPai.IndSexo := FIntAnimais.IntFiliacao.AnimalPai.IndSexo;
  FFiliacao.AnimalPai.CodTipoOrigem := FIntAnimais.IntFiliacao.AnimalPai.CodTipoOrigem;
  FFiliacao.AnimalPai.SglTipoOrigem := FIntAnimais.IntFiliacao.AnimalPai.SglTipoOrigem;
  FFiliacao.AnimalPai.DesTipoOrigem := FIntAnimais.IntFiliacao.AnimalPai.DesTipoOrigem;

  FFiliacao.AnimalMae.CodPessoaProdutor  := FIntAnimais.IntFiliacao.AnimalMae.CodPessoaProdutor;
  FFiliacao.AnimalMae.CodAnimal := FIntAnimais.IntFiliacao.AnimalMae.CodAnimal;
  FFiliacao.AnimalMae.CodFazendaManejo := FIntAnimais.IntFiliacao.AnimalMae.CodFazendaManejo;
  FFiliacao.AnimalMae.SglFazendaManejo := FIntAnimais.IntFiliacao.AnimalMae.SglFazendaManejo;
  FFiliacao.AnimalMae.CodAnimalManejo := FIntAnimais.IntFiliacao.AnimalMae.CodAnimalManejo;
  FFiliacao.AnimalMae.CodAnimalCertificadora := FIntAnimais.IntFiliacao.AnimalMae.CodAnimalCertificadora;
  FFiliacao.AnimalMae.CodPaisSisbov := FIntAnimais.IntFiliacao.AnimalMae.CodPaisSisbov;
  FFiliacao.AnimalMae.CodEstadoSisbov := FIntAnimais.IntFiliacao.AnimalMae.CodEstadoSisbov;
  FFiliacao.AnimalMae.CodMicroRegiaoSisbov := FIntAnimais.IntFiliacao.AnimalMae.CodMicroRegiaoSisbov;
  FFiliacao.AnimalMae.CodAnimalSisbov := FIntAnimais.IntFiliacao.AnimalMae.CodAnimalSisbov;
  FFiliacao.AnimalMae.NumDVSisbov := FIntAnimais.IntFiliacao.AnimalMae.NumDVSisbov;
  FFiliacao.AnimalMae.NomAnimal := FIntAnimais.IntFiliacao.AnimalMae.NomAnimal;
  FFiliacao.AnimalMae.CodEspecie := FIntAnimais.IntFiliacao.AnimalMae.CodEspecie;
  FFiliacao.AnimalMae.SglEspecie := FIntAnimais.IntFiliacao.AnimalMae.SglEspecie;
  FFiliacao.AnimalMae.DesEspecie := FIntAnimais.IntFiliacao.AnimalMae.DesEspecie;
  FFiliacao.AnimalMae.CodAptidao := FIntAnimais.IntFiliacao.AnimalMae.CodAptidao;
  FFiliacao.AnimalMae.SglAptidao := FIntAnimais.IntFiliacao.AnimalMae.SglAptidao;
  FFiliacao.AnimalMae.DesAptidao := FIntAnimais.IntFiliacao.AnimalMae.DesAptidao;
  FFiliacao.AnimalMae.IndSexo := FIntAnimais.IntFiliacao.AnimalMae.IndSexo;
  FFiliacao.AnimalMae.CodTipoOrigem := FIntAnimais.IntFiliacao.AnimalMae.CodTipoOrigem;
  FFiliacao.AnimalMae.SglTipoOrigem := FIntAnimais.IntFiliacao.AnimalMae.SglTipoOrigem;
  FFiliacao.AnimalMae.DesTipoOrigem := FIntAnimais.IntFiliacao.AnimalMae.DesTipoOrigem;

  FFiliacao.AnimalReceptor.CodPessoaProdutor  := FIntAnimais.IntFiliacao.AnimalReceptor.CodPessoaProdutor;
  FFiliacao.AnimalReceptor.CodAnimal := FIntAnimais.IntFiliacao.AnimalReceptor.CodAnimal;
  FFiliacao.AnimalReceptor.CodFazendaManejo := FIntAnimais.IntFiliacao.AnimalReceptor.CodFazendaManejo;
  FFiliacao.AnimalReceptor.SglFazendaManejo := FIntAnimais.IntFiliacao.AnimalReceptor.SglFazendaManejo;
  FFiliacao.AnimalReceptor.CodAnimalManejo := FIntAnimais.IntFiliacao.AnimalReceptor.CodAnimalManejo;
  FFiliacao.AnimalReceptor.CodAnimalCertificadora := FIntAnimais.IntFiliacao.AnimalReceptor.CodAnimalCertificadora;
  FFiliacao.AnimalReceptor.CodPaisSisbov := FIntAnimais.IntFiliacao.AnimalReceptor.CodPaisSisbov;
  FFiliacao.AnimalReceptor.CodEstadoSisbov := FIntAnimais.IntFiliacao.AnimalReceptor.CodEstadoSisbov;
  FFiliacao.AnimalReceptor.CodMicroRegiaoSisbov := FIntAnimais.IntFiliacao.AnimalReceptor.CodMicroRegiaoSisbov;
  FFiliacao.AnimalReceptor.CodAnimalSisbov := FIntAnimais.IntFiliacao.AnimalReceptor.CodAnimalSisbov;
  FFiliacao.AnimalReceptor.NumDVSisbov := FIntAnimais.IntFiliacao.AnimalReceptor.NumDVSisbov;
  FFiliacao.AnimalReceptor.NomAnimal := FIntAnimais.IntFiliacao.AnimalReceptor.NomAnimal;
  FFiliacao.AnimalReceptor.CodEspecie := FIntAnimais.IntFiliacao.AnimalReceptor.CodEspecie;
  FFiliacao.AnimalReceptor.SglEspecie := FIntAnimais.IntFiliacao.AnimalReceptor.SglEspecie;
  FFiliacao.AnimalReceptor.DesEspecie := FIntAnimais.IntFiliacao.AnimalReceptor.DesEspecie;
  FFiliacao.AnimalReceptor.CodAptidao := FIntAnimais.IntFiliacao.AnimalReceptor.CodAptidao;
  FFiliacao.AnimalReceptor.SglAptidao := FIntAnimais.IntFiliacao.AnimalReceptor.SglAptidao;
  FFiliacao.AnimalReceptor.DesAptidao := FIntAnimais.IntFiliacao.AnimalReceptor.DesAptidao;
  FFiliacao.AnimalReceptor.IndSexo := FIntAnimais.IntFiliacao.AnimalReceptor.IndSexo;
  FFiliacao.AnimalReceptor.CodTipoOrigem := FIntAnimais.IntFiliacao.AnimalReceptor.CodTipoOrigem;
  FFiliacao.AnimalReceptor.SglTipoOrigem := FIntAnimais.IntFiliacao.AnimalReceptor.SglTipoOrigem;
  FFiliacao.AnimalReceptor.DesTipoOrigem := FIntAnimais.IntFiliacao.AnimalReceptor.DesTipoOrigem;

  Result := FFiliacao;
end;

function TAnimais.Get_Registro: IRegistro;
begin
  FRegistro.CodPessoaProdutor  := FIntAnimais.IntRegistro.CodPessoaProdutor;
  FRegistro.CodAnimal := FIntAnimais.IntRegistro.CodAnimal;
  FRegistro.CodAssociacaoRaca := FIntAnimais.IntRegistro.CodAssociacaoRaca;
  FRegistro.SglAssociacaoRaca := FIntAnimais.IntRegistro.SglAssociacaoRaca;
  FRegistro.NomAssociacaoRaca := FIntAnimais.IntRegistro.NomAssociacaoRaca;
  FRegistro.CodGrauSangue := FIntAnimais.IntRegistro.CodGrauSangue;
  FRegistro.SglGrauSangue := FIntAnimais.IntRegistro.SglGrauSangue;
  FRegistro.DesGrauSangue := FIntAnimais.IntRegistro.DesGrauSangue;
  FRegistro.NumRGD := FIntAnimais.IntRegistro.NumRGD;

  Result := FRegistro;
end;

function TAnimais.Buscar(CodAnimal: Integer; const CodAnimalSisbov,
  IndAnimalDoProprioProdutor, IndAnimalVendido: WideString): Integer;
begin
  Result := FIntAnimais.Buscar(CodAnimal, CodAnimalSisbov, IndAnimalDoProprioProdutor, IndAnimalVendido);
end;

function TAnimais.InserirComprado(CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
  NumDVSisbov: Integer; const CodSituacaoSisBov: WideString;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  const NumImovelNascimento: WideString; CodPropriedadeNascimento: Integer;
  DtaCompra: TDateTime; CodPessoaSecundariaCriador: Integer;
  const NomAnimal, DesApelido: WideString; CodAssociacaoRaca,
  CodGrauSangue: Integer; const NumRGD, NumTransponder: WideString;
  CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
  CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
  IndAnimalCastrado: WideString; CodRegimeAlimentar, CodCategoriaAnimal,
  CodTipoLugar, CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
  CodPropriedadeCorrente: Integer; const NumCNPJCPFCorrente: WideString;
  CodPessoaCorrente: Integer; const TxtObservacao, NumGta: WideString;
  DtaEmissaoGta: TDateTime; NumNotaFiscal: Integer;
  const IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
  const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirComprado(CodFazendaManejo, CodAnimalManejo, CodAnimalCertificadora,
    CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov,
    CodSituacaoSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento, NumImovelNascimento,
    CodPropriedadeNascimento, DtaCompra, CodPessoaSecundariaCriador, NomAnimal, DesApelido,
    CodAssociacaoRaca, CodGrauSangue, NumRGD, NumTransponder, CodTipoIdentificador1,
    CodPosicaoIdentificador1, CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3,
    CodPosicaoIdentificador3, CodTipoIdentificador4,  CodPosicaoIdentificador4, CodEspecie, CodAptidao,
    CodRaca, CodPelagem, IndSexo, CodFazendaManejoPai, CodAnimalPai, CodFazendaManejoMae,
    CodAnimalMae, CodFazendaManejoReceptor, CodAnimalReceptor, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, TxtObservacao, NumGta, DtaEmissaoGta, NumNotaFiscal, IndCodSisBovReservado,
    CodPessoaTecnico, numCNPJCPFTecnico, -1);
end;

function TAnimais.InserirImportado(CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora,
  CodSituacaoSisBov: WideString; DtaNascimento, DtaCompra: TDateTime;
  CodPessoaSecundariaCriador: Integer; const NomAnimal,
  DesApelido: WideString; CodAssociacaoRaca, CodGrauSangue: Integer;
  const NumRGD, NumTransponder: WideString; CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
  CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
  IndAnimalCastrado: WideString; CodRegimeAlimentar, CodCategoriaAnimal,
  CodTipoLugar, CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
  CodPropriedadeCorrente: Integer; const NumCNPJCPFCorrente: WideString;
  CodPessoaCorrente, CodPaisOrigem: Integer;
  const DesPropriedadeOrigem: WideString; DtaAutorizacaoImportacao,
  DtaEntradaPais: TDateTime; const NumGuiaImportacao, NumLicencaImportacao,
  TxtObservacao, IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirImportado(CodFazendaManejo, CodAnimalManejo, CodAnimalCertificadora,
    CodSituacaoSisbov, DtaNascimento, DtaCompra, CodPessoaSecundariaCriador, NomAnimal, DesApelido,
    CodAssociacaoRaca, CodGrauSangue, NumRGD, NumTransponder, CodTipoIdentificador1, CodPosicaoIdentificador1,
    CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3,
    CodTipoIdentificador4, CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
    CodPelagem, IndSexo, CodFazendaManejoPai, CodAnimalPai, CodFazendaManejoMae, CodAnimalMae,
    CodFazendaManejoReceptor, CodAnimalReceptor, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, CodPaisOrigem, DesPropriedadeOrigem, DtaAutorizacaoImportacao,
    DtaEntradaPais, NumGuiaImportacao, NumLicencaImportacao, TxtObservacao, IndCodSisBovReservado,
    CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.InserirExterno(const CodAnimalManejo,
  CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSisBov,
  CodMicroRegiaoSisBov, CodAnimalSisbov, NumDVSisbov: Integer;
  const CodSituacaoSisBov: WideString; DtaNascimento: TDateTime;
  const NomAnimal, DesApelido: WideString; CodAssociacaoRaca,
  CodGrauSangue: Integer; const NumRGD: WideString; CodEspecie, CodAptidao,
  CodRaca, CodPelagem: Integer; const IndSexo: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
  CodFazendaManejoReceptor: Integer; const CodAnimalReceptor,
  TxtObservacao, IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirExterno(CodAnimalManejo, CodAnimalCertificadora, CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov, CodSituacaoSisbov,
  DtaNascimento, NomAnimal, DesApelido, CodAssociacaoRaca, CodGrauSangue, NumRGD, CodEspecie,
  CodAptidao, CodRaca, CodPelagem, IndSexo, CodFazendaManejoPai, CodAnimalPai,
  CodFazendaManejoMae, CodAnimalMae,
  CodFazendaManejoReceptor, CodAnimalReceptor, TxtObservacao, IndCodSisBovReservado,
  CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.Pesquisar(CodFazendaManejo: Integer;
  const CodManejoInicio, CodManejoFim, CodAnimalCertificadora: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
  CodSisBovFim: Integer; const CodSituacaoSisBov: WideString;
  DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
  CodFazendaNascimento: Integer; DtaCompraInicio, DtaCompraFim: TDateTime;
  CodPessoaSecundariaCriador: Integer; const NomAnimal,
  DesApelido: WideString; CodAptidao: Integer; const CodRaca, IndSexo,
  CodOrigem, SglFazendaPai, CodAnimalPai, DesApelidoPai, SglFazendaMae,
  CodAnimalMae, IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
  const CodCategoria, IndConsiderarExterno: WideString; CodAssociacao,
  CodGrauSangue: Integer; const NumRGD: WideString; CodTipoLugar: Integer;
  const CodLocal, CodLote: WideString; CodFazendaCorrente: Integer;
  const NumImovelCorrente: WideString; CodLocalizacaoCorrente: Integer;
  const NumCPFCNPJCorrente, IndCadastroEfetivado, CodOrdenacao: WideString;
  CodEvento: Integer; const IndEventoAplicado,
  IndAnimaisEvento: WideString; CodReprodutorMultiplo: Integer;
  const IndTrazerComposicaoRacial, IndAgrupRaca1: WideString;
  CodRaca1: Integer; QtdCompRacialIncio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; const IndAptoCobertura,
  IndAutenticacao: WideString; CodEstacaoMonta: Integer;
  const IndAnimalSemTecnico: WideString;
  CodPessoaTecnico: Integer): Integer;
begin
  result := FIntAnimais.Pesquisar(CodFazendaManejo, CodManejoInicio,
  CodManejoFim, CodAnimalCertificadora, CodPaisSisBov, CodEstadoSisBov,
  CodMicroRegiaoSisBov, CodSisBovInicio, CodSisBovFim, CodSituacaoSisbov,
  DtaNascimentoInicio, DtaNascimentoFim, CodFazendaNascimento,
  DtaCompraInicio, DtaCompraFim, CodPessoaSecundariaCriador, NomAnimal,
  DesApelido, CodAptidao, CodRaca, IndSexo, CodOrigem, SglFazendaPai,
  CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae,
  IndAnimalCastrado, CodRegimeAlimentar, CodCategoria, IndConsiderarExterno,
  CodAssociacao, CodGrauSangue, NumRGD, CodTipoLugar, CodLocal, CodLote,
  CodFazendaCorrente, NumImovelCorrente, CodLocalizacaoCorrente, NumCPFCNPJCorrente,
  IndCadastroEfetivado, CodOrdenacao, CodEvento, IndEventoAplicado, IndAnimaisEvento,
  CodReprodutorMultiplo, IndTrazerComposicaoRacial, IndAgrupRaca1, CodRaca1,
  QtdCompRacialIncio1, QtdCompRacialFim1, IndAgrupRaca2, CodRaca2,
  QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3,
  CodRaca3, QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4,
  CodRaca4, QtdCompRacialInicio4, QtdCompRacialFim4, IndAptoCobertura, IndAutenticacao,
  CodEstacaoMonta, IndAnimalSemTecnico, CodPessoaTecnico, 'S');
end;

function TAnimais.BuscarResumido(CodAnimal: Integer;
  const CodAnimalSisBov: WideString): Integer;
begin
  result := FIntAnimais.BuscarResumido(CodAnimal,CodAnimalSisBov);
end;

function TAnimais.AlterarNascido(CodAnimal, CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
  NumDVSisbov: Integer; DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodFazendaNascimento: Integer; const NomAnimal, DesApelido,
  NumTransponder: WideString; CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodRaca, CodPelagem: Integer;
  const IndAnimalCastrado: WideString; CodRegimeAlimentar,
  CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao, IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const IndSexo: WideString): Integer;
begin
  Result := FIntAnimais.AlterarNascido(CodAnimal, CodFazendaManejo, CodAnimalManejo,
    CodAnimalCertificadora, CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
    CodAnimalSisbov, NumDVSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento, CodFazendaNascimento,
    NomAnimal, DesApelido, NumTransponder, CodTipoIdentificador1, CodPosicaoIdentificador1,
    CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3,
    CodTipoIdentificador4, CodPosicaoIdentificador4, CodRaca, CodPelagem, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente, NumCNPJCPFCorrente,
    CodPessoaCorrente, TxtObservacao, IndCodSisBovReservado, CodPessoaTecnico, IndSexo);
end;

function TAnimais.AlterarComprado(CodAnimal, CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
  NumDVSisbov: Integer; DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  const NumImovelNascimento: WideString; CodPropriedadeNascimento: Integer;
  DtaCompra: TDateTime; CodPessoaSecundariaCriador: Integer;
  const NomAnimal, DesApelido, NumTransponder: WideString;
  CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodRaca, CodPelagem: Integer;
  const IndAnimalCastrado: WideString; CodRegimeAlimentar,
  CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao, NumGta: WideString; DtaEmissaoGta: TDateTime;
  NumNotaFiscal: Integer; const IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const IndSexo: WideString): Integer;
begin
  Result := FIntAnimais.AlterarComprado(CodAnimal, CodFazendaManejo, CodAnimalManejo,
    CodAnimalCertificadora, CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
    CodAnimalSisbov, NumDVSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento, NumImovelNascimento,
    CodPropriedadeNascimento, DtaCompra, CodPessoaSecundariaCriador,
    NomAnimal, DesApelido, NumTransponder, CodTipoIdentificador1, CodPosicaoIdentificador1,
    CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3,
    CodTipoIdentificador4, CodPosicaoIdentificador4, CodRaca, CodPelagem, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente, NumCNPJCPFCorrente,
    CodPessoaCorrente, TxtObservacao, NumGta, DtaEmissaoGta, NumNotaFiscal, IndCodSisBovReservado, CodPessoaTecnico, IndSexo);
end;

function TAnimais.AlterarImportado(CodAnimal, CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; DtaNascimento,
  DtaCompra: TDateTime; CodPessoaSecundariaCriador: Integer;
  const NomAnimal, DesApelido, NumTransponder: WideString;
  CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodRaca, CodPelagem: Integer;
  const IndAnimalCastrado: WideString; CodRegimeAlimentar,
  CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente,
  CodPaisOrigem: Integer; const DesPropriedadeOrigem: WideString;
  DtaAutorizacaoImportacao, DtaEntradaPais: TDateTime;
  const NumGuiaImportacao, NumLicencaImportacao, TxtObservacao,
  IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
  const IndSexo: WideString): Integer;
begin
  Result := FIntAnimais.AlterarImportado(CodAnimal, CodFazendaManejo, CodAnimalManejo,
    CodAnimalCertificadora, DtaNascimento, DtaCompra, CodPessoaSecundariaCriador,
    NomAnimal, DesApelido, NumTransponder, CodTipoIdentificador1, CodPosicaoIdentificador1,
    CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3,
    CodTipoIdentificador4, CodPosicaoIdentificador4, CodRaca, CodPelagem, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente, NumCNPJCPFCorrente,
    CodPessoaCorrente, CodPaisOrigem, DesPropriedadeOrigem, DtaAutorizacaoImportacao,
    DtaEntradaPais, NumGuiaImportacao, NumLicencaImportacao, TxtObservacao, IndCodSisBovReservado, CodPessoaTecnico, IndSexo);
end;

function TAnimais.AlterarExterno(CodAnimal: Integer; const CodAnimalManejo,
  CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSisbov, NumDVSisbov: Integer;
  DtaNascimento: TDateTime; const NomAnimal, DesApelido: WideString;
  CodRaca, CodPelagem: Integer; const TxtObservacao,
  IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
  const IndSexo: WideString): Integer;
begin
  Result := FIntAnimais.AlterarExterno(CodAnimal, CodAnimalManejo,
    CodAnimalCertificadora, CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
    CodAnimalSisbov, NumDVSisbov, DtaNascimento, NomAnimal, DesApelido, CodRaca,
    CodPelagem, TxtObservacao, IndCodSisBovReservado, CodPessoaTecnico, IndSexo);
end;

function TAnimais.BuscarFiliacao(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.BuscarFiliacao(CodAnimal);
end;

function TAnimais.BuscarRegistro(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.BuscarRegistro(CodAnimal);
end;

function TAnimais.AlterarFiliacao(CodAnimalFilho, CodAnimal,
  CodFazendaManejo: Integer; const CodAnimalManejo, CodAnimalCertificadora,
  CodTipoFiliacao: WideString): Integer;
begin
  Result := FIntAnimais.AlterarFiliacao(CodAnimalFilho, CodAnimal, CodFazendaManejo,
    CodAnimalManejo, CodAnimalCertificadora, CodTipoFiliacao);
end;

function TAnimais.AlterarRegistro(CodAnimal, CodAssociacaoRaca,
  CodGrauSangue: Integer; const NumRGD: WideString): Integer;
begin
  Result := FIntAnimais.AlterarRegistro(CodAnimal, CodAssociacaoRaca, CodGrauSangue, NumRGD);
end;

function TAnimais.EfetivarCadastro(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.EfetivarCadastro(CodAnimal);
end;

function TAnimais.CancelarEfetivacao(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.CancelarEfetivacao(CodAnimal);
end;

function TAnimais.InserirNascidos(QtdAnimais, CodFazendaManejo: Integer;
  const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
  TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
  CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodInicialAnimalSisbov: Integer; const CodSituacaoSisBov: WideString;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodFazendaNascimento, CodTipoIdentificador1, CodPosicaoIdentificador1,
  CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo, IndAnimalCastrado: WideString;
  CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente,
  CodLocalCorrente, CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao, IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirNascidos(QtdAnimais, CodFazendaManejo, TxtPrefixoAnimalManejo,
    CodInicialAnimalManejo, TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
    CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora,
    CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodInicialAnimalSisbov,
    CodSituacaoSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento,
    CodFazendaNascimento, CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
    CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
    CodPelagem, IndSexo, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, TxtObservacao, IndCodSisBovReservado, CodPessoaTecnico,
    numCNPJCPFTecnico);
end;

function TAnimais.InserirComprados(QtdAnimais, CodFazendaManejo: Integer;
  const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
  TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
  CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
  CodInicialAnimalSisbov: Integer; const CodSituacaoSisBov: WideString;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  const NumImovelNascimento: WideString; CodPropriedadeNascimento: Integer;
  DtaCompra: TDateTime; CodPessoaSecundariaCriador, CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo, IndAnimalCastrado: WideString;
  CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente,
  CodLocalCorrente, CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao, NumGta: WideString; DtaEmissaoGta: TDateTime;
  NumNotaFiscal: Integer; const IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirComprados(QtdAnimais, CodFazendaManejo, TxtPrefixoAnimalManejo,
    CodInicialAnimalManejo, TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
    CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora,
    CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodInicialAnimalSisbov,
    CodSituacaoSisbov, DtaIdentificacaoSisbov, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento, NumImovelNascimento,
    CodPropriedadeNascimento, DtaCompra, CodPessoaSecundariaCriador, CodTipoIdentificador1,
    CodPosicaoIdentificador1, CodTipoIdentificador2,  CodPosicaoIdentificador2,
    CodTipoIdentificador3, CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
    CodPelagem, IndSexo, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, TxtObservacao, NumGta, DtaEmissaoGta, NumNotaFiscal,
    IndCodSisBovReservado, CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.InserirImportados(QtdAnimais, CodFazendaManejo: Integer;
  const TxtPrefixoAnimalManejo, CodInicialAnimalManejo,
  TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
  CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora,
  CodSituacaoSisBov: WideString; DtaNascimento, DtaCompra: TDateTime;
  CodPessoaSecundariaCriador, CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo, IndAnimalCastrado: WideString;
  CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente,
  CodLocalCorrente, CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente,
  CodPaisOrigem: Integer; const DesPropriedadeOrigem: WideString;
  DtaAutorizacaoImportacao, DtaEntradaPais: TDateTime;
  const NumGuiaImportacao, NumLicencaImportacao, TxtObservacao,
  IndCodSisBovReservado: WideString; CodPessoaTecnico: Integer;
  const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirImportados(QtdAnimais, CodFazendaManejo, TxtPrefixoAnimalManejo,
    CodInicialAnimalManejo, TxtSufixoAnimalManejo, TxtPrefixoAnimalCertificadora,
    CodInicialAnimalCertificadora, TxtSufixoAnimalCertificadora,
    CodSituacaoSisbov, DtaNascimento, DtaCompra, CodPessoaSecundariaCriador, CodTipoIdentificador1,
    CodPosicaoIdentificador1, CodTipoIdentificador2,  CodPosicaoIdentificador2,
    CodTipoIdentificador3, CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
    CodPelagem, IndSexo, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, CodPaisOrigem,
    DesPropriedadeOrigem, DtaAutorizacaoImportacao, DtaEntradaPais,
    NumGuiaImportacao, NumLicencaImportacao, TxtObservacao, IndCodSisBovReservado,
    CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.PesquisarConsolidado(CodFazenda,
  CodAgrupamento: Integer): Integer;
begin
   Result := FIntAnimais.PesquisarConsolidado(CodFazenda,CodAgrupamento);
end;

function TAnimais.AlterarSisbovParaN(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.AlterarSisbovParaN(CodAnimal);
end;

function TAnimais.AlterarSisbovParaP(CodAnimal, CodPaisSisBov,
  CodEstadoSisBov, CodMicroRegiaoSisBov, CodAnimalSisbov,
  NumDVSisbov: Integer; DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; const NumImovelNascimento: WideString;
  CodPropriedadeNascimento: Integer): Integer;
begin
  Result := FIntAnimais.AlterarSisbovParaP(CodAnimal, CodPaisSisbov, CodEstadoSisbov,
    CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov, DtaIdentificacaoSisbov,
    NumImovelIdentificacao, CodPropriedadeIdentificacao, CodFazendaIdentificacao,
    NumImovelNascimento, CodPropriedadeNascimento);
end;

function TAnimais.EfetivarCadastros(CodFazendaManejo: Integer;
  const CodInicialAnimalManejo, CodFinalAnimalManejo,
  CodAnimais: WideString): Integer;
begin
  Result := FIntAnimais.EfetivarCadastros(CodFazendaManejo, CodInicialAnimalManejo,
    CodFinalAnimalManejo, CodAnimais);
end;

function TAnimais.CancelarEfetivacoes(CodFazendaManejo: Integer;
  const CodInicialAnimalManejo, CodFinalAnimalManejo,
  CodAnimais: WideString): Integer;
begin
  Result := FIntAnimais.CancelarEfetivacoes(CodFazendaManejo, CodInicialAnimalManejo,
    CodFinalAnimalManejo, CodAnimais);
end;

function TAnimais.Excluir(CodFazendaManejo: Integer;
  const CodInicialAnimalManejo, CodFinalAnimalManejo, CodAnimais: WideString): Integer;
begin
  Result := FIntAnimais.Excluir(CodFazendaManejo, CodInicialAnimalManejo,
    CodFinalAnimalManejo, CodAnimais);
end;

function TAnimais.AlterarSisbov(CodAnimal, CodFazendaManejo: Integer;
  const CodAnimalManejo: WideString; CodPaisSisbov, CodEstadoSisbov,
  CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov: Integer;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer): Integer;
begin
  Result := FIntAnimais.AlterarSisbov(CodAnimal, CodFazendaManejo, CodAnimalManejo,
    CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDVSisbov,
    DtaIdentificacaoSisbov, NumImovelIdentificacao, CodPropriedadeIdentificacao,
    CodFazendaIdentificacao);
end;

function TAnimais.AplicarEvento(const CodAnimais: WideString;
  CodFazenda: Integer; const CodAnimaisManejo: WideString; CodLote,
  CodLocal, CodEvento: Integer;
  const IndLimparMensagens: WideString): Integer;
begin
  Result := FIntAnimais.AplicarEvento(CodAnimais, CodFazenda, CodAnimaisManejo,
    CodLote, CodLocal, CodEvento, IndLimparMensagens);
end;

function TAnimais.AplicarEventoAnimaisPesquisados(CodEvento: Integer;
  const IndLimparMensagens: WideString): Integer;
begin
  Result := FIntAnimais.AplicarEventoAnimaisPesquisados(CodEvento,
    IndLimparMensagens);
end;

function TAnimais.PesquisarMensagensAplicacaoEvento(CodEvento: Integer;
  const IndOperacaoRemocao: WideString): Integer;
begin
  Result := FIntAnimais.PesquisarMensagensAplicacaoEvento(CodEvento, IndOperacaoRemocao);
end;

function TAnimais.RemoverEvento(const CodAnimais: WideString;
  CodFazenda: Integer; const CodAnimaisManejo: WideString; CodLote,
  CodLocal, CodEvento: Integer;
  const IndLimparMensagens: WideString): Integer;
begin
  Result := FIntAnimais.RemoverEvento(CodAnimais, CodFazenda, CodAnimaisManejo,
    CodLote, CodLocal, CodEvento, IndLimparMensagens);
end;

function TAnimais.RemoverEventoAnimaisPesquisados(CodEvento: Integer;
  const IndLimparMensagens: WideString): Integer;
begin
  Result := FIntAnimais.RemoverEventoAnimaisPesquisados(CodEvento,
    IndLimparMensagens);
end;

function TAnimais.PesquisarMensagensOperacaoCadastro(
  CodOperacao: Integer): Integer;
begin
  Result := FIntAnimais.PesquisarMensagensOperacaoCadastro(CodOperacao);
end;

function TAnimais.LimparErrosOperacao(CodAnimal,
  CodOperacaoCadastro: Integer): Integer;
begin
  Result := FIntAnimais.LimparErrosOperacao(CodAnimal, CodOperacaoCadastro);
end;

function TAnimais.GerarRelatorio(CodFazendaManejo: Integer;
  const CodManejoInicio, CodManejoFim, CodAnimalCertificadora: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
  CodSisBovFim: Integer; const CodSituacaoSisBov: WideString;
  DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
  CodFazendaNascimento: Integer; DtaCompraInicio, DtaCompraFim: TDateTime;
  CodPessoaSecundariaCriador: Integer; const NomAnimal,
  DesApelido: WideString; CodAptidao: Integer; const CodRaca, IndSexo,
  CodOrigem, SglFazendaPai, CodAnimalPai, DesApelidoPai, SglFazendaMae,
  CodAnimalMae, IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
  const CodCategoria, IndConsiderarExterno: WideString; CodAssociacao,
  CodGrauSangue: Integer; const NumRGD: WideString; CodTipoLugar: Integer;
  const CodLocal, CodLote: WideString; CodFazendaCorrente: Integer;
  const NumImovelCorrente: WideString; CodLocalizacaoCorrente: Integer;
  const NumCPFCNPJCorrente, IndCadastroEfetivado, CodOrdenacao: WideString;
  CodEvento: Integer; const IndEventoAplicado, IndAnimaisEvento,
  IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double;
  const IndAptoCobertura, IndAutenticacao: WideString; Tipo,
  QtdQuebraRelatorio: Integer; const IndAnimalSemTecnico: WideString;
  CodPessoaTecnico: Integer): WideString;
begin
  Result := FIntAnimais.GerarRelatorio(CodFazendaManejo, CodManejoInicio,
    CodManejoFim, CodAnimalCertificadora, CodPaisSisBov, CodEstadoSisBov,
    CodMicroRegiaoSisBov, CodSisBovInicio, CodSisBovFim, CodSituacaoSisbov,
    DtaNascimentoInicio, DtaNascimentoFim, CodFazendaNascimento,
    DtaCompraInicio, DtaCompraFim, CodPessoaSecundariaCriador, NomAnimal,
    DesApelido, CodAptidao, CodRaca, IndSexo, CodOrigem, SglFazendaPai,
    CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae, IndAnimalCastrado,
    CodRegimeAlimentar, CodCategoria, IndConsiderarExterno, CodAssociacao,
    CodGrauSangue, NumRGD, CodTipoLugar, CodLocal, CodLote, CodFazendaCorrente,
    NumImovelCorrente, CodLocalizacaoCorrente, NumCPFCNPJCorrente,
    IndCadastroEfetivado, CodOrdenacao, CodEvento, IndEventoAplicado,
    IndAnimaisEvento, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
    QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
    QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
    QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
    QtdCompRacialFim4, IndAptoCobertura, IndAutenticacao, Tipo,
    QtdQuebraRelatorio, IndAnimalSemTecnico, CodPessoaTecnico);
end;

function TAnimais.PesquisarEventos(CodAnimal,
  CodGrupoEvento: Integer): Integer;
begin
  Result := FIntAnimais.PesquisarEventos(CodAnimal,CodGrupoEvento);
end;

function TAnimais.GerarRelatorioConsolidado(const SglProdutor,
  NomPessoaProdutor, CodSituacaoSisBov: WideString; DtaNascimentoInicio,
  DtaNascimentoFim, DtaIdentificacaoInicio, DtaIdentifcacaoFim: TDateTime;
  CodMicroRegiaoSisbovNascimento: Integer;
  const NomMicroRegiaoNascimento: WideString; CodEstadoNascimento: Integer;
  const NumImovelNascimento: WideString; CodLocalizacaoNascimento,
  CodMicroRegiaoSisbovIdentificacao: Integer;
  const NomMicroRegiaoIdentificacao: WideString;
  CodEstadoIdentificacao: Integer;
  const NumImovelIdentificacao: WideString;
  CodLocalizacaoIdentificacao: Integer; DtaCompraInicio,
  DtaCompraFim: TDateTime; const CodRaca, IndSexo, CodOrigem,
  IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
  const CodCategoria: WideString; CodAssociacaoRaca, CodGrauSangue,
  CodTipoLugar: Integer; const NumImovelCorrente: WideString;
  CodLocalizacaoCorrente: Integer; const NumCNPJCPFCorrente, NomPaisOrigem,
  IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double;
  const IndAptoCobertura: WideString; DtaInicioCertificado,
  DtaFimCertificado, DtaInicioCadastramento,
  DtaFimCadastramento: TDateTime; Tipo, QtdQuebraRelatorio: Integer;
  const numCNPJCPFTecnico, IndAnimalSemTecnico,
  IndAnimalCompradoComEvento: WideString; DtaInicioCadastramentoHerdom,
  DtaFimCadastramentoHerdom: TDateTime): WideString;
begin
  Result := FIntAnimais.GerarRelatorioConsolidado(SglProdutor, NomPessoaProdutor,
    CodSituacaoSisbov, DtaNascimentoInicio, DtaNascimentoFim,
    DtaIdentificacaoInicio, DtaIdentifcacaoFim, CodMicroRegiaoSisbovNascimento,
    NomMicroRegiaoNascimento, CodEstadoNascimento, NumImovelNascimento,
    CodLocalizacaoNascimento, CodMicroRegiaoSisbovIdentificacao,
    NomMicroRegiaoIdentificacao, CodEstadoIdentificacao, NumImovelIdentificacao,
    CodLocalizacaoIdentificacao, DtaCompraInicio, DtaCompraFim, CodRaca,
    IndSexo, CodOrigem, IndAnimalCastrado, CodRegimeAlimentar, CodCategoria,
    CodAssociacaoRaca, CodGrauSangue, CodTipoLugar, NumImovelCorrente,
    CodLocalizacaoCorrente, NumCNPJCPFCorrente,  NomPaisOrigem,
    IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1, QtdCompRacialFim1,
    IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2, QtdCompRacialFim2,
    IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3, QtdCompRacialFim3,
    IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4, QtdCompRacialFim4,
    IndAptoCobertura, DtaInicioCertificado, DtaFimCertificado,
    DtaInicioCadastramento, DtaFimCadastramento, Tipo,
    QtdQuebraRelatorio, NumCNPJCPFTecnico, IndAnimalSemTecnico,
    IndAnimalCompradoComEvento, -1, DtaInicioCadastramentoHerdom, DtaFimCadastramentoHerdom);
end;

function TAnimais.GerarRelatorioEventos(CodAnimal, CodGrupoEvento, Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  result := FIntAnimais.GerarRelatorioEventos(CodAnimal, CodGrupoEvento, Tipo,QtdQuebraRelatorio);
end;

function TAnimais.DefinirPesoAnimal(CodEvento, CodFazendaManejo: Integer;
  const CodAnimais, CodAnimaisManejo, QtdPesosAnimais,
  IndLimparMensagens: WideString): Integer;
begin
  result := FIntAnimais.DefinirPesoAnimal(CodEvento, CodFazendaManejo,
  CodAnimais, CodAnimaisManejo,QtdPesosAnimais,IndLimparMensagens);
//  result := FIntAnimais.DefinirPesoAnimal(CodEvento, CodFazendaManejo,
//  CodAnimaisManejo,QtdPesosAnimais,IndLimparMensagens);
end;

function TAnimais.AlterarPesoAnimal(CodEvento: Integer; const CodAnimais,
  QtdPesosAnimais: WideString): Integer;
begin
  result := FIntAnimais.AlterarPesoAnimal(CodEvento,
  CodAnimais,QtdPesosAnimais);
end;

function TAnimais.GerarRelatorioPesoAjustado(Origem: Integer;
  const Sexo: WideString; Aptidao, CodFazendaManejo: Integer;
  const CodManejoInicial, CodManejoFinal, Raca, SglFazendaPai,
  CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae: WideString;
  DtaNascimentoInicio, DtaNascimentoFim, DtaCompraInicio,
  DtaCompraFim: TDateTime; CodPessoaSecundaria: Integer;
  const CodCategoria, IndAnimalCastrado: WideString;
  CodRegimeAlimentar: Integer; const CodLocal, CodLote: WideString;
  CodTipoLugar, NumIdadePadrao: Integer; QtdPesoMinimo, QtdPesoMaximo,
  QtdGPDMinimo, QtdGPDMaximo, QtdGPMMinimo, QtdGPMMaximo: Double;
  const IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  result := FIntAnimais.GerarRelatorioPesoAjustado(Origem, Sexo, Aptidao,
  CodFazendaManejo,CodManejoInicial, CodManejoFinal, Raca, SglFazendaPai,
  CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae,
  DtaNascimentoInicio, DtaNascimentoFim, DtaCompraInicio, DtaCompraFim,
  CodPessoaSecundaria, CodCategoria, IndAnimalCastrado, CodRegimeAlimentar,
  CodLocal, CodLote, CodTipoLugar, NumIdadePadrao,
  QtdPesoMinimo, QtdPesoMaximo, QtdGPDMinimo, QtdGPDMaximo, QtdGPMMinimo,
  QtdGPMMaximo, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
  QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
  QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
  QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
  QtdCompRacialFim4, Tipo, QtdQuebraRelatorio, -1, -1);
end;

function TAnimais.GerarRelatorioPesagem(CodOrigem: Integer;
  const IndSexoAnimal: WideString; CodAptidao, CodFazendaManejo: Integer;
  const CodAnimalManejoInicio, CodAnimalManejoFim, CodRaca, SglFazendaPai,
  CodAnimalManejoPai, DesApelidoPai, SglFazendaMae,
  CodAnimalManejoMae: WideString; DtaNascimentoInicio, DtaNascimentoFim,
  DtaCompraInicio, DtaCompraFim: TDateTime; CodPessoaSecundaria: Integer;
  const CodCategoria, IndAnimalCastrado: WideString;
  CodRegimeAlimentar: Integer; const CodLote, CodLocal: WideString;
  CodTipoLugar: Integer; DtaPesagemInicio, DtaPesagemFim: TDateTime;
  QtdPesoMinimo, QtdPesoMaximo, QtdGPDMinimo, QtdGPDMaximo, QtdGPMMinimo,
  QtdGPMMaximo: Double; QtdUltimasPesagens: Integer;
  const IndAgrupRaca1: WideString; CodRaca1: Integer; QtdCompRacialInicio1,
  QtdCompRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdCompRacialInicio2, QtdCompRacialFim2: Double;
  const IndAgrupRaca3: WideString; CodRaca3: Integer; QtdCompRacialInicio3,
  QtdCompRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdCompRacialInicio4, QtdCompRacialFim4: Double; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  result := FIntAnimais.GerarRelatorioPesagem(CodOrigem, IndSexoAnimal,
  CodAptidao, CodFazendaManejo, CodAnimalManejoInicio, CodAnimalManejoFim,
  CodRaca, SglFazendaPai, CodAnimalManejoPai, DesApelidoPai, SglFazendaMae,
  CodAnimalManejoMae, DtaNascimentoInicio, DtaNascimentoFim,
  DtaCompraInicio, DtaCompraFim, CodPessoaSecundaria, CodCategoria,
  IndAnimalCastrado, CodRegimeAlimentar, CodLote, CodLocal, CodTipoLugar,
  DtaPesagemInicio, DtaPesagemFim, QtdPesoMinimo, QtdPesoMaximo,
  QtdGPDMinimo, QtdGPDMaximo, QtdGPMMinimo, QtdGPMMaximo,
  QtdUltimasPesagens, IndAgrupRaca1, CodRaca1, QtdCompRacialInicio1,
  QtdCompRacialFim1, IndAgrupRaca2, CodRaca2, QtdCompRacialInicio2,
  QtdCompRacialFim2, IndAgrupRaca3, CodRaca3, QtdCompRacialInicio3,
  QtdCompRacialFim3, IndAgrupRaca4, CodRaca4, QtdCompRacialInicio4,
  QtdCompRacialFim4, Tipo, QtdQuebraRelatorio, -1, -1);
end;

function TAnimais.DefinirComposicaoRacial(CodAnimal, CodRaca: Integer;
  QtdComposicaoRacial: Double): Integer;
begin
  result := FIntAnimais.DefinirComposicaoRacial(CodAnimal, CodRaca,
  QtdComposicaoRacial);
end;

function TAnimais.PesquisarComposicaoRacial(CodAnimal: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntAnimais.PesquisarComposicaoRacial(CodAnimal, CodOrdenacao);
end;

function TAnimais.AlterarAtributo(CodAnimal, CodAtributo: Integer; Valor1,
  Valor2: OleVariant): Integer;
begin
  Result := FIntAnimais.AlterarAtributo(CodAnimal, CodAtributo, Valor1, Valor2);
end;

function TAnimais.CalcularCompRacial(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.CalcularCompRacial(CodAnimal);
end;

function TAnimais.CalcularCompRacialDescendentes(CodAnimal,
  CodAnimalRM: Integer): Integer;
begin
  Result := FIntAnimais.CalcularCompRacialDescendentes(CodAnimal,CodAnimalRM);
end;

function TAnimais.RecalcularTodasCompRacial: Integer;
begin
  Result := FIntAnimais.RecalcularTodasCompRacial;
end;

function TAnimais.LimparComposicaoRacial(CodAnimal: Integer): Integer;
begin
  Result := FIntAnimais.LimparComposicaoRacial(CodAnimal);
end;

function TAnimais.PesquisarGenealogia(const CodAnimais: WideString;
  CodFazendaManejo: Integer; const CodAnimaisManejo: WideString): Integer;
begin
  Result := FIntAnimais.PesquisarGenealogia(CodAnimais, CodFazendaManejo,
            CodAnimaisManejo);
end;

function TAnimais.DefinirDiagnosticoPrenhez(CodEvento: Integer;
  const CodAnimais: WideString; CodFazendaManejo: Integer;
  const CodAnimaisManejo, IndVacasPrenhas: WideString): Integer;
begin
  Result := FIntAnimais.DefinirDiagnosticoPrenhez(CodEvento,
            CodAnimais, CodFazendaManejo, CodAnimaisManejo,
            IndVacasPrenhas);
end;

function TAnimais.DefinirExameAndrologico(CodEvento: Integer;
  const CodAnimais: WideString; CodFazendaManejo: Integer;
  const CodAnimaisManejo, IndTourosAptos: WideString): Integer;
begin
  Result := FIntAnimais.DefinirExameAndrologico(CodEvento,
            CodAnimais, CodFazendaManejo, CodAnimaisManejo,
            IndTourosAptos);
end;

function TAnimais.GerarRelatorioGenealogia(const CodAnimais: WideString;
  CodFazendaManejo: Integer;
  const CodAnimaisManejo: WideString): WideString;
begin
  Result := FIntAnimais.GerarRelatorioGenealogia(CodAnimais, CodFazendaManejo,
    CodAnimaisManejo);
end;

function TAnimais.GerarRelatorioAscendentes(const CodAnimais: WideString;
  CodFazendaManejo: Integer;
  const CodAnimaisManejo: WideString): WideString;
begin
  Result := FIntAnimais.GerarRelatorioAscendentes(CodAnimais, CodFazendaManejo,
    CodAnimaisManejo);
end;

function TAnimais.GerarRelAscendentesPesquisados: WideString;
begin
  Result := FIntAnimais.GerarRelAscendentesPesquisados;
end;

function TAnimais.DefinirAvaliacao(CodEvento, CodAnimal,
  CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
  CodCaracteristicaAvaliacao: Integer; QtdAvalicao: Double): Integer;
begin
  Result := FIntAnimais.DefinirAvaliacao(CodEvento, CodAnimal,
  CodFazendaManejo, CodAnimalManejo, CodCaracteristicaAvaliacao,
  QtdAvalicao);
end;

function TAnimais.RemoverAvaliacao(CodEvento, CodAnimal,
  CodFazendaManejo: Integer; const CodAnimalManejo: WideString): Integer;
begin
  Result := FIntAnimais.RemoverAvaliacao(CodEvento, CodAnimal,
  CodFazendaManejo, CodAnimalManejo);
end;

function TAnimais.PesquisarAvaliacao(CodEvento: Integer): Integer;
begin
  Result := FIntAnimais.PesquisarAvaliacao(CodEvento);
end;

function TAnimais.InserirNascidoParto(CodAnimalMae, CodAnimalPai,
  CodReprodutorMultiplo, CodFazendaManejo: Integer;
  const CodAnimalManejoCria, IndSexo: WideString; CodPelagem: Integer;
  DtaNascimento: TDateTime; const CodSituacaoSisBov: WideString;
  CodEspecie, CodAptidao, CodRaca, CodRegimeAlimentar, CodCategoriaAnimal,
  CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente: Integer; const IndCodSisBovReservado: WideString;
  CodPessoaTecnico: Integer; const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirNascidoParto(CodAnimalMae, CodAnimalPai,
  CodReprodutorMultiplo, CodFazendaManejo, CodAnimalManejoCria, IndSexo,
  CodPelagem, DtaNascimento, CodSituacaoSisBov, CodEspecie, CodAptidao,
  CodRaca, CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
  CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente, IndCodSisBovReservado,
  CodPessoaTecnico, numCNPJCPFTecnico);
end;

function TAnimais.PesquisarPossivelPai(CodEstacaoMonta, CodAnimalFemea,
  CodFazendaManejoFemea: Integer; const CodAnimalManejoFemea: WideString;
  DtaEventoParto: TDateTime): Integer;
begin
  Result := FIntAnimais.PesquisarPossivelPai(CodEstacaoMonta,
  CodAnimalFemea, CodFazendaManejoFemea, CodAnimalManejoFemea,
  DtaEventoParto);
end;

function TAnimais.CancelarEfetivacaoAnimaisPesquisados: Integer;
begin
  Result := FIntAnimais.CancelarEfetivacaoAnimaisPesquisados;
end;

function TAnimais.EfetivarCadastroAnimaisPesquisados: Integer;
begin
  Result := FIntAnimais.EfetivarCadastroAnimaisPesquisados;
end;

function TAnimais.GerarRelatorioAutenticacao(const SglProdutor,
  NomPessoaProdutor, CodOrigens, IndSexo: WideString; CodAptidao,
  CodPaisSisBov, CodEstadoSisBov, CodMicroRegiaoSisBov, CodSisBovInicio,
  CodSisBovFim: Integer; const CodRacas, CodCategorias: WideString;
  DtaInicioNascimento, DtaFimNascimento: TDateTime; CodRegimeAlimentar,
  CodTipoLugar: Integer; DtaInicioAutenticacao, DtaFimAutenticacao,
  DtaInicioAutenticacaoPrevista, DtaFimAutenticacaoPrevista: TDateTime;
  const IndCertificadoEmitido: WideString; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntAnimais.GerarRelatorioAutenticacao(SglProdutor,
    NomPessoaProdutor, CodOrigens, IndSexo, CodAptidao, CodPaisSisBov,
    CodEstadoSisBov, CodMicroRegiaoSisBov, CodSisBovInicio, CodSisBovFim,
    CodRacas, CodCategorias, DtaInicioNascimento, DtaFimNascimento,
    CodRegimeAlimentar, CodTipoLugar, DtaInicioAutenticacao,
    DtaFimAutenticacao, DtaInicioAutenticacaoPrevista,
    DtaFimAutenticacaoPrevista, IndCertificadoEmitido, Tipo,
    QtdQuebraRelatorio);
end;

function TAnimais.MarcarAnimaisComoExportadosPesquisados: Integer;
begin
  Result := FIntAnimais.MarcarAnimaisComoExportadosPesquisados;
end;

function TAnimais.DesmCancAnimaisComoExportadosPesquisados(
  CodProcessamento: Integer): Integer;
begin
  Result := FIntAnimais.DesmCancAnimaisComoExportadosPesquisados(CodProcessamento);
end;

function TAnimais.DesmarcarExportados(CodFazendaManejo: Integer;
  const CodInicialAnimalManejo, CodFinalAnimalManejo,
  CodAnimais: WideString; CodProcessamento: Integer): Integer;
begin
  Result := FIntAnimais.DesmarcarExportados(CodFazendaManejo,
            CodInicialAnimalManejo, CodFinalAnimalManejo,
            CodAnimais, CodProcessamento);
end;

function TAnimais.MarcarExportados(CodFazendaManejo: Integer;
  const CodInicialAnimalManejo, CodFinalAnimalManejo,
  CodAnimais: WideString): Integer;
begin
  Result := FIntAnimais.MarcarExportados(CodFazendaManejo,
                  CodInicialAnimalManejo, CodFinalAnimalManejo,
                  CodAnimais);
end;

function TAnimais.PesquisarAnimalPai(CodFazendaManejo: Integer;
  const CodManejoInicio, CodManejoFim, CodAnimalCertificadora: WideString;
  CodPaisSisBov, CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodSisBovInicio,
  CodSisBovFim: Integer; const CodSituacaoSisBov: WideString;
  DtaNascimentoInicio, DtaNascimentoFim: TDateTime;
  CodFazendaNascimento: Integer; DtaCompraInicio, DtaCompraFim: TDateTime;
  CodPessoaSecundariaCriador: Integer; const NomAnimal,
  DesApelido: WideString; CodAptidao: Integer; const CodRaca, IndSexo,
  CodOrigem, SglFazendaPai, CodAnimalPai, DesApelidoPai, SglFazendaMae,
  CodAnimalMae, IndAnimalCastrado: WideString; CodRegimeAlimentar: Integer;
  const CodCategoria, IndConsiderarExterno: WideString; CodAssociacao,
  CodGrauSangue: Integer; const NumRGD: WideString; CodTipoLugar: Integer;
  const CodLocal, CodLote: WideString; CodFazendaCorrente: Integer;
  const NumImovelCorrente: WideString; CodLocalizacaoCorrente: Integer;
  const NumCPFCNPJCorrente, IndCadastroEfetivado, CodOrdenacao: WideString;
  CodEvento: Integer; const IndEventoAplicado,
  IndAnimaisEvento: WideString; CodReprodutorMultiplo: Integer;
  const IndTrazerComposicaoRacial, IndAgrupRaca1: WideString;
  CodRaca1: Integer; QtdCompRacialIncio1, QtdCompRacialFim1: Double;
  const IndAgrupRaca2: WideString; CodRaca2: Integer; QtdCompRacialInicio2,
  QtdCompRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdCompRacialInicio3, QtdCompRacialFim3: Double;
  const IndAgrupRaca4: WideString; CodRaca4: Integer; QtdCompRacialInicio4,
  QtdCompRacialFim4: Double; const IndAptoCobertura,
  IndAutenticacao: WideString; CodEstacaoMonta: Integer;
  const IndAnimalSemTecnico: WideString;
  CodPessoaTecnico: Integer): Integer;
begin
   Result := FIntAnimais.Pesquisar(CodFazendaManejo, CodManejoInicio,
  CodManejoFim, CodAnimalCertificadora, CodPaisSisBov, CodEstadoSisBov,
  CodMicroRegiaoSisBov, CodSisBovInicio, CodSisBovFim, CodSituacaoSisbov,
  DtaNascimentoInicio, DtaNascimentoFim, CodFazendaNascimento,
  DtaCompraInicio, DtaCompraFim, CodPessoaSecundariaCriador, NomAnimal,
  DesApelido, CodAptidao, CodRaca, IndSexo, CodOrigem, SglFazendaPai,
  CodAnimalPai, DesApelidoPai, SglFazendaMae, CodAnimalMae,
  IndAnimalCastrado, CodRegimeAlimentar, CodCategoria, IndConsiderarExterno,
  CodAssociacao, CodGrauSangue, NumRGD, CodTipoLugar, CodLocal, CodLote,
  CodFazendaCorrente, NumImovelCorrente, CodLocalizacaoCorrente, NumCPFCNPJCorrente,
  IndCadastroEfetivado, CodOrdenacao, CodEvento, IndEventoAplicado, IndAnimaisEvento,
  CodReprodutorMultiplo, IndTrazerComposicaoRacial, IndAgrupRaca1, CodRaca1,
  QtdCompRacialIncio1, QtdCompRacialFim1, IndAgrupRaca2, CodRaca2,
  QtdCompRacialInicio2, QtdCompRacialFim2, IndAgrupRaca3,
  CodRaca3, QtdCompRacialInicio3, QtdCompRacialFim3, IndAgrupRaca4,
  CodRaca4, QtdCompRacialInicio4, QtdCompRacialFim4, IndAptoCobertura, IndAutenticacao,
  CodEstacaoMonta, IndAnimalSemTecnico, CodPessoaTecnico, 'N');
end;

function TAnimais.AlterarTecnico(CodTecnico: Integer;
  const CodAnimais: WideString): Integer;
begin
  Result := FIntAnimais.AlterarTecnico(CodTecnico, CodAnimais);
end;

function TAnimais.AlterarTecnicoAnimaisPesquisados(
  CodTecnico: Integer): Integer;
begin
  Result := FIntAnimais.AlterarTecnicoAnimaisPesquisados(CodTecnico);
end;

function TAnimais.InserirNaoEspecificado(CodFazendaManejo: Integer;
  const CodAnimalManejo, CodAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
  NumDVSisbov: Integer; const CodSituacaoSisBov: WideString;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo: WideString;
  CodFazendaManejoPai: Integer; const CodAnimalPai: WideString;
  CodFazendaManejoMae: Integer; const CodAnimalMae: WideString;
  CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente,
  CodLocalCorrente, CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao: WideString; CodPessoaTecnico: Integer;
  const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirNaoEspecificado(CodFazendaManejo,
    CodAnimalManejo, CodAnimalCertificadora, CodPaisSISBOV,
    CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSISBOV, NumDVSISBOV,
    CodSituacaoSISBOV, DtaIdentificacaoSISBOV, NumImovelIdentificacao,
    CodPropriedadeIdentificacao, CodFazendaIdentificacao, DtaNascimento,
    CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
    CodPosicaoIdentificador2, CodTipoIdentificador3,
    CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca, CodPelagem,
    IndSexo, CodFazendaManejoPai, CodAnimalPai, CodFazendaManejoMae,
    CodAnimalMae, CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
    CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
    CodPropriedadeCorrente, NumCNPJCPFCorrente, CodPessoaCorrente,
    TxtObservacao, CodPessoaTecnico, NumCNPJCPFTecnico);
end;

function TAnimais.AlterarNaoEspecificado(CodAnimal,
  CodFazendaManejo: Integer; const CodAnimalManejo,
  CodAnimalCertificadora: WideString; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSisbov, NumDVSisbov: Integer;
  DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodFazendaNascimento, CodTipoIdentificador1, CodPosicaoIdentificador1,
  CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodRaca, CodPelagem, CodRegimeAlimentar,
  CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao: WideString; CodPessoaTecnico: Integer;
  const IndSexo: WideString): Integer;
begin
  Result := FIntAnimais.AlterarNaoEspecificado(CodAnimal, CodFazendaManejo,
    CodAnimalManejo, CodAnimalCertificadora, CodPaisSISBOV, CodEstadoSISBOV,
    CodMicroRegiaoSISBOV, CodAnimalSISBOV, NumDVSISBOV, DtaIdentificacaoSISBOV,
    NumImovelIdentificacao, CodPropriedadeIdentificacao,
    CodFazendaIdentificacao, DtaNascimento, CodFazendaNascimento,
    CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
    CodPosicaoIdentificador2, CodTipoIdentificador3,
    CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodRaca, CodPelagem, CodRegimeAlimentar,
    CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
    CodFazendaCorrente, CodPropriedadeCorrente,
    NumCNPJCPFCorrente, CodPessoaCorrente, TxtObservacao, CodPessoaTecnico, IndSexo);
end;

function TAnimais.InserirNaoEspecificados(QtdAnimais,
  CodFazendaManejo: Integer; const CodInicialAnimalManejo,
  CodInicialAnimalCertificadora: WideString; CodPaisSisBov,
  CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodInicialAnimalSisbov: Integer;
  const CodSituacaoSisBov: WideString; DtaIdentificacaoSisbov: TDateTime;
  const NumImovelIdentificacao: WideString; CodPropriedadeIdentificacao,
  CodFazendaIdentificacao: Integer; DtaNascimento: TDateTime;
  CodTipoIdentificador1, CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca,
  CodPelagem: Integer; const IndSexo: WideString; CodRegimeAlimentar,
  CodCategoriaAnimal, CodTipoLugar, CodLoteCorrente, CodLocalCorrente,
  CodFazendaCorrente, CodPropriedadeCorrente: Integer;
  const NumCNPJCPFCorrente: WideString; CodPessoaCorrente: Integer;
  const TxtObservacao: WideString; CodPessoaTecnico: Integer;
  const numCNPJCPFTecnico: WideString): Integer;
begin
  Result := FIntAnimais.InserirNaoEspecificados(QtdAnimais, CodFazendaManejo,
    CodInicialAnimalManejo, CodInicialAnimalCertificadora,
    CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodInicialAnimalSISBOV, CodSituacaoSISBOV, DtaIdentificacaoSISBOV,
    NumImovelIdentificacao, CodPropriedadeIdentificacao,
    CodFazendaIdentificacao, DtaNascimento, CodTipoIdentificador1,
    CodPosicaoIdentificador1, CodTipoIdentificador2,
    CodPosicaoIdentificador2, CodTipoIdentificador3,
    CodPosicaoIdentificador3, CodTipoIdentificador4,
    CodPosicaoIdentificador4, CodEspecie, CodAptidao, CodRaca, CodPelagem,
    IndSexo, CodRegimeAlimentar, CodCategoriaAnimal, CodTipoLugar,
    CodLoteCorrente, CodLocalCorrente, CodFazendaCorrente,
    CodPropriedadeCorrente, NumCNPJCPFCorrente, CodPessoaCorrente,
    TxtObservacao, CodPessoaTecnico, NumCNPJCPFTecnico);
end;

function TAnimais.BuscarCaracteristicaAvaliacao(const CodAnimalManejo,
  SglCaracteristicaAvaliacao: WideString): Double;
begin
  Result := FIntAnimais.BuscarCaracteristicaAvaliacao(CodAnimalManejo, SglCaracteristicaAvaliacao);
end;

function TAnimais.BuscarPosicaoAnimalAvaliacaoCaracteristica(NumTela: Integer): Integer;
begin
  Result := FIntAnimais.BuscarPosicaoAnimalAvaliacaoCaracteristica(NumTela);
end;

function TAnimais.GerarRelatorioConsolidacaoCodigosSISBOV(
  const CodProdutor, NumCNPJCPFProdutor, NomProdutor,
  NumImovelReceitaFederal: WideString; CodExportacao: Integer;
  const NomPropriedadeRural, NomMunicipioPropriedade: WideString;
  SglEstadoPropriedade: Integer; DtaInicioIdentificacaoAnimal,
  DtaFimIdentificacaoAnimal: TDateTime; const NomPessoaTecnico,
  numCNPJCPFTecnico: WideString; TipoRelatorio: Integer): WideString;
begin
  Result := FIntAnimais.GerarRelatorioConsolidacaoCodigosSISBOV(CodProdutor,
                                                                NumCNPJCPFProdutor,
                                                                NomProdutor,
                                                                NumImovelReceitaFederal,
                                                                CodExportacao,
                                                                NomPropriedadeRural,
                                                                NomMunicipioPropriedade,
                                                                SglEstadoPropriedade,
                                                                DtaInicioIdentificacaoAnimal,
                                                                DtaFimIdentificacaoAnimal,
                                                                NomPessoaTecnico,
                                                                numCNPJCPFTecnico,
                                                                TipoRelatorio,
                                                                -1);
end;

function TAnimais.InventariarAnimaisPesquisados(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntAnimais.InventariarAnimaisPesquisados(CodPessoaProdutor, CodPropriedadeRural);
end;

function TAnimais.ExcluirInventarioAnimaisPesquisados(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntAnimais.ExcluirInventarioAnimaisPesquisados(CodPessoaProdutor, CodPropriedadeRural);
end;

function TAnimais.AlterarAnimalTmp(const PdataIdentificacaoSisbov,
  PdataNascimento, PNumRgd, PCodIdPropriedadeSISBOV, PCodRacaSisbov,
  PCodIdentificadorSisbov, PSexo,PCodSISBOV: WideString): Integer;
begin
  FIntAnimais.AlterarAnimalTmp(PdataIdentificacaoSisbov, PdataNascimento,
  PNumRgd, PCodIdPropriedadeSISBOV, PCodSISBOV, PCodRacaSisbov,
  PCodIdentificadorSISBOV, PSexo);
end;

function TAnimais.AtualizarDataAbate(CodPessoaProdutor,
  CodFazenda: integer): integer;
begin
  result  :=  FIntAnimais.AtualizarDataAbate(CodPessoaProdutor,CodFazenda);
end;

function TAnimais.SolicitarAlteracaoPosse(CodPropriedadeRural,
  CodProdutorOrigem, CodProdutorDestino, CodMotivoSolicitacao: Integer;
  const Justificativa, NumeracaoEnvio: WideString): Integer;
begin
  result  :=  FIntAnimais.solicitarAlteracaoPosse(CodPropriedadeRural,CodProdutorOrigem,CodProdutorDestino,CodMotivoSolicitacao,Justificativa,NumeracaoEnvio);
end;

function TAnimais.ConsultarAnimaisAbatidos(CodFrigorifico: Integer;
  const Data: WideString): Integer;
begin
  result  :=  FIntAnimais.ConsultarAnimaisAbatidos(CodFrigorifico,Data);
end;

function TAnimais.BuscaNumDvSISBOV(CodPaisSisbov, CodEstadoSisBov,
  CodMicroRegiaoSisBov, CodAnimalSisbov: Integer): Integer;
begin
  result  :=  uferramentas.BuscarDVSisBov(CodPaisSisbov,CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalSisbov);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnimais, Class_Animais, ciMultiInstance, tmApartment);
end.
