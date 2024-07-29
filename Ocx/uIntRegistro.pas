unit uIntRegistro;

interface

type
  TIntRegistro = class
  private
    FCodPessoaProdutor: Integer;
    FCodAnimal: Integer;
    FCodAssociacaoRaca: Integer;
    FSglAssociacaoRaca: String;
    FNomAssociacaoRaca: String;
    FCodGrauSangue: Integer;
    FSglGrauSangue: String;
    FDesGrauSangue: String;
    FNumRGD: String;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodAssociacaoRaca: Integer read FCodAssociacaoRaca write FCodAssociacaoRaca;
    property SglAssociacaoRaca: String read FSglAssociacaoRaca write FSglAssociacaoRaca;
    property NomAssociacaoRaca: String read FNomAssociacaoRaca write FNomAssociacaoRaca;
    property CodGrauSangue: Integer read FCodGrauSangue write FCodGrauSangue;
    property SglGrauSangue: String read FSglGrauSangue write FSglGrauSangue;
    property DesGrauSangue: String read FDesGrauSangue write FDesGrauSangue;
    property NumRGD: String read FNumRGD write FNumRGD;
  end;

implementation

end.
