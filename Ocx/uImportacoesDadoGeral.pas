// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/06/2004
// *  Documentação       : Importação de dado geral - documentação das classes
// *  Código Classe      : 90
// *  Descrição Resumida : Interface que descreve os métodos                              
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit uImportacoesDadoGeral;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntImportacoesDadoGeral, uIntMensagens,
  uConexao, uImportacaoDadoGeral;

type
  TImportacoesDadoGeral = class(TASPMTSObject, IImportacoesDadoGeral)
  private
    FIntImportacoesDadoGeral: TIntImportacoesDadoGeral;
    FImportacaoDadoGeral: TImportacaoDadoGeral;
    FInicializado: Boolean;
  protected
    function ArmazenarArqUpload(CodTipoOrigemArqImport: Integer;
      const NomArqUpload: WideString): Integer; safecall;
    function Buscar(CodArqImportDado: Integer): Integer; safecall;
    function Pesquisar(const NomArqUpload: WideString; DtaImportacaoInicio,
      DtaImportacaoFim: TDateTime; const NomUsuarioUpload: WideString;
      CodTipoOrigemArqImport: Integer;
      const CodSituacaoArqImport: WideString; DtaUltimoProcessamentoInicio,
      DtaUltimoProcessamentoFim: TDateTime;
      const NomUsuarioUltimoProc: WideString): Integer; safecall;
    function Get_ImportacaoDadoGeral: IImportacaoDadoGeral; safecall;
    function BOF: WordBool; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodArquivoImportDado: Integer): Integer; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function NumeroRegistros: Integer; safecall;
    function PesquisarOcorrencias(CodArqImportDado, CodTipoLinhaImportacao,
      CodTipoMensagem: Integer): Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function ProcessarArquivo(CodArqImportDado, LinhaInicial,
      TempoMaximo: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): WideString; safecall;
//?    function PesquisarTipoArquivoImportacaoSisBov: Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TImportacoesDadoGeral.AfterConstruction;
begin
  inherited;
  FImportacaoDadoGeral := TImportacaoDadoGeral.Create;
  FImportacaoDadoGeral.ObjAddRef;
  FInicializado := False;
end;

procedure TImportacoesDadoGeral.BeforeDestruction;
begin
  If FIntImportacoesDadoGeral <> nil Then Begin
    FIntImportacoesDadoGeral.Free;
  End;
  If FImportacaoDadoGeral <> nil Then Begin
    FImportacaoDadoGeral.ObjRelease;
    FImportacaoDadoGeral := nil;
  End;
  inherited;
end;

function TImportacoesDadoGeral.Get_ImportacaoDadoGeral: IImportacaoDadoGeral;
begin

FImportacaoDadoGeral.CodArqImportDadoGeral     :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodArqImportDadoGeral;
FImportacaoDadoGeral.NomArqUpLoad              :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.NomArqUpLoad;
FImportacaoDadoGeral.NomArqImportDadoGeral     :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.NomArqImportDadoGeral;
FImportacaoDadoGeral.DtaImportacao             :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DtaImportacao;
FImportacaoDadoGeral.CodUsuarioUltimoProc      :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodUsuarioUltimoProc;
FImportacaoDadoGeral.NomUsuarioUltimoProc      :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.NomUsuarioUltimoProc;
FImportacaoDadoGeral.CodUsuarioUpload          :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodUsuarioUpload;
FImportacaoDadoGeral.NomUsuarioUpload          :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.NomUsuarioUpload;
FImportacaoDadoGeral.QtdVezesProcessamento     :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdVezesProcessamento;
FImportacaoDadoGeral.DtaUltimoProcessamento    :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DtaUltimoProcessamento;
FImportacaoDadoGeral.QtdProdutoresTotal        :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdProdutoresTotal;
FImportacaoDadoGeral.QtdProdutoresErrados      :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdProdutoresErrados;
FImportacaoDadoGeral.QtdProdutoresProcessados  :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdProdutoresProcessados;
FImportacaoDadoGeral.QtdPropriedadesTotal       :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdPropriedadesTotal;
FImportacaoDadoGeral.QtdPropriedadesErradas     :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdPropriedadesErradas;
FImportacaoDadoGeral.QtdPropriedadesProcessadas :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdPropriedadesProcessadas;
FImportacaoDadoGeral.QtdFazendasTotal           :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdFazendasTotal;
FImportacaoDadoGeral.QtdFazendasErradas         :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdFazendasErradas;
FImportacaoDadoGeral.QtdFazendasProcessadas     :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdFazendasProcessadas;
FImportacaoDadoGeral.QtdLocaisTotal             :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdLocaisTotal;
FImportacaoDadoGeral.QtdLocaisErrados           :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdLocaisErrados;
FImportacaoDadoGeral.QtdLocaisProcessados       :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdLocaisProcessados;

