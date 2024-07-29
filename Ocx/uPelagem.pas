// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 29/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 27
// *  Descrição Resumida : Cadastro de pelagem
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    29/07/2002    Criação
// *
// ********************************************************************
unit uPelagem;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPelagem = class(TASPMTSObject, IPelagem)
  private
    FCodPelagem        : Integer;
    FSglPelagem        : WideString;
    FDesPelagem        : WideString;
    FIndRestritoSistema: WideString;
  protected
    function Get_CodPelagem: Integer; safecall;
    function Get_DesPelagem: WideString; safecall;
    function Get_SglPelagem: WideString; safecall;
    procedure Set_CodPelagem(Value: Integer); safecall;
    procedure Set_DesPelagem(const Value: WideString); safecall;
    procedure Set_SglPelagem(const Value: WideString); safecall;
    function Get_IndRestritoSistema: WideString; safecall;
  public
    property  CodPelagem        : Integer        Read FCodPelagem         write FCodPelagem;
    property  SglPelagem        : WideString     Read FSglPelagem         write FSglPelagem;
    property  DesPelagem        : WideString     Read FDesPelagem         write FDesPelagem;
    property  IndRestritoSistema: WideString     Read FIndRestritoSistema write FIndRestritoSistema;
  end;

implementation

uses ComServ;

function TPelagem.Get_CodPelagem: Integer;
begin
  result := FCodPelagem;
end;

function TPelagem.Get_DesPelagem: WideString;
begin
  result := FDesPelagem;
end;

function TPelagem.Get_SglPelagem: WideString;
begin
  result := FSglPelagem;
end;

procedure TPelagem.Set_CodPelagem(Value: Integer);
begin
  FCodPelagem := value;
end;

procedure TPelagem.Set_DesPelagem(const Value: WideString);
begin
  FDesPelagem := value;
end;

procedure TPelagem.Set_SglPelagem(const Value: WideString);
begin
  FSglPelagem := value;
end;

function TPelagem.Get_IndRestritoSistema: WideString;
begin
  Result := FIndRestritoSistema;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPelagem, Class_Pelagem,
    ciMultiInstance, tmApartment);
end.
