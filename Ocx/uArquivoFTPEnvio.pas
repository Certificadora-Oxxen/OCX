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

unit uArquivoFTPEnvio;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TArquivoFTPEnvio = class(TASPMTSObject, IArquivoFTPEnvio)
  private
    FCodArquivoFTPEnvio      : Integer;
    FCodRotinaFTPEnvio       : Integer;
    FDesRotinaFTPEnvio       : WideString;
    FNomArquivoLocal         : WideString;
    FNomArquivoRemoto        : WideString;
    FTxtCaminhoLocal         : WideString;
    FQtdBytesArquivo         : Integer;
    FCodTipoMensagem         : Integer;
    FDesTipoMensagem         : WideString;
    FTxtMensagem             : WideString;
    FCodSituacaoArquivoFTP   : Integer;
    FSglSituacaoArquivoFTP   : WideString;
    FDesSituacaoArquivoFTP   : WideString;
    FDtaUltimaTransferencia  : TDateTime;
    FQtdDuracaoTransferencia : Integer;
    FQtdVezesTransferencia   : Integer;
  protected
    function Get_CodArquivoFTPEnvio: Integer; safecall;
    function Get_CodRotinaFTPEnvio: Integer; safecall;
    function Get_CodSituacaoArquivoFTP: Integer; safecall;
    function Get_CodTipoMensagem: Integer; safecall;
    function Get_DesRotinaFTPEnvio: WideString; safecall;
    function Get_DesSituacaoArquivoFTP: WideString; safecall;
    function Get_DtaUltimaTransferencia: TDateTime; safecall;
    function Get_NomArquivoLocal: WideString; safecall;
    function Get_NomArquivoRemoto: WideString; safecall;
    function Get_QtdBytesArquivo: Integer; safecall;
    function Get_QtdDuracaoTransferencia: Integer; safecall;
    function Get_QtdVezesTransferencia: Integer; safecall;
    function Get_SglSituacaoArquivoFTP: WideString; safecall;
    function Get_TxtCaminhoLocal: WideString; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodArquivoFTPEnvio(Value: Integer); safecall;
    procedure Set_CodRotinaFTPEnvio(Value: Integer); safecall;
    procedure Set_CodSituacaoArquivoFTP(Value: Integer); safecall;
    procedure Set_CodTipoMensagem(Value: Integer); safecall;
    procedure Set_DesRotinaFTPEnvio(const Value: WideString); safecall;
    procedure Set_DesSituacaoArquivoFTP(const Value: WideString); safecall;
    procedure Set_DtaUltimaTransferencia(Value: TDateTime); safecall;
    procedure Set_NomArquivoLocal(const Value: WideString); safecall;
    procedure Set_NomArquivoRemoto(const Value: WideString); safecall;
    procedure Set_QtdBytesArquivo(Value: Integer); safecall;
    procedure Set_QtdDuracaoTransferencia(Value: Integer); safecall;
    procedure Set_QtdVezesTransferencia(Value: Integer); safecall;
    procedure Set_SglSituacaoArquivoFTP(const Value: WideString); safecall;
    procedure Set_TxtCaminhoLocal(const Value: WideString); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
    function Get_DesTipoMensagem: WideString; safecall;
    procedure Set_DesTipoMensagem(const Value: WideString); safecall;
  public
    property CodArquivoFTPEnvio      : Integer    read FCodArquivoFTPEnvio       write FCodArquivoFTPEnvio;
    property CodRotinaFTPEnvio       : Integer    read FCodRotinaFTPEnvio        write FCodRotinaFTPEnvio;
    property DesRotinaFTPEnvio       : WideString read FDesRotinaFTPEnvio        write FDesRotinaFTPEnvio;
    property NomArquivoLocal         : WideString read FNomArquivoLocal          write FNomArquivoLocal;
    property NomArquivoRemoto        : WideString read FNomArquivoRemoto         write FNomArquivoRemoto;
    property TxtCaminhoLocal         : WideString read FTxtCaminhoLocal          write FTxtCaminhoLocal;
    property QtdBytesArquivo         : Integer    read FQtdBytesArquivo          write FQtdBytesArquivo;
    property CodTipoMensagem         : Integer    read FCodTipoMensagem          write FCodTipoMensagem;
    property DesTipoMensagem         : WideString read FDesTipoMensagem          write FDesTipoMensagem;
    property TxtMensagem             : WideString read FTxtMensagem              write FTxtMensagem;
    property CodSituacaoArquivoFTP   : Integer    read FCodSituacaoArquivoFTP    write FCodSituacaoArquivoFTP;
    property SglSituacaoArquivoFTP   : WideString read FSglSituacaoArquivoFTP    write FSglSituacaoArquivoFTP;
    property DesSituacaoArquivoFTP   : WideString read FDesSituacaoArquivoFTP    write FDesSituacaoArquivoFTP;
    property DtaUltimaTransferencia  : TDateTime  read FDtaUltimaTransferencia   write FDtaUltimaTransferencia;
    property QtdDuracaoTransferencia : Integer    read FQtdDuracaoTransferencia  write FQtdDuracaoTransferencia;
    property QtdVezesTransferencia   : Integer    read FQtdVezesTransferencia    write FQtdVezesTransferencia;
  end;

