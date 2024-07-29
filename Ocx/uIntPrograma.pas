unit uIntPrograma;

interface

type
  TIntPrograma = class
  private
    FCodGrupoPaginas: Integer;
    FSeqPosicaoBanner: Integer;
    FDtaInicioAnuncio: TDateTime;
    FDtaFimAnuncio: TDateTime;
    FCodBanner: Integer;
    FDesGrupoPaginas: String;
    FDesPosicaoBanner: String;
    FNomArquivo: String;
  public
    property CodGrupoPaginas: Integer    read FCodGrupoPaginas  write FCodGrupoPaginas;
    property SeqPosicaoBanner: Integer   read FSeqPosicaoBanner write FSeqPosicaoBanner;
    property DtaInicioAnuncio: TDateTime read FDtaInicioAnuncio write FDtaInicioAnuncio;
    property DtaFimAnuncio: TDateTime    read FDtaFimAnuncio    write FDtaFimAnuncio;
    property CodBanner: Integer          read FCodBanner        write FCodBanner;
    property DesGrupoPaginas: String  read FDesGrupoPaginas   write FDesGrupoPaginas;
    property DesPosicaoBanner: String read FDesPosicaoBanner  write FDesPosicaoBanner;
    property NomArquivo: String       read FNomArquivo        write FNomArquivo;
  end;

implementation

end.
