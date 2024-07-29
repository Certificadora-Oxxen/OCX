unit uIntSolicitacoesReimpressao;

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl, WsSISBOV1, Classes, SysUtils,
  uFerramentas, uIntClassesBasicas, uConexao, uIntMensagens, uIntSoapSisbov;

const
  cLimiteQtdAnimais: Integer = 99999;

type
      TIntSolicitacoesReimpressao = class(TIntClasseBDNavegacaoBasica)
  private
    FSolicitacoesReimpressao: TIntSolicitacoesReimpressao;

    class function ObtemValorSequencial(EConexao: TConexao; EMensagens: TIntMensagens; NomeCampo: String; var ValorCampo: Integer): Integer;
    class function ProximoNumeroSolicitacao(var ValProximoSolicitacao: Integer; Conexao: TConexao; Mensagens: TIntMensagens): Integer;
    class function ProximoCodigoSolicitacao(var ValProximoSolicitacao: Integer; Conexao: TConexao; Mensagens: TIntMensagens): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;
    function SolicitacaoReimpressao: TIntSolicitacoesReimpressao;

    class function ObterProximoNumero(EConexao: TConexao; EMensagens: TIntMensagens): Integer;
    function Inserir(EConexao: TConexao; EMensagens: TIntMensagens;
                     CodSolicitacaoReimpressao, CodPessoaProdutor, CodPropriedadeRural,
                     CodFabricanteIdentificador: Integer;
                     CodAnimais, CodIdentificacoes: WideString): Integer;
  end;

implementation

uses DB;

{ TIntSolicitacoesReimpressao }

constructor TIntSolicitacoesReimpressao.Create;
begin
  inherited;
  FSolicitacoesReimpressao := TIntSolicitacoesReimpressao.Create;
end;

destructor TIntSolicitacoesReimpressao.Destroy;
begin
  FSolicitacoesReimpressao.Free;
  inherited;
end;

function TIntSolicitacoesReimpressao.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
end;

function TIntSolicitacoesReimpressao.Inserir(EConexao: TConexao; EMensagens: TIntMensagens;
  CodSolicitacaoReimpressao, CodPessoaProdutor, CodPropriedadeRural, CodFabricanteIdentificador: Integer;
  CodAnimais, CodIdentificacoes: WideString): Integer;
const
  NomeMetodo = 'Inserir';
var
  QueryLocal: THerdomQuery;
  CodPropriedadeSisbov: Integer;
  NumCnpjFabricante, NumCnpjProdutor, NumCpfProdutor: String;
  Numeros, Identificacoes: TStringList;
  CodigosSisbov: Array_Of_NumeroReimpressaoDTO;
  QtdAnimais, CodPais, CodEstado, CodMicroRegiao, CodAnimal, CodDV: Integer;
  Conectado: Boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoSolicitacaoNumeracaoReimpressao;
  RetornoConsulta: RetornoConsultarNumeracaoReimpressao;
