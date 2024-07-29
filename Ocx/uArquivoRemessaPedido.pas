// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 103
// *  Descrição Resumida : Armazena os atributos de um arquivo de remessa de pedidos
// *                       de identificadores gerado no sistema.
// ************************************************************************
// *  Últimas Alterações :
// *
// ********************************************************************
unit uArquivoRemessaPedido;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TArquivoRemessaPedido = class(TASPMTSObject, IArquivoRemessaPedido)
  private
    FCodArquivoFTPEnvio: Integer;
    FCodArquivoRemessaPedido: Integer;
    FCodEmailEnvio: Integer;
    FCodFabricanteIdentificador: Integer;
    FCodSituacaoArquivoFTP: Integer;
    FCodSituacaoEmail: Integer;
    FDesSituacaoEmail: WideString;
    FDtaCriacaoArquivo: TDateTime;
    FDtaUltimaTransferencia: TDateTime;
    FDtaUltimoEnvio: TDateTime;
    FIndEnvioPedidoEmail: WideString;
    FIndEnvioPedidoFTP: WideString;
    FNomArquivoRemessaPedido: WideString;
    FNomArquivoFichaPedido: WideString;    
    FNomReduzidoFabricante: WideString;
    FNumRemessaFabricante: Integer;
    FQtdBytesArquivoRemessa: Integer;
    FQtdBytesArquivoFicha: Integer;
    FSglSituacaoArquivoFTP: WideString;
    FSglSituacaoEmail: WideString;
    FDesSituacaoArquivoFTP: WideString;
    FNumPedidoFabricanteInicio: Integer;
    FQtdPedidosRemessa: Integer;
    FCodUsuarioCriacao: Integer;
    FNomUsuarioCriacao: WideString;
    FTxtCaminho: WideString;
    FCodTipoArquivoRemessa: Integer;
    FDesTipoArquivoRemessa: WideString;
  protected
    function Get_CodArquivoRemessaPedido: Integer; safecall;
    function Get_CodEmailEnvio: Integer; safecall;
    function Get_CodFabricanteIdentificador: Integer; safecall;
    function Get_CodSituacaoEmail: Integer; safecall;
    function Get_DtaCriacaoArquivo: TDateTime; safecall;
    function Get_DtaUltimoEnvio: TDateTime; safecall;
    function Get_IndEnvioPedidoEmail: WideString; safecall;
    function Get_NomArquivoRemessaPedido: WideString; safecall;
    function Get_NomReduzidoFabricante: WideString; safecall;
    function Get_NumRemessaFabricante: Integer; safecall;
    function Get_QtdBytesArquivoRemessa: Integer; safecall;
    procedure Set_CodArquivoRemessaPedido(Value: Integer); safecall;
    procedure Set_CodEmailEnvio(Value: Integer); safecall;
    procedure Set_CodFabricanteIdentificador(Value: Integer); safecall;
    procedure Set_CodSituacaoEmail(Value: Integer); safecall;
    procedure Set_DtaCriacaoArquivo(Value: TDateTime); safecall;
    procedure Set_DtaUltimoEnvio(Value: TDateTime); safecall;
    procedure Set_IndEnvioPedidoEmail(const Value: WideString); safecall;
    procedure Set_NomArquivoRemessaPedido(const Value: WideString); safecall;
    procedure Set_NomReduzidoFabricante(const Value: WideString); safecall;
    procedure Set_NumRemessaFabricante(Value: Integer); safecall;
    procedure Set_QtdBytesArquivoRemessa(Value: Integer); safecall;
    function Get_CodArquivoFTPEnvio: Integer; safecall;
    function Get_CodSituacaoArquivoFTP: Integer; safecall;
    function Get_DesSituacaoArquivoFTP: WideString; safecall;
    function Get_DesSituacaoEmail: WideString; safecall;
    function Get_DtaUltimaTransferencia: TDateTime; safecall;
    function Get_IndEnvioPedidoFTP: WideString; safecall;
    function Get_SglSituacaoArquivoFTP: WideString; safecall;
    function Get_SglSituacaoEmail: WideString; safecall;
    procedure Set_CodArquivoFTPEnvio(Value: Integer); safecall;
    procedure Set_CodSituacaoArquivoFTP(Value: Integer); safecall;
    procedure Set_DesSituacaoArquivoFTP(const Value: WideString); safecall;
    procedure Set_DesSituacaoEmail(const Value: WideString); safecall;
    procedure Set_DtaUltimaTransferencia(Value: TDateTime); safecall;
    procedure Set_IndEnvioPedidoFTP(const Value: WideString); safecall;
    procedure Set_SglSituacaoArquivoFTP(const Value: WideString); safecall;
    procedure Set_SglSituacaoEmail(const Value: WideString); safecall;
    function Get_CodUsuarioCriacao: Integer; safecall;
    function Get_NomUsuarioCriacao: WideString; safecall;
    function Get_NumPedidoFabricanteInicio: Integer; safecall;
    function Get_QtdPedidosRemessa: Integer; safecall;
    procedure Set_CodUsuarioCriacao(Value: Integer); safecall;
    procedure Set_NomUsuarioCriacao(const Value: WideString); safecall;
    procedure Set_NumPedidoFabricanteInicio(Value: Integer); safecall;
    procedure Set_QtdPedidosRemessa(Value: Integer); safecall;
    function Get_NomArquivoFichaPedido: WideString; safecall;
    function Get_QtdBytesArquivoFicha: Integer; safecall;
    procedure Set_NomArquivoFichaPedido(const Value: WideString); safecall;
    procedure Set_QtdBytesArquivoFicha(Value: Integer); safecall;
    function Get_CodTipoArquivoRemessa: Integer; safecall;
    function Get_DesTipoArquivoRemessa: WideString; safecall;
    function Get_TxtCaminho: WideString; safecall;
    procedure Set_CodTipoArquivoRemessa(Value: Integer); safecall;
    procedure Set_DesTipoArquivoRemessa(const Value: WideString); safecall;
    procedure Set_TxtCaminho(const Value: WideString); safecall;
  public
    property CodArquivoFTPEnvio: Integer read FCodArquivoFTPEnvio write FCodArquivoFTPEnvio;
    property CodArquivoRemessaPedido: Integer read FCodArquivoRemessaPedido write FCodArquivoRemessaPedido;
    property CodEmailEnvio: Integer read FCodEmailEnvio write FCodEmailEnvio;
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodSituacaoArquivoFTP: Integer read FCodSituacaoArquivoFTP write FCodSituacaoArquivoFTP;
    property CodSituacaoEmail: Integer read FCodSituacaoEmail write FCodSituacaoEmail;
    property DesSituacaoEmail: WideString read FDesSituacaoEmail write FDesSituacaoEmail;
    property DtaCriacaoArquivo: TDateTime read FDtaCriacaoArquivo write FDtaCriacaoArquivo;
    property DtaUltimaTransferencia: TDateTime read FDtaUltimaTransferencia write FDtaUltimaTransferencia;
    property DtaUltimoEnvio: TDateTime read FDtaUltimoEnvio write FDtaUltimoEnvio;
    property IndEnvioPedidoEmail: WideString read FIndEnvioPedidoEmail write FIndEnvioPedidoEmail;
    property IndEnvioPedidoFTP: WideString read FIndEnvioPedidoFTP write FIndEnvioPedidoFTP;
    property NomArquivoRemessaPedido: WideString read FNomArquivoRemessaPedido write FNomArquivoRemessaPedido;
    property NomArquivoFichaPedido: WideString read FNomArquivoFichaPedido write FNomArquivoFichaPedido;
    property NomReduzidoFabricante: WideString read FNomReduzidoFabricante write FNomReduzidoFabricante;
    property NumRemessaFabricante: Integer read FNumRemessaFabricante write FNumRemessaFabricante;
    property QtdBytesArquivoRemessa: Integer read FQtdBytesArquivoRemessa write FQtdBytesArquivoRemessa;
    property QtdBytesArquivoFicha: Integer read FQtdBytesArquivoFicha write FQtdBytesArquivoFicha;
    property SglSituacaoArquivoFTP: WideString read FSglSituacaoArquivoFTP write FSglSituacaoArquivoFTP;
    property SglSituacaoEmail: WideString read FSglSituacaoEmail write FSglSituacaoEmail;
    property DesSituacaoArquivoFTP: WideString read FDesSituacaoArquivoFTP write FDesSituacaoArquivoFTP;
    property NumPedidoFabricanteInicio: Integer read FNumPedidoFabricanteInicio write FNumPedidoFabricanteInicio;
    property QtdPedidosRemessa: Integer read FQtdPedidosRemessa write FQtdPedidosRemessa;
    property CodUsuarioCriacao: Integer read FCodUsuarioCriacao write FCodUsuarioCriacao;
    property NomUsuarioCriacao: WideString read FNomUsuarioCriacao write FNomUsuarioCriacao;
    property TxtCaminho: WideString read FTxtCaminho write FTxtCaminho;
    property CodTipoArquivoRemessa: Integer read FCodTipoArquivoRemessa write FCodTipoArquivoRemessa;
    property DesTipoArquivoRemessa: WideString read FDesTipoArquivoRemessa write FDesTipoArquivoRemessa;
  end;

