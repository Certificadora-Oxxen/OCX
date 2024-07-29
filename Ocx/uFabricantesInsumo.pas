// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 11/09/2002
// *  Documentação       :
// *  Código Classe      :  60
// *  Descrição Resumida : Cadastro de Fabricante Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/10/2002    Criação
// *
// ********************************************************************
unit uFabricantesInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntFabricantesInsumo,uFabricanteInsumo;

type
  TFabricantesInsumo = class(TASPMTSObject, IFabricantesInsumo)
  private
    FIntFabricantesInsumo    : TIntFabricantesInsumo;
    FInicializado : Boolean;
    FFabricanteInsumo         : TFabricanteInsumo;
  protected
    function EOF: WordBool; safecall;
    function BOF: WordBool; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Buscar(CodUnidadeMedida: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function Inserir(const NomFabricanteInsumo,
      NomReduzidoFabricanteInsumo: WideString;
      NumRegistroFabricante: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Alterar(CodFabricanteInsumo: Integer; const NomFabricanteInsumo,
      NomReduzidoFabricanteInsumo: WideString;
      NumRegistroFabricante: Integer): Integer; safecall;
    function Excluir(CodFabricanteInsumo: Integer): Integer; safecall;
    function Pesquisar(CodTipoInsumo: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function AdicionarTipoInsumo(CodFabricanteInsumo,
      CodTipoInsumo: Integer): Integer; safecall;
    function RetirarTipoInsumo(CodFabricanteInsumo,
      CodTipoInsumo: Integer): Integer; safecall;
    function PossuiTipoInsumo(CodFabricanteInsumo,
      CodTipoInsumo: Integer): Integer; safecall;
    function Get_FabricanteInsumo: IFabricanteInsumo; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TFabricantesInsumo.AfterConstruction;
begin
  inherited;
  FFabricanteInsumo := TFabricanteInsumo.Create;
  FFabricanteInsumo.ObjAddRef;
  FInicializado := False;
end;

procedure TFabricantesInsumo.BeforeDestruction;
begin
  If FIntFabricantesInsumo <> nil Then Begin
    FIntFabricantesInsumo.Free;
  End;
  If FFabricanteInsumo <> nil Then Begin
    FFabricanteInsumo.ObjRelease;
    FFabricanteInsumo := nil;
  End;
  inherited;
end;

function TFabricantesInsumo.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntFabricantesInsumo := TIntFabricantesInsumo.Create;
  Result := FIntFabricantesInsumo.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TFabricantesInsumo.EOF: WordBool;
begin
  result := FIntFabricantesInsumo.EOF;
end;

function TFabricantesInsumo.BOF: WordBool;
begin
  result := FIntFabricantesInsumo.BOF;
end;

procedure TFabricantesInsumo.IrAoPrimeiro;
begin
  FIntFabricantesInsumo.IrAoPrimeiro;
end;

procedure TFabricantesInsumo.IrAoProximo;
begin
  FIntFabricantesInsumo.IrAoProximo;
end;

procedure TFabricantesInsumo.IrAoUltimo;
begin
  FIntFabricantesInsumo.IrAoUltimo;
end;

function TFabricantesInsumo.Buscar(CodUnidadeMedida: Integer): Integer;
begin
  result := FIntFabricantesInsumo.Buscar(CodUnidadeMedida);
end;

function TFabricantesInsumo.Deslocar(NumDeslocamento: Integer): Integer;
begin
  result := FIntFabricantesInsumo.Deslocar(NumDeslocamento);
end;

function TFabricantesInsumo.Inserir(const NomFabricanteInsumo,
  NomReduzidoFabricanteInsumo: WideString;
  NumRegistroFabricante: Integer): Integer;
begin
  result := FIntFabricantesInsumo.Inserir(NomFabricanteInsumo,NomReduzidoFabricanteInsumo,NumRegistroFabricante);
end;

function TFabricantesInsumo.NumeroRegistros: Integer;
begin
  result := FIntFabricantesInsumo.NumeroRegistros;
end;

function TFabricantesInsumo.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  result := FIntFabricantesInsumo.ValorCampo(NomColuna);
end;

procedure TFabricantesInsumo.FecharPesquisa;
begin
  FIntFabricantesInsumo.FecharPesquisa;
end;

procedure TFabricantesInsumo.IrAoAnterior;
begin
  FIntFabricantesInsumo.IrAoAnterior;
end;

procedure TFabricantesInsumo.Posicionar(NumPosicao: Integer);
begin
  FIntFabricantesInsumo.Posicionar(NumPosicao);
end;

function TFabricantesInsumo.Alterar(CodFabricanteInsumo: Integer;
  const NomFabricanteInsumo, NomReduzidoFabricanteInsumo: WideString;
  NumRegistroFabricante: Integer): Integer;
begin
  result := FIntFabricantesInsumo.Alterar(CodFabricanteInsumo,NomFabricanteInsumo, NomReduzidoFabricanteInsumo,NumRegistroFabricante);
end;

function TFabricantesInsumo.Excluir(CodFabricanteInsumo: Integer): Integer;
begin
  result := FIntFabricantesInsumo.Excluir(CodFabricanteInsumo);
end;

function TFabricantesInsumo.Pesquisar(CodTipoInsumo: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntFabricantesInsumo.Pesquisar(CodTipoInsumo,CodOrdenacao);
end;

function TFabricantesInsumo.AdicionarTipoInsumo(CodFabricanteInsumo,
  CodTipoInsumo: Integer): Integer;
begin
  result := FIntFabricantesInsumo.AdicionarTipoInsumo(CodFabricanteInsumo,CodTipoInsumo);
end;

function TFabricantesInsumo.RetirarTipoInsumo(CodFabricanteInsumo,
  CodTipoInsumo: Integer): Integer;
begin
  result := FIntFabricantesInsumo.RetirarTipoInsumo(CodFabricanteInsumo, CodTipoInsumo);
end;

function TFabricantesInsumo.PossuiTipoInsumo(CodFabricanteInsumo,
  CodTipoInsumo: Integer): Integer;
begin
  result := FIntFabricantesInsumo.PossuiTipoInsumo(CodFabricanteInsumo,CodTipoInsumo);
end;

function TFabricantesInsumo.Get_FabricanteInsumo: IFabricanteInsumo;
begin
  FFabricanteInsumo.CodFabricanteInsumo          := FIntFabricantesInsumo.IntFabricanteInsumo.CodFabricanteInsumo;
  FFabricanteInsumo.NomFabricanteInsumo          := FIntFabricantesInsumo.IntFabricanteInsumo.NomFabricanteInsumo;
  FFabricanteInsumo.NomReduzidoFabricanteInsumo  := FIntFabricantesInsumo.IntFabricanteInsumo.NomReduzidoFabricanteInsumo;
  FFabricanteInsumo.NumRegistroFabricante        := FIntFabricantesInsumo.IntFabricanteInsumo.NumRegistroFabricante;
  result := FFabricanteInsumo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFabricantesInsumo, Class_FabricantesInsumo,
    ciMultiInstance, tmApartment);
end.
