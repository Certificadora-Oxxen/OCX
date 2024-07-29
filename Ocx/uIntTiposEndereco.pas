// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Arley
// *  Vers�o             : 1
// *  Data               : 06/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  C�digo Classe      : 44
// *  Descri��o Resumida : Cadastro de Tipos de Endereco
// ************************************************************************
// *  �ltimas Altera��es
// *
// ************************************************************************

unit uIntTiposEndereco;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInTiposEndereco }
  TIntTiposEndereco = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String): Integer;
  end;

implementation

{ TIntTiposEndereco}
function TIntTiposEndereco.Pesquisar(CodOrdenacao: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usu�rio pode executar m�todo
  If Not Conexao.PodeExecutarMetodo(162) Then Begin
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
    Add('  cod_tipo_endereco   as CodTipoEndereco');
    Add('  , sgl_tipo_endereco as SglTipoEndereco');
    Add('  , des_tipo_endereco as DesTipoEndereco');
    Add('from');
    Add('  tab_tipo_endereco');
    Add('order by');
    if CodOrdenacao = 'C' then
      Add('  cod_tipo_endereco')
    else if CodOrdenacao = 'S' then
      Add('  sgl_tipo_endereco')
    else if CodOrdenacao = 'D' then
      Add('  des_tipo_endereco');
  end;
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(459, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -459;
      Exit;
    End;
  End;
end;

end.
