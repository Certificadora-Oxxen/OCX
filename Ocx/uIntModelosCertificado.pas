
unit uIntModelosCertificado;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInModelosCertificado }
  TIntModelosCertificado = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntModelosCertificado}

function TIntModelosCertificado.Pesquisar: Integer;
const
  CodMetodo: Integer = 371;
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
      '  cod_modelo_certificado as CodModeloCertificado '+
      '  , des_modelo_certificado as DesModeloCertificado '+
      'from '+
      '  tab_modelo_certificado '+
      'where '+
      '  dta_fim_validade is null '+
      'order by '+
      '  num_ordem ';
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1180, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1180;
      Exit;
    End;
  End;
end;

end.
