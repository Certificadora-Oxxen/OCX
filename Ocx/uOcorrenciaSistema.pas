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

unit uOcorrenciaSistema;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TOcorrenciaSistema = class(TASPMTSObject, IOcorrenciaSistema)
  private
    FCodOcorrenciaSistema    : Integer;
    FDtaOcorrenciaSistema    : TDateTime;
    FIndOcorrenciaTratada    : WideString;
    FCodAplicativo           : Integer;
    FNomAplicativo           : WideString;
    FCodTipoMensagem         : Integer;
    FDesTipoMensagem         : WideString;
    FTxtMensagem             : WideString;
    FTxtIdentificacao        : WideString;
    FTxtLegendaIdentificacao : WideString;
  protected
    function Get_CodAplicativo: Integer; safecall;
    function Get_CodOcorrenciaSistema: Integer; safecall;
    function Get_CodTipoMensagem: Integer; safecall;
    function Get_DesTipoMensagem: WideString; safecall;
    function Get_DtaOcorrenciaSistema: TDateTime; safecall;
    function Get_IndOcorrenciaTratada: WideString; safecall;
    function Get_NomAplicativo: WideString; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodAplicativo(Value: Integer); safecall;
    procedure Set_CodOcorrenciaSistema(Value: Integer); safecall;
    procedure Set_CodTipoMensagem(Value: Integer); safecall;
    procedure Set_DesTipoMensagem(const Value: WideString); safecall;
    procedure Set_DtaOcorrenciaSistema(Value: TDateTime); safecall;
    procedure Set_IndOcorrenciaTratada(const Value: WideString); safecall;
    procedure Set_NomAplicativo(const Value: WideString); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
    function Get_TxtIdentificacao: WideString; safecall;
    function Get_TxtLegendaIdentificacao: WideString; safecall;
    procedure Set_TxtIdentificacao(const Value: WideString); safecall;
    procedure Set_TxtLegendaIdentificacao(const Value: WideString); safecall;
  public
    property CodOcorrenciaSistema    : Integer     read FCodOcorrenciaSistema    write FCodOcorrenciaSistema;
    property DtaOcorrenciaSistema    : TDateTime   read FDtaOcorrenciaSistema    write FDtaOcorrenciaSistema;
    property IndOcorrenciaTratada    : WideString  read FIndOcorrenciaTratada    write FIndOcorrenciaTratada;
    property CodAplicativo           : Integer     read FCodAplicativo           write FCodAplicativo;
    property NomAplicativo           : WideString  read FNomAplicativo           write FNomAplicativo;
    property CodTipoMensagem         : Integer     read FCodTipoMensagem         write FCodTipoMensagem;
    property DesTipoMensagem         : WideString  read FDesTipoMensagem         write FDesTipoMensagem;
    property TxtMensagem             : WideString  read FTxtMensagem             write FTxtMensagem;
    property TxtIdentificacao        : WideString  read FTxtIdentificacao        write FTxtIdentificacao;
    property TxtLegendaIdentificacao : WideString  read FTxtLegendaIdentificacao write FTxtLegendaIdentificacao;
  end;

implementation

uses ComServ;

function TOcorrenciaSistema.Get_CodAplicativo: Integer;
begin
  Result := FCodAplicativo;
end;

function TOcorrenciaSistema.Get_CodOcorrenciaSistema: Integer;
begin
  Result := FCodOcorrenciaSistema;
end;

function TOcorrenciaSistema.Get_CodTipoMensagem: Integer;
begin
  Result := FCodTipoMensagem;
end;

function TOcorrenciaSistema.Get_DesTipoMensagem: WideString;
begin
  Result := FDesTipoMensagem;
end;

function TOcorrenciaSistema.Get_DtaOcorrenciaSistema: TDateTime;
begin
  Result := FDtaOcorrenciaSistema;
end;

function TOcorrenciaSistema.Get_IndOcorrenciaTratada: WideString;
begin
  Result := FIndOcorrenciaTratada;
end;

function TOcorrenciaSistema.Get_NomAplicativo: WideString;
begin
  Result := FNomAplicativo;
end;

function TOcorrenciaSistema.Get_TxtMensagem: WideString;
begin
  Result := FTxtMensagem;
end;

function TOcorrenciaSistema.Get_TxtIdentificacao: WideString;
begin
  Result := FTxtIdentificacao;
end;

function TOcorrenciaSistema.Get_TxtLegendaIdentificacao: WideString;
begin
  Result := FTxtLegendaIdentificacao;
end;

procedure TOcorrenciaSistema.Set_CodAplicativo(Value: Integer);
begin
  FCodAplicativo := Value;
end;

procedure TOcorrenciaSistema.Set_CodOcorrenciaSistema(Value: Integer);
begin
  FCodOcorrenciaSistema := Value;
end;

procedure TOcorrenciaSistema.Set_CodTipoMensagem(Value: Integer);
begin
  FCodTipoMensagem := Value;
end;

procedure TOcorrenciaSistema.Set_DesTipoMensagem(const Value: WideString);
begin
  FDesTipoMensagem := Value;
end;

procedure TOcorrenciaSistema.Set_DtaOcorrenciaSistema(Value: TDateTime);
begin
  FDtaOcorrenciaSistema := Value;
end;

procedure TOcorrenciaSistema.Set_IndOcorrenciaTratada(const Value: WideString);
begin
  FIndOcorrenciaTratada := Value;
end;

procedure TOcorrenciaSistema.Set_NomAplicativo(const Value: WideString);
begin
  FNomAplicativo := Value;
end;

procedure TOcorrenciaSistema.Set_TxtMensagem(const Value: WideString);
begin
  FTxtMensagem := Value;
end;

procedure TOcorrenciaSistema.Set_TxtIdentificacao(const Value: WideString);
begin
  FTxtIdentificacao := Value;
end;

procedure TOcorrenciaSistema.Set_TxtLegendaIdentificacao(
  const Value: WideString);
begin
  FTxtLegendaIdentificacao := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOcorrenciaSistema, Class_OcorrenciaSistema,
    ciMultiInstance, tmApartment);
end.
