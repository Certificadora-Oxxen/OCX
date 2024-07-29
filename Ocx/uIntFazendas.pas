// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Propriedade Rural,fazenda, etc - Definição das Classes.doc
// *  Código Classe      : 34
// *  Descrição Resumida : Cadastro de Fazenda
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    24/07/2002    Criação
// *   Arley    13/08/2002    Alteração nos atributos desta classe
// *   Arley    13/11/2002    Inclusão da propriedade IndSituacaoImagem
// *   Hitalo    19/11/2002    Adcionar metodo GerarRelatorio.
// *
// ****************************************************************************
unit uIntFazendas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntFazenda, uIntRelatorios,dbtables, sysutils, db,
     uFerramentas, FileCtrl, uColecoes, uIntMensagens, uIntImportacoes,
     uConexao, uConsisteIE, WsSISBOV1, InvokeRegistry, Rio, SOAPHTTPClient;

const
  PAR_SGL_LOCAL: Integer = 99;
  PAR_DES_LOCAL: Integer = 100;
  PAR_SGL_FONTE_AGUA: Integer = 101;

type
  { TIntFazendas }
  TIntFazendas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntFazenda : TIntFazenda;
    function VerificaNumLetra(Valor: String; Tamanho: Integer;
      NomParametro: String): Integer;
    function PesquisarRelatorio(EQuery: THerdomQuery; SglProdutor, NomPessoaProdutor, SglFazenda,
      NomFazenda, CodSituacaoSISBOVFazenda, IndSituacaoImagemFazenda,
      NomPropriedadeRural, NumImovelReceitaFederal: String; CodLocalizacaoSisbov, CodEstado: Integer;
      NomMunicipio, CodMicroRegiao: String; var QtdPropriedadeRural, QtdFazenda,
      QtdAnimal: Integer; DtaInicioCadastramento, DtaFimCadastramento: TDateTime; CodTarefa: Integer;
      DtaInicioVistoria, DtaFimVistoria: TDateTime): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodOrdenacao: String): Integer;
    function Inserir(SglFazenda, NomFazenda: String;
      CodEstado: Integer; NumPropriedadeRural: String;
      CodRegimePosseUso: Integer; TxtObservacao, CodUlavPro, CodUlavFaz: String;
      QtdDistMun: Integer; DesAcessoFaz: String): Integer;
    function InserirDadoGeral(NumCNPJCPFProdutor,CodNaturezaProdutor, SglFazenda, NomFazenda: String;
      CodEstado: Integer; NumPropriedadeRural, NumImovelReceitaFederal: String;
      CodRegimePosseUso: Integer; TxtObservacao: String): Integer;
    function Alterar(CodFazenda: Integer; SglFazenda,
      NomFazenda: String; CodEstado: Integer; NumPropriedadeRural: String;
      CodRegimePosseUso: Integer; TxtObservacao, CodUlavPro, CodUlavFaz: String;
      QtdDistMun: Integer; DesAcessoFaz: String): Integer;
    function EfetivarCadastro(CodFazenda: Integer; IndProdutorDefinido: Integer; NumCNPJCpfProdutor: String): Integer;
    function CancelarEfetivacao(CodFazenda: Integer; IndExportarPropriedade: String): Integer;
    function Excluir(CodFazenda: Integer): Integer;
    function Buscar(CodFazenda: Integer): Integer;
    function DefinirPropriedadeRural(CodFazenda,
      CodPropriedadeRural: Integer): Integer;
    function DefinirImagem(CodFazenda: Integer; ArquivoOrigem: String): Integer;
    function LiberarImagem(CodFazenda: Integer): Integer;
    function RemoverImagem(CodFazenda: Integer): Integer;
    function GerarRelatorio(SglProdutor, NomPessoaProdutor, SglFazenda,
      NomFazenda, CodSituacaoSISBOVFazenda, IndSituacaoImagemFazenda,
      NomPropriedadeRural, NumImovelReceitaFederal: String; CodLocalizacaoSisbov,
      CodEstado: Integer; NomMunicipio, CodMicroRegiao: String;
      DtaInicioCadastramento, DtaFimCadastramento: TDateTime;
      Tipo, QtdQuebraRelatorio: integer; CodTarefa: Integer; DtaInicioVistoria,
      DtaFimVistoria: TDateTime): String;
    function AlterarCodigoExportacao(CodFazenda, CodExportacao: Integer): Integer;
    function desvincularProdutorPropriedade(cpfProdutor, cnpjProdutor: WideString;const idPropriedade: Int64):integer;
    class function VerificaFazendaEfetivada(EConexao: TConexao;
      EMensagens: TIntMensagens; ECodFazenda: Integer;
      var ECodPropriedadeRural: Integer; var ENumImovelReceitaFederal: String;
      var ECodLocalizacaoSISBOV: Integer; var EDtaInicioCertificacao: TDateTime;
      ENomeCampo: String): Integer;

    /////////////////////////////
    // Métodos da carga inicial
    function InserirFazendaCargaInicial(CodArquivoExportacao,
      CodPropriedadeRural, CodPessoaProdutor: Integer; NomFazenda,
      RegimePosseUso, CodLocalizacaoSISBOV: String): Integer;
    procedure EfetivarCadastroCargaInicial(CodFazenda, CodPessoaProdutor,
      CodLocalizacaoSISBOV, CodArquivoSISBOV: Integer);
    /////////////////////////////

    property IntFazenda : TIntFazenda read FIntFazenda write FIntFazenda;
  end;

implementation

uses uIntLocais, uIntEnderecos, SqlExpr, uIntSoapSisbov;

{ TIntFazendas }
constructor TIntFazendas.Create;
begin
  inherited;
  FIntFazenda := TIntFazenda.Create;
end;

destructor TIntFazendas.Destroy;
begin
  FIntFazenda.Free;
  inherited;
end;

function TIntFazendas.VerificaNumLetra(Valor: String;
  Tamanho: Integer; NomParametro: String): Integer;
var
  X : Integer;
begin
  Result := 0;
  If Length(Valor) > Tamanho Then Begin
    Mensagens.Adicionar(537, Self.ClassName, 'VerificaNumLetra', [NomParametro, IntToStr(Tamanho)]);
    Result := -537;
    Exit;
  End;

  For X := 1 to Length(Valor) do Begin
    If Pos(Copy(Valor, X, 1), '0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ') = 0 Then Begin
      Mensagens.Adicionar(538, Self.ClassName, 'VerificaNumLetra', [NomParametro]);
      Result := -538;
      Exit;
    End;
  End;
end;

