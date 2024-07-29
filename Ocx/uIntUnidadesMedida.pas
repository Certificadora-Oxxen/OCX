// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Unidade Medida - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    10/09/2002    Criação.
// *
// ********************************************************************
unit uIntUnidadesMedida;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
 uIntUnidadeMedida;

type
  { TIntUnidadesMedida }
  TIntUnidadesMedida = class(TIntClasseBDNavegacaoBasica)
  private
    FIntUnidadeMedida : TIntUnidadeMedida;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodOrdenacao : String) : Integer;
    function Inserir(SglUnidadeMedida,DesUnidadeMedida : String): Integer;
    function Alterar(CodUnidadeMedida: Integer;SglUnidadeMedida,DesUnidadeMedida : String): Integer;
    function Excluir(CodUnidadeMedida: Integer): Integer;
    function Buscar(CodUnidadeMedida: Integer): Integer;

    property IntUnidadeMedida : TIntUnidadeMedida read FIntUnidadeMedida write FIntUnidadeMedida;
  end;

implementation

constructor TIntUnidadesMedida.Create;
begin
  inherited;
  FIntUnidadeMedida:= TIntUnidadeMedida.Create;
end;

destructor TIntUnidadesMedida.Destroy;
begin
  FIntUnidadeMedida.Free;
  inherited;
end;

