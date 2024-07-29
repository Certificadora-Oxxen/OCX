unit uIntInventariosCodigosSisbov;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, WsSISBOV1, InvokeRegistry, Rio, SOAPHTTPClient, uIntSoapSisbov,
  uFerramentas, uIntRelatorios;

type
  TIntInventariosCodigosSisbov = class(TIntClasseBDNavegacaoBasica)
  public
    function Inserir(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo, CodTipoIdentificacaoSisbov: Integer): Integer;
    function Excluir(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo: Integer): Integer;
    function Pesquisar(NomProdutor, SglProdutor, NomPropriedadeRural: String;
      DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
      DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim: TDateTime;
      IndTransmissaoSisbov: String): Integer;
    function GerarRelatorio(NomProdutor, SglProdutor, NomPropriedadeRural: String;
      DtaLancamentoInventarioIni, DtaLancamentoInventarioFim,
      DtaTransmissaoSisbovIni, DtaTransmissaoSisbovFim: TDateTime;
      IndTransmissaoSisbov: String; QtdQuebraRelatorio, Tipo: Integer): String;
    function Transmitir: Integer;
  private
    function ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural: Integer): Integer;
    function ConsistirTipoIdentificacaoSisbov(CodTipoIdentificacaoSisbov: Integer): Integer;
    function InserirInventario(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo, CodTipoIdentificacaoSisbov: Integer): Integer;
    function ExcluirInventario(CodPessoaProdutor, CodPropriedadeRural,
      NumSolicitacaoCodigo: Integer): Integer;
  end;

implementation

{ TIntInventariosCodigosSisbov }

