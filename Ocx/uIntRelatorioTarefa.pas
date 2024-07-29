unit uIntRelatorioTarefa;

interface

uses
  Classes, uConexao, uIntMensagens, uIntAnimais, uIntCodigosSISBOV, uIntFazendas,
  ActiveX, uIntEventos;

type
  TVariantArray = Array of Variant;
  TVariantArrayPtr = ^TVariantArray;

  TThrRelatorioTarefa = class(TThread)
  private
    FCodTarefa: Integer;
    FCodTipoTarefa: Integer;
    FParametros: Array of Variant;
    FConexao: TConexao;
    FMensagens: TIntMensagens;
    FNomArquivo: String;

    function getParametro(Index: Integer): Variant;
    function GerarConsolidadoAnimais(): Integer;
    function GerarConsolidadoCodigosSISBOV(): Integer;
    function GerarConsolidadoFazendas(): Integer;
    function GerarConsolidadoEventos(): Integer;
    function GerarPesosAjustados(): Integer;
    function GerarPesagemAnimais(): Integer;
    function GerarAvaliacaoAnimais(): Integer;
    function GerarPrevisaoParto(): Integer;
    function GerarFemeasDiagnosticar(): Integer;
    function GerarDesempenhoVacas(): Integer;
    function GerarResumoEstacaoMonta(): Integer;
    function GerarConsolidacaoCodigosSISBOV(): Integer;
    function GerarArquivoExportacaoABCZ(): Integer;
    function GetRetorno(): Integer;
  protected
    procedure Execute; override;
  public
    constructor CreateTarefa(CodTarefa: Integer; Parametros: Array of Variant;
      Conexao: TConexao; Mensagens: TIntMensagens; CodTipoTarefa: Integer);
    property Parametro[Index: Integer]: Variant read getParametro;
    property CodTarefa: Integer read FCodTarefa;
    property CodTipoTarefa: Integer read FCodTipoTarefa;
    property NomArquivo: String read FNomArquivo;
    property Retorno: Integer read GetRetorno;
  end;

const
  CONSOLIDADO_ANIMAIS         = 3;
  CONSOLIDADO_EVENTOS         = 4;
  CONSOLIDADO_FAZENDAS        = 6;
  PESOS_AJUSTADOS             = 10;
  PESAGEM_ANIMAIS             = 11;
  CONSOLIDADO_CODIGOS_SISBOV  = 12;
  AVALIACAO_ANIMAIS           = 16;
  PREVISAO_PARTO              = 18;
  FEMEAS_DIAGNOSTICAR         = 19;
  DESEMPENHO_VACAS            = 20;
  RESUMO_ESTACAO_MONTA        = 28;
  CONSOLIDACAO_CODIGOS_SISBOV = 29;

implementation

uses SysUtils, Variants, ComObj;

{ TThrRelatorioTarefa }

constructor TThrRelatorioTarefa.CreateTarefa(CodTarefa: Integer;
  Parametros: Array of Variant; Conexao: TConexao; Mensagens: TIntMensagens; CodTipoTarefa: Integer);
var
  iAux: Integer;
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FCodTarefa := CodTarefa;
  FCodTipoTarefa := CodTipoTarefa;
  SetLength(FParametros, Length(Parametros));
  for iAux := 0 to Length(Parametros)-1 do begin
    FParametros[iAux] := Parametros[iAux];
  end;
  FConexao := Conexao;
  FMensagens := Mensagens;
  Priority := tpLowest;
  Suspended := False;
end;

function TThrRelatorioTarefa.getParametro(Index: Integer): Variant;
begin
  Result := FParametros[Index];
end;

function TThrRelatorioTarefa.GerarConsolidadoAnimais: Integer;
const
  cpSglProdutor:                       Integer = 1;
  cpNomPessoaProdutor:                 Integer = 2;
  cpCodSituacaoSisbov:                 Integer = 3;
  cpDtaNascimentoInicio:               Integer = 4;
  cpDtaNascimentoFim:                  Integer = 5;
  cpDtaIdentificacaoInicio:            Integer = 6;
  cpDtaIdentifcacaoFim:                Integer = 7;
  cpCodMicroRegiaoSisbovNascimento:    Integer = 8;
  cpNomMicroRegiaoNascimento:          Integer = 9;
  cpCodEstadoNascimento:               Integer = 10;
  cpNumImovelNascimento:               Integer = 11;
  cpCodLocalizacaoNascimento:          Integer = 12;
  cpCodMicroRegiaoSisbovIdentificacao: Integer = 13;
  cpNomMicroRegiaoIdentificacao:       Integer = 14;
  cpCodEstadoIdentificacao:            Integer = 15;
  cpNumImovelIdentificacao:            Integer = 16;
  cpCodLocalizacaoIdentificacao:       Integer = 17;
  cpDtaCompraInicio:                   Integer = 18;
  cpDtaCompraFim:                      Integer = 19;
  cpCodRaca:                           Integer = 20;
  cpIndSexo:                           Integer = 21;
  cpCodOrigem:                         Integer = 22;
  cpIndAnimalCastrado:                 Integer = 23;
  cpCodRegimeAlimentar:                Integer = 24;
  cpCodCategoria:                      Integer = 25;
  cpCodAssociacaoRaca:                 Integer = 26;
  cpCodGrauSangue:                     Integer = 27;
  cpCodTipoLugar:                      Integer = 28;
  cpNumImovelCorrente:                 Integer = 29;
  cpCodLocalizacaoCorrente:            Integer = 30;
  cpNumCNPJCPFCorrente:                Integer = 31;
  cpNomPaisOrigem:                     Integer = 32;
  cpIndAgrupRaca1:                     Integer = 33;
  cpCodRaca1:                          Integer = 34;
  cpQtdCompRacialInicio1:              Integer = 35;
  cpQtdCompRacialFim1:                 Integer = 36;
  cpIndAgrupRaca2:                     Integer = 37;
  cpCodRaca2:                          Integer = 38;
  cpQtdCompRacialInicio2:              Integer = 39;
  cpQtdCompRacialFim2:                 Integer = 40;
  cpIndAgrupRaca3:                     Integer = 41;
  cpCodRaca3:                          Integer = 42;
  cpQtdCompRacialInicio3:              Integer = 43;
  cpQtdCompRacialFim3:                 Integer = 44;
  cpIndAgrupRaca4:                     Integer = 45;
  cpCodRaca4:                          Integer = 46;
  cpQtdCompRacialInicio4:              Integer = 47;
  cpQtdCompRacialFim4:                 Integer = 48;
  cpIndAptoCobertura:                  Integer = 49;
  cpDtaInicioCertificado:              Integer = 50;
  cpDtaFimCertificado:                 Integer = 51;
  cpDtaInicioCadastramento:            Integer = 52;
  cpDtaFimCadastramento:               Integer = 53;
  cpTipo:                              Integer = 54;
  cpQtdQuebraRelatorio:                Integer = 55;
  cpNumCNPJCPFTecnico:                 Integer = 56;
  cpIndAnimalSemTecnico:               Integer = 57;
  cpIndAnimalCompradoComEvento:        Integer = 58;
  cpDtaInicioCadastramentoHerdom:      Integer = 59;
  cpDtaFimCadastramentoHerdom:         Integer = 60;
