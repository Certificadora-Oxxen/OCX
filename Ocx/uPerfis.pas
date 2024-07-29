// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Perfil do Usuário
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *
// *
// *
// ********************************************************************
unit uPerfis;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uPerfil,
  uIntPerfis;

type
  TPerfis = class(TASPMTSObject, IPerfis)
  private
    FIntPerfis : TIntPerfis;
    FInicializado : Boolean;
    FPerfil: TPerfil;
  protected
    function Pesquisar(CodPapel: Integer; IndPesquisarDesativados: WordBool): Integer; safecall;
//    function Pesquisar(CodPapel: Integer): Integer; safecall;
    function Buscar(CodPerfil: Integer): Integer; safecall;
    function Excluir(CodPerfil: Integer): Integer; safecall;
    function Alterar(CodPerfil: Integer; const NomPerfil,
      DesPerfil: WideString): Integer; safecall;
    function Inserir(const NomPerfil: WideString; CodPapel: Integer;
      const DesPerfil: WideString): Integer; safecall;

    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Get_Inicializado: WordBool; safecall;
    function Get_Perfil: IPerfil; safecall;
    function ExcluirFuncao(CodPerfil, CodFuncao: Integer): Integer; safecall;
    function ExcluirItemMenu(CodPerfil, CodItemMenu: Integer): Integer;
      safecall;
    function InserirFuncao(CodPerfil, CodFuncao: Integer): Integer; safecall;
    function InserirItemMenu(CodPerfil, CodItemMenu: Integer): Integer;
      safecall;
    function PesquisarFuncoes(CodPerfil, CodMenu: Integer): Integer; safecall;
    function PesquisarItemMenu(CodPerfil, CodMenu: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPerfis.AfterConstruction;
begin
  inherited;
  FPerfil := TPerfil.Create;
  FPerfil.ObjAddRef;
  FInicializado := False;
end;

procedure TPerfis.BeforeDestruction;
begin
  If FIntPerfis <> nil Then Begin
    FIntPerfis.Free;
  End;
  If FPerfil <> nil Then Begin
    FPerfil.ObjRelease;
    FPerfil := nil;
  End;
  inherited;
end;

function TPerfis.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPerfis := TIntPerfis.Create;
  Result := FIntPerfis.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPerfis.BOF: WordBool;
begin
  Result := FIntPerfis.BOF;
end;

function TPerfis.Buscar(CodPerfil: Integer): Integer;
begin
  Result := FIntPerfis.Buscar(CodPerfil);
end;

function TPerfis.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntPerfis.Deslocar(QtdRegistros);
end;

function TPerfis.EOF: WordBool;
begin
  Result := FIntPerfis.EOF;
end;

function TPerfis.Excluir(CodPerfil: Integer): Integer;
begin
  Result := FIntPerfis.Excluir(CodPerfil);
end;

function TPerfis.Inserir(const NomPerfil: WideString; CodPapel: Integer;
  const DesPerfil: WideString): Integer;
begin
  Result := FIntPerfis.Inserir(NomPerfil, CodPapel, DesPerfil);
end;

function TPerfis.NumeroRegistros: Integer;
begin
  Result := FIntPerfis.NumeroRegistros;
end;

function TPerfis.Pesquisar(CodPapel: Integer;IndPesquisarDesativados: WordBool): Integer;
begin
  Result := FIntPerfis.Pesquisar(CodPapel,IndPesquisarDesativados);
end;

function TPerfis.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPerfis.ValorCampo(NomeColuna);
end;

procedure TPerfis.FecharPesquisa;
begin
  FIntPerfis.FecharPesquisa;
end;

procedure TPerfis.IrAoAnterior;
begin
  FIntPerfis.IrAoAnterior;
end;

procedure TPerfis.IrAoPrimeiro;
begin
  FIntPerfis.IrAoPrimeiro;
end;

procedure TPerfis.IrAoProximo;
begin
  FIntPerfis.IrAoProximo;
end;

procedure TPerfis.IrAoUltimo;
begin
  FIntPerfis.IrAoUltimo;
end;

procedure TPerfis.Posicionar(NumRegistro: Integer);
begin
  FIntPerfis.Posicionar(NumRegistro);
end;

function TPerfis.Alterar(CodPerfil: Integer; const NomPerfil,
  DesPerfil: WideString): Integer;
begin
  Result := FIntPerfis.Alterar(CodPerfil, NomPerfil, DesPerfil);
end;

function TPerfis.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TPerfis.Get_Perfil: IPerfil;
begin
  FPerfil.CodPerfil       := FIntPerfis.IntPerfil.CodPerfil;
  FPerfil.NomPerfil       := FIntPerfis.IntPerfil.NomPerfil;
  FPerfil.CodPapel        := FIntPerfis.IntPerfil.CodPapel;
  FPerfil.DesPapel        := FIntPerfis.IntPerfil.DesPapel;
  FPerfil.DesPerfil       := FIntPerfis.IntPerfil.DesPerfil;
  FPerfil.DtaFimValidade  := FIntPerfis.IntPerfil.DtaFimValidade;
  Result := FPerfil;
end;

function TPerfis.ExcluirFuncao(CodPerfil, CodFuncao: Integer): Integer;
begin
  Result := FIntPerfis.ExcluirFuncao(CodPerfil, CodFuncao);
end;

function TPerfis.ExcluirItemMenu(CodPerfil, CodItemMenu: Integer): Integer;
begin
  Result := FIntPerfis.ExcluirItemMenu(CodPerfil, CodItemMenu);
end;

function TPerfis.InserirFuncao(CodPerfil, CodFuncao: Integer): Integer;
begin
 Result := FIntPerfis.InserirFuncao(CodPerfil, CodFuncao);
end;

function TPerfis.InserirItemMenu(CodPerfil, CodItemMenu: Integer): Integer;
begin
  Result := FIntPerfis.InserirItemMenu(CodPerfil, CodItemMenu);
end;

function TPerfis.PesquisarFuncoes(CodPerfil, CodMenu: Integer): Integer;
begin
  Result := FIntPerfis.PesquisarFuncoes(CodPerfil, CodMenu);
end;

function TPerfis.PesquisarItemMenu(CodPerfil, CodMenu: Integer): Integer;
begin
  Result := FIntPerfis.PesquisarItemMenu(CodPerfil, CodMenu);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPerfis, Class_Perfis,
    ciMultiInstance, tmApartment);
end.
