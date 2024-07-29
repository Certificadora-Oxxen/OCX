// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Controle de acesso - definição das classesc
// *  Código Classe      : 
// *  Descrição Resumida : Cadastro de Produtor
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    25/07/2002    Criação
// *   Hitalo   02/09/2002    Adicionar SglProdutor,QtdCaracterCodManejo
// *
// ********************************************************************
unit uProdutor;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TProdutor = class(TASPMTSObject, IProdutor)
  private
    FCodProdutor: Integer;
    FNomProdutor: WideString;
    FCodNatureza: WideString;
    FNumCPFCNPJ: WideString;
    FNumCPFCNPJFormatado: WideString;
    FSglProdutor  : wideString;
    FQtdCaracterCodManejo : Integer;
    FIndConsultaPublica : WideString;
    FCodTipoAgrupamentoRacas : Integer;
    FQtdDenominadorCompRacial : Integer;
    FQtdDiasEntreCoberturas: Integer;
    FQtdDiasDescansoReprodutivo: Integer;
    FQtdDiasDiagnosticoGestacao: Integer;
    FCodAptidao: Integer;
    FCodSituacaoSisBov: WideString;
    FIndMostrarNome: WideString;
    FIndMostrarIdentificadores: WideString;
    FIndTransfereEmbrioes: WideString;
    FIndMostrarFiltroCompRacial: WideString;
    FIndEstacaoMonta: WideString;
    FIndTrabalhaAssociacaoRaca: WideString;
    FQtdIdadeMinimaDesmame: Integer;
    FQtdIdadeMaximaDesmame: Integer;
    FIndAplicarDesmameAutomatico: WideString;
  protected
    function Get_CodNatureza: WideString; safecall;
    function Get_CodProdutor: Integer; safecall;
    function Get_NomProdutor: WideString; safecall;
    function Get_NumCPFCNPJ: WideString; safecall;
    procedure Set_CodNatureza(const Value: WideString); safecall;
    procedure Set_CodProdutor(Value: Integer); safecall;
    procedure Set_NomProdutor(const Value: WideString); safecall;
    procedure Set_NumCPFCNPJ(const Value: WideString); safecall;
    function Get_NumCPFCNPJFormatado: WideString; safecall;
    procedure Set_NumCPFCNPJFormatado(const Value: WideString); safecall;
    function Get_SglProdutor: WideString; safecall;
    procedure Set_SglProdutor(const Value: WideString); safecall;
    function Get_QtdCaracterCodManejo: Integer; safecall;
    procedure Set_QtdCaracterCodManejo(Value: Integer); safecall;
    function Get_IndConsultaPublica: WideString; safecall;
    procedure Set_IndConsultaPublica(const Value: WideString); safecall;
    function Get_CodTipoAgrupamentoRacas: Integer; safecall;
    function Get_QtdDenominadorCompRacial: Integer; safecall;
    procedure Set_CodTipoAgrupamentoRacas(Value: Integer); safecall;
    procedure Set_QtdDenominadorCompRacial(Value: Integer); safecall;
    function Get_QtdDiasDescansoReprodutivo: Integer; safecall;
    function Get_QtdDiasDiagnosticoGestacao: Integer; safecall;
    function Get_QtdDiasEntreCoberturas: Integer; safecall;
    procedure Set_QtdDiasDescansoReprodutivo(Value: Integer); safecall;
    procedure Set_QtdDiasDiagnosticoGestacao(Value: Integer); safecall;
    procedure Set_QtdDiasEntreCoberturas(Value: Integer); safecall;
    function Get_CodAptidao: Integer; safecall;
    function Get_CodSituacaoSisBov: WideString; safecall;
    function Get_IndMostrarFiltroCompRacial: WideString; safecall;
    function Get_IndMostrarIdentificadores: WideString; safecall;
    function Get_IndMostrarNome: WideString; safecall;
    function Get_IndTransfereEmbrioes: WideString; safecall;
    procedure Set_CodAptidao(Value: Integer); safecall;
    procedure Set_CodSituacaoSisBov(const Value: WideString); safecall;
    procedure Set_IndMostrarFiltroCompRacial(const Value: WideString);
      safecall;
    procedure Set_IndMostrarIdentificadores(const Value: WideString); safecall;
    procedure Set_IndMostrarNome(const Value: WideString); safecall;
    procedure Set_IndTransfereEmbrioes(const Value: WideString); safecall;
    function Get_IndEstacaoMonta: WideString; safecall;
    procedure Set_IndEstacaoMonta(const Value: WideString); safecall;
    function Get_QtdIdadeMaximaDesmame: Integer; safecall;
    function Get_QtdIdadeMinimaDesmame: Integer; safecall;
    function Get_IndTrabalhaAssociacaoRaca: WideString; safecall;
    procedure Set_QtdIdadeMaximaDesmame(Value: Integer); safecall;
    procedure Set_QtdIdadeMinimaDesmame(Value: Integer); safecall;
    procedure Set_IndTrabalhaAssociacaoRaca(const Value: WideString); safecall;
    function Get_IndAplicarDesmameAutomatico: WideString; safecall;
    procedure Set_IndAplicarDesmameAutomatico(const Value: WideString);
      safecall;
  public
    property CodProdutor:                 Integer    read FCodProdutor                 write FCodProdutor;
    property NomProdutor:                 WideString read FNomProdutor                 write FNomProdutor;
    property CodNatureza:                 WideString read FCodNatureza                 write FCodNatureza;
    property NumCPFCNPJ:                  WideString read FNumCPFCNPJ                  write FNumCPFCNPJ;
    property NumCPFCNPJFormatado:         WideString read FNumCPFCNPJFormatado         write FNumCPFCNPJFormatado;
    property SglProdutor:                 WideString read FSglProdutor                 write FSglProdutor;
    property QtdCaracterCodManejo:        Integer    read FQtdCaracterCodManejo        write FQtdCaracterCodManejo;
    property IndConsultaPublica:          WideString read FIndConsultaPublica          write FIndConsultaPublica;
    property CodTipoAgrupamentoRacas:     Integer    read FCodTipoAgrupamentoRacas     write FCodTipoAgrupamentoRacas;
    property QtdDenominadorCompRacial:    Integer    read FQtdDenominadorCompRacial    write FQtdDenominadorCompRacial;
    property QtdDiasEntreCoberturas:      Integer    read FQtdDiasEntreCoberturas      write FQtdDiasEntreCoberturas;
    property QtdDiasDescansoReprodutivo:  Integer    read FQtdDiasDescansoReprodutivo  write FQtdDiasDescansoReprodutivo;
    property QtdDiasDiagnosticoGestacao:  Integer    read FQtdDiasDiagnosticoGestacao  write FQtdDiasDiagnosticoGestacao;
    property CodAptidao:                  Integer    read FCodAptidao                  write FCodAptidao;
    property CodSituacaoSisBov:           WideString read FCodSituacaoSisBov           write FCodSituacaoSisBov;
    property IndMostrarNome:              WideString read FIndMostrarNome              write FIndMostrarNome;
    property IndMostrarIdentificadores:   WideString read FIndMostrarIdentificadores   write FIndMostrarIdentificadores;
    property IndTransfereEmbrioes:        WideString read FIndTransfereEmbrioes        write FIndTransfereEmbrioes;
    property IndMostrarFiltroCompRacial:  WideString read FIndMostrarFiltroCompRacial  write FIndMostrarFiltroCompRacial;
    property IndEstacaoMonta:             WideString read FIndEstacaoMonta             write FIndEstacaoMonta;
    property IndTrabalhaAssociacaoRaca:   WideString read FIndTrabalhaAssociacaoRaca   write FIndTrabalhaAssociacaoRaca;
    property QtdIdadeMinimaDesmame:       Integer    read FQtdIdadeMinimaDesmame       write FQtdIdadeMinimaDesmame;
    property QtdIdadeMaximaDesmame:       Integer    read FQtdIdadeMaximaDesmame       write FQtdIdadeMaximaDesmame;
    property IndAplicarDesmameAutomatico: WideString read FIndAplicarDesmameAutomatico write FIndAplicarDesmameAutomatico;
  end;

