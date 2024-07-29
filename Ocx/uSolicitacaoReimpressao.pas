unit uSolicitacaoReimpressao;

interface

uses
  AspTlb, ComObj, ActiveX, Boitata_TLB, StdVcl, WsSISBOV1, uConexao, uIntMensagens,
  uIntSolicitacaoReimpressao;

type
  TSolicitacaoReimpressao = class(TASPMTSObject, ISolicitacaoReimpressao)
  private
    FIntSolicitacoesReimpressao: TIntSolicitacaoReimpressao;
    FInicializado: Boolean;
    FConexaoBD: TConexao;
    FMensagens: TIntMensagens;
  protected
    function ObterProximoNumero: Integer; safecall;
    function Inserir(CodPessoaProdutor: Integer; CodPropriedadeRural: Integer; CodFabricanteIdentificador: Integer;
                     const CodAnimais: WideString; const CodIdentificacoes: WideString): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;

    //property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador;
    //property NomeFabricanteIdentificador: String read FNomeFabricanteIdentificador;
  end;

implementation

uses ComServ;

{ TSolicitacoesReimpressao }

procedure TSolicitacaoReimpressao.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TSolicitacaoReimpressao.BeforeDestruction;
begin
  if FIntSolicitacoesReimpressao <> nil then begin
    FIntSolicitacoesReimpressao.Free;
  end;
  inherited;
end;

function TSolicitacaoReimpressao.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FConexaoBD := ConexaoBD;
  FMensagens := Mensagens;
  FIntSolicitacoesReimpressao := TIntSolicitacaoReimpressao.Create;
  Result := FIntSolicitacoesReimpressao.Inicializar(ConexaoBD, Mensagens);
  FInicializado := (Result = 0);
end;

function TSolicitacaoReimpressao.Inserir(
  CodPessoaProdutor: Integer; CodPropriedadeRural: Integer; CodFabricanteIdentificador: Integer;
  const CodAnimais: WideString; const CodIdentificacoes: WideString): Integer;
begin
  Result := FIntSolicitacoesReimpressao.Inserir(CodPessoaProdutor,
    CodPropriedadeRural, CodFabricanteIdentificador, CodAnimais, CodIdentificacoes);
end;

function TSolicitacaoReimpressao.ObterProximoNumero: Integer;
begin
  Result := FIntSolicitacoesReimpressao.ObterProximoNumero();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSolicitacaoReimpressao, CLASS_SolicitacaoReimpressao,
    ciMultiInstance, tmApartment);

end.
 