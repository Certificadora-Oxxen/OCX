// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 47
// *  Descrição Resumida : Cadastro de Espécies
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uIntEspecies;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntAptidoes }
  TIntEspecies = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntespecies}
function TIntespecies.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(176) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_especie as CodEspecie ');
  Query.SQL.Add('     , sgl_especie as SglEspecie ');
  Query.SQL.Add('     , des_especie as DesEspecie ');
  Query.SQL.Add('     , cod_especie_sisbov as CodEspecieSisbov ');
  Query.SQL.Add('  from tab_especie ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_especie ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_especie ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_especie ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(491, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -491;
      Exit;
    End;
  End;
end;

end.