begin
  // Verifica se usuário pode executar método
  if not EConexao.PodeExecutarMetodo(552) then
  begin
    EMensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      // Verifica se já existe uma OS com este número na base de dados.
      if CodSolicitacaoReimpressao > 0 then
      begin
        try
          QueryLocal.SQL.Clear;
          {$IFDEF MSSQL}
          QueryLocal.SQL.Add(' select cod_solicitacao_reimpressao ');
          QueryLocal.SQL.Add(' from tab_solicitacao_reimpressao ');
          QueryLocal.SQL.Add(' where cod_solicitacao_reimpressao = :cod_solicitacao_reimpressao');
          {$ENDIF}
          QueryLocal.ParamByName('cod_solicitacao_reimpressao').AsInteger := CodSolicitacaoReimpressao;
          QueryLocal.Open;

          if not QueryLocal.IsEmpty then
          begin
            EMensagens.Adicionar(1764, Self.ClassName, NomeMetodo, []);
            Result := -1764;
            Exit;
          end;
        finally
          QueryLocal.Close;
        end;
      end;

      if (CodPessoaProdutor > 0) then begin
        try
          QueryLocal.SQL.Clear;
          {$IFDEF MSSQL}
          QueryLocal.SQL.Add(' select cod_natureza_pessoa, num_cnpj_cpf ');
          QueryLocal.SQL.Add(' from tab_pessoa ');
          QueryLocal.SQL.Add(' where cod_pessoa = :cod_pessoa');
          {$ENDIF}
          QueryLocal.ParamByName('cod_pessoa').AsInteger := CodPessoaProdutor;
          QueryLocal.Open;

          if QueryLocal.IsEmpty then
          begin
            EMensagens.Adicionar(1771, Self.ClassName, NomeMetodo, []);
            Result := -1771;
            Exit;
          end;
          NumCnpjProdutor := '';
          NumCpfProdutor := '';
          if QueryLocal.FieldByName('cod_natureza_pessoa').AsString = 'F' then
            NumCpfProdutor := QueryLocal.FieldByName('num_cnpj_cpf').AsString
          else
            NumCnpjProdutor := QueryLocal.FieldByName('num_cnpj_cpf').AsString;
        finally
          QueryLocal.Close;
        end;
      end;

      // Obtem o codigo da propriedade no sisbov
      if (CodPropriedadeRural > 0) then begin
        try
          QueryLocal.SQL.Clear;
          {$IFDEF MSSQL}
          QueryLocal.SQL.Add(' select cod_id_propriedade_sisbov ');
          QueryLocal.SQL.Add(' from tab_propriedade_rural ');
          QueryLocal.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural');
          {$ENDIF}
          QueryLocal.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          QueryLocal.Open;

          if QueryLocal.IsEmpty then
          begin
            EMensagens.Adicionar(513, Self.ClassName, NomeMetodo, []);
            Result := -513;
            Exit;
          end;
          CodPropriedadeSisbov := QueryLocal.FieldByName('cod_id_propriedade_sisbov').AsInteger;

        finally
          QueryLocal.Close;
        end;
      end;

      // Obtem o CNPJ do fabricante de identificadores
      if (CodFabricanteIdentificador > 0) then begin
        try
          QueryLocal.SQL.Clear;
          {$IFDEF MSSQL}
          QueryLocal.SQL.Add(' select num_cnpj_fabricante ');
          QueryLocal.SQL.Add(' from tab_fabricante_identificador ');
          QueryLocal.SQL.Add(' where cod_fabricante_identificador = :cod_fabricante_identificador');
          {$ENDIF}
          QueryLocal.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
          QueryLocal.Open;

          if QueryLocal.IsEmpty then
          begin
            EMensagens.Adicionar(1955, Self.ClassName, NomeMetodo, []);
            Result := -1955;
            Exit;
          end;
          NumCnpjFabricante := QueryLocal.FieldByName('num_cnpj_fabricante').AsString;

        finally
          QueryLocal.Close;
        end;
      end;

      Numeros := TStringList.Create;
      Identificacoes := TStringList.Create;
      try
        CodAnimais := StringReplace(CodAnimais, ' ', '', [rfReplaceAll]);
        CodAnimais := StringReplace(CodAnimais, ',0', '', [rfReplaceAll]);
        Numeros.DelimitedText := CodAnimais;

        CodIdentificacoes := StringReplace(CodIdentificacoes, ' ', '', [rfReplaceAll]);
        Identificacoes.DelimitedText := CodIdentificacoes;

        SetLength(CodigosSisbov, Numeros.Count);
        for QtdAnimais := 0 to Numeros.Count do begin
          CodigosSisbov[QtdAnimais] := NumeroReimpressaoDTO.Create;
          CodigosSisbov[QtdAnimais].numeroSisbov := Numeros[QtdAnimais];
          CodigosSisbov[QtdAnimais].tipoIdentificacao := StrToInt(Identificacoes[QtdAnimais]);
        end;
        QtdAnimais := Numeros.Count;
      finally
        Numeros.Free;
        Identificacoes.Free;
      end;

      // A quantidade de animais da OS deve ser maior que 0 e menor
      // que o limite de animais
      if (QtdAnimais < 1) or (QtdAnimais > cLimiteQtdAnimais) then
      begin
        EMensagens.Adicionar(1773, Self.ClassName, NomeMetodo, [IntToStr(cLimiteQtdAnimais)]);
        Result := -1773;
        Exit;
      end;

      // Obtem o sequencial da OS
      Result := ProximoCodigoSolicitacao(CodSolicitacaoReimpressao, EConexao, EMensagens);
      if Result < 0 then
      begin
        Exit;
      end;

      EConexao.BeginTran;

      // Insere a ordem de serviço na base de dados
      QueryLocal.SQL.Clear;
      QueryLocal.SQL.Add('insert into tab_solicitacao_reimpressao ');
      QueryLocal.SQL.Add('    (cod_solicitacao_reimpressao ');
      QueryLocal.SQL.Add('    ,cod_pessoa_produtor ');
      QueryLocal.SQL.Add('    ,cod_propriedade_rural ');
      QueryLocal.SQL.Add('    ,cod_fabricante_identificador ');
      QueryLocal.SQL.Add('    ,qtd_animais ');
      QueryLocal.SQL.Add('    ,dta_cadastramento ');
      QueryLocal.SQL.Add('    ,dta_ultima_alteracao ');
      QueryLocal.SQL.Add('    ,ind_transmissao_sisbov ');
      QueryLocal.SQL.Add('    ,cod_id_transacao_sisbov ');
      QueryLocal.SQL.Add('    ,num_solicitacao_sisbov ');
      QueryLocal.SQL.Add('    ,dta_solicitacao_sisbov) ');
      QueryLocal.SQL.Add('values ');
      QueryLocal.SQL.Add('    (:cod_solicitacao_reimpressao ');
      QueryLocal.SQL.Add('    ,:cod_pessoa_produtor ');
      QueryLocal.SQL.Add('    ,:cod_propriedade_rural ');
      QueryLocal.SQL.Add('    ,:cod_fabricante_identificador ');
      QueryLocal.SQL.Add('    ,:qtd_animais ');
      QueryLocal.SQL.Add('    ,getdate() ');
      QueryLocal.SQL.Add('    ,getdate() ');
      QueryLocal.SQL.Add('    ,''N'' ');
      QueryLocal.SQL.Add('    ,Null ');
      QueryLocal.SQL.Add('    ,Null ');
      QueryLocal.SQL.Add('    ,Null) ');

      QueryLocal.ParamByName('cod_solicitacao_reimpressao').AsInteger := CodSolicitacaoReimpressao;
      QueryLocal.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      QueryLocal.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      QueryLocal.ParamByName('cod_fabricante_identificador').AsInteger := CodFabricanteIdentificador;
      QueryLocal.ParamByName('qtd_animais').AsInteger := QtdAnimais;

      // Insereo registro
      QueryLocal.ExecSQL;

      QueryLocal.SQL.Clear;
      QueryLocal.SQL.Add('insert into tab_codigo_reimpressao ');
      QueryLocal.SQL.Add('    (cod_solicitacao_reimpressao ');
      QueryLocal.SQL.Add('    ,cod_pais_sisbov ');
      QueryLocal.SQL.Add('    ,cod_estado_sisbov ');
      QueryLocal.SQL.Add('    ,cod_micro_regiao_sisbov ');
      QueryLocal.SQL.Add('    ,cod_animal_sisbov ');
      QueryLocal.SQL.Add('    ,num_dv_sisbov ');
      QueryLocal.SQL.Add('    ,cod_identificacao ');
      QueryLocal.SQL.Add('    ,cod_pessoa_produtor ');
      QueryLocal.SQL.Add('    ,cod_propriedade_rural ');
      QueryLocal.SQL.Add('    ,des_situacao) ');
      QueryLocal.SQL.Add('values ');
      QueryLocal.SQL.Add('    (:cod_solicitacao_reimpressao ');
      QueryLocal.SQL.Add('    ,:cod_pais_sisbov ');
      QueryLocal.SQL.Add('    ,:cod_estado_sisbov ');
      QueryLocal.SQL.Add('    ,:cod_micro_regiao_sisbov ');
      QueryLocal.SQL.Add('    ,:cod_animal_sisbov ');
      QueryLocal.SQL.Add('    ,:num_dv_sisbov ');
      QueryLocal.SQL.Add('    ,:cod_identificacao ');
      QueryLocal.SQL.Add('    ,:cod_pessoa_produtor ');
      QueryLocal.SQL.Add('    ,:cod_propriedade_rural ');
      QueryLocal.SQL.Add('    ,Null) ');

      QueryLocal.ParamByName('cod_solicitacao_reimpressao').AsInteger := CodSolicitacaoReimpressao;
      QueryLocal.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      QueryLocal.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;

      for QtdAnimais := 0 to High(CodigosSisbov) do begin
        CodPais := StrToInt(Copy(CodigosSisbov[QtdAnimais].numeroSisbov, 1, 3));
        CodEstado := StrToInt(Copy(CodigosSisbov[QtdAnimais].numeroSisbov, 4, 2));
        CodMicroRegiao := StrToInt(Copy(CodigosSisbov[QtdAnimais].numeroSisbov, 6, 1));
        CodAnimal := StrToInt(Copy(CodigosSisbov[QtdAnimais].numeroSisbov, 7, Length(CodigosSisbov[QtdAnimais].numeroSisbov) -1));
        CodDV := StrToInt(Copy(CodigosSisbov[QtdAnimais].numeroSisbov, Length(CodigosSisbov[QtdAnimais].numeroSisbov) -1, 1));

        QueryLocal.ParamByName('cod_pais_sisbov').AsInteger := CodPais;
        QueryLocal.ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
        QueryLocal.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
        QueryLocal.ParamByName('cod_animal_sisbov').AsInteger := CodAnimal;
        QueryLocal.ParamByName('num_dv_sisbov').AsInteger := CodDV;
        QueryLocal.ParamByName('cod_identificacao').AsInteger := CodigosSisbov[QtdAnimais].tipoIdentificacao;

        QueryLocal.ExecSQL;
      end;

      EConexao.Commit;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1774, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1774;
      Exit;
    end;
  end;

  Result := -1;
  RetornoSisbov := nil;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  SoapSisbov := TIntSoapSisbov.Create;
  try
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Solicitação numeração reimpressão');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, NomeMetodo, [' não foi possível transmitir a solicitação de reimpressão ']);
        Result := -2289;
        Exit;
      end;

      RetornoSisbov := SoapSisbov.solicitarNumeracaoReimpressao(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , NumCnpjFabricante
                       , NumCpfProdutor
                       , NumCnpjProdutor
                       , CodPropriedadeSisbov
                       , QtdAnimais
                       , CodigosSisbov);

      If (RetornoSisbov <> nil) and (RetornoSisbov.Status = 1) then begin
        EConexao.BeginTran;
        QueryLocal.SQL.Clear;
        {$IFDEF MSSQL}
        QueryLocal.SQL.Add(' update tab_solicitacao_reimpressao  ');
        QueryLocal.SQL.Add('    set ind_transmissao_sisbov         = ''S''  ');
        QueryLocal.SQL.Add('      , cod_id_transacao_sisbov        = :cod_idtransacao  ');
        QueryLocal.SQL.Add('      , num_solicitacao_sisbov         = :num_solicitacao_sisbov  ');
        QueryLocal.SQL.Add('      , dta_solicitacao_sisbov         = getdate()  ');
        QueryLocal.SQL.Add('  where cod_solicitacao_reimpressao    = :cod_solicitacao_reimpressao ');
        {$ENDIF}
        QueryLocal.ParamByName('cod_solicitacao_reimpressao').AsInteger         := CodSolicitacaoReimpressao;
        QueryLocal.ParamByName('num_solicitacao_sisbov').AsInteger    := RetornoSisbov.numeroSolicitacao;
        QueryLocal.ParamByName('cod_idtransacao').AsInteger           := RetornoSisbov.idTransacao;

        QueryLocal.ExecSQL;
        EConexao.Commit;
      end else begin
        EConexao.Rollback;
        Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [RetornoSisbov.listaErros[0].menssagemErro]);
        Result := -2290;
        Exit;
      end;

      RetornoConsulta := SoapSisbov.consultarNumeracaoReimpressao(
                         Descriptografar(ValorParametro(118))
                       , Descriptografar(ValorParametro(119))
                       , CodSolicitacaoReimpressao);

      If (RetornoConsulta <> nil) and (RetornoConsulta.Status = 1) then begin
        EConexao.beginTran;
        QueryLocal.SQL.Clear;
        QueryLocal.SQL.Add(' update tab_codigo_reimpressao ');
        QueryLocal.SQL.Add('    set des_situacao = :des_situacao ');
        QueryLocal.SQL.Add(' where ');
        QueryLocal.SQL.Add('    cod_solicitacao_reimpressao = :cod_solicitacao_reimpressao and ');
        QueryLocal.SQL.Add('    cod_pais_sisbov = :cod_pais_sisbov and ');
        QueryLocal.SQL.Add('    cod_estado_sisbov = :cod_estado_sisbov and ');
        QueryLocal.SQL.Add('    cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov and ');
        QueryLocal.SQL.Add('    cod_animal_sisbov = :cod_animal_sisbov and ');
        QueryLocal.SQL.Add('    num_dv_sisbov = :num_dv_sisbov ');

        QueryLocal.ParamByName('cod_solicitacao_reimpressao').AsInteger := CodSolicitacaoReimpressao;

        for QtdAnimais := 0 to High(RetornoConsulta.numeracoes) do begin
          CodPais := StrToInt(Copy(RetornoConsulta.numeracoes[QtdAnimais].numero, 1, 3));
          CodEstado := StrToInt(Copy(RetornoConsulta.numeracoes[QtdAnimais].numero, 4, 2));
          CodMicroRegiao := StrToInt(Copy(RetornoConsulta.numeracoes[QtdAnimais].numero, 6, 1));
          CodAnimal := StrToInt(Copy(RetornoConsulta.numeracoes[QtdAnimais].numero, 7, Length(RetornoConsulta.numeracoes[QtdAnimais].numero) -1));
          CodDV := StrToInt(Copy(RetornoConsulta.numeracoes[QtdAnimais].numero, Length(RetornoConsulta.numeracoes[QtdAnimais].numero) -1, 1));

          QueryLocal.ParamByName('cod_pais_sisbov').AsInteger := CodPais;
          QueryLocal.ParamByName('cod_estado_sisbov').AsInteger := CodEstado;
          QueryLocal.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiao;
          QueryLocal.ParamByName('cod_animal_sisbov').AsInteger := CodAnimal;
          QueryLocal.ParamByName('num_dv_sisbov').AsInteger := CodDV;
          QueryLocal.ParamByName('des_situacao').AsString := RetornoConsulta.numeracoes[QtdAnimais].descricao;

          QueryLocal.ExecSQL;
        end;
        EConexao.Commit;
      end else begin
        EConexao.Rollback;
        Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, [RetornoConsulta.listaErros[0].menssagemErro]);
        Result := -2290;
        Exit;
      end;
    except
      on E: Exception do
      begin
        Mensagens.Adicionar(2290, Self.ClassName, NomeMetodo, ['']);
        Result := -2290;
      end;
    end;
  finally
    RetornoSisbov.Free;
    RetornoConsulta.Free;
    SoapSisbov.Free;
  end;
  Result := CodSolicitacaoReimpressao;
