// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Vers�o             : 1
// *  Data               : 06/01/2003
// *  Documenta��o       : Atributo de animais
// *  C�digo Classe      :
// *  Descri��o Resumida : Cadastro de tipos de agrupamento de ra�as
// ************************************************************************************************
// *  �ltimas Altera��es
// ************************************************************************************************

unit UIntTiposAgrupamentoRacas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntTipoAgrupamentoRacas, dbtables, sysutils, db;

type
  { TIntTiposAgrupamentoRacas }
  TIntTiposAgrupamentoRacas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntTipoAgrupamentoRacas : TIntTipoAgrupamentoRacas;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodTipoAgrupamentoRacas: Integer): Integer;
    function Inserir(SglTipoAgrupamentoRacas,DesTipoAgrupamentoRacas: String): Integer;
    function Alterar(CodTipoAgrupamentoRacas: Integer;
      SglTipoAgrupamentoRacas, DesTipoAgrupamentoRacas: String): Integer;
    function Excluir(CodTipoAgrupamentoRacas: Integer): Integer;
    function Pesquisar(CodOrdenacao: String): Integer;

    property IntTipoAgrupamentoRacas : TIntTipoAgrupamentoRacas read FIntTipoAgrupamentoRacas write FIntTipoAgrupamentoRacas;
  end;

implementation

{ TIntLote }
constructor TIntTiposAgrupamentoRacas.Create;
begin
  inherited;
  FIntTipoAgrupamentoRacas := TIntTipoAgrupamentoRacas.Create;
end;

destructor TIntTiposAgrupamentoRacas.Destroy;
begin
  FIntTipoAgrupamentoRacas.Free;
  inherited;
end;