const
  NomeMetodo: String = 'GerarConsolidadoAnimais';
var
  IntAnimais: TIntAnimais;
begin
  FNomArquivo := '';
  IntAnimais := TIntAnimais.Create;

  try
    Result := IntAnimais.Inicializar(FConexao, FMensagens);
    if Result < 0 then
    begin
      Exit;
    end;
    FNomArquivo := IntAnimais.GerarRelatorioConsolidado(Parametro[cpSglProdutor],
                                                        Parametro[cpNomPessoaProdutor],
                                                        Parametro[cpCodSituacaoSisbov],
                                                        Parametro[cpDtaNascimentoInicio],
                                                        Parametro[cpDtaNascimentoFim],
                                                        Parametro[cpDtaIdentificacaoInicio],
                                                        Parametro[cpDtaIdentifcacaoFim],
                                                        Parametro[cpCodMicroRegiaoSisbovNascimento],
                                                        Parametro[cpNomMicroRegiaoNascimento],
                                                        Parametro[cpCodEstadoNascimento],
                                                        Parametro[cpNumImovelNascimento],
                                                        Parametro[cpCodLocalizacaoNascimento],
                                                        Parametro[cpCodMicroRegiaoSisbovIdentificacao],
                                                        Parametro[cpNomMicroRegiaoIdentificacao],
                                                        Parametro[cpCodEstadoIdentificacao],
                                                        Parametro[cpNumImovelIdentificacao],
                                                        Parametro[cpCodLocalizacaoIdentificacao],
                                                        Parametro[cpDtaCompraInicio],
                                                        Parametro[cpDtaCompraFim],
                                                        Parametro[cpCodRaca],
                                                        Parametro[cpIndSexo],
                                                        Parametro[cpCodOrigem],
                                                        Parametro[cpIndAnimalCastrado],
                                                        Parametro[cpCodRegimeAlimentar],
                                                        Parametro[cpCodCategoria],
                                                        Parametro[cpCodAssociacaoRaca],
                                                        Parametro[cpCodGrauSangue],
                                                        Parametro[cpCodTipoLugar],
                                                        Parametro[cpNumImovelCorrente],
                                                        Parametro[cpCodLocalizacaoCorrente],
                                                        Parametro[cpNumCNPJCPFCorrente],
                                                        Parametro[cpNomPaisOrigem],
                                                        Parametro[cpIndAgrupRaca1],
                                                        Parametro[cpCodRaca1],
                                                        Parametro[cpQtdCompRacialInicio1],
                                                        Parametro[cpQtdCompRacialFim1],
                                                        Parametro[cpIndAgrupRaca2],
                                                        Parametro[cpCodRaca2],
                                                        Parametro[cpQtdCompRacialInicio2],
                                                        Parametro[cpQtdCompRacialFim2],
                                                        Parametro[cpIndAgrupRaca3],
                                                        Parametro[cpCodRaca3],
                                                        Parametro[cpQtdCompRacialInicio3],
                                                        Parametro[cpQtdCompRacialFim3],
                                                        Parametro[cpIndAgrupRaca4],
                                                        Parametro[cpCodRaca4],
                                                        Parametro[cpQtdCompRacialInicio4],
                                                        Parametro[cpQtdCompRacialFim4],
                                                        Parametro[cpIndAptoCobertura],
                                                        Parametro[cpDtaInicioCertificado],
                                                        Parametro[cpDtaFimCertificado],
                                                        Parametro[cpDtaInicioCadastramento],
                                                        Parametro[cpDtaFimCadastramento],
                                                        Parametro[cpTipo],
                                                        Parametro[cpQtdQuebraRelatorio],
                                                        Parametro[cpNumCNPJCPFTecnico],
                                                        Parametro[cpIndAnimalSemTecnico],
                                                        Parametro[cpIndAnimalCompradoComEvento],
                                                        FCodTarefa,
                                                        Parametro[cpDtaInicioCadastramentoHerdom],
                                                        Parametro[cpDtaFimCadastramentoHerdom]);

    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntAnimais.Free;
  end;
end;

function TThrRelatorioTarefa.GerarConsolidadoCodigosSISBOV: Integer;
const
  cpCodEstado: Integer = 1;
  cpSglProdutor: Integer = 2;
  cpNomPessoaProdutor: Integer = 3;
  cpNumCNPJCPFProdutor: Integer = 4;
  cpNumImovelReceitaFederal: Integer = 5;
  cpCodLocalizacaoSisbov: Integer = 6;
  cpNomPropriedadeRural: Integer = 7;
  cpNomMunicipioPropriedadeRural: Integer = 8;
  cpDtaSolicitacaoSISBOVInicio: Integer = 9;
  cpDtaSolicitacaoSISBOVFim: Integer = 10;
  cpDtaInsercaoInicio: Integer = 11;
  cpDtaInsercaoFim: Integer = 12;
  cpDtaUtilizacaoInicio: Integer = 13;
  cpDtaUtilizacaoFim: Integer = 14;
  cpDtaLiberacaoAbateInicio: Integer = 15;
  cpDtaLiberacaoAbateFim: Integer = 16;
  cpDtaExpiracaoInicio: Integer = 17;
  cpDtaExpiracaoFim: Integer = 18;
  cpCodSituacoesCodigoSISBOV: Integer = 19;
  cpQtdQuebraRelatorio: Integer = 20;
  cpTipo: Integer = 21;
var
  IntCodigosSISBOV: TIntCodigosSISBOV;
