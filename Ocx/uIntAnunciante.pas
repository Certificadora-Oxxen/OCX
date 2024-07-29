unit uIntAnunciante;

interface

type
  TIntAnunciante = class
  private
    FCodigo              : Integer;
    FNomAnunciante       : String;
    FTxtEmailAnunciante  : String;
    FDtaFimValidade      : TDateTime;
  public
    property Codigo             : Integer   read FCodigo              write FCodigo;
    property NomAnunciante      : String    read FNomAnunciante       write FNomAnunciante;
    property TxtEmailAnunciante : String    read FTxtEmailAnunciante  write FTxtEmailAnunciante;
    property DtaFimValidade     : TDateTime read FDtaFimValidade      write FDtaFimValidade;
  end;

implementation

end.
