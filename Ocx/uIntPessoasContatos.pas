// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Versão             : 1
// *  Data               : 24/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 52
// *  Descrição Resumida : Cadastro de contatos de uma pessoas
// ************************************************************************
// *  Últimas Alterações
// *
// ************************************************************************

unit uIntPessoasContatos;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
  uFerramentas;

type
  { TInPessoasContatos }
  TIntPessoasContatos = class(TIntClasseBDNavegacaoBasica)
  public
    function DefinirPrincipalGrupo(CodPessoa: Integer; CodGrupo: String): Integer;
    function DefinirPrincipal(CodPessoa, CodContato: Integer): Integer;
    function Inserir(CodPessoa, CodTipoContato: Integer;
      TxtContato: String): Integer;
    function Pesquisar(CodPessoa: Integer;
      CodGrupoContato: String): Integer;
    function Alterar(CodPessoa, CodContato, CodTipoContato: Integer;
      TxtContato: String): Integer;
    function Excluir(CodPessoa, CodContato: Integer): Integer;

    /////////////////////////////
    // Métodos da carga inicial
    procedure InserirContatoCargaInicial(CodPessoa: Integer; TipoContato,
      TxtContato: String);
    /////////////////////////////
  end;

implementation

{ TIntPessoasContatos }

function TIntPessoasContatos.DefinirPrincipalGrupo(CodPessoa: Integer;
  CodGrupo: String): Integer;
var
 QQ: THerdomQuery;
begin
  { Esta rotina define de forma padrão o novo contato principal para um grupo
    de contato informado, utilizada quando o contato principal é excluído ou o
    mesmo tem seu grupo alterado.
    A regra utilizada para eleger o principal é a seguinte:
    - Assume-se o contato de maior campo "cod_contato", teóricamente o último
    contato cadastrado para a pessoa
    OBS:
      Como esta rotina só é executada a partir de outras, a transação é de total
      responsabilidade do procedimento pai que a chamou }

  QQ := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Desmarca o(s) contato(s) do grupo referente ao contato informado
      // que estava(m) marcado(s) como principal(is)
      QQ.SQL.Clear;
{$IFDEF MSSQL}
      QQ.SQL.Add('update tab_pessoa_contato set');
      QQ.SQL.Add('  ind_principal = ''N''');
      QQ.SQL.Add('where');
      QQ.SQL.Add('  cod_pessoa = :cod_pessoa');
      QQ.SQL.Add('  and cod_contato in (select cod_contato');
      QQ.SQL.Add('                      from tab_pessoa_contato tpc, tab_tipo_contato ttc');
      QQ.SQL.Add('                      where tpc.cod_tipo_contato = ttc.cod_tipo_contato');
      QQ.SQL.Add('                        and ttc.cod_grupo_contato = :cod_grupo_contato');
      QQ.SQL.Add('                        and tpc.cod_pessoa = :cod_pessoa');
      QQ.SQL.Add('                        and tpc.ind_principal = ''S'')');
{$ENDIF}
      QQ.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      QQ.ParamByName('cod_grupo_contato').AsString := CodGrupo;
      QQ.ExecSQL;

      // Elege um contato para principal
      QQ.SQL.Clear;
{$IFDEF MSSQL}
      QQ.SQL.Add('update tab_pessoa_contato set');
      QQ.SQL.Add('  ind_principal = ''S''');
      QQ.SQL.Add('where');
      QQ.SQL.Add('  cod_pessoa = :cod_pessoa');
      QQ.SQL.Add('  and cod_contato = (select max(cod_contato)');
      QQ.SQL.Add('                     from tab_pessoa_contato tpc, tab_tipo_contato ttc');
      QQ.SQL.Add('                     where tpc.cod_tipo_contato = ttc.cod_tipo_contato');
      QQ.SQL.Add('                       and ttc.cod_grupo_contato = :cod_grupo_contato');
      QQ.SQL.Add('                       and tpc.cod_pessoa = :cod_pessoa)');
{$ENDIF}
      QQ.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      QQ.ParamByName('cod_grupo_contato').AsString := CodGrupo;
      QQ.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(684, Self.ClassName, 'DefinirPrincipalGrupo', [E.Message]);
        Result := -684;
        Exit;
      End;
    End;
  Finally
    QQ.Free;
  End;
