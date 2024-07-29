unit uImportacoes;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntImportacoes, uIntMensagens,
  uConexao, uImportacao;

type
  TImportacoes = class(TASPMTSObject, IImportacoes)
  private
    FIntImportacoes: TIntImportacoes;
    FImportacao: TImportacao;
    FInicializado: Boolean;
  protected
    function ArmazenarArquivoUpload(CodTipoOrigemArqImport: Integer;
      const NomArquivoUpload: WideString): Integer; safecall;
    function Buscar(CodArquivoImportacao: Integer): Integer; safecall;
    function GerarArquivoParametro: Integer; safecall;
    function Pesquisar(const NomArqUpload: WideString; DtaImportacaoInicio,
      DtaImportacaoFim: TDateTime; const NomUsuarioUpload: WideString;
      CodTipoOrigemArqImport: Integer;
      const CodSituacaoArqImport: WideString; DtaUltimoProcessamentoInicio,
      DtaUltimoProcessamentoFim: TDateTime): Integer; safecall;
    function Get_Importacao: IImportacao; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function PesquisarOcorrenciasProcessamento(CodArquivoImportacao,
      CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer; safecall;
    function ProcessarArquivo(CodArquivoImportacao, LinhaInicial,
      TempoMaximo: Integer): Integer; safecall;
    function Excluir(CodArquivoImportacao: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function ArmazenarArquivoAutenticacao(
      const NomArquivoUpload: WideString): Integer; safecall;
    function PesquisarOcorrenciasAutenticacao(CodArquivoImportacao,
      CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer; safecall;
    function ProcessarAutenticacao(CodArquivoImportacao: Integer): Integer;
      safecall;
    function PesquisarAutenticacao(DtaImportacaoInicio, DtaImportacaoFim,
      DtaUltimoProcessamentoInicio, DtaUltimoProcessamentoFim: TDateTime;
      const LoginUsuario, IndErrosNoProcessamento,
      IndArquivoProcessado: WideString): Integer; safecall;
    function BuscarAutenticacao(CodArquivoImportacao: Integer): Integer;
      safecall;
    function ExcluirAutenticacao(CodArquivoImportacao: Integer): Integer;
      safecall;
    function PesquisarTipoArquivoImportacaoSisBov: Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TImportacoes.AfterConstruction;
begin
  inherited;
  FImportacao := TImportacao.Create;
  FImportacao.ObjAddRef;
  FInicializado := False;
end;

procedure TImportacoes.BeforeDestruction;
begin
  If FIntImportacoes <> nil Then Begin
    FIntImportacoes.Free;
  End;
  If FImportacao <> nil Then Begin
    FImportacao.ObjRelease;
    FImportacao := nil;
  End;
  inherited;
end;

function TImportacoes.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntImportacoes := TIntImportacoes.Create;
  Result := FIntImportacoes.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TImportacoes.ArmazenarArquivoUpload(
  CodTipoOrigemArqImport: Integer;
  const NomArquivoUpload: WideString): Integer;
begin
  Result := FIntImportacoes.ArmazenarArquivoUpload(CodTipoOrigemArqImport, NomArquivoUpload);
end;

function TImportacoes.Buscar(CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntImportacoes.Buscar(CodArquivoImportacao);
end;

function TImportacoes.GerarArquivoParametro: Integer;
begin
  Result := FIntImportacoes.GerarArquivoParametro;
end;

function TImportacoes.Pesquisar(const NomArqUpload: WideString;
  DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  const NomUsuarioUpload: WideString; CodTipoOrigemArqImport: Integer;
  const CodSituacaoArqImport: WideString; DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime): Integer;
begin
  Result := FIntImportacoes.Pesquisar(NomArqUpload, DtaImportacaoInicio, DtaImportacaoFim,
    NomUsuarioUpload, CodTipoOrigemArqImport, CodSituacaoArqImport, DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim);
end;

function TImportacoes.Get_Importacao: IImportacao;
begin
  FImportacao.CodPessoaProdutor := FIntImportacoes.IntImportacao.CodPessoaProdutor;
  FImportacao.DtaUltimoProcessamento := FIntImportacoes.IntImportacao.DtaUltimoProcessamento;
  FImportacao.CodArquivoImportacao := FIntImportacoes.IntImportacao.CodArquivoImportacao;
  FImportacao.NomArquivoImportacao := FIntImportacoes.IntImportacao.NomArquivoImportacao;
  FImportacao.NomUsuarioUpload := FIntImportacoes.IntImportacao.NomUsuarioUpload;
  FImportacao.NomArquivoUpload := FIntImportacoes.IntImportacao.NomArquivoUpload;
  FImportacao.DtaImportacao := FIntImportacoes.IntImportacao.DtaImportacao;
  FImportacao.NomPessoaProdutor := FIntImportacoes.IntImportacao.NomPessoaProdutor;
  FImportacao.NumCNPJCPFFormatadoProdutor := FIntImportacoes.IntImportacao.NumCNPJCPFFormatadoProdutor;
  FImportacao.QtdAnimaisAlteracaoProcessados := FIntImportacoes.IntImportacao.QtdAnimaisAlteracaoProcessados;
  FImportacao.QtdAnimaisAlteracaoTotal := FIntImportacoes.IntImportacao.QtdAnimaisAlteracaoTotal;
  FImportacao.QtdAnimaisEventosProcessados := FIntImportacoes.IntImportacao.QtdAnimaisEventosProcessados;
  FImportacao.QtdAnimaisEventosTotal := FIntImportacoes.IntImportacao.QtdAnimaisEventosTotal;
  FImportacao.QtdAnimaisInsercaoProcessados := FIntImportacoes.IntImportacao.QtdAnimaisInsercaoProcessados;
  FImportacao.QtdAnimaisInsercaoTotal := FIntImportacoes.IntImportacao.QtdAnimaisInsercaoTotal;
  FImportacao.QtdEventosProcessados := FIntImportacoes.IntImportacao.QtdEventosProcessados;
  FImportacao.QtdEventosTotal := FIntImportacoes.IntImportacao.QtdEventosTotal;
  FImportacao.QtdRMProcessados := FIntImportacoes.IntImportacao.QtdRMProcessados;
  FImportacao.QtdRMTotal := FIntImportacoes.IntImportacao.QtdRMTotal;
  FImportacao.QtdInventariosAnimaisTotal := FIntImportacoes.IntImportacao.QtdInventariosAnimaisTotal;
  FImportacao.QtdInventariosAnimaisProcessados := FIntImportacoes.IntImportacao.QtdInventariosAnimaisProcessados;
  FImportacao.QtdInventariosAnimaisErro := FIntImportacoes.IntImportacao.QtdInventariosAnimaisErro;
  FImportacao.QtdTourosRMProcessados := FIntImportacoes.IntImportacao.QtdTourosRMProcessados;
  FImportacao.QtdTourosRMTotal := FIntImportacoes.IntImportacao.QtdTourosRMTotal;
  FImportacao.QtdVezesProcessamento := FIntImportacoes.IntImportacao.QtdVezesProcessamento;
  FImportacao.SglProdutor := FIntImportacoes.IntImportacao.SglProdutor;
  FImportacao.QtdOcorrencias := FIntImportacoes.IntImportacao.QtdOcorrencias;
  FImportacao.QtdLinhas := FIntImportacoes.IntImportacao.QtdLinhas;
  FImportacao.QtdRMErro := FIntImportacoes.IntImportacao.QtdRMErro;
  FImportacao.QtdAnimaisInsercaoErro := FIntImportacoes.IntImportacao.QtdAnimaisInsercaoErro;
  FImportacao.QtdAnimaisAlteracaoErro := FIntImportacoes.IntImportacao.QtdAnimaisAlteracaoErro;
  FImportacao.QtdTourosRMErro := FIntImportacoes.IntImportacao.QtdTourosRMErro;
  FImportacao.QtdEventosErro := FIntImportacoes.IntImportacao.QtdEventosErro;
  FImportacao.QtdAnimaisEventosErro := FIntImportacoes.IntImportacao.QtdAnimaisEventosErro;
  FImportacao.QtdCRacialTotal := FIntImportacoes.IntImportacao.QtdCRacialTotal;
  FImportacao.QtdCRacialProcessados := FIntImportacoes.IntImportacao.QtdCRacialProcessados;
  FImportacao.QtdCRacialErro := FIntImportacoes.IntImportacao.QtdCRacialErro;
  FImportacao.CodTipoOrigemArqImport := FIntImportacoes.IntImportacao.CodTipoOrigemArqImport;
  FImportacao.SglTipoOrigemArqImport := FIntImportacoes.IntImportacao.SglTipoOrigemArqImport;
  FImportacao.DesTipoOrigemArqImport := FIntImportacoes.IntImportacao.DesTipoOrigemArqImport;
  FImportacao.CodSituacaoArqImport := FIntImportacoes.IntImportacao.CodSituacaoArqImport;
  FImportacao.DesSituacaoArqImport := FIntImportacoes.IntImportacao.DesSituacaoArqImport;
  FImportacao.CodUsuarioUpload := FIntImportacoes.IntImportacao.CodUsuarioUpload;
  FImportacao.CodUltimaTarefa := FIntImportacoes.IntImportacao.CodUltimaTarefa;
  FImportacao.CodSituacaoUltimaTarefa := FIntImportacoes.IntImportacao.CodSituacaoUltimaTarefa;
  FImportacao.DesSituacaoUltimaTarefa := FIntImportacoes.IntImportacao.DesSituacaoUltimaTarefa;
  FImportacao.DtaInicioPrevistoUltimaTarefa := FIntImportacoes.IntImportacao.DtaInicioPrevistoUltimaTarefa;
  FImportacao.DtaInicioRealUltimaTarefa := FIntImportacoes.IntImportacao.DtaInicioRealUltimaTarefa;
  FImportacao.DtaFimRealUltimaTarefa := FIntImportacoes.IntImportacao.DtaFimRealUltimaTarefa;
  Result := FImportacao;
end;

function TImportacoes.EOF: WordBool;
begin
  Result := FIntImportacoes.EOF;
end;

function TImportacoes.ValorCampo(const NomColuna: WideString): OleVariant;
begin
  Result := FIntImportacoes.ValorCampo(NomColuna);
end;

procedure TImportacoes.FecharPesquisa;
begin
  FIntImportacoes.FecharPesquisa;
end;

procedure TImportacoes.IrAoPrimeiro;
begin
  FIntImportacoes.IrAoPrimeiro;
end;

procedure TImportacoes.IrAoProximo;
begin
  FIntImportacoes.IrAoProximo;
end;

function TImportacoes.PesquisarOcorrenciasProcessamento(
  CodArquivoImportacao, CodTipoLinhaImportacao,
  CodTipoMensagem: Integer): Integer;
begin
  Result := FIntImportacoes.PesquisarOcorrenciasProcessamento(
    CodArquivoImportacao, CodTipoLinhaImportacao, CodTipoMensagem);
end;

function TImportacoes.ProcessarArquivo(CodArquivoImportacao, LinhaInicial,
  TempoMaximo: Integer): Integer;
begin
  Result := FIntImportacoes.ProcessarArquivo(CodArquivoImportacao,
    LinhaInicial, TempoMaximo);
end;

function TImportacoes.Excluir(CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntImportacoes.Excluir(CodArquivoImportacao);
end;

function TImportacoes.BOF: WordBool;
begin
  Result := FIntImportacoes.BOF;
end;

function TImportacoes.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntImportacoes.Deslocar(QtdRegistros);
end;

function TImportacoes.NumeroRegistros: Integer;
begin
  Result := FIntImportacoes.NumeroRegistros;
end;

procedure TImportacoes.IrAoAnterior;
begin
  FIntImportacoes.IrAoAnterior;
end;

procedure TImportacoes.IrAoUltimo;
begin
  FIntImportacoes.IrAoUltimo;
end;

procedure TImportacoes.Posicionar(NumRegistro: Integer);
begin
  FIntImportacoes.Posicionar(NumRegistro);
end;

function TImportacoes.ArmazenarArquivoAutenticacao(
  const NomArquivoUpload: WideString): Integer;
begin
  Result := FIntImportacoes.ArmazenarArquivoAutenticacao(NomArquivoUpload);
end;

function TImportacoes.PesquisarOcorrenciasAutenticacao(
  CodArquivoImportacao, CodTipoLinhaImportacao,
  CodTipoMensagem: Integer): Integer;
begin
  Result := FIntImportacoes.PesquisarOcorrenciasAutenticacao(
    CodArquivoImportacao, CodTipoLinhaImportacao, CodTipoMensagem);
end;

function TImportacoes.ProcessarAutenticacao(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntImportacoes.ProcessarAutenticacao(CodArquivoImportacao);
end;

function TImportacoes.PesquisarAutenticacao(DtaImportacaoInicio,
  DtaImportacaoFim, DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime; const LoginUsuario,
  IndErrosNoProcessamento, IndArquivoProcessado: WideString): Integer;
begin
  Result := FIntImportacoes.PesquisarAutenticacao(DtaImportacaoInicio,
    DtaImportacaoFim, DtaUltimoProcessamentoInicio, DtaUltimoProcessamentoFim,
    LoginUsuario, IndErrosNoProcessamento, IndArquivoProcessado);
end;

function TImportacoes.BuscarAutenticacao(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntImportacoes.BuscarAutenticacao(CodArquivoImportacao);
end;

function TImportacoes.ExcluirAutenticacao(
  CodArquivoImportacao: Integer): Integer;
begin
  Result := FIntImportacoes.ExcluirAutenticacao(CodArquivoImportacao);
end;

function TImportacoes.PesquisarTipoArquivoImportacaoSisBov: Integer;
begin
   Result := FIntImportacoes.PesquisarTipoArquivoImportacaoSisBov;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacoes, Class_Importacoes,
    ciMultiInstance, tmApartment);
end.
