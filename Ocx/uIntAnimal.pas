// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/08/2002
// *  Documentação       : Animais - Definição das Classes.doc
// *  Código Classe      : 45
// *  Descrição Resumida : Cadastro de Animais
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    23/08/2002    Criação
// *   Hitalo   23/08/2002    Adiconar Propriedades(Tipo Identificador,Posicao Identificador)
// *
// ********************************************************************
unit uIntAnimal;

interface

type
  TIntAnimal = class
  private
    FCodPessoaProdutor: Integer;
    FNomPessoaProdutor: String;
    FCodAnimal: Integer;
    FCodFazendaManejo: Integer;
    FSglFazendaManejo: String;
    FCodAnimalManejo: String;
    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;
    FCodPessoaCertificadora: Integer;
    FNomPessoaCertificadora: String;
    FNomAnimal: String;
    FDesApelido: String;
    FCodRaca: Integer;
    FSglRaca: String;
    FDesRaca: String;
    FCodPelagem: Integer;
    FSglPelagem: String;
    FDesPelagem: String;
    FIndSexo: String;
    FCodTipoOrigem: Integer;
    FSglTipoOrigem: String;
    FDesTipoOrigem: String;
    FDtaNascimento: TDateTime;
    FDtaCompra: TDateTime;
    FCodAnimalPai: Integer;
    FSglFazendaAnimalPai: String;
    FCodManejoAnimalPai: String;
    FCodAnimalMae: Integer;
    FSglFazendaAnimalMae: String;
    FCodManejoAnimalMae: String;
    FCodAnimalReceptor: Integer;
    FSglFazendaAnimalReceptor: String;
    FCodManejoAnimalReceptor: String;
    FIndAnimalCastrado: String;
    FCodRegimeAlimentar: Integer;
    FSglRegimeAlimentar: String;
    FDesRegimeAlimentar: String;
    FCodCategoriaAnimal: Integer;
    FSglCategoriaAnimal: String;
    FDesCategoriaAnimal: String;
    FCodFazendaCorrente: Integer;
    FSglFazendaCorrente: String;
    FNomFazendaCorrente: String;
    FCodLocalCorrente: Integer;
    FSglLocalCorrente: String;
    FDesLocalCorrente: String;
    FCodLoteCorrente: Integer;
    FSglLoteCorrente: String;
    FDesLoteCorrente: String;
    FTxtObservacao: String;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FDtaUltimoEvento: TDateTime;
    FCodAssociacaoRaca: Integer;
    FSglAssociacaoRaca: String;
    FCodGrauSangue: Integer;
    FSglGrauSangue: String;
    FNumRGN: String;
    FNumRGD: String;
    FCodAnimalCertificadora: String;
    FCodSituacaoSisbov          : String;
    FDesSituacaoSisbov          : String;
    FTxtSituacaoSisbov          : String;
    FDtaIdentificacaoSisbov     : TDateTime;
    FNumImovelIdentificacao     : String;
    FCodLocalizacaoIdentificacao: Integer;
    FCodPropriedadeIdentificacao: Integer;
    FNomPropriedadeIdentificacao: String;
    FCodFazendaIdentificacao: Integer;
    FSglFazendaIdentificacao: String;
    FNomFazendaIdentificacao: String;
    FNumImovelNascimento: String;
    FCodLocalizacaoNascimento: Integer;
    FCodPropriedadeNascimento: Integer;
    FNomPropriedadeNascimento: String;
    FCodFazendaNascimento: Integer;
    FSglFazendaNascimento: String;
    FNomFazendaNascimento: String;
    FCodPessoaSecundariaCriador: Integer;
    FNomPessoaSecundariaCriador: String;
    FCodPessoaSecundariaFornec: Integer;
    FNomPessoaSecundariaFornec: Integer;
    FCodEspecie: Integer;
    FSglEspecie: String;
    FDesEspecie: String;
    FCodAptidao: Integer;
    FSglAptidao: String;
    FDesAptidao: String;
    FNumImovelCorrente: String;
    FCodLocalizacaoCorrente: Integer;
    FCodPropriedadeCorrente: Integer;
    FNomPropriedadeCorrente: String;
    FCodPessoaCorrente: Integer;
    FNomPessoaCorrente: String;
    FNumCNPJCPFCorrente: String;
    FNumCNPJCPFCorrenteFormatado: String;
    FCodPapelCorrente: Integer;
    FDesPapelCorrente: String;
    FCodPaisOrigem: Integer;
    FNomPaisOrigem: String;
    FDesPropriedadeOrigem: String;
    FDtaAutorizacaoImportacao: TDateTime;
    FDtaEntradaPais: TDateTime;
    FNumGuiaImportacao: String;
    FNumLicencaImportacao: String;
    FCodArquivoSisbov: Integer;
    FDtaGravacaoSisbov: TDateTime;
    FNomArquivoSisbov: String;
    FCodTipoLugar: Integer;
    FSglTipoLugar: String;
    FDesTipoLugar: String;
    FNumTransponder           : String;
    FCodTipoIdentificador1    : Integer;
    FSglTipoIdentificador1    : String;
    FDesTipoIdentificador1    : String;
    FCodPosicaoIdentificador1 : Integer;
    FSglPosicaoIdentificador1 : String;
    FDesPosicaoIdentificador1 : String;

    FCodTipoIdentificador2    : Integer;
    FSglTipoIdentificador2    : String;
    FDesTipoIdentificador2    : String;
    FCodPosicaoIdentificador2 : Integer;
    FSglPosicaoIdentificador2 : String;
    FDesPosicaoIdentificador2 : String;

    FCodTipoIdentificador3    : Integer;
    FSglTipoIdentificador3    : String;
    FDesTipoIdentificador3    : String;
    FCodPosicaoIdentificador3 : Integer;
    FSglPosicaoIdentificador3 : String;
    FDesPosicaoIdentificador3 : String;

    FCodTipoIdentificador4    : Integer;
    FSglTipoIdentificador4    : String;
    FDesTipoIdentificador4    : String;
    FCodPosicaoIdentificador4 : Integer;
    FSglPosicaoIdentificador4 : String;
    FDesPosicaoIdentificador4 : String;
    FIndPessoaSecundaria      : String;

    FNomAssociacaoRaca        : String;
    FDesGrauSangue            : String;

    FNumGta                   : String;
    FDtaEmissaoGta            : TDateTime;
    FNumNotaFiscal            : Integer;

    FNomMunicipioIdentificacao : String;
    FSglEstadoIdentificacao    : String;
    FNomMunicipioNascimento    : String;
    FSglEstadoNascimento       : String;

    FDesComposicaoRacial       : String;

    FIndAptoCobertura          :String;
    FIndCadastroParto          :String;
    FIndCodSisBovReservado     :String;

    FCodPessoaTecnico           : Integer;
    FNomPessoaTecnico           : String;

    FNomPessoaVendedor:         String; 
  public

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodFazendaManejo: Integer read FCodFazendaManejo write FCodFazendaManejo;
    property SglFazendaManejo: String read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: String read FCodAnimalManejo write FCodAnimalManejo;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;
    property CodPessoaCertificadora: Integer read FCodPessoaCertificadora write FCodPessoaCertificadora;
    property NomPessoaCertificadora: String read FNomPessoaCertificadora write FNomPessoaCertificadora;
    property NomAnimal: String read FNomAnimal write FNomAnimal;
    property DesApelido: String read FDesApelido write FDesApelido;
    property CodRaca: Integer read FCodRaca write FCodRaca;
    property SglRaca: String read FSglRaca write FSglRaca;
    property DesRaca: String read FDesRaca write FDesRaca;
    property CodPelagem: Integer read FCodPelagem write FCodPelagem;
    property SglPelagem: String read FSglPelagem write FSglPelagem;
    property DesPelagem: String read FDesPelagem write FDesPelagem;
    property IndSexo: String read FIndSexo write FIndSexo;
    property CodTipoOrigem: Integer read FCodTipoOrigem write FCodTipoOrigem;
    property SglTipoOrigem: String read FSglTipoOrigem write FSglTipoOrigem;
    property DesTipoOrigem: String read FDesTipoOrigem write FDesTipoOrigem;
    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property DtaCompra: TDateTime read FDtaCompra write FDtaCompra;
    property CodAnimalPai: Integer read FCodAnimalPai write FCodAnimalPai;
    property SglFazendaAnimalPai: String read FSglFazendaAnimalPai write FSglFazendaAnimalPai;
    property CodManejoAnimalPai: String read FCodManejoAnimalPai write FCodManejoAnimalPai;
    property CodAnimalMae: Integer read FCodAnimalMae write FCodAnimalMae;
    property SglFazendaAnimalMae: String read FSglFazendaAnimalMae write FSglFazendaAnimalMae;
    property CodManejoAnimalMae: String read FCodManejoAnimalMae write FCodManejoAnimalMae;
    property CodAnimalReceptor: Integer read FCodAnimalReceptor write FCodAnimalReceptor;
    property SglFazendaAnimalReceptor: String read FSglFazendaAnimalReceptor write FSglFazendaAnimalReceptor;
    property CodManejoAnimalReceptor: String read FCodManejoAnimalReceptor write FCodManejoAnimalReceptor;
    property IndAnimalCastrado: String read FIndAnimalCastrado write FIndAnimalCastrado;
    property CodRegimeAlimentar: Integer read FCodRegimeAlimentar write FCodRegimeAlimentar;
    property SglRegimeAlimentar: String read FSglRegimeAlimentar write FSglRegimeAlimentar;
    property DesRegimeAlimentar: String read FDesRegimeAlimentar write FDesRegimeAlimentar;
    property CodCategoriaAnimal: Integer read FCodCategoriaAnimal write FCodCategoriaAnimal;
    property SglCategoriaAnimal: String read FSglCategoriaAnimal write FSglCategoriaAnimal;
    property DesCategoriaAnimal: String read FDesCategoriaAnimal write FDesCategoriaAnimal;
    property CodFazendaCorrente: Integer read FCodFazendaCorrente write FCodFazendaCorrente;
    property SglFazendaCorrente: String read FSglFazendaCorrente write FSglFazendaCorrente;
    property NomFazendaCorrente: String read FNomFazendaCorrente write FNomFazendaCorrente;
    property CodLocalCorrente: Integer read FCodLocalCorrente write FCodLocalCorrente;
    property SglLocalCorrente: String read FSglLocalCorrente write FSglLocalCorrente;
    property DesLocalCorrente: String read FDesLocalCorrente write FDesLocalCorrente;
    property CodLoteCorrente: Integer read FCodLoteCorrente write FCodLoteCorrente;
    property SglLoteCorrente: String read FSglLoteCorrente write FSglLoteCorrente;
    property DesLoteCorrente: String read FDesLoteCorrente write FDesLoteCorrente;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property DtaUltimoEvento: TDateTime read FDtaUltimoEvento write FDtaUltimoEvento;
    property CodAssociacaoRaca: Integer read FCodAssociacaoRaca write FCodAssociacaoRaca;
    property SglAssociacaoRaca: String read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property CodGrauSangue: Integer read FCodGrauSangue write FCodGrauSangue;
    property SglGrauSangue: String read FSglGrauSangue write FSglGrauSangue;
    property NumRGN: String read FNumRGN write FNumRGN;
    property NumRGD: String read FNumRGD write FNumRGD;
    property CodAnimalCertificadora: String read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property CodSituacaoSisbov: String read FCodSituacaoSisbov write FCodSituacaoSisbov;
    property DesSituacaoSisbov: String read FDesSituacaoSisbov write FDesSituacaoSisbov;
    property TxtSituacaoSisbov: String read FTxtSituacaoSisbov write FTxtSituacaoSisbov;    
    property DtaIdentificacaoSisbov: TDateTime read FDtaIdentificacaoSisbov write FDtaIdentificacaoSisbov;
    property NumImovelIdentificacao: String read FNumImovelIdentificacao write FNumImovelIdentificacao;
    property CodLocalizacaoIdentificacao: Integer read FCodLocalizacaoIdentificacao write FCodLocalizacaoIdentificacao;
    property CodPropriedadeIdentificacao: Integer read FCodPropriedadeIdentificacao write FCodPropriedadeIdentificacao;
    property NomPropriedadeIdentificacao: String read FNomPropriedadeIdentificacao write FNomPropriedadeIdentificacao;
    property CodFazendaIdentificacao: Integer read FCodFazendaIdentificacao write FCodFazendaIdentificacao;
    property SglFazendaIdentificacao: String read FSglFazendaIdentificacao write FSglFazendaIdentificacao;
    property NomFazendaIdentificacao: String read FNomFazendaIdentificacao write FNomFazendaIdentificacao;
    property NumImovelNascimento: String read FNumImovelNascimento write FNumImovelNascimento;
    property CodLocalizacaoNascimento: Integer read FCodLocalizacaoNascimento write FCodLocalizacaoNascimento;
    property CodPropriedadeNascimento: Integer read FCodPropriedadeNascimento write FCodPropriedadeNascimento;
    property NomPropriedadeNascimento: String read FNomPropriedadeNascimento write FNomPropriedadeNascimento;
    property CodFazendaNascimento: Integer read FCodFazendaNascimento write FCodFazendaNascimento;
    property SglFazendaNascimento: String read FSglFazendaNascimento write FSglFazendaNascimento;
    property NomFazendaNascimento: String read FNomFazendaNascimento write FNomFazendaNascimento;
    property CodPessoaSecundariaCriador: Integer read FCodPessoaSecundariaCriador write FCodPessoaSecundariaCriador;
    property NomPessoaSecundariaCriador: String read FNomPessoaSecundariaCriador write FNomPessoaSecundariaCriador;
    property CodPessoaSecundariaFornec: Integer read FCodPessoaSecundariaFornec write FCodPessoaSecundariaFornec;
    property NomPessoaSecundariaFornec: Integer read FNomPessoaSecundariaFornec write FNomPessoaSecundariaFornec;
    property CodEspecie: Integer read FCodEspecie write FCodEspecie;
    property SglEspecie: String read FSglEspecie write FSglEspecie;
    property DesEspecie: String read FDesEspecie write FDesEspecie;
    property CodAptidao: Integer read FCodAptidao write FCodAptidao;
    property SglAptidao: String read FSglAptidao write FSglAptidao;
    property DesAptidao: String read FDesAptidao write FDesAptidao;
    property NumImovelCorrente: String read FNumImovelCorrente write FNumImovelCorrente;
    property CodLocalizacaoCorrente: Integer read FCodLocalizacaoCorrente write FCodLocalizacaoCorrente;
    property CodPropriedadeCorrente: Integer read FCodPropriedadeCorrente write FCodPropriedadeCorrente;
    property NomPropriedadeCorrente: String read FNomPropriedadeCorrente write FNomPropriedadeCorrente;
    property CodPessoaCorrente: Integer read FCodPessoaCorrente write FCodPessoaCorrente;
    property NomPessoaCorrente: String read FNomPessoaCorrente write FNomPessoaCorrente;
    property NumCNPJCPFCorrente: String read FNumCNPJCPFCorrente write FNumCNPJCPFCorrente;
    property NumCNPJCPFCorrenteFormatado: String read FNumCNPJCPFCorrenteFormatado write FNumCNPJCPFCorrenteFormatado;
    property CodPapelCorrente: Integer read FCodPapelCorrente write FCodPapelCorrente;
    property DesPapelCorrente: String read FDesPapelCorrente write FDesPapelCorrente;
    property CodPaisOrigem: Integer read FCodPaisOrigem write FCodPaisOrigem;
    property NomPaisOrigem: String read FNomPaisOrigem write FNomPaisOrigem;
    property DesPropriedadeOrigem: String read FDesPropriedadeOrigem write FDesPropriedadeOrigem;
    property DtaAutorizacaoImportacao: TDateTime read FDtaAutorizacaoImportacao write FDtaAutorizacaoImportacao;
    property DtaEntradaPais: TDateTime read FDtaEntradaPais write FDtaEntradaPais;
    property NumGuiaImportacao: String read FNumGuiaImportacao write FNumGuiaImportacao;
    property NumLicencaImportacao: String read FNumLicencaImportacao write FNumLicencaImportacao;
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property DtaGravacaoSisbov: TDateTime read FDtaGravacaoSisbov write FDtaGravacaoSisbov;
    property NomArquivoSisbov: String read FNomArquivoSisbov write FNomArquivoSisbov;
    property CodTipoLugar: Integer read FCodTipoLugar write FCodTipoLugar;
    property SglTipoLugar: String read FSglTipoLugar write FSglTipoLugar;
    property DesTipoLugar: String read FDesTipoLugar write FDesTipoLugar;

    property NumTransponder           : String  read FNumTransponder           write FNumTransponder;
    property CodTipoIdentificador1    : Integer read FCodTipoIdentificador1    write FCodTipoIdentificador1;
    property SglTipoIdentificador1    : String  read FSglTipoIdentificador1    write FSglTipoIdentificador1;
    property DesTipoIdentificador1    : String  read FDesTipoIdentificador1    write FDesTipoIdentificador1;
    property CodPosicaoIdentificador1 : Integer read FCodPosicaoIdentificador1 write FCodPosicaoIdentificador1;
    property SglPosicaoIdentificador1 : String  read FSglPosicaoIdentificador1 write FSglPosicaoIdentificador1;
    property DesPosicaoIdentificador1 : String  read FDesPosicaoIdentificador1 write FDesPosicaoIdentificador1;

    property CodTipoIdentificador2    : Integer read FCodTipoIdentificador2    write FCodTipoIdentificador2;
    property SglTipoIdentificador2    : String  read FSglTipoIdentificador2    write FSglTipoIdentificador2;
    property DesTipoIdentificador2    : String  read FDesTipoIdentificador2    write FDesTipoIdentificador2;
    property CodPosicaoIdentificador2 : Integer read FCodPosicaoIdentificador2 write FCodPosicaoIdentificador2;
    property SglPosicaoIdentificador2 : String  read FSglPosicaoIdentificador2 write FSglPosicaoIdentificador2;
    property DesPosicaoIdentificador2 : String  read FDesPosicaoIdentificador2 write FDesPosicaoIdentificador2;

    property CodTipoIdentificador3    : Integer read FCodTipoIdentificador3    write FCodTipoIdentificador3;
    property SglTipoIdentificador3    : String  read FSglTipoIdentificador3    write FSglTipoIdentificador3;
    property DesTipoIdentificador3    : String  read FDesTipoIdentificador3    write FDesTipoIdentificador3;
    property CodPosicaoIdentificador3 : Integer read FCodPosicaoIdentificador3 write FCodPosicaoIdentificador3;
    property SglPosicaoIdentificador3 : String  read FSglPosicaoIdentificador3 write FSglPosicaoIdentificador3;
    property DesPosicaoIdentificador3 : String  read FDesPosicaoIdentificador3 write FDesPosicaoIdentificador3;

    property CodTipoIdentificador4    : Integer read FCodTipoIdentificador4    write FCodTipoIdentificador4;
    property SglTipoIdentificador4    : String  read FSglTipoIdentificador4    write FSglTipoIdentificador4;
    property DesTipoIdentificador4    : String  read FDesTipoIdentificador4    write FDesTipoIdentificador4;
    property CodPosicaoIdentificador4 : Integer read FCodPosicaoIdentificador4 write FCodPosicaoIdentificador4;
    property SglPosicaoIdentificador4 : String  read FSglPosicaoIdentificador4 write FSglPosicaoIdentificador4;
    property DesPosicaoIdentificador4 : String  read FDesPosicaoIdentificador4 write FDesPosicaoIdentificador4;
    property IndPessoaSecundaria      : String  read FIndPessoaSecundaria      write FIndPessoaSecundaria;

    property NomAssociacaoRaca        : String  read FNomAssociacaoRaca        write FNomAssociacaoRaca;
    property DesGrauSangue            : String  read FDesGrauSangue            write FDesGrauSangue;

    property NumGta                   : String  read FNumGta                   write FNumGta;
    property DtaEmissaoGta            : TDateTime read FDtaEmissaoGta          write FDtaEmissaoGta;
    property NumNotaFiscal            : Integer read FNumNotaFiscal            write FNumNotaFiscal;

    property NomMunicipioIdentificacao : String read FNomMunicipioIdentificacao write FNomMunicipioIdentificacao;
    property SglEstadoIdentificacao    : String read FSglEstadoIdentificacao    write FSglEstadoIdentificacao;
    property NomMunicipioNascimento    : String read FNomMunicipioNascimento    write FNomMunicipioNascimento;
    property SglEstadoNascimento       : String read FSglEstadoNascimento       write FSglEstadoNascimento;

    property DesComposicaoRacial       : String read FDesComposicaoRacial       write FDesComposicaoRacial;

    property IndAptoCobertura          : String read FIndAptoCobertura          write FIndAptoCobertura;
    property IndCadastroParto          : String read FIndCadastroParto          write FIndCadastroParto;
    property IndCodSisBovReservado     : String read FIndCodSisBovReservado     write FIndCodSisBovReservado;

    property CodPessoaTecnico          : Integer read FCodPessoaTecnico         write FCodPessoaTecnico;
    property NomPessoaTecnico          : String read FNomPessoaTecnico          write FNomPessoaTecnico;

    property NomPessoaVendedor:        String read FNomPessoaVendedor           write FNomPessoaVendedor;
    property NomPessoaProdutor:        String read FNomPessoaProdutor           write FNomPessoaProdutor;
  end;

implementation

end.
