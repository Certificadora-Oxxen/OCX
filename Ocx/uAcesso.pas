// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 25/07/2002
// *  Documenta��o       : Controle de acesso - defini��o das classes
// *  C�digo Classe      : 14
// *  Descri��o Resumida : Controle de Acesso
// ************************************************************************
// *  �ltimas Altera��es
// *   Jerry    25/07/2002    Cria��o
// *   Hitalo   02/09/2002    Adicionar SglProdutor,QtdCaracterCodManejo
// *
// ************************************************************************
unit uAcesso;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uIntAcesso,
  uUsuario, uItemMenu, uBloqueio, uProdutor, uFazendaTrabalho,uParametro;

type
  TAcesso = class(TASPMTSObject, IAcesso)
  private
    FIntAcesso : TIntAcesso;
    FInicializado : Boolean;
    FUsuario: TUsuario;
    FItemMenu: TItemMenu;
    FBloqueio: TBloqueio;
    FProdutorTrabalho: TProdutor;
    FFazendaTrabalho: TFazendaTrabalho;
    FParametro    : TParametro;
  protected
    function Get_Bloqueio: IBloqueio; safecall;
    function Get_ItemMenu: IItemMenu; safecall;
    function Get_ProdutorTrabalho: IProdutor; safecall;
    function Get_TipoAcesso: WideString; safecall;
    function Get_Usuario: IUsuario; safecall;
    procedure PesquisarItensMenu(CodItemPai, NumNivelMaximo: Integer);
      safecall;
    function EOFItensMenu: WordBool; safecall;
    procedure BuscarProximoItemMenu; safecall;
    function PodeExecutarFuncao(CodFuncao: Integer): WordBool; safecall;
    function PesquisarProdutores(CodProdutor: Integer; const NomProdutor,
      CodNatureza, NumCNPJCPF: WideString): Integer; safecall;
    procedure IrAoProximoProdutor; safecall;
    function ValorCampoProdutor(const NomCampo: WideString): OleVariant;
      safecall;
    function EOFProdutores: WordBool; safecall;
    procedure FecharPesquisaProdutores; safecall;
    function DefinirProdutorTrabalho(CodProdutor: Integer): Integer; safecall;
    procedure LimparProdutorTrabalho; safecall;
    function ExisteProdutorTrabalho: WordBool; safecall;
    function QtdComunicadosNaoLidos: Integer; safecall;
    function AlterarUsuario(const TxtSenhaAtual, NomUsuarioNovo, TxtSenhaNova,
      NomTratamentoNovo: WideString): Integer; safecall;
    function Get_FazendaTrabalho: IFazendaTrabalho; safecall;
    function DefinirFazendaTrabalho(CodFazenda: Integer): Integer; safecall;
    function ExisteFazendaTrabalho: WordBool; safecall;
    procedure LimparFazendaTrabalho; safecall;
    function QtdComunicadosImportantesNaoLidos: Integer; safecall;
    function Get_Parametro: IParametro; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens;
      NomUsuario, TxtSenha: String): Integer;
  end;

implementation

uses ComServ, uIntFazendaTrabalho;

procedure TAcesso.AfterConstruction;
begin
  inherited;

  FUsuario := TUsuario.Create;
  FUsuario.ObjAddRef;
  FItemMenu := TItemMenu.Create;
  FItemMenu.ObjAddRef;
  FBloqueio := TBloqueio.Create;
  FBloqueio.ObjAddRef;
  FProdutorTrabalho := TProdutor.Create;
  FProdutorTrabalho.ObjAddRef;
  FFazendaTrabalho := TFazendaTrabalho.Create;
  FFazendaTrabalho.ObjAddRef;
  FParametro := TParametro.Create;
  FParametro.ObjAddRef;

  FInicializado := False;
end;

procedure TAcesso.BeforeDestruction;
begin
  If FIntAcesso <> nil Then Begin
    FIntAcesso.Free;
  End;

  If FUsuario <> nil Then Begin
    FUsuario.ObjRelease;
    FUsuario := nil;
  End;
  If FItemMenu <> nil Then Begin
    FItemMenu.ObjRelease;
    FItemMenu := nil;
  End;
  If FBloqueio <> nil Then Begin
    FBloqueio.ObjRelease;
    FBloqueio := nil;
  End;
  If FProdutorTrabalho <> nil Then Begin
    FProdutorTrabalho.ObjRelease;
    FProdutorTrabalho := nil;
  End;
  If FFazendaTrabalho <> nil Then Begin
    FFazendaTrabalho.ObjRelease;
    FFazendaTrabalho := nil;
  End;
  If FParametro <> nil Then Begin
    FParametro.ObjRelease;
    FParametro := nil;
  End;
  inherited;
end;

function TAcesso.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens;
      NomUsuario, TxtSenha: String): Integer;
