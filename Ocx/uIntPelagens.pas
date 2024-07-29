// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Pelagem de Animal - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *
// *
// ********************************************************************
unit uIntPelagens;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntPelagem;

type
  { TIntPelagens }
  TIntPelagens = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPelagem : TIntPelagem;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodOrdenacao, IndRestritoSistema: String) : Integer;
    function Inserir(SglPelagem, DesPelagem: String): Integer;
    function Buscar(CodPelagem: Integer): Integer;
    function Alterar(CodPelagem: Integer; SglPelagem, DesPelagem : String): Integer;
    function Excluir(CodPelagem: Integer): Integer;
    property IntPelagem : TIntPelagem read FIntPelagem write FIntPelagem;
  end;

implementation

{ TIntPelagens }

constructor TIntPelagens.Create;
begin
  inherited;
  FIntPelagem := TIntPelagem.Create;
end;

destructor TIntPelagens.Destroy;
begin
  FIntPelagem.Free;
  inherited;
end;

function TIntPelagens.Pesquisar(CodOrdenacao, IndRestritoSistema: String) : Integer;
Const
  NomeMetodo : String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(86) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_pelagem as CodPelagem ');
  Query.SQL.Add('     , sgl_pelagem as SglPelagem ');
  Query.SQL.Add('     , des_pelagem as DesPelagem ');
  Query.SQL.Add('     , ind_restrito_sistema as IndRestritoSistema ');
  Query.SQL.Add('  from tab_pelagem ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if IndRestritoSistema <> '' then
  begin
    Query.SQL.Add(' and ind_restrito_sistema = :ind_restrito_sistema');
  end;

  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_Pelagem ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_Pelagem ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_Pelagem ');
{$ENDIF}

  Try
    if IndRestritoSistema <> '' then
    begin
      Query.ParamByName('ind_restrito_sistema').AsString := IndRestritoSistema;
    end;

    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(306, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -306;
      Exit;
    End;
  End;
end;

function TIntPelagens.Inserir(SglPelagem, DesPelagem : String): Integer;
var
  Q : THerdomQuery;
  CodPelagem : Integer;
Const
  NomeMetodo : String = 'Inserir';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(129) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //------------------------
  //Valida Sigla de Pelagem
  //------------------------
  Result := VerificaString(SglPelagem,'Sigla de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------
  //Valida Sigla de Pelagem
  //------------------------
  Result := TrataString(SglPelagem,4, 'Sigla de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Pelagem
  //-------------------------
  Result := VerificaString(DesPelagem, 'Descrição de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Pelagem
  //-------------------------
  Result := TrataString(DesPelagem, 30, 'Descrição de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_Pelagem ');
      Q.SQL.Add(' where sgl_Pelagem = :sglPelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sglPelagem').AsString := SglPelagem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(394, Self.ClassName, NomeMetodo, [SglPelagem]);
        Result := -394;
        Exit;
      End;
      Q.Close;

      //----------------------------------
      // Verifica duplicidade de Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_Pelagem ');
      Q.SQL.Add(' where des_Pelagem = :desPelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('desPelagem').AsString := DesPelagem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(393, Self.ClassName, NomeMetodo, [DesPelagem]);
        Result := -393;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_Pelagem), 0) + 1 as cod_Pelagem from tab_Pelagem');
{$ENDIF}
      Q.Open;
      CodPelagem := Q.FieldByName('cod_Pelagem').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_Pelagem ');
      Q.SQL.Add(' (cod_Pelagem, ');
      Q.SQL.Add('  sgl_Pelagem, ');
      Q.SQL.Add('  Des_Pelagem, ');
      Q.SQL.Add('  ind_restrito_sistema, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_Pelagem, ');
      Q.SQL.Add('  :sgl_Pelagem, ');
      Q.SQL.Add('  :Des_Pelagem, ');
      Q.SQL.Add('  ''N'', ');
      Q.SQL.Add('  null ) ');
{$ENDIF}
      Q.ParamByName('cod_Pelagem').AsInteger      := CodPelagem;
      Q.ParamByName('sgl_Pelagem').AsString       := SglPelagem;
      Q.ParamByName('Des_Pelagem').AsString       := DesPelagem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodPelagem;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(391, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -391;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPelagens.Alterar(CodPelagem: Integer; SglPelagem, DesPelagem : String): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'Alterar';
begin

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(131) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //------------------------
  //Valida Sigla de Pelagem
  //------------------------
  Result := VerificaString(SglPelagem,'Sigla de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------
  //Valida Sigla de Pelagem
  //------------------------
  Result := TrataString(SglPelagem,4, 'Sigla de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Pelagem
  //-------------------------
  Result := VerificaString(DesPelagem, 'Descrição de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Pelagem
  //-------------------------
  Result := TrataString(DesPelagem, 30, 'Descrição de Pelagem');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-------------------------------------------
      // Verifica existência do registro
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_restrito_sistema from tab_Pelagem ');
      Q.SQL.Add(' where cod_Pelagem = :cod_Pelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(392, Self.ClassName, NomeMetodo, []);
        Result := -392;
        Exit;
      End;

      If Q.FieldByName('ind_restrito_sistema').AsString = 'S' then Begin
        Mensagens.Adicionar(2074, Self.ClassName, NomeMetodo, []);
        Result := -2074;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_Pelagem ');
      Q.SQL.Add(' where sgl_Pelagem  = :sgl_Pelagem ');
      Q.SQL.Add('   and cod_Pelagem != :cod_Pelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_Pelagem').AsString  := SglPelagem;
      Q.ParamByName('cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(394, Self.ClassName, NomeMetodo, [SglPelagem]);
        Result := -394;
        Exit;
      End;
      Q.Close;

      //----------------------------------
      // Verifica duplicidade de Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_Pelagem ');
      Q.SQL.Add(' where des_Pelagem = :des_Pelagem ');
      Q.SQL.Add('   and cod_Pelagem != :cod_Pelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_Pelagem').AsString  := DesPelagem;
      Q.ParamByName('cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(393, Self.ClassName, NomeMetodo, [DesPelagem]);
        Result := -393;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_Pelagem ');
      Q.SQL.Add('   set Sgl_Pelagem = :Sql_Pelagem');
      Q.SQL.Add('     , des_Pelagem = :Des_Pelagem');
      Q.SQL.Add(' where cod_Pelagem = :Cod_Pelagem ');
{$ENDIF}
      Q.ParamByName('Sql_Pelagem').AsString           := SglPelagem;
      Q.ParamByName('Des_Pelagem').AsString           := DesPelagem;
      Q.ParamByName('cod_Pelagem').AsInteger          := CodPelagem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(390, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -390;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPelagens.Excluir(CodPelagem: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'Excluir';  
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(130) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //--------------------------------
      // Verifica existência do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_restrito_sistema from tab_pelagem ');
      Q.SQL.Add(' where cod_Pelagem = :cod_Pelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');

{$ENDIF}
      Q.ParamByName('cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(392, Self.ClassName, NomeMetodo, [IntToStr(CodPelagem)]);
        Result := -392;
        Exit;
      End;

      If Q.FieldByName('ind_restrito_sistema').AsString = 'S' then Begin
        Mensagens.Adicionar(2074, Self.ClassName, NomeMetodo, []);
        Result := -2074;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica relacionamento com algum animal
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ');
      Q.SQL.Add(' where cod_Pelagem = :cod_Pelagem ');
{$ENDIF}
      Q.ParamByName('cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1035, Self.ClassName, NomeMetodo, [IntToStr(CodPelagem)]);
        Result := -1035;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete tab_Pelagem ');
      Q.SQL.Add(' where cod_Pelagem = :Cod_Pelagem ');
{$ENDIF}
      Q.ParamByName('Cod_Pelagem').AsInteger      := CodPelagem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(389, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -389;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPelagens.Buscar(CodPelagem: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'Buscar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(128) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_Pelagem ');
      Q.SQL.Add('     , sgl_Pelagem ');
      Q.SQL.Add('     , des_Pelagem ');
      Q.SQL.Add('     , ind_restrito_sistema ');
      Q.SQL.Add('  from tab_Pelagem ');
      Q.SQL.Add(' where cod_Pelagem = :Cod_Pelagem ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('Cod_Pelagem').AsInteger := CodPelagem;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(392, Self.ClassName, NomeMetodo, []);
        Result := -392;
        Exit;
      End;

      // Obtem informações do registro
      FIntPelagem.CodPelagem          := Q.FieldByName('Cod_Pelagem').AsInteger;
      FIntPelagem.SglPelagem          := Q.FieldByName('sgl_Pelagem').AsString;
      FIntPelagem.DesPelagem          := Q.FieldByName('Des_Pelagem').AsString;
      FIntPelagem.IndRestritoSistema  := Q.FieldByName('ind_restrito_sistema').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(388, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -388;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

