// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 22/09/2004
// *  Documentação       :
// *  Código Classe      : 111
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntSituacoesFTP;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntSituacoesFTP }
  TIntSituacoesFTP = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntTiposEmail }

function TIntSituacoesFTP.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 592;
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
                      '    cod_situacao_arquivo_ftp as CodSituacaoArquivoFTP ' +
                      '  , sgl_situacao_arquivo_ftp as SglSituacaoArquivoFTP ' +
                      '  , des_situacao_arquivo_ftp as DesSituacaoArquivoFTP ' +
                      '   from tab_situacao_arquivo_ftp '+
                      '  where ' +
                      '    (1 = 1) ' +
                      'order by ' +
                      '    cod_situacao_arquivo_ftp ';
    Query.Open;
    Result := 1; 
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(1952, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1952;
      Exit;
    End;
  End;
end;

end.

