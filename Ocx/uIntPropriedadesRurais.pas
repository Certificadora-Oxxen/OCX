unit uIntPropriedadesRurais;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntPropriedadeRural, dbtables, sysutils, db, XSBuiltIns, Classes,
     uPrintPDF, uFerramentas, uConexao, uIntMensagens, DateUtils, WsSISBOV1, InvokeRegistry, Rio, SOAPHTTPClient,variants,XMLDoc,XMLIntf,SOAPHTTPTrans;

type
  { TIntPropriedadesRurais }
  TIntPropriedadesRurais = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPropriedadeRural  : TIntPropriedadeRural;

    function VerificaUtilizacaoAnimal(CodPropriedadeRural:  Integer): Integer;
    function VerificaUtilizacaoFazenda(CodPropriedadeRural:  Integer;
      IndFazendaEfetivada: Boolean): Integer;
    function VerificaMunicipioEfetivado(CodPropriedadeRural:  Integer): Integer;


  public
    QueryListaVistorias:THerdomQuery;
    QueryQuestionarioVistoria:THerdomQuery;
    constructor Create; override;
    destructor Destroy; override;
    function Inserir(NomPropriedadeRural, NumImovelReceitaFederal: String;
      CodTipoInscricao: Integer; NumLatitude, NumLongitude: Integer;
      QtdArea: Double; NomPessoaContato, NumTelefone, NumFax: String;
      DtaInicioCertificacao: TDateTime; TxtObservacao, OrientLa, OrientLo: String; TipoPro: Integer): Integer;
    function Pesquisar(CodPropriedadeRural: Integer;  NomPropriedadeRural,
      NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer;
      QtdAreaMinima, QtdAreaMaxima: Double; NomMunicipio, NumMunicipioIBGE,
      NomMicroRegiao: String; CodMicroRegiaoSisbov, CodEstado: Integer;
      SglEstado: String; CodPais: Integer; IndCadastroEfetivado,
      IndExportadoSisbov: String): Integer;
    function Buscar(CodPropriedadeRural: Integer): Integer; safecall;
    function Alterar(CodPropriedadeRural: Integer; NomPropriedadeRural,
      NumImovelReceitaFederal: String; CodTipoInscricao: Integer; NumLatitude,
      NumLongitude: Integer; QtdArea: String; NomPessoaContato, NumTelefone,
      NumFax: String; DtaInicioCertificacao: TDateTime;
      TxtObservacao, OrientLa, OrientLo: String; TipoPro: Integer): Integer;
    function EfetivarCadastro(CodPropriedadeRural: Integer): Integer;
    function CancelarEfetivacao(CodPropriedadeRural: Integer): Integer;
{    function DefinirProprietario(CodPropriedadeRural,
      CodPessoaProprietario: Integer): Integer;

    function LimparProprietario(CodPropriedadeRural: Integer): Integer;
}
    function DefinirEndereco(CodPropriedadeRural: Integer; NomLogradouro,
      NomBairro, NumCEP: String; CodPais, CodEstado, CodMunicipio,
      CodDistrito: Integer): Integer;
    function LimparEndereco(CodPropriedadeRural: Integer): Integer;
    function DefinirEnderecoCorrespondencia(CodPropriedadeRural: Integer;
      NomLogradouro, NomBairro, NumCEP: String; CodPais, CodEstado,
      CodMunicipio, CodDistrito: Integer): Integer;

    function DefinirProprietario(CodPropriedadeRural, CodProdutor: Integer): Integer;

    function LimparEnderecoCorrespondencia(
      CodPropriedadeRural: Integer): Integer;
    function Excluir(CodPropriedadeRural: Integer): Integer;
    function PesquisarPropriedade(CodPessoaProdutor, CodEstado,
      CodPropriedadeRural: Integer; NumImovelReceitaFederal: String;
      CodLocalizacaoSisbov, CodFazenda: Integer): Integer;
    function PesquisarPorProdutor(CodPessoaProdutor: Integer): Integer;
    class function VerificaLocalizacaoSISBOVPropriedade(EConexao: TConexao;
      EMensagem: TIntMensagens; ENumImovelReceitaFederal: String;
      ECodPropriedadeRural, ECodLocalizacaoSisbov, ECodPessoaProdutor: Integer;
      IndVerificaEfetivado: Boolean): Integer;

    function ExcluirVistoria(CodVistoria: Integer): Integer;
    function InserirVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
    function PesquisarVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
    function ImprimirCertificado(CodPropriedadeRural: Integer): String;
    //Druzo 27/05/2009 Eventos de Suspensão SISBOV
    function ConsultarSuspensao(CodPropriedadeRural: integer): integer;
    function suspenderPropriedade(IdPropriedadeSisbov,IdMotivo: integer;Obs:widestring):integer;
    /////////////////////////////
    //druzo 16-06-2009 - Eventos de Vistoria
    function iniciarVistoria(const CodPropriedadeRural: integer; const dataAgendamento: WideString; const CodTecnico: integer): integer;
    function ReagendarVistoria(const CodPropriedadeRural: integer; const dataReAgendamento: WideString; const CodTecnico: integer;Justificativa:WideString):integer;
    function LancarVistoria(const CodPropriedadeRural: integer; const dataAgendamento: WideString):integer;
    function FinalizarVistoria(cod_propriedade_rural:integer;cancelar:boolean):integer;
    function EmitirParecerVistoria(CodPropriedadeRural:integer;const parecer:widestring):integer;
    function ConsultarVistorias(CodPropriedadeRural:integer;DataVistoria:widestring):integer;
    function ProximaVistoria:integer;
    function IrAPrimeiraVistoria:integer;
    function VistoriaEof:Boolean;
    function ValorCampoVistoria(const NomeCampo:widestring):widestring;
    function ConsultarQuestionarioVistoria(CodPropriedadeRural:integer;DataVistoria:widestring):integer;
    function ProximoQuestionarioVistoria():integer;
    function IrAoPrimeiroQuestionarioVistoria():integer;
    function QuestionarioVistoriaEOF():boolean;
    function ValorCampoQuestionarioVistoria(Const NomeCampo:widestring):widestring;
    function GravarRespostaQuestionario(CodPropriedadeRural:integer;const DataVistoria:widestring;CodItemSISBOV:integer;Resposta,Conformidade:widestring):integer;
    function RecuperarCheckList(CodPropriedadeRural:integer;const dataAgendamento: WideString):integer;
    /////////////////////////////
    //druzo 07-07-2009
    function InformarPeriodoDeConfinamento(CodPropriedadeRural:integer;const DataInicioConfinamento, DataFimConfinamento:widestring;cancelar:wordbool):integer;
    function informarPeriodoDeConfinamento2(CodpropriedadeRural:integer;Const DataInicioConfinamento:widestring;Const DataFimConfinamento:WideString;Cancelar: boolean):integer;
    /////////////////////////////
    //druzo 07-04-2010
    function InformarAjusteRebanho(CodPropriedadeRural:integer):integer;
    // Métodos da carga inicial
    function InserirPropriedadeCargaInicial(NomPropriedadeRural,
      NumImovelReceitaFederal, NumLatitude, NumLongitude, QtdArea,
      NomLogradouro, NomBairro, NumCEP, UFMunicipio, NomMunicipio,
      NomPessoaContato, NumTelefone, NumFax, NomLogradouroCorrespondencia,
      NomBairroCorrespondencia, NumCEPCorrespondencia,
      UFMunicipioCorrespondencia, NomMunicipioCorrespondencia, SglTipoInscricao,
      DtaInicioCertificado: String): Integer;
    function StrDecimalToReal(Valor: String; QtdCasasDecimais: Integer;
      IndTemSinal: Boolean): Real;
    /////////////////////////////

    property IntPropriedadeRural : TIntPropriedadeRural read FIntPropriedadeRural write FIntPropriedadeRural;
  end;

implementation

uses uIntEnderecos, Math, uIntSoapSisbov;

constructor TIntPropriedadesRurais.Create;
begin
  inherited;
  FIntPropriedadeRural      := TIntPropriedadeRural.Create;
  QueryListaVistorias       :=  nil;
  QueryQuestionarioVistoria :=  nil;
end;

destructor TIntPropriedadesRurais.Destroy;
begin
  FIntPropriedadeRural.Free;
  if QueryListaVistorias <> nil then
  begin
    QueryListaVistorias.Close;
    QueryListaVistorias.Free;
  end;
  inherited;
end;

function TIntPropriedadesRurais.VerificaUtilizacaoAnimal(
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo : String = 'VerificaUtilizacaoAnimal';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where (cod_propriedade_nascimento = :cod_propriedade_rural ' +
                '    or cod_propriedade_identificacao = :cod_propriedade_rural ' +
                '    or cod_propriedade_corrente = :cod_propriedade_rural) ' +
                '   and dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(724, Self.ClassName, NomeMetodo, []);
        Result := -724;
        Exit;
      End;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, NomeMetodo, [E.Message, 'Existência da propriedade na tab_animal']);
        Result := -496;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.VerificaUtilizacaoFazenda(
  CodPropriedadeRural: Integer; IndFazendaEfetivada: Boolean): Integer;
const
  NomeMetodo : String = 'VerificaUtilizacaoFazenda';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ' +
                ' where cod_propriedade_rural = :cod_propriedade_rural ' +
                '   and dta_fim_validade is null');
      if IndFazendaEfetivada then begin
        Q.SQL.Add('   and dta_efetivacao_cadastro is not null ');
      End;
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if not Q.IsEmpty then begin
//          Foi retirado essa consistência, porque as alterações de propriedades
//          passam a ir automaticamente para o sisbov

//        if IndFazendaEfetivada then begin
//          Mensagens.Adicionar(728, Self.ClassName, NomeMetodo, []);
//          Result := -728;
//        End Else Begin

        if not IndFazendaEfetivada then begin
          Mensagens.Adicionar(727, Self.ClassName, NomeMetodo, []);
          Result := -727;
        End;
//        Exit;
      End;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, NomeMetodo, [E.Message, 'Existência da propriedade na tab_fazenda']);
        Result := -496;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.VerificaMunicipioEfetivado(
  CodPropriedadeRural: Integer): Integer;
const
  NomeMetodo : String = 'VerificaMunicipioEfetivado';
var
  Q : THerdomQuery;
  CodMun, CodMunC : Integer;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select cod_municipio, '+
                '       cod_municipio_correspondencia ' +
                '  from tab_propriedade_rural ' +
                ' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      CodMun := Q.FieldByName('cod_municipio').AsInteger;
      CodMunC := Q.FieldByName('cod_municipio_correspondencia').AsInteger;

      // Verifica se município é efetivado
      if CodMun > 0 then begin
        Q.SQL.Clear;
  {$ifDEF MSSQL}
        Q.SQL.Add('select dta_efetivacao_cadastro '+
                  '  from tab_municipio ' +
                  ' where cod_municipio = :cod_municipio ');
  {$ENDif}
        Q.ParamByName('cod_municipio').AsInteger := CodMun;
        Q.Open;
        if Q.FieldByName('dta_efetivacao_cadastro').IsNull then begin
          Mensagens.Adicionar(729, Self.ClassName, NomeMetodo, []);
          Result := -729;
          Exit;
        End;
      End;

      // Verifica se município de correspondência é efetivado
      if CodMunC > 0 then begin
        Q.SQL.Clear;
  {$ifDEF MSSQL}
        Q.SQL.Add('select dta_efetivacao_cadastro '+
                  '  from tab_municipio ' +
                  ' where cod_municipio = :cod_municipio ');
  {$ENDif}
        Q.ParamByName('cod_municipio').AsInteger := CodMunC;
        Q.Open;
        if Q.FieldByName('dta_efetivacao_cadastro').IsNull then begin
          Mensagens.Adicionar(729, Self.ClassName, NomeMetodo, []);
          Result := -729;
          Exit;
        End;
      End;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, NomeMetodo, [E.Message, 'efetivação do cadastro dos municípios da propriedade']);
        Result := -496;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

{ TIntPropriedadesRurais }
function TIntPropriedadesRurais.Inserir(NomPropriedadeRural, NumImovelReceitaFederal: String;
  CodTipoInscricao: Integer; NumLatitude, NumLongitude: Integer;
  QtdArea: Double; NomPessoaContato, NumTelefone, NumFax: String;
  DtaInicioCertificacao: TDateTime; TxtObservacao, OrientLa, OrientLo: String; TipoPro: Integer): Integer;
const
  NomeMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  CodPropriedadeRural: Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(182) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Trata nome da propriedade rural
  Result := VerificaString(NomPropriedadeRural, 'Nome da propriedade rural');
  if Result < 0 then
  begin
    Exit;
  end;
  Result := TrataString(NomPropriedadeRural, 50, 'Nome da propriedade rural');
  if Result < 0 then
  begin
    Exit;
  end;

  // Trata tipo da propriedade rural
  if TipoPro <= 0 then
  begin
    Mensagens.Adicionar(2282, Self.ClassName, NomeMetodo, []);
    Result := -2282;
    Exit;
  end;

  // Trata NIRF
  if Trim(NumImovelReceitaFederal) <> '' then begin   // Nirf não é mais obrigatório no novo SISBOV
    if not ValidaNirfIncra(CodTipoInscricao, NumImovelReceitaFederal, true) then
    begin
      Mensagens.Adicionar(494, Self.ClassName, NomeMetodo,
        [NumImovelReceitaFederal]);
      Result := -494;
      Exit;
    end;
  end;

  if (OrientLa = '') then
  begin
    Mensagens.Adicionar(2274, Self.ClassName, NomeMetodo, []);
    Result := -2274;
    Exit;
  end;

  if (OrientLo = '') then
  begin
    Mensagens.Adicionar(2275, Self.ClassName, NomeMetodo, []);
    Result := -2275;
    Exit;
  end;

{ O sisbov retirou a obrigatoriedade dos campos NumLatitude e NumLongitude
  if (NumLatitude = 0) or (OrientLa = '') then
  begin
    Mensagens.Adicionar(2274, Self.ClassName, NomeMetodo, []);
    Result := -2274;
    Exit;
  end;

  if (NumLongitude = 0) or (OrientLo = '') then
  begin
    Mensagens.Adicionar(2275, Self.ClassName, NomeMetodo, []);
    Result := -2275;
    Exit;
  end;
}

  // Trata área da Propriedade Rural
  if QtdArea <= 0 then
  begin
    Mensagens.Adicionar(495, Self.ClassName, NomeMetodo, []);
    Result := -495;
    Exit;
  end;

  // Trata área da Propriedade Rural
  if QtdArea > 99999999.99 then
  begin
    Mensagens.Adicionar(502, Self.ClassName, NomeMetodo, []);
    Result := -502;
    Exit;
  end;

  // Trata Pessoa de contato
  if NomPessoaContato <> '' then
  begin
    Result := TrataString(NomPessoaContato, 50, 'Pessoa para contato');
    if Result < 0 then
    begin
      Exit;
    end;
  end;

  // Trata Telefone
  if NumTelefone <> '' then
  begin
    Result := TrataString(NumTelefone, 15, 'Número do telefone');
    if Result < 0 then
    begin
      Exit;
    end;
  end;

  // Trata Telefone
  if NumFax <> '' then
  begin
    Result := TrataString(NumFax, 15, 'Número do fax');
    if Result < 0 then
    begin
      Exit;
    end;
  end;

  // Trata data de início de certificação
  if DtaInicioCertificacao <= 0 then
  begin
    Mensagens.Adicionar(500, Self.ClassName, NomeMetodo, []);
    Result := -500;
    Exit;
  end;

  // Trata data de início de certificação
  if DtaInicioCertificacao > DateOf(now) then
  begin
    Mensagens.Adicionar(2108, Self.ClassName, NomeMetodo, []);
    Result := -2108;
    Exit;
  end;

  // Trata Observação
  if TxtObservacao <> '' then begin
    Result := TrataString(TxtObservacao, 255, 'Observação');
    if Result < 0 then begin
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

//  Validação retirada em 17/01/2005! De acordo com o SISBOV, a propriedade passa a ser identificada por
//  NIRF/INCRA + código de exportação (cod_localizacao_sisbov). Com essa alteração será permitido a inserção
//  de mais de uma propriedade rural com o mesmo NIRF/INCRA, lembrando que ao chamar o método já deverá ter verificado
//  a existencia de outra(s) propriedade(s) com mesmo NIRF/INCRA, e caso exista, alertar o usuário com uma mensagem!