implementation

uses ComServ;

function TArquivoFTPEnvio.Get_CodArquivoFTPEnvio: Integer;
begin
  Result := FCodArquivoFTPEnvio;
end;

function TArquivoFTPEnvio.Get_CodRotinaFTPEnvio: Integer;
begin
  Result := FCodRotinaFTPEnvio;
end;

function TArquivoFTPEnvio.Get_CodSituacaoArquivoFTP: Integer;
begin
  Result := FCodSituacaoArquivoFTP;
end;

function TArquivoFTPEnvio.Get_CodTipoMensagem: Integer;
begin
  Result := FCodTipoMensagem;
end;

function TArquivoFTPEnvio.Get_DesRotinaFTPEnvio: WideString;
begin
  Result := FDesRotinaFTPEnvio;
end;

function TArquivoFTPEnvio.Get_DesSituacaoArquivoFTP: WideString;
begin
  Result := FDesSituacaoArquivoFTP;
end;

function TArquivoFTPEnvio.Get_DtaUltimaTransferencia: TDateTime;
begin
  Result := FDtaUltimaTransferencia;
end;

function TArquivoFTPEnvio.Get_NomArquivoLocal: WideString;
begin
  Result := FNomArquivoLocal;
end;

function TArquivoFTPEnvio.Get_NomArquivoRemoto: WideString;
begin
  Result := FNomArquivoRemoto;
end;

function TArquivoFTPEnvio.Get_QtdBytesArquivo: Integer;
begin
  Result := FQtdBytesArquivo;
end;

function TArquivoFTPEnvio.Get_QtdDuracaoTransferencia: Integer;
begin
  Result := FQtdDuracaoTransferencia;
end;

function TArquivoFTPEnvio.Get_QtdVezesTransferencia: Integer;
begin
  Result := FQtdVezesTransferencia;
end;

function TArquivoFTPEnvio.Get_SglSituacaoArquivoFTP: WideString;
begin
  Result := FSglSituacaoArquivoFTP;
end;

function TArquivoFTPEnvio.Get_TxtCaminhoLocal: WideString;
begin
  Result := FTxtCaminhoLocal;
end;

function TArquivoFTPEnvio.Get_TxtMensagem: WideString;
begin
  Result := FTxtMensagem;
end;

procedure TArquivoFTPEnvio.Set_CodArquivoFTPEnvio(Value: Integer);
begin
  FCodArquivoFTPEnvio := Value;
end;

procedure TArquivoFTPEnvio.Set_CodRotinaFTPEnvio(Value: Integer);
begin
  FCodRotinaFTPEnvio := Value;
end;

procedure TArquivoFTPEnvio.Set_CodSituacaoArquivoFTP(Value: Integer);
begin
  FCodSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPEnvio.Set_CodTipoMensagem(Value: Integer);
begin
  FCodTipoMensagem := Value;
end;

procedure TArquivoFTPEnvio.Set_DesRotinaFTPEnvio(const Value: WideString);
begin
  FDesRotinaFTPEnvio := Value;
end;

procedure TArquivoFTPEnvio.Set_DesSituacaoArquivoFTP(const Value: WideString);
begin
  FDesSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPEnvio.Set_DtaUltimaTransferencia(Value: TDateTime);
begin
  FDtaUltimaTransferencia := Value;
end;

procedure TArquivoFTPEnvio.Set_NomArquivoLocal(const Value: WideString);
begin
  FNomArquivoLocal := Value;
end;

procedure TArquivoFTPEnvio.Set_NomArquivoRemoto(const Value: WideString);
begin
  FNomArquivoRemoto := Value;
end;

procedure TArquivoFTPEnvio.Set_QtdBytesArquivo(Value: Integer);
begin
  FQtdBytesArquivo := Value;
end;

procedure TArquivoFTPEnvio.Set_QtdDuracaoTransferencia(Value: Integer);
begin
  FQtdDuracaoTransferencia := Value;
end;

procedure TArquivoFTPEnvio.Set_QtdVezesTransferencia(Value: Integer);
begin
  FQtdVezesTransferencia := Value;
end;

procedure TArquivoFTPEnvio.Set_SglSituacaoArquivoFTP(const Value: WideString);
begin
  FSglSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPEnvio.Set_TxtCaminhoLocal(const Value: WideString);
begin
  FTxtCaminhoLocal := Value;
end;

procedure TArquivoFTPEnvio.Set_TxtMensagem(const Value: WideString);
begin
  FTxtMensagem := Value;
end;

function TArquivoFTPEnvio.Get_DesTipoMensagem: WideString;
begin
  Result := FDesTipoMensagem;
end;

procedure TArquivoFTPEnvio.Set_DesTipoMensagem(const Value: WideString);
begin
  FDesTipoMensagem := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivoFTPEnvio, Class_ArquivoFTPEnvio,
    ciMultiInstance, tmApartment);
end.
