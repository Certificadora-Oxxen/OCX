unit uIntInventariosAnimais;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, WsSISBOV1, uIntSoapSisbov,
  uFerramentas, uIntRelatorios;

type
  TIntInventariosAnimais = class(TIntClasseBDNavegacaoBasica)
  public
    function Excluir(CodPessoaProdutor, CodPropriedadeRural: Integer;
      CodSisbov: String; CodAnimal: Integer): Integer;
    function Inserir(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisbov: String; CodAnimal: Integer): Integer;
    function Pesquisar(NomProdutor, SglProdutor, NomPropriedadeRural: String;
      DtaLancamentoInventarioIni, DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime; IndTransmissaoSisbov: String; Tipo: Integer): Integer;
    function Transmitir: Integer;
    function TransmitirAgendados: Integer;
    function InserirIntervalo(CodPessoaProdutor, CodPropriedadeRural: Integer;
      const CodSisbovInicial, CodSisbovFinal: String): Integer;
    function PesquisarEfetivados(const SglProdutor, NomProdutor, NomPropriedadeRural: String;
      CodIDPropriedade: Integer; DtaEfetivacaoInicio, DtaEfetivacaoFinal: TDateTime;
      const IndTransmissaoSisbov: String): Integer;
    function EfetivarInventario(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer;
    function InserirAnimaisPesquisados(CodPessoaProdutor,
      CodPropriedadeRural: Integer; QueryPesquisa: THerdomQueryNavegacao): Integer;
    function ExcluirAnimaisPesquisados(CodPessoaProdutor,
      CodPropriedadeRural: Integer; QueryPesquisa: THerdomQueryNavegacao): Integer;
    function ExcluirIntervalo(CodPessoaProdutor, CodPropriedadeRural: Integer;
      CodSisbovInicial, CodSisbovFinal: String): Integer;
    function CancelarEfetivacao(CodPessoaProdutor,
      CodPropriedadeRural: Integer): Integer;
    function GerarRelatorioInventario(NomProdutor, SglProdutor, NomPropriedadeRural: String;
      DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
      DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim: TDateTime;
      IndTransmissaoSisbov: String; Tipo: Integer): String;
    function ExcluirAnimalErro(CodPessoaProdutor, CodPropriedadeRural: Integer): Integer;
  private
    function ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural: Integer): Integer;
    function ObterCodAnimal(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
      CodPessoaProdutor: Integer): Integer;
    function InserirInventario(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
      CodAnimal, CodPessoaProdutor, CodPropriedadeRural: Integer; Intervalo: Boolean): Integer;
    function ExcluirInventario(CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
      CodAnimal, CodPessoaProdutor, CodPropriedadeRural: Integer; Intervalo: Boolean): Integer;
    function ObterCodigoSisbov(CodAnimal, CodPessoaProdutor: Integer; var CodPaisSisbov: Integer;
      var CodEstadoSisbov: Integer; var CodMicroRegiaoSisbov: Integer; var CodAnimalSisbov: Integer;
      var NumDvSisbov: Integer): Integer;
    function InventarioEfetivado(CodPessoaProdutor, CodPropriedadeRural: Integer; var Efetivado: boolean): Integer;
    function InventariosDaPropriedadeEfetivados(CodPropriedadeRural: Integer; var Efetivado: boolean): Integer;
    function GravaErroInventarioProdutor(CodPessoaProdutor, CodPropriedadeRural: Integer; TxtMensagemErro: String;
      CodIdTransacaoSisbov: Integer; DtaTransacaoSisbov: TDateTime): Integer;
//    function GravaErroInventarioPropriedade(CodPropriedadeRural: Integer; TxtMensagemErro: String;
//      CodIdTransacaoSisbov: Integer; DtaTransacaoSisbov: TDateTime): Integer;
    function GravaErroInventarioTransmitindo(TxtMensagemErro: String; DtaTransacaoSisbov: TDateTime): Integer;
    function TransmitirInventario(SoapSisbov: TIntSoapSisbov; CpfProdutor, CnpjProdutor: String; CodPropriedadeRural,
      CodIdPropriedadeSisbov: Integer; Codigos: String): Integer;
    function MarcarInventarioComoTarefa(CodPropriedadeRural: Integer): Integer;
  end;

implementation

