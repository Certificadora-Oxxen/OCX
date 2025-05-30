unit uIntInterfaceSisbov;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, classes, dbtables, sysutils, db, FileCtrl, uFerramentas,
  uIntArquivoSisbov, uLibZipM, DateUtils, uIntArquivosFTPEnvio, Math,
  XSBuiltIns, xmldom, XMLIntf, msxmldom, XMLDoc, WsSISBOV1, InvokeRegistry, Rio, SOAPHTTPClient;

type
  TIdentificacaoDupla = record
    CodTipoIdentificador_1: Integer;
    CodTipoIdentificador_2: Integer;
  end;

  TDadosArquivo = record
    CodArquivoSisbov : Integer;
    Caminho : String;
    CNPJCertificadora : String;
    NomArquivoZIP : String;
    NomArquivoSisbov : String;
    DtaCriacaoArquivo : TDateTime;
    CodTipoArquivoSisbov   : Integer;
    CodUsuario : Integer;
    ArquivoNovo : Boolean;
    PossuiLogErro : Boolean;
    DtaInsercaoSisbov : TDateTime;
    Tamanho : Integer;
    CodRotinaFTPEnvio:         Integer;
    IndEnvioArquivoFTP:        String;
    IndDescompactarArquivoFTP: String;
  end;

  { TIntInterfaceSisbov }
  TIntInterfaceSisbov = class(TIntClasseBDNavegacaoBasica)
  private
    FCodArquivoAnimais : Integer;
    FCodArquivoPropriedades : Integer;
    FCodArquivoMovimentacoes : Integer;
    FCodArquivoMortes : Integer;
    FCodArquivoCertificados : Integer;
    FIntArquivoSisbov : TIntArquivoSisbov;
    FCodArquivoProdutores :Integer;
    FCodArquivoSupervisores : Integer;
    FExtensaoArquivo : String;

    FPossuiLogPRO : Boolean;
    FPossuiLogANI : Boolean;
    FPossuiLogMOR : Boolean;
    FPossuiLogMOV : Boolean;
    FPossuiLogCER : Boolean;
    FPossuiLogIPP : Boolean;
    FPossuiLogSUP : Boolean;

    function ProximoCodArquivoSisbov: Integer;


    function VerificaArquivoSisbov(CodArquivoSisbov: Integer;
      var DadosArquivo: TDadosArquivo): Integer;

    function ObtemDadosTipoArquivoSisbov(var DadosArquivo: TDadosArquivo;
                                         var DesTipoArquivoSisbov,
                                         TxtPrefixoNomeArquivo: String): Integer;

    function GravaArquivoSisbov(DadosArquivo: TDadosArquivo): Integer;

    function AtualizaTamanhoArquivo(var DadosArquivo: TDadosArquivo): Integer;

    function AtualizaLocalizacaoSisbov(CodPropriedadeRural, CodPessoaProdutor: Integer;
      DadosArquivo: TDadosArquivo): Integer;

//    function AtualizaLocalizacaoSisbovLog(CodPropriedadeRural, CodPessoaProdutor: Integer;
//      DadosArquivo: TDadosArquivo): Integer;

    function AtualizaAnimal(CodProdutor, CodAnimal: Integer;
      DadosArquivo: TDadosArquivo): Integer;

    function AtualizaAnimalLog(CodProdutor, CodAnimal: Integer;
      DadosArquivo: TDadosArquivo): Integer;

//    function AtualizaEvento(CodProdutor, CodEvento: Integer;
//      DadosArquivo: TDadosArquivo): Integer;

    function AtualizaAnimalEvento(CodProdutor, CodEvento, CodAnimal: Integer;
      DadosArquivo: TDadosArquivo): Integer;

//    function AtualizaEventoLog(CodProdutor, CodEvento: Integer;
//      DadosArquivo: TDadosArquivo): Integer;

    function AtualizaAnimalEventoLog(CodProdutor, CodEvento, CodAnimal: Integer;
      DadosArquivo: TDadosArquivo): Integer;

    function LimparErros(DadosArquivo: TDadosArquivo): Integer;

    function InserirErro(DadosArquivo: TDadosArquivo;
      TxtMensagemErro: String): Integer;

    function CodLocalizacao(CodPropriedadeRural, CodPessoaProdutor: Integer;
      var CodLocalizacao:String; var CodArquivoSisbov: Integer): Integer;

    function PossuiLog(CodArquivoSisbov: Integer): Integer;

    function BuscaIdentificacaoDuplaSisbov(Query: THerdomQueryNavegacao;
      DadosArquivo: TDadosArquivo; var IdentificacaoDuplaSisbov: String;
      var DtaSolicitacaoCodigo: TDateTime): Integer;

//    function PessoaProdutorDestinoVendaCriador(
//      CodPessoaProdutor: Integer; var CodPessoaProdutorDestino: Integer;
//      var NomPessoaProdutorDestino: String): Integer;

    function ObtemRacaAnimal(CodRacaSisbov: String;
      DtaSolicitacaoCodigo: TDateTime): String;

//    function StrToNum(Texto: string): string;

//    function Replace(Dest, SubStr, Str: string): string;

    function GeraArquivoPRO(var DadosArquivo: TDadosArquivo): Integer;

    function GeraArquivoMOR(var DadosArquivo: TDadosArquivo): Integer;

    function GeraArquivoMOV(var DadosArquivo: TDadosArquivo): Integer;


//  Fun��o para tratar movimenta��es para o sistema antigo Sisbov
{ ** Comentado em 23/01/2008 as 17:15hs por Edivaldo Junior
     O Sistema antigo deixou de ser utilizado a partir de 01/01/2008.
    function GeraArquivoMOVAnt(var DadosArquivo: TDadosArquivo): Integer;
}
    function GeraArquivoIPP(var  DadosArquivo: TDadosArquivo): Integer;

    function GeraArquivoSUP(var  DadosArquivo: TDadosArquivo): Integer;
    // N�o gerar arquivo de certificado, pois o mesmo ser� impresso pelo sistema SISBOV!
    //    function GeraArquivoCER(var  DadosArquivo: TDadosArquivo): Integer;

  public
    constructor Create; override;

    destructor Destroy; override;

    function GerarArquivos(CodArquivoSisbov, CodTipoArquivo: Integer): Integer;

    function PesquisarArquivos(DtaInicio,
                               DtaFim: TDateTime;
                               CodTipoArquivoSisbov: Integer;
                               DtaInicioSisbov,
                               DtaFimSisbov: TDateTime;
                               IndPossuiLogErro: String): Integer;

    function Buscar(CodArquivoSisbov: Integer): Integer;

    function PesquisarLogErro(CodArquivoSisbov: Integer): Integer;

    function AtualizarDataSisbov(CodArquivoSisbov: Integer;
                                 DtaInsercaoSisbov: TDateTime): Integer;


    function GeraArquivoANI(var DadosArquivo: TDadosArquivo): Integer; overload;

    function GeraArquivoANI(var DadosArquivo: TDadosArquivo; Chamador: String): Integer; overload;

    function ObtemCNPJCertificadora(var CNPJCodTipoArquivoSisbov: String): Integer;
    function CadastrarEmail(const NovoEmail: String): String;
    function ConsultarSolicitacaoNumeracao(const NumeroSolicitacao: String): String;
    function CancelarSolicitacaoNumeracao(NumeroSolicitacao: Integer; NumeroSisbov: WideString; CodPropriedade: Integer; CnpjProdutor, CpfProdutor: WideString; CodMotivoCancelamento: Integer): Integer;
    function ConsultarEmail: String;
    procedure RecuperarTabela(CodigoTabela: Integer);

    property CodArquivoAnimais:       Integer read FCodArquivoAnimais       write FCodArquivoAnimais;
    property CodArquivoPropriedades:  Integer read FCodArquivoPropriedades  write FCodArquivoPropriedades;
    property CodArquivoMovimentacoes: Integer read FCodArquivoMovimentacoes write FCodArquivoMovimentacoes;
    property CodArquivoMortes:        Integer read FCodArquivoMortes        write FCodArquivoMortes;
    property CodArquivoCertificados:  Integer read FCodArquivoCertificados  write FCodArquivoCertificados;
    property CodArquivoProdutores:    Integer read FCodArquivoProdutores    write FCodArquivoProdutores;
    property CodArquivoSupervisores:  Integer read FCodArquivoSupervisores  write FCodArquivoSupervisores;

    property IntArquivoSisbov: TIntArquivoSisbov read FIntArquivoSisbov write FIntArquivoSisbov;
  end;

const
  COD_RACA_SISBOV_NOVO  : array[0 .. 11] of String = ('NS', 'RW', 'GY', 'GD', 'HI', 'IB', 'J�', 'UM', 'NM', 'NO', 'SL', 'TI');
  COD_RACA_SISBOV_ANTIGO: array[0 .. 11] of String = ('BZ', 'DW', 'GI', 'GN', 'SH', 'IN', 'JA', 'MU', 'NO', 'NM', 'SA', 'TU');
  ctCodRotinaIPR: Integer = 1;
  ctCodRotinaIAN: Integer = 2;
  ctCodRotinaMOV: Integer = 3;
  ctCodRotinaMAN: Integer = 4;
  ctCodRotinaIPP: Integer = 5;
  ctCodRotinaSUP: Integer = 9;


implementation

uses StrUtils, uIntSoapSisbov;

{ TIntInterfaceSisbov }
constructor TIntInterfaceSisbov.Create;
begin
  inherited;
  FIntArquivoSisbov := TIntArquivoSisbov.Create;
end;

destructor TIntInterfaceSisbov.Destroy;
begin
  FIntArquivoSisbov.Free;
  inherited;
end;

function TIntInterfaceSisbov.ProximoCodArquivoSisbov: Integer;
const
  NomeMetodo: String = 'ProximoCodArquivoSisbov';
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try

    BeginTran('OBTER_PROXIMO_CODIGO_SISBOV');
    try
      Q.SQL.Clear;
//{$IFDEF MSSQL}
//      Q.SQL.Add('update tab_arquivo_sisbov ' +
//                '   set cod_arquivo_sisbov = cod_arquivo_sisbov where cod_arquivo_sisbov is null');
//{$ENDIF}
//      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_arquivo_sisbov), 0) + 1 as cod_arquivo_sisbov from tab_arquivo_sisbov where cod_arquivo_sisbov < 999999999');
{$ENDIF}
      Q.Open;

      Result := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
      Q.Close;

      // Confirma Transa��o
      Commit('OBTER_PROXIMO_CODIGO_SISBOV');
    except
      On E: Exception do begin
//        Rollback('OBTER_PROXIMO_CODIGO');
        Rollback;
        Mensagens.Adicionar(1080, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1080;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.ObtemCNPJCertificadora(
  var CNPJCodTipoArquivoSisbov: String): Integer;
const
  NomeMetodo: String = 'ObtemCNPJCertificadora';
var
  Q : THerdomQuery;
  X : Integer;
  Pessoa : String;
begin
  Result := -1;

  CNPJCodTipoArquivoSisbov := '';

  try
    Pessoa := ValorParametro(4);
  except
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select num_cnpj_cpf ' +
                '  from tab_pessoa ' +
                ' where cod_pessoa = :cod_pessoa  ' +
                '   and dta_fim_validade is null ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := StrToInt(Pessoa);
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1088, Self.ClassName, NomeMetodo, []);
        Result := -1088;
        Exit;
      end;

      CNPJCodTipoArquivoSisbov := '';
      X := 14 - Length(Q.FieldByName('num_cnpj_cpf').AsString);
      While X > 0 Do begin
        CNPJCodTipoArquivoSisbov := '0' + CNPJCodTipoArquivoSisbov;
        Dec(X);
      end;
      CNPJCodTipoArquivoSisbov := CNPJCodTipoArquivoSisbov + Q.FieldByName('num_cnpj_cpf').AsString;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1089, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1089;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.VerificaArquivoSisbov(CodArquivoSisbov: Integer;
  var DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'VerificaArquivoSisbov';
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_arquivo_sisbov, nom_arquivo_sisbov, dta_criacao_arquivo, ' +
                'cod_tipo_arquivo_sisbov, cod_usuario, dta_insercao_sisbov from tab_arquivo_sisbov ' +
                ' where cod_arquivo_sisbov = :cod_arquivo_sisbov ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSisbov;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1081, Self.ClassName, NomeMetodo, []);
        Result := -1081;
        Exit;
      end;

      DadosArquivo.CodArquivoSisbov := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
      DadosArquivo.NomArquivoSisbov := Q.FieldByName('nom_arquivo_sisbov').AsString;
      DadosArquivo.DtaCriacaoArquivo := Q.FieldByName('dta_criacao_arquivo').AsDateTime;
      DadosArquivo.CodTipoArquivoSisbov := Q.FieldByName('cod_tipo_arquivo_sisbov').AsInteger;
      DadosArquivo.CodUsuario := Q.FieldByName('cod_usuario').AsInteger;
      DadosArquivo.DtaInsercaoSisbov := Q.FieldByName('dta_insercao_sisbov').AsDateTime;
      DadosArquivo.ArquivoNovo := False;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1082, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1082;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.ObtemDadosTipoArquivoSisbov(var DadosArquivo: TDadosArquivo;
  var DesTipoArquivoSisbov, TxtPrefixoNomeArquivo: String): Integer;
const
  NomeMetodo: String = 'ObtemDadosTipoArquivoSisbov';
var
  Q : THerdomQuery;
begin
  DesTipoArquivoSisbov := '';
  TxtPrefixoNomeArquivo := '';

  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select ttas.cod_rotina_ftp_envio ' +
                '     , ttas.ind_envio_arquivo_ftp ' +
                '     , ttas.ind_descompactar_arquivo_ftp ' +
                '     , ttas.des_tipo_arquivo_sisbov ' +
                '     , ttas.txt_prefixo_nome_arquivo ' +
                '  from tab_tipo_arquivo_sisbov ttas ' +
                ' where ttas.dta_fim_validade is null ' +
                '   and cod_tipo_arquivo_sisbov = :cod_tipo_arquivo_sisbov ');
      {$ENDIF}
      Q.ParamByName('cod_tipo_arquivo_sisbov').AsInteger := DadosArquivo.CodTipoArquivoSisbov;
      Q.Open;

      if Q.IsEmpty then begin
        Mensagens.Adicionar(1084, Self.ClassName, NomeMetodo, []);
        Result := -1084;
        Exit;
      end;

      DadosArquivo.IndEnvioArquivoFTP        := Q.FieldByName('ind_envio_arquivo_ftp').AsString;
      DadosArquivo.IndDescompactarArquivoFTP := Q.FieldByName('ind_descompactar_arquivo_ftp').AsString;
      DadosArquivo.CodRotinaFTPEnvio         := Q.FieldByName('cod_rotina_ftp_envio').AsInteger;

      DesTipoArquivoSisbov  := Q.FieldByName('des_tipo_arquivo_sisbov').AsString;
      TxtPrefixoNomeArquivo := Q.FieldByName('txt_prefixo_nome_arquivo').AsString;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1085, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1085;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.GravaArquivoSisbov(DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GravaArquivoSisbov';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_arquivo_sisbov ' +
                '      ( cod_arquivo_sisbov ' +
                '      , nom_arquivo_sisbov ' +
                '      , dta_criacao_arquivo ' +
                '      , qtd_bytes_arquivo ' +
                '      , cod_tipo_arquivo_sisbov ' +
                '      , ind_envio_arquivo_ftp ' +
                '      , ind_descompactar_arquivo_ftp ' +
                '      , ind_possui_log_erro ' +
                '      , cod_usuario ) ' +
                ' values ' +
                '      ( :cod_arquivo_sisbov ' +
                '      , :nom_arquivo_sisbov ' +
                '      , :dta_criacao_arquivo ' +
                '      , :qtd_bytes_arquivo ' +
                '      , :cod_tipo_arquivo_sisbov ' +
                '      , :ind_envio_arquivo_ftp ' +
                '      , :ind_descompactar_arquivo_ftp ' +
                '      , :ind_possui_log_erro ' +
                '      , :cod_usuario )');
      {$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
//      Q.ParamByName('nom_arquivo_sisbov').AsString := ExtractFileName(DadosArquivo.NomArquivoSisbov);
      Q.ParamByName('nom_arquivo_sisbov').AsString := ExtractFileName(DadosArquivo.NomArquivoZIP);
      Q.ParamByName('dta_criacao_arquivo').AsDateTime := DadosArquivo.DtaCriacaoArquivo;
      Q.ParamByName('qtd_bytes_arquivo').AsInteger := 0;
      Q.ParamByName('cod_tipo_arquivo_sisbov').AsInteger := DadosArquivo.CodTipoArquivoSisbov;
      Q.ParamByName('ind_envio_arquivo_ftp').AsString := DadosArquivo.IndEnvioArquivoFTP;
      Q.ParamByName('ind_descompactar_arquivo_ftp').AsString := DadosArquivo.IndDescompactarArquivoFTP;
      Q.ParamByName('ind_possui_log_erro').AsString := 'N';
      Q.ParamByName('cod_usuario').AsInteger := DadosArquivo.CodUsuario;

      Q.ExecSQL;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1086, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1086;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.AtualizaTamanhoArquivo(var DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaTamanhoArquivo';
var
  F : File of Byte;
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_arquivo_sisbov ' +
                '   set qtd_bytes_arquivo = :qtd_bytes_arquivo, ' +
                '       ind_possui_log_erro = :ind_possui_log_erro ' +
                ' where cod_arquivo_sisbov = :cod_arquivo_sisbov ');
{$ENDIF}
      if FileExists(DadosArquivo.NomArquivoZIP) then begin
        AssignFile(F, DadosArquivo.NomArquivoZIP);
        Reset(F);
        try
          DadosArquivo.Tamanho := FileSize(F);
        finally
          CloseFile(F);
        end;
      end else begin
        DadosArquivo.Tamanho := 0;
      end;

      Q.ParamByName('qtd_bytes_arquivo').AsInteger := DadosArquivo.Tamanho;
      if DadosArquivo.PossuiLogErro then begin
        Q.ParamByName('ind_possui_log_erro').AsString := 'S';
      end else begin
        Q.ParamByName('ind_possui_log_erro').AsString := 'N';
      end;
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.ExecSQL;

      // Se o arquivo � novo e ficou com 0 bytes, exclui entrada do mesmo
      if (DadosArquivo.Tamanho = 0) and (DadosArquivo.ArquivoNovo) and (not DadosArquivo.PossuiLogErro) then begin
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('delete tab_arquivo_sisbov ' +
                  ' where cod_arquivo_sisbov = :cod_arquivo_sisbov ');
        {$ENDIF}
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
        Q.ExecSQL;
      end;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1118, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1118;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.AtualizaLocalizacaoSisbov(CodPropriedadeRural, CodPessoaProdutor: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaLocalizacaoSisbov';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_localizacao_sisbov ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = null ' +
                ' where cod_propriedade_rural = :cod_propriedade_rural ' +
                '   and cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_arquivo_sisbov is null ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

      Q.ExecSQL;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1480, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1480;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{

  M�todo Desnecess�rio, a forma como o arquivo � gerado foi alterada.

function TIntInterfaceSisbov.AtualizaLocalizacaoSisbovLog(CodPropriedadeRural, CodPessoaProdutor: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaLocalizacaoSisbovLog';
var
  Q : THerdomQuery;
  X : Integer;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
{      Q.SQL.Add('update tab_localizacao_sisbov ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = :cod_arquivo_sisbov_log ' +
                ' where cod_propriedade_rural = :cod_propriedade_rural ' +
                '   and cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_arquivo_sisbov is null ');
{$ENDIF}
{      Q.ParamByName('cod_arquivo_sisbov_log').AsInteger := DadosArquivo.CodArquivoSisbov;
      if DadosArquivo.ArquivoNovo then begin
        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_arquivo_sisbov').Clear;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

      Q.ExecSQL;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1480, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1480;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;
}

function TIntInterfaceSisbov.AtualizaAnimal(CodProdutor, CodAnimal: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaAnimal';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_animal ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = null ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_animal = :cod_animal ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;

      Q.ExecSQL;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1093, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1093;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.AtualizaAnimalLog(CodProdutor, CodAnimal: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaAnimalLog';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try

    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_animal ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = :cod_arquivo_sisbov_log ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_animal = :cod_animal ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov_log').AsInteger := DadosArquivo.CodArquivoSisbov;
      if DadosArquivo.ArquivoNovo then begin
        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_arquivo_sisbov').Clear;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;

      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;

      Begintran;
      Q.ExecSQL;
      Commit;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1093, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1093;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

//function TIntInterfaceSisbov.AtualizaEvento(CodProdutor, CodEvento: Integer;
//  DadosArquivo: TDadosArquivo): Integer;
//const
//  NomeMetodo: String = 'AtualizaEvento';
//var
//  Q : THerdomQuery;
//  X : Integer;
//begin
//  Q := THerdomQuery.Create(Conexao, nil);
//  try
//
//
//    try
//      Q.SQL.Clear;
//{$IFDEF MSSQL}
//      Q.SQL.Add('update tab_evento ' +
//                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
//                '       cod_arquivo_sisbov_log = null ' +
//                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
//                '   and cod_evento = :cod_evento ');
//{$ENDIF}
//      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
//      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
//      Q.ParamByName('cod_evento').AsInteger := CodEvento;
//
//      Q.ExecSQL;

//      Result := 0;
//    except
//      On E: Exception do begin
//        Rollback;
//        Mensagens.Adicionar(1097, Self.ClassName, NomeMetodo, [E.Message]);
//        Result := -1097;
//        Exit;
//      end;
//    end;
//  finally
//    Q.Free;
//  end;
//end;

function TIntInterfaceSisbov.AtualizaAnimalEvento(CodProdutor, CodEvento, CodAnimal: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaAnimalEvento';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try


    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_animal_evento ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = null ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_evento = :cod_evento ' +
                '   and cod_animal = :cod_animal');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEvento;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;

      BeginTran;
      Q.ExecSQL;
      Commit;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1097, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1097;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

//function TIntInterfaceSisbov.AtualizaEventoLog(CodProdutor, CodEvento: Integer;
//  DadosArquivo: TDadosArquivo): Integer;
//const
//  NomeMetodo: String = 'AtualizaEventoLog';
//var
//  Q : THerdomQuery;
//  X : Integer;
//begin
//  Q := THerdomQuery.Create(Conexao, nil);
//  try
//
//
//    try
//      Q.SQL.Clear;
//{$IFDEF MSSQL}
//      Q.SQL.Add('update tab_evento ' +
//                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
//                '       cod_arquivo_sisbov_log = :cod_arquivo_sisbov_log ' +
//                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
//                '   and cod_evento = :cod_evento ');
//{$ENDIF}
//      Q.ParamByName('cod_arquivo_sisbov_log').AsInteger := DadosArquivo.CodArquivoSisbov;
//      if DadosArquivo.ArquivoNovo then begin
//        if DadosArquivo.CodArquivoSisbov >
//        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
//        Q.ParamByName('cod_arquivo_sisbov').Clear;
//      end else begin
//        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
//      end;
//
//      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
//      Q.ParamByName('cod_evento').AsInteger := CodEvento;
//
//      Q.ExecSQL;
//
//      Result := 0;
//    except
//      On E: Exception do begin
//        Rollback;
//        Mensagens.Adicionar(1097, Self.ClassName, NomeMetodo, [E.Message]);
//        Result := -1097;
//        Exit;
//      end;
//    end;
//  finally
//    Q.Free;
//  end;
//end;

function TIntInterfaceSisbov.AtualizaAnimalEventoLog(CodProdutor, CodEvento, CodAnimal: Integer;
  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'AtualizaAnimalEventoLog';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try


    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_animal_evento ' +
                '   set cod_arquivo_sisbov = :cod_arquivo_sisbov, ' +
                '       cod_arquivo_sisbov_log = :cod_arquivo_sisbov_log ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_evento = :cod_evento ' +
                '   and cod_animal = :cod_animal ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov_log').AsInteger := DadosArquivo.CodArquivoSisbov;
      if DadosArquivo.ArquivoNovo then begin
        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_arquivo_sisbov').Clear;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;

      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_evento').AsInteger := CodEvento;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;

      BeginTran;
      Q.ExecSQL;
      Commit;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1097, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1097;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.GeraArquivoPRO(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoPRO';
  TipoArquivo: Integer = 1;
var
  Q, Q1, Q2 : THerdomQuery;
  DesTipo, Prefixo: String;
  Zip : ZipFile;
  I, J, Qtd1 : Integer;
  cod_idPropriedade, CodProp, CodPess, CodTmp: Integer;
  QtdAreaS: String;
  RelacionaProprietarioProp, TelefoneContato, Aux, Nirf : String;
  XMLDoc: TXMLDocument;
  INodeArquivo, INodePropriedades, INodePropriedade, INodeProdutores, INodeProdutor, INodeTemp : IXMLNode;
  sl : TStringList;
  ZipAberto, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoincluirPropriedadeRural: RetornoIncluirPropriedade;
  RetornoIncluirproprietarioProp: RetornoIncluirProprietario;
  RetornoVProprietarioPropriedade: RetornoVincularProprietarioPropriedade;
  RetornoVProdutorPropriedade: RetornoVincularProdutorPropriedade;
  MsgDB, CPFPessoa, CNPJPessoa, FaxContato, SNirf, SIncra : String;
  QtdDistanciaMunicipio, AreaProriedade, SGLatitude, SMLatitude, SSLatitude, SGLongitude, SMLongitude, SSLongitude : Integer;
begin
//  XMLDoc := nil;
  cod_idPropriedade := 0;
//  RetornoincluirPropriedadeRural  := nil;
//  RetornoIncluirProprietarioProp  := nil;
//  RetornoVProprietarioPropriedade := nil;
//  RetornoVProdutorPropriedade     := nil;
  ZipAberto                       := false;

  Q  := THerdomQuery.Create(Conexao, nil);
  Q1 := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Propriedade rural');

      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('exec spt_obtem_prop_rural_sisbov :cod_arquivo_sisbov');
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
      end;
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (Not DadosArquivo.ArquivoNovo) then begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end else begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then begin
          Exit;
        end;
      end else begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
      end;

      // Limpa mensagens de erro
      Result := LimparErros(DadosArquivo);

      if (not Conectado) and (not DadosArquivo.ArquivoNovo) then begin
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de propriedade rural n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
        if Result < 0 then begin
          Exit;
        end;
      end;

      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.Active := true;

        INodeArquivo := XMLDoc.AddChild('ARQUIVO');
        INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
        INodeTemp.Text := DadosArquivo.CNPJCertificadora;
        INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
        INodeTemp.Text := 'IPR'; //VALOR FIXO

        INodePropriedades := INodeArquivo.AddChild('PROPRIEDADES');
      except
        Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - PROPRIEDADE ']);
        Result := -2278;
        Exit;
      end;

      Qtd1 := 0;
      CodProp := 0;
      CodPess := 0;

      While Not Q.Eof do begin
        RetornoincluirPropriedadeRural  := nil;
        RetornoIncluirProprietarioProp  := nil;
        RetornoVProprietarioPropriedade := nil;
        RetornoVProdutorPropriedade     := nil;

//        cod_idPropriedade := 0;

        // Consiste se propriedade est� efetivada
        if Not (Q.FieldByName('ind_propriedade_efetivada').AsBoolean) then begin
          // Insere log de erro
          Result := InserirErro(DadosArquivo, 'A propriedade n�o est� identificada (' + Q.FieldByName('nom_propriedade_rural').AsString + ').');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona na pr�xima propriedade
          CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
          While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
           Q.Next;
          end;
          Continue;
        end;

        // Consiste se produtor est� efetivado
        if Not (Q.FieldByName('ind_produtor_efetivado').AsBoolean) then begin
          // Insere log de erro
          Result := InserirErro(DadosArquivo, 'A produtor n�o est� identificado (' + Q.FieldByName('nom_pessoa_produtor').AsString + ').');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona no pr�ximo produtor
          CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          While (Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp) and (Not Q.Eof) do begin
            Q.Next;
          end;
          Continue;
        end;

        if not ValidaNirfIncra(Q.FieldByName('num_imovel_receita_federal').AsString, True) then begin
          Result := InserirErro(DadosArquivo, 'O n�mero de inscri��o do im�vel rural na Secretaria da Receita Federal (NIRF) est� incorreto para a propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + '.');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona na pr�xima propriedade
          CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
          While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
           Q.Next;
          end;

          Continue;
        end;

        // Verifica se a data de inicio da certifica��o est� correta.
        if Q.FieldByName('dta_inicio_certificacao').AsDateTime > DateOf(Now) then
        begin
          Result := InserirErro(DadosArquivo, 'A data de inicio da certifica��o da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' deve ser menor ou igual que a data atual.');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona na pr�xima propriedade
          CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
          While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
           Q.Next;
          end;

          Continue;
        end;

        if (CodProp <> Q.FieldByName('cod_propriedade_rural').AsInteger) or
           (CodPess <> Q.FieldByName('cod_pessoa_produtor').AsInteger) then begin

          // Consiste se o proprietario foi informado
          if Q.FieldByName('nom_pessoa_proprietario').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O Proprietario da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
{
          // Consiste se o tipo propriedade est� informado
          if Q.FieldByName('cod_tipo_inscricao_sisbov').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O tipo da Propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ', n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
}
          // Consiste se o nome da propriedade est� informado
          if Q.FieldByName('nom_propriedade_rural').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O nome da Propriedade n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se o acesso fazenda est� informado
          if Q.FieldByName('des_acesso_fazenda').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A informa��o sobre a forma de acesso � fazenda da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se a distancia da sede da fazenda ao municipio foi informado
          if Q.FieldByName('qtd_distancia_municipio').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A informa��o da distancia da sede da fazenda ao Municipio da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
{
          // Consiste se a orientacao latitude foi informada
          if ((uppercase(Q.FieldByName('cod_orientacao_latitude').AsString) <> 'N') and
             (uppercase(Q.FieldByName('cod_orientacao_latitude').AsString) <> 'S')) then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A Orienta��o Latitude n�o foi informado corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se a latitude foi informada
          if Q.FieldByName('num_latitude').AsInteger <= 0 then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A Latitude n�o foi informada corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;

          // Consiste se a orientacao longitude foi informada
          if ((uppercase(Q.FieldByName('cod_orientacao_longitude').AsString) <> 'E') and
             (uppercase(Q.FieldByName('cod_orientacao_longitude').AsString) <> 'W')) then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A Orienta��o Longitude n�o foi informado corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se a longitude foi informada
          if Q.FieldByName('num_longitude').AsInteger <= 0 then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A Longitude n�o foi informada corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
}
          // Consiste se a �rea foi informada
          if Q.FieldByName('qtd_area').AsFloat <= 0 then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'A �rea da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informada corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se a logradouro foi informado
          if Q.FieldByName('nom_logradouro').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O Logradouro da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se a cod municipio IBGE foi informado
          if Q.FieldByName('num_municipio_ibge').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O C�digo Municipio IBGE da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado corretamente.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se o Tipo produtor foi informado
          if Q.FieldByName('des_tipo_produtor').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O Tipo produtor da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se CPF_CNPJ produtor foi informado
          if Q.FieldByName('num_cnpj_cpf_produtor').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O CPF/CNPJ produtor da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;
          // Consiste se indicador produtor foi informado
          if Q.FieldByName('cod_regime_posse_uso_sisbov').AsString = '' then begin
            // Insere log de erro
            Result := InserirErro(DadosArquivo, 'O indicador produtor da propriedade ' + Q.FieldByName('nom_propriedade_rural').AsString + ' n�o foi informado.');
            if Result < 0 then begin
              Exit;
            end;
            // Posiciona na pr�xima propriedade
            CodTmp := Q.FieldByName('cod_propriedade_rural').AsInteger;
            While (Q.FieldByName('cod_propriedade_rural').AsInteger = CodTmp) and (Not Q.Eof) do begin
              Q.Next;
            end;
            Continue;
          end;

          try
            // Transmite para o Sisbov a propriedade.
            If (Conectado) and (Q.FieldByName('ind_transmissao_sisbov').AsString = '') and
               (CodProp <> Q.FieldByName('cod_propriedade_rural').AsInteger) then begin

              if Q.FieldByName('num_telefone').AsString = '' then begin
                TelefoneContato  := '';//'N�o tem';
              end else begin
                TelefoneContato  := Q.FieldByName('num_telefone').AsString;
              end;

              if Q.FieldByName('num_fax').AsString = '' then begin
                FaxContato  := '';//'N�o tem';
              end else begin
                FaxContato  := Q.FieldByName('num_fax').AsString;
              end;

              if length(Q.FieldByName('num_imovel_receita_federal').AsString) = 13 then begin
                SNirf  := '';
                SIncra :=  Q.FieldByName('num_imovel_receita_federal').AsString;
              end else begin
                SNirf  := Q.FieldByName('num_imovel_receita_federal').AsString;
                SIncra := '';
              end;
              if Length(IntToStr(Q.FieldByName('num_latitude').AsInteger)) = 7 then begin
                SGLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),1,3));
                SMLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),4,2));
                SSLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),6,2));
              end else if Length(IntToStr(Q.FieldByName('num_latitude').AsInteger)) = 6 then begin
                SGLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),1,2));
                SMLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),3,2));
                SSLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),5,2));
              end else if Length(IntToStr(Q.FieldByName('num_latitude').AsInteger)) = 5 then begin
                SGLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),1,1));
                SMLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),2,2));
                SSLatitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_latitude').AsInteger),4,2));
              end else begin
                SGLatitude := 0;
                SMLatitude := 0;
                SSLatitude := 0;
              end;

              if Length(IntToStr(Q.FieldByName('num_longitude').AsInteger)) = 7 then begin
                SGLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),1,3));
                SMLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),4,2));
                SSLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),6,2));
              end else if Length(IntToStr(Q.FieldByName('num_longitude').AsInteger)) = 6 then begin
                SGLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),1,2));
                SMLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),3,2));
                SSLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),5,2));
              end else if Length(IntToStr(Q.FieldByName('num_longitude').AsInteger)) = 5 then begin
                SGLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),1,1));
                SMLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),2,2));
                SSLongitude := StrToInt(Copy(IntToStr(Q.FieldByName('num_longitude').AsInteger),4,2));
              end else begin
                SGLongitude := 0;
                SMLongitude := 0;
                SSLongitude := 0;
              end;

              AreaProriedade        := (Q.FieldByName('qtd_area').AsInteger*100);
              QtdDistanciaMunicipio := trunc(Q.FieldByName('qtd_distancia_municipio').AsInteger*100);

              try
                RetornoincluirPropriedadeRural := SoapSisbov.incluirPropriedade(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , SNirf
                                 , SIncra
                                 , Q.FieldByName('cod_tipo_propriedade_rural').AsInteger
                                 , Q.FieldByName('nom_propriedade_rural').AsString
                                 , Q.FieldByName('des_acesso_fazenda').AsString
                                 , QtdDistanciaMunicipio
                                 , Q.FieldByName('cod_orientacao_latitude').AsString
                                 , SGLatitude
                                 , SMLatitude
                                 , SSLatitude
                                 , Q.FieldByName('cod_orientacao_longitude').AsString
                                 , SGLongitude
                                 , SMLongitude
                                 , SSLongitude
                                 , AreaProriedade
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('num_municipio_ibge').AsString
                                 , Q.FieldByName('nom_logradouro_correspondencia').AsString
                                 , Q.FieldByName('nom_bairro_correspondencia').AsString
                                 , Q.FieldByName('num_cep_correspondencia').AsString
                                 , Q.FieldByName('num_ibge_correspondencia').AsString
                                 , TelefoneContato
                                 , FaxContato
                                 , ''
                                 , '');
              except
                on E: Exception do
                begin
                  Result := InserirErro(DadosArquivo, 'Erro ao transmitir a propriedade (' + Q.FieldByName('nom_propriedade_rural').AsString + ').');

                  if Result < 0 then begin
                    Exit;
                  end;
                end;
              end;

              If RetornoincluirPropriedadeRural <> nil then begin
                If (RetornoincluirPropriedadeRural.Status = 0) and (RetornoIncluirProprietarioProp.listaErros[0].codigoErro <> '2.008')
                                                               and (RetornoIncluirProprietarioProp.listaErros[0].codigoErro <> '2.012') then begin
                  BeginTran;

                  // Atualiza na tabela tab_propriedade_rural o indice, indicando que o id de transa��o
                  Q2.SQL.Clear;
                  {$IFDEF MSSQL}
                       Q2.SQL.Add('update tab_propriedade_rural ' +
                                 '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                                 ' where cod_propriedade_rural   = :cod_propriedade_rural ');
                  {$ENDIF}
                  Q2.ParamByName('cod_idtransacao').AsInteger        := RetornoincluirPropriedadeRural.idTransacao;
                  Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                  Q2.ExecSQL;

                  Commit;

                  Result := InserirErro(DadosArquivo, 'Erro ao transmitir a propriedade (' + Q.FieldByName('nom_propriedade_rural').AsString + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoincluirPropriedadeRural));
                  if Result < 0 then begin
                    Exit;
                  end;
                end else begin
                  cod_idPropriedade := RetornoincluirPropriedadeRural.idPropriedade;

                  BeginTran;

                  // Atualiza na tabela tab_propriedade_rural o indice, indicando que a propriedade j� foi
                  // enviada para o minist�rio.
                  Q2.SQL.Clear;
                  {$IFDEF MSSQL}
                       Q2.SQL.Add('update tab_propriedade_rural ' +
                                 '   set ind_transmissao_sisbov = ''S'' ' +
                                 '     , cod_id_propriedade_sisbov = :cod_idpropriedade ' +
                                 '     , cod_id_transacao_sisbov = :cod_idtransacao ' +
                                 ' where cod_propriedade_rural  = :cod_propriedade_rural ');
                  {$ENDIF}
                  Q2.ParamByName('cod_idpropriedade').AsInteger      := cod_idPropriedade;
                  Q2.ParamByName('cod_idtransacao').AsInteger        := RetornoincluirPropriedadeRural.idTransacao;
                  Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                  Q2.ExecSQL;

                  Commit;
                end;
              end else begin
                Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o a propriedade (' + Q.FieldByName('nom_propriedade_rural').AsString + ')');
              end;
            end else begin
              If (Conectado) and (Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) then begin
                cod_idPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
              end;
            end;

            if cod_idPropriedade > 0 then begin
              // Pesquisa o propriet�rio da propriedade.
              Q1.SQL.Clear;
              {$IFDEF MSSQL}
                  Q1.SQL.Add('Select tpr.cod_pessoa_produtor, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''F'' then ''PF'' ' +
                           '    when ''J'' then ''PJ'' ' +
                           '  end  as tipo_proprietario, ' +
                           '  case tpr.dta_efetivacao_cadastro ' +
                           '    when null then 0 ' +
                           '    else 1 ' +
                           '  end as ind_produtor_efetivado, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''J'' then left(tpe.nom_pessoa, 50) ' +
                           '    else '''' ' +
                           '  end as razao_social, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''J'' then tpe.num_cnpj_cpf ' +
                           '    else '''' ' +
                           '  end as cnpj_pessoa, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''F'' then left(tpe.nom_pessoa, 50) ' +
                           '    else '''' ' +
                           '  end as nom_pessoa, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''F'' then tpe.num_cnpj_cpf ' +
                           '    else '''' ' +
                           '  end as cpf_pessoa, ' +
                           '  tpe.ind_sexo, ' +
                           '  tpe.num_identidade, ' +
                           '  tte.cod_endereco_sisbov, ' +
                           '  tpe.nom_logradouro, ' +
                           '  tpe.nom_bairro, ' +
                           '  tpe.num_cep, ' +
                           '  tm.nom_municipio, ' +
                           '  tm.num_municipio_ibge, ' +
                           '  te.sgl_estado, ' +
                           '  (select txt_contato from tab_pessoa_contato tpc where tpe.cod_pessoa = tpc.cod_pessoa and tpc.cod_tipo_contato = 1 and ind_principal = ''S'') as telefone_contato, ' +
                           '  (select txt_contato from tab_pessoa_contato tpc where tpe.cod_pessoa = tpc.cod_pessoa and tpc.cod_tipo_contato = 5 and ind_principal = ''S'') as email_contato, ' +
                           '  tpe.num_cnpj_cpf, ' +
                           '  tpr.ind_transmissao_sisbov ' +
                           'From tab_pessoa tpe ' +
                           '     ,tab_produtor tpr ' +
                           '     ,tab_municipio tm ' +
                           '     ,tab_estado te ' +
                           '     ,tab_tipo_endereco tte ' +
                           'Where tpe.cod_pessoa    = :cod_pessoa ' +
                           '  and tpe.cod_pessoa    = tpr.cod_pessoa_produtor ' +
                           '  and tpe.cod_municipio *= tm.cod_municipio ' +
                           '  and tpe.cod_estado    *= te.cod_estado ' +
                           '  and tpe.cod_tipo_endereco = tte.cod_tipo_endereco ' +
                           '  and tpr.ind_efetivado_uma_vez = ''S'' ' +
                           '  and tpr.dta_fim_validade is null ');
              {$ENDIF}

              Q1.ParamByName('cod_pessoa').AsInteger    := Q.FieldByName('cod_pessoa_proprietario').AsInteger;
              Q1.Open;

              // Transmite para o Sisbov o propriet�rio da propriedade.
              if (Not Q1.Eof) and (Q.FieldByName('ind_trans_sisbov_proprietario').AsString = '') then begin
                if Q1.FieldByName('telefone_contato').AsString = '' then begin
                  TelefoneContato := '';//'N�o tem';
                end else begin
                  TelefoneContato := Q1.FieldByName('telefone_contato').AsString;
                end;

                try
                  RetornoIncluirProprietarioProp := SoapSisbov.incluirProprietario(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q1.FieldByName('razao_social').AsString
                                 , Q1.FieldByName('cnpj_pessoa').AsString
                                 , Q1.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q1.FieldByName('email_contato').AsString
                                 , Q1.FieldByName('cpf_pessoa').AsString
                                 , Q1.FieldByName('ind_sexo').AsString
                                 , Q1.FieldByName('nom_logradouro').AsString
                                 , Q1.FieldByName('nom_bairro').AsString
                                 , Q1.FieldByName('num_cep').AsString
                                 , Q1.FieldByName('num_municipio_ibge').AsString);
                except
                  on E: Exception do
                  begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir o propriet�rio da propriedade ( Nome propriet�rio : ' + Q1.FieldByName('nom_pessoa').AsString + ' - Nome propriedade : ' + Q.FieldByName('nom_propriedade_rural').AsString + ').');

                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
                end;

                If RetornoIncluirProprietarioProp <> nil then begin
                  If (RetornoIncluirProprietarioProp.Status = 0) and (RetornoIncluirProprietarioProp.listaErros[0].codigoErro <> '3.019') then begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir propriet�rio (CPF/CNPJ:' + Q1.FieldByName('num_cnpj_cpf').AsString + ') da propriedade. <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoIncluirProprietarioProp));

                    if Result < 0 then begin
                      Exit;
                    end;
                  end else begin
                    BeginTran;

                    Q2.SQL.Clear;
                    {$IFDEF MSSQL}
                      Q2.SQL.Add('update tab_propriedade_rural ' +
                                 '   set ind_trans_sisbov_proprietario = ''S'' ' +
                                 ' where cod_propriedade_rural    = :cod_propriedade_rural ');
                    {$ENDIF}
                    Q2.ParamByName('cod_propriedade_rural').AsInteger    := Q.FieldByName('cod_propriedade_rural').AsInteger;
                    Q2.ExecSQL;

                    Commit;
                  end;
                end else begin
                  Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o propriet�rio (CPF/CNPJ:' + Q1.FieldByName('num_cnpj_cpf').AsString + ').');
                end;
              end;

              RelacionaProprietarioProp := Q.FieldByName('ind_trans_relac_propriet_prop').AsString;

              // Transmite para o Sisbov o vinculo entre o propriet�rio e a propriedade.
              If (Conectado) and (Q.FieldByName('ind_trans_relac_propriet_prop').AsString = '') then begin
                if Trim(Q1.FieldByName('cpf_pessoa').AsString) = '' then begin
                  CPFPessoa  := '';
                  CNPJPessoa := Q1.FieldByName('cnpj_pessoa').AsString;
                end else begin
                  CPFPessoa  := Q1.FieldByName('cpf_pessoa').AsString;
                  CNPJPessoa := '';
                end;

                try
                  RetornoVProprietarioPropriedade := SoapSisbov.vincularProprietarioPropriedade(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , CPFPessoa
                                 , CNPJPessoa
                                 , cod_idPropriedade
                                 , 1);
                except
                  on E: Exception do
                  begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir o relacionamento entre propriet�rio e a propriedade ( Nome propriet�rio : ' + Q1.FieldByName('nom_pessoa').AsString + ' - Nome propriedade : ' + Q.FieldByName('nom_propriedade_rural').AsString + ').');

                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
                end;

                If RetornoVProprietarioPropriedade <> nil then begin
                  If RetornoVProprietarioPropriedade.Status = 0 then begin
                    BeginTran;

                    // Atualiza na tabela tab_localizacao_sisbov o id da transa��o
                    Q2.SQL.Clear;
                    {$IFDEF MSSQL}
                         Q2.SQL.Add('update tab_propriedade_rural ' +
                                   '   set cod_id_trans_relac_prop  = :cod_id_transacao ' +
                                   ' where cod_propriedade_rural    = :cod_propriedade_rural ');
                    {$ENDIF}
                    Q2.ParamByName('cod_id_transacao').AsInteger       := RetornoVProprietarioPropriedade.idTransacao;
                    Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                    Q2.ExecSQL;

                    Commit;

                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir relacionamento entre propriet�rio (CPF/CNPJ:' + Q1.FieldByName('num_cnpj_cpf').AsString + ') e propriedade. <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoVProprietarioPropriedade));
                    if Result < 0 then begin
                      Exit;
                    end;
                  end else begin
                    BeginTran;

                    // Atualiza na tabela tab_localizacao_sisbov o indice, indicando que o vinculo entre propriet�rio e a propriedade j�
                    // enviada para o minist�rio.
                    Q2.SQL.Clear;
                    {$IFDEF MSSQL}
                         Q2.SQL.Add('update tab_propriedade_rural ' +
                                   '   set ind_trans_relac_propriet_prop = ''S'' ' +
                                   '   ,   cod_id_trans_relac_prop  = :cod_id_transacao ' +
                                   ' where cod_propriedade_rural    = :cod_propriedade_rural ');
                    {$ENDIF}
                    Q2.ParamByName('cod_id_transacao').AsInteger       := RetornoVProprietarioPropriedade.idTransacao;
                    Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                    Q2.ExecSQL;

                    Commit;
                    RelacionaProprietarioProp := 'S'
                  end;
                end else begin
                  Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do relacionamento entre propriet�rio (CPF/CNPJ:' + Q1.FieldByName('num_cnpj_cpf').AsString + ') e propriedade: '+ Q.FieldByName('nom_propriedade_rural').AsString + ').');
                end;
              end;

              // Transmite para o Sisbov o vinculo entre o produtor dono dos animais e a propriedade.
              If (Conectado) and (Q.FieldByName('ind_trans_relac_produtor_prop').AsString = '') and (RelacionaProprietarioProp = 'S') then begin
                if Trim(Q.FieldByName('cpf_pessoa').AsString) = '' then begin
                  CPFPessoa  := '';
                  CNPJPessoa := Q.FieldByName('cnpj_pessoa').AsString;
                end else begin
                  CPFPessoa  := Q.FieldByName('cpf_pessoa').AsString;
                  CNPJPessoa := '';
                end;

                try
                  RetornoVProdutorPropriedade := SoapSisbov.vincularProdutorPropriedade(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('cnpj_pessoa').AsString
                                 , cod_idPropriedade
                                 , Q.FieldByName('num_propriedade_rural').AsString
                                 , Q.FieldByName('sgl_estado_IE').AsString
                                 , StrToInt(Trim(Q.FieldByName('cod_regime_posse_uso_sisbov').AsString)));
                except
                  on E: Exception do
                  begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir o relacionamento entre produtor e a propriedade ( CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf_produtor').AsString + ' - Nome propriedade : ' + Q.FieldByName('nom_propriedade_rural').AsString + ').');

                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
                end;

                If RetornoVProdutorPropriedade <> nil then begin
                  If RetornoVProdutorPropriedade.Status = 0 then begin
                    BeginTran;

                    // Atualiza na tabela tab_localizacao_sisbov o id da transa��o.
                    Q2.SQL.Clear;
                    {$IFDEF MSSQL}
                         Q2.SQL.Add('update tab_localizacao_sisbov ' +
                                   '   set cod_id_trans_relac_prod   = :cod_id_transacao ' +
                                   ' where cod_pessoa_produtor       = :cod_pessoa_produtor ' +
                                   '   and cod_propriedade_rural     = :cod_propriedade_rural ' +
                                   '   and cod_localizacao_sisbov    = :cod_localizacao_sisbov ');
                    {$ENDIF}
                    Q2.ParamByName('cod_pessoa_produtor').AsInteger    := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                    Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                    Q2.ParamByName('cod_localizacao_sisbov').AsInteger := Q.FieldByName('cod_localizacao_sisbov').AsInteger;
                    Q2.ParamByName('cod_id_transacao').AsInteger       := RetornoVProdutorPropriedade.idTransacao;

                    Q2.ExecSQL;

                    Commit;

                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir relacionamento entre produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf_produtor').AsString + ') e propriedade:' + Q.FieldByName('nom_propriedade_rural').AsString + ' <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoVProdutorPropriedade));

                    if Result < 0 then begin
                      Exit;
                    end;
                  end else begin
                    BeginTran;

                    // Atualiza na tabela tab_localizacao_sisbov o indice, indicando que o vinculo entre o produtor dono
                    // dos animais e a propriedade j� enviada para o minist�rio.
                    Q2.SQL.Clear;
                    {$IFDEF MSSQL}
                         Q2.SQL.Add('update tab_localizacao_sisbov ' +
                                   '   set ind_trans_relac_produtor_prop = ''S'' ' +
                                   '    ,  cod_id_trans_relac_prod   = :cod_id_transacao ' +
                                   ' where cod_pessoa_produtor       = :cod_pessoa_produtor ' +
                                   '   and cod_propriedade_rural     = :cod_propriedade_rural ' +
                                   '   and cod_localizacao_sisbov    = :cod_localizacao_sisbov ');
                    {$ENDIF}
                    Q2.ParamByName('cod_pessoa_produtor').AsInteger    := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                    Q2.ParamByName('cod_propriedade_rural').AsInteger  := Q.FieldByName('cod_propriedade_rural').AsInteger;
                    Q2.ParamByName('cod_localizacao_sisbov').AsInteger := Q.FieldByName('cod_localizacao_sisbov').AsInteger;
                    Q2.ParamByName('cod_id_transacao').AsInteger       := RetornoVProdutorPropriedade.idTransacao;

                    Q2.ExecSQL;

                    Commit;
                  end;
                end else begin
                  Result := InserirErro(DadosArquivo, 'Erro ao transmitir relacionamento entre produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf_produtor').AsString + ') e propriedade: ' + Q.FieldByName('nom_propriedade_rural').AsString + ')');
                end;
              end;
            end;

            INodePropriedade := INodePropriedades.AddChild('PROPRIEDADE');
                INodeTemp := INodePropriedade.AddChild('COD_TRANSACAO_PROPRIEDADE');
                INodeTemp.Text := IntToStr(cod_idPropriedade);
                INodeTemp := INodePropriedade.AddChild('TIPO_PROPRIEDADE_RURAL');
                INodeTemp.Text := Q.FieldByName('cod_tipo_propriedade_rural').AsString;
                INodeTemp := INodePropriedade.AddChild('INSCRICAO_ESTADUAL');
                INodeTemp.Text := Q.FieldByName('sgl_estado_IE').AsString + ' ' + Q.FieldByName('num_propriedade_rural').AsString;
                INodeTemp := INodePropriedade.AddChild('NOME');
                INodeTemp.Text := Q.FieldByName('nom_propriedade_rural').AsString;
                INodeTemp := INodePropriedade.AddChild('NR_INSCRICAO_PRODUTOR');
                INodeTemp.Text := Q.FieldByName('cod_ulav_produtor').AsString;
                INodeTemp := INodePropriedade.AddChild('CODIGO_PROPRIEDADE_ESCRITORIO_LOCAL');
                INodeTemp.Text := Q.FieldByName('cod_ulav_fazenda').AsString;
                INodeTemp := INodePropriedade.AddChild('NIRF');
                  Nirf := Q.FieldByName('num_imovel_receita_federal').AsString;
                  if length(nirf) = 8 then
                    INodeTemp.Text := Nirf
                  else
                    INodeTemp.Text := ' ';
                INodeTemp := INodePropriedade.AddChild('INCRA');
                  if length(nirf) = 13 then
                    INodeTemp.Text := Nirf //corresponde ao valor INCRA
                  else
                    INodeTemp.Text := ' ';
                INodeTemp := INodePropriedade.AddChild('ACESSO_FAZENDA');
                INodeTemp.Text := Q.FieldByName('des_acesso_fazenda').AsString;
                INodeTemp := INodePropriedade.AddChild('DISTANCIA_SEDE_MUNICIPIO');
                INodeTemp.Text := Q.FieldByName('qtd_distancia_municipio').AsString;
                INodeTemp := INodePropriedade.AddChild('DT_INI_CERTIFICACAO');
                INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_inicio_certificacao').AsDateTime);
                INodeTemp := INodePropriedade.AddChild('ORIENTACAO_LATITUDE');
                INodeTemp.Text := Q.FieldByName('cod_orientacao_latitude').AsString;
                INodeTemp := INodePropriedade.AddChild('GRAU_LATITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_latitude').AsInteger));
                  if Length(Aux) = 6 then begin
                    Aux := Copy(Aux, 1, 2)
                  end else if Length(Aux) = 5 then begin
                    Aux := PadR(Copy(Aux, 1, 1), '0', 1)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('MINUTO_LATITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_latitude').AsInteger));
                  if Length(Aux) > 2 then begin
                    Aux := Copy(Aux, 3, 2)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('SEGUNDO_LATITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_latitude').AsInteger));
                  if Length(Aux) > 2 then begin
                    Aux := Copy(Aux, 5, 2)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('ORIENTACAO_LONGITUDE');
                INodeTemp.Text := Q.FieldByName('cod_orientacao_longitude').AsString;
                INodeTemp := INodePropriedade.AddChild('GRAU_LONGITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_longitude').AsInteger));
                  if Length(Aux) = 6 then begin
                    Aux := Copy(Aux, 1, 2)
                  end else if Length(Aux) = 5 then begin
                    Aux := PadR(Copy(Aux, 1, 1), '0', 1)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('MINUTO_LONGITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_longitude').AsInteger));
                  if Length(Aux) > 2 then begin
                    Aux := Copy(Aux, 3, 2)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('SEGUNDO_LONGITUDE');
                  Aux := IntToStr(Abs(Q.FieldByName('num_longitude').AsInteger));
                  if Length(Aux) > 2 then begin
                    Aux := Copy(Aux, 5, 2)
                  end else begin
                    Aux := '0';
                  end;
                INodeTemp.Text := Aux;
                INodeTemp := INodePropriedade.AddChild('AREA');
                QtdAreaS := Q.FieldByName('qtd_area').asvariant * 100;
                Insert('.', QtdAreaS, length(QtdAreaS)-1);
                INodeTemp.Text := QtdAreaS;
                INodeTemp := INodePropriedade.AddChild('LOGRADOURO');
                INodeTemp.Text := Q.FieldByName('nom_logradouro').AsString;
                INodeTemp := INodePropriedade.AddChild('BAIRRO');
                INodeTemp.Text := Q.FieldByName('nom_bairro').AsString;
                INodeTemp := INodePropriedade.AddChild('CEP');
                INodeTemp.Text := Q.FieldByName('num_cep').AsString;
                INodeTemp := INodePropriedade.AddChild('NOME_MUNICIPIO');
                INodeTemp.Text := Q.FieldByName('nom_municipio').AsString;
                INodeTemp := INodePropriedade.AddChild('CODIGO_MUNICIPIO_IBGE');
                INodeTemp.Text := Q.FieldByName('num_municipio_ibge').AsString;
                INodeTemp := INodePropriedade.AddChild('LOGRADOURO_CORRESPONDENCIA');
                INodeTemp.Text := Q.FieldByName('nom_logradouro_correspondencia').AsString;
                INodeTemp := INodePropriedade.AddChild('BAIRRO_CORRESPONDENCIA');
                INodeTemp.Text := Q.FieldByName('nom_bairro_correspondencia').AsString;
                INodeTemp := INodePropriedade.AddChild('CEP_CORRESPONDENCIA');
                INodeTemp.Text := Q.FieldByName('num_cep_correspondencia').AsString;
                INodeTemp := INodePropriedade.AddChild('NOME_MUNICIPIO_CORRESPONDENCIA');
                INodeTemp.Text := Q.FieldByName('nom_municipio_correspondencia').AsString;
                INodeTemp := INodePropriedade.AddChild('CODIGO_MUNICIPIO_IBGE_CORRESPONDENCIA');
                INodeTemp.Text := Q.FieldByName('num_ibge_correspondencia').AsString;
                INodeProdutores := INodePropriedade.AddChild('PRODUTORES_PROPRIEDADE');
                  INodeProdutor := INodeProdutores.AddChild('PRODUTOR_PROPRIEDADE');
                    INodeTemp := INodeProdutor.AddChild('TIPO_PRODUTOR');
                    INodeTemp.Text := Q.FieldByName('des_tipo_produtor').AsString;
                    INodeTemp := INodeProdutor.AddChild('CPF_CNPJ');
                    INodeTemp.Text := Q.FieldByName('num_cnpj_cpf_produtor').AsString;
                    INodeTemp := INodeProdutor.AddChild('INDICADOR_PRODUTOR');
                    INodeTemp.Text := Q.FieldByName('cod_regime_posse_uso_sisbov').AsString;
                  INodeProdutor := INodeProdutores.AddChild('PRODUTOR_PROPRIETARIO');
                    INodeTemp := INodeProdutor.AddChild('NOME_PRODUTOR');
                    INodeTemp.Text := Q.FieldByName('nom_pessoa_proprietario').AsString;
                    INodeTemp := INodeProdutor.AddChild('CPF_CNPJ');
                    INodeTemp.Text := Q.FieldByName('num_cnpj_cpf_pessoa_prop').AsString;
          except
            Result := InserirErro(DadosArquivo, 'Erro na gera��o/transmiss�o da propriedade: ' + Q.FieldByName('nom_propriedade_rural').AsString + ')');
          end;

          if DadosArquivo.ArquivoNovo then begin
            Result := AtualizaLocalizacaoSisbov(Q.FieldByName('cod_propriedade_rural').AsInteger,
                                                Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                                DadosArquivo);
            if Result < 0 then begin
              Exit;
            end;
          end;

          Inc(Qtd1);
        end;

        CodProp := Q.FieldByName('cod_propriedade_rural').AsInteger;
        CodPess := 0;
        Q.Next;

        if (CodProp <> Q.FieldByName('cod_propriedade_rural').AsInteger) then begin
          cod_idPropriedade := 0;
        end;
      end;

      XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

      // Grava��o do arquivo, cria arquivo ZIP
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;

      if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
        Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip + ' ID Propriedade ' + IntToStr(cod_idPropriedade)]);
        Result := -2277;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o' + ' ID Propriedade ' + IntToStr(cod_idPropriedade)]);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoPropriedades := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogPRO) then begin
          CodArquivoPropriedades := -1;
        end;
        Result := -1;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message + ' ID Propriedade ' + IntToStr(cod_idPropriedade)]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    if ZipAberto then begin
      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o' + ' ID Propriedade ' + IntToStr(cod_idPropriedade)]);
      end;
    end;

    Q.Free;
    Q1.Free;
    Q2.Free;
    SoapSisbov.Free;
  end;
