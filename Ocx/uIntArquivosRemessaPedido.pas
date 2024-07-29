// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 103
// *  Descrição Resumida : Armazena os atributos de um arquivo de remessa de pedidos
// *                       de identificadores gerado no sistema.
// ************************************************************************
// *  Últimas Alterações :
// *
// ********************************************************************
unit uIntArquivosRemessaPedido;

{$DEFINE MSSQL}

interface

uses Classes, uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntArquivoRemessaPedido, uLibZip, ZipUtils, uFerramentas, uIntEmailsEnvio,
     uIntPedidosIdentificadores, uIntOrdensServico, uIntArquivosFTPEnvio, uEmailsEnvio,
     strUtils, uIntOcorrenciasSistema;

type
  { TIntArquivosRemessaPedido }
  TIntArquivosRemessaPedido = class(TIntClasseBDNavegacaoBasica)
  private
    FIntArquivoRemessaPedido:    TIntArquivoRemessaPedido;
    FIntPedidosIdentificadores:  TPedidoIdentificador;
    FIntEmailsEnvio:             TIntEmailsEnvio;
    FIntArquivosFTPEnvio:        TIntArquivosFTPEnvio;
    FIntOcorrenciasSistema:      TIntOcorrenciasSistema;
    function ObterCodArquivoRemessa(var CodArquivoRemessaNovo: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;
    function Pesquisar(DtaCriacaoArquivoInicio,
  DtaCriacaoArquivoFim: TDateTime; CodFabricanteIdentificador,
  NumRemessaFabricante, NumPedidoFabricante: Integer; const IndEnvioPedidoEmail: WideString;
  CodSituacaoEmail: Integer; const IndEnvioPedidoFTP: WideString;
  CodSituacaoArquivoFTP: Integer): Integer;
    function Buscar(CodArquivoRemessaPedido: Integer): Integer;
    function GerarNovaRemessa(CodFabricanteIdentificador: Integer): Integer;
    property IntArquivoRemessaPedido: TIntArquivoRemessaPedido read FIntArquivoRemessaPedido write FIntArquivoRemessaPedido;
  end;

implementation

uses SqlExpr;


{ TIntArquivosRemessaPedido }

constructor TIntArquivosRemessaPedido.Create;
begin
  inherited;
  FIntArquivoRemessaPedido   := TIntArquivoRemessaPedido.Create;
end;

destructor TIntArquivosRemessaPedido.Destroy;
begin
  FIntArquivoRemessaPedido.Free;
  inherited;
end;

//Busca os dados de um arquivo de remessa de pedidos de identificadores gerado
//no sistema e carrega-os como atributos da propriedade ArquivoRemessaPedido
function TIntArquivosRemessaPedido.Buscar(
  CodArquivoRemessaPedido: Integer): Integer;
const
  CodMetodo: Integer = 546;
  NomeMetodo: String = 'Buscar';
var
  Q: THerdomQuery;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
      Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
      Result := -188;
      Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.Close;
      {Montando query de pesquisa de acordo com os críterios informados}
      Q.SQL.Text :=
            'select '+
            '  tar.cod_arquivo_ftp_envio as CodArquivoFTPEnvio, '+
            '  tar.cod_arquivo_remessa_pedido as CodArquivoRemessaPedido, '+
            '  tar.cod_email_envio as CodEmailEnvio, '+
            '  tar.cod_fabricante_identificador as CodFabricanteIdentificador, '+
            '  taf.cod_situacao_arquivo_ftp as CodSituacaoArquivoFTP, '+
            '  tee.cod_situacao_email as CodSituacaoEmail, '+
            '  tse.des_situacao_email as DesSituacaoEmail, '+
            '  tar.dta_criacao_arquivo as DtaCriacaoArquivo, '+
            '  taf.dta_ultima_transferencia as DtaUltimaTransferencia, '+
            '  tee.dta_ultimo_envio as DtaUltimoEnvio, '+
            '  tar.ind_envio_pedido_email as IndEnvioPedidoEmail, '+
            '  tar.ind_envio_pedido_ftp as IndEnvioPedidoFTP, '+
            '  tar.nom_arquivo_remessa_pedido as NomArquivoRemessaPedido, '+
            '  tar.nom_arquivo_ficha_pedido as NomArquivoFichaPedido, '+
            '  tfi.nom_reduzido_fabricante as NomReduzidoFabricante, '+
            '  tar.num_remessa_fabricante as NumRemessaFabricante, '+
            '  tar.qtd_bytes_arquivo_remessa as QtdBytesArquivoRemessa, '+
            '  tar.qtd_bytes_arquivo_ficha as QtdBytesArquivoFicha, '+
            '  tsa.sgl_situacao_arquivo_ftp as SglSituacaoArquivoFTP, '+
            '  tse.sgl_situacao_email as SglSituacaoEmail, '+
            '  tsa.des_situacao_arquivo_ftp as DesSituacaoArquivoFTP, '+
            '  tar.cod_usuario_criacao as CodUsuarioCriacao,          '+
            '  (select nom_pessoa from tab_pessoa where              '+
            '    cod_pessoa = (select cod_pessoa from tab_usuario '+
            '       where cod_usuario = tar.cod_usuario_criacao)) as NomUsuarioCriacao,  '+
            '  tar.num_pedido_fabricante_inicio as NumPedidoFabricanteInicio, '+
            '  tar.qtd_pedidos_remessa as QtdPedidosRemessa, '+
            '  (select val_parametro_sistema from tab_parametro_sistema where cod_parametro_sistema = 85) TxtCaminho, '+
            '   tar.cod_tipo_arquivo_remessa as CodTipoArquivoRemessa, '+
            '  (select des_tipo_arquivo_remessa from tab_tipo_arquivo_remessa '+
            '       where cod_tipo_arquivo_remessa =    tar.cod_tipo_arquivo_remessa ) as DesTipoArquivoRemessa '+
            'from '+
            '  tab_arquivo_remessa_pedido tar '+
            '  left join tab_arquivo_ftp_envio taf '+
            '     on taf.cod_arquivo_ftp_envio = tar.cod_arquivo_ftp_envio '+
       	    '  left join tab_email_envio tee '+
            '     on tee.cod_email_envio = tar.cod_email_envio '+
            '  left join tab_fabricante_identificador tfi '+
            '     on tfi.cod_fabricante_identificador = tar.cod_fabricante_identificador '+
            '  left join tab_situacao_arquivo_ftp tsa '+
            '     on tsa.cod_situacao_arquivo_ftp = taf.cod_situacao_arquivo_ftp '+
            '  left join tab_situacao_email tse '+
            '     on tse.cod_situacao_email = tee.cod_situacao_email '+
            'where '+
            '  tar.cod_arquivo_remessa_pedido = :cod_arquivo_remessa_pedido ';
      Q.ParamByName('cod_arquivo_remessa_pedido').AsInteger := CodArquivoRemessaPedido;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(1756, Self.ClassName, NomeMetodo, []);
        Result := -1756;
        Exit;
      end;

      FIntArquivoRemessaPedido.CodArquivoFTPEnvio           := Q.FieldByName('CodArquivoFTPEnvio').AsInteger;
      FIntArquivoRemessaPedido.CodArquivoRemessaPedido      := Q.FieldByName('CodArquivoRemessaPedido').AsInteger;
      FIntArquivoRemessaPedido.CodEmailEnvio                := Q.FieldByName('CodEmailEnvio').AsInteger;
      FIntArquivoRemessaPedido.CodFabricanteIdentificador   := Q.FieldByName('CodFabricanteIdentificador').AsInteger;
      FIntArquivoRemessaPedido.CodSituacaoArquivoFTP        := Q.FieldByName('CodSituacaoArquivoFTP').AsInteger;
      FIntArquivoRemessaPedido.CodSituacaoEmail             := Q.FieldByName('CodSituacaoEmail').AsInteger;
      FIntArquivoRemessaPedido.DesSituacaoEmail             := Q.FieldByName('DesSituacaoEmail').AsString;
      FIntArquivoRemessaPedido.DtaCriacaoArquivo            := Q.FieldByName('DtaCriacaoArquivo').AsDateTime;
      FIntArquivoRemessaPedido.DtaUltimaTransferencia       := Q.FieldByName('DtaUltimaTransferencia').AsDateTime;
      FIntArquivoRemessaPedido.DtaUltimoEnvio               := Q.FieldByName('DtaUltimoEnvio').AsDateTime;
      FIntArquivoRemessaPedido.IndEnvioPedidoEmail          := Q.FieldByName('IndEnvioPedidoEmail').AsString;
      FIntArquivoRemessaPedido.IndEnvioPedidoFTP            := Q.FieldByName('IndEnvioPedidoFTP').AsString;
      FIntArquivoRemessaPedido.NomArquivoRemessaPedido      := Q.FieldByName('NomArquivoRemessaPedido').AsString;
      FIntArquivoRemessaPedido.NomArquivoFichaPedido        := Q.FieldByName('NomArquivoFichaPedido').AsString;
      FIntArquivoRemessaPedido.NomReduzidoFabricante        := Q.FieldByName('NomReduzidoFabricante').AsString;
      FIntArquivoRemessaPedido.QtdBytesArquivoRemessa       := Q.FieldByName('QtdBytesArquivoRemessa').AsInteger;
      FIntArquivoRemessaPedido.QtdBytesArquivoFicha         := Q.FieldByName('QtdBytesArquivoFicha').AsInteger;
      FIntArquivoRemessaPedido.SglSituacaoArquivoFTP        := Q.FieldByName('SglSituacaoArquivoFTP').AsString;
      FIntArquivoRemessaPedido.SglSituacaoEmail             := Q.FieldByName('SglSituacaoEmail').AsString;
      FIntArquivoRemessaPedido.DesSituacaoArquivoFTP        := Q.FieldByName('DesSituacaoArquivoFTP').AsString;
      FIntArquivoRemessaPedido.NumRemessaFabricante         := Q.FieldByName('NumRemessaFabricante').AsInteger;
      FIntArquivoRemessaPedido.NumPedidoFabricanteInicio    := Q.FieldByName('NumPedidoFabricanteInicio').AsInteger;
      FIntArquivoRemessaPedido.QtdPedidosRemessa            := Q.FieldByName('QtdPedidosRemessa').AsInteger;
      FIntArquivoRemessaPedido.CodUsuarioCriacao            := Q.FieldByName('CodUsuarioCriacao').AsInteger;
      FIntArquivoRemessaPedido.NomUsuarioCriacao            := Q.FieldByName('NomUsuarioCriacao').AsString;
      FIntArquivoRemessaPedido.TxtCaminho                   := Q.FieldByName('TxtCaminho').AsString;
      FIntArquivoRemessaPedido.CodTipoArquivoRemessa        := Q.FieldByName('CodTipoArquivoRemessa').AsInteger;
      FIntArquivoRemessaPedido.DesTipoArquivoRemessa        := Q.FieldByName('DesTipoArquivoRemessa').AsString;

      // Identifica procedimento como bem sucedido
      Result := 0;
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(1755, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1755;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

//Pesquisa por arquivos de remessa de pedido de identificadoes gerados pelo sistema
//de acordo com os critérios especificados.
function TIntArquivosRemessaPedido.Pesquisar(DtaCriacaoArquivoInicio,
  DtaCriacaoArquivoFim: TDateTime; CodFabricanteIdentificador,
  NumRemessaFabricante, NumPedidoFabricante: Integer; const IndEnvioPedidoEmail: WideString;
  CodSituacaoEmail: Integer; const IndEnvioPedidoFTP: WideString;
  CodSituacaoArquivoFTP: Integer): Integer;
const
  CodMetodo: Integer = 547;
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select                                                           ');
  Query.SQL.Add(' tar.cod_arquivo_remessa_pedido as CodArquivoRemessaPedido,      ');
  Query.SQL.Add(' tar.dta_criacao_arquivo as DtaCriacaoArquivo,                   ');
  Query.SQL.Add(' tar.cod_fabricante_identificador as CodFabricanteIdentificador, ');
  Query.SQL.Add(' tfi.nom_reduzido_fabricante as NomReduzidoFabricante,           ');
  Query.SQL.Add(' tar.num_remessa_fabricante as NumRemessaFabricante,             ');
  Query.SQL.Add(' tar.num_pedido_fabricante_inicio as NumPedidoFabricanteInicio,   ');
  Query.SQL.Add(' tar.qtd_pedidos_remessa as QtdPedidosRemessa,                   ');
  Query.SQL.Add(' tar.ind_envio_pedido_email as IndEnvioArquivoEmail,             ');
  Query.SQL.Add(' tse.sgl_situacao_email as SglSituacaoEmail,                     ');
  Query.SQL.Add(' tar.ind_envio_pedido_ftp as IndEnvioArquivoFTP,                 ');
  Query.SQL.Add(' tsa.sgl_situacao_arquivo_ftp as SglSituacaoArquivoFTP           ');
  Query.SQL.Add('from                                                             ');
  Query.SQL.Add(' tab_arquivo_remessa_pedido tar                                  ');
  Query.SQL.Add('  left join tab_arquivo_ftp_envio taf                            ');
  Query.SQL.Add('     on taf.cod_arquivo_ftp_envio = tar.cod_arquivo_ftp_envio    ');
  Query.SQL.Add('  left join tab_email_envio tee                                  ');
  Query.SQL.Add('     on tee.cod_email_envio = tar.cod_email_envio                ');
  Query.SQL.Add('  left join tab_fabricante_identificador tfi                     ');
  Query.SQL.Add('     on tfi.cod_fabricante_identificador = tar.cod_fabricante_identificador ');
  Query.SQL.Add('  left join tab_situacao_arquivo_ftp tsa                            ');
  Query.SQL.Add('     on tsa.cod_situacao_arquivo_ftp = taf.cod_situacao_arquivo_ftp ');
  Query.SQL.Add('  left join tab_situacao_email tse                                  ');
  Query.SQL.Add('     on tse.cod_situacao_email = tee.cod_situacao_email             ');
  Query.SQL.Add('  where tfi.dta_fim_validade is null                                ');

  if (DtaCriacaoArquivoInicio > 0) then
  begin
    Query.SQL.Add(' and tar.dta_criacao_arquivo >= :Dta_Criacao_Arquivo_Inicio ');
    Query.ParamByName('Dta_Criacao_Arquivo_Inicio').AsDateTime := Trunc(DtaCriacaoArquivoInicio);
  end;
  if (DtaCriacaoArquivoFim > 0) then
  begin
    Query.SQL.Add(' and tar.dta_criacao_arquivo < :Dta_Criacao_Arquivo_Fim ');
    Query.ParamByName('Dta_Criacao_Arquivo_Fim').AsDateTime := Trunc(DtaCriacaoArquivoFim)+1;
  end;

  if (CodFabricanteIdentificador > 0) then
  begin
    Query.SQL.Add(' and tfi.cod_fabricante_identificador = :cod_fabricante_identificador');
    Query.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
  end;

  if (NumRemessaFabricante > 0) then
  begin
    Query.SQL.Add(' and tar.num_remessa_fabricante = :num_remessa_fabricante');
    Query.ParamByName('num_remessa_fabricante').AsInteger := NumRemessaFabricante;
  end;

  if (NumPedidoFabricante > 0) then
  begin
    Query.SQL.Add(' and :num_pedido between tar.num_pedido_fabricante_inicio and ((tar.num_pedido_fabricante_inicio + tar.qtd_pedidos_remessa)-1) ');
    Query.ParamByName('num_pedido').AsInteger := NumPedidoFabricante;
  end;

  if (IndEnvioPedidoEmail <> '') then
  begin
    Query.SQL.Add(' and tar.ind_envio_pedido_email = :ind_envio_pedido_email');
    Query.ParamByName('ind_envio_pedido_email').AsString := IndEnvioPedidoEmail;
  end;

  if (CodSituacaoEmail > 0) then
  begin
    Query.SQL.Add(' and tse.cod_situacao_email = :cod_situacao_email');
    Query.ParamByName('cod_situacao_email').AsInteger := CodSituacaoEmail;
  end;

  if (IndEnvioPedidoFTP <> '') then
  begin
    Query.SQL.Add(' and tar.ind_envio_pedido_ftp = :ind_envio_pedido_ftp');
    Query.ParamByName('ind_envio_pedido_ftp').AsString := IndEnvioPedidoFTP;
  end;

  if (CodSituacaoArquivoFTP > 0) then
  begin
    Query.SQL.Add(' and tsa.cod_situacao_arquivo_ftp = :cod_situacao_arquivo_ftp');
    Query.ParamByName('cod_situacao_arquivo_ftp').AsInteger := CodSituacaoArquivoFTP;
  end;
  Query.SQL.Add('order by tar.dta_criacao_arquivo desc ');

  try
    Query.Open;
    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1757, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1757;
      Exit;
    end;
  end;

end;

function TIntArquivosRemessaPedido.GerarNovaRemessa(
  CodFabricanteIdentificador: Integer): Integer;
const
  CodMetodo: Integer = 580;
  CodAplicativo: Integer = 5;
  NomeMetodo: String = 'GerarNovaRemessa';
var
  Q, QAux: THerdomQueryNavegacao;
  TxtCaminhoArquivo, nom_arquivo_remessa, nom_arquivo_ficha, MsgErro,
  AssuntoEmail, CorpoEmail, NomCertificadora, NomReduzidoCertificadora,
  TxtMensagemErro: String;
  CodArquivoRemessaNovo, QtdBytesArquivoFicha, QtdBytesArquivoRemessa, CodEmailEnvio,
  CodFTPEnvio, NumPedidoFabricanteSeq: Integer;

  procedure ObtemDadosCertificadora(CodCertificadora: Integer);
  begin
    QAux.Close;
    QAux.SQL.Clear;
    QAux.SQL.Add('select nom_pessoa, nom_reduzido_pessoa from tab_pessoa ');
    QAux.SQL.Add(' where cod_pessoa = :cod_certificadora ');
    QAux.ParamByName('cod_certificadora').AsInteger := CodCertificadora;
    QAux.Open;
    NomCertificadora         := QAux.FieldByName('nom_pessoa').AsString;
    NomReduzidoCertificadora := QAux.FieldByName('nom_reduzido_pessoa').AsString;
  end;

  procedure PreparaCorpoEmail;
  begin
    AssuntoEmail := AnsiReplaceStr(AssuntoEmail, '<NomReduzidoCertificadora>', NomReduzidoCertificadora);
    AssuntoEmail := AnsiReplaceStr(AssuntoEmail, '<NumRemessaFabricante>', IntToStr(Q.FieldByName('NumRemessaFabricante').AsInteger));

    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomFabricanteIdentificador>', Q.FieldByName('NomFabricanteIdentificador').AsString);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomReduzidoFabricante>', Q.FieldByName('NomReduzidoFabricante').AsString);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomCertificadora>', NomCertificadora);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomReduzidoCertificadora>', NomReduzidoCertificadora);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NumRemessaFabricante>', IntToStr(Q.FieldByName('NumRemessaFabricante').AsInteger));
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<QtdPedidosRemessa>', IntToStr(Q.RecordCount));
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NumPedidoFabricanteInicio>', IntToStr(Q.FieldByName('NumPedidoFabricante').AsInteger));
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NumPedidoFabricanteFim>', IntToStr((Q.FieldByName('NumPedidoFabricante').AsInteger+Q.RecordCount)-1));
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomArquivoRemessaPedido>', nom_arquivo_remessa);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomArquivoFichaPedido>', nom_arquivo_ficha);
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtEmailContatoCertificadora>', ValorParametro(86));
    CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtEmailContatoHerdom>', ValorParametro(87));
  end;

  procedure ObtemModeloEmail;
  begin
    With QAux do begin
        Close;
        SQL.Clear;
        SQL.Add('select txt_assunto, txt_corpo_email     ');
        SQL.Add(' from tab_modelo_email where            ');
        SQL.Add(' cod_modelo_email = :cod_modelo_email   ');
        if Q.FieldByName('CodTipoArquivoRemessa').AsInteger = 1 then
          ParamByName('cod_modelo_email').AsInteger := 1
        else
          ParamByName('cod_modelo_email').AsInteger := 2;
        Open;
        CorpoEmail   := FieldByName('txt_corpo_email').AsString;
        AssuntoEmail := FieldByName('txt_assunto').AsString;
    end;
  end;

