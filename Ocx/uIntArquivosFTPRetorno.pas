// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 04/08/2004
// *  Documentação       : Arquivos FTP de Retorno - Definição das Classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo recebido via FTP
// *                       pelo sistema
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntArquivosFTPRetorno;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, Classes, sysutils, db, uConexao, uIntMensagens,
     uIntArquivoFTPRetorno, IdFTP, uIntOcorrenciasSistema, uFerramentas;

type
{ TIntArquivosFTPRetorno }
  TIntArquivosFTPRetorno = class(TIntClasseBDNavegacaoBasica)
  private
    FIntArquivoFTPRetorno : TIntArquivoFTPRetorno;

    function ObterCodArquivoFTPRetorno(var CodArquivoFTPRetorno: Integer): Integer;

    function ExecutarFTP(CodRotinaFTPRetorno: Integer;
                         TxtMaquinaRemota,
                         TxtPortaRemota,
                         TxtUsuarioMaquina,
                         TxtSenhaMaquina,
                         TxtCaminhoRemoto,
                         TxtArquivoRemoto,
                         TxtCaminhoLocal,
                         TxtArquivoLocal: String;
                         ReadTimeOut: Integer;
                         var QtdDuracao: Integer;
                         var CodTipoMensagem: Integer;
                         var TxtMensagem: String): Integer;

    function ObterNomeArquivo(NomArquivo: String): String;

    function MontarListaArquivos(CodRotinaFTPRetorno: Integer;
                                 TxtMaquinaRemota,
                                 TxtPortaRemota,
                                 TxtUsuarioMaquina,
                                 TxtSenhaMaquina,
                                 TxtMascaraArquivo,
                                 TxtCaminhoRemoto: String;
                                 ReadTimeOut: Integer;
                                 DtaCorte: TDateTime;
                                 var ListaArquivos: TStringList): Integer;

    function MoverArquivoRemoto(CodRotinaFTPRetorno: Integer;
                                TxtMaquinaRemota,
                                TxtPortaRemota,
                                TxtUsuarioMaquina,
                                TxtSenhaMaquina,
                                TxtCaminhoRemoto,
                                TxtCaminhoMovido,
                                TxtArquivo: String;
                                ReadTimeOut: Integer;
                                var CodTipoMensagem: Integer;
                                var TxtMensagem: String): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Pesquisar(CodRotinaFTPRetorno: Integer; NomArquivoLocal: String;
                       CodTipoMensagem, CodSituacaoArquivoFTP: Integer;
                       DtaTransferenciaArquivoInicio, DtaTransferenciaArquivoFim: TDateTime;
                       IndAindaSemTransferencia: String): Integer;
    function AlterarSituacaoParaPendente(CodArquivoFTPRetorno: Integer): Integer;

    function Buscar(CodArquivoFTPRetorno: Integer): Integer;

    function Receber(CodRotinaFTPRetorno, ReadTimeOut: Integer): Integer;

    property IntArquivoFTPRetorno : TIntArquivoFTPRetorno read FIntArquivoFTPRetorno write FIntArquivoFTPRetorno;
  end;

implementation

uses Math, IdFTPList, Masks;

constructor TIntArquivosFTPRetorno.Create;
begin
  inherited;
  FIntArquivoFTPRetorno := TIntArquivoFTPRetorno.Create;
end;

destructor TIntArquivosFTPRetorno.Destroy;
begin
  FIntArquivoFTPRetorno.Free;
  inherited;
end;

{ TIntArquivosFTPRetorno }
function TIntArquivosFTPRetorno.Pesquisar(CodRotinaFTPRetorno: Integer; NomArquivoLocal: String;
                                          CodTipoMensagem, CodSituacaoArquivoFTP: Integer;
                                          DtaTransferenciaArquivoInicio, DtaTransferenciaArquivoFim: TDateTime;
                                          IndAindaSemTransferencia: String): Integer;
