unit uIntPaginas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntPaginas }
  TIntPaginas = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodGrupoPaginas, CodTipoPagina: Integer): Integer;
    function PesquisarDisponiveis(CodGrupoPaginas: Integer): Integer;
    function PesquisarDoGrupo(CodGrupoPaginas: Integer): Integer;
    function Alterar(CodPagina, CodGrupoPaginas: Integer): Integer;
  end;

implementation

{ TIntPaginas }

function TIntPaginas.Pesquisar(CodGrupoPaginas, CodTipoPagina: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(18) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pagina as CodPagina, ');
  Query.SQL.Add('       tp.des_pagina as DesPagina, ');
  Query.SQL.Add('	tp.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('       tgp.des_grupo_paginas as DesGrupoPaginas, ');
  Query.SQL.Add('       tp.cod_tipo_pagina as CodTipoPagina, ');
  Query.SQL.Add('       ttp.des_tipo_pagina as DesTipoPagina ');
  Query.SQL.Add(' from 	tab_pagina tp, ');
  Query.SQL.Add('       tab_grupo_paginas tgp, ');
  Query.SQL.Add('       tab_tipo_pagina ttp ');
  Query.SQL.Add(' where ((tp.cod_grupo_paginas = :cod_grupo_paginas) or (:cod_grupo_paginas = -1)) ');
  Query.SQL.Add('   and ((tp.cod_tipo_pagina   = :cod_tipo_pagina) or (:cod_tipo_pagina = -1)) ');
  Query.SQL.Add('   and tp.cod_grupo_paginas = tgp.cod_grupo_paginas ');
  Query.SQL.Add('   and tp.cod_tipo_pagina   = ttp.cod_tipo_pagina ');
  Query.SQL.Add('   order by ttp.des_tipo_pagina, tgp.des_grupo_paginas, tp.des_pagina ');
{$ENDIF}

  Try
    Query.ParamByName('cod_grupo_paginas').asInteger := CodGrupoPaginas;
    Query.ParamByName('cod_tipo_pagina').asInteger   := CodTipoPagina;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(120, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -120;
      Exit;
    End;
  End;
end;

function TIntPaginas.PesquisarDisponiveis(CodGrupoPaginas: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarDisponiveis');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(20) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarDisponiveis', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pagina as CodPagina, ');
  Query.SQL.Add('	tp.des_pagina as DesPagina, ');
  Query.SQL.Add('	tp.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('	tgp.des_grupo_paginas as DesGrupoPaginas, ');
  Query.SQL.Add('	tp.cod_tipo_pagina as CodTipoPagina, ');
  Query.SQL.Add('	ttp.des_tipo_pagina as DesTipoPagina ');
  Query.SQL.Add(' from tab_pagina tp, ');
  Query.SQL.Add('	tab_grupo_paginas tgp, ');
  Query.SQL.Add('	tab_grupo_paginas tgp1, ');
  Query.SQL.Add('	tab_tipo_pagina ttp ');
  Query.SQL.Add(' where tp.cod_grupo_paginas <> :cod_grupo_paginas ');
  Query.SQL.Add('  and tp.cod_grupo_paginas   = tgp.cod_grupo_paginas ');
  Query.SQL.Add('  and tp.cod_tipo_pagina     = ttp.cod_tipo_pagina ');
  Query.SQL.Add('  and tp.cod_tipo_pagina     = tgp1.cod_tipo_pagina ');
  Query.SQL.Add('  and tgp1.cod_grupo_paginas = :cod_grupo_paginas ');
  Query.SQL.Add('order by ttp.des_tipo_pagina, tgp.des_grupo_paginas, tp.des_pagina ');
{$ENDIF}

  Try
    Query.ParamByName('cod_grupo_paginas').asInteger := CodGrupoPaginas;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(128, Self.ClassName, 'PesquisarDisponiveis', [E.Message]);
      Result := -128;
      Exit;
    End;
  End;
end;

function TIntPaginas.PesquisarDoGrupo(CodGrupoPaginas: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarDoGrupo');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(21) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarDoGrupo', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pagina as CodPagina, ');
  Query.SQL.Add('	tp.des_pagina as DesPagina, ');
  Query.SQL.Add('	tp.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('	tgp.des_grupo_paginas as DesGrupoPaginas, ');
  Query.SQL.Add('	tp.cod_tipo_pagina as CodTipoPagina, ');
  Query.SQL.Add('	ttp.des_tipo_pagina as DesTipoPagina ');
  Query.SQL.Add(' from tab_pagina tp, ');
  Query.SQL.Add('	tab_grupo_paginas tgp, ');
  Query.SQL.Add('	tab_tipo_pagina ttp ');
  Query.SQL.Add(' where tp.cod_grupo_paginas  = :cod_grupo_paginas ');
  Query.SQL.Add('  and tp.cod_grupo_paginas   = tgp.cod_grupo_paginas ');
  Query.SQL.Add('  and tp.cod_tipo_pagina     = ttp.cod_tipo_pagina ');
  Query.SQL.Add('order by ttp.des_tipo_pagina, tgp.des_grupo_paginas, tp.des_pagina ');
{$ENDIF}

  Try
    Query.ParamByName('cod_grupo_paginas').asInteger := CodGrupoPaginas;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(129, Self.ClassName, 'PesquisarDoGrupo', [E.Message]);
      Result := -129;
      Exit;
    End;
  End;
end;

function TIntPaginas.Alterar(CodPagina: Integer; CodGrupoPaginas: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(19) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro Grupo Paginas
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

      // Verifica existencia do registro Pagina
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pagina ');
      Q.SQL.Add(' where cod_pagina = :cod_pagina ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(237, Self.ClassName, 'Alterar', [IntToStr(CodPagina)]);
        Result := -237;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pagina tp, ');
      Q.SQL.Add('      tab_grupo_paginas tgp ');
      Q.SQL.Add(' where tp.cod_pagina = :cod_pagina ');
      Q.SQL.Add('    and tgp.cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('    and tp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
{$ENDIF}
      Q.ParamByName('cod_pagina').AsInteger         := CodPagina;
      Q.ParamByName('cod_grupo_paginas').AsInteger  := CodGrupoPaginas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(133, Self.ClassName, 'Alterar', [IntToStr(CodPagina), IntToStr(CodGrupoPaginas)]);
        Result := -133;
        Exit;
      End;
      Q.Close;

      // Atualiza registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pagina ');
      Q.SQL.Add('  set cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('  where cod_pagina = :cod_pagina ');
{$ENDIF}

      Q.ParamByName('cod_grupo_paginas').AsInteger  := CodGrupoPaginas;
      Q.ParamByName('cod_pagina').AsInteger         := CodPagina;
      Q.ExecSQL;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(134, Self.ClassName, 'Alterar', [E.Message]);
        Result := -134;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
