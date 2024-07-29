unit UIntGrausDificuldade;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntSituacoesCria }
  TIntGrausDificuldade = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntGrausDificuldade}

function TIntGrausDificuldade.Pesquisar: Integer;
const
  CodMetodo: Integer = 467;
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
      '  cod_grau_dificuldade_parto as CodGrauDificuldadeParto '+
      '  , sgl_grau_dificuldade_parto as SglGrauDificuldadeParto '+
      '  , des_grau_dificuldade_parto as DesGrauDificuldadeParto '+
      'from '+
      '  tab_grau_dificuldade_parto '+
      'where '+
      '  dta_fim_validade is null '+
      'order by '+
      '  cod_grau_dificuldade_parto ';
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1543, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1543;
      Exit;
    End;
  End;
end;

end.
