unit uPropriedadeRural;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uPessoa;

type
  TPropriedadeRural = class(TASPMTSObject, IPropriedadeRural)
  private
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: WideString;
    FNumImovelReceitaFederal: WideString;
    FNumLatitude: Integer;
    FNumLongitude: Integer;
    FQtdArea: Double;
    FNomLogradouro: WideString;
    FNomBairro: WideString;
    FNumCEP: WideString;
    FCodPais: Integer;
    FNomPais: WideString;
    FCodPaisSisbov: Integer;
    FCodEstado: Integer;
    FSglEstado: WideString;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiao: Integer;
    FNomMicroRegiao: WideString;
    FCodMicroRegiaoSisbov: Integer;
    FCodMunicipio: Integer;
    FNomMunicipio: WideString;
    FCodDistrito: Integer;
    FNomDistrito: WideString;
    FNomPessoaContato: WideString;
    FNumTelefone: WideString;
    FNumFax: WideString;
    FNomLogradouroCorrespondencia: WideString;
    FNomBairroCorrespondencia: WideString;
    FNumCEPCorrespondencia: WideString;
    FCodPaisCorrespondencia: Integer;
    FNomPaisCorrespondencia: WideString;
    FCodPaisSisbovCorrespondencia: Integer;
    FCodEstadoCorrespondencia: Integer;
    FSglEstadoCorrespondencia: WideString;
    FCodEstadoSisbovCorrespondencia: Integer;
    FCodMunicipioCorrespondencia: Integer;
    FNomMunicipioCorrespondencia: WideString;
    FCodDistritoCorrespondencia: Integer;
    FNomDistritoCorrespondencia: WideString;
    FDtaInicioCertificacao: TDateTime;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FTxtObservacao: WideString;
    FIndEfetivadoUmaVez: WideString;
    FCodTipoInscricao: Integer;
    FOrientacaoLat: WideString;
    FOrientacaoLon: WideString;
    FCodPessoaProprietario: Integer;
    FNomPessoaProprietario: WideString;
    FCodNaturezaPessoaProp: WideString;
    FNumCNPJCPFFormatadoProp: WideString;
    FCodTipoPropriedadeRural: Integer;
    FDesTipoPropriedadeRural: WideString;
    FCodIdPropriedadeSisbov: Integer;
    FData_Inicio_Confinamento:TDateTime;
    FData_Fim_Confinamento:TDateTime;
    FDtaInicioPeriodoAjusteRebanho:TDateTime;
  protected
    function Get_CodDistrito: Integer; safecall;
    function Get_CodDistritoCorrespondencia: Integer; safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_CodEstadoCorrespondencia: Integer; safecall;
    function Get_CodEstadoSisbov: Integer; safecall;
    function Get_CodEstadoSisbovCorrespondencia: Integer; safecall;
    function Get_CodMicroRegiao: Integer; safecall;
    function Get_CodMicroRegiaoSisbov: Integer; safecall;
    function Get_CodMunicipio: Integer; safecall;
    function Get_CodMunicipioCorrespondencia: Integer; safecall;
    function Get_CodPais: Integer; safecall;
    function Get_CodPaisCorrespondencia: Integer; safecall;
    function Get_CodPaisSisbov: Integer; safecall;
    function Get_CodPaisSisbovCorrespondencia: Integer; safecall;
    function Get_CodPropriedadeRural: Integer; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_IndEfetivadoUmaVez: WideString; safecall;
    function Get_DtaInicioCertificacao: TDateTime; safecall;
    function Get_NomBairro: WideString; safecall;
    function Get_NomBairroCorrespondencia: WideString; safecall;
    function Get_NomDistrito: WideString; safecall;
    function Get_NomDistritoCorrespondencia: WideString; safecall;
    function Get_NomLogradouro: WideString; safecall;
    function Get_NomLogradouroCorrespondencia: WideString; safecall;
    function Get_NomMicroRegiao: WideString; safecall;
    function Get_NomMunicipio: WideString; safecall;
    function Get_NomMunicipioCorrespondencia: WideString; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_NomPaisCorrespondencia: WideString; safecall;
    function Get_NomPessoaContato: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NumCEP: WideString; safecall;
    function Get_NumCEPCorrespondencia: WideString; safecall;
    function Get_NumFax: WideString; safecall;
    function Get_NumImovelReceitaFederal: WideString; safecall;
    function Get_NumLatitude: Integer; safecall;
    function Get_NumLongitude: Integer; safecall;
    function Get_NumTelefone: WideString; safecall;
    function Get_QtdArea: Double; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_SglEstadoCorrespondencia: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_CodDistrito(Value: Integer); safecall;
    procedure Set_CodDistritoCorrespondencia(Value: Integer); safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_CodEstadoCorrespondencia(Value: Integer); safecall;
    procedure Set_CodEstadoSisbov(Value: Integer); safecall;
    procedure Set_CodEstadoSisbovCorrespondencia(Value: Integer); safecall;
    procedure Set_CodMicroRegiao(Value: Integer); safecall;
    procedure Set_CodMicroRegiaoSisbov(Value: Integer); safecall;
    procedure Set_CodMunicipio(Value: Integer); safecall;
    procedure Set_CodMunicipioCorrespondencia(Value: Integer); safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_CodPaisCorrespondencia(Value: Integer); safecall;
    procedure Set_CodPaisSisbov(Value: Integer); safecall;
    procedure Set_CodPaisSisbovCorrespondencia(Value: Integer); safecall;
    procedure Set_CodPropriedadeRural(Value: Integer); safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_DtaEfetivacaoCadastro(Value: TDateTime); safecall;
    procedure Set_IndEfetivadoUmaVez(const Value: WideString); safecall;
    procedure Set_DtaInicioCertificacao(Value: TDateTime); safecall;
    procedure Set_NomBairro(const Value: WideString); safecall;
    procedure Set_NomBairroCorrespondencia(const Value: WideString); safecall;
    procedure Set_NomDistrito(const Value: WideString); safecall;
    procedure Set_NomDistritoCorrespondencia(const Value: WideString);
      safecall;
    procedure Set_NomLogradouro(const Value: WideString); safecall;
    procedure Set_NomLogradouroCorrespondencia(const Value: WideString);
      safecall;
    procedure Set_NomMicroRegiao(const Value: WideString); safecall;
    procedure Set_NomMunicipio(const Value: WideString); safecall;
    procedure Set_NomMunicipioCorrespondencia(const Value: WideString);
      safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_NomPaisCorrespondencia(const Value: WideString); safecall;
    procedure Set_NomPessoaContato(const Value: WideString); safecall;
    procedure Set_NomPropriedadeRural(const Value: WideString); safecall;
    procedure Set_NumCEP(const Value: WideString); safecall;
    procedure Set_NumCEPCorrespondencia(const Value: WideString); safecall;
    procedure Set_NumFax(const Value: WideString); safecall;
    procedure Set_NumImovelReceitaFederal(const Value: WideString); safecall;
    procedure Set_NumLatitude(Value: Integer); safecall;
    procedure Set_NumLongitude(Value: Integer); safecall;
    procedure Set_NumTelefone(const Value: WideString); safecall;
    procedure Set_QtdArea(Value: Double); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_SglEstadoCorrespondencia(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_CodTipoInscricao: Integer; safecall;
    procedure Set_CodTipoInscricao(Value: Integer); safecall;
    function Get_OrientacaoLat: WideString; safecall;
    function Get_OrientacaoLon: WideString; safecall;
    procedure Set_OrientacaoLat(const Value: WideString); safecall;
    procedure Set_OrientacaoLon(const Value: WideString); safecall;
    function Get_CodNaturezaPessoaProp: WideString; safecall;
    function Get_CodPessoaProprietario: Integer; safecall;
    function Get_NomPessoaProprietario: WideString; safecall;
    function Get_NumCNPJCPFFormatadoProp: WideString; safecall;
    procedure Set_CodNaturezaPessoaProp(const Value: WideString); safecall;
    procedure Set_CodPessoaProprietario(Value: Integer); safecall;
    procedure Set_NomPessoaProprietario(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatadoProp(const Value: WideString); safecall;
    function Get_CodTipoPropriedadeRural: Integer; safecall;
    function Get_DesTipoPropriedadeRural: WideString; safecall;
    procedure Set_CodTipoPropriedadeRural(Value: Integer); safecall;
    procedure Set_DesTipoPropriedadeRural(const Value: WideString); safecall;
    function Get_CodIdPropriedadeSisbov: Integer; safecall;
    procedure Set_CodIdPropriedadeSisbov(Value: Integer); safecall;
    function Get_DtaFimConfinamento: TDateTime; safecall;
    function Get_DtaInicioConfinamento: TDateTime; safecall;
    procedure Set_DtaFimConfinamento(Value: TDateTime); safecall;
    procedure Set_DtaInicioConfinamento(Value: TDateTime); safecall;

    function Get_DtaInicioPeriodoAjusteRebanho: TDateTime; safecall;

    procedure Set_DtaInicioPeriodoAjusteRebanho(Value: TDateTime); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    //druzo 21-07-2009
    property DtaInicioConfinamento: TDateTime read Get_DtaInicioConfinamento write Set_DtaInicioConfinamento;
    property DtaFimConfinamento: TDateTime read Get_DtaFimConfinamento write Set_DtaFimConfinamento;

    //druzo 07-04-2010
    property DtaInicioPeriodoAjusteRebanho: TDateTime read Get_DtaInicioPeriodoAjusteRebanho write Set_DtaInicioPeriodoAjusteRebanho;

    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: WideString read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederal: WideString read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property NumLatitude: Integer read FNumLatitude write FNumLatitude;
    property NumLongitude: Integer read FNumLongitude write FNumLongitude;
    property QtdArea: Double read FQtdArea write FQtdArea;
    property NomLogradouro: WideString read FNomLogradouro write FNomLogradouro;
    property NomBairro: WideString read FNomBairro write FNomBairro;
    property NumCEP: WideString read FNumCEP write FNumCEP;
    property CodPais: Integer read FCodPais write FCodPais;
    property NomPais: WideString read FNomPais write FNomPais;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: WideString read FSglEstado write FSglEstado;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiao: Integer read FCodMicroRegiao write FCodMicroRegiao;
    property NomMicroRegiao: WideString read FNomMicroRegiao write FNomMicroRegiao;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property NomMunicipio: WideString read FNomMunicipio write FNomMunicipio;
    property CodDistrito: Integer read FCodDistrito write FCodDistrito;
    property NomDistrito: WideString read FNomDistrito write FNomDistrito;
    property NomPessoaContato: WideString read FNomPessoaContato write FNomPessoaContato;
    property NumTelefone: WideString read FNumTelefone write FNumTelefone;
    property NumFax: WideString read FNumFax write FNumFax;
    property NomLogradouroCorrespondencia: WideString read FNomLogradouroCorrespondencia write FNomLogradouroCorrespondencia;
    property NomBairroCorrespondencia: WideString read FNomBairroCorrespondencia write FNomBairroCorrespondencia;
    property NumCEPCorrespondencia: WideString read FNumCEPCorrespondencia write FNumCEPCorrespondencia;
    property CodPaisCorrespondencia: Integer read FCodPaisCorrespondencia write FCodPaisCorrespondencia;
    property NomPaisCorrespondencia: WideString read FNomPaisCorrespondencia write FNomPaisCorrespondencia;
    property CodPaisSisbovCorrespondencia: Integer read FCodPaisSisbovCorrespondencia write FCodPaisSisbovCorrespondencia;
    property CodEstadoCorrespondencia: Integer read FCodEstadoCorrespondencia write FCodEstadoCorrespondencia;
    property SglEstadoCorrespondencia: WideString read FSglEstadoCorrespondencia write FSglEstadoCorrespondencia;
    property CodEstadoSisbovCorrespondencia: Integer read FCodEstadoSisbovCorrespondencia write FCodEstadoSisbovCorrespondencia;
    property CodMunicipioCorrespondencia: Integer read FCodMunicipioCorrespondencia write FCodMunicipioCorrespondencia;
    property NomMunicipioCorrespondencia: WideString read FNomMunicipioCorrespondencia write FNomMunicipioCorrespondencia;
    property CodDistritoCorrespondencia: Integer read FCodDistritoCorrespondencia write FCodDistritoCorrespondencia;
    property NomDistritoCorrespondencia: WideString read FNomDistritoCorrespondencia write FNomDistritoCorrespondencia;
    property DtaInicioCertificacao: TDateTime read FDtaInicioCertificacao write FDtaInicioCertificacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property IndEfetivadoUmaVez: WideString read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodTipoInscricao: Integer read FCodTipoInscricao write FCodTipoInscricao;
    property OrientacaoLat: WideString read FOrientacaoLat write FOrientacaoLat;
    property OrientacaoLon: WideString read FOrientacaoLon write FOrientacaoLon;
    property CodPessoaProprietario: Integer read FCodPessoaProprietario write FCodPessoaProprietario;
    property NomPessoaProprietario: WideString read FNomPessoaProprietario write FNomPessoaProprietario;
    property CodNaturezaPessoaProp: WideString read FCodNaturezaPessoaProp write FCodNaturezaPessoaProp;
    property NumCNPJCPFFormatadoProp: WideString read FNumCNPJCPFFormatadoProp write FNumCNPJCPFFormatadoProp;
    property CodTipoPropriedadeRural: Integer read FCodTipoPropriedadeRural write FCodTipoPropriedadeRural;
    property DesTipoPropriedadeRural: WideString read FDesTipoPropriedadeRural write FDesTipoPropriedadeRural;
    property CodIdPropriedadeSisbov: Integer read FCodIdPropriedadeSisbov write FCodIdPropriedadeSisbov;
  end;

implementation

uses ComServ;

procedure TPropriedadeRural.AfterConstruction;
begin
  inherited;

end;

procedure TPropriedadeRural.BeforeDestruction;
begin
  inherited;
end;

function TPropriedadeRural.Get_CodDistrito: Integer;
begin
  Result := FCodDistrito;
end;

function TPropriedadeRural.Get_CodDistritoCorrespondencia: Integer;
begin
  Result := FCodDistritoCorrespondencia;
end;

function TPropriedadeRural.Get_CodEstado: Integer;
begin
  Result := FCodEstado;
end;

function TPropriedadeRural.Get_CodEstadoCorrespondencia: Integer;
begin
  Result := FCodEstadoCorrespondencia;
end;

function TPropriedadeRural.Get_CodEstadoSisbov: Integer;
begin
  Result := FCodEstadoSisbov;
end;

function TPropriedadeRural.Get_CodEstadoSisbovCorrespondencia: Integer;
begin
  Result := FCodEstadoSisbovCorrespondencia;
end;

function TPropriedadeRural.Get_CodMicroRegiao: Integer;
begin
  Result := FCodMicroRegiao;
end;

function TPropriedadeRural.Get_CodMicroRegiaoSisbov: Integer;
begin
  Result := FCodMicroRegiaoSisbov;
end;

function TPropriedadeRural.Get_CodMunicipio: Integer;
begin
  Result := FCodMunicipio;
end;

function TPropriedadeRural.Get_CodMunicipioCorrespondencia: Integer;
begin
  Result := FCodMunicipioCorrespondencia;
end;

function TPropriedadeRural.Get_CodPais: Integer;
begin
  Result := FCodPais;
end;

function TPropriedadeRural.Get_CodPaisCorrespondencia: Integer;
begin
  Result := FCodPaisCorrespondencia;
end;

function TPropriedadeRural.Get_CodPaisSisbov: Integer;
begin
  Result := FCodPaisSisbov;
end;

function TPropriedadeRural.Get_CodPaisSisbovCorrespondencia: Integer;
begin
  Result := FCodPaisSisbovCorrespondencia;
end;

function TPropriedadeRural.Get_CodPropriedadeRural: Integer;
begin
  Result := FCodPropriedadeRural;
end;

function TPropriedadeRural.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TPropriedadeRural.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  Result := FDtaEfetivacaoCadastro;
end;

function TPropriedadeRural.Get_IndEfetivadoUmaVez: WideString;
begin
  Result := FIndEfetivadoUmaVez;
end;

function TPropriedadeRural.Get_DtaInicioCertificacao: TDateTime;
begin
  Result := FDtaInicioCertificacao;
end;

function TPropriedadeRural.Get_NomBairro: WideString;
begin
  Result := FNomBairro;
end;

function TPropriedadeRural.Get_NomBairroCorrespondencia: WideString;
begin
  Result := FNomBairroCorrespondencia;
end;

function TPropriedadeRural.Get_NomDistrito: WideString;
begin
  Result := FNomDistrito;
end;

function TPropriedadeRural.Get_NomDistritoCorrespondencia: WideString;
begin
  Result := FNomDistritoCorrespondencia;
end;

function TPropriedadeRural.Get_NomLogradouro: WideString;
begin
  Result := FNomLogradouro;
end;

function TPropriedadeRural.Get_NomLogradouroCorrespondencia: WideString;
begin
  Result := FNomLogradouroCorrespondencia;
end;

function TPropriedadeRural.Get_NomMicroRegiao: WideString;
begin
  Result := FNomMicroRegiao;
end;

function TPropriedadeRural.Get_NomMunicipio: WideString;
begin
  Result := FNomMunicipio;
end;

function TPropriedadeRural.Get_NomMunicipioCorrespondencia: WideString;
begin
  Result := FNomMunicipioCorrespondencia;
end;

function TPropriedadeRural.Get_NomPais: WideString;
begin
  Result := FNomPais;
end;

function TPropriedadeRural.Get_NomPaisCorrespondencia: WideString;
begin
  Result := FNomPaisCorrespondencia;
end;

function TPropriedadeRural.Get_NomPessoaContato: WideString;
begin
  Result := FNomPessoaContato;
end;

function TPropriedadeRural.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TPropriedadeRural.Get_NumCEP: WideString;
begin
  Result := FNumCEP;
end;

function TPropriedadeRural.Get_NumCEPCorrespondencia: WideString;
begin
  Result := FNumCEPCorrespondencia;
end;

function TPropriedadeRural.Get_NumFax: WideString;
begin
  Result := FNumFax;
end;

function TPropriedadeRural.Get_NumImovelReceitaFederal: WideString;
begin
  Result := FNumImovelReceitaFederal;
end;

function TPropriedadeRural.Get_NumLatitude: Integer;
begin
  Result := FNumLatitude;
end;

function TPropriedadeRural.Get_NumLongitude: Integer;
begin
  Result := FNumLongitude;
end;

function TPropriedadeRural.Get_NumTelefone: WideString;
begin
  Result := FNumTelefone;
end;

function TPropriedadeRural.Get_QtdArea: Double;
begin
  Result := FQtdArea;
end;

function TPropriedadeRural.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

function TPropriedadeRural.Get_SglEstadoCorrespondencia: WideString;
begin
  Result := FSglEstadoCorrespondencia;
end;

function TPropriedadeRural.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

procedure TPropriedadeRural.Set_CodDistrito(Value: Integer);
begin
  FCodDistrito := Value;
end;

procedure TPropriedadeRural.Set_CodDistritoCorrespondencia(Value: Integer);
begin
  FCodDistritoCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodEstado(Value: Integer);
begin
  FCodEstado := Value;
end;

procedure TPropriedadeRural.Set_CodEstadoCorrespondencia(Value: Integer);
begin
  FCodEstadoCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodEstadoSisbov(Value: Integer);
begin
  FCodEstadoSisbov := Value;
end;

procedure TPropriedadeRural.Set_CodEstadoSisbovCorrespondencia(
  Value: Integer);
begin
  FCodEstadoSisbovCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodMicroRegiao(Value: Integer);
begin
  FCodMicroRegiao := Value;
end;

procedure TPropriedadeRural.Set_CodMicroRegiaoSisbov(Value: Integer);
begin
  FCodMicroRegiaoSisbov := Value;
end;

procedure TPropriedadeRural.Set_CodMunicipio(Value: Integer);
begin
  FCodMunicipio := Value;
end;

procedure TPropriedadeRural.Set_CodMunicipioCorrespondencia(
  Value: Integer);
begin
  FCodMunicipioCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodPais(Value: Integer);
begin
  FCodPais := Value;
end;

procedure TPropriedadeRural.Set_CodPaisCorrespondencia(Value: Integer);
begin
  FCodPaisCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodPaisSisbov(Value: Integer);
begin
  FCodPaisSisbov := Value;
end;

procedure TPropriedadeRural.Set_CodPaisSisbovCorrespondencia(
  Value: Integer);
begin
  FCodPaisSisbovCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_CodPropriedadeRural(Value: Integer);
begin
  FCodPropriedadeRural := Value;
end;

procedure TPropriedadeRural.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

procedure TPropriedadeRural.Set_DtaEfetivacaoCadastro(Value: TDateTime);
begin
  FDtaEfetivacaoCadastro := Value;
end;

procedure TPropriedadeRural.Set_IndEfetivadoUmaVez(
  const Value: WideString);
begin
  FIndEfetivadoUmaVez := Value;
end;

procedure TPropriedadeRural.Set_DtaInicioCertificacao(Value: TDateTime);
begin
  FDtaInicioCertificacao := Value;
end;

procedure TPropriedadeRural.Set_NomBairro(const Value: WideString);
begin
  FNomBairro := Value;
end;

procedure TPropriedadeRural.Set_NomBairroCorrespondencia(
  const Value: WideString);
begin
  FNomBairroCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NomDistrito(const Value: WideString);
begin
  FNomDistrito := Value;
end;

procedure TPropriedadeRural.Set_NomDistritoCorrespondencia(
  const Value: WideString);
begin
  FNomDistritoCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NomLogradouro(const Value: WideString);
begin
  FNomLogradouro := Value;
end;

procedure TPropriedadeRural.Set_NomLogradouroCorrespondencia(
  const Value: WideString);
begin
  FNomLogradouroCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NomMicroRegiao(const Value: WideString);
begin
  FNomMicroRegiao := Value;
end;

procedure TPropriedadeRural.Set_NomMunicipio(const Value: WideString);
begin
  FNomMunicipio := Value;
end;

procedure TPropriedadeRural.Set_NomMunicipioCorrespondencia(
  const Value: WideString);
begin
  FNomMunicipioCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NomPais(const Value: WideString);
begin
  FNomPais := Value;
end;

procedure TPropriedadeRural.Set_NomPaisCorrespondencia(
  const Value: WideString);
begin
  FNomPaisCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NomPessoaContato(const Value: WideString);
begin
  FNomPessoaContato := Value;
end;

procedure TPropriedadeRural.Set_NomPropriedadeRural(
  const Value: WideString);
begin
  FNomPropriedadeRural := Value;
end;

procedure TPropriedadeRural.Set_NumCEP(const Value: WideString);
begin
  FNumCEP := Value;
end;

procedure TPropriedadeRural.Set_NumCEPCorrespondencia(
  const Value: WideString);
begin
  FNumCEPCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_NumFax(const Value: WideString);
begin
  FNumFax := Value;
end;

procedure TPropriedadeRural.Set_NumImovelReceitaFederal(
  const Value: WideString);
begin
  FNumImovelReceitaFederal := Value;
end;

procedure TPropriedadeRural.Set_NumLatitude(Value: Integer);
begin
  FNumLatitude := Value;
end;

procedure TPropriedadeRural.Set_NumLongitude(Value: Integer);
begin
  FNumLongitude := Value;
end;

procedure TPropriedadeRural.Set_NumTelefone(const Value: WideString);
begin
  FNumTelefone := Value;
end;

procedure TPropriedadeRural.Set_QtdArea(Value: Double);
begin
  FQtdArea := Value;
end;

procedure TPropriedadeRural.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

procedure TPropriedadeRural.Set_SglEstadoCorrespondencia(
  const Value: WideString);
begin
  FSglEstadoCorrespondencia := Value;
end;

procedure TPropriedadeRural.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao := Value;
end;

function TPropriedadeRural.Get_CodTipoInscricao: Integer;
begin
  Result := FCodTipoInscricao;
end;

procedure TPropriedadeRural.Set_CodTipoInscricao(Value: Integer);
begin
  FCodTipoInscricao := Value;
end;

function TPropriedadeRural.Get_OrientacaoLat: WideString;
begin
  Result := FOrientacaoLat;
end;

procedure TPropriedadeRural.Set_OrientacaoLat(const Value: WideString);
begin
  FOrientacaoLat := Value;
end;

function TPropriedadeRural.Get_OrientacaoLon: WideString;
begin
  Result := FOrientacaoLon;
end;

procedure TPropriedadeRural.Set_OrientacaoLon(const Value: WideString);
begin
  FOrientacaoLon := Value;
end;

function TPropriedadeRural.Get_CodNaturezaPessoaProp: WideString;
begin
  Result := FCodNaturezaPessoaProp;
end;

function TPropriedadeRural.Get_CodPessoaProprietario: Integer;
begin
  Result := FCodPessoaProprietario;
end;

function TPropriedadeRural.Get_NomPessoaProprietario: WideString;
begin
  Result := FNomPessoaProprietario;
end;

function TPropriedadeRural.Get_NumCNPJCPFFormatadoProp: WideString;
begin
  Result := FNumCNPJCPFFormatadoProp;
end;

procedure TPropriedadeRural.Set_CodNaturezaPessoaProp(
  const Value: WideString);
begin
  FCodNaturezaPessoaProp := Value;
end;

procedure TPropriedadeRural.Set_CodPessoaProprietario(Value: Integer);
begin
  FCodPessoaProprietario := Value;
end;

procedure TPropriedadeRural.Set_NomPessoaProprietario(
  const Value: WideString);
begin
  FNomPessoaProprietario := Value;
end;

procedure TPropriedadeRural.Set_NumCNPJCPFFormatadoProp(
  const Value: WideString);
begin
  FNumCNPJCPFFormatadoProp := Value;
end;

function TPropriedadeRural.Get_CodTipoPropriedadeRural: Integer;
begin
  Result := FCodTipoPropriedadeRural;
end;

function TPropriedadeRural.Get_DesTipoPropriedadeRural: WideString;
begin
  Result := FDesTipoPropriedadeRural;
end;

procedure TPropriedadeRural.Set_CodTipoPropriedadeRural(Value: Integer);
begin
  FCodTipoPropriedadeRural := Value;
end;

procedure TPropriedadeRural.Set_DesTipoPropriedadeRural(
  const Value: WideString);
begin
  FDesTipoPropriedadeRural := Value;
end;

function TPropriedadeRural.Get_CodIdPropriedadeSisbov: Integer;
begin
  Result := CodIdPropriedadeSisbov;
end;

procedure TPropriedadeRural.Set_CodIdPropriedadeSisbov(Value: Integer);
begin
  CodIdPropriedadeSisbov := Value;
end;

function TPropriedadeRural.Get_DtaFimConfinamento: TDateTime;
begin
  result  :=  FData_Fim_Confinamento;
end;

function TPropriedadeRural.Get_DtaInicioConfinamento: TDateTime;
begin
  result  :=  FData_Inicio_Confinamento;
end;

procedure TPropriedadeRural.Set_DtaFimConfinamento(Value: TDateTime);
begin
  FData_Fim_Confinamento  :=  Value;
end;

procedure TPropriedadeRural.Set_DtaInicioConfinamento(Value: TDateTime);
begin
  FData_Inicio_Confinamento :=  value;
end;

function TPropriedadeRural.Get_DtaInicioPeriodoAjusteRebanho: TDateTime;
begin
  result  :=  FDtaInicioPeriodoAjusteRebanho;
end;

procedure TPropriedadeRural.Set_DtaInicioPeriodoAjusteRebanho(
  Value: TDateTime);
begin
  FDtaInicioPeriodoAjusteRebanho  :=  value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPropriedadeRural, Class_PropriedadeRural,
    ciMultiInstance, tmApartment);
end.
