unit uIntRotinasFTPRetorno;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntRotinasFTPRetorno }
  TIntRotinasFTPRetorno = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntRotinasFTPRetorno }
function TIntRotinasFTPRetorno.Pesquisar: Integer;
const
  CodMetodo: Integer = 562;
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('   select cod_rotina_ftp_retorno      as CodRotinaFTPRetorno,      '+
                '          des_rotina_ftp_retorno      as DesRotinaFTPRetorno,      '+
                '          txt_endereco_maquina_remota as TxtEnderecoMaquinaRemota, '+
                '          txt_caminho_remoto          as TxtCaminhoRemoto,         '+
                '          dta_ultima_transferencia    as DtaUltimaTransferencia    '+
                '     from tab_rotina_ftp_retorno                                   '+
                '    where dta_fim_validade is null                                 '+
                ' order by des_rotina_ftp_retorno                                   ');
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1824, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1824;
      Exit;
    End;
  End;
end;
end.
