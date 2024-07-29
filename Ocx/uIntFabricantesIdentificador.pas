// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 99
// *  Descrição Resumida : Fornece todas as operações a serem realizadas com a entidade que representa
// *                       um fabricante de identificadores.
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntFabricantesIdentificador;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, uFerramentas, sysutils, db, uConexao, uIntMensagens,
      uIntFabricanteIdentificador, uIntRelatorios;

type
  { TIntFabricantesIdentificador }
  TIntFabricantesIdentificador = class(TIntClasseBDNavegacaoBasica)
  private
    FIntFabricanteIdentificador: TIntFabricanteIdentificador;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodFabricanteIdentificador: Integer): Integer;
    function Pesquisar(): Integer;
    property IntFabricanteIdentificador: TIntFabricanteIdentificador read FIntFabricanteIdentificador write FIntFabricanteIdentificador;    
  end;

implementation

{ TIntFabricantesIdentificador }

constructor TIntFabricantesIdentificador.Create;
begin
  inherited;
  FIntFabricanteIdentificador := TIntFabricanteIdentificador.Create;
end;

destructor TIntFabricantesIdentificador.Destroy;
begin
  FIntFabricanteIdentificador.Free;
  inherited;
end;

//Busca os dados de um arquivo a ser (ou já) enviado via FTP pelo sistema
// e carrega-os como atributos da propriedade ArquivoFTPEnvio.
function TIntFabricantesIdentificador.Buscar(
  CodFabricanteIdentificador: Integer): Integer;
const
  CodMetodo: Integer = 541;
  NomeMetodo: String = 'Buscar';
var
//  Query: THerdomQuery;
  Q: THerdomQuery;
  CNPJFormatado: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
      Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
      Result := -188;
      Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.Close;
      {Montando query de pesquisa de acordo com os críterios informados}
      Q.SQL.Text :=
          ' select ' +
          '  tfi.cod_fabricante_identificador as CodFabricanteIdentificador , ' +
          '  tftpe.cod_rotina_ftp_envio as CodRotinaFTPEnvio, ' +
          '  tftpr.cod_rotina_ftp_retorno as CodRotinaFTPRetorno, ' +
          '  tftpe.des_rotina_ftp_envio as DesRotinaFTPEnvio, ' +
          '  tftpr.des_rotina_ftp_retorno as DesRotinaFTPRetorno, ' +
          '  tfi.ind_envio_pedido_email as IndEnvioPedidoEmail, ' +
          '  tfi.ind_envio_pedido_ftp as IndEnvioPedidoFTP, ' +
          '  tfi.ind_retorno_situacao_ftp as IndRetornoSituacaoFTP, ' +
          '  tfi.nom_fabricante_identificador as NomFabricanteIdentificador, ' +
          '  tfi.nom_reduzido_fabricante as NomReduzidoFabricante, ' +
          '  tfi.num_cnpj_fabricante as NumCNPJFabricante, ' +
          '  tfi.num_maximo_pedido as NumMaxPedido, ' +
          '  tfi.num_ordem as NumOrdem, ' +
          '  tfi.num_ultima_remessa as NumUltimaRemessa, ' +
          '  tfi.num_ultimo_pedido as NumUltimoPedido, ' +
          '  tfi.txt_email_fabricante as TxtEmailFabricante ' +
          'from ' +
          '  tab_fabricante_identificador tfi, ' +
          '  tab_rotina_ftp_envio tftpe, ' +
          '  tab_rotina_ftp_retorno tftpr ' +
          'where ' +
          '   tfi.cod_fabricante_identificador  = :cod_fabricante_identificador ' +
          '   and tfi.cod_rotina_ftp_envio     *= tftpe.cod_rotina_ftp_envio ' +
          '   and tfi.cod_rotina_ftp_retorno   *= tftpr.cod_rotina_ftp_retorno ' +
          '   and tfi.dta_fim_validade is null ';
        Q.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
        Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1751, Self.ClassName, NomeMetodo, []);
        Result := -1751;
        Exit;
      End;

      CNPJFormatado := Q.FieldByName('NumCNPJFabricante').AsString;
      CNPJFormatado := Copy(CNPJFormatado, 1, 2)+'.'+Copy(CNPJFormatado, 3, 3)+'.'+Copy(CNPJFormatado, 6, 3)+'/'+Copy(CNPJFormatado, 9, 4)+'-'+Copy(CNPJFormatado, 13, 2)+'.';

      FIntFabricanteIdentificador.CodFabricanteIdentificador   := Q.FieldByName('CodFabricanteIdentificador').AsInteger;
      FIntFabricanteIdentificador.CodRotinaFTPEnvio            := Q.FieldByName('CodRotinaFTPEnvio').AsInteger;
      FIntFabricanteIdentificador.CodRotinaFTPRetorno          := Q.FieldByName('CodRotinaFTPRetorno').AsInteger;
      FIntFabricanteIdentificador.DesRotinaFTPEnvio            := Q.FieldByName('DesRotinaFTPEnvio').AsString;
      FIntFabricanteIdentificador.DesRotinaFTPRetorno          := Q.FieldByName('DesRotinaFTPRetorno').AsString;
      FIntFabricanteIdentificador.IndEnvioPedidoEmail          := Q.FieldByName('IndEnvioPedidoEmail').AsString;
      FIntFabricanteIdentificador.IndEnvioPedidoFTP            := Q.FieldByName('IndEnvioPedidoFTP').AsString;
      FIntFabricanteIdentificador.IndRetornoSituacaoFTP        := Q.FieldByName('IndRetornoSituacaoFTP').AsString;
      FIntFabricanteIdentificador.NomFabricanteIdentificador   := Q.FieldByName('NomFabricanteIdentificador').AsString;
      FIntFabricanteIdentificador.NomReduzidoFabricante        := Q.FieldByName('NomReduzidoFabricante').AsString;
      FIntFabricanteIdentificador.NumCNPJFabricante            := Q.FieldByName('NumCNPJFabricante').AsString;
      FIntFabricanteIdentificador.NumCNPJFabricanteFormatado   := CNPJFormatado;
      FIntFabricanteIdentificador.NumMaximoPedido              := Q.FieldByName('NumMaxPedido').AsInteger;
      FIntFabricanteIdentificador.NumOrdem                     := Q.FieldByName('NumOrdem').AsInteger;
      FIntFabricanteIdentificador.NumUltimaRemessa             := Q.FieldByName('NumUltimaRemessa').AsInteger;
      FIntFabricanteIdentificador.NumUltimoPedido              := Q.FieldByName('NumUltimoPedido').AsInteger;
      FIntFabricanteIdentificador.TxtEmailFabricante           := Q.FieldByName('TxtEmailFabricante').AsString;

      // Identifica procedimento como bem sucedido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1750, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1750;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFabricantesIdentificador.Pesquisar(): Integer;
const
  CodMetodo: Integer = 542;
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
  Query.SQL.Text :=
          'select '+
          '   cod_fabricante_identificador as CodFabricanteIdentificador, '+
          '   nom_reduzido_fabricante as NomReduzidoFabricante, '+
          '   num_ultimo_pedido as NumUltimoPedido, '+
          '   num_ultima_remessa as NumUltimaRemessa, '+
          '   ind_default as IndDefault  '+
          'from '+
          '   tab_fabricante_identificador '+
          'where '+
          '   dta_fim_validade is null '+
          'order by '+
          '   num_ordem asc ';
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1749, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1749;
      Exit;
    End;
  End;
end;

end.
