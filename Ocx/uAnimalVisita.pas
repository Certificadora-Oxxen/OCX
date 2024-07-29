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
unit uAnimalVisita;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAnimalVisita = class(TASPMTSObject, IAnimalVisita)
  private
    FNomPessoaProdutor: WideString;
    FNumCNPJCPFProdutorFormatado: WideString;
    FCodPessoaNatureza : WideString;

    FSglFazendaManejo: WideString;
    FCodAnimalManejo: WideString;
    FCodAnimalCertificadora: WideString;
    FNomArquivoImagemManejo: WideString;

    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;
    
    FDtaIdentificacaoSisbov: TDateTime;
    FNumImovelIdentificacao: WideString;
    FNomPropriedadeIdentificacao: WideString;
    FNomFazendaIdentificacao: WideString;
    FNomArquivoImagemIdentificacao: WideString;
    FNomMunicipioIdentificacao: WideString;
    FSglEstadoIdentificacao: WideString;

    FDtaNascimento : TDateTime;
    FNumImovelNascimento: WideString;
    FNomPropriedadeNascimento: WideString;
    FNomFazendaNascimento: WideString;
    FNomArquivoImagemNascimento: WideString;
    FNomMunicipioNascimento: WideString;
    FSglEstadoNascimento: WideString;

    FNomAnimal  : WideString;
    FDesApelido : WideString;
    FDesEspecie : WideString;
    FDesAptidao : WideString;
    FDesRaca    : WideString;
    FDesPelagem : WideString;
    FIndSexo    : WideString;
    FIndAnimalCastrado: WideString;
    FSglAssociacaoRaca: WideString;
    FSglGrauSangue: WideString;
    FNumRGD: WideString;

  protected
    function Get_NomPessoaProdutor: WideString; safecall;
    function Get_NumCNPJCPFProdutorFormatado: WideString; safecall;
    procedure Set_NomPessoaProdutor(const Value: WideString); safecall;
    function Get_CodAnimalCertificadora: WideString; safecall;
    function Get_CodAnimalManejo: WideString; safecall;
    function Get_CodAnimalSISBOV: Integer; safecall;
    function Get_CodEstadoSISBOV: Integer; safecall;
    function Get_CodMicroRegiaoSISBOV: Integer; safecall;
    function Get_CodPaisSISBOV: Integer; safecall;
    function Get_DtaIdentificacaoSISBOV: TDateTime; safecall;
    function Get_NumDvSISBOV: Integer; safecall;
    function Get_NumImovelIdentificacao: WideString; safecall;
    function Get_SglFazendaManejo: WideString; safecall;
    procedure Set_CodAnimalCertificadora(const Value: WideString); safecall;
    procedure Set_CodAnimalManejo(const Value: WideString); safecall;
    procedure Set_CodAnimalSISBOV(Value: Integer); safecall;
    procedure Set_CodEstadoSISBOV(Value: Integer); safecall;
    procedure Set_CodMicroRegiaoSISBOV(Value: Integer); safecall;
    procedure Set_CodPaisSISBOV(Value: Integer); safecall;
    procedure Set_DtaIdentificacaoSISBOV(Value: TDateTime); safecall;
    procedure Set_NumDvSISBOV(Value: Integer); safecall;
    procedure Set_NumImovelIdentificacao(const Value: WideString); safecall;
    procedure Set_SglFazendaManejo(const Value: WideString); safecall;
    function Get_NomPropriedadeIdentificacao: WideString; safecall;
    procedure Set_NomPropriedadeIdentificacao(const Value: WideString);
      safecall;
    function Get_NomArquivoImagemIdentificacao: WideString; safecall;
    function Get_NomFazendaIdentificacao: WideString; safecall;
    procedure Set_NomArquivoImagemIdentificacao(const Value: WideString);
      safecall;
    procedure Set_NomFazendaIdentificacao(const Value: WideString); safecall;
    function Get_DtaNascimento: TDateTime; safecall;
    function Get_NomArquivoImagemNascimento: WideString; safecall;
    function Get_NomFazendaNascimento: WideString; safecall;
    function Get_NomPropriedadeNascimento: WideString; safecall;
    function Get_NumImovelNascimento: WideString; safecall;
    procedure Set_DtaNascimento(Value: TDateTime); safecall;
    procedure Set_NomArquivoImagemNascimento(const Value: WideString);
      safecall;
    procedure Set_NomFazendaNascimento(const Value: WideString); safecall;
    procedure Set_NomPropriedadeNascimento(const Value: WideString); safecall;
    procedure Set_NumImovelNascimento(const Value: WideString); safecall;
    function Get_DesAptidao: WideString; safecall;
    function Get_DesEspecie: WideString; safecall;
    function Get_DesPelagem: WideString; safecall;
    function Get_DesRaca: WideString; safecall;
    function Get_IndAnimalCastrado: WideString; safecall;
    function Get_IndSexo: WideString; safecall;
    function Get_NomAnimal: WideString; safecall;
    procedure Set_DesAptidao(const Value: WideString); safecall;
    procedure Set_DesEspecie(const Value: WideString); safecall;
    procedure Set_DesPelagem(const Value: WideString); safecall;
    procedure Set_DesRaca(const Value: WideString); safecall;
    procedure Set_IndAnimalCastrado(const Value: WideString); safecall;
    procedure Set_IndSexo(const Value: WideString); safecall;
    procedure Set_NomAnimal(const Value: WideString); safecall;
    function Get_SglAssociacaoRaca: WideString; safecall;
    function Get_SglGrauSangue: WideString; safecall;
    procedure Set_SglAssociacaoRaca(const Value: WideString); safecall;
    procedure Set_SglGrauSangue(const Value: WideString); safecall;
    function Get_NumRGD: WideString; safecall;
    procedure Set_NumRGD(const Value: WideString); safecall;
    function Get_NomArquivoImagemManejo: WideString; safecall;
    function Get_NomMunicipioIdentificacao: WideString; safecall;
    function Get_NomMunicipioNascimento: WideString; safecall;
    function Get_SglEstadoIdentificacao: WideString; safecall;
    function Get_SglEstadoNascimento: WideString; safecall;
    procedure Set_NomArquivoImagemManejo(const Value: WideString); safecall;
    procedure Set_NomMunicipioIdentificacao(const Value: WideString); safecall;
    procedure Set_NomMunicipioNascimento(const Value: WideString); safecall;
    procedure Set_SglEstadoIdentificacao(const Value: WideString); safecall;
    procedure Set_SglEstadoNascimento(const Value: WideString); safecall;
    function Get_CodPessoaNatureza: WideString; safecall;
    procedure Set_CodPessoaNatureza(const Value: WideString); safecall;

  public
    property NomPessoaProdutor: WideString read FNomPessoaProdutor write FNomPessoaProdutor;
    property NumCNPJCPFProdutorFormatado: WideString read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
    property CodPessoaNatureza: WideString read FCodPessoaNatureza write FCodPessoaNatureza;

    property SglFazendaManejo: WideString read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: WideString read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalCertificadora  : WideString read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property NomArquivoImagemManejo : WideString read FNomArquivoImagemManejo write FNomArquivoImagemManejo;

    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;

    property DtaIdentificacaoSisbov: TDateTime read FDtaIdentificacaoSisbov write FDtaIdentificacaoSisbov;
    property NumImovelIdentificacao: WideString read FNumImovelIdentificacao write FNumImovelIdentificacao;
    property NomPropriedadeIdentificacao: WideString read FNomPropriedadeIdentificacao write FNomPropriedadeIdentificacao;
    property NomFazendaIdentificacao: WideString read FNomFazendaIdentificacao write FNomFazendaIdentificacao;
    property NomArquivoImagemIdentificacao: WideString read FNomArquivoImagemIdentificacao write FNomArquivoImagemIdentificacao;
    property NomMunicipioIdentificacao: WideString read FNomMunicipioIdentificacao write FNomMunicipioIdentificacao;
    property SglEstadoIdentificacao: WideString read FSglEstadoIdentificacao write FSglEstadoIdentificacao;

    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property NumImovelNascimento: WideString read FNumImovelNascimento write FNumImovelNascimento;
    property NomPropriedadeNascimento: WideString read FNomPropriedadeNascimento write FNomPropriedadeNascimento;
    property NomFazendaNascimento: WideString read FNomFazendaNascimento write FNomFazendaNascimento;
    property NomArquivoImagemNascimento: WideString read FNomArquivoImagemNascimento write FNomArquivoImagemNascimento;
    property NomMunicipioNascimento: WideString read FNomMunicipioNascimento write FNomMunicipioNascimento;
    property SglEstadoNascimento: WideString read FSglEstadoNascimento write FSglEstadoNascimento;

    property NomAnimal: WideString read FNomAnimal write FNomAnimal;
    property DesApelido: WideString read FDesApelido write FDesApelido;
    property DesEspecie: WideString read FDesEspecie write FDesEspecie;
    property DesAptidao: WideString read FDesAptidao write FDesAptidao;

    property DesRaca: WideString read FDesRaca write FDesRaca;
    property DesPelagem: WideString read FDesPelagem write FDesPelagem;
    property IndSexo: WideString read FIndSexo write FIndSexo;
    property IndAnimalCastrado: WideString read FIndAnimalCastrado write FIndAnimalCastrado;
    property SglAssociacaoRaca: WideString read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property SglGrauSangue: WideString read FSglGrauSangue write FSglGrauSangue;
    property NumRGD: WideString read FNumRGD write FNumRGD;
  end;

