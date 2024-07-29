unit uIntEstoqueSemen;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntMovimentoEstoqueSemen, uColecoes, uIntRelatorios;

const
  ctmesCompra =  1;
  ctmesColeta = 2;
  ctmesVenda = 3;
  ctmesPerda = 4;
  ctmesUtilizacao = 5;
  ctmesLiberacaoParaUso = 6;
  ctmesBloqueioDeUso = 7;
  ctmesTransferencia = 8;
  ctmesEstorno = 9;
  ctmesEntradaPorAjuste = 10;
  ctmesSaidaPorAjuste = 11;

type
  {Auxiliar no controle de quantidades}
  TQtdDosesSemen = record
    Apto: Integer;
    Inapto: Integer;
  end;

  {Auxiliar na consistência de animais}
  TDadosAnimal = record
    CodAnimal: Integer;
    Sexo: String;
    CodTipoOrigem: Integer;
    CodCategoriaAnimal: Integer;
    DtaCompra: TDateTime;
  end;

  TDadosEvento = record
    CodCategoriaAnimal: Integer;
    DtaEvento: TDateTime;
  end;

  { TIntEstoqueSemen }
  TIntEstoqueSemen = class(TIntClasseBDNavegacaoBasica)
  private
    FIntMovimentoEstoqueSemen: TIntMovimentoEstoqueSemen;
    function ConsistirFazenda(CodFazenda: Integer): Integer;
    function ConsistirAnimal(CodAnimal: Integer;
      var DadosAnimal: TDadosAnimal): Integer;
    function ConsistirPessoaSecundaria(CodPessoaSecundaria,
      CodPapelSecundario: Integer): Integer;
    function ObterSaldo(CodFazenda: Integer;
      var DadosAnimal: TDadosAnimal; NumPartida: String;
      var QtdDosesEstoque: TQtdDosesSemen; var Existe: Boolean): Integer;
    function InserirEstoqueSemen(CodFazenda, CodAnimal: Integer;
      NumPartida: String): Integer;
    function AtualizarEstoqueSemen(CodFazenda, CodAnimal: Integer;
      NumPartida: String): Integer;
    function InserirMovimentoNaBase(CodMovimento, SeqMovimento,
      CodTipoMovEstoqueSemen, CodFazenda, CodAnimal: Integer;
      NumPartida: String; DtaMovimento: TDateTime; CodPessoaSecundaria,
      CodAnimalFemea, CodFazendaRelacionada, QtdDosesApto,
      QtdDosesInapto: Integer; TxtObservacao: String;
      DtaCadastramento: TDateTime): Integer;
    function PesquisarRelatorio(CodFazenda, CodFazendaManejo: Integer;
      CodAnimalManejoInicio, CodAnimalManejoFim, NomAnimal,
      DesApelido: String; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; CodRacas, NumRGD,
      IndAgrupRaca1: String; CodRaca1: Integer;
      QtdComposicaoRacialInicio1, QtdComposicaoRacialFim1: Double;
      IndAgrupRaca2: String; CodRaca2: Integer;
      QtdComposicaoRacialInicio2, QtdComposicaoRacialFim2: Double;
      IndAgrupRaca3: String; CodRaca3: Integer;
      QtdComposicaoRacialInicio3, QtdComposicaoRacialFim3: Double;
      IndAgrupRaca4: String; CodRaca4: Integer;
      QtdComposicaoRacialInicio4, QtdComposicaoRacialFim4: Double;
      NumPartidaInicio, NumPartidaFim, CodTipoMovimentos: String;
      DtaMovimentoInicio, DtaMovimentoFim: TDateTime; CodPessoaFornecedores,
      CodPessoaCompradores: String; CodFazendaOrigem, CodFazendaDestino,
      QtdAptoInicio, QtdAptoFim, QtdInaptoInicio,
      QtdInaptoFim: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodMovimento, SeqMovimento: Integer): Integer;
    function EstornarMovimento(CodMovimento: Integer;
      TxtObservacao, IndSistema: String): Integer;
    function InserirMovimento(CodTipoMovEstoqueSemen, CodFazenda,
      CodAnimal, CodFazendaManejo: Integer; CodAnimalManejo, NumPartida: String;
      DtaMovimento: TDateTime; CodPessoaSecundaria, CodAnimalFemea,
      CodFazendaDestino, QtdDosesApto, QtdDosesInapto: Integer;
      TxtObservacao, IndSistema: String): Integer;
    function PesquisarPosicaoFazenda(CodFazenda, CodAnimal: Integer;
      IndDetalharPartida, IndEstoquePositivo, IndConsolidar,
      CodOrdenacao: String): Integer;
    function PesquisarTouros(CodFazenda: Integer; IndDosesApto,
      CodOrdenacao: String): Integer;
    function PesquisarPosicaoTouro(CodAnimal, CodFazenda: Integer;
      IndDetalharPartida, IndEstoquePositivo, IndConsolidar,
      CodOrdenacao: String): Integer;
    function Pesquisar(CodFazendas: String;
      CodFazendaManejo: Integer; CodAnimalManejoInicio,
      CodAnimalManejoFim, DesApelido, NomAnimal, NumPartida,
      CodTipoMovsEstoqueSemen, IndMovimentoEstorno: String;
      DtaMovimentoInicio, DtaMovimentoFim: TDateTime;
      CodFornecedoresSemen: String): Integer;
    function GerarRelatorio(CodFazenda, CodFazendaManejo: Integer;
      CodAnimalManejoInicio, CodAnimalManejoFim, NomAnimal,
      DesApelido: String; DtaNascimentoInicio,
      DtaNascimentoFim: TDateTime; CodRacas, NumRGD,
      IndAgrupRaca1: String; CodRaca1: Integer;
      QtdComposicaoRacialInicio1, QtdComposicaoRacialFim1: Double;
      IndAgrupRaca2: String; CodRaca2: Integer;
      QtdComposicaoRacialInicio2, QtdComposicaoRacialFim2: Double;
      IndAgrupRaca3: String; CodRaca3: Integer;
      QtdComposicaoRacialInicio3, QtdComposicaoRacialFim3: Double;
      IndAgrupRaca4: String; CodRaca4: Integer;
      QtdComposicaoRacialInicio4, QtdComposicaoRacialFim4: Double;
      NumPartidaInicio, NumPartidaFim, CodTipoMovimentos: String;
      DtaMovimentoInicio, DtaMovimentoFim: TDateTime; CodPessoaFornecedores,
      CodPessoaCompradores: String; CodFazendaOrigem, CodFazendaDestino,
      QtdAptoInicio, QtdAptoFim, QtdInaptoInicio, QtdInaptoFim, Tipo,
      QtdQuebraRelatorio: Integer): String;

    property IntMovimentoEstoqueSemen: TIntMovimentoEstoqueSemen read FIntMovimentoEstoqueSemen write FIntMovimentoEstoqueSemen;
  end;

implementation

{ TIntEstoqueSemen }

constructor TIntEstoqueSemen.Create;
begin
  inherited;
  FIntMovimentoEstoqueSemen := TIntMovimentoEstoqueSemen.Create;
end;

destructor TIntEstoqueSemen.Destroy;
begin
  FIntMovimentoEstoqueSemen.Free;
  inherited;
end;

function TIntEstoqueSemen.ConsistirFazenda(CodFazenda: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirFazenda';
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se a fazenda é válida
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  1 '+
        'from '+
        '  tab_fazenda '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1393, Self.ClassName, NomeMetodo, []);
        Result := -1393;
        Exit;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1293, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1293;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.ConsistirAnimal(CodAnimal: Integer;
  var DadosAnimal: TDadosAnimal): Integer;
const
  NomeMetodo: String = 'ConsistirAnimal';
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se o animal é válido
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  ind_sexo '+
        '  , cod_tipo_origem '+
        '  , cod_categoria_animal '+
        '  , dta_compra '+
        'from '+
        '  tab_animal '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_animal = :cod_animal '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(679, Self.ClassName, NomeMetodo, []);
        Result := -679;
        Exit;
      end;
      DadosAnimal.CodAnimal := CodAnimal;
      DadosAnimal.Sexo := Q.FieldByName('ind_sexo').AsString;
      DadosAnimal.CodTipoOrigem := Q.FieldByName('cod_tipo_origem').AsInteger;
      DadosAnimal.CodCategoriaAnimal := Q.FieldByName('cod_categoria_animal').AsInteger;
      DadosAnimal.DtaCompra := Q.FieldByName('dta_compra').AsDateTime;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1303, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1303;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.ConsistirPessoaSecundaria(CodPessoaSecundaria,
  CodPapelSecundario: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirPessoaSecundaria';
var
  Q: THerdomQuery;
  sAux: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se a pessoa existe
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  nom_pessoa_secundaria '+
        'from '+
        '  tab_pessoa_secundaria '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_pessoa_secundaria = :cod_pessoa_secundaria '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1402, Self.ClassName, NomeMetodo, []);
        Result := -1402;
        Exit;
      end;
      sAux := Q.FieldByName('nom_pessoa_secundaria').AsString;

      // Verifica se pessoa informada possui papel, caso informado
      if CodPapelSecundario > 0 then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  tpps.cod_pessoa_secundaria '+
          '  , tps.des_papel_secundario '+
          'from '+
          '  tab_papel_secundario tps '+
          '  , tab_pessoa_papel_secundario tpps '+
          'where '+
{IFDEF MSSQL}
          '  tps.cod_papel_secundario *= tpps.cod_papel_secundario '+
{ENDIF}
          '  and tpps.cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and tpps.cod_pessoa_secundaria = :cod_pessoa_secundaria '+
          '  and tps.cod_papel_secundario = :cod_papel_secundario ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
        Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(422, Self.ClassName, NomeMetodo, []);
          Result := -422;
          Exit;
        end else if Q.FieldByName('cod_pessoa_secundaria').IsNull then begin
          Mensagens.Adicionar(1403, Self.ClassName, NomeMetodo, [sAux, Q.FieldByName('des_papel_secundario').AsString]);
          Result := -1403;
          Exit;
        end;
      end;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1310, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1310;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.ObterSaldo(CodFazenda: Integer;
  var DadosAnimal: TDadosAnimal; NumPartida: String;
  var QtdDosesEstoque: TQtdDosesSemen; var Existe: Boolean): Integer;
const
  NomeMetodo: String = 'ObterSaldo';
var
  Q: THerdomQuery;
begin
  { Se o parametro "existe" for "True" e o registro em estoque não existir,
  gera uma mensagem de erro, caso o parametro seja "False" e o registro
  no estoque realmente não exista, o parametro "existe" para a valer "False",
  caso exista retorna "True" }
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Consiste fazenda
  Result := ConsistirFazenda(CodFazenda);
  if Result < 0 then Exit;

  // Consiste animal
  Result := ConsistirAnimal(DadosAnimal.CodAnimal, DadosAnimal);
  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem saldo atual
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  qtd_doses_apto '+
        '  , qtd_doses_inapto '+
        'from '+
        '  tab_estoque_semen '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and cod_animal = :cod_animal '+
        '  and num_partida  = :num_partida ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_animal').AsInteger := DadosAnimal.CodAnimal;
      Q.ParamByName('num_partida').AsString := NumPartida;
      Q.Open;
      if Q.IsEmpty then begin
        QtdDosesEstoque.Apto := 0;
        QtdDosesEstoque.Inapto := 0;
        if Existe then begin
          Mensagens.Adicionar(1399, Self.ClassName, NomeMetodo, []);
          Result := -1399;
          Exit;
        end;
      end else begin
        QtdDosesEstoque.Apto := Q.FieldByName('qtd_doses_apto').AsInteger;
        QtdDosesEstoque.Inapto := Q.FieldByName('qtd_doses_inapto').AsInteger;
      end;

      // Identifica se o registro já existia no estoque de sêmen
      Existe := not(Q.IsEmpty);

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1398, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1398;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.AtualizarEstoqueSemen(CodFazenda,
  CodAnimal: Integer; NumPartida: String): Integer;
const
  NomeMetodo: String = 'AtualizarEstoqueSemen';
var
  Q: THerdomQuery;
  iSaldoDosesSemen: TQtdDosesSemen;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem novo saldo
      Q.Close;
      Q.SQL.Text :=
        'select '+
{IFDEF MSSQL}
        '  isnull(sum(qtd_doses_apto), 0) as qtd_doses_apto '+
        '  , isnull(sum(qtd_doses_inapto), 0) as qtd_doses_inapto '+
{ENDIF}
        'from '+
        '  tab_movimento_estoque_semen '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and cod_animal = :cod_animal '+
        '  and num_partida = :num_partida ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.ParamByName('num_partida').AsString := NumPartida;
      Q.Open;
      iSaldoDosesSemen.Apto := Q.FieldByName('qtd_doses_apto').AsInteger;
      iSaldoDosesSemen.Inapto := Q.FieldByName('qtd_doses_inapto').AsInteger;

      // Atualiza saldo atual no estoque de sêmen
      Q.Close;
      Q.SQL.Text :=
        'update tab_estoque_semen '+
        'set '+
        '  qtd_doses_apto = :qtd_doses_apto '+
        '  , qtd_doses_inapto = :qtd_doses_inapto '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and cod_animal = :cod_animal '+
        '  and num_partida = :num_partida ';
      Q.ParamByName('qtd_doses_apto').AsInteger := iSaldoDosesSemen.Apto;
      Q.ParamByName('qtd_doses_inapto').AsInteger := iSaldoDosesSemen.Inapto;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.ParamByName('num_partida').AsString := NumPartida;
      Q.ExecSQL;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1422, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1422;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.InserirEstoqueSemen(CodFazenda,
  CodAnimal: Integer; NumPartida: String): Integer;
