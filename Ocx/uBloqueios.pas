unit uBloqueios;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uBloqueio,
  uIntBloqueios;

type
  TBloqueios = class(TASPMTSObject, IBloqueios)
  private
    FIntBloqueios : TIntBloqueios;
    FInicializado : Boolean;
    FBloqueio: TBloqueio;
  protected
    function BOF: WordBool; safecall;
    function Buscar(const CodAplicacaoBloqueio: WideString; CodUsuario,
      CodPessoaProdutor: Integer; DtaInicioBloqueio: TDateTime): Integer;
      safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(const CodAplicacaoBloqueio: WideString; CodUsuario,
      CodPessoaProdutor: Integer): Integer; safecall;
    function Inserir(const CodAplicacaoBloqueio: WideString; CodUsuario,
      CodPessoaProdutor, CodMotivoBloqueio: Integer;
      const TxtObservacaoBloqueio, TxtObservacaoUsuario,
      TxtProcedimentoUsuario: WideString): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const CodAplicacaoBloqueio: WideString; const NomUsuario: WideString;
                       CodPessoa: Integer; const NomPessoa: WideString; 
                       const CodNaturezaPessoa: WideString; const NumCNPJCPF: WideString; 
                       const SglProdutor: WideString; CodMotivoBloqueio: Integer; 
                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                       const IndApenasBloqueados: WideString; CodOrdenacao: Integer): Integer; safecall;       
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Get_Bloqueio: IBloqueio; safecall;
    function Get_Inicializado: WordBool; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;


implementation

uses ComServ;

function TBloqueios.BOF: WordBool;
begin
  Result := FIntBloqueios.BOF;
end;

function TBloqueios.Buscar(const CodAplicacaoBloqueio: WideString;
  CodUsuario, CodPessoaProdutor: Integer;
  DtaInicioBloqueio: TDateTime): Integer;
begin
  Result := FIntBloqueios.Buscar(CodaplicacaoBloqueio, CodUsuario, CodPessoaProdutor, DtaInicioBloqueio);
end;

function TBloqueios.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntBloqueios.Deslocar(QtdRegistros);
end;

function TBloqueios.EOF: WordBool;
begin
  Result := FIntBloqueios.EOF;
end;

function TBloqueios.Excluir(const CodAplicacaoBloqueio: WideString;
  CodUsuario, CodPessoaProdutor: Integer): Integer;
begin
  Result := FIntBloqueios.Excluir(CodAplicacaoBloqueio, CodUsuario, CodPessoaProdutor);
end;

function TBloqueios.Inserir(const CodAplicacaoBloqueio: WideString;
  CodUsuario, CodPessoaProdutor, CodMotivoBloqueio: Integer;
  const TxtObservacaoBloqueio, TxtObservacaoUsuario,
  TxtProcedimentoUsuario: WideString): Integer;
begin
  Result := FIntBloqueios.Inserir(CodAplicacaoBloqueio, CodUsuario, CodPessoaProdutor,
                                  CodMotivoBloqueio, TxtObservacaoBloqueio,
                                  TxtObservacaoUsuario, TxtProcedimentoUsuario);
end;

function TBloqueios.NumeroRegistros: Integer;
begin
  Result := FIntBloqueios.NumeroRegistros;
end;

function TBloqueios.Pesquisar(const CodAplicacaoBloqueio: WideString; const NomUsuario: WideString;
                       CodPessoa: Integer; const NomPessoa: WideString; 
                       const CodNaturezaPessoa: WideString; const NumCNPJCPF: WideString; 
                       const SglProdutor: WideString; CodMotivoBloqueio: Integer; 
                       DtaInicio: TDateTime; DtaFim: TDateTime; 
                       const IndApenasBloqueados: WideString; CodOrdenacao: Integer): Integer;
begin
  Result := FIntBloqueios.Pesquisar( CodAplicacaoBloqueio, NomUsuario, CodPessoa,
                                     NomPessoa, CodNaturezaPessoa, NumCNPJCPF, SglProdutor,
                                     CodMotivoBloqueio, DtaInicio, DtaFim, IndApenasBloqueados, 
                                     CodOrdenacao);
end;

function TBloqueios.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntBloqueios.ValorCampo(NomeColuna);
end;

procedure TBloqueios.FecharPesquisa;
begin
  FIntBloqueios.FecharPesquisa;
end;

procedure TBloqueios.IrAoAnterior;
begin
  FIntBloqueios.IrAoAnterior;
end;

procedure TBloqueios.IrAoPrimeiro;
begin
  FIntBloqueios.IrAoPrimeiro;
end;

procedure TBloqueios.IrAoProximo;
begin
  FIntBloqueios.IrAoProximo;
end;

procedure TBloqueios.IrAoUltimo;
begin
  FIntBloqueios.IrAoUltimo;
end;

procedure TBloqueios.Posicionar(NumRegistro: Integer);
begin
  FIntBloqueios.Posicionar(NumRegistro);
end;

function TBloqueios.Get_Bloqueio: IBloqueio;
begin
  FBloqueio.DtaInicioBloqueio       := FIntBloqueios.IntBloqueio.DtaInicioBloqueio;
  FBloqueio.CodMotivoBloqueio       := FIntBloqueios.IntBloqueio.CodMotivoBloqueio;
  FBloqueio.CodAplicacaoBloqueio    := FIntBloqueios.IntBloqueio.CodAplicacaoBloqueio;
  FBloqueio.TxtMotivoBloqueio       := FIntBloqueios.IntBloqueio.TxtMotivoBloqueio;
  FBloqueio.TxtObservacaoBloqueio   := FIntBloqueios.IntBloqueio.TxtObservacaoBloqueio;
  FBloqueio.TxtObservacaoUsuario    := FIntBloqueios.IntBloqueio.TxtObservacaoUsuario;
  FBloqueio.TxtProcedimentoUsuario  := FIntBloqueios.IntBloqueio.TxtProcedimentoUsuario;
  FBloqueio.CodUsuario              := FIntBloqueios.IntBloqueio.CodUsuario;
  FBloqueio.CodPessoaProdutor       := FIntBloqueios.IntBloqueio.CodPessoaProdutor;
  FBloqueio.TxtMotivoUsuario        := FIntBloqueios.IntBloqueio.TxtMotivoUsuario;
  FBloqueio.CodUsuarioResponsavel   := FIntBloqueios.IntBloqueio.CodUsuarioResponsavel;
  FBloqueio.NomUsuarioResponsavel   := FIntBloqueios.IntBloqueio.NomUsuarioResponsavel;
  FBloqueio.NomUsuario              := FIntBloqueios.IntBloqueio.NomUsuario;
  FBloqueio.NomPessoa               := FIntBloqueios.IntBloqueio.NomPessoa;
  FBloqueio.DtaFimBloqueio          := FIntBloqueios.IntBloqueio.DtaFimBloqueio;

  Result := FBloqueio;
end;

function TBloqueios.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

procedure TBloqueios.AfterConstruction;
begin
  inherited;
  FBloqueio := TBloqueio.Create;
  FBloqueio.ObjAddRef;
  FInicializado := False;
end;

procedure TBloqueios.BeforeDestruction;
begin
  If FIntBloqueios <> nil Then Begin
    FIntBloqueios.Free;
  End;
  If FBloqueio <> nil Then Begin
    FBloqueio.ObjRelease;
    FBloqueio := nil;
  End;
  inherited;
end;

function TBloqueios.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntBloqueios := TIntBloqueios.Create;
  Result := FIntBloqueios.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBloqueios, Class_Bloqueios,
    ciMultiInstance, tmApartment);
end.
