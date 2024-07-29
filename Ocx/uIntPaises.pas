// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 18/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Paises - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    18/07/2002    Criação.
// *   Hítalo    02/08/2002    Adicionar método Inserir,Excluir,Alterar
// *                           Buscar.
// *   Hítalo    09/08/2002    Adicionar método PaisCertificadora.
// *
// ********************************************************************
unit uIntPaises;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntPais;

type
  { TIntPaises }
  TIntPaises = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPais : TIntPais;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodOrdenacao : String) : Integer;
    function Inserir(NomPais : String;CodPaisSisBov : Integer): Integer;
    function Alterar(CodPais: Integer;NomPais: String;CodPaisSisBov : integer): Integer;
    function Excluir(CodPais: Integer): Integer;
    function Buscar(CodPais: Integer): Integer;
    function PaisCertificadora: Integer;

    property IntPais : TIntPais read FIntPais write FIntPais;
  end;

implementation

constructor TIntPaises.Create;
begin
  inherited;
  FIntPais:= TIntPais.Create;
end;

destructor TIntPaises.Destroy;
begin
  FIntPais.Free;
  inherited;
end;

{ TIntPaises }
function TIntPaises.Pesquisar(CodOrdenacao : String): Integer;
Const
  CodMetodo : Integer = 81;
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
  Query.SQL.Add('select Cod_pais as CodPais                  ');
  Query.SQL.Add('     , nom_pais as NomPais                  ');
  Query.SQL.Add('     , Cod_Pais_SisBov as CodPaisSisBov     ');
  Query.SQL.Add('  from tab_pais                             ');
  Query.SQL.Add(' where dta_fim_validade is null             ');
  if UpperCase(CodOrdenacao)= 'N' then begin
    Query.SQL.Add(' order by nom_pais                          ');
  end
  else If UpperCase(CodOrdenacao)= 'B' then begin
    Query.SQL.Add(' order by cod_pais_sisbov                    ');
  end;

