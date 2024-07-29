// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Vers�o             : 1
// *  Data               : 03/08/2004
// *  Documenta��o       : Atributos de Ordem de Servi�o - Defini��o das Classes.doc
// *  C�digo Classe      : 101
// *  Descri��o Resumida : Pesquisa por todos os acess�rios de um determinado fabricante
// *                       de identificadores
// ************************************************************************
// *  �ltimas Altera��es :
// *
// ************************************************************************
unit uIntProdutosAcessorios;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntProdutosAcessorios }
  TIntProdutosAcessorios = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodFabricanteIdentificador :Integer): Integer;
  end;

implementation

{ TIntProdutosAcessorios }
//Adalberto
//Pesquisa por todos os acess�rios de um determinado fabricante de identificadores
function TIntProdutosAcessorios.Pesquisar(CodFabricanteIdentificador :Integer): Integer;
const
  CodMetodo: Integer = 544;
  NomMetodo: String = 'Pesquisar';
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

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text :=
    'select '+
    '  cod_fabricante_identificador as CodFabricanteIdentificador, '+
    '  cod_produto_acessorio as CodProdutoAcessorio, '+
    '  sgl_produto_acessorio as SglProdutoAcessorio, '+
    '  des_produto_acessorio as DesProdutoAcessorio  '+
    'from '+
    '  tab_produto_acessorio '+
    'where ' +
    '  dta_fim_validade is null ';
  If CodFabricanteIdentificador > 0 then begin
  Query.SQL.Text := Query.SQL.Text +
    '  and cod_fabricante_identificador = :cod_fabricante_identificador ';
    Query.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
  end;
  Query.SQL.Text := Query.SQL.Text +
    'order by num_ordem asc ';
  
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1753, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1753;
      Exit;
    End;
  End;
end;

end.
