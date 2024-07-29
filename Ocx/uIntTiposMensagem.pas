// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Vers�o             : 2.0
// *  Data               : 29/09/2004
// *  Documenta��o       :
// *  C�digo Classe      : 112
// *  Descri��o Resumida :
// *
// *
// ************************************************************************
// *  �ltimas Altera��es :
// *
// *
// ********************************************************************
unit uIntTiposMensagem;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntTiposMensagem }
  TIntTiposMensagem = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntTiposMensagem }

function TIntTiposMensagem.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 593;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Text := ' select ' +
                      '    cod_tipo_mensagem as CodTipoMensagem ' +
                      '  , des_tipo_mensagem as DesTipoMensagem ' +
                      '   from tab_tipo_mensagem '+
                      '  where ' +
                      '    (1 = 1) ' +
                      'order by ' +
                      '    des_tipo_mensagem ';
    Query.Open;
    Result := 1; 
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(1963, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1963;
      Exit;
    End;
  End;
end;

end.

