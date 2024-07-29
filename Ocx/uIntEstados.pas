// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Estados - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *   Hítalo    02/08/2002    Adicionar método Inserir,Excluir,Alterar
// *                           Buscar.
// *
// ********************************************************************
unit uIntEstados;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntEstado;

type
{ TIntEstados }
  TIntEstados= class(TIntClasseBDNavegacaoBasica)
  private
    FIntEstado : TIntEstado;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Pesquisar(CodPais : Integer;CodOrdenacao : String) : Integer;
    function Inserir(NomEstado,SglEstado: String;CodEstSisBov,CodPais : Integer): Integer;
    function Alterar(CodEstado : Integer; NomEstado,SglEstado: String;CodEstSisBov : Integer): Integer;
    function Excluir(CodEstado : Integer): Integer;
    function Buscar(CodEstado : Integer): Integer;
    property IntEstado : TIntEstado read FIntEstado write FIntEstado;
  end;

implementation

constructor TIntEstados.Create;
begin
  inherited;
  FIntEstado := TIntEstado.Create;
end;

destructor TIntEstados.Destroy;
begin
  FIntEstado.Free;
  inherited;
end;

{ TIntEstados }
function TIntEstados.Pesquisar(CodPais : Integer;CodOrdenacao : String): Integer;
Const
  CodMetodo : Integer = 83;
  NomMetodo : String = 'Pesquisar';
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

  //-----------------------------------------------------------
  // Obetem o Valor do Parâmetro do Código estado Certificadora
  //-----------------------------------------------------------
  if CodPais = - 1 then
    CodPais := StrToInt(ValorParametro(6));

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select e.cod_estado as CodEstado  ' +
  '     , e.sgl_estado as SglEstado  ' +
  '     , e.nom_estado as NomEstado  ' +
  '     , e.cod_estado_sisBov as CodEstadoSisBov ' +
  '     , p.cod_Pais as CodPais ' +
  '     , p.nom_Pais as NomPais ' +
  '     , p.cod_pais_sisBov as CodPaisSisBov ' +
  '  from tab_estado e  ' +
  '     , tab_pais p   ' +
  ' where p.cod_pais = e.cod_pais ' +
  '   and ((e.Cod_pais = :Cod_pais) or (:Cod_pais = -1)) ' +
  '   and e.dta_fim_validade is null');
   if UpperCase(CodOrdenacao)= 'S' then begin
     Query.SQL.Add(' order by e.sgl_estado   ')
   end
   else if UpperCase(CodOrdenacao)= 'N' then begin
     Query.SQL.Add(' order by e.nom_estado   ')
   end
   else if UpperCase(CodOrdenacao)= 'B' then begin
     Query.SQL.Add(' order by e.cod_estado_sisbov   ')
   end;

  Query.ParamByName('Cod_pais').AsInteger := codPais;

{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(302, Self.ClassName, NomMetodo, [E.Message]);
      Result := -302;
      Exit;
    End;
  End;
end;

function TIntEstados.Inserir(NomEstado,SglEstado: String;CodEstSisBov,CodPais : Integer): Integer;
var
  Q : THerdomQuery;
  CodEstado : Integer;
Const
  CodMetodo : Integer = 148;
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

  //------------------------
  //Válida o Nome do Estado
  //------------------------
  Result := VerificaString(NomEstado,'Nome do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomEstado,20,'Nome do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  //------------------------
  //Válida o Sigla do Estado
  //------------------------
  Result := VerificaString(SglEstado,'Sigla do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglEstado,2,'Sigla do Estado');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------------------------
  // Verifica se o Código do SisBov <> 0
  //-------------------------------------
  If CodEstSisBov = 0 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, [IntToStr(CodEstSisBov)]);
    Result := -296;
    Exit;
  End;

  //---------------------------------------------------------
  // Obetem o Valor do Parâmetro do Código Pais Certificadora
  //---------------------------------------------------------
  if CodPais = - 1 then
    CodPais := StrToInt(ValorParametro(6));

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------
      // Verifica duplicidade do Nome Estado
      //-------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ' +
        ' where nom_estado = :nom_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_estado').AsString := NomEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(449, Self.ClassName, NomMetodo, [NomEstado]);
        Result := -449;
        Exit;
      End;
      Q.Close;
      //-------------------------------------
      // Verifica duplicidade do Sigla Estado
      //-------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ' +
        ' where sgl_estado = :sgl_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_estado').AsString := SglEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(451, Self.ClassName, NomMetodo, [SglEstado]);
        Result := -451;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------
      // Verifica duplicidade do Código Estado SisBov
      //----------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ' +
        ' where cod_estado_sisbov = :cod_estado_sisbov ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstSisbov;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(452, Self.ClassName, NomMetodo, [IntToStr(CodEstSisbov)]);
        Result := -452;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica a existência do Registro no País
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pais ' +
        ' where cod_pais = :cod_pais ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := Codpais;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(402, Self.ClassName, NomMetodo, [IntToStr(CodPais)]);
        Result := -402;
        Exit;
      End;

      //Abre transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_estado), 0) + 1 as cod_estado from tab_estado');
{$ENDIF}
      Q.Open;
      CodEstado := Q.FieldByName('cod_estado').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_estado ' + 
      ' (cod_estado, ' + 
      '  nom_estado, ' + 
      '  sgl_estado, ' + 
      '  cod_estado_sisbov, ' + 
      '  cod_pais, ' + 
      '  dta_fim_validade) ' + 
      'values ' + 
      ' (:cod_estado, ' +
      '  :nom_estado, ' + 
      '  :sgl_estado, ' + 
      '  :cod_estado_sisbov, ' + 
      '  :cod_pais, ' + 
      '  null ) ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger         := CodEstado;
      Q.ParamByName('nom_estado').AsString          := NomEstado;
      Q.ParamByName('sgl_estado').AsString          := SglEstado;
      Q.ParamByName('cod_pais').AsInteger           := CodPais;

      if CodEstSisBov = -1  then begin
        Q.ParamByName('cod_estado_sisBov').DataType  := ftInteger;
        Q.ParamByName('cod_estado_sisBov').clear;
      end else begin
        Q.ParamByName('cod_estado_sisBov').AsInteger  := CodEstSisBov;
      end;

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := Codestado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(450, Self.ClassName, NomMetodo, [E.Message]);
        Result := -450;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEstados.Alterar(CodEstado : Integer; NomEstado,SglEstado: String;CodEstSisBov : Integer): Integer;
