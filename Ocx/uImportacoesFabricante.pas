unit uImportacoesFabricante;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntImportacoesFabricante,
  uImportacaoFabricante, uConexao, uIntMensagens;


type
  TImportacoesFabricante = class(TASPMTSObject, IImportacoesFabricante)
  protected
    FInicializado: Boolean;

    FIntImportacoesFabricante: TIntImportacoesFabricante;
    FImportacaoFabricante: TImportacaoFabricante;

    function ArmazenarArquivoUpload(CodTipoOrigemArqImport: Integer;
      const NomArqUpload: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodArqImportFabricante: Integer): Integer; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodArqImportFabricante: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const NomArqUpload: WideString; DtaImportacaoInicio,
      DtaImportacaoFim: TDateTime; const NomUsuarioUpload: WideString;
      CodTipoOrigemArqImport: Integer;
      const CodSituacaoArqImport: WideString; DtaProcessamentoInicio,
      DtaProcessamentoFim: TDateTime;
      const NomUsuarioProc: WideString): Integer; safecall;
    function PesquisarOcorrencias(CodArqImportFabricante,
      CodTipoMensagem: Integer): Integer; safecall;
    function ProcessarArquivo(CodArqImportDadoGeral: Integer): Integer;
      safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_ImportacaoFabricante: IImportacaoFabricante; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntClassesBasicas, uIntImportacaoFabricante;

function TImportacoesFabricante.ArmazenarArquivoUpload(
  CodTipoOrigemArqImport: Integer;
  const NomArqUpload: WideString): Integer;
begin
  Result := FIntImportacoesFabricante.ArmazenarArquivoUpload(
    CodTipoOrigemArqImport, NomArqUpload);
end;

function TImportacoesFabricante.BOF: WordBool;
begin
  Result := FIntImportacoesFabricante.BOF;
end;

function TImportacoesFabricante.Buscar(
  CodArqImportFabricante: Integer): Integer;
begin
  Result := FIntImportacoesFabricante.Buscar(CodArqImportFabricante);
end;

function TImportacoesFabricante.Deslocar(
  NumDeslocamento: Integer): Integer;
begin
  Result := FIntImportacoesFabricante.Deslocar(NumDeslocamento);
end;

function TImportacoesFabricante.EOF: WordBool;
begin
  Result := FIntImportacoesFabricante.EOF;
end;

function TImportacoesFabricante.Excluir(
  CodArqImportFabricante: Integer): Integer;
begin
  Result := FIntImportacoesFabricante.Excluir(CodArqImportFabricante);
end;

function TImportacoesFabricante.NumeroRegistros: Integer;
begin
  Result := FIntImportacoesFabricante.NumeroRegistros;
end;

function TImportacoesFabricante.Pesquisar(const NomArqUpload: WideString;
  DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  const NomUsuarioUpload: WideString; CodTipoOrigemArqImport: Integer;
  const CodSituacaoArqImport: WideString; DtaProcessamentoInicio,
  DtaProcessamentoFim: TDateTime;
  const NomUsuarioProc: WideString): Integer;
begin
  Result := FIntImportacoesFabricante.Pesquisar(NomArqUpload,
    DtaImportacaoInicio, DtaImportacaoFim, NomUsuarioUpload,
    CodTipoOrigemArqImport, CodSituacaoArqImport, DtaProcessamentoInicio,
    DtaProcessamentoFim, NomUsuarioProc);
end;

function TImportacoesFabricante.PesquisarOcorrencias(
  CodArqImportFabricante, CodTipoMensagem: Integer): Integer;
begin
  Result := FIntImportacoesFabricante.PesquisarOcorrencias(
    CodArqImportFabricante, CodTipoMensagem);
end;

function TImportacoesFabricante.ProcessarArquivo(
  CodArqImportDadoGeral: Integer): Integer;
begin
  Result := FIntImportacoesFabricante.ProcessarArquivo(CodArqImportDadoGeral);
end;

function TImportacoesFabricante.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntImportacoesFabricante.ValorCampo(NomCampo);
end;

procedure TImportacoesFabricante.IrAoAnterior;
begin
  FIntImportacoesFabricante.IrAoAnterior;
end;

procedure TImportacoesFabricante.IrAoPrimeiro;
begin
  FIntImportacoesFabricante.IrAoPrimeiro;
end;

procedure TImportacoesFabricante.IrAoProximo;
begin
  FIntImportacoesFabricante.IrAoProximo;
end;

procedure TImportacoesFabricante.IrAoUltimo;
begin
  FIntImportacoesFabricante.IrAoUltimo;
end;

procedure TImportacoesFabricante.Posicionar(NumPosicao: Integer);
begin
  FIntImportacoesFabricante.Posicionar(NumPosicao);
end;

procedure TImportacoesFabricante.AfterConstruction;
begin
  inherited;
  FImportacaoFabricante := TImportacaoFabricante.Create;
  FImportacaoFabricante.ObjAddRef;
  FInicializado := False;
end;

procedure TImportacoesFabricante.BeforeDestruction;
begin
  if FIntImportacoesFabricante <> nil then
  begin
    FIntImportacoesFabricante.Free;
  end;

  if FImportacaoFabricante <> nil then
  begin
    FImportacaoFabricante.ObjRelease;
    FImportacaoFabricante := nil;
  end;
  
  inherited;
end;

