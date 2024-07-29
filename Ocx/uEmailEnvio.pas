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

unit uEmailEnvio;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TEmailEnvio = class(TASPMTSObject, IEmailEnvio)
  private
    FCodEmailEnvio      : Integer;
    FCodTipoEmail       : Integer;
    FDesTipoEmail       : WideString;
    FTxtAssunto         : WideString;
    FTxtCorpoEmail      : WideString;
    FCodTipoMensagem    : Integer;
    FDesTipoMensagem    : WideString;
    FTxtMensagem        : WideString;
    FCodSituacaoEmail   : Integer;
    FSglSituacaoEmail   : WideString;
    FDesSituacaoEmail   : WideString;
    FDtaUltimoEnvio     : TDateTime;
    FQtdDuracaoEnvio    : Integer;
    FQtdVezesEnvio      : Integer;
  protected
    function Get_CodEmailEnvio: Integer; safecall;
    function Get_CodSituacaoEmail: Integer; safecall;
    function Get_CodTipoEmail: Integer; safecall;
    function Get_CodTipoMensagem: Integer; safecall;
    function Get_DesSituacaoEmail: WideString; safecall;
    function Get_DesTipoEmail: WideString; safecall;
    function Get_DesTipoMensagem: WideString; safecall;
    function Get_DtaUltimoEnvio: TDateTime; safecall;
    function Get_QtdVezesEnvio: Integer; safecall;
    function Get_SglSituacaoEmail: WideString; safecall;
    function Get_TxtAssunto: WideString; safecall;
    function Get_TxtCorpoEmail: WideString; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodEmailEnvio(Value: Integer); safecall;
    procedure Set_CodSituacaoEmail(Value: Integer); safecall;
    procedure Set_CodTipoEmail(Value: Integer); safecall;
    procedure Set_CodTipoMensagem(Value: Integer); safecall;
    procedure Set_DesSituacaoEmail(const Value: WideString); safecall;
    procedure Set_DesTipoEmail(const Value: WideString); safecall;
    procedure Set_DesTipoMensagem(const Value: WideString); safecall;
    procedure Set_DtaUltimoEnvio(Value: TDateTime); safecall;
    procedure Set_QtdVezesEnvio(Value: Integer); safecall;
    procedure Set_SglSituacaoEmail(const Value: WideString); safecall;
    procedure Set_TxtAssunto(const Value: WideString); safecall;
    procedure Set_TxtCorpoEmail(const Value: WideString); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
    function Get_QtdDuracaoEnvio: Integer; safecall;
    procedure Set_QtdDuracaoEnvio(Value: Integer); safecall;
  public
    property CodEmailEnvio    : Integer     read FCodEmailEnvio    write FCodEmailEnvio;
    property CodTipoEmail     : Integer     read FCodTipoEmail     write FCodTipoEmail;
    property DesTipoEmail     : WideString  read FDesTipoEmail     write FDesTipoEmail;
    property TxtAssunto       : WideString  read FTxtAssunto       write FTxtAssunto;
    property TxtCorpoEmail    : WideString  read FTxtCorpoEmail    write FTxtCorpoEmail;
    property CodTipoMensagem  : Integer     read FCodTipoMensagem  write FCodTipoMensagem;
    property DesTipoMensagem  : WideString  read FDesTipoMensagem  write FDesTipoMensagem;
    property TxtMensagem      : WideString  read FTxtMensagem      write FTxtMensagem;
    property CodSituacaoEmail : Integer     read FCodSituacaoEmail write FCodSituacaoEmail;
    property SglSituacaoEmail : WideString  read FSglSituacaoEmail write FSglSituacaoEmail;
    property DesSituacaoEmail : WideString  read FDesSituacaoEmail write FDesSituacaoEmail;
    property DtaUltimoEnvio   : TDateTime   read FDtaUltimoEnvio   write FDtaUltimoEnvio;
    property QtdDuracaoEnvio  : Integer     read FQtdDuracaoEnvio  write FQtdDuracaoEnvio;
    property QtdVezesEnvio    : Integer     read FQtdVezesEnvio    write FQtdVezesEnvio;
  end;

