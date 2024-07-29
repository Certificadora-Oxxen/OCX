// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Pessas e Pessoa Secundaria - Especificação das
// *                       classes.doc
// *  Código Classe      : 50
// *  Descrição Resumida : Cadastro de Graus Instrução
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    15/08/2002    Criação
// *
// *
// ********************************************************************
unit uIntGrausInstrucao;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInGrausInstrucao }
  TIntGrausInstrucao = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntGrausInstrucao}
function TIntGrausInstrucao.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(194) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_grau_instrucao as CodGrauInstrucao ');
  Query.SQL.Add('     , sgl_grau_instrucao as SglGrauInstrucao ');
  Query.SQL.Add('     , des_grau_instrucao as DesGrauInstrucao ');
  Query.SQL.Add('  from tab_grau_instrucao ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_grau_instrucao ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_grau_instrucao ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by Des_grau_instrucao ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(530, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -530;
      Exit;
    End;
  End;
end;
end.


