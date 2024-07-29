// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/10/2002
// *  Documentação       :
// *  Código Classe      : 70
// *  Descrição Resumida : Pesquisa de arquivos SISBOV
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    31/10/2002    Criação
// *
// ********************************************************************
unit uIntTiposArquivoSISBOV;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposArquivoSISBOV }
  TIntTiposArquivoSISBOV = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar : Integer;
  end;

implementation

{ TIntTiposArquivoSISBOV}
function TIntTiposArquivoSISBOV.Pesquisar() : Integer;
Const
  NomeMetodo : String  = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(340) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select cod_tipo_arquivo_sisbov as CodTipoArquivoSisbov ' +
                     ' , des_tipo_arquivo_sisbov as DesTipoArquivoSisbov ' +
                 '  from tab_tipo_arquivo_sisbov ' +
                 ' where dta_fim_validade is null ' +
                 ' order by num_ordem');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1111, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1111;
      Exit;
    End;
  End;
end;

end.
