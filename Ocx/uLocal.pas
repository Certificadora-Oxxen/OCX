// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Propriedades Rurais, Fazendas, etc - Definição das
// *                       classes.doc
// *  Código Classe      : 32
// *  Descrição Resumida : Cadastro de Locais
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    15/08/2002    Criação
// *   Hitalo   15/08/2002    Retirar os Campos NumIncra, NumPropriedadeRural
// *                          do metodo buscar e propriedade Buscar
// *
// ***************************************************************************
unit uLocal;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TLocal = class(TASPMTSObject, ILocal)
  private
    FCodPessoaProdutor: Integer;
    FCodFazenda: Integer;
    FCodLocal: Integer;
    FSglLocal: WideString;
    FDesLocal: WideString;
    FSglFazenda: WideString;
    FNomFazenda: WideString;
    FCodEstado: Integer;
    FSglEstado: WideString;
    FDtaCadastramento  : TDateTime;
    FIndPrincipal: String;
  protected
    function Get_CodPessoaProdutor: Integer; safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    function Get_CodFazenda: Integer; safecall;
    procedure Set_CodFazenda(Value: Integer); safecall;
    function Get_CodLocal: Integer; safecall;
    procedure Set_CodLocal(Value: Integer); safecall;
    function Get_SglLocal: WideString; safecall;
    procedure Set_SglLocal(const Value: WideString); safecall;
    function Get_DesLocal: WideString; safecall;
    procedure Set_DesLocal(const Value: WideString); safecall;
    function Get_SglFazenda: WideString; safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;
    function Get_NomFazenda: WideString; safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_SglEstado: WideString; safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    function Get_IndPrincipal: WideString; safecall;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property CodLocal: Integer read FCodLocal write FCodLocal;
    property SglLocal: WideString read FSglLocal write FSglLocal;
    property DesLocal: WideString read FDesLocal write FDesLocal;
    property SglFazenda: WideString read FSglFazenda write FSglFazenda;
    property NomFazenda: WideString read FNomFazenda write FNomFazenda;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: WideString read FSglEstado write FSglEstado;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndPrincipal: String read FIndPrincipal write FIndPrincipal;
  end;

implementation

uses ComServ;

function TLocal.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

procedure TLocal.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

function TLocal.Get_CodFazenda: Integer;
begin
  Result := FCodFazenda;
end;

procedure TLocal.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := Value;
end;

function TLocal.Get_CodLocal: Integer;
begin
  Result := FCodLocal;
end;

procedure TLocal.Set_CodLocal(Value: Integer);
begin
  FCodLocal := Value;
end;

function TLocal.Get_SglLocal: WideString;
begin
  Result := FSglLocal;
end;

procedure TLocal.Set_SglLocal(const Value: WideString);
begin
  FSglLocal := Value;
end;

function TLocal.Get_DesLocal: WideString;
begin
  Result := FDesLocal;
end;

procedure TLocal.Set_DesLocal(const Value: WideString);
begin
  FDesLocal := Value;
end;

function TLocal.Get_SglFazenda: WideString;
begin
  Result := FSglFazenda;
end;

procedure TLocal.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := Value;
end;

function TLocal.Get_NomFazenda: WideString;
begin
  Result := FNomFazenda;
end;

procedure TLocal.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := Value;
end;

function TLocal.Get_CodEstado: Integer;
begin
  Result := FCodEstado;
end;

function TLocal.Get_SglEstado: WideString;
begin
  Result := FSglEstado;
end;

procedure TLocal.Set_CodEstado(Value: Integer);
begin
  FCodEstado := Value;
end;

procedure TLocal.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

function TLocal.Get_DtaCadastramento: TDateTime;
begin
  result := FDtaCadastramento;
end;

procedure TLocal.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := value;
end;

function TLocal.Get_IndPrincipal: WideString;
begin
  Result := FIndPrincipal;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLocal, Class_Local,
    ciMultiInstance, tmApartment);
end.
