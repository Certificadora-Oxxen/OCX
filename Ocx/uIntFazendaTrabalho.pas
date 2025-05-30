unit uIntFazendaTrabalho;

interface

type
  TIntFazendaTrabalho = class
  private
    FCodFazenda : Integer;
    FSglFazenda : String;
    FNomFazenda : String;
    FDataUltimaVistoria : String;
    FStatusVistoria : String;
  public
    property CodFazenda: Integer        read FCodFazenda         write FCodFazenda;
    property SglFazenda: String         read FSglFazenda         write FSglFazenda;
    property NomFazenda: String         read FNomFazenda         write FNomFazenda;
    property DataUltimaVistoria: String read FDataUltimaVistoria write FDataUltimaVistoria;
    property StatusVistoria: String     read FStatusVistoria     write FStatusVistoria;

  end;

implementation

end.
