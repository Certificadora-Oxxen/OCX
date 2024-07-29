// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 05/10/2004
// *  Documentação       :
// *  Código Classe      : 114
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntAplicativos;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntAplicativos }
  TIntAplicativos = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntAplicativos }

function TIntAplicativos.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 595;
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

  Try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Text := '  select ' +
                      '     cod_aplicativo as CodAplicativo ' +
                      '   , des_aplicativo as DesAplicativo ' +
                      '   , nom_aplicativo as NomAplicativo ' +
                      '    from tab_aplicativo '+
                      '   where ' +
                      '     (1 = 1) ' +
                      '     and dta_fim_validade is null ' +
                      'order by ' +
                      '     nom_aplicativo ';
    Query.Open;
    Result := 1; 
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(1984, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1984;
      Exit;
    End;
  End;
end;

end.

