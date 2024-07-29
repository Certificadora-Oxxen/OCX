unit uIntOrientacoes;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntOrientacoes }
  TIntOrientacoes = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntOrientacoes}
function TIntOrientacoes.Pesquisar: Integer;
const
  Metodo: Integer = 317;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select ' +
                '  cod_orientacao as CodOrientacao ' +
                '  , des_orientacao as DesOrientacao ' +
                'from ' +
                '  tab_orientacao ' +
                'order by ' +
                '  DesOrientacao ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(976, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -976;
      Exit;
    End;
  End;
end;

end.
