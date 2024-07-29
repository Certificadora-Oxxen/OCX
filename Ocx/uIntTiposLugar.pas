// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 20/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 53
// *  Descrição Resumida : Cadastro de Tipos Lugar
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit uIntTiposLugar;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposLugar }
  TIntTiposLugar = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntTiposMorte}
function TIntTiposLugar.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(229) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_lugar as CodTipoLugar ');
  Query.SQL.Add('     , sgl_tipo_lugar as SglTipoLugar ');
  Query.SQL.Add('     , des_tipo_lugar as DesTipoLugar ');
  Query.SQL.Add('  from tab_tipo_lugar ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_lugar ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_lugar ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_tipo_lugar ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(611, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -611;
      Exit;
    End;
  End;
end;
end.
