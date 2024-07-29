// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Banner
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Cadastro de Anuniciantes
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *   Hitalo    17/07/2002  Adicionar TrataString nos Métodos Inserir
// *                         ,Alterar e Pesquisar
// *
// *
// ********************************************************************

unit uIntGruposPaginas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntGrupoPaginas, dbtables, sysutils, db;

type
  TIntGruposPaginas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntGrupoPaginas : TIntGrupoPaginas;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(DesGrupoPaginas: String; CodTipoPagina: Integer;IndPesquisarDesativos : boolean): Integer;
    function Inserir(DesGrupoPaginas: String; CodTipoPagina: Integer): Integer;
    function Alterar(CodGrupoPaginas: Integer; DesGrupoPaginas: String): Integer;
    function Excluir(CodGrupoPaginas: Integer): Integer;
    function TipoPagina(CodGrupoPaginas: Integer): Integer;
    function Buscar(CodGrupoPaginas: Integer): Integer;

    property IntGrupoPaginas : TIntGrupoPaginas read FIntGrupoPaginas write FIntGrupoPaginas;
  end;

implementation

constructor TIntGruposPaginas.Create;
begin
  inherited;
  FIntGrupoPaginas := TIntGrupoPaginas.Create;
end;

destructor TIntGruposPaginas.Destroy;
begin
  FIntGrupoPaginas.Free;
  inherited;
end;

