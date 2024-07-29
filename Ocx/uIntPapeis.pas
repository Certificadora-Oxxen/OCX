unit uIntPapeis;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposTarget }
  TIntPapeis = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(ECodTipoAcessoNaoDesejado: String): Integer;
  end;

implementation

{ TIntPapeis }

{* Função responsável por retornar os papéis cadastrados no sistema.
   Especificamente na tabela, tab_papel.

   @param ECodTipoAcessoNaoDesejado String

   @return 0 Valor retornado quando a execução do método ocorrer com sucesso.
   @return -188 Valor retornado quando o usuário que for executar o método
                (usuário logado no sistema) não possuir acesso ao método, ou seja,
                o usuário não tem acesso ao método.
   @return -187 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.
}
function TIntPapeis.Pesquisar(ECodTipoAcessoNaoDesejado: String): Integer;
const
  CodMetodo: Integer = 36;
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;

  if not Inicializado then
  Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
  {$IFDEF MSSQL}
  Query.SQL.Text :=  ' select pap.cod_papel           as CodPapel ' +
            #13#10 + '      , pap.des_papel           as DesPapel ' +
            #13#10 + '      , pap.cod_tipo_acesso     as CodTipoAcesso ' +
            #13#10 + '      , tipo.des_tipo_acesso    as DesTipoAcesso ' +
            #13#10 + '      , pap.cod_natureza_pessoa as CodNaturezaPessoa ' +
            #13#10 + ' from tab_papel pap '+
            #13#10 + '    , tab_tipo_acesso tipo '+
            #13#10 + 'where pap.cod_tipo_acesso = tipo.cod_tipo_acesso ';

  if ECodTipoAcessoNaoDesejado <> '' then
  begin
    Query.SQL.Text :=  Query.SQL.Text + #13#10 + '  and pap.cod_tipo_acesso != :cod_tipo_acesso ';
  end;

  // Se o usuário logado for um gestor, trazer apenas papéis de técnico (3)
  // e produtor (4) e vendedor (8)
  if (Conexao.CodPapelUsuario = 9) then
  begin
    Query.SQL.Text := Query.SQL.Text + #13#10 + ' and cod_papel in (3, 4, 8) ';
  end;

  // Se o usuário logado for um técnico, trazer apenas papéis de produtor e vendedor (8). 
  if (Conexao.CodPapelUsuario = 3) then
  begin
    Query.SQL.Text := Query.SQL.Text + #13#10 + ' and cod_papel in (4, 8) ';
  end;

  Query.SQL.Text :=  Query.SQL.Text + #13#10 + ' order by pap.des_papel ';
  {$ENDIF}

  if ECodTipoAcessoNaoDesejado <> '' then
  begin
    Query.ParamByName('cod_tipo_acesso').AsString := ECodTipoAcessoNaoDesejado
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(187, Self.ClassName, NomMetodo, [E.Message]);
      Result := -187;
      Exit;
    end;
  end;
end;

end.
 