// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 28/07/2004
// *  Documentação       : Envio Arquivos FTP - Definição das Classes.doc
// *                       classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo a ser (ou já)
// *                       enviado via FTP
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntArquivosFTPEnvio;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, Classes, sysutils, db, uConexao, uIntMensagens,
     uIntArquivoFTPEnvio, IdFTP, uIntOcorrenciasSistema, uLibZipM;


type
{ TIntArquivosFTPEnvio }
  TIntArquivosFTPEnvio = class(TIntClasseBDNavegacaoBasica)
  private
    FIntArquivoFTPEnvio : TIntArquivoFTPEnvio;
    function ObterCodArquivoFTPEnvio(var CodArquivoFTPEnvio: Integer): Integer;
    function ExecutarFTP(CodRotinaFTPEnvio: Integer;
                         TxtMaquinaRemota,
                         TxtPortaRemota,
                         TxtUsuarioMaquina,
                         TxtSenhaMaquina,
                         TxtCaminhoRemoto,
                         TxtArquivoRemoto,
                         TxtArquivoLocal: String;
                         ReadTimeOut: Integer;
                         var QtdDuracao: Integer;
                         var CodTipoMensagem: Integer;
                         var TxtMensagem: String): Integer;

    function InserirErroTransferenciaFTP(ECodArquivoFTPEnvio: Integer;
                                         ETxtMensagemErro: String): Integer;

    function LimparOcorrenciaTransferenciaFTP(ECodArquivoFTPEnvio: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Pesquisar(CodRotinaFTPEnvio: Integer; NomArquivoLocal: String;
                       CodTipoMensagem, CodSituacaoArquivoFTP: Integer;
                       DtaUltimaTransferenciaInicio, DtaUltimaTransferenciaFim: TDateTime;
                       IndAindaSemTransferencia: String): Integer;
    function Buscar(CodArquivoFTPEnvio: Integer): Integer;
    function Inserir(CodRotinaFTPEnvio: Integer; NomArquivoLocal, NomArquivoRemoto,
                     TxtCaminhoLocal: String; QtdBytesArquivo: Integer;
                     IndDescompactarArquivoZip: String): Integer; overload;
    function Inserir(CodRotinaFTPEnvio: Integer; NomArquivoLocal, NomArquivoRemoto,
                     TxtCaminhoLocal: String; QtdBytesArquivo: Integer;
                     IndDescompactarArquivoZip: String;
                     CodArquivoSisbov: Integer): Integer; overload;
    function AlterarSituacaoParaPendente(CodArquivoFTPEnvio: Integer): Integer;
    function Enviar(CodArquivoFTPEnvio, ReadTimeOut: Integer): Integer;

    function PesquisarErroFTPEnvio(ECodArquivoFTPEnvio: Integer): Integer;

    property IntArquivoFTPEnvio : TIntArquivoFTPEnvio read FIntArquivoFTPEnvio write FIntArquivoFTPEnvio;
  end;

implementation

uses Math, StrUtils, SqlExpr, uIntInterfaceSisbov;

constructor TIntArquivosFTPEnvio.Create;
begin
  inherited;
  FIntArquivoFTPEnvio := TIntArquivoFTPEnvio.Create;
end;

destructor TIntArquivosFTPEnvio.Destroy;
begin
  FIntArquivoFTPEnvio.Free;
  inherited;
end;

{ TIntArquivosFTPEnvio }
function TIntArquivosFTPEnvio.Pesquisar(CodRotinaFTPEnvio: Integer; NomArquivoLocal: String;
                                        CodTipoMensagem, CodSituacaoArquivoFTP: Integer;
                                        DtaUltimaTransferenciaInicio, DtaUltimaTransferenciaFim: TDateTime;
                                        IndAindaSemTransferencia: String): Integer;
const
  CodMetodo: Integer = 526;
  NomMetodo: String  = 'Pesquisar';
begin
  Result := -1;

  if Not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if Not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  if (DtaUltimaTransferenciaInicio = 0) and (DtaUltimaTransferenciaFim = 0) and (IndAindaSemTransferencia <> '') then begin
    Mensagens.Adicionar(1883, Self.ClassName, NomMetodo, []);
    Result := -1883;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select arq.cod_arquivo_ftp_envio        as CodArquivoFTPEnvio,      '+
                '       arq.cod_rotina_ftp_envio         as CodRotinaFTPEnvio,       '+
                '       rot.des_rotina_ftp_envio         as DesRotinaFTPEnvio,       '+
                '       arq.nom_arquivo_local            as NomArquivoLocal,         '+
                '       arq.qtd_bytes_arquivo            as QtdBytesArquivo,         '+
                '       arq.cod_tipo_mensagem            as CodTipoMensagem,         '+
                '       msg.des_tipo_mensagem            as DesTipoMensagem,         '+
                '       arq.cod_situacao_arquivo_ftp     as CodSituacaoArquivoFTP,   '+
                '       sit.sgl_situacao_arquivo_ftp     as SglSituacaoArquivoFTP,   '+
                '       arq.dta_ultima_transferencia     as DtaUltimaTransferencia,  '+
                '       arq.qtd_vezes_transferencia      as QtdVezesTransferencia,   '+
                '       tu.nom_usuario                   as NomUsuario,              '+
                '       arq.cod_usuario_insercao         as CodUsuario,              '+
                '       tu.cod_papel                     as CodPapelUsuario          '+
                '  from tab_arquivo_ftp_envio     arq,                               '+
                '       tab_situacao_arquivo_ftp  sit,                               '+
                '       tab_rotina_ftp_envio      rot,                               '+
                '       tab_tipo_mensagem         msg,                               '+
                '       tab_usuario               tu                                 '+
                ' where arq.cod_rotina_ftp_envio      = rot.cod_rotina_ftp_envio     '+
                '   and arq.cod_situacao_arquivo_ftp  = sit.cod_situacao_arquivo_ftp '+
                '   and arq.cod_usuario_insercao      = tu.cod_usuario               '+
                '   and arq.cod_tipo_mensagem        *= msg.cod_tipo_mensagem        ');

   if CodRotinaFTPEnvio > 0 then begin
     Query.SQL.Add(' and arq.cod_rotina_ftp_envio = :cod_rotina_ftp_envio');
   end;

   if NomArquivoLocal <> '' then begin
     Query.SQL.Add(' and arq.nom_arquivo_local like :nom_arquivo_local');
   end;

   if CodTipoMensagem > 0 then begin
     Query.SQL.Add(' and arq.cod_tipo_mensagem = :cod_tipo_mensagem');
   end;

   if CodSituacaoArquivoFTP > 0 then begin
     Query.SQL.Add(' and arq.cod_situacao_arquivo_ftp = :cod_situacao_arquivo_ftp');
   end;

   if DtaUltimaTransferenciaInicio > 0 then begin
     if IndAindaSemTransferencia = 'S' then begin
       Query.SQL.Add(' and (arq.dta_ultima_transferencia >= :dta_ultima_transferencia_inicio');
       Query.SQL.Add ('  or arq.dta_ultima_transferencia is null)');
     end else  begin
       Query.SQL.Add(' and arq.dta_ultima_transferencia >= :dta_ultima_transferencia_inicio');
     end;
   end;

   if DtaUltimaTransferenciaFim > 0 then begin
     if IndAindaSemTransferencia = 'S' then begin
       Query.SQL.Add(' and (arq.dta_ultima_transferencia < :dta_ultima_transferencia_fim');
       Query.SQL.Add('  or arq.dta_ultima_transferencia is null)');
     end else  begin
       Query.SQL.Add(' and arq.dta_ultima_transferencia < :dta_ultima_transferencia_fim');
     end;
   end;

   Query.SQL.Add(' order by isnull(arq.dta_ultima_transferencia, ''20760101'') desc, arq.cod_arquivo_ftp_envio desc');

   //---------------- Parâmetros -----------------------------------------------

   if CodRotinaFTPEnvio > 0 then begin
     Query.ParamByName('cod_rotina_ftp_envio').AsInteger := CodRotinaFTPEnvio;
   end;

   if NomArquivoLocal <> '' then begin
     Query.ParamByName('nom_arquivo_local').AsString := '%' + NomArquivoLocal + '%';
   end;

   if CodTipoMensagem > 0 then begin
     Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
   end;

   if CodSituacaoArquivoFTP > 0 then begin
     Query.ParamByName('cod_situacao_arquivo_ftp').AsInteger := CodSituacaoArquivoFTP;
   end;

   if DtaUltimaTransferenciaInicio > 0 then begin
     Query.ParamByName('dta_ultima_transferencia_inicio').AsDateTime := Trunc(DtaUltimaTransferenciaInicio);
   end;

   if DtaUltimaTransferenciaFim > 0 then begin
     Query.ParamByName('dta_ultima_transferencia_fim').AsDateTime := Trunc(DtaUltimaTransferenciaFim);
   end;
{$ENDIF}

  try
    Query.Open;
    Result := 0;
  except
    on E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1709, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1709;
      Exit;
    end;
  end;