begin
  IntCodigosSISBOV := TIntCodigosSisbov.Create;
  try
    Result := IntCodigosSISBOV.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;

    FNomArquivo := IntCodigosSISBOV.GerarRelatorioConsolidado(
      Parametro[cpCodEstado],
      Parametro[cpSglProdutor],
      Parametro[cpNomPessoaProdutor],
      Parametro[cpNumCNPJCPFProdutor],
      Parametro[cpNumImovelReceitaFederal],
      Parametro[cpCodLocalizacaoSisbov],      
      Parametro[cpNomPropriedadeRural],
      Parametro[cpNomMunicipioPropriedadeRural],
      Parametro[cpDtaSolicitacaoSISBOVInicio],
      Parametro[cpDtaSolicitacaoSISBOVFim],
      Parametro[cpDtaInsercaoInicio],
      Parametro[cpDtaInsercaoFim],
      Parametro[cpDtaUtilizacaoInicio],
      Parametro[cpDtaUtilizacaoFim],
      Parametro[cpDtaLiberacaoAbateInicio],
      Parametro[cpDtaLiberacaoAbateFim],
      Parametro[cpDtaExpiracaoInicio],
      Parametro[cpDtaExpiracaoFim],
      Parametro[cpCodSituacoesCodigoSISBOV],
      Parametro[cpQtdQuebraRelatorio],
      Parametro[cpTipo],
      FCodTarefa);

    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntCodigosSISBOV.Free;
  end;
end;

procedure TThrRelatorioTarefa.Execute;
const
  NomMetodo: String = 'Execute';
  cpCodRelatorio: Integer = 0;
var
  CodRelatorio: Integer;
begin
  try
    if (FCodTipoTarefa = 8) then
    begin
      ReturnValue := GerarArquivoExportacaoABCZ();
    end
    else
      begin
        CodRelatorio := Parametro[cpCodRelatorio];
        case CodRelatorio of
          CONSOLIDADO_ANIMAIS         : ReturnValue := GerarConsolidadoAnimais();
          CONSOLIDADO_CODIGOS_SISBOV  : ReturnValue := GerarConsolidadoCodigosSISBOV();
          CONSOLIDADO_FAZENDAS        : ReturnValue := GerarConsolidadoFazendas();
          CONSOLIDADO_EVENTOS         : ReturnValue := GerarConsolidadoEventos();
          PESOS_AJUSTADOS             : ReturnValue := GerarPesosAjustados();
          PESAGEM_ANIMAIS             : ReturnValue := GerarPesagemAnimais();
          AVALIACAO_ANIMAIS           : ReturnValue := GerarAvaliacaoAnimais();
          PREVISAO_PARTO              : ReturnValue := GerarPrevisaoParto();
          FEMEAS_DIAGNOSTICAR         : ReturnValue := GerarFemeasDiagnosticar();
          DESEMPENHO_VACAS            : ReturnValue := GerarDesempenhoVacas();
          RESUMO_ESTACAO_MONTA        : ReturnValue := GerarResumoEstacaoMonta();
          CONSOLIDACAO_CODIGOS_SISBOV : ReturnValue := GerarConsolidacaoCodigosSISBOV();
          else
          begin
            raise Exception.CreateFmt(
              'A implementação do relatório [ %s ] não foi realizada para ser ' +
              'executada como tarefa ', [IntToStr(CodRelatorio)]);
          end;
        end;
      end;
  except
    on E: Exception do
    begin
      FMensagens.Adicionar(1996, Self.ClassName, NomMetodo, [E.Message]);
      ReturnValue := -1996;
      Exit;
    end;
  end;
end;

function TThrRelatorioTarefa.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

function TThrRelatorioTarefa.GerarConsolidadoFazendas: Integer;
const
  cpSglProdutor:              Integer = 1;
  cpNomPessoaProdutor:        Integer = 2;
  cpSglFazenda:               Integer = 3;
  cpNomFazenda:               Integer = 4;
  cpCodSituacaoSISBOVFazenda: Integer = 5;
  cpIndSituacaoImagemFazenda: Integer = 6;
  cpNomPropriedadeRural:      Integer = 7;
  cpNumImovelReceitaFederal:  Integer = 8;
  cpCodLocalizacaoSisbov:     Integer = 9;
  cpCodEstado:                Integer = 10;
  cpNomMunicipio:             Integer = 11;
  cpCodMicroRegiao:           Integer = 12;
  cpQtdPropriedadeRural:      Integer = 13;
  cpQtdFazenda:               Integer = 14;
  cpQtdAnimal:                Integer = 15;
  cpDtaInicioCadastramento:   Integer = 16;
  cpDtaFimCadastramento:      Integer = 17;
  cpTipo:                     Integer = 18;
  cpQtdQuebraRelatorio:       Integer = 19;
  cpDtaInicioVistoria:        Integer = 20;
  cpDtaFimVistoria:           Integer = 21;
var
  IntFazendas: TIntFazendas;
begin
  FNomArquivo := '';
  IntFazendas := TIntFazendas.Create;
  try
    Result := IntFazendas.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntFazendas.GerarRelatorio(Parametro[cpSglProdutor],
                                              Parametro[cpNomPessoaProdutor],
                                              Parametro[cpSglFazenda],
                                              Parametro[cpNomFazenda],
                                              Parametro[cpCodSituacaoSISBOVFazenda],
                                              Parametro[cpIndSituacaoImagemFazenda],
                                              Parametro[cpNomPropriedadeRural],
                                              Parametro[cpNumImovelReceitaFederal],
                                              Parametro[cpCodLocalizacaoSisbov],
                                              Parametro[cpCodEstado],
                                              Parametro[cpNomMunicipio],
                                              Parametro[cpCodMicroRegiao],
                                              Parametro[cpDtaInicioCadastramento],
                                              Parametro[cpDtaFimCadastramento],
                                              Parametro[cpTipo],
                                              Parametro[cpQtdQuebraRelatorio],
                                              FCodTarefa,
                                              Parametro[cpDtaInicioVistoria],
                                              Parametro[cpDtaFimVistoria]
                                             );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntFazendas.Free;
  end;
end;

function TThrRelatorioTarefa.GerarConsolidadoEventos: Integer;
const
  cpSglProdutor:               Integer = 1;
  cpNomPessoaProdutor:         Integer = 2;
  cpCodSituacaoSisbov:         Integer = 3;
  cpCodGrupoEvento:            Integer = 4;
  cpCodTipoEvento:             Integer = 5;
  cpCodTipoSubEventoSanitario: Integer = 6;
  cpDtaInicio:                 Integer = 7;
  cpDtaFim:                    Integer = 8;
  cpTxtDados:                  Integer = 9;
  cpTipo:                      Integer = 10;
  cpQtdQuebraRelatorio:        Integer = 11;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioConsolidado(Parametro[cpSglProdutor],
                                                        Parametro[cpNomPessoaProdutor],
                                                        Parametro[cpCodSituacaoSisBov],
                                                        Parametro[cpCodGrupoEvento],
                                                        Parametro[cpCodTipoEvento],
                                                        Parametro[cpCodTipoSubEventoSanitario],
                                                        Parametro[cpDtaInicio],
                                                        Parametro[cpDtaFim],
                                                        Parametro[cpTxtDados],
                                                        Parametro[cpTipo],
                                                        Parametro[cpQtdQuebraRelatorio],
                                                        FCodTarefa, 0, 0, 0, 0
                                                       );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarPesosAjustados(): Integer;