Const
  CodMetodo: Integer = 536;
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

  If (DtaTransferenciaArquivoInicio = 0) and (DtaTransferenciaArquivoFim = 0) and (IndAindaSemTransferencia <> '') Then Begin
    Mensagens.Adicionar(1883, Self.ClassName, NomMetodo, []);
    Result := -1883;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select arq.cod_arquivo_ftp_retorno      as CodArquivoFTPRetorno,    '+
                '       arq.cod_rotina_ftp_retorno       as CodRotinaFTPRetorno,     '+
                '       rot.des_rotina_ftp_retorno       as DesRotinaFTPRetorno,     '+
                '       arq.nom_arquivo_local            as NomArquivoLocal,         '+
                '       arq.nom_arquivo_remoto           as NomArquivoRemoto,        '+
                '       arq.qtd_bytes_arquivo            as QtdBytesArquivo,         '+
                '       arq.cod_tipo_mensagem            as CodTipoMensagem,         '+
                '       msg.des_tipo_mensagem            as DesTipoMensagem,         '+
                '       arq.cod_situacao_arquivo_ftp     as CodSituacaoArquivoFTP,   '+
                '       sit.sgl_situacao_arquivo_ftp     as SglSituacaoArquivoFTP,   '+
                '       arq.dta_ultima_transferencia     as DtaTransferenciaArquivo, '+
                '       arq.qtd_vezes_transferencia      as QtdVezesTransferencia    '+
                '  from tab_arquivo_ftp_retorno     arq,                             '+
                '       tab_situacao_arquivo_ftp    sit,                             '+
                '       tab_rotina_ftp_Retorno      rot,                             '+
                '       tab_tipo_mensagem           msg                              '+
                ' where arq.cod_rotina_ftp_Retorno    = rot.cod_rotina_ftp_retorno   '+
                '   and arq.cod_situacao_arquivo_ftp  = sit.cod_situacao_arquivo_ftp '+
                '   and arq.cod_tipo_mensagem        *= msg.cod_tipo_mensagem        ');

   If CodRotinaFTPRetorno > 0 Then Begin
     Query.SQL.Add(' and arq.cod_rotina_ftp_Retorno = :cod_rotina_ftp_Retorno');
   End;

   If NomArquivoLocal <> '' Then Begin
     Query.SQL.Add(' and arq.nom_arquivo_local like :nom_arquivo_local');
   End;

   If CodTipoMensagem > 0 Then Begin
     Query.SQL.Add(' and arq.cod_tipo_mensagem = :cod_tipo_mensagem');
   End;

   If CodSituacaoArquivoFTP > 0 Then Begin
     Query.SQL.Add(' and arq.cod_situacao_arquivo_ftp = :cod_situacao_arquivo_ftp');
   End;

   If DtaTransferenciaArquivoInicio > 0 Then Begin
     If IndAindaSemTransferencia = 'S' Then Begin
       Query.SQL.Add(' and (arq.dta_ultima_transferencia >= :dta_ultima_transferencia_inicio');
       Query.SQL.Add ('  or arq.dta_ultima_transferencia is null)');
     End Else Begin
       Query.SQL.Add(' and arq.dta_ultima_transferencia >= :dta_ultima_transferencia_inicio');
     End;
   End;

   If DtaTransferenciaArquivoFim > 0 Then Begin
     If IndAindaSemTransferencia = 'S' Then Begin
       Query.SQL.Add(' and (arq.dta_ultima_transferencia <= :dta_ultima_transferencia_fim');
       Query.SQL.Add('  or arq.dta_ultima_transferencia is null)');
     End Else Begin
       Query.SQL.Add(' and arq.dta_ultima_transferencia <= :dta_ultima_transferencia_fim');
     End;
   End;

   Query.SQL.Add(' order by isnull(arq.dta_ultima_transferencia, ''20760101'') desc, arq.cod_arquivo_ftp_retorno desc');

   //---------------- Parâmetros -----------------------------------------------

   If CodRotinaFTPRetorno > 0 Then Begin
     Query.ParamByName('cod_rotina_ftp_Retorno').AsInteger := CodRotinaFTPRetorno;
   End;

   If NomArquivoLocal <> '' Then Begin
     Query.ParamByName('nom_arquivo_local').AsString := '%' + NomArquivoLocal + '%';
   End;

   If CodTipoMensagem > 0 Then Begin
     Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
   End;

   If CodSituacaoArquivoFTP > 0 Then Begin
     Query.ParamByName('cod_situacao_arquivo_ftp').AsInteger := CodSituacaoArquivoFTP;
   End;

   If DtaTransferenciaArquivoInicio > 0 Then Begin
     Query.ParamByName('dta_ultima_transferencia_inicio').AsDateTime := DtaTransferenciaArquivoInicio;
   End;

   If DtaTransferenciaArquivoFim > 0 Then Begin
     Query.ParamByName('dta_ultima_transferencia_fim').AsDateTime := DtaTransferenciaArquivoFim;
   End;
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1734, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1734;
      Exit;
    End;
  End;
end;

function TIntArquivosFTPRetorno.Buscar(CodArquivoFTPRetorno: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo: Integer = 537;
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
      Q.SQL.Add('select arq.cod_arquivo_ftp_retorno,                                 '+
                '       arq.cod_rotina_ftp_retorno,                                  '+
                '       rot.des_rotina_ftp_retorno,                                  '+
                '       arq.nom_arquivo_local,                                       '+
                '       arq.nom_arquivo_remoto,                                      '+
                '       arq.dta_criacao_arquivo,                                     '+
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
                '  from tab_arquivo_ftp_retorno     arq,                             '+
                '       tab_situacao_arquivo_ftp    sit,                             '+
                '       tab_rotina_ftp_retorno      rot,                             '+
                '       tab_tipo_mensagem           msg                              '+
                ' where arq.cod_rotina_ftp_Retorno    = rot.cod_rotina_ftp_retorno   '+
                '   and arq.cod_situacao_arquivo_ftp  = sit.cod_situacao_arquivo_ftp '+
                '   and arq.cod_tipo_mensagem        *= msg.cod_tipo_mensagem        '+
                '   and arq.cod_arquivo_ftp_Retorno   = :cod_arquivo_ftp_retorno     ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_retorno').AsInteger := CodArquivoFTPRetorno;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1732, Self.ClassName, NomMetodo, []);
        Result := -1732;
        Exit;
      End;

      FIntArquivoFTPRetorno.CodArquivoFTPRetorno    :=  Q.FieldByName('cod_arquivo_ftp_retorno').AsInteger;
      FIntArquivoFTPRetorno.CodRotinaFTPRetorno     :=  Q.FieldByName('cod_rotina_ftp_retorno').AsInteger;
      FIntArquivoFTPRetorno.DesRotinaFTPRetorno     :=  Q.FieldByName('des_rotina_ftp_retorno').AsString;
      FIntArquivoFTPRetorno.NomArquivoLocal         :=  Q.FieldByName('nom_arquivo_local').AsString;
      FIntArquivoFTPRetorno.NomArquivoRemoto        :=  Q.FieldByName('nom_arquivo_remoto').AsString;
      FIntArquivoFTPRetorno.DtaCriacaoArquivo       :=  Q.FieldByName('dta_criacao_arquivo').AsDateTime;
      FIntArquivoFTPRetorno.QtdBytesArquivo         :=  Q.FieldByName('qtd_bytes_arquivo').AsInteger;
      FIntArquivoFTPRetorno.CodTipoMensagem         :=  Q.FieldByName('cod_tipo_mensagem').AsInteger;
      FIntArquivoFTPRetorno.DesTipoMensagem         :=  Q.FieldByName('des_tipo_mensagem').AsString;
      FIntArquivoFTPRetorno.TxtMensagem             :=  Q.FieldByName('txt_mensagem').AsString;
      FIntArquivoFTPRetorno.CodSituacaoArquivoFTP   :=  Q.FieldByName('cod_situacao_arquivo_ftp').AsInteger;
      FIntArquivoFTPRetorno.SglSituacaoArquivoFTP   :=  Q.FieldByName('sgl_situacao_arquivo_ftp').AsString;
      FIntArquivoFTPRetorno.DesSituacaoArquivoFTP   :=  Q.FieldByName('des_situacao_arquivo_ftp').AsString;
      FIntArquivoFTPRetorno.DtaUltimaTransferencia  :=  Q.FieldByName('dta_ultima_transferencia').AsDateTime;
      FIntArquivoFTPRetorno.QtdDuracaoTransferencia :=  Q.FieldByName('qtd_duracao_transferencia').AsInteger;
      FIntArquivoFTPRetorno.QtdVezesTransferencia   :=  Q.FieldByName('qtd_vezes_transferencia').AsInteger;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1733, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1733;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntArquivosFTPRetorno.Receber(CodRotinaFTPRetorno, ReadTimeOut: Integer): Integer;
