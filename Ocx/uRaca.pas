// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 29/07/2002
// *  Documentação       : Atributos de Animais.doc
// *  Código Classe      : 26
// *  Descrição Resumida : Cadastro de Raca
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    29/07/2002    Criação
// *   Hítalo    10/09/2002   Adiconar propriedade CodRacaSisBov.
// *   Hítalo    19/09/2002   Adicionar as propriedades CodEspecie,DesEspecie,Sglespecie.
// *
// ********************************************************************
unit uRaca;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TRaca = class(TASPMTSObject, IRaca)
  Private
    FCodRaca        : Integer;
    FSglRaca        : WideString;
    FDesRaca        : WideString;
    FIndRacaPura    : WideString;
    FCodRacaSisBov  : WideString;
    FCodEspecie     : Integer;
    FSglEspecie     : WideString;
    FDesEspecie     : WideString;
    FIndDefaultProdutor : WideString;
    FQtdPesoPadraoNascimento : Double;
    FQtdMinDiasGestacao: Integer;
    FQtdMaxDiasGestacao: Integer;
    FCodRacaAbcz    : WideString;
  protected
    function Get_CodRaca: Integer; safecall;
    function Get_DesRaca: WideString; safecall;
    function Get_IndRacaPura: WideString; safecall;
    function Get_SglRaca: WideString; safecall;
    procedure Set_CodRaca(Value: Integer); safecall;
    procedure Set_DesRaca(const Value: WideString); safecall;
    procedure Set_IndRacaPura(const Value: WideString); safecall;
    procedure Set_SglRaca(const Value: WideString); safecall;
    function Get_CodRacaSisBov: WideString; safecall;
    procedure Set_CodRacaSisBov(const Value: WideString); safecall;
    function Get_DesEspecie: WideString; safecall;
    function Get_SglEspecie: WideString; safecall;
    procedure Set_DesEspecie(const Value: WideString); safecall;
    procedure Set_SglEspecie(const Value: WideString); safecall;
    function Get_CodEspecie: Integer; safecall;
    procedure Set_CodEspecie(Value: Integer); safecall;
    function Get_IndDefaultProdutor: WideString; safecall;
    procedure Set_IndDefaultProdutor(const Value: WideString); safecall;
    function Get_QtdPesoPadraoNascimento: Double; safecall;
    procedure Set_QtdPesoPadraoNascimento(Value: Double); safecall;
    function Get_QtdMaxDiasGestacao: Integer; safecall;
    function Get_QtdMinDiasGestacao: Integer; safecall;
    procedure Set_QtdMaxDiasGestacao(Value: Integer); safecall;
    procedure Set_QtdMinDiasGestacao(Value: Integer); safecall;
    function Get_CodRacaAbcz: WideString; safecall;
    procedure Set_CodRacaAbcz(const Value: WideString); safecall;
  public
    property  CodRaca            : Integer        Read FCodRaca                write FCodRaca;
    property  SglRaca            : WideString     Read FSglRaca                write FSglRaca;
    property  DesRaca            : WideString     Read FDesRaca                write FDesRaca;
    property  IndRacaPura        : WideString     Read FIndRacaPura            write FIndRacaPura;
    property  CodRacaSisBov      : WideString     Read FCodRacaSisBov          write FCodRacaSisBov;
    property  CodEspecie         : Integer        Read FCodEspecie             write FCodEspecie;
    property  SglEspecie         : WideString     Read FSglEspecie             write FSglEspecie;
    property  DesEspecie         : WideString     Read FDesEspecie             write FDesEspecie;
    property  IndDefaultProdutor : WideString     Read FIndDefaultProdutor     write FIndDefaultProdutor;
    property  QtdPesoPadraoNascimento  : Double   Read FQtdPesoPadraoNascimento  write FQtdPesoPadraoNascimento;
    property  QtdMinDiasGestacao       : Integer  Read FQtdMinDiasGestacao       write FQtdMinDiasGestacao;
    property  QtdMaxDiasGestacao       : Integer  Read FQtdMaxDiasGestacao       write FQtdMaxDiasGestacao;
    property  CodRacaAbcz        : WideString     read Get_CodRacaAbcz         write Set_CodRacaAbcz;
  end;

implementation

uses ComServ;

function TRaca.Get_CodRaca: Integer;
begin
  result := FCodRaca;
end;

function TRaca.Get_DesRaca: WideString;
begin
  result := FDesRaca;
end;

function TRaca.Get_IndRacaPura: WideString;
begin
  result := FIndRacaPura;
end;

function TRaca.Get_SglRaca: WideString;
begin
  result := FSglRaca;
end;

procedure TRaca.Set_CodRaca(Value: Integer);
begin
  FCodRaca := value;
end;

procedure TRaca.Set_DesRaca(const Value: WideString);
begin
  FDesRaca := value;
end;

procedure TRaca.Set_IndRacaPura(const Value: WideString);
begin
  FIndRacaPura := value;
end;

procedure TRaca.Set_SglRaca(const Value: WideString);
begin
  FSglRaca := value;
end;

function TRaca.Get_CodRacaSisBov: WideString;
begin
  Result := FCodRacaSisBov;
end;

procedure TRaca.Set_CodRacaSisBov(const Value: WideString);
begin
  FCodRacaSisBov := value;
end;

function TRaca.Get_DesEspecie: WideString;
begin
  result := FDesEspecie;
end;

function TRaca.Get_SglEspecie: WideString;
begin
  result := FSglEspecie;
end;

procedure TRaca.Set_DesEspecie(const Value: WideString);
begin
  FDesEspecie := value;
end;

procedure TRaca.Set_SglEspecie(const Value: WideString);
begin
  FSglEspecie := value;
end;

function TRaca.Get_CodEspecie: Integer;
begin
  result := FCodEspecie;
end;

procedure TRaca.Set_CodEspecie(Value: Integer);
begin
  FCodEspecie := value;
end;

function TRaca.Get_IndDefaultProdutor: WideString;
begin
  result := FIndDefaultProdutor;
end;

procedure TRaca.Set_IndDefaultProdutor(const Value: WideString);
begin
  FIndDefaultProdutor := value;
end;

function TRaca.Get_QtdPesoPadraoNascimento: Double;
begin
  result := FQtdPesoPadraoNascimento;
end;

procedure TRaca.Set_QtdPesoPadraoNascimento(Value: Double);
begin
  FQtdPesoPadraoNascimento := value;
end;

function TRaca.Get_QtdMaxDiasGestacao: Integer;
begin
  result := FQtdMaxDiasGestacao;
end;

function TRaca.Get_QtdMinDiasGestacao: Integer;
begin
  result := FQtdMinDiasGestacao;
end;

procedure TRaca.Set_QtdMaxDiasGestacao(Value: Integer);
begin
  FQtdMaxDiasGestacao := value;
end;

procedure TRaca.Set_QtdMinDiasGestacao(Value: Integer);
begin
  FQtdMinDiasGestacao := value;
end;

function TRaca.Get_CodRacaAbcz: WideString;
begin
  Result := FCodRacaAbcz;
end;

procedure TRaca.Set_CodRacaAbcz(const Value: WideString);
begin
  FCodRacaAbcz := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRaca, Class_Raca,
    ciMultiInstance, tmApartment);
end.