end;

function TIntPessoasContatos.DefinirPrincipal(CodPessoa,
  CodContato: Integer): Integer;
const
  Metodo: Integer = 219;
var
  Q: THerdomQuery;
  CodGrupoContato: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('DefinirPrincipal');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirPrincipal', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste pessoa informada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'DefinirPrincipal', []);
        Result := -212;
        Exit;
      End;
      Q.Close;

      // Verifica se o contato é válido
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  ttc.cod_grupo_contato');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa_contato tpc');
      Q.SQL.Add('  , tab_tipo_contato ttc');
      Q.SQL.Add('where ttc.cod_tipo_contato = tpc.cod_tipo_contato');
      Q.SQL.Add('  and cod_contato = :cod_contato');
      Q.SQL.Add('  and cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(681, Self.ClassName, 'DefinirPrincipal', []);
        Result := -681;
        Exit;
      End;
      CodGrupoContato := Q.FieldByName('cod_grupo_contato').AsString;
      Q.Close;

      // Abre transação
      BeginTran;

      // Para está operação não é gerado um registro de log!

      // Desmarca o(s) contato(s) do grupo referente ao contato informado
      // que estava(m) marcado(s) como principal(is)
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_contato set');
      Q.SQL.Add('  ind_principal = ''N''');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_contato in (select cod_contato');
      Q.SQL.Add('                      from tab_pessoa_contato tpc, tab_tipo_contato ttc');
      Q.SQL.Add('                      where tpc.cod_tipo_contato = ttc.cod_tipo_contato');
      Q.SQL.Add('                        and ttc.cod_grupo_contato = :cod_grupo_contato');
      Q.SQL.Add('                        and tpc.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('                        and tpc.ind_principal = ''S'')');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_grupo_contato').AsString := CodGrupoContato;
      Q.ExecSQL;

      // Marca o contato informado como principal
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_contato set');
      Q.SQL.Add('  ind_principal = ''S''');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_contato = :cod_contato');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(684, Self.ClassName, 'DefinirPrincipal', [E.Message]);
        Result := -684;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasContatos.Alterar(CodPessoa, CodContato,
  CodTipoContato: Integer; TxtContato: String): Integer;
const
  Metodo: Integer = 210;
var
  Q: THerdomQuery;
  CodRegistroLog: Integer;
  RedefinirPrincipalGrupoAntigo: Boolean;
  CodGrupoContato, CodGrupoContatoAntigo, IndPrincipal: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Trata descrição do contato
  Result := VerificaString(TxtContato, 'Descrição do Contato');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(TxtContato, 50, 'Descrição do Contato');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste pessoa informada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'Alterar', []);
        Result := -212;
        Exit;
      End;
      Q.Close;

      // Consiste contato informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_grupo_contato from tab_tipo_contato');
      Q.SQL.Add(' where cod_tipo_contato = :cod_tipo_contato');
{$ENDIF}
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(676, Self.ClassName, 'Alterar', []);
        Result := -676;
        Exit;
      End;
      CodGrupoContato := Q.FieldByName('cod_grupo_contato').AsString;
      Q.Close;

      // Verifica se o contato é válido
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  ttc.cod_grupo_contato');
      Q.SQL.Add('  , tpc.ind_principal');
      Q.SQL.Add('  , tpc.cod_registro_log');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa_contato tpc');
      Q.SQL.Add('  , tab_tipo_contato ttc');
      Q.SQL.Add('where ttc.cod_tipo_contato = tpc.cod_tipo_contato');
      Q.SQL.Add('  and cod_contato = :cod_contato');
      Q.SQL.Add('  and cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(681, Self.ClassName, 'Alterar', []);
        Result := -681;
        Exit;
      End;
      CodGrupoContatoAntigo := Q.FieldByName('cod_grupo_contato').AsString;
      IndPrincipal := Q.FieldByName('ind_principal').AsString;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Verifica se o contato já existe na base
      // com o tipo e descrição informados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_contato');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and cod_tipo_contato = :cod_tipo_contato');
      Q.SQL.Add('   and txt_contato = :txt_contato');
      Q.SQL.Add('   and cod_contato != :cod_contato');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.ParamByName('txt_contato').AsString := TxtContato;
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(677, Self.ClassName, 'Alterar', []);
        Result := -677;
        Exit;
      End;
      Q.Close;

      if CodGrupoContato <> CodGrupoContatoAntigo then begin
        // Verifica se o contato é o primeiro do grupo referente ao tipo
        // se for, já marca o contato como principal
        // ! Apenas se o grupo do contato tiver sido alterado !
        RedefinirPrincipalGrupoAntigo := (IndPrincipal = 'S');
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1');
        Q.SQL.Add('from');
        Q.SQL.Add('  tab_tipo_contato ttc');
        Q.SQL.Add('  , tab_pessoa_contato tpc');
        Q.SQL.Add('where');
        Q.SQL.Add('  ttc.cod_grupo_contato = :cod_grupo_contato');
        Q.SQL.Add('  and ttc.cod_tipo_contato = tpc.cod_tipo_contato');
        Q.SQL.Add('  and tpc.cod_pessoa = :cod_pessoa');
{$ENDIF}
        Q.ParamByName('cod_grupo_contato').AsString := CodGrupoContato;
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Q.Open;
        If not Q.IsEmpty Then Begin
          IndPrincipal := 'N';
        end else begin
          IndPrincipal := 'S';
        End;
        Q.Close;
      end else begin
        RedefinirPrincipalGrupoAntigo := False;
      end;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_contato', CodRegistroLog, 2, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_contato set');
      Q.SQL.Add('   cod_tipo_contato = :cod_tipo_contato');
      Q.SQL.Add('   , txt_contato = :txt_contato');
      Q.SQL.Add('   , ind_principal = :ind_principal');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_contato = :cod_contato');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.ParamByName('txt_contato').AsString := TxtContato;
      Q.ParamByName('ind_principal').AsString := IndPrincipal;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_contato', CodRegistroLog, 3, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      if RedefinirPrincipalGrupoAntigo then begin
        Result := DefinirPrincipalGrupo(CodPessoa, CodGrupoContatoAntigo);
        if Result < 0 Then Begin
          Rollback;
          Exit;
        end;
      end;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(682, Self.ClassName, 'Alterar', [E.Message]);
        Result := -682;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasContatos.Excluir(CodPessoa,
  CodContato: Integer): Integer;