end;

function TIntInterfaceSisbov.BuscaIdentificacaoDuplaSisbov(
  Query: THerdomQueryNavegacao; DadosArquivo: TDadosArquivo;
  var IdentificacaoDuplaSisbov: String;
  var DtaSolicitacaoCodigo: TDateTime): Integer;
const
  NumMaxPossibilidades = 10;
  NumMaxIdentificadores = 4;
  NomeMetodo = 'BuscaIdentificacaoDuplaSisbov';
  NomPadraoCampoIdentificador = 'cod_tipo_identificador_';
  SqlDtaSolicitacaoSisbov =
    'select ' +
    '  dta_solicitacao_sisbov ' +
    'from ' +
    '  tab_codigo_sisbov ' +
    'where ' +
    '  cod_pais_sisbov = :cod_pais_sisbov ' +
    '  and cod_estado_sisbov = :cod_estado_sisbov ' +
    '  and cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
    '  and cod_animal_sisbov = :cod_animal_sisbov ' +
    '  and num_dv_sisbov = :num_dv_sisbov ';
  SqlIdentificacaoDupla =
    'select '+
    '  tid.cod_identificacao_dupla '+
    '  , tid.cod_identificacao_dupla_sisbov '+
    '  , tid.ind_requer_rgd '+
    '  , tid.dta_validade_solicitacao '+
    'from '+
    '  tab_identificacao_dupla tid '+
    '  , tab_ident_dupla_tipo_ident tidti '+
    'where '+
    '  tid.cod_identificacao_dupla = tidti.cod_identificacao_dupla '+
    '  and isnull(tidti.cod_tipo_identificador_1, 0) = :cod_tipo_identificador_1 '+
    '  and isnull(tidti.cod_tipo_identificador_2, 0) = :cod_tipo_identificador_2 '+
    '  and tid.dta_fim_validade is null ';
var
  Q: THerdomQuery;
  IndRequerRgd: Boolean;
  iAux, jAux, kAux: Integer;
  CodIdentificacaoDupla: Integer;
  DtaValidadeIdentificacao: TDateTime;
  NomCampoIdentificador, CodIdentificacaoDuplaSISBOV: String;
  Possibilidades: Array [1..NumMaxPossibilidades] Of TIdentificacaoDupla;
begin
  Result := 0;
  IdentificacaoDuplaSisbov := '';
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.Close;
      Q.SQL.Text := SqlDtaSolicitacaoSisbov;
      Q.ParamByName('cod_pais_sisbov').AsInteger := Query.FieldByName('cod_pais_sisbov').AsInteger;
      Q.ParamByName('cod_estado_sisbov').AsInteger := Query.FieldByName('cod_estado_sisbov').AsInteger;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := Query.FieldByName('cod_micro_regiao_sisbov').AsInteger;
      Q.ParamByName('cod_animal_sisbov').AsInteger := Query.FieldByName('cod_animal_sisbov').AsInteger;
      Q.ParamByName('num_dv_sisbov').AsInteger := Query.FieldByName('num_dv_sisbov').AsInteger;
      Q.Open;
      if Q.IsEmpty or Q.FieldByName('dta_solicitacao_sisbov').IsNull then begin
        DtaSolicitacaoCodigo := 0;
      end else begin
        DtaSolicitacaoCodigo := Q.FieldByName('dta_solicitacao_sisbov').AsDateTime;
      end;

      kAux := 1;
      For iAux := 1 to NumMaxIdentificadores Do begin
        // Primeiro identificador da dupla
        NomCampoIdentificador := NomPadraoCampoIdentificador + IntToStr(iAux);
        Possibilidades[kAux].CodTipoIdentificador_1 :=
          Query.FieldByName(NomCampoIdentificador).AsInteger;

        // Segundo identificador da dupla
        Possibilidades[kAux].CodTipoIdentificador_2 := 0;

        // Pr�ximas possibilidades
        Inc(kAux);
        For jAux := iAux + 1 to NumMaxIdentificadores Do begin
          // Primeiro identificador da dupla
          NomCampoIdentificador := NomPadraoCampoIdentificador + IntToStr(iAux);
          Possibilidades[kAux].CodTipoIdentificador_1 :=
            Query.FieldByName(NomCampoIdentificador).AsInteger;

          // Segundo identificador da dupla
          NomCampoIdentificador := NomPadraoCampoIdentificador + IntToStr(jAux);
          Possibilidades[kAux].CodTipoIdentificador_2 :=
            Query.FieldByName(NomCampoIdentificador).AsInteger;

          // Pr�xima possibilidade
          Inc(kAux);
        end;
      end;

      // Verifica se uma das possibilidades corresponde a uma idenfica��o dupla
      // v�lida para o SISBOV
      CodIdentificacaoDupla := 0;
      CodIdentificacaoDuplaSISBOV := '';
      IndRequerRgd := False;
      DtaValidadeIdentificacao := 0;
      Q.SQL.Text := SqlIdentificacaoDupla;
      For kAux := 1 to NumMaxPossibilidades Do begin
        if (Possibilidades[kAux].CodTipoIdentificador_1 <> 0) or (Possibilidades[kAux].CodTipoIdentificador_2 <> 0) then begin
          Q.Close;
//          Q.ParamByName('cod_tipo_identificador_1').AsInteger := Possibilidades[kAux].CodTipoIdentificador_1;
//          Q.ParamByName('cod_tipo_identificador_2').AsInteger := Possibilidades[kAux].CodTipoIdentificador_2;

          // Pega os c�digos de identificadores e pesquisa na base os tipos de dupla identifica��o
          if (not Query.FieldByName('cod_tipo_identificador_1').Isnull and not Query.FieldByName('cod_tipo_identificador_2').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_1').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_2').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_1').Isnull and not Query.FieldByName('cod_tipo_identificador_3').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_1').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_3').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_1').Isnull and not Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_1').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_4').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_2').Isnull and not Query.FieldByName('cod_tipo_identificador_3').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_2').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_3').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_2').Isnull and not Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_2').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_4').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_3').Isnull and not Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_3').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := Query.FieldByName('cod_tipo_identificador_4').AsInteger;
          end else if (not Query.FieldByName('cod_tipo_identificador_1').Isnull) and (Query.FieldByName('cod_tipo_identificador_2').Isnull) and (Query.FieldByName('cod_tipo_identificador_3').Isnull) and (Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_1').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := 0;
          end else if (Query.FieldByName('cod_tipo_identificador_1').Isnull) and (not Query.FieldByName('cod_tipo_identificador_2').Isnull) and (Query.FieldByName('cod_tipo_identificador_3').Isnull) and (Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_2').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := 0;
          end else if (Query.FieldByName('cod_tipo_identificador_1').Isnull) and (Query.FieldByName('cod_tipo_identificador_2').Isnull) and (not Query.FieldByName('cod_tipo_identificador_3').Isnull) and (Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_3').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := 0;
          end else if (Query.FieldByName('cod_tipo_identificador_1').Isnull) and (Query.FieldByName('cod_tipo_identificador_2').Isnull) and (Query.FieldByName('cod_tipo_identificador_3').Isnull) and (not Query.FieldByName('cod_tipo_identificador_4').Isnull) then begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := Query.FieldByName('cod_tipo_identificador_4').AsInteger;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := 0;
          end else begin
            Q.ParamByName('cod_tipo_identificador_1').AsInteger := 0;
            Q.ParamByName('cod_tipo_identificador_2').AsInteger := 0;
          end;
          Q.Open;

          if not Q.IsEmpty then begin
            CodIdentificacaoDupla := Q.FieldByName('cod_identificacao_dupla').AsInteger;
            CodIdentificacaoDuplaSISBOV := Q.FieldByName('cod_identificacao_dupla_sisbov').AsString;
            IndRequerRgd := (Q.FieldByName('ind_requer_rgd').AsString = 'S');
            if Q.FieldByName('dta_validade_solicitacao').IsNull then begin
              DtaValidadeIdentificacao := 0;
            end else begin
              DtaValidadeIdentificacao := Trunc(Q.FieldByName('dta_validade_solicitacao').AsDateTime) + 1;
            end;
            if not (IndRequerRgd and (Trim(Query.FieldByName('num_rgd').AsString) = ''))
              and not ((DtaValidadeIdentificacao <> 0) and ((DtaSolicitacaoCodigo = 0) or not (DtaSolicitacaoCodigo < DtaValidadeIdentificacao))) then begin
              Break;
            end;
          end;
        end;
      end;

      // Verifica se os identificadores SISBOV foram identificados
      if (CodIdentificacaoDupla = 0) then begin
        // Insere log de erro para o registro
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel determinar o tipo da dupla identifica��o do animal ' +
          Query.FieldByName('sgl_fazenda_manejo').AsString + '-' + Query.FieldByName('cod_animal_manejo').AsString +
          ' do produtor ' + Query.FieldByName('nom_pessoa').AsString + ' segundo os crit�rios do SISBOV');

        // Finaliza procedimento
        Exit;
      end;

      // Verifica se existe data de validade para tipo de identifica��o
      if DtaValidadeIdentificacao <> 0 then begin
        // Verifica se foi identificada a data de solicita��o SISBOV
        if DtaSolicitacaoCodigo = 0 then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O tipo de identifica��o "' + CodIdentificacaoDuplaSISBOV +
            '" correspondente ao animal ' + Query.FieldByName('sgl_fazenda_manejo').AsString + '-' + Query.FieldByName('cod_animal_manejo').AsString +
            ' do produtor ' + Query.FieldByName('nom_pessoa').AsString + ' exige que a data de solicita��o do c�digo SISBOV relacionado tenha ' +
            ' sido informada');

          // Finaliza procedimento
          Exit;
        end;

        if not (DtaSolicitacaoCodigo < DtaValidadeIdentificacao) then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O tipo de identifica��o "' + CodIdentificacaoDuplaSISBOV +
            '" correspondente ao animal ' + Query.FieldByName('sgl_fazenda_manejo').AsString + '-' + Query.FieldByName('cod_animal_manejo').AsString +
            ' do produtor ' + Query.FieldByName('nom_pessoa').AsString + ' exige data de solicita��o do c�digo SISBOV inferior a data ' +
            ' de validade: ' + FormatDateTime('dd/mm/yyyy', DtaValidadeIdentificacao-1));

          // Finaliza procedimento
          Exit;
        end;
      end;

      // Verifica se a identifica��o dupla v�lida segundo o SISBOV exige que o
      // animal possua n�mero de registro em associa��o
      if IndRequerRgd and (Trim(Query.FieldByName('num_rgd').AsString) = '') then begin
        // Insere log de erro para o registro
        Result := InserirErro(DadosArquivo, 'O tipo de identifica��o "' + CodIdentificacaoDuplaSISBOV +
          '" correspondente ao animal ' + Query.FieldByName('sgl_fazenda_manejo').AsString + '-' + Query.FieldByName('cod_animal_manejo').AsString +
          ' do produtor ' + Query.FieldByName('nom_pessoa').AsString + ' exige que n�mero de registro em associa��o correspondente ao' +
          ' animal seja informado');

        // Finaliza procedimento
        Exit;
      end;
      IdentificacaoDuplaSisbov := CodIdentificacaoDuplaSISBOV;
      Q.Close;

    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1686, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1686;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.GeraArquivoANI(var  DadosArquivo: TDadosArquivo): Integer;
begin
  Result := GeraArquivoAni(DadosArquivo, 'OCX');
end;

function TIntInterfaceSisbov.GeraArquivoANI(
  var DadosArquivo: TDadosArquivo; Chamador: String): Integer;
const
  NomeMetodo: String = 'GeraArquivoANI';
  TipoArquivo: Integer = 2;
var
  Q : THerdomQueryNavegacao;
  Q2, QS : THerdomQuery;
  CodLocN, CodLocI,
  DesTipo, Prefixo: String;
  Zip: ZipFile;
  CodIdentificadorSISBOV, CodArq, Qtd1 : Integer;
  MsgSisbovAnimal, CodAutenticacaoSisbov, Nirf, StrNrSisBov: String;
  CpfCnpjProdutor, NirfLocalizacao, numCNPJ, numCPF, IdentificacaoDuplaSisbov: String;
  DtaSolicitacaoCodigo: TDateTime;
  XMLDoc: TXMLDocument;
  ZipAberto, Conectado: boolean;
