// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Propriedades Rurais, Fazendas, etc - Definição das
// *                       classes.doc
// *  Código Classe      : 33
// *  Descrição Resumida : Cadastro de Lote
// ************************************************************************************************
// *  Últimas Alterações
// *   Hitalo    25/07/2002    Criação
// *   Hitalo    30/08/2002    Alteração no método Inserir - Incrementar o
// *                           Código Lote por CodPessoaProdutor. Alteração no Método excluir
// *                           Se faz referência com Animal não deixar excluir, independente  se
// *                           o animal estiver ativo ou não.
// ************************************************************************************************
unit uIntLotes;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntLote, dbtables, sysutils, db;

type
  { TIntLotes }
  TIntLotes = class(TIntClasseBDNavegacaoBasica)
  private
    FIntLote : TIntLote;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodFazenda: Integer; CodOrdenacao: String): Integer;
    function Inserir(CodFazenda: Integer;  SglLote,DesLote: String): Integer;
    function Alterar(CodFazenda, CodLote: Integer; SglLote,DesLote: String): Integer;
    function Excluir(CodFazenda, CodLote: Integer): Integer;
    function Buscar(CodFazenda, CodLote: Integer): Integer;

    property IntLote : TIntLote read FIntLote write FIntLote;
  end;

implementation

{ TIntLote }
constructor TIntLotes.Create;
begin
  inherited;
  FIntLote := TIntLote.Create;
end;

destructor TIntLotes.Destroy;
begin
  FIntLote.Free;
  inherited;
end;