const
  cpOrigem:               Integer = 1;
  cpSexo:                 Integer = 2;
  cpAptidao:              Integer = 3;
  cpCodFazendaManejo:     Integer = 4;
  cpCodManejoInicial:     Integer = 5;
  cpCodManejoFinal:       Integer = 6;
  cpRaca:                 Integer = 7;
  cpSglFazendaPai:        Integer = 8;
  cpCodAnimalPai:         Integer = 9;
  cpDesApelidoPai:        Integer = 10;
  cpSglFazendaMae:        Integer = 11;
  cpCodAnimalMae:         Integer = 12;
  cpDtaNascimentoInicio:  Integer = 13;
  cpDtaNascimentoFim:     Integer = 14;
  cpDtaCompraInicio:      Integer = 15;
  cpDtaCompraFim:         Integer = 16;
  cpCodPessoaSecundaria:  Integer = 17;
  cpCodCategoria:         Integer = 18;
  cpIndAnimalCastrado:    Integer = 19;
  cpCodRegimeAlimentar:   Integer = 20;
  cpCodLocal:             Integer = 21;
  cpCodLote:              Integer = 22;
  cpCodTipoLugar:         Integer = 23;
  cpNumIdadePadrao:       Integer = 24;
  cpQtdPesoMinimo:        Integer = 25;
  cpQtdPesoMaximo:        Integer = 26;
  cpQtdGPDMinimo:         Integer = 27;
  cpQtdGPDMaximo:         Integer = 28;
  cpQtdGPMMinimo:         Integer = 29;
  cpQtdGPMMaximo:         Integer = 30;
  cpIndAgrupRaca1:        Integer = 31;
  cpCodRaca1:             Integer = 32;
  cpQtdCompRacialInicio1: Integer = 33;
  cpQtdCompRacialFim1:    Integer = 34;
  cpIndAgrupRaca2:        Integer = 35;
  cpCodRaca2:             Integer = 36;
  cpQtdCompRacialInicio2: Integer = 37;
  cpQtdCompRacialFim2:    Integer = 38;
  cpIndAgrupRaca3:        Integer = 39;
  cpCodRaca3:             Integer = 40;
  cpQtdCompRacialInicio3: Integer = 41;
  cpQtdCompRacialFim3:    Integer = 42;
  cpIndAgrupRaca4:        Integer = 43;
  cpCodRaca4:             Integer = 44;
  cpQtdCompRacialInicio4: Integer = 45;
  cpQtdCompRacialFim4:    Integer = 46;
  cpTipo:                 Integer = 47;
  cpQtdQuebraRelatorio:   Integer = 48;
  cpCodPessoaProdutor:    Integer = 49;
var
  IntAnimais: TIntAnimais;
begin
  FNomArquivo := '';
  IntAnimais := TIntAnimais.Create;
  try
    Result := IntAnimais.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntAnimais.GerarRelatorioPesoAjustado(Parametro[cpOrigem],
                                                         Parametro[cpSexo],
                                                         Parametro[cpAptidao],
                                                         Parametro[cpCodFazendaManejo],
                                                         Parametro[cpCodManejoInicial],
                                                         Parametro[cpCodManejoFinal],
                                                         Parametro[cpRaca],
                                                         Parametro[cpSglFazendaPai],
                                                         Parametro[cpCodAnimalPai],
                                                         Parametro[cpDesApelidoPai],
                                                         Parametro[cpSglFazendaMae],
                                                         Parametro[cpCodAnimalMae],
                                                         Parametro[cpDtaNascimentoInicio],
                                                         Parametro[cpDtaNascimentoFim],
                                                         Parametro[cpDtaCompraInicio],
                                                         Parametro[cpDtaCompraFim],
                                                         Parametro[cpCodPessoaSecundaria],
                                                         Parametro[cpCodCategoria],
                                                         Parametro[cpIndAnimalCastrado],
                                                         Parametro[cpCodRegimeAlimentar],
                                                         Parametro[cpCodLocal],
                                                         Parametro[cpCodLote],
                                                         Parametro[cpCodTipoLugar],
                                                         Parametro[cpNumIdadePadrao],
                                                         Parametro[cpQtdPesoMinimo],
                                                         Parametro[cpQtdPesoMaximo],
                                                         Parametro[cpQtdGPDMinimo],
                                                         Parametro[cpQtdGPDMaximo],
                                                         Parametro[cpQtdGPMMinimo],
                                                         Parametro[cpQtdGPMMaximo],
                                                         Parametro[cpIndAgrupRaca1],
                                                         Parametro[cpCodRaca1],
                                                         Parametro[cpQtdCompRacialInicio1],
                                                         Parametro[cpQtdCompRacialFim1],
                                                         Parametro[cpIndAgrupRaca2],
                                                         Parametro[cpCodRaca2],
                                                         Parametro[cpQtdCompRacialInicio2],
                                                         Parametro[cpQtdCompRacialFim2],
                                                         Parametro[cpIndAgrupRaca3],
                                                         Parametro[cpCodRaca3],
                                                         Parametro[cpQtdCompRacialInicio3],
                                                         Parametro[cpQtdCompRacialFim3],
                                                         Parametro[cpIndAgrupRaca4],
                                                         Parametro[cpCodRaca4],
                                                         Parametro[cpQtdCompRacialInicio4],
                                                         Parametro[cpQtdCompRacialFim4],
                                                         Parametro[cpTipo],
                                                         Parametro[cpQtdQuebraRelatorio],
                                                         FCodTarefa,
                                                         Parametro[cpCodPessoaProdutor]                                                          
                                                        );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntAnimais.Free;
  end;
end;

