// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Perfil do Usuário
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade
// *
// *
// *
// *
// ********************************************************************
unit uPerfil;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPerfil = class(TASPMTSObject, IPerfil)
  private
    FCodPerfil      : Integer;
    FNomPerfil      : WideString;
    FCodPapel       : Integer;
    FDesPapel       : WideString;
    FDesPerfil      : WideString;
    FDtaFimValidade : TDateTime;
  protected
    function Get_CodPapel: Integer; safecall;
    function Get_CodPerfil: Integer; safecall;
    function Get_DesPapel: WideString; safecall;
    function Get_DesPerfil: WideString; safecall;
    function Get_NomPerfil: WideString; safecall;
    function Get_DtaFimValidade: TDateTime; safecall;

    procedure Set_CodPerfil(Value            : Integer); safecall;
    procedure Set_CodPapel(Value             : Integer); safecall;
    procedure Set_DesPapel(const Value       : WideString); safecall;
    procedure Set_DesPerfil(const Value      : WideString); safecall;
    procedure Set_NomPerfil(const Value      : WideString); safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;

  public
    property CodPerfil      : Integer       read FCodPerfil      write FCodPerfil;
    property NomPerfil      : WideString    read FNomPerfil      write FNomPerfil;
    property CodPapel       : Integer       read FCodPapel       write FCodPapel;
    property DesPapel       : WideString    read FDesPapel       write FDesPapel;
    property DesPerfil      : WideString    read FDesPerfil      write FDesPerfil;
    property DtaFimValidade : TDateTime     read FDtaFimValidade write FDtaFimValidade;
  end;

implementation

uses ComServ;

function TPerfil.Get_CodPapel: Integer;
begin
  Result := FCodPapel;
end;

function TPerfil.Get_CodPerfil: Integer;
begin
  Result := FCodPerfil;
end;

function TPerfil.Get_DesPapel: WideString;
begin
  Result := FDesPapel;
end;

function TPerfil.Get_DesPerfil: WideString;
begin
  Result := FDesPerfil;
end;

function TPerfil.Get_NomPerfil: WideString;
begin
  Result := FNomPerfil;
end;

procedure TPerfil.Set_CodPerfil(Value: Integer);
begin
  FCodPerfil := Value;
end;

procedure TPerfil.Set_CodPapel(Value: Integer);
begin
  FCodPapel := Value;
end;

procedure TPerfil.Set_DesPapel(const Value: WideString);
begin
  FDesPapel := Value;
end;

procedure TPerfil.Set_DesPerfil(const Value: WideString);
begin
  FDesPerfil := Value;
end;

procedure TPerfil.Set_NomPerfil(const Value: WideString);
begin
  FNomPerfil := Value;
end;

function TPerfil.Get_DtaFimValidade: TDateTime;
begin
  Result := FDtaFimValidade;
end;

procedure TPerfil.Set_DtaFimValidade(Value: TDateTime);
begin
  FDtaFimValidade := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPerfil, Class_Perfil,
    ciMultiInstance, tmApartment);
end.
