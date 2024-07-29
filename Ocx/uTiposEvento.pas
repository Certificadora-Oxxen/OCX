// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 09/09/2002
// *  Documentação       : Eventos de Movimentação - Especificação das
// *                       classes.doc
// *  Código Classe      : 56
// *  Descrição Resumida : Cadastro de Tipos de Eventos
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/09/2002    Criação
// *
// ********************************************************************
unit uTiposEvento;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposEvento;

type
  TTiposEvento = class(TASPMTSObject, ITiposEvento)
  private
    FIntTiposEvento : TIntTiposEvento;
    FInicializado : Boolean;
  protected
    function Pesquisar(CodGrupoEvento: Integer; const IndEventoSisBov,
      IndRestritoSistema: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure FecharPesquisa; safecall;
    function PesquisarCoberturas(const IndEventoSisbov, IndRestritoSistema,
      CodOrdenacao: WideString): Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposEvento.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposEvento.BeforeDestruction;
begin
  If FIntTiposEvento <> nil Then Begin
    FIntTiposEvento.Free;
  End;
  inherited;
end;

function TTiposEvento.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposEvento := TIntTiposEvento.Create;
  Result := FIntTiposEvento.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;


function TTiposEvento.Pesquisar(CodGrupoEvento: Integer;
  const IndEventoSisBov, IndRestritoSistema: WideString): Integer;
begin
  result := FIntTiposEvento.Pesquisar(CodGrupoEvento,IndEventoSisBov,IndRestritoSistema);
end;

function TTiposEvento.EOF: WordBool;
begin
  result := FIntTiposEvento.Eof;
end;

procedure TTiposEvento.IrAoProximo;
begin
  FIntTiposEvento.IrAoProximo;
end;

function TTiposEvento.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntTiposEvento.ValorCampo(NomCampo);
end;

procedure TTiposEvento.IrAoPrimeiro;
begin
  FIntTiposEvento.IrAoPrimeiro;
end;

procedure TTiposEvento.FecharPesquisa;
begin
  FIntTiposEvento.FecharPesquisa;
end;

function TTiposEvento.PesquisarCoberturas(const IndEventoSisbov,
  IndRestritoSistema, CodOrdenacao: WideString): Integer;
begin
  Result := FIntTiposEvento.PesquisarCoberturas(IndEventoSisbov,
    IndRestritoSistema, CodOrdenacao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposEvento, Class_TiposEvento,
    ciMultiInstance, tmApartment);
end.