{      // Verifica duplicidade de NIRF
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_propriedade_rural ');
      Q.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal ');
      Q.SQL.Add('   and dta_fim_validade is null ');
      Q.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(499, Self.ClassName, 'Inserir', [NumImovelReceitaFederal]);
        Result := -499;
        Exit;
      End;
      Q.Close; }

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_propriedade_rural), 0) + 1 as cod_propriedade_rural ');
      Q.SQL.Add('  from tab_propriedade_rural ');
{$ENDif}
      Q.Open;
      CodPropriedadeRural := Q.FieldByName('cod_propriedade_rural').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('insert into tab_propriedade_rural ' +
                ' (cod_propriedade_rural, ' +
                '  nom_propriedade_rural, ' +
                '  cod_tipo_propriedade_rural, ' +
                '  num_imovel_receita_federal, ' +
                '  cod_tipo_inscricao, ' +
                '  cod_orientacao_latitude, ' +
                '  num_latitude, ' +
                '  cod_orientacao_longitude, ' +
                '  num_longitude, ' +
                '  qtd_area, ' +
                '  nom_logradouro, ' +
                '  nom_bairro, ' +
                '  num_cep, ' +
                '  cod_pais, ' +
                '  cod_estado, ' +
                '  cod_municipio, ' +
                '  cod_distrito, ' +
                '  nom_pessoa_contato, ' +
                '  num_telefone, ' +
                '  num_fax, ' +
                '  nom_logradouro_correspondencia, ' +
                '  nom_bairro_correspondencia, ' +
                '  num_cep_correspondencia, ' +
                '  cod_pais_correspondencia, ' +
                '  cod_estado_correspondencia, ' +
                '  cod_municipio_correspondencia, ' +
                '  cod_distrito_correspondencia, ' +
                '  dta_inicio_certificacao, ' +
                '  dta_cadastramento, ' +
                '  dta_efetivacao_cadastro, ' +
                '  txt_observacao, ' +
                '  ind_efetivado_uma_vez, ' +
                '  dta_fim_validade) ' +
                'values ' +
                ' (:cod_propriedade_rural, ' +
                '  :nom_propriedade_rural, ' +
                '  :cod_tipo_propriedade, ' +
                '  :num_imovel_receita_federal, ' +
                '  :cod_tipo_inscricao, ' +
                '  :cod_orientacao_latitude, ' +
                '  :num_latitude, ' +
                '  :cod_orientacao_longitude, ' +
                '  :num_longitude, ' +
                '  :qtd_area, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  :nom_pessoa_contato, ' +
                '  :num_telefone, ' +
                '  :num_fax, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  null, ' +
                '  :dta_inicio_certificacao, ' +
                '  getdate(), ' +
                '  null, ' +
                '  :txt_observacao, ' +
                '  ''N'', ' +
                '  null) ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ParamByName('nom_propriedade_rural').AsString := NomPropriedadeRural;
      Q.ParamByName('cod_tipo_propriedade').AsInteger := TipoPro;
      if Trim(NumImovelReceitaFederal) <> '' then begin   // Nirf não é mais obrigatório no novo SISBOV
        Q.ParamByName('num_imovel_receita_federal').AsString      := NumImovelReceitaFederal;
        Q.ParamByName('cod_tipo_inscricao').AsInteger := CodTipoInscricao;
      end else begin
        Q.ParamByName('cod_tipo_inscricao').DataType := ftInteger;
        Q.ParamByName('cod_tipo_inscricao').Clear;
        Q.ParamByName('num_imovel_receita_federal').DataType := ftString;
        Q.ParamByName('num_imovel_receita_federal').Clear;
      end;
      Q.ParamByName('cod_orientacao_latitude').AsString := OrientLa;
      Q.ParamByName('num_latitude').AsInteger := NumLatitude;
      Q.ParamByName('cod_orientacao_longitude').AsString := OrientLo;
      Q.ParamByName('num_longitude').AsInteger := NumLongitude;
      Q.ParamByName('qtd_area').AsFloat := QtdArea;

      if NomPessoaContato <> '' then
      begin
        Q.ParamByName('nom_pessoa_contato').AsString := NomPessoaContato;
      end
      else
      begin
        Q.ParamByName('nom_pessoa_contato').DataType := ftString;
        Q.ParamByName('nom_pessoa_contato').Clear;
      end;

      if NumTelefone <> '' then
      begin
        Q.ParamByName('num_telefone').AsString := NumTelefone;
      end
      else
      begin
        Q.ParamByName('num_telefone').DataType := ftString;
        Q.ParamByName('num_telefone').Clear;
      end;

      if NumFax <> '' then
      begin
        Q.ParamByName('num_fax').AsString := NumFax;
      end
      else
      begin
        Q.ParamByName('num_fax').DataType := ftString;
        Q.ParamByName('num_fax').Clear;
      end;

      Q.ParamByName('dta_inicio_certificacao').AsDateTime := Trunc(DtaInicioCertificacao);

      if TxtObservacao <> '' then
      begin
        Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      end
      else
      begin
        Q.ParamByName('txt_observacao').DataType := ftString;
        Q.ParamByName('txt_observacao').Clear;
      end;

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodPropriedadeRural;
    except
      on E: Exception do
      begin
        Rollback;
        Mensagens.Adicionar(501, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -501;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntPropriedadesRurais.Pesquisar(CodPropriedadeRural: Integer;  NomPropriedadeRural,
  NumImovelReceitaFederal: String; CodLocalizacaoSisbov: Integer; QtdAreaMinima, QtdAreaMaxima: Double;
  NomMunicipio, NumMunicipioIBGE, NomMicroRegiao: String; CodMicroRegiaoSisbov, CodEstado: Integer;
  SglEstado: String; CodPais: Integer; IndCadastroEfetivado,
  IndExportadoSisbov: String): Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(87) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  // Consiste parâmetros
  if QtdAreaMinima > QtdAreaMaxima then begin
    Mensagens.Adicionar(488, Self.ClassName, 'Pesquisar', []);
    Result := -488;
    Exit;
  End;

  Try
    Query.Close;
{$ifDEF MSSQL}
    Query.SQL.Clear;
    Query.SQL.Add('select tpr.cod_propriedade_rural as CodPropriedadeRural, ');
    Query.SQL.Add('       tpr.nom_propriedade_rural as NomPropriedadeRural, ');
    Query.SQL.Add('       tpr.cod_id_propriedade_sisbov as CodIdPropriedadeSisbov, ');
    Query.SQL.Add('       tpr.num_imovel_receita_federal as NumImovelReceitaFederal, ');
    Query.SQL.Add('       tpr.qtd_area as QtdArea, ');
    Query.SQL.Add('       tm.nom_municipio as NomMunicipio, ');
    Query.SQL.Add('       tm.num_municipio_ibge as NumMunicipioIBGE, ');

    if (NomMicroRegiao <> '') or (CodMicroRegiaoSisbov > 0) or (NomMunicipio <> '') or (NumMunicipioIBGE <> '') Then
    begin
      Query.SQL.Add('       tmr.nom_micro_regiao as NomMicroRegiao, ');
      Query.SQL.Add('       tmr.cod_micro_regiao_sisbov as CodMicroRegiaoSisbov, ');
    end
    else
    begin
      Query.SQL.Add('       null as NomMicroRegiao, ');
      Query.SQL.Add('       null as CodMicroRegiaoSisbov, ');
    end;

    Query.SQL.Add('       te.sgl_estado as SglEstado, ');
    Query.SQL.Add('       tpa.nom_pais as NomPais, ');
    Query.SQL.Add('       case ');
    Query.SQL.Add('         when tpr.dta_efetivacao_cadastro is null then ''N'' ');
    Query.SQL.Add('       else ');
    Query.SQL.Add('         ''S'' ');
    Query.SQL.Add('       end as IndCadastroEfetivado, ');

    if UpperCase(IndExportadoSisbov) = 'N' then
    begin
      Query.SQL.Add('       ''N'' as IndExportadoSisbov, ');
    end
    else
    if UpperCase(IndExportadoSisbov) = 'S'  then
    begin
      Query.SQL.Add('       ''S'' as IndExportadoSisbov, ');
    end
    else
    begin
      Query.SQL.Add('       case ');
      Query.SQL.Add('         when tls2.cod_propriedade_rural is null then ''N'' ');
      Query.SQL.Add('       else ');
      Query.SQL.Add('         ''S'' ');
      Query.SQL.Add('       end as IndExportadoSisbov, ');
    End;
    Query.SQL.Add('       tls2.cod_localizacao_sisbov as CodLocalizacaoSisbov, ');
    Query.SQL.Add('       tp.nom_pessoa as NomPessoa ');
    Query.SQL.Add('  from tab_propriedade_rural tpr left outer join tab_localizacao_sisbov tls2 on tls2.cod_propriedade_rural = tpr.cod_propriedade_rural ');
    Query.SQL.Add('                                 left outer join tab_pessoa tp on tp.cod_pessoa = tls2.cod_pessoa_produtor ');
    Query.SQL.Add('                                 left outer join tab_municipio tm on tm.cod_municipio = tpr.cod_municipio ');
    Query.SQL.Add('                                 left outer join tab_estado te on te.cod_estado = tpr.cod_estado ');
    Query.SQL.Add('                                 left outer join tab_pais tpa on tpa.cod_pais = tpr.cod_pais ');

    if (NomMicroRegiao <> '') or (CodMicroRegiaoSisbov > 0) or (NomMunicipio <> '') or (NumMunicipioIBGE <> '') then begin
      Query.SQL.Add('   , tab_micro_regiao tmr ');
    End;

    Query.SQL.Add(' where (1 = 1)');

    if (NomMicroRegiao <> '') or (CodMicroRegiaoSisbov > 0) or (NomMunicipio <> '') or (NumMunicipioIBGE <> '') then begin
      Query.SQL.Add(' and tmr.cod_micro_regiao = tm.cod_micro_regiao ');
    End;

    if UpperCase(IndExportadoSisbov) = 'N' then begin
      Query.SQL.Add(' and not exists (select top 1 1 from tab_localizacao_sisbov '+
                    '                 where cod_propriedade_rural = tpr.cod_propriedade_rural '+
                    '                   and cod_arquivo_sisbov is not null) ');
    End;

    // Filtros
    if CodPropriedadeRural > 0 then begin
      Query.SQL.Add('   and tpr.cod_propriedade_rural = :cod_propriedade_rural ');
    End;
    if NomPropriedadeRural <> '' then begin
      Query.SQL.Add('   and tpr.nom_propriedade_rural like :nom_propriedade_rural ');
    End;
    if NumImovelReceitaFederal <> '' then begin
      Query.SQL.Add('   and tpr.num_imovel_receita_federal = :num_imovel_receita_federal ');
    End;
    if CodLocalizacaoSisbov > 0 then begin
      Query.SQL.Add('   and (tls2.cod_localizacao_sisbov = :cod_localizacao_sisbov and tls2.cod_localizacao_sisbov is not null)');
    end;
    if QtdAreaMaxima > 0 then begin
      Query.SQL.Add('   and tpr.qtd_area between :qtd_area_minima and :qtd_area_maxima ');
    End;
    if NomMunicipio <> '' then begin
      Query.SQL.Add('   and (tm.nom_municipio like :nom_municipio and tpr.cod_municipio is not null)');
    End;
    if NumMunicipioIBGE <> '' then begin
      Query.SQL.Add('   and (tm.num_municipio_ibge like :num_municipio_ibge and tpr.cod_municipio is not null)');
    End;
    if NomMicroRegiao <> '' then begin
      Query.SQL.Add('   and (tmr.nom_micro_regiao like :nom_micro_regiao and tpr.cod_micro_regiao is not null)');
    End;
    if CodMicroRegiaoSisbov > 0 then begin
      Query.SQL.Add('   and (tmr.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov and tpr.cod_micro_regiao is not null)');
    End;
    if CodEstado > 0 then begin
      Query.SQL.Add('   and (tpr.cod_estado = :cod_estado and tpr.cod_estado is not null)');
    End;
    if SglEstado <> '' then begin
      Query.SQL.Add('   and (te.sgl_estado = :sgl_estado and tpr.cod_estado is not null)');
    End;
    if CodPais > 0 then begin
      Query.SQL.Add('   and (tpr.cod_pais = :cod_pais and tpr.cod_pais is not null)');
    End;
    if UpperCase(IndCadastroEfetivado) = 'S' then begin
      Query.SQL.Add('   and tpr.dta_efetivacao_cadastro is not null ');
    End;
    if UpperCase(IndCadastroEfetivado) = 'N' then begin
      Query.SQL.Add('   and tpr.dta_efetivacao_cadastro is null ');
    End;

    Query.SQL.Add('  and tpr.dta_fim_validade is null ');

    Query.SQL.Add('  order by tpr.nom_propriedade_rural, tpr.num_imovel_receita_federal, tpr.cod_propriedade_rural, tls2.cod_localizacao_sisbov ');
{$ENDif}

    // Trata parâmetros
    if CodPropriedadeRural > 0 then begin
      Query.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
    End;
    if NomPropriedadeRural <> '' then begin
      Query.ParamByName('nom_propriedade_rural').AsString := '%' + NomPropriedadeRural + '%';
    End;
    if NumImovelReceitaFederal <> '' then begin
      Query.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
    End;
    if CodLocalizacaoSisbov > 0 then begin
      Query.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;
    end;
    if QtdAreaMaxima > 0 then begin
      Query.ParamByName('qtd_area_minima').AsBCD := QtdAreaMinima;
      Query.ParamByName('qtd_area_maxima').AsBCD := QtdAreaMaxima;
    End;
{    if NomPessoaProprietario <> '' then begin
      Query.ParamByName('nom_pessoa').AsString := '%' + NomPessoaProprietario + '%';
    End;
    if CodPessoaProprietario > 0 then begin
      Query.ParamByName('cod_pessoa').AsInteger := CodPessoaProprietario;
    End;
    if NumCNPJCPF <> '' then begin
      Query.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPF + '%';
    End; }
    if NomMunicipio <> '' then begin
      Query.ParamByName('nom_municipio').AsString := '%' + NomMunicipio + '%';
    End;
    if NumMunicipioIBGE <> '' then begin
      Query.ParamByName('num_municipio_ibge').AsString := NumMunicipioIBGE + '%';
    End;
    if NomMicroRegiao <> '' then begin
      Query.ParamByName('nom_micro_regiao').AsString := '%' + NomMicroRegiao + '%';
    End;
    if CodMicroRegiaoSisbov > 0 then begin
      Query.ParamByName('cod_micro_regiao_sisbov').AsInteger := CodMicroRegiaoSisbov;
    End;
    if CodEstado > 0 then begin
      Query.ParamByName('cod_estado').AsInteger := CodEstado;
    End;
    if SglEstado <> '' then begin
      Query.ParamByName('sgl_estado').AsString := SglEstado;
    End;
    if CodPais > 0 then begin
      Query.ParamByName('cod_pais').AsInteger := CodPais;
    End;

//    Query.SQL.SaveToFile('c:\query.sql');

    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(325, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -325;
      Exit;
    End;
  End;
end;

function TIntPropriedadesRurais.Buscar(CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(183) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select tpr.cod_propriedade_rural, ');
      Q.SQL.Add('       tpr.nom_propriedade_rural, ');
      Q.SQL.Add('       ttp.cod_tipo_propriedade_rural, ');
      Q.SQL.Add('       ttp.des_tipo_propriedade_rural, ');
      Q.SQL.Add('       tpr.num_imovel_receita_federal, ');
      Q.SQL.Add('       tpr.cod_tipo_inscricao, ');
      Q.SQL.Add('       tpr.cod_orientacao_latitude, ');
      Q.SQL.Add('       tpr.num_latitude, ');
      Q.SQL.Add('       tpr.cod_orientacao_longitude, ');
      Q.SQL.Add('       tpr.num_longitude, ');
      Q.SQL.Add('       tpr.qtd_area, ');
      Q.SQL.Add('       tpr.cod_pessoa_proprietario, ');
      Q.SQL.Add('       tpr.nom_logradouro, ');
      Q.SQL.Add('       tpr.nom_bairro, ');
      Q.SQL.Add('       tpr.num_cep, ');
      Q.SQL.Add('       tpr.cod_pais, ');
      Q.SQL.Add('       tpa.nom_pais, ');
      Q.SQL.Add('       tpa.cod_pais_sisbov, ');
      Q.SQL.Add('       tpr.cod_estado, ');
      Q.SQL.Add('       te.sgl_estado, ');
      Q.SQL.Add('       te.cod_estado_sisbov, ');
      Q.SQL.Add('       tpr.cod_municipio, ');
      Q.SQL.Add('       tm.nom_municipio, ');
      Q.SQL.Add('       tm.cod_micro_regiao, ');
      Q.SQL.Add('       tpr.cod_distrito, ');
      Q.SQL.Add('       td.nom_distrito, ');
      Q.SQL.Add('       tpr.nom_pessoa_contato, ');
      Q.SQL.Add('       tpr.num_telefone, ');
      Q.SQL.Add('       tpr.num_fax, ');
      Q.SQL.Add('       tpr.nom_logradouro_correspondencia, ');
      Q.SQL.Add('       tpr.nom_bairro_correspondencia, ');
      Q.SQL.Add('       tpr.num_cep_correspondencia, ');
      Q.SQL.Add('       tpr.cod_pais_correspondencia, ');
      Q.SQL.Add('       tpa1.nom_pais as nom_pais_correspondencia, ');
      Q.SQL.Add('       tpa1.cod_pais_sisbov as cod_pais_sisbov_correspond, ');
      Q.SQL.Add('       tpr.cod_estado_correspondencia, ');
      Q.SQL.Add('       te1.sgl_estado as sgl_estado_correspondencia, ');
      Q.SQL.Add('       te1.cod_estado_sisbov as cod_estado_sisbov_correspond, ');
      Q.SQL.Add('       tpr.cod_municipio_correspondencia, ');
      Q.SQL.Add('       tm1.nom_municipio as nom_municipio_correspondencia, ');
      Q.SQL.Add('       tpr.cod_distrito_correspondencia, ');
      Q.SQL.Add('       td1.nom_distrito as nom_distrito_correspondencia, ');
      Q.SQL.Add('       tpr.dta_inicio_certificacao, ');
      Q.SQL.Add('       tpr.dta_cadastramento, ');
      Q.SQL.Add('       tpr.dta_efetivacao_cadastro, ');
      Q.SQL.Add('       tpr.cod_id_propriedade_sisbov, ');
      Q.SQL.Add('       tpr.txt_observacao, ');
      Q.SQL.Add('       tpr.ind_efetivado_uma_vez, ');
      Q.SQL.Add('       tp.cod_pessoa as cod_pessoa_proprietario, ');
      Q.SQL.Add('       tp.nom_pessoa as nom_pessoa_proprietario, ');
      Q.SQL.Add('       tp.cod_natureza_pessoa as cod_natureza_pessoa_prop, ');
      Q.SQL.Add('       case tp.cod_natureza_pessoa  ' +
                '         when ''F'' then convert(varchar(18), ' +
                '           substring(tp.num_cnpj_cpf, 1, 3) + ''.'' +     ' +
                '           substring(tp.num_cnpj_cpf, 4, 3) + ''.'' +     ' +
                '           substring(tp.num_cnpj_cpf, 7, 3) + ''-'' +     ' +
                '           substring(tp.num_cnpj_cpf, 10, 2))             ' +
                '         when ''J'' then convert(varchar(18),             ' +
                '           substring(tp.num_cnpj_cpf, 1, 2) + ''.'' +     ' +
                '           substring(tp.num_cnpj_cpf, 3, 3) + ''.'' +     ' +
                '           substring(tp.num_cnpj_cpf, 6, 3) + ''/'' +     ' +
                '           substring(tp.num_cnpj_cpf, 9, 4) + ''-'' +     ' +
                '           substring(tp.num_cnpj_cpf, 13, 2))             ' +
                '       end                     as num_CNPJCPF_formatado_prop, ');
      Q.SQL.Add('       tpr.dta_inicio_confinamento, ');
      Q.SQL.Add('       tpr.dta_fim_confinamento, ');
      Q.SQL.Add('       tpr.dta_inicio_periodo_ajuste_rebanho as dta_ini_per_aj_reb ');
      Q.SQL.Add('  from tab_propriedade_rural tpr, ');
      Q.SQL.Add('       tab_pais tpa, ');
      Q.SQL.Add('       tab_estado te, ');
      Q.SQL.Add('       tab_municipio tm, ');
      Q.SQL.Add('       tab_distrito td, ');
      Q.SQL.Add('       tab_pais tpa1, ');
      Q.SQL.Add('       tab_estado te1, ');
      Q.SQL.Add('       tab_municipio tm1, ');
      Q.SQL.Add('       tab_distrito td1, ');
      Q.SQL.Add('       tab_pessoa tp, ');
      Q.SQL.Add('       tab_tipo_propriedade_rural ttp ');
      Q.SQL.Add(' where tpa.cod_pais =* tpr.cod_pais ');
      Q.SQL.Add('   and te.cod_estado =* tpr.cod_estado ');
      Q.SQL.Add('   and tm.cod_municipio =* tpr.cod_municipio ');
      Q.SQL.Add('   and td.cod_distrito =* tpr.cod_distrito ');
      Q.SQL.Add('   and tpa1.cod_pais =* tpr.cod_pais_correspondencia ');
      Q.SQL.Add('   and te1.cod_estado =* tpr.cod_estado_correspondencia ');
      Q.SQL.Add('   and tm1.cod_municipio =* tpr.cod_municipio_correspondencia ');
      Q.SQL.Add('   and td1.cod_distrito =* tpr.cod_distrito_correspondencia ');
      Q.SQL.Add('   and tpr.cod_pessoa_proprietario *= tp.cod_pessoa ');
      Q.SQL.Add('   and tpr.cod_tipo_propriedade_rural *= ttp.cod_tipo_propriedade_rural ');
      Q.SQL.Add('   and tpr.cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and tpr.dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'Buscar', []);
        Result := -327;
        Exit;
      End;

      // Obtem informações do registro
      IntPropriedadeRural.CodPropriedadeRural := Q.FieldByName('cod_propriedade_rural').AsInteger;
      IntPropriedadeRural.NomPropriedadeRural := Q.FieldByName('nom_propriedade_rural').AsString;
      IntPropriedadeRural.CodTipoPropriedadeRural := Q.FieldByName('cod_tipo_propriedade_rural').AsInteger;
      IntPropriedadeRural.DesTipoPropriedadeRural := Q.FieldByName('des_tipo_propriedade_rural').AsString;
      IntPropriedadeRural.NumImovelReceitaFederal := Q.FieldByName('num_imovel_receita_federal').AsString;
      IntPropriedadeRural.CodTipoInscricao := Q.FieldByName('cod_tipo_inscricao').AsInteger;
      IntPropriedadeRural.OrientacaoLat := Q.FieldByName('cod_orientacao_latitude').AsString;
      IntPropriedadeRural.NumLatitude := Q.FieldByName('num_latitude').AsInteger;
      IntPropriedadeRural.OrientacaoLon := Q.FieldByName('cod_orientacao_longitude').AsString;
      IntPropriedadeRural.NumLongitude := Q.FieldByName('num_longitude').AsInteger;
      IntPropriedadeRural.QtdArea := Q.FieldByName('qtd_area').AsFloat;
      IntPropriedadeRural.NomLogradouro := Q.FieldByName('nom_logradouro').AsString;
      IntPropriedadeRural.NomBairro := Q.FieldByName('nom_bairro').AsString;
      IntPropriedadeRural.NumCEP := Q.FieldByName('num_cep').AsString;
      IntPropriedadeRural.CodPais := Q.FieldByName('cod_pais').AsInteger;
      IntPropriedadeRural.NomPais := Q.FieldByName('nom_pais').AsString;
      IntPropriedadeRural.CodPaisSisbov := Q.FieldByName('cod_pais_sisbov').AsInteger;
      IntPropriedadeRural.CodEstado := Q.FieldByName('cod_estado').AsInteger;
      IntPropriedadeRural.SglEstado := Q.FieldByName('sgl_estado').AsString;
      IntPropriedadeRural.CodEstadoSisbov := Q.FieldByName('cod_estado_sisbov').AsInteger;
      IntPropriedadeRural.CodMicroRegiao := Q.FieldByName('cod_micro_regiao').AsInteger;
      IntPropriedadeRural.CodMunicipio := Q.FieldByName('cod_municipio').AsInteger;
      IntPropriedadeRural.NomMunicipio := Q.FieldByName('nom_municipio').AsString;
      IntPropriedadeRural.CodDistrito := Q.FieldByName('cod_distrito').AsInteger;
      IntPropriedadeRural.NomDistrito := Q.FieldByName('nom_distrito').AsString;
      IntPropriedadeRural.NomPessoaContato := Q.FieldByName('nom_pessoa_contato').AsString;
      IntPropriedadeRural.NumTelefone := Q.FieldByName('num_telefone').AsString;
      IntPropriedadeRural.NumFax := Q.FieldByName('num_fax').AsString;
      IntPropriedadeRural.NomLogradouroCorrespondencia := Q.FieldByName('nom_logradouro_correspondencia').AsString;
      IntPropriedadeRural.NomBairroCorrespondencia := Q.FieldByName('nom_bairro_correspondencia').AsString;
      IntPropriedadeRural.NumCEPCorrespondencia := Q.FieldByName('num_cep_correspondencia').AsString;
      IntPropriedadeRural.CodPaisCorrespondencia := Q.FieldByName('cod_pais_correspondencia').AsInteger;
      IntPropriedadeRural.NomPaisCorrespondencia := Q.FieldByName('nom_pais_correspondencia').AsString;
      IntPropriedadeRural.CodPaisSisbovCorrespondencia := Q.FieldByName('cod_pais_sisbov_correspond').AsInteger;
      IntPropriedadeRural.CodEstadoCorrespondencia := Q.FieldByName('cod_estado_correspondencia').AsInteger;
      IntPropriedadeRural.SglEstadoCorrespondencia := Q.FieldByName('sgl_estado_correspondencia').AsString;
      IntPropriedadeRural.CodEstadoSisbovCorrespondencia := Q.FieldByName('cod_estado_sisbov_correspond').AsInteger;
      IntPropriedadeRural.CodMunicipioCorrespondencia := Q.FieldByName('cod_municipio_correspondencia').AsInteger;
      IntPropriedadeRural.NomMunicipioCorrespondencia := Q.FieldByName('nom_municipio_correspondencia').AsString;
      IntPropriedadeRural.CodDistritoCorrespondencia := Q.FieldByName('cod_distrito_correspondencia').AsInteger;
      IntPropriedadeRural.NomDistritoCorrespondencia := Q.FieldByName('nom_distrito_correspondencia').AsString;
      IntPropriedadeRural.DtaInicioCertificacao := Q.FieldByName('dta_inicio_certificacao').AsDateTime;
      IntPropriedadeRural.DtaCadastramento := Q.FieldByName('dta_cadastramento').AsDateTime;
      IntPropriedadeRural.DtaEfetivacaoCadastro := Q.FieldByName('dta_efetivacao_cadastro').AsDateTime;
      IntPropriedadeRural.CodIdPropriedadeSisbov := Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
      IntPropriedadeRural.TxtObservacao := Q.FieldByName('txt_observacao').AsString;
      IntPropriedadeRural.IndEfetivadoUmaVez := Q.FieldByName('ind_efetivado_uma_vez').AsString;
      IntPropriedadeRural.CodPessoaProprietario := Q.FieldByName('cod_pessoa_proprietario').AsInteger;
      IntPropriedadeRural.NomPessoaProprietario := Q.FieldByName('nom_pessoa_proprietario').AsString;
      IntPropriedadeRural.CodNaturezaPessoaProp := Q.FieldByName('cod_natureza_pessoa_prop').AsString;
      IntPropriedadeRural.NumCNPJCPFFormatadoProp := Q.FieldByName('num_CNPJCPF_formatado_prop').AsString;
      IntPropriedadeRural.DtaInicioConfinamento   :=  Q.FieldByName('dta_inicio_confinamento').AsDateTime;
      IntPropriedadeRural.DtaFimConfinamento      :=  Q.FieldByName('dta_fim_confinamento').AsDateTime;
      IntPropriedadeRural.DtaInicioPeriodoAjusteRebanho :=  Q.fieldbyname('dta_ini_per_aj_reb').AsDateTime;
      


      // Tenta Buscar MicroRegiao
      if IntPropriedadeRural.CodMicroRegiao > 0 then begin
        Q.Close;
        Q.SQL.Clear;
  {$ifDEF MSSQL}
        Q.SQL.Add('select nom_micro_regiao, ');
        Q.SQL.Add('       cod_micro_regiao_sisbov ');
        Q.SQL.Add('  from tab_micro_regiao ');
        Q.SQL.Add(' where cod_micro_regiao = :cod_micro_regiao ');
  {$ENDif}
        Q.ParamByName('cod_micro_regiao').AsInteger := IntPropriedadeRural.CodMicroRegiao;
        Q.Open;

        // Verifica se existe registro para busca
        if not Q.IsEmpty then begin
          IntPropriedadeRural.NomMicroRegiao := Q.FieldByName('nom_micro_regiao').AsString;
          IntPropriedadeRural.CodMicroRegiaoSisbov := Q.FieldByName('cod_micro_regiao_sisbov').AsInteger;
        End;
      End;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(359, Self.ClassName, 'Buscar', [E.Message]);
        Result := -359;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.Alterar(CodPropriedadeRural: Integer; NomPropriedadeRural,
  NumImovelReceitaFederal: String; CodTipoInscricao: Integer; NumLatitude,
  NumLongitude: Integer; QtdArea: String;
  NomPessoaContato, NumTelefone, NumFax: String;
  DtaInicioCertificacao: TDateTime; TxtObservacao, OrientLa, OrientLo: String; TipoPro: Integer): Integer;
var
  Q, Q1 : THerdomQuery;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoAPropriedade: RetornoAlterarPropriedade;
  NomMetodo, CodOrientLatitude, CodOrientLongitude, TelefoneContato, FaxContato, SNirf, SIncra : String;
  QtdDistanciaMunicipio, AreaProriedade, SGLatitude, SMLatitude, SSLatitude, SGLongitude, SMLongitude, SSLongitude : Integer;
  QtdAreaConv: Double;
  DataQuarentena: TDateTime;

function ConverteValorFlutuanteParaString(ValorFlutuante: Double): String;
var tmpS: String;
begin
  Result := IntToStr(Trunc(ValorFlutuante));
  tmpS   := FormatFloat('0.0#', ValorFlutuante);
  System.Delete(tmpS, 1, Pos(',', tmpS));
  Result := Result + Copy(tmpS + '00', 1, 2);
end;

begin
  Result := -1;
  NomMetodo := 'AlterarPropriedade';
  DataQuarentena := 0;

  QtdAreaConv := StrToFloatDef(QtdArea, 0);

  if Not Inicializado then begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(186) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    if (NomPropriedadeRural <> '') or
       (NumImovelReceitaFederal <> '') or
       (NumLatitude >= 0) or
       (NumLongitude >= 0) or
       (QtdAreaConv > 0) or
       (NomPessoaContato <> '') or
       (NumTelefone <> '') or
       (NumFax <> '') or
       (DtaInicioCertificacao > 0) then begin
      Mensagens.Adicionar(507, Self.ClassName, 'Alterar', []);
      Result := -507;
      Exit;
    End;
  End;

  // Verifica se pelo menos um parâmetro foi informado
  if (NomPropriedadeRural = '') and
     (TipoPro <= 0) and
     (NumImovelReceitaFederal = '') and
     (CodTipoInscricao <= 0) and
     (NumLatitude < 0) and
     (NumLongitude < 0) and
     (QtdAreaConv < 0) and
     (NomPessoaContato = '') and
     (NumTelefone = '') and
     (NumFax = '') and
     (DtaInicioCertificacao = 0) and
     (TxtObservacao = '') then begin
    Mensagens.Adicionar(215, Self.ClassName, 'Alterar', []);
    Result := -215;
    Exit;
  End;

  // Trata nome da propriedade rural
  Result := VerificaString(NomPropriedadeRural, 'Nome da propriedade rural');
  if Result < 0 then begin
    Exit;
  End;
  Result := TrataString(NomPropriedadeRural, 50, 'Nome da propriedade rural');
  if Result < 0 then begin
    Exit;
  End;

  // Trata NIRF
  if Trim(NumImovelReceitaFederal) <> '' then begin   // Nirf não é mais obrigatório no novo SISBOV
    if not ValidaNirfIncra(CodTipoInscricao, NumImovelReceitaFederal, true) then begin
      Mensagens.Adicionar(494, Self.ClassName, 'Alterar', [NumImovelReceitaFederal]);
      Result := -494;
      Exit;
    End;
  End;

  if (OrientLa = '') then
  begin
    Mensagens.Adicionar(2274, Self.ClassName, 'Alterar', []);
    Result := -2274;
    Exit;
  end;

  // Trata longitude e orientação da propriedade
  if (OrientLo = '') then
  begin
    Mensagens.Adicionar(2275, Self.ClassName, 'Alterar', []);
    Result := -2275;
    Exit;
  end;

{
  // Trata latitude e orientação da propriedade
  if (NumLatitude = 0) or (OrientLa = '') then
  begin
    Mensagens.Adicionar(2274, Self.ClassName, 'Alterar', []);
    Result := -2274;
    Exit;
  end;

  // Trata longitude e orientação da propriedade
  if (NumLongitude = 0) or (OrientLo = '') then
  begin
    Mensagens.Adicionar(2275, Self.ClassName, 'Alterar', []);
    Result := -2275;
    Exit;
  end;
}

  // Trata área da Propriedade Rural
  if QtdAreaConv <= 0 then begin
    Mensagens.Adicionar(495, Self.ClassName, 'Alterar', []);
    Result := -495;
    Exit;
  End;

  // Trata tipo da propriedade rural
  if TipoPro <= 0 then
  begin
    Mensagens.Adicionar(2282, Self.ClassName, 'Alterar', []);
    Result := -2282;
    Exit;
  end;

  // Trata área da Propriedade Rural
  if QtdAreaConv > 99999999.99 then begin
    Mensagens.Adicionar(502, Self.ClassName, 'Alterar', []);
    Result := -502;
    Exit;
  End;

  // Trata Pessoa de contato
  Result := TrataString(NomPessoaContato, 50, 'Pessoa para contato');
  if Result < 0 then begin
    Exit;
  End;

  // Trata Telefone
  Result := TrataString(NumTelefone, 15, 'Número do telefone');
  if Result < 0 then begin
    Exit;
  End;

  // Trata Fax
  Result := TrataString(NumFax, 15, 'Número do fax');
  if Result < 0 then begin
    Exit;
  End;

  // Trata Observação
  Result := TrataString(TxtObservacao, 255, 'Observação');
  if Result < 0 then begin
    Exit;
  End;

  Q  := THerdomQuery.Create(Conexao, nil);
  Q1 := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    Try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Alterar propriedade rural');

      if Conectado then begin
        // Verifica existência do registro
        Q.SQL.Clear;
  {$ifDEF MSSQL}
        Q.SQL.Text :=
          'select '+
          '  num_imovel_receita_federal '+
          '  , dta_inicio_certificacao '+
          '  , ind_efetivado_uma_vez '+
          'from '+
          '  tab_propriedade_rural '+
          'where '+
          '  cod_propriedade_rural = :cod_propriedade_rural '+
          '  and dta_fim_validade is null ';
  {$ENDif}
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(327, Self.ClassName, 'Alterar', []);
          Result := -327;
          Exit;
        End;

        // Verifica se a data de início da certificação pode ser alterada
        if (Q.FieldByName('ind_efetivado_uma_vez').AsString = 'S') and (Q.FieldByName('dta_inicio_certificacao').AsDateTime <> DtaInicioCertificacao) then begin
          Mensagens.Adicionar(1379, Self.ClassName, 'Alterar', []);
          Result := -1379;
          Exit;
        End;

  { Devido as alterações no Sisbov serem realizadas on-line via WebService, os
  testes abaixo para o NIRF foram retirados.
        // Verifica se o número do imóvel pode ser alterado
        if (Q.FieldByName('ind_efetivado_uma_vez').AsString = 'S') and
           (Q.FieldByName('num_imovel_receita_federal').AsString <> NumImovelReceitaFederal) then begin
          Mensagens.Adicionar(1380, Self.ClassName, 'Alterar', []);
          Result := -1380;
          Exit;
        End;

        if NumImovelReceitaFederal <> Q.FieldByName('num_imovel_receita_federal').AsString then begin
          Result := VerificaUtilizacaoAnimal(CodPropriedadeRural);
          if Result < 0 then begin
            Exit;
          End;
        End;
  }
  // Removido 17/01/2005 - O SISBOV não exige que o nome da propriedade seja único!
  {      // Verifica duplicidade de nome
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_propriedade_rural ');
        Q.SQL.Add(' where nom_propriedade_rural = :nom_propriedade_rural ');
        Q.SQL.Add('   and cod_propriedade_rural != :cod_propriedade_rural ');
        Q.SQL.Add('   and dta_fim_validade is null ');
        Q.ParamByName('nom_propriedade_rural').AsString := NomPropriedadeRural;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(498, Self.ClassName, 'Alterar', [NomPropriedadeRural]);
          Result := -498;
          Exit;
        End;
        Q.Close;
  }

  //Removido - 17/01/2005 Veja justificativa para o mesmo tratamento do campo NumImovelReceitaFederal no método INSERIR

  {      // Verifica duplicidade de NIRF
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_propriedade_rural ');
        Q.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal ');
        Q.SQL.Add('   and cod_propriedade_rural != :cod_propriedade_rural ');
        Q.SQL.Add('   and dta_fim_validade is null ');
        Q.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(499, Self.ClassName, 'Alterar', [NumImovelReceitaFederal]);
          Result := -499;
          Exit;
        End;
        Q.Close;
  }

        // Realiza alteração dos dados no Sisbov

        Q.Close;
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('  select ');
        Q.SQL.Add('        tpr.nom_propriedade_rural ');
        Q.SQL.Add('      , tti.cod_tipo_inscricao_sisbov ');
        Q.SQL.Add('      , tpr.num_imovel_receita_federal ');
        Q.SQL.Add('      , tf.des_acesso_fazenda ');
        Q.SQL.Add('      , tf.qtd_distancia_municipio ');
        Q.SQL.Add('      , tpr.cod_orientacao_latitude ');
        Q.SQL.Add('      , tpr.num_latitude ');
        Q.SQL.Add('      , tpr.cod_orientacao_longitude ');
        Q.SQL.Add('      , tpr.num_longitude ');
        Q.SQL.Add('      , tpr.qtd_area ');
        Q.SQL.Add('      , tpr.nom_pessoa_contato ');
        Q.SQL.Add('      , tpr.num_telefone ');
        Q.SQL.Add('      , tpr.num_fax ');
        Q.SQL.Add('      , tpr.nom_logradouro ');
        Q.SQL.Add('      , tpr.nom_bairro ');
        Q.SQL.Add('      , tpr.num_cep ');
        Q.SQL.Add('      , tm.num_municipio_ibge ');
        Q.SQL.Add('      , te.sgl_estado ');
        Q.SQL.Add('      , tpr.nom_logradouro_correspondencia ');
        Q.SQL.Add('      , tpr.nom_bairro_correspondencia ');
        Q.SQL.Add('      , tpr.num_cep_correspondencia ');
        Q.SQL.Add('      , tmc.num_municipio_ibge as num_ibge_correspondencia ');
        Q.SQL.Add('      , tec.sgl_estado as sgl_estado_correspondencia ');
        Q.SQL.Add('      , tpr.cod_tipo_propriedade_rural ');
        Q.SQL.Add('      , tpr.ind_transmissao_sisbov ');
        Q.SQL.Add('      , tpr.cod_id_propriedade_sisbov ');
        Q.SQL.Add('  from ');
        Q.SQL.Add('      tab_fazenda tf ');
        Q.SQL.Add('    , tab_estado tec ');
        Q.SQL.Add('    , tab_municipio tmc ');
        Q.SQL.Add('    , tab_estado te ');
        Q.SQL.Add('    , tab_municipio tm ');
        Q.SQL.Add('    , tab_tipo_inscricao tti ');
        Q.SQL.Add('    , tab_propriedade_rural tpr ');
        Q.SQL.Add('    , tab_localizacao_sisbov tls ');
        Q.SQL.Add('  where ');
        Q.SQL.Add('      tpr.cod_propriedade_rural          =  :cod_propriedade_rural ');
        Q.SQL.Add('  and tpr.cod_propriedade_rural          = tls.cod_propriedade_rural ');
        Q.SQL.Add('  and tpr.ind_transmissao_sisbov         = ''S'' ');
        Q.SQL.Add('  and tls.cod_propriedade_rural          = tf.cod_propriedade_rural ');
        Q.SQL.Add('  and tls.cod_pessoa_produtor            = tf.cod_pessoa_produtor ');
        Q.SQL.Add('  and tf.des_acesso_fazenda is not null ');
        Q.SQL.Add('  and tpr.cod_estado_correspondencia    *= tec.cod_estado ');
        Q.SQL.Add('  and tpr.cod_municipio_correspondencia *= tmc.cod_municipio ');
        Q.SQL.Add('  and tpr.cod_estado                     = te.cod_estado ');
        Q.SQL.Add('  and tpr.cod_municipio                  = tm.cod_municipio ');
        Q.SQL.Add('  and tpr.cod_tipo_inscricao            *= tti.cod_tipo_inscricao ');
  {$ENDIF}
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Q.Open;

        // Calculando Data de Quarentena
        if (Q.FieldByName('nom_propriedade_rural').AsString <> NomPropriedadeRural)
        or (Q.FieldByName('num_imovel_receita_federal').AsString <> NumImovelReceitaFederal) then begin
          DataQuarentena := Date + 40;
        end;

        if (Q.IsEmpty) and (Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) then begin
          Mensagens.Adicionar(327, Self.ClassName, 'Alterar', []);
          Result := -327;
          Exit;
        End;

        if Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0 then begin
          if NumTelefone = '' then begin
            TelefoneContato  := '';//'Não tem';
          end else begin
            TelefoneContato  := NumTelefone;
          end;

          if NumFax = '' then begin
            FaxContato  := '';//'Não tem';
          end else begin
            FaxContato  := NumFax;
          end;

          if length(NumImovelReceitaFederal) = 13 then begin
            SNirf  := '';
            SIncra :=  NumImovelReceitaFederal;
          end else begin
            SNirf  := NumImovelReceitaFederal;
            SIncra := '';
          end;

          if Length(OrientLa) = 0 then begin
            CodOrientLatitude := 'S';
          end else begin
            CodOrientLatitude := OrientLa;
          end;

          if Length(IntToStr(NumLatitude)) = 7 then begin
            SGLatitude := StrToInt(Copy(IntToStr(NumLatitude),1,3));
            SMLatitude := StrToInt(Copy(IntToStr(NumLatitude),4,2));
            SSLatitude := StrToInt(Copy(IntToStr(NumLatitude),6,2));
          end else if Length(IntToStr(NumLatitude)) = 6 then begin
            SGLatitude := StrToInt(Copy(IntToStr(NumLatitude),1,2));
            SMLatitude := StrToInt(Copy(IntToStr(NumLatitude),3,2));
            SSLatitude := StrToInt(Copy(IntToStr(NumLatitude),5,2));
          end else if Length(IntToStr(NumLatitude)) = 5 then begin
            SGLatitude := StrToInt(Copy(IntToStr(NumLatitude),1,1));
            SMLatitude := StrToInt(Copy(IntToStr(NumLatitude),2,2));
            SSLatitude := StrToInt(Copy(IntToStr(NumLatitude),4,2));
          end else begin
            SGLatitude := 0;
            SMLatitude := 0;
            SSLatitude := 0;
          end;

          if Length(OrientLo) = 0 then begin
            CodOrientLongitude := 'W';
          end else begin
            CodOrientLongitude := OrientLo;
          end;

          if Length(IntToStr(NumLongitude)) = 7 then begin
            SGLongitude := StrToInt(Copy(IntToStr(NumLongitude),1,3));
            SMLongitude := StrToInt(Copy(IntToStr(NumLongitude),4,2));
            SSLongitude := StrToInt(Copy(IntToStr(NumLongitude),6,2));
          end else if Length(IntToStr(NumLongitude)) = 6 then begin
            SGLongitude := StrToInt(Copy(IntToStr(NumLongitude),1,2));
            SMLongitude := StrToInt(Copy(IntToStr(NumLongitude),3,2));
            SSLongitude := StrToInt(Copy(IntToStr(NumLongitude),5,2));
          end else if Length(IntToStr(NumLongitude)) = 5 then begin
            SGLongitude := StrToInt(Copy(IntToStr(NumLongitude),1,1));
            SMLongitude := StrToInt(Copy(IntToStr(NumLongitude),2,2));
            SSLongitude := StrToInt(Copy(IntToStr(NumLongitude),4,2));
          end else begin
            SGLongitude := 0;
            SMLongitude := 0;
            SSLongitude := 0;
          end;

//          AreaProriedade        := trunc(QtdAreaConv*100);
          AreaProriedade        := StrToInt(ConverteValorFlutuanteParaString(QtdAreaConv));
          QtdDistanciaMunicipio := trunc(Q.FieldByName('qtd_distancia_municipio').AsInteger*100);

          try
            RetornoAPropriedade := SoapSisbov.alterarPropriedade(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q.FieldByName('cod_id_propriedade_sisbov').AsInteger
                                 , SNirf
                                 , SIncra
                                 , TipoPro
                                 , NomPropriedadeRural
                                 , Q.FieldByName('des_acesso_fazenda').AsString
                                 , QtdDistanciaMunicipio
                                 , CodOrientLatitude
                                 , SGLatitude
                                 , SMLatitude
                                 , SSLatitude
                                 , CodOrientLongitude
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

            If RetornoAPropriedade <> nil then begin
              If RetornoAPropriedade.Status = 0 then begin
                Mensagens.Adicionar(2304, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoAPropriedade)]);
                Result := -2304;
                Exit;
              end else begin
                BeginTran;

                // Atualiza na tabela tab_propriedade_rural o ID da transação de alteração
                // dos dados da propriedade.
                Q1.SQL.Clear;
                {$IFDEF MSSQL}
                     Q1.SQL.Add('update tab_propriedade_rural ' +
                               '   set cod_id_transacao_sisbov = :cod_idtransacao ' +
                               ' where cod_propriedade_rural   = :cod_propriedade_rural ');
                {$ENDIF}
                Q1.ParamByName('cod_idtransacao').AsInteger        := RetornoAPropriedade.idTransacao;
                Q1.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
                Q1.ExecSQL;

                Commit;
              end;
            end else begin
              Mensagens.Adicionar(2304, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
              Result := -2304;
              Exit;
            end;
          except
            on E: Exception do
            begin
              Mensagens.Adicionar(2304, Self.ClassName, 'Alterar', [E.Message]);
              Result := -2304;
              Exit;
            end;
          end;
        end;
      end;

      if (Q.FieldByName('cod_id_propriedade_sisbov').AsInteger = 0) or
         ((Q.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) and (Conectado))  then begin
        // Abre transação
        BeginTran;

        // Tenta Alterar Registro
        Q.SQL.Clear;
  {$ifDEF MSSQL}
        Q.SQL.Add('update tab_propriedade_rural ');
        Q.SQL.Add('   set ');
        Q.SQL.Add('   nom_propriedade_rural = :nom_propriedade_rural,');
        Q.SQL.Add('   cod_tipo_propriedade_rural = :cod_tipo_propriedade,');
        Q.SQL.Add('   num_imovel_receita_federal = :num_imovel_receita_federal,');
        Q.SQL.Add('   cod_tipo_inscricao = :cod_tipo_inscricao,');
        Q.SQL.Add('   cod_orientacao_latitude = :cod_orientacao_latitude,');
        Q.SQL.Add('   num_latitude = :num_latitude,');
        Q.SQL.Add('   cod_orientacao_longitude = :cod_orientacao_longitude,');
        Q.SQL.Add('   num_longitude = :num_longitude,');
        Q.SQL.Add('   qtd_area = :qtd_area,');
        Q.SQL.Add('   nom_pessoa_contato = :nom_pessoa_contato,');
        Q.SQL.Add('   num_telefone = :num_telefone,');
        Q.SQL.Add('   num_fax = :num_fax,');
        Q.SQL.Add('   dta_inicio_certificacao = :dta_inicio_certificacao,');
        Q.SQL.Add('   txt_observacao = :txt_observacao');
        if (DataQuarentena > 0) then
          Q.SQL.Add('   ,dta_quarentena = :dta_quarentena ');
        Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
  {$ENDif}
        Q.ParamByName('nom_propriedade_rural').AsString      := NomPropriedadeRural;
        Q.ParamByName('cod_tipo_propriedade').AsInteger      := TipoPro;
        if Trim(NumImovelReceitaFederal) <> '' then begin   // Nirf não é mais obrigatório no novo SISBOV
          Q.ParamByName('num_imovel_receita_federal').AsString      := NumImovelReceitaFederal;
          Q.ParamByName('cod_tipo_inscricao').AsInteger := CodTipoInscricao;
        end else begin
          Q.ParamByName('cod_tipo_inscricao').DataType := ftInteger;
          Q.ParamByName('cod_tipo_inscricao').Clear;
          Q.ParamByName('num_imovel_receita_federal').DataType := ftString;
          Q.ParamByName('num_imovel_receita_federal').Clear;
        end;
        Q.ParamByName('cod_orientacao_latitude').AsString  := OrientLa;
        Q.ParamByName('num_latitude').AsInteger  := NumLatitude;
        Q.ParamByName('cod_orientacao_longitude').AsString  := OrientLo;
        Q.ParamByName('num_longitude').AsInteger  := NumLongitude;
        Q.ParamByName('qtd_area').AsFloat  := QtdAreaConv;
        Q.ParamByName('nom_pessoa_contato').AsString      := NomPessoaContato;
        Q.ParamByName('num_telefone').AsString      := NumTelefone;
        Q.ParamByName('num_fax').AsString      := NumFax;
        Q.ParamByName('dta_inicio_certificacao').AsDateTime  := Trunc(DtaInicioCertificacao);
        Q.ParamByName('txt_observacao').AsString      := TxtObservacao;
        Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        if (Q.Params.FindParam('dta_quarentena') <> nil) then
          Q.ParamByName('dta_quarentena').AsDateTime := DataQuarentena;
        Q.ExecSQL;

        // Cofirma transação
        Commit;
      end;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(508, Self.ClassName, 'Alterar', [E.Message]);
        Result := -508;
        Exit;
      End;
    End;
  Finally
    SoapSisbov.Free;
    Q.Free;
    Q1.Free;
  End;
end;

function TIntPropriedadesRurais.EfetivarCadastro(
  CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(187) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'EfetivarCadastro', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro já está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1, CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'EfetivarCadastro', []);
    Result := -507;
    Exit;
  End;

  // Verifica se municípios da propriedade estão efetivados
  Result := VerificaMunicipioEfetivado(CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Abre transação
      BeginTran;

      // Verifica se dados obrigatórios já estão definidos
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select cod_pais, ');
      Q.SQL.Add('       cod_estado, ');
      Q.SQL.Add('       cod_municipio, ');
      Q.SQL.Add('       cod_municipio_correspondencia, ');
      Q.SQL.Add('       cod_orientacao_latitude, ');
      Q.SQL.Add('       num_latitude, ');
      Q.SQL.Add('       cod_orientacao_longitude, ');
      Q.SQL.Add('       num_longitude, ');
      Q.SQL.Add('       cod_pessoa_proprietario ');
      Q.SQL.Add('  from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if (Q.FieldByName('cod_pais').IsNull) or
         (Q.FieldByName('cod_estado').IsNull) or
         (Q.FieldByName('cod_orientacao_latitude').IsNull) or
         (Q.FieldByName('num_latitude').IsNull) or
         (Q.FieldByName('cod_orientacao_longitude').IsNull) or
         (Q.FieldByName('num_longitude').IsNull) or
         (Q.FieldByName('cod_pessoa_proprietario').IsNull) or
         (Q.FieldByName('cod_municipio_correspondencia').IsNull) or
         (Q.FieldByName('cod_municipio').IsNull) then begin
        Rollback;
        Mensagens.Adicionar(535, Self.ClassName, 'EfetivarCadastro', []);
        Result := -535;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   dta_efetivacao_cadastro = getdate()');
      Q.SQL.Add('   , ind_efetivado_uma_vez = ''S'' ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      Result := AtualizaGrandeza(11, -1, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;

      Result := AtualizaGrandeza(12, -1, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;
*)

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(509, Self.ClassName, 'EfetivarCadastro', [E.Message]);
        Result := -509;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.CancelarEfetivacao(
  CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('CancelarEfetivacao');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(188) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro já está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1, CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 0 then begin
    Mensagens.Adicionar(510, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -510;
    Exit;
  End;

  // Verifica utilização na tab_fazenda para fazendas efetivadas
  Result := VerificaUtilizacaoFazenda(CodPropriedadeRural, True);
  if Result < 0 then begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   dta_efetivacao_cadastro = null');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      Result := AtualizaGrandeza(11, -1, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;

      Result := AtualizaGrandeza(12, -1, 1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;
*)

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(511, Self.ClassName, 'CancelarEfetivacao', [E.Message]);
        Result := -511;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.DefinirEndereco(
  CodPropriedadeRural: Integer; NomLogradouro, NomBairro, NumCEP: String;
  CodPais, CodEstado, CodMunicipio, CodDistrito: Integer): Integer;
var
  Q : THerdomQuery;
  CodDis, CodMun, CodEst, CodPai : Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('DefinirEndereco');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(118) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirEndereco', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'DefinirEndereco', []);
    Result := -507;
    Exit;
  End;

  // Verifica se pelo menos um parâmetro foi informado
  if (NomLogradouro = '') and
     (NomBairro = '') and
     (NumCEP = '') and
     (CodPais <= 0) and
     (CodEstado <= 0) and
     (CodMunicipio <= 0) and
     (CodDistrito <= 0) then begin
    Mensagens.Adicionar(215, Self.ClassName, 'DefinirEndereco', []);
    Result := -215;
    Exit;
  End;

  // Trata Logradouro
  if NomLogradouro <> '' then begin
    Result := TrataString(NomLogradouro, 100, 'Logradouro da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEndereco', []);
      Result := -520;
      Exit;
    End;
  End;

  // Trata Bairro
  if NomBairro <> '' then begin
    Result := TrataString(NomBairro, 50, 'Bairro da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEndereco', []);
      Result := -520;
      Exit;
    End;
  End;

  // Trata CEP
  if NumCEP <> '' then begin
    Result := TrataString(NumCEP, 8, 'CEP da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;

    if not ehNumerico(NumCEP) then
    begin
      Mensagens.Adicionar(1845, Self.ClassName, 'DefinirEndereco', []);
      Result := -1845;
      Exit;
    end;

    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEndereco', []);
      Result := -520;
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      (*Bloco de código comentado (18/11/2004). Caso a propriedade já tenha sido
        identificada e exportada, o endereço poderá ser alterado se a exportação
        e identificação for cancelada.
      // Verifica existência do registro
      Q.SQL.Clear;
      Q.SQL.Text :=
      {$ifDEF MSSQL}
        'select '+
        '  cod_pais '+
        '  , cod_estado '+
        '  , cod_municipio '+
        '  , cod_distrito '+
        '  , ind_efetivado_uma_vez '+
        'from '+
        '  tab_propriedade_rural '+
        'where '+
        '  cod_propriedade_rural = :cod_propriedade_rural '+
        '  and dta_fim_validade is null ';
      {$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'DefinirProprietario', []);
        Result := -327;
        Exit;
      End;
      IndEfetivadoUmaVez := Q.FieldByName('ind_efetivado_uma_vez').AsString;
      if Q.FieldByName('cod_pais').IsNull then begin
        CodPaiAnt := -1;
      End Else Begin
        CodPaiAnt := Q.FieldByName('cod_pais').AsInteger;
      End;
      if Q.FieldByName('cod_estado').IsNull then begin
        CodEstAnt := -1;
      End Else Begin
        CodEstAnt := Q.FieldByName('cod_estado').AsInteger;
      End;
      if Q.FieldByName('cod_municipio').IsNull then begin
        CodMunAnt := -1;
      End Else Begin
        CodMunAnt := Q.FieldByName('cod_municipio').AsInteger;
      End;
      if Q.FieldByName('cod_distrito').IsNull then begin
        CodDisAnt := -1;
      End Else Begin
        CodDisAnt := Q.FieldByName('cod_distrito').AsInteger;
      End;
      Q.Close;
      *)

      CodDis := -1;
      CodMun := -1;
      CodEst := -1;
      CodPai := -1;

      // Consiste o distrito
      if CodDistrito > 0 then begin
        Q.SQL.Clear;
{$ifDEF MSSQL}
        Q.SQL.Add('select td.cod_municipio, ');
        Q.SQL.Add('       tm.cod_estado, ');
        Q.SQL.Add('       te.cod_pais ');
        Q.SQL.Add('  from tab_distrito td, ');
        Q.SQL.Add('       tab_municipio tm, ');
        Q.SQL.Add('       tab_estado te ');
        Q.SQL.Add(' where tm.cod_municipio = td.cod_municipio ');
        Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
        Q.SQL.Add('   and td.cod_distrito = :cod_distrito ');
        Q.SQL.Add('   and td.dta_fim_validade is null ');
{$ENDif}
        Q.ParamByName('cod_distrito').AsInteger := CodDistrito;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(397, Self.ClassName, 'DefinirEndereco', []);
          Result := -397;
          Exit;
        End;
        CodDis := CodDistrito;
        CodMun := Q.FieldByName('cod_municipio').AsInteger;
        CodEst := Q.FieldByName('cod_estado').AsInteger;
        CodPai := Q.FieldByName('cod_pais').AsInteger;

        if CodMunicipio > 0 then begin
          if CodMunicipio <> CodMun then begin
            Mensagens.Adicionar(398, Self.ClassName, 'DefinirEndereco', []);
            Result := -398;
            Exit;
          End;
        End;

        if CodEstado > 0 then begin
          if CodEstado <> CodEst then begin
            Mensagens.Adicionar(400, Self.ClassName, 'DefinirEndereco', []);
            Result := -400;
            Exit;
          End;
        End;

        if CodPais > 0 then begin
          if CodPais <> CodPai then begin
            Mensagens.Adicionar(401, Self.ClassName, 'DefinirEndereco', []);
            Result := -401;
            Exit;
          End;
        End;

        Q.Close;
      End Else Begin
        // Consiste o município
        if CodMunicipio > 0 then begin
          Q.SQL.Clear;
  {$ifDEF MSSQL}
          Q.SQL.Add('select tm.cod_estado, ');
          Q.SQL.Add('       te.cod_pais ');
          Q.SQL.Add('  from tab_municipio tm, ');
          Q.SQL.Add('       tab_estado te ');
          Q.SQL.Add(' where tm.cod_municipio = :cod_municipio ');
          Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
          Q.SQL.Add('   and tm.dta_fim_validade is null ');
  {$ENDif}
          Q.ParamByName('cod_municipio').AsInteger := CodMunicipio;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(399, Self.ClassName, 'DefinirEndereco', []);
            Result := -399;
            Exit;
          End;
          CodMun := CodMunicipio;
          CodEst := Q.FieldByName('cod_estado').AsInteger;
          CodPai := Q.FieldByName('cod_pais').AsInteger;

          if CodEstado > 0 then begin
            if CodEstado <> CodEst then begin
              Mensagens.Adicionar(400, Self.ClassName, 'DefinirEndereco', []);
              Result := -400;
              Exit;
            End;
          End;

          if CodPais > 0 then begin
            if CodPais <> CodPai then begin
              Mensagens.Adicionar(401, Self.ClassName, 'DefinirEndereco', []);
              Result := -401;
              Exit;
            End;
          End;

          Q.Close;
        End Else Begin
          // Consiste o estado
          if CodEstado > 0 then begin
            Q.SQL.Clear;
    {$ifDEF MSSQL}
            Q.SQL.Add('select te.cod_pais ');
            Q.SQL.Add('  from tab_estado te ');
            Q.SQL.Add(' where te.cod_estado = :cod_estado ');
            Q.SQL.Add('   and te.dta_fim_validade is null ');
    {$ENDif}
            Q.ParamByName('cod_estado').AsInteger := CodEstado;
            Q.Open;
            if Q.IsEmpty then begin
              Mensagens.Adicionar(387, Self.ClassName, 'DefinirEndereco', []);
              Result := -387;
              Exit;
            End;
            CodEst := CodEstado;
            CodPai := Q.FieldByName('cod_pais').AsInteger;

            if CodPais > 0 then begin
              if CodPais <> CodPai then begin
                Mensagens.Adicionar(401, Self.ClassName, 'DefinirEndereco', []);
                Result := -401;
                Exit;
              End;
            End;
            Q.Close;
          End Else Begin
            if CodPais > 0 then begin
              Q.SQL.Clear;
      {$ifDEF MSSQL}
              Q.SQL.Add('select cod_pais ');
              Q.SQL.Add('  from tab_pais ');
              Q.SQL.Add(' where cod_pais = :cod_pais ');
              Q.SQL.Add('   and dta_fim_validade is null ');
      {$ENDif}
              Q.ParamByName('cod_pais').AsInteger := CodPais;
              Q.Open;
              if Q.IsEmpty then begin
                Mensagens.Adicionar(402, Self.ClassName, 'DefinirEndereco', []);
                Result := -402;
                Exit;
              End;
              CodPai := CodPais;
              Q.Close;
            End;
          End;
        End;
      End;

      // Verifica se distrito, município, estado e país podem ser alterados
      (*Bloco de código comentado (18/11/2004). Caso a propriedade já tenha sido
        identificada e exportada, o endereço poderá ser alterado se a exportação
        e identificação for cancelada.
      if (IndEfetivadoUmaVez = 'S') then begin
        if (CodDisAnt <> CodDis) then begin
          Mensagens.Adicionar(1381, Self.ClassName, 'DefinirEndereco', ['Distrito']);
          Result := -1381;
          Exit;
        End;
        if (CodMunAnt <> CodMun) then begin
          Mensagens.Adicionar(1381, Self.ClassName, 'DefinirEndereco', ['Município']);
          Result := -1381;
          Exit;
        End;
        if (CodEstAnt <> CodEst) then begin
          Mensagens.Adicionar(1381, Self.ClassName, 'DefinirEndereco', ['Estado']);
          Result := -1381;
          Exit;
        End;
        if (CodPaiAnt <> CodPai) then begin
          Mensagens.Adicionar(1381, Self.ClassName, 'DefinirEndereco', ['País']);
          Result := -1381;
          Exit;
        End;
      End;
      *)

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   nom_logradouro = :nom_logradouro,');
      Q.SQL.Add('   nom_bairro = :nom_bairro,');
      Q.SQL.Add('   num_cep = :num_cep');
      //if IndEfetivadoUmaVez <> 'S' then begin
        Q.SQL.Add('   , cod_pais = :cod_pais ');
        Q.SQL.Add('   , cod_estado = :cod_estado ');
        Q.SQL.Add('   , cod_municipio = :cod_municipio ');
        Q.SQL.Add('   , cod_distrito = :cod_distrito ');
      //End;
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      if NomLogradouro <> '' then begin
        Q.ParamByName('nom_logradouro').AsString      := NomLogradouro;
      End Else Begin
        Q.ParamByName('nom_logradouro').DataType := ftString;
        Q.ParamByName('nom_logradouro').Clear
      End;
      if NomBairro <> '' then begin
        Q.ParamByName('nom_bairro').AsString      := NomBairro;
      End Else Begin
        Q.ParamByName('nom_bairro').DataType := ftString;
        Q.ParamByName('nom_bairro').Clear
      End;
      if NumCEP <> '' then begin
        Q.ParamByName('num_cep').AsString      := NumCEP;
      End Else Begin
        Q.ParamByName('num_cep').DataType := ftString;
        Q.ParamByName('num_cep').Clear
      End;
      //if IndEfetivadoUmaVez <> 'S' then begin
        if CodPai > 0 then begin
          Q.ParamByName('cod_pais').AsInteger     := CodPai;
        End Else Begin
          Q.ParamByName('cod_pais').DataType := ftInteger;
          Q.ParamByName('cod_pais').Clear
        End;
        if CodEst > 0 then begin
          Q.ParamByName('cod_estado').AsInteger     := CodEst;
        End Else Begin
          Q.ParamByName('cod_estado').DataType := ftInteger;
          Q.ParamByName('cod_estado').Clear
        End;
        if CodMun > 0 then begin
          Q.ParamByName('cod_municipio').AsInteger     := CodMun;
        End Else Begin
          Q.ParamByName('cod_municipio').DataType := ftInteger;
          Q.ParamByName('cod_municipio').Clear
        End;
        if CodDis > 0 then begin
          Q.ParamByName('cod_distrito').AsInteger     := CodDis;
        End Else Begin
          Q.ParamByName('cod_distrito').DataType := ftInteger;
          Q.ParamByName('cod_distrito').Clear
        End;
      //End;

      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(403, Self.ClassName, 'DefinirEndereco', [E.Message]);
        Result := -403;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.DefinirProprietario(CodPropriedadeRural, CodProdutor: Integer): Integer;
var
  Q : THerdomQuery;
  Q1 : THerdomQuery;
  Q2 : THerdomQuery;
  Q3 : THerdomQuery;
  Q4 : THerdomQuery;

  TelefoneContato: String;
  CPFPessoa: String;
  NomMetodo, CNPJPessoa: String;

  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoIProprietario: RetornoIncluirProprietario;
  RetornoVProprietarioPropriedade : RetornoVincularProprietarioPropriedade;
  RetornoDPropriedadeProprietario : RetornoDesvincularProprietarioPropriedade;

begin
  NomMetodo := 'DefinirProprietario';
  RetornoDPropriedadeProprietario := nil;
  RetornoVProprietarioPropriedade := nil;

  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('DefinirProprietario');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(118) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirProprietario', []);
    Result := -188;
    Exit;
  End;

  SoapSisbov := TIntSoapSisbov.Create;
  Q := THerdomQuery.Create(Conexao, nil);
  Q1 := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  Q3 := THerdomQuery.Create(Conexao, nil);
  Q4 := THerdomQuery.Create(Conexao, nil);

  Try
    Try

      SoapSisbov.Inicializar(Conexao, Mensagens);

      //Verifica se cod_propriedade_rural > 0
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
                 '  tpr.ind_transmissao_sisbov, ' +
                 '  tpl.cod_id_propriedade_sisbov ' +
                 'From tab_pessoa tpe ' +
                 '     ,tab_produtor tpr ' +
                 '     ,tab_municipio tm ' +
                 '     ,tab_estado te ' +
                 '     ,tab_tipo_endereco tte ' +
                 '     ,tab_propriedade_rural tpl ' +
                 'Where tpe.cod_pessoa    = :cod_pessoa ' +
                 '  and tpe.cod_pessoa    = tpr.cod_pessoa_produtor ' +
                 '  and tpe.cod_municipio *= tm.cod_municipio ' +
                 '  and tpe.cod_estado    *= te.cod_estado ' +
                 '  and tpe.cod_tipo_endereco = tte.cod_tipo_endereco ' +
                 '  and tpr.ind_efetivado_uma_vez = ''S'' ' +
                 '  and tpl.cod_propriedade_rural    = :cod_propriedade_rural ' +
                 '  and tpr.dta_fim_validade is null ');
      {$ENDIF}

      Q1.ParamByName('cod_pessoa').AsInteger    := CodProdutor;
      Q1.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q1.Open;


      // Busca se cod_id_propriedade_sisbov e dados do produtor atual

      Q2.SQL.Clear;
      {$IFDEF MSSQL}
      Q2.SQL.Add(          'Select ' +
                           '  tpl.ind_trans_sisbov_proprietario ' +
                           'From  ' +
                           '  tab_propriedade_rural tpl ' +
                           'Where  ' +
                           ' tpl.cod_pessoa_proprietario  = :CodProdutor ' +
                           ' and tpl.ind_trans_sisbov_proprietario  = :ind_trans_sisbov_proprietario '
                           );
      {$ENDIF}

      Q2.ParamByName('CodProdutor').AsInteger := CodProdutor;
      Q2.ParamByName('ind_trans_sisbov_proprietario').AsString := 'S';
      Q2.Open;


      Q4.SQL.Clear;
      {$IFDEF MSSQL}
      Q4.SQL.Add('Select ' +
                           ' tpl.cod_pessoa_proprietario, ' +
                           ' tpl.ind_trans_sisbov_proprietario, ' +
                           ' tpl.cod_pessoa_proprietario, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''J'' then tpe.num_cnpj_cpf ' +
                           '    else '''' ' +
                           '  end as cnpj_pessoa, ' +
                           '  case tpe.cod_natureza_pessoa ' +
                           '    when ''F'' then tpe.num_cnpj_cpf ' +
                           '    else '''' ' +
                           '  end as cpf_pessoa ' +
                           'From  ' +
                           '  tab_propriedade_rural tpl ' +
                           '  ,tab_pessoa tpe ' +
                           'Where  ' +
                           ' tpe.cod_pessoa = tpl.cod_pessoa_proprietario ' +
                           ' and tpl.cod_propriedade_rural  = :CodPropriedadeRural ');
              {$ENDIF}

      Q4.ParamByName('CodPropriedadeRural').AsInteger := CodPropriedadeRural;
      Q4.Open;

      if (Q4.FieldByName('cod_pessoa_proprietario').AsInteger = CodProdutor) then begin
        Mensagens.Adicionar(2365, Self.ClassName, 'DefinirProprietario', ['']);
        Result := -2365;
        Exit;
      End;

      if (Not Q1.Eof) and (Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger > 0) then Begin
        if (Q2.Eof) then Begin
          if Not Inicializado then begin
            RaiseNaoInicializado('DefinirProprietario');
            Exit;
          End;
	        if Not Conexao.PodeExecutarMetodo(186) then begin
            Mensagens.Adicionar(188, Self.ClassName, 'DefinirProprietario', []);
            Result := -188;
            Exit;
          End;

          Conectado := SoapSisbov.conectado('DefinirProprietario');

          if Conectado then begin
            RetornoIProprietario := nil;

            if Q1.FieldByName('telefone_contato').AsString = '' then begin
              TelefoneContato := '';//'Não tem';
            end else begin
              TelefoneContato := Q1.FieldByName('telefone_contato').AsString;
            end;

            try
              RetornoIProprietario := SoapSisbov.incluirProprietario(
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
                                 , Q1.FieldByName('num_municipio_ibge').AsString
                                 );
            except
              on E: Exception do
              begin
                Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoIProprietario)]);
                Result := -404;
              end;
            end;

            If RetornoIProprietario <> nil then begin
              If RetornoIProprietario.Status = 0 then begin
                if (RetornoIProprietario.listaErros[0].codigoErro <> '3.019') then begin
                  Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoIProprietario)]);
                end;
              end;
            end else begin
              Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
            end;
          end;
        end;

        If Trim(Q1.FieldByName('cpf_pessoa').AsString) = '' then begin
          CPFPessoa  := '';
          CNPJPessoa := Q1.FieldByName('cnpj_pessoa').AsString;
        end
        else begin
          CPFPessoa  := Q1.FieldByName('cpf_pessoa').AsString;
          CNPJPessoa := '';
        end;

        try
          RetornoVProprietarioPropriedade := SoapSisbov.vincularProprietarioPropriedade(
                                 Descriptografar(ValorParametro(118))
                               , Descriptografar(ValorParametro(119))
                               , Q1.FieldByName('cpf_pessoa').AsString
                               , Q1.FieldByName('cnpj_pessoa').AsString
                               , Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger
                               , 1);
        except
          on E: Exception do
          begin
            Mensagens.Adicionar(404, Self.ClassName, NomMetodo, ['']);
            Result := -404;
          end;
        end;

        // Tenta Alterar Registro
        Q3.SQL.Clear;
        {$ifDEF MSSQL}
        Q3.SQL.Add('update tab_propriedade_rural ');
        Q3.SQL.Add('   set ');

        If RetornoVProprietarioPropriedade <> nil then begin
          If RetornoVProprietarioPropriedade.Status = 0 then begin
            if RetornoVProprietarioPropriedade.erroBanco <> 'ORA-00001: restrição exclusiva (SISBOV.PROPRIEDADE_PROPRIETARIO_UK) violada' then begin
              Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoVProprietarioPropriedade)]);
              exit;
            end else begin
              Q3.SQL.Add('   ind_trans_relac_propriet_prop = :ind_trans_relac_propriet_prop ');
              Q3.ParamByName('ind_trans_relac_propriet_prop').AsString := 'S';
            end;
          End Else begin
            Q3.SQL.Add('   ind_trans_relac_propriet_prop = :ind_trans_relac_propriet_prop ');
            Q3.ParamByName('ind_trans_relac_propriet_prop').AsString := 'S';
          end;

          Q3.SQL.Add('   , cod_id_trans_relac_prop = :cod_id_trans_relac_prop ');
          Q3.SQL.Add(' where cod_propriedade_rural = :CodPropriedadeRural ');
          {$ENDif}

          // Abre transação
          BeginTran;

          Q3.ParamByName('cod_id_trans_relac_prop').AsInteger := RetornoVProprietarioPropriedade.idTransacao;
          Q3.ParamByName('CodPropriedadeRural').AsInteger := CodPropriedadeRural;
          Q3.ExecSQL;

          // Cofirma transação
          Commit;

          if (Not Q4.Eof) and (Q4.FieldByName('ind_trans_sisbov_proprietario').AsString = 'S') and
             (RetornoVProprietarioPropriedade.Status = 1) then begin
            try
              RetornoDPropriedadeProprietario := SoapSisbov.desvincularPropriedadeProprietario(
                                   Descriptografar(ValorParametro(118))
                                 , Descriptografar(ValorParametro(119))
                                 , Q4.FieldByName('cpf_pessoa').AsString
                                 , Q4.FieldByName('cnpj_pessoa').AsString
                                 , Q1.FieldByName('cod_id_propriedade_sisbov').AsInteger
                                 );
            except
              on E: Exception do
              begin
                Mensagens.Adicionar(404, Self.ClassName, NomMetodo, ['']);
              end;
            end;

            If RetornoDPropriedadeProprietario <> nil then begin
              If RetornoDPropriedadeProprietario.Status = 0 then begin
                Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoDPropriedadeProprietario)]);
                exit
              End;
            end else begin
              Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
              exit
            end;
          End
          else begin
            Mensagens.Adicionar(2364, Self.ClassName, 'DefinirProprietario', ['']);
            Result := -2364;
            exit
          end;
        end else begin
          Mensagens.Adicionar(404, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
          exit;
        end;
        // Finaliza Condição que verifica se propriedade está efetivada
      End;

      // Verifica se cadastro está efetivado
      Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
      CodPropriedadeRural, True);
      if Result < 0 Then Exit;
        if Result = 1 then begin
          Mensagens.Adicionar(507, Self.ClassName, 'DefinirProprietario', []);
          Result := -507;
          Exit;
        End;

      // Verifica se pelo menos um parâmetro foi informado
      if (CodProdutor <= 0) then begin
        Mensagens.Adicionar(215, Self.ClassName, 'DefinirProprietario', []);
        Result := -215;
        Exit;
      End;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
      {$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   cod_pessoa_proprietario = :cod_pessoa_proprietario ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      {$ENDif}

      Q.ParamByName('cod_pessoa_proprietario').AsInteger := CodProdutor;
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;

  Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(404, Self.ClassName, 'DefinirProprietario', [E.Message]);
        Result := -404;
        Exit;
      End;
  End;
  Finally
  if SoapSisbov.Inicializado then begin
    SoapSisbov.Free;
  end;
  Q1.Free;
  Q2.Free;
  Q.Free;
  Q3.Free;
  Q4.Free;
  End;
End;


function TIntPropriedadesRurais.LimparEndereco(
  CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('LimparEndereco');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(120) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'LimparEndereco', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'LimparEndereco', []);
    Result := -507;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'LimparEndereco', []);
        Result := -327;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   nom_logradouro = null,');
      Q.SQL.Add('   nom_bairro = null,');
      Q.SQL.Add('   num_cep = null,');
      Q.SQL.Add('   cod_pais = null,');
      Q.SQL.Add('   cod_estado = null,');
      Q.SQL.Add('   cod_municipio = null,');
      Q.SQL.Add('   cod_distrito = null');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(406, Self.ClassName, 'LimparEndereco', [E.Message]);
        Result := -406;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.DefinirEnderecoCorrespondencia(
  CodPropriedadeRural: Integer; NomLogradouro, NomBairro, NumCEP: String;
  CodPais, CodEstado, CodMunicipio, CodDistrito: Integer): Integer;
