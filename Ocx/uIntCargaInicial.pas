unit uIntCargaInicial;

interface

{$DEFINE MSSQL}

uses uIntClassesBasicas, dbtables, sysutils, db, uFerramentas, FileCtrl,
     uColecoes, uIntMensagens, Classes;

type
  { TIntArquivoPropriedade }
  TIntArquivoPropriedade = class (TIntArquivoSISBOV)
  private
  public
    constructor Create; override;
  end;

  { TIntArquivoCodigoSISBOV }
  TIntArquivoCodigoSISBOV = class (TIntArquivoSISBOV)
  private
  public
    constructor Create; override;
  end;

  { TIntArquivoCodigoSISBOV }
  TIntArquivoAnimal = class (TIntArquivoSISBOV)
  private
  public
    constructor Create; override;
  end;

  { TIntCargaInicial }
  TIntCargaInicial = class(TIntClasseBDNavegacaoBasica)
  private
    procedure GravarArquivoPropriedadeErro(Arquivo: TIntArquivoPropriedade;
      LinhasPropriedade: TStringList; NomeArquivo: String);
    procedure GravarArquivoAnimaisErro(Arquivo: TIntArquivoAnimal;
      LinhasAnimal: TStringList; NomeArquivo: String);
    procedure GravarArquivoCodSISBOVErro(Linha, NomeArquivo: String);
    function InserirArquivoSISBOV(CodTipoArq: Integer): Integer;
    procedure PreparaDadosBaseDados;
    procedure FinalizaDadosBaseDados;
  public
    function ImportarPropriedades(NomeArquivoAbsoluto: String): Integer;
    function ImportarCodigosSISBOV(NomeArquivoAbsoluto: String): Integer;
    function ImportarAnimais(NomeArquivoAbsoluto: String): Integer;
  end;

const
  // -----------------
  PROP_0_TIPO_REG = 0;
  PROP_0_CNPJ     = 1;

  PROP_1_TIPO_REG            = 0;
  PROP_1_NOME                = 1;
  PROP_1_TIPO_INSCRICAO      = 2;
  PROP_1_NIRF                = 3;
  PROP_1_CODIGO              = 4;
  PROP_1_DT_INI_CERTIFICADO  = 5;
  PROP_1_LATITUDE            = 6;
  PROP_1_LONGITUDE           = 7;
  PROP_1_AREA                = 8;
  PROP_1_PESSOA_CONTATO      = 9;
  PROP_1_TELEFONE            = 10;
  PROP_1_FAX                 = 11;
  PROP_1_LOGRADOURO          = 12;
  PROP_1_BAIRRO              = 13;
  PROP_1_CEP                 = 14;
  PROP_1_MUNICIPIO           = 15;
  PROP_1_UF_MUNICIPIO        = 16;
  PROP_1_LOGRADOURO_CORR     = 17;
  PROP_1_BAIRRO_CORR         = 18;
  PROP_1_CEP_CORR            = 19;
  PROP_1_MUNICIPIO_CORR      = 20;
  PROP_1_UF_MUNICIPIO_CORR   = 21;

  PROP_2_TIPO_REG               = 0;
  PROP_2_TIPO_PROPRIETARIO      = 1;
  PROP_2_CPF_CNPJ               = 2;
  PROP_2_NOME                   = 3;
  PROP_2_LOGRADOURO             = 4;
  PROP_2_BAIRRO                 = 5;
  PROP_2_CEP                    = 6;
  PROP_2_MUNICIPIO              = 7;
  PROP_2_UF_MUNICIPIO           = 8;
  PROP_2_INDICADOR_PROPRIETARIO = 9;

  PROP_3_TIPO_REG               = 0;
  PROP_3_TIPO_CONTATO           = 1;
  PROP_3_VALOR                  = 2;

  PROP_9_TIPO_REG     = 0;
  PROP_9_TIPO_1       = 1;
  PROP_9_QUANTIDADE_1 = 2;
  PROP_9_TIPO_2       = 3;
  PROP_9_QUANTIDADE_2 = 4;
  PROP_9_TIPO_3       = 5;
  PROP_9_QUANTIDADE_3 = 6;

  // -----------------
  COD_0_TIPO_REG  = 0;
  COD_0_CNPJ      = 1;

  COD_1_TIPO_REG                      = 0;
  COD_1_NR_SISBOV                     = 1;
  COD_1_SITUACAO                      = 2;
  COD_1_TIPO_INSCRICAO_RESERVA        = 3;
  COD_1_NIRF_INCRA_RESERVA            = 4;
  COD_1_CODIGO_RESERVA                = 5;
  COD_1_TIPO_PROPRIETARIO_RESERVA     = 6;
  COD_1_CPF_CNPJ_RESERVA              = 7;
  COD_1_NM_PROPRIETARIO_RESERVA       = 8;
  COD_1_NR_SOLICITACAO                = 15;
  COD_1_DT_SOLICITACAO                = 16;

  // -----------------
  ANI_0_TIPO_REG  = 0;
  ANI_0_CNPJ      = 1;

  ANI_1_TIPO_REG                   = 0;
  ANI_1_ESPECIE                    = 1;
  ANI_1_NR_SISBOV                  = 2;
  ANI_1_DT_IDENTIFICACAO           = 3;
  ANI_1_TIPO_DUPLA_IDENTIFICACAO   = 4;
  ANI_1_CODIGO_RACA                = 5;
  ANI_1_DATA_NASCIMENTO            = 6;
  ANI_1_SEXO                       = 7;
  ANI_1_APTIDAO                    = 8;
  ANI_1_TIPO_INSCRICAO_NASCIMENTO  = 9;
  ANI_1_NIRF_INCRA_NASCIMENTO      = 10;
  ANI_1_CODIGO_NASCIMENTO          = 11;
  ANI_1_TIPO_INSCRICAO_RESPONSAVEL = 12;
  ANI_1_NIRF_INCRA_RESPONSAVEL     = 13;
  ANI_1_CODIGO_RESPONSAVEL         = 14;
  ANI_1_NR_ASSOCIACAO              = 15;
  ANI_1_NR_CERTIFICADORA           = 16;
  ANI_1_NR_SISBOV_MAE              = 17;
  ANI_1_NR_SISBOV_PAI              = 18;
  ANI_1_DT_MORTE                   = 19;
  ANI_1_TIPO_MORTE                 = 20;
  ANI_1_CAUSA_MORTE                = 21;
  ANI_1_CS_LOCALIZACAO_ATUAL       = 22;
  ANI_1_ID_LOCALIZACAO_ATUAL       = 23;
  ANI_1_DT_INCLUSAO_SISTEMA        = 24;

  ANI_2_TIPO_REG               = 0;
  ANI_2_CS_ORIGEM              = 1;
  ANI_2_TIPO_INSCRICAO_ORIEM   = 2;
  ANI_2_ID_ORIGEM              = 3;
  ANI_2_DT_EMISSAO             = 4;
  ANI_2_DT_SAIDA               = 5;
  ANI_2_DT_CHEGADA             = 6;
  ANI_2_CS_DESTINO             = 7;
  ANI_2_TIPO_INSCRICAO_DESTINO = 8;
  ANI_2_ID_DESTINO             = 9;