FImportacaoDadoGeral.CodTipoOrigemArqImport    :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodTipoOrigemArqImport;
FImportacaoDadoGeral.SglTipoOrigemArqImport    :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.SglTipoOrigemArqImport;
FImportacaoDadoGeral.DesTipoOrigemArqImport    :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DesTipoOrigemArqImport;
FImportacaoDadoGeral.CodSituacaoArqImport      :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodSituacaoArqImport;
FImportacaoDadoGeral.DesSituacaoArqImport      :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DesSituacaoArqImport;
FImportacaoDadoGeral.QtdLinhas                 :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdLinhas;
FImportacaoDadoGeral.QtdOcorrencias            :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.QtdOcorrencias;
FImportacaoDadoGeral.CodUltimaTarefa           :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodUltimaTarefa;
FImportacaoDadoGeral.CodSituacaoUltimaTarefa   :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.CodSituacaoUltimaTarefa;
FImportacaoDadoGeral.DesSituacaoUltimaTarefa   :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DesSituacaoUltimaTarefa;
FImportacaoDadoGeral.DtaInicioPrevistoUltimaTarefa  :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DtaInicioPrevistoUltimaTarefa;
FImportacaoDadoGeral.DtaInicioRealUltimaTarefa :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DtaInicioRealUltimaTarefa;
FImportacaoDadoGeral.DtaFimRealUltimaTarefa    :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.DtaFimRealUltimaTarefa;
FImportacaoDadoGeral.TxtMensagem               :=  FIntImportacoesDadoGeral.IntImportacaoDadoGeral.TxtMensagem;

Result := FImportacaoDadoGeral;
end;

function TImportacoesDadoGeral.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntImportacoesDadoGeral := TIntImportacoesDadoGeral.Create;
  Result := FIntImportacoesDadoGeral.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TImportacoesDadoGeral.ArmazenarArqUpload(CodTipoOrigemArqImport: Integer;
        const NomArqUpload: WideString): Integer;
begin
  Result := FIntImportacoesDadoGeral.ArmazenarArqUpload(CodTipoOrigemArqImport, NomArqUpload);
end;

function TImportacoesDadoGeral.Buscar(CodArqImportDado: Integer): Integer;
begin
  Result := FIntImportacoesDadoGeral.Buscar(CodArqImportDado);
end;

function TImportacoesDadoGeral.Pesquisar(const NomArqUpload: WideString;
  DtaImportacaoInicio, DtaImportacaoFim: TDateTime;
  const NomUsuarioUpload: WideString; CodTipoOrigemArqImport: Integer;
  const CodSituacaoArqImport: WideString; DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime;
  const NomUsuarioUltimoProc: WideString): Integer;
begin
  Result := FIntImportacoesDadoGeral.Pesquisar(NomArqUpload, DtaImportacaoInicio, DtaImportacaoFim,
    NomUsuarioUpload, CodTipoOrigemArqImport, CodSituacaoArqImport, DtaUltimoProcessamentoInicio,
    DtaUltimoProcessamentoFim, NomUsuarioUltimoProc);
end;

function TImportacoesDadoGeral.BOF: WordBool;
begin
  Result := FIntImportacoesDadoGeral.BOF;
end;

function TImportacoesDadoGeral.Deslocar(NumDeslocamento: Integer): Integer;
begin
  Result := FIntImportacoesDadoGeral.Deslocar(NumDeslocamento);
end;

function TImportacoesDadoGeral.EOF: WordBool;
begin
  Result := FIntImportacoesDadoGeral.EOF;
end;

function TImportacoesDadoGeral.Excluir(
  CodArquivoImportDado: Integer): Integer;
begin
 Result := FIntImportacoesDadoGeral.Excluir(CodArquivoImportDado);
end;

procedure TImportacoesDadoGeral.FecharPesquisa;
begin
  FIntImportacoesDadoGeral.FecharPesquisa;
end;

procedure TImportacoesDadoGeral.IrAoAnterior;
begin
  FIntImportacoesDadoGeral.IrAoAnterior;
end;

procedure TImportacoesDadoGeral.IrAoPrimeiro;
begin
  FIntImportacoesDadoGeral.IrAoPrimeiro;
end;

procedure TImportacoesDadoGeral.IrAoProximo;
begin
  FIntImportacoesDadoGeral.IrAoProximo;
end;

procedure TImportacoesDadoGeral.IrAoUltimo;
begin
  FIntImportacoesDadoGeral.IrAoUltimo;
end;

function TImportacoesDadoGeral.NumeroRegistros: Integer;
begin
  Result := FIntImportacoesDadoGeral.NumeroRegistros;
end;

function TImportacoesDadoGeral.PesquisarOcorrencias(CodArqImportDado,
  CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer;
begin
  Result := FIntImportacoesDadoGeral.PesquisarOcorrencias(
    CodArqImportDado, CodTipoLinhaImportacao, CodTipoMensagem);
end;

procedure TImportacoesDadoGeral.Posicionar(NumPosicao: Integer);
begin
  FIntImportacoesDadoGeral.Posicionar(NumPosicao);
end;

function TImportacoesDadoGeral.ProcessarArquivo(CodArqImportDado,
  LinhaInicial, TempoMaximo: Integer): Integer;
begin
  Result := FIntImportacoesDadoGeral.ProcessarArquivo(CodArqImportDado,
    LinhaInicial, TempoMaximo);
end;

function TImportacoesDadoGeral.ValorCampo(
  const NomCampo: WideString): WideString;
begin
  Result := FIntImportacoesDadoGeral.ValorCampo(NomCampo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacoesDadoGeral, Class_ImportacoesDadoGeral,
    ciMultiInstance, tmApartment);
end.
