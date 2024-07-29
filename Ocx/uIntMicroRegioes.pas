// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Micro Regioes - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *   Hítalo    06/08/2002    Adicionar método Inserir,Excluir,Alterar
// *                           Buscar.
// *
// ********************************************************************
unit uIntMicroRegioes;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntMicroRegiao;

type
  { TIntMicroRegioes }
  TIntMicroRegioes = class(TIntClasseBDNavegacaoBasica)
  private
    FIntMicroRegiao : TIntMicroRegiao;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Pesquisar(NomMicroRegiao : String;CodEstado : Integer;CodOrdenacao : String; CodMicroRegiaoSisbov: Integer) : Integer;
    function Inserir(NomMicroRegiao : String;CodMicroRegiaoSisBov,CodEstado : Integer): Integer;
    function Alterar(CodMicroRegiao : Integer;NomMicroRegiao : String;CodMicroRegiaoSisBov : Integer): Integer;
    function Excluir(CodMicroRegiao: Integer): Integer;
    function Buscar(CodMicroRegiao: Integer): Integer;

    property IntMicroRegiao : TIntMicroRegiao read FIntMicroRegiao write FIntMicroRegiao;
  end;

implementation

constructor TIntMicroRegioes.Create;
begin
  inherited;
  FIntMicroRegiao := TIntMicroRegiao.Create;
end;

destructor TIntMicroRegioes.Destroy;
begin
  FIntMicroRegiao.Free;
  inherited;
end;

