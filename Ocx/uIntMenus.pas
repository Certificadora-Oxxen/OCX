// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.3
// *  Data               : 03/12/2004
// *  Documentação       : Controle de Acesso - Definição de classes.doc
// *  Descrição Resumida : Consulta tabela tab_menu para montagem do menu
//                         do sistema
// *  Código da Classe   : 117
// ********************************************************************
// *  Últimas Alterações
// *   Daniel    03/12/2004    Criação
// *
// *
// ********************************************************************

unit uIntMenus;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntMenus }
  TIntMenus = class(TIntClasseBDNavegacaoBasica)
  public
    function Pesquisar(CodPapel: Integer) : Integer;
  end;

implementation

{ TIntMenus }

function TIntMenus.Pesquisar(CodPapel: Integer): Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 614;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Result := -1;
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(46) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select cod_papel as CodPapel                ');
  Query.SQL.Add('      , cod_menu as CodMenu                  ');
  Query.SQL.Add('      , txt_titulo as TxtTitulo              ');
  Query.SQL.Add('      , cod_item_menu_raiz as CodItemMenuRaiz');
  Query.SQL.Add('   from tab_menu ');

  if CodPapel > 0 then begin
    Query.SQL.Add('where cod_papel = :cod_papel');
  end;

  Query.SQL.Add('  order by num_ordem ');  

{$ENDIF}

  if CodPapel > 0 then begin
    Query.ParamByName('cod_papel').AsInteger := CodPapel;
  end;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2071, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2071;
      Exit;
    End;
  End;
end;

end.