implementation

uses ComServ;

function TArquivoRemessaPedido.Get_CodArquivoFTPEnvio: Integer;
begin
   Result := FCodArquivoFTPEnvio;
end;

function TArquivoRemessaPedido.Get_CodArquivoRemessaPedido: Integer;
begin
   Result := FCodArquivoRemessaPedido;
end;

function TArquivoRemessaPedido.Get_CodEmailEnvio: Integer;
begin
   Result := FCodEmailEnvio;
end;

function TArquivoRemessaPedido.Get_CodFabricanteIdentificador: Integer;
begin
   Result := FCodFabricanteIdentificador;
end;

function TArquivoRemessaPedido.Get_CodSituacaoArquivoFTP: Integer;
begin
   Result := FCodSituacaoArquivoFTP;
end;

function TArquivoRemessaPedido.Get_CodSituacaoEmail: Integer;
begin
   Result := FCodSituacaoEmail;
end;

function TArquivoRemessaPedido.Get_DesSituacaoEmail: WideString;
begin
   Result := FDesSituacaoEmail;
end;

function TArquivoRemessaPedido.Get_DtaCriacaoArquivo: TDateTime;
begin
   Result := FDtaCriacaoArquivo;
end;

function TArquivoRemessaPedido.Get_DtaUltimaTransferencia: TDateTime;
begin
   Result := FDtaUltimaTransferencia;
