// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 2.0
// *  Data               : 01/10/2004
// *  Documentação       :
// *  Código Classe      : 113
// *  Descrição Resumida :
// *
// *
// ************************************************************************
// *  Últimas Alterações :
// *
// *
// *
// ********************************************************************

unit uIntRotinasFTPEnvio;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntRotinasFTPEnvio }
  TIntRotinasFTPEnvio = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar: Integer;
  end;

implementation

{ TIntRotinasFTPEnvio }
function TIntRotinasFTPEnvio.Pesquisar: Integer;
const
  CodMetodo: Integer = 594;
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
  Query.SQL.Add('   select cod_rotina_ftp_envio          as CodRotinaFTPEnvio,        '+
                '          des_rotina_ftp_envio          as DesRotinaFTPEnvio,        '+
                '          txt_endereco_maquina_remota   as TxtEnderecoMaquinaRemota, '+
                '          txt_caminho_remoto            as TxtCaminhoRemeto,         '+
                '          dta_ultima_transferencia      as DtaUltimaTransferencia    '+
                '     from tab_rotina_ftp_envio                                       '+
                '    where dta_fim_validade is null                                   '+
                ' order by des_rotina_ftp_envio                                       ');
  Try
    Query.Open;
    Result := 1;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1966, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1966;
      Exit;
    End;
  End;
end;

end.
