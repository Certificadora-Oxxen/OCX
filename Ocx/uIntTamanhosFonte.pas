unit uIntTamanhosFonte;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInTamanhosFonte }
  TIntTamanhosFonte = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntTamanhosFonte}
function TIntTamanhosFonte.Pesquisar: Integer;
const
  Metodo: Integer = 318;
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
                '  cod_tamanho_fonte as CodTamanhoFonte ' +
                '  , des_tamanho_fonte as DesTamanhoFonte ' +
                'from ' +
                '  tab_tamanho_fonte ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(977, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -977;
      Exit;
    End;
  End;
end;
end.
