unit uTarefa;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TTarefa = class(TASPMTSObject, ITarefa)
  private
    FCodSituacaoTarefa: WideString;
    FCodTarefa: Integer;
    FCodTipoTarefa: Integer;
    FDesSituacaoTarefa: WideString;
    FDtaAgendamento: TDateTime;
    FDtaFimReal: TDateTime;
    FDtaInicioPrevisto: TDateTime;
    FDtaInicioReal: TDateTime;
    FIndPermiteCancelamento: WideString;
    FQtdProgresso: Integer;
    FTxtMensagemErro: WideString;
    FNomArqUpLoad: WideString;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: WideString;
    FDesTipoOrigemArqImport: WideString;
    FNomArqRelatorio: WideString;
  protected
    function Get_CodSituacaoTarefa: WideString; safecall;
    function Get_CodTarefa: Integer; safecall;
    function Get_CodTipoTarefa: Integer; safecall;
    function Get_DesSituacaoTarefa: WideString; safecall;
    function Get_DtaAgendamento: TDateTime; safecall;
    function Get_DtaFimReal: TDateTime; safecall;
    function Get_DtaInicioPrevisto: TDateTime; safecall;
    function Get_DtaInicioReal: TDateTime; safecall;
    function Get_IndPermiteCancelamento: WideString; safecall;
    function Get_QtdProgresso: Integer; safecall;
    function Get_TxtMensagemErro: WideString; safecall;
    procedure Set_CodSituacaoTarefa(const Value: WideString); safecall;
    procedure Set_CodTarefa(Value: Integer); safecall;
    procedure Set_CodTipoTarefa(Value: Integer); safecall;
    procedure Set_DesSituacaoTarefa(const Value: WideString); safecall;
    procedure Set_DtaAgendamento(Value: TDateTime); safecall;
    procedure Set_DtaFimReal(Value: TDateTime); safecall;
    procedure Set_DtaInicioPrevisto(Value: TDateTime); safecall;
    procedure Set_DtaInicioReal(Value: TDateTime); safecall;
    procedure Set_IndPermiteCancelamento(const Value: WideString); safecall;
    procedure Set_QtdProgresso(Value: Integer); safecall;
    procedure Set_TxtMensagemErro(const Value: WideString); safecall;
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    function Get_NomArqUpLoad: WideString; safecall;
    function Get_SqlTipoOrigemArqImport: WideString; safecall;
    procedure Set_CodTipoOrigemArqImport(Value: Integer); safecall;
    procedure Set_DesTipoOrigemArqImport(const Value: WideString); safecall;
    procedure Set_NomArqUpLoad(const Value: WideString); safecall;
    procedure Set_SqlTipoOrigemArqImport(const Value: WideString); safecall;

    procedure Set_SglTipoOrigemArqImport(const Value: WideString); safecall;
    function Get_SglTipoOrigemArqImport: WideString; safecall;
    function Get_NomArqRelatorio: WideString; safecall;
    procedure Set_NomArqRelatorio(const Value: WideString); safecall;
  public
    property CodSituacaoTarefa: WideString read FCodSituacaoTarefa write FCodSituacaoTarefa;
    property CodTarefa: Integer read FCodTarefa write FCodTarefa;
    property CodTipoTarefa: Integer read FCodTipoTarefa write FCodTipoTarefa;
    property DesSituacaoTarefa: WideString read FDesSituacaoTarefa write FDesSituacaoTarefa;
    property DtaAgendamento: TDateTime read FDtaAgendamento write FDtaAgendamento;
    property DtaFimReal: TDateTime read FDtaFimReal write FDtaFimReal;
    property DtaInicioPrevisto: TDateTime read FDtaInicioPrevisto write FDtaInicioPrevisto;
    property DtaInicioReal: TDateTime read FDtaInicioReal write FDtaInicioReal;
    property IndPermiteCancelamento: WideString read FIndPermiteCancelamento write FIndPermiteCancelamento;
    property QtdProgresso: Integer read FQtdProgresso write FQtdProgresso;
    property TxtMensagemErro: WideString read FTxtMensagemErro write FTxtMensagemErro;
    property NomArqUpLoad: WideString read FNomArqUpLoad write FNomArqUpLoad;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: WideString read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: WideString read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property NomArqRelatorio: WideString read FNomArqRelatorio write FNomArqRelatorio;
  end;

  
implementation

uses ComServ;

function TTarefa.Get_CodSituacaoTarefa: WideString;
begin
  Result := FCodSituacaoTarefa;
