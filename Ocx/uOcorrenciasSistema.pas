// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 02/08/2004
// *  Documentação       : Ocorrências Sistema - Definição das Classes.doc
// *  Descrição Resumida : Armazena atributos referentes à ocorrência no sistema
// *                       de uma mensagem de advertência ou erro.
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uOcorrenciasSistema;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntOcorrenciasSistema, uOcorrenciaSistema, uConexao, uIntMensagens;

type
  TOcorrenciasSistema = class(TASPMTSObject, IOcorrenciasSistema)
  private
     FIntOcorrenciasSistema : TIntOcorrenciasSistema;
     FInicializado          : Boolean;
     FOcorrenciaSistema     : TOcorrenciaSistema;
  protected
    function AlterarParaNaoTratada(CodOcorrenciaSistema: Integer): Integer;
      safecall;
    function AlterarParaTratada(CodOcorrenciaSistema: Integer): Integer;
      safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodOcorrenciaSistema: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_OcorrenciaSistema: IOcorrenciaSistema; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(DtaOcorrenciaInicio, DtaOcorrenciaFim: TDateTime;
      const IndOcorrenciaTratada: WideString; CodAplicativo,
      CodTipoMensagem: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntOcorrenciaSistema;

procedure TOcorrenciasSistema.AfterConstruction;
begin
  inherited;
  FOcorrenciaSistema := TOcorrenciaSistema.Create;
  FOcorrenciaSistema.ObjAddRef;
  FInicializado := False;
end;

procedure TOcorrenciasSistema.BeforeDestruction;
begin
  If FIntOcorrenciasSistema <> nil Then Begin
    FIntOcorrenciasSistema.Free;
  End;
  If FOcorrenciaSistema <> nil Then Begin
    FOcorrenciaSistema.ObjRelease;
    FOcorrenciaSistema := nil;
  End;
  inherited;
end;

function TOcorrenciasSistema.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntOcorrenciasSistema := TIntOcorrenciasSistema.Create;
  Result := FIntOcorrenciasSistema.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TOcorrenciasSistema.AlterarParaNaoTratada(
  CodOcorrenciaSistema: Integer): Integer;
begin
  Result := FIntOcorrenciasSistema.AlterarParaNaoTratada(CodOcorrenciaSistema);
end;

function TOcorrenciasSistema.AlterarParaTratada(
  CodOcorrenciaSistema: Integer): Integer;
begin
  Result := FIntOcorrenciasSistema.AlterarParaTratada(CodOcorrenciaSistema);
end;

function TOcorrenciasSistema.BOF: WordBool;
begin
  Result := FIntOcorrenciasSistema.BOF;
end;

function TOcorrenciasSistema.Buscar(CodOcorrenciaSistema: Integer): Integer;
begin
  Result := FIntOcorrenciasSistema.Buscar(CodOcorrenciaSistema);
end;

function TOcorrenciasSistema.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntOcorrenciasSistema.Deslocar(NumDeslocamento);
end;

function TOcorrenciasSistema.EOF: WordBool;
begin
  Result := FIntOcorrenciasSistema.EOF;
end;

function TOcorrenciasSistema.Get_OcorrenciaSistema: IOcorrenciaSistema;
begin
  FOcorrenciaSistema.CodOcorrenciaSistema    := FIntOcorrenciasSistema.IntOcorrenciaSistema.CodOcorrenciaSistema;
  FOcorrenciaSistema.DtaOcorrenciaSistema    := FIntOcorrenciasSistema.IntOcorrenciaSistema.DtaOcorrenciaSistema;
  FOcorrenciaSistema.IndOcorrenciaTratada    := FIntOcorrenciasSistema.IntOcorrenciaSistema.IndOcorrenciaTratada;
  FOcorrenciaSistema.CodAplicativo           := FIntOcorrenciasSistema.IntOcorrenciaSistema.CodAplicativo;
  FOcorrenciaSistema.NomAplicativo           := FIntOcorrenciasSistema.IntOcorrenciaSistema.NomAplicativo;
  FOcorrenciaSistema.CodTipoMensagem         := FIntOcorrenciasSistema.IntOcorrenciaSistema.CodTipoMensagem;
  FOcorrenciaSistema.DesTipoMensagem         := FIntOcorrenciasSistema.IntOcorrenciaSistema.DesTipoMensagem;
  FOcorrenciaSistema.TxtMensagem             := FIntOcorrenciasSistema.IntOcorrenciaSistema.TxtMensagem;
  FOcorrenciaSistema.TxtIdentificacao        := FIntOcorrenciasSistema.IntOcorrenciaSistema.TxtIdentificacao;
  FOcorrenciaSistema.TxtLegendaIdentificacao := FIntOcorrenciasSistema.IntOcorrenciaSistema.TxtLegendaIdentificacao;
  Result := FOcorrenciaSistema;
end;

function TOcorrenciasSistema.NumeroRegistros: Integer;
begin
  Result := FIntOcorrenciasSistema.NumeroRegistros;
end;

function TOcorrenciasSistema.Pesquisar(DtaOcorrenciaInicio,
  DtaOcorrenciaFim: TDateTime; const IndOcorrenciaTratada: WideString;
  CodAplicativo, CodTipoMensagem: Integer): Integer;
begin
  Result := FIntOcorrenciasSistema.Pesquisar(DtaOcorrenciaInicio, DtaOcorrenciaFim,
                                             IndOcorrenciaTratada, CodAplicativo, CodTipoMensagem);
end;

function TOcorrenciasSistema.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntOcorrenciasSistema.ValorCampo(NomCampo);
end;

procedure TOcorrenciasSistema.IrAoAnterior;
begin
  FIntOcorrenciasSistema.IrAoAnterior;
end;

procedure TOcorrenciasSistema.IrAoPrimeiro;
begin
  FIntOcorrenciasSistema.IrAoPrimeiro;
end;

procedure TOcorrenciasSistema.IrAoProximo;
begin
  FIntOcorrenciasSistema.IrAoProximo;
end;

procedure TOcorrenciasSistema.IrAoUltimo;
begin
  FIntOcorrenciasSistema.IrAoUltimo;
end;

procedure TOcorrenciasSistema.Posicionar(NumPosicao: Integer);
begin
  FIntOcorrenciasSistema.Posicionar(NumPosicao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOcorrenciasSistema, Class_OcorrenciasSistema,
    ciMultiInstance, tmApartment);
end.
