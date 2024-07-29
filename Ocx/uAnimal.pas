// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/08/2002
// *  Documentação       : Animais - Definição das Classes.doc
// *  Código Classe      : 33
// *  Descrição Resumida : Cadastro de Animais
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    23/08/2002    Criação
// *   Hitalo   23/08/2002    Adiconar Propriedades(Tipo Identificador,Posicao Identificador)
// *
// ********************************************************************
unit uAnimal;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAnimal = class(TASPMTSObject, IAnimal)
  private
    FCodPessoaProdutor: Integer;
    FNomPessoaProdutor: WideString;
    FCodAnimal: Integer;
    FCodFazendaManejo: Integer;
    FSglFazendaManejo: WideString;
    FCodAnimalManejo: WideString;
    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;
    FNomAnimal: WideString;
    FDesApelido: WideString;
    FCodRaca: Integer;
    FSglRaca: WideString;
    FDesRaca: WideString;
    FCodPelagem: Integer;
    FSglPelagem: WideString;
    FDesPelagem: WideString;
    FIndSexo: WideString;
    FCodTipoOrigem: Integer;
    FSglTipoOrigem: WideString;
    FDesTipoOrigem: WideString;
    FDtaNascimento: TDateTime;
    FDtaCompra: TDateTime;
    FCodAnimalPai: Integer;
    FSglFazendaAnimalPai: WideString;
    FCodManejoAnimalPai: WideString;
    FCodAnimalMae: Integer;
    FSglFazendaAnimalMae: WideString;
    FCodManejoAnimalMae: WideString;
    FCodAnimalReceptor: Integer;
    FSglFazendaAnimalReceptor: WideString;
    FCodManejoAnimalReceptor: WideString;
    FIndAnimalCastrado: WideString;
    FCodRegimeAlimentar: Integer;
    FSglRegimeAlimentar: WideString;
    FDesRegimeAlimentar: WideString;
    FCodCategoriaAnimal: Integer;
    FSglCategoriaAnimal: WideString;
    FDesCategoriaAnimal: WideString;
    FCodFazendaCorrente: Integer;
    FSglFazendaCorrente: WideString;
    FNomFazendaCorrente: WideString;
    FCodLocalCorrente: Integer;
    FSglLocalCorrente: WideString;
    FDesLocalCorrente: WideString;
    FCodLoteCorrente: Integer;
    FSglLoteCorrente: WideString;
    FDesLoteCorrente: WideString;
    FTxtObservacao: WideString;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FDtaUltimoEvento: TDateTime;
    FCodAssociacaoRaca: Integer;
    FSglAssociacaoRaca: WideString;
    FCodGrauSangue: Integer;
    FSglGrauSangue: WideString;
    FNumRGD: WideString;
    FCodAnimalCertificadora: WideString;
    FCodSituacaoSisbov: WideString;
    FDesSituacaoSisbov: WideString;
    FTxtSituacaoSisbov: WideString;
    FDtaIdentificacaoSisbov: TDateTime;
    FNumImovelIdentificacao: WideString;
    FCodLocalizacaoIdentificacao: Integer;
    FCodPropriedadeIdentificacao: Integer;
    FNomPropriedadeIdentificacao: WideString;
    FCodFazendaIdentificacao: Integer;
    FSglFazendaIdentificacao: WideString;
    FNomFazendaIdentificacao: WideString;
    FNumImovelNascimento: WideString;
    FCodLocalizacaoNascimento: Integer;
    FCodPropriedadeNascimento: Integer;
    FNomPropriedadeNascimento: WideString;
    FCodFazendaNascimento: Integer;
    FSglFazendaNascimento: WideString;
    FNomFazendaNascimento: WideString;
    FCodPessoaSecundariaCriador: Integer;
    FNomPessoaSecundariaCriador: WideString;
    FCodEspecie: Integer;
    FSglEspecie: WideString;
    FDesEspecie: WideString;
    FCodAptidao: Integer;
    FSglAptidao: WideString;
    FDesAptidao: WideString;
    FNumImovelCorrente: WideString;
    FCodLocalizacaoCorrente: Integer;
    FCodPropriedadeCorrente: Integer;
    FNomPropriedadeCorrente: WideString;
    FCodPessoCorrente: Integer;
    FCodPessoaCorrente : Integer; 
    FNomPessoaCorrente: WideString;
    FNumCNPJCPFCorrente: WideString;
    FNumCNPJCPFCorrenteFormatado: WideString;
    FCodPaisOrigem: Integer;
    FNomPaisOrigem: WideString;
    FDesPropriedadeOrigem: WideString;
    FDtaAutorizacaoImportacao: TDateTime;
    FDtaEntradaPais: TDateTime;
    FNumGuiaImportacao: WideString;
    FNumLicencaImportacao: WideString;
    FCodArquivoSisbov: Integer;
    FDtaGravacaoSisbov: TDateTime;
    FNomArquivoSisbov: WideString;
    FCodTipoLugar: Integer;
    FSglTipoLugar: WideString;
    FDesTipoLugar: WideString;
    FNumTransponder : WideString;
    FCodTipoIdentificador1 : Integer;
    FSglTipoIdentificador1 : WideString;
    FDesTipoIdentificador1 : WideString;
    FCodPosicaoIdentificador1 : Integer;
    FSglPosicaoIdentificador1 : WideString;
    FDesPosicaoIdentificador1 : WideString;

    FCodTipoIdentificador2 : Integer;
    FSglTipoIdentificador2 : WideString;
    FDesTipoIdentificador2 : WideString;
    FCodPosicaoIdentificador2 : Integer;
    FSglPosicaoIdentificador2 : WideString;
    FDesPosicaoIdentificador2 : WideString;

    FCodTipoIdentificador3 : Integer;
    FSglTipoIdentificador3 : WideString;
    FDesTipoIdentificador3 : WideString;
    FCodPosicaoIdentificador3 : Integer;
    FSglPosicaoIdentificador3 : WideString;
    FDesPosicaoIdentificador3 : WideString;

    FCodTipoIdentificador4 : Integer;
    FSglTipoIdentificador4 : WideString;
    FDesTipoIdentificador4 : WideString;
    FCodPosicaoIdentificador4 : Integer;
    FSglPosicaoIdentificador4 : WideString;
    FDesPosicaoIdentificador4 : WideString;
    FIndPessoaSecundaria      : WideString;

    FNomAssociacaoRaca      : WideString;
    FDesGrauSangue          : WideString;

    FNumGta                 : WideString;
    FDtaEmissaoGta          : TDateTime;
    FNumNotaFiscal          : Integer;

    FNomMunicipioIdentificacao : WideString;
    FSglEstadoIdentificacao    : WideString;
    FNomMunicipioNascimento    : WideString;
    FSglEstadoNascimento       : WideString;

    FDesComposicaoRacial       : WideString;
    FIndAptoCobertura          : WideString;
    FIndCadastroParto          : WideString;
    FIndCodSisBovReservado     : WideString;

    FCodPessoaTecnico          : Integer;
    FNomPessoaTecnico          : WideString;

    FNomPessoaVendedor:        WideString;
  protected
    function Get_CodAnimal: Integer; safecall;
    function Get_CodAnimalManejo: WideString; safecall;
    function Get_CodAnimalSisbov: Integer; safecall;
    function Get_CodEstadoSisbov: Integer; safecall;
    function Get_CodFazendaManejo: Integer; safecall;
    function Get_CodMicroRegiaoSisbov: Integer; safecall;
    function Get_CodPaisSisbov: Integer; safecall;
    function Get_CodPelagem: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodRaca: Integer; safecall;
    function Get_CodTipoOrigem: Integer; safecall;
    function Get_DesApelido: WideString; safecall;
    function Get_DesPelagem: WideString; safecall;
    function Get_DesRaca: WideString; safecall;
    function Get_DesTipoOrigem: WideString; safecall;
    function Get_IndSexo: WideString; safecall;
    function Get_NomAnimal: WideString; safecall;
    function Get_NumDVSisbov: Integer; safecall;
    function Get_SglFazendaManejo: WideString; safecall;
    function Get_SglPelagem: WideString; safecall;
    function Get_SglRaca: WideString; safecall;
    function Get_SglTipoOrigem: WideString; safecall;
    procedure Set_CodAnimal(Value: Integer); safecall;
    procedure Set_CodAnimalManejo(const Value: WideString); safecall;
    procedure Set_CodAnimalSisbov(Value: Integer); safecall;
    procedure Set_CodEstadoSisbov(Value: Integer); safecall;
    procedure Set_CodFazendaManejo(Value: Integer); safecall;
    procedure Set_CodMicroRegiaoSisbov(Value: Integer); safecall;
    procedure Set_CodPaisSisbov(Value: Integer); safecall;
    procedure Set_CodPelagem(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodRaca(Value: Integer); safecall;
    procedure Set_CodTipoOrigem(Value: Integer); safecall;
    procedure Set_DesApelido(const Value: WideString); safecall;
    procedure Set_DesPelagem(const Value: WideString); safecall;
    procedure Set_DesRaca(const Value: WideString); safecall;
    procedure Set_DesTipoOrigem(const Value: WideString); safecall;
    procedure Set_IndSexo(const Value: WideString); safecall;
    procedure Set_NomAnimal(const Value: WideString); safecall;
    procedure Set_NumDVSisbov(Value: Integer); safecall;
    procedure Set_SglFazendaManejo(const Value: WideString); safecall;
    procedure Set_SglPelagem(const Value: WideString); safecall;
    procedure Set_SglRaca(const Value: WideString); safecall;
    procedure Set_SglTipoOrigem(const Value: WideString); safecall;
    function Get_CodAnimalMae: Integer; safecall;
    function Get_CodAnimalPai: Integer; safecall;
    function Get_CodAnimalReceptor: Integer; safecall;
    function Get_CodCategoriaAnimal: Integer; safecall;
    function Get_CodFazendaCorrente: Integer; safecall;
    function Get_CodLocalCorrente: Integer; safecall;
    function Get_CodManejoAnimalMae: WideString; safecall;
    function Get_CodManejoAnimalPai: WideString; safecall;
    function Get_CodManejoAnimalReceptor: WideString; safecall;
    function Get_CodRegimeAlimentar: Integer; safecall;
    function Get_DesCategoriaAnimal: WideString; safecall;
    function Get_DesRegimeAlimentar: WideString; safecall;
    function Get_DtaCompra: TDateTime; safecall;
    function Get_DtaNascimento: TDateTime; safecall;
    function Get_IndAnimalCastrado: WideString; safecall;
    function Get_NomFazendaCorrente: WideString; safecall;
    function Get_DesLocalCorrente: WideString; safecall;
    function Get_SglCategoriaAnimal: WideString; safecall;
    function Get_SglFazendaAnimalMae: WideString; safecall;
    function Get_SglFazendaAnimalPai: WideString; safecall;
    function Get_SglFazendaAnimalReceptor: WideString; safecall;
    function Get_SglFazendaCorrente: WideString; safecall;
    function Get_SglLocalCorrente: WideString; safecall;
    function Get_SglRegimeAlimentar: WideString; safecall;
    procedure Set_CodAnimalMae(Value: Integer); safecall;
    procedure Set_CodAnimalPai(Value: Integer); safecall;
    procedure Set_CodAnimalReceptor(Value: Integer); safecall;
    procedure Set_CodCategoriaAnimal(Value: Integer); safecall;
    procedure Set_CodFazendaCorrente(Value: Integer); safecall;
    procedure Set_CodLocalCorrente(Value: Integer); safecall;
    procedure Set_CodManejoAnimalMae(const Value: WideString); safecall;
    procedure Set_CodManejoAnimalPai(const Value: WideString); safecall;
    procedure Set_CodManejoAnimalReceptor(const Value: WideString); safecall;
    procedure Set_CodRegimeAlimentar(Value: Integer); safecall;
    procedure Set_DesCategoriaAnimal(const Value: WideString); safecall;
    procedure Set_DesRegimeAlimentar(const Value: WideString); safecall;
    procedure Set_DtaCompra(Value: TDateTime); safecall;
    procedure Set_DtaNascimento(Value: TDateTime); safecall;
    procedure Set_IndAnimalCastrado(const Value: WideString); safecall;
    procedure Set_NomFazendaCorrente(const Value: WideString); safecall;
    procedure Set_DesLocalCorrente(const Value: WideString); safecall;
    procedure Set_SglCategoriaAnimal(const Value: WideString); safecall;
    procedure Set_SglFazendaAnimalMae(const Value: WideString); safecall;
    procedure Set_SglFazendaAnimalPai(const Value: WideString); safecall;
    procedure Set_SglFazendaAnimalReceptor(const Value: WideString); safecall;
    procedure Set_SglFazendaCorrente(const Value: WideString); safecall;
    procedure Set_SglLocalCorrente(const Value: WideString); safecall;
    procedure Set_SglRegimeAlimentar(const Value: WideString); safecall;
    function Get_CodAssociacaoRaca: Integer; safecall;
    function Get_CodGrauSangue: Integer; safecall;
    function Get_CodLoteCorrente: Integer; safecall;
    function Get_DesLoteCorrente: WideString; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_DtaUltimoEvento: TDateTime; safecall;
    function Get_NumRGD: WideString; safecall;
    function Get_SglAssociacaoRaca: WideString; safecall;
    function Get_SglGrauSangue: WideString; safecall;
    function Get_SglLoteCorrente: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_CodAssociacaoRaca(Value: Integer); safecall;
    procedure Set_CodGrauSangue(Value: Integer); safecall;
    procedure Set_CodLoteCorrente(Value: Integer); safecall;
    procedure Set_DesLoteCorrente(const Value: WideString); safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_DtaEfetivacaoCadastro(Value: TDateTime); safecall;
    procedure Set_DtaUltimoEvento(Value: TDateTime); safecall;
    procedure Set_NumRGD(const Value: WideString); safecall;
    procedure Set_SglAssociacaoRaca(const Value: WideString); safecall;
    procedure Set_SglGrauSangue(const Value: WideString); safecall;
    procedure Set_SglLoteCorrente(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_CodAnimalCertificadora: WideString; safecall;
    procedure Set_CodAnimalCertificadora(const Value: WideString); safecall;
    function Get_CodSituacaoSisbov: WideString; safecall;
    procedure Set_CodSituacaoSisbov(const Value: WideString); safecall;
    function Get_DesSituacaoSisbov: WideString; safecall;
    procedure Set_DesSituacaoSisbov(const Value: WideString); safecall;
    function Get_DtaIdentificacaoSisbov: TDateTime; safecall;
    procedure Set_DtaIdentificacaoSisbov(Value: TDateTime); safecall;
    function Get_NumImovelIdentificacao: WideString; safecall;
    procedure Set_NumImovelIdentificacao(const Value: WideString); safecall;
    function Get_CodPropriedadeIdentificacao: Integer; safecall;
    procedure Set_CodPropriedadeIdentificacao(Value: Integer); safecall;
    function Get_NomPropriedadeIdentificacao: WideString; safecall;
    procedure Set_NomPropriedadeIdentificacao(const Value: WideString);
      safecall;
    function Get_CodFazendaIdentificacao: Integer; safecall;
    procedure Set_CodFazendaIdentificacao(Value: Integer); safecall;
    function Get_SglFazendaIdentificacao: WideString; safecall;
    procedure Set_SglFazendaIdentificacao(const Value: WideString); safecall;
    function Get_NomFazendaIdentificacao: WideString; safecall;
    procedure Set_NomFazendaIdentificacao(const Value: WideString); safecall;
    function Get_NumImovelNascimento: WideString; safecall;
    procedure Set_NumImovelNascimento(const Value: WideString); safecall;
    function Get_CodPropriedadeNascimento: Integer; safecall;
    procedure Set_CodPropriedadeNascimento(Value: Integer); safecall;
    function Get_NomPropriedadeNascimento: WideString; safecall;
    procedure Set_NomPropriedadeNascimento(const Value: WideString); safecall;
    function Get_CodFazendaNascimento: Integer; safecall;
    procedure Set_CodFazendaNascimento(Value: Integer); safecall;
    function Get_SglFazendaNascimento: WideString; safecall;
    procedure Set_SglFazendaNascimento(const Value: WideString); safecall;
    function Get_NomFazendaNascimento: WideString; safecall;
    procedure Set_NomFazendaNascimento(const Value: WideString); safecall;
    function Get_CodPessoaSecundariaCriador: Integer; safecall;
    procedure Set_CodPessoaSecundariaCriador(Value: Integer); safecall;
    function Get_NomPessoaSecundariaCriador: WideString; safecall;
    procedure Set_NomPessoaSecundariaCriador(const Value: WideString);
      safecall;
    function Get_CodEspecie: Integer; safecall;
    procedure Set_CodEspecie(Value: Integer); safecall;
    function Get_SglEspecie: WideString; safecall;
    procedure Set_SglEspecie(const Value: WideString); safecall;
    function Get_DesEspecie: WideString; safecall;
    procedure Set_DesEspecie(const Value: WideString); safecall;
    function Get_CodAptidao: Integer; safecall;
    procedure Set_CodAptidao(Value: Integer); safecall;
    function Get_SglAptidao: WideString; safecall;
    procedure Set_SglAptidao(const Value: WideString); safecall;
    function Get_DesAptidao: WideString; safecall;
    procedure Set_DesAptidao(const Value: WideString); safecall;
    function Get_NumImovelCorrente: WideString; safecall;
    procedure Set_NumImovelCorrente(const Value: WideString); safecall;
    function Get_CodPropriedadeCorrente: Integer; safecall;
    procedure Set_CodPropriedadeCorrente(Value: Integer); safecall;
    function Get_CodPessoCorrente: Integer; safecall;
    procedure Set_CodPessoCorrente(Value: Integer); safecall;
    function Get_NomPessoaCorrente: WideString; safecall;
    procedure Set_NomPessoaCorrente(const Value: WideString); safecall;
    function Get_NumCNPJCPFCorrente: WideString; safecall;
    procedure Set_NumCNPJCPFCorrente(const Value: WideString); safecall;
    function Get_NumCNPJCPFCorrenteFormatado: WideString; safecall;
    procedure Set_NumCNPJCPFCorrenteFormatado(const Value: WideString);
      safecall;
    function Get_CodPaisOrigem: Integer; safecall;
    procedure Set_CodPaisOrigem(Value: Integer); safecall;
    function Get_NomPaisOrigem: WideString; safecall;
    procedure Set_NomPaisOrigem(const Value: WideString); safecall;
    function Get_DesPropriedadeOrigem: WideString; safecall;
    procedure Set_DesPropriedadeOrigem(const Value: WideString); safecall;
    function Get_DtaAutorizacaoImportacao: TDateTime; safecall;
    procedure Set_DtaAutorizacaoImportacao(Value: TDateTime); safecall;
    function Get_DtaEntradaPais: TDateTime; safecall;
    procedure Set_DtaEntradaPais(Value: TDateTime); safecall;
    function Get_NumGuiaImportacao: WideString; safecall;
    procedure Set_NumGuiaImportacao(const Value: WideString); safecall;
    function Get_NumLicencaImportacao: WideString; safecall;
    procedure Set_NumLicencaImportacao(const Value: WideString); safecall;
    function Get_CodArquivoSisbov: Integer; safecall;
    procedure Set_CodArquivoSisbov(Value: Integer); safecall;
    function Get_DtaGravacaoSisbov: TDateTime; safecall;
    procedure Set_DtaGravacaoSisbov(Value: TDateTime); safecall;
    function Get_NomArquivoSisbov: WideString; safecall;
    procedure Set_NomArquivoSisbov(const Value: WideString); safecall;
    function Get_CodTipoLugar: Integer; safecall;
    function Get_DesTipoLugar: WideString; safecall;
    function Get_SglTipoLugar: WideString; safecall;
    procedure Set_CodTipoLugar(Value: Integer); safecall;
    procedure Set_DesTipoLugar(const Value: WideString); safecall;
    procedure Set_SglTipoLugar(const Value: WideString); safecall;
    function Get_TxtSituacaoSisBov: WideString; safecall;
    procedure Set_TxtSituacaoSisBov(const Value: WideString); safecall;
    function Get_NumTransponder: WideString; safecall;
    procedure Set_NumTransponder(const Value: WideString); safecall;
    function Get_CodTipoIdentificador1: Integer; safecall;
    function Get_SglTipoIdentificador1: WideString; safecall;
    procedure Set_CodTipoIdentificador1(Value: Integer); safecall;
    procedure Set_SglTipoIdentificador1(const Value: WideString); safecall;
    function Get_DesTipoIdentificador1: WideString; safecall;
    procedure Set_DesTipoIdentificador1(const Value: WideString); safecall;
    function Get_CodPosicaoIdentificador1: Integer; safecall;
    procedure Set_CodPosicaoIdentificador1(Value: Integer); safecall;
    function Get_SglPosicaoIdentificador1: WideString; safecall;
    procedure Set_SglPosicaoIdentificador1(const Value: WideString); safecall;
    function Get_DesPosicaoIdentificador1: WideString; safecall;
    procedure Set_DesPosicaoIdentificador1(const Value: WideString); safecall;
    function Get_CodTipoIdentificador2: Integer; safecall;
    function Get_DesTipoIdentificador2: WideString; safecall;
    function Get_SglTipoIdentificador2: WideString; safecall;
    procedure Set_CodTipoIdentificador2(Value: Integer); safecall;
    procedure Set_DesTipoIdentificador2(const Value: WideString); safecall;
    procedure Set_SglTipoIdentificador2(const Value: WideString); safecall;
    function Get_CodPosicaoIdentificador2: Integer; safecall;
    procedure Set_CodPosicaoIdentificador2(Value: Integer); safecall;
    function Get_SglPosicaoIdentificador2: WideString; safecall;
    procedure Set_SglPosicaoIdentificador2(const Value: WideString); safecall;
    function Get_DesPosicaoIdentificador2: WideString; safecall;
    procedure Set_DesPosicaoIdentificador2(const Value: WideString); safecall;
    function Get_CodTipoIdentificador3: Integer; safecall;
    procedure Set_CodTipoIdentificador3(Value: Integer); safecall;
    function Get_SglTipoIdentificador3: WideString; safecall;
    procedure Set_SglTipoIdentificador3(const Value: WideString); safecall;
    function Get_DesTipoIdentificador3: WideString; safecall;
    procedure Set_DesTipoIdentificador3(const Value: WideString); safecall;
    function Get_CodPosicaoIdentificador3: Integer; safecall;
    function Get_DesPosicaoIdentificador3: WideString; safecall;
    function Get_SglPosicaoIdentificador3: WideString; safecall;
    procedure Set_CodPosicaoIdentificador3(Value: Integer); safecall;
    procedure Set_DesPosicaoIdentificador3(const Value: WideString); safecall;
    procedure Set_SglPosicaoIdentificador3(const Value: WideString); safecall;
    function Get_CodTipoIdentificador4: Integer; safecall;
    procedure Set_CodTipoIdentificador4(Value: Integer); safecall;
    function Get_SglTipoIdentificador4: WideString; safecall;
    procedure Set_SglTipoIdentificador4(const Value: WideString); safecall;
    function Get_CodPosicaoIdentificador4: Integer; safecall;
    function Get_DesTipoIdentificador4: WideString; safecall;
    procedure Set_CodPosicaoIdentificador4(Value: Integer); safecall;
    procedure Set_DesTipoIdentificador4(const Value: WideString); safecall;
    function Get_SglPosicaoIdentificador4: WideString; safecall;
    procedure Set_SglPosicaoIdentificador4(const Value: WideString); safecall;
    function Get_DesPosicaoIdentificador4: WideString; safecall;
    procedure Set_DesPosicaoIdentificador4(const Value: WideString); safecall;
    function Get_NomPropriedadeCorrente: WideString; safecall;
    procedure Set_NomPropriedadeCorrente(const Value: WideString); safecall;
    function Get_CodPessoaCorrente: Integer; safecall;
    procedure Set_CodPessoaCorrente(Value: Integer); safecall;
    function Get_IndPessoaSecundaria: WideString; safecall;
    procedure Set_IndPessoaSecundaria(const Value: WideString); safecall;
    function Get_NomAssociacaoRaca: WideString; safecall;
    procedure Set_NomAssociacaoRaca(const Value: WideString); safecall;
    function Get_DesGrauSangue: WideString; safecall;
    procedure Set_DesGrauSangue(const Value: WideString); safecall;
    function Get_NumGta: WideString; safecall;
    procedure Set_NumGta(const Value: WideString); safecall;
    function Get_DtaEmissaoGta: TDateTime; safecall;
    procedure Set_DtaEmissaoGta(Value: TDateTime); safecall;
    function Get_NumNotaFiscal: Integer; safecall;
    procedure Set_NumNotaFiscal(Value: Integer); safecall;
    function Get_NomMunicipioIdentificacao: WideString; safecall;
    function Get_SglEstadoIdentificacao: WideString; safecall;
    procedure Set_NomMunicipioIdentificacao(const Value: WideString); safecall;
    procedure Set_SglEstadoIdentificacao(const Value: WideString); safecall;
    function Get_NomMunicipioNascimento: WideString; safecall;
    function Get_SglEstadoNascimento: WideString; safecall;
    procedure Set_NomMunicipioNascimento(const Value: WideString); safecall;
    procedure Set_SglEstadoNascimento(const Value: WideString); safecall;
    function Get_DesComposicaoRacial: WideString; safecall;
    procedure Set_DesComposicaoRacial(const Value: WideString); safecall;
    function Get_IndAptoCobertura: WideString; safecall;
    procedure Set_IndAptoCobertura(const Value: WideString); safecall;
    function Get_IndCadastroParto: WideString; safecall;
    procedure Set_IndCadastroParto(const Value: WideString); safecall;
    function Get_IndCodSisBovReservado: WideString; safecall;
    procedure Set_IndCodSisBovReservado(const Value: WideString); safecall;
    function Get_CodPessoaTecnico: Integer; safecall;
    function Get_NomPessoaTecnico: WideString; safecall;
    procedure Set_CodPessoaTecnico(Value: Integer); safecall;
    procedure Set_NomPessoaTecnico(const Value: WideString); safecall;
    function Get_CodLocalizacaoCorrente: Integer; safecall;
    function Get_CodLocalizacaoIdentificacao: Integer; safecall;
    function Get_CodLocalizacaoNascimento: Integer; safecall;
    procedure Set_CodLocalizacaoCorrente(Value: Integer); safecall;
    procedure Set_CodLocalizacaoIdentificacao(Value: Integer); safecall;
    procedure Set_CodLocalizacaoNascimento(Value: Integer); safecall;
    function Get_NomPessoaVendedor: WideString; safecall;
    procedure Set_NomPessoaVendedor(const Value: WideString); safecall;
    function Get_NomPessoaProdutor: WideString; safecall;
    procedure Set_NomPessoaProdutor(const Value: WideString); safecall;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodFazendaManejo: Integer read FCodFazendaManejo write FCodFazendaManejo;
    property SglFazendaManejo: WideString read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: WideString read FCodAnimalManejo write FCodAnimalManejo;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;
    property NomAnimal: WideString read FNomAnimal write FNomAnimal;
    property DesApelido: WideString read FDesApelido write FDesApelido;
    property CodRaca: Integer read FCodRaca write FCodRaca;
    property SglRaca: WideString read FSglRaca write FSglRaca;
    property DesRaca: WideString read FDesRaca write FDesRaca;
    property CodPelagem: Integer read FCodPelagem write FCodPelagem;
    property SglPelagem: WideString read FSglPelagem write FSglPelagem;
    property DesPelagem: WideString read FDesPelagem write FDesPelagem;
    property IndSexo: WideString read FIndSexo write FIndSexo;
    property CodTipoOrigem: Integer read FCodTipoOrigem write FCodTipoOrigem;
    property SglTipoOrigem: WideString read FSglTipoOrigem write FSglTipoOrigem;
    property DesTipoOrigem: WideString read FDesTipoOrigem write FDesTipoOrigem;
    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property DtaCompra: TDateTime read FDtaCompra write FDtaCompra;
    property CodAnimalPai: Integer read FCodAnimalPai write FCodAnimalPai;
    property SglFazendaAnimalPai: WideString read FSglFazendaAnimalPai write FSglFazendaAnimalPai;
    property CodManejoAnimalPai: WideString read FCodManejoAnimalPai write FCodManejoAnimalPai;
    property CodAnimalMae: Integer read FCodAnimalMae write FCodAnimalMae;
    property SglFazendaAnimalMae: WideString read FSglFazendaAnimalMae write FSglFazendaAnimalMae;
    property CodManejoAnimalMae: WideString read FCodManejoAnimalMae write FCodManejoAnimalMae;
    property CodAnimalReceptor: Integer read FCodAnimalReceptor write FCodAnimalReceptor;
    property SglFazendaAnimalReceptor: WideString read FSglFazendaAnimalReceptor write FSglFazendaAnimalReceptor;
    property CodManejoAnimalReceptor: WideString read FCodManejoAnimalReceptor write FCodManejoAnimalReceptor;
    property IndAnimalCastrado: WideString read FIndAnimalCastrado write FIndAnimalCastrado;
    property CodRegimeAlimentar: Integer read FCodRegimeAlimentar write FCodRegimeAlimentar;
    property SglRegimeAlimentar: WideString read FSglRegimeAlimentar write FSglRegimeAlimentar;
    property DesRegimeAlimentar: WideString read FDesRegimeAlimentar write FDesRegimeAlimentar;
    property CodCategoriaAnimal: Integer read FCodCategoriaAnimal write FCodCategoriaAnimal;
    property SglCategoriaAnimal: WideString read FSglCategoriaAnimal write FSglCategoriaAnimal;
    property DesCategoriaAnimal: WideString read FDesCategoriaAnimal write FDesCategoriaAnimal;
    property CodFazendaCorrente: Integer read FCodFazendaCorrente write FCodFazendaCorrente;
    property SglFazendaCorrente: WideString read FSglFazendaCorrente write FSglFazendaCorrente;
    property NomFazendaCorrente: WideString read FNomFazendaCorrente write FNomFazendaCorrente;
    property CodLocalCorrente: Integer read FCodLocalCorrente write FCodLocalCorrente;
    property SglLocalCorrente: WideString read FSglLocalCorrente write FSglLocalCorrente;
    property DesLocalCorrente: WideString read FDesLocalCorrente write FDesLocalCorrente;
    property CodLoteCorrente: Integer read FCodLoteCorrente write FCodLoteCorrente;
    property SglLoteCorrente: WideString read FSglLoteCorrente write FSglLoteCorrente;
    property DesLoteCorrente: WideString read FDesLoteCorrente write FDesLoteCorrente;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property DtaUltimoEvento: TDateTime read FDtaUltimoEvento write FDtaUltimoEvento;
    property CodAssociacaoRaca: Integer read FCodAssociacaoRaca write FCodAssociacaoRaca;
    property SglAssociacaoRaca: WideString read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property CodGrauSangue: Integer read FCodGrauSangue write FCodGrauSangue;
    property SglGrauSangue: WideString read FSglGrauSangue write FSglGrauSangue;
    property NumRGD: WideString read FNumRGD write FNumRGD;
    property CodAnimalCertificadora: WideString read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property CodSituacaoSisbov: WideString read FCodSituacaoSisbov write FCodSituacaoSisbov;
    property DesSituacaoSisbov: WideString read FDesSituacaoSisbov write FDesSituacaoSisbov;
    property TxtSituacaoSisbov: WideString read FTxtSituacaoSisbov write FTxtSituacaoSisbov;    
    property DtaIdentificacaoSisbov: TDateTime read FDtaIdentificacaoSisbov write FDtaIdentificacaoSisbov;
    property NumImovelIdentificacao: WideString read FNumImovelIdentificacao write FNumImovelIdentificacao;
    property CodLocalizacaoIdentificacao: Integer read FCodLocalizacaoIdentificacao write FCodLocalizacaoIdentificacao;
    property CodPropriedadeIdentificacao: Integer read FCodPropriedadeIdentificacao write FCodPropriedadeIdentificacao;
    property NomPropriedadeIdentificacao: WideString read FNomPropriedadeIdentificacao write FNomPropriedadeIdentificacao;
    property CodFazendaIdentificacao: Integer read FCodFazendaIdentificacao write FCodFazendaIdentificacao;
    property SglFazendaIdentificacao: WideString read FSglFazendaIdentificacao write FSglFazendaIdentificacao;
    property NomFazendaIdentificacao: WideString read FNomFazendaIdentificacao write FNomFazendaIdentificacao;
    property NumImovelNascimento: WideString read FNumImovelNascimento write FNumImovelNascimento;
    property CodLocalizacaoNascimento: Integer read FCodLocalizacaoNascimento write FCodLocalizacaoNascimento;
    property CodPropriedadeNascimento: Integer read FCodPropriedadeNascimento write FCodPropriedadeNascimento;
    property NomPropriedadeNascimento: WideString read FNomPropriedadeNascimento write FNomPropriedadeNascimento;
    property CodFazendaNascimento: Integer read FCodFazendaNascimento write FCodFazendaNascimento;
    property SglFazendaNascimento: WideString read FSglFazendaNascimento write FSglFazendaNascimento;
    property NomFazendaNascimento: WideString read FNomFazendaNascimento write FNomFazendaNascimento;
    property CodPessoaSecundariaCriador: Integer read FCodPessoaSecundariaCriador write FCodPessoaSecundariaCriador;
    property NomPessoaSecundariaCriador: WideString read FNomPessoaSecundariaCriador write FNomPessoaSecundariaCriador;
    property CodEspecie: Integer read FCodEspecie write FCodEspecie;
    property SglEspecie: WideString read FSglEspecie write FSglEspecie;
    property DesEspecie: WideString read FDesEspecie write FDesEspecie;
    property CodAptidao: Integer read FCodAptidao write FCodAptidao;
    property SglAptidao: WideString read FSglAptidao write FSglAptidao;
    property DesAptidao: WideString read FDesAptidao write FDesAptidao;
    property NumImovelCorrente: WideString read FNumImovelCorrente write FNumImovelCorrente;
    property CodLocalizacaoCorrente: Integer read FCodLocalizacaoCorrente write FCodLocalizacaoCorrente;
    property CodPropriedadeCorrente: Integer read FCodPropriedadeCorrente write FCodPropriedadeCorrente;
    property NomPropriedadeCorrente: WideString read FNomPropriedadeCorrente write FNomPropriedadeCorrente;
    property CodPessoCorrente: Integer read FCodPessoCorrente write FCodPessoCorrente;
    property NomPessoaCorrente: WideString read FNomPessoaCorrente write FNomPessoaCorrente;
    property NumCNPJCPFCorrente: WideString read FNumCNPJCPFCorrente write FNumCNPJCPFCorrente;
    property NumCNPJCPFCorrenteFormatado: WideString read FNumCNPJCPFCorrenteFormatado write FNumCNPJCPFCorrenteFormatado;
    property CodPaisOrigem: Integer read FCodPaisOrigem write FCodPaisOrigem;
    property NomPaisOrigem: WideString read FNomPaisOrigem write FNomPaisOrigem;
    property DesPropriedadeOrigem: WideString read FDesPropriedadeOrigem write FDesPropriedadeOrigem;
    property DtaAutorizacaoImportacao: TDateTime read FDtaAutorizacaoImportacao write FDtaAutorizacaoImportacao;
    property DtaEntradaPais: TDateTime read FDtaEntradaPais write FDtaEntradaPais;
    property NumGuiaImportacao: WideString read FNumGuiaImportacao write FNumGuiaImportacao;
    property NumLicencaImportacao: WideString read FNumLicencaImportacao write FNumLicencaImportacao;
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property DtaGravacaoSisbov: TDateTime read FDtaGravacaoSisbov write FDtaGravacaoSisbov;
    property NomArquivoSisbov: WideString read FNomArquivoSisbov write FNomArquivoSisbov;
    property CodTipoLugar: Integer read FCodTipoLugar write FCodTipoLugar;
    property SglTipoLugar: WideString read FSglTipoLugar write FSglTipoLugar;
    property DesTipoLugar: WideString read FDesTipoLugar write FDesTipoLugar;
    property NumTransponder: WideString read FNumTransponder write FNumTransponder;
    property CodTipoIdentificador1    : Integer    read FCodTipoIdentificador1    write FCodTipoIdentificador1;
    property SglTipoIdentificador1    : WideString read FSglTipoIdentificador1    write FSglTipoIdentificador1;
    property DesTipoIdentificador1    : WideString read FDesTipoIdentificador1    write FDesTipoIdentificador1;
    property CodPosicaoIdentificador1 : Integer    read FCodPosicaoIdentificador1 write FCodPosicaoIdentificador1;
    property SglPosicaoIdentificador1 : WideString read FSglPosicaoIdentificador1 write FSglPosicaoIdentificador1;
    property DesPosicaoIdentificador1 : WideString read FDesPosicaoIdentificador1 write FDesPosicaoIdentificador1;

    property CodTipoIdentificador2    : Integer    read FCodTipoIdentificador2    write FCodTipoIdentificador2;
    property SglTipoIdentificador2    : WideString read FSglTipoIdentificador2    write FSglTipoIdentificador2;
    property DesTipoIdentificador2    : WideString read FDesTipoIdentificador2    write FDesTipoIdentificador2;
    property CodPosicaoIdentificador2 : Integer    read FCodPosicaoIdentificador2 write FCodPosicaoIdentificador2;
    property SglPosicaoIdentificador2 : WideString read FSglPosicaoIdentificador2 write FSglPosicaoIdentificador2;
    property DesPosicaoIdentificador2 : WideString read FDesPosicaoIdentificador2 write FDesPosicaoIdentificador2;

    property CodTipoIdentificador3    : Integer    read FCodTipoIdentificador3    write FCodTipoIdentificador3;
    property SglTipoIdentificador3    : WideString read FSglTipoIdentificador3    write FSglTipoIdentificador3;
    property DesTipoIdentificador3    : WideString read FDesTipoIdentificador3    write FDesTipoIdentificador3;
    property CodPosicaoIdentificador3 : Integer    read FCodPosicaoIdentificador3 write FCodPosicaoIdentificador3;
    property SglPosicaoIdentificador3 : WideString read FSglPosicaoIdentificador3 write FSglPosicaoIdentificador3;
    property DesPosicaoIdentificador3 : WideString read FDesPosicaoIdentificador3 write FDesPosicaoIdentificador3;

    property CodTipoIdentificador4    : Integer    read FCodTipoIdentificador4    write FCodTipoIdentificador4;
    property SglTipoIdentificador4    : WideString read FSglTipoIdentificador4    write FSglTipoIdentificador4;
    property DesTipoIdentificador4    : WideString read FDesTipoIdentificador4    write FDesTipoIdentificador4;
    property CodPosicaoIdentificador4 : Integer    read FCodPosicaoIdentificador4 write FCodPosicaoIdentificador4;
    property SglPosicaoIdentificador4 : WideString read FSglPosicaoIdentificador4 write FSglPosicaoIdentificador4;
    property DesPosicaoIdentificador4 : WideString read FDesPosicaoIdentificador4 write FDesPosicaoIdentificador4;
    property IndPessoaSecundaria      : WideString read FIndPessoaSecundaria      write FIndPessoaSecundaria;

    property NomAssociacaoRaca        : WideString read FNomAssociacaoRaca        write FNomAssociacaoRaca;
    property DesGrauSangue            : WideString read FDesGrauSangue            write FDesGrauSangue;

    property NumGta                   : WideString read FNumGta                   write FNumGta;
    property DtaEmissaoGta            : TDateTime  read FDtaEmissaoGta            write FDtaEmissaoGta;
    property NumNotaFiscal            : Integer    read FNumNotaFiscal            write FNumNotaFiscal;

    property NomMunicipioIdentificacao : WideString read FNomMunicipioIdentificacao write FNomMunicipioIdentificacao;
    property SglEstadoIdentificacao    : WideString read FSglEstadoIdentificacao    write FSglEstadoIdentificacao;
    property NomMunicipioNascimento    : WideString read FNomMunicipioNascimento    write FNomMunicipioNascimento;
    property SglEstadoNascimento       : WideString read FSglEstadoNascimento       write FSglEstadoNascimento;

    property DesComposicaoRacial       : WideString read FDesComposicaoRacial       write FDesComposicaoRacial;

    property IndAptoCobertura          : WideString read FIndAptoCobertura          write FIndAptoCobertura;
    property IndCadastroParto          : WideString read FIndCadastroParto          write FIndCadastroParto;
    property IndCodSisBovReservado     : WideString read FIndCodSisBovReservado     write FIndCodSisBovReservado;

    property CodPessoaTecnico          : Integer read FCodPessoaTecnico     write FCodPessoaTecnico;
    property NomPessoaTecnico          : WideString read FNomPessoaTecnico     write FNomPessoaTecnico;

    property NomPessoaVendedor:         WideString read FNomPessoaVendedor write FNomPessoaVendedor;
    property NomPessoaProdutor:         WideString read FNomPessoaProdutor write FNomPessoaProdutor;
  end;

implementation

uses ComServ;

function TAnimal.Get_CodAnimal: Integer;
begin
  Result := FCodAnimal;
end;

function TAnimal.Get_CodAnimalManejo: WideString;
begin
  Result := FCodAnimalManejo;
end;

function TAnimal.Get_CodAnimalSisbov: Integer;
begin
  Result := FCodAnimalSisbov;
end;

function TAnimal.Get_CodEstadoSisbov: Integer;
begin
  Result := FCodEstadoSisbov;
end;

function TAnimal.Get_CodFazendaManejo: Integer;
begin
  Result := FCodFazendaManejo;
end;

function TAnimal.Get_CodMicroRegiaoSisbov: Integer;
begin
  Result := FCodMicroRegiaoSisbov;
end;

function TAnimal.Get_CodPaisSisbov: Integer;
begin
  Result := FCodPaisSisbov;
end;

function TAnimal.Get_CodPelagem: Integer;
begin
  Result := FCodPelagem;
end;

function TAnimal.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TAnimal.Get_CodRaca: Integer;
begin
  Result := FCodRaca;
end;

function TAnimal.Get_CodTipoOrigem: Integer;
begin
  Result := FCodTipoOrigem;
end;

function TAnimal.Get_DesApelido: WideString;
begin
  Result := FDesApelido;
end;

function TAnimal.Get_DesPelagem: WideString;
begin
  Result := FDesPelagem;
end;

function TAnimal.Get_DesRaca: WideString;
begin
  Result := FDesRaca;
end;

function TAnimal.Get_DesTipoOrigem: WideString;
begin
  Result := FDesTipoOrigem;
end;

function TAnimal.Get_IndSexo: WideString;
begin
  Result := FIndSexo;
end;

function TAnimal.Get_NomAnimal: WideString;
begin
  Result := FNomAnimal;
end;


function TAnimal.Get_NumDVSisbov: Integer;
begin
  Result := FNumDVSisbov;
end;

function TAnimal.Get_SglFazendaManejo: WideString;
begin
  Result := FSglFazendaManejo;
end;

function TAnimal.Get_SglPelagem: WideString;
begin
  Result := FSglPelagem;
end;

function TAnimal.Get_SglRaca: WideString;
begin
  Result := FSglRaca;
end;

function TAnimal.Get_SglTipoOrigem: WideString;
begin
  Result := FSglTipoOrigem;
end;

procedure TAnimal.Set_CodAnimal(Value: Integer);
begin
  FCodAnimal := Value;
end;

procedure TAnimal.Set_CodAnimalManejo(const Value: WideString);
begin
  FCodAnimalManejo := Value;
end;

procedure TAnimal.Set_CodAnimalSisbov(Value: Integer);
begin
  FCodAnimalSisbov := Value;
end;

procedure TAnimal.Set_CodEstadoSisbov(Value: Integer);
begin
  FCodEstadoSisbov := Value;
end;

procedure TAnimal.Set_CodFazendaManejo(Value: Integer);
begin
  FCodFazendaManejo := Value;
end;

procedure TAnimal.Set_CodMicroRegiaoSisbov(Value: Integer);
begin
  FCodMicroRegiaoSisbov := Value;
end;

procedure TAnimal.Set_CodPaisSisbov(Value: Integer);
begin
  FCodPaisSisbov := Value;
end;

procedure TAnimal.Set_CodPelagem(Value: Integer);
begin
  FCodPelagem := Value;
end;


procedure TAnimal.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TAnimal.Set_CodRaca(Value: Integer);
begin
  FCodRaca := Value;
end;

procedure TAnimal.Set_CodTipoOrigem(Value: Integer);
begin
  FCodTipoOrigem := Value;
end;

procedure TAnimal.Set_DesApelido(const Value: WideString);
begin
  FDesApelido := Value;
end;

procedure TAnimal.Set_DesPelagem(const Value: WideString);
begin
  FDesPelagem := Value;
end;

procedure TAnimal.Set_DesRaca(const Value: WideString);
begin
  FDesRaca := Value;
end;

procedure TAnimal.Set_DesTipoOrigem(const Value: WideString);
begin
  FDesTipoOrigem := Value;
end;

procedure TAnimal.Set_IndSexo(const Value: WideString);
begin
  FIndSexo := Value;
end;

procedure TAnimal.Set_NomAnimal(const Value: WideString);
begin
  FNomAnimal := Value;
end;


procedure TAnimal.Set_NumDVSisbov(Value: Integer);
begin
  FNumDVSisbov := Value;
end;

procedure TAnimal.Set_SglFazendaManejo(const Value: WideString);
begin
  FSglFazendaManejo := Value;
end;

procedure TAnimal.Set_SglPelagem(const Value: WideString);
begin
  FSglPelagem := Value;
end;

procedure TAnimal.Set_SglRaca(const Value: WideString);
begin
  FSglRaca := Value;
end;

procedure TAnimal.Set_SglTipoOrigem(const Value: WideString);
begin
  FSglTipoOrigem := Value;
end;

function TAnimal.Get_CodAnimalMae: Integer;
begin
  Result := FCodAnimalMae;
end;

function TAnimal.Get_CodAnimalPai: Integer;
begin
  Result := FCodAnimalPai;
end;

function TAnimal.Get_CodAnimalReceptor: Integer;
begin
  Result := FCodAnimalReceptor;
end;

function TAnimal.Get_CodCategoriaAnimal: Integer;
begin
  Result := FCodCategoriaAnimal;
end;

function TAnimal.Get_CodFazendaCorrente: Integer;
begin
  Result := FCodFazendaCorrente;
end;

function TAnimal.Get_CodLocalCorrente: Integer;
begin
  Result := FCodLocalCorrente;
end;

function TAnimal.Get_CodManejoAnimalMae: WideString;
begin
  Result := FCodManejoAnimalMae;
end;

function TAnimal.Get_CodManejoAnimalPai: WideString;
begin
  Result := FCodManejoAnimalPai;
end;

function TAnimal.Get_CodManejoAnimalReceptor: WideString;
begin
  Result := FCodManejoAnimalReceptor;
end;

function TAnimal.Get_CodRegimeAlimentar: Integer;
begin
  Result := FCodRegimeAlimentar;
end;

function TAnimal.Get_DesCategoriaAnimal: WideString;
begin
  Result := FDesCategoriaAnimal;
end;

function TAnimal.Get_DesRegimeAlimentar: WideString;
begin
  Result := FDesRegimeAlimentar;
end;

function TAnimal.Get_DtaCompra: TDateTime;
begin
  Result := FDtaCompra;
end;

function TAnimal.Get_DtaNascimento: TDateTime;
begin
  Result := FDtaNascimento;
end;

function TAnimal.Get_IndAnimalCastrado: WideString;
begin
  Result := FIndAnimalCastrado;
end;

function TAnimal.Get_NomFazendaCorrente: WideString;
begin
  Result := FNomFazendaCorrente;
end;

function TAnimal.Get_DesLocalCorrente: WideString;
begin
  Result := FDesLocalCorrente;
end;

function TAnimal.Get_SglCategoriaAnimal: WideString;
begin
  Result := FSglCategoriaAnimal;
end;

function TAnimal.Get_SglFazendaAnimalMae: WideString;
begin
  Result := FSglFazendaAnimalMae;
end;

function TAnimal.Get_SglFazendaAnimalPai: WideString;
begin
  Result := FSglFazendaAnimalPai;
end;

function TAnimal.Get_SglFazendaAnimalReceptor: WideString;
begin
  Result := FSglFazendaAnimalReceptor;
end;

function TAnimal.Get_SglFazendaCorrente: WideString;
begin
  Result := FSglFazendaCorrente;
end;

function TAnimal.Get_SglLocalCorrente: WideString;
begin
  Result := FSglLocalCorrente;
end;

function TAnimal.Get_SglRegimeAlimentar: WideString;
begin
  Result := FSglRegimeAlimentar;;
end;

procedure TAnimal.Set_CodAnimalMae(Value: Integer);
begin
  FCodAnimalMae := Value;
end;

procedure TAnimal.Set_CodAnimalPai(Value: Integer);
begin
  FCodAnimalPai := Value;
end;

procedure TAnimal.Set_CodAnimalReceptor(Value: Integer);
begin
  FCodAnimalReceptor := Value;
end;

procedure TAnimal.Set_CodCategoriaAnimal(Value: Integer);
begin
  FCodCategoriaAnimal := Value;
end;

procedure TAnimal.Set_CodFazendaCorrente(Value: Integer);
begin
  FCodFazendaCorrente := Value;
end;

procedure TAnimal.Set_CodLocalCorrente(Value: Integer);
begin
  FCodLocalCorrente := Value;
end;

procedure TAnimal.Set_CodManejoAnimalMae(const Value: WideString);
begin
  FCodManejoAnimalMae := Value;
end;

procedure TAnimal.Set_CodManejoAnimalPai(const Value: WideString);
begin
  FCodManejoAnimalPai := Value;
end;

procedure TAnimal.Set_CodManejoAnimalReceptor(const Value: WideString);
begin
  FCodManejoAnimalReceptor := Value;
end;

procedure TAnimal.Set_CodRegimeAlimentar(Value: Integer);
begin
  FCodRegimeAlimentar := Value;
end;

procedure TAnimal.Set_DesCategoriaAnimal(const Value: WideString);
begin
  FDesCategoriaAnimal := Value;
end;

procedure TAnimal.Set_DesRegimeAlimentar(const Value: WideString);
begin
  FDesRegimeAlimentar := Value;
end;

procedure TAnimal.Set_DtaCompra(Value: TDateTime);
begin
  FDtaCompra := Value;
end;

procedure TAnimal.Set_DtaNascimento(Value: TDateTime);
begin
  FDtaNascimento := Value;
end;

procedure TAnimal.Set_IndAnimalCastrado(const Value: WideString);
begin
  FIndAnimalCastrado := Value;
end;

procedure TAnimal.Set_NomFazendaCorrente(const Value: WideString);
begin
  FNomFazendaCorrente := Value;
end;

procedure TAnimal.Set_DesLocalCorrente(const Value: WideString);
begin
  FDesLocalCorrente := Value;
end;

procedure TAnimal.Set_SglCategoriaAnimal(const Value: WideString);
begin
  FSglCategoriaAnimal := Value;
end;

procedure TAnimal.Set_SglFazendaAnimalMae(const Value: WideString);
begin
  FSglFazendaAnimalMae := Value;
end;

procedure TAnimal.Set_SglFazendaAnimalPai(const Value: WideString);
begin
  FSglFazendaAnimalPai := Value;
end;

procedure TAnimal.Set_SglFazendaAnimalReceptor(const Value: WideString);
begin
  FSglFazendaAnimalReceptor := Value;
end;

procedure TAnimal.Set_SglFazendaCorrente(const Value: WideString);
begin
  FSglFazendaCorrente := Value;
end;

procedure TAnimal.Set_SglLocalCorrente(const Value: WideString);
begin
  FSglLocalCorrente := Value;
end;

procedure TAnimal.Set_SglRegimeAlimentar(const Value: WideString);
begin
  FSglRegimeAlimentar := Value;
end;

function TAnimal.Get_CodAssociacaoRaca: Integer;
begin
  Result := FCodAssociacaoRaca;
end;

function TAnimal.Get_CodGrauSangue: Integer;
begin
  Result := FCodGrauSangue;
end;

function TAnimal.Get_CodLoteCorrente: Integer;
begin
  Result := FCodLoteCorrente;
end;

function TAnimal.Get_DesLoteCorrente: WideString;
begin
  Result := FDesLoteCorrente;
end;

function TAnimal.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TAnimal.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  Result := FDtaEfetivacaoCadastro;
end;

function TAnimal.Get_DtaUltimoEvento: TDateTime;
begin
  Result := FDtaUltimoEvento;
end;

function TAnimal.Get_NumRGD: WideString;
begin
  Result := FNumRGD;
end;


function TAnimal.Get_SglAssociacaoRaca: WideString;
begin
  Result := FSglAssociacaoRaca;
end;

function TAnimal.Get_SglGrauSangue: WideString;
begin
  Result := FSglGrauSangue;
end;

function TAnimal.Get_SglLoteCorrente: WideString;
begin
  Result := FSglLoteCorrente;
end;

function TAnimal.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

procedure TAnimal.Set_CodAssociacaoRaca(Value: Integer);
begin
  FCodAssociacaoRaca := Value;
end;

procedure TAnimal.Set_CodGrauSangue(Value: Integer);
begin
  FCodGrauSangue := Value;
end;

procedure TAnimal.Set_CodLoteCorrente(Value: Integer);
begin
  FCodLoteCorrente := Value;
end;

procedure TAnimal.Set_DesLoteCorrente(const Value: WideString);
begin
  FDesLoteCorrente := Value;
end;

procedure TAnimal.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

procedure TAnimal.Set_DtaEfetivacaoCadastro(Value: TDateTime);
begin
  FDtaEfetivacaoCadastro := Value;
end;

procedure TAnimal.Set_DtaUltimoEvento(Value: TDateTime);
begin
  FDtaUltimoEvento := Value;
end;

procedure TAnimal.Set_NumRGD(const Value: WideString);
begin
  FNumRGD := Value;
end;

procedure TAnimal.Set_SglAssociacaoRaca(const Value: WideString);
begin
  FSglAssociacaoRaca := Value;
end;

procedure TAnimal.Set_SglGrauSangue(const Value: WideString);
begin
  FSglGrauSangue := Value;
end;

procedure TAnimal.Set_SglLoteCorrente(const Value: WideString);
begin
  FSglLoteCorrente := Value;
end;

procedure TAnimal.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao := Value;
end;

function TAnimal.Get_CodAnimalCertificadora: WideString;
begin
  Result := FCodAnimalCertificadora;
end;

procedure TAnimal.Set_CodAnimalCertificadora(const Value: WideString);
begin
  FCodAnimalCertificadora := Value;
end;

function TAnimal.Get_CodSituacaoSisbov: WideString;
begin
  Result := FCodSituacaoSisbov;
end;

procedure TAnimal.Set_CodSituacaoSisbov(const Value: WideString);
begin
  FCodSituacaoSisbov := Value;
end;

function TAnimal.Get_DesSituacaoSisbov: WideString;
begin
  Result := FDesSituacaoSisbov;
end;

procedure TAnimal.Set_DesSituacaoSisbov(const Value: WideString);
begin
  FDesSituacaoSisbov := Value;
end;

function TAnimal.Get_DtaIdentificacaoSisbov: TDateTime;
begin
  Result := FDtaIdentificacaoSisbov;
end;

procedure TAnimal.Set_DtaIdentificacaoSisbov(Value: TDateTime);
begin
  FDtaIdentificacaoSisbov := Value;
end;

function TAnimal.Get_NumImovelIdentificacao: WideString;
begin
  Result := FNumImovelIdentificacao;
end;

procedure TAnimal.Set_NumImovelIdentificacao(const Value: WideString);
begin
  FNumImovelIdentificacao := Value;
end;

function TAnimal.Get_CodPropriedadeIdentificacao: Integer;
begin
  Result := FCodPropriedadeIdentificacao;
end;

procedure TAnimal.Set_CodPropriedadeIdentificacao(Value: Integer);
begin
  FCodPropriedadeIdentificacao := Value;
end;

function TAnimal.Get_NomPropriedadeIdentificacao: WideString;
begin
  Result := FNomPropriedadeIdentificacao;
end;

procedure TAnimal.Set_NomPropriedadeIdentificacao(const Value: WideString);
begin
  FNomPropriedadeIdentificacao := Value;
end;

function TAnimal.Get_CodFazendaIdentificacao: Integer;
begin
  Result := FCodFazendaIdentificacao;
end;

procedure TAnimal.Set_CodFazendaIdentificacao(Value: Integer);
begin
  FCodFazendaIdentificacao := Value;
end;

function TAnimal.Get_SglFazendaIdentificacao: WideString;
begin
  Result := FSglFazendaIdentificacao;
end;

procedure TAnimal.Set_SglFazendaIdentificacao(const Value: WideString);
begin
  FSglFazendaIdentificacao := Value;
end;

function TAnimal.Get_NomFazendaIdentificacao: WideString;
begin
  Result := FNomFazendaIdentificacao;
end;

procedure TAnimal.Set_NomFazendaIdentificacao(const Value: WideString);
begin
  FNomFazendaIdentificacao := Value;
end;

function TAnimal.Get_NumImovelNascimento: WideString;
begin
  Result := FNumImovelNascimento;
end;

procedure TAnimal.Set_NumImovelNascimento(const Value: WideString);
begin
  FNumImovelNascimento := Value;
end;

function TAnimal.Get_CodPropriedadeNascimento: Integer;
begin
  Result := FCodPropriedadeNascimento;
end;

procedure TAnimal.Set_CodPropriedadeNascimento(Value: Integer);
begin
  FCodPropriedadeNascimento := Value;
end;

function TAnimal.Get_NomPropriedadeNascimento: WideString;
begin
  Result := FNomPropriedadeNascimento;
end;

procedure TAnimal.Set_NomPropriedadeNascimento(const Value: WideString);
begin
  FNomPropriedadeNascimento := Value;
end;

function TAnimal.Get_CodFazendaNascimento: Integer;
begin
  Result := FCodFazendaNascimento;
end;

procedure TAnimal.Set_CodFazendaNascimento(Value: Integer);
begin
  FCodFazendaNascimento := Value;
end;

function TAnimal.Get_SglFazendaNascimento: WideString;
begin
  Result := FSglFazendaNascimento;
end;

procedure TAnimal.Set_SglFazendaNascimento(const Value: WideString);
begin
  FSglFazendaNascimento := Value;
end;

function TAnimal.Get_NomFazendaNascimento: WideString;
begin
  Result := FNomFazendaNascimento;
end;

procedure TAnimal.Set_NomFazendaNascimento(const Value: WideString);
begin
  FNomFazendaNascimento := Value;
end;

function TAnimal.Get_CodPessoaSecundariaCriador: Integer;
begin
  Result := FCodPessoaSecundariaCriador;
end;

procedure TAnimal.Set_CodPessoaSecundariaCriador(Value: Integer);
begin
  FCodPessoaSecundariaCriador := Value;
end;

function TAnimal.Get_NomPessoaSecundariaCriador: WideString;
begin
  Result := FNomPessoaSecundariaCriador;
end;

procedure TAnimal.Set_NomPessoaSecundariaCriador(const Value: WideString);
begin
  FNomPessoaSecundariaCriador := Value;
end;


function TAnimal.Get_CodEspecie: Integer;
begin
  Result := FCodEspecie;
end;

procedure TAnimal.Set_CodEspecie(Value: Integer);
begin
  FCodEspecie := Value;
end;

function TAnimal.Get_SglEspecie: WideString;
begin
  Result := FSglEspecie;
end;

procedure TAnimal.Set_SglEspecie(const Value: WideString);
begin
  FSglEspecie := Value;
end;

function TAnimal.Get_DesEspecie: WideString;
begin
  Result := FDesEspecie;
end;

procedure TAnimal.Set_DesEspecie(const Value: WideString);
begin
  FDesEspecie := Value;
end;

function TAnimal.Get_CodAptidao: Integer;
begin
  Result := FCodAptidao;
end;

procedure TAnimal.Set_CodAptidao(Value: Integer);
begin
  FCodAptidao := Value;
end;

function TAnimal.Get_SglAptidao: WideString;
begin
  Result := FSglAptidao;
end;

procedure TAnimal.Set_SglAptidao(const Value: WideString);
begin
  FSglAptidao := Value;
end;

function TAnimal.Get_DesAptidao: WideString;
begin
  Result := FDesAptidao;
end;

procedure TAnimal.Set_DesAptidao(const Value: WideString);
begin
  FDesAptidao := Value;
end;

function TAnimal.Get_NumImovelCorrente: WideString;
begin
  Result := FNumImovelCorrente;
end;

procedure TAnimal.Set_NumImovelCorrente(const Value: WideString);
begin
  FNumImovelCorrente := Value;
end;

function TAnimal.Get_CodPropriedadeCorrente: Integer;
begin
  Result := FCodPropriedadeCorrente;
end;

procedure TAnimal.Set_CodPropriedadeCorrente(Value: Integer);
begin
  FCodPropriedadeCorrente := Value;
end;

function TAnimal.Get_CodPessoCorrente: Integer;
begin
  Result := FCodPessoCorrente;
end;

procedure TAnimal.Set_CodPessoCorrente(Value: Integer);
begin
  FCodPessoCorrente := Value;
end;

function TAnimal.Get_NomPessoaCorrente: WideString;
begin
  Result := FNomPessoaCorrente;
end;

procedure TAnimal.Set_NomPessoaCorrente(const Value: WideString);
begin
  FNomPessoaCorrente := Value;
end;

function TAnimal.Get_NumCNPJCPFCorrente: WideString;
begin
  Result := FNumCNPJCPFCorrente;
end;

procedure TAnimal.Set_NumCNPJCPFCorrente(const Value: WideString);
begin
  FNumCNPJCPFCorrente := Value;
end;

function TAnimal.Get_NumCNPJCPFCorrenteFormatado: WideString;
begin
  Result := FNumCNPJCPFCorrenteFormatado;
end;

procedure TAnimal.Set_NumCNPJCPFCorrenteFormatado(const Value: WideString);
begin
  FNumCNPJCPFCorrenteFormatado := Value;
end;

function TAnimal.Get_CodPaisOrigem: Integer;
begin
  Result := FCodPaisOrigem;
end;

procedure TAnimal.Set_CodPaisOrigem(Value: Integer);
begin
  FCodPaisOrigem := Value;
end;

function TAnimal.Get_NomPaisOrigem: WideString;
begin
  Result := FNomPaisOrigem;
end;

procedure TAnimal.Set_NomPaisOrigem(const Value: WideString);
begin
  FNomPaisOrigem := Value;
end;

function TAnimal.Get_DesPropriedadeOrigem: WideString;
begin
  Result := FDesPropriedadeOrigem;
end;

procedure TAnimal.Set_DesPropriedadeOrigem(const Value: WideString);
begin
  FDesPropriedadeOrigem := Value;
end;

function TAnimal.Get_DtaAutorizacaoImportacao: TDateTime;
begin
  Result := FDtaAutorizacaoImportacao;
end;

procedure TAnimal.Set_DtaAutorizacaoImportacao(Value: TDateTime);
begin
  FDtaAutorizacaoImportacao := Value;
end;

function TAnimal.Get_DtaEntradaPais: TDateTime;
begin
  Result := FDtaEntradaPais;
end;

procedure TAnimal.Set_DtaEntradaPais(Value: TDateTime);
begin
  FDtaEntradaPais := Value;
end;

function TAnimal.Get_NumGuiaImportacao: WideString;
begin
  Result := FNumGuiaImportacao;
end;

procedure TAnimal.Set_NumGuiaImportacao(const Value: WideString);
begin
  FNumGuiaImportacao := Value;
end;

function TAnimal.Get_NumLicencaImportacao: WideString;
begin
  Result := FNumLicencaImportacao;
end;

procedure TAnimal.Set_NumLicencaImportacao(const Value: WideString);
begin
  FNumLicencaImportacao := Value;
end;

function TAnimal.Get_CodArquivoSisbov: Integer;
begin
  Result := FCodArquivoSisbov;
end;

procedure TAnimal.Set_CodArquivoSisbov(Value: Integer);
begin
  FCodArquivoSisbov := Value;
end;

function TAnimal.Get_DtaGravacaoSisbov: TDateTime;
begin
  Result := FDtaGravacaoSisbov;
end;

procedure TAnimal.Set_DtaGravacaoSisbov(Value: TDateTime);
begin
  FDtaGravacaoSisbov := Value;
end;

function TAnimal.Get_NomArquivoSisbov: WideString;
begin
  Result := FNomArquivoSisbov;
end;

procedure TAnimal.Set_NomArquivoSisbov(const Value: WideString);
begin
  FNomArquivoSisbov := Value;
end;

function TAnimal.Get_CodTipoLugar: Integer;
begin
  Result := FCodTipoLugar;
end;

function TAnimal.Get_DesTipoLugar: WideString;
begin
  Result := FDesTipoLugar;
end;

function TAnimal.Get_SglTipoLugar: WideString;
begin
  Result := FSglTipoLugar;
end;

procedure TAnimal.Set_CodTipoLugar(Value: Integer);
begin
  FCodTipoLugar := Value;
end;

procedure TAnimal.Set_DesTipoLugar(const Value: WideString);
begin
  FDesTipoLugar := Value;
end;

procedure TAnimal.Set_SglTipoLugar(const Value: WideString);
begin
  FSglTipoLugar := Value;
end;

function TAnimal.Get_TxtSituacaoSisBov: WideString;
begin
  result := FTxtSituacaoSisBov;
end;

procedure TAnimal.Set_TxtSituacaoSisBov(const Value: WideString);
begin
  FTxtSituacaoSisBov := value;
end;

function TAnimal.Get_NumTransponder: WideString;
begin
  result := FNumTransponder;
end;

procedure TAnimal.Set_NumTransponder(const Value: WideString);
begin
  FNumTransponder := value;
end;

function TAnimal.Get_CodTipoIdentificador1: Integer;
begin
  result := FCodTipoIdentificador1;
end;

function TAnimal.Get_SglTipoIdentificador1: WideString;
begin
  result := FSglTipoIdentificador1;
end;

procedure TAnimal.Set_CodTipoIdentificador1(Value: Integer);
begin
  FCodTipoIdentificador1 := value;
end;

procedure TAnimal.Set_SglTipoIdentificador1(const Value: WideString);
begin
  FSglTipoIdentificador1 := value;
end;

function TAnimal.Get_DesTipoIdentificador1: WideString;
begin
  Result := FDesTipoIdentificador1;
end;

procedure TAnimal.Set_DesTipoIdentificador1(const Value: WideString);
begin
  FDesTipoIdentificador1 := value;
end;

function TAnimal.Get_CodPosicaoIdentificador1: Integer;
begin
  Result := FCodPosicaoIdentificador1;
end;

procedure TAnimal.Set_CodPosicaoIdentificador1(Value: Integer);
begin
  FCodPosicaoIdentificador1 := value;
end;

function TAnimal.Get_SglPosicaoIdentificador1: WideString;
begin
  Result := FSglPosicaoIdentificador1;
end;

procedure TAnimal.Set_SglPosicaoIdentificador1(const Value: WideString);
begin
  FSglPosicaoIdentificador1 := value;
end;

function TAnimal.Get_DesPosicaoIdentificador1: WideString;
begin
  result := FDesPosicaoIdentificador1;
end;

procedure TAnimal.Set_DesPosicaoIdentificador1(const Value: WideString);
begin
  FDesPosicaoIdentificador1 := value;
end;

function TAnimal.Get_CodTipoIdentificador2: Integer;
begin
  result := FCodTipoIdentificador2;
end;

function TAnimal.Get_DesTipoIdentificador2: WideString;
begin
  result  := FDesTipoIdentificador2;
end;

function TAnimal.Get_SglTipoIdentificador2: WideString;
begin
  result := FSglTipoIdentificador2;
end;

procedure TAnimal.Set_CodTipoIdentificador2(Value: Integer);
begin
  FCodTipoIdentificador2 := value;
end;

procedure TAnimal.Set_DesTipoIdentificador2(const Value: WideString);
begin
  FDesTipoIdentificador2 := value;
end;

procedure TAnimal.Set_SglTipoIdentificador2(const Value: WideString);
begin
  FSglTipoIdentificador2 := value;
end;

function TAnimal.Get_CodPosicaoIdentificador2: Integer;
begin
  result := FCodPosicaoIdentificador2;
end;

procedure TAnimal.Set_CodPosicaoIdentificador2(Value: Integer);
begin
  FCodPosicaoIdentificador2 := value;
end;

function TAnimal.Get_SglPosicaoIdentificador2: WideString;
begin
  result := FSglPosicaoIdentificador2;
end;

procedure TAnimal.Set_SglPosicaoIdentificador2(const Value: WideString);
begin
  FSglPosicaoIdentificador2 := value;
end;

function TAnimal.Get_DesPosicaoIdentificador2: WideString;
begin
  result := FDesPosicaoIdentificador2;
end;

procedure TAnimal.Set_DesPosicaoIdentificador2(const Value: WideString);
begin
  FDesPosicaoIdentificador2 := Value;
end;

function TAnimal.Get_CodTipoIdentificador3: Integer;
begin
  result := FCodTipoIdentificador3;
end;

procedure TAnimal.Set_CodTipoIdentificador3(Value: Integer);
begin
  FCodTipoIdentificador3 := value;
end;

function TAnimal.Get_SglTipoIdentificador3: WideString;
begin
  result  := FSglTipoIdentificador3;
end;

procedure TAnimal.Set_SglTipoIdentificador3(const Value: WideString);
begin
  FSglTipoIdentificador3 := Value;
end;

function TAnimal.Get_DesTipoIdentificador3: WideString;
begin
  result := FDesTipoIdentificador3;
end;

procedure TAnimal.Set_DesTipoIdentificador3(const Value: WideString);
begin
  FDesTipoIdentificador3 := Value;
end;

function TAnimal.Get_CodPosicaoIdentificador3: Integer;
begin
  result := FCodPosicaoIdentificador3;
end;

function TAnimal.Get_DesPosicaoIdentificador3: WideString;
begin
  result := FDesPosicaoIdentificador3;
end;

function TAnimal.Get_SglPosicaoIdentificador3: WideString;
begin
  result := FSglPosicaoIdentificador3;
end;

procedure TAnimal.Set_CodPosicaoIdentificador3(Value: Integer);
begin
  FCodPosicaoIdentificador3 := value;
end;

procedure TAnimal.Set_DesPosicaoIdentificador3(const Value: WideString);
begin
  FDesPosicaoIdentificador3 := Value;
end;

procedure TAnimal.Set_SglPosicaoIdentificador3(const Value: WideString);
begin
  FSglPosicaoIdentificador3 := Value;
end;

function TAnimal.Get_CodTipoIdentificador4: Integer;
begin
  result := FCodTipoIdentificador4;
end;

procedure TAnimal.Set_CodTipoIdentificador4(Value: Integer);
begin
  FCodTipoIdentificador4 := value;
end;

function TAnimal.Get_SglTipoIdentificador4: WideString;
begin
  result := FSglTipoIdentificador4;
end;

procedure TAnimal.Set_SglTipoIdentificador4(const Value: WideString);
begin
  FSglTipoIdentificador4 := value; 
end;

function TAnimal.Get_CodPosicaoIdentificador4: Integer;
begin
  result := FCodPosicaoIdentificador4;
end;

function TAnimal.Get_DesTipoIdentificador4: WideString;
begin
  result := FDesTipoIdentificador4;
end;

procedure TAnimal.Set_CodPosicaoIdentificador4(Value: Integer);
begin
  FCodPosicaoIdentificador4 := value;
end;

procedure TAnimal.Set_DesTipoIdentificador4(const Value: WideString);
begin
  FDesTipoIdentificador4 := Value;
end;

function TAnimal.Get_SglPosicaoIdentificador4: WideString;
begin
  result := FSglPosicaoIdentificador4;
end;

procedure TAnimal.Set_SglPosicaoIdentificador4(const Value: WideString);
begin
  FSglPosicaoIdentificador4 := value;
end;

function TAnimal.Get_DesPosicaoIdentificador4: WideString;
begin
  result := FDesPosicaoIdentificador4;
end;

procedure TAnimal.Set_DesPosicaoIdentificador4(const Value: WideString);
begin
  FDesPosicaoIdentificador4 := value;
end;

function TAnimal.Get_NomPropriedadeCorrente: WideString;
begin
  result := FNomPropriedadeCorrente;
end;

procedure TAnimal.Set_NomPropriedadeCorrente(const Value: WideString);
begin
  FNomPropriedadeCorrente := Value;
end;

function TAnimal.Get_CodPessoaCorrente: Integer;
begin
 result := FCodPessoaCorrente;
end;

procedure TAnimal.Set_CodPessoaCorrente(Value: Integer);
begin
  FCodPessoaCorrente := value;
end;

function TAnimal.Get_IndPessoaSecundaria: WideString;
begin
  result := FIndPessoaSecundaria;
end;

procedure TAnimal.Set_IndPessoaSecundaria(const Value: WideString);
begin
  FIndPessoaSecundaria := value;
end;

function TAnimal.Get_NomAssociacaoRaca: WideString;
begin
 result := FNomAssociacaoRaca;
end;

procedure TAnimal.Set_NomAssociacaoRaca(const Value: WideString);
begin
  FNomAssociacaoRaca := value;
end;

function TAnimal.Get_DesGrauSangue: WideString;
begin
  result := FDesGrauSangue;
end;

procedure TAnimal.Set_DesGrauSangue(const Value: WideString);
begin
  FDesGrauSangue := value;
end;

function TAnimal.Get_NumGta: WideString;
begin
  Result := FNumGta;
end;

procedure TAnimal.Set_NumGta(const Value: WideString);
begin
  FNumGta := Value;
end;

function TAnimal.Get_DtaEmissaoGta: TDateTime;
begin
  Result := FDtaEmissaoGta;
end;

procedure TAnimal.Set_DtaEmissaoGta(Value: TDateTime);
begin
  FDtaEmissaoGta := Value;
end;

function TAnimal.Get_NumNotaFiscal: Integer;
begin
  Result := FNumNotaFiscal;
end;

procedure TAnimal.Set_NumNotaFiscal(Value: Integer);
begin
  FNumNotaFiscal := Value;
end;

function TAnimal.Get_NomMunicipioIdentificacao: WideString;
begin
  result := FNomMunicipioIdentificacao;
end;

function TAnimal.Get_SglEstadoIdentificacao: WideString;
begin
  result := FSglEstadoIdentificacao;
end;

procedure TAnimal.Set_NomMunicipioIdentificacao(const Value: WideString);
begin
  FNomMunicipioIdentificacao := value;
end;

procedure TAnimal.Set_SglEstadoIdentificacao(const Value: WideString);
begin
  FSglEstadoIdentificacao := value;
end;

function TAnimal.Get_NomMunicipioNascimento: WideString;
begin
  result := FNomMunicipioNascimento;
end;

function TAnimal.Get_SglEstadoNascimento: WideString;
begin
  result := FSglEstadoNascimento;
end;

procedure TAnimal.Set_NomMunicipioNascimento(const Value: WideString);
begin
  FNomMunicipioNascimento := value;
end;

procedure TAnimal.Set_SglEstadoNascimento(const Value: WideString);
begin
  FSglEstadoNascimento := value;
end;

function TAnimal.Get_DesComposicaoRacial: WideString;
begin
  result := FDesComposicaoRacial;
end;

procedure TAnimal.Set_DesComposicaoRacial(const Value: WideString);
begin
  FDesComposicaoRacial := value;
end;

function TAnimal.Get_IndAptoCobertura: WideString;
begin
  result := FIndAptoCobertura;
end;

procedure TAnimal.Set_IndAptoCobertura(const Value: WideString);
begin
  FIndAptoCobertura := value;
end;

function TAnimal.Get_IndCadastroParto: WideString;
begin
  result := FIndCadastroParto;
end;

procedure TAnimal.Set_IndCadastroParto(const Value: WideString);
begin
  FIndCadastroParto := value;
end;

function TAnimal.Get_IndCodSisBovReservado: WideString;
begin
  result := FIndCodSisBovReservado;
end;

procedure TAnimal.Set_IndCodSisBovReservado(const Value: WideString);
begin
  FIndCodSisBovReservado := value;
end;

function TAnimal.Get_CodPessoaTecnico: Integer;
begin
  Result := FCodPessoaTecnico;
end;

function TAnimal.Get_NomPessoaTecnico: WideString;
begin
  Result := FNomPessoaTecnico;
end;

procedure TAnimal.Set_CodPessoaTecnico(Value: Integer);
begin
   FCodPessoaTecnico := Value;
end;

procedure TAnimal.Set_NomPessoaTecnico(const Value: WideString);
begin
   FNomPessoaTecnico := Value;
end;

function TAnimal.Get_CodLocalizacaoCorrente: Integer;
begin
  Result := FCodLocalizacaoCorrente;
end;

function TAnimal.Get_CodLocalizacaoIdentificacao: Integer;
begin
  Result := FCodLocalizacaoIdentificacao;
end;

function TAnimal.Get_CodLocalizacaoNascimento: Integer;
begin
  Result := CodLocalizacaoNascimento;
end;

procedure TAnimal.Set_CodLocalizacaoCorrente(Value: Integer);
begin
  FCodLocalizacaoCorrente := Value;
end;

procedure TAnimal.Set_CodLocalizacaoIdentificacao(Value: Integer);
begin
  FCodLocalizacaoIdentificacao := Value;
end;

procedure TAnimal.Set_CodLocalizacaoNascimento(Value: Integer);
begin
  FCodLocalizacaoNascimento := Value;
end;

function TAnimal.Get_NomPessoaVendedor: WideString;
begin
  Result := FNomPessoaVendedor;
end;

procedure TAnimal.Set_NomPessoaVendedor(const Value: WideString);
begin
  FNomPessoaVendedor := Value;
end;

function TAnimal.Get_NomPessoaProdutor: WideString;
begin
  Result := FNomPessoaProdutor;
end;

procedure TAnimal.Set_NomPessoaProdutor(const Value: WideString);
begin
  FNomPessoaProdutor := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnimal, Class_Animal,
    ciMultiInstance, tmApartment);
end.
