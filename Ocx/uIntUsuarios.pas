// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 17/07/2002
// *  Descrição Resumida : Cadastro de Usuarios
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *   Hitalo    17/07/2002  Alterar o NumCNPJCPF,Nome Pessoa,Nome usuario
// *                         adcionando Like no Método Pesquisar.
// *                         Adicionar TrataString nos Métodos Inserir ,
// *                         Alterar.
// *   Adalberto 22/06/2004  Adicionado método para verificar de usuário corrente é usuário FTP
// *                         caso positivo, bloqueará todas operações de alteração/exclusão para o mesmo                        
// *
// *
// ********************************************************************

unit uIntUsuarios;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntUsuario, dbtables, sysutils, db, uFerramentas;

type
  { TIntUsuarios }
  TIntUsuarios = class(TIntClasseBDNavegacaoBasica)
  private
    FIntUsuario : TIntUsuario;
//    function VerificaLetraNumero(Str: String): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(ENomUsuario: String;
                       ECodPerfil: Integer;
                       EIndUsuarioBloqueado: String;
                       ECodPessoa: Integer;
                       ENomPessoa: String;
                       ECodPapel: Integer;
                       ECodNaturezaPessoa,
                       ENumCNPJCPF: String;
                       ECodOrdenacao: Integer;
                       EIndPesquisarDesativados: Boolean): Integer;
                       
    function Inserir(NomUsuario, TxtSenha: String; CodPerfil: Integer;
      NomTratamento: String; CodPessoa, CodPapel: Integer): Integer;
    function Alterar(CodUsuario: Integer; NomUsuario, TxtSenha: String;
      CodPerfil: Integer; NomTratamento: String): Integer;
    function Excluir(CodUsuario: Integer): Integer;
    function Buscar(CodUsuario: Integer): Integer;
    function seUsuarioFTP(CodUsuario: Integer): Integer;
    property IntUsuario : TIntUsuario read FIntUsuario write FIntUsuario;
  end;

implementation

{ TIntUsuarios }

{ verifica se o usuário é usuário FTP }
function TIntUsuarios.seUsuarioFTP(CodUsuario: Integer): Integer;
begin
        if (CodUsuario = StrToInt(ValorParametro(74))) then begin
            Result := 1; //usuário é do tipo FTP
            exit;
        end;
    Result := -1; //Retorno NEGATIVO. NÃO é FTP
end;                                   

constructor TIntUsuarios.Create;
begin
  inherited;
  FIntUsuario := TIntUsuario.Create;
end;

destructor TIntUsuarios.Destroy;
begin
  FIntUsuario.Free;
  inherited;
end;


{* Função responsável por retornar os usuaários cadastrados na base de dados,
   de acordo com os parâmetros de entrada informados.
   Result Set composto por: CodUsuario, NomUsuario, UsuarioFTP, CodPerfil,
                            NomPerfil, IndUsuarioBloqueado, CodPessoa, NomPessoa,
                            CodPapel, DesPapel, CodNaturezaPessoa,
                            NumCNPJCPFFormatado, NomReduzidoPessoa, DtaFimValidade

   @param ENomUsuario String
   @param ECodPerfil Integer
   @param EIndUsuarioBloqueado String
   @param ECodPessoa Integer
   @param ENomPessoa String
   @param ECodPapel Integer
   @param ECodNaturezaPessoa String
   @param ENumCNPJCPF String
   @param ECodOrdenacao Integer
   @param EIndPesquisarDesativados Boolean

   @return 0 Valor retornado quando a execução do método ocorrer com sucesso.
   @return -188 Valor retornado quando o usuário que for executar o método
                (usuário logado no sistema) não possuir acesso ao método, ou seja,
                o usuário não tem acesso ao método.
   @return -2186 Valor retornado quando o usuário logado no sistema for um gestor
                 e o mesmo tentar filtrar por papeis diferentes de técnico e
                 produtor.
   @return -204 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.
}
function TIntUsuarios.Pesquisar(ENomUsuario: String;
                                ECodPerfil: Integer;
                                EIndUsuarioBloqueado: String;
                                ECodPessoa: Integer;
                                ENomPessoa: String;
                                ECodPapel: Integer;
                                ECodNaturezaPessoa,
                                ENumCNPJCPF: String;
                                ECodOrdenacao: Integer;
                                EIndPesquisarDesativados: Boolean): Integer;
