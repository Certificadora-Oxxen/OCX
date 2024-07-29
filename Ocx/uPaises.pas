// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 18/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Paises
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    18/07/2002    Criação
// *   Hitalo    09/08/2002    Adiciona metodo PaisCertificadora
// *
// ********************************************************************
unit uPaises;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntPaises,uPais;

type
  TPaises = class(TASPMTSObject, IPaises)
  private
    FIntPaises    : TIntPaises;
    FInicializado : Boolean;
    FPais         : TPais;
  protected
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Inserir(const NomPais: WideString;
      CodPaisSisBov: Integer): Integer; safecall;
    function Alterar(CodPais: Integer; const NomPais: WideString;
      CodPaisSisBov: Integer): Integer; safecall;
    function Excluir(CodPais: Integer): Integer; safecall;
    function Buscar(CodPais: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    function Get_Pais: IPais; safecall;
    function PaisCertificadora: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;
implementation

uses ComServ;

procedure TPaises.AfterConstruction;
begin
  inherited;
  FPais := TPais.Create;
  FPais.ObjAddRef;
  FInicializado := False;
end;

procedure TPaises.BeforeDestruction;
begin
  If FIntPaises <> nil Then Begin
    FIntPaises.Free;
  End;
  If FPais <> nil Then Begin
    FPais.ObjRelease;
    FPais := nil;
  End;
  inherited;
end;

function TPaises.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPaises := TIntPaises.Create;
  Result := FIntPaises.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPaises.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  Result := FIntPaises.Pesquisar(CodOrdenacao);
end;

function TPaises.EOF: WordBool;
begin
  Result := FIntPaises.EOF;
end;

function TPaises.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPaises.ValorCampo(NomeColuna);
end;

procedure TPaises.FecharPesquisa;
begin
  FIntPaises.FecharPesquisa;
end;

procedure TPaises.IrAoProximo;
begin
  FIntPaises.IrAoProximo;
end;

function TPaises.Inserir(const NomPais: WideString;
  CodPaisSisBov: Integer): Integer;
begin
  result :=  FIntPaises.Inserir(NomPais,CodPaisSisBov);
end;

function TPaises.Alterar(CodPais: Integer; const NomPais: WideString;
  CodPaisSisBov: Integer): Integer;
begin
  result :=  FIntPaises.Alterar(CodPais,NomPais,CodPaisSisBov);
end;

function TPaises.Excluir(CodPais: Integer): Integer;
begin
  result :=  FIntPaises.Excluir(CodPais);
end;

function TPaises.Buscar(CodPais: Integer): Integer;
begin
  result :=  FIntPaises.Buscar(CodPais);
end;

function TPaises.NumeroRegistros: Integer;
begin
  result :=  FIntPaises.NumeroRegistros;
end;

procedure TPaises.IrAoAnterior;
begin
  FIntPaises.IrAoAnterior;
end;

procedure TPaises.IrAoPrimeiro;
begin
  FIntPaises.IrAoPrimeiro;
end;

procedure TPaises.IrAoUltimo;
begin
  FIntPaises.IrAoUltimo;
end;

procedure TPaises.Posicionar(NumPosicao: Integer);
begin
  FIntPaises.Posicionar(NumPosicao);
end;

procedure TPaises.Deslocar(NumDeslocamento: Integer);
begin
  FIntPaises.Deslocar(NumDeslocamento);
end;

function TPaises.Get_Pais: IPais;
begin
  FPais.CodPais          := FIntPaises.IntPais.CodPais;
  FPais.NomPais          := FIntPaises.IntPais.NomPais;
  FPais.CodPaisSisBov    := FIntPaises.IntPais.CodPaisSisBov;
  result := FPais;
end;

function TPaises.PaisCertificadora: Integer;
begin
  Result := FIntPaises.PaisCertificadora;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPaises, Class_Paises,
    ciMultiInstance, tmApartment);
end.
