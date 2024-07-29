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
unit uArquivosRemessaPedido;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uArquivoRemessaPedido, uIntArquivosRemessaPedido;
  

type
  TArquivosRemessaPedido = class(TASPMTSObject, IArquivosRemessaPedido)
  private
    FIntArquivosRemessaPedido: TIntArquivosRemessaPedido;
    FArquivoRemessaPedido: TArquivoRemessaPedido;
    FInicializado : Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function Buscar(CodArquivoRemessaPedido: Integer): Integer; safecall;
    function Pesquisar(DtaCriacaoArquivoInicio,
      DtaCriacaoArquivoFim: TDateTime; CodFabricanteIdentificador,
      NumRemessaFabricante, NumPedidoFabricante: Integer;
      const IndEnvioPedidoEmail: WideString; CodSituacaoEmail: Integer;
      const IndEnvioPedidoFTP: WideString;
      CodSituacaoArquivoFTP: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function BOF: WordBool; safecall;
    function Get_ArquivoRemessaPedido: IArquivoRemessaPedido; safecall;
    function GerarNovaRemessa(CodFabricanteIdentificador: Integer): Integer;
      safecall;
    function ValorCampo(const NomCampo: WideString): WideString; safecall;
  end;

implementation

uses ComServ;

function TArquivosRemessaPedido.Buscar(
  CodArquivoRemessaPedido: Integer): Integer;
begin
  Result := FIntArquivosRemessaPedido.Buscar(CodArquivoRemessaPedido);
end;

function TArquivosRemessaPedido.Pesquisar(DtaCriacaoArquivoInicio,
  DtaCriacaoArquivoFim: TDateTime; CodFabricanteIdentificador,
  NumRemessaFabricante, NumPedidoFabricante: Integer;
  const IndEnvioPedidoEmail: WideString; CodSituacaoEmail: Integer;
  const IndEnvioPedidoFTP: WideString;
  CodSituacaoArquivoFTP: Integer): Integer;
begin
  Result := FIntArquivosRemessaPedido.Pesquisar(DtaCriacaoArquivoInicio, DtaCriacaoArquivoFim,
  CodFabricanteIdentificador, NumRemessaFabricante, NumPedidoFabricante, IndEnvioPedidoEmail, CodSituacaoEmail, IndEnvioPedidoFTP,
  CodSituacaoArquivoFTP);
end;

function TArquivosRemessaPedido.Deslocar(
  NumDeslocamento: Integer): Integer;
begin
  Result := FIntArquivosRemessaPedido.Deslocar(NumDeslocamento);
end;

function TArquivosRemessaPedido.EOF: WordBool;
begin
  Result := FIntArquivosRemessaPedido.EOF;
end;

procedure TArquivosRemessaPedido.IrAoAnterior;
begin
  FIntArquivosRemessaPedido.IrAoAnterior;
end;

procedure TArquivosRemessaPedido.IrAoPrimeiro;
begin
  FIntArquivosRemessaPedido.IrAoPrimeiro;
end;

procedure TArquivosRemessaPedido.IrAoProximo;
begin
 FIntArquivosRemessaPedido.IrAoProximo;
end;

procedure TArquivosRemessaPedido.IrAoUltimo;
begin
 FIntArquivosRemessaPedido.IrAoUltimo;
end;

function TArquivosRemessaPedido.NumeroRegistros: Integer;
begin
 Result := FIntArquivosRemessaPedido.NumeroRegistros;
end;

procedure TArquivosRemessaPedido.Posicionar(NumPosicao: Integer);
begin
  FIntArquivosRemessaPedido.Posicionar(NumPosicao);
end;

function TArquivosRemessaPedido.BOF: WordBool;
begin
  Result := FIntArquivosRemessaPedido.BOF;
end;

function TArquivosRemessaPedido.Get_ArquivoRemessaPedido: IArquivoRemessaPedido;
begin
  FArquivoRemessaPedido.CodArquivoFTPEnvio          := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodArquivoFTPEnvio;
  FArquivoRemessaPedido.CodArquivoRemessaPedido     := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodArquivoRemessaPedido;
  FArquivoRemessaPedido.CodEmailEnvio               := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodEmailEnvio;
  FArquivoRemessaPedido.CodFabricanteIdentificador  := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodFabricanteIdentificador;
  FArquivoRemessaPedido.CodSituacaoArquivoFTP       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodSituacaoArquivoFTP;
  FArquivoRemessaPedido.CodSituacaoEmail            := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodSituacaoEmail;
  FArquivoRemessaPedido.DesSituacaoEmail            := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DesSituacaoEmail;
  FArquivoRemessaPedido.DtaCriacaoArquivo           := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DtaCriacaoArquivo;
  FArquivoRemessaPedido.DtaUltimaTransferencia      := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DtaUltimaTransferencia;
  FArquivoRemessaPedido.DtaUltimoEnvio              := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DtaUltimoEnvio;
  FArquivoRemessaPedido.IndEnvioPedidoEmail         := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.IndEnvioPedidoEmail;
  FArquivoRemessaPedido.IndEnvioPedidoFTP           := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.IndEnvioPedidoFTP;
  FArquivoRemessaPedido.NomArquivoRemessaPedido     := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NomArquivoRemessaPedido;
  FArquivoRemessaPedido.NomArquivoFichaPedido       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NomArquivoFichaPedido;
  FArquivoRemessaPedido.NomReduzidoFabricante       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NomReduzidoFabricante;
  FArquivoRemessaPedido.NumRemessaFabricante        := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NumRemessaFabricante;
  FArquivoRemessaPedido.QtdBytesArquivoRemessa      := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.QtdBytesArquivoRemessa;
  FArquivoRemessaPedido.QtdBytesArquivoFicha        := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.QtdBytesArquivoFicha;  
  FArquivoRemessaPedido.SglSituacaoArquivoFTP       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.SglSituacaoArquivoFTP;
  FArquivoRemessaPedido.SglSituacaoEmail            := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.SglSituacaoEmail;
  FArquivoRemessaPedido.DesSituacaoArquivoFTP       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DesSituacaoArquivoFTP;
  FArquivoRemessaPedido.CodUsuarioCriacao           := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodUsuarioCriacao;
  FArquivoRemessaPedido.NomUsuarioCriacao           := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NomUsuarioCriacao;
  FArquivoRemessaPedido.NumPedidoFabricanteInicio   := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.NumPedidoFabricanteInicio;
  FArquivoRemessaPedido.QtdPedidosRemessa           := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.QtdPedidosRemessa;
  FArquivoRemessaPedido.TxtCaminho                  := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.TxtCaminho;
  FArquivoRemessaPedido.CodTipoArquivoRemessa       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.CodTipoArquivoRemessa;
  FArquivoRemessaPedido.DesTipoArquivoRemessa       := FIntArquivosRemessaPedido.IntArquivoRemessaPedido.DesTipoArquivoRemessa;
  Result := FArquivoRemessaPedido;
end;

procedure TArquivosRemessaPedido.AfterConstruction;
begin
  inherited;
  inherited;
  FArquivoRemessaPedido := TArquivoRemessaPedido.Create;
  FArquivoRemessaPedido.ObjAddRef;
  FInicializado := False;
end;

procedure TArquivosRemessaPedido.BeforeDestruction;
begin
  If FIntArquivosRemessaPedido <> nil Then Begin
    FIntArquivosRemessaPedido.Free;
  End;
  If FArquivoRemessaPedido <> nil Then Begin
    FArquivoRemessaPedido.ObjRelease;
    FArquivoRemessaPedido := nil;
  End;
  inherited;
end;

function TArquivosRemessaPedido.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntArquivosRemessaPedido := TIntArquivosRemessaPedido.Create;
  Result := FIntArquivosRemessaPedido.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TArquivosRemessaPedido.GerarNovaRemessa(
  CodFabricanteIdentificador: Integer): Integer;
begin
  Result := FIntArquivosRemessaPedido.GerarNovaRemessa(CodFabricanteIdentificador);
end;

function TArquivosRemessaPedido.ValorCampo(
  const NomCampo: WideString): WideString;
begin
  Result := FIntArquivosRemessaPedido.ValorCampo(NomCampo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TArquivosRemessaPedido, Class_ArquivosRemessaPedido,
    ciMultiInstance, tmApartment);
end.