function TIntFazendas.Pesquisar(CodOrdenacao: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(106) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Pesquisar', []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select');
  Query.SQL.Add('  tf.cod_pessoa_produtor as CodPessoaProdutor');
  Query.SQL.Add('  , tf.cod_fazenda as CodFazenda');
  Query.SQL.Add('  , tf.sgl_fazenda as SglFazenda');
  Query.SQL.Add('  , tf.nom_fazenda as NomFazenda');
  Query.SQL.Add('  , tf.ind_situacao_imagem as IndSituacaoImagem ');
  Query.SQL.Add('  , tpr.num_imovel_receita_federal as NumImovelReceitaFederalPR');
  Query.SQL.Add('  , tpr.cod_id_propriedade_sisbov as CodIdPropriedadeSisbov');
  Query.SQL.Add('  , case isnull(tf.dta_efetivacao_cadastro,0)');
  Query.SQL.Add('      when 0 then ''N''');
  Query.SQL.Add('      else ''S''');
  Query.SQL.Add('    end as IndCadastroEfetivado');
  Query.SQL.Add('  , tls.cod_localizacao_sisbov as CodLocalizacaoSisbov');
  Query.SQL.Add('from');
  Query.SQL.Add('    tab_fazenda tf');
  Query.SQL.Add('  , tab_propriedade_rural tpr');
  Query.SQL.Add('  , tab_localizacao_sisbov tls');
  Query.SQL.Add('where');
  Query.SQL.Add('  tf.cod_propriedade_rural *= tpr.cod_propriedade_rural');
  Query.SQL.Add('  and tf.cod_propriedade_rural  *= tls.cod_propriedade_rural ');
  Query.SQL.Add('  and tf.cod_pessoa_produtor    *= tls.cod_pessoa_produtor ');
  Query.SQL.Add('  and tf.cod_pessoa_produtor = :cod_pessoa_produtor ');
  Query.SQL.Add('  and tf.dta_fim_validade is null ');
  If Uppercase(CodOrdenacao) = 'C' Then Begin
    Query.SQL.Add(' order by tf.cod_fazenda ');
  End;
  If Uppercase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by tf.sgl_fazenda ');
  End;
  If Uppercase(CodOrdenacao) = 'N' Then Begin
    Query.SQL.Add(' order by tf.nom_fazenda ');
  End;
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(326, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -326;
      Exit;
    End;
  End;
end;

function TIntFazendas.Inserir(SglFazenda, NomFazenda: String;
  CodEstado: Integer; NumPropriedadeRural: String;
  CodRegimePosseUso: Integer; TxtObservacao, CodUlavPro, CodUlavFaz: String;
  QtdDistMun: Integer; DesAcessoFaz: String): Integer;
var
  Q : THerdomQuery;
  CodFazenda, CodRegistroLog, CodFonteAgua: Integer;
  DesFonteAgua, SglFonteAgua, SglLocal, DesLocal: String;
  IntLocais: TIntLocais;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(107) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Inserir', []);
    Result := -307;
    Exit;
  End;

   // Garante que os caracteres da sigla estão em maiúsculo
  SglFazenda := UpperCase(SglFazenda);

  // Trata sigla do Fazenda
  Result := VerificaString(SglFazenda, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Verifica se a sigla só contém letras maíusculas e números
  Result := VerificaNumLetra(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do Fazenda
  Result := VerificaString(NomFazenda, 'Nome da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomFazenda, 50, 'Nome da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata número da Propriedade Rural
  If NumPropriedadeRural <> '' Then Begin
    Result := TrataString(NumPropriedadeRural, 25, 'Número da Propriedade rural');
    If Result < 0 Then Begin
      Exit;
    End;
    If CodEstado <= 0 then Begin
      Mensagens.Adicionar(386, Self.ClassName, 'Inserir', []);
      Result := -386;
      Exit;
    End;
  End;

  if CodUlavPro = '' then begin
    CodUlavPro := '0';
  end;

  if CodUlavFaz = '' then begin
    CodUlavFaz := '0';
  end;

  // Trata valores da distancia da fazenda para o municipio
  if (QtdDistMun <= 0) or (QtdDistMun > 9999) then
  begin
    Mensagens.Adicionar(2273, Self.ClassName, 'Inserir', []);
    Result := -2273;
    Exit;
  end;

  if (Length(Trim(DesAcessoFaz)) = 0) then begin
    Mensagens.Adicionar(2307, Self.ClassName, 'Inserir', []);
    Result := -2307;
    Exit;
  end;

  // Trata descrição do acesso a fazenda
  Result := TrataString(DesAcessoFaz, 200, 'Acesso fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata Observações
  Result := TrataString(TxtObservacao, 255, 'Observação');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Consiste o estado
      If CodEstado > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_estado ');
        Q.SQL.Add(' where cod_estado = :cod_estado ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(387, Self.ClassName, 'Inserir', []);
          Result := -387;
          Exit;
        End;
        Q.Close;

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select count(*) as QtdRegistros from tab_fazenda ');
        Q.SQL.Add(' where num_propriedade_rural = :num_propriedade_rural ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('num_propriedade_rural').AsString := NumPropriedadeRural;
        Q.Open;
        If Q.FieldByName('QtdRegistros').AsInteger >= 1 Then Begin
          Mensagens.Adicionar(2306, Self.ClassName, 'Inserir', []);
          Result := -2306;
          Exit;
        End;
        Q.Close;
      End;

      // Consiste indicador de tipo
      If CodRegimePosseUso > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_regime_posse_uso ');
        Q.SQL.Add(' where cod_regime_posse_uso = :cod_regime_posse_uso ');
{$ENDIF}
        Q.ParamByName('cod_regime_posse_uso').AsInteger := CodRegimePosseUso;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1692, Self.ClassName, 'Inserir', []);
          Result := -1692;
          Exit;
        End;
        Q.Close;
      End;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
      Q.SQL.Add('   and sgl_fazenda = :sgl_fazenda');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('sgl_fazenda').AsString := SglFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(328, Self.ClassName, 'Inserir', [SglFazenda]);
        Result := -328;
        Exit;
      End;
      Q.Close;

{ Removido 30/12/2004 - Fábio - Essa consitencia não é mais necessária.
      // Verifica duplicidade de nome
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and nom_fazenda = :nom_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('nom_fazenda').AsString := NomFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(329, Self.ClassName, 'Inserir', [NomFazenda]);
        Result := -329;
        Exit;
      End;
      Q.Close;
}
      // Obtem os parametros para
      SglFonteAgua := Conexao.ValorParametro(PAR_SGL_FONTE_AGUA, Mensagens);
      SglLocal := Conexao.ValorParametro(PAR_SGL_LOCAL, Mensagens);
      DesLocal := Conexao.ValorParametro(PAR_DES_LOCAL, Mensagens);

      // Obtem o código da fonte de agua
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tipo_fonte_agua, des_tipo_fonte_agua');
      Q.SQL.Add('  from tab_tipo_fonte_agua');
      Q.SQL.Add(' where sgl_tipo_fonte_agua = :sgl_tipo_fonte_agua');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('sgl_tipo_fonte_agua').AsString := SglFonteAgua;
      Q.Open;
      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2077, Self.ClassName, 'Inserir', []);
        Result := -2077;
        Exit;
      end;
      CodFonteAgua := Q.FieldByName('cod_tipo_fonte_agua').AsInteger;
      DesFonteAgua := Q.FieldByName('des_tipo_fonte_agua').AsString;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_fazenda), 0) + 1 as cod_fazenda ');
      Q.SQL.Add('  from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      CodFazenda := Q.FieldByName('cod_fazenda').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_fazenda ' +
                ' (cod_pessoa_produtor, ' +
                '  cod_fazenda, ' +
                '  sgl_fazenda, ' +
                '  nom_fazenda, ' +
                '  cod_estado, ' +
                '  num_propriedade_rural, ' +
                '  ind_efetivado_uma_vez, ' +
                '  ind_situacao_imagem, ' +
                '  cod_regime_posse_uso, '+
                '  txt_observacao,' +
                '  dta_cadastramento, ' +
                '  cod_registro_log, ' +
                '  dta_fim_validade, ' +
                '  cod_ulav_produtor, ' +
                '  cod_ulav_fazenda, ' +
                '  qtd_distancia_municipio, ' +
                '  des_acesso_fazenda) ' +
                'values ' +
                ' (:cod_pessoa_produtor, ' +
                '  :cod_fazenda, ' +
                '  :sgl_fazenda, ' +
                '  :nom_fazenda, ' +
                '  :cod_estado, ' +
                '  :num_propriedade_rural, ' +
                '  ''N'', ' +
                '  ''N'', ' +
                '  :cod_regime_posse_uso, '+
                '  :txt_observacao,' +
                '  getdate(), ' +
                '  :cod_registro_log, ' +
                '  null, ' +
                '  :cod_ulav_produtor, ' +
                '  :cod_ulav_fazenda, ' +
                '  :qtd_distancia_municipio, ' +
                '  :des_acesso_fazenda) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_fazenda').AsString := SglFazenda;
      Q.ParamByName('nom_fazenda').AsString := NomFazenda;
      If CodEstado > 0 Then Begin
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
      End Else Begin
        Q.ParamByName('cod_estado').DataType := ftInteger;
        Q.ParamByName('cod_estado').Clear;
      End;
      If NumPropriedadeRural <> '' Then Begin
        Q.ParamByName('num_propriedade_rural').AsString := NumPropriedadeRural;
      End Else Begin
        Q.ParamByName('num_propriedade_rural').DataType := ftString;
        Q.ParamByName('num_propriedade_rural').Clear;
      End;
      If CodRegimePosseUso > 0 Then Begin
        Q.ParamByName('cod_regime_posse_uso').AsInteger := CodRegimePosseUso;
      End Else Begin
        Q.ParamByName('cod_regime_posse_uso').DataType := ftInteger;
        Q.ParamByName('cod_regime_posse_uso').Clear;
      End;
      Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      Q.ParamByName('cod_ulav_produtor').AsString := CodUlavPro;
      Q.ParamByName('cod_ulav_fazenda').AsString := CodUlavFaz;
      Q.ParamByName('qtd_distancia_municipio').AsInteger := QtdDistMun;
      Q.ParamByName('des_acesso_fazenda').AsString := DesAcessoFaz;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 1, 107);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      { Inicio alteração - 17/12/2004 - Fábio }
      // Insere o local padrão
      IntLocais := TIntLocais.Create;
      try
        Result := IntLocais.Inicializar(Conexao, Mensagens);
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;

        Result := IntLocais.Inserir(CodFazenda, SglLocal, DesLocal,
          IntToStr(CodFonteAgua), 'S');
        if Result < 0 then
        begin
          Rollback;
          Exit;
        end;

        Mensagens.Adicionar(2078, Self.ClassName, 'Inserir',
          [SglLocal, DesLocal, SglFonteAgua + ', ' + DesFonteAgua]);
        Result := CodFazenda;
      finally
        IntLocais.Free;
      end;
      { Fim alteração - 17/12/2004 - Fábio }

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      { Atualiza Grandeza }
      // Fazendas - Cadastradas
      Result := AtualizaGrandeza(7, Conexao.CodProdutorTrabalho, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      // Fazendas - Não controlados pela certificadora
      Result := AtualizaGrandeza(9, Conexao.CodProdutorTrabalho, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
*)

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodFazenda;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(330, Self.ClassName, 'Inserir', [E.Message]);
        Result := -330;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.Alterar(CodFazenda: Integer; SglFazenda,
  NomFazenda: String; CodEstado: Integer; NumPropriedadeRural: String;
  CodRegimePosseUso: Integer; TxtObservacao, CodUlavPro, CodUlavFaz: String;
  QtdDistMun: Integer; DesAcessoFaz: String): Integer;
var
  Q : THerdomQuery;
  CodIdPropriedade, CodRegistroLog : Integer;
  NomMetodo, Cpf, Cnpj, CpfCnpjProdutor : String;
  Conectado, AlterarInscricaoEstadual : boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoAlterarIE;
begin
  NomMetodo := 'AlterarFazenda';
  Result := -1;
  AlterarInscricaoEstadual := false;
  CodIdPropriedade := 0;
  CpfCnpjProdutor  := '';
  Cpf              := '';
  Cnpj             := '';

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(108) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Alterar', []);
    Result := -307;
    Exit;
  End;

  // Garante que os caracteres da sigla estão em maiúsculo
  SglFazenda := UpperCase(SglFazenda);

  // Trata sigla do Fazenda
  Result := TrataString(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Verifica se a sigla só contém letras maíusculas e números
  Result := VerificaNumLetra(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata nome do Fazenda
  Result := TrataString(NomFazenda, 50, 'Nome da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata número da Propriedade Rural
  If NumPropriedadeRural <> '' Then Begin
    Result := TrataString(NumPropriedadeRural, 25, 'Número da Propriedade rural');
    If Result < 0 Then Begin
      Exit;
    End;
    If CodEstado <= 0 then Begin
      Mensagens.Adicionar(386, Self.ClassName, 'Alterar', []);
      Result := -386;
      Exit;
    End;
  End;

  if CodUlavPro = '' then begin
    CodUlavPro := '0';
  end;

  if CodUlavFaz = '' then begin
    CodUlavFaz := '0';
  end;

  // Trata valores da distancia da fazenda para o municipio
  if (QtdDistMun <= 0) or (QtdDistMun > 9999) then
  begin
    Mensagens.Adicionar(2273, Self.ClassName, 'Alterar', []);
    Result := -2273;
    Exit;
  end;

  if (Length(Trim(DesAcessoFaz)) = 0) then begin
    Mensagens.Adicionar(2307, Self.ClassName, 'Alterar', []);
    Result := -2307;
    Exit;
  end;

  // Trata descrição do acesso a fazenda
  Result := TrataString(DesAcessoFaz, 200, 'Acesso fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata Observações
  Result := TrataString(TxtObservacao, 255, 'Observação');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    Try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.conectado('Alterar Fazenda');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, 'AlterarFazenda', ['não foi possível transmitir dados da fazenda, tente mais tarde.']);
        Result := -2289;
        Exit;
      end;

      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text :=
        ' select ' +
        '    tf.cod_registro_log ' +
        '  , tf.cod_estado ' +
        '  , tf.sgl_fazenda ' +
        '  , tf.ind_efetivado_uma_vez ' +
        '  , tf.cod_estado ' +
        '  , tf.num_propriedade_rural ' +
        '  , tp.num_cnpj_cpf ' +
        '  , tr.cod_id_propriedade_sisbov ' +
        '  , tls.ind_trans_relac_produtor_prop ' +
        'from ' +
        '  tab_fazenda tf ' +
        ', tab_pessoa tp ' +
        ', tab_propriedade_rural tr ' +
        ', tab_localizacao_sisbov tls ' +
        'where ' +
        '      tf.cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and tf.cod_fazenda = :cod_fazenda ' +
        '  and tf.dta_fim_validade is null ' +
        '  and tf.cod_pessoa_produtor = tp.cod_pessoa ' +
        '  and tf.cod_propriedade_rural *= tr.cod_propriedade_rural ' +
        '  and tf.cod_propriedade_rural *= tls.cod_propriedade_rural ' +
        '  and tf.cod_pessoa_produtor *= tls.cod_pessoa_produtor ';


{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'Alterar', []);
        Result := -310;
        Exit;
      End;

      if (Q.FieldByName('num_propriedade_rural').AsString <> NumPropriedadeRural) and
         (Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) and
         (Q.FieldByName('ind_trans_relac_produtor_prop').AsString = 'S') then begin
         AlterarInscricaoEstadual := true;
         CodIdPropriedade := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
         CpfCnpjProdutor  := Q.FieldByName('num_cnpj_cpf').AsString;
      end;

      // Verifica se a sigla pode ser alterada
      If (Q.FieldByName('ind_efetivado_uma_vez').AsString = 'S')
        and (Trim(Q.FieldByName('sgl_fazenda').AsString) <> Trim(SglFazenda)) Then Begin
        Mensagens.Adicionar(1378, Self.ClassName, 'Alterar', []);
        Result := -1378;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Consiste o estado
      If CodEstado > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_estado ');
        Q.SQL.Add(' where cod_estado = :cod_estado ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(387, Self.ClassName, 'Alterar', []);
          Result := -387;
          Exit;
        End;
        Q.Close;

        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add(' select count(*) as QtdRegistros ');
        Q.SQL.Add('     ,  cod_pessoa_produtor ');
        Q.SQL.Add('     ,  cod_fazenda ');
        Q.SQL.Add('     ,  cod_estado ');
        Q.SQL.Add(' from tab_fazenda ');
        Q.SQL.Add(' where num_propriedade_rural = :num_propriedade_rural ');
        Q.SQL.Add('   and dta_fim_validade is null ');
        Q.SQL.Add(' group by cod_pessoa_produtor ');
        Q.SQL.Add('       ,  cod_fazenda ');
        Q.SQL.Add('       ,  cod_estado ');
{$ENDIF}
        Q.ParamByName('num_propriedade_rural').AsString := NumPropriedadeRural;
        Q.Open;

        If not Q.IsEmpty Then Begin
          If (Q.FieldByName('QtdRegistros').AsInteger >= 2) or
             ((Q.FieldByName('cod_pessoa_produtor').AsInteger <> Conexao.CodProdutorTrabalho) and
              (Q.FieldByName('cod_fazenda').AsInteger <> CodFazenda) and
              (Q.FieldByName('cod_estado').AsInteger = CodEstado)) or
             ((Q.FieldByName('cod_pessoa_produtor').AsInteger = Conexao.CodProdutorTrabalho) and
              (Q.FieldByName('cod_fazenda').AsInteger <> CodFazenda) and
              (Q.FieldByName('cod_estado').AsInteger = CodEstado)) Then Begin
            Mensagens.Adicionar(2306, Self.ClassName, 'Alterar', []);
            Result := -2306;
            Exit;
          end;
        end;
        Q.Close;
      End;

      // Consiste indicador de tipo
      If CodRegimePosseUso > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_regime_posse_uso ');
        Q.SQL.Add(' where cod_regime_posse_uso = :cod_regime_posse_uso ');
{$ENDIF}
        Q.ParamByName('cod_regime_posse_uso').AsInteger := CodRegimePosseUso;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1692, Self.ClassName, 'Inserir', []);
          Result := -1692;
          Exit;
        End;
        Q.Close;
      End;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda != :cod_fazenda ');
      Q.SQL.Add('   and sgl_fazenda = :sgl_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_fazenda').AsString := SglFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(328, Self.ClassName, 'Alterar', [SglFazenda]);
        Result := -328;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda != :cod_fazenda ');
      Q.SQL.Add('   and nom_fazenda = :nom_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('nom_fazenda').AsString := NomFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(329, Self.ClassName, 'Alterar', [NomFazenda]);
        Result := -329;
        Exit;
      End;
      Q.Close;

      if AlterarInscricaoEstadual then begin
        try
          if Length(CpfCnpjProdutor) = 11 then begin
            Cpf  := CpfCnpjProdutor;
            Cnpj := '';
          end else begin
            Cpf  := '';
            Cnpj := CpfCnpjProdutor;
          end;

          RetornoSisbov := SoapSisbov.alterarIE(
                               Descriptografar(ValorParametro(118))
                             , Descriptografar(ValorParametro(119))
                             , Cpf
                             , Cnpj
                             , CodIdPropriedade
                             , NumPropriedadeRural);
        except
           on E: Exception do
           begin
             Mensagens.Adicionar(2296, Self.ClassName, 'AlterarFazenda', ['']);
             Result := -2296;
             Exit;
           end;
        end;

        If RetornoSisbov <> nil then begin
          If RetornoSisbov.Status = 0 then begin
            Mensagens.Adicionar(2296, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoSisbov)]);
            Result := -2296;
            Exit;
          end;
        end else begin
          Mensagens.Adicionar(2296, Self.ClassName, 'AlterarFazenda', ['']);
          Result := -2296;
          Exit;
        end;
      end;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 108);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_fazenda ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   sgl_fazenda = :sgl_fazenda,');
      Q.SQL.Add('   nom_fazenda = :nom_fazenda,');
      Q.SQL.Add('   cod_estado = :cod_estado,');
      Q.SQL.Add('   num_propriedade_rural = :num_propriedade_rural,');
      Q.SQL.Add('   cod_regime_posse_uso = :cod_regime_posse_uso, ');
      Q.SQL.Add('   txt_observacao = :txt_observacao,');
      Q.SQL.Add('   cod_ulav_produtor = :cod_ulav_produtor,');
      Q.SQL.Add('   cod_ulav_fazenda  = :cod_ulav_fazenda,');
      Q.SQL.Add('   qtd_distancia_municipio = :qtd_distancia_municipio,');
      Q.SQL.Add('   des_acesso_fazenda = :des_acesso_fazenda,');

      // Pra tirar a vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
{$ENDIF}
      Q.ParamByName('sgl_fazenda').DataType           := ftString;
      Q.ParamByName('nom_fazenda').DataType           := ftString;
      Q.ParamByName('num_propriedade_rural').DataType := ftString;
      Q.ParamByName('cod_estado').DataType            := ftInteger;
      Q.ParamByName('cod_regime_posse_uso').DataType := ftInteger;
      Q.ParamByName('txt_observacao').DataType        := ftString;
      Q.ParamByName('cod_ulav_produtor').DataType := ftString;
      Q.ParamByName('cod_ulav_fazenda').DataType := ftString;
      Q.ParamByName('qtd_distancia_municipio').DataType := ftInteger;
      Q.ParamByName('des_acesso_fazenda').DataType := ftString;

      AtribuiValorParametro(Q.ParamByName('sgl_fazenda'), SglFazenda);
      AtribuiValorParametro(Q.ParamByName('nom_fazenda'), NomFazenda);
      AtribuiValorParametro(Q.ParamByName('num_propriedade_rural'), NumPropriedadeRural);
      AtribuiValorParametro(Q.ParamByName('cod_estado'), CodEstado);
      AtribuiValorParametro(Q.ParamByName('cod_regime_posse_uso'), CodRegimePosseUso);
      AtribuiValorParametro(Q.ParamByName('txt_observacao'), TxtObservacao);
      AtribuiValorParametro(Q.ParamByName('cod_ulav_produtor'), CodUlavPro);
      AtribuiValorParametro(Q.ParamByName('cod_ulav_fazenda'), CodUlavFaz);
      AtribuiValorParametro(Q.ParamByName('qtd_distancia_municipio'), QtdDistMun);
      AtribuiValorParametro(Q.ParamByName('des_acesso_fazenda'), DesAcessoFaz);

      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 108);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(332, Self.ClassName, 'Alterar', [E.Message]);
        Result := -332;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


function TIntFazendas.AlterarCodigoExportacao(CodFazenda, CodExportacao: Integer): Integer;
var
  Q : THerdomQuery;
  CodPropriedadeRural, CodLocalizacaoSisbov, CodRegistroLog : Integer;
  NomMetodo : String;
begin
  NomMetodo := 'AlterarCodigoExportacao';
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(651) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Alterar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text :=
        ' select ' +
        '    tf.cod_registro_log ' +
        '  , tp.ind_transmissao_sisbov ' +
        '  , tr.cod_propriedade_rural ' +
        '  , tr.cod_id_propriedade_sisbov ' +
        '  , tls.ind_trans_relac_produtor_prop ' +
        '  , tls.cod_localizacao_sisbov ' +
        'from ' +
        '  tab_fazenda tf ' +
        ', tab_produtor tp ' +
        ', tab_propriedade_rural tr ' +
        ', tab_localizacao_sisbov tls ' +
        'where ' +
        '      tf.cod_pessoa_produtor    = :cod_pessoa_produtor ' +
        '  and tf.cod_fazenda            = :cod_fazenda ' +
        '  and tf.dta_fim_validade is null ' +
        '  and tf.cod_pessoa_produtor    = tp.cod_pessoa_produtor ' +
        '  and tf.cod_propriedade_rural *= tr.cod_propriedade_rural ' +
        '  and tf.cod_propriedade_rural *= tls.cod_propriedade_rural ' +
        '  and tf.cod_pessoa_produtor   *= tls.cod_pessoa_produtor ';

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'AlterarCodigoExportacao', []);
        Result := -310;
        Exit;
      End;

      if (Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) or
         (Q.FieldByName('ind_trans_relac_produtor_prop').AsString = 'S') or
         (Q.FieldByName('ind_transmissao_sisbov').AsString = 'S') then begin
        Mensagens.Adicionar(2389, Self.ClassName, 'AlterarCodigoExportacao', []);
        Result := -2389;
        Exit;
      end;

      CodRegistroLog       := Q.FieldByName('cod_registro_log').AsInteger;
      CodPropriedadeRural  := Q.FieldByName('cod_propriedade_rural').AsInteger;
      CodLocalizacaoSisbov := Q.FieldByName('cod_localizacao_sisbov').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 651);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text := ' update tab_fazenda ' +
                    '    set dta_efetivacao_cadastro = ''2007-01-01 00:00:00'' ' +
                    '    ,   ind_efetivado_uma_vez = ''S'' ' +
                    ' where  cod_pessoa_produtor = :cod_pessoa_produtor ' +
                    '  and   cod_fazenda         = :cod_fazenda ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text := ' update tab_produtor ' +
                    '    set dta_efetivacao_cadastro = ''2007-01-01 00:00:00'' ' +
                    '    ,   ind_efetivado_uma_vez = ''S'' ' +
                    ' where  cod_pessoa_produtor = :cod_pessoa_produtor ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text := ' update tab_propriedade_rural ' +
                    '    set dta_efetivacao_cadastro = ''2007-01-01 00:00:00'' ' +
                    '    ,   ind_efetivado_uma_vez = ''S'' ' +
                    ' where  cod_propriedade_rural = :cod_propriedade_rural ';
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      if CodLocalizacaoSisbov > 0 then begin
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Text := ' update tab_localizacao_sisbov ' +
                      '    set cod_localizacao_sisbov = :cod_localizacao_sisbov ' +
                      '    ,   cod_arquivo_sisbov     = 1 ' +
                      ' where  cod_propriedade_rural  = :cod_propriedade_rural ' +
                      '  and   cod_pessoa_produtor    = :cod_pessoa_produtor ';
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger    := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
        Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodExportacao;
        Q.ExecSQL;

      end else begin
        // Tenta Inserir Registro
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_localizacao_sisbov ' +
                  ' values ( ' +
                  '         :cod_propriedade_rural, ' +
                  '         :cod_pessoa_produtor, ' +
                  '         :cod_localizacao_sisbov, ' +
                  '         1, ' +
                  '         null, ' +
                  '         null, ' +
                  '         null) ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger    := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
        Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodExportacao;
        Q.ExecSQL;
      end;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 651);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Finally
      Q.Free;
    End;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(332, Self.ClassName, 'Alterar', [E.Message]);
      Result := -332;
      Exit;
    End;
  End;
end;


