// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Micro Regioes
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *   Hítalo    06/08/2002    Adicionar método Inserir,Excluir,Alterar
// *                           Buscar.
// *
// ********************************************************************
unit uMicroRegioes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntMicroRegioes,uMicroRegiao;

type
  TMicroRegioes = class(TASPMTSObject, IMicroRegioes)
  private
    FIntMicroRegioes   : TIntMicroRegioes;
    FInicializado      : Boolean;
    FMicroRegiao       : TMicroRegiao;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const NomMicroRegiao: WideString; CodEstado: Integer;
      const CodOrdenacao: WideString;
      CodMicroRegiaoSisbov: Integer): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Inserir(const NomMicroRegiao: WideString; CodMIcroRegiao,
      CodEstado: Integer): Integer; safecall;
    function Alterar(CodMicroRegiao: Integer; const NomMicroRegiao: WideString;
      CodMicroRegiaoSisBov: Integer): Integer; safecall;
    function Excluir(CodMicroRegiao: Integer): Integer; safecall;
    function Buscar(CodMicroRegiao: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure IrAoAnterior; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function Get_MicroRegiao: IMicroRegiao; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TMicroRegioes.AfterConstruction;
begin
  inherited;
  FMicroRegiao := TMicroRegiao.Create;
  FMicroRegiao.ObjAddRef;
  FInicializado := False;
end;

procedure TMicroRegioes.BeforeDestruction;
begin
  If FIntMicroRegioes <> nil Then Begin
    FIntMicroRegioes.Free;
  End;
  If FMicroRegiao <> nil Then Begin
    FMicroRegiao.ObjRelease;
    FMicroRegiao := nil;
  End;
  inherited;
end;

function TMicroRegioes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntMicroRegioes := TIntMicroRegioes.Create;
  Result := FIntMicroRegioes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TMicroRegioes.EOF: WordBool;
begin
  result := FIntMicroRegioes.Eof;
end;

function TMicroRegioes.Pesquisar(const NomMicroRegiao: WideString;
  CodEstado: Integer; const CodOrdenacao: WideString;
  CodMicroRegiaoSisbov: Integer): Integer;
begin
  result := FIntMicroRegioes.Pesquisar (NomMicroRegiao,CodEstado,CodOrdenacao,CodMicroRegiaoSisbov);
end;

function TMicroRegioes.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  result := FIntMicroRegioes.ValorCampo(NomeColuna);
end;

procedure TMicroRegioes.FecharPesquisa;
begin
  FIntMicroRegioes.FecharPesquisa;
end;

procedure TMicroRegioes.IrAoProximo;
begin
  FIntMicroRegioes.IrAoProximo;
end;

function TMicroRegioes.Inserir(const NomMicroRegiao: WideString;
  CodMIcroRegiao, CodEstado: Integer): Integer;
begin
  result := FIntMicroRegioes.Inserir(NomMicroRegiao,CodMIcroRegiao, CodEstado);
end;

function TMicroRegioes.Alterar(CodMicroRegiao: Integer;
  const NomMicroRegiao: WideString;
  CodMicroRegiaoSisBov: Integer): Integer;
begin
  result := FIntMicroRegioes.Alterar(CodMicroRegiao,NomMicroRegiao, CodMicroRegiaoSisBov);
end;

function TMicroRegioes.Excluir(CodMicroRegiao: Integer): Integer;
begin
  result := FIntMicroRegioes.Excluir(CodMicroRegiao);
end;

function TMicroRegioes.Buscar(CodMicroRegiao: Integer): Integer;
begin
  result := FIntMicroRegioes.Buscar(CodMicroRegiao);
end;

function TMicroRegioes.BOF: WordBool;
begin
  result := FIntMicroRegioes.BOF;
end;

function TMicroRegioes.NumeroRegistros: Integer;
begin
  result := FIntMicroRegioes.NumeroRegistros;
end;

procedure TMicroRegioes.IrAoPrimeiro;
begin
  FIntMicroRegioes.IrAoPrimeiro;
end;

procedure TMicroRegioes.IrAoUltimo;
begin
  FIntMicroRegioes.IrAoUltimo;
end;

procedure TMicroRegioes.IrAoAnterior;
begin
  FIntMicroRegioes.IrAoAnterior;
end;

procedure TMicroRegioes.Posicionar(NumPosicao: Integer);
begin
  FIntMicroRegioes.Posicionar(NumPosicao);
end;

function TMicroRegioes.Deslocar(NumDeslocamento: Integer): Integer;
begin
  result := FIntMicroRegioes.Deslocar(NumDeslocamento);
end;

function TMicroRegioes.Get_MicroRegiao: IMicroRegiao;
begin
  FMicroRegiao.CodPais               := FIntMicroRegioes.IntMicroRegiao.CodPais;
  FMicroRegiao.NomPais               := FIntMicroRegioes.IntMicroRegiao.NomPais;
  FMicroRegiao.CodPaisSisBov         := FIntMicroRegioes.IntMicroRegiao.CodPaisSisBov;
  FMicroRegiao.CodEstado             := FIntMicroRegioes.IntMicroRegiao.CodEstado;
  FMicroRegiao.SglEstado             := FIntMicroRegioes.IntMicroRegiao.SglEstado;
  FMicroRegiao.CodEstadoSisBov       := FIntMicroRegioes.IntMicroRegiao.CodEstadoSisBov;
  FMicroRegiao.CodMicroRegiao        := FIntMicroRegioes.IntMicroRegiao.CodMicroRegiao;
  FMicroRegiao.NomMicroRegiao        := FIntMicroRegioes.IntMicroRegiao.NomMicroRegiao;
  FMicroRegiao.CodMicroRegiaoSisBov  := FIntMicroRegioes.IntMicroRegiao.CodMicroRegiaoSisBov;

  result := FMicroRegiao;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMicroRegioes, Class_MicroRegioes,
    ciMultiInstance, tmApartment);
end.
