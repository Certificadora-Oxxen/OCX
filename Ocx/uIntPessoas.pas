// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 17/07/2002
// *  Descrição Resumida : Cadastro de Pessoas
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *   Hitalo    17/07/2002  Alterar o NumCNPJCPF,Nom Pessoa adcionando
// *                         Like no Método Pesquisar
// *   Arley     20/07/2002  Inclusão de novos procedimentos
// *                         (Inserir, Altera, Excluir, Buscar,
// *                          AdicionarPapel, RetirarPapel, PossuiPapel,
// *                          EfetivarCadastro, CancelarEfetivacao,
// *                          MarcarNaoGravadoSisbov, Definirendereco)
// *   Carlos    03/12/2002   Definição dos métodos DefinirIdadesPadraoProdutor
// *                          DefinirIdadesPadraoAssociacao
// *   Carlos    03/12/2002   Acrescentar os parâmetros CodTipoAgrupamentoRacas,
// *                          e QtdDenominadorCompRacial no método DefinirParametrosProdutor
// ********************************************************************

unit uIntPessoas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uFerramentas, uIntPessoa,
     uColecoes, InvokeRegistry, Rio, WSSISBOV1, SOAPHTTPClient;

type
  { TParametrosPesagem }
  TParametrosPesagem = Record
    NumLimiteAjuste: Integer;
    NumLimiteEquivalencia: Integer;
    QtdIdadeMinimaPesagem : Integer;
    NumIdadePadrao1: Integer;
    NumIdadePadrao2: Integer;
    NumIdadePadrao3: Integer;
    NumIdadePadrao4: Integer;
    NumIdadePadrao5: Integer;
  end;

  { TIntPessoas }
  TIntPessoas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPessoa : TIntPessoa;
    function BuscarParametrosPessagemPadrao(
      var ParametrosPesagemPadrao: TParametrosPesagem): Integer;

  public
    constructor Create; override;
    destructor Destroy; override;

    function VerificaNumLetra(Valor: String;
                              Tamanho: Integer;
                              NomParametro: String): Integer;

    function Pesquisar(ECodPessoa: Integer;
                       ENomPessoa: String;
                       ECodPapel: Integer;
                       ECodNaturezaPessoa,
                       ENumCNPJCPF,
                       EIndBloqueio,
                       EIndIncluirCertificadoraDonaSistema: String;
                       EIndPesquisarDesativados: WordBool;
                       ESglProdutor,
                       ECodOrdenacao,
                       EIndCadastroEfetivado,
                       EIndExportadoSisbov,
                       ECodTipoAcessoNaoDesejado: String): Integer;

    function PesquisarAvancado(ECodPessoa: Integer;
                               ENomPessoa: String;
                               ECodPapel: Integer;
                               ECodNaturezaPessoa,
                               ENumCNPJCPF,
                               EIndBloqueio,
                               EIndIncluirCertificadoraDonaSistema: String;
                               EIndPesquisarDesativados: WordBool;
                               ESglProdutor,
                               ECodOrdenacao,
                               EIndCadastroEfetivado,
                               EIndExportadoSisbov,
                               ECodTipoAcessoNaoDesejado: String;
                               ECodEstado: Integer;
                               ENomMunicipio,
                               ECodMicroRegiao,
                               ENomLogradouro: String;
                               EDiaNascimentoInicio,
                               EMesNascimentoInicio,
                               EDiaNascimentoFim,
                               EMesNascimentoFim: Integer;
                               EIndRelatorio: Boolean;
                               EOrderBy: String): Integer;

    function Inserir(ENomPessoa,
                     ENomReduzidoPessoa,
                     ECodNaturezaPessoa,
                     ENumCNPJCPF: String;
                     EDtaNascimento: TDateTime;
                     ETxtObservacao: String;
                     ECodPapel: Integer;
                     ESglProdutor: String;
                     ECodGrauInstrucao: Integer;
                     EDesCursoSuperior,
                     ESglConselhoRegional,
                     ENumConselhoRegional: String;
                     ECodPessoaGestor: Integer;
                     ESexo: String;
                     ENumIE: String;
                     EOrgaoIE: String;
                     EUFIE: String;
                     EDtaExp: TDateTime): Integer;

    function Alterar(ECodPessoa: Integer;
                     ENomPessoa,
                     ENomReduzidoPessoa,
                     ENumCNPJCPF: String;
                     EDtaNascimento: TDateTime;
                     ETxtObservacao,
                     ESglProdutor: String;
                     ECodGrauInstrucao: Integer;
                     EDesCursoSuperior,
                     ESglConselhoRegional,
                     ENumConselhoRegional: String;
                     ECodPessoaGestor: Integer;
                     ESexo: String;
                     ENumIE: String;
                     EOrgaoIE: String;
                     EUFIE: String;
                     EDtaExp: TDateTime;
                     EIndTecnicoAtivo: String): Integer;
                     
    function Buscar(ECodPessoa: Integer): Integer;
    function Excluir(ECodPessoa: Integer): Integer;

    function AdicionarPapel(ECodPessoa,
                            ECodPapel: Integer;
                            ESglProdutor: String;
                            ECodGrauInstrucao: Integer;
                            EDesCursoSuperior,
                            ESglConselhoRegional,
                            ENumConselhoRegional: String;
                            ECodPessoaGestor: Integer;
                            EIndTecnicoAtivo: String): Integer;

    function RetirarPapel(CodPessoa, CodPapel: Integer): Integer;
    function PossuiPapel(CodPessoa, CodPapel: Integer): Integer;
    function EfetivarCadastro(CodPessoa: Integer): Integer;
    function CancelarEfetivacao(CodPessoa: Integer): Integer;
    function Definirendereco(CodPessoa, CodTipoendereco: Integer;
      NomLogradouro, NomBairro, NumCEP: String; CodPais,
      CodEstado, CodMunicipio, CodDistrito: Integer): Integer;

    function DefinirParametrosProdutor(EQtdCaracteres: Integer;
                                       EIndConsultaPublica: String;
                                       ECodTipoAgrupamentoRacas,
                                       EQtdDenominadorCompRacial,
                                       EQtdDiasEntreCoberturas,
                                       EQtdDiasDescansoReprodutivo,
                                       EQtdDiasDiagnosticoGestacao: Integer;
                                       ECodSituacaoSisBov: String;
                                       ECodAptidao: Integer;
                                       EIndMostrarNome,
                                       EIndMostrarIdentificadores,
                                       EIndTransfereEmbrioes,
                                       EIndMostrarFiltroCompRacial,
                                       EIndEstacaoMonta: String;
                                       EIndTrabalhaAssociacaoRaca: String;
                                       EQtdIdadeMinimaDesmame,
                                       EQtdIdadeMaximaDesmame: Integer;
                                       EIndAplicarDesmameAutomatico: String): Integer;

    function GerarRelatorio(CodPessoa: Integer; NomPessoa: String;
      CodPapel: Integer; CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
      IndIncluirCertificadoraDonaSistema: String;
      IndPesquisarDesativados: WordBool; SglProdutor, CodOrdenacao,
      IndCadastroEfetivado, IndExportadoSisbov,
      CodTipoAcessoNaoDesejado: String; CodEstado: Integer;
      NomMunicipio, CodMicroRegiao, NomLogradouro: String;
      DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
      MesNascimentoFim, Tipo, QtdQuebraRelatorio: Integer): String;
    function PesquisarPorPropriedadeRural(
      CodPropriedadeRural: Integer): Integer;
    function Limparendereco(CodPessoa: Integer): Integer;

    function PesquisarGestores(ECodPessoaGestor: Integer): Integer;

    function ExcluirComentario(CodPessoa, CodComentario: Integer): Integer;
    function InserirComentario(CodPessoa: Integer; TxtComentario: String): Integer;
    function PesquisarComentario(CodPessoa, CodComentario: Integer): Integer;

    /////////////////////////////
    // Métodos da carga inicial
    function InserirProdutorCargaInicial(CodArquivoExportacao: Integer;
      SglProdutor, NomPessoa, NaturezaPessoa, NumCNPJCPF, NomLogradouro,
      NomBairro, NumCEP, UFMunicipio, NomMunicipio: String): Integer;
    /////////////////////////////

    property IntPessoa: TIntPessoa read FIntPessoa write FIntPessoa;
  end;

implementation

uses SqlExpr, uIntRelatorios, uIntenderecos, uIntMensagens, uIntSoapSisbov;

{ TIntPessoas }

function TIntPessoas.BuscarParametrosPessagemPadrao(
  var ParametrosPesagemPadrao: TParametrosPesagem): Integer;
const
  NomeMetodo: String = 'BuscarParametrosPessagemPadrao';
var
  Q: THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Buscando parametros padrões do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text :=
        'select ' +
        '  tp1.val_parametro_sistema as NumLimiteEquivalencia ' +
        '  , tp2.val_parametro_sistema as NumLimiteAjuste ' +
        '  , tp3.val_parametro_sistema as NumIdadePadrao1 ' +
        '  , tp4.val_parametro_sistema as NumIdadePadrao2 ' +
        '  , tp5.val_parametro_sistema as NumIdadePadrao3 ' +
        '  , tp6.val_parametro_sistema as NumIdadePadrao4 ' +
        '  , tp7.val_parametro_sistema as NumIdadePadrao5 ' +
        '  , tp8.val_parametro_sistema as QtdIdadeMinimaPesagem ' +
        'from ' +
        '  tab_parametro_sistema tp1 ' +
        '  , tab_parametro_sistema tp2 ' +
        '  , tab_parametro_sistema tp3 ' +
        '  , tab_parametro_sistema tp4 ' +
        '  , tab_parametro_sistema tp5 ' +
        '  , tab_parametro_sistema tp6 ' +
        '  , tab_parametro_sistema tp7 ' +
        '  , tab_parametro_sistema tp8 ' +
        'where ' +
        '  tp1.cod_parametro_sistema = 27 ' + // Número padrao de dias para equivalência de idade
        '  and tp2.cod_parametro_sistema = 28 ' + // Número máximo de dias para ajuste de idade
        '  and tp3.cod_parametro_sistema = 29 ' + // Número idade padrao 1
        '  and tp4.cod_parametro_sistema = 30 ' + // Número idade padrao 2
        '  and tp5.cod_parametro_sistema = 31 ' + // Número idade padrao 3
        '  and tp6.cod_parametro_sistema = 32 ' + // Número idade padrao 4
        '  and tp7.cod_parametro_sistema = 33 ' + // Número idade padrao 5
        '  and tp8.cod_parametro_sistema = 46 '; // idade mínima para pesagem
{$ENDIF}
      Q.Open;
      // Consiste se os dados foram obtidos com êxito
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1170, Self.ClassName, NomeMetodo, []);
        Result := -1170;
        Exit;
      end;
      // Guarda os valores identificados
      ParametrosPesagemPadrao.NumLimiteAjuste       := Q.FieldByName('NumLimiteAjuste').AsInteger;
      ParametrosPesagemPadrao.NumLimiteEquivalencia := Q.FieldByName('NumLimiteEquivalencia').AsInteger;
      ParametrosPesagemPadrao.NumIdadePadrao1       := Q.FieldByName('NumIdadePadrao1').AsInteger;
      ParametrosPesagemPadrao.NumIdadePadrao2       := Q.FieldByName('NumIdadePadrao2').AsInteger;
      ParametrosPesagemPadrao.NumIdadePadrao3       := Q.FieldByName('NumIdadePadrao3').AsInteger;
      ParametrosPesagemPadrao.NumIdadePadrao4       := Q.FieldByName('NumIdadePadrao4').AsInteger;
      ParametrosPesagemPadrao.NumIdadePadrao5       := Q.FieldByName('NumIdadePadrao5').AsInteger;
      ParametrosPesagemPadrao.QtdIdadeMinimaPesagem := Q.FieldByName('QtdIdadeMinimaPesagem').AsInteger;
      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(1169, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1169;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntPessoas.VerificaNumLetra(Valor: String;
  Tamanho: Integer; NomParametro: String): Integer;
var
  X : Integer;
begin
  Result := 0;
  Valor := Trim(Valor);
  if Length(Valor) > Tamanho then begin
    Mensagens.Adicionar(537, Self.ClassName, 'VerificaNumLetra', [NomParametro, IntToStr(Tamanho)]);
    Result := -537;
    Exit;
  end;

  For X := 1 to Length(Valor) do begin
    if Pos(Copy(Valor, X, 1), '0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ') = 0 then begin
      Mensagens.Adicionar(538, Self.ClassName, 'VerificaNumLetra', [NomParametro]);
      Result := -538;
      Exit;
    end;
  end;
end;

function TIntPessoas.AdicionarPapel(ECodPessoa,
                                    ECodPapel: Integer;
                                    ESglProdutor: String;
                                    ECodGrauInstrucao: Integer;
                                    EDesCursoSuperior,
                                    ESglConselhoRegional,
                                    ENumConselhoRegional: String;
                                    ECodPessoaGestor: Integer;
                                    EIndTecnicoAtivo: String): Integer;
const
  Metodo: Integer = 203;
var
  Q: THerdomQuery;
  bNovo, bRevalidacao: Boolean;
  sCodNatureza, sIndConsultaPublica: String;
  QtdCaracteresCodManejo, CodRegistroLog: Integer;
  ParametrosPesagem: TParametrosPesagem;
  IndGestorObrigatorio: String;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('AdicionarPapel');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarPapel', []);
    Result := -188;
    Exit;
  end;

  if ((ECodGrauInstrucao > 0) or (EDesCursoSuperior <> '') or
      (ESglConselhoRegional <> '') or (ENumConselhoRegional <> '')) and
      (ECodPapel <> 3) then
  begin
    Mensagens.Adicionar(555, Self.ClassName, 'AdicionarPapel', []);
    Result := -555;
    Exit;
  end;

  if ECodPapel = 3 then begin {Técnico}
    // Trata Grau de instrução
    if (ECodGrauInstrucao <= 0) then begin
      Result := VerificaString('', 'Para o papel de "Técnico", o grau de instrução');
      if Result < 0 then Exit;
    end;
    // Trata Descrição do curso superior
    if EDesCursoSuperior <> '' then begin
      Result := TrataString(EDesCursoSuperior, 30, 'Descrição do Curso Superior');
      if Result < 0 then Exit;
    end;
    // Trata Sigla do conselho regional
    if ESglConselhoRegional <> '' then begin
      Result := TrataString(ESglConselhoRegional, 10, 'Sigla do Conselho Regional');
      if Result < 0 then Exit;
    end;
    // Trata Número conselho regional
    if ENumConselhoRegional <> '' then begin
      Result := TrataString(ENumConselhoRegional, 15, 'Número Conselho Regional');
      if Result < 0 then Exit;
    end;
  end else if ECodPapel = 4 then begin {Produtor}
    Result := VerificaString(ESglProdutor, 'Sigla do produtor');
    if Result < 0 then Exit;
    Result := VerificaNumLetra(ESglProdutor, 5, 'Sigla do Produtor');
    if Result < 0 then Exit;
  end;

  QtdCaracteresCodManejo := StrToInt(ValorParametro(7));

  if ECodPapel in [1, 4] then begin // (associação, produtor)
    // Para estes papéis, é necessário levantar os padrões de pesagem do sistema
    Result := BuscarParametrosPessagemPadrao(ParametrosPesagem);
    if Result < 0 then Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      if ECodPapel = 3 then begin {Técnico}
        // Trata Grau de instrução (verifica se é válido)
        if (ECodGrauInstrucao > 0) then begin
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_grau_instrucao');
          Q.SQL.Add(' where cod_grau_instrucao = :cod_grau_instrucao');
          Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          Q.ParamByName('cod_grau_instrucao').AsInteger := ECodGrauInstrucao;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(590, Self.ClassName, 'AdicionarPapel', []);
            Result := -590;
            Exit;
          end;
          Q.Close;
        end;
      end;

      sIndConsultaPublica := '';

      if ECodPapel = 4 then begin {Produtor}
        // Consiste se a sigla informada para o produtor é única na tabela
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_produtor');
        Q.SQL.Add(' where sgl_produtor = :sgl_produtor');
        Q.SQL.Add('   and cod_pessoa_produtor <> :cod_pessoa_produtor');
        Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoa;
        Q.ParamByName('sgl_produtor').AsString := ESglProdutor;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(721, Self.ClassName, 'AdicionarPapel', []);
          Result := -721;
          Exit;
        end;
        Q.Close;

        // Consiste se a sigla pode ser alterada
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select ind_efetivado_uma_vez, sgl_produtor from tab_produtor');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          if (Q.FieldByName('ind_efetivado_uma_vez').AsString = 'S') and (trim(Q.FieldByName('sgl_produtor').AsString) <> trim(ESglProdutor)) then begin
            Mensagens.Adicionar(722, Self.ClassName, 'AdicionarPapel', []);
            Result := -722;
            Exit;
          end;
        end;
        Q.Close;

        // Obtem valor padrão referente a consulta pública dos animais do produtor
        sIndConsultaPublica := ValorParametro(18);
      end;

      // Consiste Pessoa
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_natureza_pessoa from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'AdicionarPapel', []);
        Result := -212;
        Exit;
      end;
      sCodNatureza := Q.FieldByName('cod_natureza_pessoa').AsString;
      Q.Close;

      // Consiste Papel
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_natureza_pessoa from tab_papel');
      Q.SQL.Add(' where cod_papel = :cod_papel');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := ECodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(591, Self.ClassName, 'AdicionarPapel', []);
        Result := -591;
        Exit;
      end;
      // Consiste se o papel informado se aplica a natureza da pessoa
      if (Q.FieldByName('cod_natureza_pessoa').AsString <> 'A') and (Q.FieldByName('cod_natureza_pessoa').AsString <> sCodNatureza) then begin
        Mensagens.Adicionar(756, Self.ClassName, 'AdicionarPapel', []);
        Result := -756;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa já possui o papel informado.
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  cod_registro_log as CodRegistroLog');
      Q.SQL.Add('  , dta_fim_validade as DtaFimValidade');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa_papel');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_papel = :cod_papel');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger  := ECodPessoa;
      Q.ParamByName('cod_papel').AsInteger := ECodPapel;
      Q.Open;
      bNovo := Q.IsEmpty;
      bRevalidacao := not(Q.FieldByName('DtaFimValidade').IsNull);
      if not bNovo then begin
        CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
      end else begin
        CodRegistroLog := 0;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      if bNovo then begin

        // Pega próximo CodRegistroLog
        CodRegistroLog := ProximoCodRegistroLog;
        if CodRegistroLog < 0 then begin
          Rollback;
          Result := CodRegistroLog;
          Exit;
        end;

        //--------------------------------------------
        // Insere relacionamento com o papel informado
        //--------------------------------------------
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_pessoa_papel');
        Q.SQL.Add('  (cod_pessoa');
        Q.SQL.Add('   , cod_papel');
        Q.SQL.Add('   , cod_registro_log');
        Q.SQL.Add('   , dta_fim_validade)');
        Q.SQL.Add('values');
        Q.SQL.Add('  (:cod_pessoa');
        Q.SQL.Add('   , :cod_papel');
        Q.SQL.Add('   , :cod_registro_log');
        Q.SQL.Add('   , null)');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ParamByName('cod_papel').AsInteger := ECodPapel;
        Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_pessoa_papel', CodRegistroLog, 1, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

      end else if bRevalidacao then begin

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_pessoa_papel', CodRegistroLog, 6, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        //----------------------------------------------
        // Revalida relacionamento com o papel informado
        //----------------------------------------------
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_pessoa_papel');
        Q.SQL.Add('  set dta_fim_validade = null');
        Q.SQL.Add('  where');
        Q.SQL.Add('   cod_pessoa = :cod_pessoa');
        Q.SQL.Add('   and cod_papel = :cod_papel');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ParamByName('cod_papel').AsInteger := ECodPapel;
        Q.ExecSQL;

      end;

      //--------------------------------------------------------------------------
      // Insere/atualiza relacionamento da pessoa com a tabela de papel específica
      //--------------------------------------------------------------------------
      if ECodPapel = 1 then begin {Associação}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select dta_fim_validade as DtaFimValidade from tab_associacao');
        Q.SQL.Add('  where cod_pessoa_associacao = :cod_pessoa_associacao');
{$ENDIF}
        Q.ParamByName('cod_pessoa_associacao').AsInteger := ECodPessoa;
        Q.Open;
        bNovo := Q.IsEmpty;
        bRevalidacao := not(Q.FieldByName('DtaFimValidade').IsNull);
        Q.Close;

        if bNovo then begin

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Text :=
            'insert into tab_associacao ' +
            '( ' +
            '  cod_pessoa_associacao ' +
            '  , num_idade_padrao_1 ' +
            '  , num_idade_padrao_2 ' +
            '  , num_idade_padrao_3 ' +
            '  , num_idade_padrao_4 ' +
            '  , num_idade_padrao_5 ' +
            '  , num_limite_ajuste_idade ' +
            '  , num_limite_equivale_idade ' +
            '  , dta_fim_validade ' +
            ') ' +
            'values ' +
            '( ' +
            '  :cod_pessoa_associacao ' +
            '  , :num_idade_padrao_1 ' +
            '  , :num_idade_padrao_2 ' +
            '  , :num_idade_padrao_3 ' +
            '  , :num_idade_padrao_4 ' +
            '  , :num_idade_padrao_5 ' +
            '  , :num_limite_ajuste_idade ' +
            '  , :num_limite_equivale_idade ' +
            '  , null ' +
            ') ';
{$ENDIF}
          Q.ParamByName('cod_pessoa_associacao').AsInteger     := ECodPessoa;
          Q.ParamByName('num_idade_padrao_1').AsInteger        := ParametrosPesagem.NumIdadePadrao1;
          Q.ParamByName('num_idade_padrao_2').AsInteger        := ParametrosPesagem.NumIdadePadrao2;
          Q.ParamByName('num_idade_padrao_3').AsInteger        := ParametrosPesagem.NumIdadePadrao3;
          Q.ParamByName('num_idade_padrao_4').AsInteger        := ParametrosPesagem.NumIdadePadrao4;
          Q.ParamByName('num_idade_padrao_5').AsInteger        := ParametrosPesagem.NumIdadePadrao5;
          Q.ParamByName('num_limite_ajuste_idade').AsInteger   := ParametrosPesagem.NumLimiteAjuste;
          Q.ParamByName('num_limite_equivale_idade').AsInteger := ParametrosPesagem.NumLimiteEquivalencia;
          Q.ExecSQL;

        end else if bRevalidacao then begin

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Text :=
            'update tab_associacao set ' +
            '  num_idade_padrao_1 = :num_idade_padrao_1 ' +
            '  , num_idade_padrao_2 = :num_idade_padrao_2 ' +
            '  , num_idade_padrao_3 = :num_idade_padrao_3 ' +
            '  , num_idade_padrao_4 = :num_idade_padrao_4 ' +
            '  , num_idade_padrao_5 = :num_idade_padrao_5 ' +
            '  , num_limite_ajuste_idade = :num_limite_ajuste_idade ' +
            '  , num_limite_equivale_idade = :num_limite_equivale_idade ' +
            '  , dta_fim_validade = NULL ' +
            'where ' +
            '  cod_pessoa_associacao = :cod_pessoa_associacao ';
{$ENDIF}
          Q.ParamByName('cod_pessoa_associacao').AsInteger     := ECodPessoa;
          Q.ParamByName('num_idade_padrao_1').AsInteger        := ParametrosPesagem.NumIdadePadrao1;
          Q.ParamByName('num_idade_padrao_2').AsInteger        := ParametrosPesagem.NumIdadePadrao2;
          Q.ParamByName('num_idade_padrao_3').AsInteger        := ParametrosPesagem.NumIdadePadrao3;
          Q.ParamByName('num_idade_padrao_4').AsInteger        := ParametrosPesagem.NumIdadePadrao4;
          Q.ParamByName('num_idade_padrao_5').AsInteger        := ParametrosPesagem.NumIdadePadrao5;
          Q.ParamByName('num_limite_ajuste_idade').AsInteger   := ParametrosPesagem.NumLimiteAjuste;
          Q.ParamByName('num_limite_equivale_idade').AsInteger := ParametrosPesagem.NumLimiteEquivalencia;
          Q.ExecSQL;

        end;

      end else if ECodPapel = 2 then begin {Funcionário}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select dta_fim_validade as DtaFimValidade from tab_funcionario');
        Q.SQL.Add('  where cod_pessoa_funcionario = :cod_pessoa_funcionario');
{$ENDIF}
        Q.ParamByName('cod_pessoa_funcionario').AsInteger := ECodPessoa;
        Q.Open;
        bNovo := Q.IsEmpty;
        bRevalidacao := not(Q.FieldByName('DtaFimValidade').IsNull);
        Q.Close;

        if bNovo then begin

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('insert into tab_funcionario');
          Q.SQL.Add('  (cod_pessoa_funcionario');
          Q.SQL.Add('   , dta_fim_validade)');
          Q.SQL.Add('values');
          Q.SQL.Add('  (:cod_pessoa_funcionario');
          Q.SQL.Add('   , null)');
{$ENDIF}
          Q.ParamByName('cod_pessoa_funcionario').AsInteger := ECodPessoa;
          Q.ExecSQL;

        end else if bRevalidacao then begin

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('update tab_funcionario');
          Q.SQL.Add('  set dta_fim_validade = NULL');
          Q.SQL.Add('   where cod_pessoa_funcionario = :cod_pessoa_funcionario');
{$ENDIF}
          Q.ParamByName('cod_pessoa_funcionario').AsInteger := ECodPessoa;
          Q.ExecSQL;

        end;

      end else if ECodPapel = 3 then begin  {Técnico}

        IndGestorObrigatorio := UpperCase(ValorParametro(108));
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select');
        Q.SQL.Add('  dta_fim_validade as DtaFimValidade');
        Q.SQL.Add('  , cod_registro_log as CodRegistroLog');
        Q.SQL.Add('from');
        Q.SQL.Add('  tab_tecnico');
        Q.SQL.Add('where');
        Q.SQL.Add('  cod_pessoa_tecnico = :cod_pessoa_tecnico');
{$ENDIF}
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := ECodPessoa;
        Q.Open;
        bNovo := Q.IsEmpty;
        bRevalidacao := not(Q.FieldByName('DtaFimValidade').IsNull);
        CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
        Q.Close;

        if bNovo then begin

          // Pega próximo CodRegistroLog
          CodRegistroLog := ProximoCodRegistroLog;
          if CodRegistroLog < 0 then begin
            Rollback;
            Result := CodRegistroLog;
            Exit;
          end;

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('insert into tab_tecnico ');
          Q.SQL.Add('  (cod_pessoa_tecnico ');
          Q.SQL.Add('  , cod_grau_instrucao ');
          Q.SQL.Add('  , des_curso_superior ');
          Q.SQL.Add('  , sgl_conselho_regional ');
          Q.SQL.Add('  , num_conselho_regional ');
          Q.SQL.Add('  , cod_registro_log ');
          Q.SQL.Add('  , dta_fim_validade ');
          Q.SQL.Add('  , cod_pessoa_gestor ');
          Q.SQL.Add('  , ind_tecnico_ativo) ');
          Q.SQL.Add('values ');
          Q.SQL.Add('  (:cod_pessoa_tecnico ');
          Q.SQL.Add('  , :cod_grau_instrucao ');
          Q.SQL.Add('  , :des_curso_superior ');
          Q.SQL.Add('  , :sgl_conselho_regional ');
          Q.SQL.Add('  , :num_conselho_regional ');
          Q.SQL.Add('  , :cod_registro_log ');
          Q.SQL.Add('  , null ');

          if (ECodPessoaGestor > 0) or (Conexao.CodPapelUsuario = 9) then
          begin
            Q.SQL.Add(', :cod_pessoa_gestor ');
          end else begin
            Q.SQL.Add(', null ');
          end;
          Q.SQL.Add('  , ''S'') ');
{$ENDIF}
          Q.ParamByName('cod_pessoa_tecnico').AsInteger   := ECodPessoa;
          Q.ParamByName('cod_registro_log').AsInteger     := CodRegistroLog;
          Q.ParamByName('cod_grau_instrucao').AsInteger   := ECodGrauInstrucao;
          Q.ParamByName('des_curso_superior').DataType    := ftString;
          Q.ParamByName('sgl_conselho_regional').DataType := ftString;
          Q.ParamByName('num_conselho_regional').DataType := ftString;
          AtribuiValorParametro(Q.ParamByName('des_curso_superior'), EDesCursoSuperior);
          AtribuiValorParametro(Q.ParamByName('sgl_conselho_regional'), ESglConselhoRegional);
          AtribuiValorParametro(Q.ParamByName('num_conselho_regional'), ENumConselhoRegional);
          if (ECodPessoaGestor > 0) then begin
            Q.ParamByName('cod_pessoa_gestor').AsInteger  := ECodPessoaGestor;
          end else if (Conexao.CodPapelUsuario = 9) then begin
            Q.ParamByName('cod_pessoa_gestor').AsInteger  := Conexao.CodPessoa;
          end;
          Q.ExecSQL;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_tecnico', CodRegistroLog, 1, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

        end else begin

          if bRevalidacao then begin
            // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
            // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
            Result := GravarLogOperacao('tab_tecnico', CodRegistroLog, 6, Metodo);
            if Result < 0 then begin
              Rollback;
              Exit;
            end;
          end;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_tecnico', CodRegistroLog, 2, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('update tab_tecnico set');
          Q.SQL.Add('    cod_grau_instrucao    = :cod_grau_instrucao');
          Q.SQL.Add('  , des_curso_superior    = :des_curso_superior');
          Q.SQL.Add('  , sgl_conselho_regional = :sgl_conselho_regional');
          Q.SQL.Add('  , num_conselho_regional = :num_conselho_regional');
          Q.SQL.Add('  , ind_tecnico_ativo     = :ind_tecnico_ativo');
          if ECodPessoaGestor > 0 then
          begin
            Q.SQL.Add('  , cod_pessoa_gestor     = :cod_pessoa_gestor');
          end
          else
          begin
            Q.SQL.Add('  , cod_pessoa_gestor     = null');
          end;
          if bRevalidacao then begin
            Q.SQL.Add('  , dta_fim_validade = NULL');
          end;
          Q.SQL.Add('where');
          Q.SQL.Add('  cod_pessoa_tecnico = :cod_pessoa_tecnico');
          {$ENDIF}
          Q.ParamByName('cod_pessoa_tecnico').AsInteger   := ECodPessoa;
          if ECodPessoaGestor > 0 then
          begin
            Q.ParamByName('cod_pessoa_gestor').AsInteger    := ECodPessoaGestor;
          end;
          Q.ParamByName('cod_grau_instrucao').DataType    := ftInteger;
          Q.ParamByName('des_curso_superior').DataType    := ftString;
          Q.ParamByName('sgl_conselho_regional').DataType := ftString;
          Q.ParamByName('num_conselho_regional').DataType := ftString;
          Q.ParamByName('ind_tecnico_ativo').DataType     := ftString;
          AtribuiValorParametro(Q.ParamByName('cod_grau_instrucao'), ECodGrauInstrucao);
          AtribuiValorParametro(Q.ParamByName('des_curso_superior'), EDesCursoSuperior);
          AtribuiValorParametro(Q.ParamByName('sgl_conselho_regional'), ESglConselhoRegional);
          AtribuiValorParametro(Q.ParamByName('num_conselho_regional'), ENumConselhoRegional);
          AtribuiValorParametro(Q.ParamByName('ind_tecnico_ativo'), EIndTecnicoAtivo);
          Q.ExecSQL;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_tecnico', CodRegistroLog, 3, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

        end;

