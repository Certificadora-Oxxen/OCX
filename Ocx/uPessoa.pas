unit uPessoa;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPessoa = class(TASPMTSObject, IPessoa)
  private
    FCodPessoa: Integer;
    FNomPessoa: WideString;
    FNomReduzidoPessoa: WideString;
    FCodNaturezaPessoa: WideString;
    FNumCNPJCPF: WideString;
    FNumCNPJCPFFormatado: WideString;
    FDtaNascimento: TDateTime;
    FCodTelefonePrincipal: Integer;
    FSglTelefonePrincipal: WideString;
    FTxtTelefonePrincipal: WideString;
    FCodEMailPrincipal: Integer;
    FSglEMailPrincipal: WideString;
    FTxtEMailPrincipal: WideString;
    FCodTipoEndereco: Integer;
    FSglTipoEndereco: WideString;
    FDesTipoEndereco: WideString;
    FNomLogradouro: WideString;
    FNomBairro: WideString;
    FNumCEP: WideString;
    FCodPais: Integer;
    FNomPais: WideString;
    FCodEstado: Integer;
    FSglEstado: WideString;
    FCodMunicipio: Integer;
    FNomMunicipio: WideString;
    FNumMunicipioIBGE: WideString;
    FCodDistrito: Integer;
    FNomDistrito: WideString;
    FTxtObservacao: WideString;
    FDtaCadastramento: TDateTime;
    FIndProdutorBloqueado: WideString;
    FDtaEfetivacaoCadastro: TDateTime;
    FCodGrauInstrucao: Integer;
    FDesGrauInstrucao: WideString;
    FDesCursoSuperior: WideString;
    FSglConselhoRegional: WideString;
    FNumConselhoRegional: WideString;
    FSglProdutor: WideString;
    FIndEfetivadoUmaVez: WideString;
    FCodPessoaGestor: Integer;
    FNomGestor: WideString;
    FNomReduzidoGestor: WideString;
    FSexo: WideString;
    FNumIE: WideString;
    FDtaExp: TDateTime;
    FOrgaoIE: WideString;
    FUFIE: WideString;
    FIndEfetivadoUmaVezTecnico: WideString;
    FDtaEfetivacaoCadastroTecnico: TDateTime;
    FIndTecnicoAtivo: WideString;
  protected
    function Get_CodNaturezaPessoa: WideString; safecall;
    function Get_CodPessoa: Integer; safecall;
    function Get_NomPessoa: WideString; safecall;
    function Get_NomReduzidoPessoa: WideString; safecall;
    function Get_NumCNPJCPF: WideString; safecall;
    function Get_NumCNPJCPFFormatado: WideString; safecall;
    procedure Set_CodNaturezaPessoa(const Value: WideString); safecall;
    procedure Set_CodPessoa(Value: Integer); safecall;
    procedure Set_NomPessoa(const Value: WideString); safecall;
    procedure Set_NomReduzidoPessoa(const Value: WideString); safecall;
    procedure Set_NumCNPJCPF(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatado(const Value: WideString); safecall;
    function Get_CodDistrito: Integer; safecall;
    function Get_CodEMailPrincipal: Integer; safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_CodGrauInstrucao: Integer; safecall;
    function Get_CodMunicipio: Integer; safecall;
    function Get_CodPais: Integer; safecall;
    function Get_CodTelefonePrincipal: Integer; safecall;
    function Get_CodTipoEndereco: Integer; safecall;
    function Get_DesCursoSuperior: WideString; safecall;
    function Get_DesGrauInstrucao: WideString; safecall;
    function Get_DesTipoEndereco: WideString; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_DtaNascimento: TDateTime; safecall;
    function Get_IndProdutorBloqueado: WideString; safecall;
    function Get_NomBairro: WideString; safecall;
    function Get_NomDistrito: WideString; safecall;
    function Get_NomLogradouro: WideString; safecall;
    function Get_NomMunicipio: WideString; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_NumCEP: WideString; safecall;
    function Get_NumConselhoRegional: WideString; safecall;
    function Get_NumMunicipioIBGE: WideString; safecall;
    function Get_SglConselhoRegional: WideString; safecall;
    function Get_SglEMailPrincipal: WideString; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_SglTelefonePrincipal: WideString; safecall;
    function Get_SglTipoEndereco: WideString; safecall;
    function Get_TxtEMailPrincipal: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    function Get_TxtTelefonePrincipal: WideString; safecall;
    procedure Set_CodDistrito(Value: Integer); safecall;
    procedure Set_CodEMailPrincipal(Value: Integer); safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_CodGrauInstrucao(Value: Integer); safecall;
    procedure Set_CodMunicipio(Value: Integer); safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_CodTelefonePrincipal(Value: Integer); safecall;
    procedure Set_CodTipoEndereco(Value: Integer); safecall;
    procedure Set_DesCursoSuperior(const Value: WideString); safecall;
    procedure Set_DesGrauInstrucao(const Value: WideString); safecall;
    procedure Set_DesTipoEndereco(const Value: WideString); safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_DtaEfetivacaoCadastro(Value: TDateTime); safecall;
    procedure Set_DtaNascimento(Value: TDateTime); safecall;
    procedure Set_IndProdutorBloqueado(const Value: WideString); safecall;
    procedure Set_NomBairro(const Value: WideString); safecall;
    procedure Set_NomDistrito(const Value: WideString); safecall;
    procedure Set_NomLogradouro(const Value: WideString); safecall;
    procedure Set_NomMunicipio(const Value: WideString); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_NumCEP(const Value: WideString); safecall;
    procedure Set_NumConselhoRegional(const Value: WideString); safecall;
    procedure Set_NumMunicipioIBGE(const Value: WideString); safecall;
    procedure Set_SglConselhoRegional(const Value: WideString); safecall;
    procedure Set_SglEMailPrincipal(const Value: WideString); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_SglTelefonePrincipal(const Value: WideString); safecall;
    procedure Set_SglTipoEndereco(const Value: WideString); safecall;
    procedure Set_TxtEMailPrincipal(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    procedure Set_TxtTelefonePrincipal(const Value: WideString); safecall;
    function Get_SglProdutor: WideString; safecall;
    procedure Set_SglProdutor(const Value: WideString); safecall;
    function Get_IndEfetivadoUmaVez: WideString; safecall;
    procedure Set_IndEfetivadoUmaVez(const Value: WideString); safecall;
    function Get_CodPessoaGestor: Integer; safecall;
    function Get_NomGestor: WideString; safecall;
    function Get_NomReduzidoGestor: WideString; safecall;
    procedure Set_CodPessoaGestor(Value: Integer); safecall;
    procedure Set_NomGestor(const Value: WideString); safecall;
    procedure Set_NomReduzidoGestor(const Value: WideString); safecall;
    function Get_Sexo: WideString; safecall;
    procedure Set_Sexo(const Value: WideString); safecall;
    function Get_NumIE: WideString; safecall;
    procedure Set_NumIE(const Value: WideString); safecall;
    function Get_DtaEfetivacaoCadastroTecnico: TDateTime; safecall;
    function Get_IndEfetivadoUmaVezTecnico: WideString; safecall;
    procedure Set_DtaEfetivacaoCadastroTecnico(Value: TDateTime); safecall;
    procedure Set_IndEfetivadoUmaVezTecnico(const Value: WideString); safecall;
    function Get_DtaExp: TDateTime; safecall;
    function Get_OrgaoIE: WideString; safecall;
    function Get_UFIE: WideString; safecall;
    procedure Set_DtaExp(Value: TDateTime); safecall;
    procedure Set_OrgaoIE(const Value: WideString); safecall;
    procedure Set_UFIE(const Value: WideString); safecall;
    function Get_IndTecnicoAtivo: WideString; safecall;
    procedure Set_IndTecnicoAtivo(const Value: WideString); safecall;
  public
    property CodPessoa: Integer read FCodPessoa write FCodPessoa;
    property NomPessoa: WideString read FNomPessoa write FNomPessoa;
    property NomReduzidoPessoa: WideString read FNomReduzidoPessoa write FNomReduzidoPessoa;
    property CodNaturezaPessoa: WideString read FCodNaturezaPessoa write FCodNaturezaPessoa;
    property NumCNPJCPF: WideString read FNumCNPJCPF write FNumCNPJCPF;
    property NumCNPJCPFFormatado: WideString read FNumCNPJCPFFormatado write FNumCNPJCPFFormatado;
    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property CodTelefonePrincipal: Integer read FCodTelefonePrincipal write FCodTelefonePrincipal;
    property SglTelefonePrincipal: WideString read FSglTelefonePrincipal write FSglTelefonePrincipal;
    property TxtTelefonePrincipal: WideString read FTxtTelefonePrincipal write FTxtTelefonePrincipal;
    property CodEMailPrincipal: Integer read FCodEMailPrincipal write FCodEMailPrincipal;
    property SglEMailPrincipal: WideString read FSglEMailPrincipal write FSglEMailPrincipal;
    property TxtEMailPrincipal: WideString read FTxtEMailPrincipal write FTxtEMailPrincipal;
    property CodTipoEndereco: Integer read FCodTipoEndereco write FCodTipoEndereco;
    property SglTipoEndereco: WideString read FSglTipoEndereco write FSglTipoEndereco;
    property DesTipoEndereco: WideString read FDesTipoEndereco write FDesTipoEndereco;
    property NomLogradouro: WideString read FNomLogradouro write FNomLogradouro;
    property NomBairro: WideString read FNomBairro write FNomBairro;
    property NumCEP: WideString read FNumCEP write FNumCEP;
    property CodPais: Integer read FCodPais write FCodPais;
    property NomPais: WideString read FNomPais write FNomPais;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: WideString read FSglEstado write FSglEstado;
    property CodMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property NomMunicipio: WideString read FNomMunicipio write FNomMunicipio;
    property NumMunicipioIBGE: WideString read FNumMunicipioIBGE write FNumMunicipioIBGE;
    property CodDistrito: Integer read FCodDistrito write FCodDistrito;
    property NomDistrito: WideString read FNomDistrito write FNomDistrito;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndProdutorBloqueado: WideString read FIndProdutorBloqueado write FIndProdutorBloqueado;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property CodGrauInstrucao: Integer read FCodGrauInstrucao write FCodGrauInstrucao;
    property DesGrauInstrucao: WideString read FDesGrauInstrucao write FDesGrauInstrucao;
    property DesCursoSuperior: WideString read FDesCursoSuperior write FDesCursoSuperior;
    property SglConselhoRegional: WideString read FSglConselhoRegional write FSglConselhoRegional;
    property NumConselhoRegional: WideString read FNumConselhoRegional write FNumConselhoRegional;
    property SglProdutor: WideString read FSglProdutor write FSglProdutor;
    property IndEfetivadoUmaVez: WideString read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodPessoaGestor: Integer read FCodPessoaGestor write FCodPessoaGestor;
    property NomGestor: WideString read FNomGestor write FNomGestor;
    property NomReduzidoGestor: WideString read FNomReduzidoGestor write FNomReduzidoGestor;
    property Sexo: WideString read FSexo write FSexo;
    property NumIE: WideString read FNumIE write FNumIE;
    property DtaExp: TDateTime read FDtaExp write FDtaExp;
    property OrgaoIE: WideString read FOrgaoIE write FOrgaoIE;
    property UFIE: WideString read FUFIE write FUFIE;
    property IndEfetivadoUmaVezTecnico: WideString read FIndEfetivadoUmaVezTecnico write FIndEfetivadoUmaVezTecnico;
    property DtaEfetivacaoCadastroTecnico: TDateTime read FDtaEfetivacaoCadastroTecnico write FDtaEfetivacaoCadastroTecnico;
    property IndTecnicoAtivo: WideString read FIndTecnicoAtivo write FIndTecnicoAtivo;
  end;

implementation

uses ComServ;

function TPessoa.Get_CodNaturezaPessoa: WideString;
begin
  Result := FCodNaturezaPessoa;
end;

function TPessoa.Get_CodPessoa: Integer;
begin
  Result := FCodPessoa;
end;

function TPessoa.Get_NomPessoa: WideString;
begin
  Result := FNomPessoa;
end;

function TPessoa.Get_NomReduzidoPessoa: WideString;
begin
  Result := FNomReduzidoPessoa;
end;

function TPessoa.Get_NumCNPJCPF: WideString;
begin
  Result := FNumCNPJCPF;
end;

function TPessoa.Get_NumCNPJCPFFormatado: WideString;
begin
  Result := FNumCNPJCPFFormatado;
end;

procedure TPessoa.Set_CodNaturezaPessoa(const Value: WideString);
begin
  FCodNaturezaPessoa := Value;
end;

procedure TPessoa.Set_CodPessoa(Value: Integer);
begin
  FCodPessoa := Value;
end;

procedure TPessoa.Set_NomPessoa(const Value: WideString);
begin
  FNomPessoa := Value;
end;

procedure TPessoa.Set_NomReduzidoPessoa(const Value: WideString);
begin
  FNomReduzidoPessoa := Value;
end;

procedure TPessoa.Set_NumCNPJCPF(const Value: WideString);
begin
  FNumCNPJCPF := Value;
end;

procedure TPessoa.Set_NumCNPJCPFFormatado(const Value: WideString);
begin
  FNumCNPJCPFFormatado := Value;
end;

function TPessoa.Get_CodDistrito: Integer;
begin
  Result := FCodDistrito;
end;

function TPessoa.Get_CodEMailPrincipal: Integer;
begin
  Result := FCodEMailPrincipal;
end;

function TPessoa.Get_CodEstado: Integer;
begin
  Result := FCodEstado;
end;

function TPessoa.Get_CodGrauInstrucao: Integer;
begin
  Result := FCodGrauInstrucao;
end;

function TPessoa.Get_CodMunicipio: Integer;
begin
  Result := FCodMunicipio;
end;

function TPessoa.Get_CodPais: Integer;
begin
  Result := FCodPais;
end;

function TPessoa.Get_CodTelefonePrincipal: Integer;
begin
  Result := FCodTelefonePrincipal;
end;

function TPessoa.Get_CodTipoEndereco: Integer;
begin
  Result := FCodTipoEndereco;
end;

function TPessoa.Get_DesCursoSuperior: WideString;
begin
  Result := FDesCursoSuperior;
end;

function TPessoa.Get_DesGrauInstrucao: WideString;
begin
  Result := FDesGrauInstrucao;
end;

function TPessoa.Get_DesTipoEndereco: WideString;
begin
  Result := FDesTipoEndereco;
end;

function TPessoa.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TPessoa.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  Result := FDtaEfetivacaoCadastro;
end;

function TPessoa.Get_DtaNascimento: TDateTime;
begin
  Result := FDtaNascimento;
end;

function TPessoa.Get_IndProdutorBloqueado: WideString;
begin
  Result := FIndProdutorBloqueado;
end;

function TPessoa.Get_NomBairro: WideString;
begin
  Result := FNomBairro;
end;

function TPessoa.Get_NomDistrito: WideString;
begin
  Result := FNomDistrito;
end;

function TPessoa.Get_NomLogradouro: WideString;
begin
  Result := FNomLogradouro;
end;

function TPessoa.Get_NomMunicipio: WideString;
begin
  Result := FNomMunicipio;
end;

function TPessoa.Get_NomPais: WideString;
begin
  Result := FNomPais;
end;

function TPessoa.Get_NumCEP: WideString;
begin
  Result := FNumCEP;
end;

function TPessoa.Get_NumConselhoRegional: WideString;
begin
  Result := FNumConselhoRegional;
end;

function TPessoa.Get_NumMunicipioIBGE: WideString;
begin
  Result := FNumMunicipioIBGE;
end;

function TPessoa.Get_SglConselhoRegional: WideString;
begin
  Result := FSglConselhoRegional;
end;

function TPessoa.Get_SglEMailPrincipal: WideString;
begin
  Result := FSglEMailPrincipal;
end;

function TPessoa.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

function TPessoa.Get_SglTelefonePrincipal: WideString;
begin
  Result := FSglTelefonePrincipal;
end;

function TPessoa.Get_SglTipoEndereco: WideString;
begin
  Result := FSglTipoEndereco;
end;

function TPessoa.Get_TxtEMailPrincipal: WideString;
begin
  Result := FTxtEMailPrincipal;
end;

function TPessoa.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

function TPessoa.Get_TxtTelefonePrincipal: WideString;
begin
  Result := FTxtTelefonePrincipal;
end;

procedure TPessoa.Set_CodDistrito(Value: Integer);
begin
  CodDistrito := Value;
end;

procedure TPessoa.Set_CodEMailPrincipal(Value: Integer);
begin
  CodEMailPrincipal := Value;
end;

procedure TPessoa.Set_CodEstado(Value: Integer);
begin
  CodEstado := Value;
end;

procedure TPessoa.Set_CodGrauInstrucao(Value: Integer);
begin
  CodGrauInstrucao := Value;
end;

procedure TPessoa.Set_CodMunicipio(Value: Integer);
begin
  CodMunicipio := Value;
end;

procedure TPessoa.Set_CodPais(Value: Integer);
begin
  CodPais := Value;
end;

procedure TPessoa.Set_CodTelefonePrincipal(Value: Integer);
begin
  CodTelefonePrincipal := Value;
end;

procedure TPessoa.Set_CodTipoEndereco(Value: Integer);
begin
  CodTipoEndereco := Value;
end;

procedure TPessoa.Set_DesCursoSuperior(const Value: WideString);
begin
  DesCursoSuperior := Value;
end;

procedure TPessoa.Set_DesGrauInstrucao(const Value: WideString);
begin
  DesGrauInstrucao := Value;
end;

procedure TPessoa.Set_DesTipoEndereco(const Value: WideString);
begin
  DesTipoEndereco := Value;
end;

procedure TPessoa.Set_DtaCadastramento(Value: TDateTime);
begin
  DtaCadastramento := Value;
end;

procedure TPessoa.Set_DtaEfetivacaoCadastro(Value: TDateTime);
begin
  DtaEfetivacaoCadastro := Value;
end;

procedure TPessoa.Set_DtaNascimento(Value: TDateTime);
begin
  DtaNascimento := Value;
end;

procedure TPessoa.Set_IndProdutorBloqueado(const Value: WideString);
begin
  IndProdutorBloqueado := Value;
end;

procedure TPessoa.Set_NomBairro(const Value: WideString);
begin
  NomBairro := Value;
end;

procedure TPessoa.Set_NomDistrito(const Value: WideString);
begin
  NomDistrito := Value;
end;

procedure TPessoa.Set_NomLogradouro(const Value: WideString);
begin
  NomLogradouro := Value;
end;

procedure TPessoa.Set_NomMunicipio(const Value: WideString);
begin
  NomMunicipio := Value;
end;

procedure TPessoa.Set_NomPais(const Value: WideString);
begin
  NomPais := Value;
end;

procedure TPessoa.Set_NumCEP(const Value: WideString);
begin
  NumCEP := Value;
end;

procedure TPessoa.Set_NumConselhoRegional(const Value: WideString);
begin
  NumConselhoRegional := Value;
end;

procedure TPessoa.Set_NumMunicipioIBGE(const Value: WideString);
begin
  NumMunicipioIBGE := Value;
end;

procedure TPessoa.Set_SglConselhoRegional(const Value: WideString);
begin
  SglConselhoRegional := Value;
end;

procedure TPessoa.Set_SglEMailPrincipal(const Value: WideString);
begin
  SglEMailPrincipal := Value;
end;

procedure TPessoa.Set_SglEstado(const Value: WideString);
begin
  SglEstado := Value;
end;

procedure TPessoa.Set_SglTelefonePrincipal(const Value: WideString);
begin
  SglTelefonePrincipal := Value;
end;

procedure TPessoa.Set_SglTipoEndereco(const Value: WideString);
begin
  SglTipoEndereco := Value;
end;

procedure TPessoa.Set_TxtEMailPrincipal(const Value: WideString);
begin
  TxtEMailPrincipal := Value;
end;

procedure TPessoa.Set_TxtObservacao(const Value: WideString);
begin
  TxtObservacao := Value;
end;

procedure TPessoa.Set_TxtTelefonePrincipal(const Value: WideString);
begin
  TxtTelefonePrincipal := Value;
end;

function TPessoa.Get_SglProdutor: WideString;
begin
  Result := FSglProdutor;
end;

procedure TPessoa.Set_SglProdutor(const Value: WideString);
begin
  FSglProdutor := Value;
end;

function TPessoa.Get_IndEfetivadoUmaVez: WideString;
begin
  Result := FIndEfetivadoUmaVez;
end;

procedure TPessoa.Set_IndEfetivadoUmaVez(const Value: WideString);
begin
  FIndEfetivadoUmaVez := Value;
end;

function TPessoa.Get_CodPessoaGestor: Integer;
begin
  Result := FCodPessoaGestor;
end;

function TPessoa.Get_NomGestor: WideString;
begin
  Result := FNomGestor;
end;

function TPessoa.Get_NomReduzidoGestor: WideString;
begin
  Result := FNomReduzidoGestor;
end;

procedure TPessoa.Set_CodPessoaGestor(Value: Integer);
begin
  FCodPessoaGestor := Value;
end;

procedure TPessoa.Set_NomGestor(const Value: WideString);
begin
  FNomGestor := Value;
end;

procedure TPessoa.Set_NomReduzidoGestor(const Value: WideString);
begin
  FNomReduzidoGestor := Value;
end;

procedure TPessoa.Set_Sexo(const Value: WideString);
begin
  FSexo := Value;
end;

function TPessoa.Get_Sexo: WideString;
begin
  Result := FSexo;
end;

function TPessoa.Get_NumIE: WideString;
begin
  Result := FNumIE;
end;

procedure TPessoa.Set_NumIE(const Value: WideString);
begin
  FNumIE := Value;
end;

function TPessoa.Get_DtaEfetivacaoCadastroTecnico: TDateTime;
begin
  Result := FDtaEfetivacaoCadastroTecnico;
end;

function TPessoa.Get_IndEfetivadoUmaVezTecnico: WideString;
begin
  Result := FIndEfetivadoUmaVezTecnico;
end;

procedure TPessoa.Set_DtaEfetivacaoCadastroTecnico(Value: TDateTime);
begin
  FDtaEfetivacaoCadastroTecnico := Value;
end;

procedure TPessoa.Set_IndEfetivadoUmaVezTecnico(const Value: WideString);
begin
  FIndEfetivadoUmaVezTecnico := Value;
end;

function TPessoa.Get_DtaExp: TDateTime;
begin
  Result := FDtaExp;
end;

function TPessoa.Get_OrgaoIE: WideString;
begin
  Result := FOrgaoIE;
end;

function TPessoa.Get_UFIE: WideString;
begin
  Result := FUFIE;
end;

procedure TPessoa.Set_DtaExp(Value: TDateTime);
begin
  FDtaExp := Value;
end;

procedure TPessoa.Set_OrgaoIE(const Value: WideString);
begin
  FOrgaoIE := Value;
end;

procedure TPessoa.Set_UFIE(const Value: WideString);
begin
  FUFIE := Value;
end;

function TPessoa.Get_IndTecnicoAtivo: WideString;
begin
  Result := FIndTecnicoAtivo;
end;

procedure TPessoa.Set_IndTecnicoAtivo(const Value: WideString);
begin
  FIndTecnicoAtivo := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPessoa, Class_Pessoa,
    ciMultiInstance, tmApartment);
end.