function TIntInventariosAnimais.ConsistirProdutorPropriedade(
  CodPessoaProdutor, CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirProdutorPropriedade';
var
  Q : THerdomQuery;
  Efetivado: Boolean;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste Produtor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.cod_pessoa_produtor ');
      Q.SQL.Add('  from tab_produtor tp ');
      Q.SQL.Add(' where tp.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tp.ind_transmissao_sisbov = ''S'' ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(607, Self.ClassName, NomeMetodo, []);
        Result := -607;
        Exit;
      End;
      Q.Close;

      // Consiste Propriedade Rural  
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tpr.cod_propriedade_rural ');
      Q.SQL.Add('  from tab_propriedade_rural tpr ');
      Q.SQL.Add(' where tpr.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and tpr.ind_transmissao_sisbov = ''S'' ');
      Q.SQL.Add('   and tpr.cod_id_propriedade_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(513, Self.ClassName, NomeMetodo, []);
        Result := -513;
        Exit;
      End;
      Q.Close;

      // Verifica efetivação do cadastro do produtor / propriedade
      Result := InventarioEfetivado(CodPessoaProdutor, CodPropriedadeRural, Efetivado);
      if Result < 0 then begin
        Exit;
      end;

      // Se produtor / propriedade já são efetivados não é possível excluir o animal
      if Efetivado then begin
        Mensagens.Adicionar(2342, Self.ClassName, NomeMetodo, []);
        Result := -2342;
        Exit;
      end;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2328, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2328;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.EfetivarInventario(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'EfetivarInventario';
var
  Q : THerdomQuery;
begin
  Result := 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Consistências
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se produtor/propriedade já foram efetivados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_efetivacao_inventario tei');
      Q.SQL.Add(' where tei.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tei.cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(2342, Self.ClassName, NomeMetodo, []);
        Result := -2342;
        Exit;
      End;

      // Verifica se o produtor / propriedade possui animais inseridos no cadastro de inventário
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_inventario_animal tia');
      Q.SQL.Add(' where tia.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tia.cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(2343, Self.ClassName, NomeMetodo, []);
        Result := -2343;
        Exit;
      End;

      // Tenta Inserir registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_efetivacao_inventario ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_propriedade_rural, ');
      Q.SQL.Add('  cod_usuario_efetivacao, ');
      Q.SQL.Add('  dta_efetivacao_sisbov, ');
      Q.SQL.Add('  ind_transmissao_sisbov, ');
      Q.SQL.Add('  ind_transmissao_tarefa) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_propriedade_rural, ');
      Q.SQL.Add('  :cod_usuario_efetivacao, ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  ''N'', ');
      Q.SQL.Add('  ''N'' ) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_usuario_efetivacao').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      // Efetua uma checagem se há algum produtor da propriedade que ainda não inventariou animais
      // Em caso positivo, retorna uma mensagem de aviso
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tls.cod_pessoa_produtor, ');
      Q.SQL.Add('       tls.cod_propriedade_rural ');
      Q.SQL.Add('  from tab_localizacao_sisbov tls ');
      Q.SQL.Add(' where tls.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and not exists (select distinct 1 ');
      Q.SQL.Add('                     from tab_inventario_animal tia ');
      Q.SQL.Add('                    where tia.cod_propriedade_rural = tls.cod_propriedade_rural ');
      Q.SQL.Add('                      and tia.cod_pessoa_produtor = tls.cod_pessoa_produtor) ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(2369, Self.ClassName, NomeMetodo, []);
        Result := -2369;
      End else Begin
        // Retorna 0 dizendo que tudo ocorreu normalmente
        Result := 0;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2344, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2344;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.Excluir(CodPessoaProdutor, CodPropriedadeRural: Integer;
  CodSisbov: String; CodAnimal: Integer): Integer;
const
  NomeMetodo: String = 'Excluir';
var
  CodAnimalExcluir : Integer;
  CodP, CodE, CodM, CodA, Dig: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(105) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  // Consiste se parâmetros
  // Só pode ser informado CodSisbov ou CodAnimal, nunca ambos simultaneamente
  if (Trim(CodSisbov) <> '') and (CodAnimal > 0) then begin
    Mensagens.Adicionar(2315, Self.ClassName, NomeMetodo, []);
    Result := -2315;
    Exit;
  end;

  // Um dos dois CodSisbov ou CodAnimal deve ser informado
  if (Trim(CodSisbov) = '') and (CodAnimal <= 0) then begin
    Mensagens.Adicionar(2316, Self.ClassName, NomeMetodo, []);
    Result := -2316;
    Exit;
  end;

  // CodSisbov deve possuir 15 ou 17 caracteres
  if Trim(CodSisbov) <> '' then begin
    if (Length(Trim(CodSisbov)) <> 15) and (Length(Trim(CodSisbov)) <> 17) then begin
      Mensagens.Adicionar(2317, Self.ClassName, NomeMetodo, []);
      Result := -2317;
      Exit;
    end;
  end;

  Try
    // Consiste produtor e propriedade
    Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
    if Result < 0 then begin
      Exit;
    end;

    // Se código do animal foi informado, obtém código SISBOV
    if CodAnimal > 0 then begin
      Result := ObterCodigoSisbov(CodAnimal, CodPessoaProdutor, CodP, CodE, CodM, CodA, Dig);
      if Result < 0 then begin
        Exit;
      end;
      CodAnimalExcluir := CodAnimal;
    end else begin
      // Se código sisbov foi informado, verifica se o animal pertence à base do Herdom, e em caso afirmativo
      // obtém o código do animal
      CodP := StrToInt(Copy(Trim(CodSisbov), 1, 3));
      CodE := StrToInt(Copy(Trim(CodSisbov), 4, 2));
      if Length(CodSisbov) = 15 then begin
        CodM := -1;
        CodA := StrToInt(Copy(Trim(CodSisbov), 6, 9));
        Dig  := StrToInt(Copy(Trim(CodSisbov), 15, 1));
      end else begin
        CodM := StrToInt(Copy(Trim(CodSisbov), 6, 2));
        CodA := StrToInt(Copy(Trim(CodSisbov), 8, 9));
        Dig  := StrToInt(Copy(Trim(CodSisbov), 17, 1));
      end;

      Result := ObterCodAnimal(CodP, CodE, CodM, CodA, Dig, CodPessoaProdutor);
      if Result < 0 then begin
        Exit;
      end;
      CodAnimalExcluir := Result;
    end;

    Result := ExcluirInventario(CodP, CodE, CodM, CodA, Dig, CodAnimalExcluir, CodPessoaProdutor, CodPropriedadeRural, false);
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2323, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2323;
      Exit;
    End;
  End;
end;

function TIntInventariosAnimais.Inserir(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisbov: String;
  CodAnimal: Integer): Integer;
const
  NomeMetodo: String = 'Inserir';
var
  CodAnimalGravar: Integer;
  CodP, CodE, CodM, CodA, Dig: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(92) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Try
    // Consiste se parâmetros
    // Só pode ser informado CodSisbov ou CodAnimal, nunca ambos simultaneamente
    if (Trim(CodSisbov) <> '') and (CodAnimal > 0) then begin
      Mensagens.Adicionar(2315, Self.ClassName, NomeMetodo, []);
      Result := -2315;
      Exit;
    end;

    // Um dos dois CodSisbov ou CodAnimal deve ser informado
    if (Trim(CodSisbov) = '') and (CodAnimal <= 0) then begin
      Mensagens.Adicionar(2316, Self.ClassName, NomeMetodo, []);
      Result := -2316;
      Exit;
    end;

    // CodSisbov deve possuir 15 ou 17 caracteres
    if Trim(CodSisbov) <> '' then begin
      if (Length(Trim(CodSisbov)) <> 15) and (Length(Trim(CodSisbov)) <> 17) then begin
        Mensagens.Adicionar(2317, Self.ClassName, NomeMetodo, []);
        Result := -2317;
        Exit;
      end;
    end;

    // Consiste produtor e propriedade
    Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
    if Result < 0 then begin
      Exit;
    end;

    // Se código do animal foi informado, obtém código SISBOV
    if CodAnimal > 0 then begin
      Result := ObterCodigoSisbov(CodAnimal, CodPessoaProdutor, CodP, CodE, CodM, CodA, Dig);
      if Result < 0 then begin
        Exit;
      end;
      CodAnimalGravar := CodAnimal;
    end else begin
      // Se código sisbov foi informado, tenta obter o código do animal
      CodP := StrToInt(Copy(Trim(CodSisbov), 1, 3));
      CodE := StrToInt(Copy(Trim(CodSisbov), 4, 2));
      if Length(CodSisbov) = 15 then begin
        CodM := -1;
        CodA := StrToInt(Copy(Trim(CodSisbov), 6, 9));
        Dig  := StrToInt(Copy(Trim(CodSisbov), 15, 1));
      end else begin
        CodM := StrToInt(Copy(Trim(CodSisbov), 6, 2));
        CodA := StrToInt(Copy(Trim(CodSisbov), 8, 9));
        Dig  := StrToInt(Copy(Trim(CodSisbov), 17, 1));
      end;

      Result := ObterCodAnimal(CodP, CodE, CodM, CodA, Dig, CodPessoaProdutor);
      if Result < 0 then begin
        Exit;
      end;
      CodAnimalGravar := Result;
    end;

    Result := InserirInventario(CodP, CodE, CodM, CodA, Dig, CodAnimalGravar, CodPessoaProdutor, CodPropriedadeRural, false);

  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2318, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2318;
      Exit;
    End;
  End;
end;

function TIntInventariosAnimais.InserirIntervalo(CodPessoaProdutor,
  CodPropriedadeRural: Integer; const CodSisbovInicial,
  CodSisbovFinal: String): Integer;
const
  NomeMetodo: String = 'InserirIntervalo';
var
  CodP, CodE, CodM, CodA, Dig, CodAI, CodAF, CodAnimalGravar: Integer;
  JaIncluido: Boolean;
begin
  Result := -0;
  JaIncluido := False;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(92) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  // Consiste se parâmetros
  // Consiste se CodSisbov inicial e final foram informados
  if (Trim(CodSisbovInicial) = '') or (Trim(CodSisbovFinal) = '') then begin
    Mensagens.Adicionar(2330, Self.ClassName, NomeMetodo, []);
    Result := -2330;
    Exit;
  end;

  // CodSisbov deve possuir 14 ou 16 caracteres
  if (Length(Trim(CodSisbovInicial)) <> 14) and (Length(Trim(CodSisbovInicial)) <> 16) then begin
    Mensagens.Adicionar(2331, Self.ClassName, NomeMetodo, []);
    Result := -2331;
    Exit;
  end;
  if (Length(Trim(CodSisbovFinal)) <> 14) and (Length(Trim(CodSisbovFinal)) <> 16) then begin
    Mensagens.Adicionar(2331, Self.ClassName, NomeMetodo, []);
    Result := -2331;
    Exit;
  end;

  // Pais, estado e micro-região dos códigos sisbov inicial e final devem ser idênticos
  if Length(Trim(CodSisbovInicial)) = 14 then begin
    if Copy(Trim(CodSisbovInicial), 1, 5) <> Copy(Trim(CodSisbovFinal), 1, 5) then begin
      Mensagens.Adicionar(2332, Self.ClassName, NomeMetodo, []);
      Result := -2332;
      Exit;
    end;
  end else begin
    if Copy(Trim(CodSisbovInicial), 1, 7) <> Copy(Trim(CodSisbovFinal), 1, 7) then begin
      Mensagens.Adicionar(2332, Self.ClassName, NomeMetodo, []);
      Result := -2332;
      Exit;
    end;
  end;

  // Extrai os códigos de pais, estado, micro regiao e animal dos códigos sisbov
  CodP := StrToInt(Copy(Trim(CodSisbovInicial), 1, 3));
  CodE := StrToInt(Copy(Trim(CodSisbovInicial), 4, 2));
  if Length(CodSisbovInicial) = 14 then begin
    CodM := -1;
    CodAI := StrToInt(Copy(Trim(CodSisbovInicial), 6, 9));
    CodAF := StrToInt(Copy(Trim(CodSisbovFinal), 6, 9));
  end else begin
    CodM := StrToInt(Copy(Trim(CodSisbovInicial), 6, 2));
    CodAI := StrToInt(Copy(Trim(CodSisbovInicial), 8, 9));
    CodAF := StrToInt(Copy(Trim(CodSisbovFinal), 8, 9));
  end;

  // Codigo final deve ser maior ou igual ao inicial
  if CodAI > CodAF then begin
    Mensagens.Adicionar(2334, Self.ClassName, NomeMetodo, []);
    Result := -2334;
    Exit;
  end;

  // Consiste produtor e propriedade
  Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  end;

  // Tenta inserir cada um dos códigos do intervalo
  For CodA := CodAI to CodAF do Begin
    Dig := BuscarDVSisBov(CodP, CodE, CodM, CodA);
    Result := ObterCodAnimal(CodP, CodE, CodM, CodA, Dig, CodPessoaProdutor);
    if Result < 0 then begin
      Exit;
    end;
    CodAnimalGravar := Result;

    Result := InserirInventario(CodP, CodE, CodM, CodA, Dig, CodAnimalGravar, CodPessoaProdutor, CodPropriedadeRural, true);
    if Result < 0 then begin
      if Result <> -2320 then begin
        Exit;
      end else begin
        JaIncluido := True;
      end;
    end;
  End;

  if JaIncluido then begin
    Mensagens.Adicionar(2333, Self.ClassName, NomeMetodo, []);
    Result := -2333;
  end;
end;

function TIntInventariosAnimais.InserirInventario(CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
  CodAnimal, CodPessoaProdutor, CodPropriedadeRural: Integer; Intervalo: Boolean): Integer;
const
  NomeMetodo: String = 'InserirInventario';
var
  Q : THerdomQuery;
  CodSisbov : String;
begin
  Result := 0;
  CodSisbov := '';

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se animal já foi inventariado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_inventario_animal ');
      Q.SQL.Add(' where ((cod_pais_sisbov = :cod_pais_sisbov and ');
      Q.SQL.Add('         cod_estado_sisbov = :cod_estado_sisbov and ');
      Q.SQL.Add('				  cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov and ');
      Q.SQL.Add('				  cod_animal_sisbov = :cod_animal_sisbov and ');
      Q.SQL.Add('				  num_dv_sisbov = :num_dv_sisbov) ');
      Q.SQL.Add('			  or ');
      Q.SQL.Add('			   (cod_animal = :cod_animal)) ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
      Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.Open;

      If not Q.IsEmpty Then Begin
        if not Intervalo then begin
          if CodMicroRegiaoSisbov = -1 then begin
            CodSisbov := CodSisbov + '105' +
                               PadL(IntToStr(CodEstadoSisbov), '0', 2) +
                               PadL(IntToStr(CodAnimalSisbov), '0', 9) +
                               PadL(IntToStr(NumDvSisbov), '0', 1);
          end else begin
            // Se o codigo micro região sisbov for igual 0, muda para 00. De acordo
            // com as novas implementações do sisbov
            if CodMicroRegiaoSisbov = 0 then begin
              CodSisbov := CodSisbov + '105' +
                               PadL(IntToStr(CodEstadoSisbov), '0', 2) +
                               '00' +
                               PadL(IntToStr(CodAnimalSisbov), '0', 9) +
                               PadL(IntToStr(NumDvSisbov), '0', 1);
            end else begin
              CodSisbov := CodSisbov + '105' +
                               PadL(IntToStr(CodEstadoSisbov), '0', 2) +
                               PadL(IntToStr(CodMicroRegiaoSisbov), '0', 2) +
                               PadL(IntToStr(CodAnimalSisbov), '0', 9) +
                               PadL(IntToStr(NumDvSisbov), '0', 1);
            end;
          end;

          Mensagens.Adicionar(2320, Self.ClassName, NomeMetodo, [CodSisbov]);
        end;
        Result := -2320;
        Exit;
      End;
      Q.Close;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert tab_inventario_animal ');
      Q.SQL.Add('  (cod_pais_sisbov, ');
      Q.SQL.Add('   cod_estado_sisbov, ');
      Q.SQL.Add('   cod_micro_regiao_sisbov, ');
      Q.SQL.Add('   cod_animal_sisbov, ');
      Q.SQL.Add('   num_dv_sisbov, ');
      Q.SQL.Add('   cod_animal, ');
      Q.SQL.Add('   cod_pessoa_produtor, ');
      Q.SQL.Add('   cod_propriedade_rural, ');
      Q.SQL.Add('   cod_usuario, ');
      Q.SQL.Add('   ind_transmissao_sisbov, ');
      Q.SQL.Add('   dta_lancamento_inventario) ');
      Q.SQL.Add('values ');
      Q.SQL.Add('  (:cod_pais_sisbov, ');
      Q.SQL.Add('   :cod_estado_sisbov, ');
      Q.SQL.Add('   :cod_micro_regiao_sisbov, ');
      Q.SQL.Add('   :cod_animal_sisbov, ');
      Q.SQL.Add('   :num_dv_sisbov, ');
      Q.SQL.Add('   :cod_animal, ');
      Q.SQL.Add('   :cod_pessoa_produtor, ');
      Q.SQL.Add('   :cod_propriedade_rural, ');
      Q.SQL.Add('   :cod_usuario, ');
      Q.SQL.Add('   ''N'', ');
      Q.SQL.Add('   getdate() ) ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
      Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
      if CodAnimal > 0 then begin
        Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      end else begin
        Q.ParamByName('cod_animal').DataType := ftInteger;
        Q.ParamByName('cod_animal').Clear;
      end;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2318, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2318;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.InserirAnimaisPesquisados(CodPessoaProdutor,
  CodPropriedadeRural: Integer; QueryPesquisa: THerdomQueryNavegacao): Integer;
const
  NomeMetodo: String = 'InserirAnimaisPesquisados';
var
  BM: TBookMark;
  CodP, CodE, CodM, CodA, Dig: Integer;
  JaIncluido: Boolean;
begin
  JaIncluido := false;

  // Se não há animais pesquisados, não pode realizar a inserção
  If QueryPesquisa.IsEmpty Then Begin
    Mensagens.Adicionar(2338, Self.ClassName, NomeMetodo, []);
    Result := -2338;
    Exit;
  End;

  // Consiste produtor e propriedade
  Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  end;

  // Tenta inserir cada um dos códigos de animal pesquisados
  BM := QueryPesquisa.GetBookmark;
  try
    QueryPesquisa.First;
    While not QueryPesquisa.EOF do begin
      // Obtém código SISBOV
      Result := ObterCodigoSisbov(QueryPesquisa.FieldByName('CodAnimal').AsInteger, CodPessoaProdutor, CodP, CodE, CodM, CodA, Dig);
      if Result < 0 then begin
        Exit;
      end;

      // Tenta inserir animal
      Result := InserirInventario(CodP, CodE, CodM, CodA, Dig, QueryPesquisa.FieldByName('CodAnimal').AsInteger, CodPessoaProdutor, CodPropriedadeRural, true);
      if Result < 0 then begin
        if Result <> -2320 then begin
          Exit;
        end else begin
          JaIncluido := True;
        end;
      end;
      QueryPesquisa.Next;
    End;
  finally
    QueryPesquisa.GotoBookmark(BM);
  end;

  if JaIncluido then begin
    Mensagens.Adicionar(2333, Self.ClassName, NomeMetodo, []);
    Result := -2333;
  end;
end;

function TIntInventariosAnimais.ObterCodAnimal(CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
  CodPessoaProdutor: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodAnimal';
var
  Q : THerdomQuery;
  NRSisbov : String;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ta.cod_pais_sisbov, ');
      Q.SQL.Add('       ta.cod_estado_sisbov, ');
      Q.SQL.Add('       ta.cod_micro_regiao_sisbov, ');
      Q.SQL.Add('			  ta.cod_animal_sisbov, ');
      Q.SQL.Add('			  ta.num_dv_sisbov, ');
      Q.SQL.Add('			  ta.cod_animal, ');
      Q.SQL.Add('       ta.cod_pessoa_produtor ');
      Q.SQL.Add('  from tab_animal ta ');
      Q.SQL.Add(' where ta.cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and ta.cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('   and ta.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('		and ta.cod_animal_sisbov = :cod_animal_sisbov ');
      Q.SQL.Add('		and ta.dta_fim_validade is null ');
      Q.SQL.Add('		and ta.dta_desativacao is null ');
      if NumDvSisbov >= 0 then begin
        Q.SQL.Add('		and ta.num_dv_sisbov = :num_dv_sisbov ');
      end;
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
      if NumDvSisbov >= 0 then begin
        Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
      end;
      Q.Open;

      If not Q.IsEmpty Then Begin
        if Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor then begin
          // Se o codigo micro região sisbov for igual -1, retira-se o codigo micro regiao
          // e insere no início o código do país, de acordo com as novas implementações do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then begin
            NRSisbov := '105' +
            PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
            PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
            PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end else begin
            // Se o codigo micro região sisbov for igual 0, muda para 00. De acordo
            // com as novas implementações do sisbov
            if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
              NRSisbov := '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                           '00' +
                           PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                           PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end else begin
              NRSisbov := '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
              PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end;
          end;

          Mensagens.Adicionar(2319, Self.ClassName, NomeMetodo, [NRSisbov]);
//          Result := -2319;
//          Exit;
        end;
        Result := Q.FieldByName('cod_animal').AsInteger;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2329, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2329;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.Pesquisar(NomProdutor, SglProdutor, NomPropriedadeRural: String;
      DtaLancamentoInventarioIni, DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
      DtaTransmissaoSisbovFim: TDateTime; IndTransmissaoSisbov: String; Tipo: Integer): Integer;
const
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(101) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select ');
  if Tipo = 2 then begin
    Query.SQL.Add('   char(39) + ');
  end;
  Query.SQL.Add('       convert(char(3), tia.cod_pais_sisbov) + ');
  Query.SQL.Add('         right(''00'' + convert(varchar(2), tia.cod_estado_sisbov), 2) + ');
  Query.SQL.Add('         CASE tia.cod_micro_regiao_sisbov WHEN 0 THEN  ');
  Query.SQL.Add('           ''00''  ');
  Query.SQL.Add('         WHEN -1 THEN  ');
  Query.SQL.Add('           ''''  ');
  Query.SQL.Add('         ELSE  ');
  Query.SQL.Add('           right(''00'' + convert(varchar(2), tia.cod_micro_regiao_sisbov), 2) ');
  Query.SQL.Add('         END + ');
  Query.SQL.Add('       right(''000000000'' + convert(varchar(9), tia.cod_animal_sisbov), 9) + ');
  Query.SQL.Add('       convert(varchar(1), tia.num_dv_sisbov) as CodAnimalSisbov, ');
  Query.SQL.Add('			  tia.cod_animal as CodAnimal, ');
  Query.SQL.Add('			  tia.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('			  ta.cod_animal_certificadora as CodAnimalCertificadora, ');
  Query.SQL.Add('			  tp.sgl_produtor as SglProdutor, ');
  Query.SQL.Add('       tps.nom_pessoa as NomPessoa, ');
  Query.SQL.Add(' 		  tia.cod_propriedade_rural as CodPropriedadeRural, ');
  Query.SQL.Add('			  tpr.nom_propriedade_rural as NomPropriedadeRural, ');
  Query.SQL.Add('			  tia.cod_usuario as CodUsuario, ');
  Query.SQL.Add('			  tu.nom_usuario as NomUsuario, ');
  Query.SQL.Add('			  tia.ind_transmissao_sisbov as IndTransmissaoSisbov, ');
  Query.SQL.Add('			  case tia.ind_transmissao_sisbov when ''S'' then ''Transmitido'' when ''E'' then ''Erro'' else ''Não Transmitido'' end as DesTransmissaoSisbov, ');
  Query.SQL.Add('			  tia.dta_lancamento_inventario as DtaLancamentoInventario, ');
  if (DtaTransmissaoSisbovIni > 0) or (DtaTransmissaoSisbovFim > 0) then begin
    Query.SQL.Add('			  tei.dta_transacao_sisbov as DtaTransacaoSisbov, ');
  end else begin
    Query.SQL.Add('			  null as DtaTransacaoSisbov, ');
  end;
  Query.SQL.Add('			  tia.txt_mensagem_erro as TxtMensagemErro, ');
  Query.SQL.Add('			  '''' as TxtMensagemErroEfetivacao');
  Query.SQL.Add('  from tab_inventario_animal tia, ');
  Query.SQL.Add('       tab_animal ta, ');
  Query.SQL.Add('	      tab_produtor tp, ');
  Query.SQL.Add('			  tab_pessoa tps, ');
  Query.SQL.Add('			  tab_propriedade_rural tpr, ');
  Query.SQL.Add('			  tab_usuario tu ');
  if (DtaTransmissaoSisbovIni > 0) or (DtaTransmissaoSisbovFim > 0) then begin
    Query.SQL.Add('			, tab_efetivacao_inventario tei ');
  end;
  Query.SQL.Add(' where ta.cod_animal =* tia.cod_animal_sisbov ');
  Query.SQL.Add('   and tp.cod_pessoa_produtor = tia.cod_pessoa_produtor ');
  Query.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
  Query.SQL.Add('	  and tpr.cod_propriedade_rural = tia.cod_propriedade_rural ');
  Query.SQL.Add('	  and tu.cod_usuario = tia.cod_usuario ');
  if NomProdutor <> '' then begin
    Query.SQL.Add('   and tps.nom_pessoa like ''' + NomProdutor + '%'' ');
  end;
  if SglProdutor <> '' then begin
    Query.SQL.Add('   and tp.sgl_produtor = ''' + SglProdutor + ''' ');
  end;
  if NomPropriedadeRural <> '' then begin
    Query.SQL.Add('   and tpr.nom_propriedade_rural like ''' + NomPropriedadeRural + '%'' ');
  end;
  if DtaLancamentoInventarioIni > 0 then begin
    Query.SQL.Add('   and tia.dta_lancamento_inventario >= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioIni) + ' 00:00:00'' ');
  end;
  if DtaLancamentoInventarioFim > 0 then begin
    Query.SQL.Add('   and tia.dta_lancamento_inventario <= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioFim) + ' 23:59:59'' ');
  end;
  if (DtaTransmissaoSisbovIni > 0) then begin
    Query.SQL.Add('   and tei.dta_transacao_sisbov >= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovIni) + ' 00:00:00'' ');
    Query.SQL.Add('	  and tei.cod_propriedade_rural = tia.cod_propriedade_rural ');
    Query.SQL.Add('	  and tei.cod_pessoa_produtor   = tia.cod_pessoa_produtor ');
  end;
  if (DtaTransmissaoSisbovFim > 0) then begin
    Query.SQL.Add('   and tei.dta_transacao_sisbov <= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovFim) + ' 23:59:59'' ');
    if DtaTransmissaoSisbovIni = 0 then begin
      Query.SQL.Add('	  and tei.cod_propriedade_rural = tia.cod_propriedade_rural ');
      Query.SQL.Add('	  and tei.cod_pessoa_produtor   = tia.cod_pessoa_produtor ');
    end;
  end;
  if Trim(IndTransmissaoSisbov) <> 'T' then begin
    Query.SQL.Add('   and tia.ind_transmissao_sisbov = ''' + Trim(IndTransmissaoSisbov) + '''');
  end;

  if Trim(IndTransmissaoSisbov) = 'E' then begin
    Query.SQL.Add(' union ');
    Query.SQL.Add('   select ');
    Query.SQL.Add('        '''' as CodAnimalSisbov, ');
    Query.SQL.Add('        null as CodAnimal, ');
    Query.SQL.Add('        tp.cod_pessoa_produtor as CodPessoaProdutor, ');
    Query.SQL.Add('        null as CodAnimalCertificadora, ');
    Query.SQL.Add('        tp.sgl_produtor as SglProdutor, ');
    Query.SQL.Add('        tps.nom_pessoa as NomPessoa, ');
    Query.SQL.Add('        tpr.cod_propriedade_rural as CodPropriedadeRural, ');
    Query.SQL.Add('        tpr.nom_propriedade_rural as NomPropriedadeRural, ');
    Query.SQL.Add('        tei.cod_usuario_transacao as CodUsuario, ');
    Query.SQL.Add('        tu.nom_usuario as NomUsuario, ');
    Query.SQL.Add('        tei.ind_transmissao_sisbov as IndTransmissaoSisbov, ');
    Query.SQL.Add('        ''Erro'' as DesTransmissaoSisbov, ');
    Query.SQL.Add('        null as DtaLancamentoInventario, ');
    Query.SQL.Add('        null as DtaTransacaoSisbov, ');
    Query.SQL.Add('        null as TxtMensagemErro, ');
    Query.SQL.Add('        tei.txt_mensagem_erro as TxtMensagemErroEfetivacao ');
    Query.SQL.Add('  from tab_efetivacao_inventario tei, ');
    Query.SQL.Add('        tab_produtor tp, ');
    Query.SQL.Add('        tab_pessoa tps, ');
    Query.SQL.Add('        tab_propriedade_rural tpr, ');
    Query.SQL.Add('        tab_usuario tu ');
    Query.SQL.Add('  where tp.sgl_produtor = ''' + SglProdutor + ''' ');
    Query.SQL.Add('   and tpr.nom_propriedade_rural like ''' + NomPropriedadeRural + '%'' ');
    Query.SQL.Add('   and tei.cod_propriedade_rural = tpr.cod_propriedade_rural ');
    Query.SQL.Add('   and tei.cod_pessoa_produtor   = tp.cod_pessoa_produtor ');
    Query.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
    Query.SQL.Add('   and tu.cod_usuario = tei.cod_usuario_efetivacao ');
    Query.SQL.Add('   and tei.ind_transmissao_sisbov = ''E'' ');
  end;
  Query.SQL.Add(' order by 1 ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2324, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2324;
      Exit;
    End;
  End;
end;

function TIntInventariosAnimais.PesquisarEfetivados(const SglProdutor, NomProdutor, NomPropriedadeRural: String;
      CodIDPropriedade: Integer; DtaEfetivacaoInicio, DtaEfetivacaoFinal: TDateTime;
      const IndTransmissaoSisbov: String): Integer;
const
  NomeMetodo: String = 'PesquisarEfetivados';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(101) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tei.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('       tp.sgl_produtor as SglProdutor, ');
  Query.SQL.Add('       tps.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tei.cod_propriedade_rural as CodPropriedadeRural, ');
  Query.SQL.Add('       tpr.nom_propriedade_rural as NomPropriedadeRural, ');
  Query.SQL.Add('       tpr.num_imovel_receita_federal as NumImovelPropriedade, ');
  Query.SQL.Add('       tei.cod_usuario_efetivacao as CodUsuarioEfetivacao, ');
  Query.SQL.Add('       tu.nom_usuario as NomUsuarioEfetivacao, ');
  Query.SQL.Add('       tei.dta_efetivacao_sisbov as DtaEfetivacaoSisbov, ');
  Query.SQL.Add('       tei.cod_usuario_transacao as CodUsuarioTransacao, ');
  Query.SQL.Add('       tu1.nom_usuario as NomUsuarioTransacao, ');
  Query.SQL.Add('       tei.dta_transacao_sisbov as DtaTransacaoSisbov, ');
  Query.SQL.Add('       tei.cod_id_transacao_sisbov as CodIdTransacaoSisbov, ');
  Query.SQL.Add('       tei.ind_transmissao_sisbov as IndTransmissaoSisbov, ');
  Query.SQL.Add('       case tei.ind_transmissao_sisbov when ''S'' then ''Transmitido'' when ''E'' then ''Erro'' when ''A'' then ''Agendado'' when ''P'' then ''Em Transmissão'' else ''Não Transmitido'' end as DesTransmissaoSisbov, ');
  Query.SQL.Add('       tei.ind_transmissao_tarefa as IndTransmissaoTarefa, ');
  Query.SQL.Add('       tei.val_percentual_processado as ValPercentualProcessado ');
  Query.SQL.Add('  from tab_efetivacao_inventario tei, ');
  Query.SQL.Add('       tab_produtor tp, ');
  Query.SQL.Add('       tab_pessoa tps, ');
  Query.SQL.Add('       tab_propriedade_rural tpr, ');
  Query.SQL.Add('       tab_usuario tu, ');
  Query.SQL.Add('       tab_usuario tu1 ');
  Query.SQL.Add('   where tp.cod_pessoa_produtor = tei.cod_pessoa_produtor ');
  Query.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
  Query.SQL.Add('   and tpr.cod_propriedade_rural = tei.cod_propriedade_rural ');
  Query.SQL.Add('   and tu.cod_usuario = tei.cod_usuario_efetivacao ');
  Query.SQL.Add('   and tu1.cod_usuario =* tei.cod_usuario_transacao ');

  if SglProdutor <> '' then begin
    Query.SQL.Add('   and tp.sgl_produtor = ''' + SglProdutor + ''' ');
  end;
  if NomProdutor <> '' then begin
    Query.SQL.Add('   and tps.nom_pessoa like ''' + NomProdutor + '%'' ');
  end;
  if NomPropriedadeRural <> '' then begin
    Query.SQL.Add('   and tpr.nom_propriedade_rural like ''' + NomPropriedadeRural + '%'' ');
  end;
  if CodIDPropriedade > 0 then begin
    Query.SQL.Add('   and tpr.cod_id_propriedade_sisbov = ' + IntToStr(CodIDPropriedade) );
  end;
  if DtaEfetivacaoInicio > 0 then begin
    Query.SQL.Add('   and tei.dta_efetivacao_sisbov >= ''' + FormatDateTime('yyyy-mm-dd', DtaEfetivacaoInicio) + ' 00:00:00'' ');
  end;
  if DtaEfetivacaoFinal > 0 then begin
    Query.SQL.Add('   and tei.dta_efetivacao_sisbov <= ''' + FormatDateTime('yyyy-mm-dd', DtaEfetivacaoFinal) + ' 23:59:59'' ');
  end;
  if Trim(IndTransmissaoSisbov) <> 'T' then begin
    Query.SQL.Add(' and  tei.ind_transmissao_sisbov = ''' + Trim(IndTransmissaoSisbov) + '''');
  end;

  Query.SQL.Add(' order by tei.dta_efetivacao_sisbov desc, tps.nom_pessoa ');

{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2324, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2324;
      Exit;
    End;
  End;
end;

function TIntInventariosAnimais.Transmitir: Integer;
const
  NomeMetodo: String = 'Transmitir';
var
  Q : THerdomQuery;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
//  Codigos: ArrayOf_xsd_string;
//  QtdCodigos, CodIDPropriedade, I, CodProd, CodProp: Integer;
  CodProd, CodProp: Integer;
  CpfProdutor, CnpjProdutor: String;
  Efetivado: Boolean;
  IndTarefa: Boolean;
begin
  IndTarefa := False;

  // Query para leitura dos registros de inventário efetivados ainda não transmitidos
  // ou com erro na última transmissão
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    // Cria classe de conexão SOAP
    SoapSisbov := TIntSoapSisbov.Create;
    Try
      Try
        // Conexão SOAP
        SoapSisbov.Inicializar(Conexao, Mensagens);
        Conectado:= SoapSisbov.conectado('InventariosAnimais');

        if Conectado then begin
          // Query para leitura dos registros ainda não transmitidos ou com erro na última transmissão
          Q.SQL.Clear;
  {$IFDEF MSSQL}
          Q.SQL.Add('select tei.cod_pessoa_produtor, ');
          Q.SQL.Add('       tei.cod_propriedade_rural, ');
          Q.SQL.Add('       case tps.cod_natureza_pessoa ');
          Q.SQL.Add('         when ''F'' then tps.num_cnpj_cpf ');
          Q.SQL.Add('       else ');
          Q.SQL.Add('         '''' ');
          Q.SQL.Add('       end as num_cpf_produtor, ');
          Q.SQL.Add('       case tps.cod_natureza_pessoa ');
          Q.SQL.Add('         when ''J'' then tps.num_cnpj_cpf ');
          Q.SQL.Add('       else ');
          Q.SQL.Add('         '''' ');
          Q.SQL.Add('       end as num_cnpj_produtor, ');
          Q.SQL.Add('       tpr.cod_id_propriedade_sisbov ');
          Q.SQL.Add('  from tab_efetivacao_inventario tei, ');
          Q.SQL.Add('       tab_pessoa tps, ');
          Q.SQL.Add('       tab_propriedade_rural tpr ');
          Q.SQL.Add(' where tps.cod_pessoa = tei.cod_pessoa_produtor ');
          Q.SQL.Add('   and tpr.cod_propriedade_rural = tei.cod_propriedade_rural ');
          Q.SQL.Add('   and tei.ind_transmissao_sisbov = ''N'' ');
          Q.SQL.Add('   and tei.ind_transmissao_tarefa = ''N'' ');
          Q.SQL.Add(' order by tei.cod_propriedade_rural, ');
          Q.SQL.Add('          tei.cod_pessoa_produtor ');
  {$ENDIF}
          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(2327, Self.ClassName, NomeMetodo, []);
            Result := -2327;
            Exit;
          End;

//          I := 0;

          CodProd          := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          CodProp          := Q.FieldByName('cod_propriedade_rural').AsInteger;
          CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
          CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
//          CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;

          // Varre todos os registros
          Efetivado := False;
          while not Q.Eof do begin
            // Verifica se todos os produtores da propriedade efetivaram o inventário
            Result := InventariosDaPropriedadeEfetivados(Q.FieldByName('cod_propriedade_rural').AsInteger, Efetivado);
            if Result < 0 then begin
              Exit;
            end;

            // Se um dos produtores da propriedade não efetivaram, grava "erro" na tab_efetivacao_inventario
            // para os produtores que efetivaram, e ignora registros até a próxima propriedade
            if not Efetivado then begin
              // Grava mensagem de erro nos animais do produtor
              Result := GravaErroInventarioProdutor(CodProd, CodProp, 'Existem um ou mais produtores da propriedade que ainda não efetivaram o inventario dos animais. Só é possível a transmissão quando todos os produtores da propriedade efetivarem o inventário.', 0, Conexao.DtaSistema);
              if Result < 0 then begin
                Exit;
              end;

              // Ignora inventários até o próximo produtor/propriedade
              while (Q.FieldByName('cod_pessoa_produtor').AsInteger = CodProd) and (Q.FieldByName('cod_propriedade_rural').AsInteger = CodProp) and not Q.Eof do begin
                Q.Next;
              end;

              // Se chegou ao fim da query então finaliza o loop
              if Q.Eof then Break;
              CodProd          := Q.FieldByName('cod_pessoa_produtor').AsInteger;
              CodProp          := Q.FieldByName('cod_propriedade_rural').AsInteger;
              CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
              CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
//              CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
              Continue;
            end;

//            if (Q.FieldByName('cod_propriedade_rural').AsInteger = CodProp) then begin
//              SetLength(Codigos, I + 1);
//              Codigos[I] := Q.FieldByName('CodSisbovEnvio').AsString;
//              Inc(I);
//            end else begin
              // Verifica se quantidade de animais, se a quantidade for maior que o valor do parâmetro 127
              // então a transmissão deve ser feita por tarefa e não no módulo online
//              if I > StrToInt(ValorParametro(127)) then begin

                Result := MarcarInventarioComoTarefa(CodProp);
                if Result < 0 then begin
                  Exit;
                end;
                IndTarefa := True;

//              end else begin
//                QtdCodigos := I;
//                Result := TransmitirInventario(SoapSisbov,
//                                               CodProp,
//                                               CodIDPropriedade,
//                                               QtdCodigos,
//                                               Codigos);
//              end;

//              QtdCodigos := I;
//              I := 0;

              CodProd          := Q.FieldByName('cod_pessoa_produtor').AsInteger;
              CodProp          := Q.FieldByName('cod_propriedade_rural').AsInteger;
              CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
              CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
//              CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;

//              SetLength(Codigos, 0);
//              Continue;
//            end;

            Q.Next;
          end;  // while

          // Transmite o último lote de animais já que no fim da query não será encontrada
          // uma "quebra" de propriedade
//          if Efetivado then begin
            // Verifica se quantidade de animais, se a quantidade for maior que o valor do parâmetro 127
            // então a transmissão deve ser feita por tarefa e não no módulo online
//            if I > StrToInt(ValorParametro(127)) then begin
//              Result := MarcarInventarioComoTarefa(CodProp);
//              if Result < 0 then begin
//                Exit;
//              end;
//              IndTarefa := True;
//            end else begin
//              QtdCodigos := I;
//              Result := TransmitirInventario(SoapSisbov,
//                                             CodProp,
//                                             CodIDPropriedade,
//                                             QtdCodigos,
//                                             Codigos);
//              if Result < 0 then begin
//                exit;
//              End;
//            end;
//          end;

          Q.Close;
        end;  // if not conectado

        // Se algum inventário foi marcado para ser transmitido via tarefa, informa ao usuário 
        if IndTarefa then begin
          Mensagens.Adicionar(2373, Self.ClassName, NomeMetodo, [ValorParametro(127)]);
          Result := -2373;
        end else begin
          Result := 0;
        end;
      Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -2326;
          Exit;
        End;
      End;
    Finally
      SoapSisbov.Free;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.ObterCodigoSisbov(CodAnimal, CodPessoaProdutor: Integer;
  var CodPaisSisbov, CodEstadoSisbov, CodMicroRegiaoSisbov,
  CodAnimalSisbov, NumDvSisbov: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodigoSisbov';
var
  Q : THerdomQuery;
  NRSisbov : String;
begin
  Result := 0;
  // Consistências dependentes do banco de dados
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ta.cod_pais_sisbov, ');
      Q.SQL.Add('       ta.cod_estado_sisbov, ');
      Q.SQL.Add('       ta.cod_micro_regiao_sisbov, ');
      Q.SQL.Add('			  ta.cod_animal_sisbov, ');
      Q.SQL.Add('			  ta.num_dv_sisbov, ');
      Q.SQL.Add('			  ta.cod_animal, ');
      Q.SQL.Add('       ta.cod_pessoa_produtor ');
      Q.SQL.Add('  from tab_animal ta ');
      Q.SQL.Add(' where ta.cod_animal = :cod_animal ');
{$ENDIF}
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(692, Self.ClassName, NomeMetodo, []);
        Result := -692;
        Exit;
      End;

      if Q.FieldByName('cod_pessoa_produtor').AsInteger <> CodPessoaProdutor then begin
        // Se o codigo micro região sisbov for igual -1, retira-se o codigo micro regiao
        // e insere no início o código do país, de acordo com as novas implementações do sisbov
        if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then begin
          NRSisbov := '105' +
          PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
          PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
          PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
        end else begin
          // Se o codigo micro região sisbov for igual 0, muda para 00. De acordo
          // com as novas implementações do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
            NRSisbov := '105' +
            PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                         '00' +
                         PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                         PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end else begin
            NRSisbov := '105' +
            PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
            PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
            PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
            PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end;
        end;

        Mensagens.Adicionar(2319, Self.ClassName, NomeMetodo, [NRSisbov]);
//        Result := -2319;
//        Exit;
      end;

      CodPaisSisbov := Q.FieldByName('cod_pais_sisbov').AsInteger;
      CodEstadoSisbov := Q.FieldByName('cod_estado_sisbov').AsInteger;
      CodMicroRegiaoSisbov := Q.FieldByName('cod_micro_regiao_sisbov').AsInteger;
      CodAnimalSisbov := Q.FieldByName('cod_animal_sisbov').AsInteger;
      NumDvSisbov  := Q.FieldByName('num_dv_sisbov').AsInteger;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2341, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2341;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.ExcluirAnimaisPesquisados(
  CodPessoaProdutor, CodPropriedadeRural: Integer;
  QueryPesquisa: THerdomQueryNavegacao): Integer;
const
  NomeMetodo: String = 'ExcluirAnimaisPesquisados';
var
  BM: TBookMark;
  CodP, CodE, CodM, CodA, Dig: Integer;
  NaoIncluido: Boolean;
begin
  // Se não há animais pesquisados, não pode realizar a exclusão
  If QueryPesquisa.IsEmpty Then Begin
    Mensagens.Adicionar(2345, Self.ClassName, NomeMetodo, []);
    Result := -2345;
    Exit;
  End;

  // Consiste produtor e propriedade
  Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  end;

  // Tenta excluir cada um dos códigos de animal pesquisados
  BM := QueryPesquisa.GetBookmark;
  try
    NaoIncluido := false;
    QueryPesquisa.First;
    While not QueryPesquisa.EOF do begin
      // Obtém código SISBOV
      Result := ObterCodigoSisbov(QueryPesquisa.FieldByName('CodAnimal').AsInteger, CodPessoaProdutor, CodP, CodE, CodM, CodA, Dig);
      if Result < 0 then begin
        Exit;
      end;

      // Tenta excluir inventario
      Result := ExcluirInventario(CodP, CodE, CodM, CodA, Dig, QueryPesquisa.FieldByName('CodAnimal').AsInteger, CodPessoaProdutor, CodPropriedadeRural, true);
      if Result < 0 then begin
        if Result <> -2321 then begin
          Exit;
        end else begin
          NaoIncluido := True;
        end;
      end;
      QueryPesquisa.Next;
    End;
  finally
    QueryPesquisa.GotoBookmark(BM);
  end;

  if NaoIncluido then begin
    Mensagens.Adicionar(2347, Self.ClassName, NomeMetodo, []);
    Result := -2347;
  end;
end;

function TIntInventariosAnimais.InventarioEfetivado(CodPessoaProdutor,
  CodPropriedadeRural: Integer; var Efetivado: boolean): Integer;
const
  NomeMetodo: String = 'InventarioEfetivado';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Efetivado := False;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se produtor/propriedade já foram efetivados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_efetivacao_inventario tei');
      Q.SQL.Add(' where tei.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tei.cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Efetivado := True;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2346, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2346;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.InventariosDaPropriedadeEfetivados(
  CodPropriedadeRural: Integer; var Efetivado: boolean): Integer;
const
  NomeMetodo: String = 'InventariosDaPropriedadeEfetivados';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Efetivado := False;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se os inventários de todos os produtores que inventariaram animais da propriedade
      // já foram efetivados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tia.cod_pessoa_produtor, ');
      Q.SQL.Add('       tia.cod_propriedade_rural ');
      Q.SQL.Add('  from tab_inventario_animal tia ');
      Q.SQL.Add(' where tia.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and not exists (select distinct 1 ');
      Q.SQL.Add('                     from tab_efetivacao_inventario tei ');
      Q.SQL.Add('                    where tei.cod_propriedade_rural = tia.cod_propriedade_rural ');
      Q.SQL.Add('                      and tei.cod_pessoa_produtor = tia.cod_pessoa_produtor) ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Efetivado := True;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2346, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2346;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


function TIntInventariosAnimais.ExcluirInventario(CodPaisSisbov,
  CodEstadoSisbov, CodMicroRegiaoSisbov, CodAnimalSisbov, NumDvSisbov,
  CodAnimal, CodPessoaProdutor, CodPropriedadeRural: Integer;
  Intervalo: Boolean): Integer;
const
  NomeMetodo: String = 'ExcluirInventario';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste animal no inventário
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_transmissao_sisbov ');
      Q.SQL.Add('  from tab_inventario_animal ');
      Q.SQL.Add(' where ((cod_pais_sisbov = :cod_pais_sisbov and ');
      Q.SQL.Add('         cod_estado_sisbov = :cod_estado_sisbov and ');
      Q.SQL.Add('				  cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov and ');
      Q.SQL.Add('				  cod_animal_sisbov = :cod_animal_sisbov and ');
      Q.SQL.Add('				  num_dv_sisbov = :num_dv_sisbov) ');
      Q.SQL.Add('			  or ');
      Q.SQL.Add('			   (cod_animal = :cod_animal)) ');
      Q.SQL.Add('		and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('		and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
      Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      // Se não encontrou
      If Q.IsEmpty Then Begin
        if not Intervalo then begin
          Mensagens.Adicionar(2321, Self.ClassName, NomeMetodo, []);
        end;
        Result := -2321;
        Exit;
      End;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete tab_inventario_animal ');
      Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
      Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
      Q.SQL.Add('		and	cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('		and	cod_animal_sisbov = :cod_animal_sisbov ');
      Q.SQL.Add('		and num_dv_sisbov = :num_dv_sisbov ');
      Q.SQL.Add('		and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('		and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := CodAnimalSisbov;
      Q.ParamByName('num_dv_sisbov').AsInteger := NumDvSisbov;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2323, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2323;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.ExcluirIntervalo(CodPessoaProdutor,
  CodPropriedadeRural: Integer; CodSisbovInicial,
  CodSisbovFinal: String): Integer;
const
  NomeMetodo: String = 'ExcluirIntervalo';
var
  CodP, CodE, CodM, CodA, Dig, CodAI, CodAF, CodAnimalExcluir: Integer;
  NaoIncluido: Boolean;
begin
  Result := -0;
  NaoIncluido := False;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(92) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  // Consiste se parâmetros
  // Consiste se CodSisbov inicial e final foram informados
  if (Trim(CodSisbovInicial) = '') or (Trim(CodSisbovFinal) = '') then begin
    Mensagens.Adicionar(2330, Self.ClassName, NomeMetodo, []);
    Result := -2330;
    Exit;
  end;

  // CodSisbov deve possuir 14 ou 16 caracteres
  if (Length(Trim(CodSisbovInicial)) <> 14) and (Length(Trim(CodSisbovInicial)) <> 16) then begin
    Mensagens.Adicionar(2331, Self.ClassName, NomeMetodo, []);
    Result := -2331;
    Exit;
  end;
  if (Length(Trim(CodSisbovFinal)) <> 14) and (Length(Trim(CodSisbovFinal)) <> 16) then begin
    Mensagens.Adicionar(2331, Self.ClassName, NomeMetodo, []);
    Result := -2331;
    Exit;
  end;

  // Pais, estado e micro-região dos códigos sisbov inicial e final devem ser idênticos
  if Length(Trim(CodSisbovInicial)) = 14 then begin
    if Copy(Trim(CodSisbovInicial), 1, 5) <> Copy(Trim(CodSisbovFinal), 1, 5) then begin
      Mensagens.Adicionar(2332, Self.ClassName, NomeMetodo, []);
      Result := -2332;
      Exit;
    end;
  end else begin
    if Copy(Trim(CodSisbovInicial), 1, 7) <> Copy(Trim(CodSisbovFinal), 1, 7) then begin
      Mensagens.Adicionar(2332, Self.ClassName, NomeMetodo, []);
      Result := -2332;
      Exit;
    end;
  end;

  // Extrai os códigos de pais, estado, micro regiao e animal dos códigos sisbov
  CodP := StrToInt(Copy(Trim(CodSisbovInicial), 1, 3));
  CodE := StrToInt(Copy(Trim(CodSisbovInicial), 4, 2));
  if Length(CodSisbovInicial) = 14 then begin
    CodM := -1;
    CodAI := StrToInt(Copy(Trim(CodSisbovInicial), 6, 9));
    CodAF := StrToInt(Copy(Trim(CodSisbovFinal), 6, 9));
  end else begin
    CodM := StrToInt(Copy(Trim(CodSisbovInicial), 6, 2));
    CodAI := StrToInt(Copy(Trim(CodSisbovInicial), 8, 9));
    CodAF := StrToInt(Copy(Trim(CodSisbovFinal), 8, 9));
  end;

  // Codigo final deve ser maior ou igual ao inicial
  if CodAI > CodAF then begin
    Mensagens.Adicionar(2334, Self.ClassName, NomeMetodo, []);
    Result := -2334;
    Exit;
  end;

  // Consiste produtor e propriedade
  Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  end;

  // Tenta inserir cada um dos códigos do intervalo
  For CodA := CodAI to CodAF do Begin
    Dig := BuscarDVSisBov(CodP, CodE, CodM, CodA);
    Result := ObterCodAnimal(CodP, CodE, CodM, CodA, Dig, CodPessoaProdutor);
    if Result < 0 then begin
      Exit;
    end;
    CodAnimalExcluir := Result;

    Result := ExcluirInventario(CodP, CodE, CodM, CodA, Dig, CodAnimalExcluir, CodPessoaProdutor, CodPropriedadeRural, true);
    if Result < 0 then begin
      if Result <> -2321 then begin
        Exit;
      end else begin
        NaoIncluido := True;
      end;
    end;
  End;

  if NaoIncluido then begin
    Mensagens.Adicionar(2347, Self.ClassName, NomeMetodo, []);
    Result := -2347;
  end;
end;

function TIntInventariosAnimais.CancelarEfetivacao(CodPessoaProdutor,
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'CancelarEfetivacao';
var
  Q : THerdomQuery;
begin
  Result := 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Consistências
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se produtor/propriedade já foram efetivados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tei.ind_transmissao_sisbov ');
      Q.SQL.Add('  from tab_efetivacao_inventario tei');
      Q.SQL.Add(' where tei.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tei.cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(2348, Self.ClassName, NomeMetodo, []);
        Result := -2348;
        Exit;
      End;

      If Q.FieldByName('ind_transmissao_sisbov').AsString = 'S' then begin
        Mensagens.Adicionar(2349, Self.ClassName, NomeMetodo, []);
        Result := -2349;
        Exit;
      End;

      // Tenta Excluir registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_efetivacao_inventario ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2350, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2350;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.GerarRelatorioInventario(NomProdutor,
  SglProdutor, NomPropriedadeRural: String; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime; IndTransmissaoSisbov: String;
  Tipo: Integer): String;
const
  NomeMetodo: String = 'GerarRelatorioInventario';
  CodRelatorio: Integer = 30;
var
  Rel: TRelatorioPadrao;
  Retorno: Integer;
  Cod1, Cod2, Cod3, Cod4, Cod5: string;
  Q : THerdomQueryNavegacao;
  IntRelatorios: TIntRelatorios;
  NumCampos: Integer;
begin
  Result := '';

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
//  if not Conexao.PodeExecutarMetodo(Metodo) then begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Exit;
//  end;

  // Efetua a pesquisa de acordo com os parâmetros informados
  Retorno := Pesquisar(NomProdutor, SglProdutor, NomPropriedadeRural,
    DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
    DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim, IndTransmissaoSisbov, Tipo);
  if Retorno < 0 then begin
    Exit;
  end;

  Try  // Bloco try exception para tratar erros no método
    // Cria instância da classe Relatorios
    IntRelatorios := TIntRelatorios.Create;
    try
      Retorno := IntRelatorios.Inicializar(Conexao, Mensagens);
      if Retorno < 0 then begin
        Exit;
      end;

      // Posiciona a classe Relatorios no relatório desejado
      Retorno := IntRelatorios.Buscar(CodRelatorio);
      if Retorno < 0 then begin
        Exit;
      end;

      // Obtém as colunas do relatório desejado
      Retorno := IntRelatorios.Pesquisar(CodRelatorio);
      if Retorno < 0 then begin
        Exit;
      end;

      // Cria instância de relatório padrão
      Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
      Try
        // Define o relatório em questão e carrega os seus dados específicos
        Retorno := Rel.CarregarRelatorio(CodRelatorio);
        if Retorno < 0 then begin
          Exit;
        end;

        // Setando a quantidade de campos selecionados pelo usuario para a montagem do relatorio
        NumCampos := 1;
        if (IntRelatorios.CampoAssociado(6) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(7) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(8) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(9) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(10) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(11) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(12) = 1) then Inc(NumCampos);

        // Cria query para uso genérico
        Q := THerdomQueryNavegacao.Create(nil);
        try
          // Se o usuario optou pela impressao pdf (tipo=1) somente do código do sisbov,
          // eles serao apresentados em 5 colunas no relatorio, para isso cria-se uma
          // tabela temporária com 5 colunas, para montar a estrutura necessária
          if ((Tipo = 1) and (NumCampos = 1)) then begin
            Q.SQLConnection := Conexao.SQLConnection;
  {$IFDEF MSSQL}
            Q.SQL.Add('if object_id(''tempdb..#tmp_rel_inventario_animais'') is null '+
            #13#10'  create table #tmp_rel_inventario_animais '+
            #13#10'  ( '+
            #13#10'      CodAnimalSisbov  varchar(17) '+
            #13#10'    , CodAnimalSisbov1 varchar(17) '+
            #13#10'    , CodAnimalSisbov2 varchar(17) '+
            #13#10'    , CodAnimalSisbov3 varchar(17) '+
            #13#10'    , CodAnimalSisbov4 varchar(17) '+
            #13#10'  ) ');
  {$ENDIF}
            Q.ExecSQL;

            Q.SQL.Clear;
  {$IFDEF MSSQL}
            Q.SQL.Add('truncate table #tmp_rel_inventario_animais');
  {$ENDIF}
            Q.ExecSQL;

  {$IFDEF MSSQL}
            Q.SQL.Clear;
            Q.SQL.Add('insert into #tmp_rel_inventario_animais ');
            Q.SQL.Add('   values ( :Cod1 ');
            Q.SQL.Add('          , :Cod2 ');
            Q.SQL.Add('          , :Cod3 ');
            Q.SQL.Add('          , :Cod4 ');
            Q.SQL.Add('          , :Cod5 ');
            Q.SQL.Add('   ) ');
  {$ENDIF}

            // Varre animais pesquisados para compor tabela temporária
            Query.First;
            while (not Query.EOF) do begin
              Cod1 := Query.FieldByName('CodAnimalSisbov').AsString;
              Query.Next;
              if (not Query.EOF) then begin
                Cod2 := Query.FieldByName('CodAnimalSisbov').AsString;
                Query.Next;
                if (not Query.EOF) then begin
                  Cod3 := Query.FieldByName('CodAnimalSisbov').AsString;
                  Query.Next;
                  if (not Query.EOF) then begin
                    Cod4 := Query.FieldByName('CodAnimalSisbov').AsString;
                    Query.Next;
                    if (not Query.EOF) then begin
                      Cod5 := Query.FieldByName('CodAnimalSisbov').AsString;
                    end;
                  end;
                end;
              end;

              // Cria uma linha na tabela temporária que contém resultado de 5 linhas da pesquisa
              Q.ParamByName('Cod1').AsString := Cod1;
              Q.ParamByName('Cod2').AsString := Cod2;
              Q.ParamByName('Cod3').AsString := Cod3;
              Q.ParamByName('Cod4').AsString := Cod4;
              Q.ParamByName('Cod5').AsString := Cod5;
              Q.ExecSQL;
              Cod1 := ''; Cod2 := ''; Cod3 := ''; Cod4 := ''; Cod5 := '';
              Query.Next;
            end;
            Q.SQL.Clear;

            // Query para obter os fields da tabela temporária
  {$IFDEF MSSQL}
            Q.SQL.Add('select * ');
            Q.SQL.Add(' from #tmp_rel_inventario_animais ');
  {$ENDIF}
            Q.Open;
          end; // if ((Tipo = 1) and (NumCampos = 1))

          // Inicia montagem do relatório
          Rel.TipoDoArquvio := Tipo;
          Rel.Campos.IrAoPrimeiro;
          Retorno := Rel.InicializarRelatorio;
          if Retorno < 0 then  begin
            Exit;
          end;

          // Relatório somente de códigos sisbov (NumCampos = 1)
          if (NumCampos = 1) then begin
            // Tipo PDF
            if (Tipo = 1) then begin
              // Verifica se há algum código sisbov do inventário a imprimir
              if Q.IsEmpty then begin
                Mensagens.Adicionar(1307, Self.ClassName, NomeMetodo, []);
                Exit;
              end;

              // Varre tabela temporária para imprimir códigos sisbov
              Q.First;
              while (not Q.EOF) do begin
                Rel.ImprimirColunasResultSet(Q);
                Q.Next;
              end;

              // Dropa tabela temporária
              Q.SQL.Clear;
  {$IFDEF MSSQL}
              Q.SQL.Add('Drop table #tmp_rel_inventario_animais');
  {$ENDIF}
              Q.ExecSQL;
            end else begin
              // Tipo CSV
              // Verifica se há algum código sisbov do inventário a imprimir
              if Query.IsEmpty then begin
                Mensagens.Adicionar(1307, Self.ClassName, NomeMetodo, []);
                Exit;
              end;

              // Varre pesquisa para imprimir códigos sisbov
              Query.First;
              while not Query.EOF do begin
                Rel.ImprimirColunasResultSet(Query);
                Query.Next;
              end;
            end; // if Tipo = 1
          end else begin
            // Relatório normal, contém mais que um campo, então não é só de códigos SISBOV
            // Varre a pesquisa para imprimir o relatório
            Query.First;
            while not Query.EOF do begin
              // Formato PDF
              if Tipo = 1 then begin
                // Verifica se o próximo registro existe, para que o último registro
                // do relatório possa ser exibido na próxima folha, e assim o total não
                // seja mostrado sozinho nesta folha
                if Rel.LinhasRestantes <= 2 then begin
                  if Query.FindNext then begin
                    Query.Prior;
                  end else begin
                    Rel.NovaPagina;
                  end;
                end;
              end;
              Rel.ImprimirColunasResultSet(Query);
              Query.Next;
            end;
          end; // if (NumCampos = 1)

          Retorno := Rel.FinalizarRelatorio;
          {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
          if Retorno = 0 then begin
            Result := Rel.NomeArquivo;
          end;
        finally
          Q.Free;
        end;
      finally
        Rel.Free;
      end;
    finally
      IntRelatorios.Free;
    end;
  except // try Exception geral
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(2351, Self.ClassName, NomeMetodo, [E.Message]);
      Result := '';
      Exit;
    end;
  end;
end;

function TIntInventariosAnimais.TransmitirInventario(SoapSisbov: TIntSoapSisbov;
  CpfProdutor, CnpjProdutor: String; CodPropriedadeRural, CodIdPropriedadeSisbov: Integer;
  Codigos: String): Integer;
{const
  NomeMetodo: String = 'TransmitirInventario';
var
  Q : THerdomQuery;
  RetornoSolicitacaoInventario : RetornoIncluirAnimalNaoInventariado;
  MsgLogRetorno, MsgRet, Cod : String;
  I, IdTransacao: Integer;
  DtaSistema: TDateTime;
  CodP, CodE, CodM, CodA, Dig: Integer;
  RetornaErroGeral: Boolean;}
begin
  raise Exception.Create('De acordo com a documentação e atualização da WebService de 04/04/2008, o método "TransmitirInventario" não está mais disponível.');

{  Result := 0;
  MsgLogRetorno := '';
  MsgRet := '';
  RetornaErroGeral := false;
//  RetornoSolicitacaoInventario := nil;
//  CodP := -1;
//  CodE := -1;
//  CodM := -1;
//  CodA := -1;
//  Dig := -1;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Antes de tentar transmitir, limpa o status de transmissão e a mensagem de todos os animais
      // e da efetivacao
//      Q.SQL.Clear;
//      Q.SQL.Add('update tab_efetivacao_inventario ');
//      Q.SQL.Add('   set txt_mensagem_erro = null ');
//      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
//      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
//      Q.ExecSQL;

//      Q.SQL.Clear;
//      Q.SQL.Add('update tab_inventario_animal ');
//      Q.SQL.Add('   set ind_transmissao_sisbov = ''N'', ');
//      Q.SQL.Add('   set txt_mensagem_erro = null ');
//      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
//      Q.SQL.Add('   and ind_transmissao_sisbov <> ''S'' ');
//      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
//      Q.ExecSQL;

      DtaSistema := Conexao.DtaSistema;

      try
        // Invoca o método SOAP
        RetornoSolicitacaoInventario := SoapSisbov.incluirAnimalNaoInventariado(Descriptografar(ValorParametro(118)),  // usuário
                                              Descriptografar(ValorParametro(119)),  // senha
                                              CpfProdutor, // Cpf produtor
                                              CnpjProdutor, // Cnpj Produtor
                                              CodIdPropriedadeSisbov, // id da propriedade
                                              Codigos //numeros sisbov
                                               );

        If RetornoSolicitacaoInventario <> nil then Begin
          // Trata retorno do método
          IdTransacao := RetornoSolicitacaoInventario.idTransacao;

          Cod := Codigos;
          if Copy(Cod, 1, 3) <> '105' then begin
            Cod := Copy(MsgRet, Length(MsgRet) - 14, 15);
          end;
          if Copy(Cod, 1, 3) = '105' then begin
            Try
              CodP := StrToInt(Copy(Trim(Cod), 1, 3));
              CodE := StrToInt(Copy(Trim(Cod), 4, 2));
              if Length(Cod) = 15 then begin
                CodM := -1;
                CodA := StrToInt(Copy(Trim(Cod), 6, 9));
                Dig  := StrToInt(Copy(Trim(Cod), 15, 1));
              end else begin
                CodM := StrToInt(Copy(Trim(Cod), 6, 2));
                CodA := StrToInt(Copy(Trim(Cod), 8, 9));
                Dig  := StrToInt(Copy(Trim(Cod), 17, 1));
              end;
            Except
              CodP := -1;
              CodE := -1;
              CodM := -1;
              CodA := -1;
              Dig := -1;
            End;
          End Else Begin
            MsgLogRetorno := MsgLogRetorno + MsgRet + ' <BR> ';

            CodP := -1;
            CodE := -1;
            CodM := -1;
            CodA := -1;
            Dig := -1;
          End;

          // Abre transação no banco
          Begintran;

          // Se status = 0 então houve erro sendo assim atualiza a tabela de inventário de animais
          // baseado na lista de erros
          If RetornoSolicitacaoInventario.status = 0 then Begin
            // Comando de update que será utilizado para atualização
            Q.SQL.Clear;
            Q.SQL.Add('update tab_inventario_animal ');
            Q.SQL.Add('   set ind_transmissao_sisbov = ''E'', ');
            Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
            Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
            Q.SQL.Add('   and cod_pais_sisbov = :cod_pais_sisbov ');
            Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
            Q.SQL.Add('	  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
            Q.SQL.Add('	  and cod_animal_sisbov = :cod_animal_sisbov ');
            Q.SQL.Add('	  and num_dv_sisbov = :num_dv_sisbov ');

            // Atualiza cada animal com erro
            For I := 0 to length(RetornoSolicitacaoInventario.listaErros) - 1 do begin
              // Obter codigo sisbov a partir da mensagem de erro
//              if length(RetornoSolicitacaoInventario.listaErros[I].valorInformado) > 0 then begin
                MsgRet := MsgRet + ' ' + RetornoSolicitacaoInventario.listaErros[I].menssagemErro + ' ' +
                          RetornoSolicitacaoInventario.erroBanco + ' - ' + Codigos;  // + ' ' +
//                          RetornoSolicitacaoInventario.listaErros[0].valorInformado[0];
//              End Else Begin
//                MsgRet := MsgRet + ' ' + RetornoSolicitacaoInventario.listaErros[I].menssagemErro + ' ' +
//                          RetornoSolicitacaoInventario.erroBanco;
//              End;

                if (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '10.011') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '10.010') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '7.005') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '7.006') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '7.007') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '7.008') or
                   (RetornoSolicitacaoInventario.listaErros[I].codigoErro = '2.053') then begin
                  RetornaErroGeral := True;
                end;
            End;

            // Efetuar atualização
            Q.ParamByName('txt_mensagem_erro').AsString := Copy(TrimRight(MsgRet), 1, 250);
            Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
            Q.ParamByName('cod_pais_sisbov').AsInteger := CodP;
            Q.ParamByName('cod_estado_sisbov').AsInteger := CodE;
            Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodM;
            Q.ParamByName('cod_animal_sisbov').AsInteger := CodA;
            Q.ParamByName('num_dv_sisbov').AsInteger := Dig;
            Q.ExecSQL;


            // Atualiza o cadastro de inventários efetivados
            Q.SQL.Clear;
            Q.SQL.Add('update tab_efetivacao_inventario ');
            Q.SQL.Add('   set cod_usuario_transacao = :cod_usuario_transacao, ');
            Q.SQL.Add('       dta_transacao_sisbov = :dta_transacao_sisbov, ');
            Q.SQL.Add('       cod_id_transacao_sisbov = :cod_id_transacao_sisbov, ');
            Q.SQL.Add('       ind_transmissao_sisbov = ''E'' ');

            // Caso tenha uma mensagem de erro que não esteja relacionado a algum animal
            // grava a mensagem de erro na tabela tab_efetivacao_inventario
//            if (Length(MsgLogRetorno) > 0) and (CodP = -1) and (CodE = -1) and (CodM = -1) and (CodA = -1) and (Dig = -1) then begin
//              Q.SQL.Add('       ind_transmissao_tarefa = ''N'', ');
//              Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
//            end else begin
//              Q.SQL.Add('       ind_transmissao_tarefa = ''N'' ');
//            end;

            Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
            Q.ParamByName('cod_usuario_transacao').AsInteger := Conexao.CodUsuario;
            Q.ParamByName('dta_transacao_sisbov').AsDateTime := DtaSistema;
            Q.ParamByName('cod_id_transacao_sisbov').AsInteger := IdTransacao;
            Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

            if (Length(MsgLogRetorno) > 0) and (CodP = -1) and (CodE = -1) and (CodM = -1) and (CodA = -1) and (Dig = -1) then begin
              Q.ParamByName('txt_mensagem_erro').AsString := Copy(TrimRight(MsgLogRetorno), 1, 4000);
            end;

            Q.ExecSQL;

            if RetornaErroGeral then begin
              Result := -2;
            end else begin
              Result := -1;
            end;

          End else Begin
            // Atualiza o cadastro de inventários efetivados
//            Q.SQL.Clear;
//            Q.SQL.Add('update tab_efetivacao_inventario ');
//            Q.SQL.Add('   set cod_usuario_transacao = :cod_usuario_transacao, ');
//            Q.SQL.Add('       dta_transacao_sisbov = :dta_transacao_sisbov, ');
//            Q.SQL.Add('       cod_id_transacao_sisbov = :cod_id_transacao_sisbov, ');
//            Q.SQL.Add('       ind_transmissao_sisbov = ''S'' ');
//            Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
//            Q.ParamByName('cod_usuario_transacao').AsInteger := Conexao.CodUsuario;
//            Q.ParamByName('dta_transacao_sisbov').AsDateTime := DtaSistema;
//            Q.ParamByName('cod_id_transacao_sisbov').AsInteger := IdTransacao;
//            Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
//            Q.ExecSQL;

            // Se não houve erro então atualiza todos os registros com 'S' no ind_transmissao_sisbov
            Q.SQL.Clear;
            Q.SQL.Add('update tab_inventario_animal ');
            Q.SQL.Add('   set ind_transmissao_sisbov = ''S'', ');
            Q.SQL.Add('       txt_mensagem_erro = null ');
            Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
            Q.SQL.Add('   and cod_pais_sisbov = :cod_pais_sisbov ');
            Q.SQL.Add('   and cod_estado_sisbov = :cod_estado_sisbov ');
            Q.SQL.Add('	  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
            Q.SQL.Add('	  and cod_animal_sisbov = :cod_animal_sisbov ');
            Q.SQL.Add('	  and num_dv_sisbov = :num_dv_sisbov ');

            Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
            Q.ParamByName('cod_pais_sisbov').AsInteger := CodP;
            Q.ParamByName('cod_estado_sisbov').AsInteger := CodE;
            Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodM;
            Q.ParamByName('cod_animal_sisbov').AsInteger := CodA;
            Q.ParamByName('num_dv_sisbov').AsInteger := Dig;
            Q.ExecSQL;
          End;

          // Confirma transação no banco
          Commit;
        end else begin
          Rollback;
          GravaErroInventarioPropriedade(CodPropriedadeRural, 'Não foi retornada resposta do SISBOV', 0, DtaSistema);
          Result := -2;
        end;
      Except
        Rollback;
        GravaErroInventarioPropriedade(CodPropriedadeRural, 'Não foi retornada resposta do SISBOV', 0, DtaSistema);
        Result := -2;
      end;

    Except
      On E: Exception do Begin
        Rollback;
        if GravaErroInventarioPropriedade(CodPropriedadeRural, 'Erro na transmissão agendada. Mensagem retornada: ' + E.Message, 0, Conexao.DtaSistema) = 0 then begin
          Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -2326;
        end;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
  }
end;

function TIntInventariosAnimais.GravaErroInventarioProdutor(CodPessoaProdutor, CodPropriedadeRural: Integer; TxtMensagemErro: String;
      CodIdTransacaoSisbov: Integer; DtaTransacaoSisbov: TDateTime): Integer;
const
  NomeMetodo: String = 'GravaErroInventarioProdutor';
var
  Q : THerdomQuery;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Atualiza mensagem de erro dos animais
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_inventario_animal');
      Q.SQL.Add('   set ind_transmissao_sisbov = ''E'', ');
      Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('txt_mensagem_erro').AsString := TxtMensagemErro;
      Q.ExecSQL;

      // Atualiza status da efetivação
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_efetivacao_inventario');
      Q.SQL.Add('   set ind_transmissao_sisbov = ''E'', ');
      Q.SQL.Add('       ind_transmissao_tarefa = ''N'', ');
      Q.SQL.Add('       cod_id_transacao_sisbov = :cod_id_transacao_sisbov, ');
      Q.SQL.Add('       dta_transacao_sisbov = :dta_transacao_sisbov, ');
      Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      if CodIdTransacaoSisbov > 0 then begin
        Q.ParamByName('cod_id_transacao_sisbov').AsInteger := CodIdTransacaoSisbov;
      end else begin
        Q.ParamByName('cod_id_transacao_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_id_transacao_sisbov').Clear;
      end;
      if DtaTransacaoSisbov > 0 then begin
        Q.ParamByName('dta_transacao_sisbov').AsDateTime := DtaTransacaoSisbov;
      end else begin
        Q.ParamByName('dta_transacao_sisbov').DataType := ftDateTime;
        Q.ParamByName('dta_transacao_sisbov').Clear;
      end;
      Q.ParamByName('txt_mensagem_erro').AsString := TxtMensagemErro;
      Q.ExecSQL;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2326;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

{function TIntInventariosAnimais.GravaErroInventarioPropriedade(
  CodPropriedadeRural: Integer; TxtMensagemErro: String;
  CodIdTransacaoSisbov: Integer; DtaTransacaoSisbov: TDateTime): Integer;
const
  NomeMetodo: String = 'GravaErroInventarioPropriedade';
var
  Q : THerdomQuery;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Atualiza status da efetivação
      Q.SQL.Clear;
      Q.SQL.Add('update tab_efetivacao_inventario');
      Q.SQL.Add('   set ind_transmissao_sisbov = ''E'', ');
      Q.SQL.Add('       ind_transmissao_tarefa = ''N'', ');
      Q.SQL.Add('       cod_id_transacao_sisbov = :cod_id_transacao_sisbov, ');
      Q.SQL.Add('       dta_transacao_sisbov = :dta_transacao_sisbov, ');
      Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      if CodIdTransacaoSisbov > 0 then begin
        Q.ParamByName('cod_id_transacao_sisbov').AsInteger := CodIdTransacaoSisbov;
      end else begin
        Q.ParamByName('cod_id_transacao_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_id_transacao_sisbov').Clear;
      end;
      if DtaTransacaoSisbov > 0 then begin
        Q.ParamByName('dta_transacao_sisbov').AsDateTime := DtaTransacaoSisbov;
      end else begin
        Q.ParamByName('dta_transacao_sisbov').DataType := ftDateTime;
        Q.ParamByName('dta_transacao_sisbov').Clear;
      end;
      Q.ParamByName('txt_mensagem_erro').AsString := TxtMensagemErro;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2326;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
}
function TIntInventariosAnimais.MarcarInventarioComoTarefa(
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'MarcarInventarioComoTarefa';
var
  Q : THerdomQuery;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

{$IFDEF MSSQL}
      Q.SQL.Add('update tab_efetivacao_inventario ');
      Q.SQL.Add('   set ind_transmissao_sisbov = ''A'', ');
      Q.SQL.Add('       ind_transmissao_tarefa = ''S'', ' );
      Q.SQL.Add('       txt_mensagem_erro = null ' );
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2326;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.TransmitirAgendados: Integer;
const
  NomeMetodo: String = 'TransmitirAgendados';
var
  Q, Qu : THerdomQuery;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  Codigos: String;
//  CodPropriedade, QtdCodigos, CodIDPropriedade, I, CodProd, CodProp: Integer;
  CodIDPropriedade, CodProd, CodProp: Integer;
  CpfProdutor, CnpjProdutor: String;
  MudaPropriedade : Boolean;
//  RetornoConsultarInventario : RetornoConsultarInventarioAnimal;
//  TmpDecimalSeparator: Char;
  ErroInventario : String;
begin
  Result := 0;
  ErroInventario := 'N';

  // Query para leitura dos registros de inventário efetivados, marcados para transmissão por agendamento
  // ainda não transmitidos
  Q := THerdomQuery.Create(Conexao, nil);
  Qu := THerdomQuery.Create(Conexao, nil);
  // Cria classe de conexão SOAP
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    // Conexão SOAP
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado:= SoapSisbov.conectado('InventariosAnimais');


    if Conectado then begin
      // Verifica se existe algum registro com ind_transmissao_sisbov = 'P', o que significaria que já existe
      // alguma thread sendo executada para esta certificadora, então neste caso não faz nada, pois só poderá
      // existir uma thread ativa por certificadora
      Q.SQL.Clear;
    {$IFDEF MSSQL}
      Q.SQL.Add('select count(*) ');
      Q.SQL.Add('  from tab_efetivacao_inventario ');
      Q.SQL.Add(' where ind_transmissao_sisbov = ''P'' ');
    {$ENDIF}
      Q.Open;
      if (Q.Fields[0].AsInteger > 0) then begin
 {       CodPropriedade := Q.FieldByName('cod_propriedade_rural').AsInteger;

        if Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0 then begin
          RetornoConsultarInventario := SoapSisbov.consultarInventarioAnimais(Descriptografar(ValorParametro(118)),  // usuário
                                                Descriptografar(ValorParametro(119)),  // senha
                                                Q.FieldByName('cod_id_propriedade_sisbov').AsInteger,  // id propriedade
                                                );

          If RetornoConsultarInventario <> nil then Begin
            If RetornoConsultarInventario.status = 1 then Begin
              Q.SQL.Add('update tab_efetivacao_inventario ');
              Q.SQL.Add('   set val_percentual_processado = :PercentualProcessado  ');
              Q.SQL.Add(' where ind_transmissao_sisbov = ''P'' ');
              Q.SQL.Add('  and  cod_propriedade_rural = :cod_propriedade_rural ');

              TmpDecimalSeparator := DecimalSeparator;
              DecimalSeparator := ',';
              Q.ParamByName('PercentualProcessado').AsInteger  := Trunc(StrToFloat(Trim(RetornoConsultarInventario.percentagem)));
              DecimalSeparator := TmpDecimalSeparator;
              Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;

              Q.ExecSQL;
            End;
          End;
        End;
}
        Result := 1;
        Exit;
      end;
      Q.Close;
    end;

    Try
      if Conectado then begin
        // Marca inventários que serão transmitidos via tarefa para que não sejam utilizados
        // por outra thread

        Qu.SQL.Clear;
{$IFDEF MSSQL}
        Qu.SQL.Add('update tab_efetivacao_inventario ');
        Qu.SQL.Add('   set ind_transmissao_sisbov = ''P'' , ');
        Qu.SQL.Add('       txt_mensagem_erro = null  ');
        Qu.SQL.Add(' where ind_transmissao_sisbov = ''A'' ');
        Qu.SQL.Add('   and ind_transmissao_tarefa = ''S'' ');
{$ENDIF}
        {TODO: Verificar se a transação aberta e fechada neste ponto seria a melhor estratégia}
        Conexao.beginTran;
        Qu.ExecSQL;
        Conexao.Commit;

        // Query para leitura dos registros ainda não transmitidos ou com erro na última transmissão
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select tei.cod_pessoa_produtor, ');
        Q.SQL.Add('       tei.cod_propriedade_rural, ');
        Q.SQL.Add('       case tps.cod_natureza_pessoa ');
        Q.SQL.Add('         when ''F'' then tps.num_cnpj_cpf ');
        Q.SQL.Add('       else ');
        Q.SQL.Add('         '''' ');
        Q.SQL.Add('       end as num_cpf_produtor, ');
        Q.SQL.Add('       case tps.cod_natureza_pessoa ');
        Q.SQL.Add('         when ''J'' then tps.num_cnpj_cpf ');
        Q.SQL.Add('       else ');
        Q.SQL.Add('         '''' ');
        Q.SQL.Add('       end as num_cnpj_produtor, ');
        Q.SQL.Add('       tpr.cod_id_propriedade_sisbov, ');
        Q.SQL.Add('       convert(char(3), tia.cod_pais_sisbov) + ');
        Q.SQL.Add('         right(''00'' + convert(varchar(2), tia.cod_estado_sisbov), 2) + ');
        Q.SQL.Add('         case tia.cod_micro_regiao_sisbov ');
        Q.SQL.Add('           when  0 then ''00'' ');
        Q.SQL.Add('           when -1 then '''' ');
        Q.SQL.Add('           else ');
        Q.SQL.Add('             right(''00'' + convert(varchar(2), tia.cod_micro_regiao_sisbov), 2) ');
        Q.SQL.Add('           end + ');
        Q.SQL.Add('         right(''000000000'' + convert(varchar(9), tia.cod_animal_sisbov), 9) + ');
        Q.SQL.Add('         convert(varchar(1), tia.num_dv_sisbov) as CodSisbovEnvio, ');
        Q.SQL.Add('       tia.cod_pais_sisbov, ');
        Q.SQL.Add('       tia.cod_estado_sisbov, ');
        Q.SQL.Add('       tia.cod_micro_regiao_sisbov, ');
        Q.SQL.Add('       tia.cod_animal_sisbov, ');
        Q.SQL.Add('       tia.num_dv_sisbov ');
        Q.SQL.Add('  from tab_inventario_animal tia, ');
        Q.SQL.Add('       tab_efetivacao_inventario tei, ');
        Q.SQL.Add('       tab_produtor tp, ');
        Q.SQL.Add('       tab_pessoa tps, ');
        Q.SQL.Add('       tab_propriedade_rural tpr ');
        Q.SQL.Add(' where tei.cod_pessoa_produtor = tia.cod_pessoa_produtor ');
        Q.SQL.Add('   and tei.cod_propriedade_rural = tia.cod_propriedade_rural ');
        Q.SQL.Add('   and tp.cod_pessoa_produtor = tia.cod_pessoa_produtor ');
        Q.SQL.Add('   and tia.ind_transmissao_sisbov <> ''S'' ');
        Q.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
        Q.SQL.Add('   and tpr.cod_propriedade_rural = tia.cod_propriedade_rural ');
//          Q.SQL.Add('   and tei.ind_transmissao_sisbov in (''N'', ''A'') ');
        Q.SQL.Add('   and tei.ind_transmissao_sisbov = ''P'' ');
        Q.SQL.Add('   and tei.ind_transmissao_tarefa = ''S'' ');
        Q.SQL.Add(' order by tei.dta_efetivacao_sisbov, ');
        Q.SQL.Add('          tei.cod_propriedade_rural, ');
        Q.SQL.Add('          tei.cod_pessoa_produtor ');

{$ENDIF}
        Q.Open;
        If Q.IsEmpty Then Begin
          Result := 0;
          Exit;
        End;

//        I := 0;

        // Varre todos os registros
//        Efetivado := False;
        CodProp := 0;
        CodProd := 0;

        while not Q.Eof do begin
          CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
          CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
          CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
          MudaPropriedade  := False;

          if (CodProp <> Q.FieldByName('cod_propriedade_rural').AsInteger) or
             (CodProd <> Q.FieldByName('cod_pessoa_produtor').AsInteger)   then begin

            if (ErroInventario = 'N') and (CodProp > 0) then begin
                // Atualiza o cadastro de inventários efetivados
                Qu.SQL.Clear;
            {$IFDEF MSSQL}
                Qu.SQL.Add('update tab_efetivacao_inventario ');
                Qu.SQL.Add('   set ind_transmissao_sisbov = ''S'' ');
                Qu.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
                Qu.SQL.Add('   and cod_pessoa_produtor   = :cod_pessoa_produtor ');
            {$ENDIF}
                Qu.ParamByName('cod_propriedade_rural').AsInteger := CodProp;
                Qu.ParamByName('cod_pessoa_produtor').AsInteger := CodProd;
                Conexao.beginTran;
                Qu.ExecSQL;
                Conexao.Commit;

            end else begin
              ErroInventario := 'N';
            end;

            CodProp       := Q.FieldByName('cod_propriedade_rural').AsInteger;
            CodProd       := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          end;


          // Verifica se todos os produtores da propriedade efetivaram o inventário
{          Result := InventariosDaPropriedadeEfetivados(Q.FieldByName('cod_propriedade_rural').AsInteger, Efetivado);
          if Result < 0 then begin
            Exit;
          end;

          // Se um dos produtores da propriedade não efetivaram, grava "erro" na tab_efetivacao_inventario
          // para os produtores que efetivaram, e ignora registros até a próxima propriedade
          if not Efetivado then begin
            // Grava mensagem de erro nos animais do produtor
            Result := GravaErroInventarioProdutor(CodProd, CodProp, 'Existem um ou mais produtores da propriedade que ainda não efetivaram o inventario dos animais. Só é possível a transmissão quando todos os produtores da propriedade efetivarem o inventário.', 0, Conexao.DtaSistema);
            if Result < 0 then begin
              Exit;
            end;

            // Ignora inventários até o próximo produtor/propriedade
            while (Q.FieldByName('cod_pessoa_produtor').AsInteger = CodProd) and (Q.FieldByName('cod_propriedade_rural').AsInteger = CodProp) and not Q.Eof do begin
              Q.Next;
            end;

            // Se chegou ao fim da query então finaliza o loop
            if Q.Eof then Break;

            CodProd          := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            CodProp          := Q.FieldByName('cod_propriedade_rural').AsInteger;
            CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
            CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
            CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
            Continue;
          end;
}
//          if (Q.FieldByName('cod_propriedade_rural').AsInteger = CodProp) then begin
//            SetLength(Codigos, I + 1);
//            Codigos[I] := Q.FieldByName('CodSisbovEnvio').AsString;
//            Inc(I);
//          end else begin
//            QtdCodigos := I;

            Codigos := Q.FieldByName('CodSisbovEnvio').AsString;
            Result := TransmitirInventario(SoapSisbov,
                                           CpfProdutor,
                                           CnpjProdutor,
                                           CodProp,
                                           CodIDPropriedade,
                                           Codigos);

            if Result = -2 then begin
              while not eof do begin
                if CodProp <> Q.FieldByName('cod_propriedade_rural').AsInteger then begin
                  MudaPropriedade := True;
                  break;
                end;

                Q.Next;
              end;

              // Atualiza o cadastro de inventários efetivados
              Qu.SQL.Clear;
          {$IFDEF MSSQL}
              Qu.SQL.Add('update tab_efetivacao_inventario ');
              Qu.SQL.Add('   set ind_transmissao_sisbov = ''E'' ');
              Qu.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
          {$ENDIF}
              Qu.ParamByName('cod_propriedade_rural').AsInteger := CodProp;
              Conexao.beginTran;
              Qu.ExecSQL;
              Conexao.Commit;

              CodProp        := Q.FieldByName('cod_propriedade_rural').AsInteger;
              ErroInventario := 'S';

            end else if Result = -1 then begin
              if ErroInventario = 'N' then begin
                // Atualiza o cadastro de inventários efetivados
                Qu.SQL.Clear;
            {$IFDEF MSSQL}
                Qu.SQL.Add('update tab_efetivacao_inventario ');
                Qu.SQL.Add('   set ind_transmissao_sisbov = ''E'' ');
                Qu.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
                Qu.SQL.Add('   and cod_pessoa_produtor   = :cod_pessoa_produtor ');
            {$ENDIF}
                Qu.ParamByName('cod_propriedade_rural').AsInteger := CodProp;
                Qu.ParamByName('cod_pessoa_produtor').AsInteger   := CodProd;
                Conexao.beginTran;
                Qu.ExecSQL;
                Conexao.Commit;

                ErroInventario := 'S';
              end;

            end else if Result < -2 then begin
              // Atualiza o cadastro de inventários efetivados
              Qu.SQL.Clear;
          {$IFDEF MSSQL}
              Qu.SQL.Add('update tab_efetivacao_inventario ');
              Qu.SQL.Add('   set ind_transmissao_sisbov = ''E'' ');
              Qu.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
              Qu.SQL.Add('   and cod_pessoa_produtor   = :cod_pessoa_produtor ');
          {$ENDIF}
              Qu.ParamByName('cod_propriedade_rural').AsInteger := CodProp;
              Qu.ParamByName('cod_pessoa_produtor').AsInteger   := CodProd;
              Conexao.beginTran;
              Qu.ExecSQL;
              Conexao.Commit;

              ErroInventario := 'S';
              Exit;
            end;

//            QtdCodigos := I;
//            I := 0;
//            CodProd          := Q.FieldByName('cod_pessoa_produtor').AsInteger;
//            CodProp          := Q.FieldByName('cod_propriedade_rural').AsInteger;
//            CpfProdutor      := Q.FieldByName('num_cpf_produtor').AsString;
//            CnpjProdutor     := Q.FieldByName('num_cnpj_produtor').AsString;
//            CodIDPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;

//            SetLength(Codigos, 0);
//            Continue;
//          end;

          if not MudaPropriedade then begin
            Q.Next;
          end;
        end;  // while

        if ErroInventario = 'N' then begin
            // Atualiza o cadastro de inventários efetivados
            Qu.SQL.Clear;
        {$IFDEF MSSQL}
            Qu.SQL.Add('update tab_efetivacao_inventario ');
            Qu.SQL.Add('   set ind_transmissao_sisbov = ''S'' ');
            Qu.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
            Qu.SQL.Add('   and cod_pessoa_produtor   = :cod_pessoa_produtor ');
        {$ENDIF}
            Qu.ParamByName('cod_propriedade_rural').AsInteger := CodProp;
            Qu.ParamByName('cod_pessoa_produtor').AsInteger := CodProd;
            Conexao.beginTran;
            Qu.ExecSQL;
            Conexao.Commit;
        end else begin
          // Marca inventários que tentou-se transmitir via tarefa para que possam ser retransmitidos
          // por outra thread

          Q.SQL.Clear;
  {$IFDEF MSSQL}
          Q.SQL.Add('update tab_efetivacao_inventario ');
          Q.SQL.Add('   set ind_transmissao_sisbov = ''A'' , ');
          Q.SQL.Add('       txt_mensagem_erro = null  ');
          Q.SQL.Add(' where ind_transmissao_sisbov = ''P'' ');
          Q.SQL.Add('   and ind_transmissao_tarefa = ''S'' ');
  {$ENDIF}
          {TODO: Verificar se a transação aberta e fechada neste ponto seria a melhor estratégia}
          Conexao.beginTran;
          Q.ExecSQL;
          Conexao.Commit;
        end;

        // Transmite o último lote de animais já que no fim da query não será encontrada
        // uma "quebra" de propriedade
//        if Efetivado then begin
//          QtdCodigos := I;
//          Result := TransmitirInventario(SoapSisbov,
//                                         CpfProdutor,
//                                         CnpjProdutor,
//                                         CodProp,
//                                         CodIDPropriedade,
//                                         Codigos);
//
//          if Result < 0 then begin
//            exit;
//          end;
//        end;

        Q.Close;
        Qu.Close;
      end;  // if not conectado

      Result := 0;
    Except
      On E: Exception do Begin
        // Marca inventários que tentou-se transmitir via tarefa para que possam ser retransmitidos
        // por outra thread

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_efetivacao_inventario ');
        Q.SQL.Add('   set ind_transmissao_sisbov = ''A'' , ');
        Q.SQL.Add('       txt_mensagem_erro = null  ');
        Q.SQL.Add(' where ind_transmissao_sisbov = ''P'' ');
        Q.SQL.Add('   and ind_transmissao_tarefa = ''S'' ');
{$ENDIF}
        {TODO: Verificar se a transação aberta e fechada neste ponto seria a melhor estratégia}
        Conexao.beginTran;
        Q.ExecSQL;
        Conexao.Commit;


//        Rollback;
        if GravaErroInventarioTransmitindo('Erro ao transmitir inventário agendado. Mensagem retornada: ' + E.Message, Conexao.DtaSistema) = 0 then begin
          Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -2326;
        end;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    Qu.Free;
    SoapSisbov.Free;
  End;
end;

function TIntInventariosAnimais.ExcluirAnimalErro(CodPessoaProdutor,
                      CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'ExcluirAnimalErro';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
  {$IFDEF MSSQL}
      Q.SQL.Add('select tia.cod_pessoa_produtor, ');
      Q.SQL.Add('       tia.cod_propriedade_rural, ');
      Q.SQL.Add('       tia.cod_pais_sisbov, ');
      Q.SQL.Add('       tia.cod_estado_sisbov, ');
      Q.SQL.Add('       tia.cod_micro_regiao_sisbov, ');
      Q.SQL.Add('       tia.cod_animal_sisbov, ');
      Q.SQL.Add('       tia.num_dv_sisbov ');
      Q.SQL.Add('  from tab_inventario_animal tia, ');
      Q.SQL.Add('       tab_produtor tp, ');
      Q.SQL.Add('       tab_propriedade_rural tpr ');
      Q.SQL.Add(' where tia.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tia.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and tia.ind_transmissao_sisbov  = ''E'' ');
      Q.SQL.Add('   and tia.txt_mensagem_erro is not null ');
  {$ENDIF}

      Q.ParamByName('cod_pessoa_produtor').AsInteger   := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

      Q.Open;
      If Q.IsEmpty Then Begin
        Result := 0;
        Exit;
      End;

      while not Q.Eof do begin
        Result := ExcluirInventario(Q.FieldByName('cod_pais_sisbov').AsInteger
                                  , Q.FieldByName('cod_estado_sisbov').AsInteger
                                  , Q.FieldByName('cod_micro_regiao_sisbov').AsInteger
                                  , Q.FieldByName('cod_animal_sisbov').AsInteger
                                  , Q.FieldByName('num_dv_sisbov').AsInteger
                                  , 0, CodPessoaProdutor, CodPropriedadeRural, false);
        Q.Next;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2323, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2323;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosAnimais.GravaErroInventarioTransmitindo(
  TxtMensagemErro: String; DtaTransacaoSisbov: TDateTime): Integer;
const
  NomeMetodo: String = 'GravaErroInventarioTransmitindo';
var
  Q : THerdomQuery;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Atualiza status da efetivação
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_efetivacao_inventario');
      Q.SQL.Add('   set ind_transmissao_sisbov = ''E'', ');
      Q.SQL.Add('       ind_transmissao_tarefa = ''N'', ');
      Q.SQL.Add('       dta_transacao_sisbov = :dta_transacao_sisbov, ');
      Q.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
      Q.SQL.Add(' where ind_transmissao_sisbov = ''P'' ');
{$ENDIF}
      if DtaTransacaoSisbov > 0 then begin
        Q.ParamByName('dta_transacao_sisbov').AsDateTime := DtaTransacaoSisbov;
      end else begin
        Q.ParamByName('dta_transacao_sisbov').DataType := ftDateTime;
        Q.ParamByName('dta_transacao_sisbov').Clear;
      end;
      Q.ParamByName('txt_mensagem_erro').AsString := TxtMensagemErro;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2326, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2326;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.
