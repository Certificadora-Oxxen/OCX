// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/06/2004
// *  Documentação       : Importação de dado geral - documentação das classes
// *  Código Classe      : 90
// *  Descrição Resumida : Atributos da classe ImportaçõesDadoGeral                 
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit uIntImportacaoDadoGeral;

interface                       

type
  TIntImportacaoDadoGeral = class
  private
    FCodArqImportDadoGeral: Integer;
    FNomArqUpLoad: String;
    FNomArqImportDadoGeral: String;
    FDtaImportacao: TDateTime;
    FCodUsuarioUltimoProc: Integer;
    FNomUsuarioUltimoProc: String;
    FCodUsuarioUpload: Integer;
    FNomUsuarioUpload: String;    
    FQtdVezesProcessamento: Integer;
    FDtaUltimoProcessamento: TDateTime;
    FQtdLinhas: Integer;
    FQtdProdutoresTotal: Integer;
    FQtdProdutoresErrados: Integer;
    FQtdProdutoresProcessados: Integer;
    FQtdPropriedadesTotal: Integer;
    FQtdPropriedadesErradas: Integer;
    FQtdPropriedadesProcessadas: Integer;
    FQtdFazendasTotal: Integer;
    FQtdFazendasErradas: Integer;
    FQtdFazendasProcessadas: Integer;
    FQtdLocaisTotal: Integer;
    FQtdLocaisErrados: Integer;
    FQtdLocaisProcessados: Integer;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: String;
    FDesTipoOrigemArqImport: String;
    FCodSituacaoArqImport: String;
    FDesSituacaoArqImport: String;
    FQtdOcorrencias: Integer;
    FCodUltimaTarefa: Integer;
    FCodSituacaoUltimaTarefa: String;
    FDesSituacaoUltimaTarefa: String;
    FDtaInicioPrevistoUltimaTarefa: TDateTime;
    FDtaInicioRealUltimaTarefa: TDateTime;
    FDtaFimRealUltimaTarefa: TDateTime;
    FTxtMensagem: String;
  public
    property CodArqImportDadoGeral: Integer read FCodArqImportDadoGeral write FCodArqImportDadoGeral;
    property NomArqUpLoad: String read FNomArqUpLoad write FNomArqUpLoad;
    property NomArqImportDadoGeral: String read FNomArqImportDadoGeral write FNomArqImportDadoGeral;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property CodUsuarioUltimoProc: Integer read FCodUsuarioUltimoProc write FCodUsuarioUltimoProc;
    property NomUsuarioUltimoProc: String read FNomUsuarioUltimoProc write FNomUsuarioUltimoProc;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property NomUsuarioUpload: String read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdProdutoresTotal: Integer read FQtdProdutoresTotal write FQtdProdutoresTotal;
    property QtdProdutoresErrados: Integer read FQtdProdutoresErrados write FQtdProdutoresErrados;
    property QtdProdutoresProcessados: Integer read FQtdProdutoresProcessados write FQtdProdutoresProcessados;
    property QtdPropriedadesTotal: Integer read FQtdPropriedadesTotal write FQtdPropriedadesTotal;
    property QtdPropriedadesErradas: Integer read FQtdPropriedadesErradas write FQtdPropriedadesErradas;
    property QtdPropriedadesProcessadas: Integer read FQtdPropriedadesProcessadas write FQtdPropriedadesProcessadas;
    property QtdFazendasTotal: Integer read FQtdFazendasTotal write FQtdFazendasTotal;
    property QtdFazendasErradas: Integer read FQtdFazendasErradas write FQtdFazendasErradas;
    property QtdFazendasProcessadas: Integer read FQtdFazendasProcessadas write FQtdFazendasProcessadas;
    property QtdLocaisTotal: Integer read FQtdLocaisTotal write FQtdLocaisTotal;
    property QtdLocaisErrados: Integer read FQtdLocaisErrados write FQtdLocaisErrados;
    property QtdLocaisProcessados: Integer read FQtdLocaisProcessados write FQtdLocaisProcessados;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: String read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property CodSituacaoArqImport: String read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property DesSituacaoArqImport: String read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property CodUltimaTarefa: Integer read FCodUltimaTarefa write FCodUltimaTarefa;
    property CodSituacaoUltimaTarefa: String read FCodSituacaoUltimaTarefa write FCodSituacaoUltimaTarefa;
    property DesSituacaoUltimaTarefa: String read FDesSituacaoUltimaTarefa write FDesSituacaoUltimaTarefa;
    property DtaInicioPrevistoUltimaTarefa: TDateTime read FDtaInicioPrevistoUltimaTarefa write FDtaInicioPrevistoUltimaTarefa;
    property DtaInicioRealUltimaTarefa: TDateTime read FDtaInicioRealUltimaTarefa write FDtaInicioRealUltimaTarefa;
    property DtaFimRealUltimaTarefa: TDateTime read FDtaFimRealUltimaTarefa write FDtaFimRealUltimaTarefa;
    property TxtMensagem: String read FTxtMensagem write FTxtMensagem;


end;

implementation

end.
