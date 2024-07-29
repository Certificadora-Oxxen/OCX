// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 13/08/2004
// *  Documentação       :
// *  Descrição Resumida :
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntEmailsEnvio;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, Classes, sysutils, db, uConexao, uIntMensagens,
     uIntEmailEnvio, uIntOcorrenciasSistema, uFerramentas, idMessage, idSMTP;

type
{ TIntEmailEnvio }
  TIntEmailsEnvio = class(TIntClasseBDNavegacaoBasica)
  private
    FIntEmailEnvio : TIntEmailEnvio;
    function ObterCodEmailEnvio(var CodEmailEnvio: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Buscar(CodEmailEnvio: Integer): Integer;
    function Pesquisar(TxtEmailDestinatario, NomPessoa: String; CodEmailEnvio, CodTipoEmail: Integer;
               TxtAssunto: String; CodTipoMensagem, CodSituacaoEmail: Integer; DtaUltimoEnvioInicio,
               DtaUltimoEnvioFim: TDateTime; IndAindaSemEnvio: String): Integer;
    function PesquisarDestinatarios(CodEmailEnvio: Integer): Integer;
    function PesquisarArquivosAnexos(CodEmailEnvio: Integer): Integer;
    function Inserir(CodTipoEmail: Integer; TxtAssunto, TxtCorpoEmail: String): Integer;
    function AdicionarDestinatario(CodEmailEnvio: Integer; TxtEmailDestinatario: String;
                                   CodTipoDestinatario, CodPessoa: Integer): Integer;
    function AdicionarArquivoAnexo(CodEmailEnvio: Integer; NomArquivoAnexo, TxtCaminhoArquivo: String): Integer;
    function Enviar(CodEmailEnvio: Integer): Integer;
    function AlterarSituacaoParaPendente(CodEmailEnvio: Integer; IndChamadaInterna: String = 'N'): Integer;
    property IntEmailEnvio : TIntEmailEnvio read FIntEmailEnvio write FIntEmailEnvio;
  end;

implementation

constructor TIntEmailsEnvio.Create;
begin
  inherited;
  FIntEmailEnvio := TIntEmailEnvio.Create;
end;

destructor TIntEmailsEnvio.Destroy;
begin
  FIntEmailEnvio.Free;
  inherited;
end;

function TIntEmailsEnvio.Buscar(CodEmailEnvio: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo: Integer = 566;
  NomMetodo: String  = 'Buscar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select emi.cod_email_envio,                        '+
          '        emi.cod_tipo_email,                               '+
          '        tip.des_tipo_email,                               '+
          '        emi.txt_assunto,                                  '+
          '        emi.txt_corpo_email,                              '+
          '        emi.cod_tipo_mensagem,                            '+
          '        msg.des_tipo_mensagem,                            '+
          '        emi.txt_mensagem,                                 '+
          '        emi.cod_situacao_email,                           '+
          '        sit.sgl_situacao_email,                           '+
          '        sit.des_situacao_email,                           '+
          '        emi.dta_ultimo_envio,                             '+
          '        emi.qtd_duracao_envio,                            '+
          '        emi.qtd_vezes_envio                               '+
          '   from tab_email_envio         emi,                      '+
          '        tab_tipo_email          tip,                      '+
          '        tab_situacao_email      sit,                      '+
          '        tab_tipo_mensagem       msg                       '+
          '  where emi.cod_tipo_email       = tip.cod_tipo_email     '+
          '    and emi.cod_situacao_email   = sit.cod_situacao_email '+
          '    and emi.cod_tipo_mensagem   *= msg.cod_tipo_mensagem  '+
          '    and emi.cod_email_envio      = :cod_email_envio       ');

      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1856, Self.ClassName, NomMetodo, []);
        Result := -1856;
        Exit;
      End;

      FIntEmailEnvio.CodEmailEnvio    :=  Q.FieldByName('cod_email_envio').AsInteger;
      FIntEmailEnvio.CodTipoEmail     :=  Q.FieldByName('cod_tipo_email').AsInteger;
      FIntEmailEnvio.DesTipoEmail     :=  Q.FieldByName('des_tipo_email').AsString;
      FIntEmailEnvio.TxtAssunto       :=  Q.FieldByName('txt_assunto').AsString;
      FIntEmailEnvio.TxtCorpoEmail    :=  Q.FieldByName('txt_corpo_email').AsString;
      FIntEmailEnvio.CodTipoMensagem  :=  Q.FieldByName('cod_tipo_mensagem').AsInteger;
      FIntEmailEnvio.DesTipoMensagem  :=  Q.FieldByName('des_tipo_mensagem').AsString;
      FIntEmailEnvio.TxtMensagem      :=  Q.FieldByName('txt_mensagem').AsString;
      FIntEmailEnvio.CodSituacaoEmail :=  Q.FieldByName('cod_situacao_email').AsInteger;
      FIntEmailEnvio.SglSituacaoEmail :=  Q.FieldByName('sgl_situacao_email').AsString;
      FIntEmailEnvio.DesSituacaoEmail :=  Q.FieldByName('des_situacao_email').AsString;
      FIntEmailEnvio.DtaUltimoEnvio   :=  Q.FieldByName('dta_ultimo_envio').AsDateTime;
      FIntEmailEnvio.QtdDuracaoEnvio  :=  Q.FieldByName('qtd_duracao_envio').AsInteger;
      FIntEmailEnvio.QtdVezesEnvio    :=  Q.FieldByName('qtd_vezes_envio').AsInteger;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1857, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1857;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEmailsEnvio.Pesquisar(TxtEmailDestinatario, NomPessoa: String; CodEmailEnvio, CodTipoEmail: Integer;
  TxtAssunto: String; CodTipoMensagem, CodSituacaoEmail: Integer; DtaUltimoEnvioInicio,
  DtaUltimoEnvioFim: TDateTime; IndAindaSemEnvio: String): Integer;
