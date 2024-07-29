unit uIntArquivoSisbov;

interface

type
  TIntArquivoSisbov = class
  private
    FCodArquivoSisbov: Integer;
    FNomArquivoSisbov: String;
    FDtaCriacaoArquivo: TDateTime;
    FQtdBytesArquivo: Integer;
    FCodTipoArquivoSisbov: Integer;
    FDesTipoArquivoSisbov: String;
    FCodUsuario: Integer;
    FNomUsuario: String;
    FIndPossuiLogErro: Integer;
    FDtaInsercaoSisbov: TDateTime;
  public
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property NomArquivoSisbov: String read FNomArquivoSisbov write FNomArquivoSisbov;
    property DtaCriacaoArquivo: TDateTime read FDtaCriacaoArquivo write FDtaCriacaoArquivo;
    property QtdBytesArquivo: Integer read FQtdBytesArquivo write FQtdBytesArquivo;
    property CodTipoArquivoSisbov: Integer read FCodTipoArquivoSisbov write FCodTipoArquivoSisbov;
    property DesTipoArquivoSisbov: String read FDesTipoArquivoSisbov write FDesTipoArquivoSisbov;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property NomUsuario: String read FNomUsuario write FNomUsuario;
    property IndPossuiLogErro: Integer read FIndPossuiLogErro write FIndPossuiLogErro;
    property DtaInsercaoSisbov: TDateTime read FDtaInsercaoSisbov write FDtaInsercaoSisbov;
  end;

  implementation

end.
