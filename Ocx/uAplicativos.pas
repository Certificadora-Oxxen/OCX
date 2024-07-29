unit uAplicativos;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntAplicativos, uConexao, uIntMensagens;

type
  TAplicativos = class(TASPMTSObject, IAplicativos)
  private
    FIntAplicativos: TIntAplicativos;
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

uses ComServ, uIntClassesBasicas;

function TAplicativos.EOF: WordBool;
begin
  Result := FIntAplicativos.EOF();
end;

function TAplicativos.Pesquisar: Integer;
begin
  Result := FIntAplicativos.Pesquisar();
end;

function TAplicativos.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntAplicativos.ValorCampo(NomCampo);
end;

procedure TAplicativos.FecharPesquisa;
begin
  FIntAplicativos.FecharPesquisa();
end;

procedure TAplicativos.IrAoPrimeiro;
begin
  FIntAplicativos.IrAoPrimeiro();
end;

procedure TAplicativos.IrAoProximo;
begin
  FIntAplicativos.IrAoProximo();
end;

procedure TAplicativos.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TAplicativos.BeforeDestruction;
begin
  inherited;
  If FIntAplicativos <> nil Then Begin
    FIntAplicativos.Free;
  End;  
end;

function TAplicativos.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAplicativos := TIntAplicativos.Create;
  Result := FIntAplicativos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAplicativos, Class_Aplicativos,
    ciMultiInstance, tmApartment);
end.
