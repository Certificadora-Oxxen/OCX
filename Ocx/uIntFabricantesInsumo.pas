// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 11/09/2002
// *  Documentação       :
// *  Código Classe      :  60
// *  Descrição Resumida : Cadastro de Fabricante Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/10/2002    Criação
// *
// ********************************************************************
unit uIntFabricantesInsumo;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntFabricanteInsumo,uFerramentas;

type
  { TIntRacas }
  TIntFabricantesInsumo = class(TIntClasseBDNavegacaoBasica)
  private
    FIntFabricanteInsumo : TIntFabricanteInsumo;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodTipoInsumo : Integer;CodOrdenacao: String) : Integer;
    function Inserir(NomFabricanteInsumo,NomReduzidoFabricanteInsumo: String;NumRegistroFabricante : Integer): Integer;
    function Alterar(CodFabricanteInsumo: Integer; NomFabricanteInsumo,NomReduzidoFabricanteInsumo: String;NumRegistroFabricante : Integer): Integer;
    function Excluir(CodFabricanteInsumo: Integer): Integer;
    function Buscar(CodFabricanteInsumo: Integer): Integer;
    function AdicionarTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;
    function RetirarTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;
    function PossuiTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;

    property IntFabricanteInsumo : TIntFabricanteInsumo read FIntFabricanteInsumo write FIntFabricanteInsumo;
  end;

implementation

{ TIntFabricantesInsumo }
constructor TIntFabricantesInsumo.Create;
begin
  inherited;
  FIntFabricanteInsumo := TIntFabricanteInsumo.Create;
end;

destructor TIntFabricantesInsumo.Destroy;
begin
  FIntFabricanteInsumo.Free;
  inherited;
end;

