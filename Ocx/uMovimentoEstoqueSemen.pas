unit uMovimentoEstoqueSemen;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TMovimentoEstoqueSemen = class(TASPMTSObject, IMovimentoEstoqueSemen)
  private
    FCodAnimal: Integer;
    FCodAnimalFemea: Integer;
    FCodAnimalManejo: WideString;
    FCodAnimalManejoFemea: WideString;
    FCodFazenda: Integer;
    FCodFazendaRelacionada: Integer;
    FCodMovimento: Integer;
    FCodPessoaSecundaria: Integer;
    FCodTipoMovEstoqueSemen: Integer;
    FDesTipoMovEstoqueSemen: WideString;
    FDtaMovimento: TDateTime;
    FNomFazenda: WideString;
    FNomFazendaRelacionada: WideString;
    FNomPessoaSecundaria: WideString;
    FNumCNPJCPFPessoaSecundaria: WideString;
    FNumPartida: WideString;
    FQtdDosesSemenApto: Integer;
    FSglFazenda: WideString;
    FSglFazendaManejo: WideString;
    FSglFazendaManejoFemea: WideString;
    FSglFazendaRelacionada: WideString;
    FSglTipoMovEstoqueSemen: WideString;
    FCodOperacaoMovEstoqueApto: WideString;
    FCodOperacaoMovEstoqueInapto: WideString;
    FCodUsuario: Integer;
    FDesOperacaoMovEstoqueApto: WideString;
    FDesOperacaoMovEstoqueInapto: WideString;
    FDtaCadastramento: TDateTime;
    FIndMovimentoEstorno: WideString;
    FNomUsuario: WideString;
    FQtdDosesSemenInapto: Integer;
    FTxtObservacao: WideString;
    FSeqMovimento: Integer;
    FDesApelido: WideString;
    FNomAnimal: WideString;
  protected
    function Get_CodAnimal: Integer; safecall;
    function Get_CodAnimalFemea: Integer; safecall;
    function Get_CodAnimalManejo: WideString; safecall;
    function Get_CodAnimalManejoFemea: WideString; safecall;
    function Get_CodFazenda: Integer; safecall;
    function Get_CodFazendaRelacionada: Integer; safecall;
    function Get_CodMovimento: Integer; safecall;
    function Get_CodPessoaSecundaria: Integer; safecall;
    function Get_CodTipoMovEstoqueSemen: Integer; safecall;
    function Get_DesTipoMovEstoqueSemen: WideString; safecall;
    function Get_DtaMovimento: TDateTime; safecall;
    function Get_NomFazenda: WideString; safecall;
    function Get_NomFazendaRelacionada: WideString; safecall;
    function Get_NomPessoaSecundaria: WideString; safecall;
    function Get_NumCNPJCPFPessoaSecundaria: WideString; safecall;
    function Get_NumPartida: WideString; safecall;
    function Get_QtdDosesSemenApto: Integer; safecall;
    function Get_SglFazenda: WideString; safecall;
    function Get_SglFazendaManejo: WideString; safecall;
    function Get_SglFazendaManejoFemea: WideString; safecall;
    function Get_SglFazendaRelacionada: WideString; safecall;
    function Get_SglTipoMovEstoqueSemen: WideString; safecall;
    procedure Set_CodAnimal(Value: Integer); safecall;
    procedure Set_CodAnimalFemea(Value: Integer); safecall;
    procedure Set_CodAnimalManejo(const Value: WideString); safecall;
    procedure Set_CodAnimalManejoFemea(const Value: WideString); safecall;
    procedure Set_CodFazenda(Value: Integer); safecall;
    procedure Set_CodFazendaRelacionada(Value: Integer); safecall;
    procedure Set_CodMovimento(Value: Integer); safecall;
    procedure Set_CodPessoaSecundaria(Value: Integer); safecall;
    procedure Set_CodTipoMovEstoqueSemen(Value: Integer); safecall;
    procedure Set_DesTipoMovEstoqueSemen(const Value: WideString); safecall;
    procedure Set_DtaMovimento(Value: TDateTime); safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    procedure Set_NomFazendaRelacionada(const Value: WideString); safecall;
    procedure Set_NomPessoaSecundaria(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFPessoaSecundaria(const Value: WideString);
      safecall;
    procedure Set_NumPartida(const Value: WideString); safecall;
    procedure Set_QtdDosesSemenApto(Value: Integer); safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;
    procedure Set_SglFazendaManejo(const Value: WideString); safecall;
    procedure Set_SglFazendaManejoFemea(const Value: WideString); safecall;
    procedure Set_SglFazendaRelacionada(const Value: WideString); safecall;
    procedure Set_SglTipoMovEstoqueSemen(const Value: WideString); safecall;
    function Get_CodOperacaoMovEstoqueApto: WideString; safecall;
    function Get_CodOperacaoMovEstoqueInapto: WideString; safecall;
    function Get_CodUsuario: Integer; safecall;
    function Get_DesOperacaoMovEstoqueApto: WideString; safecall;
    function Get_DesOperacaoMovEstoqueInapto: WideString; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_IndMovimentoEstorno: WideString; safecall;
    function Get_NomUsuario: WideString; safecall;
    function Get_QtdDosesSemenInapto: Integer; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_CodOperacaoMovEstoqueApto(const Value: WideString); safecall;
    procedure Set_CodOperacaoMovEstoqueInapto(const Value: WideString);
      safecall;
    procedure Set_CodUsuario(Value: Integer); safecall;
    procedure Set_DesOperacaoMovEstoqueApto(const Value: WideString); safecall;
    procedure Set_DesOperacaoMovEstoqueInapto(const Value: WideString);
      safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_IndMovimentoEstorno(const Value: WideString); safecall;
    procedure Set_NomUsuario(const Value: WideString); safecall;
    procedure Set_QtdDosesSemenInapto(Value: Integer); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_SeqMovimento: Integer; safecall;
    procedure Set_SeqMovimento(Value: Integer); safecall;
    function Get_DesApelido: WideString; safecall;
    function Get_NomAnimal: WideString; safecall;
    procedure Set_DesApelido(const Value: WideString); safecall;
    procedure Set_NomAnimal(const Value: WideString); safecall;
  public
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodAnimalFemea: Integer read FCodAnimalFemea write FCodAnimalFemea;
    property CodAnimalManejo: WideString read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalManejoFemea: WideString read FCodAnimalManejoFemea write FCodAnimalManejoFemea;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property CodFazendaRelacionada: Integer read FCodFazendaRelacionada write FCodFazendaRelacionada;
    property CodMovimento: Integer read FCodMovimento write FCodMovimento;
    property CodPessoaSecundaria: Integer read FCodPessoaSecundaria write FCodPessoaSecundaria;
    property CodTipoMovEstoqueSemen: Integer read FCodTipoMovEstoqueSemen write FCodTipoMovEstoqueSemen;
    property DesTipoMovEstoqueSemen: WideString read FDesTipoMovEstoqueSemen write FDesTipoMovEstoqueSemen;
    property DtaMovimento: TDateTime read FDtaMovimento write FDtaMovimento;
    property NomFazenda: WideString read FNomFazenda write FNomFazenda;
    property NomFazendaRelacionada: WideString read FNomFazendaRelacionada write FNomFazendaRelacionada;
    property NomPessoaSecundaria: WideString read FNomPessoaSecundaria write FNomPessoaSecundaria;
    property NumCNPJCPFPessoaSecundaria: WideString read FNumCNPJCPFPessoaSecundaria write FNumCNPJCPFPessoaSecundaria;
    property NumPartida: WideString read FNumPartida write FNumPartida;
    property QtdDosesSemenApto: Integer read FQtdDosesSemenApto write FQtdDosesSemenApto;
    property SglFazenda: WideString read FSglFazenda write FSglFazenda;
    property SglFazendaManejo: WideString read FSglFazendaManejo write FSglFazendaManejo;
    property SglFazendaManejoFemea: WideString read FSglFazendaManejoFemea write FSglFazendaManejoFemea;
    property SglFazendaRelacionada: WideString read FSglFazendaRelacionada write FSglFazendaRelacionada;
    property SglTipoMovEstoqueSemen: WideString read FSglTipoMovEstoqueSemen write FSglTipoMovEstoqueSemen;
    property CodOperacaoMovEstoqueApto: WideString read FCodOperacaoMovEstoqueApto write FCodOperacaoMovEstoqueApto;
    property CodOperacaoMovEstoqueInapto: WideString read FCodOperacaoMovEstoqueInapto write FCodOperacaoMovEstoqueInapto;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property DesOperacaoMovEstoqueApto: WideString read FDesOperacaoMovEstoqueApto write FDesOperacaoMovEstoqueApto;
    property DesOperacaoMovEstoqueInapto: WideString read FDesOperacaoMovEstoqueInapto write FDesOperacaoMovEstoqueInapto;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndMovimentoEstorno: WideString read FIndMovimentoEstorno write FIndMovimentoEstorno;
    property NomUsuario: WideString read FNomUsuario write FNomUsuario;
    property QtdDosesSemenInapto: Integer read FQtdDosesSemenInapto write FQtdDosesSemenInapto;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property SeqMovimento: Integer read FSeqMovimento write FSeqMovimento;
    property DesApelido: WideString read FDesApelido write FDesApelido;
    property NomAnimal: WideString read FNomAnimal write FNomAnimal;
  end;

implementation

uses ComServ;

function TMovimentoEstoqueSemen.Get_CodAnimal: Integer;
begin
  Result := FCodAnimal;
end;

function TMovimentoEstoqueSemen.Get_CodAnimalFemea: Integer;
begin
  Result := FCodAnimalFemea;
end;

function TMovimentoEstoqueSemen.Get_CodAnimalManejo: WideString;
begin
  Result := FCodAnimalManejo;
end;

function TMovimentoEstoqueSemen.Get_CodAnimalManejoFemea: WideString;
begin
  Result := FCodAnimalManejoFemea;
end;

function TMovimentoEstoqueSemen.Get_CodFazenda: Integer;
begin
  Result := FCodFazenda;
end;

function TMovimentoEstoqueSemen.Get_CodFazendaRelacionada: Integer;
begin
  Result := FCodFazendaRelacionada;
end;

function TMovimentoEstoqueSemen.Get_CodMovimento: Integer;
begin
  Result := FCodMovimento;
end;

function TMovimentoEstoqueSemen.Get_CodPessoaSecundaria: Integer;
begin
  Result := FCodPessoaSecundaria;
end;

function TMovimentoEstoqueSemen.Get_CodTipoMovEstoqueSemen: Integer;
begin
  Result := FCodTipoMovEstoqueSemen;
end;

function TMovimentoEstoqueSemen.Get_DesTipoMovEstoqueSemen: WideString;
begin
  Result := FDesTipoMovEstoqueSemen;
end;

function TMovimentoEstoqueSemen.Get_DtaMovimento: TDateTime;
begin
  Result := FDtaMovimento;
end;

function TMovimentoEstoqueSemen.Get_NomFazenda: WideString;
begin
  Result := FNomFazenda;
end;

function TMovimentoEstoqueSemen.Get_NomFazendaRelacionada: WideString;
begin
  Result := FNomFazendaRelacionada;
end;

function TMovimentoEstoqueSemen.Get_NomPessoaSecundaria: WideString;
begin
  Result := FNomPessoaSecundaria;
end;

function TMovimentoEstoqueSemen.Get_NumCNPJCPFPessoaSecundaria: WideString;
begin
  Result := FNumCNPJCPFPessoaSecundaria;
end;

function TMovimentoEstoqueSemen.Get_NumPartida: WideString;
begin
  Result := FNumPartida;
end;

function TMovimentoEstoqueSemen.Get_QtdDosesSemenApto: Integer;
begin
  Result := FQtdDosesSemenApto;
end;

function TMovimentoEstoqueSemen.Get_SglFazenda: WideString;
begin
  Result := FSglFazenda;
end;

function TMovimentoEstoqueSemen.Get_SglFazendaManejo: WideString;
begin
  Result := FSglFazendaManejo;
end;

function TMovimentoEstoqueSemen.Get_SglFazendaManejoFemea: WideString;
begin
  Result := FSglFazendaManejoFemea;
end;

function TMovimentoEstoqueSemen.Get_SglFazendaRelacionada: WideString;
begin
  Result := SglFazendaRelacionada;
end;

function TMovimentoEstoqueSemen.Get_SglTipoMovEstoqueSemen: WideString;
begin
  Result := FSglTipoMovEstoqueSemen;
end;

procedure TMovimentoEstoqueSemen.Set_CodAnimal(Value: Integer);
begin
  FCodAnimal := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodAnimalFemea(Value: Integer);
begin
  FCodAnimalFemea := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodAnimalManejo(
  const Value: WideString);
begin
  FCodAnimalManejo := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodAnimalManejoFemea(
  const Value: WideString);
begin
  FCodAnimalManejoFemea := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodFazendaRelacionada(Value: Integer);
begin
  FCodFazendaRelacionada := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodMovimento(Value: Integer);
begin
  FCodMovimento := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodPessoaSecundaria(Value: Integer);
begin
  FCodPessoaSecundaria := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodTipoMovEstoqueSemen(
  Value: Integer);
begin
  FCodTipoMovEstoqueSemen := Value;
end;

procedure TMovimentoEstoqueSemen.Set_DesTipoMovEstoqueSemen(
  const Value: WideString);
begin
  FDesTipoMovEstoqueSemen := Value;
end;

procedure TMovimentoEstoqueSemen.Set_DtaMovimento(Value: TDateTime);
begin
  FDtaMovimento := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NomFazendaRelacionada(
  const Value: WideString);
begin
  FNomFazendaRelacionada := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NomPessoaSecundaria(
  const Value: WideString);
begin
  FNomPessoaSecundaria := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NumCNPJCPFPessoaSecundaria(
  const Value: WideString);
begin
  FNumCNPJCPFPessoaSecundaria := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NumPartida(const Value: WideString);
begin
  FNumPartida := Value;
end;

procedure TMovimentoEstoqueSemen.Set_QtdDosesSemenApto(Value: Integer);
begin
  FQtdDosesSemenApto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := Value;
end;

procedure TMovimentoEstoqueSemen.Set_SglFazendaManejo(
  const Value: WideString);
begin
  FSglFazendaManejo := Value;
end;

procedure TMovimentoEstoqueSemen.Set_SglFazendaManejoFemea(
  const Value: WideString);
begin
  FSglFazendaManejoFemea := Value;
end;

procedure TMovimentoEstoqueSemen.Set_SglFazendaRelacionada(
  const Value: WideString);
begin
  FSglFazendaRelacionada := Value;
end;

procedure TMovimentoEstoqueSemen.Set_SglTipoMovEstoqueSemen(
  const Value: WideString);
begin
  FSglTipoMovEstoqueSemen := Value;
end;

function TMovimentoEstoqueSemen.Get_CodOperacaoMovEstoqueApto: WideString;
begin
  Result := FCodOperacaoMovEstoqueApto;
end;

function TMovimentoEstoqueSemen.Get_CodOperacaoMovEstoqueInapto: WideString;
begin
  Result := FCodOperacaoMovEstoqueInapto;
end;

function TMovimentoEstoqueSemen.Get_CodUsuario: Integer;
begin
  Result := FCodUsuario;
end;

function TMovimentoEstoqueSemen.Get_DesOperacaoMovEstoqueApto: WideString;
begin
  Result := FDesOperacaoMovEstoqueApto;
end;

function TMovimentoEstoqueSemen.Get_DesOperacaoMovEstoqueInapto: WideString;
begin
  Result := FDesOperacaoMovEstoqueInapto;
end;

function TMovimentoEstoqueSemen.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TMovimentoEstoqueSemen.Get_IndMovimentoEstorno: WideString;
begin
  Result := FIndMovimentoEstorno;
end;

function TMovimentoEstoqueSemen.Get_NomUsuario: WideString;
begin
  Result := FNomUsuario;
end;

function TMovimentoEstoqueSemen.Get_QtdDosesSemenInapto: Integer;
begin
  Result := FQtdDosesSemenInapto;
end;

function TMovimentoEstoqueSemen.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

procedure TMovimentoEstoqueSemen.Set_CodOperacaoMovEstoqueApto(
  const Value: WideString);
begin
  FCodOperacaoMovEstoqueApto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodOperacaoMovEstoqueInapto(
  const Value: WideString);
begin
  FCodOperacaoMovEstoqueInapto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_CodUsuario(Value: Integer);
begin
  FCodUsuario := Value;
end;

procedure TMovimentoEstoqueSemen.Set_DesOperacaoMovEstoqueApto(
  const Value: WideString);
begin
  FDesOperacaoMovEstoqueApto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_DesOperacaoMovEstoqueInapto(
  const Value: WideString);
begin
  FDesOperacaoMovEstoqueInapto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

procedure TMovimentoEstoqueSemen.Set_IndMovimentoEstorno(
  const Value: WideString);
begin
  FIndMovimentoEstorno := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NomUsuario(const Value: WideString);
begin
  FNomUsuario := Value;
end;

procedure TMovimentoEstoqueSemen.Set_QtdDosesSemenInapto(Value: Integer);
begin
  FQtdDosesSemenInapto := Value;
end;

procedure TMovimentoEstoqueSemen.Set_TxtObservacao(
  const Value: WideString);
begin
  FTxtObservacao := Value;
end;

function TMovimentoEstoqueSemen.Get_SeqMovimento: Integer;
begin
  Result := FSeqMovimento;
end;

procedure TMovimentoEstoqueSemen.Set_SeqMovimento(Value: Integer);
begin
  FSeqMovimento := Value;
end;

function TMovimentoEstoqueSemen.Get_DesApelido: WideString;
begin
  Result := FDesApelido;
end;

function TMovimentoEstoqueSemen.Get_NomAnimal: WideString;
begin
  Result := FNomAnimal;
end;

procedure TMovimentoEstoqueSemen.Set_DesApelido(const Value: WideString);
begin
  FDesApelido := Value;
end;

procedure TMovimentoEstoqueSemen.Set_NomAnimal(const Value: WideString);
begin
  FNomAnimal := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMovimentoEstoqueSemen, Class_MovimentoEstoqueSemen,
    ciMultiInstance, tmApartment);
end.
