unit uIntImportacao;

interface

type
  TIntImportacao = class
 private
    FCodPessoaProdutor: Integer;
    FDtaUltimoProcessamento: TDateTime;
    FCodArquivoImportacao: Integer;
    FNomArquivoImportacao: String;
    FDtaImportacao: TDateTime;
    FNomPessoaProdutor: String;
    FNumCNPJCPFFormatadoProdutor: String;
    FQtdAnimaisAlteracaoProcessados: Integer;
    FQtdAnimaisAlteracaoTotal: Integer;
    FQtdAnimaisEventosProcessados: Integer;
    FQtdAnimaisEventosTotal: Integer;
    FQtdAnimaisInsercaoProcessados: Integer;
    FQtdAnimaisInsercaoTotal: Integer;
    FQtdEventosProcessados: Integer;
    FQtdEventosTotal: Integer;
    FQtdRMProcessados: Integer;
    FQtdRMTotal: Integer;
    FQtdTourosRMProcessados: Integer;
    FQtdTourosRMTotal: Integer;
    FQtdVezesProcessamento: Integer;
    FSglProdutor: String;
    FNomArquivoUpload: String;
    FNomUsuarioUpload: String;
    FQtdOcorrencias: Integer;
    FQtdLinhas: Integer;
    FQtdRMErro: Integer;
    FQtdAnimaisInsercaoErro: Integer;
    FQtdAnimaisAlteracaoErro: Integer;
    FQtdTourosRMErro: Integer;
    FQtdEventosErro: Integer;
    FQtdAnimaisEventosErro: Integer;
    FQtdCRacialTotal: Integer;
    FQtdCRacialProcessados: Integer;
    FQtdCRacialErro: Integer;
    FQtdInventariosAnimaisTotal: Integer;
    FQtdInventariosAnimaisProcessados: Integer;
    FQtdInventariosAnimaisErro: Integer;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: String;
    FDesTipoOrigemArqImport: String;
    FCodSituacaoArqImport: String;
    FDesSituacaoArqImport: String;
    FCodUsuarioUpload: Integer;
    FCodUltimaTarefa: Integer;
    FCodSituacaoUltimaTarefa: String;
    FDesSituacaoUltimaTarefa: String;
    FDtaInicioPrevistoUltimaTarefa: TDateTime;
    FDtaInicioRealUltimaTarefa: TDateTime;
    FDtaFimRealUltimaTarefa: TDateTime;
 public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
    property NomArquivoImportacao: String read FNomArquivoImportacao write FNomArquivoImportacao;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property NomPessoaProdutor: String read FNomPessoaProdutor write FNomPessoaProdutor;
    property NumCNPJCPFFormatadoProdutor: String read FNumCNPJCPFFormatadoProdutor write FNumCNPJCPFFormatadoProdutor;
    property QtdAnimaisAlteracaoProcessados: Integer read FQtdAnimaisAlteracaoProcessados write FQtdAnimaisAlteracaoProcessados;
    property QtdAnimaisAlteracaoTotal: Integer read FQtdAnimaisAlteracaoTotal write FQtdAnimaisAlteracaoTotal;
    property QtdAnimaisEventosProcessados: Integer read FQtdAnimaisEventosProcessados write FQtdAnimaisEventosProcessados;
    property QtdAnimaisEventosTotal: Integer read FQtdAnimaisEventosTotal write FQtdAnimaisEventosTotal;
    property QtdAnimaisInsercaoProcessados: Integer read FQtdAnimaisInsercaoProcessados write FQtdAnimaisInsercaoProcessados;
    property QtdAnimaisInsercaoTotal: Integer read FQtdAnimaisInsercaoTotal write FQtdAnimaisInsercaoTotal;
    property QtdEventosProcessados: Integer read FQtdEventosProcessados write FQtdEventosProcessados;
    property QtdEventosTotal: Integer read FQtdEventosTotal write FQtdEventosTotal;
    property QtdRMProcessados: Integer read FQtdRMProcessados write FQtdRMProcessados;
    property QtdRMTotal: Integer read FQtdRMTotal write FQtdRMTotal;
    property QtdTourosRMProcessados: Integer read FQtdTourosRMProcessados write FQtdTourosRMProcessados;
    property QtdTourosRMTotal: Integer read FQtdTourosRMTotal write FQtdTourosRMTotal;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property SglProdutor: String read FSglProdutor write FSglProdutor;
    property NomArquivoUpload: String read FNomArquivoUpload write FNomArquivoUpload;
    property NomUsuarioUpload: String read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdRMErro: Integer read FQtdRMErro write FQtdRMErro;
    property QtdAnimaisInsercaoErro: Integer read FQtdAnimaisInsercaoErro write FQtdAnimaisInsercaoErro;
    property QtdAnimaisAlteracaoErro: Integer read FQtdAnimaisAlteracaoErro write FQtdAnimaisAlteracaoErro;
    property QtdTourosRMErro: Integer read FQtdTourosRMErro write FQtdTourosRMErro;
    property QtdEventosErro: Integer read FQtdEventosErro write FQtdEventosErro;
    property QtdAnimaisEventosErro: Integer read FQtdAnimaisEventosErro write FQtdAnimaisEventosErro;
    property QtdCRacialTotal: Integer read FQtdCRacialTotal write FQtdCRacialTotal;
    property QtdCRacialProcessados: Integer read FQtdCRacialProcessados write FQtdCRacialProcessados;
    property QtdCRacialErro: Integer read FQtdCRacialErro write FQtdCRacialErro;
    property QtdInventariosAnimaisTotal: Integer read FQtdInventariosAnimaisTotal write FQtdInventariosAnimaisTotal;
    property QtdInventariosAnimaisProcessados: Integer read FQtdInventariosAnimaisProcessados write FQtdInventariosAnimaisProcessados;
    property QtdInventariosAnimaisErro: Integer read FQtdInventariosAnimaisErro write FQtdInventariosAnimaisErro;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: String read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property CodSituacaoArqImport: String read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property DesSituacaoArqImport: String read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property CodUltimaTarefa: Integer read FCodUltimaTarefa write FCodUltimaTarefa;
    property CodSituacaoUltimaTarefa: String read FCodSituacaoUltimaTarefa write FCodSituacaoUltimaTarefa;
    property DesSituacaoUltimaTarefa: String read FDesSituacaoUltimaTarefa write FDesSituacaoUltimaTarefa;
    property DtaInicioPrevistoUltimaTarefa: TDateTime read FDtaInicioPrevistoUltimaTarefa write FDtaInicioPrevistoUltimaTarefa;
    property DtaInicioRealUltimaTarefa: TDateTime read FDtaInicioRealUltimaTarefa write FDtaInicioRealUltimaTarefa;
    property DtaFimRealUltimaTarefa: TDateTime read FDtaFimRealUltimaTarefa write FDtaFimRealUltimaTarefa;
 end;

implementation

end.
