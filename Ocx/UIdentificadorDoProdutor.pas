// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 28/08/2002
// *  Documentação       : Atributos de Animais.doc
// *  Código Classe      : 36
// *  Descrição Resumida : Cadastro de Tipos de Identificador
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit UIdentificadorDoProdutor;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TIdentificadorDoProdutor = class(TASPMTSObject, IIdentificadorDoProdutor)
  private
    FCodTipoIdentificador       : Integer;
    FSglTipoIdentificador       : WideString;
    FDesTipoIdentificador       : WideString;
    FCodPosicaoIdentificador    : Integer;
    FSglPosicaoIdentificador    : WideString;
    FDesPosicaoIdentificador    : WideString;
    FCodGrupoIdentificador      : WideString;
  protected
    function Get_CodGrupoIdentificador: WideString; safecall;
    function Get_CodPosicaoIdentificador: Integer; safecall;
    function Get_CodTipoIdentificador: Integer; safecall;
    function Get_DesPosicaoIdentificador: WideString; safecall;
    function Get_DesTipoIdentificador: WideString; safecall;
    function Get_SglPosicaoIdentificador: WideString; safecall;
    function Get_SglTipoIdentificador: WideString; safecall;
    procedure Set_CodGrupoIdentificador(const Value: WideString); safecall;
    procedure Set_CodPosicaoIdentificador(Value: Integer); safecall;
    procedure Set_CodTipoIdentificador(Value: Integer); safecall;
    procedure Set_DesPosicaoIdentificador(const Value: WideString); safecall;
    procedure Set_DesTipoIdentificador(const Value: WideString); safecall;
    procedure Set_SglPosicaoIdentificador(const Value: WideString); safecall;
    procedure Set_SglTipoIdentificador(const Value: WideString); safecall;
  public
    property  CodTipoIdentificador     : Integer        Read FCodTipoIdentificador      write FCodTipoIdentificador;
    property  SglTipoIdentificador     : WideString     Read FSglTipoIdentificador      write FSglTipoIdentificador;
    property  DesTipoIdentificador     : WideString     Read FDesTipoIdentificador      write FDesTipoIdentificador;
    property  CodPosicaoIdentificador  : Integer        Read FCodPosicaoIdentificador   write FCodPosicaoIdentificador;
    property  SglPosicaoIdentificador  : WideString     Read FSglPosicaoIdentificador   write FSglPosicaoIdentificador;
    property  DesPosicaoIdentificador  : WideString     Read FDesPosicaoIdentificador   write FDesPosicaoIdentificador;
    property  CodGrupoIdentificador    : WideString     Read FCodGrupoIdentificador     write FCodGrupoIdentificador;
  end;

implementation

uses ComServ;

function TIdentificadorDoProdutor.Get_CodGrupoIdentificador: WideString;
begin
   result := FCodGrupoIdentificador;
end;

function TIdentificadorDoProdutor.Get_CodPosicaoIdentificador: Integer;
begin
   result := FCodPosicaoIdentificador;
end;

function TIdentificadorDoProdutor.Get_CodTipoIdentificador: Integer;
begin
   result := FCodTipoIdentificador;
end;

function TIdentificadorDoProdutor.Get_DesPosicaoIdentificador: WideString;
begin
   result := FDesPosicaoIdentificador;
end;

function TIdentificadorDoProdutor.Get_DesTipoIdentificador: WideString;
begin
   result := FDesTipoIdentificador;
end;

function TIdentificadorDoProdutor.Get_SglPosicaoIdentificador: WideString;
begin
   result := FSglPosicaoIdentificador;
end;

function TIdentificadorDoProdutor.Get_SglTipoIdentificador: WideString;
begin
   result := FSglTipoIdentificador;
end;

procedure TIdentificadorDoProdutor.Set_CodGrupoIdentificador(
  const Value: WideString);
begin
   FCodGrupoIdentificador:=value;
end;

procedure TIdentificadorDoProdutor.Set_CodPosicaoIdentificador(
  Value: Integer);
begin
   FCodPosicaoIdentificador:=value;
end;

procedure TIdentificadorDoProdutor.Set_CodTipoIdentificador(
  Value: Integer);
begin
   FCodTipoIdentificador := value;
end;

procedure TIdentificadorDoProdutor.Set_DesPosicaoIdentificador(
  const Value: WideString);
begin
   FDesPosicaoIdentificador := value;
end;

procedure TIdentificadorDoProdutor.Set_DesTipoIdentificador(
  const Value: WideString);
begin
   FDesTipoIdentificador := value;
end;

procedure TIdentificadorDoProdutor.Set_SglPosicaoIdentificador(
  const Value: WideString);
begin
   FSglPosicaoIdentificador := value;
end;

procedure TIdentificadorDoProdutor.Set_SglTipoIdentificador(
  const Value: WideString);
begin
   FSglTipoIdentificador := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TIdentificadorDoProdutor, Class_IdentificadorDoProdutor,
    ciMultiInstance, tmApartment);
end.
