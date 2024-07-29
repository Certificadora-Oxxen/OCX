unit uBloqueio;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TBloqueio = class(TASPMTSObject, IBloqueio)
  private
    FDtaInicioBloqueio: TDateTime;
    FCodMotivoBloqueio: Integer;
    FCodAplicacaoBloqueio: WideString;
    FTxtMotivoBloqueio: WideString;
    FTxtObservacaoBloqueio: WideString;
    FTxtObservacaoUsuario: WideString;
    FTxtProcedimentoUsuario: WideString;
    FCodUsuario: Integer;
    FCodPessoaProdutor: Integer;
    FTxtMotivoUsuario: WideString;
    FCodUsuarioResponsavel: Integer;
    FNomUsuarioResponsavel: WideString;
    FNomUsuario: WideString;
    FNomPessoa: WideString;
    FDtaFimBloqueio: TDatetime;
  protected
    function Get_CodAplicacaoBloqueio: WideString; safecall;
    function Get_CodMotivoBloqueio: Integer; safecall;
    function Get_DtaInicioBloqueio: TDateTime; safecall;
    function Get_DtaFimBloqueio: TDateTime; safecall;
    function Get_TxtMotivoBloqueio: WideString; safecall;
    function Get_TxtObservacaoBloqueio: WideString; safecall;
    function Get_TxtObservacaoUsuario: WideString; safecall;
    function Get_TxtProcedimentoUsuario: WideString; safecall;
    procedure Set_CodAplicacaoBloqueio(const Value: WideString); safecall;
    procedure Set_CodMotivoBloqueio(Value: Integer); safecall;
    procedure Set_DtaInicioBloqueio(Value: TDateTime); safecall;
    procedure Set_DtaFimBloqueio(Value: TDateTime); safecall;
    procedure Set_TxtMotivoBloqueio(const Value: WideString); safecall;
    procedure Set_TxtObservacaoBloqueio(const Value: WideString); safecall;
    procedure Set_TxtObservacaoUsuario(const Value: WideString); safecall;
    procedure Set_TxtProcedimentoUsuario(const Value: WideString); safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodUsuario: Integer; safecall;
    function Get_CodUsuarioResponsavel: Integer; safecall;
    function Get_NomUsuarioResponsavel: WideString; safecall;
    function Get_TxtMotivoUsuario: WideString; safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodUsuario(Value: Integer); safecall;
    procedure Set_CodUsuarioResponsavel(Value: Integer); safecall;
    procedure Set_NomUsuarioResponsavel(const Value: WideString); safecall;
    procedure Set_TxtMotivoUsuario(const Value: WideString); safecall;
    function Get_NomPessoa: WideString; safecall;
    function Get_NomUsuario: WideString; safecall;
    procedure Set_NomPessoa(const Value: WideString); safecall;
    procedure Set_NomUsuario(const Value: WideString); safecall;
  public
    property DtaInicioBloqueio: TDateTime       read FDtaInicioBloqueio      write FDtaInicioBloqueio;
    property CodMotivoBloqueio: Integer         read FCodMotivoBloqueio      write FCodMotivoBloqueio;
    property CodAplicacaoBloqueio: WideString   read FCodAplicacaoBloqueio   write FCodAplicacaoBloqueio;
    property TxtMotivoBloqueio: WideString      read FTxtMotivoBloqueio      write FTxtMotivoBloqueio;
    property TxtObservacaoBloqueio: WideString  read FTxtObservacaoBloqueio  write FTxtObservacaoBloqueio;
    property TxtObservacaoUsuario: WideString   read FTxtObservacaoUsuario   write FTxtObservacaoUsuario;
    property TxtProcedimentoUsuario: WideString read FTxtProcedimentoUsuario write FTxtProcedimentoUsuario;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property TxtMotivoUsuario: WideString read FTxtMotivoUsuario write FTxtMotivoUsuario;
    property CodUsuarioResponsavel: Integer read FCodUsuarioResponsavel write FCodUsuarioResponsavel;
    property NomUsuarioResponsavel: WideString read FNomUsuarioResponsavel write FNomUsuarioResponsavel;
    property NomUsuario: WideString read FNomUsuario write FNomUsuario;
    property NomPessoa: WideString read FNomPessoa write FNomPessoa;
    property DtaFimBloqueio: TDateTime read FDtaFimBloqueio      write FDtaFimBloqueio;
  end;

