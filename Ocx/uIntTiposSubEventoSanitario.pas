// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 08/11/2002
// *  Documentação       : Eventos de Movimentação - Definição das classes.doc
// *  Código Classe      : 71
// *  Descrição Resumida : Pesquisa de Tipos de Sub Eventos Sanitários
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    08/11/2002    Criação
// *
// ********************************************************************
unit uIntTiposSubEventoSanitario;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposSubEventoSanitario }
  TIntTiposSubEventoSanitario = class(TIntClasseBDNavegacaoBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntTiposSubEventoSanitario }
function TIntTiposSubEventoSanitario.Pesquisar(CodOrdenacao: String) : Integer;
Const
  NomeMetodo : String  = 'Pesquisar';
  CodMetodo  : Integer = 346;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_sub_evento_sanitario as CodTipoSubEventoSanitario ');
  Query.SQL.Add('     , sgl_tipo_sub_evento_sanitario as SglTipoSubEventoSanitario ');
  Query.SQL.Add('     , Des_tipo_sub_evento_sanitario as DesTipoSubEventoSanitario ');
  Query.SQL.Add('  from tab_tipo_sub_evento_sanitario ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_sub_evento_sanitario ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_sub_evento_sanitario ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_tipo_sub_evento_sanitario ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1115, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1115;
      Exit;
    End;
  End;
end;

end.