const
  NomMetodo: String = 'Pesquisar';
var
  CodUsuario : Integer;
  sUsuarioFTP: String;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(37) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  end;

  if (Conexao.CodPapelUsuario = 9) and (not ECodPapel in [3, 4]) then
  begin
    Mensagens.Adicionar(2186, Self.ClassName, NomMetodo, []);
    Result := -2186;
    Exit;
  end;   

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select cod_usuario from tab_usuario where nom_usuario like :nom_usuario ');
  if ENomUsuario <> '' then
  begin
    Query.ParamByName('nom_usuario').AsString      := '%' + ENomUsuario + '%';
    Query.Open;
    CodUsuario := Query.FieldByName('cod_usuario').AsInteger;
    if seUsuarioFTP(CodUsuario) > 0 then
    begin
      sUsuarioFTP := 'Sim';
    end
    else
    begin
      sUsuarioFTP := 'Não';
    end;
  end
  else
  begin
    Query.ParamByName('nom_usuario').AsString := ' ';
    Query.Open;
    sUsuarioFTP := '';
  end;


  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select tu.cod_usuario as CodUsuario, ' +
                '        tu.nom_usuario as NomUsuario, ' +
                '        ' + '''' + sUsuarioFTP + '''' + ' as UsuarioFTP, ' +
                '        tu.cod_perfil as CodPerfil, ' +
                '        tper.nom_perfil as NomPerfil,  ' +
                '        tu.ind_usuario_bloqueado as IndUsuarioBloqueado, ' +
                '        tu.cod_pessoa as CodPessoa, ' +
                '        tp.nom_pessoa as NomPessoa, ' +
                '        tu.cod_papel as CodPapel, ' +
                '        tpap.des_papel as DesPapel, ' +
                '        tp.cod_natureza_pessoa as CodNaturezaPessoa, ' +
                '        case tp.cod_natureza_pessoa ' +
                '          when ''F'' then convert(varchar(18), ' +
                '                              substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                '                              substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                '                              substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                '                              substring(tp.num_cnpj_cpf, 10, 2)) ' +
                '          when ''J'' then convert(varchar(18), ' +
                '                              substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                '                              substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                '                              substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                '                              substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                '                              substring(tp.num_cnpj_cpf, 13, 2)) ' +
                '        end NumCNPJCPFFormatado, ' +
                '        tp.nom_reduzido_pessoa as NomReduzidoPessoa, ' +
                '        tp.dta_fim_validade as DtaFimValidade ' +
                '   from tab_usuario tu, ' +
                '        tab_perfil tper, ' +
                '        tab_pessoa tp, ' +
                '        tab_papel tpap, ' +
                '        tab_pessoa_papel tpp ' +
                '  where tu.cod_usuario <> 1 ' +
                '    and tper.cod_perfil = tu.cod_perfil ' +
                '    and tper.cod_papel = tu.cod_papel ' +
                '    and tp.cod_pessoa = tu.cod_pessoa ' +
                '    and tpap.cod_papel = tu.cod_papel ' +
                '    and tpp.cod_pessoa = tu.cod_pessoa ' +
                '    and tpp.cod_papel = tu.cod_papel ' +
