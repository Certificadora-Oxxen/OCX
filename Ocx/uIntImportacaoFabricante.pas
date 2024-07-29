unit uIntImportacaoFabricante;

interface

type

  TIntImportacaoFabricante = class
  private //Declaração dos atribuitos com tipos de dados DELPHI.
    FCodArqImportFabricante: Integer;
    FCodFabricanteIdentificador: Integer;
    FCodSituacaoArqImport: String;
    FCodSituacaoTarefa: String;
    FCodTarefa: Integer;
    FCodTipoArqImportFabricante: Integer;
    FCodTipoOrigemArqImport: Integer;
    FCodUsuarioProc: Integer;
    FCodUsuarioUpload: Integer;
    FDesSituacaoArqImport: String;
    FDesSituacaoTarefa: String;
    FDesTipoArqImportFabricante: String;
    FDesTipoOrigemArqImport: String;
    FDtaFimRealTarefa: TDateTime;
    FDtaImportacao: TDateTime; 
    FDtaInicioPrevistoTarefa: TDateTime; 
    FDtaInicioRealTarefa: TDateTime; 
    FDtaProcessamento: TDateTime; 
    FNomArqImportFabricante: String; 
    FNomArqUpload: String; 
    FNomFabricanteIdentificador: String;
    FNomReduzidoFabricanteIdentificador: String; 
    FNomUsuarioProc: String;
    FNomUsuarioUpload: String;
    FQtdOcorrencias: Integer;
    FQtdRegistrosErrados: Integer;
    FQtdRegistrosProcessados: Integer;
    FQtdRegistrosTotal: Integer;
    FSglTipoArqImportFabricante: String;
    FSglTipoOrigemArqImport: String;
    FTxtMensagem: String;
  public //Declaracao das propriedades!
    property CodArqImportFabricante: Integer read FCodArqImportFabricante write FCodArqImportFabricante;
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodSituacaoArqImport: String read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property CodSituacaoTarefa: String read FCodSituacaoTarefa write FCodSituacaoTarefa;
    property CodTarefa: Integer read FCodTarefa write FCodTarefa;
    property CodTipoArqImportFabricante: Integer read FCodTipoArqImportFabricante write FCodTipoArqImportFabricante;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property CodUsuarioProc: Integer read FCodUsuarioProc write FCodUsuarioProc;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property DesSituacaoArqImport: String read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property DesSituacaoTarefa: String read FDesSituacaoTarefa write FDesSituacaoTarefa;
    property DesTipoArqImportFabricante: String read FDesTipoArqImportFabricante write FDesTipoArqImportFabricante;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property DtaFimRealTarefa: TDateTime read FDtaFimRealTarefa write FDtaFimRealTarefa;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property DtaInicioPrevistoTarefa: TDateTime read FDtaInicioPrevistoTarefa write FDtaInicioPrevistoTarefa;
    property DtaInicioRealTarefa: TDateTime read FDtaInicioRealTarefa write FDtaInicioRealTarefa;
    property DtaProcessamento: TDateTime read FDtaProcessamento write FDtaProcessamento;
    property NomArqImportFabricante: String read FNomArqImportFabricante write FNomArqImportFabricante;
    property NomArqUpload: String read FNomArqUpload write FNomArqUpload;
    property NomFabricanteIdentificador: String read FNomFabricanteIdentificador write FNomFabricanteIdentificador;
    property NomReduzidoFabricanteIdentificador: String read FNomReduzidoFabricanteIdentificador write FNomReduzidoFabricanteIdentificador;
    property NomUsuarioProc: String read FNomUsuarioProc write FNomUsuarioProc;
    property NomUsuarioUpload: String read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property QtdRegistrosErrados: Integer read FQtdRegistrosErrados write FQtdRegistrosErrados;
    property QtdRegistrosProcessados: Integer read FQtdRegistrosProcessados write FQtdRegistrosProcessados;
    property QtdRegistrosTotal: Integer read FQtdRegistrosTotal write FQtdRegistrosTotal;
    property SglTipoArqImportFabricante: String read FSglTipoArqImportFabricante write FSglTipoArqImportFabricante;
    property SglTipoOrigemArqImport: String read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property TxtMensagem: String read FTxtMensagem write FTxtMensagem;
  end;



implementation

end.
