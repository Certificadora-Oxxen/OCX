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

unit uArquivoFTPRetorno;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TArquivoFTPRetorno = class(TASPMTSObject, IArquivoFTPRetorno)
  private
    FCodArquivoFTPRetorno    : Integer;
    FCodRotinaFTPRetorno     : Integer;
    FDesRotinaFTPRetorno     : WideString;
    FNomArquivoLocal         : WideString;
    FNomArquivoRemoto        : WideString;
    FDtaCriacaoArquivo       : TDateTime;
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
    function Get_CodArquivoFTPRetorno: Integer; safecall;
    function Get_CodRotinaFTPRetorno: Integer; safecall;
    function Get_CodSituacaoArquivoFTP: Integer; safecall;
    function Get_CodTipoMensagem: Integer; safecall;
    function Get_DesRotinaFTPRetorno: WideString; safecall;
    function Get_DesSituacaoArquivoFTP: WideString; safecall;
    function Get_DesTipoMensagem: WideString; safecall;
    function Get_DtaCriacaoArquivo: TDateTime; safecall;
    function Get_DtaUltimaTransferencia: TDateTime; safecall;
    function Get_NomArquivoLocal: WideString; safecall;
    function Get_NomArquivoRemoto: WideString; safecall;
    function Get_QtdBytesArquivo: Integer; safecall;
    function Get_QtdDuracaoTransferencia: Integer; safecall;
    function Get_QtdVezesTransferencia: Integer; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodArquivoFTPRetorno(Value: Integer); safecall;
    procedure Set_CodRotinaFTPRetorno(Value: Integer); safecall;
    procedure Set_CodSituacaoArquivoFTP(Value: Integer); safecall;
    procedure Set_CodTipoMensagem(Value: Integer); safecall;
    procedure Set_DesRotinaFTPRetorno(const Value: WideString); safecall;
    procedure Set_DesSituacaoArquivoFTP(const Value: WideString); safecall;
    procedure Set_DesTipoMensagem(const Value: WideString); safecall;
    procedure Set_DtaCriacaoArquivo(Value: TDateTime); safecall;
    procedure Set_DtaUltimaTransferencia(Value: TDateTime); safecall;
    procedure Set_NomArquivoLocal(const Value: WideString); safecall;
    procedure Set_NomArquivoRemoto(const Value: WideString); safecall;
    procedure Set_QtdBytesArquivo(Value: Integer); safecall;
    procedure Set_QtdDuracaoTransferencia(Value: Integer); safecall;
    procedure Set_QtdVezesTransferencia(Value: Integer); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
    function Get_SglSituacaoArquivoFTP: WideString; safecall;
    procedure Set_SglSituacaoArquivoFTP(const Value: WideString); safecall;
  public
    property CodArquivoFTPRetorno    : Integer    read FCodArquivoFTPRetorno       write FCodArquivoFTPRetorno;
    property CodRotinaFTPRetorno     : Integer    read FCodRotinaFTPRetorno        write FCodRotinaFTPRetorno;
    property DesRotinaFTPRetorno     : WideString read FDesRotinaFTPRetorno        write FDesRotinaFTPRetorno;
    property NomArquivoLocal         : WideString read FNomArquivoLocal          write FNomArquivoLocal;
    property NomArquivoRemoto        : WideString read FNomArquivoRemoto         write FNomArquivoRemoto;
    property DtaCriacaoArquivo       : TDateTime  read FDtaCriacaoArquivo        write FDtaCriacaoArquivo;
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

function TArquivoFTPRetorno.Get_CodArquivoFTPRetorno: Integer;
begin
  Result := FCodArquivoFTPRetorno;
end;

function TArquivoFTPRetorno.Get_CodRotinaFTPRetorno: Integer;
begin
  Result := FCodRotinaFTPRetorno;
end;

function TArquivoFTPRetorno.Get_CodSituacaoArquivoFTP: Integer;
begin
  Result := FCodSituacaoArquivoFTP;
end;

function TArquivoFTPRetorno.Get_CodTipoMensagem: Integer;
begin
  Result := FCodTipoMensagem;
end;

function TArquivoFTPRetorno.Get_DesRotinaFTPRetorno: WideString;
begin
  Result := FDesRotinaFTPRetorno;