//Hitalo                '   and tu.dta_fim_validade is null ' +
//Hitalo                '   and tp.dta_fim_validade is null ' +
                '    and ((tu.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ' +
                '    and ((tp.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ' +
                '    and tpp.dta_fim_validade is null ' +
                '    and ((tu.cod_perfil = :cod_perfil) or (:cod_perfil = -1)) ' +
                '    and ((tu.cod_pessoa = :cod_pessoa) or (:cod_pessoa = -1))');
  // Caso o usuário logado seja um Gestor, apenas os perfis de técnico e
  // produtor deverão ser listados.
  if (Conexao.CodPapelUsuario = 9) then
  begin
    if (ECodPapel = 4) or (ECodPapel <= 0) then
    begin
      Query.SQL.Add('  and tu.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa ' +
                    '                           from tab_tecnico_produtor ttp ' +
                    '                              , tab_tecnico tt ' +
                    '                          where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                    '                             and ttp.dta_fim_validade is null ' +
                    '                             and tt.dta_fim_validade is null ' +
                    '                             and tt.cod_pessoa_gestor = :cod_pessoa_gestor ');
      if ECodPapel = 4 then
      begin
      Query.SQL.Add('                         ) ');
      end;
    end;
    if ECodPapel <= 0 then
    begin
      Query.SQL.Add('                           union ');
    end;
    if (ECodPapel = 3) or (ECodPapel <= 0) then
    begin
      if ECodPapel = 3 then
      begin
        Query.SQL.Add('  and tu.cod_pessoa in (  ');
      end;
      Query.SQL.Add('                          select tt.cod_pessoa_tecnico as cod_pessoa ' +
                    '                            from tab_tecnico tt ' +
                    '                           where tt.dta_fim_validade is null ' +
                    '                             and tt.cod_pessoa_gestor = :cod_pessoa_gestor ' +
                    '                          ) ');
    end;
     Query.ParamByName('cod_pessoa_gestor').AsInteger := Conexao.CodPessoa;    
    if (ECodPapel < 0) then
    begin
      Query.SQL.Add('and tu.cod_papel in (3, 4) ');
    end;
  end;

  if ECodPapel >= 0 then
  begin
    Query.SQL.Add('  and tu.cod_papel = :cod_papel ');
  end;

  if (UpperCase(ECodNaturezaPessoa) = 'F') or
     (UpperCase(ECodNaturezaPessoa) = 'J') then
  begin
    Query.SQL.Add(' and tp.cod_natureza_pessoa =  :cod_natureza_pessoa ');
  end;

  if ENumCNPJCPF <> '' then
  begin
    Query.SQL.Add(' and tp.num_cnpj_cpf like :num_cnpj_cpf ');
  end;

  if (UpperCase(EIndUsuarioBloqueado) = 'S') or
     (UpperCase(EIndUsuarioBloqueado) = 'N') then
  begin
    Query.SQL.Add(' and tu.ind_usuario_bloqueado =  :ind_usuario_bloqueado ');
  end;

  if ENomUsuario <> '' then
  begin
    Query.SQL.Add(' and tu.nom_usuario like :nom_usuario ');
  end;

  if ENomPessoa <> '' then
  begin
    Query.SQL.Add(' and tp.nom_pessoa like :nom_pessoa ');
  end;

  if ECodOrdenacao = 2 then
  begin
    Query.SQL.Add(' order by tu.cod_pessoa, tpap.des_papel ');
  end
  else
  begin
    if ECodOrdenacao = 3 then
    begin
      Query.SQL.Add(' order by tp.nom_pessoa, tpap.des_papel ');
    end
    else
    begin
      Query.SQL.Add(' order by tu.nom_usuario ');
    end;
  end;
  {$ENDIF}

  Query.ParamByName('cod_perfil').AsInteger := ECodPerfil;
  Query.ParamByName('cod_pessoa').AsInteger := ECodPessoa;

  if ECodPapel >= 0 then
  begin
    Query.ParamByName('cod_papel').AsInteger := ECodPapel;
  end;

  if (UpperCase(ECodNaturezaPessoa) = 'F') or
     (UpperCase(ECodNaturezaPessoa) = 'J') then
  begin
    Query.ParamByName('cod_natureza_pessoa').AsString := ECodNaturezaPessoa;
  end;

  if ENumCNPJCPF <> '' then
  begin
    Query.ParamByName('num_cnpj_cpf').AsString := ENumCNPJCPF  + '%';
  end;

  if (UpperCase(EIndUsuarioBloqueado) = 'S') or
     (UpperCase(EIndUsuarioBloqueado) = 'N') then
  begin
    Query.ParamByName('ind_usuario_bloqueado').AsString := EIndUsuarioBloqueado;
  end;

  if ENomUsuario <> '' then
  begin
    Query.ParamByName('nom_usuario').AsString := '%' + ENomUsuario + '%';
  end;

  if ENomPessoa <> '' then
  begin
    Query.ParamByName('nom_pessoa').AsString := '%' + ENomPessoa + '%';
  end;

  if EIndPesquisarDesativados then
  begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 1;
  end
  else
  begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 0;
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do
    begin
      Mensagens.Adicionar(204, Self.ClassName, NomMetodo, [E.Message]);
      Result := -204;
      Exit;
    end;
  end;
