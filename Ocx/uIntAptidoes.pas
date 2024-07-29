// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 10/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  C�digo Classe      : 46
// *  Descri��o Resumida : Cadastro de Aptidoes
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    10/08/2002    Cria��o
// *
// ********************************************************************
unit uIntAptidoes;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntAptidoes }
  TIntAptidoes = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
  end;

implementation

{ TIntAptidoes}
function TIntAptidoes.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(175) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_aptidao as CodAptidao ');
  Query.SQL.Add('     , sgl_aptidao as SglAptidao ');
  Query.SQL.Add('     , des_aptidao as DesAptidao ');
  Query.SQL.Add('     , cod_aptidao_sisbov as CodAptidaoSisbov ');
  Query.SQL.Add('  from tab_aptidao ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_aptidao ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_aptidao ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_aptidao ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(490, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -490;
      Exit;
    End;
  End;
end;
end.