begin
  FIntAcesso := TIntAcesso.Create;
  Result := FIntAcesso.Inicializar(ConexaoBD, Mensagens, NomUsuario, TxtSenha);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAcesso.Get_Bloqueio: IBloqueio;
begin
  FBloqueio.CodAplicacaoBloqueio   := FIntAcesso.IntBloqueio.CodAplicacaoBloqueio;
  FBloqueio.CodUsuario             := FIntAcesso.IntBloqueio.CodUsuario;
  FBloqueio.CodPessoaProdutor      := FIntAcesso.IntBloqueio.CodPessoaProdutor;
  FBloqueio.DtaInicioBloqueio      := FIntAcesso.IntBloqueio.DtaInicioBloqueio;
  FBloqueio.DtaFimBloqueio         := FIntAcesso.IntBloqueio.DtaFimBloqueio;
  FBloqueio.CodMotivoBloqueio      := FIntAcesso.IntBloqueio.CodMotivoBloqueio;
  FBloqueio.TxtMotivoBloqueio      := FIntAcesso.IntBloqueio.TxtMotivoBloqueio;
  FBloqueio.TxtObservacaoBloqueio  := FIntAcesso.IntBloqueio.TxtObservacaoBloqueio;
  FBloqueio.TxtMotivoUsuario       := FIntAcesso.IntBloqueio.TxtMotivoUsuario;
  FBloqueio.TxtObservacaoUsuario   := FIntAcesso.IntBloqueio.TxtObservacaoUsuario;
  FBloqueio.TxtProcedimentoUsuario := FIntAcesso.IntBloqueio.TxtProcedimentoUsuario;
  FBloqueio.CodUsuarioResponsavel  := FIntAcesso.IntBloqueio.CodUsuarioResponsavel;
  FBloqueio.NomUsuarioResponsavel  := FIntAcesso.IntBloqueio.NomUsuarioResponsavel;
  FBloqueio.NomUsuario             := FIntAcesso.IntBloqueio.NomUsuario;
  FBloqueio.NomPessoa              := FIntAcesso.IntBloqueio.NomPessoa;
  Result := FBloqueio;
end;

function TAcesso.Get_ItemMenu: IItemMenu;
begin
  FItemMenu.CodItemMenu := FIntAcesso.IntItemMenu.CodItemMenu;
  FItemMenu.TxtTitulo := FIntAcesso.IntItemMenu.TxtTitulo;
  FItemMenu.TxtHintItemMenu := FIntAcesso.IntItemMenu.TxtHintItemMenu;
  FItemMenu.IndDestaqueTitulo := FIntAcesso.IntItemMenu.IndDestaqueTitulo;
  FItemMenu.CodItemPai := FIntAcesso.IntItemMenu.CodItemPai;
  FItemMenu.NumOrdem := FIntAcesso.IntItemMenu.NumOrdem;
  FItemMenu.NumNivel := FIntAcesso.IntItemMenu.NumNivel;
  FItemMenu.QtdFilhos := FIntAcesso.IntItemMenu.QtdFilhos;
  FItemMenu.CodPagina := FIntAcesso.IntItemMenu.CodPagina;
  FItemMenu.URLPagina := FIntAcesso.IntItemMenu.URLPagina;
  Result := FItemMenu;
end;