Const
  CodMetodo: Integer = 567;
  NomMetodo: String  = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  If (DtaUltimoEnvioInicio = 0) and (DtaUltimoEnvioFim = 0) and (IndAindaSemEnvio <> '') Then Begin
    Mensagens.Adicionar(1882, Self.ClassName, NomMetodo, []);
    Result := -1882;
    Exit;
  End;

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select emi.cod_email_envio        as CodEmailEnvio,       '+
                '        emi.cod_tipo_email         as CodTipoEmail,        '+
                '        tip.des_tipo_email         as DesTipoEmail,        '+
                '        emi.txt_assunto            as TxtAssunto,          '+
                '        emi.cod_tipo_mensagem      as CodTipoMensagem,     '+
                '        msg.des_tipo_mensagem      as DesTipoMensagem,     '+
                '        emi.cod_situacao_email     as CodSituacaoEmail,    '+
                '        sit.sgl_situacao_email     as SglSituacaoEmail,    '+
                '        emi.dta_ultimo_envio       as DtaUltimoEnvio,      '+
                '        emi.qtd_vezes_envio        as QtdVezesEnvio        '+
                '   from tab_email_envio              emi,                  '+
                '        tab_tipo_email               tip,                  '+
                '        tab_situacao_email           sit,                  '+
                '        tab_tipo_mensagem            msg                   '+
                '  where emi.cod_tipo_email       = tip.cod_tipo_email      '+
                '    and emi.cod_situacao_email   = sit.cod_situacao_email  '+
                '    and emi.cod_tipo_mensagem   *= msg.cod_tipo_mensagem   ');

  If (TxtEmailDestinatario <> '') and (NomPessoa = '') Then Begin
    Query.SQL.Add(' and exists  (select 1                                                       '+
                  '                from tab_email_envio_destinatario des                        '+
                  '               where des.cod_email_envio = emi.cod_email_envio               '+
                  '                 and des.txt_email_destinatario like :txt_email_destinatario)');
  End;

  If (TxtEmailDestinatario = '') and (NomPessoa <> '') Then Begin
    Query.SQL.Add(' and exists  (select 1                                                       '+
                  '                from tab_email_envio_destinatario des,                       '+
                  '                     tab_pessoa                   pes                        '+
                  '               where des.cod_email_envio = emi.cod_email_envio               '+
                  '                 and des.cod_pessoa      = pes.cod_pessoa                    '+
                  '                 and pes.nom_pessoa like :nom_pessoa)                        ');
  End;

  If (TxtEmailDestinatario <> '') and (NomPessoa <> '') Then Begin
    Query.SQL.Add(' and exists  (select 1                                                       '+
                  '                from tab_email_envio_destinatario des,                       '+
                  '                     tab_pessoa                   pes                        '+
                  '               where des.cod_email_envio = emi.cod_email_envio               '+
                  '                 and des.cod_pessoa      = pes.cod_pessoa                    '+
                  '                 and des.txt_email_destinatario like :txt_email_destinatario '+
                  '                 and pes.nom_pessoa like :nom_pessoa)                        ');
  End;

  If CodEmailEnvio > 0 Then Begin
    Query.SQL.Add(' and emi.cod_email_envio = :cod_email_envio');
  End;

  If CodTipoEmail > 0 Then Begin
    Query.SQL.Add(' and emi.cod_tipo_email = :cod_tipo_email');
  End;

  If TxtAssunto <> '' Then Begin
    Query.SQL.Add(' and emi.txt_assunto like :txt_assunto');
  End;

  If CodTipoMensagem > 0 Then Begin
    Query.SQL.Add(' and emi.cod_tipo_mensagem = :cod_tipo_mensagem');
  End;

  If CodSituacaoEmail > 0 Then Begin
    Query.SQL.Add(' and emi.cod_situacao_email = :cod_situacao_email');
  End;

  If DtaUltimoEnvioInicio > 0 Then Begin
    If IndAindaSemEnvio = 'S' Then Begin
      Query.SQL.Add(' and (emi.dta_ultimo_envio >= :dta_ultimo_envio_inicio');
      Query.SQL.Add ('  or emi.dta_ultimo_envio is null)');
    End Else Begin
      Query.SQL.Add(' and emi.dta_ultimo_envio >= :dta_ultimo_envio_inicio');
    End;
  End;

  If DtaUltimoEnvioFim > 0 Then Begin
    If IndAindaSemEnvio = 'S' Then Begin
      Query.SQL.Add(' and (emi.dta_ultimo_envio < :dta_ultimo_envio_fim');
      Query.SQL.Add('  or  emi.dta_ultimo_envio is null)');
    End Else Begin
      Query.SQL.Add(' and emi.dta_ultimo_envio < :dta_ultimo_envio_fim');
    End;
  End;

  Query.SQL.Add(' order by isnull(emi.dta_ultimo_envio, ''20760101'') desc, emi.cod_email_envio desc');

  //---------------- Parâmetros -----------------------------------------------

  If TxtEmailDestinatario <> '' Then Begin
    Query.ParamByName('txt_email_destinatario').AsString := '%' + TxtEmailDestinatario + '%';
  End;

  If NomPessoa <> '' Then Begin
    Query.ParamByName('nom_pessoa').AsString := '%' + NomPessoa + '%';
  End;

  If CodEmailEnvio > 0 Then Begin
    Query.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
  End;

  If CodTipoEmail > 0 Then Begin
    Query.ParamByName('cod_tipo_email').AsInteger := CodTipoEmail;
  End;

  If TxtAssunto <> '' Then Begin
    Query.ParamByName('txt_assunto').AsString := '%' + TxtAssunto + '%';
  End;

  If CodTipoMensagem > 0 Then Begin
    Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
  End;

  If CodSituacaoEmail > 0 Then Begin
    Query.ParamByName('cod_situacao_email').AsInteger := CodSituacaoEmail;
  End;

  If DtaUltimoEnvioInicio > 0 Then Begin
    Query.ParamByName('dta_ultimo_envio_inicio').AsDateTime := Trunc(DtaUltimoEnvioInicio);
  End;

  If DtaUltimoEnvioFim > 0 Then Begin
    Query.ParamByName('dta_ultimo_envio_fim').AsDateTime := Trunc(DtaUltimoEnvioFim)+1;
  End;
  {$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1870, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1870;
      Exit;
    End;
  End;
end;

function TIntEmailsEnvio.PesquisarArquivosAnexos(CodEmailEnvio: Integer): Integer;
Const
  CodMetodo : Integer = 570;
  NomMetodo : String = 'PesquisarArquivosAnexos';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select cod_email_envio     as CodEmailEnvio,     '+
                '        nom_arquivo_anexo   as NomArquivo,        '+
                '        txt_caminho_arquivo as TxtCaminhoArquivo, '+
                '        qtd_bytes_arquivo   as QtdBytesArquivo    '+
                '   from tab_email_envio_arquivo_anexo             '+
                '  where cod_email_envio     = :cod_email_envio    '+
                ' order by nom_arquivo_anexo                       ');
  {$ENDIF}
  Query.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1891, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1891;
      Exit;
    End;
  End;
