unit uTamanhosFonte;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTamanhosFonte;

type
  TTamanhosFonte = class(TASPMTSObject, ITamanhosFonte)
  private
    FIntTamanhosFonte: TIntTamanhosFonte;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTamanhosFonte.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTamanhosFonte.BeforeDestruction;
begin
  If FIntTamanhosFonte <> nil Then Begin
    FIntTamanhosFonte.Free;
  End;
  inherited;
end;

function TTamanhosFonte.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTamanhosFonte := TIntTamanhosFonte.Create;
  Result := FIntTamanhosFonte.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTamanhosFonte.EOF: WordBool;
begin
  Result := FIntTamanhosFonte.EOF;
end;

function TTamanhosFonte.Pesquisar: Integer;
begin
  Result := FIntTamanhosFonte.Pesquisar;
end;

function TTamanhosFonte.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTamanhosFonte.ValorCampo(NomCampo);
end;

procedure TTamanhosFonte.FecharPesquisa;
begin
  FIntTamanhosFonte.FecharPesquisa;
end;

procedure TTamanhosFonte.IrAoProximo;
begin
  FIntTamanhosFonte.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTamanhosFonte, Class_TamanhosFonte,
    ciMultiInstance, tmApartment);
end.