end;

function TIntArquivosFTPEnvio.Buscar(CodArquivoFTPEnvio: Integer): Integer;
var
  Q : THerdomQuery;
const
  CodMetodo: Integer = 525;
  NomMetodo: String  = 'Buscar';
begin
  Result := -1;

  if Not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if Not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select arq.cod_arquivo_ftp_envio,                                   '+
                '       arq.cod_rotina_ftp_envio,                                    '+
                '       rot.des_rotina_ftp_envio,                                    '+
                '       arq.nom_arquivo_local,                                       '+
                '       arq.nom_arquivo_remoto,                                      '+
                '       arq.txt_caminho_local,                                       '+
                '       arq.qtd_bytes_arquivo,                                       '+
                '       arq.cod_tipo_mensagem,                                       '+
                '       msg.des_tipo_mensagem,                                       '+
                '       arq.txt_mensagem,                                            '+
                '       arq.cod_situacao_arquivo_ftp,                                '+
                '       sit.sgl_situacao_arquivo_ftp,                                '+
                '       sit.des_situacao_arquivo_ftp,                                '+
                '       arq.dta_ultima_transferencia,                                '+
                '       arq.qtd_duracao_transferencia,                               '+
                '       arq.qtd_vezes_transferencia                                  '+
                '  from tab_arquivo_ftp_envio     arq,                               '+
                '       tab_situacao_arquivo_ftp  sit,                               '+
                '       tab_rotina_ftp_envio      rot,                               '+
                '       tab_tipo_mensagem         msg                                '+
                ' where arq.cod_rotina_ftp_envio      = rot.cod_rotina_ftp_envio     '+
                '   and arq.cod_situacao_arquivo_ftp  = sit.cod_situacao_arquivo_ftp '+
                '   and arq.cod_tipo_mensagem        *= msg.cod_tipo_mensagem        '+
                '   and arq.cod_arquivo_ftp_envio     = :cod_arquivo_ftp_envio       ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger := CodArquivoFTPEnvio;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1699, Self.ClassName, NomMetodo, []);
        Result := -1699;
        Exit;
      end;

      FIntArquivoFTPEnvio.CodArquivoFTPEnvio       :=  Q.FieldByName('cod_arquivo_ftp_envio').AsInteger;
      FIntArquivoFTPEnvio.CodRotinaFTPEnvio        :=  Q.FieldByName('cod_rotina_ftp_envio').AsInteger;
      FIntArquivoFTPEnvio.DesRotinaFTPEnvio        :=  Q.FieldByName('des_rotina_ftp_envio').AsString;
      FIntArquivoFTPEnvio.NomArquivoLocal          :=  Q.FieldByName('nom_arquivo_local').AsString;
      FIntArquivoFTPEnvio.NomArquivoRemoto         :=  Q.FieldByName('nom_arquivo_remoto').AsString;
      FIntArquivoFTPEnvio.TxtCaminhoLocal          :=  Q.FieldByName('txt_caminho_local').AsString;
      FIntArquivoFTPEnvio.QtdBytesArquivo          :=  Q.FieldByName('qtd_bytes_arquivo').AsInteger;
      if Q.FieldByName('cod_tipo_mensagem').AsInteger > 0 then begin
        FIntArquivoFTPEnvio.CodTipoMensagem          :=  Q.FieldByName('cod_tipo_mensagem').AsInteger;
      end else begin
        FIntArquivoFTPEnvio.CodTipoMensagem          := 3
      end;
      FIntArquivoFTPEnvio.DesTipoMensagem          :=  Q.FieldByName('des_tipo_mensagem').AsString;
      FIntArquivoFTPEnvio.TxtMensagem              :=  Q.FieldByName('txt_mensagem').AsString;
      FIntArquivoFTPEnvio.CodSituacaoArquivoFTP    :=  Q.FieldByName('cod_situacao_arquivo_ftp').AsInteger;
      FIntArquivoFTPEnvio.SglSituacaoArquivoFTP    :=  Q.FieldByName('sgl_situacao_arquivo_ftp').AsString;
      FIntArquivoFTPEnvio.DesSituacaoArquivoFTP    :=  Q.FieldByName('des_situacao_arquivo_ftp').AsString;
      FIntArquivoFTPEnvio.DtaUltimaTransferencia   :=  Q.FieldByName('dta_ultima_transferencia').AsDateTime;
      FIntArquivoFTPEnvio.QtdDuracaoTransferencia  :=  Q.FieldByName('qtd_duracao_transferencia').AsInteger;
      FIntArquivoFTPEnvio.QtdVezesTransferencia    :=  Q.FieldByName('qtd_vezes_transferencia').AsInteger;

      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1700, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1700;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosFTPEnvio.Inserir(CodRotinaFTPEnvio: Integer; NomArquivoLocal, NomArquivoRemoto,
                     TxtCaminhoLocal: String; QtdBytesArquivo: Integer;
                     IndDescompactarArquivoZip: String): Integer;
