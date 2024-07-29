// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 16/09/2002
// *  Documentação       :
// *  Código Classe      :  63
// *  Descrição Resumida : Cadastro de Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    16/10/2002    Criação
// *
// ********************************************************************
unit uInsumos;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntInsumos,uInsumo;

type
  TInsumos = class(TASPMTSObject, IInsumos)
  private
    FIntInsumos    : TIntInsumos;
    FInicializado : Boolean;
    FInsumo         : TInsumo;
  protected
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoPrimeiro; safecall;
    function Alterar(CodInsumo: Integer; const DesInsumo,
      TxtInsumo: WideString): Integer; safecall;
    function Buscar(CodFabricanteInsumo: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function Excluir(CodFabricanteInsumo: Integer): Integer; safecall;
    function Inserir(const DesInsumo: WideString; CodTipoInsumo,
      CodSubTipoInsumo, CodFabricanteInsumo: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const DesInsumo: WideString; CodTipoInsumo,
      CodSubTipoInsumo, CodFabricante: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_Insumo: IInsumo; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TInsumos.AfterConstruction;
begin
  inherited;
  FInsumo := TInsumo.Create;
  FInsumo.ObjAddRef;
  FInicializado := False;
end;

procedure TInsumos.BeforeDestruction;
begin
  If FIntInsumos <> nil Then Begin
    FIntInsumos.Free;
  End;
  If FInsumo <> nil Then Begin
    FInsumo.ObjRelease;
    FInsumo := nil;
  End;
  inherited;
end;

function TInsumos.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntInsumos := TIntInsumos.Create;
  Result := FIntInsumos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TInsumos.BOF: WordBool;
begin
 result := FIntInsumos.BOF;
end;

function TInsumos.EOF: WordBool;
begin
 result := FIntInsumos.EOF;
end;

procedure TInsumos.IrAoPrimeiro;
begin
 FIntInsumos.IrAoPrimeiro;
end;

function TInsumos.Alterar(CodInsumo: Integer; const DesInsumo,
  TxtInsumo: WideString): Integer;
begin
  result := FIntInsumos.Alterar(CodInsumo,DesInsumo,TxtInsumo);
end;

function TInsumos.Buscar(CodFabricanteInsumo: Integer): Integer;
begin
 result := FIntInsumos.Buscar(CodFabricanteInsumo);
end;

function TInsumos.Deslocar(NumDeslocamento: Integer): Integer;
begin
 result := FIntInsumos.Deslocar(NumDeslocamento);
end;

function TInsumos.Excluir(CodFabricanteInsumo: Integer): Integer;
begin
 result := FIntInsumos.Excluir(CodFabricanteInsumo);
end;

function TInsumos.Inserir(const DesInsumo: WideString; CodTipoInsumo,
  CodSubTipoInsumo, CodFabricanteInsumo: Integer;
  const TxtObservacao: WideString): Integer;
begin
  result := FIntInsumos.Inserir(DesInsumo,CodTipoInsumo,CodSubTipoInsumo, CodFabricanteInsumo,TxtObservacao);
end;

function TInsumos.NumeroRegistros: Integer;
begin
 result := FIntInsumos.NumeroRegistros;
end;

function TInsumos.Pesquisar(const DesInsumo: WideString; CodTipoInsumo,
  CodSubTipoInsumo, CodFabricante: Integer;
  const CodOrdenacao: WideString): Integer;
begin
 result := FIntInsumos.Pesquisar(DesInsumo,CodTipoInsumo,CodSubTipoInsumo, CodFabricante, CodOrdenacao);
end;

function TInsumos.ValorCampo(const NomColuna: WideString): OleVariant;
begin
 result := FIntInsumos.ValorCampo(NomColuna);
end;

procedure TInsumos.FecharPesquisa;
begin
 FIntInsumos.FecharPesquisa;
end;

procedure TInsumos.IrAoAnterior;
begin
  FIntInsumos.IrAoAnterior;
end;

procedure TInsumos.IrAoProximo;
begin
 FIntInsumos.IrAoProximo;
end;

procedure TInsumos.IrAoUltimo;
begin
  FIntInsumos.IrAoUltimo;
end;

procedure TInsumos.Posicionar(NumPosicao: Integer);
begin
  FIntInsumos.Posicionar(NumPosicao);
end;

function TInsumos.Get_Insumo: IInsumo;
begin
  FInsumo.CodInsumo                    := FIntInsumos.IntInsumo.CodInsumo;
  FInsumo.DesInsumo                    := FIntInsumos.IntInsumo.DesInsumo;
  FInsumo.CodTipoInsumo                := FIntInsumos.IntInsumo.CodTipoInsumo;
  FInsumo.SglTipoInsumo                := FIntInsumos.IntInsumo.SglTipoInsumo;
  FInsumo.DesTipoInsumo                := FIntInsumos.IntInsumo.DesTipoInsumo;
  FInsumo.CodSubTipoInsumo             := FIntInsumos.IntInsumo.CodSubTipoInsumo;
  FInsumo.SglSubTipoInsumo             := FIntInsumos.IntInsumo.SglSubTipoInsumo;
  FInsumo.DesSubTipoInsumo             := FIntInsumos.IntInsumo.DesSubTipoInsumo;
  FInsumo.CodFabricanteInsumo          := FIntInsumos.IntInsumo.CodFabricanteInsumo;
  FInsumo.NomFabricanteInsumo          := FIntInsumos.IntInsumo.NomFabricanteInsumo;
  FInsumo.NomReduzidoFabricanteInsumo  := FIntInsumos.IntInsumo.NomReduzidoFabricanteInsumo;
  FInsumo.TxtObservacao                := FIntInsumos.IntInsumo.TxtObservacao;
  result := FInsumo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TInsumos, Class_Insumos,
    ciMultiInstance, tmApartment);
end.