function TIntFazendas.Excluir(CodFazenda: Integer): Integer;
var
  Q: THerdomQuery;
  CodRegistroLog,
  CodPropriedadeRural: Integer;
  bCadastroEfetivado: Boolean;
  sArquivo, sAux: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(110) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Excluir', []);
    Result := -307;
    Exit;
  End;

  // Recupera pasta adequada de imagens
  sArquivo := Conexao.CaminhoArquivosCertificadora + ValorParametro(22);
  if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
    sArquivo := sArquivo + '\';
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Text :=
        'select '+
        '  cod_registro_log '+
        '  , dta_efetivacao_cadastro '+
        '  , right(''00000'' + CAST(cod_pessoa_produtor as VARCHAR(5)), 5) + '+
        '    right(''00000'' + CAST(cod_fazenda as VARCHAR(5)), 5) as arquivo '+
        'from '+
        '  tab_fazenda '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda '+
        '  and dta_fim_validade is null ';
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'Excluir', []);
        Result := -310;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      bCadastroEfetivado := not Q.FieldByName('dta_efetivacao_cadastro').IsNull;
      sArquivo := sArquivo + Q.FieldByName('arquivo').AsString;
      Q.Close;

      // Consiste se o cadastro já foi efetivado
      if bCadastroEfetivado then begin
        Mensagens.Adicionar(512, Self.ClassName, 'Excluir', []);
        Result := -512;
        Exit;
      end;

      // Verifica relacionamento com Lote
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_lote ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(334, Self.ClassName, 'Excluir', []);
        Result := -334;
        Exit;
      End;
      Q.Close;

      // Verifica relacionamento com Local
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_local ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(527, Self.ClassName, 'Excluir', []);
        Result := -527;
        Exit;
      End;
      Q.Close;

      // Verifica relacionamento com animal
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal '+
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and (cod_fazenda_nascimento = :cod_fazenda '+
                '        or cod_fazenda_identificacao = :cod_fazenda '+
                '        or cod_fazenda_manejo = :cod_fazenda '+
                '        or cod_fazenda_corrente = :cod_fazenda )'+
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1040, Self.ClassName, 'Excluir', []);
        Result := -1040;
        Exit;
      End;
      Q.Close;

      // Verifica relacionamento com evento
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_evento_transferencia '+
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and (cod_fazenda_origem = :cod_fazenda '+
                '        or cod_fazenda_destino = :cod_fazenda )');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1041, Self.ClassName, 'Excluir', []);
        Result := -1041;
        Exit;
      End;
      Q.Close;


      // Obtem a propriedade da fazenda
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_propriedade_rural from tab_fazenda');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      CodPropriedadeRural := Q.FieldByName('cod_propriedade_rural').AsInteger;
      Q.Close;

      // Verifica relacionamento com ordem de servico
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_ordem_servico '+
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and cod_propriedade_rural = :cod_propriedade_rural '+
                '   and cod_situacao_os <> 99 ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(2270, Self.ClassName, 'Excluir', []);
        Result := -2270;
        Exit;
      End;
      Q.Close;

      // Verifica se existem códigos SISBOV associados à fazenda
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(cod_animal_sisbov) as QtdCodigos from tab_codigo_sisbov '+
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.FieldByName('QtdCodigos').AsInteger > 0 Then Begin
        Mensagens.Adicionar(2070, Self.ClassName, 'Excluir', []);
        Result := -2070;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 5, 110);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_fazenda ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;


      // Exclui o código de exportação para o SISBOV
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_localizacao_sisbov ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      { Atualiza Grandeza }
      // Fazendas - Cadastradas
      Result := AtualizaGrandeza(7, Conexao.CodProdutorTrabalho, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      if bCadastroEfetivado then begin
        // Fazendas - Identificadas no SISBOV
        Result := AtualizaGrandeza(8, Conexao.CodProdutorTrabalho, -1);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end else begin
        // Fazendas - Não controlados pela certificadora
        Result := AtualizaGrandeza(9, Conexao.CodProdutorTrabalho, -1);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;
*)

      // Verifica se já existe um arquivo de imagem do tipo JPG
      sAux := sArquivo+'.jpg';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;
      // Verifica se já existe um arquivo de imagem do tipo JPEG
      sAux := sArquivo+'.jpeg';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;
      // Verifica se já existe um arquivo de imagem do tipo GIF
      sAux := sArquivo+'.gif';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(336, Self.ClassName, 'Excluir', [E.Message]);
        Result := -336;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.Buscar(CodFazenda: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(109) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Buscar', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ');
      Q.SQL.Add('  tf.cod_pessoa_produtor ');
      Q.SQL.Add('  , tf.cod_fazenda ');
      Q.SQL.Add('  , tf.sgl_fazenda ');
      Q.SQL.Add('  , tf.nom_fazenda ');
      Q.SQL.Add('  , te.cod_estado ');
      Q.SQL.Add('  , te.sgl_estado ');
      Q.SQL.Add('  , tf.num_propriedade_rural ');
      Q.SQL.Add('  , tf.txt_observacao ');
      Q.SQL.Add('  , tpr.cod_propriedade_rural ');
      Q.SQL.Add('  , tpr.nom_propriedade_rural ');
      Q.SQL.Add('  , tpr.num_imovel_receita_federal ');
      Q.SQL.Add('  , tpr.cod_id_propriedade_sisbov ');
      Q.SQL.Add('  , tmpr.nom_municipio as nom_municipio_pr ');
      Q.SQL.Add('  , tepr.sgl_estado as sgl_estado_pr ');
      Q.SQL.Add('  , tppr.nom_pais as nom_pais_pr ');
      Q.SQL.Add('  , tf.dta_cadastramento ');
      Q.SQL.Add('  , tf.dta_efetivacao_cadastro ');
      Q.SQL.Add('  , tf.ind_efetivado_uma_vez ');
      Q.SQL.Add('  , tf.ind_situacao_imagem ');
      Q.SQL.Add('  , tls.cod_localizacao_sisbov');
      Q.SQL.Add('  , titp.cod_regime_posse_uso ');
      Q.SQL.Add('  , titp.des_regime_posse_uso ');
      Q.SQL.Add('  , tf.cod_ulav_produtor ');
      Q.SQL.Add('  , tf.cod_ulav_fazenda ');
      Q.SQL.Add('  , tf.qtd_distancia_municipio ');
      Q.SQL.Add('  , tf.des_acesso_fazenda ');
      Q.SQL.Add('from ');
      Q.SQL.Add('  tab_fazenda tf ');
      Q.SQL.Add('  , tab_estado te ');
      Q.SQL.Add('  , tab_propriedade_rural tpr ');
      Q.SQL.Add('  , tab_municipio tmpr ');
      Q.SQL.Add('  , tab_estado tepr ');
      Q.SQL.Add('  , tab_pais tppr ');
      Q.SQL.Add('  , tab_localizacao_sisbov tls ');
      Q.SQL.Add('  , tab_regime_posse_uso titp ');
      Q.SQL.Add('where ');
      Q.SQL.Add('  tpr.cod_municipio *= tmpr.cod_municipio ');
      Q.SQL.Add('  and tpr.cod_estado *= tepr.cod_estado ');
      Q.SQL.Add('  and tpr.cod_pais *= tppr.cod_pais ');
      Q.SQL.Add('  and tf.cod_propriedade_rural = tpr.cod_propriedade_rural ');
      Q.SQL.Add('  and tf.cod_estado *= te.cod_estado ');
      Q.SQL.Add('  and tf.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('  and tf.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('  and tf.dta_fim_validade is null ');
      Q.SQL.Add('  and tf.cod_propriedade_rural  *= tls.cod_propriedade_rural ');
      Q.SQL.Add('  and tf.cod_pessoa_produtor    *= tls.cod_pessoa_produtor ');
      Q.SQL.Add('  and tf.cod_regime_posse_uso *= titp.cod_regime_posse_uso ');
      Q.SQL.Add(' ');
      Q.SQL.Add('union all ');
      Q.SQL.Add(' ');
      Q.SQL.Add('select ');
      Q.SQL.Add('  tf.cod_pessoa_produtor ');
      Q.SQL.Add('  , tf.cod_fazenda ');
      Q.SQL.Add('  , tf.sgl_fazenda ');
      Q.SQL.Add('  , tf.nom_fazenda ');
      Q.SQL.Add('  , te.cod_estado ');
      Q.SQL.Add('  , te.sgl_estado ');
      Q.SQL.Add('  , tf.num_propriedade_rural ');
      Q.SQL.Add('  , tf.txt_observacao ');
      Q.SQL.Add('  , null as cod_propriedade_rural ');
      Q.SQL.Add('  , null as nom_propriedade_rural ');
      Q.SQL.Add('  , null as num_imovel_receita_federal ');
      Q.SQL.Add('  , null as cod_id_propriedade_sisbov ');
      Q.SQL.Add('  , null as nom_municipio_pr ');
      Q.SQL.Add('  , null as sgl_estado_pr ');
      Q.SQL.Add('  , null as nom_pais_pr ');
      Q.SQL.Add('  , tf.dta_cadastramento ');
      Q.SQL.Add('  , tf.dta_efetivacao_cadastro ');
      Q.SQL.Add('  , tf.ind_efetivado_uma_vez ');
      Q.SQL.Add('  , tf.ind_situacao_imagem ');
      Q.SQL.Add('  , null as cod_localizacao_sisbov ');
      Q.SQL.Add('  , titp.cod_regime_posse_uso ');
      Q.SQL.Add('  , titp.des_regime_posse_uso ');
      Q.SQL.Add('  , tf.cod_ulav_produtor ');
      Q.SQL.Add('  , tf.cod_ulav_fazenda ');
      Q.SQL.Add('  , tf.qtd_distancia_municipio ');
      Q.SQL.Add('  , tf.des_acesso_fazenda ');
      Q.SQL.Add('from ');
      Q.SQL.Add('  tab_fazenda tf ');
      Q.SQL.Add('  , tab_estado te ');
      Q.SQL.Add('  , tab_regime_posse_uso titp ');
      Q.SQL.Add('where ');
      Q.SQL.Add('  tf.cod_estado *= te.cod_estado ');
      Q.SQL.Add('  and tf.cod_regime_posse_uso *= titp.cod_regime_posse_uso ');
      Q.SQL.Add('  and tf.cod_propriedade_rural is null ');
      Q.SQL.Add('  and tf.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('  and tf.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('  and tf.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger         := CodFazenda;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'Buscar', []);
        Result := -310;
        Exit;
      End;

      // Obtem informações do registro
      IntFazenda.CodPessoaProdutor         := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      IntFazenda.CodFazenda                := Q.FieldByName('cod_fazenda').AsInteger;
      IntFazenda.SglFazenda                := Q.FieldByName('sgl_fazenda').AsString;
      IntFazenda.NomFazenda                := Q.FieldByName('nom_fazenda').AsString;
      IntFazenda.CodEstado                 := Q.FieldByName('cod_estado').AsInteger;
      IntFazenda.SglEstado                 := Q.FieldByName('sgl_estado').AsString;
      IntFazenda.NumPropriedadeRural       := Q.FieldByName('num_propriedade_rural').AsString;
      IntFazenda.TxtObservacao             := Q.FieldByName('txt_observacao').AsString;
      IntFazenda.CodPropriedadeRural       := Q.FieldByName('cod_propriedade_rural').AsInteger;
      IntFazenda.NomPropriedadeRural       := Q.FieldByName('nom_propriedade_rural').AsString;
      IntFazenda.NumImovelReceitaFederalPR := Q.FieldByName('num_imovel_receita_federal').AsString;
      IntFazenda.CodIdPropriedadeSisbov    := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
      IntFazenda.NomMunicipioPR            := Q.FieldByName('nom_municipio_pr').AsString;
      IntFazenda.SglEstadoPR               := Q.FieldByName('sgl_estado_pr').AsString;
      IntFazenda.NomPaisPR                 := Q.FieldByName('nom_pais_pr').AsString;
      IntFazenda.DtaCadastramento          := Q.FieldByName('dta_cadastramento').AsDateTime;
      IntFazenda.DtaEfetivacaoCadastro     := Q.FieldByName('dta_efetivacao_cadastro').AsDateTime;
      IntFazenda.IndEfetivadoUmaVez        := Q.FieldByName('ind_efetivado_uma_vez').AsString;
      IntFazenda.IndSituacaoImagem         := Q.FieldByName('ind_situacao_imagem').AsString;
      IntFazenda.CodLocalizacaoSisbov      := Q.FieldByName('cod_localizacao_sisbov').AsInteger;
      IntFazenda.CodRegimePosseUso         := Q.FieldByName('cod_regime_posse_uso').AsInteger;
      IntFazenda.DesRegimePosseUso         := Q.FieldByName('des_regime_posse_uso').AsString;
      IntFazenda.CodUlavPro                := Q.FieldByName('cod_ulav_produtor').AsString;
      IntFazenda.CodUlavFaz                := Q.FieldByName('cod_ulav_fazenda').AsString;
      IntFazenda.QtdDistMunicipio          := Q.FieldByName('qtd_distancia_municipio').AsInteger;
      IntFazenda.DesAcessoFaz              := Q.FieldByName('des_acesso_fazenda').AsString;
      IntFazenda.CodIdPropriedadeSisbov    := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(337, Self.ClassName, 'Buscar', [E.Message]);
        Result := -337;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.DefinirPropriedadeRural(CodFazenda,
      CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
  CodPropriedadeRuralDesvinculada, CodRegistroLog: Integer;
  CodIdPropriedadeSisbov : Integer;
  Conectado, GravaDefinicaoPropriedade : boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoDProdutor: RetornoDesvincularProdutorPropriedade;
  CnpjProdutor, CpfProdutor : String;
begin
  Result := -1;
  GravaDefinicaoPropriedade := True;
  CodPropriedadeRuralDesvinculada := 0;
  CodRegistroLog := 0;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('DefinirPropriedadeRural');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(184) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirPropriedadeRural', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'DefinirPropriedadeRural', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    Try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Definir propriedade rural');

      if Conectado then begin
        // Consiste propriedade rural a ser definida no Herdom e no sisbov
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_propriedade_rural ');
        Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(327, Self.ClassName, 'DefinirPropriedadeRural', []);
          Result := -327;
          Exit;
        End;

        // Consiste se o produtor já não possui fazendas associadas
        // a propriedade rural informada
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_fazenda ' +
                  ' where cod_pessoa_produtor   = :cod_pessoa_produtor ' +
                  '   and cod_propriedade_rural = :cod_propriedade_rural ' +
                  '   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(762, Self.ClassName, 'DefinirPropriedadeRural', []);
          Result := -762;
          Exit;
        End;

        // Verifica existência do registro
        Q.Close;
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select cod_registro_log ' +
                  '  ,    ind_efetivado_uma_vez ' +
                  '  ,    cod_propriedade_rural ' +
                  '  ,    dta_efetivacao_cadastro ' +
                  '  from tab_fazenda ' +
                  ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                  '   and cod_fazenda = :cod_fazenda ' +
                  '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(310, Self.ClassName, 'DefinirPropriedadeRural', []);
          Result := -310;
          Exit;
        End;
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
        If not Q.FieldByName('dta_efetivacao_cadastro').IsNull Then Begin
          Mensagens.Adicionar(512, Self.ClassName, 'DefinirPropriedadeRural', []);
          Result := -512;
          Exit;
        End;

{
        If Q.FieldByName('ind_efetivado_uma_vez').AsString = 'S' Then Begin
          Mensagens.Adicionar(761, Self.ClassName, 'DefinirPropriedadeRural', []);
          Result := -761;
          Exit;
        End;
}
        CodPropriedadeRuralDesvinculada := Q.FieldByName('cod_propriedade_rural').AsInteger;
        Q.Close;

        // Consiste propriedade rural a ser desvinculada do sisbov
        If CodPropriedadeRuralDesvinculada > 0 Then Begin
          Q.SQL.Clear;
  {$IFDEF MSSQL}
          Q.SQL.Add('select cod_id_propriedade_sisbov ');
          Q.SQL.Add('  from tab_propriedade_rural ');
          Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
          Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
          Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRuralDesvinculada;
          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(327, Self.ClassName, 'DefinirPropriedadeRural', []);
            Result := -327;
            Exit;
          End;

          CodIdPropriedadeSisbov := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
          Q.Close;

          if CodIdPropriedadeSisbov > 0 then begin
            // Verifica existência do produtor
            Q.Close;
            Q.SQL.Clear;
      {$IFDEF MSSQL}
            Q.SQL.Add('select num_cnpj_cpf ' +
                      '  from tab_pessoa ' +
                      ' where cod_pessoa = :cod_pessoa ');
      {$ENDIF}
            Q.ParamByName('cod_pessoa').AsInteger := Conexao.CodProdutorTrabalho;
            Q.Open;

            If Q.IsEmpty Then Begin
              Mensagens.Adicionar(170, Self.ClassName, 'DefinirPropriedadeRural', []);
              Result := -170;
              Exit;
            end else begin
              if Length(Q.FieldByName('num_cnpj_cpf').AsString) = 11 then begin
                CpfProdutor  := Q.FieldByName('num_cnpj_cpf').AsString;
                CnpjProdutor := '';
              end else begin
                CnpjProdutor := Q.FieldByName('num_cnpj_cpf').AsString;
                CpfProdutor  := '';
              end;
            End;

            try
              RetornoDProdutor    := SoapSisbov.DesvincularProdutorPropriedade(
                                     Descriptografar(ValorParametro(118))
                                   , Descriptografar(ValorParametro(119))
                                   , CpfProdutor
                                   , CnpjProdutor
                                   , CodIdPropriedadeSisbov );

              If RetornoDProdutor <> nil then begin
                If RetornoDProdutor.Status = 0 then begin
                  Mensagens.Adicionar(2381, Self.ClassName, 'DefinirPropriedadeRural', [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoDProdutor)]);
                  Result := -2381;
                  Exit;
                end;
              end else begin
                Mensagens.Adicionar(2381, Self.ClassName, 'DefinirPropriedadeRural', [' Erro no retorno do SISBOV ']);
                Result := -2381;
                Exit;
              end;
            except
              on E: Exception do
              begin
                Mensagens.Adicionar(2381, Self.ClassName, 'DefinirPropriedadeRural', [E.Message]);
                Result := -2381;
                Exit;
              end;
            end;
          end;
        End;
      end else begin
        GravaDefinicaoPropriedade := False;
      End;

      If GravaDefinicaoPropriedade then begin
        // Abre transação
        BeginTran;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 184);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;

        // Exclui registro da tab_localizacao_sisbov
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('delete tab_localizacao_sisbov ');
        Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
        Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
  {$ENDIF}
        Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRuralDesvinculada;
        Q.ParamByName('cod_pessoa_produtor').AsInteger    := Conexao.CodProdutorTrabalho;
        Q.ExecSQL;

        // Tenta Alterar Registro
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_fazenda ');
        Q.SQL.Add('   set ');
        Q.SQL.Add('   cod_propriedade_rural = :cod_propriedade_rural');
        Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
  {$ENDIF}
        If CodPropriedadeRural > 0 Then Begin
          Q.ParamByName('cod_propriedade_rural').AsInteger     := CodPropriedadeRural;
        End Else Begin
          Q.ParamByName('cod_propriedade_rural').DataType := ftInteger;
          Q.ParamByName('cod_propriedade_rural').Clear
        End;

        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 184);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;

        // Cofirma transação
        Commit;

        // Retorna status "ok" do método
        Result := 0;
      end;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(528, Self.ClassName, 'DefinirPropriedadeRural', [E.Message]);
        Result := -528;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    SoapSisbov.Free;
  End;
end;

