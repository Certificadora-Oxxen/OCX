unit uOrientacoes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntOrientacoes;

type
  TOrientacoes = class(TASPMTSObject, IOrientacoes)
  private
    FIntOrientacoes: TIntOrientacoes;
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

procedure TOrientacoes.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TOrientacoes.BeforeDestruction;
begin
  If FIntOrientacoes <> nil Then Begin
    FIntOrientacoes.Free;
  End;
  inherited;
end;

function TOrientacoes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntOrientacoes := TIntOrientacoes.Create;
  Result := FIntOrientacoes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TOrientacoes.EOF: WordBool;
begin
  Result := FIntOrientacoes.EOF;
end;

function TOrientacoes.Pesquisar: Integer;
begin
  Result := FIntOrientacoes.Pesquisar;
end;

function TOrientacoes.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntOrientacoes.ValorCampo(NomCampo);
end;

procedure TOrientacoes.FecharPesquisa;
begin
  FIntOrientacoes.FecharPesquisa;
end;

procedure TOrientacoes.IrAoProximo;
begin
  FIntOrientacoes.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOrientacoes, Class_Orientacoes,
    ciMultiInstance, tmApartment);
end.
