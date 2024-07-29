// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 03/09/2002
// *  Documenta��o       :
// *  Classe             : 55
// *  Descri��o Resumida : Pesquisa de Grandezas Resumo
// ********************************************************************
// *  �ltimas Altera��es
// *   Hitalo    03/09/2002    Cria��o.
// *
// ********************************************************************
unit uGrandezasResumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntGrandezasResumo, uConexao, uIntMensagens;

type
  TGrandezasResumo = class(TASPMTSObject, IGrandezasResumo)
  private
    FIntGrandezasResumo : TIntGrandezasResumo;
    FInicializado  : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TGrandezasResumo.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TGrandezasResumo.BeforeDestruction;
begin
  If FIntGrandezasResumo <> nil Then Begin
    FIntGrandezasResumo.Free;
  End;
  inherited;
end;

function TGrandezasResumo.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGrandezasResumo := TIntGrandezasResumo.Create;
  Result := FIntGrandezasResumo.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGrandezasResumo.EOF: WordBool;
begin
  result := FIntGrandezasResumo.EOF;
end;

function TGrandezasResumo.Pesquisar: Integer;
begin
  result := FIntGrandezasResumo.Pesquisar;
end;

function TGrandezasResumo.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntGrandezasResumo.ValorCampo(NomCampo);
end;

procedure TGrandezasResumo.FecharPesquisa;
begin
  FIntGrandezasResumo.FecharPesquisa;
end;

procedure TGrandezasResumo.IrAoPrimeiro;
begin
  FIntGrandezasResumo.IrAoPrimeiro;
end;

procedure TGrandezasResumo.IrAoProximo;
begin
  FIntGrandezasResumo.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGrandezasResumo, Class_GrandezasResumo,
    ciMultiInstance, tmApartment);
end.