{ TIntUnidadesMedida }
function TIntUnidadesMedida.Pesquisar(CodOrdenacao : String): Integer;
Const
  NomeMetodo : String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(255) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_unidade_medida as CodUnidadeMedida ' +
  '     , sgl_unidade_medida as SglUnidadeMedida ' +
  '     , des_unidade_medida as DesUnidadeMedida ' +
  '  from tab_unidade_medida ');
  if UpperCase(CodOrdenacao)= 'C' then begin
    Query.SQL.Add(' order by cod_unidade_medida ');
  end
  else If UpperCase(CodOrdenacao)= 'S' then begin
    Query.SQL.Add(' order by sgl_unidade_medida ');
  end
  else If UpperCase(CodOrdenacao)= 'D' then begin
    Query.SQL.Add(' order by des_unidade_medida ');
  end;
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(784, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -784;
      Exit;
    End;
  End;
end;

function TIntUnidadesMedida.Inserir(SglUnidadeMedida,DesUnidadeMedida : String): Integer;
var
  Q : THerdomQuery;
  CodUnidadeMedida : Integer;
Const
  NomeMetodo : String = 'Inserir';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(257) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //--------------
  //Válida a Sigla
  //--------------
  Result := VerificaString(SglUnidadeMedida,'Sigla da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglUnidadeMedida,10,'Sigla da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------
  //Válida a Descrição
  //-------------------
  Result := VerificaString(DesUnidadeMedida,'Descrião da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesUnidadeMedida,15,'Descrião da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;
  
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------------
      // Verifica duplicidade da Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where des_unidade_medida = :des_unidade_medida ');
{$ENDIF}
      Q.ParamByName('des_unidade_medida').AsString := DesUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(785, Self.ClassName, NomeMetodo, [DesUnidadeMedida]);
        Result := -785;
        Exit;
      End;
      Q.Close;
      //------------------------------
      // Verifica duplicidade da Sigla
      //------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where sgl_unidade_medida = :sgl_unidade_medida ');
{$ENDIF}
      Q.ParamByName('sgl_unidade_medida').AsString := SglUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(786, Self.ClassName, NomeMetodo, [SglUnidadeMedida]);
        Result := -786;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_unidade_medida), 0) + 1 as cod_unidade_medida from tab_unidade_medida');
{$ENDIF}
      Q.Open;
      CodUnidadeMedida := Q.FieldByName('cod_unidade_medida').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_unidade_medida ' + 
      ' (cod_unidade_medida, ' + 
      '  sgl_unidade_medida, ' +
      '  des_unidade_medida) ' +
      'values ' + 
      ' (:cod_unidade_medida, ' + 
      '  :sgl_unidade_medida, ' + 
      '  :des_unidade_medida) ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger        := CodUnidadeMedida;
      Q.ParamByName('sgl_unidade_medida').AsString         := SglUnidadeMedida;
      Q.ParamByName('des_unidade_medida').AsString         := DesUnidadeMedida;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodUnidadeMedida;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(787, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -787;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntUnidadesMedida.Alterar(CodUnidadeMedida: Integer;SglUnidadeMedida,DesUnidadeMedida : String): Integer;
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
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(258) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //-------------------
  //Válida a Descrição
  //-------------------
  Result := VerificaString(DesUnidadeMedida,'Descrião da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesUnidadeMedida,15,'Descrião da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------
  //Válida a Sigla
  //--------------
  Result := VerificaString(SglUnidadeMedida,'Sigla da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglUnidadeMedida,10,'Sigla da Unidade de Medida');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------------
      // Verifica a existência da Undiade
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(788, Self.ClassName, NomeMetodo, [IntToStr(CodUnidadeMedida)]);
        Result := -788;
        Exit;
      End;
      Q.Close;

      //----------------------------------
      // Verifica duplicidade da Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where des_unidade_medida = :des_unidade_medida ');
      Q.SQL.Add('   and cod_unidade_medida != :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('des_unidade_medida').AsString := DesUnidadeMedida;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(785, Self.ClassName, NomeMetodo, [DesUnidadeMedida]);
        Result := -785;
        Exit;
      End;
      Q.Close;
      //------------------------------
      // Verifica duplicidade da Sigla
      //------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where sgl_unidade_medida = :sgl_unidade_medida ');
      Q.SQL.Add('   and cod_unidade_medida != :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('sgl_unidade_medida').AsString := SglUnidadeMedida;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(786, Self.ClassName, NomeMetodo, [SglUnidadeMedida]);
        Result := -786;
        Exit;
      End;
      Q.Close;
      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_unidade_medida ');
      Q.SQL.Add('   set des_unidade_medida = :des_unidade_medida');
      Q.SQL.Add('     , sgl_unidade_medida= :sgl_unidade_medida');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger         := CodUnidadeMedida;
      Q.ParamByName('sgl_unidade_medida').AsString          := SglUnidadeMedida;
      Q.ParamByName('des_unidade_medida').AsString          := DesUnidadeMedida;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(791, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -791;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntUnidadesMedida.Excluir(CodUnidadeMedida: Integer): Integer;
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
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(259) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //----------------------------------
      // Verifica a existência da Undiade
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(788, Self.ClassName, NomeMetodo, [IntToStr(CodUnidadeMedida)]);
        Result := -788;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica a existência de Entrada de Insumos
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(793, Self.ClassName, NomeMetodo, []);
        Result := -793;
        Exit;
      End;

      //------------------------------------------
      // Verifica a existência de Entrada de Insumos
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_entrada_insumo ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(792, Self.ClassName, NomeMetodo, []);
        Result := -792;
        Exit;
      End;
      // Abre transação
      BeginTran;


      //-----------------------
      // Tenta Excluir Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete tab_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(794, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -794;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntUnidadesMedida.Buscar(CodUnidadeMedida: Integer): Integer;
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
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(256) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------
      // Tenta Buscar Registro
      //-----------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select cod_unidade_medida ' +
      '     , sgl_unidade_medida ' +
      '     , des_unidade_medida ' +
      '  from tab_unidade_medida ' +
      ' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(788, Self.ClassName, NomeMetodo, []);
        Result := -788;
        Exit;
      End;

      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      FIntUnidadeMedida.CodUnidadeMedida  := Q.FieldByName('Cod_unidade_medida').AsInteger;
      FIntUnidadeMedida.SglUnidadeMedida  := Q.FieldByName('sgl_unidade_medida').AsString;
      FIntUnidadeMedida.DesUnidadeMedida  := Q.FieldByName('des_unidade_medida').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(795, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -795;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
