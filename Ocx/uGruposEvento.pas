// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 09/09/2002
// *  Documentação       : Eventos de Movimentação - Especificação das
// *                       classes.doc
// *  Código Classe      : 55
// *  Descrição Resumida : Cadastro de Grupos de Eventos
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/09/2002    Criação
// *
// ********************************************************************
unit uGruposEvento;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntGruposEvento;

type
  TGruposEvento = class(TASPMTSObject, IGruposEvento)
  private
    FIntGruposEvento : TIntGruposEvento;
    FInicializado : Boolean;
  protected
     function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TGruposEvento.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TGruposEvento.BeforeDestruction;
begin
  If FIntGruposEvento <> nil Then Begin
    FIntGruposEvento.Free;
  End;
  inherited;
end;

function TGruposEvento.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGruposEvento := TIntGruposEvento.Create;
  Result := FIntGruposEvento.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGruposEvento.EOF: WordBool;
begin
  result := FIntGruposEvento.Eof;
end;

function TGruposEvento.Pesquisar: Integer;
begin
  result := FIntGruposEvento.Pesquisar;
end;

function TGruposEvento.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntGruposEvento.ValorCampo(NomCampo);
end;

procedure TGruposEvento.FecharPesquisa;
begin
  FIntGruposEvento.FecharPesquisa;
end;

procedure TGruposEvento.IrAoPrimeiro;
begin
  FIntGruposEvento.IrAoPrimeiro;
end;

procedure TGruposEvento.IrAoProximo;
begin
  FIntGruposEvento.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGruposEvento, Class_GruposEvento,
    ciMultiInstance, tmApartment);
end.
