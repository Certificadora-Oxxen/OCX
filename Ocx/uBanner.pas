unit uBanner;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TBanner = class(TASPMTSObject, IBanner)
  private
    FCodigo         : Integer;
    FNomArquivo     : WideString;
    FCodTipoBanner  : Integer;
    FURLDestino     : WideString;
    FTxtAlternativo : WideString;
    FCodAnunciante  : Integer;
    FCodTipoTarget  : Integer;
    FDesTipoBanner  : WideString;
    FNomAnunciante  : WideString;
    FDesTipoTarget  : WideString;
    FDtaFimValidade : TDateTime;
    FTxtComandoTarget: WideString;
  protected
    function Get_Codigo: Integer; safecall;
    function Get_CodTipoBanner: Integer; safecall;
    function Get_NomArquivo: WideString; safecall;
    function Get_TxtAlternativo: WideString; safecall;
    function Get_URLDestino: WideString; safecall;
    procedure Set_Codigo(Value: Integer); safecall;
    procedure Set_CodTipoBanner(Value: Integer); safecall;
    procedure Set_NomArquivo(const Value: WideString); safecall;
    procedure Set_TxtAlternativo(const Value: WideString); safecall;
    procedure Set_URLDestino(const Value: WideString); safecall;
    function Get_CodAnunciante: Integer; safecall;
    function Get_CodTipoTarget: Integer; safecall;
    procedure Set_CodAnunciante(Value: Integer); safecall;
    procedure Set_CodTipoTarget(Value: Integer); safecall;
    function Get_DesTipoBanner: WideString; safecall;
    function Get_DesTipoTarget: WideString; safecall;
    function Get_NomAnunciante: WideString; safecall;
    procedure Set_DesTipoBanner(const Value: WideString); safecall;
    procedure Set_DesTipoTarget(const Value: WideString); safecall;
    procedure Set_NomAnunciante(const Value: WideString); safecall;
    function Get_DtaFimValidade: TDateTime; safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;
    function Get_TxtComandoTarget: WideString; safecall;
    procedure Set_TxtComandoTarget(const Value: WideString); safecall;
  public
    property Codigo         : Integer       read FCodigo                write FCodigo;
    property NomArquivo     : WideString    read FNomArquivo            write FNomArquivo;
    property CodTipoBanner  : Integer       read FCodTipoBanner         write FCodTipoBanner;
    property URLDestino     : WideString    read FURLDestino            write FURLDestino;
    property TxTAlternativo : WideString    read FTxTAlternativo        write FTxTAlternativo;
    property CodAnunciante  : Integer       read FCodAnunciante         write FCodAnunciante;
    property CodTipoTarget  : Integer       read FCodTipoTarget         write FCodTipoTarget;
    property DesTipoBanner  : WideString    read FDesTipoBanner         write FDesTipoBanner;
    property NomAnunciante  : WideString    read FNomAnunciante         write FNomAnunciante;
    property DesTipoTarget  : WideString    read FDesTipoTarget         write FDesTipoTarget;
    property DtaFimValidade : TDateTime     read FDtaFimValidade        write FDtaFimValidade;
    property TxtComandoTarget: WideString   read FTxtComandoTarget      write FTxtComandoTarget;
  end;

implementation

uses ComServ;

function TBanner.Get_Codigo: Integer;
begin
  Result := FCodigo;
end;

function TBanner.Get_CodTipoBanner: Integer;
begin
  Result := FCodTipoBanner;
end;

function TBanner.Get_NomArquivo: WideString;
begin
  Result := FNomArquivo;
end;

function TBanner.Get_TxtAlternativo: WideString;
begin
  Result := FTxtAlternativo;
end;

function TBanner.Get_URLDestino: WideString;
begin
  Result := FURLDestino;
end;

procedure TBanner.Set_Codigo(Value: Integer);
begin
  FCodigo := Value;
end;

procedure TBanner.Set_CodTipoBanner(Value: Integer);
begin
  FCodTipoBanner := Value;
end;

procedure TBanner.Set_NomArquivo(const Value: WideString);
begin
  FNomArquivo := Value;
end;

procedure TBanner.Set_TxtAlternativo(const Value: WideString);
begin
  FTxtAlternativo := Value;
end;

procedure TBanner.Set_URLDestino(const Value: WideString);
begin
  FURLDestino := Value;
end;

function TBanner.Get_CodAnunciante: Integer;
begin
  Result := FCodAnunciante;
end;

function TBanner.Get_CodTipoTarget: Integer;
begin
  Result := FCodTipoTarget;
end;

procedure TBanner.Set_CodAnunciante(Value: Integer);
begin
  FCodAnunciante := Value;
end;

procedure TBanner.Set_CodTipoTarget(Value: Integer);
begin
  FCodTipoTarget := Value;
end;

function TBanner.Get_DesTipoBanner: WideString;
begin
  Result := FDesTipoBanner;
end;

function TBanner.Get_DesTipoTarget: WideString;
begin
  Result := FDesTipoTarget;
end;

function TBanner.Get_NomAnunciante: WideString;
begin
  Result := FNomAnunciante;
end;

procedure TBanner.Set_DesTipoBanner(const Value: WideString);
begin
  FDesTipoBanner := Value;
end;

procedure TBanner.Set_DesTipoTarget(const Value: WideString);
begin
  FDesTipoTarget := Value;
end;

procedure TBanner.Set_NomAnunciante(const Value: WideString);
begin
  FNomAnunciante := Value;
end;

function TBanner.Get_DtaFimValidade: TDateTime;
begin
  Result  := FDtaFimValidade;
end;

procedure TBanner.Set_DtaFimValidade(Value: TDateTime);
begin
  FDtaFimValidade :=  Value;
end;

function TBanner.Get_TxtComandoTarget: WideString;
begin
  Result := FTxtComandoTarget;
end;

procedure TBanner.Set_TxtComandoTarget(const Value: WideString);
begin
  FTxtComandoTarget := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBanner, Class_Banner,
    ciMultiInstance, tmApartment);
end.