{ TIntMicroRegioes }
function TIntMicroRegioes.Pesquisar(NomMicroRegiao : String;CodEstado : Integer;CodOrdenacao : String; CodMicroRegiaoSisbov: Integer) : Integer;
Const
  CodMetodo : Integer = 84;
  NomMetodo : String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select r.cod_micro_regiao as CodMicroRegiao ');
  Query.SQL.Add('     , r.Nom_micro_regiao as NomMicroRegiao ');
  Query.SQL.Add('     , e.Cod_Estado   as CodEstado ');
  Query.SQL.Add('     , e.sgl_Estado   as SglEstado ');
  Query.SQL.Add('     , r.Cod_Micro_Regiao_SisBov as CodMicroRegiaoSisBov ');
  Query.SQL.Add('     , e.Cod_estado_SisBov as CodEstadoSisBov ');
  Query.SQL.Add('  from tab_micro_regiao r ');
  Query.SQL.Add('     , tab_estado e ');
  Query.SQL.Add(' where e.Cod_Estado = r.Cod_Estado ');
  Query.SQL.Add('   and r.dta_fim_validade is null ');
  Query.SQL.Add('   and ((e.Cod_Estado = :Cod_Estado) or (:Cod_Estado = -1)) ');

  if trim(NomMicroRegiao) <> '' then begin
    Query.SQL.Add('   and r.Nom_micro_regiao like :Nom_micro_regiao');
  end;

  if CodMicroRegiaoSisbov >= 0 then begin
    Query.SQL.Add('   and r.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
  end;

  if UpperCase(CodOrdenacao)='N' then begin
    Query.SQL.Add(' order by e.Sgl_estado,r.Nom_micro_regiao');
  end
  else if UpperCase(CodOrdenacao)='B' then begin
    Query.SQL.Add(' order by e.cod_estado_sisBov,r.cod_micro_regiao_sisbov');
  end
  else if UpperCase(CodOrdenacao)='M' then begin
    Query.SQL.Add(' order by r.Nom_micro_regiao,e.Sgl_estado');
  end;

  Query.ParamByName('Cod_Estado').AsInteger := codEstado;

  if trim(NomMicroRegiao) <> '' then begin
    Query.ParamByName('Nom_micro_regiao').AsString := '%' + NomMicroRegiao + '%';
  end;

  if CodMicroRegiaoSisbov >= 0 then begin
   Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
  end;

{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(461, Self.ClassName, NomMetodo, [E.Message]);
      Result := -461;
      Exit;
    End;
  End;
end;

function TIntMicroRegioes.Inserir(NomMicroRegiao: String;CodMicroRegiaoSisBov,CodEstado : Integer): Integer;
var
  Q : THerdomQuery;
  CodMicroRegiao : Integer;
Const
  CodMetodo : Integer = 152;
  NomMetodo : String = 'Inserir';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //------------------------------
  //Válida o Nome do micro regiao
  //------------------------------
  Result := VerificaString(NomMicroRegiao,'Nome da Micro Região');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomMicroRegiao,40,'Nome da Micro Região');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------------------------
  // Verifica se o Código do SisBov <= 0
  //-------------------------------------
  If CodMicroRegiaoSisBov <= 0 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisBov)]);
    Result := -296;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-------------------------------------------
      // Verifica duplicidade do Nome Micro Regiao
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao ');
      Q.SQL.Add(' where nom_micro_regiao = :nom_micro_regiao ');
      Q.SQL.Add('   and cod_estado  = :cod_estado ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_micro_regiao').AsString := NomMicroRegiao;
      Q.ParamByName('cod_estado').AsInteger      := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(465, Self.ClassName, NomMetodo, [NomMicroRegiao]);
        Result := -465;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------
      // Verifica duplicidade do Código Micro Regiao SisBov
      //----------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_estado  = :cod_estado ');
{ Fábio - 22/07/2004 - Não é permitido inserir uma micro com o mesmo codigo   }
{                      SISBOV e estado mesmo que esta seja inválida           }
{      Q.SQL.Add('   and dta_fim_validade is null ');                         }
{$ENDIF}
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_estado').AsInteger      := CodEstado;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(466, Self.ClassName,NomMetodo, [IntToStr(CodMicroRegiaoSisbov)]);
        Result := -466;
        Exit;
      End;
      Q.Close;

      //--------------------------------------------
      // Verifica a existência do Registro no Estado
      //--------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ');
      Q.SQL.Add(' where cod_estado = :cod_estado ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(387, Self.ClassName, NomMetodo, [IntToStr(CodEstado)]);
        Result := -387;
        Exit;
      End;

      //Abre transação
      BeginTran;

      //---------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_micro_regiao), 0) + 1 as cod_micro_regiao from tab_micro_regiao');
{$ENDIF}
      Q.Open;
      CodMicroRegiao := Q.FieldByName('cod_micro_regiao').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_micro_regiao ');
      Q.SQL.Add(' (cod_micro_regiao, ');
      Q.SQL.Add('  nom_micro_regiao, ');
      Q.SQL.Add('  cod_micro_regiao_sisbov, ');
      Q.SQL.Add('  cod_estado, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_micro_regiao, ');
      Q.SQL.Add('  :nom_micro_regiao, ');
      Q.SQL.Add('  :cod_micro_regiao_sisbov, ');
      Q.SQL.Add('  :cod_estado, ');
      Q.SQL.Add('  null ) ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger         := CodMicroRegiao;
      Q.ParamByName('nom_micro_regiao').AsString          := NomMicroRegiao;
      Q.ParamByName('cod_estado').AsInteger               := CodEstado;

      if CodMicroRegiaoSisBov < -1  then begin
        Q.ParamByName('cod_micro_regiao_sisBov').DataType  := ftInteger;
        Q.ParamByName('cod_micro_regiao_sisBov').clear;
      end else begin
        Q.ParamByName('cod_micro_regiao_sisBov').AsInteger  := CodMicroRegiaoSisBov;
      end;

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodMicroRegiao;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(462, Self.ClassName, NomMetodo, [E.Message]);
        Result := -462;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntMicroRegioes.Alterar(CodMicroRegiao : Integer;NomMicroRegiao : String;CodMicroRegiaoSisBov : Integer): Integer;
var
  Q : THerdomQuery;
  CodMicroRegiaoSisBovCor,CodEstado : Integer;
Const
  CodMetodo : Integer = 153;
  NomMetodo : String = 'Alterar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------------------------
  //Válida o Nome do micro_regiao
  //-----------------------------
  Result := VerificaString(NomMicroRegiao,'Nome da Micro Região');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomMicroRegiao,40,'Nome da Micro Região');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------------------------
  // Verifica se o Código do SisBov <> 0
  //-------------------------------------
  If CodMicroRegiaoSisBov < -1 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisBov)]);
    Result := -296;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //----------------------------------
      // Verifica a existência do Registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_micro_regiao_sisBov,cod_estado from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao = :cod_micro_regiao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(467, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiao)]);
        Result := -467;
        Exit;
      End;
      //---------------------------------------------
      // Código micro_regiao SisBov, Estado Corrente
      //---------------------------------------------
      CodMicroRegiaoSisBovCor := Q.FieldByName('cod_micro_regiao_sisBov').Asinteger;
      CodEstado               := Q.FieldByName('cod_estado').Asinteger;

      Q.Close;

      //-------------------------------------------
      // Verifica duplicidade do Nome micro_regiao
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao ');
      Q.SQL.Add(' where nom_micro_regiao = :nom_micro_regiao ');
      Q.SQL.Add('   and cod_micro_regiao != :cod_micro_regiao ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_micro_regiao').AsString  := NomMicroRegiao;
      Q.ParamByName('cod_micro_regiao').Asinteger := CodMicroRegiao;
      Q.ParamByName('cod_estado').AsInteger       := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(465, Self.ClassName, NomMetodo, [NomMicroRegiao]);
        Result := -465;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------
      // Verifica duplicidade do Código micro_regiao SisBov
      //----------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add('   and cod_micro_regiao != :cod_micro_regiao ');
      Q.SQL.Add('   and cod_estado = :cod_estado ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
      Q.ParamByName('cod_estado').AsInteger       := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(466, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisBov)]);
        Result := -466;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------
      // Verifica se o Código micro_regiao SisBov não está
      // espetado na tabela tab_animal
      //----------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add(' and cod_estado_sisbov = (select cod_estado_sisbov from tab_estado where cod_estado = :cod_estado) ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbovCor;
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(453, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisBovCor)]);
        Result := -453;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------
      // Verifica se o Código micro_regiao SisBov não está espetado
      // na tabela tab_codigo_sisbov
      //----------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_codigo_sisbov ');
      Q.SQL.Add(' where cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ');
      Q.SQL.Add(' and cod_estado_sisbov = (select cod_estado_sisbov from tab_estado where cod_estado = :cod_estado) ');      
{$ENDIF}
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbovCor;
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(454, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiaoSisBovCor)]);
        Result := -454;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_micro_regiao ');
      Q.SQL.Add('   set Cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov');
      Q.SQL.Add('     , Nom_micro_regiao = :Nom_micro_regiao');
      Q.SQL.Add(' where cod_micro_regiao = :cod_micro_regiao');
{$ENDIF}
      Q.ParamByName('Nom_micro_regiao').AsString         := NomMicroRegiao;
      if CodMicroRegiaoSisBov < -1  then begin
        Q.ParamByName('cod_micro_regiao_sisbov').DataType  := ftInteger;
        Q.ParamByName('cod_micro_regiao_sisbov').clear;
      end else begin
        Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisBov;
      end;
      Q.ParamByName('cod_micro_regiao').AsInteger         := CodMicroRegiao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(463, Self.ClassName, NomMetodo, [E.Message]);
        Result := -463;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntMicroRegioes.Excluir(CodMicroRegiao : Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 154;
  NomMetodo : String = 'Excluir';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------------
      // Verifica a existência do Registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao ');
      Q.SQL.Add(' where cod_micro_regiao = :cod_micro_regiao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(467, Self.ClassName, NomMetodo, [IntToStr(CodMicroRegiao)]);
        Result := -467;
        Exit;
      End;
      //------------------------
      // Tenta Alterar Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_micro_regiao ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_micro_regiao = :cod_micro_regiao ');
{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(472, Self.ClassName, NomMetodo, [E.Message]);
        Result := -472;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntMicroRegioes.Buscar(CodMicroRegiao: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 155;
  NomMetodo : String = 'Buscar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------
      // Tenta Buscar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select p.cod_pais ');
      Q.SQL.Add('     , p.nom_pais ');
      Q.SQL.Add('     , p.cod_pais_sisbov');
      Q.SQL.Add('     , e.cod_estado ');
      Q.SQL.Add('     , e.sgl_estado ');
      Q.SQL.Add('     , e.cod_estado_sisbov');
      Q.SQL.Add('     , r.cod_micro_regiao ');
      Q.SQL.Add('     , r.nom_micro_regiao ');
      Q.SQL.Add('     , r.cod_micro_regiao_sisbov ');
      Q.SQL.Add('  from tab_estado e ');
      Q.SQL.Add('     , tab_pais p ');
      Q.SQL.Add('     , tab_micro_regiao r ');
      Q.SQL.Add(' where r.cod_micro_regiao = :cod_micro_regiao ');
      Q.SQL.Add('   and e.cod_estado = r.cod_estado ');
      Q.SQL.Add('   and p.cod_pais = e.cod_pais ');
      Q.SQL.Add('   and r.dta_fim_validade is null ');

{$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.Open;

      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(467, Self.ClassName, NomMetodo, []);
        Result := -467;
        Exit;
      End;

      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      FIntMicroRegiao.CodPais               := Q.FieldByName('cod_pais').AsInteger;
      FIntMicroRegiao.NomPais               := Q.FieldByName('nom_pais').AsString;
      FIntMicroRegiao.CodPaisSisBov         := Q.FieldByName('cod_pais_sisBov').AsInteger;
      FIntMicroRegiao.CodEstado             := Q.FieldByName('Cod_estado').AsInteger;
      FIntMicroRegiao.SglEstado             := Q.FieldByName('sgl_estado').AsString;
      FIntMicroRegiao.CodEstadoSisBov       := Q.FieldByName('cod_estado_sisBov').AsInteger;
      FIntMicroRegiao.CodMicroRegiao        := Q.FieldByName('Cod_micro_regiao').AsInteger;
      FIntMicroRegiao.NomMicroRegiao        := Q.FieldByName('nom_micro_regiao').AsString;
      FIntMicroRegiao.CodMicroRegiaoSisBov  := Q.FieldByName('cod_micro_regiao_sisBov').AsInteger;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(464, Self.ClassName, NomMetodo, [E.Message]);
        Result := -464;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
