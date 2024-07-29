// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 48
// *  Descrição Resumida : Cadastro de Tipos Morte
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *   Carlos    26/09/2002    Inserção do método Pesquisar Relacionamento
// ********************************************************************
unit uIntTiposMorte;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposMorte }
  TIntTiposMorte = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodOrdenacao: String) : Integer;
    function PesquisarRelacionamento: Integer;
  end;

implementation

{ TIntTiposMorte}
function TIntTiposMorte.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(177) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_morte as CodTipoMorte ');
  Query.SQL.Add('     , sgl_tipo_morte as SglTipoMorte ');
  Query.SQL.Add('     , des_tipo_morte as DesTipoMorte ');
  Query.SQL.Add('     , cod_tipo_morte_sisbov as CodTipoMorteSisbov ');
  Query.SQL.Add('  from tab_tipo_morte ');
  Query.SQL.Add(' where dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_morte ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_morte ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_tipo_morte ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(492, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -492;
      Exit;
    End;
  End;
end;

function TIntTiposMorte.PesquisarRelacionamento: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarRelacionamento');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(313) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarRelacionamento', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select ttm.cod_tipo_morte as CodTipoMorte, ');
  Query.SQL.Add('       tcm.cod_causa_morte as CodCausaMorte ');
  Query.SQL.Add('from tab_tipo_morte as ttm, ');
  Query.SQL.Add('     tab_causa_morte as tcm, ');
  Query.SQL.Add('     tab_tipo_causa_morte as ttcm ');
  Query.SQL.Add('where ttm.cod_tipo_morte = ttcm.cod_tipo_morte ');
  Query.SQL.Add('and   tcm.cod_causa_morte = ttcm.cod_causa_morte ');
  Query.SQL.Add('and   ttm.dta_fim_validade is null ');
  Query.SQL.Add('order by ttm.cod_tipo_morte ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(936, Self.ClassName, 'PesquisarRelacionamento', [E.Message]);
      Result := -936;
      Exit;
    End;
  End;
end;

end.
