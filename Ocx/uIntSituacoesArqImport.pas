// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 18/10/2004
// *  Documentação       :
// *  Código Classe      : 116
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntSituacoesArqImport;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntSituacoesArqImport }
  TIntSituacoesArqImport = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntSituacoesArqImport }

function TIntSituacoesArqImport.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 602;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Text := '  select ' +
                      '     cod_situacao_arq_import as CodSituacaoArqImport ' +
                      '   , des_situacao_arq_import as DesSituacaoArqImport ' +
                      '    from tab_situacao_arq_import '+
                      'order by ' +
                      '     des_situacao_arq_import ';
    Query.Open;
    Result := 1; 
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(1984, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1984;
      Exit;
    End;
  End;
end;

end.

