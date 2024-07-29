unit uTiposMensagem;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntTiposMensagem, uIntMensagens;

type
  TTiposMensagem = class(TASPMTSObject, ITiposMensagem)
  private
    FIntTiposMensagem: TIntTiposMensagem;
    FInicializado: Boolean;
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

function TTiposMensagem.EOF: WordBool;
begin
  Result := FIntTiposMensagem.EOF;
end;

function TTiposMensagem.Pesquisar: Integer;
begin
  Result := FIntTiposMensagem.Pesquisar;
end;

function TTiposMensagem.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposMensagem.ValorCampo(NomCampo);
end;

procedure TTiposMensagem.FecharPesquisa;
begin
  FIntTiposMensagem.FecharPesquisa;
end;

procedure TTiposMensagem.IrAoPrimeiro;
begin
  FIntTiposMensagem.IrAoPrimeiro;
end;

procedure TTiposMensagem.IrAoProximo;
begin
  FIntTiposMensagem.IrAoProximo;
end;

procedure TTiposMensagem.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposMensagem.BeforeDestruction;
begin
  inherited;
  If FIntTiposMensagem <> nil Then Begin
    FIntTiposMensagem.Free;
  End;
end;

function TTiposMensagem.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposMensagem := TIntTiposMensagem.Create;
  Result := FIntTiposMensagem.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposMensagem, Class_TiposMensagem,
    ciMultiInstance, tmApartment);
end.
