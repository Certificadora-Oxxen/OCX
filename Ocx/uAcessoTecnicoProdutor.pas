unit uAcessoTecnicoProdutor;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntAcessoTecnicoProdutor;

type
  TAcessoTecnicoProdutor = class(TASPMTSObject, IAcessoTecnicoProdutor)
  private
    FIntAcessoTecnicoProdutor : TIntAcessoTecnicoProdutor;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Adicionar(CodPessoaProdutor, CodPessoaTecnico: Integer): Integer;
      safecall;
    function PesquisarProdutores(CodPessoaTecnico: Integer): Integer; safecall;
    function PesquisarTecnicos(CodPessoaProdutor: Integer;
      const ind_considerar_inativos: WideString): Integer; safecall;
    function Retirar(CodPessoaProdutor, CodPessoaTecnico: Integer): Integer;
      safecall;
    function NumeroRegistros: Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TAcessoTecnicoProdutor.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TAcessoTecnicoProdutor.BeforeDestruction;
begin
  If FIntAcessoTecnicoProdutor <> nil Then Begin
    FIntAcessoTecnicoProdutor.Free;
  End;
  inherited;
end;

function TAcessoTecnicoProdutor.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAcessoTecnicoProdutor := TIntAcessoTecnicoProdutor.Create;
  Result := FIntAcessoTecnicoProdutor.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAcessoTecnicoProdutor.EOF: WordBool;
begin
  Result := FIntAcessoTecnicoProdutor.EOF;
end;

function TAcessoTecnicoProdutor.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntAcessoTecnicoProdutor.ValorCampo(NomeColuna);
end;

procedure TAcessoTecnicoProdutor.FecharPesquisa;
begin
  FIntAcessoTecnicoProdutor.FecharPesquisa;
end;

procedure TAcessoTecnicoProdutor.IrAoProximo;
begin
  FIntAcessoTecnicoProdutor.IrAoProximo;
end;

function TAcessoTecnicoProdutor.Adicionar(CodPessoaProdutor,
  CodPessoaTecnico: Integer): Integer;
begin
  Result := FIntAcessoTecnicoProdutor.Adicionar(CodPessoaProdutor, CodPessoaTecnico);
end;

function TAcessoTecnicoProdutor.PesquisarProdutores(
  CodPessoaTecnico: Integer): Integer;
begin
  Result := FIntAcessoTecnicoProdutor.PesquisarProdutores(CodPessoaTecnico);
end;

function TAcessoTecnicoProdutor.PesquisarTecnicos(
  CodPessoaProdutor: Integer;
  const ind_considerar_inativos: WideString): Integer;
begin
  Result := FIntAcessoTecnicoProdutor.PesquisarTecnicos(
    CodPessoaProdutor,
    String(ind_considerar_inativos)
  );
end;

function TAcessoTecnicoProdutor.Retirar(CodPessoaProdutor,
  CodPessoaTecnico: Integer): Integer;
begin
  Result := FIntAcessoTecnicoProdutor.Retirar(CodPessoaProdutor, CodPessoaTecnico);
end;

function TAcessoTecnicoProdutor.NumeroRegistros: Integer;
begin
  Result := FIntAcessoTecnicoProdutor.NumeroRegistros
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAcessoTecnicoProdutor, Class_AcessoTecnicoProdutor,
    ciMultiInstance, tmApartment);
end.