end;

function TTarefa.Get_CodTarefa: Integer;
begin
  Result := FCodTarefa;
end;

function TTarefa.Get_CodTipoTarefa: Integer;
begin
  Result := FCodTipoTarefa;
end;

function TTarefa.Get_DesSituacaoTarefa: WideString;
begin
  Result := FDesSituacaoTarefa;
end;

function TTarefa.Get_DtaAgendamento: TDateTime;
begin
  Result := FDtaAgendamento;
end;

function TTarefa.Get_DtaFimReal: TDateTime;
begin
  Result := FDtaFimReal;
end;

function TTarefa.Get_DtaInicioPrevisto: TDateTime;
begin
  Result := FDtaInicioPrevisto;
end;

function TTarefa.Get_DtaInicioReal: TDateTime;
begin
  Result := FDtaInicioReal;
end;

function TTarefa.Get_IndPermiteCancelamento: WideString;
begin
  Result := FIndPermiteCancelamento;
end;

function TTarefa.Get_QtdProgresso: Integer;
begin
  Result := FQtdProgresso;
end;

function TTarefa.Get_TxtMensagemErro: WideString;
begin
  Result := FTxtMensagemErro;
end;

procedure TTarefa.Set_CodSituacaoTarefa(const Value: WideString);
begin
  FCodSituacaoTarefa := Value;
end;

procedure TTarefa.Set_CodTarefa(Value: Integer);
begin
  FCodTarefa := Value;
end;

procedure TTarefa.Set_CodTipoTarefa(Value: Integer);
begin
  FCodTipoTarefa := Value;
end;

procedure TTarefa.Set_DesSituacaoTarefa(const Value: WideString);
begin
  FDesSituacaoTarefa := Value;
end;

procedure TTarefa.Set_DtaAgendamento(Value: TDateTime);
begin
  FDtaAgendamento := Value;
end;

procedure TTarefa.Set_DtaFimReal(Value: TDateTime);
begin
  FDtaFimReal := Value;
end;

procedure TTarefa.Set_DtaInicioPrevisto(Value: TDateTime);
begin
  FDtaInicioPrevisto := Value;
end;

procedure TTarefa.Set_DtaInicioReal(Value: TDateTime);
begin
  FDtaInicioReal := Value;
end;

procedure TTarefa.Set_IndPermiteCancelamento(const Value: WideString);
begin
  FIndPermiteCancelamento := Value;
end;

procedure TTarefa.Set_QtdProgresso(Value: Integer);
begin
  FQtdProgresso := Value;
end;

procedure TTarefa.Set_TxtMensagemErro(const Value: WideString);
begin
  FTxtMensagemErro := Value;
end;

function TTarefa.Get_CodTipoOrigemArqImport: Integer;
begin
   Result := FCodTipoOrigemArqImport;
end;

function TTarefa.Get_DesTipoOrigemArqImport: WideString;
begin
   Result := FDesTipoOrigemArqImport;
end;

function TTarefa.Get_NomArqUpLoad: WideString;
begin
   Result := FNomArqUpLoad;
end;

function TTarefa.Get_SqlTipoOrigemArqImport: WideString;
begin
   Result := FSglTipoOrigemArqImport;
end;

procedure TTarefa.Set_CodTipoOrigemArqImport(Value: Integer);
begin
   FCodTipoOrigemArqImport := Value;
end;

procedure TTarefa.Set_DesTipoOrigemArqImport(const Value: WideString);
begin
   FDesTipoOrigemArqImport := Value;
end;

procedure TTarefa.Set_NomArqUpLoad(const Value: WideString);
begin
   FNomArqUpLoad := Value;
end;

procedure TTarefa.Set_SqlTipoOrigemArqImport(const Value: WideString);
begin
   FSglTipoOrigemArqImport := Value;
end;

procedure TTarefa.Set_SglTipoOrigemArqImport(const Value: WideString);
begin
   FSglTipoOrigemArqImport := Value;
end;

function TTarefa.Get_SglTipoOrigemArqImport: WideString;
begin
   Result := FSglTipoOrigemArqImport;
end;

function TTarefa.Get_NomArqRelatorio: WideString;
begin
  Result := FNomArqRelatorio;
end;

procedure TTarefa.Set_NomArqRelatorio(const Value: WideString);
begin
  FNomArqRelatorio := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTarefa, Class_Tarefa,
    ciMultiInstance, tmApartment);
end.