const
  NomeMetodo: String = 'InserirEstoqueSemen';
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Insere registro no estoque de sêmen
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_estoque_semen '+
        ' (cod_pessoa_produtor '+
        '  , cod_fazenda '+
        '  , cod_animal '+
        '  , num_partida '+
        '  , qtd_doses_apto '+
        '  , qtd_doses_inapto) '+
        'values '+
        ' (:cod_pessoa_produtor '+
        '  , :cod_fazenda '+
        '  , :cod_animal '+
        '  , :num_partida '+
        '  , 0 '+
        '  , 0) ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.ParamByName('num_partida').AsString := NumPartida;
      Q.ExecSQL;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1421, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1421;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.InserirMovimentoNaBase(CodMovimento, SeqMovimento,
  CodTipoMovEstoqueSemen, CodFazenda, CodAnimal: Integer; NumPartida: String;
  DtaMovimento: TDateTime; CodPessoaSecundaria, CodAnimalFemea,
  CodFazendaRelacionada, QtdDosesApto, QtdDosesInapto: Integer;
  TxtObservacao: String; DtaCadastramento: TDateTime): Integer;
const
  NomeMetodo: String = 'InserirMovimentoNaBase';
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_movimento_estoque_semen '+
        ' (cod_pessoa_produtor '+
        '  , cod_movimento '+
        '  , seq_movimento '+
        '  , cod_fazenda '+
        '  , cod_animal '+
        '  , num_partida '+
        '  , cod_tipo_mov_estoque_semen '+
        '  , ind_movimento_estorno '+
        '  , dta_movimento '+
        '  , cod_pessoa_secundaria '+
        '  , cod_animal_femea '+
        '  , cod_fazenda_relacionada '+
        '  , qtd_doses_apto '+
        '  , qtd_doses_inapto '+
        '  , txt_observacao '+
        '  , dta_cadastramento '+
        '  , cod_usuario) '+
        'values '+
        ' (:cod_pessoa_produtor '+
        '  , :cod_movimento '+
        '  , :seq_movimento '+
        '  , :cod_fazenda '+
        '  , :cod_animal '+
        '  , :num_partida '+
        '  , :cod_tipo_mov_estoque_semen '+
        '  , :ind_movimento_estorno '+
        '  , :dta_movimento '+
        '  , :cod_pessoa_secundaria '+
        '  , :cod_animal_femea '+
        '  , :cod_fazenda_relacionada '+
        '  , :qtd_doses_apto '+
        '  , :qtd_doses_inapto '+
        '  , :txt_observacao '+
        '  , :dta_cadastramento '+
        '  , :cod_usuario) ';

      // Atribui valores
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_movimento').AsInteger := CodMovimento;
      Q.ParamByName('seq_movimento').AsInteger := SeqMovimento;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.ParamByName('num_partida').AsString := NumPartida;
      Q.ParamByName('cod_tipo_mov_estoque_semen').AsInteger := CodTipoMovEstoqueSemen;
      Q.ParamByName('ind_movimento_estorno').AsString := 'N';
      Q.ParamByName('dta_movimento').AsDateTime := DtaMovimento;
      if CodPessoaSecundaria > 0 then begin
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      end else begin
        Q.ParamByName('cod_pessoa_secundaria').DataType := ftInteger;
        Q.ParamByName('cod_pessoa_secundaria').Clear;
      end;
      if CodAnimalFemea > 0 then begin
        Q.ParamByName('cod_animal_femea').AsInteger := CodAnimalFemea;
      end else begin
        Q.ParamByName('cod_animal_femea').DataType := ftInteger;
        Q.ParamByName('cod_animal_femea').Clear;
      end;
      if CodFazendaRelacionada > 0 then begin
        Q.ParamByName('cod_fazenda_relacionada').AsInteger := CodFazendaRelacionada;
      end else begin
        Q.ParamByName('cod_fazenda_relacionada').DataType := ftInteger;
        Q.ParamByName('cod_fazenda_relacionada').Clear;
      end;
      Q.ParamByName('qtd_doses_apto').AsInteger := QtdDosesApto;
      Q.ParamByName('qtd_doses_inapto').AsInteger := QtdDosesInapto;
      if TxtObservacao <> '' then begin
        Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      end else begin
        Q.ParamByName('txt_observacao').DataType := ftString;
        Q.ParamByName('txt_observacao').Clear;
      end;
      Q.ParamByName('dta_cadastramento').AsDateTime := DtaCadastramento;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;

      // Executando script
      Q.ExecSQL;
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1420, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1420;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.PesquisarRelatorio(CodFazenda,
  CodFazendaManejo: Integer; CodAnimalManejoInicio, CodAnimalManejoFim,
  NomAnimal, DesApelido: String; DtaNascimentoInicio,
  DtaNascimentoFim: TDateTime; CodRacas, NumRGD, IndAgrupRaca1: String;
  CodRaca1: Integer; QtdComposicaoRacialInicio1,
  QtdComposicaoRacialFim1: Double; IndAgrupRaca2: String;
  CodRaca2: Integer; QtdComposicaoRacialInicio2,
  QtdComposicaoRacialFim2: Double; IndAgrupRaca3: String;
  CodRaca3: Integer; QtdComposicaoRacialInicio3,
  QtdComposicaoRacialFim3: Double; IndAgrupRaca4: String;
  CodRaca4: Integer; QtdComposicaoRacialInicio4,
  QtdComposicaoRacialFim4: Double; NumPartidaInicio, NumPartidaFim,
  CodTipoMovimentos: String; DtaMovimentoInicio,
  DtaMovimentoFim: TDateTime; CodPessoaFornecedores,
  CodPessoaCompradores: String; CodFazendaOrigem, CodFazendaDestino,
  QtdAptoInicio, QtdAptoFim, QtdInaptoInicio, QtdInaptoFim: Integer): Integer;
const
  NomMetodo: String = 'PesquisarRelatorio';
  CodRelatorio: Integer = 17;

  fSGLFAZENDA: Integer = 1;
  fCODANIMALMANEJO: Integer = 2;
  fNOMANIMAL: Integer = 3;
  fDESAPELIDO: Integer = 4;
  fCODANIMALMANEJOPAI: Integer = 5;
  fNOMANIMALPAI: Integer = 6;
  fDESAPELIDOPAI: Integer = 7;
  fCODANIMALMANEJOMAE: Integer = 8;
  fNOMANIMALMAE: Integer = 9;
  fDTANASCIMENTO: Integer = 10;
  fSGLRACA: Integer = 11;
  fDESCOMPOSICAORACIAL: Integer = 12;
  fNUMPARTIDA: Integer = 13;
  fDTAMOVIMENTO: Integer = 14;
  fSGLTIPOMOVIMENTO: Integer = 15;
  fDESTIPOMOVIMENTO: Integer = 16;
  fNOMPESSOACOMPRADOR: Integer = 17;
  fNOMPESSOAFORNECEDOR: Integer = 18;
  fNOMPESSOAINSEMINADOR: Integer = 19;
  fQTDAPTO: Integer = 20;
  fQTDINAPTO: Integer = 21;
  fQTDTOTAL: Integer = 22;

var
  Param: TValoresParametro;
  IntRelatorios: TIntRelatorios;
  bPersonalizavel, bGroupBy, bAux: Boolean;
  sAux: String;

  function SQL(Linha: String; VerificaCampo: Integer): Boolean; overload;
  begin
    Result := False;
    if (VerificaCampo <> -1) then begin
      Result := (VerificaCampo = 0) or not(bPersonalizavel)
        or (IntRelatorios.CampoAssociado(VerificaCampo) = 1);
      if Result then begin
        Query.SQL.Text := Query.SQL.Text + Linha;
      end;
    end;
  end;

  function SQL(Linha: String; VerificaCampos: Array Of Integer): Boolean; overload;
  var
    iAuxPesquisa: Integer;
  begin
    iAuxPesquisa := 0;
    Result := not(bPersonalizavel);
    while (iAuxPesquisa < Length(VerificaCampos)) and (not Result) do begin
      Result :=
        (IntRelatorios.CampoAssociado(VerificaCampos[iAuxPesquisa]) = 1);
      Inc(iAuxPesquisa);
    end;
    if Result then begin
      SQL(Linha, 0);
    end;
  end;

  function Pertence(Elemento: Integer; Lista: String): Boolean;
  var
    iiAux: Integer;
  begin
    Result := False;
    If Lista <> '' Then Begin
      Param := TValoresParametro.Create(TValorParametro);
      Try
        {Consistindo parametros multivalorados}
        Param.Clear;
        if VerificaParametroMultiValor(Lista, Param) < 0 then Exit;
        for iiAux := 0 to Param.Count-1 do begin
          try
            Result := (Param.Items[iiAux].Valor = Elemento);
            if Result then Exit;
          except
            Exit;
          end;
        end;
      Finally
        Param.Free;
      End;
    End;
  end;

begin
  {----------------------------------------------------------------------------
  * Notas sobre esta função

    Esta função contrói uma query de acordo com  os  campos  selecionados  pelo
  usuário o relatório, levando em conta também os critérios por  ele  informado
  para a seleção dos animais do relatório.
    Para isto algumas procedures internas foram  criadas  visando  facilitar  o
  procedimento principal. As function´s criadas são:

  SQL('<linha a ser inserida no SQL da query>', <número do campo do relatório>)
  - Esta função condiciona a inclusão da <linha a ser inserida no SQL da query>
  somente se o <número do campo do relatório> for 0 (zero) ou o  usuário  tiver
  selecionado esse campo para ser apresentado no relatório, quando o valor "-1"
  é a linha é descosiderada imediantamente, não sendo incluída.

  SQL('<linha a ser inserida no SQL da query>', <lista de campos do relatório>)
  - Esta função condiciona a inclusão da <linha a ser inserida no SQL da query>
  somente se pelo menos um dos campo da <lista de campos do relatório> tiver
  sido selecionada pelo usuário para ser apresentado no relatório.

  Ambas as funções retornam verdadeiro (TRUE) quando uma  linha  é  inserida  e
  falso (FALSE) quando não.
  ----------------------------------------------------------------------------}
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  Param := TValoresParametro.Create(TValorParametro);
  Try
    {Consistindo parametros multivalorados}
    Param.Clear;
    If CodRacas <> '' Then Begin
      Result := VerificaParametroMultiValor(CodRacas, Param);
      If Result < 0 Then Exit;
      Param.Clear;
    End;
    If CodTipoMovimentos <> '' Then Begin
      Result := VerificaParametroMultiValor(CodTipoMovimentos, Param);
      If Result < 0 Then Exit;
      Param.Clear;
    End;
    If CodPessoaFornecedores <> '' Then Begin
      Result := VerificaParametroMultiValor(CodPessoaFornecedores, Param);
      If Result < 0 Then Exit;
      Param.Clear;
    End;
    If CodPessoaCompradores <> '' Then Begin
      Result := VerificaParametroMultiValor(CodPessoaCompradores, Param);
      If Result < 0 Then Exit;
      Param.Clear;
    End;
  Finally
    Param.Free;
  End;

  IntRelatorios := TIntRelatorios.Create;
  try
    Result := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Result < 0 then Exit;
    Result := IntRelatorios.Buscar(CodRelatorio);
    if Result < 0 then Exit;
    Result := IntRelatorios.Pesquisar(CodRelatorio);
    if Result < 0 then Exit;

    bPersonalizavel := (IntRelatorios.IntRelatorio.IndPersonalizavel = 'S');

    Try
      // Cria tabela temporária de pesquisa, quando não existir
      Query.SQL.Text :=
        'if object_id(''tempdb..#tmp_relatorio_estoque_semen'') is null '+
        'begin '+
        '  create table #tmp_relatorio_estoque_semen '+
        '  ( '+
        '    cod_pessoa_produtor int not null '+
        '    , SglFazenda varchar(2) null '+
        '    , CodAnimalManejo varchar(11) null '+
        '    , NomAnimal varchar(60) null '+
        '    , DesApelido varchar(20) null '+
        '    , cod_animal_pai int null '+
        '    , CodAnimalManejoPai varchar(11) null '+
        '    , NomAnimalPai varchar(60) null '+
        '    , DesApelidoPai varchar(20) null '+
        '    , cod_animal_mae int null '+
        '    , CodAnimalManejoMae varchar(11) null '+
        '    , NomAnimalMae varchar(60) null '+
        '    , DtaNascimento smalldatetime null '+
        '    , SglRaca char(3) null '+
        '    , DesComposicaoRacial varchar(50) null '+
        '    , NumPartida varchar(10) null '+
        '    , DtaMovimento smalldatetime null '+
        '    , SglTipoMovimento char(2) null '+
        '    , DesTipoMovimento varchar(18) null '+
        '    , NomPessoaComprador varchar(50) null '+
        '    , NomPessoaFornecedor varchar(50) null '+
        '    , NomPessoaInseminador varchar(50) null '+
        '    , QtdDosesApto int null '+
        '    , QtdDosesInapto int null '+
        '    , QtdDosesTotal int null '+
        '  ) '+
        '  create index idx_tmp_estoque_semen_pai on #tmp_relatorio_estoque_semen (cod_pessoa_produtor, cod_animal_pai) '+
        '  create index idx_tmp_estoque_semen_mae on #tmp_relatorio_estoque_semen (cod_pessoa_produtor, cod_animal_mae) '+
        'end ';
//      Query.SQL.SaveToFile('c:\tmp\Create.sql');
      Query.ExecSQL;

      // Esvazia a tabela temporária
      Query.SQL.Text :=
        'truncate table #tmp_relatorio_estoque_semen ';