//  DtaNascimento, DtaIdentificacao : TXSDateTime;
  SoapSisbov: TIntSoapSisbov;
  RetornoASisbov: RetornoIncluirAnimal;
  RetornoCDASisbov: RetornoConsultarDadosAnimal;
  INodeArquivo, INodeInclusaoAnimais, INodeInclusaoAnimal, INodeTemp : IXMLNode;
  AgendarServico : Boolean;
  IntArquivosFTPEnvio: TIntArquivosFTPEnvio;
  Erro: Boolean;
begin
  try
  //  XMLDoc := nil;
//    RetornoASisbov   := nil;
//    RetornoCDASisbov := nil;
    ZipAberto        := false;
    MsgSisbovAnimal  := '';
    AgendarServico   := false;
    Conectado        := false;
    Erro             := false;

    QS := THerdomQuery.Create(Conexao, nil);
    Q2 := THerdomQuery.Create(Conexao, nil);
    SoapSisbov := TIntSoapSisbov.Create;
    try
      try
        // Se estiver chamando um reprocessamento de arquivo PELA P�GINA, ent�o verifica se
        // j� n�o existe um agendamento pendente para este arquivo
        if (Chamador = 'OCX') and (DadosArquivo.CodArquivoSisbov > 0) then begin
          QS.SQL.Clear;
    {$IFDEF MSSQL}
          QS.SQL.Add('select 1 from tab_arquivo_ftp_envio ' +
                    '  where cod_arquivo_sisbov = :cod_arquivo_sisbov '+
                    '    and cod_situacao_arquivo_ftp = 1 ');
    {$ENDIF}
          QS.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
          QS.Open;

          // Se j� houver um agendamento pendente para este arquivo, ent�o n�o criaremos outro agendamento
          // pois o servi�o processar� o agendamento existente e isso dever� ser transparente
          // para o usu�rio, dessa forma, simplesmente retornaremos zero nesta rotina
          if not QS.IsEmpty then begin
            Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
            if Result < 0 then begin
              Exit;
            end;
            DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
            DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
            FPossuiLogANI := true;
            Exit;
          end;
        end;

        QS.SQL.Clear;
        QS.SQL.Add('select distinct 1 from ' +
                  'tab_codigo_exportacao tce ' +
                  ',    	tab_animal ta ' +
                  'where tce.cod_arquivo_sisbov = :cod_arquivo_sisbov ' +
                  'and   ta.cod_animal = tce.cod_animal ' +
                  'and   ta.dta_fim_validade is null ');

        if (Not DadosArquivo.ArquivoNovo) then begin
          QS.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
          QS.Open;

          // Verifica se existe algum animal da rela��o do arquivo solicitado para
          // processamento que foi remarcado para exporta��o.
          if not QS.IsEmpty then begin
            Mensagens.Adicionar(1645, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
            Result := 1645;
            Exit;
          end;
        end;

  //      Q := THerdomQueryNavegacao.Create(Conexao, nil);
        Q := THerdomQueryNavegacao.Create(nil);
        try
          Q.SQLConnection := Conexao.SQLConnection;
          try
            Q.SQL.Clear;
            {$IFDEF MSSQL}
            Q.SQL.Add('select   ta.cod_pessoa_produtor, ' +
                      '         ta.cod_animal, ' +
                      '         te.cod_especie_sisbov, ' +
                      '         ta.cod_pais_sisbov, ' +
                      '         ta.cod_estado_sisbov, ' +
                      '         ta.cod_micro_regiao_sisbov, ' +
                      '         ta.cod_animal_sisbov, ' +
                      '         ta.num_dv_sisbov, ' +
                      '         ta.dta_identificacao_sisbov, ' +
                      '         tr.cod_raca_sisbov, ' +
                      '         ta.dta_nascimento, ' +
                      '         ta.ind_sexo as ind_sexo, ' +
                      '         tap.cod_aptidao_sisbov, ' +
                  // Pega o nirf de nascimento, pesquisando pela fazenda ou indo direto na propriedade pelo cod. propried.
                      '         case isnull(ta.cod_propriedade_nascimento, '''') when '''' then ' +
                      '            case isnull(ta.cod_fazenda_nascimento, '''') ' +
                      '               when '''' then null ' +
                      '            else ' +
                      '               (select tpr11.num_imovel_receita_federal from tab_fazenda tf11 , tab_propriedade_rural tpr11 ' +
                      '                where  tf11.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                   and tf11.cod_fazenda = ta.cod_fazenda_nascimento ' +
                      '                   and tf11.cod_propriedade_rural = tpr11.cod_propriedade_rural) ' +
                      '            end ' +
                      '         else ' +
                      '           (select tpr11.num_imovel_receita_federal from tab_propriedade_rural tpr11 ' +
                      '            where  tpr11.cod_propriedade_rural = ta.cod_propriedade_nascimento) ' +
                      '         end as nirf_nascimento, ' +
                  // Pega o cod. propriedade da tab_animal ou pesquisando pela fazenda
                      '         case isnull(ta.cod_propriedade_nascimento, '''') ' +
                      '           when '''' then ' +
                      '              case isnull(ta.cod_fazenda_nascimento, '''') ' +
                      '                 when '''' then null ' +
                      '              else ' +
                      '                 (select tf12.cod_propriedade_rural from tab_fazenda tf12 ' +
                      '                  where tf12.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                    and tf12.cod_fazenda = ta.cod_fazenda_nascimento) ' +
                      '              end ' +
                      '         else ' +
                      '            ta.cod_propriedade_nascimento ' +
                      '         end as cod_propriedade_nascimento, ' +
                  // Pega o cod ID da propriedade nascimento pela fazenda ou direto na propriedade
                      '         case isnull(ta.cod_propriedade_nascimento, '''') ' +
                      '           when '''' then ' +
                      '              case isnull(ta.cod_fazenda_nascimento, '''') ' +
                      '                 when '''' then null ' +
                      '              else ' +
                      '                 (select tpr13.cod_id_propriedade_sisbov from tab_fazenda tf13 , tab_propriedade_rural tpr13 ' +
                      '                    where  tf13.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                       and tf13.cod_fazenda = ta.cod_fazenda_nascimento ' +
                      '                       and tf13.cod_propriedade_rural = tpr13.cod_propriedade_rural) ' +
                      '              end ' +
                      '         else ' +
                      '            (select tpr13.cod_id_propriedade_sisbov from tab_propriedade_rural tpr13 ' +
                      '             where  tpr13.cod_propriedade_rural = ta.cod_propriedade_nascimento) ' +
                      '         end as cod_id_propriedade_nascimento, ' +
                  // Pega o cod ID da propriedade respons�vel pela fazenda ou propriedade identificacao
                      '         case isnull(ta.cod_propriedade_identificacao, '''') when '''' then ' +
                      '            case isnull(ta.cod_fazenda_identificacao, '''') ' +
                      '               when '''' then null ' +
                      '            else ' +
                      '               (select tpr14.cod_id_propriedade_sisbov from tab_fazenda tf14 , tab_propriedade_rural tpr14 ' +
                      '                where  tf14.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                   and tf14.cod_fazenda = ta.cod_fazenda_identificacao ' +
                      '                   and tf14.cod_propriedade_rural = tpr14.cod_propriedade_rural) ' +
                      '            end ' +
                      '         else ' +
                      '            (select tpr14.cod_id_propriedade_sisbov from tab_propriedade_rural tpr14 ' +
                      '             where  tpr14.cod_propriedade_rural = ta.cod_propriedade_identificacao) ' +
                      '         end as cod_id_propriedade_responsavel, ' +
                  // Pega o cod ID da propriedade localizacao pela fazenda ou propriedade corrente
                      '         case isnull(ta.cod_propriedade_corrente, '''') when '''' then ' +
                      '            case isnull(ta.cod_fazenda_corrente, '''') ' +
                      '               when '''' then null ' +
                      '            else ' +
                      '               (select tpr14.cod_id_propriedade_sisbov from tab_fazenda tf14 , tab_propriedade_rural tpr14 ' +
                      '                where  tf14.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                   and tf14.cod_fazenda = ta.cod_fazenda_corrente ' +
                      '                   and tf14.cod_propriedade_rural = tpr14.cod_propriedade_rural) ' +
                      '            end ' +
                      '         else ' +
                      '            (select tpr14.cod_id_propriedade_sisbov from tab_propriedade_rural tpr14 ' +
                      '             where  tpr14.cod_propriedade_rural = ta.cod_propriedade_corrente) ' +
                      '         end as cod_id_propriedade_localizacao, ' +
                  // Pega o NIRF de identifica��o pelo cod. propriedade ou pelo cod. fazenda
                      '         case isnull(ta.cod_propriedade_identificacao, '''') when '''' then ' +
                      '            case isnull(ta.cod_fazenda_identificacao, '''') ' +
                      '               when '''' then null ' +
                      '            else ' +
                      '              (select tpr15.num_imovel_receita_federal from tab_fazenda tf15 , tab_propriedade_rural tpr15 ' +
                      '               where  tf15.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                  and tf15.cod_fazenda = ta.cod_fazenda_identificacao ' +
                      '                  and tf15.cod_propriedade_rural = tpr15.cod_propriedade_rural) ' +
                      '            end ' +
                      '         else ' +
                      '            (select tpr15.num_imovel_receita_federal from tab_propriedade_rural tpr15 ' +
                      '             where  tpr15.cod_propriedade_rural = ta.cod_propriedade_identificacao) ' +
                      '         end as nirf_identificacao, ' +
                  // Pega o c�digo de identifica��o da propriedade pelo cod. propriedade ou pelo cod. fazenda
                      '         case isnull(ta.cod_propriedade_identificacao, '''') when '''' then ' +
                      '            case isnull(ta.cod_fazenda_identificacao, '''') ' +
                      '               when '''' then null ' +
                      '            else ' +
                      '              (select tf16.cod_propriedade_rural from tab_fazenda tf16 ' +
                      '               where  tf16.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '                  and tf16.cod_fazenda = ta.cod_fazenda_identificacao) ' +
                      '            end ' +
                      '         else ' +
                      '      ta.cod_propriedade_identificacao ' +
                      '         end as cod_propriedade_identificacao, ' +
                      '         ta.num_rgd, ' +
                      '         ta.cod_animal_certificadora, ' +
                      '         case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                      '           when 0 then 0 ' +
                      '         else ' +
                      '           1 ' +
                      '         end as ind_cadastro_efetivado, ' +
                      '         tf.sgl_fazenda as sgl_fazenda_manejo, ' +
                      '         ta.cod_animal_manejo, ' +
                      '         tp.nom_pessoa, ' +
                      '         case tp.cod_natureza_pessoa ' +
                      '           when ''F'' then ''PF'' ' +
                      '           when ''J'' then ''PJ'' ' +
                      '         end  as tipo_proprietario, ' +
                      '         tp.num_cnpj_cpf, ' +
                      '         ta.cod_tipo_identificador_1, ' +
                      '         ta.cod_tipo_identificador_2, ' +
                      '         ta.cod_tipo_identificador_3, ' +
                      '         ta.cod_tipo_identificador_4, ' +
                      '         ta.ind_transmissao_sisbov ' +
                      '        from tab_pessoa tp, ' +
                      '             tab_animal ta ' +
                      '               inner join ' +
                      '                 tab_especie te ' +
                      '               on te.cod_especie = ta.cod_especie and ' +
                      '                ta.dta_fim_validade is null and ' +
                      '                ta.cod_tipo_origem in (1, 2, 5, 6) ' +
                      '               inner join ' +
                      '                tab_raca tr ' +
                      '                on ta.cod_raca = tr.cod_raca ' +
                      '               inner join ' +
                      '                tab_aptidao tap ' +
                      '                on tap.cod_aptidao = ta.cod_aptidao ' +
                      '               inner join ' +
                      '               tab_fazenda tf ' +
                      '                on tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                      '       where tp.cod_pessoa = ta.cod_pessoa_produtor ' +
                      '         and tf.cod_fazenda = ta.cod_fazenda_manejo '); 
            if DadosArquivo.ArquivoNovo then begin
              Q.SQL.Add('   and ta.cod_animal not in (select distinct cod_animal from tab_codigo_exportacao) ');
              Q.SQL.Add('   and ta.dta_efetivacao_cadastro is not null ');
              Q.SQL.Add('   and ta.cod_arquivo_sisbov is null ');
            end else begin
              Q.SQL.Add('   and ta.cod_arquivo_sisbov = :cod_arquivo_sisbov ');
            end;
            {$ENDIF}

            // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
            // pega registros gerados com o c�digo informado
            if DadosArquivo.ArquivoNovo then begin
              DadosArquivo.CodArquivoSisbov := -1;
            end else begin
              Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
            end;

            Q.Open;

            // Tratamento para o caso de n�o encontrar nenhuma informa��o
            if Q.IsEmpty then begin
              // Se n�o for arquivo novo e n�o encontrar registros, causa erro
              if (Not DadosArquivo.ArquivoNovo) then begin
                Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
                Result := -1083;
              end else begin
                Result := -1;
              end;
              Exit;
            end;

            // Se quantidade de registros > limite permitido no par�metro, ent�o agenda servi�o
            if Chamador = 'OCX' then begin
              if Q.RecordCount > StrToInt(ValorParametro(125)) then begin
                AgendarServico := true;
              end;
            end;

            // Se chamada for 'SER' (servi�o) ent�o AgendarServico = False
            // Se chamada for 'OCX' ent�o AgendarServi�o pode ser true se nro registros > parametro ou false se n�o
            // Conclus�o, se AgendarServico = false ent�o haver� transmiss�o ao SISBOV
            if Not AgendarServico then begin
              SoapSisbov.Inicializar(Conexao, Mensagens);
              Conectado := SoapSisbov.conectado('Animais');
            end;

            // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
            // OBS: S� pode ser arquivo novo no caso da chamada ter sido feita pela OCX
            // j� que quando a chamada for feita pelo servi�o o arquivo n�o ser� novo
            if DadosArquivo.ArquivoNovo then begin
              // Obtem pr�ximo c�digo
              Result := ProximoCodArquivoSisbov;
              if Result < 0 then begin
                Exit;
              end;
              DadosArquivo.CodArquivoSisbov := Result;

              // Monta nome do arquivo
              DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
              Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
              if Result < 0 then begin
                Exit;
              end;
              DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
              DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';

              // Grava registro na tab_arquivo_sisbov
              Result := GravaArquivoSisbov(DadosArquivo);
              if Result < 0 then begin
                Exit;
              end;
            end else begin
              Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
              if Result < 0 then begin
                Exit;
              end;
              DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
              DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
            end;

            // Limpa mensagens de erro
            Result := LimparErros(DadosArquivo);

            // Se for haver transmiss�o ent�o deve-se garantir que a conex�o com o sisbov foi estabelecida
            if (not AgendarServico) then begin
              if (Not conectado) then begin
                Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de animais n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
              end;
            end;

            { Grava��o do arquivo de Propriedade em XML }
            XMLDoc := TXMLDocument.Create(nil);
            try
              XMLDoc.Active := true;

              INodeArquivo := XMLDoc.AddChild('ARQUIVO');
              INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
              INodeTemp.Text := DadosArquivo.CNPJCertificadora;
              INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
              INodeTemp.Text := 'IAN'; //VALOR FIXO

              INodeInclusaoAnimais := INodeArquivo.AddChild('INCLUSAO_ANIMAIS');
            except
              Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - ANIMAIS ']);
              Result := -2278;
              Exit;
            end;

            Qtd1 := 0;
            NirfLocalizacao := '';
            CpfCnpjProdutor := '';

            While Not Q.Eof do begin
              RetornoASisbov   := nil;
              RetornoCDASisbov := nil;

              // Consiste se animal est� efetivado
              if Q.FieldByName('ind_cadastro_efetivado').AsInteger <> 1 then begin
                if Not DadosArquivo.ArquivoNovo then begin
                  // Insere log de erro para o registro
                  Result := InserirErro(DadosArquivo, 'O animal ' +
                  Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
                  ' do produtor ' + Q.FieldByName('nom_pessoa').AsString +
                  ' n�o est� identificado no SISBOV');
                  Erro := true;

                  if Result < 0 then begin
                    Exit;
                  end;

                  // Marca registro como registro com log de erro
                  Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                              Q.FieldByName('cod_animal').AsInteger,
                                              DadosArquivo);
                  if Result < 0 then begin
                    Exit;
                  end;
                end;
                Q.Next;
                Continue;
              end;

              // Verifica se propriedade de identificacao j� foi exportada
              Result := CodLocalizacao(Q.FieldByName('cod_propriedade_identificacao').AsInteger,
                                       Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                       CodLocI,
                                       CodArq);
              if Result < 0 then begin
                Exit;
              end;
              if (CodLocI = '') or (CodArq < 0) then begin
                // Insere log de erro para o registro
                Result := InserirErro(DadosArquivo, 'A fazenda ou propriedade de identifica��o do animal ' +
                                      Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
                                      ' do produtor ' + Q.FieldByName('nom_pessoa').AsString +
                                      ' ainda n�o foi enviada para o SISBOV');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;

                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;

                Q.Next;
                Continue;
              end;

              if Q.FieldByName('cod_propriedade_nascimento').AsInteger <> 0 then begin
                // Verifica se propriedade de nascimento j� foi exportada
                Result := CodLocalizacao(Q.FieldByName('cod_propriedade_nascimento').AsInteger,
                                         Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                         CodLocN,
                                         CodArq);
                if Result < 0 then begin
                  Exit;
                end;

                if (CodLocN = '') or (CodArq < 0) then begin
                  // Insere log de erro para o registro
                  Result := InserirErro(DadosArquivo, 'A fazenda ou propriedade de nascimento do animal ' +
                            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
                            ' do produtor ' + Q.FieldByName('nom_pessoa').AsString +
                            ' ainda n�o foi enviada para o SISBOV');
                  Erro := true;

                  if Result < 0 then begin
                    Exit;
                  end;

                  // Marca registro como registro com log de erro
                  Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                              Q.FieldByName('cod_animal').AsInteger,
                                              DadosArquivo);
                  if Result < 0 then begin
                    Exit;
                  end;

                  Q.Next;
                  Continue;
                end;
              end;

              // Constr�i o tipo de identifica��o dupla SISBOV correspondente ao animal
              Result := BuscaIdentificacaoDuplaSisbov(Q, DadosArquivo,
                                                      IdentificacaoDuplaSisbov, DtaSolicitacaoCodigo);

              // Verifica a ocorr�ncia de erros durante o procedimento e cancela a opera��o
              if Result < 0 then begin
                Exit;
              end;

              // Verifica a n�o identifica��o e registra o erro
              if (IdentificacaoDuplaSisbov = '') then begin
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);

                // Verifica a ocorr�ncia de erros durante o procedimento e cancela a opera��o
                if Result < 0 then begin
                  Exit;
                end;

                Q.Next;
                // Avalia pr�xima animal
                Continue;
              end;

              // Verifica se o NIRF possui 8 digitos
              if (not ValidaNirfIncra(Trim(Q.FieldByName('nirf_nascimento').AsString), False))
              or (not ValidaNirfIncra(Trim(Q.FieldByName('nirf_identificacao').AsString), True)) then begin
                // Insere log de erro para o registro
                Result := InserirErro(DadosArquivo,
                          'O n�mero de inscri��o do im�vel rural na Secretaria da Receita Federal (NIRF) '
                          + 'est� incorreto para a propriedade do animal '
                          + Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString
                          + ' do produtor ' + Q.FieldByName('nom_pessoa').AsString + '.');
                Erro := true;

                if Result < 0 then begin
                  Exit;
                end;

                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;

                Q.Next;
                Continue;
              end;

              // Se rotina foi chamada pela OCX ent�o atualiza o animal com o c�d arquivo sisbov
              // Esta opera��o n�o � necess�ria quando a chamada foi feita pelo servi�o porque
              // nesse caso ela j� ter� sido previamente executada na chamada pela OCX
              if Chamador = 'OCX' then begin
                if DadosArquivo.ArquivoNovo then begin
                  Result := AtualizaAnimal(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                           Q.FieldByName('cod_animal').AsInteger,
                                           DadosArquivo);
                  if Result < 0 then begin
                    Exit;
                  end;
                end;
              end;

              // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
              // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
              StrNrSisBov := '';
              if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '-1' then begin
                StrNrSisBov := StrNrSisBov + '105' +
                                   PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                   PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                   PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
              end else begin
                // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
                // com as novas implementa��es do sisbov
                if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
                  StrNrSisBov := StrNrSisBov + '105' +
                                   PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                   '00' +
                                   PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                   PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end else begin
                  StrNrSisBov := StrNrSisBov + '105' +
                                   PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                   PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                                   PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                   PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end;
              end;

              // Consiste o nr sisbov
              if StrNrSisBov = '' then begin
                Result := InserirErro(DadosArquivo, 'O n�mero SISBOV n�o foi informado.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste a data de identificacao
              if Q.FieldByName('dta_identificacao_sisbov').AsDateTime > DateOf(Now) then begin
                Result := InserirErro(DadosArquivo, 'A data de inicio da certifica��o deve ser menor ou igual que a data atual.');
                Erro := true;

                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste dupla identificacao
              if IdentificacaoDuplaSisbov = '' then begin
                Result := InserirErro(DadosArquivo, 'A dupla identifica��o SISBOV n�o foi informada');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste ra�a
              if ObtemRacaAnimal(Q.FieldByName('cod_raca_sisbov').AsString, DtaSolicitacaoCodigo) = '' then begin
                Result := InserirErro(DadosArquivo, 'A ra�a do animal n�o foi informada.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste data nascimento
              if Q.FieldByName('dta_nascimento').AsDateTime > DateOf(Now) then begin
                Result := InserirErro(DadosArquivo, 'A data de nascimento deve ser menor ou igual que a data atual.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste sexo
              if Q.FieldByName('ind_sexo').AsString = '' then begin
                Result := InserirErro(DadosArquivo, 'Sexo do animal n�o foi informado.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste tipo produtor
              if Q.FieldByName('tipo_proprietario').AsString = '' then begin
                Result := InserirErro(DadosArquivo, 'Tipo produtor n�o foi informado.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              // Consiste cpf cnpj do produtor
              if Q.FieldByName('num_cnpj_cpf').AsString = '' then begin
                Result := InserirErro(DadosArquivo, 'CPF/CNPJ do produtor n�o foi informado.');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
                // Marca registro como registro com log de erro
                Result := AtualizaAnimalLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
                if Result < 0 then begin
                  Exit;
                end;
                Q.Next;
                Continue;
              end;

              try
                // S� estar� conectado caso deva ocorrer a transmiss�o agora, ou seja quando n�o estiver
                // somente agendando o servi�o
                If (Conectado) and ((Q.FieldByName('ind_transmissao_sisbov').AsString = '') or (Q.FieldByName('ind_transmissao_sisbov').AsString = 'N')) then begin
                  if Q.FieldByName('tipo_proprietario').AsString = 'PF' then begin
                    numCNPJ := '';
                    numCPF  := Q.FieldByName('num_cnpj_cpf').AsString;
                  end else begin
                    numCPF  := '';
                    numCNPJ := Q.FieldByName('num_cnpj_cpf').AsString;
                  end;

                  CodIdentificadorSISBOV       := StrToInt(trim(IdentificacaoDuplaSisbov));

                  try
                    RetornoASisbov := SoapSisbov.incluirAnimal(
                                       Descriptografar(ValorParametro(118))
                                     , Descriptografar(ValorParametro(119))
                                     , FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_identificacao_sisbov').AsDateTime)
                                     , FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_nascimento').AsDateTime)
                                     , ''
                                     , Q.FieldByName('num_rgd').AsString
                                     , Q.FieldByName('cod_id_propriedade_nascimento').AsInteger
                                     , Q.FieldByName('cod_id_propriedade_localizacao').AsInteger
                                     , Q.FieldByName('cod_id_propriedade_responsavel').AsInteger
                                     , StrNrSisBov
                                     , Q.FieldByName('cod_raca_sisbov').AsString
                                     , CodIdentificadorSISBOV
                                     , Q.FieldByName('ind_sexo').AsString
                                     , numCNPJ
                                     , numCPF);
                  except
                    on E: Exception do
                    begin
                      Result := InserirErro(DadosArquivo, 'Erro ao transmitir animal (COD. SISBOV:' + StrNrSisBov + ').');
                      Erro := true;

                      if Result < 0 then begin
                        Exit;
                      end;
                    end;
                  end;

                  If RetornoASisbov <> nil then begin
                    If (RetornoASisbov.Status = 0) and (RetornoASisbov.listaErros[0].codigoErro <> '1.023')  then begin
                      BeginTran;

                      Q2.SQL.Clear;
                      {$IFDEF MSSQL}
                         Q2.SQL.Add('update tab_animal ' +
                                    '   set cod_id_transacao_sisbov = :cod_id_transacao ' +
                                    ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                                    ' and   cod_animal              = :cod_animal ');
                      {$ENDIF}
                      Q2.ParamByName('cod_pessoa_produtor').AsInteger      := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                      Q2.ParamByName('cod_animal').AsInteger               := Q.FieldByName('cod_animal').AsInteger;
                      Q2.ParamByName('cod_id_transacao').AsInteger         := RetornoASisbov.idTransacao;

                      Q2.ExecSQL;

                      Commit;

                      MsgSisbovAnimal := TrataMensagemErroSISBOV(RetornoASisbov);

                      Result := InserirErro(DadosArquivo, 'Erro ao transmitir o animal (COD. SISBOV:' + StrNrSisBov + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoASisbov));
                      Erro := true;

                      if Result < 0 then begin
                        Exit;
                      end;
                    end else begin
                      CodAutenticacaoSisbov := '';
                      MsgSisbovAnimal       := '';

                      // Busca no sistema SISBOV o c�digo autentica��o do animal
                      // para impressao posteriormente do DIA
                      try
                        RetornoCDASisbov := SoapSisbov.consultarDadosAnimal(
                                         Descriptografar(ValorParametro(118))
                                       , Descriptografar(ValorParametro(119))
                                       , StrNrSisBov);
                      except
                        on E: Exception do
                        begin
                          Result := InserirErro(DadosArquivo, 'Erro ao buscar o c�digo autentica��o do animal (COD. SISBOV:' + StrNrSisBov + ').');

                          if Result < 0 then begin
                            Exit;
                          end;
                        end;
                      end;

                      If RetornoCDASisbov <> nil then begin
                        If RetornoCDASisbov.Status = 1 then begin
                          CodAutenticacaoSisbov := RetornoCDASisbov.dia;

                          BeginTran;

                          Q2.SQL.Clear;
                          {$IFDEF MSSQL}
                             Q2.SQL.Add('update tab_animal ' +
                                        '   set ind_transmissao_sisbov  = ''S'' ' +
                                        '    ,  cod_autenticacao_sisbov = :cod_autenticacao_sisbov ' +
                                        '    ,  dta_insercao_sisbov     = getdate() ' +
                                        ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                                        ' and   cod_animal              = :cod_animal ');
                          {$ENDIF}
                          Q2.ParamByName('cod_pessoa_produtor').AsInteger      := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                          Q2.ParamByName('cod_animal').AsInteger               := Q.FieldByName('cod_animal').AsInteger;
                          Q2.ParamByName('cod_autenticacao_sisbov').AsString   := CodAutenticacaoSisbov;

                          Q2.ExecSQL;

                          Commit;
{ ** Comentado em 24/01/2008 as 16:45hs por Edivaldo Junior
     Solicita��o de Luiz Canival.
                          // Este procedimento foi retirado porque o sisbov n�o retorna mais a data de
                          // previs�o de abate e tamb�m porque da data de inser��o sisbov passou para a tab_animal
                          Q2.SQL.Clear;
                          {$IFDEF MSSQL
                          Q2.SQL.Add('update tab_codigo_sisbov ' +
                                    '   set dta_liberacao_abate     = :dta_liberacao_abate ' +
                                    ' where cod_pais_sisbov         = :cod_pais_sisbov ' +
                                    ' and   cod_estado_sisbov       = :cod_estado_sisbov ' +
                                    ' and   cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
                                    ' and   cod_animal_sisbov       = :cod_animal_sisbov ');
                          {$ENDIF

                          Q2.ParamByName('cod_pais_sisbov').AsInteger         := Q.FieldByName('cod_pais_sisbov').AsInteger;
                          Q2.ParamByName('cod_estado_sisbov').AsInteger       := Q.FieldByName('cod_estado_sisbov').AsInteger;
                          Q2.ParamByName('cod_micro_regiao_sisbov').AsInteger := Q.FieldByName('cod_micro_regiao_sisbov').AsInteger;
                          Q2.ParamByName('cod_animal_sisbov').AsInteger       := Q.FieldByName('cod_animal_sisbov').AsInteger;

                          if Length(Trim(RetornoCDASisbov.dataLiberacaoAbate)) > 0 then begin
                            Q2.ParamByName('dta_liberacao_abate').AsString    := RetornoCDASisbov.dataLiberacaoAbate;
                          end else begin
                            Q2.ParamByName('dta_liberacao_abate').Datatype := ftDateTime;
                            Q2.ParamByName('dta_liberacao_abate').Clear;
                          end;

                          Q2.ExecSQL;
}
                        end;
                      end else begin
                        Result := InserirErro(DadosArquivo, 'Erro no retorno da busca do c�digo criptografado (DIA) do animal (COD. SISBOV:' + StrNrSisBov + ')');
                        Erro := true;
                      end;
                    end;
                  end else begin
                    Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do animal (COD. SISBOV:' + StrNrSisBov + ').');
                    Erro := true;
                  end;
                end;

                if (NirfLocalizacao <> Q.FieldByName('nirf_identificacao').AsString) or
                   (CpfCnpjProdutor <> Q.FieldByName('num_cnpj_cpf').AsString) then begin

                  NirfLocalizacao := Q.FieldByName('nirf_identificacao').AsString;
                  CpfCnpjProdutor := Q.FieldByName('num_cnpj_cpf').AsString;

                  INodeInclusaoAnimal := INodeInclusaoAnimais.AddChild('INCLUSAO_ANIMAL');
                    INodeTemp := INodeInclusaoAnimal.AddChild('NIRF_LOCALIZACAO');
                        Nirf := Q.FieldByName('nirf_identificacao').AsString;
                        if Length(Nirf) = 8 then
                         INodeTemp.Text := Nirf
                       else
                         INodeTemp.Text := ' ';
                    INodeTemp := INodeInclusaoAnimal.AddChild('CPF_CNPJ_PRODUTOR');
                    INodeTemp.Text := Q.FieldByName('num_cnpj_cpf').AsString;
                    INodeTemp := INodeInclusaoAnimal.AddChild('NR_SISBOV');
                    INodeTemp.Text := StrNrSisBov;
                    INodeTemp := INodeInclusaoAnimal.AddChild('MSG_SISBOV');
                    INodeTemp.Text := MsgSisbovAnimal;
                end else begin
                    INodeTemp := INodeInclusaoAnimal.AddChild('NR_SISBOV');
                    INodeTemp.Text := StrNrSisBov;
                    INodeTemp := INodeInclusaoAnimal.AddChild('MSG_SISBOV');
                    INodeTemp.Text := TrataMensagemErroSISBOV(RetornoASisbov);
                end;
              except
                Result := InserirErro(DadosArquivo, 'Erro na montagem/transmiss�o dos dados do animal ('+ '105' +
                                   PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                                   PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                                   PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1) + ').');
                Erro := true;
                if Result < 0 then begin
                  Exit;
                end;
              end;

              Inc(Qtd1);
              Q.Next;
            end;

            if ExtractFileExt(DadosArquivo.NomArquivoSisbov) = '' then begin
              DadosArquivo.NomArquivoSisbov := DadosArquivo.NomArquivoSisbov + '.xml';
            end;
            XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

            // Grava��o do arquivo, cria arquivo ZIP
            if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
              Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
              Result := -1140;
              Exit;
            end else begin
              ZipAberto := true;
            end;

            if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
              Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip]);
              Result := -2277;
              Exit;
            end;

            if FecharZip(Zip, nil) < 0 then begin
              Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
              Result := -1140;
              Exit;
            end else begin
              ZipAberto := false;
            end;
            DeleteFile(DadosArquivo.NomArquivoSisbov);

            // Se for um agendamento de servi�o, ent�o insere entrada para processamento posterior
            if AgendarServico then begin
              Result := AtualizaTamanhoArquivo(DadosArquivo);
              if Result < 0 then begin
                Exit;
              end;

              IntArquivosFTPEnvio := TIntArquivosFTPEnvio.Create;
              try
                Result := IntArquivosFTPEnvio.Inicializar(Conexao, Mensagens);
                if Result < 0 then begin
                  exit;
                end;

                Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaIAN,
                                                      ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                      ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                      ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                      DadosArquivo.Tamanho,
                                                      DadosArquivo.IndDescompactarArquivoFTP,
                                                      DadosArquivo.CodArquivoSisbov);

                if Result < 0 then begin
                  exit;
                end;
                Result := InserirErro(DadosArquivo, 'Devido ao grande volume de animais a serem transmitidos, esta opera��o foi inclu�da ' +
                          'no processamento batch. Para visualizar a transmiss�o, favor acessar no menu principal, a op��o "Processamento batch" / "Arquivos enviados p/ SISBOV"');

              finally
                IntArquivosFTPEnvio.Free;
              end;

              if Result < 0 then begin
                Rollback;
                Exit;
              end;
            end else begin
              if Chamador = 'SER' then begin
                if (Qtd1 > 0) and (not Erro) then begin
                  DadosArquivo.PossuiLogErro := false;
                end else begin
                  DadosArquivo.PossuiLogErro := true;
                end;
                Result := AtualizaTamanhoArquivo(DadosArquivo);
              end;  
            end;

            CodArquivoAnimais := DadosArquivo.CodArquivoSisbov;

            if Qtd1 > 0 then begin
               if Not Erro then begin
                 Result := 0;
               end else begin
                 Result := -1;
               end;
            end else begin
              if (DadosArquivo.ArquivoNovo) and (not FPossuiLogANI) then begin
                CodArquivoAnimais := -1;
              end;
              Result := -1;
            end;
          except
            On E: Exception do begin
              Rollback;
              Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
              Result := -1087;
              Exit;
            end;
          end;
        finally
         Q.Free;
        end;
      except
        On E: Exception do begin
          Rollback;
          Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
          Result := -1087;
          Exit;
        end;
      end;
    finally
     if ZipAberto then begin
        if FecharZip(Zip, nil) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
          Result := -1140;
        end;
     end;

     QS.Free;
     Q2.Free;
     SoapSisbov.Free;
    end;
  except
    on E:Exception do begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1140;
    end;
  end;
end;

function TIntInterfaceSisbov.GeraArquivoMOR(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoMOR';
  TipoArquivo: Integer = 3;
var
  Q, Q2 : THerdomQuery;
  DesTipo, Prefixo: String;
  Zip : ZipFile;
  CodTmp, CodTmp1, Qtd1 : Integer;
  NRSISBOV : String;
  XMLDoc: TXMLDocument;
  ZipAberto, Conectado: boolean;
//  DtaMorte : TXSDateTime;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoWsSISBOV;
  INodeArquivo, INodeMortesAnimal, INodeMorteAnimal, INodeTemp : IXMLNode;
begin
//  XMLDoc := nil;
//  RetornoSisbov := nil;
  ZipAberto     := false;

  Q := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Morte');

      // Obtem as informa��es para gera��o do arquivo
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select te.cod_pessoa_produtor, ' +
                '       tp.nom_pessoa, ' +
                '       te.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       te.dta_inicio, ' +
                '       ttm.cod_tipo_morte_sisbov, ' +
                '       tcm.cod_causa_morte_sisbov, ' +
                '       tcm.des_causa_morte, ' +
                '       tte.des_tipo_evento, ' +
                '       ttm.des_tipo_morte, ' + 
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tf.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       tae.ind_transmissao_sisbov ' +
                '  from tab_evento te, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_evento_morte tem, ' +
                '       tab_tipo_morte ttm, ' +
                '       tab_causa_morte tcm, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tf ' +
                ' where tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and ta.cod_animal = tae.cod_animal ' +
                '   and ta.dta_fim_validade is null ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and tem.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tem.cod_evento = te.cod_evento ' +
                '   and ttm.cod_tipo_morte = tem.cod_tipo_morte ' +
                '   and tcm.cod_causa_morte = tem.cod_causa_morte ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tf.cod_fazenda = ta.cod_fazenda_manejo ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov  ') +
                '   and te.cod_tipo_evento = 12 ' +
                ' order by 1, 3, 4 ');
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (Not DadosArquivo.ArquivoNovo) then begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end else begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then begin
          Exit;
        end;
      end else begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
      end;

      // Limpa mensagens de erro
      Result := LimparErros(DadosArquivo);

      if (not Conectado) and (Not DadosArquivo.ArquivoNovo) then begin
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de morte n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
        if Result < 0 then begin
          Exit;
        end;
      end;

      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.Active := true;

        INodeArquivo := XMLDoc.AddChild('ARQUIVO');
        INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
        INodeTemp.Text := DadosArquivo.CNPJCertificadora;
        INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
        INodeTemp.Text := 'MAN'; //VALOR FIXO

        INodeMortesAnimal := INodeArquivo.AddChild('MORTES_ANIMAL');
      except
        Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - MORTE ']);
        Result := -2278;
        Exit;
      end;

      Qtd1 := 0;

      While Not Q.Eof do begin
        RetornoSisbov := nil;

        // Consiste se evento est� efetivado
        if Q.FieldByName('ind_evento_efetivado').AsInteger <> 1 then begin
          if Not DadosArquivo.ArquivoNovo then begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
              ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
              Q.FieldByName('nom_pessoa').AsString + ' n�o est� identificado no SISBOV');
            if Result < 0 then begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                              Q.FieldByName('cod_evento').AsInteger,
                                              Q.FieldByName('cod_animal').AsInteger,
                                              DadosArquivo);
            if Result < 0 then begin
              Exit;
            end;

            // Posiciona no pr�ximo evento
            CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            CodTmp1 := Q.FieldByName('cod_evento').AsInteger;
            While ((Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp ) and
                   (Q.FieldByName('cod_evento').AsInteger = CodTmp1 )) and (Not Q.Eof) do begin
              Q.Next;
            end;
          end else begin
            Q.Next;
          end;
          Continue;
        end;

        // Consiste se o animal est� efetivado
        if Q.FieldByName('ind_animal_efetivado').AsInteger <> 1 then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
            ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
            Q.FieldByName('nom_pessoa').AsString + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi identificado no SISBOV');
          if Result < 0 then begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_evento').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                      DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Consiste se o animal j� foi exportado
        if Q.FieldByName('cod_arquivo_sisbov').IsNull then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
            ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
            Q.FieldByName('nom_pessoa').AsString + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi enviado para o SISBOV');
          if Result < 0 then begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_evento').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Marca registro como processado para este arquivo
        if DadosArquivo.ArquivoNovo then begin
          Result := AtualizaAnimalEvento(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                         Q.FieldByName('cod_evento').AsInteger,
                                         Q.FieldByName('cod_animal').AsInteger,
                                         DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;
        end;

        // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
        // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
        NRSISBOV := '';
        if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '-1' then begin
          NRSISBOV := NRSISBOV + '105' +
                      PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                      PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                      PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
        end else begin
          // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
          // com as novas implementa��es do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
            NRSISBOV := NRSISBOV + '105' +
                        PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                        '00' +
                        PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                        PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end else begin
            NRSISBOV := NRSISBOV + '105' +
                        PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                        PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                        PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                        PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end;
        end;

        try
          If (Conectado) and (Q.FieldByName('ind_transmissao_sisbov').AsString = '') then begin
              if UpperCase(Q.FieldByName('des_tipo_morte').AsString) = 'DESLIGAMENTO' then begin
                try
                  RetornoSisbov := SoapSisbov.informarDesligamentoAnimal(
                                       Descriptografar(ValorParametro(118))
                                     , Descriptografar(ValorParametro(119))
                                     , NRSISBOV
                                     , Q.FieldByName('cod_causa_morte_sisbov').AsInteger);
                except
                  on E: Exception do
                  begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir desligamento do animal (COD. SISBOV:' + NRSISBOV + ').');

                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
                end;

              end else begin
                try
                  RetornoSisbov := SoapSisbov.informarMorteAnimal(
                                       Descriptografar(ValorParametro(118))
                                     , Descriptografar(ValorParametro(119))
                                     , NRSISBOV
                                     , FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_inicio').AsDateTime)
                                     , StrToInt(Trim(Q.FieldByName('cod_tipo_morte_sisbov').AsString))
                                     , Q.FieldByName('cod_causa_morte_sisbov').AsInteger);
                except
                  on E: Exception do
                  begin
                    Result := InserirErro(DadosArquivo, 'Erro ao transmitir morte do animal (COD. SISBOV:' + NRSISBOV + ').');

                    if Result < 0 then begin
                      Exit;
                    end;
                  end;
                end;
              end;

            If RetornoSisbov <> nil then begin
              If RetornoSisbov.Status = 0 then begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                  Q2.SQL.Add('update tab_animal_evento ' +
                             '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                             ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                             ' and   cod_evento              = :cod_evento ' +
                             ' and   cod_animal              = :cod_animal ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_produtor').AsInteger  := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                Q2.ParamByName('cod_evento').AsInteger           := Q.FieldByName('cod_evento').AsInteger;
                Q2.ParamByName('cod_idtransacao').AsInteger      := RetornoSisbov.idTransacao;
                Q2.ParamByName('cod_animal').AsInteger           := Q.FieldByName('cod_animal').AsInteger;

                Q2.ExecSQL;

                Commit;

                Result := InserirErro(DadosArquivo, 'Erro ao transmitir evento de morte (COD. SISBOV:' + NRSISBOV + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoSisbov));

                if Result < 0 then begin
                  Exit;
                end;
              end else begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                  Q2.SQL.Add('update tab_animal_evento ' +
                             '   set ind_transmissao_sisbov = ''S'' ' +
                             '     , cod_id_transacao_sisbov = :cod_idtransacao ' +
                             ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                             ' and   cod_evento              = :cod_evento ' +
                             ' and   cod_animal              = :cod_animal ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_produtor').AsInteger  := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                Q2.ParamByName('cod_evento').AsInteger           := Q.FieldByName('cod_evento').AsInteger;
                Q2.ParamByName('cod_idtransacao').AsInteger      := RetornoSisbov.idTransacao;
                Q2.ParamByName('cod_animal').AsInteger           := Q.FieldByName('cod_animal').AsInteger;

                Q2.ExecSQL;

                Commit;
              end;
            end else begin
              Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do evento de morte (COD. SISBOV:' + NRSISBOV + ').');
            end;
          end;

          INodeMorteAnimal := INodeMortesAnimal.AddChild('MORTE_ANIMAL');
             INodeTemp := INodeMorteAnimal.AddChild('NR_SISBOV');
             INodeTemp.Text := NRSISBOV;
             INodeTemp := INodeMorteAnimal.AddChild('DT_MORTE');
             INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_inicio').AsDateTime);
             INodeTemp := INodeMorteAnimal.AddChild('TIPO_MORTE');
          if UpperCase(Q.FieldByName('des_tipo_morte').AsString) = 'DESLIGAMENTO' then begin
             INodeTemp.Text := 'DESL';
          end else begin
             INodeTemp.Text := Q.FieldByName('cod_tipo_morte_sisbov').AsString;
          end;
             INodeTemp := INodeMorteAnimal.AddChild('CAUSA_MORTE_SISBOV');
             INodeTemp.Text := IntToStr(Q.FieldByName('cod_causa_morte_sisbov').AsInteger);
             INodeTemp := INodeMorteAnimal.AddChild('CAUSA_MORTE');
             INodeTemp.Text := Q.FieldByName('des_causa_morte').AsString;
          Inc(Qtd1);
        except
          Result := InserirErro(DadosArquivo, 'Erro na gera��o/transmiss�o do evento de morte (COD. SISBOV:' + NRSISBOV + ').');
        end;

        Q.Next;
      end;

      XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

      // Grava��o do arquivo, cria arquivo ZIP
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;

      if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
        Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip]);
        Result := -2277;
        Exit;
      end;

      if (FecharZip(Zip, nil) < 0) then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoMortes := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogMOR) then begin
          CodArquivoMortes := -1;
        end;
        Result := -1;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    Q.Free;
    Q2.Free;
    SoapSisbov.Free;

    if ZipAberto then begin
      if (FecharZip(Zip, nil) < 0) then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
      end;
    end;
  end;
