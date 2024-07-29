// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Localidades
// ********************************************************************
// *  Últimas Alterações
// *   Jerry    06/08/2002    Criação
// *
// *
// ********************************************************************
unit uLocalidade;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TLocalidade = class(TASPMTSObject, ILocalidade)
  private
    FCodLocalidade        : Integer;
    FNomLocalidade        : WideString;
    FCodEstado            : Integer;
    FSglEstado            : WideString;
    FCodEstadoSisBov      : Integer;
    FNumLatitude          : Integer;
    FNumLongitude         : Integer;
    FCodMunicipio         : Integer;
    FNomMunicipio         : WideString;
    FDesTipoLocalidade    : WideString;
    FCodPais              : Integer;
    FNomPais              : WideString;
    FCodPaisSisBov        : Integer;
    FCodMicroRegiao       : Integer;
    FNomMicroRegiao       : WideString;
    FCodMicroRegiaoSisBov : Integer;
    FNumMunicipioIBGE     : WideString;
    FDtaEfetivacaoCadastro : TDateTime;
  protected
    function Get_CodEstado: Integer; safecall;
    function Get_CodLocalidade: Integer; safecall;
    function Get_CodMunicipio: Integer; safecall;
    function Get_DesTipoLocalidade: WideString; safecall;
    function Get_NomLocalidade: WideString; safecall;
    function Get_NomMunicipio: WideString; safecall;
    function Get_NumLatitude: Integer; safecall;
    function Get_NumLongitude: Integer; safecall;
    function Get_SglEstado: WideString; safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_CodLocalidade(Value: Integer); safecall;
    procedure Set_CodMunicipio(Value: Integer); safecall;
    procedure Set_DesTipoLocalidade(const Value: WideString); safecall;
    procedure Set_NomLocalidade(const Value: WideString); safecall;
    procedure Set_NomMunicipio(const Value: WideString); safecall;
    procedure Set_NumLatitude(Value: Integer); safecall;
    procedure Set_NumLongitude(Value: Integer); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    function Get_CodPais: Integer; safecall;
    function Get_NomPais: WideString; safecall;
    procedure Set_CodPais(Value: Integer); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    function Get_CodEstadoSisBov: Integer; safecall;
    function Get_CodMicroRegiao: Integer; safecall;
    function Get_NomMicroRegiao: WideString; safecall;
    procedure Set_CodEstadoSisBov(Value: Integer); safecall;
    procedure Set_CodMicroRegiao(Value: Integer); safecall;
    procedure Set_NomMicroRegiao(const Value: WideString); safecall;
    function Get_CodMicroRegiaoSisBov: Integer; safecall;
    procedure Set_CodMicroRegiaoSisBov(Value: Integer); safecall;
    function Get_CodPaisSisBov: Integer; safecall;
    procedure Set_CodPaisSisBov(Value: Integer); safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_NumMunicipioIBGE: WideString; safecall;
    procedure Set_DtaEfetivacaoCadastro(Value: TDateTime); safecall;
    procedure Set_NumMunicipioIBGE(const Value: WideString); safecall;
  public
    property CodLocalidade       : Integer      read FCodLocalidade         write FCodLocalidade;
    property NomLocalidade       : WideString   read FNomLocalidade         write FNomLocalidade;
    property NumLatitude         : Integer      read FNumLatitude           write FNumLatitude;
    property NumLongitude        : Integer      read FNumLongitude          write FNumLongitude;
    property DesTipoLocalidade   : WideString   read FDesTipoLocalidade     write FDesTipoLocalidade;
    property CodPais             : Integer      read FCodPais               write FCodPais;
    property NomPais             : WideString   read FNomPais               write FNomPais;
    property CodPaisSisBov       : Integer      read FCodPaisSisBov         write FCodPaisSisBov;
    property CodEstado           : Integer      read FCodEstado             write FCodEstado;
    property SglEstado           : WideString   read FSglEstado             write FSglEstado;
    property CodEstadoSisBov     : Integer      read FCodEstadoSisBov       write FCodEstadoSisBov;
    property CodMicroRegiao      : Integer      read FCodMicroRegiao        write FCodMicroRegiao;
    property NomMicroRegiao      : WideString   read FNomMicroRegiao        write FNomMicroRegiao;
    property CodMicroRegiaoSisBov: Integer      read FCodMicroRegiaoSisBov  write FCodMicroRegiaoSisBov;
    property CodMunicipio        : Integer      read FCodMunicipio          write FCodMunicipio;
    property NomMunicipio        : WideString   read FNomMunicipio          write FNomMunicipio;
    property NumMunicipioIBGE    : WideString   read FNumMunicipioIBGE      write FNumMunicipioIBGE;
    property DtaEfetivacaoCadastro : TDateTime   read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
  end;