implementation

uses uIntPessoas, uIntPropriedadesRurais, uIntFazendas, uIntPessoasContatos,
  SqlExpr, uIntCodigosSISBOV, uIntAnimais, uIntEventos;

{ TIntCargaInicial }

{ Grava as linhas propriedade que deu erro no arquivo de erro.
  Grava todas as linhas do tipo 1, 2 e 3.

Parametros:
  Arquivo: Arquivo que esta sendo processado.
  LinhasPropriedade: Linhas já lidas da propriedade.
  NomeArquivo: Nome absoluto do arquivo que esta sendo processado.}
procedure TIntCargaInicial.GravarArquivoPropriedadeErro(
  Arquivo: TIntArquivoPropriedade; LinhasPropriedade: TStringList;
  NomeArquivo: String);
var
  ArqErro: TextFile;
  NomeArqErro: String;
  I: Integer;
begin
  Arquivo.LerLinha;
  while not (Arquivo.TipoLiha in [1, 9]) do
  begin
    LinhasPropriedade.Add(Arquivo.Linha);
    Arquivo.LerLinha;
  end;

  NomeArqErro := Copy(NomeArquivo, 1, Length(NomeArquivo) - 4) + '.ERR';
  AssignFile(ArqErro, NomeArqErro);
  if FileExists(NomeArqErro) then
  begin
    Append(ArqErro);
  end
  else
  begin
    Rewrite(ArqErro);
  end;

  for I := 0 to LinhasPropriedade.Count - 1 do
  begin
    WriteLn(ArqErro, LinhasPropriedade[I]);
  end;

  Closefile(ArqErro);
end;

procedure TIntCargaInicial.GravarArquivoAnimaisErro(
  Arquivo: TIntArquivoAnimal; LinhasAnimal: TStringList;
  NomeArquivo: String);
var
  ArqErro: TextFile;
  NomeArqErro: String;
  I: Integer;
begin
  Arquivo.LerLinha;
  while not (Arquivo.TipoLiha in [1, 9]) do
  begin
    LinhasAnimal.Add(Arquivo.Linha);
    Arquivo.LerLinha;
  end;

  NomeArqErro := Copy(NomeArquivo, 1, Length(NomeArquivo) - 4) + '.ERR';
  AssignFile(ArqErro, NomeArqErro);
  if FileExists(NomeArqErro) then
  begin
    Append(ArqErro);
  end
  else
  begin
    Rewrite(ArqErro);
  end;

  for I := 0 to LinhasAnimal.Count - 1 do
  begin
    WriteLn(ArqErro, LinhasAnimal[I]);
  end;

  Closefile(ArqErro);
end;

{ Grava no arquivo de erro a linha que não foi processada com sucesso.

Parametros:
  Linha: Linha que não foi processada com sucesso.
  NomeArquivo: Nome do arquivo que não foi processado com sucesso.}
procedure TIntCargaInicial.GravarArquivoCodSISBOVErro(Linha,
  NomeArquivo: String);
var
  ArqErro: TextFile;
  NomeArqErro: String;
begin
  NomeArqErro := Copy(NomeArquivo, 1, Length(NomeArquivo) - 4) + '.ERR';
  AssignFile(ArqErro, NomeArqErro);
  if FileExists(NomeArqErro) then
  begin
    Append(ArqErro);
  end
  else
  begin
    Rewrite(ArqErro);
  end;

  WriteLn(ArqErro, Linha);

  Closefile(ArqErro);
end;

{ Importa o cadastro dos produtores, propriedades e fazendas do arquivo gerado
  pelo SISBOV. Caso ocorra algum erro em algum registro todos os registros da
  propriedade são gravados em um  arquivo com o mesmo nome do arquivo, mas com a
  extensão .ERR.

Parametros:
  NomeArquivoAbsoluto: Nome Absoluto (com a pasta) do arquivo de improtação.

Retorno:
  = 0 se der tudo certo
  < 0 se ocorre algum erro}
function TIntCargaInicial.ImportarPropriedades(
  NomeArquivoAbsoluto: String): Integer;
const
  NomeMetodo: String = 'ImportarPropriedades';
var
  Arquivo: TIntArquivoPropriedade;
  LinhasPropriedade: TStringList;
  Propriedades: TIntPropriedadesRurais;
  Fazendas: TIntFazendas;
  Pessoas: TIntPessoas;
  Contatos: TIntPessoasContatos;
  LerProximaLinha: Boolean;
  CodPropriedade,
  CodFazenda,
  CodPessoa,
  ContSglProdutor: Integer;
  NomeFazenda,
  CodLocalizacao: String;
  CodArquivoSISBOVPropriedade,
  CodArquivoSISBOVProdutor: Integer;