end;

function TIntEmailsEnvio.PesquisarDestinatarios(CodEmailEnvio: Integer): Integer;
Const
  CodMetodo : Integer = 571;
  NomMetodo : String = 'PesquisarDestinatarios';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select des.cod_email_envio        as CodEmailEnvio,            '+
                '        des.txt_email_destinatario as TxtEmailDestinatario,     '+
                '        des.cod_tipo_destinatario  as CodTipoDestinatario,      '+
                '        tip.des_tipo_destinatario  as DesTipoDestinatario,      '+
                '        des.cod_pessoa             as CodPessoa,                '+
                '        pes.nom_pessoa             as NomPessoa                 '+
                '   from tab_email_envio_destinatario des,                       '+
                '        tab_tipo_destinatario        tip,                       '+
                '        tab_pessoa                   pes                        '+
                '  where des.cod_tipo_destinatario  = tip.cod_tipo_destinatario  '+
                '    and des.cod_pessoa            *= pes.cod_pessoa             '+
                '    and des.cod_email_envio        = :cod_email_envio           '+
                ' order by des.txt_email_destinatario                            ');
  {$ENDIF}
  Query.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1890, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1890;
      Exit;
    End;
  End;
end;

function TIntEmailsEnvio.Inserir(CodTipoEmail: Integer; TxtAssunto,
  TxtCorpoEmail: String): Integer;
var
  Q, Q2 : THerdomQuery;
  NewCodEmailEnvio: Integer;
  CodRegistroLog: Integer;
  CodTipoDestinatario: Integer;
Const
  NomMetodo: String  = 'Inserir';
  CodMetodo: Integer = 575;
