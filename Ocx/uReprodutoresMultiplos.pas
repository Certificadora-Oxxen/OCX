// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 27/11/2002
// *  Documentação       : Animais - Definição das Classes
// *  Código Classe      : 73
// *  Descrição Resumida : Cadastro de Reprodutor Multiplo
// ********************************************************************
// *  Últimas Alterações
// *  Hitalo   27/11/2002  criacao
// *
// ********************************************************************
unit uReprodutoresMultiplos;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMensagens,uConexao,
  uIntReprodutoresMultiplos,uReprodutorMultiplo;

type
  TReprodutoresMultiplos = class(TASPMTSObject, IReprodutoresMultiplos)
  private
    FIntReprodutoresMultiplos : TIntReprodutoresMultiplos;
    FInicializado   : Boolean;
    FReprodutorMultiplo     : TReprodutorMultiplo;
  protected
    function Inserir(CodFazendaManejo: Integer;
      const CodReprodutorMultiploManejo: WideString; CodEspecie: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function Excluir(CodReprodutorMultiplo: Integer): Integer; safecall;
    function Copiar(CodReprodutorMultiplo, CodFazendaManejo: Integer;
      const CodReprodutorMultiploManejo: WideString): Integer; safecall;
    function Alterar(CodReprodutorMultiplo: Integer;
      const CodReprodutorMultiploManejo,
      TxtObservacao: WideString): Integer; safecall;
    function Ativar(CodReprodutorMultiplo: Integer): Integer; safecall;
    function AdicionarTouro(CodReprodutorMultiplo, CodAnimal,
      CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
      DtaInicioUso, DtaFimUso: TDateTime): Integer; safecall;
    function Desativar(CodReprodutorMultiplo: Integer): Integer; safecall;
    function RetirarTouro(CodReprodutorMultiplo, CodAnimal: Integer): Integer;
      safecall;
    function PesquisarTouros(CodReprodutorMultiplo: Integer): Integer;
      safecall;
    function Buscar(CodReprodutorMultiplo: Integer): Integer; safecall;
    function Pesquisar(CodFazendaManejo, CodEspecie: Integer;
      const IndAtivo: WideString; CodAnimal,
      CodFazendaManejoAnimal: Integer;
      const CodAnimalManejo: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    function BOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_ReprodutorMultiplo: IReprodutorMultiplo; safecall;
    function AdicionarTouros(CodReprodutorMultiplo: Integer;
      const CodAnimais: WideString; CodFazendaManejo: Integer;
      const CodAnimaisManejo: WideString; DtaInicioUso,
      DtaFimUso: TDateTime): Integer; safecall;
    function RetirarTouros(CodReprodutorMultiplo: Integer;
      const CodAnimais: WideString; CodFazendaManejo: Integer;
      const CodAnimaisManejo: WideString): Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TReprodutoresMultiplos.AfterConstruction;
begin
  inherited;
  FReprodutorMultiplo := TReprodutorMultiplo.Create;
  FReprodutorMultiplo.ObjAddRef;
  FInicializado := False;
end;

procedure TReprodutoresMultiplos.BeforeDestruction;
begin
  If FIntReprodutoresMultiplos <> nil Then Begin
    FIntReprodutoresMultiplos.Free;
  End;

  If FReprodutorMultiplo <> nil Then Begin
    FReprodutorMultiplo.ObjRelease;
    FReprodutorMultiplo := nil;
  End;
  inherited;
end;

function TReprodutoresMultiplos.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntReprodutoresMultiplos := TIntReprodutoresMultiplos.Create;
  Result := FIntReprodutoresMultiplos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TReprodutoresMultiplos.Inserir(CodFazendaManejo: Integer;
  const CodReprodutorMultiploManejo: WideString; CodEspecie: Integer;
  const TxtObservacao: WideString): Integer;
begin
  result := FIntReprodutoresMultiplos.Inserir(CodFazendaManejo,
  CodReprodutorMultiploManejo, CodEspecie,TxtObservacao);
end;

function TReprodutoresMultiplos.Excluir(
  CodReprodutorMultiplo: Integer): Integer;
begin
  result := FIntReprodutoresMultiplos.Excluir(CodReprodutorMultiplo);
end;

function TReprodutoresMultiplos.Copiar(CodReprodutorMultiplo,
  CodFazendaManejo: Integer;
  const CodReprodutorMultiploManejo: WideString): Integer;
begin
  result := FIntReprodutoresMultiplos.Copiar(CodReprodutorMultiplo,
  CodFazendaManejo, CodReprodutorMultiploManejo);
end;

function TReprodutoresMultiplos.Alterar(CodReprodutorMultiplo: Integer;
  const CodReprodutorMultiploManejo, TxtObservacao: WideString): Integer;
begin
  result := FIntReprodutoresMultiplos.Alterar(CodReprodutorMultiplo, CodReprodutorMultiploManejo,TxtObservacao);
end;

function TReprodutoresMultiplos.Ativar(
  CodReprodutorMultiplo: Integer): Integer;
begin
  result := FIntReprodutoresMultiplos.Ativar(CodReprodutorMultiplo);
end;

function TReprodutoresMultiplos.AdicionarTouro(CodReprodutorMultiplo,
  CodAnimal, CodFazendaManejo: Integer; const CodAnimalManejo: WideString;
  DtaInicioUso, DtaFimUso: TDateTime): Integer;
begin
  result := FIntReprodutoresMultiplos.AdicionarTouro(CodReprodutorMultiplo,
  CodAnimal, CodFazendaManejo, CodAnimalManejo, DtaInicioUso, DtaFimUso);
end;

function TReprodutoresMultiplos.Desativar(
  CodReprodutorMultiplo: Integer): Integer;
begin
  result := FIntReprodutoresMultiplos.Desativar(CodReprodutorMultiplo);
end;

function TReprodutoresMultiplos.RetirarTouro(CodReprodutorMultiplo,
  CodAnimal: Integer): Integer;
begin
  result := FIntReprodutoresMultiplos.RetirarTouro(CodReprodutorMultiplo,CodAnimal);
end;

function TReprodutoresMultiplos.PesquisarTouros(
  CodReprodutorMultiplo: Integer): Integer;
begin
  result := FIntReprodutoresMultiplos.PesquisarTouros(CodReprodutorMultiplo);
end;

function TReprodutoresMultiplos.Buscar(
  CodReprodutorMultiplo: Integer): Integer;
begin
   result := FIntReprodutoresMultiplos.Buscar(CodReprodutorMultiplo);
end;

function TReprodutoresMultiplos.Pesquisar(CodFazendaManejo,
  CodEspecie: Integer; const IndAtivo: WideString; CodAnimal,
  CodFazendaManejoAnimal: Integer;
  const CodAnimalManejo: WideString): Integer;
begin
  result := FIntReprodutoresMultiplos.Pesquisar(CodFazendaManejo,
  CodEspecie,IndAtivo, CodAnimal, CodFazendaManejoAnimal,CodAnimalManejo);
end;

function TReprodutoresMultiplos.EOF: WordBool;
begin
  result := FIntReprodutoresMultiplos.EOF;
end;

function TReprodutoresMultiplos.BOF: WordBool;
begin
  result := FIntReprodutoresMultiplos.BOF;
end;

function TReprodutoresMultiplos.NumeroRegistros: Integer;
begin
  result := FIntReprodutoresMultiplos.NumeroRegistros;
end;

function TReprodutoresMultiplos.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  result := FIntReprodutoresMultiplos.ValorCampo(NomColuna);
end;

procedure TReprodutoresMultiplos.FecharPesquisa;
begin
  FIntReprodutoresMultiplos.FecharPesquisa;
end;

procedure TReprodutoresMultiplos.IrAoAnterior;
begin
  FIntReprodutoresMultiplos.IrAoAnterior;
end;

procedure TReprodutoresMultiplos.IrAoPrimeiro;
begin
  FIntReprodutoresMultiplos.IrAoPrimeiro;
end;

procedure TReprodutoresMultiplos.IrAoProximo;
begin
  FIntReprodutoresMultiplos.IrAoProximo;
end;

procedure TReprodutoresMultiplos.IrAoUltimo;
begin
  FIntReprodutoresMultiplos.IrAoUltimo;
end;

function TReprodutoresMultiplos.Deslocar(
  NumDeslocamento: Integer): Integer;
begin
 result := FIntReprodutoresMultiplos.Deslocar(NumDeslocamento);
end;

procedure TReprodutoresMultiplos.Posicionar(NumPosicao: Integer);
begin
  FIntReprodutoresMultiplos.Posicionar(NumPosicao);
end;

function TReprodutoresMultiplos.Get_ReprodutorMultiplo: IReprodutorMultiplo;
begin
  FReprodutorMultiplo.CodPessoaProdutor            := FIntReprodutoresMultiplos.IntReprodutorMultiplo.CodPessoaProdutor;
  FReprodutorMultiplo.CodReprodutorMultiplo        := FIntReprodutoresMultiplos.IntReprodutorMultiplo.CodReprodutorMultiplo;
  FReprodutorMultiplo.CodFazendaManejo             := FIntReprodutoresMultiplos.IntReprodutorMultiplo.CodFazendaManejo;
  FReprodutorMultiplo.SglFazendaManejo             := FIntReprodutoresMultiplos.IntReprodutorMultiplo.SglFazendaManejo;
  FReprodutorMultiplo.NomFazendaManejo             := FIntReprodutoresMultiplos.IntReprodutorMultiplo.NomFazendaManejo;
  FReprodutorMultiplo.CodReprodutorMultiploManejo  := FIntReprodutoresMultiplos.IntReprodutorMultiplo.CodReprodutorMultiploManejo;
  FReprodutorMultiplo.CodEspecie                   := FIntReprodutoresMultiplos.IntReprodutorMultiplo.CodEspecie;
  FReprodutorMultiplo.SglEspecie                   := FIntReprodutoresMultiplos.IntReprodutorMultiplo.SglEspecie;
  FReprodutorMultiplo.DesEspecie                   := FIntReprodutoresMultiplos.IntReprodutorMultiplo.DesEspecie;
  FReprodutorMultiplo.TxtObservacao                := FIntReprodutoresMultiplos.IntReprodutorMultiplo.txtObservacao;
  FReprodutorMultiplo.IndAtivo                     := FIntReprodutoresMultiplos.IntReprodutorMultiplo.IndAtivo;
  FReprodutorMultiplo.DtaCadastramento             := FIntReprodutoresMultiplos.IntReprodutorMultiplo.DtaCadastramento;

  result := FReprodutorMultiplo;
end;

function TReprodutoresMultiplos.AdicionarTouros(
  CodReprodutorMultiplo: Integer; const CodAnimais: WideString;
  CodFazendaManejo: Integer; const CodAnimaisManejo: WideString;
  DtaInicioUso, DtaFimUso: TDateTime): Integer;
begin
  result := FIntReprodutoresMultiplos.AdicionarTouros(CodReprodutorMultiplo,
  CodAnimais, CodFazendaManejo, CodAnimaisManejo, DtaInicioUso, DtaFimUso);
end;

function TReprodutoresMultiplos.RetirarTouros(
  CodReprodutorMultiplo: Integer; const CodAnimais: WideString;
  CodFazendaManejo: Integer; const CodAnimaisManejo: WideString): Integer;
begin
  result := FIntReprodutoresMultiplos.RetirarTouros(CodReprodutorMultiplo,
  CodAnimais, CodFazendaManejo, CodAnimaisManejo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TReprodutoresMultiplos, Class_ReprodutoresMultiplos,
    ciMultiInstance, tmApartment);
end.
