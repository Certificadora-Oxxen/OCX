unit uRegistro;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TRegistro = class(TASPMTSObject, IRegistro)
  private
    FCodPessoaProdutor: Integer;
    FCodAnimal: Integer;
    FCodAssociacaoRaca: Integer;
    FSglAssociacaoRaca: WideString;
    FNomAssociacaoRaca: WideString;
    FCodGrauSangue: Integer;
    FSglGrauSangue: WideString;
    FDesGrauSangue: WideString;
    FNumRGD: WideString;
  protected
    function Get_CodAnimal: Integer; safecall;
    function Get_CodAssociacaoRaca: Integer; safecall;
    function Get_CodGrauSangue: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_DesGrauSangue: WideString; safecall;
    function Get_NomAssociacaoRaca: WideString; safecall;
    function Get_NumRGD: WideString; safecall;
    function Get_SglAssociacaoRaca: WideString; safecall;
    function Get_SglGrauSangue: WideString; safecall;
    procedure Set_CodAnimal(Value: Integer); safecall;
    procedure Set_CodAssociacaoRaca(Value: Integer); safecall;
    procedure Set_CodGrauSangue(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_DesGrauSangue(const Value: WideString); safecall;
    procedure Set_NomAssociacaoRaca(const Value: WideString); safecall;
    procedure Set_NumRGD(const Value: WideString); safecall;
    procedure Set_SglAssociacaoRaca(const Value: WideString); safecall;
    procedure Set_SglGrauSangue(const Value: WideString); safecall;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodAssociacaoRaca: Integer read FCodAssociacaoRaca write FCodAssociacaoRaca;
    property SglAssociacaoRaca: WideString read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property NomAssociacaoRaca: WideString read FNomAssociacaoRaca write FNomAssociacaoRaca;
    property CodGrauSangue: Integer read FCodGrauSangue write FCodGrauSangue;
    property SglGrauSangue: WideString read FSglGrauSangue write FSglGrauSangue;
    property DesGrauSangue: WideString read FDesGrauSangue write FDesGrauSangue;
    property NumRGD: WideString read FNumRGD write FNumRGD;
  end;

implementation

uses ComServ;

function TRegistro.Get_CodAnimal: Integer;
begin
  Result := FCodAnimal;
end;

function TRegistro.Get_CodAssociacaoRaca: Integer;
begin
  Result := FCodAssociacaoRaca;
end;

function TRegistro.Get_CodGrauSangue: Integer;
begin
  Result := FCodGrauSangue;
end;

function TRegistro.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TRegistro.Get_DesGrauSangue: WideString;
begin
  Result := FDesGrauSangue;
end;

function TRegistro.Get_NomAssociacaoRaca: WideString;
begin
  Result := FNomAssociacaoRaca;
end;

function TRegistro.Get_NumRGD: WideString;
begin
  Result := FNumRGD;
end;

function TRegistro.Get_SglAssociacaoRaca: WideString;
begin
  Result := FSglAssociacaoRaca;
end;

function TRegistro.Get_SglGrauSangue: WideString;
begin
  Result := FSglGrauSangue;
end;

procedure TRegistro.Set_CodAnimal(Value: Integer);
begin
  FCodAnimal := Value;
end;

procedure TRegistro.Set_CodAssociacaoRaca(Value: Integer);
begin
  FCodAssociacaoRaca := Value;
end;

procedure TRegistro.Set_CodGrauSangue(Value: Integer);
begin
  FCodGrauSangue := Value;
end;

procedure TRegistro.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TRegistro.Set_DesGrauSangue(const Value: WideString);
begin
  FDesGrauSangue := Value;
end;

procedure TRegistro.Set_NomAssociacaoRaca(const Value: WideString);
begin
  FNomAssociacaoRaca := Value;
end;

procedure TRegistro.Set_NumRGD(const Value: WideString);
begin
  FNumRGD := Value;
end;

procedure TRegistro.Set_SglAssociacaoRaca(const Value: WideString);
begin
  FSglAssociacaoRaca := Value;
end;

procedure TRegistro.Set_SglGrauSangue(const Value: WideString);
begin
  FSglGrauSangue := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRegistro, Class_Registro,
    ciMultiInstance, tmApartment);
end.