var
  Q: THerdomQuery;
  Q1: THerdomQuery;
  Q2: THerdomQuery;
  O: TIntOcorrenciasSistema;
  ListaArquivos: TStringList;
  ResultadoGet: Integer;
  ResultadoMove: Integer;
  CodTipoMensagemGet: Integer;
  TxtMensagemGet: String;
  CodTipoMensagemMove: Integer;
  TxtMensagemMove: String;
  CodTipoMensagem: Integer;
  TxtMensagem: String;
  QtdDuracao: Integer;
  DtaCorte: TDateTime;
  MaxTentativa: Integer;
  NumTentativa: Integer;
  CodArquivoFTPRetorno: Integer;
  NewCodArquivoFTPRetorno: Integer;
  QtdBytes: Integer;
  DtaCriacao: TDateTime;
  NomArquivoRemoto: String;
  DtaUltimaTransferencia: TDateTime;
  X: Integer;
  CodRegistroLog: Integer;
Const
  CodMetodo: Integer = 538;
  NomMetodo: String = 'Receber';
  CodAplicativo: Integer = 2;
  TxtLegenda: String = 'Nome do Arquivo';
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    ListaArquivos := TStringList.Create;

    //--------------------------- Busca parametro sistema ------------------------

    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('select val_parametro_sistema                          '+
              '  from tab_parametro_sistema                          '+
              ' where cod_parametro_sistema = :cod_parametro_sistema ');
    {$ENDIF}
    Q.ParamByName('cod_parametro_sistema').AsInteger := 77;
    Try
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1879, Self.ClassName, NomMetodo, [IntToStr(77)]);
        Result := -1879;
        Exit;
      End;

      Try
        MaxTentativa := StrToInt(Q.FieldByName('val_parametro_sistema').AsString);
      Except
        MaxTentativa := 0;
      End;

      If MaxTentativa = 0 Then Begin
        Mensagens.Adicionar(1713, Self.ClassName, NomMetodo, [IntToStr(77)]);
        Result := -1713;
        Exit;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1736, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1736;
        Exit;
      End;
    End;

    //------------------ Busca dados rotina -------------------------------------

    Q.Close;
    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('select cod_rotina_ftp_retorno,                           '+
              '       des_rotina_ftp_retorno,                           '+
              '       txt_endereco_maquina_remota,                      '+
              '       txt_porta_maquina_remota,                         '+
              '       txt_usuario_maquina_remota,                       '+
              '       txt_senha_maquina_remota,                         '+
              '       txt_caminho_remoto,                               '+
              '       txt_mascara_arquivo_remoto,                       '+
              '       ind_mover_arquivo_remoto,                         '+
              '       txt_caminho_arquivo_movido,                       '+
              '       txt_caminho_local,                                '+
              '       txt_prefixo_arquivo_local,                        '+
              '       qtd_dias_retroativos_corte,                       '+
              '       dta_criacao_ultimo_arquivo,                       '+
              '       dta_ultima_transferencia,                         '+
              '       dta_fim_validade                                  '+
              '  from tab_rotina_ftp_retorno                            '+
              ' where cod_rotina_ftp_retorno  = :cod_rotina_ftp_retorno ');
    {$ENDIF}
    Q.ParamByName('cod_rotina_ftp_retorno').AsInteger := CodRotinaFTPRetorno;
    Try
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1737, Self.ClassName, NomMetodo, [IntToStr(CodRotinaFTPRetorno)]);
        Result := -1737;
        Exit;
      End;

      If not Q.FieldByName('dta_fim_validade').IsNull Then Begin
        Mensagens.Adicionar(1738, Self.ClassName, NomMetodo, []);
        Result := -1738;
        Exit;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1736, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1736;
        Exit;
      End;
    End;

    If Q.FieldByName('dta_criacao_ultimo_arquivo').IsNull Then Begin
      DtaCorte := 0;
    End Else Begin
      DtaCorte := Q.FieldByName('dta_criacao_ultimo_arquivo').AsDateTime - Q.FieldByName('qtd_dias_retroativos_corte').AsInteger;
    End;

    //--------------------------------- Atualiza tab_arquivo_ftp_retorno -------

    If (DtaCorte > 0) Then Begin
      CodTipoMensagem := Mensagens.BuscarTipoMensagem(1739);
      TxtMensagem     := Mensagens.GerarMensagem(1739, []);

      O  := TIntOcorrenciasSistema.Create;
      Q1 := THerdomQuery.Create(Conexao, nil);
      Q2 := THerdomQuery.Create(Conexao, nil);
      Try
        O.Inicializar(Conexao, Mensagens);
        Try
          Q1.Close;
          Q1.SQL.Clear;
          {$IFDEF MSSQL}
          Q1.SQL.Add(' select cod_arquivo_ftp_retorno,                            '+
                     '        nom_arquivo_local                                   '+
                     '   from tab_arquivo_ftp_retorno                             '+
                     '  where cod_situacao_arquivo_ftp  = 1                       '+
                     '    and dta_criacao_arquivo       < :dta_criacao_arquivo    '+
                     '    and cod_rotina_ftp_retorno    = :cod_rotina_ftp_retorno ');
          {$ENDIF}
          Q1.ParamByName('dta_criacao_arquivo').AsDateTime   := DtaCorte;
          Q1.ParamByName('cod_rotina_ftp_retorno').AsInteger := CodRotinaFTPRetorno;
          Q1.Open;

          If Not Q1.IsEmpty Then Begin
            While not Q1.Eof Do Begin
              BeginTran;

              Q2.Close;
              Q2.SQL.Clear;
              {$IFDEF MSSQL}
              Q2.SQL.Add(' update tab_arquivo_ftp_retorno                                 '+
                         '    set cod_tipo_mensagem         = :cod_tipo_mensagem,         '+
                         '        txt_mensagem              = :txt_mensagem,              '+
                         '        cod_situacao_arquivo_ftp  = :cod_situacao_arquivo_ftp   '+
                         '  where cod_situacao_arquivo_ftp  = 1                           '+
                         '    and cod_arquivo_ftp_retorno   = :cod_arquivo_ftp_retorno    ');
              {$ENDIF}
              Q2.ParamByName('cod_arquivo_ftp_retorno').AsInteger  := Q1.FieldByName('cod_arquivo_ftp_retorno').AsInteger;
              Q2.ParamByName('cod_tipo_mensagem').AsInteger        := CodTipoMensagem;
              Q2.ParamByName('txt_mensagem').AsString              := TxtMensagem;
              Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 2;   //ERRO
              Q2.ExecSQL;

              If Q2.RowsAffected > 0 Then Begin
                Result := O.Inserir(CodAplicativo, CodMetodo, CodTipoMensagem, TxtMensagem, Q1.FieldByName('nom_arquivo_local').AsString, TxtLegenda);
                If Result < 0 Then Begin
                  Exit;
                End;
              End;

              Commit;

              Q1.Next;
            End;
          End;
        Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(1740, Self.ClassName, NomMetodo, [E.Message]);
            Result := -1740;
            Exit;
          End;
        End;
      Finally
        Q1.Free;
        Q2.Free;
        O.Free;
      End;
    End;

    //-------------------- Montar Lista de Arquivos ----------------------------

    Result := MontarListaArquivos(CodRotinaFTPRetorno,
                                  Q.FieldByName('txt_endereco_maquina_remota').AsString,
                                  Q.FieldByName('txt_porta_maquina_remota').AsString,
                                  Q.FieldByName('txt_usuario_maquina_remota').AsString,
                                  Q.FieldByName('txt_senha_maquina_remota').AsString,
                                  Q.FieldByName('txt_mascara_arquivo_remoto').AsString,
                                  Q.FieldByName('txt_caminho_remoto').AsString,
                                  ReadTimeOut,
                                  DtaCorte,
                                  ListaArquivos);
    If Result < 0 Then Begin
      Exit;
    End;

    If ListaArquivos.Text = '' Then Begin