end;

{
function TIntInterfaceSisbov.PessoaProdutorDestinoVendaCriador(
  CodPessoaProdutor: Integer; var CodPessoaProdutorDestino: Integer;
  var NomPessoaProdutorDestino: String): Integer;
const
  NomeMetodo : String = 'PessoaProdutorDestinoVendaCriador';
var
  Q: THerdomQuery;
begin
  Result := 0;
  try
    Q := THerdomQuery.Create(Conexao, nil);
    try
      CodPessoaProdutorDestino := -1;
      NomPessoaProdutorDestino := '';

      Q.SQL.Clear;
      Q.SQL.Add('select tpr.cod_pessoa_produtor,');
      Q.SQL.Add('       tp.nom_pessoa');
      Q.SQL.Add('  from tab_produtor tpr,');
      Q.SQL.Add('       tab_pessoa tp');
      Q.SQL.Add(' where tpr.dta_fim_validade is null');
      Q.SQL.Add('   and tpr.cod_pessoa_produtor = tp.cod_pessoa');
      Q.SQL.Add('   and tp.dta_fim_validade is null');
      Q.SQL.Add('   and tp.cod_pessoa = :cod_pessoa');
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
      Q.Open;

      if not Q.IsEmpty then
      begin
        CodPessoaProdutorDestino := Q.FieldByName('cod_pessoa_produtor').AsInteger;
        NomPessoaProdutorDestino := Q.FieldByName('nom_pessoa').AsString;
      end;
    finally
      Q.Free;
    end;
  except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1695, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1695;
      Exit;
    end;
  end;
end;
}