function TAcesso.Get_ProdutorTrabalho: IProdutor;
begin
  FProdutorTrabalho.CodProdutor                 := FIntAcesso.Conexao.ProdutorTrabalho.CodProdutor;
  FProdutorTrabalho.NomProdutor                 := FIntAcesso.Conexao.ProdutorTrabalho.NomProdutor;
  FProdutorTrabalho.CodNatureza                 := FIntAcesso.Conexao.ProdutorTrabalho.CodNatureza;
  FProdutorTrabalho.NumCPFCNPJ                  := FIntAcesso.Conexao.ProdutorTrabalho.NumCPFCNPJ;
  FProdutorTrabalho.NumCPFCNPJFormatado         := FIntAcesso.Conexao.ProdutorTrabalho.NumCPFCNPJFormatado;
  FProdutorTrabalho.SglProdutor                 := FIntAcesso.Conexao.ProdutorTrabalho.SglProdutor;
  FProdutorTrabalho.QtdCaracterCodManejo        := FIntAcesso.Conexao.ProdutorTrabalho.QtdCaracterCodManejo;
  FProdutorTrabalho.IndConsultaPublica          := FIntAcesso.Conexao.ProdutorTrabalho.IndConsultaPublica;
  FProdutorTrabalho.CodTipoAgrupamentoRacas     := FIntAcesso.Conexao.ProdutorTrabalho.CodTipoAgrupamentoRacas;
  FProdutorTrabalho.QtdDenominadorCompRacial    := FIntAcesso.Conexao.ProdutorTrabalho.QtdDenominadorCompRacial;
  FProdutorTrabalho.QtdDiasEntreCoberturas      := FIntAcesso.Conexao.ProdutorTrabalho.QtdDiasEntreCoberturas;
  FProdutorTrabalho.QtdDiasDescansoReprodutivo  := FIntAcesso.Conexao.ProdutorTrabalho.QtdDiasDescansoReprodutivo;
  FProdutorTrabalho.QtdDiasDiagnosticoGestacao  := FIntAcesso.Conexao.ProdutorTrabalho.QtdDiasDiagnosticoGestacao;
  FProdutorTrabalho.CodAptidao                  := FIntAcesso.Conexao.ProdutorTrabalho.CodAptidao;
  FProdutorTrabalho.CodSituacaoSisBov           := FIntAcesso.Conexao.ProdutorTrabalho.CodSituacaoSisBov;
  FProdutorTrabalho.IndMostrarNome              := FIntAcesso.Conexao.ProdutorTrabalho.IndMostrarNome;
  FProdutorTrabalho.IndMostrarIdentificadores   := FIntAcesso.Conexao.ProdutorTrabalho.IndMostrarIdentificadores;
  FProdutorTrabalho.IndTransfereEmbrioes        := FIntAcesso.Conexao.ProdutorTrabalho.IndtransfereEmbrioes;
  FProdutorTrabalho.IndMostrarFiltroCompRacial  := FIntAcesso.Conexao.ProdutorTrabalho.IndMostrarFiltroCompRacial;
  FProdutorTrabalho.IndEstacaoMonta             := FIntAcesso.Conexao.ProdutorTrabalho.IndEstacaoMonta;
  FProdutorTrabalho.IndTrabalhaAssociacaoRaca   := FIntAcesso.Conexao.ProdutorTrabalho.IndTrabalhaAssociacaoRaca;
  FProdutorTrabalho.QtdIdadeMinimaDesmame       := FIntAcesso.Conexao.ProdutorTrabalho.QtdIdadeMinimaDesmame;
  FProdutorTrabalho.QtdIdadeMaximaDesmame       := FIntAcesso.Conexao.ProdutorTrabalho.QtdIdadeMaximaDesmame;
  FProdutorTrabalho.IndAplicarDesmameAutomatico := FIntAcesso.Conexao.ProdutorTrabalho.IndAplicarDesmameAutomatico;
  Result := FProdutorTrabalho;
end;

function TAcesso.Get_TipoAcesso: WideString;
begin
  Result := FIntAcesso.TipoAcesso;
end;

function TAcesso.Get_Usuario: IUsuario;
begin
  FUsuario.CodUsuario := FIntAcesso.IntUsuario.CodUsuario;
  FUsuario.NomUsuario := FIntAcesso.IntUsuario.NomUsuario;
  FUsuario.NomTratamento := FIntAcesso.IntUsuario.NomTratamento;
  FUsuario.CodPessoa := FIntAcesso.IntUsuario.CodPessoa;
  FUsuario.NomPessoa := FIntAcesso.IntUsuario.NomPessoa;
  FUsuario.CodNaturezaPessoa := FIntAcesso.IntUsuario.CodNaturezaPessoa;
  FUsuario.NumCNPJCPF := FIntAcesso.IntUsuario.NumCNPJCPF;
  FUsuario.CodPapel := FIntAcesso.IntUsuario.CodPapel;
  FUsuario.DesPapel := FIntAcesso.IntUsuario.DesPapel;
  FUsuario.CodPerfil := FIntAcesso.IntUsuario.CodPerfil;
  FUsuario.DesPerfil := FIntAcesso.IntUsuario.DesPerfil;
  FUsuario.QtdAcumLoginsCorretos := FIntAcesso.IntUsuario.QtdAcumLoginsCorretos;
  FUsuario.QtdAcumLoginsIncorretos := FIntAcesso.IntUsuario.QtdAcumLoginsIncorretos;
  FUsuario.DtaUltimoLoginCorreto := FIntAcesso.IntUsuario.DtaUltimoLoginCorreto;
  FUsuario.DtaUltimoLoginIncorreto := FIntAcesso.IntUsuario.DtaUltimoLoginIncorreto;
  FUsuario.QtdLoginsIncorretos := FIntAcesso.IntUsuario.QtdLoginsIncorretos;
  FUsuario.DtaCriacaoUsuario := FIntAcesso.IntUsuario.DtaCriacaoUsuario;
  FUsuario.NumCNPJCPFFormatado := FIntAcesso.IntUsuario.NumCNPJCPFFormatado;
  FUsuario.DtaPenultimoLoginCorreto := FIntAcesso.IntUsuario.DtaPenultimoLoginCorreto;
  FUsuario.NomUsuarioReduzido := FIntAcesso.IntUsuario.NomUsuarioReduzido;
  Result := FUsuario;
