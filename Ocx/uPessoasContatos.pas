// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Versão             : 1
// *  Data               : 23/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 52
// *  Descrição Resumida : Cadastro de contatos de uma pessoas
// ************************************************************************
// *  Últimas Alterações
// *
// ************************************************************************

unit uPessoasContatos;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntPessoasContatos;

type
  TPessoasContatos = class(TASPMTSObject, IPessoasContatos)
  private
    FInicializado:       Boolean;
    FIntPessoasContatos: TIntPessoasContatos;

  protected
    function EOF: WordBool; safecall;
    function Inserir(CodPessoa, CodTipoContato: Integer;
      const TxtContato: WideString): Integer; safecall;
    function Pesquisar(CodPessoa: Integer;
      const CodGrupoContato: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    function Alterar(CodPessoa, CodContato, CodTipoContato: Integer;
      const TxtContato: WideString): Integer; safecall;
    function DefinirPrincipal(CodPessoa, CodContato: Integer): Integer;
      safecall;
    function Excluir(CodPessoa, CodContato: Integer): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function BOF: WordBool; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPessoasContatos.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TPessoasContatos.BeforeDestruction;
begin
  If FIntPessoasContatos <> nil Then Begin
    FIntPessoasContatos.Free;
  End;
  inherited;
end;

function TPessoasContatos.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPessoasContatos := TIntPessoasContatos.Create;
  Result := FIntPessoasContatos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPessoasContatos.EOF: WordBool;
begin
  Result := FIntPessoasContatos.EOF;
end;

function TPessoasContatos.Inserir(CodPessoa, CodTipoContato: Integer;
  const TxtContato: WideString): Integer;
begin
  Result := FIntPessoasContatos.Inserir(
              CodPessoa
              , CodTipoContato
              , TxtContato);
end;

function TPessoasContatos.Pesquisar(CodPessoa: Integer;
  const CodGrupoContato: WideString): Integer;
begin
  Result := FIntPessoasContatos.Pesquisar(
              CodPessoa
              , CodGrupoContato);
end;

function TPessoasContatos.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntPessoasContatos.ValorCampo(
              NomCampo);
end;

function TPessoasContatos.Alterar(CodPessoa, CodContato,
  CodTipoContato: Integer; const TxtContato: WideString): Integer;
begin
  Result := FIntPessoasContatos.Alterar(
              CodPessoa
              , CodContato
              , CodTipoContato
              , TxtContato);
end;

function TPessoasContatos.DefinirPrincipal(CodPessoa,
  CodContato: Integer): Integer;
begin
  Result := FIntPessoasContatos.DefinirPrincipal(
              CodPessoa
              , CodContato);
end;

function TPessoasContatos.Excluir(CodPessoa, CodContato: Integer): Integer;
begin
  Result := FIntPessoasContatos.Excluir(
              CodPessoa
              , CodContato);

end;

procedure TPessoasContatos.FecharPesquisa;
begin
  FIntPessoasContatos.FecharPesquisa;
end;

procedure TPessoasContatos.IrAoProximo;
begin
  FIntPessoasContatos.IrAoProximo;
end;

function TPessoasContatos.BOF: WordBool;
begin
  Result := FIntPessoasContatos.BOF;
end;

function TPessoasContatos.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntPessoasContatos.Deslocar(NumDeslocamento);
end;

function TPessoasContatos.NumeroRegistros: Integer;
begin
  Result := FIntPessoasContatos.NumeroRegistros;
end;

procedure TPessoasContatos.IrAoAnterior;
begin
  FIntPessoasContatos.IrAoAnterior;
end;

procedure TPessoasContatos.IrAoPrimeiro;
begin
  FIntPessoasContatos.IrAoPrimeiro;
end;

procedure TPessoasContatos.IrAoUltimo;
begin
  FIntPessoasContatos.IrAoUltimo;
end;

procedure TPessoasContatos.Posicionar(NumPosicao: Integer);
begin
  FIntPessoasContatos.Posicionar(NumPosicao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPessoasContatos, Class_PessoasContatos,
    ciMultiInstance, tmApartment);
end.
