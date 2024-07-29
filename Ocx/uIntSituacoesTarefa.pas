unit uIntSituacoesTarefa;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposTarget }
  TIntSituacoesTarefa = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntSituacoesTarefa }

function TIntSituacoesTarefa.Pesquisar: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
{  If Not Conexao.PodeExecutarMetodo(414) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;}

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select cod_situacao_tarefa  as CodSituacaoTarefa, ');
  Query.SQL.Add('       des_situacao_tarefa  as DesSituacaoTarefa ');
  Query.SQL.Add(' from tab_situacao_tarefa ');
  Query.SQL.Add(' order by des_situacao_tarefa ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1347, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -1347;
      Exit;
    End;
  End;
end;

end.