const
  Metodo: Integer = 217;
var
  Q: THerdomQuery;
  CodRegistroLog: Integer;
  CodGrupoContato, IndPrincipal: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste pessoa informada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'Excluir', []);
        Result := -212;
        Exit;
      End;
      Q.Close;

      // Verifica se o contato é válido
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  ttc.cod_grupo_contato');
      Q.SQL.Add('  , tpc.ind_principal');
      Q.SQL.Add('  , tpc.cod_registro_log');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa_contato tpc');
      Q.SQL.Add('  , tab_tipo_contato ttc');
      Q.SQL.Add('where ttc.cod_tipo_contato = tpc.cod_tipo_contato');
      Q.SQL.Add('  and cod_contato = :cod_contato');
      Q.SQL.Add('  and cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(681, Self.ClassName, 'Excluir', []);
        Result := -681;
        Exit;
      End;
      CodGrupoContato := Q.FieldByName('cod_grupo_contato').AsString;
      IndPrincipal := Q.FieldByName('ind_principal').AsString;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_contato', CodRegistroLog, 4, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_pessoa_contato');
      Q.SQL.Add('where');
      Q.SQL.Add('  cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and cod_contato = :cod_contato');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ExecSQL;

      if IndPrincipal = 'S' then begin
        Result := DefinirPrincipalGrupo(CodPessoa, CodGrupoContato);
        if Result < 0 Then Begin
          Rollback;
          Exit;
        end;
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(683, Self.ClassName, 'Excluir', [E.Message]);
        Result := -683;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasContatos.Inserir(CodPessoa, CodTipoContato: Integer;
  TxtContato: String): Integer;