implementation

uses ComServ;

function TBloqueio.Get_CodAplicacaoBloqueio: WideString;
begin
  Result := FCodAplicacaoBloqueio;
end;

function TBloqueio.Get_CodMotivoBloqueio: Integer;
begin
  Result := FCodMotivoBloqueio;
end;

function TBloqueio.Get_DtaInicioBloqueio: TDateTime;
begin
  Result := FDtaInicioBloqueio;
end;

function TBloqueio.Get_TxtMotivoBloqueio: WideString;
begin
  Result := FTxtMotivoBloqueio;
end;

function TBloqueio.Get_TxtObservacaoBloqueio: WideString;
begin
  Result := FTxtObservacaoBloqueio;
end;

function TBloqueio.Get_TxtObservacaoUsuario: WideString;
begin
  Result := FTxtObservacaoUsuario;
end;

function TBloqueio.Get_TxtProcedimentoUsuario: WideString;
begin
  Result := FTxtProcedimentoUsuario;
end;

procedure TBloqueio.Set_CodAplicacaoBloqueio(const Value: WideString);
begin
  FCodAplicacaoBloqueio := Value;
end;

procedure TBloqueio.Set_CodMotivoBloqueio(Value: Integer);
begin
  FCodMotivoBloqueio := Value;
end;

procedure TBloqueio.Set_DtaInicioBloqueio(Value: TDateTime);
begin
  FDtaInicioBloqueio := Value;
end;

procedure TBloqueio.Set_TxtMotivoBloqueio(const Value: WideString);
begin
  FTxtMotivoBloqueio := Value;
end;

procedure TBloqueio.Set_TxtObservacaoBloqueio(const Value: WideString);
begin
  FTxtObservacaoBloqueio := Value;
end;

procedure TBloqueio.Set_TxtObservacaoUsuario(const Value: WideString);
begin
  FTxtObservacaoUsuario := Value;
end;

procedure TBloqueio.Set_TxtProcedimentoUsuario(const Value: WideString);
begin
  FTxtProcedimentoUsuario := Value;
end;

function TBloqueio.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TBloqueio.Get_CodUsuario: Integer;
begin
  Result := FCodUsuario;
end;

function TBloqueio.Get_CodUsuarioResponsavel: Integer;
begin
  Result := FCodUsuarioResponsavel;
end;

function TBloqueio.Get_NomUsuarioResponsavel: WideString;
begin
  Result := FNomUsuarioResponsavel;
end;

function TBloqueio.Get_TxtMotivoUsuario: WideString;
begin
  Result := FTxtMotivoUsuario;
end;

procedure TBloqueio.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TBloqueio.Set_CodUsuario(Value: Integer);
begin
  FCodUsuario := Value;
end;

procedure TBloqueio.Set_CodUsuarioResponsavel(Value: Integer);
begin
  FCodUsuarioResponsavel := Value;
end;

procedure TBloqueio.Set_NomUsuarioResponsavel(const Value: WideString);
begin
  FNomUsuarioResponsavel := Value;
end;

procedure TBloqueio.Set_TxtMotivoUsuario(const Value: WideString);
begin
  FTxtMotivoUsuario := Value;
end;

function TBloqueio.Get_NomPessoa: WideString;
begin
  Result := FNomPessoa;
end;

function TBloqueio.Get_NomUsuario: WideString;
begin
  Result := FNomUsuario;
end;

procedure TBloqueio.Set_NomPessoa(const Value: WideString);
begin
  FNomPessoa := Value;
end;

procedure TBloqueio.Set_NomUsuario(const Value: WideString);
begin
  FNomUsuario := Value;
end;

function TBloqueio.Get_DtaFimBloqueio: TDateTime;
begin
  Result := FDtaFimBloqueio;
end;

procedure TBloqueio.Set_DtaFimBloqueio(Value: TDateTime);
begin
  FDtaFimBloqueio := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBloqueio, Class_Bloqueio,
    ciMultiInstance, tmApartment);
end.