function TIntInterfaceSisbov.GeraArquivoMOV(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoMOV';
  TipoArquivo: Integer = 4;
  //Quantidade de dias que ser� definido para a busca de dados na tabela tab_animal_evento data do evento
  QdteDiasBuscaTabelaAnimais:string = '7';
var
  Q, Q2 : THerdomQuery;
  IndMigrarAnimal, DesTipo, Prefixo: String;
  Zip : ZipFile;
  NumCnpjCpfFrigorifico, DesTipoEvento, CpfCnpjProdutorOrigem, RetornoErro, NRSisbov: string;
  CodEvento, CodTmp, CodTmp1, Qtd1 : Integer;
  CodIdPropriedadeDestino, CodPessoaProdutor, CodIdPropriedadeOrigem, CodEve, CodPess: Integer;
  Cod, StrNrSisBov, NumCPFOrigem, NumCNPJOrigem, NumCNPJDestino, NumCPFDestino, NumGTA: String;
  ZipAberto, InsereReg, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoInformarMovimentacao;
  XMLDoc: TXMLDocument;
  INodeDadosOrigem, INodeEvento, INodeTipoEvento, INodeArquivo, INodeMovimentacoes, INodeMovimentacao, INodeOrigem : IXMLNode;
  INodeDadosDestino, INodeDestino : IXMLNode;
  INodeFrigorificoDestino : IXMLNode;
  INodeCNPJCertTerceira, INodeGtas, INodeGta, INodeAnimais, INodeAnimal, INodeTemp : IXMLNode;
  CodAnimal, NrosSisbovMov, NrosSisbov: ArrayOf_xsd_string;
  LoopMov, I, A, J, K, CodTipoEvento, LoopCod, vCodProdutor, vCodEvento: Integer;
  NrosGta: Array_Of_GtaDTO;
  sl : TStringList;
  CodExportacaoOrigem, MovNErasEras, NumNIRFOrigem, NumINCRAOrigem, NirfIncraOrigem, DtaChegada, DtaSaida, DtaEmissaoGta, DtaValidadeGta : String;
  Teste : TStringList;

//  RetornoCDASisbov: RetornoConsultarDadosAnimal;
begin
  try
    Teste := TStringList.Create;

    InsereReg    := False;
    ZipAberto    := False;
//    CodEvento    := 0;
    CpfCnpjProdutorOrigem := '';
//    RetornoCDASisbov := nil;

//    RetornoSisbov := nil;
    Q := THerdomQuery.Create(Conexao, nil);
    Q2 := THerdomQuery.Create(Conexao, nil);
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Movimenta��o');

      // Obtem as informa��es para gera��o do arquivo
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        // Transfer�ncias
        //alteracao na pesquina por Antonio Druzo 30-03-2009
        Q.SQL.Add(' select  tet.cod_pessoa_produtor ' +
                  '     , tp.nom_pessoa ' +
                  '     , tet.cod_evento ' +
                  '     , ta.cod_animal  ' +
                  '     , tf.sgl_fazenda as sgl_fazenda_manejo ' +
                  '     , ta.cod_animal_manejo ' +
                  '     , te.dta_inicio       as dta_saida ' +
                  '     , te.dta_fim          as dta_chegada ' +
                  '     , tet.dta_emissao_gta as dta_emissao_gta ' +
                  '     , tet.dta_validade_gta as dta_validade_gta ' +
                  '     , tet.num_gta ' +
                  '     , tet.cod_serie_gta ' +
                  '     , tes.sgl_estado ' +
//                ---- Cod codigo exporta��o da propriedade de origem
                  '     , case when tet.ind_mov_naoeras_eras = ''S'' then ' +
                  '            case when tet.cod_localizacao_origem is null then ' +
                  '               (select top 1 tls112.cod_localizacao_sisbov from tab_fazenda tf112, tab_localizacao_sisbov tls112 ' +
                  '                 where tf112.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf112.cod_fazenda            = tet.cod_fazenda_origem ' +
                  '                   and tls112.cod_propriedade_rural = tf112.cod_propriedade_rural ' +
                  '                   and tls112.cod_pessoa_produtor   = tf112.cod_pessoa_produtor) ' +
                  '            else ' +
                  '               tet.cod_localizacao_origem ' +
                  '            end ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as codigo_exportacao_origem ' +
//                ---- Cod codigo exporta��o da propriedade de origem certificadora terceira
                  '     , case when tet.ind_mov_naoeras_eras = ''S'' then ' +
                  '            case when tet.cod_localizacao_origem is null then ' +
                  '               (select top 1 tls112.cod_exportacao_terceiro_sisbov from tab_fazenda tf112, tab_localizacao_sisbov tls112 ' +
                  '                 where tf112.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf112.cod_fazenda            = tet.cod_fazenda_origem ' +
                  '                   and tls112.cod_propriedade_rural = tf112.cod_propriedade_rural ' +
                  '                   and tls112.cod_pessoa_produtor   = tf112.cod_pessoa_produtor) ' +
                  '            else ' +
                  '               (select top 1 tls112.cod_exportacao_terceiro_sisbov from tab_localizacao_sisbov tls112 ' +
                  '                 where tls112.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tls112.cod_localizacao_sisbov = tet.cod_localizacao_origem) ' +
                  '            end ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as cod_exp_origem_cert_terceira ' +
//                ---- Cod NIRF/INCRA da propriedade de origem
                  '     , case when tet.ind_mov_naoeras_eras = ''S'' then ' +
                  '            case when tet.num_imovel_origem is null then ' +
                  '               (select top 1 tpr111.num_imovel_receita_federal from tab_fazenda tf111, tab_propriedade_rural tpr111 ' +
                  '                 where tf111.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf111.cod_fazenda            = tet.cod_fazenda_origem ' +
                  '                   and tpr111.cod_propriedade_rural = tf111.cod_propriedade_rural) ' +
                  '            else ' +
                  '               tet.num_imovel_origem ' +
                  '            end ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as nirf_propriedade_origem ' +
//                ---- Cod ID da propriedade de origem
                  '     , case when tet.cod_propriedade_origem is null then ' +
                  '            case when tet.cod_fazenda_origem is null then '''' ' +
                  '            else ' +
                  '               (select top 1 tpr11.cod_id_propriedade_sisbov from tab_fazenda tf11, tab_propriedade_rural tpr11 ' +
                  '                 where tf11.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf11.cod_fazenda            = tet.cod_fazenda_origem ' +
                  '                   and tpr11.cod_propriedade_rural = tf11.cod_propriedade_rural) ' +
                  '            end ' +
                  '       else ' +
                  '               (select top 1 tpr11.cod_id_propriedade_sisbov from tab_propriedade_rural tpr11 ' +
                  '                 where tpr11.cod_propriedade_rural = tet.cod_propriedade_origem) ' +
                  '       end as cod_id_propriedade_origem ' +
//                ---- Vistoria da propriedade de origem
                  '     , case when tet.cod_propriedade_origem is null then ' +
                  '            case when tet.cod_fazenda_origem is null then '''' ' +
                  '            else ' +
                  '               (select distinct ''S'' from tab_fazenda tf11, tab_vistoria_eras tve11 ' +
                  '                 where tf11.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf11.cod_fazenda            = tet.cod_fazenda_origem ' +
                  '                   and tve11.cod_propriedade_rural = tf11.cod_propriedade_rural) ' +
                  '            end ' +
                  '       else ' +
                  '               (select distinct ''S'' from tab_vistoria_eras tve11 ' +
                  '                 where tve11.cod_propriedade_rural = tet.cod_propriedade_origem) ' +
                  '       end as ind_vistoria_propriedade_origem ' +
//                ---- Cod ID da propriedade de destino
                  '     , case when tet.cod_propriedade_destino  is null then ' +
                  '            case when tet.cod_fazenda_destino is null then '''' ' +
                  '            else ' +
                  '               (select top 1 tpr12.cod_id_propriedade_sisbov from tab_fazenda tf12, tab_propriedade_rural tpr12 ' +
                  '                 where tf12.cod_pessoa_produtor    = tet.cod_pessoa_produtor ' +
                  '                   and tf12.cod_fazenda            = tet.cod_fazenda_destino ' +
                  '                   and tpr12.cod_propriedade_rural = tf12.cod_propriedade_rural) ' +
                  '            end ' +
                  '       else ' +
                  '               (select top 1 tpr12.cod_id_propriedade_sisbov from tab_propriedade_rural tpr12 ' +
                  '                 where tpr12.cod_propriedade_rural = tet.cod_propriedade_destino) ' +
                  '       end as cod_id_propriedade_destino ' +
//                ---- Nro CPF/CNPJ do produtor de origem
                  '     , (select top 1 tp13.num_cnpj_cpf from tab_pessoa tp13 ' +
                  '         where tp13.cod_pessoa = tet.cod_pessoa_produtor)  as num_cpf_cnpj_produtor_origem ' +
//                ---- Nro CPF/CNPJ do produtor de destino ' +
                  '     , case when tet.cod_localizacao_destino  is null then ' +
                  '            case when tet.cod_pessoa_destino  is null then '''' ' +
                  '            else ' +
                  '               (select top 1 tp14.num_cnpj_cpf from tab_pessoa tp14 ' +
                  '                 where tp14.cod_pessoa = tet.cod_pessoa_produtor) ' +
                  '            end ' +
                  '       else ' +
                  '               (select top 1 tp14.num_cnpj_cpf from tab_pessoa tp14, tab_localizacao_sisbov tls14 ' +
                  '                 where tls14.cod_propriedade_rural = tet.cod_propriedade_destino ' +
                  '                   and tls14.cod_localizacao_sisbov = tet.cod_localizacao_destino ' +
                  '                   and tp14.cod_pessoa              = tls14.cod_pessoa_produtor) ' +
                  '       end as num_cpf_cnpj_produtor_destino ' +
//                ----
//                  '     , '''' as cnpj_certificadora_destino ' +
                  '     , ta.cod_estado_sisbov ' +
                  '     , ta.cod_micro_regiao_sisbov ' +
                  '     , ta.cod_animal_sisbov ' +
                  '     , ta.num_dv_sisbov ' +
                  '     , case isnull(te.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_evento_efetivado ' +
                  '     , case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_animal_efetivado ' +
                  '     , ta.cod_arquivo_sisbov ' +
                  '     , te.cod_tipo_evento ' +
                  '     , tae.ind_transmissao_sisbov ' +
                  '     , tet.ind_mov_naoeras_eras ' +
                  '     , '''' as cod_export_propriedade_destino ' +
                  '     , '''' as cpf_cnpj_produtor_destino ' +
                  '     , '''' as ind_venda_certif_terceira ' +
                  '     , '''' as num_cnpj_cpf_frigorifico ' +
                  '     , tet.ind_migrar_animal_sisbov ' +
                  '     , '' Transfer�ncia '' as des_tipo_evento ' +
                  ' from  tab_evento te ' +
                  '     , tab_evento_transferencia tet ' +
//Antonio Druzo 30-03-2009
//'     , tab_animal_evento tae  WITH(INDEX=idx_04_tab_animal_evento)' +
//AND tae.dta_aplicacao_evento between GETDATE()-7 and GETDATE()
                  '     , tab_animal_evento tae  /*WITH(INDEX=idx_04_tab_animal_evento)*/' +
                  '     , tab_animal ta ' +
                  '     , tab_estado tes ' +
                  '     , tab_pessoa tp ' +
                  '     , tab_fazenda tf ' +
                  ' where tet.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tet.cod_evento = te.cod_evento ' +
                  '   and tet.cod_estado_gta *= tes.cod_estado ' +
                  '   and tet.cod_tipo_lugar_origem  in (1,2) ' +
                  '   and tet.cod_tipo_lugar_destino in (1,2) ' +
                  '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tae.cod_evento = te.cod_evento ' +
                  '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                  '   and ta.cod_animal = tae.cod_animal ' +
                  '   and ta.dta_fim_validade is null ' +
                  '   and te.dta_efetivacao_cadastro is not null ' +
                  '   and tae.cod_pessoa_produtor = tp.cod_pessoa ' +
                  '   and ta.cod_pessoa_produtor = tf.cod_pessoa_produtor ' +
                  '   and ta.cod_fazenda_manejo = tf.cod_fazenda ' +
                SE(DadosArquivo.ArquivoNovo,
                  '   and tae.cod_arquivo_sisbov is null ',
                  '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                  //Antonio Druzo 30-03-2009
                  '   AND tae.dta_aplicacao_evento between GETDATE()-'+QdteDiasBuscaTabelaAnimais+' and GETDATE() '+
                'union ' +

                  // Venda p/ criador (origem propriedade, destino propriedade)
                  'select tevc.cod_pessoa_produtor ' +
                  '     , tp.nom_pessoa ' +
                  '     , tevc.cod_evento ' +
                  '     , ta.cod_animal ' +
                  '     , tf.sgl_fazenda        as sgl_fazenda_manejo ' +
                  '     , ta.cod_animal_manejo ' +
                  '     , te.dta_inicio         as dta_saida ' +
                  '     , te.dta_fim            as dta_chegada ' +
                  '     , tevc.dta_emissao_gta  as dta_emissao_gta ' +
                  '     , tevc.dta_validade_gta as dta_validade_gta ' +
                  '     , tevc.num_gta ' +
                  '     , tevc.cod_serie_gta ' +
                  '     , tes.sgl_estado ' +
//                ---- Cod codigo exporta��o da propriedade de origem
                  '     , case when tevc.ind_mov_naoeras_eras = ''S'' then ' +
                  '          (select top 1 tls114.cod_localizacao_sisbov from tab_fazenda tf114, tab_localizacao_sisbov tls114 ' +
                  '            where tf114.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '              and tf114.cod_fazenda            = te.cod_fazenda ' +
                  '              and tls114.cod_propriedade_rural = tf114.cod_propriedade_rural ' +
                  '              and tls114.cod_pessoa_produtor   = tf114.cod_pessoa_produtor) ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as codigo_exportacao_origem ' +
//                ---- Cod codigo exporta��o da propriedade de origem certificadora terceira
                  '     , case when tevc.ind_mov_naoeras_eras = ''S'' then ' +
                  '          (select top 1 tls114.cod_exportacao_terceiro_sisbov from tab_fazenda tf114, tab_localizacao_sisbov tls114 ' +
                  '            where tf114.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '              and tf114.cod_fazenda            = te.cod_fazenda ' +
                  '              and tls114.cod_propriedade_rural = tf114.cod_propriedade_rural ' +
                  '              and tls114.cod_pessoa_produtor   = tf114.cod_pessoa_produtor) ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as cod_exp_origem_cert_terceira ' +
//                ---- Cod NIRF/INCRA da propriedade de origem
                  '     , case when tevc.ind_mov_naoeras_eras = ''S'' then ' +
                  '         (select top 1 tpr113.num_imovel_receita_federal from tab_fazenda tf113, tab_propriedade_rural tpr113 ' +
                  '           where tf113.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '             and tf113.cod_fazenda            = te.cod_fazenda ' +
                  '             and tpr113.cod_propriedade_rural = tf113.cod_propriedade_rural) ' +
                  '       else ' +
                  '            '''' ' +
                  '       end as nirf_propriedade_origem ' +
  //              ---- Cod ID da propriedade de origem
                  '     , (select top 1 tpr11.cod_id_propriedade_sisbov from tab_fazenda tf11, tab_propriedade_rural tpr11 ' +
                  '         where tf11.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '           and tf11.cod_fazenda            = te.cod_fazenda ' +
                  '           and tpr11.cod_propriedade_rural = tf11.cod_propriedade_rural) as cod_id_propriedade_origem ' +
  //              ---- Vistoria da propriedade de origem
                  '     , (select distinct ''S'' from tab_fazenda tf11, tab_vistoria_eras tve11 ' +
                  '         where tf11.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '           and tf11.cod_fazenda            = te.cod_fazenda ' +
                  '           and tve11.cod_propriedade_rural = tf11.cod_propriedade_rural) as ind_vistoria_propriedade_origem ' +
  //              ---- Cod ID da propriedade de destino
                  '     , case when tevc.cod_propriedade_rural  is null then ' +
                  '            case when tevc.cod_localizacao_sisbov is null then ' +
                  '                case when tevc.cod_exportacao_propriedade is null then ''''  ' +
                  '                else ' +
                  '                   tevc.cod_exportacao_propriedade ' +
                  '                end ' +
                  '            else ' +
                  '               (select top 1 tpr12.cod_id_propriedade_sisbov from tab_localizacao_sisbov tls12, tab_propriedade_rural tpr12 ' +
                  '                 where tls12.cod_localizacao_sisbov = tevc.cod_localizacao_sisbov ' +
                  '                   and tpr12.cod_propriedade_rural  = tls12.cod_propriedade_rural) ' +
                  '            end ' +
                  '       else ' +
                  '            (select top 1 tpr12.cod_id_propriedade_sisbov from tab_propriedade_rural tpr12 ' +
                  '              where tpr12.cod_propriedade_rural = tevc.cod_propriedade_rural) ' +
                  '       end as cod_id_propriedade_destino ' +
  //              ---- Nro CPF/CNPJ do produtor de origem
                  '     , (select top 1 tp13.num_cnpj_cpf from tab_pessoa tp13 ' +
                  '         where tp13.cod_pessoa = tevc.cod_pessoa_produtor)  as num_cpf_cnpj_produtor_origem ' +
  //              ---- Nro CPF/CNPJ do produtor de destino
                  '     , case when tevc.cod_pessoa  is null then ''''  ' +
                  '       else ' +
                  '               (select top 1 tp14.num_cnpj_cpf from tab_pessoa tp14 ' +
                  '                 where tp14.cod_pessoa = tevc.cod_pessoa) ' +
                  '       end as num_cpf_cnpj_produtor_destino ' +
  //              ----
//                  '     , '''' as cnpj_certificadora_destino ' +
                  '     , ta.cod_estado_sisbov ' +
                  '     , ta.cod_micro_regiao_sisbov ' +
                  '     , ta.cod_animal_sisbov ' +
                  '     , ta.num_dv_sisbov ' +
                  '     , case isnull(te.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_evento_efetivado ' +
                  '     , case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_animal_efetivado ' +
                  '     , ta.cod_arquivo_sisbov ' +
                  '     , te.cod_tipo_evento ' +
                  '     , tae.ind_transmissao_sisbov ' +
                  '     , tevc.ind_mov_naoeras_eras ' +
                  '     , tevc.cod_exportacao_propriedade as cod_export_propriedade_destino ' +
                  '     , tevc.num_cnpj_cpf_pessoa_secundaria as cpf_cnpj_produtor_destino ' +
                  '     , tevc.ind_venda_certif_terceira as ind_venda_certif_terceira ' +
                  '     , '''' as num_cnpj_cpf_frigorifico ' +
                  '     , ''N'' as ind_migrar_animal_sisbov ' +
                  '     , '' Venda para criador '' as des_tipo_evento ' +
                  '  from tab_evento te ' +
                  '     , tab_evento_venda_criador tevc ' +
      //Antonio Druzo 30-03-2009
//                  '     , tab_animal_evento tae WITH(INDEX=idx_03_tab_animal_evento)' +
                  '     , tab_animal_evento tae /*WITH(INDEX=idx_03_tab_animal_evento)*/' +
                  '     , tab_animal ta ' +
                  '     , tab_fazenda tf ' +
                  '     , tab_pessoa tp ' +
                  '     , tab_estado tes ' +
                  ' where tevc.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tevc.cod_evento = te.cod_evento ' +
                  '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tae.cod_evento = te.cod_evento ' +
                  '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                  '   and ta.cod_animal = tae.cod_animal ' +
                  '   and ta.dta_fim_validade is null ' +
                  '   and te.dta_efetivacao_cadastro is not null ' +
                  '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                  '   and tf.cod_fazenda = ta.cod_fazenda_manejo ' +
                  '   and tae.cod_tipo_lugar in (1,2) ' +
                  '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                  '   and tevc.cod_estado_gta *= tes.cod_estado  ' +
                  SE(DadosArquivo.ArquivoNovo,
                  '   and tae.cod_arquivo_sisbov is null ',
                  '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                  //Antonio Druzo 30-03-2009
                  '   AND tae.dta_aplicacao_evento between GETDATE()-'+QdteDiasBuscaTabelaAnimais+' and GETDATE() '+
                ' union ' +

                  // Venda p/ frigor�fico
                  'select tevf.cod_pessoa_produtor ' +
                  '     , tp.nom_pessoa ' +
                  '     , tevf.cod_evento ' +
                  '     , ta.cod_animal ' +
                  '     , tf.sgl_fazenda        as sgl_fazenda_manejo ' +
                  '     , ta.cod_animal_manejo ' +
                  '     , te.dta_inicio         as dta_saida ' +
                  '     , te.dta_fim            as dta_chegada ' +
                  '     , tevf.dta_emissao_gta  as dta_emissao_gta ' +
                  '     , tevf.dta_validade_gta as dta_validade_gta ' +
                  '     , tevf.num_gta ' +
                  '     , tevf.cod_serie_gta ' +
                  '     , tes.sgl_estado ' +
//                ---- Cod codigo exporta��o da propriedade de origem
                  '     , '''' as codigo_exportacao_origem ' +
//                ---- Cod codigo exporta��o da propriedade de origem certificadora terceira
                  '     , '''' as cod_exp_origem_cert_terceira ' +
//                ---- Cod NIRF/INCRA da propriedade de origem
                  '     , '''' as nirf_propriedade_origem ' +
  //           ---- Cod ID da propriedade de origem
                  '     , (select top 1 tpr11.cod_id_propriedade_sisbov from tab_fazenda tf11, tab_propriedade_rural tpr11 ' +
                  '         where tf11.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '           and tf11.cod_fazenda            = te.cod_fazenda ' +
                  '           and tpr11.cod_propriedade_rural = tf11.cod_propriedade_rural) ' +
                  '       as cod_id_propriedade_origem ' +
  //           ---- Vistoria da propriedade de origem
                  '     , (select distinct ''S'' from tab_fazenda tf11, tab_vistoria_eras tve11 ' +
                  '         where tf11.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                  '           and tf11.cod_fazenda            = te.cod_fazenda ' +
                  '           and tve11.cod_propriedade_rural = tf11.cod_propriedade_rural) ' +
                  '       as ind_vistoria_propriedade_origem ' +
  //                 ----
                  '     , 0 as cod_id_propriedade_destino ' +
  //                 ---- Nro CPF/CNPJ do produtor de origem ' +
                  '     , (select top 1 tp13.num_cnpj_cpf from tab_pessoa tp13 ' +
                  '         where tp13.cod_pessoa = tevf.cod_pessoa_produtor)  as num_cpf_cnpj_produtor_origem ' +
                  '     , '''' as num_cpf_cnpj_produtor_destino ' +
//                  '     , '''' as cnpj_certificadora_destino ' +
                  '     , ta.cod_estado_sisbov ' +
                  '     , ta.cod_micro_regiao_sisbov ' +
                  '     , ta.cod_animal_sisbov ' +
                  '     , ta.num_dv_sisbov ' +
                  '     , case isnull(te.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_evento_efetivado ' +
                  '     , case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                  '         when 0 then 0 ' +
                  '         else 1 ' +
                  '       end as ind_animal_efetivado ' +
                  '     , ta.cod_arquivo_sisbov ' +
                  '     , te.cod_tipo_evento ' +
                  '     , tae.ind_transmissao_sisbov ' +
                  '     , ''N'' as ind_mov_naoeras_eras ' +
                  '     , '''' as cod_export_propriedade_destino ' +
                  '     , '''' as cpf_cnpj_produtor_destino ' +
                  '     , '''' as ind_venda_certif_terceira ' +
                  '     , tevf.num_cnpj_cpf_frigorifico ' +
                  '     , ''N'' as ind_migrar_animal_sisbov ' +
                  '     , '' Venda para frigorifico '' as des_tipo_evento ' +
                  '  from tab_evento te ' +
                  '    ,  tab_evento_venda_frigorifico tevf ' +
                  //Antonio Druzo 30-03-2009
//                  '    ,  tab_animal_evento tae WITH(INDEX=idx_03_tab_animal_evento)' +
                  '    ,  tab_animal_evento tae /*WITH(INDEX=idx_03_tab_animal_evento)*/' +
                  '    ,  tab_animal ta ' +
                  '    ,  tab_fazenda tf ' +
                  '    ,  tab_pessoa tp ' +
                  '    ,  tab_estado tes ' +
                  ' where tevf.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tevf.cod_evento = te.cod_evento ' +
                  '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                  '   and tae.cod_evento = te.cod_evento ' +
                  '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                  '   and ta.cod_animal = tae.cod_animal ' +
                  '   and ta.dta_fim_validade is null ' +
                  '   and te.dta_efetivacao_cadastro is not null ' +
                  '   and tf.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                  '   and tf.cod_fazenda = tae.cod_fazenda_corrente ' +
                  '   and tae.cod_tipo_lugar in (1,2) ' +
                  '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                  '   and tevf.cod_estado_gta *= tes.cod_estado ' +
                  SE(DadosArquivo.ArquivoNovo,
                  '   and tae.cod_arquivo_sisbov is null ',
                  '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                  //Antonio Druzo 30-03-2009
                  '   AND tae.dta_aplicacao_evento between GETDATE()-'+QdteDiasBuscaTabelaAnimais+' and GETDATE() '+
                  ' order by 1,  ' +
                  '          3,  ' +
                  '          te.cod_tipo_evento, ' +
                  '          ta.cod_estado_sisbov, ' +
                  '          ta.cod_micro_regiao_sisbov, ' +
                  '          ta.cod_animal_sisbov, ' +
                  '          ta.num_dv_sisbov ' );
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;

      Teste.Text := Q.SQL.Text;
      Teste.SaveToFile('C:\Herdom\sql.txt');

      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then
      begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (not DadosArquivo.ArquivoNovo) then
        begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo,
            [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end
        else
        begin
          Result := -1;
        end;
        Exit;
      end;

      // Limpa mensagens de erro
      Result := LimparErros(DadosArquivo);

      if (not Conectado) and (not DadosArquivo.ArquivoNovo) then begin
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de eventos de movimenta��o n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
        if Result < 0 then begin
          Exit;
        end;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then
      begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then
        begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo,
          DesTipo, Prefixo);
        if Result < 0 then
        begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then
        begin
          Exit;
        end;
      end
      else
      begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo,
          DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.ZIP';
      end;

      //////////////////////////////////////////////////// Grava��o do arquivo

      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.Active := true;

        INodeArquivo := XMLDoc.AddChild('ARQUIVO');
        INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
        INodeTemp.Text := DadosArquivo.CNPJCertificadora;
        INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
        INodeTemp.Text := 'MOV'; //VALOR FIXO
        INodeMovimentacoes := INodeArquivo.AddChild('MOVIMENTACOES');
      except
        Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - MOVIMENTA��O ']);
        Result := -2278;
        Exit;
      end;

      Qtd1 := 0;
      CodPess := 0;
      CodEve  := 0;
      NumGTA  := '';

      while not Q.Eof do begin
//        RetornoCDASisbov := nil;
        RetornoSisbov := nil;

        RetornoErro := '';

        // Verifica se propriedade de destino j� foi exportada para o novo sisbov
        if ((Q.FieldByName('cod_id_propriedade_destino').AsInteger = 0) and
            (Q.FieldByName('ind_mov_naoeras_eras').AsString = 'S')      and
            (Q.FieldByName('ind_venda_certif_terceira').AsString <> 'S')) then begin

          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' +
            Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
            Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
            Q.FieldByName('nom_pessoa').AsString +
            ' n�o tem c�digo ID SISBOV na propriedade de destino.');
          if Result < 0 then
          begin
            Exit;
          end;

          Q.Next;
          if (Q.Eof) and (not InsereReg) then begin
            DeleteFile(DadosArquivo.NomArquivoZip);
          end;

          Continue;
        end;

        // Verifica se propriedade de origem j� foi exportada para o novo sisbov
//        if ((Q.FieldByName('cod_id_propriedade_origem').AsInteger = 0)   or
//            (Q.FieldByName('cod_id_propriedade_origem').AsInteger > 0) and
//            (Q.FieldByName('ind_vistoria_propriedade_origem').AsString <> 'S')) and
//            (Q.FieldByName('ind_mov_naoeras_eras').AsString <> 'S') and
//            (Q.FieldByName('cod_tipo_evento').AsInteger <> 36) then begin
//          Q.Next;
//          if (Q.Eof) and (not InsereReg) then begin
//            DeleteFile(DadosArquivo.NomArquivoZip);
//          end;
//          Continue;
//        end;

        // Consiste se evento est� efetivado
        if Q.FieldByName('ind_evento_efetivado').AsInteger <> 1 then
        begin
          if not DadosArquivo.ArquivoNovo then
          begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'O evento de ' +
              Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
              Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
              Q.FieldByName('nom_pessoa').AsString +
              ' n�o est� identificado no SISBOV');
            if Result < 0 then
            begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
              Q.FieldByName('cod_evento').AsInteger,
              Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
            if Result < 0 then
            begin
              Exit;
            end;

            // Posiciona no pr�ximo evento
            CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            CodTmp1 := Q.FieldByName('cod_evento').AsInteger;
            while ((Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp ) and
              (Q.FieldByName('cod_evento').AsInteger = CodTmp1 )) and
              (Not Q.Eof) do
            begin
              Q.Next;
            end;
          end
          else
          begin
            Q.Next;
          end;
          Continue;
        end;

        // Consiste se o animal est� efetivado
        if Q.FieldByName('ind_animal_efetivado').AsInteger <> 1 then
        begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' +
            Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
            Q.FieldByName('cod_evento').AsString + ' para animais do produtor '
            + Q.FieldByName('nom_pessoa').AsString
            + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' +
            Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi identificado no SISBOV');
          if Result < 0 then
          begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Consiste se o animal est� exportado
        if Q.FieldByName('cod_arquivo_sisbov').IsNull then
        begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' +
            Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
            Q.FieldByName('cod_evento').AsString + ' para animais do produtor '
            + Q.FieldByName('nom_pessoa').AsString
            + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' +
            Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi enviado para o SISBOV');
          if Result < 0 then
          begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Marca registro como processado para este arquivo
        if DadosArquivo.ArquivoNovo then
        begin
          Result := AtualizaAnimalEvento(
            Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;
        end;

        // Dispara impress�o de registro tipo 1
        if (CodPess <> Q.FieldByName('cod_pessoa_produtor').AsInteger) or
           ((CodEve <> Q.FieldByName('cod_evento').AsInteger) and
           ((NumGTA <> Q.FieldByName('num_gta').AsString) or (Q.FieldByName('num_gta').AsString = '9999999999'))) then
        begin
          CodPess := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          CodEve  := Q.FieldByName('cod_evento').AsInteger;
          NumGTA  := Q.FieldByName('num_gta').AsString;
          if (not DadosArquivo.ArquivoNovo) then begin
            CodArquivoMovimentacoes := DadosArquivo.CodArquivoSisbov;
          end;

          try
            INodeMovimentacao := INodeMovimentacoes.AddChild('MOVIMENTACAO');
              INodeEvento := INodeMovimentacao.AddChild('EVENTO');
                INodeTipoEvento := INodeEvento.AddChild('TIPO_EVENTO');
                  INodeTemp := INodeTipoEvento.AddChild('COD_PRODUTOR');
                  INodeTemp.Text := IntToStr(Q.FieldByName('cod_pessoa_produtor').AsInteger);
                  INodeTemp := INodeTipoEvento.AddChild('NOME_PRODUTOR_ORIGEM');
                  INodeTemp.Text := Q.FieldByName('nom_pessoa').AsString;
                  INodeTemp := INodeTipoEvento.AddChild('COD_EVENTO');
                  INodeTemp.Text := IntToStr(Q.FieldByName('cod_evento').AsInteger);
                  INodeTemp := INodeTipoEvento.AddChild('DESC_TIPO_EVENTO');
                  INodeTemp.Text := Q.FieldByName('des_tipo_evento').AsString;

              INodeOrigem := INodeMovimentacao.AddChild('ORIGEM');
                INodeDadosOrigem := INodeOrigem.AddChild('DADOS_ORIGEM');
                  INodeTemp := INodeDadosOrigem.AddChild('CPF_CNPJ_PRODUTOR_ORIGEM');
                  INodeTemp.Text := Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString;
                  INodeTemp := INodeDadosOrigem.AddChild('CODIGO_ID_PROPRIEDADE_ORIGEM');
                  INodeTemp.Text := IntToStr(Q.FieldByName('cod_id_propriedade_origem').AsInteger);

            Inc(Qtd1);
            INodeDestino := INodeMovimentacao.AddChild('DESTINO');
              INodeDadosDestino := INodeDestino.AddChild('DADOS_DESTINO');
                  INodeTemp := INodeDadosDestino.AddChild('CPF_CNPJ_PRODUTOR_DESTINO');
                  INodeTemp.Text := Q.FieldByName('num_cpf_cnpj_produtor_destino').AsString;
                  INodeTemp := INodeDadosDestino.AddChild('CODIGO_ID_PROPRIEDADE_DESTINO');
                  INodeTemp.Text := IntToStr(Q.FieldByName('cod_id_propriedade_destino').AsInteger);

              INodeFrigorificoDestino := INodeDestino.AddChild('FRIGORIFICO_DESTINO');
                INodeTemp := INodeFrigorificoDestino.AddChild('CNPJ_FRIGORIFICO_DESTINO');
                INodeTemp.Text := Q.FieldByName('num_cnpj_cpf_frigorifico').AsString;
//              INodeCNPJCertTerceira := INodeDestino.AddChild('FRIGORIFICO_DESTINO');
//                INodeTemp := INodeCNPJCertTerceira.AddChild('CNPJ_CERTIFICADORA_DESTINO');
//                INodeTemp.Text := Q.FieldByName('cnpj_certificadora_destino').AsString;

              INodeTemp := INodeMovimentacao.AddChild('DT_EMISSAO');
              INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_emissao_gta').AsDateTime);
              INodeTemp := INodeMovimentacao.AddChild('DT_SAIDA');
              INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_saida').AsDateTime);
              INodeTemp := INodeMovimentacao.AddChild('DT_CHEGADA');
              INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_chegada').AsDateTime);
              INodeTemp := INodeMovimentacao.AddChild('DT_VALIDADE_GTA');
              INodeTemp.Text := FormatDateTime('yyyy-mm-dd', Q.FieldByName('dta_validade_gta').AsDateTime);

              INodeGtas := INodeMovimentacao.AddChild('GTAS');
                INodeGta := INodeGtas.AddChild('GTA');
                  INodeTemp := INodeGta.AddChild('SG_UF_EMISSOR');
                  INodeTemp.Text := Q.FieldByName('sgl_estado').AsString;;
                  INodeTemp := INodeGta.AddChild('NR_SERIE');
                  INodeTemp.Text := Q.FieldByName('cod_serie_gta').AsString;
                  INodeTemp := INodeGta.AddChild('NR_GTA');
                  INodeTemp.Text := Q.FieldByName('num_gta').AsString;

              INodeAnimais := INodeMovimentacao.AddChild('ANIMAIS');
          except
             Result := InserirErro(DadosArquivo, 'Erro na montagem do arquivo XML de movimenta��o - ' + DesTipoEvento);
          end;
        end;

        INodeAnimal := INodeAnimais.AddChild('ANIMAL');

//        If (Conectado) and (Q.FieldByName('ind_transmissao_sisbov').AsString = '') then begin
        If Conectado then begin
          vCodProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          vCodEvento   := Q.FieldByName('cod_evento').AsInteger;
          I            := 0;
          A            := 0;

          if Length(Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString) = 11 then begin
            NumCPFOrigem  := Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString;
            NumCNPJOrigem := '';
          end else if Length(Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString) = 14 then begin
            NumCPFOrigem  := '';
            NumCNPJOrigem := Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString;
          end else begin
            NumCPFOrigem  := '';
            NumCNPJOrigem := '';
          end;

          if Length(Q.FieldByName('nirf_propriedade_origem').AsString) = 8 then begin
            NumNIRFOrigem  := Q.FieldByName('nirf_propriedade_origem').AsString;
            NumINCRAOrigem := '';
          end else if Length(Q.FieldByName('nirf_propriedade_origem').AsString) > 8 then begin
            NumNIRFOrigem  := '';
            NumINCRAOrigem := Q.FieldByName('nirf_propriedade_origem').AsString;
          end else begin
            NumNIRFOrigem  := '';
            NumINCRAOrigem := '';
          end;

          if Length(Q.FieldByName('num_cpf_cnpj_produtor_destino').AsString) = 11 then begin
            NumCPFDestino  := Q.FieldByName('num_cpf_cnpj_produtor_destino').AsString;
            NumCNPJDestino := '';
          end else if Length(Q.FieldByName('num_cpf_cnpj_produtor_destino').AsString) = 14 then begin
            NumCPFDestino  := '';
            NumCNPJDestino := Q.FieldByName('num_cpf_cnpj_produtor_destino').AsString;
          end else begin
            NumCPFDestino  := '';
            NumCNPJDestino := '';
          end;

          CodEvento               := Q.FieldByName('cod_evento').AsInteger;
          CpfCnpjProdutorOrigem   := Q.FieldByName('num_cpf_cnpj_produtor_origem').AsString;
          DesTipoEvento           := Q.FieldByName('des_tipo_evento').AsString;
          DtaValidadeGta          := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_validade_gta').AsDateTime);
          DtaEmissaoGta           := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_emissao_gta').AsDateTime);
          DtaSaida                := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_saida').AsDateTime);
          DtaChegada              := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_chegada').AsDateTime);
          CodIdPropriedadeOrigem  := Q.FieldByName('cod_id_propriedade_origem').AsInteger;
          CodIdPropriedadeDestino := Q.FieldByName('cod_id_propriedade_destino').AsInteger;
          NumCnpjCpfFrigorifico   := Q.FieldByName('num_cnpj_cpf_frigorifico').AsString;
          CodPessoaProdutor       := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          CodTipoEvento           := Q.FieldByName('cod_tipo_evento').AsInteger;

          // Para venda para produtor de outra certificadora no novo sisbov, pegar os dados do
          // produtor e ID da propriedade digitados pelo usu�rio.
          if Q.FieldByName('ind_venda_certif_terceira').AsString = 'S' then begin
            if Q.FieldByName('cod_export_propriedade_destino').IsNull then begin
              CodIdPropriedadeDestino := 0;
            end else begin
              CodIdPropriedadeDestino := Q.FieldByName('cod_export_propriedade_destino').AsInteger;
            end;

            if Length(Q.FieldByName('cpf_cnpj_produtor_destino').AsString) = 11 then begin
              NumCPFDestino  := Q.FieldByName('cpf_cnpj_produtor_destino').AsString;
              NumCNPJDestino := '';
            end else if Length(Q.FieldByName('cpf_cnpj_produtor_destino').AsString) = 14 then begin
              NumCPFDestino  := '';
              NumCNPJDestino := Q.FieldByName('cpf_cnpj_produtor_destino').AsString;
            end else begin
              NumCPFDestino  := '';
              NumCNPJDestino := '';
            end;
          end;

          if UpperCase(ValorParametro(111)) = 'S' then begin
            CodExportacaoOrigem := PadL(Q.FieldByName('codigo_exportacao_origem').AsString, '0', 10);
          end else begin
            CodExportacaoOrigem := Q.FieldByName('codigo_exportacao_origem').AsString
          end;

          if not Q.FieldByName('cod_exp_origem_cert_terceira').IsNull then begin
            CodExportacaoOrigem := Q.FieldByName('cod_exp_origem_cert_terceira').AsString
          end;

          MovNErasEras            := Q.FieldByName('ind_mov_naoeras_eras').AsString;
          IndMigrarAnimal         := Q.FieldByName('ind_migrar_animal_sisbov').AsString;

          SetLength(NrosGta, 1);
          SetLength(NrosSisbov, 0);
          SetLength(CodAnimal, 0);
          NrosGta[0]             := GtaDTO.Create;
          NrosGta[0].numeroGTA   := Q.FieldByName('num_gta').AsString;
          NrosGta[0].numeroSerie := Q.FieldByName('cod_serie_gta').AsString;
          NrosGta[0].uf          := Q.FieldByName('sgl_estado').AsString;

          // Trata vetor para envio do lote de animais para o SISBOV
          while (not Q.Eof) and (vCodProdutor = Q.FieldByName('cod_pessoa_produtor').AsInteger)
            and (vCodEvento = Q.FieldByName('cod_evento').AsInteger) do begin

            if (Q.FieldByName('ind_transmissao_sisbov').AsString <> 'S') or
               (CodTipoEvento = 10) or (IndMigrarAnimal = 'S') or (MovNErasEras = 'S') then begin

              // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
              // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
              if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then begin
                NRSisbov := '105' +
                PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
              end else begin
                // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
                // com as novas implementa��es do sisbov
                if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
                  NRSisbov := '105' +
                  PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                               '00' +
                               PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                               PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end else begin
                  NRSisbov := '105' +
                  PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                  PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                  PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                  PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end;
              end;

              SetLength(NrosSisbov, Length(NrosSisbov) + 1);
              SetLength(CodAnimal, Length(CodAnimal) + 1);
              NrosSisbov[A]  := NRSisbov;
              CodAnimal[A]   := IntToStr(Q.FieldByName('cod_animal').AsInteger);
              INodeTemp      := INodeAnimal.AddChild('NR_SISBOV');
              INodeTemp.Text := NrosSisbov[A];
              inc(A);

            end else begin
              // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
              // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
              if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then begin
                NRSisbov := '105' +
                PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
              end else begin
                // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
                // com as novas implementa��es do sisbov
                if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
                  NRSisbov := '105' +
                  PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                               '00' +
                               PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                               PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end else begin
                  NRSisbov := '105' +
                  PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                  PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                  PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                  PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
                end;
              end;

              INodeTemp := INodeAnimal.AddChild('NR_SISBOV');
              INodeTemp.Text := NRSisbov;
            end;

            inc(I);
            Q.Next;
          end;

          if A > 0 then begin
            if A-1 > 0 then begin
              INodeTemp.Text := NrosSisbov[A-1];
              NrosGta[0].qtdeAnimais := I;
            end else begin
              INodeTemp.Text := NrosSisbov[0];
              NrosGta[0].qtdeAnimais := 1;
            end;

            if CodTipoEvento = 10 then begin
              try

                // Funcao movimentarAnimalParaFrigorifico
                // Alterada 11/01/2009(conforme documentacao SISBOV)
                // Permance ainda a chamada para a funcao anterior a esta data.
                //

                LoopMov := 1;
                K := 0;
                repeat
                  J := 0;
                  SetLength(NrosSisbovMov, 1);

                  while (J <= 49) and (K < Length(NrosSisbov)) do begin
                    SetLength(NrosSisbovMov, Length(NrosSisbovMov) + 1);
                    NrosSisbovMov[J] := NrosSisbov[K];
                    inc(K);
                    inc(J);
                  end;

                  RetornoSisbov := SoapSisbov.movimentarAnimalParaFrigorifico(
                                           Descriptografar(ValorParametro(118))
                                         , Descriptografar(ValorParametro(119))
                                         , DtaValidadeGta
                                         , DtaEmissaoGta
                                         , DtaSaida
                                         , DtaChegada
                                         , CodIdPropriedadeOrigem
                                         , NumCnpjCpfFrigorifico
                                         , NumCPFOrigem
                                         , NumCNPJOrigem
                                         , NrosGta
                                         , NrosSisbovMov);
                until (LoopMov <= ceil((A)/50))
              except
                on E: Exception do
                begin
                  Result := InserirErro(DadosArquivo, 'Erro ao transmitir movimenta��o - ' + DesTipoEvento
                                        + ' - (Prod.: ' + CpfCnpjProdutorOrigem
                                        + ' - Evento: ' + IntToStr(CodEvento) + ')');

                  if Result < 0 then begin
                    Exit;
                  end;
                end;
              end;
            end else begin
              try
                if IndMigrarAnimal = 'S' then begin
                  RetornoSisbov := SoapSisbov.migrarAnimalNaoInventariado(
                                           Descriptografar(ValorParametro(118))
                                         , Descriptografar(ValorParametro(119))
                                         , CodExportacaoOrigem
                                         , NumNIRFOrigem
                                         , NumINCRAOrigem
                                         , NumCPFOrigem
                                         , NumCNPJOrigem
                                         , CodIdPropriedadeDestino
                                         , NumCPFDestino
                                         , NumCNPJDestino
                                         , 1
                                         , NrosSisbov);
                end else begin
                  if MovNErasEras <> 'S' then begin
                    if A > 50 then begin
                      LoopMov := 1;
                      K := 0;

                      while LoopMov <= ceil((A)/50) do begin
                        // Inicializa vetor auxiliar com os 50 c�digos sisbov para transmissao
                        SetLength(NrosSisbovMov, 1);
                        J := 0;

                        while (J <= 49) and (K < Length(NrosSisbov)) do begin
                          SetLength(NrosSisbovMov, Length(NrosSisbovMov) + 1);
                          NrosSisbovMov[J] := NrosSisbov[K];
                          inc(K);
                          inc(J);
                        end;

                        RetornoSisbov := SoapSisbov.movimentarAnimal(
                                               Descriptografar(ValorParametro(118))
                                             , Descriptografar(ValorParametro(119))
                                             , DtaValidadeGta
                                             , DtaEmissaoGta
                                             , DtaSaida
                                             , DtaChegada
                                             , CodIdPropriedadeOrigem
                                             , CodIdPropriedadeDestino
                                             , NumCPFOrigem
                                             , NumCNPJOrigem
                                             , NumCPFDestino
                                             , NumCNPJDestino
                                             , NrosGta
                                             , NrosSisbovMov);

                        If RetornoSisbov <> nil then begin
                          Q2.SQL.Clear;
                          {$IFDEF MSSQL}
                             Q2.SQL.Add('update tab_animal_evento ' +
                                           '   set cod_arquivo_sisbov       = :cod_arquivo_sisbov ' +
                                           ' where cod_pessoa_produtor      = :cod_pessoa_produtor ' +
                                           '  and  cod_evento               = :cod_evento ');
                          {$ENDIF}
                          Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                          Q2.ParamByName('cod_arquivo_sisbov').AsInteger   := DadosArquivo.CodArquivoSisbov;
                          Q2.ParamByName('cod_evento').AsInteger           := CodEvento;

                          BeginTran;
                          Q2.ExecSQL;
                          Commit;

                          If RetornoSisbov.Status = 0 then begin
                            J := (K-J);
                            while (J < Length(CodAnimal)) do begin
                              Q2.SQL.Clear;
                            {$IFDEF MSSQL}
                              Q2.SQL.Add('update tab_animal_evento ' +
                                            '   set cod_id_transacao_sisbov  = :cod_idtransacao ' +
                                            '     , ind_transmissao_sisbov   = ''E'' ' +
                                            ' where cod_pessoa_produtor      = :cod_pessoa_produtor ' +
                                            '  and  cod_evento               = :cod_evento ' +
                                            '  and  cod_animal               = :cod_animal ');
                            {$ENDIF}
                              Q2.ParamByName('cod_pessoa_produtor').AsInteger     := CodPessoaProdutor;
                              Q2.ParamByName('cod_idtransacao').AsInteger         := RetornoSisbov.idTransacao;
                              Q2.ParamByName('cod_evento').AsInteger              := CodEvento;
                              Q2.ParamByName('cod_animal').AsInteger              := StrToInt(CodAnimal[J]);

                              BeginTran;
                              Q2.ExecSQL;
                              Commit;

                              inc(J);
                            end;

                            // Verifica se o vetor de erros contem algum elemento
                            if RetornoSISBOV.listaErros <> nil then
                            begin
                              // Percorre os elementos do vetor
                              for I := 0 to Length(RetornoSISBOV.listaErros) - 1 do
                              begin
                                RetornoErro := '("' + RetornoSISBOV.listaErros[I].menssagemErro + '"';
                                // Verifica o vetor de erros do banco de dados do SISBOV
                                if RetornoSISBOV.listaErros[I].valorInformado <> nil then
                                begin
                                  // Percorre o vetor de erros do banco de dados do SISBOV
                                  for J := 0 to Length(RetornoSISBOV.listaErros[I].valorInformado) - 1 do
                                  begin
                                    RetornoErro := RetornoErro + ', "' + RetornoSISBOV.listaErros[I].valorInformado[J] + '"';
                                  end;
                                end;

                                RetornoErro := RetornoErro + ') ';

                                Result := InserirErro(DadosArquivo, 'Erro na transmiss�o movimenta��o - ' + DesTipoEvento
                                                        + ' - (Prod.: ' + CpfCnpjProdutorOrigem
                                                        + ' Evento: ' + IntToStr(CodEvento) +
                                                        '). <br>&nbsp;&nbsp;&nbsp;Msg Sisbov: ' + RetornoErro);

                                if Result < 0 then begin
                                  Exit;
                                end;

                                RetornoErro := '';
                              end;
                            end;
                          end else begin
                            J := (K-J);
                            while (J < Length(CodAnimal)) do begin
                              Q2.SQL.Clear;
                              {$IFDEF MSSQL}
                                 Q2.SQL.Add('update tab_animal_evento ' +
                                               '   set ind_transmissao_sisbov   = ''S'' ' +
                                               '     , cod_id_transacao_sisbov  = :cod_idtransacao ' +
                                               ' where cod_pessoa_produtor      = :cod_pessoa_produtor ' +
                                               '  and  cod_evento               = :cod_evento ' +
                                               '  and  cod_animal               = :cod_animal ');
                              {$ENDIF}
                              Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                              Q2.ParamByName('cod_idtransacao').AsInteger      := RetornoSisbov.idTransacao;
                              Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                              Q2.ParamByName('cod_animal').AsInteger           := StrToInt(CodAnimal[J]);

                              BeginTran;
                              Q2.ExecSQL;
                              Commit;

                              inc(J);
                            end;
                          end;

                          // Atualiza tabela de evento de transferencia com o Id de movimenta��o
                          // retornado do Sisbov.
                          if CodTipoEvento = 8 then begin
                            Q2.SQL.Clear;
                            {$IFDEF MSSQL}
                               Q2.SQL.Add('update tab_evento_transferencia ' +
                                             '   set cod_id_movimentacao_sisbov = :cod_idmovimentacao ' +
                                             ' where cod_pessoa_produtor        = :cod_pessoa_produtor ' +
                                             '  and  cod_evento                 = :cod_evento ');
                            {$ENDIF}
                            Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                            Q2.ParamByName('cod_idmovimentacao').AsInteger   := RetornoSisbov.chave;
                            Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                            BeginTran;
                            Q2.ExecSQL;
                            Commit;

                          // Atualiza tabela de evento venda para criador com o Id de movimenta��o
                          // retornado do Sisbov.
                          end else if CodTipoEvento = 9 then begin
                            Q2.SQL.Clear;
                            {$IFDEF MSSQL}
                               Q2.SQL.Add('update tab_evento_venda_criador ' +
                                             '   set cod_id_movimentacao_sisbov = :cod_idmovimentacao ' +
                                             ' where cod_pessoa_produtor        = :cod_pessoa_produtor ' +
                                             '  and  cod_evento                 = :cod_evento ');
                            {$ENDIF}
                            Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                            Q2.ParamByName('cod_idmovimentacao').AsInteger   := RetornoSisbov.chave;
                            Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                            BeginTran;
                            Q2.ExecSQL;
                            Commit;
                          end;
                        end;

                        Inc(LoopMov);
                      end;

                      // Volta no loop principal
                      continue;

                    end else begin
                      RetornoSisbov := SoapSisbov.movimentarAnimal(
                                             Descriptografar(ValorParametro(118))
                                           , Descriptografar(ValorParametro(119))
                                           , DtaValidadeGta
                                           , DtaEmissaoGta
                                           , DtaSaida
                                           , DtaChegada
                                           , CodIdPropriedadeOrigem
                                           , CodIdPropriedadeDestino
                                           , NumCPFOrigem
                                           , NumCNPJOrigem
                                           , NumCPFDestino
                                           , NumCNPJDestino
                                           , NrosGta
                                           , NrosSisbov);

                    end;
                  end else begin
                    RetornoSisbov := SoapSisbov.movimentarAnimalNaoErasPraEras(
                                           Descriptografar(ValorParametro(118))
                                         , Descriptografar(ValorParametro(119))
                                         , DtaValidadeGta
                                         , DtaEmissaoGta
                                         , DtaSaida
                                         , DtaChegada
                                         , CodExportacaoOrigem
                                         , NumNIRFOrigem
                                         , NumINCRAOrigem
                                         , CodIdPropriedadeDestino
                                         , NumCPFOrigem
                                         , NumCNPJOrigem
                                         , NumCPFDestino
                                         , NumCNPJDestino
                                         , NrosGta
                                         , NrosSisbov);
                  end;
                end;
              except
                on E: Exception do
                begin
                  Result := InserirErro(DadosArquivo, 'Erro ao transmitir evento de movimenta��o - ' + DesTipoEvento
                                        + ' - (Produtor: ' + CpfCnpjProdutorOrigem
                                        + ' - Evento: ' + IntToStr(CodEvento) + ')');

                  if Result < 0 then begin
                    Exit;
                  end;
                end;
              end;
            end;

            If RetornoSisbov <> nil then begin
              If RetornoSisbov.Status = 0 then begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                   Q2.SQL.Add('update tab_animal_evento ' +
                                 '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                                 '     , cod_arquivo_sisbov      = :cod_arquivo_sisbov ' +
                                 ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                                 '  and  cod_evento              = :cod_evento ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                Q2.ParamByName('cod_idtransacao').AsInteger      := RetornoSisbov.idTransacao;
                Q2.ParamByName('cod_arquivo_sisbov').AsInteger   := DadosArquivo.CodArquivoSisbov;
                Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                Q2.ExecSQL;

                Commit;

                // Verifica se o vetor de erros contem algum elemento
                if RetornoSISBOV.listaErros <> nil then
                begin
                  // Percorre os elementos do vetor
                  for I := 0 to Length(RetornoSISBOV.listaErros) - 1 do
                  begin
                    RetornoErro := '("' + RetornoSISBOV.listaErros[I].menssagemErro + '"';
                    // Verifica o vetor de erros do banco de dados do SISBOV
                    if RetornoSISBOV.listaErros[I].valorInformado <> nil then
                    begin
                      // Percorre o vetor de erros do banco de dados do SISBOV
                      for J := 0 to Length(RetornoSISBOV.listaErros[I].valorInformado) - 1 do
                      begin
                        RetornoErro := RetornoErro + ', "' + RetornoSISBOV.listaErros[I].valorInformado[J] + '"';
                      end;
                    end;

                    RetornoErro := RetornoErro + ') ';

                    Result := InserirErro(DadosArquivo, 'Erro na transmiss�o movimenta��o - ' + DesTipoEvento
                                            + ' - (Prod.: ' + CpfCnpjProdutorOrigem
                                            + ' Evento: ' + IntToStr(CodEvento) +
                                            '). <br>&nbsp;&nbsp;&nbsp;Msg Sisbov: ' + RetornoErro);

                    if Result < 0 then begin
                      Exit;
                    end;

                    RetornoErro := '';
                  end;
                end;
              end else begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                   Q2.SQL.Add('update tab_animal_evento ' +
                                 '   set ind_transmissao_sisbov = ''S'' ' +
                                 '     , cod_id_transacao_sisbov = :cod_idtransacao ' +
                                 '     , cod_arquivo_sisbov      = :cod_arquivo_sisbov ' +
                                 ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                                 '  and  cod_evento              = :cod_evento ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                Q2.ParamByName('cod_idtransacao').AsInteger      := RetornoSisbov.idTransacao;
                Q2.ParamByName('cod_arquivo_sisbov').AsInteger   := DadosArquivo.CodArquivoSisbov;
                Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                Q2.ExecSQL;

                // Atualiza tabela de evento venda para frigorifico com o Id de movimenta��o
                // retornado do Sisbov.
                if CodTipoEvento = 10 then begin
                  Q2.SQL.Clear;
                  {$IFDEF MSSQL}
                     Q2.SQL.Add('update tab_evento_venda_frigorifico ' +
                                   '   set cod_id_movimentacao_sisbov = :cod_idmovimentacao ' +
                                   ' where cod_pessoa_produtor        = :cod_pessoa_produtor ' +
                                   '  and  cod_evento                 = :cod_evento ');
                  {$ENDIF}
                  Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                  Q2.ParamByName('cod_idmovimentacao').AsInteger   := RetornoSisbov.chave;
                  Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                  Q2.ExecSQL;

                // Atualiza tabela de evento de transferencia com o Id de movimenta��o
                // retornado do Sisbov.
                end else if CodTipoEvento = 8 then begin
                  Q2.SQL.Clear;
                  {$IFDEF MSSQL}
                     Q2.SQL.Add('update tab_evento_transferencia ' +
                                   '   set cod_id_movimentacao_sisbov = :cod_idmovimentacao ' +
                                   ' where cod_pessoa_produtor        = :cod_pessoa_produtor ' +
                                   '  and  cod_evento                 = :cod_evento ');
                  {$ENDIF}
                  Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                  Q2.ParamByName('cod_idmovimentacao').AsInteger   := RetornoSisbov.chave;
                  Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                  Q2.ExecSQL;

                // Atualiza tabela de evento venda para criador com o Id de movimenta��o
                // retornado do Sisbov.
                end else if CodTipoEvento = 9 then begin
                  Q2.SQL.Clear;
                  {$IFDEF MSSQL}
                     Q2.SQL.Add('update tab_evento_venda_criador ' +
                                   '   set cod_id_movimentacao_sisbov = :cod_idmovimentacao ' +
                                   ' where cod_pessoa_produtor        = :cod_pessoa_produtor ' +
                                   '  and  cod_evento                 = :cod_evento ');
                  {$ENDIF}
                  Q2.ParamByName('cod_pessoa_produtor').AsInteger  := CodPessoaProdutor;
                  Q2.ParamByName('cod_idmovimentacao').AsInteger   := RetornoSisbov.chave;
                  Q2.ParamByName('cod_evento').AsInteger           := CodEvento;
                  Q2.ExecSQL;
                end;

                Commit;
              end;
            end else begin
              Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o de movimenta��o - ' + DesTipoEvento
                                       + ' - (Prod.: ' + CpfCnpjProdutorOrigem
                                       + ' Evento: ' + IntToStr(CodEvento) + '). Transmiss�o sem retorno do Sisbov.');

            end;
          end;
        end else begin
          // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
          // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then begin
            NRSisbov := '105' +
            PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
            PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
            PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end else begin
            // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
            // com as novas implementa��es do sisbov
            if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
              NRSisbov := '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                           '00' +
                           PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                           PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end else begin
              NRSisbov := '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
              PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
            end;
          end;

          INodeTemp := INodeAnimal.AddChild('NR_SISBOV');
          INodeTemp.Text := NRSisbov;
          Q.Next;
        end;

        InsereReg := True;
      end;

      XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

      // Cria arquivo
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;

      if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
        Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip]);
        Result := -2277;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoMovimentacoes := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogMOV) then begin
          CodArquivoMovimentacoes := -1;
        end;
        Result := -1;
      end;
    finally
      Q.Free;
      Q2.Free;
      SoapSisbov.Free;

      if ZipAberto then begin
        if FecharZip(Zip, nil) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(2394, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2394;
      Exit;
    end;
  end;
end;


{ *** Ver coment�rio na declara��o da fun��o.
function TIntInterfaceSisbov.GeraArquivoMOVAnt(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoMOVAnt';
  TipoArquivo: Integer = 4;
var
  Q : THerdomQuery;
  DesTipo, Prefixo: String;
  Zip : ZipFile;
  NomPessoaProdutorDestino: String;
  CodPessoaProdutorDestino, CodPropriedadeRuralDestino: Integer;
  CodTmp, CodTmp1, Qtd1, Qtd2, Qtd3 : Integer;
  CodEve, CodPess: Integer;
  CodLocI, CodLoc,
  NumGTA, Linha : String;
  CodArq: Integer;
  ZipAberto: boolean;
begin
  try
    ZipAberto := false;
    Q := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem as informa��es para gera��o do arquivo
      Q.SQL.Clear;
      {$IFDEF MSSQL
      // Transfer�ncias
      Q.SQL.Add('select tet.cod_pessoa_produtor, ' +
                '       tet.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       case  ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> ta.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '       case tet.cod_tipo_lugar_origem ' +
                '         when 1 then ''PROP'' ' +
                '         when 2 then ''PROP'' ' +
//                '         when 3 then ''AGL'' ' +
                '       end as cod_tipo_lugar_origem, ' +
                '       case tet.cod_tipo_lugar_origem ' +
                '         when 1 then tet.num_imovel_origem ' +
                '         when 2 then tet.num_imovel_origem ' +
//                '         when 3 then tet.num_cnpj_cpf_origem ' +
                '       end as id_origem, ' +
                '       tet.num_imovel_origem as nirf_origem, ' + // F�bio - 14/07/2004
                '       tpo.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '       case tet.cod_tipo_lugar_origem ' + // F�bio - 02/02/2005
                '         when 1 then tet.cod_pessoa_produtor ' + // F�bio - 02/02/2005
                '         when 2 then tet.cod_pessoa_origem ' + // F�bio - 02/02/2005
//                '         when 3 then tet.cod_pessoa_origem ' + // F�bio - 02/02/2005
                '       end as cod_pessoa_origem, ' + // F�bio - 02/02/2005
                '       te.dta_inicio, ' +
                '       te.dta_inicio as dta_saida, ' +
                '       te.dta_fim as dta_chegada, ' +
                '       case tet.cod_tipo_lugar_destino ' +
                '         when 1 then ''PROP'' ' +
                '         when 2 then ''PROP'' ' +
//                '         when 3 then ''AGL'' ' +
                '       end as cod_tipo_lugar_destino, ' +
                '       case tet.cod_tipo_lugar_destino ' +
                '         when 1 then tet.num_imovel_destino ' +
                '         when 2 then tet.num_imovel_destino ' +
//                '         when 3 then tet.num_cnpj_cpf_destino ' +
                '       end as id_destino, ' +
                '       tet.num_imovel_destino as nirf_destino, ' + // F�bio - 14/07/2004 
                '       tpd.cod_id_propriedade_sisbov as id_propriedade_destino, ' +
                '       case tet.cod_tipo_lugar_destino ' + // F�bio - 02/02/2005 
                '         when 1 then tet.cod_pessoa_produtor ' + // F�bio - 02/02/2005 
                '         when 2 then tet.cod_pessoa_destino ' + // F�bio - 02/02/2005 
//                '         when 3 then tet.cod_pessoa_destino ' + // F�bio - 02/02/2005 
                '       end as cod_pessoa_destino, ' + // F�bio - 02/02/2005
                '       tet.num_gta, ' +
                '       tet.cod_propriedade_origem, ' +
                '       tet.cod_propriedade_destino, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tf.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       te.cod_tipo_evento, ' +
                '       case tp.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       tet.num_cnpj_cpf_destino, ' +
                '       null as cod_natureza_pessoa_comprador, ' +
                '       null as num_cnpj_cpf_comprador, ' +
                '       null as ind_venda_certif_terceira, ' +
                '       null as cod_exportacao_propriedade ' +
                '  from tab_evento te, ' +
                '       tab_evento_transferencia tet ' +
                '          LEFT JOIN tab_fazenda tfd ' +
                '             ON tfd.cod_pessoa_produtor = tet.cod_pessoa_produtor ' +
                '            AND tfd.cod_fazenda = tet.cod_fazenda_destino ' +
                '          LEFT JOIN tab_propriedade_rural tpo ' +
                '             ON tpo.num_imovel_receita_federal = tet.num_imovel_origem ' +
                '          LEFT JOIN tab_propriedade_rural tpd ' +
                '             ON tpd.num_imovel_receita_federal = tet.num_imovel_destino, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tf ' +
                ' where tet.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tet.cod_evento = te.cod_evento ' +
                '   and tet.ind_mov_naoeras_eras <> ''S'' ' +
                '   and ((tet.cod_tipo_lugar_origem in (1, 2) and tet.cod_tipo_lugar_destino = 3) or ' +
                '        (tet.cod_tipo_lugar_origem = 3 and tet.cod_tipo_lugar_destino in (1, 2)) or ' +
                // Propriedade de terceiro
                '        ((tet.cod_tipo_lugar_origem = 2 and tet.cod_tipo_lugar_destino = 2) and ' +
                '         (not (tet.cod_propriedade_origem = tet.cod_propriedade_destino and ' +
                '          tet.cod_pessoa_origem = tet.cod_pessoa_destino))) or ' +
                // Fazenda do produtor
                '        ((tet.cod_tipo_lugar_origem = 1 and tet.cod_tipo_lugar_destino = 1) and ' +
                '         (tet.cod_fazenda_origem <> tet.cod_fazenda_destino)) or ' +
                // Tratamento para incluir no arquivo de exporta��o tranfer�ncias de Aglomera��o para Aglomera��o!
		            '        (tet.cod_tipo_lugar_origem = 3 and tet.cod_tipo_lugar_destino = 3 ' + { Daniel - 05/01/2005 
                '	    		and tet.num_cnpj_cpf_origem <> tet.num_cnpj_cpf_destino) ' + { Daniel - 05/01/2005 
                '         or (tet.cod_tipo_lugar_origem = 1 and tet.cod_tipo_lugar_destino = 2)) ' +
                '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tae.cod_animal ' +
                '   and ta.dta_fim_validade is null ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tf.cod_fazenda = ta.cod_fazenda_manejo ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                'union ' +
                // Venda p/ criador
                'select tevc.cod_pessoa_produtor, ' +
                '       tevc.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       case  ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> tae.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '       ''PROP'' as cod_tipo_lugar_origem, ' +
                '       tpr.num_imovel_receita_federal as id_origem, ' +
                '       tpr.num_imovel_receita_federal as nirf_origem, ' + { F�bio - 14/07/2004 
                '       tpr.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '       tevc.cod_pessoa_produtor as cod_pessoa_origem, ' + { F�bio - 02/02/2005 
                '       te.dta_inicio, ' +
                '       te.dta_inicio as dta_saida, ' +
                '       te.dta_fim as dta_chegada, ' +
                '       ''PROP'' as cod_tipo_lugar_destino, ' +
                '       tevc.num_imovel_receita_federal as id_destino, ' +
                '       tevc.num_imovel_receita_federal as nirf_destino , ' + { F�bio - 14/07/2004 
                '       tpd.cod_id_propriedade_sisbov as id_propriedade_destino, ' +
                '       tevc.cod_pessoa as cod_pessoa_destino, ' + { F�bio - 02/02/2005 
                '       tevc.num_gta, ' +
                '       tpr.cod_propriedade_rural as cod_propriedade_origem, ' +
                '       tevc.cod_propriedade_rural as cod_propriedade_destino, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tfm.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       te.cod_tipo_evento, ' +
                '       case tp.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       null as num_cnpj_cpf_destino, ' +
                '       case tpv.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa_comprador, ' +
                '       tpv.num_cnpj_cpf as num_cnpj_cpf_comprador, ' +
                '       null as ind_venda_certif_terceira, ' +
                '       null as cod_exportacao_propriedade ' +
                '  from tab_evento te, ' +
                '       tab_evento_venda_criador tevc, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_fazenda tf, ' +
                '       tab_propriedade_rural tpr, ' +
                '       tab_propriedade_rural tpd, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tfm, ' +
                '       tab_pessoa tpv ' +
                ' where tevc.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tevc.cod_evento = te.cod_evento ' +
                '   and tevc.ind_mov_naoeras_eras <> ''S'' ' +
                '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tae.cod_animal ' +
                '   and ta.dta_fim_validade is null ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tf.cod_fazenda = ta.cod_fazenda_corrente ' +
                '   and tpr.cod_propriedade_rural = tf.cod_propriedade_rural ' +
                '   and tae.cod_tipo_lugar in (1,2) ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and tfm.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tfm.cod_fazenda = ta.cod_fazenda_manejo ' +
                '   and tevc.cod_pessoa = tpv.cod_pessoa ' +
                '   and tpd.num_imovel_receita_federal =* tevc.num_imovel_receita_federal ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                ' union ' +
                ' select tevc.cod_pessoa_produtor, ' +
                '        tevc.cod_evento, ' +
                '        ta.cod_animal, ' +
                '       case  ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> tae.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '        ''PROP'' as cod_tipo_lugar_origem, ' +
                '        tpr.num_imovel_receita_federal as id_origem, ' +
                '        tpr.num_imovel_receita_federal as nirf_origem, ' +  { F�bio - 14/07/2004 
                '        tpr.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '        tevc.cod_pessoa_produtor as cod_pessoa_origem, ' +  { F�bio - 02/02/2005 
                '        te.dta_inicio, ' +
                '        te.dta_inicio as dta_saida, ' +
                '        te.dta_fim as dta_chegada, ' +
                '        ''PROP'' as cod_tipo_lugar_destino, ' +
                '        tevc.num_imovel_receita_federal as id_destino, ' +
                '        tevc.num_imovel_receita_federal as nirf_destino ,  ' + { F�bio - 14/07/2004 
                '        tpd.cod_id_propriedade_sisbov as id_propriedade_destino, ' +
                '        tevc.cod_pessoa as cod_pessoa_destino,  ' + { F�bio - 02/02/2005 
                '        tevc.num_gta, ' +
                '        tpr.cod_propriedade_rural as cod_propriedade_origem, ' +
                '        tevc.cod_propriedade_rural as cod_propriedade_destino, ' +
                '        ta.cod_estado_sisbov, ' +
                '        ta.cod_micro_regiao_sisbov, ' +
                '        ta.cod_animal_sisbov, ' +
                '        ta.num_dv_sisbov, ' +
                '        tte.des_tipo_evento, ' +
                '        tp.nom_pessoa, ' +
                '        case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '          when 0 then 0 ' +
                '        else ' +
                '          1 ' +
                '        end as ind_evento_efetivado, ' +
                '        case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '          when 0 then 0 ' +
                '        else ' +
                '          1 ' +
                '        end as ind_animal_efetivado, ' +
                '        ta.cod_arquivo_sisbov, ' +
                '        tfm.sgl_fazenda as sgl_fazenda_manejo, ' +
                '        ta.cod_animal_manejo, ' +
                '        te.cod_tipo_evento, ' +
                '        case tp.cod_natureza_pessoa ' +
                '                when ''F'' then ''PF'' ' +
                '                when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '        tp.num_cnpj_cpf, ' +
                '        null as num_cnpj_cpf_destino, ' +
                '	       case ' +
                '	          when (tpv.cod_natureza_pessoa is null and len(tevc.num_cnpj_cpf_pessoa_secundaria) = 11) then ''PF'' ' +
                '	          when (tpv.cod_natureza_pessoa is null and len(tevc.num_cnpj_cpf_pessoa_secundaria) = 14) then ''PJ'' ' +
                '	          when (tpv.cod_natureza_pessoa = ''F'') then ''PF'' ' +
                '     	    when (tpv.cod_natureza_pessoa = ''J'') then ''PJ'' ' +
                '      	 end as cod_natureza_pessoa_comprador, ' +
	              '        case when tpv.num_cnpj_cpf is null then tevc.num_cnpj_cpf_pessoa_secundaria ' +
                '       	  else tpv.num_cnpj_cpf ' +
	              '        end as num_cnpj_cpf_comprador, ' +
	              '        tevc.ind_venda_certif_terceira, ' +
	              '        tevc.cod_exportacao_propriedade ' +
                '   from tab_evento te, ' +
                '        tab_evento_venda_criador tevc, ' +
                '        tab_animal_evento tae, ' +
                '        tab_animal ta, ' +
                '        tab_propriedade_rural tpr, ' +
                '        tab_propriedade_rural tpd, ' +
                '        tab_tipo_evento tte, ' +
                '        tab_pessoa tp, ' +
                '        tab_fazenda tfm, ' +
                '        tab_pessoa tpv ' +
                '  where tevc.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '    and tevc.cod_evento = te.cod_evento ' +
                '    and tevc.ind_mov_naoeras_eras <> ''S'' ' +
                '    and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '    and tae.cod_evento = te.cod_evento ' +
                '    and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '    and ta.cod_animal = tae.cod_animal ' +
                '    and ta.dta_fim_validade is null ' +
                '    and te.dta_efetivacao_cadastro is not null ' +
                '    and tpr.cod_propriedade_rural = ta.cod_propriedade_corrente ' +
                '    and tae.cod_tipo_lugar in (1,2) ' +
                '    and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '    and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '    and tfm.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '    and tfm.cod_fazenda = ta.cod_fazenda_manejo ' +
                '    and tevc.cod_pessoa *= tpv.cod_pessoa ' +
                '    and tpd.num_imovel_receita_federal =* tevc.num_imovel_receita_federal ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                'union ' +
                'select tevc.cod_pessoa_produtor, ' +
                '       tevc.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       case ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> tae.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '       ''PROP'' as cod_tipo_lugar_origem, ' +
                '       tpr.num_imovel_receita_federal as id_origem, ' +
                '       tpr.num_imovel_receita_federal as nirf_origem, ' +  // F�bio - 14/07/2004
                '       tpr.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '       tevc.cod_pessoa_produtor as cod_pessoa_origem, ' +  // F�bio - 02/02/2005
                '       te.dta_inicio, ' +
                '       te.dta_inicio as dta_saida, ' +
                '       te.dta_fim as dta_chegada, ' +
                '       ''PROP'' as cod_tipo_lugar_destino, ' +
                '       tevc.num_imovel_receita_federal as id_destino, ' +
                '       tevc.num_imovel_receita_federal as nirf_destino , ' +  // F�bio - 14/07/2004
                '       tpd.cod_id_propriedade_sisbov as id_propriedade_destino, ' +
                '       tevc.cod_pessoa as cod_pessoa_destino, ' + // F�bio - 02/02/2005
                '       tevc.num_gta, ' +
                '       tpr.cod_propriedade_rural as cod_propriedade_origem, ' +
                '       null as cod_propriedade_destino, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tfm.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       te.cod_tipo_evento, ' +
                '       case tp.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       null as num_cnpj_cpf_destino, ' +
                '       case ' +
                '               when len(tevc.num_cnpj_cpf_pessoa_secundaria) = 11 then ''PF'' ' +
                '               when len(tevc.num_cnpj_cpf_pessoa_secundaria) = 14 then ''PJ'' end as cod_natureza_pessoa_comprador, ' +
                '       tevc.num_cnpj_cpf_pessoa_secundaria as num_cnpj_cpf_comprador, ' +
                '       tevc.ind_venda_certif_terceira, ' +
                '       tevc.cod_exportacao_propriedade ' +
                '  from tab_evento te, ' +
                '       tab_evento_venda_criador tevc, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_propriedade_rural tpr, ' +
                '       tab_propriedade_rural tpd, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tfm, ' +
                '       tab_fazenda tf ' +
                ' where tevc.cod_pessoa_produtor   = te.cod_pessoa_produtor ' +
                '   and tevc.cod_evento            = te.cod_evento ' +
                '   and tevc.ind_mov_naoeras_eras <> ''S'' ' +
                '   and tae.cod_pessoa_produtor    = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento             = te.cod_evento ' +
                '   and ta.cod_pessoa_produtor     = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal              = tae.cod_animal ' +
                '   and ta.dta_fim_validade        is null ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
	              '   and tae.cod_pessoa_produtor    = tf.cod_pessoa_produtor ' +
	              '   and tae.cod_fazenda_corrente   = tf.cod_fazenda ' +
	              '   and tf.cod_propriedade_rural   = tpr.cod_propriedade_rural ' +
//                '   and tpr.cod_propriedade_rural  = ta.cod_propriedade_corrente ' +
                '   and tae.cod_tipo_lugar         in (1,2) ' +
                '   and tp.cod_pessoa              = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento        = te.cod_tipo_evento ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and tfm.cod_pessoa_produtor    = ta.cod_pessoa_produtor ' +
                '   and tfm.cod_fazenda            = ta.cod_fazenda_manejo ' +
                '   and tpd.num_imovel_receita_federal =* tevc.num_imovel_receita_federal ' +
                '   and tevc.ind_venda_certif_terceira = ''S'' ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                'union ' +
                // Venda p/ frigor�fico
                'select tevf.cod_pessoa_produtor, ' +
                '       tevf.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       case  ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> tae.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '       ''PROP'' as cod_tipo_lugar_origem, ' +
                '       tpr.num_imovel_receita_federal as id_origem, ' +
                '       tpr.num_imovel_receita_federal as nirf_origem, ' + { F�bio - 15/07/2004 
                '       tpr.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '       tevf.cod_pessoa_produtor as cod_pessoa_origem, ' + { F�bio - 02/02/2005 
                '       te.dta_inicio, ' +
                '       te.dta_inicio as dta_saida, ' +
                '       te.dta_fim as dta_chegada, ' +
                '       ''FRIG'' as cod_tipo_lugar_destino, ' +
                '       tevf.num_cnpj_cpf_frigorifico as id_destino, ' +
                '       '''' as nirf_destino, ' + { F�bio - 15/07/2004 
                '       0 as id_propriedade_destino, ' +
                '       null as cod_pessoa_destino, ' + { F�bio - 02/02/2005 
                '       tevf.num_gta, ' +
                '       tpr.cod_propriedade_rural as cod_propriedade_origem, ' +
                '       null as cod_propriedade_destino, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tfm.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       te.cod_tipo_evento, ' +
                '       case tp.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       null as num_cnpj_cpf_destino, ' +
                '       null as cod_natureza_pessoa_comprador, ' +
                '       null as num_cnpj_cpf_comprador, ' +
                '       null as ind_venda_certif_terceira, ' +
                '       null as cod_exportacao_propriedade ' +
                '  from tab_evento te, ' +
                '       tab_evento_venda_frigorifico tevf, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_fazenda tf, ' +
                '       tab_propriedade_rural tpr, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tfm ' +
                ' where tevf.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tevf.cod_evento = te.cod_evento ' +
                '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tae.cod_animal ' +
                '   and ta.dta_fim_validade is null ' +
                '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tf.cod_fazenda = ta.cod_fazenda_corrente ' +
                '   and tpr.cod_propriedade_rural = tf.cod_propriedade_rural ' +
                '   and tae.cod_tipo_lugar in (1,2) ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and tfm.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tfm.cod_fazenda = ta.cod_fazenda_manejo ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                'union ' +
                'select tevf.cod_pessoa_produtor, ' +
                '       tevf.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       case  ' +
                '         when tae.cod_pessoa_corrente is null then tae.cod_pessoa_produtor ' +
                '         when tae.cod_pessoa_corrente <> tae.cod_pessoa_produtor then tae.cod_pessoa_corrente ' +
                '         else tae.cod_pessoa_corrente ' +
                '       end as cod_pessoa_corrente, ' +
                '       ''PROP'' as cod_tipo_lugar_origem, ' +
                '       tpr.num_imovel_receita_federal as id_origem, ' +
                '       tpr.num_imovel_receita_federal as nirf_origem, ' +  { F�bio - 15/07/2004 
                '       tpr.cod_id_propriedade_sisbov as id_propriedade_origem, ' +
                '       tevf.cod_pessoa_produtor as cod_pessoa_origem, ' +  { F�bio - 02/02/2005 
                '       te.dta_inicio, ' +
                '       te.dta_inicio as dta_saida, ' +
                '       te.dta_fim as dta_chegada, ' +
                '       ''FRIG'' as cod_tipo_lugar_destino, ' +
                '       tevf.num_cnpj_cpf_frigorifico as id_destino, ' +
                '       '''' as nirf_destino, ' +  { F�bio - 15/07/2004 
                '       0 as id_propriedade_destino, ' +
                '       null as cod_pessoa_destino, ' +  { F�bio - 02/02/2005 
                '       tevf.num_gta, ' +
                '       tpr.cod_propriedade_rural as cod_propriedade_origem, ' +
                '       null as cod_propriedade_destino, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tfm.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo, ' +
                '       te.cod_tipo_evento, ' +
                '       case tp.cod_natureza_pessoa ' +
                '               when ''F'' then ''PF'' ' +
                '               when ''J'' then ''PJ'' end as cod_natureza_pessoa, ' +
                '       tp.num_cnpj_cpf, ' +
                '       null as num_cnpj_cpf_destino, ' +
                '       null as cod_natureza_pessoa_comprador, ' +
                '       null as num_cnpj_cpf_comprador, ' +
                '       null as ind_venda_certif_terceira, ' +
                '       null as cod_exportacao_propriedade ' +                
                '  from tab_evento te, ' +
                '       tab_evento_venda_frigorifico tevf, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_propriedade_rural tpr, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tfm ' +
                ' where tevf.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tevf.cod_evento = te.cod_evento ' +
                '   and tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and te.dta_efetivacao_cadastro is not null ' +
                '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tae.cod_animal  ' +
                '   and ta.dta_fim_validade is null ' +
                '   and tpr.cod_propriedade_rural = ta.cod_propriedade_corrente ' +
                '   and tae.cod_tipo_lugar in (1,2) ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and tfm.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tfm.cod_fazenda = ta.cod_fazenda_manejo ' +
                SE(DadosArquivo.ArquivoNovo,
                '   and tae.cod_arquivo_sisbov is null ',
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ') +
                ' order by 1,  ' +
                '          11, ' +
                '          2,  ' +
                '          ta.cod_estado_sisbov, ' +
                '          ta.cod_micro_regiao_sisbov, ' +
                '          ta.cod_animal_sisbov, ' +
                '          ta.num_dv_sisbov ' );
      {$ENDIF

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then
      begin
        DadosArquivo.CodArquivoSisbov := -1;
      end
      else
      begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then
      begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (not DadosArquivo.ArquivoNovo) then
        begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo,
            [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end
        else
        begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then
      begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then
        begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo,
          DesTipo, Prefixo);
        if Result < 0 then
        begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.TXT';
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then
        begin
          Exit;
        end;
      end
      else
      begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo,
          DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.TXT';
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) +
          Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5))
          + '.ZIP';
      end;

      //////////////////////////////////////////////////// Grava��o do arquivo

      // Cria arquivo
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;


      if AbrirArquivoNoZip(Zip, ExtractFileName(DadosArquivo.NomArquivoSisbov)) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end;

      // Grava registro Tipo 0
      if GravarLinhaNoZip(Zip, '0' + DadosArquivo.CNPJCertificadora) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'grava��o']);
        Result := -1140;
        Exit;
      end;

      Qtd1 := 0;
      Qtd2 := 0;
      Qtd3 := 0;
      CodPess := 0;
      CodEve  := 0;
      NumGTA  := '';

      while not Q.Eof do
      begin
        CodPropriedadeRuralDestino := -1;
        CodPessoaProdutorDestino := -1;
        NomPessoaProdutorDestino := '';

        // Consiste se a propriedade de origem j� foi exportada para o novo sisbov
        if (Q.FieldByName('id_propriedade_origem').AsInteger > 0) or
           (Q.FieldByName('id_propriedade_destino').AsInteger > 0) then
        begin
          Q.Next;
          Continue;
        end;

        // Consiste se evento est� efetivado
        if Q.FieldByName('ind_evento_efetivado').AsInteger <> 1 then
        begin
          if not DadosArquivo.ArquivoNovo then
          begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'O evento de ' +
              Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
              Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
              Q.FieldByName('nom_pessoa').AsString +
              ' n�o est� identificado no SISBOV');
            if Result < 0 then
            begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
              Q.FieldByName('cod_evento').AsInteger,
              Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
            if Result < 0 then
            begin
              Exit;
            end;

            // Posiciona no pr�ximo evento
            CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            CodTmp1 := Q.FieldByName('cod_evento').AsInteger;
            while ((Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp ) and
              (Q.FieldByName('cod_evento').AsInteger = CodTmp1 )) and
              (Not Q.Eof) do
            begin
              Q.Next;
            end;
          end
          else
          begin
            Q.Next;
          end;
          Continue;
        end;

        // Consiste se o animal est� efetivado
        if Q.FieldByName('ind_animal_efetivado').AsInteger <> 1 then
        begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' +
            Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
            Q.FieldByName('cod_evento').AsString + ' para animais do produtor '
            + Q.FieldByName('nom_pessoa').AsString
            + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' +
            Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi identificado no SISBOV');
          if Result < 0 then
          begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Consiste se o animal est� exportado
        if Q.FieldByName('cod_arquivo_sisbov').IsNull then
        begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' +
            Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
            Q.FieldByName('cod_evento').AsString + ' para animais do produtor '
            + Q.FieldByName('nom_pessoa').AsString
            + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' +
            Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi enviado para o SISBOV');
          if Result < 0 then
          begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Verifica se propriedade de origem j� foi exportada
        if Q.FieldByName('cod_tipo_lugar_origem').AsString = 'PROP' then
        begin                                
          Result := CodLocalizacao(Q.FieldByName('cod_propriedade_origem').AsInteger,
            Q.FieldByName('cod_pessoa_origem').AsInteger, CodLocI, CodArq);
          if Result < 0 then
          begin
            Exit;
          end;

          if (CodLocI = '') or (CodArq < 0) then
          begin
            Result := CodLocalizacao(Q.FieldByName('cod_propriedade_origem').AsInteger,
              Q.FieldByName('cod_pessoa_corrente').AsInteger, CodLocI, CodArq);
            if Result < 0 then
            begin
              Exit;
            end;
          end;

          if (CodLocI = '') or (CodArq < 0) then
          begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'Evento ' +
              Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
              Q.FieldByName('cod_evento').AsString +
              ': A fazenda ou propriedade de origem do animal ' +
              Q.FieldByName('sgl_fazenda_manejo').AsString + '-'
              + Q.FieldByName('cod_animal_manejo').AsString +
              ' do produtor ' + Q.FieldByName('nom_pessoa').AsString +
              ' ainda n�o foi enviada para o SISBOV');
            if Result < 0 then
            begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(
              Q.FieldByName('cod_pessoa_produtor').AsInteger,
              Q.FieldByName('cod_evento').AsInteger,
              Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
            if Result < 0 then
            begin
              Exit;
            end;

            Q.Next;
            Continue;
          end;
        end;

        // Verifica se propriedade de destino j� foi exportada
        if Q.FieldByName('cod_tipo_lugar_destino').AsString = 'PROP' then
        begin
          case Q.FieldByName('cod_tipo_evento').AsInteger of
            9: // Evento venda para criador
            begin
              if (UpperCase(Q.FieldByName('ind_venda_certif_terceira').AsString) <> 'S') then
              begin
                CodPropriedadeRuralDestino :=
                  Q.FieldByName('cod_propriedade_destino').AsInteger;
                Result := PessoaProdutorDestinoVendaCriador(
                  Q.FieldByName('cod_pessoa_destino').AsInteger,
                  CodPessoaProdutorDestino,
                  NomPessoaProdutorDestino);
                if Result < 0 then
                begin
                  Exit;
                end;

                if CodPessoaProdutorDestino < 0 then
                begin
                  // Insere log de erro para o registro
                  Result := InserirErro(
                    DadosArquivo, 'Evento ' +
                    Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
                    Q.FieldByName('cod_evento').AsString +
                    ', produtor ' + Q.FieldByName('nom_pessoa').AsString +
                    ': N�o foi poss�vel identificar o produtor ' +
                    'de destino referente a pessoa criador associada ao ' +
                    'evento em quest�o');
                  if Result < 0 then
                  begin
                    Exit;
                  end;

                  // Marca registro como registro com log de erro
                  Result := AtualizaAnimalEventoLog(
                    Q.FieldByName('cod_pessoa_produtor').AsInteger,
                    Q.FieldByName('cod_evento').AsInteger,
                    Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
                  if Result < 0 then
                  begin
                    Exit;
                  end;

                  Q.Next;
                  Continue;
                end;
              end;
            end;
            8: // Transferencia
            begin
              if Q.FieldbyName('cod_pessoa_destino').IsNull
                and ((Q.FieldbyName('num_cnpj_cpf_destino').AsString <> '')
                or (not Q.FieldbyName('num_cnpj_cpf_destino').IsNull)) then
              begin
                with Query do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select cod_pessoa, nom_pessoa from tab_pessoa');
                  SQL.Add('where num_cnpj_cpf = :num_cnpj_cpf');
                  ParamByName('num_cnpj_cpf').AsString := Q.FieldbyName('num_cnpj_cpf_destino').AsString;
                  Open;

                  if IsEmpty then
                  begin
                    Result := InserirErro(DadosArquivo,
                      'Evento ' +
                      Q.FieldByName('des_tipo_evento').AsString +
                      ' com o c�digo ' + Q.FieldByName('cod_evento').AsString +
                      ', produtor ' + Q.FieldByName('nom_pessoa').AsString +
                      ':N�o foi encontrado nenhum produtor com o CNPJ/CPF: '
                      + Q.FieldbyName('num_cnpj_cpf_destino').AsString
                      + '. A opera��o n�o ser� realizada.');
                    if Result < 0 then
                    begin
                      Exit;
                    end;

                    // Marca registro como registro com log de erro
                    Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                      Q.FieldByName('cod_evento').AsInteger,
                      Q.FieldByName('cod_animal').AsInteger, DadosArquivo);

                    if Result < 0 then
                    begin
                      Exit;
                    end;
                    Q.Next;
                    Continue;
                  end;
                end;

                CodPropriedadeRuralDestino :=
                  Q.FieldByName('cod_propriedade_destino').AsInteger;
                CodPessoaProdutorDestino :=
                  Query.FieldByName('cod_pessoa').AsInteger;
                NomPessoaProdutorDestino :=
                  Query.FieldByName('nom_pessoa').AsString;
              end
              else
              begin
                CodPropriedadeRuralDestino :=
                  Q.FieldByName('cod_propriedade_destino').AsInteger;
                CodPessoaProdutorDestino :=
                  Q.FieldByName('cod_pessoa_destino').AsInteger;
                NomPessoaProdutorDestino :=
                  Q.FieldByName('nom_pessoa').AsString;
              end;
            end;
          else
            CodPropriedadeRuralDestino :=
              Q.FieldByName('cod_propriedade_destino').AsInteger;
            CodPessoaProdutorDestino := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            NomPessoaProdutorDestino := Q.FieldByName('nom_pessoa').AsString;
          end;

          if (UpperCase(Q.FieldByName('ind_venda_certif_terceira').AsString) <> 'S') then
          begin
            Result := CodLocalizacao(CodPropriedadeRuralDestino,
              CodPessoaProdutorDestino, CodLocI, CodArq);
            if Result < 0 then
            begin
              Exit;
            end;
          end
          else
          begin
            CodLocI := Q.FieldByName('cod_exportacao_propriedade').AsString;
            CodArq  := 0; // Atribu�do zero pois o c�digo de exporta��o da
                          // propriedade pertence a outra certificadora
          end;

          if (CodLocI = '') or (CodArq < 0) then
          begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'Evento ' +
              Q.FieldByName('des_tipo_evento').AsString + ' com o c�digo ' +
              Q.FieldByName('cod_evento').AsString +
              ', produtor ' + Q.FieldByName('nom_pessoa').AsString +
              'A fazenda ou propriedade de destino para o animal ' +
              Q.FieldByName('sgl_fazenda_manejo').AsString + '-' +
              Q.FieldByName('cod_animal_manejo').AsString +
              ' do produtor ' + NomPessoaProdutorDestino +
              ' ainda n�o foi enviada para o SISBOV');
            if Result < 0 then
            begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(
              Q.FieldByName('cod_pessoa_produtor').AsInteger,
              Q.FieldByName('cod_evento').AsInteger,
              Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
            if Result < 0 then
            begin
              Exit;
            end;

            Q.Next;
            Continue;
          end;
        end;

        // Marca registro como processado para este arquivo
        if DadosArquivo.ArquivoNovo then
        begin
          Result := AtualizaAnimalEvento(
            Q.FieldByName('cod_pessoa_produtor').AsInteger,
            Q.FieldByName('cod_evento').AsInteger,
            Q.FieldByName('cod_animal').AsInteger, DadosArquivo);
          if Result < 0 then
          begin
            Exit;
          end;
        end;

        // Dispara impress�o de registro tipo 1
        if (CodPess <> Q.FieldByName('cod_pessoa_produtor').AsInteger) or
           ((CodEve <> Q.FieldByName('cod_evento').AsInteger) and
           ((NumGTA <> Q.FieldByName('num_gta').AsString) or (Q.FieldByName('num_gta').AsString = '9999999999'))) then
        begin
          CodPess := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          CodEve  := Q.FieldByName('cod_evento').AsInteger;
          NumGTA  := Q.FieldByName('num_gta').AsString;

          Linha := '1';
          Linha := Linha + PadR(Q.FieldByName('cod_tipo_lugar_origem').AsString,
            ' ', 04);
          if Trim(UpperCase(Q.FieldByName('cod_tipo_lugar_origem').AsString)) <> 'PROP' then
          begin
            Linha := Linha + PadR('', ' ', 5);
            Linha := Linha + PadR(Q.FieldByName('id_origem').AsString, ' ', 23);
          end
          else
          begin
            Result := CodLocalizacao(Q.FieldByName('cod_propriedade_origem').AsInteger,
              Q.FieldByName('cod_pessoa_origem').AsInteger, CodLoc, CodArq);
            if Result < 0 then
            begin
              Exit;
            end;

            // Caso nao tenha encontrado o codigo localizacao sisbov pela pessoa
            // origem, busca o codigo pela pessoa corrente
            if (CodLoc = '') or (CodArq < 0) then
            begin
              Result := CodLocalizacao(Q.FieldByName('cod_propriedade_origem').AsInteger,
                Q.FieldByName('cod_pessoa_corrente').AsInteger, CodLoc, CodArq);
              if Result < 0 then
              begin
                Exit;
              end;
            end;

            if Length(Q.FieldByName('nirf_origem').AsString) = 8 then
            begin
              Linha := Linha + 'NIRF ';
              Linha := Linha + PadR(Copy(Q.FieldByName('id_origem').AsString,
                1, 8) + CodLoc, ' ', 23);
            end
            else
            begin
              Linha := Linha + 'INCRA';
              Linha := Linha + PadR(Copy(Q.FieldByName('id_origem').AsString,
                1, 13) + CodLoc, ' ', 23);
            end;
          end;
          Linha := Linha + PadR(FormatDateTime('ddmmyyyy',
            Q.FieldByName('dta_inicio').AsDateTime), ' ', 8);
          Linha := Linha + PadR(FormatDateTime('ddmmyyyy',
            Q.FieldByName('dta_saida').AsDateTime), ' ', 8);
          Linha := Linha + PadR(FormatDateTime('ddmmyyyy',
            Q.FieldByName('dta_chegada').AsDateTime), ' ', 8);
          Linha := Linha + PadR(
            Q.FieldByName('cod_tipo_lugar_destino').AsString, ' ', 04);
          if Trim(UpperCase(Q.FieldByName('cod_tipo_lugar_destino').AsString)) <> 'PROP' then
          begin
            Linha := Linha + PadR('', ' ', 5);
            Linha := Linha + PadR(Q.FieldByName('id_destino').AsString, ' ', 23);
          end
          else
          begin
            if (UpperCase(Q.FieldByName('ind_venda_certif_terceira').AsString) <> 'S') then
            begin
              Result := CodLocalizacao(CodPropriedadeRuralDestino,
                CodPessoaProdutorDestino, CodLoc, CodArq);
              if Result < 0 then
              begin
                Exit;
              end;
            end
            else
            begin
              CodLoc := Q.FieldByName('cod_exportacao_propriedade').AsString;
              CodArq := 0;
            end;

            if Length(Q.FieldByName('nirf_destino').AsString) = 8 then
            begin
              Linha := Linha + 'NIRF ';
              Linha := Linha + PadR(Copy(Q.FieldByName('id_destino').AsString,
                1, 8) + CodLoc, ' ', 23);
            end
            else
            begin
              Linha := Linha + 'INCRA';
              Linha := Linha + PadR(Copy(Q.FieldByName('id_destino').AsString,
                1, 13) + CodLoc, ' ', 23);
            end;
          end;
          if GravarLinhaNoZip(Zip, Linha) < 0 then
          begin
            Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
              [DadosArquivo.NomArquivoZip, 'grava��o']);
            Result := -1140;
            Exit;
          end;
          Inc(Qtd1);

          Linha := '2';
          Linha := Linha + PadR(Q.FieldByName('num_gta').AsString, ' ', 10);
          if GravarLinhaNoZip(Zip, Linha) < 0 then
          begin
            Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
              [DadosArquivo.NomArquivoZip, 'grava��o']);
            Result := -1140;
            Exit;
          end;
          Inc(Qtd2);
        end;

        Linha := '3';

        // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
        // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
        if Q.FieldByName('cod_micro_regiao_sisbov').AsInteger = -1 then
        begin
          Linha := Linha + '105' +
            PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
            PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
            PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
        end
        else
        begin
          // Se o codigo micro regi�o sisbov for igual 0, muda para 00. De acordo
          // com as novas implementa��es do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then
          begin
            Linha := Linha + '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
              '00' +
              PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
              PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end
          else
          begin
            Linha := Linha + '105' +
              PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
              PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
              PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end;
        end;

        if (Q.FieldByName('cod_tipo_evento').AsInteger = 9) then
        begin
          //Verifica o tipo do proprietario (PF ou PJ) e o informa no arquivo
          if (Q.FieldByName('cod_natureza_pessoa_comprador').AsString = 'PF') then
          begin
            Linha := Linha + 'PF';
          end
          else
          begin
            Linha := Linha + 'PJ';
          end;
          //Informa o CNPJ/CPF do propriet�rio.
          Linha := Linha + PadL(Q.FieldByName('num_cnpj_cpf_comprador').AsString, '0', 14);
        end
        else
        begin
          //Verifica o tipo do proprietario (PF ou PJ) e o informa no arquivo
          if (Q.FieldByName('cod_natureza_pessoa').AsString = 'PF') then
          begin
            Linha := Linha + 'PF';
          end
          else
          begin
            Linha := Linha + 'PJ';
          end;
          //Informa o CNPJ/CPF do propriet�rio.
          Linha := Linha + PadL(Q.FieldByName('num_cnpj_cpf').AsString, '0', 14);
        end;

        if GravarLinhaNoZip(Zip, Linha) < 0 then
        begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
            [DadosArquivo.NomArquivoZip, 'grava��o']);
          Result := -1140;
          Exit;
        end;
        Inc(Qtd3);

        Q.Next;
      end;

      // Grava registro Tipo 9
      if GravarLinhaNoZip(Zip, '91' + StrZero(Qtd1, 6) + '2' + StrZero(Qtd2, 6)
        + '3' + StrZero(Qtd3, 6)) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'grava��o']);
        Result := -1140;
        Exit;
      end;

      if FecharArquivoNoZip(Zip) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'fechamento']);
        Result := -1140;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then
      begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo,
          [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoMovimentacoes := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then
      begin
        Result := 0;
      end
      else
      begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogMOV) then
        begin
          CodArquivoMovimentacoes := -1;
        end;
        Result := -1;
      end;
    finally
      Q.Free;

      if ZipAberto then begin
        if FecharZip(Zip, nil) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1087;
      Exit;
    end;
  end;
end;
}
{ //Ver coment�rio na declara��o da fun��o!
function TIntInterfaceSisbov.GeraArquivoCER(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoCER';
  TipoArquivo: Integer = 5;
var
  Q : THerdomQuery;
  X : Integer;
  DesTipo, Prefixo: String;
  Zip : ZipFile;
  Qtd1 : Integer;
  Linha : String;
  CodTmp, CodTmp1: Integer;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try


    try
      // Obtem as informa��es para gera��o do arquivo
      Q.SQL.Clear;
      {$IFDEF MSSQL}
{      Q.SQL.Add('select te.cod_pessoa_produtor, ' +
                '       te.cod_evento, ' +
                '       ta.cod_animal, ' +
                '       ta.cod_estado_sisbov, ' +
                '       ta.cod_micro_regiao_sisbov, ' +
                '       ta.cod_animal_sisbov, ' +
                '       ta.num_dv_sisbov, ' +
                '       te.dta_inicio, ' +

                '       tte.des_tipo_evento, ' +
                '       tp.nom_pessoa, ' +
                '       case isnull(te.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_evento_efetivado, ' +
                '       case isnull(ta.dta_efetivacao_cadastro, 0) ' +
                '         when 0 then 0 ' +
                '       else ' +
                '         1 ' +
                '       end as ind_animal_efetivado, ' +
                '       ta.cod_arquivo_sisbov, ' +
                '       tf.sgl_fazenda as sgl_fazenda_manejo, ' +
                '       ta.cod_animal_manejo ' +
                '  from tab_evento te, ' +
                '       tab_animal_evento tae, ' +
                '       tab_animal ta, ' +
                '       tab_tipo_evento tte, ' +
                '       tab_pessoa tp, ' +
                '       tab_fazenda tf ' +
                ' where tae.cod_pessoa_produtor = te.cod_pessoa_produtor ' +
                '   and tae.cod_evento = te.cod_evento ' +
                '   and ta.cod_pessoa_produtor = tae.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tae.cod_animal ' +
                '   and ta.dta_fim_validade is null ' +
                '   and tp.cod_pessoa = te.cod_pessoa_produtor ' +
                '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                '   and tf.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tf.cod_fazenda = ta.cod_fazenda_manejo ' +
                '   and tae.cod_arquivo_sisbov = :cod_arquivo_sisbov ' +
                '   and te.cod_tipo_evento = 16 ' +
                ' order by 1, 2');
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
{      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
        Q.ParamByName('cod_arquivo_sisbov').DataType := ftInteger;
        Q.ParamByName('cod_arquivo_sisbov').Clear;
      end else begin
        Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      end;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (Not DadosArquivo.ArquivoNovo) then begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end else begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := DadosArquivo.Caminho + Prefixo + '_' + StrZero(DadosArquivo.CodArquivoSisbov, 5) + '.TXT';
        DadosArquivo.NomArquivoZip    := DadosArquivo.Caminho + Prefixo + '_' + StrZero(DadosArquivo.CodArquivoSisbov, 5) + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then begin
          Exit;
        end;
      end else begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := DadosArquivo.Caminho + Prefixo + '_' + StrZero(DadosArquivo.CodArquivoSisbov, 5) + '.TXT';
        DadosArquivo.NomArquivoZip    := DadosArquivo.Caminho + Prefixo + '_' + StrZero(DadosArquivo.CodArquivoSisbov, 5) + '.ZIP';
      end;

      // Grava��o do arquivo

      // Cria arquivo
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end;
      if AbrirArquivoNoZip(Zip, ExtractFileName(DadosArquivo.NomArquivoSisbov)) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end;

      // Grava registro Tipo 0
      if GravarLinhaNoZip(Zip, '0' + DadosArquivo.CNPJCertificadora) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'grava��o']);
        Result := -1140;
        Exit;
      end;

      Qtd1 := 0;

      While Not Q.Eof do begin
        // Consiste se evento est� efetivado
        if Q.FieldByName('ind_evento_efetivado').AsInteger <> 1 then begin
          if Not DadosArquivo.ArquivoNovo then begin
            // Insere log de erro para o registro
            Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
              ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
              Q.FieldByName('nom_pessoa').AsString + ' n�o est� identificado no SISBOV');
            if Result < 0 then begin
              Exit;
            end;

            // Marca registro como registro com log de erro
            Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                              Q.FieldByName('cod_evento').AsInteger,
                                              Q.FieldByName('cod_animal').AsInteger,
                                              DadosArquivo);
            if Result < 0 then begin
              Exit;
            end;

            // Posiciona no pr�ximo evento
            CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
            CodTmp1 := Q.FieldByName('cod_evento').AsInteger;
            While ((Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp ) and
                   (Q.FieldByName('cod_evento').AsInteger = CodTmp1 )) and (Not Q.Eof) do begin
              Q.Next;
            end;
          end else begin
            Q.Next;
          end;
          Continue;
        end;

        // Consiste se o animal est� efetivado
        if Q.FieldByName('ind_animal_efetivado').AsInteger <> 1 then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
            ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
            Q.FieldByName('nom_pessoa').AsString + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi identificado no SISBOV');
          if Result < 0 then begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_evento').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Consiste se o animal j� foi exportado
        if Q.FieldByName('cod_arquivo_sisbov').IsNull then begin
          // Insere log de erro para o registro
          Result := InserirErro(DadosArquivo, 'O evento de ' + Q.FieldByName('des_tipo_evento').AsString +
            ' com o c�digo ' + Q.FieldByName('cod_evento').AsString + ' para animais do produtor ' +
            Q.FieldByName('nom_pessoa').AsString + ' est� associado ao animal ' +
            Q.FieldByName('sgl_fazenda_manejo').AsString + '-' + Q.FieldByName('cod_animal_manejo').AsString +
            ', por�m este animal ainda n�o foi enviado para o SISBOV');
          if Result < 0 then begin
            Exit;
          end;

          // Marca registro como registro com log de erro
          Result := AtualizaAnimalEventoLog(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                            Q.FieldByName('cod_evento').AsInteger,
                                            Q.FieldByName('cod_animal').AsInteger,
                                            DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;

          Q.Next;
          Continue;
        end;

        // Marca registro como gravado no SISBOV
        if DadosArquivo.ArquivoNovo then begin
          Result := AtualizaAnimalEvento(Q.FieldByName('cod_pessoa_produtor').AsInteger,
                                         Q.FieldByName('cod_evento').AsInteger,
                                         Q.FieldByName('cod_animal').AsInteger,
                                         DadosArquivo);
          if Result < 0 then begin
            Exit;
          end;
        end;

        // Dispara impress�o de registro tipo 1
        Linha := '1';
        // Se o codigo micro regi�o sisbov for igual -1, retira-se o codigo micro regiao
        // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
        if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '-1' then begin
          Linha := Linha + '105' +
                           PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                           PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                           PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
        end else begin
        // Se o codigo micro regi�o sisbov for igual 0, insere o codigo micro regiao = 00
        // e insere no in�cio o c�digo do pa�s, de acordo com as novas implementa��es do sisbov
          if Q.FieldByName('cod_micro_regiao_sisbov').AsString = '0' then begin
            Linha := Linha + '105' +
                             PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                             '00' +
                             PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                             PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end else begin
            Linha := Linha + '105' +
                             PadL(Q.FieldByName('cod_estado_sisbov').AsString, '0', 2) +
                             PadL(Q.FieldByName('cod_micro_regiao_sisbov').AsString, '0', 2) +
                             PadL(Q.FieldByName('cod_animal_sisbov').AsString, '0', 9) +
                             PadL(Q.FieldByName('num_dv_sisbov').AsString, '0', 1);
          end;
        end;
        Linha := Linha + PadR(FormatDateTime('ddmmyyyy', Q.FieldByName('dta_inicio').AsDateTime), ' ', 8);

        if GravarLinhaNoZip(Zip, Linha) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'grava��o']);
          Result := -1140;
          Exit;
        end;
        Inc(Qtd1);

        Q.Next;
      end;

      // Grava registro Tipo 9
      if GravarLinhaNoZip(Zip, '91' + StrZero(Qtd1, 6)) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'grava��o']);
        Result := -1140;
        Exit;
      end;

      if FecharArquivoNoZip(Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'fechamento']);
        Result := -1140;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end;

      CodArquivoCertificados := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogCER) then begin
          CodArquivoCertificados := -1;
        end;
        Result := -1;
      end;
    except
      On E: Exception do begin
        Rollback;
        DeleteFile(DadosArquivo.NomArquivoZip);
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;
}

function TIntInterfaceSisbov.GeraArquivoIPP(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoIPP';
  TipoArquivo: Integer = 7;
var
  Q, Q2, QU : THerdomQuery;
  TelefoneContato, CpfCnpjProp, DesTipo, Prefixo: String;
  Zip : ZipFile;
  Qtd1 : Integer;
  CodTmp: Integer;
  XMLDoc: TXMLDocument;
  INodeArquivo, INodeProdutores, INodeProdutor, INodeTemp : IXMLNode;
  ZipAberto, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoIProdutor: RetornoIncluirProdutor;
  RetornoIProprietario: RetornoIncluirProprietario;
begin
//  XMLDoc := nil;
//  RetornoIProdutor     := nil;
//  RetornoIProprietario := nil;
  ZipAberto            := false;

  Q := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  QU := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;

  try
    SoapSisbov.Inicializar(Conexao, Mensagens);

    Conectado := SoapSisbov.conectado('Produtores');

    QU.SQL.Clear;
    QU.SQL.Add('update tab_produtor ');
    QU.SQL.Add('  set cod_arquivo_sisbov = :cod_arquivo_sisbov ');
    QU.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');

    try

      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('exec spt_obtem_produtor_rural :cod_arquivo_sisbov');
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
      end;
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (Not DadosArquivo.ArquivoNovo) then begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end else begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then begin
          Exit;
        end;
      end else begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
      end;

      // Limpa mensagens de erro
      Result := LimparErros(DadosArquivo);

      if (not Conectado) and (Not DadosArquivo.ArquivoNovo) then begin
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de produtor n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
        if Result < 0 then begin
          Exit;
        end;
      end;

      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.Active := true;

        INodeArquivo := XMLDoc.AddChild('ARQUIVO');
        INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
        INodeTemp.Text := DadosArquivo.CNPJCertificadora;
        INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
        INodeTemp.Text := 'IPP'; //VALOR FIXO

        INodeProdutores := INodeArquivo.AddChild('PRODUTORES');
      except
        Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - PRODUTOR ']);
        Result := -2278;
        Exit;
      end;

      Qtd1 := 0;
      CpfCnpjProp := '';

      While Not Q.Eof do begin
        RetornoIProdutor     := nil;
        RetornoIProprietario := nil;

        // Consiste se produtor est� efetivado
        if Q.FieldByName('ind_produtor_efetivado').AsInteger = 0  then begin
          // Insere log de erro
          Result := InserirErro(DadosArquivo, 'A produtor n�o est� identificado (' + Q.FieldByName('nom_pessoa').AsString + ').');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona no pr�ximo produtor
          CodTmp := Q.FieldByName('cod_pessoa_produtor').AsInteger;
          While (Q.FieldByName('cod_pessoa_produtor').AsInteger = CodTmp) and (Not Q.Eof) do begin
            Q.Next;
          end;
          Continue;
        end;

        try
           // Transmite dados do proprietario
           If (Conectado) and (Q.FieldByName('cod_propriedade_rural').AsInteger > 0) and
                              (Q.FieldByName('ind_trans_sisbov_proprietario').AsString = '') then begin
             if Q.FieldByName('telefone_contato').AsString = '' then begin
               TelefoneContato  := '';//'N�o tem';
             end else begin
               TelefoneContato  := Q.FieldByName('telefone_contato').AsString;
             end;

             try
               RetornoIProprietario := SoapSisbov.incluirProprietario(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('razao_social').AsString
                                 , Q.FieldByName('cnpj_pessoa').AsString
                                 , Q.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q.FieldByName('email_contato').AsString
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('sexo_pessoa').AsString
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('cod_municipio').AsString);
             except
               on E: Exception do
               begin
                 Result := InserirErro(DadosArquivo, 'Erro ao transmitir propriet�rio (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');

                 if Result < 0 then begin
                   Exit;
                 end;
               end;
             end;

             If RetornoIProprietario <> nil then begin
               If (RetornoIProprietario.Status = 0) and (RetornoIProprietario.listaErros[0].codigoErro <> '3.019') then begin
                 Result := InserirErro(DadosArquivo, 'Erro ao transmitir o propriet�rio (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoIProprietario));

                 if Result < 0 then begin
                   Exit;
                 end;
               end else begin
                 Q2.SQL.Clear;
                 {$IFDEF MSSQL}
                    Q2.SQL.Add('update tab_propriedade_rural ' +
                               '   set ind_trans_sisbov_proprietario = ''S'' ' +
                               ' where cod_propriedade_rural    = :cod_propriedade_rural ');
                 {$ENDIF}
                 Q2.ParamByName('cod_propriedade_rural').AsInteger    := Q.FieldByName('cod_propriedade_rural').AsInteger;

                 Q2.ExecSQL;
               end;
             end else begin
               Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do propriet�rio (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');
             end;
           end;

           // Transmite dados do produtor
           If (Conectado) and (Q.FieldByName('ind_transmissao_sisbov').AsString = '') and
                              (Q.FieldByName('cod_propriedade_rural').AsInteger = 0) then begin
             if Q.FieldByName('telefone_contato').AsString = '' then begin
               TelefoneContato  := '';//'N�o tem';
             end else begin
               TelefoneContato  := Q.FieldByName('telefone_contato').AsString;
             end;

             try
               RetornoIProdutor := SoapSisbov.incluirProdutor(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('razao_social').AsString
                                 , Q.FieldByName('cnpj_pessoa').AsString
                                 , Q.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q.FieldByName('email_contato').AsString
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('sexo_pessoa').AsString
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('cod_municipio').AsString
                                 , TelefoneContato
                                 , ''
                                 , TelefoneContato
                                 , '' );
             except
               on E: Exception do
               begin
                 Result := InserirErro(DadosArquivo, 'Erro ao transmitir produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');

                 if Result < 0 then begin
                   Exit;
                 end;
               end;
             end;

             If RetornoIProdutor <> nil then begin
               If (RetornoIProdutor.Status = 0) and (RetornoIProdutor.listaErros[0].codigoErro <> '8.019') then begin
                 BeginTran;

                 Q2.SQL.Clear;
                 {$IFDEF MSSQL}
                    Q2.SQL.Add('update tab_produtor ' +
                               '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                               ' where cod_pessoa_produtor     = :cod_pessoa_produtor ');
                 {$ENDIF}
                 Q2.ParamByName('cod_pessoa_produtor').AsInteger    := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                 Q2.ParamByName('cod_idtransacao').AsInteger        := RetornoIProdutor.idTransacao;
                 Q2.ExecSQL;

                 Commit;

                 Result := InserirErro(DadosArquivo, 'Erro ao transmitir o produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoIProdutor));

                 if Result < 0 then begin
                   Exit;
                 end;
               end else begin
                 BeginTran;

                 Q2.SQL.Clear;
                 {$IFDEF MSSQL}
                    Q2.SQL.Add('update tab_produtor ' +
                               '   set ind_transmissao_sisbov = ''S'' ' +
                               '     , cod_id_transacao_sisbov = :cod_idtransacao ' +
                               ' where cod_pessoa_produtor     = :cod_pessoa_produtor ');
                 {$ENDIF}
                 Q2.ParamByName('cod_pessoa_produtor').AsInteger    := Q.FieldByName('cod_pessoa_produtor').AsInteger;
                 Q2.ParamByName('cod_idtransacao').AsInteger        := RetornoIProdutor.idTransacao;
                 Q2.ExecSQL;

                 Commit;
               end;
             end else begin
               Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');
             end;
           end;

           INodeProdutor := INodeProdutores.AddChild('PRODUTOR');
                INodeTemp := INodeProdutor.AddChild('TIPO_PRODUTOR');
                INodeTemp.Text := Q.FieldByName('tipo_proprietario').AsString;
                INodeTemp := INodeProdutor.AddChild('CPF_CNPJ');
                INodeTemp.Text := Q.FieldByName('num_cnpj_cpf').AsString;
                INodeTemp := INodeProdutor.AddChild('RAZAO_SOCIAL');
                INodeTemp.Text := Q.FieldByName('razao_social').AsString;
                INodeTemp := INodeProdutor.AddChild('NOME');
                INodeTemp.Text := Q.FieldByName('nom_pessoa').AsString;
                INodeTemp := INodeProdutor.AddChild('NUM_IDENTIDADE');
                INodeTemp.Text := Q.FieldByName('num_identidade').AsString;
                INodeTemp := INodeProdutor.AddChild('SEXO');
                INodeTemp.Text := Q.FieldByName('sexo_pessoa').AsString;
                INodeTemp := INodeProdutor.AddChild('TIPO_ENDERECO');
                INodeTemp.Text := Q.FieldByName('tipo_endereco').AsString;
                INodeTemp := INodeProdutor.AddChild('LOGRADOURO');
                INodeTemp.Text := Q.FieldByName('nom_logradouro').AsString;
                INodeTemp := INodeProdutor.AddChild('BAIRRO');
                INodeTemp.Text := Q.FieldByName('nom_bairro').AsString;
                INodeTemp := INodeProdutor.AddChild('CEP');
                INodeTemp.Text := Q.FieldByName('num_cep').AsString;
                INodeTemp := INodeProdutor.AddChild('MUNICIPIO');
                INodeTemp.Text := Q.FieldByName('nom_municipio').AsString;
                INodeTemp := INodeProdutor.AddChild('MUNICIPIO_IBGE');
                INodeTemp.Text := Q.FieldByName('cod_municipio').AsString;
                INodeTemp := INodeProdutor.AddChild('TELEFONE');
                INodeTemp.Text := Q.FieldByName('telefone_contato').AsString;
                INodeTemp := INodeProdutor.AddChild('EMAIL');
                INodeTemp.Text := Q.FieldByName('email_contato').AsString;
                if Q.FieldByName('cod_propriedade_rural').AsInteger > 0 then begin
                  INodeTemp := INodeProdutor.AddChild('PROPRIETARIO');
                  INodeTemp.Text := 'C�d. propriedade : ' + IntToStr(Q.FieldByName('cod_propriedade_rural').AsInteger);
                end else begin
                  INodeTemp := INodeProdutor.AddChild('PRODUTOR');
                  INodeTemp.Text := 'C�d. propriedade : ' + IntToStr(Q.FieldByName('cod_propriedade_rural').AsInteger) + 'dono dos animais.';
                end;
           Inc(Qtd1);
        except
          Result := InserirErro(DadosArquivo, 'Erro na gera��o/transmiss�o do produtor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');
        end;

        QU.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
        QU.ParamByName('cod_pessoa_produtor').AsInteger := Q.FieldByName('cod_pessoa_produtor').AsInteger;
        QU.ExecSQL;

        Q.Next;
      end;

      XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

      // Grava��o do arquivo, cria arquivo ZIP
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;

      if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
        Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip]);
        Result := -2277;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoProdutores := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogIPP) then begin
          CodArquivoProdutores := -1;
        end;
        Result := -1;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
    Q.Free;
    Q2.Free;
    QU.Free;

    if ZipAberto then begin
      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
      end;
    end;
  end;
end;

function TIntInterfaceSisbov.GeraArquivoSUP(var  DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo: String = 'GeraArquivoSUP';
  TipoArquivo: Integer = 8;
var
  Q, Q2, QU : THerdomQuery;
  SexoSuperv, DtaExpedicao, DtaNascimento, TelefoneContato, CpfCnpjProp, DesTipo, Prefixo: String;
  Zip : ZipFile;
  Qtd1 : Integer;
  CodTmp: Integer;
  XMLDoc: TXMLDocument;
  INodeArquivo, INodeTecnicos, INodeTecnico, INodeTemp : IXMLNode;
  ZipAberto, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoWsSISBOV;
begin
//  XMLDoc := nil;
//  RetornoSisbov := nil;
  ZipAberto     := false;

  Q := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  QU := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;

  try
    SoapSisbov.Inicializar(Conexao, Mensagens);

    Conectado := SoapSisbov.conectado('T�cnico/Supervisor');

    QU.SQL.Clear;
    QU.SQL.Add('update tab_tecnico ');
    QU.SQL.Add('  set cod_arquivo_sisbov = :cod_arquivo_sisbov ');
    QU.SQL.Add('where cod_pessoa_tecnico = :cod_pessoa_tecnico ');

    try

      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('exec spt_obtem_tecnico :cod_arquivo_sisbov');
      {$ENDIF}

      // Se for gera��o de arquivo novo pega todos os registros ainda n�o gerados, sen�o
      // pega registros gerados com o c�digo informado
      if DadosArquivo.ArquivoNovo then begin
        DadosArquivo.CodArquivoSisbov := -1;
      end;
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
      Q.Open;

      // Tratamento para o caso de n�o encontrar nenhuma informa��o
      if Q.IsEmpty then begin
        // Se n�o for arquivo novo e n�o encontrar registros, causa erro
        if (Not DadosArquivo.ArquivoNovo) then begin
          Mensagens.Adicionar(1083, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov]);
          Result := -1083;
        end else begin
          Result := -1;
        end;
        Exit;
      end;

      // Se for arquivo novo, cria registro correspondente na tab_arquivo_sisbov
      if DadosArquivo.ArquivoNovo then begin
        // Obtem pr�ximo c�digo
        Result := ProximoCodArquivoSisbov;
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.CodArquivoSisbov := Result;

        // Monta nome do arquivo
        DadosArquivo.CodTipoArquivoSisbov := TipoArquivo;
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        if Result < 0 then begin
          Exit;
        end;
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';

        // Grava registro na tab_arquivo_sisbov
        Result := GravaArquivoSisbov(DadosArquivo);
        if Result < 0 then begin
          Exit;
        end;
      end else begin
        Result := ObtemDadosTipoArquivoSisbov(DadosArquivo, DesTipo, Prefixo);
        DadosArquivo.NomArquivoSisbov := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + FExtensaoArquivo;
        DadosArquivo.NomArquivoZip    := Trim(DadosArquivo.Caminho) + Trim(Prefixo) + '_' + Trim(StrZero(DadosArquivo.CodArquivoSisbov, 5)) + '.ZIP';
      end;

      // Limpa mensagens de erro
      Result := LimparErros(DadosArquivo);

      if (not Conectado) and (Not DadosArquivo.ArquivoNovo) then begin
        Result := InserirErro(DadosArquivo, 'N�o foi poss�vel conectar no servidor SISBOV. Assim, os dados de t�cnico/supervisor n�o foram transmitidos. Favor reprocessar o arquivo mais tarde.');
        if Result < 0 then begin
          Exit;
        end;
      end;

      XMLDoc := TXMLDocument.Create(nil);
      try
        XMLDoc.Active := true;

        INodeArquivo := XMLDoc.AddChild('ARQUIVO');
        INodeTemp := INodeArquivo.AddChild('CNPJ_CERTIFICADORA');
        INodeTemp.Text := DadosArquivo.CNPJCertificadora;
        INodeTemp := INodeArquivo.AddChild('TIPO_ARQUIVO');
        INodeTemp.Text := 'SUP'; //VALOR FIXO

        INodeTecnicos := INodeArquivo.AddChild('TECNICOS');
      except
        Mensagens.Adicionar(2278, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, ' cria��o - T�CNICO ']);
        Result := -2278;
        Exit;
      end;

      Qtd1 := 0;
      CpfCnpjProp := '';

      While Not Q.Eof do begin
        RetornoSisbov := nil;

        // Consiste se tecnico est� efetivado
        if Q.FieldByName('ind_tecnico_efetivado').AsInteger = 0  then begin
          // Insere log de erro
          Result := InserirErro(DadosArquivo, 'O t�cnico n�o est� efetivado (' + Q.FieldByName('nom_pessoa').AsString + ').');
          if Result < 0 then begin
            Exit;
          end;

          // Posiciona no pr�ximo tecnico
          CodTmp := Q.FieldByName('cod_pessoa_tecnico').AsInteger;
          While (Q.FieldByName('cod_pessoa_tecnico').AsInteger = CodTmp) and (Not Q.Eof) do begin
            Q.Next;
          end;
          Continue;
        end;

        try
          If (Conectado) and (Q.FieldByName('ind_transmissao_sisbov').AsString = '') then begin
            if Q.FieldByName('telefone_contato').AsString = '' then begin
              TelefoneContato := '';//'N�o tem';
            end else begin
              TelefoneContato := Q.FieldByName('telefone_contato').AsString;
            end;

            DtaExpedicao      := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_expedicao').AsDateTime);
            DtaNascimento     := FormatDateTime('dd/mm/yyyy', Q.FieldByName('dta_nascimento').AsDateTime);

            if Q.FieldByName('sexo_pessoa').AsString = 'M' then begin
              SexoSuperv := 'MA';
            end else begin
              SexoSuperv := 'FE';
            end;

            try
              RetornoSisbov := SoapSisbov.incluirSupervisor(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('nom_pessoa').AsString
                                 , TelefoneContato
                                 , Q.FieldByName('email_contato').AsString
                                 , Q.FieldByName('cpf_pessoa').AsString
                                 , Q.FieldByName('num_identidade').AsString
                                 , DtaNascimento
                                 , DtaExpedicao
                                 , Q.FieldByName('orgao_expedicao').AsString
                                 , Q.FieldByName('uf_expedicao').AsString
                                 , SexoSuperv
                                 , Q.FieldByName('nom_logradouro').AsString
                                 , Q.FieldByName('nom_bairro').AsString
                                 , Q.FieldByName('num_cep').AsString
                                 , Q.FieldByName('cod_municipio').AsString );
            except
              on E: Exception do
              begin
                Result := InserirErro(DadosArquivo, 'Erro ao transmitir t�cnico/supervisor (CPF/CNPJ:' + Q.FieldByName('num_cnpj_cpf').AsString + ').');

                if Result < 0 then begin
                  Exit;
                end;
              end;
            end;

            If RetornoSisbov <> nil then begin
              If (RetornoSisbov.Status = 0) and (RetornoSisbov.listaErros[0].codigoErro <> '11.018') then begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                   Q2.SQL.Add('update tab_tecnico ' +
                              '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                              ' where cod_pessoa_tecnico    = :cod_pessoa_tecnico ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_tecnico').AsInteger    := Q.FieldByName('cod_pessoa_tecnico').AsInteger;
                Q2.ParamByName('cod_idtransacao').AsInteger       := RetornoSisbov.idTransacao;
                Q2.ExecSQL;

                Commit;

                Result := InserirErro(DadosArquivo, 'Erro ao transmitir o t�cnico (CPF/CNPJ:' + Q.FieldByName('cpf_pessoa').AsString + '). <br>&nbsp;&nbsp;&nbsp;Mensagem Sisbov: ' + TrataMensagemErroSISBOV(RetornoSisbov));

                if Result < 0 then begin
                  Exit;
                end;
              end else begin
                BeginTran;

                Q2.SQL.Clear;
                {$IFDEF MSSQL}
                   Q2.SQL.Add('update tab_tecnico ' +
                              '   set ind_transmissao_sisbov = ''S'' ' +
                              '     , cod_id_transacao_sisbov = :cod_idtransacao ' +
                              ' where cod_pessoa_tecnico    = :cod_pessoa_tecnico ');
                {$ENDIF}
                Q2.ParamByName('cod_pessoa_tecnico').AsInteger    := Q.FieldByName('cod_pessoa_tecnico').AsInteger;
                Q2.ParamByName('cod_idtransacao').AsInteger       := RetornoSisbov.idTransacao;
                Q2.ExecSQL;

                Commit;
              end;
            end else begin
              Result := InserirErro(DadosArquivo, 'Erro no retorno da transmiss�o do t�cnico (CPF/CNPJ:' + Q.FieldByName('cpf_pessoa').AsString + ').');
            end;
          end;

          INodeTecnico := INodeTecnicos.AddChild('TECNICO');
                INodeTemp := INodeTecnico.AddChild('TIPO_TECNICO');
                INodeTemp.Text := Q.FieldByName('tipo_tecnico').AsString;
                INodeTemp := INodeTecnico.AddChild('CPF_CNPJ');
                INodeTemp.Text := Q.FieldByName('cpf_pessoa').AsString;
                INodeTemp := INodetecnico.AddChild('NOME');
                INodeTemp.Text := Q.FieldByName('nom_pessoa').AsString;
                INodeTemp := INodeTecnico.AddChild('NUM_IDENTIDADE');
                INodeTemp.Text := Q.FieldByName('num_identidade').AsString;
                INodeTemp := INodeTecnico.AddChild('SEXO');
                INodeTemp.Text := Q.FieldByName('sexo_pessoa').AsString;
                INodeTemp := INodeTecnico.AddChild('TIPO_ENDERECO');
                INodeTemp.Text := Q.FieldByName('tipo_endereco').AsString;
                INodeTemp := INodeTecnico.AddChild('LOGRADOURO');
                INodeTemp.Text := Q.FieldByName('nom_logradouro').AsString;
                INodeTemp := INodeTecnico.AddChild('BAIRRO');
                INodeTemp.Text := Q.FieldByName('nom_bairro').AsString;
                INodeTemp := INodeTecnico.AddChild('CEP');
                INodeTemp.Text := Q.FieldByName('num_cep').AsString;
                INodeTemp := INodeTecnico.AddChild('MUNICIPIO');
                INodeTemp.Text := Q.FieldByName('nom_municipio').AsString;
                INodeTemp := INodeTecnico.AddChild('MUNICIPIO_IBGE');
                INodeTemp.Text := Q.FieldByName('cod_municipio').AsString;
                INodeTemp := INodeTecnico.AddChild('TELEFONE');
                INodeTemp.Text := Q.FieldByName('telefone_contato').AsString;
                INodeTemp := INodeTecnico.AddChild('EMAIL');
                INodeTemp.Text := Q.FieldByName('email_contato').AsString;

          Inc(Qtd1);
        except
          Result := InserirErro(DadosArquivo, 'Erro na gera��o/transmiss�o do t�cnico (CPF/CNPJ:' + Q.FieldByName('cpf_pessoa').AsString + ').');
        end;


        QU.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
        QU.ParamByName('cod_pessoa_tecnico').AsInteger := Q.FieldByName('cod_pessoa_tecnico').AsInteger;
        QU.ExecSQL;

        Q.Next;
      end;

      XMLDoc.SaveToFile(DadosArquivo.NomArquivoSisbov);

      // Grava��o do arquivo, cria arquivo ZIP
      if AbrirZip(DadosArquivo.NomArquivoZip, Zip) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'cria��o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := true;
      end;

      if AdicionarArquivoNoZipSemHierarquiaPastas(zip, DadosArquivo.NomArquivoSisbov) < 0 then begin
        Mensagens.Adicionar(2277, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoSisbov, DadosArquivo.NomArquivoZip]);
        Result := -2277;
        Exit;
      end;

      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
        Result := -1140;
        Exit;
      end else begin
        ZipAberto := false;
      end;

      CodArquivoSupervisores := DadosArquivo.CodArquivoSisbov;

      if Qtd1 > 0 then begin
        Result := 0;
      end else begin
        if (DadosArquivo.ArquivoNovo) and (not FPossuiLogSUP) then begin
          CodArquivoSupervisores := -1;
        end;
        Result := -1;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1087, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1087;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
    Q.Free;
    Q2.Free;
    QU.Free;

    if ZipAberto then begin
      if FecharZip(Zip, nil) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZip, 'conclus�o']);
      end;
    end;
  end;
end;


function TIntInterfaceSisbov.LimparErros(DadosArquivo: TDadosArquivo): Integer;
const
  NomeMetodo : String = 'LimparErros';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  try

    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('delete from tab_erro_exportacao_sisbov ' +
              ' where cod_arquivo_sisbov = :cod_arquivo_sisbov');
    {$ENDIF}
    Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
    try
      Q.ExecSQL;
    except
      On E: Exception do begin
        Rollback;
        if DadosArquivo.NomArquivoZip <> '' then begin
          DeleteFile(DadosArquivo.NomArquivoZip);
        end;
        Mensagens.Adicionar(1449, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1449;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.InserirErro(DadosArquivo: TDadosArquivo;
  TxtMensagemErro: String): Integer;
const
  NomeMetodo : String = 'InserirErro';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  try

    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('insert into tab_erro_exportacao_sisbov ' +
              '  (cod_arquivo_sisbov, txt_mensagem_erro) ' +
              'values ' +
              '  (:cod_arquivo_sisbov, :txt_mensagem_erro)');
    {$ENDIF}
    Q.ParamByName('cod_arquivo_sisbov').AsInteger := DadosArquivo.CodArquivoSisbov;
    Q.ParamByName('txt_mensagem_erro').AsString := TxtMensagemErro;
    try
      Q.ExecSQL;
      Case DadosArquivo.CodTipoArquivoSisbov of
        1 : FPossuiLogPRO := True;
        2 : FPossuiLogANI := True;
        3 : FPossuiLogMOR := True;
        4 : FPossuiLogMOV := True;
        5 : FPossuiLogCER := True;
        7 : FPossuiLogIPP := True;
        8 : FPossuiLogSUP := True;
      end;
    except
      On E: Exception do begin
        Rollback;
        if DadosArquivo.NomArquivoZip <> '' then begin
          DeleteFile(DadosArquivo.NomArquivoZip);
        end;
        Mensagens.Adicionar(1449, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1449;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.CodLocalizacao(CodPropriedadeRural,
  CodPessoaProdutor: Integer; var CodLocalizacao: String; var CodArquivoSisbov: Integer): Integer;
const
  NomeMetodo : String = 'CodLocalizacao';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  try

    Q.SQL.Clear;
    {$IFDEF MSSQL}
    Q.SQL.Add('select cod_localizacao_sisbov, ' +
              '       cod_arquivo_sisbov  ' +
              '  from tab_localizacao_sisbov ' +
              ' where cod_propriedade_rural = :cod_propriedade_rural ' +
              '   and cod_pessoa_produtor = :cod_pessoa_produtor ');
    {$ENDIF}
    try
      CodLocalizacao := '';
      CodArquivoSisbov := -1;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      if not Q.IsEmpty then begin
        if UpperCase(ValorParametro(111)) = 'S' then
        begin
          CodLocalizacao := PadL(Q.FieldByName('cod_localizacao_sisbov').AsString, '0', 10);
        end
        else
        begin
          CodLocalizacao := PadR(Q.FieldByName('cod_localizacao_sisbov').AsString, ' ', 10);
        end;

        if Not Q.FieldByName('cod_arquivo_sisbov').IsNull then begin
          if Q.FieldByName('cod_arquivo_sisbov').AsInteger > 0 then begin
            CodArquivoSisbov := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
          end;
        end;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1441, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1441;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.GerarArquivos(CodArquivoSisbov, CodTipoArquivo: Integer): Integer;
const
  Metodo : Integer = 339;
  NomeMetodo : String = 'GerarArquivos';
var
  bDisponibilizaViaFTP: Boolean;
  sCaminhoDisponibilizacaoViaFTP: String;
  DadosArquivo : TDadosArquivo;
  IntArquivosFTPEnvio: TIntArquivosFTPEnvio;
  Q: THerdomQuery;

  procedure DisponibilizaArquivoViaFTP;
  var
    sOrigem, sDestino: String;
  begin
    if bDisponibilizaViaFTP and not(DadosArquivo.PossuiLogErro) then
    begin
      sOrigem := DadosArquivo.NomArquivoZIP;
      if FileExists(sOrigem) and (DadosArquivo.Tamanho > 0) then
      begin
        try
          sDestino := sCaminhoDisponibilizacaoViaFTP + ExtractFileName(DadosArquivo.NomArquivoZIP);

          if not Win32_CopiaArquivo(sOrigem, sDestino) then
          begin
            Mensagens.Adicionar(1691, Self.ClassName,
              NomeMetodo, [DadosArquivo.NomArquivoZIP, 'Falha durante a chamada da fun��o WIN32 (c�pia)']);
          end;
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(1691, Self.ClassName, NomeMetodo, [DadosArquivo.NomArquivoZIP, E.Message]);
          end;
        end;
      end;
    end;
  end;

begin
  Result := -1;
  if not Inicializado then
  begin
   RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  IntArquivosFTPEnvio := TIntArquivosFTPEnvio.Create;
  try
    // Verifica se usu�rio pode executar m�todo
    if not Conexao.PodeExecutarMetodo(Metodo) then
    begin
      Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
      Result := -188;
      Exit;
    end;

    // Verifica arquivo sisbov. Se CodArquivoSisbov foi passado, localiza
    // registro na tab_arquivo_sisbov
    if CodArquivoSisbov > 0 then
    begin
      Result := VerificaArquivoSisbov(CodArquivoSisbov, DadosArquivo);
      if Result < 0 then
      begin
        Exit;
      end;
    end
    else
    begin
      DadosArquivo.ArquivoNovo := True;
      DadosArquivo.DtaCriacaoArquivo := DtaSistema;
      DadosArquivo.CodUsuario := Conexao.CodUsuario;
    end;

    // Prepara caminho para grava��o dos arquivos
    try
      DadosArquivo.Caminho := ValorParametro(16) + '\' +
          FormatDateTime('yyyy', DtaSistema) + '\' +
          FormatDateTime('mm', DtaSistema)   + '\' +
          FormatDateTime('dd', DtaSistema);
      bDisponibilizaViaFTP := (ValorParametro(75) = 'S');
      if bDisponibilizaViaFTP then
      begin
        sCaminhoDisponibilizacaoViaFTP := ValorParametro(76)+ '\' +
          FormatDateTime('yyyy', DtaSistema) + '\' +
          FormatDateTime('mm', DtaSistema)   + '\' +
          FormatDateTime('dd', DtaSistema);
        if (sCaminhoDisponibilizacaoViaFTP = '') then
        begin
          bDisponibilizaViaFTP := False;
          Mensagens.Adicionar(1690, Self.ClassName, NomeMetodo, []);
        end
        else
        begin
          if (sCaminhoDisponibilizacaoViaFTP[Length(sCaminhoDisponibilizacaoViaFTP)] <> '\') then
          begin
            sCaminhoDisponibilizacaoViaFTP := sCaminhoDisponibilizacaoViaFTP + '\';
          end;
          if not DirectoryExists(sCaminhoDisponibilizacaoViaFTP) then
          begin
            if not ForceDirectories(sCaminhoDisponibilizacaoViaFTP) then
            begin
              Mensagens.Adicionar(1079, Self.ClassName, NomeMetodo, [sCaminhoDisponibilizacaoViaFTP]);
              Result := -1079;
              Exit;
            end;
          end;
        end;
      end;
    except
      Result := -1;
      Exit;
    end;

    if not DirectoryExists(DadosArquivo.Caminho) then
    begin
      if not ForceDirectories(DadosArquivo.Caminho) then
      begin
        Mensagens.Adicionar(1079, Self.ClassName, NomeMetodo, [DadosArquivo.Caminho]);
        Result := -1079;
        Exit;
      end;
    end;

    if DadosArquivo.Caminho[Length(DadosArquivo.Caminho)] <> '\' then
    begin
      DadosArquivo.Caminho := DadosArquivo.Caminho + '\';
    end;

    // Obtem CNPJ da certificadora dona do sistema
    Result := ObtemCNPJCertificadora(DadosArquivo.CNPJCertificadora);
    if Result < 0 then
    begin
      Exit;
    end;

    //Define extens�o do arquivo a ser gerado
    if UpperCase(ValorParametro(116)) = 'S' then
    begin
       FExtensaoArquivo := '.XML'
    end else
    begin
       FExtensaoArquivo := '.TXT'
    end;

    CodArquivoAnimais := -1;
    CodArquivoPropriedades := -1;
    CodArquivoMovimentacoes := -1;
    CodArquivoMortes := -1;
    CodArquivoCertificados := -1;
    CodArquivoProdutores := -1;
    CodArquivoSupervisores := -1;
    FPossuiLogPRO := False;
    FPossuiLogANI := False;
    FPossuiLogMOR := False;
    FPossuiLogMOV := False;
    FPossuiLogCER := false;
    FPossuiLogIPP := False;
    FPossuiLogSUP := False;

    try
      Result := IntArquivosFTPEnvio.Inicializar(Conexao, Mensagens);
      if Result < 0 then
      begin
        Exit;
      end;

      Q.SQL.Text := 'SET QUERY_GOVERNOR_COST_LIMIT ' + '100000';
      Q.ExecSQL;
      try
        // Processa apenas os arquivo de produtores
        if (CodTipoArquivo = 7) then begin
          // Abre transa��o para gerar produtores rurais
          BeginTran;

          // Chamada da gera��o do arquivo Produtores Rurais
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 7)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            Result := GeraArquivoIPP(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogIPP;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end
            else
            begin
              DisponibilizaArquivoViaFTP;
            end;

  { Para transmiss�o via WebService n�o transmite arquivos via FTP
            if (UpperCase(DadosArquivo.IndEnvioArquivoFTP) = 'S') and (DadosArquivo.Tamanho > 0) then
            begin
              Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaIPP, // Rotina FTP Envio do arquio IPP (5)
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                    DadosArquivo.Tamanho,
                                                    DadosArquivo.IndDescompactarArquivoFTP);
              if Result < 0 then
              begin
                Rollback;
                Exit;
              end;
            end;
  }
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de produtores
          Commit;
        end;

        if (CodTipoArquivo = 8) then begin
          // Abre transa��o para gerar t�cnicos/supervisores
          BeginTran;

          // Chamada da gera��o do arquivo tecnicos supervisores
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 8)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            Result := GeraArquivoSUP(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogSUP;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end
            else
            begin
              DisponibilizaArquivoViaFTP;
            end;
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de t�cnicos/supervisores
          Commit;
        end;

        if (CodTipoArquivo = 1) then begin
          // Abre transa��o para gerar propriedades
          //BeginTran;

          // Chamada da gera��o do arquivo Propriedades Rurais / Produtores
          if (DadosArquivo.ArquivoNovo) or
             ((Not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 1)) then begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;

            Result := GeraArquivoPRO(DadosArquivo);

            if Result < 0 then begin
              if DadosArquivo.NomArquivoZip <> '' then begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
  //            if Result <> -1 then begin
  //              Rollback;
  //              Exit;
  //            end;
            end;

            DadosArquivo.PossuiLogErro := FPossuiLogPRO;
            Result := AtualizaTamanhoArquivo(DadosArquivo);

            if Result >= 0 then begin
  //            Rollback;
  //            Exit;
  //          end else begin
              DisponibilizaArquivoViaFTP;
            end;
  { Para transmiss�o via WebService n�o transmite arquivos via FTP
            if (UpperCase(DadosArquivo.IndEnvioArquivoFTP) = 'S') and (DadosArquivo.Tamanho > 0) then
            begin
              Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaIPR, // Rotina FTP Envio do arquio IPR (1)
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                    DadosArquivo.Tamanho,
                                                    DadosArquivo.IndDescompactarArquivoFTP);
              if Result < 0 then
              begin
                Rollback;
                Exit;
              end;
            end;
  }
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de propriedades
  //        Commit;
        end;

        if (CodTipoArquivo = 2) then begin
          // Abre transa��o para gerar animais
  //        BeginTran;

          // Chamada da gera��o do arquivo Identifica��o de Animais
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 2)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            Result := GeraArquivoANI(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogANI;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end
            else
            begin
              DisponibilizaArquivoViaFTP;
            end;

  { Para transmiss�o via WebService n�o transmite arquivos via FTP
            if (UpperCase(DadosArquivo.IndEnvioArquivoFTP) = 'S') and (DadosArquivo.Tamanho > 0) then
            begin
              Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaIAN, // Rotina FTP Envio do arquio IAN (2)
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                    DadosArquivo.Tamanho,
                                                    DadosArquivo.IndDescompactarArquivoFTP);
              if Result < 0 then
              begin
                Rollback;
                Exit;
              end;
            end;
  }
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de animais
  //        Commit;
        end;

        if (CodTipoArquivo = 3) then begin
          // Abre transa��o para gerar mortes
          BeginTran;

          // Chamada da gera��o do arquivo Morte de Animais
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 3)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            Result := GeraArquivoMOR(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogMOR;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end
            else
            begin
              DisponibilizaArquivoViaFTP;
            end;

  { Para transmiss�o via WebService n�o transmite arquivos via FTP
            if (UpperCase(DadosArquivo.IndEnvioArquivoFTP) = 'S') and (DadosArquivo.Tamanho > 0) then
            begin
              Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaMAN, // Rotina FTP Envio do arquio MAN (4)
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                    DadosArquivo.Tamanho,
                                                    DadosArquivo.IndDescompactarArquivoFTP);
              if Result < 0 then
              begin
                Rollback;
                Exit;
              end;
            end;
  }
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de mortes
          Commit;
        end;

        if (CodTipoArquivo = 4) then begin
          // Abre transa��o para gerar movimenta��es novo sisbov
          // ** Comentado por Edivaldo em 2008-02-25 18:20 devido ao tratamento das transa��es
          //    ter sido implementado na func��o GeraArquivoMOV
          // BeginTran;

          // Chamada da gera��o do arquivo de Movimenta��o de Animais
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 4)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            Result := GeraArquivoMOV(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogMOV;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end;
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de movimenta��es novo sisbov
          // Commit;
        end;

{ ** Comentado em 23/01/2008 as 17:20hs por Edivaldo Junior
     O Sistema antigo deixou de ser utilizado a partir de 01/01/2008.

        // Gera arquivo de movimenta��o para o sistema antigo somente se n�o
        // for um reprocessamento de arquivo e se for n�o tenha cido um processamento
        // de movimenta��o para o novo sisbov.
        if CodArquivoMovimentacoes <= 0 then begin
          // Abre transa��o para gerar movimenta��es sistema antigo SISBOV
          BeginTran;

          // Chamada da gera��o do arquivo de Movimenta��o de Animais sistema antigo SISBOV
          if (DadosArquivo.ArquivoNovo) or
             ((not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 4)) then
          begin
            DadosArquivo.NomArquivoZIP := '';
            DadosArquivo.PossuiLogerro := False;
            FPossuiLogMOV := false;
            Result := GeraArquivoMOVAnt(DadosArquivo);
            if Result < 0 then
            begin
              if DadosArquivo.NomArquivoZip <> '' then
              begin
                DeleteFile(DadosArquivo.NomArquivoZip);
              end;
              if Result <> -1 then
              begin
                Rollback;
                Exit;
              end;
            end;
            DadosArquivo.PossuiLogErro := FPossuiLogMOV;
            Result := AtualizaTamanhoArquivo(DadosArquivo);
            if Result < 0 then
            begin
              Rollback;
              Exit;
            end
            else
            begin
              DisponibilizaArquivoViaFTP;
            end;

            if (UpperCase(DadosArquivo.IndEnvioArquivoFTP) = 'S') and (DadosArquivo.Tamanho > 0) then
            begin
              Result := IntArquivosFTPEnvio.Inserir(ctCodRotinaMOV, // Rotina FTP Envio do arquio MOV (3)
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFileName(DadosArquivo.NomArquivoZIP),
                                                    ExtractFilePath(DadosArquivo.NomArquivoZIP),
                                                    DadosArquivo.Tamanho,
                                                    DadosArquivo.IndDescompactarArquivoFTP);
              if Result < 0 then
              begin
                Rollback;
                Exit;
              end;
            end;
          end;

          DeleteFile(DadosArquivo.NomArquivoSisbov);

          // Cofirma transa��o de movimenta��es do sistema antigo SISBOV
          Commit;
        end;
}
    {    // Abre transa��o para gerar certificados
        BeginTran;

        // Chamada da gera��o do arquivo de emiss�o de certificados
        if (DadosArquivo.ArquivoNovo) or
           ((Not DadosArquivo.ArquivoNovo) and (DadosArquivo.CodTipoArquivoSisbov = 5)) then begin
          DadosArquivo.NomArquivoZIP := '';
          DadosArquivo.PossuiLogerro := False;
          Result := GeraArquivoCER(DadosArquivo);
          if Result < 0 then begin
            if DadosArquivo.NomArquivoZip <> '' then begin
              DeleteFile(DadosArquivo.NomArquivoZip);
            end;
            if Result <> -1 then begin
              Rollback;
              Exit;
            end;
          end;
          DadosArquivo.PossuiLogErro := FPossuiLogCER;
          Result := AtualizaTamanhoArquivo(DadosArquivo);
          if Result < 0 then begin
            Rollback;
            Exit;
          end else begin
            DisponibilizaArquivoViaFTP;
          end;
        end;

        // Cofirma transa��o de certificados
        Commit;
    }

        if FPossuiLogPRO or
           FPossuiLogANI or
           FPossuiLogMOR or
           FPossuiLogMOV or
           FPossuiLogCER or
           FPossuiLogIPP or
           FPossuiLogSUP then
        begin
          Result := 1;
        end
        else
        begin
          Result := 0;
        end;
      finally
        Q.SQL.Text := 'SET QUERY_GOVERNOR_COST_LIMIT ' + IntToStr(Conexao.VQueryGovernorCostLimit);
        Q.ExecSQL;
      end;
    except
      on E: Exception do
      begin
        Rollback;
        if DadosArquivo.NomArquivoZip <> '' then
        begin
          DeleteFile(DadosArquivo.NomArquivoZip);
          DeleteFile(DadosArquivo.NomArquivoSisbov);
        end;
        Mensagens.Adicionar(1067, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1067;
        Exit;
      end;
    end;
  finally
    Q.Free;
    IntArquivosFTPEnvio.Free;
  end;
end;

function TIntInterfaceSisbov.PesquisarArquivos(DtaInicio,
  DtaFim: TDateTime; CodTipoArquivoSisbov: Integer; DtaInicioSisbov,
  DtaFimSisbov: TDateTime; IndPossuiLogErro: String): Integer;
const
  Metodo : Integer = 338;
  NomeMetodo : String = 'PesquisarArquivos';
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usu�rio pode executar m�todo
  if Not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  if DtaInicio > DtaFim then begin
    Mensagens.Adicionar(159, Self.ClassName, NomeMetodo, []);
    Result := -159;
    Exit;
  end;

  if DtaFim = 0 then begin
    DtaFim := Now();
  end;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tas.dta_criacao_arquivo      DtaCriacaoArquivo, ' +
                '       tas.cod_arquivo_sisbov       CodArquivoSisbov, ' +
                '       tas.nom_arquivo_sisbov       NomArquivoSisbov, ' +
                '       tas.qtd_bytes_arquivo        QtdBytesArquivo, ' +
                '       ttas.cod_tipo_arquivo_sisbov CodTipoArquivoSisbov, ' + 
                '       ttas.des_tipo_arquivo_sisbov DesTipoArquivoSisbov, ' +
                '       tu.nom_usuario               NomUsuario, ' +
                '       tas.ind_possui_log_erro      IndPossuiLogErro, ' +
                '       tas.dta_insercao_sisbov      DtaInsercaoSisbov '+
                '  from tab_arquivo_sisbov tas, ' +
                '       tab_tipo_arquivo_sisbov ttas, ' +
                '       tab_usuario tu ' +
                ' where tas.cod_arquivo_sisbov < 999999999 ' +
                '   and ttas.cod_tipo_arquivo_sisbov = tas.cod_tipo_arquivo_sisbov ' +
                '   and tu.cod_usuario = tas.cod_usuario ' +
                '   and ((tas.cod_tipo_arquivo_sisbov = :cod_tipo_arquivo_sisbov) or (:cod_tipo_arquivo_sisbov = -1)) ');
  if DtaInicio > 0 then begin
    Query.SQL.Add('   and tas.dta_criacao_arquivo >= :dta_inicio ');
  end;
  if DtaFim > 0 then begin
    Query.SQL.Add('   and tas.dta_criacao_arquivo < :dta_fim ');
  end;
  if (DtaInicioSisbov > 0) and (DtaFimSisbov > 0) then begin
    Query.SQL.Add(' and tas.dta_insercao_sisbov >= :dta_insercao_sisbov_inicio ');
    Query.SQL.Add(' and tas.dta_insercao_sisbov < :dta_insercao_sisbov_fim ');
    Query.ParamByName('dta_insercao_sisbov_inicio').AsDateTime := Trunc(DtaInicioSisbov);
    Query.ParamByName('dta_insercao_sisbov_fim').AsDateTime := Trunc(DtaFimSisbov)+1;
  end;
  if (UpperCase(IndPossuiLogErro) = 'S') or (UpperCase(IndPossuiLogErro) = 'N') then begin
    Query.SQL.Add(' and tas.ind_possui_log_erro = :ind_possui_log_erro ');
  end;
  Query.SQL.Add(' order by tas.dta_criacao_arquivo desc ');

{$ENDIF}
  Query.ParamByName('cod_tipo_arquivo_sisbov').AsInteger := CodTipoArquivoSisbov;
  if DtaInicio > 0 then begin
    Query.ParamByName('dta_inicio').AsDateTime := Trunc(DtaInicio);
  end;
  if DtaFim > 0 then begin
    Query.ParamByName('dta_fim').AsDateTime := Trunc(DtaFim)+1;
  end;
  if (UpperCase(IndPossuiLogErro) = 'S') or (UpperCase(IndPossuiLogErro) = 'N') then begin
    Query.ParamByName('ind_possui_log_erro').AsString := UpperCase(IndPossuiLogErro);
  end;

  try
    Query.Open;
    Result := 0;
  except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1078, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1078;
      Exit;
    end;
  end;
end;

function TIntInterfaceSisbov.Buscar(CodArquivoSisbov: Integer): Integer;
const
  NomeMetodo : String = 'Buscar';
  Metodo : Integer = 347;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usu�rio pode executar m�todo
  if Not Conexao.PodeExecutarMetodo(183) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tas.cod_arquivo_sisbov, ' +
                '       tas.nom_arquivo_sisbov, ' +
                '       tas.dta_criacao_arquivo, ' +
                '       tas.qtd_bytes_arquivo, ' +
                '       tas.cod_tipo_arquivo_sisbov, ' +
                '       ttas.des_tipo_arquivo_sisbov, ' +
                '       tas.cod_usuario, ' +
                '       tu.nom_usuario, ' +
                '       tas.dta_insercao_sisbov '+
                '  from tab_arquivo_sisbov tas, ' +
                '       tab_tipo_arquivo_sisbov ttas, ' +
                '       tab_usuario tu ' +
                ' where ttas.cod_tipo_arquivo_sisbov = tas.cod_tipo_arquivo_sisbov ' +
                '   and tu.cod_usuario = tas.cod_usuario ' +
                '   and tas.cod_arquivo_sisbov = :cod_arquivo_sisbov ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSisbov;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(1116, Self.ClassName, NomeMetodo, []);
        Result := -1116;
        Exit;
      end;

      // Obtem informa��es do registro
      IntArquivoSisbov.CodArquivoSisbov := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
      IntArquivoSisbov.NomArquivoSisbov := Q.FieldByName('nom_arquivo_sisbov').AsString;
      IntArquivoSisbov.DtaCriacaoArquivo := Q.FieldByName('dta_criacao_arquivo').AsDateTime;
      IntArquivoSisbov.QtdBytesArquivo := Q.FieldByName('qtd_bytes_arquivo').AsInteger;
      IntArquivoSisbov.CodTipoArquivoSisbov := Q.FieldByName('cod_tipo_arquivo_sisbov').AsInteger;
      IntArquivoSisbov.DesTipoArquivoSisbov := Q.FieldByName('des_tipo_arquivo_sisbov').AsString;
      IntArquivoSisbov.CodUsuario := Q.FieldByName('cod_usuario').AsInteger;
      IntArquivoSisbov.NomUsuario := Q.FieldByName('nom_usuario').AsString;
      IntArquivoSisbov.DtaInsercaoSisbov := Q.FieldByName('dta_insercao_sisbov').AsDateTime;
      Result := PossuiLog(IntArquivoSisbov.CodArquivoSisbov);
      if Result < 0 then Exit;
      IntArquivoSisbov.IndPossuiLogErro := Result;

      // Retorna status "ok" do m�todo
      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1117, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1117;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.PossuiLog(CodArquivoSisbov: Integer): Integer;
const
  NomeMetodo : String = 'PossuiLog';
var
  Q : THerdomQuery;
begin
  Result := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try


      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(*) as qtd_log ' +
                '  from tab_erro_exportacao_sisbov ' +
                ' where cod_arquivo_sisbov = :cod_arquivo_sisbov ');
{$ENDIF}
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSisbov;
      Q.Open;
      if Q.FieldByName('qtd_log').AsInteger > 0 then begin
        Result := 1;
      end;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1453, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1453;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntInterfaceSisbov.PesquisarLogErro(
  CodArquivoSisbov: Integer): Integer;
const
  Metodo : Integer = 435;
  NomeMetodo : String = 'PesquisarLogErro';
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usu�rio pode executar m�todo
  if Not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select cod_arquivo_sisbov as CodArquivoSisbov, ' +
                '       txt_mensagem_erro as TxtMensagemErro ' +
                '  from tab_erro_exportacao_sisbov ' +
                ' where cod_arquivo_sisbov = :cod_arquivo_sisbov ' +
                ' order by txt_mensagem_erro ');
{$ENDIF}
  Query.ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSisbov;

  try
    Query.Open;
    Result := 0;
  except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1452, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1452;
      Exit;
    end;
  end;
end;

function TIntInterfaceSisbov.AtualizarDataSisbov(CodArquivoSisbov: Integer;
  DtaInsercaoSisbov: TDateTime): Integer;
const
  Metodo : Integer = 494;
  NomeMetodo : String = 'AtualizarDataSisbov';
var
  Q: THerdomQuery;
  InfoArquivo: TDadosArquivo;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usu�rio pode executar m�todo
  if Not Conexao.PodeExecutarMetodo(Metodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se o arquivo informado corresponde a um arquivo v�lido
  Result := VerificaArquivoSisbov(CodArquivoSisbov, InfoArquivo);
  if Result < 0 then Exit;

  // Verifica se data de inser��o do arquivo foi informada e � uma data v�lida
  if DtaInsercaoSisbov = 0 then begin
    Mensagens.Adicionar(1614, Self.ClassName, NomeMetodo, []);
    Result := -1614;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Gera mensagem caso a data de inser��o no sisbov esteja sendo alterada
      if InfoArquivo.DtaInsercaoSisbov > 0 then begin
        Mensagens.Adicionar(1615, Self.ClassName, NomeMetodo, [
          FormatDateTime('dd/mm/yyyy', InfoArquivo.DtaInsercaoSisbov),
          FormatDateTime('dd/mm/yyyy', DtaInsercaoSisbov)]);
      end;

      // Abre transa��o
      BeginTran;

      // Atualiza data na base
      Q.Close;
      Q.SQL.Text :=
        'update '+
        '  tab_arquivo_sisbov '+
        'set '+
        '  dta_insercao_sisbov = :dta_insercao_sisbov '+
        'where '+
        '  cod_arquivo_sisbov = :cod_arquivo_sisbov ';
      Q.ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSisbov;
      Q.ParamByName('dta_insercao_sisbov').AsDateTime := DtaInsercaoSisbov;
      Q.ExecSQL;

      // Confirma transa��o
      Commit;

      Result := 0;
    except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(1613, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1613;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

{ Se o c�digo SISBOV foi solicitado antes da data 01/11/2004 ent�o a ra�a a ser
  enviada para o SISBOV � a ra�a antiga e n�o a nova. Desta forma o c�digo �
  trocado caso coincida com o codigo novo.

Parametros:
  CodRacaSisbov: C�digo (sigla) da ra�a que ser� enviada para o SISBOV
  DtaSolicitacaoCodigo: Data da solicita��o do c�digo SISBOV associado ao animal

Retorno:
  Sigla que deve ser enviada para o SISBOV.}
function TIntInterfaceSisbov.ObtemRacaAnimal(CodRacaSisbov: String;
  DtaSolicitacaoCodigo: TDateTime): String;
var
  I: Integer;
begin
  Result := CodRacaSisbov;

  // Veirfica a data de solicita��o.
  if DtaSolicitacaoCodigo < EncodeDate(2004, 11, 01) then
  begin
    // Verifica se o c�digo do animal est� na lista
    for I := 0 to Length(COD_RACA_SISBOV_NOVO) - 1 do
    begin
      if COD_RACA_SISBOV_NOVO[I] = CodRacaSisbov then
      begin
        // Se estiver troca o c�digo pelo antigo
        Result := COD_RACA_SISBOV_ANTIGO[I];
      end;
    end;
  end;
end;

{
function TIntInterfaceSisbov.StrToNum(Texto: string): string;
var
  iAux: Integer;
begin
   iAux := 1;
   while iAux <= Length(Texto) do begin
    if not(Texto[iAux] in ['1','2','3','4','5','6','7','8','9','0']) then
       Texto:=Replace(Texto, Texto[iAux], '');
    Inc(iAux);
  end;
  Result := Texto;
end;

function TIntInterfaceSisbov.Replace(Dest, SubStr, Str: string): string;
var
  Position: Integer;
begin
  Position:=Pos(SubStr, Dest);
  Delete(Dest, Position, Length(SubStr));
  Insert(Str, Dest, Position);
  Result:=Dest;
end;
}

function TIntInterfaceSisbov.CadastrarEmail(const NovoEmail: String): String;
const
  NomeMetodo: String = 'CadastrarEmail';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: Boolean;
  Retorno: RetornoCadastrarEmail;
begin
  SoapSisbov := TIntSoapSisbov.Create;
  Retorno    := nil;
  Result     := '';
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.conectado('Cadastrar Email');
      if (not Conectado) then
        raise Exception.Create('N�o foi poss�vel conectar � WebService do SISBOV.');
      Retorno  := SoapSisbov.cadastrarEmail( Descriptografar(ValorParametro(118)), Descriptografar(ValorParametro(119)), NovoEmail);
      if (Retorno <> nil) then
      begin
        if (Retorno.status = 1) then
        begin
          Result := IntToStr(Retorno.idTransacao);
        end
        else
          begin
            Result := Retorno.listaErros[0].codigoErro + ' - ' + Retorno.listaErros[0].menssagemErro;
            if (Retorno.erroBanco = '') then
              Result := Retorno.erroBanco + ' [' + Result + ']';
            Result := '#ERRO: ' + Result;
          end;
      end
      else
        Result := '#ERRO: Retorno inv�lido!';
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2408, Self.ClassName, NomeMetodo, [E.Message]);
        Result := '#ERRO: 2408 - ' + E.Message;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
  end;
end;

function TIntInterfaceSisbov.ConsultarSolicitacaoNumeracao(const NumeroSolicitacao: String): String;
const
  NomeMetodo: String = 'ConsultarSolicitacaoNumeracao';
var
  SoapSisbov: TIntSoapSisbov;
  Retorno: RetornoConsultaSolicitacaoNumeracao;
  Conectado: Boolean;
  iNumeroSolicitacao: Integer;
begin
  SoapSisbov := TIntSoapSisbov.Create;
  Retorno    := nil;
  Result     := '';
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.conectado('Consultar Solicita��o de Numera��o');
      if (not Conectado) then
        raise Exception.Create('N�o foi poss�vel conectar � WebService do SISBOV.');
      iNumeroSolicitacao := StrToInt(NumeroSolicitacao);
      Retorno := SoapSisbov.consultaSolicitacaoNumeracao( Descriptografar(ValorParametro(118)), Descriptografar(ValorParametro(119)), iNumeroSolicitacao);
      if (Retorno <> nil) then
      begin
        if (Retorno.status = 1) then
        begin
          case Retorno.situacao of
            1: Result := '1 - N�o Enviada';
            2: Result := '2 - Enviada';
            3: Result := '3 - Aprovada';
            4: Result := '4 - N�o Aprovada';
            5: Result := '5 - Cancelada';
            6: Result := '6 - Aberta';
            7: Result := '7 - Finalizada';
          end;
          if (Trim(Retorno.observacao) <> '') then
            Result := Result + ' *** Observa��o: ' + Retorno.observacao;
        end
        else
          begin
            Result := Retorno.listaErros[0].codigoErro + ' - ' + Retorno.listaErros[0].menssagemErro;
            if (Retorno.erroBanco = '') then
              Result := Retorno.erroBanco + ' [' + Result + ']';
          end;
      end
      else
        Result := '#ERRO: Retorno inv�lido!';
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2410, Self.ClassName, NomeMetodo, [E.Message]);
        Result := '#ERRO: 2410 - ' + E.Message;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
  end;
end;

function TIntInterfaceSisbov.ConsultarEmail: String;
const
  NomeMetodo: String = 'ConsultarEmail';
var
  SoapSisbov: TIntSoapSisbov;
  Retorno: RetornoConsultarEmail;
  Conectado: Boolean;
begin
  SoapSisbov := TIntSoapSisbov.Create;
  Retorno    := nil;
  Result     := '';
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.conectado('Consultar Email');
      if (not Conectado) then
        raise Exception.Create('N�o foi poss�vel conectar � WebService do SISBOV.');
      Retorno   := SoapSisbov.consultarEmail( Descriptografar(ValorParametro(118)), Descriptografar(ValorParametro(119)));
      if (Retorno <> nil) then
      begin
        if (Retorno.status = 1) then
        begin
          Result := Retorno.email;
        end
        else
          begin
            Result := '#ERRO: ' + Retorno.erroBanco;
            Result := '#ERRO: ' + Retorno.erroBanco + ' [' + Retorno.listaErros[0].codigoErro + ' - ' + Retorno.listaErros[0].menssagemErro + ']';
          end;
      end
      else
        Result := '#ERRO: Retorno inv�lido!';
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2409, Self.ClassName, NomeMetodo, [E.Message]);
        Result := '#ERRO: 2409 - ' + E.Message;
        Exit;
      end;
    end;
  finally
    SoapSisbov.Free;
  end;
end;

function TIntInterfaceSisbov.CancelarSolicitacaoNumeracao(
  NumeroSolicitacao: Integer; NumeroSisbov: WideString; CodPropriedade: Integer;
  CnpjProdutor, CpfProdutor: WideString; CodMotivoCancelamento: Integer): Integer;
const
  NomeMetodo: String  = 'cancelarSolicitarNumeracao';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSisbov: RetornoCancelarSolicitacaoNumeracao;
  Index: Integer;
  Numeros: TStringList;
  CodigosSisbov: ArrayOf_xsd_string;
  Q1: THerdomQuery;
begin
  Result := -1;
  RetornoSisbov   := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  if not Conexao.PodeExecutarMetodo(569) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  Numeros := TStringList.Create;
  try
    NumeroSisbov := StringReplace(NumeroSisbov, ' ', '', [rfReplaceAll]);
    Numeros.DelimitedText := StringReplace(NumeroSisbov, ',0', '', [rfReplaceAll]);
    SetLength(CodigosSisbov, Numeros.Count);

    for Index := 0 to Numeros.Count -1 do begin
      CodigosSisbov[Index] := Numeros[Index];
    end;
  finally
    Numeros.Free;
    Numeros := Nil;
  end;

  Q1 := THerdomQuery.Create(Conexao, nil);
  try
    Q1.SQL.Clear;
    Q1.SQL.Add(' select cod_id_propriedade_sisbov ');
    Q1.SQL.Add(' from tab_propriedade_rural ');
    Q1.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
    Q1.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedade;
    Q1.Open;

    if Q1.IsEmpty then
    begin
      Mensagens.Adicionar(513, Self.ClassName, NomeMetodo, []);
      Result := -513;
      Exit;
    end;

    CodPropriedade := Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger;
    Q1.Close;
  finally
    Q1.Free;
  end;

  SoapSisbov := TIntSoapSisbov.Create;
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado := SoapSisbov.Conectado('Cancelar solicita��o numera��o');

    if not Conectado then begin
      Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, ['']);
      Result := -2289;
      Exit;
    end;

    RetornoSisbov := SoapSisbov.cancelarSolicitacaoNumeracao(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , NumeroSolicitacao
                       , CodigosSisbov
                       , CodPropriedade
                       , CnpjProdutor
                       , CpfProdutor
                       , CodMotivoCancelamento);

  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['']);
      Result := -2290;
      exit;
    end;
  end;

  If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then begin
    Result := RetornoSisbov.status;
  end else begin
    Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [RetornoSisbov.listaErros[0].menssagemErro]);
    Result := -2290;
    Exit;
  end;
end;

procedure TIntInterfaceSisbov.RecuperarTabela(CodigoTabela: Integer);
const
  NomeMetodo: String  = 'recuperarTabela';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  Index: Integer;
  Tabela: TStringList; 
  Tabelas: TStringList;
  RetornoSisbov: RetornoRecuperarTabela;
begin
  RetornoSisbov := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  SoapSisbov := TIntSoapSisbov.Create;
  Tabelas := TStringList.Create;
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado := SoapSisbov.Conectado('Recuperar Tabela');

    if not Conectado then begin
      Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, ['']);
      Exit;
    end;

    RetornoSisbov := SoapSisbov.recuperarTabela(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , 0);

    try
      for Index := 0 to High(RetornoSisbov.registros) do begin
        Tabelas.Values[RetornoSisbov.registros[Index].codigo] := RetornoSisbov.registros[Index].descricao;
      end;
      Tabelas.SaveToFile(ValorParametro(16) + '\Lista de Tabelas.txt');

      if CodigoTabela <> 0 then begin
        Tabela := TStringList.Create;
        try
          RetornoSisbov := SoapSisbov.recuperarTabela(
                             Descriptografar(ValorParametro(118))
                           , Descriptografar(ValorParametro(119))
                           , CodigoTabela);


          for Index := 0 to High(RetornoSisbov.registros) do begin
            Tabela.Values[RetornoSisbov.registros[Index].codigo] := RetornoSisbov.registros[Index].descricao;
          end;
          Tabela.SaveToFile(ValorParametro(16) + '\' + Tabelas.Values[IntToStr(CodigoTabela)] + '.txt');

        finally
          Tabela.Free;
        end;
      end;
    finally
      Tabelas.Free;
    end;
  except
    on E: Exception do
    begin
      Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [' Lista de Tabelas ']);
    end;
  end;
end;

end.
