// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 14/11/2002
// *  Documentação       : Anúnicio ded Banners - Definição das classes.doc
// *  Código Classe      : 72
// *  Descrição Resumida : Buscar dados do Animal Visita
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    14/11/2002    Criação
// *
// ********************************************************************
unit uIntAnimalVisita;

interface

type
  TIntAnimalVisita = class
  private
    FNomPessoaProdutor: String;
    FNumCNPJCPFProdutorFormatado: String;
    FCodPessoaNatureza : String;

    FSglFazendaManejo: String;
    FCodAnimalManejo: String;
    FCodAnimalCertificadora: String;
    FNomArquivoImagemManejo: String;

    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;

    FDtaIdentificacaoSisbov: TDateTime;
    FNumImovelIdentificacao: String;
    FNomPropriedadeIdentificacao: String;
    FNomFazendaIdentificacao: String;
    FNomArquivoImagemIdentificacao: String;
    FNomMunicipioIdentificacao: String;
    FSglEstadoIdentificacao: String;

    FDtaNascimento : TDateTime;
    FNumImovelNascimento: String;
    FNomPropriedadeNascimento: String;
    FNomFazendaNascimento: String;
    FNomArquivoImagemNascimento: String;
    FNomMunicipioNascimento: String;
    FSglEstadoNascimento: String;

    FNomAnimal  : String;
    FDesApelido : String;
    FDesEspecie : String;
    FDesAptidao : String;
    FDesRaca    : String;
    FDesPelagem : String;
    FIndSexo    : String;
    FIndAnimalCastrado: String;
    FSglAssociacaoRaca: String;
    FSglGrauSangue: String;
    FNumRGD: String;
  public
    property NomPessoaProdutor: String read FNomPessoaProdutor write FNomPessoaProdutor;
    property NumCNPJCPFProdutorFormatado: String read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
    property CodPessoaNatureza: String read FCodPessoaNatureza write FCodPessoaNatureza;

    property SglFazendaManejo: String read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: String read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalCertificadora  : String read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property NomArquivoImagemManejo : String read FNomArquivoImagemManejo write FNomArquivoImagemManejo;

    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;

    property DtaIdentificacaoSisbov: TDateTime read FDtaIdentificacaoSisbov write FDtaIdentificacaoSisbov;
    property NumImovelIdentificacao: String read FNumImovelIdentificacao write FNumImovelIdentificacao;
    property NomPropriedadeIdentificacao: String read FNomPropriedadeIdentificacao write FNomPropriedadeIdentificacao;
    property NomFazendaIdentificacao: String read FNomFazendaIdentificacao write FNomFazendaIdentificacao;
    property NomArquivoImagemIdentificacao: String read FNomArquivoImagemIdentificacao write FNomArquivoImagemIdentificacao;
    property NomMunicipioIdentificacao: String read FNomMunicipioIdentificacao write FNomMunicipioIdentificacao;
    property SglEstadoIdentificacao: String read FSglEstadoIdentificacao write FSglEstadoIdentificacao;

    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property NumImovelNascimento: String read FNumImovelNascimento write FNumImovelNascimento;
    property NomPropriedadeNascimento: String read FNomPropriedadeNascimento write FNomPropriedadeNascimento;
    property NomFazendaNascimento: String read FNomFazendaNascimento write FNomFazendaNascimento;
    property NomArquivoImagemNascimento: String read FNomArquivoImagemNascimento write FNomArquivoImagemNascimento;
    property NomMunicipioNascimento: String read FNomMunicipioNascimento write FNomMunicipioNascimento;
    property SglEstadoNascimento: String read FSglEstadoNascimento write FSglEstadoNascimento;

    property NomAnimal: String read FNomAnimal write FNomAnimal;
    property DesApelido: String read FDesApelido write FDesApelido;
    property DesEspecie: String read FDesEspecie write FDesEspecie;
    property DesAptidao: String read FDesAptidao write FDesAptidao;

    property DesRaca: String read FDesRaca write FDesRaca;
    property DesPelagem: String read FDesPelagem write FDesPelagem;
    property IndSexo: String read FIndSexo write FIndSexo;
    property IndAnimalCastrado: String read FIndAnimalCastrado write FIndAnimalCastrado;
    property SglAssociacaoRaca: String read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property SglGrauSangue: String read FSglGrauSangue write FSglGrauSangue;
    property NumRGD: String read FNumRGD write FNumRGD;
  end;

implementation

end.