function TThrRelatorioTarefa.GerarPesagemAnimais: Integer;
const
  cpCodOrigem:             Integer = 1;
  cpIndSexoAnimal:         Integer = 2;
  cpCodAptidao:            Integer = 3;
  cpCodFazendaManejo:      Integer = 4;
  cpCodAnimalManejoInicio: Integer = 5;
  cpCodAnimalManejoFim:    Integer = 6;
  cpCodRaca:               Integer = 7;
  cpSglFazendaPai:         Integer = 8;
  cpCodAnimalManejoPai:    Integer = 9;
  cpDesApelidoPai:         Integer = 10;
  cpSglFazendaMae:         Integer = 11;
  cpCodAnimalManejoMae:    Integer = 12;
  cpDtaNascimentoInicio:   Integer = 13;
  cpDtaNascimentoFim:      Integer = 14;
  cpDtaCompraInicio:       Integer = 15;
  cpDtaCompraFim:          Integer = 16;
  cpCodPessoaSecundaria:   Integer = 17;
  cpCodCategoria:          Integer = 18;
  cpIndAnimalCastrado:     Integer = 19;
  cpCodRegimeAlimentar:    Integer = 20;
  cpCodLote:               Integer = 21;
  cpCodLocal:              Integer = 22;
  cpCodTipoLugar:          Integer = 23;
  cpDtaPesagemInicio:      Integer = 24;
  cpDtaPesagemFim:         Integer = 25;
  cpQtdPesoMinimo:         Integer = 26;
  cpQtdPesoMaximo:         Integer = 27;
  cpQtdGPDMinimo:          Integer = 28;
  cpQtdGPDMaximo:          Integer = 29;
  cpQtdGPMMinimo:          Integer = 30;
  cpQtdGPMMaximo:          Integer = 31;
  cpQtdUltimasPesagens:    Integer = 32;
  cpIndAgrupRaca1:         Integer = 33;
  cpCodRaca1:              Integer = 34;
  cpQtdCompRacialInicio1:  Integer = 35;
  cpQtdCompRacialFim1:     Integer = 36;
  cpIndAgrupRaca2:         Integer = 37;
  cpCodRaca2:              Integer = 38;
  cpQtdCompRacialInicio2:  Integer = 39;
  cpQtdCompRacialFim2:     Integer = 40;
  cpIndAgrupRaca3:         Integer = 41;
  cpCodRaca3:              Integer = 42;
  cpQtdCompRacialInicio3:  Integer = 43;
  cpQtdCompRacialFim3:     Integer = 44;
  cpIndAgrupRaca4:         Integer = 45;
  cpCodRaca4:              Integer = 46;
  cpQtdCompRacialInicio4:  Integer = 47;
  cpQtdCompRacialFim4:     Integer = 48;
  cpTipo:                  Integer = 49;
  cpQtdQuebraRelatorio:    Integer = 50;
  cpCodPessoaProdutor:     Integer = 51;
var
  IntAnimais: TIntAnimais;
begin
  FNomArquivo := '';
  IntAnimais := TIntAnimais.Create;
  try
    Result := IntAnimais.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntAnimais.GerarRelatorioPesagem(Parametro[cpCodOrigem],
                                                    Parametro[cpIndSexoAnimal],
                                                    Parametro[cpCodAptidao],
                                                    Parametro[cpCodFazendaManejo],
                                                    Parametro[cpCodAnimalManejoInicio],
                                                    Parametro[cpCodAnimalManejoFim],
                                                    Parametro[cpCodRaca],
                                                    Parametro[cpSglFazendaPai],
                                                    Parametro[cpCodAnimalManejoPai],
                                                    Parametro[cpDesApelidoPai],
                                                    Parametro[cpSglFazendaMae],
                                                    Parametro[cpCodAnimalManejoMae],
                                                    Parametro[cpDtaNascimentoInicio],
                                                    Parametro[cpDtaNascimentoFim],
                                                    Parametro[cpDtaCompraInicio],
                                                    Parametro[cpDtaCompraFim],
                                                    Parametro[cpCodPessoaSecundaria],
                                                    Parametro[cpCodCategoria],
                                                    Parametro[cpIndAnimalCastrado],
                                                    Parametro[cpCodRegimeAlimentar],
                                                    Parametro[cpCodLote],
                                                    Parametro[cpCodLocal],
                                                    Parametro[cpCodTipoLugar],
                                                    Parametro[cpDtaPesagemInicio],
                                                    Parametro[cpDtaPesagemFim],
                                                    Parametro[cpQtdPesoMinimo],
                                                    Parametro[cpQtdPesoMaximo],
                                                    Parametro[cpQtdGPDMinimo],
                                                    Parametro[cpQtdGPDMaximo],
                                                    Parametro[cpQtdGPMMinimo],
                                                    Parametro[cpQtdGPMMaximo],
                                                    Parametro[cpQtdUltimasPesagens],
                                                    Parametro[cpIndAgrupRaca1],
                                                    Parametro[cpCodRaca1],
                                                    Parametro[cpQtdCompRacialInicio1],
                                                    Parametro[cpQtdCompRacialFim1],
                                                    Parametro[cpIndAgrupRaca2],
                                                    Parametro[cpCodRaca2],
                                                    Parametro[cpQtdCompRacialInicio2],
                                                    Parametro[cpQtdCompRacialFim2],
                                                    Parametro[cpIndAgrupRaca3],
                                                    Parametro[cpCodRaca3],
                                                    Parametro[cpQtdCompRacialInicio3],
                                                    Parametro[cpQtdCompRacialFim3],
                                                    Parametro[cpIndAgrupRaca4],
                                                    Parametro[cpCodRaca4],
                                                    Parametro[cpQtdCompRacialInicio4],
                                                    Parametro[cpQtdCompRacialFim4],
                                                    Parametro[cpTipo],
                                                    Parametro[cpQtdQuebraRelatorio],
                                                    FCodTarefa,
                                                    Parametro[cpCodPessoaProdutor]
                                                    );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntAnimais.Free;
  end;
end;

