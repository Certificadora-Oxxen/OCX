// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 06/08/2004
// *  Documentação       : Arquivos FTP de Retorno - Definição das Classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo recebido via FTP
// *                       pelo sistema
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uArquivosFTPRetorno;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntArquivosFTPRetorno, uArquivoFTPRetorno, uConexao, uIntMensagens;

type
  TArquivosFTPRetorno = class(TASPMTSObject, IArquivosFTPRetorno)
  private
     FIntArquivosFTPRetorno : TIntArquivosFTPRetorno;
     FInicializado          : Boolean;
     FArquivoFTPRetorno     : TArquivoFTPRetorno;
  protected
    function BOF: WordBool; safecall;
    function Buscar(CodArquivoFTPRetorno: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_ArquivoFTPRetorno: IArquivoFTPRetorno; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodRotinaFTPRetorno: Integer;
      const NomArquivoRemoto: WideString; CodTipoMensagem,
      CodSituacaoArquivoFTP: Integer; DtaTransferenciaArquivoInicio,
      DtaTransferenciaArquivoFim: TDateTime;
      const IndAindaSemTransferencia: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function AlterarSituacaoParaPendente(
      CodArquivoFTPRetorno: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntArquivoFTPRetorno;

procedure TArquivosFTPRetorno.AfterConstruction;
begin
  inherited;
  FArquivoFTPRetorno := TArquivoFTPRetorno.Create;
  FArquivoFTPRetorno.ObjAddRef;
  FInicializado := False;
end;

procedure TArquivosFTPRetorno.BeforeDestruction;
begin
  If FIntArquivosFTPRetorno <> nil Then Begin
    FIntArquivosFTPRetorno.Free;
  End;
  If FArquivoFTPRetorno <> nil Then Begin
    FArquivoFTPRetorno.ObjRelease;
    FArquivoFTPRetorno := nil;
  End;
  inherited;
end;

function TArquivosFTPRetorno.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntArquivosFTPRetorno := TIntArquivosFTPRetorno.Create;
  Result := FIntArquivosFTPRetorno.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TArquivosFTPRetorno.Buscar(
  CodArquivoFTPRetorno: Integer): Integer;
begin
  Result := FIntArquivosFTPRetorno.Buscar(CodArquivoFTPRetorno);
end;

function TArquivosFTPRetorno.Pesquisar(CodRotinaFTPRetorno: Integer;
  const NomArquivoRemoto: WideString; CodTipoMensagem,
  CodSituacaoArquivoFTP: Integer; DtaTransferenciaArquivoInicio,
  DtaTransferenciaArquivoFim: TDateTime;
  const IndAindaSemTransferencia: WideString): Integer;
begin
  Result := FIntArquivosFTPRetorno.Pesquisar(CodRotinaFTPRetorno,
              NomArquivoRemoto, CodTipoMensagem, CodSituacaoArquivoFTP,
              DtaTransferenciaArquivoInicio, DtaTransferenciaArquivoFim,
              IndAindaSemTransferencia);
end;

function TArquivosFTPRetorno.BOF: WordBool;
begin
  Result := FIntArquivosFTPRetorno.BOF;
end;


function TArquivosFTPRetorno.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntArquivosFTPRetorno.Deslocar(NumDeslocamento);
end;

function TArquivosFTPRetorno.EOF: WordBool;
begin
  Result := FIntArquivosFTPRetorno.EOF;
end;

function TArquivosFTPRetorno.Get_ArquivoFTPRetorno: IArquivoFTPRetorno;
begin
  FArquivoFTPRetorno.CodArquivoFTPRetorno       := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.CodArquivoFTPRetorno;
  FArquivoFTPRetorno.CodRotinaFTPRetorno        := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.CodRotinaFTPRetorno;
  FArquivoFTPRetorno.DesRotinaFTPRetorno        := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.DesRotinaFTPRetorno;
  FArquivoFTPRetorno.NomArquivoLocal            := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.NomArquivoLocal;
  FArquivoFTPRetorno.NomArquivoRemoto           := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.NomArquivoRemoto;
  FArquivoFTPRetorno.DtaCriacaoArquivo          := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.DtaCriacaoArquivo;
  FArquivoFTPRetorno.QtdBytesArquivo            := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.QtdBytesArquivo;
  FArquivoFTPRetorno.CodTipoMensagem            := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.CodTipoMensagem;
  FArquivoFTPRetorno.DesTipoMensagem            := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.DesTipoMensagem;
  FArquivoFTPRetorno.TxtMensagem                := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.TxtMensagem;
  FArquivoFTPRetorno.CodSituacaoArquivoFTP      := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.CodSituacaoArquivoFTP;
  FArquivoFTPRetorno.SglSituacaoArquivoFTP      := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.SglSituacaoArquivoFTP;
  FArquivoFTPRetorno.DesSituacaoArquivoFTP      := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.DesSituacaoArquivoFTP;
  FArquivoFTPRetorno.DtaUltimaTransferencia     := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.DtaUltimaTransferencia;
  FArquivoFTPRetorno.QtdDuracaoTransferencia    := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.QtdDuracaoTransferencia;
  FArquivoFTPRetorno.QtdVezesTransferencia      := FIntArquivosFTPRetorno.IntArquivoFTPRetorno.QtdVezesTransferencia;
  Result := FArquivoFTPRetorno;
end;

function TArquivosFTPRetorno.NumeroRegistros: Integer;
begin
  Result := FIntArquivosFTPRetorno.NumeroRegistros;
end;

function TArquivosFTPRetorno.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntArquivosFTPRetorno.ValorCampo(NomCampo);
end;

procedure TArquivosFTPRetorno.IrAoAnterior;
begin
  FIntArquivosFTPRetorno.IrAoAnterior;
end;

procedure TArquivosFTPRetorno.IrAoPrimeiro;
begin
  FIntArquivosFTPRetorno.IrAoPrimeiro;
end;

procedure TArquivosFTPRetorno.IrAoProximo;
begin
  FIntArquivosFTPRetorno.IrAoProximo;
end;

procedure TArquivosFTPRetorno.IrAoUltimo;
begin
  FIntArquivosFTPRetorno.IrAoUltimo;
end;

procedure TArquivosFTPRetorno.Posicionar(NumPosicao: Integer);
begin
  FIntArquivosFTPRetorno.Posicionar(NumPosicao);
end;

function TArquivosFTPRetorno.AlterarSituacaoParaPendente(
  CodArquivoFTPRetorno: Integer): Integer;
begin
  Result := FIntArquivosFTPRetorno.AlterarSituacaoParaPendente(CodArquivoFTPRetorno);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivosFTPRetorno, Class_ArquivosFTPRetorno,
    ciMultiInstance, tmApartment);
end.