end;

function TIntUsuarios.Inserir(NomUsuario, TxtSenha: String; CodPerfil: Integer;
  NomTratamento: String; CodPessoa, CodPapel: Integer): Integer;
var
  Q : THerdomQuery;
  CodUsuario, CodRegistroLog : Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Inserir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(38) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  end;
  //----------------------------------------------------
  //Verifica se a variável não contem espaços em brancos
  //----------------------------------------------------
  if Pos(' ', NomUsuario) > 0 then begin
    Mensagens.Adicionar(293, Self.ClassName, 'Inserir', []);
    result := -293;
    exit;
  end;

  // Verifica se tamanho do nome e senha estão corretos
  if (Length(NomUsuario) < 3) or (Length(TxtSenha) < 6) then begin
    Mensagens.Adicionar(210, Self.ClassName, 'Inserir', []);
    Result := -210;
    Exit;
  end;

  if Uppercase(TxtSenha) = UpperCase(NomUsuario) then begin
    Mensagens.Adicionar(1090, Self.ClassName, 'Inserir', []);
    Result := -1090;
    Exit;
  end;

//  // Verifica se senha possui letras e números
//  Result := VerificaLetraNumero(TxtSenha);
//  if Result < 0 then Exit;

  // Consiste NomTratamento
  if NomTratamento = '' then begin
    Mensagens.Adicionar(214, Self.ClassName, 'Inserir', []);
    Result := -214;
    Exit;
  end;

  //---------------------------------
  //Trata a variavel Nome do Usuário
  //---------------------------------
  result := TrataString(NomUsuario,15,'Nome do Usuário');

  if result < 0 then
    exit;


  //----------------------
  //Trata a variavel Senha
  //----------------------
  result := TrataString(TxtSenha,30,'Senha do Usuário');

  if result < 0 then
    exit;

  //---------------------------------
  //Trata a variavel Nome Tratamento
  //----------------------------------
  result := TrataString(NomTratamento,15,'Tratamento do Nome de Usuário');

  if result < 0 then
    exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------------
      // Verifica existencia de registro duplicado
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_usuario ');
      Q.SQL.Add(' where nom_usuario = :nom_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_usuario').AsString := NomUsuario;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(205, Self.ClassName, 'Inserir', [NomUsuario]);
        Result := -205;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa do usuário é válida
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_pessoa tp ');
      Q.SQL.Add(' where tp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('   and tp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'Inserir', []);
        Result := -212;
        Exit;
      end;
      Q.Close;

      // Verifica se o tipo de acesso do papel da pessoa do usuário é permitido
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tipo_acesso ');
      Q.SQL.Add('  from tab_papel ');
      Q.SQL.Add(' where cod_papel = :cod_papel ');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(376, Self.ClassName, 'Inserir', []);
        Result := -376;
        Exit;
      end;
      if UpperCase(Q.FieldByName('cod_tipo_acesso').AsString) = 'N' then begin
        Mensagens.Adicionar(377, Self.ClassName, 'Inserir', []);
        Result := -377;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa do usuário possui o papel informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_pessoa_papel tpp ');
      Q.SQL.Add(' where tpp.cod_pessoa = :cod_pessoa ');
      Q.SQL.Add('   and tpp.cod_papel = :cod_papel ');
      Q.SQL.Add('   and tpp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(213, Self.ClassName, 'Inserir', []);
        Result := -213;
        Exit;
      end;
      Q.Close;

      // Verifica se o papel da pessoa do usuário é compatível com o novo perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_perfil tp ');
      Q.SQL.Add(' where tp.cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and tp.cod_papel = :cod_papel ');
      Q.SQL.Add('   and tp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(211, Self.ClassName, 'Inserir', []);
        Result := -211;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_usuario), 0) + 1 as cod_usuario from tab_usuario');
{$ENDIF}
      Q.Open;
      CodUsuario := Q.FieldByName('cod_usuario').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 then begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_usuario ');
      Q.SQL.Add(' (cod_usuario, ');
      Q.SQL.Add('  nom_usuario, ');
      Q.SQL.Add('  nom_tratamento, ');
      Q.SQL.Add('  txt_senha, ');
      Q.SQL.Add('  cod_pessoa, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  cod_perfil, ');
      Q.SQL.Add('  qtd_acum_logins_corretos, ');
      Q.SQL.Add('  qtd_acum_logins_incorretos, ');
      Q.SQL.Add('  dta_ultimo_login_correto, ');
      Q.SQL.Add('  dta_ultimo_login_incorreto, ');
      Q.SQL.Add('  qtd_logins_incorretos, ');
      Q.SQL.Add('  ind_usuario_bloqueado, ');
      Q.SQL.Add('  dta_criacao_usuario, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_usuario, ');
      Q.SQL.Add('  :nom_usuario, ');
      Q.SQL.Add('  :nom_tratamento, ');
      Q.SQL.Add('  :txt_senha, ');
      Q.SQL.Add('  :cod_pessoa, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :cod_perfil, ');
      Q.SQL.Add('  0, ');
      Q.SQL.Add('  0, ');
      Q.SQL.Add('  null, ');
      Q.SQL.Add('  null, ');
      Q.SQL.Add('  0, ');
      Q.SQL.Add('  ''N'', ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger      := CodUsuario;
      Q.ParamByName('nom_usuario').AsString       := NomUsuario;
      Q.ParamByName('nom_tratamento').AsString    := NomTratamento;
      Q.ParamByName('txt_senha').AsString         := Criptografar(TxtSenha);
      Q.ParamByName('cod_pessoa').AsInteger       := CodPessoa;
      Q.ParamByName('cod_papel').AsInteger        := CodPapel;
      Q.ParamByName('cod_perfil').AsInteger       := CodPerfil;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 1, 38);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodUsuario;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(277, Self.ClassName, 'Inserir', [E.Message]);
        Result := -277;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntUsuarios.Alterar(CodUsuario: Integer; NomUsuario, TxtSenha: String;
  CodPerfil: Integer; NomTratamento: String): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Alterar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(39) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  end;

  if seUsuarioFTP(CodUsuario) > 0 then begin
        Mensagens.Adicionar(1683, Self.ClassName, 'Alterar', []);
        Result := -1683;
        Exit;
  end;

  // Verifica se pelo menos um parâmetro foi informado
  if (NomUsuario = '') and
     (TxtSenha = '') and
     (CodPerfil < 0 ) and
     (NomTratamento = '') then begin
    Mensagens.Adicionar(215, Self.ClassName, 'Alterar', []);
    Result := -215;
    Exit;
  end;

  // Verifica se tamanho do nome e senha estão corretos
  if NomUsuario <> '' then begin
    if Length(NomUsuario) < 3  then begin
      Mensagens.Adicionar(210, Self.ClassName, 'Alterar', []);
      Result := -210;
      Exit;
    end;
  end;
  if TxtSenha <> '' then begin
    if Length(TxtSenha) < 6  then begin
      Mensagens.Adicionar(210, Self.ClassName, 'Alterar', []);
      Result := -210;
      Exit;
    end;
  end;

  // Verifica se a senha é idêntica ao nome do usuário
  if (TxtSenha <> '') and (NomUsuario <> '') then begin
    if Uppercase(TxtSenha) = UpperCase(NomUsuario) then begin
      Mensagens.Adicionar(1090, Self.ClassName, 'Alterar', []);
      Result := -1090;
      Exit;
    end;
  end;

  // Verifica se senha possui letras e números