implementation

uses ComServ;


function TAnimalVisita.Get_NomPessoaProdutor: WideString;
begin
  result := FNomPessoaProdutor;
end;

function TAnimalVisita.Get_NumCNPJCPFProdutorFormatado: WideString;
begin
  result := FNumCNPJCPFProdutorFormatado;
end;

procedure TAnimalVisita.Set_NomPessoaProdutor(const Value: WideString);
begin
  FNomPessoaProdutor := value;
end;

function TAnimalVisita.Get_CodAnimalCertificadora: WideString;
begin
  result := FCodAnimalCertificadora;
end;

function TAnimalVisita.Get_CodAnimalManejo: WideString;
begin
  result := FCodAnimalManejo;
end;

function TAnimalVisita.Get_CodAnimalSISBOV: Integer;
begin
  result := FCodAnimalSISBOV;
end;

function TAnimalVisita.Get_CodEstadoSISBOV: Integer;
begin
  result := FCodEstadoSISBOV;
end;

function TAnimalVisita.Get_CodMicroRegiaoSISBOV: Integer;
begin
  result := FCodMicroRegiaoSISBOV;
end;

function TAnimalVisita.Get_CodPaisSISBOV: Integer;
begin
  result := FCodPaisSISBOV;
end;

function TAnimalVisita.Get_DtaIdentificacaoSISBOV: TDateTime;
begin
  result := FDtaIdentificacaoSISBOV;
