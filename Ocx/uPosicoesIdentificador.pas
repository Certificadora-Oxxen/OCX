// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Atributos Animais - Definição das
// *                       classes.doc
// *  Código Classe      : 51
// *  Descrição Resumida : Cadastro de Posicão do Indentificador
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    15/08/2002    Criação
// *
// ********************************************************************
unit uPosicoesIdentificador;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntPosicoesIdentificador;

type
  TPosicoesIdentificador = class(TASPMTSObject, IPosicoesIdentificador)
  private
    FIntPosicoesIdentificador : TIntPosicoesIdentificador;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodGrupoIdentificador,
      CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function PesquisarRelacionamentos: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPosicoesIdentificador.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TPosicoesIdentificador.BeforeDestruction;
begin
  If FIntPosicoesIdentificador <> nil Then Begin
    FIntPosicoesIdentificador.Free;
  End;
  inherited;
end;

function TPosicoesIdentificador.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPosicoesIdentificador := TIntPosicoesIdentificador.Create;
  Result := FIntPosicoesIdentificador.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPosicoesIdentificador.EOF: WordBool;
begin
  result := FIntPosicoesIdentificador.EOF;
end;

function TPosicoesIdentificador.Pesquisar(const CodGrupoIdentificador,
  CodOrdenacao: WideString): Integer;
begin
  result := FIntPosicoesIdentificador.Pesquisar(CodGrupoIdentificador,CodOrdenacao);
end;

function TPosicoesIdentificador.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntPosicoesIdentificador.ValorCampo(NomCampo);
end;

procedure TPosicoesIdentificador.FecharPesquisa;
begin
  FIntPosicoesIdentificador.FecharPesquisa;
end;

procedure TPosicoesIdentificador.IrAoPrimeiro;
begin
  FIntPosicoesIdentificador.IrAoPrimeiro;
end;

procedure TPosicoesIdentificador.IrAoProximo;
begin
  FIntPosicoesIdentificador.IrAoProximo;
end;

function TPosicoesIdentificador.PesquisarRelacionamentos: Integer;
begin
  result := FIntPosicoesIdentificador.PesquisarRelacionamentos;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPosicoesIdentificador, Class_PosicoesIdentificador,
    ciMultiInstance, tmApartment);
end.