implementation

uses ComServ;

function TLocalidade.Get_CodEstado: Integer;
begin
  Result := FCodEstado;
end;

function TLocalidade.Get_CodLocalidade: Integer;
begin
  Result := FCodLocalidade;
end;

function TLocalidade.Get_CodMunicipio: Integer;
begin
  Result := FCodMunicipio;
end;

function TLocalidade.Get_DesTipoLocalidade: WideString;
begin
  Result := FDesTipoLocalidade;
end;

function TLocalidade.Get_NomLocalidade: WideString;
begin
  Result := FNomLocalidade;
end;

function TLocalidade.Get_NomMunicipio: WideString;
begin
  Result := FNomMunicipio;
end;

function TLocalidade.Get_NumLatitude: Integer;
begin
  Result := FNumLatitude;
end;

function TLocalidade.Get_NumLongitude: Integer;
begin
  Result := FNumLongitude;
end;

function TLocalidade.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

procedure TLocalidade.Set_CodEstado(Value: Integer);
begin
  FCodEstado := Value;
end;

procedure TLocalidade.Set_CodLocalidade(Value: Integer);
begin
  FCodLocalidade := Value;
end;

procedure TLocalidade.Set_CodMunicipio(Value: Integer);
begin
  FCodMunicipio := Value;
end;

procedure TLocalidade.Set_DesTipoLocalidade(const Value: WideString);
begin
  FDesTipoLocalidade := Value;
end;

procedure TLocalidade.Set_NomLocalidade(const Value: WideString);
begin
  FNomLocalidade := Value;
end;

procedure TLocalidade.Set_NomMunicipio(const Value: WideString);
begin
  FNomMunicipio := Value;
end;

procedure TLocalidade.Set_NumLatitude(Value: Integer);
begin
  FNumLatitude := Value;
end;

procedure TLocalidade.Set_NumLongitude(Value: Integer);
begin
  FNumLongitude := Value;
end;

procedure TLocalidade.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

function TLocalidade.Get_CodPais: Integer;
begin
  Result := FCodPais;
end;

function TLocalidade.Get_NomPais: WideString;
begin
  Result := FNomPais;
end;

procedure TLocalidade.Set_CodPais(Value: Integer);
begin
  FCodPais := Value;
end;

procedure TLocalidade.Set_NomPais(const Value: WideString);
begin
  FNomPais := Value;
end;

function TLocalidade.Get_CodEstadoSisBov: Integer;
begin
  result := FCodEstadoSisBov;
end;

function TLocalidade.Get_CodMicroRegiao: Integer;
begin
  result := FCodMicroRegiao;
end;

function TLocalidade.Get_NomMicroRegiao: WideString;
begin
  result := FNomMicroRegiao;
end;

procedure TLocalidade.Set_CodEstadoSisBov(Value: Integer);
begin
  FCodEstadoSisBov := value;
end;

procedure TLocalidade.Set_CodMicroRegiao(Value: Integer);
begin
  FCodMicroRegiao := value;
end;

procedure TLocalidade.Set_NomMicroRegiao(const Value: WideString);
begin
  FNomMicroRegiao := value;
end;

function TLocalidade.Get_CodMicroRegiaoSisBov: Integer;
begin
  result := FCodMicroRegiaoSisBov;
end;

procedure TLocalidade.Set_CodMicroRegiaoSisBov(Value: Integer);
begin
  FCodMicroRegiaoSisBov := value;
end;

function TLocalidade.Get_CodPaisSisBov: Integer;
begin
  result := FCodPaisSisBov;
end;

procedure TLocalidade.Set_CodPaisSisBov(Value: Integer);
begin
  FCodPaisSisBov := Value;
end;

function TLocalidade.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  result := FDtaEfetivacaoCadastro;
end;

function TLocalidade.Get_NumMunicipioIBGE: WideString;
begin
  result := FNumMunicipioIBGE;
end;

procedure TLocalidade.Set_DtaEfetivacaoCadastro(Value: TDateTime);
begin
  FDtaEfetivacaoCadastro := value;
end;

procedure TLocalidade.Set_NumMunicipioIBGE(const Value: WideString);
begin
  FNumMunicipioIBGE := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLocalidade, Class_Localidade,
    ciMultiInstance, tmApartment);
end.
