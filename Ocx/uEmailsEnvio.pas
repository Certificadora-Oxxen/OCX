// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 17/08/2004
// *  Documentação       :
// *  Descrição Resumida :
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uEmailsEnvio;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntEmailsEnvio, uEmailEnvio;

type
  TEmailsEnvio = class(TASPMTSObject, IEmailsEnvio)
  private
    FIntEmailsEnvio : TIntEmailsEnvio;
    FInicializado   : Boolean;
    FEmailEnvio     : TEmailEnvio;
  protected
    function BOF: WordBool; safecall;
    function Buscar(CodEmailEnvio: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_EmailEnvio: IEmailEnvio; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const TxtEmailDestinatario, NomPessoa: WideString;
      CodEmailEnvio, CodTipoEmail: Integer; const TxtAssunto: WideString;
      CodTipoMensagem, CodSituacaoEmail: Integer; DtaUltimoEnvioInicio,
      DtaUltimoEnvioFim: TDateTime;
      const IndAindaSemEnvio: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function AlterarSituacaoParaPendente(CodEmailEnvio: Integer): Integer;
      safecall;
    function PesquisarArquivosAnexos(CodEmailEnvio: Integer): Integer;
      safecall;
    function PesquisarDestinatarios(CodEmailEnvio: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntEmailEnvio;

procedure TEmailsEnvio.AfterConstruction;
begin
  inherited;
  FEmailEnvio  := TEmailEnvio.Create;
  FEmailEnvio.ObjAddRef;
  FInicializado := False;
end;

procedure TEmailsEnvio.BeforeDestruction;
begin
  If FIntEmailsEnvio <> nil Then Begin
    FIntEmailsEnvio.Free;
  End;
  If FEmailEnvio <> nil Then Begin
    FEmailEnvio.ObjRelease;
    FEmailEnvio := nil;
  End;
  inherited;
end;

function TEmailsEnvio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEmailsEnvio := TIntEmailsEnvio.Create;
  Result := FIntEmailsEnvio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEmailsEnvio.Buscar(CodEmailEnvio: Integer): Integer;
begin
  Result := FIntEmailsEnvio.Buscar(CodEmailEnvio);
end;

function TEmailsEnvio.Pesquisar(const TxtEmailDestinatario,
  NomPessoa: WideString; CodEmailEnvio, CodTipoEmail: Integer;
  const TxtAssunto: WideString; CodTipoMensagem, CodSituacaoEmail: Integer;
  DtaUltimoEnvioInicio, DtaUltimoEnvioFim: TDateTime;
  const IndAindaSemEnvio: WideString): Integer;
begin
  Result := FIntEmailsEnvio.Pesquisar(TxtEmailDestinatario, NomPessoa,
              CodEmailEnvio, CodTipoEmail, TxtAssunto, CodTipoMensagem, CodSituacaoEmail,
              DtaUltimoEnvioInicio, DtaUltimoEnvioFim, IndAindaSemEnvio);
end;

function TEmailsEnvio.BOF: WordBool;
begin
  Result := FIntEmailsEnvio.BOF;
end;

function TEmailsEnvio.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntEmailsEnvio.Deslocar(NumDeslocamento);
end;

function TEmailsEnvio.EOF: WordBool;
begin
  Result := FIntEmailsEnvio.EOF;
end;

function TEmailsEnvio.Get_EmailEnvio: IEmailEnvio;
begin
  FEmailEnvio.CodEmailEnvio      := FIntEmailsEnvio.IntEmailEnvio.CodEmailEnvio;
  FEmailEnvio.CodTipoEmail       := FIntEmailsEnvio.IntEmailEnvio.CodTipoEmail;
  FEmailEnvio.DesTipoEmail       := FIntEmailsEnvio.IntEmailEnvio.DesTipoEmail;
  FEmailEnvio.TxtAssunto         := FIntEmailsEnvio.IntEmailEnvio.TxtAssunto;
  FEmailEnvio.TxtCorpoEmail      := FIntEmailsEnvio.IntEmailEnvio.TxtCorpoEmail;
  FEmailEnvio.CodTipoMensagem    := FIntEmailsEnvio.IntEmailEnvio.CodTipoMensagem;
  FEmailEnvio.DesTipoMensagem    := FIntEmailsEnvio.IntEmailEnvio.DesTipoMensagem;
  FEmailEnvio.TxtMensagem        := FIntEmailsEnvio.IntEmailEnvio.TxtMensagem;
  FEmailEnvio.CodSituacaoEmail   := FIntEmailsEnvio.IntEmailEnvio.CodSituacaoEmail;
  FEmailEnvio.SglSituacaoEmail   := FIntEmailsEnvio.IntEmailEnvio.SglSituacaoEmail;
  FEmailEnvio.DesSituacaoEmail   := FIntEmailsEnvio.IntEmailEnvio.DesSituacaoEmail;
  FEmailEnvio.DtaUltimoEnvio     := FIntEmailsEnvio.IntEmailEnvio.DtaUltimoEnvio;
  FEmailEnvio.QtdDuracaoEnvio    := FIntEmailsEnvio.IntEmailEnvio.QtdDuracaoEnvio;
  FEmailEnvio.QtdVezesEnvio      := FIntEmailsEnvio.IntEmailEnvio.QtdVezesEnvio;
  Result := FEmailEnvio;
end;

function TEmailsEnvio.NumeroRegistros: Integer;
begin
  Result := FIntEmailsEnvio.NumeroRegistros;
end;

function TEmailsEnvio.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntEmailsEnvio.ValorCampo(NomCampo);
end;

procedure TEmailsEnvio.IrAoAnterior;
begin
  FIntEmailsEnvio.IrAoAnterior;
end;

procedure TEmailsEnvio.IrAoPrimeiro;
begin
  FIntEmailsEnvio.IrAoPrimeiro;
end;

procedure TEmailsEnvio.IrAoProximo;
begin
  FIntEmailsEnvio.IrAoProximo;
end;

procedure TEmailsEnvio.IrAoUltimo;
begin
  FIntEmailsEnvio.IrAoUltimo;
end;

procedure TEmailsEnvio.Posicionar(NumPosicao: Integer);
begin
  FIntEmailsEnvio.Posicionar(NumPosicao);
end;

function TEmailsEnvio.AlterarSituacaoParaPendente(
  CodEmailEnvio: Integer): Integer;
begin
  FIntEmailsEnvio.AlterarSituacaoParaPendente(CodEmailEnvio);
end;

function TEmailsEnvio.PesquisarArquivosAnexos(
  CodEmailEnvio: Integer): Integer;
begin
  FIntEmailsEnvio.PesquisarArquivosAnexos(CodEmailEnvio);
end;

function TEmailsEnvio.PesquisarDestinatarios(
  CodEmailEnvio: Integer): Integer;
begin
  FIntEmailsEnvio.PesquisarDestinatarios(CodEmailEnvio);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEmailsEnvio, Class_EmailsEnvio,
    ciMultiInstance, tmApartment);
end.