//      Query.SQL.SaveToFile('c:\tmp\Truncate.sql');
      Query.ExecSQL;

      // Define quais campos seram populados
      Query.SQL.Clear;
      SQL('insert into #tmp_relatorio_estoque_semen ', 0);
      SQL('( ', 0);
      SQL('  cod_pessoa_produtor ',    0);
      SQL('  , SglFazenda ',           fSGLFAZENDA);
      SQL('  , CodAnimalManejo ',      fCODANIMALMANEJO);
      SQL('  , NomAnimal ',            fNOMANIMAL);
      SQL('  , DesApelido ',           fDESAPELIDO);
      SQL('  , cod_animal_pai ',       [fCODANIMALMANEJOPAI, fNOMANIMALPAI, fDESAPELIDOPAI]);
      SQL('  , cod_animal_mae ',       [fCODANIMALMANEJOMAE, fNOMANIMALMAE]);
      SQL('  , DtaNascimento ',        fDTANASCIMENTO);
      SQL('  , SglRaca ',              fSGLRACA);
      SQL('  , DesComposicaoRacial ',  fDESCOMPOSICAORACIAL);
      SQL('  , NumPartida ',           fNUMPARTIDA);
      SQL('  , DtaMovimento ',         fDTAMOVIMENTO);
      SQL('  , SglTipoMovimento ',     fSGLTIPOMOVIMENTO);
      SQL('  , DesTipoMovimento ',     fDESTIPOMOVIMENTO);
      SQL('  , NomPessoaFornecedor ',  fNOMPESSOAFORNECEDOR);
      SQL('  , NomPessoaComprador ',   fNOMPESSOACOMPRADOR);
      SQL('  , NomPessoaInseminador ', fNOMPESSOAINSEMINADOR);
      SQL('  , QtdDosesApto ',         0);
      SQL('  , QtdDosesInapto ',       0);
      SQL('  , QtdDosesTotal ',        0);
      SQL(') ', 0);

      // Obtem os dados que atendam aos critérios de pesquisa
      SQL('select ', 0);
      SQL('  tmes.cod_pessoa_produtor ', 0);
      SQL('  , tf.sgl_fazenda ',                                                       fSGLFAZENDA);
      SQL('  , case when ta.cod_fazenda_manejo is null then '+
          '      ta.cod_animal_manejo '+
          '    else '+
          '      tfm.sgl_fazenda + '' '' + ta.cod_animal_manejo '+
          '    end ',                                                                  fCODANIMALMANEJO);
      SQL('  , ta.nom_animal ',                                                        fNOMANIMAL);
      SQL('  , ta.des_apelido ',                                                       fDESAPELIDO);
      SQL('  , ta.cod_animal_pai ',                                                    [fCODANIMALMANEJOPAI, fNOMANIMALPAI, fDESAPELIDOPAI]);
      SQL('  , ta.cod_animal_mae ',                                                    [fCODANIMALMANEJOMAE, fNOMANIMALMAE]);
      SQL('  , ta.dta_nascimento ',                                                    fDTANASCIMENTO);
      SQL('  , tr.sgl_raca ',                                                          fSGLRACA);
      SQL('  , dbo.FNT_COMPOSICAO_RACIAL(ta.cod_pessoa_produtor, ta.cod_animal) ',     fDESCOMPOSICAORACIAL);
      SQL('  , tmes.num_partida ',                                                     fNUMPARTIDA);
      SQL('  , tmes.dta_movimento ',                                                   fDTAMOVIMENTO);
      SQL('  , ttmes.sgl_tipo_mov_estoque_semen ',                                     fSGLTIPOMOVIMENTO);
      SQL('  , ttmes.des_tipo_mov_estoque_semen ',                                     fDESTIPOMOVIMENTO);
      SQL('  , case when tmes.cod_tipo_mov_estoque_semen = 3 then '+
          '      tps.nom_pessoa_secundaria '+
          '    end ',                                                                  fNOMPESSOACOMPRADOR);
      SQL('  , case when tmes.cod_tipo_mov_estoque_semen = 1 then '+
          '      tps.nom_pessoa_secundaria '+
          '    end ',                                                                  fNOMPESSOAFORNECEDOR);
      SQL('  , case when tmes.cod_tipo_mov_estoque_semen = 5 then '+
          '      tps.nom_pessoa_secundaria '+
          '    end ',                                                                  fNOMPESSOAINSEMINADOR);
      SQL('  , abs(tmes.qtd_doses_apto) ',                                             0);
      SQL('  , abs(tmes.qtd_doses_inapto) ',                                           0);
      SQL('  , tmes.qtd_doses_apto + tmes.qtd_doses_inapto ',                          0);
      SQL('from ', 0);
      SQL('  tab_movimento_estoque_semen tmes ', 0);
      SQL('  , tab_pessoa_secundaria tps ',                                            [fNOMPESSOAFORNECEDOR, fNOMPESSOACOMPRADOR, fNOMPESSOAINSEMINADOR]);
      SQL('  , tab_tipo_mov_estoque_semen ttmes ',                                     [fSGLTIPOMOVIMENTO, fDESTIPOMOVIMENTO]);
      SQL('  , tab_raca tr ',                                                          fSGLRACA);
      SQL('  , tab_fazenda tfm ',                                                      fCODANIMALMANEJO);
      SQL('  , tab_animal ta with (nolock) ', 0);
      SQL('  , tab_fazenda tf ',                                                       fSGLFAZENDA);
      SQL('  , tab_composicao_racial as tcr with (nolock) ',                           SE(IndAgrupRaca1 = 'N', 0, -1));
      SQL('  , tab_composicao_racial as tcr2 with (nolock) ',                          SE(IndAgrupRaca2 = 'N', 0, -1));
      SQL('  , tab_composicao_racial as tcr3 with (nolock) ',                          SE(IndAgrupRaca3 = 'N', 0, -1));
      SQL('  , tab_composicao_racial as tcr4 with (nolock) ',                          SE(IndAgrupRaca4 = 'N', 0, -1));
      SQL('where ', 0);
      SQL('  tmes.cod_pessoa_produtor = :cod_pessoa_produtor ', 0);
      SQL('  and tmes.ind_movimento_estorno <> ''S'' ', 0);
      SQL('  and tps.cod_pessoa_produtor =* tmes.cod_pessoa_produtor ',                [fNOMPESSOAFORNECEDOR, fNOMPESSOACOMPRADOR, fNOMPESSOAINSEMINADOR]);
      SQL('  and tps.cod_pessoa_secundaria =* tmes.cod_pessoa_secundaria ',            [fNOMPESSOAFORNECEDOR, fNOMPESSOACOMPRADOR, fNOMPESSOAINSEMINADOR]);
      SQL('  and ttmes.cod_tipo_mov_estoque_semen = tmes.cod_tipo_mov_estoque_semen ', [fSGLTIPOMOVIMENTO, fDESTIPOMOVIMENTO]);
      SQL('  and tr.cod_raca = ta.cod_raca ',                                          fSGLRACA);
      SQL('  and tfm.cod_pessoa_produtor =* ta.cod_pessoa_produtor ',                  fCODANIMALMANEJO);
      SQL('  and tfm.cod_fazenda =* ta.cod_fazenda_manejo ',                           fCODANIMALMANEJO);
      SQL('  and ta.cod_pessoa_produtor = tmes.cod_pessoa_produtor ', 0);
      SQL('  and ta.cod_animal = tmes.cod_animal ', 0);
      SQL('  and tf.cod_pessoa_produtor = tmes.cod_pessoa_produtor ',                  fSGLFAZENDA);
      SQL('  and tf.cod_fazenda = tmes.cod_fazenda ',                                  fSGLFAZENDA);
      If IndAgrupRaca1 = 'N' then begin
         SQL('  and ta.cod_animal = tcr.cod_animal  ',0);
         SQL('  and ta.cod_pessoa_produtor = tcr.cod_pessoa_produtor  ',0);
         SQL('  and tcr.cod_raca = :codraca1  ',0);
         SQL('  and tcr.qtd_composicao_racial between :qtdcompracialinicio1 and :qtdcompracialfim1  ',0);
      end;
      If IndAgrupRaca2 = 'N' then begin
         SQL('  and ta.cod_animal = tcr2.cod_animal  ',0);
         SQL('  and ta.cod_pessoa_produtor = tcr2.cod_pessoa_produtor  ',0);
         SQL('  and tcr2.cod_raca = :codraca2  ',0);
         SQL('  and tcr2.qtd_composicao_racial between :qtdcompracialinicio2 and :qtdcompracialfim2  ',0);
      end;
      If IndAgrupRaca3 = 'N' then begin
         SQL('  and ta.cod_animal = tcr3.cod_animal  ',0);
         SQL('  and ta.cod_pessoa_produtor = tcr3.cod_pessoa_produtor  ',0);
         SQL('  and tcr3.cod_raca = :codraca3  ',0);
         SQL('  and tcr3.qtd_composicao_racial between :qtdcompracialinicio3 and :qtdcompracialfim3  ',0);
      end;
      If IndAgrupRaca4 = 'N' then begin
         SQL('  and ta.cod_animal = tcr4.cod_animal  ',0);
         SQL('  and ta.cod_pessoa_produtor = tcr4.cod_pessoa_produtor  ',0);
         SQL('  and tcr4.cod_raca = :codraca4  ',0);
         SQL('  and tcr4.qtd_composicao_racial between :qtdcompracialinicio4 and :qtdcompracialfim4  ',0);
      end;
      If IndAgrupRaca1 = 'S' then begin
         SQL(' and ta.cod_animal in (select cod_animal ' +
             ' from tab_composicao_racial as tcr with (nolock), ' +
             ' tab_composicao_agrup_racas as tacr with (nolock) ' +
             ' where tacr.cod_agrupamento_racas = :codraca1 ' +
             ' and   tacr.cod_raca = tcr.cod_raca ' +
             ' and   tcr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
             ' group by cod_animal ' +
             ' having sum(qtd_composicao_racial) between :qtdcompracialinicio1 and :qtdcompracialfim1) ',0);
       end;
      If IndAgrupRaca2 = 'S' then begin
         SQL(' and ta.cod_animal in (select cod_animal ' +
             ' from tab_composicao_racial as tcr with (nolock), ' +
             ' tab_composicao_agrup_racas as tacr with (nolock) ' +
             ' where tacr.cod_agrupamento_racas = :codraca2 ' +
             ' and   tcr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
             ' and   tacr.cod_raca = tcr.cod_raca ' +
             ' group by cod_animal ' +
             ' having sum(qtd_composicao_racial) between :qtdcompracialinicio2 and :qtdcompracialfim2) ',0);
      end;
      If IndAgrupRaca3 = 'S' then begin
         SQL(' and ta.cod_animal in (select cod_animal ' +
             ' from tab_composicao_racial as tcr with (nolock), ' +
             ' tab_composicao_agrup_racas as tacr with (nolock) ' +
             ' where tacr.cod_agrupamento_racas = :codraca3 ' +
             ' and   tcr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
             ' and   tacr.cod_raca = tcr.cod_raca ' +
             ' group by cod_animal ' +
             ' having sum(qtd_composicao_racial) between :qtdcompracialinicio3 and :qtdcompracialfim3) ',0);
      end;
      If IndAgrupRaca4 = 'S' then begin
         SQL(' and ta.cod_animal in (select cod_animal ' +
             ' from tab_composicao_racial as tcr with (nolock), ' +
             ' tab_composicao_agrup_racas as tacr with (nolock) ' +
             ' where tacr.cod_agrupamento_racas = :codraca4 ' +
             ' and   tcr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
             ' and   tacr.cod_raca = tcr.cod_raca ' +
             ' group by cod_animal ' +
             ' having sum(qtd_composicao_racial) between :qtdcompracialinicio4 and :qtdcompracialfim4) ',0);
      end;
      If (IndAgrupRaca1 = 'N') or (IndAgrupRaca1 = 'S') then begin
          Query.ParamByName('codraca1').AsInteger := CodRaca1;
          Query.ParamByName('qtdcompracialinicio1').Asfloat := QtdComposicaoRacialInicio1;
          Query.ParamByName('qtdcompracialfim1').Asfloat := QtdComposicaoRacialFim1;
      end;
      If (IndAgrupRaca2 = 'N') or (IndAgrupRaca2 = 'S') then begin
          Query.ParamByName('codraca2').AsInteger := CodRaca2;
          Query.ParamByName('qtdcompracialinicio2').Asfloat := QtdComposicaoRacialInicio2;
          Query.ParamByName('qtdcompracialfim2').Asfloat := QtdComposicaoRacialFim2;
      end;
      If (IndAgrupRaca3 = 'N') or (IndAgrupRaca3 = 'S') then begin
          Query.ParamByName('codraca3').AsInteger := CodRaca3;
          Query.ParamByName('qtdcompracialinicio3').Asfloat := QtdComposicaoRacialInicio3;
          Query.ParamByName('qtdcompracialfim3').Asfloat := QtdComposicaoRacialFim3;
      end;
      If (IndAgrupRaca4 = 'N') or (IndAgrupRaca4 = 'S') then begin
          Query.ParamByName('codraca4').AsInteger := CodRaca4;
          Query.ParamByName('qtdcompracialinicio4').Asfloat := QtdComposicaoRacialInicio4;
          Query.ParamByName('qtdcompracialfim4').Asfloat := QtdComposicaoRacialFim4;
      end;
      Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;

      // Critérios de pesquisa
      if CodFazenda > 0 then begin
        SQL('  and tmes.cod_fazenda = :cod_fazenda ', 0);
        Query.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      end;
      if CodFazendaManejo > 0 then begin
        SQL('  and ta.cod_fazenda_manejo = :cod_fazenda_manejo ', 0);
        Query.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      end;
      if (CodAnimalManejoInicio <> '') and (CodAnimalManejoFim <> '') then begin
        SQL('  and ta.cod_animal_manejo between :cod_animal_manejo_inicio and :cod_animal_manejo_fim ', 0);
        Query.ParamByName('cod_animal_manejo_inicio').AsString := CodAnimalManejoInicio;
        Query.ParamByName('cod_animal_manejo_fim').AsString := CodAnimalManejoFim;
      end;
      if NomAnimal <> '' then begin
        SQL('  and ta.nom_animal like :nom_animal ', 0);
        Query.ParamByName('nom_animal').AsString := NomAnimal + '%';
      end;
      if DesApelido <> '' then begin
        SQL('  and ta.des_apelido like :des_apelido ', 0);
        Query.ParamByName('des_apelido').AsString := DesApelido + '%';
      end;
      if (DtaNascimentoInicio > 0 ) and (DtaNascimentoFim > 0) then begin
        SQL('  and ( ta.dta_nascimento >= :dta_nascimento_inicio and ta.dta_nascimento < :dta_nascimento_fim ) ', 0);
        Query.ParamByName('dta_nascimento_inicio').AsDateTime := Trunc(DtaNascimentoInicio);
        Query.ParamByName('dta_nascimento_fim').AsDateTime := Trunc(DtaNascimentoFim)+1;
      end;
      if CodRacas <> '' then begin
        SQL('  and ta.cod_raca in ( '+CodRacas+' ) ', 0);
      end;
      if NumRGD <> '' then begin
        SQL('  and ta.num_rgd = :num_rgd ', 0);
        Query.ParamByName('num_rgd').AsString := NumRGD;
      end;
      if (NumPartidaInicio <> '') and (NumPartidaFim <> '') then begin
        SQL('  and tmes.num_partida between :num_partida_inicio and :num_partida_fim ', 0);
        Query.ParamByName('num_partida_inicio').AsString := NumPartidaInicio;
        Query.ParamByName('num_partida_fim').AsString := NumPartidaFim;
      end;
      if CodTipoMovimentos <> '' then begin
        SQL('  and tmes.cod_tipo_mov_estoque_semen in ( '+CodTipoMovimentos+' ) ', 0);
      end;
      if (DtaMovimentoInicio > 0 ) and (DtaMovimentoFim > 0) then begin
        SQL('  and ( tmes.dta_movimento >= :dta_movimento_inicio and tmes.dta_movimento < :dta_movimento_fim ) ', 0);
        Query.ParamByName('dta_movimento_inicio').AsDateTime := Trunc(DtaMovimentoInicio);
        Query.ParamByName('dta_movimento_fim').AsDateTime := Trunc(DtaMovimentoFim)+1;
      end;
      if not Pertence(1, CodTipoMovimentos) then begin // Se mov de compra não foi selecionado
        CodPessoaFornecedores := '';
      end;
      if not Pertence(3, CodTipoMovimentos) then begin // Se mov de venda não foi selecionado
        CodPessoaCompradores := '';
      end;
      if (CodPessoaFornecedores  <> '') and (CodPessoaCompradores = '') then begin
        SQL('  and tmes.cod_pessoa_secundaria in ( '+CodPessoaFornecedores+' ) ', 0);
      end else if (CodPessoaFornecedores  = '') and (CodPessoaCompradores <> '') then begin
        SQL('  and tmes.cod_pessoa_secundaria in ( '+CodPessoaCompradores+' ) ', 0);
      end else if (CodPessoaFornecedores <> '') and (CodPessoaCompradores <> '') then begin
        SQL('  and ( tmes.cod_pessoa_secundaria in ( '+CodPessoaFornecedores+' ) ', 0);
        SQL('        or tmes.cod_pessoa_secundaria in ( '+CodPessoaCompradores+' ) ', 0);
      end;
      if Pertence(8, CodTipoMovimentos) then begin // Se mov de transferência foi selecionado
        if (CodFazendaOrigem > 0) and not(CodFazendaDestino > 0) then begin
          SQL('  and ( tmes.seq_movimento = 1 and tmes.cod_fazenda_relacionada = :cod_fazenda_origem ) ', 0);
          Query.ParamByName('cod_fazenda_origem').AsInteger := CodFazendaOrigem;
        end else if not(CodFazendaOrigem > 0) and (CodFazendaDestino > 0) then begin
          SQL('  and ( tmes.seq_movimento = 1 and tmes.cod_fazenda = :cod_fazenda_destino ) ', 0);
          Query.ParamByName('cod_fazenda_destino').AsInteger := CodFazendaDestino;
        end else if (CodFazendaOrigem > 0) and (CodFazendaDestino > 0) then begin
          SQL('  and ( tmes.cod_fazenda = :cod_fazenda_destino '+
              '        and tmes.cod_fazenda_relacionada = :cod_fazenda_origem ) ', 0);
          Query.ParamByName('cod_fazenda_destino').AsInteger := CodFazendaDestino;
          Query.ParamByName('cod_fazenda_origem').AsInteger := CodFazendaOrigem;
        end;
      end;