end;

class function TIntSolicitacoesReimpressao.ObtemValorSequencial(
  EConexao: TConexao; EMensagens: TIntMensagens; NomeCampo: String;
  var ValorCampo: Integer): Integer;
const
  NomeMetodo = 'ObtemValorSequencial';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(EConexao, nil);
    try
      with QueryLocal do
      begin
        // Inicia uma transação separada para a obtenção do proximo código da OS
        EConexao.BeginTran('OBTER_PROXIMO_CODIGO_SOLICITACAO');

        // Atualiza os códigos
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('update tab_seq_solicitacao_reimpressao ');
        SQL.Add('   set ' + NomeCampo + ' = ' + NomeCampo + ' + 1');
{$ENDIF}
        ExecSQL;

        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('select ' + NomeCampo + ' from tab_seq_solicitacao_reimpressao');
{$ENDIF}
        Open;

        If IsEmpty Then Begin
          EConexao.Rollback('OBTER_PROXIMO_CODIGO_SOLICITACAO');
          EMensagens.Adicionar(1775, Self.ClassName, NomeMetodo, ['Tabela vazia']);
          Result := -1775;
          Exit;
        End;

        ValorCampo := FieldByName(nomeCampo).AsInteger;
        Close;

        // Confirma Transação
        EConexao.Commit('OBTER_PROXIMO_CODIGO_SOLICITACAO');
        Result := 0;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback('OBTER_PROXIMO_CODIGO_SOLICITACAO');
      EMensagens.Adicionar(1775, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1775;
      Exit;
    end;
  end;
end;

class function TIntSolicitacoesReimpressao.ObterProximoNumero(EConexao: TConexao; EMensagens: TIntMensagens): Integer;
const
  NomeMetodo = 'ObterProximoCodigo';
var
  ParObterCodigoAutomatico: String;
  ValProximoSolicitacao: Integer;
begin
  // Verifica se usuário pode executar método
  if not EConexao.PodeExecutarMetodo(550) then
  begin
    EMensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    // Busca o parametro
    ParObterCodigoAutomatico := EConexao.ValorParametro(78, EMensagens);

    // Verifica se a geração do código é automatica ou manual
    if UpperCase(ParObterCodigoAutomatico) = 'S' then
    begin // Geração automática
      Result := ProximoNumeroSolicitacao(ValProximoSolicitacao, EConexao, EMensagens);
      if Result >= 0 then
        Result := ValProximoSolicitacao;
    end
    else
    begin // Geração Manual
      Result := 0;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(1776, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1776;
      Exit;
    end;
  end;
end;

class function TIntSolicitacoesReimpressao.ProximoCodigoSolicitacao(
  var ValProximoSolicitacao: Integer; Conexao: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  Result := ObtemValorSequencial(Conexao, Mensagens,
    'cod_seq_solicitacao_reimpressao', ValProximoSolicitacao);
end;

class function TIntSolicitacoesReimpressao.ProximoNumeroSolicitacao(
  var ValProximoSolicitacao: Integer; Conexao: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  Result := ObtemValorSequencial(Conexao, Mensagens,
    'num_seq_solicitacao_reimpressao', ValProximoSolicitacao);
end;

function TIntSolicitacoesReimpressao.SolicitacaoReimpressao: TIntSolicitacoesReimpressao;
const
  NomeMetodo = 'SolicitacaoReimpressao';
begin
  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
  end;
  Result := FSolicitacoesReimpressao;
end;

end.