//  Result := VerificaLetraNumero(TxtSenha);
//  if Result < 0 then Exit;

  //----------------------------------------------------
  //Verifica se a variável não contem espaços em brancos
  //----------------------------------------------------
  if Pos(' ', NomUsuario) > 0 then begin
    Mensagens.Adicionar(293, Self.ClassName, 'Inserir', []);
    result := -293;
    exit;
  end;

  //---------------------------------
  //Trata a variavel Nome do Usuário
  //---------------------------------
  result := TrataString(NomUsuario,15,'Nome do Usuário');

  if result < 0 then
    exit;

  //----------------------
  //Trata a variavel Senha
  //----------------------
  result := TrataString(TxtSenha,30,'Senha do Usuário');

  if result < 0 then
    exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-------------------------------------------
      // Verifica existencia de registro duplicado
      //-------------------------------------------
//      Q.SQL.Clear;
//      {$IFDEF MSSQL}
//      Q.SQL.Add('select 1 from tab_usuario ');
//      Q.SQL.Add(' where nom_usuario  = :nom_usuario ');
//      Q.SQL.Add('   and cod_usuario != :cod_usuario ');
//      Q.SQL.Add('   and dta_fim_validade is null    ');
//      {$ENDIF}
//      Q.ParamByName('nom_usuario').AsString  := NomUsuario;
//      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
//      Q.Open;
//      if not Q.IsEmpty then begin
//        Mensagens.Adicionar(205, Self.ClassName, 'Alterar', [NomUsuario]);
//        Result := -205;
//        Exit;
//      end;
//      Q.Close;

      // Verifica existencia do registro e pega cod_registro_log do mesmo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select nom_usuario, txt_senha, cod_registro_log from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(209, Self.ClassName, 'Alterar', [IntToStr(CodUsuario)]);
        Result := -209;
        Exit;
      end else begin
        // Pega CodRegistroLog
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      end;

      // Verifica se nome informado não é idêntico à senha já gravada
      if (NomUsuario <> '') and (TxtSenha = '') then begin
        if UpperCase(NomUsuario) = Uppercase(Descriptografar(Q.FieldByName('txt_senha').AsString)) then begin
          Mensagens.Adicionar(1090, Self.ClassName, 'Alterar', []);
          Result := -1090;
          Exit;
        end;
      end;

      // Verifica se senha informada não é idêntica ao nome já gravado
      if (TxtSenha <> '') and (NomUsuario = '') then begin
        if UpperCase(TxtSenha) = Uppercase(Q.FieldByName('nom_usuario').AsString) then begin
          Mensagens.Adicionar(1090, Self.ClassName, 'Alterar', []);
          Result := -1090;
          Exit;
        end;
      end;

      Q.Close;

      // Verifica se novo nome para o usuário já existe
      if NomUsuario <> '' then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_usuario ');
        Q.SQL.Add(' where nom_usuario = :nom_usuario ');
        Q.SQL.Add('   and cod_usuario != :cod_usuario ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('nom_usuario').AsString := NomUsuario;
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(205, Self.ClassName, 'Alterar', [NomUsuario]);
          Result := -205;
          Exit;
        end;
        Q.Close;
      end;

      // Verifica se o papel da pessoa do usuário é compatível com o novo perfil
      if CodPerfil >= 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_usuario tu, ');
        Q.SQL.Add('       tab_perfil tp ');
        Q.SQL.Add(' where tp.cod_perfil = :cod_perfil ');
        Q.SQL.Add('   and tp.cod_papel = tu.cod_papel ');
        Q.SQL.Add('   and tu.cod_usuario = :cod_usuario ');
{$ENDIF}
        Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(211, Self.ClassName, 'Alterar', [NomUsuario]);
          Result := -211;
          Exit;
        end;
        Q.Close;
      end;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 2, 39);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_usuario ');
      Q.SQL.Add('   set ');
      if NomUsuario <> '' then begin
        Q.SQL.Add('   nom_usuario = :nom_usuario,');
      end;
      if TxtSenha <> '' then begin
        Q.SQL.Add('   txt_senha = :txt_senha,');
      end;
      if CodPerfil > 0 then begin
        Q.SQL.Add('   cod_perfil = :cod_perfil,');
      end;
      if NomTratamento <> '' then begin
        Q.SQL.Add('   nom_tratamento = :nom_tratamento,');
      end;

      // Pra tirar a merda de vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      if NomUsuario <> '' then begin
        Q.ParamByName('nom_usuario').AsString      := NomUsuario;
      end;
      if TxtSenha <> '' then begin
        Q.ParamByName('txt_senha').AsString      := Criptografar(TxtSenha);
      end;
      if CodPerfil > 0 then begin
        Q.ParamByName('cod_perfil').AsInteger      := CodPerfil;
      end;
      if NomTratamento <> '' then begin
        Q.ParamByName('nom_tratamento').AsString      := NomTratamento;
      end;
      Q.ParamByName('cod_usuario').AsInteger      := CodUsuario;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 3, 39);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(216, Self.ClassName, 'Alterar', [E.Message]);
        Result := -216;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntUsuarios.Excluir(CodUsuario: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Excluir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(41) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro e pega cod_registro_log do mesmo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(209, Self.ClassName, 'Excluir', [IntToStr(CodUsuario)]);
        Result := -209;
        Exit;
      end else begin
        // Pega CodRegistroLog
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      end;
      Q.Close;

      // Verifica se usuário é usuário "sistema"
      if CodUsuario = StrToInt(ValorParametro(3)) then begin
        Mensagens.Adicionar(217, Self.ClassName, 'Excluir', [IntToStr(CodUsuario)]);
        Result := -217;
        Exit;
      end;

      if seUsuarioFTP(CodUsuario) > 0 then begin
        Mensagens.Adicionar(1683, Self.ClassName, 'Excluir', [IntToStr(CodUsuario)]);
        Result := -1683;
        Exit;
      end;

      // Verifica se usuário é o próprio usuário logado
      if CodUsuario = Conexao.CodUsuario then begin
        Mensagens.Adicionar(218, Self.ClassName, 'Excluir', [IntToStr(CodUsuario)]);
        Result := -218;
        Exit;
      end;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 5, 41);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_usuario ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger      := CodUsuario;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(219, Self.ClassName, 'Excluir', [E.Message]);
        Result := -219;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntUsuarios.Buscar(CodUsuario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Buscar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(40) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tu.cod_usuario, ' +
                '       tu.nom_usuario, ' +
                '       tu.nom_tratamento, ' +
                '       tu.cod_pessoa, ' +
                '       tp.nom_pessoa, ' +
                '       tp.cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       case tp.cod_natureza_pessoa ' +
                '         when ''F'' then convert(varchar(18), ' +
                '                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                '                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                '                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                '                             substring(tp.num_cnpj_cpf, 10, 2)) ' +
                '         when ''J'' then convert(varchar(18), ' +
                '                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                '                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                '                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                '                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                '                             substring(tp.num_cnpj_cpf, 13, 2)) ' +
                '       end as num_cnpj_cpf_formatado, ' +
                '       tu.cod_papel, ' +
                '       tpa.des_papel, ' +
                '       tu.cod_perfil, ' +
                '       tpe.nom_perfil, ' +
                '       tu.qtd_acum_logins_corretos, ' +
                '       tu.qtd_acum_logins_incorretos, ' +
                '       tu.dta_ultimo_login_correto, ' +
                '       tu.dta_ultimo_login_incorreto, ' +
                '       tu.qtd_logins_incorretos , ' +
                '       tu.ind_usuario_bloqueado , ' +
                '       tu.dta_criacao_usuario   ,' +
                '       tp.nom_reduzido_pessoa   ,' +                
                '       tu.dta_fim_validade       ' +
                '  from tab_usuario tu, ' +
                '       tab_pessoa tp, ' +
                '       tab_papel tpa, ' +
                '       tab_perfil tpe ' +
                ' where tu.cod_usuario <> 1 ' +
                '   and tp.cod_pessoa = tu.cod_pessoa ' +
                '   and tpa.cod_papel = tu.cod_papel ' +
                '   and tpe.cod_perfil = tu.cod_perfil ' +
                '   and tpe.cod_papel = tu.cod_papel ' +
