unit uSessao;

{$DEFINE MSSQL}

interface

uses
  Classes,
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, SysUtils, IniFiles, DB,
  FileCtrl, DBTables, uConexao, uIntMensagens, uMensagens, uFerramentas,
  uBanners, uTiposBanner, uTiposPagina, uLayoutsPagina, uGruposPaginas,
  uBannersDefault, uPaginas, uTiposTarget, uAnunciantes, uProgramas,
  uResultadosAnuncio, uAcesso, uPessoas, uPapeis, uUsuarios, uComunicados,
  uBloqueios, uPerfis, uAcessoTecnicoProdutor, uAcessoAssociacaoProdutor,
  uMotivosBloqueio, uPaises,uEstados,uMicroRegioes, uCodigosSisbov , uRacas,
  uPelagens, uLocais, uTiposOrigem, uFazendas, uRegimesAlimentares,
  uAssociacoesRaca, uGrausSangue, uTiposIdentificador, uCategoriasAnimal,
  uTiposFonteAgua, uAnimais, uLotes, uLocalidades, uPapeisSecundarios,
  uPessoasSecundarias, uOpcoesEnvioComunicado, uTiposContato, uTiposEndereco,
  uPropriedadesRurais, uAptidoes, uEspecies, uTiposMorte, uCausasMorte,
  uGrausInstrucao, uPosicoesIdentificador, uTiposLugar, USituacoesSisBov,
  uPessoasContatos, uGrandezasResumo,uGruposEvento, uTiposEvento,
  uUnidadesMedida, uTiposInsumo, uSubTiposInsumo, uFabricantesInsumo,
  uEventos, uMudancasCategoriaAnimal, uInsumos, uEntradasInsumo, uRelatorios,
  uOrientacoes, uTamanhosFonte, uLargurasLinhaRelatorio, uInterfaceSisbov,
  uTiposArquivoSISBOV, uTiposSubEventoSanitario, uReprodutoresMultiplos,
  uParametrosPesoAjustado, uModelosCertificado, uImportacoes,
  uTiposAgrupamentoRacas, uAgrupamentosRacas, uTarefas, uIntClassesBasicas,
  uSituacoesTarefa, uEstoqueSemen, uTiposMovimentoEstoqueSemen,
  uTiposAvaliacao, uCaracteristicasAvaliacao, uGrausDificuldade,
  uSituacoesCria, uMotivosDescarte, uImportacoesSISBOV, uImportacoesDadoGeral,
  uTiposOrigemArqImport, uRegimesPosseUso, uArquivosFTPEnvio,
  uOcorrenciasSistema, uFormasPagamentoIdentificador, uFormasPagamentoOS,
  uFabricantesIdentificador, uIdentificacoesDuplas, uProdutosAcessorios,
  uSituacoesOS, uArquivosRemessaPedido, uOrdensServico, uArquivosFTPRetorno,
  uEnderecos, uRotinasFTPRetorno, uEmailsEnvio, uSituacoesCodigoSISBOV,
  uSituacoesEmail, uTiposEmail, uSituacoesFTP, uTiposMensagem, uRotinasFTPEnvio,
  uAplicativos, uImportacoesFabricante, uSituacoesArqImport, uMenus, uBoletosBancario,
  uIdentificacoesBancarias, uDownloads, uTiposPropriedades, uInventariosAnimais,
  uInventariosCodigosSisbov, uTmpAplicaEvento,uTipoPropriedades, uSolicitacaoReimpressao;


const
  DIR_ROOT = 'D:\HERDOM';
  ARQUIVO_INI = 'D:\HERDOM\herdom.ini';
  ARQUIVO_DEBUG = 'D:\HERDOM\Log\OCX_BRENDOWN.txt';