end;

function TAnimalVisita.Get_NumDvSISBOV: Integer;
begin
  result := FNumDvSISBOV;
end;

function TAnimalVisita.Get_NumImovelIdentificacao: WideString;
begin
  result := FNumImovelIdentificacao;
end;

function TAnimalVisita.Get_SglFazendaManejo: WideString;
begin
  result := FSglFazendaManejo;
end;

procedure TAnimalVisita.Set_CodAnimalCertificadora(
  const Value: WideString);
begin
  FCodAnimalCertificadora := value;
end;

procedure TAnimalVisita.Set_CodAnimalManejo(const Value: WideString);
begin
  FCodAnimalManejo := value;
end;

procedure TAnimalVisita.Set_CodAnimalSISBOV(Value: Integer);
begin
  FCodAnimalSISBOV := value;
end;

procedure TAnimalVisita.Set_CodEstadoSISBOV(Value: Integer);
begin
  FCodEstadoSISBOV := value;
end;

procedure TAnimalVisita.Set_CodMicroRegiaoSISBOV(Value: Integer);
begin
  FCodMicroRegiaoSISBOV := value;
end;

procedure TAnimalVisita.Set_CodPaisSISBOV(Value: Integer);
begin
  FCodPaisSISBOV := value;
end;

procedure TAnimalVisita.Set_DtaIdentificacaoSISBOV(Value: TDateTime);
begin
  FDtaIdentificacaoSISBOV := value;
