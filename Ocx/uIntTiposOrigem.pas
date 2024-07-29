// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 22/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Tipo de Origem Animal - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    22/07/2002    Criação
// *
// *
// ********************************************************************

unit uIntTiposOrigem;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposOrigem }
  TIntTiposOrigem = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntTiposOrigem }
function TIntTiposOrigem.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(111) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_origem as CodTipoOrigem ');
  Query.SQL.Add('     , sgl_tipo_origem as SglTipoOrigem ');
  Query.SQL.Add('     , des_tipo_origem as DesTipoOrigem ');
  Query.SQL.Add('  from tab_tipo_origem ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_origem ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_origem ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_tipo_origem ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(320, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -320;
      Exit;
    End;
  End;
end;
end.

