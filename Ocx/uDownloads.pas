unit uDownloads;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntDownloads;

type
  TDownloads = class(TASPMTSObject, IDownloads)
  private
    FIntDownloads: TIntDownloads;
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
    function Inicializar(EConexaoBD: TConexao;
                         EMensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

function TDownloads.EOF: WordBool;
begin
  Result := FIntDownloads.EOF;
end;

function TDownloads.Pesquisar: Integer;
begin
  Result := FIntDownloads.Pesquisar;
end;

function TDownloads.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntDownloads.ValorCampo(NomCampo);
end;

procedure TDownloads.FecharPesquisa;
begin
  FIntDownloads.FecharPesquisa;
end;

procedure TDownloads.IrAoPrimeiro;
begin
  FIntDownloads.IrAoPrimeiro;
end;

procedure TDownloads.IrAoProximo;
begin
  FIntDownloads.IrAoProximo;
end;

procedure TDownloads.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TDownloads.BeforeDestruction;
begin
  inherited;
  if FIntDownloads <> nil then
  begin
    FIntDownloads.Free;
  end;
end;

function TDownloads.Inicializar(EConexaoBD: TConexao;
                                EMensagens: TIntMensagens): Integer;
begin
  FIntDownloads := TIntDownloads.Create;
  Result := FIntDownloads.Inicializar(EConexaoBD, EMensagens);
  if Result = 0 then
  begin
    FInicializado := True;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TDownloads, Class_Downloads,
    ciMultiInstance, tmApartment);
end.