//      Mensagens.Adicionar(1742, Self.ClassName, NomMetodo, []); - Daniel 19/08/2005
      Result := -1742;
      Exit;
    End;

    //------------- Verififica se existe arquivo na tab_arquivo_ftp_retorno ----


    Q1 := THerdomQuery.Create(Conexao, nil);
    Q2 := THerdomQuery.Create(Conexao, nil);
    Try
      For X := 0 To ListaArquivos.Count - 1 Do Begin
        Try
          DtaCriacao       := StrToDateTime(Copy(ListaArquivos.Strings[X], 1, 19));
          QtdBytes         := StrToInt(Trim(Copy(ListaArquivos.Strings[X], 21, 10)));
          NomArquivoRemoto := Copy(ListaArquivos.Strings[X], 32, Length(ListaArquivos.Strings[X]));

          Q1.Close;
          Q1.SQL.Clear;
          {$IFDEF MSSQL}
          Q1.SQL.Add(' select cod_arquivo_ftp_retorno,                           '+
                     '        cod_situacao_arquivo_ftp                           '+
                     '   from tab_arquivo_ftp_retorno                            '+
                     '  where nom_arquivo_remoto     = :nom_arquivo_remoto       '+
                     '    and dta_criacao_arquivo    = :dta_criacao_arquivo      '+
                     '    and cod_rotina_ftp_retorno = :cod_rotina_ftp_retorno   ');
          {$ENDIF}
          Q1.ParamByName('dta_criacao_arquivo').AsDateTime   := DtaCriacao;
          Q1.ParamByName('nom_arquivo_remoto').AsString      := NomArquivoRemoto;
          Q1.ParamByName('cod_rotina_ftp_retorno').AsInteger := CodRotinaFTPRetorno;
          Q1.Open;

          If Q1.IsEmpty Then Begin

            //------------------- Busca o código do arquivo --------------------------

            Result := ObterCodArquivoFTPRetorno(NewCodArquivoFTPRetorno);
            If Result < 0 Then Begin
              Exit;
            End;

            If NewCodArquivoFTPRetorno <= 0 then Begin
              Mensagens.Adicionar(1735, Self.ClassName, NomMetodo, []);
              Result := -1735;
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

            Q2.Close;
            Q2.SQL.Clear;
            {$IFDEF MSSQL}
            Q2.SQL.Add(' insert into tab_arquivo_ftp_retorno ('+
                       '    cod_arquivo_ftp_retorno,          '+
                        '   cod_rotina_ftp_retorno,           '+
                        '   nom_arquivo_local,                '+
                        '   nom_arquivo_remoto,               '+
                        '   dta_criacao_arquivo,              '+
                        '   qtd_bytes_arquivo,                '+
                        '   cod_tipo_mensagem,                '+
                        '   txt_mensagem,                     '+
                        '   cod_situacao_arquivo_ftp,         '+
                        '   dta_ultima_transferencia,         '+
                        '   qtd_duracao_transferencia,        '+
                        '   qtd_vezes_transferencia,          '+
                        '   cod_registro_log                  '+
                        ' ) values (                          '+
                        '   :cod_arquivo_ftp_retorno,         '+
                        '   :cod_rotina_ftp_retorno,          '+
                        '   :nom_arquivo_local,               '+
                        '   :nom_arquivo_remoto,              '+
                        '   :dta_criacao_arquivo,             '+
                        '   :qtd_bytes_arquivo,               '+
                        '   null,                             '+
                        '   null,                             '+
                        '   :cod_situacao_arquivo_ftp,        '+
                        '   null,                             '+
                        '   null,                             '+
                        '   :qtd_vezes_transferencia,         '+
                        '   :cod_registro_log)                ');
            {$ENDIF}
            Q2.ParamByName('cod_arquivo_ftp_retorno').AsInteger   := NewCodArquivoFTPRetorno;
            Q2.ParamByName('cod_rotina_ftp_retorno').AsInteger    := CodRotinaFTPRetorno;
            Q2.ParamByName('nom_arquivo_local').AsString          := Q.FieldByName('txt_prefixo_arquivo_local').AsString + NomArquivoRemoto;
            Q2.ParamByName('nom_arquivo_remoto').AsString         := NomArquivoRemoto;
            Q2.ParamByName('dta_criacao_arquivo').AsDateTime      := DtaCriacao;
            Q2.ParamByName('qtd_bytes_arquivo').AsInteger         := QtdBytes;
            Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger  := 1;
            Q2.ParamByName('qtd_vezes_transferencia').AsInteger   := 0;
            Q2.ParamByName('cod_registro_log').AsInteger          := CodRegistroLog;
            Q2.ExecSQL;

            // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
            // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
            Result := GravarLogOperacao('tab_arquivo_ftp_retorno', CodRegistroLog, 1, CodMetodo);
            If Result < 0 Then Begin
              Rollback;
              Exit;
            End;

            ListaArquivos.Strings[X] := PadL(IntToStr(NewCodArquivoFTPRetorno), ' ', 10) + ' ' + ListaArquivos.Strings[X];

            Commit;
          End Else Begin
            If Q1.FieldByName('cod_situacao_arquivo_ftp').AsInteger <> 1 Then Begin
              ListaArquivos.Strings[X] := '0000000000'+  ' '  + ListaArquivos.Strings[X];
            End;

            If Q1.FieldByName('cod_situacao_arquivo_ftp').AsInteger = 1 Then Begin
              ListaArquivos.Strings[X] := PadL(Q1.FieldByName('cod_arquivo_ftp_retorno').AsString, ' ', 10) + ' ' + ListaArquivos.Strings[X];
            End
          End;
        Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(1743, Self.ClassName, NomMetodo, [E.Message]);
            Result := -1743;
            Exit;
          End;
        End;
      End;
    Finally
      Q1.Free;
      Q2.Free;
    End;

    //---------------------- Atribuição Result ---------------------------------

    Result         := 0;

    //---------------------- Executa o FTP -------------------------------------

    Q1 := THerdomQuery.Create(Conexao, nil);
    Q2 := THerdomQuery.Create(Conexao, nil);
    Try
      For X := 0 To ListaArquivos.Count - 1 Do Begin
        If Copy(ListaArquivos.Strings[X], 1, 10) <> '0000000000' Then Begin

          Try
            CodArquivoFTPRetorno   := StrToInt(Trim(Copy(ListaArquivos.Strings[X], 1, 10)));

            Q1.Close;
            Q1.SQL.Clear;
            {$IFDEF MSSQL}
            Q1.SQL.Add('select nom_arquivo_local,                                  '+
                       '       nom_arquivo_remoto,                                 '+
                       '       qtd_vezes_transferencia,                            '+
                       '       dta_criacao_arquivo,                                '+
                       '       qtd_vezes_transferencia                             '+
                       '  from tab_arquivo_ftp_retorno                             '+
                       ' where cod_arquivo_ftp_retorno = :cod_arquivo_ftp_retorno  ');
            {$ENDIF}
            Q1.ParamByName('cod_arquivo_ftp_retorno').AsInteger := CodArquivoFTPRetorno;
            Q1.Open;

            NumTentativa := Q1.FieldByName('qtd_vezes_transferencia').AsInteger + 1;

            ResultadoGet := ExecutarFTP(CodRotinaFTPRetorno,
                                        Q.FieldByName('txt_endereco_maquina_remota').AsString,
                                        Q.FieldByName('txt_porta_maquina_remota').AsString,
                                        Q.FieldByName('txt_usuario_maquina_remota').AsString,
                                        Q.FieldByName('txt_senha_maquina_remota').AsString,
                                        Q.FieldByName('txt_caminho_remoto').AsString,
                                        Q1.FieldByName('nom_arquivo_remoto').AsString,
                                        Q.FieldByName('txt_caminho_local').AsString,
                                        Q1.FieldByName('nom_arquivo_local').AsString,
                                        ReadTimeOut,
                                        QtdDuracao,
                                        CodTipoMensagemGet,
                                        TxtMensagemGet);

            ResultadoMove := 0;

            If ResultadoGet = 0 Then Begin
              If Q.FieldByName('ind_mover_arquivo_remoto').AsString = 'S' Then Begin
                ResultadoMove := MoverArquivoRemoto(CodRotinaFTPRetorno,
                                                    Q.FieldByName('txt_endereco_maquina_remota').AsString,
                                                    Q.FieldByName('txt_porta_maquina_remota').AsString,
                                                    Q.FieldByName('txt_usuario_maquina_remota').AsString,
                                                    Q.FieldByName('txt_senha_maquina_remota').AsString,
                                                    Q.FieldByName('txt_caminho_remoto').AsString,
                                                    Q.FieldByName('txt_caminho_arquivo_movido').AsString,
                                                    Q1.FieldByName('nom_arquivo_remoto').AsString,
                                                    ReadTimeOut,
                                                    CodTipoMensagemMove,
                                                    TxtMensagemMove);
              End;
            End;

            //-------------------- Atualiza tab_arquivo_ftp_retorno ------------

            Begintran;

            DtaUltimaTransferencia := Now;
            If QtdDuracao = 0 Then Begin
              QtdDuracao := 1;
            End;

            Q2.Close;
            Q2.SQL.Clear;
            {$IFDEF MSSQL}
            Q2.SQL.Add(' update tab_arquivo_ftp_retorno                                  '+
                       '    set cod_tipo_mensagem         = :cod_tipo_mensagem,          '+
                       '        txt_mensagem              = :txt_mensagem,               '+
                       '        qtd_vezes_transferencia   = qtd_vezes_transferencia + 1, '+
                       '        dta_ultima_transferencia  = :dta_ultima_transferencia,   '+
                       '        qtd_duracao_transferencia = :qtd_duracao_tranferencia,   '+
                       '        cod_situacao_arquivo_ftp  = :cod_situacao_arquivo_ftp    '+
                       '  where cod_arquivo_ftp_retorno   = :cod_arquivo_ftp_retorno     ');
            {$ENDIF}
            Q2.ParamByName('cod_arquivo_ftp_retorno').AsInteger    := CodArquivoFTPRetorno;
            Q2.ParamByName('dta_ultima_transferencia').AsDateTime  := DtaUltimaTransferencia;
            Q2.ParamByName('qtd_duracao_tranferencia').AsInteger   := QtdDuracao;
            Q2.ParamByName('cod_tipo_mensagem').AsInteger          := CodTipoMensagemGet;
            Q2.ParamByName('txt_mensagem').AsString                := TxtMensagemGet;
            If ResultadoGet = 0 Then Begin
              Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 3;   //SUCESSO
              If ResultadoMove < 0 Then Begin
                Q2.ParamByName('cod_tipo_mensagem').AsInteger      := CodTipoMensagemMove;
                Q2.ParamByName('txt_mensagem').AsString            := TxtMensagemMove;
              End;
            End Else Begin
              If (NumTentativa = 0) or (MaxTentativa = 0) Then Begin
                Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger   := 1; //PENDENTE
              End Else Begin
                If NumTentativa >= MaxTentativa Then Begin
                  Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 2; //ERRO
                End Else Begin
                  Q2.ParamByName('cod_situacao_arquivo_ftp').AsInteger := 1; //PENDENTE
                End;
              End;
            End;
            Q2.ExecSQL;

            //----- Grava ocorrencia caso necessario ---------------------------
            If ResultadoGet < 0 Then Begin
              If (NumTentativa > 0) and (MaxTentativa > 0) Then Begin
                If NumTentativa >= MaxTentativa Then Begin
                  O := TIntOcorrenciasSistema.Create;
                  Try
                    TxtMensagem      := Mensagens.GerarMensagem(1822, []);
                    CodTipoMensagem  := Mensagens.BuscarTipoMensagem(1822);

                    O.Inicializar(Conexao, Mensagens);
                    If O.Inserir(CodAplicativo, CodMetodo, CodTipoMensagem, TxtMensagem, Q1.FieldByName('nom_arquivo_remoto').AsString, TxtLegenda) < 0 Then Begin
                      Exit;
                    End;
                  Finally
                    O.Free;
                  End;
                End;
              End;
            End;

            //---------------------- Atualiza tab_rotina_ftp_retorno -----------

            If ResultadoGet = 0 Then Begin
              Q2.Close;
              Q2.SQL.Clear;
              {$IFDEF MSSQL}
              Q2.SQL.Add('update tab_rotina_ftp_retorno                                    '+
                         '   set dta_ultima_transferencia   = :dta_ultima_transferencia,   '+
                         '       dta_criacao_ultimo_arquivo = :dta_criacao_ultimo_arquivo  '+
                         ' where cod_rotina_ftp_retorno     = :cod_rotina_ftp_retorno      ');
              {$ENDIF}
              Q2.ParamByName('cod_rotina_ftp_retorno').AsInteger      := CodRotinaFTPRetorno;
              Q2.ParamByName('dta_ultima_transferencia').AsDateTime   := DtaUltimaTransferencia;
              Q2.ParamByName('dta_criacao_ultimo_arquivo').AsDateTime := Q1.FieldByName('dta_criacao_arquivo').AsDateTime;
              Q2.ExecSQL;
            End;

            Commit;
          Except
            On E: Exception do Begin
              Rollback;
              Mensagens.Adicionar(1758, Self.ClassName, NomMetodo, [E.Message]);
              Result := -1758;
            End;
          End;
        End;
      End;
    Finally
      Q1.Free;
      Q2.Free;
    End;
  Finally
    Q.Free;
    ListaArquivos.Free;
  End;