implementation

uses ComServ;

function TProdutor.Get_CodNatureza: WideString;
begin
  Result := FCodNatureza;
end;

function TProdutor.Get_CodProdutor: Integer;
begin
  Result := FCodProdutor;
end;

function TProdutor.Get_NomProdutor: WideString;
begin
  Result := FNomProdutor;
end;

function TProdutor.Get_NumCPFCNPJ: WideString;
begin
  Result := FNumCPFCNPJ;
end;

procedure TProdutor.Set_CodNatureza(const Value: WideString);
begin
  FCodNatureza := Value;
end;

procedure TProdutor.Set_CodProdutor(Value: Integer);
begin
  FCodProdutor := Value;
end;

procedure TProdutor.Set_NomProdutor(const Value: WideString);
begin
  FNomProdutor := Value;
end;

procedure TProdutor.Set_NumCPFCNPJ(const Value: WideString);
begin
  FNumCPFCNPJ := Value;
end;

function TProdutor.Get_NumCPFCNPJFormatado: WideString;
begin
  Result := FNumCPFCNPJFormatado;
end;

procedure TProdutor.Set_NumCPFCNPJFormatado(const Value: WideString);
begin
  FNumCPFCNPJFormatado := Value;
end;

function TProdutor.Get_SglProdutor: WideString;
begin
  result := FSglProdutor;
end;

procedure TProdutor.Set_SglProdutor(const Value: WideString);
begin
  FSglProdutor := value;
end;

function TProdutor.Get_QtdCaracterCodManejo: Integer;
begin
  result := FQtdCaracterCodManejo;
end;

procedure TProdutor.Set_QtdCaracterCodManejo(Value: Integer);
begin
 FQtdCaracterCodManejo := value;