begin
  //------------------------ Validações ----------------------------------------
  If CodTipoEmail <= 0 Then Begin
    Mensagens.Adicionar(1850, Self.ClassName, NomMetodo, [IntToStr(CodTipoEmail)]);
    Result := -1850;
    Exit;
  End;

  Result := VerificaString(TxtAssunto, 'O campo assunto, para envio de e-mail,');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------- Verifica se existe tipo email ---------------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select cod_tipo_destinatario_admin from tab_tipo_email            '+
                '  where cod_tipo_email = :cod_tipo_email ');
      {$ENDIF}
      Q.ParamByName('cod_tipo_email').AsInteger := CodTipoEmail;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1850, Self.ClassName, NomMetodo, [IntToStr(CodTipoEmail)]);
        Result := -1850;
        Exit;
      End;

      CodTipoDestinatario :=  Q.FieldByName('cod_tipo_destinatario_admin').AsInteger;

      //-------------------- Busca usuários administradores --------------------
      Q2.Close;
      Q2.SQL.Clear;
      {$IFDEF MSSQL}
      Q2.SQL.Add(' select distinct u.cod_pessoa,                                          '+
                 '        dbo.fnt_buscar_contato_principal(u.cod_pessoa, ''E'') as email  '+
                 '   from tab_usuario_admin_tipo_email a,                                 '+
                 '        tab_usuario u                                                   '+
                 '  where a.cod_usuario    = u.cod_usuario                                '+
                 '    and a.cod_tipo_email = :cod_tipo_email                              ');
      {$ENDIF}
      Q2.ParamByName('cod_tipo_email').AsInteger := CodTipoEmail;
      Q2.Open;

      //------------------- Busca o código do email ----------------------------

      Result := ObterCodEmailEnvio(NewCodEmailEnvio);
      If Result < 0 then Begin
        Exit;
      End;

      If NewCodEmailEnvio <= 0 then Begin
        Mensagens.Adicionar(1849, Self.ClassName, NomMetodo, []);
        Result := -1849;
        Exit;
      End;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      end;

      BeginTran;

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' insert into tab_email_envio   ('+
                '   cod_email_envio,             '+
                '   cod_tipo_email,              '+
                '   txt_assunto,                 '+
                '   txt_corpo_email,             '+
                '   txt_mensagem,                '+
                '   cod_tipo_mensagem,           '+
                '   cod_situacao_email,          '+
                '   qtd_vezes_envio,             '+
                '   qtd_duracao_envio,           '+
                '   dta_ultimo_envio,            '+
                '   cod_registro_log             '+
                ' ) values (                     '+
                '   :cod_email_envio,            '+
                '   :cod_tipo_email,             '+
                '   :txt_assunto,                '+
                '   :txt_corpo_email,            '+
                '   null,                        '+
                '   null,                        '+
                '   :cod_situacao_email,         '+
                '   :qtd_vezes_envio,            '+
                '   :qtd_duracao_envio,          '+
                '   null,                        '+
                '   :cod_registro_log)           ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger     := NewCodEmailEnvio;
      Q.ParamByName('cod_tipo_email').AsInteger      := CodTipoEmail;
      Q.ParamByName('txt_assunto').AsString          := TxtAssunto;
      Q.ParamByName('txt_corpo_email').Clear;
      AtribuiParametro(Q, TxtCorpoEmail, 'txt_corpo_email', '');
      Q.ParamByName('cod_situacao_email').AsInteger  := 4; //Em montagem
      Q.ParamByName('qtd_vezes_envio').AsInteger     := 0;
      Q.ParamByName('qtd_duracao_envio').AsInteger   := 0;
      Q.ParamByName('cod_registro_log').AsInteger    := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_email_envio', CodRegistroLog, 1, CodMetodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      Commit;

      If Not Q2.IsEmpty Then Begin
        While Not Q2.Eof Do Begin
          If Not Q2.FieldByName('email').IsNull Then Begin
            Result := AdicionarDestinatario(NewCodEmailEnvio, Q2.FieldByName('email').AsString, CodTipoDestinatario, Q2.FieldByName('cod_pessoa').AsInteger);
            If Result < 0 Then begin
              Break;
              Exit;
            End;
          End;
          Q2.Next;
        End;
      End;

      If Result < 0 Then Begin
        Exit;
      End;

      Result := NewCodEmailEnvio;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1851, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1851;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    Q2.Free;
  End;
end;

function TIntEmailsEnvio.AdicionarDestinatario(CodEmailEnvio: Integer;
  TxtEmailDestinatario: String; CodTipoDestinatario, CodPessoa: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomMetodo: String  = 'AdicionarDestinatario';
begin
  //------------------------ Validações ----------------------------------------
  If CodEmailEnvio <= 0 Then Begin
    Mensagens.Adicionar(1852, Self.ClassName, NomMetodo, [IntToStr(CodEmailEnvio)]);
    Result := -1852;
    Exit;
  End;

  Result := VerificaString(TxtEmailDestinatario, 'E-mail Destinatário');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(TxtEmailDestinatario, 255, 'E-mail Destinatário');
  If Result < 0 Then Begin
    Exit;
  End;

  If CodTipoDestinatario <= 0 Then Begin
    Mensagens.Adicionar(1853, Self.ClassName, NomMetodo, [IntToStr(CodTipoDestinatario)]);
    Result := -1853;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------- Verifica se existe email --------------------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_email_envio             '+
                '  where cod_situacao_email in (1, 4)       '+
                '    and cod_email_envio = :cod_email_envio ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1852, Self.ClassName, NomMetodo, [IntToStr(CodEmailEnvio)]);
        Result := -1852;
        Exit;
      End;

      //-------------------- Verifica se existe tipo destinatario --------------

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_tipo_destinatario                   '+
                '  where cod_tipo_destinatario = :cod_tipo_destinatario ');
      {$ENDIF}
      Q.ParamByName('cod_tipo_destinatario').AsInteger := CodTipoDestinatario;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1853, Self.ClassName, NomMetodo, [IntToStr(CodTipoDestinatario)]);
        Result := -1853;
        Exit;
      End;

      //---------------- Verifica se já existe um destinatoario para o e-mail --

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_email_envio_destinatario              '+
                '  where txt_email_destinatario = :txt_email_destinatario '+
                '    and cod_email_envio        = :cod_email_envio        ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger       := CodEmailEnvio;
      Q.ParamByName('txt_email_destinatario').AsString := TxtEmailDestinatario;
      Q.Open;

      If Not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1861, Self.ClassName, NomMetodo, []);
        Result := -1861;
        Exit;
      End;

      //-------------------- Adiciona Destinatario -----------------------------

      BeginTran;

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' insert into tab_email_envio_destinatario ('+
                '   cod_email_envio,                        '+
                '   cod_tipo_destinatario,                  '+
                '   txt_email_destinatario,                 '+
                '   cod_pessoa                              '+
                ' ) values (                                '+
                '   :cod_email_envio,                       '+
                '   :cod_tipo_destinatario,                 '+
                '   :txt_email_destinatario,                '+
                '   :cod_pessoa)                            ');

      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger         := CodEmailEnvio;
      Q.ParamByName('cod_tipo_destinatario').AsInteger   := CodTipoDestinatario;
      Q.ParamByName('txt_email_destinatario').AsString   := TxtEmailDestinatario;
      AtribuiParametro(Q, CodPessoa,  'cod_pessoa', -1);
      Q.ExecSQL;

      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1854, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1854;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEmailsEnvio.AdicionarArquivoAnexo(CodEmailEnvio: Integer;
  NomArquivoAnexo, TxtCaminhoArquivo: String): Integer;
