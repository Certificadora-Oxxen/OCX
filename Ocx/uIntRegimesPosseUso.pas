unit uIntRegimesPosseUso;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntRegimesPosseUso }
  TIntRegimesPosseUso = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntRegimesPosseUso }
function TIntRegimesPosseUso.Pesquisar: Integer;
const
  CodMetodo: Integer = 524;
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
    '    cod_regime_posse_uso        as CodRegimePosseUso '+
    '  , sgl_regime_posse_uso        as SglRegimePosseUso '+
    '  , des_regime_posse_uso        as DesRegimePosseUso '+
    '  , cod_regime_posse_uso_sisbov as CodRegimePosseUsoSisbov '+
    'from '+
    '  tab_regime_posse_uso '+
    'where '+
    '  dta_fim_validade is null '+
    'order by '+
    '  DesRegimePosseUso ';
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1694, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1694;
      Exit;
    End;
  End;
end;

end.
