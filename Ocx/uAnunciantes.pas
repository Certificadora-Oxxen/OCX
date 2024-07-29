unit uAnunciantes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uAnunciante,
  uIntAnunciantes;

type
  TAnunciantes = class(TASPMTSObject, IAnunciantes)
  private
    FIntAnunciantes : TIntAnunciantes;
    FInicializado   : Boolean;
    FAnunciante     : TAnunciante;
  protected
    function Alterar(CodAnunciante: Integer;
      const TxtEmailAnunciante: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodAnunciante: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodAnunciante: Integer): Integer; safecall;
    function Get_Anunciante: IAnunciante; safecall;
    function Get_Inicializado: WordBool; safecall;
    function Inserir(const NomAnunciante,
      TxtEmailAnunciante: WideString): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(IndPesquisarDesativados: WordBool): Integer; safecall;
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

procedure TAnunciantes.AfterConstruction;
begin
  inherited;
  FAnunciante := TAnunciante.Create;
  FAnunciante.ObjAddRef;
  FInicializado := False;
end;

procedure TAnunciantes.BeforeDestruction;
begin
  If FIntAnunciantes <> nil Then Begin
    FIntAnunciantes.Free;
  End;
  If FAnunciante <> nil Then Begin
    FAnunciante.ObjRelease;
    FAnunciante := nil;
  End;
  inherited;
end;

function TAnunciantes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAnunciantes := TIntAnunciantes.Create;
  Result := FIntAnunciantes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAnunciantes.Alterar(CodAnunciante: Integer;
  const TxtEmailAnunciante: WideString): Integer;
begin
  Result := FIntAnunciantes.Alterar(CodAnunciante, TxtEmailAnunciante);
end;

function TAnunciantes.BOF: WordBool;
begin
  Result := FIntAnunciantes.BOF;
end;

function TAnunciantes.Buscar(CodAnunciante: Integer): Integer;
begin
  Result := FIntAnunciantes.Buscar(CodAnunciante);
end;

function TAnunciantes.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntAnunciantes.Deslocar(QtdRegistros);
end;

function TAnunciantes.EOF: WordBool;
begin
  Result := FIntAnunciantes.EOF;
end;

function TAnunciantes.Excluir(CodAnunciante: Integer): Integer;
begin
  Result := FIntAnunciantes.Excluir(CodAnunciante);
end;

function TAnunciantes.Get_Anunciante: IAnunciante;
begin
  FAnunciante.Codigo             := FIntAnunciantes.IntAnunciante.Codigo;
  FAnunciante.NomAnunciante      := FIntAnunciantes.IntAnunciante.NomAnunciante;
  FAnunciante.TxtEmailAnunciante := FIntAnunciantes.IntAnunciante.TxtEmailAnunciante;
  FAnunciante.DtaFimValidade     := FIntAnunciantes.IntAnunciante.DtaFimValidade;
  Result := FAnunciante;
end;

function TAnunciantes.Get_Inicializado: WordBool;
begin
  Result := FInicializado;
end;

function TAnunciantes.Inserir(const NomAnunciante,
  TxtEmailAnunciante: WideString): Integer;
begin
  Result := FIntAnunciantes.Inserir(NomAnunciante, TxtEmailAnunciante);
end;

function TAnunciantes.NumeroRegistros: Integer;
begin
  Result := FIntAnunciantes.NumeroRegistros;
end;

function TAnunciantes.Pesquisar(
  IndPesquisarDesativados: WordBool): Integer;
begin
  Result := FIntAnunciantes.Pesquisar(IndPesquisarDesativados); 
end;

function TAnunciantes.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntAnunciantes.ValorCampo(NomeColuna);
end;

procedure TAnunciantes.FecharPesquisa;
begin
  FIntAnunciantes.FecharPesquisa;
end;

procedure TAnunciantes.IrAoAnterior;
begin
  FIntAnunciantes.IrAoAnterior;
end;

procedure TAnunciantes.IrAoPrimeiro;
begin
  FIntAnunciantes.IrAoPrimeiro;
end;

procedure TAnunciantes.IrAoProximo;
begin
  FIntAnunciantes.IrAoProximo;
end;

procedure TAnunciantes.IrAoUltimo;
begin
  FIntAnunciantes.IrAoUltimo;
end;

procedure TAnunciantes.Posicionar(NumRegistro: Integer);
begin
  FIntAnunciantes.Posicionar(NumRegistro);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnunciantes, Class_Anunciantes,
    ciMultiInstance, tmApartment);
end.
