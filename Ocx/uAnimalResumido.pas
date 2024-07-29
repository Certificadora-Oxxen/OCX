unit uAnimalResumido;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TAnimalResumido = class(TASPMTSObject, IAnimalResumido)
  private
    FCodPessoaProdutor: Integer;
    FNomPessoaProdutor: WideString;
    FCodAnimal: Integer;
    FCodFazendaManejo: Integer;
    FSglFazendaManejo: WideString;
    FCodAnimalManejo: WideString;
    FCodAnimalCertificadora: WideString;
    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;
    FNomAnimal: WideString;
    FCodEspecie: Integer;
    FSglEspecie: WideString;
    FCodAptidao: Integer;
    FSglAptidao: WideString;
    FIndSexo: WideString;
    FCodTipoOrigem: Integer;
    FSglTipoOrigem: WideString;
    FDesAptidao: WideString;
    FDesEspecie: WideString;
    FDesTipoOrigem: WideString;
    FNomPessoaVendedor: WideString;
  protected
    function Get_CodAnimal: Integer; safecall;
    function Get_CodAnimalCertificadora: WideString; safecall;
    function Get_CodAnimalManejo: WideString; safecall;
    function Get_CodAnimalSisbov: Integer; safecall;
    function Get_CodAptidao: Integer; safecall;
    function Get_CodEspecie: Integer; safecall;
    function Get_CodEstadoSisbov: Integer; safecall;
    function Get_CodFazendaManejo: Integer; safecall;
    function Get_CodMicroRegiaoSisbov: Integer; safecall;
    function Get_CodPaisSisbov: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodTipoOrigem: Integer; safecall;
    function Get_IndSexo: WideString; safecall;
    function Get_NomAnimal: WideString; safecall;
    function Get_NumDVSisbov: Integer; safecall;
    function Get_SglAptidao: WideString; safecall;
    function Get_SglEspecie: WideString; safecall;
    function Get_SglFazendaManejo: WideString; safecall;
    function Get_SglTipoOrigem: WideString; safecall;
    procedure Set_CodAnimal(Value: Integer); safecall;
    procedure Set_CodAnimalCertificadora(const Value: WideString); safecall;
    procedure Set_CodAnimalManejo(const Value: WideString); safecall;
    procedure Set_CodAnimalSisbov(Value: Integer); safecall;
    procedure Set_CodAptidao(Value: Integer); safecall;
    procedure Set_CodEspecie(Value: Integer); safecall;
    procedure Set_CodEstadoSisbov(Value: Integer); safecall;
    procedure Set_CodFazendaManejo(Value: Integer); safecall;
    procedure Set_CodMicroRegiaoSisbov(Value: Integer); safecall;
    procedure Set_CodPaisSisbov(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodTipoOrigem(Value: Integer); safecall;
    procedure Set_IndSexo(const Value: WideString); safecall;
    procedure Set_NomAnimal(const Value: WideString); safecall;
    procedure Set_NumDVSisbov(Value: Integer); safecall;
    procedure Set_SglAptidao(const Value: WideString); safecall;
    procedure Set_SglEspecie(const Value: WideString); safecall;
    procedure Set_SglFazendaManejo(const Value: WideString); safecall;
    procedure Set_SglTipoOrigem(const Value: WideString); safecall;
    function Get_DesAptidao: WideString; safecall;
    function Get_DesEspecie: WideString; safecall;
    function Get_DesTipoOrigem: WideString; safecall;
    procedure Set_DesAptidao(const Value: WideString); safecall;
    procedure Set_DesEspecie(const Value: WideString); safecall;
    procedure Set_DesTipoOrigem(const Value: WideString); safecall;
    function AplicarEvento(const CodAnimais: WideString; CodFazenda: Integer;
      const CodAnimaisManejo: WideString; CodLote, CodLocal,
      CodEvento: Integer): Integer; safecall;
    function AplicarEventoAnimaisPesquisados(CodEvento: Integer): Integer;
      safecall;
    function PesquisarMensagensAplicacaoEvento(CodEvento: Integer): Integer;
      safecall;
    function Get_NomPessoaVendedor: WideString; safecall;
    procedure Set_NomPessoaVendedor(const Value: WideString); safecall;
    function Get_NomPessoaProdutor: WideString; safecall;
    procedure Set_NomPessoaProdutor(const Value: WideString); safecall;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodFazendaManejo: Integer read FCodFazendaManejo write FCodFazendaManejo;
    property SglFazendaManejo: WideString read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: WideString read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalCertificadora: WideString read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;
    property NomAnimal: WideString read FNomAnimal write FNomAnimal;
    property CodEspecie: Integer read FCodEspecie write FCodEspecie;
    property SglEspecie: WideString read FSglEspecie write FSglEspecie;
    property CodAptidao: Integer read FCodAptidao write FCodAptidao;
    property SglAptidao: WideString read FSglAptidao write FSglAptidao;
    property IndSexo: WideString read FIndSexo write FIndSexo;
    property CodTipoOrigem: Integer read FCodTipoOrigem write FCodTipoOrigem;
    property SglTipoOrigem: WideString read FSglTipoOrigem write FSglTipoOrigem;

    property DesAptidao: WideString read FDesAptidao write FDesAptidao;
    property DesEspecie: WideString read FDesEspecie write FDesEspecie;
    property DesTipoOrigem: WideString read FDesTipoOrigem write FDesTipoOrigem;
    property NomPessoaVendedor: WideString read FNomPessoaVendedor write FNomPessoaVendedor;
    property NomPessoaProdutor: WideString read FNomPessoaProdutor write FNomPessoaProdutor;
  end;

implementation

uses ComServ;

function TAnimalResumido.Get_CodAnimal: Integer;
begin
  Result := FCodAnimal;
end;

function TAnimalResumido.Get_CodAnimalCertificadora: WideString;
begin
  Result := FCodAnimalCertificadora;
end;

function TAnimalResumido.Get_CodAnimalManejo: WideString;
begin
  Result := FCodAnimalManejo;
end;

function TAnimalResumido.Get_CodAnimalSisbov: Integer;
begin
  Result := FCodAnimalSisbov;
end;

function TAnimalResumido.Get_CodAptidao: Integer;
begin
  Result := FCodAptidao;
end;

function TAnimalResumido.Get_CodEspecie: Integer;
begin
  Result := FCodEspecie;
end;

function TAnimalResumido.Get_CodEstadoSisbov: Integer;
begin
  Result := FCodEstadoSisbov;
end;

function TAnimalResumido.Get_CodFazendaManejo: Integer;
begin
  Result := FCodFazendaManejo;
end;

function TAnimalResumido.Get_CodMicroRegiaoSisbov: Integer;
begin
  Result := FCodMicroRegiaoSisbov;
end;

function TAnimalResumido.Get_CodPaisSisbov: Integer;
begin
  Result := FCodPaisSisbov;
end;

function TAnimalResumido.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TAnimalResumido.Get_CodTipoOrigem: Integer;
begin
  Result := FCodTipoOrigem;
end;

function TAnimalResumido.Get_IndSexo: WideString;
begin
  Result := FIndSexo;
end;

function TAnimalResumido.Get_NomAnimal: WideString;
begin
  Result := FNomAnimal;
end;

function TAnimalResumido.Get_NumDVSisbov: Integer;
begin
  Result := FNumDVSisbov;
end;

function TAnimalResumido.Get_SglAptidao: WideString;
begin
  Result := FSglAptidao;
end;

function TAnimalResumido.Get_SglEspecie: WideString;
begin
  Result := FSglEspecie;
end;

function TAnimalResumido.Get_SglFazendaManejo: WideString;
begin
  Result := FSglFazendaManejo;
end;

function TAnimalResumido.Get_SglTipoOrigem: WideString;
begin
  Result := FSglTipoOrigem;
end;

procedure TAnimalResumido.Set_CodAnimal(Value: Integer);
begin
  FCodAnimal := Value;
end;

procedure TAnimalResumido.Set_CodAnimalCertificadora(
  const Value: WideString);
begin
  FCodAnimalCertificadora := Value;
end;

procedure TAnimalResumido.Set_CodAnimalManejo(const Value: WideString);
begin
  FCodAnimalManejo := Value;
end;

procedure TAnimalResumido.Set_CodAnimalSisbov(Value: Integer);
begin
  FCodAnimalSisbov := Value;
end;

procedure TAnimalResumido.Set_CodAptidao(Value: Integer);
begin
  FCodAptidao := Value;
end;

procedure TAnimalResumido.Set_CodEspecie(Value: Integer);
begin
  FCodEspecie := Value;
end;

procedure TAnimalResumido.Set_CodEstadoSisbov(Value: Integer);
begin
  FCodEstadoSisbov := Value;
end;

procedure TAnimalResumido.Set_CodFazendaManejo(Value: Integer);
begin
  FCodFazendaManejo := Value;
end;

procedure TAnimalResumido.Set_CodMicroRegiaoSisbov(Value: Integer);
begin
  FCodMicroRegiaoSisbov := Value;
end;

procedure TAnimalResumido.Set_CodPaisSisbov(Value: Integer);
begin
  FCodPaisSisbov := Value;
end;

procedure TAnimalResumido.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TAnimalResumido.Set_CodTipoOrigem(Value: Integer);
begin
  FCodTipoOrigem := Value;
end;

procedure TAnimalResumido.Set_IndSexo(const Value: WideString);
begin
  FIndSexo := Value;
end;

procedure TAnimalResumido.Set_NomAnimal(const Value: WideString);
begin
  FNomAnimal := Value;
end;

procedure TAnimalResumido.Set_NumDVSisbov(Value: Integer);
begin
  FNumDVSisbov := Value;
end;

procedure TAnimalResumido.Set_SglAptidao(const Value: WideString);
begin
  FSglAptidao := Value;
end;

procedure TAnimalResumido.Set_SglEspecie(const Value: WideString);
begin
  FSglEspecie := Value;
end;

procedure TAnimalResumido.Set_SglFazendaManejo(const Value: WideString);
begin
  FSglFazendaManejo := Value;
end;

procedure TAnimalResumido.Set_SglTipoOrigem(const Value: WideString);
begin
  FSglTipoOrigem := Value;
end;

function TAnimalResumido.Get_DesAptidao: WideString;
begin
  Result := FDesAptidao;
end;

function TAnimalResumido.Get_DesEspecie: WideString;
begin
  Result := FDesEspecie;
end;

function TAnimalResumido.Get_DesTipoOrigem: WideString;
begin
  Result := FDesTipoOrigem;
end;

procedure TAnimalResumido.Set_DesAptidao(const Value: WideString);
begin
  FDesAptidao := Value;
end;

procedure TAnimalResumido.Set_DesEspecie(const Value: WideString);
begin
  FDesEspecie := Value;
end;

procedure TAnimalResumido.Set_DesTipoOrigem(const Value: WideString);
begin
  FDesTipoOrigem := Value;
end;

function TAnimalResumido.AplicarEvento(const CodAnimais: WideString;
  CodFazenda: Integer; const CodAnimaisManejo: WideString; CodLote,
  CodLocal, CodEvento: Integer): Integer;
begin

end;

function TAnimalResumido.AplicarEventoAnimaisPesquisados(
  CodEvento: Integer): Integer;
begin

end;

function TAnimalResumido.PesquisarMensagensAplicacaoEvento(
  CodEvento: Integer): Integer;
begin

end;

function TAnimalResumido.Get_NomPessoaVendedor: WideString;
begin
  Result := FNomPessoaVendedor;
end;

procedure TAnimalResumido.Set_NomPessoaVendedor(const Value: WideString);
begin
  FNomPessoaVendedor := Value;
end;

function TAnimalResumido.Get_NomPessoaProdutor: WideString;
begin
  Result := FNomPessoaProdutor;
end;

procedure TAnimalResumido.Set_NomPessoaProdutor(const Value: WideString);
begin
  FNomPessoaProdutor := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnimalResumido, Class_AnimalResumido,
    ciMultiInstance, tmApartment);
end.