end;

function TArquivoRemessaPedido.Get_DtaUltimoEnvio: TDateTime;
begin
   Result := FDtaUltimoEnvio;
end;

function TArquivoRemessaPedido.Get_IndEnvioPedidoEmail: WideString;
begin
   Result := FIndEnvioPedidoEmail;
end;

function TArquivoRemessaPedido.Get_IndEnvioPedidoFTP: WideString;
begin
   Result := FIndEnvioPedidoFTP;
end;

function TArquivoRemessaPedido.Get_NomArquivoRemessaPedido: WideString;
begin
   Result := FNomArquivoRemessaPedido;
end;

function TArquivoRemessaPedido.Get_NomReduzidoFabricante: WideString;
begin
   Result := FNomReduzidoFabricante;
end;

function TArquivoRemessaPedido.Get_NumRemessaFabricante: Integer;
begin
   Result := FNumRemessaFabricante;
end;

function TArquivoRemessaPedido.Get_QtdBytesArquivoRemessa: Integer;
begin
   Result := FQtdBytesArquivoRemessa;
end;

function TArquivoRemessaPedido.Get_SglSituacaoArquivoFTP: WideString;
begin
   Result := FSglSituacaoArquivoFTP;
end;

function TArquivoRemessaPedido.Get_SglSituacaoEmail: WideString;
begin
   Result := FSglSituacaoEmail;
end;

procedure TArquivoRemessaPedido.Set_CodArquivoFTPEnvio(Value: Integer);
begin
  FCodArquivoFTPEnvio := Value;
end;

procedure TArquivoRemessaPedido.Set_CodArquivoRemessaPedido(
  Value: Integer);
begin
  FCodArquivoRemessaPedido := Value;
end;

procedure TArquivoRemessaPedido.Set_CodEmailEnvio(Value: Integer);
begin
  FCodEmailEnvio := Value;
end;

procedure TArquivoRemessaPedido.Set_CodFabricanteIdentificador(
  Value: Integer);
begin
  FCodFabricanteIdentificador := Value;
end;

procedure TArquivoRemessaPedido.Set_CodSituacaoArquivoFTP(Value: Integer);
begin
  FCodSituacaoArquivoFTP := Value;
end;

procedure TArquivoRemessaPedido.Set_CodSituacaoEmail(Value: Integer);
begin
  FCodSituacaoEmail := Value;
end;

procedure TArquivoRemessaPedido.Set_DesSituacaoEmail(
  const Value: WideString);
begin
  FDesSituacaoEmail := Value;
end;

procedure TArquivoRemessaPedido.Set_DtaCriacaoArquivo(Value: TDateTime);
begin
  FDtaCriacaoArquivo := Value;
end;

procedure TArquivoRemessaPedido.Set_DtaUltimaTransferencia(
  Value: TDateTime);
begin
  FDtaUltimaTransferencia := Value;
end;

procedure TArquivoRemessaPedido.Set_DtaUltimoEnvio(Value: TDateTime);
begin
  FDtaUltimoEnvio := Value;
end;

