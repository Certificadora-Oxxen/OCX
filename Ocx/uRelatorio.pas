unit uRelatorio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TRelatorio = class(TASPMTSObject, IRelatorio)
  private
    FCodRelatorio: Integer;
    FTxtTitulo: WideString;
    FQtdColunas: Integer;
    FCodOrientacao: Integer;
    FCodTamanhoFonte: Integer;
    FIndPersonalizavel: WideString;
    FTxtSubTitulo: WideString;
  protected
    function Get_CodOrientacao: Integer; safecall;
    function Get_CodRelatorio: Integer; safecall;
    function Get_CodTamanhoFonte: Integer; safecall;
    function Get_IndPersonalizavel: WideString; safecall;
    function Get_QtdColunas: Integer; safecall;
    function Get_TxtTitulo: WideString; safecall;
    procedure Set_CodOrientacao(Value: Integer); safecall;
    procedure Set_CodRelatorio(Value: Integer); safecall;
    procedure Set_CodTamanhoFonte(Value: Integer); safecall;
    procedure Set_IndPersonalizavel(const Value: WideString); safecall;
    procedure Set_QtdColunas(Value: Integer); safecall;
    procedure Set_TxtTitulo(const Value: WideString); safecall;
    function Get_TxtSubTitulo: WideString; safecall;
    procedure Set_TxtSubTitulo(const Value: WideString); safecall;
  public
    property CodRelatorio: Integer read FCodRelatorio write FCodRelatorio;
    property TxtTitulo: WideString read FTxtTitulo write FTxtTitulo;
    property QtdColunas: Integer read FQtdColunas write FQtdColunas;
    property CodOrientacao: Integer read FCodOrientacao write FCodOrientacao;
    property CodTamanhoFonte: Integer read FCodTamanhoFonte write FCodTamanhoFonte;
    property IndPersonalizavel: WideString read FIndPersonalizavel write FIndPersonalizavel;
    property TxtSubTitulo: WideString read FTxtSubTitulo write FTxtSubTitulo;
  end;

implementation

uses ComServ;

function TRelatorio.Get_CodOrientacao: Integer;
begin
  Result := FCodOrientacao;
end;

function TRelatorio.Get_CodRelatorio: Integer;
begin
  Result := FCodRelatorio;
end;

function TRelatorio.Get_CodTamanhoFonte: Integer;
begin
  Result := FCodTamanhoFonte;
end;

function TRelatorio.Get_IndPersonalizavel: WideString;
begin
  Result := FIndPersonalizavel;
end;

function TRelatorio.Get_QtdColunas: Integer;
begin
  Result := FQtdColunas;
end;

function TRelatorio.Get_TxtTitulo: WideString;
begin
  Result := FTxtTitulo;
end;

procedure TRelatorio.Set_CodOrientacao(Value: Integer);
begin
  FCodOrientacao := Value;
end;

procedure TRelatorio.Set_CodRelatorio(Value: Integer);
begin
  FCodRelatorio := Value;
end;

procedure TRelatorio.Set_CodTamanhoFonte(Value: Integer);
begin
  FCodTamanhoFonte := Value;
end;

procedure TRelatorio.Set_IndPersonalizavel(const Value: WideString);
begin
  FIndPersonalizavel := Value;
end;

procedure TRelatorio.Set_QtdColunas(Value: Integer);
begin
  FQtdColunas := Value;
end;

procedure TRelatorio.Set_TxtTitulo(const Value: WideString);
begin
  FTxtTitulo := Value;
end;

function TRelatorio.Get_TxtSubTitulo: WideString;
begin
  Result := FTxtSubTitulo;
end;

procedure TRelatorio.Set_TxtSubTitulo(const Value: WideString);
begin
  FTxtSubTitulo := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRelatorio, Class_Relatorio,
    ciMultiInstance, tmApartment);
end.