var
  Q : THerdomQuery;
  Aux: String;
  QtdBytesArquivo: Integer;
  ArquivoAnexo: String;
Const
  NomMetodo: String  = 'AdicionarArquivoAnexo';
begin
  //------------------------ Validações ----------------------------------------
  If CodEmailEnvio <= 0 Then Begin
    Mensagens.Adicionar(1852, Self.ClassName, NomMetodo, [IntToStr(CodEmailEnvio)]);
    Result := -1852;
    Exit;
  End;

  Result := VerificaString(NomArquivoAnexo, 'Nome do arquivo anexo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(NomArquivoAnexo, 255, 'Nome do arquivo anexo');
  If Result < 0 Then Begin
    Exit;
  End;

  //-- Retira a barra no final do local caso exista.
  Aux := TxtCaminhoArquivo;
  If Copy(Aux, Length(Aux), 1) = '\' Then begin
    Delete(Aux, Length(Aux), 1);
    TxtCaminhoArquivo := Aux;
  End;

  Result := VerificaString(TxtCaminhoArquivo, 'Caminho do arquivo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(TxtCaminhoArquivo, 255, 'Caminho do arquivo');
  If Result < 0 Then Begin
    Exit;
  End;

  ArquivoAnexo := TxtCaminhoArquivo + '\' + NomArquivoAnexo;
  If not FileExists(ArquivoAnexo) Then Begin
    Mensagens.Adicionar(1888, Self.ClassName, NomMetodo, []);
    Result := -1888;
    Exit;
  End;

  Try
    With TFileStream.Create(ArquivoAnexo, fmOpenRead or fmShareExclusive) Do Begin
      Try
        QtdBytesArquivo := Size;
      Finally
        Free;
      End;
    End;
  Except
    QtdBytesArquivo := 0;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------- Verifica se existe email --------------------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_email_envio             '+
                '  where cod_situacao_email in (1, 4)       '+
                '    and cod_email_envio = :cod_email_envio ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1852, Self.ClassName, NomMetodo, [IntToStr(CodEmailEnvio)]);
        Result := -1852;
        Exit;
      End;

      //-------------------- Adiciona Destinatario -----------------------------

      BeginTran;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' insert into tab_email_envio_arquivo_anexo ('+
                '   cod_email_envio,                         '+
                '   nom_arquivo_anexo,                       '+
                '   txt_caminho_arquivo,                     '+
                '   qtd_bytes_arquivo                        '+
                ' ) values (                                 '+
                '   :cod_email_envio,                        '+
                '   :nom_arquivo_anexo,                      '+
                '   :txt_caminho_arquivo,                    '+
                '   :qtd_bytes_arquivo)                      ');

      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger    := CodEmailEnvio;
      Q.ParamByName('nom_arquivo_anexo').AsString   := NomArquivoAnexo;
      Q.ParamByName('txt_caminho_arquivo').AsString := TxtCaminhoArquivo;
      Q.ParamByName('qtd_bytes_arquivo').AsInteger    := QtdBytesArquivo;
      Q.ExecSQL;

      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1855, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1855;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEmailsEnvio.Enviar(CodEmailEnvio: Integer): Integer;
var
  Q, Q1, Q2: THerdomQuery;
  NumTentativa, MaxTentativa: Integer;
  A: TIntOcorrenciasSistema;
  CodTipoMensagem: Integer;
  TxtMensagem: String;
  DtaUltimoEnvio: TDateTime;
  Resultado: Integer;
  MsgEmail: TidMessage;
  idSMTP: TIdSMTP;
  ServidorSMTP, NomeUsuario, LoginUsuario, SenhaUsuario, EmailUsuario: String;
  varaux, varaux1, ArquivoAnexo: String;
  QtdDuracaoEnvio: Integer;
  DtaInicio: TDateTime;
Const
  CodMetodo: Integer = 568;
  NomMetodo: String = 'Enviar';
  CodAplicativo: Integer = 3;
  TxtLegenda: String = 'Código do e-mail';
begin
  MaxTentativa    := 0;
  Resultado       := 0;
  TxtMensagem     := '';
  CodTipoMensagem := 0;


  //------------------------ Validações ----------------------------------------
  If CodEmailEnvio <= 0 Then Begin
    Mensagens.Adicionar(1856, Self.ClassName, NomMetodo, []);
    Result := -1856;
    Exit;
  End;


  Q  := THerdomQuery.Create(Conexao, nil);
  Q1 := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  Try
    //--------------------------- Busca parametro sistema ------------------------

    If Resultado = 0 Then Begin
      Try
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select val_parametro_sistema      '+
                  '  from tab_parametro_sistema      '+
                  ' where cod_parametro_sistema = 77 ');
        {$ENDIF}
        Q.Open;

        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['77']);
          Resultado       := -1879;
          TxtMensagem     := Mensagens.GerarMensagem(1879, ['77']);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
        End;

        If Resultado = 0 Then Begin
          Try
            MaxTentativa := StrToInt(Q.FieldByName('val_parametro_sistema').AsString);
          Except
            MaxTentativa := 0;
          End;

          If MaxTentativa = 0 Then Begin
            Mensagens.Adicionar(1713, Self.ClassName, NomMetodo, ['77']);
            Resultado       := -1713;
            TxtMensagem     := Mensagens.GerarMensagem(1713, ['77']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1713);
          End;
        End;

        // ---------------- Busca servidor -------------------------------------

        If Resultado = 0 Then Begin
          Q.Close;
          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('select val_parametro_sistema      '+
                    '  from tab_parametro_sistema      '+
                    ' where cod_parametro_sistema = 79 ');
          {$ENDIF}
          Q.Open;

          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['79']);
            Resultado       := -1879;
            TxtMensagem     := Mensagens.GerarMensagem(1879, ['79']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
          End Else Begin
            ServidorSMTP := Q.FieldByName('val_parametro_sistema').AsString;
          End;
        End;

        // ---------------- Busca Nome do Usuario ------------------------------

        If Resultado = 0 Then Begin
          Q.Close;
          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('select val_parametro_sistema      '+
                    '  from tab_parametro_sistema      '+
                    ' where cod_parametro_sistema = 80 ');
          {$ENDIF}
          Q.Open;

          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['80']);
            Resultado       := -1879;
            TxtMensagem     := Mensagens.GerarMensagem(1879, ['80']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
          End Else Begin
            NomeUsuario := Q.FieldByName('val_parametro_sistema').AsString;
          End;
        End;

        // ---------------- Busca Login Usuario --------------------------------

        If Resultado = 0 Then Begin
          Q.Close;
          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('select val_parametro_sistema      '+
                    '  from tab_parametro_sistema      '+
                    ' where cod_parametro_sistema = 81 ');
          {$ENDIF}
          Q.Open;

          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['81']);
            Resultado       := -1879;
            TxtMensagem     := Mensagens.GerarMensagem(1879, ['81']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
          End Else Begin
            LoginUsuario := Q.FieldByName('val_parametro_sistema').AsString;
          End;
        End;

        // ---------------- Busca Senha Usuario --------------------------------

        If Resultado = 0 Then Begin
          Q.Close;
          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('select val_parametro_sistema      '+
                    '  from tab_parametro_sistema      '+
                    ' where cod_parametro_sistema = 82 ');
          {$ENDIF}
          Q.Open;

          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['82']);
            Resultado       := -1879;
            TxtMensagem     := Mensagens.GerarMensagem(1879, ['82']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
          End Else Begin
            SenhaUsuario := Descriptografar(Q.FieldByName('val_parametro_sistema').AsString);
          End;
        End;

        // ---------------- Busca Email Usuario --------------------------------

        If Resultado = 0 Then Begin
          Q.Close;
          Q.SQL.Clear;
          {$IFDEF MSSQL}
          Q.SQL.Add('select val_parametro_sistema      '+
                    '  from tab_parametro_sistema      '+
                    ' where cod_parametro_sistema = 83 ');
          {$ENDIF}
          Q.Open;

          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, ['83']);
            Resultado       := -1879;
            TxtMensagem     := Mensagens.GerarMensagem(1879, ['83']);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1879);
          End Else Begin
            EmailUsuario := Q.FieldByName('val_parametro_sistema').AsString;
          End;
        End;
      Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(1858, Self.ClassName, NomMetodo, [E.Message]);
          Resultado       := -1858;
          TxtMensagem     := Mensagens.GerarMensagem(1858, [E.Message]);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1858);
        End;
      End;
    End;

    //------------------ Busca dados do email ----------------------------------

    Q.Close;
    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('select cod_email_envio,                     '+
              '       cod_tipo_email,                      '+
              '       txt_assunto,                         '+
              '       txt_corpo_email,                     '+
              '       cod_situacao_email,                  '+
              '       qtd_vezes_envio                      '+
              '  from tab_email_envio                      '+
              ' where cod_email_envio = :cod_email_envio   ');
    {$ENDIF}
    Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
    Try
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1856, Self.ClassName, NomMetodo, []);
        Result := -1856;
        Exit;
      End Else Begin
        NumTentativa := Q.FieldByName('qtd_vezes_envio').AsInteger + 1;
      End;

      If Q.FieldByName('cod_situacao_email').AsInteger <> 1 Then Begin
        Mensagens.Adicionar(1859, Self.ClassName, NomMetodo, []);
        Result := -1859;
        Exit;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1858, Self.ClassName, NomMetodo, [E.Message]);
        Result    := -1858;
        Exit;
      End;
    End;

    //------------------ Busca dados do destinatario ---------------------------

    If Resultado = 0 Then Begin
      Q1.Close;
      Q1.SQL.Clear;
      {$IFDEF MSSQL}
      Q1.SQL.Add('select des.cod_email_envio,                '+
                 '       des.txt_email_destinatario,         '+
                 '       des.cod_pessoa,                     '+
                 '       pes.nom_pessoa,                     '+
                 '       des.cod_tipo_destinatario           '+
                 '  from tab_email_envio_destinatario des,   '+
                 '       tab_pessoa                   pes    '+
                 ' where des.cod_pessoa  *= pes.cod_pessoa   '+
                 '   and cod_email_envio = :cod_email_envio  ');
      {$ENDIF}
      Q1.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Try
        Q1.Open;

        If Q1.IsEmpty Then Begin
          Mensagens.Adicionar(1860, Self.ClassName, NomMetodo, []);
          Resultado       := -1860;
          TxtMensagem     := Mensagens.GerarMensagem(1860, [] );
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1860);
        End;
      Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(1858, Self.ClassName, NomMetodo, [E.Message]);
          Resultado       := -1858;
          TxtMensagem     := Mensagens.GerarMensagem(1858, [E.Message]);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1858);
        End;
      End;
    End;

    //------------------ Busca dados do arquivo --------------------------------

    If Resultado = 0 Then Begin
      Q2.Close;
      Q2.SQL.Clear;
      {$IFDEF MSSQL}
      Q2.SQL.Add('select cod_email_envio,                    '+
                 '       nom_arquivo_anexo,                  '+
                 '       txt_caminho_arquivo                 '+
                 '  from tab_email_envio_arquivo_anexo       '+
                 ' where cod_email_envio = :cod_email_envio  ');
      {$ENDIF}
      Q2.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Try
        Q2.Open;
      Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(1858, Self.ClassName, NomMetodo, [E.Message]);
          Resultado       := -1858;
          TxtMensagem     := Mensagens.GerarMensagem(1858, [E.Message]);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1858);
        End;
      End;
    End;

    //-------------------- Executa o Envio -------------------------------------

    DtaInicio := Now;

    If Resultado = 0 Then Begin
      idSMTP   := TIdSMTP.Create(Nil);
      MsgEmail := TidMessage.Create(idSMTP);
      Try

        MsgEmail.From.Name      := NomeUsuario;
        MsgEmail.From.Address   := EmailUsuario;

        // ------------- Destinatarios -----------------------------------------

        While Not Q1.Eof Do Begin
          Case Q1.FieldByName('cod_tipo_destinatario').AsInteger Of
            1:Begin
                  if pos(';',Q1.FieldByName('txt_email_destinatario').AsString) > 0 then begin
                    varaux := Q1.FieldByName('txt_email_destinatario').AsString;
                    while pos(';',varaux) > 0 do begin
                      varaux1 := copy(varaux,0,pos(';',varaux)-1);
                      varaux  := copy(varaux,pos(';',varaux)+1,1500);
                      MsgEmail.Recipients.Add.Text := varaux1;
                    end;
                    MsgEmail.Recipients.Add.Text := varaux;
                  end else begin
                    MsgEmail.Recipients.Add.Text := Q1.FieldByName('txt_email_destinatario').AsString;
                  end;
              End;

            2:Begin
                  if pos(';',Q1.FieldByName('txt_email_destinatario').AsString) > 0 then begin
                    varaux := Q1.FieldByName('txt_email_destinatario').AsString;
                    while pos(';',varaux) > 0 do begin
                      varaux1 := copy(varaux,0,pos(';',varaux)-1);
                      varaux  := copy(varaux,pos(';',varaux)+1,1500);
                      MsgEmail.CCList.Add.Text := varaux1;
                    end;
                    MsgEmail.CCList.Add.Text := varaux;
                  end else begin
                    MsgEmail.CCList.Add.Text := Q1.FieldByName('txt_email_destinatario').AsString;
                  end;
              End;

            3:Begin
                  if pos(';',Q1.FieldByName('txt_email_destinatario').AsString) > 0 then begin
                    varaux := Q1.FieldByName('txt_email_destinatario').AsString;
                    while pos(';',varaux) > 0 do begin
                      varaux1 := copy(varaux,0,pos(';',varaux)-1);
                      varaux  := copy(varaux,pos(';',varaux)+1,1500);
                      MsgEmail.BccList.Add.Text := varaux1;
                    end;
                    MsgEmail.BccList.Add.Text := varaux;
                  end else begin
                    MsgEmail.BccList.Add.Text := Q1.FieldByName('txt_email_destinatario').AsString;
                  end;
              End;
          End;
          Q1.Next;
        End;

        // ------------- Assunto e Corpo ---------------------------------------

        MsgEmail.Subject      := Q.FieldbyName('txt_assunto').AsString;
        If Not Q.FieldbyName('txt_corpo_email').IsNull Then begin
          MsgEmail.Body.Text := Q.FieldbyName('txt_corpo_email').AsString;
        End;
        MsgEmail.Body.Add('');
        MsgEmail.Body.Add('(e-mail '+ Q.FieldbyName('cod_email_envio').AsString + ')');

        // ------------- Anexos ------------------------------------------------

        if Not Q2.IsEmpty Then Begin
          While Not Q2.Eof Do Begin
            ArquivoAnexo := Q2.FieldByName('txt_caminho_arquivo').AsString + '\' + Q2.FieldByName('nom_arquivo_anexo').AsString;
            If FileExists(ArquivoAnexo) Then Begin
              TIdAttachment.Create(MsgEmail.MessageParts, TFileName(ArquivoAnexo));
            End Else Begin
              Mensagens.Adicionar(1863, Self.ClassName, NomMetodo, []);
              Resultado       := -1863;
              TxtMensagem     := Mensagens.GerarMensagem(1863, []);
              CodTipoMensagem := Mensagens.BuscarTipoMensagem(1863);
              Break;
            End;
            Q2.Next;
          End;
        End;

        If Resultado = 0 Then Begin
          Try
            idSMTP.AuthenticationType := atLogin;

            idSMTP.Username  := LoginUsuario;
            idSMTP.Password  := SenhaUsuario;
            idSMTP.Host      := ServidorSMTP;
            idSMTP.Port			 := 587;
            idSMTP.Connect;

            if not idSMTP.Authenticate then
            begin
              Mensagens.Adicionar(2238, Self.ClassName, NomMetodo, []);
              Resultado       := -2238;
              TxtMensagem     := Mensagens.GerarMensagem(2238, []);
              CodTipoMensagem := Mensagens.BuscarTipoMensagem(2238);
            end;
          Except
            On E:Exception do begin
              Mensagens.Adicionar(1864, Self.ClassName, NomMetodo, [E.Message]);
              Resultado       := -1864;
              TxtMensagem     := Mensagens.GerarMensagem(1864, [E.Message]);
              CodTipoMensagem := Mensagens.BuscarTipoMensagem(1864);
            End;
          End;

          If Resultado = 0 Then Begin
            Try
              idSMTP.Send(MsgEmail);
            Except
              On E:Exception Do Begin
                Mensagens.Adicionar(1865, Self.ClassName, NomMetodo, [E.Message]);
                Resultado       := -1865;
                TxtMensagem     := Mensagens.GerarMensagem(1865, [E.Message]);
                CodTipoMensagem := Mensagens.BuscarTipoMensagem(1865);
              End;
            End;
          End;

          If Resultado = 0 Then Begin
            TxtMensagem     := Mensagens.GerarMensagem(1868, []);
            CodTipoMensagem := Mensagens.BuscarTipoMensagem(1868);
          End;
        End;
      Finally
        idSMTP.Disconnect;
        MsgEmail.Free;
        idSMTP.Free;
      End;
    End;

    QtdDuracaoEnvio := Round((Now - DtaInicio) * 24 * 60 * 60);
    If QtdDuracaoEnvio = 0 Then Begin
      QtdDuracaoEnvio := 1;
    End;

    DtaUltimoEnvio := Now;

    //-------------------- Atualiza tab_arquivo_ftp_envio ----------------------

    BeginTran;
    Try
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' update tab_email_envio                               '+
                '    set cod_tipo_mensagem   = :cod_tipo_mensagem,     '+
                '        txt_mensagem        = :txt_mensagem,          '+
                '        qtd_vezes_envio     = qtd_vezes_envio + 1,    '+
                '        dta_ultimo_envio    = :dta_ultimo_envio,      '+
                '        cod_situacao_email  = :cod_situacao_email,    '+
                '        qtd_duracao_envio   = :qtd_duracao_envio      '+
                '  where cod_email_envio     = :cod_email_envio        ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger    := CodEmailEnvio;
      Q.ParamByName('cod_tipo_mensagem').AsInteger  := CodTipoMensagem;
      Q.ParamByName('txt_mensagem').AsString        := TxtMensagem;
      Q.ParamByName('dta_ultimo_envio').AsDateTime  := DtaUltimoEnvio;
      Q.ParamByName('qtd_duracao_envio').AsInteger  := QtdDuracaoEnvio;
      If Resultado = 0 Then Begin
        Q.ParamByName('cod_situacao_email').AsInteger := 3;   //SUCESSO
      End Else Begin
        If (NumTentativa = 0) or (MaxTentativa = 0) Then Begin
          Q.ParamByName('cod_situacao_email').AsInteger := 1; //PENDENTE
        End Else Begin
          If NumTentativa >= MaxTentativa Then Begin
            Q.ParamByName('cod_situacao_email').AsInteger := 2; //ERRO
          End Else Begin
            Q.ParamByName('cod_situacao_email').AsInteger := 1; //PENDENTE
          End;
        End;
      End;
      Q.ExecSQL;

      Commit;

      //----- Grava ocorrencia caso necessario ---------------------------------
      If Resultado < 0 Then Begin
        If (NumTentativa > 0) and (MaxTentativa > 0) Then Begin
          If NumTentativa >= MaxTentativa Then Begin
            A := TIntOcorrenciasSistema.Create;
            Try
              TxtMensagem      := Mensagens.GerarMensagem(1866, []);
              CodTipoMensagem  := Mensagens.BuscarTipoMensagem(1866);

              A.Inicializar(Conexao, Mensagens);
              A.Inserir(CodAplicativo, CodMetodo, CodTipoMensagem, TxtMensagem, IntToStr(CodEmailEnvio), TxtLegenda);
            Finally
              A.Free;
            End;
          End;
        End;
      End;

      Result := Resultado;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1858, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1858;
      End;
    End;
  Finally
    Q.Free;
    Q1.Free;
    Q2.Free;
  End;