begin
  Result          := -1;
  QtdBytesArquivoRemessa := -1;
  CodEmailEnvio   := -1;
  CodFTPEnvio     := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  //define os objetos como não instanciados
  Q := nil;
  QAux := nil;
  FIntPedidosIdentificadores := nil;
  FIntEmailsEnvio := nil;
  FIntArquivosFTPEnvio := nil;
  FIntOcorrenciasSistema := nil;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;
  
  try
    Q := THerdomQueryNavegacao.Create(nil);
    Q.SQLConnection := Conexao.SQLConnection;
    QAux := THerdomQueryNavegacao.Create(nil);
    QAux.SQLConnection := Conexao.SQLConnection;
    FIntPedidosIdentificadores := TPedidoIdentificador.Create(Conexao, Mensagens);
    FIntEmailsEnvio := TIntEmailsEnvio.Create;
    FIntArquivosFTPEnvio := TIntArquivosFTPEnvio.Create;
    FIntOcorrenciasSistema := TIntOcorrenciasSistema.Create;

    try
      with Q do
      begin
       SQL.Clear;
       {$IFDEF MSSQL}
        SQL.Add(' select 1 from tab_fabricante_identificador ');
        SQL.Add('  where cod_fabricante_identificador = :cod_fabricante_identificador ');
        SQL.Add('  and dta_fim_validade is null ');
        {$ENDIF}
        ParamByName('cod_fabricante_identificador').AsInteger      := CodFabricanteIdentificador;
        Open;
        if IsEmpty then
        begin
          Mensagens.Adicionar(1955, Self.ClassName, NomeMetodo, []);
          Result := -1955;
          Exit;
        end;
      end;

      with Q do
      begin
        SQL.Clear;
        {$IFDEF MSSQL}
        SQL.Add('exec spt_buscar_fabricante_identificador ' + IntToStr(CodFabricanteIdentificador));
        {$ENDIF}
        Open;
        if IsEmpty then
        begin
          Mensagens.Adicionar(1905, Self.ClassName, NomeMetodo, []);
          Result := -1905;
          Exit;
        end;
      end;

      //Inicialização da classe de Ocorrencias Sistema
      Result := FIntOcorrenciasSistema.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;
      //Inicialização da classe de EmaisEnvio
      Result := FIntEmailsEnvio.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;
      //Inicialização da classe de ArquivosFTPEnvio
      Result := FIntArquivosFTPEnvio.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;
      
      //************************************************************************
      //Verifica se há números de pedidos suficiente para os pedidos que irão
      //compor a nova remessa a ser gerada
      //************************************************************************
      if (Q.FieldByName('NumMaximoPedido').AsInteger) < (Q.FieldByName('NumUltimoPedido').AsInteger + Q.RecordCount) then
      begin
        Mensagens.Adicionar(1916, Self.ClassName, NomeMetodo, []);
        Result := FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
         'O número de pedidos a ser gerado é maior que o número máximo de pedidos para o fabricante.',
         Q.FieldByName('NomFabricanteIdentificador').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço');
        Result := -1916;
        Exit;
      end;

      //Monta os nomes dos arquivos de remessa e de ficha de pedido
      if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
      begin
        nom_arquivo_remessa := UpperCase(Q.FieldByName('NomReduzidoFabricante').AsString+'_'+PadL(IntToStr(Q.FieldByName('NumRemessaFabricante').AsInteger), '0', 9)+'_'+Q.FieldByName('TxtExtensaoArquivo').AsString+'.ZIP');
      end
      else
      begin
        nom_arquivo_remessa := '';
      end;
      nom_arquivo_ficha   := UpperCase(Q.FieldByName('NomReduzidoFabricante').AsString+'_'+PadL(IntToStr(Q.FieldByName('NumRemessaFabricante').AsInteger), '0', 9)+'_PDF.ZIP');

      //Obtem o caminho onde o arquivo será gravado - Este varia de acordo com cada certificadora
      TxtCaminhoArquivo := ValorParametro(85);
      if (Length(TxtCaminhoArquivo)=0) or (TxtCaminhoArquivo[Length(TxtCaminhoArquivo)]<>'\') then begin
        TxtCaminhoArquivo := TxtCaminhoArquivo + '\';
      end;

      //Verifica a existência do diretório informado      
      if not DirectoryExists(TxtCaminhoArquivo) then
      begin
        if not ForceDirectories(TxtCaminhoArquivo) then
        begin
          Mensagens.Adicionar(1906, Self.ClassName, NomeMetodo, []);
          Result := FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'O caminho para armazenamento do arquivo de remessa não foi encontrado.',
             TxtCaminhoArquivo, 'Caminho buscado pelo sistema para armazenamento do arquivo ');
          Result := -1906;
          Exit;
        end;
      end;
      NumPedidoFabricanteSeq := Q.FieldByName('NumPedidoFabricante').AsInteger;

      //chama procedimento que obtem nome da pessoa e o seu nome reduzido levando seu código
      ObtemDadosCertificadora(StrToInt(ValorParametro(4)));


      //*****************************************************************
      //Inicialização dos arquivos de Remessa e Arquivos de Ficha
      //*****************************************************************
      FIntPedidosIdentificadores.PedidoIdentificadores.CodTipoArquivoRemessa       := Q.FieldByName('CodTipoArquivoRemessa').AsInteger;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomArquivoRemessaPedido     := nom_arquivo_remessa;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomArquivoFichaPedido       := nom_arquivo_ficha;
      FIntPedidosIdentificadores.PedidoIdentificadores.TxtCaminhoArquivo           := TxtCaminhoArquivo;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomFabricanteIdentificador  := Q.FieldByName('NomFabricanteIdentificador').AsString;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomReduzidoFabricante       := Q.FieldByName('NomReduzidoFabricante').AsString;
      FIntPedidosIdentificadores.PedidoIdentificadores.NumCNPJFabricante           := Q.FieldByName('NumCNPJFabricante').AsString;
      FIntPedidosIdentificadores.PedidoIdentificadores.NumOrdemServico             := Q.FieldByName('NumOrdemServico').AsInteger;
      FIntPedidosIdentificadores.PedidoIdentificadores.DtaPedido                   := Q.FieldByName('DtaPedido').AsDateTime;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomUsuarioPedido            := Q.FieldByName('NomUsuarioPedido').AsString;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomTratamentoUsuarioPedido  := Q.FieldByName('NomTratamentoUsuarioPedido').AsString;
      FIntPedidosIdentificadores.PedidoIdentificadores.NumRemessaFabricante        := Q.FieldByName('NumRemessaFabricante').AsInteger;
      FIntPedidosIdentificadores.PedidoIdentificadores.NumPedidoFabricante         := NumPedidoFabricanteSeq;
      FIntPedidosIdentificadores.PedidoIdentificadores.NomCertificadora            := NomCertificadora;


      if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
      begin
        Result := FIntPedidosIdentificadores.InicializarArquivoRemessa;
        if Result < 0 then
        begin
          FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'Erro ao inicializar arquivo de remessa.',
             Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço ');
          exit;
        end;
      end;
      Result := FIntPedidosIdentificadores.InicializarArquivoFicha;
      if Result < 0 then
      begin
        FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
          'Erro ao inicializar arquivo de ficha.',
           Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço ');
        Exit;
      end;

      //Obtem novo codigo de arquivo remessa de pedido
      Result := ObterCodArquivoRemessa(CodArquivoRemessaNovo);
      if Result < 0 then
      begin
        FIntPedidosIdentificadores.CancelarArquivoRemessa;
        FIntPedidosIdentificadores.CancelarArquivoFicha;
        MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
        Result:= -1;
        Exit;
      end;

      //Abre transação com o banco
      BeginTran;
      //Insere ocorrência de geração dos arquivos na tab_arquivo_remessa_pedido
      with QAux do
      begin
        SQL.Add('insert into tab_arquivo_remessa_pedido ');
        SQL.Add('(cod_arquivo_remessa_pedido,    ');
        SQL.Add(' nom_arquivo_remessa_pedido,    ');
        SQL.Add(' nom_arquivo_ficha_pedido,      ');
        SQL.Add(' cod_tipo_arquivo_remessa,      ');
        SQL.Add(' qtd_bytes_arquivo_remessa,     ');
        SQL.Add(' qtd_bytes_arquivo_ficha,       ');        
        SQL.Add(' cod_fabricante_identificador,  ');
        SQL.Add(' num_pedido_fabricante_inicio,  ');
        SQL.Add(' num_remessa_fabricante,        ');
        SQL.Add(' qtd_pedidos_remessa,           ');
        SQL.Add(' ind_envio_pedido_email,        ');
        SQL.Add(' ind_envio_pedido_ftp,          ');
        SQL.Add(' cod_email_envio,               ');
        SQL.Add(' cod_arquivo_ftp_envio,         ');
        SQL.Add(' dta_criacao_arquivo,           ');
        SQL.Add(' cod_usuario_criacao)           ');
        SQL.Add(' values                         ');
        SQL.Add('(:cod_arquivo_remessa_pedido,   ');
        if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
        begin
           SQL.Add(' :nom_arquivo_remessa_pedido,');
        end
        else
        begin
           SQL.Add('  NULL,                      ');
        end;
        SQL.Add(' :nom_arquivo_ficha_pedido,     ');
        SQL.Add(' :cod_tipo_arquivo_remessa,     ');
        SQL.Add(' null,                          ');
        SQL.Add(' null,                          ');        
        SQL.Add(' :cod_fabricante_identificador, ');
        SQL.Add(' :num_pedido_fabricante_inicio, ');
        SQL.Add(' :num_remessa_fabricante,       ');
        SQL.Add(' :qtd_pedidos_remessa,          ');
        SQL.Add(' :ind_envio_pedido_email,       ');
        SQL.Add(' :ind_envio_pedido_ftp,         ');
        SQL.Add(' null,                          ');
        SQL.Add(' null,                          ');
        SQL.Add(' getdate(),                     ');
        SQL.Add(' :cod_usuario_criacao)          ');
        ParamByName('cod_arquivo_remessa_pedido').AsInteger   := CodArquivoRemessaNovo;
        if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
        begin
          ParamByName('nom_arquivo_remessa_pedido').AsString  := nom_arquivo_remessa;
        end;

        ParamByName('nom_arquivo_ficha_pedido').AsString      := nom_arquivo_ficha;
        ParamByName('cod_tipo_arquivo_remessa').AsInteger     := Q.FieldByName('CodTipoArquivoRemessa').AsInteger;
        ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
        ParamByName('num_pedido_fabricante_inicio').AsInteger := NumPedidoFabricanteSeq;
        ParamByName('num_remessa_fabricante').AsInteger       := Q.FieldByName('NumRemessaFabricante').AsInteger;
        ParamByName('qtd_pedidos_remessa').AsInteger          := Q.RecordCount;
        ParamByName('ind_envio_pedido_email').AsString        := Q.FieldByName('IndEnvioPedidoEmail').AsString;
        ParamByName('ind_envio_pedido_ftp').AsString          := Q.FieldByName('IndEnvioPedidoFTP').AsString;
        ParamByName('cod_usuario_criacao').AsInteger          := Conexao.CodUsuario;
        ExecSQL;
      end;    

      //Inicia o LOOP para as ordens de serviço encontradas do Fabricante indicado no paramentro
      while not Q.Eof do
      begin
        FIntPedidosIdentificadores.PedidoIdentificadores.NomFabricanteIdentificador  := Q.FieldByName('NomFabricanteIdentificador').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NomReduzidoFabricante       := Q.FieldByName('NomReduzidoFabricante').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumCNPJFabricante           := Q.FieldByName('NumCNPJFabricante').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodCertificadoraFabricante  := Q.FieldByName('CodCertificadoraFabricante').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumRemessaFabricante        := Q.FieldByName('NumRemessaFabricante').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.IndAnimaisRegistrados       := Q.FieldByName('IndAnimaisRegistrados').AsString;

        //********************************************************
        //  OBTEM DADOS DO ENDERECO PARA PROPRIEDADE RURAL
        //********************************************************
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomPessoaContato  := Q.FieldByName('NomPessoaContatoPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NumTelefone       := Q.FieldByName('NumTelefonePR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NumFax            := Q.FieldByName('NumFaxPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomLogradouro     := Q.FieldByName('NomLogradouroPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomBairro         := Q.FieldByName('NomBairroPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NumCEP            := Q.FieldByName('NumCEPPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.CodDistrito       := Q.FieldByName('CodDistritoPR').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomDistrito       := Q.FieldByName('NomDistritoPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.CodMunicipio      := Q.FieldByName('CodMunicipioPR').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NumMunicipioIBGE  := Q.FieldByName('NumMunicipioIBGEPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomMunicipio      := Q.FieldByName('NomMunicipioPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.CodEstado         := Q.FieldByName('CodEstadoPR').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado         := Q.FieldByName('SglEstadoPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomEstado         := Q.FieldByName('NomEstadoPR').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.CodPais           := Q.FieldByName('CodPaisPR').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoPropriedadeRural.NomPais           := Q.FieldByName('NomPaisPR').AsString;

        //********************************************************
        //  OBTEM DADOS DO ENDERECO DE CONBRANÇA DE IDENTIFICADORES
        //********************************************************
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodEndereco       := Q.FieldByName('CodEnderecoCobrancaIdent').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodTipoEndereco   := Q.FieldByName('CodTipoEnderecoCI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.SglTipoEndereco   := Q.FieldByName('SglTipoEnderecoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.DesTipoEndereco   := Q.FieldByName('DesTipoEnderecoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato  := Q.FieldByName('NomPessoaContatoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NumTelefone       := Q.FieldByName('NumTelefoneCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NumFax            := Q.FieldByName('NumFaxCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.TxtEmail          := Q.FieldByName('TxtEmailCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro     := Q.FieldByName('NomLogradouroCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro         := Q.FieldByName('NomBairroCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP            := Q.FieldByName('NumCEPCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodDistrito       := Q.FieldByName('CodDistritoCI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomDistrito       := Q.FieldByName('NomDistritoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodMunicipio      := Q.FieldByName('CodMunicipioCI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NumMunicipioIBGE  := Q.FieldByName('NumMunicipioIBGECI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio      := Q.FieldByName('NomMunicipioCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodEstado         := Q.FieldByName('CodEstadoCI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.SglEstado         := Q.FieldByName('SglEstadoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomEstado         := Q.FieldByName('NomEstadoCI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.CodPais           := Q.FieldByName('CodPaisCI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoCobrancaIdent.NomPais           := Q.FieldByName('NomPaisCI').AsString;

        //********************************************************
        //  OBTEM DADOS DO ENDERECO DE ENTREGA DE IDENTIFICADORES
        //********************************************************
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodEndereco       := Q.FieldByName('CodEnderecoEntregaIdent').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodTipoEndereco   := Q.FieldByName('CodTipoEnderecoEI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.SglTipoEndereco   := Q.FieldByName('SglTipoEnderecoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.DesTipoEndereco   := Q.FieldByName('DesTipoEnderecoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomPessoaContato  := Q.FieldByName('NomPessoaContatoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NumTelefone       := Q.FieldByName('NumTelefoneEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NumFax            := Q.FieldByName('NumFaxEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.TxtEmail          := Q.FieldByName('TxtEmailEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomLogradouro     := Q.FieldByName('NomLogradouroEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomBairro         := Q.FieldByName('NomBairroEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NumCEP            := Q.FieldByName('NumCEPEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodDistrito       := Q.FieldByName('CodDistritoEI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomDistrito       := Q.FieldByName('NomDistritoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodMunicipio      := Q.FieldByName('CodMunicipioEI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NumMunicipioIBGE  := Q.FieldByName('NumMunicipioIBGEEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomMunicipio      := Q.FieldByName('NomMunicipioEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodEstado         := Q.FieldByName('CodEstadoEI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.SglEstado         := Q.FieldByName('SglEstadoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomEstado         := Q.FieldByName('NomEstadoEI').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.CodPais           := Q.FieldByName('CodPaisEI').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.EnderecoEntregaIdent.NomPais           := Q.FieldByName('NomPaisEI').AsString;

        //Obtem o restante dos dados para a geração do arquivo.
        FIntPedidosIdentificadores.PedidoIdentificadores.NumPedidoFabricante         := NumPedidoFabricanteSeq;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumOrdemServico             := Q.FieldByName('NumOrdemServico').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.SglProdutor                 := Q.FieldByName('SglProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NomProdutor                 := Q.FieldByName('NomProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NomReduzidoProdutor         := Q.FieldByName('NomReduzidoProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodNaturezaPessoa           := Q.FieldByName('CodNaturezaPessoa').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumCNPJCPFProdutor          := Q.FieldByName('NumCNPJCPFProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumCNPJCPFProdutorFormatado := FormataCnpjCpf(Q.FieldByName('NumCNPJCPFProdutor').AsString);
        FIntPedidosIdentificadores.PedidoIdentificadores.NumTelefoneProdutor         := Q.FieldByName('NumTelefoneProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumFaxProdutor              := Q.FieldByName('NumFaxProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.TxtEMailProdutor            := Q.FieldByName('TxtEMailProdutor').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumImovelReceitaFederal     := Q.FieldByName('NumImovelReceitaFederal').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NomFazenda                  := Q.FieldByName('NomFazenda').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.SglEstadoFazenda            := Q.FieldByName('SglEstadoFazenda').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumPropriedadeRuralFazenda  := Q.FieldByName('NumPropriedadeRuralFazenda').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.QtdAnimais                  := Q.FieldByName('QtdAnimais').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumSolicitacaoSISBOV        := Q.FieldByName('NumSolicitacaoSISBOV').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodPaisSISBOV               := Q.FieldByName('CodPaisSISBOV').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodEstadoSISBOV             := Q.FieldByName('CodEstadoSISBOV').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodMicroRegiaoSISBOV        := Q.FieldByName('CodMicroRegiaoSISBOV').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodAnimalSISBOVInicio       := Q.FieldByName('CodAnimalSISBOVInicio').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumDVSISBOVInicio           := Q.FieldByName('NumDVSISBOVInicio').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodAnimalSISBOVFim          := Q.FieldByName('CodAnimalSISBOVFim').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.NumDVSISBOVFim              := BuscarDVSisBov(Q.FieldByName('CodPaisSISBOV').AsInteger, Q.FieldByName('CodEstadoSISBOV').AsInteger,
                                              Q.FieldByName('CodMicroRegiaoSISBOV').AsInteger, Q.FieldByName('CodAnimalSISBOVFim').AsInteger);
        FIntPedidosIdentificadores.PedidoIdentificadores.SglIdentificacaoDupla       := Q.FieldByName('SglIdentificacaoDupla').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesIdentificacaoDupla       := Q.FieldByName('DesIdentificacaoDupla').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodFormaPagamentoFabricante := Q.FieldByName('CodFormaPagamentoFabricante').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesFormaPagamentoIdent      := Q.FieldByName('DesFormaPagamentoIdent').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodModeloFabricante1        := Q.FieldByName('CodModeloFabricante1').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesModeloIdentificador1     := Q.FieldByName('DesModeloIdentificador1').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodModeloFabricante2        := Q.FieldByName('CodModeloFabricante2').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesModeloIdentificador2     := Q.FieldByName('DesModeloIdentificador2').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodProdutoFabricante1       := Q.FieldByName('CodProdutoFabricante1').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesProdutoAcessorio1        := Q.FieldByName('DesProdutoAcessorio1').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.QtdProdutoAcessorio1        := Q.FieldByName('QtdProdutoAcessorio1').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodProdutoFabricante2       := Q.FieldByName('CodProdutoFabricante2').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesProdutoAcessorio2        := Q.FieldByName('DesProdutoAcessorio2').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.QtdProdutoAcessorio2        := Q.FieldByName('QtdProdutoAcessorio2').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.CodProdutoFabricante3       := Q.FieldByName('CodProdutoFabricante3').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.DesProdutoAcessorio3        := Q.FieldByName('DesProdutoAcessorio3').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.QtdProdutoAcessorio3        := Q.FieldByName('QtdProdutoAcessorio3').AsInteger;
        FIntPedidosIdentificadores.PedidoIdentificadores.DtaPedido                   := Q.FieldByName('DtaPedido').AsDateTime;
        FIntPedidosIdentificadores.PedidoIdentificadores.NomUsuarioPedido            := Q.FieldByName('NomUsuarioPedido').AsString;
        FIntPedidosIdentificadores.PedidoIdentificadores.TxtObservacaoPedido         := Q.FieldByName('TxtObservacaoPedido').AsString;

        FIntPedidosIdentificadores.PedidoIdentificadores.IndDescompactarArquivoZip   := Q.FieldByName('IndDescompactarArquivoZip').AsString;

        //Chama o procedimento para Gravar o arquivo de remessa e de ficha de pedido.
        if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
        begin
          Result := FIntPedidosIdentificadores.GravarPedidoArquivo;
          if Result < 0 then
          begin
            Rollback;
            FIntPedidosIdentificadores.CancelarArquivoRemessa;
            FIntPedidosIdentificadores.CancelarArquivoFicha;
            Begintran;
            FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
               'Erro ao gravar arquivo de remessa.',
            Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString+' \ '+nom_arquivo_remessa, 'Nome do Fabricante \ Número da Ordem de Serviço \ Nome do Arquivo de Remessa ');
            commit;
            exit;
          end;
        end;

        Result := FIntPedidosIdentificadores.GravarPedidoFicha;
        if Result < 0 then
        begin
          Rollback;
          FIntPedidosIdentificadores.CancelarArquivoRemessa;
          FIntPedidosIdentificadores.CancelarArquivoFicha;
          Begintran;
          FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'Erro ao gravar arquivo de ficha.',
           Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString+' \ '+nom_arquivo_ficha, 'Nome do Fabricante \ Número da Ordem de Serviço \ Nome do Arquivo de Ficha ');
          Commit;
          exit;
        end;

        //Atualiza os dados da Ordem de Serviço
        QAux.Close;
        with QAux do
        begin
          SQL.Clear;
          SQL.Add('update tab_ordem_servico ');
          SQL.Add('set ');
          SQL.Add(' cod_arquivo_remessa_pedido = :cod_arquivo_remessa_pedido, ');
          SQL.Add(' num_pedido_fabricante = :num_pedido_fabricante, ');
          SQL.Add(' dta_pedido = getdate(), ');
          SQL.Add(' cod_usuario_pedido = :cod_usuario ');
          SQL.Add('where ');
          SQL.Add(' cod_ordem_servico = :cod_ordem_servico ');

          ParamByName('num_pedido_fabricante').AsInteger       := NumPedidoFabricanteSeq;
          ParamByName('cod_arquivo_remessa_pedido').AsInteger  := CodArquivoRemessaNovo;
          ParamByName('cod_ordem_servico').AsInteger           := Q.FieldByName('CodOrdemServico').AsInteger;
          ParamByName('cod_usuario').AsInteger                 := Conexao.CodUsuario;
          ExecSQL;
        end;

       Result := TIntOrdensServico.MudarSituacao(Conexao, Mensagens, Q.FieldByName('CodOrdemServico').AsInteger, 6, '', 'S', 'S');
        if Result < 0 then //caso ocorra algum erro na mudança da situação, interrompe o processamento
        begin
          FIntPedidosIdentificadores.CancelarArquivoRemessa;
          FIntPedidosIdentificadores.CancelarArquivoFicha;
          RollBack;
          TxtMensagemErro := Mensagens.Items[Mensagens.Count - 1].Texto;
          Mensagens.Clear;
          Mensagens.Adicionar(1907, Self.ClassName, NomeMetodo, [Q.FieldByName('NumOrdemServico').AsString, TxtMensagemErro]);
          BeginTran;
          FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
            'Erro ao mudar a situação da Ordem de Serviço para "Pedidos de brincos já enviados".',
            Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço ');
          Commit;
          Result := -1907;
          Exit;
        end;
        Inc(NumPedidoFabricanteSeq);
        Q.Next;
      end;

      //Atualiza os dados do Fabricante de Identificador em questão
      QAux.Close;
      With QAux do
      begin
        SQL.Clear;
        SQL.Add('update tab_fabricante_identificador ');
        SQL.Add('set ');
        SQL.Add(' num_ultima_remessa  = :num_ultima_remessa, ');
        SQL.Add(' num_ultimo_pedido   = :num_ultimo_pedido ');
        SQL.Add('where ');
        SQL.Add(' cod_fabricante_identificador = :cod_fabricante_identificador ');

        ParamByName('num_ultima_remessa').AsInteger           := Q.FieldByName('NumRemessaFabricante').AsInteger;
        ParamByName('num_ultimo_pedido').AsInteger            := NumPedidoFabricanteSeq-1; //faz (-1) devido ao Inc nesta variavel no Loop anterior
        ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
        ExecSQL;
      end;

      //Finaliza os arquivos gerados
      if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
      begin
        QtdBytesArquivoRemessa := FIntPedidosIdentificadores.FinalizarArquivoRemessa;
        if QtdBytesArquivoRemessa < 0 then
        begin
          RollBack;
          BeginTran;
          FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'Erro ao finalizar arquivo de remessa.',
             Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString+' \ '+nom_arquivo_remessa, 'Nome do Fabricante \ Número da Ordem de Serviço \ Nome do Arquivo de Remessa ');
          Commit;
          Result := QtdBytesArquivoRemessa; //retorna codigo de erro!
          Exit;
        end;
      end;

      QtdBytesArquivoFicha := FIntPedidosIdentificadores.FinalizarArquivoFicha;
      if QtdBytesArquivoFicha < 0 then
      begin
        RollBack;
        BeginTran;
        FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
           'Erro ao finalizar arquivo de ficha.',
             Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString+' \ '+nom_arquivo_ficha, 'Nome do Fabricante \ Número da Ordem de Serviço \ Nome do Arquivo de Ficha ');
        Commit;
        Result := QtdBytesArquivoFicha;
        exit;
      end;

      //Caso o parametro IndEnvioPedidoEmail for "S"; Então envia email contendo os arquivos de remessa e de fichas
      //de pedido para o fabricante de identificadores
      if UpperCase(Q.FieldByName('IndEnvioPedidoEmail').AsString) = 'S' then
      begin
        ObtemModeloEmail;
        PreparaCorpoEmail;
        CodEmailEnvio := FIntEmailsEnvio.Inserir(1, AssuntoEmail, CorpoEmail);
        if CodEmailEnvio > 0 then
        begin
           Result := FIntEmailsEnvio.AdicionarDestinatario(CodEmailEnvio, Q.FieldByName('TxtEmailFabricante').AsString, 1, -1);
           if Result >= 0 then
           begin
             if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
             begin
               Result := FIntEmailsEnvio.AdicionarArquivoAnexo(CodEmailEnvio, nom_arquivo_remessa, TxtCaminhoArquivo);
             end;
             if Result >= 0 then
             begin
               Result := FIntEmailsEnvio.AdicionarArquivoAnexo(CodEmailEnvio, nom_arquivo_ficha, TxtCaminhoArquivo);
             end;
           end;
        end;

        if (Result < 0) or (CodEmailEnvio < 0) then
        begin
          RollBack;
          if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
          begin
             DeleteFile(TxtCaminhoArquivo + nom_arquivo_remessa);
          end;
          DeleteFile(TxtCaminhoArquivo + nom_arquivo_ficha);
          BeginTran;
          FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'Erro ao enviar email de remessa de pedido para fabricante.',
             Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço');
          Commit;
          if (CodEmailEnvio < 0)
          then
             Result := CodEmailEnvio;
          Exit;
        end
        else
        begin
          FIntEmailsEnvio.AlterarSituacaoParaPendente(CodEmailEnvio, 'S');
        end;
      end;

      //Caso o parametro IndEnvioPedidoFTP for "S"; Então envia os arquivos de remessa e de fichas de pedido para
      //o fabricante de identificadores via FTP
      if UpperCase(Q.FieldByName('IndEnvioPedidoFTP').AsString) = 'S' then
      begin
         if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
         begin
           Result := FIntArquivosFTPEnvio.Inserir(Q.FieldByName('CodRotinaFTPEnvio').AsInteger, nom_arquivo_remessa, nom_arquivo_remessa, TxtCaminhoArquivo, QtdBytesArquivoRemessa,
                                                  Q.FieldByName('IndDescompactarArquivoZip').AsString);
         end
         else
         begin
           Result := FIntArquivosFTPEnvio.Inserir(Q.FieldByName('CodRotinaFTPEnvio').AsInteger, nom_arquivo_ficha, nom_arquivo_ficha, TxtCaminhoArquivo, QtdBytesArquivoFicha,
                                                  Q.FieldByName('IndDescompactarArquivoZip').AsString);
         end;
         if Result < 0 then
         begin
           RollBack;
           if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
           begin
             DeleteFile(TxtCaminhoArquivo + nom_arquivo_remessa);
           end;
           DeleteFile(TxtCaminhoArquivo + nom_arquivo_ficha);
           BeginTran;
           FIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, 1,
             'Erro ao enviar arquivos de remessa de pedido via FTP.',
             Q.FieldByName('NomReduzidoFabricante').AsString+' \ '+Q.FieldByName('NumOrdemServico').AsString, 'Nome do Fabricante \ Número da Ordem de Serviço');
           Commit;
           Exit;
         end;
      end;
      
      //Atualiza os dados abaixo na tab_arquivo_remessa_pedido
      QAux.Close;
      with QAux do
      begin
        SQL.Clear;
        SQL.Add('update tab_arquivo_remessa_pedido ');
        SQL.Add('set ');
        SQL.Add(' qtd_bytes_arquivo_remessa = :qtd_bytes_arquivo_remessa,');
        SQL.Add(' qtd_bytes_arquivo_ficha   = :qtd_bytes_arquivo_ficha,  ');
        SQL.Add(' cod_email_envio       = :cod_email_envio,      ');
        SQL.Add(' cod_arquivo_ftp_envio = :cod_arquivo_ftp_envio ');
        SQL.Add('where ');
        SQL.Add(' cod_arquivo_remessa_pedido = :cod_arquivo_remessa_pedido ');

        if (Q.FieldByName('CodTipoArquivoRemessa').AsInteger > 1) then
        begin
          ParamByName('qtd_bytes_arquivo_remessa').AsInteger    := QtdBytesArquivoRemessa;
        end
        else
        begin
          ParamByName('qtd_bytes_arquivo_remessa').DataType := ftInteger;
          ParamByName('qtd_bytes_arquivo_remessa').Clear;
        end;

        ParamByName('qtd_bytes_arquivo_ficha').AsInteger      := QtdBytesArquivoFicha;
        if CodEmailEnvio > 0 then
        begin
          ParamByName('cod_email_envio').AsInteger          := CodEmailEnvio;
        end
        else
        begin
          ParamByName('cod_email_envio').DataType := ftInteger;
          ParamByName('cod_email_envio').Clear;
        end;

        if CodFTPEnvio > 0 then
        begin
          ParamByName('cod_arquivo_ftp_envio').AsInteger    := CodFTPEnvio;
        end
        else
        begin
          ParamByName('cod_arquivo_ftp_envio').DataType := ftInteger;
          ParamByName('cod_arquivo_ftp_envio').Clear;
        end;
        
        ParamByName('cod_arquivo_remessa_pedido').AsInteger   := CodArquivoRemessaNovo;
        ExecSQL;
      end;

      commit;
      //Retornar Aqui o codigo do arquivo gerado
      Result := CodArquivoRemessaNovo;
    finally
      if Assigned(FIntPedidosIdentificadores) then FIntPedidosIdentificadores.Free;
      if Assigned(FIntEmailsEnvio) then FIntEmailsEnvio.Free;
      if Assigned(FIntArquivosFTPEnvio) then FIntArquivosFTPEnvio.Free;
      if Assigned(FIntOcorrenciasSistema) then FIntOcorrenciasSistema.Free;
      if Assigned(Q) then Q.Free;
      if Assigned(QAux) then QAux.Free;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1908, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1908;
      Exit;
    end;
  end;
end;

function TIntArquivosRemessaPedido.ObterCodArquivoRemessa(var CodArquivoRemessaNovo: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodArquivoRemessa';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre transação
      BeginTran;
      // Executa um update que não afeta nenhuma linha para travar tabela
      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arquivo_remessa_pedido set cod_seq_arquivo_remessa_pedido = cod_seq_arquivo_remessa_pedido where cod_seq_arquivo_remessa_pedido is null');
      {$ENDIF}
      Q.ExecSQL;
      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arquivo_remessa_pedido), 0) + 1 as CodArquivoRemessaPedido from tab_seq_arquivo_remessa_pedido ');
      {$ENDIF}
      Q.Open;
      CodArquivoRemessaNovo := Q.FieldByName('CodArquivoRemessaPedido').AsInteger;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arquivo_remessa_pedido set cod_seq_arquivo_remessa_pedido = cod_seq_arquivo_remessa_pedido + 1');
      {$ENDIF}
      Q.ExecSQL;
      Q.Close;
      // Fecha a transação
      Commit;
      Result := 0;
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(1909, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1909;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosRemessaPedido.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
end;

end.
