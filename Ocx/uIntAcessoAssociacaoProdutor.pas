unit uIntAcessoAssociacaoProdutor;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db;

type
  { TIntAcessoAssociacaoProdutor }
  TIntAcessoAssociacaoProdutor = class(TIntClasseBDNavegacaoBasica)
  public
    function Adicionar(CodPessoaProdutor, CodPessoaAssociacao: Integer): Integer;
    function PesquisarAssociacoes(CodPessoaProdutor: Integer): Integer;
    function PesquisarProdutores(CodPessoaAssociacao: Integer): Integer;
    function Retirar(CodPessoaProdutor, CodPessoaAssociacao: Integer): Integer;
  end;

implementation

{ TIntAcessoAssociacaoProdutor }

function TIntAcessoAssociacaoProdutor.Adicionar(CodPessoaProdutor,
  CodPessoaAssociacao: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  NomAssociacao, NomProdutor : String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Adicionar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(74) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Adicionar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se usuário tem papel permitido para executar o método
  If (Conexao.CodPapelUsuario <> 2) and (Conexao.CodPapelUsuario <> 4) Then Begin
    Mensagens.Adicionar(258, Self.ClassName, 'Adicionar', []);
    Result := -258;
    Exit;
  End;

  // Se usuário é produtor, verifica se ele é o próprio produtor ao qual está sendo
  // associada uma associação
  If Conexao.CodPapelUsuario = 4 Then Begin
    If Conexao.CodProdutor <> CodPessoaProdutor Then Begin
      Mensagens.Adicionar(259, Self.ClassName, 'Adicionar', []);
      Result := -259;
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se a pessoa da associacao é realmente uma associacao
      // se for, pega o nome dela
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.nom_pessoa ');
      Q.SQL.Add('  from tab_pessoa_papel tpp, ');
      Q.SQL.Add('       tab_pessoa tp ');
      Q.SQL.Add(' where tpp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('   and tp.cod_pessoa = tpp.cod_pessoa ');
      Q.SQL.Add('   and tpp.cod_papel = 1 ');
      Q.SQL.Add('   and tpp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaAssociacao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(260, Self.ClassName, 'Adicionar', []);
        Result := -260;
        Exit;
      End;
      NomAssociacao := Q.FieldByName('nom_pessoa').AsString;
      Q.Close;

      // Verifica se a pessoa do produtor é realmente um produtor
      // se for, pega o nome dele
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.nom_pessoa ');
      Q.SQL.Add('  from tab_pessoa_papel tpp, ');
      Q.SQL.Add('       tab_pessoa tp ');
      Q.SQL.Add(' where tpp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('   and tp.cod_pessoa = tpp.cod_pessoa ');
      Q.SQL.Add('   and tpp.cod_papel = 4 ');
      Q.SQL.Add('   and tpp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(180, Self.ClassName, 'Adicionar', []);
        Result := -180;
        Exit;
      End;
      NomProdutor := Q.FieldByName('nom_pessoa').AsString;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_produtor ');
      Q.SQL.Add(' where cod_pessoa_associacao = :cod_pessoa_associacao ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_associacao').AsInteger := CodPessoaAssociacao;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(360, Self.ClassName, 'Adicionar', [NomProdutor, NomAssociacao]);
        Result := -360;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

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
      Q.SQL.Add('insert into tab_associacao_produtor ');
      Q.SQL.Add(' (cod_pessoa_associacao, ');
      Q.SQL.Add('  cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_registro_log) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_associacao, ');
      Q.SQL.Add('  :cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_registro_log) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_associacao').AsInteger := CodPessoaAssociacao;
      Q.ParamByName('cod_pessoa_produtor').AsInteger   := CodPessoaProdutor;
      Q.ParamByName('cod_registro_log').AsInteger      := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_associacao_produtor', CodRegistroLog, 1, 74);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(261, Self.ClassName, 'Adicionar', [E.Message]);
        Result := -261;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAcessoAssociacaoProdutor.PesquisarAssociacoes(
  CodPessoaProdutor: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarAssociacoes');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(76) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarAssociacoes', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pessoa as CodPessoa, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tp.cod_natureza_pessoa as CodNaturezaPessoa, ');
  Query.SQL.Add('       case tp.cod_natureza_pessoa ');
  Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2)) ');
  Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2)) ');
  Query.SQL.Add('       end NumCNPJCPFFormatado ');
  Query.SQL.Add('  from tab_pessoa tp, ');
  Query.SQL.Add('       tab_associacao_produtor tap ');
  Query.SQL.Add(' where tp.cod_pessoa = tap.cod_pessoa_associacao ');
  Query.SQL.Add('   and tap.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tp.dta_fim_validade is null ');
  Query.SQL.Add(' order by tp.nom_pessoa ');
{$ENDIF}
  Query.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(265, Self.ClassName, 'PesquisarAssociacoes', [E.Message]);
      Result := -265;
      Exit;
    End;
  End;
end;

function TIntAcessoAssociacaoProdutor.PesquisarProdutores(
  CodPessoaAssociacao: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarProdutores');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(77) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarProdutores', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pessoa as CodPessoa, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tp.cod_natureza_pessoa as CodNaturezaPessoa, ');
  Query.SQL.Add('       case tp.cod_natureza_pessoa ');
  Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2)) ');
  Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2)) ');
  Query.SQL.Add('       end NumCNPJCPFFormatado ');
  Query.SQL.Add('  from tab_pessoa tp, ');
  Query.SQL.Add('       tab_associacao_produtor tap ');
  Query.SQL.Add(' where tp.cod_pessoa = tap.cod_pessoa_produtor ');
  Query.SQL.Add('   and tap.cod_pessoa_associacao = :cod_pessoa_associacao ');
  Query.SQL.Add('   and tp.dta_fim_validade is null ');
  Query.SQL.Add(' order by tp.nom_pessoa ');
{$ENDIF}
  Query.ParamByName('cod_pessoa_associacao').AsInteger := CodPessoaAssociacao;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(266, Self.ClassName, 'PesquisarProdutores', [E.Message]);
      Result := -266;
      Exit;
    End;
  End;
end;

function TIntAcessoAssociacaoProdutor.Retirar(CodPessoaProdutor,
  CodPessoaAssociacao: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Retirar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(75) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Retirar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se usuário tem papel permitido para executar o método
  If (Conexao.CodPapelUsuario <> 2) and (Conexao.CodPapelUsuario <> 4) Then Begin
    Mensagens.Adicionar(262, Self.ClassName, 'Retirar', []);
    Result := -262;
    Exit;
  End;

  // Se usuário é produtor, verifica se ele é o próprio produtor ao qual está sendo
  // associada uma associação
  If Conexao.CodPapelUsuario = 4 Then Begin
    If Conexao.CodProdutor <> CodPessoaProdutor Then Begin
      Mensagens.Adicionar(263, Self.ClassName, 'Retirar', []);
      Result := -263;
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_associacao_produtor ');
      Q.SQL.Add(' where cod_pessoa_associacao = :cod_pessoa_associacao ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_associacao').AsInteger := CodPessoaAssociacao;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Result := 0;
        Exit;
      End Else Begin
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_associacao_produtor', CodRegistroLog, 4, 75);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete tab_associacao_produtor ');
      Q.SQL.Add(' where cod_pessoa_associacao = :cod_pessoa_associacao ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_associacao').AsInteger := CodPessoaAssociacao;
      Q.ParamByName('cod_pessoa_produtor').AsInteger   := CodPessoaProdutor;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(264, Self.ClassName, 'Retirar', [E.Message]);
        Result := -264;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.

