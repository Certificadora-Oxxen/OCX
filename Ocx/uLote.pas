// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 33
// *  Descrição Resumida : Cadastro de Lote
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    25/07/2002    Criação
// *
// ********************************************************************
unit uLote;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TLote = class(TASPMTSObject, ILote)
  Private
    FCodPessoaProdutor       : Integer;
    FCodFazenda              : Integer;
    FCodLote                 : Integer;
    FSglLote                 : WideString;
    FDesLote                 : WideString;
    FSglFazenda              : WideString;
    FNomFazenda              : WideString;
    FDtaCadastramento        : TDateTime;
  protected
    function Get_CodFazenda: Integer; safecall;
    function Get_CodLote: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_DesLote: WideString; safecall;
    function Get_NomFazenda: WideString; safecall;
    function Get_SglFazenda: WideString; safecall;
    function Get_SglLote: WideString; safecall;
    procedure Set_CodFazenda(Value: Integer); safecall;
    procedure Set_CodLote(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_DesLote(const Value: WideString); safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;
    procedure Set_SglLote(const Value: WideString); safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
  public
    property CodPessoaProdutor   : Integer     read FCodPessoaProdutor   write FCodPessoaProdutor;
    property CodFazenda          : Integer     read FCodFazenda          write FCodFazenda;
    property CodLote             : Integer     read FCodLote             write FCodLote;
    property SglLote             : WideString  read FSglLote             write FSglLote;
    property DesLote             : WideString  read FDesLote             write FDesLote;
    property SglFazenda          : WideString  read FSglFazenda          write FSglFazenda;
    property NomFazenda          : WideString  read FNomFazenda          write FNomFazenda;
    property DtaCadastramento    : TDateTime   read FDtaCadastramento    write FDtaCadastramento;
  end;

implementation

uses ComServ;

function TLote.Get_CodFazenda: Integer;
begin
 result := FCodFazenda;
end;

function TLote.Get_CodLote: Integer;
begin
 result := FCodLote;
end;

function TLote.Get_CodPessoaProdutor: Integer;
begin
 result := FCodPessoaProdutor;
end;

function TLote.Get_DesLote: WideString;
begin
 result := FDesLote;
end;

function TLote.Get_NomFazenda: WideString;
begin
  result := FNomFazenda;
end;

function TLote.Get_SglFazenda: WideString;
begin
  result := FSglFazenda;
end;

function TLote.Get_SglLote: WideString;
begin
  result := FSglLote;
end;

procedure TLote.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := value;
end;

procedure TLote.Set_CodLote(Value: Integer);
begin
  FCodLote := Value;
end;

procedure TLote.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := value;
end;

procedure TLote.Set_DesLote(const Value: WideString);
begin
  FDesLote := value;
end;

procedure TLote.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := value;
end;

procedure TLote.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := value;
end;

procedure TLote.Set_SglLote(const Value: WideString);
begin
  FSglLote := value;
end;

function TLote.Get_DtaCadastramento: TDateTime;
begin
  result := FDtaCadastramento;
end;

procedure TLote.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLote, Class_Lote,
    ciMultiInstance, tmApartment);
end.