var
  Q : THerdomQuery;
  CodDis, CodMun, CodEst, CodPai : Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('DefinirEnderecoCorrespondencia');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(190) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
    Result := -507;
    Exit;
  End;

  // Verifica se pelo menos um parâmetro foi informado
  if (NomLogradouro = '') and
     (NomBairro = '') and
     (NumCEP = '') and
     (CodPais <= 0) and
     (CodEstado <= 0) and
     (CodMunicipio <= 0) and
     (CodDistrito <= 0) then begin
    Mensagens.Adicionar(215, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
    Result := -215;
    Exit;
  End;

  // Trata Logradouro
  if NomLogradouro <> '' then begin
    Result := TrataString(NomLogradouro, 100, 'Logradouro de correspondência da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
      Result := -520;
      Exit;
    End;
  End;

  // Trata Bairro
  if NomBairro <> '' then begin
    Result := TrataString(NomBairro, 50, 'Bairro de correspondência da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
      Result := -520;
      Exit;
    End;
  End;

  // Trata CEP
  if NumCEP <> '' then begin
    Result := TrataString(NumCEP, 8, 'CEP de correspondência da propriedade rural');
    if Result < 0 then begin
      Exit;
    End;
    if not ehNumerico(NumCEP) then
    begin
      Mensagens.Adicionar(1845, Self.ClassName,
        'DefinirEnderecoCorrespondencia', []);
      Result := -1845;
      Exit;
    end;
    if (CodMunicipio <= 0) and (CodDistrito <=0) then begin
      Mensagens.Adicionar(520, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
      Result := -520;
      Exit;
    End;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      // Verifica existência do registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
        Result := -327;
        Exit;
      End;
      Q.Close;

      CodDis := -1;
      CodMun := -1;
      CodEst := -1;
      CodPai := -1;

      // Consiste o distrito
      if CodDistrito > 0 then begin
        Q.SQL.Clear;
{$ifDEF MSSQL}
        Q.SQL.Add('select td.cod_municipio, ');
        Q.SQL.Add('       tm.cod_estado, ');
        Q.SQL.Add('       te.cod_pais ');
        Q.SQL.Add('  from tab_distrito td, ');
        Q.SQL.Add('       tab_municipio tm, ');
        Q.SQL.Add('       tab_estado te ');
        Q.SQL.Add(' where tm.cod_municipio = td.cod_municipio ');
        Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
        Q.SQL.Add('   and td.cod_distrito = :cod_distrito ');
        Q.SQL.Add('   and td.dta_fim_validade is null ');
{$ENDif}
        Q.ParamByName('cod_distrito').AsInteger := CodDistrito;
        Q.Open;
        if Q.IsEmpty then begin
          Mensagens.Adicionar(397, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
          Result := -397;
          Exit;
        End;
        CodDis := CodDistrito;
        CodMun := Q.FieldByName('cod_municipio').AsInteger;
        CodEst := Q.FieldByName('cod_estado').AsInteger;
        CodPai := Q.FieldByName('cod_pais').AsInteger;

        if CodMunicipio > 0 then begin
          if CodMunicipio <> CodMun then begin
            Mensagens.Adicionar(398, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
            Result := -398;
            Exit;
          End;
        End;

        if CodEstado > 0 then begin
          if CodEstado <> CodEst then begin
            Mensagens.Adicionar(400, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
            Result := -400;
            Exit;
          End;
        End;

        if CodPais > 0 then begin
          if CodPais <> CodPai then begin
            Mensagens.Adicionar(401, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
            Result := -401;
            Exit;
          End;
        End;

        Q.Close;
      End Else Begin
        // Consiste o município
        if CodMunicipio > 0 then begin
          Q.SQL.Clear;
  {$ifDEF MSSQL}
          Q.SQL.Add('select tm.cod_estado, ');
          Q.SQL.Add('       te.cod_pais ');
          Q.SQL.Add('  from tab_municipio tm, ');
          Q.SQL.Add('       tab_estado te ');
          Q.SQL.Add(' where tm.cod_municipio = :cod_municipio ');
          Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
          Q.SQL.Add('   and tm.dta_fim_validade is null ');
  {$ENDif}
          Q.ParamByName('cod_municipio').AsInteger := CodMunicipio;
          Q.Open;
          if Q.IsEmpty then begin
            Mensagens.Adicionar(399, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
            Result := -399;
            Exit;
          End;
          CodMun := CodMunicipio;
          CodEst := Q.FieldByName('cod_estado').AsInteger;
          CodPai := Q.FieldByName('cod_pais').AsInteger;

          if CodEstado > 0 then begin
            if CodEstado <> CodEst then begin
              Mensagens.Adicionar(400, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
              Result := -400;
              Exit;
            End;
          End;

          if CodPais > 0 then begin
            if CodPais <> CodPai then begin
              Mensagens.Adicionar(401, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
              Result := -401;
              Exit;
            End;
          End;

          Q.Close;
        End Else Begin
          // Consiste o estado
          if CodEstado > 0 then begin
            Q.SQL.Clear;
    {$ifDEF MSSQL}
            Q.SQL.Add('select te.cod_pais ');
            Q.SQL.Add('  from tab_estado te ');
            Q.SQL.Add(' where te.cod_estado = :cod_estado ');
            Q.SQL.Add('   and te.dta_fim_validade is null ');
    {$ENDif}
            Q.ParamByName('cod_estado').AsInteger := CodEstado;
            Q.Open;
            if Q.IsEmpty then begin
              Mensagens.Adicionar(387, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
              Result := -387;
              Exit;
            End;
            CodEst := CodEstado;
            CodPai := Q.FieldByName('cod_pais').AsInteger;

            if CodPais > 0 then begin
              if CodPais <> CodPai then begin
                Mensagens.Adicionar(401, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
                Result := -401;
                Exit;
              End;
            End;
            Q.Close;
          End Else Begin
            if CodPais > 0 then begin
              Q.SQL.Clear;
      {$ifDEF MSSQL}
              Q.SQL.Add('select cod_pais ');
              Q.SQL.Add('  from tab_pais ');
              Q.SQL.Add(' where cod_pais = :cod_pais ');
              Q.SQL.Add('   and dta_fim_validade is null ');
      {$ENDif}
              Q.ParamByName('cod_pais').AsInteger := CodPais;
              Q.Open;
              if Q.IsEmpty then begin
                Mensagens.Adicionar(402, Self.ClassName, 'DefinirEnderecoCorrespondencia', []);
                Result := -402;
                Exit;
              End;
              CodPai := CodPais;
              Q.Close;
            End;
          End;
        End;
      End;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   nom_logradouro_correspondencia = :nom_logradouro,');
      Q.SQL.Add('   nom_bairro_correspondencia = :nom_bairro,');
      Q.SQL.Add('   num_cep_correspondencia = :num_cep,');
      Q.SQL.Add('   cod_pais_correspondencia = :cod_pais,');
      Q.SQL.Add('   cod_estado_correspondencia = :cod_estado,');
      Q.SQL.Add('   cod_municipio_correspondencia = :cod_municipio,');
      Q.SQL.Add('   cod_distrito_correspondencia = :cod_distrito');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      if NomLogradouro <> '' then begin
        Q.ParamByName('nom_logradouro').AsString      := NomLogradouro;
      End Else Begin
        Q.ParamByName('nom_logradouro').DataType := ftString;
        Q.ParamByName('nom_logradouro').Clear
      End;
      if NomBairro <> '' then begin
        Q.ParamByName('nom_bairro').AsString      := NomBairro;
      End Else Begin
        Q.ParamByName('nom_bairro').DataType := ftString;
        Q.ParamByName('nom_bairro').Clear
      End;
      if NumCEP <> '' then begin
        Q.ParamByName('num_cep').AsString      := NumCEP;
      End Else Begin
        Q.ParamByName('num_cep').DataType := ftString;
        Q.ParamByName('num_cep').Clear
      End;
      if CodPai > 0 then begin
        Q.ParamByName('cod_pais').AsInteger     := CodPai;
      End Else Begin
        Q.ParamByName('cod_pais').DataType := ftInteger;
        Q.ParamByName('cod_pais').Clear
      End;
      if CodEst > 0 then begin
        Q.ParamByName('cod_estado').AsInteger     := CodEst;
      End Else Begin
        Q.ParamByName('cod_estado').DataType := ftInteger;
        Q.ParamByName('cod_estado').Clear
      End;
      if CodMun > 0 then begin
        Q.ParamByName('cod_municipio').AsInteger     := CodMun;
      End Else Begin
        Q.ParamByName('cod_municipio').DataType := ftInteger;
        Q.ParamByName('cod_municipio').Clear
      End;
      if CodDis > 0 then begin
        Q.ParamByName('cod_distrito').AsInteger     := CodDis;
      End Else Begin
        Q.ParamByName('cod_distrito').DataType := ftInteger;
        Q.ParamByName('cod_distrito').Clear
      End;

      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(521, Self.ClassName, 'DefinirEnderecoCorrespondencia', [E.Message]);
        Result := -521;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.LimparEnderecoCorrespondencia(
  CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('LimparEnderecoCorrespondencia');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(191) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'LimparEnderecoCorrespondencia', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'LimparEnderecoCorrespondencia', []);
    Result := -507;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'LimparEnderecoCorrespondencia', []);
        Result := -327;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set ');
      Q.SQL.Add('   nom_logradouro_correspondencia = null,');
      Q.SQL.Add('   nom_bairro_correspondencia = null,');
      Q.SQL.Add('   num_cep_correspondencia = null,');
      Q.SQL.Add('   cod_pais_correspondencia = null,');
      Q.SQL.Add('   cod_estado_correspondencia = null,');
      Q.SQL.Add('   cod_municipio_correspondencia = null,');
      Q.SQL.Add('   cod_distrito_correspondencia = null');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(522, Self.ClassName, 'LimparEnderecoCorrespondencia', [E.Message]);
        Result := -522;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.Excluir(
  CodPropriedadeRural: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(192) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  // Verifica se cadastro está efetivado
  Result := CadastroEfetivado('tab_propriedade_rural', 'cod_propriedade_rural', -1,
    CodPropriedadeRural, True);
  if Result < 0 Then Exit;
  if Result = 1 then begin
    Mensagens.Adicionar(507, Self.ClassName, 'LimparEnderecoCorrespondencia', []);
    Result := -507;
    Exit;
  End;

  // Verifica utilização na tab_animal
  Result := VerificaUtilizacaoAnimal(CodPropriedadeRural);
  if Result < 0 then begin
    Exit;
  End;

  // Verifica utilização na tab_fazenda
  Result := VerificaUtilizacaoFazenda(CodPropriedadeRural, False);
  if Result < 0 then begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existência do registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('select 1 from tab_propriedade_rural ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(327, Self.ClassName, 'LimparEnderecoCorrespondencia', []);
        Result := -327;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$ifDEF MSSQL}
      Q.SQL.Add('update tab_propriedade_rural ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_propriedade_rural = :cod_propriedade_rural ');
{$ENDif}
      Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
      Q.ExecSQL;

(*
      A partir de 19/10/2004 o procedimento de atualização de grandezas será
      realizado a partir da execução de processo batch por intervalos configuráveis
      e não mais a partir da execução de cada operação como anteriormente.
      Result := AtualizaGrandeza(10, -1, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;

      Result := AtualizaGrandeza(12, -1, -1);
      if Result < 0 then begin
        Rollback;
        Exit;
      End;
*)

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(523, Self.ClassName, 'Excluir', [E.Message]);
        Result := -523;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;


function TIntPropriedadesRurais.PesquisarPropriedade(CodPessoaProdutor,
  CodEstado, CodPropriedadeRural: Integer; NumImovelReceitaFederal: String;
  CodLocalizacaoSisbov, CodFazenda: Integer): Integer;
begin
  Result := -1;
  if Not Inicializado then begin
    RaiseNaoInicializado('PesquisarPropriedade');
    Exit;
  End;

  // Verifica se usuário pode executar método
  if Not Conexao.PodeExecutarMetodo(509) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarPropriedade', []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
{$ifDEF MSSQL}
    Query.SQL.Clear;
    Query.SQL.Add('select fz.cod_fazenda as CodFazenda,');
    Query.SQL.Add('       fz.sgl_fazenda as SglFazenda,');
    Query.SQL.Add('       fz.nom_fazenda as NomFazenda,');
    Query.SQL.Add('       pr.cod_propriedade_rural as CodPropriedadeRural,');
    Query.SQL.Add('       pr.nom_propriedade_rural as NomPropriedadeRural,');
    Query.SQL.Add('       pr.cod_id_propriedade_sisbov as CodIdPropriedadeSisbov,');
    Query.SQL.Add('       pr.num_imovel_receita_federal as NumImovelReceitaFederal,');
    Query.SQL.Add('       tls.cod_localizacao_sisbov as CodLocalizacaoSisbov');
    Query.SQL.Add('  from tab_propriedade_rural pr, tab_fazenda fz,');
    Query.SQL.Add('       tab_localizacao_sisbov tls');
    Query.SQL.Add(' where fz.dta_fim_validade is null');
    Query.SQL.Add('   and tls.cod_propriedade_rural =* pr.cod_propriedade_rural');
    if CodPessoaProdutor > 0 then
      Query.SQL.Add('   and fz.cod_pessoa_produtor = :cod_pessoa_produtor');
    if CodEstado > 0 then
      Query.SQL.Add('   and pr.cod_estado  = :cod_estado');
    if CodFazenda > 0 then
      Query.SQL.Add('   and fz.cod_fazenda = :cod_fazenda');
    Query.SQL.Add('   and pr.dta_fim_validade is null');
    if CodPropriedadeRural > 0 then
      Query.SQL.Add('   and pr.cod_propriedade_rural = :cod_propriedade_rural');
    if Trim(NumImovelReceitaFederal) <> '' then
      Query.SQL.Add('   and pr.num_imovel_receita_federal = :num_imovel_receita_federal');
    if CodLocalizacaoSisbov > 0 then
      Query.SQL.Add('   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
    Query.SQL.Add('   and (   fz.cod_propriedade_rural = pr.cod_propriedade_rural');
    Query.SQL.Add('        OR fz.num_propriedade_rural = pr.num_imovel_receita_federal)');
{$ENDif}
    if CodPessoaProdutor > 0 then
      Query.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
    if CodEstado > 0 then
      Query.ParamByName('cod_estado').AsInteger := CodEstado;
    if CodFazenda > 0 then
      Query.ParamByName('cod_fazenda').AsInteger := CodFazenda;
    if CodPropriedadeRural > 0 then
      Query.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
    if Trim(NumImovelReceitaFederal) <> '' then
      Query.ParamByName('num_imovel_receita_federal').AsString := NumImovelReceitaFederal;
    if CodLocalizacaoSisbov > 0 then
      Query.ParamByName('cod_localizacao_sisbov').AsInteger := CodLocalizacaoSisbov;

    Query.Open;

    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(325, Self.ClassName, 'PesquisarPropriedade', [E.Message]);
      Result := -325;
      Exit;
    End;
  End;
end;

function TIntPropriedadesRurais.PesquisarPorProdutor(CodPessoaProdutor: Integer): Integer;
const
  NomeMetodo = 'PesquisarPorProdutor';
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(564) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  try
    with Query do
    begin
      SQL.Clear;
      SQL.Add('select tppr.cod_propriedade_rural as CodPropriedadeRural,');
      SQL.Add('       tppr.num_imovel_receita_federal as NumImovelReceitaFederal,');
      SQL.Add('       tppr.nom_propriedade_rural as NomPropriedadeRural,');
      SQL.Add('       tppr.cod_id_propriedade_sisbov as CodIdPropriedadeSisbov,');
      SQL.Add('       tls.cod_localizacao_sisbov as CodLocalizacaoSisbov');
      SQL.Add('  from tab_produtor tpr,');
      SQL.Add('       tab_propriedade_rural tppr,');
      SQL.Add('       tab_localizacao_sisbov tls,');
      SQL.Add('       tab_pessoa tp');
      SQL.Add(' where tpr.cod_pessoa_produtor = tp.cod_pessoa');
      SQL.Add('   and tpr.dta_fim_validade is null');
      SQL.Add('   and tp.dta_fim_validade is null');
      SQL.Add('   and tls.cod_pessoa_produtor = tpr.cod_pessoa_produtor');
      SQL.Add('   and tppr.dta_fim_validade is null');
      SQL.Add('   and tppr.cod_propriedade_rural = tls.cod_propriedade_rural');
      SQL.Add('   and tls.cod_pessoa_produtor = :cod_pessoa_produtor');

      ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

      Open;
    end;

    Result := 0;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(325, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -325;
      Exit;
    end;
  end;
end;

class function TIntPropriedadesRurais.VerificaLocalizacaoSISBOVPropriedade(
  EConexao: TConexao; EMensagem: TIntMensagens;
  ENumImovelReceitaFederal: String;
  ECodPropriedadeRural, ECodLocalizacaoSisbov, ECodPessoaProdutor: Integer;
  IndVerificaEfetivado: Boolean): Integer;
const
  NomMetodo: String = 'VerificaLocalizacaoSISBOVPropriedade';
var
  Qry: THerdomQuery;
  CodPropriedadeRural: Integer;
begin
  if ECodPessoaProdutor <= 0 then
  begin
    EMensagem.Adicionar(2103, Self.ClassName, NomMetodo, []);
    Result := -2103;
    Exit;
  end;

  if (ECodPropriedadeRural > 0) and (ENumImovelReceitaFederal <> '') then
  begin
    EMensagem.Adicionar(-2104, Self.ClassName, NomMetodo, []);
    Result := -2104;
    Exit;
  end;

  Try
    Qry := THerdomQuery.Create(EConexao, nil);
    Try
      { Caso o NIRF/INCRA seja informado verifica a existência de uma propriedade.
        Caso seja encontrado mais de 1 registro ou nenhum registro para a consulta retornar erro informando-o
        Caso contrário, retornar o cod_propriedade_rural }
      if (Length(Trim(ENumImovelReceitaFederal)) > 0) and (ECodLocalizacaoSisbov > 0) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select tpr.cod_propriedade_rural from tab_propriedade_rural tpr, tab_localizacao_sisbov tls');
        Qry.SQL.Add(' where tpr.cod_propriedade_rural = tls.cod_propriedade_rural ');
        Qry.SQL.Add('   and tpr.num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and tls.cod_localizacao_sisbov = :cod_localizacao_sisbov');
        Qry.SQL.Add('   and tpr.dta_fim_validade is null');        
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar(2094, Self.ClassName, NomMetodo, [ENumImovelReceitaFederal + ' - código exportação: ' + IntToStr(ECodLocalizacaoSisbov)]);
          Result := -2094;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('cod_propriedade_rural').AsInteger;        
      end
      else
      if Length(Trim(ENumImovelReceitaFederal)) > 0 then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select num_imovel_receita_federal, count(cod_propriedade_rural) as QtdPropriedade, max(cod_propriedade_rural) as CodPropriedadeRural from tab_propriedade_rural');
        Qry.SQL.Add(' where num_imovel_receita_federal = :num_imovel_receita_federal');
        Qry.SQL.Add('   and dta_fim_validade is null');        
        Qry.SQL.Add('group by num_imovel_receita_federal');
        Qry.ParamByName('num_imovel_receita_federal').AsString := ENumImovelReceitaFederal;
        Qry.Open;

        if Qry.FieldByName('QtdPropriedade').AsInteger = 0 then
        begin
          EMensagem.Adicionar(2094, Self.ClassName, NomMetodo, [ENumImovelReceitaFederal]);
          Result := -2094;
          Exit;
        end;

        if Qry.FieldByName('QtdPropriedade').AsInteger > 1 then
        begin
          EMensagem.Adicionar(2095, Self.ClassName, NomMetodo, [ENumImovelReceitaFederal]);
          Result := -2095;
          Exit;
        end;
        CodPropriedadeRural := Qry.FieldByName('CodPropriedadeRural').AsInteger;
      end
      else if ECodPropriedadeRural > 0 then
      begin
        CodPropriedadeRural := ECodPropriedadeRural;
      end
      else
      begin
        EMensagem.Adicionar(2096, Self.ClassName, NomMetodo, []);
        Result := -2096;
        Exit;
      end;
      { Caso o CodLocalizacaoSisbov tenha sido informado, consistir o par, produtor/propriedade
        verficando-os com o respectivo codigo de localizacao }
      if (ECodLocalizacaoSisbov > 0) or (IndVerificaEfetivado) then
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('select cod_localizacao_sisbov');
        Qry.SQL.Add('  from tab_localizacao_sisbov');
        Qry.SQL.Add(' where (1 = 1)');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.SQL.Add('   and cod_localizacao_sisbov = :cod_localizacao_sisbov');
        end;
        Qry.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        if ECodLocalizacaoSisbov > 0 then
        begin
          Qry.ParamByName('cod_localizacao_sisbov').AsInteger := ECodLocalizacaoSisbov;
        end;
        Qry.ParamByName('cod_pessoa_produtor').AsInteger :=   ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar(2097, Self.ClassName, NomMetodo, []);
          Result := -2097;
          Exit;
        end;
      end
      else
      begin
        { Caso o CodLocalizacaoSisbov não seja informado, ou esteja pesquisando por uma propriedade não exportada
          é necessário verificar se existe uma fazenda associada a propriedade e ao produtor informado }
        Qry.SQL.Clear;  
        Qry.SQL.Add('select cod_fazenda from tab_fazenda');
        Qry.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor');
        Qry.SQL.Add('   and cod_propriedade_rural = :cod_propriedade_rural');
        Qry.SQL.Add('   and dta_fim_validade is null');        
        Qry.ParamByName('cod_pessoa_produtor').AsInteger := ECodPessoaProdutor;
        Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
        Qry.Open;

        if Qry.IsEmpty then
        begin
          EMensagem.Adicionar(2098, Self.ClassName, NomMetodo, []);
          Result := -2098;
          Exit;
        end;
      end;

      Result := CodPropriedadeRural;
    Finally
      qry.Free;
    end;
  Except
    on E:Exception do
    begin
      EMensagem.Adicionar(2099, Self.ClassName, NomMetodo, [e.message]);
      Result := -2099;
      Exit;
    end;
  end;
end;

function TIntPropriedadesRurais.InserirPropriedadeCargaInicial(
  NomPropriedadeRural, NumImovelReceitaFederal, NumLatitude, NumLongitude,
  QtdArea, NomLogradouro, NomBairro, NumCEP, UFMunicipio, NomMunicipio,
  NomPessoaContato, NumTelefone, NumFax, NomLogradouroCorrespondencia,
  NomBairroCorrespondencia, NumCEPCorrespondencia,
  UFMunicipioCorrespondencia, NomMunicipioCorrespondencia,
  SglTipoInscricao, DtaInicioCertificado: String): Integer;
const
  NomeMetodo: String = 'InserirPropriedadeCargaInicial';
var
  CodPropriedadeRural: Integer;
  CodDistrito,
  CodMunicipio,
  CodEstado,
  CodDistritoCorrespondencia,
  CodMunicipioCorrespondencia,
  CodEstadoCorrespondencia,
  CodTipoInscricao,
  Longitude,
  Latitude: Integer;
  Area: Real;
  DataInicioCertificado: TDateTime;
  IntEnderecos: TIntEnderecos;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  try
    if Length(NomPropriedadeRural) > 50 then
    begin
      raise Exception.Create('O atributo NomPropriedadeRural é inválido.');
    end;
    if Length(NumImovelReceitaFederal) > 13 then
    begin
      raise Exception.Create('O atributo NumImovelReceitaFederal é inválido.');
    end;
    if Length(NumLatitude) > 8 then
    begin
      raise Exception.Create('O atributo NumLatitude é inválido.');
    end;
    if Length(NumLongitude) > 8 then
    begin
      raise Exception.Create('O atributo NumLongitude é inválido.');
    end;
    if Length(QtdArea) > 10 then
    begin
      raise Exception.Create('O atributo QtdArea é inválido.');
    end;
    if Length(NomLogradouro) > 100 then
    begin
      raise Exception.Create('O atributo NomLogradouro é inválido.');
    end;
    if Length(NomBairro) > 50 then
    begin
      raise Exception.Create('O atributo NomBairro é inválido.');
    end;
    if Length(NumCEP) > 8 then
    begin
      raise Exception.Create('O atributo NomCEP é inválido.');
    end;
    if Length(UFMunicipio) > 2 then
    begin
      raise Exception.Create('O atributo UFMunicipio é inválido.');
    end;
    if Length(NomMunicipio) > 50 then
    begin
      raise Exception.Create('O atributo NomMunicipio é inválido.');
    end;
    if Length(NomPessoaContato) > 50 then
    begin
      raise Exception.Create('O atributo NomPessoaContato é inválido.');
    end;
    if Length(NumTelefone) > 15 then
    begin
      raise Exception.Create('O atributo NumTelefone é inválido.');
    end;
    if Length(NumFax) > 15 then
    begin
      raise Exception.Create('O atributo NumFax é inválido.');
    end;
    if Length(NomLogradouroCorrespondencia) > 100 then
    begin
      raise Exception.Create('O atributo NomLogradouroCorrespondencia é inválido.');
    end;
    if Length(NomBairroCorrespondencia) > 50 then
    begin
      raise Exception.Create('O atributo NomBairroCorrespondencia é inválido.');
    end;
    if Length(NumCEPCorrespondencia) > 8 then
    begin
      raise Exception.Create('O atributo NumCEPCorrespondencia é inválido.');
    end;
    if Length(UFMunicipioCorrespondencia) > 2 then
    begin
      raise Exception.Create('O atributo UFMunicipioCorrespondencia é inválido.');
    end;
    if Length(NomMunicipioCorrespondencia) > 50 then
    begin
      raise Exception.Create('O atributo NomMunicipioCorrespondencia é inválido.');
    end;
    if Length(SglTipoInscricao) > 5 then
    begin
      raise Exception.Create('O atributo SglTipoInscricao é inválido.');
    end;
    if Length(DtaInicioCertificado) <> 8 then
    begin
      raise Exception.Create('O atributo DtaInicioCertificado é inválido.');
    end;

    IntEnderecos := TIntEnderecos.Create;
    try
      // Obtem o código do estado e do municipio/distrito
      IntEnderecos.Inicializar(Conexao, Mensagens);
      CodEstado := IntEnderecos.ObtemCodigoEstado(UFMunicipio);
      IntEnderecos.ObtemCodigoMunicipioDistrito(NomMunicipio, CodEstado,
        CodMunicipio, CodDistrito);

      // Obtem o código do estado e do municipio/distrito de correspondencia
      IntEnderecos.Inicializar(Conexao, Mensagens);
      CodEstadoCorrespondencia :=
        IntEnderecos.ObtemCodigoEstado(UFMunicipioCorrespondencia);
      IntEnderecos.ObtemCodigoMunicipioDistrito(NomMunicipioCorrespondencia,
        CodEstadoCorrespondencia, CodMunicipioCorrespondencia,
        CodDistritoCorrespondencia);
    finally
      IntEnderecos.Free;
    end;

    // Obtem o tipo de inscrição NIRF/INCRA
    CodTipoInscricao := -1;
    if Trim(SglTipoInscricao) = 'NIRF' then
    begin
      CodTipoInscricao := 1;
    end
    else
    if Trim(SglTipoInscricao) = 'INCRA' then
    begin
      CodTipoInscricao := 2;
    end;

    if CodTipoInscricao = -1 then
    begin
      raise Exception.Create('Tipo de inscrição ' + SglTipoInscricao + ' inválida');
    end;

    // Prepara a longitude a latitude e a area
    Longitude := -1;
    Latitude := -1;
    if Trim(NumLongitude) <> '' then
    begin
      Longitude := Trunc(StrDecimalToReal(NumLongitude, 0, False));
    end;
    if Trim(NumLatitude) <> '' then
    begin
      Latitude := Trunc(StrDecimalToReal(NumLatitude, 0, False));
    end;
    Area := StrDecimalToReal(QtdArea, 2, False);

    // Prepara a data
    DataInicioCertificado := EncodeDate(
      StrToInt(Copy(DtaInicioCertificado, 5, 4)),  // Ano
      StrToInt(Copy(DtaInicioCertificado, 3, 2)),  // Mes
      StrToInt(Copy(DtaInicioCertificado, 1, 2))); // Dia

    // Insere a propriedade
    CodPropriedadeRural := Inserir(NomPropriedadeRural,  Trim(NumImovelReceitaFederal), CodTipoInscricao,
                                   Latitude, Longitude, Area, NomPessoaContato, NumTelefone, NumFax,
                                   DataInicioCertificado, '', 'S', 'W', 1);
    if CodPropriedadeRural < 0 then
    begin
      Result := CodPropriedadeRural;
      Exit;
    end;

    Result := DefinirEndereco(CodPropriedadeRural, NomLogradouro, NomBairro,
      Trim(NumCEP), 1, CodEstado, CodMunicipio, CodDistrito);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := DefinirEnderecoCorrespondencia(CodPropriedadeRural,
      NomLogradouroCorrespondencia, NomBairroCorrespondencia,
      Trim(NumCEPCorrespondencia), 1, CodEstadoCorrespondencia,
      CodMunicipioCorrespondencia, CodDistritoCorrespondencia);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := EfetivarCadastro(CodPropriedadeRural);
    if Result < 0 then
    begin
      Exit;
    end;

    Result := CodPropriedadeRural;
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

function TIntPropriedadesRurais.StrDecimalToReal(Valor: String;
  QtdCasasDecimais: Integer; IndTemSinal: Boolean): Real;
var
  Base: Integer;
  Sinal: String;
begin
  if IndTemSinal then
  begin
    Sinal := Copy(Valor, 1, 1);
    Base := StrToInt(Trim(Copy(Valor, 2, Length(Valor))));
  end
  else
  begin
    Sinal := '+';
    Base := StrToInt(Trim(Valor));
  end;

  Result := Base / (Power(10, QtdCasasDecimais));

  if Sinal = '-' then
  begin
    Result := Result * -1;
  end;
end;

function TIntPropriedadesRurais.InserirVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
var
  Q : THerdomQuery;
  CodVistoriaEras: Integer;
  Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoIncluirVistoriaERAS;
  MsgDB, NomMetodo: String;
//  DtaVistoriaProp : TXSDateTime;
begin
  NomMetodo := 'InserirVistoria';

  Result := -1;
  RetornoSisbov := nil;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('InserirVistoria');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(186) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  // Trata se a propriedade rural foi informada.
  if CodPropriedadeRural <= 0 then begin
    Mensagens.Adicionar(2293, Self.ClassName, 'InserirVistoria', []);
    Result := -2293;
    Exit;
  End;

  // Trata se o técnico que realizou a vistoria.
  if CodTecnico <= 0 then begin
    Mensagens.Adicionar(2294, Self.ClassName, 'InserirVistoria', []);
    Result := -2294;
    Exit;
  End;

  // Trata data da vistoria da propriedade
  if (DtaVistoria <= StrToDate('01/12/2006',AjustesdeFormato)) then
  begin
    Mensagens.Adicionar(2295, Self.ClassName, 'InserirVistoria', []);
    Result := -2295;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    Try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Inserir Vistoria');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, 'InserirVistoria', ['não foi possível transmitir dados da vistoria do eras, tente mais tarde.']);
        Result := -2289;
        Exit;
      end;

      Q.SQL.Clear;
      Q.SQL.Add(' select  distinct 1 ' +
                '   from  tab_vistoria_eras tve ' +
                '   where cod_propriedade_rural = :cod_propriedade_rural ' +
                '     and cod_pessoa_tecnico    = :cod_tecnico ' +
                '     and dta_vistoria_eras     = :dta_vistoria_eras ');

      Q.ParamByName('cod_tecnico').AsInteger            := CodTecnico;
      Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
      Q.ParamByName('dta_vistoria_eras').AsDateTime     := DtaVistoria;
      Q.Open;

      if not Q.IsEmpty then
      begin
        Mensagens.Adicionar(2336, Self.ClassName, 'InserirVistoria', []);
        Result := -2336;
        Exit;
      end;

      Q.SQL.Clear;
      Q.SQL.Add(' select  tp.num_cnpj_cpf as num_cpf_tecnico ' +
                '      ,  tpr.cod_id_propriedade_sisbov ' +
                '      ,  tt.ind_transmissao_sisbov ' +
                ' from    tab_propriedade_rural tpr ' +
                '      ,  tab_pessoa tp ' +
                '      ,  tab_tecnico tt ' +
                ' where   tpr.cod_propriedade_rural = :cod_propriedade_rural ' +
                '    and  tp.cod_pessoa = :cod_tecnico ' +
                '    and  tt.cod_pessoa_tecnico = tp.cod_pessoa ');

      Q.ParamByName('cod_tecnico').AsInteger            := CodTecnico;
      Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
      Q.Open;

      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2297, Self.ClassName, 'InserirVistoria', []);
        Result := -2297;
        Exit;
      end;

      if Q.FieldByName('cod_id_propriedade_sisbov').IsNull then
      begin
        Mensagens.Adicionar(510, Self.ClassName, 'InserirVistoria', []);
        Result := -510;
        Exit;
      end;

      if Q.FieldByName('ind_transmissao_sisbov').AsString <> 'S' then
      begin
        Mensagens.Adicionar(2314, Self.ClassName, 'InserirVistoria', []);
        Result := -2314;
        Exit;
      end;

      try
        RetornoSisbov := SoapSisbov.incluirVistoriaERAS(
                             Descriptografar(ValorParametro(118))
                           , Descriptografar(ValorParametro(119))
                           , Q.FieldByName('num_cpf_tecnico').AsString
                           , Q.FieldByName('cod_id_propriedade_sisbov').AsInteger
                           , FormatDateTime('dd/mm/yyyy', DtaVistoria));
      except
         on E: Exception do
         begin
           Mensagens.Adicionar(2296, Self.ClassName, 'InserirVistoria', ['']);
           Result := -2296;
         end;
      end;

      If RetornoSisbov <> nil then begin
        If RetornoSisbov.Status = 0 then begin
          Mensagens.Adicionar(2296, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoSisbov)]);
          Result := -2296;
        end else begin
          BeginTran;

          // Obtem o codigo do registro
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select max(cod_vistoria_eras) as CodVistoriaEras from tab_vistoria_eras');
    {$ENDIF}
          Q.Open;

          CodVistoriaEras := Q.FieldByName('CodVistoriaEras').AsInteger + 1;

          // Tenta Inserir Registro
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('insert into tab_vistoria_eras ' +
                    ' (cod_propriedade_rural ' +
                    '  , cod_pessoa_tecnico ' +
                    '  , dta_vistoria_eras ' +
                    '  , cod_vistoria_eras ' +
                    '  , ind_transmissao_sisbov) ' +
                    'values ' +
                    ' (:cod_propriedade_rural, ' +
                    '  :cod_pessoa_tecnico, ' +
                    '  :dta_vistoria_eras, ' +
                    '  :cod_vistoria_eras, ' +
                    '  ''S'') ');
    {$ENDIF}
          Q.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          Q.ParamByName('cod_pessoa_tecnico').AsInteger    := CodTecnico;
          Q.ParamByName('dta_vistoria_eras').AsDateTime    := DtaVistoria;
          Q.ParamByName('cod_vistoria_eras').AsInteger     := CodVistoriaEras;
          Q.ExecSQL;

          // Cofirma transação
          Commit;
        end;
      end else begin
        Mensagens.Adicionar(2296, Self.ClassName, NomMetodo, [' Erro no retorno do SISBOV ']);
        Result := -2296;
      end;

      // Retorna código do registro inserido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        MsgDB := E.Message;
        Mensagens.Adicionar(2311, Self.ClassName, 'InserirVistoria', [E.Message]);
        Result := -2311;
        Exit;
      End;
    End;
  Finally
    Q.Free;
    SoapSisbov.Free;
  End;
end;

function TIntPropriedadesRurais.ExcluirVistoria(CodVistoria: Integer): Integer;
var
  Q : THerdomQuery;
  ExcluiVistoria, Conectado: boolean;
  SoapSisbov: TIntSoapSisbov;
  RetornoSisbov: RetornoExcluirVistoria;
  NomMetodo: String;
begin
  NomMetodo := 'ExcluirVistoria';
  ExcluiVistoria := false;
  RetornoSisbov := nil;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ExcluirVistoria');
    Exit;
  End;

  // Trata se o código da vistoria é valido.
  if CodVistoria <= 0 then begin
    Mensagens.Adicionar(2298, Self.ClassName, 'ExcluirVistoria', []);
    Result := -2298;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  SoapSisbov := TIntSoapSisbov.Create;
  Try
    Try
      SoapSisbov.Inicializar(Conexao, Mensagens);

      Conectado := SoapSisbov.conectado('Excluir Vistoria');

      if not Conectado then begin
        Mensagens.Adicionar(2289, Self.ClassName, 'ExcluirVistoria', ['não foi possível transmitir dados da vistoria do eras, tente mais tarde.']);
        Result := -2289;
        Exit;
      end;

      Q.SQL.Clear;
      Q.SQL.Add(' select  tvs.ind_transmissao_sisbov ' +
                '     ,   tpr.cod_id_propriedade_sisbov ' +
                ' from    tab_vistoria_eras tvs ' +
                '     ,   tab_propriedade_rural tpr ' +
                ' where   tvs.cod_vistoria_eras = :cod_vistoria_eras ' +
                '   and   tvs.cod_propriedade_rural = tpr.cod_propriedade_rural ');

      Q.ParamByName('cod_vistoria_eras').AsInteger := CodVistoria;
      Q.Open;

      if Q.IsEmpty then
      begin
        Mensagens.Adicionar(2298, Self.ClassName, 'InserirVistoria', []);
        Result := -2298;
        Exit;
      end;

      if Q.FieldByName('ind_transmissao_sisbov').AsString = 'S' then begin
        try
          RetornoSisbov := SoapSisbov.excluirVistoria(
                               Descriptografar(ValorParametro(118))
                             , Descriptografar(ValorParametro(119))
                             , Q.FieldByName('cod_id_propriedade_sisbov').AsInteger);
        except
           on E: Exception do
           begin
             Mensagens.Adicionar(2296, Self.ClassName, 'InserirVistoria', ['']);
             Result := -2296;
           end;
        end;

        If RetornoSisbov <> nil then begin
          If RetornoSisbov.Status = 0 then begin
            Mensagens.Adicionar(2296, Self.ClassName, NomMetodo, [' Mensagem SISBOV: ' + TrataMensagemErroSISBOV(RetornoSisbov)]);
            Result := -2296;
          end else begin
            ExcluiVistoria := true;
          end;
        end;
      end else begin
        ExcluiVistoria := true;
      end;

      if ExcluiVistoria then begin
        // Abre transação
        BeginTran;

        // Tenta excluir Registro
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('delete tab_vistoria_eras ' +
                  ' where cod_vistoria_eras = :cod_vistoria_eras ');
{$ENDIF}
        Q.ParamByName('cod_vistoria_eras').AsInteger := CodVistoria;
        Q.ExecSQL;

        // Cofirma transação
        Commit;
      end;

      // Retorna código do registro inserido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(2312, Self.ClassName, 'ExcluirVistoria', [E.Message]);
        Result := -2312;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPropriedadesRurais.PesquisarVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarVistoria');
    Exit;
  End;

  // Trata se a propriedade rural foi informada.
  if (CodPropriedadeRural <= 0) and (CodTecnico <= 0) and (DtaVistoria <= 0) then begin
    Mensagens.Adicionar(2298, Self.ClassName, 'PesquisarVistoria', []);
    Result := -2298;
    Exit;
  End;

  Try
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add(' select  tve.cod_propriedade_rural ' +
              '      ,  tve.cod_pessoa_tecnico as cod_tecnico ' +
              '      ,  tp.nom_pessoa ' +
              '      ,  tve.dta_vistoria_eras ' +
              '      ,  tve.ind_transmissao_sisbov ' +
              '      ,  tve.cod_vistoria_eras ' +
              '   from  tab_vistoria_eras tve ' +
              '      ,  tab_pessoa tp ' +
              '  where  tp.cod_pessoa = tve.cod_pessoa_tecnico ');
    if (CodPropriedadeRural > 0) then begin
      Query.SQL.Add('  and tve.cod_propriedade_rural = :cod_propriedade_rural ');
    end;

    if (CodTecnico > 0) then begin
      Query.SQL.Add('  and tve.cod_pessoa_tecnico    = :cod_pessoa_tecnico ');
    end;

    if (DtaVistoria > 0) then begin
      Query.SQL.Add('  and tve.dta_vistoria_eras    >= :dta_vistoria_eras ');
    end;
    Query.SQL.Add(' order by dta_vistoria_eras desc ');

    if (CodPropriedadeRural > 0) then begin
      Query.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
    end;

    if (CodTecnico > 0) then begin
      Query.ParamByName('cod_pessoa_tecnico').AsInteger            := CodTecnico;
    end;

    if (DtaVistoria > 0) then begin
      Query.ParamByName('dta_vistoria_eras').AsDateTime      := DtaVistoria;
    end;

    Query.Open;

    // Retorna código do registro inserido
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(2313, Self.ClassName, 'PesquisarVistoria', [E.Message]);
      Result := -2313;
      Exit;
    End;
  End;
end;

function TIntPropriedadesRurais.ImprimirCertificado(CodPropriedadeRural: Integer): String;
type
  TTecnico = record
    CodPessoa: Integer;
    Nome: String;
    CRMV: String;
  end;
var
  Rel : TRelatorioPadrao;
  Qry, QryLayout, QryCampo : THerdomQuery;
  I, Retorno : Integer;
  PDF : TPrintPDF;
  NomeArquivo, Caminho : String;
  Coef: Extended;
  TecnicoResponsavel: TTecnico;
  TipoResponsavel: String;
begin
  Result := '';
  Caminho := '';
  NomeArquivo := '';

  Coef := 28.3501;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('ImprimirCertificado');
    Exit;
  End;

  // Trata se a propriedade rural foi informada.
  if (CodPropriedadeRural <= 0) then begin
    Mensagens.Adicionar(2387, Self.ClassName, 'ImprimirCertificado', []);
    Result := '';
    Exit;
  End;

  Try
    Qry := THerdomQuery.Create(Conexao, nil);
    Try
      QryLayout := THerdomQuery.Create(Conexao, nil);
      Try
        QryCampo := THerdomQuery.Create(Conexao, nil);
        Try

          Qry.Close;
          Qry.SQL.Clear;
          Qry.SQL.Add(' select tve.dta_vistoria_eras ' +
                      '   ,    case tpr.cod_tipo_propriedade_rural ' +
                      '          when 1 then tve.dta_vistoria_eras + 180 ' +
                      '          when 2 then tve.dta_vistoria_eras + 60 ' +
                      '          when 3 then tve.dta_vistoria_eras + 180 ' +
                      '        end as dta_validade_vistoria ' +
                      '   ,    tpr.cod_tipo_propriedade_rural ' +
                      '   ,    tpr.nom_propriedade_rural ' +
                      '   ,    tm.nom_municipio ' +
                      '   ,    te.cod_estado ' +
                      '   ,    te.sgl_estado ' +
                      '   ,    tpr.num_imovel_receita_federal ' +
                      '   ,    tpr.cod_id_propriedade_sisbov ' +
                      '   ,    tp.nom_pessoa ' +
                      '   ,    case tp.cod_natureza_pessoa  ' +
                      '         when ''F'' then convert(varchar(18),  ' +
                      '           substring(tp.num_cnpj_cpf, 1, 3) + ''.'' +  ' +
                      '           substring(tp.num_cnpj_cpf, 4, 3) + ''.'' +  ' +
                      '           substring(tp.num_cnpj_cpf, 7, 3) + ''-'' +  ' +
                      '           substring(tp.num_cnpj_cpf, 10, 2))  ' +
                      '         when ''J'' then convert(varchar(18),  ' +
                      '           substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                      '           substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                      '           substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                      '           substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                      '           substring(tp.num_cnpj_cpf, 13, 2)) ' +
                      '        end as num_cnpj_cpf ' +
                      '   ,    tp1.nom_pessoa as nom_pessoa_tecnico ' +
                      '   ,    tt.num_conselho_regional ' +
                      '   ,    tp2.nom_pessoa as nom_pessoa_certificadora ' +
                      ' from   tab_vistoria_eras tve ' +
                      '   ,    tab_propriedade_rural tpr ' +
                      '   ,    tab_pessoa tp ' +
                      '   ,    tab_municipio tm ' +
                      '   ,    tab_estado te ' +
                      '   ,    tab_pessoa tp1 ' +
                      '   ,    tab_pessoa tp2 ' +
                      '   ,    tab_tecnico tt ' +
                      '   ,    tab_parametro_sistema tps ' +
                      '   ,    tab_parametro_sistema tps1 ' +
                      ' where  tve.cod_propriedade_rural = :cod_propriedade_rural ' +
                      '   and  tve.ind_transmissao_sisbov = ''S'' ' +
                      '   and  tve.cod_propriedade_rural = tpr.cod_propriedade_rural ' +
                      '   and  tpr.cod_municipio  = tm.cod_municipio ' +
                      '   and  tpr.cod_estado = te.cod_estado ' +
                      '   and  tve.cod_pessoa_tecnico = tp.cod_pessoa ' +
                      '   and  tps.cod_parametro_sistema = 65 ' +
                      '   and  tps.val_parametro_sistema = tp1.cod_pessoa ' +
                      '   and  tp1.cod_pessoa = tt.cod_pessoa_tecnico ' +
                      '   and  tps1.cod_parametro_sistema = 4 ' +
                      '   and  tps1.val_parametro_sistema = tp2.cod_pessoa ' +
                      ' order by tve.dta_vistoria_eras desc ');

          Qry.ParamByName('cod_propriedade_rural').AsInteger := CodPropriedadeRural;
          Qry.Open;


          TipoResponsavel := '';
          // Recupera pessoa responsável
          QryCampo.SQL.Clear;
          QryCampo.SQL.Text :=
            'select '+
            '  val_parametro_sistema as TipoResponsavel '+
            'from '+
            '  tab_parametro_sistema '+
            'where '+
            '  cod_parametro_sistema = 201 ';
          QryCampo.Open;
          TipoResponsavel := Trim( QryCampo.FieldByName('TipoResponsavel').AsString );
          QryCampo.Close;

          if (TipoResponsavel = '') then
            TipoResponsavel := 'N';

          TecnicoResponsavel.CodPessoa := -1;
          TecnicoResponsavel.Nome := '';
          TecnicoResponsavel.CRMV := '';


          // Recupera pessoa responsável
          QryCampo.SQL.Clear;
          QryCampo.SQL.Text :=
            'select '+
            '  cast(val_parametro_sistema as integer) as CodPessoa '+
            'from '+
            '  tab_parametro_sistema '+
            'where '+
            '  cod_parametro_sistema = 65 ';
          QryCampo.Open;
          if not QryCampo.IsEmpty then begin
            TecnicoResponsavel.CodPessoa := QryCampo.FieldByName('CodPessoa').AsInteger;
          end;
          QryCampo.Close;

          // Recupera dados do técnico da UF do Animal
          if (TipoResponsavel = 'U') then begin
            QryCampo.SQL.Clear;
            QryCampo.SQL.Text :=
              'select tp.cod_pessoa as CodPessoa,'+
              '  tp.nom_pessoa as NomPessoa '+
              '  , case when tt.sgl_conselho_regional is null then '+
              '      tt.num_conselho_regional '+
              '    else '+
              '      tt.sgl_conselho_regional + '' - '' + tt.num_conselho_regional '+
              '    end as CRMV '+
              'from '+
              '  tab_pessoa tp '+
              '  , tab_tecnico tt, tab_estado_tecnico ttu '+
              'where tt.cod_pessoa_tecnico = tp.cod_pessoa '+
              '  and ttu.cod_pessoa_tecnico = tt.cod_pessoa_tecnico '+
              '  and ttu.cod_estado = :cod_estado ';
            QryCampo.ParamByName('cod_estado').AsInteger := Qry.FieldByName('cod_estado').AsInteger;
            QryCampo.Open;
            if QryCampo.IsEmpty then begin
              raise Exception.Create('Técnico não encontrado.');
            end;
            TecnicoResponsavel.CodPessoa := QryCampo.FieldByName('CodPessoa').AsInteger;
            TecnicoResponsavel.Nome      := QryCampo.FieldByName('NomPessoa').AsString;
            TecnicoResponsavel.CRMV      := QryCampo.FieldByName('CRMV').AsString;
          end
          else
            // Recupera dados do técnico (caso o mesmo tenha sido informado)
            //if (TipoResponsavel = 'P') then
            begin
              QryCampo.SQL.Clear;
              QryCampo.SQL.Text :=
                'select '+
                '  tp.nom_pessoa as NomPessoa '+
                '  , case when tt.sgl_conselho_regional is null then '+
                '      tt.num_conselho_regional '+
                '    else '+
                '      tt.sgl_conselho_regional + '' - '' + tt.num_conselho_regional '+
                '    end as CRMV '+
                'from '+
                '  tab_pessoa tp '+
                '  , tab_tecnico tt '+
                'where '+
                '  tp.cod_pessoa = :cod_pessoa '+
                '  and tt.cod_pessoa_tecnico = tp.cod_pessoa ';
              QryCampo.ParamByName('cod_pessoa').AsInteger := TecnicoResponsavel.CodPessoa;
              QryCampo.Open;
              if QryCampo.IsEmpty then begin
                raise Exception.Create('Técnico Principal não encontrado.');
              end;
              TecnicoResponsavel.Nome := QryCampo.FieldByName('NomPessoa').AsString;
              TecnicoResponsavel.CRMV := QryCampo.FieldByName('CRMV').AsString;
            end;

          Qry.First;
          if not Qry.Eof then begin
            // Prepara dados para início da geração do arquivo
            PDF := TPrintPDF.Create(nil);
            Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);

            try
              PDF.Title := 'Certificados de Propriedade';
              PDF.Compress := True;

              Retorno := Rel.BuscarNomeArquivo;
              if Retorno <= 0 then begin
                Exit;
              end else begin
                Caminho := Rel.NomeArquivo + '.PDF';
              end;

              PDF.FileName := Caminho;
              PDF.beginDoc;

              // Pega na tabela de layout do certificado de propriedade o tamanho
              // padrão da folha
              QryLayout.Close;
              QryLayout.SQL.Clear;
              QryLayout.SQL.Add(' select num_largura_layout ' +
                                '     ,  num_altura_layout ' +
                                '     ,  cod_tipo_fonte ' +
                                '     ,  val_tamanho_fonte ' +
                                ' from   tab_layout_certif_propriedade ' +
                                ' where  cod_layout_certificado = 1 ');

              QryLayout.Open;
              QryLayout.First;

              PDF.PageWidth  := Trunc(QryLayout.FieldByname('num_largura_layout').AsFloat * Coef);
              PDF.PageHeight := Trunc(QryLayout.FieldByname('num_altura_layout').AsFloat * Coef);
              PDF.LineWidth  := 1;

              PDF.Font.Name := TPDFFontName(QryLayout.FieldByname('cod_tipo_fonte').AsInteger);
              PDF.Font.Size := QryLayout.FieldByname('val_tamanho_fonte').AsInteger;

              QryCampo.Close;
              QryCampo.SQL.Clear;
              QryCampo.SQL.Add(' select  num_posicao_x ' +
                                '     ,  num_posicao_y ' +
                                ' from   tab_campo_certif_propriedade ' +
                                ' where  cod_layout_certificado = 1 ');

              QryCampo.Open;

              QryCampo.First;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('nom_propriedade_rural').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('nom_municipio').AsString + ' / ' + Qry.FieldByname('sgl_estado').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('num_imovel_receita_federal').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('cod_id_propriedade_sisbov').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('nom_pessoa').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('num_cnpj_cpf').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          Qry.FieldByname('nom_pessoa_certificadora').AsString);

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          FormatDateTime('DD',Qry.FieldByname('dta_vistoria_eras').AsDateTime) + '       ' +
                          FormatDateTime('MM',Qry.FieldByname('dta_vistoria_eras').AsDateTime) + '        ' +
                          FormatDateTime('YYYY',Qry.FieldByname('dta_vistoria_eras').AsDateTime));

              QryCampo.Next;
              PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                          Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                          FormatDateTime('DD',Qry.FieldByname('dta_validade_vistoria').AsDateTime) + '       ' +
                          FormatDateTime('MM',Qry.FieldByname('dta_validade_vistoria').AsDateTime) + '        ' +
                          FormatDateTime('YYYY',Qry.FieldByname('dta_validade_vistoria').AsDateTime));

              QryCampo.Next;
//              if ( TipoResponsavel <> 'N') then
                PDF.TextOut(Trunc(QryCampo.FieldByname('num_posicao_x').AsFloat * Coef),
                            Trunc(QryCampo.FieldByname('num_posicao_y').AsFloat * Coef),
                            TecnicoResponsavel.Nome + ' / ' + TecnicoResponsavel.CRMV);

              PDF.ENDDoc;

              I := Length(Caminho);

              While I > 0 do begin
                if copy(Caminho, I, 1) = '\' then begin
                  I := 0;
                end else begin
                  NomeArquivo := copy(Caminho, I, 1) + NomeArquivo;
                end;
                I := I - 1
              End;

              Result := NomeArquivo;
            Finally
              PDF.Free;
              Rel.Free;
            end;
          end else begin
            Mensagens.Adicionar(2387, Self.ClassName, 'ImprimirCertificado', []);
            Result := '';
          end;
        Finally
          QryCampo.Free;
        end;
      Finally
        QryLayout.Free;
      end;
    Finally
      Qry.Free;
    end;
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(2388, Self.ClassName, 'ImprimirCertificado', [E.Message]);
      Result := '';
      Exit;
    End;
  End;
end;

function TIntPropriedadesRurais.ConsultarSuspensao(
  CodPropriedadeRural: integer): integer;
const
  NomeMetodo: String  = 'ConsultarSuspencaoPropriedade';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoConsultarSuspensao;
  StatusSuspencao:widestring;
  q:THerdomQuery;
  IdPropriedadeSisbov:integer;
begin
   Result := -1;
   RetornoSisbov   := nil;

  q :=  therdomquery.Create(Conexao,nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;

    q.SQL.Text  :=  'SELECT DTA_INICIO_CONFINAMENTO,DTA_FIM_CONFINAMENTO,COD_TIPO_PROPRIEDADE_RURAL,COD_ID_PROPRIEDADE_SISBOV '+
                    'FROM TAB_PROPRIEDADE_RURAL '+
                    'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL';
    q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    q.Open;

    if q.IsEmpty  then
    begin
      Mensagens.Adicionar(327, Self.ClassName, NomeMetodo, []);
      Result := -327;
      Exit;
    end;
    IdPropriedadeSisbov :=  Q.FIELDBYNAME('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
    SoapSisbov          :=  TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Consultar Suspenção de Propriedade');
      try
        RetornoSISBOV :=  SoapSisbov.consultarSuspensao(Descriptografar(ValorParametro(118)),
                                                        Descriptografar(ValorParametro(119)),
                                                        IdPropriedadeSisbov);

        if RetornoSISBOV.status <> 1 then
          raise Exception.Create(RetornoSISBOV.listaErros[0].menssagemErro);
        result  :=  1;
      except
        //Alterar esse codigo de erro para o correto
        on E: Exception do begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Consulta de Suspenção)'+e.Message]);
          Result := -CERRO_GERAL;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Close;
    q.Free;
  end;
end;
function TIntPropriedadesRurais.suspenderPropriedade(IdPropriedadeSisbov,
  IdMotivo: integer; Obs: widestring): integer;
const
  NomeMetodo: String  = 'SuspenderPropriedade';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoWsSISBOV;
  StatusSuspencao:widestring;
  Q:THerdomQuery;
begin
   Result := -1;
   RetornoSisbov   := nil;
   Q := THerdomQuery.Create(Conexao, nil);
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;
  SoapSisbov := TIntSoapSisbov.Create;
  try
    SoapSisbov.Inicializar(Conexao, Mensagens);
    Conectado := SoapSisbov.Conectado('Suspenção de Propriedade');
    try
      RetornoSISBOV :=  SoapSisbov.suspenderPropriedade(Descriptografar(ValorParametro(118)),
                                                      Descriptografar(ValorParametro(119)),IdPropriedadeSisbov,IdMotivo,Obs);
      if RetornoSISBOV.status <> 1 then
        raise Exception.Create('Falha ao suspender propriedade no SISBOV');

      q.SQL.Text  :=  'UPDATE TAB_PROPRIEDADE_RURAL SET DATA_SUSPENSAO = CURRENT_TIMESTAMP, COD_MOTIVO_SUSPENCAO_PROPRIEDADE = :ID_MOTIVO_SUSPENCAO '+
                      'WHERE COD_ID_PROPRIEDADE_SISBOV = :IDPROPRIEDADESISBOV';

      Q.ParamByName('ID_MOTIVO_SUSPENCAO').AsInteger  :=  IdMotivo;
      Q.ParamByName('IDPROPRIEDADESISBOV').AsInteger  :=  IDPROPRIEDADESISBOV;
      Begintran;
      Q.ExecSQL();
      Commit;
      result  :=  1;
    except
      //Alterar esse codigo de erro para o correto
      on E: Exception do begin
        Rollback;
        Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Suspenção de Propriedade)'+e.Message]);
        Result := -CERRO_GERAL;
      end;
    end;
  finally
    SoapSisbov.Free;
    q.Free;
  end;
end;

function TIntPropriedadesRurais.iniciarVistoria(
  const CodPropriedadeRural: integer; const dataAgendamento: WideString;
  const CodTecnico: integer): integer;
const
  NomeMetodo: String  = 'IniciarVistoria';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoCheckListVistoria;
  StatusSuspencao:widestring;
  Q:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont,ContGrupos,ContItens,ContDivisao:Integer;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    try
      if StrToDate(dataAgendamento,AjustesdeFormato)<trunc(Now) then
      begin
       Mensagens.Adicionar(10246, Self.ClassName, NomeMetodo, []);
       Result := -10246;
       Exit;
      end;
    except
       Mensagens.Adicionar(10248, Self.ClassName, NomeMetodo, []);
       Result := -10248;
       Exit;
    end;
    //Verificando se existe alguma vistoria em estado aberto nessa data
    Q.SQL.Text  :=  'SELECT COD_PROPRIEDADE_RURAL  FROM TAB_VISTORIA '+
                    'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL AND DATA_VISTORIA = :DATA_VISTORIA AND COD_STATUS_VISTORIA = 2';
    Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    Q.ParamByName('DATA_VISTORIA').AsDate             :=  StrToDate(dataAgendamento);
    Q.Open;

    if not q.IsEmpty then
    begin
      Mensagens.Adicionar(10242, Self.ClassName, NomeMetodo, [dataAgendamento]);
      Result := -10242;
      Exit;
    end;
    //VERIFICANDO SE JÁ EXISTE UMA VISTORIA EM ABERTO PARA A PROPRIEDADE RURAL
    Q.Close;
    q.SQL.Text  :=  'SELECT DATA_VISTORIA FROM TAB_VISTORIA WHERE COD_STATUS_VISTORIA = 2 AND COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
    Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    Q.Open;

    if not q.IsEmpty then
    begin
      Mensagens.Adicionar(10245, Self.ClassName, NomeMetodo, [q.FieldByName('DATA_VISTORIA').AsString]);
      Result := -10245;
      Exit;
    end;
    //Resgatando o CPF do Técnico, ID da propriedade no SISBOV
    q.Close;
    Q.SQL.Clear;
    Q.SQL.Add(' SELECT  TP.NUM_CNPJ_CPF AS NUM_CPF_TECNICO ' +
              '      ,  TPR.COD_ID_PROPRIEDADE_SISBOV ' +
              '      ,  TT.IND_TRANSMISSAO_SISBOV ' +
              ' FROM    TAB_PROPRIEDADE_RURAL TPR ' +
              '      ,  TAB_PESSOA TP ' +
              '      ,  TAB_TECNICO TT ' +
              ' WHERE   TPR.COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL ' +
              '    AND  TP.COD_PESSOA = :COD_TECNICO ' +
              '    AND  TT.COD_PESSOA_TECNICO = TP.COD_PESSOA ');

    Q.ParamByName('cod_tecnico').AsInteger            := CodTecnico;
    Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
    Q.Open;

    if Q.IsEmpty then
    begin
      Mensagens.Adicionar(2297, Self.ClassName, NomeMetodo, []);
      Result := -2297;
      Exit;
    end;

    if Q.FieldByName('cod_id_propriedade_sisbov').IsNull then
    begin
      Mensagens.Adicionar(510, Self.ClassName, NomeMetodo, []);
      Result := -510;
      Exit;
    end;

    if Q.FieldByName('ind_transmissao_sisbov').AsString <> 'S' then
    begin
      Mensagens.Adicionar(2314, Self.ClassName, NomeMetodo, []);
      Result := -2314;
      Exit;
    end;
    IDPropriedadeSISBOV :=  Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
    CPFTecnico          :=  Q.FieldByName('num_cpf_tecnico').AsString;
    q.Close;
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Iniciar Vistoria');
      try
        RetornoSISBOV :=  SoapSisbov.iniciarVistoria(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                   IDPropriedadeSISBOV,dataAgendamento,CPFTecnico);
        if RetornoSISBOV.status <> 0 then
        begin
          //inserindo questionário no banco de dados
          try
            q.SQL.Text  :=  'INSERT INTO TAB_VISTORIA (COD_PROPRIEDADE_RURAL,DATA_VISTORIA,COD_PESSOA_TECNICO,COD_ID_TRANSACAO_SISBOV) VALUES'+
                            '(:COD_PROPRIEDADE_RURAL,:DATA_VISTORIA,:COD_PESSOA_TECNICO,:COD_ID_TRANSACAO_SISBOV)';
            Begintran;
            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
            Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataAgendamento);
            Q.ParamByName('COD_PESSOA_TECNICO').AsInteger       :=  CodTecnico;
            Q.ParamByName('COD_ID_TRANSACAO_SISBOV').AsInteger  :=  RetornoSISBOV.idTransacao;
            Q.ExecSQL();
            Q.sql.text  :=  'INSERT INTO TAB_VISTORIA_ERAS '  +
                            '   SELECT COD_PROPRIEDADE_RURAL, COD_PESSOA_TECNICO, '  +
                            '          (SELECT MAX (COD_VISTORIA_ERAS) + 1 '  +
                            '             FROM TAB_VISTORIA_ERAS) COD_VISTORIA_ERAS, DATA_VISTORIA, '  +
                            '          ''S'' AS IND_TRANSMISSAO_SISBOV, COD_ID_TRANSACAO_SISBOV '  +
                            '     FROM TAB_VISTORIA '  +
                            '    WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL '  +
                            '      AND DATA_VISTORIA = (SELECT MAX (DATA_VISTORIA) '  +
                            '                             FROM TAB_VISTORIA '  +
                            '                            WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL)';

            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
            Q.ExecSQL();

            Q.SQL.Text  :=  'INSERT INTO TAB_VISTORIA_QUESTIONARIO(COD_PROPRIEDADE_RURAL,DATA_VISTORIA,COD_ITEM_SISBOV,DESCRICAO_ITEM,TIPO_ITEM,ORDEM_GRUPO,NOME_GRUPO,ORDEM_ITEM) VALUES'+
                            '(:COD_PROPRIEDADE_RURAL,:DATA_VISTORIA,:COD_ITEM_SISBOV,:DESCRICAO_ITEM,:TIPO_ITEM,:ORDEM_GRUPO,:NOME_GRUPO,:ORDEM_ITEM)';
            for ContGrupos := 0 to High(RetornoSISBOV.grupos) do
            begin
              for ContItens :=  0 to High(RetornoSISBOV.grupos[ContGrupos].itemGrupo) do
              begin
                Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataAgendamento);
                Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].idItem;
                Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].descricaoItem;
                Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].tipoItem;
                Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].ordemItem;
                Q.ExecSQL();
              end;
              for ContDivisao :=  0 to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo) do
              begin
                for ContItens := 0  to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao) do
                begin
                  Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                  Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataAgendamento);
                  Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].idItem;
                  Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].descricaoItem;
                  Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].tipoItem;
                  Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                  Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                  Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].ordemItem;
                  Q.ExecSQL();
                end;
              end;
            end;
            Commit;
            result  :=  0;
          except
            on E: Exception do
            begin
              Rollback;
              Mensagens.Adicionar(10244, Self.ClassName, NomeMetodo, [e.Message]);
              Result := -10244;
            end;
          end;
        end
        else
        begin
          Mensagens.Adicionar(10243, Self.ClassName, NomeMetodo, []);
          Result := -10243;
          exit;
        end;
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Iniciar Vistoria)'+e.Message]);
          Result := -CERRO_GERAL;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Close;
    q.Free;
  end;
