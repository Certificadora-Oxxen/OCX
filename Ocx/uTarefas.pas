unit uTarefas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMensagens, uConexao,
    uIntTarefas, uTarefa;

type
  TTarefas = class(TASPMTSObject, ITarefas)
  private
    FIntTarefas: TIntTarefas;
    FTarefa: TTarefa;
    FInicializado: Boolean;
  protected
    function BOF: WordBool; safecall;
    function Buscar(CodTarefa: Integer): Integer; safecall;
    function Cancelar(CodTarefa: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_Tarefa: ITarefa; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(DtaAgendamentoInicio, DtaAgendamentoFim: TDateTime;
      QtdDiasConclusao: Integer; const CodSituacaoTarefa, NomUsuario,
      NomArqUpload: WideString; CodTipoOrigemArqImport: Integer): Integer;
      safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTarefas.AfterConstruction;
begin
  inherited;
  FTarefa := TTarefa.Create;
  FTarefa.ObjAddRef;
  FInicializado := False;
end;

procedure TTarefas.BeforeDestruction;
begin
  If FIntTarefas <> nil Then Begin
    FIntTarefas.Free;
  End;
  If FTarefa <> nil Then Begin
    FTarefa.ObjRelease;
    FTarefa := nil;
  End;
  inherited;
end;

function TTarefas.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntTarefas := TIntTarefas.Create;
  Result := FIntTarefas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTarefas.BOF: WordBool;
begin
  Result := FIntTarefas.BOF;
end;

function TTarefas.Buscar(CodTarefa: Integer): Integer;
begin
  Result := FIntTarefas.Buscar(CodTarefa);
end;

function TTarefas.Cancelar(CodTarefa: Integer): Integer;
begin
  Result := FIntTarefas.Cancelar(CodTarefa);
end;

function TTarefas.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntTarefas.Deslocar(QtdRegistros);
end;

function TTarefas.EOF: WordBool;
begin
  Result := FIntTarefas.EOF;
end;

function TTarefas.Get_Tarefa: ITarefa;
begin
  FTarefa.CodSituacaoTarefa             := FIntTarefas.IntTarefa.CodSituacaoTarefa;
  FTarefa.CodTarefa                     := FIntTarefas.IntTarefa.CodTarefa;
  FTarefa.CodTipoTarefa                 := FIntTarefas.IntTarefa.CodTipoTarefa;
  FTarefa.DesSituacaoTarefa             := FIntTarefas.IntTarefa.DesSituacaoTarefa;
  FTarefa.DtaAgendamento                := FIntTarefas.IntTarefa.DtaAgendamento;
  FTarefa.DtaFimReal                    := FIntTarefas.IntTarefa.DtaFimReal;
  FTarefa.DtaInicioPrevisto             := FIntTarefas.IntTarefa.DtaInicioPrevisto;
  FTarefa.DtaInicioReal                 := FIntTarefas.IntTarefa.DtaInicioReal;
  FTarefa.IndPermiteCancelamento        := FIntTarefas.IntTarefa.IndPermiteCancelamento;
  FTarefa.QtdProgresso                  := FIntTarefas.IntTarefa.QtdProgresso;
  FTarefa.TxtMensagemErro               := FIntTarefas.IntTarefa.TxtMensagemErro;
  FTarefa.NomArqUpLoad                  := FIntTarefas.IntTarefa.NomArqUpLoad;
  FTarefa.CodTipoOrigemArqImport        := FIntTarefas.IntTarefa.CodTipoOrigemArqImport;
  FTarefa.SglTipoOrigemArqImport        := FIntTarefas.IntTarefa.SglTipoOrigemArqImport;
  FTarefa.DesSituacaoTarefa             := FIntTarefas.IntTarefa.DesSituacaoTarefa;
  FTarefa.NomArqRelatorio               := FIntTarefas.IntTarefa.NomArqRelatorio;
  Result := FTarefa;
end;

function TTarefas.NumeroRegistros: Integer;
begin
  Result := FIntTarefas.NumeroRegistros;
end;

function TTarefas.Pesquisar(DtaAgendamentoInicio,
  DtaAgendamentoFim: TDateTime; QtdDiasConclusao: Integer;
  const CodSituacaoTarefa, NomUsuario, NomArqUpload: WideString;
  CodTipoOrigemArqImport: Integer): Integer;
begin
  Result := FIntTarefas.Pesquisar(DtaAgendamentoInicio,
                                  DtaAgendamentoFim,
                                  QtdDiasConclusao,
                                  CodSituacaoTarefa,
                                  NomUsuario, 
                                  NomArqUpLoad,
                                  CodTipoOrigemArqImport);
end;

function TTarefas.ValorCampo(const NomColuna: WideString): OleVariant;
begin
  Result := FIntTarefas.ValorCampo(NomColuna);
end;

procedure TTarefas.IrAoAnterior;
begin
  FIntTarefas.IrAoAnterior;
end;

procedure TTarefas.IrAoPrimeiro;
begin
  FIntTarefas.IrAoPrimeiro;
end;

procedure TTarefas.IrAoProximo;
begin
  FIntTarefas.IrAoProximo;
end;

procedure TTarefas.IrAoUltimo;
begin
  FIntTarefas.IrAoUltimo;
end;

procedure TTarefas.Posicionar(NumRegistro: Integer);
begin
  FIntTarefas.Posicionar(NumRegistro);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTarefas, Class_Tarefas,
    ciMultiInstance, tmApartment);
end.