function TThrRelatorioTarefa.GerarAvaliacaoAnimais: Integer;
const
  cpCodEvento:             Integer = 1;
  cpDtaInicioEvento:       Integer = 2;
  cpDtaFimEvento:          Integer = 3;
  cpCodTipoAvaliacao:      Integer = 4;
  cpCodCaracteristicas:    Integer = 5;
  cpCodFazendaManejo:      Integer = 6;
  cpCodAnimalManejoInicio: Integer = 7;
  cpCodAnimalManejoFim:    Integer = 8;
  cpCodFazendaManejoPai:   Integer = 9;
  cpCodAnimalManejoPai:    Integer = 10;
  cpNomAnimalPai:          Integer = 11;
  cpDesApelidoPai:         Integer = 12;
  cpCodFazendaManejoMae:   Integer = 13;
  cpCodAnimalManejoMae:    Integer = 14;
  cpDtaNascimentoInicio:   Integer = 15;
  cpDtaNascimentoFim:      Integer = 16;
  cpIndSexo:               Integer = 17;
  cpCodRacas:              Integer = 18;
  cpCodCategorias:         Integer = 19;
  cpCodLocais:             Integer = 20;
  cpCodLotes:              Integer = 21;
  cpIndAgrupRaca1:         Integer = 22;
  cpCodRaca1:              Integer = 23;
  cpQtdCompRacialInicio1:  Integer = 24;
  cpQtdCompRacialFim1:     Integer = 25;
  cpIndAgrupRaca2:         Integer = 26;
  cpCodRaca2:              Integer = 27;
  cpQtdCompRacialInicio2:  Integer = 28;
  cpQtdCompRacialFim2:     Integer = 29;
  cpIndAgrupRaca3:         Integer = 30;
  cpCodRaca3:              Integer = 31;
  cpQtdCompRacialInicio3:  Integer = 32;
  cpQtdCompRacialFim3:     Integer = 33;
  cpIndAgrupRaca4:         Integer = 34;
  cpCodRaca4:              Integer = 35;
  cpQtdCompRacialInicio4:  Integer = 36;
  cpQtdCompRacialFim4:     Integer = 37;
  cpTipo:                  Integer = 38;
  cpQtdQuebraRelatorio:    Integer = 39;
  cpCodPessoaProdutor:     Integer = 40;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioAvaliacao(Parametro[cpCodEvento],
                                                      Parametro[cpDtaInicioEvento],
                                                      Parametro[cpDtaFimEvento],
                                                      Parametro[cpCodTipoAvaliacao],
                                                      Parametro[cpCodCaracteristicas],
                                                      Parametro[cpCodFazendaManejo],
                                                      Parametro[cpCodAnimalManejoInicio],
                                                      Parametro[cpCodAnimalManejoFim],
                                                      Parametro[cpCodFazendaManejoPai],
                                                      Parametro[cpCodAnimalManejoPai],
                                                      Parametro[cpNomAnimalPai],
                                                      Parametro[cpDesApelidoPai],
                                                      Parametro[cpCodFazendaManejoMae],
                                                      Parametro[cpCodAnimalManejoMae],
                                                      Parametro[cpDtaNascimentoInicio],
                                                      Parametro[cpDtaNascimentoFim],
                                                      Parametro[cpIndSexo],
                                                      Parametro[cpCodRacas],
                                                      Parametro[cpCodCategorias],
                                                      Parametro[cpCodLocais],
                                                      Parametro[cpCodLotes],
                                                      Parametro[cpIndAgrupRaca1],
                                                      Parametro[cpCodRaca1],
                                                      Parametro[cpQtdCompRacialInicio1],
                                                      Parametro[cpQtdCompRacialFim1],
                                                      Parametro[cpIndAgrupRaca2],
                                                      Parametro[cpCodRaca2],
                                                      Parametro[cpQtdCompRacialInicio2],
                                                      Parametro[cpQtdCompRacialFim2],
                                                      Parametro[cpIndAgrupRaca3],
                                                      Parametro[cpCodRaca3],
                                                      Parametro[cpQtdCompRacialInicio3],
                                                      Parametro[cpQtdCompRacialFim3],
                                                      Parametro[cpIndAgrupRaca4],
                                                      Parametro[cpCodRaca4],
                                                      Parametro[cpQtdCompRacialInicio4],
                                                      Parametro[cpQtdCompRacialFim4],
                                                      Parametro[cpTipo],
                                                      Parametro[cpQtdQuebraRelatorio],
                                                      FCodTarefa,
                                                      Parametro[cpCodPessoaProdutor]
                                                     );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarPrevisaoParto(): Integer;
const
  cpCodEventoEstacaoMonta:   Integer = 1;
  cpCodTipoEventosCobertura: Integer = 2;
  cpDtaPrevistaPartoInicio:  Integer = 3;
  cpDtaPrevistaPartoFim:     Integer = 4;
  cpCodRacas:                Integer = 5;
  cpCodCategorias:           Integer = 6;
  cpIndAgrupRaca1:           Integer = 7;
  cpCodRaca1:                Integer = 8;
  cpQtdCompRacialInicio1:    Integer = 9;
  cpQtdCompRacialFim1:       Integer = 10;
  cpIndAgrupRaca2:           Integer = 11;
  cpCodRaca2:                Integer = 12;
  cpQtdCompRacialInicio2:    Integer = 13;
  cpQtdCompRacialFim2:       Integer = 14;
  cpIndAgrupRaca3:           Integer = 15;
  cpCodRaca3:                Integer = 16;
  cpQtdCompRacialInicio3:    Integer = 17;
  cpQtdCompRacialFim3:       Integer = 18;
  cpIndAgrupRaca4:           Integer = 19;
  cpCodRaca4:                Integer = 20;
  cpQtdCompRacialInicio4:    Integer = 21;
  cpQtdCompRacialFim4:       Integer = 22;
  cpNumOrdemInicio:          Integer = 23;
  cpNumOrdemFim:             Integer = 24;
  cpCodLotes:                Integer = 25;
  cpCodLocais:               Integer = 26;
  cpCodFazendaManejo:        Integer = 27;
  cpCodAnimalManejoInicio:   Integer = 28;
  cpCodAnimalManejoFim:      Integer = 29;
  cpCodFazendaManejoPai:     Integer = 30;
  cpCodAnimalManejoPai:      Integer = 31;
  cpTipo:                    Integer = 32;
  cpCodPessoaProdutor:       Integer = 33;
  cpIndDiagnosticoPrenhez:   Integer = 34;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioPrevisaoParto(Parametro[cpCodEventoEstacaoMonta],
                                                          Parametro[cpCodTipoEventosCobertura],
                                                          Parametro[cpDtaPrevistaPartoInicio],
                                                          Parametro[cpDtaPrevistaPartoFim],
                                                          Parametro[cpCodRacas],
                                                          Parametro[cpCodCategorias],
                                                          Parametro[cpIndAgrupRaca1],
                                                          Parametro[cpCodRaca1],
                                                          Parametro[cpQtdCompRacialInicio1],
                                                          Parametro[cpQtdCompRacialFim1],
                                                          Parametro[cpIndAgrupRaca2],
                                                          Parametro[cpCodRaca2],
                                                          Parametro[cpQtdCompRacialInicio2],
                                                          Parametro[cpQtdCompRacialFim2],
                                                          Parametro[cpIndAgrupRaca3],
                                                          Parametro[cpCodRaca3],
                                                          Parametro[cpQtdCompRacialInicio3],
                                                          Parametro[cpQtdCompRacialFim3],
                                                          Parametro[cpIndAgrupRaca4],
                                                          Parametro[cpCodRaca4],
                                                          Parametro[cpQtdCompRacialInicio4],
                                                          Parametro[cpQtdCompRacialFim4],
                                                          Parametro[cpNumOrdemInicio],
                                                          Parametro[cpNumOrdemFim],
                                                          Parametro[cpCodLotes],
                                                          Parametro[cpCodLocais],
                                                          Parametro[cpCodFazendaManejo],
                                                          Parametro[cpCodAnimalManejoInicio],
                                                          Parametro[cpCodAnimalManejoFim],
                                                          Parametro[cpCodFazendaManejoPai],
                                                          Parametro[cpCodAnimalManejoPai],
                                                          Parametro[cpTipo],
                                                          FCodTarefa,
                                                          Parametro[cpCodPessoaProdutor],
                                                          Parametro[cpIndDiagnosticoPrenhez]
                                                     );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarFemeasDiagnosticar: Integer;
