unit uIntTiposPagina;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposPagina }
  TIntTiposPagina = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntTiposPagina }

function TIntTiposPagina.Pesquisar: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(8) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select cod_tipo_pagina as CodTipoPagina, ');
  Query.SQL.Add('       des_tipo_pagina as DesTipoPagina ');
  Query.SQL.Add('  from tab_tipo_pagina ');
  Query.SQL.Add(' where dta_fim_validade is null ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(115, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -115;
      Exit;
    End;
  End;
end;

end.
