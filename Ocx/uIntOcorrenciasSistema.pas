// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 02/08/2004
// *  Documentação       : Ocorrências Sistema - Definição das Classes.doc
// *  Descrição Resumida : Armazena atributos referentes à ocorrência no sistema
// *                       de uma mensagem de advertência ou erro.
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntOcorrenciasSistema;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, StrUtils, db, uConexao, uIntMensagens,
     uIntOcorrenciaSistema, uFerramentas;

const
  INDICADOR_ENVIO_EMAIL_OCORRENCIA: Integer = 94;

type
{ TIntOcorrenciasSistema }
  TIntOcorrenciasSistema = class(TIntClasseBDNavegacaoBasica)
  private
    FIntOcorrenciaSistema : TIntOcorrenciaSistema;
    function ObterCodOcorrenciaSistema(var CodOcorrenciaSistema: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function Pesquisar(DtaOcorrenciaInicio, DtaOcorrenciaFim: TDateTime;
                       IndOcorrenciaTratada: String; CodAplicativo, CodTipoMensagem: Integer): Integer;
    function Buscar(CodOcorrenciaSistema: Integer): Integer;
    function Inserir(CodAplicativo, CodMetodo, CodTipoMensagem: Integer; TxtMensagem, TxtIdentificacao,
                     TxtLegendaIdentificacao: String): Integer;
    function AlterarParaTratada(CodOcorrenciaSistema: Integer): Integer;
    function AlterarParaNaoTratada(CodOcorrenciaSistema: Integer): Integer;
    property IntOcorrenciaSistema : TIntOcorrenciaSistema read FIntOcorrenciaSistema write FIntOcorrenciaSistema;
  end;

implementation

uses uIntEmailsEnvio;

constructor TIntOcorrenciasSistema.Create;
begin
  inherited;
  FIntOcorrenciaSistema := TIntOcorrenciaSistema.Create;
end;

destructor TIntOcorrenciasSistema.Destroy;
begin
  FIntOcorrenciaSistema.Free;
  inherited;
end;

{ TIntOcorrenciasSistema }
function TIntOcorrenciasSistema.Pesquisar(DtaOcorrenciaInicio, DtaOcorrenciaFim: TDateTime;
                                          IndOcorrenciaTratada: String; CodAplicativo,
                                          CodTipoMensagem: Integer): Integer;
Const
  CodMetodo: Integer = 533;
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

  if (DtaOcorrenciaInicio <> 0) and (DtaOcorrenciaFim <> 0)
    and (DtaOcorrenciaInicio > DtaOcorrenciaFim) then
  begin
    Mensagens.Adicionar(1353, Self.ClassName, NomMetodo, []);
    Result := -1353;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select ocr.cod_ocorrencia_sistema    as CodOcorrenciaSistema,   '+
                '        ocr.dta_ocorrencia_sistema    as DtaOcorrenciaSistema,   '+
                '        ocr.ind_ocorrencia_tratada    as IndOcorrenciaTratada,   '+
                '        ocr.cod_aplicativo            as CodAplicativo,          '+
                '        apl.nom_aplicativo            as NomAplicativo,          '+
                '        ocr.cod_tipo_mensagem         as CodTipoMensagem,        '+
                '        msg.des_tipo_mensagem         as DesTipoMensagem,        '+
                '        ocr.txt_mensagem              as TxtMensagem,            '+
                '        ocr.txt_identificacao         as TxtIdentificacao,       '+
                '        ocr.txt_legenda_identificacao as TxtLegendaIdentificacao '+
                '   from tab_ocorrencia_sistema    ocr,                           '+
                '        tab_tipo_mensagem         msg,                           '+
                '        tab_aplicativo            apl                            '+
                '  where ocr.cod_tipo_mensagem        = msg.cod_tipo_mensagem     '+
                '    and ocr.cod_aplicativo           = apl.cod_aplicativo        ');

   If DtaOcorrenciaInicio > 0 Then Begin
     Query.SQL.Add(' and ocr.dta_ocorrencia_sistema >= :dta_ocorrencia_sistema_inicio');
   End;

   If DtaOcorrenciaFim > 0 Then Begin
     Query.SQL.Add(' and ocr.dta_ocorrencia_sistema <= :dta_ocorrencia_sistema_fim');
   End;

   If IndOcorrenciaTratada <> '' Then Begin
     Query.SQL.Add(' and ocr.ind_ocorrencia_tratada = :ind_ocorrencia_tratada');
   End;

   If CodAplicativo > 0 Then Begin
     Query.SQL.Add(' and ocr.cod_aplicativo = :cod_aplicativo');
   End;

   If CodTipoMensagem > 0 Then Begin
     Query.SQL.Add(' and ocr.cod_tipo_mensagem = :cod_tipo_mensagem');
   End;

   Query.SQL.Add(' order by ocr.cod_ocorrencia_sistema desc');

   //---------------- Parâmetros -----------------------------------------------

   If DtaOcorrenciaInicio > 0 Then Begin
     Query.ParamByName('dta_ocorrencia_sistema_inicio').AsDateTime := DtaOcorrenciaInicio;
   End;

   If DtaOcorrenciaFim > 0 Then Begin
     Query.ParamByName('dta_ocorrencia_sistema_fim').AsDateTime := DtaOcorrenciaFim;
   End;

   If IndOcorrenciaTratada <> '' Then Begin
     Query.ParamByName('ind_ocorrencia_tratada').AsString := IndOcorrenciaTratada;
   End;

   If CodAplicativo > 0 Then Begin
     Query.ParamByName('cod_aplicativo').AsInteger := CodAplicativo;
   End;

   If CodTipoMensagem > 0 Then Begin
     Query.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
   End;