(*
        A partir de 19/10/2004 o procedimento de atualização de grandezas será
        realizado a partir da execução de processo batch por intervalos configuráveis
        e não mais a partir da execução de cada operação como anteriormente.
        { Atualiza Grandeza caso o papel de técnico esteja sendo atribuído
          or re-atribuído a pessoa}
        if bNovo or bRevalidacao then begin
          // Técnicos - Técnicos cadastrados
          Result := AtualizaGrandeza(16, -1, 1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
        end;
*)

      end else if ECodPapel = 4 then begin {Produtor}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select');
        Q.SQL.Add('  dta_fim_validade as DtaFimValidade');
        Q.SQL.Add('  , cod_registro_log as CodRegistroLog');
        Q.SQL.Add('from');
        Q.SQL.Add('  tab_produtor');
        Q.SQL.Add('where');
        Q.SQL.Add('  cod_pessoa_produtor = :cod_pessoa_produtor');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoa;
        Q.Open;
        bNovo := Q.IsEmpty;
        bRevalidacao := not(Q.FieldByName('DtaFimValidade').IsNull);
        CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
        Q.Close;

        if bNovo then begin

          // Pega próximo CodRegistroLog
          CodRegistroLog := ProximoCodRegistroLog;
          if CodRegistroLog < 0 then begin
            Rollback;
            Result := CodRegistroLog;
            Exit;
          end;

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Text :=
            'insert into tab_produtor ' +
            '( ' +
            '  cod_pessoa_produtor ' +
            '  , sgl_produtor ' +
            '  , qtd_caracteres_cod_manejo ' +
            '  , ind_produtor_bloqueado ' +
            '  , ind_consulta_publica ' +
            '  , cod_registro_log ' +
            '  , dta_efetivacao_cadastro ' +
            '  , ind_efetivado_uma_vez ' +
            '  , num_idade_padrao_1 ' +
            '  , num_idade_padrao_2 ' +
            '  , num_idade_padrao_3 ' +
            '  , num_idade_padrao_4 ' +
            '  , num_idade_padrao_5 ' +
            '  , num_limite_ajuste_idade ' +
            '  , num_limite_equivale_idade ' +
            '  , qtd_idade_minima_pesagem ' +
            '  , qtd_dias_entre_coberturas ' +
            '  , qtd_dias_descanso_reprodutivo ' +
            '  , qtd_dias_diagnostico_gestacao ' +
            '  , ind_estacao_monta ' +
            '  , cod_situacao_sisbov ' +
            '  , cod_aptidao ' +
            '  , ind_mostrar_nome ' +
            '  , ind_mostrar_identificadores ' +
            '  , ind_transfere_embrioes ' +
            '  , ind_mostrar_filtro_comp_racial ' +
            '  , ind_trabalha_assoc_raca ' +
            '  , qtd_idade_minima_desmame ' +
            '  , qtd_idade_maxima_desmame ' +
            '  , dta_fim_validade ' +
            ') ' +
            'values ' +
            '( ' +
            '  :cod_pessoa_produtor ' +
            '  , :sgl_produtor ' +
            '  , :qtd_caracteres_cod_manejo ' +
            '  , :ind_produtor_bloqueado ' +
            '  , :ind_consulta_publica ' +
            '  , :cod_registro_log ' +
            '  , null ' +
            '  , ''N'' ' +
            '  , :num_idade_padrao_1 ' +
            '  , :num_idade_padrao_2 ' +
            '  , :num_idade_padrao_3 ' +
            '  , :num_idade_padrao_4 ' +
            '  , :num_idade_padrao_5 ' +
            '  , :num_limite_ajuste_idade ' +
            '  , :num_limite_equivale_idade ' +
            '  , :qtd_idade_minima_pesagem ' +
            '  , :qtd_dias_entre_coberturas ' +
            '  , :qtd_dias_descanso_reprodutivo ' +
            '  , :qtd_dias_diagnostico_gestacao ' +
            '  , ''S'' ' +
            '  , :cod_situacao_sisbov ' +
            '  , :cod_aptidao ' +
            '  , :ind_mostrar_nome ' +
            '  , :ind_mostrar_identificadores ' +
            '  , :ind_transfere_embrioes ' +
            '  , :ind_mostrar_filtro_comp_racial ' +
            '  , :ind_trabalha_assoc_raca ' +
            '  , :qtd_idade_minima_desmame ' +
            '  , :qtd_idade_maxima_desmame ' +
            '  , null ' +
            ') ';
{$ENDIF}
          Q.ParamByName('cod_pessoa_produtor').AsInteger       := ECodPessoa;
          Q.ParamByName('sgl_produtor').AsString               := ESglProdutor;
          Q.ParamByName('qtd_caracteres_cod_manejo').AsInteger := QtdCaracteresCodManejo;
          Q.ParamByName('ind_produtor_bloqueado').AsString     := 'N';
          Q.ParamByName('ind_consulta_publica').AsString       := sIndConsultaPublica;
          Q.ParamByName('cod_registro_log').AsInteger          := CodRegistroLog;
          Q.ParamByName('num_idade_padrao_1').AsInteger        := ParametrosPesagem.NumIdadePadrao1;
          Q.ParamByName('num_idade_padrao_2').AsInteger        := ParametrosPesagem.NumIdadePadrao2;
          Q.ParamByName('num_idade_padrao_3').AsInteger        := ParametrosPesagem.NumIdadePadrao3;
          Q.ParamByName('num_idade_padrao_4').AsInteger        := ParametrosPesagem.NumIdadePadrao4;
          Q.ParamByName('num_idade_padrao_5').AsInteger        := ParametrosPesagem.NumIdadePadrao5;
          Q.ParamByName('num_limite_ajuste_idade').AsInteger   := ParametrosPesagem.NumLimiteAjuste;
          Q.ParamByName('num_limite_equivale_idade').AsInteger := ParametrosPesagem.NumLimiteEquivalencia;
          Q.ParamByName('qtd_idade_minima_pesagem').AsInteger  := ParametrosPesagem.QtdIdadeMinimaPesagem;
          Q.ParamByName('qtd_dias_entre_coberturas').AsInteger  := StrtoInt(ValorParametro(47));
          Q.ParamByName('qtd_dias_descanso_reprodutivo').AsInteger  := StrtoInt(ValorParametro(48));
          Q.ParamByName('qtd_dias_diagnostico_gestacao').AsInteger  := StrtoInt(ValorParametro(49));
          Q.ParamByName('cod_situacao_sisbov').AsString  := ValorParametro(51);
          Q.ParamByName('cod_aptidao').AsInteger  := StrtoInt(ValorParametro(52));
          Q.ParamByName('ind_mostrar_nome').AsString  := ValorParametro(53);
          Q.ParamByName('ind_mostrar_identificadores').AsString  := ValorParametro(54);
          Q.ParamByName('ind_transfere_embrioes').AsString  := ValorParametro(55);
          Q.ParamByName('ind_mostrar_filtro_comp_racial').AsString  := ValorParametro(56);
          Q.ParamByName('ind_trabalha_assoc_raca').AsString  := ValorParametro(57);
          Q.ParamByName('qtd_idade_minima_desmame').AsInteger  := StrtoInt(ValorParametro(58));
          Q.ParamByName('qtd_idade_maxima_desmame').AsInteger  := StrtoInt(ValorParametro(59));
          Q.ExecSQL;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 1, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

        end else begin

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 6, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('update tab_produtor set');
          Q.SQL.Add('  sgl_produtor = :sgl_produtor');
          if bRevalidacao then begin
            Q.SQL.Add('  , qtd_caracteres_cod_manejo = :qtd_caracteres_cod_manejo ');
            Q.SQL.Add('  , ind_produtor_bloqueado = :ind_produtor_bloqueado ');
            Q.SQL.Add('  , ind_consulta_publica = :ind_consulta_publica ');
            Q.SQL.Add('  , dta_efetivacao_cadastro = NULL ');
            Q.SQL.Add('  , ind_efetivado_uma_vez = ''N'' ');
            Q.SQL.Add('  , num_idade_padrao_1 = :num_idade_padrao_1 ');
            Q.SQL.Add('  , num_idade_padrao_2 = :num_idade_padrao_2 ');
            Q.SQL.Add('  , num_idade_padrao_3 = :num_idade_padrao_3 ');
            Q.SQL.Add('  , num_idade_padrao_4 = :num_idade_padrao_4 ');
            Q.SQL.Add('  , num_idade_padrao_5 = :num_idade_padrao_5 ');
            Q.SQL.Add('  , num_limite_ajuste_idade = :num_limite_ajuste_idade ');
            Q.SQL.Add('  , num_limite_equivale_idade = :num_limite_equivale_idade ');
            Q.SQL.Add('  , qtd_dias_entre_coberturas = :qtd_dias_entre_coberturas ');
            Q.SQL.Add('  , qtd_dias_descanso_reprodutivo = :qtd_dias_descanso_reprodutivo ');
            Q.SQL.Add('  , qtd_dias_diagnostico_gestacao = :qtd_dias_diagnostico_gestacao ');
            Q.SQL.Add('  , cod_situacao_sisbov = :cod_situacao_sisbov ');
            Q.SQL.Add('  , cod_aptidao = :cod_aptidao ');
            Q.SQL.Add('  , ind_mostrar_nome = :ind_mostrar_nome ');
            Q.SQL.Add('  , ind_mostrar_identificadores = :ind_mostrar_identificadores ');
            Q.SQL.Add('  , ind_transfere_embrioes = :ind_transfere_embrioes ');
            Q.SQL.Add('  , ind_mostrar_filtro_comp_racial = :ind_mostrar_filtro_comp_racial ');
            Q.SQL.Add('  , ind_trabalha_assoc_raca = :ind_trabalha_assoc_raca ');
            Q.SQL.Add('  , qtd_idade_minima_desmame = :qtd_idade_minima_desmame ');
            Q.SQL.Add('  , qtd_idade_maxima_desmame = :qtd_idade_maxima_desmame ');
            Q.SQL.Add('  , dta_fim_validade = NULL ');
          end;
          Q.SQL.Add('where');
          Q.SQL.Add('  cod_pessoa_produtor = :cod_pessoa_produtor');
{$ENDIF}
          Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoa;
          Q.ParamByName('sgl_produtor').AsString := ESglProdutor;
          if bRevalidacao then begin
            Q.ParamByName('qtd_caracteres_cod_manejo').AsInteger        := QtdCaracteresCodManejo;
            Q.ParamByName('ind_produtor_bloqueado').AsString            := 'N';
            Q.ParamByName('ind_consulta_publica').AsString              := sIndConsultaPublica;
            Q.ParamByName('num_idade_padrao_1').AsInteger               := ParametrosPesagem.NumIdadePadrao1;
            Q.ParamByName('num_idade_padrao_2').AsInteger               := ParametrosPesagem.NumIdadePadrao2;
            Q.ParamByName('num_idade_padrao_3').AsInteger               := ParametrosPesagem.NumIdadePadrao3;
            Q.ParamByName('num_idade_padrao_4').AsInteger               := ParametrosPesagem.NumIdadePadrao4;
            Q.ParamByName('num_idade_padrao_5').AsInteger               := ParametrosPesagem.NumIdadePadrao5;
            Q.ParamByName('num_limite_ajuste_idade').AsInteger          := ParametrosPesagem.NumLimiteAjuste;
            Q.ParamByName('num_limite_equivale_idade').AsInteger        := ParametrosPesagem.NumLimiteEquivalencia;
            Q.ParamByName('qtd_dias_entre_coberturas').AsInteger        := StrtoInt(ValorParametro(47));
            Q.ParamByName('qtd_dias_descanso_reprodutivo').AsInteger    := StrtoInt(ValorParametro(48));
            Q.ParamByName('qtd_dias_diagnostico_gestacao').AsInteger    := StrtoInt(ValorParametro(49));
            Q.ParamByName('cod_situacao_sisbov').AsString               := ValorParametro(51);
            Q.ParamByName('cod_aptidao').AsInteger                      := StrtoInt(ValorParametro(52));
            Q.ParamByName('ind_mostrar_nome').AsString                  := ValorParametro(53);
            Q.ParamByName('ind_mostrar_identificadores').AsString       := ValorParametro(54);
            Q.ParamByName('ind_transfere_embrioes').AsString            := ValorParametro(55);
            Q.ParamByName('ind_mostrar_filtro_comp_racial').AsString    := ValorParametro(56);
            Q.ParamByName('ind_trabalha_assoc_raca').AsString           := ValorParametro(57);
            Q.ParamByName('qtd_idade_minima_desmame').AsInteger         := StrtoInt(ValorParametro(58));
            Q.ParamByName('qtd_idade_maxima_desmame').AsInteger         := StrtoInt(ValorParametro(59));
          end;
          Q.ExecSQL;

        end;

        if bNovo or bRevalidacao then begin

          { Faz carga na tab_produtor_raca com as raças default para produtor }
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('insert into tab_produtor_raca (cod_pessoa_produtor, cod_raca)');
          Q.SQL.Add('select :cod_pessoa_produtor, cod_raca from tab_raca');
          Q.SQL.Add('where ind_default_produtor = ''S''');
{$ENDIF}
          Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoa;
          Q.ExecSQL;

(*
          A partir de 19/10/2004 o procedimento de atualização de grandezas será
          realizado a partir da execução de processo batch por intervalos configuráveis
          e não mais a partir da execução de cada operação como anteriormente.
          { Atualiza Grandeza caso o papel de produtor esteja sendo atribuído }
          { or re-atribuído a pessoa }
          // Produtores - Cadastrados
          Result := AtualizaGrandeza(13, CodPessoa, 1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
          // Produtores - Com identificação SISBOV pendente
          Result := AtualizaGrandeza(14, CodPessoa, 1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
*)

        end;

      end;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(592, Self.ClassName, 'AdicionarPapel', [E.Message]);
        Result := -592;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;


{* Função responsável por alterar o cadastro de uma pessoa cadastrada na base de
   dados.

   @param ECodPessoa Integer
   @param ENomPessoa String
   @param ENomReduzidoPessoa String
   @param ENumCNPJCPF String
   @param EDtaNascimento TDateTime
   @param ETxtObservacao String
   @param ESglProdutor String
   @param ECodGrauInstrucao Integer
   @param EDesCursoSuperior String
   @param ESglConselhoRegional String
   @param ENumConselhoRegional String
   @param ECodPessoaGestor Integer

   @return 0 Valor retornado quando o método for executado com sucesso.
   @return -188 Valor retornadoo quando o usuário que estiver executando o
                método não possuir permissão para executá-lo.
   @return -416 Valor retornado quando o parâmetro ECodNaturezaPessoa contiver
                um valor diferente de "F" ou "J".
   @return -424 Valor retornado quando o parâmetro ENumCNPJCPF contiver um valor
                inválido (CPF ou CNPJ)
   @return -551 Valor retornado quando a pessoa a ser inserida for uma pessoa
                física, e sua data de nascimento (EDtaNascimento) não foi
                informada.
   @return -553 Valor retornado quando a pessoa a ser cadastrada, já estiver
                previamente cadastrada. Atentar para o fato de que poderemos ter
                a situação de dois registros com o campo num_cnpj_cpf iguais, porém
                os valores do campo dta_fim_validade com valores distintos.
   @return -2188 Valor retornado quando o parâmetro ECodPessoaGestor não foi
                 informado.
   @return -2189 Valor informando quando o gestor informado for inválido.
   @return -561 Valor retornado quando durante a execução do método ocorrer
                uma exceção.
}
function TIntPessoas.Alterar(ECodPessoa: Integer;
                             ENomPessoa,
                             ENomReduzidoPessoa,
                             ENumCNPJCPF: String;
                             EDtaNascimento: TDateTime;
                             ETxtObservacao,
                             ESglProdutor: String;
                             ECodGrauInstrucao: Integer;
                             EDesCursoSuperior,
                             ESglConselhoRegional,
                             ENumConselhoRegional: String;
                             ECodPessoaGestor: Integer;
                             ESexo: String;
                             ENumIE: String;
                             EOrgaoIE: String;
                             EUFIE: String;
                             EDtaExp: TDateTime;
                             EIndTecnicoAtivo: String): Integer;
const
  NomMetodo: String = 'Alterar';
  Metodo: Integer = 200;
  CodPapelTecnico: Integer = 3;
  CodPapelProdutor: Integer = 4;
var
  Qup, Q: THerdomQuery;
  CodRegistroLog, ErroCNPJCPF: Integer;
  SexoSuperv, DtaExpedicao, DtaNascimento, TelefoneContato, CodNaturezaPessoa, NumCNPJCPFSemDv: String;
  bCadastroEfetivado, bTecnico, bProdutor,
  bGestor, bAlteraCNPJCPF: Boolean;
  CodPessoaGestor: Integer;
  PesquisaCPFCNPJ, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoAProdutor: RetornoAlterarProdutor;
  RetornoASupervisor: RetornoAlterarSupervisor;
  DataQuarentena: TDateTime;
begin
  Result := -1;
  RetornoAProdutor   := nil;
  RetornoASupervisor := nil;
  PesquisaCPFCNPJ := True;
  DataQuarentena  := 0;

  if not Inicializado then begin
    RaiseNaoInicializado('Alterar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  end;

  // Trata nome da pessoa
  Result := VerificaString(ENomPessoa, 'Nome da Pessoa');
  if Result < 0 then Exit;

  Result := TrataString(ENomPessoa, 100, 'Nome da Pessoa');
  if Result < 0 then Exit;

  // Trata nome reduzido da pessoa
  Result := VerificaString(ENomReduzidoPessoa, 'Nome reduzido da pessoa');
  if Result < 0 then Exit;

  Result := TrataString(ENomReduzidoPessoa, 15, 'Nome reduzido da pessoa');
  if Result < 0 then Exit;

  // Trata número CNPJ ou CPF
  if length(ENumCNPJCPF) = 11 then
  begin
    if ((length(ESexo) > 0) and (UpperCase(ESexo) <> 'F')) and ((length(ESexo) > 0) and (UpperCase(ESexo) <> 'M')) then begin
      Mensagens.Adicionar(2280, Self.ClassName, 'Alterar', []);
      Result := -2280;
      Exit;
    end;
  end
  else
  begin
    if (length(ESexo) > 0) and (length(ENumIE) > 0) and (length(EOrgaoIE) > 0) and (length(EUFIE) > 0) and (EDtaExp > 0) then begin
      Mensagens.Adicionar(2279, Self.ClassName, 'Alterar', []);
      Result := -2279;
      Exit;
    end;
  end;

{
  // Trata Observação
  if ETxtObservacao <> '' then begin
    Result := TrataString(ETxtObservacao, 255, 'Observação');
    if Result < 0 then Exit;
  end;
}
  Q   := THerdomQuery.Create(Conexao, nil);
  Qup := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Alterar pessoas');

      // caso o usuário logado seja um gestor, verificar se a pessoa a ser alterada
      // esta relacionada a sua pessoa.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select tt.cod_pessoa_tecnico as cod_pessoa ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
        Q.SQL.Add('    and tt.cod_pessoa_tecnico = :cod_pessoa ');
        Q.SQL.Add('    and tt.dta_fim_validade is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade is null ');
        Q.SQL.Add(' union ');
        Q.SQL.Add(' select ttp.cod_pessoa_produtor as cod_pessoa ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
        Q.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa ');
        Q.SQL.Add('    and tt.dta_fim_validade is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade is null ');

        Q.ParamByName('cod_pessoa_gestor').AsInteger    := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa').AsInteger   := ECodPessoa;
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2194, Self.ClassName, NomMetodo, []);
          Result := -2194;
          Exit
        end;
      end;

      // Verifica se a pessoa é o frigorífico ou aglomeração de algum animal
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_corrente = :cod_pessoa ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      // Define se o atributo NumCNPJCPF pode ou não ser alterado
      bAlteraCNPJCPF := Q.IsEmpty;
      ErroCNPJCPF := 754;
      Q.Close;

      if (ECodPessoaGestor > 0) then
      begin
        // verifica se o gestor informado é válido
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_pessoa tp, tab_pessoa_papel tpp ');
        Q.SQL.Add(' where tp.cod_pessoa = :cod_pessoa');
        Q.SQL.Add('   and tp.cod_pessoa = tpp.cod_pessoa');
        Q.SQL.Add('   and tpp.cod_papel = 3');
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;

        if not Q.IsEmpty then
        begin
          Q.SQL.Clear;
          Q.SQL.Add('select 1 from tab_pessoa tp');
          Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
          Q.ParamByName('cod_pessoa').AsInteger := ECodPessoaGestor;
          Q.Open;
          if Q.IsEmpty then
          begin
            Mensagens.Adicionar(2189, Self.ClassName, NomMetodo, []);
            Result := -2189;
            Exit;
          end;
        end;
      end;

      if bAlteraCNPJCPF then begin
        // Verifica se a pessoa em questão é a pessoa de origem ou de destino
        // de um evento de transferência
        ErroCNPJCPF := 910;
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_evento_transferencia ' +
                  ' where cod_pessoa_destino = :cod_pessoa ' +
                  '    or cod_pessoa_origem = :cod_pessoa ');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        // Define se o atributo NumCNPJCPF pode ou não ser alterado
        bAlteraCNPJCPF := Q.IsEmpty;
        Q.Close;

        if bAlteraCNPJCPF then begin
          // Verifica se a pessoa é o frigorífico de algum evento de venda
          ErroCNPJCPF := 1021;
          Q.Close;
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_evento_venda_frigorifico ' +
                    ' where cod_pessoa = :cod_pessoa ');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
          Q.Open;
          // Define se o atributo NumCNPJCPF pode ou não ser alterado
          bAlteraCNPJCPF := Q.IsEmpty;
          Q.Close;
        end;
      end;

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select                                                   ');
      Q.SQL.Add('    tpe.nom_pessoa              as NomPessoa             ');
      Q.SQL.Add('  , tpe.nom_reduzido_pessoa     as NomReduzidoPessoa     ');
      Q.SQL.Add('  , tpe.cod_natureza_pessoa     as CodNaturezaPessoa     ');
      Q.SQL.Add('  , tpe.num_cnpj_cpf            as NumCNPJCPF            ');
      Q.SQL.Add('  , tpe.dta_nascimento          as DtaNascimento         ');
      Q.SQL.Add('  , tpr.dta_efetivacao_cadastro as DtaEfetivacaoCadastro ');
      Q.SQL.Add('  , tpr.ind_efetivado_uma_vez   as IndEfetivadoUmaVez    ');
      Q.SQL.Add('  , tpr.sgl_produtor            as SglProdutor           ');
      Q.SQL.Add('  , tpe.cod_registro_log    as CodRegistroLog            ');
      Q.SQL.Add('  , tt.cod_pessoa_tecnico   as Tecnico                   ');
      Q.SQL.Add('  , tpr.cod_pessoa_produtor as Produtor                  ');
      Q.SQL.Add('  , tt.cod_pessoa_gestor    as Gestor                    ');
//      Q.SQL.Add('  , tpr.dta_quarentena      as DtaQuarentena             ');
      Q.SQL.Add('from                                                     ');
      Q.SQL.Add('    tab_pessoa tpe                                       ');
      Q.SQL.Add('  , tab_produtor tpr                                     ');
      Q.SQL.Add('  , tab_tecnico tt                                       ');
      Q.SQL.Add('where                                                    ');
      Q.SQL.Add('      tpe.cod_pessoa = :cod_pessoa                       ');
      Q.SQL.Add('  and tpe.dta_fim_validade is null                       ');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa          ');
      Q.SQL.Add('  and tpr.dta_fim_validade is null                       ');
      Q.SQL.Add('  and tt.cod_pessoa_tecnico =* tpe.cod_pessoa            ');
      Q.SQL.Add('  and tt.dta_fim_validade is null                        ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'Alterar', []);
        Result := -212;
        Exit;
      end;

      bTecnico           := not(Q.FieldByName('Tecnico').IsNull);
      bProdutor          := not(Q.FieldByName('Produtor').IsNull);
      bGestor            := not(Q.FieldByName('Gestor').IsNull);

      CodPessoaGestor := Q.FieldByName('Gestor').AsInteger;

      CodRegistroLog     := Q.FieldByName('CodRegistroLog').AsInteger;
      CodNaturezaPessoa  := Q.FieldByName('CodNaturezaPessoa').AsString;
      bCadastroEfetivado := not(Q.FieldByName('DtaEfetivacaoCadastro').IsNull);

      // Calculando Data de Quarentena
      if bProdutor then begin  // and bCadastroEfetivado then begin
        if (Q.FieldByName('NomPessoa').AsString <> ENomPessoa)
        or (Q.FieldByName('NumCNPJCPF').AsString <> ENumCNPJCPF) then begin
         DataQuarentena := Date + 40;
        end;
      end;

      if bCadastroEfetivado then begin
        if (Q.FieldByName('NomPessoa').AsString <> ENomPessoa)
        or (Q.FieldByName('NomReduzidoPessoa').AsString <> ENomReduzidoPessoa)
        or (Q.FieldByName('NumCNPJCPF').AsString <> ENumCNPJCPF)
        or (Q.FieldByName('DtaNascimento').AsDateTime <> EDtaNascimento) then begin
          Mensagens.Adicionar(559, Self.ClassName, 'Alterar', []);
          Result := -559;
          Exit;
        end;
      end;
      if not(bAlteraCNPJCPF) and (Q.FieldByName('NumCNPJCPF').AsString <> ENumCNPJCPF) then begin
        Mensagens.Adicionar(ErroCNPJCPF, Self.ClassName, 'Alterar', []);
        Result := -ErroCNPJCPF;
        Exit;
      end;
      Q.Close;

      // Trata número CNPJ ou CPF
      if CodNaturezaPessoa = 'F' then begin
        Result := VerificaString(ENumCNPJCPF, 'Número CPF');
        if Result < 0 then Exit;
        Result := TrataString(ENumCNPJCPF,11, 'Número CPF');
        NumCNPJCPFSemDv := Copy(ENumCNPJCPF,1,9);
      end else begin
        Result := VerificaString(ENumCNPJCPF, 'Número CNPJ');
        if Result < 0 then Exit;
        Result := TrataString(ENumCNPJCPF,14, 'Número CNPJ');
        NumCNPJCPFSemDv := Copy(ENumCNPJCPF,1,12);
      end;
      if Result < 0 then Exit;

      if not VerificarCnpjCpf(NumCNPJCPFSemDv,ENumCNPJCPF, ValorParametro(128)) then begin
        Mensagens.Adicionar(424, Self.ClassName, 'Alterar', []);
        Result := -424;
        Exit;
      end;

      // Consiste Data de Nascimento
      if (CodNaturezaPessoa <> 'F') and (EDtaNascimento > 0) then begin
        Mensagens.Adicionar(551, Self.ClassName, 'Alterar', []);
        Result := -551;
        Exit;
      end else if (CodNaturezaPessoa = 'F') and (EDtaNascimento >= Date) then begin
        Mensagens.Adicionar(1069, Self.ClassName, 'Alterar', []);
        Result := -1069;
        Exit;
      end;

      // Tratando dados referentes ao papel informado para inserção
      if bTecnico then begin
        // Trata Grau de instrução
        if (ECodGrauInstrucao = 0) then begin
          Result := VerificaString('', 'Para o papel de "Técnico", o grau de instrução');
          if Result < 0 then Exit;
        end;
        // Trata Descrição do curso superior
        if EDesCursoSuperior <> '' then begin
          Result := TrataString(EDesCursoSuperior, 30, 'Descrição do Curso Superior');
          if Result < 0 then Exit;
        end;
        // Trata Sigla do conselho regional
        if ESglConselhoRegional <> '' then begin
          Result := TrataString(ESglConselhoRegional, 10, 'Sigla do Conselho Regional');
          if Result < 0 then Exit;
        end;
        // Trata Número conselho regional
        if ENumConselhoRegional <> '' then begin
          Result := TrataString(ENumConselhoRegional, 15, 'Número Conselho Regional');
          if Result < 0 then Exit;
        end;
      end;

      if bGestor and (CodPessoaGestor <> ECodPessoaGestor) then
      begin
        if (Conexao.CodPapelUsuario <> 2) and (ECodPessoaGestor > 0) then
        begin
          Mensagens.Adicionar(2190, Self.ClassName, NomMetodo, []);
          Result := -2190;
          Exit;
        end;
      end;

      if bProdutor then
      begin
        Result := VerificaString(ESglProdutor, 'Sigla do produtor');
        if Result < 0 then
        begin
          Exit;
        end;
        Result := TrataString(ESglProdutor, 5, 'Sigla do produtor');
        if Result < 0 then
        begin
          Exit;
        end;
      end;

      if (CodNaturezaPessoa = 'J') and (
        (ENumCNPJCPF = '00000000000000') or
        (ENumCNPJCPF = '11111111111111') or
        (ENumCNPJCPF = '22222222222222') or
        (ENumCNPJCPF = '33333333333333') or
        (ENumCNPJCPF = '44444444444444') or
        (ENumCNPJCPF = '55555555555555') or
        (ENumCNPJCPF = '66666666666666') or
        (ENumCNPJCPF = '77777777777777') or
        (ENumCNPJCPF = '88888888888888') or
        (ENumCNPJCPF = '99999999999999')) and (ValorParametro(128) = 'S') then begin

        PesquisaCPFCNPJ := False;
      end else if (
        (ENumCNPJCPF = '00000000000') or
        (ENumCNPJCPF = '11111111111') or
        (ENumCNPJCPF = '22222222222') or
        (ENumCNPJCPF = '33333333333') or
        (ENumCNPJCPF = '44444444444') or
        (ENumCNPJCPF = '55555555555') or
        (ENumCNPJCPF = '66666666666') or
        (ENumCNPJCPF = '77777777777') or
        (ENumCNPJCPF = '88888888888') or
        (ENumCNPJCPF = '99999999999')) and (ValorParametro(128) = 'S') then begin

        PesquisaCPFCNPJ := False;
      end;

      if PesquisaCPFCNPJ then begin
        // Verifica duplicidade de número de CNPJCPF
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pessoa ');
        Q.SQL.Add('where num_cnpj_cpf = :num_cnpj_cpf ');
        Q.SQL.Add('  and cod_pessoa != :cod_pessoa ');
        Q.SQL.Add('  and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('num_cnpj_cpf').AsString := ENumCNPJCPF;
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(553, Self.ClassName, 'Alterar', [ENumCNPJCPF]);
          Result := -553;
          Exit;
        end;
        Q.Close;
      end;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 2, Metodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('       txt_observacao = :txt_observacao');
      Q.SQL.Add('   , ind_sexo = :ind_sexo');
      Q.SQL.Add('   , num_identidade  = :num_identidade');
      Q.SQL.Add('   , orgao_expedicao = :orgao_expedicao');
      Q.SQL.Add('   , uf_expedicao    = :uf_expedicao');
      Q.SQL.Add('   , dta_expedicao   = :dta_expedicao');

      if not bCadastroEfetivado then begin
        Q.SQL.Add('   , nom_pessoa = :nom_pessoa');
        Q.SQL.Add('   , nom_reduzido_pessoa = :nom_reduzido_pessoa');
        Q.SQL.Add('   , num_cnpj_cpf = :num_cnpj_cpf');
        Q.SQL.Add('   , dta_nascimento = :dta_nascimento');
      end;
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger           := ECodPessoa;
      Q.ParamByName('ind_sexo').AsString              := UpperCase(ESexo);
      Q.ParamByName('num_identidade').AsString        := ENumIE;
      Q.ParamByName('orgao_expedicao').AsString       := EOrgaoIE;
      Q.ParamByName('uf_expedicao').AsString          := EUFIE;
      Q.ParamByName('dta_expedicao').DataType         := ftDateTime;
      AtribuiValorParametro(Q.ParamByName('dta_expedicao') , EDtaExp);

      Q.ParamByName('txt_observacao').DataType        := ftString;
      AtribuiValorParametro(Q.ParamByName('txt_observacao'), ETxtObservacao);

      if not bCadastroEfetivado then begin
        Q.ParamByName('nom_pessoa').AsString          := ENomPessoa;
        Q.ParamByName('nom_reduzido_pessoa').AsString := ENomReduzidoPessoa;
        Q.ParamByName('num_cnpj_cpf').AsString        := ENumCNPJCPF;
        Q.ParamByName('dta_nascimento').DataType      := ftDateTime;
        AtribuiValorParametro(Q.ParamByName('dta_nascimento'), EDtaNascimento);
      end;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 3, Metodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end else begin
        // Verifica se está sendo alterado produtor ou técnico
        // se for um dos dois, é também alterado os dados no Sisbov
        if ((Conectado) and (PossuiPapel(ECodPessoa, CodPapelProdutor) = 1) or (Conectado) and (PossuiPapel(ECodPessoa, 3) = 1)) then begin
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add(' select ');
          Q.SQL.Add('    case tpe.cod_natureza_pessoa ');
          Q.SQL.Add('    when ''J'' then left(tpe.nom_pessoa, 50) ');
          Q.SQL.Add('    else '''' ');
          Q.SQL.Add('    end as razao_social, ');
          Q.SQL.Add('    case tpe.cod_natureza_pessoa ');
          Q.SQL.Add('    when ''J'' then tpe.num_cnpj_cpf ');
          Q.SQL.Add('    else '''' ');
          Q.SQL.Add('    end as cnpj_pessoa, ');
          Q.SQL.Add('    case tpe.cod_natureza_pessoa ');
          Q.SQL.Add('    when ''F'' then left(tpe.nom_pessoa, 50) ');
          Q.SQL.Add('    else '''' ');
          Q.SQL.Add('    end as nom_pessoa, ');
          Q.SQL.Add('    case tpe.cod_natureza_pessoa ');
          Q.SQL.Add('    when ''F'' then tpe.num_cnpj_cpf ');
          Q.SQL.Add('    else '''' ');
          Q.SQL.Add('    end as cpf_pessoa, ');
          Q.SQL.Add('    tpe.dta_nascimento, ');
          Q.SQL.Add('    tpe.num_identidade, ');
          Q.SQL.Add('    tpe.orgao_expedicao, ');
          Q.SQL.Add('    tpe.uf_expedicao, ');
          Q.SQL.Add('    tpe.dta_expedicao, ');
          Q.SQL.Add('    tpe.ind_sexo, ');
          Q.SQL.Add('    tpe.nom_logradouro, ');
          Q.SQL.Add('    tpe.nom_bairro, ');
          Q.SQL.Add('    tpe.num_cep, ');
          Q.SQL.Add('    tm.num_municipio_ibge, ');
          Q.SQL.Add('    te.sgl_estado, ');
          Q.SQL.Add('    tp.ind_transmissao_sisbov as transmissao_produtor, ');
          Q.SQL.Add('    tt.ind_transmissao_sisbov as transmissao_tecnico, ');
          Q.SQL.Add('    (select txt_contato from tab_pessoa_contato tpc where tpe.cod_pessoa = tpc.cod_pessoa and tpc.cod_tipo_contato = 1 and tpc.ind_principal = ''S'') as telefone_contato, ');
          Q.SQL.Add('    (select txt_contato from tab_pessoa_contato tpc where tpe.cod_pessoa = tpc.cod_pessoa and tpc.cod_tipo_contato = 5 and tpc.ind_principal = ''S'') as email_contato ');
          Q.SQL.Add('  from tab_pessoa tpe, ');
          Q.SQL.Add('    tab_municipio tm, ');
          Q.SQL.Add('    tab_produtor tp, ');
          Q.SQL.Add('    tab_tecnico tt, ');
          Q.SQL.Add('    tab_estado te ');
          Q.SQL.Add('  where tpe.cod_pessoa    = :cod_pessoa ');
          Q.SQL.Add('    and tpe.cod_pessoa    *= tp.cod_pessoa_produtor ');
          Q.SQL.Add('    and tp.ind_transmissao_sisbov is not null ');
          Q.SQL.Add('    and tpe.cod_pessoa    *= tt.cod_pessoa_tecnico ');
          Q.SQL.Add('    and tt.ind_transmissao_sisbov is not null ');
          Q.SQL.Add('    and tpe.cod_municipio *= tm.cod_municipio ');
          Q.SQL.Add('    and tpe.cod_estado    *= te.cod_estado ');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(212, Self.ClassName, 'Alterar', []);
            Result := -212;
            Exit;
          end;

          if Q.FieldByName('telefone_contato').AsString = '' then begin
            TelefoneContato  := '';//'Não tem';
          end else begin
            TelefoneContato  := Q.FieldByName('telefone_contato').AsString;
          end;

          // Transmite dados do produtor
          if (Q.FieldByName('transmissao_produtor').AsString = 'S') and (PossuiPapel(ECodPessoa, CodPapelProdutor) = 1) then begin
            try
              RetornoAProdutor := SoapSisbov.alterarProdutor(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('razao_social').AsString
                                 , Q.FieldByName('cnpj_pessoa').AsString
                                 , Q.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q.FieldByName('email_contato').AsString
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('ind_sexo').AsString
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('num_municipio_ibge').AsString
                                 , TelefoneContato
                                 , ''
                                 , TelefoneContato
                                 , '' );
            except
              on E: Exception do
              begin
                Mensagens.Adicionar(2302, Self.ClassName, NomMetodo, ['']);
                Result := -2302;
              end;
            end;

            If RetornoAProdutor <> nil then begin
              If RetornoAProdutor.Status = 0 then begin
                Mensagens.Adicionar(2302, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoAProdutor)]);
                Result := -2302;
              end else begin
                BeginTran;

                // Atualiza na tabela tab_produtor o indice, indicando que o mesmo já foi
                // enviada para o ministério.
                Qup.SQL.Clear;
                {$IFDEF MSSQL}
                     Qup.SQL.Add('update tab_produtor ');
                     Qup.SQL.Add('   set cod_id_transacao_sisbov = :cod_idtransacao ');
                     if (DataQuarentena > 0) then
                       Qup.SQL.Add('   ,dta_quarentena = :dta_quarentena ');

                     Qup.SQL.Add(' where cod_pessoa_produtor     = :cod_pessoa_produtor ');
                {$ENDIF}
                Qup.ParamByName('cod_idtransacao').AsInteger        := RetornoAProdutor.idTransacao;
                if (Qup.Params.FindParam('dta_quarentena') <> nil) then
                  Qup.ParamByName('dta_quarentena').AsDateTime := DataQuarentena;
                Qup.ParamByName('cod_pessoa_produtor').AsInteger    := ECodPessoa;
                Qup.ExecSQL;

                Commit;
              end;
            end else begin
              Mensagens.Adicionar(2302, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
              Result := -2302;
            end;
          end;

          // Transmite dados do técnico
          if (PossuiPapel(ECodPessoa, 3) = 1) and (Q.FieldByName('transmissao_tecnico').AsString = 'S') then begin
            DtaExpedicao      := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_expedicao').AsDateTime);
            DtaNascimento     := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_nascimento').AsDateTime);

            if Q.FieldByName('ind_sexo').AsString = 'M' then begin
              SexoSuperv := 'MA';
            end else begin
              SexoSuperv := 'FE';
            end;

            try
              RetornoASupervisor := SoapSisbov.alterarSupervisor(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q.FieldByName('email_contato').AsString
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('num_identidade').AsString
                                 , DtaNascimento
                                 , DtaExpedicao
                                 , Q.FieldByName('orgao_expedicao').AsString
                                 , Q.FieldByName('uf_expedicao').AsString
                                 , SexoSuperv
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('num_municipio_ibge').AsString );
            except
              on E: Exception do
              begin
                Mensagens.Adicionar(2303, Self.ClassName, NomMetodo, ['']);
                Result := -2303;
              end;
            end;

            If RetornoASupervisor <> nil then begin
              If RetornoASupervisor.Status = 0 then begin
                Mensagens.Adicionar(2303, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoASupervisor)]);
                Result := -2303;
              end else begin
                BeginTran;

                // Atualiza na tabela tab_tecnico o indice, indicando que o mesmo já foi
                // enviada para o ministério.
                Qup.SQL.Clear;
                {$IFDEF MSSQL}
                     Qup.SQL.Add('update tab_tecnico ' +
                                '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                                ' where cod_pessoa_tecnico      = :cod_pessoa_tecnico ');
                {$ENDIF}
                Qup.ParamByName('cod_idtransacao').AsInteger        := RetornoASupervisor.idTransacao;
                Qup.ParamByName('cod_pessoa_tecnico').AsInteger     := ECodPessoa;
                Qup.ExecSQL;

                Commit;
              end;
            end else begin
              Mensagens.Adicionar(2303, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
              Result := -2303;
            end;
          end;
        end;
      end;

      // Atualiza os dados referentes ao papel de técnico da pessoa em questão
      // O procedimento AdicionarPapel, identifica se a pessoa já possui o papel de técnico
      //   realizando então, apenas a atualização dos dados pertinentes ao papel.
      if bTecnico then begin
        Result := AdicionarPapel(ECodPessoa,
                                 CodPapelTecnico,
                                 ESglProdutor,
                                 ECodGrauInstrucao,
                                 EDesCursoSuperior,
                                 ESglConselhoRegional,
                                 ENumConselhoRegional,
                                 ECodPessoaGestor,
                                 EIndTecnicoAtivo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Atualiza os dados referentes ao papel de produtor da pessoa em questão
      // O procedimento AdicionarPapel, identifica se a pessoa já possui o papel de produtor
      //   realizando então, apenas a atualização dos dados pertinentes ao papel.
      if bProdutor then begin
        Result := AdicionarPapel(ECodPessoa,
                                 CodPapelProdutor, ESglProdutor, -1, '', '', '', -1, '');
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(561, Self.ClassName, 'Alterar', [E.Message]);
        Result := -561;
        Exit;
      end;
    end;
  Finally
    Q.Free;
    Qup.Free;
    SoapSisbov.Free;
  end;
end;


{* Função responsável por retornar oa atributos de uma pessoa.

   @param ECodPessoa Integer Parâmetro obrigatório. Indica a pessoa, a qual
                             deseja-se pesquisar na base de dados, para obter
                             as informações de seu cadastro.

   @return 0 Valor retornado quando o método for executado com sucesso.
   @return -188 Valor retornado quando o usuário que está executando o método não
                possui permissão para executá-lo.
   @return -577 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.   
}
function TIntPessoas.Buscar(ECodPessoa: Integer): Integer;
const
  Metodo: Integer = 201;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado('Buscar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  end;

  try
    Result := IntPessoa.CarregaPropriedades(ECodPessoa, Conexao, Mensagens);
  except
    On E: exception do begin
      Rollback;
      Mensagens.Adicionar(577, Self.ClassName, 'Buscar', [E.Message]);
      Result := -577;
      Exit;
    end;
  end;
end;

function TIntPessoas.CancelarEfetivacao(CodPessoa: Integer): Integer;
const
  NomMetodo: String = 'CancelarEfetivacao';
  Metodo: Integer = 206;
  Produtor: Integer = 4;
  Tecnico: Integer = 3;
var
  Q: THerdomQuery;
  CodRegistroLogTecnico, CodRegistroLog: Integer;
  DtaEfetivacaoProdutor, DtaEfetivacaoTecnico: TDateTime;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('CancelarEfetivacao');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -188;
    Exit;
  end;

  // Verifica se a pessoa informada é válida e é um produtor
  Result := PossuiPapel(CodPessoa, Produtor);
  if Result <> 1 then begin
    // Verifica se a pessoa informada é válida e é um tecnico
    Result := PossuiPapel(CodPessoa, Tecnico);
    if Result <> 1 then begin
      if Result = 0 then begin
        Mensagens.Adicionar(600, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -600;
      end;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // caso o usuário logado seja um gestor, verificar se a pessoa a ser alterada
      // esta relacionada a sua pessoa.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select 1 ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
        Q.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('    and tt.dta_fim_validade is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade is null ');
        Q.ParamByName('cod_pessoa_gestor').AsInteger  := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoa;
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2195, Self.ClassName, NomMetodo, []);
          Result := -2195;
          Exit
        end;
      end;
      
      // Buscando dados para serem consistidos
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  tpr.dta_efetivacao_cadastro   as DtaEfetivacaoCadastroProdutor');
      Q.SQL.Add('  , tt.dta_efetivacao_cadastro  as DtaEfetivacaoCadastroTecnico');
      Q.SQL.Add('  , tpr.cod_registro_log        as CodRegistroLog');
      Q.SQL.Add('  , tt.cod_registro_log         as CodRegistroLogTecnico');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('  , tab_tecnico tt');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tt.cod_pessoa_tecnico  =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -212;
        Exit;
      end;

      // Consistindo se o cadastro do produtor foi efetivado
      if (Q.FieldByName('DtaEfetivacaoCadastroProdutor').IsNull and Q.FieldByName('DtaEfetivacaoCadastroTecnico').IsNull) then begin
        Mensagens.Adicionar(604, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -604;
        Exit;
      end;

      CodRegistroLog        := Q.FieldByName('CodRegistroLog').AsInteger;
      CodRegistroLogTecnico := Q.FieldByName('CodRegistroLogTecnico').AsInteger;
      DtaEfetivacaoProdutor := Q.FieldByName('DtaEfetivacaoCadastroProdutor').AsDateTime;
      DtaEfetivacaoTecnico  := Q.FieldByName('DtaEfetivacaoCadastroTecnico').AsDateTime;
      Q.Close;

      // Abre transação
      beginTran;

      if DtaEfetivacaoProdutor > 0 then begin
        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 2, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        // Cancela efetivação do cadastro do produtor
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_produtor ');
        Q.SQL.Add('  set dta_efetivacao_cadastro = null');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoa;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 3, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      if DtaEfetivacaoTecnico > 0 then begin
        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_tecnico', CodRegistroLogTecnico, 2, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        // Cancela efetivação do cadastro do tecnico
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_tecnico ');
        Q.SQL.Add('  set dta_efetivacao_cadastro = null');
        Q.SQL.Add('where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoa;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_tecnico', CodRegistroLogTecnico, 3, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(606, Self.ClassName, 'CancelarEfetivacao', [E.Message]);
        Result := -606;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

constructor TIntPessoas.Create;
begin
  inherited;
  FIntPessoa := TIntPessoa.Create;
end;

destructor TIntPessoas.Destroy;
begin
  FIntPessoa.Free;
  inherited;
end;

function TIntPessoas.Definirendereco(CodPessoa, CodTipoendereco: Integer;
  NomLogradouro, NomBairro, NumCEP: String; CodPais, CodEstado,
          CodMunicipio, CodDistrito: Integer): Integer;
const
  Metodo: Integer = 228;
var
  Q : THerdomQuery;
  icCodDistrito, icCodMunicipio, icCodEstado, icCodPais,
    CodRegistroLog : Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Definirendereco');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Definirendereco', []);
    Result := -188;
    Exit;
  end;

  // Verifica se pelo menos um parâmetro foi informado
  if (CodTipoendereco < 0) and
     (NomLogradouro = '') and
     (NomBairro = '') and
     (NumCEP = '') and
     (CodPais <= 0) and
     (CodEstado <= 0) and
     (CodMunicipio <= 0) and
     (CodDistrito <= 0) then begin
    Mensagens.Adicionar(215, Self.ClassName, 'Definirendereco', []);
    Result := -215;
    Exit;
  end;

  // Trata Logradouro
  if NomLogradouro <> '' then begin
    Result := TrataString(NomLogradouro, 100, 'endereço');
    if Result < 0 then Exit;
    if (CodTipoendereco <= 0) then begin
      Result := VerificaString('', 'Tipo do endereço');
      if Result < 0 then Exit;
    end;
    if (CodMunicipio <= 0) and (CodDistrito <= 0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'Definirendereco', []);
      Result := -520;
      Exit;
    end;
  end else if CodTipoendereco > 0 then begin
    Mensagens.Adicionar(582, Self.ClassName, 'Definirendereco', []);
    Result := -582;
    Exit;
  end;

  // Trata Bairro
  if NomBairro <> '' then begin
    Result := TrataString(NomBairro, 50, 'Bairro');
    if Result < 0 then begin
      Exit;
    end;
    if (CodTipoendereco <= 0) then begin
      Result := VerificaString('', 'Tipo do endereço');
      if Result < 0 then Exit;
    end;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'Definirendereco', []);
      Result := -520;
      Exit;
    end;
  end;

  // Trata CEP
  if NumCEP <> '' then begin
    if not ehNumerico(NumCEP) then
    begin
      Mensagens.Adicionar(1845, Self.ClassName,
        'Definirendereco', []);
      Result := -1845;
      Exit;
    end;

    Result := TrataString(NumCEP, 8, 'CEP');
    if Result < 0 then begin
      Exit;
    end;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'Definirendereco', []);
      Result := -520;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  tpe.cod_registro_log as CodRegistroLog');
      Q.SQL.Add('  , tpr.dta_efetivacao_cadastro as DtaEfetivacaoCadastro');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'Definirendereco', []);
        Result := -212;
        Exit;
      end;
      if not(Q.FieldByName('DtaEfetivacaoCadastro').IsNull) then begin
        Mensagens.Adicionar(557, Self.ClassName, 'Definirendereco', []);
        Result := -557;
        Exit;
      end;
      CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
      Q.Close;

      if CodTipoendereco > 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_tipo_endereco');
        Q.SQL.Add('where cod_tipo_endereco = :cod_tipo_endereco');
{$ENDIF}
        Q.ParamByName('cod_tipo_endereco').AsInteger := CodTipoendereco;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(588, Self.ClassName, 'Definirendereco', []);
          Result := -588;
          Exit;
        end;
      end;
      Q.Close;

      icCodDistrito  := -1;
      icCodMunicipio := -1;
      icCodEstado    := -1;
      icCodPais      := -1;

      // Consiste o distrito
      if CodDistrito > 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select td.cod_municipio, ');
        Q.SQL.Add('       tm.cod_estado, ');
        Q.SQL.Add('       te.cod_pais ');
        Q.SQL.Add('  from tab_distrito td, ');
        Q.SQL.Add('       tab_municipio tm, ');
        Q.SQL.Add('       tab_estado te ');
        Q.SQL.Add(' where tm.cod_municipio = td.cod_municipio ');
        Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
        Q.SQL.Add('   and td.cod_distrito = :cod_distrito ');
        Q.SQL.Add('   and td.dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger := CodDistrito;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(397, Self.ClassName, 'Definirendereco', []);
          Result := -397;
          Exit;
        end;
        icCodDistrito  := CodDistrito;
        icCodMunicipio := Q.FieldByName('cod_municipio').AsInteger;
        icCodEstado    := Q.FieldByName('cod_estado').AsInteger;
        icCodPais      := Q.FieldByName('cod_pais').AsInteger;

        if CodMunicipio > 0 then begin
          if CodMunicipio <> icCodMunicipio then begin
            Mensagens.Adicionar(398, Self.ClassName, 'Definirendereco', []);
            Result := -398;
            Exit;
          end;
        end;

        if CodEstado > 0 then begin
          if CodEstado <> icCodEstado then begin
            Mensagens.Adicionar(400, Self.ClassName, 'Definirendereco', []);
            Result := -400;
            Exit;
          end;
        end;

        if CodPais > 0 then begin
          if CodPais <> icCodPais then begin
            Mensagens.Adicionar(401, Self.ClassName, 'Definirendereco', []);
            Result := -401;
            Exit;
          end;
        end;

        Q.Close;
      end else begin
        // Consiste o município
        if CodMunicipio > 0 then begin
          Q.SQL.Clear;
  {$IFDEF MSSQL}
          Q.SQL.Add('select tm.cod_estado, ');
          Q.SQL.Add('       te.cod_pais ');
          Q.SQL.Add('  from tab_municipio tm, ');
          Q.SQL.Add('       tab_estado te ');
          Q.SQL.Add(' where tm.cod_municipio = :cod_municipio ');
          Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
          Q.SQL.Add('   and tm.dta_fim_validade is null ');
  {$ENDIF}
          Q.ParamByName('cod_municipio').AsInteger := CodMunicipio;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(399, Self.ClassName, 'Definirendereco', []);
            Result := -399;
            Exit;
          end;
          icCodMunicipio := CodMunicipio;
          icCodEstado    := Q.FieldByName('cod_estado').AsInteger;
          icCodPais      := Q.FieldByName('cod_pais').AsInteger;

          if CodEstado > 0 then begin
            if CodEstado <> icCodEstado then begin
              Mensagens.Adicionar(400, Self.ClassName, 'Definirendereco', []);
              Result := -400;
              Exit;
            end;
          end;

          if CodPais > 0 then begin
            if CodPais <> icCodPais then begin
              Mensagens.Adicionar(401, Self.ClassName, 'Definirendereco', []);
              Result := -401;
              Exit;
            end;
          end;

          Q.Close;
        end else begin
          // Consiste o estado
          if CodEstado > 0 then begin
            Q.SQL.Clear;
    {$IFDEF MSSQL}
            Q.SQL.Add('select te.cod_pais ');
            Q.SQL.Add('  from tab_estado te ');
            Q.SQL.Add(' where te.cod_estado = :cod_estado ');
            Q.SQL.Add('   and te.dta_fim_validade is null ');
    {$ENDIF}
            Q.ParamByName('cod_estado').AsInteger := CodEstado;
            Q.Open;
            if Q.IsEmpty then begin
              Mensagens.Adicionar(387, Self.ClassName, 'Definirendereco', []);
              Result := -387;
              Exit;
            end;
            icCodEstado := CodEstado;
            icCodPais   := Q.FieldByName('cod_pais').AsInteger;

            if CodPais > 0 then begin
              if CodPais <> icCodPais then begin
                Mensagens.Adicionar(401, Self.ClassName, 'Definirendereco', []);
                Result := -401;
                Exit;
              end;
            end;
            Q.Close;
          end else begin
            if CodPais > 0 then begin
              Q.SQL.Clear;
      {$IFDEF MSSQL}
              Q.SQL.Add('select cod_pais ');
              Q.SQL.Add('  from tab_pais ');
              Q.SQL.Add(' where cod_pais = :cod_pais ');
              Q.SQL.Add('   and dta_fim_validade is null ');
      {$ENDIF}
              Q.ParamByName('cod_pais').AsInteger := CodPais;
              Q.Open;
              if Q.IsEmpty then begin
                Mensagens.Adicionar(402, Self.ClassName, 'Definirendereco', []);
                Result := -402;
                Exit;
              end;
              icCodPais := CodPais;

              Q.Close;
            end;
          end;
        end;
      end;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 2, Metodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa ');
      Q.SQL.Add('  set ');
      Q.SQL.Add('  cod_tipo_endereco = :cod_tipo_endereco,');
      Q.SQL.Add('  nom_logradouro = :nom_logradouro,');
      Q.SQL.Add('  nom_bairro = :nom_bairro,');
      Q.SQL.Add('  num_cep = :num_cep,');
      Q.SQL.Add('  cod_pais = :cod_pais,');
      Q.SQL.Add('  cod_estado = :cod_estado,');
      Q.SQL.Add('  cod_municipio = :cod_municipio,');
      Q.SQL.Add('  cod_distrito = :cod_distrito');
      Q.SQL.Add('where cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_tipo_endereco').DataType := ftInteger;
      Q.ParamByName('nom_logradouro').DataType    := ftString;
      Q.ParamByName('nom_bairro').DataType        := ftString;
      Q.ParamByName('num_cep').DataType           := ftString;
      Q.ParamByName('cod_pais').DataType          := ftInteger;
      Q.ParamByName('cod_estado').DataType        := ftInteger;
      Q.ParamByName('cod_municipio').DataType     := ftInteger;
      Q.ParamByName('cod_distrito').DataType      := ftInteger;
      AtribuiValorParametro(Q.ParamByName('cod_tipo_endereco'), CodTipoendereco);
      AtribuiValorParametro(Q.ParamByName('nom_logradouro'), NomLogradouro);
      AtribuiValorParametro(Q.ParamByName('nom_bairro'), NomBairro);
      AtribuiValorParametro(Q.ParamByName('num_cep'), NumCEP);
      AtribuiValorParametro(Q.ParamByName('cod_pais'), icCodPais);
      AtribuiValorParametro(Q.ParamByName('cod_estado'), icCodEstado);
      AtribuiValorParametro(Q.ParamByName('cod_municipio'), icCodMunicipio);
      AtribuiValorParametro(Q.ParamByName('cod_distrito'), icCodDistrito);
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 3, Metodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(589, Self.ClassName, 'Definirendereco', [E.Message]);
        Result := -589;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntPessoas.EfetivarCadastro(CodPessoa: Integer): Integer;
const
  Metodo: Integer = 205;
  Produtor: Integer = 4;
  Tecnico: Integer = 3;
  NomMetodo: String = 'EfetivarCadastro';
var
  Q : THerdomQuery;
  CodRegistroLogTecnico, CodRegistroLog: Integer;
  DtaEfetivacaoCadastroProdutor: TDateTime;
  DtaEfetivacaoCadastroTecnico: TDateTime;
  CodPapelProdutor: String;
  CodNaturezaPessoa, CodPapelTecnico: String;

begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'EfetivarCadastro', []);
    Result := -188;
    Exit;
  end;

  // Verifica se a pessoa informada é válida e é um produtor
  Result := PossuiPapel(CodPessoa, Produtor);
  if Result <> 1 then begin
    Result := PossuiPapel(CodPessoa, Tecnico);
    if Result <> 1 then begin
      if Result = 0 then begin
        Mensagens.Adicionar(600, Self.ClassName, 'EfetivarCadastro', []);
        Result := -600;
      end;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // caso o usuário logado seja um gestor, verificar se a pessoa a ser alterada
      // esta relacionada a sua pessoa.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select 1 ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
        Q.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('    and tt.dta_fim_validade is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade is null ');
        Q.ParamByName('cod_pessoa_gestor').AsInteger  := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoa;
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2196, Self.ClassName, NomMetodo, []);
          Result := -2196;
          Exit
        end;
      end;

      // Buscando dados para serem consistidos
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  tpe.nom_logradouro            as NomLogradouro');
      Q.SQL.Add('  , tpe.num_cep                 as NumCEP');
      Q.SQL.Add('  , tpe.cod_municipio           as CodMunicipio');
      Q.SQL.Add('  , tpe.ind_sexo                as IndSexo');
      Q.SQL.Add('  , tpe.cod_natureza_pessoa     as CodNaturezaPessoa');
      Q.SQL.Add('  , tmu.dta_efetivacao_cadastro as DtaEfetivacaoCadastroMunicipio');
      Q.SQL.Add('  , tpr.dta_efetivacao_cadastro as DtaEfetivacaoCadastroProdutor');
      Q.SQL.Add('  , tt.dta_efetivacao_cadastro  as DtaEfetivacaoCadastroTecnico');
      Q.SQL.Add('  , tpr.cod_registro_log        as CodRegistroLog');
      Q.SQL.Add('  , tt.cod_registro_log         as CodRegistroLogTecnico');
      Q.SQL.Add('  , (select ''S'' from tab_pessoa_papel where cod_pessoa = tpe.cod_pessoa and cod_papel = 3) as CodPapelTecnico ');
    	Q.SQL.Add('  , (select ''S'' from tab_pessoa_papel where cod_pessoa = tpe.cod_pessoa and cod_papel = 4) as CodPapelProdutor ');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('  , tab_tecnico tt');
      Q.SQL.Add('  , tab_municipio tmu');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tt.cod_pessoa_tecnico   =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
      Q.SQL.Add('  and tmu.cod_municipio =* tpe.cod_municipio');
      Q.SQL.Add('  and tmu.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'EfetivarCadastro', []);
        Result := -212;
        Exit;
      end;

      // Consistindo natureza da pessoa
      if (Q.FieldByName('CodNaturezaPessoa').AsString = 'J') and (PossuiPapel(CodPessoa, Produtor) = 0) then begin
        Mensagens.Adicionar(2286, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2286;
        Exit;
      end;

      // Consistindo o sexo da pessoa
      if (((Q.FieldByName('CodNaturezaPessoa').AsString = 'F') and (Q.FieldByName('IndSexo').IsNull)) or ((Q.FieldByName('CodNaturezaPessoa').AsString = 'F') and (UpperCase(Q.FieldByName('IndSexo').AsString) <> 'F')) and ((Q.FieldByName('CodNaturezaPessoa').AsString = 'F') and (UpperCase(Q.FieldByName('IndSexo').AsString) <> 'M'))) then begin
        Mensagens.Adicionar(2283, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2283;
        Exit;
      end;

      // Consistindo se o cadastro do produtor/tecnico ainda não foi efetivado
      if (not Q.FieldByName('DtaEfetivacaoCadastroProdutor').IsNull and not Q.FieldByName('DtaEfetivacaoCadastroTecnico').IsNull) then begin
        Mensagens.Adicionar(557, Self.ClassName, 'EfetivarCadastro', []);
        Result := -557;
        Exit;
      end;

      // Consistindo se o cadastro do produtor ainda não foi efetivado
      if (not Q.FieldByName('DtaEfetivacaoCadastroProdutor').IsNull and Q.FieldByName('CodPapelTecnico').IsNull) then begin
        Mensagens.Adicionar(557, Self.ClassName, 'EfetivarCadastro', []);
        Result := -557;
        Exit;
      end;

      // Consistindo se o cadastro do tecnico ainda não foi efetivado
      if (not Q.FieldByName('DtaEfetivacaoCadastroTecnico').IsNull and Q.FieldByName('CodPapelProdutor').IsNull) then begin
        Mensagens.Adicionar(2284, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2284;
        Exit;
      end;

      // Consistindo informações básicas para efetivação
      if Q.FieldByName('NomLogradouro').IsNull
      or Q.FieldByName('NumCEP').IsNull
      or Q.FieldByName('CodMunicipio').IsNull then begin
        Mensagens.Adicionar(601, Self.ClassName, 'EfetivarCadastro', []);
        Result := -601;
        Exit;
      end;

      // Consistindo se o município informado possui seu cadastro efetivado
      if Q.FieldByName('DtaEfetivacaoCadastroMunicipio').IsNull then begin
        Mensagens.Adicionar(602, Self.ClassName, 'EfetivarCadastro', []);
        Result := -602;
        Exit;
      end;

      CodRegistroLog                := Q.FieldByName('CodRegistroLog').AsInteger;
      CodRegistroLogTecnico         := Q.FieldByName('CodRegistroLogTecnico').AsInteger;
      DtaEfetivacaoCadastroProdutor := Q.FieldByName('DtaEfetivacaoCadastroProdutor').AsDateTime;
      DtaEfetivacaoCadastroTecnico  := Q.FieldByName('DtaEfetivacaoCadastroTecnico').AsDateTime;
      CodPapelProdutor              := Q.FieldByName('CodPapelProdutor').AsString;
      CodPapelTecnico               := Q.FieldByName('CodPapelTecnico').AsString;
      CodNaturezaPessoa             := Q.FieldByName('CodNaturezaPessoa').AsString;
      Q.Close;

      // Abre transação
      beginTran;

      if CodRegistroLog > 0 then begin
        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 2, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      if CodRegistroLogTecnico > 0 then begin
        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_tecnico', CodRegistroLogTecnico, 2, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Efetiva o cadasto produtor
      if (DtaEfetivacaoCadastroProdutor = 0) and not (CodPapelProdutor = '') then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_produtor');
        Q.SQL.Add('  set dta_efetivacao_cadastro = getdate()');
        Q.SQL.Add('    , ind_efetivado_uma_vez = ''S''');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoa;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 3, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 3, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

      // Efetiva o cadasto tecnico
      if (DtaEfetivacaoCadastroTecnico = 0) and not (CodPapelTecnico = '') and (CodNaturezaPessoa = 'F') then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_tecnico');
        Q.SQL.Add('  set dta_efetivacao_cadastro = getdate()');
        Q.SQL.Add('    , ind_efetivado_uma_vez = ''S''');
        Q.SQL.Add('where cod_pessoa_tecnico = :cod_pessoa_tecnico');
{$ENDIF}
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoa;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
        Result := GravarLogOperacao('tab_tecnico', CodRegistroLogTecnico, 3, Metodo);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      { Atualiza Grandeza  }
      // Produtores - Identificados no SISBOV
      Result := AtualizaGrandeza(15, CodPessoa, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      // Produtores - Com identificação SISBOV pendente
      Result := AtualizaGrandeza(14, CodPessoa, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
*)

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(603, Self.ClassName, 'EfetivarCadastro', [E.Message]);
        Result := -603;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntPessoas.Excluir(ECodPessoa: Integer): Integer;
const
  NomMetodo: String = 'Excluir';
  Metodo: Integer = 202;
var
  Q: THerdomQuery;
  dDtaFimValidade: TDateTime;
  X, CodRegistroLog, CodRegistroLogTecnico, CodRegistroLogProdutor: Integer;
  bProdutor,
  bProdutorEfetivado,
  bTecnico,
  bAssociacao,
  bFuncionario,
  bGestor: Boolean;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado('Excluir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // caso o usuário logado seja um gestor, verificar se a pessoa a ser alterada
      // esta relacionada a sua pessoa.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        Q.SQL.Clear;
        Q.SQL.Add(' select 1 ');
        Q.SQL.Add('   from tab_tecnico tt ');
        Q.SQL.Add('      , tab_tecnico_produtor ttp ');
        Q.SQL.Add('  where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ');
        Q.SQL.Add('    and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
        Q.SQL.Add('    and ttp.cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('    and tt.dta_fim_validade is null ');
        Q.SQL.Add('    and ttp.dta_fim_validade is null ');
        Q.ParamByName('cod_pessoa_gestor').AsInteger  := Conexao.CodPessoa;
        Q.ParamByName('cod_pessoa_produtor').AsInteger  := ECodPessoa;
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2194, Self.ClassName, NomMetodo, []);
          Result := -2194;
          Exit
        end;
      end;

      // Verifica existência do registro
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('    tpe.cod_registro_log        as CodRegistroLog');
      Q.SQL.Add('  , tpr.cod_registro_log        as CodRegistroLogProdutor');
      Q.SQL.Add('  , tpr.cod_pessoa_produtor     as Produtor');
      Q.SQL.Add('  , tpr.dta_efetivacao_cadastro as DtaEfetivacaoCadastro');
      Q.SQL.Add('  , tt.cod_registro_log         as CodRegistroLogTecnico');
      Q.SQL.Add('  , tt.cod_pessoa_tecnico       as Tecnico');
      Q.SQL.Add('  , ta.cod_pessoa_associacao    as Associacao');
      Q.SQL.Add('  , tf.cod_pessoa_funcionario   as Funcionario');
      Q.SQL.Add('  , tg.cod_pessoa_gestor        as Gestor');
      Q.SQL.Add('  , getdate()                   as DtaFimValidade');
      Q.SQL.Add('from');
      Q.SQL.Add('    tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('  , tab_tecnico tt');
      Q.SQL.Add('  , tab_associacao ta');
      Q.SQL.Add('  , tab_funcionario tf');
      // "tabela" com dados do gestor para que possa verificar se a pessoa em
      // questão é um gestor 
      Q.SQL.Add('  , ( select tp.cod_pessoa as cod_pessoa_gestor ');
      Q.SQL.Add('       from tab_pessoa tp ');
      Q.SQL.Add('          , tab_pessoa_papel tpp ');
      Q.SQL.Add('       where tp.cod_pessoa *= tpp.cod_pessoa ');
      Q.SQL.Add('         and tp.dta_fim_validade is null ');
      Q.SQL.Add('         and tpp.dta_fim_validade is null ');
      Q.SQL.Add('         and tp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('         and tpp.cod_papel = 9) tg ');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
      Q.SQL.Add('  and tt.cod_pessoa_tecnico =* tpe.cod_pessoa');
      Q.SQL.Add('  and tt.dta_fim_validade is null');
      Q.SQL.Add('  and ta.cod_pessoa_associacao =* tpe.cod_pessoa');
      Q.SQL.Add('  and ta.dta_fim_validade is null');
      Q.SQL.Add('  and tf.cod_pessoa_funcionario =* tpe.cod_pessoa');
      Q.SQL.Add('  and tf.dta_fim_validade is null');
      Q.SQL.Add('  and tpe.cod_pessoa = tg.cod_pessoa_gestor');      
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(212, Self.ClassName, 'Excluir', []);
        Result := -212;
        Exit;
      end;
      bTecnico               := not(Q.FieldByName('Tecnico').IsNull);
      bProdutor              := not(Q.FieldByName('Produtor').IsNull);
      bProdutorEfetivado     := not Q.FieldByName('DtaEfetivacaoCadastro').IsNull;
      bAssociacao            := not(Q.FieldByName('Associacao').IsNull);
      bFuncionario           := not(Q.FieldByName('Funcionario').IsNull);
      bGestor                := not(Q.FieldByName('Gestor').IsNull);
      CodRegistroLog         := Q.FieldByName('CodRegistroLog').AsInteger;
      CodRegistroLogProdutor := Q.FieldByName('CodRegistroLogProdutor').AsInteger;
      CodRegistroLogTecnico  := Q.FieldByName('CodRegistroLogTecnico').AsInteger;
      dDtaFimValidade        := Q.FieldByName('DtaFimValidade').AsDateTime;
      Q.Close;

      if bProdutor and bProdutorEfetivado then
      begin
        Mensagens.Adicionar(557, Self.ClassName, 'Excluir', []);
        Result := -557;
        Exit;
      end;

      // Verifica se a pessoa é o frigorífico ou aglomeração de algum animal
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_corrente = :cod_pessoa ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if not Q.IsEmpty then
      begin
        Mensagens.Adicionar(755, Self.ClassName, 'Excluir', []);
        Result := -755;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa em questão é a pessoa de origem ou de destino
      // de um evento de transferência
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_evento_transferencia ' +
                ' where cod_pessoa_destino = :cod_pessoa ' +
                '    or cod_pessoa_origem = :cod_pessoa ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if not Q.IsEmpty then
      begin
        Mensagens.Adicionar(914, Self.ClassName, 'Excluir', []);
        Result := -914;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa é o frigorífico de algum evento de venda
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_evento_venda_frigorifico ' +
                ' where cod_pessoa = :cod_pessoa ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if not Q.IsEmpty then
      begin
        Mensagens.Adicionar(1022, Self.ClassName, 'Excluir', []);
        Result := -1022;
        Exit;
      end;
      Q.Close;

      // Verifica se existe um usuário ativo para a pessoa informada
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_usuario');
      Q.SQL.Add('  where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('    and dta_fim_validade is null');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      if not Q.IsEmpty then
      begin
        Mensagens.Adicionar(570, Self.ClassName, 'Excluir', []);
        Result := -570;
        Exit;
      end;

      // Consistindo informações para produtor rural
      if bProdutor then
      begin
        // Consiste se existem fazendas ativas para o produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_fazenda');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(564, Self.ClassName, 'Excluir', []);
          Result := -564;
          Exit;
        end;

        // Consiste se existem lotes ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_lote');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
          Mensagens.Adicionar(565, Self.ClassName, 'Excluir', []);
          Result := -565;
          Exit;
        end;

        // Consiste se existem locais ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_local');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
          Mensagens.Adicionar(566, Self.ClassName, 'Excluir', []);
          Result := -566;
          Exit;
        end;

        // Consiste se existem animais ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_animal');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
          Mensagens.Adicionar(567, Self.ClassName, 'Excluir', []);
          Result := -567;
          Exit;
        end;

        // Consiste se existem pessoas secundárias ativas para o produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pessoa_secundaria');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
          Mensagens.Adicionar(568, Self.ClassName, 'Excluir', []);
          Result := -568;
          Exit;
        end;
      end;

      // Abre transação
      BeginTran;

      // -----------------------------
      // Tratando papel de Funcionário
      // -----------------------------
      if bFuncionario then
      begin
        // Finalizando dados do papel de funcionário para pessoa
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('update tab_funcionario');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('  where cod_pessoa_funcionario = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;
      end;

      // ----------------------------
      // Tratando papel de Associação
      // ----------------------------
      if bAssociacao then
      begin
        // Gravando Log de exclusão para a tabela
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log from tab_associacao_produtor');
        Q.SQL.Add('  where cod_pessoa_associacao = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        while not Q.Eof do
        begin
          X := Q.FieldByName('cod_registro_log').AsInteger;
          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_associacao_produtor', X, 4, Metodo);
          if Result < 0 then
          begin
            Rollback;
            Exit;
          end;
          Q.Next;
        end;

        // Excluindo relacionamento na tab_associacao_produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_associacao_produtor');
        Q.SQL.Add('  where cod_pessoa_associacao = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

        // Finalizando dados do papel de associação para pessoa
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('update tab_associacao');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('  where cod_pessoa_associacao = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;
      end;

      // -------------------------
      // Tratando papel de Técnico
      // -------------------------
      if bTecnico then
      begin
        // Gravando Log de exclusão para a tabela
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log from tab_tecnico_produtor');
        Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa');
        Q.SQL.Add('   and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        while not Q.Eof do
        begin
          X := Q.FieldByName('cod_registro_log').AsInteger;
          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_tecnico_produtor', X, 4, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
          Q.Next;
        end;

        //Verficando se existe algum produtor associado ao técnico
        Q.Close;
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_tecnico_produtor');
        Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico');
        Q.SQL.Add('   and dta_fim_validade is null');
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
           Mensagens.Adicionar(1894, Self.ClassName, NomMetodo, []);
           Result := 1894;
           Exit;
        end;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_tecnico', CodRegistroLogTecnico, 5, Metodo);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;

        // Finalizando dados do papel de técnico para pessoa
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('update tab_tecnico');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('  where cod_pessoa_tecnico = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

(*
        A partir de 19/10/2004 o procedimento de atualização de grandezas será
        realizado a partir da execução de processo batch por intervalos configuráveis
        e não mais a partir da execução de cada operação como anteriormente.
        { Atualiza Grandeza caso o papel de técnico esteja sendo removido }
        // Técnicos - Técnicos cadastrados
        Result := AtualizaGrandeza(16, -1, -1);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
*)

      end;

      // -------------------------
      // Tratando papel de Gestor
      // -------------------------
      if bGestor then
      begin
        // Gravando Log de exclusão para a tabela
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select tp.cod_registro_log from tab_pessoa tp, tab_pessoa_papel tpp');
        Q.SQL.Add(' where tp.cod_pessoa = tpp.cod_pessoa');
        Q.SQL.Add('   and tp.dta_fim_validade is null');
        Q.SQL.Add('   and tpp.dta_fim_validade is null');
        Q.SQL.Add('   and tpp.cod_papel = 9');
        Q.SQL.Add('   and tp.cod_pessoa = :cod_pessoa');                
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        while not Q.Eof do
        begin
          X := Q.FieldByName('cod_registro_log').AsInteger;
          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_pessoa', X, 4, Metodo);
          if Result < 0 then
          begin
            Rollback;
            Exit;
          end;
          Q.Next;
        end;

        //Verificando se existe algum técnico associado ao gestor
        Q.Close;
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_tecnico');
        Q.SQL.Add(' where cod_pessoa_gestor = :cod_pessoa_gestor');
        Q.SQL.Add('   and dta_fim_validade is null');
        Q.ParamByName('cod_pessoa_gestor').AsInteger := ECodPessoa;
        Q.Open;
        if not Q.IsEmpty then
        begin
           Mensagens.Adicionar(2193, Self.ClassName, NomMetodo, []);
           Result := -2193;
           Exit;
        end;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 5, Metodo);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
      end;

      // --------------------------
      // Tratando papel de Produtor
      // --------------------------
      if bProdutor then
      begin
        // Gravando Log de exclusão para a tabela
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log from tab_associacao_produtor');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        while not Q.EOF do
        begin
          X := Q.FieldByName('cod_registro_log').AsInteger;
          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_associacao_produtor', X, 4, Metodo);
          if Result < 0 then
          begin
            Rollback;
            Exit;
          end;
          Q.Next;
        end;

        // Excluindo relacionamento na tab_associacao_produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_associacao_produtor');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

        // Gravando Log de exclusão para a tabela
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log from tab_tecnico_produtor');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('   and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.Open;
        while not Q.Eof do
        begin
          X := Q.FieldByName('cod_registro_log').AsInteger;
          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_tecnico_produtor', X, 4, Metodo);
          if Result < 0 then
          begin
            Rollback;
            Exit;
          end;
          Q.Next;
        end;

        // Excluindo raças do produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_produtor_raca');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

        // Excluindo relacionamento na tab_tecnico_produtor
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_tecnico_produtor');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('   and dta_fim_validade is null');
        {$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_produtor', CodRegistroLogProdutor, 5, Metodo);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;

        // Finalizando dados do papel de produtor para pessoa
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('update tab_produtor');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        {$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
        Q.ExecSQL;

(*
        A partir de 19/10/2004 o procedimento de atualização de grandezas será
        realizado a partir da execução de processo batch por intervalos configuráveis
        e não mais a partir da execução de cada operação como anteriormente.
        { Atualiza Grandeza caso o papel de produtor esteja sendo removido }
        // Produtores - Cadastrados
        Result := AtualizaGrandeza(13, CodPessoa, -1);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
        if bProdutorEfetivado then begin
          // Produtores - Identificados no SISBOV
          Result := AtualizaGrandeza(15, CodPessoa, -1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
        end else begin
          // Produtores - Com identificação SISBOV pendente
          Result := AtualizaGrandeza(14, CodPessoa, -1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
        end;
*)

      end;

      // Gravando Log de finalização de papéis para pessoa
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_pessoa_papel');
      Q.SQL.Add('  where cod_pessoa = :cod_pessoa');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      while not Q.Eof do
      begin
        X := Q.FieldByName('cod_registro_log').AsInteger;
        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_pessoa_papel', X, 5, Metodo);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
        Q.Next;
      end;

      // Finalizando relacionamento entre pessoa e papeis a ela atribuídos
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_papel');
      Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
      Q.SQL.Add('  where cod_pessoa = :cod_pessoa');
      {$ENDIF}
      Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 5, Metodo);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa');
      Q.SQL.Add(' set dta_fim_validade = :dta_fim_validade');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      {$ENDIF}
      Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      On E: exception do
      begin
        Rollback;
        Mensagens.Adicionar(575, Self.ClassName, 'Excluir', [E.Message]);
        Result := -575;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;


{*

   @param ENomPessoa String
   @param ENomReduzidoPessoa String
   @param ECodNaturezaPessoa String
   @param ENumCNPJCPF String
   @param EDtaNascimento TDateTime
   @param ETxtObservacao String
   @param ECodPapel Integer
   @param ESglProdutor String
   @param ECodGrauInstrucao Integer
   @param EDesCursoSuperior String
   @param ESglConselhoRegional String
   @param ENumConselhoRegional String
   @param ECodPessoaGestor Integer

   @return CodPessoa Valor retornado quando o método for executado com sucesso.
   @return -188 Valor retornadoo quando o usuário que estiver executando o
                método não possuir permissão para executá-lo.
   @return -416 Valor retornado quando o parâmetro ECodNaturezaPessoa contiver
                um valor diferente de "F" ou "J".
   @return -426 Valor retornado quando o parâmetro ENumCNPJCPF contiver um valor
                inválido (CPF ou CNPJ)
   @return -551 Valor retornado quando a pessoa a ser inserida for uma pessoa
                física, e sua data de nascimento (EDtaNascimento) não foi
                informada.
   @return -553 Valor retornado quando a pessoa a ser cadastrada, já estiver
                previamente cadastrada. Atentar para o fato de que poderemos ter
                a situação de dois registros com o campo num_cnpj_cpf iguais, porém
                os valores do campo dta_fim_validade com valores distintos.
   @return -555 Valor retornado quando a pessoa a ser inserida tiver papel
                diferente de técnico e um dos campos ECodGrauInstrucao ou
                EDesCursoSuperior ou ENumConselhoRegional, tiver algum valor
                válido.
   @return -1069 Valor retornado quando a pessoa a ser inserida for uma pessoa
                 física, e sua deta de nascimento for maior ou igual a data do
                 sistema.
   @return -2188 Valor retornado quando o parâmetro ECodPessoaGestor não foi
                 informado.
   @return -2189 Valor informando quando o gestor informado for inválido.
   @return -2190 Valor retornado quando um usuário com perfil diferente de
                 funcionário tentar inserir uma pessoa com papel de gestor.

   @return -554 Valor retornado quando durante a execução do método ocorrer
                uma exceção.
}
function TIntPessoas.Inserir(ENomPessoa,
                             ENomReduzidoPessoa,
                             ECodNaturezaPessoa,
                             ENumCNPJCPF: String;
                             EDtaNascimento: TDateTime;
                             ETxtObservacao: String;
                             ECodPapel: Integer;
                             ESglProdutor: String;
                             ECodGrauInstrucao: Integer;
                             EDesCursoSuperior,
                             ESglConselhoRegional,
                             ENumConselhoRegional: String;
                             ECodPessoaGestor: Integer;
                             ESexo: String;
                             ENumIE: String;
                             EOrgaoIE: String;
                             EUFIE: String;
                             EDtaExp: TDateTime): Integer;
const
  NomMetodo: String = 'Inserir';
  Metodo: Integer = 199;
var
  Q : THerdomQuery;
  NumCNPJCPFSemDv : String;
  CodPessoa, CodRegistroLog: Integer;
  IndGestorObrigatorio: String;
  PesquisaCPFCNPJ : boolean;
begin
  Result := -1;
  PesquisaCPFCNPJ := True;

  if not Inicializado then
  begin
    RaiseNaoInicializado('Inserir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  end;

  // Trata nome da pessoa
  Result := VerificaString(ENomPessoa, 'Nome da Pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  Result := TrataString(ENomPessoa, 100, 'Nome da Pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  // Trata nome reduzido da pessoa
  Result := VerificaString(ENomReduzidoPessoa, 'Nome reduzido da pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  Result := TrataString(ENomReduzidoPessoa, 15, 'Nome reduzido da pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  // Trata Natureza
  Result := VerificaString(ECodNaturezaPessoa, 'Natureza da Pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  Result := TrataString(ECodNaturezaPessoa, 1, 'Natureza da Pessoa');
  if Result < 0 then
  begin
    Exit;
  end;

  if not (ECodNaturezaPessoa[1] in ['F', 'J']) then
  begin
    Mensagens.Adicionar(416, Self.ClassName, 'Inserir', []);
    Result := -416;
    Exit;
  end;

  // Trata número CNPJ ou CPF
  if ECodNaturezaPessoa = 'F' then
  begin
    Result := VerificaString(ENumCNPJCPF, 'Número CPF');
    if Result < 0 then
    begin
      Exit;
    end;

    Result := TrataString(ENumCNPJCPF,11, 'Número CPF');
    if Result < 0 then Exit;
    NumCNPJCPFSemDv := Copy(ENumCNPJCPF,1,9);

    if ((length(ESexo) > 0) and (UpperCase(ESexo) <> 'F')) and ((length(ESexo) > 0) and (UpperCase(ESexo) <> 'M')) then begin
      Mensagens.Adicionar(2280, Self.ClassName, 'Inserir', []);
      Result := -2280;
      Exit;
    end;
  end
  else
  begin
    Result := VerificaString(ENumCNPJCPF, 'Número CNPJ');
    if Result < 0 then
    begin
      Exit;
    end;

    Result := TrataString(ENumCNPJCPF,14, 'Número CNPJ');
    NumCNPJCPFSemDv := Copy(ENumCNPJCPF,1,12);

    if (length(ESexo) > 0) and (length(ENumIE) > 0) and (length(EOrgaoIE) > 0) and (length(EUFIE) > 0) and (EDtaExp > 0) then begin
      Mensagens.Adicionar(2279, Self.ClassName, 'Inserir', []);
      Result := -2279
    end;
  end;
  if Result < 0 then
  begin
    Exit;
  end;

  if not VerificarCnpjCpf(NumCNPJCPFSemDv, ENumCNPJCPF, ValorParametro(128)) then
  begin
    Mensagens.Adicionar(424, Self.ClassName, 'Inserir', []);
    Result := -424;
    Exit;
  end;

  // Consiste Data de Nascimento
  if (ECodNaturezaPessoa <> 'F') and (EDtaNascimento > 0) then
  begin
    Mensagens.Adicionar(551, Self.ClassName, 'Inserir', []);
    Result := -551;
    Exit;
  end
  else if (ECodNaturezaPessoa = 'F') and (EDtaNascimento >= Date) then
  begin
    Mensagens.Adicionar(1069, Self.ClassName, 'Inserir', []);
    Result := -1069;
    Exit;
  end;

{
  // Trata Observação
  if ETxtObservacao <> '' then
  begin
    Result := TrataString(ETxtObservacao, 255, 'Observação');
    if Result < 0 then
    begin
      Exit;
    end;
  end;
}
  // Trata Sigla de produtor se a mesma foi informada
  if ESglProdutor <> '' then
  begin
    Result := VerificaNumLetra(ESglProdutor, 5, 'Sigla do Produtor');
    if Result < 0 then begin
      Exit;
    end;
  end;

  if ECodPapel = -1 then
  begin
    Mensagens.Adicionar(2226, Self.ClassName, 'Inserir', []);
    Result := -2226;
    Exit;
  end;

  // Tratando dados referentes ao papel informado para inserção
  if ECodPapel > 0 then begin
    if ((ECodGrauInstrucao > 0) or
        (EDesCursoSuperior <> '') or
        (ESglConselhoRegional <> '') or
        (ENumConselhoRegional <> '')) and
        (ECodPapel <> 3) then
    begin
      Mensagens.Adicionar(555, Self.ClassName, 'Inserir', []);
      Result := -555;
      Exit;
    end;
    if ECodPapel = 3 then
    begin
      IndGestorObrigatorio := ValorParametro(108);
      if (UpperCase(IndGestorObrigatorio) = 'S') and (ECodPessoaGestor <= 0) then
      begin
        Mensagens.Adicionar(2188, Self.ClassName, NomMetodo, []);
        Result := -2188;
        Exit;
      end;

      if Conexao.CodPapelUsuario = 9 then
      begin
        if ECodPessoaGestor <= 0 then
        begin
          ECodPessoaGestor := Conexao.CodPessoa;
        end
        else if ECodPessoaGestor <> Conexao.CodPessoa then
        begin
          Mensagens.Adicionar(2198, Self.ClassName, NomMetodo, []);
          Result := -2198;
          Exit;
        end;
      end;

      // Trata Grau de instrução
      if (ECodGrauInstrucao = 0) then
      begin
        Result := VerificaString('', 'Para o papel de "Técnico", o grau de instrução');
        if Result < 0 then
        begin
          Exit;
        end;
      end;
      // Trata Descrição do curso superior
      if EDesCursoSuperior <> '' then
      begin
        Result := TrataString(EDesCursoSuperior, 30, 'Descrição do Curso Superior');
        if Result < 0 then
        begin
          Exit;
        end;
      end;
      // Trata Sigla do conselho regional
      if ESglConselhoRegional <> '' then
      begin
        Result := TrataString(ESglConselhoRegional, 10, 'Sigla do Conselho Regional');
        if Result < 0 then
        begin
          Exit;
        end;
      end;
      // Trata Número conselho regional
      if ENumConselhoRegional <> '' then
      begin
        Result := TrataString(ENumConselhoRegional, 15, 'Número Conselho Regional');
        if Result < 0 then
        begin
          Exit;
        end;
      end;
    end
    else if ECodPapel = 4 then {Produtor}
    begin
      Result := VerificaString(ESglProdutor, 'Sigla do produtor');
      if Result < 0 then
      begin
        Exit;
      end;

      Result := TrataString(ESglProdutor, 5, 'Sigla do produtor');
      if Result < 0 then
      begin
        Exit;
      end;      
    end
    else if ECodPapel = 8 then
    begin
      if (Conexao.CodPapelUsuario <> 2) and (ECodPessoaGestor > 0) then
      begin
        Mensagens.Adicionar(2190, Self.ClassName, NomMetodo, []);
        Result := -2190;
        Exit;
      end;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      if (ECodNaturezaPessoa = 'J') and (
        (ENumCNPJCPF = '00000000000000') or
        (ENumCNPJCPF = '11111111111111') or
        (ENumCNPJCPF = '22222222222222') or
        (ENumCNPJCPF = '33333333333333') or
        (ENumCNPJCPF = '44444444444444') or
        (ENumCNPJCPF = '55555555555555') or
        (ENumCNPJCPF = '66666666666666') or
        (ENumCNPJCPF = '77777777777777') or
        (ENumCNPJCPF = '88888888888888') or
        (ENumCNPJCPF = '99999999999999')) and (ValorParametro(128) = 'S') then begin

        PesquisaCPFCNPJ := False;
      end else if (
        (ENumCNPJCPF = '00000000000') or
        (ENumCNPJCPF = '11111111111') or
        (ENumCNPJCPF = '22222222222') or
        (ENumCNPJCPF = '33333333333') or
        (ENumCNPJCPF = '44444444444') or
        (ENumCNPJCPF = '55555555555') or
        (ENumCNPJCPF = '66666666666') or
        (ENumCNPJCPF = '77777777777') or
        (ENumCNPJCPF = '88888888888') or
        (ENumCNPJCPF = '99999999999')) and (ValorParametro(128) = 'S') then begin

        PesquisaCPFCNPJ := False;
      end;

      if (PesquisaCPFCNPJ) then begin
        // Verifica duplicidade de número de CNPJCPF
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pessoa ');
        Q.SQL.Add('where num_cnpj_cpf = :num_cnpj_cpf ');
        Q.SQL.Add('  and dta_fim_validade is null ');
        {$ENDIF}
        Q.ParamByName('num_cnpj_cpf').AsString := ENumCNPJCPF;
        Q.Open;

        if not Q.IsEmpty then
        begin
          Mensagens.Adicionar(553, Self.ClassName, 'Inserir', [ENumCNPJCPF]);
          Result := -553;
          Exit;
        end;
        Q.Close;
      end;

      if (ECodPessoaGestor > 0) and (ECodPapel = 3) then
      begin
        // verifica se o gestor informado é válido
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_pessoa');
        Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
        Q.ParamByName('cod_pessoa').AsInteger := ECodPessoaGestor;
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(2189, Self.ClassName, NomMetodo, []);
          Result := -2189;
          Exit;
        end;
      end;

      // Abre transação
      beginTran;

      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_pessoa), 0) + 1 as cod_pessoa ');
      Q.SQL.Add('  from tab_pessoa ');
      {$ENDIF}
      Q.Open;
      CodPessoa := Q.FieldByName('cod_pessoa').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 then
      begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_pessoa            ');
      Q.SQL.Add(' (cod_pessoa,                     ');
      Q.SQL.Add('  nom_pessoa,                     ');
      Q.SQL.Add('  nom_reduzido_pessoa,            ');
      Q.SQL.Add('  cod_natureza_pessoa,            ');
      Q.SQL.Add('  num_cnpj_cpf,                   ');
      Q.SQL.Add('  dta_nascimento,                 ');
      Q.SQL.Add('  cod_tipo_endereco,              ');
      Q.SQL.Add('  nom_logradouro,                 ');
      Q.SQL.Add('  nom_bairro,                     ');
      Q.SQL.Add('  num_cep,                        ');
      Q.SQL.Add('  cod_pais,                       ');
      Q.SQL.Add('  cod_estado,                     ');
      Q.SQL.Add('  cod_municipio,                  ');
      Q.SQL.Add('  cod_distrito,                   ');
      Q.SQL.Add('  txt_observacao,                 ');
      Q.SQL.Add('  dta_cadastramento,              ');
      Q.SQL.Add('  ind_sexo,                       ');
      Q.SQL.Add('  num_identidade,                 ');
      Q.SQL.Add('  orgao_expedicao,                ');
      Q.SQL.Add('  uf_expedicao,                   ');
      Q.SQL.Add('  dta_expedicao,                  ');
      Q.SQL.Add('  cod_registro_log,               ');
      Q.SQL.Add('  dta_fim_validade)               ');
      Q.SQL.Add('values                            ');
      Q.SQL.Add(' (:cod_pessoa,                    ');
      Q.SQL.Add('  :nom_pessoa,                    ');
      Q.SQL.Add('  :nom_reduzido_pessoa,           ');
      Q.SQL.Add('  :cod_natureza_pessoa,           ');
      Q.SQL.Add('  :num_cnpj_cpf,                  ');
      Q.SQL.Add('  :dta_nascimento,                ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  null,                           ');
      Q.SQL.Add('  :txt_observacao,                ');
      Q.SQL.Add('  getdate(),                      ');
      Q.SQL.Add('  :ind_sexo,                      ');
      Q.SQL.Add('  :num_identidade,                ');
      Q.SQL.Add('  :orgao_expedicao,               ');
      Q.SQL.Add('  :uf_expedicao,                  ');
      Q.SQL.Add('  :dta_expedicao,                 ');
      Q.SQL.Add('  :cod_registro_log,              ');
      Q.SQL.Add('  null)                           ');
      {$ENDIF}

      Q.ParamByName('cod_pessoa').AsInteger         := CodPessoa;
      Q.ParamByName('nom_pessoa').AsString          := ENomPessoa;
      Q.ParamByName('nom_reduzido_pessoa').AsString := ENomReduzidoPessoa;
      Q.ParamByName('cod_natureza_pessoa').AsString := ECodNaturezaPessoa;
      Q.ParamByName('ind_sexo').AsString            := UpperCase(ESexo);
      Q.ParamByName('num_identidade').AsString      := ENumIE;
      Q.ParamByName('orgao_expedicao').AsString     := EOrgaoIE;
      Q.ParamByName('uf_expedicao').AsString        := EUFIE;
      Q.ParamByName('num_cnpj_cpf').AsString        := ENumCNPJCPF;
      Q.ParamByName('cod_registro_log').AsInteger   := CodRegistroLog;
      Q.ParamByName('dta_nascimento').DataType      := ftDateTime;
      Q.ParamByName('txt_observacao').DataType      := ftString;
      Q.ParamByName('dta_expedicao').DataType       := ftDateTime;
      AtribuiValorParametro(Q.ParamByName('dta_expedicao') , EDtaExp);
      AtribuiValorParametro(Q.ParamByName('dta_nascimento'), EDtaNascimento);
      AtribuiValorParametro(Q.ParamByName('txt_observacao'), ETxtObservacao);
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa', CodRegistroLog, 1, Metodo);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      if ECodPapel > 0 then
      begin
        Result := AdicionarPapel(CodPessoa,
                                 ECodPapel,
                                 ESglProdutor,
                                 ECodGrauInstrucao,
                                 EDesCursoSuperior,
                                 ESglConselhoRegional,
                                 ENumConselhoRegional,
                                 ECodPessoaGestor,
                                 'S');
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;
      end;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodPessoa;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(554, Self.ClassName, 'Inserir', [E.Message]);
        Result := -554;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;


{* Função responsável por retornar dados de pessoas cadastradas no sistema.
   O result set retornado é composto por: CodPessoa, NomPessoa, CodPapel,
                                          DesPapel, CodNaturezaPessoa,
                                          NumCNPJCPF, SglProdutor,
                                          NumCNPJCPFFormatado, DtaFimValidade

   @param ECodPessoa Integer Parâmetro opcional. Quando informado deverá filtrar
                             por uma única pessoa e retorná-los num result set.
   @param ENomPessoa String Parâmetro opcional. Quando informado deverá filtrar
                            por nomes que se assimilem ao parâmetro (like), e
                            retorná-los em um result set.
   @param ECodPapel Integer Parâmetro opcional. Quando informado deverá filtrar
                            pelo papel informado, retornando num result set todas
                            as pessoas que estiverem associadas ao papel
                            especificado. Lembrando que uma pessoa pode não ter
                            papel associado, ou também ter mais de um papel
                            associado.
   @param ECodNaturezaPessoa String Parâmetro opcional (F ou J ou ""). Quando
                                    informado deverá filtrar pela natureza da
                                    pessoa (física ou jurídica), retornando num
                                    result set o resultado da pesquisa.
   @param ENumCNPJCPF String Parâmetro opcional. Quando informado deverá filtrar
                             pelo campo num_cnpj_cpf da tab_pessoa, retornado num
                             result set, os registros encontrados.
   @param EIndBloqueio String Parâmetro obrigatório (S ou N). Quando informado deverá
                              filtrar pelo status de produtor bloqueado ou não.
                              Vale ressaltar que este parâmetro só é válido para
                              pessoas com papel de produtor.
   @param EIndIncluirCertificadoraDonaSistema String Parâmetro obrigatório (S ou
                                                     N). Quando o valor do parâmetro
                                                     for "N", então a pessoa
                                                     representada pela certificadora
                                                     deverá ser excluída do
                                                     result set. Caso o valor seja
                                                     "S", a pessoa representada
                                                     pela certificadora deverá ser
                                                     incluída no result set.
   @param EIndPesquisarDesativados Boolean Parâmetro obrigatório (True ou False).
                                           Quando o valor informado for "True",
                                           a pesquisa na tab_pessoa, deverá filtrar
                                           pelo campo dta_fim_validade que for
                                           igual a "null". Caso o valor seja
                                           "False" o campo dta_fim_validade que
                                           for diferente "null".
   @param ESglProdutor String Parâmetro opcional. Quando o valor for informado,
                              filtrar por pessoas que tenham o papel de produtor,
                              e que o campo sgl_produtor seja semelhante a sigla
                              informada (like).
   @param ECodOrdenacao String Parâmetro opcional (S ou demais valores). Caso o
                               valor informado seja igual a "S", a pesquisa
                               deverá ser ordenada pelo campo sgl_produtor. Caso
                               contrário o result set será ordenado pelo campo
                               nom_pessoa.
   @param EIndCadastroEfetivado String Parâmetro obrigatório (S ou N). Caso o
                                       valor informado seja igual a "S", então a
                                       pesquisa será restringida pelo campo
                                       dta_efetivacao_cadastro que não estejam
                                       nulos. Caso o valor seja igual a "N" então
                                       a pesquisa deverá ser restringida pelo
                                       campo dta_efetivacao_cadastro igual a null
   @param EIndExportadoSisbov String Parâmetro obrigatório (S ou N). Filtro
                                     aplicado somente a pessoas que tenham o
                                     papel de produtor. Quando o valor do
                                     parâmetro for igual a "S", então dever-se-á
                                     pesquisar na tab_localizacao_sisbov, por um
                                     registro que contenha o campo
                                     cod_arquivo_sisbov com um valor válido. Caso
                                     o valor informado no parâmetro seja igual a
                                     "N", dever-se-á pesquisar por registros que
                                     contenham o campo cod_arquivo_sisbov da
                                     tab_localizacao_sisbov, igual a null, ou
                                     não exista na tab_localizacao_sisbov.
   @param ECodTipoAcessoNaoDesejado String Parâmetro obrigatório (C, N, P ou T).
                                           Quando o parâmetro for informado, filtrar
                                           pelo tipo de acesso de cada papel, de
                                           acordo com os valores indicados acima.   

   @return 0 Valor retornado quando a execução do método ocorrer com sucesso.
   @return -188 Valor retornado quando o usuário que for executar o método
                (usuário logado no sistema) não possuir acesso ao método, ou seja,
                o usuário não tem acesso ao método.
   @return -182 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.
}
function TIntPessoas.Pesquisar(ECodPessoa: Integer;
                               ENomPessoa: String;
                               ECodPapel: Integer;
                               ECodNaturezaPessoa,
                               ENumCNPJCPF,
                               EIndBloqueio,
                               EIndIncluirCertificadoraDonaSistema: String;
                               EIndPesquisarDesativados: WordBool;
                               ESglProdutor,
                               ECodOrdenacao,
                               EIndCadastroEfetivado,
                               EIndExportadoSisbov,
                               ECodTipoAcessoNaoDesejado: String): Integer;
var
  sSQLUnion: String;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(35) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  end;

  ESglProdutor := Trim(ESglProdutor);
  sSQLUnion := '';

  try
    Query.Close;
    {$IFDEF MSSQL}
    Query.SQL.Clear;
    Query.SQL.Add('select pes.cod_pessoa           as CodPessoa, ');
    Query.SQL.Add('       pes.nom_pessoa           as NomPessoa, ');
    Query.SQL.Add('       pap.cod_papel            as CodPapel, ');
    Query.SQL.Add('       pap.des_papel            as DesPapel, ');
    Query.SQL.Add('       pes.cod_natureza_pessoa  as CodNaturezaPessoa, ');
    Query.SQL.Add('       pes.num_cnpj_cpf         as NumCNPJCPF,');
    Query.SQL.Add('       prod.sgl_produtor        as SglProdutor,');
    Query.SQL.Add('       case pes.cod_natureza_pessoa ');
    Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 1, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 4, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 7, 3) + ''-'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 10, 2)) ');
    Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 1, 2) + ''.'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 3, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 6, 3) + ''/'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 9, 4) + ''-'' + ');
    Query.SQL.Add('                             substring(pes.num_cnpj_cpf, 13, 2)) ');
    Query.SQL.Add('       end as NumCNPJCPFFormatado, ');
    Query.SQL.Add('       pes.dta_fim_validade as DtaFimValidade ');
    Query.SQL.Add('from tab_pessoa pes ');
    Query.SQL.Add('   , tab_pessoa_papel pap_pes ');
    Query.SQL.Add('   , tab_produtor prod ');
    if ECodPapel = 3 then begin
      Query.SQL.Add('   , tab_tecnico tt ');
    end;
    Query.SQL.Add('   , tab_papel pap ');
    Query.SQL.Add('where pes.cod_pessoa = pap_pes.cod_pessoa ');
    Query.SQL.Add('  and pap.cod_papel  = pap_pes.cod_papel ');
    Query.SQL.Add('  and pap_pes.dta_fim_validade is null ');

    if ECodTipoAcessoNaoDesejado <> '' then
    begin
      Query.SQL.Add('  and pap.cod_tipo_acesso != :cod_tipo_acesso ');
    end;

    if UpperCase(EIndIncluirCertificadoraDonaSistema) <> 'S' then
    begin
      Query.SQL.Add('  and not (pes.cod_pessoa = :cod_certificadora_dona_sistema and pap.cod_papel = 5)');
    end;

    if ECodPapel = 4 then
    begin
      Query.SQL.Add('  and prod.cod_pessoa_produtor = pes.cod_pessoa ');
    end
    else
    begin
      Query.SQL.Add('  and prod.cod_pessoa_produtor =* pes.cod_pessoa ');
    end;

    if ECodPapel = 3 then
    begin
      Query.SQL.Add('  and tt.cod_pessoa_tecnico = pes.cod_pessoa ');

      if EIndCadastroEfetivado = 'S' then
      begin
        Query.SQL.Add('  and tt.dta_efetivacao_cadastro is not null');
      end
      else if EIndCadastroEfetivado = 'N' then
      begin
        Query.SQL.Add('  and tt.dta_efetivacao_cadastro is null');
      end;
      if EIndExportadoSisbov = 'S' then
      begin
        Query.SQL.Add('  and exists (select top 1 1 from tab_tecnico ' +
                      '               where cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                      '                 and cod_arquivo_sisbov is not null) ');
      end
      else if EIndExportadoSisbov = 'N' then
      begin
        Query.SQL.Add('  and not exists (select top 1 1 from tab_tecnico ' +
                      '                   where cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                      '                     and cod_arquivo_sisbov is not null) ');
      end;
    end;

    if ECodPapel = 4 then
    begin
      if (Uppercase(EIndBloqueio) = 'S') or (Uppercase(EIndBloqueio) = 'N') then
      begin
        Query.SQL.Add('  and prod.ind_produtor_bloqueado = :ind_produtor_bloqueado ');
      end;
      if (ESglProdutor <> '') then
      begin
        Query.SQL.Add('  and prod.sgl_produtor like :sgl_produtor');
      end;
      if EIndCadastroEfetivado = 'S' then
      begin
        Query.SQL.Add('  and prod.dta_efetivacao_cadastro is not null');
      end
      else if EIndCadastroEfetivado = 'N' then
      begin
        Query.SQL.Add('  and prod.dta_efetivacao_cadastro is null');
      end;
      if EIndExportadoSisbov = 'S' then
      begin
        Query.SQL.Add('  and exists (select top 1 1 from tab_localizacao_sisbov ' +
                      '               where cod_pessoa_produtor = prod.cod_pessoa_produtor ' +
                      '                 and cod_arquivo_sisbov is not null) ');
      end
      else if EIndExportadoSisbov = 'N' then
      begin
        Query.SQL.Add('  and not exists (select top 1 1 from tab_localizacao_sisbov ' +
                      '                   where cod_pessoa_produtor = prod.cod_pessoa_produtor ' +
                      '                     and cod_arquivo_sisbov is not null) ');
      end;
    end;

    Query.SQL.Add('   and ( (pes.cod_pessoa = :cod_pessoa) or (:cod_pessoa = -1)) ');

    if ENomPessoa <> '' then
    begin
      Query.SQL.Add('   and pes.nom_pessoa like :nom_pessoa ');
      sSQLUnion := sSQLUnion + '   and pes.nom_pessoa like :nom_pessoa ';
    end;

    Query.SQL.Add('   and ( (pap.cod_papel = :cod_papel) or (:cod_papel = -1)) ');

    if (UpperCase(ECodNaturezaPessoa) = 'F') or
       (UpperCase(ECodNaturezaPessoa) = 'J') then
    begin
      Query.SQL.Add('   and pes.cod_natureza_pessoa = :cod_natureza_pessoa ');
      sSQLUnion := sSQLUnion + '   and pes.cod_natureza_pessoa = :cod_natureza_pessoa ';
    end;

    if ENumCNPJCPF <> '' then
    begin
      Query.SQL.Add('   and pes.num_cnpj_cpf like :num_cnpj_cpf ');
      sSQLUnion := sSQLUnion + '   and pes.num_cnpj_cpf like :num_cnpj_cpf ';
    end;

    Query.SQL.Add('   and ((pes.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ');

    // caso o usuário tenha papel de técnico, deverá ser listada apenas as
    // pessoas que sejam produtores e estejam associados a ele.
    if (Conexao.CodPapelUsuario = 3) then
    begin
      if ECodPapel <> 8 then
      begin
        Query.SQL.Add(' and pes.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa');
        Query.SQL.Add('                           from tab_tecnico_produtor ttp');
        Query.SQL.Add('                          where ttp.dta_fim_validade is null');
        Query.SQL.Add('                            and ttp.cod_pessoa_tecnico = :cod_pessoa_tecnico ) ');
        Query.SQL.Add(' and pap_pes.cod_papel in (4) ');
      end;
    end;

    if ECodPapel <> 8 then
    begin
      // caso o usuário tenha papel de gestpr, deverá ser listada apenas as
      // pessoas que sejam produtores e ténicos e estejam associados ao gestor.
      if (Conexao.CodPapelUsuario = 9) then
      begin
        if (ECodPapel < 0) then
        begin
          Query.SQL.Add(' and pes.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa');
          Query.SQL.Add('                           from tab_tecnico_produtor ttp');
          Query.SQL.Add('                              , tab_tecnico tt');
          Query.SQL.Add('                          where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico');
          Query.SQL.Add('                            and ttp.dta_fim_validade is null');
          Query.SQL.Add('                            and tt.dta_fim_validade is null');
          Query.SQL.Add('                            and tt.cod_pessoa_gestor = :cod_pessoa_gestor');
          Query.SQL.Add('                          union');
          Query.SQL.Add('                          select tt.cod_pessoa_tecnico as cod_pessoa');
          Query.SQL.Add('                           from tab_tecnico tt');
          Query.SQL.Add('                          where tt.dta_fim_validade is null');
          Query.SQL.Add('                            and tt.cod_pessoa_gestor = :cod_pessoa_gestor ) ');
          Query.SQL.Add(' and pap_pes.cod_papel in (3, 4) ');
        end
        else
        begin
          Query.SQL.Add(' and pes.cod_pessoa in ( select tt.cod_pessoa_tecnico as cod_pessoa');
          Query.SQL.Add('                           from tab_tecnico tt');
          Query.SQL.Add('                          where tt.dta_fim_validade is null');
          Query.SQL.Add('                            and tt.cod_pessoa_gestor = :cod_pessoa_gestor ) ');
        end;
      end;
    end;


    if (ECodPapel < 0) and (ECodTipoAcessoNaoDesejado = '') then
    begin
      // Se nenhum papel foi informado então todas pessoas devem ser lista
      // * Este porção do select adiciona ao result set as pessoas que não possuem papel
      sSQLUnion := ' union all ' +
                   '    select pes.cod_pessoa           as CodPessoa, ' +
                   '           pes.nom_pessoa           as NomPessoa, ' +
                   '           null            	        as CodPapel, ' +
                   '           null  		                as DesPapel, ' +
                   '           pes.cod_natureza_pessoa  as CodNaturezaPessoa, ' +
                   '           pes.num_cnpj_cpf         as NumCNPJCPF, ' +
                   '           null                     as SglProdutor, ' +
                   '           case pes.cod_natureza_pessoa ' +
                   '             when ''F'' then convert(varchar(18), ' +
                   '                                 substring(pes.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 10, 2)) ' +
                   '             when ''J'' then convert(varchar(18), ' +
                   '                                 substring(pes.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                   '                                 substring(pes.num_cnpj_cpf, 13, 2)) ' +
                   '           end as NumCNPJCPFFormatado, ' +
                   '           pes.dta_fim_validade as dtaFimValidade ' +
                   '    from tab_pessoa pes ' +
                   '    where ' +
                   '       ((pes.cod_pessoa = :cod_pessoa) or (:cod_pessoa = -1)) ' +
                   '       and ((pes.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ' +
                   '       and not exists (select 1 from tab_pessoa_papel where cod_pessoa = pes.cod_pessoa and dta_fim_validade is null) ' +
                   sSQLUnion;
      Query.SQL.Add(sSQLUnion);
    end;

    if (ECodOrdenacao = 'S') then
    begin
      Query.SQL.Add('order by prod.sgl_produtor ');
    end
    else
    begin
      Query.SQL.Add('order by pes.nom_pessoa ');
    end;
    {$ENDIF}

    Query.ParamByName('cod_pessoa').AsInteger := ECodPessoa;

    if ECodTipoAcessoNaoDesejado <> '' then
    begin
      Query.ParamByName('cod_tipo_acesso').AsString := ECodTipoAcessoNaoDesejado;
    end;

    if ENomPessoa <> '' then
    begin
      Query.ParamByName('nom_pessoa').AsString      := '%' + ENomPessoa + '%';
    end;

    Query.ParamByName('cod_papel').AsInteger := ECodPapel;

    if (UpperCase(ECodNaturezaPessoa) = 'F') or
       (UpperCase(ECodNaturezaPessoa) = 'J') then
    begin
      Query.ParamByName('cod_natureza_pessoa').AsString  := ECodNaturezaPessoa;
    end;

    if ENumCNPJCPF <> '' then
    begin
      Query.ParamByName('num_cnpj_cpf').AsString := ENumCNPJCPF + '%';
    end;

    if ECodPapel = 4 then
    begin
      if (Uppercase(EIndBloqueio) = 'S') or (Uppercase(EIndBloqueio) = 'N') then
      begin
        Query.ParamByName('ind_produtor_bloqueado').AsString := EIndBloqueio;
      end;
      if (ESglProdutor <> '') then
      begin
        Query.ParamByName('sgl_produtor').AsString := '%' + ESglProdutor + '%';
      end;
    end;

    if EIndPesquisarDesativados then
    begin
      Query.ParamByName('ind_pesquisar_desativados').AsInteger := 1;
    end
    else
    begin
      Query.ParamByName('ind_pesquisar_desativados').AsInteger := 0;
    end;

    // Verifica se inclui ou não a certificadora dona do sistema no ResultSet
    if UpperCase(EIndIncluirCertificadoraDonaSistema) <> 'S' then
    begin
      Query.ParamByName('cod_certificadora_dona_sistema').AsInteger := StrToInt(ValorParametro(4));
    end;

    if (Conexao.CodPapelUsuario = 3) and (ECodPapel <> 8) then
    begin
      Query.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
    end;

    if (Conexao.CodPapelUsuario = 9) and (ECodPapel <> 8) then
    begin
      Query.ParamByName('cod_pessoa_gestor').AsInteger := Conexao.CodPessoa;
    end;

    Query.Open;
    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(182, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -182;
      Exit;
    end;
  end;
end;

function TIntPessoas.PossuiPapel(CodPessoa, CodPapel: Integer): Integer;
const
  Metodo: Integer = 208;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('PossuiPapel');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PossuiPapel', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

     // Consiste Pessoa
       Q.SQL.Clear;
{$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_pessoa');
       Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
       Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
       Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
       Q.Open;
       if Q.IsEmpty then begin
         Mensagens.Adicionar(212, Self.ClassName, 'PossuiPapel', []);
         Result := -212;
         Exit;
       end;
       Q.Close;

       // Consiste Papel
       Q.SQL.Clear;
{$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_papel');
       Q.SQL.Add(' where cod_papel = :cod_papel');
{$ENDIF}
       Q.ParamByName('cod_papel').AsInteger := CodPapel;
       Q.Open;
       if Q.IsEmpty then begin
         Mensagens.Adicionar(591, Self.ClassName, 'PossuiPapel', []);
         Result := -591;
         Exit;
       end;
       Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_papel');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and cod_papel = :cod_papel');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger  := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;

      if not Q.IsEmpty then begin
        // Consiste existência dos registros nas tabelas específicas

        if CodPapel = 1 then begin {Associacao}

          Q.Close;
          // Verifica existencia do registro na tab_associacao
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_associacao');
          Q.SQL.Add(' where cod_pessoa_associacao = :cod_pessoa');
          Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(598, Self.ClassName, 'PossuiPapel', []);
            Result := -598;
            Exit;
          end;

        end else if CodPapel = 2 then begin {Funcionário}

          Q.Close;
          // Verifica existencia do registro na tab_funcionario
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_funcionario');
          Q.SQL.Add(' where cod_pessoa_funcionario = :cod_pessoa');
          Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(598, Self.ClassName, 'PossuiPapel', []);
            Result := -598;
            Exit;
          end;

        end else if CodPapel = 3 then begin {Técnico}

          Q.Close;
          // Verifica existencia do registro na tab_tecnico
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_tecnico');
          Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa');
          Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(598, Self.ClassName, 'PossuiPapel', []);
            Result := -598;
            Exit;
          end;

        end else if CodPapel = 4 then begin {Produtor}

          Q.Close;
          // Verifica existencia do registro na tab_produtor
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_produtor');
          Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa');
          Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(598, Self.ClassName, 'PossuiPapel', []);
            Result := -598;
            Exit;
          end;

        end;

        Q.Close;
        Result := 1;
      end else begin
        Result := 0;
      end;

    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(599, Self.ClassName, 'PossuiPapel', [E.Message]);
        Result := -599;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntPessoas.RetirarPapel(CodPessoa, CodPapel: Integer): Integer;
const
  Metodo: Integer = 204;
var
  Q: THerdomQuery;
  CodRegistroLog: Integer;
  dDtaFimValidade: TDateTime;
//  bProdutorEfetivado: Boolean;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('RetirarPapel');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarPapel', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Consiste Pessoa
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'RetirarPapel', []);
        Result := -212;
        Exit;
      end;
      Q.Close;

      // Consiste Papel
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_papel');
      Q.SQL.Add(' where cod_papel = :cod_papel');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(591, Self.ClassName, 'RetirarPapel', []);
        Result := -591;
        Exit;
      end;
      Q.Close;

       // Consiste se pessoa possui o papel informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  getdate() as DtaFimValidade');
      Q.SQL.Add('  , cod_registro_log as CodRegistroLog');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa_papel');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_papel = :cod_papel');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger  := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
         Mensagens.Adicionar(593, Self.ClassName, 'RetirarPapel', []);
         Result := -593;
         Exit;
      end;
      dDtaFimValidade := Q.FieldByName('DtaFimValidade').AsDateTime;
      CodRegistroLog  := Q.FieldByName('CodRegistroLog').AsInteger;
      Q.Close;

       // Consiste se existe um usuário válido para a pessoa e o papel informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_usuario');
      Q.SQL.Add('  where cod_pessoa  = :cod_pessoa');
      Q.SQL.Add('    and cod_papel = :cod_papel');
      Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger  := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if not Q.IsEmpty then begin
         Mensagens.Adicionar(594, Self.ClassName, 'RetirarPapel', []);
         Result := -594;
         Exit;
      end;

      // Consistindo informações para produtor rural
      if CodPapel = 4 then begin {Produtor}

        // Consiste se o produtor não tem seu cadastro efetivado
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select dta_efetivacao_cadastro from tab_produtor ' +
                  ' where cod_pessoa_produtor = :cod_pessoa ' +
                  '   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.FieldByName('dta_efetivacao_cadastro').IsNull then begin
          Mensagens.Adicionar(557, Self.ClassName, 'RetirarPapel', []);
          Result := -557;
          Exit;
        end;

        // Consiste se existem fazendas ativas para o produtor
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_fazenda');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(564, Self.ClassName, 'RetirarPapel', []);
          Result := -564;
          Exit;
        end;

        // Consiste se existem lotes ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_lote');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(565, Self.ClassName, 'RetirarPapel', []);
          Result := -565;
          Exit;
        end;

        // Consiste se existem locais ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_local');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(566, Self.ClassName, 'RetirarPapel', []);
          Result := -566;
          Exit;
        end;

        // Consiste se existem animais ativos para o produtor
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_animal');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(567, Self.ClassName, 'RetirarPapel', []);
          Result := -567;
          Exit;
        end;

        // Consiste se existem pessoas secundárias ativas para o produtor
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pessoa_secundaria');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(568, Self.ClassName, 'RetirarPapel', []);
          Result := -568;
          Exit;
        end;

        // Consiste se o produtor é atendido por algum técnico
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_tecnico_produtor');
        Q.SQL.Add('  where cod_pessoa_produtor = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(596, Self.ClassName, 'RetirarPapel', []);
          Result := -596;
          Exit;
        end;
        Q.Close;

      end;

      // Consiste informações para técnico
      if CodPapel = 3 then begin {Técnico}

        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_tecnico_produtor');
        Q.SQL.Add('  where cod_pessoa_tecnico = :cod_pessoa');
        Q.SQL.Add('    and dta_fim_validade is null');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(595, Self.ClassName, 'RetirarPapel', []);
          Result := -595;
          Exit;
        end;
        Q.Close;

      end;

      if (CodPapel = 6) or (CodPapel = 7) then begin

        // Verifica se a pessoa é o frigorífico ou aglomeração de algum animal
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_animal ' +
                  ' where cod_pessoa_corrente = :cod_pessoa ' +
                  '   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(842, Self.ClassName, 'Alterar', []);
          Result := -842;
          Exit;
        end;
        Q.Close;

        if (CodPapel = 6) then begin
          // Verifica se a pessoa é o frigorífico de algum evento de venda
          Q.Close;
          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_evento_venda_frigorifico ' +
                    ' where cod_pessoa = :cod_pessoa ');
{$ENDIF}
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.Open;
          if not Q.IsEmpty then begin
            Mensagens.Adicionar(1023, Self.ClassName, 'Excluir', []);
            Result := -1023;
            Exit;
          end;
          Q.Close;
        end;

      end;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_papel', CodRegistroLog, 5, Metodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_papel');
      Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_papel = :cod_papel');
{$ENDIF}
      Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ExecSQL;

      if CodPapel = 1 then begin {Associação}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_associacao');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('where');
        Q.SQL.Add('  cod_pessoa_associacao = :cod_pessoa');
{$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.ExecSQL;

      end else if CodPapel = 2 then begin {Funcionário}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_funcionario');
        Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
        Q.SQL.Add('where');
        Q.SQL.Add('  cod_pessoa_funcionario = :cod_pessoa');
{$ENDIF}
        Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.ExecSQL;

      end else if CodPapel = 3 then begin {Técnico}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log as CodRegistroLog from tab_tecnico');
        Q.SQL.Add('where cod_pessoa_tecnico = :cod_pessoa');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin

          CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
          Q.Close;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_tecnico', CodRegistroLog, 5, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('update tab_tecnico');
          Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
          Q.SQL.Add('where');
          Q.SQL.Add('  cod_pessoa_tecnico = :cod_pessoa');
{$ENDIF}
          Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.ExecSQL;

(*
          A partir de 19/10/2004 o procedimento de atualização de grandezas será
          realizado a partir da execução de processo batch por intervalos configuráveis
          e não mais a partir da execução de cada operação como anteriormente.
          { Atualiza Grandeza caso o papel de técnico esteja sendo removido }
          // Técnicos - Técnicos cadastrados
          Result := AtualizaGrandeza(16, -1, -1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
*)

        end;
        Q.Close;

      end else if CodPapel = 4 then begin {Produtor}

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_produtor_raca');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoa;
        Q.ExecSQL;

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log, dta_efetivacao_cadastro from tab_produtor');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa');
{$ENDIF}
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        if not Q.IsEmpty then begin

          CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
//          bProdutorEfetivado := not Q.FieldByName('dta_efetivacao_cadastro').IsNull;
          Q.Close;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
          Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 5, Metodo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          Q.SQL.Clear;
{$IFDEF MSSQL}
          Q.SQL.Add('update tab_produtor');
          Q.SQL.Add('  set dta_fim_validade = :dta_fim_validade');
          Q.SQL.Add('where');
          Q.SQL.Add('  cod_pessoa_produtor = :cod_pessoa');
{$ENDIF}
          Q.ParamByName('dta_fim_validade').AsDateTime := dDtaFimValidade;
          Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
          Q.ExecSQL;

(*
          A partir de 19/10/2004 o procedimento de atualização de grandezas será
          realizado a partir da execução de processo batch por intervalos configuráveis
          e não mais a partir da execução de cada operação como anteriormente.
          { Atualiza Grandeza caso o papel de produtor esteja sendo removido }
          // Produtores - Cadastrados
          Result := AtualizaGrandeza(13, CodPessoa, -1);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;
          if bProdutorEfetivado then begin
            // Produtores - Identificados no SISBOV
            Result := AtualizaGrandeza(15, CodPessoa, -1);
            if Result < 0 then begin
              Rollback;
              Exit;
            end;
          end else begin
            // Produtores - Com identificação SISBOV pendente
            Result := AtualizaGrandeza(14, CodPessoa, -1);
            if Result < 0 then begin
              Rollback;
              Exit;
            end;
          end;
*)

        end;
        Q.Close;

      end;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    except
      On E: exception do begin
        Rollback;
        Mensagens.Adicionar(597, Self.ClassName, 'RetirarPapel', [E.Message]);
        Result := -597;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntPessoas.DefinirParametrosProdutor(EQtdCaracteres: Integer;
                                               EIndConsultaPublica: String;
                                               ECodTipoAgrupamentoRacas,
                                               EQtdDenominadorCompRacial,
                                               EQtdDiasEntreCoberturas,
                                               EQtdDiasDescansoReprodutivo,
                                               EQtdDiasDiagnosticoGestacao: Integer;
                                               ECodSituacaoSisBov: String;
                                               ECodAptidao: Integer;
                                               EIndMostrarNome,
                                               EIndMostrarIdentificadores,
                                               EIndTransfereEmbrioes,
                                               EIndMostrarFiltroCompRacial,
                                               EIndEstacaoMonta: String;
                                               EIndTrabalhaAssociacaoRaca: String;
                                               EQtdIdadeMinimaDesmame,
                                               EQtdIdadeMaximaDesmame: Integer;
                                               EIndAplicarDesmameAutomatico: String): Integer;
const
  Metodo: Integer = 244;
var
  Q: THerdomQuery;
  CodRegistroLog: Integer;
  NomeProdutor : String;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado('DefinirParametrosProdutor');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then
  begin
    Mensagens.Adicionar(307, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -307;
    Exit;
  end;

  // Verifica se a quantidade caracteres para código de manejo é válida
  if (EQtdCaracteres < 0) or (EQtdCaracteres > 8) then
  begin
    Mensagens.Adicionar(719, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -719;
    Exit;
  end;

  // Verifica se a quantidade de dias entre coberturas é válida
  if (EQtdDiasEntreCoberturas < 0) then
  begin
    Mensagens.Adicionar(1436, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -1436;
    Exit;
  end;

  // Verifica se a quantidade de dias para descanso reprodutivo é válida
  if (EQtdDiasDescansoReprodutivo < 0) then
  begin
    Mensagens.Adicionar(1437, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -1437;
    Exit;
  end;

  // Verifica se a quantidade de dias para diagnostico de gestação é válida
  if (EQtdDiasDiagnosticoGestacao < 0) then
  begin
    Mensagens.Adicionar(1438, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -1438;
    Exit;
  end;

  // Verifica se o IndConsultaPublica á valido. Caso contrário coloca defaut como "N"
  if not((UpperCase(EIndConsultaPublica) = 'S') or
         (UpperCase(EIndConsultaPublica) = 'N')) then
  begin
    EIndConsultaPublica := ValorParametro(18);;
  end;

  if (UpperCase(EIndAplicarDesmameAutomatico) <> 'S') and
     (UpperCase(EIndAplicarDesmameAutomatico) <> 'N') then
  begin
    Mensagens.Adicionar(2241, Self.ClassName, 'DefinirParametrosProdutor', []);
    Result := -2241;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Consiste o Tipo de agrupamento de raças
      if ECodTipoAgrupamentoRacas > 0 then
      begin
         Q.SQL.Clear;
         {$IFDEF MSSQL}
         Q.SQL.Add('select 1 ');
         Q.SQL.Add('from');
         Q.SQL.Add('  tab_tipo_agrup_racas ');
         Q.SQL.Add('where');
         Q.SQL.Add('     cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
         Q.SQL.Add(' and dta_fim_validade is null ');
         {$ENDIF}
         Q.ParamByName('cod_tipo_agrup_racas').AsInteger := ECodTipoAgrupamentoRacas;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(1278, Self.ClassName, 'DefinirParametrosProdutor', []);
            Result := -1278;
           Exit;
         end;
      end;

      // Consiste CodAptidao
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_aptidao ');
      Q.SQL.Add('where');
      Q.SQL.Add('     cod_aptidao = :cod_aptidao ');
      Q.SQL.Add(' and dta_fim_validade is null ');
      {$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := ECodAptidao;
      Q.Open;
      if Q.IsEmpty then begin
         Mensagens.Adicionar(1481, Self.ClassName, 'DefinirParametrosProdutor', []);
         Result := -1481;
         Exit;
      end;

      // Consiste SituacaoSISBOV
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_situacao_sisbov ');
      Q.SQL.Add('where');
      Q.SQL.Add('     cod_situacao_sisbov = :cod_situacao_sisbov ');
      {$ENDIF}
      Q.ParamByName('cod_situacao_sisbov').AsString := ECodSituacaoSisBov;
      Q.Open;
      if Q.IsEmpty then begin
         Mensagens.Adicionar(609, Self.ClassName, 'DefinirParametrosProdutor', []);
         Result := -609;
         Exit;
      end;

      // Buscando dados para serem consistidos
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  tpr.cod_registro_log as CodRegistroLog');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'DefinirParametrosProdutor', []);
        Result := -212;
        Exit;
      end;

      CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 2, Metodo);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Marca cadastro como não enviado para o sisbov
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('update tab_produtor set');
      Q.SQL.Add('       qtd_caracteres_cod_manejo = :qtd_caracteres_cod_manejo ');
      Q.SQL.Add('     , ind_consulta_publica = :ind_consulta_publica ');
      if ECodTipoAgrupamentoRacas > 0 then
      begin
        Q.SQL.Add('   , cod_tipo_agrup_racas = :cod_tipo_agrup_racas ')
      end
      else
      begin
        Q.SQL.Add('   , cod_tipo_agrup_racas = null ');
      end;
      if EQtdDenominadorCompRacial > 0 then
      begin
        Q.SQL.Add('   , qtd_denominador_comp_racial = :qtd_denominador_comp_racial ')
      end
      else
      begin
        Q.SQL.Add('   , qtd_denominador_comp_racial = null ');
      end;
      Q.SQL.Add('     , qtd_dias_entre_coberturas      = :qtd_dias_entre_coberturas ');
      Q.SQL.Add('     , qtd_dias_descanso_reprodutivo  = :qtd_dias_descanso_reprodutivo ');
      Q.SQL.Add('     , qtd_dias_diagnostico_gestacao  = :qtd_dias_diagnostico_gestacao ');
      Q.SQL.Add('     , cod_aptidao                    = :cod_aptidao ');
      Q.SQL.Add('     , cod_situacao_sisbov            = :cod_situacao_sisbov ');
      Q.SQL.Add('     , ind_mostrar_nome               = :ind_mostrar_nome ');
      Q.SQL.Add('     , ind_mostrar_identificadores    = :ind_mostrar_identificadores ');
      Q.SQL.Add('     , ind_transfere_embrioes         = :ind_transfere_embrioes ');
      Q.SQL.Add('     , ind_mostrar_filtro_comp_racial = :ind_mostrar_filtro_comp_racial ');
      Q.SQL.Add('     , ind_estacao_monta              = :ind_estacao_monta ');
      Q.SQL.Add('     , ind_trabalha_assoc_raca        = :ind_trabalha_assoc_raca ');
      Q.SQL.Add('     , qtd_idade_minima_desmame       = :qtd_idade_minima_desmame ');
      Q.SQL.Add('     , qtd_idade_maxima_desmame       = :qtd_idade_maxima_desmame ');
      Q.SQL.Add('     , ind_aplicar_desmame_automatico = :ind_aplicar_desmame_automatico ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('qtd_caracteres_cod_manejo').AsInteger := EQtdCaracteres;
      Q.ParamByName('ind_consulta_publica').AsString := EIndConsultaPublica;
      if ECodTipoAgrupamentoRacas > 0 then
      begin
        Q.ParamByName('cod_tipo_agrup_racas').AsInteger := ECodTipoAgrupamentoRacas;
      end;
      if EQtdDenominadorCompRacial > 0 then
      begin
        Q.ParamByName('qtd_denominador_comp_racial').AsInteger := EQtdDenominadorCompRacial;
      end;
      Q.ParamByName('qtd_dias_entre_coberturas').AsInteger     := EQtdDiasEntreCoberturas;
      Q.ParamByName('qtd_dias_descanso_reprodutivo').AsInteger := EQtdDiasDescansoReprodutivo;
      Q.ParamByName('qtd_dias_diagnostico_gestacao').AsInteger := EQtdDiasDiagnosticoGestacao;
      Q.ParamByName('cod_aptidao').AsInteger                   := ECodAptidao;
      Q.ParamByName('cod_situacao_sisbov').AsString            := ECodSituacaoSisBov;
      Q.ParamByName('ind_mostrar_nome').AsString               := EIndMostrarNome;
      Q.ParamByName('ind_mostrar_identificadores').AsString    := EIndMostrarIdentificadores;
      Q.ParamByName('ind_transfere_embrioes').AsString         := EIndTransfereEmbrioes;
      Q.ParamByName('ind_mostrar_filtro_comp_racial').AsString := EIndMostrarFiltroCompRacial;
      Q.ParamByName('ind_estacao_monta').AsString              := EIndEstacaoMonta;
      Q.ParamByName('ind_trabalha_assoc_raca').AsString        := EIndTrabalhaAssociacaoRaca;
      Q.ParamByName('qtd_idade_minima_desmame').AsInteger      := EQtdIdadeMinimaDesmame;
      Q.ParamByName('qtd_idade_maxima_desmame').AsInteger      := EQtdIdadeMaximaDesmame;
      Q.ParamByName('ind_aplicar_desmame_automatico').AsString := EIndAplicarDesmameAutomatico;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 3, Metodo);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Atualiza propriedades dos paramentros do produtor
      Result := Conexao.DefinirProdutorTrabalho(Conexao.CodProdutorTrabalho, NomeProdutor);
      if Result < 0 then
      begin
        Exit;
      end;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do
      begin
        Rollback;
        Mensagens.Adicionar(720, Self.ClassName, 'DefinirParametrosProdutor', [E.Message]);
        Result := -720;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;


{* Função responsável por retornar dados de pessoas cadastradas no sistema.
   O result set retornado é composto por: CodPessoa, SglProdutor, NomPessoa,
                                          NomReduzidoPessoa, DesPapeis,
                                          CodNaturezaPessoa, DesNaturezaPessoa,
                                          NumCNPJCPFFormatado, DtaNascimento,
                                          SglTipoendereco, NomLogradouro,
                                          NomBairro, NumCEP, NomDistrito,
                                          NomMunicipio, CodMicroRegiao,
                                          CodMicroRegiaoSisbov, NomMicroRegiao,
                                          SglEstado, NomEstado, SglTelefonePrincipal,
                                          TxtTelefonePrincipal, TxtEmailPrincipal,
                                          DtaCadastramento.

   @param ECodPessoa Integer
   @param ENomPessoa String
   @param ECodPapel Integer
   @param ECodNaturezaPessoa String
   @param ENumCNPJCPF String
   @param EIndBloqueio String
   @param EIndIncluirCertificadoraDonaSistema String
   @param EIndPesquisarDesativados WordBool
   @param ESglProdutor String
   @param ECodOrdenacao String
   @param EIndCadastroEfetivado String
   @param EIndExportadoSisbov String
   @param ECodTipoAcessoNaoDesejado String
   @param ECodEstado Integer
   @param ENomMunicipio String
   @param ECodMicroRegiao String
   @param ENomLogradouro String
   @param EDiaNascimentoInicio Integer
   @param EMesNascimentoInicio Integer
   @param EDiaNascimentoFim Integer
   @param EMesNascimentoFim Integer
   @param EIndRelatorio Boolean
   @param EOrderBy String

   @return 0 Valor retornado quando o método for executado com sucesso.
   @return -188 Valor retornadoo quando o usuário que estiver executando o
                método não possuir permissão para executá-lo.
   @return -1466 Valor retornado quando durante a execução do método ocorrer
                 uma exceção.
}
function TIntPessoas.PesquisarAvancado(ECodPessoa: Integer;
                                       ENomPessoa: String;
                                       ECodPapel: Integer;
                                       ECodNaturezaPessoa,
                                       ENumCNPJCPF,
                                       EIndBloqueio,
                                       EIndIncluirCertificadoraDonaSistema: String;
                                       EIndPesquisarDesativados: WordBool;
                                       ESglProdutor,
                                       ECodOrdenacao,
                                       EIndCadastroEfetivado,
                                       EIndExportadoSisbov,
                                       ECodTipoAcessoNaoDesejado: String;
                                       ECodEstado: Integer;
                                       ENomMunicipio,
                                       ECodMicroRegiao,
                                       ENomLogradouro: String;
                                       EDiaNascimentoInicio,
                                       EMesNascimentoInicio,
                                       EDiaNascimentoFim,
                                       EMesNascimentoFim: Integer;
                                       EIndRelatorio: Boolean;
                                       EOrderBy: String): Integer;
const
  Metodo: Integer = 441;
  NomeMetodo: String = 'PesquisarAvancado';
var
  Param : TValoresParametro;
  bPapel, bMunicipio : Boolean;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  ESglProdutor := Trim(ESglProdutor);
  bPapel := (ECodPapel > 0) or (ECodTipoAcessoNaoDesejado <> '');
  bMunicipio := (ENomMunicipio <> '') or (ECodMicroRegiao <> '');

  try
    Query.Close;
{$IFDEF MSSQL}
    if EIndRelatorio then
    begin
      Query.SQL.Text :=
        'if object_id(''tempdb..#tmp_pessoa'') is null ' +
        'begin ' +
        '  create table #tmp_pessoa ' +
        '  ( ' +
        '    CodPessoa int not null ' +
        '    , SglProdutor varchar(5) null ' +
        '    , NomPessoa varchar(100) not null ' +
        '    , NomReduzidoPessoa varchar(15) not null ' +
        '    , DesPapeis varchar(105) null ' +
        '    , CodNaturezaPessoa char(1) not null ' +
        '    , DesNaturezaPessoa varchar(10)not null ' +
        '    , NumCNPJCPFFormatado varchar(20) not null ' +
        '    , DtaNascimento smalldatetime null ' +
        '    , SglTipoendereco varchar(3) null ' +
        '    , NomLogradouro varchar(100) null ' +
        '    , NomBairro varchar(50) null ' +
        '    , NumCEP varchar(8) null ' +
        '    , NomDistrito varchar(50) null ' +
        '    , NomMunicipio varchar(50) null ' +
        '    , CodMicroRegiao int null ' +
        '    , CodMicroRegiaoSisbov int null ' +
        '    , NomMicroRegiao varchar(40) null ' +
        '    , SglEstado varchar(2) null ' +
        '    , NomEstado varchar(20) null ' +
        '    , SglTelefonePrincipal varchar(6) null ' +
        '    , TxtTelefonePrincipal varchar(50) null ' +
        '    , TxtEmailPrincipal varchar(50) null ' +
        '    , DtaCadastramento smalldatetime null ' +
        '  ) ' +
        '  create index idx_tmp_pessoa on #tmp_pessoa (CodPessoa) ' +
        '  create index idx_tmp_pessoa_micro_regiao on #tmp_pessoa (CodMicroRegiao) ' +
        'end ';
      Query.ExecSQL;
      Query.SQL.Text :=
        'truncate table #tmp_pessoa ';
      Query.ExecSQL;
      Query.SQL.Text :=
        'insert into #tmp_pessoa ' +
        '( ' +
        '  CodPessoa ' +
        '  , SglProdutor ' +
        '  , NomPessoa ' +
        '  , NomReduzidoPessoa ' +
        '  , DesPapeis ' +
        '  , CodNaturezaPessoa ' +
        '  , DesNaturezaPessoa ' +
        '  , NumCNPJCPFFormatado ' +
        '  , DtaNascimento ' +
        '  , SglTipoendereco ' +
        '  , NomLogradouro ' +
        '  , NomBairro ' +
        '  , NumCEP ' +
        '  , NomDistrito ' +
        '  , NomMunicipio ' +
        '  , CodMicroRegiao ' +
        '  , SglEstado ' +
        '  , NomEstado ' +
        '  , DtaCadastramento ' +
        ') ';
    end
    else
    begin
      Query.SQL.Text := '';
    end;

    Query.SQL.Text := Query.SQL.Text +
      ' select distinct ' +
      '        tp.cod_pessoa as CodPessoa ' +
      '      , tpp.sgl_produtor as SglProdutor' +
      '      , tp.nom_pessoa as NomPessoa ' +
      '      , tp.nom_reduzido_pessoa as NomReduzidoPessoa ' +
      '      , dbo.FNT_DES_PAPEIS (tp.cod_pessoa, '''  + SE((Conexao.CodPapelUsuario = 9), 'S', 'N') +  ''') as DesPapeis ' +
      '      , tp.cod_natureza_pessoa as CodNaturezaPessoa ' +
      '      , tnp.des_natureza_pessoa as DesNaturezaPessoa ' +
      '      , case tp.cod_natureza_pessoa ' +
      '        when ''F'' then convert(varchar(18), ' +
      '          substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '          substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '          substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '          substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '        when ''J'' then convert(varchar(18), ' +
      '          substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '          substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '          substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '          substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '          substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '        end as NumCNPJCPFFormatado ' +
      '      , tp.dta_nascimento as DtaNascimento ' +
      '      , tte.sgl_tipo_endereco as SglTipoendereco ' +
      '      , tp.nom_logradouro as NomLogradouro ' +
      '      , tp.nom_bairro as NomBairro ' +
      '      , tp.num_cep as NumCEP ' +
      '      , td.nom_distrito as NomDistrito ' +
      '      , tm.nom_municipio as NomMunicipio ' +
      '      , tm.cod_micro_regiao as CodMicroRegiao ' +
      '      , te.sgl_estado as SglEstado ' +
      '      , te.nom_estado as NomEstado ' +
      '      , tp.dta_cadastramento as DtaCadastramento ' +
      '   from ' +
      '        tab_pessoa tp ' +
      '      , tab_produtor tpp ' +
      '      , tab_natureza_pessoa tnp ' +
      '      , tab_tipo_endereco tte ' +
      '      , tab_distrito td ' +
      '      , tab_municipio tm ' +
      '      , tab_estado te ';
      if ECodPapel = 3 then begin
        Query.SQL.Text := Query.SQL.Text + '      , tab_tecnico tt ';
      end;
      Query.SQL.Text := Query.SQL.Text + '      , tab_pessoa_papel tppa ' +
      SE(bPapel, '  , tab_papel tpa ', '')+
      '  where ' +
      '        tnp.cod_natureza_pessoa = tp.cod_natureza_pessoa ' +
      '    and tte.cod_tipo_endereco =* tp.cod_tipo_endereco ' +
      '    and td.cod_distrito =* tp.cod_distrito ' +
      '    and tm.cod_municipio ' +SE(bMunicipio, '=', '=*')+' tp.cod_municipio ' +
      '    and te.cod_estado =* tp.cod_estado ' +
      '    and tpp.cod_pessoa_produtor ' + SE(ECodPapel = 4, '=', '=*')+' tp.cod_pessoa ' +
      '  and tppa.cod_pessoa = tp.cod_pessoa ' +
      '  and tppa.dta_fim_validade is null ' +
      SE(bPapel, '  and tppa.cod_papel = tpa.cod_papel ', '') +
      SE(EIndPesquisarDesativados, '', '  and tp.dta_fim_validade is null ');

    if ECodTipoAcessoNaoDesejado <> '' then
    begin
      Query.SQL.Add('  and tpa.cod_tipo_acesso != :cod_tipo_acesso ');
      Query.ParamByName('cod_tipo_acesso').AsString := ECodTipoAcessoNaoDesejado;
    end;

    if UpperCase(EIndIncluirCertificadoraDonaSistema) <> 'S' then
    begin
      Query.SQL.Add('  and tp.cod_pessoa <> :cod_certificadora_dona_sistema ');
      Query.ParamByName('cod_certificadora_dona_sistema').AsInteger := StrToInt(ValorParametro(4));
    end;

    if ECodPapel = 3 then
    begin
      Query.SQL.Add('  and tt.cod_pessoa_tecnico = tp.cod_pessoa ');
      
      if EIndCadastroEfetivado = 'S' then
      begin
        Query.SQL.Add('  and tt.dta_efetivacao_cadastro is not null');
      end
      else if EIndCadastroEfetivado = 'N' then
      begin
        Query.SQL.Add('  and tt.dta_efetivacao_cadastro is null');
      end;
      if EIndExportadoSisbov = 'S' then
      begin
        Query.SQL.Add('  and exists (select top 1 1 from tab_tecnico ' +
                      '               where cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                      '                 and cod_arquivo_sisbov is not null) ');
      end
      else if EIndExportadoSisbov = 'N' then
      begin
        Query.SQL.Add('  and not exists (select top 1 1 from tab_tecnico ' +
                      '                   where cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                      '                     and cod_arquivo_sisbov is not null) ');
      end;
    end;

    if ECodPapel = 4 then
    begin
      if (Uppercase(EIndBloqueio) = 'S') or (Uppercase(EIndBloqueio) = 'N') then
      begin
        Query.SQL.Add('  and tpp.ind_produtor_bloqueado = :ind_produtor_bloqueado ');
        Query.ParamByName('ind_produtor_bloqueado').AsString := EIndBloqueio;
      end;
      if (ESglProdutor <> '') then
      begin
        Query.SQL.Add('  and tpp.sgl_produtor like :sgl_produtor');
        Query.ParamByName('sgl_produtor').AsString := '%' + ESglProdutor + '%';
      end;
      if EIndCadastroEfetivado = 'S' then
      begin
        Query.SQL.Add('  and tpp.dta_efetivacao_cadastro is not null');
      end
      else if EIndCadastroEfetivado = 'N' then
      begin
        Query.SQL.Add('  and tpp.dta_efetivacao_cadastro is null');
      end;
      if EIndExportadoSisbov = 'S' then
      begin
        Query.SQL.Add('  and exists (select top 1 1 from tab_localizacao_sisbov ' +
                      '               where cod_pessoa_produtor = tpp.cod_pessoa_produtor ' +
                      '                 and cod_arquivo_sisbov is not null) ');
      end
      else if EIndExportadoSisbov = 'N' then
      begin
        Query.SQL.Add('  and not exists (select top 1 1 from tab_localizacao_sisbov ' +
                      '                   where cod_pessoa_produtor = tpp.cod_pessoa_produtor ' +
                      '                     and cod_arquivo_sisbov is not null) ');
      end;
    end;

    if ECodPessoa > 0 then
    begin
      Query.SQL.Add('   and tp.cod_pessoa = :cod_pessoa ');
      Query.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
    end;

    if ENomPessoa <> '' then
    begin
      Query.SQL.Add('   and tp.nom_pessoa like :nom_pessoa ');
      Query.ParamByName('nom_pessoa').AsString := '%' + ENomPessoa + '%';
    end;

    if ECodPapel > 0 then
    begin
      Query.SQL.Add('   and tpa.cod_papel = :cod_papel ');
      Query.ParamByName('cod_papel').AsInteger := ECodPapel;
    end;

    if (UpperCase(ECodNaturezaPessoa) = 'F') or
       (UpperCase(ECodNaturezaPessoa) = 'J') then
    begin
      Query.SQL.Add('   and tp.cod_natureza_pessoa = :cod_natureza_pessoa ');
      Query.ParamByName('cod_natureza_pessoa').AsString  := ECodNaturezaPessoa;
    end;

    if ENumCNPJCPF <> '' then
    begin
      Query.SQL.Add('   and tp.num_cnpj_cpf like :num_cnpj_cpf ');
      Query.ParamByName('num_cnpj_cpf').AsString := ENumCNPJCPF + '%';
    end;

    if ECodEstado > 0 then
    begin
      Query.SQL.Add('   and tp.cod_estado = :cod_estado ');
      Query.ParamByName('cod_estado').AsInteger := ECodEstado;
    end;

    if ENomMunicipio <> '' then
    begin
      Query.SQL.Add('   and tm.nom_municipio like :nom_municipio ');
      Query.ParamByName('nom_municipio').AsString := '%' + ENomMunicipio + '%';
    end;

    if ECodMicroRegiao <> '' then
    begin
      Param := TValoresParametro.Create(TValorParametro);
      try
        Result := VerificaParametroMultiValor(ECodMicroRegiao, Param);
        if Result < 0 then
        begin
          Exit;
        end;
        Param.Clear;
      Finally
        Param.Free;
      end;
      Query.SQL.Add('     and tm.cod_micro_regiao in ( ' + ECodMicroRegiao + ' ) ');
    end;

    if ENomLogradouro <> '' then
    begin
      Query.SQL.Add('     and tp.nom_logradouro like :nom_logradouro ');
      Query.ParamByName('nom_logradouro').AsString := '%' + ENomLogradouro + '%';
    end;

    if (EDiaNascimentoInicio > 0) and
       (EMesNascimentoInicio > 0) then
    begin
      Query.SQL.Add('       and (month(tp.dta_nascimento) > :mes_nascimento_inicio or (month(tp.dta_nascimento) = :mes_nascimento_inicio and day(tp.dta_nascimento) >= :dia_nascimento_inicio )) ');
      Query.ParamByName('dia_nascimento_inicio').AsInteger := EDiaNascimentoInicio;
      Query.ParamByName('mes_nascimento_inicio').AsInteger := EMesNascimentoInicio;
    end;

    if (EDiaNascimentoFim > 0) and
       (EMesNascimentoFim > 0) then
    begin
      Query.SQL.Add('       and (month(tp.dta_nascimento) < :mes_nascimento_fim or (month(tp.dta_nascimento) = :mes_nascimento_fim and day(tp.dta_nascimento) <= :dia_nascimento_fim )) ');
      Query.ParamByName('dia_nascimento_fim').AsInteger := EDiaNascimentoFim;
      Query.ParamByName('mes_nascimento_fim').AsInteger := EMesNascimentoFim;
    end;

    // caso o usuário tenha papel de técnico, deverá ser listada apenas as
    // pessoas que sejam produtores e estejam associados a ele.
    if (Conexao.CodPapelUsuario = 3) then
    begin
      Query.SQL.Add(' and tp.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa ');
      Query.SQL.Add('                           from tab_tecnico_produtor ttp ');
      Query.SQL.Add('                          where ttp.dta_fim_validade is null ');
      Query.SQL.Add('                            and ttp.cod_pessoa_tecnico = :cod_pessoa_tecnico ) ');
      Query.SQL.Add(' and tppa.cod_papel in (4) ');
      Query.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
    end;
    // caso o usuário tenha papel de gestpr, deverá ser listada apenas as
    // pessoas que sejam produtores e ténicos e estejam associados ao gestor.
    if (Conexao.CodPapelUsuario = 9) then
    begin
      Query.SQL.Add(' and tp.cod_pessoa in ( ');

      if (ECodPapel = 4) or (ECodPapel <= 0) then
      begin
        Query.SQL.Add('                         select ttp.cod_pessoa_produtor as cod_pessoa ');
        Query.SQL.Add('                           from tab_tecnico_produtor ttp ');
        Query.SQL.Add('                              , tab_tecnico tt ');
        Query.SQL.Add('                          where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico ');
        Query.SQL.Add('                            and ttp.dta_fim_validade is null ');
        Query.SQL.Add('                            and tt.dta_fim_validade is null ');
        Query.SQL.Add('                            and tt.cod_pessoa_gestor = :cod_pessoa_gestor ');
      end;

      if ECodPapel <= 0 then
      begin
        Query.SQL.Add('                          union ');
      end;

      if (ECodPapel = 3) or (ECodPapel <= 0) then
      begin
        Query.SQL.Add('                          select tt.cod_pessoa_tecnico as cod_pessoa ');
        Query.SQL.Add('                           from tab_tecnico tt ');
        Query.SQL.Add('                          where tt.dta_fim_validade is null ');
        Query.SQL.Add('                            and tt.cod_pessoa_gestor = :cod_pessoa_gestor ');
      end;
      Query.SQL.Add('                       ) ');

      if ECodPapel = 3 then
      begin
        Query.SQL.Add(' and tppa.cod_papel in (3) ');
      end
      else if ECodPapel = 4 then
      begin
        Query.SQL.Add(' and tppa.cod_papel in (4) ');
      end
      else
      begin
        Query.SQL.Add(' and tppa.cod_papel in (3, 4) ');
      end;

      Query.ParamByName('cod_pessoa_gestor').AsInteger := Conexao.CodPessoa;
    end;

    if (ECodOrdenacao = 'S') then
    begin
      Query.SQL.Add('order by tpp.sgl_produtor ');
    end
    else
    begin
      Query.SQL.Add('order by tp.nom_pessoa ');
    end;

    if EIndRelatorio then
    begin
      Query.ExecSQL;

      // Identifica tipo e número do telefone principal
      Query.SQL.Text :=
        'update #tmp_pessoa ' +
        'set ' +
        '  SglTelefonePrincipal = ttc.sgl_tipo_contato ' +
        '  , TxtTelefonePrincipal = tpc.txt_contato ' +
        'from ' +
        '  tab_pessoa_contato tpc ' +
        '  , tab_tipo_contato ttc ' +
        'where ' +
        '  ttc.cod_grupo_contato = ''T'' ' + // (T)elefone
        '  and ttc.cod_tipo_contato = tpc.cod_tipo_contato ' +
        '  and tpc.ind_principal = ''S'' ' +
        '  and tpc.cod_pessoa = #tmp_pessoa.CodPessoa ';
      Query.ExecSQL;

      // Identifica descrição do email principal
      Query.SQL.Text :=
        'update #tmp_pessoa ' +
        'set ' +
        '  TxtEmailPrincipal = tpc.txt_contato ' +
        'from ' +
        '  tab_pessoa_contato tpc ' +
        '  , tab_tipo_contato ttc ' +
        'where ' +
        '  ttc.cod_grupo_contato = ''E'' ' + // (E)mail
        '  and ttc.cod_tipo_contato = tpc.cod_tipo_contato ' +
        '  and tpc.ind_principal = ''S'' ' +
        '  and tpc.cod_pessoa = #tmp_pessoa.CodPessoa ';
      Query.ExecSQL;

      // Identifica nome e código sisbov de micro regiões
      Query.SQL.Text :=
        'update #tmp_pessoa ' +
        'set ' +
        '  NomMicroRegiao = tmr.nom_micro_regiao ' +
        '  , CodMicroRegiaoSisbov = tmr.cod_micro_regiao_sisbov ' +
        'from ' +
        '  tab_micro_regiao tmr ' +
        'where ' +
        '  #tmp_pessoa.CodMicroRegiao = tmr.cod_micro_regiao ';
      Query.ExecSQL;

      // Realiza pesquisa final de dados para o relatório
      Query.SQL.Text :=
        'select ' +
        '  CodPessoa ' +
        '  , SglProdutor ' +
        '  , NomPessoa ' +
        '  , NomReduzidoPessoa ' +
        '  , DesPapeis ' +
        '  , DesNaturezaPessoa ' +
        '  , NumCNPJCPFFormatado ' +
        '  , DtaNascimento ' +
        '  , SglTipoendereco ' +
        '  , NomLogradouro ' +
        '  , NomBairro ' +
        '  , NumCEP ' +
        '  , NomDistrito ' +
        '  , NomMunicipio ' +
        '  , CodMicroRegiaoSisbov ' +
        '  , NomMicroRegiao ' +
        '  , SglEstado ' +
        '  , NomEstado ' +
        '  , SglTelefonePrincipal ' +
        '  , TxtTelefonePrincipal ' +
        '  , TxtEmailPrincipal ' +
        '  , DtaCadastramento ' +
        'from ' +
        '  #tmp_pessoa ';
        if EOrderBy <> '' then
        begin
          Query.SQL.Text := Query.SQL.Text + ' order by ' + EOrderBy;
        end;
    end;
{$ENDIF}
    //Query.SQL.SaveToFile('c:\pessoa.sql');
    Query.Open;

    Result := 0;
  except
    On E: exception do
    begin
      Mensagens.Adicionar(1466, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1466;
      Exit;
    end;
  end;
end;

function TIntPessoas.GerarRelatorio(CodPessoa: Integer; NomPessoa: String;
  CodPapel: Integer; CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
  IndIncluirCertificadoraDonaSistema: String;
  IndPesquisarDesativados: WordBool; SglProdutor, CodOrdenacao,
  IndCadastroEfetivado, IndExportadoSisbov,
  CodTipoAcessoNaoDesejado: String; CodEstado: Integer; NomMunicipio,
  CodMicroRegiao, NomLogradouro: String; DiaNascimentoInicio,
  MesNascimentoInicio, DiaNascimentoFim, MesNascimentoFim,
  Tipo, QtdQuebraRelatorio: Integer): String;
const
  Metodo: Integer = 444;
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 14;
var
  Rel: TRelatorioPadrao;
  IntRelatorios: TIntRelatorios;
  Retorno,
  // CodCampo,
  iAux: Integer;
  sQuebra,
  sAux: String;
  bTituloQuebra,
  bAvancou: Boolean;
  vAux: Array [1..2] of Variant;
  sOrderBy: String;
begin
  Result := '';

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  IntRelatorios := TIntRelatorios.Create;
  try
    Retorno := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Retorno < 0 then Exit;
    Retorno := IntRelatorios.Buscar(CodRelatorio);
    if Retorno < 0 then Exit;
    Retorno := IntRelatorios.Pesquisar(CodRelatorio);
    if Retorno < 0 then Exit;

    // Monta o order by
    sOrderBy := '';
    IntRelatorios.IrAoPrimeiro;
    while not IntRelatorios.EOF do begin
      if IntRelatorios.ValorCampo('IndSelecaoUsuario') = 'S' then
      begin
        if sOrderBy = '' then
          sOrderBy := ' '
        else
          sOrderBy := sOrderBy + ', ';
        sOrderBy := sOrderBy + IntRelatorios.ValorCampo('NomField');
      end;
      IntRelatorios.IrAoProximo;
    end;
    IntRelatorios.IrAoPrimeiro;
  finally
    IntRelatorios.Free;
  end;

  Retorno := PesquisarAvancado(CodPessoa, NomPessoa, CodPapel,
    CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
    IndIncluirCertificadoraDonaSistema, IndPesquisarDesativados, SglProdutor,
    CodOrdenacao, IndCadastroEfetivado, IndExportadoSisbov,
    CodTipoAcessoNaoDesejado, CodEstado, NomMunicipio, CodMicroRegiao,
    NomLogradouro, DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
    MesNascimentoFim, True, sOrderBy);
  if Retorno < 0 then Exit;

  if Query.IsEmpty then begin
    Mensagens.Adicionar(1479, Self.ClassName, NomeMetodo, []);
    Exit;
  end;


  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  try
    Rel.TipoDoArquvio := Tipo;
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then
    begin
      Exit;
    end;

    // Consiste se o número de quebras é válido
    if Rel.Campos.NumCampos < QtdQuebraRelatorio then begin
      Mensagens.Adicionar(1384, Self.ClassName, NomeMetodo, []);
      Exit;
    end;
    // Desabilita a apresentação dos campos selecionados para quebra
    Rel.Campos.IrAoPrimeiro;
    for iAux := 1 to QtdQuebraRelatorio do
    begin
      Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
      Rel.Campos.IrAoProximo;
    end;

    // Inicializa o procedimento de geração do arquivo de relatório
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then
    begin
      Exit;
    end;

    sQuebra := '';
    bTituloQuebra := False;
    while not Query.EOF do
    begin
      bAvancou := False;
      // Atualiza o campo valor do atributo Campos do relatorio
      // c/ os dados da query
      Rel.Campos.CarregarValores(Query);
      Rel.Campos.SalvarValores;

      // Realiza tratamento de quebras somente para formato PDF
      if Tipo = ctaPDF then
      begin
        if Rel.LinhasRestantes <= 2 then
        begin
          {Verifica se o próximo registro existe, para que o último registro
          do relatório possa ser exibido na próxima folha, e assim o total não
          seja mostrado sozinho nesta folha}
          Query.Next;
          bAvancou := True;
          if Query.Eof then
          begin
            Rel.NovaPagina;
          end;
        end;
        if QtdQuebraRelatorio > 0 then
        begin
          // Percorre o(s) campo(s) informado(s) para quebra
          sAux := '';
          for iAux := 1 to QtdQuebraRelatorio do
          begin
            // Concatena o valor dos campos de quebra, montando o título
            vAux[iAux] := Rel.Campos.ValorCampoIdx[iAux-1];
            sAux := SE(sAux = '', sAux, sAux + ' / ') +
              TrataQuebra(Rel.Campos.TextoTituloIdx[iAux-1]) + ': ' +
              Rel.Campos.ValorCampoIdx[iAux-1];
          end;
          if (sAux <> sQuebra) then
          begin
            {Se ocorreu mudança na quebra atual ou é a primeira ('')
             Apresenta subtotal para quebra concluída, caso não seja a primeira}
            sQuebra := sAux;
            if Rel.LinhasRestantes <= 4 then
            begin
              {Verifica se a quebra possui somente um registro e se o espaço é su-
              ficiênte para a impressão de título, registro e subtotal, caso
              contrário quebra a página antes da impressão}
              if not bAvancou then
              begin
                Query.Next;
                bAvancou := True;
              end;
              if Query.Eof then
              begin
                Rel.NovaPagina;
              end
              else
              begin
                Rel.Campos.CarregarValores(Query);
                for iAux := 1 to QtdQuebraRelatorio do
                begin
                  if (rel.LinhasRestantes <= 2)
                    or (vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1]) then
                  begin
                    Rel.NovaPagina;
                    Break;
                  end;
                end;
                // Verifica se uma nova página foi gerada, caso não salta uma linha
                if Rel.LinhasRestantes < Rel.LinhasPorPagina then
                begin
                  Rel.NovaLinha;
                end;
              end;
            end
            else if Rel.LinhasRestantes < Rel.LinhasPorPagina then
            begin
              // Salta uma linha antes da quebra, caso não seja a primeira da pág.
              Rel.NovaLinha;
            end;
            // Imprime título da quebra
            Rel.FonteNegrito;
            Rel.ImprimirTexto(0, sQuebra);
            Rel.FonteNormal;
          end
          else if bTituloQuebra then
          begin
            // Repete o título da quebra no topo da nova pág. qdo ocorrer
            // quebra de pág.
            Rel.NovaPagina;
            Rel.FonteNegrito;
            Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
            Rel.FonteNormal;
          end;
        end;

        {Verifica se o registro a ser apresentado é o último da quebra, caso
        seja faz com que ele possa ser exibido na próxima folha, e assim o
        subtotal e/ou o total não sejam mostrados sozinhos nesta folha}
        if (Rel.LinhasRestantes <= 2) and (QtdQuebraRelatorio > 0) then
        begin
          if not bAvancou then
          begin
             Query.Next;
             bAvancou := True;
          end;
          if not Query.Eof then
          begin
            {Caso uma nova pág. seja necessária, apresenta o texto da
            quebra novamente no início da nova página concatenado com o
            texto "(continuação)"}
            Rel.Campos.CarregarValores(Query);
            for iAux := 1 to QtdQuebraRelatorio do
            begin
              if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then
              begin
                Rel.NovaPagina;
                Rel.FonteNegrito;
                Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                Rel.FonteNormal;
                Break;
              end;
            end;
          end;
        end;
      end;
      Rel.Campos.RecuperarValores;
      Rel.ImprimirColunas;
      bTituloQuebra := (Rel.LinhaCorrente = Rel.LinhasPorPagina);
      if not bAvancou then
      begin
        Query.Next;
      end;
    end;

    {Rel.TipoDoArquvio := Tipo;
    Retorno := Rel.InicializarRelatorio(CodRelatorio);
    if Retorno < 0 then Exit;

    Query.First;
    while not EOF do begin
      Rel.ImprimirColunasResultSet(Query);
      Query.Next;
    end;}



    Retorno := Rel.FinalizarRelatorio;
    if Retorno = 0 then begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
  end;
end;

function TIntPessoas.PesquisarPorPropriedadeRural(
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo = 'PesquisarPorPropriedadeRural';
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(563) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Clear;
      SQL.Add('select tpr.cod_pessoa_produtor as CodPessoaProdutor,');
      SQL.Add('       tpr.sgl_produtor as SglProdutor,');
      SQL.Add('       case tp.cod_natureza_pessoa');
      SQL.Add('         when ''F'' then convert(varchar(18),');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2))');
      SQL.Add('         when ''J'' then convert(varchar(18),');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' +');
      SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2))');
      SQL.Add('       end as NumCNPJCPFProdutorFormatado,');
      SQL.Add('       tp.nom_pessoa as NomProdutor');
      SQL.Add('  from tab_produtor tpr,');
      SQL.Add('       tab_propriedade_rural tppr,');
      SQL.Add('       tab_localizacao_sisbov tls,');
      SQL.Add('       tab_pessoa tp');
      SQL.Add(' where tpr.cod_pessoa_produtor = tp.cod_pessoa');
      SQL.Add('   and tpr.dta_fim_validade is null');
      SQL.Add('   and tp.dta_fim_validade is null');
      SQL.Add('   and tls.cod_pessoa_produtor = tpr.cod_pessoa_produtor');
      SQL.Add('   and tppr.dta_fim_validade is null');
      SQL.Add('   and tppr.cod_propriedade_rural = tls.cod_propriedade_rural');
      SQL.Add('   and tppr.cod_propriedade_rural = :cod_propriedade_rural');

      ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

      Open;
    end;
    
    Result := 0;
  except
    on E: exception do
    begin
      Rollback;
      Mensagens.Adicionar(182, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -182;
      Exit;
    end;
  end;
end;

function TIntPessoas.Limparendereco(CodPessoa: Integer): Integer;
const
  NomMetodo: String = 'Limparendereco';
  CodMetodo: Integer = 604;
var
  qry: THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Limparendereco', []);
    Result := -188;
    Exit;
  end;

  qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Se a pessoa a ser excluída se tratar de um produtor, verificar se seu cadastrado está efeitvado!
      // caso seu cadastrado esteja efetivado, a operação não deverá ser realizada.
      begintran;
      with qry do begin
        Close;
        SQL.Clear;
        SQL.Text := 'select                                                    ' +
                    '       tpe.nom_pessoa                                     ' +
                    '  from                                                    ' +
                    '       tab_produtor tpr                                   ' +
                    '     , tab_pessoa tpe                                     ' +
                    ' where                                                    ' +
                    '       tpe.cod_pessoa = tpr.cod_pessoa_produtor           ' +
                    '   and tpr.dta_fim_validade is null                       ' +
                    '   and tpe.dta_fim_validade is null                       ' +
                    '   and tpr.dta_efetivacao_cadastro is not null            ' +
                    '   and tpr.cod_pessoa_produtor = :cod_pessoa_produtor     ';
        ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoa;
        Open;

        if not IsEmpty then begin
          Mensagens.Adicionar(2027, Self.ClassName, NomMetodo, [FieldByName('nom_pessoa').AsString]);
          Result := -2027;
          Exit;
        end;
      end;

      // Se a pessoa em questão não se trata de um produtor, limpar as informações do endereço da pessoa.
      with qry do begin
        Close;
        SQL.Clear;
        SQL.Text := 'update tab_pessoa               ' +
                    '   set                          ' +
                    '       cod_tipo_endereco = null ' +
                    '     , nom_logradouro = null    ' +
                    '     , nom_bairro = null        ' +
                    '     , num_cep = null           ' +
                    '     , cod_pais = null          ' +
                    '     , cod_estado = null        ' +
                    '     , cod_municipio = null     ' +
                    '     , cod_distrito = null      ' +
                    ' where                          ' +
                    '       cod_pessoa = :cod_pessoa ';
        ParamByName('cod_pessoa').AsInteger  := CodPessoa;
        ExecSQL;
        Commit;
        Result := 1;
      end;
    except
      on E:exception do begin
        Rollback;
        Mensagens.Adicionar(2028, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2028;
        Exit;
      end;
    end;
  Finally
    qry.Free;
  end;
end;

{ Insere um produtor, define seu endereço e efetiva o cadastro.

Parametros:
  CodArquivoExportacao: Arquivo de exportação que o registro deve ser inserido.
  NomPessoa: Nome do produtor
  NaturezaPessoa: Fisica ou Juridica
  NomLogradouro: Logradouro do produtor
  NomBairro: Bairro do produtor
  NumCEP: CEP do produtor
  UFMunicipio: Estado do produtor
  NomMunicipio: Municipio do produtor

Retorno:
  Código do produtor.
  < 0 se ocorrer algum erro.}
function TIntPessoas.InserirProdutorCargaInicial(
  CodArquivoExportacao: Integer; SglProdutor, NomPessoa, NaturezaPessoa,
  NumCNPJCPF, NomLogradouro, NomBairro, NumCEP, UFMunicipio,
  NomMunicipio: String): Integer;
const
  NomeMetodo: String = 'InserirProdutorCargaInicial';
var
  CodPessoaProdutor,
  CodDistrito,
  CodMunicipio,
  CodEstado: Integer;
  CodNaturezaPessoa,
  NomeReduzido: String;
  Intenderecos: TIntenderecos;
  QueryLocal: THerdomQuery;
begin
  Result := -1;
  CodPessoaProdutor := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    if Length(NomPessoa) > 100 then
    begin
      raise exception.Create('O atributo NomPessoa é inválido.');
    end;
    if Length(NaturezaPessoa) > 2 then
    begin
      raise exception.Create('O atributo NaturezaPessoa é inválido.');
    end;
    if Length(NumCNPJCPF) > 14 then
    begin
      raise exception.Create('O atributo NumCNPJCPF é inválido.');
    end;
    if Length(NomLogradouro) > 100 then
    begin
      raise exception.Create('O atributo NomLogradouro é inválido.');
    end;
    if Length(NomBairro) > 50 then
    begin
      raise exception.Create('O atributo NomBairro é inválido.');
    end;
    if Length(NumCEP) > 8 then
    begin
      raise exception.Create('O atributo NumCEP é inválido.');
    end;
    if Trim(NumCEP) = '' then
    begin
      raise exception.Create('O atributo NumCEP é obrigatório.');
    end;
    if Length(UFMunicipio) > 2 then
    begin
      raise exception.Create('O atributo UFMunicipio é inválido.');
    end;
    if Length(NomMunicipio) > 50 then
    begin
      raise exception.Create('O atributo NomMunicipio é inválido.');
    end;
    if CodArquivoExportacao <= 0 then
    begin
      raise exception.Create('O atributo CodArquivoExportacao é obrigatório.');
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica se a pessoa ja está cadastrada
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_pessoa');
        SQL.Add('  from tab_pessoa');
        SQL.Add(' where num_cnpj_cpf = :num_cnpj_cpf');

        ParamByName('num_cnpj_cpf').AsString := Trim(NumCNPJCPF);
        Open;

        if not IsEmpty then
        begin
          Result := FieldByName('cod_pessoa').AsInteger;
          Exit;
        end;
      end;

      // Obtem o código do estado e do municipio/distrito
      Intenderecos := TIntenderecos.Create;
      try
        Intenderecos.Inicializar(Conexao, Mensagens);
        CodEstado := Intenderecos.ObtemCodigoEstado(UFMunicipio);
        Intenderecos.ObtemCodigoMunicipioDistrito(NomMunicipio, CodEstado,
          CodMunicipio, CodDistrito);
      finally
        Intenderecos.Free;
      end;

      // Obtem a natureza da pessoa
      CodNaturezaPessoa := '';
      if Trim(UpperCase(NaturezaPessoa)) = 'PF' then
      begin
        CodNaturezaPessoa := 'F'
      end
      else
      if Trim(UpperCase(NaturezaPessoa)) = 'PJ' then
      begin
        CodNaturezaPessoa := 'J'
      end;

      if CodNaturezaPessoa = '' then
      begin
        raise exception.Create('A natureza ' + NaturezaPessoa + ' é inválida.');
      end;

      // Obtem o nome reduzido
      NomeReduzido := Copy(Copy(NomPessoa, 1, Pos(' ', NomPessoa)), 1, 15);

      // Insere o produtor
      CodPessoaProdutor := Inserir(NomPessoa, NomeReduzido, CodNaturezaPessoa,
        NumCNPJCPF, 0, '', 4, SglProdutor, -1, '', '', '', -1, '', '', '', '', 0);
      if CodPessoaProdutor < 0 then
      begin
        Result := CodPessoaProdutor;
        Exit;
      end;

      // Define o endereço
      Result := Definirendereco(CodPessoaProdutor, 1, NomLogradouro, NomBairro,
        Trim(NumCEP), 1, CodEstado, CodMunicipio, CodDistrito);
      if Result < 0 then
      begin
        Exit;
      end;

      // Efetiva o cadastro
      Result := EfetivarCadastro(CodPessoaProdutor);
      if Result < 0 then
      begin
        Exit;
      end;

      // Exporta o cadastro
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('update tab_produtor');
        SQL.Add('   set cod_arquivo_sisbov = :cod_arquivo_sisbov');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');

        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoExportacao;
        ExecSQL;
      end;
    finally
      QueryLocal.Free;
    end;

    Result := CodPessoaProdutor;
  except                         
    on E: EHerdomexception do
    begin
      E.gerarMensagem(Mensagens);
      Result := -E.CodigoErro;
      Exit;
    end;
    on E: exception do
    begin
      Mensagens.Adicionar(2079, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2079;
      Exit;
    end;
  end;
end;


{* Função responsável por retornar os dados dos gestores cadastrados no sistema

  @param ECodPessoaGestor Integer Parâmetro opcional. Caso seja passado o valor,
                                  -1, todos os gestores deverão ser listados.
                                  Caso contrário, dever-se-á trazer apenas o
                                  gestor passado como parâmetro.
}
function TIntPessoas.PesquisarGestores(ECodPessoaGestor: Integer): Integer;
const
  NomMetodo: String = 'PesquisarGestores';
  CodMetodo: Integer = 641;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    Query.SQL.Clear;
    Query.SQL.Add(' select tp.cod_pessoa as CodPessoaGestor ' +
                  '      , tp.nom_pessoa as NomPessoaGestor ' +
                  '      , tp.nom_reduzido_pessoa as NomReduzidoPessoa ' +
                  '   from tab_pessoa tp ' +
                  '      , tab_pessoa_papel tpp ' +
                  '  where tp.cod_pessoa = tpp.cod_pessoa ' +
                  '    and tpp.dta_fim_validade is null ' +
                  '    and tp.dta_fim_validade is null ' +
                  '    and tpp.cod_papel = 9 ');
    if ECodPessoaGestor > 0 then
    begin
      Query.SQL.Add('  and tp.cod_pessoa = :cod_pessoa ');
      Query.ParamByName('cod_pessoa').AsInteger := ECodPessoaGestor;
    end;

    Query.Open;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2187, Self.ClassName, NomMetodo, []);
      Result := -2187;
      Exit;
    end;
  end;
end;

function TIntPessoas.InserirComentario(CodPessoa: Integer; TxtComentario: String): Integer;
const
  NomMetodo: String = 'InserirComentario';
  CodMetodo: Integer = 646;
var
  qry: THerdomQuery;
  CodComentario : Integer;
begin
  Result := 0;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if CodPessoa <= 0 then begin
    Mensagens.Adicionar(2379, Self.ClassName, NomMetodo, []);
    Result := -2379;
    Exit;
  end;

  if Length(Trim(TxtComentario)) = 0 then begin
    Mensagens.Adicionar(2376, Self.ClassName, NomMetodo, []);
    Result := -2376;
    Exit;
  end;

  qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Pesquisa se pessoa informada existe
      qry.SQL.Clear;
      qry.SQL.Add(' select 1 ' +
                  '  from tab_pessoa ' +
                  ' where cod_pessoa = :cod_pessoa ');

      qry.ParamByName('cod_pessoa').AsInteger   := CodPessoa;
      qry.Open;

      if qry.IsEmpty then begin
        Mensagens.Adicionar(2375, Self.ClassName, NomMetodo, []);
        Result := -2375;
        Exit;
      end;

      // Pesquisa na tabela tab_pessoa_comentario se existe algum comentario cadastrado
      // para a pessoa em questão.
      qry.SQL.Clear;
      qry.SQL.Add(' select max(cod_comentario)+1 as CodComentario ' +
                  '  from tab_pessoa_comentario ' +
                  ' where cod_pessoa = :cod_pessoa ');
    
      qry.ParamByName('cod_pessoa').AsInteger            := CodPessoa;
      qry.Open;

      if qry.FieldByName('CodComentario').AsInteger > 0 then begin
        CodComentario := qry.FieldByName('CodComentario').AsInteger;
      end else begin
        CodComentario := 1;
      end;

      // Tenta Inserir Registro
      qry.SQL.Clear;
      {$IFDEF MSSQL}
      qry.SQL.Add('insert into tab_pessoa_comentario ');
      qry.SQL.Add(' (cod_pessoa,                     ');
      qry.SQL.Add('  cod_comentario,          ');
      qry.SQL.Add('  cod_usuario,                    ');
      qry.SQL.Add('  dta_insercao_comentario,        ');
      qry.SQL.Add('  txt_comentario_pessoa)          ');
      qry.SQL.Add('values                            ');
      qry.SQL.Add(' (:cod_pessoa,                    ');
      qry.SQL.Add('  :cod_comentario,         ');
      qry.SQL.Add('  :cod_usuario,                   ');
      qry.SQL.Add('  getdate(),                      ');
      qry.SQL.Add('  :txt_comentario_pessoa)         ');
      {$ENDIF}

      qry.ParamByName('cod_pessoa').AsInteger            := CodPessoa;
      qry.ParamByName('cod_comentario').AsInteger        := CodComentario;
      qry.ParamByName('cod_usuario').AsInteger           := Conexao.CodUsuario;
      qry.ParamByName('txt_comentario_pessoa').AsString  := TxtComentario;
      qry.ExecSQL;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2374, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2374;
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TIntPessoas.ExcluirComentario(CodPessoa, CodComentario: Integer): Integer;
const
  NomMetodo: String = 'ExcluirComentario';
  CodMetodo: Integer = 648;
var
  qry: THerdomQuery;
begin
  Result := 0;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if CodPessoa <= 0 then begin
    Mensagens.Adicionar(2379, Self.ClassName, NomMetodo, []);
    Result := -2379;
    Exit;
  end;

  if CodComentario <= 0 then begin
    Mensagens.Adicionar(2377, Self.ClassName, NomMetodo, []);
    Result := -2377;
    Exit;
  end;

  qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre transação
      beginTran;

      // Tenta excluir Registro
      qry.SQL.Clear;
      {$IFDEF MSSQL}
      qry.SQL.Add(' update tab_pessoa_comentario                      ');
      qry.SQL.Add('  set  dta_fim_validade = getdate()                ');
      qry.SQL.Add(' where cod_pessoa = :cod_pessoa                    ');
      qry.SQL.Add('  and  cod_comentario = :cod_comentario            ');
      {$ENDIF}

      qry.ParamByName('cod_pessoa').AsInteger      := CodPessoa;
      qry.ParamByName('cod_comentario').AsInteger  := CodComentario;
      qry.ExecSQL;

      Commit;
    except
      on E:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2380, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2380;
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TIntPessoas.PesquisarComentario(CodPessoa, CodComentario: Integer): Integer;
const
  NomMetodo: String = 'PesquisarComentario';
  CodMetodo: Integer = 649;
begin
  Result := 0;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if CodPessoa <= 0 then begin
    Mensagens.Adicionar(2379, Self.ClassName, NomMetodo, []);
    Result := -2379;
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add(' select tpc.cod_pessoa                   as CodPessoa, ');
    Query.SQL.Add('        tp.nom_pessoa                    as NomPessoa, ');
    Query.SQL.Add('        tpc.cod_comentario               as CodComentario, ');
    Query.SQL.Add('        tpc.cod_usuario                  as CodUsuarioInsercao, ');
    Query.SQL.Add('        tu1.nom_usuario                  as NomUsuarioInsercao, ');
    Query.SQL.Add('        tpc.dta_insercao_comentario      as DtaInsercaoComentario, ');
    Query.SQL.Add('        tpc.txt_comentario_pessoa        as TxtComentarioPessoa ');
    Query.SQL.Add(' from tab_pessoa_comentario tpc ');
    Query.SQL.Add('  ,  tab_pessoa  tp ');
    Query.SQL.Add('  ,  tab_usuario tu1 ');
    Query.SQL.Add(' where tpc.cod_pessoa  = :cod_pessoa  ');

    if CodComentario > 0  then begin
      Query.SQL.Add('   and tpc.cod_comentario = :cod_comentario  ');
    end;

    Query.SQL.Add('   and tpc.cod_pessoa  = tp.cod_pessoa  ');
    Query.SQL.Add('   and tpc.cod_usuario = tu1.cod_usuario  ');
    Query.SQL.Add('   and tpc.dta_fim_validade is null  ');
    Query.SQL.Add('   order by tpc.cod_comentario desc ');

    Query.ParamByName('cod_pessoa').AsInteger        := CodPessoa;
    if CodComentario > 0  then begin
      Query.ParamByName('cod_comentario').AsInteger  := CodComentario;
    end;

    Query.Open;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2374, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2374;
      Exit;
    end;
  end;
end;

end.