end;



function TIntPropriedadesRurais.ReagendarVistoria(
  const CodPropriedadeRural: integer; const dataReAgendamento: WideString;
  const CodTecnico: integer;Justificativa:WideString): integer;
const
  NomeMetodo: String  = 'ReagendarVistoria';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoCheckListVistoria;
  StatusSuspencao:widestring;
  Q:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont,ContGrupos,ContItens,ContDivisao:Integer;
  DataAgendamento:TDateTime;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    try

      if StrToDate(dataReAgendamento,AjustesdeFormato)<trunc(Now) then
      begin
       Mensagens.Adicionar(10246, Self.ClassName, NomeMetodo, []);
       Result := -10246;
       Exit;
      end;
    except
       Mensagens.Adicionar(10248, Self.ClassName, NomeMetodo, [DateToStr(trunc(now))]);
       Result := -10248;
       Exit;
    end;

    Q.Close;
    q.SQL.Text  :=  'SELECT DATA_VISTORIA FROM TAB_VISTORIA WHERE COD_STATUS_VISTORIA = 2 AND COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
    Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    Q.Open;

    if q.IsEmpty then
    begin
      Mensagens.Adicionar(10247, Self.ClassName, NomeMetodo, []);
      Result := -10247;
      Exit;
    end
    else
    begin
      DataAgendamento :=  q.fieldbyname('DATA_VISTORIA').AsDateTime;
    end;
    //Resgatando o CPF do Técnico, ID da propriedade no SISBOV
    q.Close;
    Q.SQL.Clear;
    Q.SQL.Add(' SELECT  TP.NUM_CNPJ_CPF AS NUM_CPF_TECNICO ' +
              '      ,  TPR.COD_ID_PROPRIEDADE_SISBOV ' +
              '      ,  TT.IND_TRANSMISSAO_SISBOV ' +
              ' FROM    TAB_PROPRIEDADE_RURAL TPR ' +
              '      ,  TAB_PESSOA TP ' +
              '      ,  TAB_TECNICO TT ' +
              ' WHERE   TPR.COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL ' +
              '    AND  TP.COD_PESSOA = :COD_TECNICO ' +
              '    AND  TT.COD_PESSOA_TECNICO = TP.COD_PESSOA ');

    Q.ParamByName('cod_tecnico').AsInteger            := CodTecnico;
    Q.ParamByName('cod_propriedade_rural').AsInteger  := CodPropriedadeRural;
    Q.Open;

    if Q.IsEmpty then
    begin
      Mensagens.Adicionar(2297, Self.ClassName, NomeMetodo, []);
      Result := -2297;
      Exit;
    end;

    if Q.FieldByName('cod_id_propriedade_sisbov').IsNull then
    begin
      Mensagens.Adicionar(510, Self.ClassName, NomeMetodo, []);
      Result := -510;
      Exit;
    end;

    if Q.FieldByName('ind_transmissao_sisbov').AsString <> 'S' then
    begin
      Mensagens.Adicionar(2314, Self.ClassName, NomeMetodo, []);
      Result := -2314;
      Exit;
    end;
    IDPropriedadeSISBOV :=  Q.FieldByName('cod_id_propriedade_sisbov').AsInteger;
    CPFTecnico          :=  Q.FieldByName('num_cpf_tecnico').AsString;
    q.Close;

    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Reagendar Vistoria');
      try
        RetornoSISBOV :=  SoapSisbov.reagendarVistoria(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                   IDPropriedadeSISBOV,FormatDateTime('dd/mm/yyyy',StrToDate(dataReAgendamento,AjustesdeFormato)),CPFTecnico,Justificativa);
        if RetornoSISBOV.status <> 0 then
        begin

          try
            Begintran;
            //APAGANDO QUESTIONÁRIO DO AGENDAMENTO ANTERIOR
            q.SQL.Text  :=  'DELETE FROM TAB_VISTORIA_QUESTIONARIO WHERE DATA_VISTORIA=:DATA_VISTORIA AND COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
            Q.ParamByName('DATA_VISTORIA').AsDate            :=  DataAgendamento;
            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger :=  CodPropriedadeRural;
            Q.ExecSQL();
            //APAGANDO VISTORIA
            q.SQL.Text  :=  'DELETE FROM TAB_VISTORIA WHERE DATA_VISTORIA=:DATA_VISTORIA AND COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
            Q.ParamByName('DATA_VISTORIA').AsDate            :=  DataAgendamento;
            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger :=  CodPropriedadeRural;
            Q.ExecSQL();
            //APAGANDO VISTORIA ERAS
            q.SQL.Text  :=  'DELETE '  +
                            ' FROM TAB_VISTORIA_ERAS '  +
                            ' WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL '  +
                            '       AND DTA_VISTORIA_ERAS = :DATA_VISTORIA';

            Q.ParamByName('DATA_VISTORIA').AsDate            :=  DataAgendamento;
            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger :=  CodPropriedadeRural;
            Q.ExecSQL();                          
            //inserindo questionário no banco de dados
            q.SQL.Text  :=  'INSERT INTO TAB_VISTORIA (COD_PROPRIEDADE_RURAL,DATA_VISTORIA,COD_PESSOA_TECNICO,COD_ID_TRANSACAO_SISBOV) VALUES'+
                            '(:COD_PROPRIEDADE_RURAL,:DATA_VISTORIA,:COD_PESSOA_TECNICO,:COD_ID_TRANSACAO_SISBOV)';
            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
            Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataReAgendamento,AjustesdeFormato);
            Q.ParamByName('COD_PESSOA_TECNICO').AsInteger       :=  CodTecnico;
            Q.ParamByName('COD_ID_TRANSACAO_SISBOV').AsInteger  :=  RetornoSISBOV.idTransacao;
            Q.ExecSQL();

            //inserindo dados na tabela de vistoria ERAS usado na geração do relatório de futuras vistorias
            Q.sql.text  :=  'INSERT INTO TAB_VISTORIA_ERAS '  +
                            '   SELECT COD_PROPRIEDADE_RURAL, COD_PESSOA_TECNICO, '  +
                            '          (SELECT MAX (COD_VISTORIA_ERAS) + 1 '  +
                            '             FROM TAB_VISTORIA_ERAS) COD_VISTORIA_ERAS, DATA_VISTORIA, '  +
                            '          ''S'' AS IND_TRANSMISSAO_SISBOV, COD_ID_TRANSACAO_SISBOV '  +
                            '     FROM TAB_VISTORIA '  +
                            '    WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL '  +
                            '      AND DATA_VISTORIA = (SELECT MAX (DATA_VISTORIA) '  +
                            '                             FROM TAB_VISTORIA '  +
                            '                            WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL)';

            Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
            Q.ExecSQL();

            Q.SQL.Text  :=  'INSERT INTO TAB_VISTORIA_QUESTIONARIO(COD_PROPRIEDADE_RURAL,DATA_VISTORIA,COD_ITEM_SISBOV,DESCRICAO_ITEM,TIPO_ITEM,ORDEM_GRUPO,NOME_GRUPO,ORDEM_ITEM) VALUES'+
                            '(:COD_PROPRIEDADE_RURAL,:DATA_VISTORIA,:COD_ITEM_SISBOV,:DESCRICAO_ITEM,:TIPO_ITEM,:ORDEM_GRUPO,:NOME_GRUPO,:ORDEM_ITEM)';
            for ContGrupos := 0 to High(RetornoSISBOV.grupos) do
            begin
              for ContItens :=  0 to High(RetornoSISBOV.grupos[ContGrupos].itemGrupo) do
              begin
                Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataReAgendamento,AjustesdeFormato);
                Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].idItem;
                Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].descricaoItem;
                Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].tipoItem;
                Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].ordemItem;
                Q.ExecSQL();
              end;

              for ContDivisao :=  0 to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo) do
              begin
                for ContItens := 0  to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao) do
                begin
                  Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                  Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataReAgendamento,AjustesdeFormato);
                  Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].idItem;
                  Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].descricaoItem;
                  Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].tipoItem;
                  Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                  Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                  Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].ordemItem;
                  Q.ExecSQL();
                end;
              end;
            end;
            Commit;
            result  :=  0;
          except
            on E: Exception do
            begin
              Rollback;
              Mensagens.Adicionar(10244, Self.ClassName, NomeMetodo, [e.Message]);
              Result := -10244;
            end;
          end;
        end
        else
        begin
          Mensagens.Adicionar(10249, Self.ClassName, NomeMetodo, []);
          Result := -10249;
          exit;
        end;
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Reagendar Vistoria)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Close;
    q.Free;
  end;