end;

procedure TAcesso.PesquisarItensMenu(CodItemPai, NumNivelMaximo: Integer);
begin
  FIntAcesso.PesquisarItensMenu(CodItemPai, NumNivelMaximo);
end;

function TAcesso.EOFItensMenu: WordBool;
begin
  Result := FIntAcesso.EOFItensMenu;
end;

procedure TAcesso.BuscarProximoItemMenu;
begin
  FIntAcesso.BuscarProximoItemMenu;
end;

function TAcesso.PodeExecutarFuncao(CodFuncao: Integer): WordBool;
begin
  Result := FIntAcesso.PodeExecutarFuncao(CodFuncao);
end;

function TAcesso.PesquisarProdutores(CodProdutor: Integer;
  const NomProdutor, CodNatureza, NumCNPJCPF: WideString): Integer;
begin
  Result := FIntAcesso.PesquisarProdutores(CodProdutor, NomProdutor, CodNatureza, NumCNPJCPF);
end;

procedure TAcesso.IrAoProximoProdutor;
begin
  FIntAcesso.IrAoProximoProdutor;
end;

function TAcesso.ValorCampoProdutor(
  const NomCampo: WideString): OleVariant;
begin
  Result := FIntAcesso.ValorCampoProdutor(NomCampo);
end;

function TAcesso.EOFProdutores: WordBool;
begin
  Result := FIntAcesso.EOFProdutores;
end;

procedure TAcesso.FecharPesquisaProdutores;
begin
  FIntAcesso.FecharPesquisaProdutores;
end;

function TAcesso.DefinirProdutorTrabalho(CodProdutor: Integer): Integer;
begin
  Result := FIntAcesso.DefinirProdutorTrabalho(CodProdutor);
end;

procedure TAcesso.LimparProdutorTrabalho;
begin
  FIntAcesso.LimparProdutorTrabalho;
end;

function TAcesso.ExisteProdutorTrabalho: WordBool;
begin
  Result := FIntAcesso.ExisteProdutorTrabalho;
end;

function TAcesso.QtdComunicadosNaoLidos: Integer;
begin
  Result := FIntAcesso.QtdComunicadosNaoLidos;
end;

function TAcesso.AlterarUsuario(const TxtSenhaAtual, NomUsuarioNovo,
  TxtSenhaNova, NomTratamentoNovo: WideString): Integer;
begin
  Result := FIntAcesso.AlterarUsuario(TxtSenhaAtual, NomUsuarioNovo, TxtSenhaNova, NomTratamentoNovo);
end;

function TAcesso.Get_FazendaTrabalho: IFazendaTrabalho;
begin
  FFazendaTrabalho.CodFazenda := FIntAcesso.Conexao.FazendaTrabalho.CodFazenda;
  FFazendaTrabalho.SglFazenda := FIntAcesso.Conexao.FazendaTrabalho.SglFazenda;
  FFazendaTrabalho.NomFazenda := FIntAcesso.Conexao.FazendaTrabalho.NomFazenda;

  FFazendaTrabalho.DataUltimaVistoria := FIntAcesso.Conexao.FazendaTrabalho.DataUltimaVistoria;
  FFazendaTrabalho.StatusVistoria     := FIntAcesso.Conexao.FazendaTrabalho.StatusVistoria;

  Result := FFazendaTrabalho;
end;

function TAcesso.DefinirFazendaTrabalho(CodFazenda: Integer): Integer;
begin
  Result := FIntAcesso.DefinirFazendaTrabalho(CodFazenda);
end;

function TAcesso.ExisteFazendaTrabalho: WordBool;
begin
  Result := FIntAcesso.ExisteFazendaTrabalho;
end;

procedure TAcesso.LimparFazendaTrabalho;
begin
  FIntAcesso.LimparFazendaTrabalho;
end;

function TAcesso.QtdComunicadosImportantesNaoLidos: Integer;
begin
  Result := FIntAcesso.QtdComunicadosImportantesNaoLidos;
end;

function TAcesso.Get_Parametro: IParametro;
begin
  FParametro.CodPaisCertificadora          := FIntAcesso.IntParametro.CodPaisCertificadora;
  FParametro.NomPaisCertificadora          := FIntAcesso.IntParametro.NomPaisCertificadora;
  FParametro.CodPaisSisBovCertificadora    := FIntAcesso.IntParametro.CodPaisSisBovCertificadora;
  FParametro.IndCodCertificadoraAutomatico := FIntAcesso.IntParametro.IndCodCertificadoraAutomatico;
  Result := FParametro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAcesso, Class_Acesso,
    ciMultiInstance, tmApartment);
end.
