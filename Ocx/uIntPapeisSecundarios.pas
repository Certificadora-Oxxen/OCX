// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 40
// *  Descrição Resumida : Cadastro de Papeis Secundários - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *
// *
// ********************************************************************
unit uIntPapeisSecundarios;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInPapeisSecundarios }
  TIntPapeisSecundarios = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar : Integer;
  end;

implementation

{ TIntPapeisSecundarios}
function TIntPapeisSecundarios.Pesquisar : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(133) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_papel_secundario as CodPapelSecundario ');
  Query.SQL.Add('     , des_papel_secundario as DesPapelSecundario ');
  Query.SQL.Add('     , cod_natureza_pessoa as CodNaturezaPessoa ');
  Query.SQL.Add('     , ind_cnpj_cpf_obrigatorio as IndCnpjCpfObrigatorio');
  Query.SQL.Add('  from tab_papel_secundario ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  Query.SQL.Add(' order by des_papel_secundario ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(414, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -414;
      Exit;
    End;
  End;
end;
end.


