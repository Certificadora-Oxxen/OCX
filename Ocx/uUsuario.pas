unit uUsuario;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TUsuario = class(TASPMTSObject, IUsuario)
  private
    FCodUsuario                : Integer;
    FNomUsuario                : WideString;
    FNomTratamento             : WideString;
    FCodPessoa                 : Integer;
    FNomPessoa                 : WideString;
    FCodNaturezaPessoa         : WideString;
    FNumCNPJCPF                : WideString;
    FCodPapel                  : Integer;
    FDesPapel                  : WideString;
    FCodPerfil                 : Integer;
    FDesPerfil                 : WideString;
    FQtdAcumLoginsCorretos     : Integer;
    FQtdAcumLoginsIncorretos   : Integer;
    FDtaUltimoLoginCorreto     : TDateTime;
    FDtaUltimoLoginIncorreto   : TDateTime;
    FQtdLoginsIncorretos       : Integer;
    FDtaCriacaoUsuario         : TDateTime;
    FNumCNPJCPFFormatado       : WideString;
    FDtaPenultimoLoginCorreto  : TDateTime;
    FDtaFimValidade            : TDateTime;
    FIndUsuarioFTP             : WideString;
    FNomUsuarioReduzido        : WideString;
  protected
    function Get_CodPapel: Integer; safecall;
    function Get_CodPerfil: Integer; safecall;
    function Get_CodPessoa: Integer; safecall;
    function Get_CodUsuario: Integer; safecall;
    function Get_DesPapel: WideString; safecall;
    function Get_DesPerfil: WideString; safecall;
    function Get_DtaCriacaoUsuario: TDateTime; safecall;
    function Get_DtaUltimoLoginCorreto: TDateTime; safecall;
    function Get_DtaUltimoLoginIncorreto: TDateTime; safecall;
    function Get_CodNaturezaPessoa: WideString; safecall;
    function Get_NomPessoa: WideString; safecall;
    function Get_NomTratamento: WideString; safecall;
    function Get_NomUsuario: WideString; safecall;
    function Get_NumCNPJCPF: WideString; safecall;
    function Get_QtdAcumLoginsCorretos: Integer; safecall;
    function Get_QtdAcumLoginsIncorretos: Integer; safecall;
    function Get_QtdLoginsIncorretos: Integer; safecall;
    procedure Set_CodPapel(Value: Integer); safecall;
    procedure Set_CodPerfil(Value: Integer); safecall;
    procedure Set_CodPessoa(Value: Integer); safecall;
    procedure Set_CodUsuario(Value: Integer); safecall;
    procedure Set_DesPapel(const Value: WideString); safecall;
    procedure Set_DesPerfil(const Value: WideString); safecall;
    procedure Set_DtaCriacaoUsuario(Value: TDateTime); safecall;
    procedure Set_DtaUltimoLoginCorreto(Value: TDateTime); safecall;
    procedure Set_DtaUltimoLoginIncorreto(Value: TDateTime); safecall;
    procedure Set_CodNaturezaPessoa(const Value: WideString); safecall;
    procedure Set_NomPessoa(const Value: WideString); safecall;
    procedure Set_NomTratamento(const Value: WideString); safecall;
    procedure Set_NomUsuario(const Value: WideString); safecall;
    procedure Set_NumCNPJCPF(const Value: WideString); safecall;
    procedure Set_QtdAcumLoginsCorretos(Value: Integer); safecall;
    procedure Set_QtdAcumLoginsIncorretos(Value: Integer); safecall;
    procedure Set_QtdLoginsIncorretos(Value: Integer); safecall;
    function Get_NumCNPJCPFFormatado: WideString; safecall;
    procedure Set_NumCNPJCPFFormatado(const Value: WideString); safecall;
    function Get_DtaPenultimoLoginCorreto: TDateTime; safecall;
    procedure Set_DtaPenultimoLoginCorreto(Value: TDateTime); safecall;
    function Get_DtaFimValidade: TDateTime; safecall;
    procedure Set_DtaFimValidade(Value: TDateTime); safecall;
    function Get_IndUsuarioFTP: WideString; safecall;
    procedure Set_IndUsuarioFTP(const Value: WideString); safecall;
    function Get_NomUsuarioReduzido: WideString; safecall;
    procedure Set_NomUsuarioReduzido(const Value: WideString); safecall;
  public
    property CodUsuario               : Integer        read FCodUsuario               write FCodUsuario;
    property NomUsuario               : WideString     read FNomUsuario               write FNomUsuario;
    property NomTratamento            : WideString     read FNomTratamento            write FNomTratamento;
    property CodPessoa                : Integer        read FCodPessoa                write FCodPessoa;
    property NomPessoa                : WideString     read FNomPessoa                write FNomPessoa;
    property CodNaturezaPessoa        : WideString     read FCodNaturezaPessoa        write FCodNaturezaPessoa;
    property NumCNPJCPF               : WideString     read FNumCNPJCPF               write FNumCNPJCPF;
    property CodPapel                 : Integer        read FCodPapel                 write FCodPapel;
    property DesPapel                 : WideString     read FDesPapel                 write FDesPapel;
    property CodPerfil                : Integer        read FCodPerfil                write FCodPerfil;
    property DesPerfil                : WideString     read FDesPerfil                write FDesPerfil;
    property QtdAcumLoginsCorretos    : Integer        read FQtdAcumLoginsCorretos    write FQtdAcumLoginsCorretos;
    property QtdAcumLoginsIncorretos  : Integer        read FQtdAcumLoginsIncorretos  write FQtdAcumLoginsIncorretos;
    property DtaUltimoLoginCorreto    : TDateTime      read FDtaUltimoLoginCorreto    write FDtaUltimoLoginCorreto;
    property DtaUltimoLoginIncorreto  : TDateTime      read FDtaUltimoLoginIncorreto  write FDtaUltimoLoginIncorreto;
    property QtdLoginsIncorretos      : Integer        read FQtdLoginsIncorretos      write FQtdLoginsIncorretos;
    property DtaCriacaoUsuario        : TDateTime      read FDtaCriacaoUsuario        write FDtaCriacaoUsuario;
    property NumCNPJCPFFormatado      : WideString     read FNumCNPJCPFFormatado      write FNumCNPJCPFFormatado;
    property DtaPenultimoLoginCorreto : TDateTime      read FDtaPenultimoLoginCorreto write FDtaPenultimoLoginCorreto;
    property DtaFimValidade           : TDateTime      read FDtaFimValidade           write FDtaFimValidade;
    property IndUsuarioFTP            : WideString     read FIndUsuarioFTP            write FIndUsuarioFTP;
    property NomUsuarioReduzido      : WideString     read FNomUsuarioReduzido       write FNomUsuarioReduzido;    
  end;

