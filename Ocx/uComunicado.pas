unit uComunicado;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uPessoa;

type
  TComunicado = class(TASPMTSObject, IComunicado)
  private
    FCodComunicado: Integer;
    FTxtAssunto: WideString;
    FTxtComunicado: WideString;
    FDtaInicioValidade: TDateTime;
    FDtaFimValidade: TDateTime;
    FDtaEnvioComunicado: TDateTime;
    FCodUsuarioEnvio: Integer;
    FNomUsuarioEnvio: WideString;
    FPessoaEnvio: TPessoa;
    FCodPapelEnvio: Integer;
    FDesPapelEnvio: WideString;
    FCodOpcaoEnvio: Integer;
    FDesOpcaoEnvio: WideString;
    FCodUsuarioOpcaoEnvio: Integer;
    FNomUsuarioOpcaoEnvio: WideString;
    FPessoaOpcaoEnvio: TPessoa;
    FCodPapelOpcaoEnvio: Integer;
    FDesPapelOpcaoEnvio: WideString;
    FDesSituacao: WideString;
    FDtaLeitura: TDateTime;
  protected
    function Get_CodComunicado: Integer; safecall;
    function Get_CodUsuarioEnvio: Integer; safecall;
    function Get_DtaEnvioComunicado: TDateTime; safecall;
    function Get_DtaFimValidade: TDateTime; safecall;
    function Get_DtaInicioValidade: TDateTime; safecall;
    function Get_NomUsuarioEnvio: WideString; safecall;
    function Get_TxtAssunto: WideString; safecall;
    function Get_TxtComunicado: WideString; safecall;
    procedure Set_CodComunicado(Value: Integer); safecall;
    procedure Set_CodUsuarioEnvio(Value: Integer); safecall;
    procedure Set_DtaEnvioComunicado(Value: TDateTime); safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;
    procedure Set_DtaInicioValidade(Value: TDateTime); safecall;
    procedure Set_NomUsuarioEnvio(const Value: WideString); safecall;
    procedure Set_TxtAssunto(const Value: WideString); safecall;
    procedure Set_TxtComunicado(const Value: WideString); safecall;
    function Get_DesSituacao: WideString; safecall;
    function Get_DtaLeitura: TDateTime; safecall;
    procedure Set_DesSituacao(const Value: WideString); safecall;
    procedure Set_DtaLeitura(Value: TDateTime); safecall;
    function Get_PessoaEnvio: IPessoa; safecall;
    procedure Set_PessoaEnvio(const Value: IPessoa); safecall;
    function Get_CodPapelEnvio: Integer; safecall;
    procedure Set_CodPapelEnvio(Value: Integer); safecall;
    function Get_DesPapelEnvio: WideString; safecall;
    procedure Set_DesPapelEnvio(const Value: WideString); safecall;
    function Get_CodOpcaoEnvio: Integer; safecall;
    procedure Set_CodOpcaoEnvio(Value: Integer); safecall;
    function Get_DesOpcaoEnvio: WideString; safecall;
    procedure Set_DesOpcaoEnvio(const Value: WideString); safecall;
    function Get_CodUsuarioOpcaoEnvio: Integer; safecall;
    procedure Set_CodUsuarioOpcaoEnvio(Value: Integer); safecall;
    function Get_NomUsuarioOpcaoEnvio: WideString; safecall;
    procedure Set_NomUsuarioOpcaoEnvio(const Value: WideString); safecall;
    function Get_PessoaOpcaoEnvio: IPessoa; safecall;
    procedure Set_PessoaOpcaoEnvio(const Value: IPessoa); safecall;
    function Get_CodPapelOpcaoEnvio: Integer; safecall;
    procedure Set_CodPapelOpcaoEnvio(Value: Integer); safecall;
    function Get_DesPapelOpcaoEnvio: WideString; safecall;
    procedure Set_DesPapelOpcaoEnvio(const Value: WideString); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property CodComunicado: Integer read FCodComunicado write FCodComunicado;
    property TxtAssunto: WideString read FTxtAssunto write FTxtAssunto;
    property TxtComunicado: WideString read FTxtComunicado write FTxtComunicado;
    property DtaInicioValidade: TDateTime read FDtaInicioValidade write FDtaInicioValidade;
    property DtaFimValidade: TDateTime read FDtaFimValidade write FDtaFimValidade;
    property DtaEnvioComunicado: TDateTime read FDtaEnvioComunicado write FDtaEnvioComunicado;
    property CodUsuarioEnvio: Integer read FCodUsuarioEnvio write FCodUsuarioEnvio;
    property NomUsuarioEnvio: WideString read FNomUsuarioEnvio write FNomUsuarioEnvio;
    property PessoaEnvio: TPessoa read FPessoaEnvio write FPessoaEnvio;
    property CodPapelEnvio: Integer read FCodPapelEnvio write FCodPapelEnvio;
    property DesPapelEnvio: WideString read FDesPapelEnvio write FDesPapelEnvio;
    property CodOpcaoEnvio: Integer read FCodOpcaoEnvio write FCodOpcaoEnvio;
    property DesOpcaoEnvio: WideString read FDesOpcaoEnvio write FDesOpcaoEnvio;
    property CodUsuarioOpcaoEnvio: Integer read FCodUsuarioOpcaoEnvio write FCodUsuarioOpcaoEnvio;
    property NomUsuarioOpcaoEnvio: WideString read FNomUsuarioOpcaoEnvio write FNomUsuarioOpcaoEnvio;
    property PessoaOpcaoEnvio: TPessoa read FPessoaOpcaoEnvio write FPessoaOpcaoEnvio;
    property CodPapelOpcaoEnvio: Integer read FCodPapelOpcaoEnvio write FCodPapelOpcaoEnvio;
    property DesPapelOpcaoEnvio: WideString read FDesPapelOpcaoEnvio write FDesPapelOpcaoEnvio;
    property DesSituacao: WideString read FDesSituacao write FDesSituacao;
    property DtaLeitura: TDateTime read FDtaLeitura write FDtaLeitura;
  end;