function TIntTiposAgrupamentoRacas.Buscar(CodTipoAgrupamentoRacas: Integer): Integer;
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

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(391) Then Begin
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
      Q.SQL.Add('select cod_tipo_agrup_racas as CodTipoAgrupamentoRacas, ');
      Q.SQL.Add('       sgl_tipo_agrup_racas as SglTipoAgrupamentoRacas, ');
      Q.SQL.Add('       des_tipo_agrup_racas as DesTipoAgrupamentoRacas ');
      Q.SQL.Add(' from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas = :CodTipoAgrupamentoRacas ');
{$ENDIF}
      Q.ParamByName('CodTipoAgrupamentoRacas').AsInteger         := CodTipoAgrupamentoRacas;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1247, Self.ClassName, NomMetodo, []);
        Result := -1247;
        Exit;
      End;

      // Obtem informa��es do registro
      IntTipoAgrupamentoRacas.CodTipoAgrupamentoRacas   := Q.FieldByName('CodTipoAgrupamentoRacas').AsInteger;
      IntTipoAgrupamentoRacas.SglTipoAgrupamentoRacas   := Q.FieldByName('SglTipoAgrupamentoRacas').AsString;
      IntTipoAgrupamentoRacas.DesTipoAgrupamentoRacas   := Q.FieldByName('DesTipoAgrupamentoRacas').AsString;

      // Retorna status "ok" do m�todo
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1248, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1248;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAgrupamentoRacas.Inserir(SglTipoAgrupamentoRacas,DesTipoAgrupamentoRacas: String): Integer;
const
  NomMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  CodTipoAgrupamentoRacas : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(392) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  // Trata sigla do tipo de agrupamento de ra�a
  Result := VerificaString(SglTipoAgrupamentoRacas, 'Sigla do tipo de agrupamento de ra�a');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoAgrupamentoRacas, 10, 'Sigla do tipo de agrupamento de ra�a');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descri��o do tipo de agrupamento de ra�a
  Result := VerificaString(DesTipoAgrupamentoRacas, 'Descri��o do tipo de agrupamento de ra�a');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesTipoAgrupamentoRacas, 30, 'Descri��o do tipo de agrupamento de ra�a');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where sgl_tipo_agrup_racas = :sgl_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_tipo_agrup_racas').AsString := SglTipoAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1249, Self.ClassName, NomMetodo, [SglTipoAgrupamentoRacas]);
        Result := -1249;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade da descri��o
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where des_tipo_agrup_racas = :des_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_tipo_agrup_racas').AsString := DesTipoAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1250, Self.ClassName, NomMetodo, [DesTipoAgrupamentoRacas]);
        Result := -1250;
        Exit;
      End;
      Q.Close;

      // Abre transa��o
      BeginTran;

      // Pega pr�ximo c�digo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_tipo_agrup_racas), 0) + 1 as cod_tipo_agrup_racas ');
      Q.SQL.Add('  from tab_tipo_agrup_racas ');
{$ENDIF}
      Q.Open;
      CodTipoAgrupamentoRacas := Q.FieldByName('cod_tipo_agrup_racas').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_tipo_agrup_racas ');
      Q.SQL.Add(' (cod_tipo_agrup_racas, ');
      Q.SQL.Add('  sgl_tipo_agrup_racas, ');
      Q.SQL.Add('  des_tipo_agrup_racas, ');
      Q.SQL.Add('  dta_fim_validade)');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_tipo_agrup_racas, ');
      Q.SQL.Add('  :sgl_tipo_agrup_racas, ');
      Q.SQL.Add('  :des_tipo_agrup_racas, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.ParamByName('sgl_tipo_agrup_racas').AsString := SglTipoAgrupamentoRacas;
      Q.ParamByName('des_tipo_agrup_racas').AsString := DesTipoAgrupamentoRacas;
      Q.ExecSQL;

      // Cofirma transa��o
      Commit;

      // Retorna c�digo do registro inserido
      Result := CodTipoAgrupamentoRacas;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1251, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1251;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAgrupamentoRacas.Alterar(CodTipoAgrupamentoRacas: Integer;
  SglTipoAgrupamentoRacas, DesTipoAgrupamentoRacas: String): Integer;
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

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(393) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-------------------------------------------
  // Trata sigla do tipo de agrupamento de ra�a
  //-------------------------------------------
  Result := VerificaString(SglTipoAgrupamentoRacas, 'Sigla do tipo de agrupamento da ra�a');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoAgrupamentoRacas, 10, 'Sigla do tipo de agrupamento da ra�a');
  If Result < 0 Then Begin
    Exit;
  End;
  //-----------------------------------------------
  // Trata descri��o do tipo de agrupamento de ra�a
  //-----------------------------------------------
  Result := VerificaString(DesTipoAgrupamentoRacas, 'Descri��o do tipo de agrupamento da ra�a');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesTipoAgrupamentoRacas, 30, 'Descri��o do tipo de agrupamento da ra�a');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica exist�ncia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1247, Self.ClassName, 'Alterar', []);
        Result := -1247;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas != :cod_tipo_agrup_racas ');
      Q.SQL.Add('   and sgl_tipo_agrup_racas  = :sgl_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.ParamByName('sgl_tipo_agrup_racas').AsString := SglTipoAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1249, Self.ClassName, NomMetodo, [SglTipoAgrupamentoRacas]);
        Result := -1249;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descri��o
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas != :cod_tipo_agrup_racas ');
      Q.SQL.Add('   and des_tipo_agrup_racas  = :des_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.ParamByName('des_tipo_agrup_racas').AsString := DesTipoAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1250, Self.ClassName, NomMetodo, [DesTipoAgrupamentoRacas]);
        Result := -1250;
        Exit;
      End;
      Q.Close;

      // Abre transa��o
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_tipo_agrup_racas ');
      Q.SQL.Add('   set sgl_tipo_agrup_racas = :sgl_tipo_agrup_racas ');
      Q.SQL.Add('     , des_tipo_agrup_racas = :des_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.ParamByName('sgl_tipo_agrup_racas').AsString := SglTipoAgrupamentoRacas;
      Q.ParamByName('des_tipo_agrup_racas').AsString := DesTipoAgrupamentoRacas;
      Q.ExecSQL;

      // Cofirma transa��o
      Commit;

      // Retorna status "ok" do m�todo
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1252, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1252;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAgrupamentoRacas.Excluir(
  CodTipoAgrupamentoRacas: Integer): Integer;
const
  NomMetodo: String = 'Excluir';
var
  Q : THerdomQuery;
  TipoExcl : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(394) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
       //-------------------------------
      // Verifica exist�ncia do registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1247, Self.ClassName, NomMetodo, []);
        Result := -1247;
        Exit;
      End;
      Q.Close;
       //-----------------------------------------------------
      // Verifica relacionamento com algum agrupamento de ra�a
      //------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas ' +
                ' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty
         Then TipoExcl := 1 //o tipo de agrupamento de ra�a ser� apenas considerado inativo para novas inser��es
         Else TipoExcl := 0; //o tipo de agrupamento de ra�a ser� exclu�do
      Q.Close;

      // Abre transa��o
      BeginTran;

      if TipoExcl = 1 then begin
         // Tenta Alterar Registro
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('update tab_tipo_agrup_racas ');
         Q.SQL.Add('   set dta_fim_validade = getdate() ');
         Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
{$ENDIF}
         Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
         Q.ExecSQL;

         // Cofirma transa��o
         Commit;
      end else begin
         // Tenta Excluir Registro
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('delete from tab_tipo_agrup_racas ');
         Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
{$ENDIF}
         Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
         Q.ExecSQL;

         // Cofirma transa��o
         Commit;
      end;
      // Retorna status "ok" do m�todo
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1253, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1253;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposAgrupamentoRacas.Pesquisar(CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(395) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_agrup_racas as CodTipoAgrupamentoRacas, ');
  Query.SQL.Add('       sgl_tipo_agrup_racas as SglTipoAgrupamentoRacas, ');
  Query.SQL.Add('       des_tipo_agrup_racas as DesTipoAgrupamentoRacas ');
  Query.SQL.Add('  from tab_tipo_agrup_racas ');
  Query.SQL.Add('  where dta_fim_validade is null ');
  If Uppercase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by sgl_tipo_agrup_racas ');
  End;
  If Uppercase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by des_tipo_agrup_racas ');
  End;
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1254, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1254;
      Exit;
    End;
  End;
end;
end.
