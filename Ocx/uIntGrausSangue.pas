// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 21/08/2002
// *  Documentação       : Atributos de Animais - Especificação das Classe.doc// *  Código Classe      : 38
// *  Descrição Resumida : Cadastro de Grau de Sangue
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    21/08/2002    Criação
// *   Carlos    02/12/2002    Alterações nos campos sglgrausangue e desgrausangue
// *   Canival   23/12/2002  Adicionar métodos PesquisarRelacionamentosParaProdutor,
// *                         PesquisarDoProdutor
// *
// ********************************************************************
unit uIntGrausSangue;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntGrauSangue;

type
  { TIntGrausSangue }
  TIntGrausSangue = class(TIntClasseBDNavegacaoBasica)
  private
    FIntGrauSangue : TIntGrauSangue;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodAssociacaoRaca: Integer;IndAindaNaoRelacionados,CodOrdenacao: String): Integer;
    function Alterar(CodGrauSangue : Integer;SglGrauSangue,DesGrauSangue : String): Integer;
    function Inserir(SglGrauSangue,DesGrauSangue : String): Integer;
    function Excluir(CodGrauSangue : Integer): Integer;
    function Buscar(CodGrauSangue : Integer): Integer;
    function PesquisarRelacionamentos : Integer;
    function PesquisarDoProdutor(CodOrdenacao: String): Integer;
    function PesquisarRelacionamentoParaProdutor: Integer;

    property IntGrauSangue : TIntGrauSangue read FIntGrauSangue write FIntGrauSangue;
  end;

implementation

{ TIntGrausSangue}
constructor TIntGrausSangue.Create;
begin
  inherited;
  FIntGrauSangue := TIntGrauSangue.Create;
end;

destructor TIntGrausSangue.Destroy;
begin
  FIntGrauSangue.Free;
  inherited;
end;

