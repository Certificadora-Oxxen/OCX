unit uPaginas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,  uConexao, uIntMensagens,
  uIntPaginas;

type
  TPaginas = class(TASPMTSObject, IPaginas)
  private
    FIntPaginas : TIntPaginas;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodGrupoPaginas, CodTipoPagina: Integer): Integer;
      safecall;
    function PesquisarDisponiveis(CodGrupoPaginas: Integer): Integer; safecall;
    function PesquisarDoGrupo(CodGrupoPaginas: Integer): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    function Alterar(CodPagina, CodGrupoPaginas: Integer): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPaginas.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TPaginas.BeforeDestruction;
begin
  If FIntPaginas <> nil Then Begin
    FIntPaginas.Free;
  End;
  inherited;
end;

function TPaginas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPaginas := TIntPaginas.Create;
  Result := FIntPaginas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPaginas.EOF: WordBool;
begin
  Result := FIntPaginas.EOF;
end;

function TPaginas.Pesquisar(CodGrupoPaginas,
  CodTipoPagina: Integer): Integer;
begin
  Result := FIntPaginas.Pesquisar(CodGrupoPaginas, CodTipoPagina);
end;

function TPaginas.PesquisarDisponiveis(CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntPaginas.PesquisarDisponiveis(CodGrupoPaginas);
end;

function TPaginas.PesquisarDoGrupo(CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntPaginas.PesquisarDoGrupo(CodGrupoPaginas);
end;

function TPaginas.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPaginas.ValorCampo(NomeColuna);
end;

function TPaginas.Alterar(CodPagina, CodGrupoPaginas: Integer): Integer;
begin
  Result := FIntPaginas.Alterar(CodPagina, CodGrupoPaginas);
end;

procedure TPaginas.FecharPesquisa;
begin
  FIntPaginas.FecharPesquisa;
end;

procedure TPaginas.IrAoProximo;
begin
  FIntPaginas.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPaginas, Class_Paginas,
    ciMultiInstance, tmApartment);
end.