begin
  Result := Inserir(CodRotinaFTPEnvio, NomArquivoLocal, NomArquivoRemoto, TxtCaminhoLocal,
                    QtdBytesArquivo, IndDescompactarArquivoZip, -1);
end;

function TIntArquivosFTPEnvio.Inserir(CodRotinaFTPEnvio: Integer;
  NomArquivoLocal, NomArquivoRemoto, TxtCaminhoLocal: String;
  QtdBytesArquivo: Integer; IndDescompactarArquivoZip: String;
  CodArquivoSisbov: Integer): Integer;
var
  Q : THerdomQuery;
  NewCodArquivoFTPEnvio: Integer;
  Aux: String;
  CodRegistroLog: Integer;
const
  NomMetodo: String  = 'Inserir';
  CodMetodo: Integer = 574;
begin
  //------------------------ Validações ----------------------------------------
  Result := VerificaString(NomArquivoLocal, 'Nome do Arquivo Local');
  if Result < 0 then begin
    Exit;
  end;

  Result := TrataString(NomArquivoLocal, 255, 'Nome do Arquivo Local');
  if Result < 0 then begin
    Exit;
  end;

  Result := VerificaString(NomArquivoRemoto, 'Nome do Arquivo Remoto');
  if Result < 0 then begin
    Exit;
  end;

  Result := TrataString(NomArquivoRemoto, 255, 'Nome do Arquivo Remoto');
  if Result < 0 then begin
    Exit;
  end;

  //-- Retira a barra no final do local caso exista.
  Aux := TxtCaminhoLocal;
  if Copy(Aux, Length(Aux), 1) = '\' then begin
    Delete(Aux, Length(Aux), 1);
    TxtCaminhoLocal := Aux;
  end;

  Result := VerificaString(TxtCaminhoLocal, 'Txt do Caminho Local');
  if Result < 0 then begin
    Exit;
  end;

  Result := TrataString(TxtCaminhoLocal, 255, 'Txt do Caminho Local');
  if Result < 0 then begin
    Exit;
  end;

  if CodRotinaFTPEnvio <= 0 then begin
    Mensagens.Adicionar(1702, Self.ClassName, NomMetodo, [IntToStr(CodRotinaFTPEnvio)]);
    Result := -1702;
    Exit;
  end;

  if QtdBytesArquivo <= 0 then begin
    Mensagens.Adicionar(1703, Self.ClassName, NomMetodo, [IntToStr(QtdBytesArquivo)]);
    Result := -1703;
    Exit;
  end;

  if (UpperCase(IndDescompactarArquivoZip) <> 'S') and (UpperCase(IndDescompactarArquivoZip) <> 'N') then
  begin
    Mensagens.Adicionar(2227, Self.ClassName, NomMetodo, [IntToStr(QtdBytesArquivo)]);
    Result := -2227;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      //-------------------- Verifica se existe a rotina -----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_rotina_ftp_envio                  ' +
                '  where cod_rotina_ftp_envio = :cod_rotina_ftp_envio '+
                '    and dta_fim_validade is null                     ');
{$ENDIF}
      Q.ParamByName('cod_rotina_ftp_envio').AsInteger := CodRotinaFTPEnvio;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1706, Self.ClassName, NomMetodo, [IntToStr(CodRotinaFTPEnvio)]);
        Result := -1706;
        Exit;
      end;

      //------------------- Busca o código do arquivo --------------------------




      Result := ObterCodArquivoFTPEnvio(NewCodArquivoFTPEnvio);
      if Result < 0 then begin
        Exit;
      end;

      if NewCodArquivoFTPEnvio <= 0 then begin
        Mensagens.Adicionar(1707, Self.ClassName, NomMetodo, []);
        Result := -1707;
        Exit;
      end;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 then begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      end;

      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' insert into tab_arquivo_ftp_envio ('+
                '   cod_arquivo_ftp_envio,           '+
                '   cod_rotina_ftp_envio,            '+
                '   nom_arquivo_local,               '+
                '   nom_arquivo_remoto,              '+
                '   txt_caminho_local,               '+
                '   qtd_bytes_arquivo,               '+
                '   cod_tipo_mensagem,               '+
                '   txt_mensagem,                    '+
                '   cod_situacao_arquivo_ftp,        '+
                '   dta_ultima_transferencia,        '+
                '   qtd_duracao_transferencia,       '+
                '   qtd_vezes_transferencia,         '+
                '   ind_descompactar_arquivo_zip,    '+
                '   cod_usuario_insercao,            '+
                '   cod_registro_log,                '+
                '   cod_arquivo_sisbov               '+
                ' ) values (                         '+
                '   :cod_arquivo_ftp_envio,          '+
                '   :cod_rotina_ftp_envio,           '+
                '   :nom_arquivo_local,              '+
                '   :nom_arquivo_remoto,             '+
                '   :txt_caminho_local,              '+
                '   :qtd_bytes_arquivo,              '+
                '   null,                            '+
                '   null,                            '+
                '   :cod_situacao_arquivo_ftp,       '+
                '   null,                            '+
                '   null,                            '+
                '   :qtd_vezes_transferencia,        '+
                '   :ind_descompactar_arquivo_zip,   '+
                '   :cod_usuario_insercao,           '+
                '   :cod_registro_log,               '+
                '   :cod_arquivo_sisbov)             ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger       := NewCodArquivoFTPEnvio;
      Q.ParamByName('cod_rotina_ftp_envio').AsInteger        := CodRotinaFTPEnvio;
      Q.ParamByName('nom_arquivo_local').AsString            := NomArquivoLocal;
      Q.ParamByName('nom_arquivo_remoto').AsString           := NomArquivoRemoto;
      Q.ParamByName('txt_caminho_local').AsString            := TxtCaminhoLocal;
      Q.ParamByName('qtd_bytes_arquivo').AsInteger           := QtdBytesArquivo;
      Q.ParamByName('cod_situacao_arquivo_ftp').AsInteger    := 1; //Pendente
      Q.ParamByName('qtd_vezes_transferencia').AsInteger     := 0;
      Q.ParamByName('ind_descompactar_arquivo_zip').AsString := IndDescompactarArquivoZip;
      Q.ParamByName('cod_usuario_insercao').AsInteger        := Conexao.CodUsuario;
      Q.ParamByName('cod_registro_log').AsInteger            := CodRegistroLog;
      if CodArquivoSisbov > 0 then begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger            := CodArquivoSisbov;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_arquivo_sisbov').Clear;
      end;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_arquivo_ftp_envio', CodRegistroLog, 1, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      Commit;

      Result := NewCodArquivoFTPEnvio;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1708, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1708;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosFTPEnvio.AlterarSituacaoParaPendente(CodArquivoFTPEnvio: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog: Integer;
const
  CodMetodo : Integer = 527;
  NomMetodo : String = 'AlterarSituacaoParaPendente';
begin
  Result := -1;

  if Not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if Not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select cod_arquivo_ftp_envio,                         '+
                '        cod_registro_log                               '+
                '   from tab_arquivo_ftp_envio                          '+
                '  where cod_arquivo_ftp_envio = :cod_arquivo_ftp_envio ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger := CodArquivoFTPEnvio;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1699, Self.ClassName, NomMetodo, [IntToStr(CodArquivoFTPEnvio)]);
        Result := -1699;
        Exit;
      end;

      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_arquivo_ftp_envio', CodRegistroLog, 2, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' update tab_arquivo_ftp_envio                             '+
                '    set cod_situacao_arquivo_ftp = 1,                     '+
                '        qtd_vezes_transferencia  = 0                      '+
                '  where cod_arquivo_ftp_envio    = :cod_arquivo_ftp_envio ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger :=  CodArquivoFTPEnvio;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_arquivo_ftp_envio', CodRegistroLog, 3, CodMetodo);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      Commit;

      Result := 0;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1701, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1701;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosFTPEnvio.Enviar(CodArquivoFTPEnvio, ReadTimeOut: Integer): Integer;
