unit uIntGrupoPaginas;

interface

type
  TIntGrupoPaginas = class
  private
    FCodigo          : Integer;
    FCodTipoPagina   : Integer;
    FDesGrupoPaginas : String;
    FDtaFimValidade  : TDateTime;
  public
    property Codigo          : Integer    read FCodigo           write FCodigo;
    property CodTipoPagina   : Integer    read FCodTipoPagina    write FCodTipoPagina;
    property DesGrupoPaginas : String     read FDesGrupoPaginas  write FDesGrupoPaginas;
    property DtaFimValidade  : TDateTime  read FDtaFimValidade   write FDtaFimValidade ;
  end;

implementation

end.

