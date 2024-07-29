unit uIntOpcoesEnvioComunicado;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInOpcoesEnvioComunicado }
  TIntOpcoesEnvioComunicado = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodPapel: Integer): Integer;
  end;

implementation

{ TIntOpcoesEnvioComunicado}
function TIntOpcoesEnvioComunicado.Pesquisar(CodPapel: Integer): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(160) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_acesso ');
  Query.SQL.Add('  from tab_papel ');
  Query.SQL.Add(' where cod_papel = :cod_papel ');
{$ENDIF}
  Query.ParamByName('cod_papel').AsInteger := CodPapel;
  Query.Open;
  If Query.IsEmpty Then Begin
    Mensagens.Adicionar(376, Self.ClassName, 'Pesquisar', []);
    Result := -376;
    Query.Close;
    Exit;
  End;
  If Query.FieldByName('cod_tipo_acesso').AsString = 'N' Then Begin
    Mensagens.Adicionar(376, Self.ClassName, 'Pesquisar', []);
    Result := -376;
    Query.Close;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_papel as CodPapel, ');
  Query.SQL.Add('       cod_opcao_envio_comunicado as CodOpcaoEnvioComunicado, ');
  Query.SQL.Add('       des_opcao_envio_comunicado as DesOpcaoEnvioComunicado ');
  Query.SQL.Add('  from tab_opcao_envio_comunicado ');
  Query.SQL.Add(' where cod_papel = :cod_papel ');
  Query.SQL.Add(' order by 2 ');
{$ENDIF}
  Query.ParamByName('cod_papel').AsInteger := CodPapel;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(445, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -445;
      Exit;
    End;
  End;
end;

end.
