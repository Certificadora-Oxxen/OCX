// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 03/09/2002
// *  Documentação       :
// *  Classe             : 55
// *  Descrição Resumida : Pesquisa de Grandezas Resumo
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    03/09/2002    Criação.
// *
// ********************************************************************
unit uIntGrandezasResumo;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntLote, dbtables, sysutils, db;

  { TIntGrandezasResumo }
type
  TIntGrandezasResumo = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;

implementation

{ TIntGrandezasResumo  }

{* Função responsável por pesquisar as grandezas que irão compor o quadro
   informativo da página principal do sistema.

   @return -373 Valor retornado quando não for informado nenhum usuário.
   @return 0 Valor retornado quando o método for executado com sucesso.
   @return -730 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.      

}
function TIntGrandezasResumo.Pesquisar(): Integer;
begin
  Result := -1;

  if conexao.CodUsuario = - 1 then
  begin
    Mensagens.Adicionar(373, Self.ClassName, 'Pesquisar', []);
    Result := -373;
    exit;
  end;

  if Not Inicializado then
  begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tpgg.des_grupo_grandeza as DesGrupoGrandeza ' +
                '     , tgr.des_grandeza_resumo as DesGrandezaResumo' +
                '     , tgg.num_ordem ' +
                '     , tgr.num_ordem ' +
                '     , sum(isnull(tvgr.vlr_grandeza_resumo,0)) as VlrGrandezaResumo ' +
                '  from tab_papel_grupo_grandeza tpgg with (nolock) ' +
                '     , tab_grupo_grandeza tgg with (nolock) ' +
                '     , tab_grandeza_resumo tgr with (nolock) ' +
                '     , tab_valor_grandeza_resumo tvgr with (nolock) ');
  Query.SQL.Add(' where tpgg.cod_papel = :cod_papel ');
  if Conexao.CodPapelUsuario = 1 then    // Associacao
  begin
    Query.SQL.Add(' and tvgr.cod_pessoa_produtor in (select cod_pessoa_produtor ' +
                  '                                    from tab_associacao_produtor ' +
                  '                                   where cod_pessoa_associacao = :cod_pessoa )');
  end
  else if Conexao.CodPapelUsuario = 3 then    // Tecnico
  begin
    Query.SQL.Add(' and tvgr.cod_pessoa_produtor in (select cod_pessoa_produtor ' +
                  '                                    from tab_tecnico_produtor ' +
                  '                                   where cod_pessoa_tecnico = :cod_pessoa ' +
                  '                                     and dta_fim_validade is null)');
  end
  else if Conexao.CodPapelUsuario = 4 then    //Produtor
  begin
    Query.SQL.Add(' and tvgr.cod_pessoa_produtor = :cod_pessoa');
  end
  else if Conexao.CodPapelUsuario = 9 then // Gestor (19/04/2005)
  begin
    Query.SQL.Add('  and tvgr.cod_pessoa_produtor in (select cod_pessoa_produtor ' +
                  '                                     from tab_tecnico_produtor ttp ' +
                  '                                        , tab_tecnico tt ' +
                  '                                    where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                  '                                      and ttp.dta_fim_validade is null ' +
                  '                                      and tt.dta_fim_validade is null ' +                  
                  '                                      and tt.cod_pessoa_gestor = :cod_pessoa)');
  end;

  Query.SQL.Add('   and tgg.cod_grupo_grandeza = tpgg.cod_grupo_grandeza ' +
                '   and tgr.cod_grupo_grandeza = tgg.cod_grupo_grandeza ' +
                '   and tvgr.cod_grandeza_resumo =* tgr.cod_grandeza_resumo ' +
                '  group by tpgg.des_grupo_grandeza ' +
                '         , tgr.des_grandeza_resumo ' +
                '         , tgg.num_ordem ' +
                '         , tgr.num_ordem ' +
                '  order by tgg.num_ordem ' +
                '         , tgr.num_ordem ');
{$ENDIF}
  if (Conexao.CodPapelUsuario = 1) or (Conexao.CodPapelUsuario = 3) or
     (Conexao.CodPapelUsuario = 4) or (Conexao.CodPapelUsuario = 9) then
  begin
    Query.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
  end;
  Query.ParamByName('cod_papel').AsInteger := Conexao.CodPapelUsuario;

  try
    Query.Open;
    Result := 0;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(730, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -730;
      Exit;
    end;
  end;
end;

end.
