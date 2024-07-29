// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 19/08/2002
// *  Documenta��o       : Atributos de animais - defini��o das classes.doc
// *  C�digo Classe      : 37
// *  Descri��o Resumida : Cadastro de Associa��o Ra�a
// ************************************************************************
// *  �ltimas    Altera��es
// *   Hitalo    23/07/2002  Cria��o
// *   Hitalo    19/08/2002  Adicionar m�todos Inserir, Excluir, Buscar ,Alterar,
// *                         AdicionarGrauSangue,RetirrarGrauSangue,PesquisarRelacionamentos
// *
// *************************************************************************
unit uAssociacaoRaca;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAssociacaoRaca = class(TASPMTSObject, IAssociacaoRaca)
  private
    FCodAssociacaoRaca : Integer;
    FSglAssociacaoRaca : WideString;
    FNomAssociacaoRaca : WideString;
  protected
    function Get_CodAssociacaoRaca: Integer; safecall;
    function Get_NomAssociacaoRaca: WideString; safecall;
    function Get_SglAssociacaoRaca: WideString; safecall;
    procedure Set_CodAssociacaoRaca(Value: Integer); safecall;
    procedure Set_NomAssociacaoRaca(const Value: WideString); safecall;
    procedure Set_SglAssociacaoRaca(const Value: WideString); safecall;
  public
    property CodAssociacaoRaca   : Integer     read FCodAssociacaoRaca   write FCodAssociacaoRaca;
    property SglAssociacaoRaca   : WideString  read FSglAssociacaoRaca   write FSglAssociacaoRaca;
    property NomAssociacaoRaca   : WideString  read FNomAssociacaoRaca   write FNomAssociacaoRaca;
  end;

implementation

uses ComServ;

function TAssociacaoRaca.Get_CodAssociacaoRaca: Integer;
begin
  result := FCodAssociacaoRaca;
end;

function TAssociacaoRaca.Get_NomAssociacaoRaca: WideString;
begin
  result := FNomAssociacaoRaca;
end;

function TAssociacaoRaca.Get_SglAssociacaoRaca: WideString;
begin
  result := FSglAssociacaoRaca;
end;

procedure TAssociacaoRaca.Set_CodAssociacaoRaca(Value: Integer);
begin
  FCodAssociacaoRaca := value;
end;

procedure TAssociacaoRaca.Set_NomAssociacaoRaca(const Value: WideString);
begin
  FNomAssociacaoRaca := value;
end;

procedure TAssociacaoRaca.Set_SglAssociacaoRaca(const Value: WideString);
begin
  FSglAssociacaoRaca := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAssociacaoRaca, Class_AssociacaoRaca,
    ciMultiInstance, tmApartment);
end.
