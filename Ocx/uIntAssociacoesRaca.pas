// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/07/2002
// *  Documentação       : Atributos de animais - definição das classes.doc
// *  Código Classe      : 37
// *  Descrição Resumida : Cadastro de Associações de Raças Animal -
// *                       Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    23/07/2002    Criação
// *   Hitalo    19/08/2002  Adicionar métodos Inserir, Excluir, Buscar ,Alterar,
// *                         AdicionarGrauSangue,RetirrarGrauSangue,PesquisarRelacionamentos
// *   Canival   23/12/2002  Adicionar métodos PesquisardoProdutor, AdicionardoProdutor
// *                         RetirardoProdutor
// *
// ********************************************************************
unit uIntAssociacoesRaca;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uIntAssociacaoRaca, uColecoes;

type
  { TIntAssociacoesRaca }
  TIntAssociacoesRaca = class(TIntClasseBDNavegacaoBasica)
  private
    FIntAssociacaoRaca : TIntAssociacaoRaca;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodOrdenacao: String) : Integer;
    function Inserir(SglAssociacaoRaca,NomAssociacaoRaca : String): Integer;
    function Alterar(CodAssociacaoRaca : Integer;SglAssociacaoRaca,NomAssociacaoRaca : String): Integer;
    function Excluir(CodAssociacaoRaca : Integer): Integer;
    function Buscar(CodAssociacaoRaca : Integer): Integer;
    function AdicionarGrauSangue(CodAssociacaoRaca: Integer; CodGrausSangue: String): Integer;
    function RetirarGrauSangue(CodAssociacaoRaca: Integer; CodGrausSangue: String): Integer;
    function PesquisarRelacionamento: Integer;
    function PesquisarDoProdutor(IndAssociacaoRacaProdutor,CodOrdenacao: String) : Integer;
    function AdicionarAoProdutor(CodAssociacaoRaca: Integer): Integer;
    function RetirarDoProdutor(CodAssociacaoRaca: Integer): Integer;
    function AdicionarRaca(CodAssociacaoRaca: Integer; CodRacas: String): Integer;
    function PesquisarRacas(CodAssociacaoRaca: Integer; IndAindaNaoRelacionados, CodOrdenacao: String): Integer;
    function RetirarRaca(CodAssociacaoRaca: Integer; CodRacas: String): Integer;

    property IntAssociacaoRaca : TIntAssociacaoRaca read FIntAssociacaoRaca write FIntAssociacaoRaca;
  end;

implementation

{ TIntAssociacoesRaca}

constructor TIntAssociacoesRaca.Create;
begin
  inherited;
  FIntAssociacaoRaca := TIntAssociacaoRaca.Create;
end;

destructor TIntAssociacoesRaca.Destroy;
begin
  FIntAssociacaoRaca.Free;
  inherited;
end;

