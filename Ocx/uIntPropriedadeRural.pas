unit uIntPropriedadeRural;

interface

uses uIntPessoa;

type
  TIntPropriedadeRural = class
  private
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: String;
    FNumImovelReceitaFederal: String;
    FNumLatitude: Integer;
    FNumLongitude: Integer;
    FQtdArea: Double;
    FNomLogradouro: String;
    FNomBairro: String;
    FNumCEP: String;
    FCodPais: Integer;
    FNomPais: String;
    FCodPaisSisbov: Integer;
    FCodEstado: Integer;
    FSglEstado: String;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiao: Integer;
    FNomMicroRegiao: String;
    FCodMicroRegiaoSisbov: Integer;
    FCodMunicipio: Integer;
    FNomMunicipio: String;
    FCodDistrito: Integer;
    FNomDistrito: String;
    FNomPessoaContato: String;
    FNumTelefone: String;
    FNumFax: String;
    FNomLogradouroCorrespondencia: String;
    FNomBairroCorrespondencia: String;
    FNumCEPCorrespondencia: String;
    FCodPaisCorrespondencia: Integer;
    FNomPaisCorrespondencia: String;
    FCodPaisSisbovCorrespondencia: Integer;
    FCodEstadoCorrespondencia: Integer;
    FSglEstadoCorrespondencia: String;
    FCodEstadoSisbovCorrespondencia: Integer;
    FCodMunicipioCorrespondencia: Integer;
    FNomMunicipioCorrespondencia: String;
    FCodDistritoCorrespondencia: Integer;
    FNomDistritoCorrespondencia: String;
    FDtaInicioCertificacao: TDateTime;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FTxtObservacao: String;
    FDtaGravacaoSisbov: TDateTime;
    FCodArquivoSisbov: Integer;
    FNomArquivoSisbov: String;
    FIndEfetivadoUmaVez: String;
    FCodTipoInscricao: Integer;
    FOrientacaoLat: String;
    FOrientacaoLon: String;
    FCodPessoaProprietario: Integer;
    FNomPessoaProprietario: String;
    FCodNaturezaPessoaProp: String;
    FNumCNPJCPFFormatadoProp: String;
    FDesTipoPropriedadeRural: String;
    FCodTipoPropriedadeRural: Integer;
    FCodIdPropriedadeSisbov: Integer;
    FDataInicioConfinamento:TDateTime;
    FDataFimConfinamento:TDateTime;
    FDtaInicioPeriodoAjusteRebanho:TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: String read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederal: String read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property NumLatitude: Integer read FNumLatitude write FNumLatitude;
    property NumLongitude: Integer read FNumLongitude write FNumLongitude;
    property QtdArea: Double read FQtdArea write FQtdArea;
    property NomLogradouro: String read FNomLogradouro write FNomLogradouro;
    property NomBairro: String read FNomBairro write FNomBairro;
    property NumCEP: String read FNumCEP write FNumCEP;
    property CodPais: Integer read FCodPais write FCodPais;
    property NomPais: String read FNomPais write FNomPais;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: String read FSglEstado write FSglEstado;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiao: Integer read FCodMicroRegiao write FCodMicroRegiao;
    property NomMicroRegiao: String read FNomMicroRegiao write FNomMicroRegiao;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property NomMunicipio: String read FNomMunicipio write FNomMunicipio;
    property CodDistrito: Integer read FCodDistrito write FCodDistrito;
    property NomDistrito: String read FNomDistrito write FNomDistrito;
    property NomPessoaContato: String read FNomPessoaContato write FNomPessoaContato;
    property NumTelefone: String read FNumTelefone write FNumTelefone;
    property NumFax: String read FNumFax write FNumFax;
    property NomLogradouroCorrespondencia: String read FNomLogradouroCorrespondencia write FNomLogradouroCorrespondencia;
    property NomBairroCorrespondencia: String read FNomBairroCorrespondencia write FNomBairroCorrespondencia;
    property NumCEPCorrespondencia: String read FNumCEPCorrespondencia write FNumCEPCorrespondencia;
    property CodPaisCorrespondencia: Integer read FCodPaisCorrespondencia write FCodPaisCorrespondencia;
    property NomPaisCorrespondencia: String read FNomPaisCorrespondencia write FNomPaisCorrespondencia;
    property CodPaisSisbovCorrespondencia: Integer read FCodPaisSisbovCorrespondencia write FCodPaisSisbovCorrespondencia;
    property CodEstadoCorrespondencia: Integer read FCodEstadoCorrespondencia write FCodEstadoCorrespondencia;
    property SglEstadoCorrespondencia: String read FSglEstadoCorrespondencia write FSglEstadoCorrespondencia;
    property CodEstadoSisbovCorrespondencia: Integer read FCodEstadoSisbovCorrespondencia write FCodEstadoSisbovCorrespondencia;
    property CodMunicipioCorrespondencia: Integer read FCodMunicipioCorrespondencia write FCodMunicipioCorrespondencia;
    property NomMunicipioCorrespondencia: String read FNomMunicipioCorrespondencia write FNomMunicipioCorrespondencia;
    property CodDistritoCorrespondencia: Integer read FCodDistritoCorrespondencia write FCodDistritoCorrespondencia;
    property NomDistritoCorrespondencia: String read FNomDistritoCorrespondencia write FNomDistritoCorrespondencia;
    property DtaInicioCertificacao: TDateTime read FDtaInicioCertificacao write FDtaInicioCertificacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property DtaGravacaoSisbov: TDateTime read FDtaGravacaoSisbov write FDtaGravacaoSisbov;
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property NomArquivoSisbov: String read FNomArquivoSisbov write FNomArquivoSisbov;
    property IndEfetivadoUmaVez: String read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodTipoInscricao: Integer read FCodTipoInscricao write FCodTipoInscricao;
    property OrientacaoLat: String read FOrientacaoLat write FOrientacaoLat;
    property OrientacaoLon: String read FOrientacaoLon write FOrientacaoLon;
    property CodTipoPropriedadeRural: Integer read FCodTipoPropriedadeRural write FCodTipoPropriedadeRural;
    property DesTipoPropriedadeRural: String read FDesTipoPropriedadeRural write FDesTipoPropriedadeRural;
    property CodPessoaProprietario: Integer read FCodPessoaProprietario write FCodPessoaProprietario;
    property NomPessoaProprietario: String read FNomPessoaProprietario write FNomPessoaProprietario;
    property CodNaturezaPessoaProp: String read FCodNaturezaPessoaProp write FCodNaturezaPessoaProp;
    property NumCNPJCPFFormatadoProp: String read FNumCNPJCPFFormatadoProp write FNumCNPJCPFFormatadoProp;
    property CodIdPropriedadeSisbov: Integer read FCodIdPropriedadeSisbov write FCodIdPropriedadeSisbov;
    property DtaInicioConfinamento:TDateTime read FDataInicioConfinamento write FDataInicioConfinamento;
    property DtaFimConfinamento:TDateTime read FDataFimConfinamento write FDataFimConfinamento;
    property DtaInicioPeriodoAjusteRebanho:TDateTime read FDtaInicioPeriodoAjusteRebanho write FDtaInicioPeriodoAjusteRebanho;


  end;

implementation

{ TIntPropriedadeRural }

constructor TIntPropriedadeRural.Create;
begin
  inherited;
end;

destructor TIntPropriedadeRural.Destroy;
begin
  inherited;
end;

end.