const
  CodMetodo: Integer = 529;
  NomMetodo: String = 'Enviar';
  CodAplicativo: Integer = 1;
  TxtLegenda: String = 'Nome do arquivo';
var
  Q: THerdomQuery;
  ArquivoFTP: String;
  NumTentativa, MaxTentativa: Integer;
  QtdDuracao: Integer;
  Resultado: Integer;
  A: TIntOcorrenciasSistema;
  CodTipoMensagem: Integer;
  TxtMensagem: String;
  DtaUltimaTransferencia: TDateTime;
  CodRotinaFTP: Integer;
  NomArquivoLocal: String;

  i,
  QtdArquivosTransferencia: Integer;
  strNomDiretorio,
  NomArquivoCorrenteZip: String;
  ArquivoZIP: ZipFile;
  InterfaceSisbov: TIntInterfaceSisbov;
  DadosArquivo: TDadosArquivo;

  function GravarOcorrenciaProcessamento(): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Mensagens.Count - 1 do
    begin
      Result := InserirErroTransferenciaFTP(CodArquivoFTPEnvio, Mensagens.Items[i].Texto);
      if Result < 0 then
      begin
        Exit;
      end;
    end;
    if Result = 0 then
    begin
      Mensagens.Clear;
    end;
  end;

begin
  Resultado       := 0;
  NumTentativa    := 0;
  CodRotinaFTP    := 0;
  NomArquivoLocal := '';

  Result := LimparOcorrenciaTransferenciaFTP(CodArquivoFTPEnvio);
  if Result < 0 then begin
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    //--------------------------- Busca parametro sistema ------------------------
    MaxTentativa := StrToInt(ValorParametro(77));

    if MaxTentativa < 1 then begin
      Mensagens.Adicionar(1713, Self.ClassName, NomMetodo, [IntToStr(77)]);
      Resultado       := -1713;
      TxtMensagem     := Mensagens.GerarMensagem(1713, [IntToStr(77)]);
      CodTipoMensagem := Mensagens.BuscarTipoMensagem(1713);
    end;

    //------------------ Busca dados arquivo -------------------------------------
    if Resultado = 0 then begin
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select arq.cod_arquivo_ftp_envio,                                  '+
                '       arq.cod_rotina_ftp_envio,                                   '+
                '       arq.nom_arquivo_local,                                      '+
                '       arq.nom_arquivo_remoto,                                     '+
                '       arq.txt_caminho_local,                                      '+
                '       arq.qtd_bytes_arquivo,                                      '+
                '       arq.cod_situacao_arquivo_ftp,                               '+
                '       arq.dta_ultima_transferencia,                               '+
                '       arq.qtd_duracao_transferencia,                              '+
                '       arq.qtd_vezes_transferencia,                                '+
                '       arq.ind_descompactar_arquivo_zip,                           '+
                '       rot.des_rotina_ftp_envio,                                   '+
                '       rot.txt_endereco_maquina_remota,                            '+
                '       rot.txt_porta_maquina_remota,                               '+
                '       rot.txt_usuario_maquina_remota,                             '+
                '       rot.txt_senha_maquina_remota,                               '+
                '       rot.txt_caminho_remoto,                                     '+
                '       rot.dta_ultima_transferencia,                               '+
                '       rot.dta_fim_validade,                                       '+
                '       arq.cod_arquivo_sisbov                                      '+
                '  from tab_arquivo_ftp_envio     arq,                              '+
                '       tab_rotina_ftp_envio      rot                               '+
                ' where arq.cod_rotina_ftp_envio     = rot.cod_rotina_ftp_envio     '+
                '   and arq.cod_arquivo_ftp_envio    = :cod_arquivo_ftp_envio       ');
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger := CodArquivoFTPEnvio;
      try
        Q.Open;

        if Q.IsEmpty then
        begin
          Mensagens.Adicionar(1699, Self.ClassName, NomMetodo, []);
          Result := -1699;
          Exit;
        end
        else
        begin
          NomArquivoLocal := Q.FieldByName('nom_arquivo_local').AsString;
          CodRotinaFTP    := Q.FieldByName('cod_rotina_ftp_envio').AsInteger;
          NumTentativa    := Q.FieldByName('qtd_vezes_transferencia').AsInteger + 1;
        end;

        if Resultado = 0 then
        begin
          if Q.FieldByName('cod_situacao_arquivo_ftp').AsInteger <> 4{1} then
          begin
            Mensagens.Adicionar(1710, Self.ClassName, NomMetodo, []);
            Result := -1710;
            Exit;
          end;

          if not Q.FieldByName('dta_fim_validade').IsNull then
          begin
            Mensagens.Adicionar(1711, Self.ClassName, NomMetodo, []);
            Resultado        := -1711;
            TxtMensagem      := Mensagens.GerarMensagem(1711, []);
            CodTipoMensagem  := Mensagens.BuscarTipoMensagem(1711);
          end;

          ArquivoFTP := Q.FieldByName('txt_caminho_local').AsString + '\' + Q.FieldByName('nom_arquivo_local').AsString;
          if not FileExists(ArquivoFTP) then
          begin
            Mensagens.Adicionar(1712, Self.ClassName, NomMetodo, []);
            Resultado       := -1712;
            TxtMensagem     := Mensagens.GerarMensagem(1712, []);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1712);
          end;
        end;
      except
        on E: Exception do
        begin
          Mensagens.Adicionar(1714, Self.ClassName, NomMetodo, [E.Message]);
          TxtMensagem      := Mensagens.GerarMensagem(1714, [E.Message]);
          CodTipoMensagem  := Mensagens.BuscarTipoMensagem(1714);
          Resultado        := -1714;
          NumTentativa     :=     0;
          CodRotinaFTP     :=     0;
        end;
      end;
    end;

    // Se Arquivo é de Animais, então chama rotina GeraArquivoANI da IntInterfaceSisbov
    if CodRotinaFTP = 2 then begin
      MaxTentativa := 1;

      // Instancia IntInterfaceSisbov
      InterfaceSisbov := TIntInterfaceSisbov.Create;
      Try
        Result := InterfaceSisbov.Inicializar(Conexao, Mensagens);
        if Result < 0 then begin
          Exit;
        end;

        // Monta dados arquivo
        DadosArquivo.ArquivoNovo := false;
        DadosArquivo.CodArquivoSisbov := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
        DadosArquivo.CodTipoArquivoSisbov := 2; // Animais
        DadosArquivo.Caminho := Q.FieldByName('txt_caminho_local').AsString;
        if DadosArquivo.Caminho[Length(DadosArquivo.Caminho)] <> '\' then
        begin
          DadosArquivo.Caminho := DadosArquivo.Caminho + '\';
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Copy(Q.FieldByName('nom_arquivo_local').AsString, 1, Length(Q.FieldByName('nom_arquivo_local').AsString)-4) + '.xml';
        DadosArquivo.CodUsuario := Conexao.CodUsuario;
        Resultado := InterfaceSisbov.ObtemCNPJCertificadora(DadosArquivo.CNPJCertificadora);
        if Resultado < 0 then begin
          Exit;
        end;

        // Transmite animais via metodos SOAP conforme implementado na rotina GeraArquivoANI
        Resultado := InterfaceSisbov.GeraArquivoANI(DadosArquivo, 'SER');
        if Resultado < 0 then begin
          if Resultado = -1 then begin
            Mensagens.Adicionar(2367, Self.ClassName, NomMetodo, []);
            TxtMensagem     := Mensagens.BuscarTextoMensagem(2367);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(2367);
          end else begin
            TxtMensagem     := Mensagens.BuscarTextoMensagem(Trunc(Abs(Result)));
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(Trunc(Abs(Result)));
          end;
        end else begin
          Mensagens.Adicionar(2368, Self.ClassName, NomMetodo, [DadosArquivo.NomArquivoSisbov]);
          TxtMensagem     := Mensagens.GerarMensagem(2368, [DadosArquivo.NomArquivoSisbov]);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(2368);
        end;
      Finally
        InterfaceSisbov.Free;
      End;

    end else begin
      // Verifica se o arquivo a ser transmitido pode ser transmitido como ZIP
      if (UpperCase(Q.FieldByName('ind_descompactar_arquivo_zip').AsString) = 'S') and
         (ExtractFileExt(ArquivoFTP) = '.ZIP') then
      begin
        // Abre arquivo ZIP
        Resultado := AbrirUnZip(ArquivoFTP, ArquivoZip);
        if Resultado < 0 then
        begin
          Mensagens.Adicionar(1360, Self.ClassName, NomMetodo, [ExtractFileName(ArquivoFTP)]);
          TxtMensagem     := Mensagens.GerarMensagem(1360, [ExtractFileName(ArquivoFTP)]);;
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1360);
        end;

        QtdArquivosTransferencia := NumArquivosDoUnZip(ArquivoZIP);
        if QtdArquivosTransferencia < 0 then
        begin
          Mensagens.Adicionar(1361, Self.ClassName, NomMetodo, [ExtractFileName(ArquivoFTP)]);
          TxtMensagem     := Mensagens.GerarMensagem(1361, [ExtractFileName(ArquivoFTP)]);;
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1361);
        end;

        strNomDiretorio := ExtractFileDir(ArquivoFTP) + '\' + LeftStr(ExtractFileName(ArquivoFTP), Length(ExtractFileName(ArquivoFTP)) - 4);
        if not CreateDir(strNomDiretorio) then
        begin
          Mensagens.Adicionar(2229, Self.ClassName, NomMetodo, []);
          TxtMensagem     := Mensagens.GerarMensagem(2229, []);;
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(2229);
        end;

        Resultado := IrAoPrimeiroArquivoDoUnzip(ArquivoZIP);
        if Resultado < 0 then
        begin
          Mensagens.Adicionar(2230, Self.ClassName, NomMetodo, []);
          TxtMensagem     := Mensagens.GerarMensagem(2230, []);;
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(2230);
          Resultado       := -2230;
        end;

        try
          if Resultado >= 0 then
          begin
            for i := 1 to QtdArquivosTransferencia do
            begin
              NomArquivoCorrenteZip := NomeArquivoCorrenteDoUnzip(ArquivoZIP);
              Result := ExtrairArquivoDoUnZip(ArquivoZIP, NomArquivoCorrenteZip, strNomDiretorio);
              if Resultado < 0 then
              begin
                Mensagens.Adicionar(1361, Self.ClassName, NomMetodo, [ExtractFileName(ArquivoFTP)]);
                TxtMensagem     := Mensagens.GerarMensagem(1361, [ExtractFileName(ArquivoFTP)]);;
                CodTipoMensagem := Mensagens.BuscarTipoMensagem(1361);
                Resultado       := -1361;
              end;
              NomArquivoCorrenteZip := strNomDiretorio + '\' + NomArquivoCorrenteZip;
              try
                if Resultado = 0 then
                begin
                  Resultado := ExecutarFTP(Q.FieldByName('cod_rotina_ftp_envio').AsInteger,
                                           Q.FieldByName('txt_endereco_maquina_remota').AsString,
                                           Q.FieldByName('txt_porta_maquina_remota').AsString,
                                           Q.FieldByName('txt_usuario_maquina_remota').AsString,
                                           Q.FieldByName('txt_senha_maquina_remota').AsString,
                                           Q.FieldByName('txt_caminho_remoto').AsString,
                                           ExtractFileName(NomArquivoCorrenteZip),
                                           NomArquivoCorrenteZip,
                                           ReadTimeOut,
                                           QtdDuracao,
                                           CodTipoMensagem,
                                           TxtMensagem);
                  if (Resultado < 0) and (Resultado <> -1731) then
                  begin
                    Continue;
                  end;
                end;
              finally
                if not DeleteFile(NomArquivoCorrenteZip) then
                begin
                  Mensagens.Adicionar(2231, Self.ClassName, NomMetodo, []);
                  TxtMensagem     := Mensagens.GerarMensagem(2231, []);;
                  CodTipoMensagem := Mensagens.BuscarTipoMensagem(2231);
                  Resultado       := -2231;
                end;
              end;

              if (Resultado < 0) and (Resultado <> -1731) then
              begin
                Exit;
              end;

              Result := IrAoProximoArquivoDoUnzip(ArquivoZIP);
              if Resultado < 0 then
              begin
                if Resultado = -1 then
                begin
                  Resultado := 0;
                  Break;
                end
                else
                begin
                  Mensagens.Adicionar(1361, Self.ClassName, NomMetodo, [ExtractFileName(ArquivoFTP)]);
                  TxtMensagem     := Mensagens.GerarMensagem(1361, [ExtractFileName(ArquivoFTP)]);;
                  CodTipoMensagem := Mensagens.BuscarTipoMensagem(1361);
                  Resultado       := -1361;
                end;
              end;
            end;
          end;
        finally
          if not RemoveDir(strNomDiretorio) then
          begin
            Mensagens.Adicionar(2232, Self.ClassName, NomMetodo, []);
            TxtMensagem     := Mensagens.GerarMensagem(2232, []);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(2232);
            Resultado       := -2232;
          end;
        end;
      end
      else
      begin
        //-------------------- Executa o FTP ----------------------------------------

        if Resultado = 0 then
        begin
          Resultado := ExecutarFTP(Q.FieldByName('cod_rotina_ftp_envio').AsInteger,
                                   Q.FieldByName('txt_endereco_maquina_remota').AsString,
                                   Q.FieldByName('txt_porta_maquina_remota').AsString,
                                   Q.FieldByName('txt_usuario_maquina_remota').AsString,
                                   Q.FieldByName('txt_senha_maquina_remota').AsString,
                                   Q.FieldByName('txt_caminho_remoto').AsString,
                                   Q.FieldByName('nom_arquivo_remoto').AsString,
                                   ArquivoFTP,
                                   ReadTimeOut,
                                   QtdDuracao,
                                   CodTipoMensagem,
                                   TxtMensagem);
        end;
      end;
    end;

    DtaUltimaTransferencia := Now;

    //-------------------- Atualiza tab_arquivo_ftp_envio ----------------------

    BeginTran;
    try
      if Resultado < 0 then begin
        Result := GravarOcorrenciaProcessamento();
        if Result < 0 then begin
          Exit;
        end;
      end;

      if QtdDuracao = 0 then begin
        QtdDuracao := 1;
      end;

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' update tab_arquivo_ftp_envio                                    '+
                '    set cod_tipo_mensagem         = :cod_tipo_mensagem,          '+
                '        txt_mensagem              = :txt_mensagem,               '+
                '        qtd_vezes_transferencia   = qtd_vezes_transferencia + 1, '+
                '        dta_ultima_transferencia  = :dta_ultima_transferencia,   '+
                '        qtd_duracao_transferencia = :qtd_duracao_tranferencia,   '+
                '        cod_situacao_arquivo_ftp  = :cod_situacao_arquivo_ftp    '+
                '  where cod_arquivo_ftp_envio     = :cod_arquivo_ftp_envio       ');
      {$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_envio').AsInteger      := CodArquivoFTPEnvio;
      if CodTipoMensagem > 0 then begin
        Q.ParamByName('cod_tipo_mensagem').AsInteger          := CodTipoMensagem;
      end else begin
        Q.ParamByName('cod_tipo_mensagem').AsInteger          := 3
      end;

      Q.ParamByName('txt_mensagem').AsString                := TxtMensagem;
      Q.ParamByName('dta_ultima_transferencia').AsDateTime  := DtaUltimaTransferencia;
      Q.ParamByName('qtd_duracao_tranferencia').AsInteger   := QtdDuracao;
      if Resultado = 0 then
      begin
        Q.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 3;   //SUCESSO
      end
      else
      begin
        if (NumTentativa = 0) or (MaxTentativa = 0) then
        begin
          Q.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 1; //PENDENTE
        end
        else
        begin
          if NumTentativa >= MaxTentativa then
          begin
            Q.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 2; //ERRO
          end
          else
          begin
            Q.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 1; //PENDENTE
          end;
        end;
      end;
      Q.ExecSQL;

      //------------- Atualiza tab_rotina_ftp_envio ----------------------------

      if CodRotinaFTP > 0 then
      begin
        Q.Close;
        Q.SQL.Clear;
        {$IFDEF MSSQL}
           Q.SQL.Add('update tab_rotina_ftp_envio set dta_ultima_transferencia = :dta_ultima_transferencia '+
                     ' where cod_rotina_ftp_envio = :cod_rotina_ftp_envio');
        {$ENDIF}
        Q.ParamByName('cod_rotina_ftp_envio').AsInteger      := CodRotinaFTP;
        Q.ParamByName('dta_ultima_transferencia').AsDateTime := DtaUltimaTransferencia;
        Q.ExecSQL;
      end;

      Commit;

      //----- Grava ocorrencia caso necessario ---------------------------------
      if Resultado < 0 then
      begin
        if (NumTentativa > 0) and (MaxTentativa > 0) then
        begin
          if NumTentativa >= MaxTentativa then
          begin
            A := TIntOcorrenciasSistema.Create;
            try
              TxtMensagem      := Mensagens.GerarMensagem(1822, []);
              CodTipoMensagem  := Mensagens.BuscarTipoMensagem(1822);

              A.Inicializar(Conexao, Mensagens);
              A.Inserir(CodAplicativo, CodMetodo, CodTipoMensagem, TxtMensagem, NomArquivoLocal, TxtLegenda);
            finally
              A.Free;
            end;
          end;
        end;
      end;

      Result := Resultado;
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(1714, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1714;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosFTPEnvio.ExecutarFTP(CodRotinaFTPEnvio: Integer;
                                          TxtMaquinaRemota,
                                          TxtPortaRemota,
                                          TxtUsuarioMaquina,
                                          TxtSenhaMaquina,
                                          TxtCaminhoRemoto,
                                          TxtArquivoRemoto,
                                          TxtArquivoLocal: String;
                                          ReadTimeOut: Integer;
                                          var QtdDuracao: Integer;
                                          var CodTipoMensagem: Integer;
                                          var TxtMensagem: String): Integer;
const
  NomMetodo: String = 'ExecutarFTP';
var
  ConexaoFTP: TIdFTP;
  DataInicio: TDateTime;
  X: Integer;
  AchouArquivo: Boolean;
begin
  QtdDuracao    := 0;
  DataInicio    := Now;

  ConexaoFTP := TIdFTP.Create(Nil);
  try
    ConexaoFTP.Host     := TxtMaquinaRemota;
    ConexaoFTP.Port     := StrToInt(TxtPortaRemota);
    ConexaoFTP.Username := TxtUsuarioMaquina;
    ConexaoFTP.Password := TxtSenhaMaquina;

    ConexaoFTP.ReadTimeout := ReadTimeOut;
    try
      ConexaoFTP.Connect;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(1715, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1715;
        TxtMensagem     := Mensagens.GerarMensagem(1715, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1715);
        Exit;
      end;
    end;

    //----------------------- Acessa a pasta remota ----------------------------
    try
      if (not ConexaoFTP.Connected) then
      begin
        ConexaoFTP.Connect;
      end;

      ConexaoFTP.ChangeDir(TxtCaminhoRemoto);
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(1716, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        Result          := -1716;
        TxtMensagem     := Mensagens.GerarMensagem(1716, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1716);
        Exit;
      end;
    end;

    //----------------------- Envia Arquivo ------------------------------------
    try
      if (not ConexaoFTP.Connected) then
      begin
        ConexaoFTP.Connect;
      end;

      AchouArquivo := False;

      ConexaoFTP.List(Nil, '*' + ExtractFileExt(TxtArquivoRemoto), True);
      for X := 0 to ConexaoFTP.DirectoryListing.Count - 1 do
      begin
        if ConexaoFTP.DirectoryListing.Items[x].FileName = TxtArquivoRemoto then
        begin
          AchouArquivo := True;
        end;
      end;

      if not AchouArquivo then
      begin
        ConexaoFTP.Put(TxtArquivoLocal, TxtArquivoRemoto);
      end
      else
      begin
        Mensagens.Adicionar(1731, Self.ClassName, NomMetodo, [TxtArquivoRemoto, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1731;
        TxtMensagem     := Mensagens.GerarMensagem(1731, [TxtArquivoRemoto, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1731);
        Exit;
      end;
    except
      on E: Exception do
      begin
        Mensagens.Adicionar(1717, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtArquivoRemoto, TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1717;
        TxtMensagem     := Mensagens.GerarMensagem(1717, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtArquivoRemoto, TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1717);
        Exit;
      end;
    end;

    QtdDuracao := Round((Now - DataInicio) * 24 * 60 * 60);

    Mensagens.Adicionar(1722, Self.ClassName, NomMetodo, [ExtractFileName(TxtArquivoLocal), Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
    TxtMensagem     := Mensagens.GerarMensagem(1722, [ExtractFileName(TxtArquivoLocal), Conexao.Banco, IntToStr(CodRotinaFTPEnvio), TxtMaquinaRemota, TxtPortaRemota]);
    CodTipoMensagem := Mensagens.BuscarTipoMensagem(1722);
    Result          := 0;
  finally
    ConexaoFTP.Disconnect;
    ConexaoFTP.Free;
  end;
end;

function TIntArquivosFTPEnvio.ObterCodArquivoFTPEnvio(var CodArquivoFTPEnvio: Integer): Integer;
const
  NomMetodo: String = 'ObterCodArquivoFTPEnvio';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      BeginTran;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arquivo_ftp_envio), 0) + 1 as CodSeqArquivoFtpEnvio from tab_seq_arquivo_ftp_envio');
      {$ENDIF}
      Q.Open;

      CodArquivoFTPEnvio := Q.FieldByName('CodSeqArquivoFtpEnvio').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arquivo_ftp_envio set cod_seq_arquivo_ftp_envio = cod_seq_arquivo_ftp_envio + 1');
      {$ENDIF}
      Q.ExecSQL;

      Commit;

      Result := CodArquivoFTPEnvio;
    except
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1707, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1707;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntArquivosFTPEnvio.InserirErroTransferenciaFTP(ECodArquivoFTPEnvio: Integer;
                                                          ETxtMensagemErro: String): Integer;
const
  NomMetodo: String = 'InserirErroTransferenciaFTP';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(Conexao, nil);
  try
    try
      with Qry do
      begin
        SQL.Clear;
        SQL.Add(' select 1 from tab_arquivo_ftp_envio ');
        SQL.Add('  where cod_arquivo_ftp_envio = :cod_arquivo_ftp_envio ');
        ParamByName('cod_arquivo_ftp_envio').AsInteger := ECodArquivoFTPEnvio;
        Open;
        if IsEmpty then
        begin
          Mensagens.Adicionar(2233, Self.ClassName, NomMetodo, []);
          Result := -2233;
          Exit;
        end;

        BeginTran;

        SQL.Clear;
        SQL.Add(' insert into tab_erro_ftp_envio ');
        SQL.Add('        ( cod_arquivo_ftp_envio ');
        SQL.Add('        , txt_mensagem_erro ) ');
        SQL.Add(' values ( :cod_arquivo_ftp_envio ');
        SQL.Add('        , :txt_mensagem_erro ) ');
        ParamByName('cod_arquivo_ftp_envio').AsInteger := ECodArquivoFTPEnvio;
        ParamByName('txt_mensagem_erro').AsString := ETxtMensagemErro;
        ExecSQL;

        Commit;
      end;

      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2234, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2234;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TIntArquivosFTPEnvio.PesquisarErroFTPEnvio(ECodArquivoFTPEnvio: Integer): Integer;
const
  CodMetodo : Integer = 644;
  NomMetodo : String = 'PesquisarErroFTPEnvio';
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;

  if ECodArquivoFTPEnvio < 0 then
  begin
    Mensagens.Adicionar(2235, Self.ClassName, NomMetodo, []);
    Result := -2235;
    Exit;
  end;
  
  try
    with Query do
    begin
      SQL.Clear;
      SQL.Add(' select cod_arquivo_ftp_envio as CodArquivoFTPEnvio ');
      SQL.Add('      , txt_mensagem_erro     as TxtMensagemErro ');
      SQL.Add('   from tab_erro_ftp_envio ');
      SQL.Add('  where cod_arquivo_ftp_envio = :cod_arquivo_ftp_envio ');
      ParamByName('cod_arquivo_ftp_envio').AsInteger := ECodArquivoFTPEnvio;
      Open;
    end;

    Result := 0;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2236, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2236;
      Exit;
    end;
  end;
end;

function TIntArquivosFTPEnvio.LimparOcorrenciaTransferenciaFTP(ECodArquivoFTPEnvio: Integer): Integer;
const
  NomMetodo: String = 'LimparOcorrenciaTransferenciaFTP';
var
  qAux: THerdomQuery;
begin
  qAux := THerdomQuery.Create(Conexao, nil);
  try
    try
      qAux.SQL.Clear;
      qAux.SQL.Add(' delete tab_erro_ftp_envio ');
      qAux.SQL.Add('  where cod_arquivo_ftp_envio = :cod_arquivo_ftp_envio');
      qAux.ParamByName('cod_arquivo_ftp_envio').AsInteger := ECodArquivoFTPEnvio;
      qAux.ExecSQL;
      Result := 0;
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(2237, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2237;
        Exit;
      end;
    end;
  finally
    qAux.Free;
  end;
end;

end.

