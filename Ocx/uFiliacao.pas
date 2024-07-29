unit uFiliacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uAnimalResumido;

type
  TFiliacao = class(TASPMTSObject, IFiliacao)
  private
    FCodPessoaProdutor: Integer;
    FCodAnimal: Integer;
    FAnimalPai: TAnimalResumido;
    FAnimalMae: TAnimalResumido;
    FAnimalReceptor: TAnimalResumido;
  protected
    function Get_AnimalMae: IAnimalResumido; safecall;
    function Get_AnimalPai: IAnimalResumido; safecall;
    function Get_AnimalReceptor: IAnimalResumido; safecall;
    function Get_CodAnimal: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    procedure Set_AnimalMae(const Value: IAnimalResumido); safecall;
    procedure Set_AnimalPai(const Value: IAnimalResumido); safecall;
    procedure Set_AnimalReceptor(const Value: IAnimalResumido); safecall;
    procedure Set_CodAnimal(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property AnimalPai: TAnimalResumido read FAnimalPai write FAnimalPai;
    property AnimalMae: TAnimalResumido read FAnimalMae write FAnimalMae;
    property AnimalReceptor: TAnimalResumido read FAnimalReceptor write FAnimalReceptor;
  end;

implementation

uses ComServ;

procedure TFiliacao.AfterConstruction;
begin
  inherited;

  FAnimalPai := TAnimalResumido.Create;
  FAnimalPai.ObjAddRef;
  FAnimalMae := TAnimalResumido.Create;
  FAnimalMae.ObjAddRef;
  FAnimalReceptor := TAnimalResumido.Create;
  FAnimalReceptor.ObjAddRef;
end;

procedure TFiliacao.BeforeDestruction;
begin
  If FAnimalPai <> nil Then Begin
    FAnimalPai.ObjRelease;
    FAnimalPai := nil;
  End;
  If FAnimalMae <> nil Then Begin
    FAnimalMae.ObjRelease;
    FAnimalMae := nil;
  End;
  If FAnimalReceptor <> nil Then Begin
    FAnimalReceptor.ObjRelease;
    FAnimalReceptor := nil;
  End;

  inherited;
end;

function TFiliacao.Get_AnimalMae: IAnimalResumido;
begin
  Result := FAnimalMae;
end;

function TFiliacao.Get_AnimalPai: IAnimalResumido;
begin
  Result := FAnimalPai;
end;

function TFiliacao.Get_AnimalReceptor: IAnimalResumido;
begin
  Result := FAnimalReceptor;
end;

function TFiliacao.Get_CodAnimal: Integer;
begin
  Result := FCodAnimal;
end;

function TFiliacao.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

procedure TFiliacao.Set_AnimalMae(const Value: IAnimalResumido);
begin
  FAnimalMae := TAnimalResumido(Value);
end;

procedure TFiliacao.Set_AnimalPai(const Value: IAnimalResumido);
begin
  FAnimalPai := TAnimalResumido(Value);
end;

procedure TFiliacao.Set_AnimalReceptor(const Value: IAnimalResumido);
begin
  FAnimalReceptor := TAnimalResumido(Value);
end;

procedure TFiliacao.Set_CodAnimal(Value: Integer);
begin
  FCodAnimal := Value;
end;

procedure TFiliacao.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFiliacao, Class_Filiacao,
    ciMultiInstance, tmApartment);
end.
