unit uOrdemServicoResumida;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl;

type
  TOrdemServicoResumida = class(TAutoObject, IOrdemServicoResumida)
  private
    FCodOrdemServico: Integer;
    FNomProdutor: String;
    FNomPropriedadeRural: String;
    FNumCNPJCPFProdutorFormatado: String;
    FNumImovelReceitaFederal: String;
    FNumOrdemServico: Integer;
    FQtdAnimais: Integer;
    FCodPessoaProdutor: Integer;
    FCodPropriedadeRural: Integer;
    FCodSituacaoOS: Integer;
    FDesSituacaoOS: String;
    FSglProdutor: String;
    FSglSituacaoOS: String;
    FCodLocalizacaoSisbov: Integer;

    FDtaEnvioPedido: TDateTime;
    FNomServicoEnvio: String;
    FNroConhecimento: String;
  protected
    function Get_CodOrdemServico: Integer; safecall;
    function Get_NomProdutor: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NumCNPJCPFProdutorFormatado: WideString; safecall;
    function Get_NumImovelReceitaFederal: WideString; safecall;
    function Get_NumOrdemServico: Integer; safecall;
    function Get_QtdAnimais: Integer; safecall;
    procedure Set_CodOrdemServico(Value: Integer); safecall;
    procedure Set_NomProdutor(const Value: WideString); safecall;
    procedure Set_NomPropriedadeRural(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFProdutorFormatado(const Value: WideString);
      safecall;
    procedure Set_NumImovelReceitaFederal(const Value: WideString); safecall;
    procedure Set_NumOrdemServico(Value: Integer); safecall;
    procedure Set_QtdAnimais(Value: Integer); safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodPropriedadeRural: Integer; safecall;
    function Get_CodSituacaoOS: Integer; safecall;
    function Get_DesSituacaoOS: WideString; safecall;
    function Get_SglProdutor: WideString; safecall;
    function Get_SglSituacaoOS: WideString; safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodPropriedadeRural(Value: Integer); safecall;
    procedure Set_CodSituacaoOS(Value: Integer); safecall;
    procedure Set_DesSituacaoOS(const Value: WideString); safecall;
    procedure Set_SglProdutor(const Value: WideString); safecall;
    procedure Set_SglSituacaoOS(const Value: WideString); safecall;
    function Get_CodLocalizacaoSisbov: Integer; safecall;
    procedure Set_CodLocalizacaoSisbov(Value: Integer); safecall;
    function Get_DtaEnvioPedido: TDateTime; safecall;
    function Get_NomServico: WideString; safecall;
    function Get_NroConhecimento: WideString; safecall;
    procedure Set_DtaEnvioPedido(Value: TDateTime); safecall;
    procedure Set_NomServico(const Value: WideString); safecall;
    procedure Set_NroConhecimento(const Value: WideString); safecall;
  public
    property CodOrdemServico: Integer read FCodOrdemServico write FCodOrdemServico;
    property NomProdutor: String read FNomProdutor write FNomProdutor;
    property NomPropriedadeRural: String read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumCNPJCPFProdutorFormatado: String read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
    property NumImovelReceitaFederal: String read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property NumOrdemServico: Integer read FNumOrdemServico write FNumOrdemServico;
    property QtdAnimais: Integer read FQtdAnimais write FQtdAnimais;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property CodSituacaoOS: Integer read FCodSituacaoOS write FCodSituacaoOS;
    property DesSituacaoOS: String read FDesSituacaoOS write FDesSituacaoOS;
    property SglSituacaoOS: String read FSglSituacaoOS write FSglSituacaoOS;
    property SglProdutor: String read FSglProdutor write FSglProdutor;
    property CodLocalizacaoSisbov: Integer read FCodLocalizacaoSisbov write FCodLocalizacaoSisbov;

    property DtaEnvioPedido: TDateTime read FDtaEnvioPedido write FDtaEnvioPedido;
    property NomServicoEnvio: String read FNomServicoEnvio write FNomServicoEnvio;
    property NroConhecimento: String read FNroConhecimento write FNroConhecimento;
  end;

implementation

uses ComServ;

function TOrdemServicoResumida.Get_CodOrdemServico: Integer;
begin
  Result := FCodOrdemServico;
end;

function TOrdemServicoResumida.Get_NomProdutor: WideString;
begin
  Result := FNomProdutor;
end;

function TOrdemServicoResumida.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TOrdemServicoResumida.Get_NumCNPJCPFProdutorFormatado: WideString;
begin
  Result := NumCNPJCPFProdutorFormatado;
end;

function TOrdemServicoResumida.Get_NumImovelReceitaFederal: WideString;
begin
  Result := NumImovelReceitaFederal;
end;

function TOrdemServicoResumida.Get_NumOrdemServico: Integer;
begin
  Result := NumOrdemServico;
end;

function TOrdemServicoResumida.Get_QtdAnimais: Integer;
begin
  Result := QtdAnimais;
end;

procedure TOrdemServicoResumida.Set_CodOrdemServico(Value: Integer);
begin
  FCodOrdemServico := Value;
end;

procedure TOrdemServicoResumida.Set_NomProdutor(const Value: WideString);
begin
  FNomProdutor := Value;
end;

procedure TOrdemServicoResumida.Set_NomPropriedadeRural(
  const Value: WideString);
begin
  FNomPropriedadeRural := Value;
end;

procedure TOrdemServicoResumida.Set_NumCNPJCPFProdutorFormatado(
  const Value: WideString);
begin
  FNumCNPJCPFProdutorFormatado := Value;
end;

procedure TOrdemServicoResumida.Set_NumImovelReceitaFederal(
  const Value: WideString);
begin
  FNumImovelReceitaFederal := Value;
end;

procedure TOrdemServicoResumida.Set_NumOrdemServico(Value: Integer);
begin
  FNumOrdemServico := Value;
end;

procedure TOrdemServicoResumida.Set_QtdAnimais(Value: Integer);
begin
  FQtdAnimais := Value;
end;

function TOrdemServicoResumida.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TOrdemServicoResumida.Get_CodPropriedadeRural: Integer;
begin
  Result := FCodPropriedadeRural;
end;

function TOrdemServicoResumida.Get_CodSituacaoOS: Integer;
begin
  Result := FCodSituacaoOS;
end;

function TOrdemServicoResumida.Get_DesSituacaoOS: WideString;
begin
  Result := FDesSituacaoOS;
end;

function TOrdemServicoResumida.Get_SglProdutor: WideString;
begin
  Result := FSglProdutor;
end;

function TOrdemServicoResumida.Get_SglSituacaoOS: WideString;
begin
  Result := FSglSituacaoOS;
end;

procedure TOrdemServicoResumida.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TOrdemServicoResumida.Set_CodPropriedadeRural(Value: Integer);
begin
  FCodPropriedadeRural := Value;
end;

procedure TOrdemServicoResumida.Set_CodSituacaoOS(Value: Integer);
begin
  FCodSituacaoOS := Value;
end;

procedure TOrdemServicoResumida.Set_DesSituacaoOS(const Value: WideString);
begin
  FDesSituacaoOS := Value;
end;

procedure TOrdemServicoResumida.Set_SglProdutor(const Value: WideString);
begin
  FSglProdutor := Value;
end;

procedure TOrdemServicoResumida.Set_SglSituacaoOS(const Value: WideString);
begin
  FSglSituacaoOS := Value;
end;

function TOrdemServicoResumida.Get_CodLocalizacaoSisbov: Integer;
begin
  Result := FCodLocalizacaoSisbov;
end;

procedure TOrdemServicoResumida.Set_CodLocalizacaoSisbov(Value: Integer);
begin
  FCodLocalizacaoSisbov := Value
end;

function TOrdemServicoResumida.Get_DtaEnvioPedido: TDateTime;
begin
 Result := FDtaEnvioPedido;
end;

function TOrdemServicoResumida.Get_NomServico: WideString;
begin
  Result := FNomServicoEnvio;
end;

function TOrdemServicoResumida.Get_NroConhecimento: WideString;
begin
  Result := FNroConhecimento;
end;

procedure TOrdemServicoResumida.Set_DtaEnvioPedido(Value: TDateTime);
begin
  FDtaEnvioPedido := Value;
end;

procedure TOrdemServicoResumida.Set_NomServico(const Value: WideString);
begin
  FNomServicoEnvio := Value;
end;

procedure TOrdemServicoResumida.Set_NroConhecimento(
  const Value: WideString);
begin
  FNroConhecimento := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOrdemServicoResumida, Class_OrdemServicoResumida,
    ciMultiInstance, tmApartment);
end.