end;

procedure TAnimalVisita.Set_NumDvSISBOV(Value: Integer);
begin
  FNumDvSISBOV := value;
end;

procedure TAnimalVisita.Set_NumImovelIdentificacao(
  const Value: WideString);
begin
  FNumImovelIdentificacao := value;
end;

procedure TAnimalVisita.Set_SglFazendaManejo(const Value: WideString);
begin
  FSglFazendaManejo := value;
end;

function TAnimalVisita.Get_NomPropriedadeIdentificacao: WideString;
begin
  result := FNomPropriedadeIdentificacao;
end;

procedure TAnimalVisita.Set_NomPropriedadeIdentificacao(
  const Value: WideString);
begin
  FNomPropriedadeIdentificacao := value;
end;

function TAnimalVisita.Get_NomArquivoImagemIdentificacao: WideString;
begin
  result := FNomArquivoImagemIdentificacao;
end;

function TAnimalVisita.Get_NomFazendaIdentificacao: WideString;
begin
  result := FNomFazendaIdentificacao;
end;

procedure TAnimalVisita.Set_NomArquivoImagemIdentificacao(
  const Value: WideString);
begin
  FNomArquivoImagemIdentificacao := value;
end;

procedure TAnimalVisita.Set_NomFazendaIdentificacao(
  const Value: WideString);
begin
  FNomFazendaIdentificacao := value;
end;

function TAnimalVisita.Get_DtaNascimento: TDateTime;
begin
  result := FDtaNascimento;
end;

function TAnimalVisita.Get_NomArquivoImagemNascimento: WideString;
begin
  result := FNomArquivoImagemNascimento;
end;

function TAnimalVisita.Get_NomFazendaNascimento: WideString;
begin
  result := FNomFazendaNascimento;
end;

function TAnimalVisita.Get_NomPropriedadeNascimento: WideString;
begin
  result := FNomPropriedadeNascimento;
end;

function TAnimalVisita.Get_NumImovelNascimento: WideString;
begin
  result := FNumImovelNascimento;
end;

procedure TAnimalVisita.Set_DtaNascimento(Value: TDateTime);
begin
  FDtaNascimento := value;
end;

procedure TAnimalVisita.Set_NomArquivoImagemNascimento(
  const Value: WideString);
begin
  FNomArquivoImagemNascimento := value;
end;

procedure TAnimalVisita.Set_NomFazendaNascimento(const Value: WideString);
begin
  FNomFazendaNascimento := value;
end;

procedure TAnimalVisita.Set_NomPropriedadeNascimento(
  const Value: WideString);
begin
  FNomPropriedadeNascimento := value;
end;

procedure TAnimalVisita.Set_NumImovelNascimento(const Value: WideString);
begin
  FNumImovelNascimento := value;
end;

function TAnimalVisita.Get_DesAptidao: WideString;
begin
  result := FDesAptidao;
end;

function TAnimalVisita.Get_DesEspecie: WideString;
begin
  result := FDesEspecie;
end;

function TAnimalVisita.Get_DesPelagem: WideString;
begin
  result := FDesPelagem;
