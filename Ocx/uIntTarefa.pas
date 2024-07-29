unit uIntTarefa;

interface

type
  TIntTarefa = class
  private
    FCodSituacaoTarefa: String;
    FCodTarefa: Integer;
    FCodTipoTarefa: Integer;
    FDesSituacaoTarefa: String;
    FDtaAgendamento: TDateTime;
    FDtaFimReal: TDateTime;
    FDtaInicioPrevisto: TDateTime;
    FDtaInicioReal: TDateTime;
    FIndPermiteCancelamento: String;
    FQtdProgresso: Integer;
    FTxtMensagemErro: String;
    FNomArqUpLoad: String;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: String;
    FDesTipoOrigemArqImport: String;
    FNomArqRelatorio: String;
  public
    property CodSituacaoTarefa: String read FCodSituacaoTarefa write FCodSituacaoTarefa;
    property CodTarefa: Integer read FCodTarefa write FCodTarefa;
    property CodTipoTarefa: Integer read FCodTipoTarefa write FCodTipoTarefa;
    property DesSituacaoTarefa: String read FDesSituacaoTarefa write FDesSituacaoTarefa;
    property DtaAgendamento: TDateTime read FDtaAgendamento write FDtaAgendamento;
    property DtaFimReal: TDateTime read FDtaFimReal write FDtaFimReal;
    property DtaInicioPrevisto: TDateTime read FDtaInicioPrevisto write FDtaInicioPrevisto;
    property DtaInicioReal: TDateTime read FDtaInicioReal write FDtaInicioReal;
    property IndPermiteCancelamento: String read FIndPermiteCancelamento write FIndPermiteCancelamento;
    property QtdProgresso: Integer read FQtdProgresso write FQtdProgresso;
    property TxtMensagemErro: String read FTxtMensagemErro write FTxtMensagemErro;
    property NomArqUpLoad: String read FNomArqUpLoad write FNomArqUpLoad;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: String read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property NomArqRelatorio: String read FNomArqRelatorio write FNomArqRelatorio;
  end;

implementation

end.
