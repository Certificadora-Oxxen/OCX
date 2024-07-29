unit uEstoqueSemen;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntEstoqueSemen, uMovimentoEstoqueSemen;

type
  TEstoqueSemen = class(TASPMTSObject, IEstoqueSemen)
  private
    FIntEstoqueSemen       : TIntEstoqueSemen;
    FInicializado          : Boolean;
    FMovimentoEstoqueSemen : TMovimentoEstoqueSemen;
  protected
    function BOF: WordBool; safecall;
    function Buscar(CodMovimento, SeqMovimento: Integer): Integer; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function EstornarMovimento(CodMovimento: Integer;
      const TxtObservacao: WideString): Integer; safecall;
    function Get_MovimentoEstoqueSemen: IMovimentoEstoqueSemen; safecall;
    function InserirMovimento(CodTipoMovEstoqueSemen, CodFazenda, CodAnimal,
      CodFazendaManejo: Integer; const CodAnimalManejo,
      NumPartida: WideString; DtaMovimento: TDateTime; CodPessoaSecundaria,
      CodAnimalFemea, CodFazendaDestino, QtdDosesApto,
      QtdDosesInapto: Integer; const TxtObservacao: WideString): Integer;
      safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(const CodFazendas: WideString;
      CodFazendaManejo: Integer; const CodAnimalManejoInicio,
      CodAnimalManejoFim, DesApelido, NomAnimal, NumPartida,
      CodTipoMovsEstoqueSemen, IndMovimentoEstorno: WideString;
      DtaMovimentoInicio, DtaMovimentoFim: TDateTime;
      const CodFornecedoresSemen: WideString): Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function PesquisarPosicaoFazenda(CodFazenda, CodAnimal: Integer;
      const IndDetalharPartida, IndEstoquePositivo, IndConsolidar,
      CodOrdenacao: WideString): Integer; safecall;
    function PesquisarTouros(CodFazenda: Integer; const IndDosesApto,
      CodOrdenacao: WideString): Integer; safecall;
    function PesquisarPosicaoTouro(CodAnimal, CodFazenda: Integer;
      const IndDetalharPartida, IndEstoquePositivo, IndConsolidar,
      CodOrdenacao: WideString): Integer; safecall;
    function GerarRelatorio(CodFazenda, CodFazendaManejo: Integer;
      const CodAnimalManejoInicio, CodAnimalManejoFim, NomAnimal,
      DesApelido: WideString; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; const CodRacas, NumRGD,
      IndAgrupRaca1: WideString; CodRaca1: Integer;
      QtdComposicaoRacialInicio1, QtdComposicaoRacialFim1: Double;
      const IndAgrupRaca2: WideString; CodRaca2: Integer;
      QtdComposicaoRacialInicio2, QtdComposicaoRacialFim2: Double;
      const IndAgrupRaca3: WideString; CodRaca3: Integer;
      QtdComposicaoRacialInicio3, QtdComposicaoRacialFim3: Double;
      const IndAgrupRaca4: WideString; CodRaca4: Integer;
      QtdComposicaoRacialInicio4, QtdComposicaoRacialFim4: Double;
      const NumPartidaInicio, NumPartidaFim, CodTipoMovimentos: WideString;
      DtaMovimentoInicio, DtaMovimentoFim: TDateTime;
      const CodPessoaFornecedores, CodPessoaCompradores: WideString;
      CodFazendaOrigem, CodFazendaDestino, QtdAptoInicio, QtdAptoFim,
      QtdInaptoInicio, QtdInaptoFim, Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TEstoqueSemen.AfterConstruction;
begin
  inherited;
  FMovimentoEstoqueSemen := TMovimentoEstoqueSemen.Create;
  FMovimentoEstoqueSemen.ObjAddRef;
  FInicializado := False;
end;

procedure TEstoqueSemen.BeforeDestruction;
begin
  If FIntEstoqueSemen <> nil Then Begin
    FIntEstoqueSemen.Free;
  End;
  If FMovimentoEstoqueSemen <> nil Then Begin
    FMovimentoEstoqueSemen.ObjRelease;
    FMovimentoEstoqueSemen := nil;
  End;
  inherited;
end;

function TEstoqueSemen.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEstoqueSemen := TIntEstoqueSemen.Create;
  Result := FIntEstoqueSemen.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEstoqueSemen.BOF: WordBool;
begin
  Result := FIntEstoqueSemen.BOF;
end;

function TEstoqueSemen.Buscar(CodMovimento,
  SeqMovimento: Integer): Integer;
begin
  Result := FIntEstoqueSemen.Buscar(CodMovimento, SeqMovimento);
end;

function TEstoqueSemen.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntEstoqueSemen.Deslocar(QtdRegistros);
end;

function TEstoqueSemen.EOF: WordBool;
begin
  Result := FIntEstoqueSemen.EOF;
end;

function TEstoqueSemen.EstornarMovimento(CodMovimento: Integer;
  const TxtObservacao: WideString): Integer;
begin
  Result := FIntEstoqueSemen.EstornarMovimento(CodMovimento, TxtObservacao, 'N');
end;

function TEstoqueSemen.Get_MovimentoEstoqueSemen: IMovimentoEstoqueSemen;
begin
  FMovimentoEstoqueSemen.CodAnimal := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodAnimal;
  FMovimentoEstoqueSemen.CodAnimalFemea := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodAnimalFemea;
  FMovimentoEstoqueSemen.CodAnimalManejo := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodAnimalManejo;
  FMovimentoEstoqueSemen.CodAnimalManejoFemea := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodAnimalManejoFemea;
  FMovimentoEstoqueSemen.NomAnimal := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NomAnimal;
  FMovimentoEstoqueSemen.DesApelido := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DesApelido;
  FMovimentoEstoqueSemen.CodFazenda := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodFazenda;
  FMovimentoEstoqueSemen.CodFazendaRelacionada := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodFazendaRelacionada;
  FMovimentoEstoqueSemen.CodMovimento := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodMovimento;
  FMovimentoEstoqueSemen.CodPessoaSecundaria := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodPessoaSecundaria;
  FMovimentoEstoqueSemen.CodTipoMovEstoqueSemen := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodTipoMovEstoqueSemen;
  FMovimentoEstoqueSemen.DesTipoMovEstoqueSemen := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DesTipoMovEstoqueSemen;
  FMovimentoEstoqueSemen.DtaMovimento := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DtaMovimento;
  FMovimentoEstoqueSemen.NomFazenda := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NomFazenda;
  FMovimentoEstoqueSemen.NomFazendaRelacionada := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NomFazendaRelacionada;
  FMovimentoEstoqueSemen.NomPessoaSecundaria := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NomPessoaSecundaria;
  FMovimentoEstoqueSemen.NumCNPJCPFPessoaSecundaria := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NumCNPJCPFPessoaSecundaria;
  FMovimentoEstoqueSemen.NumPartida := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NumPartida;
  FMovimentoEstoqueSemen.QtdDosesSemenApto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.QtdDosesSemenApto;
  FMovimentoEstoqueSemen.SglFazenda := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SglFazenda;
  FMovimentoEstoqueSemen.SglFazendaManejo := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SglFazendaManejo;
  FMovimentoEstoqueSemen.SglFazendaManejoFemea := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SglFazendaManejoFemea;
  FMovimentoEstoqueSemen.SglFazendaRelacionada := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SglFazendaRelacionada;
  FMovimentoEstoqueSemen.SglTipoMovEstoqueSemen := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SglTipoMovEstoqueSemen;
  FMovimentoEstoqueSemen.CodOperacaoMovEstoqueApto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueApto;
  FMovimentoEstoqueSemen.CodOperacaoMovEstoqueInapto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueInapto;
  FMovimentoEstoqueSemen.CodUsuario := FIntEstoqueSemen.IntMovimentoEstoqueSemen.CodUsuario;
  FMovimentoEstoqueSemen.DesOperacaoMovEstoqueApto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueApto;
  FMovimentoEstoqueSemen.DesOperacaoMovEstoqueInapto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueInapto;
  FMovimentoEstoqueSemen.DtaCadastramento := FIntEstoqueSemen.IntMovimentoEstoqueSemen.DtaCadastramento;
  FMovimentoEstoqueSemen.IndMovimentoEstorno := FIntEstoqueSemen.IntMovimentoEstoqueSemen.IndMovimentoEstorno;
  FMovimentoEstoqueSemen.NomUsuario := FIntEstoqueSemen.IntMovimentoEstoqueSemen.NomUsuario;
  FMovimentoEstoqueSemen.QtdDosesSemenInapto := FIntEstoqueSemen.IntMovimentoEstoqueSemen.QtdDosesSemenInapto;
  FMovimentoEstoqueSemen.TxtObservacao := FIntEstoqueSemen.IntMovimentoEstoqueSemen.TxtObservacao;
  FMovimentoEstoqueSemen.SeqMovimento := FIntEstoqueSemen.IntMovimentoEstoqueSemen.SeqMovimento;
  Result := FMovimentoEstoqueSemen;
end;

function TEstoqueSemen.InserirMovimento(CodTipoMovEstoqueSemen, CodFazenda,
  CodAnimal, CodFazendaManejo: Integer; const CodAnimalManejo,
  NumPartida: WideString; DtaMovimento: TDateTime; CodPessoaSecundaria,
  CodAnimalFemea, CodFazendaDestino, QtdDosesApto, QtdDosesInapto: Integer;
  const TxtObservacao: WideString): Integer;
begin
  Result := FIntEstoqueSemen.InserirMovimento(CodTipoMovEstoqueSemen,
    CodFazenda, CodAnimal, CodFazendaManejo, CodAnimalManejo, NumPartida,
    DtaMovimento, CodPessoaSecundaria, CodAnimalFemea, CodFazendaDestino,
    QtdDosesApto, QtdDosesInapto, TxtObservacao, 'N');
end;

function TEstoqueSemen.NumeroRegistros: Integer;
begin
  Result := FIntEstoqueSemen.NumeroRegistros;
end;

function TEstoqueSemen.Pesquisar(const CodFazendas: WideString;
  CodFazendaManejo: Integer; const CodAnimalManejoInicio,
  CodAnimalManejoFim, DesApelido, NomAnimal, NumPartida,
  CodTipoMovsEstoqueSemen, IndMovimentoEstorno: WideString;
  DtaMovimentoInicio, DtaMovimentoFim: TDateTime;
  const CodFornecedoresSemen: WideString): Integer;
begin
  Result := FIntEstoqueSemen.Pesquisar(CodFazendas, CodFazendaManejo,
    CodAnimalManejoInicio, CodAnimalManejoFim, DesApelido, NomAnimal,
    NumPartida, CodTipoMovsEstoqueSemen, IndMovimentoEstorno,
    DtaMovimentoInicio, DtaMovimentoFim, CodFornecedoresSemen); 
end;

function TEstoqueSemen.ValorCampo(const NomColuna: WideString): OleVariant;
begin
  Result := FIntEstoqueSemen.ValorCampo(NomColuna);
end;

procedure TEstoqueSemen.FecharPesquisa;
begin
  FIntEstoqueSemen.FecharPesquisa;
end;

procedure TEstoqueSemen.IrAoAnterior;
begin
  FIntEstoqueSemen.IrAoAnterior;
end;

procedure TEstoqueSemen.IrAoPrimeiro;
begin
  FIntEstoqueSemen.IrAoPrimeiro;
end;

procedure TEstoqueSemen.IrAoProximo;
begin
  FIntEstoqueSemen.IrAoProximo;
end;

procedure TEstoqueSemen.IrAoUltimo;
begin
  FIntEstoqueSemen.IrAoUltimo;
end;

procedure TEstoqueSemen.Posicionar(NumRegistro: Integer);
begin
  FIntEstoqueSemen.Posicionar(NumRegistro);
end;

function TEstoqueSemen.PesquisarPosicaoFazenda(CodFazenda,
  CodAnimal: Integer; const IndDetalharPartida, IndEstoquePositivo,
  IndConsolidar, CodOrdenacao: WideString): Integer;
begin
  Result := FIntEstoqueSemen.PesquisarPosicaoFazenda(CodFazenda,
    CodAnimal, IndDetalharPartida, IndEstoquePositivo, IndConsolidar,
    CodOrdenacao);
end;

function TEstoqueSemen.PesquisarTouros(CodFazenda: Integer;
  const IndDosesApto, CodOrdenacao: WideString): Integer;
begin
  Result := FIntEstoqueSemen.PesquisarTouros(CodFazenda, IndDosesApto,
    CodOrdenacao);
end;

function TEstoqueSemen.PesquisarPosicaoTouro(CodAnimal,
  CodFazenda: Integer; const IndDetalharPartida, IndEstoquePositivo,
  IndConsolidar, CodOrdenacao: WideString): Integer;
begin
  Result := FIntEstoqueSemen.PesquisarPosicaoTouro(CodAnimal, CodFazenda,
    IndDetalharPartida, IndEstoquePositivo, IndConsolidar, CodOrdenacao);
end;

function TEstoqueSemen.GerarRelatorio(CodFazenda,
  CodFazendaManejo: Integer; const CodAnimalManejoInicio,
  CodAnimalManejoFim, NomAnimal, DesApelido: WideString;
  DtaNascimentoInicio, DtaNascimentoFim: TDateTime; const CodRacas, NumRGD,
  IndAgrupRaca1: WideString; CodRaca1: Integer; QtdComposicaoRacialInicio1,
  QtdComposicaoRacialFim1: Double; const IndAgrupRaca2: WideString;
  CodRaca2: Integer; QtdComposicaoRacialInicio2,
  QtdComposicaoRacialFim2: Double; const IndAgrupRaca3: WideString;
  CodRaca3: Integer; QtdComposicaoRacialInicio3,
  QtdComposicaoRacialFim3: Double; const IndAgrupRaca4: WideString;
  CodRaca4: Integer; QtdComposicaoRacialInicio4,
  QtdComposicaoRacialFim4: Double; const NumPartidaInicio, NumPartidaFim,
  CodTipoMovimentos: WideString; DtaMovimentoInicio,
  DtaMovimentoFim: TDateTime; const CodPessoaFornecedores,
  CodPessoaCompradores: WideString; CodFazendaOrigem, CodFazendaDestino,
  QtdAptoInicio, QtdAptoFim, QtdInaptoInicio, QtdInaptoFim, Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntEstoqueSemen.GerarRelatorio(CodFazenda, CodFazendaManejo,
    CodAnimalManejoInicio, CodAnimalManejoFim, NomAnimal, DesApelido,
    DtaNascimentoInicio, DtaNascimentoFim, CodRacas, NumRGD, IndAgrupRaca1,
    CodRaca1, QtdComposicaoRacialInicio1, QtdComposicaoRacialFim1,
    IndAgrupRaca2, CodRaca2, QtdComposicaoRacialInicio2,
    QtdComposicaoRacialFim2, IndAgrupRaca3, CodRaca3,
    QtdComposicaoRacialInicio3, QtdComposicaoRacialFim3, IndAgrupRaca4,
    CodRaca4, QtdComposicaoRacialInicio4, QtdComposicaoRacialFim4,
    NumPartidaInicio, NumPartidaFim, CodTipoMovimentos, DtaMovimentoInicio,
    DtaMovimentoFim, CodPessoaFornecedores, CodPessoaCompradores,
    CodFazendaOrigem, CodFazendaDestino, QtdAptoInicio, QtdAptoFim,
    QtdInaptoInicio, QtdInaptoFim, Tipo, QtdQuebraRelatorio);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEstoqueSemen, Class_EstoqueSemen,
    ciMultiInstance, tmApartment);
end.
