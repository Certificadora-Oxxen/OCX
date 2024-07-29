unit uIntTiposOrigemArqImport;

{$DEFINE MSSQL}

interface

uses Classes, DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas, uFerramentas, uArquivo,
        uIntTipoOrigemArqImport, uConexao, uIntMensagens, uLibZipM;

type
  TIntTiposOrigemArqImport = class(TIntClasseBDNavegacaoBasica)
  private
    FIntTipoOrigemArqImport: TIntTipoOrigemArqImport;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar: Integer;

    property IntTipoOrigemArqImport: TIntTipoOrigemArqImport read FIntTipoOrigemArqImport write FIntTipoOrigemArqImport;
  end;

implementation

uses ComServ;

{ TIntTiposOrigemArqImport }

constructor TIntTiposOrigemArqImport.Create;
begin
  inherited;
  FIntTipoOrigemArqImport := TIntTipoOrigemArqImport.Create;
end;

destructor TIntTiposOrigemArqImport.Destroy;
begin
  FIntTipoOrigemArqImport.Free;
  inherited;
end;
                    
function TIntTiposOrigemArqImport.Pesquisar: Integer;
const
  Metodo: Integer = 518;
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
{  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;}

  Try
     Query.Close;
     Query.SQL.Text := ' Select ' +
                       '      cod_tipo_origem_arq_import as CodTipoOrigemArqImport ' +
                       '    , sgl_tipo_origem_arq_import as SglTipoOrigemArqImport ' +
                       '    , des_tipo_origem_arq_import as DesTipoOrigemArqImport ' +
                       ' From tab_tipo_origem_arq_import ' +
                       ' Order by sgl_tipo_origem_arq_import ';
     Query.Open;
     Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1682, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1682;
      Exit;
    End;
  end;
end;
end.
