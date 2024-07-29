// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 102
// *  Descrição Resumida : Pesquisa por todas situacoes de Ordem de Serviço
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntSituacoesOS;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntSituacoesOS }
  TIntSituacoesOS = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodSituacaoOSOrigem: Integer; IndEnviaPedidoIdent: String): Integer;
  end;

implementation

{ TIntSituacoesOS }
//Adalberto
//Pesquisa por todas situacoes de Ordem de Serviço
function TIntSituacoesOS.Pesquisar(CodSituacaoOSOrigem: Integer; IndEnviaPedidoIdent: String): Integer;
const
  CodMetodo: Integer = 545;
  NomMetodo: String = 'Pesquisar';
  QueryString1: String =
     ' select  '+
     '   cod_situacao_os as CodSituacaoOS, '+
     '   sgl_situacao_os as SglSituacaoOS, '+
     '   des_situacao_os as DesSituacaoOS  '+
     ' from '+
     '   tab_situacao_os '+
     '   order by num_ordem asc ';

  QueryString2: String =
     ' select  '+
     '   cod_situacao_os as CodSituacaoOS, '+
     '   sgl_situacao_os as SglSituacaoOS, '+
     '   des_situacao_os as DesSituacaoOS  '+
     ' from '+
     '   tab_situacao_os ts, tab_mudanca_situacao_os tm '+
     ' where '+
     '   cod_situacao_os_origem = :cod_situacao_os_origem '+
     '   and cod_situacao_os = cod_situacao_os_destino '+
     '   and ind_envia_pedido_ident = :ind_envia_pedido_ident '+     
     '   and ind_restrito_sistema = ''N'' '+
     ' order by num_ordem asc ';
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

  If ((CodSituacaoOSOrigem > 0) and (IndEnviaPedidoIdent = '')) or
     ((CodSituacaoOSOrigem < 0) and (IndEnviaPedidoIdent <> ''))
  then begin
    Mensagens.Adicionar(1884, Self.ClassName, NomMetodo, []);
    Result := -1884;
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
  If CodSituacaoOSOrigem < 0 Then Begin
    Query.SQL.Text := QueryString1;
  end else begin
    Query.SQL.Text := QueryString2;
    Query.ParamByName('cod_situacao_os_origem').AsInteger := CodSituacaoOSOrigem;
    Query.ParamByName('ind_envia_pedido_ident').AsString  := IndEnviaPedidoIdent;
  end;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1754, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1754;
      Exit;
    End;
  End;
end;

end.