begin
  Result := -1;
  CodPessoa := -1;
  CodPropriedade := -1;
  LerProximaLinha := True;
  ContSglProdutor := 0;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Inicializa o arquivo.
  Arquivo := TIntArquivoPropriedade.Create;
  LinhasPropriedade := TStringList.Create;
  Propriedades := TIntPropriedadesRurais.Create;
  Fazendas := TIntFazendas.Create;
  Pessoas := TIntPessoas.Create;
  Contatos := TIntPessoasContatos.Create;
  try
    Propriedades.Inicializar(Conexao, Mensagens);
    Fazendas.Inicializar(Conexao, Mensagens);
    Pessoas.Inicializar(Conexao, Mensagens);
    Contatos.Inicializar(Conexao, Mensagens);

    BeginTran;
    try
      CodArquivoSISBOVPropriedade := InserirArquivoSISBOV(1);
      CodArquivoSISBOVProdutor := InserirArquivoSISBOV(7);
      Commit;
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2080;
        Exit;
      end;
    end;

    Arquivo.Abrir(NomeArquivoAbsoluto);
    Arquivo.LerLinha;
    // Percorre o arquivo
    while not Arquivo.Eof do
    begin
      try
        LerProximaLinha := True;

        case Arquivo.TipoLiha of
          0: begin
            // Verificar se é a certificadora correta
          end;
          1: begin
            // Se a transação estiver aberto então da um commit
            if EmTransacao then
            begin
              Commit;
            end;

            // Inicia uma nova transação.
            BeginTran;
            LinhasPropriedade.Clear;
            LinhasPropriedade.Add(Arquivo.Linha);

            // Insere a propriedade
            CodPropriedade := Propriedades.InserirPropriedadeCargaInicial(
              Arquivo.ValorAtributo(PROP_1_NOME),
              Arquivo.ValorAtributo(PROP_1_NIRF),
              Arquivo.ValorAtributo(PROP_1_LATITUDE),
              Arquivo.ValorAtributo(PROP_1_LONGITUDE),
              Arquivo.ValorAtributo(PROP_1_AREA),
              Arquivo.ValorAtributo(PROP_1_LOGRADOURO),
              Arquivo.ValorAtributo(PROP_1_BAIRRO),
              Arquivo.ValorAtributo(PROP_1_CEP),
              Arquivo.ValorAtributo(PROP_1_UF_MUNICIPIO),
              Arquivo.ValorAtributo(PROP_1_MUNICIPIO),
              Arquivo.ValorAtributo(PROP_1_PESSOA_CONTATO),
              Arquivo.ValorAtributo(PROP_1_TELEFONE),
              Arquivo.ValorAtributo(PROP_1_FAX),
              Arquivo.ValorAtributo(PROP_1_LOGRADOURO_CORR),
              Arquivo.ValorAtributo(PROP_1_BAIRRO_CORR),
              Arquivo.ValorAtributo(PROP_1_CEP_CORR),
              Arquivo.ValorAtributo(PROP_1_UF_MUNICIPIO_CORR),
              Arquivo.ValorAtributo(PROP_1_MUNICIPIO_CORR),
              Arquivo.ValorAtributo(PROP_1_TIPO_INSCRICAO),
              Arquivo.ValorAtributo(PROP_1_DT_INI_CERTIFICADO));
            if CodPropriedade < 0 then
            begin
              raise EHerdomException.Create(CodPropriedade, Self.ClassName,
                NomeMetodo, [], True);
            end;

            NomeFazenda    := Arquivo.ValorAtributo(PROP_1_NOME);
            CodLocalizacao := Arquivo.ValorAtributo(PROP_1_CODIGO);
          end;
          2: begin
            LinhasPropriedade.Add(Arquivo.Linha);

            Inc(ContSglProdutor);
            CodPessoa := Pessoas.InserirProdutorCargaInicial(
              CodArquivoSISBOVProdutor,
              PadL(IntToStr(ContSglProdutor), '0', 3),
              Arquivo.ValorAtributo(PROP_2_NOME),
              Arquivo.ValorAtributo(PROP_2_TIPO_PROPRIETARIO),
              Arquivo.ValorAtributo(PROP_2_CPF_CNPJ),
              Arquivo.ValorAtributo(PROP_2_LOGRADOURO),
              Arquivo.ValorAtributo(PROP_2_BAIRRO),
              Arquivo.ValorAtributo(PROP_2_CEP),
              Arquivo.ValorAtributo(PROP_2_UF_MUNICIPIO),
              Arquivo.ValorAtributo(PROP_2_MUNICIPIO));
            if CodPessoa < 0 then
            begin
              raise EHerdomException.Create(CodPessoa, Self.ClassName,
                NomeMetodo, [], True);
            end;

            CodFazenda := Fazendas.InserirFazendaCargaInicial(
              CodArquivoSISBOVPropriedade,
              CodPropriedade,
              CodPessoa,
              NomeFazenda,
              Arquivo.ValorAtributo(PROP_2_INDICADOR_PROPRIETARIO),
              CodLocalizacao);
            if CodFazenda < 0 then
            begin
              raise EHerdomException.Create(CodFazenda, Self.ClassName,
                NomeMetodo, [], True);
            end;
          end;
          3: begin
            LinhasPropriedade.Add(Arquivo.Linha);

            Contatos.InserirContatoCargaInicial(
              CodPessoa,
              Arquivo.ValorAtributo(PROP_3_TIPO_CONTATO),
              Arquivo.ValorAtributo(PROP_3_VALOR));
          end;
        end;
        
        // Se a transação estiver aberto então da um commit
        if EmTransacao then
        begin
          Commit;
        end;
      except
        on E: EHerdomException do
        begin
          Rollback;
          GravarArquivoPropriedadeErro(Arquivo, LinhasPropriedade,
            NomeArquivoAbsoluto);
          LerProximaLinha := False;
          E.gerarMensagem(Mensagens);
        end;
        on E: Exception do
        begin
          Rollback;
          GravarArquivoPropriedadeErro(Arquivo, LinhasPropriedade,
            NomeArquivoAbsoluto);
          LerProximaLinha := False;
          Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
        end;
      end;

      if LerProximaLinha then
      begin
        Arquivo.LerLinha;
      end;
    end;
  finally
    Arquivo.Free;
    LinhasPropriedade.Free;
    Propriedades.Free;
    Fazendas.Free;
    Pessoas.Free;
    Contatos.Free;
  end;
end;

{ Importa o cadastro dos codigos SISBOV.

Parametros:
  NomeArquivoAbsoluto: Nome Absoluto (com a pasta) do arquivo de improtação.

Retorno:
  = 0 se der tudo certo
  < 0 se ocorre algum erro}
function TIntCargaInicial.ImportarCodigosSISBOV(
  NomeArquivoAbsoluto: String): Integer;
const
  NomeMetodo: String = 'ImportarCodigosSISBOV';
