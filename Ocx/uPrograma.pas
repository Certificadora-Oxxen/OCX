unit uPrograma;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TPrograma = class(TASPMTSObject, IPrograma)
  private
    FCodGrupoPaginas: Integer;
    FSeqPosicaoBanner: Integer;
    FDtaInicioAnuncio: TDateTime;
    FDtaFimAnuncio: TDateTime;
    FCodBanner: Integer;
    FDesGrupoPaginas: WideString;
    FDesPosicaoBanner: WideString;
    FNomArquivo: WideString;
  protected
    function Get_CodBanner: Integer; safecall;
    function Get_CodGrupoPaginas: Integer; safecall;
    function Get_DtaFimAnuncio: TDateTime; safecall;
    function Get_DtaInicioAnuncio: TDateTime; safecall;
    function Get_SeqPosicaoBanner: Integer; safecall;
    procedure Set_CodBanner(Value: Integer); safecall;
    procedure Set_CodGrupoPaginas(Value: Integer); safecall;
    procedure Set_DtaFimAnuncio(Value: TDateTime); safecall;
    procedure Set_DtaInicioAnuncio(Value: TDateTime); safecall;
    procedure Set_SeqPosicaoBanner(Value: Integer); safecall;
    function Get_DesGrupoPaginas: WideString; safecall;
    function Get_DesPosicaoBanner: WideString; safecall;
    function Get_NomArquivo: WideString; safecall;
    procedure Set_DesGrupoPaginas(const Value: WideString); safecall;
    procedure Set_DesPosicaoBanner(const Value: WideString); safecall;
    procedure Set_NomArquivo(const Value: WideString); safecall;
  public
    property CodGrupoPaginas: Integer     read FCodGrupoPaginas   write FCodGrupoPaginas;
    property SeqPosicaoBanner: Integer    read FSeqPosicaoBanner  write FSeqPosicaoBanner;
    property DtaInicioAnuncio: TDateTime  read FDtaInicioAnuncio  write FDtaInicioAnuncio;
    property DtaFimAnuncio: TDateTime     read FDtaFimAnuncio     write FDtaFimAnuncio;
    property CodBanner: Integer           read FCodBanner         write FCodBanner;
    property DesGrupoPaginas: WideString  read FDesGrupoPaginas   write FDesGrupoPaginas;
    property DesPosicaoBanner: WideString read FDesPosicaoBanner  write FDesPosicaoBanner;
    property NomArquivo: WideString       read FNomArquivo        write FNomArquivo;
  end;

implementation

uses ComServ;

function TPrograma.Get_CodBanner: Integer;
begin
  Result := FCodBanner;
end;

function TPrograma.Get_CodGrupoPaginas: Integer;
begin
  Result := FCodGrupoPaginas;
end;

function TPrograma.Get_DtaFimAnuncio: TDateTime;
begin
  Result := FDtaFimAnuncio;
end;

function TPrograma.Get_DtaInicioAnuncio: TDateTime;
begin
  Result := FDtaInicioAnuncio;
end;

function TPrograma.Get_SeqPosicaoBanner: Integer;
begin
  Result := FSeqPosicaoBanner;
end;

procedure TPrograma.Set_CodBanner(Value: Integer);
begin
  FCodBanner := Value;
end;

procedure TPrograma.Set_CodGrupoPaginas(Value: Integer);
begin
  FCodGrupoPaginas := Value;
end;

procedure TPrograma.Set_DtaFimAnuncio(Value: TDateTime);
begin
  FDtaFimAnuncio := Value;
end;

procedure TPrograma.Set_DtaInicioAnuncio(Value: TDateTime);
begin
  FDtaInicioAnuncio := Value;
end;

procedure TPrograma.Set_SeqPosicaoBanner(Value: Integer);
begin
  FSeqPosicaoBanner := Value;
end;

function TPrograma.Get_DesGrupoPaginas: WideString;
begin
  Result := FDesGrupoPaginas;
end;

function TPrograma.Get_DesPosicaoBanner: WideString;
begin
  Result := FDesPosicaoBanner;
end;

function TPrograma.Get_NomArquivo: WideString;
begin
  Result := FNomArquivo;
end;

procedure TPrograma.Set_DesGrupoPaginas(const Value: WideString);
begin
  FDesGrupoPaginas := Value;
end;

procedure TPrograma.Set_DesPosicaoBanner(const Value: WideString);
begin
  FDesPosicaoBanner := Value;
end;

procedure TPrograma.Set_NomArquivo(const Value: WideString);
begin
  FNomArquivo := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPrograma, Class_Programa,
    ciMultiInstance, tmApartment);
end.
