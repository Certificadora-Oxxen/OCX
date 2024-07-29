// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Propriedades Rurais, Fazendas, etc - Definição das
// *                       classes.doc
// *  Código Classe      : 32
// *  Descrição Resumida : Cadastro de Locais
// ************************************************************************************************
// *  Últimas Alterações
// *   Jerry    15/08/2002    Criação
// *   Hitalo   15/08/2002    Retirar os Campos NumIncra, NumPropriedadeRural
// *                          do metodo buscar e propriedade Buscar
// *   Hitalo   30/08/2002    Alteração no método Inserir - Incrementar o
// *                          Código Lote por CodPessoaProdutor. Alteração no Método excluir
// *                          Se faz referência com Animal não deixar excluir, independente  se
// *                          o animal estiver ativo ou não.
// *   Carlos   26/09/2002    Criacao do Método Pesquisar Relacionamento
// *************************************************************************************************
unit uIntLocais;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntLocal, dbtables, sysutils, db, uColecoes, uFerramentas ;

const
  REGIME_ALIMENTAR_NAO_DEFINIDO: Integer = 99;

type
  { TIntLocais }
  TIntLocais = class(TIntClasseBDNavegacaoBasica)
  private
    FIntLocal : TIntLocal;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodFazenda: Integer; CodOrdenacao: String): Integer;
    function Inserir(CodFazenda: Integer; SglLocal, DesLocal,
      CodTiposFonteAgua: String; IndPrincipal: String): Integer;
    function InserirDadoGeral(NumCNPJCPFProdutor, CodNaturezaProdutor :String; CodFazenda: Integer; SglLocal, DesLocal,
      CodTiposFonteAgua, CodRegimeAlimentar: String): Integer;
    function Alterar(CodFazenda, CodLocal: Integer; SglLocal, DesLocal,
      IndPrincipal: String): Integer;
    function Excluir(CodFazenda, CodLocal: Integer): Integer;
    function Buscar(CodFazenda, CodLocal: Integer): Integer;
    function AdicionarRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer;
    function AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal,
      CodRegimeAlimentar, CodProdutor: Integer): Integer;
    function RetirarRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer;
    function AdicionarTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime): Integer;
    function AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime; CodProdutor:Integer): Integer;
    function RetirarTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade,
      DtaFimValidade: TDateTime): Integer;
    function ExcluirTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade,
      DtaFimValidade: TDateTime): Integer;
    function PesquisarTiposFonteAgua(CodFazenda, CodLocal: Integer): Integer;
    function PossuiRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer;
    function PesquisarRelacionamento(CodFazenda: Integer): Integer;
    property IntLocal : TIntLocal read FIntLocal write FIntLocal;
  end;

implementation

{ TIntLocais }
constructor TIntLocais.Create;
begin
  inherited;
  FIntLocal := TIntLocal.Create;
end;

destructor TIntLocais.Destroy;
begin
  FIntLocal.Free;
  inherited;
end;