end;

function TProdutor.Get_IndConsultaPublica: WideString;
begin
  result := FIndConsultaPublica;
end;

procedure TProdutor.Set_IndConsultaPublica(const Value: WideString);
begin
 FIndConsultaPublica := value;
end;

function TProdutor.Get_CodTipoAgrupamentoRacas: Integer;
begin
  result := FCodTipoAgrupamentoRacas;
end;

function TProdutor.Get_QtdDenominadorCompRacial: Integer;
begin
  result := FQtdDenominadorCompRacial;
end;

procedure TProdutor.Set_CodTipoAgrupamentoRacas(Value: Integer);
begin
 FCodTipoAgrupamentoRacas := value;
end;

procedure TProdutor.Set_QtdDenominadorCompRacial(Value: Integer);
begin
 FQtdDenominadorCompRacial := value;
end;

function TProdutor.Get_QtdDiasDescansoReprodutivo: Integer;
begin
  result := FQtdDiasDescansoReprodutivo;
end;

function TProdutor.Get_QtdDiasDiagnosticoGestacao: Integer;
begin
  result := FQtdDiasDiagnosticoGestacao;
end;

function TProdutor.Get_QtdDiasEntreCoberturas: Integer;
begin
  result := FQtdDiasEntreCoberturas;
end;

procedure TProdutor.Set_QtdDiasDescansoReprodutivo(Value: Integer);
begin
 FQtdDiasDescansoReprodutivo := value;
end;

procedure TProdutor.Set_QtdDiasDiagnosticoGestacao(Value: Integer);
begin
 FQtdDiasDiagnosticoGestacao := value;
end;

procedure TProdutor.Set_QtdDiasEntreCoberturas(Value: Integer);
begin
 FQtdDiasEntreCoberturas := value;
end;

function TProdutor.Get_CodAptidao: Integer;
begin
  result := FCodAptidao;
end;

function TProdutor.Get_CodSituacaoSisBov: WideString;
begin
  result := FCodSituacaoSisBov;
end;

function TProdutor.Get_IndMostrarFiltroCompRacial: WideString;
begin
  result := FIndMostrarFiltroCompRacial;
end;

function TProdutor.Get_IndMostrarIdentificadores: WideString;
begin
  result := FIndMostrarIdentificadores;
end;

function TProdutor.Get_IndMostrarNome: WideString;
begin
  result := FIndMostrarNome;
end;

function TProdutor.Get_IndTransfereEmbrioes: WideString;
begin
  result := FIndTransfereEmbrioes;
end;

procedure TProdutor.Set_CodAptidao(Value: Integer);
begin
 FCodAptidao := value;
end;

procedure TProdutor.Set_CodSituacaoSisBov(const Value: WideString);
begin
 FCodSituacaoSisBov := value;
end;

procedure TProdutor.Set_IndMostrarFiltroCompRacial(
  const Value: WideString);
begin
 FIndMostrarFiltroCompRacial := value;
end;

procedure TProdutor.Set_IndMostrarIdentificadores(const Value: WideString);
begin
 FIndMostrarIdentificadores := value;
end;

procedure TProdutor.Set_IndMostrarNome(const Value: WideString);
begin
 FIndMostrarNome := value;
end;

procedure TProdutor.Set_IndTransfereEmbrioes(const Value: WideString);
begin
 FIndTransfereEmbrioes := value;
end;

function TProdutor.Get_IndEstacaoMonta: WideString;
begin
  result := FIndEstacaoMonta;
end;

procedure TProdutor.Set_IndEstacaoMonta(const Value: WideString);
begin
 FIndEstacaoMonta := value;
end;

function TProdutor.Get_QtdIdadeMaximaDesmame: Integer;
begin
  result := FQtdIdadeMaximaDesmame;
end;

function TProdutor.Get_QtdIdadeMinimaDesmame: Integer;
begin
  result := FQtdIdadeMinimaDesmame;
end;

function TProdutor.Get_IndTrabalhaAssociacaoRaca: WideString;
begin
  result := FIndTrabalhaAssociacaoRaca;
end;

procedure TProdutor.Set_QtdIdadeMaximaDesmame(Value: Integer);
begin
 FQtdIdadeMaximaDesmame := value;
end;

procedure TProdutor.Set_QtdIdadeMinimaDesmame(Value: Integer);
begin
 FQtdIdadeMinimaDesmame := value;
end;

procedure TProdutor.Set_IndTrabalhaAssociacaoRaca(const Value: WideString);
begin
 FIndTrabalhaAssociacaoRaca := value;
end;

function TProdutor.Get_IndAplicarDesmameAutomatico: WideString;
begin
  Result := FIndAplicarDesmameAutomatico;
end;

procedure TProdutor.Set_IndAplicarDesmameAutomatico(
  const Value: WideString);
begin
  FIndAplicarDesmameAutomatico := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TProdutor, Class_Produtor,
    ciMultiInstance, tmApartment);
end.