implementation

uses ComServ;

function TUsuario.Get_CodPapel: Integer;
begin
  Result := FCodPapel;
end;

function TUsuario.Get_CodPerfil: Integer;
begin
  Result := FCodPerfil;
end;

function TUsuario.Get_CodPessoa: Integer;
begin
  Result := FCodPessoa;
end;

function TUsuario.Get_CodUsuario: Integer;
begin
  Result := FCodUsuario;
end;

function TUsuario.Get_DesPapel: WideString;
begin
  Result := FDesPapel;
end;

function TUsuario.Get_DesPerfil: WideString;
begin
  Result := FDesPerfil;
end;

function TUsuario.Get_DtaCriacaoUsuario: TDateTime;
begin
  Result := FDtaCriacaoUsuario;
end;

function TUsuario.Get_DtaUltimoLoginCorreto: TDateTime;
begin
  Result := FDtaUltimoLoginCorreto;
end;

function TUsuario.Get_DtaUltimoLoginIncorreto: TDateTime;
begin
  Result := FDtaUltimoLoginIncorreto;
end;

function TUsuario.Get_CodNaturezaPessoa: WideString;
begin
  Result := FCodNaturezaPessoa;
end;

function TUsuario.Get_NomPessoa: WideString;
begin
  Result := FNomPessoa;
end;

function TUsuario.Get_NomTratamento: WideString;
begin
  Result := FNomTratamento;
end;

function TUsuario.Get_NomUsuario: WideString;
begin
  Result := FNomUsuario;
end;

function TUsuario.Get_NumCNPJCPF: WideString;
begin
  Result := FNumCNPJCPF;
