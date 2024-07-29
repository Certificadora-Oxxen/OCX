unit uAcessoAssociacaoProdutor;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntAcessoAssociacaoProdutor;

type
  TAcessoAssociacaoProdutor = class(TASPMTSObject, IAcessoAssociacaoProdutor)
  private
    FIntAcessoAssociacaoProdutor : TIntAcessoAssociacaoProdutor;
    FInicializado : Boolean;
  protected
    function Adicionar(CodPessoaProdutor, CodPessoaAssociacao: Integer): Integer;
      safecall;
    function EOF: WordBool; safecall;
    function PesquisarAssociacoes(CodPessoaProdutor: Integer): Integer;
      safecall;
    function PesquisarProdutores(CodPessoaAssociacao: Integer): Integer; safecall;
    function Retirar(CodPessoaProdutor, CodPessoaAssociacao: Integer): Integer;
      safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function NumeroRegistros: Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntClassesBasicas;

procedure TAcessoAssociacaoProdutor.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TAcessoAssociacaoProdutor.BeforeDestruction;
begin
  If FIntAcessoAssociacaoProdutor <> nil Then Begin
    FIntAcessoAssociacaoProdutor.Free;
  End;
  inherited;
end;

function TAcessoAssociacaoProdutor.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAcessoAssociacaoProdutor := TIntAcessoAssociacaoProdutor.Create;
  Result := FIntAcessoAssociacaoProdutor.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAcessoAssociacaoProdutor.Adicionar(CodPessoaProdutor,
  CodPessoaAssociacao: Integer): Integer;
begin
  Result := FIntAcessoAssociacaoProdutor.Adicionar(CodPessoaProdutor, CodPessoaAssociacao);
end;

function TAcessoAssociacaoProdutor.EOF: WordBool;
begin
  Result := FIntAcessoAssociacaoProdutor.EOF;
end;

function TAcessoAssociacaoProdutor.PesquisarAssociacoes(
  CodPessoaProdutor: Integer): Integer;
begin
  Result := FIntAcessoAssociacaoProdutor.PesquisarAssociacoes(CodPessoaProdutor);
end;

function TAcessoAssociacaoProdutor.PesquisarProdutores(
  CodPessoaAssociacao: Integer): Integer;
begin
  Result := FIntAcessoAssociacaoProdutor.PesquisarProdutores(CodPessoaAssociacao);
end;

function TAcessoAssociacaoProdutor.Retirar(CodPessoaProdutor,
  CodPessoaAssociacao: Integer): Integer;
begin
  Result := FIntAcessoAssociacaoProdutor.Retirar(CodPessoaProdutor, CodPessoaAssociacao);
end;

function TAcessoAssociacaoProdutor.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntAcessoAssociacaoProdutor.ValorCampo(NomeColuna);
end;

procedure TAcessoAssociacaoProdutor.FecharPesquisa;
begin
  FIntAcessoAssociacaoProdutor.FecharPesquisa;
end;

procedure TAcessoAssociacaoProdutor.IrAoProximo;
begin
  FIntAcessoAssociacaoProdutor.IrAoProximo;
end;

function TAcessoAssociacaoProdutor.NumeroRegistros: Integer;
begin
  Result := FIntAcessoAssociacaoProdutor.NumeroRegistros
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAcessoAssociacaoProdutor, Class_AcessoAssociacaoProdutor,
    ciMultiInstance, tmApartment);
end.
