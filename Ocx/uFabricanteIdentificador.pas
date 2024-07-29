// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 99
// *  Descrição Resumida : Fornece todas as operações a serem realizadas com a entidade que representa
// *                       um fabricante de identificadores.
// ************************************************************************
// *  Últimas Alterações :
// *
// ********************************************************************
unit uFabricanteIdentificador;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TFabricanteIdentificador = class(TASPMTSObject, IFabricanteIdentificador)
  private
    FCodFabricanteIdentificador: Integer;
    FCodRotinaFTPEnvio: Integer;
    FCodRotinaFTPRetorno: Integer;
    FDesRotinaFTPEnvio: WideString;
    FDesRotinaFTPRetorno: WideString;
    FIndEnvioPedidoEmail: WideString;
    FIndEnvioPedidoFTP: WideString;
    FIndRetornoSituacaoFTP: WideString;
    FNomFabricanteIdentificador: WideString;
    FNomReduzidoFabricante: WideString;
    FNumCNPJFabricante: WideString;
    FNumCNPJFabricanteFormatado: WideString;
    FNumMaximoPedido: Integer;
    FNumOrdem: Integer;
    FNumUltimaRemessa: Integer;
    FNumUltimoPedido: Integer;
    FTxtEmailFabricante: WideString;
  protected
    function Get_CodFabricanteIdentificador: Integer; safecall;
    function Get_CodRotinaFTPEnvio: Integer; safecall;
    function Get_CodRotinaFTPRetorno: Integer; safecall;
    function Get_DesRotinaFTPEnvio: WideString; safecall;
    function Get_DesRotinaFTPRetorno: WideString; safecall;
    function Get_IndEnvioPedidoEmail: WideString; safecall;
    function Get_IndEnvioPedidoFTP: WideString; safecall;
    function Get_IndRetornoSituacaoFTP: WideString; safecall;
    function Get_NomFabricanteIdentificador: WideString; safecall;
    function Get_NomReduzidoFabricante: WideString; safecall;
    function Get_NumCNPJFabricante: WideString; safecall;
    function Get_NumCNPJFabricanteFormatado: WideString; safecall;
    function Get_NumMaximoPedido: Integer; safecall;
    function Get_NumOrdem: Integer; safecall;
    function Get_NumUltimaRemessa: Integer; safecall;
    function Get_NumUltimoPedido: Integer; safecall;
    function Get_TxtEmailFabricante: WideString; safecall;
    procedure Set_CodFabricanteIdentificador(Value: Integer); safecall;
    procedure Set_CodRotinaFTPEnvio(Value: Integer); safecall;
    procedure Set_CodRotinaFTPRetorno(Value: Integer); safecall;
    procedure Set_DesRotinaFTPEnvio(const Value: WideString); safecall;
    procedure Set_DesRotinaFTPRetorno(const Value: WideString); safecall;
    procedure Set_IndEnvioPedidoEmail(const Value: WideString); safecall;
    procedure Set_IndEnvioPedidoFTP(const Value: WideString); safecall;
    procedure Set_IndRetornoSituacaoFTP(const Value: WideString); safecall;
    procedure Set_NomFabricanteIdentificador(const Value: WideString);
      safecall;
    procedure Set_NomReduzidoFabricante(const Value: WideString); safecall;
    procedure Set_NumCNPJFabricante(const Value: WideString); safecall;
    procedure Set_NumCNPJFabricanteFormatado(const Value: WideString);
      safecall;
    procedure Set_NumMaximoPedido(Value: Integer); safecall;
    procedure Set_NumOrdem(Value: Integer); safecall;
    procedure Set_NumUltimaRemessa(Value: Integer); safecall;
    procedure Set_NumUltimoPedido(Value: Integer); safecall;
    procedure Set_TxtEmailFabricante(const Value: WideString); safecall;
  public
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodRotinaFTPEnvio: Integer read FCodRotinaFTPEnvio write FCodRotinaFTPEnvio;
    property CodRotinaFTPRetorno: Integer read FCodRotinaFTPRetorno write FCodRotinaFTPRetorno;
    property DesRotinaFTPEnvio: WideString read FDesRotinaFTPEnvio write FDesRotinaFTPEnvio;
    property DesRotinaFTPRetorno: WideString read FDesRotinaFTPRetorno write FDesRotinaFTPRetorno;
    property IndEnvioPedidoEmail: WideString read FIndEnvioPedidoEmail write FIndEnvioPedidoEmail;
    property IndEnvioPedidoFTP: WideString  read FIndEnvioPedidoFTP write FIndEnvioPedidoFTP;
    property IndRetornoSituacaoFTP: WideString read FIndRetornoSituacaoFTP write FIndRetornoSituacaoFTP;
    property NomFabricanteIdentificador: WideString read FNomFabricanteIdentificador write FNomFabricanteIdentificador;
    property NomReduzidoFabricante: WideString read FNomReduzidoFabricante  write FNomReduzidoFabricante;
    property NumCNPJFabricante: WideString  read FNumCNPJFabricante write FNumCNPJFabricante;
    property NumCNPJFabricanteFormatado: WideString read FNumCNPJFabricanteFormatado write FNumCNPJFabricanteFormatado;
    property NumMaximoPedido: Integer read FNumMaximoPedido write FNumMaximoPedido;
    property NumOrdem: Integer read FNumOrdem write FNumOrdem;
    property NumUltimaRemessa: Integer read FNumUltimaRemessa write FNumUltimaRemessa;
    property NumUltimoPedido: Integer read FNumUltimoPedido  write FNumUltimoPedido;
    property TxtEmailFabricante: WideString  read FTxtEmailFabricante write FTxtEmailFabricante;
  end;

