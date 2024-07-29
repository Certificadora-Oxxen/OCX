unit uLotes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntLotes, uLote, uConexao, uIntMensagens;

type
  TLotes = class(TASPMTSObject, ILotes)
  private
    FIntLotes : TIntLotes;
    FInicializado : Boolean;
    FLote: TLote;
  protected
    function Pesquisar(CodFazenda: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    procedure IrAoUltimo; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoAnterior; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function Inserir(CodFazenda: Integer; const SglLote,
      DesLote: WideString): Integer; safecall;
    function Alterar(CodFazenda, CodLote: Integer; const SglLote,
      DesLote: WideString): Integer; safecall;
    function Excluir(CodFazenda, CodLote: Integer): Integer; safecall;
    function Buscar(CodFazenda, CodLote: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    function Get_Lote: ILote; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TLotes.AfterConstruction;
begin
  inherited;
  FLote := TLote.Create;
  FLote.ObjAddRef;
  FInicializado := False;
end;

procedure TLotes.BeforeDestruction;
begin
  If FIntLotes <> nil Then Begin
    FIntLotes.Free;
  End;
  If FLote <> nil Then Begin
    FLote.ObjRelease;
    FLote := nil;
  End;
  inherited;
end;

function TLotes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntLotes := TIntLotes.Create;
  Result := FIntLotes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TLotes.Pesquisar(CodFazenda: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntLotes.Pesquisar(CodFazenda,CodOrdenacao);
end;

procedure TLotes.IrAoUltimo;
begin
  FIntLotes.IrAoUltimo;
end;

procedure TLotes.IrAoProximo;
begin
  FIntLotes.IrAoProximo;
end;

procedure TLotes.IrAoAnterior;
begin
  FIntLotes.IrAoAnterior;
end;

procedure TLotes.Posicionar(NumPosicao: Integer);
begin
  FIntLotes.Posicionar(NumPosicao);
end;

procedure TLotes.Deslocar(NumDeslocamento: Integer);
begin
  FIntLotes.Deslocar(NumDeslocamento);
end;

function TLotes.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntLotes.ValorCampo(NomCampo);
end;

procedure TLotes.FecharPesquisa;
begin
  FIntLotes.FecharPesquisa;
end;

function TLotes.Inserir(CodFazenda: Integer; const SglLote,
  DesLote: WideString): Integer;
begin
  result := FIntLotes.Inserir(CodFazenda,SglLote,DesLote);
end;

function TLotes.Alterar(CodFazenda, CodLote: Integer; const SglLote,
  DesLote: WideString): Integer;
begin
  result := FIntLotes.Alterar(CodFazenda, CodLote,SglLote,DesLote);
end;

function TLotes.Excluir(CodFazenda, CodLote: Integer): Integer;
begin
  result := FIntLotes.Excluir(CodFazenda, CodLote);
end;

function TLotes.Buscar(CodFazenda, CodLote: Integer): Integer;
begin
  result := FIntLotes.Buscar(CodFazenda, CodLote);
end;

function TLotes.BOF: WordBool;
begin
  result := FIntLotes.BOF;
end;

function TLotes.EOF: WordBool;
begin
  result := FIntLotes.EOF;
end;

function TLotes.NumeroRegistros: Integer;
begin
  result := FIntLotes.NumeroRegistros;
end;

procedure TLotes.IrAoPrimeiro;
begin
  FIntLotes.IrAoPrimeiro;
end;

function TLotes.Get_Lote: ILote;
begin
  FLote.CodPessoaProdutor   := FIntLotes.IntLote.CodPessoaProdutor;
  FLote.CodFazenda          := FIntLotes.IntLote.CodFazenda;
  FLote.CodLote             := FIntLotes.IntLote.CodLote;
  FLote.SglLote             := FIntLotes.IntLote.SglLote;
  FLote.DesLote             := FIntLotes.IntLote.DesLote;
  FLote.SglFazenda          := FIntLotes.IntLote.SglFazenda;
  FLote.NomFazenda          := FIntLotes.IntLote.NomFazenda;
  FLote.DtaCadastramento    := FIntLotes.IntLote.DtaCadastramento;
  Result := FLote;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLotes, Class_Lotes,
    ciMultiInstance, tmApartment);
end.
