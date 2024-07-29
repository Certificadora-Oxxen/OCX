unit uUsuarios;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uUsuario,
  uIntUsuarios;

type
  TUsuarios = class(TASPMTSObject, IUsuarios)
  private
    FIntUsuarios : TIntUsuarios;
    FInicializado : Boolean;
    FUsuario: TUsuario;
  protected
    function Alterar(CodUsuario: Integer; const NomUsuario,
      TxtSenha: WideString; CodPerfil: Integer;
      const NomTratamento: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodUsuario: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(Codusuario: Integer): Integer; safecall;
    function Get_Usuario: IUsuario; safecall;
    function Inserir(const NomUsuario, TxtSenha: WideString;
      CodPerfil: Integer; const NomTratamento: WideString; CodPessoa,
      CodPapel: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const NomUsuario: WideString; CodPerfil: Integer;
      const IndUsuarioBloqueado: WideString; CodPessoa: Integer;
      const NomPessoa: WideString; CodPapel: Integer;
      const CodNaturezaPessoa, NumCNPJCPF: WideString;
      CodOrdenacao: Integer; IndPesquisarDesativados: WordBool): Integer;
      safecall;
    function seUsuarioFTP(CodUsuario: Integer): Integer; safecall;     
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntUsuario;


function TUsuarios.seUsuarioFTP(CodUsuario: Integer): Integer;
begin
  Result := FIntUsuarios.seUsuarioFTP(CodUsuario);
end;

procedure TUsuarios.AfterConstruction;
begin
  inherited;
  FUsuario := TUsuario.Create;
  FUsuario.ObjAddRef;
  FInicializado := False;
end;

procedure TUsuarios.BeforeDestruction;
begin
  If FIntUsuarios <> nil Then Begin
    FIntUsuarios.Free;
  End;
  If FUsuario <> nil Then Begin
    FUsuario.ObjRelease;
    FUsuario := nil;
  End;
  inherited;
end;

function TUsuarios.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntUsuarios := TIntUsuarios.Create;
  Result := FIntUsuarios.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TUsuarios.Alterar(CodUsuario: Integer; const NomUsuario,
  TxtSenha: WideString; CodPerfil: Integer;
  const NomTratamento: WideString): Integer;
begin
  Result := FIntUsuarios.Alterar(CodUsuario, NomUsuario, TxtSenha, CodPerfil, NomTratamento);
end;

function TUsuarios.BOF: WordBool;
begin
  Result := FIntUsuarios.BOF;
end;

function TUsuarios.Buscar(CodUsuario: Integer): Integer;
begin
  Result := FIntUsuarios.Buscar(CodUsuario);
end;

function TUsuarios.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntUsuarios.Deslocar(QtdRegistros);
end;

function TUsuarios.EOF: WordBool;
begin
  Result := FIntUsuarios.EOF;
end;

function TUsuarios.Excluir(CodUsuario: Integer): Integer;
begin
  Result := FIntUsuarios.Excluir(CodUsuario);
end;

function TUsuarios.Get_Usuario: IUsuario;
begin
  FUsuario.CodUsuario               := FIntUsuarios.IntUsuario.CodUsuario;
  FUsuario.NomUsuario               := FIntUsuarios.IntUsuario.NomUsuario;
  FUsuario.NomTratamento            := FIntUsuarios.IntUsuario.NomTratamento;
  FUsuario.CodPessoa                := FIntUsuarios.IntUsuario.CodPessoa;
  FUsuario.NomPessoa                := FIntUsuarios.IntUsuario.NomPessoa;
  FUsuario.CodNaturezaPessoa        := FIntUsuarios.IntUsuario.CodNaturezaPessoa;
  FUsuario.NumCNPJCPF               := FIntUsuarios.IntUsuario.NumCNPJCPF;
  FUsuario.CodPapel                 := FIntUsuarios.IntUsuario.CodPapel;
  FUsuario.DesPapel                 := FIntUsuarios.IntUsuario.DesPapel;
  FUsuario.CodPerfil                := FIntUsuarios.IntUsuario.CodPerfil;
  FUsuario.DesPerfil                := FIntUsuarios.IntUsuario.DesPerfil;
  FUsuario.QtdAcumLoginsCorretos    := FIntUsuarios.IntUsuario.QtdAcumLoginsCorretos;
  FUsuario.QtdAcumLoginsIncorretos  := FIntUsuarios.IntUsuario.QtdAcumLoginsIncorretos;
  FUsuario.DtaUltimoLoginCorreto    := FIntUsuarios.IntUsuario.DtaUltimoLoginCorreto;
  FUsuario.DtaUltimoLoginIncorreto  := FIntUsuarios.IntUsuario.DtaUltimoLoginIncorreto;
  FUsuario.QtdLoginsIncorretos      := FIntUsuarios.IntUsuario.QtdLoginsIncorretos;
  FUsuario.DtaCriacaoUsuario        := FIntUsuarios.IntUsuario.DtaCriacaoUsuario;
  FUsuario.NumCNPJCPFFormatado      := FIntUsuarios.IntUsuario.NumCNPJCPFFormatado;
  FUsuario.DtaPenultimoLoginCorreto := FIntUsuarios.IntUsuario.DtaPenultimoLoginCorreto;
  FUsuario.DtaFimValidade           := FIntUsuarios.IntUsuario.DtaFimValidade;
  FUsuario.IndUsuarioFTP            := FIntUsuarios.IntUsuario.IndUsuarioFTP;
  FUsuario.NomUsuarioReduzido       := FIntUsuarios.IntUsuario.NomUsuarioReduzido;
  Result := FUsuario;
end;

function TUsuarios.Inserir(const NomUsuario, TxtSenha: WideString;
  CodPerfil: Integer; const NomTratamento: WideString; CodPessoa,
  CodPapel: Integer): Integer;
begin
  Result := FIntUsuarios.Inserir(NomUsuario, TxtSenha, CodPerfil, NomTratamento, CodPessoa, CodPapel);
end;

function TUsuarios.NumeroRegistros: Integer;
begin
  Result := FIntUsuarios.NumeroRegistros;
end;

function TUsuarios.Pesquisar(const NomUsuario: WideString;
  CodPerfil: Integer; const IndUsuarioBloqueado: WideString;
  CodPessoa: Integer; const NomPessoa: WideString; CodPapel: Integer;
  const CodNaturezaPessoa, NumCNPJCPF: WideString; CodOrdenacao: Integer;
  IndPesquisarDesativados: WordBool): Integer;
begin
  Result := FIntUsuarios.Pesquisar(NomUsuario, CodPerfil, IndUsuarioBloqueado, CodPessoa,
    NomPessoa, CodPapel, CodNaturezaPessoa, NumCNPJCPF, CodOrdenacao,IndPesquisarDesativados);
end;

function TUsuarios.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntUsuarios.ValorCampo(NomeColuna);
end;

procedure TUsuarios.FecharPesquisa;
begin
  FIntUsuarios.FecharPesquisa;
end;

procedure TUsuarios.IrAoAnterior;
begin
  FIntUsuarios.IrAoAnterior;
end;

procedure TUsuarios.IrAoPrimeiro;
begin
  FIntUsuarios.IrAoPrimeiro;
end;

procedure TUsuarios.IrAoProximo;
begin
  FIntUsuarios.IrAoProximo;
end;

procedure TUsuarios.IrAoUltimo;
begin
  FIntUsuarios.IrAoUltimo;
end;

procedure TUsuarios.Posicionar(NumRegistro: Integer);
begin
  FIntUsuarios.Posicionar(NumRegistro);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TUsuarios, Class_Usuarios,
    ciMultiInstance, tmApartment);
end.