function TIntGrausSangue.Pesquisar(CodAssociacaoRaca: Integer;IndAindaNaoRelacionados,CodOrdenacao: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(114) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;

{$IFDEF MSSQL}
  if CodAssociacaoRaca = -1 then begin
    Query.SQL.Add('select cod_grau_sangue as CodGrauSangue, ');
    Query.SQL.Add('       sgl_grau_sangue as SglGrauSangue, ');
    Query.SQL.Add('       des_grau_sangue as DesGrauSangue ');
    Query.SQL.Add('  from tab_grau_sangue ');
    Query.SQL.Add(' where dta_fim_validade is null ');
  end
  else begin
    Query.SQL.Add('select cod_grau_sangue as CodGrauSangue, ');
    Query.SQL.Add('       sgl_grau_sangue as SglGrauSangue, ');
    Query.SQL.Add('       des_grau_sangue as DesGrauSangue ');
    Query.SQL.Add('  from tab_grau_sangue tgs ');
    Query.SQL.Add(' where tgs.dta_fim_validade is null ');
    if IndAindaNaoRelacionados = 'S' then begin
      Query.SQL.Add('   and  ');
    end else begin
      Query.SQL.Add('   and not ');
    end;
    Query.SQL.Add('    exists (select 1 from tab_assoc_raca_grau_sangue targs');
    Query.SQL.Add('               where targs.cod_grau_sangue =tgs.cod_grau_sangue ');
    Query.SQL.Add('               and targs.cod_associacao_raca = :cod_associacao_raca )');
  end;
  if CodAssociacaoRaca <> -1 then begin
    Query.ParamByName('cod_associacao_raca').asInteger := CodAssociacaoRaca;
  end;

  If UpperCase(CodOrdenacao) = 'C' Then Begin
    Query.SQL.Add(' order by cod_grau_sangue ');
  End;
  If UpperCase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by sgl_grau_sangue ');
  End;
  If UpperCase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by des_grau_sangue ');
  End;

{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(356, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -356;
      Exit;
    End;
  End;
end;

function TIntGrausSangue.PesquisarRelacionamentos : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarRelacionamentos');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(113) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarRelacionamentos', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select targs.cod_associacao_raca as CodAssociacaoRaca ');
  Query.SQL.Add('     , targs.cod_grau_sangue as CodGrauSangue ');
  Query.SQL.Add('  from tab_grau_sangue tgs, ');
  Query.SQL.Add('       tab_associacao_raca tar, ');
  Query.SQL.Add('       tab_assoc_raca_grau_sangue targs ');
  Query.SQL.Add(' where tar.cod_associacao_raca = targs.cod_associacao_raca ');
  Query.SQL.Add('   and tar.dta_fim_validade is null ');
  Query.SQL.Add('   and tgs.cod_grau_sangue = targs.cod_grau_sangue ');
  Query.SQL.Add('   and tgs.dta_fim_validade is null ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(436, Self.ClassName, 'PesquisarRelacionamentos', [E.Message]);
      Result := -436;
      Exit;
    End;
  End;
end;

function TIntGrausSangue.Inserir(SglGrauSangue,DesGrauSangue : String): Integer;
var
  Q : THerdomQuery;
  CodGrauSangue : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(224) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglGrauSangue, 'Sigla do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglGrauSangue, 5, 'Sigla do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesGrauSangue, 'Descrição do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesGrauSangue, 40, 'Descrição do Grau Sangue');
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
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  sgl_grau_sangue = :sgl_grau_sangue');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_grau_sangue').AsString := SglGrauSangue;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(573, Self.ClassName, 'Inserir', [SglGrauSangue]);
        Result := -573;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  des_grau_sangue = :des_grau_sangue ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_grau_sangue').AsString := DesGrauSangue;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(572, Self.ClassName, 'Inserir', [DesGrauSangue]);
        Result := -572;
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
      Q.SQL.Add('select isnull(max(cod_grau_sangue), 0) + 1 as cod_grau_sangue ');
      Q.SQL.Add('  from tab_grau_sangue');
{$ENDIF}
      Q.Open;
      CodGrauSangue := Q.FieldByName('cod_grau_sangue').AsInteger;
      //-------------------------
      // Tenta Inserir Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_grau_sangue ');
      Q.SQL.Add(' (cod_grau_sangue, ');
      Q.SQL.Add('  sgl_grau_sangue, ');
      Q.SQL.Add('  des_grau_sangue, ');
      Q.SQL.Add('  dta_fim_validade )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_grau_sangue, ');
      Q.SQL.Add('  :sgl_grau_sangue, ');
      Q.SQL.Add('  :des_grau_sangue, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger            := CodGrauSangue;
      Q.ParamByName('sgl_grau_sangue').AsString             := SglGrauSangue;
      Q.ParamByName('des_grau_sangue').AsString             := DesGrauSangue;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := codGrauSangue;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(574, Self.ClassName, 'Inserir', [E.Message]);
        Result := -574;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGrausSangue.Alterar(CodGrauSangue : Integer;SglGrauSangue,DesGrauSangue : String): Integer;
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
  If Not Conexao.PodeExecutarMetodo(225) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglGrauSangue, 'Sigla do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglGrauSangue, 5, 'Sigla do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesGrauSangue, 'Descrição do Grau Sangue');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesGrauSangue, 40, 'Descrição do Grau Sangue');
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
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  sgl_grau_sangue = :sgl_grau_sangue');
      Q.SQL.Add('   and  cod_grau_sangue != :cod_grau_sangue');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_grau_sangue').AsString  := SglGrauSangue;
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(573, Self.ClassName, 'Alterar', [SglGrauSangue]);
        Result := -573;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  des_grau_sangue = :des_grau_sangue ');
      Q.SQL.Add('   and  cod_grau_sangue != :cod_grau_sangue');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_grau_sangue').AsString := DesGrauSangue;
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(572, Self.ClassName, 'Alterar', [DesGrauSangue]);
        Result := -572;
        Exit;
      End;
      Q.Close;

      //--------------------------------------------
      // Verifica a existência do Codigo Grau sangue
      //--------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  cod_grau_sangue = :cod_grau_sangue');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(556, Self.ClassName, 'Alterar', [IntToStr(CodGrauSangue)]);
        Result := -556;
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
      Q.SQL.Add('update tab_grau_sangue ');
      Q.SQL.Add('   set sgl_grau_sangue = :sgl_grau_sangue');
      Q.SQL.Add('     , des_grau_sangue = :des_grau_sangue');
      Q.SQL.Add(' where cod_grau_sangue = :cod_grau_sangue ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.ParamByName('sgl_grau_sangue').AsString  := SglGrauSangue;
      Q.ParamByName('des_grau_sangue').AsString  := DesGrauSangue;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(576, Self.ClassName, 'Alterar', [E.Message]);
        Result := -576;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGrausSangue.Excluir(CodGrauSangue : Integer): Integer;
var
  Q : THerdomQuery;
  STipoExclusao : String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(226) Then Begin
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
      Q.SQL.Add('select 1 from tab_grau_sangue ');
      Q.SQL.Add(' where  cod_grau_sangue = :cod_grau_sangue ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(556, Self.ClassName, 'Excluir', [IntToStr(CodGrauSangue)]);
        Result := -556;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica o relacionamento com Grau Sangue
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_assoc_raca_grau_sangue tRel ');
      Q.SQL.Add('     , tab_associacao_raca tar ');
      Q.SQL.Add(' where  trel.cod_grau_sangue = :cod_grau_sangue ');
      Q.SQL.Add('   and  tar.cod_associacao_raca = tRel.cod_associacao_raca ');
      Q.SQL.Add('   and  tar.dta_fim_validade is  null ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(685, Self.ClassName, 'Excluir', [IntToStr(CodGrauSangue)]);
        Result := -685;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica o relacionamento com Grau Sangue
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_assoc_raca_grau_sangue ');
      Q.SQL.Add('     , tab_associacao_raca ');
      Q.SQL.Add(' where  cod_grau_sangue = :cod_grau_sangue ');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
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
        Q.SQL.Add('update tab_grau_sangue ');
        Q.SQL.Add('   set dta_fim_validade = getdate() ');
        Q.SQL.Add(' where cod_grau_sangue = :cod_grau_sangue ');
  {$ENDIF}
      end
      else begin
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_grau_sangue ');
        Q.SQL.Add(' where cod_grau_sangue = :cod_grau_sangue');
  {$ENDIF}
      end;
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(578, Self.ClassName, 'Excluir', [E.Message]);
        Result := -578;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGrausSangue.Buscar(CodGrauSangue : Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(227) Then Begin
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
      Q.SQL.Add('select cod_grau_sangue ');
      Q.SQL.Add('     , sgl_grau_sangue ');
      Q.SQL.Add('     , des_grau_sangue ');
      Q.SQL.Add('  from tab_grau_sangue ');
      Q.SQL.Add(' where cod_grau_sangue = :cod_grau_sangue');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_grau_sangue').AsInteger := CodGrauSangue;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(556, Self.ClassName, 'Buscar', []);
        Result := -556;
        Exit;
      End;
      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      IntGrauSangue.CodGrauSangue  := Q.FieldByName('cod_grau_sangue').AsInteger;
      IntGrauSangue.SglGrauSangue  := Q.FieldByName('sgl_grau_sangue').AsString;
      IntGrauSangue.DesGrauSangue  := Q.FieldByName('des_grau_sangue').AsString;

      Q.close;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(581, Self.ClassName, 'Buscar', [E.Message]);
        Result := -581;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGrausSangue.PesquisarDoProdutor(CodOrdenacao: String): Integer;
Const
  NomeMetodo : String = 'PesquisarDoProdutor';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(381) Then Begin
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
  Query.SQL.Add('select distinct tgs.cod_grau_sangue as CodGrauSangue ');
  Query.SQL.Add('     , tgs.Sgl_grau_sangue as SglGrauSangue ');
  Query.SQL.Add('     , tgs.Des_grau_sangue as DesGrauSangue ');
  Query.SQL.Add('  from tab_grau_sangue tgs, ');
  Query.SQL.Add('       tab_associacao_raca tar, ');
  Query.SQL.Add('       tab_assoc_raca_grau_sangue targs, ');
  Query.SQL.Add('       tab_produtor_associacao_raca tpa ');
  Query.SQL.Add(' where tar.cod_associacao_raca = targs.cod_associacao_raca ');
  Query.SQL.Add('   and tar.dta_fim_validade is null ');
  Query.SQL.Add('   and tgs.cod_grau_sangue = targs.cod_grau_sangue ');
  Query.SQL.Add('   and tgs.dta_fim_validade is null ');
  Query.SQL.Add('   and tar.cod_associacao_raca = tpa.cod_associacao_raca ');
  Query.SQL.Add('   and tpa.cod_pessoa_produtor = :cod_produtor ');

  if CodOrdenacao = 'C' then
     Query.SQL.Add(' order by tgs.cod_grau_sangue ')
  else if CodOrdenacao = 'S' then
     Query.SQL.Add(' order by tgs.sgl_grau_sangue ')
  else if CodOrdenacao = 'D' then
     Query.SQL.Add(' order by tgs.des_grau_sangue ');
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

function TIntGrausSangue.PesquisarRelacionamentoParaProdutor: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarRelacionamentoParaProdutor');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(389) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarRelacionamentoParaProdutor', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tpa.cod_associacao_raca as CodAssociacaoRaca, ');
  Query.SQL.Add('     tgs.cod_grau_sangue     as CodGrauSangue ');
  Query.SQL.Add('  from tab_associacao_raca tar, ');
  Query.SQL.Add('       tab_grau_sangue tgs, ');
  Query.SQL.Add('       tab_assoc_raca_grau_sangue targs, ');
  Query.SQL.Add('       tab_produtor_associacao_raca tpa ');
  Query.SQL.Add(' where tpa.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tar.cod_associacao_raca = tpa.cod_associacao_raca ');
  Query.SQL.Add('   and tar.cod_associacao_raca = targs.cod_associacao_raca ');
  Query.SQL.Add('   and targs.cod_grau_sangue   = tgs.cod_grau_sangue ');
  Query.SQL.Add('   and tar.dta_fim_validade is null ');
{$ENDIF}
  Try
    Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(436, Self.ClassName, 'PesquisarRelacionamentoParaProdutor', [E.Message]);
      Result := -436;
      Exit;
    End;
  End;
end;
end.

