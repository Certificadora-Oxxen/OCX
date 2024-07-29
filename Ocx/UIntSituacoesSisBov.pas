// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 22/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 54
// *  Descrição Resumida : Cadastro de Situacoes SisBov
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit UIntSituacoesSisBov;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposLugar }
  TIntSituacoesSisBov = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar : Integer;
  end;

implementation

{ TIntTiposMorte}
function TIntSituacoesSisBov.Pesquisar : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(230) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_situacao_sisbov as CodSituacaoSisBov ');
  Query.SQL.Add('     , des_situacao_sisbov as DesSituacaoSisBov ');
  Query.SQL.Add('     , txt_situacao_sisbov as TxtSituacaoSisBov ');
  Query.SQL.Add('  from tab_situacao_sisbov ');
  Query.SQL.Add(' order by num_ordem ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(610, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -610;
      Exit;
    End;
  End;
end;
end.