function TIntFabricantesInsumo.Pesquisar(CodTipoInsumo : Integer;CodOrdenacao: String) : Integer;
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
  If Not Conexao.PodeExecutarMetodo(272) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tf.cod_fabricante_insumo as CodFabricanteInsumo ' +
  '     , tf.nom_fabricante_insumo as NomFabricanteInsumo ' +
  '     , tf.nom_reduzido_fabricante as NomReduzidoFabricante ' +
  '     , tf.num_registro_fabricante as NumRegistroFabricante  ');
  if CodTipoInsumo <> -1 then
    Query.SQL.Add(',tft.Cod_tipo_Insumo as CodTipoInsumo ')
  else
    Query.SQL.Add(', 0 as CodTipoInsumo');

  Query.SQL.Add('  from tab_fabricante_insumo tf');
  if CodTipoInsumo <> -1 then begin
    Query.SQL.Add(' , tab_fabricante_tipo_insumo tft' +
      '  where tft.cod_fabricante_insumo = tf.cod_fabricante_insumo' +
      '    and tft.cod_tipo_insumo = :cod_tipo_insumo ' +
      '    and tf.dta_fim_validade is null ');
  end
  else begin
    Query.SQL.Add('  where tf.dta_fim_validade is null ');
  end;

  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by tf.num_registro_fabricante')
  else if CodOrdenacao = 'N' then
    Query.SQL.Add(' order by tf.nom_fabricante_insumo ')
  else if CodOrdenacao = 'R' then
    Query.SQL.Add(' order by tf.nom_reduzido_fabricante ');
{$ENDIF}
  if CodTipoInsumo <> -1 then begin
    Query.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
  end;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(810, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -810;
      Exit;
    End;
  End;
end;

function TIntFabricantesInsumo.Inserir(NomFabricanteInsumo,NomReduzidoFabricanteInsumo: String;NumRegistroFabricante : Integer): Integer;
var
  Q : THerdomQuery;
  CodFabricanteInsumo : Integer;
Const
    NomeMetodo : String = 'Inserir';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(269) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------
  //Valida Nome
  //-----------
  Result := VerificaString(NomFabricanteInsumo,'Nome do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomFabricanteInsumo,30,'Nome do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------
  //Valida Nome Reduzido
  //---------------------
  Result := VerificaString(NomReduzidoFabricanteInsumo,'Nome Reduzido do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomReduzidoFabricanteInsumo,15,'Nome Reduzido do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------
      // Verifica duplicidade do Nome
      //-----------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where nom_fabricante_insumo = :nom_fabricante_insumo' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_fabricante_insumo').AsString := NomFabricanteInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(812, Self.ClassName, NomeMetodo, [NomFabricanteInsumo]);
        Result := -812;
        Exit;
      End;
      Q.Close;
      //--------------------------------------
      // Verifica duplicidade do Nome Reduzido
      //---------------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where nom_reduzido_fabricante = :nom_reduzido_fabricante' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_reduzido_fabricante').AsString := NomReduzidoFabricanteInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(813, Self.ClassName, NomeMetodo, [NomReduzidoFabricanteInsumo]);
        Result := -813;
        Exit;
      End;
      Q.Close;
      //-------------------------------------
      // Verifica Numero Registro Fabricante
      //-------------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where num_registro_fabricante = :num_registro_fabricante ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_registro_fabricante').AsInteger := NumRegistroFabricante;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(844, Self.ClassName, NomeMetodo, [IntToStr(NumRegistroFabricante)]);
        Result := -844;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      //---------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_fabricante_insumo), 0) + 1 as cod_fabricante_insumo from tab_fabricante_insumo');
{$ENDIF}
      Q.Open;
      CodFabricanteInsumo := Q.FieldByName('cod_fabricante_insumo').AsInteger;

      //-----------------------
      // Tenta Inserir Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_fabricante_insumo ' +
      ' (cod_fabricante_insumo, ' +
      '  nom_fabricante_insumo, ' +
      '  nom_reduzido_fabricante, ' +
      '  num_registro_fabricante, '+
      '  dta_fim_validade) ' +
      'values ' +
      ' (:cod_fabricante_insumo, ' +
      '  :nom_fabricante_insumo, ' +
      '  :nom_reduzido_fabricante, ' +
      '  :num_registro_fabricante, ' +
      '  null ) ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger   := CodFabricanteInsumo;
      Q.ParamByName('nom_fabricante_insumo').AsString    := NomFabricanteInsumo;
      Q.ParamByName('nom_reduzido_fabricante').AsString  := NomReduzidoFabricanteInsumo;
      Q.ParamByName('num_registro_fabricante').DataType     := ftInteger;
      AtribuiValorParametro(Q.ParamByName('num_registro_fabricante'),NumRegistroFabricante);
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodFabricanteInsumo;;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(814, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -814;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.Alterar(CodFabricanteInsumo: Integer; NomFabricanteInsumo,NomReduzidoFabricanteInsumo: String;NumRegistroFabricante : Integer): Integer;
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
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(270) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------
  //Valida Nome
  //-----------
  Result := VerificaString(NomFabricanteInsumo,'Nome do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomFabricanteInsumo,30,'Nome do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------
  //Valida Nome Reduzido
  //---------------------
  Result := VerificaString(NomReduzidoFabricanteInsumo,'Nome Reduzido do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomReduzidoFabricanteInsumo,15,'Nome Reduzido do Fabricante Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------------
      // Verifica há existência do Registro
      //-----------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where cod_fabricante_insumo = :cod_fabricante_insumo' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, [IntToStr(CodFabricanteInsumo)]);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //-----------------------------
      // Verifica duplicidade do Nome
      //-----------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where nom_fabricante_insumo = :nom_fabricante_insumo' +
         '   and cod_fabricante_insumo != :cod_fabricante_insumo' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_fabricante_insumo').AsString := NomFabricanteInsumo;
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(812, Self.ClassName, NomeMetodo, [NomFabricanteInsumo]);
        Result := -812;
        Exit;
      End;
      Q.Close;
      //--------------------------------------
      // Verifica duplicidade do Nome Reduzido
      //---------------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where nom_reduzido_fabricante = :nom_reduzido_fabricante ' +
         '   and cod_fabricante_insumo != :cod_fabricante_insumo ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_reduzido_fabricante').AsString := NomReduzidoFabricanteInsumo;
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(813, Self.ClassName, NomeMetodo, [NomReduzidoFabricanteInsumo]);
        Result := -813;
        Exit;
      End;
      Q.Close;
      //-------------------------------------
      // Verifica Numero Registro Fabricante
      //-------------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where num_registro_fabricante = :num_registro_fabricante ' +
         '   and cod_fabricante_insumo != :cod_fabricante_insumo ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_registro_fabricante').AsInteger := NumRegistroFabricante;
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;

      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(844, Self.ClassName, NomeMetodo, [IntToStr(NumRegistroFabricante)]);
        Result := -844;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //---------------
      BeginTran;
      //-----------------------
      // Tenta Alterar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_fabricante_insumo ' +
      '   set nom_fabricante_insumo = :nom_fabricante_insumo ' +
      '     , nom_reduzido_fabricante = :nom_reduzido_fabricante ' +
      '     , num_registro_fabricante = :num_registro_fabricante ' +
      ' where cod_fabricante_insumo = :cod_fabricante_insumo ');
{$ENDIF}
      //----------------------------------------
      // Atribui o Tipo de dado para o parâmetro
      //----------------------------------------
      Q.ParamByName('cod_fabricante_insumo').DataType     := ftInteger;
      AtribuiValorParametro(Q.ParamByName('cod_fabricante_insumo'),CodFabricanteInsumo);

      Q.ParamByName('nom_fabricante_insumo').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('nom_fabricante_insumo'),NomFabricanteInsumo);

      Q.ParamByName('nom_reduzido_fabricante').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('nom_reduzido_fabricante'),NomReduzidoFabricanteInsumo);

      Q.ParamByName('num_registro_fabricante').DataType     := ftInteger;
      AtribuiValorParametro(Q.ParamByName('num_registro_fabricante'),NumRegistroFabricante);

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(816, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -816;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.Excluir(CodFabricanteInsumo: Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(271) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------------------
      // Verifica existência do fabricante Insumo
      //-----------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
        ' where cod_fabricante_insumo = :cod_fabricante_insumo ' +
        '   and dta_fim_validade is null ' );
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, []);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------
      // Verifica relacionamento com  Insumo Válido
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_insumo ' +
        ' where cod_fabricante_insumo = :cod_fabricante_insumo ' +
        '   and dta_fim_validade is null ' );
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(817, Self.ClassName, NomeMetodo, []);
        Result := -817;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_fabricante_insumo ' +
        '          set dta_fim_validade  = getDate() ' +
        ' where cod_fabricante_insumo = :cod_fabricante_insumo ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger      := CodFabricanteInsumo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(819, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -819;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.Buscar(CodFabricanteInsumo: Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(268) Then Begin
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
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_fabricante_insumo ' + 
      '     , nom_fabricante_insumo '   + 
      '     , nom_reduzido_fabricante ' +
      '     , num_registro_fabricante ' +
      '  from tab_fabricante_insumo '   +
      ' where cod_fabricante_insumo = :cod_fabricante_insumo ' +
      '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, []);
        Result := -815;
        Exit;
      End;

      // Obtem informações do registro
      FIntFabricanteInsumo.CodFabricanteInsumo          := Q.FieldByName('Cod_fabricante_insumo').AsInteger;
      FIntFabricanteInsumo.NomFabricanteInsumo          := Q.FieldByName('nom_fabricante_insumo').AsString;
      FIntFabricanteInsumo.NomReduzidoFabricanteInsumo  := Q.FieldByName('nom_reduzido_fabricante').AsString;
      FIntFabricanteInsumo.NumRegistroFabricante        := Q.FieldByName('num_registro_fabricante').AsInteger;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(821, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -821;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.AdicionarTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;
var
  Q : THerdomQuery;
Const
    NomeMetodo : String = 'AdicionarTipoInsumo';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(273) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------------------------
      // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_insumo ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, []);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, NomeMetodo, []);
        Result := -800;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //---------------------
      // Verifica existencia
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_tipo_insumo ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
          //------------------------
          // Tenta Inserir Registro
          //------------------------
          Q.Close;
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('insert into tab_fabricante_tipo_insumo  ');
          Q.SQL.Add(' ( cod_fabricante_insumo ');
          Q.SQL.Add(' , cod_tipo_insumo ');
          Q.SQL.Add(' )');
          Q.SQL.Add('values ');
          Q.SQL.Add(' ( :cod_fabricante_insumo ');
          Q.SQL.Add(' , :cod_tipo_insumo ');
          Q.SQL.Add(' )');
    {$ENDIF}
          Q.ParamByName('cod_fabricante_insumo').AsInteger    := CodFabricanteInsumo;
          Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
          Q.ExecSQL;
      end;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(825, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -825;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.RetirarTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;
var
  Q : THerdomQuery;
Const
    NomeMetodo : String = 'RetirarTipoInsumo';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(274) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------------------------
      // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_insumo ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, []);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, NomeMetodo, []);
        Result := -800;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //------------------------
      // Tenta Excluir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_fabricante_tipo_insumo  ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger    := CodFabricanteInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ExecSQL;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(827, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -827;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesInsumo.PossuiTipoInsumo(CodFabricanteInsumo,CodTipoInsumo: Integer): Integer;
var
  Q : THerdomQuery;
Const
    NomeMetodo : String = 'PossuiTipoInsumo';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(275) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------------------------
      // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_insumo ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, NomeMetodo, []);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
       // Verifica existencia do Fabricante Insumo
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, NomeMetodo, []);
        Result := -800;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fabricante_tipo_insumo  ');
      Q.SQL.Add(' where cod_fabricante_insumo = :cod_fabricante_insumo ');
      Q.SQL.Add('   and cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger    := CodFabricanteInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 1;
      End Else Begin
        Result := 0;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(796, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -796;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