function TIntLocais.Pesquisar(CodFazenda: Integer; CodOrdenacao: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(91) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Pesquisar', []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tl.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('       tl.cod_fazenda as CodFazenda, ');
  Query.SQL.Add('       tl.cod_local as CodLocal, ');
  Query.SQL.Add('       tl.sgl_local as SglLocal, ');
  Query.SQL.Add('       tl.des_local as DesLocal, ');
  Query.SQL.Add('       tf.sgl_fazenda as SglFazenda, ');
  Query.SQL.Add('       case tl.ind_principal when ''S'' then ''Sim''');
  Query.SQL.Add('         else ''Não'' end as IndPrincipal,');
  Query.SQL.Add('       tf.nom_fazenda as NomFazenda ');
  Query.SQL.Add('  from tab_local tl, ');
  Query.SQL.Add('       tab_fazenda tf ');
  Query.SQL.Add(' where tl.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tf.cod_pessoa_produtor = tl.cod_pessoa_produtor ');
  Query.SQL.Add('   and tf.cod_fazenda = tl.cod_fazenda ');
  Query.SQL.Add('   and tl.dta_fim_validade is null ');
  Query.SQL.Add('   and ((tl.cod_fazenda = :cod_fazenda) or (:cod_fazenda = -1)) ');
  If Uppercase(CodOrdenacao) = 'C' Then Begin
    Query.SQL.Add(' order by tl.cod_fazenda, tl.cod_local ');
  End;
  If Uppercase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by tf.sgl_fazenda, tl.sgl_local ');
  End;
  If Uppercase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by tf.sgl_fazenda, tl.des_local ');
  End;
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_fazenda').AsInteger         := CodFazenda;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(308, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -308;
      Exit;
    End;
  End;
end;

function TIntLocais.Inserir(CodFazenda: Integer; SglLocal, DesLocal,
  CodTiposFonteAgua: String; IndPrincipal: String): Integer;
const
  NomeMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  X, CodLocal, CodRegistroLog : Integer;
  Param : TValoresParametro;
  DtaSistema : TDateTime;
  DIA, MES, ANO, HOR, MIN, SEC, MSEC : Word;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(92) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  //----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Trata sigla do local
  Result := VerificaString(SglLocal, 'Sigla do Local');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglLocal, 2, 'Sigla do Local');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do local
  Result := VerificaString(DesLocal, 'Descrição do Local');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesLocal, 30, 'Descrição do Local');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata fontes de água
  Result := VerificaString(CodTiposFonteAgua, 'Tipos de fonte de água');
  If Result < 0 Then Begin
    Exit;
  End;
  Param := TValoresParametro.Create(TValorParametro);
  Result := VerificaParametroMultiValor(CodTiposFonteAgua, Param);
  If Result < 0 Then Begin
    Param.Free;
    Exit;
  End;

  if (IndPrincipal <> 'S') and (IndPrincipal <> 'N') then
  begin
    Mensagens.Adicionar(2005, Self.ClassName, NomeMetodo, []);
    Result := -2005;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------
      // Consiste Fazenda
      //------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      End;
      Q.Close;
      //------------------------------
      // Verifica duplicidade de sigla
      //------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and sgl_local = :sgl_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_local').AsString := SglLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(311, Self.ClassName, NomeMetodo, [SglLocal]);
        Result := -311;
        Exit;
      End;
      Q.Close;
      //----------------------------------
      // Verifica duplicidade de descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and des_local = :des_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('des_local').AsString := DesLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(312, Self.ClassName, NomeMetodo, [DesLocal]);
        Result := -312;
        Exit;
      End;
      Q.Close;
      //----------------------------------
      // Verifica se já existe um local principal
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and ind_principal = ''S'' ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        // Se não esitir nenhum principal força o registro inserido a ser o
        // principal
        IndPrincipal := 'S';
      End;
      Q.Close;
      //-----------------------------------------------
      // Consiste existência dos tipos de fonte de água
      //-----------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      For X := 0 to Param.Count - 1 do Begin
        Q.Close;
        Q.ParamByName('cod_tipo_fonte_agua').AsInteger := Param.Items[X].Valor;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(439, Self.ClassName, NomeMetodo, [IntToStr(Param.Items[X].Valor)]);
          Result := -439;
          Exit;
        End;
      End;

      // Abre transação
      BeginTran;

      //--------------------
      // Pega próximo código
      //--------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_local), 0) + 1 as cod_local ');
      Q.SQL.Add('  from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      CodLocal := Q.FieldByName('cod_local').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Obtem Data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;
      // Deixa a data do sistema com precisão de dia
      DecodeDate(DtaSistema, ANO, MES, DIA);
      DecodeTime(DtaSistema, HOR, MIN, SEC, MSEC);
      DtaSistema := EncodeDate(ANO, MES, DIA) + EncodeTime(0, 0, 0, 0);

      //--------------------
      // Altera a situação dos outros locais para não principal se o registro
      // a ser inserido for principal
      //--------------------
      if IndPrincipal = 'S' then
      begin
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_local ');
        Q.SQL.Add('   set ind_principal = ''N'' ');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
        Q.ExecSQL;
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  sgl_local, ');
      Q.SQL.Add('  des_local, ');
      Q.SQL.Add('  ind_principal,');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_cadastramento, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :sgl_local, ');
      Q.SQL.Add('  :des_local, ');
      Q.SQL.Add('  :ind_principal,');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  :dta_sistema, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ParamByName('sgl_local').AsString := SglLocal;
      Q.ParamByName('des_local').AsString := DesLocal;
      Q.ParamByName('ind_principal').AsString := IndPrincipal;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local', CodRegistroLog, 1, 92);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Adiciona relacionamentos com tipos de fontes de água
      For X := 0 to Param.Count - 1 do Begin
        Result := AdicionarTipoFonteAgua(CodFazenda, CodLocal, Param.Items[X].Valor, DtaSistema);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;
      End;

      // Insere o regime alimentar desconhecido
      Result := AdicionarRegimeAlimentar(CodFazenda, CodLocal,
        REGIME_ALIMENTAR_NAO_DEFINIDO);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodLocal;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(313, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -313;
        Exit;
      End;
    End;
  Finally
    Param.Free;
    Q.Free;
  End;
end;

function TIntLocais.Alterar(CodFazenda, CodLocal: Integer; SglLocal, DesLocal,
  IndPrincipal: String): Integer;
const
  NomeMetodo: String = 'Alterar';
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(93) Then Begin
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

  // Verifica se pelo menos um parâmetro foi informado
  If (SglLocal = '') and
     (DesLocal = '') Then Begin
    Mensagens.Adicionar(215, Self.ClassName, NomeMetodo, []);
    Result := -215;
    Exit;
  End;

  // Trata sigla do local
  Result := TrataString(SglLocal, 2, 'Sigla do Local');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do local
  Result := TrataString(DesLocal, 30, 'Descrição do Local');
  If Result < 0 Then Begin
    Exit;
  End;

  if (IndPrincipal <> 'S') and (IndPrincipal <> 'N') then
  begin
    Mensagens.Adicionar(2005, Self.ClassName, NomeMetodo, []);
    Result := -2005;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log, ind_principal from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, NomeMetodo, []);
        Result := -314;
        Exit;
      End;

      if (Q.FieldByName('ind_principal').AsString = 'S') and (IndPrincipal = 'N') then
      begin
        Mensagens.Adicionar(2008, Self.ClassName, NomeMetodo, []);
        Result := -2008;
        Exit;
      end;

      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Consiste Fazenda
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local != :cod_local ');
      Q.SQL.Add('   and sgl_local = :sgl_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ParamByName('sgl_local').AsString := SglLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(311, Self.ClassName, NomeMetodo, [SglLocal]);
        Result := -311;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local != :cod_local ');
      Q.SQL.Add('   and des_local = :des_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ParamByName('des_local').AsString := DesLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(312, Self.ClassName, NomeMetodo, [DesLocal]);
        Result := -312;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local', CodRegistroLog, 2, 93);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      //--------------------
      // Altera a situação dos outros locais para não principal se o registro
      // a ser inserido for principal
      //--------------------
      if IndPrincipal = 'S' then
      begin
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_local ');
        Q.SQL.Add('   set ind_principal = ''N'' ');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
        Q.ExecSQL;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_local ');
      Q.SQL.Add('   set ');
      If SglLocal <> '' Then Begin
        Q.SQL.Add('   sgl_local = :sgl_local,');
      End;
      If DesLocal <> '' Then Begin
        Q.SQL.Add('   des_local = :des_local,');
      End;
        Q.SQL.Add('   ind_principal = :ind_principal,');

      // Pra tirar a merda de vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
{$ENDIF}
      If SglLocal <> '' Then Begin
        Q.ParamByName('sgl_local').AsString      := SglLocal;
      End;
      If DesLocal <> '' Then Begin
        Q.ParamByName('des_local').AsString      := DesLocal;
      End;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ParamByName('ind_principal').AsString := IndPrincipal;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local', CodRegistroLog, 3, 93);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(333, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -333;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.Excluir(CodFazenda, CodLocal: Integer): Integer;
const
  NomeMetodo: String = 'Excluir';
var
  Q : THerdomQuery;
  CodRegistroLog, QtdLocais : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(95) Then Begin
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
  Try
    Try
      // Verifica a quantidade de locais
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(cod_local) as QtdLocais from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;

      QtdLocais := Q.FieldByName('QtdLocais').AsInteger;
      Q.Close;


      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log, ind_principal from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, NomeMetodo, []);
        Result := -314;
        Exit;
      End;

      // Se existir mais de um local para a fazenda do produtor e a propriedade
      // a ser excluída for a principal então
      if (Q.FieldByName('ind_principal').AsString = 'S') and (QtdLocais > 1) then
      begin
        Mensagens.Adicionar(2006, Self.ClassName, NomeMetodo, []);
        Result := -2006;
        Exit;
      end;

      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      //----------------------------------------
      // Verifica relacionamento com algum animal
      //-----------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_fazenda_corrente = :cod_fazenda ' +
                '   and cod_local_corrente = :cod_local ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(317, Self.ClassName, NomeMetodo, []);
        Result := -317;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local', CodRegistroLog, 5, 95);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_local ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(318, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -318;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.Buscar(CodFazenda, CodLocal: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(94) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Buscar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tl.cod_pessoa_produtor, ');
      Q.SQL.Add('       tl.cod_fazenda, ');
      Q.SQL.Add('       tl.cod_local, ');
      Q.SQL.Add('       tl.sgl_local, ');
      Q.SQL.Add('       tl.des_local, ');
      Q.SQL.Add('       tl.ind_principal, ');
      Q.SQL.Add('       tf.sgl_fazenda, ');
      Q.SQL.Add('       tf.nom_fazenda, ');
      Q.SQL.Add('       isnull(tf.cod_estado, -1) as cod_estado, ');
      Q.SQL.Add('       te.sgl_estado, ');
      Q.SQL.Add('       tl.dta_cadastramento');
      Q.SQL.Add('  from tab_local tl, ');
      Q.SQL.Add('       tab_fazenda tf, ');
      Q.SQL.Add('       tab_estado te ');
      Q.SQL.Add(' where tf.cod_pessoa_produtor = tl.cod_pessoa_produtor ');
      Q.SQL.Add('   and tf.cod_fazenda = tl.cod_fazenda ');
      Q.SQL.Add('   and te.cod_estado =* tf.cod_estado ');
      Q.SQL.Add('   and tl.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tl.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and tl.cod_local = :cod_local ');
      Q.SQL.Add('   and tl.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
      Q.ParamByName('cod_local').AsInteger           := CodLocal;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'Buscar', []);
        Result := -314;
        Exit;
      End;

      // Obtem informações do registro
      IntLocal.CodPessoaProdutor   := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      IntLocal.CodFazenda          := Q.FieldByName('cod_fazenda').AsInteger;
      IntLocal.CodLocal            := Q.FieldByName('cod_local').AsInteger;
      IntLocal.SglLocal            := Q.FieldByName('sgl_local').AsString;
      IntLocal.DesLocal            := Q.FieldByName('des_local').AsString;
      IntLocal.SglFazenda          := Q.FieldByName('sgl_fazenda').AsString;
      IntLocal.NomFazenda          := Q.FieldByName('nom_fazenda').AsString;
      IntLocal.CodEstado           := Q.FieldByName('cod_estado').AsInteger;
      IntLocal.SglEstado           := Q.FieldByName('sgl_estado').AsString;
      IntLocal.DtaCadastramento    := Q.FieldByName('dta_cadastramento').AsDateTime;
      IntLocal.IndPrincipal        := Q.FieldByName('ind_principal').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(319, Self.ClassName, 'Buscar', [E.Message]);
        Result := -319;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.AdicionarRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarRegimeAlimentar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(96) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarRegimeAlimentar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'AdicionarRegimeAlimentar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local_regime_alimentar ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_regime_alimentar = :cod_regime_alimentar ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 0;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'AdicionarRegimeAlimentar', []);
        Result := -314;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o regime alimentar informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_regime_alimentar ');
      Q.SQL.Add(' where cod_regime_alimentar = :cod_regime_alimentar ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(321, Self.ClassName, 'AdicionarRegimeAlimentar', []);
        Result := -321;
        Exit;
      End;
      Q.Close;

      // Abre transação
//      BeginTran;

      // Pega próximo CodRegistroLog
//      CodRegistroLog := ProximoCodRegistroLog;
//      If CodRegistroLog < 0 Then Begin
//        Rollback;
//        Result := CodRegistroLog;
//        Exit;
//      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local_regime_alimentar ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  cod_regime_alimentar) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :cod_regime_alimentar) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
//      Result := GravarLogOperacao('tab_local_regime_alimentar', CodRegistroLog, 1, 96);
//      If Result < 0 Then Begin
//        Rollback;
//        Exit;
//      End;

      // Cofirma transação
//      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(322, Self.ClassName, 'AdicionarRegimeAlimentar', [E.Message]);
        Result := -322;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.RetirarRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('RetirarRegimeAlimentar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(97) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarRegimeAlimentar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'RetirarRegimeAlimentar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Não é permitido remover o regime alimentar não definido
      if CodRegimeAlimentar = REGIME_ALIMENTAR_NAO_DEFINIDO then
      begin
        Mensagens.Adicionar(2076, Self.ClassName, 'RetirarRegimeAlimentar', []);
        Result := -2076;
        Exit;
      end;

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'RetirarRegimeAlimentar', []);
        Result := -314;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o regime alimentar informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_regime_alimentar ');
      Q.SQL.Add(' where cod_regime_alimentar = :cod_regime_alimentar ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(321, Self.ClassName, 'RetirarRegimeAlimentar', []);
        Result := -321;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
//      Q.SQL.Add('select cod_registro_log from tab_local_regime_alimentar ');
      Q.SQL.Add('select 1 from tab_local_regime_alimentar ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_regime_alimentar = :cod_regime_alimentar ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If Q.IsEmpty Then Begin
        Result := 0;
        Exit;
      End;
//      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre transação
//      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
//      Result := GravarLogOperacao('tab_local_regime_alimentar', CodRegistroLog, 4, 97);
//      If Result < 0 Then Begin
//        Rollback;
//        Exit;
//      End;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_local_regime_alimentar ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_regime_alimentar = :cod_regime_alimentar ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.ExecSQL;

      // Cofirma transação
//      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(323, Self.ClassName, 'RetirarRegimeAlimentar', [E.Message]);
        Result := -323;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.AdicionarTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  TransacaoInterna : Boolean;
  DtaCadastramento, DtaSistema : TDateTime;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarTipoFonteAgua');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(98) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -307;
    Exit;
  End;

  DtaInicioValidade := Trunc(DtaInicioValidade);

  If DtaInicioValidade = 0 then Begin
    Mensagens.Adicionar(286, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -286;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and ((:dta_inicio_validade between dta_inicio_validade and isnull(dta_fim_validade, ''2079-06-06'')) ');
      Q.SQL.Add('    or  (dta_fim_validade is null)) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(342, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -342;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_cadastramento from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -314;
        Exit;
      End;
      DtaCadastramento := Trunc(Q.FieldByName('dta_cadastramento').AsDateTime);
      Q.Close;

      // Consiste data informada
      If DtaInicioValidade < DtaCadastramento Then Begin
        Mensagens.Adicionar(440, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -440;
        Exit;
      End;

      // Obtem Data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;
      // Deixa a data do sistema com precisão de dia
      DtaSistema := Trunc(DtaSistema);

      // Consiste se data informada não é maior que a data do sistema
      If DtaInicioValidade > DtaSistema Then Begin
        Mensagens.Adicionar(442, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -442;
        Exit;
      End;

      // Verifica se existe o tipo de fonte de água informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger := CodTipoFonteAgua;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(324, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -324;
        Exit;
      End;
      Q.Close;

      // Abre transação
      // Este método pode ser chamado diretamente pela aplicação de interface ou internamente
      // pelo método Inserir. No segundo caso, já existirá uma transação aberta, e a transação
      // abaixo deverá ser nomeada para que o commit no final deste método não salve todo o
      // trabalho antes do próprio commit do método Inserir
      If EmTransacao Then Begin
        BeginTran('LOCAIS_ADICIONAR_TIPO_FONTE_AGUA');
        TransacaoInterna := True;
      End Else Begin
        BeginTran;
        TransacaoInterna := False;
      End;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  cod_tipo_fonte_agua, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :cod_tipo_fonte_agua, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('cod_registro_log').AsInteger     := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local_tipo_fonte_agua', CodRegistroLog, 1, 98);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      If TransacaoInterna Then Begin
        Commit('LOCAIS_ADICIONAR_TIPO_FONTE_AGUA');
      End Else Begin
        Commit;
      End;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(341, Self.ClassName, 'AdicionarTipoFonteAgua', [E.Message]);
        Result := -341;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.RetirarTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade,
  DtaFimValidade: TDateTime): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  DtaCadastramento : TDateTime;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('RetirarTipoFonteAgua');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(99) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarTipoFonteAgua', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'RetirarTipoFonteAgua', []);
    Result := -307;
    Exit;
  End;

  If DtaInicioValidade = 0 then Begin
    Mensagens.Adicionar(286, Self.ClassName, 'RetirarTipoFonteAgua', []);
    Result := -286;
    Exit;
  End;

  If DtaFimValidade = 0 then Begin
    Mensagens.Adicionar(287, Self.ClassName, 'RetirarTipoFonteAgua', []);
    Result := -287;
    Exit;
  End;

  If DtaFimValidade < DtaInicioValidade then Begin
    Mensagens.Adicionar(288, Self.ClassName, 'RetirarTipoFonteAgua', []);
    Result := -288;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_cadastramento from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'RetirarTipoFonteAgua', []);
        Result := -314;
        Exit;
      End;
      DtaCadastramento := Q.FieldByName('dta_cadastramento').AsDateTime;
      Q.Close;

      // Verifica se a data de fim de validade é válida
      If DtaFimValidade < DtaCadastramento Then Begin
        Mensagens.Adicionar(441, Self.ClassName, 'RetirarTipoFonteAgua', []);
        Result := -441;
        Exit;
      End;

      // Verifica se existe o tipo de fonte de água informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger := CodTipoFonteAgua;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(324, Self.ClassName, 'RetirarTipoFonteAgua', []);
        Result := -324;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_inicio_validade = :dta_inicio_validade ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(343, Self.ClassName, 'RetirarTipoFonteAgua', []);
        Result := -343;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local_tipo_fonte_agua', CodRegistroLog, 5, 99);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_local_tipo_fonte_agua ');
      Q.SQL.Add('   set dta_fim_validade = :dta_fim_validade ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_inicio_validade = :dta_inicio_validade ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('dta_fim_validade').AsDateTime    := DtaFimValidade;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(344, Self.ClassName, 'RetirarTipoFonteAgua', [E.Message]);
        Result := -344;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.ExcluirTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade,
  DtaFimValidade: TDateTime): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ExcluirTipoFonteAgua');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(100) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'ExcluirTipoFonteAgua', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'ExcluirTipoFonteAgua', []);
    Result := -307;
    Exit;
  End;

  If DtaInicioValidade = 0 then Begin
    Mensagens.Adicionar(286, Self.ClassName, 'ExcluirTipoFonteAgua', []);
    Result := -286;
    Exit;
  End;

//  If DtaFimValidade = 0 then Begin
//    Mensagens.Adicionar(287, Self.ClassName, 'ExcluirTipoFonteAgua', []);
//    Result := -287;
//    Exit;
//  End;

//  If DtaFimValidade < DtaInicioValidade then Begin
//    Mensagens.Adicionar(288, Self.ClassName, 'ExcluirTipoFonteAgua', []);
//    Result := -288;
//    Exit;
//  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'ExcluirTipoFonteAgua', []);
        Result := -314;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o tipo de fonte de água informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger := CodTipoFonteAgua;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(324, Self.ClassName, 'ExcluirTipoFonteAgua', []);
        Result := -324;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_inicio_validade = :dta_inicio_validade ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(343, Self.ClassName, 'ExcluirTipoFonteAgua', []);
        Result := -343;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local_tipo_fonte_agua', CodRegistroLog, 4, 100);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_inicio_validade = :dta_inicio_validade ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
//      Q.ParamByName('dta_fim_validade').AsDateTime    := DtaFimValidade;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(345, Self.ClassName, 'ExcluirTipoFonteAgua', [E.Message]);
        Result := -345;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.PesquisarTiposFonteAgua(CodFazenda,
  CodLocal: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarTiposFonteAgua');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(142) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarTiposFonteAgua', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'PesquisarTiposFonteAgua', []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tltfa.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('       tltfa.cod_fazenda as CodFazenda, ');
  Query.SQL.Add('       tltfa.cod_local as CodLocal, ');
  Query.SQL.Add('       tltfa.cod_tipo_fonte_agua as CodTipoFonteAgua, ');
  Query.SQL.Add('       tltfa.dta_inicio_validade as DtaInicioValidade, ');
  Query.SQL.Add('       tltfa.dta_fim_validade as DtaFimValidade, ');
  Query.SQL.Add('       ttfa.sgl_tipo_fonte_agua as SglTipoFonteAgua, ');
  Query.SQL.Add('       ttfa.des_tipo_fonte_agua as DesTipoFonteAgua ');
  Query.SQL.Add('  from tab_local_tipo_fonte_agua tltfa, ');
  Query.SQL.Add('       tab_tipo_fonte_agua ttfa ');
  Query.SQL.Add(' where ttfa.cod_tipo_fonte_agua = tltfa.cod_tipo_fonte_agua ');
  Query.SQL.Add('   and tltfa.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tltfa.cod_fazenda = :cod_fazenda ');
  Query.SQL.Add('   and tltfa.cod_local = :cod_local ');
  Query.SQL.Add(' order by tltfa.dta_inicio_validade, ttfa.sgl_tipo_fonte_agua ');
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
  Query.ParamByName('cod_local').AsInteger           := CodLocal;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(358, Self.ClassName, 'PesquisarTiposFonteAgua', [E.Message]);
      Result := -358;
      Exit;
    End;
  End;
end;

function TIntLocais.PossuiRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PossuiRegimeAlimentar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(143) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PossuiRegimeAlimentar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'PossuiRegimeAlimentar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'PossuiRegimeAlimentar', []);
        Result := -314;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o regime alimentar informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_regime_alimentar ');
      Q.SQL.Add(' where cod_regime_alimentar = :cod_regime_alimentar ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(321, Self.ClassName, 'PossuiRegimeAlimentar', []);
        Result := -321;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local_regime_alimentar ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_regime_alimentar = :cod_regime_alimentar ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 1;
      End Else Begin
        Result := 0;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(425, Self.ClassName, 'PossuiRegimeAlimentar', [E.Message]);
        Result := -425;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.PesquisarRelacionamento(CodFazenda: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(312) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Pesquisar', []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select ta.cod_aptidao as CodAptidao, ');
  Query.SQL.Add('       tl.cod_local as CodLocal, ');
  Query.SQL.Add('       tr.cod_regime_alimentar as CodRegimeAlimentar, ');
  Query.SQL.Add('       tr.ind_animal_mamando as IndAnimalMamando ');
  Query.SQL.Add(' from ');
  Query.SQL.Add('       tab_regime_alimentar as tr, ');
  Query.SQL.Add('       tab_local as tl, ');
  Query.SQL.Add('       tab_aptidao as ta, ');
  Query.SQL.Add('       tab_regime_alimentar_aptidao as tra, ');
  Query.SQL.Add('       tab_local_regime_alimentar as tlr ');
  Query.SQL.Add(' where ((tl.cod_fazenda = :cod_fazenda) or (:cod_fazenda = -1)) ');
  Query.SQL.Add(' and   tl.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add(' and   tl.cod_local = tlr.cod_local ');
  Query.SQL.Add(' and   tl.cod_fazenda = tlr.cod_fazenda ');
  Query.SQL.Add(' and   tl.cod_pessoa_produtor = tlr.cod_pessoa_produtor ');
  Query.SQL.Add(' and   tr.cod_regime_alimentar = tlr.cod_regime_alimentar ');
  Query.SQL.Add(' and   tr.cod_regime_alimentar = tra.cod_regime_alimentar ');
  Query.SQL.Add(' and   ta.cod_aptidao = tra.cod_aptidao ');
  Query.SQL.Add(' and   tl.dta_fim_validade is null ');
  Query.SQL.Add(' and   tr.dta_fim_validade is null ');
  Query.SQL.Add(' and   ta.dta_fim_validade is null ');
  Query.SQL.Add(' order by CodAptidao, CodRegimeAlimentar ');
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_fazenda').AsInteger         := CodFazenda;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(935, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -935;
      Exit;
    End;
  End;
end;

function TIntLocais.InserirDadoGeral(NumCNPJCPFProdutor, CodNaturezaProdutor: String;
  CodFazenda: Integer; SglLocal, DesLocal, CodTiposFonteAgua,
  CodRegimeAlimentar: String): Integer;
const
  NomeMetodo: String = 'InserirDadoGeral';
var
  Q : THerdomQuery;
  X, CodLocal, CodRegistroLog, CodProdutor : Integer;
  Param, ParamRA : TValoresParametro;
  DtaSistema : TDateTime;
  DIA, MES, ANO, HOR, MIN, SEC, MSEC : Word;
  IndPrincipal, NumCNPJCPFSemDv : String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

{  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(92) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  //----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

}
  // Trata número CNPJ ou CPF
  if CodNaturezaProdutor = 'F' then begin
    Result := VerificaString(NumCNPJCPFProdutor, 'Número CPF');
    if Result < 0 then Exit;
    Result := TrataString(NumCNPJCPFProdutor,11, 'Número CPF');
    NumCNPJCPFSemDv := Copy(NumCNPJCPFProdutor,1,9);
  end else begin
    if CodNaturezaProdutor = 'J' then begin
      Result := VerificaString(NumCNPJCPFProdutor, 'Número CNPJ');
      if Result < 0 then Exit;
      Result := TrataString(NumCNPJCPFProdutor,14, 'Número CNPJ');
      NumCNPJCPFSemDv := Copy(NumCNPJCPFProdutor,1,12);
    end else begin
      Mensagens.Adicionar(416, Self.ClassName, NomeMetodo, []);
      Result := -416;
      Exit;
    end;
  end;
  
  if Result < 0 then Exit;

  if not VerificarCnpjCpf(NumCNPJCPFSemDv,NumCNPJCPFProdutor, ValorParametro(128)) then begin
    Mensagens.Adicionar(424, Self.ClassName, NomeMetodo, []);
    Result := -424;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------

      // Busca o Código do produtor através do CPF/CNPJ
      Q.SQL.Clear;
    {$IFDEF MSSQL}
      Q.SQL.Add('select tr.cod_pessoa_produtor from ');
      Q.SQL.Add(' tab_produtor tr, ');
      Q.SQL.Add(' tab_pessoa   tp  ');
      Q.SQL.Add(' where tp.cod_pessoa = tr.cod_pessoa_produtor ');
      Q.SQL.Add('  and rtrim(ltrim(tp.num_cnpj_cpf)) = :NumCNPJCPFProdutor ');
      Q.SQL.Add('  and tp.dta_fim_validade is null ');
    {$ENDIF}
      Q.ParamByName('NumCNPJCPFProdutor').AsString := NumCNPJCPFProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, [NumCNPJCPFProdutor]);
        Result := -170;
        Exit;
      End Else
        CodProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;

      Q.Close;

      // Trata sigla do local
      Result := VerificaString(SglLocal, 'Sigla do Local');
      If Result < 0 Then Begin
        Exit;
      End;
      Result := TrataString(SglLocal, 2, 'Sigla do Local');
      If Result < 0 Then Begin
        Exit;
      End;

      // Trata descrição do local
      Result := VerificaString(DesLocal, 'Descrição do Local');
      If Result < 0 Then Begin
        Exit;
      End;
      Result := TrataString(DesLocal, 30, 'Descrição do Local');
      If Result < 0 Then Begin
        Exit;
      End;

      // Trata fontes de água
      Result := VerificaString(CodTiposFonteAgua, 'Tipos de fonte de água');
      If Result < 0 Then Begin
        Exit;
      End;
      Param := TValoresParametro.Create(TValorParametro);
      Result := VerificaParametroMultiValor(CodTiposFonteAgua, Param);
      If Result < 0 Then Begin
        Param.Free;
        Exit;
      End;

      // Trata regimes alimentares
      Result := VerificaString(CodRegimeAlimentar, 'Tipos de Regimes Alimentares');
      If Result < 0 Then Begin
        Exit;
      End;
      ParamRA := TValoresParametro.Create(TValorParametro);
      Result := VerificaParametroMultiValor(CodRegimeAlimentar, ParamRA);
      If Result < 0 Then Begin
        Param.Free;
        Exit;
      End;


      //------------------
      // Consiste Fazenda
      //------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      End;
      Q.Close;
      //------------------------------
      // Verifica duplicidade de sigla
      //------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and sgl_local = :sgl_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_local').AsString := SglLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(311, Self.ClassName, NomeMetodo, [SglLocal]);
        Result := -311;
        Exit;
      End;
      Q.Close;
      //----------------------------------
      // Verifica duplicidade de descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and des_local = :des_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('des_local').AsString := DesLocal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(312, Self.ClassName, NomeMetodo, [DesLocal]);
        Result := -312;
        Exit;
      End;
      Q.Close;

      //-----------------------------------------------
      // Consiste existência dos tipos de fonte de água
      //-----------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      For X := 0 to Param.Count - 1 do Begin
        Q.Close;
        Q.ParamByName('cod_tipo_fonte_agua').AsInteger := Param.Items[X].Valor;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(439, Self.ClassName, NomeMetodo, [IntToStr(Param.Items[X].Valor)]);
          Result := -439;
          Exit;
        End;
      End;


      Q.Close;
      //------------------------------------------------------------
      // Consiste existência dos tipos de regimes alimentares
      //------------------------------------------------------------
      Q.SQL.Clear;
    {$IFDEF MSSQL}
      Q.SQL.Add('select * from tab_regime_alimentar ');
      Q.SQL.Add('  where cod_regime_alimentar= :cod_regime_alimentar ');
      Q.SQL.Add('    and dta_fim_validade is null ');
    {$ENDIF}
      For X := 0 to ParamRA.Count - 1 do Begin
        Q.Close;
        Q.ParamByName('cod_regime_alimentar').AsInteger := ParamRA.Items[X].Valor;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1677, Self.ClassName, NomeMetodo, [IntToStr(ParamRA.Items[X].Valor)]);
          Result := -1677;
          Exit;
        End;
      End;

      // Abre transação
      BeginTran;

      //--------------------
      // Pega próximo código
      //--------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_local), 0) + 1 as cod_local ');
      Q.SQL.Add('  from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.Open;
      CodLocal := Q.FieldByName('cod_local').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Obtem Data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;
      // Deixa a data do sistema com precisão de dia
      DecodeDate(DtaSistema, ANO, MES, DIA);
      DecodeTime(DtaSistema, HOR, MIN, SEC, MSEC);
      DtaSistema := EncodeDate(ANO, MES, DIA) + EncodeTime(0, 0, 0, 0);

      //Verifica se o local a ser gravado, será marcado como local principal
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_local');
      Q.SQL.Add(' where cod_fazenda = :cod_fazenda');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.Open;
      if Q.IsEmpty then
      begin
        IndPrincipal := 'S';
      end
      else
      begin
        IndPrincipal := 'N';
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  sgl_local, ');
      Q.SQL.Add('  des_local, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_cadastramento, ');
      Q.SQL.Add('  ind_principal, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :sgl_local, ');
      Q.SQL.Add('  :des_local, ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  :dta_sistema, ');
      Q.SQL.Add('  :ind_principal, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.ParamByName('sgl_local').AsString := SglLocal;
      Q.ParamByName('des_local').AsString := DesLocal;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ParamByName('ind_principal').AsString := IndPrincipal;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local', CodRegistroLog, 1, 92);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Adiciona relacionamentos com tipos de fontes de água
      For X := 0 to Param.Count - 1 do Begin
        Result := AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal, Param.Items[X].Valor, DtaSistema, CodProdutor);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;
      End;

      // Adiciona relacionamentos com tipos de regimes alimentares
      For X := 0 to ParamRA.Count - 1 do Begin
        Result := AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal, ParamRA.Items[X].Valor, CodProdutor);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;
      End;

      // Insere o regime alimentar desconhecido
      Result := AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal, REGIME_ALIMENTAR_NAO_DEFINIDO, CodProdutor);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodLocal;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(313, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -313;
        Exit;
      End;
    End;
  Finally
    Param.Free;
    Q.Free;
  End;
end;

function TIntLocais.AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal,
  CodRegimeAlimentar, CodProdutor: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarRegimeAlimentar');
    Exit;
  End;

{  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(96) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarRegimeAlimentar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'AdicionarRegimeAlimentar', []);
    Result := -307;
    Exit;
  End;
}
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local_regime_alimentar ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_regime_alimentar = :cod_regime_alimentar ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 0;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'AdicionarRegimeAlimentar', []);
        Result := -314;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o regime alimentar informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_regime_alimentar ');
      Q.SQL.Add(' where cod_regime_alimentar = :cod_regime_alimentar ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(321, Self.ClassName, 'AdicionarRegimeAlimentar', []);
        Result := -321;
        Exit;
      End;
      Q.Close;

      // Abre transação
//      BeginTran;

      // Pega próximo CodRegistroLog
//      CodRegistroLog := ProximoCodRegistroLog;
//      If CodRegistroLog < 0 Then Begin
//        Rollback;
//        Result := CodRegistroLog;
//        Exit;
//      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local_regime_alimentar ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  cod_regime_alimentar) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :cod_regime_alimentar) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_regime_alimentar').AsInteger := CodRegimeAlimentar;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
//      Result := GravarLogOperacao('tab_local_regime_alimentar', CodRegistroLog, 1, 96);
//      If Result < 0 Then Begin
//        Rollback;
//        Exit;
//      End;

      // Cofirma transação
//      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(322, Self.ClassName, 'AdicionarRegimeAlimentar', [E.Message]);
        Result := -322;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocais.AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime; CodProdutor: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  TransacaoInterna : Boolean;
  DtaCadastramento, DtaSistema : TDateTime;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarTipoFonteAgua');
    Exit;
  End;

{  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(98) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -307;
    Exit;
  End;
}
  DtaInicioValidade := Trunc(DtaInicioValidade);

  If DtaInicioValidade = 0 then Begin
    Mensagens.Adicionar(286, Self.ClassName, 'AdicionarTipoFonteAgua', []);
    Result := -286;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and ((:dta_inicio_validade between dta_inicio_validade and isnull(dta_fim_validade, ''2079-06-06'')) ');
      Q.SQL.Add('    or  (dta_fim_validade is null)) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(342, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -342;
        Exit;
      End;
      Q.Close;

      // Verifica se existe o local informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_cadastramento from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_local = :cod_local ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_local').AsInteger := CodLocal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(314, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -314;
        Exit;
      End;
      DtaCadastramento := Trunc(Q.FieldByName('dta_cadastramento').AsDateTime);
      Q.Close;

      // Consiste data informada
      If DtaInicioValidade < DtaCadastramento Then Begin
        Mensagens.Adicionar(440, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -440;
        Exit;
      End;

      // Obtem Data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;
      // Deixa a data do sistema com precisão de dia
      DtaSistema := Trunc(DtaSistema);

      // Consiste se data informada não é maior que a data do sistema
      If DtaInicioValidade > DtaSistema Then Begin
        Mensagens.Adicionar(442, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -442;
        Exit;
      End;

      // Verifica se existe o tipo de fonte de água informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_fonte_agua ');
      Q.SQL.Add(' where cod_tipo_fonte_agua = :cod_tipo_fonte_agua ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger := CodTipoFonteAgua;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(324, Self.ClassName, 'AdicionarTipoFonteAgua', []);
        Result := -324;
        Exit;
      End;
      Q.Close;

      // Abre transação
      // Este método pode ser chamado diretamente pela aplicação de interface ou internamente
      // pelo método Inserir. No segundo caso, já existirá uma transação aberta, e a transação
      // abaixo deverá ser nomeada para que o commit no final deste método não salve todo o
      // trabalho antes do próprio commit do método Inserir
      If EmTransacao Then Begin
        BeginTran('LOCAIS_ADICIONAR_TIPO_FONTE_AGUA');
        TransacaoInterna := True;
      End Else Begin
        BeginTran;
        TransacaoInterna := False;
      End;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_local_tipo_fonte_agua ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_local, ');
      Q.SQL.Add('  cod_tipo_fonte_agua, ');
      Q.SQL.Add('  dta_inicio_validade, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_local, ');
      Q.SQL.Add('  :cod_tipo_fonte_agua, ');
      Q.SQL.Add('  :dta_inicio_validade, ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger          := CodFazenda;
      Q.ParamByName('cod_local').AsInteger            := CodLocal;
      Q.ParamByName('cod_tipo_fonte_agua').AsInteger  := CodTipoFonteAgua;
      Q.ParamByName('dta_inicio_validade').AsDateTime := DtaInicioValidade;
      Q.ParamByName('cod_registro_log').AsInteger     := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_local_tipo_fonte_agua', CodRegistroLog, 1, 98);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      If TransacaoInterna Then Begin
        Commit('LOCAIS_ADICIONAR_TIPO_FONTE_AGUA');
      End Else Begin
        Commit;
      End;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(341, Self.ClassName, 'AdicionarTipoFonteAgua', [E.Message]);
        Result := -341;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
