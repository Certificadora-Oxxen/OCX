unit uIntLargurasLinhaRelatorio;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInLargurasLinhaRelatorio }
  TIntLargurasLinhaRelatorio = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntLargurasLinhaRelatorio}
function TIntLargurasLinhaRelatorio.Pesquisar: Integer;
const
  Metodo: Integer = 319;
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
                '  , cod_tamanho_fonte as CodTamanhoFonte ' +
                '  , qtd_largura as QtdLargura ' +
                'from ' +
                '  tab_largura_linha_relatorio ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(978, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -978;
      Exit;
    End;
  End;
end;

end.