function TIntAssociacoesRaca.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(159) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_associacao_raca as CodAssociacaoRaca ');
  Query.SQL.Add('     , sgl_associacao_raca as SglAssociacaoRaca ');
  Query.SQL.Add('     , nom_associacao_raca as NomAssociacaoRaca ');
  Query.SQL.Add('  from tab_associacao_raca ');
  Query.SQL.Add(' where dta_fim_validade is null');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_associacao_raca ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_associacao_raca ')
  else if CodOrdenacao = 'N' then
    Query.SQL.Add(' order by nom_associacao_raca ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(339, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -339;
      Exit;
    End;
  End;
end;

function TIntAssociacoesRaca.Inserir(SglAssociacaoRaca,NomAssociacaoRaca : String): Integer;
var
  Q : THerdomQuery;
  CodAssociacaoRaca : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(214) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglAssociacaoRaca, 'Sigla da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglAssociacaoRaca, 10, 'Sigla da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(NomAssociacaoRaca, 'Nome da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomAssociacaoRaca, 50, 'Nome da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  sgl_associacao_raca = :sgl_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_associacao_raca').AsString := SglAssociacaoRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(546, Self.ClassName, 'Inserir', [SglAssociacaoRaca]);
        Result := -546;
        Exit;
      End;
      Q.Close;

      //-----------------------------
      // Verifica duplicidade do Nome
      //-----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  nom_associacao_raca = :nom_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_associacao_raca').AsString := NomAssociacaoRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(547, Self.ClassName, 'Inserir', [NomAssociacaoRaca]);
        Result := -547;
        Exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------

      BeginTran;
      //--------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_associacao_raca), 0) + 1 as cod_associacao_raca ');
      Q.SQL.Add('  from tab_associacao_raca ');
{$ENDIF}
      Q.Open;
      CodAssociacaoRaca := Q.FieldByName('cod_associacao_raca').AsInteger;
      //-------------------------
      // Tenta Inserir Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_associacao_raca ');
      Q.SQL.Add(' (cod_associacao_raca, ');
      Q.SQL.Add('  sgl_associacao_raca, ');
      Q.SQL.Add('  nom_associacao_raca, ');
      Q.SQL.Add('  dta_fim_validade )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_associacao_raca, ');
      Q.SQL.Add('  :sgl_associacao_raca, ');
      Q.SQL.Add('  :nom_associacao_raca, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger            := CodAssociacaoRaca;
      Q.ParamByName('sgl_associacao_raca').AsString             := SglAssociacaoRaca;
      Q.ParamByName('nom_associacao_raca').AsString             := NomAssociacaoRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := codAssociacaoRaca;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(548, Self.ClassName, 'Inserir', [E.Message]);
        Result := -548;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.Alterar(CodAssociacaoRaca : Integer;SglAssociacaoRaca,NomAssociacaoRaca : String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(215) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglAssociacaoRaca, 'Sigla da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglAssociacaoRaca, 10, 'Sigla da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(NomAssociacaoRaca, 'Nome da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomAssociacaoRaca, 50, 'Nome da Associação Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------------
      // Verifica a existência do registro
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(471, Self.ClassName, 'Inserir', [IntToStr(CodAssociacaoRaca)]);
        Result := -471;
        Exit;
      End;
      Q.Close;
      //-------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  sgl_associacao_raca  = :sgl_associacao_raca ');
      Q.SQL.Add('   and  cod_associacao_raca != :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_associacao_raca').AsString  := SglAssociacaoRaca;
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(546, Self.ClassName, 'Inserir', [SglAssociacaoRaca]);
        Result := -546;
        Exit;
      End;
      Q.Close;

      //-----------------------------
      // Verifica duplicidade do Nome
      //-----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  nom_associacao_raca = :nom_associacao_raca ');
      Q.SQL.Add('   and  cod_associacao_raca != :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_associacao_raca').AsString := NomAssociacaoRaca;
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(547, Self.ClassName, 'Inserir', [NomAssociacaoRaca]);
        Result := -547;
        Exit;
      End;
      Q.Close;

      //----------------
      // Abre transação
      //----------------
      BeginTran;

      //-----------------
      // Alterar Registro
      //-----------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_associacao_raca ');
      Q.SQL.Add('   set sgl_associacao_raca = :sgl_associacao_raca');
      Q.SQL.Add('     , nom_associacao_raca = :nom_associacao_raca');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.ParamByName('sgl_associacao_raca').AsString  := SglAssociacaoRaca;
      Q.ParamByName('nom_associacao_raca').AsString  := NomAssociacaoRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(549, Self.ClassName, 'Alterar', [E.Message]);
        Result := -549;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.Excluir(CodAssociacaoRaca : Integer): Integer;
var
  Q : THerdomQuery;
  STipoExclusao : String;
begin
  Result := -1;
  STipoExclusao := 'S'; //Excluir o Registro

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(216) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------------
      // Verifica a existência do registro
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where  cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(471, Self.ClassName, 'Inserir', [IntToStr(CodAssociacaoRaca)]);
        Result := -471;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica o relacionamento com Grau Sangue
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_assoc_raca_grau_sangue ');
      Q.SQL.Add(' where  cod_associacao_raca = :cod_associacao_raca ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        STipoExclusao := 'N';
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      //------------------------------------
      // Exclui o Registro - DtaFimValidade
      //------------------------------------
      Q.Close;
      Q.SQL.Clear;
      if STipoExclusao = 'N' then begin
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_associacao_raca ');
        Q.SQL.Add('   set dta_fim_validade = getdate() ');
        Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
  {$ENDIF}
      end
      else begin
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_associacao_raca ');
        Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
  {$ENDIF}
      end;
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(550, Self.ClassName, 'Excluir', [E.Message]);
        Result := -550;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.Buscar(CodAssociacaoRaca : Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(220) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------
      // Buscar Registro
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select cod_associacao_raca ');
      Q.SQL.Add('     , sgl_associacao_raca ');
      Q.SQL.Add('     , nom_associacao_raca ');
      Q.SQL.Add('  from tab_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(471, Self.ClassName, 'Buscar', []);
        Result := -471;
        Exit;
      End;
      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      IntAssociacaoRaca.CodAssociacaoRaca  := Q.FieldByName('cod_associacao_Raca').AsInteger;
      IntAssociacaoRaca.SglAssociacaoRaca  := Q.FieldByName('sgl_associacao_Raca').AsString;
      IntAssociacaoRaca.NomAssociacaoRaca  := Q.FieldByName('nom_associacao_Raca').AsString;

      Q.close;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(552, Self.ClassName, 'Buscar', [E.Message]);
        Result := -552;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.AdicionarGrauSangue(CodAssociacaoRaca: Integer;
  CodGrausSangue: String): Integer;
var
  Q : THerdomQuery;
  Param: TValoresParametro;
  X  : Integer;
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarGrauSangue');
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(221) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarGrauSangue', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------------
      // Verifica existencia de Associação Raça
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(471, Self.ClassName, 'AdicionarGrauSangue', []);
        Result := -471;
        Exit;
      End;
      Q.Close;

      Param := TValoresParametro.Create(TValorParametro);
      try
        // Consistindo o "parâmetro" graus sangue
        Result := VerificaParametroMultiValor(CodGrausSangue, Param);
        If Result < 0 Then Begin
          Exit;
        End;

        // Consistindo graus sangue
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  tgs.des_grau_sangue as DesGrauSangue '+
          '  , targs.cod_associacao_raca as CodAssociacaoRaca '+
          'from '+
          '  tab_grau_sangue tgs '+
          '  , tab_assoc_raca_grau_sangue targs '+
          'where '+
          '  tgs.cod_grau_sangue = :cod_grau_sangue '+
          '  and tgs.dta_fim_validade is null '+
          '  and tgs.cod_grau_sangue *= targs.cod_grau_sangue '+
          '  and targs.cod_associacao_raca = :cod_associacao_raca ';
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.Close;
          Q.ParamByName('cod_grau_sangue').AsInteger := Param.Items[X].Valor;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(1373, Self.ClassName, 'AdicionarGrauSangue', []);
            Result := -1373;
            Exit;
          end else if not Q.FieldByName('CodAssociacaoRaca').IsNull then begin
            Mensagens.Adicionar(1372, Self.ClassName, 'AdicionarGrauSangue', [Q.FieldByName('DesGrauSangue').AsString]);
            Result := -1372;
            Exit;
          end;
        end;

        // Abre transação
        BeginTran;

        Q.Close;
        Q.SQL.Text :=
          'insert into tab_assoc_raca_grau_sangue '+
          ' (cod_associacao_raca '+
          '  , cod_grau_sangue) '+
          'values '+
          ' (:cod_associacao_raca '+
          '  , :cod_grau_sangue ) ';
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.ParamByName('cod_grau_sangue').AsInteger := Param.Items[X].Valor;
          Q.ExecSQL;
        end;

        // Confirma transação
        Commit;

        // Identifica procedimento como bem sucedido
        Result := 0;
      finally
        Param.Free;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(558, Self.ClassName, 'AdicionarGrauSangue', [E.Message]);
        Result := -558;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.RetirarGrauSangue(CodAssociacaoRaca: Integer;
  CodGrausSangue: String): Integer;
const
  sSelect: String =
    'select '+
    '  1 '+
    'from '+
    '  tab_assoc_raca_grau_sangue '+
    'where '+
    '  cod_grau_sangue = :cod_grau_sangue '+
    '  and cod_associacao_raca = :cod_associacao_raca ';
  sDelete: String =
    'delete from tab_assoc_raca_grau_sangue '+
    'where '+
    '  cod_grau_sangue = :cod_grau_sangue '+
    '  and cod_associacao_raca = :cod_associacao_raca ';
var
  Q : THerdomQuery;
  Param: TValoresParametro;
  X : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('RetirarGrauSangue');
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(222) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarGrauSangue', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------------
      // Verifica existencia de Associação Raça
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(471, Self.ClassName, 'RetirarGrauSangue', []);
        Result := -471;
        Exit;
      End;
      Q.Close;

      Param := TValoresParametro.Create(TValorParametro);
      try
        // Consistindo o "parâmetro" raças
        Result := VerificaParametroMultiValor(CodGrausSangue, Param);
        If Result < 0 Then Begin
          Exit;
        End;

        // Abre transação
        BeginTran;
        Q.Close;
        Q.SQL.Text := sSelect;
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.Close;
          Q.SQL.Text := sSelect;
          Q.ParamByName('cod_grau_sangue').AsInteger := Param.Items[X].Valor;
          Q.Open;
          if not Q.IsEmpty then begin
            Q.Close;
            Q.SQL.Text := sDelete;
            Q.ExecSQL;
          end;
        end;

        // Confirma transação
        Commit;

        // Identifica procedimento como bem sucedido
        Result := 0;
      finally
        Param.Free;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(560, Self.ClassName, 'RetirarGrauSangue', [E.Message]);
        Result := -560;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.PesquisarDoProdutor(IndAssociacaoRacaProdutor,CodOrdenacao: String) : Integer;
Const
  NomeMetodo : String = 'PesquisarDoProdutor';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(378) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select tar.cod_associacao_raca as CodAssociacaoRaca ');
  Query.SQL.Add('      , tar.sgl_associacao_raca as SglAssociacaoRaca ');
  Query.SQL.Add('      , tar.nom_associacao_raca as NomAssociacaoRaca ');
  Query.SQL.Add('      , case tpa.cod_pessoa_produtor ');
  Query.SQL.Add('        when null then ''N'' ');
  Query.SQL.Add('        else ''S'' ');
  Query.SQL.Add('        end as IndAssociacaoRacaProdutor ');
  Query.SQL.Add(' from tab_associacao_raca tar ');
  Query.SQL.Add('    , tab_produtor_associacao_raca tpa ');
  if IndAssociacaoRacaProdutor = 'S' then
     Query.SQL.Add(' where tar.cod_associacao_raca = tpa.cod_associacao_raca ')
  else if IndAssociacaoRacaProdutor = 'N' then begin
     Query.SQL.Add(' where tar.cod_associacao_raca *= tpa.cod_associacao_raca ');
     Query.SQL.Add('   and tar.cod_associacao_raca not in (select cod_associacao_raca ');
     Query.SQL.Add('               from tab_produtor_associacao_raca ');
     Query.SQL.Add('               where cod_pessoa_produtor=:cod_produtor) ');
  end
  else Query.SQL.Add(' where tar.cod_associacao_raca *= tpa.cod_associacao_raca ');

  Query.SQL.Add(' and tpa.cod_pessoa_produtor =:cod_produtor ');
  Query.SQL.Add(' and tar.dta_fim_validade is null ');

  if CodOrdenacao = 'C' then
     Query.SQL.Add(' order by tar.cod_associacao_raca ')
  else if CodOrdenacao = 'S' then
     Query.SQL.Add(' order by tar.sgl_associacao_raca ')
  else if CodOrdenacao = 'D' then
     Query.SQL.Add(' order by tar.des_associacao_raca ');
{$ENDIF}
  Query.ParamByName('cod_produtor').AsInteger         := Conexao.CodProdutorTrabalho;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(305, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -305;
      Exit;
    End;
  End;
end;

function TIntAssociacoesRaca.AdicionarAoProdutor(CodAssociacaoRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'AdicionarAoProdutor';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(379) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Produtor
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, []);
        Result := -170;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor_associacao_raca ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_associacao_raca = :cod_associacao_raca ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //------------------------
      // Tenta Inserir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_produtor_associacao_raca ');
      Q.SQL.Add(' ( cod_pessoa_produtor ');
      Q.SQL.Add(' , cod_associacao_raca ');
      Q.SQL.Add(' )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' ( :cod_pessoa_produtor ');
      Q.SQL.Add(' , :cod_associacao_raca ');
      Q.SQL.Add(' )');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
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
        Mensagens.Adicionar(694, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -694;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.RetirarDoProdutor(CodAssociacaoRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'RetirarDoProdutor';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(380) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Produtor
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, []);
        Result := -170;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor_associacao_raca ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_associacao_raca = :cod_associacao_raca ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
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
      Q.SQL.Add('delete from tab_produtor_associacao_raca ');
      Q.SQL.Add(' where cod_associacao_raca = :cod_associacao_raca ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
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
        Mensagens.Adicionar(695, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -695;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.PesquisarRelacionamento: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(223) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select targs.cod_associacao_raca as CodAssociacaoRaca ' );
  Query.SQL.Add('     , targs.cod_grau_sangue as CodGrauSangue ');
  Query.SQL.Add('  from tab_assoc_raca_grau_sangue targs ');
  Query.SQL.Add('     , tab_grau_sangue  tgs ');
  Query.SQL.Add('     , tab_associacao_raca  tar ');
  Query.SQL.Add(' where tar.cod_associacao_raca = targs.cod_associacao_raca ');
  Query.SQL.Add('   and tgs.cod_grau_sangue = targs.cod_grau_sangue ');
  Query.SQL.Add('   and tar.dta_fim_validade is null');
  Query.SQL.Add('   and tgs.dta_fim_validade is null');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(532, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -532;
      Exit;
    End;
  End;
end;

function TIntAssociacoesRaca.AdicionarRaca(CodAssociacaoRaca: Integer;
  CodRacas: String): Integer;
const
  Metodo: Integer = 419;
  NomeMetodo: String = 'AdicionarRaca';
var
  Q: THerdomQuery;
  Param: TValoresParametro;
  X: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consistindo associação
      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  1 '+
        'from '+
        '  tab_associacao_raca '+
        'where '+
        '  cod_associacao_raca = :cod_associacao_raca '+
        '  and dta_fim_validade is null ';
      Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(471, Self.ClassName, NomeMetodo, []);
        Result := -471;
        Exit;
      end;

      Param := TValoresParametro.Create(TValorParametro);
      try
        // Consistindo o "parâmetro" raças
        Result := VerificaParametroMultiValor(CodRacas, Param);
        If Result < 0 Then Begin
          Exit;
        End;

        // Consistindo raças
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  tr.des_raca as DesRaca '+
          '  , tarr.cod_associacao_raca as CodAssociacaoRaca '+
          'from '+
          '  tab_raca tr '+
          '  , tab_associacao_raca_raca tarr '+
          'where '+
          '  tr.cod_raca = :cod_raca '+
          '  and tr.dta_fim_validade is null '+
          '  and tr.cod_raca *= tarr.cod_raca '+
          '  and tarr.cod_associacao_raca = :cod_associacao_raca ';
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.Close;
          Q.ParamByName('cod_raca').AsInteger := Param.Items[X].Valor;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(1371, Self.ClassName, NomeMetodo, []);
            Result := -1371;
            Exit;
          end else if not Q.FieldByName('CodAssociacaoRaca').IsNull then begin
            Mensagens.Adicionar(1370, Self.ClassName, NomeMetodo, [Q.FieldByName('DesRaca').AsString]);
            Result := -1370;
            Exit;
          end;
        end;

        // Abre transação
        BeginTran;

        Q.Close;
        Q.SQL.Text :=
          'insert into tab_associacao_raca_raca '+
          ' (cod_associacao_raca '+
          '  , cod_raca) '+
          'values '+
          ' (:cod_associacao_raca '+
          '  , :cod_raca) ';
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.ParamByName('cod_raca').AsInteger := Param.Items[X].Valor;
          Q.ExecSQL;
        end;

        // Confirma transação
        Commit;

        // Identifica procedimento como bem sucedido
        Result := 0;
      finally
        Param.Free;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1367, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1367;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAssociacoesRaca.PesquisarRacas(CodAssociacaoRaca: Integer;
  IndAindaNaoRelacionados, CodOrdenacao: String): Integer;
const
  Metodo: Integer = 420;
  NomeMetodo: String = 'PesquisarRacas';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    {Montando query de pesquisa de acordo com os críterios informados}
    Query.SQL.Text :=
      'select '+
      '  tr.cod_raca as CodRaca '+
      '  , tr.sgl_raca as SglRaca '+
      '  , tr.des_raca as DesRaca '+
      'from '+
      '  tab_raca tr '+
      'where ';
{$IFDEF MSSQL}
    if IndAindaNaoRelacionados = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  not exists (select 1 from tab_associacao_raca_raca '+
        '               where cod_raca = tr.cod_raca '+
        '                 and cod_associacao_raca = :cod_associacao_raca ) ';
    end else begin
      Query.SQL.Text := Query.SQL.Text +
        '  exists (select 1 from tab_associacao_raca_raca '+
        '           where cod_raca = tr.cod_raca '+
        '             and cod_associacao_raca = :cod_associacao_raca ) ';
    end;
{$ENDIF}
    Query.SQL.Text := Query.SQL.Text +
      'order by ';
    if CodOrdenacao = 'C' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  CodRaca ';
    end else if CodOrdenacao = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  SglRaca ';
    end else if CodOrdenacao = 'D' then begin
      Query.SQL.Text := Query.SQL.Text +
        '  DesRaca ';
    end else begin
      Query.SQL.Text := Query.SQL.Text +
        '  DesRaca ';
    end;
    Query.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1368, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1368;
      Exit;
    End;
  End;
end;

function TIntAssociacoesRaca.RetirarRaca(CodAssociacaoRaca: Integer;
  CodRacas: String): Integer;
const
  Metodo: Integer = 421;
  NomeMetodo: String = 'RetirarRaca';
  sSelect: String =
    'select '+
    '  1 '+
    'from '+
    '  tab_associacao_raca_raca '+
    'where '+
    '  cod_raca = :cod_raca '+
    '  and cod_associacao_raca = :cod_associacao_raca ';
  sDelete: String =
    'delete from tab_associacao_raca_raca '+
    'where '+
    '  cod_raca = :cod_raca '+
    '  and cod_associacao_raca = :cod_associacao_raca ';
var
  Q: THerdomQuery;
  Param: TValoresParametro;
  X: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Param := TValoresParametro.Create(TValorParametro);
      try
        // Consistindo o "parâmetro" raças
        Result := VerificaParametroMultiValor(CodRacas, Param);
        If Result < 0 Then Begin
          Exit;
        End;

        // Abre transação
        BeginTran;

        Q.Close;
        Q.SQL.Text := sSelect;
        Q.ParamByName('cod_associacao_raca').AsInteger := CodAssociacaoRaca;
        for X := 0 to Param.Count-1 do begin
          Q.Close;
          Q.SQL.Text := sSelect;
          Q.ParamByName('cod_raca').AsInteger := Param.Items[X].Valor;
          Q.Open;
          if not Q.IsEmpty then begin
            Q.Close;
            Q.SQL.Text := sDelete;
            Q.ExecSQL;
          end;
        end;

        // Confirma transação
        Commit;

        // Identifica procedimento como bem sucedido
        Result := 0;
      finally
        Param.Free;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1369, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1369;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.

