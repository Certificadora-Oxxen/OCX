// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Raças de Animal
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *   Hitalo    29/07/2002    Adicionar métodos Inserir, Excluir, Alterar
// *                           e Buscar.
// *   Hítalo    10/09/2002   Adiconar propriedade CodRacaSisBov.
// *   Hítalo    19/09/2002   Adiconar métodos AdicionarAptidao, RetirarAptidao,PossuiAptidao
// *   Hítalo    19/09/2002   Alterar os métodos Inserir(CodEspecie),Buscar(CodEspecie,DesEspecie,Sglespecie)
// *   Carlos    26/08/2002   Adicionar o método PesquisarDoProdutor(CodOrdenacao)
// *   Carlos    28/08/2002   Adicionar os métodos AdicionarAoProdutor(CodRaca) e RetirarDoProdutor(CodRaca)
// *
// *
// ********************************************************************

unit uRacas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntRacas,uRaca;

type
  TRacas = class(TASPMTSObject, IRacas)
  private
    FIntRacas     : TIntRacas;
    FInicializado : Boolean;
    FRaca         : TRaca;
  protected
    function Pesquisar(CodEspecie, CodAptidao: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Inserir(const SglRaca, DesRaca, IndRacaPura,
      CodRacaSisBov: WideString; CodEspecie: Integer;
      const IndDefaultProdutor: WideString;
      QtdPesoPadraoNascimento: Double; QtdMinDiasGestacao,
      QtdMaxDiasGestacao: Integer; const CodRacaAbcz: WideString): Integer;
      safecall;
    function Alterar(CodRaca: Integer; const SglRaca, DesRaca, IndRacaPura,
      CodRacaSisBov, IndDefaultProdutor: WideString;
      QtdPesoPadraoNascimento: Double; QtdMinDiasGestacao,
      QtdMaxDiasGestacao: Integer; const CodRacaAbcz: WideString): Integer;
      safecall;
    function Excluir(CodRaca: Integer): Integer; safecall;
    function Buscar(CodRaca: Integer): Integer; safecall;
    function Get_Raca: IRaca; safecall;
    function AdicionarAptidao(CodRaca, CodAptidao: Integer): Integer; safecall;
    function PossuiAptidao(CodRaca, CodAptidao: Integer): Integer; safecall;
    function RetirarAptidao(CodRaca, CodAptidao: Integer): Integer; safecall;
    function PesquisarDoProdutor(const IndRacaProdutor: WideString;
      CodEspecie: Integer; const CodOrdenacao: WideString): Integer;
      safecall;
    function AdicionarAoProdutor(CodRaca: Integer): Integer; safecall;
    function RetirarDoProdutor(CodRaca: Integer): Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    function GerarRelatorio(CodEspecie: Integer;
      const CodOrdenacao: WideString; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
    function PesquisarAgrupamentos(CodRaca,
      CodTipoAgrupRacas: Integer): Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TRacas.AfterConstruction;
begin
  inherited;
  FRaca := TRaca.Create;
  FRaca.ObjAddRef;
  FInicializado := False;
end;

procedure TRacas.BeforeDestruction;
begin
  If FIntRacas <> nil Then Begin
    FIntRacas.Free;
  End;
  If FRaca <> nil Then Begin
    FRaca.ObjRelease;
    FRaca := nil;
  End;
  inherited;
end;

function TRacas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRacas := TIntRacas.Create;
  Result := FIntRacas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TRacas.Pesquisar(CodEspecie, CodAptidao: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntRacas.Pesquisar (CodEspecie, CodAptidao,CodOrdenacao);
end;

function TRacas.EOF: WordBool;
begin
  result := FIntRacas.EOF;
end;

function TRacas.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  result := FIntRacas.ValorCampo(NomeColuna);
end;

procedure TRacas.FecharPesquisa;
begin
  FIntRacas.FecharPesquisa;
end;

procedure TRacas.IrAoProximo;
begin
  FIntRacas.IrAoProximo;
end;

function TRacas.Inserir(const SglRaca, DesRaca, IndRacaPura,
  CodRacaSisBov: WideString; CodEspecie: Integer;
  const IndDefaultProdutor: WideString; QtdPesoPadraoNascimento: Double;
  QtdMinDiasGestacao, QtdMaxDiasGestacao: Integer;
  const CodRacaAbcz: WideString): Integer;
begin
  result := FIntRacas.Inserir(SglRaca, DesRaca,IndRacaPura,CodRacaSisBov,CodEspecie,IndDefaultProdutor,
                              QtdPesoPadraoNascimento, QtdMinDiasGestacao, QtdMaxDiasGestacao, CodRacaAbcz);
end;

function TRacas.Alterar(CodRaca: Integer; const SglRaca, DesRaca,
  IndRacaPura, CodRacaSisBov, IndDefaultProdutor: WideString;
  QtdPesoPadraoNascimento: Double; QtdMinDiasGestacao,
  QtdMaxDiasGestacao: Integer; const CodRacaAbcz: WideString): Integer;
begin
  result := FIntRacas.Alterar(CodRaca,SglRaca, DesRaca,
                              IndRacaPura,CodRacaSisBov, IndDefaultProdutor,QtdPesoPadraoNascimento,
                              QtdMinDiasGestacao, QtdMaxDiasGestacao, CodRacaAbcz);
end;

function TRacas.Excluir(CodRaca: Integer): Integer;
begin
  result := FIntRacas.Excluir(CodRaca);
end;

function TRacas.Buscar(CodRaca: Integer): Integer;
begin
  result := FIntRacas.Buscar(CodRaca);
end;

function TRacas.Get_Raca: IRaca;
begin
  FRaca.CodRaca          := FIntRacas.IntRaca.CodRaca;
  FRaca.SglRaca          := FIntRacas.IntRaca.SglRaca;
  FRaca.DesRaca          := FIntRacas.IntRaca.DesRaca;
  FRaca.IndRacaPura      := FIntRacas.IntRaca.IndRacaPura;
  FRaca.codRacaSisBov    := FIntRacas.IntRaca.codRacaSisBov;
  FRaca.CodEspecie       := FIntRacas.IntRaca.CodEspecie;
  FRaca.SglEspecie       := FIntRacas.IntRaca.SglEspecie;
  FRaca.DesEspecie       := FIntRacas.IntRaca.DesEspecie;
  FRaca.IndDefaultProdutor := FIntRacas.IntRaca.IndDefaultProdutor;
  FRaca.QtdPesoPadraoNascimento := FIntRacas.IntRaca.QtdPesoPadraoNascimento;
  FRaca.QtdMinDiasGestacao := FIntRacas.IntRaca.QtdMinDiasGestacao;
  FRaca.QtdMaxDiasGestacao := FIntRacas.IntRaca.QtdMaxDiasGestacao;
  FRaca.CodRacaAbcz      := FIntRacas.IntRaca.CodRacaAbcz;
  Result := FRaca;
end;

function TRacas.AdicionarAptidao(CodRaca, CodAptidao: Integer): Integer;
begin
  result := FIntRacas.AdicionarAptidao(CodRaca, CodAptidao);
end;

function TRacas.PossuiAptidao(CodRaca, CodAptidao: Integer): Integer;
begin
  result := FIntRacas.PossuiAptidao(CodRaca, CodAptidao);
end;

function TRacas.RetirarAptidao(CodRaca, CodAptidao: Integer): Integer;
begin
  result := FIntRacas.RetirarAptidao(CodRaca, CodAptidao);
end;

function TRacas.PesquisarDoProdutor(const IndRacaProdutor: WideString;
  CodEspecie: Integer; const CodOrdenacao: WideString): Integer;
begin
  result := FIntRacas.PesquisarDoProdutor (IndRacaProdutor, CodEspecie, CodOrdenacao);
end;

function TRacas.AdicionarAoProdutor(CodRaca: Integer): Integer;
begin
  result := FIntRacas.AdicionarAoProdutor (CodRaca);
end;

function TRacas.RetirarDoProdutor(CodRaca: Integer): Integer;
begin
  result := FIntRacas.RetirarDoProdutor (CodRaca);
end;

procedure TRacas.IrAoPrimeiro;
begin
  FIntRacas.IrAoPrimeiro;
end;

function TRacas.GerarRelatorio(CodEspecie: Integer;
  const CodOrdenacao: WideString; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  result := FIntRacas.GerarRelatorio(CodEspecie,CodOrdenacao,Tipo,QtdQuebraRelatorio);
end;

function TRacas.PesquisarAgrupamentos(CodRaca,
  CodTipoAgrupRacas: Integer): Integer;
begin
  result := FIntRacas.PesquisarAgrupamentos(CodRaca, CodTipoAgrupRacas);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRacas, Class_Racas,
    ciMultiInstance, tmApartment);
end.
