// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 98
// *  Descrição Resumida : Pesquisa por todas as formas de pagamento de ordens de serviço
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntFormasPagamentoOS;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntFormasPagamentoOS }
  TIntFormasPagamentoOS = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;

implementation

{ TIntFormasPagamentoOS }
//Adalberto
//Pesquisa por todas as formas de pagamento de ordens de serviço
function TIntFormasPagamentoOS.Pesquisar(): Integer;
const
  CodMetodo: Integer = 540;
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

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text :=
        'select '+
        ' cod_forma_pagamento_os as CodFormaPagamentoOS, '+
        ' des_forma_pagamento_os as DesFormaPagamentoOS, '+
        ' ind_default as IndDefault '+
        ' from  '+
        '  tab_forma_pagamento_os '+
        ' where dta_fim_validade is null '+
        ' order by num_ordem asc ';
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1747, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1747;
      Exit;
    End;
  End;
end;

end.
