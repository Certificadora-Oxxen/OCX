// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Propriedade Rural,fazenda, etc - Definição das Classes.doc
// *  Código Classe      : 34
// *  Descrição Resumida : Cadastro de Fazenda
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    24/07/2002    Criação
// *   Arley    13/08/2002    Alteração nos atributos desta classe
// *   Arley    13/11/2002    Inclusão da propriedade IndSituacaoImagem
// *   Hitalo    19/11/2002    Adcionar metodo GerarRelatorio.
// *
// ****************************************************************************
unit uFazendas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntFazendas, uFazenda, uConexao,
  uIntMensagens;

type
  TFazendas = class(TASPMTSObject, IFazendas)
  private
    FIntFazendas : TIntFazendas;
    FInicializado : Boolean;
    FFazenda: TFazenda;
  protected
    function Alterar(CodFazenda: Integer; const SglFazenda,
      NomFazenda: WideString; CodEstado: Integer;
      const NumPropriedadeRural: WideString;
      CodIndTipoProprietario: Integer; const TxtObservacao, CodUlavPro,
      CodUlavFaz: WideString; QtdDistMun: Integer;
      const DesAcessoFaz: WideString): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodFazenda: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodFazenda: Integer): Integer; safecall;
    function Inserir(const SglFazenda, NomFazenda: WideString;
      CodEstado: Integer; const NumPropriedadeRural: WideString;
      CodIndTipoProprietario: Integer; const TxtObservacao, CodUlavPro,
      CodUlavFaz: WideString; QtdDistMun: Integer;
      const DesAcessoFaz: WideString): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Get_Fazenda: IFazenda; safecall;
    function EfetivarCadastro(CodFazenda, IndProdutorDefinido: Integer;
      const NumCNPJCpfProdutor: WideString): Integer; safecall;
    function CancelarEfetivacao(CodFazenda: Integer;
      const IndExportarPropriedade: WideString): Integer; safecall;
    function DefinirPropriedadeRural(CodFazenda,
      CodPropriedadeRural: Integer): Integer; safecall;
    function DefinirImagem(CodFazenda: Integer;
      const ArquivoOrigem: WideString): Integer; safecall;
    function LiberarImagem(CodFazenda: Integer): Integer; safecall;
    function RemoverImagem(CodFazenda: Integer): Integer; safecall;
    function GerarRelatorio(const SglProdutor, NomPessoaProdutor, SglFazenda,
      NomFazenda, CodSituacaoSISBOVFazenda, IndSituacaoImagemFazenda,
      NomPropriedadeRural, NumImovelReceitaFederal: WideString;
      CodLocalizacaoSisbov, CodEstado: Integer; const NomMunicipio,
      CodMicroRegiao: WideString; DtaInicioCadastramento,
      DtaFimCadastramento: TDateTime; Tipo, QtdQuebraRelatorio: Integer;
      DtaInicioVistoria, DtaFimVistoria: TDateTime): WideString; safecall;
    function InserirDadoGeral(const NumCNPJCPFProdutor, CodNaturezaProdutor,
      SglFazenda, NomFazenda: WideString; CodEstado: Integer;
      const NumPropriedadeRural, NumImovelReceitaFederal: WideString;
      CodIndTipoProprietario: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function AlterarCodigoExportacao(CodFazenda, CodExportacao: Integer): Integer; safecall;
    function DesvincularProdutorPropriedade(const cpfprodutor,
      cnpjprodutor: WideString; idpropriedade: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TFazendas.AfterConstruction;
begin
  inherited;
  FFazenda := TFazenda.Create;
  FFazenda.ObjAddRef;
  FInicializado := False;
end;

procedure TFazendas.BeforeDestruction;
begin
  If FIntFazendas <> nil Then Begin
    FIntFazendas.Free;
  End;
  If FFazenda <> nil Then Begin
    FFazenda.ObjRelease;
    FFazenda := nil;
  End;
  inherited;
end;

function TFazendas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntFazendas := TIntFazendas.Create;
  Result := FIntFazendas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TFazendas.Alterar(CodFazenda: Integer; const SglFazenda,
  NomFazenda: WideString; CodEstado: Integer;
  const NumPropriedadeRural: WideString; CodIndTipoProprietario: Integer;
  const TxtObservacao, CodUlavPro, CodUlavFaz: WideString;
  QtdDistMun: Integer; const DesAcessoFaz: WideString): Integer;
begin
  Result := FIntFazendas.Alterar(CodFazenda, SglFazenda, NomFazenda,
    CodEstado, NumPropriedadeRural, CodIndTipoProprietario, TxtObservacao,
    CodUlavPro, CodUlavFaz, QtdDistMun, DesAcessoFaz);
end;

function TFazendas.BOF: WordBool;
begin
  Result := FIntFazendas.BOF;
end;

function TFazendas.Buscar(CodFazenda: Integer): Integer;
begin
  Result := FIntFazendas.Buscar(CodFazenda);
end;

function TFazendas.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntFazendas.Deslocar(QtdRegistros);
end;

function TFazendas.EOF: WordBool;
begin
  Result := FIntFazendas.EOF;
end;

function TFazendas.Excluir(CodFazenda: Integer): Integer;
begin
  Result := FIntFazendas.Excluir(CodFazenda);
end;

function TFazendas.Inserir(const SglFazenda, NomFazenda: WideString;
  CodEstado: Integer; const NumPropriedadeRural: WideString;
  CodIndTipoProprietario: Integer; const TxtObservacao, CodUlavPro,
  CodUlavFaz: WideString; QtdDistMun: Integer;
  const DesAcessoFaz: WideString): Integer;
begin
  Result := FIntFazendas.Inserir(SglFazenda, NomFazenda, CodEstado, NumPropriedadeRural,
  CodIndTipoProprietario, TxtObservacao, CodUlavPro, CodUlavFaz, QtdDistMun, DesAcessoFaz);
end;

function TFazendas.NumeroRegistros: Integer;
begin
  Result := FIntFazendas.NumeroRegistros;
end;

function TFazendas.Pesquisar(const CodOrdenacao: WideString): Integer;
begin
  Result := FIntFazendas.Pesquisar(CodOrdenacao);
end;

function TFazendas.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntFazendas.ValorCampo(NomeColuna);
end;

procedure TFazendas.FecharPesquisa;
begin
  FIntFazendas.FecharPesquisa;
end;

procedure TFazendas.IrAoAnterior;
begin
  FIntFazendas.IrAoAnterior;
end;

procedure TFazendas.IrAoPrimeiro;
begin
  FIntFazendas.IrAoPrimeiro;
end;

procedure TFazendas.IrAoProximo;
begin
  FIntFazendas.IrAoProximo;
end;

procedure TFazendas.IrAoUltimo;
begin
  FIntFazendas.IrAoUltimo;
end;

procedure TFazendas.Posicionar(NumRegistro: Integer);
begin
  FIntFazendas.Posicionar(NumRegistro);
end;

function TFazendas.Get_Fazenda: IFazenda;
begin
  FFazenda.CodPessoaProdutor          := FIntFazendas.IntFazenda.CodPessoaProdutor;
  FFazenda.CodFazenda                 := FIntFazendas.IntFazenda.CodFazenda;
  FFazenda.SglFazenda                 := FIntFazendas.IntFazenda.SglFazenda;
  FFazenda.NomFazenda                 := FIntFazendas.IntFazenda.NomFazenda;
  FFazenda.CodEstado                  := FIntFazendas.IntFazenda.CodEstado;
  FFazenda.SglEstado                  := FIntFazendas.IntFazenda.SglEstado;
  FFazenda.NumPropriedadeRural        := FIntFazendas.IntFazenda.NumPropriedadeRural;
  FFazenda.TxtObservacao              := FIntFazendas.IntFazenda.TxtObservacao;
  FFazenda.CodPropriedadeRural        := FIntFazendas.IntFazenda.CodPropriedadeRural;
  FFazenda.NomPropriedadeRural        := FIntFazendas.IntFazenda.NomPropriedadeRural;
  FFazenda.NumImovelReceitaFederalPR  := FIntFazendas.IntFazenda.NumImovelReceitaFederalPR;
  FFazenda.CodIdPropriedadeSisbov     := FIntFazendas.IntFazenda.CodIdPropriedadeSisbov;
  FFazenda.NomMunicipioPR             := FIntFazendas.IntFazenda.NomMunicipioPR;
  FFazenda.SglEstadoPR                := FIntFazendas.IntFazenda.SglEstadoPR;
  FFazenda.NomPaisPR                  := FIntFazendas.IntFazenda.NomPaisPR;
  FFazenda.DtaCadastramento           := FIntFazendas.IntFazenda.DtaCadastramento;
  FFazenda.DtaEfetivacaoCadastro      := FIntFazendas.IntFazenda.DtaEfetivacaoCadastro;
  FFazenda.IndSituacaoImagem          := FIntFazendas.IntFazenda.IndSituacaoImagem;
  FFazenda.IndEfetivadoUmaVez         := FIntFazendas.IntFazenda.IndEfetivadoUmaVez;
  FFazenda.CodLocalizacaoSisbov       := FIntFazendas.IntFazenda.CodLocalizacaoSisbov;
  FFazenda.CodRegimePosseUso          := FIntFazendas.IntFazenda.CodRegimePosseUso;
  FFazenda.DesRegimePosseUso          := FIntFazendas.IntFazenda.DesRegimePosseUso;
  FFazenda.CodUlavPro                 := FIntFazendas.IntFazenda.CodUlavPro;
  FFazenda.CodUlavFaz                 := FIntFazendas.IntFazenda.CodUlavFaz;
  FFazenda.QtdDistMunicipio           := FIntFazendas.IntFazenda.QtdDistMunicipio;
  FFazenda.DesAcessoFaz               := FIntFazendas.IntFazenda.DesAcessoFaz;
  Result := FFazenda;
end;

function TFazendas.EfetivarCadastro(CodFazenda,
  IndProdutorDefinido: Integer;
  const NumCNPJCpfProdutor: WideString): Integer;
begin
  Result := FIntFazendas.EfetivarCadastro(CodFazenda, IndProdutorDefinido, NumCNPJCpfProdutor);
end;

function TFazendas.CancelarEfetivacao(CodFazenda: Integer;
  const IndExportarPropriedade: WideString): Integer;
begin
  Result := FIntFazendas.CancelarEfetivacao(CodFazenda, IndExportarPropriedade);
end;

function TFazendas.DefinirPropriedadeRural(CodFazenda,
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntFazendas.DefinirPropriedadeRural(CodFazenda, CodPropriedadeRural);
end;

function TFazendas.DefinirImagem(CodFazenda: Integer;
  const ArquivoOrigem: WideString): Integer;
begin
  Result := FIntFazendas.DefinirImagem(CodFazenda, ArquivoOrigem);
end;

function TFazendas.LiberarImagem(CodFazenda: Integer): Integer;
begin
  Result := FIntFazendas.LiberarImagem(CodFazenda);
end;

function TFazendas.RemoverImagem(CodFazenda: Integer): Integer;
begin
  Result := FIntFazendas.RemoverImagem(CodFazenda);
end;

function TFazendas.GerarRelatorio(const SglProdutor, NomPessoaProdutor,
  SglFazenda, NomFazenda, CodSituacaoSISBOVFazenda,
  IndSituacaoImagemFazenda, NomPropriedadeRural,
  NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
  CodEstado: Integer; const NomMunicipio, CodMicroRegiao: WideString;
  DtaInicioCadastramento, DtaFimCadastramento: TDateTime; Tipo,
  QtdQuebraRelatorio: Integer; DtaInicioVistoria,
  DtaFimVistoria: TDateTime): WideString;
begin
  Result := FIntFazendas.GerarRelatorio(SglProdutor, NomPessoaProdutor,
    SglFazenda, NomFazenda, CodSituacaoSISBOVFazenda,IndSituacaoImagemFazenda,
    NomPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov, CodEstado, NomMunicipio,
    CodMicroRegiao, DtaInicioCadastramento, DtaFimCadastramento, Tipo, QtdQuebraRelatorio, -1,
    DtaInicioVistoria, DtaFimVistoria);
end;

function TFazendas.InserirDadoGeral(const NumCNPJCPFProdutor,
  CodNaturezaProdutor, SglFazenda, NomFazenda: WideString;
  CodEstado: Integer; const NumPropriedadeRural,
  NumImovelReceitaFederal: WideString; CodIndTipoProprietario: Integer;
  const TxtObservacao: WideString): Integer;
begin
  Result := FIntFazendas.InserirDadoGeral(NumCNPJCPFProdutor,
  CodNaturezaProdutor, SglFazenda, NomFazenda,
  CodEstado, NumPropriedadeRural, NumImovelReceitaFederal,
  CodIndTipoProprietario, TxtObservacao);
end;

function TFazendas.AlterarCodigoExportacao(CodFazenda, CodExportacao: Integer): Integer;
begin
  Result := FIntFazendas.AlterarCodigoExportacao(CodFazenda, CodExportacao);
end;

function TFazendas.DesvincularProdutorPropriedade(const cpfprodutor,
  cnpjprodutor: WideString; idpropriedade: Integer): Integer;
begin
  result  :=  FIntFazendas.desvincularProdutorPropriedade(cpfProdutor,cnpjProdutor,idPropriedade);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFazendas, Class_Fazendas,
    ciMultiInstance, tmApartment);
end.

