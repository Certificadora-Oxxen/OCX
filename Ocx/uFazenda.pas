// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Propriedade Rural,fazenda, etc - Definição das Classes.doc
// *  Código Classe      : 34
// *  Descrição Resumida : Cadastro de Fazenda
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    24/07/2002    Criação
// *   Arley    13/08/2002    Alteração nos atributos desta classe
// *   Arley    13/11/2002    Inclusão da propriedade IndSituacaoImagem
// *   Hitalo    19/11/2002    Adcionar metodo GerarRelatorio.
// *
// ****************************************************************************
unit uFazenda;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TFazenda = class(TASPMTSObject, IFazenda)
  private
    FCodPessoaProdutor: Integer;
    FCodFazenda: Integer;
    FSglFazenda: WideString;
    FNomFazenda: WideString;
    FCodEstado: Integer;
    FSglEstado: WideString;
    FNumPropriedadeRural: WideString;
    FTxtObservacao: WideString;
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: WideString;
    FNumImovelReceitaFederalPR: WideString;
    FNomMunicipioPR: WideString;
    FSglEstadoPR: WideString;
    FNomPaisPR: WideString;
    FIndSituacaoImagem: WideString;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FIndEfetivadoUmaVez: WideString;
    FCodLocalizacaoSisbov:Integer;
    FCodRegimePosseUso: Integer;
    FDesRegimePosseUso: WideString;
    FCodUlavPro: WideString;
    FCodUlavFaz: WideString;
    FDesAcessoFaz: WideString;
    FQtdDistMunicipio: Integer;
    FCodIdPropriedadeSisbov: Integer;

  protected
    function Get_CodFazenda: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_NomFazenda: WideString; safecall;
    function Get_SglFazenda: WideString; safecall;
    function Get_CodEstado: Integer; safecall;
    function Get_SglEstado: WideString; safecall;
    function Get_NumPropriedadeRural: WideString; safecall;
    procedure Set_CodFazenda(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;
    procedure Set_CodEstado(Value: Integer); safecall;
    procedure Set_SglEstado(const Value: WideString); safecall;
    procedure Set_NumPropriedadeRural(const Value: WideString); safecall;
    function Get_CodPropriedadeRural: Integer; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_NomMunicipioPR: WideString; safecall;
    function Get_NomPaisPR: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NumImovelReceitaFederalPR: WideString; safecall;
    function Get_SglEstadoPR: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_CodPropriedadeRural(Value: Integer); safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
    procedure Set_DtaEfetivacaoCadastro(Value: TDateTime); safecall;
    procedure Set_NomMunicipioPR(const Value: WideString); safecall;
    procedure Set_NomPaisPR(const Value: WideString); safecall;
    procedure Set_NomPropriedadeRural(const Value: WideString); safecall;
    procedure Set_NumImovelReceitaFederalPR(const Value: WideString); safecall;
    procedure Set_SglEstadoPR(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_IndSituacaoImagem: WideString; safecall;
    procedure Set_IndSituacaoImagem(const Value: WideString); safecall;
    function Get_IndEfetivadoUmaVez: WideString; safecall;
    procedure Set_IndEfetivadoUmaVez(const Value: WideString); safecall;
    function Get_CodLocalizacaoSisbov: Integer; safecall;
    procedure Set_CodLocalizacaoSisbov(Value: Integer); safecall;
    function Get_CodRegimePosseUso: Integer; safecall;
    function Get_DesRegimePosseUso: WideString; safecall;
    procedure Set_CodRegimePosseUso(Value: Integer); safecall;
    procedure Set_DesRegimePosseUso(const Value: WideString); safecall;
    function Get_CodUlavPro: WideString; safecall;
    procedure Set_CodUlavPro(const Value: WideString); safecall;
    function Get_CodUlavFaz: WideString; safecall;
    function Get_DesAcessoFaz: WideString; safecall;
    function Get_QtdDistMunicipio: Integer; safecall;
    procedure Set_CodUlavFaz(const Value: WideString); safecall;
    procedure Set_DesAcessoFaz(const Value: WideString); safecall;
    procedure Set_QtdDistMunicipio(Value: Integer); safecall;
    function Get_CodIdPropriedadeSisbov: Integer; safecall;
    procedure Set_CodIdPropriedadeSisbov(Value: Integer); safecall;

  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property SglFazenda: WideString read FSglFazenda write FSglFazenda;
    property NomFazenda: WideString read FNomFazenda write FNomFazenda;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: WideString read FSglEstado write FSglEstado;
    property NumPropriedadeRural: WideString read FNumPropriedadeRural write FNumPropriedadeRural;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: WideString read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederalPR: WideString read FNumImovelReceitaFederalPR write FNumImovelReceitaFederalPR;
    property NomMunicipioPR: WideString read FNomMunicipioPR write FNomMunicipioPR;
    property SglEstadoPR: WideString read FSglEstadoPR write FSglEstadoPR;
    property NomPaisPR: WideString read FNomPaisPR write FNomPaisPR;
    property IndSituacaoImagem: WideString read FIndSituacaoImagem write FIndSituacaoImagem;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property IndEfetivadoUmaVez: WideString read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodLocalizacaoSisbov: Integer read FCodLocalizacaoSisbov write FCodLocalizacaoSisbov;
    property CodRegimePosseUso: Integer read FCodRegimePosseUso write FCodRegimePosseUso;
    property DesRegimePosseUso: WideString read FDesRegimePosseUso write FDesRegimePosseUso;
    property CodUlavPro: WideString read FCodUlavPro write FCodUlavPro;
    property CodUlavFaz: WideString read FCodUlavFaz write FCodUlavFaz;
    property DesAcessoFaz: WideString read FDesAcessoFaz write FDesAcessoFaz;
    property QtdDistMunicipio: Integer read FQtdDistMunicipio write FQtdDistMunicipio;
    property CodIdPropriedadeSisbov: Integer read FCodIdPropriedadeSisbov write FCodIdPropriedadeSisbov;
  end;

implementation

uses ComServ;

function TFazenda.Get_CodFazenda: Integer;
begin
  Result := FCodFazenda;
end;

function TFazenda.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TFazenda.Get_NomFazenda: WideString;
begin
  Result := FNomFazenda;
end;

function TFazenda.Get_SglFazenda: WideString;
begin
  Result := FSglFazenda;
end;

procedure TFazenda.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := Value;
end;

procedure TFazenda.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TFazenda.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := Value;
end;

procedure TFazenda.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := Value;
end;

function TFazenda.Get_CodEstado: Integer;
begin
  result := FCodEstado;
end;

function TFazenda.Get_SglEstado: WideString;
begin
  result := FSglEstado;
end;

procedure TFazenda.Set_CodEstado(Value: Integer);
begin
  FCodEstado := Value;
end;

procedure TFazenda.Set_SglEstado(const Value: WideString);
begin
  FSglEstado := Value;
end;

function TFazenda.Get_NumPropriedadeRural: WideString;
begin
  Result := FNumPropriedadeRural;
end;

procedure TFazenda.Set_NumPropriedadeRural(const Value: WideString);
begin
  FNumPropriedadeRural := Value;
end;

function TFazenda.Get_CodPropriedadeRural: Integer;
begin
  Result := FCodPropriedadeRural;
end;

function TFazenda.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TFazenda.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  Result := FDtaEfetivacaoCadastro;
end;

function TFazenda.Get_NomMunicipioPR: WideString;
begin
  Result := FNomMunicipioPR;
end;

function TFazenda.Get_NomPaisPR: WideString;
begin
  Result := FNomPaisPR;
end;

function TFazenda.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TFazenda.Get_NumImovelReceitaFederalPR: WideString;
begin
  Result := FNumImovelReceitaFederalPR;
end;

function TFazenda.Get_SglEstadoPR: WideString;
begin
  Result := FSglEstadoPR;
end;

function TFazenda.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

procedure TFazenda.Set_CodPropriedadeRural(Value: Integer);
begin
  FCodPropriedadeRural := Value;
end;

procedure TFazenda.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

procedure TFazenda.Set_DtaEfetivacaoCadastro(Value: TDateTime);
begin
  FDtaEfetivacaoCadastro := Value;
end;

procedure TFazenda.Set_NomMunicipioPR(const Value: WideString);
begin
  FNomMunicipioPR := Value;
end;

procedure TFazenda.Set_NomPaisPR(const Value: WideString);
begin
  FNomPaisPR := Value;
end;

procedure TFazenda.Set_NomPropriedadeRural(const Value: WideString);
begin
  FNomPropriedadeRural := Value;
end;

procedure TFazenda.Set_NumImovelReceitaFederalPR(const Value: WideString);
begin
  FNumImovelReceitaFederalPR := Value;
end;

procedure TFazenda.Set_SglEstadoPR(const Value: WideString);
begin
  FSglEstadoPR := Value;
end;

procedure TFazenda.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao := Value;
end;

function TFazenda.Get_IndSituacaoImagem: WideString;
begin
  Result := FIndSituacaoImagem;
end;

procedure TFazenda.Set_IndSituacaoImagem(const Value: WideString);
begin
  FIndSituacaoImagem := Value;
end;

function TFazenda.Get_IndEfetivadoUmaVez: WideString;
begin
  Result := FIndEfetivadoUmaVez;
end;

procedure TFazenda.Set_IndEfetivadoUmaVez(const Value: WideString);
begin
  FIndEfetivadoUmaVez := Value;
end;

function TFazenda.Get_CodLocalizacaoSisbov: Integer;
begin
  Result := FCodLocalizacaoSisbov;
end;

procedure TFazenda.Set_CodLocalizacaoSisbov(Value: Integer);
begin
  FCodLocalizacaoSisbov := Value;
end;

function TFazenda.Get_CodRegimePosseUso: Integer;
begin
  Result := FCodRegimePosseUso;
end;

function TFazenda.Get_DesRegimePosseUso: WideString;
begin
  Result := FDesRegimePosseUso;
end;

procedure TFazenda.Set_CodRegimePosseUso(Value: Integer);
begin
  FCodRegimePosseUso := Value;
end;

procedure TFazenda.Set_DesRegimePosseUso(const Value: WideString);
begin
  FDesRegimePosseUso := Value;
end;

function TFazenda.Get_CodUlavPro: WideString;
begin
  Result := FCodUlavPro;
end;

procedure TFazenda.Set_CodUlavPro(const Value: WideString);
begin
  FCodUlavPro := Value;
end;

function TFazenda.Get_CodUlavFaz: WideString;
begin
  Result := FCodUlavFaz;
end;

procedure TFazenda.Set_CodUlavFaz(const Value: WideString);
begin
  FCodUlavFaz := Value;
end;

function TFazenda.Get_DesAcessoFaz: WideString;
begin
  Result := FDesAcessoFaz;
end;

procedure TFazenda.Set_DesAcessoFaz(const Value: WideString);
begin
  FDesAcessoFaz := Value;
end;

function TFazenda.Get_QtdDistMunicipio: Integer;
begin
  Result := FQtdDistMunicipio;
end;

procedure TFazenda.Set_QtdDistMunicipio(Value: Integer);
begin
  FQtdDistMunicipio := Value;
end;

function TFazenda.Get_CodIdPropriedadeSisbov: Integer;
begin
  Result := FCodIdPropriedadeSisbov;
end;

procedure TFazenda.Set_CodIdPropriedadeSisbov(Value: Integer);
begin
  FCodIdPropriedadeSisbov := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFazenda, Class_Fazenda,
    ciMultiInstance, tmApartment);
end.