end;
//------------------------------------------------------------------------------
function TIntPropriedadesRurais.LancarVistoria(
  const CodPropriedadeRural: integer;
  const dataAgendamento: WideString): integer;
const
  NomeMetodo: String  = 'lancarVistoria';
var
  SoapSisbov: THTTPReqResp;
  Conectado: boolean;
  RetornoSISBOV:RetornoWsSISBOV;
  StatusSuspencao:widestring;
  Q:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont:Integer;
  respostas:ArrayOf_tns5_CheckListItemRespostaDTO;
  NomeArquivoENV: string;
  NomeArquivoRET: string;
  XMLDoc: TXMLDocument;
  XMLDocRetorno: IXMLDocument;
  body,envelope,resposta,INodeRetorno:IXMLNode;
  RetornoXMLSisbov: TStringStream;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    q.SQL.Text  :=  'SELECT P.NUM_CNPJ_CPF, '+
                    'A.DATA_VISTORIA, '+
                    'R.COD_ID_PROPRIEDADE_SISBOV, '+
                    'P.NOM_PESSOA, '+
                    'B.COD_ITEM_SISBOV, '+
                    'B.DESCRICAO_ITEM, '+
                    'B.TIPO_ITEM, '+
                    'B.RESPOSTA_ITEM, '+
                    'B.CONFORMIDADE_ITEM '+
                    'FROM TAB_VISTORIA A, '+
                    'TAB_VISTORIA_QUESTIONARIO B, '+
                    'TAB_PESSOA P, '+
                    'TAB_TECNICO T, '+
                    'TAB_PROPRIEDADE_RURAL R '+
                    'WHERE A.COD_PESSOA_TECNICO = T.COD_PESSOA_TECNICO '+
                    'AND A.COD_PROPRIEDADE_RURAL = B.COD_PROPRIEDADE_RURAL '+
                    'AND A.DATA_VISTORIA = B.DATA_VISTORIA '+
                    'AND A.COD_PROPRIEDADE_RURAL = R.COD_PROPRIEDADE_RURAL '+
                    'AND T.COD_PESSOA_TECNICO = P.COD_PESSOA '+
	                  'AND A.DATA_VISTORIA=:DATA_VISTORIA '+
                    'AND A.COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL ';//  AND B.ENVIADO_PARA_SISBOV=:ENVIADO_PARA_SISBOV ';

    q.ParamByName('cod_propriedade_rural').AsInteger  :=  CodPropriedadeRural;
    q.ParamByName('data_vistoria').AsDate             :=  StrToDate(dataAgendamento);