function TIntInventariosCodigosSisbov.ConsistirProdutorPropriedade(
  CodPessoaProdutor, CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirProdutorPropriedade';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste Produtor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.cod_pessoa_produtor ');
      Q.SQL.Add('  from tab_produtor tp ');
      Q.SQL.Add(' where tp.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tp.ind_transmissao_sisbov = ''S'' ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(607, Self.ClassName, NomeMetodo, []);
        Result := -607;
        Exit;
      End;
      Q.Close;

      // Consiste Propriedade Rural
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tpr.cod_propriedade_rural ');
      Q.SQL.Add('  from tab_propriedade_rural tpr ');
      Q.SQL.Add(' where tpr.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and tpr.ind_transmissao_sisbov = ''S'' ');
      Q.SQL.Add('   and tpr.cod_id_propriedade_sisbov is not null ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(513, Self.ClassName, NomeMetodo, []);
        Result := -513;
        Exit;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2328, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2328;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosCodigosSisbov.ConsistirTipoIdentificacaoSisbov(
  CodTipoIdentificacaoSisbov: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirTipoIdentificacaoSisbov';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste Identificação
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_identificacao_dupla ');
      Q.SQL.Add(' where cod_identificacao_dupla = :cod_identificacao_dupla ');
{$ENDIF}
      Q.ParamByName('cod_identificacao_dupla').AsInteger := CodTipoIdentificacaoSisbov;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(2353, Self.ClassName, NomeMetodo, []);
        Result := -2353;
        Exit;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2354, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2354;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosCodigosSisbov.Excluir(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo: Integer): Integer;
const
  NomeMetodo: String = 'Excluir';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(92) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Try
    // Consiste se parâmetros

    // Consiste número da solicitação
    if NumSolicitacaoCodigo <= 0 then begin
      Mensagens.Adicionar(2352, Self.ClassName, NomeMetodo, []);
      Result := -2352;
      Exit;
    end;

    // Consiste produtor e propriedade
    Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
    if Result < 0 then begin
      Exit;
    end;

    Result := ExcluirInventario(CodPessoaProdutor, CodPropriedadeRural, NumSolicitacaoCodigo);

  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2358, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2358;
      Exit;
    End;
  End;
end;

function TIntInventariosCodigosSisbov.ExcluirInventario(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo: Integer): Integer;
const
  NomeMetodo: String = 'ExcluirInventario';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se solicitação já foi inventariada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_transmissao_sisbov ');
      Q.SQL.Add('  from tab_inventario_codigo ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('		and num_solicitacao_codigo = :num_solicitacao_codigo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('num_solicitacao_codigo').AsInteger := NumSolicitacaoCodigo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(2357, Self.ClassName, NomeMetodo, []);
        Result := -2357;
        Exit;
      End;

      // Verifica se inventário já não foi transmitido
      if Q.FieldByName('ind_transmissao_sisbov').AsString = 'S' then begin
        Mensagens.Adicionar(2359, Self.ClassName, NomeMetodo, []);
        Result := -2359;
        Exit;
      end;

      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_inventario_codigo ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('		and num_solicitacao_codigo = :num_solicitacao_codigo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('num_solicitacao_codigo').AsInteger := NumSolicitacaoCodigo;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2358, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2358;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosCodigosSisbov.GerarRelatorio(NomProdutor,
  SglProdutor, NomPropriedadeRural: String; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime; IndTransmissaoSisbov: String;
  QtdQuebraRelatorio, Tipo: Integer): String;
const
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 31;
var
  Rel: TRelatorioPadrao;
  Retorno:  Integer;
  Q : THerdomQueryNavegacao;
  IntRelatorios: TIntRelatorios;
  NumCampos, iAux: Integer;
  sAux, sQuebra: String;
  vAux: Array [1..2] of Variant;
begin
  Result := '';

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
//  if not Conexao.PodeExecutarMetodo(Metodo) then begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Exit;
//  end;

  try
    // Obtem parâmetro com o máximo número de códigos sisbov para pesquisa
    IntRelatorios := TIntRelatorios.Create;
    try
      Retorno := IntRelatorios.Inicializar(Conexao, Mensagens);
      if Retorno < 0 then Exit;
      Retorno := IntRelatorios.Buscar(CodRelatorio);
      if Retorno < 0 then Exit;
      Retorno := IntRelatorios.Pesquisar(CodRelatorio);
      if Retorno < 0 then Exit;

      Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
      try
        // Define o relatório em questão e carrega os seus dados específicos
        Retorno := Rel.CarregarRelatorio(CodRelatorio);
        if Retorno < 0 then Exit;

        NumCampos := 0;

        // Setando a quantidade de campos selecionados pelo usuario para a montagem do relatorio
        if (IntRelatorios.CampoAssociado(1) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(2) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(3) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(4) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(5) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(6) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(7) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(8) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(9) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(10) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(11) = 1) then Inc(NumCampos);
        if (IntRelatorios.CampoAssociado(12) = 1) then Inc(NumCampos);

        // Pelo menos um campo deve ter sido selecionado para que o relatório possa ser emitido
        if NumCampos < 1 then begin
          Mensagens.Adicionar(962, Self.ClassName, NomeMetodo, []);
          Exit;
        end;

        // O número de quebras não pode ser maior que o número de campos selecionados
        if QtdQuebraRelatorio > NumCampos then begin
          Mensagens.Adicionar(1384, Self.ClassName, NomeMetodo, []);
          Exit;
        end;

        Q := THerdomQueryNavegacao.Create(nil);
        try
          Q.SQLConnection := Conexao.SQLConnection;

          // Query do relatório
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select tic.cod_pessoa_produtor as CodPessoaProdutor, ');
          Q.SQL.Add('       tp.sgl_produtor as SglProdutor, ');
          Q.SQL.Add('       tps.nom_pessoa as NomPessoa, ');
          Q.SQL.Add('       tic.cod_propriedade_rural as CodPropriedadeRural, ');
          Q.SQL.Add('       tpr.nom_propriedade_rural as NomPropriedadeRural, ');
          Q.SQL.Add('       tpr.num_imovel_receita_federal as NumImovelPropriedade, ');
          Q.SQL.Add('       tic.num_solicitacao_codigo as NumSolicitacaoCodigo, ');
          Q.SQL.Add('       tic.num_solicitacao_novo_sisbov as NumSolicitacaoNovoSisbov, ');
          Q.SQL.Add('       tic.cod_tipo_identificacao_sisbov as CodTipoIdentificacaoSisbov, ');
          Q.SQL.Add('       tid.des_identificacao_dupla as DesIdentificacaoDupla, ');
          Q.SQL.Add('       tid.cod_identificacao_dupla_sisbov as CodIdentificacaoDuplaSisbov, ');
          Q.SQL.Add('       tic.cod_usuario as CodUsuario, ');
          Q.SQL.Add('       tu.nom_usuario as NomUsuario, ');
          Q.SQL.Add('       tic.ind_transmissao_sisbov as IndTransmissaoSisbov, ');
          Q.SQL.Add('       case tic.ind_transmissao_sisbov when ''S'' then ''Transmitido'' when ''E'' then ''Erro'' else ''Não Transmitido'' end as DesTransmissaoSisbov, ');
          Q.SQL.Add('       tic.cod_id_transacao_sisbov as CodIdTransacaoSisbov, ');
          Q.SQL.Add('       tic.dta_lancamento_inventario as DtaLancamentoInventario, ');
          Q.SQL.Add('       tic.dta_transmissao_sisbov as DtaTransmissaoSisbov, ');
          Q.SQL.Add('       tic.txt_mensagem_erro as TxtMensagemErro ');
          Q.SQL.Add('  from tab_inventario_codigo tic, ');
          Q.SQL.Add('       tab_produtor tp, ');
          Q.SQL.Add('       tab_pessoa tps, ');
          Q.SQL.Add('       tab_propriedade_rural tpr, ');
          Q.SQL.Add('       tab_identificacao_dupla tid, ');
          Q.SQL.Add('       tab_usuario tu ');
          Q.SQL.Add(' where tp.cod_pessoa_produtor = tic.cod_pessoa_produtor ');
          Q.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
          Q.SQL.Add('   and tpr.cod_propriedade_rural = tic.cod_propriedade_rural ');
          Q.SQL.Add('   and tid.cod_identificacao_dupla = tic.cod_tipo_identificacao_sisbov ');
          Q.SQL.Add('   and tu.cod_usuario = tic.cod_usuario ');

          if NomProdutor <> '' then begin
            Q.SQL.Add('   and tps.nom_pessoa like ''' + NomProdutor + '%'' ');
          end;
          if SglProdutor <> '' then begin
            Q.SQL.Add('   and tp.sgl_produtor = ''' + SglProdutor + ''' ');
          end;
          if NomPropriedadeRural <> '' then begin
            Q.SQL.Add('   and tpr.nom_propriedade_rural like ''' + NomPropriedadeRural + '%'' ');
          end;
          if DtaLancamentoInventarioIni > 0 then begin
            Q.SQL.Add('   and tic.dta_lancamento_inventario >= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioIni) + ' 00:00:00'' ');
          end;
          if DtaLancamentoInventarioFim > 0 then begin
            Q.SQL.Add('   and tic.dta_lancamento_inventario <= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioFim) + ' 23:59:59'' ');
          end;
          if DtaTransmissaoSisbovIni > 0 then begin
            Q.SQL.Add('   and tic.dta_transmissao_sisbov >= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovIni) + ' 00:00:00'' ');
          end;
          if DtaTransmissaoSisbovFim > 0 then begin
            Q.SQL.Add('   and tic.dta_transmissao_sisbov <= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovFim) + ' 23:59:59'' ');
          end;
          if Trim(IndTransmissaoSisbov) <> 'T' then begin
            Q.SQL.Add('   and tic.ind_transmissao_sisbov = ''' + Trim(IndTransmissaoSisbov) + '''');
          end;

          {Ordenando o resultado apresentado no relatório}
          Q.SQL.Add(' order by ');
          if (QtdQuebraRelatorio = 0) then begin
            Q.SQL.Add(' dta_lancamento_inventario desc, NomPessoa ');
          end else begin
            iAux := 0;
            Rel.Campos.IrAoPrimeiro;
            while not Rel.Campos.EOF do begin
              Q.SQL.Add(Rel.Campos.Campo.NomField);
              Inc(iAux);
              if iAux = QtdQuebraRelatorio then begin
                break;
              end else begin
                Q.SQL.Add(',');
              end;
              Rel.Campos.IrAoProximo;
            end;
          end;
    {$ENDIF}
          Q.Open;

          Rel.TipoDoArquvio := Tipo;

          //Desabilita a apresentação dos campos selecionados para quebra
          Rel.Campos.IrAoPrimeiro;
          for iAux := 1 to QtdQuebraRelatorio do begin
            Rel.Campos.DesabilitarCampo(Rel.campos.campo.NomField);
            Rel.Campos.IrAoProximo;
          end;

          // Inicializa o procedimento de geração do arquivo de relatório
          Retorno := Rel.InicializarRelatorio;
          if Retorno < 0 then Exit;
          sQuebra := '';

          Q.First;
          while not Q.EOF do begin
            // Realiza tratamento de quebras somente para formato PDF
            if Tipo = 1 then begin
              if Rel.LinhasRestantes <= 2 then begin
                // Verifica se o próximo registro existe, para que o último registro
                // do relatório possa ser exibido na próxima folha, e assim o total não
                // seja mostrado sozinho nesta folha
                if Q.FindNext then begin
                  Q.Prior;
                end else begin
                  Rel.NovaPagina;
                end;
              end;
              if QtdQuebraRelatorio > 0 then begin
                // Atualiza o campo valor do atributo Campos do relatorio c/ os dados da query
                Rel.Campos.CarregarValores(Q);
                // Percorre o(s) campo(s) informado(s) para quebra
                sAux := '';
                for iAux := 1 to QtdQuebraRelatorio do begin
                  // Concatena o valor dos campos de quebra, montando o título
                  vAux[iAux] := Rel.Campos.ValorCampoIdx[iAux-1];
                  sAux := SE(sAux = '', sAux, sAux + ' / ') +
                    TrataQuebra(Rel.Campos.TextoTituloIdx[iAux-1]) + ': ' +
                    Rel.Campos.ValorCampoIdx[iAux-1];
                end;
                if (sAux <> sQuebra) then begin
                  // Se ocorreu mudança na quebra atual ou é a primeira ('')
                  // Apresenta subtotal para quebra concluída, caso não seja a primeira
                  if sQuebra <> '' then begin
                    // Confirma se o subtotal deve ser apresentado
                    if NumCampos > (QtdQuebraRelatorio + 1) then begin
                      Rel.NovaLinha;
                      Rel.Campos.LimparValores;
                    end;
                  end;
                  sQuebra := sAux;
                  if Rel.LinhasRestantes <= 4 then begin
                    // Verifica se a quebra possui somente um registro e se o espaço é su-
                    // ficiênte para a impressão de título, registro e subtotal, caso
                    // contrário quebra a página antes da impressão
                    if not Q.FindNext then begin
                      Rel.NovaPagina;
                    end else begin
                      Rel.Campos.CarregarValores(Q);
                      for iAux := 1 to QtdQuebraRelatorio do begin
                        if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then begin
                          Rel.NovaPagina;
                          Break;
                        end;
                      end;
                    end;
                    Q.Prior;
                  end else if Rel.LinhasRestantes < Rel.LinhasPorPagina then begin
                    // Salta uma linha antes da quebra, caso não seja a primeira da pág.
                    Rel.NovaLinha;
                  end;

                  // Imprime título da quebra
                  Rel.FonteNegrito;
                  Rel.ImprimirTexto(0, sQuebra);
                  Rel.FonteNormal;
                end else if (Rel.LinhasRestantes = Rel.LinhasPorPagina) then begin
                  // Repete o título da quebra no topo da nova pág. qdo ocorrer quebra de pág.
                  Rel.FonteNegrito;
                  Rel.ImprimirTexto(0, sQuebra + ' (continuação)');
                  Rel.FonteNormal;
                end;
              end;

              // Verifica se o registro a ser apresentado é o último da quebra, caso
              // seja faz com que ele possa ser exibido na próxima folha, e assim o
              // subtotal e/ou o total não sejam mostrados sozinhos nesta folha
              if (Rel.LinhasRestantes <= 2) and (QtdQuebraRelatorio > 0) then begin
                if Q.FindNext then begin
                  Rel.Campos.CarregarValores(Q);
                  for iAux := 1 to QtdQuebraRelatorio do begin
                    if vAux[iAux] <> Rel.Campos.ValorCampoIdx[iAux-1] then begin
                      Rel.NovaPagina;
                      Break;
                    end;
                  end;
                  Q.Prior;

                  // Caso uma nova pág. tenha sido criada, força o reinício do procedi-
                  // mento para que o nome do produtor possa ser impresso no início da nova
                  // página concatenado com o texto "(continuação)"
                  if Rel.LinhasRestantes = Rel.LinhasPorPagina then begin
                    Continue;
                  end;
                end;
              end;
            end;

            Rel.ImprimirColunasResultSet(Q);
            Q.Next;
          end;

          // Realiza tratamento de quebras somente para formato PDF}
          if Tipo = 1 then begin

            // Monta Linhas totalizadoras, caso necessário
            if not Q.IsEmpty then begin
              // Confirma se o subtotal deve ser apresentado
              if NumCampos > (QtdQuebraRelatorio+1) then begin
                Rel.NovaLinha;
                Rel.Campos.LimparValores;
              end;
              Rel.NovaLinha;
              Rel.Campos.LimparValores;
            end;
          end;

          Q.SQL.Clear;

          Retorno := Rel.FinalizarRelatorio;

          // Se a finalização foi bem sucedida retorna o nome do arquivo gerado
          if Retorno = 0 then begin
            Result := Rel.NomeArquivo;
          end;
        finally
          Q.Free;
        end;
      finally
        Rel.Free;
      end;
    finally
      IntRelatorios.Free;
    end;
  except  // try/except principal do método
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(2370, Self.ClassName, NomeMetodo, [E.Message]);
      Result := '';
      Exit;
    end;
  end;
end;

function TIntInventariosCodigosSisbov.Inserir(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo,
  CodTipoIdentificacaoSisbov: Integer): Integer;
const
  NomeMetodo: String = 'Inserir';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(92) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Try
    // Consiste se parâmetros

    // Consiste número da solicitação
    if NumSolicitacaoCodigo <= 0 then begin
      Mensagens.Adicionar(2352, Self.ClassName, NomeMetodo, []);
      Result := -2352;
      Exit;
    end;

    // Consiste produtor e propriedade
    Result := ConsistirProdutorPropriedade(CodPessoaProdutor, CodPropriedadeRural);
    if Result < 0 then begin
      Exit;
    end;

    // Consiste Identificação SISBOV
    Result := ConsistirTipoIdentificacaoSisbov(CodTipoIdentificacaoSisbov);
    if Result < 0 then begin
      Exit;
    end;

    Result := InserirInventario(CodPessoaProdutor, CodPropriedadeRural, NumSolicitacaoCodigo, CodTipoIdentificacaoSisbov);

  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2356, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2356;
      Exit;
    End;
  End;
end;

function TIntInventariosCodigosSisbov.InserirInventario(CodPessoaProdutor,
  CodPropriedadeRural, NumSolicitacaoCodigo,
  CodTipoIdentificacaoSisbov: Integer): Integer;
const
  NomeMetodo: String = 'InserirInventario';
var
  Q : THerdomQuery;
begin
  Result := 0;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se solicitação já foi inventariada
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('  from tab_inventario_codigo ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('		and num_solicitacao_codigo = :num_solicitacao_codigo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('num_solicitacao_codigo').AsInteger := NumSolicitacaoCodigo;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(2355, Self.ClassName, NomeMetodo, []);
        Result := -2355;
        Exit;
      End;
      Q.Close;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert tab_inventario_codigo ');
      Q.SQL.Add('  (cod_pessoa_produtor, ');
      Q.SQL.Add('   cod_propriedade_rural, ');
      Q.SQL.Add('   num_solicitacao_codigo, ');
      Q.SQL.Add('   cod_tipo_identificacao_sisbov, ');
      Q.SQL.Add('   ind_transmissao_sisbov, ');
      Q.SQL.Add('   dta_lancamento_inventario, ');
      Q.SQL.Add('   cod_usuario) ');
      Q.SQL.Add('values ');
      Q.SQL.Add('  (:cod_pessoa_produtor, ');
      Q.SQL.Add('   :cod_propriedade_rural, ');
      Q.SQL.Add('   :num_solicitacao_codigo, ');
      Q.SQL.Add('   :cod_tipo_identificacao_sisbov, ');
      Q.SQL.Add('   ''N'', ');
      Q.SQL.Add('   getdate(), ');
      Q.SQL.Add('   :cod_usuario) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('num_solicitacao_codigo').AsInteger := NumSolicitacaoCodigo;
      Q.ParamByName('cod_tipo_identificacao_sisbov').AsInteger := CodTipoIdentificacaoSisbov;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2356, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -2356;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInventariosCodigosSisbov.Pesquisar(NomProdutor, SglProdutor,
  NomPropriedadeRural: String; DtaLancamentoInventarioIni,
  DtaLancamentoInventarioFim, DtaTransmissaoSisbovIni,
  DtaTransmissaoSisbovFim: TDateTime;
  IndTransmissaoSisbov: String): Integer;
const
  NomeMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
//  If Not Conexao.PodeExecutarMetodo(101) Then Begin
//    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
//    Result := -188;
//    Exit;
//  End;

  // Verifica se produtor de trabalho foi definido
//  If Conexao.CodProdutorTrabalho = -1 Then Begin
//    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
//    Result := -307;
//    Exit;
//  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tic.cod_pessoa_produtor as CodPessoaProdutor, ');
  Query.SQL.Add('       tp.sgl_produtor as SglProdutor, ');
  Query.SQL.Add('       tps.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tic.cod_propriedade_rural as CodPropriedadeRural, ');
  Query.SQL.Add('       tpr.nom_propriedade_rural as NomPropriedadeRural, ');
  Query.SQL.Add('       tpr.num_imovel_receita_federal as NumImovelPropriedade, ');
  Query.SQL.Add('       tic.num_solicitacao_codigo as NumSolicitacaoCodigo, ');
  Query.SQL.Add('       tic.num_solicitacao_novo_sisbov as NumSolicitacaoNovoSisbov, ');
  Query.SQL.Add('       tic.cod_tipo_identificacao_sisbov as CodTipoIdentificacaoSisbov, ');
  Query.SQL.Add('       tid.des_identificacao_dupla as DesIdentificacaoDupla, ');
  Query.SQL.Add('       tid.cod_identificacao_dupla_sisbov as CodIdentificacaoDuplaSisbov, ');
  Query.SQL.Add('       tic.cod_usuario as CodUsuario, ');
  Query.SQL.Add('       tu.nom_usuario as NomUsuario, ');
  Query.SQL.Add('       tic.ind_transmissao_sisbov as IndTransmissaoSisbov, ');
  Query.SQL.Add('       case tic.ind_transmissao_sisbov when ''S'' then ''Transmitido'' when ''E'' then ''Erro'' else ''Não Transmitido'' end as DesTransmissaoSisbov, ');
  Query.SQL.Add('       tic.cod_id_transacao_sisbov as CodIdTransacaoSisbov, ');
  Query.SQL.Add('       tic.dta_lancamento_inventario as DtaLancamentoInventario, ');
  Query.SQL.Add('       tic.dta_transmissao_sisbov as DtaTransmissaoSisbov, ');
  Query.SQL.Add('       tic.txt_mensagem_erro as TxtMensagemErro ');
  Query.SQL.Add('  from tab_inventario_codigo tic, ');
  Query.SQL.Add('       tab_produtor tp, ');
  Query.SQL.Add('       tab_pessoa tps, ');
  Query.SQL.Add('       tab_propriedade_rural tpr, ');
  Query.SQL.Add('       tab_identificacao_dupla tid, ');
  Query.SQL.Add('       tab_usuario tu ');
  Query.SQL.Add(' where tp.cod_pessoa_produtor = tic.cod_pessoa_produtor ');
  Query.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
  Query.SQL.Add('   and tpr.cod_propriedade_rural = tic.cod_propriedade_rural ');
  Query.SQL.Add('   and tid.cod_identificacao_dupla = tic.cod_tipo_identificacao_sisbov ');
  Query.SQL.Add('   and tu.cod_usuario = tic.cod_usuario ');

  if NomProdutor <> '' then begin
    Query.SQL.Add('   and tps.nom_pessoa like ''' + NomProdutor + '%'' ');
  end;
  if SglProdutor <> '' then begin
    Query.SQL.Add('   and tp.sgl_produtor = ''' + SglProdutor + ''' ');
  end;
  if NomPropriedadeRural <> '' then begin
    Query.SQL.Add('   and tpr.nom_propriedade_rural like ''' + NomPropriedadeRural + '%'' ');
  end;
  if DtaLancamentoInventarioIni > 0 then begin
    Query.SQL.Add('   and tic.dta_lancamento_inventario >= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioIni) + ' 00:00:00'' ');
  end;
  if DtaLancamentoInventarioFim > 0 then begin
    Query.SQL.Add('   and tic.dta_lancamento_inventario <= ''' + FormatDateTime('yyyy-mm-dd', DtaLancamentoInventarioFim) + ' 23:59:59'' ');
  end;
  if DtaTransmissaoSisbovIni > 0 then begin
    Query.SQL.Add('   and tic.dta_transmissao_sisbov >= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovIni) + ' 00:00:00'' ');
  end;
  if DtaTransmissaoSisbovFim > 0 then begin
    Query.SQL.Add('   and tic.dta_transmissao_sisbov <= ''' + FormatDateTime('yyyy-mm-dd', DtaTransmissaoSisbovFim) + ' 23:59:59'' ');
  end;
  if Trim(IndTransmissaoSisbov) <> 'T' then begin
    Query.SQL.Add('   and tic.ind_transmissao_sisbov = ''' + Trim(IndTransmissaoSisbov) + '''');
  end;
  Query.SQL.Add(' order by dta_lancamento_inventario desc, NomPessoa ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2360, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2360;
      Exit;
    End;
  End;
end;

function TIntInventariosCodigosSisbov.Transmitir: Integer;
const
  NomeMetodo: String = 'Transmitir';
var
  Q : THerdomQuery;
  QUpd : THerdomQuery;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  Retorno : RetornoInventarioSolicitacao;
  DtaSistema: TDateTime;
  I, IdTransacao: Integer;
  MsgRet: String;
begin
  Result := 0;
  IdTransacao := 0;

  // Cria query para leitura dos registros a serem transmitidos
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    // Cria query para atualização dos registros transmitidos
    QUpd := THerdomQuery.Create(Conexao, nil);
    Try
      // Cria classe de conexão SOAP
      SoapSisbov := TIntSoapSisbov.Create;
      Try
        Try
          // Conexão SOAP
          SoapSisbov.Inicializar(Conexao, Mensagens);
          Conectado:= SoapSisbov.conectado('InventariosCodigosSisbov');

          if Conectado then begin
            // Query para leitura dos registros ainda não transmitidos ou com erro na última transmissão
            Q.SQL.Clear;
    {$IFDEF MSSQL}
            Q.SQL.Add('select tic.cod_pessoa_produtor, ');
            Q.SQL.Add('       tic.cod_propriedade_rural, ');
            Q.SQL.Add('       tic.num_solicitacao_codigo, ');
            Q.SQL.Add('       case tps.cod_natureza_pessoa ');
            Q.SQL.Add('         when ''F'' then tps.num_cnpj_cpf ');
            Q.SQL.Add('       else ');
            Q.SQL.Add('         '''' ');
            Q.SQL.Add('       end as num_cpf_produtor, ');
            Q.SQL.Add('       case tps.cod_natureza_pessoa ');
            Q.SQL.Add('         when ''J'' then tps.num_cnpj_cpf ');
            Q.SQL.Add('       else ');
            Q.SQL.Add('         '''' ');
            Q.SQL.Add('       end as num_cnpj_produtor, ');
            Q.SQL.Add('       tpr.cod_id_propriedade_sisbov, ');
            Q.SQL.Add('       cast(tid.cod_identificacao_dupla_sisbov as integer) as cod_identificacao_dupla_sisbov ');
            Q.SQL.Add('  from tab_inventario_codigo tic, ');
            Q.SQL.Add('       tab_produtor tp, ');
            Q.SQL.Add('       tab_pessoa tps, ');
            Q.SQL.Add('       tab_propriedade_rural tpr, ');
            Q.SQL.Add('       tab_identificacao_dupla tid ');
            Q.SQL.Add(' where tp.cod_pessoa_produtor = tic.cod_pessoa_produtor ');
            Q.SQL.Add('   and tps.cod_pessoa = tp.cod_pessoa_produtor ');
            Q.SQL.Add('   and tpr.cod_propriedade_rural = tic.cod_propriedade_rural ');
            Q.SQL.Add('   and tid.cod_identificacao_dupla = tic.cod_tipo_identificacao_sisbov ');
            Q.SQL.Add('   and tic.ind_transmissao_sisbov in (''N'', ''E'') ');
    {$ENDIF}
            Q.Open;
            If Q.IsEmpty Then Begin
              Mensagens.Adicionar(2361, Self.ClassName, NomeMetodo, []);
              Result := -2361;
              Exit;
            End;

            // Comando de update que será utilizado para atualização
            QUpd.SQL.Clear;
       {$IFDEF MSSQL}
            QUpd.SQL.Add('update tab_inventario_codigo ');
            QUpd.SQL.Add('   set ind_transmissao_sisbov = :ind_transmissao_sisbov, ');
            QUpd.SQL.Add('       dta_transmissao_sisbov = :dta_transmissao_sisbov, ');
            QUpd.SQL.Add('       cod_id_transacao_sisbov = :cod_id_transacao_sisbov, ');
            QUpd.SQL.Add('       num_solicitacao_novo_sisbov = :num_solicitacao_novo_sisbov, ');
            QUpd.SQL.Add('       txt_mensagem_erro = :txt_mensagem_erro ');
            QUpd.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
            QUpd.SQL.Add('	 and cod_propriedade_rural = :cod_propriedade_rural ');
            QUpd.SQL.Add('	 and num_solicitacao_codigo = :num_solicitacao_codigo ');
       {$ENDIF}

            // Tenta transmitir cada registro obtido
            DtaSistema := Conexao.DtaSistema;
            while not Q.Eof do begin
              // Invoca o método SOAP
              Retorno := SoapSisbov.inventariarSolicitacaoNumeracao(Descriptografar(ValorParametro(118)),  // usuário
                                                                 Descriptografar(ValorParametro(119)),  // senha
                                                                 Q.FieldByName('num_solicitacao_codigo').AsInteger,
                                                                 Q.FieldByName('num_cpf_produtor').AsString,
                                                                 Q.FieldByName('num_cnpj_produtor').AsString,
                                                                 Q.FieldByName('cod_id_propriedade_sisbov').AsInteger,
                                                                 Q.FieldByName('cod_identificacao_dupla_sisbov').AsInteger
                                                                 );

              If Retorno <> nil then Begin
                // Trata retorno do método
                IdTransacao := Retorno.idTransacao;
                If Retorno.status = 0 then Begin
                  MsgRet := '';
                  for I := 0 to length(Retorno.listaErros) - 1 do begin
                    if MsgRet <> '' then MsgRet := MsgRet + ' / ';
                    MsgRet := MsgRet + Retorno.listaErros[I].menssagemErro;
                  end;
                  QUpd.ParamByName('ind_transmissao_sisbov').AsString := 'E';
                  QUpd.ParamByName('num_solicitacao_novo_sisbov').DataType := ftInteger;
                  QUpd.ParamByName('num_solicitacao_novo_sisbov').Clear;
                  QUpd.ParamByName('txt_mensagem_erro').AsString := MsgRet;
                End else Begin
                  QUpd.ParamByName('ind_transmissao_sisbov').AsString := 'S';
                  QUpd.ParamByName('num_solicitacao_novo_sisbov').AsInteger := Retorno.idSolicitacao;
                  QUpd.ParamByName('txt_mensagem_erro').DataType := ftString;
                  QUpd.ParamByName('txt_mensagem_erro').Clear;
                End;
              end else begin
                MsgRet := 'Erro no retorno do SISBOV';
                QUpd.ParamByName('ind_transmissao_sisbov').AsString := 'E';
                QUpd.ParamByName('num_solicitacao_novo_sisbov').DataType := ftInteger;
                QUpd.ParamByName('num_solicitacao_novo_sisbov').Clear;
                QUpd.ParamByName('txt_mensagem_erro').AsString := MsgRet;
              end;

              QUpd.ParamByName('cod_pessoa_produtor').AsInteger := Q.FieldByName('cod_pessoa_produtor').AsInteger;
              QUpd.ParamByName('cod_propriedade_rural').AsInteger := Q.FieldByName('cod_propriedade_rural').AsInteger;
              QUpd.ParamByName('num_solicitacao_codigo').AsInteger := Q.FieldByName('num_solicitacao_codigo').AsInteger;
              QUpd.ParamByName('dta_transmissao_sisbov').AsDateTime := DtaSistema;
              QUpd.ParamByName('cod_id_transacao_sisbov').AsInteger := IdTransacao;

              // Efetuar atualização
              QUpd.ExecSQL;

              // Próximo registro
              Q.Next;
            end;  // while

            Q.Close;
          end;  // if not conectado
        Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(2362, Self.ClassName, NomeMetodo, [E.Message]);
            Result := -2362;
            Exit;
          End;
        End;
      Finally
        SoapSisbov.Free;
      End;
    Finally
      QUpd.Free;
    End;
  Finally
    Q.Free;
  End;
end;

end.
