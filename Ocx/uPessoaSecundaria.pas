// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 41
// *  Descrição Resumida : Cadastro de Pessoas Secundárias
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *   Arley     06/08/2002    Adição no cadastro de alguns atributos
// *   Arley     06/09/2002    Adição das propriedades tipos de contato
// *
// ********************************************************************
unit uPessoaSecundaria;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPessoaSecundaria = class(TASPMTSObject, IPessoaSecundaria)
  private
    FCodPessoaProdutor           : Integer;
    FCodPessoaSecundaria         : Integer;
    FNomPessoaSecundaria         : WideString;
    FNomReduzidoPessoaSecundaria : WideString;
    FCodNaturezaPessoa           : WideString;
    FDtaCadastramento            : TDateTime;
    FNumCNPJCPF                  : WideString;
    FNumCNPJCPFFormatado         : WideString;
    FCodTipoContato1             : Integer;
    FDesTipoContato1             : WideString;
    FTxtContato1                 : WideString;
    FCodTipoContato2             : Integer;
    FDesTipoContato2             : WideString;
    FTxtContato2                 : WideString;
    FCodTipoContato3             : Integer;
    FDesTipoContato3             : WideString;
    FTxtContato3                 : WideString;
    FCodTipoEndereco             : Integer;
    FNomLogradouro               : WideString;
    FNomBairro                   : WideString;
    FNumCep                      : WideString;
    FNomPais                     : WideString;
    FSglEstado                   : WideString;
    FNomMunicipio                : WideString;
    FNumMunicipioIBGE            : WideString;
    FNomDistrito                 : WideString;
    FtxtObservacao               : WideString;
  protected
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodPessoaSecundaria: Integer; safecall;
    function Get_NomPessoaSecundaria: WideString; safecall;
    function Get_NomReduzidoPessoaSecundaria: WideString; safecall;
    function Get_CodNaturezaPessoa: WideString; safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodPessoaSecundaria(Value: Integer); safecall;
    procedure Set_NomPessoaSecundaria(const Value: WideString); safecall;
    procedure Set_NomReduzidoPessoaSecundaria(const Value: WideString);
      safecall;
    procedure Set_CodNaturezaPessoa(const Value: WideString); safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_NumCNPJCPF: WideString; safecall;
    function Get_NumCNPJCPFFormatado: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_NumCNPJCPF(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatado(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_CodTipoEndereco: Integer; safecall;
    function Get_CodTipoContato1: Integer; safecall;
    function Get_CodTipoContato2: Integer; safecall;
    function Get_CodTipoContato3: Integer; safecall;
    function Get_NomBairro: WideString; safecall;
    function Get_NomDistrito: WideString; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_NomLogradouro: WideString; safecall;
    function Get_NomMunicipio: WideString; safecall;
    function Get_NomPais: WideString; safecall;
    function Get_NumCep: WideString; safecall;
    function Get_TxtContato1: WideString; safecall;
    function Get_TxtContato2: WideString; safecall;
    function Get_TxtContato3: WideString; safecall;
    function Get_NumMunicipioIBGE: WideString; safecall;
    procedure Set_CodTipoEndereco(Value: Integer); safecall;
    procedure Set_CodTipoContato1(Value: Integer); safecall;
    procedure Set_CodTipoContato2(Value: Integer); safecall;
    procedure Set_CodTipoContato3(Value: Integer); safecall;
    procedure Set_NomBairro(const Value: WideString); safecall;
    procedure Set_NomDistrito(const Value: WideString); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_NomLogradouro(const Value: WideString); safecall;
    procedure Set_NomMunicipio(const Value: WideString); safecall;
    procedure Set_NomPais(const Value: WideString); safecall;
    procedure Set_NumCep(const Value: WideString); safecall;
    procedure Set_TxtContato1(const Value: WideString); safecall;
    procedure Set_TxtContato2(const Value: WideString); safecall;
    procedure Set_TxtContato3(const Value: WideString); safecall;
    procedure Set_NumMunicipioIBGE(const Value: WideString); safecall;
    function Get_DesTipoContato1: WideString; safecall;
    function Get_DesTipoContato2: WideString; safecall;
    function Get_DesTipoContato3: WideString; safecall;
    procedure Set_DesTipoContato1(const Value: WideString); safecall;
    procedure Set_DesTipoContato2(const Value: WideString); safecall;
    procedure Set_DesTipoContato3(const Value: WideString); safecall;
  public
    property CodPessoaProdutor           : Integer     read FCodPessoaProdutor           write FCodPessoaProdutor;
    property CodPessoaSecundaria         : Integer     read FCodPessoaSecundaria         write FCodPessoaSecundaria;
    property NomPessoaSecundaria         : WideString  read FNomPessoaSecundaria         write FNomPessoaSecundaria;
    property NomReduzidoPessoaSecundaria : WideString  read FNomReduzidoPessoaSecundaria write FNomReduzidoPessoaSecundaria;
    property CodNaturezaPessoa           : WideString  read FCodNaturezaPessoa           write FCodNaturezaPessoa;
    property DtaCadastramento            : TDateTime   read FDtaCadastramento            write FDtaCadastramento;
    property NumCNPJCPF                  : WideString  read FNumCNPJCPF                  write FNumCNPJCPF;
    property NumCNPJCPFFormatado         : WideString  read FNumCNPJCPFFormatado         write FNumCNPJCPFFormatado;
    property CodTipoContato1             : Integer     read FCodTipoContato1             write FCodTipoContato1;
    property DesTipoContato1             : WideString  read FDesTipoContato1             write FDesTipoContato1;
    property TxtContato1                 : WideString  read FTxtContato1                 write FTxtContato1;
    property CodTipoContato2             : Integer     read FCodTipoContato2             write FCodTipoContato2;
    property DesTipoContato2             : WideString  read FDesTipoContato2             write FDesTipoContato2;
    property TxtContato2                 : WideString  read FTxtContato2                 write FTxtContato2;
    property CodTipoContato3             : Integer     read FCodTipoContato3             write FCodTipoContato3;
    property DesTipoContato3             : WideString  read FDesTipoContato3             write FDesTipoContato3;
    property TxtContato3                 : WideString  read FTxtContato3                 write FTxtContato3;
    property CodTipoEndereco             : Integer     read FCodTipoEndereco             write FCodTipoEndereco;
    property NomLogradouro               : WideString  read FNomLogradouro               write FNomLogradouro;
    property NomBairro                   : WideString  read FNomBairro                   write FNomBairro;
    property NumCep                      : WideString  read FNumCep                      write FNumCep;
    property NomPais                     : WideString  read FNomPais                     write FNomPais;
    property SglEstado                   : WideString  read FSglEstado                   write FSglEstado;
    property NomMunicipio                : WideString  read FNomMunicipio                write FNomMunicipio;
    property NumMunicipioIBGE            : WideString  read FNumMunicipioIBGE            write FNumMunicipioIBGE;
    property NomDistrito                 : WideString  read FNomDistrito                 write FNomDistrito;
    property txtObservacao               : WideString  read FtxtObservacao               write FtxtObservacao;
  end;

implementation

uses ComServ;

function TPessoaSecundaria.Get_CodPessoaProdutor: Integer;
begin
  result := FCodPessoaProdutor;
end;

function TPessoaSecundaria.Get_CodPessoaSecundaria: Integer;
begin
 result := FCodPessoaSecundaria;
end;

function TPessoaSecundaria.Get_NomPessoaSecundaria: WideString;
begin
  result := FNomPessoaSecundaria;
end;

function TPessoaSecundaria.Get_NomReduzidoPessoaSecundaria: WideString;
begin
  result := FNomReduzidoPessoaSecundaria;
end;

function TPessoaSecundaria.Get_CodNaturezaPessoa: WideString;
begin
  result := FCodNaturezaPessoa;
end;

procedure TPessoaSecundaria.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := value;
end;

procedure TPessoaSecundaria.Set_CodPessoaSecundaria(Value: Integer);
begin
  FCodPessoaSecundaria := value;
end;

procedure TPessoaSecundaria.Set_NomPessoaSecundaria(
  const Value: WideString);
begin
  FNomPessoaSecundaria := value;
end;

procedure TPessoaSecundaria.Set_NomReduzidoPessoaSecundaria(
  const Value: WideString);
begin
  FNomReduzidoPessoaSecundaria := value;
end;

procedure TPessoaSecundaria.Set_CodNaturezaPessoa(const Value: WideString);
begin
  FCodNaturezaPessoa := value;
end;

function TPessoaSecundaria.Get_DtaCadastramento: TDateTime;
begin
  result := FDtaCadastramento;
end;

function TPessoaSecundaria.Get_NumCNPJCPF: WideString;
begin
  result := FNumCNPJCPF;
end;

function TPessoaSecundaria.Get_NumCNPJCPFFormatado: WideString;
begin
  result := FNumCNPJCPFFormatado;
end;

function TPessoaSecundaria.Get_TxtObservacao: WideString;
begin
  result := FtxtObservacao;
end;

procedure TPessoaSecundaria.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := value;
end;

procedure TPessoaSecundaria.Set_NumCNPJCPF(const Value: WideString);
begin
  FNumCNPJCPF := value;
end;

procedure TPessoaSecundaria.Set_NumCNPJCPFFormatado(
  const Value: WideString);
begin
  FNumCNPJCPFFormatado := value;
end;

procedure TPessoaSecundaria.Set_TxtObservacao(const Value: WideString);
begin
  FtxtObservacao := value;
end;

function TPessoaSecundaria.Get_CodTipoEndereco: Integer;
begin
  Result := FCodTipoEndereco;
end;

function TPessoaSecundaria.Get_CodTipoContato1: Integer;
begin
  Result := FCodTipoContato1;
end;

function TPessoaSecundaria.Get_CodTipoContato2: Integer;
begin
  Result := FCodTipoContato2;
end;

function TPessoaSecundaria.Get_CodTipoContato3: Integer;
begin
  Result := FCodTipoContato3;
end;

function TPessoaSecundaria.Get_NomBairro: WideString;
begin
  Result := FNomBairro;
end;

function TPessoaSecundaria.Get_NomDistrito: WideString;
begin
  Result := FNomDistrito;
end;

function TPessoaSecundaria.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

function TPessoaSecundaria.Get_NomLogradouro: WideString;
begin
  Result := FNomLogradouro;
end;

function TPessoaSecundaria.Get_NomMunicipio: WideString;
begin
  Result := FNomMunicipio;
end;

function TPessoaSecundaria.Get_NomPais: WideString;
begin
  Result := FNomPais;
end;

function TPessoaSecundaria.Get_NumCep: WideString;
begin
  Result := FNumCep;
end;

function TPessoaSecundaria.Get_TxtContato1: WideString;
begin
  Result := FTxtContato1;
end;

function TPessoaSecundaria.Get_TxtContato2: WideString;
begin
  Result := FTxtContato2;
end;

function TPessoaSecundaria.Get_TxtContato3: WideString;
begin
  Result := FTxtContato3;
end;

procedure TPessoaSecundaria.Set_CodTipoEndereco(Value: Integer);
begin
  FCodTipoEndereco := Value;
end;

procedure TPessoaSecundaria.Set_CodTipoContato1(Value: Integer);
begin
  FCodTipoContato1 := Value;
end;

procedure TPessoaSecundaria.Set_CodTipoContato2(Value: Integer);
begin
  FCodTipoContato2 := Value;
end;

procedure TPessoaSecundaria.Set_CodTipoContato3(Value: Integer);
begin
  FCodTipoContato3 := Value;
end;

procedure TPessoaSecundaria.Set_NomBairro(const Value: WideString);
begin
  FNomBairro := Value;
end;

procedure TPessoaSecundaria.Set_NomDistrito(const Value: WideString);
begin
  FNomDistrito := Value;
end;

procedure TPessoaSecundaria.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

procedure TPessoaSecundaria.Set_NomLogradouro(const Value: WideString);
begin
  FNomLogradouro := Value;
end;

procedure TPessoaSecundaria.Set_NomMunicipio(const Value: WideString);
begin
  FNomMunicipio := Value;
end;

procedure TPessoaSecundaria.Set_NomPais(const Value: WideString);
begin
  FNomPais := Value;
end;

procedure TPessoaSecundaria.Set_NumCep(const Value: WideString);
begin
  FNumCep  := Value;
end;

procedure TPessoaSecundaria.Set_TxtContato1(const Value: WideString);
begin
  FTxtContato1 := Value;
end;

procedure TPessoaSecundaria.Set_TxtContato2(const Value: WideString);
begin
  FTxtContato2 := Value;
end;

procedure TPessoaSecundaria.Set_TxtContato3(const Value: WideString);
begin
  FTxtContato3 := Value;
end;

function TPessoaSecundaria.Get_NumMunicipioIBGE: WideString;
begin
  Result := FNumMunicipioIBGE;
end;

procedure TPessoaSecundaria.Set_NumMunicipioIBGE(const Value: WideString);
begin
  FNumMunicipioIBGE := Value;
end;

function TPessoaSecundaria.Get_DesTipoContato1: WideString;
begin
  Result := FDesTipoContato1;
end;

function TPessoaSecundaria.Get_DesTipoContato2: WideString;
begin
   Result := FDesTipoContato2;
end;

function TPessoaSecundaria.Get_DesTipoContato3: WideString;
begin
  Result := FDesTipoContato3;
end;

procedure TPessoaSecundaria.Set_DesTipoContato1(const Value: WideString);
begin
  FDesTipoContato1 := Value;
end;

procedure TPessoaSecundaria.Set_DesTipoContato2(const Value: WideString);
begin
  FDesTipoContato2 := Value;
end;

procedure TPessoaSecundaria.Set_DesTipoContato3(const Value: WideString);
begin
  FDesTipoContato3 := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPessoaSecundaria, Class_PessoaSecundaria,
    ciMultiInstance, tmApartment);
end.