type
  TSessao = class(TASPMTSObject, ISessao)

  // Declarações de Variaveis, Funções e Procedures Privadas da TSessao
  private
    FConexao:                      TConexao;
    FMensagens:                    TIntMensagens;
    FAtiva:                        Boolean;
    FCaminhoArquivosCertificadora: String;
    FBanners:                      TBanners;
    FTiposBanner:                  TTiposBanner;
    FTiposPagina:                  TTiposPagina;
    FLayoutsPagina:                TLayoutsPagina;
    FGruposPaginas:                TGruposPaginas;
    FBannersDefault:               TBannersDefault;
    FPaginas:                      TPaginas;
    FTiposTarget:                  TTiposTarget;
    FAnunciantes:                  TAnunciantes;
    FProgramas:                    TProgramas;
    FResultadosAnuncio:            TResultadosAnuncio;
    FAcesso:                       TAcesso;
    FPessoas:                      TPessoas;
    FPapeis:                       TPapeis;
    FUsuarios:                     TUsuarios;
    FComunicados:                  TComunicados;
    FBloqueios:                    TBloqueios;
    FPerfis:                       TPerfis;
    FAcessoTecnicoProdutor:        TAcessoTecnicoProdutor;
    FAcessoAssociacaoProdutor:     TAcessoAssociacaoProdutor;
    FMotivosBloqueio:              TMotivosBloqueio;
    FPaises:                       TPaises;
    FCodigosSisbov:                TCodigosSisbov;
    FEstados:                      TEstados;
    FMicroRegioes:                 TMicroRegioes;
    FRacas:                        TRacas;
    FPelagens:                     TPelagens;
    FLocais:                       TLocais;
    FTiposOrigem:                  TTiposOrigem;
    FFazendas:                     TFazendas;
    FRegimesAlimentares:           TRegimesAlimentares;
    FAssociacoesRaca:              TAssociacoesRaca;
    FGrausSangue:                  TGrausSangue;
    FTiposIdentificador:           TTiposIdentificador;
    FCategoriasAnimal:             TCategoriasAnimal;
    FTiposFonteAgua:               TTiposFonteAgua;
    FAnimais:                      TAnimais;
    FLotes:                        TLotes;
    FLocalidades:                  TLocalidades;
    FPapeisSecundarios:            TPapeisSecundarios;
    FPessoasSecundarias:           TPessoasSecundarias;
    FOpcoesEnvioComunicado:        TOpcoesEnvioComunicado;
    FTiposContato:                 TTiposContato;
    FTiposEndereco:                TTiposEndereco;
    FPropriedadesRurais:           TPropriedadesRurais;
    FAptidoes:                     TAptidoes;
    FEspecies:                     TEspecies;
    FTiposMorte:                   TTiposMorte;
    FCausasMorte:                  TCausasMorte;
    FGrausInstrucao:               TGrausInstrucao;
    FPosicoesIdentificador:        TPosicoesIdentificador;
    FTiposLugar:                   TTiposLugar;
    FSituacoesSisBov:              TSituacoesSisBov;
    FPessoasContatos:              TPessoasContatos;
    FGrandezasResumo:              TGrandezasResumo;
    FGruposEvento:                 TGruposEvento;
    FTiposEvento:                  TTiposEvento;
    FUnidadesMedida:               TUnidadesMedida;
    FTiposInsumo:                  TTiposInsumo;
    FSubTiposInsumo:               TSubTiposInsumo;
    FFabricantesInsumo:            TFabricantesInsumo;
    FEventos:                      TEventos;
    FMudancasCategoriaAnimal:      TMudancasCategoriaAnimal;
    FInsumos:                      TInsumos;
    FEntradasInsumo:               TEntradasInsumo;
    FRelatorios:                   TRelatorios;
    FOrientacoes:                  TOrientacoes;
    FTamanhosFonte:                TTamanhosFonte;
    FLargurasLinhaRelatorio:       TLargurasLinhaRelatorio;
    FInterfaceSisbov:              TInterfaceSisbov;
    FTiposArquivoSISBOV:           TTiposArquivoSISBOV;
    FTiposSubEventoSanitario:      TTiposSubEventoSanitario;
    FReprodutoresMultiplos:        TReprodutoresMultiplos;
    FParametrosPesoAjustado:       TParametrosPesoAjustado;
    FModelosCertificado:           TModelosCertificado;
    FImportacoes:                  TImportacoes;
    FTiposAgrupamentoRacas:        TTiposAgrupamentoRacas;
    FAgrupamentosRacas:            TAgrupamentosRacas;
    FTarefas:                      TTarefas;
    FSituacoesTarefa:              TSituacoesTarefa;
    FEstoqueSemen:                 TEstoqueSemen;
    FTiposMovimentoEstoqueSemen:   TTiposMovimentoEstoqueSemen;
    FTiposAvaliacao:               TTiposAvaliacao;
    FCaracteristicasAvaliacao:     TCaracteristicasAvaliacao;
    FSituacoesCria:                TSituacoesCria;
    FGrausDificuldade:             TGrausDificuldade;
    FMotivosDescarte:              TMotivosDescarte;
    FImportacoesSISBOV:            TImportacoesSISBOV;
    FImportacoesDadoGeral:         TImportacoesDadoGeral;
    FTiposOrigemArqImport:         TTiposOrigemArqImport;
    FRegimesPosseUso:              TRegimesPosseUso;
    FArquivosFTPEnvio:             TArquivosFTPEnvio;
    FOcorrenciasSistema:           TOcorrenciasSistema;
    FFormasPagamentoIdentificador: TFormasPagamentoIdentificador;
    FFormasPagamentoOS:            TFormasPagamentoOS;
    FFabricantesIdentificador:     TFabricantesIdentificador;
    FIdentificacoesDuplas:         TIdentificacoesDuplas;
    FProdutosAcessorios:           TProdutosAcessorios;
    FSituacoesOS:                  TSituacoesOS;
    FArquivosRemessaPedido:        TArquivosRemessaPedido;
    FOrdensServico:                TOrdensServico;
    FArquivosFTPRetorno:           TArquivosFTPRetorno;
    FEnderecos:                    TEnderecos;
    FRotinasFTPRetorno:            TRotinasFTPRetorno;
    FEmailsEnvio:                  TEmailsEnvio;
    FSituacoesCodigoSISBOV:        TSituacoesCodigoSISBOV;
    FSituacoesEmail:               TSituacoesEmail;
    FTiposEmail:                   TTiposEmail;
    FSituacoesFTP:                 TSituacoesFTP;
    FTiposMensagem:                TTiposMensagem;
    FRotinasFTPEnvio:              TRotinasFTPEnvio;
    FAplicativos:                  TAplicativos;
    FImportacoesFabricante:        TImportacoesFabricante;
    FSituacoesArqImport:           TSituacoesArqImport;
    FMenus:                        TMenus;
    FBoletosBancario:              TBoletosBancario;
    FIdentificacoesBancarias:      TIdentificacoesBancarias;
    FDownloads:                    TDownloads;
    FTiposPropriedades:            TTiposPropriedades;
    FInventariosAnimais:           TInventariosAnimais;
    FInventariosCodigosSisbov:     TInventariosCodigosSisbov;
    FTmpAplicaEvento:              TTmpAplicaEvento;
    FTipoPropriedades:             TTipoPropriedades;
    FSolicitacaoReimpressao:      TSolicitacaoReimpressao;
    
    function BuscarSPID: Integer;
    function BuscarValorParametroSistema(Parametro: Integer): String;
    function InicializarAcesso(const NomUsuario, TxtSenha: WideString): Integer; safecall;
    procedure LimparRelatoriosSessao;

  // Declarações de Variaveis, Funções e Procedures Protegidas da TSessao
  protected
    function Inicializar(const IdCertificadora, NomUsuario, TxtSenha: WideString): Integer; safecall;
    function Mensagens: IDispatch; safecall;
    function Get_Ativa: WordBool; safecall;
    procedure FinalizarTudo(CodClasseNaoFinalizar: Integer); safecall;
    function Get_Banners: IBanners; safecall;
    function InicializarBanners: Integer; safecall;
    procedure FinalizarBanners; safecall;
    function Get_TiposBanner: ITiposBanner; safecall;
    function InicializarTiposBanner: Integer; safecall;
    procedure FinalizarTiposBanner; safecall;
    function Get_TiposPagina: ITiposPagina; safecall;
    function InicializarTiposPagina: Integer; safecall;
    procedure FinalizarTiposPagina; safecall;
    function Get_LayoutsPagina: ILayoutsPagina; safecall;
    function InicializarLayoutsPagina: Integer; safecall;
    procedure FinalizarLayoutsPagina; safecall;
    function Get_GruposPaginas: IGruposPaginas; safecall;
    function InicializarGruposPaginas: Integer; safecall;
    procedure FinalizarGruposPaginas; safecall;
    function Get_BannersDefault: IBannersDefault; safecall;
    function InicializarBannersDefault: Integer; safecall;
    procedure FinalizarBannersDefault; safecall;
    function Get_Paginas: IPaginas; safecall;
    function InicializarPaginas: Integer; safecall;
    procedure FinalizarPaginas; safecall;
    function Get_TiposTarget: ITiposTarget; safecall;
    function InicializarTiposTarget: Integer; safecall;
    procedure FinalizarTiposTarget; safecall;
    function Get_Anunciantes: IAnunciantes; safecall;
    function InicializarAnunciantes: Integer; safecall;
    procedure FinalizarAnunciantes; safecall;
    function Get_Programas: IProgramas; safecall;
    function InicializarProgramas: Integer; safecall;
    procedure FinalizarProgramas; safecall;
    function Get_ResultadosAnuncio: IResultadosAnuncio; safecall;
    function InicializarResultadosAnuncio: Integer; safecall;
    procedure FinalizarResultadosAnuncio; safecall;
    procedure Finalizar; safecall;
    function BuscarTextoMensagem(Codigo: Integer): WideString; safecall;
    procedure FinalizarAcesso; safecall;
    function Get_Acesso: IAcesso; safecall;
    function BuscarTipoMensagem(Codigo: Integer): Integer; safecall;
    function Get_Pessoas: IPessoas; safecall;
    function InicializarPessoas: Integer; safecall;
    procedure FinalizarPessoas; safecall;
    function Get_Papeis: IPapeis; safecall;
    function InicializarPapeis: Integer; safecall;
    procedure FinalizarPapeis; safecall;
    function Get_Usuarios: IUsuarios; safecall;
    function InicializarUsuarios: Integer; safecall;
    procedure FinalizarUsuarios; safecall;
    function InicializarComunicados: Integer; safecall;
    procedure FinalizarComunicados; safecall;
    function Get_Comunicados: IComunicados; safecall;
    function Get_Bloqueios: IBloqueios; safecall;
    function Get_Perfis: IPerfis; safecall;
    function InicializarBloqueios: Integer; safecall;
    function InicializarPerfis: Integer; safecall;
    procedure FinalizarBloqueios; safecall;
    procedure FinalizarPerfis; safecall;
    function Get_AcessoAssociacaoProdutor: IAcessoAssociacaoProdutor; safecall;
    function Get_AcessoTecnicoProdutor: IAcessoTecnicoProdutor; safecall;
    function InicializarAcessoTecnicoProdutor: Integer; safecall;
    procedure FinalizarAcessoAssociacaoProdutor; safecall;
    procedure FinalizarAcessoTecnicoProdutor; safecall;
    function InicializarAcessoAssociacaoProdutor: Integer; safecall;
    procedure LimparMensagens; safecall;
    function Get_MotivosBloqueio: IMotivosBloqueio; safecall;
    function InicializarMotivosBloqueio: Integer; safecall;
    procedure FinalizarMotivosBloqueio; safecall;
    function Get_Paises: IPaises; safecall;
    function InicializarPaises: Integer; safecall;
    procedure FinalizarPaises; safecall;
    function Get_CodigosSisbov: ICodigosSisbov; safecall;
    procedure FinalizarCodigosSisbov; safecall;
    function InicializarCodigosSisbov: Integer; safecall;
    function Get_Estados: IEstados; safecall;
    function InicializarEstados: Integer; safecall;
    procedure FinalizarEstados; safecall;
    function Get_MicroRegioes: IMicroRegioes; safecall;
    function InicializarMicroRegioes: Integer; safecall;
    procedure FinalizarMicroRegioes; safecall;
    function Get_Racas: IRacas; safecall;
    function InicializarRacas: Integer; safecall;
    procedure FinalizarRacas; safecall;
    function Get_Pelagens: IPelagens; safecall;
    function InicializarPelagens: Integer; safecall;
    procedure FinalizarPelagens; safecall;
    function Get_Locais: ILocais; safecall;
    function InicializarLocais: Integer; safecall;
    procedure FinalizarLocais; safecall;
    function Get_TiposOrigem: ITiposOrigem; safecall;
    function InicializarTiposOrigem: Integer; safecall;
    procedure FinalizarTiposOrigem; safecall;
    function Get_Fazendas: IFazendas; safecall;
    function InicializarFazendas: Integer; safecall;
    procedure FinalizarFazendas; safecall;
    function Get_RegimesAlimentares: IRegimesAlimentares; safecall;
    function InicializarRegimesAlimentares: Integer; safecall;
    procedure FinalizarRegimesAlimentares; safecall;
    function Get_AssociacoesRaca: IAssociacoesRaca; safecall;
    function InicializarAssociacoesRaca: Integer; safecall;
    procedure FinalizarAssociacoesRaca; safecall;
    function Get_GrausSangue: IGrausSangue; safecall;
    function InicializarGrausSangue: Integer; safecall;
    procedure FinalizarGrausSangue; safecall;
    function Get_TiposIdentificador: ITiposIdentificador; safecall;
    function InicializarTiposIdentificador: Integer; safecall;
    procedure FinalizarTiposIdentificador; safecall;
    function Get_CategoriasAnimal: ICategoriasAnimal; safecall;
    function InicializarCategoriasAnimal: Integer; safecall;
    procedure FinalizarCategoriasAnimal; safecall;
    function Get_TiposFonteAgua: TiposFonteAgua; safecall;
    function InicializarTiposFonteAgua: Integer; safecall;
    procedure FinalizarTiposFonteAgua; safecall;
    function Get_Animais: IAnimais; safecall;
    function InicializarAnimais: Integer; safecall;
    procedure FinalizarAnimais; safecall;
    function Get_Lotes: ILotes; safecall;
    function InicializarLotes: Integer; safecall;
    procedure FinalizarLotes; safecall;
    function Get_Localidades: ILocalidades; safecall;
    function InicializarLocalidades: Integer; safecall;
    procedure FinalizarLocalidades; safecall;
    function InicializarPapeisSecundarios: Integer; safecall;
    procedure FinalizarPapeisSecundarios; safecall;
    function Get_PapeisSecundarios: IPapeisSecundarios; safecall;
    function InicializarPessoasSecundarias: Integer; safecall;
    procedure FinalizarPessoasSecundarias; safecall;
    function Get_PessoasSecundarias: IPessoasSecundarias; safecall;
    function Get_OpcoesEnvioComunicado: IOpcoesEnvioComunicado; safecall;
    function InicializarOpcoesEnvioComunicado: Integer; safecall;
    procedure FinalizarOpcoesEnvioComunicado; safecall;
    function Get_TiposContato: ITiposContato; safecall;
    function InicializarTiposContato: Integer; safecall;
    procedure FinalizarTiposContato; safecall;
    function Get_TiposEndereco: ITiposEndereco; safecall;
    procedure FinalizarTiposEndereco; safecall;
    function InicializarTiposEndereco: Integer; safecall;
    function Get_PropriedadesRurais: IPropriedadesRurais; safecall;
    function InicializarPropriedadesRurais: Integer; safecall;
    procedure FinalizarPropriedadesRurais; safecall;
    function Get_Aptidoes: IAptidoes; safecall;
    function InicializarAptidoes: Integer; safecall;
    procedure FinalizarAptidoes; safecall;
    function Get_Especies: IEspecies; safecall;
    function InicializarEspecies: Integer; safecall;
    procedure FinalizarEspecies; safecall;
    function Get_TiposMorte: ITiposMorte; safecall;
    function InicializarTiposMorte: Integer; safecall;
    procedure FinalizarTiposMorte; safecall;
    function Get_CausasMorte: ICausasMorte; safecall;
    function InicializarCausasMorte: Integer; safecall;
    procedure FinalizarCausasMorte; safecall;
    function InicializarGrausInstrucao: Integer; safecall;
    procedure FinalizarGrausInstrucao; safecall;
    function Get_GrausInstrucao: IGrausInstrucao; safecall;
    function Get_PosicoesIdentificador: IPosicoesIdentificador; safecall;
    function InicializarPosicoesIdentificador: Integer; safecall;
    procedure FinalizarPosicoesIdentificador; safecall;
    function Get_TiposLugar: ITiposLugar; safecall;
    function InicializarTiposLugar: Integer; safecall;
    procedure FinalizarTiposLugar; safecall;
    function Get_SituacoesSisBov: ISituacoesSisBov; safecall;
    function InicializarSituacoesSisBov: Integer; safecall;
    procedure FinalizarSituacoesSisBov; safecall;
    function Get_PessoasContatos: IPessoasContatos; safecall;
    procedure FinalizarPessoasContatos; safecall;
    function InicializarPessoasContatos: Integer; safecall;
    function AdicionarMensagem(CodMensagem: Integer): Integer; safecall;
    function Get_GrandezasResumo: IGrandezasResumo; safecall;
    function InicializarGrandezasResumo: Integer; safecall;
    procedure FinalizarGrandezasResumo; safecall;
    function Get_GruposEvento: IGruposEvento; safecall;
    function InicializarGruposEvento: Integer; safecall;
    procedure FinalizarGruposEvento; safecall;
    function Get_TiposEvento: TiposEvento; safecall;
    function InicializarTiposEvento: Integer; safecall;
    procedure FinalizarTiposEvento; safecall;
    function Get_UnidadesMedida: IUnidadesMedida; safecall;
    function InicializarUnidadesMedida: Integer; safecall;
    procedure FinalizarUnidadesMedida; safecall;
    function InicializarTiposInsumo: Integer; safecall;
    function Get_TiposInsumo: ITiposInsumo; safecall;
    procedure FinalizarTiposInsumo; safecall;
    function InicializarSubTiposInsumo: Integer; safecall;
    function Get_SubTiposInsumo: ISubTiposInsumo; safecall;
    procedure FinalizarSubTiposInsumo; safecall;
    function Get_FabricantesInsumo: IFabricantesInsumo; safecall;
    function InicializarFabricantesInsumo: Integer; safecall;
    procedure FinalizarFabricantesInsumo; safecall;
    function Get_Eventos: IEventos; safecall;
    function InicializarEventos: Integer; safecall;
    procedure FinalizarEventos; safecall;
    function Get_MudancasCategoriaAnimal: IMudancasCategoriaAnimal; safecall;
    function InicializarMudancasCategoriaAnimal: Integer; safecall;
    procedure FinalizarMudancasCategoriaAnimal; safecall;
    function Get_Insumos: IInsumos; safecall;
    function InicializarInsumos: Integer; safecall;
    procedure FinalizarInsumos; safecall;
    function InicializarEntradasInsumo: Integer; safecall;
    function Get_EntradasInsumo: IEntradasInsumo; safecall;
    procedure FinalizarEntradasInsumo; safecall;
    function Get_Relatorios: IRelatorios; safecall;
    function InicializarRelatorios: Integer; safecall;
    procedure FinalizarRelatorios; safecall;
    function Get_LargurasLinhaRelatorio: ILargurasLinhaRelatorio; safecall;
    function InicializarLargurasLinhaRelatorio: Integer; safecall;
    procedure FinalizarLargurasLinhaRelatorio; safecall;
    function InicializarOrientacoes: Integer; safecall;
    function Get_Orientacoes: IOrientacoes; safecall;
    procedure FinalizarOrientacoes; safecall;
    function Get_TamanhosFonte: ITamanhosFonte; safecall;
    function InicializarTamanhosFonte: Integer; safecall;
    procedure FinalizarTamanhosFonte; safecall;
    function ValorParametroSistema(CodParametro: Integer): WideString; safecall;
    function InicializarInterfaceSisbov: Integer; safecall;
    procedure FinalizarInterfaceSisbov; safecall;
    function Get_InterfaceSisbov: IInterfaceSisbov; safecall;
    function InicializarTiposArquivoSisbov: Integer; safecall;
    procedure FinalizarTiposArquivoSisbov; safecall;
    function Get_TiposArquivoSISBOV: ITiposArquivoSisBov; safecall;
    function InicializarTiposSubEventoSanitario: Integer; safecall;
    procedure FinalizarTiposSubEventoSanitario; safecall;
    function Get_TiposSubEventoSanitario: ITiposSubEventoSanitario; safecall;
    function Get_ReprodutoresMultiplos: IReprodutoresMultiplos; safecall;
    function InicializarReprodutoresMultiplos: Integer; safecall;
    procedure FinalizarReprodutoresMultiplos; safecall;
    function InicializarParametrosPesoAjustado: Integer; safecall;
    function Get_ParametrosPesoAjustado: IParametrosPesoAjustado; safecall;
    procedure FinalizarParametrosPesoAjustado; safecall;
    function Get_ModelosCertificado: IModelosCertificado; safecall;
    function InicializarModelosCertificado: Integer; safecall;
    procedure FinalizarModelosCertificado; safecall;
    function Get_Importacoes: IImportacoes; safecall;
    function InicializarImportacoes: Integer; safecall;
    procedure FinalizarImportacoes; safecall;
    function Get_TiposAgrupamentoRacas: ITiposAgrupamentoRacas; safecall;
    function InicializarTiposAgrupamentosRacas: Integer; safecall;
    procedure FinalizarTiposAgrupamentosRacas; safecall;
    function InicializarAgrupamentosRacas: Integer; safecall;
    procedure FinalizarAgrupamentosRacas; safecall;
    function Get_AgrupamentosRacas: IAgrupamentosRacas; safecall;
    function QtdTarefasAgendadas: Integer; safecall;
    function QtdTarefasEmAndamento: Integer; safecall;
    function Get_Tarefas: ITarefas; safecall;
    procedure FinalizarTarefas; safecall;
    function InicializarTarefas: Integer; safecall;
    function Get_SituacoesTarefa: ISituacoesTarefa; safecall;
    function InicializarSituacoesTarefa: Integer; safecall;
    procedure FinalizarSituacoesTarefa; safecall;
    function Get_EstoqueSemen: IEstoqueSemen; safecall;
    function InicializarEstoqueSemen: Integer; safecall;
    procedure FinalizarEstoqueSemen; safecall;
    function Get_TiposMovimentoEstoqueSemen: ITiposMovimentoEstoqueSemen; safecall;
    function InicializarTiposMovimentoEstoqueSemen: Integer; safecall;
    procedure FinalizarTiposMovimentoEstoqueSemen; safecall;
    function Get_CaminhoArquivosCertificadora: WideString; safecall;
    function Get_TiposAvaliacao: ITiposAvaliacao; safecall;
    function InicializarTiposAvaliacao: Integer; safecall;
    procedure FinalizarTiposAvaliacao; safecall;
    function Get_CaracteristicasAvaliacao: ICaracteristicasAvaliacao; safecall;
    function InicializarCaracteristicasAvaliacao: Integer; safecall;
    procedure FinalizarCaracteristicasAvaliacao; safecall;
    function Get_SituacoesCria: ISituacoesCria; safecall;
    function InicializarSituacoesCria: Integer; safecall;
    procedure FinalizarSituacoesCria; safecall;
    function Get_GrausDificuldade: IGrausDificuldade; safecall;
    function InicializarGrausDificuldade: Integer; safecall;
    procedure FinalizarGrausDificuldade; safecall;
    function Get_MotivosDescarte: IMotivosDescarte; safecall;
    function InicializarMotivosDescarte: Integer; safecall;
    procedure FinalizarMotivosDescarte; safecall;
    function Get_ImportacoesSISBOV: IImportacoesSISBOV; safecall;
    function InicializarImportacoesSISBOV: Integer; safecall;
    procedure FinalizarImportacoesSISBOV; safecall;
    function Get_ImportacoesDadoGeral: IImportacoesDadoGeral; safecall;
    function InicializarImportacoesDadoGeral: Integer; safecall;
    procedure FinalizarImportacoesDadoGeral; safecall;
    function Get_TiposOrigemArqImport: ITiposOrigemArqImport; safecall;
    procedure FinalizarTiposOrigemArqImport; safecall;
    function InicializarTiposOrigemArqImport: Integer; safecall;
    function Get_RegimesPosseUso: IRegimesPosseUso; safecall;
    function InicializarRegimesPosseUso: Integer; safecall;
    procedure FinalizarRegimesPosseUso; safecall;
    function Get_ArquivosFTPEnvio: IArquivosFTPEnvio; safecall;
    function InicializarArquivosFTPEnvio: Integer; safecall;
    procedure FinalizarArquivosFTPEnvio; safecall;
    function Get_OcorrenciasSistema: IOcorrenciasSistema; safecall;
    procedure FinalizarOcorrenciasSistema; safecall;
    function InicializarOcorrenciasSistema: Integer; safecall;

    function Get_FormasPagamentoIdentificador: IFormasPagamentoIdentificador; safecall;
    procedure FinalizarFormasPagamentoIdentificador; safecall;
    function InicializarFormasPagamentoIdentificador: Integer; safecall;
    function Get_FormasPagamentoOS: IFormasPagamentoOS; safecall;
    procedure FinalizarFormasPagamentoOS; safecall;
    function InicializarFormasPagamentoOS: Integer; safecall;
    function Get_FabricantesIdentificador: IFabricantesIdentificador; safecall;
    procedure FinalizarFabricantesIdentificador; safecall;
    function InicializarFabricantesIdentificador: Integer; safecall;
    function Get_IdentificacoesDuplas: IIdentificacoesDuplas; safecall;
    procedure FinalizarIdentificacoesDuplas; safecall;
    function InicializarIdentificacoesDuplas: Integer; safecall;
    function Get_ProdutosAcessorios: IProdutosAcessorios; safecall;
    procedure FinalizarProdutosAcessorios; safecall;
    function InicializarProdutosAcessorios: Integer; safecall;
    function Get_SituacoesOS: ISituacoesOS; safecall;
    procedure FinalizarSituacoesOS; safecall;
    function InicializarSituacoesOS: Integer; safecall;
    function Get_ArquivosRemessaPedido: IArquivosRemessaPedido; safecall;
    procedure FinalizarArquivosRemessaPedido; safecall;
    function InicializarArquivosRemessaPedido: Integer; safecall;
    function Get_OrdensServico: IOrdensServico; safecall;
    function InicializarOrdensServico: Integer; safecall;
    procedure FinalizarOrdensServico; safecall;
    function Get_ArquivosFTPRetorno: IArquivosFTPRetorno; safecall;
    function InicializarArquivosFTPRetorno: Integer; safecall;
    procedure FinalizarArquivosFTPRetorno; safecall;

    function Get_Enderecos: IEnderecos; safecall;
    function InicializarEnderecos: Integer; safecall;
    procedure FinalizarEnderecos; safecall;

    function Get_RotinasFTPRetorno: IRotinasFTPRetorno; safecall;
    function InicializarRotinasFTPRetorno: Integer; safecall;
    procedure FinalizarRotinasFTPRetorno; safecall;
    function Get_EmailsEnvio: IEmailsEnvio; safecall;
    function InicializarEmailsEnvio: Integer; safecall;
    procedure FinalizarEmailsEnvio; safecall;
    function Get_SituacoesCodigoSISBOV: ISituacoesCodigoSISBOV; safecall;
    function InicializarSituacoesCodigoSISBOV: Integer; safecall;
    procedure FinalizarSituacoesCodigoSISBOV; safecall;
    function Get_SituacoesEmail: ISituacoesEmail; safecall;
    function Get_TiposEmail: ITiposEmail; safecall;
    function InicializarSituacoesEmail: Integer; safecall;
    function InicializarTiposEmail: Integer; safecall;
    procedure FinalizarSituacoesEmail; safecall;
    procedure FinalizarTiposEmail; safecall;
    function Get_SituacoesFTP: ISituacoesFTP; safecall;
    function InicializarSituacoesFTP: Integer; safecall;
    procedure FinalizarSituacoesFTP; safecall;
    function InicializarTiposMensagem: Integer; safecall;
    procedure FinalizarTiposMensagem; safecall;
    function Get_TiposMensagem: ITiposMensagem; safecall;
    function Get_RotinasFTPEnvio: IRotinasFTPEnvio; safecall;
    function InicializarRotinasFTPEnvio: Integer; safecall;
    procedure FinalizarRotinasFTPEnvio; safecall;
    function Get_Aplicativos: IAplicativos; safecall;
    function InicializarAplicativos: Integer; safecall;
    procedure FinalizarAplicativos; safecall;
    function Get_ImportacoesFabricante: IImportacoesFabricante; safecall;
    function InicializarImportacoesFabricante: Integer; safecall;
    procedure FinalizarImportacoesFabricantes; safecall;
    function Get_SituacoesArqImport: ISituacoesArqImport; safecall;
    function InicializarSituacoesArqImport: Integer; safecall;
    procedure FinalizarSituacoesArqImport; safecall;
    function InicializarMenus: Integer; safecall;
    procedure FinalizarMenus; safecall;
    function Get_Menus: IMenus; safecall;
    function ImportarCargaInicial(CodTipoArquivo: Integer; const NomeCompletoArquivo: WideString): Integer; safecall;
    function Get_BoletosBancario: IBoletosBancario; safecall;
    function InicializarBoletosBancario: Integer; safecall;
    procedure FinalizarBoletosBancario; safecall;
    function InicializarIdentificacoesBancarias: Integer; safecall;
    procedure FinalizarIdentificacoesBancarias; safecall;
    function Get_IdentificacoesBancarias: IIdentificacoesBancarias; safecall;
    function InicializarDownloads: Integer; safecall;
    procedure FinalizarDownloads; safecall;
    function Get_Downloads: IDownloads; safecall;
    function Get_TiposPropriedades: ITiposPropriedades; safecall;
    function InicializarTiposPropriedades: Integer; safecall;
    procedure FinalizarTiposPropriedades; safecall;
    function InicializarInventariosAnimais: Integer; safecall;
    procedure FinalizarInventariosAnimais; safecall;
    function Get_InventariosAnimais: IInventariosAnimais; safecall;
    function InicializarInventariosCodigosSisbov: Integer; safecall;
    procedure FinalizarInventariosCodigosSisbov; safecall;
    function Get_InventariosCodigosSisbov: IInventariosCodigosSisbov; safecall;
    procedure AdicionarMensagemCustomizada(Codigo: Integer; const Texto, Classe, Metodo: WideString; Tipo: Integer); safecall;
    function Get_TmpAplicaEvento: ITmpAplicaEvento; safecall;
    procedure FinalizarTmpAplicaEvento; safecall;
    function InicializarTmpAplicaEvento: Integer; safecall;
    function inicializarTipoPropriedades:integer;safecall;
    procedure FinalizarTipoPropriedades;safecall;
    function Get_TipoPropriedades:ITipoPropriedades;safecall;
    function Get_SolicitacaoReimpressao: ISolicitacaoReimpressao; safecall;
    function InicializarSolicitacaoReimpressao: Integer; safecall;
    procedure FinalizarSolicitacaoReimpressao; safecall;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure LogToFile(const FileName, LogMessage: string);
  end;