function TIntFazendas.EfetivarCadastro(CodFazenda: Integer; IndProdutorDefinido: Integer; NumCNPJCpfProdutor: String): Integer;
var
  Q : THerdomQuery;
  IndEfetivadoUmaVez: String;
  CodPessoaProdutor, CodPropriedadeRural, {CodLocalizacaoSisbov,} CodRegistroLog: Integer;
  LocalizacaoSISBOV : TLocalizacaoSISBOV;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(132) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EfetivarCadastro', []);
    Result := -188;
    Exit;
  End;

  // Verifica se a origem (IndProdutorDefinido) vem de Importacoes referente a produtor,
  //se positivo verfica se produtor de trabalho foi definido
  if IndProdutorDefinido = 1 then begin
     If Conexao.CodProdutorTrabalho = -1 Then Begin
        Mensagens.Adicionar(307, Self.ClassName, 'EfetivarCadastro', []);
        Result := -307;
        Exit;
     End;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      if IndProdutorDefinido = 0 then begin
         Q.Close;
         Q.SQL.Clear;
         Q.SQL.Add('select cod_pessoa from tab_pessoa ');
         Q.SQL.Add(' where num_cnpj_cpf = :num_cnpj_cpf_produtor ');
         Q.ParamByName('num_cnpj_cpf_produtor').AsString := NumCNPJCpfProdutor;
         Q.Open;
         CodPessoaProdutor := Q.FieldByName('cod_pessoa').AsInteger;
      end else begin
         CodPessoaProdutor := Conexao.CodProdutorTrabalho;
      end;

      // Verifica se o cadastro do produtor já foi efetivado
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_efetivacao_cadastro from tab_produtor ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, 'EfetivarCadastro', []);
        Result := -170;
        Exit;
      End;
      If Q.FieldByName('dta_efetivacao_cadastro').IsNull Then Begin
        Mensagens.Adicionar(760, Self.ClassName, 'EfetivarCadastro', []);
        Result := -760;
        Exit;
      End;

      // Verifica existência do registro
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tf.cod_registro_log ');
      Q.SQL.Add('     , tf.dta_efetivacao_cadastro ');
      Q.SQL.Add('     , tf.cod_propriedade_rural ');
      Q.SQL.Add('     , tf.ind_efetivado_uma_vez ');
      Q.SQL.Add('     , tf.cod_regime_posse_uso ');
      Q.SQL.Add('     , tf.cod_estado as cod_estado_fazenda ');
      Q.SQL.Add('     , te.sgl_estado ');
      Q.SQL.Add('     , tpr.cod_estado as cod_estado_propriedade ');
      Q.SQL.Add('     , tf.num_propriedade_rural ');
      Q.SQL.Add('     , tf.des_acesso_fazenda ');
      Q.SQL.Add('     , tf.qtd_distancia_municipio ');
      Q.SQL.Add('from tab_fazenda tf ');
      Q.SQL.Add('   , tab_propriedade_rural tpr ');
      Q.SQL.Add('   , tab_estado te ');
      Q.SQL.Add(' where tf.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tf.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and tf.dta_fim_validade is null ');
      Q.SQL.Add('   and tf.cod_propriedade_rural = tpr.cod_propriedade_rural ');
      Q.SQL.Add('   and tf.cod_estado *= te.cod_estado ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'EfetivarCadastro', []);
        Result := -310;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;

      If Not Q.FieldByName('dta_efetivacao_cadastro').IsNull then Begin
        Mensagens.Adicionar(408, Self.ClassName, 'EfetivarCadastro', []);
        Result := -408;
        Exit;
      End;

      // Verifica se a distancia da fazenda do municipio foi informado
      If Q.FieldByName('qtd_distancia_municipio').IsNull then Begin
        Mensagens.Adicionar(2310, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2310;
        Exit;
      End;

      // Verifica se a descrição de acesso a fazenda foi informado
      If Q.FieldByName('des_acesso_fazenda').IsNull then Begin
        Mensagens.Adicionar(2309, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2309;
        Exit;
      End;

      If (Q.FieldByName('cod_estado_fazenda').AsInteger <> Q.FieldByName('cod_estado_propriedade').AsInteger) then Begin
        Mensagens.Adicionar(2299, Self.ClassName, 'EfetivarCadastro', []);
        Result := -2299;
        Exit;
      End;

//      if not ChkInscEstadual(Q.FieldByName('num_propriedade_rural').AsString, Q.FieldByName('sgl_estado').AsString) then begin
//        Mensagens.Adicionar(2300, Self.ClassName, 'EfetivarCadastro', []);
//        Result := -2300;
//        Exit;
//      End;

      // Verifica se a propriedade rural foi informada
      If Q.FieldByName('cod_propriedade_rural').IsNull then Begin
        Mensagens.Adicionar(515, Self.ClassName, 'EfetivarCadastro', []);
        Result := -515;
        Exit;
      End;

      // Verifica se o indicador de tipo de proprietário foi definido
      If Q.FieldByName('cod_regime_posse_uso').IsNull then Begin
        Mensagens.Adicionar(1693, Self.ClassName, 'EfetivarCadastro', []);
        Result := -1693;
        Exit;
      End;

      // Verifica se a propriedade rural informada é válida
      CodPropriedadeRural := Q.FieldByName('cod_propriedade_rural').AsInteger;

      // Recupera o flag que indica se a fazenda teve seu cadastro efetivado
      // pelo menos uma vez
      IndEfetivadoUmaVez := Q.FieldByName('ind_efetivado_uma_vez').AsString;

      Q.Close;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select dta_efetivacao_cadastro ');
      Q.SQL.Add('  from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(517, Self.ClassName, 'EfetivarCadastro', []);
        Result := -517;
        Exit;
      End;
      If Q.FieldByName('dta_efetivacao_cadastro').IsNull Then Begin
        Mensagens.Adicionar(516, Self.ClassName, 'EfetivarCadastro', []);
        Result := -516;
        Exit;
      end;

      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 132);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Verifica a existência do relacionamento entre o produtor da fazenda e a propriedade associada
{      Q.Close;
      Q.SQL.Text :=
        'select '+
        '  cod_localizacao_sisbov '+
        'from '+
        '  tab_localizacao_sisbov '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_propriedade_rural = :cod_propriedade_rural ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        // Obtem um novo código de localização sisbov
        Q.Close;
        Q.SQL.Text :=
          'update tab_sequencia_codigo '+
          'set '+
          '  cod_localizacao_sisbov = cod_localizacao_sisbov + 1 ';
        Q.ExecSQL;

        // Recupera o código de localização sisbov obtido
        Q.Close;
        Q.SQL.Text :=
          'select '+
          '  cod_localizacao_sisbov '+
          'from '+
          '  tab_sequencia_codigo ';
        Q.Open;
        CodLocalizacaoSisbov := Q.FieldByName('cod_localizacao_sisbov').AsInteger;

        // Estabelece um novo relacionamento entre o produtor da fazenda e propriedade associada
        Q.Close;
        Q.SQL.Text :=
          'insert into tab_localizacao_sisbov '+
          ' (cod_propriedade_rural '+
          '  , cod_pessoa_produtor '+
          '  , cod_localizacao_sisbov '+
          '  , cod_arquivo_sisbov) '+
          'values '+
          ' (:cod_propriedade_rural '+
          '  , :cod_pessoa_produtor '+
          '  , :cod_localizacao_sisbov '+
          '  , null) ';
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
        Q.ExecSQL;
      end; }
      LocalizacaoSISBOV := TLocalizacaoSISBOV.Create;
      try
        result:= LocalizacaoSisBov.Inicializar(Conexao,Mensagens);
        if Result < 0  then begin
           RollBack;
           Exit;
        end;
        Result:= LocalizacaoSISBOV.RelacionaProdutorPropriedade(CodPessoaProdutor,CodPropriedadeRural);
        If Result < 0 Then Begin
          Rollback;
          Exit;
        End;
      finally
        LocalizacaoSisBov.Free;
      end;
      // Tenta Alterar Registro
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_fazenda ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   dta_efetivacao_cadastro = getdate()');
      If IndEfetivadoUmaVez <> 'S' Then Begin
        // Marca o registro como já efetivado pelo menos uma vez
        Q.SQL.Add('   , ind_efetivado_uma_vez = ''S''');
      End;
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
{$ENDIF}

      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 132);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      { Atualiza Grandeza }
      // Fazendas - Identificadas no SISBOV
      Result := AtualizaGrandeza(8, CodPessoaProdutor, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      // Fazendas - Não controlados pela certificadora
      Result := AtualizaGrandeza(9, CodPessoaProdutor, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
*)

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(407, Self.ClassName, 'EfetivarCadastro', [E.Message]);
        Result := -407;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.CancelarEfetivacao(CodFazenda: Integer; IndExportarPropriedade: String): Integer;
var
  Q : THerdomQuery;
  CodIdPropriedadeSisbov, CodProprietario, CodPropriedadeRural, CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('CancelarEfetivacao');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(185) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -307;
    Exit;
  End;

  Q  := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tf.cod_registro_log ');
      Q.SQL.Add('     , tf.dta_efetivacao_cadastro ');
      Q.SQL.Add('     , tf.cod_propriedade_rural ');
      Q.SQL.Add('     , tpr.cod_id_propriedade_sisbov ');
      Q.SQL.Add('     , tpr.cod_pessoa_proprietario ');
      Q.SQL.Add('from tab_fazenda tf ');
      Q.SQL.Add('   , tab_propriedade_rural tpr ');
      Q.SQL.Add(' where tf.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tf.cod_fazenda = :cod_fazenda ');
      Q.SQL.Add('   and tf.dta_fim_validade is null ');
      Q.SQL.Add('   and tf.cod_propriedade_rural = tpr.cod_propriedade_rural ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -310;
        Exit;
      End;
      CodPropriedadeRural := Q.FieldByName('cod_propriedade_rural').AsInteger;
      CodProprietario     := Q.FieldByName('cod_pessoa_proprietario').AsInteger;
      CodRegistroLog      := Q.FieldByName('cod_registro_log').AsInteger;

      // Verifica se o cadastro está realmente efetivado
      If Q.FieldByName('dta_efetivacao_cadastro').IsNull then Begin
        Mensagens.Adicionar(518, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -518;
        Exit;
      End;

      CodIdPropriedadeSisbov := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
{
      // Se a propriedade já foi exportada para o Sisbov, não aceita cancelar a efetivação da mesma.
      If Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0 then Begin
        Mensagens.Adicionar(2340, Self.ClassName, 'CancelarEfetivacao', []);
        Result := -2340;
        Exit;
      End;
}
      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 132);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Verifica se existe um relacionamento entre o produtor da fazenda e a propriedade associada
      Q.Close;
      Q.SQL.Text :=
        'select  ' +
        '      tls.cod_arquivo_sisbov ' +
        '    , tpr.ind_transmissao_sisbov ' +
        'from ' +
        '     tab_propriedade_rural tpr ' +
        '   , tab_localizacao_sisbov tls ' +
        'where ' +
        '      tpr.cod_propriedade_rural = :cod_propriedade_rural ' +
        '  and tls.cod_pessoa_produtor = :cod_pessoa_produtor ' +
        '  and tls.cod_propriedade_rural = :cod_propriedade_rural ';

      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      if not Q.IsEmpty then begin
        if uppercase(IndExportarPropriedade) = 'S' then begin
          if CodProprietario = 0 then begin
            Mensagens.Adicionar(2308, Self.ClassName, 'CancelarEfetivacao', []);
            Result := -2308;
            Exit;
          end;

          // retira o código de exportação para que a propriedade possa ser exportada novamente.
          Q.Close;
          Q.SQL.Text :=
            ' update tab_localizacao_sisbov ' +
            ' set    cod_arquivo_sisbov =  null ' +
            ' where  cod_propriedade_rural   = :cod_propriedade_rural ' +
            '   and  cod_pessoa_produtor     = :cod_pessoa_produtor ';

          Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          Q.ExecSQL;

          if CodIdPropriedadeSisbov = 0 then begin
            // Atualiza a data de efetivação da propriedade para identificar que é uma
            // exportação para o sistema novo.
            Q.Close;
            Q.SQL.Text :=
              ' update tab_propriedade_rural ' +
              ' set    dta_efetivacao_cadastro = getdate() ' +
              ' where ' +
              '  cod_propriedade_rural   = :cod_propriedade_rural ';

            Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
            Q.ExecSQL;
          end;

          // Atualiza a data de efetivação do produtor para identificar que é uma
          // exportação para o sistema novo e anula o cod_arquivo_sisbov para que seja
          // exportado novamente.
          Q.Close;
          Q.SQL.Text :=
            ' update tab_produtor ' +
            ' set    dta_efetivacao_cadastro = getdate() ' +
            '    ,  cod_arquivo_sisbov      = null ' +
            ' where ' +
            '  cod_pessoa_produtor   = :cod_pessoa_produtor ';

          Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          Q.ExecSQL;
        end;
      end;

      // Tenta Alterar Registro
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' update tab_fazenda ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   dta_efetivacao_cadastro = null');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_fazenda = :cod_fazenda ');
{$ENDIF}

      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 132);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(529, Self.ClassName, 'CancelarEfetivacao', [E.Message]);
        Result := -529;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.DefinirImagem(CodFazenda: Integer;
  ArquivoOrigem: String): Integer;
const
  Metodo: Integer = 348;
  NomeMetodo: String = 'DefinirImagem';
var
  Q: THerdomQuery;
  bValido: Boolean;
  fAux: file of Byte;
  sOrigem, sDestino, sAux: String;
  fMaxSize, fSize, CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Recupera pasta temporária de imagens
  sOrigem := ValorParametro(21);
  if (Length(sOrigem)=0) or (sOrigem[Length(sOrigem)]<>'\') then begin
    sOrigem := sOrigem + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(sOrigem) then begin
    Mensagens.Adicionar(1122, Self.ClassName, NomeMetodo, []);
    Result := -1122;
    Exit;
  end;

  // Consiste existência do arquivo informado
  sOrigem := sOrigem + ArquivoOrigem;
  if not FileExists(sOrigem) then begin
    Mensagens.Adicionar(1123, Self.ClassName, NomeMetodo, []);
    Result := -1123;
    Exit;
  end;

  // Consiste formato do arquivo
  bValido := (LowerCase(Copy(sOrigem, Length(sOrigem)-3, 4)) = '.jpg');
  if not bValido then bValido := (LowerCase(Copy(sOrigem, Length(sOrigem)-4, 5)) = '.jpeg');
  if not bValido then bValido := (LowerCase(Copy(sOrigem, Length(sOrigem)-3, 4)) = '.gif');
  if not bValido then begin
    // Gera Mensagem erro informando o problema ao usuário
    Mensagens.Adicionar(1139, Self.ClassName, NomeMetodo, []);
    Result := -1139;
    Exit;
  end;

  // Recupera pasta adequada de imagens
  sDestino := Conexao.CaminhoArquivosCertificadora + ValorParametro(22);
  if (Length(sDestino)=0) or (sDestino[Length(sDestino)]<>'\') then begin
    sDestino := sDestino + '\';
  end;

  // Consiste existência da pasta, caso não exista tenta criá-la
  if not DirectoryExists(sDestino) then begin
    if not ForceDirectories(sDestino) then begin
      // Remove o arquivo temporário de imagem da pasta temporária
      DeleteFile(sOrigem);
      // Gera Mensagem erro informando o problema ao usuário
      Mensagens.Adicionar(1124, Self.ClassName, NomeMetodo, []);
      Result := -1124;
      Exit;
    end;
  end;

  // Obtem o tamanho real do arquivo
  AssignFile(fAux, sOrigem);
  Reset(fAux);
  try
    fSize := FileSize(fAux);
  finally
    CloseFile(fAux);
  end;

  // Obtem tamanho máximo de arquivo permitido para arquivo
  fMaxSize := StrToInt(ValorParametro(20));

  // Consiste o tamanho do arquivo de imagem
  if fSize = 0 then begin
    // Remove o arquivo temporário de imagem da pasta temporária
    DeleteFile(sOrigem);
    // Gera Mensagem erro informando o problema ao usuário
    Mensagens.Adicionar(1128, Self.ClassName, NomeMetodo, []);
    Result := -1128;
    Exit;
  end else if fSize > fMaxSize then begin
    // Remove o arquivo temporário de imagem da pasta temporária
    DeleteFile(sOrigem);
    // Gera Mensagem erro informando o problema ao usuário
    Mensagens.Adicionar(1127, Self.ClassName, NomeMetodo, []);
    Result := -1127;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Obtendo o nome do arquivo de imagem da fazenda do produtor
      Q.Close;
      Q.SQL.Text :=
        'select '+
{$IFDEF MSSQL}
        '  right(''00000'' + CAST(tf.cod_pessoa_produtor as VARCHAR(5)), 5) + '+
        '  right(''00000'' + CAST(tf.cod_fazenda as VARCHAR(5)), 5) as arquivo '+
{$ENDIF}
        '  , cod_registro_log '+
        'from '+
        '  tab_fazenda tf '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      if Q.IsEmpty then begin
        // Remove o arquivo temporário de imagem da pasta temporária
        DeleteFile(sOrigem);
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      end;
      sDestino := sDestino + Q.FieldByName('arquivo').AsString;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Verifica se já existe um arquivo de imagem do tipo JPG
      sAux := sDestino+'.jpg';
      if FileExists(sAux) and not(DeleteFile(sAux)) then begin
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1206, Self.ClassName, NomeMetodo, []);
        Result := -1206;
        Exit;
      end;
      // Verifica se já existe um arquivo de imagem do tipo JPEG
      sAux := sDestino+'.jpeg';
      if FileExists(sAux) and not(DeleteFile(sAux)) then begin
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1206, Self.ClassName, NomeMetodo, []);
        Result := -1206;
        Exit;
      end;
      // Verifica se já existe um arquivo de imagem do tipo GIF
      sAux := sDestino+'.gif';
      if FileExists(sAux) and not(DeleteFile(sAux)) then begin
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1206, Self.ClassName, NomeMetodo, []);
        Result := -1206;
        Exit;
      end;

      // Atualiza extensão que identifica o formato do arquivo
      sDestino := sDestino + ExtractFileExt(sOrigem);

      // Copiando arquivo para o destino já com o nome correto
      if not CopiaArquivo(sOrigem, sDestino) then begin
        // Remove o arquivo temporário de imagem da pasta temporária
        DeleteFile(sOrigem);
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1125, Self.ClassName, NomeMetodo, []);
        Result := -1125;
        Exit;
      end;

      // Consiste se o arquivo foi copiado com sucesso
      if not FileExists(sDestino) then begin
        // Remove o arquivo temporário de imagem da pasta temporária
        DeleteFile(sOrigem);
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1125, Self.ClassName, NomeMetodo, []);
        Result := -1125;
        Exit;
      end;

      // Remove o arquivo temporário de imagem da pasta temporária
      DeleteFile(sOrigem);

      // Abre Transação do servidor de banco
      BeginTran;

      // Atualiza o flag referente a imagem da tabela como pendente a liberação
      Q.SQL.Text :=
        'update tab_fazenda '+
        '  set '+
        '    ind_situacao_imagem = ''P'' '+ // P - Pendente de liberação
        '  where '+
        '    cod_pessoa_produtor = :cod_pessoa_produtor '+
        '    and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Encerra transação confirmando operação
      Commit;

      // Identificao operação bem sucedida
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1126, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1126;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.LiberarImagem(CodFazenda: Integer): Integer;
const
  Metodo: Integer = 350;
  NomeMetodo: String = 'LiberarImagem';
var
  Q: THerdomQuery;
  sArquivo: String;
  CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Recupera pasta adequada de imagens
  sArquivo := Conexao.CaminhoArquivosCertificadora + ValorParametro(22);
  if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
    sArquivo := sArquivo + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(sArquivo) then begin
    Mensagens.Adicionar(1129, Self.ClassName, NomeMetodo, []);
    Result := -1129;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Obtendo o nome do arquivo de imagem da fazenda do produtor
      Q.Close;
      Q.SQL.Text :=
        'select '+
{$IFDEF MSSQL}
        '  right(''00000'' + CAST(tf.cod_pessoa_produtor as VARCHAR(5)), 5) + '+
        '  right(''00000'' + CAST(tf.cod_fazenda as VARCHAR(5)), 5) as arquivo '+
{$ENDIF}
        '  , cod_registro_log '+
        '  , ind_situacao_imagem '+
        'from '+
        '  tab_fazenda tf '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      end;
      if Q.FieldByName('ind_situacao_imagem').AsString <> 'P' then begin
        Mensagens.Adicionar(1131, Self.ClassName, NomeMetodo, []);
        Result := -1131;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('arquivo').AsString;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Consiste se o arquivo de imagem existe no local adequado
      if FileExists(sArquivo+'.jpg') then begin
        sArquivo := sArquivo + '.jpg';
      end else if FileExists(sArquivo+'.jpeg') then begin
        sArquivo := sArquivo + '.jpeg';
      end else if FileExists(sArquivo+'.gif') then begin
        sArquivo := sArquivo + '.gif';
      end;
      if not FileExists(sArquivo) then begin
        // Gera Mensagem erro informando o problema ao usuário
        Mensagens.Adicionar(1130, Self.ClassName, NomeMetodo, []);
        Result := -1130;
        Exit;
      end;

      // Abre Transação do servidor de banco
      BeginTran;

      // Atualiza o flag referente a imagem da tabela como pendente a liberação
      Q.SQL.Text :=
        'update tab_fazenda '+
        '  set '+
        '    ind_situacao_imagem = ''L'' '+ // L - Liberada
        '  where '+
        '    cod_pessoa_produtor = :cod_pessoa_produtor '+
        '    and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Encerra transação confirmando operação
      Commit;

      // Identificao operação bem sucedida
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1133, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1133;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.RemoverImagem(CodFazenda: Integer): Integer;
const
  Metodo: Integer = 349;
  NomeMetodo: String = 'RemoverImagem';