const
  Metodo: Integer = 209;
var
  Q: THerdomQuery;
  CodGrupoContato, IndPrincipal: String;
  CodContato, CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  // Trata descrição do contato
  Result := VerificaString(TxtContato, 'Descrição do Contato');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(TxtContato, 50, 'Descrição do Contato');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste pessoa informada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'Inserir', []);
        Result := -212;
        Exit;
      End;
      Q.Close;

      // Consiste contato informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_grupo_contato from tab_tipo_contato');
      Q.SQL.Add(' where cod_tipo_contato = :cod_tipo_contato');
{$ENDIF}
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(676, Self.ClassName, 'Inserir', []);
        Result := -676;
        Exit;
      End;
      CodGrupoContato := Q.FieldByName('cod_grupo_contato').AsString;
      Q.Close;

      // Verifica se o contato já existe na base
      // com o tipo e descrição informados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_contato');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
      Q.SQL.Add('   and cod_tipo_contato = :cod_tipo_contato');
      Q.SQL.Add('   and txt_contato = :txt_contato');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.ParamByName('txt_contato').AsString := TxtContato;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(677, Self.ClassName, 'Inserir', []);
        Result := -677;
        Exit;
      End;
      Q.Close;

      // Verifica se o contato é o primeiro do grupo referente ao tipo
      // se for, já marca o contato como principal
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_tipo_contato ttc');
      Q.SQL.Add('  , tab_pessoa_contato tpc');
      Q.SQL.Add('where');
      Q.SQL.Add('  ttc.cod_grupo_contato = :cod_grupo_contato');
      Q.SQL.Add('  and ttc.cod_tipo_contato = tpc.cod_tipo_contato');
      Q.SQL.Add('  and tpc.cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_grupo_contato').AsString := CodGrupoContato;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      If not Q.IsEmpty Then Begin
        IndPrincipal := 'N';
      end else begin
        IndPrincipal := 'S';
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      end;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_contato), 0) + 1 as cod_contato');
      Q.SQL.Add('  from tab_pessoa_contato');
      Q.SQL.Add(' where cod_pessoa = :cod_pessoa');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      CodContato := Q.FieldByName('cod_contato').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_pessoa_contato');
      Q.SQL.Add('  (cod_pessoa');
      Q.SQL.Add('   , cod_contato');
      Q.SQL.Add('   , cod_tipo_contato');
      Q.SQL.Add('   , txt_contato');
      Q.SQL.Add('   , ind_principal');
      Q.SQL.Add('   , cod_registro_log)');
      Q.SQL.Add('values');
      Q.SQL.Add('  (:cod_pessoa');
      Q.SQL.Add('   , :cod_contato');
      Q.SQL.Add('   , :cod_tipo_contato');
      Q.SQL.Add('   , :txt_contato');
      Q.SQL.Add('   , :ind_principal');
      Q.SQL.Add('   , :cod_registro_log)');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_contato').AsInteger := CodContato;
      Q.ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
      Q.ParamByName('txt_contato').AsString := TxtContato;
      Q.ParamByName('ind_principal').AsString := IndPrincipal;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_contato', CodRegistroLog, 1, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodContato;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(680, Self.ClassName, 'Inserir', [E.Message]);
        Result := -680;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasContatos.Pesquisar(CodPessoa: Integer;
  CodGrupoContato: String): Integer;