implementation

uses ComServ;

procedure TComunicado.AfterConstruction;
begin
  inherited;

  FPessoaEnvio := TPessoa.Create;
  FPessoaEnvio.ObjAddRef;
  FPessoaOpcaoEnvio := TPessoa.Create;
  FPessoaOpcaoEnvio.ObjAddRef;
end;

procedure TComunicado.BeforeDestruction;
begin
  If FPessoaEnvio <> nil Then Begin
    FPessoaEnvio.ObjRelease;
    FPessoaEnvio := nil;
  End;
  If FPessoaOpcaoEnvio <> nil Then Begin
    FPessoaOpcaoEnvio.ObjRelease;
    FPessoaOpcaoEnvio := nil;
  End;

  inherited;
end;

function TComunicado.Get_CodComunicado: Integer;
begin
  Result := FCodComunicado;
end;

function TComunicado.Get_CodUsuarioEnvio: Integer;
begin
  Result := FCodUsuarioEnvio;
end;

function TComunicado.Get_DtaEnvioComunicado: TDateTime;
begin
  Result := FDtaEnvioComunicado;
end;

function TComunicado.Get_DtaFimValidade: TDateTime;
begin
  Result := FDtaFimValidade;
end;

function TComunicado.Get_DtaInicioValidade: TDateTime;
begin
  Result := FDtaInicioValidade;
end;

function TComunicado.Get_NomUsuarioEnvio: WideString;
begin
  Result := FNomUsuarioEnvio;
end;

function TComunicado.Get_TxtAssunto: WideString;
begin
  Result := FTxtAssunto;
end;

function TComunicado.Get_TxtComunicado: WideString;
begin
  Result := FTxtComunicado;
end;

procedure TComunicado.Set_CodComunicado(Value: Integer);
begin
  FCodComunicado := Value;
end;

procedure TComunicado.Set_CodUsuarioEnvio(Value: Integer);
begin
  FCodUsuarioEnvio := Value;
end;

procedure TComunicado.Set_DtaEnvioComunicado(Value: TDateTime);
begin
  FDtaEnvioComunicado := Value;
