unit uSolicitacoesReimpressao;

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl, WsSISBOV1, uConexao, uIntMensagens,
  uIntSolicitacoesReimpressao;

type
  TSolicitacoesReimpressao = class(TAutoObject, ISolicitacoesReimpressao)
  private
    FIntSolicitacoesReimpressao: TIntSolicitacoesReimpressao;
    FInicializado: Boolean;
    FConexaoBD: TConexao;
    FMensagens: TIntMensagens;
  protected
    function ObterProximoNumero: Integer; safecall;
    function Inserir(CodSolicitacaoReimpressao: Integer; CodPessoaProdutor: Integer;
                     CodPropriedadeRural: Integer; CodFabricanteIdentificador: Integer;
                     const CodAnimais: WideString; const CodIdentificacoes: WideString): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

{ TSolicitacoesReimpressao }

procedure TSolicitacoesReimpressao.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSolicitacoesReimpressao.BeforeDestruction;
begin
  if FIntSolicitacoesReimpressao <> nil then begin
    FIntSolicitacoesReimpressao.Free;
  end;
  inherited;
end;

function TSolicitacoesReimpressao.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FConexaoBD := ConexaoBD;
  FMensagens := Mensagens;
  FIntSolicitacoesReimpressao := TIntSolicitacoesReimpressao.Create;
  Result := FIntSolicitacoesReimpressao.Inicializar(ConexaoBD, Mensagens);
  FInicializado := (Result = 0);
end;

function TSolicitacoesReimpressao.Inserir(
  CodSolicitacaoReimpressao: Integer; CodPessoaProdutor: Integer; CodPropriedadeRural: Integer; CodFabricanteIdentificador: Integer;
  const CodAnimais: WideString; const CodIdentificacoes: WideString): Integer;
begin
  Result := FIntSolicitacoesReimpressao.Inserir(FConexaoBD, FMensagens,
    CodSolicitacaoReimpressao, CodPessoaProdutor, CodPropriedadeRural, CodFabricanteIdentificador,
    CodAnimais, CodIdentificacoes);
end;

function TSolicitacoesReimpressao.ObterProximoNumero: Integer;
begin
  Result := FIntSolicitacoesReimpressao.ObterProximoNumero(FConexaoBD, FMensagens);
end;

end.
 