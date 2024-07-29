// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 100
// *  Descrição Resumida : Pesquisa por todas as identificações duplas exigidas pelo SISBOV
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntIdentificacoesDuplas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntIdentificacoesDuplas }
  TIntIdentificacoesDuplas = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(IndEnviaPedidoIdent: String): Integer;
  end;

implementation

{ TIntIdentificacoesDuplas }
//Adalberto
//Pesquisa por todas as identificações duplas exigidas pelo SISBOV
function TIntIdentificacoesDuplas.Pesquisar(IndEnviaPedidoIdent: String): Integer;
const
  CodMetodo: Integer = 543;
  NomMetodo: String = 'Pesquisar';
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

  If IndEnviaPedidoIdent = '' then begin
    Mensagens.Adicionar(1752, Self.ClassName, NomMetodo, ['Indicador envia pedido inválido']);
    Result := -1752;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add(
    ' select '+
    '   cod_identificacao_dupla as CodIdentificacaoDupla, '+
    '   sgl_identificacao_dupla as SglIdentificacaoDupla, '+
    '   des_identificacao_dupla as DesIdentificacaoDupla, '+
    '   ind_default as IndDefault, '+
    '   ind_requer_pedido_ident as IndRequerPedidoIdent  '+
    ' from '+
    '    tab_identificacao_dupla ' +
    ' where dta_fim_validade is null ');
  If IndEnviaPedidoIdent = 'S' then
  Query.SQL.Add(' and ind_requer_pedido_ident = ''S'' ');
  Query.SQL.Add(' order by num_ordem asc ');
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1752, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1752;
      Exit;
    End;
  End;
end;

end.