var
  Q: THerdomQuery;
  sArquivo, sAux: String;
  CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  // Recupera pasta adequada de imagens
  sArquivo := Conexao.CaminhoArquivosCertificadora + ValorParametro(22);
  if (Length(sArquivo)=0) or (sArquivo[Length(sArquivo)]<>'\') then begin
    sArquivo := sArquivo + '\';
  end;

  // Consiste existência da pasta
  if not DirectoryExists(sArquivo) then begin
    Mensagens.Adicionar(1129, Self.ClassName, NomeMetodo, []);
    Result := -1129;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Obtendo o nome do arquivo de imagem da fazenda do produtor
      Q.Close;
      Q.SQL.Text :=
        'select '+
{$IFDEF MSSQL}
        '  right(''00000'' + CAST(tf.cod_pessoa_produtor as VARCHAR(5)), 5) + '+
        '  right(''00000'' + CAST(tf.cod_fazenda as VARCHAR(5)), 5) as arquivo '+
{$ENDIF}
        '  , cod_registro_log '+
        '  , ind_situacao_imagem '+
        'from '+
        '  tab_fazenda tf '+
        'where '+
        '  cod_pessoa_produtor = :cod_pessoa_produtor '+
        '  and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
        Result := -310;
        Exit;
      end;
      if Q.FieldByName('ind_situacao_imagem').AsString = 'N' then begin
        Mensagens.Adicionar(1134, Self.ClassName, NomeMetodo, []);
        Result := -1134;
        Exit;
      end;
      sArquivo := sArquivo + Q.FieldByName('arquivo').AsString;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre Transação do servidor de banco
      BeginTran;

      // Atualiza o flag referente a imagem da tabela como pendente a liberação
      Q.SQL.Text :=
        'update tab_fazenda '+
        '  set '+
        '    ind_situacao_imagem = ''N'' '+ // N - Imagem não definida
        '  where '+
        '    cod_pessoa_produtor = :cod_pessoa_produtor '+
        '    and cod_fazenda = :cod_fazenda ';
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Verifica se já existe um arquivo de imagem do tipo JPG
      sAux := sArquivo+'.jpg';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;
      // Verifica se já existe um arquivo de imagem do tipo JPEG
      sAux := sArquivo+'.jpeg';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;
      // Verifica se já existe um arquivo de imagem do tipo GIF
      sAux := sArquivo+'.gif';
      if FileExists(sAux) then begin
        DeleteFile(sAux)
      end;

      // Encerra transação confirmando operação
      Commit;

      // Identificao operação bem sucedida
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1135, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1135;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntFazendas.PesquisarRelatorio(EQuery: THerdomQuery;
                                         SglProdutor,
                                         NomPessoaProdutor,
                                         SglFazenda,
                                         NomFazenda,
                                         CodSituacaoSISBOVFazenda,
                                         IndSituacaoImagemFazenda,
                                         NomPropriedadeRural,
                                         NumImovelReceitaFederal: String;
                                         CodLocalizacaoSisbov,
                                         CodEstado: Integer;
                                         NomMunicipio,
                                         CodMicroRegiao: String;
                                         var QtdPropriedadeRural,
                                         QtdFazenda,
                                         QtdAnimal: Integer;
                                         DtaInicioCadastramento,
                                         DtaFimCadastramento: TDateTime;
                                         CodTarefa: Integer;
                                         DtaInicioVistoria,
                                         DtaFimVistoria: TDateTime): Integer;
const
  NomMetodo: String = 'PesquisarRelatorio';
  CodRelatorio: Integer = 6;

  // Indicadores utilizados como campos que determinam a inclusão ou
  // exclusão de alguma string SQL
  ccDesprezar = -1;
  ccAdicionar = 0;

  // Campos que compõe o relatório
  ccNomPessoaProdutor:            Integer = 1;
  ccNomReduzidoPessoaProdutor:    Integer = 2;
  ccSglProdutor:                  Integer = 3;
  ccSglFazenda:                   Integer = 4;
  ccNomFazenda:                   Integer = 5;
  ccCodSituacaoSISBOVFazenda:     Integer = 6;
  ccDesSituacaoSISBOVFazenda:     Integer = 7;
  ccIndSituacaoImagemFazenda:     Integer = 8;
  ccNomPropriedadeRural:          Integer = 9;
  ccNumImovelReceitaFederal:      Integer = 10;
  ccSglLocal:                     Integer = 11;
  ccDesLocal:                     Integer = 12;
  ccSglTipoFonteAgua:             Integer = 13;
  ccDesTipoFonteAgua:             Integer = 14;
  ccNumCNPJCPFFormatadoProdutor:  Integer = 15;
  ccDesRegimePosseUso:            Integer = 16;
  ccNomPessoaContato:             Integer = 17;
  ccNumTelefone:                  Integer = 18;
  ccNumFax:                       Integer = 19;
  ccNomLogradouro:                Integer = 20;
  ccNomBairro:                    Integer = 21;
  ccNumCEP:                       Integer = 22;
  ccNomDistrito:                  Integer = 23;
  ccNomMunicipio:                 Integer = 24;
  ccSglEstado:                    Integer = 25;
  ccNomEstado:                    Integer = 26;
  ccQtdAnimais:                   Integer = 27;
  ccNomPessoaTecnico:             Integer = 28;
  ccCodLocalizacaoSisbov:         Integer = 29;
  ccLogradouroProdutor:           Integer = 30;
  ccBairroProdutor:               Integer = 31;
  ccCEPProdutor:                  Integer = 32;
  ccMunicipioProdutor:            Integer = 33;
  ccSglEstadoProdutor:            Integer = 34;
  ccEstadoProdutor:               Integer = 35;
  ccEnderecoPropCorrespondencia:  Integer = 36;
  ccBairroPropCorrespondencia:    Integer = 37;
  ccCEPPropCorrespondencia:       Integer = 38;
  ccMunicipioPropCorrespondencia: Integer = 39;
  ccSglEstadoPropCorrespondencia: Integer = 40;
  ccEstadoPropCorrespondencia:    Integer = 41;
  ccUFInscEstadualFazenda:        Integer = 42;
  ccNumInscEstadualFazenda:       Integer = 43;
  ccDtaCadastramento:             Integer = 44;
  ccCodIdPropriedadeSisbov:       Integer = 45;
  ccDtaProximaVistoriaEras:       Integer = 46;
  ccDtaUltimaVistoriaEras:        Integer = 47;
  ccCpfPessoaTecnico:             Integer = 48;
var
  Retorno: Integer;
  Param : TValoresParametro;
  IntRelatorios: TIntRelatorios;
  bPersonalizavel: Boolean;
  Rel : TRelatorioPadrao;
  strSQL: String;
  iAux: Integer;

  function SQL(Linha: String; VerificaCampo: Integer): Boolean; overload;
  begin
    Result := False;
    if (VerificaCampo <> -1) then begin
      Result := (VerificaCampo = 0) or not(bPersonalizavel)
        or (IntRelatorios.CampoAssociado(VerificaCampo) = 1);
      if Result then begin
        EQuery.SQL.Text := EQuery.SQL.Text + Linha;
      end;
    end;
  end;

  function CamposAssociados(VerificaCampos: Array Of Integer): Boolean;
  var
    iAuxPesquisa: Integer;
  begin
    iAuxPesquisa := 0;
    Result := not(bPersonalizavel);
    while (iAuxPesquisa < Length(VerificaCampos)) and (not Result) do begin
      Result :=
        (IntRelatorios.CampoAssociado(VerificaCampos[iAuxPesquisa]) = 1);
      Inc(iAuxPesquisa);
    end;
  end;
begin
  IntRelatorios := TIntRelatorios.Create;

  try
    Result := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := IntRelatorios.Buscar(CodRelatorio);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := IntRelatorios.Pesquisar(CodRelatorio);
    if Result < 0 then
    begin
      Exit;
    end;

    bPersonalizavel :=
      (IntRelatorios.IntRelatorio.IndPersonalizavel = 'S');

    EQuery.SQL.Clear;
{$IFDEF MSSQL}
    // Cria temporária caso não exista
    EQuery.SQL.Add(
      #13#10'if object_id(''tempdb..#tmp_fazenda_relatorio'') is null '+
      #13#10'  create table #tmp_fazenda_relatorio '+
      #13#10'  ( '+
      #13#10'     CodPessoaProdutor int null ' +
      #13#10'    , NomPessoaProdutor varchar (100) null '+
      #13#10'    , NomReduzidoPessoaProdutor varchar (15) null '+
      #13#10'    , NumCNPJCPFFormatadoProdutor varchar (20) null '+
      #13#10'    , SglProdutor char(5) null'+
      #13#10'    , cod_fazenda int null '+
      #13#10'    , SglFazenda char(2) null'+
      #13#10'    , NomFazenda varchar(50) null'+
      #13#10'    , CodSituacaoSISBOVFazenda char(1) null '+
      #13#10'    , DesSituacaoSISBOVFazenda varchar(50) null '+
      #13#10'    , IndSituacaoImagemFazenda char(1) null '+
      #13#10'    , cod_propriedade_rural int null '+
      #13#10'    , NomPropriedadeRural varchar(50) null'+
      #13#10'    , NumImovelReceitaFederal varchar(13) null'+ { Fábio - 14/07/2004 - Alteração do tamanho do campo de 8 para 13 }
      #13#10'    , DesRegimePosseUso varchar(25) null '+
      #13#10'    , NomPessoaContato varchar(50) null '+
      #13#10'    , NumTelefone varchar(15) null '+
      #13#10'    , NumFAX varchar(15) null '+
      #13#10'    , NomLogradouro varchar(100) null '+
      #13#10'    , NomBairro varchar(50) null '+
      #13#10'    , NumCEP varchar(8) null '+
      #13#10'    , NomDistrito varchar(50) null '+
      #13#10'    , NomMunicipio varchar(50) null '+
      #13#10'    , SglEstado char(2) null '+
      #13#10'    , NomEstado varchar(20) null '+
      #13#10'    , SglLocal varchar(2) null '+
      #13#10'    , DesLocal varchar(30) null '+
      #13#10'    , SglTipoFonteAgua varchar(10) null '+
      #13#10'    , DesTipoFonteAgua varchar(50) null '+
      #13#10'    , QtdAnimais int null '+
      #13#10'    , CodPessoaTecnico int null '+
      #13#10'    , NomPessoaTecnico varchar (100) null '+
      #13#10'    , CpfPessoaTecnico varchar (11) null '+
      #13#10'    , CodLocalizacaoSisbov int null '+
      #13#10'    , LogradouroProdutor varchar (100) null '+
      #13#10'    , BairroProdutor varchar (50) null '+
      #13#10'    , CEPProdutor varchar (8) null '+
      #13#10'    , MunicipioProdutor varchar (50) null '+
      #13#10'    , SglEstadoProdutor varchar (4) null '+
      #13#10'    , EstadoProdutor varchar (50) null '+
      #13#10'    , EnderecoPropCorrespondencia varchar (100) null '+
      #13#10'    , BairroPropCorrespondencia varchar (50) null '+
      #13#10'    , CEPPropCorrespondencia varchar (8) null '+
      #13#10'    , MunicipioPropCorrespondencia varchar (50) null '+
      #13#10'    , SglEstadoPropCorrespondencia varchar (2) null '+
      #13#10'    , EstadoPropCorrespondencia varchar (20) null ' +
      #13#10'    , UFInscricaoEstadualFazenda varchar (4) null ' +
      #13#10'    , NumInscricaoEstadualFazenda varchar (25) null ' +
      #13#10'    , DtaCadastramento datetime null ' +
      #13#10'    , CodIdPropriedadeSisbov int null ' +
      #13#10'    , CodTipoInscricaoSisbov int null ' +
      #13#10'    , DtaProximaVistoriaEras datetime null ' +
      #13#10'    , DtaUltimaVistoriaEras datetime null ' +
      #13#10'  ) ');
    EQuery.ExecSQL;
    // Limpa a tabela
    EQuery.SQL.Clear;
    EQuery.SQL.Add(#13#10'truncate table #tmp_fazenda_relatorio ');
    EQuery.ExecSQL;

    EQuery.SQL.Clear;
    SQL('insert into #tmp_fazenda_relatorio ' +
        '       ( CodPessoaProdutor ', ccAdicionar); //só para inicializar a virgula
    SQL('       , NomPessoaProdutor ', ccNomPessoaProdutor);
    SQL('       , NomReduzidoPessoaProdutor ', ccNomReduzidoPessoaProdutor);
    SQL('       , NumCNPJCPFFormatadoProdutor ', ccNumCNPJCPFFormatadoProdutor);
    SQL('       , SglProdutor ', ccSglProdutor);
    SQL('       , cod_fazenda ', ccAdicionar);
    SQL('       , SglFazenda ', ccSglFazenda);
    SQL('       , NomFazenda ', ccNomFazenda);
    SQL('       , CodSituacaoSISBOVFazenda', SE(CamposAssociados([ccCodSituacaoSisBovFazenda, ccDesSituacaoSISBOVFazenda]), ccAdicionar, ccDesprezar));
    SQL('       , DesSituacaoSISBOVFazenda ', ccDesSituacaoSISBOVFazenda);
    SQL('       , IndSituacaoImagemFazenda', ccIndSituacaoImagemFazenda);
    SQL('       , cod_propriedade_rural', ccAdicionar);
    SQL('       , NomPropriedadeRural ', ccNomPropriedadeRural);
    SQL('       , NumImovelReceitaFederal ', ccNumImovelReceitaFederal);
    SQL('       , DesRegimePosseUso', ccDesRegimePosseUso);
    SQL('       , NomPessoaContato ', ccNomPessoaContato);
    SQL('       , NumTelefone', ccNumTelefone);
    SQL('       , NumFax ', ccNumFax);
    SQL('       , NomLogradouro ', ccNomLogradouro);
    SQL('       , NomBairro ', ccNomBairro);
    SQL('       , NumCEP ', ccNumCEP);
    SQL('       , NomDistrito ', ccNomDistrito);
    SQL('       , NomMunicipio ', ccNomMunicipio);
    SQL('       , SglEstado ', ccSglEstado);
    SQL('       , NomEstado ', ccNomEstado);
    SQL('       , SglLocal ', ccSglLocal);
    SQL('       , DesLocal ', ccDesLocal);
    SQL('       , SglTipoFonteAgua ', ccSglTipoFonteAgua);
    SQL('       , DesTipoFonteAgua', ccDesTipoFonteAgua);
    SQL('       , QtdAnimais ', ccAdicionar);
    SQL('       , CodPessoaTecnico ', SE(CamposAssociados([ccNomPessoaTecnico, ccCpfPessoaTecnico]), ccAdicionar, ccDesprezar));
    SQL('       , CodLocalizacaoSisbov ', ccCodLocalizacaoSisbov);
    SQL('       , LogradouroProdutor ', ccLogradouroProdutor);
    SQL('       , BairroProdutor ', ccBairroProdutor);
    SQL('       , CEPProdutor ', ccCEPProdutor);
    SQL('       , MunicipioProdutor ', ccMunicipioProdutor);
    SQL('       , SglEstadoProdutor ', ccSglEstadoProdutor);
    SQL('       , EstadoProdutor ', ccEstadoProdutor);
    SQL('       , EnderecoPropCorrespondencia ', ccEnderecoPropCorrespondencia);
    SQL('       , BairroPropCorrespondencia ', ccBairroPropCorrespondencia);
    SQL('       , CEPPropCorrespondencia ', ccCEPPropCorrespondencia);
    SQL('       , MunicipioPropCorrespondencia ', ccMunicipioPropCorrespondencia);
    SQL('       , SglEstadoPropCorrespondencia ', ccSglEstadoPropCorrespondencia);
    SQL('       , EstadoPropCorrespondencia ', ccEstadoPropCorrespondencia);
    SQL('       , UFInscricaoEstadualFazenda ', ccUFInscEstadualFazenda);
    SQL('       , NumInscricaoEstadualFazenda ', ccNumInscEstadualFazenda);
    SQL('       , DtaCadastramento ', ccDtaCadastramento);
    SQL('       , CodIdPropriedadeSisbov ', ccCodIdPropriedadeSisbov);
    SQL('       , CodTipoInscricaoSisbov ', ccAdicionar);
    SQL('       , DtaProximaVistoriaEras ', ccAdicionar);
    SQL('       , DtaUltimaVistoriaEras ', ccAdicionar);
    SQL('       )', ccAdicionar);

    //------------------------------------------------------------------------------
    // druzo - 18/11/2010 17:01:16
    // Adicionado a clausula distinct no select
    //------------------------------------------------------------------------------
    //original
		//SQL(' select tf.cod_pessoa_produtor as CodPessoaProdutor ', ccAdicionar); //Iniciando a vírgula

    SQL(' select distinct tf.cod_pessoa_produtor as CodPessoaProdutor ', ccAdicionar); //Iniciando a vírgula
    SQL('      , tp.nom_pessoa as NomPessoaProdutor ', ccNomPessoaProdutor);
    SQL('      , tp.nom_reduzido_pessoa as NomReduzidoPessoaProdutor ', ccNomReduzidoPessoaProdutor);
    SQL('      , case tp.cod_natureza_pessoa '+
        '        when ''F'' then convert(varchar(18), '+
        '          substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + '+
        '          substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + '+
        '          substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + '+
        '          substring(tp.num_cnpj_cpf, 10, 2)) '+
        '        when ''J'' then convert(varchar(18), '+
        '          substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + '+
        '          substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + '+
        '          substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + '+
        '          substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + '+
        '          substring(tp.num_cnpj_cpf, 13, 2)) '+
        '        end as NumCNPJCPFFormatadoProdutor ', ccNumCNPJCPFFormatadoProdutor);
    SQL('      , tpd.sgl_produtor as SglProdutor ', ccSglProdutor);
    SQL('      , tf.cod_fazenda ', ccAdicionar);
    SQL('      , tf.sgl_fazenda as SglFazenda ', ccSglFazenda);
    SQL('      , tf.nom_fazenda as NomFazenda ', ccNomFazenda);
    SQL('      , case isnull(tf.dta_efetivacao_cadastro,0) ' +
        '        when 0 then ''N'' ' +
        '        else ''I'' ' +
        '        end as CodSituacaoSISOVFazenda ', SE(CamposAssociados([ccCodSituacaoSisBovFazenda, ccDesSituacaoSISBOVFazenda]), ccAdicionar, ccDesprezar));
    SQL('      , ts.des_situacao_sisbov as DesSituacaoSISBOVFazenda ', ccDesSituacaoSISBOVFazenda);
    SQL('      , tf.ind_situacao_imagem as IndSituacaoImagemFazenda ', ccIndSituacaoImagemFazenda);
    SQL('      , tf.cod_propriedade_rural ', ccAdicionar);
    SQL('      , tpr.nom_propriedade_rural as NomPropriedadeRural ', ccNomPropriedadeRural);
    SQL('      , tpr.num_imovel_receita_federal as NumImovelReceitaFederal ', ccNumImovelReceitaFederal);
    SQL('      , trpu.des_regime_posse_uso as DesRegimePosseUso ', ccDesRegimePosseUso);
    SQL('      , tpr.nom_pessoa_contato as NomPessoaContato ', ccNomPessoaContato);
    SQL('      , tpr.num_telefone as NumTelefone ', ccNumTelefone);
    SQL('      , tpr.num_fax as NumFax ', ccNumFax);
    SQL('      , tpr.nom_logradouro as NomLogradouro ', ccNomLogradouro);
    SQL('      , tpr.nom_bairro as NomBairro ', ccNomBairro);
    SQL('      , tpr.num_cep as NumCEP ', ccNumCEP);
    SQL('      , td.nom_distrito as NomDistrito ', ccNomDistrito);
    SQL('      , tm.nom_municipio as NomMunicipio ', ccNomMunicipio);
    SQL('      , te1.sgl_estado as SglEstado ', ccSglEstado);
    SQL('      , te1.nom_estado as NomEstado ', ccNomEstado);
    SQL('      , tl.sgl_local as SglLocal ', ccSglLocal);
    SQL('      , tl.des_local as DesLocal ', ccDesLocal);
    if (IntRelatorios.CampoAssociado(11) = 1) or (IntRelatorios.CampoAssociado(12) = 1) then
    begin
      SQL('    , dbo.FNT_LISTA_FONTESAGUA(''S'', tf.cod_pessoa_produtor, tf.cod_fazenda, tl.cod_local) as SglTipoFonteAgua ', ccSglTipoFonteAgua);
      SQL('    , dbo.FNT_LISTA_FONTESAGUA(''D'', tf.cod_pessoa_produtor, tf.cod_fazenda, tl.cod_local) as DesTipoFonteAgua ', ccDesTipoFonteAgua);
      SQL('    , dbo.FNT_CONTA_ANIMAIS(tf.cod_pessoa_produtor, tf.cod_fazenda, tl.cod_local) as QtdAnimais ', ccAdicionar);
    end
    else
    begin
      SQL('    , dbo.FNT_LISTA_FONTESAGUA(''S'', tf.cod_pessoa_produtor, tf.cod_fazenda, null) as SglTipoFonteAgua ', ccSglTipoFonteAgua);
      SQL('    , dbo.FNT_LISTA_FONTESAGUA(''D'', tf.cod_pessoa_produtor, tf.cod_fazenda, null) as DesTipoFonteAgua ', ccDesTipoFonteAgua);
      SQL('    , dbo.FNT_CONTA_ANIMAIS(tf.cod_pessoa_produtor, tf.cod_fazenda, null) as QtdAnimais ', ccAdicionar);
    end;
    SQL('      , ttp.cod_pessoa_tecnico ', SE(CamposAssociados([ccNomPessoaTecnico, ccCpfPessoaTecnico]), ccAdicionar, ccDesprezar));
    SQL('      , tls.cod_localizacao_sisbov ', ccCodLocalizacaoSisbov);
    SQL('      , tp.nom_logradouro as LogradouroProdutor ', ccLogradouroProdutor);
    SQL('      , tp.nom_bairro as BairroProdutor ', ccBairroProdutor);
    SQL('      , tp.num_cep as CEPProdutor ', ccCEPProdutor);
    SQL('      , tm1.nom_municipio as MunicipioProdutor ', ccMunicipioProdutor);
    SQL('      , te.sgl_estado as SglEstadoProdutor ', ccSglEstadoProdutor);
    SQL('      , te.nom_estado as EstadoProdutor ', ccEstadoProdutor);
    SQL('      , tpr.nom_logradouro_correspondencia as EnderecoPropCorrespondencia ', ccEnderecoPropCorrespondencia);
    SQL('      , tpr.nom_bairro_correspondencia as BairroPropCorrespondencia ', ccBairroPropCorrespondencia);
    SQL('      , tpr.num_cep_correspondencia as CEPPropCorrespondencia ', ccCEPPropCorrespondencia);
    SQL('      , tm2.nom_municipio as MunicipioPropCorrespondencia ', ccMunicipioPropCorrespondencia);
    SQL('      , te2.sgl_estado as SglEstadoPropCorrespondencia ', ccSglEstadoPropCorrespondencia);
    SQL('      , te2.nom_estado as EstadoPropCorrespondencia ', ccEstadoPropCorrespondencia);
    SQL('      , te3.sgl_estado as UFInscricaoEstadualFazenda ', ccUFInscEstadualFazenda);
    SQL('      , tf.num_propriedade_rural as NumInscricaoEstadualFazenda ', ccNumInscEstadualFazenda);
    SQL('      , tf.dta_cadastramento as DtaCadastramento ', ccDtaCadastramento);
    SQL('      , tpr.cod_id_propriedade_sisbov as CodIdPropriedadeSisbov ', ccCodIdPropriedadeSisbov);
    if (IntRelatorios.CampoAssociado(46) = 1) then begin
      SQL('      , tpr.cod_tipo_propriedade_rural as CodTipoInscricaoSisbov ', ccAdicionar);
    //------------------------------------------------------------------------------
    // druzo - 18/11/2010 15:00:16
    // Alteração para arrumar o problema da proxima data de vistoria para propriedades mistas
    //------------------------------------------------------------------------------
				SQL('      , dbo.fnt_calcula_data_vistoria(tpr.cod_propriedade_rural) AS DtaProximaVistoriaEras ', ccAdicionar);

//      SQL('      , CASE tpr.cod_tipo_propriedade_rural ', ccAdicionar);
//      SQL('          WHEN 1 THEN tve.dta_vistoria_eras + 180 ', ccAdicionar);
//      SQL('          WHEN 2 THEN tve.dta_vistoria_eras + 60 ',  ccAdicionar);
//      SQL('          WHEN 3 THEN tve.dta_vistoria_eras + 180 ', ccAdicionar);
//      SQL('        END AS DtaProximaVistoriaEras ', ccAdicionar);
    end else begin
      SQL('      , null as CodTipoInscricaoSisbov ', ccAdicionar);
      SQL('      , null as DtaProximaVistoriaEras ', ccAdicionar);
    end;
    if (IntRelatorios.CampoAssociado(47) = 1) then begin
      SQL('      , (select max(tve1.dta_vistoria_eras) ', ccAdicionar);
		  SQL('           from tab_vistoria_eras tve1 ', ccAdicionar);
      SQL('           where tve1.cod_propriedade_rural = tpr.cod_propriedade_rural) as DtaUltimaVistoriaEras ', ccAdicionar);
    end else begin
      SQL('      , null as DtaUltimaVistoriaEras ', ccAdicionar);
    end;
    SQL('  from ', ccAdicionar);
    SQL('       tab_pessoa tp ', ccAdicionar);
    SQL('                     left join tab_municipio tm1 on tp.cod_municipio = tm1.cod_municipio ', SE(CamposAssociados([ccMunicipioProdutor]), ccAdicionar, ccDesprezar));
    SQL('                     left join tab_estado te     on tp.cod_estado = te.cod_estado ', SE(CamposAssociados([ccSglEstadoProdutor, ccEstadoProdutor]), ccAdicionar, ccDesprezar));
    SQL('                     inner join tab_produtor tpd on tp.cod_pessoa = tpd.cod_pessoa_produtor ', SE(CamposAssociados([ccSglProdutor]) or (Trim(SglProdutor) <> ''), ccAdicionar, ccDesprezar));
    SQL('     , tab_fazenda tf ', ccAdicionar);
    SQL('                      left join tab_regime_posse_uso trpu on tf.cod_regime_posse_uso = trpu.cod_regime_posse_uso ', SE(CamposAssociados([ccDesRegimePosseUso]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_tecnico_produtor ttp  on tf.cod_pessoa_produtor = ttp.cod_pessoa_produtor and ttp.dta_fim_validade is null ', SE(CamposAssociados([ccNomPessoaTecnico, ccCpfPessoaTecnico]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_local tl              on tf.cod_pessoa_produtor = tl.cod_pessoa_produtor and tf.cod_fazenda = tl.cod_fazenda and tl.dta_fim_validade is null ', SE(CamposAssociados([ccSglLocal, ccDesLocal]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_estado te3            on tf.cod_estado = te3.cod_estado ', SE(CamposAssociados([ccUFInscEstadualFazenda]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_propriedade_rural tpr on tf.cod_propriedade_rural = tpr.cod_propriedade_rural ', SE(CamposAssociados([ccNomPropriedadeRural,  ccNumImovelReceitaFederal, ccNomPessoaContato, ccNumTelefone, ccNumFax, ccNomLogradouro, ccNomBairro, ccNumCEP, ccNomDistrito, ccNomMunicipio, ccSglEstado, ccNomEstado, ccEnderecoPropCorrespondencia, ccBairroPropCorrespondencia, ccCEPPropCorrespondencia, ccMunicipioPropCorrespondencia, ccSglEstadoPropCorrespondencia, ccEstadoPropCorrespondencia, ccDtaCadastramento, ccCodIdPropriedadeSisbov, ccDtaProximaVistoriaEras, ccDtaUltimaVistoriaEras]) or (Trim(NumImovelReceitaFederal) <> '') or (Trim(NomPropriedadeRural) <> '') or (CodEstado > 0) or (Trim(NomMunicipio) <> '') or (DtaInicioVistoria > 0), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_municipio tm          on tpr.cod_municipio = tm.cod_municipio ', SE(CamposAssociados([ccNomMunicipio]) or (Trim(NomMunicipio) <> '') or (Trim(CodMicroRegiao) <> ''), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_municipio tm2         on tpr.cod_municipio_correspondencia = tm2.cod_municipio ', SE(CamposAssociados([ccMunicipioPropCorrespondencia]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_distrito td           on td.cod_distrito = tpr.cod_distrito ', SE(CamposAssociados([ccNomDistrito]), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_estado te1            on tpr.cod_estado = te1.cod_estado ', SE(CamposAssociados([ccSglEstado, ccNomEstado]) or (CodEstado > 0), ccAdicionar, ccDesprezar));
    SQL('                      left join tab_estado te2            on tpr.cod_estado_correspondencia = te2.cod_estado ', SE(CamposAssociados([ccSglEstadoPropCorrespondencia, ccEstadoPropCorrespondencia]), ccAdicionar, ccDesprezar));
    SQL('     , tab_localizacao_sisbov tls ', SE(CamposAssociados([ccCodLocalizacaoSisbov]) or (CodLocalizacaoSisbov > 0), ccAdicionar, ccDesprezar));
    SQL('     , tab_situacao_sisbov ts ', ccDesSituacaoSISBOVFazenda);
    if (IntRelatorios.CampoAssociado(46) = 1) or (DtaInicioVistoria > 0) then begin
      SQL('     , tab_vistoria_eras tve ', ccAdicionar);
    end;
    if Trim(CodMicroRegiao) <> '' then
    begin
      SQL('   , tab_micro_regiao tmr ', ccAdicionar);
    end;
    SQL(' where ', ccAdicionar);

    SQL('       tf.dta_fim_validade is null ', ccAdicionar);
    SQL('   and tf.cod_pessoa_produtor = tp.cod_pessoa ', ccAdicionar);
    SQL('   and tf.sgl_fazenda = :sgl_fazenda ' , SE((Trim(SglFazenda) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tf.nom_fazenda like :nom_fazenda ', SE((Trim(NomFazenda) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tf.dta_efetivacao_cadastro is null ', SE((UpperCase(CodSituacaoSISBOVFazenda)= 'N'), ccAdicionar, ccDesprezar));
    SQL('   and tf.dta_efetivacao_cadastro is not null ', SE((UpperCase(CodSituacaoSISBOVFazenda) = 'I'), ccAdicionar, ccDesprezar));
    SQL('   and tf.ind_situacao_imagem = :ind_situacao_imagem ', SE((Trim(IndSituacaoImagemFazenda) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tf.dta_cadastramento >= :dta_inicio_cadastramento ', SE((DtaInicioCadastramento > 0), ccAdicionar, ccDesprezar));
    SQL('   and tf.dta_cadastramento < :dta_fim_cadastramento ', SE((DtaFimCadastramento > 0), ccAdicionar, ccDesprezar));

    SQL('   and tls.cod_pessoa_produtor = tp.cod_pessoa ', SE(CamposAssociados([ccCodLocalizacaoSisbov]) or (CodLocalizacaoSisbov > 0), ccAdicionar, ccDesprezar));
    SQL('   and tls.cod_propriedade_rural = tf.cod_propriedade_rural ', SE(CamposAssociados([ccCodLocalizacaoSisbov]) or (CodLocalizacaoSisbov > 0), ccAdicionar, ccDesprezar));
    SQL('   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov ', SE((CodLocalizacaoSisbov > 0), ccAdicionar, ccDesprezar));

    SQL('   and tpr.nom_propriedade_rural like :nom_propriedade_rural ', SE((Trim(NomPropriedadeRural)<> ''), ccAdicionar, ccDesprezar));
    SQL('   and tpr.num_imovel_receita_federal = :num_imovel_receita_federal ', SE((Trim(NumImovelReceitaFederal)<> ''), ccAdicionar, ccDesprezar));
    SQL('   and tpr.cod_estado = :cod_estado ', SE((CodEstado > 0), ccAdicionar, ccDesprezar));

    // Tratamento da próxima data de vistoria
    if (IntRelatorios.CampoAssociado(46) = 1) or (DtaInicioVistoria > 0) then begin
      SQL('    and tpr.cod_propriedade_rural = tve.cod_propriedade_rural ', ccAdicionar);

    //------------------------------------------------------------------------------
    // druzo - 18/11/2010 15:00:16
    // Alteração para arrumar o problema da proxima data de vistoria para propriedades mistas
    //------------------------------------------------------------------------------
			SQL('    and dbo.fnt_calcula_data_vistoria(tpr.cod_propriedade_rural) between :dta_inicio_vistoria and :dta_fim_vistoria  ', ccAdicionar);

      //SQL('    and ((tpr.cod_tipo_propriedade_rural = 1 and (tve.0dta_vistoria_eras + 180) between :dta_inicio_vistoria and :dta_fim_vistoria ) ', ccAdicionar);
      //SQL('    or (tpr.cod_tipo_propriedade_rural = 2 and (tve.dta_vistoria_eras + 60) between :dta_inicio_vistoria and :dta_fim_vistoria ) ', ccAdicionar);
      //SQL('    or (tpr.cod_tipo_propriedade_rural = 3 and (tve.dta_vistoria_eras + 180) between :dta_inicio_vistoria and :dta_fim_vistoria )) ', ccAdicionar);
      SQL('    and tve.ind_transmissao_sisbov = ''S'' ', ccAdicionar);
      if (Conexao.CodPapelUsuario = 3) then begin // Técnico
        SQL('  and tve.cod_pessoa_tecnico = ' + IntToStr(Conexao.CodPessoa), ccAdicionar);
      end;
      if (IntRelatorios.CampoAssociado(28) = 1) or (IntRelatorios.CampoAssociado(48) = 1) then begin
        SQL('  and tve.cod_pessoa_tecnico = ttp.cod_pessoa_tecnico ', ccAdicionar);
      end;
    end;

    SQL('   and tm.nom_municipio like :nom_municipio ', SE((Trim(NomMunicipio) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tp.nom_pessoa like :nom_pessoa ', SE((Trim(NomPessoaProdutor) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tp.cod_pessoa = tpd.cod_pessoa_produtor ', SE(CamposAssociados([ccSglProdutor]) or (Trim(SglProdutor) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and tpd.sgl_produtor = :sgl_produtor ', SE((Trim(SglProdutor) <> ''), ccAdicionar, ccDesprezar));
    SQL('   and (case isnull(tf.dta_efetivacao_cadastro, 0) when 0 then ''N'' else ''I'' end) = ts.cod_situacao_sisbov', ccDesSituacaoSISBOVFazenda);

    if (Conexao.CodPapelUsuario = 3) then // Técnico
    begin
      SQL(' and tf.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ', ccAdicionar);
      SQL('                                 where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_tecnico = :cod_pessoa) ', ccAdicionar);
    end;
    if (Conexao.CodPapelUsuario = 4) then // Técnico
    begin
      SQL(' and tf.cod_pessoa_produtor = :cod_pessoa ', ccAdicionar);
    end;
    if (Conexao.CodPapelUsuario = 9) then // Gestor
    begin
      SQL(' and tf.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ', ccAdicionar);
      SQL('                                 where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ', ccAdicionar);
    end;


    if Trim(CodMicroRegiao) <> '' then
    begin
      Param := TValoresParametro.Create(TValorParametro);
      try
        Result := VerificaParametroMultiValor(CodMicroRegiao, Param);
        if Result < 0 then Exit;
        Param.Clear;
      finally
        Param.Free;
      end;
      SQL(' and tmr.cod_micro_regiao = tm.cod_micro_regiao ' +
          ' and tpr.cod_municipio = tm.cod_municipio ' +
          ' and tm.cod_micro_regiao in ( ' + CodMicroRegiao + ' )', ccAdicionar);
    end;

    if (IntRelatorios.CampoAssociado(46) = 1) or (DtaInicioVistoria > 0) then begin
      EQuery.ParamByName('dta_inicio_vistoria').AsDatetime := DtaInicioVistoria;
      EQuery.ParamByName('dta_fim_vistoria').AsDatetime := DtaFimVistoria;
    end;
    if Trim(SglProdutor) <> '' then
    begin
      EQuery.ParamByName('sgl_produtor').AsString := SglProdutor;
    end;
    if Trim(NomPessoaProdutor) <> '' then
    begin
      EQuery.ParamByName('nom_pessoa').AsString := '%' + NomPessoaProdutor + '%';
    end;
    if Trim(SglFazenda) <> '' then
    begin
      EQuery.ParamByName('sgl_fazenda').AsString := SglFazenda;
    end;
    if Trim(NomFazenda) <> '' then
    begin
      EQuery.ParamByName('nom_fazenda').AsString := '%' + NomFazenda + '%';
    end;
    if Trim(IndSituacaoImagemFazenda) <> '' then
    begin
      EQuery.ParamByName('ind_situacao_imagem').AsString := IndSituacaoImagemFazenda;
    end;
    if Trim(NomPropriedadeRural) <> '' then
    begin
      EQuery.ParamByName('nom_propriedade_rural').AsString := '%' + NomPropriedadeRural + '%';
    end;
    if Trim(NumImovelReceitaFederal) <> '' then
    begin
      EQuery.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
    end;
    if CodLocalizacaoSisbov > 0 then
    begin
      EQuery.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
    end;
    if CodEstado > 0 then
    begin
      EQuery.ParamByName('cod_estado').AsInteger := CodEstado;
    end;
    if Trim(NomMunicipio) <> '' then
    begin
      EQuery.ParamByName('nom_municipio').AsString := '%' + NomMunicipio + '%';
    end;                                                                           
    if DtaInicioCadastramento > 0 then
    begin
      EQuery.ParamByName('dta_inicio_cadastramento').AsDateTime := DtaInicioCadastramento;
    end;
    if DtaFimCadastramento > 0 then
    begin
      EQuery.ParamByName('dta_fim_cadastramento').AsDateTime := DtaFimCadastramento + 1;
    end;

    if (Conexao.CodPapelUsuario = 3) or
       (Conexao.CodPapelUsuario = 4) or
       (Conexao.CodPapelUsuario = 9) then
    begin
      EQuery.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
    end;
//    EQuery.SQL.SaveToFile('c:\sql\sql.sql');
    EQuery.ExecSQL;
{$ENDIF}

    //--------------------------------------
    //Atualiza técnico que atente o produtor
    //--------------------------------------
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(28) = 1) or (IntRelatorios.CampoAssociado(48) = 1) then begin
        EQuery.close;
        EQuery.sql.clear;

        strSQL := ' update #tmp_fazenda_relatorio ' +
                  '    set NomPessoaTecnico = tp.nom_pessoa ' +
                  '     ,  CpfPessoaTecnico = tp.num_cnpj_cpf ' +
                  '   from #tmp_fazenda_relatorio tmp ' +
                  '      , tab_pessoa tp ' +
                  '  where tp.cod_pessoa = tmp.CodPessoaTecnico ';

        EQuery.sql.Add(strSQL);
        EQuery.execSql;
    end;

    //----------------------------------
    //Obtendo totalizadores do relatório
    //----------------------------------

    // Propriedades
    EQuery.Close;
    EQuery.SQL.Text :=
      'select count(cod_propriedade_rural) as QtdPropriedadeRural '+
      'from (select distinct cod_propriedade_rural from #tmp_fazenda_relatorio) tmp ';
    EQuery.Open;
    QtdPropriedadeRural := EQuery.FieldByName('QtdPropriedadeRural').AsInteger;

    // Fazendas
    EQuery.Close;
    EQuery.SQL.Text :=
      'select count(cod_fazenda) as QtdFazenda '+
      'from (select distinct CodPessoaProdutor, cod_fazenda from #tmp_fazenda_relatorio) tmp ';
    EQuery.Open;
    QtdFazenda := EQuery.FieldByName('QtdFazenda').AsInteger;

    // Animais
    EQuery.Close;
    EQuery.SQL.Text :=
      'select sum(QtdAnimais) as QtdAnimal '+
      'from (select distinct CodPessoaProdutor, cod_fazenda, QtdAnimais from #tmp_fazenda_relatorio) tmp ';
    EQuery.Open;
    QtdAnimal := EQuery.FieldByName('QtdAnimal').AsInteger;


    //------------------------------
    //EQuery apresentada no Relatorio
    //------------------------------
    EQuery.Close;
    EQuery.SQL.Clear;
    strSQL := '';
    Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
    try
      Retorno := Rel.CarregarRelatorio(CodRelatorio);
      if Retorno < 0 then Exit;

      {Verifica se execução do procedimento está ocorrendo sobre uma tarefa}
      if CodTarefa > 0 then begin
        Rel.CodTarefa := CodTarefa;
      end;

      Rel.Campos.IrAoPrimeiro;
      while not Rel.campos.EOF do begin
        if Pos(Rel.Campos.Campo.NomField, 'QtdAnimais') = 0 then begin
          strSQL := strSQL + SE(strSQL = '', '', ', ') + Rel.Campos.Campo.NomField;
        end;
        Rel.Campos.IrAoProximo;
      end;
      if not bPersonalizavel or (IntRelatorios.CampoAssociado(27) = 1) then begin
        EQuery.SQL.Add('select ' + strSQL + SE(strSQL = '', '', ', ') + 'sum(QtdAnimais) as QtdAnimais ');
      end else begin
        EQuery.SQL.Add('select ' + strSQL);
      end;
      EQuery.SQL.Add('from #tmp_fazenda_Relatorio ');
      if strSQL <> '' then begin
        EQuery.SQL.Add('group by ' + strSQL);
        EQuery.SQL.Add('order by ' + strSQL);
      end;
    finally
      Rel.Free;
    end;
    EQuery.Open;
    Result := 0;
  Except
    on E: Exception do begin
      Rollback;
      iAux := Length(strExceedsTheConfiguredThreshold);
      if (CodTarefa = -1) and (Copy(E.Message, 1, iAux) = strExceedsTheConfiguredThreshold) then begin
        Result := idExceedsTheConfiguredThreshold;
      end else begin
        Mensagens.Adicionar(326, Self.ClassName, NomMetodo, [E.Message]);
        Result := -326;
      end;
      Exit;
    end;
  end;
end;

function TIntFazendas.GerarRelatorio(SglProdutor,
                                     NomPessoaProdutor,
                                     SglFazenda,
                                     NomFazenda,
                                     CodSituacaoSISBOVFazenda,
                                     IndSituacaoImagemFazenda,
                                     NomPropriedadeRural,
                                     NumImovelReceitaFederal: String;
                                     CodLocalizacaoSisbov, CodEstado: Integer;
                                     NomMunicipio,
                                     CodMicroRegiao: String;
                                     DtaInicioCadastramento,
                                     DtaFimCadastramento: TDateTime;
                                     Tipo,
                                     QtdQuebraRelatorio: Integer;
                                     CodTarefa: Integer;
                                     DtaInicioVistoria,
                                     DtaFimVistoria: TDateTime): String;
const
  NomMetodo: String = 'GerarRelatorio';
  CodMetodo: Integer =  353;
  CodRelatorio: Integer = 6;
  CodTipoTarefa: Integer = 5;  
var
  Rel: TRelatorioPadrao;
  Retorno,AuxQuebra: Integer;
  Aux,MontaTitulo,sQuebraTitulo1,sQuebraTitulo2: String;
  QtdPropriedadeRural, QtdFazenda, QtdAnimal: Integer;
  Qry: THerdomQuery;
begin
  Result := '';
  Qry := THerdomQuery.Create(Conexao, nil);
  Try
    If Not Inicializado Then Begin
      RaiseNaoInicializado(NomMetodo);
      Exit;
    End;

    //------------------------------------------
    // Verifica se usuário pode executar método
    //------------------------------------------
    If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
      Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
      Exit;
    End;

    Retorno := PesquisarRelatorio(Qry,
                                  SglProdutor,
                                  NomPessoaProdutor,
                                  SglFazenda,
                                  NomFazenda,
                                  CodSituacaoSISBOVFazenda,
                                  IndSituacaoImagemFazenda,
                                  NomPropriedadeRural,
                                  NumImovelReceitaFederal,
                                  CodLocalizacaoSisbov,
                                  CodEstado,
                                  NomMunicipio,
                                  CodMicroRegiao,
                                  QtdPropriedadeRural,
                                  QtdFazenda,
                                  QtdAnimal,
                                  DtaInicioCadastramento,
                                  DtaFimCadastramento,
                                  CodTarefa,
                                  DtaInicioVistoria,
                                  DtaFimVistoria);
    if Retorno < 0 then
    begin
      if Retorno = idExceedsTheConfiguredThreshold then
      begin
        Retorno := VerificarAgendamentoTarefa(CodTipoTarefa, [CodRelatorio, SglProdutor, NomPessoaProdutor,
                                              SglFazenda, NomFazenda, CodSituacaoSISBOVFazenda,
                                              IndSituacaoImagemFazenda, NomPropriedadeRural, NumImovelReceitaFederal,
                                              CodLocalizacaoSisbov,  CodEstado, NomMunicipio, CodMicroRegiao,
                                              QtdPropriedadeRural, QtdFazenda, QtdAnimal, DtaInicioCadastramento,
                                              DtaFimCadastramento, Tipo, QtdQuebraRelatorio]);
        if Retorno <= 0 then
        begin
          if Retorno = 0 then
          begin
            Mensagens.Adicionar(1994, Self.ClassName, NomMetodo, []);
          end;
          Exit;
        end;

        // Realiza o agendamento da tarefa para iniciar imediatamente ou tão logo possível
        Retorno := SolicitarAgendamentoTarefa(CodTipoTarefa, [CodRelatorio, SglProdutor, NomPessoaProdutor,
                                              SglFazenda, NomFazenda, CodSituacaoSISBOVFazenda,
                                              IndSituacaoImagemFazenda, NomPropriedadeRural, NumImovelReceitaFederal,
                                              CodLocalizacaoSisbov,  CodEstado, NomMunicipio, CodMicroRegiao,
                                              QtdPropriedadeRural, QtdFazenda, QtdAnimal, DtaInicioCadastramento,
                                              DtaFimCadastramento, Tipo, QtdQuebraRelatorio], DtaSistema);

        // Trata o resultado da solicitação, gerando mensagem se bem sucedido
        if Retorno >= 0 then
        begin
          Mensagens.Adicionar(1995, Self.Classname, NomMetodo, []);
        end;
        Exit;
      end;
    end;

    if Qry.IsEmpty then begin
      Mensagens.Adicionar(1141, Self.ClassName, NomMetodo, []);
      Exit;
    end;

    Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
    try
      Rel.TipoDoArquvio := Tipo;
      //-----------------------------------------------------------------
      //Define o relatório em questão e carrega os seus dados específicos
      //-----------------------------------------------------------------
      Retorno := Rel.CarregarRelatorio(CodRelatorio);
      if Retorno < 0 then Exit;

      {Verifica se execução do procedimento está ocorrendo sobre uma tarefa}
      if CodTarefa > 0 then begin
        Rel.CodTarefa := CodTarefa;
      end;

      //-------------------------------------------------------------
      //Desabilita a apresentação dos campos selecionados para quebra
      //-------------------------------------------------------------
      rel.Campos.IrAoPrimeiro;
      For auxQuebra := 1 to QtdQuebraRelatorio  do begin
        rel.Campos.DesabilitarCampo(rel.campos.campo.NomField);
        rel.Campos.IrAoProximo;
      end;
      //-------------------------------------------------------------
      //Inicializa o procedimento de geração do arquivo de relatório
      //-------------------------------------------------------------
      Retorno := Rel.InicializarRelatorio;
      if Retorno < 0 then Exit;

      Aux            := '';
      MontaTitulo    := '';
      sQuebraTitulo1 := '';
      sQuebraTitulo2 := '';

      Qry.First;
      while not Qry.EOF do begin
        if QtdQuebraRelatorio = 1 then begin
          rel.Campos.IrAoPrimeiro;
          if MontaTitulo <> rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString then begin
            MontaTitulo := rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString;
            if rel.LinhasRestantes = 1 then begin
              rel.ImprimirTexto(0,'');
              rel.ImprimirTexto(0,MontaTitulo);
            end else begin
                //1º titulo - sem espaço em branco
                if rel.LinhasPorPagina > rel.LinhasRestantes then begin
                  rel.ImprimirTexto(0,'');
                end;
                rel.ImprimirTexto(0,MontaTitulo);
            end;
          end else begin
            if rel.LinhasRestantes = rel.LinhasPorPagina then begin
              rel.ImprimirTexto(0,MontaTitulo + '  ' + '(continuação)');
            end;
          end;
        end
        else if QtdQuebraRelatorio = 2 then begin
          rel.Campos.IrAoPrimeiro;
          if sQuebraTitulo1 <> rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString + ' / ' then begin
              sQuebraTitulo1 := rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString + ' / ';
              rel.Campos.IrAoProximo;
              sQuebraTitulo2 := rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString;
              if rel.LinhasRestantes <= 2 then begin
                rel.NovaPagina;
                rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
              end else begin
                if rel.LinhasPorPagina > rel.LinhasRestantes then begin
                  rel.ImprimirTexto(0,'');
                end;
                rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
              end;
          end else begin
            rel.Campos.IrAoProximo;
            if sQuebraTitulo2 <> rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString then begin
              sQuebraTitulo2 := rel.campos.campo.TxtTitulo + ': ' + Qry.FieldByname(rel.campos.campo.NomField).asString;
              if rel.LinhasRestantes <=2 then begin
                rel.NovaPagina;
                rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
              end else begin
                rel.ImprimirTexto(0,'');
                rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
              end;
            end else begin
              if rel.LinhasRestantes = rel.LinhasPorPagina then begin
                rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2 + '  ' + '(continuação)');
              end;
            end;
          end;
        end;
        Rel.ImprimirColunasResultSet(Qry);
        Qry.Next;
      end;
      if Rel.LinhasRestantes < 4 then begin
        Rel.NovaPagina;
      end else begin
        Rel.NovaLinha;
      end;
      Rel.ImprimirTexto(0, 'Total de Propriedades: ' + IntToStr(QtdPropriedadeRural));
      Rel.ImprimirTexto(0, 'Total de Fazendas: ' + IntToStr(QtdFazenda));
      Rel.ImprimirTexto(0, 'Total de Animais: ' + IntToStr(QtdAnimal));

      Retorno := Rel.FinalizarRelatorio;
      if Retorno = 0 then begin
        Result := Rel.NomeArquivo;
      end;
    finally
      Rel.Free;
    end;
  finally
    Qry.Free;
  end;
end;

function TIntFazendas.InserirDadoGeral(NumCNPJCPFProdutor, CodNaturezaProdutor, SglFazenda,
  NomFazenda: String; CodEstado: Integer; NumPropriedadeRural,
  NumImovelReceitaFederal: String; CodRegimePosseUso: Integer;
  TxtObservacao: String): Integer;
const
  NomeMetodo: String = 'InserirDadoGeral';
var
  Q : THerdomQuery;
  CodFazenda, CodRegistroLog, CodPropriedadeRural, CodProdutor : Integer;
  NumCNPJCPFSemDv : String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(107) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

{  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'Inserir', []);
    Result := -307;
    Exit;
  End;
}
  // Garante que os caracteres da sigla estão em maiúsculo
  SglFazenda := UpperCase(SglFazenda);

  // Trata sigla do Fazenda
  Result := VerificaString(SglFazenda, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Verifica se a sigla só contém letras maíusculas e números
  Result := VerificaNumLetra(SglFazenda, 2, 'Sigla da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do Fazenda
  Result := VerificaString(NomFazenda, 'Nome da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomFazenda, 50, 'Nome da Fazenda');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata número da Propriedade Rural
  If NumPropriedadeRural <> '' Then Begin
    Result := TrataString(NumPropriedadeRural, 25, 'Número da Propriedade rural');
    If Result < 0 Then Begin
      Exit;
    End;
    If CodEstado <= 0 then Begin
      Mensagens.Adicionar(386, Self.ClassName, NomeMetodo, []);
      Result := -386;
      Exit;
    End;
  End;

  // Trata número CNPJ ou CPF
  if CodNaturezaProdutor = 'F' then begin
    Result := VerificaString(NumCNPJCPFProdutor, 'Número CPF');
    if Result < 0 then Exit;
    Result := TrataString(NumCNPJCPFProdutor,11, 'Número CPF');
    NumCNPJCPFSemDv := Copy(NumCNPJCPFProdutor,1,9);
  end else begin
    if CodNaturezaProdutor = 'J' then begin
      Result := VerificaString(NumCNPJCPFProdutor, 'Número CNPJ');
      if Result < 0 then Exit;
      Result := TrataString(NumCNPJCPFProdutor,14, 'Número CNPJ');
      NumCNPJCPFSemDv := Copy(NumCNPJCPFProdutor,1,12);
    end else begin
      Mensagens.Adicionar(416, Self.ClassName, NomeMetodo, []);
      Result := -416;
      Exit;
    end;
  end;

  if Result < 0 then Exit;

  if not VerificarCnpjCpf(NumCNPJCPFSemDv,NumCNPJCPFProdutor, ValorParametro(128)) then begin
    Mensagens.Adicionar(424, Self.ClassName, NomeMetodo, []);
    Result := -424;
    Exit;
  end;


  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      // Busca o Código do produtor através do CPF/CNPJ
      Q.SQL.Clear;
    {$IFDEF MSSQL}
      Q.SQL.Add('select tr.cod_pessoa_produtor from ');
      Q.SQL.Add(' tab_produtor tr, ');
      Q.SQL.Add(' tab_pessoa   tp  ');
      Q.SQL.Add(' where tp.cod_pessoa = tr.cod_pessoa_produtor ');
      Q.SQL.Add('  and rtrim(ltrim(tp.num_cnpj_cpf)) = :NumCNPJCPFProdutor ');
      Q.SQL.Add('  and tp.dta_fim_validade is null ');
    {$ENDIF}
      Q.ParamByName('NumCNPJCPFProdutor').AsString := NumCNPJCPFProdutor;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, [NumCNPJCPFProdutor]);
        Result := -170;
        Exit;
      End Else
        CodProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;

      Q.Close;


      // Trata NIRF
      If not ValidaNirfIncra(NumImovelReceitaFederal, True) Then Begin { Fábio - 14/07/2004 - Alteração da validação do NIRF/INCRA }
        Mensagens.Adicionar(494, Self.ClassName, NomeMetodo, [NumImovelReceitaFederal]);
        Result := -494;
        Exit;
      End;

      Q.SQL.Clear;
      Q.SQL.Add('select num_imovel_receita_federal, count(cod_propriedade_rural) as QtdPropriedade, max(cod_propriedade_rural) as CodPropriedadeRural from tab_propriedade_rural');
      Q.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal');
      Q.SQL.Add('group by num_imovel_receita_federal');
      Q.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
      Q.Open;

      if Q.FieldByName('QtdPropriedade').AsInteger = 0 then
      begin
        Mensagens.Adicionar(327, Self.ClassName, NomeMetodo, [NumImovelReceitaFederal]);
        Result := -327;
        Exit;
      end;

      if Q.FieldByName('QtdPropriedade').AsInteger > 1 then
      begin
        Mensagens.Adicionar(2095, Self.ClassName, NomeMetodo, [NumImovelReceitaFederal]);
        Result := -2095;
        Exit;
      end;
      CodPropriedadeRural := Q.FieldByName('CodPropriedadeRural').AsInteger;
      Q.Close;

      // Trata Observações
      Result := TrataString(TxtObservacao, 255, 'Observação');
      If Result < 0 Then Begin
        Exit;
      End;

      // Consiste o estado
      If CodEstado > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_estado ');
        Q.SQL.Add(' where cod_estado = :cod_estado ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(387, Self.ClassName, NomeMetodo, []);
          Result := -387;
          Exit;
        End;
        Q.Close;
      End;

      // Consiste indicador de tipo
      If CodRegimePosseUso > 0 Then Begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_regime_posse_uso ');
        Q.SQL.Add(' where cod_regime_posse_uso = :cod_regime_posse_uso ');
{$ENDIF}
        Q.ParamByName('cod_regime_posse_uso').AsInteger := CodRegimePosseUso;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(1692, Self.ClassName, NomeMetodo, []);
          Result := -1692;
          Exit;
        End;
        Q.Close;
      End;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and sgl_fazenda = :sgl_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('sgl_fazenda').AsString := SglFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(328, Self.ClassName, NomeMetodo, [SglFazenda]);
        Result := -328;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de nome
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and nom_fazenda = :nom_fazenda ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('nom_fazenda').AsString := NomFazenda;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(329, Self.ClassName, NomeMetodo, [NomFazenda]);
        Result := -329;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_fazenda), 0) + 1 as cod_fazenda ');
      Q.SQL.Add('  from tab_fazenda ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.Open;
      CodFazenda := Q.FieldByName('cod_fazenda').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_fazenda ' +
                ' (cod_pessoa_produtor, ' +
                '  cod_fazenda, ' +
                '  sgl_fazenda, ' +
                '  nom_fazenda, ' +
                '  cod_estado, ' +
                '  num_propriedade_rural, ' +
                '  cod_propriedade_rural, ' +
                '  ind_efetivado_uma_vez, ' +
                '  ind_situacao_imagem, ' +
                '  cod_regime_posse_uso, '+
                '  txt_observacao,' +
                '  dta_cadastramento, ' +
                '  cod_registro_log, ' +
                '  dta_fim_validade) ' +
                'values ' +
                ' (:cod_pessoa_produtor, ' +
                '  :cod_fazenda, ' +
                '  :sgl_fazenda, ' +
                '  :nom_fazenda, ' +
                '  :cod_estado, ' +
                '  :num_propriedade_rural, ' +
                '  :cod_propriedade_rural, ' +
                '  ''N'', ' +
                '  ''N'', ' +
                '  :cod_regime_posse_uso, '+
                '  :txt_observacao,' +
                '  getdate(), ' +
                '  :cod_registro_log, ' +
                '  null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodProdutor;
      Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
      Q.ParamByName('sgl_fazenda').AsString := SglFazenda;
      Q.ParamByName('nom_fazenda').AsString := NomFazenda;
      If CodEstado > 0 Then Begin
        Q.ParamByName('cod_estado').AsInteger := CodEstado;
      End Else Begin
        Q.ParamByName('cod_estado').DataType := ftInteger;
        Q.ParamByName('cod_estado').Clear;
      End;
      If NumPropriedadeRural <> '' Then Begin
        Q.ParamByName('num_propriedade_rural').AsString := NumPropriedadeRural;
      End Else Begin
        Q.ParamByName('num_propriedade_rural').DataType := ftString;
        Q.ParamByName('num_propriedade_rural').Clear;
      End;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      If CodRegimePosseUso > 0 Then Begin
        Q.ParamByName('cod_regime_posse_uso').AsInteger := CodRegimePosseUso;
      End Else Begin
        Q.ParamByName('cod_regime_posse_uso').DataType := ftInteger;
        Q.ParamByName('cod_regime_posse_uso').Clear;
      End;
      Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_fazenda', CodRegistroLog, 1, 107);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodFazenda;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(330, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -330;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

{ Método interno que insere uma fazenda a partir dos dados obtidos no arquivo
  gerado pelo SISBOV de produtores de uma certificadora.

  Após a inserção o método efetiva a fazenda com o código de localização
  SISBOV informado.

Parametros:
  CodArquivoExportacao: Código do arquivo que a fazenda deve ser exportada.
  CodPropriedadeRural: Código da propriedade rural da fazenda
  CodPessoaProdutor: Código do produtor da fazenda
  NomFazenda: Nome da fazenda no arquivo SISBOV
  UFMunicipio: Sigla do estado no arquivo SISBOV
  NomMunicipio: Municipio da fazenda no arquivo SISBOV

Retorno:
  Código da fazenda se a operação for realizda com sucesso.
  < 0 se ocorrer algum erro.}
function TIntFazendas.InserirFazendaCargaInicial(CodArquivoExportacao,
  CodPropriedadeRural, CodPessoaProdutor: Integer; NomFazenda,
  RegimePosseUso, CodLocalizacaoSISBOV: String): Integer;
const
  NomeMetodo: String = 'InserirFazendaCargaInicial';
var
  CodFazenda, CodRegimePosse: Integer;
  QueryLocal: THerdomQuery;
  NomProdutorTrabalho,
  SglFazenda: String;
begin
  Result := -1;
  CodFazenda := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    if Length(NomFazenda) > 50 then
    begin
      raise Exception.Create('O atributo NomFazenda é inválido.');
    end;
    if Length(SglFazenda) > 2 then
    begin
      raise Exception.Create('O atributo SglFazenda é inválido.');
    end;
    if Length(RegimePosseUso) > 4 then
    begin
      raise Exception.Create('O atributo RegimePosseUso é inválido.');
    end;
    if Length(CodLocalizacaoSISBOV) > 10 then
    begin
      raise Exception.Create('O atributo CodLocalizacaoSISBOV é inválido.');
    end;
    if CodArquivoExportacao <= 0 then
    begin
      raise Exception.Create('O atributo CodArquivoExportacao é obrigatório.');
    end;
    if StrToInt(Trim(CodLocalizacaoSISBOV)) <= 0 then
    begin
      raise Exception.Create('O atributo CodLocalizacaoSISBOV é obrigatório.');
    end;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Obtem o código do regime de posse e uso
      CodRegimePosse := -1;
      if Trim(RegimePosseUso) <> '' then
      begin
        with QueryLocal do
        begin
          SQL.Clear;
          SQL.Add('SELECT cod_regime_posse_uso');
          SQL.Add('  FROM tab_regime_posse_uso');
          SQL.Add(' WHERE sgl_regime_posse_uso = :sgl_regime_posse_uso');

          ParamByName('sgl_regime_posse_uso').AsString :=
            UpperCase(Trim(RegimePosseUso));
          Open;

          if IsEmpty then
          begin
            raise Exception.Create('O regime de posse e uso ' + RegimePosseUso
              + 'não foi encontrado.');
          end;

          CodRegimePosse := FieldByName('cod_regime_posse_uso').AsInteger;
        end;
      end;

      // Obtem a sigla da fazenda
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT IsNull(COUNT(cod_fazenda), 0) + 1 AS SglFazenda');
        SQL.Add('  FROM tab_fazenda');
        SQL.Add(' WHERE cod_pessoa_produtor = :cod_pessoa_produtor');

        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        Open;

        SglFazenda := PadL(FieldByName('SglFazenda').AsString, '0', 2);
      end;

      Result := Conexao.DefinirProdutorTrabalho(CodPessoaProdutor,
        NomProdutorTrabalho);
      if Result < 0 then
      begin
        Exit;
      end;

      // Insere a fazenda
      CodFazenda := Inserir(SglFazenda, NomFazenda, -1, '',
        CodRegimePosse, '', '', '', 0, '');
      if CodFazenda < 0 then
      begin
        Result := CodFazenda;
        Exit;
      end;

      Result := DefinirPropriedadeRural(CodFazenda, CodPropriedadeRural);
      if Result < 0 then
      begin
        Exit;
      end;

      // Efetiva o cadastro
      EfetivarCadastroCargaInicial(CodFazenda, CodPessoaProdutor,
        StrToInt(Trim(CodLocalizacaoSISBOV)), CodArquivoExportacao);
      if Result < 0 then
      begin
        Exit;
      end;
    finally
      QueryLocal.Free;
    end;

    Result := CodFazenda;
  except
    on E: EHerdomException do
    begin
      E.gerarMensagem(Mensagens);
      Result := -E.CodigoErro;
      Exit;
    end;
    on E: Exception do
    begin
      Mensagens.Adicionar(2079, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -2079;
      Exit;
    end;
  end;
end;



{ Efetiva uma fazenda inserida pela carga incial utilizando o código da
  localização SISBOV enviado pelo MAPA.

Parametros:
  CodFazenda: Código da fazenda inserida.
  CodProdutor: Código do produtor relacionado á fazenda.
  CodLocalizacaoSISBOV: Código da fazenda no SISBOV.

Exceptions:
  EHerdomExcetpion: caso ocorra algum erro.}
procedure TIntFazendas.EfetivarCadastroCargaInicial(CodFazenda,
  CodPessoaProdutor, CodLocalizacaoSISBOV, CodArquivoSISBOV: Integer);
const
  NomeMetodo: String = 'EfetivarCadastroCargaInicial';
var
  QueryLocal: THerdomQuery;
  CodPropriedadeRural,
  CodRegistroLog: Integer;
  Retorno: Integer;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  QueryLocal := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Valida o registro e obtem o código de LOG
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select cod_registro_log,');
        SQL.Add('       dta_efetivacao_cadastro,');
        SQL.Add('       cod_propriedade_rural,');
        SQL.Add('       cod_regime_posse_uso');
        SQL.Add('  from tab_fazenda');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   and cod_fazenda = :cod_fazenda');
        SQL.Add('   and dta_fim_validade is null');
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_fazenda').AsInteger := CodFazenda;
        Open;

        // Verifica se a fazenda existe
        if IsEmpty then
        begin
          raise EHerdomException.Create(310, Self.ClassName,
            NomeMetodo, [], False);
        end;

        if not FieldByName('dta_efetivacao_cadastro').IsNull then
        begin
          raise EHerdomException.Create(408, Self.ClassName, NomeMetodo,
            [], False);
        end;

        // Verifica se a propriedade rural foi informada
        if FieldByName('cod_propriedade_rural').IsNull then
        begin
          raise EHerdomException.Create(515, Self.ClassName, NomeMetodo,
            [], False);
        end;

        // Verifica se a propriedade rural informada é válida
        CodPropriedadeRural := FieldByName('cod_propriedade_rural').AsInteger;

        // Registro de LOG
        CodRegistroLog := FieldByName('cod_registro_log').AsInteger;

        Close;
      end;

      // Verifica se a propriedade foi efetivada
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select dta_efetivacao_cadastro ');
        SQL.Add('  from tab_propriedade_rural ');
        SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural');
        SQL.Add('   and dta_fim_validade is null ');
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Open;

       // Verifica se a propriedade existe
        if IsEmpty then
        begin
          raise EHerdomException.Create(517, Self.ClassName, NomeMetodo,
            [], False);
        end;

        // Verifica se a propriedade está efetivada
        if FieldByName('dta_efetivacao_cadastro').IsNull then
        begin
          raise EHerdomException.Create(516, Self.ClassName, NomeMetodo,
            [], False);
        end;

        Close;
      end;

      // Verifica se a localização SISBOV já existe
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('select 1 ');
        SQL.Add('  from tab_localizacao_sisbov ');
        SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural');
        SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Open;

        // Verifica se a localização SISBOV existe
        if not IsEmpty then
        begin
          raise Exception.Create('O código de localização SISBOV '
            + IntToStr(CodLocalizacaoSISBOV) + ' já está cadastrado.'
            + ' CodPessoa: ' + IntToStr(CodPessoaProdutor)
            + ' CodPropriedade: ' + IntToStr(CodPropriedadeRural));
        end;

        Close;
      end;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Retorno := GravarLogOperacao('tab_fazenda', CodRegistroLog, 2, 132);
      if Retorno < 0 then
      begin
        raise EHerdomException.Create(Retorno * -1, Self.ClassName, NomeMetodo,
          [], True);
      end;

      // Atualiza a localização SISBOV
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('insert into tab_localizacao_sisbov (');
        SQL.Add('  cod_propriedade_rural,');
        SQL.Add('  cod_pessoa_produtor,');
        SQL.Add('  cod_localizacao_sisbov,');
        SQL.Add('  cod_arquivo_sisbov');
        SQL.Add(') values (');
        SQL.Add('  :cod_propriedade_rural,');
        SQL.Add('  :cod_pessoa_produtor,');
        SQL.Add('  :cod_localizacao_sisbov,');
        SQL.Add('  :cod_arquivo_sisbov');
        SQL.Add(')');

        ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSISBOV;
        ParamByName('cod_arquivo_sisbov').AsInteger := CodArquivoSISBOV;
        ExecSQL;
      end;

      // Atualiza o contador da localização SISBOV
      with QueryLocal do
      begin
         SQL.Clear;
         SQL.Add('update tab_sequencia_codigo');
         SQL.Add('set cod_localizacao_sisbov = (select max(cod_localizacao_sisbov)');
         SQL.Add('                                from tab_localizacao_sisbov)');
         ExecSQL;
      end;

      // Tenta Alterar Registro
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('update tab_fazenda ');
        SQL.Add('   set dta_efetivacao_cadastro = getdate(),');
        SQL.Add('       ind_efetivado_uma_vez = ''S''');
        SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
        SQL.Add('   and cod_fazenda = :cod_fazenda ');

        ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
        ParamByName('cod_fazenda').AsInteger := CodFazenda;
        ExecSQL;
      end;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Retorno := GravarLogOperacao('tab_fazenda', CodRegistroLog, 3, 132);
      if Retorno < 0 then
      begin
        raise EHerdomException.Create(Retorno * -1, Self.ClassName, NomeMetodo,
          [], True);
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: EHerdomException do
    begin
      raise;
    end;
    on E: Exception do
    begin
      raise EHerdomException.Create(407, Self.ClassName, NomeMetodo,
        [E.Message], False);
    end;
  end;
end;

class function TIntFazendas.VerificaFazendaEfetivada(EConexao: TConexao;
  EMensagens: TIntMensagens; ECodFazenda: Integer;
  var ECodPropriedadeRural: Integer; var ENumImovelReceitaFederal: String;
  var ECodLocalizacaoSISBOV: Integer; var EDtaInicioCertificacao: TDateTime;
  ENomeCampo: String): Integer;
const
  NomeMetodo : String = 'VerificaFazendaEfetivada';
var
  QueryLocal: THerdomQuery;
begin
  QueryLocal := THerdomQuery.Create(EConexao, nil);
  try
    try
      with QueryLocal do
      begin
        SQL.Clear;
{$IFDEF MSSQL}
        SQL.Add('SELECT tf.dta_efetivacao_cadastro,');
        SQL.Add('       tf.cod_propriedade_rural,');
        SQL.Add('       tpr.num_imovel_receita_federal,');
        SQL.Add('       tpr.dta_inicio_certificacao,');
        SQL.Add('       tls.cod_localizacao_sisbov');
        SQL.Add('  FROM tab_fazenda tf,');
        SQL.Add('       tab_propriedade_rural tpr,');
        SQL.Add('       tab_localizacao_sisbov tls');
        SQL.Add(' WHERE tpr.cod_propriedade_rural = tf.cod_propriedade_rural');
        SQL.Add('   AND tls.cod_propriedade_rural = tf.cod_propriedade_rural');
        SQL.Add('   AND tls.cod_pessoa_produtor = tf.cod_pessoa_produtor');
        SQL.Add('   AND tf.cod_pessoa_produtor = :cod_pessoa_produtor');
        SQL.Add('   AND tf.cod_fazenda = :cod_fazenda');
{$ENDIF}
        ParamByName('cod_pessoa_produtor').AsInteger :=
          EConexao.CodProdutorTrabalho;
        ParamByName('cod_fazenda').AsInteger := ECodFazenda;
        Open;

        if IsEmpty then
        begin
          EMensagens.Adicionar(310, Self.ClassName, NomeMetodo, []);
          Result := -310;
          Exit;
        end;

        if FieldByName('dta_efetivacao_cadastro').IsNull then
        begin
          EMensagens.Adicionar(732, Self.ClassName, NomeMetodo, [ENomeCampo]);
          Result := -732;
          Exit;
        end;

        ECodPropriedadeRural     := FieldByName('cod_propriedade_rural').AsInteger;
        ENumImovelReceitaFederal := FieldByName('num_imovel_receita_federal').AsString;
        EDtaInicioCertificacao   := Trunc(FieldByName('dta_inicio_certificacao').AsDateTime);
        ECodLocalizacaoSISBOV    := FieldByName('cod_localizacao_sisbov').AsInteger;

        Close;
      end;
      Result := 0;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      EConexao.Rollback;
      EMensagens.Adicionar(496, Self.ClassName, NomeMetodo,
        [E.Message, ENomeCampo]);
      Result := -496;
      Exit;
    end;
  end;
end;

function TIntFazendas.desvincularProdutorPropriedade(cpfProdutor,
  cnpjProdutor: WideString; const idPropriedade: Int64): integer;
const
  NomeMetodo: String  = 'DesvincularProdutorPropriedade';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoDesvincularProdutorPropriedade:RetornoWsSISBOV;
  StatusSuspencao:widestring;
begin
  result  :=  -1;

  SoapSisbov := TIntSoapSisbov.Create;
  //terminar essa rotina
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);

    RetornoDesvincularProdutorPropriedade    := SoapSisbov.DesvincularProdutorPropriedade(
                             Descriptografar(ValorParametro(118))
                            , Descriptografar(ValorParametro(119))
                            , CpfProdutor
                            , CnpjProdutor
                            , idPropriedade );
    result  :=  0;
  finally
    SoapSisbov.Free;
  end;
end;

end.