implementation

uses ComServ, uIntCargaInicial;

procedure TSessao.AfterConstruction;
begin
  inherited;
  FAtiva := False;
  FCaminhoArquivosCertificadora := '';
end;

procedure TSessao.BeforeDestruction;
begin
  FAtiva := False;
  FCaminhoArquivosCertificadora := '';
  inherited;
End;

procedure TSessao.FinalizarTudo(CodClasseNaoFinalizar: Integer);
begin
  // Limpa coleção de mensagens
  FMensagens.Clear;

// Finaliza qualquer objeto que tenha sido inicializado exceto o objeto cuja
// classe possua o código determinado pelo parâmetro CodClasseNaoFinalizar
// FinalizarAcesso;
  FinalizarBanners;
  FinalizarTiposBanner;
  FinalizarTiposPagina;
  FinalizarLayoutsPagina;
  FinalizarGruposPaginas;
  FinalizarBannersDefault;
  FinalizarPaginas;
  FinalizarTiposTarget;
  FinalizarAnunciantes;
  FinalizarProgramas;
  FinalizarResultadosAnuncio;
  FinalizarPessoas;
  FinalizarPapeis;
  FinalizarUsuarios;
  FinalizarComunicados;
  FinalizarBloqueios;
  FinalizarPerfis;
  FinalizarAcessoTecnicoProdutor;
  FinalizarAcessoAssociacaoProdutor;
  FinalizarMotivosBloqueio;
  FinalizarPaises;
  If CodClasseNaoFinalizar <> 23 Then Begin
    FinalizarCodigosSisbov;
  End;
  FinalizarEstados;
  FinalizarMicroRegioes;
  FinalizarRacas;
  FinalizarPelagens;
  FinalizarLocais;
  FinalizarTiposOrigem;
  FinalizarFazendas;
  FinalizarRegimesAlimentares;
  FinalizarAssociacoesRaca;
  FinalizarGrausSangue;
  FinalizarTiposIdentificador;
  FinalizarCategoriasAnimal;
  FinalizarTiposFonteAgua;
  If CodClasseNaoFinalizar <> 45 Then Begin
    FinalizarAnimais;
  End;
  FinalizarLotes;
  FinalizarLocalidades;
  FinalizarPapeisSecundarios;
  FinalizarPessoasSecundarias;
  FinalizarOpcoesEnvioComunicado;
  FinalizarTiposContato;
  FinalizarTiposEndereco;
  FinalizarPropriedadesRurais;
  FinalizarAptidoes;
  FinalizarEspecies;
  FinalizarTiposMorte;
  FinalizarCausasMorte;
  FinalizarGrausInstrucao;
  FinalizarPosicoesIdentificador;
  FinalizarTiposLugar;
  FinalizarSituacoesSisBov;
  FinalizarPessoasContatos;
  FinalizarGrandezasResumo;
  FinalizarGruposEvento;
  FinalizarTiposEvento;
  FinalizarUnidadesMedida;
  FinalizarTiposInsumo;
  FinalizarSubTiposInsumo;
  FinalizarFabricantesInsumo;
  FinalizarEventos;
  FinalizarMudancasCategoriaAnimal;
  FinalizarInsumos;
  FinalizarEntradasInsumo;
  FinalizarRelatorios;
  FinalizarOrientacoes;
  FinalizarTamanhosFonte;
  FinalizarLargurasLinhaRelatorio;
  FinalizarInterfaceSisbov;
  FinalizarTiposArquivoSisbov;
  FinalizarTiposSubEventoSanitario;
  FinalizarReprodutoresMultiplos;
  FinalizarParametrosPesoAjustado;
  FinalizarModelosCertificado;
  FinalizarImportacoes;
  FinalizarTiposAgrupamentosRacas;
  FinalizarAgrupamentosRacas;
  FinalizarTarefas;
  FinalizarSituacoesTarefa;
  FinalizarEstoqueSemen;
  FinalizarTiposMovimentoEstoqueSemen;
  FinalizarTiposAvaliacao;
  FinalizarCaracteristicasAvaliacao;
  FinalizarGrausDificuldade;
  FinalizarSituacoesCria;
  FinalizarMotivosDescarte;
  FinalizarImportacoesSISBOV;
  FinalizarImportacoesDadoGeral;
  FinalizarTiposOrigemArqImport;
  FinalizarRegimesPosseUso;
  FinalizarArquivosFTPEnvio;
  FinalizarFormasPagamentoIdentificador;
  FinalizarFormasPagamentoOS;
  FinalizarFabricantesIdentificador;
  FinalizarIdentificacoesDuplas;
  FinalizarProdutosAcessorios;
  FinalizarSituacoesOS;
  FinalizarArquivosRemessaPedido;
  FinalizarArquivosFTPRetorno;
  FinalizarEnderecos;
  FinalizarRotinasFTPRetorno;
  FinalizarEmailsEnvio;
  FinalizarSituacoesCodigoSISBOV;
  FinalizarTiposEmail;
  FinalizarSituacoesEmail;
  FinalizarSituacoesFTP;
  FinalizarTiposMensagem;
  FinalizarRotinasFTPRetorno;
  FinalizarRotinasFTPEnvio;
  FinalizarAplicativos;
  FinalizarOrdensServico;
  FinalizarImportacoesFabricantes;
  FinalizarSituacoesArqImport;
  FinalizarMenus;
  FinalizarBoletosBancario;
  FinalizarIdentificacoesBancarias;
  FinalizarDownloads;
  FinalizarInventariosAnimais;
  FinalizarInventariosCodigosSisbov;
  FinalizarTmpAplicaEvento;

  // Verifica a existência de alguma transação aberta e realiza o encerramento
  if Assigned(FConexao) then begin
    if (FConexao.SQLConnection.Connected) then begin
      FConexao.Rollback;
    end;
  end;
end;




// Função para gravar logs em arquivo
procedure TSessao.LogToFile(const FileName, LogMessage: string);
var
  LogFile: TextFile;
begin
  AssignFile(LogFile, FileName);
  try
    if FileExists(FileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);
    Writeln(LogFile, DateTimeToStr(Now) + ': ' + LogMessage);
  finally
    CloseFile(LogFile);
  end;
end;

function TSessao.Inicializar(const IdCertificadora, NomUsuario, TxtSenha: WideString): Integer;
var
  FIni : TIniFile;
  Ret : TConectar;
  GerarLog: Boolean;
  X, NivelLog, LockTimeOut, QueryGovernorCostLimit: Integer;
  Section, ServerName, UserName, Password, Banco: String;
begin

  // Faz o Debug para qual arquivo INI a OCX vai utilizar
  LogToFile(ARQUIVO_DEBUG, 'Arquivo Ini de Configuração: ' + ARQUIVO_INI);

  // Verifica se a Conexão está ativa
  If FAtiva Then Begin
    Result := 0;
    Exit;
  End;

  // Define o resultado para -1 para gerar erro
  Result := -1;

  // Cria objetos de conexão e mensagens se ainda não foram criados
  If FConexao = nil Then Begin
    FConexao := TConexao.Create;
  End Else Begin
    FConexao.SQLConnection.Close;
  End;
  If FMensagens = nil Then Begin
    FMensagens := TIntMensagens.Create(TIntMensagem);
  End;

  // Limpa coleção de mensagens
  FMensagens.Clear;

  // Abre arquivo ini
  FIni := TIniFile.Create(ARQUIVO_INI);

  // Debug da Função Inicializar
  LogToFile(ARQUIVO_DEBUG, '[TSessao.Inicializar] IdCertificadora: ' + IdCertificadora + ' | Usuario: ' + NomUsuario + ' | Senha: ' + TxtSenha);
  
  try

    // Alimenta a variavel 'Section' para verificação com a certificadora recebida do ASP
    Section := IdCertificadora;

    // Alimenta a variavel 'FCaminhoArqivosCertificadora' com o IdCertificadora
    FCaminhoArquivosCertificadora := IdCertificadora;

    try

      // Verifica a Chave de Sessão para Certificadora
      If (Not FIni.SectionExists(Section)) then begin
        // Registra no Debug a falha de identificação da Sessão da Certificadora no .ini
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar a Sessão: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;
      
      // Verifica os valores de 'SERVIDOR' do Banco para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'SERVIDOR')) then begin
        // Registra no Debug a falha de identificação do valor SERVIDOR para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de SERVIDOR em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'BANCO' do Banco para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'BANCO')) then begin
        // Registra no Debug a falha de identificação do valor BANCO para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de BANCO em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'USUARIO_V' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'USUARIO_V')) then begin
        // Registra no Debug a falha de identificação do valor USUARIO_V para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de USUARIO_V em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'SENHA_V' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'SENHA_V')) then begin
        // Registra no Debug a falha de identificação do valor SENHA_V para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de SENHA_V em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'USUARIO_S' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'USUARIO_S')) then begin
        // Registra no Debug a falha de identificação do valor USUARIO_S para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de USUARIO_S em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'SENHA_S' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'SENHA_S')) then begin
        // Registra no Debug a falha de identificação do valor SENHA_S para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de SENHA_S em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'GERAR_LOG' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'GERAR_LOG')) then begin
        // Registra no Debug a falha de identificação do valor GERAR_LOG para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de GERAR_LOG em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);
        
        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'ARQUIVO_LOG' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'ARQUIVO_LOG')) then begin
        // Registra no Debug a falha de identificação do valor ARQUIVO_LOG para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de ARQUIVO_LOG em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'NIVEL_LOG' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'NIVEL_LOG')) then begin
        // Registra no Debug a falha de identificação do valor NIVEL_LOG para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de NIVEL_LOG em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'CAMINHO_ARQUIVOS' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'CAMINHO_ARQUIVOS')) then begin
        // Caminho de Arquivos não existe no (ARQUIVO_INI)
        // Registra no Debug a falha de identificação do valor CAMINHO_ARQUIVOS
        LogToFile(ARQUIVO_DEBUG, 'Na Sessão: ' + Section + ' não há um valor definido para: CAMINHO_ARQUIVOS');

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'LOCK_TIMEOUT' para Certificadora no (ARQUIVO_INI).
      LockTimeOut := FIni.ReadInteger(IdCertificadora, 'LOCK_TIMEOUT', -1);
      // Caso o 'LockTimeOut' seja o padrão -1, o define para 90
      If LockTimeOut = -1 Then Begin
        LockTimeOut := 90;
        FIni.WriteInteger(IdCertificadora, 'LOCK_TIMEOUT', LockTimeOut);
      End;

      // Verifica os valores de 'QUERY_GOVERNOR_COST_LIMIT' para Certificadora no (ARQUIVO_INI).
      QueryGovernorCostLimit := FIni.ReadInteger(IdCertificadora, 'QUERY_GOVERNOR_COST_LIMIT', -1);
      // Caso o 'QueryGovernorConstLimit' seja o padrão de -1, o define para 90
      If QueryGovernorCostLimit = -1 Then Begin
        QueryGovernorCostLimit := 90;
        FIni.WriteInteger(IdCertificadora, 'QUERY_GOVERNOR_COST_LIMIT', QueryGovernorCostLimit);
      End;

      // Verifica os valores de 'PASTA_FTP_IMPORTACAO' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'PASTA_FTP_IMPORTACAO')) then begin
        // Registra no Debug a falha de identificação do valor PASTA_FTP_IMPORTACAO para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de PASTA_FTP_IMPORTACAO em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'USUARIO_SIS' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'USUARIO_SIS')) then begin
        // Registra no Debug a falha de identificação do valor USUARIO_SIS para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de USUARIO_SIS em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Verifica os valores de 'USUARIO_SIS' para Certificadora no (ARQUIVO_INI).
      If (Not FIni.ValueExists(Section, 'USUARIO_SIS')) then begin
        // Registra no Debug a falha de identificação do valor USUARIO_SIS para Sessão da Certificadora no (ARQUIVO_INI).
        LogToFile(ARQUIVO_DEBUG, 'Falha ao localizar o valor de USUARIO_SIS em: ' + Section);

        // Registra nas mensagens da OCX
        FMensagens.Adicionar(1, Self.ClassName, 'icializar', [Section]);

        // Interrompe o script
        Exit;
      End;

      // Janela para Debug
      // Alimenta as variaveis
      ServerName := Descriptografar(FIni.ReadString(Section, 'SERVIDOR', ''));
      UserName := Descriptografar(FIni.ReadString(Section, 'USUARIO_S', ''));
      Password := Descriptografar(FIni.ReadString(Section, 'SENHA_S', ''));
      Banco := Descriptografar(FIni.ReadString(Section, 'BANCO', ''));
      FCaminhoArquivosCertificadora := FIni.ReadString(Section, 'CAMINHO_ARQUIVOS', '');

      // Verifica se a variavel 'FCaminhoArquivosCertificadora' é vazia
      If FCaminhoArquivosCertificadora = '' Then Begin
        // Gera mensagem (não sei para que serve #brendown)
        FMensagens.Adicionar(1, Self.ClassName, 'Inicializar', [IdCertificadora]);
        Exit;
      End;

      // Garante que o caminho da Certificadora sempre vai terminar com uma \ no final
      If Copy(FCaminhoArquivosCertificadora, Length(FCaminhoArquivosCertificadora), 1) <> '\' Then Begin
        FCaminhoArquivosCertificadora := FCaminhoArquivosCertificadora + '\';
      End;

      // Alimenta 'FConexão' com o Caminho para os arquivos da certificadora
      FConexao.CaminhoArquivosCertificadora := FCaminhoArquivosCertificadora;

      // Verificar se as variaveis: 'ServerName' 'UserName' 'Password' 'Banco', estão sendo alimentadas antes da utilização pela FConexão.Conectar
      //LogToFile(ARQUIVO_DEBUG, 'ServerName: ' + ServerName);
      //LogToFile(ARQUIVO_DEBUG, 'UserName: ' + UserName);
      //LogToFile(ARQUIVO_DEBUG, 'Password: ' + Password);
      //LogToFile(ARQUIVO_DEBUG, 'Banco: ' + Banco);
      //LogToFile(ARQUIVO_DEBUG, 'CAMINHO_ARQUIVOS: ' + FCaminhoArquivosCertificadora);
      //LogToFile(ARQUIVO_DEBUG, 'LockTimeOut: ' + IntToStr(LockTimeOut));
      //LogToFile(ARQUIVO_DEBUG, 'QueryGovernorCostLimit: ' + IntToStr(QueryGovernorCostLimit));

      // Inicia a conexão com o banco de dados utilizando os dados obtidos no ARQUIVO_INI
      Ret := FConexao.Conectar(ServerName, UserName, Password, Banco, 'S_'+Trim(UpperCase(IdCertificadora+'_'+NomUsuario)), LockTimeOut, QueryGovernorCostLimit);

      // Verifica o status da conexão do Ret, se é diferente de '0'
      If Ret.Status <> 0 Then Begin

        // Caso o Status for:
        Case Ret.Status of

          // -1 | Erro de conexão com o banco de dados
          -1 : 
          Begin
            //FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', ['-1']);
            For X := 0 to Ret.Erros.Count - 1 do 
            Begin
              LogToFile(ARQUIVO_DEBUG, 'Erro de Conexão com o banco de dados [-1]: ' + Ret.Erros[X].Texto);
              FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', [Ret.Erros[X].Texto]);
              FMensagens.Adicionar('Erro ''%s'' durante a conexão com o servidor de banco de dados', 3, Self.ClassName, 'Inicializar', [Ret.Erros[X].Texto]);
            End;
          End;

          // Erro de acesso a Database Padrão
          -2 : 
            Begin
              //FMensagens.Adicionar(12, Self.ClassName, 'Inicializar', ['-2']);
              For X := 0 to Ret.Erros.Count - 1 do 
              Begin
                LogToFile(ARQUIVO_DEBUG, 'Erro de Conexão com o banco de dados padrão [-2]: ' + Ret.Erros[X].Texto);
                FMensagens.Adicionar(12, Self.ClassName, 'Inicializar', [Ret.Erros[X].Texto]);
              End;
            End;
          End;
        Exit;
      End 
      Else 
      Begin
        GerarLog := FIni.ReadBool(IdCertificadora, 'GERAR_LOG', True);
        NivelLog := FIni.ReadInteger(IdCertificadora, 'NIVEL_LOG', 3);
      End;

      // Inicializa Objeto Mensagens
      If FMensagens.Inicializar(FConexao,
                                GerarLog,
                                FIni.ReadString(IdCertificadora, 'ARQUIVO_LOG', ''),
                                NivelLog) < 0 Then Begin
        FMensagens.Adicionar(8, Self.ClassName, 'Inicializar', ['FMensagens']);
        Result := -1;
        Exit;
      End;

      FAtiva := True;

      Result := InicializarAcesso(NomUsuario, TxtSenha);
      If Result < 0 Then Begin
        FConexao.SQLConnection.Close;
        FAtiva := False;
      End;
    Except
      On E: Exception do Begin
        FMensagens.Adicionar(11, Self.ClassName, 'Inicializar', [E.Message]);
      End;
    End;
  Finally
    FIni.Free;
  End;