{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1723, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1723;
      Exit;
    End;
  End;
end;

function TIntOcorrenciasSistema.Buscar(CodOcorrenciaSistema: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo: Integer = 532;
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
      Q.SQL.Add(' select ocr.cod_ocorrencia_sistema    as CodOcorrenciaSistema,   '+
                '        ocr.dta_ocorrencia_sistema    as DtaOcorrenciaSistema,   '+
                '        ocr.ind_ocorrencia_tratada    as IndOcorrenciaTratada,   '+
                '        ocr.cod_aplicativo            as CodAplicativo,          '+
                '        apl.nom_aplicativo            as NomAplicativo,          '+
                '        ocr.cod_tipo_mensagem         as CodTipoMensagem,        '+
                '        msg.des_tipo_mensagem         as DesTipoMensagem,        '+
                '        ocr.txt_mensagem              as TxtMensagem,            '+
                '        ocr.txt_identificacao         as TxtIdentificacao,       '+
                '        ocr.txt_legenda_identificacao as TxtLegendaIdentificacao '+
                '   from tab_ocorrencia_sistema    ocr,                           '+
                '        tab_tipo_mensagem         msg,                           '+
                '        tab_aplicativo            apl                            '+
                '  where ocr.cod_tipo_mensagem      = msg.cod_tipo_mensagem       '+
                '    and ocr.cod_aplicativo         = apl.cod_aplicativo          '+
                '   and ocr.cod_ocorrencia_sistema  = :cod_ocorrencia_sistema     ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger := CodOcorrenciaSistema;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1724, Self.ClassName, NomMetodo, []);
        Result := -1724;
        Exit;
      End;

      FIntOcorrenciaSistema.CodOcorrenciaSistema    :=  Q.FieldByName('CodOcorrenciaSistema').AsInteger;
      FIntOcorrenciaSistema.DtaOcorrenciaSistema    :=  Q.FieldByName('DtaOcorrenciaSistema').AsDateTime;
      FIntOcorrenciaSistema.IndOcorrenciaTratada    :=  Q.FieldByName('IndOcorrenciaTratada').AsString;
      FIntOcorrenciaSistema.CodAplicativo           :=  Q.FieldByName('CodAplicativo').AsInteger;
      FIntOcorrenciaSistema.NomAplicativo           :=  Q.FieldByName('NomAplicativo').AsString;
      FIntOcorrenciaSistema.CodTipoMensagem         :=  Q.FieldByName('CodTipoMensagem').AsInteger;
      FIntOcorrenciaSistema.DesTipoMensagem         :=  Q.FieldByName('DesTipoMensagem').AsString;
      FIntOcorrenciaSistema.TxtMensagem             :=  Q.FieldByName('TxtMensagem').AsString;
      FIntOcorrenciaSistema.TxtIdentificacao        :=  Q.FieldByName('TxtIdentificacao').AsString;
      FIntOcorrenciaSistema.TxtLegendaIdentificacao :=  Q.FieldByName('TxtLegendaIdentificacao').AsString;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1725, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1725;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntOcorrenciasSistema.Inserir(CodAplicativo, CodMetodo, CodTipoMensagem: Integer;
                                        TxtMensagem, TxtIdentificacao, TxtLegendaIdentificacao: String): Integer;
var
  Q, QAux: THerdomQuery;
  NewCodOcorrenciaSistema: Integer;
  AssuntoEmail, CorpoEmail: String;
  FIntEmailsEnvio: TIntEmailsEnvio;
  NomAplicativo: String;
  DtaOcorrencia: TDateTime;
  DesTipoMensagem: String;
  CodEmail: Integer;
Const
  NomMetodo: String  = 'Inserir';

  procedure ObtemModeloEmail(CodModelo: Integer);
  begin
    QAux.Close;
    QAux.SQL.Clear;
    QAux.SQL.Add('select txt_assunto, txt_corpo_email     ');
    QAux.SQL.Add(' from tab_modelo_email where            ');
    QAux.SQL.Add(' cod_modelo_email = :cod_modelo_email   ');
    QAux.ParamByName('cod_modelo_email').AsInteger := CodModelo;
    QAux.Open;

    CorpoEmail   := QAux.FieldByName('txt_corpo_email').AsString;
    AssuntoEmail := QAux.FieldByName('txt_assunto').AsString;
  end;

begin
  //------------------------ Validações ----------------------------------------
  If CodAplicativo <= 0 Then Begin
    Mensagens.Adicionar(1726, Self.ClassName, NomMetodo, [IntToStr(CodAplicativo)]);
    Result := -1726;
    Exit;
  End;

  If CodMetodo <= 0 Then Begin
    Mensagens.Adicionar(1727, Self.ClassName, NomMetodo, [IntToStr(CodMetodo)]);
    Result := -1727;
    Exit;
  End;

  If CodTipoMensagem <= 0 Then Begin
    Mensagens.Adicionar(1728, Self.ClassName, NomMetodo, [IntToStr(CodTipoMensagem)]);
    Result := -1728;
    Exit;
  End;

  Result := VerificaString(TxtMensagem, 'Texto da Mensagem');
  If Result < 0 Then Begin
    Exit;
  End;

  If TxtIdentificacao <> '' Then Begin
    Result := VerificaString(TxtIdentificacao, 'Texto da Identificação');
    If Result < 0 Then Begin
      Exit;
    End;

    Result := TrataString(TxtIdentificacao, 255, 'Texto da Identificação');
    If Result < 0 Then Begin
      Exit;
    End;
  End;

  If TxtLegendaIdentificacao <> '' Then Begin
    Result := VerificaString(TxtLegendaIdentificacao, 'Texto da Legenda Identificação');
    If Result < 0 Then Begin
      Exit;
    End;

    Result := TrataString(TxtLegendaIdentificacao, 255, 'Texto da Legenda Identificação');
    If Result < 0 Then Begin
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------- Verifica se existe aplicativo ---------------------
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select nom_aplicativo from tab_aplicativo  '+
                '  where cod_aplicativo = :cod_aplicativo    '+
                '    and dta_fim_validade is null            ');
      {$ENDIF}
      Q.ParamByName('cod_aplicativo').AsInteger := CodAplicativo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1719, Self.ClassName, NomMetodo, []);
        Result := -1719;
        Exit;
      End;

      NomAplicativo := Q.FieldByName('nom_aplicativo').AsString;


      //-------------------- Verifica Metodo -----------------------------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_metodo        '+
                '  where cod_metodo = :cod_metodo ');
      {$ENDIF}
      Q.ParamByName('cod_metodo').AsInteger := CodMetodo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1919, Self.ClassName, NomMetodo, []);
        Result := -1919;
        Exit;
      End;

      //-------------------- Busca Mensagem ------------------------------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add(' select des_tipo_mensagem from tab_tipo_mensagem  '+
                '  where cod_tipo_mensagem = :cod_tipo_mensagem    ');
      {$ENDIF}
      Q.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1918, Self.ClassName, NomMetodo, []);
        Result := -1918;
        Exit;
      End Else Begin
        DesTipoMensagem := Q.FieldByName('des_tipo_mensagem').AsString;
      End;


      //------------------- Busca o código do arquivo --------------------------

      Result := ObterCodOcorrenciaSistema(NewCodOcorrenciaSistema);
      If Result < 0 then Begin
        Exit;
      End;

      If NewCodOcorrenciaSistema <= 0 then Begin
        Mensagens.Adicionar(1721, Self.ClassName, NomMetodo, []);
        Result := -1721;
        Exit;
      End;

      BeginTran;

      DtaOcorrencia := Now;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' insert into tab_ocorrencia_sistema ('+
                '   cod_ocorrencia_sistema,           '+
                '   dta_ocorrencia_sistema,           '+
                '   ind_ocorrencia_tratada,           '+
                '   cod_aplicativo,                   '+
                '   cod_metodo,                       '+
                '   cod_tipo_mensagem,                '+
                '   txt_mensagem,                     '+
                '   txt_identificacao,                '+
                '   txt_legenda_identificacao         '+
                ' ) values (                          '+
                '   :cod_ocorrencia_sistema,          '+
                '   :dta_ocorrencia_sistema,          '+
                '   :ind_ocorrencia_tratada,          '+
                '   :cod_aplicativo,                  '+
                '   :cod_metodo,                      '+
                '   :cod_tipo_mensagem,               '+
                '   :txt_mensagem,                    '+
                '   :txt_identificacao,               '+
                '   :txt_legenda_identificacao)       ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger     := NewCodOcorrenciaSistema;
      Q.ParamByName('dta_ocorrencia_sistema').AsDateTime    := DtaOcorrencia;
      Q.ParamByName('ind_ocorrencia_tratada').AsString      := 'N';
      Q.ParamByName('cod_aplicativo').AsInteger             := CodAplicativo;
      Q.ParamByName('cod_metodo').AsInteger                 := CodMetodo;
      Q.ParamByName('cod_tipo_mensagem').AsInteger          := CodTipoMensagem;
      Q.ParamByName('txt_mensagem').AsString                := TxtMensagem;
      AtribuiParametro(Q, TxtIdentificacao,  'txt_identificacao', '');
      AtribuiParametro(Q, TxtLegendaIdentificacao,  'txt_legenda_identificacao', '');
      Q.ExecSQL;

      Commit;

      // Se o paramtro indicador de envio de e-mail for 'S' então envia o email
      If Conexao.ValorParametro(INDICADOR_ENVIO_EMAIL_OCORRENCIA, Mensagens) = 'S' Then Begin
        If CodTipoMensagem in [1,2] Then Begin
          FIntEmailsEnvio := TIntEmailsEnvio.Create;
          Try
            FIntEmailsEnvio.Inicializar(Conexao, Mensagens);
            If TxtIdentificacao = '' Then Begin
              ObtemModeloEmail(3);

              AssuntoEmail := AnsiReplaceStr(AssuntoEmail, '<NomAplicativo>', NomAplicativo);

              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<DtaOcorrenciaSistema>', FormatDateTime('DD/MM/YYYY HH:MM:SS', DtaOcorrencia));
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomAplicativo>', NomAplicativo);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<DesTipoMensagem>', DesTipoMensagem);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtMensagem>', TxtMensagem);
            End Else Begin
              ObtemModeloEmail(4);

              AssuntoEmail := AnsiReplaceStr(AssuntoEmail, '<NomAplicativo>', NomAplicativo);

              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<DtaOcorrenciaSistema>', FormatDateTime('DD/MM/YYYY HH:MM:SS', DtaOcorrencia));
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<NomAplicativo>', NomAplicativo);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtLegendaIdentificacao>', TxtLegendaIdentificacao);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtIdentificacao>', TxtIdentificacao);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<DesTipoMensagem>', DesTipoMensagem);
              CorpoEmail := AnsiReplaceStr(CorpoEmail, '<TxtMensagem>', TxtMensagem);
            End;

            CodEmail := FIntEmailsEnvio.Inserir(2, AssuntoEmail, CorpoEmail);
            If CodEMail < 0 Then Begin
              Result := CodEMail;
              Exit;
            End;

            Result := FIntEmailsEnvio.AlterarSituacaoParaPendente(CodEmail, 'S');
            If Result < 0 Then Begin
              Exit;
            End;
          Finally
            FIntEmailsEnvio.Free;
          End;
        End;
      End;

      Result := NewCodOcorrenciaSistema;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1729, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1729;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    QAux.Free;
  End;
