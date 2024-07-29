unit uInterfaceSisbov;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntInterfaceSisbov, uArquivoSisbov;

type
  TInterfaceSisbov = class(TASPMTSObject, IInterfaceSisbov)
  private
    FIntInterfaceSisbov : TIntInterfaceSisbov;
    FInicializado : Boolean;
    FCodArquivoAnimais : Integer;
    FCodArquivoPropriedades : Integer;
    FCodArquivoMovimentacoes : Integer;
    FCodArquivoMortes : Integer;
    FCodArquivoCertificados : Integer;
    FArquivoSisbov : TArquivoSisbov;
    FCodArquivoProdutores: Integer;
    FCodArquivoSupervisores: Integer;

  protected
    function BOF: WordBool; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function NumeroRegistros: Integer; safecall;
    function GerarArquivos(CodArquivoSisbov, CodTipoArquivo: Integer): Integer;
      safecall;
    function PesquisarArquivos(DtaInicio, DtaFim: TDateTime;
      CodTipoArquivoSisbov: Integer; DtaInicioSisbov,
      DtaFimSisbov: TDateTime;
      const IndPossuiLogErro: WideString): Integer; safecall;
    function Buscar(CodArquivoSisbov: Integer): Integer; safecall;
    function Get_CodArquivoAnimais: Integer; safecall;
    function Get_CodArquivoCertificados: Integer; safecall;
    function Get_CodArquivoMortes: Integer; safecall;
    function Get_CodArquivoMovimentacoes: Integer; safecall;
    function Get_CodArquivoPropriedades: Integer; safecall;
    function Get_ArquivoSisbov: IArquivoSisbov; safecall;
    function PesquisarLogErro(CodArquivoSisbov: Integer): Integer; safecall;
    function AtualizarDataSisbov(CodArquivoSisbov: Integer;
      DtaInsercaoSisbov: TDateTime): Integer; safecall;
    function Get_CodArquivoProdutores: Integer; safecall;
    function Get_CodArquivoSupervisores: Integer; safecall;
    function CadastrarEmail(const NovoEmail: WideString): WideString; safecall;
    function ConsultarSolicitacaoNumeracao(
      const NumeroSolicitacao: WideString): WideString; safecall;
    function ConsultarEmail: WideString; safecall;
    function CancelarSolicitacaoNumeracao(NumeroSolicitacao: Integer;
      const NumeroSisbov: WideString; CodPropriedad: Integer;
      const CnpjProduto, CpfProduto: WideString;
      CodMotivoCancelamento: Integer): Integer; safecall;
    procedure RecuperarTabela(CodigoTabela: Integer); safecall;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;

    property CodArquivoAnimais: Integer read FCodArquivoAnimais;
    property CodArquivoPropriedades: Integer read FCodArquivoPropriedades;
    property CodArquivoMovimentacoes: Integer read FCodArquivoMovimentacoes;
    property CodArquivoMortes: Integer read FCodArquivoMortes;
    property CodArquivoCertificados: Integer read FCodArquivoCertificados;
    property ArquivoSisbov: TArquivoSisbov read FArquivoSisbov;
    property CodArquivoProdutores: Integer read FCodArquivoProdutores;
    property CodArquivoSupervisores: Integer read FCodArquivoSupervisores;
  end;

implementation

uses ComServ;

procedure TInterfaceSisbov.AfterConstruction;
begin
  inherited;
  FArquivoSisbov := TArquivoSisbov.Create;
  FArquivoSisbov.ObjAddRef;
  FInicializado := False;
end;

procedure TInterfaceSisbov.BeforeDestruction;
begin
  If FIntInterfaceSisbov <> nil Then Begin
    FIntInterfaceSisbov.Free;
  End;
  If FArquivoSisbov <> nil Then Begin
    FArquivoSisbov.ObjRelease;
    FArquivoSisbov := nil;
  End;
  inherited;
end;

function TInterfaceSisbov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntInterfaceSisbov := TIntInterfaceSisbov.Create;
  Result := FIntInterfaceSisbov.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TInterfaceSisbov.BOF: WordBool;
begin
  Result := FIntInterfaceSisbov.BOF;
end;

function TInterfaceSisbov.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntInterfaceSisbov.Deslocar(NumDeslocamento);
end;

function TInterfaceSisbov.EOF: WordBool;
begin
  Result := FIntInterfaceSisbov.EOF;
end;

function TInterfaceSisbov.NumeroRegistros: Integer;
begin
  Result := FIntInterfaceSisbov.NumeroRegistros;
end;

function TInterfaceSisbov.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  Result := FIntInterfaceSisbov.ValorCampo(NomColuna);
end;

procedure TInterfaceSisbov.FecharPesquisa;
begin
  FIntInterfaceSisbov.FecharPesquisa;
end;

procedure TInterfaceSisbov.IrAoAnterior;
begin
  FIntInterfaceSisbov.IrAoAnterior;
end;

procedure TInterfaceSisbov.IrAoPrimeiro;
begin
  FIntInterfaceSisbov.IrAoPrimeiro;
end;

procedure TInterfaceSisbov.IrAoProximo;
begin
  FIntInterfaceSisbov.IrAoProximo;
end;

procedure TInterfaceSisbov.IrAoUltimo;
begin
  FIntInterfaceSisbov.IrAoUltimo;
end;