//      Query.SQL.SaveToFile('c:\tmp\Insert.sql');
      Query.ExecSQL;

      //Caso o usuário logado seja um técnico (CodPapelUsuario = 3) mostrar mensagem 1697!
      if Conexao.CodPapelUsuario = 3 then begin
         Mensagens.Adicionar(1697, Self.ClassName, NomMetodo, []);
      end;

      // Atualiza informações do pai quando necessário
      if not(bPersonalizavel)
        or (IntRelatorios.CampoAssociado(fCODANIMALMANEJOPAI) = 1)
        or (IntRelatorios.CampoAssociado(fNOMANIMALPAI) = 1)
        or (IntRelatorios.CampoAssociado(fDESAPELIDOPAI) = 1)
        then begin
        Query.SQL.Text :=
          'update '+
          '  #tmp_relatorio_estoque_semen '+
          'set '+
          '  CodAnimalManejoPai = '+
          '    case '+
          '      when tap.cod_fazenda_manejo is null then '+
          '        tap.cod_animal_manejo '+
          '      else '+
          '        tfmp.sgl_fazenda + '' '' + tap.cod_animal_manejo '+
          '    end '+
          '  , NomAnimalPai = tap.nom_animal '+
          '  , DesApelidoPai = tap.des_apelido '+
          'from '+
          '  tab_animal tap '+
          '  , tab_fazenda tfmp '+
          'where '+
          '  tfmp.cod_pessoa_produtor =* tap.cod_pessoa_produtor '+
          '  and tfmp.cod_fazenda =* tap.cod_fazenda_manejo '+
          '  and tap.cod_pessoa_produtor = #tmp_relatorio_estoque_semen.cod_pessoa_produtor '+
          '  and tap.cod_animal = #tmp_relatorio_estoque_semen.cod_animal_pai '+
          '  and #tmp_relatorio_estoque_semen.cod_animal_pai is not null ';
//        Query.SQL.SaveToFile('c:\tmp\UpdatePai.sql');
        Query.ExecSQL;
      end;

      // Atualiza informações da mãe quando necessário
      if not(bPersonalizavel)
        or (IntRelatorios.CampoAssociado(fCODANIMALMANEJOMAE) = 1)
        or (IntRelatorios.CampoAssociado(fNOMANIMALMAE) = 1)
        then begin
        Query.SQL.Text :=
          'update '+
          '  #tmp_relatorio_estoque_semen '+
          'set '+
          '  CodAnimalManejoMae = '+
          '    case '+
          '      when tam.cod_fazenda_manejo is null then '+
          '        tam.cod_animal_manejo '+
          '      else '+
          '        tfmm.sgl_fazenda + '' '' + tam.cod_animal_manejo '+
          '    end '+
          '  , NomAnimalMae = tam.nom_animal '+
          'from '+
          '  tab_animal tam '+
          '  , tab_fazenda tfmm '+
          'where '+
          '  tfmm.cod_pessoa_produtor =* tam.cod_pessoa_produtor '+
          '  and tfmm.cod_fazenda =* tam.cod_fazenda_manejo '+
          '  and tam.cod_pessoa_produtor = #tmp_relatorio_estoque_semen.cod_pessoa_produtor '+
          '  and tam.cod_animal = #tmp_relatorio_estoque_semen.cod_animal_mae '+
          '  and #tmp_relatorio_estoque_semen.cod_animal_mae is not null ';
