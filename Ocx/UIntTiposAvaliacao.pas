// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Luiz Humberto Canival
// *  Versão             : 1
// *  Data               : 27/05/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Tipos de Avaliação
// ************************************************************************************************
// *  Últimas Alterações
// ************************************************************************************************

unit UIntTiposAvaliacao;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntTipoAvaliacao, dbtables, sysutils, db;

type
  { TIntTiposAvaliacao }
  TIntTiposAvaliacao = class(TIntClasseBDNavegacaoBasica)
  private
    FIntTipoAvaliacao : TIntTipoAvaliacao;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodTipoAvaliacao: Integer): Integer;
    function Inserir(SglTipoAvaliacao, DesTipoAvaliacao: String): Integer;
    function Alterar(CodTipoAvaliacao: Integer;
      SglTipoAvaliacao, DesTipoAvaliacao: String): Integer;
    function Excluir(CodTipoAvaliacao: Integer): Integer;
    function Pesquisar(CodOrdenacao: String): Integer;

    property IntTipoAvaliacao : TIntTipoAvaliacao read FIntTipoAvaliacao write FIntTipoAvaliacao;
  end;

implementation

{ TIntLote }
constructor TIntTiposAvaliacao.Create;
begin
  inherited;
  FIntTipoAvaliacao := TIntTipoAvaliacao.Create;
end;

destructor TIntTiposAvaliacao.Destroy;
begin
  FIntTipoAvaliacao.Free;
  inherited;
end;

function TIntTiposAvaliacao.Buscar(CodTipoAvaliacao: Integer): Integer;
const
  NomMetodo: String = 'Buscar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(455) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tipo_avaliacao    as CodTipoAvaliacao, ');
      Q.SQL.Add('       sgl_tipo_avaliacao    as SglTipoAvaliacao, ');
      Q.SQL.Add('       des_tipo_avaliacao    as DesTipoAvaliacao ');
      Q.SQL.Add(' from tab_tipo_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :CodTipoAvaliacao ');
{$ENDIF}
      Q.ParamByName('CodTipoAvaliacao').AsInteger  := CodTipoAvaliacao;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1502, Self.ClassName, NomMetodo, []);
        Result := -1502;
        Exit;
      End;

      // Obtem informações do registro
      IntTipoAvaliacao.CodTipoAvaliacao   := Q.FieldByName('CodTipoAvaliacao').AsInteger;
      IntTipoAvaliacao.SglTipoAvaliacao   := Q.FieldByName('SglTipoAvaliacao').AsString;
      IntTipoAvaliacao.DesTipoAvaliacao   := Q.FieldByName('DesTipoAvaliacao').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1503, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1503;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAvaliacao.Inserir(SglTipoAvaliacao, DesTipoAvaliacao: String): Integer;
const
  NomMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  CodTipoAvaliacao : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(451) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  // Trata sigla do tipo de avaliacao
  Result := VerificaString(SglTipoAvaliacao, 'Sigla do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoAvaliacao, 5, 'Sigla do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do tipo de avaliacao
  Result := VerificaString(DesTipoAvaliacao, 'Descrição do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(DesTipoAvaliacao, 30, 'Descrição do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao ');
      Q.SQL.Add(' where sgl_tipo_avaliacao = :sgl_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_tipo_avaliacao').AsString := SglTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1504, Self.ClassName, NomMetodo, [SglTipoAvaliacao]);
        Result := -1504;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade da descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao ');
      Q.SQL.Add(' where des_tipo_avaliacao = :des_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_tipo_avaliacao').AsString := DesTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1505, Self.ClassName, NomMetodo, [DesTipoAvaliacao]);
        Result := -1505;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_tipo_avaliacao), 0) + 1 as cod_tipo_avaliacao ');
      Q.SQL.Add('  from tab_tipo_avaliacao ');
{$ENDIF}
      Q.Open;
      CodTipoAvaliacao := Q.FieldByName('cod_tipo_avaliacao').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_tipo_avaliacao ');
      Q.SQL.Add(' (cod_tipo_avaliacao, ');
      Q.SQL.Add('  sgl_tipo_avaliacao, ');
      Q.SQL.Add('  des_tipo_avaliacao) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_tipo_avaliacao, ');
      Q.SQL.Add('  :sgl_tipo_avaliacao, ');
      Q.SQL.Add('  :des_tipo_avaliacao) ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('sgl_tipo_avaliacao').AsString  := SglTipoAvaliacao;
      Q.ParamByName('des_tipo_avaliacao').AsString  := DesTipoAvaliacao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodTipoAvaliacao;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1506, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1506;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAvaliacao.Alterar(CodTipoAvaliacao: Integer;
  SglTipoAvaliacao, DesTipoAvaliacao: String): Integer;
const
  NomMetodo: String = 'Alterar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(452) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------------------------------
  // Trata sigla do tipo de avaliacao
  //-----------------------------------
  Result := VerificaString(SglTipoAvaliacao, 'Sigla do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoAvaliacao, 5, 'Sigla do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;
  //---------------------------------------
  // Trata descrição do tipo de avaliacao
  //---------------------------------------
  Result := VerificaString(DesTipoAvaliacao, 'Descrição do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(DesTipoAvaliacao, 30, 'Descrição do tipo de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade   is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1502, Self.ClassName, 'Alterar', []);
        Result := -1502;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao  ');
      Q.SQL.Add(' where sgl_tipo_avaliacao = :sgl_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_tipo_avaliacao != :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('sgl_tipo_avaliacao').AsString := SglTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1504, Self.ClassName, NomMetodo, [SglTipoAvaliacao]);
        Result := -1504;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao ');
      Q.SQL.Add(' where des_tipo_avaliacao  = :des_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_tipo_avaliacao != :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');

{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('des_tipo_avaliacao').AsString  := DesTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1505, Self.ClassName, NomMetodo, [DesTipoAvaliacao]);
        Result := -1505;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_tipo_avaliacao ');
      Q.SQL.Add('   set sgl_tipo_avaliacao = :sgl_tipo_avaliacao ');
      Q.SQL.Add('     , des_tipo_avaliacao = :des_tipo_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('sgl_tipo_avaliacao').AsString  := SglTipoAvaliacao;
      Q.ParamByName('des_tipo_avaliacao').AsString  := DesTipoAvaliacao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1507, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1507;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAvaliacao.Excluir(CodTipoAvaliacao: Integer): Integer;
const
  NomMetodo: String = 'Excluir';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(453) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
       //-------------------------------
      // Verifica existência do registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade   is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1502, Self.ClassName, NomMetodo, []);
        Result := -1502;
        Exit;
      End;
      Q.Close;

      // Tenta Excluir as caracteristicas associadas
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade   is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1523, Self.ClassName, NomMetodo, []);
        Result := -1523;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_tipo_avaliacao ');
      Q.SQL.Add(' set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ExecSQL;

      // Confirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1508, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1508;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAvaliacao.Pesquisar(CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(461) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_avaliacao as CodTipoAvaliacao ');
  Query.SQL.Add('     , sgl_tipo_avaliacao as SglTipoAvaliacao ');
  Query.SQL.Add('     , des_tipo_avaliacao as DesTipoAvaliacao ');
  Query.SQL.Add(' from tab_tipo_avaliacao ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'S' then
     Query.SQL.Add(' order by sgl_tipo_avaliacao ')
  else if CodOrdenacao = 'D' then
     Query.SQL.Add(' order by des_tipo_avaliacao ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1509, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1509;
      Exit;
    End;
  End;
end;
end.