end;

function TIntArquivosFTPRetorno.ObterCodArquivoFTPRetorno(var CodArquivoFTPRetorno: Integer): Integer;
const
  NomMetodo: String = 'ObterCodArquivoFTPRetorno';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      BeginTran;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_arquivo_ftp_retorno), 0) + 1 as CodSeqArquivoFtpRetorno from tab_seq_arquivo_ftp_retorno');
      {$ENDIF}
      Q.Open;

      CodArquivoFTPRetorno := Q.FieldByName('CodSeqArquivoFtpRetorno').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_arquivo_ftp_retorno set cod_seq_arquivo_ftp_Retorno = cod_seq_arquivo_ftp_retorno + 1');
      {$ENDIF}
      Q.ExecSQL;

      Commit;

      Result := CodArquivoFTPRetorno;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1735, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1735;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntArquivosFTPRetorno.AlterarSituacaoParaPendente(CodArquivoFTPRetorno: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog: Integer;
Const
  CodMetodo : Integer = 576;
  NomMetodo : String = 'AlterarSituacaoParaPendente';
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
      Q.SQL.Add(' select cod_arquivo_ftp_retorno,                           '+
                '        cod_registro_log                                   '+
                '   from tab_arquivo_ftp_retorno                            '+
                '  where cod_arquivo_ftp_retorno = :cod_arquivo_ftp_retorno ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_retorno').AsInteger := CodArquivoFTPRetorno;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1732, Self.ClassName, NomMetodo, [IntToStr(CodArquivoFTPRetorno)]);
        Result := -1732;
        Exit;
      End;

      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_arquivo_ftp_retorno', CodRegistroLog, 2, CodMetodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' update tab_arquivo_ftp_retorno                             '+
                '    set cod_situacao_arquivo_ftp = 1,                       '+
                '        qtd_vezes_transferencia  = 0                        '+
                '  where cod_arquivo_ftp_retorno  = :cod_arquivo_ftp_retorno ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_ftp_retorno').AsInteger :=  CodArquivoFTPRetorno;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_arquivo_ftp_retorno', CodRegistroLog, 3, CodMetodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1892, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1892;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntArquivosFTPRetorno.MontarListaArquivos(CodRotinaFTPRetorno: Integer;
                                                    TxtMaquinaRemota,
                                                    TxtPortaRemota,
                                                    TxtUsuarioMaquina,
                                                    TxtSenhaMaquina,
                                                    TxtMascaraArquivo,
                                                    TxtCaminhoRemoto: String;
                                                    ReadTimeOut: Integer;
                                                    DtaCorte: TDateTime;
                                                    var ListaArquivos: TStringList): Integer;
