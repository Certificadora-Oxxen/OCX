// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/08/2002
// *  Documentação       : Atributos de animais - definição das classes.doc
// *  Código Classe      : 37
// *  Descrição Resumida : Cadastro de Associação Raça
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    23/07  /2002    Criação
// *   Hitalo    19/08/2002  Adicionar métodos Inserir, Excluir, Buscar ,Alterar,
// *                         AdicionarGrauSangue,RetirrarGrauSangue,PesquisarRelacionamentos
// *   Canival   23/12/2002  Adicionar métodos PesquisardoProdutor, AdicionardoProdutor
// *                         RetirardoProdutor
// *
// ********************************************************************
unit uAssociacoesRaca;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntAssociacoesRaca,uAssociacaoRaca;

type
  TAssociacoesRaca = class(TASPMTSObject, IAssociacoesRaca)
  private
    FIntAssociacoesRaca : TIntAssociacoesRaca;
    FInicializado : Boolean;
    FAssociacaoRaca: TAssociacaoRaca;
  protected
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function Get_AssociacaoRaca: IAssociacaoRaca; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    function Alterar(CodAssociacaoRaca: Integer; const SglAssociacaoRaca,
      NomAssociacaoRaca: WideString): Integer; safecall;
    function Inserir(const SglAssociacaoRaca,
      NomAssociacaoRaca: WideString): Integer; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Excluir(CodAssociacaoRaca: Integer): Integer; safecall;
    function Buscar(CodAssociacaoRaca: Integer): Integer; safecall;
    function AdicionarGrauSangue(CodAssociacaoRaca: Integer;
      const CodGrausSangue: WideString): Integer; safecall;
    function PesquisarRelacionamento: Integer; safecall;
    function RetirarGrauSangue(CodAssociacaoRaca: Integer;
      const CodGrausSangue: WideString): Integer; safecall;
    function AdicionarAoProdutor(CodAssociacaoRaca: Integer): Integer;
      safecall;
    function PesquisarDoProdutor(const IndAssociacaoRacaProdutor,
      CodOrdenacao: WideString): Integer; safecall;
    function RetirarDoProdutor(CodAssociacaoRaca: Integer): Integer; safecall;
    function AdicionarRaca(CodAssociacaoRaca: Integer;
      const CodRacas: WideString): Integer; safecall;
    function PesquisarRacas(CodAssociacaoRaca: Integer;
      const IndAindaNaoRelacionados, CodOrdenacao: WideString): Integer;
      safecall;
    function RetirarRaca(CodAssociacaoRaca: Integer;
      const CodRacas: WideString): Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TAssociacoesRaca.AfterConstruction;
begin
  inherited;
  FAssociacaoRaca := TAssociacaoRaca.Create;
  FAssociacaoRaca.ObjAddRef;
  FInicializado := False;
end;

procedure TAssociacoesRaca.BeforeDestruction;
begin
  If FIntAssociacoesRaca <> nil Then Begin
    FIntAssociacoesRaca.Free;
  End;
  If FAssociacaoRaca <> nil Then Begin
    FAssociacaoRaca.ObjRelease;
    FAssociacaoRaca := nil;
  End;
  inherited;
end;

function TAssociacoesRaca.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAssociacoesRaca := TIntAssociacoesRaca.Create;
  Result := FIntAssociacoesRaca.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAssociacoesRaca.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntAssociacoesRaca.Pesquisar(CodOrdenacao);
end;

function TAssociacoesRaca.EOF: WordBool;
begin
  result := FIntAssociacoesRaca.Eof;
end;

procedure TAssociacoesRaca.IrAoProximo;
begin
  FIntAssociacoesRaca.IrAoProximo;
end;

function TAssociacoesRaca.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntAssociacoesRaca.ValorCampo(NomCampo);
end;

procedure TAssociacoesRaca.FecharPesquisa;
begin
  FIntAssociacoesRaca.FecharPesquisa;
end;

function TAssociacoesRaca.Get_AssociacaoRaca: IAssociacaoRaca;
begin
  FAssociacaoRaca.CodAssociacaoRaca  := FIntAssociacoesRaca.IntAssociacaoRaca.CodAssociacaoRaca;
  FAssociacaoRaca.SglAssociacaoRaca  := FIntAssociacoesRaca.IntAssociacaoRaca.SglAssociacaoRaca;
  FAssociacaoRaca.NomAssociacaoRaca  := FIntAssociacoesRaca.IntAssociacaoRaca.NomAssociacaoRaca;
  result := FAssociacaoRaca;
end;

