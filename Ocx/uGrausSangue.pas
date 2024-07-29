// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 21/08/2002
// *  Documentação       : Atributos de Animais - Especificação das Classe.doc// *  Código Classe      : 38
// *  Descrição Resumida : Cadastro de Grau de Sangue
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    21/08/2002    Criação
// *   Canival   23/12/2002  Adicionar métodos PesquisarRelacionamentosParaProdutor,
// *                         PesquisarDoProdutor
// *
// ********************************************************************
unit uGrausSangue;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntGrausSangue,uGrauSangue;

type
  TGrausSangue = class(TASPMTSObject, IGrausSangue)
  private
    FIntGrausSangue : TIntGrausSangue;
    FInicializado   : Boolean;
    FGrauSangue     : TGrauSangue;
  protected
    function EOF: WordBool; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function PesquisarRelacionamentos: Integer; safecall;
    function Inserir(const SglGrauSangue, DesGrauSangue: WideString): Integer;
      safecall;
    function Alterar(CodGrauSangue: Integer; const SglGrauSangue,
      DesGrauSangue: WideString): Integer; safecall;
    function Buscar(CodGrauSangue: Integer): Integer; safecall;
    function Excluir(CodGrauSangue: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure IrAoAnterior; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_GrauSangue: IGrauSangue; safecall;
    function Pesquisar(CodAssociacaoRaca: Integer;
      const IndAindaNaoRelacionados, CodOrdenacao: WideString): Integer;
      safecall;
    function PesquisarDoProdutor(const CodOrdenacao: WideString): Integer;
      safecall;
    function PesquisarRelacionamentoParaProdutor: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TGrausSangue.AfterConstruction;
begin
  inherited;
  FGrauSangue := TGrauSangue.Create;
  FGrauSangue.ObjAddRef;
  FInicializado := False;
end;

procedure TGrausSangue.BeforeDestruction;
begin
  If FIntGrausSangue <> nil Then Begin
    FIntGrausSangue.Free;
  End;
  If FGrauSangue <> nil Then Begin
    FGrauSangue.ObjRelease;
    FGrauSangue := nil;
  End;
  inherited;
end;

function TGrausSangue.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGrausSangue := TIntGrausSangue.Create;
  Result := FIntGrausSangue.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGrausSangue.EOF: WordBool;
begin
  result := FIntGrausSangue.Eof;
end;

procedure TGrausSangue.IrAoProximo;
begin
  FIntGrausSangue.IrAoProximo;
end;

function TGrausSangue.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntGrausSangue.ValorCampo(NomCampo);
end;

procedure TGrausSangue.FecharPesquisa;
begin
  FIntGrausSangue.FecharPesquisa;
end;

function TGrausSangue.PesquisarRelacionamentos: Integer;
begin
  result := FIntGrausSangue.PesquisarRelacionamentos;
end;

function TGrausSangue.Inserir(const SglGrauSangue,
  DesGrauSangue: WideString): Integer;
begin
  result := FIntGrausSangue.Inserir(SglGrauSangue,DesGrauSangue);
end;

function TGrausSangue.Alterar(CodGrauSangue: Integer; const SglGrauSangue,
  DesGrauSangue: WideString): Integer;
begin
 result := FIntGrausSangue.Alterar(CodGrauSangue,SglGrauSangue, DesGrauSangue);
end;

function TGrausSangue.Buscar(CodGrauSangue: Integer): Integer;
begin
 result := FIntGrausSangue.Buscar(CodGrauSangue);
end;

function TGrausSangue.Excluir(CodGrauSangue: Integer): Integer;
begin
 result := FIntGrausSangue.Excluir(CodGrauSangue);
end;

function TGrausSangue.BOF: WordBool;
begin
 result := FIntGrausSangue.BOF;
end;

function TGrausSangue.NumeroRegistros: Integer;
begin
  result := FIntGrausSangue.NumeroRegistros;
end;

procedure TGrausSangue.IrAoPrimeiro;
begin
  FIntGrausSangue.IrAoPrimeiro;
end;

procedure TGrausSangue.IrAoUltimo;
begin
  FIntGrausSangue.IrAoUltimo;
end;

procedure TGrausSangue.IrAoAnterior;
begin
  FIntGrausSangue.IrAoAnterior;
end;

function TGrausSangue.Deslocar(NumDeslocamento: Integer): Integer;
begin
  result := FIntGrausSangue.Deslocar(NumDeslocamento);
end;

procedure TGrausSangue.Posicionar(NumPosicao: Integer);
begin
  FIntGrausSangue.Posicionar(NumPosicao);
end;

function TGrausSangue.Get_GrauSangue: IGrauSangue;
begin
  FGrauSangue.CodGrauSangue  := FIntGrausSangue.IntGrauSangue.CodGrauSangue;
  FGrauSangue.SglGrauSangue  := FIntGrausSangue.IntGrauSangue.SglGrauSangue;
  FGrauSangue.DesGrauSangue  := FIntGrausSangue.IntGrauSangue.DesGrauSangue;
  result := FGrauSangue;
end;

function TGrausSangue.Pesquisar(CodAssociacaoRaca: Integer;
  const IndAindaNaoRelacionados, CodOrdenacao: WideString): Integer;
begin
  result := FIntGrausSangue.Pesquisar(CodAssociacaoRaca,IndAindaNaoRelacionados,CodOrdenacao);
end;

function TGrausSangue.PesquisarDoProdutor(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntGrausSangue.PesquisarDoProdutor (CodOrdenacao);
end;

function TGrausSangue.PesquisarRelacionamentoParaProdutor: Integer;
begin
  result := FIntGrausSangue.PesquisarRelacionamentoParaProdutor;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrausSangue, Class_GrausSangue,
    ciMultiInstance, tmApartment);
end.
