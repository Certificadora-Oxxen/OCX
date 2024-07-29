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
unit UIntTiposPropriedades;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,
     uFerramentas, strUtils;

type

  { TIntDownloads }
  TIntTiposPropriedades = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;


implementation

{ TIntTiposPropriedades }

function TIntTiposPropriedades.Pesquisar: Integer;
const
  NomMetodo: String = 'PesquisarTiposPropriedade';
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
    Query.SQL.Add('select cod_tipo_propriedade_rural as CodTipoPropriedadeRural,');
    Query.SQL.Add('       des_tipo_propriedade_rural as DesTipoPropriedadeRural');
    Query.SQL.Add('  from tab_tipo_propriedade_rural ');
    Query.SQL.Add('  order by cod_tipo_propriedade_rural ');

    Query.Open;

    Result := 1; 
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2281, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2281;
      Exit;
    end;
  end;
end;

end.