const
  NomMetodo: String = 'MontarListaArquivos';
var
  ConexaoFTP: TIdFTP;
  X: Integer;
  Aux: String;
  DataInicioDownload: TDateTime;
  DataArquivo: String;
begin
  ListaArquivos.Clear;

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
        Mensagens.Adicionar(1715, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result := -1715;
        Exit;
      end;
    end;

    //----------------------- Acessa a pasta remota ----------------------------
    try
      ConexaoFTP.ChangeDir(TxtCaminhoRemoto);
    except
      on E:Exception do
      begin
        Mensagens.Adicionar(1716, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        Result := -1716;
        Exit;
      end;
    end;

    //----------------------- Monta Lista --------------------------------------
    DataInicioDownload := StrToDateTime(ValorParametro(112));
    try
      ConexaoFTP.List(Nil, TxtMascaraArquivo, True);

      for X := 0 to ConexaoFTP.DirectoryListing.Count - 1 do
      begin
        Aux := PadR(FormatDateTime('DD/MM/YYY HH:MM:SS', ConexaoFTP.DirectoryListing[X].ModifiedDate), ' ', 19) + ' ' +
               PadR(IntToStr(ConexaoFTP.DirectoryListing[X].Size), ' ', 10) + ' ' +
               ConexaoFTP.DirectoryListing[X].FileName;
        DataArquivo := FormatDateTime('DD/MM/YYYY HH:MM:SS', ConexaoFTP.DirectoryListing[X].ModifiedDate);
        if (Trunc(StrToDateTime(DataArquivo)) > Trunc(DataInicioDownload)) then
        begin
          if DtaCorte = 0 then
          begin
            ListaArquivos.Add(Aux);
          end
          else if ConexaoFTP.DirectoryListing[X].ModifiedDate >= DtaCorte then
          begin
            ListaArquivos.Add(Aux);
          end;
        end
        else
        begin
          ConexaoFTP.Rename(ConexaoFTP.DirectoryListing[X].FileName, 'HRD_' + ConexaoFTP.DirectoryListing[X].FileName);
        end
      end;
      ListaArquivos.Sort;
    except
      on E: Exception do
      begin
        Mensagens.Adicionar(1741, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result := -1741;
        Exit;
      end;
    end;

    Result := 0;
  finally
    ConexaoFTP.Disconnect;
    ConexaoFTP.Free;
  end;
end;

function TIntArquivosFTPRetorno.ExecutarFTP(CodRotinaFTPRetorno: Integer;
                                            TxtMaquinaRemota,
                                            TxtPortaRemota,
                                            TxtUsuarioMaquina,
                                            TxtSenhaMaquina,
                                            TxtCaminhoRemoto,
                                            TxtArquivoRemoto,
                                            TxtCaminhoLocal,
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
  ArqRen: String;
begin
  QtdDuracao    := 0;
  DataInicio    := Now;

  ConexaoFTP := TIdFTP.Create(Nil);
  Try
    ConexaoFTP.Host     := TxtMaquinaRemota;
    ConexaoFTP.Port     := StrToInt(TxtPortaRemota);
    ConexaoFTP.Username := TxtUsuarioMaquina;
    ConexaoFTP.Password := TxtSenhaMaquina;
    ConexaoFTP.ReadTimeout := ReadTimeOut;

    Try
      ConexaoFTP.Connect;
    Except
      On E:Exception do
      begin
        Mensagens.Adicionar(1715, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1715;
        TxtMensagem     := Mensagens.GerarMensagem(1715, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1715);
        Exit;
      End;
    End;

    //----------------------- Acessa a pasta remota ----------------------------
    Try
      if (not ConexaoFTP.Connected) then
      begin
        ConexaoFTP.Connect;
      end;

      ConexaoFTP.ChangeDir(TxtCaminhoRemoto);
    Except
      On E:Exception do
      begin
        Mensagens.Adicionar(1716, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        Result          := -1716;
        TxtMensagem     := Mensagens.GerarMensagem(1716, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1716);
        Exit;
      End;
    End;

    //----------------------- Buscar Arquivo -----------------------------------
    Try
      if (not ConexaoFTP.Connected) then
      begin
        ConexaoFTP.Connect;
      end;

      ArqRen := 'TMP_' + TxtArquivoLocal;
      ConexaoFTP.Get(TxtArquivoRemoto, TxtCaminhoLocal + '\' + ArqRen);

      // Renomeia arquivos na pasta FTP para que no proximo processamento não seja buscado o arquivo!
      ConexaoFTP.Rename(TxtArquivoRemoto, 'HRD_' + TxtArquivoRemoto);

      RenameFile(TxtCaminhoLocal + '\' + ArqRen, TxtCaminhoLocal + '\' + TxtArquivoLocal);
    Except
      On E: Exception Do Begin
        Mensagens.Adicionar(1746, Self.ClassName, NomMetodo, [TxtArquivoRemoto, E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1746;
        TxtMensagem     := Mensagens.GerarMensagem(1746, [TxtArquivoRemoto, E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1746);
        Exit;
      End;
    End;

    QtdDuracao := Round((Now - DataInicio) * 24 * 60 * 60);

    Mensagens.Adicionar(1748, Self.ClassName, NomMetodo, [TxtArquivoRemoto, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);

    TxtMensagem     := Mensagens.GerarMensagem(1748, [TxtArquivoRemoto, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
    CodTipoMensagem := Mensagens.BuscarTipoMensagem(1748);

    Result          := 0
  Finally
    ConexaoFTP.Disconnect;
    ConexaoFTP.Free;
  End;
end;

function TIntArquivosFTPRetorno.MoverArquivoRemoto(CodRotinaFTPRetorno: Integer;
                                                   TxtMaquinaRemota,
                                                   TxtPortaRemota,
                                                   TxtUsuarioMaquina,
                                                   TxtSenhaMaquina,
                                                   TxtCaminhoRemoto,
                                                   TxtCaminhoMovido,
                                                   TxtArquivo: String;
                                                   ReadTimeOut: Integer;
                                                   var CodTipoMensagem: Integer;
                                                   var TxtMensagem: String): Integer;
const
  NomMetodo: String = 'MoverArquivoRemoto';
var
  ConexaoFTP: TIdFTP;
  ArqOri: String;
  ArqRen: String;
begin
  Result := -1;

  ConexaoFTP := TIdFTP.Create(Nil);
  Try
    ConexaoFTP.Host     := TxtMaquinaRemota;
    ConexaoFTP.Port     := StrToInt(TxtPortaRemota);
    ConexaoFTP.Username := TxtUsuarioMaquina;
    ConexaoFTP.Password := TxtSenhaMaquina;
    ConexaoFTP.ReadTimeout := ReadTimeOut;

    Try
      ConexaoFTP.Connect;
    Except
      On E:Exception do begin
        Mensagens.Adicionar(1715, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1715;
        TxtMensagem     := Mensagens.GerarMensagem(1715, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1715);
        Exit;
      End;
    End;

    //----------------------- Acessa a pasta remota ----------------------------
    Try
      ConexaoFTP.ChangeDir(TxtCaminhoRemoto);
    Except
      On E:Exception do begin
        Mensagens.Adicionar(1716, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        Result          := -1716;
        TxtMensagem     := Mensagens.GerarMensagem(1716, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota, TxtCaminhoRemoto]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1716);
        Exit;
      End;
    End;

    //----------------------- Move Arquivo -------------------------------------
    Try
      ArqOri:= TxtArquivo;
      ArqRen:= ObterNomeArquivo(TxtArquivo) + '.del';

      ConexaoFTP.Rename(TxtArquivo, ArqRen);
      ConexaoFTP.Rename(ArqRen, TxtCaminhoMovido + '/' + ArqOri);
    Except
      On E: Exception Do Begin
        Mensagens.Adicionar(1759, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        Result          := -1759;
        TxtMensagem     := Mensagens.GerarMensagem(1759, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
        CodTipoMensagem := Mensagens.BuscarTipoMensagem(1759);
      End;
    End;

    If Result = -1759 Then begin
      Try
        ConexaoFTP.Rename(ArqRen, ArqOri);
        Exit;
      Except
        On E: Exception Do Begin
          Mensagens.Adicionar(1759, Self.ClassName, NomMetodo, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
          Result          := -1759;
          TxtMensagem     := Mensagens.GerarMensagem(1759, [E.Message, Conexao.Banco, IntToStr(CodRotinaFTPRetorno), TxtMaquinaRemota, TxtPortaRemota]);
          CodTipoMensagem := Mensagens.BuscarTipoMensagem(1759);
          Exit;
        End;
      End;
    End;

    Result := 0;
  Finally
    ConexaoFTP.Disconnect;
    ConexaoFTP.Free;
  End;
end;

function TIntArquivosFTPRetorno.ObterNomeArquivo(NomArquivo: String): String;
var
  X: Integer;
begin
  Result := '';

  For X := 1 To Length(NomArquivo) Do Begin
    If NomArquivo[X] = '.' Then Begin
      Exit;
    End Else Begin
      Result := Result + NomArquivo[X];
    End;
  End;
end;
end.

