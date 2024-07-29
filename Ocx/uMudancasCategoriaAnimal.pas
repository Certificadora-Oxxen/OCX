unit uMudancasCategoriaAnimal;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntMudancasCategoriaAnimal;

type
  TMudancasCategoriaAnimal = class(TASPMTSObject, IMudancasCategoriaAnimal)
  private
    FIntMudancasCategoriaAnimal: TIntMudancasCategoriaAnimal;
    FInicializado: Boolean;
  protected
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodTipoEvento: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function PesquisarOrigens(CodTipoEvento, CodAptidao: Integer): Integer;
      safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TMudancasCategoriaAnimal.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TMudancasCategoriaAnimal.BeforeDestruction;
begin
  If FIntMudancasCategoriaAnimal <> nil Then Begin
    FIntMudancasCategoriaAnimal.Free;
  End;
  inherited;
end;

function TMudancasCategoriaAnimal.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntMudancasCategoriaAnimal := TIntMudancasCategoriaAnimal.Create;
  Result := FIntMudancasCategoriaAnimal.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TMudancasCategoriaAnimal.EOF: WordBool;
begin
  Result := FIntMudancasCategoriaAnimal.EOF;
end;

function TMudancasCategoriaAnimal.NumeroRegistros: Integer;
begin
  Result := FIntMudancasCategoriaAnimal.NumeroRegistros;
end;

function TMudancasCategoriaAnimal.Pesquisar(
  CodTipoEvento: Integer): Integer;
begin
  Result := FIntMudancasCategoriaAnimal.Pesquisar(CodtipoEvento);
end;

function TMudancasCategoriaAnimal.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntMudancasCategoriaAnimal.ValorCampo(NomCampo);
end;

procedure TMudancasCategoriaAnimal.FecharPesquisa;
begin
  FIntMudancasCategoriaAnimal.FecharPesquisa;
end;

procedure TMudancasCategoriaAnimal.IrAoPrimeiro;
begin
  FIntMudancasCategoriaAnimal.IrAoPrimeiro;
end;

procedure TMudancasCategoriaAnimal.IrAoProximo;
begin
  FIntMudancasCategoriaAnimal.IrAoProximo;
end;

function TMudancasCategoriaAnimal.PesquisarOrigens(CodTipoEvento,
  CodAptidao: Integer): Integer;
begin
  Result := FIntMudancasCategoriaAnimal.PesquisarOrigens(CodTipoEvento,
    CodAptidao);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMudancasCategoriaAnimal, Class_MudancasCategoriaAnimal,
    ciMultiInstance, tmApartment);
end.
