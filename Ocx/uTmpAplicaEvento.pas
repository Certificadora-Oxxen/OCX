unit uTmpAplicaEvento;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntTmpAplicaEvento, uIntMensagens;

type
  TTmpAplicaEvento = class(TASPMTSObject, ITmpAplicaEvento)
    FIntTmpAplicaEvento: TIntTmpAplicaEvento;
    FInicializado: Boolean;
  protected
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodPessoaProdutor, CodAnimal, CodEvento, CodSessao: Integer): Integer; safecall;
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

function TTmpAplicaEvento.BOF: WordBool;
begin
  Result := FIntTmpAplicaEvento.BOF;
end;

function TTmpAplicaEvento.EOF: WordBool;
begin
  Result := FIntTmpAplicaEvento.EOF;
end;

function TTmpAplicaEvento.NumeroRegistros: Integer;
begin
  Result := FIntTmpAplicaEvento.NumeroRegistros();
end;

function TTmpAplicaEvento.Pesquisar(CodPessoaProdutor, CodAnimal, CodEvento, CodSessao: Integer): Integer;
begin
  Result := FIntTmpAplicaEvento.Pesquisar(CodPessoaProdutor, CodAnimal, CodEvento, CodSessao);
end;

function TTmpAplicaEvento.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntTmpAplicaEvento.ValorCampo(NomCampo);
end;

procedure TTmpAplicaEvento.FecharPesquisa;
begin
  FIntTmpAplicaEvento.FecharPesquisa;
end;

procedure TTmpAplicaEvento.IrAoPrimeiro;
begin
  FIntTmpAplicaEvento.IrAoPrimeiro;
end;

procedure TTmpAplicaEvento.IrAoProximo;
begin
  FIntTmpAplicaEvento.IrAoProximo;
end;

procedure TTmpAplicaEvento.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTmpAplicaEvento.BeforeDestruction;
begin
  inherited;
  if FIntTmpAplicaEvento <> nil then
  begin
    FIntTmpAplicaEvento.Free;
  end;
end;

function TTmpAplicaEvento.Inicializar(EConexaoBD: TConexao;
                                EMensagens: TIntMensagens): Integer;
begin
  FIntTmpAplicaEvento := TIntTmpAplicaEvento.Create;
  Result := FIntTmpAplicaEvento.Inicializar(EConexaoBD, EMensagens);
  if Result = 0 then
  begin
    FInicializado := True;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTmpAplicaEvento, Class_TmpAplicaEvento, ciMultiInstance, tmApartment);
end.
