unit uEndereco;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl;

type
  TEndereco = class(TAutoObject, IEndereco)
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
  protected
    function Get_CodDistrito: Integer; safecall;
    function Get_CodEndereco: Integer; safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_CodMunicipio: Integer; safecall;
    function Get_CodPais: Integer; safecall;
    function Get_CodTipoEndereco: Integer; safecall;
    function Get_DesTipoEndereco: WideString; safecall;
    function Get_NomBairro: WideString; safecall;
    function Get_NomDistrito: WideString; safecall;
    function Get_NomEstado: WideString; safecall;
    function Get_NomLogradouro: WideString; safecall;
    function Get_NomMunicipio: WideString; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_NomPessoaContato: WideString; safecall;
    function Get_NumCEP: WideString; safecall;
    function Get_NumFax: WideString; safecall;
    function Get_NumMunicipioIBGE: WideString; safecall;
    function Get_NumTelefone: WideString; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_SglTipoEndereco: WideString; safecall;
    function Get_TxtEMail: WideString; safecall;
    procedure Set_CodDistrito(Value: Integer); safecall;
    procedure Set_CodEndereco(Value: Integer); safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_CodMunicipio(Value: Integer); safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_CodTipoEndereco(Value: Integer); safecall;
    procedure Set_DesTipoEndereco(const Value: WideString); safecall;
    procedure Set_NomBairro(const Value: WideString); safecall;
    procedure Set_NomDistrito(const Value: WideString); safecall;
    procedure Set_NomEstado(const Value: WideString); safecall;
    procedure Set_NomLogradouro(const Value: WideString); safecall;
    procedure Set_NomMunicipio(const Value: WideString); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_NomPessoaContato(const Value: WideString); safecall;
    procedure Set_NumCEP(const Value: WideString); safecall;
    procedure Set_NumFax(const Value: WideString); safecall;
    procedure Set_NumMunicipioIBGE(const Value: WideString); safecall;
    procedure Set_NumTelefone(const Value: WideString); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_SglTipoEndereco(const Value: WideString); safecall;
    procedure Set_TxtEMail(const Value: WideString); safecall;
  public
    property CodEndereco: Integer read Get_CodEndereco write Set_CodEndereco;
    property CodTipoEndereco: Integer read Get_CodTipoEndereco write Set_CodTipoEndereco;
    property SglTipoEndereco: WideString read Get_SglTipoEndereco write Set_SglTipoEndereco;
    property DesTipoEndereco: WideString read Get_DesTipoEndereco write Set_DesTipoEndereco;
    property NomPessoaContato: WideString read Get_NomPessoaContato write Set_NomPessoaContato;
    property NumTelefone: WideString read Get_NumTelefone write Set_NumTelefone;
    property NumFax: WideString read Get_NumFax write Set_NumFax;
    property TxtEmail: WideString read Get_TxtEmail write Set_TxtEmail;
    property NomLogradouro: WideString read Get_NomLogradouro write Set_NomLogradouro;
    property NomBairro: WideString read Get_NomBairro write Set_NomBairro;
    property NumCEP: WideString read Get_NumCEP write Set_NumCEP;
    property CodDistrito: Integer read Get_CodDistrito write Set_CodDistrito;
    property NomDistrito: WideString read Get_NomDistrito write Set_NomDistrito;
    property CodMunicipio: Integer read Get_CodMunicipio write Set_CodMunicipio;
    property NumMunicipioIBGE: WideString read Get_NumMunicipioIBGE write Set_NumMunicipioIBGE;
    property NomMunicipio: WideString read Get_NomMunicipio write Set_NomMunicipio;
    property CodEstado: Integer read Get_CodEstado write Set_CodEstado;
    property SglEstado: WideString read Get_SglEstado write Set_SglEstado;
    property NomEstado: WideString read Get_NomEstado write Set_NomEstado;
    property CodPais: Integer read Get_CodPais write Set_CodPais;
    property NomPais: WideString read Get_NomPais write Set_NomPais;
  end;

implementation

uses ComServ;

function TEndereco.Get_CodDistrito: Integer;
begin
  Result := FCodDistrito;
end;

function TEndereco.Get_CodEndereco: Integer;
begin
  Result := FCodEndereco;
end;

function TEndereco.Get_CodEstado: Integer;
begin
  Result := FCodEstado;
