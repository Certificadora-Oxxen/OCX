// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 20/09/2004
// *  Documentação       :
// *  Código Classe      : 109
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntTiposEmail;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntTiposEmail }
  TIntTiposEmail = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntTiposEmail }

function TIntTiposEmail.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 589;
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
                      '    cod_tipo_email as CodTipoEmail ' +
                      '  , des_tipo_email as DesTipoEmail ' +
                      '  , cod_tipo_destinatario_admin as CodTipoDestinatarioAdmin ' +
                      '   from tab_tipo_email '+
                      '  where ' +
                      '    (1 = 1) ' +
                      'order by ' +
                      '    des_tipo_email ';
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
