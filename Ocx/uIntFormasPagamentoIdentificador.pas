// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 97
// *  Descrição Resumida : Pesquisa por todas as formas de pagamento de identifcadores de
// *                       um determinado fabricante
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntFormasPagamentoIdentificador;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntFormasPagamentoIdentificador }
  TIntFormasPagamentoIdentificador = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodFabricanteIdentificador :Integer) : Integer;
  end;

implementation

{ TIntFormasPagamentoIdentificador }
//Adalberto
//Pesquisa por todas as formas de pagamento de identifcadores de um determinado fabricante
function TIntFormasPagamentoIdentificador.Pesquisar(CodFabricanteIdentificador: Integer): Integer;
const
  CodMetodo: Integer = 539;
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
        ' cod_fabricante_identificador as CodFabricanteIdentificador,  '+
        ' cod_forma_pagamento_ident as CodFormaPagamentoIdentificador, '+
        ' des_forma_pagamento_ident as DesFormaPagamentoIdentificador, '+
        ' ind_default as IndDefault '+
        ' from  '+
        '    tab_forma_pagamento_ident '+
        ' where '+
        '   dta_fim_validade is null ';
        If CodFabricanteIdentificador > 0 Then Begin
         Query.SQL.Text :=   Query.SQL.Text +
         '   and cod_fabricante_identificador = :cod_fabricante_identificador ';
         Query.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
        End;
        Query.SQL.Text :=   Query.SQL.Text +
        ' order by num_ordem asc ';
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1745, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1745;
      Exit;
    End;
  End;
end;

end.