end;

function TIntOcorrenciasSistema.AlterarParaTratada(CodOcorrenciaSistema: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 534;
  NomMetodo : String = 'AlterarParaTratada';
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
      Q.SQL.Add(' select cod_ocorrencia_sistema                           '+
                '   from tab_ocorrencia_sistema                           '+
                '  where cod_ocorrencia_sistema = :cod_ocorrencia_sistema ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger := CodOcorrenciaSistema;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1724, Self.ClassName, NomMetodo, []);
        Result := -1724;
        Exit;
      End;

      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' update tab_ocorrencia_sistema                           '+
                '    set ind_ocorrencia_tratada = ''S''                   '+
                '  where cod_ocorrencia_sistema = :cod_ocorrencia_sistema ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger := CodOcorrenciaSistema;
      Q.ExecSQL;

      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1730, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1730;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntOcorrenciasSistema.AlterarParaNaoTratada(CodOcorrenciaSistema: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 535;
  NomMetodo : String = 'AlterarParaNaoTratada';
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
      Q.SQL.Add(' select cod_ocorrencia_sistema                           '+
                '   from tab_ocorrencia_sistema                           '+
                '  where cod_ocorrencia_sistema = :cod_ocorrencia_sistema ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger := CodOcorrenciaSistema;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1724, Self.ClassName, NomMetodo, []);
        Result := -1724;
        Exit;
      End;

      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' update tab_ocorrencia_sistema                           '+
                '    set ind_ocorrencia_tratada = ''N''                   '+
                '  where cod_ocorrencia_sistema = :cod_ocorrencia_sistema ');
{$ENDIF}
      Q.ParamByName('cod_ocorrencia_sistema').AsInteger := CodOcorrenciaSistema;
      Q.ExecSQL;

      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1730, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1730;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntOcorrenciasSistema.ObterCodOcorrenciaSistema(var CodOcorrenciaSistema: Integer): Integer;
const
  NomMetodo: String = 'ObterCodOcorrenciaSistema';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      BeginTran;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_ocorrencia_sistema), 0) + 1 as CodSeqOcorrenciaSistema from tab_seq_ocorrencia_sistema');
      {$ENDIF}
      Q.Open;

      CodOcorrenciaSistema := Q.FieldByName('CodSeqOcorrenciaSistema').AsInteger;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_ocorrencia_sistema set cod_seq_ocorrencia_sistema = cod_seq_ocorrencia_sistema + 1');
      {$ENDIF}
      Q.ExecSQL;

      Commit;

      Result := CodOcorrenciaSistema;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1721, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1721;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.

