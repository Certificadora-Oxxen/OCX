unit uIntMotivosDescarte;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntMotivosDescarte }
  TIntMotivosDescarte = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntMotivosDescarte}

function TIntMotivosDescarte.Pesquisar: Integer;
const
  CodMetodo: Integer = 484;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Text :=
      'select '+
      '  cod_motivo_descarte as CodMotivoDescarte '+
      '  , sgl_motivo_descarte as SglMotivoDescarte '+
      '  , des_motivo_descarte as DesMotivoDescarte '+
      'from '+
      '  tab_motivo_descarte '+
      'where '+
      '  dta_fim_validade is null '+
      'order by '+
      '  des_motivo_descarte ';
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1597, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1597;
      Exit;
    End;
  End;
end;

end.