var
  Q : THerdomQuery;
  CodEstSisBovCor : Integer;
Const
  CodMetodo : Integer = 149;
  NomMetodo : String = 'Alterar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
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

  //------------------------
  //Válida o Nome do Estado
  //------------------------
  Result := VerificaString(NomEstado,'Nome do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomEstado,20,'Nome do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  //------------------------
  //Válida o Sigla do Estado
  //------------------------
  Result := VerificaString(SglEstado,'Sigla do Estado');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglEstado,2,'Sigla do Estado');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------------------------
  // Verifica se o Código do SisBov <> 0
  //-------------------------------------
  If CodEstSisBov = 0 Then Begin
    Mensagens.Adicionar(296, Self.ClassName, NomMetodo, [IntToStr(CodEstSisBov)]);
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
      Q.SQL.Add('select cod_estado_sisBov from tab_estado ' +
        ' where cod_estado = :cod_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(387, Self.ClassName, NomMetodo, [IntToStr(CodEstado)]);
        Result := -387;
        Exit;
      End;

      //-------------------------------
      // Código Estado SisBov Corrente
      //-------------------------------
      CodEstSisBovCor := Q.FieldByName('cod_estado_sisBov').Asinteger;
      Q.Close;

      //------------------------------------
      // Verifica duplicidade do Nome Estado
      //------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado '+
      ' where nom_estado = :nom_estado '+
      '   and cod_estado != :cod_estado '+
      '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_estado').AsString := NomEstado;
      Q.ParamByName('cod_estado').Asinteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(449, Self.ClassName, NomMetodo, [NomEstado]);
        Result := -449;
        Exit;
      End;
      Q.Close;
      //-------------------------------------
      // Verifica duplicidade do Sigla Estado
      //-------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_estado ' +
      ' where sgl_estado = :sgl_estado ' +
      '   and cod_estado != :cod_estado ' +
      '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_estado').AsString := SglEstado;
      Q.ParamByName('cod_estado').Asinteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(451, Self.ClassName, NomMetodo, [SglEstado]);
        Result := -451;
        Exit;
      End;
      Q.Close;

      if (CodEstSisBov > 0) and (CodEstSisBov <> CodEstSisBovCor) then begin
        //--------------------------------------------
        // Verifica duplicidade do Código Estado SisBov
        //--------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_estado ' +
                ' where cod_estado_sisbov = :cod_estado_sisbov ' +
                '   and cod_estado != :cod_estado ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstSisbov;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(452, Self.ClassName, NomMetodo, [IntToStr(CodEstSisBov)]);
          Result := -452;
          Exit;
        End;
        Q.Close;

        //----------------------------------------------------
        // Verifica se o Código Estado SisBov não está espetado
        // na tabela tab_animal
        //----------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_estado_sisbov = :cod_estado_sisbov ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstSisbovCor;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(453, Self.ClassName, NomMetodo, [IntToStr(CodEstSisBovCor)]);
          Result := -453;
          Exit;
        End;
        Q.Close;

        //----------------------------------------------------
        // Verifica se o Código Estado SisBov não está espetado
        // na tabela tab_codigo_sisbov
        //----------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_codigo_sisbov ' +
        ' where cod_estado_sisbov = :cod_estado_sisbov ');
  {$ENDIF}
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstSisbovCor;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(454, Self.ClassName, NomMetodo, [IntToStr(CodEstSisBovCor)]);
          Result := -454;
          Exit;
        End;
        Q.Close;
      end;
      //----------------
      // Abre transação
      //----------------
      BeginTran;
      //-----------------------
      // Tenta Alterar Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_estado '+
      '   set Cod_estado_sisbov = :cod_estado_sisbov'+
      '     , Nom_estado = :Nom_estado'+
      '     , sgl_estado = :sgl_estado'+
      ' where cod_estado = :cod_estado');
{$ENDIF}
      Q.ParamByName('Nom_estado').AsString         := NomEstado;
      Q.ParamByName('sgl_estado').AsString         := SglEstado;
      if CodEstSisBov = -1  then begin
        Q.ParamByName('cod_estado_sisbov').DataType  := ftInteger;
        Q.ParamByName('cod_estado_sisbov').clear;
      end else begin
        Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstSisBov;
      end;
      Q.ParamByName('cod_estado').AsInteger         := CodEstado;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(455, Self.ClassName, 'Alterar', [E.Message]);
        Result := -455;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEstados.Excluir(CodEstado: Integer): Integer;
