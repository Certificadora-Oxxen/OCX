unit uIntTipoOrigemArqImport;

interface

type
  TIntTipoOrigemArqImport = class
  private //Declaração dos atribuitos com tipos de dados DELPHI.
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: String;
    FDesTipoOrigemArqImport: String;
  public //Declaracao das propriedades!
    property CodTipoOrigemArqImport: Integer  read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: String  read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: String  read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
  end;

implementation

end.
