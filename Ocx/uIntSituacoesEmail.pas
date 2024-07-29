// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 20/09/2004
// *  Documentação       :
// *  Código Classe      : 110
// *  Descrição Resumida :
// *
// *                       
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// *
// ********************************************************************

unit uIntSituacoesEmail;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntSituacoesEmail }
  TIntSituacoesEmail = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;

implementation

{ TIntSituacoesEmail }

function TIntSituacoesEmail.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 590;
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
    Query.SQL.Text := ' select ' +
                      '    cod_situacao_email as CodSituacaoEmail ' +
                      '  , sgl_situacao_email as SglSituacaoEmail ' +
                      '  , des_situacao_email as DesSituacaoEmail ' +
                      '   from tab_situacao_email ' +
                      '  where ' +
                      '    (1 = 1) ' +
                      'order by ' +
                      '    des_situacao_email ';
    Query.Open;
    Result := 1;     
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(1951, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1951;
      Exit;
    End;
  End;
end;

end.
