// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.6
// *  Data               : 13/05/2004
// *  Documentação       :
// *  Código Classe      :
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// ********************************************************************
unit uIntDownloads;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntDownloads }
  TIntDownloads = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(): Integer;
  end;


implementation

{ TIntDownloads }

function TIntDownloads.Pesquisar: Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Text := ' select tad.cod_arquivo_download       as CodArquivoDownload ' +
                      '      , tad.cod_tipo_arquivo_download  as CodTipoArquivoDownload ' +
                      '      , ttad.sgl_tipo_arquivo_download as SglTipoArquivoDownload ' +
                      '      , ttad.des_tipo_arquivo_download as DesTipoArquivoDownload ' +
                      '      , tad.nom_arquivo_download       as NomArquivoDownload ' +
                      '      , tad.txt_descricao_download     as TxtDescricaoDownload' +
                      '      , tad.num_ordem                  as NumOrdem ' +
                      '   from tab_arquivo_download tad ' +
                      '      , tab_tipo_arquivo_download ttad ' +
                      '  where tad.cod_tipo_arquivo_download = ttad.cod_tipo_arquivo_download ' +
                      '    and tad.dta_fim_validade is null ' +
                      '  order by tad.cod_tipo_arquivo_download, tad.num_ordem ';
    Query.Open;

    Result := 1; 
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2200, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2200;
      Exit;
    end;
  end;
end;

end.