end;

function TArquivoFTPRetorno.Get_DesSituacaoArquivoFTP: WideString;
begin
  Result := FDesSituacaoArquivoFTP;
end;

function TArquivoFTPRetorno.Get_DtaUltimaTransferencia: TDateTime;
begin
  Result := FDtaUltimaTransferencia;
end;

function TArquivoFTPRetorno.Get_NomArquivoLocal: WideString;
begin
  Result := FNomArquivoLocal;
end;

function TArquivoFTPRetorno.Get_NomArquivoRemoto: WideString;
begin
  Result := FNomArquivoRemoto;
end;

function TArquivoFTPRetorno.Get_QtdBytesArquivo: Integer;
begin
  Result := FQtdBytesArquivo;
end;

function TArquivoFTPRetorno.Get_QtdDuracaoTransferencia: Integer;
begin
  Result := FQtdDuracaoTransferencia;
end;

function TArquivoFTPRetorno.Get_QtdVezesTransferencia: Integer;
begin
  Result := FQtdVezesTransferencia;
end;

function TArquivoFTPRetorno.Get_SglSituacaoArquivoFTP: WideString;
begin
  Result := FSglSituacaoArquivoFTP;
end;

function TArquivoFTPRetorno.Get_DtaCriacaoArquivo: TDateTime;
begin
  Result := FDtaCriacaoArquivo
end;

function TArquivoFTPRetorno.Get_TxtMensagem: WideString;
begin
  Result := FTxtMensagem;
end;

procedure TArquivoFTPRetorno.Set_CodArquivoFTPRetorno(Value: Integer);
begin
  FCodArquivoFTPRetorno := Value;
end;

procedure TArquivoFTPRetorno.Set_CodRotinaFTPRetorno(Value: Integer);
begin
  FCodRotinaFTPRetorno := Value;
end;

procedure TArquivoFTPRetorno.Set_CodSituacaoArquivoFTP(Value: Integer);
begin
  FCodSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPRetorno.Set_CodTipoMensagem(Value: Integer);
begin
  FCodTipoMensagem := Value;
end;

procedure TArquivoFTPRetorno.Set_DesRotinaFTPRetorno(const Value: WideString);
begin
  FDesRotinaFTPRetorno := Value;
end;

procedure TArquivoFTPRetorno.Set_DesSituacaoArquivoFTP(const Value: WideString);
begin
  FDesSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPRetorno.Set_DtaUltimaTransferencia(Value: TDateTime);
begin
  FDtaUltimaTransferencia := Value;
end;

procedure TArquivoFTPRetorno.Set_NomArquivoLocal(const Value: WideString);
begin
  FNomArquivoLocal := Value;
end;

procedure TArquivoFTPRetorno.Set_NomArquivoRemoto(const Value: WideString);
begin
  FNomArquivoRemoto := Value;
end;

procedure TArquivoFTPRetorno.Set_QtdBytesArquivo(Value: Integer);
begin
  FQtdBytesArquivo := Value;
end;

procedure TArquivoFTPRetorno.Set_QtdDuracaoTransferencia(Value: Integer);
begin
  FQtdDuracaoTransferencia := Value;
end;

procedure TArquivoFTPRetorno.Set_QtdVezesTransferencia(Value: Integer);
begin
  FQtdVezesTransferencia := Value;
end;

procedure TArquivoFTPRetorno.Set_SglSituacaoArquivoFTP(const Value: WideString);
begin
  FSglSituacaoArquivoFTP := Value;
end;

procedure TArquivoFTPRetorno.Set_DtaCriacaoArquivo(Value: TDateTime);
begin
  FDtaCriacaoArquivo := Value;
end;

procedure TArquivoFTPRetorno.Set_TxtMensagem(const Value: WideString);
begin
  FTxtMensagem := Value;
end;

function TArquivoFTPRetorno.Get_DesTipoMensagem: WideString;
begin
  Result := FDesTipoMensagem;
end;

procedure TArquivoFTPRetorno.Set_DesTipoMensagem(const Value: WideString);
begin
  FDesTipoMensagem := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivoFTPRetorno, Class_ArquivoFTPRetorno,
    ciMultiInstance, tmApartment);
end.