const
  Metodo: Integer = 218;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  with Query.SQL do
  begin
    Clear;
{$IFDEF MSSQL}
    Add('select');
    Add('  tpe.cod_pessoa          as CodPessoa');
    Add('  , tpc.cod_contato       as CodContato');
    Add('  , ttc.cod_tipo_contato  as CodTipoContato');
    Add('  , ttc.sgl_tipo_contato  as SglTipoContato');
    Add('  , ttc.des_tipo_contato  as DesTipoContato');
    Add('  , tpc.txt_contato       as TxtContato');
    Add('  , tpc.ind_principal     as IndPrincipal');
    Add('  , ttc.cod_grupo_contato as CodGrupoContato');
    Add('from');
    Add('  tab_pessoa tpe');
    Add('  , tab_tipo_contato ttc');
    Add('  , tab_pessoa_contato tpc');
    Add('where');
    Add('  tpe.cod_pessoa = :cod_pessoa');
    Add('  and tpe.dta_fim_validade is null');
    Add('  and tpc.cod_pessoa = tpe.cod_pessoa');
    Add('  and ttc.cod_tipo_contato = tpc.cod_tipo_contato');
    if CodGrupoContato <> '' then begin
      Add('  and ttc.cod_grupo_contato = :cod_grupo_contato');
    end;
    Add('order by');
    Add('  ttc.num_ordem');
{$ENDIF}
  end;
  Try
    Query.ParamByName('cod_pessoa').AsInteger := CodPessoa;
    if CodGrupoContato <> '' then begin
      Query.ParamByName('cod_grupo_contato').AsString := CodGrupoContato;
    end;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(624, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -624;
      Exit;
    End;
  End;
end;

procedure TIntPessoasContatos.InserirContatoCargaInicial(CodPessoa: Integer;
  TipoContato, TxtContato: String);
const
  NomeMetodo: String = 'InserirContato';
var
  Retorno: Integer;
  CodTipoContato: Integer;
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    if Trim(TipoContato) = '' then
    begin
      raise Exception.Create('O parametro TipoContato é obrigatório.'); 
    end;

    if CodPessoa <= 0 then
    begin
      raise Exception.Create('O parametro CodPessoa é obrigatório.');
    end;

    CodTipoContato := -1;
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_tipo_contato');
        SQL.Add('  FROM tab_tipo_contato');
        SQL.Add(' WHERE cod_tipo_contato_sisbov = :cod_tipo_contato_sisbov');

        ParamByName('cod_tipo_contato_sisbov').AsString := Trim(TipoContato);
        Open;

        if IsEmpty then
        begin
          raise Exception.Create('Tipo de contato "' + TipoContato + '" inválido');
        end;

        CodTipoContato := FieldByName('cod_tipo_contato').AsInteger;
      end;

      // Verifica se existe mais de um contato do mesmo tipo
      // se existir o contato é ignorado
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT 1');
        SQL.Add('  FROM tab_pessoa_contato');
        SQL.Add(' WHERE cod_tipo_contato = :cod_tipo_contato');
        SQL.Add('   AND cod_pessoa = :cod_pessoa');

        ParamByName('cod_tipo_contato').AsInteger := CodTipoContato;
        ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Open;

        if not IsEmpty then
        begin
          Exit;
        end;
      end;
    except
      QueryLocal.Free;
    end;

    Retorno := Inserir(CodPessoa, CodTipoContato, TxtContato);
    if Retorno < 0 then
    begin
      raise EHerdomException.Create(Retorno * -1, Self.ClassName, NomeMetodo,
        [], True);
    end;
  except
    on E: EHerdomException do
    begin
      raise;
    end;
    on E: Exception do
    begin
      raise EHerdomException.Create(2079, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

end.


