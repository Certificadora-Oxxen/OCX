unit uIntImportacaoSISBOV;

interface

type

  TIntImportacaoSISBOV = class
  private //Declaração dos atribuitos com tipos de dados DELPHI.
     FNIRF: String;
     FNumCpfCnpj: String;
     FCodProdutor: Integer;
     FCodPropriedade: Integer;
     FCodSisBov: String;
     FCodArqImportSisBov: Integer;
     FNomArqImportSisBov: String;
     FNomArqUpload: String;
     FCodUsuarioUpLoad: Integer;
     FNomUsuarioUpLoad: String;
     FDtaArqImportSisBov: TDateTime;
     FQtdVezesProcessamento: Integer;
     FDtaUltimoProcessamento: TDateTime;
     FQtdLinhas: Integer;
     FQtdLinhasErroUltimoProc: Integer;
     FQtdLinhasLogUltimoProc: Integer;
     FCodTipoArqImportSisBov: Integer;
     FTxtDados: String;
     FQtdLinhasProcessadas: Integer;
     FCodTipoOrigemArqImport: Integer;
     FCodSituacaoArqImport: String;
     FtxtMensagem: String;
     FDesTipoOrigemArqImport: String;
     FDesSituacaoArqImport: String;
  public //Declaracao das propriedades!
    property NIRF: String  read FNIRF write FNIRF;
    property NumCpfCnpj: String  read FNumCpfCnpj write FNumCpfCnpj;
    property CodProdutor: Integer  read FCodProdutor write FCodProdutor;
    property CodPropriedade: Integer  read FCodPropriedade write FCodPropriedade;
    property CodSisBov: String  read FCodSisBov write FCodSisBov;
    property CodArqImportSisBov: Integer read FCodArqImportSisBov write FCodArqImportSisBov;
    property NomArqImportSisBov: String read FNomArqImportSisBov write FNomArqImportSisBov;
    property NomArqUpload: String read FNomArqUpload write FNomArqUpload;
    property NomUsuarioUpLoad: String read FNomUsuarioUpLoad write FNomUsuarioUpLoad;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property DtaArqImportSisBov: TDateTime read FDtaArqImportSisBov write FDtaArqImportSisBov;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdLinhasErroUltimoProc: Integer read FQtdLinhasErroUltimoProc write FQtdLinhasErroUltimoProc;
    property QtdLinhasLogUltimoProc: Integer read FQtdLinhasLogUltimoProc write FQtdLinhasLogUltimoProc;
    property CodTipoArqImportSisBov: Integer read FCodTipoArqImportSisBov write FCodTipoArqImportSisBov;
    property TxtDados: String read FTxtDados write FTxtDados;
    property QtdLinhasProcessadas: Integer read FQtdLinhasProcessadas write FQtdLinhasProcessadas;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property CodSituacaoArqImport: String read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property txtMensagem: String read FtxtMensagem write FtxtMensagem;
    property CodUsuarioUpLoad: Integer  read FCodUsuarioUpLoad write FCodUsuarioUpLoad;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property DesSituacaoArqImport: String read FDesSituacaoArqImport write FDesSituacaoArqImport;
  end;



implementation

end.
