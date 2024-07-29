unit uMenus;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMenus, uConexao, uIntMensagens;

type
  TMenus = class(TASPMTSObject, IMenus)
  private
    FIntMenu : TIntMenus;
    FInicializado : Boolean;
  protected
    function Pesquisar(CodPapel: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure FecharPesquisa; safecall;
  public
    procedure AfterConstruction(); override;
    procedure BeforeDestruction(); override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

function TMenus.Pesquisar(CodPapel: Integer): Integer;
begin
  Result := FIntMenu.Pesquisar(CodPapel);
end;

function TMenus.EOF(): WordBool;
begin
  Result := FIntMenu.EOF();
end;

function TMenus.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntMenu.ValorCampo(NomCampo);
end;

procedure TMenus.IrAoPrimeiro();
begin
  FIntMenu.IrAoPrimeiro();
end;

procedure TMenus.IrAoProximo();
begin
  FIntMenu.IrAoProximo();
end;

procedure TMenus.FecharPesquisa();
begin
  FIntMenu.FecharPesquisa();
end;

procedure TMenus.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TMenus.BeforeDestruction;
begin
  If FIntMenu <> nil Then Begin
    FIntMenu.Free;
  End;
  inherited;
end;

function TMenus.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntMenu := TIntMenus.Create;
  Result := FIntMenu.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMenus, Class_Menus,
    ciMultiInstance, tmApartment);
end.