end;

function TEndereco.Get_CodMunicipio: Integer;
begin
  Result := FCodMunicipio;
end;

function TEndereco.Get_CodPais: Integer;
begin
  Result := FCodPais;
end;

function TEndereco.Get_CodTipoEndereco: Integer;
begin
  Result := FCodTipoEndereco;
end;

function TEndereco.Get_DesTipoEndereco: WideString;
begin
  Result := FDesTipoEndereco;
end;

function TEndereco.Get_NomBairro: WideString;
begin
  Result := FNomBairro;
end;

function TEndereco.Get_NomDistrito: WideString;
begin
  Result := FNomDistrito;
end;

function TEndereco.Get_NomEstado: WideString;
begin
  Result := FNomEstado;
end;

function TEndereco.Get_NomLogradouro: WideString;
begin
  Result := FNomLogradouro;
end;

function TEndereco.Get_NomMunicipio: WideString;
begin
  Result := FNomMunicipio;
end;

function TEndereco.Get_NomPais: WideString;
begin
  Result := FNomPais;
end;

function TEndereco.Get_NomPessoaContato: WideString;
begin
  Result := FNomPessoaContato;
end;

function TEndereco.Get_NumCEP: WideString;
begin
  Result := FNumCEP;
end;

function TEndereco.Get_NumFax: WideString;
begin
  Result := FNumFax;
end;

function TEndereco.Get_NumMunicipioIBGE: WideString;
begin
  Result := FNumMunicipioIBGE;
end;

function TEndereco.Get_NumTelefone: WideString;
begin
  Result := FNumTelefone;
end;

function TEndereco.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

function TEndereco.Get_SglTipoEndereco: WideString;
begin
  Result := FSglTipoEndereco;
end;

function TEndereco.Get_TxtEMail: WideString;
begin
  Result := FTxtEmail;
end;

procedure TEndereco.Set_CodDistrito(Value: Integer);
begin
  FCodDistrito := Value;
end;

procedure TEndereco.Set_CodEndereco(Value: Integer);
begin
  FCodEndereco := Value;
end;

procedure TEndereco.Set_CodEstado(Value: Integer);
begin
  FCodEstado := Value;
end;

procedure TEndereco.Set_CodMunicipio(Value: Integer);
begin
  FCodMunicipio := Value;
end;

procedure TEndereco.Set_CodPais(Value: Integer);
begin
  FCodPais := Value;
end;

procedure TEndereco.Set_CodTipoEndereco(Value: Integer);
begin
  FCodTipoEndereco := Value;
end;

procedure TEndereco.Set_DesTipoEndereco(const Value: WideString);
begin
  FDesTipoEndereco := Value;
end;

procedure TEndereco.Set_NomBairro(const Value: WideString);
begin
  FNomBairro := Value;
end;

procedure TEndereco.Set_NomDistrito(const Value: WideString);
begin
  FNomDistrito := Value;
end;

procedure TEndereco.Set_NomEstado(const Value: WideString);
begin
  FNomEstado := Value;
end;

procedure TEndereco.Set_NomLogradouro(const Value: WideString);
begin
  FNomLogradouro := Value;
end;

procedure TEndereco.Set_NomMunicipio(const Value: WideString);
begin
  FNomMunicipio := Value;
end;

procedure TEndereco.Set_NomPais(const Value: WideString);
begin
  FNomPais := Value;

end;

procedure TEndereco.Set_NomPessoaContato(const Value: WideString);
begin
  FNomPessoaContato := Value;
end;

procedure TEndereco.Set_NumCEP(const Value: WideString);
begin
  FNumCEP := Value;
end;

procedure TEndereco.Set_NumFax(const Value: WideString);
begin
  FNumFax := Value;
end;

procedure TEndereco.Set_NumMunicipioIBGE(const Value: WideString);
begin
  FNumMunicipioIBGE := Value;
end;

procedure TEndereco.Set_NumTelefone(const Value: WideString);
begin
  FNumTelefone := Value;
end;

procedure TEndereco.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

procedure TEndereco.Set_SglTipoEndereco(const Value: WideString);
begin
  FSglTipoEndereco := Value;
end;

procedure TEndereco.Set_TxtEMail(const Value: WideString);
begin
  FTxtEmail := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEndereco, Class_Endereco,
    ciMultiInstance, tmApartment);
end.
