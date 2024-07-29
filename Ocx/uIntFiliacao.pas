unit uIntFiliacao;

interface

uses uIntAnimalResumido;

type
  TIntFiliacao = class
  private
    FCodPessoaProdutor: Integer;
    FCodAnimal: Integer;
    FAnimalPai: TIntAnimalResumido;
    FAnimalMae: TIntAnimalResumido;
    FAnimalReceptor: TIntAnimalResumido;
  public
    constructor Create;
    destructor Destroy; override;

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property AnimalPai: TIntAnimalResumido read FAnimalPai write FAnimalPai;
    property AnimalMae: TIntAnimalResumido read FAnimalMae write FAnimalMae;
    property AnimalReceptor: TIntAnimalResumido read FAnimalReceptor write FAnimalReceptor;
  end;


implementation

{ TIntFiliacao }

constructor TIntFiliacao.Create;
begin
  inherited;
  FAnimalPai := TIntAnimalResumido.Create;
  FAnimalMae := TIntAnimalResumido.Create;
  FAnimalReceptor := TIntAnimalResumido.Create;
end;

destructor TIntFiliacao.Destroy;
begin
  FAnimalPai.Free;
  FAnimalMae.Free;
  FAnimalReceptor.Free;
  inherited;
end;

end.
