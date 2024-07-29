// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 15/08/2002
// *  Documenta��o       : Atributos Animais - Defini��o das
// *                       classes.doc
// *  C�digo Classe      : 51
// *  Descri��o Resumida : Cadastro de Posic�o do Indentificador
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    15/08/2002    Cria��o
// *
// ********************************************************************
unit uIntPosicoesIdentificador;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInPosicoesIdentificador }
  TIntPosicoesIdentificador = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodGrupoIdentificador,CodOrdenacao: String) : Integer;
    function PesquisarRelacionamentos: Integer;
  end;

implementation

{ TIntPosicoesIdentificador}
function TIntPosicoesIdentificador.Pesquisar(CodGrupoIdentificador,CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usu�rio pode executar m�todo
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(195) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;

  Query.SQL.Clear;
  if trim(CodGrupoIdentificador) = '' then begin
  {$IFDEF MSSQL}
    Query.SQL.Add('select tpi.cod_posicao_identificador as CodPosicaoIdentificador, ');
    Query.SQL.Add('       tpi.sgl_posicao_identificador as SglPosicaoIdentificador, ');
    Query.SQL.Add('       tpi.des_posicao_identificador as DesPosicaoIdentificador, ');
    Query.SQL.Add('       tgpi.cod_grupo_identificador as CodGrupoIdentificador ');
    Query.SQL.Add('  from tab_posicao_identificador tpi, ');
    Query.SQL.Add('       tab_grupo_posicao_ident tgpi ');
    Query.SQL.Add(' where tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ');
    Query.SQL.Add('   and tpi.dta_fim_validade is null ');
    if CodOrdenacao = 'C' then
      Query.SQL.Add(' order by tgpi.cod_grupo_identificador, tpi.cod_posicao_identificador ')
    else if CodOrdenacao = 'S' then
      Query.SQL.Add(' order by tgpi.cod_grupo_identificador, tpi.sgl_posicao_identificador ')
    else if CodOrdenacao = 'D' then
      Query.SQL.Add(' order by tgpi.cod_grupo_identificador, tpi.des_posicao_identificador ');
{$ENDIF}
  end else begin
{$IFDEF MSSQL}
    Query.SQL.Add('select tpi.cod_posicao_identificador as CodPosicaoIdentificador ');
    Query.SQL.Add('     , tpi.sgl_posicao_identificador as SglPosicaoIdentificador ');
    Query.SQL.Add('     , tpi.des_posicao_identificador as DesPosicaoIdentificador ');
    Query.SQL.Add('     , ttpi.cod_grupo_identificador as CodGrupoIdentificador ');
    Query.SQL.Add('  from tab_posicao_identificador tpi ');
    Query.SQL.Add('     , tab_grupo_posicao_ident ttpi ');
    Query.SQL.Add('     , tab_grupo_identificador tgi ');
    Query.SQL.Add(' where ttpi.cod_grupo_identificador  = :cod_grupo_identificador ');
    Query.SQL.Add('   and tgi.cod_grupo_identificador  = ttpi.cod_grupo_identificador ');
    Query.SQL.Add('   and tgi.dta_fim_validade is null ');
    Query.SQL.Add('   and tpi.cod_posicao_identificador  = ttpi.cod_posicao_identificador ');
    Query.SQL.Add('   and tpi.dta_fim_validade is null ');
    if CodOrdenacao = 'C' then
      Query.SQL.Add(' order by ttpi.cod_grupo_identificador,tpi.cod_posicao_identificador ')
    else if CodOrdenacao = 'S' then
      Query.SQL.Add(' order by ttpi.cod_grupo_identificador,tpi.sgl_posicao_identificador ')
    else if CodOrdenacao = 'D' then
      Query.SQL.Add(' order by ttpi.cod_grupo_identificador,tpi.des_posicao_identificador ');
      Query.ParamByName('cod_grupo_identificador').asString := CodGrupoIdentificador;
{$ENDIF}
  end;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(531, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -531;
      Exit;
    End;
  End;
end;

function TIntPosicoesIdentificador.PesquisarRelacionamentos: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usu�rio pode executar m�todo
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(196) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select ttpi.cod_posicao_identificador as CodPosicaoIdentificador ');
  Query.SQL.Add('     , ttpi.cod_grupo_identificador as CodGrupoIdentificador ');
  Query.SQL.Add('  from tab_grupo_posicao_ident ttpi ');
  Query.SQL.Add('     , tab_posicao_identificador tpi ');
  Query.SQL.Add('     , tab_grupo_identificador tgi ');
  Query.SQL.Add(' where ttpi.cod_posicao_identificador =  tpi.cod_posicao_identificador ');
  Query.SQL.Add('   and ttpi.cod_grupo_identificador =  tgi.cod_grupo_identificador ');
  Query.SQL.Add('   and tpi.dta_fim_validade is null');
  Query.SQL.Add('   and tgi.dta_fim_validade is null');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(534, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -534;
      Exit;
    End;
  End;
end;
end.