//        Query.SQL.SaveToFile('c:\tmp\UpdateMae.sql');
        Query.ExecSQL;
      end;

      // Recupera os dados que serão apresentados no relatório
      Query.SQL.Clear;
      SQL('select ', 0);
      SQL('  null ', 0);
      bGroupBy := False;
      IntRelatorios.IrAoPrimeiro;
      while not IntRelatorios.EOF do begin
        if (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesApto')
          and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesInapto')
          and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesTotal')
          then begin
          sAux := '  , '+IntRelatorios.ValorCampo('NomField');
          if SQL(sAux, SE(not bPersonalizavel
            or (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S')
            or (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S'), 0, -1))
            and not(bGroupBy) then bGroupBy := True;
        end;
        IntRelatorios.IrAoProximo;
      end;
      SQL('  , sum(abs(QtdDosesApto)) as QtdDosesApto ', 0);
      SQL('  , sum(abs(QtdDosesInapto)) as QtdDosesInapto ', 0);
      SQL('  , sum(abs(QtdDosesApto)+abs(QtdDosesInapto)) as QtdDosesTotal ', 0);
      SQL('from ', 0);
      SQL('  #tmp_relatorio_estoque_semen ', 0);
      SQL('where ', 0);
      SQL('  cod_pessoa_produtor is not null ', 0);

      // Realiza "group by" por campos selecionados
      if bGroupBy then begin
        SQL('group by ', 0);
        bAux := False;
        IntRelatorios.IrAoPrimeiro;
        while not IntRelatorios.EOF do begin
          if (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesApto')
            and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesInapto')
            and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesTotal')
            then begin
            sAux := SE(bAux, '  , ', '  ')+IntRelatorios.ValorCampo('NomField');
            if SQL(sAux, SE(not bPersonalizavel
              or (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S')
              or (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S'), 0, -1))
              and not(bAux) then bAux := True;
          end;
          IntRelatorios.IrAoProximo;
        end;
      end;

      // Critérios referentes a quantidades totalizadas
      if (QtdAptoInicio > 0) and (QtdAptoFim > 0)
        and (QtdInaptoInicio > 0) and (QtdInaptoFim > 0) then begin
        SQL('having ', 0);
        SQL('  ( sum(abs(QtdDosesApto)) between :qtd_doses_apto_inicio and :qtd_doses_apto_fim '+
            '    or sum(abs(QtdDosesInapto)) between :qtd_doses_inapto_inicio and :qtd_doses_inapto_fim ) ', 0);
        Query.ParamByName('qtd_doses_apto_inicio').AsInteger := QtdAptoInicio;
        Query.ParamByName('qtd_doses_apto_fim').AsInteger := QtdAptoFim;
        Query.ParamByName('qtd_doses_inapto_inicio').AsInteger := QtdInaptoInicio;
        Query.ParamByName('qtd_doses_inapto_fim').AsInteger := QtdInaptoFim;
      end else if (QtdAptoInicio > 0) and (QtdAptoFim > 0) then begin
        SQL('having ', 0);
        SQL('  sum(abs(QtdDosesApto)) between :qtd_doses_apto_inicio and :qtd_doses_apto_fim ', 0);
        Query.ParamByName('qtd_doses_apto_inicio').AsInteger := QtdAptoInicio;
        Query.ParamByName('qtd_doses_apto_fim').AsInteger := QtdAptoFim;
      end else if (QtdInaptoInicio > 0) and (QtdInaptoFim > 0) then begin
        SQL('having ', 0);
        SQL('  sum(abs(QtdDosesInapto)) between :qtd_doses_inapto_inicio and :qtd_doses_inapto_fim ', 0);
        Query.ParamByName('qtd_doses_inapto_inicio').AsInteger := QtdInaptoInicio;
        Query.ParamByName('qtd_doses_inapto_fim').AsInteger := QtdInaptoFim;
      end;

      // Realiza "order by" por campos selecionados
      if bGroupBy then begin
        SQL('order by ', 0);
        bAux := False;
        IntRelatorios.IrAoPrimeiro;
        while not IntRelatorios.EOF do begin
          if (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesApto')
            and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesInapto')
            and (IntRelatorios.ValorCampo('NomField') <> 'QtdDosesTotal')
            then begin
            sAux := SE(bAux, '  , ', '  ')+IntRelatorios.ValorCampo('NomField');
            if SQL(sAux, SE(not bPersonalizavel
              or (IntRelatorios.ValorCampo('IndCampoObrigatorio') = 'S')
              or (IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S'), 0, -1))
              and not(bAux) then bAux := True;
          end;
          IntRelatorios.IrAoProximo;
        end;
      end;

      // Realiza consulta a massa de dados preparada
//      Query.SQL.SaveToFile('c:\tmp\Select.sql');
      Query.Open;

      // Identifica procedimento como bem sucedido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1522, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1522;
        Exit;
      End;
    End;
  finally
    IntRelatorios.Free;
  end;
end;

function TIntEstoqueSemen.Buscar(CodMovimento,
  SeqMovimento: Integer): Integer;
const
  Metodo: Integer = 426;
  NomeMetodo: String = 'Buscar';
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Busca dados do evento
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  tmes.cod_movimento '+
        '  , tmes.seq_movimento '+
        '  , tmes.cod_fazenda '+
        '  , tf.sgl_fazenda '+
        '  , tf.nom_fazenda '+
        '  , tmes.cod_animal '+
        '  , tfa.sgl_fazenda as sgl_fazenda_manejo '+
        '  , ta.cod_animal_manejo '+
        '  , ta.nom_animal '+
        '  , ta.des_apelido '+
        '  , tmes.num_partida '+
        '  , tmes.dta_movimento '+
        '  , tmes.cod_tipo_mov_estoque_semen '+
        '  , ttmes.sgl_tipo_mov_estoque_semen '+
        '  , ttmes.des_tipo_mov_estoque_semen '+
        '  , tmes.qtd_doses_apto '+
        '  , tmes.qtd_doses_inapto '+
        '  , tmes.txt_observacao '+
        '  , tmes.dta_cadastramento '+
        '  , tmes.cod_usuario '+
        '  , tu.nom_usuario '+
        '  , tmes.ind_movimento_estorno '+
        '  , tmes.cod_pessoa_secundaria '+
        '  , tmes.cod_fazenda_relacionada '+
        '  , tmes.cod_animal_femea '+
        'from '+
        '  tab_fazenda tf '+
        '  , tab_fazenda tfa '+
        '  , tab_animal ta '+
        '  , tab_tipo_mov_estoque_semen ttmes '+
        '  , tab_usuario tu '+
        '  , tab_movimento_estoque_semen tmes '+
        'where '+
        '  tf.cod_pessoa_produtor = tmes.cod_pessoa_produtor '+
        '  and tf.cod_fazenda = tmes.cod_fazenda '+
{IFDEF MSSQL}
        '  and tfa.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
        '  and tfa.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
        '  and ta.cod_pessoa_produtor = tmes.cod_pessoa_produtor '+
        '  and ta.cod_animal = tmes.cod_animal '+
        '  and ttmes.cod_tipo_mov_estoque_semen = tmes.cod_tipo_mov_estoque_semen '+
        '  and tu.cod_usuario = tmes.cod_usuario '+
        '  and tmes.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and tmes.cod_movimento = :cod_movimento '+
        '  and tmes.seq_movimento = :seq_movimento ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_movimento').AsInteger := CodMovimento;
      Q.ParamByName('seq_movimento').AsInteger := SeqMovimento;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1427, Self.ClassName, NomeMetodo, []);
        Result := -1427;
        Exit;
      end;

      // Popula propriedades básicas, comuns a todos os tipos de movimentos
      IntMovimentoEstoqueSemen.CodMovimento := Q.FieldByName('cod_movimento').AsInteger;
      IntMovimentoEstoqueSemen.SeqMovimento := Q.FieldByName('seq_movimento').AsInteger;
      IntMovimentoEstoqueSemen.CodFazenda := Q.FieldByName('cod_fazenda').AsInteger;
      IntMovimentoEstoqueSemen.SglFazenda := Q.FieldByName('sgl_fazenda').AsString;
      IntMovimentoEstoqueSemen.NomFazenda := Q.FieldByName('nom_fazenda').AsString;
      IntMovimentoEstoqueSemen.CodAnimal := Q.FieldByName('cod_animal').AsInteger;
      IntMovimentoEstoqueSemen.SglFazendaManejo := Q.FieldByName('sgl_fazenda_manejo').AsString;
      IntMovimentoEstoqueSemen.CodAnimalManejo := Q.FieldByName('cod_animal_manejo').AsString;
      IntMovimentoEstoqueSemen.NomAnimal := Q.FieldByName('nom_animal').AsString;
      IntMovimentoEstoqueSemen.DesApelido := Q.FieldByName('des_apelido').AsString;
      IntMovimentoEstoqueSemen.NumPartida := Q.FieldByName('num_partida').AsString;
      IntMovimentoEstoqueSemen.DtaMovimento := Q.FieldByName('dta_movimento').AsDateTime;
      IntMovimentoEstoqueSemen.CodTipoMovEstoqueSemen := Q.FieldByName('cod_tipo_mov_estoque_semen').AsInteger;
      IntMovimentoEstoqueSemen.DesTipoMovEstoqueSemen := Q.FieldByName('des_tipo_mov_estoque_semen').AsString;
      IntMovimentoEstoqueSemen.SglTipoMovEstoqueSemen := Q.FieldByName('sgl_tipo_mov_estoque_semen').AsString;
      IntMovimentoEstoqueSemen.QtdDosesSemenApto := Q.FieldByName('qtd_doses_apto').AsInteger;
      IntMovimentoEstoqueSemen.QtdDosesSemenInapto := Q.FieldByName('qtd_doses_inapto').AsInteger;
      IntMovimentoEstoqueSemen.TxtObservacao := Q.FieldByName('txt_observacao').AsString;
      IntMovimentoEstoqueSemen.DtaCadastramento := Q.FieldByName('dta_cadastramento').AsDateTime;
      IntMovimentoEstoqueSemen.CodUsuario := Q.FieldByName('cod_usuario').AsInteger;
      IntMovimentoEstoqueSemen.NomUsuario := Q.FieldByName('nom_usuario').AsString;
      IntMovimentoEstoqueSemen.IndMovimentoEstorno := Q.FieldByName('ind_movimento_estorno').AsString;
      IntMovimentoEstoqueSemen.CodPessoaSecundaria := Q.FieldByName('cod_pessoa_secundaria').AsInteger;
      IntMovimentoEstoqueSemen.CodFazendaRelacionada := Q.FieldByName('cod_fazenda_relacionada').AsInteger;
      IntMovimentoEstoqueSemen.CodAnimalFemea := Q.FieldByName('cod_animal_femea').AsInteger;

      // Busca dados de pessoa secundária (criador ou compra, depende do tipo do movimento)
      if (IntMovimentoEstoqueSemen.CodTipoMovEstoqueSemen in [ctmesCompra, ctmesVenda])
        and (IntMovimentoEstoqueSemen.CodPessoaSecundaria > 0) then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  nom_pessoa_secundaria '+
          '  , num_cnpj_cpf '+
          'from '+
          '  tab_pessoa_secundaria '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_pessoa_secundaria = :cod_pessoa_secundaria ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := IntMovimentoEstoqueSemen.CodPessoaSecundaria;
        Q.Open;
        IntMovimentoEstoqueSemen.NomPessoaSecundaria := Q.FieldByName('nom_pessoa_secundaria').AsString;
        IntMovimentoEstoqueSemen.NumCNPJCPFPessoaSecundaria := Q.FieldByName('num_cnpj_cpf').AsString;
      end else begin
        IntMovimentoEstoqueSemen.NomPessoaSecundaria := '';
        IntMovimentoEstoqueSemen.NumCNPJCPFPessoaSecundaria := '';
      end;

      // Busca fazenda relacionada (origem ou destino, depende do seq_movimento)
      if (IntMovimentoEstoqueSemen.CodTipoMovEstoqueSemen in [ctmesTransferencia])
        and (IntMovimentoEstoqueSemen.CodFazendaRelacionada > 0) then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  sgl_fazenda '+
          '  , nom_fazenda '+
          'from '+
          '  tab_fazenda '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_fazenda = :cod_fazenda ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := IntMovimentoEstoqueSemen.CodFazendaRelacionada;
        Q.Open;
        IntMovimentoEstoqueSemen.SglFazendaRelacionada := Q.FieldByName('sgl_fazenda').AsString;
        IntMovimentoEstoqueSemen.NomFazendaRelacionada := Q.FieldByName('nom_fazenda').AsString;
      end else begin
        IntMovimentoEstoqueSemen.SglFazendaRelacionada := '';
        IntMovimentoEstoqueSemen.NomFazendaRelacionada := '';
      end;

      if (IntMovimentoEstoqueSemen.CodTipoMovEstoqueSemen in [ctmesUtilizacao])
        and (IntMovimentoEstoqueSemen.CodAnimalFemea > 0) then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  sgl_fazenda as sgl_fazenda_manejo '+
          '  , cod_animal_manejo '+
          'from '+
          '  tab_animal ta '+
          '  , tab_fazenda tf '+
          'where '+
{IFDEF MSSQL}
          '  tf.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
          '  and tf.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
          '  and ta.cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and ta.cod_animal = :cod_animal ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_animal').AsInteger := IntMovimentoEstoqueSemen.CodAnimalFemea;
        Q.Open;
        IntMovimentoEstoqueSemen.SglFazendaManejoFemea := Q.FieldByName('sgl_fazenda_manejo').AsString;
        IntMovimentoEstoqueSemen.CodAnimalManejoFemea := Q.FieldByName('cod_animal_manejo').AsString;
      end else begin
        IntMovimentoEstoqueSemen.SglFazendaManejoFemea := '';
        IntMovimentoEstoqueSemen.CodAnimalManejoFemea := '';
      end;

      // Identifica a operação sobre o estoque de sêmen apto
      if IntMovimentoEstoqueSemen.QtdDosesSemenApto > 0 then begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueApto := 'E';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueApto := 'Entrada';
      end else if IntMovimentoEstoqueSemen.QtdDosesSemenApto < 0 then begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueApto := 'S';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueApto := 'Saída';
      end else begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueApto := '';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueApto := '';
      end;

      // Identifica a operação sobre o estoque de sêmen inapto
      if IntMovimentoEstoqueSemen.QtdDosesSemenInapto > 0 then begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueInapto := 'E';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueInapto := 'Entrada';
      end else if IntMovimentoEstoqueSemen.QtdDosesSemenInapto < 0 then begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueInapto := 'S';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueInapto := 'Saída';
      end else begin
        IntMovimentoEstoqueSemen.CodOperacaoMovEstoqueInapto := '';
        IntMovimentoEstoqueSemen.DesOperacaoMovEstoqueInapto := '';
      end;

      // Torna os valores qtd doses do movimento em valores absolutos
      IntMovimentoEstoqueSemen.QtdDosesSemenApto := Abs(IntMovimentoEstoqueSemen.QtdDosesSemenApto);
      IntMovimentoEstoqueSemen.QtdDosesSemenInapto := Abs(IntMovimentoEstoqueSemen.QtdDosesSemenInapto);

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1428, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1428;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.InserirMovimento(CodTipoMovEstoqueSemen,
  CodFazenda, CodAnimal, CodFazendaManejo: Integer; CodAnimalManejo,
  NumPartida: String; DtaMovimento: TDateTime; CodPessoaSecundaria,
  CodAnimalFemea, CodFazendaDestino, QtdDosesApto, QtdDosesInapto: Integer;
  TxtObservacao, IndSistema: String): Integer;
const
  Metodo: Integer = 425;
  NomeMetodo: String = 'InserirMovimento';
var
  Q: THerdomQuery;
  bExiste: Boolean;
  dAux: TDateTime;
  iCodMovimento, iSeqMovimento: Integer;
  DadosAnimal: TDadosAnimal;
  iSaldoDosesSemen: TQtdDosesSemen;

  function DadosVenda: TDadosEvento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  te.dta_inicio '+
      '  , tae.cod_categoria_animal '+
      'from '+
      '  tab_evento te '+
      '  , tab_animal_evento tae '+
      'where '+
      '  te.cod_tipo_evento in (9, 10, 20) '+
      '  and te.cod_pessoa_produtor = tae.cod_pessoa_produtor '+
      '  and te.cod_evento = tae.cod_evento '+
      '  and tae.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and tae.cod_animal = :cod_animal ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_animal').AsInteger := CodAnimal;
    Q.Open;
    Result.DtaEvento := Q.FieldByName('dta_inicio').AsDateTime;
    Result.CodCategoriaAnimal := Q.FieldByName('cod_categoria_animal').AsInteger;
  end;

  function DadosMorte: TDadosEvento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  te.dta_inicio '+
      '  , tae.cod_categoria_animal '+
      'from '+
      '  tab_evento te '+
      '  , tab_animal_evento tae '+
      'where '+
      '  te.cod_tipo_evento in (12, 19) '+
      '  and te.cod_pessoa_produtor = tae.cod_pessoa_produtor '+
      '  and te.cod_evento = tae.cod_evento '+
      '  and tae.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and tae.cod_animal = :cod_animal ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_animal').AsInteger := CodAnimal;
    Q.Open;
    Result.DtaEvento := Q.FieldByName('dta_inicio').AsDateTime;
    Result.CodCategoriaAnimal := Q.FieldByName('cod_categoria_animal').AsInteger;
  end;

  function DadosDesaparecimento: TDadosEvento;
  begin
    Q.Close;
    Q.SQL.Text :=
      'select '+
      '  te.dta_inicio '+
      '  , tae.cod_categoria_animal '+
      'from '+
      '  tab_evento te '+
      '  , tab_animal_evento tae '+
      'where '+
      '  te.cod_tipo_evento in (11, 18) '+
      '  and te.cod_pessoa_produtor = tae.cod_pessoa_produtor '+
      '  and te.cod_evento = tae.cod_evento '+
      '  and tae.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and tae.cod_animal = :cod_animal ';
    Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Q.ParamByName('cod_animal').AsInteger := CodAnimal;
    Q.Open;
    Result.DtaEvento := Q.FieldByName('dta_inicio').AsDateTime;
    Result.CodCategoriaAnimal := Q.FieldByName('cod_categoria_animal').AsInteger;
  end;

  function ConsistirAnimalTouroAtivo: Integer;
  var
    DadosEvento: TDadosEvento;
  begin
    if DadosAnimal.CodTipoOrigem = 4 then begin
      Mensagens.Adicionar(1405, Self.ClassName, NomeMetodo, []);
      Result := -1405;
      Exit;
    end else begin
      if DadosAnimal.CodTipoOrigem = 2 then begin
        if DtaMovimento < DadosAnimal.DtaCompra then begin // Compra
          Mensagens.Adicionar(1430, Self.ClassName, NomeMetodo, []);
          Result := -1430;
          Exit;
        end;
      end;
      case DadosAnimal.CodCategoriaAnimal of
        12: // Vendido
          DadosEvento := DadosVenda;
        13: // Morto
          DadosEvento := DadosMorte;
        14: // Desaparecido
          DadosEvento := DadosDesaparecimento;
        else
          DadosEvento.DtaEvento := 0;
          DadosEvento.CodCategoriaAnimal := 0;
      end;
      if DadosEvento.DtaEvento > 0 then begin
        if DadosEvento.DtaEvento < DtaMovimento then begin
          Mensagens.Adicionar(1405, Self.ClassName, NomeMetodo, []);
          Result := -1405;
          Exit;
        end else if DadosEvento.CodCategoriaAnimal <> 4 then begin
          Mensagens.Adicionar(1415, Self.ClassName, NomeMetodo, []);
          Result := -1415;
          Exit;
        end;
      end else if DadosAnimal.CodCategoriaAnimal <> 4 then begin
        Mensagens.Adicionar(1415, Self.ClassName, NomeMetodo, []);
        Result := -1415;
        Exit;
      end;
    end;
    Result := 0;
  end;

  function ConsistirAnimalFemeaAtivo: Integer;
  var
    DadosEvento: TDadosEvento;
    DadosFemea: TDadosAnimal;
  begin
    // Consiste existência do animal informado
    Result := ConsistirAnimal(CodAnimalFemea, DadosFemea);
    if Result < 0 then Exit;

    // Consiste animal identificado
    if DadosFemea.CodTipoOrigem = 4 then begin
      Mensagens.Adicionar(1431, Self.ClassName, NomeMetodo, []);
      Result := -1431;
      Exit;
    end else begin
      if DadosFemea.CodTipoOrigem = 2 then begin
        if DtaMovimento < DadosFemea.DtaCompra then begin // Compra
          Mensagens.Adicionar(1430, Self.ClassName, NomeMetodo, []);
          Result := -1430;
          Exit;
        end;
      end;
      case DadosFemea.CodCategoriaAnimal of
        12: // Vendido
          DadosEvento := DadosVenda;
        13: // Morto
          DadosEvento := DadosMorte;
        14: // Desaparecido
          DadosEvento := DadosDesaparecimento;
        else
          DadosEvento.DtaEvento := 0;
          DadosEvento.CodCategoriaAnimal := 0;
      end;
      if DadosEvento.DtaEvento > 0 then begin
        if DadosEvento.DtaEvento < DtaMovimento then begin
          Mensagens.Adicionar(1431, Self.ClassName, NomeMetodo, []);
          Result := -1431;
          Exit;
        end;
      end;
      if DadosFemea.Sexo <> 'F' then begin
        Mensagens.Adicionar(1432, Self.ClassName, NomeMetodo, []);
        Result := -1432;
        Exit;
      end;
    end;
    Result := 0;
  end;

  function ConsistirSaida: Integer;
  begin
    // Regra: Verificar se o valor que está sendo lançado é menor ou igual do
    // do que o saldo atual, caso não seja identifica e apresenta uma mensagem
    // inteligente ao usuário.
    if ((QtdDosesApto > 0) and (iSaldoDosesSemen.Apto < QtdDosesApto))
      or ((QtdDosesInapto > 0) and (iSaldoDosesSemen.Inapto < QtdDosesInapto)) then begin
      Mensagens.Adicionar(1413, Self.ClassName, NomeMetodo, []);
      Result := -1413;
      Exit;
    end;
    Result := 0;
  end;

  function ConsistirCompra: Integer;
  var
    DadosEvento: TDadosEvento;
  begin
    // Regra: Somente animais válidos, externos ou comprados com data da compra
    // superior à data de compra do sêmen, ou ainda vendidos com data da venda
    // inferior à data de compra do sêmen.
    if DadosAnimal.CodCategoriaAnimal = 12 then begin // Animal vendido
      DadosEvento := DadosVenda;
      if DadosEvento.DtaEvento > DtaMovimento then begin
        Mensagens.Adicionar(1400, Self.ClassName, NomeMetodo, []);
        Result := -1400;
        Exit;
      end;
    end else if DadosAnimal.CodTipoOrigem = 2 then begin // Compra
      if DtaMovimento < DadosAnimal.DtaCompra then begin
        Mensagens.Adicionar(1430, Self.ClassName, NomeMetodo, []);
        Result := -1430;
        Exit;
      end else begin
        Mensagens.Adicionar(1400, Self.ClassName, NomeMetodo, []);
        Result := -1400;
        Exit;
      end;
    end else if DadosAnimal.CodTipoOrigem <> 4 then begin // Externo
      Mensagens.Adicionar(1401, Self.ClassName, NomeMetodo, []);
      Result := -1401;
      Exit;
    end;

    // Consiste pessoa secundária, caso a mesma tenha sido informada
    if CodPessoaSecundaria > 0 then begin
      Result := ConsistirPessoaSecundaria(CodPessoaSecundaria, 5); // Fornecedor de Sêmen
      if Result < 0 then Exit;
    end;
    Result := 0;
  end;

  function ConsistirColeta: Integer;
  begin
    // Regra: Somente animais ativos na data da coleta
    Result := ConsistirAnimalTouroAtivo;
  end;

  function ConsistirVenda: Integer;
  begin
    // Consistência padrão para eventos de saída
    Result := ConsistirSaida;
    if Result < 0 then Exit;

    // Consiste pessoa secundária, caso a mesma tenha sido informada
    if CodPessoaSecundaria > 0 then begin
      Result := ConsistirPessoaSecundaria(CodPessoaSecundaria, -1);
      if Result < 0 then Exit;
    end;
    Result := 0;
  end;

  function ConsistirPerda: Integer;
  begin
    // Consistência padrão para eventos de saída
    Result := ConsistirSaida;
  end;

  function ConsistirUtilizacao: Integer;
  begin
    // Verifica se não foi informada quantidade de sêmen inapto para utilização
    if QtdDosesInapto <> 0 then begin
      Mensagens.Adicionar(1414, Self.ClassName, NomeMetodo, []);
      Result := -1414;
      Exit;
    end;

    // Consistência padrão para eventos de saída
    Result := ConsistirSaida;
    if Result < 0 then Exit;

    // Consiste animal fêmea informado
    Result := ConsistirAnimalFemeaAtivo;
    if Result < 0 then Exit;

    // Consiste pessoa secundária, caso a mesma tenha sido informada
    if CodPessoaSecundaria > 0 then begin
      Result := ConsistirPessoaSecundaria(CodPessoaSecundaria, 6); // Inseminador
      if Result < 0 then Exit;
    end;
  end;

  function ConsistirLiberacao: Integer;
  begin
    // Consiste saldo inapto para liberação
    if iSaldoDosesSemen.Inapto < QtdDosesInapto then begin
      Mensagens.Adicionar(1416, Self.ClassName, NomeMetodo, []);
      Result := -1416;
      Exit;
    end;
    Result := 0;
  end;

  function ConsistirBloqueio: Integer;
  begin
    // Consiste saldo inapto para liberação
    if iSaldoDosesSemen.Inapto < QtdDosesInapto then begin
      Mensagens.Adicionar(1417, Self.ClassName, NomeMetodo, []);
      Result := -1417;
      Exit;
    end;
    Result := 0;
  end;

  function ConsistirTransferencia: Integer;
  begin
    // Consistindo fazenda
    Result := ConsistirFazenda(CodFazendaDestino);
  end;

begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Trata Observação
  If TxtObservacao <> '' Then Begin
    Result := TrataString(TxtObservacao, 255, 'Observação');
    If Result < 0 Then Exit;
  End;

  // Consiste parâmetros de identificação do animal
  If (CodAnimal > 0) and ((CodFazendaManejo > 0) or (CodAnimalManejo <> '')) Then Begin
    Mensagens.Adicionar(1526, Self.ClassName, NomeMetodo, []);
    Result := -1526;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem o código interno do animal a partir do código de manejo informado
      if (CodFazendaManejo > 0) or (CodAnimalManejo <> '') then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  cod_animal '+
          'from '+
          '  tab_animal '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_fazenda_manejo = :cod_fazenda_manejo ';
          if (Conexao.CodPapelUsuario = 3) then begin
          Q.SQL.Text := Q.SQL.Text +
          '  and (cod_pessoa_tecnico = :cod_pessoa_tecnico ' +
          '       or cod_pessoa_tecnico is null) ' ;
          end;
          Q.SQL.Text := Q.SQL.Text +
          '  and cod_animal_manejo = :cod_animal_manejo ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        if CodFazendaManejo > 0 then begin
          Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
        end else begin
          Q.ParamByName('cod_fazenda_manejo').DataType := ftInteger;
          Q.ParamByName('cod_fazenda_manejo').Clear;
        end;
        if (Conexao.CodPapelUsuario = 3) then begin
          Q.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
        end;
        Q.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(679, Self.ClassName, NomeMetodo, []);
          Result := -679;
          Exit;
        end else begin
          CodAnimal := Q.FieldByName('cod_animal').AsInteger;
        end;
      end;

      // Marca código interno do animal
      DadosAnimal.CodAnimal := CodAnimal;

      // Consistindo CodTipoMovEstoqueSemen
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  ind_restrito_sistema '+
        '  , des_tipo_mov_estoque_semen '+
        'from '+
        '  tab_tipo_mov_estoque_semen '+
        'where '+
        '  cod_tipo_mov_estoque_semen = :cod_tipo_mov_estoque_semen ';
      Q.ParamByName('cod_tipo_mov_estoque_semen').AsInteger := CodTipoMovEstoqueSemen;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1391, Self.ClassName, NomeMetodo, []);
        Result := -1391;
        Exit;
      end else if (IndSistema <> 'S') and (Q.FieldByName('ind_restrito_sistema').AsString = 'S') then begin
        Mensagens.Adicionar(1392, Self.ClassName, NomeMetodo, [Q.FieldByName('des_tipo_mov_estoque_semen').AsString]);
        Result := -1392;
        Exit;
      end;

      // Obtem o saldo atual para o estoque informado, consistindo fazenda e animal
      bExiste := False;
      Result := ObterSaldo(CodFazenda, DadosAnimal, NumPartida, iSaldoDosesSemen, bExiste);
      if Result < 0 then Exit;

      // Consiste sexo do animal
      if DadosAnimal.Sexo <> 'M' then begin
        Mensagens.Adicionar(1404, Self.ClassName, NomeMetodo, []);
        Result := -1404;
        Exit;
      end;

      // Consistindo a data do movimento
      if (DtaMovimento = 0) then begin
        Mensagens.Adicionar(1394, Self.ClassName, NomeMetodo, []);
        Result := -1394;
        Exit;
      end else if (DtaMovimento > Trunc(DtaSistema)) then begin
        Mensagens.Adicionar(1395, Self.ClassName, NomeMetodo, []);
        Result := -1395;
        Exit;
      end;

      // Consistindo QtdDoses
      if QtdDosesApto < 0 then begin
        Mensagens.Adicionar(1396, Self.ClassName, NomeMetodo, ['Apto']);
        Result := -1396;
        Exit;
      end else if QtdDosesInapto < 0 then begin
        Mensagens.Adicionar(1396, Self.ClassName, NomeMetodo, ['Inapto']);
        Result := -1396;
        Exit;
      end else if (QtdDosesApto = 0) and (QtdDosesInapto = 0) then begin
        Mensagens.Adicionar(1397, Self.ClassName, NomeMetodo, []);
        Result := -1397;
        Exit;
      end;

      // Consistências específicas por tipo de evento
      case CodTipoMovEstoqueSemen of
        ctmesCompra:
          Result := ConsistirCompra;
        ctmesColeta:
          Result := ConsistirColeta;
        ctmesVenda:
          Result := ConsistirVenda;
        ctmesPerda:
          Result := ConsistirPerda;
        ctmesUtilizacao:
          Result := ConsistirUtilizacao;
        ctmesLiberacaoParaUso:
          Result := ConsistirLiberacao;
        ctmesBloqueioDeUso:
          Result := ConsistirBloqueio;
        ctmesTransferencia:
          Result := ConsistirTransferencia;
        ctmesSaidaPorAjuste:
          Result := ConsistirSaida;
      end;
      if Result < 0 then Exit;

      // Obtem instante da inserção
      dAux := DtaSistema;

      // Inicia transação
      BeginTran;

      // Obtendo próximo código
      Q.Close;
      Q.SQL.Text :=
        'select '+
{IFDEF MSSQL}
        '  isnull(max(cod_movimento)+1, 1) '+
{ENDIF}
        'from '+
        '  tab_movimento_estoque_semen '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      iCodMovimento := Q.Fields[0].AsInteger;
      iSeqMovimento := 1;

      // Insere registro no estoque de sêmen
      if not bExiste then begin
        Result := InserirEstoqueSemen(CodFazenda, CodAnimal, NumPartida);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // No caso de transferência verifica se o registro já existe na tabela
      // pai antes de tentar inserir
      if CodTipoMovEstoqueSemen = 8 then begin
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  1 '+
          'from '+
          '  tab_estoque_semen '+
          'where '+
          '  cod_pessoa_produtor = :cod_pessoa_produtor '+
          '  and cod_fazenda = :cod_fazenda '+
          '  and cod_animal = :cod_animal '+
          '  and num_partida = :num_partida ';
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := CodFazendaDestino;
        Q.ParamByName('cod_animal').AsInteger := CodAnimal;
        Q.ParamByName('num_partida').AsString := NumPartida;
        Q.Open;

        // Insere registro no estoque de sêmen, caso o mesmo não exista
        if Q.IsEmpty then begin
          Result := InserirEstoqueSemen(CodFazendaDestino, CodAnimal, NumPartida);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
        end;
      end;

      // Realiza inserção na base de acordo com o tipo de evento
      case CodTipoMovEstoqueSemen of
        ctmesCompra:
          begin
            // Incrementa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, CodPessoaSecundaria, -1, -1, QtdDosesApto,
              QtdDosesInapto, TxtObservacao, dAux);
          end;
        ctmesColeta:
          begin
            // Incrementa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, -1, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);
          end;
        ctmesVenda:
          begin
            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;
            QtdDosesInapto := -QtdDosesInapto;

            // Baixa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, CodPessoaSecundaria, -1, -1, QtdDosesApto,
              QtdDosesInapto, TxtObservacao, dAux);
          end;
        ctmesPerda:
          begin
            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;
            QtdDosesInapto := -QtdDosesInapto;

            // Baixa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, -1, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);
          end;
        ctmesUtilizacao:
          begin
            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;
            QtdDosesInapto := -QtdDosesInapto;

            // Baixa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, CodPessoaSecundaria, CodAnimalFemea, -1,
              QtdDosesApto, QtdDosesInapto, TxtObservacao, dAux);
          end;
        ctmesLiberacaoParaUso:
          begin
            // Identifica (E)ntrada
            QtdDosesApto := QtdDosesInapto;

            // Identifica (S)aída
            QtdDosesInapto := -QtdDosesInapto;

            // Incrementa estoque apto / Baixa estoque inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, -1, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);
          end;
        ctmesBloqueioDeUso:
          begin
            // Identifica (E)ntrada
            QtdDosesInapto := QtdDosesApto;

            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;

            // Baixa estoque apto / Incrementa estoque inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, -1, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);
          end;
        ctmesTransferencia:
          begin
            // Incrementa apto e inapto na fazenda destino
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazendaDestino, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, CodFazenda, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);

            // Verifica se primeiro passo foi bem sucedido
            if Result < 0 then begin
              RollBack;
              Exit;
            end;

            // Incrementa sequencial do movimento
            Inc(iSeqMovimento);

            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;
            QtdDosesInapto := -QtdDosesInapto;

            // Baixa estoque apto e inapto na fazenda origem
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, CodFazendaDestino, QtdDosesApto,
              QtdDosesInapto, TxtObservacao, dAux);
          end;
        ctmesEntradaPorAjuste:
          begin
            // Incrementa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, -1, QtdDosesApto, QtdDosesInapto,
              TxtObservacao, dAux);
          end;
        ctmesSaidaPorAjuste:
          begin
            // Identifica (S)aída
            QtdDosesApto := -QtdDosesApto;
            QtdDosesInapto := -QtdDosesInapto;

            // Baixa estoque apto e inapto
            Result := InserirMovimentoNaBase(iCodMovimento, iSeqMovimento,
              CodTipoMovEstoqueSemen, CodFazenda, CodAnimal, NumPartida,
              DtaMovimento, -1, -1, CodFazendaDestino, QtdDosesApto,
              QtdDosesInapto, TxtObservacao, dAux);
          end;
      end;
      // Verifica se o passo de inserção do movimento foi bem sucedido
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Atualiza saldo do registro no estoque de sêmen
      Result := AtualizarEstoqueSemen(CodFazenda, CodAnimal, NumPartida);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // No caso de transferência atualiza o saldo para o animal e partida
      // na fazenda de destino
      if CodTipoMovEstoqueSemen = 8 then begin
        Result := AtualizarEstoqueSemen(CodFazendaDestino, CodAnimal, NumPartida);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Confirma Transação
      Commit;

      // Identifica procedimento como bem sucedido
      Result := iCodMovimento;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1390, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1390;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.EstornarMovimento(CodMovimento: Integer;
  TxtObservacao, IndSistema: String): Integer;
const
  Metodo: Integer = 427;
  NomeMetodo: String = 'EstornarMovimento';
var
  Q: THerdomQuery;
  dAux: TDateTime;
  sNumPartida: String;
  iCodFazenda, iCodAnimal: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Trata Observação
  If TxtObservacao <> '' Then Begin
    Result := TrataString(TxtObservacao, 255, 'Observação');
    If Result < 0 Then Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Consiste a existência do movimento informado
      Q.Close;
      Q.SQL.Text :=
        'select '+
{IFDEF MSSQL}
        '  top 1 '+
{ENDIF}
        '  tmes.ind_movimento_estorno '+
        '  , tmes.cod_fazenda '+
        '  , tmes.cod_animal '+
        '  , tmes.num_partida '+
        '  , ttmes.ind_restrito_sistema '+
        '  , ttmes.des_tipo_mov_estoque_semen '+
        'from '+
        '  tab_movimento_estoque_semen tmes '+
        '  , tab_tipo_mov_estoque_semen ttmes '+
        'where '+
        '  ttmes.cod_tipo_mov_estoque_semen = tmes.cod_tipo_mov_estoque_semen '+
        '  and tmes.cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and tmes.cod_movimento = :cod_movimento ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_movimento').AsInteger := CodMovimento;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1424, Self.ClassName, NomeMetodo, []);
        Result := -1424;
        Exit;
      end else if Q.FieldByName('ind_movimento_estorno').AsString = 'S' then begin
        Mensagens.Adicionar(1425, Self.ClassName, NomeMetodo, []);
        Result := -1425;
        Exit;
      end else if (IndSistema <> 'S') and (Q.FieldByName('ind_restrito_sistema').AsString = 'S') then begin
        Mensagens.Adicionar(1492, Self.ClassName, NomeMetodo, [Q.FieldByName('des_tipo_mov_estoque_semen').AsString]);
        Result := -1492;
        Exit;
      end;
      iCodFazenda := Q.FieldByName('cod_fazenda').AsInteger;
      iCodAnimal := Q.FieldByName('cod_animal').AsInteger;
      sNumPartida := Q.FieldByName('num_partida').AsString;

      // Obtem instante da inserção
      dAux := DtaSistema;

      // Inicia transação
      BeginTran;

      // Marcando movimento(s) como estornado(s)
      Q.Close;
      Q.SQL.Text :=
        'update tab_movimento_estoque_semen '+
        'set '+
        '  ind_movimento_estorno = :ind_movimento_estorno '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_movimento = :cod_movimento ';
      Q.ParamByName('ind_movimento_estorno').AsString := 'S';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_movimento').AsInteger := CodMovimento;
      Q.ExecSQL;

      // Inserindo movimentos de estorno
      Q.Close;
      Q.SQL.Text :=
        'insert into tab_movimento_estoque_semen '+
        ' (cod_pessoa_produtor '+
        '  , cod_movimento '+
        '  , seq_movimento '+
        '  , cod_fazenda '+
        '  , cod_animal '+
        '  , num_partida '+
        '  , cod_tipo_mov_estoque_semen '+
        '  , ind_movimento_estorno '+
        '  , dta_movimento '+
        '  , cod_pessoa_secundaria '+
        '  , cod_animal_femea '+
        '  , cod_fazenda_relacionada '+
        '  , qtd_doses_apto '+
        '  , qtd_doses_inapto '+
        '  , txt_observacao '+
        '  , dta_cadastramento '+
        '  , cod_usuario) '+
        'select '+
        '  cod_pessoa_produtor '+
        '  , cod_movimento '+
        '  , seq_movimento + 10 '+
        '  , cod_fazenda '+
        '  , cod_animal '+
        '  , num_partida '+
        '  , :cod_tipo_mov_estoque_semen '+
        '  , ind_movimento_estorno '+
        '  , dta_movimento '+
        '  , cod_pessoa_secundaria '+
        '  , cod_animal_femea '+
        '  , cod_fazenda_relacionada '+
        '  , qtd_doses_apto * -1 '+
        '  , qtd_doses_inapto * -1 '+
        '  , :txt_observacao '+
        '  , :dta_cadastramento '+
        '  , :cod_usuario '+
        'from '+
        '  tab_movimento_estoque_semen '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_movimento = :cod_movimento ';
      Q.ParamByName('cod_tipo_mov_estoque_semen').AsInteger := 9; // Estorno
      Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      Q.ParamByName('dta_cadastramento').AsDateTime := dAux;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_movimento').AsInteger := CodMovimento;
      Q.ExecSQL;

      // Atualiza saldo do registro no estoque de sêmen
      Result := AtualizarEstoqueSemen(iCodFazenda, iCodAnimal, sNumPartida);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Confirma Transação
      Commit;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1423, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1423;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntEstoqueSemen.PesquisarPosicaoFazenda(CodFazenda,
  CodAnimal: Integer; IndDetalharPartida, IndEstoquePositivo,
  IndConsolidar, CodOrdenacao: String): Integer;
