// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Vers�o             : 1
// *  Data               : 06/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  C�digo Classe      : 43
// *  Descri��o Resumida : Cadastro de Tipos de Contato
// ************************************************************************
// *  �ltimas Altera��es
// *
// ************************************************************************

unit uIntTiposContato;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInTiposContato }
  TIntTiposContato = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String): Integer;
  end;

implementation

{ TIntTiposContato}
function TIntTiposContato.Pesquisar(CodOrdenacao: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(161) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  with Query.SQL do
  begin
    Clear;
    Add('select');
    Add('  cod_tipo_contato           as CodTipoContato');
    Add('  , sgl_tipo_contato         as SglTipoContato');
    Add('  , des_tipo_contato         as DesTipoContato');
    Add('  , cod_grupo_contato        as CodGrupoContato');
    Add('  , cod_tipo_contato_sisbov  as CodTipoContatoSISBOV');
    Add('from');
    Add('  tab_tipo_contato');
    Add('order by');
    if CodOrdenacao = 'C' then
      Add('  cod_tipo_contato')
    else if CodOrdenacao = 'S' then
      Add('  sgl_tipo_contato')
    else if CodOrdenacao = 'D' then
      Add('  des_tipo_contato');
  end;
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(458, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -458;
      Exit;
    End;
  End;
end;

end.
