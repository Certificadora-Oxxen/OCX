// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 09/09/2002
// *  Documentação       : Eventos de Movimentação - Especificação das
// *                       classes.doc
// *  Código Classe      : 55
// *  Descrição Resumida : Cadastro de Grupos Eventos
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/09/2002    Criação
// *
// ********************************************************************
unit uIntGruposEvento;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntGruposEvento }
  TIntGruposEvento = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar() : Integer;
  end;

implementation

{ TIntGruposEvento}
function TIntGruposEvento.Pesquisar() : Integer;
const
  CodMetodo : Integer = 251;
  NomMetodo : String ='Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_grupo_evento as CodGrupoEvento ' +
  '     , sgl_grupo_evento as SglGrupoEvento ' +
  '     , des_grupo_evento as DesGrupoEvento ' +
  '  from tab_grupo_evento ' +
  ' where dta_fim_validade is null ' +
  ' order by num_ordem ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(771, Self.ClassName, NomMetodo, [E.Message]);
      Result := -771;
      Exit;
    End;
  End;
end;
end.