end;

function TSessao.Mensagens: IDispatch;
var
  Items: TMensagens;
  X : Integer;
begin
  Items := TMensagens.Create;
  For X := 0 to FMensagens.Count - 1 do Begin
    Items.Adicionar(FMensagens[X].Codigo,
                    FMensagens[X].Texto,
                    FMensagens[X].Classe,
                    FMensagens[X].Metodo,
                    FMensagens[X].Tipo);
  End;
  Result := Items as IDispatch;
end;

function TSessao.Get_Ativa: WordBool;
begin
  Result := FAtiva;
end;

function TSessao.Get_Banners: IBanners;
begin
  Result := FBanners;
end;

function TSessao.InicializarBanners: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarBanners', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarBanners;
  FBanners := TBanners.Create;
  FBanners.ObjAddRef;
  Result := FBanners.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarBanners;
begin
  If FBanners <> nil Then Begin
    FBanners.ObjRelease;
    FBanners := nil;
  End;
end;

function TSessao.Get_TiposBanner: ITiposBanner;
begin
  Result := FTiposBanner;
end;

function TSessao.InicializarTiposBanner: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposBanner', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposBanner;
  FTiposBanner := TTiposBanner.Create;
  FTiposBanner.ObjAddRef;
  Result := FTiposBanner.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposBanner;
begin
  If FTiposBanner <> nil Then Begin
    FTiposBanner.ObjRelease;
    FTiposBanner := nil;
  End;
end;

function TSessao.Get_TiposPagina: ITiposPagina;
begin
  Result := FTiposPagina;
end;

function TSessao.InicializarTiposPagina: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposPagina', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposPagina;
  FTiposPagina := TTiposPagina.Create;
  FTiposPagina.ObjAddRef;
  Result := FTiposPagina.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposPagina;
begin
  If FTiposPagina <> nil Then Begin
    FTiposPagina.ObjRelease;
    FTiposPagina := nil;
  End;
end;

function TSessao.Get_LayoutsPagina: ILayoutsPagina;
begin
  Result := FLayoutsPagina;
end;

function TSessao.InicializarLayoutsPagina: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarLayoutsPagina', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarLayoutsPagina;
  FLayoutsPagina := TLayoutsPagina.Create;
  FLayoutsPagina.ObjAddRef;
  Result := FLayoutsPagina.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarLayoutsPagina;
begin
  If FLayoutsPagina <> nil Then Begin
    FLayoutsPagina.ObjRelease;
    FLayoutsPagina := nil;
  End;
end;

function TSessao.Get_GruposPaginas: IGruposPaginas;
begin
  Result := FGruposPaginas;
end;

function TSessao.InicializarGruposPaginas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGruposPaginas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarGruposPaginas;
  FGruposPaginas := TGruposPaginas.Create;
  FGruposPaginas.ObjAddRef;
  Result := FGruposPaginas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGruposPaginas;
begin
  If FGruposPaginas <> nil Then Begin
    FGruposPaginas.ObjRelease;
    FGruposPaginas := nil;
  End;
end;

function TSessao.Get_BannersDefault: IBannersDefault;
begin
  Result := FBannersDefault;
end;

function TSessao.InicializarBannersDefault: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarBannersDefault', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarBannersDefault;
  FBannersDefault := TBannersDefault.Create;
  FBannersDefault.ObjAddRef;
  Result := FBannersDefault.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarBannersDefault;
begin
  If FBannersDefault <> nil Then Begin
    FBannersDefault.ObjRelease;
    FBannersDefault := nil;
  End;
end;

function TSessao.Get_Paginas: IPaginas;
begin
  Result := FPaginas;
end;

function TSessao.InicializarPaginas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarInicializarPaginas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPaginas;
  FPaginas := TPaginas.Create;
  FPaginas.ObjAddRef;
  Result := FPaginas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPaginas;
begin
  If FPaginas <> nil Then Begin
    FPaginas.ObjRelease;
    FPaginas := nil;
  End;
end;

function TSessao.Get_TiposTarget: ITiposTarget;
begin
  Result := FTiposTarget;
end;

function TSessao.InicializarTiposTarget: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposTarget', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposTarget;
  FTiposTarget := TTiposTarget.Create;
  FTiposTarget.ObjAddRef;
  Result := FTiposTarget.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposTarget;
begin
  If FTiposTarget <> nil Then Begin
    FTiposTarget.ObjRelease;
    FTiposTarget := nil;
  End;
end;

function TSessao.Get_Anunciantes: IAnunciantes;
begin
  Result := FAnunciantes;
end;

function TSessao.InicializarAnunciantes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAnunciantes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAnunciantes;
  FAnunciantes := TAnunciantes.Create;
  FAnunciantes.ObjAddRef;
  Result := FAnunciantes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAnunciantes;
begin
  If FAnunciantes <> nil Then Begin
    FAnunciantes.ObjRelease;
    FAnunciantes := nil;
  End;
end;

function TSessao.Get_Programas: IProgramas;
begin
  Result := FProgramas;
end;

function TSessao.InicializarProgramas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarProgramas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarProgramas;
  FProgramas := TProgramas.Create;
  FProgramas.ObjAddRef;
  Result := FProgramas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarProgramas;
begin
  If FProgramas <> nil Then Begin
    FProgramas.ObjRelease;
    FProgramas := nil;
  End;
end;

function TSessao.Get_ResultadosAnuncio: IResultadosAnuncio;
begin
  Result := FResultadosAnuncio;
end;

function TSessao.InicializarResultadosAnuncio: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarResultadosAnuncio', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarResultadosAnuncio;
  FResultadosAnuncio := TResultadosAnuncio.Create;
  FResultadosAnuncio.ObjAddRef;
  Result := FResultadosAnuncio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarResultadosAnuncio;
begin
  If FResultadosAnuncio <> nil Then Begin
    FResultadosAnuncio.ObjRelease;
    FResultadosAnuncio := nil;
  End;
end;

function TSessao.BuscarSPID: Integer;
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select @@spid as SPID ');
{$ENDIF}
    Q.Open;
    Result := Q.FieldByName('SPID').AsInteger;
    Q.Close;
  Finally
    Q.Free;
  End;
end;

function TSessao.BuscarValorParametroSistema(Parametro: Integer): String;
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Q.SQL.Clear;
{$IFDEF MSSQL}
    Q.SQL.Add('select val_parametro_sistema');
    Q.SQL.Add('  from tab_parametro_sistema');
    Q.SQL.Add(' where cod_parametro_sistema = :cod_parametro_sistema');
{$ENDIF}
    Q.ParamByName('cod_parametro_sistema').AsInteger := Parametro;
    Q.Open;
    Result := Q.FieldByName('val_parametro_sistema').AsString;
    Q.Close;
  Finally
    Q.Free;
  End;
end;

procedure TSessao.LimparRelatoriosSessao;
var
  SR: TSearchRec;
  iAux: Integer;
  sPath, sArquivo: String;
  asListaArquivos: Array of String;
  dLimite: TDateTime;