{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(295, Self.ClassName, NomMetodo, [E.Message]);
      Result := -295;
      Exit;
    End;
  End;
end;

function TIntPaises.Inserir(NomPais : String;CodPaisSisBov : Integer): Integer;
var
  Q : THerdomQuery;
  CodPais : Integer;
Const
  CodMetodo : Integer = 144;
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

  //---------------------
  //Válida o Nome do País
  //---------------------
  Result := VerificaString(NomPais,'Nome do País');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomPais,20,'Nome do País');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------------------------
  // Verifica se o Código do SisBov <> 0
  //-------------------------------------
  If CodPaisSisBov = 0 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, []);
    Result := -296;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------------
      // Verifica duplicidade do Nome Pais
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pais ');
      Q.SQL.Add(' where nom_pais = :nom_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_pais').AsString := NomPais;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(430, Self.ClassName, NomMetodo, [NomPais]);
        Result := -430;
        Exit;
      End;
      Q.Close;

      if CodPaisSisbov > 0 then begin
        //--------------------------------------------
        // Verifica duplicidade do Código País SisBov
        //--------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pais ');
        Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(431, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisbov)]);
          Result := -431;
          Exit;
        End;
        Q.Close;
      end;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_pais), 0) + 1 as cod_pais from tab_pais');
{$ENDIF}
      Q.Open;
      CodPais := Q.FieldByName('cod_pais').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_pais ');
      Q.SQL.Add(' (cod_pais, ');
      Q.SQL.Add('  nom_pais, ');
      Q.SQL.Add('  cod_pais_sisbov, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pais, ');
      Q.SQL.Add('  :nom_pais, ');
      Q.SQL.Add('  :cod_pais_sisbov, ');
      Q.SQL.Add('  null ) ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger        := CodPais;
      Q.ParamByName('nom_pais').AsString         := NomPais;

      if CodPaisSisBov = -1  then begin
        Q.ParamByName('cod_pais_sisbov').DataType  := ftInteger;
        Q.ParamByName('cod_pais_sisbov').clear;
      end else begin
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisBov;
      end;

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodPais;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(432, Self.ClassName, NomMetodo, [E.Message]);
        Result := -432;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPaises.Alterar(CodPais: Integer;NomPais: String;CodPaisSisBov : integer): Integer;
var
  Q : THerdomQuery;
  CodPaisSisBovCor : Integer;
Const
  CodMetodo : Integer = 145;
  NomMetodo : String = 'Alterar';
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

  //---------------------
  //Válida o Nome do País
  //---------------------
  Result := VerificaString(NomPais,'Nome do País');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomPais,20,'Nome do País');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------------------
  // Verifica se o Código do SisBov <> 0
  //------------------------------------
  If CodPaisSisBov = 0 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, []);
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
      Q.SQL.Add('select cod_pais_sisBov from tab_pais ');
      Q.SQL.Add(' where cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(402, Self.ClassName, NomMetodo, [CodPais]);
        Result := -402;
        Exit;
      End;
      //-----------------------------
      // Código Pais SisBov Corrente
      //-----------------------------
      CodPaisSisBovCor := Q.FieldByName('cod_pais_sisBov').Asinteger;
      Q.Close;

      //----------------------------------
      // Verifica duplicidade do Nome Pais
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pais ');
      Q.SQL.Add(' where nom_pais = :nom_pais ');
      Q.SQL.Add('   and cod_pais != :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_pais').AsString := NomPais;
      Q.ParamByName('cod_pais').Asinteger := CodPais;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(430, Self.ClassName, NomMetodo, [NomPais]);
        Result := -430;
        Exit;
      End;
      Q.Close;
      if CodPaisSisbov > 0 then begin
        //--------------------------------------------
        // Verifica duplicidade do Código País SisBov
        //--------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_pais ');
        Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
        Q.SQL.Add('   and cod_pais != :cod_pais ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pais').AsInteger := CodPais;
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbov;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(431, Self.ClassName, NomMetodo, [IntToStr(CodPaisSisBov)]);
          Result := -431;
          Exit;
        End;
        Q.Close;
      end;

      //----------------------------------------------------
      // Verifica se o Código País SisBov não está espetado
      // na tabela tab_animal
      //----------------------------------------------------
      if CodPaisSisBovCor <> CodPaisSisBov then begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_animal ');
          Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
          Q.SQL.Add('   and dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbovCor;
          Q.Open;
          If not Q.IsEmpty Then Begin
            Mensagens.Adicionar(433, Self.ClassName, NomMetodo, [CodPaisSisBovCor]);
            Result := -433;
            Exit;
          End;
          Q.Close;
       end;

      //----------------------------------------------------
      // Verifica se o Código País SisBov não está espetado
      // na tabela tab_codigo_sisbov
      //----------------------------------------------------
      if CodPaisSisBovCor <> CodPaisSisBov then begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_codigo_sisbov ');
          Q.SQL.Add(' where cod_pais_sisbov = :cod_pais_sisbov ');
    {$ENDIF}
          Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisbovCor;
          Q.Open;
          If not Q.IsEmpty Then Begin
            Mensagens.Adicionar(434, Self.ClassName, NomMetodo, [CodPaisSisBovCor]);
            Result := -434;
            Exit;
          End;
          Q.Close;
      end;
      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pais ');
      Q.SQL.Add('   set Cod_pais_sisbov = :cod_pais_sisbov');
      Q.SQL.Add('     , Nom_Pais = :Nom_Pais');
      Q.SQL.Add(' where cod_pais = :cod_pais');
{$ENDIF}
      Q.ParamByName('Nom_Pais').AsString         := NomPais;
      if CodPaisSisBov = -1  then begin
        Q.ParamByName('cod_pais_sisbov').DataType  := ftInteger;
        Q.ParamByName('cod_pais_sisbov').clear;
      end else begin
        Q.ParamByName('cod_pais_sisbov').AsInteger := CodPaisSisBov;
      end;
      Q.ParamByName('cod_pais').AsInteger         := CodPais;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(435, Self.ClassName, NomMetodo, [E.Message]);
        Result := -435;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPaises.Excluir(CodPais: Integer): Integer;
var
  Q : THerdomQuery;
  nPaisPar : Integer;
Const
  CodMetodo : Integer = 146;
  NomMetodo : String = 'Excluir';
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
  //------------------------------------------------
  // Não permite a exclusão do País da Certificadora
  //------------------------------------------------
   nPaisPar := StrToint(valorParametro(6));

   if nPaisPar = CodPais then begin
    Mensagens.Adicionar(723, Self.ClassName, NomMetodo, []);
    Result := -723;
    Exit;
   end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //----------------------------------
      // Verifica a existência do Registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais_sisBov from tab_pais ');
      Q.SQL.Add(' where cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(402, Self.ClassName, NomMetodo, [IntToStr(CodPais)]);
        Result := -402;
        Exit;
      End;

      //------------------------------------------
      // Verifica a existência de Estados Válidos
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ');
      Q.SQL.Add(' where cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(725, Self.ClassName, NomMetodo, [IntToStr(CodPais)]);
        Result := -725;
        Exit;
      End;

      //------------------------
      // Tenta Alterar Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pais ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_pais = :cod_pais ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(447, Self.ClassName, NomMetodo, [E.Message]);
        Result := -447;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPaises.Buscar(CodPais: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 147;
  NomMetodo : String = 'Buscar';
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

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------
      // Tenta Buscar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_pais ');
      Q.SQL.Add('     , nom_pais ');
      Q.SQL.Add('     , cod_pais_sisbov');
      Q.SQL.Add('  from tab_pais ');
      Q.SQL.Add(' where cod_pais = :cod_pais ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := CodPais;
      Q.Open;

      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(402, Self.ClassName, NomMetodo, []);
        Result := -402;
        Exit;
      End;

      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      FIntPais.CodPais          := Q.FieldByName('Cod_Pais').AsInteger;
      FIntPais.NomPais          := Q.FieldByName('nom_Pais').AsString;
      FIntPais.CodPaisSisBov    := Q.FieldByName('cod_pais_sisBov').AsInteger;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(448, Self.ClassName, NomMetodo, [E.Message]);
        Result := -448;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPaises.PaisCertificadora: Integer;
Const
  CodMetodo : Integer = 181;
  NomMetodo : String = 'PaisCertificadora';
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
  Try
    //-----------------------------------------
    // Obtem o código do País da Certificadora
    //-----------------------------------------
    Result := StrToInt(ValorParametro(6));
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(487, Self.ClassName, NomMetodo, [E.Message]);
      Result := -487;
      Exit;
    End;
  End;
end;
end.