const
  Metodo: Integer = 431;
  NomeMetodo: String = 'PesquisarPosicaoFazenda';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  try
    // Consiste a existência do movimento informado
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  tes.cod_fazenda as CodFazenda '+
      '  , tf.sgl_fazenda as SglFazenda '+
      '  , tf.nom_fazenda as NomFazenda ';
    if (IndConsolidar <> 'S') or (CodAnimal <> -1) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  , ta.cod_animal as CodAnimal '+
        '  , tfa.sgl_fazenda as SglFazendaManejo '+
        '  , ta.cod_animal_manejo as CodAnimalManejo '+
        '  , ta.des_apelido as DesApelido ';
    end;
    if IndDetalharPartida = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  , tes.num_partida as NumPartida '+
        '  , tes.qtd_doses_apto as QtdDosesApto '+
        '  , tes.qtd_doses_inapto as QtdDosesInapto ';
    end else begin
      Query.SQL.Text := Query.SQL.Text +
        '  , sum(tes.qtd_doses_apto) as QtdDosesApto '+
        '  , sum(tes.qtd_doses_inapto) as QtdDosesInapto ';
    end;
    Query.SQL.Text := Query.SQL.Text +
      'from '+
      '  tab_estoque_semen tes '+
      '  , tab_fazenda tf '+
      '  , tab_animal ta '+
      '  , tab_fazenda tfa '+
      'where '+
{IFDEF MSSQL}
      '  tfa.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
      '  and tfa.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
      '  and ta.cod_pessoa_produtor = tes.cod_pessoa_produtor '+
      '  and ta.cod_animal = tes.cod_animal '+
      '  and tf.cod_pessoa_produtor = tes.cod_pessoa_produtor '+
      '  and tf.cod_fazenda = tes.cod_fazenda '+
      '  and tes.cod_pessoa_produtor = :cod_pessoa_produtor ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    if CodFazenda > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tes.cod_fazenda = :cod_fazenda ';
      Query.ParamByName('cod_fazenda').AsInteger := CodFazenda;
    end;
    if CodAnimal > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tes.cod_animal = :cod_animal ';
      Query.ParamByName('cod_animal').AsInteger := CodAnimal;
    end;
    if IndEstoquePositivo = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and (tes.qtd_doses_apto > 0 or tes.qtd_doses_inapto > 0) ';
    end;
    if IndDetalharPartida <> 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        'group by '+
        '  tes.cod_fazenda '+
        '  , tf.sgl_fazenda '+
        '  , tf.nom_fazenda ';
      if (IndConsolidar <> 'S') or (CodAnimal <> -1) then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , ta.cod_animal '+
          '  , tfa.sgl_fazenda '+
          '  , ta.cod_animal_manejo '+
          '  , ta.des_apelido ';
      end;
    end;
    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  SglFazenda ';
    if (IndConsolidar <> 'S') or (CodAnimal <> -1) then begin
      if CodOrdenacao = 'M' then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , SglFazendaManejo '+
          '  , CodAnimalManejo ';
      end else if CodOrdenacao = 'A' then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , DesApelido ';
      end;
    end;
    Query.Open;

    //Caso o usuário logado seja um técnico (CodPapelUsuario = 3) mostrar mensagem 1697!
    if Conexao.CodPapelUsuario = 3 then begin
       Mensagens.Adicionar(1697, Self.ClassName, NomeMetodo, []);
    end;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1433, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1433;
      Exit;
    end;
  end;
