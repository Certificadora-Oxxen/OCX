unit uIntAcessoTecnicoProdutor;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db;

type
  { TIntAcessoTecnicoProdutor }
  TIntAcessoTecnicoProdutor = class(TIntClasseBDNavegacaoBasica)
  public
    function Adicionar(ECodPessoaProdutor,
                       ECodPessoaTecnico: Integer): Integer;

    function PesquisarTecnicos(CodPessoaProdutor: Integer; ind_considerar_inativos: String): Integer;

    function PesquisarProdutores(CodPessoaTecnico: Integer): Integer;

    function Retirar(CodPessoaProdutor, CodPessoaTecnico: Integer): Integer;
  end;

implementation

{ TIntAcessoTecnicoProdutor }

function TIntAcessoTecnicoProdutor.Adicionar(ECodPessoaProdutor,
                                             ECodPessoaTecnico: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog, TipoLog : Integer;
  NomProdutor, NomTecnico : String;
  Desativado: Boolean;
begin
  Result := -1;

  if Not Inicializado then
  begin
    RaiseNaoInicializado('Adicionar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(70) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Adicionar', []);
    Result := -188;
    Exit;
  end;

  // Verifica se usuário tem papel permitido para executar o método
  if (Conexao.CodPapelUsuario <> 2) and
     (Conexao.CodPapelUsuario <> 3) and
     (Conexao.CodPapelUsuario <> 4) and
     (Conexao.CodPapelUsuario <> 9) then
  begin
    Mensagens.Adicionar(267, Self.ClassName, 'Adicionar', []);
    Result := -267;
    Exit;
  end;

  // Se usuário é produtor, verifica se ele é o próprio produtor ao qual está sendo
  // associado um técnico
  if Conexao.CodPapelUsuario = 4 then
  begin
    if Conexao.CodProdutor <> ECodPessoaProdutor then
    begin
      Mensagens.Adicionar(268, Self.ClassName, 'Adicionar', []);
      Result := -268;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica se a pessoa do tecnico é realmente uma tecnico
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select tp.nom_pessoa ');
      Q.SQL.Add('  from tab_pessoa_papel tpp, ');
      Q.SQL.Add('       tab_pessoa tp ');
      Q.SQL.Add(' where tpp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('   and tp.cod_pessoa = tpp.cod_pessoa ');
      Q.SQL.Add('   and tpp.cod_papel = 3 ');
      Q.SQL.Add('   and tpp.dta_fim_validade is null ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoaTecnico;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(269, Self.ClassName, 'Adicionar', []);
        Result := -269;
        Exit;
      end;
      NomTecnico := Q.FieldByName('nom_pessoa').AsString;
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
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoaProdutor;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(180, Self.ClassName, 'Adicionar', []);
        Result := -180;
        Exit;
      end;
      NomProdutor := Q.FieldByName('nom_pessoa').AsString;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select CAST(isNull(dta_fim_validade, 0) AS INTEGER) as dta from tab_tecnico_produtor ');
      Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_tecnico').AsInteger := ECodPessoaTecnico;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoaProdutor;
      Q.Open;
      if (not Q.IsEmpty) and
         (Q.FieldByName('dta').AsInteger = 0) then
      begin
        Mensagens.Adicionar(361, Self.ClassName, 'Adicionar', [NomTecnico, NomProdutor]);
        Result := -361;
        Exit;
      end;

      // flag que indica se o técnico já esta relacionado a este produtor, mas esta desativado
      Desativado := (not Q.IsEmpty) and (Q.FieldByName('dta').AsInteger <> 0);
      Q.Close;

      // Abre transação
      BeginTran;

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
      // Se o técnico numca foi relacionado ao produtor
      // insere um novo registro na base
      if not Desativado then
      begin
        TipoLog := 1;
        {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_tecnico_produtor ');
        Q.SQL.Add(' (cod_pessoa_tecnico, ');
        Q.SQL.Add('  cod_pessoa_produtor, ');
        Q.SQL.Add('  cod_registro_log) ');
        Q.SQL.Add('values ');
        Q.SQL.Add(' (:cod_pessoa_tecnico, ');
        Q.SQL.Add('  :cod_pessoa_produtor, ');
        Q.SQL.Add('  :cod_registro_log) ');
        {$ENDIF}
      end
      else
      begin
        // se o técnico já foi relacionado ao produtor, mas está desativado
        // reativa o relacionamento
        TipoLog := 3;
        {$IFDEF MSSQL}
        Q.SQL.Add('update tab_tecnico_produtor ');
        Q.SQL.Add('   set dta_fim_validade = NULL, cod_registro_log = :cod_registro_log');
        Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
        Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      end;
      Q.ParamByName('cod_pessoa_tecnico').AsInteger  := ECodPessoaTecnico;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoaProdutor;
      Q.ParamByName('cod_registro_log').AsInteger    := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_tecnico_produtor', CodRegistroLog, TipoLog, 70);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    except
      on E: exception do
      begin
        Rollback;
        Mensagens.Adicionar(270, Self.ClassName, 'Adicionar', [E.Message]);
        Result := -270;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntAcessoTecnicoProdutor.PesquisarTecnicos(
  CodPessoaProdutor: Integer; ind_considerar_inativos: String): Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('PesquisarTecnicos');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(72) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarTecnicos', []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pessoa as CodPessoa, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tp.nom_reduzido_pessoa as NomReduzidoPessoa, ');
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
  Query.SQL.Add('       end NumCNPJCPFFormatado, ');
  Query.SQL.Add('       tap.dta_fim_validade as DtaFimValidade ');
  Query.SQL.Add('  from tab_pessoa tp, ');
  Query.SQL.Add('       tab_tecnico_produtor tap ');
  Query.SQL.Add(' where tp.cod_pessoa = tap.cod_pessoa_tecnico ');
  Query.SQL.Add('   and tap.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tp.dta_fim_validade is null ');

  if (Conexao.CodPapelUsuario = 9) then
  begin
    Query.SQL.Add('   and tp.cod_pessoa in ( select ttp.cod_pessoa_tecnico as cod_pessoa ');
    Query.SQL.Add('                            from tab_tecnico_produtor ttp ');
    Query.SQL.Add('                               , tab_tecnico tt');
    Query.SQL.Add('                           where tt.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico');
    Query.SQL.Add('                             and tt.cod_pessoa_gestor  = :cod_pessoa_gestor ');
    Query.SQL.Add('                             and tt.dta_fim_validade is null ');
    Query.SQL.Add('                             and ttp.dta_fim_validade is null )');
    Query.ParamByName('cod_pessoa_gestor').AsInteger := Conexao.CodPessoa;
  end;

  if UpperCase(ind_considerar_inativos) <> 'S' then begin
    Query.SQL.Add('   and tap.dta_fim_validade is null ');
  end;

  Query.SQL.Add(' order by tp.nom_pessoa ');
{$ENDIF}
  Query.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(274, Self.ClassName, 'PesquisarTecnicos', [E.Message]);
      Result := -274;
      Exit;
    end;
  end;
end;

function TIntAcessoTecnicoProdutor.PesquisarProdutores(
  CodPessoaTecnico: Integer): Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('PesquisarProdutores');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(73) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarProdutores', []);
    Result := -188;
    Exit;
  end;

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
  Query.SQL.Add('       tab_tecnico_produtor tap ');
  Query.SQL.Add(' where tp.cod_pessoa = tap.cod_pessoa_produtor ');
  Query.SQL.Add('   and tap.cod_pessoa_tecnico = :cod_pessoa_tecnico ');
  Query.SQL.Add('   and tp.dta_fim_validade is null ');
  Query.SQL.Add('   and tap.dta_fim_validade is null ');
  Query.SQL.Add(' order by tp.nom_pessoa ');
{$ENDIF}
  Query.ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoaTecnico;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(275, Self.ClassName, 'PesquisarProdutores', [E.Message]);
      Result := -275;
      Exit;
    end;
  end;
end;

function TIntAcessoTecnicoProdutor.Retirar(CodPessoaProdutor,
  CodPessoaTecnico: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('Retirar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(71) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Retirar', []);
    Result := -188;
    Exit;
  end;

  // Verifica se usuário tem papel permitido para executar o método
  if (Conexao.CodPapelUsuario <> 2) and
     (Conexao.CodPapelUsuario <> 4) and
     (Conexao.CodPapelUsuario <> 9) then
  begin
    Mensagens.Adicionar(271, Self.ClassName, 'Retirar', []);
    Result := -271;
    Exit;
  end;

  // Se usuário é produtor, verifica se ele é o próprio produtor ao qual está sendo
  // associada uma associação
  if Conexao.CodPapelUsuario = 4 then
  begin
    if Conexao.CodProdutor <> CodPessoaProdutor then
    begin
      Mensagens.Adicionar(272, Self.ClassName, 'Retirar', []);
      Result := -272;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_tecnico_produtor ');
      Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoaTecnico;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      if Q.IsEmpty then
      begin
        Result := 0;
        Exit;
      end
      else
      begin
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      end;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_tecnico_produtor', CodRegistroLog, 5, 71);
      if Result < 0 then
      begin
        Rollback;
        Exit;
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('update tab_tecnico_produtor ');
      Q.SQL.Add('   set dta_fim_validade = getDate() ');
      Q.SQL.Add(' where cod_pessoa_tecnico = :cod_pessoa_tecnico ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa_tecnico').AsInteger := CodPessoaTecnico;
      Q.ParamByName('cod_pessoa_produtor').AsInteger   := CodPessoaProdutor;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status OK
      Result := 0;
    except
      on E: exception do
      begin
        Rollback;
        Mensagens.Adicionar(273, Self.ClassName, 'Retirar', [E.Message]);
        Result := -273;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

end.