var
  Arquivo: TIntArquivoCodigoSISBOV;
  CodigosSISBOV: TIntCodigosSisbov;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    Arquivo := TIntArquivoCodigoSISBOV.Create;
    CodigosSISBOV := TIntCodigosSisbov.Create;
    try
      CodigosSISBOV.Inicializar(Conexao, Mensagens);
      Arquivo.Abrir(NomeArquivoAbsoluto);
      Arquivo.LerLinha;
      BeginTran;
      while not Arquivo.Eof do
      begin
        try
          if Arquivo.TipoLiha = 1 then
          begin
            // Se o código estiver cancelado não insere
            if Pos('CANCELADO', UpperCase(Arquivo.ValorAtributo(COD_1_SITUACAO))) = 0 then
            begin
              CodigosSISBOV.InserirCodigoSISBOVCargaInicial(
                Arquivo.ValorAtributo(COD_1_NR_SISBOV),
                Arquivo.ValorAtributo(COD_1_NIRF_INCRA_RESERVA),
                Arquivo.ValorAtributo(COD_1_CODIGO_RESERVA),
                Arquivo.ValorAtributo(COD_1_CPF_CNPJ_RESERVA),
                '',
                '',
                '',
                Arquivo.ValorAtributo(COD_1_NR_SOLICITACAO),
                Arquivo.ValorAtributo(COD_1_DT_SOLICITACAO));
            end;
          end;
        except
          on E: EHerdomException do
          begin
            GravarArquivoCodSISBOVErro(Arquivo.Linha, NomeArquivoAbsoluto);
            E.gerarMensagem(Mensagens);
            Result := -E.CodigoErro;
          end;
          on E: Exception do
          begin
            GravarArquivoCodSISBOVErro(Arquivo.Linha, NomeArquivoAbsoluto);
            Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
            Result := -2080;
          end;
        end;

        Arquivo.LerLinha;
      end;
      Commit;
    finally
      Arquivo.Free;
    end;
  except
    on E: EHerdomException do
    begin
      Rollback;
      E.gerarMensagem(Mensagens);
      Result := -E.CodigoErro;
      Exit;
    end;
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2080;
      Exit;
    end;
  end;
end;

{ Insere os animais e os eventos dos animais na base de dados. }
function TIntCargaInicial.ImportarAnimais(
  NomeArquivoAbsoluto: String): Integer;
const
  NomeMetodo: String = 'ImportarAnimais';
var
  Arquivo: TIntArquivoAnimal;
  Animais: TIntAnimais;
  Eventos: TIntEventos;
  CodPessoaProdutor,
  CodFazenda,
  CodAptidao,
  CodAnimal,
  CodEvento,
  CodArquivoSISBOV,
  CodArquivoSISBOVEventos: Integer;
  NomeProdutor,
  StrDtaMorte,
  CausaMorte,
  TipoMorte: String;
  EventoAplicado: Boolean;
  LinhasAnimal: TStringList;