end;

function TIntEmailsEnvio.ObterCodEmailEnvio(var CodEmailEnvio: Integer): Integer;
const
  NomMetodo: String = 'ObterCodEmailEnvio';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      BeginTran;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_email_envio), 0) + 1 as CodSeqEmailEnvio from tab_seq_email_envio');
      {$ENDIF}
      Q.Open;

      CodEmailEnvio := Q.FieldByName('CodSeqEmailEnvio').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_email_envio set cod_seq_email_envio = cod_seq_email_envio + 1');
      {$ENDIF}
      Q.ExecSQL;

      Commit;

      Result := CodEmailEnvio;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1849, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1849;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntEmailsEnvio.AlterarSituacaoParaPendente(
  CodEmailEnvio: Integer; IndChamadaInterna: String = 'N'): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog: Integer;
Const
  CodMetodo : Integer = 572;
  NomMetodo : String = 'AlterarSituacaoParaPendente';
begin
  Result := -1;

  If IndChamadaInterna = 'N' Then Begin
    If Not Inicializado Then Begin
      RaiseNaoInicializado(NomMetodo);
      Exit;
    End;

    If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
      Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
      Result := -188;
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select cod_registro_log from tab_email_envio  '+
                '  where cod_email_envio = :cod_email_envio     ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1852, Self.ClassName, NomMetodo, [IntToStr(CodEmailEnvio)]);
        Result := -1852;
        Exit;
      End;

      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_email_envio', CodRegistroLog, 2, CodMetodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;


      BeginTran;

      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' update tab_email_envio                       '+
                '    set cod_situacao_email = 1,               '+
                '        qtd_vezes_envio    = 0                '+
                '  where cod_email_envio    = :cod_email_envio ');
      {$ENDIF}
      Q.ParamByName('cod_email_envio').AsInteger := CodEmailEnvio;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_email_envio', CodRegistroLog, 3, CodMetodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;


      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1889, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1889;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

