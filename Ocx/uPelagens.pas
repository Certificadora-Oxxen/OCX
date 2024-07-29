// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Pelagem de Animal
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *
// ********************************************************************
unit uPelagens;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao,uIntMensagens,
  uIntPelagens,uPelagem;

type
  TPelagens = class(TASPMTSObject, IPelagens)
  private
    FIntPelagens  : TIntPelagens;
    FInicializado : Boolean;
    FPelagem      : TPelagem;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao,
      IndRestritoSistema: WideString): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    function Inserir(const SglPelagem, DesPelagem: WideString): Integer;
      safecall;
    function Alterar(CodPelagem: Integer; const SglPelagem,
      DesPelagem: WideString): Integer; safecall;
    function Excluir(CodPelagem: Integer): Integer; safecall;
    function Buscar(CodPelagem: Integer): Integer; safecall;
    function Get_Pelagem: IPelagem; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPelagens.AfterConstruction;
begin
  inherited;
  FPelagem := TPelagem.Create;
  FPelagem.ObjAddRef;
  FInicializado := False;
end;

procedure TPelagens.BeforeDestruction;
begin
  If FIntPelagens <> nil Then Begin
    FIntPelagens.Free;
  End;
  If FPelagem <> nil Then Begin
    FPelagem.ObjRelease;
    FPelagem := nil;
  End;
  inherited;
end;

function TPelagens.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPelagens := TIntPelagens.Create;
  Result := FIntPelagens.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPelagens.EOF: WordBool;
begin
  result := FIntPelagens.Eof;
end;

function TPelagens.Pesquisar(const CodOrdenacao,
  IndRestritoSistema: WideString): Integer;
begin
  result := FIntPelagens.Pesquisar(CodOrdenacao, IndRestritoSistema);
end;

procedure TPelagens.FecharPesquisa;
begin
  FIntPelagens.FecharPesquisa;
end;

procedure TPelagens.IrAoProximo;
begin
  FIntPelagens.IrAoProximo;
end;

function TPelagens.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  result := FIntPelagens.ValorCampo(NomeColuna);
end;

function TPelagens.Inserir(const SglPelagem,
  DesPelagem: WideString): Integer;
begin
  result := FIntPelagens.Inserir(SglPelagem,DesPelagem);
end;

function TPelagens.Alterar(CodPelagem: Integer; const SglPelagem,
  DesPelagem: WideString): Integer;
begin
  result := FIntPelagens.Alterar(CodPelagem,SglPelagem,DesPelagem);
end;

function TPelagens.Excluir(CodPelagem: Integer): Integer;
begin
  result := FIntPelagens.Excluir(CodPelagem);
end;

function TPelagens.Buscar(CodPelagem: Integer): Integer;
begin
  result := FIntPelagens.Buscar(CodPelagem);
end;

function TPelagens.Get_Pelagem: IPelagem;
begin
  FPelagem.CodPelagem          := FIntPelagens.IntPelagem.CodPelagem;
  FPelagem.SglPelagem          := FIntPelagens.IntPelagem.SglPelagem;
  FPelagem.DesPelagem          := FIntPelagens.IntPelagem.DesPelagem;
  FPelagem.IndRestritoSistema  := FIntPelagens.IntPelagem.IndRestritoSistema;
  Result := FPelagem;
end;

function TPelagens.BOF: WordBool;
begin
  result := FIntPelagens.BOF;
end;

function TPelagens.NumeroRegistros: Integer;
begin
  result := FIntPelagens.NumeroRegistros;
end;

procedure TPelagens.Deslocar(NumDeslocamento: Integer);
begin
  FIntPelagens.Deslocar(NumDeslocamento);
end;

procedure TPelagens.IrAoAnterior;
begin
 FIntPelagens.IrAoAnterior;
end;

procedure TPelagens.IrAoPrimeiro;
begin
 FIntPelagens.IrAoPrimeiro;
end;

procedure TPelagens.IrAoUltimo;
begin
 FIntPelagens.IrAoUltimo;
end;

procedure TPelagens.Posicionar(NumPosicao: Integer);
begin
 FIntPelagens.Posicionar(NumPosicao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPelagens, Class_Pelagens,
    ciMultiInstance, tmApartment);
end.