implementation

uses ComServ;

function TFabricanteIdentificador.Get_CodFabricanteIdentificador: Integer;
begin
  Result := FCodFabricanteIdentificador;
end;

function TFabricanteIdentificador.Get_CodRotinaFTPEnvio: Integer;
begin
  Result := FCodRotinaFTPEnvio;
end;

function TFabricanteIdentificador.Get_CodRotinaFTPRetorno: Integer;
begin
  Result :=  FCodRotinaFTPRetorno;
end;

function TFabricanteIdentificador.Get_DesRotinaFTPEnvio: WideString;
begin
  Result :=  FDesRotinaFTPEnvio;
end;

function TFabricanteIdentificador.Get_DesRotinaFTPRetorno: WideString;
begin
  Result :=  FDesRotinaFTPRetorno;
end;

function TFabricanteIdentificador.Get_IndEnvioPedidoEmail: WideString;
begin
  Result :=  FIndEnvioPedidoEmail;
end;

function TFabricanteIdentificador.Get_IndEnvioPedidoFTP: WideString;
begin
  Result :=  FIndEnvioPedidoFTP;
end;

function TFabricanteIdentificador.Get_IndRetornoSituacaoFTP: WideString;
begin
  Result :=  FIndRetornoSituacaoFTP;
end;

function TFabricanteIdentificador.Get_NomFabricanteIdentificador: WideString;
begin
  Result :=  FNomFabricanteIdentificador;
end;

function TFabricanteIdentificador.Get_NomReduzidoFabricante: WideString;
begin
  Result :=  FNomReduzidoFabricante;
end;

function TFabricanteIdentificador.Get_NumCNPJFabricante: WideString;
begin
  Result :=  FNumCNPJFabricante;
end;

function TFabricanteIdentificador.Get_NumCNPJFabricanteFormatado: WideString;
begin
  Result :=  FNumCNPJFabricanteFormatado;
end;

function TFabricanteIdentificador.Get_NumMaximoPedido: Integer;
begin
  Result :=  FNumMaximoPedido;
end;

function TFabricanteIdentificador.Get_NumOrdem: Integer;
begin
  Result :=  FNumOrdem;
end;

function TFabricanteIdentificador.Get_NumUltimaRemessa: Integer;
begin
  Result :=  FNumUltimaRemessa;
end;

function TFabricanteIdentificador.Get_NumUltimoPedido: Integer;
begin
  Result :=  FNumUltimoPedido;
end;

function TFabricanteIdentificador.Get_TxtEmailFabricante: WideString;
begin
  Result :=  FTxtEmailFabricante;
end;

procedure TFabricanteIdentificador.Set_CodFabricanteIdentificador(
  Value: Integer);
begin
  FCodFabricanteIdentificador := value;
end;

procedure TFabricanteIdentificador.Set_CodRotinaFTPEnvio(Value: Integer);
begin
  FCodRotinaFTPEnvio := value;
end;

procedure TFabricanteIdentificador.Set_CodRotinaFTPRetorno(Value: Integer);
begin
  FCodRotinaFTPRetorno := value;
end;

procedure TFabricanteIdentificador.Set_DesRotinaFTPEnvio(
  const Value: WideString);
begin
  FDesRotinaFTPEnvio := value;
end;

procedure TFabricanteIdentificador.Set_DesRotinaFTPRetorno(
  const Value: WideString);
begin
  FDesRotinaFTPRetorno := value;
end;

procedure TFabricanteIdentificador.Set_IndEnvioPedidoEmail(
  const Value: WideString);
begin
  FIndEnvioPedidoEmail := value;
end;

procedure TFabricanteIdentificador.Set_IndEnvioPedidoFTP(
  const Value: WideString);
begin
  FIndEnvioPedidoFTP := value;
end;

procedure TFabricanteIdentificador.Set_IndRetornoSituacaoFTP(
  const Value: WideString);
begin
  FIndRetornoSituacaoFTP := value;
end;

procedure TFabricanteIdentificador.Set_NomFabricanteIdentificador(
  const Value: WideString);
begin
  FNomFabricanteIdentificador := value;
end;

procedure TFabricanteIdentificador.Set_NomReduzidoFabricante(
  const Value: WideString);
begin
  FNomReduzidoFabricante := value;
end;

procedure TFabricanteIdentificador.Set_NumCNPJFabricante(
  const Value: WideString);
begin
  FNumCNPJFabricante := value;
end;

procedure TFabricanteIdentificador.Set_NumCNPJFabricanteFormatado(
  const Value: WideString);
begin
  FNumCNPJFabricanteFormatado := value;
end;

procedure TFabricanteIdentificador.Set_NumMaximoPedido(Value: Integer);
begin
  FNumMaximoPedido := value;
end;

procedure TFabricanteIdentificador.Set_NumOrdem(Value: Integer);
begin
  FNumOrdem := value;
end;

procedure TFabricanteIdentificador.Set_NumUltimaRemessa(Value: Integer);
begin
  FNumUltimaRemessa := value;
end;

procedure TFabricanteIdentificador.Set_NumUltimoPedido(Value: Integer);
begin
  FNumUltimoPedido := value;
end;

procedure TFabricanteIdentificador.Set_TxtEmailFabricante(
  const Value: WideString);
begin
  FTxtEmailFabricante := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFabricanteIdentificador, Class_FabricanteIdentificador,
    ciMultiInstance, tmApartment);
end.