//    q.ParamByName('ENVIADO_PARA_SISBOV').AsString     :=  'N';
    q.Open;
    if q.IsEmpty then
    begin
      Mensagens.Adicionar(10250, Self.ClassName, NomeMetodo, []);
      Result := -10250;
      Exit;
    end;
    //validando se a data da vistoria é maior ou igual a data atual
    if  trunc(Now) < StrToDate(dataAgendamento) then
    begin
      Mensagens.Adicionar(10254, Self.ClassName, NomeMetodo, [q.FieldByName('DATA_VISTORIA').AsString]);
      Result := -10254;
      Exit;
    end;
    cont  :=  0;
    q.First;
    //validando as respostas
    while not q.Eof do
    begin
      if (q.FieldByName('RESPOSTA_ITEM').IsNull) or (q.FieldByName('CONFORMIDADE_ITEM').IsNull) then
      begin
        Mensagens.Adicionar(10251, Self.ClassName, NomeMetodo, []);
        Result := -10251;
        Exit;
      end
      else
      begin
        cont  :=  cont  + 1;
      end;
      q.Next;
    end;

    SetLength(respostas,cont);
    q.First;
    cont  :=  0;
    //inserindo o array de respostas
    while not q.Eof do
    begin
      respostas[cont]               :=  CheckListItemRespostaDTO.Create;
      respostas[cont].conformidade  :=  q.FieldByName('CONFORMIDADE_ITEM').AsString;
      respostas[cont].resposta      :=  q.FieldByName('RESPOSTA_ITEM').AsString;
      respostas[cont].id            :=  q.FieldByName('COD_ITEM_SISBOV').AsInteger;
      cont  :=  cont  + 1;
      q.Next;
    end;
    SoapSisbov := THTTPReqResp.Create(nil);
    RetornoSISBOV  :=  RetornoWsSISBOV.Create;
    try
      //SoapSisbov.Inicializar(Conexao, Mensagens);
      //Conectado := SoapSisbov.Conectado('Lancar Vistoria');
      try
        q.First;
        IDPropriedadeSISBOV :=  q.fieldbyname('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
        CPFTecnico          :=  q.fieldbyname('NUM_CNPJ_CPF').AsString;

        q.Close;
        q.SQL.Text  :=   'UPDATE TAB_VISTORIA_QUESTIONARIO SET ENVIADO_PARA_SISBOV=:ENVIADO_PARA_SISBOV '+
                         'WHERE COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL AND DATA_VISTORIA=:DATA_VISTORIA'; { AND COD_ITEM_SISBOV=:COD_ITEM_SISBOV';}

      //*************************************************************************************************************************************************
      //Geração do arquivo XML
      //*************************************************************************************************************************************************
        XMLDoc  := TXMLDocument.Create(nil);
        //NomeArquivoENV := ValorParametro(16) + '\' + Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaSistema) + '_ENV_' + NomeMetodo + '.xml';
        NomeArquivoENV  :=  ValorParametro(16)   + '\' +
                            FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
                            FormatDateTime('mm', Conexao.DtaSistema)   + '\' +
                            FormatDateTime('dd', Conexao.DtaSistema)   + '\' +
                            Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_ENV_' + NomeMetodo + '.xml';

        NomeArquivoRET  :=  ValorParametro(16)   + '\' +
                            FormatDateTime('yyyy', Conexao.DtaSistema) + '\' +
                            FormatDateTime('mm', Conexao.DtaSistema)   + '\' +
                            FormatDateTime('dd', Conexao.DtaSistema)   + '\' +
                            Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', Conexao.DtaSistema) + '_RET_' + NomeMetodo + '.xml';

  //      NomeArquivoRET := ValorParametro(16) + '\' + Conexao.NomUsuario + '_' + FormatDateTime('yyyymmddhhnnsszzz', DtaSistema) + '_RET_' + NomeMetodo + '.xml';
        try
          //Cabecalho
          XMLDoc.Active :=  true;
          XMLDoc.Version :=  '1.0';
          envelope :=  XMLDoc.AddChild('SOAP-ENV:Envelope','http://schemas.xmlsoap.org/soap/envelope/');
          envelope.Attributes['xmlns:xsd']   :=  'http://www.w3.org/2001/XMLSchema';
          envelope.Attributes['xmlns:xsi']   :=  'http://www.w3.org/2001/XMLSchema-instance';
          //corpo
          body  :=  envelope.AddChild('SOAP-ENV:Body').AddChild(NomeMetodo,'http://servicosWeb.sisbov.mapa.gov.br');
          body.AddChild('usuario').Text         :=  Descriptografar(ValorParametro(118));
          body.AddChild('senha').Text           :=  Descriptografar(ValorParametro(119));
          body.AddChild('idPropriedade').Text   :=  inttostr(IDPropriedadeSISBOV);
          body.AddChild('dataVistoria').Text    :=  dataAgendamento;
          for cont := 0 to High(respostas) do
          begin
            resposta                                :=  body.AddChild('resposta'{,'http://dto.checklist.certificado.negocio.sisbov.mapa.gov.br'});
            resposta.AddChild('conformidade').Text  :=  respostas[cont].conformidade;
            resposta.AddChild('id').Text            :=  inttostr(respostas[cont].id);
            resposta.AddChild('resposta').Text      :=  respostas[cont].resposta;

            {RetornoSISBOV :=  SoapSisbov.lancarVistoria(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                        IDPropriedadeSISBOV,dataAgendamento,CPFTecnico,respostas[cont]);
            if RetornoSISBOV.status = 0 then
            begin
              Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Lançar vistoria no SISBOV']);
              Result := -CERRO_GERAL;
              exit;
            end;
            q.ParamByName('ENVIADO_PARA_SISBOV').AsString     :=  'S';
            q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
            q.ParamByName('DATA_VISTORIA').AsDate             :=  strtodate(DataAgendamento);
            q.ParamByName('COD_ITEM_SISBOV').AsInteger        :=  respostas[cont].id;
            BeginTran;
            q.ExecSQL();
            commit;}
          end;
          if not ForceDirectories(ExtractFileDir(NomeArquivoENV)) then
          begin
            Mensagens.Adicionar(1079, Self.ClassName, NomeMetodo, [ExtractFileDir(NomeArquivoENV)]);
            Exit;
          end;
          //realizando o envio "na mão" do xml para o SISBOV
          SoapSisbov.URL := ValorParametro(117);
          SoapSisbov.Proxy := ValorParametro(120);
          SoapSisbov.UserName:= Descriptografar(ValorParametro(121));
          SoapSisbov.Password:= Descriptografar(ValorParametro(122));
          SoapSisbov.MaxSinglePostSize := $1000000;
          XMLDoc.SaveToFile(NomeArquivoENV);


          RetornoXMLSisbov := TStringStream.Create('');
          try
            SoapSisbov.Execute(XMLDoc.XML.Text, RetornoXMLSisbov);
            XMLDocRetorno    := LoadXMLData(RetornoXMLSisbov.DataString);
            XMLDocRetorno.SaveToFile(NomeArquivoRET);
            //pegando o retorno
            INodeRetorno  := XMLDocRetorno.DocumentElement.ChildNodes.First.ChildNodes.First.ChildNodes.First;


            RetornoSisbov.ambiente    := INodeRetorno.ChildNodes.FindNode('ambiente').Text;
            RetornoSisbov.erroBanco   := INodeRetorno.ChildNodes.FindNode('erroBanco').Text;
            RetornoSisbov.idTransacao := StrToInt64(INodeRetorno.ChildNodes.FindNode('idTransacao').Text);// StrToInt64(INodeRetorno.ChildNodes['idTransacao'].Text);
            RetornoSisbov.status      := Strtoint(INodeRetorno.ChildNodes.FindNode('status').Text); //StrToInt(INodeRetorno.ChildNodes['status'].Text);
            RetornoSisbov.trace       := INodeRetorno.ChildNodes.FindNode('trace').Text; //INodeRetorno.ChildNodes['trace'].Text;
            if RetornoSISBOV.status = 0 then
            begin
              Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Lançar vistoria no SISBOV']);
              Result := -CERRO_GERAL;
              exit;
            end;
            q.ParamByName('ENVIADO_PARA_SISBOV').AsString     :=  'S';
            q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
            q.ParamByName('DATA_VISTORIA').AsDate             :=  strtodate(DataAgendamento);
            BeginTran;
            q.ExecSQL();
            commit;
            Mensagens.Adicionar(10261, Self.ClassName, NomeMetodo, []);
            result  :=  1;
          finally
            RetornoXMLSisbov.Free;
            RetornoSISBOV.Free;
          end;
        finally
          xmldoc  :=  nil;
        end;
      //*************************************************************************************************************************************************
      //Fim Geração do Arquivo XML
      //*************************************************************************************************************************************************
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
          Rollback;
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Lançar Vistoria)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      for cont := 0 to High(respostas) do
      begin
        respostas[cont].Free;
      end;
      SoapSisbov.Free;
    end;

  finally
    q.Close;
    q.Free;
  end;
end;

function TIntPropriedadesRurais.FinalizarVistoria(
  cod_propriedade_rural: integer; cancelar: boolean): integer;
const
  NomeMetodo: String  = 'FinalizarVistoria';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoWsSISBOV;
  StatusSuspencao:widestring;
  Q,Q2:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont:Integer;
  respostas:ArrayOf_tns5_CheckListItemRespostaDTO;
  DataAgendamento:string;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q  := THerdomQuery.Create(Conexao, nil);
  Q2 := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    q.SQL.Text  :=  'SELECT A.DATA_VISTORIA,R.COD_ID_PROPRIEDADE_SISBOV '+
                    'FROM TAB_VISTORIA A, TAB_PROPRIEDADE_RURAL R       '+
                    'WHERE A.COD_PROPRIEDADE_RURAL=R.COD_PROPRIEDADE_RURAL '+
                    'AND A.COD_STATUS_VISTORIA=2 AND A.COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
    q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  cod_propriedade_rural;
    q.Open;
    if q.IsEmpty then
    begin
      Mensagens.Adicionar(10252, Self.ClassName, NomeMetodo, []);
      Result := -10252;
      Exit;
    end;
    SoapSisbov := TIntSoapSisbov.Create;
    //terminar essa rotina
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      IDPropriedadeSISBOV :=  q.fieldbyname('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
      DataAgendamento     :=  FormatDateTime('dd/mm/yyyy',q.fieldbyname('DATA_VISTORIA').AsDateTime);


      try
        Conectado := SoapSisbov.Conectado('Finalizar Vistoria');
        RetornoSISBOV :=  SoapSisbov.finalizarVistoria(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                       IDPropriedadeSISBOV,DataAgendamento,cancelar);
        if RetornoSISBOV.status = 0 then
        begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Finalizar vistoria no SISBOV']);
          Result := -CERRO_GERAL;
          exit;
        end;

        q.Close;
        q.SQL.Text  :=  'UPDATE TAB_VISTORIA SET COD_STATUS_VISTORIA=:COD_STATUS_VISTORIA, DATA_FINALIZACAO_VISTORIA=CURRENT_TIMESTAMP '+
                        'WHERE COD_PROPRIEDADE_RURAL =:COD_PROPRIEDADE_RURAL AND DATA_VISTORIA=:DATA_VISTORIA';
        if cancelar then
          q.ParamByName('cod_status_vistoria').AsInteger  :=  1
        else
          q.ParamByName('cod_status_vistoria').AsInteger  :=  0;

        q.ParamByName('cod_propriedade_rural').AsInteger  := cod_propriedade_rural;
        q.ParamByName('data_vistoria').AsDate  := strtodate(DataAgendamento,AjustesdeFormato);

        q2.SQL.Text  :=  'UPDATE TAB_PROPRIEDADE_RURAL SET DTA_INICIO_PERIODO_AJUSTE_REBANHO = NULL '+
                        'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL';
        q2.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger              :=  cod_propriedade_rural;

        Begintran;
        q.ExecSQL();
        if not cancelar then
          q2.ExecSQL();
        commit;
        result  :=  0;
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
          rollback;
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Finalizar Vistoria)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Close;
    q.Free;
    q2.Free;
  end;
end;

function TIntPropriedadesRurais.EmitirParecerVistoria(CodPropriedadeRural: integer; const parecer: widestring): integer;
const
  NomeMetodo: String  = 'EmitirParecerVistoria';
var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoWsSISBOV;
  StatusSuspencao:widestring;
  Q:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont:Integer;
  DataAgendamento:string;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    q.SQL.Text  :=  'SELECT 		A.DATA_VISTORIA,P.NUM_CNPJ_CPF,PR.COD_ID_PROPRIEDADE_SISBOV, '+
              			'SUM(CASE WHEN B.ENVIADO_PARA_SISBOV = ''S'' THEN 1 ' +
                    'ELSE  0 END) ENVIADOS,                             ' +
                    'SUM(CASE WHEN B.ENVIADO_PARA_SISBOV = ''N'' THEN 1  '+
                    'ELSE  0 END) NAO_ENVIADOS '+
                    'FROM TAB_VISTORIA A, TAB_VISTORIA_QUESTIONARIO B, TAB_PESSOA P, '+
                    'TAB_PROPRIEDADE_RURAL PR '+
                    'WHERE A.COD_PROPRIEDADE_RURAL=B.COD_PROPRIEDADE_RURAL '+
                    'AND A.DATA_VISTORIA=B.DATA_VISTORIA                   '+
                    'AND A.COD_PESSOA_TECNICO = P.COD_PESSOA '+
                    'AND A.COD_STATUS_VISTORIA=2 '+
                    'AND A.COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL '+
                    'AND PR.COD_PROPRIEDADE_RURAL=A.COD_PROPRIEDADE_RURAL '+
                    'GROUP BY A.DATA_VISTORIA,P.NUM_CNPJ_CPF,PR.COD_ID_PROPRIEDADE_SISBOV ';
    Q.ParamByName('cod_propriedade_rural').AsInteger  :=  CodPropriedadeRural;
    Q.Open;
    //VALIDANDO SE PODE ENVIAR O PARECER DA VISTORIA
    if  q.IsEmpty then
    begin
      Mensagens.Adicionar(10252, Self.ClassName, NomeMetodo, []);
      Result := -10252;
      Exit;
    end;
    //validando se a data da vistoria é maior ou igual a data atual
    if trunc(Now)<trunc(q.fieldbyname('DATA_VISTORIA').AsDateTime) then
    begin
      Mensagens.Adicionar(10255, Self.ClassName, NomeMetodo, [q.FieldByName('DATA_VISTORIA').AsString]);
      Result := -10255;
      Exit;
    end;
    if (q.FieldByName('nao_enviados').IsNull) or (q.FieldByName('nao_enviados').AsInteger>0) then
    begin
      Mensagens.Adicionar(10253, Self.ClassName, NomeMetodo, []);
      Result := -10253;
      Exit;
    end;
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      IDPropriedadeSISBOV :=  q.fieldbyname('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
      DataAgendamento     :=  FormatDateTime('dd/mm/yyyy',q.fieldbyname('DATA_VISTORIA').AsDateTime);
      q.Close;
      //PEGANDO O RESPONSAVEL TECNICO DA CERTIFICADORA
      q.SQL.Text          :=  'SELECT NUM_CNPJ_CPF FROM TAB_PESSOA WHERE COD_PESSOA = :COD_PESSOA';
      Q.ParamByName('COD_PESSOA').AsInteger :=  STRTOINT(ValorParametro(65));
      Q.Open;

      CPFTecnico          :=  q.fieldbyname('NUM_CNPJ_CPF').AsString;

      try
        Conectado      := SoapSisbov.Conectado('Emitir Parecer Vistoria');
        RetornoSISBOV  :=  SoapSisbov.emitirParecerVistoriaRT(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                       IDPropriedadeSISBOV,DataAgendamento,parecer,CPFTecnico);
        if RetornoSISBOV.status = 0 then
        begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Transmitir Parecer para o SISBOV']);
          Result := -CERRO_GERAL;
          exit;
        end;
        q.Close;
        q.SQL.Text  :=  'UPDATE TAB_VISTORIA SET PARECER = :PARECER WHERE COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL AND DATA_VISTORIA=:DATA_VISTORIA';
        Q.ParamByName('PARECER').AsString :=  PARECER;
        Q.ParamByName('cod_propriedade_rural').AsInteger  :=  CodPropriedadeRural;
        q.ParamByName('DATA_VISTORIA').AsDate             :=  strtodate(DataAgendamento);
        BeginTran;
        Q.ExecSQL();
        Commit;
        result  :=  1;
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
          rollback;
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Finalizar Vistoria)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Close;
    q.Free;
  end;
end;

function TIntPropriedadesRurais.ConsultarVistorias(
  CodPropriedadeRural: integer; DataVistoria:widestring): integer;
begin
  if QueryListaVistorias = nil then
    QueryListaVistorias :=  THerdomQuery.Create(Conexao, nil);

  QueryListaVistorias.Close;
  QueryListaVistorias.SQL.Text  :=  'SELECT A.COD_ID_TRANSACAO_SISBOV, '+
                                    'A.DATA_VISTORIA,                   '+
                                    'A.COD_STATUS_VISTORIA,               '+
                                    'S.DESCRICAO DESCRICAO_STATUS_VISTORIA, '+
                                    'A.COD_PESSOA_TECNICO,                  '+
                                    'P.NOM_PESSOA NOM_TECNICO,              '+
                                    'A.DATA_FINALIZACAO_VISTORIA,           '+
                                    'A.COD_PROPRIEDADE_RURAL,               '+
                                    'R.NOM_PROPRIEDADE_RURAL,               '+
                                    'A.PARECER                              '+
                                    'FROM TAB_VISTORIA A,                   '+
                                    'TAB_VISTORIA_STATUS S,                 '+
                                    'TAB_PESSOA P,                          '+
                                    'TAB_PROPRIEDADE_RURAL R                '+
                                    'WHERE A.COD_STATUS_VISTORIA = S.COD_STATUS_VISTORIA '+
                                    'AND A.COD_PESSOA_TECNICO = P.COD_PESSOA             '+
                                    'AND A.COD_PROPRIEDADE_RURAL = R.COD_PROPRIEDADE_RURAL '+
                                    'AND A.COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL ';
  if DataVistoria<>'' then
  begin
    QueryListaVistorias.SQL.Add('and a.data_vistoria=:data_vistoria');
    QueryListaVistorias.ParamByName('data_vistoria').AsDate :=  StrToDate(DataVistoria);
  end;
  QueryListaVistorias.ParamByName('cod_propriedade_rural').AsInteger  :=  CodPropriedadeRural;
  QueryListaVistorias.Open;
  result  :=  1;
end;

function TIntPropriedadesRurais.ProximaVistoria: integer;
begin
  if QueryListaVistorias = nil then
    exit;
  if not QueryListaVistorias.IsEmpty and not QueryListaVistorias.Eof then
    QueryListaVistorias.Next;

end;

function TIntPropriedadesRurais.VistoriaEof: Boolean;
begin
  if QueryListaVistorias = nil then
    exit;
  if QueryListaVistorias.IsEmpty then
    result  :=  true
  else
    Result  :=  QueryListaVistorias.Eof;
end;

function TIntPropriedadesRurais.ValorCampoVistoria(
  const NomeCampo: widestring): widestring;
begin
  if QueryListaVistorias = nil then
    exit;
  if not QueryListaVistorias.IsEmpty and not QueryListaVistorias.Eof then
  begin
    try
      result  :=  QueryListaVistorias.fieldbyname(NomeCampo).AsString;
    except
      result  :=  '#Campo Não encontrado';
    end;
  end
  else
    result  :=  '';

end;

function TIntPropriedadesRurais.IrAPrimeiraVistoria: integer;
begin
  if QueryListaVistorias = nil then
    exit;
  if not QueryListaVistorias.IsEmpty  then
    QueryListaVistorias.First;
end;

function TIntPropriedadesRurais.ConsultarQuestionarioVistoria(
  CodPropriedadeRural: integer; DataVistoria: widestring): integer;
begin
  if QueryQuestionarioVistoria  = nil then
    QueryQuestionarioVistoria :=  THerdomQuery.Create(conexao,nil);
  QueryQuestionarioVistoria.Close;
  QueryQuestionarioVistoria.SQL.Text  :=  'SELECT P.NUM_CNPJ_CPF, '+
                                    'A.DATA_VISTORIA, '+
                                    'R.COD_ID_PROPRIEDADE_SISBOV, '+
                                    'P.NOM_PESSOA, '+
                                    'B.COD_ITEM_SISBOV, '+
                                    'B.DESCRICAO_ITEM, '+
                                    'B.TIPO_ITEM, '+
                                    'B.RESPOSTA_ITEM, '+
                                    'coalesce(b.Conformidade_item,''0'') Conformidade_item '+
                                    'FROM TAB_VISTORIA A, '+
                                    'TAB_VISTORIA_QUESTIONARIO B, '+
                                    'TAB_PESSOA P, '+
                                    'TAB_TECNICO T, '+
                                    'TAB_PROPRIEDADE_RURAL R '+
                                    'WHERE A.COD_PESSOA_TECNICO = T.COD_PESSOA_TECNICO '+
                                    'AND A.COD_PROPRIEDADE_RURAL = B.COD_PROPRIEDADE_RURAL '+
                                    'AND A.DATA_VISTORIA = B.DATA_VISTORIA '+
                                    'AND A.COD_PROPRIEDADE_RURAL = R.COD_PROPRIEDADE_RURAL '+
                                    'AND T.COD_PESSOA_TECNICO = P.COD_PESSOA '+
                                    'AND A.DATA_VISTORIA=:DATA_VISTORIA '+
                                    'AND A.COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL '+
                                    'ORDER BY B.ORDEM_GRUPO,B.ORDEM_ITEM';

  QueryQuestionarioVistoria.ParamByName('DATA_VISTORIA').AsDate             :=  StrToDate(DataVistoria);
  QueryQuestionarioVistoria.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
  QueryQuestionarioVistoria.Open;
  result  :=  1;
end;

function TIntPropriedadesRurais.IrAoPrimeiroQuestionarioVistoria: integer;
begin
  if QueryQuestionarioVistoria = nil then
    exit;
  if not QueryQuestionarioVistoria.IsEmpty  then
    QueryQuestionarioVistoria.First;
end;

function TIntPropriedadesRurais.ProximoQuestionarioVistoria: integer;
begin
  if QueryQuestionarioVistoria = nil then
    exit;
  if not QueryQuestionarioVistoria.IsEmpty and not QueryQuestionarioVistoria.Eof then
    QueryQuestionarioVistoria.Next;
end;

function TIntPropriedadesRurais.QuestionarioVistoriaEOF: boolean;
begin
  if QueryQuestionarioVistoria = nil then
    exit;
  if QueryQuestionarioVistoria.IsEmpty then
    result  :=  true
  else
    Result  :=  QueryQuestionarioVistoria.Eof;
end;

function TIntPropriedadesRurais.ValorCampoQuestionarioVistoria(
  const NomeCampo: widestring): widestring;
begin
  if QueryQuestionarioVistoria = nil then
    exit;
  if not QueryQuestionarioVistoria.IsEmpty and not QueryQuestionarioVistoria.Eof then
  begin
    try
      result  :=  QueryQuestionarioVistoria.fieldbyname(NomeCampo).AsString;
    except
      result  :=  '#Campo Não encontrado';
    end;
  end
  else
    result  :=  '';
end;

function TIntPropriedadesRurais.GravarRespostaQuestionario(
  CodPropriedadeRural: integer; const DataVistoria: widestring;
  CodItemSISBOV: integer; Resposta, Conformidade: widestring): integer;
const
  NomeMetodo: String  = 'GravarRespostaQuestionario';
var
  Q:THerdomQuery;
begin
  Result := -1;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
      q.SQL.Text  :=  'UPDATE TAB_VISTORIA_QUESTIONARIO SET RESPOSTA_ITEM=:RESPOSTA_ITEM,CONFORMIDADE_ITEM=:CONFORMIDADE_ITEM '+
                      'WHERE COD_ITEM_SISBOV=:COD_ITEM_SISBOV AND COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL AND DATA_VISTORIA=:DATA_VISTORIA';
    try
      q.ParamByName('CONFORMIDADE_ITEM').DataType :=  ftString;
      q.ParamByName('RESPOSTA_ITEM').DataType     :=  ftString;
      if Length(trim(Resposta)) = 0 then
        q.ParamByName('RESPOSTA_ITEM').Value           :=  null
      else
        q.ParamByName('RESPOSTA_ITEM').value           :=  Resposta;
      if (Conformidade = 'C') or (Conformidade = 'N')  then
        q.ParamByName('CONFORMIDADE_ITEM').AsString     :=  Conformidade
      else
        q.ParamByName('CONFORMIDADE_ITEM').Value        :=  null;
      q.ParamByName('COD_ITEM_SISBOV').AsInteger        :=  CodItemSISBOV;
      q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
      q.ParamByName('DATA_VISTORIA').AsDate             :=  StrToDate(DataVistoria);

      Begintran;
      q.ExecSQL();
      Commit;
      result  :=  0;
    except
      Rollback;
      result  :=  -1;
    end;
  finally
    q.Free;
  end;
end;
//------------------------------------------------------------------------------
//Essa Rotina está obsoleta, usar a informarPeriodoDeConfinamento2
//------------------------------------------------------------------------------
function TIntPropriedadesRurais.InformarPeriodoDeConfinamento(
  CodPropriedadeRural: integer; const DataInicioConfinamento,
  DataFimConfinamento: widestring; cancelar: wordbool): integer;
const
  NomeMetodo: String  = 'InformarPeriodoDeConfinamento';
var
  Q:THerdomQuery;
  RetornoSISBOV:RetornoWsSISBOV;
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
begin
  result          :=  -1;
  RetornoSisbov   :=  nil;
  q               :=  therdomquery.Create(Conexao,nil);
  try
    q.SQL.Text  :=  'SELECT DTA_INICIO_CONFINAMENTO,DTA_FIM_CONFINAMENTO,COD_TIPO_PROPRIEDADE_RURAL,COD_ID_PROPRIEDADE_SISBOV '+
                    'FROM TAB_PROPRIEDADE_RURAL '+
                    'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL';
    q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    q.Open;
    if q.IsEmpty  then
    begin
      Mensagens.Adicionar(327, Self.ClassName, NomeMetodo, []);
      Result := -327;

      Exit;
    end;
    if q.FieldByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger  <>  3 then
    begin
      Mensagens.Adicionar(10256, Self.ClassName, NomeMetodo, []);
      Result := -10256;
      Exit;
    end;
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado     :=  SoapSisbov.Conectado('Informar Periodo de Confinamento');
      RetornoSISBOV :=  SoapSisbov.informarPeriodoConfinamento(Descriptografar(ValorParametro(118)),
                                                               Descriptografar(ValorParametro(119)),
                                                               Q.FIELDBYNAME('COD_ID_PROPRIEDADE_SISBOV').AsInteger,
                                                               DataInicioConfinamento,DataFimConfinamento,false);
      if RetornoSISBOV.status = 0 then
      begin
        Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Informar Período de Confinamento para o SISBOV']);
        Result := -CERRO_GERAL;
        exit;
      end;
      q.Close;
      q.SQL.Text  :=  'UPDATE TAB_PROPRIEDADE_RURAL '+
                      'SET DTA_INICIO_CONFINAMENTO = :DTA_INICIO_CONFINAMENTO, '+
                      'DTA_FIM_CONFINAMENTO        = :DTA_FIM_CONFINAMENTO '+
                      'WHERE COD_PROPRIEDADE_RURAL  = :COD_PROPRIEDADE_RURAL';

      Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger :=  CodPropriedadeRural;
      Q.ParamByName('DTA_INICIO_CONFINAMENTO').AsDate  :=  StrToDate(DataInicioConfinamento);
      Q.ParamByName('DTA_FIM_CONFINAMENTO').AsDate     :=  StrToDate(DataFimConfinamento);

      Begintran;
      try
        Q.ExecSQL();
        Commit;
      except
        on E: Exception do
        begin
          rollback;
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Informar Período de Confinamento)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Free;
  end;
