// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 31
// *  Descrição Resumida : Cadastro de Tipos de Fonte Agua - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    24/07/2002    Criação
// *
// *
// ********************************************************************
unit uIntTiposFonteAgua;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInTiposFonteAgua }
  TIntTiposFonteAgua = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntTiposFonteAgua}
function TIntTiposFonteAgua.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(90) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_fonte_agua as CodTipoFonteAgua ');
  Query.SQL.Add('     , sgl_tipo_fonte_agua as SglTipoFonteAgua ');
  Query.SQL.Add('     , des_tipo_fonte_agua as DesTipoFonteAgua ');
  Query.SQL.Add('  from tab_tipo_fonte_agua ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_fonte_agua ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_fonte_agua ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by Des_tipo_fonte_agua ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(358, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -358;
      Exit;
    End;
  End;
end;
end.


