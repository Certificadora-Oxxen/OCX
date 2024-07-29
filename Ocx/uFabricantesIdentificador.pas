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
unit uFabricantesIdentificador;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntFabricantesIdentificador,
  uIntMensagens, uConexao, uFabricanteIdentificador;

type
  TFabricantesIdentificador = class(TASPMTSObject, IFabricantesIdentificador)
  private
    FIntFabricantesIdentificador: TIntFabricantesIdentificador;
    FFabricanteIdentificador:  TFabricanteIdentificador;
    FInicializado: Boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function BOF: WordBool; safecall;
    function Buscar(CodFabricanteIdentificador: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar: Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Get_FabricanteIdentificador: IFabricanteIdentificador; safecall;
  end;

implementation

uses ComServ;

procedure TFabricantesIdentificador.AfterConstruction;
begin
  inherited;
  FFabricanteIdentificador := TFabricanteIdentificador.Create;
  FFabricanteIdentificador.ObjAddRef;
  FInicializado := False;
end;

procedure TFabricantesIdentificador.BeforeDestruction;
begin
  If FIntFabricantesIdentificador <> nil Then Begin
    FIntFabricantesIdentificador.Free;
  End;
  If FFabricanteIdentificador <> nil Then Begin
    FFabricanteIdentificador.ObjRelease;
    FFabricanteIdentificador := nil;
  End;
  inherited;
end;

function TFabricantesIdentificador.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntFabricantesIdentificador := TIntFabricantesIdentificador.Create;
  Result := FIntFabricantesIdentificador.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TFabricantesIdentificador.BOF: WordBool;
begin
 Result := FIntFabricantesIdentificador.BOF;
end;

function TFabricantesIdentificador.Buscar(
  CodFabricanteIdentificador: Integer): Integer;
begin
  Result := FIntFabricantesIdentificador.Buscar(CodFabricanteIdentificador);
end;

function TFabricantesIdentificador.Deslocar(
  NumDeslocamento: Integer): Integer;
begin
  Result := FIntFabricantesIdentificador.Deslocar(NumDeslocamento);
end;

function TFabricantesIdentificador.EOF: WordBool;
begin
  Result := FIntFabricantesIdentificador.EOF;
end;

function TFabricantesIdentificador.NumeroRegistros: Integer;
begin
  Result := FIntFabricantesIdentificador.NumeroRegistros;
end;

function TFabricantesIdentificador.Pesquisar: Integer;
begin
   Result := FIntFabricantesIdentificador.Pesquisar;
end;

procedure TFabricantesIdentificador.Posicionar(NumPosicao: Integer);
begin
  FIntFabricantesIdentificador.Posicionar(NumPosicao);
end;

function TFabricantesIdentificador.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntFabricantesIdentificador.ValorCampo(NomCampo);
end;

procedure TFabricantesIdentificador.IrAoAnterior;
begin
  FIntFabricantesIdentificador.IrAoAnterior;
end;

procedure TFabricantesIdentificador.IrAoPrimeiro;
begin
  FIntFabricantesIdentificador.IrAoPrimeiro;
end;

procedure TFabricantesIdentificador.IrAoProximo;
begin
  FIntFabricantesIdentificador.IrAoProximo;
end;

procedure TFabricantesIdentificador.IrAoUltimo;
begin
  FIntFabricantesIdentificador.IrAoUltimo;
end;

function TFabricantesIdentificador.Get_FabricanteIdentificador: IFabricanteIdentificador;
begin
  FFabricanteIdentificador.CodFabricanteIdentificador  := FIntFabricantesIdentificador.IntFabricanteIdentificador.CodFabricanteIdentificador;
  FFabricanteIdentificador.CodRotinaFTPEnvio           := FIntFabricantesIdentificador.IntFabricanteIdentificador.CodRotinaFTPEnvio;
  FFabricanteIdentificador.CodRotinaFTPRetorno         := FIntFabricantesIdentificador.IntFabricanteIdentificador.CodRotinaFTPRetorno;
  FFabricanteIdentificador.DesRotinaFTPEnvio           := FIntFabricantesIdentificador.IntFabricanteIdentificador.DesRotinaFTPEnvio;
  FFabricanteIdentificador.DesRotinaFTPRetorno         := FIntFabricantesIdentificador.IntFabricanteIdentificador.DesRotinaFTPRetorno;
  FFabricanteIdentificador.IndEnvioPedidoEmail         := FIntFabricantesIdentificador.IntFabricanteIdentificador.IndEnvioPedidoEmail;
  FFabricanteIdentificador.IndEnvioPedidoFTP           := FIntFabricantesIdentificador.IntFabricanteIdentificador.IndEnvioPedidoFTP;
  FFabricanteIdentificador.IndRetornoSituacaoFTP       := FIntFabricantesIdentificador.IntFabricanteIdentificador.IndRetornoSituacaoFTP;
  FFabricanteIdentificador.NomFabricanteIdentificador  := FIntFabricantesIdentificador.IntFabricanteIdentificador.NomFabricanteIdentificador;
  FFabricanteIdentificador.NomReduzidoFabricante       := FIntFabricantesIdentificador.IntFabricanteIdentificador.NomReduzidoFabricante;
  FFabricanteIdentificador.NumCNPJFabricante           := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumCNPJFabricante;
  FFabricanteIdentificador.NumCNPJFabricanteFormatado  := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumCNPJFabricanteFormatado;
  FFabricanteIdentificador.NumMaximoPedido             := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumMaximoPedido;
  FFabricanteIdentificador.NumOrdem                    := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumOrdem;
  FFabricanteIdentificador.NumUltimaRemessa            := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumUltimaRemessa;
  FFabricanteIdentificador.NumUltimoPedido             := FIntFabricantesIdentificador.IntFabricanteIdentificador.NumUltimoPedido;
  FFabricanteIdentificador.TxtEmailFabricante          := FIntFabricantesIdentificador.IntFabricanteIdentificador.TxtEmailFabricante;
  Result := FFabricanteIdentificador;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFabricantesIdentificador, Class_FabricantesIdentificador,
    ciMultiInstance, tmApartment);
end.