end;

function TIntPropriedadesRurais.informarPeriodoDeConfinamento2(
  CodpropriedadeRural: integer; const DataInicioConfinamento,
  DataFimConfinamento: WideString;Cancelar: boolean ): integer;
const
  NomeMetodo: String  = 'InformarPeriodoDeConfinamento';
var
  Q:THerdomQuery;
  RetornoSISBOV:RetornoWsSISBOV;
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  IdPropriedade:integer;
begin
  result          :=  -1;
  RetornoSisbov   :=  nil;
  q               :=  therdomquery.Create(Conexao,nil);
  try
    q.SQL.Text  :=  'SELECT DTA_INICIO_CONFINAMENTO,DTA_FIM_CONFINAMENTO,COD_TIPO_PROPRIEDADE_RURAL,COD_ID_PROPRIEDADE_SISBOV '+
                    'FROM TAB_PROPRIEDADE_RURAL '+
                    'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL';
    q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    q.Open;
    if q.IsEmpty  then
    begin
      Mensagens.Adicionar(327, Self.ClassName, NomeMetodo, []);
      Result := -327;
      Exit;
    end;
    if q.FieldByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger  <>  3 then
    begin
      Mensagens.Adicionar(10256, Self.ClassName, NomeMetodo, []);
      Result := -10256;
      Exit;
    end;
    IdPropriedade :=  Q.FIELDBYNAME('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
//    if (q.FieldByName('dta_inicio_confinamento').IsNull) or (q.FieldByName('dta_fim_confinamento').IsNull) then
      Cancelar  :=  false;
  //  else
   //   cancelar  :=  true;

    q.Close;
          
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado     :=  SoapSisbov.Conectado('Informar Periodo Confinamento');

      RetornoSISBOV :=  SoapSisbov.informarPeriodoConfinamento(Descriptografar(ValorParametro(118)),
                                                               Descriptografar(ValorParametro(119)),
                                                               IdPropriedade,
                                                               DataInicioConfinamento,DataFimConfinamento,Cancelar);
     if RetornoSISBOV.status = 0 then
      begin
        Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Informar Período de Confinamento para o SISBOV']);
        Result := -CERRO_GERAL;
        exit;
      end;
      q.SQL.Text  :=  'UPDATE TAB_PROPRIEDADE_RURAL '+
                      'SET DTA_INICIO_CONFINAMENTO = :DTA_INICIO_CONFINAMENTO, '+
                      'DTA_FIM_CONFINAMENTO        = :DTA_FIM_CONFINAMENTO '+
                      'WHERE COD_PROPRIEDADE_RURAL  = :COD_PROPRIEDADE_RURAL';


      Q.ParamByName('COD_PROPRIEDADE_RURAL').DataType   :=  ftInteger;
      Q.ParamByName('DTA_INICIO_CONFINAMENTO').DataType :=  ftDate;
      Q.ParamByName('DTA_FIM_CONFINAMENTO').DataType    :=  ftDate;

      Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;

      if not Cancelar then
      begin
        Q.ParamByName('DTA_INICIO_CONFINAMENTO').Value    :=  StrToDate(DataInicioConfinamento);
        Q.ParamByName('DTA_FIM_CONFINAMENTO').value       :=  StrToDate(DataFimConfinamento);
      end
      else
      begin
        Q.ParamByName('DTA_INICIO_CONFINAMENTO').Value    :=  NULL;
        Q.ParamByName('DTA_FIM_CONFINAMENTO').value       :=  NULL;
      end;

      Begintran;
      try
        Q.ExecSQL();
        Commit;
        result  :=  0;
      except
        on E: Exception do
        begin
          rollback;
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Informar Período de Confinamento)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    q.Free;
  end;