function TIntGruposPaginas.Pesquisar(DesGrupoPaginas: String;
  CodTipoPagina: Integer;IndPesquisarDesativos : boolean): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(10) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tgp.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('       tgp.des_grupo_paginas as DesGrupoPaginas, ');
  Query.SQL.Add('       ttp.cod_tipo_pagina as CodTipoPagina, ');
  Query.SQL.Add('       ttp.des_tipo_pagina as DesTipoPagina, ');
  Query.SQL.Add('       tgp.dta_fim_validade as dtaFimValidade');
  Query.SQL.Add('  from tab_grupo_paginas tgp, ');
  Query.SQL.Add('       tab_tipo_pagina ttp ');
  Query.SQL.Add(' where ttp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
//Hitalo  Query.SQL.Add('   and tgp.dta_fim_validade is null ');
  Query.SQL.Add('   and ((tgp.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ');

  If DesGrupoPaginas <> '' Then Begin
    Query.SQL.Add('   and tgp.des_grupo_paginas like :des_grupo_paginas  ');
  End;
  Query.SQL.Add('   and ((tgp.cod_tipo_pagina = :cod_tipo_pagina) or (:cod_tipo_pagina = -1)) ');
  Query.SQL.Add('    order by des_grupo_paginas');

{$ENDIF}

  If DesGrupoPaginas <> '' Then Begin
    Query.ParamByName('des_grupo_paginas').AsString      := '%' + DesGrupoPaginas + '%';
  End;
  Query.ParamByName('cod_tipo_pagina').AsInteger := CodTipoPagina;

  If IndPesquisarDesativos Then Begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 1;
  End Else Begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 0;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(121,Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -121;
      Exit;
    End;
  End;
end;

function TIntGruposPaginas.Inserir(DesGrupoPaginas: String;
  CodTipoPagina: Integer): Integer;
var
  Q : THerdomQuery;
  CodGrupoPaginas : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(11) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  // Verifica o parametro DesGrupoPaginas
  If DesGrupoPaginas = '' Then Begin
    Mensagens.Adicionar(236, Self.ClassName, 'Inserir', []);
    Result := -236;
    Exit;
  End;
  
  //-----------------------------------------
  //Trata a variavel Descrição Grupo paginas
  //-----------------------------------------
  result := TrataString(DesGrupoPaginas,30,'Descrição Grupo Páginas');

  if result < 0 then
    exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grupo_paginas ');
      Q.SQL.Add(' where des_grupo_paginas = :des_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade  is null ');
{$ENDIF}
      Q.ParamByName('des_grupo_paginas').AsString := DesGrupoPaginas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(127, Self.ClassName, 'Inserir', [DesGrupoPaginas]);
        Result := -127;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_grupo_paginas), 0) + 1 as cod_grupo_paginas from tab_grupo_paginas');
{$ENDIF}
      Q.Open;
      CodGrupoPaginas := Q.FieldByName('cod_grupo_paginas').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_grupo_paginas ');
      Q.SQL.Add(' (cod_grupo_paginas, ');
      Q.SQL.Add('  des_grupo_paginas, ');
      Q.SQL.Add('  cod_tipo_pagina, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_grupo_paginas, ');
      Q.SQL.Add('  :des_grupo_paginas, ');
      Q.SQL.Add('  :cod_tipo_pagina, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('des_grupo_paginas').AsString  := DesGrupoPaginas;
      Q.ParamByName('cod_tipo_pagina').AsInteger   := CodTipoPagina;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do banner criado
      Result := CodGrupoPaginas;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(122, Self.ClassName, 'Inserir', [E.Message]);
        Result := -122;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGruposPaginas.Alterar(CodGrupoPaginas: Integer;
  DesGrupoPaginas: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(12) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica o parametro DesGrupoPaginas
  If DesGrupoPaginas = '' Then Begin
    Mensagens.Adicionar(236, Self.ClassName, 'Alterar', []);
    Result := -236;
    Exit;
  End;

  //-----------------------------------------
  //Trata a variavel Descrição Grupo paginas
  //-----------------------------------------
  result := TrataString(DesGrupoPaginas,30,'Descrição Grupo Páginas');

  if result < 0 then
    exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------------------------------
      // Verifica existencia de duplicidade do registro
      //------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grupo_paginas ');
      Q.SQL.Add(' where des_grupo_paginas  = :des_grupo_paginas ');
      Q.SQL.Add('   and cod_grupo_paginas != :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade  is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('des_grupo_paginas').AsString  := DesGrupoPaginas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(127, Self.ClassName, 'Alterar', [IntToStr(CodGrupoPaginas)]);
        Result := -127;
        Exit;
      End;
      Q.Close;

      //---------------------------------
      // Verifica existencia do registro
      // para atualização
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grupo_paginas ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(126, Self.ClassName, 'Alterar', [IntToStr(CodGrupoPaginas)]);
        Result := -126;
        Exit;
      End;
      Q.Close;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_grupo_paginas ');
      Q.SQL.Add('   set des_grupo_paginas = :des_grupo_paginas ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger     := CodGrupoPaginas;
      Q.ParamByName('des_grupo_paginas').AsString      := DesGrupoPaginas;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(123, Self.ClassName, 'Alterar', [E.Message]);
        Result := -123;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGruposPaginas.Excluir(CodGrupoPaginas: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(13) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grupo_paginas ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(126, Self.ClassName, 'Excluir', [IntToStr(CodGrupoPaginas)]);
        Result := -126;
        Exit;
      End;
      Q.Close;

      // Consiste se há programação para o anúncio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_anuncio >= getdate() ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(130, Self.ClassName, 'Excluir', [IntToStr(CodGrupoPaginas)]);
        Result := -130;
        Exit;
      End;
      Q.Close;

      // Consiste se existe página neste grupo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pagina ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(131, Self.ClassName, 'Excluir', [IntToStr(CodGrupoPaginas)]);
        Result := -131;
        Exit;
      End;
      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_grupo_paginas ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger      := CodGrupoPaginas;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(124, Self.ClassName, 'Excluir', [E.Message]);
        Result := -124;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGruposPaginas.TipoPagina(CodGrupoPaginas: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('TipoPagina');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(14) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'TipoPagina', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Obter tipo de página
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tipo_pagina ');
      Q.SQL.Add('  from tab_grupo_paginas ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(126, Self.ClassName, 'TipoPagina', [IntToStr(CodGrupoPaginas)]);
        Result := -126;
        Exit;
      End;

      // Obtem informações do registro
      Result := Q.FieldByName('cod_tipo_pagina').AsInteger;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(132, Self.ClassName, 'TipoPagina', [E.Message, IntToStr(CodGrupoPaginas)]);
        Result := -132;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntGruposPaginas.Buscar(CodGrupoPaginas: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(15) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_grupo_paginas, ');
      Q.SQL.Add('       des_grupo_paginas, ');
      Q.SQL.Add('       cod_tipo_pagina  , ');
      Q.SQL.Add('       dta_fim_validade   ');
      Q.SQL.Add('  from tab_grupo_paginas  ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
//Hitalo      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(126, Self.ClassName, 'Buscar', [IntToStr(CodGrupoPaginas)]);
        Result := -126;
        Exit;
      End;

      // Obtem informações do registro
      IntGrupoPaginas.Codigo           := Q.FieldByName('cod_grupo_paginas').AsInteger;
      IntGrupoPaginas.DesGrupoPaginas  := Q.FieldByName('des_grupo_paginas').AsString;
      IntGrupoPaginas.CodTipoPagina    := Q.FieldByName('cod_tipo_pagina').AsInteger;
      IntGrupoPaginas.DtaFimValidade   := Q.FieldByName('dta_fim_validade').AsDateTime;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(125, Self.ClassName, 'Excluir', [E.Message]);
        Result := -125;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