end;

procedure TComunicado.Set_DtaFimValidade(Value: TDateTime);
begin
 FDtaFimValidade := Value;
end;

procedure TComunicado.Set_DtaInicioValidade(Value: TDateTime);
begin
  FDtaInicioValidade := Value;
end;

procedure TComunicado.Set_NomUsuarioEnvio(const Value: WideString);
begin
  FNomUsuarioEnvio := Value;
end;

procedure TComunicado.Set_TxtAssunto(const Value: WideString);
begin
  FTxtAssunto := Value;
end;

procedure TComunicado.Set_TxtComunicado(const Value: WideString);
begin
  FTxtComunicado := Value;
end;

function TComunicado.Get_DesSituacao: WideString;
begin
  Result := FDesSituacao;
end;

function TComunicado.Get_DtaLeitura: TDateTime;
begin
  Result := FDtaLeitura;
end;

procedure TComunicado.Set_DesSituacao(const Value: WideString);
begin
  FDesSituacao := Value;
end;

procedure TComunicado.Set_DtaLeitura(Value: TDateTime);
begin
  FDtaLeitura := Value;
end;

function TComunicado.Get_PessoaEnvio: IPessoa;
begin
  Result := FPessoaEnvio;
end;

procedure TComunicado.Set_PessoaEnvio(const Value: IPessoa);
begin
  FPessoaEnvio := TPessoa(Value);
end;

function TComunicado.Get_CodPapelEnvio: Integer;
begin
  Result := FCodPapelEnvio;
end;

procedure TComunicado.Set_CodPapelEnvio(Value: Integer);
begin
  FCodPapelEnvio := Value;
end;

function TComunicado.Get_DesPapelEnvio: WideString;
begin
  Result := FDesPapelEnvio;
end;

procedure TComunicado.Set_DesPapelEnvio(const Value: WideString);
begin
  FDesPapelEnvio := Value;
end;

function TComunicado.Get_CodOpcaoEnvio: Integer;
begin
  Result := FCodOpcaoEnvio;
end;

procedure TComunicado.Set_CodOpcaoEnvio(Value: Integer);
begin
  FCodOpcaoEnvio := Value;
end;

function TComunicado.Get_DesOpcaoEnvio: WideString;
begin
  Result := FDesOpcaoEnvio;
end;

procedure TComunicado.Set_DesOpcaoEnvio(const Value: WideString);
begin
  FDesOpcaoEnvio := Value;
end;

function TComunicado.Get_CodUsuarioOpcaoEnvio: Integer;
begin
  Result := FCodUsuarioOpcaoEnvio;
end;

procedure TComunicado.Set_CodUsuarioOpcaoEnvio(Value: Integer);
begin
  FCodUsuarioOpcaoEnvio := Value;
end;

function TComunicado.Get_NomUsuarioOpcaoEnvio: WideString;
begin
  Result := FNomUsuarioOpcaoEnvio;
end;

procedure TComunicado.Set_NomUsuarioOpcaoEnvio(const Value: WideString);
begin
  FNomUsuarioOpcaoEnvio := Value;
end;

function TComunicado.Get_PessoaOpcaoEnvio: IPessoa;
begin
  Result := FPessoaOpcaoEnvio;
end;

procedure TComunicado.Set_PessoaOpcaoEnvio(const Value: IPessoa);
begin
  FPessoaOpcaoEnvio := TPessoa(Value);
end;

function TComunicado.Get_CodPapelOpcaoEnvio: Integer;
begin
  Result := FCodPapelOpcaoEnvio;
end;

procedure TComunicado.Set_CodPapelOpcaoEnvio(Value: Integer);
begin
  FCodPapelOpcaoEnvio := Value;
end;

function TComunicado.Get_DesPapelOpcaoEnvio: WideString;
begin
  Result := FDesPapelOpcaoEnvio;
end;

procedure TComunicado.Set_DesPapelOpcaoEnvio(const Value: WideString);
begin
  FDesPapelOpcaoEnvio := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TComunicado, Class_Comunicado,
    ciMultiInstance, tmApartment);
end.