end;

function TIntEstoqueSemen.PesquisarTouros(CodFazenda: Integer;
  IndDosesApto, CodOrdenacao: String): Integer;
const
  Metodo: Integer = 430;
  NomeMetodo: String = 'PesquisarTouros';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  try
    // Consiste a existência do movimento informado
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  distinct '+
      '  ta.cod_animal as CodAnimal '+
      '  , tf.sgl_fazenda as SglFazendaManejo '+
      '  , ta.cod_animal_manejo as CodAnimalManejo '+
      '  , ta.des_apelido as DesApelido '+
      'from '+
      '  tab_animal ta '+
      '  , tab_fazenda tf ';
    if (CodFazenda > 0) or (IndDosesApto = 'S') or (IndDosesApto = 'N')
      or (IndDosesApto = 'A') then begin
      Query.SQL.Text := Query.SQL.Text +
        '  , tab_estoque_semen tes ';
    end;
    Query.SQL.Text := Query.SQL.Text +
      'where '+
{IFDEF MSSQL}
      '  tf.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
      '  and tf.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
      '  and ta.cod_pessoa_produtor = :cod_pessoa_produtor ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    if (CodFazenda > 0) or (IndDosesApto = 'S') or (IndDosesApto = 'N')
      or (IndDosesApto = 'A') then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tes.cod_pessoa_produtor = ta.cod_pessoa_produtor '+
        '  and tes.cod_animal = ta.cod_animal ';
      if CodFazenda > 0 then begin
        Query.SQL.Text := Query.SQL.Text +
          '  and tes.cod_fazenda = :cod_fazenda ';
        Query.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      end;
      if IndDosesApto = 'S' then begin
        Query.SQL.Text := Query.SQL.Text +
          '  and tes.qtd_doses_apto > 0 ';
      end else if IndDosesApto = 'N' then begin
        Query.SQL.Text := Query.SQL.Text +
          '  and tes.qtd_doses_inapto > 0 ';
      end else if IndDosesApto = 'A' then begin
        Query.SQL.Text := Query.SQL.Text +
          '  and (tes.qtd_doses_apto > 0 or tes.qtd_doses_inapto > 0) ';
      end;
    end;
    if (Conexao.CodPapelUsuario = 3) then begin
      Query.SQL.Text := Query.SQL.Text +
      '  and (ta.cod_pessoa_tecnico = :cod_pessoa_tecnico ' +
      '       or ta.cod_pessoa_tecnico is null) ' ;
    end;
    if CodOrdenacao = 'M' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by '+
        '  SglFazendaManejo '+
        '  , CodAnimalManejo ';
    end else if CodOrdenacao = 'A' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by '+
        '  DesApelido ';
    end;
    if (Conexao.CodPapelUsuario = 3) then begin
      Query.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
    end;
    Query.Open;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1434, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1434;
      Exit;
    end;
  end;
end;

function TIntEstoqueSemen.PesquisarPosicaoTouro(CodAnimal,
  CodFazenda: Integer; IndDetalharPartida, IndEstoquePositivo,
  IndConsolidar, CodOrdenacao: String): Integer;