end;

function TIntPropriedadesRurais.RecuperarCheckList(
  CodPropriedadeRural: integer;
  const dataAgendamento: WideString): integer;
const
  NomeMetodo: String  = 'RecuperarCheckList';

var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoCheckListVistoria;
  Q:THerdomQuery;
  CPFTecnico:string;
  IDPropriedadeSISBOV:integer;
  Cont,ContGrupos,ContItens,ContDivisao:Integer;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    q.SQL.Text  :=  'SELECT COD_ID_PROPRIEDADE_SISBOV FROM TAB_PROPRIEDADE_RURAL WHERE COD_PROPRIEDADE_RURAL=:COD_PROPRIEDADE_RURAL';
    Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    Q.Open;
    if q.IsEmpty then
      exit;
    IDPropriedadeSISBOV :=  q.Fields[0].AsInteger;
    q.Close;
    SoapSisbov := TIntSoapSisbov.Create;
    try
      SoapSisbov.Inicializar(Conexao, Mensagens);
      Conectado := SoapSisbov.Conectado('Recuperar Check List Vistoria');
      try
        RetornoSISBOV :=  SoapSisbov.recuperarCheckListVistoria(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                     IDPropriedadeSISBOV,dataAgendamento);
        if RetornoSISBOV.status <> 0 then
        begin
         //inserindo questionário no banco de dados
            Begintran;
            Q.SQL.Text  :=  'INSERT INTO TAB_VISTORIA_QUESTIONARIO(COD_PROPRIEDADE_RURAL,DATA_VISTORIA,COD_ITEM_SISBOV,DESCRICAO_ITEM,TIPO_ITEM,ORDEM_GRUPO,NOME_GRUPO,ORDEM_ITEM) VALUES'+
                            '(:COD_PROPRIEDADE_RURAL,:DATA_VISTORIA,:COD_ITEM_SISBOV,:DESCRICAO_ITEM,:TIPO_ITEM,:ORDEM_GRUPO,:NOME_GRUPO,:ORDEM_ITEM)';
            for ContGrupos := 0 to High(RetornoSISBOV.grupos) do
            begin
              for ContItens :=  0 to High(RetornoSISBOV.grupos[ContGrupos].itemGrupo) do
              begin
                Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataAgendamento);
                Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].idItem;
                Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].descricaoItem;
                Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].tipoItem;
                Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].itemGrupo[ContItens].ordemItem;
                try
                  Q.ExecSQL();
                except
                end;
              end;
              for ContDivisao :=  0 to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo) do
              begin
                for ContItens := 0  to High(RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao) do
                begin
                  Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger    :=  CodPropriedadeRural;
                  Q.ParamByName('DATA_VISTORIA').AsDate               :=  StrToDate(dataAgendamento);
                  Q.ParamByName('COD_ITEM_SISBOV').AsInteger          :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].idItem;
                  Q.ParamByName('DESCRICAO_ITEM').AsString            :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].descricaoItem;
                  Q.ParamByName('TIPO_ITEM').AsString                 :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].tipoItem;
                  Q.ParamByName('ORDEM_GRUPO').AsInteger              :=  RetornoSISBOV.grupos[ContGrupos].ordemGrupo;
                  Q.ParamByName('NOME_GRUPO').AsString                :=  RetornoSISBOV.grupos[ContGrupos].nomeGrupo;
                  Q.ParamByName('ORDEM_ITEM').AsInteger               :=  RetornoSISBOV.grupos[ContGrupos].divisaoGrupo[ContDivisao].itemdivisao[ContItens].ordemItem;
                  try
                    Q.ExecSQL();
                  except
                  end;
                end;
              end;
            end;
            Commit;
            result  :=  0;
         end
         else
         begin
          Mensagens.Adicionar(10243, Self.ClassName, NomeMetodo, []);
          Result := -10243;
          exit;
         end;
      except
      //Alterar esse codigo de erro para o correto
        on E: Exception do
        begin
        Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Iniciar Vistoria)'+e.Message]);
        Result := -CERRO_GERAL;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    FreeAndNil(q);
  end;
end;

function TIntPropriedadesRurais.InformarAjusteRebanho(
  CodPropriedadeRural: integer): integer;
const
  NomeMetodo: String  = 'InformarAjusteRebanho';

var
  SoapSisbov: TIntSoapSisbov;
  Conectado: boolean;
  RetornoSISBOV:RetornoInformarAjusteRebanho;
  Q:THerdomQuery;
  CPF_CNPJ:string;
  IDPropriedadeSISBOV:integer;
begin
  Result := -1;
  RetornoSisbov   := nil;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    if not Inicializado then
    begin
      RaiseNaoInicializado(NomeMetodo);
      Exit;
    end;
    //consultando os dados da propriedade rural para a chamada da wevservice
    q.sql.text  :=  'SELECT TPR.COD_ID_PROPRIEDADE_SISBOV, '  +
                    '       TP.NUM_CNPJ_CPF '  +
                    'FROM TAB_PROPRIEDADE_RURAL TPR, '  +
                    '     TAB_PESSOA TP '  +
                    'WHERE TPR.COD_PESSOA_PROPRIETARIO = TP.COD_PESSOA '  +
                    '      AND COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL ';

    Q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger  :=  CodPropriedadeRural;
    Q.Open;
    //verifica se encontrou a propriedade
    if q.IsEmpty then
    begin
      Mensagens.Adicionar(327, Self.ClassName, NomeMetodo, []);
      Result := -327;
      exit;
    end;
    SoapSisbov := TIntSoapSisbov.Create;
    try
      //preparando para transmitir os dados para o SISBOV
      IDPropriedadeSISBOV :=  q.Fieldbyname('COD_ID_PROPRIEDADE_SISBOV').AsInteger;
      CPF_CNPJ            :=  q.Fieldbyname('NUM_CNPJ_CPF').AsString;
      //criando objeto de conxao
      SoapSisbov.Inicializar(Conexao, Mensagens);
      //Conectando
      Conectado := SoapSisbov.Conectado('Informar Ajuste de Rebanho');
      try
        //caso seja CPF
        if Length(CPF_CNPJ) = 11 then
          RetornoSISBOV :=  SoapSisbov.informarAjusteRebanho(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                       IDPropriedadeSISBOV,CPF_CNPJ,'')
        else
        //caso seja CNPJ
          RetornoSISBOV :=  SoapSisbov.informarAjusteRebanho(Descriptografar(ValorParametro(118)),Descriptografar(ValorParametro(119)),
                                                       IDPropriedadeSISBOV,'',CPF_CNPJ);

      //O SISBOV retorna 0 quando houve falha na execução da rotina (normalmente erro de regra de negócio)
      if RetornoSISBOV.status = 0 then
      begin
        Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['Falha ao Informar Período de Confinamento para o SISBOV']);
        Result := -CERRO_GERAL;
        exit;
      end
      //se deu certo (<>0) entao.....
      else
      begin
        //atualizando  a data de inicio do periodo de ajuste do rebanho no sistema
        q.SQL.Text  :=  'UPDATE TAB_PROPRIEDADE_RURAL SET DTA_INICIO_PERIODO_AJUSTE_REBANHO = :DTA_INICIO_PERIODO_AJUSTE_REBANHO '+
                        'WHERE COD_PROPRIEDADE_RURAL = :COD_PROPRIEDADE_RURAL';
        q.ParamByName('COD_PROPRIEDADE_RURAL').AsInteger              :=  CodPropriedadeRural;
        q.ParamByName('DTA_INICIO_PERIODO_AJUSTE_REBANHO').AsDate     :=  StrToDate(RetornoSISBOV.dtInicioPeriodo);
        BeginTran;
        try
          q.ExecSQL();
          Commit();
          result  :=  1;
        except
          on E: Exception do
          begin
            Rollback;
            Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Informar Ajuste de Rebanho)'+e.Message]);
            Result := -CERRO_GERAL;
            exit;
          end;
        end;
      end;
      except
        on E: Exception do
        begin
          Mensagens.Adicionar(CERRO_GERAL, Self.ClassName, NomeMetodo, ['(Rotina:Informar Ajuste de Rebanho)'+e.Message]);
          Result := -CERRO_GERAL;
          exit;
        end;
      end;
    finally
      SoapSisbov.Free;
    end;
  finally
    FreeAndNil(q);
  end;
end;

end.