end;

function TUsuario.Get_QtdAcumLoginsCorretos: Integer;
begin
  Result := FQtdAcumLoginsCorretos;
end;

function TUsuario.Get_QtdAcumLoginsIncorretos: Integer;
begin
  Result := FQtdAcumLoginsIncorretos;
end;

function TUsuario.Get_QtdLoginsIncorretos: Integer;
begin
  Result := FQtdLoginsIncorretos;
end;

procedure TUsuario.Set_CodPapel(Value: Integer);
begin
  FCodPapel := Value;
end;

procedure TUsuario.Set_CodPerfil(Value: Integer);
begin
  FCodPerfil := Value;
end;

procedure TUsuario.Set_CodPessoa(Value: Integer);
begin
  FCodPessoa := Value;
end;

procedure TUsuario.Set_CodUsuario(Value: Integer);
begin
  FCodUsuario := Value;
end;

procedure TUsuario.Set_DesPapel(const Value: WideString);
begin
  FDesPapel := Value;
end;

procedure TUsuario.Set_DesPerfil(const Value: WideString);
begin
  FDesPerfil := Value;
end;

procedure TUsuario.Set_DtaCriacaoUsuario(Value: TDateTime);
begin
  FDtaCriacaoUsuario := Value;
end;

procedure TUsuario.Set_DtaUltimoLoginCorreto(Value: TDateTime);
begin
  FDtaUltimoLoginCorreto := Value;
end;

procedure TUsuario.Set_DtaUltimoLoginIncorreto(Value: TDateTime);
begin
  FDtaUltimoLoginIncorreto := Value;
end;

procedure TUsuario.Set_CodNaturezaPessoa(const Value: WideString);
begin
  FCodNaturezaPessoa := Value;
end;

procedure TUsuario.Set_NomPessoa(const Value: WideString);
begin
  FNomPessoa := Value;
end;

procedure TUsuario.Set_NomTratamento(const Value: WideString);
begin
  FNomTratamento := Value;
end;

procedure TUsuario.Set_NomUsuario(const Value: WideString);
begin
  FNomUsuario := Value;
end;

procedure TUsuario.Set_NumCNPJCPF(const Value: WideString);
begin
  FNumCNPJCPF := Value;
end;

procedure TUsuario.Set_QtdAcumLoginsCorretos(Value: Integer);
begin
  FQtdAcumLoginsCorretos := Value;
end;

procedure TUsuario.Set_QtdAcumLoginsIncorretos(Value: Integer);
begin
  FQtdAcumLoginsIncorretos := Value;
end;

procedure TUsuario.Set_QtdLoginsIncorretos(Value: Integer);
begin
  FQtdLoginsIncorretos := Value;
end;

function TUsuario.Get_NumCNPJCPFFormatado: WideString;
begin
  Result := FNumCNPJCPFFormatado;
end;

procedure TUsuario.Set_NumCNPJCPFFormatado(const Value: WideString);
begin
  FNumCNPJCPFFormatado := Value;
end;

function TUsuario.Get_DtaPenultimoLoginCorreto: TDateTime;
begin
  Result := FDtaPenultimoLoginCorreto;
end;

procedure TUsuario.Set_DtaPenultimoLoginCorreto(Value: TDateTime);
begin
  FDtaPenultimoLoginCorreto := Value;
end;

function TUsuario.Get_DtaFimValidade: TDateTime;
begin
  Result := FDtaFimValidade;
end;

procedure TUsuario.Set_DtaFimValidade(Value: TDateTime);
begin
  FDtaFimValidade := value;
end;

function TUsuario.Get_IndUsuarioFTP: WideString;
begin
  Result := FIndUsuarioFTP;
end;

procedure TUsuario.Set_IndUsuarioFTP(const Value: WideString);
begin
  FIndUsuarioFTP := Value;
end;

function TUsuario.Get_NomUsuarioReduzido: WideString;
begin
   Result := FNomUsuarioReduzido;
end;

procedure TUsuario.Set_NomUsuarioReduzido(const Value: WideString);
begin
   FNomUsuarioReduzido := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TUsuario, Class_Usuario,
    ciMultiInstance, tmApartment);
end.
