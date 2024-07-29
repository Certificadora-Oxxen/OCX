unit uTiposPropriedades;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntTiposPropriedades;

type
  TTiposPropriedades = class(TASPMTSObject, ITiposPropriedades)
  private
    FIntTiposPropriedades: TIntTiposPropriedades;
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

function TTiposPropriedades.EOF: WordBool;
begin
  Result := FIntTiposPropriedades.EOF;
end;

function TTiposPropriedades.Pesquisar: Integer;
begin
  Result := FIntTiposPropriedades.Pesquisar;
end;

function TTiposPropriedades.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTiposPropriedades.ValorCampo(NomCampo);
end;

procedure TTiposPropriedades.FecharPesquisa;
begin
  FIntTiposPropriedades.FecharPesquisa;
end;

procedure TTiposPropriedades.IrAoPrimeiro;
begin
  FIntTiposPropriedades.IrAoPrimeiro;
end;

procedure TTiposPropriedades.IrAoProximo;
begin
  FIntTiposPropriedades.IrAoProximo;
end;

procedure TTiposPropriedades.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposPropriedades.BeforeDestruction;
begin
  inherited;
  if FIntTiposPropriedades <> nil then
  begin
    FIntTiposPropriedades.Free;
  end;
end;

function TTiposPropriedades.Inicializar(EConexaoBD: TConexao;
                                EMensagens: TIntMensagens): Integer;
begin
  FIntTiposPropriedades := TIntTiposPropriedades.Create;
  Result := FIntTiposPropriedades.Inicializar(EConexaoBD, EMensagens);
  if Result = 0 then
  begin
    FInicializado := True;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposPropriedades, Class_TiposPropriedades,
    ciMultiInstance, tmApartment);
end.
