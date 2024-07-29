unit uIntEndereco;

interface

type
  TIntEndereco = class(TObject)
  private
    FCodEndereco: Integer;
    FCodTipoEndereco: Integer;
    FSglTipoEndereco: String;
    FDesTipoEndereco: String;
    FNomPessoaContato: String;
    FNumTelefone: String;
    FNumFax: String;
    FTxtEmail: String;
    FNomLogradouro: String;
    FNomBairro: String;
    FNumCEP: String;
    FCodDistrito: Integer;
    FNomDistrito: String;
    FCodMunicipio: Integer;
    FNumMunicipioIBGE: String;
    FNomMunicipio: String;
    FCodEstado: Integer;
    FSglEstado: String;
    FNomEstado: String;
    FCodPais: Integer;
    FNomPais: String;
  public
    property CodEndereco: Integer read FCodEndereco write FCodEndereco;
    property CodTipoEndereco: Integer read FCodTipoEndereco write FCodTipoEndereco;
    property SglTipoEndereco: String read FSglTipoEndereco write FSglTipoEndereco;
    property DesTipoEndereco: String read FDesTipoEndereco write FDesTipoEndereco;
    property NomPessoaContato: String read FNomPessoaContato write FNomPessoaContato;
    property NumTelefone: String read FNumTelefone write FNumTelefone;
    property NumFax: String read FNumFax write FNumFax;
    property TxtEmail: String read FTxtEmail write FTxtEmail;
    property NomLogradouro: String read FNomLogradouro write FNomLogradouro;
    property NomBairro: String read FNomBairro write FNomBairro;
    property NumCEP: String read FNumCEP write FNumCEP;
    property CodDistrito: Integer read FCodDistrito write FCodDistrito;
    property NomDistrito: String read FNomDistrito write FNomDistrito;
    property CodMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property NumMunicipioIBGE: String read FNumMunicipioIBGE write FNumMunicipioIBGE;
    property NomMunicipio: String read FNomMunicipio write FNomMunicipio;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: String read FSglEstado write FSglEstado;
    property NomEstado: String read FNomEstado write FNomEstado;
    property CodPais: Integer read FCodPais write FCodPais;
    property NomPais: String read FNomPais write FNomPais;
  end;

implementation

end.
 