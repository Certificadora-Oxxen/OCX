unit uIntMudancasCategoriaAnimal;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type

  { TInMudancasCategoriaAnimal }
  TIntMudancasCategoriaAnimal = class(TIntClasseBDNavegacaoBasica)
  public
    function Pesquisar(CodTipoEvento: Integer): Integer;
    function PesquisarOrigens(CodTipoEvento, CodAptidao: Integer): Integer;
  end;

implementation

{ TIntMudancasCategoriaAnimal }
function TIntMudancasCategoriaAnimal.Pesquisar(
  CodTipoEvento: Integer): Integer;
const
  Metodo: Integer = 286;
  NomeMetodo: String = 'Pesquisar';
var
  sSQL: String;
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
{$IFDEF MSSQL}
  with Query.SQL do
  begin
    Clear;
    sSQL := 'select ' +
            '  distinct ' +
            '  cod_tipo_evento as CodTipoEvento ' +
            '  , cod_aptidao as CodAptidao ' +
            '  , cod_categoria_origem as CodCategoriaOrigem ' +
            '  , cod_categoria_destino as CodCategoriaDestino ' +
            'from ' +
            '  tab_mudanca_categoria_animal ';
    if CodTipoEvento > 0 then begin
      sSQL := sSQL +
            'where ' +
            '  cod_tipo_evento = ' + IntToStr(CodTipoEvento);
    end;
    Add(sSQL);
  end;
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(839, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -839;
      Exit;
    End;
  End;
end;

function TIntMudancasCategoriaAnimal.PesquisarOrigens(CodTipoEvento,
  CodAptidao: Integer): Integer;
const
  Metodo: Integer = 304;
  NomeMetodo: String = 'PesquisarOrigens';
var
  sSQL: String;
  bWhere: Boolean;
begin
  Result := -1;
  bWhere := False;

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
{$IFDEF MSSQL}
  with Query.SQL do
  begin
    Clear;
    sSQL := 'select ' +
            '  distinct ' +
            '  cod_categoria_origem as CodCategoriaOrigem ' +
            'from ' +
            '  tab_mudanca_categoria_animal ';
    if CodTipoEvento > 0 then begin
      bWhere := True;
      sSQL := sSQL +
            'where ' +
            '  cod_tipo_evento = ' + IntToStr(CodTipoEvento);
    end;
    if CodAptidao > 0 then begin
      if bWhere then begin
        sSQL := sSQL +
              '  and ' ;
      end else begin
        sSQL := sSQL +
              'where ' +
              '  ' ;
      end;
      sSQL := sSQL +
            ' cod_aptidao = ' + IntToStr(CodAptidao);
    end;
    Add(sSQL);
  end;
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(898, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -898;
      Exit;
    End;
  End;
end;

end.