procedure TArquivoRemessaPedido.Set_IndEnvioPedidoEmail(
  const Value: WideString);
begin
  FIndEnvioPedidoEmail := Value;
end;

procedure TArquivoRemessaPedido.Set_IndEnvioPedidoFTP(
  const Value: WideString);
begin
  FIndEnvioPedidoFTP := Value;
end;

procedure TArquivoRemessaPedido.Set_NomArquivoRemessaPedido(
  const Value: WideString);
begin
  FNomArquivoRemessaPedido := Value;
end;

procedure TArquivoRemessaPedido.Set_NomReduzidoFabricante(
  const Value: WideString);
begin
  FNomReduzidoFabricante := Value;
end;

procedure TArquivoRemessaPedido.Set_NumRemessaFabricante(Value: Integer);
begin
  FNumRemessaFabricante := Value;
end;

procedure TArquivoRemessaPedido.Set_QtdBytesArquivoRemessa(Value: Integer);
begin
  FQtdBytesArquivoRemessa := Value;
end;

procedure TArquivoRemessaPedido.Set_SglSituacaoArquivoFTP(
  const Value: WideString);
begin
  FSglSituacaoArquivoFTP := Value;
end;

procedure TArquivoRemessaPedido.Set_SglSituacaoEmail(
  const Value: WideString);
begin
  FSglSituacaoEmail := Value;
end;

function TArquivoRemessaPedido.Get_DesSituacaoArquivoFTP: WideString;
begin
  Result := FDesSituacaoArquivoFTP;
end;

procedure TArquivoRemessaPedido.Set_DesSituacaoArquivoFTP(
  const Value: WideString);
begin
  FDesSituacaoArquivoFTP := Value;
end;

function TArquivoRemessaPedido.Get_CodUsuarioCriacao: Integer;
begin
  Result := FCodUsuarioCriacao;
end;

function TArquivoRemessaPedido.Get_NomUsuarioCriacao: WideString;
begin
  Result := FNomUsuarioCriacao;
end;

function TArquivoRemessaPedido.Get_NumPedidoFabricanteInicio: Integer;
begin
  Result := FNumPedidoFabricanteInicio;
end;

function TArquivoRemessaPedido.Get_QtdPedidosRemessa: Integer;
begin
  Result := FQtdPedidosRemessa;
end;

procedure TArquivoRemessaPedido.Set_CodUsuarioCriacao(Value: Integer);
begin
 FCodUsuarioCriacao := Value;
end;

procedure TArquivoRemessaPedido.Set_NomUsuarioCriacao(
  const Value: WideString);
begin
 FNomUsuarioCriacao := Value;
end;

procedure TArquivoRemessaPedido.Set_NumPedidoFabricanteInicio(
  Value: Integer);
begin
 FNumPedidoFabricanteInicio := Value;
end;

procedure TArquivoRemessaPedido.Set_QtdPedidosRemessa(Value: Integer);
begin
 FQtdPedidosRemessa := Value;
end;

function TArquivoRemessaPedido.Get_NomArquivoFichaPedido: WideString;
begin
 Result := FNomArquivoFichaPedido;
end;

function TArquivoRemessaPedido.Get_QtdBytesArquivoFicha: Integer;
begin
 Result := FQtdBytesArquivoFicha;
end;

procedure TArquivoRemessaPedido.Set_NomArquivoFichaPedido(
  const Value: WideString);
begin
 FNomArquivoFichaPedido := Value;
end;

procedure TArquivoRemessaPedido.Set_QtdBytesArquivoFicha(Value: Integer);
begin
 FQtdBytesArquivoFicha := Value;
end;

function TArquivoRemessaPedido.Get_CodTipoArquivoRemessa: Integer;
begin
 Result := FCodTipoArquivoRemessa;
end;

function TArquivoRemessaPedido.Get_DesTipoArquivoRemessa: WideString;
begin
 Result := FDesTipoArquivoRemessa;
end;

function TArquivoRemessaPedido.Get_TxtCaminho: WideString;
begin
 Result := FTxtCaminho;
end;

procedure TArquivoRemessaPedido.Set_CodTipoArquivoRemessa(Value: Integer);
begin
 FCodTipoArquivoRemessa := Value;
end;

procedure TArquivoRemessaPedido.Set_DesTipoArquivoRemessa(
  const Value: WideString);
begin
 FDesTipoArquivoRemessa := Value;
end;

procedure TArquivoRemessaPedido.Set_TxtCaminho(const Value: WideString);
begin
 FTxtCaminho := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivoRemessaPedido, Class_ArquivoRemessaPedido,
    ciMultiInstance, tmApartment);
end.
