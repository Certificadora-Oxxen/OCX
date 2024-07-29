unit uInventariosAnimais;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntInventariosAnimais, uConexao, uIntMensagens, uAnimais;

type
  TInventariosAnimais = class(TASPMTSObject, IInventariosAnimais)
  private
    FIntInventariosAnimais : TIntInventariosAnimais;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Excluir(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisBov: WideString; CodAnimal: Integer): Integer; safecall;
    function Inserir(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisbov: WideString; CodAnimal: Integer): Integer; safecall;
    function Pesquisar(const NomProdutor, SglProdutor,
      NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
      DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime;
      const IndTransmissaoSisbov: WideString; Tipo: Integer): Integer;
      safecall;
    function Transmitir: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function InserirIntervalo(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisbovInicial, CodSisbovFinal: WideString): Integer;
      safecall;
    function PesquisarEfetivados(const SglProdutor, NomProdutor,
      NomPropriedadeRural: WideString; CodIDPropriedade: Integer;
      DtaEfetivacaoInicio, DtaEfetivacaoFinal: TDateTime;
      const IndTransmissaoSisbov: WideString): Integer; safecall;
    function EfetivarInventario(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer; safecall;
    function ExcluirIntervalo(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisbovInicial, CodSisbovFinal: WideString): Integer;
      safecall;
    function CancelarEfetivacao(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer; safecall;
    function GerarRelatorioInventario(const NomProdutor, SglProdutor,
      NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
      DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime;
      const IndTransmissaoSisbov: WideString; Tipo: Integer): WideString;
      safecall;
    function ExcluirAnimalErro(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TInventariosAnimais.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TInventariosAnimais.BeforeDestruction;
begin
  If FIntInventariosAnimais <> nil Then Begin
    FIntInventariosAnimais.Free;
  End;
  inherited;
end;

function TInventariosAnimais.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntInventariosAnimais := TIntInventariosAnimais.Create;
  Result := FIntInventariosAnimais.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TInventariosAnimais.EOF: WordBool;
begin
  Result := FIntInventariosAnimais.EOF;
end;

function TInventariosAnimais.Excluir(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisBov: WideString;
  CodAnimal: Integer): Integer;
begin
  Result := FIntInventariosAnimais.Excluir(CodPessoaProdutor, CodPropriedadeRural, CodSisbov, CodAnimal);
end;

function TInventariosAnimais.Inserir(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisbov: WideString;
  CodAnimal: Integer): Integer;
begin
  Result := FIntInventariosAnimais.Inserir(CodPessoaProdutor, CodPropriedadeRural, CodSisbov, CodAnimal);
end;

function TInventariosAnimais.Pesquisar(const NomProdutor, SglProdutor,
  NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime;
  const IndTransmissaoSisbov: WideString; Tipo: Integer): Integer;
begin
  Result := FIntInventariosAnimais.Pesquisar(NomProdutor, SglProdutor, NomPropriedadeRural,
    DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
    DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim, IndTransmissaoSisbov, Tipo);
end;

function TInventariosAnimais.Transmitir: Integer;
begin
  Result := FIntInventariosAnimais.Transmitir;
end;

function TInventariosAnimais.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntInventariosAnimais.ValorCampo(NomCampo);
end;

procedure TInventariosAnimais.IrAoPrimeiro;
begin
  FIntInventariosAnimais.IrAoPrimeiro;
end;

procedure TInventariosAnimais.IrAoProximo;
begin
  FIntInventariosAnimais.IrAoProximo;
end;

function TInventariosAnimais.BOF: WordBool;
begin
  Result := FIntInventariosAnimais.BOF;
end;

function TInventariosAnimais.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntInventariosAnimais.Deslocar(QtdRegistros);
end;

function TInventariosAnimais.NumeroRegistros: Integer;
begin
  Result := FIntInventariosAnimais.NumeroRegistros;
end;

procedure TInventariosAnimais.FecharPesquisa;
begin
  FIntInventariosAnimais.FecharPesquisa;
end;

procedure TInventariosAnimais.Posicionar(NumRegistro: Integer);
begin
  FIntInventariosAnimais.Posicionar(NumRegistro);
end;

function TInventariosAnimais.InserirIntervalo(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisbovInicial,
  CodSisbovFinal: WideString): Integer;
begin
  Result := FIntInventariosAnimais.InserirIntervalo(CodPessoaProdutor, CodPropriedadeRural, CodSisbovInicial, CodSisbovFinal);
end;

function TInventariosAnimais.PesquisarEfetivados(const SglProdutor, NomProdutor,
      NomPropriedadeRural: WideString; CodIDPropriedade: Integer;
      DtaEfetivacaoInicio, DtaEfetivacaoFinal: TDateTime;
      const IndTransmissaoSisbov: WideString): Integer;
begin
  Result := FIntInventariosAnimais.PesquisarEfetivados(SglProdutor, NomProdutor, NomPropriedadeRural,
  CodIDPropriedade, DtaEfetivacaoInicio, DtaEfetivacaoFinal, IndTransmissaoSisbov);
end;

function TInventariosAnimais.EfetivarInventario(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntInventariosAnimais.EfetivarInventario(CodPessoaProdutor, CodPropriedadeRural);
end;

function TInventariosAnimais.ExcluirIntervalo(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisbovInicial,
  CodSisbovFinal: WideString): Integer;
begin
  Result := FIntInventariosAnimais.ExcluirIntervalo(CodPessoaProdutor, CodPropriedadeRural, CodSisbovInicial, CodSisbovFinal);
end;

function TInventariosAnimais.CancelarEfetivacao(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntInventariosAnimais.CancelarEfetivacao(CodPessoaProdutor, CodPropriedadeRural);
end;

function TInventariosAnimais.GerarRelatorioInventario(const NomProdutor,
  SglProdutor, NomPropriedadeRural: WideString; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime;
  const IndTransmissaoSisbov: WideString; Tipo: Integer): WideString;
begin
  Result := FIntInventariosAnimais.GerarRelatorioInventario(NomProdutor, SglProdutor, NomPropriedadeRural,
    DtaLancamentoInventarioIni, DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim,
    IndTransmissaoSisbov, Tipo);
end;

function TInventariosAnimais.ExcluirAnimalErro(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntInventariosAnimais.ExcluirAnimalErro(CodPessoaProdutor,
                               CodPropriedadeRural);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TInventariosAnimais, Class_InventariosAnimais,
    ciMultiInstance, tmApartment);
end.