var
  Q : THerdomQuery;
  CodEstadoSisbov : Integer;
Const
  CodMetodo : Integer = 150;
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
      Q.SQL.Add('select cod_estado_sisBov from tab_estado ' +
        ' where cod_estado = :cod_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(387, Self.ClassName, NomMetodo, [IntToStr(CodEstado)]);
        Result := -387;
        Exit;
      End;
      CodEstadoSisbov := Q.FieldByName('cod_estado_sisBov').asInteger;
      //------------------------------------------------
      // Verifica a existência do Registro no Municipio
      //------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_municipio ' +
        ' where cod_estado = :cod_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(924, Self.ClassName, NomMetodo, [IntToStr(CodEstado)]);
        Result := -924;
        Exit;
      End;
      //---------------------------------------------
      // Verifica a existência do Registro na Fazenda
      //---------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ' +
        ' where cod_estado = :cod_estado ' +
        '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(925, Self.ClassName, NomMetodo, [IntToStr(CodEstado)]);
        Result := -925;
        Exit;
      End;
      //----------------------------------------------------
      // Verifica a existência do Registro no Código SISBOV
      //----------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_codigo_sisbov ' +
        ' where cod_estado_sisbov = :cod_estado_sisbov ');
{$ENDIF}
      Q.ParamByName('cod_estado_sisbov').AsInteger := CodEstadoSisBov;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(926, Self.ClassName, NomMetodo, [IntToStr(CodEstadoSisBov)]);
        Result := -926;
        Exit;
      End;

      //------------------------
      // Tenta Excluir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_estado ' +
                '   set dta_fim_validade = getdate() ' +
                ' where cod_estado = :cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(456, Self.ClassName, NomMetodo, [E.Message]);
        Result := -456;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEstados.Buscar(CodEstado: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 151;
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
      Q.SQL.Add('select e.cod_estado '+
      '     , e.nom_estado '+
      '     , e.sgl_estado '+
      '     , e.cod_estado_sisbov'+
      '     , p.cod_pais '+
      '     , p.nom_pais '+
      '     , p.cod_pais_sisbov'+
      '  from tab_estado e '+
      '     , tab_pais p '+
      ' where e.cod_estado = :cod_estado '+
      '   and p.cod_pais = e.cod_pais '+
      '   and e.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;

      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(387, Self.ClassName, NomMetodo, []);
        Result := -387;
        Exit;
      End;

      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      FIntEstado.CodEstado            := Q.FieldByName('Cod_estado').AsInteger;
      FIntEstado.NomEstado            := Q.FieldByName('nom_estado').AsString;
      FIntEstado.SglEstado            := Q.FieldByName('sgl_estado').AsString;
      FIntEstado.CodestadoSisBov      := Q.FieldByName('cod_estado_sisBov').AsInteger;
      FIntEstado.CodPais              := Q.FieldByName('Cod_Pais').AsInteger;
      FIntEstado.NomPais              := Q.FieldByName('nom_Pais').AsString;
      FIntEstado.CodPaisSisBov        := Q.FieldByName('cod_Pais_sisBov').AsInteger;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(457, Self.ClassName, NomMetodo, [E.Message]);
        Result := -457;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

