unit uIntRelatorio;

interface

type
  TIntRelatorio = class
  private
    FCodRelatorio: Integer;
    FTxtTitulo: String;
    FQtdColunas: Integer;
    FCodOrientacao: Integer;
    FCodTamanhoFonte: Integer;
    FIndPersonalizavel: String;
    FTxtSubTitulo: String;
  public
    property CodRelatorio: Integer read FCodRelatorio write FCodRelatorio;
    property TxtTitulo: String read FTxtTitulo write FTxtTitulo;
    property QtdColunas: Integer read FQtdColunas write FQtdColunas;
    property CodOrientacao: Integer read FCodOrientacao write FCodOrientacao;
    property CodTamanhoFonte: Integer read FCodTamanhoFonte write FCodTamanhoFonte;
    property IndPersonalizavel: String read FIndPersonalizavel write FIndPersonalizavel;
    property TxtSubTitulo: String read FTxtSubTitulo write FTxtSubTitulo;
  end;

implementation

end.
