// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 29/07/2004
// *  Documentação       : Envio Arquivos FTP - Definição das Classes.doc
// *                       classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo a ser (ou já)
// *                       enviado via FTP
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uArquivosFTPEnvio;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntArquivosFTPEnvio, uArquivoFTPEnvio, uConexao, uIntMensagens;

type
  TArquivosFTPEnvio = class(TASPMTSObject, IArquivosFTPEnvio)
  private
     FIntArquivosFTPEnvio : TIntArquivosFTPEnvio;
     FInicializado        : Boolean;
     FArquivoFTPEnvio     : TArquivoFTPEnvio;
  protected
    function AlterarSituacaoParaPendente(CodArquivoFTPEnvio: Integer): Integer;
      safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodArquivoFTPEnvio: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_ArquivoFTPEnvio: IArquivoFTPEnvio; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodRotinaFTPEnvio: Integer;
      const NomArquivoLocal: WideString; CodTipoMensagem,
      CodSituacaoArquivoFTP: Integer; DtaUltimaTransferenciaInicio,
      DtaUltimaTransferenciaFim: TDateTime;
      const IndAindaSemTransferencia: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function PesquisarErrosFTPEnvio(CodArquivoFTPEnvio: Integer): Integer;
      safecall;
    function Enviar(CodArquivo, ReadTimeOut: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TArquivosFTPEnvio.AfterConstruction;
begin
  inherited;
  FArquivoFTPEnvio := TArquivoFTPEnvio.Create;
  FArquivoFTPEnvio.ObjAddRef;
  FInicializado := False;
end;

procedure TArquivosFTPEnvio.BeforeDestruction;
begin
  If FIntArquivosFTPEnvio <> nil Then Begin
    FIntArquivosFTPEnvio.Free;
  End;
  If FArquivoFTPEnvio <> nil Then Begin
    FArquivoFTPEnvio.ObjRelease;
    FArquivoFTPEnvio := nil;
  End;
  inherited;
end;

function TArquivosFTPEnvio.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntArquivosFTPEnvio := TIntArquivosFTPEnvio.Create;
  Result := FIntArquivosFTPEnvio.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TArquivosFTPEnvio.AlterarSituacaoParaPendente(
  CodArquivoFTPEnvio: Integer): Integer;
begin
  Result := FIntArquivosFTPEnvio.AlterarSituacaoParaPendente(CodArquivoFTPEnvio);
end;

function TArquivosFTPEnvio.BOF: WordBool;
begin
  Result := FIntArquivosFTPEnvio.BOF;
end;

function TArquivosFTPEnvio.Buscar(CodArquivoFTPEnvio: Integer): Integer;
begin
  Result := FIntArquivosFTPEnvio.Buscar(CodArquivoFTPEnvio);
end;

function TArquivosFTPEnvio.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntArquivosFTPEnvio.Deslocar(NumDeslocamento);
end;

function TArquivosFTPEnvio.EOF: WordBool;
begin
  Result := FIntArquivosFTPEnvio.EOF;
end;

function TArquivosFTPEnvio.Get_ArquivoFTPEnvio: IArquivoFTPEnvio;
begin
  FArquivoFTPEnvio.CodArquivoFTPEnvio          := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.CodArquivoFTPEnvio;
  FArquivoFTPEnvio.CodRotinaFTPEnvio           := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.CodRotinaFTPEnvio;
  FArquivoFTPEnvio.DesRotinaFTPEnvio           := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.DesRotinaFTPEnvio;
  FArquivoFTPEnvio.NomArquivoLocal             := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.NomArquivoLocal;
  FArquivoFTPEnvio.NomArquivoRemoto            := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.NomArquivoRemoto;
  FArquivoFTPEnvio.TxtCaminhoLocal             := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.TxtCaminhoLocal;
  FArquivoFTPEnvio.QtdBytesArquivo             := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.QtdBytesArquivo;
  FArquivoFTPEnvio.CodTipoMensagem             := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.CodTipoMensagem;
  FArquivoFTPEnvio.DesTipoMensagem             := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.DesTipoMensagem;
  FArquivoFTPEnvio.TxtMensagem                 := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.TxtMensagem;
  FArquivoFTPEnvio.CodSituacaoArquivoFTP       := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.CodSituacaoArquivoFTP;
  FArquivoFTPEnvio.SglSituacaoArquivoFTP       := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.SglSituacaoArquivoFTP;
  FArquivoFTPEnvio.DesSituacaoArquivoFTP       := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.DesSituacaoArquivoFTP;
  FArquivoFTPEnvio.DtaUltimaTransferencia      := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.DtaUltimaTransferencia;
  FArquivoFTPEnvio.QtdDuracaoTransferencia     := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.QtdDuracaoTransferencia;
  FArquivoFTPEnvio.QtdVezesTransferencia       := FIntArquivosFTPEnvio.IntArquivoFTPEnvio.QtdVezesTransferencia;
  Result := FArquivoFTPEnvio;
end;

function TArquivosFTPEnvio.NumeroRegistros: Integer;
begin
  Result := FIntArquivosFTPEnvio.NumeroRegistros;
end;

function TArquivosFTPEnvio.Pesquisar(CodRotinaFTPEnvio: Integer;
  const NomArquivoLocal: WideString; CodTipoMensagem,
  CodSituacaoArquivoFTP: Integer; DtaUltimaTransferenciaInicio,
  DtaUltimaTransferenciaFim: TDateTime;
  const IndAindaSemTransferencia: WideString): Integer;
begin
  Result := FIntArquivosFTPEnvio.Pesquisar(CodRotinaFTPEnvio,
                                           NomArquivoLocal,
                                           CodTipoMensagem,
                                           CodSituacaoArquivoFTP,
                                           DtaUltimaTransferenciaInicio,
                                           DtaUltimaTransferenciaFim,
                                           IndAindaSemTransferencia);
end;

function TArquivosFTPEnvio.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntArquivosFTPEnvio.ValorCampo(NomCampo);
end;

procedure TArquivosFTPEnvio.IrAoAnterior;
begin
  FIntArquivosFTPEnvio.IrAoAnterior;
end;

procedure TArquivosFTPEnvio.IrAoPrimeiro;
begin
  FIntArquivosFTPEnvio.IrAoPrimeiro;
end;

procedure TArquivosFTPEnvio.IrAoProximo;
begin
  FIntArquivosFTPEnvio.IrAoProximo;
end;

procedure TArquivosFTPEnvio.IrAoUltimo;
begin
  FIntArquivosFTPEnvio.IrAoUltimo;
end;

procedure TArquivosFTPEnvio.Posicionar(NumPosicao: Integer);
begin
  FIntArquivosFTPEnvio.Posicionar(NumPosicao);
end;

function TArquivosFTPEnvio.PesquisarErrosFTPEnvio(
  CodArquivoFTPEnvio: Integer): Integer;
begin
  Result := FIntArquivosFTPEnvio.PesquisarErroFTPEnvio(CodArquivoFTPEnvio);
end;

function TArquivosFTPEnvio.Enviar(CodArquivo,
  ReadTimeOut: Integer): Integer;
begin
  Result := FIntArquivosFTPEnvio.Enviar(CodArquivo, ReadTimeOut);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivosFTPEnvio, Class_ArquivosFTPEnvio,
    ciMultiInstance, tmApartment);
end.
