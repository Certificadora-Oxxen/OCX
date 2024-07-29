unit uIntBanner;

interface

type
  TIntBanner = class
  private
    FCodigo: Integer;
    FNomArquivo: String;
    FCodTipoBanner: Integer;
    FURLDestino: String;
    FTxtAlternativo: String;
    FCodAnunciante: Integer;
    FCodTipoTarget : Integer;
    FDesTipoBanner : String;
    FNomAnunciante : String;
    FDesTipoTarget : String;
    FDtaFimValidade : TDateTime;
    FTxtComandoTarget : String;
  public
    property Codigo: Integer                read FCodigo                write FCodigo;
    property NomArquivo: String             read FNomArquivo            write FNomArquivo;
    property CodTipoBanner: Integer         read FCodTipoBanner         write FCodTipoBanner;
    property URLDestino: String             read FURLDestino            write FURLDestino;
    property TxtAlternativo: String         read FTxtAlternativo        write FTxtAlternativo;
    property CodAnunciante: Integer         read FCodAnunciante         write FCodAnunciante;
    property CodTipoTarget: Integer         read FCodTipoTarget         write FCodTipoTarget;
    property DesTipoBanner: String          read FDesTipoBanner         write FDesTipoBanner;
    property NomAnunciante: String          read FNomAnunciante         write FNomAnunciante;
    property DesTipoTarget: String          read FDesTipoTarget         write FDesTipoTarget;
    property DtaFimValidade : TDateTime     read FDtaFimValidade        write FDtaFimValidade;
    property TxtComandoTarget: String       read FTxtComandoTarget      write FTxtComandoTarget;
  end;

implementation

end.
