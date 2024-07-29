unit uInventariosCodigosSisbov;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntInventariosCodigosSisbov, uConexao, uIntMensagens;

type
  TInventariosCodigosSisbov = class(TASPMTSObject, IInventariosCodigosSisbov)
  private
    FIntInventariosCodigosSisbov : TIntInventariosCodigosSisbov;
    FInicializado : Boolean;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo: Integer): Integer; safecall;
    function Inserir(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo, CodTipoIdentificacaoSisbov: Integer): Integer;
      safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const NomProdutor, SglProdutor,
      NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
      DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime;
      const IndTransmissaoSisbov: WideString): Integer; safecall;
    function Transmitir: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function GerarRelatorio(const NomProdutor, SglProdutor,
      NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
      DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime;
      const IndTransmissaoSisbov: WideString; QtdQuebraRelatorio,
      Tipo: Integer): WideString; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TInventariosCodigosSisbov.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TInventariosCodigosSisbov.BeforeDestruction;
begin
  If FIntInventariosCodigosSisbov <> nil Then Begin
    FIntInventariosCodigosSisbov.Free;
  End;
  inherited;
end;

function TInventariosCodigosSisbov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntInventariosCodigosSisbov := TIntInventariosCodigosSisbov.Create;
  Result := FIntInventariosCodigosSisbov.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TInventariosCodigosSisbov.BOF: WordBool;
begin
  Result := FIntInventariosCodigosSisbov.BOF;
end;

function TInventariosCodigosSisbov.Deslocar(
  QtdRegistros: Integer): Integer;
begin
  Result := FIntInventariosCodigosSisbov.Deslocar(QtdRegistros);
end;

function TInventariosCodigosSisbov.EOF: WordBool;
begin
  Result := FIntInventariosCodigosSisbov.EOF;
end;

function TInventariosCodigosSisbov.Excluir(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo: Integer): Integer;
begin
  Result := FIntInventariosCodigosSisbov.Excluir(CodPessoaProdutor, CodPropriedadeRural,
    NumSolicitacaoCodigo);
end;

function TInventariosCodigosSisbov.Inserir(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo,
  CodTipoIdentificacaoSisbov: Integer): Integer;
begin
  Result := FIntInventariosCodigosSisbov.Inserir(CodPessoaProdutor, CodPropriedadeRural,
    NumSolicitacaoCodigo, CodTipoIdentificacaoSisbov);
end;

function TInventariosCodigosSisbov.NumeroRegistros: Integer;
begin
  Result := FIntInventariosCodigosSisbov.NumeroRegistros;
end;

function TInventariosCodigosSisbov.Pesquisar(const NomProdutor,
  SglProdutor, NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime;
  const IndTransmissaoSisbov: WideString): Integer;
begin
  Result := FIntInventariosCodigosSisbov.Pesquisar(NomProdutor, SglProdutor,
    NomPropriedadeRural, DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
    DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim, IndTransmissaoSisbov);
end;

function TInventariosCodigosSisbov.Transmitir: Integer;
begin
  Result := FIntInventariosCodigosSisbov.Transmitir;
end;

function TInventariosCodigosSisbov.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntInventariosCodigosSisbov.ValorCampo(NomCampo);
end;

procedure TInventariosCodigosSisbov.FecharPesquisa;
begin
  FIntInventariosCodigosSisbov.FecharPesquisa;
end;

procedure TInventariosCodigosSisbov.IrAoPrimeiro;
begin
  FIntInventariosCodigosSisbov.IrAoPrimeiro;
end;

procedure TInventariosCodigosSisbov.IrAoProximo;
begin
  FIntInventariosCodigosSisbov.IrAoProximo;
end;

procedure TInventariosCodigosSisbov.Posicionar(NumRegistro: Integer);
begin
  FIntInventariosCodigosSisbov.Posicionar(NumRegistro);
end;

function TInventariosCodigosSisbov.GerarRelatorio(const NomProdutor,
  SglProdutor, NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime;
  const IndTransmissaoSisbov: WideString; QtdQuebraRelatorio,
  Tipo: Integer): WideString;
begin
  Result := FIntInventariosCodigosSisbov.GerarRelatorio(NomProdutor, SglProdutor,
    NomPropriedadeRural, DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
    DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim, IndTransmissaoSisbov,
    QtdQuebraRelatorio, Tipo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TInventariosCodigosSisbov, Class_InventariosCodigosSisbov,
    ciMultiInstance, tmApartment);
end.
