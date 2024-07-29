unit uParametrosPesoAjustado;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao,uIntMensagens,
  uIntParametrosPesoAjustado;

type
  TParametrosPesoAjustado = class(TASPMTSObject, IParametrosPesoAjustado)
  private
    FIntParametrosPesoAjustado  : TIntParametrosPesoAjustado;
    FInicializado               : Boolean;
  protected
    function DefinirIdadesPadraoAssociacao(CodAssociacao, NumIdadePadrao1,
      NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
      NumLimiteAjusteIdade, NUmLimiteEquivaleIdade: Integer): Integer;
      safecall;
    function DefinirIdadesPadraoProdutor(NumIdadePadrao1, NumIdadePadrao2,
      NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
      NumLimiteAjusteIdade, NUmLimiteEquivaleIdade,
      QtdIdadeMinimaPesagem: Integer): Integer; safecall;
    function BuscarDaAssociacao(CodPessoaAssociacao: Integer): Integer;
      safecall;
    function BuscarDoProdutor: Integer; safecall;
    function Get_CodPessoa: Integer; safecall;
    function Get_NomPessoa: WideString; safecall;
    function Get_NumCNPJCPFFormatado: WideString; safecall;
    function Get_NumIdadePadrao1: Integer; safecall;
    function Get_NumIdadePadrao2: Integer; safecall;
    function Get_NumIdadePadrao3: Integer; safecall;
    function Get_NumIdadePadrao4: Integer; safecall;
    function Get_NumIdadePadrao5: Integer; safecall;
    function Get_NumLimiteAjusteIdade: Integer; safecall;
    function Get_NumLimiteEquivaleIdade: Integer; safecall;
    procedure Set_CodPessoa(Value: Integer); safecall;
    procedure Set_NomPessoa(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatado(const Value: WideString); safecall;
    procedure Set_NumIdadePadrao1(Value: Integer); safecall;
    procedure Set_NumIdadePadrao2(Value: Integer); safecall;
    procedure Set_NumIdadePadrao3(Value: Integer); safecall;
    procedure Set_NumIdadePadrao4(Value: Integer); safecall;
    procedure Set_NumIdadePadrao5(Value: Integer); safecall;
    procedure Set_NumLimiteAjusteIdade(Value: Integer); safecall;
    procedure Set_NumLimiteEquivaleIdade(Value: Integer); safecall;
    function Get_QtdIdadeMinimaPesagem: Integer; safecall;
    procedure Set_QtdIdadeMinimaPesagem(Value: Integer); safecall;
  public
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;

  end;

implementation

uses ComServ;

function TParametrosPesoAjustado.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntParametrosPesoAjustado := TIntParametrosPesoAjustado.Create;
  Result := FIntParametrosPesoAjustado.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TParametrosPesoAjustado.DefinirIdadesPadraoAssociacao(
  CodAssociacao, NumIdadePadrao1, NumIdadePadrao2, NumIdadePadrao3,
  NumIdadePadrao4, NumIdadePadrao5, NumLimiteAjusteIdade,
  NUmLimiteEquivaleIdade: Integer): Integer;
begin
  Result := FIntParametrosPesoAjustado.DefinirIdadesPadraoAssociacao(CodAssociacao,
  NumIdadePadrao1, NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
  NumLimiteAjusteIdade, NUmLimiteEquivaleIdade);
end;

function TParametrosPesoAjustado.DefinirIdadesPadraoProdutor(
  NumIdadePadrao1, NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4,
  NumIdadePadrao5, NumLimiteAjusteIdade, NUmLimiteEquivaleIdade,
  QtdIdadeMinimaPesagem: Integer): Integer;
begin
  Result := FIntParametrosPesoAjustado.DefinirIdadesPadraoProdutor(NumIdadePadrao1,
  NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
  NumLimiteAjusteIdade, NUmLimiteEquivaleIdade, QtdIdadeMinimaPesagem);
end;

function TParametrosPesoAjustado.BuscarDaAssociacao(
  CodPessoaAssociacao: Integer): Integer;
begin
  Result := FIntParametrosPesoAjustado.BuscarDaAssociacao(CodPessoaAssociacao);
end;

function TParametrosPesoAjustado.BuscarDoProdutor: Integer;
begin
  Result := FIntParametrosPesoAjustado.BuscarDoProdutor;
end;

function TParametrosPesoAjustado.Get_CodPessoa: Integer;
begin
 result := FIntParametrosPesoAjustado.CodPessoa;
end;

function TParametrosPesoAjustado.Get_NomPessoa: WideString;
begin
 result := FIntParametrosPesoAjustado.NomPessoa;
end;

function TParametrosPesoAjustado.Get_NumCNPJCPFFormatado: WideString;
begin
 result := FIntParametrosPesoAjustado.NumCNPJCPFFormatado;
end;

function TParametrosPesoAjustado.Get_NumIdadePadrao1: Integer;
begin
 result := FIntParametrosPesoAjustado.NumIdadePadrao1;
end;

function TParametrosPesoAjustado.Get_NumIdadePadrao2: Integer;
begin
 result := FIntParametrosPesoAjustado.NumIdadePadrao2;
end;

function TParametrosPesoAjustado.Get_NumIdadePadrao3: Integer;
begin
 result := FIntParametrosPesoAjustado.NumIdadePadrao3;
end;

function TParametrosPesoAjustado.Get_NumIdadePadrao4: Integer;
begin
 result := FIntParametrosPesoAjustado.NumIdadePadrao4;
end;

function TParametrosPesoAjustado.Get_NumIdadePadrao5: Integer;
begin
 result := FIntParametrosPesoAjustado.NumIdadePadrao5;
end;

function TParametrosPesoAjustado.Get_NumLimiteAjusteIdade: Integer;
begin
 result := FIntParametrosPesoAjustado.NumLimiteAjusteIdade;
end;

function TParametrosPesoAjustado.Get_NumLimiteEquivaleIdade: Integer;
begin
 result := FIntParametrosPesoAjustado.NumLimiteEquivaleIdade;
end;

procedure TParametrosPesoAjustado.Set_CodPessoa(Value: Integer);
begin
  FIntParametrosPesoAjustado.CodPessoa := value;
end;

procedure TParametrosPesoAjustado.Set_NomPessoa(const Value: WideString);
begin
  FIntParametrosPesoAjustado.NomPessoa := value;
end;

procedure TParametrosPesoAjustado.Set_NumCNPJCPFFormatado(
  const Value: WideString);
begin
  FIntParametrosPesoAjustado.NumCNPJCPFFormatado := value;
end;

procedure TParametrosPesoAjustado.Set_NumIdadePadrao1(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumIdadePadrao1 := value;
end;

procedure TParametrosPesoAjustado.Set_NumIdadePadrao2(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumIdadePadrao2 := value;
end;

procedure TParametrosPesoAjustado.Set_NumIdadePadrao3(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumIdadePadrao3 := value;
end;

procedure TParametrosPesoAjustado.Set_NumIdadePadrao4(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumIdadePadrao4 := value;
end;

procedure TParametrosPesoAjustado.Set_NumIdadePadrao5(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumIdadePadrao5 := value;
end;

procedure TParametrosPesoAjustado.Set_NumLimiteAjusteIdade(Value: Integer);
begin
  FIntParametrosPesoAjustado.NumLimiteAjusteIdade := value;
end;

procedure TParametrosPesoAjustado.Set_NumLimiteEquivaleIdade(
  Value: Integer);
begin
  FIntParametrosPesoAjustado.NumLimiteEquivaleIdade := value;
end;

function TParametrosPesoAjustado.Get_QtdIdadeMinimaPesagem: Integer;
begin
 result := FIntParametrosPesoAjustado.QtdIdadeMinimaPesagem;
end;

procedure TParametrosPesoAjustado.Set_QtdIdadeMinimaPesagem(
  Value: Integer);
begin
  FIntParametrosPesoAjustado.QtdIdadeMinimaPesagem := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TParametrosPesoAjustado, Class_ParametrosPesoAjustado,
    ciMultiInstance, tmApartment);
end.
