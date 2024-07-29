// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 21/08/2002
// *  Documenta��o       : Atributos de Animais - Especifica��o das Classe.doc
// *  C�digo Classe      : 38
// *  Descri��o Resumida : Cadastro de Graus de Sangue do Animal -
// *                       Classe Auxiliar
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    21/08/2002    Cria��o
// *
// *
// ********************************************************************
unit uGrauSangue;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TGrauSangue = class(TASPMTSObject, IGrauSangue)
 private
    FCodGrauSangue : Integer;
    FSglGrauSangue : WideString;
    FDesGrauSangue : WideString;
  protected
    function Get_CodGrauSangue: Integer; safecall;
    function Get_DesGrauSangue: WideString; safecall;
    function Get_SglGrauSangue: WideString; safecall;
    procedure Set_CodGrauSangue(Value: Integer); safecall;
    procedure Set_DesGrauSangue(const Value: WideString); safecall;
    procedure Set_SglGrauSangue(const Value: WideString); safecall;
  Public
    property CodGrauSangue   : Integer     read FCodGrauSangue   write FCodGrauSangue;
    property SglGrauSangue   : WideString  read FSglGrauSangue   write FSglGrauSangue;
    property DesGrauSangue   : WideString  read FDesGrauSangue   write FDesGrauSangue;
  end;

implementation

uses ComServ;

function TGrauSangue.Get_CodGrauSangue: Integer;
begin
  result := FCodGrauSangue;
end;

function TGrauSangue.Get_DesGrauSangue: WideString;
begin
  result := FDesGrauSangue;
end;

function TGrauSangue.Get_SglGrauSangue: WideString;
begin
  result := FSglGrauSangue;
end;

procedure TGrauSangue.Set_CodGrauSangue(Value: Integer);
begin
  FCodGrauSangue := Value;
end;

procedure TGrauSangue.Set_DesGrauSangue(const Value: WideString);
begin
  FDesGrauSangue := Value;
end;

procedure TGrauSangue.Set_SglGrauSangue(const Value: WideString);
begin
  FSglGrauSangue := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrauSangue, Class_GrauSangue,
    ciMultiInstance, tmApartment);
end.