procedure TInterfaceSisbov.Posicionar(NumPosicao: Integer);
begin
  FIntInterfaceSisbov.Posicionar(NumPosicao);
end;

function TInterfaceSisbov.GerarArquivos(CodArquivoSisbov, CodTipoArquivo: Integer): Integer;
begin
  Result := FIntInterfaceSisbov.GerarArquivos(CodArquivoSisbov, CodTipoArquivo);
end;

function TInterfaceSisbov.PesquisarArquivos(DtaInicio, DtaFim: TDateTime;
  CodTipoArquivoSisbov: Integer; DtaInicioSisbov, DtaFimSisbov: TDateTime;
  const IndPossuiLogErro: WideString): Integer;
begin
  Result := FIntInterfaceSisbov.PesquisarArquivos(DtaInicio, DtaFim,
    CodTipoArquivoSisbov, DtaInicioSisbov, DtaFimSisbov, IndPossuiLogErro);
end;

function TInterfaceSisbov.Buscar(CodArquivoSisbov: Integer): Integer;
begin
  Result := FIntInterfaceSisbov.Buscar(CodArquivoSisbov);
end;

function TInterfaceSisbov.Get_CodArquivoAnimais: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoAnimais;
end;

function TInterfaceSisbov.Get_CodArquivoCertificados: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoCertificados;
end;

function TInterfaceSisbov.Get_CodArquivoMortes: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoMortes;
end;

function TInterfaceSisbov.Get_CodArquivoMovimentacoes: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoMovimentacoes;
end;

function TInterfaceSisbov.Get_CodArquivoPropriedades: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoPropriedades;
end;

function TInterfaceSisbov.Get_CodArquivoProdutores: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoProdutores;
end;

function TInterfaceSisbov.Get_ArquivoSisbov: IArquivoSisbov;
begin
  FArquivoSisbov.CodArquivoSisbov := FIntInterfaceSisbov.IntArquivoSisbov.CodArquivoSisbov;
  FArquivoSisbov.NomArquivoSisbov := FIntInterfaceSisbov.IntArquivoSisbov.NomArquivoSisbov;
  FArquivoSisbov.DtaCriacaoArquivo := FIntInterfaceSisbov.IntArquivoSisbov.DtaCriacaoArquivo;
  FArquivoSisbov.QtdBytesArquivo := FIntInterfaceSisbov.IntArquivoSisbov.QtdBytesArquivo;
  FArquivoSisbov.CodTipoArquivoSisbov := FIntInterfaceSisbov.IntArquivoSisbov.CodTipoArquivoSisbov;
  FArquivoSisbov.DesTipoArquivoSisbov := FIntInterfaceSisbov.IntArquivoSisbov.DesTipoArquivoSisbov;
  FArquivoSisbov.CodUsuario := FIntInterfaceSisbov.IntArquivoSisbov.CodUsuario;
  FArquivoSisbov.NomUsuario := FIntInterfaceSisbov.IntArquivoSisbov.NomUsuario;
  FArquivoSisbov.IndPossuiLogErro := FIntInterfaceSisbov.IntArquivoSisbov.IndPossuiLogErro;
  FArquivoSisbov.DtaInsercaoSisbov := FIntInterfaceSisbov.IntArquivoSisbov.DtaInsercaoSisbov;
  Result := FArquivoSisbov;
end;

function TInterfaceSisbov.PesquisarLogErro(
  CodArquivoSisbov: Integer): Integer;
begin
  Result := FIntInterfaceSisbov.PesquisarLogErro(CodArquivoSisbov);
end;

function TInterfaceSisbov.AtualizarDataSisbov(CodArquivoSisbov: Integer;
  DtaInsercaoSisbov: TDateTime): Integer;
begin
  Result := FIntInterfaceSisbov.AtualizarDataSisbov(CodArquivoSisbov,
    DtaInsercaoSisbov);
end;

function TInterfaceSisbov.Get_CodArquivoSupervisores: Integer;
begin
  Result := FIntInterfaceSisbov.CodArquivoSupervisores;
end;

function TInterfaceSisbov.CadastrarEmail(
  const NovoEmail: WideString): WideString;
begin
  Result := FIntInterfaceSisbov.CadastrarEmail(NovoEmail);
end;

function TInterfaceSisbov.ConsultarSolicitacaoNumeracao(
  const NumeroSolicitacao: WideString): WideString;
begin
  Result := FIntInterfaceSisbov.ConsultarSolicitacaoNumeracao(NumeroSolicitacao);
end;

function TInterfaceSisbov.ConsultarEmail: WideString;
begin
  Result := FIntInterfaceSisbov.ConsultarEmail;
end;

function TInterfaceSisbov.CancelarSolicitacaoNumeracao(
  NumeroSolicitacao: Integer; const NumeroSisbov: WideString;
  CodPropriedad: Integer; const CnpjProduto, CpfProduto: WideString;
  CodMotivoCancelamento: Integer): Integer;
begin
  Result := FIntInterfaceSisbov.CancelarSolicitacaoNumeracao(NumeroSolicitacao,
    NumeroSisbov, CodPropriedad, CnpjProduto, CpfProduto, CodMotivoCancelamento);
end;

procedure TInterfaceSisbov.RecuperarTabela(CodigoTabela: Integer);
begin
  FIntInterfaceSisbov.RecuperarTabela(CodigoTabela);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TInterfaceSisbov, Class_InterfaceSisbov,
    ciMultiInstance, tmApartment);
end.
