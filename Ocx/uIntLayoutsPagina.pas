unit uIntLayoutsPagina;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntLayoutsPagina }
  TIntLayoutsPagina = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodTipoPagina : Integer): Integer;
  end;

implementation

{ TIntLayoutsPagina }

function TIntLayoutsPagina.Pesquisar(CodTipoPagina : Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(9) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select seq_posicao_banner as SeqPosicaoBanner, ');
  Query.SQL.Add('       des_posicao_banner as DesPosicaoBanner, ');
  Query.SQL.Add('       cod_tipo_banner as CodTipoBanner ');
  Query.SQL.Add('  from tab_layout_tipo_pagina ');
  Query.SQL.Add(' where cod_tipo_pagina = :cod_tipo_pagina ');
  Query.SQL.Add(' order by seq_posicao_banner ');
{$ENDIF}

  Try
    Query.ParamByName('cod_tipo_pagina').asInteger := CodTipoPagina;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(116, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := 116;
      Exit;
    End;
  End;
end;
end.