begin
  if FAtiva then begin
    dLimite := now - StrToIntDef(BuscarValorParametroSistema(15), 0); // arq. com data infeior tb serão excluídos
    sArquivo := UpperCase(FConexao.NomUsuario) +
      '_' + IntToStr(BuscarSPID) + '_';
    sPath := FConexao.CaminhoArquivosCertificadora + BuscarValorParametroSistema(14);
    if (Length(sPath)=0) or (sPath[Length(sPath)]<>'\') then begin
      sPath := sPath + '\';
    end;
    if DirectoryExists(sPath) then begin
      if FindFirst(sPath+#42, faArchive, SR) = 0 then begin
        try
          if (Copy(UpperCase(SR.Name), 1, Length(sArquivo)) = sArquivo)
            or (FileDateToDateTime(SR.Time) < dLimite) then begin
            SetLength(asListaArquivos, Length(asListaArquivos)+1);
            asListaArquivos[Length(asListaArquivos)-1] := SR.Name;
          end;
          while FindNext(SR) = 0 do begin
            if (Copy(UpperCase(SR.Name), 1, Length(sArquivo)) = sArquivo)
              or (FileDateToDateTime(SR.Time) < dLimite) then begin
              SetLength(asListaArquivos, Length(asListaArquivos)+1);
              asListaArquivos[Length(asListaArquivos)-1] := SR.Name;
            end;
          end;
        finally
          FindClose(SR);
        end;
      end;
      {Limpa relatórios caso eles existam}
      if Length(asListaArquivos)>0 then begin
        for iAux := 0 to Length(asListaArquivos)-1 do begin
          sArquivo := sPath + asListaArquivos[iAux];
          DeleteFile(sArquivo);
        end;
      end;
    end;
  end;
end;

procedure TSessao.Finalizar;
begin
  FinalizarTudo(-1);
  FinalizarAcesso;
  LimparRelatoriosSessao;
  If FMensagens <> nil Then Begin
    FMensagens.Free;
    FMensagens := nil;
  End;
  If FConexao <> nil Then Begin
    FConexao.Free;
    FConexao := nil;
  End;
  FAtiva := False;
end;

function TSessao.BuscarTextoMensagem(Codigo: Integer): WideString;
begin
  Result := FMensagens.BuscarTextoMensagem(Codigo);
end;

function TSessao.InicializarAcesso(const NomUsuario,
  TxtSenha: WideString): Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAcesso', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAcesso;
  FAcesso := TAcesso.Create;
  FAcesso.ObjAddRef;
  Result := FAcesso.Inicializar(FConexao, FMensagens, NomUsuario, TxtSenha);
end;

procedure TSessao.FinalizarAcesso;
begin
  If FAcesso <> nil Then Begin
    FAcesso.ObjRelease;
    FAcesso := nil;
  End;
end;

function TSessao.Get_Acesso: IAcesso;
begin
  Result := FAcesso;
end;

function TSessao.BuscarTipoMensagem(Codigo: Integer): Integer;
begin
  Result := FMensagens.BuscarTipoMensagem(Codigo);
end;

function TSessao.Get_Pessoas: IPessoas;
begin
  Result := FPessoas;
end;

function TSessao.InicializarPessoas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPessoas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPessoas;
  FPessoas := TPessoas.Create;
  FPessoas.ObjAddRef;
  Result := FPessoas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPessoas;
begin
  If FPessoas <> nil Then Begin
    FPessoas.ObjRelease;
    FPessoas := nil;
  End;
end;

function TSessao.Get_Papeis: IPapeis;
begin
  Result := FPapeis;
end;

function TSessao.InicializarPapeis: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPapeis', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPapeis;
  FPapeis := TPapeis.Create;
  FPapeis.ObjAddRef;
  Result := FPapeis.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPapeis;
begin
  If FPapeis <> nil Then Begin
    FPapeis.ObjRelease;
    FPapeis := nil;
  End;
end;

function TSessao.Get_Usuarios: IUsuarios;
begin
  Result := FUsuarios;
end;

function TSessao.InicializarUsuarios: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarUsuarios', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarUsuarios;
  FUsuarios := TUsuarios.Create;
  FUsuarios.ObjAddRef;
  Result := FUsuarios.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarUsuarios;
begin
  If FUsuarios <> nil Then Begin
    FUsuarios.ObjRelease;
    FUsuarios := nil;
  End;
end;

function TSessao.InicializarComunicados: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarComunicados', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarComunicados;
  FComunicados := TComunicados.Create;
  FComunicados.ObjAddRef;
  Result := FComunicados.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarComunicados;
begin
  If FComunicados <> nil Then Begin
    FComunicados.ObjRelease;
    FComunicados := nil;
  End;
end;

function TSessao.Get_Comunicados: IComunicados;
begin
  Result := FComunicados;
end;

function TSessao.Get_Bloqueios: IBloqueios;
begin
  Result := FBloqueios;
end;

function TSessao.Get_Perfis: IPerfis;
begin
  Result := FPerfis;
end;

function TSessao.InicializarBloqueios: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarBloqueios', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarBloqueios;
  FBloqueios := TBloqueios.Create;
  FBloqueios.ObjAddRef;
  Result := FBloqueios.Inicializar(FConexao, FMensagens);
end;

function TSessao.InicializarPerfis: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPerfis', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPerfis;
  FPerfis := TPerfis.Create;
  FPerfis.ObjAddRef;
  Result := FPerfis.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarBloqueios;
begin
  If FBloqueios <> nil Then Begin
    FBloqueios.ObjRelease;
    FBloqueios := nil;
  End;
end;

procedure TSessao.FinalizarPerfis;
begin
  If FPerfis <> nil Then Begin
    FPerfis.ObjRelease;
    FPerfis := nil;
  End;
end;

function TSessao.Get_AcessoAssociacaoProdutor: IAcessoAssociacaoProdutor;
begin
  Result := FAcessoAssociacaoProdutor;
end;

function TSessao.Get_AcessoTecnicoProdutor: IAcessoTecnicoProdutor;
begin
  Result := FAcessoTecnicoProdutor;
end;

function TSessao.InicializarAcessoTecnicoProdutor: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAcessoTecnicoProdutor', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAcessoTecnicoProdutor;
  FAcessoTecnicoProdutor := TAcessoTecnicoProdutor.Create;
  FAcessoTecnicoProdutor.ObjAddRef;
  Result := FAcessoTecnicoProdutor.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAcessoAssociacaoProdutor;
begin
  If FAcessoAssociacaoProdutor <> nil Then Begin
    FAcessoAssociacaoProdutor.ObjRelease;
    FAcessoAssociacaoProdutor := nil;
  End;
end;

procedure TSessao.FinalizarAcessoTecnicoProdutor;
begin
  If FAcessoTecnicoProdutor <> nil Then Begin
    FAcessoTecnicoProdutor.ObjRelease;
    FAcessoTecnicoProdutor := nil;
  End;
end;

function TSessao.InicializarAcessoAssociacaoProdutor: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAcessoAssociacaoProdutor', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAcessoAssociacaoProdutor;
  FAcessoAssociacaoProdutor := TAcessoAssociacaoProdutor.Create;
  FAcessoAssociacaoProdutor.ObjAddRef;
  Result := FAcessoAssociacaoProdutor.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.LimparMensagens;
begin
  // Limpa coleção de mensagens
  FMensagens.Clear;
end;

function TSessao.Get_MotivosBloqueio: IMotivosBloqueio;
begin
  Result := FMotivosBloqueio;
end;

function TSessao.InicializarMotivosBloqueio: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarMotivosBloqueio', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarMotivosBloqueio;
  FMotivosBloqueio := TMotivosBloqueio.Create;
  FMotivosBloqueio.ObjAddRef;
  Result := FMotivosBloqueio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarMotivosBloqueio;
begin
  If FMotivosBloqueio <> nil Then Begin
    FMotivosBloqueio.ObjRelease;
    FMotivosBloqueio := nil;
  End;
end;

function TSessao.Get_Paises: IPaises;
begin
  Result := FPaises;
end;

function TSessao.InicializarPaises: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPaises', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPaises;
  FPaises := TPaises.Create;
  FPaises.ObjAddRef;
  Result := FPaises.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPaises;
begin
  If FPaises <> nil Then Begin
    FPaises.ObjRelease;
    FPaises := nil;
  End;
end;

function TSessao.Get_CodigosSisbov: ICodigosSisbov;
begin
  Result := FCodigosSisbov;
end;

procedure TSessao.FinalizarCodigosSisbov;
begin
  If FCodigosSisbov <> nil Then Begin
    FCodigosSisbov.ObjRelease;
    FCodigosSisbov := nil;
  End;
end;

function TSessao.InicializarCodigosSisbov: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarCodigosSisbov', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Não re-inicializa a classe se ela já estiver inicializada
  If FCodigosSisbov <> nil Then Begin
    Result := 0;
    Exit;
  End;
//  FinalizarCodigosSisbov;
  FCodigosSisbov := TCodigosSisbov.Create;
  FCodigosSisbov.ObjAddRef;
  Result := FCodigosSisbov.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_Estados: IEstados;
begin
  Result := FEstados;
end;

function TSessao.InicializarEstados: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEstados', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarEstados;
  FEstados := TEstados.Create;
  FEstados.ObjAddRef;
  Result := FEstados.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEstados;
begin
  If FEstados <> nil Then Begin
    FEstados.ObjRelease;
    FEstados := nil;
  End;

end;

function TSessao.Get_MicroRegioes: IMicroRegioes;
begin
  Result := FMicroRegioes;
end;

function TSessao.InicializarMicroRegioes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarMicroRegioes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarMicroRegioes;
  FMicroRegioes := TMicroRegioes.Create;
  FMicroRegioes.ObjAddRef;
  Result := FMicroRegioes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarMicroRegioes;
begin
  If FMicroRegioes <> nil Then Begin
    FMicroRegioes.ObjRelease;
    FMicroRegioes := nil;
  End;
end;

function TSessao.Get_Racas: IRacas;
begin
  result := FRacas;
end;

function TSessao.InicializarRacas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRacas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarRacas;
  FRacas := TRacas.Create;
  FRacas.ObjAddRef;
  Result := FRacas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarRacas;
begin
  If FRacas <> nil Then Begin
    FRacas.ObjRelease;
    FRacas := nil;
  End;
end;

function TSessao.Get_Pelagens: IPelagens;
begin
  Result := FPelagens;
end;

function TSessao.InicializarPelagens: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPelagens', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarPelagens;
  FPelagens := TPelagens.Create;
  FPelagens.ObjAddRef;
  Result := FPelagens.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPelagens;
begin
  If FPelagens <> nil Then Begin
    FPelagens.ObjRelease;
    FPelagens := nil;
  End;
end;

function TSessao.Get_Locais: ILocais;
begin
  Result := FLocais;
end;

function TSessao.InicializarLocais: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarLocais', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarLocais;
  FLocais := TLocais.Create;
  FLocais.ObjAddRef;
  Result := FLocais.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarLocais;
begin
  If FLocais <> nil Then Begin
    FLocais.ObjRelease;
    FLocais := nil;
  End;
end;

function TSessao.Get_TiposOrigem: ITiposOrigem;
begin
  Result := FTiposOrigem;
end;

function TSessao.InicializarTiposOrigem: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposOrigem', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarTiposOrigem;
  FTiposOrigem := TTiposOrigem.Create;
  FTiposOrigem.ObjAddRef;
  Result := FTiposOrigem.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposOrigem;
begin
  If FTiposOrigem <> nil Then Begin
    FTiposOrigem.ObjRelease;
    FTiposOrigem := nil;
  End;
end;

function TSessao.Get_Fazendas: IFazendas;
begin
  Result := FFazendas;
end;

function TSessao.InicializarFazendas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarFazendas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarFazendas;
  FFazendas := TFazendas.Create;
  FFazendas.ObjAddRef;
  Result := FFazendas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarFazendas;
begin
  If FFazendas <> nil Then Begin
    FFazendas.ObjRelease;
    FFazendas := nil;
  End;
end;

function TSessao.Get_RegimesAlimentares: IRegimesAlimentares;
begin
  result := FRegimesAlimentares;
end;

function TSessao.InicializarRegimesAlimentares: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRegimesAlimentares', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarRegimesAlimentares;
  FRegimesAlimentares := TRegimesAlimentares.Create;
  FRegimesAlimentares.ObjAddRef;
  Result := FRegimesAlimentares.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarRegimesAlimentares;
begin
  if FRegimesAlimentares <> nil then begin
    FRegimesAlimentares.Objrelease;
    FRegimesAlimentares := nil;
  end;
end;

function TSessao.Get_AssociacoesRaca: IAssociacoesRaca;
begin
  result := FAssociacoesRaca;
end;

function TSessao.InicializarAssociacoesRaca: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAssociacoesRaca', [Self.ClassName]);
    Result := -1;
    Exit;
  End;
  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarAssociacoesRaca;
  FAssociacoesRaca := TAssociacoesRaca.Create;
  FAssociacoesRaca.ObjAddRef;
  Result := FAssociacoesRaca.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAssociacoesRaca;
begin
  if FAssociacoesRaca <> nil then begin
    FAssociacoesRaca.Objrelease;
    FAssociacoesRaca := nil;
  end;
end;

function TSessao.Get_GrausSangue: IGrausSangue;
begin
  result := FGrausSangue;
end;

function TSessao.InicializarGrausSangue: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGrausSangue', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarGrausSangue;
  FGrausSangue := TGrausSangue.Create;
  FGrausSangue.ObjAddRef;
  Result := FGrausSangue.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGrausSangue;
begin
  if FGrausSangue <> nil then begin
    FGrausSangue.Objrelease;
    FGrausSangue := nil;
  end;
end;

function TSessao.Get_TiposIdentificador: ITiposIdentificador;
begin
  result := FTiposIdentificador;
end;

function TSessao.InicializarTiposIdentificador: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposIdentificador', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarTiposIdentificador;
  FTiposIdentificador := TTiposIdentificador.Create;
  FTiposIdentificador.ObjAddRef;
  Result := FTiposIdentificador.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposIdentificador;
begin
  if FTiposIdentificador <> nil then begin
    FTiposIdentificador.Objrelease;
    FTiposIdentificador := nil;
  end;
end;

function TSessao.Get_CategoriasAnimal: ICategoriasAnimal;
begin
  result := FCategoriasAnimal;
end;

function TSessao.InicializarCategoriasAnimal: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarCategoriasAnimal', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarCategoriasAnimal;
  FCategoriasAnimal := TCategoriasAnimal.Create;
  FCategoriasAnimal.ObjAddRef;
  Result := FCategoriasAnimal.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarCategoriasAnimal;
begin
  if FCategoriasAnimal <> nil then begin
    FCategoriasAnimal.Objrelease;
    FCategoriasAnimal := nil;
  end;
end;

function TSessao.Get_TiposFonteAgua: TiposFonteAgua;
begin
  result := FTiposFonteAgua;
end;

function TSessao.InicializarTiposFonteAgua: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposFonteAgua', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarTiposFonteAgua;
  FTiposFonteAgua := TTiposFonteAgua.Create;
  FTiposFonteAgua.ObjAddRef;
  Result := FTiposFonteAgua.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposFonteAgua;
begin
 if FTiposFonteAgua <> nil then begin
    FTiposFonteAgua.Objrelease;
    FTiposFonteAgua := nil;
  end;
end;

function TSessao.Get_Animais: IAnimais;
begin
  Result := FAnimais;
end;

function TSessao.InicializarAnimais: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAnimais', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Se a classe já estiver inicializada não reinicializa
  If FAnimais <> nil Then Begin
    Result := 0;
    Exit;
  End;
//  FInalizarAnimais;
  FAnimais := TAnimais.Create;
  FAnimais.ObjAddRef;
  Result := FAnimais.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAnimais;
begin
  If FAnimais <> nil Then Begin
    FAnimais.ObjRelease;
    FAnimais := nil;
  End;
end;

function TSessao.Get_Lotes: ILotes;
begin
  result := FLotes;
end;

function TSessao.InicializarLotes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarLotes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarLotes;
  FLotes := TLotes.Create;
  FLotes.ObjAddRef;
  Result := FLotes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarLotes;
begin
  If FLotes <> nil Then Begin
    FLotes.ObjRelease;
    FLotes := nil;
  End;
end;

function TSessao.Get_Localidades: ILocalidades;
begin
  result := FLocalidades;
end;

function TSessao.InicializarLocalidades: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarLocalidades', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarLocalidades;
  FLocalidades := TLocalidades.Create;
  FLocalidades.ObjAddRef;
  Result := FLocalidades.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarLocalidades;
begin
  If FLocalidades <> nil Then Begin
    FLocalidades.ObjRelease;
    FLocalidades := nil;
  End;
end;

function TSessao.InicializarPapeisSecundarios: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPapeisSecundarios', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarPapeisSecundarios;
  FPapeisSecundarios := TPapeisSecundarios.Create;
  FPapeisSecundarios.ObjAddRef;
  Result := FPapeisSecundarios.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPapeisSecundarios;
begin
  If FPapeisSecundarios <> nil Then Begin
    FPapeisSecundarios.ObjRelease;
    FPapeisSecundarios := nil;
  End;
end;

function TSessao.Get_PapeisSecundarios: IPapeisSecundarios;
begin
  result := FPapeisSecundarios;
end;

function TSessao.InicializarPessoasSecundarias: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPessoasSecundarias', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPessoasSecundarias;
  FPessoasSecundarias := TPessoasSecundarias.Create;
  FPessoasSecundarias.ObjAddRef;
  Result := FPessoasSecundarias.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPessoasSecundarias;
begin
  If FPessoasSecundarias <> nil Then Begin
    FPessoasSecundarias.ObjRelease;
    FPessoasSecundarias := nil;
  End;
end;

function TSessao.Get_PessoasSecundarias: IPessoasSecundarias;
begin
  Result := FPessoasSecundarias;
end;

function TSessao.Get_OpcoesEnvioComunicado: IOpcoesEnvioComunicado;
begin
  Result := FOpcoesEnvioComunicado;
end;

function TSessao.InicializarOpcoesEnvioComunicado: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarOpcoesEnvioComunicado', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarOpcoesEnvioComunicado;
  FOpcoesEnvioComunicado := TOpcoesEnvioComunicado.Create;
  FOpcoesEnvioComunicado.ObjAddRef;
  Result := FOpcoesEnvioComunicado.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarOpcoesEnvioComunicado;
begin
  If FOpcoesEnvioComunicado <> nil Then Begin
    FOpcoesEnvioComunicado.ObjRelease;
    FOpcoesEnvioComunicado := nil;
  End;
end;

function TSessao.Get_TiposContato: ITiposContato;
begin
  Result := FTiposContato;
end;

function TSessao.InicializarTiposContato: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposContato', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposContato;
  FTiposContato := TTiposContato.Create;
  FTiposContato.ObjAddRef;
  Result := FTiposContato.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposContato;
begin
  If FTiposContato <> nil Then Begin
    FTiposContato.ObjRelease;
    FTiposContato := nil;
  End;
end;

function TSessao.Get_TiposEndereco: ITiposEndereco;
begin
  Result := FTiposEndereco;
end;

function TSessao.InicializarTiposEndereco: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposEndereco', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposEndereco;
  FTiposEndereco := TTiposEndereco.Create;
  FTiposEndereco.ObjAddRef;
  Result := FTiposEndereco.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposEndereco;
begin
  If FTiposEndereco <> nil Then Begin
    FTiposEndereco.ObjRelease;
    FTiposEndereco := nil;
  End;
end;

function TSessao.Get_PropriedadesRurais: IPropriedadesRurais;
begin
  Result := FPropriedadesRurais;
end;

function TSessao.InicializarPropriedadesRurais: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPropriedadesRurais', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPropriedadesRurais;
  FPropriedadesRurais := TPropriedadesRurais.Create;
  FPropriedadesRurais.ObjAddRef;
  Result := FPropriedadesRurais.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPropriedadesRurais;
begin
  If FPropriedadesRurais <> nil Then Begin
    FPropriedadesRurais.ObjRelease;
    FPropriedadesRurais := nil;
  End;
end;

function TSessao.Get_Aptidoes: IAptidoes;
begin
  result := FAptidoes;
end;

function TSessao.InicializarAptidoes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAptidoes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAptidoes;
  FAptidoes := TAptidoes.Create;
  FAptidoes.ObjAddRef;
  Result := FAptidoes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAptidoes;
begin
  If FAptidoes <> nil Then Begin
    FAptidoes.ObjRelease;
    FAptidoes := nil;
  End;
end;

function TSessao.Get_Especies: IEspecies;
begin
  result := FEspecies;
end;

function TSessao.InicializarEspecies: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEspecies', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEspecies;
  FEspecies := TEspecies.Create;
  FEspecies.ObjAddRef;
  Result := FEspecies.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEspecies;
begin
  If FEspecies <> nil Then Begin
    FEspecies.ObjRelease;
    FEspecies := nil;
  End;
end;

function TSessao.Get_TiposMorte: ITiposMorte;
begin
  result := FTiposMorte;
end;

function TSessao.InicializarTiposMorte: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposMorte', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposMorte;
  FTiposMorte := TTiposMorte.Create;
  FTiposMorte.ObjAddRef;
  Result := FTiposMorte.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposMorte;
begin
  If FTiposMorte <> nil Then Begin
    FTiposMorte.ObjRelease;
    FTiposMorte := nil;
  End;
end;

function TSessao.Get_CausasMorte: ICausasMorte;
begin
  result := FCausasMorte;
end;

function TSessao.InicializarCausasMorte: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarCausasMorte', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarCausasMorte;
  FCausasMorte := TCausasMorte.Create;
  FCausasMorte.ObjAddRef;
  Result := FCausasMorte.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarCausasMorte;
begin
  If FCausasMorte <> nil Then Begin
    FCausasMorte.ObjRelease;
    FCausasMorte := nil;
  End;
end;

function TSessao.InicializarGrausInstrucao: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGrausInstrucao', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarGrausInstrucao;
  FGrausInstrucao := TGrausInstrucao.Create;
  FGrausInstrucao.ObjAddRef;
  Result := FGrausInstrucao.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGrausInstrucao;
begin
  If FGrausInstrucao <> nil Then Begin
    FGrausInstrucao.ObjRelease;
    FGrausInstrucao := nil;
  End;
end;

function TSessao.Get_GrausInstrucao: IGrausInstrucao;
begin
  result := FGrausInstrucao;
end;

function TSessao.Get_PosicoesIdentificador: IPosicoesIdentificador;
begin
  result := FPosicoesIdentificador;
end;

function TSessao.InicializarPosicoesIdentificador: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPosicoesIdentificador', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPosicoesIdentificador;
  FPosicoesIdentificador := TPosicoesIdentificador.Create;
  FPosicoesIdentificador.ObjAddRef;
  Result := FPosicoesIdentificador.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarPosicoesIdentificador;
begin
  If FPosicoesIdentificador <> nil Then Begin
    FPosicoesIdentificador.ObjRelease;
    FPosicoesIdentificador := nil;
  End;
end;

function TSessao.Get_TiposLugar: ITiposLugar;
begin
   result := FTiposLugar;
end;

procedure TSessao.FinalizarTiposLugar;
begin
  if FTiposLugar <> nil then begin
    FTiposLugar.Objrelease;
    FTiposLugar := nil;
  end;
end;

function TSessao.InicializarTiposLugar: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposLugar', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposLugar;
  FTiposLugar := TTiposLugar.Create;
  FTiposLugar.ObjAddRef;
  Result := FTiposLugar.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_SituacoesSisBov: ISituacoesSisBov;
begin
   result := FSituacoesSisBov;
end;

function TSessao.InicializarSituacoesSisBov: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesSisBov', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesSisBov;
  FSituacoesSisBov := TSituacoesSisBov.Create;
  FSituacoesSisBov.ObjAddRef;
  Result := FSituacoesSisBov.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesSisBov;
begin
  if FSituacoesSisBov <> nil then begin
    FSituacoesSisBov.Objrelease;
    FSituacoesSisBov := nil;
  end;
end;

function TSessao.Get_PessoasContatos: IPessoasContatos;
begin
  Result := FPessoasContatos;
end;

procedure TSessao.FinalizarPessoasContatos;
begin
  if FPessoasContatos <> nil then begin
    FPessoasContatos.Objrelease;
    FPessoasContatos := nil;
  end;
end;

function TSessao.InicializarPessoasContatos: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarPessoasContatos', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarPessoasContatos;
  FPessoasContatos := TPessoasContatos.Create;
  FPessoasContatos.ObjAddRef;
  Result := FPessoasContatos.Inicializar(FConexao, FMensagens);
end;

function TSessao.AdicionarMensagem(CodMensagem: Integer): Integer;
begin
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'AdicionarMensagem', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  Try
    FMensagens.Adicionar(CodMensagem, Self.ClassName, 'AdicionarMensagem', []);
    Result := 0;
  Except
    Result := -1;
  End;
end;

function TSessao.Get_GrandezasResumo: IGrandezasResumo;
begin
  result := FGrandezasResumo;
end;

function TSessao.InicializarGrandezasResumo: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGrandezasResumo', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarGrandezasResumo;
  FGrandezasResumo := TGrandezasResumo.Create;
  FGrandezasResumo.ObjAddRef;
  Result := FGrandezasResumo.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGrandezasResumo;
begin
  if FGrandezasResumo <> nil then begin
    FGrandezasResumo.Objrelease;
    FGrandezasResumo := nil;
  end;
end;

function TSessao.Get_GruposEvento: IGruposEvento;
begin
  result := FGruposEvento;
end;

function TSessao.InicializarGruposEvento: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGruposEvento', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarGruposEvento;
  FGruposEvento := TGruposEvento.Create;
  FGruposEvento.ObjAddRef;
  Result := FGruposEvento.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGruposEvento;
begin
  if FGruposEvento <> nil then begin
    FGruposEvento.Objrelease;
    FGruposEvento := nil;
  end;
end;

function TSessao.Get_TiposEvento: TiposEvento;
begin
  result := FTiposEvento;
end;

function TSessao.InicializarTiposEvento: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposEvento', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposEvento;
  FTiposEvento := TTiposEvento.Create;
  FTiposEvento.ObjAddRef;
  Result := FTiposEvento.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposEvento;
begin
  if FTiposEvento <> nil then begin
    FTiposEvento.Objrelease;
    FTiposEvento := nil;
  end;
end;

function TSessao.Get_UnidadesMedida: IUnidadesMedida;
begin
  result := FUnidadesMedida;
end;

function TSessao.InicializarUnidadesMedida: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarUnidadesMedida', [Self.ClassName]);
    Result := -1;
    Exit;
  End;
  //-------------------------------------------------------------
  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  //-------------------------------------------------------------
  FinalizarUnidadesMedida;
  FUnidadesMedida := TUnidadesMedida.Create;
  FUnidadesMedida.ObjAddRef;
  Result := FUnidadesMedida.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarUnidadesMedida;
begin
  if FUnidadesMedida <> nil then begin
    FUnidadesMedida.Objrelease;
    FUnidadesMedida := nil;
  end;
end;

function TSessao.InicializarTiposInsumo: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposInsumo', [Self.ClassName]);
    Result := -1;
    Exit;
  End;
  //-------------------------------------------------------------
  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  //-------------------------------------------------------------
  FinalizarTiposInsumo;
  FTiposInsumo := TTiposInsumo.Create;
  FTiposInsumo.ObjAddRef;
  Result := FTiposInsumo.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_TiposInsumo: ITiposInsumo;
begin
  result := FTiposInsumo;
end;

procedure TSessao.FinalizarTiposInsumo;
begin
  if FTiposInsumo <> nil then begin
    FTiposInsumo.Objrelease;
    FTiposInsumo := nil;
  end;
end;

function TSessao.InicializarSubTiposInsumo: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSubTiposInsumo', [Self.ClassName]);
    Result := -1;
    Exit;
  End;
  //-------------------------------------------------------------
  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  //-------------------------------------------------------------
  FinalizarSubTiposInsumo;
  FSubTiposInsumo := TSubTiposInsumo.Create;
  FSubTiposInsumo.ObjAddRef;
  Result := FSubTiposInsumo.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_SubTiposInsumo: ISubTiposInsumo;
begin
  result := FSubTiposInsumo;
end;

procedure TSessao.FinalizarSubTiposInsumo;
begin
  if FSubTiposInsumo <> nil then begin
    FSubTiposInsumo.Objrelease;
    FSubTiposInsumo := nil;
  end;
end;

function TSessao.Get_FabricantesInsumo: IFabricantesInsumo;
begin
 result := FFabricantesInsumo;
end;

function TSessao.InicializarFabricantesInsumo: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarFabricantesInsumo', [Self.ClassName]);
    Result := -1;
    Exit;
  End;
  //-------------------------------------------------------------
  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  //-------------------------------------------------------------
  FinalizarFabricantesInsumo;
  FFabricantesInsumo := TFabricantesInsumo.Create;
  FFabricantesInsumo.ObjAddRef;
  Result := FFabricantesInsumo.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarFabricantesInsumo;
begin
  if FFabricantesInsumo <> nil then begin
    FFabricantesInsumo.Objrelease;
    FFabricantesInsumo := nil;
  end;
end;

function TSessao.Get_Eventos: IEventos;
begin
  Result := FEventos;
end;

function TSessao.InicializarEventos: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEventos', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEventos;
  FEventos := TEventos.Create;
  FEventos.ObjAddRef;
  Result := FEventos.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEventos;
begin
  If FEventos <> nil Then Begin
    FEventos.ObjRelease;
    FEventos := nil;
  End;
end;

function TSessao.Get_MudancasCategoriaAnimal: IMudancasCategoriaAnimal;
begin
  Result := FMudancasCategoriaAnimal;
end;

function TSessao.InicializarMudancasCategoriaAnimal: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarMudancasCategoriaAnimal', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarMudancasCategoriaAnimal;
  FMudancasCategoriaAnimal := TMudancasCategoriaAnimal.Create;
  FMudancasCategoriaAnimal.ObjAddRef;
  Result := FMudancasCategoriaAnimal.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarMudancasCategoriaAnimal;
begin
  If FMudancasCategoriaAnimal <> nil Then Begin
    FMudancasCategoriaAnimal.ObjRelease;
    FMudancasCategoriaAnimal := nil;
  End;
end;

function TSessao.Get_Insumos: IInsumos;
begin
 result := FInsumos;
end;

function TSessao.InicializarInsumos: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarInsumos', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FInalizarInsumos;
  FInsumos := TInsumos.Create;
  FInsumos.ObjAddRef;
  Result := FInsumos.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarInsumos;
begin
  If FInsumos <> nil Then Begin
    FInsumos.ObjRelease;
    FInsumos:= nil;
  End;
end;

function TSessao.InicializarEntradasInsumo: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEntradasInsumo', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEntradasInsumo;
  FEntradasInsumo := TEntradasInsumo.Create;
  FEntradasInsumo.ObjAddRef;
  Result := FEntradasInsumo.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_EntradasInsumo: IEntradasInsumo;
begin
 result := FEntradasInsumo;
end;

procedure TSessao.FinalizarEntradasInsumo;
begin
  If FEntradasInsumo <> nil Then Begin
    FEntradasInsumo.ObjRelease;
    FEntradasInsumo:= nil;
  End;
end;

function TSessao.Get_Relatorios: IRelatorios;
begin
 Result := FRelatorios;
end;

procedure TSessao.FinalizarRelatorios;
begin
  If FRelatorios <> nil Then Begin
    FRelatorios.ObjRelease;
    FRelatorios:= nil;
  End;
end;

function TSessao.InicializarRelatorios: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRelatorios', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarRelatorios;
  FRelatorios := TRelatorios.Create;
  FRelatorios.ObjAddRef;
  Result := FRelatorios.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_LargurasLinhaRelatorio: ILargurasLinhaRelatorio;
begin
  Result := FLargurasLinhaRelatorio;
end;

function TSessao.InicializarLargurasLinhaRelatorio: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarLargurasLinhaRelatorio', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarLargurasLinhaRelatorio;
  FLargurasLinhaRelatorio := TLargurasLinhaRelatorio.Create;
  FLargurasLinhaRelatorio.ObjAddRef;
  Result := FLargurasLinhaRelatorio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarLargurasLinhaRelatorio;
begin
  If FLargurasLinhaRelatorio <> nil Then Begin
    FLargurasLinhaRelatorio.ObjRelease;
    FLargurasLinhaRelatorio := nil;
  End;
end;

function TSessao.Get_Orientacoes: IOrientacoes;
begin
  Result := FOrientacoes;
end;

function TSessao.InicializarOrientacoes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarOrientacoes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarOrientacoes;
  FOrientacoes := TOrientacoes.Create;
  FOrientacoes.ObjAddRef;
  Result := FOrientacoes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarOrientacoes;
begin
  If FOrientacoes <> nil Then Begin
    FOrientacoes.ObjRelease;
    FOrientacoes := nil;
  End;
end;

function TSessao.Get_TamanhosFonte: ITamanhosFonte;
begin
  Result := FTamanhosFonte;
end;

function TSessao.InicializarTamanhosFonte: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTamanhosFonte', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTamanhosFonte;
  FTamanhosFonte := TTamanhosFonte.Create;
  FTamanhosFonte.ObjAddRef;
  Result := FTamanhosFonte.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTamanhosFonte;
begin
  If FTamanhosFonte <> nil Then Begin
    FTamanhosFonte.ObjRelease;
    FTamanhosFonte := nil;
  End;
end;

function TSessao.ValorParametroSistema(CodParametro: Integer): WideString;
begin
  try
    Result := BuscarValorParametroSistema(CodParametro);
  except
    Result := '#ERRO#';
  end;
end;

function TSessao.InicializarInterfaceSisbov: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarInterfaceSisbov', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarInterfaceSisbov;
  FInterfaceSisbov := TInterfaceSisbov.Create;
  FInterfaceSisbov.ObjAddRef;
  Result := FInterfaceSisbov.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarInterfaceSisbov;
begin
  If FInterfaceSisbov <> nil Then Begin
    FInterfaceSisbov.ObjRelease;
    FInterfaceSisbov := nil;
  End;
end;

function TSessao.Get_InterfaceSisbov: IInterfaceSisbov;
begin
  Result := FInterfaceSisbov;
end;

function TSessao.InicializarTiposArquivoSisbov: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposArquivoSisbov', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposArquivoSisbov;
  FTiposArquivoSisbov := TTiposArquivoSisbov.Create;
  FTiposArquivoSisbov.ObjAddRef;
  Result := FTiposArquivoSisbov.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposArquivoSisbov;
begin
  If FTiposArquivoSisbov <> nil Then Begin
    FTiposArquivoSisbov.ObjRelease;
    FTiposArquivoSisbov := nil;
  End;
end;

function TSessao.Get_TiposArquivoSISBOV: ITiposArquivoSisBov;
begin
  result := FTiposArquivoSISBOV;
end;

function TSessao.InicializarTiposSubEventoSanitario: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposSubEventoSanitario', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposSubEventoSanitario;
  FTiposSubEventoSanitario := TTiposSubEventoSanitario.Create;
  FTiposSubEventoSanitario.ObjAddRef;
  Result := FTiposSubEventoSanitario.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposSubEventoSanitario;
begin
  If FTiposSubEventoSanitario <> nil Then Begin
    FTiposSubEventoSanitario.ObjRelease;
    FTiposSubEventoSanitario := nil;
  End;
end;

function TSessao.Get_TiposSubEventoSanitario: ITiposSubEventoSanitario;
begin
  result := FTiposSubEventoSanitario;
end;

function TSessao.Get_ReprodutoresMultiplos: IReprodutoresMultiplos;
begin
  result := FReprodutoresMultiplos;
end;

function TSessao.InicializarReprodutoresMultiplos: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarReprodutoresMultiplos', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarReprodutoresMultiplos;
  FReprodutoresMultiplos := TReprodutoresMultiplos.Create;
  FReprodutoresMultiplos.ObjAddRef;
  Result := FReprodutoresMultiplos.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarReprodutoresMultiplos;
begin
  If FReprodutoresMultiplos <> nil Then Begin
    FReprodutoresMultiplos.ObjRelease;
    FReprodutoresMultiplos := nil;
  End;
end;

function TSessao.InicializarParametrosPesoAjustado: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarParametrosPesoAjustado', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarParametrosPesoAjustado;
  FParametrosPesoAjustado := TParametrosPesoAjustado.Create;
  FParametrosPesoAjustado.ObjAddRef;
  Result := FParametrosPesoAjustado.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_ParametrosPesoAjustado: IParametrosPesoAjustado;
begin
  result := FParametrosPesoAjustado;
end;

procedure TSessao.FinalizarParametrosPesoAjustado;
begin
  If FParametrosPesoAjustado <> nil Then Begin
    FParametrosPesoAjustado.ObjRelease;
    FParametrosPesoAjustado := nil;
  End;
end;

function TSessao.Get_ModelosCertificado: IModelosCertificado;
begin
  Result := FModelosCertificado;
end;

function TSessao.InicializarModelosCertificado: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarModelosCertificado', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarModelosCertificado;
  FModelosCertificado := TModelosCertificado.Create;
  FModelosCertificado.ObjAddRef;
  Result := FModelosCertificado.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarModelosCertificado;
begin
  If FModelosCertificado <> nil Then Begin
    FModelosCertificado.ObjRelease;
    FModelosCertificado := nil;
  End;
end;

function TSessao.Get_Importacoes: IImportacoes;
begin
  Result := FImportacoes;
end;

function TSessao.InicializarImportacoes: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarImportacoes', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarImportacoes;
  FImportacoes := TImportacoes.Create;
  FImportacoes.ObjAddRef;
  Result := FImportacoes.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarImportacoes;
begin
  If FImportacoes <> nil Then Begin
    FImportacoes.ObjRelease;
    FImportacoes := nil;
  End;
end;

function TSessao.Get_TiposAgrupamentoRacas: ITiposAgrupamentoRacas;
begin
  Result := FTiposAgrupamentoRacas;
end;

function TSessao.InicializarTiposAgrupamentosRacas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposAgrupamentoRacas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposAgrupamentosRacas;
  FTiposAgrupamentoRacas := TTiposAgrupamentoRacas.Create;
  FTiposAgrupamentoRacas.ObjAddRef;
  Result := FTiposAgrupamentoRacas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposAgrupamentosRacas;
begin
  If FTiposAgrupamentoRacas <> nil Then Begin
    FTiposAgrupamentoRacas.ObjRelease;
    FTiposAgrupamentoRacas := nil;
  End;
end;

function TSessao.InicializarAgrupamentosRacas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAgrupamentosRacas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAgrupamentosRacas;
  FAgrupamentosRacas := TAgrupamentosRacas.Create;
  FAgrupamentosRacas.ObjAddRef;
  Result := FAgrupamentosRacas.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAgrupamentosRacas;
begin
  If FAgrupamentosRacas <> nil Then Begin
    FAgrupamentosRacas.ObjRelease;
    FAgrupamentosRacas := nil;
  End;
end;

function TSessao.Get_AgrupamentosRacas: IAgrupamentosRacas;
begin
  Result := FAgrupamentosRacas;
end;

function TSessao.QtdTarefasAgendadas: Integer;
const
  NomeMetodo: String = 'QtdTarefasAgendadas';
var
  Q: THerdomQuery;
begin
  Result := -1;
  if not FAtiva then Exit;
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.SQL.Text :=
        'select '+
        '  count(1) as QtdTarefasAgendadas '+
        'from '+
        '  tab_tarefa '+
        'where '+
        '  cod_usuario = :cod_usuario '+
        '  and cod_situacao_tarefa in (''N'', ''A'') ';
      Q.ParamByName('cod_usuario').AsInteger := FConexao.CodUsuario;
      Q.Open;
      Result := Q.FieldByName('QtdTarefasAgendadas').AsInteger;
      Q.Close;
    Except
      On E: Exception do Begin
        FMensagens.Adicionar(1323, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1323;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TSessao.QtdTarefasEmAndamento: Integer;
const
  NomeMetodo: String = 'QtdTarefasEmAndamento';
var
  Q: THerdomQuery;
begin
  Result := -1;
  if not FAtiva then Exit;
  Q := THerdomQuery.Create(FConexao, nil);
  Try
    Try
      Q.SQL.Text :=
        'select '+
        '  count(1) as QtdTarefasEmAndamento '+
        'from '+
        '  tab_tarefa '+
        'where '+
        '  cod_usuario = :cod_usuario '+
        '  and cod_situacao_tarefa in (''A'') ';
      Q.ParamByName('cod_usuario').AsInteger := FConexao.CodUsuario;
      Q.Open;
      Result := Q.FieldByName('QtdTarefasEmAndamento').AsInteger;
      Q.Close;
    Except
      On E: Exception do Begin
        FMensagens.Adicionar(1324, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1324;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TSessao.Get_Tarefas: ITarefas;
begin
  Result := FTarefas;
end;

procedure TSessao.FinalizarTarefas;
begin
  If FTarefas <> nil Then Begin
    FTarefas.ObjRelease;
    FTarefas := nil;
  End;
end;

function TSessao.InicializarTarefas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTarefas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTarefas;
  FTarefas := TTarefas.Create;
  FTarefas.ObjAddRef;
  Result := FTarefas.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_SituacoesTarefa: ISituacoesTarefa;
begin
  Result := FSituacoesTarefa;
end;

function TSessao.InicializarSituacoesTarefa: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesTarefa', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesTarefa;
  FSituacoesTarefa := TSituacoesTarefa.Create;
  FSituacoesTarefa.ObjAddRef;
  Result := FSituacoesTarefa.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesTarefa;
begin
  If FSituacoesTarefa <> nil Then Begin
    FSituacoesTarefa.ObjRelease;
    FSituacoesTarefa := nil;
  End;
end;

function TSessao.Get_EstoqueSemen: IEstoqueSemen;
begin
  Result := FEstoqueSemen;
end;

function TSessao.InicializarEstoqueSemen: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEstoqueSemen', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEstoqueSemen;
  FEstoqueSemen := TEstoqueSemen.Create;
  FEstoqueSemen.ObjAddRef;
  Result := FEstoqueSemen.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEstoqueSemen;
begin
  If FEstoqueSemen <> nil Then Begin
    FEstoqueSemen.ObjRelease;
    FEstoqueSemen := nil;
  End;
end;

function TSessao.Get_TiposMovimentoEstoqueSemen: ITiposMovimentoEstoqueSemen;
begin
  Result := FTiposMovimentoEstoqueSemen;
end;

function TSessao.InicializarTiposMovimentoEstoqueSemen: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposMovimentoEstoqueSemen', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposMovimentoEstoqueSemen;
  FTiposMovimentoEstoqueSemen := TTiposMovimentoEstoqueSemen.Create;
  FTiposMovimentoEstoqueSemen.ObjAddRef;
  Result := FTiposMovimentoEstoqueSemen.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposMovimentoEstoqueSemen;
begin
  If FTiposMovimentoEstoqueSemen <> nil Then Begin
    FTiposMovimentoEstoqueSemen.ObjRelease;
    FTiposMovimentoEstoqueSemen := nil;
  End;
end;

function TSessao.Get_CaminhoArquivosCertificadora: WideString;
begin
  Result := FCaminhoArquivosCertificadora;
end;

function TSessao.Get_TiposAvaliacao: ITiposAvaliacao;
begin
  Result := FTiposAvaliacao;
end;

function TSessao.InicializarTiposAvaliacao: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposAvaliacao', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposAvaliacao;
  FTiposAvaliacao := TTiposAvaliacao.Create;
  FTiposAvaliacao.ObjAddRef;
  Result := FTiposAvaliacao.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposAvaliacao;
begin
  If FTiposAvaliacao <> nil Then Begin
    FTiposAvaliacao.ObjRelease;
    FTiposAvaliacao := nil;
  End;
end;

function TSessao.Get_CaracteristicasAvaliacao: ICaracteristicasAvaliacao;
begin
  Result := FCaracteristicasAvaliacao;
end;

function TSessao.InicializarCaracteristicasAvaliacao: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarCaracteristicasAvaliacao', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarCaracteristicasAvaliacao;
  FCaracteristicasAvaliacao := TCaracteristicasAvaliacao.Create;
  FCaracteristicasAvaliacao.ObjAddRef;
  Result := FCaracteristicasAvaliacao.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarCaracteristicasAvaliacao;
begin
  If FCaracteristicasAvaliacao <> nil Then Begin
    FCaracteristicasAvaliacao.ObjRelease;
    FCaracteristicasAvaliacao := nil;
  End;
end;

function TSessao.Get_SituacoesCria: ISituacoesCria;
begin
  Result := FSituacoesCria;
end;

function TSessao.InicializarSituacoesCria: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesCria', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesCria;
  FSituacoesCria := TSituacoesCria.Create;
  FSituacoesCria.ObjAddRef;
  Result := FSituacoesCria.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesCria;
begin
  If FSituacoesCria <> nil Then Begin
    FSituacoesCria.ObjRelease;
    FSituacoesCria := nil;
  End;
end;

function TSessao.Get_GrausDificuldade: IGrausDificuldade;
begin
  Result := FGrausDificuldade;
end;

function TSessao.InicializarGrausDificuldade: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarGrausDificuldade', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarGrausDificuldade;
  FGrausDificuldade := TGrausDificuldade.Create;
  FGrausDificuldade.ObjAddRef;
  Result := FGrausDificuldade.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarGrausDificuldade;
begin
  If FGrausDificuldade <> nil Then Begin
    FGrausDificuldade.ObjRelease;
    FGrausDificuldade := nil;
  End;
end;

function TSessao.Get_MotivosDescarte: IMotivosDescarte;
begin
  Result := FMotivosDescarte;
end;

function TSessao.InicializarMotivosDescarte: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarMotivosDescarte', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarMotivosDescarte;
  FMotivosDescarte := TMotivosDescarte.Create;
  FMotivosDescarte.ObjAddRef;
  Result := FMotivosDescarte.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarMotivosDescarte;
begin
  If FMotivosDescarte <> nil Then Begin
    FMotivosDescarte.ObjRelease;
    FMotivosDescarte := nil;
  End;
end;


function TSessao.Get_ImportacoesSISBOV: IImportacoesSISBOV;
begin
  Result := FImportacoesSISBOV;
end;

function TSessao.InicializarImportacoesSISBOV: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarImportacoesSISBOV', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarImportacoesSISBOV;
  FImportacoesSISBOV := TImportacoesSISBOV.Create;
  FImportacoesSISBOV.ObjAddRef;
  Result := FImportacoesSISBOV.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarImportacoesSISBOV;
begin
  If FImportacoesSISBOV <> nil Then Begin
    FImportacoesSISBOV.ObjRelease;
    FImportacoesSISBOV := nil;
  End;
end;

function TSessao.Get_ImportacoesDadoGeral: IImportacoesDadoGeral;
begin
  Result := FImportacoesDadoGeral;
end;

function TSessao.InicializarImportacoesDadoGeral: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarImportacoesDadoGeral', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarImportacoesDadoGeral;
  FImportacoesDadoGeral := TImportacoesDadoGeral.Create;
  FImportacoesDadoGeral.ObjAddRef;
  Result := FImportacoesDadoGeral.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarImportacoesDadoGeral;
begin
  If FImportacoesDadoGeral <> nil Then Begin
     FImportacoesDadoGeral.ObjRelease;
     FImportacoesDadoGeral := nil;
  End;
end;


procedure TSessao.FinalizarTiposOrigemArqImport;
begin
  If FTiposOrigemArqImport <> nil Then Begin
     FTiposOrigemArqImport.ObjRelease;
     FTiposOrigemArqImport := nil;
  End;
end;

function TSessao.InicializarTiposOrigemArqImport: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTipoOrigemArqImport', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposOrigemArqImport;
  FTiposOrigemArqImport := TTiposOrigemArqImport.Create;
  FTiposOrigemArqImport.ObjAddRef;
  Result := FTiposOrigemArqImport.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_TiposOrigemArqImport: ITiposOrigemArqImport;
begin
    Result := FTiposOrigemArqImport;
end;

function TSessao.Get_RegimesPosseUso: IRegimesPosseUso;
begin
  Result := FRegimesPosseUso;
end;

function TSessao.InicializarRegimesPosseUso: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRegimesPosseUso', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarRegimesPosseUso;
  FRegimesPosseUso := TRegimesPosseUso.Create;
  FRegimesPosseUso.ObjAddRef;
  Result := FRegimesPosseUso.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarRegimesPosseUso;
begin
  If FRegimesPosseUso <> nil Then Begin
    FRegimesPosseUso.ObjRelease;
    FRegimesPosseUso := nil;
  End;
end;

function TSessao.Get_ArquivosFTPEnvio: IArquivosFTPEnvio;
begin
  Result := FArquivosFTPEnvio;
end;

function TSessao.InicializarArquivosFTPEnvio: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarArquivosFTPEnvio', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarArquivosFTPEnvio;
  FArquivosFTPEnvio := TArquivosFTPEnvio.Create;
  FArquivosFTPEnvio.ObjAddRef;
  Result := FArquivosFTPEnvio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarArquivosFTPEnvio;
begin
  If FArquivosFTPEnvio <> nil Then Begin
    FArquivosFTPEnvio.ObjRelease;
    FArquivosFTPEnvio := nil;
  End;
end;

function TSessao.Get_OcorrenciasSistema: IOcorrenciasSistema;
begin
  Result := FOcorrenciasSistema;
end;

procedure TSessao.FinalizarOcorrenciasSistema;
begin
  If FOcorrenciasSistema <> nil Then Begin
    FOcorrenciasSistema.ObjRelease;
    FOcorrenciasSistema := nil;
  End;
end;

function TSessao.InicializarOcorrenciasSistema: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarOcorrenciasSistema', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarOcorrenciasSistema;
  FOcorrenciasSistema := TOcorrenciasSistema.Create;
  FOcorrenciasSistema.ObjAddRef;
  Result := FOcorrenciasSistema.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_FormasPagamentoIdentificador: IFormasPagamentoIdentificador;
begin
  Result := FFormasPagamentoIdentificador;
end;

procedure TSessao.FinalizarFormasPagamentoIdentificador;
begin
  If FFormasPagamentoIdentificador <> nil Then Begin
    FFormasPagamentoIdentificador.ObjRelease;
    FFormasPagamentoIdentificador := nil;
  End;
end;

function TSessao.InicializarFormasPagamentoIdentificador: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarFormasPagamentoIdentificador', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarFormasPagamentoIdentificador;
  FFormasPagamentoIdentificador := TFormasPagamentoIdentificador.Create;
  FFormasPagamentoIdentificador.ObjAddRef;
  Result := FFormasPagamentoIdentificador.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_FormasPagamentoOS: IFormasPagamentoOS;
begin
  Result := FFormasPagamentoOS;
end;

procedure TSessao.FinalizarFormasPagamentoOS;
begin
  If FFormasPagamentoOS <> nil Then Begin
    FFormasPagamentoOS.ObjRelease;
    FFormasPagamentoOS := nil;
  End;
end;

function TSessao.InicializarFormasPagamentoOS: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarFormasPagamentoOS', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarFormasPagamentoOS;
  FFormasPagamentoOS := TFormasPagamentoOS.Create;
  FFormasPagamentoOS.ObjAddRef;
  Result := FFormasPagamentoOS.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_FabricantesIdentificador: IFabricantesIdentificador;
begin
  Result := FFabricantesIdentificador;
end;

procedure TSessao.FinalizarFabricantesIdentificador;
begin
  If FFabricantesIdentificador <> nil Then Begin
    FFabricantesIdentificador.ObjRelease;
    FFabricantesIdentificador := nil;
  End;
end;

function TSessao.InicializarFabricantesIdentificador: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarFabricantesIdentificador', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarFabricantesIdentificador;
  FFabricantesIdentificador := TFabricantesIdentificador.Create;
  FFabricantesIdentificador.ObjAddRef;
  Result := FFabricantesIdentificador.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_IdentificacoesDuplas: IIdentificacoesDuplas;
begin
  Result := FIdentificacoesDuplas;
end;

procedure TSessao.FinalizarIdentificacoesDuplas;
begin
  If FIdentificacoesDuplas <> nil Then Begin
    FIdentificacoesDuplas.ObjRelease;
    FIdentificacoesDuplas := nil;
  End;
end;

function TSessao.InicializarIdentificacoesDuplas: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarIdentificacoesDuplas', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarIdentificacoesDuplas;
  FIdentificacoesDuplas := TIdentificacoesDuplas.Create;
  FIdentificacoesDuplas.ObjAddRef;
  Result := FIdentificacoesDuplas.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_ProdutosAcessorios: IProdutosAcessorios;
begin
  Result := FProdutosAcessorios;
end;

procedure TSessao.FinalizarProdutosAcessorios;
begin
  If FProdutosAcessorios <> nil Then Begin
    FProdutosAcessorios.ObjRelease;
    FProdutosAcessorios := nil;
  End;
end;

function TSessao.InicializarProdutosAcessorios: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarProdutosAcessorios', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarProdutosAcessorios;
  FProdutosAcessorios := TProdutosAcessorios.Create;
  FProdutosAcessorios.ObjAddRef;
  Result := FProdutosAcessorios.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_SituacoesOS: ISituacoesOS;
begin
  Result := FSituacoesOS;
end;

procedure TSessao.FinalizarSituacoesOS;
begin
  If FSituacoesOS <> nil Then Begin
    FSituacoesOS.ObjRelease;
    FSituacoesOS := nil;
  End;
end;

function TSessao.InicializarSituacoesOS: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesOS', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesOS;
  FSituacoesOS := TSituacoesOS.Create;
  FSituacoesOS.ObjAddRef;
  Result := FSituacoesOS.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_ArquivosRemessaPedido: IArquivosRemessaPedido;
begin
  Result := FArquivosRemessaPedido;
end;

procedure TSessao.FinalizarArquivosRemessaPedido;
begin
  If FArquivosRemessaPedido <> nil Then Begin
    FArquivosRemessaPedido.ObjRelease;
    FArquivosRemessaPedido := nil;
  End;
end;

function TSessao.InicializarArquivosRemessaPedido: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarArquivosRemessaPedido', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarArquivosRemessaPedido;
  FArquivosRemessaPedido := TArquivosRemessaPedido.Create;
  FArquivosRemessaPedido.ObjAddRef;
  Result := FArquivosRemessaPedido.Inicializar(FConexao, FMensagens);
end;


function TSessao.Get_OrdensServico: IOrdensServico;
begin
  Result := FOrdensServico;
end;

function TSessao.InicializarOrdensServico: Integer;
begin
  // Verifica se Sessão está ativa
  If not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesOS',
      [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarOrdensServico;
  FOrdensServico := TOrdensServico.Create;
  FOrdensServico.ObjAddRef;
  Result := FOrdensServico.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarOrdensServico;
begin
  if FOrdensServico <> nil then
  begin
    FOrdensServico.ObjRelease;
    FOrdensServico := nil;
  end;
end;

function TSessao.Get_ArquivosFTPRetorno: IArquivosFTPRetorno;
begin
  Result := FArquivosFTPRetorno;
end;

function TSessao.InicializarArquivosFTPRetorno: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarArquivosFTPRetorno', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarArquivosFTPRetorno;
  FArquivosFTPRetorno := TArquivosFTPRetorno.Create;
  FArquivosFTPRetorno.ObjAddRef;
  Result := FArquivosFTPRetorno.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarArquivosFTPRetorno;
begin
  If FArquivosFTPRetorno <> nil Then Begin
    FArquivosFTPRetorno.ObjRelease;
    FArquivosFTPRetorno := nil;
  End;
end;

function TSessao.Get_Enderecos: IEnderecos;
begin
  Result := FEnderecos;
end;

function TSessao.InicializarEnderecos: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEnderecos', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEnderecos;
  FEnderecos := TEnderecos.Create;
  FEnderecos.ObjAddRef;
  Result := FEnderecos.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEnderecos;
begin
  If FEnderecos <> nil Then Begin
    FEnderecos.ObjRelease;
    FEnderecos := nil;
  End;
end;

function TSessao.Get_RotinasFTPRetorno: IRotinasFTPRetorno;
begin
  Result := FRotinasFTPRetorno;
end;

function TSessao.InicializarRotinasFTPRetorno: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRotinasFTPRetorno', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarRotinasFTPRetorno;
  FRotinasFTPRetorno := TRotinasFTPRetorno.Create;
  FRotinasFTPRetorno.ObjAddRef;
  Result := FRotinasFTPRetorno.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarRotinasFTPRetorno;
begin
  If FRotinasFTPRetorno <> nil Then Begin
    FRotinasFTPRetorno.ObjRelease;
    FRotinasFTPRetorno := nil;
  End;
end;

function TSessao.Get_EmailsEnvio: IEmailsEnvio;
begin
  Result := FEmailsEnvio;
end;

function TSessao.InicializarEmailsEnvio: Integer;
begin
  // Verifica se Sessão está ativa
  If Not FAtiva Then Begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarEmailsEnvio', [Self.ClassName]);
    Result := -1;
    Exit;
  End;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarEmailsEnvio;
  FEmailsEnvio := TEmailsEnvio.Create;
  FEmailsEnvio.ObjAddRef;
  Result := FEmailsEnvio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarEmailsEnvio;
begin
  If FEmailsEnvio <> nil Then Begin
    FEmailsEnvio.ObjRelease;
    FEmailsEnvio := nil;
  End;
end;

function TSessao.Get_SituacoesCodigoSISBOV: ISituacoesCodigoSISBOV;
begin
  Result := FSituacoesCodigoSISBOV;
end;

function TSessao.InicializarSituacoesCodigoSISBOV: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesCodigoSISBOV', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesCodigoSISBOV;
  FSituacoesCodigoSISBOV := TSituacoesCodigoSISBOV.Create;
  FSituacoesCodigoSISBOV.ObjAddRef;
  Result := FSituacoesCodigoSISBOV.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesCodigoSISBOV;
begin
  if FSituacoesCodigoSISBOV <> nil then begin
    FSituacoesCodigoSISBOV.ObjRelease;
    FSituacoesCodigoSISBOV := nil;
  end;
end;

function TSessao.Get_SituacoesEmail: ISituacoesEmail;
begin
  Result := FSituacoesEmail;
end;

function TSessao.Get_TiposEmail: ITiposEmail;
begin
  Result := FTiposEmail;
end;

function TSessao.InicializarSituacoesEmail: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesEmail', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesEmail;
  FSituacoesEmail := TSituacoesEmail.Create;
  FSituacoesEmail.ObjAddRef;
  Result := FSituacoesEmail.Inicializar(FConexao, FMensagens);
end;

function TSessao.InicializarTiposEmail: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposEmail', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposEmail;
  FTiposEmail := TTiposEmail.Create;
  FTiposEmail.ObjAddRef;
  Result := FTiposEmail.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesEmail;
begin
  if FSituacoesEmail <> nil then begin
    FSituacoesEmail.ObjRelease;
    FSituacoesEmail := nil;
  end;
end;

procedure TSessao.FinalizarTiposEmail;
begin
  if FTiposEmail <> nil then begin
    FTiposEmail.ObjRelease;
    FTiposEmail := nil;
  end;
end;

function TSessao.Get_SituacoesFTP: ISituacoesFTP;
begin
   Result := FSituacoesFTP;
end;

function TSessao.InicializarSituacoesFTP: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesFTP', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesFTP;
  FSituacoesFTP := TSituacoesFTP.Create;
  FSituacoesFTP.ObjAddRef;
  Result := FSituacoesFTP.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesFTP;
begin
  if FSituacoesFTP <> nil then begin
    FSituacoesFTP.ObjRelease;
    FSituacoesFTP := nil;
  end;
end;

function TSessao.InicializarTiposMensagem: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposMensagem', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposMensagem;
  FTiposMensagem := TTiposMensagem.Create;
  FTiposMensagem.ObjAddRef;
  Result := FTiposMensagem.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposMensagem;
begin
  if FTiposMensagem <> nil then begin
    FTiposMensagem.ObjRelease;
    FTiposMensagem := nil;
  end;
end;

function TSessao.Get_TiposMensagem: ITiposMensagem;
begin
  Result := FTiposMensagem;
end;

function TSessao.Get_RotinasFTPEnvio: IRotinasFTPEnvio;
begin
  Result := FRotinasFTPEnvio;
end;

function TSessao.InicializarRotinasFTPEnvio: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarRotinasFTPEnvio', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarRotinasFTPEnvio;
  FRotinasFTPEnvio := TRotinasFTPEnvio.Create;
  FRotinasFTPEnvio.ObjAddRef;
  Result := FRotinasFTPEnvio.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarRotinasFTPEnvio;
begin
  if FRotinasFTPEnvio <> nil then begin
    FRotinasFTPEnvio.ObjRelease;
    FRotinasFTPEnvio := nil;
  end;
end;

function TSessao.Get_Aplicativos: IAplicativos;
begin
   Result := FAplicativos;
end;

function TSessao.InicializarAplicativos: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarAplicativos', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarAplicativos;
  FAplicativos := TAplicativos.Create;
  FAplicativos.ObjAddRef;
  Result := FAplicativos.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarAplicativos;
begin
  if FAplicativos <> nil then begin
    FAplicativos.ObjRelease;
    FAplicativos := nil;
  end;
end;

function TSessao.Get_ImportacoesFabricante: IImportacoesFabricante;
begin
   Result := FImportacoesFabricante;
end;

function TSessao.InicializarImportacoesFabricante: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarImportacoesFabricante',
      [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarImportacoesFabricantes;
  FImportacoesFabricante := TImportacoesFabricante.Create;
  FImportacoesFabricante.ObjAddRef;
  Result := FImportacoesFabricante.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarImportacoesFabricantes;
begin
  if FImportacoesFabricante <> nil then begin
    FImportacoesFabricante.ObjRelease;
    FImportacoesFabricante := nil;
  end;
end;

function TSessao.Get_SituacoesArqImport: ISituacoesArqImport;
begin
  Result := FSituacoesArqImport;
end;

function TSessao.InicializarSituacoesArqImport: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSituacoesArqImport', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSituacoesArqImport;
  FSituacoesArqImport := TSituacoesArqImport.Create;
  FSituacoesArqImport.ObjAddRef;
  Result := FSituacoesArqImport.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSituacoesArqImport;
begin
  if FSituacoesArqImport <> nil then begin
    FSituacoesArqImport.ObjRelease;
    FSituacoesArqImport := nil;
  end;
end;

function TSessao.InicializarMenus: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarMenus', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarMenus;
  FMenus := TMenus.Create;
  FMenus.ObjAddRef;
  Result := FMenus.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarMenus;
begin
  if FMenus <> nil then begin
    FMenus.ObjRelease;
    FMenus := nil;
  end;
end;

function TSessao.Get_Menus: IMenus;
begin
  Result := FMenus;
end;

function TSessao.ImportarCargaInicial(CodTipoArquivo: Integer;
  const NomeCompletoArquivo: WideString): Integer;
var
  CargaInicial: TIntCargaInicial;
begin
  CargaInicial := TIntCargaInicial.Create;
  try
    CargaInicial.Inicializar(FConexao, FMensagens);
    case CodTipoArquivo of
      1: Result := CargaInicial.ImportarPropriedades(NomeCompletoArquivo);
      2: Result := CargaInicial.ImportarCodigosSISBOV(NomeCompletoArquivo);
      3: Result := CargaInicial.ImportarAnimais(NomeCompletoArquivo);
    else
      Result := -1;
    end;
  finally
    CargaInicial.Free;
  end;
end;

function TSessao.Get_BoletosBancario: IBoletosBancario;
begin
  Result := FBoletosBancario;
end;

function TSessao.InicializarBoletosBancario: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarBoletosBancario', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarBoletosBancario;
  FBoletosBancario := TBoletosBancario.Create;
  FBoletosBancario.ObjAddRef;
  Result := FBoletosBancario.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarBoletosBancario;
begin
  if FBoletosBancario <> nil then
  begin
    FBoletosBancario.ObjRelease;
    FBoletosBancario := nil;
  end;
end;

function TSessao.InicializarIdentificacoesBancarias: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarIdentificacoesBancarias', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarIdentificacoesBancarias;
  FIdentificacoesBancarias := TIdentificacoesBancarias.Create;
  FIdentificacoesBancarias.ObjAddRef;
  Result := FIdentificacoesBancarias.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarIdentificacoesBancarias;
begin
  if FIdentificacoesBancarias <> nil then
  begin
    FIdentificacoesBancarias.ObjRelease;
    FIdentificacoesBancarias := nil;
  end;
end;

function TSessao.Get_IdentificacoesBancarias: IIdentificacoesBancarias;
begin
  Result := FIdentificacoesBancarias;
end;

function TSessao.InicializarDownloads: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarDownloads', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarDownloads;
  FDownloads := TDownloads.Create;
  FDownloads.ObjAddRef;
  Result := FDownloads.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarDownloads;
begin
  if FDownloads <> nil then
  begin
    FDownloads.ObjRelease;
    FDownloads := nil;
  end;
end;

function TSessao.Get_Downloads: IDownloads;
begin
  Result := FDownloads;
end;

function TSessao.Get_TiposPropriedades: ITiposPropriedades;
begin
  Result := FTiposPropriedades;
end;

function TSessao.InicializarTiposPropriedades: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTiposPropriedades', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTiposPropriedades;
  FTiposPropriedades := TTiposPropriedades.Create;
  FTiposPropriedades.ObjAddRef;
  Result := FTiposPropriedades.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTiposPropriedades;
begin
  if FTiposPropriedades <> nil then
  begin
    FTiposPropriedades.ObjRelease;
    FTiposPropriedades := nil;
  end;
end;

function TSessao.InicializarInventariosAnimais: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InventariosAnimais', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarInventariosAnimais;
  FInventariosAnimais := TInventariosAnimais.Create;
  FInventariosAnimais.ObjAddRef;
  Result := FInventariosAnimais.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarInventariosAnimais;
begin
  if FInventariosAnimais <> nil then begin
    FInventariosAnimais.ObjRelease;
    FInventariosAnimais := nil;
  end;
end;

function TSessao.Get_InventariosAnimais: IInventariosAnimais;
begin
  Result := FInventariosAnimais;
end;

procedure TSessao.FinalizarInventariosCodigosSisbov;
begin
  if FInventariosCodigosSisbov <> nil then begin
    FInventariosCodigosSisbov.ObjRelease;
    FInventariosCodigosSisbov := nil;
  end;
end;

function TSessao.Get_InventariosCodigosSisbov: IInventariosCodigosSisbov;
begin
  Result := FInventariosCodigosSisbov;
end;

function TSessao.InicializarInventariosCodigosSisbov: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'InventariosCodigosSisbov', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarInventariosCodigosSisbov;
  FInventariosCodigosSisbov := TInventariosCodigosSisbov.Create;
  FInventariosCodigosSisbov.ObjAddRef;
  Result := FInventariosCodigosSisbov.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.AdicionarMensagemCustomizada(Codigo: Integer;
  const Texto, Classe, Metodo: WideString; Tipo: Integer);
begin
    FMensagens.Adicionar(Codigo, Classe, Metodo, [Texto]);
end;

function TSessao.Get_TmpAplicaEvento: ITmpAplicaEvento;
begin
  Result := FTmpAplicaEvento;
end;

procedure TSessao.FinalizarTmpAplicaEvento;
begin
  If FTmpAplicaEvento <> nil Then Begin
    FTmpAplicaEvento.ObjRelease;
    FTmpAplicaEvento := nil;
  End;
end;

function TSessao.InicializarTmpAplicaEvento: Integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then begin
    FMensagens.Adicionar(8, Self.ClassName, 'TmpAplicaEvento', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTmpAplicaEvento;
  FTmpAplicaEvento := TTmpAplicaEvento.Create;
  FTmpAplicaEvento.ObjAddRef;
  Result := FTmpAplicaEvento.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarTipoPropriedades;
begin
  If FTipoPropriedades <> nil Then Begin
    FTipoPropriedades.ObjRelease;
    FTipoPropriedades := nil;
  End;
end;

function TSessao.inicializarTipoPropriedades: integer;
begin
  // Verifica se Sessão está ativa
  if not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarTipoPropriedades', [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarTipoPropriedades;
  FTipoPropriedades := TTipoPropriedades.Create;
  FTipoPropriedades.ObjAddRef;
  Result := FTipoPropriedades.Inicializar(FConexao, FMensagens);
end;

function TSessao.Get_TipoPropriedades: ITipoPropriedades;
begin
  result  :=  FTipoPropriedades;
end;

function TSessao.Get_SolicitacaoReimpressao: ISolicitacaoReimpressao;
begin
  Result := FSolicitacaoReimpressao;
end;

function TSessao.InicializarSolicitacaoReimpressao: Integer;
begin
  If not FAtiva then
  begin
    FMensagens.Adicionar(8, Self.ClassName, 'InicializarSolicitacaoReimpressao',
      [Self.ClassName]);
    Result := -1;
    Exit;
  end;

  // Finaliza Objeto (só finaliza se já houver sido inicializado)
  FinalizarSolicitacaoReimpressao;
  FSolicitacaoReimpressao := TSolicitacaoReimpressao.Create;
  FSolicitacaoReimpressao.ObjAddRef;
  Result := FSolicitacaoReimpressao.Inicializar(FConexao, FMensagens);
end;

procedure TSessao.FinalizarSolicitacaoReimpressao;
begin
  if FSolicitacaoReimpressao <> nil then
  begin
    FSolicitacaoReimpressao.ObjRelease;
    FSolicitacaoReimpressao := nil;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSessao, Class_Sessao,
    ciMultiInstance, tmApartment);
end.