function TAssociacoesRaca.BOF: WordBool;
begin
  result := FIntAssociacoesRaca.EOF;
end;

function TAssociacoesRaca.NumeroRegistros: Integer;
begin
  result := FIntAssociacoesRaca.NumeroRegistros;
end;

procedure TAssociacoesRaca.IrAoAnterior;
begin
  FIntAssociacoesRaca.IrAoAnterior;
end;

procedure TAssociacoesRaca.IrAoPrimeiro;
begin
  FIntAssociacoesRaca.IrAoPrimeiro;
end;

procedure TAssociacoesRaca.IrAoUltimo;
begin
  FIntAssociacoesRaca.IrAoUltimo;
end;

function TAssociacoesRaca.Alterar(CodAssociacaoRaca: Integer;
  const SglAssociacaoRaca, NomAssociacaoRaca: WideString): Integer;
begin
  result := FIntAssociacoesRaca.Alterar(CodAssociacaoRaca,
            SglAssociacaoRaca, NomAssociacaoRaca);
end;

function TAssociacoesRaca.Inserir(const SglAssociacaoRaca,
  NomAssociacaoRaca: WideString): Integer;
begin
  result := FIntAssociacoesRaca.Inserir(SglAssociacaoRaca, NomAssociacaoRaca);
end;

procedure TAssociacoesRaca.Deslocar(NumDeslocamento: Integer);
begin
  FIntAssociacoesRaca.Deslocar(NumDeslocamento);
end;

procedure TAssociacoesRaca.Posicionar(NumPosicao: Integer);
begin
  FIntAssociacoesRaca.Posicionar(NumPosicao);
end;

function TAssociacoesRaca.Excluir(CodAssociacaoRaca: Integer): Integer;
begin
  result := FIntAssociacoesRaca.Excluir(CodAssociacaoRaca);
end;

function TAssociacoesRaca.Buscar(CodAssociacaoRaca: Integer): Integer;
begin
  result := FIntAssociacoesRaca.Buscar(CodAssociacaoRaca);
end;

function TAssociacoesRaca.AdicionarGrauSangue(CodAssociacaoRaca: Integer;
  const CodGrausSangue: WideString): Integer;
begin
  result := FIntAssociacoesRaca.AdicionarGrauSangue(CodAssociacaoRaca,
                                CodGrausSangue);
end;

function TAssociacoesRaca.PesquisarRelacionamento: Integer;
begin
  result := FIntAssociacoesRaca.PesquisarRelacionamento;
end;

function TAssociacoesRaca.RetirarGrauSangue(CodAssociacaoRaca: Integer;
  const CodGrausSangue: WideString): Integer;
begin
  result := FIntAssociacoesRaca.RetirarGrauSangue(CodAssociacaoRaca,
                                 CodGrausSangue);
end;

function TAssociacoesRaca.PesquisarDoProdutor(const IndAssociacaoRacaProdutor,
      CodOrdenacao: WideString): Integer;
begin
  result := FIntAssociacoesRaca.PesquisarDoProdutor (IndAssociacaoRacaProdutor, CodOrdenacao);
end;

function TAssociacoesRaca.AdicionarAoProdutor(CodAssociacaoRaca: Integer): Integer;
begin
  result := FIntAssociacoesRaca.AdicionarAoProdutor (CodAssociacaoRaca);
end;

function TAssociacoesRaca.RetirarDoProdutor(CodAssociacaoRaca: Integer): Integer;
begin
  result := FIntAssociacoesRaca.RetirarDoProdutor (CodAssociacaoRaca);
end;

function TAssociacoesRaca.AdicionarRaca(CodAssociacaoRaca: Integer;
  const CodRacas: WideString): Integer;
begin
  Result := FIntAssociacoesRaca.AdicionarRaca(CodAssociacaoRaca, CodRacas);
end;

function TAssociacoesRaca.PesquisarRacas(CodAssociacaoRaca: Integer;
  const IndAindaNaoRelacionados, CodOrdenacao: WideString): Integer;
begin
  Result := FIntAssociacoesRaca.PesquisarRacas(CodAssociacaoRaca,
    IndAindaNaoRelacionados, CodOrdenacao);
end;

function TAssociacoesRaca.RetirarRaca(CodAssociacaoRaca: Integer;
  const CodRacas: WideString): Integer;
begin
  Result := FIntAssociacoesRaca.RetirarRaca(CodAssociacaoRaca, CodRacas);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAssociacoesRaca, Class_AssociacoesRaca,
    ciMultiInstance, tmApartment);
end.
