unit uIntTiposBanner;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntBannersVisita }
  TIntTiposBanner = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntTiposBanner }

function TIntTiposBanner.Pesquisar: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(7) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select cod_tipo_banner as CodTipoBanner, ');
  Query.SQL.Add('       des_tipo_banner as DesTipoBanner ');
  Query.SQL.Add('  from tab_tipo_banner ');
  Query.SQL.Add(' where dta_fim_validade is null ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(114, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -114;
      Exit;
    End;
  End;
end;

end.