const
  cpCodEventoEstacaoMonta:   Integer = 1;
  cpCodTipoEventosCobertura: Integer = 2;
  cpDtaDiagnosticoPrevisto:  Integer = 3;
  cpCodRacas:                Integer = 4;
  cpIndAgrupRaca1:           Integer = 5;
  cpCodRaca1:                Integer = 6;
  cpQtdCompRacialInicio1:    Integer = 7;
  cpQtdCompRacialFim1:       Integer = 8;
  cpIndAgrupRaca2:           Integer = 9;
  cpCodRaca2:                Integer = 10;
  cpQtdCompRacialInicio2:    Integer = 11;
  cpQtdCompRacialFim2:       Integer = 12;
  cpIndAgrupRaca3:           Integer = 13;
  cpCodRaca3:                Integer = 14;
  cpQtdCompRacialInicio3:    Integer = 15;
  cpQtdCompRacialFim3:       Integer = 16;
  cpIndAgrupRaca4:           Integer = 17;
  cpCodRaca4:                Integer = 18;
  cpQtdCompRacialInicio4:    Integer = 19;
  cpQtdCompRacialFim4:       Integer = 20;
  cpNumOrdemInicio:          Integer = 21;
  cpNumOrdemFim:             Integer = 22;
  cpCodLotes:                Integer = 23;
  cpCodLocais:               Integer = 24;
  cpCodCategorias:           Integer = 25;
  cpCodFazendaManejo:        Integer = 26;
  cpCodAnimalManejoInicio:   Integer = 27;
  cpCodAnimalManejoFim:      Integer = 28;
  cpCodFazendaManejoPai:     Integer = 29;
  cpCodAnimalManejoPai:      Integer = 30;
  cpTipo:                    Integer = 31;
  cpCodPessoaProdutor:       Integer = 32;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioFemeasADiagnosticar(Parametro[cpCodEventoEstacaoMonta],
                                                                Parametro[cpCodTipoEventosCobertura],
                                                                Parametro[cpDtaDiagnosticoPrevisto],
                                                                Parametro[cpCodRacas],
                                                                Parametro[cpIndAgrupRaca1],
                                                                Parametro[cpCodRaca1],
                                                                Parametro[cpQtdCompRacialInicio1],
                                                                Parametro[cpQtdCompRacialFim1],
                                                                Parametro[cpIndAgrupRaca2],
                                                                Parametro[cpCodRaca2],
                                                                Parametro[cpQtdCompRacialInicio2],
                                                                Parametro[cpQtdCompRacialFim2],
                                                                Parametro[cpIndAgrupRaca3],
                                                                Parametro[cpCodRaca3],
                                                                Parametro[cpQtdCompRacialInicio3],
                                                                Parametro[cpQtdCompRacialFim3],
                                                                Parametro[cpIndAgrupRaca4],
                                                                Parametro[cpCodRaca4],
                                                                Parametro[cpQtdCompRacialInicio4],
                                                                Parametro[cpQtdCompRacialFim4],
                                                                Parametro[cpNumOrdemInicio],
                                                                Parametro[cpNumOrdemFim],
                                                                Parametro[cpCodLotes],
                                                                Parametro[cpCodLocais],
                                                                Parametro[cpCodCategorias],
                                                                Parametro[cpCodFazendaManejo],
                                                                Parametro[cpCodAnimalManejoInicio],
                                                                Parametro[cpCodAnimalManejoFim],
                                                                Parametro[cpCodFazendaManejoPai],
                                                                Parametro[cpCodAnimalManejoPai],
                                                                Parametro[cpTipo],
                                                                FCodTarefa,
                                                                Parametro[cpCodPessoaProdutor]
                                                           );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarDesempenhoVacas: Integer;
const
  cpCodFazendaManejo:       Integer = 1;
  cpCodAnimalManejoInicio:  Integer = 2;
  cpCodAnimalManejoFim:     Integer = 3;
  cpCodFazendaManejoPai:    Integer = 4;
  cpCodAnimalManejoPai:     Integer = 5;
  cpCodFazendaManejoMae:    Integer = 6;
  cpCodAnimalManejoMae:     Integer = 7;
  cpCodRacas:               Integer = 8;
  cpCodCategorias:          Integer = 9;
  cpCodLocais:              Integer = 10;
  cpCodLotes:               Integer = 11;
  cpIndAgrupRaca1:          Integer = 12;
  cpCodRaca1:               Integer = 13;
  cpQtdCompRacialInicio1:   Integer = 14;
  cpQtdCompRacialFim1:      Integer = 15;
  cpIndAgrupRaca2:          Integer = 16;
  cpCodRaca2:               Integer = 17;
  cpQtdCompRacialInicio2:   Integer = 18;
  cpQtdCompRacialFim2:      Integer = 19;
  cpIndAgrupRaca3:          Integer = 20;
  cpCodRaca3:               Integer = 21;
  cpQtdCompRacialInicio3:   Integer = 22;
  cpQtdCompRacialFim3:      Integer = 23;
  cpIndAgrupRaca4:          Integer = 24;
  cpCodRaca4:               Integer = 25;
  cpQtdCompRacialInicio4:   Integer = 26;
  cpQtdCompRacialFim4:      Integer = 27;
  cpNumPartoInicio:         Integer = 28;
  cpNumPartoFim:            Integer = 29;
  cpNumDiasIntervaloInicio: Integer = 30;
  cpNumDiasIntervalorFim:   Integer = 31;
  cpQtdPesoDesmameInicio:   Integer = 32;
  cpQtdPesoDesmameFim:      Integer = 33;
  cpTipo:                   Integer = 34;
  cpCodPessoaProdutor:      Integer = 35;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioDesempenhoVacas(Parametro[cpCodFazendaManejo],
                                                            Parametro[cpCodAnimalManejoInicio],
                                                            Parametro[cpCodAnimalManejoFim],
                                                            Parametro[cpCodFazendaManejoPai],
                                                            Parametro[cpCodAnimalManejoPai],
                                                            Parametro[cpCodFazendaManejoMae],
                                                            Parametro[cpCodAnimalManejoMae],
                                                            Parametro[cpCodRacas],
                                                            Parametro[cpCodCategorias],
                                                            Parametro[cpCodLocais],
                                                            Parametro[cpCodLotes],
                                                            Parametro[cpIndAgrupRaca1],
                                                            Parametro[cpCodRaca1],
                                                            Parametro[cpQtdCompRacialInicio1],
                                                            Parametro[cpQtdCompRacialFim1],
                                                            Parametro[cpIndAgrupRaca2],
                                                            Parametro[cpCodRaca2],
                                                            Parametro[cpQtdCompRacialInicio2],
                                                            Parametro[cpQtdCompRacialFim2],
                                                            Parametro[cpIndAgrupRaca3],
                                                            Parametro[cpCodRaca3],
                                                            Parametro[cpQtdCompRacialInicio3],
                                                            Parametro[cpQtdCompRacialFim3],
                                                            Parametro[cpIndAgrupRaca4],
                                                            Parametro[cpCodRaca4],
                                                            Parametro[cpQtdCompRacialInicio4],
                                                            Parametro[cpQtdCompRacialFim4],
                                                            Parametro[cpNumPartoInicio],
                                                            Parametro[cpNumPartoFim],
                                                            Parametro[cpNumDiasIntervaloInicio],
                                                            Parametro[cpNumDiasIntervalorFim],
                                                            Parametro[cpQtdPesoDesmameInicio],
                                                            Parametro[cpQtdPesoDesmameFim],
                                                            Parametro[cpTipo],
                                                            FCodTarefa,
                                                            Parametro[cpCodPessoaProdutor]
                                                           );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarResumoEstacaoMonta: Integer;