function TIntLotes.Pesquisar(CodFazenda: Integer; CodOrdenacao: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(101) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Pesquisar', []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tl.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('       tl.cod_fazenda as CodFazenda, ');
  Query.SQL.Add('       tl.cod_lote as CodLote, ');
  Query.SQL.Add('       tl.sgl_lote as SglLote, ');
  Query.SQL.Add('       tl.des_lote as DesLote, ');
  Query.SQL.Add('       tf.sgl_fazenda as SglFazenda, ');
  Query.SQL.Add('       tf.nom_fazenda as NomFazenda ');
  Query.SQL.Add('  from tab_lote tl, ');
  Query.SQL.Add('       tab_fazenda tf ');
  Query.SQL.Add(' where tl.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tf.cod_pessoa_produtor = tl.cod_pessoa_produtor ');
  Query.SQL.Add('   and tf.cod_fazenda = tl.cod_fazenda ');
  Query.SQL.Add('   and tl.dta_fim_validade is null ');
  Query.SQL.Add('   and ((tl.cod_fazenda = :cod_fazenda) or (:cod_fazenda = -1)) ');
  If Uppercase(CodOrdenacao) = 'C' Then Begin
    Query.SQL.Add(' order by tl.cod_fazenda, tl.cod_lote ');
  End;
  If Uppercase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by tf.sgl_fazenda, tl.sgl_lote ');
  End;
  If Uppercase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by tf.sgl_fazenda, tl.des_lote ');
  End;
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_fazenda').AsInteger         := CodFazenda;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(363, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -363;
      Exit;
    End;
  End;
end;

function TIntLotes.Inserir(CodFazenda: Integer;  SglLote,DesLote: String): Integer;
var
  Q : THerdomQuery;
  CodLote, CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(102) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Inserir', []);
    Result := -307;
    Exit;
  End;

  // Trata sigla do lote
  Result := VerificaString(SglLote, 'Sigla do Lote');
  If Result < 0 Then Begin
    Exit;
  End;
//DRUZO 13/08/2009 --ALTERAÇÃO PARA AUMENTAR O TAMANHO DA STRING DE SIGLA
//ANTIGO ->  Result := TrataString(SglLote, 2, 'Sigla do Lote');
  Result := TrataString(SglLote, 5, 'Sigla do Lote');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do lote
  Result := VerificaString(DesLote, 'Descrição do Lote');
  If Result < 0 Then Begin
    Exit;
  End;
//DRUZO 13/08/2009 --ALTERAÇÃO PARA AUMENTAR O TAMANHO DA STRING DE DESCRICAO
//ANTIGO ->  Result := TrataString(DesLote, 30, 'Descrição do Lote');
  Result := TrataString(DesLote, 200, 'Descrição do Lote');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste Fazenda
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'Inserir', []);
        Result := -310;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and sgl_lote = :sgl_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_lote').AsString := SglLote;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(364, Self.ClassName, 'Inserir', [SglLote]);
        Result := -364;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and des_lote = :des_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('des_lote').AsString := DesLote;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(365, Self.ClassName, 'Inserir', [DesLote]);
        Result := -365;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_lote), 0) + 1 as cod_lote ');
      Q.SQL.Add('  from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      CodLote := Q.FieldByName('cod_lote').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;

      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_lote ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_lote, ');
      Q.SQL.Add('  sgl_lote, ');
      Q.SQL.Add('  des_lote, ');
      Q.SQL.Add('  cod_registro_log, ');
      Q.SQL.Add('  dta_fim_validade ,');
      Q.SQL.Add('  dta_cadastramento )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_fazenda, ');
      Q.SQL.Add('  :cod_lote, ');
      Q.SQL.Add('  :sgl_lote, ');
      Q.SQL.Add('  :des_lote, ');
      Q.SQL.Add('  :cod_registro_log, ');
      Q.SQL.Add('  null, ');
      Q.SQL.Add('  getdate()) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger            := CodLote;
      Q.ParamByName('sgl_lote').AsString             := SglLote;
      Q.ParamByName('des_lote').AsString             := DesLote;
      Q.ParamByName('cod_registro_log').AsInteger    := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_lote', CodRegistroLog, 1, 92);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodLote;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(366, Self.ClassName, 'Inserir', [E.Message]);
        Result := -366;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLotes.Alterar(CodFazenda, CodLote: Integer; SglLote,DesLote: String): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(103) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Alterar', []);
    Result := -307;
    Exit;
  End;
  //---------------------
  // Trata sigla do lote
  //---------------------
  Result := VerificaString(SglLote, 'Sigla do Lote');
  If Result < 0 Then Begin
    Exit;
  End;

//DRUZO 13/08/2009 --ALTERAÇÃO PARA AUMENTAR O TAMANHO DA STRING DE SIGLA
//ANTIGO ->  Result := TrataString(SglLote, 2, 'Sigla do Lote');
  Result := TrataString(SglLote, 5, 'Sigla do Lote');
  If Result < 0 Then Begin
    Exit;
  End;
  //-------------------------
  // Trata descrição do lote
  //-------------------------
  Result := VerificaString(DesLote, 'Descrição do Lote');
  If Result < 0 Then Begin
    Exit;
  End;
//DRUZO 13/08/2009 --ALTERAÇÃO PARA AUMENTAR O TAMANHO DA STRING DE DESCRICAO
//ANTIGO ->  Result := TrataString(DesLote, 30, 'Descrição do Lote');
  Result := TrataString(DesLote, 200, 'Descrição do Lote');

  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote = :cod_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(367, Self.ClassName, 'Alterar', []);
        Result := -367;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Consiste Fazenda
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'Alterar', []);
        Result := -310;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote != :cod_lote ');
      Q.SQL.Add('   and sgl_lote  = :sgl_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.ParamByName('sgl_lote').AsString := SglLote;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(364, Self.ClassName, 'Alterar', [SglLote]);
        Result := -364;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote != :cod_lote ');
      Q.SQL.Add('   and des_lote = :des_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.ParamByName('des_lote').AsString := DesLote;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(365, Self.ClassName, 'Alterar', [DesLote]);
        Result := -365;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_lote', CodRegistroLog, 2, 93);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_lote ');
      Q.SQL.Add('   set sgl_lote = :sgl_lote');
      Q.SQL.Add('     , des_lote = :des_lote');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote = :cod_lote ');
{$ENDIF}
      Q.ParamByName('sgl_lote').AsString      := SglLote;
      Q.ParamByName('des_lote').AsString      := DesLote;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_lote', CodRegistroLog, 3, 93);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(368, Self.ClassName, 'Alterar', [E.Message]);
        Result := -368;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLotes.Excluir(CodFazenda, CodLote: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(105) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Excluir', []);
    Result := -307;
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
      Q.SQL.Add('select cod_registro_log from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote = :cod_lote ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(367, Self.ClassName, 'Excluir', []);
        Result := -367; //Lote Inexistente
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;
       //-----------------------------------------
      // Verifica relacionamento com algum animal
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_fazenda_corrente = :cod_fazenda ' +
                '   and cod_lote_corrente = :cod_lote ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(370, Self.ClassName, 'Excluir', []);
        Result := -370;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_lote', CodRegistroLog, 5, 95);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_lote ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and cod_lote = :cod_lote ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger := CodLote;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(371, Self.ClassName, 'Excluir', [E.Message]);
        Result := -371;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLotes.Buscar(CodFazenda, CodLote: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(104) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Buscar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tl.cod_pessoa_produtor, ');
      Q.SQL.Add('       tl.cod_fazenda, ');
      Q.SQL.Add('       tl.cod_lote, ');
      Q.SQL.Add('       tl.sgl_lote, ');
      Q.SQL.Add('       tl.des_lote, ');
      Q.SQL.Add('       tf.sgl_fazenda, ');
      Q.SQL.Add('       tf.nom_fazenda, ');
      Q.SQL.Add('       tl.dta_cadastramento ');
      Q.SQL.Add('  from tab_lote tl, ');
      Q.SQL.Add('       tab_fazenda tf ');
      Q.SQL.Add(' where tf.cod_pessoa_produtor = tl.cod_pessoa_produtor ');
      Q.SQL.Add('   and tf.cod_fazenda = tl.cod_fazenda ');
      Q.SQL.Add('   and tl.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tl.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and tl.cod_lote = :cod_lote ');
      Q.SQL.Add('   and tl.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
      Q.ParamByName('cod_lote').AsInteger           := CodLote;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(367, Self.ClassName, 'Buscar', []);
        Result := -367;
        Exit;
      End;

      // Obtem informações do registro
      IntLote.CodPessoaProdutor   := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      IntLote.CodFazenda          := Q.FieldByName('cod_fazenda').AsInteger;
      IntLote.CodLote             := Q.FieldByName('cod_lote').AsInteger;
      IntLote.SglLote             := Q.FieldByName('sgl_lote').AsString;
      IntLote.DesLote             := Q.FieldByName('des_lote').AsString;
      IntLote.SglFazenda          := Q.FieldByName('sgl_fazenda').AsString;
      IntLote.NomFazenda          := Q.FieldByName('nom_fazenda').AsString;
      IntLote.DtaCadastramento    := Q.FieldByName('dta_cadastramento').AsDateTime;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(372, Self.ClassName, 'Buscar', [E.Message]);
        Result := -372;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