const
  Metodo: Integer = 432;
  NomeMetodo: String = 'PesquisarPosicaoTouro';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  try
    // Consiste a existência do movimento informado
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  ta.cod_animal as CodAnimal '+
      '  , tfa.sgl_fazenda as SglFazendaManejo '+
      '  , ta.cod_animal_manejo as CodAnimalManejo '+
      '  , ta.des_apelido as DesApelido ';
    if (IndConsolidar <> 'S') or (CodFazenda <> -1) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  , tes.cod_fazenda as CodFazenda '+
        '  , tf.sgl_fazenda as SglFazenda '+
        '  , tf.nom_fazenda as NomFazenda ';
    end;
    if IndDetalharPartida = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  , tes.num_partida as NumPartida '+
        '  , tes.qtd_doses_apto as QtdDosesApto '+
        '  , tes.qtd_doses_inapto as QtdDosesInapto ';
    end else begin
      Query.SQL.Text := Query.SQL.Text +
        '  , sum(tes.qtd_doses_apto) as QtdDosesApto '+
        '  , sum(tes.qtd_doses_inapto) as QtdDosesInapto ';
    end;
    Query.SQL.Text := Query.SQL.Text +
      'from '+
      '  tab_estoque_semen tes '+
      '  , tab_animal ta '+
      '  , tab_fazenda tfa '+
      '  , tab_fazenda tf '+
      'where '+
      '  tf.cod_pessoa_produtor = tes.cod_pessoa_produtor '+
      '  and tf.cod_fazenda = tes.cod_fazenda '+
{IFDEF MSSQL}
      '  and tfa.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
      '  and tfa.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
      '  and ta.cod_pessoa_produtor = tes.cod_pessoa_produtor '+
      '  and ta.cod_animal = tes.cod_animal '+
      '  and tes.cod_pessoa_produtor = :cod_pessoa_produtor ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    if CodAnimal > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tes.cod_animal = :cod_animal ';
      Query.ParamByName('cod_animal').AsInteger := CodAnimal;
    end;
    if CodFazenda > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tes.cod_fazenda = :cod_fazenda ';
      Query.ParamByName('cod_fazenda').AsInteger := CodFazenda;
    end;
    if IndEstoquePositivo = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and (tes.qtd_doses_apto > 0 or tes.qtd_doses_inapto > 0) ';
    end;
    if (Conexao.CodPapelUsuario = 3) then begin
    Query.SQL.Text := Query.SQL.Text +
    '  and (ta.cod_pessoa_tecnico = :cod_pessoa_tecnico ' +
    '       or ta.cod_pessoa_tecnico is null) ' ;
    end;
    if IndDetalharPartida <> 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        'group by '+
        '  ta.cod_animal '+
        '  , tfa.sgl_fazenda '+
        '  , ta.cod_animal_manejo '+
        '  , ta.des_apelido ';
      if (IndConsolidar <> 'S') or (CodFazenda <> -1) then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , tes.cod_fazenda '+
          '  , tf.sgl_fazenda '+
          '  , tf.nom_fazenda ';
      end;
    end;
    if CodOrdenacao = 'M' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by '+
        '  SglFazendaManejo '+
        '  , CodAnimalManejo ';
      if (IndConsolidar <> 'S') or (CodFazenda <> -1) then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , SglFazenda ';
      end;
    end else if CodOrdenacao = 'A' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by '+
        '  DesApelido ';
      if (IndConsolidar <> 'S') or (CodFazenda <> -1) then begin
        Query.SQL.Text := Query.SQL.Text +
          '  , SglFazenda ';
      end;
    end;
    if (Conexao.CodPapelUsuario = 3) then begin
      Query.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
    end;
    Query.Open;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1435, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1435;
      Exit;
    end;
  end;
end;

function TIntEstoqueSemen.Pesquisar(CodFazendas: String;
  CodFazendaManejo: Integer; CodAnimalManejoInicio, CodAnimalManejoFim,
  DesApelido, NomAnimal, NumPartida, CodTipoMovsEstoqueSemen,
  IndMovimentoEstorno: String; DtaMovimentoInicio,
  DtaMovimentoFim: TDateTime; CodFornecedoresSemen: String): Integer;
const
  Metodo: Integer = 445;
  NomeMetodo: String = 'Pesquisar';
var
  Param: TValoresParametro;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Verifica parâmetros multivalorados
  Param := TValoresParametro.Create(TValorParametro);
  Try
    // Fazendas
    If CodFazendas <> '' Then Begin
      Result := VerificaParametroMultiValor(CodFazendas, Param);
      If Result < 0 Then Begin
        Exit;
      End;
    End;

    // Movimentos
    If CodTipoMovsEstoqueSemen <> '' Then Begin
      Result := VerificaParametroMultiValor(CodTipoMovsEstoqueSemen, Param);
      If Result < 0 Then Begin
        Exit;
      End;
    End;

    // Fornecedores
    If CodFornecedoresSemen <> '' Then Begin
      Result := VerificaParametroMultiValor(CodFornecedoresSemen, Param);
      If Result < 0 Then Begin
        Exit;
      End;
    End;
  Finally
    Param.Free;
  End;

  try
    // Pesquisa por movimentos de acordo com os critérios informados
    Query.Close;
    Query.SQL.Text :=
      'select '+
      '  tmes.cod_pessoa_produtor as CodPessoaProdutor '+
      '  , tmes.cod_movimento as CodMovimento '+
      '  , tmes.seq_movimento as SeqMovimento '+
      '  , tf.sgl_fazenda as SglFazenda '+
      '  , tfm.sgl_fazenda as SglFazendaManejo '+
      '  , ta.cod_animal_manejo as CodAnimalManejo '+
      '  , ta.des_apelido as DesApelido '+
      '  , ta.nom_animal as NomAnimal '+
      '  , tmes.num_partida as NumPartida '+
      '  , ttmes.sgl_tipo_mov_estoque_semen as SglTipoMovEstoqueSemen '+
      '  , tmes.ind_movimento_estorno as IndMovimentoEstorno '+
      '  , tmes.dta_movimento as DtaMovimento '+
{IFDEF MSSQL}
      '  , abs(tmes.qtd_doses_apto) as QtdDosesApto '+
      '  , abs(tmes.qtd_doses_inapto) as QtdDosesInapto '+
{ENDIF}
      'from '+
      '  tab_movimento_estoque_semen tmes '+
      '  , tab_tipo_mov_estoque_semen ttmes '+
      '  , tab_fazenda tf '+
      '  , tab_animal ta '+
      '  , tab_fazenda tfm '+
      'where '+
      '  tmes.cod_pessoa_produtor = :cod_pessoa_produtor '+
      '  and tf.cod_pessoa_produtor = tmes.cod_pessoa_produtor '+
      '  and tf.cod_fazenda = tmes.cod_fazenda '+
      '  and ta.cod_pessoa_produtor = tmes.cod_pessoa_produtor '+
      '  and ta.cod_animal = tmes.cod_animal '+
{IFDEF MSSQL}
      '  and tfm.cod_pessoa_produtor =* ta.cod_pessoa_produtor '+
      '  and tfm.cod_fazenda =* ta.cod_fazenda_manejo '+
{ENDIF}
      '  and ttmes.cod_tipo_mov_estoque_semen = tmes.cod_tipo_mov_estoque_semen ';
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    if CodFazendaManejo > 0 then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and ta.cod_fazenda_manejo = :cod_fazenda_manejo ';
      Query.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
    end;
    if (CodAnimalManejoInicio <> '') and (CodAnimalManejoFim <> '') then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and ta.cod_animal_manejo between :cod_animal_manejo_inicio and :cod_animal_manejo_fim ';
      Query.ParamByName('cod_animal_manejo_inicio').AsString := CodAnimalManejoInicio;
      Query.ParamByName('cod_animal_manejo_fim').AsString := CodAnimalManejoFim;
    end;
    if DesApelido <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
      '  and ta.des_apelido like :des_apelido ';
      Query.ParamByName('des_apelido').AsString := DesApelido + '%';
    end;
    if NomAnimal <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and ta.nom_animal like :nom_animal ';
      Query.ParamByName('nom_animal').AsString := NomAnimal + '%';
    end;
    if NumPartida <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tmes.num_partida = :num_partida ';
      Query.ParamByName('num_partida').AsString := NumPartida;
    end;
    if IndMovimentoEstorno <> 'S' then begin
      IndMovimentoEstorno := '''N''';
    end else begin
      IndMovimentoEstorno := '''N'', ''S''';
    end;
    Query.SQL.Text := Query.SQL.Text +
      '  and tmes.ind_movimento_estorno in ( '+IndMovimentoEstorno+' ) ';
    if (DtaMovimentoInicio > 0) and (DtaMovimentoFim > 0) then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and (tmes.dta_movimento >= :dta_movimento_inicio '+
        '       and tmes.dta_movimento < :dta_movimento_fim ) ';
      Query.ParamByName('dta_movimento_inicio').AsDateTime := Trunc(DtaMovimentoInicio);
      Query.ParamByName('dta_movimento_fim').AsDateTime := Trunc(DtaMovimentoFim)+1;
    end;
    if CodFazendas <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tmes.cod_fazenda in ( '+CodFazendas+' ) ';
    end;
    if CodTipoMovsEstoqueSemen <> '' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  and tmes.cod_tipo_mov_estoque_semen in ( '+CodTipoMovsEstoqueSemen+' ) ';
    end;
    if CodFornecedoresSemen <> '' then begin
      // Aplica o filtro, somente se o evento de "compra" foi selecionado
      if Pos(', 1,', ', '+CodTipoMovsEstoqueSemen+', ') > 0 then begin
        Query.SQL.Text := Query.SQL.Text +
          '  and tmes.cod_pessoa_secundaria in ( '+CodFornecedoresSemen+' ) ';
      end;
    end;
    Query.SQL.Text := Query.SQL.Text +
      'order by '+
      '  DtaMovimento desc ';
    Query.Open;

    //Caso o usuário logado seja um técnico (CodPapelUsuario = 3) mostrar mensagem 1697!
    if Conexao.CodPapelUsuario = 3 then begin
       Mensagens.Adicionar(1697, Self.ClassName, NomeMetodo, []);
    end;

    // Identifica procedimento como bem sucedido
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1483, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1483;
      Exit;
    end;
  end;
end;

function TIntEstoqueSemen.GerarRelatorio(CodFazenda,
  CodFazendaManejo: Integer; CodAnimalManejoInicio, CodAnimalManejoFim,
  NomAnimal, DesApelido: String; DtaNascimentoInicio,
  DtaNascimentoFim: TDateTime; CodRacas, NumRGD, IndAgrupRaca1: String;
  CodRaca1: Integer; QtdComposicaoRacialInicio1,
  QtdComposicaoRacialFim1: Double; IndAgrupRaca2: String;
  CodRaca2: Integer; QtdComposicaoRacialInicio2,
  QtdComposicaoRacialFim2: Double; IndAgrupRaca3: String;
  CodRaca3: Integer; QtdComposicaoRacialInicio3,
  QtdComposicaoRacialFim3: Double; IndAgrupRaca4: String;
  CodRaca4: Integer; QtdComposicaoRacialInicio4,
  QtdComposicaoRacialFim4: Double; NumPartidaInicio, NumPartidaFim,
  CodTipoMovimentos: String; DtaMovimentoInicio, DtaMovimentoFim: TDateTime;
  CodPessoaFornecedores, CodPessoaCompradores: String; CodFazendaOrigem,
  CodFazendaDestino, QtdAptoInicio, QtdAptoFim, QtdInaptoInicio, QtdInaptoFim,
  Tipo, QtdQuebraRelatorio: Integer): String;
const
  Metodo: Integer = 463;
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 17;
var
  Rel: TRelatorioPadrao;
  Retorno, X, iAux: Integer;
  sQuebra, sAux: String;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Exit;
  End;

  {Realiza pesquisa de avaliações de acordo com os critérios informados}
  Retorno := PesquisarRelatorio(CodFazenda, CodFazendaManejo,
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
    QtdInaptoInicio, QtdInaptoFim);
  if Retorno < 0 then Exit;

  {Verifica se a pesquisa é válida (se existe algum registro)}
  if Query.IsEmpty then begin
    Mensagens.Adicionar(1521, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  try
    Rel.TipoDoArquvio := Tipo;

    {Define o relatório em questão e carrega os seus dados específicos}
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then Exit;

    {Consiste se número de campos do relatório é maior ou igual ao de quebras}
    if Rel.Campos.NumCampos < QtdQuebraRelatorio then begin
      Mensagens.Adicionar(1119, Self.ClassName, NomeMetodo, []);
      Exit;
    end;

    {Desabilita a apresentação dos campos selecionados para quebra}
    Rel.Campos.IrAoPrimeiro;
    for iAux := 1 to QtdQuebraRelatorio do begin
      Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
      Rel.Campos.IrAoProximo;
    end;

    {Inicializa o procedimento de geração do arquivo de relatório}
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then Exit;

    sQuebra := '';
    Query.First;
    while not EOF do begin
      if QtdQuebraRelatorio > 0 then begin
        {Atualiza o campo valor do atributo Campos do relatorio c/ os dados da query}
        Rel.Campos.CarregarValores(Query);
        {Percorre o(s) campo(s) informado(s) para quebra}
        Rel.Campos.IrAoPrimeiro;
        sAux := '';
        for iAux := 1 to QtdQuebraRelatorio do begin
          {Concatena o valor dos campos de quebra, montando o título}
          sAux := SE(sAux = '', sAux, sAux + ' / ') +
            TrataQuebra(Rel.Campos.Campo.TxtTitulo) + ': ' +
            Rel.Campos.Campo.Valor;
          Rel.Campos.IrAoProximo;
        end;
        if (sAux <> sQuebra) then begin
          {Se ocorreu mudança na quebra atual ou é a primeira ('')}
          sQuebra := sAux;
          if Rel.LinhasRestantes <= 2 then begin
            {Se ñ couber uma linha de registro na pag. atual, quebra página}
            Rel.NovaPagina;
          end else if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
            {Salta uma linha antes da quebra}
            Rel.NovaLinha;
          end;
          {Imprime título da quebra}
          Rel.ImprimirTexto(0, sQuebra);
        end;
      end;
      Rel.ImprimirColunasResultSet(Query);
      Query.Next;
    end;
    Retorno := Rel.FinalizarRelatorio;
    {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
    if Retorno = 0 then begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
  end;
end;

end.
