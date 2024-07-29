// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 49
// *  Descrição Resumida : Cadastro de Causas Morte
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uIntCausasMorte;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntCausasMorte }
  TIntCausasMorte = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntCausasMorte}
function TIntCausasMorte.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(178) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_Causa_morte as CodCausaMorte ');
  Query.SQL.Add('     , sgl_Causa_morte as SglCausaMorte ');
  Query.SQL.Add('     , des_Causa_morte as DesCausaMorte ');
  Query.SQL.Add('     , txt_observacao as TxtObservacao');
  Query.SQL.Add('  from tab_Causa_morte ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_Causa_morte ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_Causa_morte ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_Causa_morte ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(493, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -493;
      Exit;
    End;
  End;
end;

end.