const
  cpCodEventoEstacaoMonta: Integer = 1;
  cpCodProdutorTrabalho:   Integer = 2;
var
  IntEventos: TIntEventos;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntEventos.GerarRelatorioResumoEstacaoMonta(Parametro[cpCodEventoEstacaoMonta],
                                                               Parametro[cpCodProdutorTrabalho],
                                                               FCodTarefa
                                                               );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

function TThrRelatorioTarefa.GerarConsolidacaoCodigosSISBOV: Integer;
const
  cpCodProdutor:                  Integer = 1;
  cpNumCNPJCPFProdutor:           Integer = 2;
  cpNomProdutor:                  Integer = 3;
  cpNumImovelReceitaFederal:      Integer = 4;
  cpCodExportacao:                Integer = 5;
  cpNomPropriedadeRural:          Integer = 6;
  cpNomMunicipioPropriedade:      Integer = 7;
  cpSglEstadoPropriedade:         Integer = 8;
  cpDtaInicioIdentificacaoAnimal: Integer = 9;
  cpDtaFimIdentificacaoAnimal:    Integer = 10;
  cpNomPessoaTecnico:             Integer = 11;
  cpNumCNPJCPFTecnico:            Integer = 12;
  cpCodTipoRelatorio:             Integer = 13;
  cpCodTarefa:                    Integer = 14;
var
  IntAnimais: TIntAnimais;
begin
  FNomArquivo := '';
  IntAnimais := TIntAnimais.Create;
  try
    Result := IntAnimais.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    FNomArquivo := IntAnimais.GerarRelatorioConsolidacaoCodigosSISBOV(Parametro[cpCodProdutor],
                                                                      Parametro[cpNumCNPJCPFProdutor],
                                                                      Parametro[cpNomProdutor],
                                                                      Parametro[cpNumImovelReceitaFederal],
                                                                      Parametro[cpCodExportacao],
                                                                      Parametro[cpNomPropriedadeRural],
                                                                      Parametro[cpNomMunicipioPropriedade],
                                                                      Parametro[cpSglEstadoPropriedade],
                                                                      Parametro[cpDtaInicioIdentificacaoAnimal],
                                                                      Parametro[cpDtaFimIdentificacaoAnimal],
                                                                      Parametro[cpNomPessoaTecnico],
                                                                      Parametro[cpNumCNPJCPFTecnico],
                                                                      Parametro[cpCodTipoRelatorio],
                                                                      FCodTarefa
                                                                      );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntAnimais.Free;
  end;
end;

function TThrRelatorioTarefa.GerarArquivoExportacaoABCZ: Integer;
const
  cpCodAnimais        :  Integer = 0;
  cpPaisSISBOV        :  Integer = 1;
  cpEstadoSISBOV      :  Integer = 2;
  cpMicroRegiaoSISBOV :  Integer = 3;
  cpCodSISBOVInicio   :  Integer = 4;
  cpCodSISBOVFim      :  Integer = 5;
  cpDtaNascInicio     :  Integer = 6;
  cpDtaNascFim        :  Integer = 7;
  cpRaca              :  Integer = 8;
  cpCategoria         :  Integer = 9;
  cpTipoLugar         :  Integer = 10;
  cpLocal             :  Integer = 11;
  cpLote              :  Integer = 12;
  cpCodManejoInicio   :  Integer = 13;
  cpCodManejoFim      :  Integer = 14;
  cpSexo              :  Integer = 15;
  cpCodProdutor       :  Integer = 16;
var
  IntEventos: TIntEventos;
  sDtaNascInicio, sDtaNascFim: String;
begin
  FNomArquivo := '';
  IntEventos := TIntEventos.Create;
  try
    Result := IntEventos.Inicializar(FConexao, FMensagens);
    if Result < 0 then begin
      Exit;
    end;
    sDtaNascInicio := VarToStr(Parametro[cpDtaNascInicio    ]);
    sDtaNascFim    := VarToStr(Parametro[cpDtaNascFim       ]);
    FNomArquivo    := IntEventos.ExportarAnimaisAbcz( Parametro[cpCodAnimais       ],
                                                   Parametro[cpPaisSISBOV       ],
                                                   Parametro[cpEstadoSISBOV     ],
                                                   Parametro[cpMicroRegiaoSISBOV],
                                                   Parametro[cpCodSISBOVInicio  ],
                                                   Parametro[cpCodSISBOVFim     ],
                                                   StrToDateDef(sDtaNascInicio, 0),
                                                   StrToDateDef(sDtaNascFim, 0),
                                                   Parametro[cpRaca             ],
                                                   Parametro[cpCategoria        ],
                                                   Parametro[cpTipoLugar        ],
                                                   Parametro[cpLocal            ],
                                                   Parametro[cpLote             ],
                                                   Parametro[cpCodManejoInicio  ],
                                                   Parametro[cpCodManejoFim     ],
                                                   Parametro[cpSexo             ],
                                                   Parametro[cpCodProdutor      ],
                                                   FCodTarefa
                                                   );
    if FNomArquivo = '' then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  finally
    IntEventos.Free;
  end;
end;

end.