//hitalo                '   and tu.dta_fim_validade is null ' +
                '   and tu.cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;

      // Verifica existência do registro
      if Q.IsEmpty then begin
        Mensagens.Adicionar(209, Self.ClassName, 'Buscar', []);
        Result := -209;
        Exit;
      end;

      if seUsuarioFTP(CodUsuario) > 0 then begin
        FIntUsuario.IndUsuarioFTP := 'S';
      end else begin
        FIntUsuario.IndUsuarioFTP := 'N';
      end;


      // Obtem informações do registro
      FIntUsuario.CodUsuario               := Q.FieldByName('cod_usuario').AsInteger;
      FIntUsuario.NomUsuario               := Q.FieldByName('nom_usuario').AsString;
      FIntUsuario.NomTratamento            := Q.FieldByName('nom_tratamento').AsString;
      FIntUsuario.CodPessoa                := Q.FieldByName('cod_pessoa').AsInteger;
      FIntUsuario.NomPessoa                := Q.FieldByName('nom_pessoa').AsString;
      FIntUsuario.CodNaturezaPessoa        := Q.FieldByName('cod_natureza_pessoa').AsString;
      FIntUsuario.NumCNPJCPF               := Q.FieldByName('num_cnpj_cpf').AsString;
      FIntUsuario.CodPapel                 := Q.FieldByName('cod_papel').AsInteger;
      FIntUsuario.DesPapel                 := Q.FieldByName('des_papel').AsString;
      FIntUsuario.CodPerfil                := Q.FieldByName('cod_perfil').AsInteger;
      FIntUsuario.DesPerfil                := Q.FieldByName('nom_perfil').AsString;
      FIntUsuario.QtdAcumLoginsCorretos    := Q.FieldByName('qtd_acum_logins_corretos').AsInteger;
      FIntUsuario.QtdAcumLoginsIncorretos  := Q.FieldByName('qtd_acum_logins_incorretos').AsInteger;
      FIntUsuario.DtaUltimoLoginCorreto    := Q.FieldByName('dta_ultimo_login_correto').AsDateTime;
      FIntUsuario.DtaUltimoLoginIncorreto  := Q.FieldByName('dta_ultimo_login_incorreto').AsDateTime;
      FIntUsuario.QtdLoginsIncorretos      := Q.FieldByName('qtd_logins_incorretos').AsInteger;
      FIntUsuario.DtaCriacaoUsuario        := Q.FieldByName('dta_criacao_usuario').AsDateTime;
      FIntUsuario.NumCNPJCPFFormatado      := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      FIntUsuario.DtaPenultimoLoginCorreto := Q.FieldByName('dta_ultimo_login_correto').AsDateTime;
      FIntUsuario.DtaFimValidade           := Q.FieldByName('dta_fim_validade').AsDateTime;
      FIntUsuario.NomUsuarioReduzido       := Q.FieldByName('nom_reduzido_pessoa').AsString;      
      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(220, Self.ClassName, 'Buscar', [E.Message]);
        Result := -220;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{
function TIntUsuarios.VerificaLetraNumero(Str: String): Integer;
var
  ExisteLetra, ExisteNumero : Boolean;
  X : Integer;
begin
  Str := UpperCase(Str);
  ExisteLetra := False;
  ExisteNumero := False;

  X := 1;

  While (X <= Length(Str)) and (not ExisteLetra) and (not ExisteNumero) do begin
    if (Ord(Str[X]) >= 65) or (Ord(Str[X]) <= 90) then begin
      ExisteLetra := True;
    end;
    if (Ord(Str[X]) >= 48) or (Ord(Str[X]) <= 57) then begin
      ExisteNumero := True;
    end;
    Inc(X);
  end;

  if (not ExisteLetra) or (not ExisteNumero) then begin
    Mensagens.Adicionar(1068, Self.ClassName, 'VerificaLetraNumero', []);
    Result := -1068;
    Exit;
  end;

  Result := 0;
end;
}

end.