implementation

uses ComServ;

function TEmailEnvio.Get_CodEmailEnvio: Integer;
begin
  Result := FCodEmailEnvio;
end;

function TEmailEnvio.Get_CodSituacaoEmail: Integer;
begin
  Result := FCodSituacaoEmail;
end;

function TEmailEnvio.Get_CodTipoEmail: Integer;
begin
  Result := FCodTipoEmail;
end;

function TEmailEnvio.Get_CodTipoMensagem: Integer;
begin
  Result := FCodTipoMensagem;
end;

function TEmailEnvio.Get_DesSituacaoEmail: WideString;
begin
  Result := FDesSituacaoEmail;
end;

function TEmailEnvio.Get_DesTipoEmail: WideString;
begin
  Result := FDesTipoEmail;
end;

function TEmailEnvio.Get_DesTipoMensagem: WideString;
begin
  Result := FDesTipoMensagem;
end;

function TEmailEnvio.Get_DtaUltimoEnvio: TDateTime;
begin
  Result := FDtaUltimoEnvio;
end;

function TEmailEnvio.Get_QtdVezesEnvio: Integer;
begin
  Result := FQtdVezesEnvio;
end;

function TEmailEnvio.Get_SglSituacaoEmail: WideString;
begin
  Result := FSglSituacaoEmail;
end;

function TEmailEnvio.Get_TxtAssunto: WideString;
begin
  Result := FTxtAssunto;
end;

function TEmailEnvio.Get_TxtCorpoEmail: WideString;
begin
  Result := FTxtCorpoEmail;
end;

function TEmailEnvio.Get_TxtMensagem: WideString;
begin
  Result := FTxtMensagem;
end;

procedure TEmailEnvio.Set_CodEmailEnvio(Value: Integer);
begin
  FCodEmailEnvio := Value;
end;

procedure TEmailEnvio.Set_CodSituacaoEmail(Value: Integer);
begin
  FCodSituacaoEmail := Value;
end;

procedure TEmailEnvio.Set_CodTipoEmail(Value: Integer);
begin
  FCodTipoEmail := Value;
end;

procedure TEmailEnvio.Set_CodTipoMensagem(Value: Integer);
begin
  FCodTipoMensagem := Value;
end;

procedure TEmailEnvio.Set_DesSituacaoEmail(const Value: WideString);
begin
  FDesSituacaoEmail := Value;
end;

procedure TEmailEnvio.Set_DesTipoEmail(const Value: WideString);
begin
  FDesTipoEmail := Value;
end;

procedure TEmailEnvio.Set_DesTipoMensagem(const Value: WideString);
begin
  FDesTipoMensagem := Value;
end;

procedure TEmailEnvio.Set_DtaUltimoEnvio(Value: TDateTime);
begin
  FDtaUltimoEnvio := Value;
end;

procedure TEmailEnvio.Set_QtdVezesEnvio(Value: Integer);
begin
  FQtdVezesEnvio := Value;
end;

procedure TEmailEnvio.Set_SglSituacaoEmail(const Value: WideString);
begin
  FSglSituacaoEmail := Value;
end;

procedure TEmailEnvio.Set_TxtAssunto(const Value: WideString);
begin
  FTxtAssunto := Value;
end;

procedure TEmailEnvio.Set_TxtCorpoEmail(const Value: WideString);
begin
  FTxtCorpoEmail := Value;
end;

procedure TEmailEnvio.Set_TxtMensagem(const Value: WideString);
begin
  FTxtMensagem := Value;
end;

function TEmailEnvio.Get_QtdDuracaoEnvio: Integer;
begin
  Result := FQtdDuracaoEnvio;
end;

procedure TEmailEnvio.Set_QtdDuracaoEnvio(Value: Integer);
begin
  FQtdDuracaoEnvio := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEmailEnvio, Class_EmailEnvio,
    ciMultiInstance, tmApartment);
end.
