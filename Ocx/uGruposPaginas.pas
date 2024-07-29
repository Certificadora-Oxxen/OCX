unit uGruposPaginas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uGrupoPaginas,
  uIntGruposPaginas;

type
  TGruposPaginas = class(TASPMTSObject, IGruposPaginas)
  private
    FIntGruposPaginas : TIntGruposPaginas;
    FInicializado : Boolean;
    FGrupoPaginas: TGrupoPaginas;
  protected
    function Alterar(CodGrupoPaginas: Integer;
      const DesGrupoPaginas: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodGrupoPaginas: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodGrupoPaginas: Integer): Integer; safecall;
    function Get_GrupoPaginas: IGrupoPaginas; safecall;
    function Get_Inicializado: WordBool; safecall;
    function Inserir(const DesGrupoPaginas: WideString;
      CodTipoPagina: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const DesGrupoPaginas: WideString;
      CodTipoPagina: Integer; IndPesquisarDesativos: WordBool): Integer;
      safecall;
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

uses ComServ;

procedure TGruposPaginas.AfterConstruction;
begin
  inherited;
  FGrupoPaginas := TGrupoPaginas.Create;
  FGrupoPaginas.ObjAddRef;
  FInicializado := False;
end;

procedure TGruposPaginas.BeforeDestruction;
begin
  If FIntGruposPaginas <> nil Then Begin
    FIntGruposPaginas.Free;
  End;
  If FGrupoPaginas <> nil Then Begin
    FGrupoPaginas.ObjRelease;
    FGrupoPaginas := nil;
  End;
  inherited;
end;

function TGruposPaginas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntGruposPaginas := TIntGruposPaginas.Create;
  Result := FIntGruposPaginas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TGruposPaginas.Alterar(CodGrupoPaginas: Integer;
  const DesGrupoPaginas: WideString): Integer;
begin
  Result := FIntGruposPaginas.Alterar(CodGrupoPaginas, DesGrupoPaginas);
end;

function TGruposPaginas.BOF: WordBool;
begin
  Result := FIntGruposPaginas.BOF;
end;

function TGruposPaginas.Buscar(CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntGruposPaginas.Buscar(CodGrupoPaginas);
end;

function TGruposPaginas.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntGruposPaginas.Deslocar(QtdRegistros);
end;

function TGruposPaginas.EOF: WordBool;
begin
  Result := FIntGruposPaginas.EOF;
end;

function TGruposPaginas.Excluir(CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntGruposPaginas.Excluir(CodGrupoPaginas);
end;

function TGruposPaginas.Get_GrupoPaginas: IGrupoPaginas;
begin
  FGrupoPaginas.Codigo          := FIntGruposPaginas.IntGrupoPaginas.Codigo;
  FGrupoPaginas.DesGrupoPaginas := FIntGruposPaginas.IntGrupoPaginas.DesGrupoPaginas;
  FGrupoPaginas.CodTipoPagina   := FIntGruposPaginas.IntGrupoPaginas.CodTipoPagina;
  FGrupoPaginas.DtaFimValidade  := FIntGruposPaginas.IntGrupoPaginas.DtaFimValidade;
  Result := FGrupoPaginas;
end;

function TGruposPaginas.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TGruposPaginas.Inserir(const DesGrupoPaginas: WideString;
  CodTipoPagina: Integer): Integer;
begin
  Result := FIntGruposPaginas.Inserir(DesGrupoPaginas, CodTipoPagina);
end;

function TGruposPaginas.NumeroRegistros: Integer;
begin
  Result := FIntGruposPaginas.NumeroRegistros;
end;

function TGruposPaginas.Pesquisar(const DesGrupoPaginas: WideString;
  CodTipoPagina: Integer; IndPesquisarDesativos: WordBool): Integer;
begin
  Result := FIntGruposPaginas.Pesquisar(DesGrupoPaginas, CodTipoPagina,IndPesquisarDesativos);
end;

function TGruposPaginas.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntGruposPaginas.ValorCampo(NomeColuna);
end;

procedure TGruposPaginas.FecharPesquisa;
begin
  FIntGruposPaginas.FecharPesquisa;
end;

procedure TGruposPaginas.IrAoAnterior;
begin
  FIntGruposPaginas.IrAoAnterior;
end;

procedure TGruposPaginas.IrAoPrimeiro;
begin
  FIntGruposPaginas.IrAoPrimeiro;
end;

procedure TGruposPaginas.IrAoProximo;
begin
  FIntGruposPaginas.IrAoProximo;
end;

procedure TGruposPaginas.IrAoUltimo;
begin
  FIntGruposPaginas.IrAoUltimo;
end;

procedure TGruposPaginas.Posicionar(NumRegistro: Integer);
begin
  FIntGruposPaginas.Posicionar(NumRegistro);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGruposPaginas, Class_GruposPaginas,
    ciMultiInstance, tmApartment);
end.