function TImportacoesFabricante.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  if FIntImportacoesFabricante = nil then
  begin
    FIntImportacoesFabricante := TIntImportacoesFabricante.Create;
  end;

  Result := FIntImportacoesFabricante.Inicializar(ConexaoBD,
                                                  Mensagens);
  if Result = 0 then
  begin
    FInicializado := True;
  end;
end;

function TImportacoesFabricante.Get_ImportacaoFabricante: IImportacaoFabricante;
begin
  FImportacaoFabricante.CodArqImportFabricante             := FIntImportacoesFabricante.IntImportacaoFabricante.CodArqImportFabricante;
  FImportacaoFabricante.CodFabricanteIdentificador         := FIntImportacoesFabricante.IntImportacaoFabricante.CodFabricanteIdentificador;
  FImportacaoFabricante.CodSituacaoArqImport               := FIntImportacoesFabricante.IntImportacaoFabricante.CodSituacaoArqImport;
  FImportacaoFabricante.CodSituacaoTarefa                  := FIntImportacoesFabricante.IntImportacaoFabricante.CodSituacaoTarefa;
  FImportacaoFabricante.CodTarefa                          := FIntImportacoesFabricante.IntImportacaoFabricante.CodTarefa;
  FImportacaoFabricante.CodTipoArqImportFabricante         := FIntImportacoesFabricante.IntImportacaoFabricante.CodTipoArqImportFabricante;
  FImportacaoFabricante.CodTipoOrigemArqImport             := FIntImportacoesFabricante.IntImportacaoFabricante.CodTipoOrigemArqImport;
  FImportacaoFabricante.CodUsuarioProc                     := FIntImportacoesFabricante.IntImportacaoFabricante.CodUsuarioProc;
  FImportacaoFabricante.CodUsuarioUpload                   := FIntImportacoesFabricante.IntImportacaoFabricante.CodUsuarioUpload;
  FImportacaoFabricante.DesSituacaoArqImport               := FIntImportacoesFabricante.IntImportacaoFabricante.CodSituacaoArqImport;
  FImportacaoFabricante.DesSituacaoTarefa                  := FIntImportacoesFabricante.IntImportacaoFabricante.DesSituacaoTarefa;
  FImportacaoFabricante.DesTipoArqImportFabricante         := FIntImportacoesFabricante.IntImportacaoFabricante.DesTipoArqImportFabricante;
  FImportacaoFabricante.DesTipoOrigemArqImport             := FIntImportacoesFabricante.IntImportacaoFabricante.DesTipoOrigemArqImport;
  FImportacaoFabricante.DtaFimRealTarefa                   := FIntImportacoesFabricante.IntImportacaoFabricante.DtaFimRealTarefa;
  FImportacaoFabricante.DtaImportacao                      := FIntImportacoesFabricante.IntImportacaoFabricante.DtaImportacao;
  FImportacaoFabricante.DtaInicioPrevistoTarefa            := FIntImportacoesFabricante.IntImportacaoFabricante.DtaInicioPrevistoTarefa;
  FImportacaoFabricante.DtaInicioRealTarefa                := FIntImportacoesFabricante.IntImportacaoFabricante.DtaInicioRealTarefa;
  FImportacaoFabricante.DtaProcessamento                   := FIntImportacoesFabricante.IntImportacaoFabricante.DtaProcessamento;
  FImportacaoFabricante.NomArqImportFabricante             := FIntImportacoesFabricante.IntImportacaoFabricante.NomArqImportFabricante;
  FImportacaoFabricante.NomArqUpload                       := FIntImportacoesFabricante.IntImportacaoFabricante.NomArqUpload;
  FImportacaoFabricante.NomFabricanteIdentificador         := FIntImportacoesFabricante.IntImportacaoFabricante.NomFabricanteIdentificador;
  FImportacaoFabricante.NomReduzidoFabricanteIdentificador := FIntImportacoesFabricante.IntImportacaoFabricante.NomReduzidoFabricanteIdentificador;
  FImportacaoFabricante.NomUsuarioProc                     := FIntImportacoesFabricante.IntImportacaoFabricante.NomUsuarioProc;
  FImportacaoFabricante.NomUsuarioUpload                   := FIntImportacoesFabricante.IntImportacaoFabricante.NomUsuarioUpload;
  FImportacaoFabricante.QtdOcorrencias                     := FIntImportacoesFabricante.IntImportacaoFabricante.QtdOcorrencias;
  FImportacaoFabricante.QtdRegistrosErrados                := FIntImportacoesFabricante.IntImportacaoFabricante.QtdRegistrosErrados;
  FImportacaoFabricante.QtdRegistrosProcessados            := FIntImportacoesFabricante.IntImportacaoFabricante.QtdRegistrosProcessados;
  FImportacaoFabricante.QtdRegistrosTotal                  := FIntImportacoesFabricante.IntImportacaoFabricante.QtdRegistrosTotal;
  FImportacaoFabricante.SglTipoArqImportFabricante         := FIntImportacoesFabricante.IntImportacaoFabricante.SglTipoArqImportFabricante;
  FImportacaoFabricante.SglTipoOrigemArqImport             := FIntImportacoesFabricante.IntImportacaoFabricante.SglTipoOrigemArqImport;
  FImportacaoFabricante.TxtMensagem                        := FIntImportacoesFabricante.IntImportacaoFabricante.TxtMensagem;

  Result := FImportacaoFabricante;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacoesFabricante, Class_ImportacoesFabricante,
    ciMultiInstance, tmApartment);
end.