begin
  Result := -1;
  CodAnimal := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    Arquivo := TIntArquivoAnimal.Create;
    Animais := TIntAnimais.Create;
    Eventos := TIntEventos.Create;
    LinhasAnimal := TStringList.Create;
    try
      CodArquivoSISBOV := InserirArquivoSISBOV(2);
      CodArquivoSISBOVEventos := InserirArquivoSISBOV(4);
      Animais.Inicializar(Conexao, Mensagens);
      Eventos.Inicializar(Conexao, Mensagens);

      Arquivo.Abrir(NomeArquivoAbsoluto);
      Arquivo.LerLinha;
      EventoAplicado := False;
      
      PreparaDadosBaseDados;

      while not Arquivo.Eof do
      begin
        try
          case Arquivo.TipoLiha of
            1: begin
              // Aplica o evento de morte
              if (Trim(StrDtaMorte) <> '') and (not EventoAplicado) then
              begin
                // Define o produtor de trabalho
                Conexao.DefinirProdutorTrabalho(CodPessoaProdutor, NomeProdutor);

                // Insere o evento
                CodEvento := Eventos.InserirEventoCargaInicial(
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  StrDtaMorte,
                  TipoMorte,
                  CausaMorte,
                  CodFazenda,
                  CodAptidao
                );

                if CodEvento < 0 then
                begin
                  raise EHerdomException.Create(-CodEvento, '', '', [], True);
                end;

                // Aplica o evento no animal inserido
                Result := Animais.AplicarEvento(IntToStr(CodAnimal), -1,
                  '', -1, -1, CodEvento, 'N');
                if Result < 0 then
                begin
                  raise EHerdomException.Create(0, '', '', [], True);
                end;
              end;

              EventoAplicado := False;
              StrDtaMorte := '';
              TipoMorte   := '';
              CausaMorte  := '';

              // Se a transação estiver aberto então da um commit
              if EmTransacao then
              begin
                Commit;
              end;

              // Inicia uma nova transação.
              BeginTran;
              LinhasAnimal.Clear;
              LinhasAnimal.Add(Arquivo.Linha);

              CodAnimal := Animais.InserirAnimalCargaInicial(
                CodArquivoSISBOV,
                Arquivo.ValorAtributo(ANI_1_ESPECIE),
                Arquivo.ValorAtributo(ANI_1_NR_SISBOV),
                Arquivo.ValorAtributo(ANI_1_DT_IDENTIFICACAO),
                Arquivo.ValorAtributo(ANI_1_TIPO_DUPLA_IDENTIFICACAO),
                Arquivo.ValorAtributo(ANI_1_CODIGO_RACA),
                Arquivo.ValorAtributo(ANI_1_DATA_NASCIMENTO),
                Arquivo.ValorAtributo(ANI_1_SEXO),
                Arquivo.ValorAtributo(ANI_1_APTIDAO),
                Arquivo.ValorAtributo(ANI_1_NIRF_INCRA_NASCIMENTO),
                Arquivo.ValorAtributo(ANI_1_CODIGO_NASCIMENTO),
                Arquivo.ValorAtributo(ANI_1_NR_ASSOCIACAO),
                Arquivo.ValorAtributo(ANI_1_NR_CERTIFICADORA),
                Arquivo.ValorAtributo(ANI_1_DT_INCLUSAO_SISTEMA),
                CodPessoaProdutor,
                CodFazenda,
                CodAptidao);
              if CodAnimal < 0 then
              begin
                raise EHerdomException.Create(0, '', '', [], True);
              end;

              StrDtaMorte := Arquivo.ValorAtributo(ANI_1_DT_MORTE);
              TipoMorte := Arquivo.ValorAtributo(ANI_1_TIPO_MORTE);
              CausaMorte := Arquivo.ValorAtributo(ANI_1_CAUSA_MORTE);
            end;
            2: begin
              EventoAplicado := True;
              LinhasAnimal.Add(Arquivo.Linha);

              // Define o produtor de trabalho
              Conexao.DefinirProdutorTrabalho(CodPessoaProdutor, NomeProdutor);

              // Insere o evento
              CodEvento := Eventos.InserirEventoCargaInicial(
                Arquivo.ValorAtributo(ANI_2_DT_SAIDA),
                Arquivo.ValorAtributo(ANI_2_DT_CHEGADA),
                Arquivo.ValorAtributo(ANI_2_DT_EMISSAO),
                Arquivo.ValorAtributo(ANI_2_CS_ORIGEM),
                Arquivo.ValorAtributo(ANI_2_TIPO_INSCRICAO_ORIEM),
                Arquivo.ValorAtributo(ANI_2_ID_ORIGEM),
                Arquivo.ValorAtributo(ANI_2_CS_DESTINO),
                Arquivo.ValorAtributo(ANI_2_TIPO_INSCRICAO_DESTINO),
                Arquivo.ValorAtributo(ANI_2_ID_DESTINO),
                '',
                '',
                '',
                CodFazenda,
                CodAptidao
              );
              if CodEvento < 0 then
              begin
                raise EHerdomException.Create(0, '', '', [], True);
              end;

              // Aplica o evento no animal inserido
              Result := Animais.AplicarEvento(IntToStr(CodAnimal), -1,
                '', -1, -1, CodEvento, 'N');
              if Result < 0 then
              begin
                raise EHerdomException.Create(0, '', '', [], True);
              end;
            end;
          end;
          Arquivo.LerLinha;
       except
          on E: EHerdomException do
          begin
            Rollback;
            StrDtaMorte := '';
            TipoMorte   := '';
            CausaMorte  := '';
            GravarArquivoAnimaisErro(Arquivo, LinhasAnimal,
              NomeArquivoAbsoluto);
            E.gerarMensagem(Mensagens);
          end;
          on E: Exception do
          begin
            Rollback;
            StrDtaMorte := '';
            TipoMorte   := '';
            CausaMorte  := '';
            GravarArquivoAnimaisErro(Arquivo, LinhasAnimal,
              NomeArquivoAbsoluto);
            Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
          end;
        end;
      end;
      Commit;

      // Efetiva os eventos inseridos
      Result := Eventos.EfetivarEventosCargaInicial(CodArquivoSISBOVEventos);
      if Result < 0 then
      begin
        raise EHerdomException.Create(0, '', '', [], True);
      end;

      FinalizaDadosBaseDados;
    finally
      Arquivo.Free;
      LinhasAnimal.Free;
      Animais.Free;
      Eventos.Free;
    end;

    Result := 0;
  except
    on E: EHerdomException do
    begin
      Rollback;
      E.gerarMensagem(Mensagens);
      Result := -E.CodigoErro;

      try
        FinalizaDadosBaseDados;
      except
        on E1: EHerdomException do
        begin
          E1.gerarMensagem(Mensagens);
        end;
      end;
      Exit;
    end;
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(2080, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2080;

      try
        FinalizaDadosBaseDados;
      except
        on E1: EHerdomException do
        begin
          E1.gerarMensagem(Mensagens);
        end;
      end;
      Exit;
    end;
  end;
end;

{ Insere um arquivo de exportação para o SISBOV.

Parametros:
  CodTipoArq: Tipo do arquivo SISBOV Produtor ou Propriedade

Excessões:
  Exception: Caso ocorra algum erro}
function TIntCargaInicial.InserirArquivoSISBOV(
  CodTipoArq: Integer): Integer;
const
  NomeMetodo: String = 'InserirArquivoSISBOV';
var
  QueryLocal: THerdomQuery;
  CodArquivoSISBOV: Integer;
  NomeArquivo: String;
begin
  QueryLocal := THerdomQuery.Create(Conexao, nil);
  try
    with QueryLocal do
    begin
      SQL.Clear;
      SQL.Add('select IsNull(max(cod_arquivo_sisbov), 0) + 1 as cod_arquivo_sisbov');
      SQL.Add('  from tab_arquivo_sisbov');
      Open;
      CodArquivoSISBOV := FieldByName('cod_arquivo_sisbov').AsInteger;
    end;

    with QueryLocal do
    begin
      SQL.Clear;
      SQL.Add('select txt_prefixo_nome_arquivo');
      SQL.Add('  from tab_tipo_arquivo_sisbov');
      SQL.Add(' where cod_tipo_arquivo_sisbov = :cod_tipo_arquivo_sisbov');
      ParamByName('cod_tipo_arquivo_sisbov').AsInteger := CodTipoArq;
      Open;
      NomeArquivo := FieldByName('txt_prefixo_nome_arquivo').AsString + '_' +
        StrZero(CodArquivoSISBOV, 5) + '.TXT';
    end;

    with QueryLocal do
    begin
      SQL.Clear;
      SQL.Add('insert into tab_arquivo_sisbov (');
      SQL.Add('  cod_arquivo_sisbov,');
      SQL.Add('  nom_arquivo_sisbov,');
      SQL.Add('  dta_criacao_arquivo,');
      SQL.Add('  qtd_bytes_arquivo,');
      SQL.Add('  cod_tipo_arquivo_sisbov,');
      SQL.Add('  ind_possui_log_erro,');
      SQL.Add('  cod_usuario');
      SQL.Add(') values (');
      SQL.Add('  :cod_arquivo_sisbov,');
      SQL.Add('  :nom_arquivo_sisbov,');
      SQL.Add('  getDate(),');
      SQL.Add('  0,');
      SQL.Add('  :cod_tipo_arquivo_sisbov,');
      SQL.Add('  ''N'',');
      SQL.Add('  1)');

      ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSISBOV;
      ParamByName('nom_arquivo_sisbov').AsString := NomeArquivo;
      ParamByName('cod_tipo_arquivo_sisbov').AsInteger := CodTipoArq;

      ExecSQL;
    end;

    Result := CodArquivoSISBOV;
  finally
    QueryLocal.Free;
  end;
end;

{ TIntArquivoPropriedade }

{ Cosntrutor da classe. Inicializa os tipos de registro do arquivo. }
constructor TIntArquivoPropriedade.Create;
var
  TipoLinha: TTipoLinhaArquivo;
begin
  inherited;

  TipoLinha.CodTipoLinha := 0;
  SetLength(TipoLinha.Atributos, 2);
  TipoLinha.Atributos[PROP_0_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[PROP_0_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[PROP_0_CNPJ].Posicao := 2;
  TipoLinha.Atributos[PROP_0_CNPJ].Tamanho := 14;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 1;
  SetLength(TipoLinha.Atributos, 22);
  TipoLinha.Atributos[PROP_1_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[PROP_1_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[PROP_1_NOME].Posicao := 2;
  TipoLinha.Atributos[PROP_1_NOME].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_TIPO_INSCRICAO].Posicao := 52;
  TipoLinha.Atributos[PROP_1_TIPO_INSCRICAO].Tamanho := 5;
  TipoLinha.Atributos[PROP_1_NIRF].Posicao := 57;
  TipoLinha.Atributos[PROP_1_NIRF].Tamanho := 13;
  TipoLinha.Atributos[PROP_1_CODIGO].Posicao := 70;
  TipoLinha.Atributos[PROP_1_CODIGO].Tamanho := 10;
  TipoLinha.Atributos[PROP_1_DT_INI_CERTIFICADO].Posicao := 80;
  TipoLinha.Atributos[PROP_1_DT_INI_CERTIFICADO].Tamanho := 8;
  TipoLinha.Atributos[PROP_1_LATITUDE].Posicao := 88;
  TipoLinha.Atributos[PROP_1_LATITUDE].Tamanho := 8;
  TipoLinha.Atributos[PROP_1_LONGITUDE].Posicao := 96;
  TipoLinha.Atributos[PROP_1_LONGITUDE].Tamanho := 8;
  TipoLinha.Atributos[PROP_1_AREA].Posicao := 104;
  TipoLinha.Atributos[PROP_1_AREA].Tamanho := 10;
  TipoLinha.Atributos[PROP_1_PESSOA_CONTATO].Posicao := 114;
  TipoLinha.Atributos[PROP_1_PESSOA_CONTATO].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_TELEFONE].Posicao := 164;
  TipoLinha.Atributos[PROP_1_TELEFONE].Tamanho := 15;
  TipoLinha.Atributos[PROP_1_FAX].Posicao := 179;
  TipoLinha.Atributos[PROP_1_FAX].Tamanho := 15;
  TipoLinha.Atributos[PROP_1_LOGRADOURO].Posicao := 194;
  TipoLinha.Atributos[PROP_1_LOGRADOURO].Tamanho := 100;
  TipoLinha.Atributos[PROP_1_BAIRRO].Posicao := 294;
  TipoLinha.Atributos[PROP_1_BAIRRO].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_CEP].Posicao := 344;
  TipoLinha.Atributos[PROP_1_CEP].Tamanho := 8;
  TipoLinha.Atributos[PROP_1_MUNICIPIO].Posicao := 352;
  TipoLinha.Atributos[PROP_1_MUNICIPIO].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_UF_MUNICIPIO].Posicao := 402;
  TipoLinha.Atributos[PROP_1_UF_MUNICIPIO].Tamanho := 2;
  TipoLinha.Atributos[PROP_1_LOGRADOURO_CORR].Posicao := 404;
  TipoLinha.Atributos[PROP_1_LOGRADOURO_CORR].Tamanho := 100;
  TipoLinha.Atributos[PROP_1_BAIRRO_CORR].Posicao := 504;
  TipoLinha.Atributos[PROP_1_BAIRRO_CORR].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_CEP_CORR].Posicao := 554;
  TipoLinha.Atributos[PROP_1_CEP_CORR].Tamanho := 8;
  TipoLinha.Atributos[PROP_1_MUNICIPIO_CORR].Posicao := 562;
  TipoLinha.Atributos[PROP_1_MUNICIPIO_CORR].Tamanho := 50;
  TipoLinha.Atributos[PROP_1_UF_MUNICIPIO_CORR].Posicao := 612;
  TipoLinha.Atributos[PROP_1_UF_MUNICIPIO_CORR].Tamanho := 02;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 2;
  SetLength(TipoLinha.Atributos, 10);
  TipoLinha.Atributos[PROP_2_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[PROP_2_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[PROP_2_TIPO_PROPRIETARIO].Posicao := 2;
  TipoLinha.Atributos[PROP_2_TIPO_PROPRIETARIO].Tamanho := 2;
  TipoLinha.Atributos[PROP_2_CPF_CNPJ].Posicao := 4;
  TipoLinha.Atributos[PROP_2_CPF_CNPJ].Tamanho := 14;
  TipoLinha.Atributos[PROP_2_NOME].Posicao := 18;
  TipoLinha.Atributos[PROP_2_NOME].Tamanho := 100;
  TipoLinha.Atributos[PROP_2_LOGRADOURO].Posicao := 118;
  TipoLinha.Atributos[PROP_2_LOGRADOURO].Tamanho := 100;
  TipoLinha.Atributos[PROP_2_BAIRRO].Posicao := 218;
  TipoLinha.Atributos[PROP_2_BAIRRO].Tamanho := 50;
  TipoLinha.Atributos[PROP_2_CEP].Posicao := 268;
  TipoLinha.Atributos[PROP_2_CEP].Tamanho := 8;
  TipoLinha.Atributos[PROP_2_MUNICIPIO].Posicao := 276;
  TipoLinha.Atributos[PROP_2_MUNICIPIO].Tamanho := 50;
  TipoLinha.Atributos[PROP_2_UF_MUNICIPIO].Posicao := 326;
  TipoLinha.Atributos[PROP_2_UF_MUNICIPIO].Tamanho := 2;
  TipoLinha.Atributos[PROP_2_INDICADOR_PROPRIETARIO].Posicao := 328;
  TipoLinha.Atributos[PROP_2_INDICADOR_PROPRIETARIO].Tamanho := 4;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 3;
  SetLength(TipoLinha.Atributos, 3);
  TipoLinha.Atributos[PROP_3_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[PROP_3_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[PROP_3_TIPO_CONTATO].Posicao := 2;
  TipoLinha.Atributos[PROP_3_TIPO_CONTATO].Tamanho := 6;
  TipoLinha.Atributos[PROP_3_VALOR].Posicao := 8;
  TipoLinha.Atributos[PROP_3_VALOR].Tamanho := 50;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 9;
  SetLength(TipoLinha.Atributos, 7);
  TipoLinha.Atributos[PROP_9_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[PROP_9_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[PROP_9_TIPO_1].Posicao := 2;
  TipoLinha.Atributos[PROP_9_TIPO_1].Tamanho := 1;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_1].Posicao := 3;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_1].Tamanho := 10;
  TipoLinha.Atributos[PROP_9_TIPO_2].Posicao := 13;
  TipoLinha.Atributos[PROP_9_TIPO_2].Tamanho := 1;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_2].Posicao := 14;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_2].Tamanho := 10;
  TipoLinha.Atributos[PROP_9_TIPO_3].Posicao := 24;
  TipoLinha.Atributos[PROP_9_TIPO_3].Tamanho := 1;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_3].Posicao := 25;
  TipoLinha.Atributos[PROP_9_QUANTIDADE_3].Tamanho := 10;
  AddTipoLinha(TipoLinha);
end;

{ TIntArquivoCodigoSISBOV }

{ Cosntrutor da classe. Inicializa os tipos de registro do arquivo. }
constructor TIntArquivoCodigoSISBOV.Create;
var
  TipoLinha: TTipoLinhaArquivo;
begin
  inherited;

  TipoLinha.CodTipoLinha := 0;
  SetLength(TipoLinha.Atributos, 2);
  TipoLinha.Atributos[COD_0_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[COD_0_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[COD_0_CNPJ].Posicao := 2;
  TipoLinha.Atributos[COD_0_CNPJ].Tamanho := 14;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 1;
  SetLength(TipoLinha.Atributos, 17);
  TipoLinha.Atributos[COD_1_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[COD_1_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[COD_1_NR_SISBOV].Posicao := 2;
  TipoLinha.Atributos[COD_1_NR_SISBOV].Tamanho := 15;
  TipoLinha.Atributos[COD_1_SITUACAO].Posicao := 17;
  TipoLinha.Atributos[COD_1_SITUACAO].Tamanho := 16;
  TipoLinha.Atributos[COD_1_TIPO_INSCRICAO_RESERVA].Posicao := 33;
  TipoLinha.Atributos[COD_1_TIPO_INSCRICAO_RESERVA].Tamanho := 5;
  TipoLinha.Atributos[COD_1_NIRF_INCRA_RESERVA].Posicao := 38;
  TipoLinha.Atributos[COD_1_NIRF_INCRA_RESERVA].Tamanho := 13;
  TipoLinha.Atributos[COD_1_CODIGO_RESERVA].Posicao := 51;
  TipoLinha.Atributos[COD_1_CODIGO_RESERVA].Tamanho := 10;
  TipoLinha.Atributos[COD_1_TIPO_PROPRIETARIO_RESERVA].Posicao := 61;
  TipoLinha.Atributos[COD_1_TIPO_PROPRIETARIO_RESERVA].Tamanho := 2;
  TipoLinha.Atributos[COD_1_CPF_CNPJ_RESERVA].Posicao := 63;
  TipoLinha.Atributos[COD_1_CPF_CNPJ_RESERVA].Tamanho := 14;
  TipoLinha.Atributos[COD_1_NM_PROPRIETARIO_RESERVA].Posicao := 77;
  TipoLinha.Atributos[COD_1_NM_PROPRIETARIO_RESERVA].Tamanho := 100;
  TipoLinha.Atributos[COD_1_NR_SOLICITACAO].Posicao := 177;
  TipoLinha.Atributos[COD_1_NR_SOLICITACAO].Tamanho := 6;
  TipoLinha.Atributos[COD_1_DT_SOLICITACAO].Posicao := 183;
  TipoLinha.Atributos[COD_1_DT_SOLICITACAO].Tamanho := 8;
  AddTipoLinha(TipoLinha);
end;

{ TIntArquivoAnimal }

{ Cosntrutor da classe. Inicializa os tipos de registro do arquivo. }
constructor TIntArquivoAnimal.Create;
var
  TipoLinha: TTipoLinhaArquivo;
begin
  inherited;

  TipoLinha.CodTipoLinha := 0;
  SetLength(TipoLinha.Atributos, 2);
  TipoLinha.Atributos[ANI_0_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[ANI_0_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[ANI_0_CNPJ].Posicao := 2;
  TipoLinha.Atributos[ANI_0_CNPJ].Tamanho := 14;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 1;
  SetLength(TipoLinha.Atributos, 25);
  TipoLinha.Atributos[ANI_1_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[ANI_1_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[ANI_1_ESPECIE].Posicao := 2;
  TipoLinha.Atributos[ANI_1_ESPECIE].Tamanho := 3;
  TipoLinha.Atributos[ANI_1_NR_SISBOV].Posicao := 5;
  TipoLinha.Atributos[ANI_1_NR_SISBOV].Tamanho := 15;
  TipoLinha.Atributos[ANI_1_DT_IDENTIFICACAO].Posicao := 20;
  TipoLinha.Atributos[ANI_1_DT_IDENTIFICACAO].Tamanho := 8;
  TipoLinha.Atributos[ANI_1_TIPO_DUPLA_IDENTIFICACAO].Posicao := 28;
  TipoLinha.Atributos[ANI_1_TIPO_DUPLA_IDENTIFICACAO].Tamanho := 4;
  TipoLinha.Atributos[ANI_1_CODIGO_RACA].Posicao := 32;
  TipoLinha.Atributos[ANI_1_CODIGO_RACA].Tamanho := 2;
  TipoLinha.Atributos[ANI_1_DATA_NASCIMENTO].Posicao := 34;
  TipoLinha.Atributos[ANI_1_DATA_NASCIMENTO].Tamanho := 8;
  TipoLinha.Atributos[ANI_1_SEXO].Posicao := 42;
  TipoLinha.Atributos[ANI_1_SEXO].Tamanho := 2;
  TipoLinha.Atributos[ANI_1_APTIDAO].Posicao := 44;
  TipoLinha.Atributos[ANI_1_APTIDAO].Tamanho := 5;
  TipoLinha.Atributos[ANI_1_TIPO_INSCRICAO_NASCIMENTO].Posicao := 49;
  TipoLinha.Atributos[ANI_1_TIPO_INSCRICAO_NASCIMENTO].Tamanho := 5;
  TipoLinha.Atributos[ANI_1_NIRF_INCRA_NASCIMENTO].Posicao := 54;
  TipoLinha.Atributos[ANI_1_NIRF_INCRA_NASCIMENTO].Tamanho := 13;
  TipoLinha.Atributos[ANI_1_CODIGO_NASCIMENTO].Posicao := 67;
  TipoLinha.Atributos[ANI_1_CODIGO_NASCIMENTO].Tamanho := 10;
  TipoLinha.Atributos[ANI_1_TIPO_INSCRICAO_RESPONSAVEL].Posicao := 77;
  TipoLinha.Atributos[ANI_1_TIPO_INSCRICAO_RESPONSAVEL].Tamanho := 5;
  TipoLinha.Atributos[ANI_1_NIRF_INCRA_RESPONSAVEL].Posicao := 82;
  TipoLinha.Atributos[ANI_1_NIRF_INCRA_RESPONSAVEL].Tamanho := 13;
  TipoLinha.Atributos[ANI_1_CODIGO_RESPONSAVEL].Posicao := 95;
  TipoLinha.Atributos[ANI_1_CODIGO_RESPONSAVEL].Tamanho := 10;
  TipoLinha.Atributos[ANI_1_NR_ASSOCIACAO].Posicao := 105;
  TipoLinha.Atributos[ANI_1_NR_ASSOCIACAO].Tamanho := 20;
  TipoLinha.Atributos[ANI_1_NR_CERTIFICADORA].Posicao := 125;
  TipoLinha.Atributos[ANI_1_NR_CERTIFICADORA].Tamanho := 20;
  TipoLinha.Atributos[ANI_1_NR_SISBOV_MAE].Posicao := 145;
  TipoLinha.Atributos[ANI_1_NR_SISBOV_MAE].Tamanho := 15;
  TipoLinha.Atributos[ANI_1_NR_SISBOV_PAI].Posicao := 160;
  TipoLinha.Atributos[ANI_1_NR_SISBOV_PAI].Tamanho := 15;
  TipoLinha.Atributos[ANI_1_DT_MORTE].Posicao := 175;
  TipoLinha.Atributos[ANI_1_DT_MORTE].Tamanho := 8;
  TipoLinha.Atributos[ANI_1_TIPO_MORTE].Posicao := 183;
  TipoLinha.Atributos[ANI_1_TIPO_MORTE].Tamanho := 5;
  TipoLinha.Atributos[ANI_1_CAUSA_MORTE].Posicao := 188;
  TipoLinha.Atributos[ANI_1_CAUSA_MORTE].Tamanho := 50;
  TipoLinha.Atributos[ANI_1_CS_LOCALIZACAO_ATUAL].Posicao := 238;
  TipoLinha.Atributos[ANI_1_CS_LOCALIZACAO_ATUAL].Tamanho := 4;
  TipoLinha.Atributos[ANI_1_ID_LOCALIZACAO_ATUAL].Posicao := 242;
  TipoLinha.Atributos[ANI_1_ID_LOCALIZACAO_ATUAL].Tamanho := 28;
  TipoLinha.Atributos[ANI_1_DT_INCLUSAO_SISTEMA].Posicao := 270;
  TipoLinha.Atributos[ANI_1_DT_INCLUSAO_SISTEMA].Tamanho := 8;
  AddTipoLinha(TipoLinha);

  TipoLinha.CodTipoLinha := 2;
  SetLength(TipoLinha.Atributos, 10);
  TipoLinha.Atributos[ANI_2_TIPO_REG].Posicao := 1;
  TipoLinha.Atributos[ANI_2_TIPO_REG].Tamanho := 1;
  TipoLinha.Atributos[ANI_2_CS_ORIGEM].Posicao := 2;
  TipoLinha.Atributos[ANI_2_CS_ORIGEM].Tamanho := 4;
  TipoLinha.Atributos[ANI_2_TIPO_INSCRICAO_ORIEM].Posicao := 6;
  TipoLinha.Atributos[ANI_2_TIPO_INSCRICAO_ORIEM].Tamanho := 5;
  TipoLinha.Atributos[ANI_2_ID_ORIGEM].Posicao := 11;
  TipoLinha.Atributos[ANI_2_ID_ORIGEM].Tamanho := 23;
  TipoLinha.Atributos[ANI_2_DT_EMISSAO].Posicao := 34;
  TipoLinha.Atributos[ANI_2_DT_EMISSAO].Tamanho := 8;
  TipoLinha.Atributos[ANI_2_DT_SAIDA].Posicao := 42;
  TipoLinha.Atributos[ANI_2_DT_SAIDA].Tamanho := 8;
  TipoLinha.Atributos[ANI_2_DT_CHEGADA].Posicao := 50;
  TipoLinha.Atributos[ANI_2_DT_CHEGADA].Tamanho := 8;
  TipoLinha.Atributos[ANI_2_CS_DESTINO].Posicao := 58;
  TipoLinha.Atributos[ANI_2_CS_DESTINO].Tamanho := 4;
  TipoLinha.Atributos[ANI_2_TIPO_INSCRICAO_DESTINO].Posicao := 62;
  TipoLinha.Atributos[ANI_2_TIPO_INSCRICAO_DESTINO].Tamanho := 5;
  TipoLinha.Atributos[ANI_2_ID_DESTINO].Posicao := 67;
  TipoLinha.Atributos[ANI_2_ID_DESTINO].Tamanho := 23;
  AddTipoLinha(TipoLinha);
end;

{ Prepara os dados na base de dados.
   - Verifica se a origem carga inicial ja está cadastrada, se não estiver
     a insere.
   - Verifica se o tipo de morte "Abate no frigorífico" esta com a data fim
     validade igual a null, se não estiver atualiza para null
   - Verifica se a identificação dupla DE (Dispositivo eletrônico) esta com
     a data fim validade igual a null, se não estiver atualiza para null

Exceptions:
  EHerdomException: caso ocorra algum erro}
procedure TIntCargaInicial.PreparaDadosBaseDados;
const
  NomeMetodo: String = 'PreparaDadosBaseDados';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica a origem "Carga inicial"
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT *');
        SQL.Add('  FROM tab_tipo_origem');
        SQL.Add(' WHERE cod_tipo_origem = 6');
        Open;

        if IsEmpty then
        begin
          SQL.Clear;
          SQL.Add('insert into tab_tipo_origem(');
          SQL.Add('  cod_tipo_origem,');
          SQL.Add('  sgl_tipo_origem,');
          SQL.Add('  des_tipo_origem');
          SQL.Add(') values (');
          SQL.Add('  6,');
          SQL.Add('  ''CI'',');
          SQL.Add('  ''Carga inicial''');
          SQL.Add(')');
          ExecSQL;
        end;
      end;

      // Atualiza o tipo de morte "Abate no frigorífico"
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_causa_morte');
        SQL.Add('   SET dta_fim_validade = NULL');
        SQL.Add(' WHERE cod_causa_morte = 30');
        ExecSQL;
      end;

      // Atualiza o tipo de morte "Abate no frigorífico"
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_tipo_identificador');
        SQL.Add('   SET dta_fim_validade = NULL');
        SQL.Add(' WHERE cod_tipo_identificador = 14');
        ExecSQL;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(2107, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

{ Prepara os dados na base de dados.
   - Verifica se o tipo de morte "Abate no frigorífico" esta com a data fim
     validade igual a null, se estiver atualiza para a data atual
   - Verifica se a identificação dupla DE (Dispositivo eletrônico) esta com
     a data fim validade igual a null, se estiver atualiza para a data atual

Exceptions:
  EHerdomException: caso ocorra algum erro}
procedure TIntCargaInicial.FinalizaDadosBaseDados;
const
  NomeMetodo: String = 'FinalizaDadosBaseDados';
var
  QueryLocal: THerdomQuery;
begin
  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Atualiza o tipo de morte "Abate no frigorífico"
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_causa_morte');
        SQL.Add('   SET dta_fim_validade = getDate()');
        SQL.Add(' WHERE cod_causa_morte = 30');
        ExecSQL;
      end;

      // Atualiza o tipo de morte "Abate no frigorífico"
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('UPDATE tab_tipo_identificador');
        SQL.Add('   SET dta_fim_validade = getDate()');
        SQL.Add(' WHERE cod_tipo_identificador = 14');
        ExecSQL;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(2107, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

end.

