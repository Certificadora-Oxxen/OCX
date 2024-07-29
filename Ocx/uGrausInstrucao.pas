// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Pessoas, Pessoas Secundárias - Definição das
// *                       classes.doc
// *  Código Classe      : 50
// *  Descrição Resumida : Cadastro de Graus Instrucao
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    15/08/2002    Criação
// *
// ********************************************************************
unit uGrausInstrucao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntGrausInstrucao;

type
  TGrausInstrucao = class(TASPMTSObject, IGrausInstrucao)
  private
    FIntGrausInstrucao : TIntGrausInstrucao;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TGrausInstrucao.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TGrausInstrucao.BeforeDestruction;
begin
  If FIntGrausInstrucao <> nil Then Begin
    FIntGrausInstrucao.Free;
  End;
  inherited;
end;

function TGrausInstrucao.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGrausInstrucao := TIntGrausInstrucao.Create;
  Result := FIntGrausInstrucao.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGrausInstrucao.EOF: WordBool;
begin
  result := FIntGrausInstrucao.EOF;
end;

function TGrausInstrucao.Pesquisar(
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntGrausInstrucao.Pesquisar(CodOrdenacao);
end;

procedure TGrausInstrucao.IrAoProximo;
begin
  FIntGrausInstrucao.IrAoProximo;
end;

function TGrausInstrucao.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntGrausInstrucao.ValorCampo(NomCampo);
end;

procedure TGrausInstrucao.FecharPesquisa;
begin
  FIntGrausInstrucao.FecharPesquisa;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrausInstrucao, Class_GrausInstrucao,
    ciMultiInstance, tmApartment);
end.