end;

function TAnimalVisita.Get_DesRaca: WideString;
begin
  result := FDesRaca;
end;

function TAnimalVisita.Get_IndAnimalCastrado: WideString;
begin
  result := FIndAnimalCastrado;
end;

function TAnimalVisita.Get_IndSexo: WideString;
begin
  result := FIndSexo;
end;

function TAnimalVisita.Get_NomAnimal: WideString;
begin
  result := FNomAnimal;
end;

procedure TAnimalVisita.Set_DesAptidao(const Value: WideString);
begin
  FDesAptidao := value;
end;

procedure TAnimalVisita.Set_DesEspecie(const Value: WideString);
begin
  FDesEspecie := value;
end;

procedure TAnimalVisita.Set_DesPelagem(const Value: WideString);
begin
  FDesPelagem := value;
end;

procedure TAnimalVisita.Set_DesRaca(const Value: WideString);
begin
  FDesRaca := value;
end;

procedure TAnimalVisita.Set_IndAnimalCastrado(const Value: WideString);
begin
  FIndAnimalCastrado := value;
end;

procedure TAnimalVisita.Set_IndSexo(const Value: WideString);
begin
  FIndSexo := value;
end;

procedure TAnimalVisita.Set_NomAnimal(const Value: WideString);
begin
  FNomAnimal := value;
end;

function TAnimalVisita.Get_SglAssociacaoRaca: WideString;
begin
  result := FSglAssociacaoRaca;
end;

function TAnimalVisita.Get_SglGrauSangue: WideString;
begin
  result := FSglGrauSangue;
end;

procedure TAnimalVisita.Set_SglAssociacaoRaca(const Value: WideString);
begin
  FSglAssociacaoRaca := value;
end;

procedure TAnimalVisita.Set_SglGrauSangue(const Value: WideString);
begin
  FSglGrauSangue := value;
end;

function TAnimalVisita.Get_NumRGD: WideString;
begin
  result := FNumRGD;
end;

procedure TAnimalVisita.Set_NumRGD(const Value: WideString);
begin
  FNumRGD := value;
end;

function TAnimalVisita.Get_NomArquivoImagemManejo: WideString;
begin
  result := FNomArquivoImagemManejo;
end;

function TAnimalVisita.Get_NomMunicipioIdentificacao: WideString;
begin
  result := FNomMunicipioIdentificacao;
end;

function TAnimalVisita.Get_NomMunicipioNascimento: WideString;
begin
  result := FNomMunicipioNascimento;
end;

function TAnimalVisita.Get_SglEstadoIdentificacao: WideString;
begin
  result := FSglEstadoIdentificacao;
end;

function TAnimalVisita.Get_SglEstadoNascimento: WideString;
begin
  result := FSglEstadoNascimento;
end;

procedure TAnimalVisita.Set_NomArquivoImagemManejo(
  const Value: WideString);
begin
  FNomArquivoImagemManejo := value;
end;

procedure TAnimalVisita.Set_NomMunicipioIdentificacao(
  const Value: WideString);
begin
  FNomMunicipioIdentificacao := value;
end;

procedure TAnimalVisita.Set_NomMunicipioNascimento(
  const Value: WideString);
begin
  FNomMunicipioNascimento := value;
end;

procedure TAnimalVisita.Set_SglEstadoIdentificacao(
  const Value: WideString);
begin
  FSglEstadoIdentificacao := value;
end;

procedure TAnimalVisita.Set_SglEstadoNascimento(const Value: WideString);
begin
  FSglEstadoNascimento := value;
end;

function TAnimalVisita.Get_CodPessoaNatureza: WideString;
begin
  result := FCodPessoaNatureza;
end;

procedure TAnimalVisita.Set_CodPessoaNatureza(const Value: WideString);
begin
  FCodPessoaNatureza := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnimalVisita, Class_AnimalVisita,
    ciMultiInstance, tmApartment);
end.
