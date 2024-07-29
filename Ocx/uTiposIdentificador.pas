// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Atributos Animais - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Tipos de Identificador
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *   Hitalo    22/08/2002    excluir o Metodo PesquisarRelacionamento
// *   Carlos    28/08/2002    Adicionar os Métodos DefinirDoProdutor e Buscar do Produtor
// *
// ********************************************************************
unit uTiposIdentificador;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposIdentificador, uIdentificadorDoProdutor;

type
  TTiposIdentificador = class(TASPMTSObject, ITiposIdentificador)
  private
    FIntTiposIdentificador : TIntTiposIdentificador;
    FInicializado : Boolean;
    FIdentificadorDoProdutor : TIdentificadorDoProdutor;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoPrimeiro; safecall;
    function DefinirDoProdutor(CodTipoIdentificador1, CodPosicaoIdentificador1,
      CodTipoIdentificador2, CodPosicaoIdentificador2,
      CodTipoIdentificador3, CodPosicaoIdentificador3,
      CodTipoIdentificador4, CodPosicaoIdentificador4: Integer): Integer;
      safecall;
    function Get_IdentificadorDoProdutor: IIdentificadorDoProdutor; safecall;
    function BuscarDoProdutor(NumSequenciadentificador: Integer): Integer;
      safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposIdentificador.AfterConstruction;
begin
  inherited;
  FIdentificadorDoProdutor := TIdentificadorDoProdutor.Create;
  FIdentificadorDoProdutor.ObjAddRef;
  FInicializado := False;
end;

procedure TTiposIdentificador.BeforeDestruction;
begin
  If FIntTiposIdentificador <> nil Then Begin
    FIntTiposIdentificador.Free;
  End;
  If FIdentificadorDoProdutor <> nil Then Begin
    FIdentificadorDoProdutor.ObjRelease;
    FIdentificadorDoProdutor := nil;
  End;
  inherited;
end;

function TTiposIdentificador.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposIdentificador := TIntTiposIdentificador.Create;
  Result := FIntTiposIdentificador.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;


function TTiposIdentificador.EOF: WordBool;
begin
  Result := FIntTiposIdentificador.EOF;
end;

function TTiposIdentificador.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  Result := FIntTiposIdentificador.Pesquisar(CodOrdenacao);
end;

function TTiposIdentificador.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposIdentificador.ValorCampo(NomCampo);
end;

procedure TTiposIdentificador.FecharPesquisa;
begin
  FIntTiposIdentificador.FecharPesquisa;
end;

procedure TTiposIdentificador.IrAoProximo;
begin
  FIntTiposIdentificador.IrAoProximo;
end;

procedure TTiposIdentificador.IrAoPrimeiro;
begin
  FIntTiposIdentificador.IrAoPrimeiro;
end;

function TTiposIdentificador.DefinirDoProdutor(CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4: Integer): Integer;
begin
  Result:=FIntTiposIdentificador.DefinirDoProdutor(CodTipoIdentificador1,
  CodPosicaoIdentificador1, CodTipoIdentificador2,
  CodPosicaoIdentificador2, CodTipoIdentificador3,
  CodPosicaoIdentificador3, CodTipoIdentificador4,
  CodPosicaoIdentificador4);
end;

function TTiposIdentificador.Get_IdentificadorDoProdutor: IIdentificadorDoProdutor;
begin
  FIdentificadorDoProdutor.CodTipoIdentificador   := FIntTiposIdentificador.IntIdentificadorDoProdutor.CodTipoIdentificador;
  FIdentificadorDoProdutor.SglTipoIdentificador   := FIntTiposIdentificador.IntIdentificadorDoProdutor.SglTipoIdentificador;
  FIdentificadorDoProdutor.DesTipoIdentificador   := FIntTiposIdentificador.IntIdentificadorDoProdutor.DesTipoIdentificador;
  FIdentificadorDoProdutor.CodPosicaoIdentificador:= FIntTiposIdentificador.IntIdentificadorDoProdutor.CodPosicaoIdentificador;
  FIdentificadorDoProdutor.SglPosicaoIdentificador:= FIntTiposIdentificador.IntIdentificadorDoProdutor.SglPosicaoIdentificador;
  FIdentificadorDoProdutor.DesPosicaoIdentificador:= FIntTiposIdentificador.IntIdentificadorDoProdutor.DesPosicaoIdentificador;
  FIdentificadorDoProdutor.CodGrupoIdentificador  := FIntTiposIdentificador.IntIdentificadorDoProdutor.CodGrupoIdentificador;

  Result := FIdentificadorDoProdutor;
end;

function TTiposIdentificador.BuscarDoProdutor(
  NumSequenciadentificador: Integer): Integer;
begin
  result := FIntTiposIdentificador.BuscarDoProdutor(NumSequenciadentificador);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposIdentificador, Class_TiposIdentificador,
    ciMultiInstance, tmApartment);
end.
